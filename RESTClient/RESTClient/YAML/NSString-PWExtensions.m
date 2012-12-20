//
//  NSString-MEAdditions.m
//  Merlin
//
//  Created by Frank Illenberger on 19.07.05.
//  Copyright 2005 ProjectWizards, Melle, Germany. All rights reserved.
//

#import "NSString-PWExtensions.h"


@implementation NSString (PWExtensions)

- (NSString*)substringWithMatch:(NSTextCheckingResult*)match rangeIndex:(NSUInteger)index
{
    if(!match)
        return nil;
    NSRange range = [match rangeAtIndex:index];
    return range.location != NSNotFound ? [self substringWithRange:range] : nil;
}

@end

