//
//  GTDAppDelegate.h
//  GTD
//
//  Created by Derek Knight on 19/09/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@class RootViewController;
@class DetailViewController;

@interface GTDAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;

    IBOutlet UINavigationController *navigationController;

	UISplitViewController *splitViewController;

	RootViewController *rootViewController;
	DetailViewController *detailViewController;

    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) UINavigationController *navigationController;

@property (readonly, nonatomic, retain) UINavigationController *detailNavigationController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;
- (void)showContentDetailViewController:(UIViewController *)viewController;

@end
