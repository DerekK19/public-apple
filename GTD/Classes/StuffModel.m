//
//  StuffModel.m
//  GTD
//
//  Created by Derek Knight on 10/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import "StuffModel.h"

@implementation StuffModel

@synthesize managedObject;

- (StuffModel *)initWithFetchedResultsController: (NSFetchedResultsController *)fetchedResultsController
                          andDateEntered:(NSDate *)dateEntered
                              andSubject:(NSString *)subject {
    
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];

    // Create the managed object
    managedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // Configure the new managed object.
    [managedObject setValue:[NSDate date] forKey:@"timeStamp"];
    [managedObject setValue:dateEntered forKey:@"entered"];
    [managedObject setValue:subject forKey:@"subject"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return self;
}

- (StuffModel *)initWithFetchedResultsController: (NSFetchedResultsController *)fetchedResultsController
                               forRowAtIndexPath: (NSIndexPath *)indexPath {
    managedObject = [fetchedResultsController objectAtIndexPath:indexPath];

    return self;
}

- (void)deleteWithFetchedResultsController: (NSFetchedResultsController *)fetchedResultsController {
    
    NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
    [context deleteObject:managedObject];
    
    NSError *error;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

@end
