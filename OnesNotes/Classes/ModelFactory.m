//
//  ModelFactory.m
//  GTD
//
//  Created by Derek Knight on 14/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import "ModelFactory.h"

@implementation ModelFactory

#pragma mark -
#pragma mark Initialisers

- (ModelFactory *) initFactoryWithFetchedResultsController:(NSFetchedResultsController *)aFetchedResultsController {
    fetchedResultsController = aFetchedResultsController;
    return self;
}

#pragma mark -
#pragma mark Creators

- (NotebookModel *) createNotebookWithName:(NSString *)name
                               andNickname:(NSString *)nickname
                                     andID:(NSString *)GUID
                                   andPath:(NSString *)path
                       andLastModifiedTime:(NSDate *)modified
                                 andColour:(NSString *)colour {
    
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
    
    // Create the managed object
    NotebookModel *rValue = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    [rValue initWithFetchedResultsController: fetchedResultsController];
    
    // Configure the new managed object.
    rValue.timeStamp = [NSDate date];
    rValue.name = name;
    rValue.nickname = nickname;
    rValue.modified = modified;
    rValue.GUID = GUID;
    rValue.path = path;
    rValue.colour = [rValue colourWithHexString: colour];
    
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
    

    return rValue;
}

- (NotebookModel *) createNotebookForRowAtIndexPath: (NSIndexPath *)indexPath {
    
    NotebookModel *rValue = [fetchedResultsController objectAtIndexPath:indexPath];
    
    return rValue;
}

- (SectionModel *) createSectionWithNotebook:(NotebookModel *)notebook
                                     andName:(NSString *)name
                                       andID:(NSString *)GUID
                                     andPath:(NSString *)path
                         andLastModifiedTime:(NSDate *)modified
                                   andColour:(NSString *)colour {
    

    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
    
    // Create the managed object
    SectionModel *rValue = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    [rValue initWithFetchedResultsController: fetchedResultsController];
    
    // Configure the new managed object.
    rValue.timeStamp = [NSDate date];
    rValue.name = name;
    rValue.modified = modified;
    rValue.GUID = GUID;
    rValue.path = path;
    rValue.colour = [rValue colourWithHexString: colour];
    rValue.notebook = notebook;
    rValue.notebookGUID = notebook.GUID;
    
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
    
    
    return rValue;
}

- (SectionModel *) createSectionForRowAtIndexPath: (NSIndexPath *)indexPath {

    SectionModel *rValue = [fetchedResultsController objectAtIndexPath:indexPath];
    
    return rValue;    
}

- (PageModel *) createPageWithSection:(SectionModel *)section
                              andName:(NSString *)name
                                andID:(NSString *)GUID
                             andLevel:(NSString *)pagelLevel
                  andLastModifiedTime:(NSDate *)modified
                      andInsertedTime:(NSDate *)inserted {
    
    
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
    
    // Create the managed object
    PageModel *rValue = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    [rValue initWithFetchedResultsController: fetchedResultsController];
    
    // Configure the new managed object.
    rValue.timeStamp = [NSDate date];
    rValue.name = name;
    rValue.modified = modified;
    rValue.GUID = GUID;
    rValue.level = pagelLevel;
    rValue.inserted = inserted;
    rValue.section = section;
    rValue.sectionGUID = section.GUID;
    
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
    
    
    return rValue;
}

- (PageModel *) createPageForRowAtIndexPath: (NSIndexPath *)indexPath {
    
    PageModel *rValue = [fetchedResultsController objectAtIndexPath:indexPath];
    
    return rValue;    
}

#pragma mark -
#pragma mark Finders

- (NotebookModel *) findNotebookWithGUID: (NSString *)GUID {
    NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Notebook"
                                                         inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(GUID = %@)", GUID];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    if (objects == nil)
    {
        NSLog(@"oops");
        return nil;
    }
    if ([objects count] > 0)
        return [objects objectAtIndex:0];
    return nil;
}

- (SectionModel *) findSectionWithGUID: (NSString *)GUID {
    NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Section"
                                                         inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(GUID = %@)", GUID];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    if (objects == nil)
    {
        NSLog(@"oops");
        return nil;
    }
    if ([objects count] > 0)
        return [objects objectAtIndex:0];
    return nil;
}

- (PageModel *) findPageWithGUID: (NSString *)GUID {
    NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Page"
                                                         inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(GUID = %@)", GUID];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    if (objects == nil)
    {
        NSLog(@"oops");
        return nil;
    }
    if ([objects count] > 0)
        return [objects objectAtIndex:0];
    return nil;
}


@end
