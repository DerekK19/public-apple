//
//  DKBCViewController.h
//  BlueClient
//
//  Created by Derek Knight on 10/03/13.
//  Copyright (c) 2013 Derek Knight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface DKBCViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) IBOutlet UITextView *log;

@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) NSMutableData *data;

@end
