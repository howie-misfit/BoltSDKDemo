//
//  DeviceViewController.m
//  MisfitBoltSDKDemo
//
//  Created by Nghia Nguyen on 10/24/14.
//  Copyright (c) 2014 Misfit. All rights reserved.
//

#import "DeviceViewController.h"
#import "MisfitControllerListViewController.h"
#import "FirmwareVersionViewController.h"

@interface DeviceViewController ()<MFIBoltDeviceConnectionDelegate, MFIBoltDeviceOADDelegate, FirmwareVersionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *readyButton;

@property (weak, nonatomic) IBOutlet UIButton *bulbSwitchButton;
@property (weak, nonatomic) IBOutlet UISwitch *bulbSwitch;
@property (weak, nonatomic) IBOutlet UIButton *setColorButton;
@property (weak, nonatomic) IBOutlet UIButton *setColorTemperatureButton;
@property (weak, nonatomic) IBOutlet UIButton *getLedNameButton;
@property (weak, nonatomic) IBOutlet UIButton *setLedNameButton;
@property (weak, nonatomic) IBOutlet UIButton *setEffectButton;
@property (weak, nonatomic) IBOutlet UIButton *getFirmwareVersionButton;
@property (weak, nonatomic) IBOutlet UIButton *getMacAddressButton;
@property (weak, nonatomic) IBOutlet UIButton *getSerialNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *getStatusButton;
@property (weak, nonatomic) IBOutlet UIButton *updateFirmwareButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshRSSIButton;
@property (weak, nonatomic) IBOutlet UIButton *beaconConfigButton;

@property (weak, nonatomic) IBOutlet UITextField *bTextField;
@property (weak, nonatomic) IBOutlet UITextField *gTextField;
@property (weak, nonatomic) IBOutlet UITextField *rTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *effectSegment;
@property (weak, nonatomic) IBOutlet UITextField *colorTemperatureTextField;
@property (weak, nonatomic) IBOutlet UITextField *setLedNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *firmwareProgress;
@property (weak, nonatomic) IBOutlet UITextField *brightnessRGBTextField;
@property (weak, nonatomic) IBOutlet UITextField *brightnessTemperatureTextField;
@property (weak, nonatomic) IBOutlet UILabel *rssiValueLabel;

@property (nonatomic) uint oadTime;

@end

@implementation DeviceViewController
{
    NSString *_stateString;
    NSString *_connectButtonTitle;
}

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _device.delegate = self;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tappedOutsideKeyboardArea:)];
    [self.view addGestureRecognizer:recognizer];
    
    // Do view setup here.
    _firmwareProgress.progress = 0;
    _stateString = @"Disconnect";
    _connectButtonTitle = @"Connect";
    [self updateUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)
    {
        [_device disconnectWithCompletion:^(MFIBoltDevice *boltDevice) {
            
        }];
    }
}

#pragma mark - Keyboard animation

- (void)tappedOutsideKeyboardArea:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - Private function

- (void)showMessage:(NSString *)message
{
    [self updateUI];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"Callback"
                                    message: message
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    });
}

#pragma mark - Connection Delegate

- (void)boltDevice:(MFIBoltDevice *)boltDevice didDisconnectUnexpectedWithError:(MFIBoltDisconnectionError *)error
{
    _stateString = @"Disconnected";
    _connectButtonTitle = @"Connect";
    
    [self updateUI];
}

- (void)boltDevice:(MFIBoltDevice *)boltDevice didRefreshRSSIWithError:(NSError *)error
{
    if (!error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _rssiValueLabel.text = [NSString stringWithFormat:@"%d", boltDevice.RSSI.intValue];
        });
        
    }
}

#pragma mark - OADDelegate

- (void)boltDevice:(MFIBoltDevice *)boltDevice firmwareUpdateDidChangeProgress:(float)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.oadTime == 0)
        {
            self.oadTime = [NSDate date].timeIntervalSince1970;
        }
        [_firmwareProgress setProgress:progress animated:YES];
    });
}

- (void)boltDevice:(MFIBoltDevice *)boltDevice firmwareUpdateCompletedWithError:(MFIBoltOADError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _firmwareProgress.progress = 0;
        
        NSString *successMessage = [NSString stringWithFormat:@"Update firmware completed in %f seconds",
                                    [NSDate date].timeIntervalSince1970 - self.oadTime];
        self.oadTime = 0;
        
        NSLog(@"oad error = %@", error);
        
        [[[UIAlertView alloc] initWithTitle:@"Callback"
                                    message:error == nil ? successMessage
                                           :error.localizedDescription
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    });
    
    [self updateUI];
}

#pragma mark - Event

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segue_beacon_config"])
    {
        MisfitControllerListViewController *controller = segue.destinationViewController;
        
        controller.device = self.device;
    }
    else if ([segue.identifier isEqualToString:@"segue_firmware"])
    {
        FirmwareVersionViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

- (IBAction)tappedRefreshRSSIButton:(id)sender {
    [_device refreshRSSI];
}

- (IBAction)tappedConnectButton:(id)sender
{
    if (_device.state == MFIBoltDeviceStateDisconnected)
    {
        [_device connectWithTimeoutInterval:5 completion:^(MFIBoltDevice *boltDevice, MFIBoltConnectionError *error) {
            _stateString = error == nil ? @"Connected" : @"Disconnected";
            _connectButtonTitle = !error ? @"Disconnect" : @"Connect";
            
            [self updateUI];
        }];
        _stateString = @"Connecting";
    }
    else if(_device.state != MFIBoltDeviceStateDisconnected || _device.state != MFIBoltDeviceStateDisconnecting)
    {
        [_device disconnectWithCompletion:^(MFIBoltDevice *boltDevice) {
            _stateString = @"Disconnected";
            _connectButtonTitle = @"Connect";
            
            [self updateUI];
        }];
        _stateString = @"Disconnecting";
    }
    [self updateUI];
}

- (IBAction)tappedSwitchBulbButton:(id)sender {
    [_device switchBulb:_bulbSwitch.on completion:^(MFIBoltDevice *boltDevice, MFIBoltActionError *error) {
        NSString *message = (error == nil) ? @"Switch succeeded." : [error.userInfo objectForKeyedSubscript:NSLocalizedDescriptionKey];
        
        [self showMessage:message];
        
        [self updateUI];
    }];
    [self updateUI];
}

- (IBAction)tappedGetMacAddressButton:(id)sender
{
    __weak DeviceViewController *controller = self;
    
    [_device getMacAddressWithCompletion:^(MFIBoltDevice *boltDevice, NSString *value, MFIBoltActionError *error) {
        [controller showMessage:error == nil? value
                               :error.localizedDescription];
    }];
    [self updateUI];
}

- (IBAction)tappedGetSerialNumberButton:(id)sender {
    __weak DeviceViewController *controller = self;
    
    [_device getSerialNumberWithCompletion:^(MFIBoltDevice *boltDevice, NSString *value, MFIBoltActionError *error) {
        [controller showMessage:error == nil? value
                               :error.localizedDescription];
    }];
    [self updateUI];
}

- (IBAction)tappedGetFirmwareVersionButton:(id)sender
{
    __weak DeviceViewController *controller = self;
    
    [_device getFirmwareVersionWithCompletion:^(MFIBoltDevice *boltDevice, NSString *value, MFIBoltActionError *error) {
        [controller showMessage:error == nil ? value
                               :error.localizedDescription];
    }];
    [self updateUI];
}

- (IBAction)tappedSetEffectButton:(id)sender
{
    __weak DeviceViewController *controller = self;

    if(_effectSegment.selectedSegmentIndex == 2)
    {
        [_device setDefaultColorWithCompletion:^(MFIBoltDevice *boltDevice, MFIBoltActionError *error) {
            [controller showMessage:error == nil ? @"Set current color succeeded."
                                   :error.localizedDescription];
            
        }];
    }
    else
    {
        BOOL on = _effectSegment.selectedSegmentIndex == 0 ? YES : NO;
        [_device switchGradualMode:on completion:^(MFIBoltDevice *boltDevice, MFIBoltActionError *error) {
            [controller showMessage:error == nil ? @"Switch gradualMode succeeded."
                                   :error.localizedDescription];
        }];
    }
    [self updateUI];
}

- (IBAction)tappedSetLedNameButton:(id)sender
{
    __weak DeviceViewController *controller = self;
    [_device setName:_setLedNameTextField.text completion:^(MFIBoltDevice *boltDevice,  MFIBoltActionError *error) {
        [controller showMessage:error == nil ? @"Set name succeeded."
                               :error.localizedDescription];
    }];
    [self updateUI];
}

- (IBAction)tappedGetLedNameButton:(id)sender
{
    __weak DeviceViewController* controller = self;
    [_device getNameWithCompletion:^(MFIBoltDevice *boltDevice, NSString *value, MFIBoltActionError *error) {
        [controller showMessage:error == nil ? value
                               :error.localizedDescription];
    }];
    [self updateUI];
}

- (IBAction)tappedSetColorTemperatureButton:(id)sender
{
    uint16_t value = [_colorTemperatureTextField.text intValue];
    uint8_t brightness = [_brightnessTemperatureTextField.text intValue];
    __weak DeviceViewController* controller = self;
    
    [_device setColorTemperature:value brightness:brightness completion:^(MFIBoltDevice *boltDevice,  MFIBoltActionError *error) {
        [controller showMessage:error == nil ? @"Set color temperature succeeded."
                               :error.localizedDescription];
    }];
    [self updateUI];
}

- (IBAction)tappedSetColorButton:(id)sender
{
    RGB rgb;
    rgb.R = [_rTextField.text intValue];
    rgb.G = [_gTextField.text intValue];
    rgb.B = [_bTextField.text intValue];
    
    uint8_t brightness = [_brightnessRGBTextField.text intValue];
    __weak DeviceViewController* controller = self;
    
    [_device setColorRGB:rgb brightness:brightness completion:^(MFIBoltDevice *boltDevice,  MFIBoltActionError *error) {
        [controller showMessage:error == nil ? @"Set color succeeded."
                               :error.localizedDescription];
    }];
    [self updateUI];
}

- (IBAction)tappedGetStatusButton:(id)sender
{
    __weak DeviceViewController* controller = self;
    
    [_device getColorStatusWithCompletion:^(MFIBoltDevice *boltDevice, MFIBoltDeviceColorMode mode, void *colorValue, uint8_t brightness, MFIBoltActionError *error) {
        NSMutableString *string = [[NSMutableString alloc] initWithString:@""];
        if (error == nil)
        {
            if (mode == MFIBoltDeviceColorModeRGB)
            {
                RGB color = *(RGB *)colorValue;
                [string appendFormat:@"R %d G %d B %d brightness %d",
                 color.R ,color.G ,color.B , brightness];
            }
            else {
                uint16_t colorTemperature = *(uint16_t *)colorValue;
                [string appendFormat:@"Temperature %d brightness %d",
                 colorTemperature, brightness];
            }
        }
        [controller showMessage:error == nil ? string
                               :error.localizedDescription];
    }];
    [self updateUI];
}

- (IBAction)tappedReadyButton:(id)sender
{
    __weak DeviceViewController *controller = self;
    if ([_device prepareWithCompletion:^(MFIBoltDevice *boltDevice,  MFIBoltPreparationError *error) {

        if (!error)
        {
            _stateString = @"Ready";
            
            [self updateUI];
        }
        else
        {
            _stateString = @"Connected";
            [controller showMessage:error.localizedDescription];
        }
    }])
    {
        _stateString = @"Preparing";
        [self updateUI];
    }
}

#pragma mark - UI

- (void)updateUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _stateLabel.text = _stateString;
        _connectButton.title = _connectButtonTitle;
        
        _bulbSwitchButton.enabled
        = _setColorButton.enabled
        = _setColorTemperatureButton.enabled
        = _getLedNameButton.enabled
        = _setLedNameButton.enabled
        = _setColorTemperatureButton.enabled
        = _getLedNameButton.enabled
        = _setLedNameButton.enabled
        = _setEffectButton.enabled
        = _getFirmwareVersionButton.enabled
        = _getMacAddressButton.enabled
        = _getSerialNumberButton.enabled
        = _getStatusButton.enabled
        = _beaconConfigButton.enabled
        = _device.state == MFIBoltDeviceStateReady;
        
        _readyButton.enabled = _device.state == MFIBoltDeviceStateConnected;
        
        _refreshRSSIButton.enabled = _device.state >= MFIBoltDeviceStateConnected;
        
        _updateFirmwareButton.enabled = (_device.state == MFIBoltDeviceStateConnected
                                         || _device.state == MFIBoltDeviceStateReady);
    });
}

#pragma mark - FirmwareVersionViewController Delegate

- (void)choosedAFirmwareVersionWithPath:(NSURL *)url
{
    _device.oadDelegate = self;
    if ([_device updateFirmwareWithBinary:[NSData dataWithContentsOfURL:url]])
    {
        _stateString = @"Updating firmware";
        [self updateUI];
    }
}
@end