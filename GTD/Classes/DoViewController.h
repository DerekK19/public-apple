//
//  DoViewController.h
//  GTD
//
//  Created by Derek Knight on 19/09/10.
//  Copyright (c) 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BaseViewController.h"

@class DoDetailViewController;

@interface DoViewController : BaseViewController {
    
    UIBarButtonItem *newButtonItem;
    UIBarButtonItem *saveButtonItem;

    DoDetailViewController *detailViewController;    
}

@property (readonly) UIBarButtonItem *newButtonItem;
@property (readonly) UIBarButtonItem *saveButtonItem;

@property (nonatomic, retain) IBOutlet DoDetailViewController *detailViewController;

- (void)initView:(UINavigationItem *)navItem;
- (void)initNavButton;
- (void)insertNewObject:(id)sender
            withsubject:(NSString *)subject
         andDateEntered:(NSDate*)dateEntered
             andDateDue:(NSDate*)dateDue;
- (void)showAddToDoView;
- (void)saveToDo;

@end
