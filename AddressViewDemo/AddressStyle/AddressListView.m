//
//  TextFieldTool.h
//
//
//  Created by damai on 2018/8/30.
//  Copyright © 2018年 damai. All rights reserved.

#import "AddressListView.h"
#import "UIColor+HexString.h"
#import "UIView+Frame.h"
#import "YYModel.h"
#import "CityModel.h"
#import "AddressCell.h"

//设备物理尺寸
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
@interface AddressListView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

//地址视图
@property(nonatomic,strong)UIView *addAddressView;
//标题数组
@property(nonatomic,strong)NSMutableArray *titleMarr;
//列表数组
@property(nonatomic,strong)NSMutableArray *tableViewMarr;
//标题滑动视图
@property(nonatomic,strong)UIScrollView *titleScrollView;
//分割线
@property(nonatomic,strong)UIView *lineView;
//第一组列表视图
@property(nonatomic,strong)UITableView *firstTableView;
//列表滑动视图
@property(nonatomic,strong)UIScrollView *contentScrollView;
@property(nonatomic,strong)UIButton *radioBtn;
//标题按钮数组
@property(nonatomic,strong)NSMutableArray *titleBtns;
//标题下划线
@property(nonatomic,strong)UILabel *lineLabel;
//标题ID数组
@property(nonatomic,strong)NSMutableArray *titleIDMarr;
//判断是滚动还是点击
@property(nonatomic,assign)BOOL isclick;
@property(nonatomic,strong)NSMutableArray *provinceMarr;//省
@property(nonatomic,strong)NSMutableArray *cityMarr;//市
@property(nonatomic,strong)NSMutableArray *countyMarr;//县
@property(nonatomic,strong)NSArray *resultArr;//数据源
@end
@implementation AddressListView

//初始化
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.defaultHeight = 400;
        self.cellHeight = 44;
        self.topHeight = 44;
        self.selectColor = [UIColor colorWithHexString:@"#3da5ff"];
        [self initAddressView];
    }
    return self;
}

//初始化
+(instancetype)store{
    
    return [[self alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
}

//初始化视图
-(void)initAddressView{
    
    //加载本地数据
    NSError *error;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"json"];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:&error];
    _resultArr = [jsonDic objectForKey:@"districts"];
    
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.hidden = YES;
    //取消手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBtnClick)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    //设置添加地址的View
    self.addAddressView = [[UIView alloc]init];
    self.addAddressView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.defaultHeight);
    self.addAddressView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.addAddressView];
   
    _firstTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.defaultHeight-self.topHeight) style:UITableViewStylePlain];
    _firstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _firstTableView.tag = 0;
    self.tableViewMarr = [[NSMutableArray alloc]init];
    self.titleMarr = [[NSMutableArray alloc]init];
    [self.tableViewMarr addObject:_firstTableView];
    [self.titleMarr addObject:@"请选择"];
    //1.添加标题滚动视图
    [self setupTitleScrollView];
    //2.添加内容滚动视图
    [self setupContentScrollView];
    [self setupAllTitle:0];
}

-(void)setTopHeight:(CGFloat)topHeight{
    
    _topHeight = topHeight;
    self.titleScrollView.height = self.topHeight;
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame) + 1;
    self.contentScrollView.frame = CGRectMake(0, y, kScreenWidth, self.defaultHeight - y);
    _firstTableView.frame = CGRectMake(0, 0, self.contentScrollView.width, self.contentScrollView.height);
    _lineView.frame = CGRectMake(0, CGRectGetMaxY(self.titleScrollView.frame), kScreenWidth, 0.5);
    [self setupAllTitle:0];
    
}
-(void)setCellHeight:(CGFloat)cellHeight{
    
    _cellHeight = cellHeight;
    
}
-(void)setDefaultHeight:(CGFloat)defaultHeight{
    
    _defaultHeight = defaultHeight;
    self.addAddressView.height = self.defaultHeight;
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame) + 1;
    self.contentScrollView.frame = CGRectMake(0, y, kScreenWidth, self.defaultHeight - y);
    _firstTableView.frame = CGRectMake(0, 0, self.contentScrollView.width, self.contentScrollView.height);
}
-(void)setSelectColor:(UIColor *)selectColor{
    
    _selectColor = selectColor;
    self.lineLabel.backgroundColor = self.selectColor;
}

//弹出视图
-(void)show{
    
    self.hidden = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.35 animations:^{
       self.addAddressView.frame = CGRectMake(0, kScreenHeight - self.defaultHeight, kScreenWidth, self.defaultHeight);
    }];
}

//取消手势
-(void)tapBtnClick{
    
    self.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        self.addAddressView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.defaultHeight);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

//视图取消
-(void)tapBtnAndcancelBtnClick{
    
    self.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
         self.addAddressView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.defaultHeight);
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        NSMutableString * titleAddress = [[NSMutableString alloc]init];
        NSMutableString * titleID = [[NSMutableString alloc]init];
        NSInteger  count = 0;
        NSString *str = self.titleMarr[self.titleMarr.count - 1];
        if ([str isEqualToString:@"请选择"]) {
            count = self.titleMarr.count - 1;
        }
        else{
            count = self.titleMarr.count;
        }
        for (int i = 0; i< count ; i++) {
            
            if (i == 0) {
                [titleAddress appendString:[[NSString alloc]initWithFormat:@"%@",self.titleMarr[i]]];
            }else{
                [titleAddress appendString:[[NSString alloc]initWithFormat:@" %@",self.titleMarr[i]]];
            }
            if (i == count - 1) {
                [titleID appendString:[[NSString alloc]initWithFormat:@"%@",self.titleIDMarr[i]]];
            }else{
                [titleID appendString:[[NSString alloc]initWithFormat:@"%@|",self.titleIDMarr[i]]];
            }
        }
        if (self.addressBlock) {
            self.addressBlock(titleAddress, titleID);
        }
    }];
}


//创建滑动视图
-(void)setupTitleScrollView{
    
    //TitleScrollView和分割线
    self.titleScrollView = [[UIScrollView alloc]init];
    self.titleScrollView.frame = CGRectMake(0, 0, kScreenWidth, self.topHeight);
    [self.addAddressView addSubview:self.titleScrollView];
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleScrollView.frame), kScreenWidth, 0.5)];
    _lineView.backgroundColor = [UIColor grayColor];
    [self.addAddressView addSubview:_lineView];
}

//滑动视图内容视图
-(void)setupContentScrollView{
    
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame) + 1;
    self.contentScrollView = [[UIScrollView alloc]init];
    self.contentScrollView.frame = CGRectMake(0, y, kScreenWidth, self.defaultHeight - y);
    [self.addAddressView addSubview:self.contentScrollView];
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.bounces = NO;
}

//滑动视图顶部title
-(void)setupAllTitle:(NSInteger)selectId{
    
    for ( UIView * view in [self.titleScrollView subviews]) {
         [view removeFromSuperview];
    }
    [self.titleBtns removeAllObjects];
    CGFloat btnH = self.topHeight;
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    _lineLabel.backgroundColor = self.selectColor;
    [self.titleScrollView addSubview:(_lineLabel)];
    CGFloat x = 15;
    for (int i = 0; i < self.titleMarr.count ; i++) {
        NSString *title = self.titleMarr[i];
        CGFloat titlelenth = title.length * 20;
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleBtn setTitle:title forState:UIControlStateNormal];
        titleBtn.tag = i;
        [titleBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        titleBtn.selected = NO;
        titleBtn.frame = CGRectMake(x, 0, titlelenth, btnH);
        x  = titlelenth + 10 + x;
        [titleBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleBtns addObject:titleBtn];
        if (i == selectId) {
            [self titleBtnClick:titleBtn];
        }
        [self.titleScrollView addSubview:(titleBtn)];
        self.titleScrollView.contentSize =CGSizeMake(x, 0);
        self.titleScrollView.showsHorizontalScrollIndicator = NO;
        self.contentScrollView.contentSize = CGSizeMake(self.titleMarr.count * kScreenWidth, 0);
        self.contentScrollView.showsHorizontalScrollIndicator = NO;
    }
}

//title选中
-(void)titleBtnClick:(UIButton *)titleBtn{
    
    self.radioBtn.selected = NO;
    titleBtn.selected = YES;
    [self setupOneTableView:titleBtn.tag];
    CGFloat x  = titleBtn.tag * kScreenWidth;
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    self.lineLabel.frame = CGRectMake(CGRectGetMinX(titleBtn.frame), self.topHeight - 3,titleBtn.frame.size.width, 3);
    self.radioBtn = titleBtn;
    self.isclick = YES;
}

-(void)setupOneTableView:(NSInteger)btnTag{
    
    UITableView *tableView= self.tableViewMarr[btnTag];
    if  (btnTag == 0) {
        //获取省级数据
        [self getProvinceData];
    }
    if (tableView.superview != nil) {
        return;
    }
    CGFloat x = btnTag * kScreenWidth;
    tableView.frame = CGRectMake(x, 0, kScreenWidth, self.contentScrollView.bounds.size.height);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.contentScrollView addSubview:tableView];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger leftI  = scrollView.contentOffset.x / kScreenWidth;
    if (scrollView.contentOffset.x / kScreenWidth != leftI){
        self.isclick = NO;
    }
    if (self.isclick == NO) {
        if (scrollView.contentOffset.x / kScreenWidth == leftI){
            UIButton * titleBtn  = self.titleBtns[leftI];
            [self titleBtnClick:titleBtn];
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 0) {
        return self.provinceMarr.count;
    }
    else if (tableView.tag == 1) {
        return self.cityMarr.count;
    }
    else if (tableView.tag == 2){
        return self.countyMarr.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * AddressAdministerCellIdentifier = @"AddressAdministerCellIdentifier";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:AddressAdministerCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddressAdministerCellIdentifier];
    }
    if (tableView.tag == 0) {
        ProvinceModel * provinceModel = self.provinceMarr[indexPath.row];
        cell.textLabel.text = provinceModel.name;
    }else if (tableView.tag == 1) {
        CityModel *cityModel = self.cityMarr[indexPath.row];
        cell.textLabel.text= cityModel.name;
    }else if (tableView.tag == 2){
        CountyModel * countyModel  = self.countyMarr[indexPath.row];
        cell.textLabel.text = countyModel.name;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = self.selectColor;
    if (tableView.tag == 0 || tableView.tag == 1 || tableView.tag == 2){
        if (tableView.tag == 0){
            ProvinceModel *provinceModel = self.provinceMarr[indexPath.row];
            NSString *provinceID = [NSString stringWithFormat:@"%@",provinceModel.adcode];
            //1. 修改选中ID
            if (self.titleIDMarr.count > 0){
                [self.titleIDMarr replaceObjectAtIndex:tableView.tag withObject:provinceID];
            }else{
                [self.titleIDMarr addObject:provinceID];
            }
            //2.修改标题
              [self.titleMarr replaceObjectAtIndex:tableView.tag withObject:provinceModel.name];
            //请求网络 添加市区
            NSArray *cityArr = provinceModel.districts;
            [self getCityData:cityArr];
        }else if (tableView.tag == 1){
            
            CityModel *cityModel = self.cityMarr[indexPath.row];
            NSString *cityID = [NSString stringWithFormat:@"%@",cityModel.adcode];
             [self.titleMarr replaceObjectAtIndex:tableView.tag withObject:cityModel.name];
            //1. 修改选中ID
            if (self.titleIDMarr.count > 1){
                [self.titleIDMarr replaceObjectAtIndex:tableView.tag withObject:cityID];
            }
            else{
                 [self.titleIDMarr addObject:cityID];
            }
            //添加县
            NSArray *countryArr = cityModel.districts;
            [self getcountyData:countryArr];
        }else if (tableView.tag == 2) {
            CountyModel *countyModel = self.countyMarr[indexPath.row];
            NSString * countyID = [NSString stringWithFormat:@"%@",countyModel.adcode];
            [self.titleMarr replaceObjectAtIndex:tableView.tag withObject:countyModel.name];
            //1. 修改选中ID
            if (self.titleIDMarr.count > 2){
                [self.titleIDMarr replaceObjectAtIndex:tableView.tag withObject:countyID];
            }else{
                [self.titleIDMarr addObject:countyID];
            }
            //2.修改标题
            [self.titleMarr replaceObjectAtIndex:tableView.tag withObject:countyModel.name];
            [self setupAllTitle:tableView.tag];
            [self tapBtnAndcancelBtnClick];
        }
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  self.cellHeight;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass(touch.view.classForCoder) isEqualToString: @"UITableViewCellContentView"] || touch.view == self.addAddressView || touch.view == self.titleScrollView) {
        return NO;
    }
    return YES;
}

//获取省级数据
-(void)getProvinceData{
    
    [self.provinceMarr removeAllObjects];
    for (NSDictionary *dict in self.resultArr) {
        ProvinceModel *provinceModel = [ProvinceModel yy_modelWithDictionary:dict];
        [self.provinceMarr addObject:provinceModel];
    }
}

//获取市级数据
-(void)getCityData:(NSArray *)array{
    [self.cityMarr removeAllObjects];
    if (array.count > 0){
        for (NSDictionary *dict in array) {
            CityModel *cityModel = [CityModel yy_modelWithDictionary:dict];
            [self.cityMarr addObject:cityModel];
        }
        
        if (self.tableViewMarr.count >= 2){
            UITableView * tableView  = self.tableViewMarr[1];
            [tableView reloadData];
            [self.titleMarr replaceObjectAtIndex:1 withObject:@"请选择"];
            NSInteger index = [self.titleMarr indexOfObject:@"请选择"];
            NSInteger count = self.titleMarr.count;
            NSInteger loc = index + 1;
            NSInteger range = count - index;
            [self.titleMarr removeObjectsInRange:NSMakeRange(loc, range - 1)];
            [self.tableViewMarr removeObjectsInRange:NSMakeRange(loc, range - 1)];
        }else{
            UITableView * tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200) style:UITableViewStylePlain];
            tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView2.tag = 1;
            [self.tableViewMarr addObject:tableView2];
            [self.titleMarr addObject:@"请选择"];
        }
        [self setupAllTitle:1];
    }else{
        
        //没有对应的市
        if (self.tableViewMarr.count >= 2){
            [self.titleMarr removeObjectsInRange:NSMakeRange(1, self.titleMarr.count - 2)];
            [self.tableViewMarr removeObjectsInRange:NSMakeRange(1, self.tableViewMarr.count - 2)];
        }
        [self setupAllTitle:0];
        [self tapBtnAndcancelBtnClick];
    }
}

//获取县级数据
-(void)getcountyData:(NSArray *)array{
    
    [self.countyMarr removeAllObjects];
    if (array.count > 0){
        
        for (NSDictionary *dict in array) {
            CountyModel *countryModel = [CountyModel yy_modelWithDictionary:dict];
            [self.countyMarr addObject:countryModel];
        }
        
        if (self.tableViewMarr.count >= 3){
            UITableView * tableView  = self.tableViewMarr[2];
            [tableView reloadData];
            [self.titleMarr replaceObjectAtIndex:2 withObject:@"请选择"];
            NSInteger index = [self.titleMarr indexOfObject:@"请选择"];
            NSInteger count = self.titleMarr.count;
            NSInteger loc = index + 1;
            NSInteger range = count - index;
            [self.titleMarr removeObjectsInRange:NSMakeRange(loc, range - 1)];
            [self.tableViewMarr removeObjectsInRange:NSMakeRange(loc, range - 1)];
        }else{
            
            UITableView * tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200) style:UITableViewStylePlain];
            tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView2.tag = 2;
            [self.tableViewMarr addObject:tableView2];
            [self.titleMarr addObject:@"请选择"];
        }
        [self setupAllTitle:2];
    }else{
        
        //没有对应的县
        if (self.tableViewMarr.count >= 3){
            [self.titleMarr removeObjectsInRange:NSMakeRange(2, self.titleMarr.count - 3)];
            [self.tableViewMarr removeObjectsInRange:NSMakeRange(2, self.tableViewMarr.count - 3)];
        }
        [self setupAllTitle:1];
        [self tapBtnAndcancelBtnClick];
    }
}

// 懒加载
-(NSMutableArray *)titleBtns{
    
    if (_titleBtns == nil) {
        _titleBtns = [[NSMutableArray alloc]init];
    }
    return _titleBtns;
}

//标题ID数组
-(NSMutableArray *)titleIDMarr{
    
    if (_titleIDMarr == nil) {
        _titleIDMarr = [[NSMutableArray alloc]init];
    }
    return _titleIDMarr;
}

//省
-(NSMutableArray *)provinceMarr{
    
    if (_provinceMarr == nil) {
        _provinceMarr = [[NSMutableArray alloc]init];
    }
    return _provinceMarr;
}

//市
-(NSMutableArray *)cityMarr{
    
    if (_cityMarr == nil) {
        _cityMarr = [[NSMutableArray alloc]init];
    }
    return _cityMarr;
}

//区
-(NSMutableArray *)countyMarr{
    
    if (_countyMarr == nil) {
        _countyMarr = [[NSMutableArray alloc]init];
    }
    return _countyMarr;
}

@end

