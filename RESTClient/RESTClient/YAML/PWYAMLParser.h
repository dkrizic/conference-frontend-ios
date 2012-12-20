//
//  PWYAMLParser.h
//  PWFoundation
//
//  Created by Frank Illenberger on 09.12.09.
//  Copyright 2009 ProjectWizards. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWISODateFormatter;

typedef enum {
    PWYAMLParserParseBooleans           = 1 << 0,
    PWYAMLParserParseNumbers            = 1 << 1,
    PWYAMLParserParseHexNumbers         = 1 << 2,
    PWYAMLParserParseDates              = 1 << 3,
   // PWYAMLParserParseBinaryData         = 1 << 4,
    PWYAMLParserParseNils               = 1 << 5,
    PWYAMLParserParseAllPListTypes      = (1 << 6) - 1,
} PWYAMLParserOptions;

enum {
    PWYAMLParserError = 1,
};

@interface PWYAMLParser : NSObject

@property (nonatomic, readonly, strong) NSCalendar* calendar;

+ (PWYAMLParser*) sharedParser;     // uses current calendar
+ (PWYAMLParser*) sharedGMTParser;  // uses GMT zone gregorian calendar

- (id)initWithCalendar:(NSCalendar*)calendar;

- (id) propertyListFromYAMLData:(NSData*)data
                    yamlOptions:(PWYAMLParserOptions)yamlOptions
                   pListOptions:(NSPropertyListReadOptions)plistOptions
                          error:(NSError**)outError;

- (BOOL) doesDataContainYAMLFile:(NSData*)data;

@end

