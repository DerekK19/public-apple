//
//  StuffDetailViewController.h
//  GTD
//
//  Created by Derek Knight on 19/09/10.
//  Copyright (c) 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "BaseDetailViewController.h"

@class DoViewController;

@interface DoDetailViewController : BaseDetailViewController {    

    UITextField *subject;
    UITextField *entered;
    UITextField *due;
    
    DoViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UITextField *subject;
@property (nonatomic, retain) IBOutlet UITextField *entered;
@property (nonatomic, retain) IBOutlet UITextField *due;

@property (nonatomic, assign) IBOutlet DoViewController *rootViewController;

- (DoDetailViewController *) initWithController:(DoViewController *)root;
- (IBAction)insertNewObject:(id)sender;
- (void)refreshUIForCreate;
- (void)refreshUIForRead;

@end
