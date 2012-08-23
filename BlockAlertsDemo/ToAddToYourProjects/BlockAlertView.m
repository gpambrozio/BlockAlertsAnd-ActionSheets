//
//  BlockAlertView.m
//
//

#import "BlockAlertView.h"
#import "BlockBackground.h"
#import "BlockUI.h"

@interface BlockAlertObject : NSObject
@property(nonatomic) BlockAlertViewButtonClors color;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, copy) BlockAlert block;

+ (BlockAlertObject *) blockObjectWithBlock: (BlockAlert) block
                                      color: (BlockAlertViewButtonClors) color
                                   andTitle: (NSString *) title;

@end

@implementation BlockAlertObject
@synthesize color = _color, title = _title, block = _block;

+ (BlockAlertObject *) blockObjectWithBlock: (BlockAlert) block
                                      color: (BlockAlertViewButtonClors) color
                                   andTitle: (NSString *) title {
    BlockAlertObject *blockObject = [[[self alloc] init] autorelease];
    blockObject.block = block;
    blockObject.color = color;
    blockObject.title = title;
    return blockObject;
}
- (void)setBlock:(BlockAlert)block{
    _block = block ? [[block copy] autorelease] : [NSNull null];
    [_block retain];
}
- (void)dealloc{
    [[self block] release];
    [super dealloc];
}
@end

@implementation BlockAlertView

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
        background = [[background stretchableImageWithLeftCapWidth:0 topCapHeight:kAlertViewBackgroundCapHeight] retain];
        titleFont = [kAlertViewTitleFont retain];
        messageFont = [kAlertViewMessageFont retain];
        buttonFont = [kAlertViewButtonFont retain];
    }
}

+ (BlockAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message
{
    return [[[BlockAlertView alloc] initWithTitle:title message:message] autorelease];
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
        
        _view = [[UIScrollView alloc] initWithFrame:frame];
        _blocks = [[NSMutableArray alloc] init];
        _height = kAlertViewBorder + 6;

        if (title)
        {
            CGSize size = [title sizeWithFont:titleFont
                            constrainedToSize:CGSizeMake(frame.size.width-kAlertViewBorder*2, 1000)
                                lineBreakMode:UILineBreakModeWordWrap];

            UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(kAlertViewBorder, _height, frame.size.width-kAlertViewBorder*2, size.height)];
            labelView.font = titleFont;
            labelView.numberOfLines = 0;
            labelView.lineBreakMode = UILineBreakModeWordWrap;
            labelView.textColor = kAlertViewTitleTextColor;
            labelView.backgroundColor = [UIColor clearColor];
            labelView.textAlignment = UITextAlignmentCenter;
            labelView.shadowColor = kAlertViewTitleShadowColor;
            labelView.shadowOffset = kAlertViewTitleShadowOffset;
            labelView.text = title;
            [_view addSubview:labelView];
            [labelView release];
            
            _height += size.height + kAlertViewBorder;
        }
        
        if (message)
        {
            CGSize size = [message sizeWithFont:messageFont
                              constrainedToSize:CGSizeMake(frame.size.width-kAlertViewBorder*2, 1000)
                                  lineBreakMode:UILineBreakModeWordWrap];
            
            UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(kAlertViewBorder, _height, frame.size.width-kAlertViewBorder*2, size.height)];
            labelView.font = messageFont;
            labelView.numberOfLines = 0;
            labelView.lineBreakMode = UILineBreakModeWordWrap;
            labelView.textColor = kAlertViewMessageTextColor;
            labelView.backgroundColor = [UIColor clearColor];
            labelView.textAlignment = UITextAlignmentCenter;
            labelView.shadowColor = kAlertViewMessageShadowColor;
            labelView.shadowOffset = kAlertViewMessageShadowOffset;
            labelView.text = message;
            [_view addSubview:labelView];
            [labelView release];
            
            _height += size.height + kAlertViewBorder;
        }
        
        _vignetteBackground = NO;
    }
    
    return self;
}
- (NSString*)formatColorTypeToString:(BlockAlertViewButtonClors) color{
    NSString *result = nil;
    
    switch(color) {
        case BlockAlertViewButtonClorsBlack:
            result = @"black";
            break;
        case BlockAlertViewButtonClorsGray:
            result = @"gray";
            break;
        case BlockAlertViewButtonClorsRed:
            result = @"red";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
    
    return result;
}
- (void)dealloc 
{
    [_backgroundImage release];
    [_view release];
    [_blocks release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)addButtonWithTitle:(NSString *)title
                     color:(BlockAlertViewButtonClors) color
                     block:(BlockAlert)block
{
    BlockAlertObject *blockObject = [BlockAlertObject blockObjectWithBlock: block
                                                                     color: color
                                                                  andTitle: title];                                     
    [_blocks addObject:blockObject];
}

- (void)addButtonWithTitle:(NSString *)title block:(BlockAlert)block 
{
    [self addButtonWithTitle:title color:BlockAlertViewButtonClorsGray block:block];
}

- (void)setCancelButtonWithTitle:(NSString *)title block:(BlockAlert)block 
{
    [self addButtonWithTitle:title color:BlockAlertViewButtonClorsBlack block:block];
}

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(BlockAlert)block
{
    [self addButtonWithTitle:title color:BlockAlertViewButtonClorsRed block:block];
}

- (void)show
{
    BOOL isSecondButton = NO;
    NSUInteger index = 0;
    for (BlockAlertObject *blockObject in _blocks) {
        NSInteger i = [_blocks indexOfObject:blockObject];
        NSString *color = [self formatColorTypeToString:blockObject.color];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"alert-%@-button.png", color]];
        image = [image stretchableImageWithLeftCapWidth:(int)(image.size.width+1)>>1 topCapHeight:0];
        
        CGFloat maxHalfWidth = floorf((_view.bounds.size.width-kAlertViewBorder*3)*0.5);
        CGFloat width = _view.bounds.size.width-kAlertViewBorder*2;
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
            CGSize size = [blockObject.title sizeWithFont:buttonFont
                                  minFontSize:10 
                               actualFontSize:nil
                                     forWidth:_view.bounds.size.width-kAlertViewBorder*2 
                                lineBreakMode:UILineBreakModeClip];
            
            if (size.width < maxHalfWidth - kAlertViewBorder){
                // It might fit. Check the next Button
                BlockAlertObject *blockObject2 = [_blocks objectAtIndex:i+1];
                NSString *title2 = blockObject2.title;
                size = [title2 sizeWithFont:buttonFont
                                minFontSize:10 
                             actualFontSize:nil
                                   forWidth:_view.bounds.size.width-kAlertViewBorder*2 
                              lineBreakMode:UILineBreakModeClip];

                if (size.width < maxHalfWidth - kAlertViewBorder){
                    // They'll fit!
                    isSecondButton = YES;  // For the next iteration
                    width = maxHalfWidth;
                }
            }
        }
        else if (_blocks.count  == 1)
        {
            // In this case this is the ony button. We'll size according to the text
            CGSize size = [blockObject.title sizeWithFont:buttonFont
                                  minFontSize:10 
                               actualFontSize:nil
                                     forWidth:_view.bounds.size.width-kAlertViewBorder*2 
                                lineBreakMode:UILineBreakModeClip];

            size.width = MAX(size.width, 80);
            if (size.width + 2 * kAlertViewBorder < width)
            {
                width = size.width + 2 * kAlertViewBorder;
                xOffset = floorf((_view.bounds.size.width - width) * 0.5);
            }
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(xOffset, _height, width, kAlertButtonHeight);
        button.titleLabel.font = buttonFont;
        button.titleLabel.minimumFontSize = 10;
        button.titleLabel.textAlignment = UITextAlignmentCenter;
        button.titleLabel.shadowOffset = kAlertViewButtonShadowOffset;
        button.backgroundColor = [UIColor clearColor];
        button.tag = i+1;
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitleColor:kAlertViewButtonTextColor forState:UIControlStateNormal];
        [button setTitleShadowColor:kAlertViewButtonShadowColor forState:UIControlStateNormal];
        [button setTitle:blockObject.title forState:UIControlStateNormal];
        button.accessibilityLabel = blockObject.title;
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_view addSubview:button];
        
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
            UIButton *btn = (UIButton *)[_view viewWithTag:i+1];
            frame = btn.frame;
            frame.origin.y += offset;
            btn.frame = frame;
        }
    }

    CGRect frame = _view.frame;
    frame.origin.y = - _height;
    frame.size.height = _height;
    _view.frame = frame;
    
    UIImageView *modalBackground = [[UIImageView alloc] initWithFrame:_view.bounds];
    modalBackground.image = background;
    modalBackground.contentMode = UIViewContentModeScaleToFill;
    [_view insertSubview:modalBackground atIndex:0];
    [modalBackground release];
    
    if (_backgroundImage)
    {
        [BlockBackground sharedInstance].backgroundImage = _backgroundImage;
        [_backgroundImage release];
        _backgroundImage = nil;
    }
    [BlockBackground sharedInstance].vignetteBackground = _vignetteBackground;
    [[BlockBackground sharedInstance] addToMainWindow:_view];

    __block CGPoint center = _view.center;
    center.y = floorf([BlockBackground sharedInstance].bounds.size.height * 0.5) + kAlertViewBounce;
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [BlockBackground sharedInstance].alpha = 1.0f;
                         _view.center = center;
                     } 
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:0
                                          animations:^{
                                              center.y -= kAlertViewBounce;
                                              _view.center = center;
                                          } 
                                          completion:^(BOOL finished) {
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertViewFinishedAnimations" object:nil];
                                          }];
                     }];
    
    [self retain];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated 
{
    if (buttonIndex >= 0 && buttonIndex < [_blocks count])
    {
       BlockAlertObject *blockObject = [_blocks objectAtIndex: buttonIndex];
       BlockAlert block = blockObject.block;
       if (![block isEqual:[NSNull null]]){
           block();
       }
    }
    
    if (animated)
    {
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:0
                         animations:^{
                             CGPoint center = _view.center;
                             center.y += 20;
                             _view.center = center;
                         } 
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.4
                                                   delay:0.0 
                                                 options:UIViewAnimationCurveEaseIn
                                              animations:^{
                                                  CGRect frame = _view.frame;
                                                  frame.origin.y = -frame.size.height;
                                                  _view.frame = frame;
                                                  [[BlockBackground sharedInstance] reduceAlphaIfEmpty];
                                              } 
                                              completion:^(BOOL finished) {
                                                  [[BlockBackground sharedInstance] removeView:_view];
                                                  [_view release]; _view = nil;
                                                  [self autorelease];
                                              }];
                         }];
    }
    else
    {
        [[BlockBackground sharedInstance] removeView:_view];
        [_view release]; _view = nil;
        [self autorelease];
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
