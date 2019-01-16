//
//  NSString+Size.h
//  AddressViewDemo
//
//  Created by damai on 2019/1/14.
//  Copyright © 2019 personal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
@end
