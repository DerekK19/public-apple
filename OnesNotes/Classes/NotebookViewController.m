//
//  NotebookViewController.m
//  OnesNotes
//
//  Created by Derek Knight on 24/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import "NotebookViewController.h"
#import "SectionViewController.h"
#import "DetailViewController.h"
#import "Common.h"

#import "SectionModel.h"

@interface NotebookViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation NotebookViewController

@synthesize detailViewController;
@synthesize notebook;

#pragma mark -
#pragma mark View lifecycle

- (NotebookViewController *)initWithNotebook:(NotebookModel *)theNotebook {
    
    self.notebook = theNotebook;
    self.navigationItem.title = self.notebook.name;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"notebookGUID == %@", self.notebook.GUID];
    [super initFetchedResultsControllerWithEntityName: @"Section"
                                           andSortKey: @"timeStamp"
                                         andPredicate: predicate];
    [super didAuthenticate];
    [self synchroniseNotebook:nil
                     withGUID:theNotebook.GUID];
    return self;
}

- (void)viewDidLoad {
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"notebookGUID == %@", self.notebook.GUID];
    [super initFetchedResultsControllerWithEntityName: @"Section"
                                           andSortKey: @"timeStamp"
                                         andPredicate: predicate];
    [super didAuthenticate];
    [super viewDidLoad];    
}

#pragma mark -
#pragma mark Table view data source

- (BOOL)findObjectWithGUID:(NSString *)GUID {
    SectionModel *findObject = [modelFactory findSectionWithGUID:GUID];
    return findObject != nil;
}


- (void)insertNewObject:(id)sender
               withName:(NSString *)name
                  andID:(NSString *)GUID
                andPath:(NSString *)path
    andLastModifiedTime:(NSDate *)modifiedTime
              andColour:(NSString *)colour {
    
    NSIndexPath *currentSelection = [self.tableView indexPathForSelectedRow];
    if (currentSelection != nil) {
        [self.tableView deselectRowAtIndexPath:currentSelection animated:NO];
    }
    
    SectionModel *newObject = [modelFactory createSectionWithNotebook:self.notebook
                                                              andName:name
                                                                andID:GUID
                                                              andPath:path
                                                  andLastModifiedTime:modifiedTime
                                                            andColour:colour];
    
    NSIndexPath *insertionPath = [fetchedResultsController indexPathForObject:newObject];
    [self.tableView selectRowAtIndexPath:insertionPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    detailViewController.detailItem = newObject;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    SectionModel *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = managedObject.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView: tableView cellForRowAtIndexPath:indexPath];    
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the managed object.
        SectionModel *theObject = [modelFactory createSectionForRowAtIndexPath:indexPath];
        if (detailViewController.detailItem == theObject) {
            detailViewController.detailItem = nil;
        }
        
        [theObject delete];
    }   
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionModel *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.backgroundColor = managedObject.colour;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set the detail item in the detail view controller.
    SectionModel *selectedObject = (SectionModel *)[super tableView:aTableView selectedRowAtIndexPath:indexPath];
    detailViewController.detailItem = selectedObject;    
    
    // Navigation logic may go here. Create and push another view controller.
    //NSString *GUID = selectedObject.GUID;
    
    SectionViewController *subViewController = [SectionViewController alloc];
    subViewController.managedObjectContext = self.managedObjectContext;
    subViewController.detailViewController = self.detailViewController;
    [subViewController initWithSection:selectedObject];
    
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
	if([xmlElementName isEqualToString:@"one:Section"])
	{
        NSString *name =  [NSString stringWithFormat: @"%@", [attributeDict valueForKey:@"name"]];
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
-(void)synchroniseNotebook:(id)sender
                  withGUID:(NSString *) GUID
{
    [self callWebServiceWithDelegate:self
                           andMethod: @"ListNotebook"
     , @"objectID", GUID
     , nil];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [fetchedResultsController release];
    [managedObjectContext release];
    [super dealloc];
}

@end

