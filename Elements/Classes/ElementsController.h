//
//  ElementsController.h
//  Elements
//
//  Created by Derek Knight on 26/03/2010.
//  Copyright 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Logging.h"
#import "XMLSOAPRequest.h"

@interface ElementsController : UIViewController <UITextFieldDelegate, NSXMLParserDelegate, DGKXMLSOAPRequestDelegate> {
	UITextField *elementNumberOrSymbol;
	UILabel *elementName;
	UILabel *atomicNumber;
	UILabel *series;
	UILabel *period;
	UILabel *isotope;
	UILabel *mass;
	UILabel *melt;
	UILabel *boil;
	UILabel *status;
	UIWebView *elementImage;
    UIWebView *claimWebView;
    DGKXMLSOAPRequest *request;
    DGKXMLSOAPRequest *request2;
	NSMutableString *recordValue;
	NSMutableString *xmlValue;
	NSXMLParser *xmlParser;
	BOOL recordResults;
	BOOL xmlResults;
    NSString *claimReason;
    NSString *claimUrl;
}

@property (nonatomic, retain) IBOutlet UITextField *elementNumberOrSymbol;
@property (nonatomic, retain) IBOutlet UILabel *elementName;
@property (nonatomic, retain) IBOutlet UILabel *atomicNumber;
@property (nonatomic, retain) IBOutlet UILabel *series;
@property (nonatomic, retain) IBOutlet UILabel *period;
@property (nonatomic, retain) IBOutlet UILabel *isotope;
@property (nonatomic, retain) IBOutlet UILabel *mass;
@property (nonatomic, retain) IBOutlet UILabel *melt;
@property (nonatomic, retain) IBOutlet UILabel *boil;
@property (nonatomic, retain) IBOutlet UIWebView *elementImage;
@property (nonatomic, retain) IBOutlet UIWebView *claimWebView;
@property (nonatomic, retain) IBOutlet UILabel *status;
@property (nonatomic, retain) NSMutableString *xmlValue;
@property (nonatomic, retain) NSMutableString *recordValue;
@property (nonatomic, retain) NSXMLParser *xmlParser;

- (IBAction)findElement:(id)sender;

@end
