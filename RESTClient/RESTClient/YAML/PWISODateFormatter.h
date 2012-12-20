//
//  PWISODateFormatter.h
//  PWFoundation
//
//  Created by Kai Brüning on 7.5.10.
//  Copyright 2010 ProjectWizards. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Format: yyyy-MM-dd[( |t|T)HH[:mm[:ss[.sss]]]]
 */

typedef enum PWISODateStyle
{
    PWISODateAndTime = 0,
    PWISODateOnly    = 1
} PWISODateStyle;

@interface PWISODateFormatter : NSFormatter

@property (nonatomic, readwrite, strong)    NSCalendar*     calendar;
@property (nonatomic, readwrite)            PWISODateStyle  style;

// Typed variant of -stringForObjectValue:
- (NSString*) stringFromDate:(NSDate*)date;

// Variant of getObjectValue:forString:errorDescription: ignoring errors.
- (NSDate*) dateFromString:(NSString*)string;

@end
