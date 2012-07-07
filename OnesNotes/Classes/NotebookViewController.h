//
//  NotebookViewController.h
//  OnesNotes
//
//  Created by Derek Knight on 24/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BaseViewController.h"

@class DetailViewController;

@interface NotebookViewController : BaseViewController <NSXMLParserDelegate> {
    
    DetailViewController *detailViewController;
    NotebookModel *notebook;
}


@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) NotebookModel *notebook;

- (NotebookViewController *)initWithNotebook:(NotebookModel *)notebook;

- (BOOL)findObjectWithGUID:(NSString *)GUID;

- (void)insertNewObject:(id)sender
               withName:(NSString *)name
                  andID:(NSString *)GUID
                andPath:(NSString *)path
    andLastModifiedTime:(NSDate *)modified
              andColour:(NSString *)colour;

- (void)synchroniseNotebook:(id)sender
                   withGUID:(NSString *) GUID;

@end
