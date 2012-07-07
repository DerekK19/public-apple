//
//  ViewFactory.m
//  ProjectTimer
//
//  Created by Derek Knight on 4/06/11.
//  Copyright 2011 ASB. All rights reserved.
//

#define LOW_LEVEL_DEBUG FALSE

#import "ViewFactory.h"

@implementation DGKViewFactory

- (id) initWithNib:(NSString*)nibName
{
    if (self == [super init])
    {
        viewTemplateStore = [[NSMutableDictionary alloc] init];
        NSArray * templates = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        for (id template in templates)
        {
            if ([template isKindOfClass:[UITableViewCell class]])
            {
                UITableViewCell * cellTemplate = (UITableViewCell *)template;
                NSString * key = cellTemplate.reuseIdentifier;
                if (key)
                {
                    [viewTemplateStore setObject:[NSKeyedArchiver
                                                  archivedDataWithRootObject:template]
                                          forKey:key];
                }
                else
                {
                    @throw [NSException exceptionWithName:@"Unknown cell"
                                                   reason:@"Cell has no reuseIdentifier"
                                                 userInfo:nil];
                }
            }
        }
    }    
    return self;
}

- (void) dealloc
{
    [viewTemplateStore release];
    [super dealloc];
}

- (UITableViewCell*)cellOfKind:(NSString*)theCellKind
                      forTable:(UITableView*)aTableView
{
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:theCellKind];
    
    if (!cell)
    {
        NSData * cellData = [viewTemplateStore objectForKey:theCellKind];
        if (cellData)
        {
            cell = [NSKeyedUnarchiver unarchiveObjectWithData:cellData];
        }
        else
        {
            NSLog(@"Don't know nothing about cell of kind %@", theCellKind);
        }
    }    
    return cell;
}

@end
