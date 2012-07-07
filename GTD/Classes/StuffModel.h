//
//  StuffModel.h
//  GTD
//
//  Created by Derek Knight on 10/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface StuffModel : NSManagedObject {

    NSManagedObject *managedObject;
}

@property (readonly) NSManagedObject *managedObject;

- (StuffModel *)initWithFetchedResultsController: (NSFetchedResultsController *)fetchedResultsController
                                  andDateEntered: (NSDate *)dateEntered
                                      andSubject: (NSString *)subject;

- (StuffModel *)initWithFetchedResultsController: (NSFetchedResultsController *)fetchedResultsController
                               forRowAtIndexPath: (NSIndexPath *)indexPath;

- (void)deleteWithFetchedResultsController: (NSFetchedResultsController *)fetchedResultsController;

@end
