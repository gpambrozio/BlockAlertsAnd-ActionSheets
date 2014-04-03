//
//  BlockAlertView.m
//
//

#import "BlockAlertView.h"
#import "BlockBackground.h"
#import "BlockUI.h"

@implementation BlockAlertView

@synthesize view = _view;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize backgroundImage = _backgroundImage;
@synthesize vignetteBackground = _vignetteBackground;

static UIFont *titleFont = nil;
static UIFont *messageFont = nil;
static UIFont *buttonFont = nil;
static UIFont *cancelFont = nil;

#pragma mark - init

+ (void)initialize
{
    if (self == [BlockAlertView class])
    {
        titleFont = [kAlertViewTitleFont retain];
        messageFont = [kAlertViewMessageFont retain];
        buttonFont = [kAlertViewButtonFont retain];
		cancelFont = [kAlertViewCancelFont retain];
    }
}

+ (BlockAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message
{
    return [[[BlockAlertView alloc] initWithTitle:title message:message] autorelease];
}

+ (void)showInfoAlertWithTitle:(NSString *)title message:(NSString *)message
{
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:title message:message];
    [alert setCancelButtonWithTitle:NSLocalizedString(@"Dismiss", nil) block:nil];
    [alert show];
    [alert release];
}

+ (void)showErrorAlert:(NSError *)error
{
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:NSLocalizedString(@"Operation Failed", nil) message:[NSString stringWithFormat:NSLocalizedString(@"The operation did not complete successfully: %@", nil), error]];
    [alert setCancelButtonWithTitle:@"Dismiss" block:nil];
    [alert show];
    [alert release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (void)addComponents:(CGRect)frame
{
	UILabel *titleView = nil;
	UILabel *messageView = nil;
    if (_title)
    {
        NSDictionary *attributes = @{NSFontAttributeName:titleFont};
        CGSize size = [_title boundingRectWithSize:CGSizeMake(frame.size.width-kAlertViewBorder*2, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
        

        titleView = [[UILabel alloc] initWithFrame:CGRectMake(kAlertViewBorder + kAlertViewTitlePadding,
																	   _height + kAlertViewTitlePadding,
																	   frame.size.width-kAlertViewBorder*2 - kAlertViewTitlePadding*2,
																	   size.height)];
        titleView.font = titleFont;
        titleView.numberOfLines = 0;
        titleView.lineBreakMode = NSLineBreakByWordWrapping;
        titleView.textColor = kAlertViewTitleTextColor;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.shadowColor = kAlertViewTitleShadowColor;
        titleView.shadowOffset = kAlertViewTitleShadowOffset;
        titleView.text = _title;
        
        _height += size.height + kAlertViewBorder + kAlertViewTitlePadding;
    }
    
    if (_message)
    {
        NSDictionary *attributes = @{NSFontAttributeName:messageFont};
        CGSize size = [_message boundingRectWithSize:CGSizeMake(frame.size.width-kAlertViewBorder*2, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
        
        messageView = [[UILabel alloc] initWithFrame:CGRectMake(kAlertViewBorder + kAlertViewMessagePadding,
																	   _height,
																	   frame.size.width-kAlertViewBorder*2 - kAlertViewMessagePadding*2,
																	   size.height)];
        messageView.font = messageFont;
        messageView.numberOfLines = 0;
        messageView.lineBreakMode = NSLineBreakByWordWrapping;
        messageView.textColor = kAlertViewMessageTextColor;
        messageView.backgroundColor = [UIColor clearColor];
        messageView.textAlignment = NSTextAlignmentCenter;
        messageView.shadowColor = kAlertViewMessageShadowColor;
        messageView.shadowOffset = kAlertViewMessageShadowOffset;
        messageView.text = _message;
        
        _height += size.height + kAlertViewBorder + kAlertViewTitlePadding;
    }
	
	UIImage *backgroundImage = [UIImage imageNamed:@"action-button-top.png"];
	backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:7 topCapHeight:7];
		
	UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(kAlertViewBorder,
																				0,
																				frame.size.width-kAlertViewBorder*2,
																				_height)];
	backgroundView.image = backgroundImage;
	[_view addSubview:backgroundView];
    [backgroundView release];
    _backgroundImageView = backgroundView;
	if(titleView){
        [_view addSubview:titleView];
        [titleView release];
	}
	if(messageView){
		[_view addSubview:messageView];
        [messageView release];
	}
}

- (void)setupDisplay
{
    [[_view subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    UIWindow *parentView = [BlockBackground sharedInstance];
    CGRect frame = parentView.bounds;
    frame.origin.x = floorf((frame.size.width - kAlertViewBackgroundWidth) * 0.5);
    frame.size.width = kAlertViewBackgroundWidth;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        frame.size.width += 150;
        frame.origin.x -= 75;
    }
    
    _view.frame = frame;
    
    _height = kAlertViewBorder + 15;
    
    if (NeedsLandscapePhoneTweaks) {
        _height -= 15; // landscape phones need to trimmed a bit
    }

    [self addComponents:frame];

    if (_shown)
        [self show];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message 
{
    self = [super init];
    
    if (self)
    {
        _title = [title copy];
        _message = [message copy];
        
        _view = [[UIView alloc] init];
        
        _view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        _blocks = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(setupDisplay) 
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification 
                                                   object:nil];   
        
        if ([self class] == [BlockAlertView class])
            [self setupDisplay];
        
        _vignetteBackground = NO;
    }
    
    return self;
}

- (void)dealloc 
{
    [_title release];
    [_message release];
    [_backgroundImage release];
    [_view release];
    [_blocks release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)addButtonWithTitle:(NSString *)title buttonType:(BlockButtonType)type block:(void (^)())block
{
	NSValue *typeVal = [NSValue valueWithBytes:&type objCType:@encode(BlockButtonType)];
	if(type == kBlockButtonCancel){
		[_blocks addObject:[NSArray arrayWithObjects:
							   block ? [[block copy] autorelease] : [NSNull null],
							   title,
							   typeVal,
							   nil]];
	}else {
		[_blocks insertObject:[NSArray arrayWithObjects:
							   block ? [[block copy] autorelease] : [NSNull null],
							   title,
							   typeVal,
							   nil]
					  atIndex:_blocks.count==0 ? 0 : _blocks.count - 1];
	}
}

- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block 
{
    [self addButtonWithTitle:title buttonType:kBlockButtonDefault block:block];
}

- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block 
{
    [self addButtonWithTitle:title buttonType:kBlockButtonCancel block:block];
}

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)())block
{
    [self addButtonWithTitle:title buttonType:kBlockButtonDestroy block:block];
}


- (void)show
{
    _shown = YES;
    
//    BOOL isSecondButton = NO;
    NSUInteger index = 0;
    for (NSUInteger i = 0; i < _blocks.count; i++)
    {
        //This adds the little one pixel horizontal border between the buttons
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kAlertViewBorder, _height, _view.bounds.size.width-kAlertViewBorder*2, 1)];
        lineView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:lineView];
        _height += 1;
        
        NSArray *block = [_blocks objectAtIndex:i];
        NSString *title = [block objectAtIndex:1];
        BlockButtonType buttonType;
		[[block objectAtIndex:2] getValue:&buttonType];
		
		UIImage *image;
		if(i == _blocks.count-1){
			image = [UIImage imageNamed:@"action-button-bottom.png"];
			image = [image stretchableImageWithLeftCapWidth:7 topCapHeight:7];
		}else {
			image = [UIImage imageNamed:@"action-button-mid.png"];
			image = [image stretchableImageWithLeftCapWidth:7 topCapHeight:7];
		}
        
        CGFloat width = _view.bounds.size.width-kAlertViewBorder*2;
        CGFloat xOffset = kAlertViewBorder;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(xOffset, _height, width, kAlertButtonHeight);
		if(buttonType == kBlockButtonCancel){
			button.titleLabel.font = cancelFont;
		}else {
			button.titleLabel.font = buttonFont;
		}
        if (IOS_LESS_THAN_6) {
#pragma clan diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            button.titleLabel.minimumFontSize = 10;
#pragma clan diagnostic pop
        }
        else {
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleLabel.adjustsLetterSpacingToFitWidth = YES;
            button.titleLabel.minimumScaleFactor = 0.1;
        }
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.shadowOffset = kAlertViewButtonShadowOffset;
        button.backgroundColor = [UIColor clearColor];
        button.tag = i+1;
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
		if(buttonType == kBlockButtonDestroy){
			[button setTitleColor:KAlertViewDestructColor forState:UIControlStateNormal];
		}else {
			[button setTitleColor:kAlertViewButtonTextColor forState:UIControlStateNormal];
		}
        [button setTitleShadowColor:kAlertViewButtonShadowColor forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.accessibilityLabel = title;
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_view addSubview:button];

		_height += kAlertButtonHeight;
        
        index++;
    }
    
    // NOTE: ABH - I took this out.  It was adding extra space between the bottom of the white box
    // and the button.  I have no idea what the intention of this code was, besides agrovated.
    
//    if (_height < kAlertViewBackgroundWidth)
//    {
//        CGFloat offset = kAlertViewBackgroundWidth - _height;
//        _height = kAlertViewBackgroundWidth;
//        NSLog(@"show: _height < kAlertViewBackgroundWidth %0.2f", _height);
//        CGRect frame;
//        for (NSUInteger i = 0; i < _blocks.count; i++)
//        {
//            UIButton *btn = (UIButton *)[_view viewWithTag:i+1];
//            frame = btn.frame;
//            frame.origin.y += offset;
//            btn.frame = frame;
//        }
//    }
    
    
    CGRect frame = _view.frame;
    frame.origin.y = - _height;
    frame.size.height = _height;
    _view.frame = frame;
    
    UIImageView *modalBackground = [[UIImageView alloc] initWithFrame:_view.bounds];

    modalBackground.contentMode = UIViewContentModeScaleToFill;
    modalBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
    
    _cancelBounce = NO;
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [BlockBackground sharedInstance].alpha = 1.0f;
                         _view.center = center;
                     } 
                     completion:^(BOOL finished) {
                         if (_cancelBounce) return;
                         
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:0
                                          animations:^{
                                              center.y -= kAlertViewBounce;
                                              _view.center = center;
                                          } 
                                          completion:^(BOOL finished) {
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertViewFinishedAnimations" object:self];
                                          }];
                     }];
    
    [self retain];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated 
{
    _shown = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
                             CGPoint center = _view.center;
                             center.y += 20;
                             _view.center = center;
                         } 
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.25
                                                   delay:0.0 
                                                 options:UIViewAnimationOptionCurveEaseIn
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
    int buttonIndex = [(UIButton *)sender tag] - 1;
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

@end
