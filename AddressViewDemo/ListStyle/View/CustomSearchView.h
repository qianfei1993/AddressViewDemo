//
//  CustomSearchView.h
//  AddressViewDemo
//
//  Created by damai on 2019/1/7.
//  Copyright © 2019 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSearchViewDelegate <NSObject>
-(void)searchBeginEditing;
-(void)didSelectCancelBtn;
-(void)searchString:(NSString *)string;
@end

@interface CustomSearchView : UIView<UISearchBarDelegate>

@property (nonatomic,retain)UISearchBar *searchBar;
@property (nonatomic,retain)UIButton *cancelBtn;
@property (nonatomic,assign) id <CustomSearchViewDelegate>delegate;

@end


