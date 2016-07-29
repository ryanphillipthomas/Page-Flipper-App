//
//  ZOZoomImageViewController.h
//

#import <UIKit/UIKit.h>

@interface ZOZoomImageViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic, readonly) UIImage *image;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) UIColor *backroundColor;
@property (strong, nonatomic) UIColor *actionColor;
@property (nonatomic) bool toolbarsHidden;

-(id)initWithImage:(UIImage *)image backroundColor:(UIColor *)backroundColor actionColor:(UIColor *)actionColor;
-(id)initWithImageURL:(NSURL *)imageURL backroundColor:(UIColor *)backroundColor actionColor:(UIColor *)actionColor;

@end
