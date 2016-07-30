//
//  ZOReaderSettingSideBySideTableViewCell.m
//  pageApp
//
//  Created by Ryan Thomas on 7/30/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "ZOReaderSettingSideBySideTableViewCell.h"

@implementation ZOReaderSettingSideBySideTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.toggle setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"kPageSideBySideSetting"]];
}

- (IBAction)toggleSettingsSwitch:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:[self.toggle isOn] forKey:@"kPageSideBySideSetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
