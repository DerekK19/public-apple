//
//  DWMAppDelegate.h
//  WindowManagerSample
//
//  Created by Derek Knight on 29/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWMViewController;

@interface DWMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DWMViewController *viewController;

@end
