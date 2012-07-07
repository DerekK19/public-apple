//
//  StuffViewController.m
//  GTD
//
//  Created by Derek Knight on 19/09/10.
//  Copyright (c) 2010 Home. All rights reserved.
//

#import "OnesNotesAppDelegate.h"
#import "BaseViewController.h"
#import "Common.h"

@implementation BaseViewController

@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize navigator;
@synthesize modelFactory;

- (NSURL *) webServiceURL
{
	return [NSURL URLWithString:[NSString stringWithFormat: @"%@/%@", URLRoot, WebService]];
}
- (NSString *) webServiceNameSpace
{
    return NameSpace;
}
- (NSString *) webServiceInterface
{
    return Interface;
}


- (id)init {

    logging = true;
    encrypt = false;
    
    return [super init];
}

- (void)initFetchedResultsControllerWithEntityName : (NSString *) name
                                        andSortKey : (NSString *)key {
    fetchedResultsController = [self fetchedResultsControllerWithEntityName:name
                                                                 andSortKey:key
                                                               andPredicate:nil];
    modelFactory = [[ModelFactory alloc] initFactoryWithFetchedResultsController:fetchedResultsController];
    [self init];
}

- (void)initFetchedResultsControllerWithEntityName : (NSString *) name
                                        andSortKey : (NSString *)key
                                      andPredicate : (NSPredicate*)predicate {
    fetchedResultsController = [self fetchedResultsControllerWithEntityName:name
                                                                 andSortKey:key
                                                               andPredicate:predicate];
    modelFactory = [[ModelFactory alloc] initFactoryWithFetchedResultsController:fetchedResultsController];
    [self init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    }
    return self;
}

-(void)callWebServiceWithDelegate:(id)delegate
                        andMethod:(NSString *)method, ...
{
    va_list varargs;
    va_start(varargs, method);
    
    soap = [[DKXMLSOAPRequest alloc]initWithDelegate:self
                                          andLogging:logging
                                       useEncryption:encrypt];
    [soap callWebService:[self webServiceURL]
           withNamespace:[self webServiceNameSpace]
            andInterface:[self webServiceInterface]
               andMethod:method
          withParameters:varargs];
    
    va_end(varargs);
}

#pragma mark -
#pragma mark View lifecycle
- (void)initView:(UINavigationItem *)navItem {
    
    navigator = navItem;
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightButton {    
    [self.navigator setRightBarButtonItem:rightButton animated:YES];
}

- (void)viewDidLoadWithRightButton:(UIBarButtonItem *)rightButton {
    
    [self viewDidLoad];
    [self.navigator setRightBarButtonItem:rightButton animated:YES];    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
}

- (void)didAuthenticate
{
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.    
    return YES;
}

- (void)showAddViewWithRightButton:(UIBarButtonItem *)rightButton {    
    [self setRightBarButtonItem:rightButton];
}

- (void)saveWithRightButton:(UIBarButtonItem *)rightButton {
    [self setRightBarButtonItem:rightButton];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the managed object.
        NSManagedObject *objectToDelete = [fetchedResultsController objectAtIndexPath:indexPath];
///        if (detailViewController.detailItem == objectToDelete) {
///            detailViewController.detailItem = nil;
///        }
        
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


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Table view delegate

- (NSManagedObject *)tableView:(UITableView *)aTableView selectedRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set the detail item in the detail view controller.
    return [[self fetchedResultsController] objectAtIndexPath:indexPath];

}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsControllerWithEntityName:(NSString *)entityName
                                                            andSortKey:(NSString *)sortKey
                                                          andPredicate:(NSPredicate *)predicate {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    if (predicate != nil)
    {
        [fetchRequest setPredicate:predicate];
    }
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    return fetchedResultsController;
}    


#pragma mark -
#pragma mark Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
                                                                     atIndex:(NSUInteger)sectionIndex
                                                               forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
                                                                atIndexPath:(NSIndexPath *)indexPath
                                                              forChangeType:(NSFetchedResultsChangeType)type
                                                               newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
///            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark -
#pragma mark Utility functions

- (NSString *)displayDate:(NSDate *) date {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"dd MMM yyyy HH:mm"];
    NSString* str = [formatter stringFromDate:date];
    return str;
}

- (NSString *)displayColour:(UIColor *) color {  
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

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
//    [soap dealloc];
    [super dealloc];
}


@end
