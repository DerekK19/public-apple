//
//  SectionModel.h
//  OnesNotes
//
//  Created by Derek Knight on 10/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import "BaseModel.h"
#import "NotebookModel.h"

@interface SectionModel : BaseModel {
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * GUID;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) UIColor * colour;
@property (nonatomic, retain) NotebookModel * notebook;
@property (nonatomic, retain) NSString * notebookGUID;
@property (nonatomic, retain) NSSet * pages;

@end
