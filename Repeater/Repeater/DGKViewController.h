//
//  DGKViewController.h
//  Repeater
//
//  Created by Derek Knight on 23/09/12.
//  Copyright (c) 2012 Derek Knight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DGKViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIButton *reset;

- (IBAction)didPressReset:(id)sender;

@end
