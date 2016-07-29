//
//  ZOReaderSettingsViewController.m
//  pageApp
//
//  Created by Ryan Thomas on 7/29/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "ZOReaderSettingsViewController.h"
#import "ZOReaderSettingFontSizeTableViewCell.h"
#import "ZOReaderSettingFontTypeTableViewCell.h"
#import "ZOReaderSettingBrightnessTableViewCell.h"
#import "ZOReaderSettingColorSchemeTableViewCell.h"
#import "ZOReaderSettingAutoNightModeTableViewCell.h"

@interface ZOReaderSettingsViewController ()

@end

@implementation ZOReaderSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        
       cell = (ZOReaderSettingBrightnessTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"brightness"];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ZOReaderSettingBrightnessTableViewCell" bundle:nil] forCellReuseIdentifier:@"brightness"];
            cell = (ZOReaderSettingBrightnessTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"brightness"];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell = (ZOReaderSettingFontSizeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"fontSize"];
            
            if (cell == nil) {
                [tableView registerNib:[UINib nibWithNibName:@"ZOReaderSettingFontSizeTableViewCell" bundle:nil] forCellReuseIdentifier:@"fontSize"];
                cell = (ZOReaderSettingFontSizeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"fontSize"];
            }
        } else {
             cell = (ZOReaderSettingFontTypeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"fontType"];
            if (cell == nil) {
                [tableView registerNib:[UINib nibWithNibName:@"ZOReaderSettingFontTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"fontType"];
                cell = (ZOReaderSettingFontTypeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"fontType"];
            }
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell = (ZOReaderSettingColorSchemeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"colorScheme"];
            if (cell == nil) {
                [tableView registerNib:[UINib nibWithNibName:@"ZOReaderSettingColorSchemeTableViewCell" bundle:nil] forCellReuseIdentifier:@"colorScheme"];
                cell = (ZOReaderSettingColorSchemeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"colorScheme"];
            }
        } else {
            cell = (ZOReaderSettingAutoNightModeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"nightMode"];
            if (cell == nil) {
                [tableView registerNib:[UINib nibWithNibName:@"ZOReaderSettingAutoNightModeTableViewCell" bundle:nil] forCellReuseIdentifier:@"nightMode"];
                cell = (ZOReaderSettingAutoNightModeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"nightMode"];
            }
        }
    }

    return cell;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if (section == 0) {
        rows = 1;
    }
    
    if (section == 1) {
        rows = 2;
    }
    
    if (section == 2) {
        rows = 2;
    }
    
    return rows;
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

@end
