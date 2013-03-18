//
//  DKBCViewController.m
//  BlueClient
//
//  Created by Derek Knight on 10/03/13.
//  Copyright (c) 2013 Derek Knight. All rights reserved.
//

#import "DKBCViewController.h"
#import "BlueCommon.h"

@interface DKBCViewController ()

@property (nonatomic, strong) CBPeripheral *peripheral;

@end

@implementation DKBCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _manager = [[CBCentralManager alloc] initWithDelegate:self
                                                    queue:nil];
    _log.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private behaviour

- (void)cleanup
{
    
}

#pragma mark - CBCentralManagerDelegate delegates

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state)
    {
        case CBCentralManagerStatePoweredOn:
            _peripheral = nil;
            [_manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:kServiceUUID]]
                                             options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @YES}];
            
            DEBUGLog(@"Waiting for connection");
            break;
            
        default:
            DEBUGLog(@"Central manager changed state - %d", central.state);
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    // Stop scanning for peripheral
    [_manager stopScan];
    
    if (_peripheral != peripheral)
    {
        _peripheral = peripheral;
        DEBUGLog(@"Connecting to peripheral %@", peripheral);
        [_manager connectPeripheral:peripheral
                            options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error
{
    DEBUGLog(@"Failed to connect %@", error);
}

- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral
{
    // Clear any dat we may already have
    [_data setLength:0];
    
    // Set the periopheral delegate to self
    [_peripheral setDelegate:self];
    
    // Ask the peripheral to discover the service
    [_peripheral discoverServices:@[[CBUUID UUIDWithString:kServiceUUID]]];
}

- (void)centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error
{
    DEBUGLog(@"Disconnected peripheral %@", peripheral);
    if (peripheral == _peripheral)
    {
        _peripheral = nil;
        [_manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:kServiceUUID]]
                                         options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @YES}];
        
        DEBUGLog(@"Waiting for connection");
    }
}

- (void)peripheralDidInvalidateServices:(CBPeripheral *)peripheral
{
    DEBUGLog(@"Invalidate services");
}

- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverServices:(NSError *)error
{
    if (error)
    {
        ERRORLog(@"Error discovering services - %@", error.localizedDescription);
        [self cleanup];
        return;
    }
    
    for (CBService *service in peripheral.services)
    {
        DEBUGLog(@"Service found with UUID %@", peripheral.UUID);
        
        // Discover the characteristics for a given service
        if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]])
        {
            [_peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:kCharacteristicUUID]]
                                      forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error
{
    if (error)
    {
        ERRORLog(@"Error discovering characteristics for service %@ - %@", service, error.localizedDescription);
        [self cleanup];
        return;
    }
    
    if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]])
    {
        for (CBCharacteristic *characteristic in service.characteristics)
        {
            [peripheral setNotifyValue:YES
                     forCharacteristic:characteristic];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error
{
    if (error)
    {
        ERRORLog(@"Error changing notification state for characteristic %@ - %@", characteristic, error.localizedDescription);
        return;
    }
    
    // Exit if it's not our characteristic
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicUUID]])
    {
        return;
    }
    
    if (characteristic.isNotifying)
    {
        // Notification has started
        DEBUGLog(@"Notification began on %@", characteristic);
        [peripheral readValueForCharacteristic:characteristic];
    }
    else
    {
        // Notification has stopped
        DEBUGLog(@"Notification stopped on %@", characteristic);
        [_manager cancelPeripheralConnection:_peripheral];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
error:(NSError *)error
{
    if (error)
    {
        ERRORLog(@"Error updating value for characteristic %@ - %@", characteristic, error.localizedDescription);
        return;
    }
    
    // Exit if it's not our characteristic
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicUUID]])
    {
        return;
    }

    _data = [[NSMutableData alloc]initWithData:characteristic.value];
    
    char *str = (char *)(_data.bytes);
    
    DEBUGLog(@"Got data '%s'", str);
    
    _log.text = [NSString stringWithFormat:@"%@\n%s", _log.text, str];
    
    // Cancel our subscription to the characteristic
    [peripheral setNotifyValue:NO
             forCharacteristic:characteristic];
    
    // and disconnect from the peripehral
    [_manager cancelPeripheralConnection:peripheral];
}

@end
