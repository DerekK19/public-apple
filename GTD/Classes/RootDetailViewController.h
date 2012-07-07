//
//  DetailViewController.h
//  GTD
//
//  Created by Derek Knight on 19/09/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class RootViewController;

@interface RootDetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    
    NSManagedObject *detailItem;
    UITextField *subject;

    RootViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) NSManagedObject *detailItem;
@property (nonatomic, retain) IBOutlet UITextField *subject;

@property (nonatomic, assign) IBOutlet RootViewController *rootViewController;

- (IBAction)insertNewObject:(id)sender;

@end
