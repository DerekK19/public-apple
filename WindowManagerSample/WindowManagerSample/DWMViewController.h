//
//  DWMViewController.h
//  WindowManagerSample
//
//  Created by Derek Knight on 29/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWMViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) IBOutlet UIButton *doItButton;
@property (nonatomic, retain) IBOutlet UIPickerView *leftPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *rightPicker;


- (IBAction)willDoIt:(id)sender;

@end
