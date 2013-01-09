//
//  RoomDetailViewController.h
//  RESTClient
//
//  Created by Darko Krizic on 2013-01-09.
//  Copyright (c) 2013 Darko Krizic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"

@interface RoomDetailViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (nonatomic,strong) Room *room;

@end
