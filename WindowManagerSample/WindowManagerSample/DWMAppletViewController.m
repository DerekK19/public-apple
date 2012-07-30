//
//  DWMAppletViewController.m
//  WindowManagerSample
//
//  Created by Derek Knight on 30/07/12.
//
//

#define LOW_LEVEL_DEBUG TRUE

#define kButtonBarItemHeight 30.0

#import "DWMAppletViewController.h"
#import "DWMUtility.h"

@interface DWMAppletViewController ()

@property (nonatomic, retain) UIView *topBar;
@property (nonatomic, retain) UIView *topBarLeft;
@property (nonatomic, retain) UIView *topBarRight;
@property (nonatomic, retain) UIButton *leftButton;
@property (nonatomic, retain) UIButton *rightButton;
@property (nonatomic, retain) UIView *webBackground;

- (UIButton *) getButtonFromTitle:(NSString *)title
                        andAction:(SEL)action
                          andType:(NSString *)buttonType;
- (IBAction)leftButtonSelect:(id)sender;
- (IBAction)rightButtonSelect:(id)sender;

@end

@implementation DWMAppletViewController

@synthesize webView = _webView;
@synthesize appletFrame = _appletFrame;
@synthesize topBar = _topBar;
@synthesize topBarLeft = _topBarLeft;
@synthesize topBarRight = _topBarRight;
@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;
@synthesize webBackground = _webBackground;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    DEBUGLog (@"%d,%d %dx%d",
              (int)_appletFrame.origin.x,
              (int)_appletFrame.origin.y,
              (int)_appletFrame.size.width,
              (int)_appletFrame.size.height);
    
    /*
     The process here is:
     Add a background view, which is going to be the entire screen
     Set the colour of this to be the application's background colour
     Add a frame for our applet. This is a 4 pixel border each side of the applet's frame
     Set the colour of this to be black
     Add a background image, which will be the size of the applet's window, so offset 4 pixels from the frame
     Set the colour of this to be the web background (carbon fibre)
     Add a web view, the same size as the web background
     Set the colour of this to be transparent, so the carbon shows through
     */
    
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    UIView *frameView = [[UIView alloc]initWithFrame:CGRectMake(_appletFrame.origin.x-4,
                                                                _appletFrame.origin.y-48,
                                                                _appletFrame.size.width+8,
                                                                _appletFrame.size.height+54)];
    frameView.backgroundColor = [UIColor blackColor];
    _webBackground = [[UIView alloc]initWithFrame:CGRectMake(4,
                                                             50,
                                                             _appletFrame.size.width,
                                                             _appletFrame.size.height)];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"carbon-fiber-bg"]];
    [_webBackground setBackgroundColor:background];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,
                                                          0,
                                                          _appletFrame.size.width,
                                                          _appletFrame.size.height)];
    _webView.backgroundColor = [UIColor clearColor];
    
    _topBar = [[UIView alloc]initWithFrame:CGRectMake(4.0,
                                                      4.0,
                                                      _appletFrame.size.width,
                                                      44.0)];
//    _topBar.backgroundColor = [UIColor blueColor];
    UIImage *image = [[UIImage imageNamed:@"blank_header_44"] stretchableImageWithLeftCapWidth:4.0 topCapHeight:0];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0.0,
                                 0.0,
                                 _appletFrame.size.width,
                                 44.0);
    [_topBar addSubview:imageView];

    _topBarLeft = [[UIView alloc]initWithFrame:CGRectMake(4.0,
                                                          7.0,
                                                          80,
                                                          44.0)];
    [_topBar addSubview:_topBarLeft];
    _topBarRight = [[UIView alloc]initWithFrame:CGRectMake(_appletFrame.size.width-80,
                                                           7.0,
                                                           80.0,
                                                           44.0)];
    [_topBar addSubview:_topBarRight];
    if (_leftButton) [_topBarLeft addSubview:_leftButton];
    if (_rightButton) [_topBarRight addSubview:_rightButton];


//    _leftButton = [self getButtonFromTitle:@"Yo" andAction:@selector(leftButtonSelect:) andType:nil];
//    [_topBar addSubview:_leftButton];
//
//    UIButton *dismiss=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    dismiss.frame= CGRectMake(10.0, 4.0, 72.0, 37.0);
//    [dismiss setTitle:@"Bye" forState:UIControlStateNormal];
//    [dismiss addTarget:self action:@selector(dismissPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [backgroundView addSubview:frameView];
    [frameView addSubview:_topBar];
    [frameView addSubview:_webBackground];
    [_webBackground addSubview:_webView];
    [self setView:backgroundView];
    
//    if (startPage != nil)
//    {
//        DEBUGLog(@"Start %@ at '%@'", _webView, startPage);
//        viewController = [[BaseWebViewController alloc] initWithNibName:nil
//                                                                 bundle:nil
//                                               withNavigationController:self.navigationController
//                                                      andNavigationItem:self.navigationItem];
//        viewController.webView = webView;
//        webView.delegate = viewController;
//        viewController.title = self.title;
//        [viewController setStartPage:startPage];
//        [viewController setThePageData:startJson];
//        [viewController view];
//    }
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view.
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // read from UISupportedInterfaceOrientations (or UISupportedInterfaceOrientations~iPad, if its iPad) from -Info.plist
    NSArray *supportedOrientations = [DWMUtility parseInterfaceOrientations: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISupportedInterfaceOrientations"]];
	BOOL autoRotate = [supportedOrientations count] > 0; // autorotate if only more than 1 orientation supported
	if (autoRotate)
	{
		if ([supportedOrientations containsObject:
			 [NSNumber numberWithInt:interfaceOrientation]]) {
			return YES;
		}
    }
	return NO;
}

#pragma mark - Control event handers

- (IBAction)leftButtonSelect:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)rightButtonSelect:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Modal dialog behaviour

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
    [self presentViewController:modalViewController
                       animated:animated
                     completion:nil];
}


- (void) dismissModalViewControllerAnimated:(BOOL)animated
{
    [self dismissViewControllerAnimated:animated
                             completion:nil];
}

- (void) presentViewController:(UIViewController *)viewControllerToPresent
                      animated:(BOOL)flag
                    completion:(void (^)(void))completion
{
    [super presentViewController:viewControllerToPresent
                        animated:flag
                      completion:completion];
}

- (void) dismissViewControllerAnimated:(BOOL)flag
                            completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
}

#pragma mark - Added header button behaviour

- (UIButton *) getButtonFromTitle:(NSString *)title
                        andAction:(SEL)action
                          andType:(NSString *)buttonType
{
    UIButton *button;
    BOOL isCustomDrawButton = buttonType && [buttonType length] > 0;
    BOOL isCallToActionButton = isCustomDrawButton && [buttonType isEqualToString:@"CallToAction"];
    BOOL isCallToActionButtonWithArrow = isCustomDrawButton && [buttonType isEqualToString:@"CallToActionWithArrow"];
    BOOL isStandardButton = isCustomDrawButton && [buttonType isEqualToString:@"Standard"];
    BOOL isStandardButtonWithArrow = isCustomDrawButton && [buttonType isEqualToString:@"StandardWithArrow"];
    
    // Text width
    UIFont *buttonFont = [UIFont boldSystemFontOfSize:12.0];
    float titleTextWidth = [title sizeWithFont:buttonFont].width;

    // Image type has title that starts with "@"
    if ([title hasPrefix:@"@"])
    {
        UIImage *image = [UIImage imageNamed:[title substringFromIndex:1]];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [button setAccessibilityLabel:[title stringByReplacingOccurrencesOfString:@"@button_" withString:@""]];
        [button setAccessibilityHint:@"button"];
        [button setIsAccessibilityElement:YES];
    }
    // Custom draw button
    else if (isCustomDrawButton && (isCallToActionButton ||
                                    isCallToActionButtonWithArrow ||
                                    isStandardButton ||
                                    isStandardButtonWithArrow))
    {
        button =[UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.font = buttonFont;
        label.textAlignment = UITextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        if (isStandardButton || isStandardButtonWithArrow)
            label.textColor = [UIColor whiteColor];
        else
            label.shadowColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:0.9];
        label.shadowOffset = CGSizeMake(0.0, 1.0);
        
        UIImage *image;
        if (isCallToActionButtonWithArrow) {
            // 10.0px left and 12px right padding hence 22.0 + titleTextWidth
            button.frame = CGRectMake(0.0, 0.0, 22.0 + titleTextWidth, kButtonBarItemHeight);
            label.frame = CGRectMake(button.frame.origin.x - 2.0, button.frame.origin.y - 1.0, button.frame.size.width, button.frame.size.height);
            image = [[UIImage imageNamed:@"button-bar-item-yellow-arrow-stretch"] stretchableImageWithLeftCapWidth:12.0
                                                                                                      topCapHeight:0];
        } else if (isCallToActionButton) {
            // 20.0px left and right padding hence 20.0 + titleTextWidth
            button.frame = CGRectMake(0.0, 0.0, 20.0 + titleTextWidth, kButtonBarItemHeight);
            label.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y - 1.0, button.frame.size.width, button.frame.size.height);
            image = [[UIImage imageNamed:@"button-bar-item-yellow-stretch"] stretchableImageWithLeftCapWidth:4.0
                                                                                                topCapHeight:0];
        } else if (isStandardButtonWithArrow) {
            // 4.0px left and 16px right padding hence 20.0 + titleTextWidth
            button.frame = CGRectMake(0.0, 0.0, 20.0 + titleTextWidth, kButtonBarItemHeight);
            label.frame = CGRectMake(button.frame.origin.x + 4.0, button.frame.origin.y - 1.0, button.frame.size.width, button.frame.size.height);
            image = [[UIImage imageNamed:@"button-bar-item-black-arrow-stretch"] stretchableImageWithLeftCapWidth:12.0
                                                                                                     topCapHeight:0];
        } else if (isStandardButton) {
            // 20.0px left and right padding hence 20.0 + titleTextWidth
            button.frame = CGRectMake(0.0, 0.0, 20.0 + titleTextWidth, kButtonBarItemHeight);
            label.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y - 1.0, button.frame.size.width, button.frame.size.height);
            image = [[UIImage imageNamed:@"button-bar-item-black-stretch"] stretchableImageWithLeftCapWidth:4.0
                                                                                               topCapHeight:0];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = button.frame;        
        [button addSubview:imageView];
        [button addSubview:label];
    }
    else
    {
        button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame= CGRectMake(0.0, 0.0, 20.0 + titleTextWidth, kButtonBarItemHeight);
        [button setTitle:title
                forState:UIControlStateNormal];
        [button addTarget:self
                   action:action
         forControlEvents:UIControlEventTouchUpInside];
    }
    
    return button;
}

- (void) showStandardLeftHeaderButton
{
    _leftButton = [self getButtonFromTitle:@""
                                 andAction:@selector(leftButtonSelect:)
                                   andType:@"StandardWithArrow"];
    [_topBar addSubview:_leftButton];
}

- (void) addLeftHeaderButton:(NSString *)title
              withCallbackId:(NSString *)callbackId
                     andType:(NSString *)buttonType
{
    DEBUGLog(@"%@", title);
    
//    self.leftCallbackId = callbackId;
    _leftButton = [self getButtonFromTitle:title
                                 andAction:@selector(leftButtonSelect:)
                                   andType:buttonType];
    [_topBar addSubview:_leftButton];
//    overridableNavigationItem.leftBarButtonItem = leftBarButton;
//    [overridableNavigationItem setLeftBarButtonItem:leftBarButton animated:YES];
//    leftBarButtonViewHack = leftBarButton;
}

- (void) addRightHeaderButton:(NSString *)title
                withBadgeText:(NSString *)badgeText
               andBadgeColour:(NSString *)badgeColour
               andScaleFactor:(int)scale
                andCallbackId:(NSString *)callbackId
                      andType:(NSString *)buttonType
{
    //    self.rightCallbackId = callbackId;
    _rightButton = [self getButtonFromTitle:title
                                  andAction:@selector(rightButtonSelect:)
                                    andType:buttonType];
    [_topBar addSubview:_rightButton];
    //    overridableNavigationItem.leftBarButtonItem = leftBarButton;
    //    [overridableNavigationItem setLeftBarButtonItem:leftBarButton animated:YES];
    //    leftBarButtonViewHack = leftBarButton;
}

- (void) removeLeftHeaderButton
{
    [_leftButton removeFromSuperview];
}
- (void) removeRightHeaderButton
{
    [_rightButton removeFromSuperview];
}

@end
