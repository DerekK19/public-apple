//
//  DKBSViewController.m
//  BlueServer
//
//  Created by Derek Knight on 10/03/13.
//  Copyright (c) 2013 Derek Knight. All rights reserved.
//

#import "DKBSViewController.h"
#import "BlueCommon.h"

@interface DKBSViewController ()

@property (nonatomic, strong) CBMutableCharacteristic *customCharacteristic;
@property (nonatomic, strong) CBMutableService *customService;

@end

@implementation DKBSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _manager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private behaviour
- (void)setupServices
{
    // Create the Characteristic UUID
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:kCharacteristicUUID];
    
    // Create the characteristic
    _customCharacteristic = [[CBMutableCharacteristic alloc]initWithType:characteristicUUID
                                                              properties:CBCharacteristicPropertyNotify
                                                                   value:nil
                                                             permissions:CBAttributePermissionsReadable];

    // Create the Service UUID
    CBUUID *serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
    
    // Create the service
    _customService = [[CBMutableService alloc]initWithType:serviceUUID
                                                   primary:YES];
    
    // Set the characteristic for this service
    [_customService setCharacteristics:@[_customCharacteristic]];
    
    // Publish the service
    [_manager addService:_customService];
}

#pragma mark - IBActions

- (void)didPressConnect:(id)sender
{
    // Start advertising the service
    [_manager startAdvertising:@{CBAdvertisementDataLocalNameKey: @"ICServer",
                                 CBAdvertisementDataServiceUUIDsKey: @[[CBUUID UUIDWithString:kServiceUUID]]}];
}

#pragma mark - CBPeripheralManagerDelegate delegates

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    switch (peripheral.state)
    {
        case CBPeripheralManagerStatePoweredOn:
            DEBUGLog(@"Powered on");
            [self setupServices];
            break;
            
        default:
            DEBUGLog (@"peripheral changed state - %d", peripheral.state);
            break;
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
            didAddService:(CBService *)service
                    error:(NSError *)error
{
    if (error == nil)
    {
        // Enable the connect button
        _connect.enabled = YES;
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
                                       error:(NSError *)error
{
    DEBUGLog(@"Started advertising");
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
                  central:(CBCentral *)central
didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    DEBUGLog(@"Subscribed to characteristic %@", characteristic);

    DEBUGLog(@"Sending data");
    
    [peripheral updateValue:[NSData dataWithBytes:"Hello world\0" length:12]
          forCharacteristic:_customCharacteristic
       onSubscribedCentrals:@[central]];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
                  central:(CBCentral *)central
didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    DEBUGLog(@"Unsubscribed from characteristic %@", characteristic);
    
    [_manager stopAdvertising];
    
}

@end
