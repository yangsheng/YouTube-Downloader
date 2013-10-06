//
//  iPhoneViewController.m
//  Youtube_DL
//
//  Created by Majd Alfhaily on 10/1/13.
//  Copyright (c) 2013 Majd Alfhaily. All rights reserved.
//

#import "iPhoneViewController.h"

@interface iPhoneViewController ()

@end

@implementation iPhoneViewController

NSString *docDir;
UIWebView *webview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self.view.backgroundColor = [UIColor whiteColor];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString*)findDocDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return docDir;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self findDocDir];
    self.title = @"Home";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menubaricon.png"] style:UIBarButtonItemStylePlain target:self.viewDeckController action:@selector(toggleLeftView)];
    self.viewDeckController.shadowEnabled = NO;
    UIButton *bookmarkletInstall = [UIButton buttonWithType:UIButtonTypeSystem];
    [bookmarkletInstall addTarget:self action:@selector(installBookmark) forControlEvents:UIControlEventTouchUpInside];
    [bookmarkletInstall setTitle:@"Install Bookmarklet" forState:UIControlStateNormal];
    bookmarkletInstall.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:bookmarkletInstall];
}

- (void)installBookmark
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://freemanrepo.me/yt_downloader/install.php?bookmark=javascript:window.location='filedl://'+document.URL;"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
