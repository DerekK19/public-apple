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

@class StuffViewController;

@interface StuffDetailViewController : BaseDetailViewController {    
    
    UITextField *subject;
    UITextField *entered;
    
    StuffViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UITextField *subject;
@property (nonatomic, retain) IBOutlet UITextField *entered;

@property (nonatomic, assign) IBOutlet StuffViewController *rootViewController;

- (StuffDetailViewController *) initWithController:(StuffViewController *)root;
- (IBAction)insertNewObject:(id)sender;
- (void)refreshUIForCreate;
- (void)refreshUIForRead;

@end
