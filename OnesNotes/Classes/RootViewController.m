//
//  RootViewController.m
//  OnesNotes
//
//  Created by Derek Knight on 22/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import "RootViewController.h"
#import "NotebookViewController.h"
#import "DetailViewController.h"
#import "Common.h"
#import "NotebookModel.h"

@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation RootViewController
		
@synthesize detailViewController;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{    
    [super viewDidLoad];
}

- (void) didAuthenticate
{
    [super initFetchedResultsControllerWithEntityName: @"Notebook"
                                           andSortKey:@"timeStamp"];
    [super didAuthenticate];
    self.navigationItem.title = @"Notebooks";
    [self resetSOAP:nil];    
    [self synchroniseNotebooks:nil];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark TableView data source

- (BOOL)findObjectWithGUID:(NSString *)GUID {
    NotebookModel *findObject = [modelFactory findNotebookWithGUID:GUID];
    return findObject != nil;
}

- (void)insertNewObject:(id)sender
               withName:(NSString *)name
            andNickname:(NSString *)nickname
                  andID:(NSString *)GUID
                andPath:(NSString *)path
    andLastModifiedTime:(NSDate *)modifiedTime
              andColour:(NSString *)colour {
    
    NSIndexPath *currentSelection = [self.tableView indexPathForSelectedRow];
    if (currentSelection != nil) {
        [self.tableView deselectRowAtIndexPath:currentSelection animated:NO];
    }
    
    NotebookModel *newObject = [modelFactory createNotebookWithName:name
                                                        andNickname:nickname
                                                              andID:GUID
                                                            andPath:path
                                                andLastModifiedTime:modifiedTime
                                                          andColour:colour];
    
    NSIndexPath *insertionPath = [fetchedResultsController indexPathForObject:newObject];
    [self.tableView selectRowAtIndexPath:insertionPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    detailViewController.detailItem = newObject;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NotebookModel *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = managedObject.name;
}

#pragma mark -
#pragma mark Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView: tableView cellForRowAtIndexPath:indexPath];    
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the managed object.
        NotebookModel *theObject = [modelFactory createNotebookForRowAtIndexPath:indexPath];
        if (detailViewController.detailItem == theObject) {
            detailViewController.detailItem = nil;
        }        
        [theObject delete];
    }   
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotebookModel *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.backgroundColor = managedObject.colour;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set the detail item in the detail view controller.
    NotebookModel *selectedObject = (NotebookModel *)[super tableView:aTableView selectedRowAtIndexPath:indexPath];
    detailViewController.detailItem = selectedObject;    
    
    //Navigation logic may go here. Create and push another view controller.
    //NSString *GUID = selectedObject.GUID;
    //    
    NotebookViewController *subViewController = [NotebookViewController alloc];
    subViewController.managedObjectContext = self.managedObjectContext;
    subViewController.detailViewController = self.detailViewController;
    [subViewController initWithNotebook:selectedObject];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:subViewController animated:YES];
    [subViewController release];
}

#pragma mark -
#pragma mark Fetched results controller delegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
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
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
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
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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


/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

#pragma mark SOAP callbacks
-(void) xmlsoap:(DKXMLSOAPRequest *)xmlsoap foundResult:(NSString *)methodName :(NSString *)result
{
    [xmlsoap release];
	if( xmlParser )
	{
		[xmlParser release];
	}
	xmlParser = [[NSXMLParser alloc] initWithData: [result dataUsingEncoding:NSUTF8StringEncoding]];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
}

-(void) xmlsoap:(DKXMLSOAPRequest *)xmlsoap foundFault:(NSString *)methodName :(NSString *)fault
{
    [xmlsoap release];
	//status.text = fault;
}

#pragma mark Parser callbacks
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)xmlElementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if([xmlElementName isEqualToString:@"message"] ||
       [xmlElementName isEqualToString:@"error"])
	{
		if(!xmlValue)
		{
			xmlValue = [[NSMutableString alloc] init];
		}
		xmlResults = TRUE;
	}
	if([xmlElementName isEqualToString:@"one:Notebook"])
	{
        NSString *name =  [NSString stringWithFormat: @"%@", [attributeDict valueForKey:@"name"]];
        NSString *nickname =  [NSString stringWithFormat: @"%@", [attributeDict valueForKey:@"nickname"]];
        NSString *GUID =  [NSString stringWithFormat: @"%@", [attributeDict valueForKey:@"ID"]];
        NSString *path =  [NSString stringWithFormat: @"%@", [attributeDict valueForKey:@"path"]];
        NSString *colour =  [NSString stringWithFormat: @"%@", [attributeDict valueForKey:@"color"]];
        NSString *temp =  [NSString stringWithFormat: @"%@", [attributeDict valueForKey:@"lastModifiedTime"]];
        NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        NSDate *modified = [dateFormatter dateFromString:temp];
        
        if (![self findObjectWithGUID:GUID])
        {
            [self insertNewObject:nil
                         withName:name
                      andNickname:nickname
                            andID:GUID
                          andPath:path
              andLastModifiedTime:modified
                        andColour:colour];
        }
		xmlResults = FALSE;
	}
	
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if( recordResults )
	{
		[soapResults appendString: string];
	}
	if( xmlResults )
	{
		[xmlValue appendString: string];
	}
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)xmlElementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([xmlElementName isEqualToString:@"message"]) {
		xmlResults = FALSE;
        //		status.text = xmlValue;
		[xmlValue release];
		xmlValue = nil;
	}
	else if ([xmlElementName isEqualToString:@"error"]) {
		xmlResults = FALSE;
        //		status.text = xmlValue;
		[xmlValue release];
		xmlValue = nil;
	}
}

#pragma mark -
#pragma mark Outlets
-(void)resetSOAP:(id)sender
{
    [self callWebServiceWithDelegate:self
                           andMethod: @"ResetQueues"
     , nil];
}

-(void)synchroniseNotebooks:(id)sender
{
    [self callWebServiceWithDelegate:self
                           andMethod: @"ListNotebooks"
     , nil];
}

#pragma mark -
#pragma mark Memory management
- (void)dealloc {
    
    //    [detailViewController release];
    [fetchedResultsController release];
    [managedObjectContext release];
    [super dealloc];
}

@end
