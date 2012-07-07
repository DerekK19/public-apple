//
//  ElementsAppDelegate.m
//  Elements
//
//  Created by Derek Knight on 26/03/2010.
//  Copyright Home 2010. All rights reserved.
//

#define LOW_LEVEL_DEBUG FALSE

#import "ElementsAppDelegate.h"

@implementation ElementsAppDelegate

@synthesize window;
@synthesize controller;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	// Override point for customization after application launch
	ElementsController *aController = [[ElementsController alloc] 
											   initWithNibName:@"ElementsView" 
											   bundle:[NSBundle mainBundle]];
	self.controller = aController;
	[aController release];
	
	[window addSubview:[controller view]];
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark Delegate for URL redirector

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    DEBUGLog(@"%@", [url absoluteString]);

    NSArray *urlComponents = [[url absoluteString] componentsSeparatedByString:@"?"];
    if ([urlComponents count] > 1)
    {
        NSArray *requestParameterChunks = [[urlComponents objectAtIndex:1] componentsSeparatedByString:@"&"];
        NSString *oauthToken;
        for (NSString *chunk in requestParameterChunks)
        {
            NSArray *keyVal = [chunk componentsSeparatedByString:@"="];
            
            if ([[keyVal objectAtIndex:0] isEqualToString:@"oauth_token"])
            {
                oauthToken = [keyVal objectAtIndex:1];
            }
        }   
        if (nil != oauthToken)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AuthenticationReturned" object:oauthToken];
            return YES;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AuthenticationCancelled" object:nil];
    return YES;
}

@end
