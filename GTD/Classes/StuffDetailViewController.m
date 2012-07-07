//
//  StuffDetailViewController.m
//  GTD
//
//  Created by Derek Knight on 19/09/10.
//  Copyright (c) 2010 Home. All rights reserved.
//

#import "StuffDetailViewController.h"
#import "StuffViewController.h"

@implementation StuffDetailViewController

@synthesize subject;
@synthesize entered;
@synthesize rootViewController;

#pragma mark -
#pragma mark Object initialisation

- (StuffDetailViewController *) initWithController:(StuffViewController *)root {
    [self initWithNibName:@"StuffDetailViewController"
                   bundle:nil];
    self.rootViewController = root;
    return self;
}

#pragma mark -
#pragma mark Object insertion

- (IBAction)insertNewObject:(id)sender {
    NSDate *enteredDate = [NSDate date];
    NSString *subjectText = subject.text;
	
	[sender insertNewObject:sender
                withsubject:subjectText
             andDateEntered:enteredDate];	
}

#pragma mark -
#pragma mark Managing the detail item

- (void)refreshUIForCreate{
    // Update the user interface for the detail item.
    entered.text = [self displayDate:[NSDate date]];
    subject.text = [[detailItem valueForKey:@"subject"] description];

    self.title = @"New Stuff";
    
}

- (void)refreshUIForRead {
    // Update the user interface for the detail item.
    entered.text = [self displayDate: [detailItem valueForKey:@"entered"]];
    subject.text = [[detailItem valueForKey:@"subject"] description];
    
    self.title = @"This Stuff";
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
 [super viewDidLoad];
     self.title = @"Stuff";
 }

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
	[subject release];
	[entered release];
    
	[super dealloc];
}	

@end
