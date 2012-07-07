//
//  BaseDetailViewController.m
//  GTD
//
//  Created by Derek Knight on 19/09/10.
//  Copyright (c) 2010 Home. All rights reserved.
//

#import "BaseDetailViewController.h"
#import "Common.h"

@interface BaseDetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end

@implementation BaseDetailViewController

@synthesize toolbar;
@synthesize synchronise;
@synthesize insert;
@synthesize popoverController;
@synthesize detailItem;

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
    
    pool = globalPool();
    
    return [super init];
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
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(NSManagedObject *)managedObject {
    
	if (detailItem != managedObject) {
		[detailItem release];
		detailItem = [managedObject retain];
		
        // Update the view.
        [self refreshUIForRead];
	}
    
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }		
}


- (void)configureView {
    [self refreshUIForRead];
}


- (void)refreshUIForCreate{
    // Update the user interface for the detail item.
///    subject.text = [[detailItem valueForKey:@"subject"] description];
///    entered.text = [[detailItem valueForKey:@"entered"] description];
///    
///    self.title = @"New Stuff";
}

- (void)refreshUIForRead {
    // Update the user interface for the detail item.
///    subject.text = [[detailItem valueForKey:@"subject"] description];
///    entered.text = [[detailItem valueForKey:@"entered"] description];
///    
///    self.title = @"This Stuff";
}

#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
}


#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
 - (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
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
    
    if (color == nil) return [NSString stringWithFormat:@"%02X%02X%02X", 0, 0, 0];
    
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

- (void)dealloc {
	
    [popoverController release];
    [toolbar release];
	
	[detailItem release];
    
	[super dealloc];
}	


@end
