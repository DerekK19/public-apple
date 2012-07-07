//
//  ProjectTimerAppDelegate.h
//  ProjectTimer
//
//  Created by Derek Knight on 29/05/11.
//  Copyright 2011 ASB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskNavigationController.h"
#import "Repository.h"

@interface ProjectTimerAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>
{

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet DGKTaskNavigationController *navController;
@property (nonatomic, retain) IBOutlet DGKRepository *repository;

@end
