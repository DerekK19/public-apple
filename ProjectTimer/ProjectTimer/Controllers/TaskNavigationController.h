//
//  TaskNavigationController.h
//  ProjectTimer
//
//  Created by Derek Knight on 29/05/11.
//  Copyright 2011 ASB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Logging.h"

@interface DGKTaskNavigationController : UINavigationController
{
    NSMutableArray *titles;
    NSMutableArray *rightButtons;
    NSMutableArray *delegates;
}

@property (nonatomic, assign, readwrite) IBOutlet UINavigationBar *navigationBar;

- (void)pushContextWithTitle:(NSString *)title
              andRightButton:(UIBarButtonItem *)button;
- (void)popContext;

@end
