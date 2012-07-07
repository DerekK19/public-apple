//
//  FirstViewController.m
//  ProjectTimer
//
//  Created by Derek Knight on 29/05/11.
//  Copyright 2011 ASB. All rights reserved.
//

#define LOW_LEVEL_DEBUG TRUE

#import "TaskViewController.h"

@implementation DGKTaskViewController

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
    [rButton release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    rButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                           target:self
                                                           action:@selector(addTask:)];
    [TheNavController pushContextWithTitle:@"All Tasks"
                            andRightButton:rButton];
    [TheNavController setDelegate:self];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark TableView data source
- (BOOL)canFindObjectWithName:(NSString *)Name
{
    TaskModel *foundObject = [TheRepository findTaskWithName:Name];
    return foundObject != nil;
}

- (void)insertNewObject:(id)sender
               withName:(NSString *)name
              andColour:(UIColor *)colour
               andNotes:(NSString *)notes
        andTotalMinutes:(NSNumber *)totalMinutes
{
    
    NSIndexPath *currentSelection = [super.tableView indexPathForSelectedRow];
    if (currentSelection != nil)
    {
        [super.tableView deselectRowAtIndexPath:currentSelection
                                       animated:NO];
    }
    
    TaskModel *newObject = [TheRepository createTaskWithName:name
                                                  andColour:colour
                                            andTotalMinutes:totalMinutes];
    
    NSIndexPath *insertionPath = [[super fetchedResultsController] indexPathForObject:newObject];
    [super.tableView selectRowAtIndexPath:insertionPath
                                 animated:YES
                           scrollPosition:UITableViewScrollPositionTop];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{    
    TaskModel *managedObject = [[super fetchedResultsController] objectAtIndexPath:indexPath];
    cell.textLabel.text = managedObject.Name;
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
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set the detail item in the detail view controller.
    TaskModel *selectedObject = (TaskModel *)[super tableView:aTableView selectedRowAtIndexPath:indexPath];
    
    DGKTaskDetailViewController *detailViewController;
    detailViewController = [[DGKTaskDetailViewController alloc] initWithNibName:@"TaskDetailView-iPhone"
                                                                         bundle:nil];
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
    [detailViewController initWithTask:selectedObject];
    [detailViewController release];
}

#pragma mark -
#pragma mark Repository Notification receiver
- (void)tasksChanged:(NSNotification *)note
{
    [TheRepository saveTasks];
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

#pragma mark -
#pragma mark Delegates
- (IBAction)addTask:(id)sender
{
    NSInteger totalMinutes = 600;
    [self insertNewObject:sender
                 withName:@"New Task"
                andColour:[UIColor yellowColor]
                 andNotes:@""
          andTotalMinutes:[NSNumber numberWithInt:totalMinutes]];
}

@end
