//
//  Talk.h
//  RESTClient
//
//  Created by Darko Krizic on 2013-01-04.
//  Copyright (c) 2013 Darko Krizic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Room, Speaker;

@interface Talk : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * minutes;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) NSNumber * updated;
@property (nonatomic, retain) Room *room;
@property (nonatomic, retain) NSSet *speakers;
@end

@interface Talk (CoreDataGeneratedAccessors)

- (void)addSpeakersObject:(Speaker *)value;
- (void)removeSpeakersObject:(Speaker *)value;
- (void)addSpeakers:(NSSet *)values;
- (void)removeSpeakers:(NSSet *)values;

@end
