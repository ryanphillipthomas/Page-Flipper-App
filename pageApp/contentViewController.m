//
//  contentViewController.m
//  pageApp
//
//  Created by Ryan Thomas on 5/6/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "contentViewController.h"
#import "ZOZoomImageViewController.h"
#import "ZOReaderSettingsViewController.h"

#define kToolBarFadeDuration            0.33f
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface contentViewController ()
@end

@implementation contentViewController
{
    BOOL _toolBarsHidden;
    NSInteger _currentPageNumber;
    NSInteger _totalNumberOfPages;
}

@synthesize contentWebView, dataObject, imageURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil toolBarsHidden:(BOOL)toolBarsHidden currentPageNumber:(NSInteger)currentPageNumber totalNumberOfPages:(NSInteger)totalNumberOfPages;

{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _toolBarsHidden = toolBarsHidden;
        _currentPageNumber = currentPageNumber;
        _totalNumberOfPages = totalNumberOfPages;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupWebView];
    [self setupToolBars];
    [self setupWebViewSettings];
    [self setupGestureView];
    [self setupLabels];
    [self setupScrubber];
}

- (void)setupGestureView
{
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toolBarGestureTapped:)];
    singleFingerTap.delegate = self;
    singleFingerTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *doubleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleFingerTap.numberOfTapsRequired = 2;
    doubleFingerTap.delegate = self;
    
    [self.toolbarGestureView addGestureRecognizer:doubleFingerTap];
    [self.toolbarGestureView addGestureRecognizer:singleFingerTap];
    
    [singleFingerTap requireGestureRecognizerToFail:doubleFingerTap];
   // [doubleFingerTap requireGestureRecognizerToFail:singleFingerTap];
}

- (void)setupScrubber
{
    NSInteger total = (NSInteger)floorf(_totalNumberOfPages);
    NSInteger current = (NSInteger)floorf(_currentPageNumber);
    
    UIColor *scrubberColor = [UIColor darkGrayColor];
    
    [self.scrubberView setMinimumTrackTintColor:scrubberColor];
    
    [self.scrubberView setThumbImage:[UIImage imageNamed:@"scrubber"] forState:UIControlStateNormal];
    
    [self.scrubberView setMaximumValue:total];
    [self.scrubberView setMinimumValue:0];
    [self.scrubberView setValue:current];
}

- (void)setupLabels
{
    CGFloat elementsAlpha = (_toolBarsHidden) ? 0.5 : 1.0;
    
    [self.bookTitleLabel setAlpha:elementsAlpha];
    [self.pageOfPagesLabel setAlpha:elementsAlpha];

    [self.numberOfPagesLeftLabel setText:[self numberOfPagesLeftString]];
    [self.pageOfPagesLabel setText:[NSString stringWithFormat:@"%li of %li", (long)_currentPageNumber, (long)_totalNumberOfPages]];
    [self.scrubberChapterLabel setText:[NSString stringWithFormat:@"Chapter %li", (long)_currentPageNumber]];
    [self.scrubberPagesLabel setText:[NSString stringWithFormat:@"Page %li", (long)_currentPageNumber]];
}

- (NSString *)numberOfPagesLeftString
{
    NSString *string;
    
    if (IDIOM == IPAD) {
        if (_currentPageNumber == _totalNumberOfPages) {
            string = @"Last page in this chapter";
        } else {
            if (_totalNumberOfPages - _currentPageNumber > 1) {
                string = [NSString stringWithFormat:@"%li pages left in this chapter", (long)_totalNumberOfPages - _currentPageNumber];
            } else {
                string = [NSString stringWithFormat:@"%li page left in this chapter", (long)_totalNumberOfPages - _currentPageNumber];
            }
        }
    } else {
        if (_currentPageNumber == _totalNumberOfPages) {
            string = @"Last page";
        } else {
            if (_totalNumberOfPages - _currentPageNumber > 1) {
                string = [NSString stringWithFormat:@"%li pages left", (long)_totalNumberOfPages - (long)_currentPageNumber];
            } else {
                string = [NSString stringWithFormat:@"%li page left", (long)_totalNumberOfPages - (long)_currentPageNumber];
            }
        }
    }
    
    return string;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebView delegate implementation

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Inject custom image css to auto scale image sizes to fit within the reader webview frame.
    NSString *cssString = @"img {max-width:100% !important; height:auto !important; width:auto !important}";
    NSString *javascriptString = @"var style = document.createElement('style'); style.innerHTML = '%@'; document.head.appendChild(style)";
    NSString *javascriptWithCSSString = [NSString stringWithFormat:javascriptString, cssString];
    [webView stringByEvaluatingJavaScriptFromString:javascriptWithCSSString];
    
//    NSArray *webviewSettings = [webView getWebViewSettingOrientation:self.interfaceOrientation];
//    for (NSString *rule in webviewSettings)
//        [webView stringByEvaluatingJavaScriptFromString:rule];
    
//    /* Handle navigation */
//    int totalWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
//    self.screensInCurrentChapterCount = (int)ceil(totalWidth/webView.bounds.size.width);
}

- (void)setupWebView
{
    [self.contentWebView loadRequest:[NSURLRequest requestWithURL:dataObject]];
    self.contentWebView.delegate = self;
}

- (void)setupToolBars
{
    CGFloat alpha = (_toolBarsHidden) ? 0.0 : 1.0;
    
    [self.topToolBar setAlpha:alpha];
    [self.bottomToolBar setAlpha:alpha];
}

- (void)setupWebViewSettings
{
    self.contentWebView.scrollView.scrollEnabled = NO;
    self.contentWebView.scrollView.bounces = NO;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender
{
    if ([self shouldDisplayImageDetail]) {
        ZOZoomImageViewController *viewController = [[ZOZoomImageViewController alloc] initWithImageURL:self.imageURL
                                                                                         backroundColor:[UIColor whiteColor]
                                                                                            actionColor:[UIColor whiteColor]];
        
        [self presentViewController:viewController animated:YES completion:^{
            [self didDisplayImageDetail];
        }];
    }
}

- (void)toolBarGestureTapped:(id)selector
{
    BOOL hidden = (_toolBarsHidden) ? NO : YES;
    
    [self setToolBarsHidden:hidden];
    [self.delegate setStatusBarHidden:hidden]; //required
}

- (void)setToolBarsHidden:(BOOL)hidden
{
    _toolBarsHidden = hidden;

    [UIView animateWithDuration:kToolBarFadeDuration animations:^{
        CGFloat alpha = (hidden) ? 0.0 : 1.0;
        CGFloat elementsAlpha = (hidden) ? 0.5 : 1.0;

        [self.topToolBar setAlpha:alpha];
        [self.bottomToolBar setAlpha:alpha];
        [self.pageOfPagesLabel setAlpha:elementsAlpha];
        [self.bookTitleLabel setAlpha:elementsAlpha];
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint point = [touch locationInView:self.view];
        
        //Examine point and return NO, if gesture should be ignored.
        if ([self pointInsideReaderControllerActionObjects:point]) {
            return NO;
        }
    }
    
    [self processImageDetailGestureRecognizer:gestureRecognizer withTouch:touch];

    return YES;
}

// Actions
- (IBAction)backButtonTapped:(id)sender {
    
}

- (IBAction)chapterButtonTapped:(id)sender {
}

- (IBAction)fontsButtonTapped:(id)sender {
    ZOReaderSettingsViewController *readerSettingsViewController = [[ZOReaderSettingsViewController alloc] initWithNibName:nil bundle:nil];
    readerSettingsViewController.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *popView = readerSettingsViewController.popoverPresentationController;
    readerSettingsViewController.popoverPresentationController.sourceRect = self.fontsButton.bounds;
    readerSettingsViewController.popoverPresentationController.sourceView = self.fontsButton;
    
    popView.delegate = self;
    popView.permittedArrowDirections = UIPopoverArrowDirectionUp;

    [self presentViewController:readerSettingsViewController animated:YES completion:nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}

- (IBAction)searchButtonTapped:(id)sender {
}


- (IBAction)bookmarkButtonTapped:(id)sender {
}


- (BOOL)pointInsideReaderControllerActionObjects:(CGPoint)point
{
    if ([self pointInsideScrubber:point]
        || [self pointInsideFontsButton:point]
        || [self pointInsideSearchButton:point]
        || [self pointInsideChapterButton:point]
        || [self pointInsideBookmarkButton:point]
        || [self pointInsideBackButton:point]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)pointInsideBackButton:(CGPoint)point
{
    return CGRectContainsPoint(self.backButton.frame, point);
}

- (BOOL)pointInsideBookmarkButton:(CGPoint)point
{
    return CGRectContainsPoint(self.bookmarkButton.frame, point);
}

- (BOOL)pointInsideSearchButton:(CGPoint)point
{
    return CGRectContainsPoint(self.searchButton.frame, point);
}

- (BOOL)pointInsideFontsButton:(CGPoint)point
{
    return CGRectContainsPoint(self.fontsButton.frame, point);
}

- (BOOL)pointInsideChapterButton:(CGPoint)point
{
    return CGRectContainsPoint(self.chapterButton.frame, point);
}

- (BOOL)pointInsideScrubber:(CGPoint)point
{
    return CGRectContainsPoint(self.scrubberGestureView.frame, point);
}

- (IBAction)scrubberValueStartedChange:(id)sender
{
    [self setScrubberContentViewHidden:NO];
}

- (IBAction)scrubberValueFinishedChange:(id)sender
{
    [self setScrubberContentViewHidden:YES];
}

- (IBAction)scrubberValueChanged:(id)sender
{
    NSInteger current = (NSInteger)floorf(self.scrubberView.value);
    [self updateUIOnScrubberContentView:current];
}

- (void)updateUIOnScrubberContentView:(NSInteger)currentValue
{
    [self.scrubberChapterLabel setText:[NSString stringWithFormat:@"Chapter %li", (long)currentValue]];
    [self.scrubberPagesLabel setText:[NSString stringWithFormat:@"Page %li", (long)currentValue]];
}

- (void)setScrubberContentViewHidden:(BOOL)hidden
{
    [UIView animateWithDuration:kToolBarFadeDuration animations:^{
        CGFloat alpha = (hidden) ? 0.0 : 0.9;
        [self.scrubberContentView setAlpha:alpha];
    }];
}

//Image Detail Methods
- (void)processImageDetailGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer withTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint touchPoint = [touch locationInView:self.view];
        
        if([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait||
           [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortraitUpsideDown) {
            NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
            NSString *imgTag = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", touchPoint.x, touchPoint.y];
            
            NSString *url = [contentWebView stringByEvaluatingJavaScriptFromString:imgURL];
            NSString *tag = [contentWebView stringByEvaluatingJavaScriptFromString:imgTag];
            
            if ([self shouldSaveImageURL:url tagName:tag]) {
                self.imageURL = [NSURL URLWithString:url];
            }
        }
    }
}

- (BOOL)shouldSaveImageURL:(NSString *)urlToSave tagName:(NSString *)tagName
{
    if ([tagName isEqualToString:@"img"] && urlToSave.length > 0) {
        return YES;
    }
    
    return NO;
}

- (BOOL)shouldDisplayImageDetail
{
    if (self.imageURL.absoluteString.length > 0) {
        return YES;
    }
    
    return NO;
}

- (void)didDisplayImageDetail
{
    self.imageURL = nil;
}

@end
