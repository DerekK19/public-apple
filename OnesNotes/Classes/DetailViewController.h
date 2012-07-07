//
//  DetailViewController.h
//  OnesNotes
//
//  Created by Derek Knight on 22/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "BaseDetailViewController.h"

@class RootViewController;
@class SectionViewController;

@interface DetailViewController : BaseDetailViewController <NSXMLParserDelegate> {
    
    NSString *pageResult;
    
    UITextField *nameText;
    UITextField *nicknameText;
    UITextField *GUIDText;
    UITextField *pathText;
    UITextField *modifiedText;
    UITextField *colourText;
    UIWebView *webArea;
    UILabel *status;
    
    RootViewController *rootViewController;
    SectionViewController *sectionViewController;
}

@property (nonatomic, retain) IBOutlet UITextField *nameText;
@property (nonatomic, retain) IBOutlet UITextField *nicknameText;
@property (nonatomic, retain) IBOutlet UITextField *GUIDText;
@property (nonatomic, retain) IBOutlet UITextField *pathText;
@property (nonatomic, retain) IBOutlet UITextField *modifiedText;
@property (nonatomic, retain) IBOutlet UITextField *colourText;
@property (nonatomic, retain) IBOutlet UIWebView *webArea;
@property (nonatomic, retain) IBOutlet UILabel *status;

@property (nonatomic, assign) IBOutlet RootViewController *rootViewController;
@property (nonatomic, assign) IBOutlet SectionViewController *sectionViewController;


- (DetailViewController *) initWithSectionController:(SectionViewController *)view;
- (IBAction)synchroniseNotebooks:(id)sender;
- (IBAction)insertNewPage:(id)sender;

- (void)refreshUIForRead;
-(void)GetPage:(id)sender
      withGUID:(NSString *) GUID;
- (void)RenderPageWithUrl: (NSURL *)url;


@end
