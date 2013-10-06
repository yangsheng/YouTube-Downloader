//
//  searchViewController.m
//  Youtube_DL
//
//  Created by Majd Alfhaily on 10/3/13.
//  Copyright (c) 2013 Majd Alfhaily. All rights reserved.
//

#import "searchViewController.h"

@interface searchViewController ()
@end

@implementation searchViewController
NSString *videoName;
NSString *docDir;
NSString *openedVidURL;

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
    [super viewDidLoad];
    self.title = @"YouTube";
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkNetworkConnection) userInfo:nil repeats:NO];
    [self findDaDoc];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewCu)];
    [self initWebViewOfVid:@"http://m.youtube.com"];
}

- (void)extractURLFromVideo:(NSString *)origvideoURL
{
    [[[TWNotification alloc] init]initWithTitle:@"YouTube"
                                        message:@"Starting Download"
                                      alignment:Center
                                      withStyle:TWNotificationStyleMessage
                              orUseACustomColor: nil
                                         inView:self.navigationController.view
                                      hideAfter:1.5f];
    [self.view bringSubviewToFront:[TWNotification alloc]];
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

- (NSString*)findDaDoc
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return docDir;
}

- (void)checkNetworkConnection
{
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.google.com"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    BOOL connectedToInternet = NO;
    if ([NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]) {
        connectedToInternet = YES;
    }
    if (!connectedToInternet) {
        [[[TWNotification alloc] init]initWithTitle:@"Error"
                                            message:@"Network not available"
                                          alignment:Center
                                          withStyle:TWNotificationStyleError
                                  orUseACustomColor: nil
                                             inView:self.navigationController.view
                                          hideAfter:1.5f];
        [self.view bringSubviewToFront:[TWNotification alloc]];
        [NSTimer scheduledTimerWithTimeInterval:1.6 target:self selector:@selector(dismissViewCu) userInfo:nil repeats:NO];
    }

}

- (void)dlDone
{
    [[[TWNotification alloc] init]initWithTitle:@"YouTube"
                                        message:@"Download Complete"
                                      alignment:Center
                                      withStyle:TWNotificationStyleSuccess
                              orUseACustomColor: nil
                                         inView:self.navigationController.view
                                      hideAfter:1.5f];
    [self.view bringSubviewToFront:[TWNotification alloc]];
}

- (NSString *)getURL
{
    NSString *theURL=[_ytWebView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    openedVidURL = theURL;
    return openedVidURL;
}

- (NSString *)getTitle
{
    NSString *theTitle=[_ytWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    theTitle = [theTitle stringByReplacingOccurrencesOfString:@" - YouTube" withString:@""];
    videoName = theTitle;
    videoName = [videoName stringByAppendingString:@".mp4"];
    return videoName;
}

- (void)initWebViewOfVid:(NSString *)webURL
{
    _ytWebView.mediaPlaybackRequiresUserAction = YES;
    NSURL *nsurl=[NSURL URLWithString:webURL];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [_ytWebView loadRequest:nsrequest];
}


- (void)dismissViewCu
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)dlBtn:(id)sender {
    [self getTitle];
    [self getURL];
    [self extractURLFromVideo:openedVidURL];
}
@end
