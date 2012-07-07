//
//  DoViewController.m
//  GTD
//
//  Created by Derek Knight on 19/09/10.
//  Copyright (c) 2010 Home. All rights reserved.
//

#import "GTDAppDelegate.h"
#import "DoViewController.h"
#import "DoDetailViewController.h"

@implementation DoViewController

@synthesize newButtonItem;
@synthesize saveButtonItem;

@synthesize detailViewController;

#pragma mark -
#pragma mark View lifecycle
- (void)initView:(UINavigationItem *)navItem {
    
    detailViewController = [[DoDetailViewController alloc] initWithController: self];
    
    newButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                  target:self
                                                                  action:@selector(showAddToDoView)];
    saveButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                   target:self
                                                                   action:@selector(saveToDo)];
    [super initView:navItem];
}

- (void)initNavButton {
    [super setRightBarButtonItem:newButtonItem];    
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoadWithRightButton:newButtonItem];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
    NSDate *date = [managedObject valueForKey:@"entered"];
    cell.textLabel.text = [self displayDate:date];
}

- (void)showAddToDoView {
	GTDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
//    [[BlogDataManager sharedDataManager] makeNewPostCurrent];
	
	if(detailViewController == nil) {
		self.detailViewController = [[DoDetailViewController alloc] initWithController: self];
	}
	[self.detailViewController refreshUIForCreate];
	
    [super showAddViewWithRightButton:saveButtonItem];

	[delegate showContentDetailViewController:self.detailViewController];
}

- (void)saveToDo {
    [self.detailViewController insertNewObject:self];
    [self.navigator setRightBarButtonItem:newButtonItem animated:YES];
}

#pragma mark -
#pragma mark Add a new object

- (void)insertNewObject:(id)sender
            withsubject:(NSString *)subject
         andDateEntered:(NSDate*)dateEntered
             andDateDue:(NSDate*)dateDue {
    
    NSIndexPath *currentSelection = [self.tableView indexPathForSelectedRow];
    if (currentSelection != nil) {
        [self.tableView deselectRowAtIndexPath:currentSelection animated:NO];
    }    
    
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    [newManagedObject setValue:dateDue forKey:@"due"];
    [newManagedObject setValue:dateEntered forKey:@"entered"];
    [newManagedObject setValue:subject forKey:@"subject"];
    
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
    
    NSIndexPath *insertionPath = [fetchedResultsController indexPathForObject:newManagedObject];
    [self.tableView selectRowAtIndexPath:insertionPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    detailViewController.detailItem = newManagedObject;
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
        NSManagedObject *objectToDelete = [fetchedResultsController objectAtIndexPath:indexPath];
        if (detailViewController.detailItem == objectToDelete) {
            detailViewController.detailItem = nil;
        }
        
        NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
        [context deleteObject:objectToDelete];
        
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
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set the detail item in the detail view controller.
    NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    detailViewController.detailItem = selectedObject;    
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    return [super fetchedResultsControllerWithEntityName:@"ToDo" andSortKey:@"timeStamp"];
}    

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [newButtonItem release];
    [saveButtonItem release];
    [super dealloc];
}

@end
