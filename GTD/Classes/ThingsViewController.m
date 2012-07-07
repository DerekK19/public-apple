//
//  ThingsViewController.m
//  GTD
//
//  Created by Derek Knight on 19/09/10.
//  Copyright (c) 2010 Home. All rights reserved.
//

#import "GTDAppDelegate.h"
#import "ThingsViewController.h"
#import "StuffDetailViewController.h"
#import "DoDetailViewController.h"

@implementation ThingsViewController

@synthesize tabBarController;
@synthesize stuffViewController;
@synthesize stuffDetailViewController;
@synthesize doViewController;
@synthesize doDetailViewController;
@synthesize managedObjectContext;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view = tabBarController.view;
    
    self.stuffViewController.managedObjectContext = self.managedObjectContext;
    [self.stuffViewController initView: self.navigationItem];
    self.stuffDetailViewController.rootViewController = self.stuffViewController;
    self.stuffDetailViewController = self.stuffViewController.detailViewController;

    self.doViewController.managedObjectContext = self.managedObjectContext;
    [self.doViewController initView: self.navigationItem];
    self.doDetailViewController.rootViewController = self.doViewController;
    self.doDetailViewController = self.doViewController.detailViewController;

    GTDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
	[delegate showContentDetailViewController:self.stuffDetailViewController];
    [stuffViewController initNavButton];
    
    // This will set the title for the right-hand pane // self.stuffDetailViewController.title = @"Foo";

    // This will set the title for the left-hand pane  // self.title = [[NSString alloc] initWithCString:"Hello World"];
    

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


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
	
    [stuffDetailViewController release], stuffDetailViewController = nil;
    [doDetailViewController release], doDetailViewController = nil;
    [tabBarController release], tabBarController = nil;
    [stuffViewController release], stuffViewController = nil;
    [doViewController release], doViewController = nil;

    [super dealloc];
}

#pragma mark UITabBarControllerDelegate Methods

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    /*
     BlogDataManager *dm = [BlogDataManager sharedDataManager];
    
    if (viewController == pagesViewController || viewController == commentsViewController) {
        // Enable pages and comments tabs only if they are supported.
        return [[[dm currentBlog] valueForKey:kSupportsPagesAndComments] boolValue];
    } else {
    */
    return YES;
    //}
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    GTDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];

    if (viewController == stuffViewController)
    {
		[delegate showContentDetailViewController:self.stuffDetailViewController];
    }
    if (viewController == doViewController)
    {
		[delegate showContentDetailViewController:self.doDetailViewController];
    }

	self.navigationItem.titleView = nil;
	self.navigationItem.rightBarButtonItem = nil;
	
	if (viewController == stuffViewController) {
        [stuffViewController initNavButton];
	} 
	else if (viewController == doViewController) {
        [doViewController initNavButton];
	} 
	
	[viewController viewWillAppear:NO];

}

@end
