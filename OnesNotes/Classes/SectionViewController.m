//
//  SectionViewController.m
//  OnesNotes
//
//  Created by Derek Knight on 24/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import "SectionViewController.h"
#import "DetailViewController.h"
#import "Common.h"

#import "PageModel.h"

@interface SectionViewController ()
- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation SectionViewController

@synthesize detailViewController;
@synthesize section;

#pragma mark -
#pragma mark View lifecycle

- (SectionViewController *)initWithSection:(SectionModel *)theSection {
    
    self.section = theSection;
    self.navigationItem.title = self.section.name;
    
    const CGFloat *c = CGColorGetComponents(self.section.colour.CGColor);  
    
    CGFloat r, g, b;
    r = c[0];  
    g = c[1];  
    b = c[2];  

    self.tableView.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:0.9];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"sectionGUID == %@", self.section.GUID];
    [super initFetchedResultsControllerWithEntityName: @"Page"
                                           andSortKey: @"timeStamp"
                                         andPredicate: predicate];
    [super didAuthenticate];
    [self synchroniseSection:nil
                    withGUID:theSection.GUID];
    
    [detailViewController init];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(listTemplates)];

    return self;
}

- (void)viewDidLoad {
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"sectionGUID == %@", self.section.GUID];
    [super initFetchedResultsControllerWithEntityName: @"Page"
                                           andSortKey: @"timeStamp"
                                         andPredicate: predicate];
    [super didAuthenticate];
    [super viewDidLoad];    
}

#pragma mark -
#pragma mark Table view data source

- (BOOL)findObjectWithGUID:(NSString *)GUID {
    PageModel *findObject = [modelFactory findPageWithGUID:GUID];
    return findObject != nil;
}


- (void)insertNewObject:(id)sender
               withName:(NSString *)name
                  andID:(NSString *)GUID
               andLevel:(NSString *)pageLevel
    andLastModifiedTime:(NSDate *)modifiedTime
        andInsertedTime:(NSDate *)insertedTime {
    
    NSIndexPath *currentSelection = [self.tableView indexPathForSelectedRow];
    if (currentSelection != nil) {
        [self.tableView deselectRowAtIndexPath:currentSelection animated:NO];
    }
    
    PageModel *newObject = [modelFactory createPageWithSection:self.section
                                                       andName:name
                                                         andID:GUID
                                                      andLevel:pageLevel
                                           andLastModifiedTime:modifiedTime
                                               andInsertedTime:insertedTime];
    
    NSIndexPath *insertionPath = [fetchedResultsController indexPathForObject:newObject];
    [self.tableView selectRowAtIndexPath:insertionPath
                                animated:YES
                          scrollPosition:UITableViewScrollPositionTop];
    detailViewController.detailItem = newObject;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    PageModel *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
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
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the managed object.
        PageModel *theObject = [modelFactory createPageForRowAtIndexPath:indexPath];
        if (detailViewController.detailItem == theObject) {
            detailViewController.detailItem = nil;
        }
        
        [theObject delete];
    }   
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = self.section.colour;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set the detail item in the detail view controller.
    PageModel *selectedObject = (PageModel *)[super tableView:aTableView selectedRowAtIndexPath:indexPath];
    detailViewController.detailItem = selectedObject;    
    
    // Navigation logic may go here. Create and push another view controller.

//    [detailViewController refreshUIForRead];
    
//    SectionViewController *subViewController = [SectionViewController alloc];
//    subViewController.managedObjectContext = self.managedObjectContext;
//    subViewController.detailViewController = self.detailViewController;
//    [subViewController initWithGUID: GUID];
//    // ...
//    // Pass the selected object to the new view controller.
//    [self.navigationController pushViewController:subViewController animated:YES];
//    [subViewController release];
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
	detailViewController.status.text = fault;
}

#pragma mark Parser callbacks
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)xmlElementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
   attributes:(NSDictionary *)attributeDict
{
	if([xmlElementName isEqualToString:@"message"] ||
       [xmlElementName isEqualToString:@"error"] ||
       [xmlElementName isEqualToString:@"templatePageName"] ||
       [xmlElementName isEqualToString:@"templatePageID"])
	{
		if(!xmlValue)
		{
			xmlValue = [[NSMutableString alloc] init];
		}
		xmlResults = TRUE;
	}
	if([xmlElementName isEqualToString:@"one:Page"])
	{
        NSString *name =  [NSString stringWithFormat: @"%@", [attributeDict valueForKey:@"name"]];
        NSString *GUID =  [NSString stringWithFormat: @"%@", [attributeDict valueForKey:@"ID"]];
        NSString *pageLevel =  [NSString stringWithFormat: @"%@", [attributeDict valueForKey:@"pageLevel"]];
        NSString *temp =  [NSString stringWithFormat: @"%@", [attributeDict valueForKey:@"lastModifiedTime"]];
        NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        NSDate *modified = [dateFormatter dateFromString:temp];
        temp =  [NSString stringWithFormat: @"%@", [attributeDict valueForKey:@"dateTime"]];
        NSDate *inserted = [dateFormatter dateFromString:temp];
        
        if (![self findObjectWithGUID:GUID])
        {
            [self insertNewObject:nil
                         withName:name
                            andID:GUID
                         andLevel:pageLevel
              andLastModifiedTime:modified
                  andInsertedTime:inserted];
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
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)xmlElementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
	if ([xmlElementName isEqualToString:@"message"]) {
		xmlResults = FALSE;
        detailViewController.status.text = xmlValue;
		[xmlValue release];
		xmlValue = nil;
	}
	else if ([xmlElementName isEqualToString:@"error"]) {
		xmlResults = FALSE;
        detailViewController.status.text = xmlValue;
		[xmlValue release];
		xmlValue = nil;
	}
    else if ([xmlElementName isEqualToString:@"templatePageName"]) {
        xmlResults = false;
        NSLog(@"Template name: %@", xmlValue);
        [xmlValue release];
		xmlValue = nil;
    }
    else if ([xmlElementName isEqualToString:@"templatePageID"]) {
        xmlResults = false;
        NSLog(@"Template ID: %@", xmlValue);
        [xmlValue release];
		xmlValue = nil;
    }
}

#pragma mark -
#pragma mark Outlets
- (IBAction)listTemplates
{
    [self callWebServiceWithDelegate:self
                           andMethod: @"ListTemplates"
     , @"objectID", section.GUID
     , nil];
}

-(void)synchroniseSection:(id)sender
                  withGUID:(NSString *) GUID
{
    [self callWebServiceWithDelegate:self
                           andMethod: @"ListSection"
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

