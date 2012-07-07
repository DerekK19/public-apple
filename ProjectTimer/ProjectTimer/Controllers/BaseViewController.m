//
//  BaseViewController.m
//  ProjectTimer
//
//  Created by Derek Knight on 19/09/10.
//  Copyright (c) 2010 Home. All rights reserved.
//

#define LOW_LEVEL_DEBUG TRUE

#import "ProjectTimerAppDelegate.h"
#import "BaseViewController.h"

@implementation DGKBaseViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize tableView = __tableView;
@synthesize viewFactory;

- (id)initWithFetchedResultsController:(NSFetchedResultsController*)aFetchedResultsController
{
    DEBUGLog(@"%X", aFetchedResultsController);
    self = [super init];
    if (nil != self)
    {
        __fetchedResultsController = aFetchedResultsController;
    }
    return self;
}

- (void)initViewFactoryWithNib:(NSString *)nibName
{
    viewFactory = [[DGKViewFactory alloc] initWithNib:nibName];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
}

- (void)viewWillAppear:(BOOL)animated
{
    DEBUGLog(@"View appears");
    [__tableView reloadData];
}

- (void)didAuthenticate
{
    
    NSError *error = nil;
    if (![__fetchedResultsController performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[__fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[__fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:aTableView
     cellForRowAtIndexPath:indexPath
        withCellIdentifier:@"Cell"];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
            withCellIdentifier:(NSString *)cellIdentifier
{    
    UITableViewCell * cell = [viewFactory cellOfKind:cellIdentifier forTable:aTableView];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {        
        // Delete the managed object.
        NSManagedObject *objectToDelete = [__fetchedResultsController objectAtIndexPath:indexPath];
///        if (detailViewController.detailItem == objectToDelete) {
///            detailViewController.detailItem = nil;
///        }
        
        NSManagedObjectContext *context = [__fetchedResultsController managedObjectContext];
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


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Table view delegate

- (NSManagedObject *)tableView:(UITableView *)aTableView
        selectedRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set the detail item in the detail view controller.
    return [__fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark -
#pragma mark Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [__tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [__tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                       withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [__tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                       withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
                                                                atIndexPath:(NSIndexPath *)indexPath
                                                              forChangeType:(NSFetchedResultsChangeType)type
                                                               newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [__tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                               withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [__tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                               withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
//                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [__tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                               withRowAnimation:UITableViewRowAnimationFade];
            [__tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                               withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [TheRepository save];
    [__tableView endUpdates];
}

#pragma mark -
#pragma mark Utility functions

- (NSString *)displayDate:(NSDate *) date
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"dd MMM yyyy HH:mm"];
    NSString* str = [formatter stringFromDate:date];
    return str;
}

- (NSString *)displayColour:(UIColor *) color
{  
    const CGFloat *c = CGColorGetComponents(color.CGColor);  
    
    CGFloat r, g, b;  
    r = c[0];  
    g = c[1];  
    b = c[2];  
    
    // Fix range if needed  
    if (r < 0.0f) r = 0.0f;  
    if (g < 0.0f) g = 0.0f;  
    if (b < 0.0f) b = 0.0f;  
    
    if (r > 1.0f) r = 1.0f;  
    if (g > 1.0f) g = 1.0f;  
    if (b > 1.0f) b = 1.0f;  
    
    // Convert to hex string between 0x00 and 0xFF  
    return [NSString stringWithFormat:@"%02X%02X%02X",  
            (int)(r * 255), (int)(g * 255), (int)(b * 255)];  
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [super dealloc];
}

@end
