//
//  SystemLocationTool.h
//  AddressViewDemo
//
//  Created by damai on 2019/1/7.
//  Copyright © 2019 personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^LocationPlacemark)(CLPlacemark *placemark);
typedef void(^LocationFailed)(NSError *error);

@interface SystemLocationTool : NSObject

+ (instancetype)sharedInstance;

- (void)getLocationViewController:(UIViewController*)viewController Placemark:(LocationPlacemark)placemark didFailWithError:(LocationFailed)error;

@end
