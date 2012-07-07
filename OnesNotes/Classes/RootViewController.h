//
//  RootViewController.h
//  OnesNotes
//
//  Created by Derek Knight on 22/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BaseViewController.h"

@class DetailViewController;

@interface RootViewController : BaseViewController <NSXMLParserDelegate> {

    DetailViewController *detailViewController;
}


@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

- (void)didAuthenticate;

- (BOOL)findObjectWithGUID:(NSString *)GUID;

- (void)insertNewObject:(id)sender
               withName:(NSString *)name
            andNickname:(NSString *)nickname
                  andID:(NSString *)GUID
                andPath:(NSString *)path
    andLastModifiedTime:(NSDate *)modified
              andColour:(NSString *)colour;

- (void)resetSOAP:(id)sender;

- (void)synchroniseNotebooks:(id)sender;

@end
