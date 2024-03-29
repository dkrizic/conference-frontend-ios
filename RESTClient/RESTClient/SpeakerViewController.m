//
//  SpeakerViewController.m
//  RESTClient
//
//  Created by Darko Krizic on 2012-12-21.
//  Copyright (c) 2012 Darko Krizic. All rights reserved.
//

#import "SpeakerViewController.h"

#import <CoreData/CoreData.h>

@interface SpeakerViewController ()

@end

@implementation SpeakerViewController

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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *speakers = [self readAllSpeakers];
    return speakers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *speakers = [self readAllSpeakers];
    NSManagedObject *speaker = [speakers objectAtIndex:indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpeakersEntry" forIndexPath:indexPath];;
    cell.textLabel.text = [speaker valueForKey:@"name"];
    cell.detailTextLabel.text = @"1";
    return cell;
}

- (NSArray *) readAllSpeakers {
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Speaker"];
    NSArray *speakers = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    return speakers;
}

@end
