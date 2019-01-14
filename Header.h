//
//  Header.h
//  AddressViewDemo
//
//  Created by damai on 2019/1/7.
//  Copyright © 2019 personal. All rights reserved.
//

#ifndef Header_h
#define Header_h

/**
 手机屏幕
 */
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
//手机型号
#define kISiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kScreenMaxLength (MAX(kScreenWidth, kScreenHeight))
#define kScreenMinLength (MIN(kScreenWidth, kScreenHeight))
#define kISiPhone5 (kISiPhone && kScreenMaxLength == 568.0)
#define kISiPhone6 (kISiPhone && kScreenMaxLength == 667.0)
#define kISiPhone6P (kISiPhone && kScreenMaxLength == 736.0)
#define kISiPhoneX (kISiPhone && kScreenMaxLength == 812.0)
#define kISiPhoneXr (kISiPhone && kScreenMaxLength == 896.0)
#define kISiPhoneXX (kISiPhone && kScreenMaxLength > 811.0)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)

//状态栏高度
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//标签栏高度
#define kTabBarHeight (kStatusBarHeight > 20 ? 83 : 49)
//导航栏高度
#define kNavBarHeight (kStatusBarHeight + 44)
//安全区高度
#define kSafeAreaBottom (kISiPhoneXX ? 34 : 0)


//6为标准适配的,如果需要其他标准可以修改
#define kScale_H(h) ((kISiPhoneXX ? 736 : kScreenHeight)/667) * (h)
#define kScale_W(w) ((kScreenWidth)/375) * (w)

/**
 字体样式
 */
#define kBoldFont(x) [UIFont boldSystemFontOfSize:x]
#define kFont(x) [UIFont systemFontOfSize:x]

/**
 手机色彩
 */
//标准RGBA格式
#define kRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/**
 获取系统对象
 */
#define kApplication [UIApplication sharedApplication]
//主窗口 （keyWindow）
#define kKeyWindow [UIApplication sharedApplication].keyWindow
//NSUserDefaults实例化
#define kUserDefaults [NSUserDefaults standardUserDefaults]
//通知中心 （单例对象）
#define kNotificationCenter [NSNotificationCenter defaultCenter]
//发送通知
#define KPostNotification(name,obj,info) [[NSNotificationCenter defaultCenter]postNotificationName:name object:obj userInfo:info]

/**
 简单调用
 */
//加载图片
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
//弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type
//强引用
#define kStrongSelf(type)  __strong typeof(type) type = weak##type
//加载xib
#define kLoadNib(nibName) [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]]
//字符串拼接
#define kStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]


// View 圆角和加边框
#define kViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]
// View 圆角
#define kViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]


/**
 线程
 */
//GCD - 在Main线程上运行
#define kMainThread(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//GCD - 开启异步线程
#define kGlobalThread(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);


/**
 判空
*/
//字符串是否为空
#define kISNullString(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kISNullArray(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0 ||[array isEqual:[NSNull null]])
//字典是否为空
#define kISNullDict(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0 || [dic isEqual:[NSNull null]])
//是否是空对象
#define kISNullObject(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//判断对象是否为空,为空的话则返回默认值
#define D_StringFix(_value,_default) ([_value isKindOfClass:[NSNull class]] || !_value || _value == nil || [_value isEqualToString:@"(null)"] || [_value isEqualToString:@"<null>"] || [_value isEqualToString:@""] || [_value length] == 0)?_default:_value

/**
 *    永久存储对象
 *
 *    @param    object    需存储的对象
 *    @param    key    对应的key
 */
#define kUserDefaults_SET_OBJECT(object, key)                                                                                                 \
({                                                                                                                                             \
NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];                                                                         \
[defaults setObject:object forKey:key];                                                                                                    \
[defaults synchronize];                                                                                                                    \
})
/**  获取对象  */
#define kUserDefaults_GET_OBJECT(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#endif /* Header_h */
