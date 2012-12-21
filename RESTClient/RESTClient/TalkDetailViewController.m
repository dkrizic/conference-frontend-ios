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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TalkDetail" forIndexPath:indexPath];    cell.textLabel.text = @"Das Leben des Perff";
    return cell;
}

@end
