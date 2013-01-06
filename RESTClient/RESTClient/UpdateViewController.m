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
    [self updateContent];
}

- (void) updateContent
{
    [self markAllUntouched];
    
    // Load JSON Strin gfrom URL
    NSURL *url = [NSURL URLWithString:@"http://conference-krizic.rhcloud.com/rest/talk/all"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSLog(@"Starting access");
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"Access finished");
    
    // Deserialize JSON
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

    NSArray *speakers = [talk objectForKey:@"speakers"];
    NSSet *speakerEntities = [self handleSpeakers:speakers];
    
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
    talkEntity.touched = [NSNumber numberWithBool:YES];
    talkEntity.speakers = speakerEntities;
}

- (NSSet *) handleSpeakers:(NSArray *)speakers {
    NSLog(@"Handling speakers %@", speakers );
    NSMutableSet *speakerEntities = [[NSMutableSet alloc] init];
    for( NSDictionary *speaker in speakers ) {
        Speaker *speakerEntity = [self handleSpeaker:speaker];
        [speakerEntities addObject:speakerEntity];
    }
    return speakerEntities;
}

- (Speaker *) handleSpeaker:(NSDictionary *)speaker {
    NSLog(@"Handling speaker %@", speaker );
    NSString *speakerId = [speaker objectForKey:@"id"];
    NSString *name = [speaker objectForKey:@"name"];
    
    Speaker *speakerEntity = [self speakerById:speakerId];
    if( speakerEntity == nil ) {
        speakerEntity = [self createSpeakerWithId:speakerId];
    }
    speakerEntity.id = speakerId;
    speakerEntity.name = name;
    speakerEntity.touched = [NSNumber numberWithBool:YES];
    return speakerEntity;
}

- (Speaker *)speakerById:(NSString *)speakerId
{
    NSEntityDescription *roomType = [NSEntityDescription entityForName:@"Speaker" inManagedObjectContext:managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id=%@", speakerId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:roomType];
    [request setPredicate:predicate];
    NSArray *speakers = [managedObjectContext executeFetchRequest:request error:nil];
    if( speakers.count == 0 ) {
        return nil;
    }
    Speaker *speaker = (Speaker *) [speakers lastObject];
    return speaker;
}

- (Speaker *) createSpeakerWithId:(NSString *)speakerId;
{
    Speaker *speaker = (Speaker *) [NSEntityDescription insertNewObjectForEntityForName:@"Speaker" inManagedObjectContext:managedObjectContext];
    speaker.id = speakerId;
    return speaker;
}

- (Room *) handleRoom:(NSDictionary *)room {
    NSString *roomId = [room objectForKey:@"id"];
    NSString *name = [room objectForKey:@"name"];
    NSNumber *capacity = [room objectForKey:@"capacity"];
    NSLog(@"%@ %@ %@", roomId, name, capacity);
    
    Room *roomEntity = [self roomById:roomId];
    if( roomEntity == nil ) {
        roomEntity = [self createRoomWithId:roomId];
        NSLog(@"Created new room for %@", room );
    } else {
        NSLog(@"Reusing existing room %@", roomEntity);
    }
    roomEntity.id = roomId;
    roomEntity.name = name;
    roomEntity.capacity = capacity;
    roomEntity.updated = [NSNumber numberWithBool:YES];
    roomEntity.touched = [NSNumber numberWithBool:YES];
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
    NSEntityDescription *talkType = [NSEntityDescription entityForName:@"Talk" inManagedObjectContext:managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id=%@", roomId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:talkType];
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

- (void)markAllUntouched
{
    [self markTalksUntouched];
    [self markRoomsUntouched];
    [self markSpeakersUntouched];
}

- (void)markTalksUntouched
{
    NSEntityDescription *talkType = [NSEntityDescription entityForName:@"Talk" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:talkType];
    NSArray *talks = [managedObjectContext executeFetchRequest:request error:nil];
    if( talks != nil ) {
        for( Talk *talk in talks ) {
            talk.touched = NO;
        }
    }
}

- (void)markRoomsUntouched
{
    NSEntityDescription *roomType = [NSEntityDescription entityForName:@"Room" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:roomType];
    NSArray *rooms = [managedObjectContext executeFetchRequest:request error:nil];
    if( rooms != nil ) {
        for( Room *room in rooms ) {
            room.touched = NO;
        }
    }
}

- (void)markSpeakersUntouched
{
    NSEntityDescription *speakerType = [NSEntityDescription entityForName:@"Speaker" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:speakerType];
    NSArray *speakers = [managedObjectContext executeFetchRequest:request error:nil];
    if( speakers != nil ) {
        for( Speaker *speaker in speakers ) {
            speaker.touched = NO;
        }
    }
}

@end
