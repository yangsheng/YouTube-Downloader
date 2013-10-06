//
//  TWNotification.h
//  TWNotification
//
//  Created by Pigi Galdi on 09/09/12.
//  Copyright (c) 2012 Pigi Galdi. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
	TWNotificationStyleSuccess  = 0,
	TWNotificationStyleMessage  = 1,
    TWNotificationStyleError    = 2,
};


typedef NSUInteger TWNotificationStyle;

enum {
	Center  = 1,
	Left  = 0,
    Right    = 2,
};
typedef NSUInteger TWAlignment;


@interface TWNotification :  UIView{

    
    // Declare UILabel for notification text.
    UILabel *_notificationText;
}
// Init mothods.
- (id)initWithTitle:(NSString *)twTitle message:(NSString *)twMessage alignment:(TWAlignment)alignment withStyle:(TWNotificationStyle)twStyle orUseACustomColor:(UIColor *)color inView:(UIView *)userView hideAfter:(float)twTimer;
- (void)showAndHideAfter:(float)timeToHide;
- (void)close;
@end
