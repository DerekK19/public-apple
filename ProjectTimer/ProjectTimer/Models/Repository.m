//
//  Repository.m
//  ProjectTimer
//
//  Created by Derek Knight on 6/06/11.
//  Copyright 2011 ASB. All rights reserved.
//

#define LOW_LEVEL_DEBUG TRUE

#import "ProjectTimerAppDelegate.h"
#import "Repository.h"

@interface DGKRepository ()
- (NSFetchedResultsController *)fetchedResultsControllerWithEntityName:(NSString *)entityName
                                                            andSortKey:(NSString *)sortKey
                                                          andPredicate:(NSPredicate *)predicate;
- (NSFetchedResultsController *)fetchedResultsControllerWithEntityName:(NSString *)name
                                                            andSortKey:(NSString *)key;
- (NSFetchedResultsController *)fetchedResultsControllerWithEntityName:(NSString *)name;

@end

@implementation DGKRepository

#pragma mark -
#pragma mark Initialiser
-(id)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if (nil != self)
    {
        managedObjectContext = context;
    }
    return self;
}

#pragma mark -
#pragma mark Public functions
- (NSFetchedResultsController *)Tasks
{
    if (frcTasks != nil) return frcTasks;
    frcTasks = [self fetchedResultsControllerWithEntityName:@"Task"
                                                 andSortKey:@"Name"];
    return frcTasks;
}

- (NSFetchedResultsController *)Events
{
    if (frcEvents != nil) return frcEvents;
    frcEvents = [self fetchedResultsControllerWithEntityName:@"Event"
                                                  andSortKey:@"Start"];
    return frcEvents;
}

- (TaskModel *)createTaskWithName:(NSString *)name
                        andColour:(UIColor *)colour
                  andTotalMinutes:(NSNumber *)totalMinutes
{
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [[self Tasks] managedObjectContext];
    NSEntityDescription *entity = [[[self Tasks] fetchRequest] entity];
    
    // Create the managed object
    TaskModel *rValue = [NSEntityDescription insertNewObjectForEntityForName:[entity name]
                                                      inManagedObjectContext:context];
    [rValue initWithFetchedResultsController:[self Tasks]];
    
    // Configure the new managed object.
    rValue.timeStamp = [NSDate date];
    rValue.Name = name;
    rValue.colour = colour;
    rValue.totalMinutes = totalMinutes;
    
    [self saveTasks];
    
    return rValue;
}

- (EventModel *)createEventForTask:(TaskModel *)task
{
//    [task initWithFetchedResultsController:[self Tasks]];
    
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [[self Events] managedObjectContext];
    NSEntityDescription *entity = [[[self Events] fetchRequest] entity];
    
    // Create the managed object
    EventModel *rValue = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    [rValue initWithFetchedResultsController: [self Events]];
    
    // Configure the new managed object.
    rValue.task = task;
    rValue.timeStamp = [NSDate date];
    rValue.Start = [NSDate date];
    
    [self saveEvents];
    
    DEBUGLog(@"Task %@ has %d events", task.Name, [task.events count]);
    
    return rValue;
}

#pragma mark -
#pragma mark Finders
- (TaskModel *)findTaskForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskModel *rValue = [[self Tasks] objectAtIndexPath:indexPath];
    [rValue initWithFetchedResultsController:[self Tasks]];
    return rValue;
}

- (TaskModel *)findTaskWithName: (NSString *)Name {
    NSManagedObjectContext *context = [[self Tasks] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Task"
                                                         inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(Name = %@)", Name];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    if (objects == nil)
    {
        NSLog(@"oops");
        return nil;
    }
    if ([objects count] <= 0)
    {
        NSLog(@"No record");
        return nil;
    }
    TaskModel *rValue = [objects objectAtIndex:0];    
    [rValue initWithFetchedResultsController:[self Tasks]];
    return rValue;
}

- (EventModel *)findEventForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventModel *rValue = [[self Events] objectAtIndexPath:indexPath];
    [rValue initWithFetchedResultsController:[self Events]];
    return rValue;
}

- (EventModel *)findEventWithStartTime: (NSDate *)StartTime
{
    NSManagedObjectContext *context = [[self Events] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Event"
                                                         inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(Start = %@)", StartTime];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    if (objects == nil)
    {
        NSLog(@"oops");
        return nil;
    }
    if ([objects count] <= 0)
    {
        NSLog(@"No record");
        return nil;
    }
    EventModel *rValue = [objects objectAtIndex:0];    
    [rValue initWithFetchedResultsController:[self Events]];
    return rValue;
}

#pragma mark -
#pragma mark Savers
- (void)save
{
    [self saveTasks];
    [self saveEvents];
}

- (void)saveTasks
{
    NSManagedObjectContext *context = [[self Tasks] managedObjectContext];
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
}

- (void)saveEvents
{
    NSManagedObjectContext *context = [[self Events] managedObjectContext];
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
}

#pragma mark -
#pragma mark Internal convenience methods
- (NSFetchedResultsController *)fetchedResultsControllerWithEntityName:(NSString *)name
{
    NSFetchedResultsController *rValue;
    rValue = [self fetchedResultsControllerWithEntityName:name
                                               andSortKey:nil
                                             andPredicate:nil];
    return rValue;
}

- (NSFetchedResultsController *)fetchedResultsControllerWithEntityName:(NSString *)name
                                                            andSortKey:(NSString *)key
{
    NSFetchedResultsController *rValue;
    rValue = [self fetchedResultsControllerWithEntityName:name
                                               andSortKey:key
                                             andPredicate:nil];
    return rValue;
}

- (NSFetchedResultsController *)fetchedResultsControllerWithEntityName:(NSString *)entityName
                                                            andSortKey:(NSString *)sortKey
                                                          andPredicate:(NSPredicate *)predicate
{
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity and set an appropriate batch size
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    // Set up a sort order and predicate
    if (sortKey != nil)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey
                                                                       ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [sortDescriptor release];
        [sortDescriptors release];
    }
    if (predicate != nil)
    {
        [fetchRequest setPredicate:predicate];
    }
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *rValue = [[NSFetchedResultsController alloc]
                                          initWithFetchRequest:fetchRequest
                                          managedObjectContext:managedObjectContext
                                            sectionNameKeyPath:nil
                                                     cacheName:nil];
    rValue.delegate = self;
    
    [fetchRequest release];
    
    return rValue;
}    


#pragma mark -
#pragma mark Fetched results controller delegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSManagedObjectContext *context = [controller managedObjectContext];
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        ERRORLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    if (controller == [self Tasks])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TASKS object:self];        
    }
    else if (controller == [self Events])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_EVENTS object:self];        
    }
}

@end
