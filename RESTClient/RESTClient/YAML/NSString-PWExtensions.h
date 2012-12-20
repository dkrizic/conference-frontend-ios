//
//  NSString-MEAdditions.h
//  Merlin
//
//  Created by Frank Illenberger on 19.07.05.
//  Copyright 2005 ProjectWizards, Melle, Germany. All rights reserved.
//

@interface NSString (PWExtensions)

- (NSString*)substringWithMatch:(NSTextCheckingResult*)match
                     rangeIndex:(NSUInteger)index;

@end
