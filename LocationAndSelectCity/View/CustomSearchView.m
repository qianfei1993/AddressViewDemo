//
//  CustomSearchView.m
//  AddressViewDemo
//
//  Created by damai on 2019/1/7.
//  Copyright © 2019 personal. All rights reserved.
//

#import "CustomSearchView.h"
@implementation CustomSearchView
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self setupSearchBar];
    }
    return self;
}

- (void)setupSearchBar{
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15, 7, self.width-30, 30)];
    _searchBar.layer.cornerRadius = 15;
    _searchBar.layer.borderWidth = 1.0;
    _searchBar.layer.borderColor = kRGBA(220, 220, 220, 1.0).CGColor;
    _searchBar.clipsToBounds = YES;
    [self addSubview:_searchBar];
    _searchBar.delegate = self;
    
    // 占位文字
    _searchBar.placeholder = @"请输入城市名称";
    //搜索框样式
    _searchBar.barStyle = UIBarMetricsDefault;
    
    // 修改搜索框的搜索图标
    [_searchBar setImage:[UIImage imageNamed:@"searchImg"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    // 修改图片偏移量
    [_searchBar setPositionAdjustment:UIOffsetMake(10, 0) forSearchBarIcon:UISearchBarIconSearch];
    // 文本框偏移
    _searchBar.searchFieldBackgroundPositionAdjustment = UIOffsetMake(-10, 0);
    // 文字偏移
    _searchBar.searchTextPositionAdjustment = UIOffsetMake(6, 0);
    // 隐藏删除按钮
    _searchBar.showsCancelButton = NO;
    // 光标颜色
    _searchBar.tintColor = [UIColor orangeColor];
    //背景颜色
    _searchBar.barTintColor = [UIColor redColor];
    // 提示信息
    //_searchBar.prompt = @"提示信息";
    // 设置是否透明
    _searchBar.translucent = YES;
    // 键盘附属视图
    UILabel *label = [[UILabel alloc]init];
    label.text = @"这是一个辅助视图";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.frame = CGRectMake(0, 0, 0, 30);
    label.backgroundColor = [UIColor redColor];
    _searchBar.inputAccessoryView = label;
    // 附件选择按钮视图
//    _searchBar.showsScopeBar = NO;
//    _searchBar.scopeButtonTitles = @[@"One",@"Two",@"Three",@"Two",@"Three"];
    //显示取消按钮
    _searchBar.showsCancelButton = NO;
    // 修改取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = kFont(15);
    cancelButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cancelButton setTitleColor:[UIColor colorWithRed:23/255.0  green:116/255.0  blue:222/255.0 alpha:1] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_searchBar setValue:cancelButton forKeyPath:@"cancelButton"];
  
    //[[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:@"取消"];
    //显示搜索结果按钮
    _searchBar.showsSearchResultsButton = NO;
    //输入框
    UITextField *textField = [_searchBar valueForKey:@"searchBarTextField"];
    textField.font = kFont(13);
    textField.borderStyle = UITextBorderStyleNone;
//    textField.layer.cornerRadius = 15;
//    textField.clipsToBounds = YES;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeNever;

    _searchBar.backgroundImage = [self imageWithColor:[UIColor whiteColor] size:_searchBar.bounds.size];
}

// 自定义取消按钮点击方法
- (void)cancelAction:(UIButton *)sender{
    
    _searchBar.text = nil;
    [_searchBar setShowsCancelButton:NO animated:YES];
    [_searchBar resignFirstResponder];
    if([_delegate respondsToSelector:@selector(didSelectCancelBtn)]){
        [_delegate didSelectCancelBtn];
    }
}

// UISearchBar得到焦点并开始编辑时，执行的方法
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:YES animated:YES];
    if(searchBar.text.length==0||[searchBar.text isEqualToString:@""]||[searchBar.text isKindOfClass:[NSNull class]]){
        if([_delegate respondsToSelector:@selector(searchBeginEditing)]){
            [_delegate searchBeginEditing];
        }
    }else{
        if([_delegate respondsToSelector:@selector(searchString:)]){
            [_delegate searchString:searchBar.text];
        }
    }
}


// 取消按钮被按下时，执行的方法(系统方法)
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.text = nil;
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    if([_delegate respondsToSelector:@selector(didSelectCancelBtn)]){
        [_delegate didSelectCancelBtn];
    }
}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
//    NSLog(@"searchBarSearchButtonClicked");
}
// 当搜索内容变化时，执行该方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
   if([_delegate respondsToSelector:@selector(searchString:)]){
       [_delegate searchString:searchText];
   }
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
