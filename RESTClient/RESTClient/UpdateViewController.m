//
//  UpdateViewController.m
//  RESTClient
//
//  Created by Darko Krizic on 2012-12-29.
//  Copyright (c) 2012 Darko Krizic. All rights reserved.
//

#import "UpdateViewController.h"

@interface UpdateViewController ()

@end

@implementation UpdateViewController

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

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Did laod");
    NSURL *url = [NSURL URLWithString:@"http://conference-krizic.rhcloud.com/rest/talk/all"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSLog(@"Starting access");
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    // NSString *json = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"Access finished");
    NSArray *talks = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"Found %i talks", [talks count] );
    for( NSDictionary *talk in talks ) {
        NSLog(@"Talk %@", talk );
        NSString *talkid = [talk objectForKey:@"id"];
        NSString *name = [talk objectForKey:@"name"];
        NSLog(@"%@ %@", talkid, name);
        
        NSDictionary *room = [talk objectForKey:@"room"];
        NSString *room_id = [room objectForKey:@"id"];
        NSString *room_name = [room objectForKey:@"name"];
        NSNumber *room_capacity = [room objectForKey:@"capacity"];
        NSLog(@"%@ %@ %@", room_id, room_name, room_capacity);
    
        Room *roomEntity = (Room *) [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:managedObjectContext];

        roomEntity.id = room_id;
        roomEntity.name = room_name;
        roomEntity.capacity = room_capacity;

        NSLog(@"Room object %@", roomEntity );
          [managedObjectContext save:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
