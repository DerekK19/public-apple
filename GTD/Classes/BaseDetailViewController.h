//
//  BaseDetailViewController.h
//  GTD
//
//  Created by Derek Knight on 19/09/10.
//  Copyright (c) 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface BaseDetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {    
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    
    NSManagedObject *detailItem;
    
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) NSManagedObject *detailItem;

- (void)refreshUIForCreate;
- (void)refreshUIForRead;

- (NSString *)displayDate:(NSDate *) date;

@end
