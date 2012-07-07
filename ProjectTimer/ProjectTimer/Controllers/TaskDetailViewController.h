//
//  TaskDetailViewController.h
//  ProjectTimer
//
//  Created by Derek Knight on 4/06/11.
//  Copyright 2011 ASB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Logging.h"
#import "General.h"
#import "TaskDetailEditController.h"
#import "TaskModel.h"

@interface DGKTaskDetailViewController : UIViewController <UINavigationControllerDelegate>
{
}

@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *today;
@property (nonatomic, retain) IBOutlet UILabel *week;
@property (nonatomic, retain) IBOutlet UILabel *month;
@property (nonatomic, retain) IBOutlet UILabel *remaining;
@property (nonatomic, retain) IBOutlet UILabel *total;
@property (nonatomic, retain) IBOutlet UITextView *notes;

@property (nonatomic, retain) UIBarButtonItem *rButton;

@property (nonatomic, retain) TaskModel *task;

- (id) initWithTask:(TaskModel *)task;

@end
