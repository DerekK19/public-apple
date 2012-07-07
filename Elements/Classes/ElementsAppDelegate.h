//
//  ElementsAppDelegate.h
//  Elements
//
//  Created by Derek Knight on 26/03/2010.
//  Copyright Home 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Logging.h"
#import "ElementsController.h"

@class ElementsController;

@interface ElementsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	ElementsController *controller;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) ElementsController *controller;

@end

