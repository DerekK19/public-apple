//
//  BaseDetailViewController.h
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

@interface BaseDetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {    
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    UIBarButtonItem *synchronise;
    UIBarButtonItem *insert;
    
    DKHTTPPool *pool;
    
    DKXMLSOAPRequest *soap;
	NSMutableData *webData;
	NSMutableString *soapResults;
	NSMutableString *xmlValue;
	NSXMLParser *xmlParser;
	BOOL recordResults;
	BOOL xmlResults;
	BOOL logging;
    BOOL encrypt;
    
    NSManagedObject *detailItem;

}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *synchronise;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *insert;

@property (nonatomic, retain) NSManagedObject *detailItem;

- (id)init;

-(void)callWebServiceWithDelegate:(id)delegate
                        andMethod:(NSString *)method, ...;

- (void)refreshUIForCreate;
- (void)refreshUIForRead;

- (NSString *)displayDate:(NSDate *) date;
- (NSString *)displayColour:(UIColor *) color;

@end
