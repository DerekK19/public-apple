//
//  OnesNotesAppDelegate.m
//  OnesNotes
//
//  Created by Derek Knight on 22/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#define THIS_LOWLEVEL_LOGGING true

#import "OnesNotesAppDelegate.h"

#import "RootViewController.h"
#import "NotebookViewController.h"
#import "SectionViewController.h"

#import "DetailViewController.h"

@implementation OnesNotesAppDelegate

@synthesize window;

@synthesize splitViewController;

@synthesize rootViewController;
@synthesize notebookViewController;
@synthesize sectionViewController;

@synthesize detailViewController;

@synthesize login;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
    // Add the split view controller's view to the window and display.
    [window addSubview:splitViewController.view];
    [window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {

    // Saves changes in the application's managed object context before the application terminates.
    NSError *error = nil;
    if (managedObjectContext) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void)dealloc {

    [window release];
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    [splitViewController release];
    [rootViewController release];
    [notebookViewController release];
    [sectionViewController release];
    [detailViewController release];
    [super dealloc];
}


/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"OnesNotes.sqlite"]];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible
         * The schema for the persistent store is incompatible with current managed object model
         Check the error message to determine what the actual problem was.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)awakeFromNib {
    // Pass the managed object context to the root view controller.
    rootViewController.managedObjectContext = self.managedObjectContext;
    rootViewController.detailViewController = self.detailViewController;
    notebookViewController.managedObjectContext = self.managedObjectContext; 
    sectionViewController.managedObjectContext = self.managedObjectContext;
}

- (IBAction)authenticateUser:(id)sender
{
    LowLevelLog(@"authenticateUser");

// These lines would by-pass the OpenID authentication
//    [rootViewController didAuthenticate];
//
//    if (1 > 0) return;
    
    JREngage *jrEngage = [JREngage jrEngageWithAppId:@"dkjmdbecjpbonbbnklcg"
                                         andTokenUrl:nil
                                            delegate:self];
    
//    NSMutableDictionary *customInterface;
//    customInterface = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                       @"stones.png", kJRProviderTableBackgroundImageName,
//                       @"stones.png", kJRUserLandingBackgroundImageName,
//                       @"stones.png", kJRSocialSharingBackgroundImageName,
//                       @"Sign in to Example App", kJRProviderTableTitle,
//                       @"Share Example App Purchase", kJRSocialSharingTitle,
//                       nil];
//    [customInterface setObject:self.navigationController
//                               forKey:kJRApplicationNavigationController];
//    [jrEngage setCustomInterfaceDefaults:customInterface];
    [jrEngage showAuthenticationDialog];
    
}

#pragma mark -
#pragma mark JREngage delegate
- (void)jrEngageDialogDidFailToShowWithError:(NSError*)error
{
    LowLevelLog(@"jrEngageDialogDidFailToShowWithError: %@", [error description]);
}
- (void)jrAuthenticationDidNotComplete
{
    LowLevelLog(@"jrAuthenticationDidNotComplete");
}
- (void)jrAuthenticationDidSucceedForUser:(NSDictionary*)auth_info
                              forProvider:(NSString*)provider
{
    LowLevelLog(@"jrAuthenticationDidSucceedForUser");
    [rootViewController didAuthenticate];
}
- (void)jrAuthenticationDidFailWithError:(NSError*)error
                             forProvider:(NSString*)provider
{
    LowLevelLog(@"jrAuthenticationDidFailWithError");
}
- (void)jrAuthenticationDidReachTokenUrl:(NSString*)tokenUrl
                            withResponse:(NSURLResponse*)response
                              andPayload:(NSData*)tokenUrlPayload
                             forProvider:(NSString*)provider
{
    LowLevelLog(@"jrAuthenticationDidReachTokenUrl");
}
- (void)jrAuthenticationCallToTokenUrl:(NSString*)tokenUrl
                      didFailWithError:(NSError*)error
                           forProvider:(NSString*)provider
{
    LowLevelLog(@"jrAuthenticationCallToTokenUrl");
}
- (void)jrSocialDidNotCompletePublishing
{
    LowLevelLog(@"jrSocialDidNotCompletePublishing");
}
- (void)jrSocialDidCompletePublishing
{
    LowLevelLog(@"jrSocialDidCompletePublishing");
}
- (void)jrSocialDidPublishActivity:(JRActivityObject*)activity
                       forProvider:(NSString*)provider
{
    LowLevelLog(@"jrSocialDidPublishActivity");
}
- (void)jrSocialPublishingActivity:(JRActivityObject*)activity
                  didFailWithError:(NSError*)error
                       forProvider:(NSString*)provider
{
    LowLevelLog(@"jrSocialPublishingActivity");
}

@end
