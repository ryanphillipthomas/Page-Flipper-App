//
//  ZOReaderSettingsViewController.h
//  pageApp
//
//  Created by Ryan Thomas on 7/29/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZOReaderSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
