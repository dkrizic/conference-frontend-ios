//
//  RoomViewController.h
//  RESTClient
//
//  Created by Darko Krizic on 2012-12-21.
//  Copyright (c) 2012 Darko Krizic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "Room.h"
#import "RoomDetailViewController.h"

@interface RoomViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
