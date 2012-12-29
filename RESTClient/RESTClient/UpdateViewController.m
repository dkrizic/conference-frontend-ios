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
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Did laod");
    NSStringEncoding *encoding = NULL;
    NSError *error;
    NSURL *jsonURL = [NSURL URLWithString:@"http://conference-krizic.rhcloud.com/rest/talk/all"];
    NSLog(@"Starting access");
    NSString *jsonData = [[NSString alloc] initWithContentsOfURL:jsonURL usedEncoding:encoding error:&error];
    NSLog(@"Access finished");
    NSLog(jsonData);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
