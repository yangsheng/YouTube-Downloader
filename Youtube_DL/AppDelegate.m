//
//  AppDelegate.m
//  Youtube_DL
//
//  Created by Majd Alfhaily on 10/1/13.
//  Copyright (c) 2013 Majd Alfhaily. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

NSString *docDir;
UIWebView *webview;
NSString *videoName;
NSString *newVidU;
iPhoneViewController *iPhoneMain;
UINavigationController *mainController;
sideBarViewController *leftController;
IIViewDeckController *deckController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    iPhoneMain = [[iPhoneViewController alloc] init];
    leftController = [[sideBarViewController alloc] init];
    mainController = [[UINavigationController alloc] initWithRootViewController:iPhoneMain];
    deckController = [[IIViewDeckController alloc] initWithCenterViewController:mainController leftViewController:leftController];
    [self.window setRootViewController:deckController];
    return YES;
}

- (NSString*)findDocDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return docDir;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [self findDocDir];
    NSString *urlStr = [url absoluteString];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"filedl://" withString:@""];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"http//" withString:@""];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"https//" withString:@""];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"m." withString:@"www."];
    urlStr = [@"http://" stringByAppendingString:urlStr];
    [self initWebViewOfVid:urlStr];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getTitle) userInfo:nil repeats:NO];
    newVidU = urlStr;
    [[[TWNotification alloc] init]initWithTitle:@"YouTube"
                                        message:@"Starting Download"
                                      alignment:Center
                                      withStyle:TWNotificationStyleMessage
                              orUseACustomColor: nil
                                         inView:self.window
                                      hideAfter:1.5f];
    [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(getDaVid) userInfo:nil repeats:NO];
    return YES;
}

- (void)getDaVid
{
    [self extractURLFromVideo:newVidU];
}

- (NSString *)getTitle
{
    NSString *theTitle=[webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    theTitle = [theTitle stringByReplacingOccurrencesOfString:@" - YouTube" withString:@""];
    videoName = theTitle;
    videoName = [videoName stringByAppendingString:@".mp4"];
    return videoName;
}

- (void)initWebViewOfVid:(NSString *)webURL
{
    webview = [[UIWebView alloc]initWithFrame:CGRectMake(-200, -300, 55,55)];
    NSURL *nsurl=[NSURL URLWithString:webURL];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webview loadRequest:nsrequest];
    [self.window addSubview:webview];
}

- (void)extractURLFromVideo:(NSString *)origvideoURL
{

    LBYouTubeExtractor *urlExtractor = [[LBYouTubeExtractor alloc] initWithURL:[NSURL URLWithString:origvideoURL] quality:LBYouTubeVideoQualityMedium];
    [urlExtractor extractVideoURLWithCompletionBlock:^(NSURL *videoURL, NSError *error) {
        if(!error) {
            NSURLRequest *requestVid = [NSURLRequest requestWithURL:videoURL];
            AFURLConnectionOperation *dlOp = [[AFHTTPRequestOperation alloc] initWithRequest:requestVid];
            dlOp.outputStream = [NSOutputStream outputStreamToFileAtPath:[docDir stringByAppendingPathComponent:videoName] append:NO];
            [dlOp start];
            [dlOp waitUntilFinished];
            [self dlDone];
        }
    }];
}

- (void)dlDone
{
    [[[TWNotification alloc] init]initWithTitle:@"YouTube"
                                        message:@"Download Complete"
                                      alignment:Center
                                      withStyle:TWNotificationStyleSuccess
                              orUseACustomColor: nil
                                         inView:self.window
                                      hideAfter:1.5f];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
