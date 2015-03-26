//
//  ViewController.m
//  MisfitBoltSDKDemo
//
//  Created by Nghia Nguyen on 10/23/14.
//  Copyright (c) 2014 Misfit. All rights reserved.
//

#import "ViewController.h"
#import "DeviceViewController.h"
#import "MultipleDevicesViewController.h"

@interface ViewController ()<MFIBoltManagerDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *multipleDevicesBut;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *scanButton;
@property (weak, nonatomic) IBOutlet UITableView *deviceTable;

@property (copy, nonatomic) NSMutableArray *devicesSelected;
@property (weak, nonatomic) IBOutlet UIButton *retrieveDevicesButton;

@end

@implementation ViewController
{
    MFIBoltManager *_manager;
    NSMutableOrderedSet *_devices;
    
    NSString *_scanButtonTitleTemp;
    
    NSIndexPath *_currentAccessoryTapped;
}

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _devicesSelected = [NSMutableArray new];
    
    _manager = [MFIBoltManager sharedInstance];
    _manager.delegate = self;
    
    _devices = [NSMutableOrderedSet new];
    _scanButton.enabled = NO;
    
    _multipleDevicesBut.enabled = NO;
    
    _deviceTable.allowsSelectionDuringEditing = YES;
    //[_deviceTable setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - MFIBoltManagerDelegate

- (void)didDiscoverDevice:(MFIBoltDevice *)device RSSI:(NSNumber *)RSSI
{
    [_devices addObject:device];
    
    NSLog(@"%@", device.uuidString);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_deviceTable reloadData];
    });
}

- (void)centralManagerDidUpdateState
{
    if (_manager.state == CBCentralManagerStatePoweredOn)
    {
        //enable start scan
        dispatch_async(dispatch_get_main_queue(), ^{
            _scanButton.enabled = YES;
        });
    }
}
- (void)scanDidStopUnexpectedly
{
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Scan is stopped unexpectedly"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
}

#pragma mark - Event

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segue_device"])
    {
        DeviceViewController *controller = [segue destinationViewController];
        controller.device = _devices[[_deviceTable indexPathForCell:sender].row];
    }
    else
        if ([segue.identifier isEqualToString:@"segue_multiple"])
        {
            MultipleDevicesViewController *controller = [segue destinationViewController];
            controller.devices = [_devicesSelected copy];
        }
}

- (IBAction)onScanClick:(id)sender {
    
    if (_deviceTable.editing)
    {
        if (_devicesSelected.count > 0)
        {
            [self performSegueWithIdentifier:@"segue_multiple" sender:sender];
            // push to multiple bulbs view controller
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Notice" message:@"Please choose devices."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        }
        return;
    }
    
    if (!_manager.isScanning)
    {
        [_devices removeAllObjects];
        [_deviceTable reloadData];
        
        [_manager startScan];
    }
    else
    {
        [_manager stopScan];
    }
    
    _scanButton.title = (_manager.isScanning) ? @"Stop scan" : @"Start scan";
}
- (IBAction)tappedMultipleDevice:(id)sender {
    if (_deviceTable.editing)
    {
        [_devicesSelected removeAllObjects];
        [_deviceTable setEditing:NO animated:YES];
        _multipleDevicesBut.title = @"Multiple Devices";
        
        _scanButton.title = _scanButtonTitleTemp;
    }
    else
    {
        [_deviceTable setEditing:YES animated:YES];
        _multipleDevicesBut.title = @"Cancel";
        
        _scanButtonTitleTemp = _scanButton.title;
        _scanButton.title = @"Control";
        
    }
    [_deviceTable reloadData];
}

- (IBAction)tappedRetriveDevicesButton:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Input" message:@"Insert uuid string" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertView show];
}

#pragma mark - Table delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"device_cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"device_cell"];
    }
    MFIBoltDevice *device = _devices[indexPath.row];
    
    if (tableView.editing)
    {
        if ([_devicesSelected containsObject:device])
        {
            cell.editingAccessoryType = UITableViewCellAccessoryCheckmark;
        }
        else cell.editingAccessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = device.uuidString;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI: %d", device.RSSI.intValue];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _multipleDevicesBut.enabled = _devices.count > 0;
    return _devices.count;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing)
    {
        MFIBoltDevice *device = _devices[indexPath.row];
        
        if ([_devicesSelected containsObject:device])
        {
            [_devicesSelected removeObject:device];
        }
        else [_devicesSelected addObject:device];
        
        [tableView reloadData];
    }
    return indexPath;
}

// remove delete button while editing mode.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) // OK
    {
        UITextField *uuidTextField = [alertView textFieldAtIndex:0];
        
        [_manager retrieveDevicesWithIdentifiers:@[uuidTextField.text] completion:^(NSArray *devices) {
            if (devices != nil)
            {
                [_devices addObjectsFromArray:devices];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_deviceTable reloadData];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No device was found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                });
            }
        }];
    }
}

@end

