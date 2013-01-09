//
//  TalkDetailViewController.m
//  RESTClient
//
//  Created by Darko Krizic on 2012-12-21.
//  Copyright (c) 2012 Darko Krizic. All rights reserved.
//

#import "TalkDetailViewController.h"

@interface TalkDetailViewController ()

@end

@implementation TalkDetailViewController
@synthesize talk, talkName, roomName, speakerName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    talkName.textLabel.text = talk.name;
    roomName.textLabel.text = talk.room.name;
    // UITableView *tableView = [self tableView];
    NSSet *speakers = talk.speakers;
    if( speakers != nil ) {
    for( Speaker *speaker in speakers ) {
        speakerName.textLabel.text = speaker.name;
    }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RoomDetailViewController *detail = [segue destinationViewController];
    detail.room = talk.room;
}

@end
