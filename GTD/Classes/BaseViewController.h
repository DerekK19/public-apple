//
//  BaseViewController.h
//  GTD
//
//  Created by Derek Knight on 19/09/10.
//  Copyright (c) 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface BaseViewController : UITableViewController <NSFetchedResultsControllerDelegate>  {
    
    UINavigationItem *navigator;
    
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (readonly) UINavigationItem *navigator;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)viewDidLoadWithRightButton:(UIBarButtonItem *)rightButton;
- (void)initView:(UINavigationItem *)navItem;
- (void)setRightBarButtonItem:(UIBarButtonItem *)rightButton;
- (void)showAddViewWithRightButton:(UIBarButtonItem *)rightButton;
- (void)saveWithRightButton:(UIBarButtonItem *)rightButton;
- (NSFetchedResultsController *)fetchedResultsControllerWithEntityName:(NSString *)entityName andSortKey:(NSString *)sortKey;
- (NSManagedObject *)tableView:(UITableView *)aTableView selectedRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)displayDate:(NSDate *) date;

@end
