//
//  searchViewController.h
//  Youtube_DL
//
//  Created by Majd Alfhaily on 10/3/13.
//  Copyright (c) 2013 Majd Alfhaily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBYouTubeExtractor.h"
#import "AFNetworking.h"
#import "TWNotification.h"

@interface searchViewController : UIViewController
- (IBAction)dlBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *ytWebView;

@end
