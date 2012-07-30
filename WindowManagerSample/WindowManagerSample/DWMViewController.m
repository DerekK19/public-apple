//
//  DWMViewController.m
//  WindowManagerSample
//
//  Created by Derek Knight on 29/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DWMViewController.h"
#import "DWMAppletViewController.h"

@interface DWMViewController ()

@end

@implementation DWMViewController

@synthesize doItButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)willDoIt:(id)sender
{
    DWMAppletViewController *appletViewController = [[DWMAppletViewController alloc]initWithNibName:nil
                                                                                             bundle:nil];
    
    [appletViewController setAppletFrame:CGRectMake(100.0, 100.0, 320.0, 480.0)];
    [appletViewController addLeftHeaderButton:@"Hello"
                               withCallbackId:@"Hi"
                                      andType:nil];
    
    [appletViewController addRightHeaderButton:@"Continue"
                                 withBadgeText:@"0"
                                andBadgeColour:@"Red"
                                andScaleFactor:0.5
                                 andCallbackId:@"continue"
                                       andType:@"CallToActionWithArrow"];
    
    [self presentViewController:appletViewController animated:YES completion:nil];
}

@end
