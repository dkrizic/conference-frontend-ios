//
//  SettingsViewController.m
//  RESTClient
//
//  Created by Darko Krizic on 2012-12-21.
//  Copyright (c) 2012 Darko Krizic. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Settings Controller");
//
//    NSStringEncoding *encoding;
//    NSError *error;
//    NSURL *jsonURL = [NSURL URLWithString:@"http://conference-krizic.rhcloud.com/rest/talk/all"];
//    NSString *jsonData = [[NSString alloc] initWithContentsOfURL:jsonURL encoding:&encoding error:&error];
//    NSLog(jsonData);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
