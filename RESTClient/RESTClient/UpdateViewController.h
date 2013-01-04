//
//  UpdateViewController.h
//  RESTClient
//
//  Created by Darko Krizic on 2012-12-29.
//  Copyright (c) 2012 Darko Krizic. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "Room.h"
#import "Talk.h"

@interface UpdateViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//- (void) handleTalks:(NSArray *) talks;
//- (void) handleTalk:(NSDictionary *) talk;
//- (Room *) createRoom;

@end
