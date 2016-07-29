//
//  ZOReaderFlipViewController.m
//  pageApp
//
//  Created by Ryan Thomas on 5/6/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "ZOReaderFlipViewController.h"

#define kStatusBarFadeDuration            0.33f
#define kDefaultToolBarHideSetting        NO
const NSInteger kDefaultPageNumber = 0;


@interface ZOReaderFlipViewController ()

@end

@implementation ZOReaderFlipViewController
{
    BOOL _hideToolBars;
    BOOL _pageIsAnimating;
    NSInteger _pageNumber;
}

@synthesize pageController, pageContent;

- (void)copyBook
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"book"];  //folder contain images in your bundle
    NSString *destPath = [documentsDirectory stringByAppendingPathComponent:@"book"];  //images is your folder under document directory
    
    NSError *error;
    [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destPath error:&error];  //copy every files from sourcePath to destPath
}

- (NSArray *)book
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *directoryURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSURL *bUrl = [directoryURL URLByAppendingPathComponent:@"book"];
    BOOL bookExists = [[NSFileManager defaultManager] fileExistsAtPath:bUrl.absoluteString];
    
    if (!bookExists) {
        [self copyBook];
    }
    
    NSURL *a = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"book/title" ofType:@"xhtml"] isDirectory:NO];
    
    NSEnumerator *enumerator = [fileManager enumeratorAtURL:bUrl includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey, NSURLContentModificationDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
    
    NSArray *bookData = [enumerator allObjects];
    
    if ([bookData count] > 0) {
        return bookData;
    }
    
    return @[a];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _hideToolBars = kDefaultToolBarHideSetting;
    _pageNumber = kDefaultPageNumber;
    
    [self loadChapterWithIndex:0 atScreenIndex:0 srcURLArray:[self book]];
     
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options: options];
    pageController.delegate = self;
    pageController.dataSource = self;
    
    [[pageController view] setFrame:[[self view] bounds]];

    contentViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:pageController];
    [[self view] addSubview:[pageController view]];
    [pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (contentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Return the data view controller for the given index.
    if (([self.pageContent count] == 0) ||
        (index >= [self.pageContent count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    contentViewController *dataViewController = [[contentViewController alloc] initWithNibName:@"contentViewController"
                                                                                        bundle:nil
                                                                                toolBarsHidden:_hideToolBars
                                                                             currentPageNumber:_pageNumber
                                                                            totalNumberOfPages:[self.pageContent count] - 1];
    dataViewController.dataObject = [self.pageContent objectAtIndex:index];
    dataViewController.delegate = self;
    
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(contentViewController *)viewController
{
    return [self.pageContent indexOfObject:viewController.dataObject];
}

- (void)loadChapterWithIndex:(NSInteger)chapterIndex
               atScreenIndex:(NSInteger)screenIndex
                 srcURLArray:(NSArray *)srcURLArray
{
    NSMutableArray *pageURLs = [[NSMutableArray alloc] init];
    for (int i = 0; i < srcURLArray.count; i++)
    {
        NSURL *pageURL = [srcURLArray objectAtIndex:i];
        [pageURLs addObject:pageURL];
    }
    
    pageContent = [[NSArray alloc] initWithArray:pageURLs];
}

-(void)setStatusBarHidden:(BOOL)hidden
{
    _hideToolBars = hidden;
    
    [UIView animateWithDuration:kStatusBarFadeDuration animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

- (BOOL)prefersStatusBarHidden {
    return _hideToolBars;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:
                        (contentViewController *)viewController];
    if ((index == 0) || (index == NSNotFound) || _pageIsAnimating) {
        return nil;
    }
    
    index--;
    
    _pageNumber = index;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(contentViewController *)viewController];
    if (index == NSNotFound || _pageIsAnimating) {
        return nil;
    }
    
    index++;
    if (index == [self.pageContent count]) {
        return nil;
    }
    
    _pageNumber = index;
    
    return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed || finished)
        _pageIsAnimating = NO;
}

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    _pageIsAnimating = YES;
}

@end
