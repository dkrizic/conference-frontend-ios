//
//  PWYAMLParserTest.m
//  PWFoundation
//
//  Created by Frank Illenberger on 09.12.09.
//  Copyright 2009 ProjectWizards. All rights reserved.
//

#import "PWYAMLParserTest.h"
#import "PWYAMLParser.h"

@implementation PWYAMLParserTest

- (void)testParseArray
{
    NSString* path = [[NSBundle bundleForClass:self.class] pathForResource:@"array" ofType:@"yaml"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSError* error = nil;
    NSArray* array = [[[PWYAMLParser alloc] init] propertyListFromYAMLData:data
                                                               yamlOptions:PWYAMLParserParseAllPListTypes
                                                              pListOptions:0
                                                                     error:&error];
    
    STAssertEquals(array.count, (NSUInteger)4, nil);
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:-3600*4];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.year     = 2009;
    components.month    = 8;
    components.day      = 12;
    components.hour     = 14;
    components.minute   = 30;
    components.second   = 15;
    NSDate* date = [calendar dateFromComponents:components];
    NSDictionary* dict0 = @{@"name": @"Mike", @"date": date, 
                           @"countries": @[@"Finland", @"Germany"], @"id": @1};
    
    STAssertEqualObjects([array objectAtIndex:0], dict0, nil);

    NSDictionary* dict1 = @{@"name": @"Chris", @"date": date, 
                           @"country": @"Brasil", @"id": @-2};
    
    STAssertEqualObjects([array objectAtIndex:1], dict1, nil);

    NSDictionary* dict2 = @{@"name": @"Mike", @"date": date, 
                           @"country": @"Guatemala", @"id": @12};
    
    STAssertEqualObjects([array objectAtIndex:2], dict2, nil);
 
    NSDateComponents* components3 = [[NSDateComponents alloc] init];
    components3.year        = 2009;
    components3.month   = 8;
    components3.day     = 12;
    NSCalendar* calendar3 = [NSCalendar currentCalendar];
    NSDate* date3 = [calendar3 dateFromComponents:components3];
    NSDictionary* dict3 = @{@"name": @"Joshi", @"date": date3, 
                           @"country": @"France", @"id": @4.4};
    
    STAssertEqualObjects([array objectAtIndex:3], dict3, nil);
}

- (void)testParseDictionary
{
    NSString* path = [[NSBundle bundleForClass:self.class] pathForResource:@"dictionary" ofType:@"yaml"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSError* error = nil;
    NSDictionary* dict = [[[PWYAMLParser alloc] init] propertyListFromYAMLData:data
                                                                   yamlOptions:PWYAMLParserParseAllPListTypes
                                                                  pListOptions:0
                                                                         error:&error];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:-3600*4];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.year     = 2009;
    components.month    = 8;
    components.day      = 12;
    components.hour     = 14;
    components.minute   = 30;
    components.second   = 15;
    NSDate* date = [calendar dateFromComponents:components];
    NSDictionary* dictCompare = @{@"name": @"Mike",
                                 @"date": date, 
                                 @"notHex": @"0xEX",
                                 @"countries": @{@"Finland": @"nice", @"Germany": @"very nice"},
                                 @"id": @0, 
                                 @"flavors": [NSSet setWithObjects:@"1 Strawberry", @"2 Vanilla", nil], 
                                 @"emptyArray": @[],
                                 @"emptyMap": @{}};
    
    STAssertEqualObjects(dict, dictCompare, nil);
    
}

- (void)testYAMLOptions
{
    NSString* path = [[NSBundle bundleForClass:self.class] pathForResource:@"dictionary 2" ofType:@"yaml"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSError* error = nil;
    NSDictionary* dict = [[PWYAMLParser sharedParser] propertyListFromYAMLData:data
                                                                   yamlOptions:PWYAMLParserParseAllPListTypes
                                                                  pListOptions:0
                                                                         error:&error];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:-3600*4];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.year     = 2009;
    components.month    = 8;
    components.day      = 12;
    components.hour     = 14;
    components.minute   = 30;
    components.second   = 15;
    NSDate* date = [calendar dateFromComponents:components];
    NSDictionary* dictCompare = @{@"id": @0, 
                                 @"name": @"Mike",
                                 @"date": date, 
                                 @"hex": @42, 
                                 @"integer": @4711, 
                                 @"float": @3.14, 
                                 @"truth": @YES, 
                                 @"nada": [NSNull null]};
    STAssertEqualObjects (dict, dictCompare, nil);


    dict = [[PWYAMLParser sharedParser] propertyListFromYAMLData:data
                                                     yamlOptions:PWYAMLParserParseBooleans | PWYAMLParserParseNumbers | PWYAMLParserParseHexNumbers
                                                    pListOptions:0
                                                           error:&error];
    dictCompare = @{@"id": @0, 
                   @"name": @"Mike",
                   @"date": @"2009-08-12T14:30:15.00-0400", 
                   @"hex": @42, 
                   @"integer": @4711, 
                   @"float": @3.14, 
                   @"truth": @YES, 
                   @"nada": @"nil"};
    STAssertEqualObjects (dict, dictCompare, nil);
    
    
    dict = [[PWYAMLParser sharedParser] propertyListFromYAMLData:data
                                                     yamlOptions:PWYAMLParserParseBooleans | PWYAMLParserParseNumbers
                                                    pListOptions:0
                                                           error:&error];
    dictCompare = @{@"id": @0, 
                   @"name": @"Mike",
                   @"date": @"2009-08-12T14:30:15.00-0400", 
                   @"hex": @"0x2a", 
                   @"integer": @4711, 
                   @"float": @3.14, 
                   @"truth": @YES, 
                   @"nada": @"nil"};
    STAssertEqualObjects (dict, dictCompare, nil);
    
    
    dict = [[PWYAMLParser sharedParser] propertyListFromYAMLData:data
                                                     yamlOptions:PWYAMLParserParseBooleans | PWYAMLParserParseNils
                                                    pListOptions:0
                                                           error:&error];
    dictCompare = @{@"id": @"0.0", 
                   @"name": @"Mike",
                   @"date": @"2009-08-12T14:30:15.00-0400", 
                   @"hex": @"0x2a", 
                   @"integer": @"4711", 
                   @"float": @"3.14", 
                   @"truth": @YES, 
                   @"nada": [NSNull null]};
    STAssertEqualObjects (dict, dictCompare, nil);
    
    
    dict = [[PWYAMLParser sharedParser] propertyListFromYAMLData:data
                                                     yamlOptions:0
                                                    pListOptions:0
                                                           error:&error];
    dictCompare = @{@"id": @"0.0", 
                   @"name": @"Mike",
                   @"date": @"2009-08-12T14:30:15.00-0400", 
                   @"hex": @"0x2a", 
                   @"integer": @"4711", 
                   @"float": @"3.14", 
                   @"truth": @"true", 
                   @"nada": @"nil"};
    STAssertEqualObjects (dict, dictCompare, nil);
}

@end

