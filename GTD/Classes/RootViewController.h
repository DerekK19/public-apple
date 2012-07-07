//
//  RootViewController.h
//  GTD
//
//  Created by Derek Knight on 19/09/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class RootDetailViewController;

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    
    RootDetailViewController *detailViewController;

    id <UITableViewDataSource, UITableViewDelegate> currentDataSource;

    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) IBOutlet RootDetailViewController *detailViewController;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)insertNewObject:(id)sender;

@end
