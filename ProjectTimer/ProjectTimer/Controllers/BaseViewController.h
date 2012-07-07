//
//  BaseViewController.h
//  GTD
//
//  Created by Derek Knight on 19/09/10.
//  Copyright (c) 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Logging.h"
#import "General.h"
#import <CoreData/CoreData.h>
#import "ViewFactory.h"

@interface DGKBaseViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
{
    UITableView *tableView;
    
    NSFetchedResultsController *fetchedResultsController;
    
    DGKViewFactory *viewFactory;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) DGKViewFactory *viewFactory;

- (id)initWithFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController;
- (void)initViewFactoryWithNib:(NSString *)nibName;

- (void)didAuthenticate;

- (UITableViewCell *)tableView:(UITableView *)aTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
            withCellIdentifier:(NSString *)cellIdentifier;
- (NSManagedObject *)tableView:(UITableView *)aTableView selectedRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)displayDate:(NSDate *) date;
- (NSString *)displayColour:(UIColor *) color;

@end
