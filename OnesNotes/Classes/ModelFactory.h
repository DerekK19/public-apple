//
//  ModelFactory.h
//  GTD
//
//  Created by Derek Knight on 14/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NotebookModel.h"
#import "SectionModel.h"
#import "PageModel.h"

@interface ModelFactory : NSObject {

    NSFetchedResultsController *fetchedResultsController;

}

- (ModelFactory *) initFactoryWithFetchedResultsController:(NSFetchedResultsController *)aFetchedResultsController;

- (NotebookModel *) createNotebookWithName:(NSString *)name
                               andNickname:(NSString *)nickname
                                     andID:(NSString *)GUID
                                   andPath:(NSString *)path
                       andLastModifiedTime:(NSDate *)modified
                                 andColour:(NSString *)colour;

- (NotebookModel *) createNotebookForRowAtIndexPath: (NSIndexPath *)indexPath;

- (NotebookModel *) findNotebookWithGUID: (NSString *)GUID;

- (SectionModel *) createSectionWithNotebook:(NotebookModel *)notebook
                                     andName:(NSString *)name
                                       andID:(NSString *)GUID
                                     andPath:(NSString *)path
                         andLastModifiedTime:(NSDate *)modified
                                   andColour:(NSString *)colour;

- (SectionModel *) createSectionForRowAtIndexPath: (NSIndexPath *)indexPath;

- (SectionModel *) findSectionWithGUID: (NSString *)GUID;

- (PageModel *) createPageWithSection:(SectionModel *)section
                              andName:(NSString *)name
                                andID:(NSString *)GUID
                             andLevel:(NSString *)level
                  andLastModifiedTime:(NSDate *)modified
                      andInsertedTime:(NSDate *)inserted;

- (PageModel *) createPageForRowAtIndexPath: (NSIndexPath *)indexPath;

- (PageModel *) findPageWithGUID: (NSString *)GUID;

@end
