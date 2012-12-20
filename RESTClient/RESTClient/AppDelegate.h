//
//  AppDelegate.h
//  RESTClient
//
//  Created by Darko Krizic on 2012-12-20.
//  Copyright (c) 2012 Darko Krizic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistenceStoreCoordinator;

@end