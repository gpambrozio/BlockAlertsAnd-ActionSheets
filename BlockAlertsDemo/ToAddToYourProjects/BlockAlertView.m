//
//  BlockAlertView.m
//
//

#import "BlockAlertView.h"
#import "BlockBackground.h"
#import "BlockUI.h"

@interface BlockAlertView ()
@property (nonatomic, strong) BlockAlertView *retainedSelf;
@property (nonatomic, readwrite, strong) UIView *view;

@end

@implementation BlockAlertView

@synthesize retainedSelf = _retainedSelf;
@synthesize view = _view;
@synthesize backgroundImage = _backgroundImage;
@synthesize vignetteBackground = _vignetteBackground;

static UIImage *background = nil;
static UIFont *titleFont = nil;
static UIFont *messageFont = nil;
static UIFont *buttonFont = nil;

#pragma mark - init

+ (void)initialize
{
    if (self == [BlockAlertView class])
    {
        background = [UIImage imageNamed:kAlertViewBackground];
        background = [background stretchableImageWithLeftCapWidth:0 topCapHeight:kAlertViewBackgroundCapHeight];
        titleFont = kAlertViewTitleFont;
        messageFont = kAlertViewMessageFont;
        buttonFont = kAlertViewButtonFont;
    }
}

+ (BlockAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message
{
    return [[BlockAlertView alloc] initWithTitle:title message:message];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithTitle:(NSString *)title message:(NSString *)message 
{
    if ((self = [super init]))
    {
        UIWindow *parentView = [BlockBackground sharedInstance];
        CGRect frame = parentView.bounds;
        frame.origin.x = floorf((frame.size.width - background.size.width) * 0.5);
        frame.size.width = background.size.width;
        
        self.view = [[UIView alloc] initWithFrame:frame];
        _blocks = [[NSMutableArray alloc] init];
        _height = kAlertViewBorder + 6;

        if (title)
        {
            CGSize size = [title sizeWithFont:titleFont
                            constrainedToSize:CGSizeMake(frame.size.width-kAlertViewBorder*2, 1000)
                                lineBreakMode:NSLineBreakByWordWrapping];

            UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(kAlertViewBorder, _height, frame.size.width-kAlertViewBorder*2, size.height)];
            labelView.font = titleFont;
            labelView.numberOfLines = 0;
            labelView.lineBreakMode = NSLineBreakByWordWrapping;
            labelView.textColor = kAlertViewTitleTextColor;
            labelView.backgroundColor = [UIColor clearColor];
            labelView.textAlignment = NSTextAlignmentCenter;
            labelView.shadowColor = kAlertViewTitleShadowColor;
            labelView.shadowOffset = kAlertViewTitleShadowOffset;
            labelView.text = title;
            [self.view addSubview:labelView];
            
            _height += size.height + kAlertViewBorder;
        }
        
        if (message)
        {
            CGSize size = [message sizeWithFont:messageFont
                              constrainedToSize:CGSizeMake(frame.size.width-kAlertViewBorder*2, 1000)
                                  lineBreakMode:NSLineBreakByWordWrapping];
            
            UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(kAlertViewBorder, _height, frame.size.width-kAlertViewBorder*2, size.height)];
            labelView.font = messageFont;
            labelView.numberOfLines = 0;
            labelView.lineBreakMode = NSLineBreakByWordWrapping;
            labelView.textColor = kAlertViewMessageTextColor;
            labelView.backgroundColor = [UIColor clearColor];
            labelView.textAlignment = NSTextAlignmentCenter;
            labelView.shadowColor = kAlertViewMessageShadowColor;
            labelView.shadowOffset = kAlertViewMessageShadowOffset;
            labelView.text = message;
            [self.view addSubview:labelView];
            
            _height += size.height + kAlertViewBorder;
        }
        
        _vignetteBackground = NO;
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)addButtonWithTitle:(NSString *)title color:(NSString*)color block:(void (^)())block 
{
    [_blocks addObject:[NSArray arrayWithObjects:
                        block ? [block copy] : [NSNull null],
                        title,
                        color,
                        nil]];
}

- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block 
{
    [self addButtonWithTitle:title color:@"gray" block:block];
}

- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block 
{
    [self addButtonWithTitle:title color:@"black" block:block];
}

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)())block
{
    [self addButtonWithTitle:title color:@"red" block:block];
}

- (void)show
{
    BOOL isSecondButton = NO;
    NSUInteger index = 0;
    for (NSUInteger i = 0; i < _blocks.count; i++)
    {
        NSArray *block = [_blocks objectAtIndex:i];
        NSString *title = [block objectAtIndex:1];
        NSString *color = [block objectAtIndex:2];

        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"alert-%@-button.png", color]];
        image = [image stretchableImageWithLeftCapWidth:(int)(image.size.width+1)>>1 topCapHeight:0];
        
        CGFloat maxHalfWidth = floorf((self.view.bounds.size.width-kAlertViewBorder*3)*0.5);
        CGFloat width = self.view.bounds.size.width-kAlertViewBorder*2;
        CGFloat xOffset = kAlertViewBorder;
        if (isSecondButton)
        {
            width = maxHalfWidth;
            xOffset = width + kAlertViewBorder * 2;
            isSecondButton = NO;
        }
        else if (i + 1 < _blocks.count)
        {
            // In this case there's another button.
            // Let's check if they fit on the same line.
            CGSize size = [title sizeWithFont:buttonFont 
                                  minFontSize:10 
                               actualFontSize:nil
                                     forWidth:self.view.bounds.size.width-kAlertViewBorder*2 
                                lineBreakMode:NSLineBreakByClipping];
            
            if (size.width < maxHalfWidth - kAlertViewBorder)
            {
                // It might fit. Check the next Button
                NSArray *block2 = [_blocks objectAtIndex:i+1];
                NSString *title2 = [block2 objectAtIndex:1];
                size = [title2 sizeWithFont:buttonFont 
                                minFontSize:10 
                             actualFontSize:nil
                                   forWidth:self.view.bounds.size.width-kAlertViewBorder*2 
                              lineBreakMode:NSLineBreakByClipping];
                
                if (size.width < maxHalfWidth - kAlertViewBorder)
                {
                    // They'll fit!
                    isSecondButton = YES;  // For the next iteration
                    width = maxHalfWidth;
                }
            }
        }
        else if (_blocks.count  == 1)
        {
            // In this case this is the ony button. We'll size according to the text
            CGSize size = [title sizeWithFont:buttonFont 
                                  minFontSize:10 
                               actualFontSize:nil
                                     forWidth:self.view.bounds.size.width-kAlertViewBorder*2 
                                lineBreakMode:NSLineBreakByClipping];

            size.width = MAX(size.width, 80);
            if (size.width + 2 * kAlertViewBorder < width)
            {
                width = size.width + 2 * kAlertViewBorder;
                xOffset = floorf((self.view.bounds.size.width - width) * 0.5);
            }
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(xOffset, _height, width, kAlertButtonHeight);
        button.titleLabel.font = buttonFont;
        if ([button.titleLabel respondsToSelector:@selector(setMinimumScaleFactor:)]) {
            button.titleLabel.minimumScaleFactor = 0.5;
        } else {
            button.titleLabel.minimumFontSize = 0.5;
        }
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.shadowOffset = kAlertViewButtonShadowOffset;
        button.backgroundColor = [UIColor clearColor];
        button.tag = i+1;
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitleColor:kAlertViewButtonTextColor forState:UIControlStateNormal];
        [button setTitleShadowColor:kAlertViewButtonShadowColor forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.accessibilityLabel = title;
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        
        if (!isSecondButton)
            _height += kAlertButtonHeight + kAlertViewBorder;
        
        index++;
    }
    
    _height += 10;  // Margin for the shadow
    
    if (_height < background.size.height)
    {
        CGFloat offset = background.size.height - _height;
        _height = background.size.height;
        CGRect frame;
        for (NSUInteger i = 0; i < _blocks.count; i++)
        {
            UIButton *btn = (UIButton *)[self.view viewWithTag:i+1];
            frame = btn.frame;
            frame.origin.y += offset;
            btn.frame = frame;
        }
    }

    CGRect frame = self.view.frame;
    frame.origin.y = - _height;
    frame.size.height = _height;
    self.view.frame = frame;
    
    UIImageView *modalBackground = [[UIImageView alloc] initWithFrame:self.view.bounds];
    modalBackground.image = background;
    modalBackground.contentMode = UIViewContentModeScaleToFill;
    [self.view insertSubview:modalBackground atIndex:0];
    
    if (_backgroundImage)
    {
        [BlockBackground sharedInstance].backgroundImage = _backgroundImage;
        _backgroundImage = nil;
    }
    [BlockBackground sharedInstance].vignetteBackground = _vignetteBackground;
    [[BlockBackground sharedInstance] addToMainWindow:self.view];

    __block CGPoint center = self.view.center;
    center.y = floorf([BlockBackground sharedInstance].bounds.size.height * 0.5) + kAlertViewBounce;
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [BlockBackground sharedInstance].alpha = 1.0f;
                         self.view.center = center;
                     } 
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:0
                                          animations:^{
                                              center.y -= kAlertViewBounce;
                                              self.view.center = center;
                                          } 
                                          completion:nil];
                     }];
    
    [self setRetainedSelf:self];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated 
{
    if (buttonIndex >= 0 && buttonIndex < [_blocks count])
    {
        id obj = [[_blocks objectAtIndex: buttonIndex] objectAtIndex:0];
        if (![obj isEqual:[NSNull null]])
        {
            ((void (^)())obj)();
        }
    }
    
    if (animated)
    {
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:0
                         animations:^{
                             CGPoint center = self.view.center;
                             center.y += 20;
                             self.view.center = center;
                         } 
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.4
                                                   delay:0.0 
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  CGRect frame = self.view.frame;
                                                  frame.origin.y = -frame.size.height;
                                                  self.view.frame = frame;
                                                  [[BlockBackground sharedInstance] reduceAlphaIfEmpty];
                                              } 
                                              completion:^(BOOL finished) {
                                                  [[BlockBackground sharedInstance] removeView:self.view];
                                                  self.view = nil;
                                                  [self setRetainedSelf:nil];
                                              }];
                         }];
    }
    else
    {
        [[BlockBackground sharedInstance] removeView:self.view];
        self.view = nil;
        [self setRetainedSelf:nil];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Action

- (void)buttonClicked:(id)sender 
{
    /* Run the button's block */
    int buttonIndex = [sender tag] - 1;
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

@end
