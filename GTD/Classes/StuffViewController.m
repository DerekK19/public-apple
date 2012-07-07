//
//  StuffViewController.m
//  GTD
//
//  Created by Derek Knight on 19/09/10.
//  Copyright (c) 2010 Home. All rights reserved.
//

#import "GTDAppDelegate.h"
#import "StuffModel.h"
#import "StuffViewController.h"
#import "StuffDetailViewController.h"

@implementation StuffViewController

@synthesize newButtonItem;
@synthesize saveButtonItem;

@synthesize detailViewController;

#pragma mark -
#pragma mark View lifecycle
- (void)initView:(UINavigationItem *)navItem {
    
    detailViewController = [[StuffDetailViewController alloc] initWithController: self];
    
    newButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                  target:self
                                                                  action:@selector(showAddStuffView)];
    saveButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                   target:self
                                                                   action:@selector(saveStuff)];
    [super initView:navItem];
}

- (void)initNavButton {
    [super setRightBarButtonItem:newButtonItem];    
}

- (void)viewDidLoad {
    [super viewDidLoadWithRightButton:newButtonItem];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
    NSDate *date = [managedObject valueForKey:@"entered"];
    cell.textLabel.text = [self displayDate:date];
}

- (void)showAddStuffView {
	GTDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
//    [[BlogDataManager sharedDataManager] makeNewPostCurrent];
	
	if(detailViewController == nil) {
        detailViewController = [[StuffDetailViewController alloc] initWithController: self];
	}
	[self.detailViewController refreshUIForCreate];
    
    [super showAddViewWithRightButton:saveButtonItem];
	
	[delegate showContentDetailViewController:self.detailViewController];
}

- (void)saveStuff {
    [self.detailViewController insertNewObject:self];
    [super showAddViewWithRightButton:newButtonItem];
}

#pragma mark -
#pragma mark Add a new object

- (void)insertNewObject:(id)sender
            withsubject:(NSString *)subject
         andDateEntered:(NSDate*)dateEntered {
    
    NSIndexPath *currentSelection = [self.tableView indexPathForSelectedRow];
    if (currentSelection != nil) {
        [self.tableView deselectRowAtIndexPath:currentSelection animated:NO];
    }
    
    StuffModel *stuffObject = [[StuffModel alloc] initWithFetchedResultsController:fetchedResultsController
                                                                         andDateEntered:dateEntered
                                                                             andSubject:subject];
    
    NSIndexPath *insertionPath = [fetchedResultsController indexPathForObject:[stuffObject managedObject]];
    [self.tableView selectRowAtIndexPath:insertionPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    detailViewController.detailItem = [stuffObject managedObject];
}


#pragma mark -
#pragma mark Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView: tableView cellForRowAtIndexPath:indexPath];    

    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the managed object.
        StuffModel *stuffObject = [[StuffModel alloc] initWithFetchedResultsController:fetchedResultsController forRowAtIndexPath:indexPath];
        if (detailViewController.detailItem == [stuffObject managedObject]) {
            detailViewController.detailItem = nil;
        }
        
        [stuffObject deleteWithFetchedResultsController:fetchedResultsController];
    }   
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set the detail item in the detail view controller.
    NSManagedObject *selectedObject = [super tableView:aTableView selectedRowAtIndexPath:indexPath];
    detailViewController.detailItem = selectedObject;    
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    return [super fetchedResultsControllerWithEntityName:@"Stuff" andSortKey:@"timeStamp"];
}    

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [newButtonItem release];
    [saveButtonItem release];
    [super dealloc];
}

@end
