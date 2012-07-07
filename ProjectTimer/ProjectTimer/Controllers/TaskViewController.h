//
//  FirstViewController.h
//  ProjectTimer
//
//  Created by Derek Knight on 29/05/11.
//  Copyright 2011 ASB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Logging.h"
#import "General.h"
#import "BaseViewController.h"
#import "TaskDetailViewController.h"

@interface DGKTaskViewController : DGKBaseViewController <UINavigationControllerDelegate>
{
    UIBarButtonItem *rButton;
}

- (IBAction)addTask:(id)sender;

@end
