//
//  TalkDetailViewController.h
//  RESTClient
//
//  Created by Darko Krizic on 2012-12-21.
//  Copyright (c) 2012 Darko Krizic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Talk.h"
#import "Room.h"
#import "Speaker.h"
#import "RoomDetailViewController.h"

@interface TalkDetailViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *talkName;
@property (weak, nonatomic) IBOutlet UITableViewCell *roomName;
@property (weak, nonatomic) IBOutlet UITableViewCell *speakerName;

@property (strong, nonatomic) Talk *talk;
@end
