//
//  Room.h
//  RESTClient
//
//  Created by Darko Krizic on 2013-01-04.
//  Copyright (c) 2013 Darko Krizic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Talk;

@interface Room : NSManagedObject

@property (nonatomic, retain) NSNumber * capacity;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * updated;
@property (nonatomic, retain) NSSet *talks;
@end

@interface Room (CoreDataGeneratedAccessors)

- (void)addTalksObject:(Talk *)value;
- (void)removeTalksObject:(Talk *)value;
- (void)addTalks:(NSSet *)values;
- (void)removeTalks:(NSSet *)values;

@end
