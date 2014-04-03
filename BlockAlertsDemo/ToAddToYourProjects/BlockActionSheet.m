//
//  BlockActionSheet.m
//
//

#import "BlockActionSheet.h"
#import "BlockBackground.h"
#import "BlockUI.h"

@implementation BlockActionSheet

@synthesize view = _view;
@synthesize vignetteBackground = _vignetteBackground;

//static UIImage *background = nil;
static UIFont *titleFont = nil;
static UIFont *buttonFont = nil;
static UIFont *cancelFont = nil;

#pragma mark - init

+ (void)initialize
{
    if (self == [BlockActionSheet class])
    {
        titleFont = [kActionSheetTitleFont retain];
        buttonFont = [kActionSheetButtonFont retain];
		cancelFont = [kActionSheetCancelFont retain];
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
        _height = kActionSheetTopMargin;

        if (title)
        {
			_hasTitle = YES;
            NSDictionary *attributes = @{NSFontAttributeName:titleFont};
            CGSize size = [title boundingRectWithSize:CGSizeMake(frame.size.width-kActionSheetBorderSides*2, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
            UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(kActionSheetBorderSides + kActionSheetTitlePadding,
																		   _height + kActionSheetTitlePadding,
																		   frame.size.width-kActionSheetBorderSides*2-kActionSheetTitlePadding*2,
																		   size.height)];

			UIImage *backgroundImage = [UIImage imageNamed:@"action-button-top.png"];
            labelView.font = titleFont;
            labelView.numberOfLines = 0;
            labelView.lineBreakMode = NSLineBreakByWordWrapping;
            labelView.textColor = kActionSheetTitleTextColor;
            labelView.backgroundColor = [UIColor clearColor];
            labelView.textAlignment = NSTextAlignmentCenter;
            labelView.shadowColor = kActionSheetTitleShadowColor;
            labelView.shadowOffset = kActionSheetTitleShadowOffset;
            labelView.text = title;
            
            labelView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			
			UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(labelView.frame.origin.x-kActionSheetTitlePadding,
																						_height,
																						labelView.frame.size.width+kActionSheetTitlePadding*2,
																						labelView.frame.size.height + kActionSheetTitlePadding*2)];
			backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:(int)(backgroundImage.size.width)>>1 topCapHeight:0];
			[backgroundView setImage:backgroundImage];
			[_view addSubview:backgroundView];
			[_view addSubview:labelView];
			
            [labelView release];
			[backgroundView release];
            
            _height += size.height + kActionSheetTitlePadding*2 + 1;
        }
        _vignetteBackground = NO;
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

- (void)addButtonWithTitle:(NSString *)title buttonType:(BlockButtonType)type block:(void (^)())block atIndex:(NSInteger)index
{
	NSValue *typeVal = [NSValue valueWithBytes:&type objCType:@encode(BlockButtonType)];
	if(type == kBlockButtonCancel){
		_hasCancel = YES;
		[_blocks addObject:[NSArray arrayWithObjects:
                               block ? [[block copy] autorelease] : [NSNull null],
                               title,
                               typeVal,
							   nil]];
	} else if (index >= 0)
    {
		if(index == _blocks.count - 1){
			index--;
		}
        [_blocks insertObject:[NSArray arrayWithObjects:
                               block ? [[block copy] autorelease] : [NSNull null],
                               title,
                               typeVal,
                               nil]
                      atIndex:index];
    }
    else
    {
        [_blocks insertObject:[NSArray arrayWithObjects:
                            block ? [[block copy] autorelease] : [NSNull null],
                            title,
                            typeVal,
                            nil]
							atIndex:_blocks.count - 1];
    }
}

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)())block
{
    [self addButtonWithTitle:title buttonType:kBlockButtonDestroy block:block atIndex:-1];
}

- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block
{
    [self addButtonWithTitle:title buttonType:kBlockButtonCancel block:block atIndex:-1];
}

- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block 
{
    [self addButtonWithTitle:title buttonType:kBlockButtonDefault block:block atIndex:-1];
}

- (void)setDestructiveButtonWithTitle:(NSString *)title atIndex:(NSInteger)index block:(void (^)())block
{
    [self addButtonWithTitle:title buttonType:kBlockButtonDestroy block:block atIndex:index];
}

- (void)setCancelButtonWithTitle:(NSString *)title atIndex:(NSInteger)index block:(void (^)())block
{
    [self addButtonWithTitle:title buttonType:kBlockButtonCancel block:block atIndex:index];
}

- (void)addButtonWithTitle:(NSString *)title atIndex:(NSInteger)index block:(void (^)())block 
{
    [self addButtonWithTitle:title buttonType:kBlockButtonDefault block:block atIndex:index];
}

- (void)showInView:(UIView *)view
{
    NSUInteger i = 1;
	BOOL topIsUsed = _hasTitle;
    for (NSArray *block in _blocks)
    {
        NSString *title = [block objectAtIndex:1];
        BlockButtonType buttonType;
		[[block objectAtIndex:2] getValue:&buttonType];

		UIImage *image;
		if(buttonType == kBlockButtonCancel) {
			image = [UIImage imageNamed:@"action-button.png"];
			image = [image stretchableImageWithLeftCapWidth:7 topCapHeight:7];
		}else if(i == _blocks.count-1){
			image = [UIImage imageNamed:@"action-button-bottom.png"];
			image = [image stretchableImageWithLeftCapWidth:7 topCapHeight:7];
		}else if(topIsUsed){
			image = [UIImage imageNamed:@"action-button-mid.png"];
			image = [image stretchableImageWithLeftCapWidth:2 topCapHeight:0];
		}else {
			image = [UIImage imageNamed:@"action-button-top.png"];
			image = [image stretchableImageWithLeftCapWidth:(int)(image.size.width)>>1 topCapHeight:0];
			topIsUsed = YES;
		}
			image = [image stretchableImageWithLeftCapWidth:7 topCapHeight:7];
        
//        UIImage *highlightedImage = [UIImage imageNamed:[NSString stringWithFormat:@"action-%@-button-highlighted.png", color]];
		
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kActionSheetBorderSides, _height, _view.bounds.size.width-kActionSheetBorderSides*2, kActionSheetButtonHeight);
		if(buttonType == kBlockButtonCancel){
			_height += kActionSheetCancelMargin;
			button.frame = CGRectMake(kActionSheetBorderSides, _height, _view.bounds.size.width-kActionSheetBorderSides*2, kActionSheetButtonHeight);
			_height += kActionSheetCancelMargin;
			button.titleLabel.font = cancelFont;
		} else {
			button.titleLabel.font = buttonFont;
		}
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
        button.titleLabel.shadowOffset = kActionSheetButtonShadowOffset;
        button.backgroundColor = [UIColor clearColor];
        button.tag = i++;
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
		
		if(buttonType == kBlockButtonDestroy){
			[button setTitleColor:kActionSheetButtonDestructColor forState:UIControlStateNormal];
		}else {
			[button setTitleColor:kActionSheetButtonTextColor forState:UIControlStateNormal];
		}
        [button setTitleShadowColor:kActionSheetButtonShadowColor forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.accessibilityLabel = title;
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [_view addSubview:button];
        _height += kActionSheetButtonHeight + kActionSheetBorderTop;
    }
    
    [BlockBackground sharedInstance].vignetteBackground = _vignetteBackground;
    [[BlockBackground sharedInstance] addToMainWindow:_view];
    CGRect frame = _view.frame;
    frame.origin.y = [BlockBackground sharedInstance].bounds.size.height;
    frame.size.height = _height + kActionSheetBounce;
    _view.frame = frame;
    
    __block CGPoint center = _view.center;
    center.y -= _height + kActionSheetBounce;
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [BlockBackground sharedInstance].alpha = 1.0f;
                         _view.center = center;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              center.y += kActionSheetBounce;
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
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
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
    int buttonIndex = [(UIButton *)sender tag] - 1;
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

@end
