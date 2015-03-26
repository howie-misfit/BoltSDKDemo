//
//  FirmwareVersionViewController.m
//  MisfitBoltSDKDemo
//
//  Created by Nghia Nguyen on 2/12/15.
//  Copyright (c) 2015 Misfit. All rights reserved.
//

#import "FirmwareVersionViewController.h"

@interface FirmwareVersionViewController()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *firmwareVersionTableView;
@property NSArray *firmwareVersionPaths;

@end

@implementation FirmwareVersionViewController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    self.firmwareVersionTableView.delegate = self;
    self.firmwareVersionTableView.dataSource = self;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *root = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSError *error;
    
    self.firmwareVersionPaths = [fileManager contentsOfDirectoryAtURL:[NSURL URLWithString:root]
                                        includingPropertiesForKeys:nil
                                                           options:NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsSubdirectoryDescendants
                                                             error:&error];
}

#pragma mark - TableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firmwareCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"firmwareCell"];
    }
    
    NSURL *url = self.firmwareVersionPaths[indexPath.row];
    
    cell.textLabel.text = [url lastPathComponent];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = self.firmwareVersionPaths[indexPath.row];
    
    [self.delegate choosedAFirmwareVersionWithPath:url];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.firmwareVersionPaths.count;
}

@end
