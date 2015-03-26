//
//  MisfitControllerConfigurationViewController.m
//  MisfitBoltSDKDemo
//
//  Created by Nghia Nguyen on 2/27/15.
//  Copyright (c) 2015 Misfit. All rights reserved.
//

#import "MisfitControllerConfigurationViewController.h"
#import <MisfitBoltSDK/MisfitBoltSDK.h>

static NSString *const kMisfitControllerConfigurationViewControllerAccessoryView = @"accessoryView";

@interface MisfitControllerConfigurationViewController()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveConfigurationButton;
@property (weak, nonatomic) IBOutlet UITableView *eventTableView;
@property (weak, nonatomic) IBOutlet UIButton *addEventButton;
@property (weak, nonatomic) IBOutlet UITextField *distanceTextField;

@property (weak, nonatomic) IBOutlet UITextField *colorTextField;
@property (weak, nonatomic) IBOutlet UITextField *brightnessTextField;
@property (weak, nonatomic) IBOutlet UISwitch *doNotDisturbSwitch;
@property (weak, nonatomic) IBOutlet UITextField *startHourTextField;
@property (weak, nonatomic) IBOutlet UITextField *startMinuteTextField;
@property (weak, nonatomic) IBOutlet UITextField *endHourTextField;
@property (weak, nonatomic) IBOutlet UITextField *endMinuteTextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *modeEventSegmentedControl;

@property (nonatomic) UITextField *eventTextField;
@property (nonatomic) UITextField *actionTextField;
@property (nonatomic) UISwitch *eventSwitch;
@property (nonatomic) UITextField *colorTemperatureTextField;
@property (nonatomic) UITextField *brightnessColorTemperatureTextField;
@property (nonatomic) UITextField *colorRTextField;
@property (nonatomic) UITextField *colorGTextField;
@property (nonatomic) UITextField *colorBTextField;
@property (nonatomic) UITextField *brightnessColorRGBTextField;

@property (nonatomic) UITextField *textFieldFocusing;

@property (nonatomic) MFIBoltMisfitControllerConfiguration *configuration;

@property (nonatomic) int widthAlertView;
@property (nonatomic) int height;
@property (nonatomic) int margin;

@end

@implementation MisfitControllerConfigurationViewController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOutsideTextField)];
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.eventTableView.delegate = self;
    self.eventTableView.dataSource = self;

    self.widthAlertView = self.view.frame.size.width * 2 / 3;
    self.margin = 5;
    self.height = 30;
    
    self.eventTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.widthAlertView / 2 - self.margin, self.height)];
    self.eventTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.eventTextField.placeholder = @"Event (0..255)";
    
    self.actionTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.widthAlertView / 2, 0, self.widthAlertView / 2 - self.margin, self.height)];
    self.actionTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.actionTextField.placeholder = @"Action (1..3)";
    
    self.colorTemperatureTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, self.height + self.margin, self.widthAlertView / 2 - self.margin, self.height)];
    self.colorTemperatureTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.colorTemperatureTextField.placeholder = @"Color";
    
    self.brightnessColorTemperatureTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.widthAlertView / 2, self.height + self.margin, self.widthAlertView / 2 - self.margin, self.height)];
    self.brightnessColorTemperatureTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.brightnessColorTemperatureTextField.placeholder = @"Brightness";
    
    self.colorRTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, _height + _margin, self.widthAlertView / 4 - _margin, _height)];
    self.colorRTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.colorRTextField.placeholder = @"R";
    
    self.colorGTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.widthAlertView / 4, _height + _margin, self.widthAlertView / 4 - _margin, _height)];
    self.colorGTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.colorGTextField.placeholder = @"G";
    
    self.colorBTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.widthAlertView / 2, _height + _margin, self.widthAlertView / 4 - _margin, _height)];
    self.colorBTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.colorBTextField.placeholder = @"B";
    
    self.brightnessColorRGBTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.widthAlertView * 3 / 4, _height + _margin, self.widthAlertView / 4 - _margin, _height)];
    self.brightnessColorRGBTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.brightnessColorRGBTextField.placeholder = @"Birghtness";
    
    self.eventSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, _height + _margin, 100, _height)];
    
    self.colorTextField.delegate = self;
    self.brightnessTextField.delegate = self;
    self.startHourTextField.delegate = self;
    self.startMinuteTextField.delegate = self;
    self.endHourTextField.delegate = self;
    self.endMinuteTextField.delegate = self;
    self.distanceTextField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [self loadData];
    
    [self updateUI];
}

#pragma mark - Events

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _textFieldFocusing = textField;
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSValue *keyboardEndFrameValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = [keyboardEndFrameValue CGRectValue];
    
    if (_textFieldFocusing.frame.origin.y > keyboardEndFrame.origin.y)
    {
        CGRect frame = self.view.frame;
        frame.origin.y = -(_textFieldFocusing.frame.origin.y - keyboardEndFrame.origin.y + _textFieldFocusing.frame.size.height);
        self.view.frame = frame;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
}
- (void)tappedOutsideTextField
{
    [self.view endEditing:YES];
}

- (UIView *)switchView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.widthAlertView, _height * 2 + _margin)];
    
    [view addSubview:self.eventTextField];
    [view addSubview:self.actionTextField];
    [view addSubview:self.eventSwitch];
    
    return view;
}

- (UIView *)colorRGBView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.widthAlertView, _height * 2 + _margin)];
    [view addSubview:self.eventTextField];
    [view addSubview:self.actionTextField];
    [view addSubview:self.colorRTextField];
    [view addSubview:self.colorGTextField];
    [view addSubview:self.colorBTextField];
    [view addSubview:self.brightnessColorRGBTextField];
    
    return view;
}

- (UIView *)colorTemperatureView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.widthAlertView, _height * 2 + _margin)];
    
    [view addSubview:self.eventTextField];
    [view addSubview:self.actionTextField];
    [view addSubview:self.brightnessColorTemperatureTextField];
    [view addSubview:self.colorTemperatureTextField];
    
    return view;
}

- (IBAction)tappedSaveButton:(id)sender {
    
    // set user favorite color temperature
    self.configuration.userFavoriteColorTemperature.brightness = self.brightnessTextField.text.intValue;
    
    self.configuration.userFavoriteColorTemperature.colorTemperature = self.colorTextField.text.intValue;
    
    self.configuration.userFavoriteColorTemperature.distance = self.distanceTextField.text.intValue;
    
    // set do not disturb
    self.configuration.doNotDisturb.on = self.doNotDisturbSwitch.on;
    
    TIME startTime = {.hour = self.startHourTextField.text.intValue, .minute = self.startMinuteTextField.text.intValue};
    
    TIME endTime = {.hour = self.endHourTextField.text.intValue, .minute = self.endMinuteTextField.text.intValue};
    
    self.configuration.doNotDisturb.start = startTime;
    self.configuration.doNotDisturb.end = endTime;
    
    // set configuration
    [self.device setMisfitControllerConfiguration:self.configuration completion:^(MFIBoltDevice *boltDevice, MFIBoltActionError *error) {
        NSString *message = !error ? @"Set configuration succeeded" : error.localizedDescription;
    
        [self showMessage:message];
        
        [self updateUI];
        
    }];
    [self updateUI];
    [self reloadTable];
}


- (IBAction)tappedAddEventButton:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Input" message:nil delegate:self cancelButtonTitle:@"Cancel"otherButtonTitles:@"OK", nil];
    
    switch (self.modeEventSegmentedControl.selectedSegmentIndex) {
        case 0:
        {
            [alertView setValue:[self switchView] forKey:kMisfitControllerConfigurationViewControllerAccessoryView];
            break;
        }
        case 1:
        {
            [alertView setValue:[self colorRGBView] forKey:kMisfitControllerConfigurationViewControllerAccessoryView];
            break;
        }
        case 2:
        {
            [alertView setValue:[self colorTemperatureView] forKey:kMisfitControllerConfigurationViewControllerAccessoryView];
            break;
        }
    }
    
    [alertView show];
}


#pragma mark - Private functions

- (void)updateUI
{
    if (![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI];
        });
        return;
    }
    
    self.saveConfigurationButton.enabled
    = self.addEventButton.enabled
    = (self.device.state == MFIBoltDeviceStateReady);
    
    if (self.configuration != nil)
    {
        self.doNotDisturbSwitch.on = self.configuration.doNotDisturb.on;
        self.startHourTextField.text = [NSString stringWithFormat:@"%d", self.configuration.doNotDisturb.start.hour];
        self.startMinuteTextField.text = [NSString stringWithFormat:@"%d", self.configuration.doNotDisturb.start.minute];
        self.endHourTextField.text = [NSString stringWithFormat:@"%d", self.configuration.doNotDisturb.end.hour];
        self.endMinuteTextField.text = [NSString stringWithFormat:@"%d", self.configuration.doNotDisturb.end.minute];
        
        self.colorTextField.text = [NSString stringWithFormat:@"%d", self.configuration.userFavoriteColorTemperature.colorTemperature];
        self.brightnessTextField.text = [NSString stringWithFormat:@"%d", self.configuration.userFavoriteColorTemperature.brightness];
        self.distanceTextField.text = [NSString stringWithFormat:@"%d", self.configuration.userFavoriteColorTemperature.distance];
        
    }
}

- (void)reloadTable
{
    if (![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadTable];
        });
        return;
    }
    
    [self.eventTableView reloadData];
}

- (void)showMessage:(NSString *)message
{
    if (![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMessage:message];
        });
        return;
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Notice"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
}

- (void)loadData
{
    [self.device getConfigurationWithMisfitController:self.misfitController completion:^(MFIBoltDevice *boltDevice, MFIBoltMisfitControllerConfiguration *misfitControllerConfiguration, MFIBoltActionError *error) {
        if (error)
        {
            [self loadData];
            return;
        }
        
        self.configuration = misfitControllerConfiguration;
        
        [self reloadTable];
        [self updateUI];
    }];
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.configuration.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCellView"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EventCellView"];
    }
    
    MFIBoltMisfitControllerEvent *event = self.configuration.events[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Event=%d Action=%d", event.event, event.action];
    NSString *detail;
    
    switch (event.mode) {
        case MFIBoltMisfitControllerEventModeColorRGB:
        {
            MFIBoltMisfitControllerEventColorRGB *eventColorRGB = (MFIBoltMisfitControllerEventColorRGB *)event;
            
            detail = [NSString stringWithFormat:@"R=%d G=%d B=%d brightness=%d", eventColorRGB.color.R, eventColorRGB.color.G, eventColorRGB.color.B, eventColorRGB.brightness];
            
            break;
        }
        case MFIBoltMisfitControllerEventModeColorTemperature:
        {
            MFIBoltMisfitControllerEventColorTemperature *eventColorTemperature = (MFIBoltMisfitControllerEventColorTemperature *)event;
            
            detail = [NSString stringWithFormat:@"colorTemperature=%d brightness=%d", eventColorTemperature.colorTemperature, eventColorTemperature.brightness];
            
            break;
        }
        case MFIBoltMisfitControllerEventModeSwitch:
        {
            MFIBoltMisfitControllerEventSwitch *eventSwitch = (MFIBoltMisfitControllerEventSwitch *)event;
            
            detail = [NSString stringWithFormat:@"switch=%d", eventSwitch.on];
            
            break;
        }
    }
    
    cell.detailTextLabel.text = detail;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.configuration.events removeObject:self.configuration.events[indexPath.row]];
        
        [self reloadTable];
    }
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        MFIBoltMisfitControllerEvent *misfitControllerEvent;
        
        uint8_t event = [self.eventTextField.text intValue];
        
        uint8_t action = [self.actionTextField.text intValue];
        
        switch (self.modeEventSegmentedControl.selectedSegmentIndex) {
            case 0:
            {
                BOOL on = self.eventSwitch.on;
                
                misfitControllerEvent = MFIBoltMisfitControllerEventSwitchMake(event, action, on);
                
                break;
            }
            case 1:
            {
                RGB color;
                color.R = [self.colorRTextField.text intValue];
                color.G = [self.colorGTextField.text intValue];
                color.B = [self.colorBTextField.text intValue];
                uint8_t brightness = [self.brightnessColorRGBTextField.text intValue];
                
                misfitControllerEvent = MFIBoltMisfitControllerEventColorRGBMake(event, action, color, brightness);
               
                break;
            }
            case 2:
            {
                uint16_t colorTemperature = [self.colorTemperatureTextField.text intValue];
                uint8_t brightness = [self.brightnessColorTemperatureTextField.text intValue];
                
                misfitControllerEvent = MFIBoltMisfitControllerEventColorTemperatureMake(event, action, colorTemperature, brightness);
                
                break;
            }
        }
        
        [self.configuration.events addObject:misfitControllerEvent];
        
        [self reloadTable];
    }
}

@end
