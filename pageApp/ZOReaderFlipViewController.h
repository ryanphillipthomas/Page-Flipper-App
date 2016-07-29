//
//  ZOReaderFlipViewController.h
//  pageApp
//
//  Created by Ryan Thomas on 5/6/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "contentViewController.h"

@interface ZOReaderFlipViewController : UIViewController
<UIPageViewControllerDataSource, contentViewControllerDelegate, UIPageViewControllerDelegate>
{
    UIPageViewController *pageController;
    NSArray *pageContent;
}
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pageContent;

- (void)loadChapterWithIndex:(NSInteger)chapterIndex
               atScreenIndex:(NSInteger)screenIndex
                 srcURLArray:(NSArray *)srcURLArray;

@end

