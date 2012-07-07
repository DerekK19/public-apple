//
//  SectionViewController.h
//  OnesNotes
//
//  Created by Derek Knight on 24/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BaseViewController.h"

@class DetailViewController;

@interface SectionViewController : BaseViewController <NSXMLParserDelegate> {
    
    DetailViewController *detailViewController;
    SectionModel *section;
}


@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) SectionModel *section;

- (SectionViewController *)initWithSection:(SectionModel *)section;

- (BOOL)findObjectWithGUID:(NSString *)GUID;

- (void)insertNewObject:(id)sender
               withName:(NSString *)name
                  andID:(NSString *)GUID
               andLevel:(NSString *)level
    andLastModifiedTime:(NSDate *)modified
        andInsertedTime:(NSDate *)inserted;

- (void)synchroniseSection:(id)sender
                  withGUID:(NSString *) GUID;
- (IBAction)listTemplates;

@end
