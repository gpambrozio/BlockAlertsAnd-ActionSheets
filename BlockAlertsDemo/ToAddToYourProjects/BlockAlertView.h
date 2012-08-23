//
//  BlockAlertView.h
//
//

#import <UIKit/UIKit.h>

typedef void(^BlockAlert)();

typedef enum {
    BlockAlertViewButtonClorsBlack = 0,
    BlockAlertViewButtonClorsGray,
    BlockAlertViewButtonClorsRed,
} BlockAlertViewButtonClors;

@interface BlockAlertView : NSObject {
@protected
    UIScrollView *_view;
    NSMutableArray *_blocks;
    CGFloat _height;
}

+ (BlockAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message;

- (id)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block;

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, readonly) UIView *view;
@property (nonatomic, readwrite) BOOL vignetteBackground;

@end
