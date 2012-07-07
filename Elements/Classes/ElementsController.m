//
//  ElementsController.m
//  Elements
//
//  Created by Derek Knight on 26/03/2010.
//  Copyright 2010 Home. All rights reserved.
//

#define LOW_LEVEL_DEBUG FALSE

#import "ElementsController.h"

@implementation ElementsController

@synthesize elementNumberOrSymbol;
@synthesize elementName;
@synthesize atomicNumber;
@synthesize series;
@synthesize period;
@synthesize isotope;
@synthesize mass;
@synthesize melt;
@synthesize boil;
@synthesize elementImage;
@synthesize status;
@synthesize xmlValue;
@synthesize recordValue;
@synthesize xmlParser;
@synthesize claimWebView;

NSString * const elementsURLRoot = @"http://xyzzy.gordonknight.co.uk/elements";
NSString * const authenticationURLRoot = @"http://xyzzy.gordonknight.co.uk/AccessControl";
NSString * const URLRedirect = @"auth://authenticate.gordonknight.co.uk";

- (NSURL *) elementsWebServiceURL
{
	return [NSURL URLWithString:[NSString stringWithFormat: @"%@/Elements.asmx", elementsURLRoot]];
}
- (NSURL *) authenticationWebServiceURL
{
	return [NSURL URLWithString:[NSString stringWithFormat: @"%@/Authentication.asmx", authenticationURLRoot]];
}
- (NSString *) webServiceNameSpace
{
    return @"gordonknight.co.uk";
}
- (NSString *) webServiceInterface
{
    return @"";
}

-(void)callElementsWebServiceWithDelegate:(id)delegate
                                andMethod:(NSString *)method, ...
{
    va_list varargs;
    va_start(varargs, method);
    
    [request callWebService:[self elementsWebServiceURL]
              withNamespace:[self webServiceNameSpace]
               andInterface:[self webServiceInterface]
                  andMethod:method
             withParameters:varargs];
    
    va_end(varargs);
}

-(void)call2ElementsWebServiceWithDelegate:(id)delegate
                                andMethod:(NSString *)method, ...
{
    va_list varargs;
    va_start(varargs, method);
    
    [request2 callWebService:[self elementsWebServiceURL]
              withNamespace:[self webServiceNameSpace]
               andInterface:[self webServiceInterface]
                  andMethod:method
             withParameters:varargs];
    
    va_end(varargs);
}

-(void)callAuthenticationWebServiceWithDelegate:(id)delegate
                                andMethod:(NSString *)method, ...
{
    va_list varargs;
    va_start(varargs, method);
    
    [request callWebService:[self authenticationWebServiceURL]
              withNamespace:[self webServiceNameSpace]
               andInterface:[self webServiceInterface]
                  andMethod:method
             withParameters:varargs];
    
    va_end(varargs);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:@"AuthenticationReturned" object:nil];
    [nc addObserver:self selector:@selector(authenticationReturned:) name:@"AuthenticationReturned" object:nil];
    [nc removeObserver:self name:@"AuthenticationCancelled" object:nil];
    [nc addObserver:self selector:@selector(authenticationCancelled) name:@"AuthenticationCancelled" object:nil];

    request = [[DGKXMLSOAPRequest alloc]initWithDelegate:self];
    request2 = [[DGKXMLSOAPRequest alloc]initWithDelegate:self];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

// Override to allow orientations other than
// the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)dealloc {
	[request release];
	[request2 release];
    [xmlValue release];
    [recordValue release];
    [xmlParser release];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:@"AuthenticationReturned" object:nil];
    [nc removeObserver:self name:@"AuthenticationCancelled" object:nil];
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	if(theTextField == elementNumberOrSymbol) {
		[elementNumberOrSymbol resignFirstResponder];
	}
	return YES;
}

- (IBAction)findElement:(id)sender {

	NSString *message = [[NSString alloc] initWithFormat:@"Searching..."];
	status.text = message;
	[message release];
	
	elementImage.hidden = TRUE;
	elementName.text= [NSString stringWithFormat: @""];
	atomicNumber.text= [NSString stringWithFormat: @""];
	isotope.text= [NSString stringWithFormat: @""];
	series.text= [NSString stringWithFormat: @""];
	period.text= [NSString stringWithFormat: @""];
	mass.text= [NSString stringWithFormat: @""];
	melt.text= [NSString stringWithFormat: @""];
	boil.text= [NSString stringWithFormat: @""];

	// Call web service
	[self callElementsWebServiceWithDelegate:self
                              andMethod:@"FindElement"
		, @"appId", @"iPhone Elements App"
		, @"numberOrSymbol", elementNumberOrSymbol.text
		, nil];
	
	[elementNumberOrSymbol resignFirstResponder];
	
	message = [[NSString alloc] initWithFormat:@""];
	status.text = message;
	[message release];
}

#pragma mark -
#pragma mark Notification handlers
- (void)authenticationReturned:(NSNotification *)notification
{
    NSString *claimToken = [notification object];
    DEBUGLog(@"%@", claimToken);
    
	// Call web service
	[self callAuthenticationWebServiceWithDelegate:self
                                         andMethod:@"GetClaims"
     , @"token", claimToken
     , nil];
    
    claimWebView.hidden = YES;
}
- (void)authenticationCancelled
{
    claimWebView.hidden = YES;
}

#pragma mark -
#pragma mark XMLSOAP callbacks
- (void)xml:(DGKXMLSOAPRequest *)xml foundClaimsToken:(NSString *)claimsToken
{
    DEBUGLog(@"Got XML claims token %@", claimsToken);
}

- (void)xml:(DGKXMLSOAPRequest *)xml foundResponse:(NSString *)methodName :(int)response :(NSString *)reason
{
    DEBUGLog(@"Got XML response for %@(%d) - %@", methodName, response, reason);
}
-(void) xml:(DGKXMLSOAPRequest *)xml foundResult:(NSString *)methodName :(NSString *)result
{
    DEBUGLog (@"Got XML results for %@", methodName);
	if( xmlParser )
	{
		[xmlParser release];
	}
	xmlParser = [[NSXMLParser alloc] initWithData: [result dataUsingEncoding:NSUTF8StringEncoding]];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
}
-(void) xml:(DGKXMLSOAPRequest *)xml foundFault:(NSString *)methodName :(NSString *)fault
{
    ERRORLog(@"Got XML fault %@", fault);
	status.text = fault;
}

#pragma mark -
#pragma mark Parser callbacks
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)xmlElementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
    DEBUGLog(@"%@", xmlElementName);
	if([xmlElementName isEqualToString:@"message"] ||
       [xmlElementName isEqualToString:@"error"] ||
       [xmlElementName isEqualToString:@"ClaimNeeded"] ||
       [xmlElementName isEqualToString:@"ClaimUrl"] ||
       [xmlElementName isEqualToString:@"ClaimReason"] ||
       [xmlElementName isEqualToString:@"symbol"] ||
       [xmlElementName isEqualToString:@"number"] ||
       [xmlElementName isEqualToString:@"name"] ||
       [xmlElementName isEqualToString:@"group"] ||
       [xmlElementName isEqualToString:@"period"] ||
       [xmlElementName isEqualToString:@"mass"] ||
       [xmlElementName isEqualToString:@"isotope"] ||
       [xmlElementName isEqualToString:@"melt"] ||
       [xmlElementName isEqualToString:@"boil"] ||
       [xmlElementName isEqualToString:@"series"])
	{
		if(!xmlValue)
		{
			xmlValue = [[NSMutableString alloc] init];
		}
		xmlResults = TRUE;
	}
    else if ([xmlElementName isEqualToString:@"Claims"])
    {
        NSString *claims =  [NSString stringWithFormat: @"%@", [attributeDict valueForKey:@"data"]];
        DEBUGLog(@"Got claims: '%@'", claims);
        // Call web service
        [self call2ElementsWebServiceWithDelegate:self
                                        andMethod:@"FindElement"
         , @"appId", @"iPhone Elements App"
         , @"numberOrSymbol", elementNumberOrSymbol.text
         , @"claims", urlEncode(claims)
         , nil];
    }
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if( recordResults )
	{
		[recordValue appendString: string];
	}
	if( xmlResults )
	{
		[xmlValue appendString: string];
	}
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)xmlElementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    DEBUGLog(@"%@", xmlElementName);
	if ([xmlElementName isEqualToString:@"message"]) {
		xmlResults = FALSE;
		status.text = xmlValue;
		[xmlValue release];
		xmlValue = nil;
	}
	else if ([xmlElementName isEqualToString:@"ClaimReason"])
	{
        claimReason = [xmlValue copy];
		xmlResults = FALSE;
		[xmlValue release];
		xmlValue = nil;
	}
	else if ([xmlElementName isEqualToString:@"ClaimUrl"])
	{
        claimUrl = [xmlValue copy];
		xmlResults = FALSE;
		[xmlValue release];
		xmlValue = nil;
	}
	else if ([xmlElementName isEqualToString:@"ClaimNeeded"])
	{
        if (nil != claimUrl)
        {
            NSString *newUrl = [NSString stringWithFormat:@"%@&redirect=%@&reason=%@", claimUrl, URLRedirect, urlEncode(claimReason)];
            DEBUGLog(@"GoTo %@", newUrl);
            NSURL *url;
            url = [NSURL URLWithString:newUrl];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            claimWebView.hidden = false;
            [claimWebView loadRequest:requestObj];
        }
        [claimReason release];
        [claimUrl release];
		xmlResults = FALSE;
		[xmlValue release];
		xmlValue = nil;
	}    
	else if ([xmlElementName isEqualToString:@"name"])
	{
		xmlResults = FALSE;
		elementName.text = xmlValue;
		[xmlValue release];
		xmlValue = nil;
	}
	else if ([xmlElementName isEqualToString:@"number"])
	{
		xmlResults = FALSE;
		atomicNumber.text = xmlValue;
		[xmlValue release];
		xmlValue = nil;
	}
	else if ([xmlElementName isEqualToString:@"isotope"])
	{
		xmlResults = FALSE;
		isotope.text = xmlValue;
		[xmlValue release];
		xmlValue = nil;
	}
	else if ([xmlElementName isEqualToString:@"series"])
	{
		xmlResults = FALSE;
		series.text = xmlValue;
		[xmlValue release];
		xmlValue = nil;
	}
	else if ([xmlElementName isEqualToString:@"period"])
	{
		xmlResults = FALSE;
		period.text = xmlValue;
		[xmlValue release];
		xmlValue = nil;
	}
	else if ([xmlElementName isEqualToString:@"mass"])
	{
		xmlResults = FALSE;
		mass.text = xmlValue;
		[xmlValue release];
		xmlValue = nil;
	}
	else if ([xmlElementName isEqualToString:@"melt"])
	{
		xmlResults = FALSE;
		melt.text = xmlValue;
		[xmlValue release];
		xmlValue = nil;
	}
	else if ([xmlElementName isEqualToString:@"boil"])
	{
		xmlResults = FALSE;
		boil.text = xmlValue;
		[xmlValue release];
		xmlValue = nil;
	}
	else if ([xmlElementName isEqualToString:@"symbol"])
	{
		xmlResults = FALSE;
		NSString *imageUrl = [NSString stringWithFormat:@"<html><body topmargin=0 leftmargin=0><img src=\"http://xyzzy.gordonknight.co.uk/static/images/elements/%@.jpg\"></body></html>", xmlValue];
		[elementImage loadHTMLString:imageUrl baseURL:nil];
		elementImage.hidden = FALSE;
		[xmlValue release];
		xmlValue = nil;
	}
}

@end
