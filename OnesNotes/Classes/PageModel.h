//
//  SectionModel.h
//  OnesNotes
//
//  Created by Derek Knight on 10/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import "BaseModel.h"
#import "SectionModel.h"

@interface PageModel : BaseModel {
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * GUID;
@property (nonatomic, retain) NSString * level;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) NSDate * inserted;
@property (nonatomic, retain) SectionModel * section;
@property (nonatomic, retain) NSString * sectionGUID;

@end
