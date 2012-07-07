//
//  ViewFactory.h
//  ProjectTimer
//
//  Created by Derek Knight on 4/06/11.
//  Copyright 2011 ASB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Logging.h"

@interface DGKViewFactory : NSObject
{
    NSMutableDictionary * viewTemplateStore;
}

- (id) initWithNib: (NSString*)aNibName;

- (UITableViewCell*)cellOfKind: (NSString*)theCellKind forTable: (UITableView*)aTableView;

@end
