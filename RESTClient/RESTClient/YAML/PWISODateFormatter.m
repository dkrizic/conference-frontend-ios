//
//  PWISODateFormatter.m
//  PWFoundation
//
//  Created by Kai Brüning on 7.5.10.
//  Copyright 2010 ProjectWizards. All rights reserved.
//

#import "PWISODateFormatter.h"
#import "NSString-PWExtensions.h"


@implementation PWISODateFormatter

@synthesize calendar = calendar_;
@synthesize style    = style_;

- (NSCalendar*) calendar
{
    if (!calendar_)
        calendar_ = [NSCalendar currentCalendar];
    return calendar_;
}

- (NSString*) stringFromDate:(NSDate*)date
{
    NSString* string = nil;
    if(!date)
        string = @"";
    else
    {
        if(style_ == PWISODateAndTime) {
            NSDateComponents* comps = [self.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                       | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
                                                       fromDate:date];
            
            // TODO: add fraction seconds?
            return [NSString stringWithFormat:@"%.4li-%.2li-%.2liT%.2li:%.2li:%.2li",
                    (long)comps.year, (long)comps.month, (long)comps.day, (long)comps.hour, (long)comps.minute, (long)comps.second];
        }
        else if(style_ == PWISODateOnly) {
            NSDateComponents* comps = [self.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                       fromDate:date];
            
            return [NSString stringWithFormat:@"%.4li-%.2li-%.2li", (long)comps.year, (long)comps.month, (long)comps.day];
        }
        else {
            NSAssert(NO, nil);
        }
    }
    return string;
}

- (NSString*) stringForObjectValue:(id)obj
{
    if (obj && ![obj isKindOfClass:[NSDate class]])
        [NSException raise:NSInvalidArgumentException 
                    format:@"PWISODateFormatter can not format a %@.", NSStringFromClass ([obj class])];

    return [self stringFromDate:obj];
}

- (BOOL) getObjectValue:(id*)outValue forString:(NSString*)string errorDescription:(NSString**)outDescription
{
    NSParameterAssert (outValue);
    if(!string.length)
    {
        *outValue = nil;
        return YES;
    }
    BOOL success = NO;

    static NSRegularExpression* regEx;
    if(!regEx)
        regEx = [NSRegularExpression
                 regularExpressionWithPattern:@"^([0-9]{1,4})-([0-9]{1,2})-([0-9]{1,2})(?:[tT\\s]\\s*([0-9]{1,2})(?::([0-9]{2})(?::([0-9]{2})(\\.[0-9]+)?)?)?)?$"
                 options:0 error:NULL];
     
    NSTextCheckingResult* match = [regEx firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    if (match) {
        NSTimeInterval fraction = 0.0;
        
        NSDateComponents* comps = [[NSDateComponents alloc] init];
        comps.year  = [[string substringWithMatch:match rangeIndex:1] integerValue];
        comps.month = [[string substringWithMatch:match rangeIndex:2] integerValue];
        comps.day   = [[string substringWithMatch:match rangeIndex:3] integerValue];
        
        if(style_ == PWISODateAndTime) {
            NSString* aNumberString = [string substringWithMatch:match rangeIndex:4];
            if (aNumberString) {
                comps.hour = [aNumberString integerValue];
                
                aNumberString = [string substringWithMatch:match rangeIndex:5];
                if (aNumberString) {
                    comps.minute = [aNumberString integerValue];
                    
                    aNumberString = [string substringWithMatch:match rangeIndex:6];
                    if (aNumberString) {
                        comps.second = [aNumberString integerValue];
                        
                        aNumberString = [string substringWithMatch:match rangeIndex:7];
                        if (aNumberString)
                            fraction = [aNumberString doubleValue];
                    }
                }
            }
        }
        NSDate* date = [self.calendar dateFromComponents:comps];
        
        // NSDateComponents knows no fractions of seconds, therefore these must be added afterwards.
        if (fraction != 0.0)
            date = [date dateByAddingTimeInterval:fraction];
        
        *outValue = date;
        success = YES;
    } else if (outDescription) {
        // TODO: create error string.
    }

    return success;
}

- (NSDate*) dateFromString:(NSString*)string
{
    NSDate* date = nil;
    [self getObjectValue:&date forString:string errorDescription:NULL];
    return date;
}

@end
