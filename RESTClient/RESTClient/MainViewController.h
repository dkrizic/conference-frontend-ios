//
//  ViewController.h
//  RESTClient
//
//  Created by Darko Krizic on 2012-12-20.
//  Copyright (c) 2012 Darko Krizic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
