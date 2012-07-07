//
//  OnesNotesAppDelegate.h
//  OnesNotes
//
//  Created by Derek Knight on 22/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JREngage+CustomInterface.h"

@class RootViewController;
@class NotebookViewController;
@class SectionViewController;

@class DetailViewController;

@interface OnesNotesAppDelegate : NSObject <UIApplicationDelegate, JREngageDelegate> {
    UIWindow *window;
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    UISplitViewController *splitViewController;
    RootViewController *rootViewController;
    NotebookViewController *notebookViewController;
    SectionViewController *sectionViewController;
    DetailViewController *detailViewController;
    UIBarButtonItem *login;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;

@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet NotebookViewController *notebookViewController;
@property (nonatomic, retain) IBOutlet SectionViewController *sectionViewController;

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain)IBOutlet UIBarButtonItem *login;

- (IBAction)authenticateUser:(id)sender;

@end
