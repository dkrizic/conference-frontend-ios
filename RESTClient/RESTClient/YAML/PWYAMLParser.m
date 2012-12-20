//
//  PWYAMLParser.m
//  PWFoundation
//
//  Created by Frank Illenberger on 09.12.09.
//  Copyright 2009 ProjectWizards. All rights reserved.
//

#import "PWYAMLParser.h"
#import "PWISODateFormatter.h"
#import "PWErrors.h"
#import "NSString-PWExtensions.h"
#import "yaml.h"

@implementation PWYAMLParser
{
    NSDateFormatter*    isoDateTimeZoneFormatter_;
    PWISODateFormatter* isoDateTimeFormatter_;
    NSDateFormatter*    spacedDateTimeFormatterWithSeconds_;
    NSDateFormatter*    spacedDateTimeFormatter_;
    NSDateFormatter*    dateFormatter_;
}

@synthesize calendar = calendar_;

- (id)initWithCalendar:(NSCalendar*)calendar
{
    if(self = [super init])
    {
        calendar_ = calendar ? calendar : [NSCalendar currentCalendar];
    }
    return self;
}

- (id)init
{
    return [self initWithCalendar:nil];
}

- (NSArray*)arrayFromParser:(yaml_parser_t*)parser
                yamlOptions:(PWYAMLParserOptions)yamlOptions
               pListOptions:(NSPropertyListReadOptions)plistOptions
{
    NSMutableArray* array = [NSMutableArray array];
    while(YES)
    {
        id value = [self propertyListFromParser:parser yamlOptions:yamlOptions pListOptions:plistOptions];
        if(value)
            [array addObject:value];
        else
            break;
    }
    return (plistOptions == NSPropertyListImmutable) ? [array copy] : array;
}

static NSString* const MappingEndMarker = @"MappingEndMarker";

- (id)mappingFromParser:(yaml_parser_t*)parser
            yamlOptions:(PWYAMLParserOptions)yamlOptions
           pListOptions:(NSPropertyListReadOptions)plistOptions
{
    id mapping;
    while(YES)
    {
        id key = [self propertyListFromParser:parser yamlOptions:yamlOptions pListOptions:plistOptions];
        if(key != MappingEndMarker)
        {
            id value = [self propertyListFromParser:parser yamlOptions:yamlOptions pListOptions:plistOptions];
            if(![value isKindOfClass:[NSString class]] || [value length])
            {
                if(!mapping)
                    mapping = [NSMutableDictionary dictionary];
                [mapping setValue:value forKey:key];
            }
            else
            {
                if(!mapping)
                    mapping = [NSMutableSet set];
                [mapping addObject:key];
            }
        }
        else
        {
            if(!mapping)
                mapping = [NSMutableDictionary dictionary];
            break;
        }
    }
    // Note: there’s no immutable variant of PWMutableOrderedDictionary yet.
    return (plistOptions == NSPropertyListImmutable ) ? [mapping copy] : mapping;
}

- (NSDateFormatter*)isoDateTimeZoneFormatter
{
    if(!isoDateTimeZoneFormatter_)
    {
        isoDateTimeZoneFormatter_ = [[NSDateFormatter alloc] init];
        isoDateTimeZoneFormatter_.calendar = calendar_;
        isoDateTimeZoneFormatter_.timeZone = calendar_.timeZone;
        isoDateTimeZoneFormatter_.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSz";
    }
    return isoDateTimeZoneFormatter_;
}

- (PWISODateFormatter*)isoDateTimeFormatter
{
    if(!isoDateTimeFormatter_)
    {
        PWISODateFormatter* formatter =  [[PWISODateFormatter alloc] init];
        formatter.calendar = calendar_;
        isoDateTimeFormatter_ = formatter;
    }
    return isoDateTimeFormatter_;
}

- (NSDateFormatter*)spacedDateTimeFormatterWithSeconds
{
    if(!spacedDateTimeFormatterWithSeconds_)
    {
        spacedDateTimeFormatterWithSeconds_ = [[NSDateFormatter alloc] init];
        spacedDateTimeFormatterWithSeconds_.calendar = calendar_;
        spacedDateTimeFormatterWithSeconds_.timeZone = calendar_.timeZone;
        spacedDateTimeFormatterWithSeconds_.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSSz";
    }
    return spacedDateTimeFormatterWithSeconds_;
}

- (NSDateFormatter*)spacedDateTimeFormatter
{
    if(!spacedDateTimeFormatter_)
    {
        spacedDateTimeFormatter_ = [[NSDateFormatter alloc] init];
        spacedDateTimeFormatter_.calendar = calendar_;
        spacedDateTimeFormatter_.timeZone = calendar_.timeZone;
        spacedDateTimeFormatter_.dateFormat = @"yyyy-MM-dd HH:mmz";
    }
    return spacedDateTimeFormatter_;
}

- (NSDateFormatter*)dateFormatter
{
    if(!dateFormatter_)
    {
        dateFormatter_ = [[NSDateFormatter alloc] init];
        dateFormatter_.calendar = calendar_;
        dateFormatter_.timeZone = calendar_.timeZone;
        dateFormatter_.dateFormat = @"yyyy-MM-dd";
    }
    return dateFormatter_;
}

- (BOOL)mayStringContainDate:(NSString*)string
{
    NSRange firstDash = [string rangeOfString:@"-"];
    if(firstDash.location != NSNotFound)
    {
        NSRange secondDash = [string rangeOfString:@"-" 
                                           options:NSLiteralSearch 
                                             range:NSMakeRange(NSMaxRange(firstDash), string.length-NSMaxRange(firstDash))];
        if(secondDash.location != NSNotFound)
            return YES;
    }
    return NO;
}


- (id)scalarFromEvent:(yaml_event_t*)event
          yamlOptions:(PWYAMLParserOptions)yamlOptions
         pListOptions:(NSPropertyListReadOptions)plistOptions
{
    // TODO: Support NSData 
    yaml_scalar_style_t style = event->data.scalar.style;
    Class stringValueClass = (plistOptions == NSPropertyListMutableContainersAndLeaves) ? [NSMutableString class] : [NSString class];
    NSString* stringValue = [stringValueClass stringWithUTF8String:(const char*)event->data.scalar.value];
    if (   style != YAML_SINGLE_QUOTED_SCALAR_STYLE && style != YAML_DOUBLE_QUOTED_SCALAR_STYLE
        && stringValue.length > 0) {
        
        /*
         if(yamlOptions & PWYAMLParserParseBinaryData)
        {
            const char* tag = (const char*)event->data.scalar.tag;
            if(tag && strcmp(tag, "tag:yaml.org,2002:binary")==0)
                return [stringValue decodeBase64Error:NULL];
        }
        */
        
        if (yamlOptions & PWYAMLParserParseBooleans) {
            if ([stringValue isEqual:@"true"])
                return @YES;
            if ([stringValue isEqual:@"false"])
                return @NO;
        }
        
        if(yamlOptions & PWYAMLParserParseNils && [stringValue isEqual:@"nil"])
            return [NSNull null];
        
        if ((yamlOptions & PWYAMLParserParseHexNumbers) && [stringValue hasPrefix:@"0x"]) {
            NSScanner* scanner = [[NSScanner alloc] initWithString:stringValue];
            double hexValue = 0.0;  // TODO: why double?
            if ([scanner scanHexDouble:&hexValue] && scanner.isAtEnd)
                return @(hexValue);
        }

        if (yamlOptions & PWYAMLParserParseNumbers) {
            // Quick check for possible number before creating the parser.
            unichar firstChar = [stringValue characterAtIndex:0];
            if (   (firstChar >= '0' && firstChar <= '9')
                || firstChar == '+'
                || firstChar == '-'
                || firstChar == '.') {
                NSScanner* scanner = [[NSScanner alloc] initWithString:stringValue];
                double doubleValue = 0.0;
                if ([scanner scanDouble:&doubleValue] && scanner.isAtEnd) {
                    NSInteger integerValue = (NSInteger)doubleValue;
                    return (doubleValue == (double)integerValue) ? @(integerValue)
                                                                 : @(doubleValue);
                }
            }
        }
        if (yamlOptions & PWYAMLParserParseDates && [self mayStringContainDate:stringValue]) {
            NSDate* date = [self.isoDateTimeZoneFormatter dateFromString:stringValue];
            if (!date)
                date = [self.isoDateTimeFormatter dateFromString:stringValue];
            if (!date)
                date = [self.spacedDateTimeFormatterWithSeconds dateFromString:stringValue];
            if (!date)
                date = [self.spacedDateTimeFormatter dateFromString:stringValue];
            if (!date)
                date = [self.dateFormatter dateFromString:stringValue];
            if (date)
                return date;
        }
    }
    return stringValue;
}

- (id)propertyListFromParser:(yaml_parser_t*)parser
                 yamlOptions:(PWYAMLParserOptions)yamlOptions
                pListOptions:(NSPropertyListReadOptions)plistOptions
{
    id plist;
    yaml_event_t event;
    if(yaml_parser_parse(parser, &event))
    {
        switch(event.type)
        {
            case YAML_SEQUENCE_START_EVENT:
                plist = [self arrayFromParser:parser yamlOptions:yamlOptions pListOptions:plistOptions];
                break;
            case YAML_MAPPING_START_EVENT:
                plist = [self mappingFromParser:parser yamlOptions:yamlOptions pListOptions:plistOptions];
                break;
            case YAML_SCALAR_EVENT:
                plist = [self scalarFromEvent:&event yamlOptions:yamlOptions pListOptions:plistOptions];
                break;
            case YAML_MAPPING_END_EVENT:
                plist = MappingEndMarker;
                break;
            case YAML_NO_EVENT:
            default:
                break;
        }
        yaml_event_delete(&event);
    }
    return plist;
}

- (NSArray*)documentsFromParser:(yaml_parser_t*)parser
                    yamlOptions:(PWYAMLParserOptions)yamlOptions
                   pListOptions:(NSPropertyListReadOptions)plistOptions
{
    NSMutableArray* documents = [NSMutableArray array];
    BOOL done = NO;
    while (!done) {
        yaml_event_t event;
        if(yaml_parser_parse(parser, &event))
        {
            switch(event.type)
            {
                case YAML_DOCUMENT_START_EVENT:
                    [documents addObject:[self propertyListFromParser:parser yamlOptions:yamlOptions pListOptions:plistOptions]];
                    break;
                case YAML_STREAM_END_EVENT:
                case YAML_NO_EVENT:
                    done = YES;
                    break;
                case YAML_STREAM_START_EVENT:
                case YAML_DOCUMENT_END_EVENT:
                case YAML_ALIAS_EVENT:
                case YAML_SCALAR_EVENT:
                case YAML_SEQUENCE_START_EVENT:                
                case YAML_SEQUENCE_END_EVENT:
                case YAML_MAPPING_START_EVENT:
                case YAML_MAPPING_END_EVENT:
                default:
                    break;
            }
            yaml_event_delete(&event);
        }
        else
            done = YES;
    }
    return (plistOptions == NSPropertyListImmutable) ? [documents copy] : documents;
}

- (NSError*)errorFromParser:(yaml_parser_t*)parser
{
    NSError* error;
    if(parser->error != YAML_NO_ERROR)
    {
        yaml_mark_t mark = parser->problem_mark;
        NSString* message = [NSString stringWithFormat:@"Parse error at index: %ld line: %zd column: %zd -> %s ", mark.index, mark.line, mark.column, parser->problem];
        NSDictionary *userInfoDict = @{NSLocalizedDescriptionKey: message};
        error = [NSError errorWithDomain:PWErrorDomain
                                    code:PWYAMLParserError
                                userInfo:userInfoDict];
    }
    return error;
}

- (id) propertyListFromYAMLData:(NSData*)data
                    yamlOptions:(PWYAMLParserOptions)yamlOptions
                   pListOptions:(NSPropertyListReadOptions)plistOptions
                          error:(NSError**)outError
{
    yaml_parser_t parser;
    yaml_parser_initialize(&parser);
    yaml_parser_set_input_string(&parser, data.bytes, data.length);
    NSArray* documents = [self documentsFromParser:&parser yamlOptions:yamlOptions pListOptions:plistOptions];
    NSError* error = [self errorFromParser:&parser];
    if(error)
    {
        documents = nil;
        if(outError)
            *outError = error;
    }
    yaml_parser_delete(&parser);
    return documents.count == 0 ? nil : documents.count==1 ? [documents objectAtIndex:0] : documents;
}

+ (PWYAMLParser*)sharedParser
{
    static PWYAMLParser* parser;
    if(!parser)
        parser = [[PWYAMLParser alloc] initWithCalendar:[NSCalendar currentCalendar]];
    return parser;
}

+ (PWYAMLParser*)sharedGMTParser
{
    static PWYAMLParser* parser;
    if(!parser)
    {
        NSTimeZone* gmt = [NSTimeZone timeZoneForSecondsFromGMT:0];
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        calendar.timeZone = gmt;
        parser = [[PWYAMLParser alloc] initWithCalendar:calendar];
    }
    return parser;
}

- (BOOL)doesDataContainYAMLFile:(NSData*)data
{
    BOOL result = NO;
    if(data.length>=4)
    {
        NSString* prefix = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0,5)] encoding:NSUTF8StringEncoding];
        if([prefix isEqual:@"---"])
            result = YES;
        else
            result = ![prefix isEqual:@"<?xml"] && ![prefix isEqual:@"bplis"] && ![prefix hasPrefix:@"("] && ![prefix hasPrefix:@"{"];
    }
    return result;
}
@end
