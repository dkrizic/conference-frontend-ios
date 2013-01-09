//
//  TalkViewController.m
//  RESTClient
//
//  Created by Darko Krizic on 2012-12-21.
//  Copyright (c) 2012 Darko Krizic. All rights reserved.
//

#import "TalkViewController.h"
#import "TalkDetailViewController.h"

@interface TalkViewController ()

@end

@implementation TalkViewController

NSInteger selectedRow;

@synthesize managedObjectContext;

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
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *talks = [self readAllTalks];
    return [talks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *talks = [self readAllTalks];
    Talk *talk = (Talk *) [talks objectAtIndex:[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TalksEntry" forIndexPath:indexPath];;
    cell.textLabel.text = talk.name;
    cell.detailTextLabel.text = talk.room.name;
    return cell;

}

-(NSArray *)readAllTalks {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Talk" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSArray *talks = [managedObjectContext executeFetchRequest:request error:nil];
    return talks;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSArray *talks = [self readAllTalks];
    Talk *talk = (Talk *) [talks objectAtIndex:selectedRow];
    TalkDetailViewController *detail = [segue destinationViewController];
    detail.talk = talk;
}

@end
