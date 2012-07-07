//
//  SecondViewController.m
//  ProjectTimer
//
//  Created by Derek Knight on 29/05/11.
//  Copyright 2011 ASB. All rights reserved.
//

#define LOW_LEVEL_DEBUG FALSE

#import "EventViewController.h"

@implementation DGKEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(eventsChanged:)
                                                     name:NOTIFICATION_EVENTS
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_EVENTS
                                                  object:nil];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [TheNavController pushContextWithTitle:@"All Events"
                            andRightButton:nil];
    [TheNavController setDelegate:self];
    
    [super initViewFactoryWithNib:@"TableViewCells"];
    [super initWithFetchedResultsController:[TheRepository Events]];
    [super didAuthenticate];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark TableView data source
- (BOOL)canFindObjectWithName:(NSDate *)StartTime
{
    EventModel *foundObject = [TheRepository findEventWithStartTime:StartTime];
    return foundObject != nil;
}

- (void)insertNewObject:(id)sender
               withName:(NSString *)name
              andColour:(UIColor *)colour
               andNotes:(NSString *)notes
        andTotalMinutes:(NSNumber *)totalMinutes
{
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{    
    EventModel *managedObject = [[super fetchedResultsController] objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", managedObject.task.Name, managedObject.Start];
    // or  [NSString stringWithFormat:@"%@ - %@", managedObject.Name, managedObject.timeStamp];
}

#pragma mark -
#pragma mark Table view delegate
- (UITableViewCell *)tableView:(UITableView *)aTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [super tableView:aTableView
                       cellForRowAtIndexPath:indexPath
                          withCellIdentifier:@"TaskCell"];    
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object.
        EventModel *theObject = [TheRepository findEventForRowAtIndexPath:indexPath];
        [theObject delete];
    }   
}

- (void)tableView:(UITableView *)aTableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventModel *managedObject = [[super fetchedResultsController] objectAtIndexPath:indexPath];
    cell.backgroundColor = managedObject.task.colour;
}

- (void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set the detail item in the detail view controller.
    EventModel *selectedObject = (EventModel *)[super tableView:aTableView selectedRowAtIndexPath:indexPath];
}

#pragma mark -
#pragma mark Repository Notification receiver
- (void)eventsChanged:(NSNotification *)note
{
    [TheRepository saveEvents];
    [[super tableView]reloadData];
}

#pragma mark -
#pragma mark Navigation Controller Delegate
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    DEBUGLog(@"%@", viewController);
}
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    DEBUGLog(@"%@", viewController);
    [super.tableView reloadData];
}

@end
