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
    [self handleTalks:talks];
}

- (void) handleTalks:(NSArray *) talks {
    NSLog(@"Found %i talks", [talks count] );
    for( NSDictionary *talk in talks ) {
        [self handleTalk:talk];
    }
    [managedObjectContext save:nil];
}

- (void) handleTalk:(NSDictionary *)talk {
    NSLog(@"Talk %@", talk );
    NSString *talkId = [talk objectForKey:@"id"];
    NSString *name = [talk objectForKey:@"name"];
    NSLog(@"%@ %@", talkId, name);
    
    NSDictionary *room = [talk objectForKey:@"room"];
    Room *roomEntity = [self handleRoom:room];
    
    Talk *talkEntity = [self talkById:talkId];
    if( talkEntity == nil ) {
        talkEntity = [self createTalkWithId:talkId];
        NSLog(@"Created %@", talkEntity );
    } else {
        NSLog(@"Reusing %@", talkEntity );
    }
    
    talkEntity.room = roomEntity;
    talkEntity.name = name;
    talkEntity.updated = [NSNumber numberWithBool:YES];
}

- (Room *) handleRoom:(NSDictionary *)room {
    NSString *room_id = [room objectForKey:@"id"];
    NSString *name = [room objectForKey:@"name"];
    NSNumber *capacity = [room objectForKey:@"capacity"];
    NSLog(@"%@ %@ %@", room_id, name, capacity);
    
    Room *roomEntity = [self roomById:room_id];
    if( roomEntity == nil ) {
        roomEntity = [self createRoomWithId:room_id];
        NSLog(@"Created new room for %@", room );
    } else {
        NSLog(@"Reusing existing room %@", roomEntity);
    }
    roomEntity.id = room_id;
    roomEntity.name = name;
    roomEntity.capacity = capacity;
    roomEntity.updated = [NSNumber numberWithBool:YES];
    NSLog(@"Room object %@", roomEntity );
    return roomEntity;
}

- (Room *)roomById:(NSString *)roomId
{
    NSEntityDescription *roomType = [NSEntityDescription entityForName:@"Room" inManagedObjectContext:managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id=%@", roomId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:roomType];
    [request setPredicate:predicate];
    NSArray *rooms = [managedObjectContext executeFetchRequest:request error:nil];
    if( rooms.count == 0 ) {
        return nil;
    }
    Room *room = (Room *) [rooms lastObject];
    return room;
}

- (Room *) createRoomWithId:(NSString *)roomId;
{
    Room *room = (Room *) [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:managedObjectContext];
    room.id = roomId;
    return room;
}

- (Talk *)talkById:(NSString *)roomId
{
    NSEntityDescription *roomType = [NSEntityDescription entityForName:@"Talk" inManagedObjectContext:managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id=%@", roomId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:roomType];
    [request setPredicate:predicate];
    NSArray *talks = [managedObjectContext executeFetchRequest:request error:nil];
    if( talks.count == 0 ) {
        return nil;
    }
    Talk *talk = (Talk *) [talks lastObject];
    return talk;
}

- (Talk *) createTalkWithId:(NSString *)talkId
{
    Talk *talk = (Talk *) [NSEntityDescription insertNewObjectForEntityForName:@"Talk" inManagedObjectContext:managedObjectContext];
    talk.id = talkId;
    return talk;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
