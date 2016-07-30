//
//  ZOReaderSettingTransitionDirectionTableViewCell.m
//  pageApp
//
//  Created by Ryan Thomas on 7/30/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "ZOReaderSettingTransitionDirectionTableViewCell.h"

@implementation ZOReaderSettingTransitionDirectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
        [self.toggle setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"kPageDirectionSetting"]];
}
- (IBAction)toggleSettingsSwitch:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:[self.toggle isOn] forKey:@"kPageDirectionSetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
