//
//  Talk.h
//  RESTClient
//
//  Created by Darko Krizic on 2012-12-20.
//  Copyright (c) 2012 Darko Krizic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Room;

@interface Talk : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) Room *room;
@property (nonatomic, retain) NSSet *speaker;
@end

@interface Talk (CoreDataGeneratedAccessors)

- (void)addSpeakerObject:(NSManagedObject *)value;
- (void)removeSpeakerObject:(NSManagedObject *)value;
- (void)addSpeaker:(NSSet *)values;
- (void)removeSpeaker:(NSSet *)values;

@end
