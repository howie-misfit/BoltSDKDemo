//
//  MisfitControllerListViewController.m
//  MisfitBoltSDKDemo
//
//  Created by Nghia Nguyen on 2/27/15.
//  Copyright (c) 2015 Misfit. All rights reserved.
//

#import "MisfitControllerListViewController.h"
#import "DeviceViewController.h"
#import "MisfitControllerConfigurationViewController.h"
#import <MisfitBoltSDK/MisfitBoltSDK.h>

static NSString *const kMisfitControllerListViewControllerAccessoryView = @"accessoryView";

@interface MisfitControllerListViewController()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addMisfitControllerButton;
@property (weak, nonatomic) IBOutlet UITableView *misfitControllerTableView;
@property (weak, nonatomic) IBOutlet UISwitch *beaconControllerSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *proximitySwitch;

@property (nonatomic) NSMutableArray *misfitControllers;
@property (nonatomic) BOOL isProximityEnabled;
@property (nonatomic) BOOL isBeaconControllerEnabled;
@property (nonatomic) MFIBoltMisfitController *misfitController;

@property (nonatomic) UITextField *macAddressTextField;
@property (nonatomic) UISegmentedControl *sourceTypeSegmentedControl;

@property (nonatomic) int widthOfAlertView;

@end

@implementation MisfitControllerListViewController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.misfitControllerTableView.delegate = self;
    self.misfitControllerTableView.dataSource = self;
    
    self.widthOfAlertView = self.view.frame.size.width * 2 / 3;
    int margin = 5;
    int height = 30;
    
    self.macAddressTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, _widthOfAlertView / 2 - margin, height)];
    self.macAddressTextField.placeholder = @"Mac Address";
    self.macAddressTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    self.sourceTypeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Shine", @"Flash"]];
    self.sourceTypeSegmentedControl.frame = CGRectMake(_widthOfAlertView / 2, 0, _widthOfAlertView / 2 - margin, height);
    self.sourceTypeSegmentedControl.selectedSegmentIndex = 1;
    
    [self loadData];
    
    [self updateUI];
}

#pragma mark - Private function

- (void)loadData
{
    if (self.device.state != MFIBoltDeviceStateReady)
    {
        [self showMessage:@"Bolt isn't ready to use"];
        return;
    }
    
    [self.device getMisfitControllersWithCompletion:^(MFIBoltDevice *boltDevice, NSArray *misfitControllers, MFIBoltActionError *error) {
        
        if (error)
        {
            [self loadData];
            return;
        }
        
        self.misfitControllers = [NSMutableArray arrayWithArray:misfitControllers];
    
        [self.device getSwitchOfBeaconControllerAndProximityWithCompletion:^(MFIBoltDevice *boltDevice, BOOL isBeaconControllerEnabled, BOOL isProximityEnabled, MFIBoltActionError *error) {
            if (error)
            {
                [self loadData];
                return;
            }
            
            self.isBeaconControllerEnabled = isBeaconControllerEnabled;
            self.isProximityEnabled = isProximityEnabled;
            
            [self reloadTable];
            [self updateUI];
        }];
        
    }];
}

- (void)updateUI
{
    if (![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI];
        });
        return;
    }
    
    self.addMisfitControllerButton.enabled
    = self.beaconControllerSwitch.enabled
    = self.proximitySwitch.enabled
    = self.device.state == MFIBoltDeviceStateReady;
    
    self.beaconControllerSwitch.on = self.isBeaconControllerEnabled;
    self.proximitySwitch.on = self.isProximityEnabled;
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
    
    [self.misfitControllerTableView reloadData];
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

- (NSString *)macAddressFromData:(NSData *)data
{
    const unsigned char *bytes=  (const unsigned char*)data.bytes;
    NSMutableString *result = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < data.length - 1; i++) {
        [result appendFormat:@"%02lx:", (unsigned long)bytes[i]];
    }
    [result appendFormat:@"%02lx", (unsigned long)bytes[data.length - 1]];
    return result;
}

- (NSData *)dataFromMacAddressString:(NSString *)macAddressString
{
    NSMutableData *data = [[NSMutableData alloc] init];
    
    for (int i = 0; i < macAddressString.length / 2; i ++)
    {
        NSScanner *scanner = [[NSScanner alloc] initWithString:[macAddressString substringWithRange:NSMakeRange(i * 2, 2)]];
        
        unsigned int hex;
        [scanner scanHexInt:&hex];
        
        uint8_t hex8bit = hex;
        
        [data appendBytes:&hex8bit length:sizeof(hex8bit)];
    }
    return data;
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.misfitControllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MisfitControllerCellView"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MisfitControllerCellView"];
    }
    
    MFIBoltMisfitController *misfitController = self.misfitControllers[indexPath.row];
    cell.textLabel.text = [self macAddressFromData:misfitController.macAddress];
    cell.detailTextLabel.text = misfitController.sourceType == MFIBoltMisfitControllerSourceTypeFlash ? @"Flash" : @"Shine";
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
        [self.device deleteMisfitController:self.misfitControllers[indexPath.row] completion:^(MFIBoltDevice *boltDevice, MFIBoltActionError *error) {
            
            if (!error)
            {
                [_misfitControllers removeObject:self.misfitControllers[indexPath.row]];
                
                [self reloadTable];
                return;
            }
            
            [self showMessage:@"Delete failed."];
        }];
    }
}

#pragma mark - Events

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MisfitControllerCellSegue"])
    {
        MisfitControllerConfigurationViewController *destination = [segue destinationViewController];
        destination.device = self.device;
        
        destination.misfitController = self.misfitControllers[[self.misfitControllerTableView indexPathForCell:sender].row];
    }
}

- (IBAction)switchBeaconController:(id)sender {
    [self.device switchBeaconController:self.beaconControllerSwitch.on completion:^(MFIBoltDevice *boltDevice, MFIBoltActionError *error) {
        if (error)
        {
            self.beaconControllerSwitch.on = !self.beaconControllerSwitch.on;
            
            [self showMessage:error.localizedDescription];
        }
        else
        {
            self.isBeaconControllerEnabled = !self.isBeaconControllerEnabled;
        }
        
        [self updateUI];
    }];
    
    [self updateUI];
}

- (IBAction)switchProximity:(id)sender {
    [self.device switchProximity:self.proximitySwitch.on completion:^(MFIBoltDevice *boltDevice, MFIBoltActionError *error) {
        if (error)
        {
            [self showMessage:error.localizedDescription];
        }
        else
        {
            self.isProximityEnabled = !self.isProximityEnabled;
        }
        
        [self updateUI];
    }];
    
    [self updateUI];
}

- (IBAction)tappedAddButton:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Input" message:nil delegate:self cancelButtonTitle:@"Cancel"otherButtonTitles:@"OK", nil];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _widthOfAlertView, 30)];
    
    [view addSubview:self.macAddressTextField];
    [view addSubview:self.sourceTypeSegmentedControl];
    
    [alertView setValue:view forKey:kMisfitControllerListViewControllerAccessoryView];
    
    [alertView show];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSData *macAddress = [self dataFromMacAddressString:self.macAddressTextField.text];
        MFIBoltMisfitControllerSourceType sourceType = self.sourceTypeSegmentedControl.selectedSegmentIndex == 0 ? MFIBoltMisfitControllerSourceTypeShine : MFIBoltMisfitControllerSourceTypeFlash;
        
        MFIBoltMisfitController *misfitController = MFIBoltMisfitControllerMake(sourceType, macAddress);
        
        [self.misfitControllers addObject:misfitController];
        
        [self reloadTable];
    }
}

@end
