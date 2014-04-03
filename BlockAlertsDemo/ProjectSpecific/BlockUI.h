//
//  BlockUI.h
//
//  Created by Gustavo Ambrozio on 14/2/12.
//

#ifndef BlockUI_h
#define BlockUI_h

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
#define NSTextAlignmentCenter       UITextAlignmentCenter
#define NSLineBreakByWordWrapping   UILineBreakModeWordWrap
#define NSLineBreakByClipping       UILineBreakModeClip

#endif

#ifndef IOS_LESS_THAN_6
#define IOS_LESS_THAN_6 !([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending)

#endif

#define NeedsLandscapePhoneTweaks (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) && UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)


// Action Sheet constants

#define kActionSheetBounce          10
#define kActionSheetBorderSides		10
#define kActionSheetBorderTop		1
#define kActionSheetButtonHeight	45
#define kActionSheetTopMargin		15
#define kActionSheetTitlePadding	15
#define kActionSheetCancelMargin	6

#define kActionSheetTitleFont           [UIFont systemFontOfSize:16]
#define kActionSheetTitleTextColor      [UIColor grayColor]
#define kActionSheetTitleShadowColor    [UIColor clearColor]
#define kActionSheetTitleShadowOffset   CGSizeMake(0, 0)

#define kActionSheetButtonFont          [UIFont systemFontOfSize:20]
#define kActionSheetCancelFont			[UIFont boldSystemFontOfSize:20]
#define kActionSheetButtonTextColor     [UIColor colorWithRed:19/255.0 green:144/255.0 blue:255/255.0 alpha:1.0]
#define kActionSheetButtonDestructColor	[UIColor redColor]
#define kActionSheetButtonShadowColor   [UIColor clearColor]
#define kActionSheetButtonShadowOffset  CGSizeMake(0, 0)


// Alert View constants

#define kAlertViewBounce         10
#define kAlertViewBorder         (NeedsLandscapePhoneTweaks ? 5 : 10)
#define kAlertButtonHeight       (NeedsLandscapePhoneTweaks ? 35 : 44)


#define kAlertViewTitleFont             [UIFont boldSystemFontOfSize:20]
#define kAlertViewTitleTextColor        [UIColor blackColor];
#define kAlertViewTitleShadowColor      [UIColor clearColor]
#define kAlertViewTitleShadowOffset     CGSizeMake(0, 0)
#define kAlertViewTitlePadding			5

#define kAlertViewMessageFont           [UIFont systemFontOfSize:14]
#define kAlertViewMessageTextColor      [UIColor blackColor]
#define kAlertViewMessageShadowColor    [UIColor clearColor]
#define kAlertViewMessageShadowOffset   CGSizeMake(0, 0)
#define kAlertViewMessagePadding        10

#define kAlertViewCancelFont            [UIFont boldSystemFontOfSize:18]
#define kAlertViewButtonFont            [UIFont systemFontOfSize:18]
#define kAlertViewButtonTextColor       [UIColor colorWithRed:19/255.0 green:144/255.0 blue:255/255.0 alpha:1.0]
#define KAlertViewDestructColor			[UIColor redColor]
#define kAlertViewButtonShadowColor     [UIColor clearColor]
#define kAlertViewButtonShadowOffset    CGSizeMake(0, 0)


#define kAlertViewBackgroundWidth		280
#define kAlertViewBackground            @""
#define kAlertViewBackgroundLandscape   @""
#define kAlertViewBackgroundCapHeight   38


typedef enum {
	kBlockButtonDefault,
	kBlockButtonCancel,
	kBlockButtonDestroy
} BlockButtonType;

#endif
