//
//  TalkViewController.h
//  RESTClient
//
//  Created by Darko Krizic on 2012-12-21.
//  Copyright (c) 2012 Darko Krizic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "Talk.h"
#import "Room.h"

@interface TalkViewController : UIViewController <UITableViewDataSource>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *talks;

@end
