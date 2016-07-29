//
//  ZOZoomImageViewController.m
//

#import "ZOZoomImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ZOZoomImageViewController ()

@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *singleTapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGestureRecognizer;

@end

@implementation ZOZoomImageViewController

- (id)initWithImage:(UIImage *)image backroundColor:(UIColor *)backroundColor actionColor:(UIColor *)actionColor
{
    if (self = [super init]) {
        _image = image;
        _backroundColor = backroundColor;
        _actionColor = actionColor;
        
        self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.view.backgroundColor = backroundColor;
    }
    
    return self;
}

- (id)initWithImageURL:(NSURL *)imageURL backroundColor:(UIColor *)backroundColor actionColor:(UIColor *)actionColor
{
    if (self = [super init]) {
        _imageURL = imageURL;
        _backroundColor = backroundColor;
        _actionColor = actionColor;
        
        self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.view.backgroundColor = backroundColor;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
    if (self.imageURL) {
        // load placeholder image
        NSURL *url = self.imageURL;
        
        // request image
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        [manager downloadImageWithURL:url options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            self.imageView.alpha = 0.0;
            [UIView transitionWithView:_imageView
                              duration:0.6
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.imageView setImage:image];
                                self.imageView.alpha = 1.0;
                            } completion:NULL];
        }];
    
    } else {
        [self.imageView setImage:self.image];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UIScrollViewDelegate methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Private methods

- (IBAction)handleSingleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        // Zoom out
        [self.scrollView zoomToRect:self.scrollView.bounds animated:YES];
    }
}

- (IBAction)handleDoubleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        // Zoom in
        CGPoint center = [tapGestureRecognizer locationInView:self.scrollView];
        CGSize size = CGSizeMake(self.scrollView.bounds.size.width / self.scrollView.maximumZoomScale,
                                 self.scrollView.bounds.size.height / self.scrollView.maximumZoomScale);
        CGRect rect = CGRectMake(center.x - (size.width / 2.0), center.y - (size.height / 2.0), size.width, size.height);
        [self.scrollView zoomToRect:rect animated:YES];
    }
    else {
        // Zoom out
        [self.scrollView zoomToRect:self.scrollView.bounds animated:YES];
    }
}

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
//    if (self.imageView.image) {
//        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.imageView.image]
//                                                                                             applicationActivities:nil];
//        [self presentViewController:activityViewController
//                           animated:YES
//                         completion:nil];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
