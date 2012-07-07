//
//  CurrentViewController.m
//  ProjectTimer
//
//  Created by Derek Knight on 6/06/11.
//  Copyright 2011 ASB. All rights reserved.
//

#define LOW_LEVEL_DEBUG TRUE

#import "CurrentViewController.h"

@implementation DGKCurrentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tasksChanged:)
                                                     name:NOTIFICATION_TASKS
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_TASKS
                                                  object:nil];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [super initViewFactoryWithNib:@"TableViewCells"];
    [super initWithFetchedResultsController:[TheRepository Tasks]];
    [super didAuthenticate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)configureCell:(DGKCurrentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{    
    TaskModel *managedObject = [[super fetchedResultsController] objectAtIndexPath:indexPath];
    cell.label.text = managedObject.Name;
    cell.detail.text = [managedObject PrettyPrintTimeToday];
    // or  [NSString stringWithFormat:@"%@ - %@", managedObject.Name, managedObject.timeStamp];
}

#pragma mark -
#pragma mark Table view delegate
- (UITableViewCell *)tableView:(UITableView *)aTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[super tableView]dequeueReusableCellWithIdentifier:@"WorkCell"];
    
    if (cell == nil)
    {
        cell = [[DGKCurrentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"WorkCell"];
    }    
    // Configure the cell.
    [self configureCell:(DGKCurrentTableViewCell *)cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object.
        TaskModel *theObject = [TheRepository findTaskForRowAtIndexPath:indexPath];
        [theObject delete];
    }   
}

- (void)tableView:(UITableView *)aTableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskModel *managedObject = [[super fetchedResultsController] objectAtIndexPath:indexPath];
    cell.backgroundColor = managedObject.colour;
}

- (void)tableView:(UITableView *)aTableView
didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set the detail item in the detail view controller.
    TaskModel *selectedObject = (TaskModel *)[super tableView:aTableView selectedRowAtIndexPath:indexPath];    
    DGKCurrentTableViewCell *cell = (DGKCurrentTableViewCell *)[aTableView cellForRowAtIndexPath:indexPath];
    
    DEBUGLog(@"De-Selected %@", selectedObject.Name);    

    [cell showTaskStopped];
}

- (void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set the detail item in the detail view controller.
    TaskModel *selectedObject = (TaskModel *)[super tableView:aTableView selectedRowAtIndexPath:indexPath];  
    DGKCurrentTableViewCell *cell = (DGKCurrentTableViewCell *)[aTableView cellForRowAtIndexPath:indexPath];
    
    DEBUGLog(@"Selected %@", selectedObject.Name);

    [cell showTaskRunning];
    
    EventModel *event = [TheRepository createEventForTask:selectedObject];    
}

#pragma mark -
#pragma mark Repository Notification receiver
- (void)tasksChanged:(NSNotification *)note
{
    [[super tableView]reloadData];
}

@end
