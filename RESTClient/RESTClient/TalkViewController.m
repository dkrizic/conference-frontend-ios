//
//  TalkViewController.m
//  RESTClient
//
//  Created by Darko Krizic on 2012-12-21.
//  Copyright (c) 2012 Darko Krizic. All rights reserved.
//

#import "TalkViewController.h"

@interface TalkViewController ()

@end

@implementation TalkViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"room"];
    cell.textLabel.text = @"Das Leben des Perff";
    cell.detailTextLabel.text = @"Darko Krizic, Ballsaal";
    return cell;
}


@end
