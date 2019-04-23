//
//  CityTableViewCell.m
//  PandaNaughty
//
//  Created by damai on 2018/11/27.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "FoldCityTableViewCell.h"
#import "CityCollectionViewCell.h"
#import "UIButton+Category.h"
#import "CityCollectionViewFlowLayout.h"
#import "NSString+Size.h"
@interface FoldCityTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *collectArr;
@end
@implementation FoldCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initWithCollectionView];
}

- (void)setDict:(NSDictionary *)dict{

    _dict = dict;
    NSString *cityName = kStringFormat(@"%@",_dict[@"name"]);
    [self.titleButton setTitle:cityName forState:UIControlStateNormal];
          _titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, kScreenWidth-56, 0, 0);
    self.collectArr = _dict[@"districts"];
    [self.cityCollectionView reloadData];
}

- (void)initWithCollectionView{
    
    self.cityCollectionView.delegate = self;
    self.cityCollectionView.dataSource = self;
    CityCollectionViewFlowLayout *layout = [[CityCollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    self.cityCollectionView.collectionViewLayout = layout;
    self.cityCollectionView.scrollEnabled = YES;
    self.cityCollectionView.showsHorizontalScrollIndicator = NO;
    self.cityCollectionView.showsVerticalScrollIndicator = NO;
    self.cityCollectionView.backgroundColor = [UIColor whiteColor];
    [self.cityCollectionView registerNib:kLoadNib(@"CityCollectionViewCell") forCellWithReuseIdentifier:@"CityCollectionViewCellID"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.collectArr[indexPath.item];
    NSString *name = kStringFormat(@"%@",dict[@"name"]);
    return [self textContentSize:name];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CityCollectionViewCellID" forIndexPath:indexPath];
    cell.dict = self.collectArr[indexPath.item];
    return cell;
}

// 添加历史记录
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *cityArr = [NSMutableArray array];
    NSMutableDictionary *mulDict = [NSMutableDictionary dictionary];
    //读取历史缓存
    NSArray *array = (NSArray*)kUserDefaults_GET_OBJECT(@"cityCache");
    NSMutableArray *districts = [NSMutableArray array];
    if (kISNullArray(array)) {
        //创建
        NSDictionary *dict = @{
                                  @"code" : @"0",
                                  @"districts" : @[],
                                  @"name" : @"历史访问城市"
                                  };
        [cityArr addObject:dict];
        mulDict = dict.mutableCopy;
        NSArray *arr = [mulDict objectForKey:@"districts"];
        districts = arr.mutableCopy;
    }else{
        //取值
        cityArr = array.mutableCopy;
        NSDictionary *dict = [cityArr objectAtIndex:0];
        mulDict = dict.mutableCopy;
        NSArray *arr = [mulDict objectForKey:@"districts"];
        districts = arr.mutableCopy;
    }
    
    if (self.titleButton.hidden == YES) {
        NSDictionary *dict = self.collectArr[indexPath.item];
        NSString *name = kStringFormat(@"%@",dict[@"name"]);
        if ([self.titleButton.titleLabel.text isEqualToString:@"定位城市"]){
            if (self.nameBlock) {
                self.nameBlock(@"定位", name);
            }
        }else{
            if (self.nameBlock) {
                self.nameBlock(self.dict[@"name"], name);
            }
        }
        if ([self.titleButton.titleLabel.text isEqualToString:@"热门城市"]) {
            NSDictionary *dict = self.collectArr[indexPath.item];
            //判重
            if ([self isRepeat:districts :dict]) {
                [districts insertObject:dict atIndex:0];
                [mulDict setObject:districts forKey:@"districts"];
            }
            [cityArr replaceObjectAtIndex:0 withObject:mulDict];
            kUserDefaults_SET_OBJECT(cityArr, @"cityCache");
        }
    }else{
        if (indexPath.item == 0) {
            NSString *name = kStringFormat(@"%@",_dict[@"name"]);
            if ([self isRepeat:districts :_dict]) {
                [districts insertObject:_dict atIndex:0];
                [mulDict setObject:districts forKey:@"districts"];
            }
            if (self.nameBlock) {
                self.nameBlock(self.dict[@"name"], name);
            }
        }else{
            NSDictionary *dict = self.collectArr[indexPath.item];
            // 添加新数据
            //判重
            if ([self isRepeat:districts :dict]) {
                [districts insertObject:dict atIndex:0];
                [mulDict setObject:districts forKey:@"districts"];
            }
            NSString *name = kStringFormat(@"%@",dict[@"name"]);
            if (self.nameBlock) {
                self.nameBlock(self.dict[@"name"], name);
            }
        }
        [cityArr replaceObjectAtIndex:0 withObject:mulDict];
        kUserDefaults_SET_OBJECT(cityArr, @"cityCache");
    }
}

// 判重
- (BOOL)isRepeat:(NSMutableArray*)mulArr :(NSDictionary*)dict{
    NSString *name = kStringFormat(@"%@",dict[@"name"]);
    for (NSDictionary *objDict in mulArr) {
        NSString *nameStr = objDict[@"name"];
        if ([name isEqualToString:nameStr]) {
            return NO;
        }
    }
    return YES;
}


//  点击展开/收起
- (IBAction)titleButtonAction:(UIButton *)sender {
    
    // 获取indexpath
    if (self.block) {
        self.block(sender);
    }
}

// 计算文字Size
- (CGSize)textContentSize:(NSString *)text {
    
    CGSize size = [text sizeForFont:kFont(14) size:CGSizeMake(kScreenWidth-46-60, 34) mode:NSLineBreakByWordWrapping];
    //NSLog(@"size === %.2f=====%.2f",size.width,size.height);
     CGFloat labelWidth = MIN(self.cityCollectionView.frame.size.width - 30 - 30, ceil(size.width));
     CGSize newsize = CGSizeMake(labelWidth + 30 + 30 , 34);
    //NSLog(@"newsize === %.2f=====%.2f",newsize.width,newsize.height);
    return newsize;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
