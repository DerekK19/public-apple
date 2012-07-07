//
//  DGKCurrentTableViewCell.h
//  ProjectTimer
//
//  Created by Derek Knight on 6/06/11.
//  Copyright 2011 ASB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Logging.h"

@interface DGKCurrentTableViewCell : UITableViewCell
{
    id delegate;
}

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *detail;
@property (nonatomic, retain) UIButton *button;

- (void)showTaskRunning;
- (void)showTaskStopped;

@end
