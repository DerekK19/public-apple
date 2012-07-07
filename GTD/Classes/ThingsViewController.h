//
//  ThingsViewController.h
//  GTD
//
//  Created by Derek Knight on 19/09/10.
//  Copyright (c) 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoViewController.h"
#import "StuffViewController.h"
#import "StuffDetailViewController.h"

@interface ThingsViewController : UIViewController <UITabBarControllerDelegate, UIAccelerometerDelegate> {
    IBOutlet UITabBarController *tabBarController;
    IBOutlet StuffViewController *stuffViewController;
    IBOutlet StuffDetailViewController *stuffDetailViewController;
    IBOutlet DoViewController *doViewController;
    IBOutlet DoDetailViewController *doDetailViewController;
    
    NSManagedObjectContext *managedObjectContext;
    
}

@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) StuffViewController *stuffViewController;
@property (nonatomic, retain) StuffDetailViewController *stuffDetailViewController;
@property (nonatomic, retain) DoViewController *doViewController;
@property (nonatomic, retain) DoDetailViewController *doDetailViewController;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@end
