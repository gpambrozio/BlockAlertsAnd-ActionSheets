//
//  BlockActionSheet.m
//
//

#import "BlockActionSheet.h"
#import "BlockBackground.h"

@implementation BlockActionSheet

@synthesize view = _view;

static UIImage *background = nil;
static UIFont *titleFont = nil;
static UIFont *buttonFont = nil;

#define kBounce         10
#define kBorder         10
#define kButtonHeight   45
#define kTopMargin      15

#define kActionSheetBackground   @"action-sheet-panel.png"
#define kActionSheetBackgroundCapHeight  30

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
#define NSTextAlignmentCenter       UITextAlignmentCenter
#define NSLineBreakByWordWrapping   UILineBreakModeWordWrap
#endif

#ifndef IOS_LESS_THAN_6
#define IOS_LESS_THAN_6 !([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending)

#endif


#pragma mark - init

+ (void)initialize
{
    if (self == [BlockActionSheet class])
    {
        background = [UIImage imageNamed:kActionSheetBackground];
        background = [[background stretchableImageWithLeftCapWidth:0 topCapHeight:kActionSheetBackgroundCapHeight] retain];
        titleFont = [[UIFont systemFontOfSize:18] retain];
        buttonFont = [[UIFont boldSystemFontOfSize:20] retain];
    }
}

+ (id)sheetWithTitle:(NSString *)title
{
    return [[[BlockActionSheet alloc] initWithTitle:title] autorelease];
}

- (id)initWithTitle:(NSString *)title 
{
    if ((self = [super init]))
    {
        UIWindow *parentView = [BlockBackground sharedInstance];
        CGRect frame = parentView.bounds;
        
        _view = [[UIView alloc] initWithFrame:frame];
        
        _view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        _blocks = [[NSMutableArray alloc] init];
        _height = kTopMargin;

        if (title)
        {
            CGSize size = [title sizeWithFont:titleFont
                            constrainedToSize:CGSizeMake(frame.size.width-kBorder*2, 1000)
                                lineBreakMode:NSLineBreakByWordWrapping];
            
            UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(kBorder, _height, frame.size.width-kBorder*2, size.height)];
            labelView.font = titleFont;
            labelView.numberOfLines = 0;
            labelView.lineBreakMode = NSLineBreakByWordWrapping;
            labelView.textColor = [UIColor whiteColor];
            labelView.backgroundColor = [UIColor clearColor];
            labelView.textAlignment = NSTextAlignmentCenter;
            labelView.shadowColor = [UIColor blackColor];
            labelView.shadowOffset = CGSizeMake(0, -1);
            labelView.text = title;
            
            labelView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

            [_view addSubview:labelView];
            [labelView release];
            
            _height += size.height + 5;
        }
    }
    
    return self;
}

- (void) dealloc 
{
    [_view release];
    [_blocks release];
    [super dealloc];
}

- (NSUInteger)buttonCount
{
    return _blocks.count;
}

- (void)addButtonWithTitle:(NSString *)title color:(NSString*)color block:(void (^)())block atIndex:(NSInteger)index
{
    if (index >= 0)
    {
        [_blocks insertObject:[NSArray arrayWithObjects:
                               block ? [[block copy] autorelease] : [NSNull null],
                               title,
                               color,
                               nil]
                      atIndex:index];
    }
    else
    {
        [_blocks addObject:[NSArray arrayWithObjects:
                            block ? [[block copy] autorelease] : [NSNull null],
                            title,
                            color,
                            nil]];
    }
}

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)())block
{
    [self addButtonWithTitle:title color:@"red" block:block atIndex:-1];
}

- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block
{
    [self addButtonWithTitle:title color:@"black" block:block atIndex:-1];
}

- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block 
{
    [self addButtonWithTitle:title color:@"gray" block:block atIndex:-1];
}

- (void)setDestructiveButtonWithTitle:(NSString *)title atIndex:(NSInteger)index block:(void (^)())block
{
    [self addButtonWithTitle:title color:@"red" block:block atIndex:index];
}

- (void)setCancelButtonWithTitle:(NSString *)title atIndex:(NSInteger)index block:(void (^)())block
{
    [self addButtonWithTitle:title color:@"black" block:block atIndex:index];
}

- (void)addButtonWithTitle:(NSString *)title atIndex:(NSInteger)index block:(void (^)())block 
{
    [self addButtonWithTitle:title color:@"gray" block:block atIndex:index];
}

- (void)showInView:(UIView *)view
{
    NSUInteger i = 1;
    for (NSArray *block in _blocks)
    {
        NSString *title = [block objectAtIndex:1];
        NSString *color = [block objectAtIndex:2];
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"action-%@-button.png", color]];
        image = [image stretchableImageWithLeftCapWidth:(int)(image.size.width)>>1 topCapHeight:0];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kBorder, _height, _view.bounds.size.width-kBorder*2, kButtonHeight);
        button.titleLabel.font = buttonFont;
        if (IOS_LESS_THAN_6) {
#pragma clan diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            button.titleLabel.minimumFontSize = 10;
#pragma clan diagnostic pop
        }
        else {
            button.titleLabel.minimumScaleFactor = 0.1;
        }
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.shadowOffset = CGSizeMake(0, -1);
        button.backgroundColor = [UIColor clearColor];
        button.tag = i++;
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.accessibilityLabel = title;
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [_view addSubview:button];
        _height += kButtonHeight + kBorder;
    }
    
    UIImageView *modalBackground = [[UIImageView alloc] initWithFrame:_view.bounds];
    modalBackground.image = background;
    modalBackground.contentMode = UIViewContentModeScaleToFill;
    modalBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_view insertSubview:modalBackground atIndex:0];
    [modalBackground release];
    
    [[BlockBackground sharedInstance] addToMainWindow:_view];
    CGRect frame = _view.frame;
    frame.origin.y = [BlockBackground sharedInstance].bounds.size.height;
    frame.size.height = _height + kBounce;
    _view.frame = frame;
    
    __block CGPoint center = _view.center;
    center.y -= _height + kBounce;
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [BlockBackground sharedInstance].alpha = 1.0f;
                         _view.center = center;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              center.y += kBounce;
                                              _view.center = center;
                                          } completion:nil];
                     }];
    
    [self retain];
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
        CGPoint center = _view.center;
        center.y += _view.bounds.size.height;
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             _view.center = center;
                             [[BlockBackground sharedInstance] reduceAlphaIfEmpty];
                         } completion:^(BOOL finished) {
                             [[BlockBackground sharedInstance] removeView:_view];
                             [_view release]; _view = nil;
                             [self autorelease];
                         }];
    }
    else
    {
        [[BlockBackground sharedInstance] removeView:_view];
        [_view release]; _view = nil;
        [self autorelease];
    }
}

#pragma mark - Action

- (void)buttonClicked:(id)sender 
{
    /* Run the button's block */
    int buttonIndex = [sender tag] - 1;
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

@end
