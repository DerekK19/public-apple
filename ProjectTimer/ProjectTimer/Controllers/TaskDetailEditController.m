//
//  TaskDetailEditController.m
//  ProjectTimer
//
//  Created by Derek Knight on 4/06/11.
//  Copyright 2011 ASB. All rights reserved.
//

#define LOW_LEVEL_DEBUG TRUE

#import "TaskDetailEditController.h"

@implementation DGKTaskDetailEditController

@synthesize name = __name;
@synthesize today = __today;
@synthesize week = __week;
@synthesize month = __month;
@synthesize remaining = __remaining;
@synthesize total = __total;
@synthesize notes = __notes;
@synthesize rButton = __rButton;
@synthesize task = __task;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self)
    {
        __rButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                  target:self
                                                                  action:@selector(saveTask:)];
    }
    return self;
}

- (id) initWithTask:(TaskModel *)task
{
    [TheNavController pushContextWithTitle:@"Edit Task"
                            andRightButton:__rButton];
    [TheNavController setDelegate:self];

    __task = [task retain];
    
    [self viewDidLoad];
    
    return self;
}

- (void)dealloc
{
    [__rButton release];
    [__name release];
    [__task release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark -
#pragma mark Navigation Controller Delegate
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    [TheNavController setDelegate:(id)viewController];
    DEBUGLog(@"%@", viewController);
}
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    DEBUGLog(@"%@", viewController);
    __name.text = [__task Name];
    __notes.text = [__task notes];
    __today.text = [__task PrettyPrintTimeToday];
    __week.text = [__task PrettyPrintTimeThisWeek];
    __month.text = [__task PrettyPrintTimeThisMonth];
    __remaining.text = [__task PrettyPrintTimeRemaining];
    __total.text = [NSString stringWithFormat:@"%d",[[ __task totalMinutes]intValue]];
}

#pragma mark -
#pragma mark Delegates
- (IBAction)saveTask:(id)sender
{
    int num;
    num = [__total.text intValue];
    __task.Name = __name.text;
    __task.notes = __notes.text;
    __task.totalMinutes = [NSNumber numberWithInt:num];
    [TheNavController popContext];
    [TheNavController popViewControllerAnimated:YES];
}
@end
