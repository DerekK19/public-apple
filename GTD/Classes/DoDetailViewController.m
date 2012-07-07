//
//  DoDetailViewController.m
//  GTD
//
//  Created by Derek Knight on 19/09/10.
//  Copyright (c) 2010 Home. All rights reserved.
//

#import "DoDetailViewController.h"
#import "DoViewController.h"

@implementation DoDetailViewController

@synthesize subject;
@synthesize entered;
@synthesize due;
@synthesize rootViewController;

#pragma mark -
#pragma mark Object initialisation

- (DoDetailViewController *) initWithController:(DoViewController *)root {
    [self initWithNibName:@"DoDetailViewController"
                   bundle:nil];
    self.rootViewController = root;
    return self;
}

#pragma mark -
#pragma mark Object insertion

- (IBAction)insertNewObject:(id)sender {
	NSDate *dueDate = [NSDate date];
    NSDate *enteredDate = [NSDate date];
    NSString *subjectText = subject.text;
    
	[sender insertNewObject:sender
                withsubject: subjectText
             andDateEntered: enteredDate
                 andDateDue: dueDate];	
}

#pragma mark -
#pragma mark Managing the detail item

- (void)refreshUIForCreate{
    // Update the user interface for the detail item.
    entered.text = [self displayDate:[NSDate date]];
    due.text = [self displayDate: [NSDate date]];
    subject.text = [[detailItem valueForKey:@"subject"] description];
    
    self.title = @"New ToDo";
    
}

- (void)refreshUIForRead {
    // Update the user interface for the detail item.
    entered.text = [self displayDate: [detailItem valueForKey:@"entered"]];
    due.text = [self displayDate: [detailItem valueForKey:@"due"]];
    subject.text = [[detailItem valueForKey:@"subject"] description];
    
    self.title = @"This ToDo";
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
 [super viewDidLoad];
     self.title = @"ToDo";
 }

#pragma mark -
#pragma mark Memory management
- (void)dealloc {

	[subject release];
	[entered release];
    [due release];
    
	[super dealloc];
}

@end
