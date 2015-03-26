//
//  MultipleDevicesViewController.m
//  MisfitBoltSDKDemo
//
//  Created by Nghia Nguyen on 12/30/14.
//  Copyright (c) 2014 Misfit. All rights reserved.
//

#import "MultipleDevicesViewController.h"
#import <MisfitBoltSDK/MisfitBoltSDK.h>

@interface MultipleDevicesViewController()<UITableViewDataSource, UITableViewDelegate, MFIBoltDeviceConnectionDelegate, MFIBoltDeviceOADDelegate>

@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *readyButton;
@property (weak, nonatomic) IBOutlet UIButton *setColorButton;
@property (weak, nonatomic) IBOutlet UIButton *updateFirmwareButton;

@property (weak, nonatomic) IBOutlet UITextField *redTextField;
@property (weak, nonatomic) IBOutlet UITextField *greenTextField;
@property (weak, nonatomic) IBOutlet UITextField *blueTextField;
@property (weak, nonatomic) IBOutlet UITextField *brightnessTextField;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@property (weak, nonatomic) IBOutlet UITableView *deviceTable;

@property (nonatomic) BOOL connectedAll;
@property (nonatomic) BOOL readyAll;
@property (nonatomic) BOOL isBusying;

@property (nonatomic) NSUInteger numberDevicesIsBusying;
@property (nonatomic) NSUInteger numberDevicesConnected;
@property (nonatomic) NSUInteger numberDevicesReady;

@property (nonatomic) NSMutableDictionary *progressOfDevices;
@property (nonatomic) NSDictionary *stateOfDevice;

@property (nonatomic) NSMutableString *logMessage;

@end

@implementation MultipleDevicesViewController

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.progressOfDevices = [NSMutableDictionary new];
    self.logMessage = [NSMutableString new];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tappedOutsideKeyboardArea:)];
    [self.view addGestureRecognizer:recognizer];
    
    _deviceTable.delegate = self;
    _deviceTable.dataSource = self;
    
    _connectedAll = NO;
    _readyAll = NO;
    _isBusying = NO;
    
    _numberDevicesReady = 0;
    
    _stateOfDevice = @{ @(MFIBoltDeviceStateBusy) : @"Busy"
                        , @(MFIBoltDeviceStateConnected) : @"Connected"
                        , @(MFIBoltDeviceStateConnecting) : @"Connecting"
                        , @(MFIBoltDeviceStateDisconnected) :@"Disconnected"
                        , @(MFIBoltDeviceStateDisconnecting) : @"Disconnecting"
                        , @(MFIBoltDeviceStatePreparing) : @"Preparing"
                        , @(MFIBoltDeviceStateReady) : @"Ready"
                        , @(MFIBoltDeviceStateUpdating) : @"Updating"};
    [self updateUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    for (MFIBoltDevice *device in _devices)
    {
        [device disconnectWithCompletion:^(MFIBoltDevice *boltDevice) {
            
        }];
    }
}

#pragma mark - Keyboard
- (void)tappedOutsideKeyboardArea:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - Private function

- (void)didUpdateStatusOfDevices
{
    _connectedAll = (self.numberDevicesConnected == _devices.count) ? YES : NO;
    
    if (!_connectedAll)
    {
        _readyAll = NO;
    }
    
    [self updateUI];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_deviceTable reloadData];
    });
}

- (void)setDevices:(NSArray *)devices
{
    _devices = devices;
    
    for (MFIBoltDevice *device in devices)
    {
        device.delegate = self;
        device.oadDelegate = self;
    }
}

- (void)updateUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _connectButton.enabled = !_connectedAll ? YES : NO;
        _readyButton.enabled = _connectedAll & !_readyAll & !_isBusying ? YES : NO;
        
        _setColorButton.enabled = _readyAll & !_isBusying ? YES : NO;
        
        _updateFirmwareButton.enabled = _connectedAll & !_isBusying ? YES : NO;
        
        _logTextView.text = _logMessage;
    });
}

- (NSUInteger)numberDevicesConnected
{
    _numberDevicesConnected = 0;
    for (MFIBoltDevice *device in _devices)
    {
        if (device.state >= MFIBoltDeviceStateConnected)
        {
            _numberDevicesConnected++;
        }
    }
    
    return _numberDevicesConnected;
}

- (NSUInteger)numberDevicesReady
{
    _numberDevicesReady = 0;
    for (MFIBoltDevice *device in _devices)
    {
        if (device.state >= MFIBoltDeviceStateReady)
        {
            _numberDevicesReady++;
        }
    }
    
    return _numberDevicesReady;
}

#pragma mark - Table view delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"device_state_cell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"device_state_cell"];
    }
    
    MFIBoltDevice *device = _devices[indexPath.row];
    
    UILabel *uuidLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *stateLabel = (UILabel *)[cell viewWithTag:2];
    UIProgressView *firmwareUpdateProgress = (UIProgressView *)[cell viewWithTag:3];
    
    if (device.state == MFIBoltDeviceStateUpdating)
    {
        firmwareUpdateProgress.hidden = NO;
        firmwareUpdateProgress.progress = [[_progressOfDevices objectForKey:device.uuidString] floatValue];
    }
    else firmwareUpdateProgress.hidden = YES;
    
    uuidLabel.text = device.uuidString;
    stateLabel.text = [_stateOfDevice objectForKey:@(device.state)];
    
    return cell;
}

#pragma mark - MFIBoltDeviceConnectionDelegate
- (void)boltDevice:(MFIBoltDevice *)boltDevice didDisconnectUnexpectedWithError:(MFIBoltDisconnectionError *)error
{
    NSLog(@"uuid=%@ disconneted", boltDevice.uuidString);
    [self didUpdateStatusOfDevices];
}

- (void)boltDevice:(MFIBoltDevice *)boltDevice didRefreshRSSIWithError:(NSError *)error
{
    
}

#pragma mark - MFIBoltDeviceOADDelegate
- (void)boltDevice:(MFIBoltDevice *)boltDevice firmwareUpdateCompletedWithError:(MFIBoltOADError *)error
{
    NSString *message = [NSString stringWithFormat:@"uuid %@", boltDevice.uuidString];
    
    if (error)
    {
        message = [NSString stringWithFormat:@"%@: %@\n", message, error.localizedDescription];
    }
    else {
        message = [NSString stringWithFormat:@"%@: %@\n", message, @"update firmware completed"];
    }
    
    [self.logMessage insertString:message atIndex:0];
    
    _numberDevicesIsBusying--;
    
    _isBusying = (_numberDevicesIsBusying == 0) ? NO: YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_deviceTable reloadData];
    });
    
    [self updateUI];
}

- (void)boltDevice:(MFIBoltDevice *)boltDevice firmwareUpdateDidChangeProgress:(float)progress
{
    [self.progressOfDevices setObject:@(progress) forKey:boltDevice.uuidString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_deviceTable reloadData];
    });
}

#pragma mark - Action
- (IBAction)tappedConnetButton:(id)sender {
    if (!_connectedAll)
    {
        for (MFIBoltDevice *device in _devices)
        {
            [device connectWithTimeoutInterval:5 completion:^(MFIBoltDevice *boltDevice, MFIBoltConnectionError *error) {
                [self didUpdateStatusOfDevices];
            }];
        }
        
        [_deviceTable reloadData];
    }
}

- (IBAction)tappedReadyButton:(id)sender {
    if (!_readyAll)
    {
        for (MFIBoltDevice *device in _devices)
        {
            [device prepareWithCompletion:^(MFIBoltDevice *boltDevice,  MFIBoltPreparationError *error) {
                
                NSString *message = [NSString stringWithFormat:@"uuid %@", device.uuidString];
                
                if (error)
                {
                    message = [NSString stringWithFormat:@"%@: %@\n", message, error.localizedDescription];
                }
                else {
                    message = [NSString stringWithFormat:@"%@: %@\n", message, @"is ready"];
                }
                
                [self.logMessage insertString:message atIndex:0];
                
                _readyAll = (self.numberDevicesReady == _devices.count) ? YES : NO;
                
                [self updateUI];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_deviceTable reloadData];
                });
            }];
        }
        
        [_deviceTable reloadData];
    }
}

- (IBAction)tappedSetColorButton:(id)sender {
    if (_readyAll && !_isBusying)
    {
        RGB rgb;
        rgb.R = [_redTextField.text intValue];
        rgb.G = [_greenTextField.text intValue];
        rgb.B = [_blueTextField.text intValue];
        uint8_t brightness= [_brightnessTextField.text intValue];
        
        _numberDevicesIsBusying = _devices.count;
        _isBusying = YES;
        
        for (MFIBoltDevice *device in _devices)
        {
            __weak MultipleDevicesViewController *controller = self;
            [device setColorRGB:rgb brightness:brightness completion:^(MFIBoltDevice *boltDevice, MFIBoltActionError *error) {
                
                NSString *message = [NSString stringWithFormat:@"uuid %@", boltDevice.uuidString];
                
                if (error)
                {
                    message = [NSString stringWithFormat:@"%@: %@\n", message, error.localizedDescription];
                }
                else {
                    message = [NSString stringWithFormat:@"%@: %@\n", message, @"change color succeeded"];
                }
                
                [self.logMessage insertString:message atIndex:0];
                
                
                _numberDevicesIsBusying --;
                
                _isBusying = (_numberDevicesIsBusying == 0) ? NO : YES;
                
                [controller updateUI];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_deviceTable reloadData];
                });
            }];
        }
        [_deviceTable reloadData];
    }
}

- (IBAction)tappedUpdateFirmwareButton:(id)sender {
    if (_connectedAll && !_isBusying)
    {
        _numberDevicesIsBusying = _devices.count;
        _isBusying = YES;
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"Leo.v3.7.6" ofType:@"bin"];
        for (MFIBoltDevice *device in _devices)
        {
            if ([device updateFirmwareWithBinary:[NSData dataWithContentsOfFile:path]])
            {
                [_progressOfDevices setObject:@(0) forKey:device.uuidString];
            }
        }
        
        [_deviceTable reloadData];
        
        [self updateUI];
    }
}

@end
