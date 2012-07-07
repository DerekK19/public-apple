//
//  DetailViewController.m
//  OnesNotes
//
//  Created by Derek Knight on 22/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "Common.h"

@implementation DetailViewController

@synthesize nameText;
@synthesize nicknameText;
@synthesize GUIDText;
@synthesize pathText;
@synthesize modifiedText;
@synthesize colourText;
@synthesize webArea;
@synthesize status;

@synthesize rootViewController;
@synthesize sectionViewController;

#pragma mark -
#pragma mark Object initialisation

- (DetailViewController *) initWithSectionController:(SectionViewController *)view {
    [self initWithNibName:@"DetailView"
                   bundle:nil];
    self.sectionViewController = view;
    
    return [self init];
}

- (id) init {
    
    return [super init];
}

#pragma mark -
#pragma mark Object insertion

//- (IBAction)insertNewObject:(id)sender {
//    NSDate *modified = [NSDate date];
//    NSString *name = nameText.text;
//    NSString *nickname = nicknameText.text;
//    NSString *GUID = GUIDText.text;
//    NSString *path = pathText.text;
//    NSString *colour = colourText.text;
//	
//	[sender insertNewObject:sender
//                   withName:name
//                andNickname:nickname
//                      andID:GUID
//                    andPath:path
//        andLastModifiedTime:modified
//                  andColour:colour];	
//}

#pragma mark -
#pragma mark Synchronisation

- (IBAction)synchroniseNotebooks:(id)sender {
//    [self.rootViewController synchroniseNotebooks:sender];
}

#pragma mark -
#pragma mark Insertion

- (IBAction)insertNewPage:(id)sender {
//    soap = [pool getConnection];
//    [soap callWebService : [self webServiceURL]
//            withNamespace: @"gordonknight.co.uk"
//              andDelegate:self
//            useEncryption:FALSE
//               andLogging:logging
//                andMethod: @"InsertPage"
//     , nil];
//
//    [self.sectionViewController insertNewPage:sender];
}

#pragma mark -
#pragma mark Managing the detail item


- (void)setDetailItem:(NSManagedObject *)managedObject {
    status.text = @"";
    [super setDetailItem:managedObject];
}

//- (void)refreshUIForCreate{
//    // Update the user interface for the detail item.
//    //    entered.text = [self displayDate:[NSDate date]];
//    //    subject.text = [[detailItem valueForKey:@"subject"] description];
//    
//    self.title = @"New Notebook";
//    
//}

- (void)refreshUIForRead {
    if ([detailItem isKindOfClass:[PageModel class]])
    {
        PageModel *page = (PageModel *) detailItem;
        NSString *GUID = page.GUID;
        nameText.text = page.name;
        GUIDText.text = GUID;
        modifiedText.text = [self displayDate: page.modified];
        
        self.title = page.name;
        
        [self GetPage:page withGUID:GUID];
    }
}

- (void)RenderPageWithUrl: (NSURL *)url {
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[webArea loadRequest:requestObj];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Page";
}

#pragma mark SOAP callbacks
-(void) xmlsoap:(DKXMLSOAPRequest *)xmlsoap foundResult:(NSString *)methodName :(NSString *)result
{
    [xmlsoap release];
	if( xmlParser )
	{
		[xmlParser release];
	}
	xmlParser = [[NSXMLParser alloc] initWithData: [result dataUsingEncoding:NSUTF8StringEncoding]];
    pageResult = [NSString stringWithFormat: @"%@", result];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
}

-(void) xmlsoap:(DKXMLSOAPRequest *)xmlsoap foundFault:(NSString *)methodName :(NSString *)fault
{
    [xmlsoap release];
	status.text = fault;
}

#pragma mark Parser callbacks
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)xmlElementName
                                       namespaceURI:(NSString *) namespaceURI
                                      qualifiedName:(NSString *)qName
                                         attributes:(NSDictionary *)attributeDict
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
    if ([xmlElementName isEqualToString:@"page"])
    {
        NSString *path =  [NSString stringWithFormat: @"%@", [attributeDict valueForKey:@"url"]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@", URLRoot, path]];
		xmlResults = FALSE;
        [self RenderPageWithUrl: url];
		xmlValue = nil;
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
		status.text = xmlValue;
		[xmlValue release];
		xmlValue = nil;
	}
	else if ([xmlElementName isEqualToString:@"error"]) {
		xmlResults = FALSE;
        status.text = xmlValue;
		[xmlValue release];
		xmlValue = nil;
	}
}

#pragma mark -
#pragma mark Outlets
-(void)GetPage:(id)sender
      withGUID:(NSString *) GUID
{
    [self callWebServiceWithDelegate:self
                           andMethod:@"GetPage"
     , @"objectID", GUID
     , nil];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    //	[subject release];
    //	[entered release];
    
	[super dealloc];
}	

@end
