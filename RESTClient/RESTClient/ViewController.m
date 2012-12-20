//
//  ViewController.m
//  RESTClient
//
//  Created by Darko Krizic on 2012-12-20.
//  Copyright (c) 2012 Darko Krizic. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if( indexPath.section == 0 ) {
    if( indexPath.row == 0 ) {
        cell.textLabel.text = @"Rooms";
    } else if( indexPath.row == 1 ) {
        cell.textLabel.text = @"Speakers";
    } else if( indexPath.row == 2 ) {
        cell.textLabel.text = @"Talks";
    }
    } else {
        cell.textLabel.text = @"Settings";
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if( section == 0 ) {
        return 3;
    } else {
        return 1;
    }
}
@end
