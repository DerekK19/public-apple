//
//  BaseModel.m
//  OnesNotes
//
//  Created by Derek Knight on 29/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

@dynamic fetchedResultsController;

@dynamic timeStamp;

- (void)initWithFetchedResultsController: (NSFetchedResultsController*) aFetchedResultsController {
    fetchedResultsController = aFetchedResultsController;
}

- (void)delete {
    
    NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
    [context deleteObject:self];
    
    NSError *error;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (UIColor *) colourWithHexString: (NSString *) stringToConvert  
{  
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];  
    
    // String should be 6 or 8 characters  
    if ([cString length] < 6) return [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];  
    
    // strip 0X if it appears  
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];  
    // strip # if it appears  
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];  
    
    if ([cString length] != 6) return [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];  
    
    // Separate into r, g, b substrings  
    NSRange range;  
    range.location = 0;  
    range.length = 2;  
    NSString *rString = [cString substringWithRange:range];  
    
    range.location = 2;  
    NSString *gString = [cString substringWithRange:range];  
    
    range.location = 4;  
    NSString *bString = [cString substringWithRange:range];  
    
    // Scan values  
    unsigned int r, g, b;  
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  
    [[NSScanner scannerWithString:gString] scanHexInt:&g];  
    [[NSScanner scannerWithString:bString] scanHexInt:&b];  
    
    return [UIColor colorWithRed:((float) r / 255.0f)  
                           green:((float) g / 255.0f)  
                            blue:((float) b / 255.0f)  
                           alpha:1.0f];  
}

- (NSString *) hexStringWithColour  : (UIColor *) color
{  
    
    if (color == nil) return [NSString stringWithFormat:@"%02X%02X%02X", 0, 0, 0];

    const CGFloat *c = CGColorGetComponents(color.CGColor);  

    CGFloat r, g, b;  
    r = c[0];  
    g = c[1];  
    b = c[2];  
    
    // Fix range if needed  
    if (r < 0.0f) r = 0.0f;  
    if (g < 0.0f) g = 0.0f;  
    if (b < 0.0f) b = 0.0f;  
    
    if (r > 1.0f) r = 1.0f;  
    if (g > 1.0f) g = 1.0f;  
    if (b > 1.0f) b = 1.0f;  
    
    // Convert to hex string between 0x00 and 0xFF  
    return [NSString stringWithFormat:@"%02X%02X%02X",  
            (int)(r * 255), (int)(g * 255), (int)(b * 255)];  
}

@end
