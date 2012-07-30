//
//  DWMAppletViewController.h
//  WindowManagerSample
//
//  Created by Derek Knight on 30/07/12.
//
//

#import <UIKit/UIKit.h>
#import "Logging.h"

@interface DWMAppletViewController : UIViewController

/** @brief A web view - which will be handed down to the base web view controller */
@property (nonatomic, retain) IBOutlet UIWebView *webView;

@property CGRect appletFrame;

/**
 @brief Show the standard left-hand navigation button
 
 Revert to showing a standard left-hand navigation button (this button has an arrow appearance)
 */
- (void) showStandardLeftHeaderButton;

/**
 @brief Add a custom left-hand navigation button
 
 Add a custom left-hand navigation button (This button has a square appearance and a black tint)
 
 @param title The text to place on the button
 @param callbackId PhoneGap's callback Id
 */
- (void) addLeftHeaderButton:(NSString *)title
              withCallbackId:(NSString *)callbackId
                     andType:(NSString *)buttonType;

/**
 @brief Add a custom right-hand navigation button
 
 Add a custom right-hand navigation button (This button has a square appearance and a black tint) and can include a badge
 
 @param title The text to place on the button
 @param badgeText The text to place in the badge
 @param badgeColour The colour for the badge
 @param scale The size of the badge
 @param callbackId PhoneGap's callback Id
 */
- (void) addRightHeaderButton:(NSString *)title
                withBadgeText:(NSString *)badgeText
               andBadgeColour:(NSString *)badgeColour
               andScaleFactor:(int)scale
                andCallbackId:(NSString *)callbackId
                      andType:(NSString *)buttonType;

/**
 @brief Remove left button
 
 Remove the left-hand navigation button 
 */
- (void) removeLeftHeaderButton;

/**
 @brief Remove right button
 
 Remove the right-hand navigation button 
 */
- (void) removeRightHeaderButton;

@end
