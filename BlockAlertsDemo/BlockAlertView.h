//
//  BlockAlertView.h
//
//

#import <UIKit/UIKit.h>

@interface BlockAlertView : NSObject {
@protected
    UIView *_view;
    NSMutableArray *_blocks;
    CGFloat _height;
    NSString *_title;
    NSString *_message;
    BOOL _shown;
}

+ (BlockAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message;

- (id)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block;

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@property (nonatomic, readonly) UIView *view;

@end
