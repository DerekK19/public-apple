//
//  BaseViewController.h
//  GTD
//
//  Created by Derek Knight on 19/09/10.
//  Copyright (c) 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ModelFactory.h"
#import "HTTPPool.h"
#import "XML+SOAPRequest.h"

@interface BaseViewController : UITableViewController <NSFetchedResultsControllerDelegate>  {
    
    UINavigationItem *navigator;
    
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;

    DKXMLSOAPRequest *soap;
	NSMutableData *webData;
	NSMutableString *soapResults;
	NSMutableString *xmlValue;
	NSXMLParser *xmlParser;
	BOOL recordResults;
	BOOL xmlResults;
	BOOL logging;
    bool encrypt;

    ModelFactory *modelFactory;
}

@property (readonly) UINavigationItem *navigator;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) ModelFactory *modelFactory;

- (id)init;
- (void)initFetchedResultsControllerWithEntityName:(NSString *)name
                                        andSortKey:(NSString *)key;
- (void)initFetchedResultsControllerWithEntityName:(NSString *)name
                                        andSortKey:(NSString *)key
                                       andPredicate:(NSPredicate *)predicate;
- (void)callWebServiceWithDelegate:(id)delegate
                         andMethod:(NSString *)method, ...;

- (void)viewDidLoadWithRightButton:(UIBarButtonItem *)rightButton;
- (void)initView:(UINavigationItem *)navItem;
- (void)didAuthenticate;
- (void)setRightBarButtonItem:(UIBarButtonItem *)rightButton;
- (void)showAddViewWithRightButton:(UIBarButtonItem *)rightButton;
- (void)saveWithRightButton:(UIBarButtonItem *)rightButton;
- (NSFetchedResultsController *)fetchedResultsControllerWithEntityName:(NSString *)entityName
                                                            andSortKey:(NSString *)sortKey
                                                          andPredicate:(NSPredicate *)predicate;
- (NSManagedObject *)tableView:(UITableView *)aTableView selectedRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)displayDate:(NSDate *) date;
- (NSString *)displayColour:(UIColor *) color;

@end
