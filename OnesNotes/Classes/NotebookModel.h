//
//  StuffModel.h
//  GTD
//
//  Created by Derek Knight on 10/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import "BaseModel.h"

@interface NotebookModel : BaseModel {
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * GUID;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) UIColor * colour;
@property (nonatomic, retain) NSSet * sections;

@end
