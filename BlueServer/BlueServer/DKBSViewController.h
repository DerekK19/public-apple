//
//  DKBSViewController.h
//  BlueServer
//
//  Created by Derek Knight on 10/03/13.
//  Copyright (c) 2013 Derek Knight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface DKBSViewController : UIViewController <CBPeripheralManagerDelegate>

@property (nonatomic, strong) IBOutlet UIButton *connect;

@property (nonatomic, strong) CBPeripheralManager *manager;

- (IBAction)didPressConnect:(id)sender;

@end
