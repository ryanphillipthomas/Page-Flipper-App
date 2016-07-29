//
//  contentViewController.h
//  pageApp
//
//  Created by Ryan Thomas on 5/6/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol contentViewControllerDelegate <NSObject>
@required - (void)setStatusBarHidden:(BOOL)hidden;
@end

@interface contentViewController : UIViewController <UIWebViewDelegate, UIGestureRecognizerDelegate,UIPopoverPresentationControllerDelegate>

@property (assign, nonatomic) id<contentViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIWebView *contentWebView;
@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) NSURL *imageURL;

@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageOfPagesLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPagesLeftLabel;

@property (weak, nonatomic) IBOutlet UISlider *scrubberView;
@property (weak, nonatomic) IBOutlet UIView *scrubberContentView;
@property (weak, nonatomic) IBOutlet UIView *scrubberGestureView;
@property (weak, nonatomic) IBOutlet UILabel *scrubberPagesLabel;
@property (weak, nonatomic) IBOutlet UILabel *scrubberChapterLabel;

@property (weak, nonatomic) IBOutlet UIView *topToolBar;
@property (weak, nonatomic) IBOutlet UIView *bottomToolBar;
@property (strong, nonatomic) IBOutlet UIView *toolbarGestureView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *chapterButton;
@property (weak, nonatomic) IBOutlet UIButton *fontsButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
       toolBarsHidden:(BOOL)toolBarsHidden
    currentPageNumber:(NSInteger)currentPageNumber
   totalNumberOfPages:(NSInteger)totalNumberOfPages;

@end
