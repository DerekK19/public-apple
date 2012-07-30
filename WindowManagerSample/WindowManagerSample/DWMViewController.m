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

@property NSMutableArray *leftEntries;
@property NSMutableArray *rightEntries;

@end

@implementation DWMViewController

@synthesize leftEntries;
@synthesize rightEntries;

@synthesize doItButton;
@synthesize leftPicker;
@synthesize rightPicker;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    leftEntries = [[NSMutableArray alloc] init];
    [leftEntries addObject:@"Plain"];
    [leftEntries addObject:@"Arrow"];
    rightEntries = [[NSMutableArray alloc] init];
    [rightEntries addObject:@"Plain"];
    [rightEntries addObject:@"Arrow"];
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

#pragma mark - Picker view delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (thePickerView == leftPicker)
        return [leftEntries count];
    else
        return [rightEntries count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (thePickerView == leftPicker)
        return [leftEntries objectAtIndex:row];
    else
        return [rightEntries objectAtIndex:row];
}

- (IBAction)willDoIt:(id)sender
{
    DWMAppletViewController *appletViewController = [[DWMAppletViewController alloc]initWithNibName:nil
                                                                                             bundle:nil];
    
    [appletViewController setAppletFrame:CGRectMake(100.0, 100.0, 320.0, 480.0)];
    
    [appletViewController addLeftHeaderButton:@"Hello"
                               withCallbackId:@"Hi"
                                      andType:[leftPicker selectedRowInComponent:0] == 0 ? @"Standard" : @"StandardWithArrow"];
    
    [appletViewController addRightHeaderButton:@"Continue"
                                 withBadgeText:@"0"
                                andBadgeColour:@"Red"
                                andScaleFactor:0.5
                                 andCallbackId:@"continue"
                                       andType:[rightPicker selectedRowInComponent:0] == 0 ? @"CallToAction" : @"CallToActionWithArrow"];

//    [appletViewController showStandardLeftHeaderButton];
    
    [self presentViewController:appletViewController
                       animated:YES
                     completion:nil];
}

@end
