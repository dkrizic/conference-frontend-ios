//
//  Speaker.h
//  RESTClient
//
//  Created by Darko Krizic on 2012-12-20.
//  Copyright (c) 2012 Darko Krizic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Talk;

@interface Speaker : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Talk *talks;

@end
