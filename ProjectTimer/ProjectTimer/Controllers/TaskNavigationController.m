//
//  TaskNavigationController.m
//  ProjectTimer
//
//  Created by Derek Knight on 29/05/11.
//  Copyright 2011 ASB. All rights reserved.
//

#import "TaskNavigationController.h"

@implementation DGKTaskNavigationController

@synthesize navigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        titles = [[NSMutableArray alloc]init];
        rightButtons = [[NSMutableArray alloc]init];
        delegates = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)pushContextWithTitle:(NSString *)title
              andRightButton:(UIBarButtonItem *)button{
    [titles addObject:title];
    [rightButtons addObject:button];
    [navigationBar.topItem setTitle:title];
    [navigationBar.topItem setRightBarButtonItem:button animated:YES];
}

- (void)popContext
{
    if ([titles count] > 1) [titles removeLastObject];
    if ([rightButtons count] > 1) [rightButtons removeLastObject];
    [navigationBar.topItem setTitle:[titles lastObject]];
    [navigationBar.topItem setRightBarButtonItem:[rightButtons lastObject]];
}

- (void)dealloc
{
    [navigationBar release];
    [titles release];
    [rightButtons release];
    [delegates release];
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
