//
//  AddressPickerView.m
//
//
//  Created by damai on 2018/8/30.
//  Copyright © 2018年 damai. All rights reserved.
//

#import "AddressPickerView.h"
#import "UIView+Frame.h"
#import "YYModel.h"
#import "CityModel.h"
#import "UIColor+HexString.h"
//#import "NSString+Category.h"
#define SCREEN [UIScreen mainScreen].bounds.size
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface AddressPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong)NSMutableArray *provinceMarr;//省
@property(nonatomic,strong)NSMutableArray *cityMarr;//市
@property(nonatomic,strong)NSMutableArray *countyMarr;//县


@property (nonatomic,copy)NSString *provinceStr;
@property (nonatomic,copy)NSString *provinceIDStr;

@property (nonatomic,copy)NSString *cityStr;
@property (nonatomic,copy)NSString *cityIDStr;

@property (nonatomic,copy)NSString *districtStr;
@property (nonatomic,copy)NSString *districtIDStr;

@property (nonatomic,copy)NSString *resultsStr;
@property (nonatomic,copy)NSString *localIDStr;

@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIButton *completeBtn;

@end
@implementation AddressPickerView
-(instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self initAddressView];
    }
    return self;
}


-(void)initAddressView{
    
    //获取数据
    NSError *error;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"json"];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:&error];
    NSArray *resultArr = [jsonDic objectForKey:@"districts"];
    [self getProvinceData:resultArr];
    //省
    ProvinceModel *pModel = self.provinceMarr[0];
    self.provinceStr = pModel.name;
    self.provinceIDStr = pModel.adcode;
    [self getCityData:pModel.districts];
    //市
    CityModel *cModel = self.cityMarr[0];
    self.cityStr = cModel.name;
    self.cityIDStr = cModel.adcode;
    [self getcountyData:cModel.districts];
    //区
    CountyModel *coModel = self.countyMarr[0];
    self.districtStr = coModel.name;
    self.districtIDStr = coModel.adcode;
    
    self.resultsStr=[NSString stringWithFormat:@"%@ %@ %@",self.provinceStr,self.cityStr,self.districtStr];
    self.localIDStr = [NSString stringWithFormat:@"%@|%@|%@",self.provinceIDStr,self.cityIDStr,self.districtIDStr];
    
    //设置默认值
    self.defaultHeight = 290;
    self.topHeight = 50;
    self.topColor = [UIColor colorWithHexString:@"#3da5ff"];
    
    
    _bgView= [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN.height, SCREEN.width, _defaultHeight)];
    _bgView.userInteractionEnabled=YES;
    [self addSubview:_bgView];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.width, _topHeight)];
    _topView.backgroundColor = _topColor;
    _topView.userInteractionEnabled=YES;
    [_bgView addSubview:_topView];
    
    
    _cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 0, 40, _topView.height)];
    [_cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_topView addSubview:_cancelBtn];
    
    _completeBtn=[[UIButton alloc]initWithFrame:CGRectMake( SCREEN.width-55, 0, 40, _topView.height)];
    [_completeBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_topView addSubview:_completeBtn];
    
    
    _pickerView =[[UIPickerView alloc]init];
    _pickerView.frame=CGRectMake(0, _topHeight, SCREEN.width, _bgView.height - _topHeight);
    _pickerView.delegate=self;
    _pickerView.dataSource=self;
    _pickerView.backgroundColor=[UIColor whiteColor];
    [_bgView addSubview:_pickerView];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *Gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Action:)];
    [self addGestureRecognizer:Gesture];
}

-(void)setDefaultHeight:(CGFloat)defaultHeight{
    
    _defaultHeight = defaultHeight;
    self.bgView.frame = CGRectMake(0, SCREEN.height, SCREEN.width, _defaultHeight);
    _pickerView.frame=CGRectMake(0, _topHeight, SCREEN.width, _bgView.height - _topHeight);
}
    
-(void)setTopHeight:(CGFloat)topHeight{
    
    _topHeight = topHeight;
    self.topView.height = _topHeight;
    _pickerView.frame=CGRectMake(0, _topHeight, SCREEN.width, _bgView.height - _topHeight);
    _cancelBtn.height = _topHeight;
    _completeBtn.height = _topHeight;
}
    
-(void)setTopColor:(UIColor *)topColor{
    
    _topColor = topColor;
    self.topView.backgroundColor = _topColor;
}
    
//获取省级数据
-(void)getProvinceData:(NSArray*)array{
    
    [self.provinceMarr removeAllObjects];
    if (array.count > 0){
        for (NSDictionary *dict in array) {
            ProvinceModel *provinceModel = [ProvinceModel yy_modelWithDictionary:dict];
            [self.provinceMarr addObject:provinceModel];
        }
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
    }else{
        [self.countyMarr removeAllObjects];
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
    }
}

#pragma mark 显示已选择的
-(void)showSelectProvinceId:(NSString*)provinceId cityId:(NSString*)cityId countyId:(NSString*)countyId{
    
    NSUInteger index1 = 0;
    NSUInteger index2 = 0;
    NSUInteger index3 = 0;
    
    self.provinceStr = @"";
    self.provinceIDStr = @"";
    
    self.cityStr = @"";
    self.cityIDStr = @"";
    
    self.districtStr = @"";
    self.districtIDStr = @"";
    
    //第一个区
    for (ProvinceModel *model in self.provinceMarr) {
        if ([model.adcode isEqualToString:provinceId]) {
            index1 = [self.provinceMarr indexOfObject:model];
            break;
        }
    }
    
    //第二个区
    if (self.provinceMarr.count > 0) {
        ProvinceModel *pModel = self.provinceMarr[index1];
        [self getCityData:pModel.districts];
        for (CityModel *cModel in self.cityMarr) {
            if ([cModel.adcode isEqualToString:cityId]) {
                index2 = [self.cityMarr indexOfObject:cModel];
                break;
            }
        }
    }
    
    //第二个区
    if (self.cityMarr.count > 0) {
        
        CityModel *cModel = self.cityMarr[index2];
        [self getcountyData:cModel.districts];
        for (CountyModel *districtModel in self.countyMarr) {
            if ([districtModel.adcode isEqualToString:countyId]) {
                index3 = [self.countyMarr indexOfObject:districtModel];
                break;
            }
        }
    }

    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:index1 inComponent:0 animated:NO];
    [self.pickerView selectRow:index2 inComponent:1 animated:NO];
    [self.pickerView selectRow:index3 inComponent:2 animated:NO];
    
    
    if (self.provinceMarr.count > 0) {
        ProvinceModel *sheng = [self.provinceMarr objectAtIndex:index1];
        self.provinceStr = sheng.name;
        self.provinceIDStr = sheng.adcode;
    }
    
    if (self.cityMarr.count > 0) {
        CityModel *shi = [self.cityMarr objectAtIndex:index2];
        self.cityStr = shi.name;
        self.cityIDStr = shi.adcode;
    }
    
    if (self.countyMarr.count > 0) {
        CountyModel *xian=[self.countyMarr objectAtIndex:index3];
        self.districtStr=xian.name;
        self.districtIDStr = xian.adcode;
    }
    
    self.resultsStr=[NSString stringWithFormat:@"%@ %@ %@",self.provinceStr,self.cityStr,self.districtStr];
    self.localIDStr = [NSString stringWithFormat:@"%@|%@|%@",self.provinceIDStr,self.cityIDStr,self.districtIDStr];
}


//  设置对应的字体大小
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, (SCREEN.width-30)/3,40)];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    label.text=[self pickerView:pickerView titleForRow:row forComponent:component]; // 数据源
    return label;
}

-(void)btnClicked:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        [self dismis];
    } else {
        if (self.addressBlock) {
            self.addressBlock(self.resultsStr, self.localIDStr);
             [self dismis];
        }
    }
}
- (void)Action:(UITapGestureRecognizer *)tap{
    [self dismis];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
//多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger result=0;
    if (component == 0) {
        result= _provinceMarr.count;
    }else if (component== 1){
        if (self.cityMarr.count > 0) {
            result= _cityMarr.count;
        }
    }else if (component== 2){
        if (self.countyMarr.count > 0) {
            result= _countyMarr.count;
        }
    }
    
    return result;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString * title = nil;
    
    if (component ==0 ) {
        ProvinceModel * prModel = _provinceMarr[row];
        title = prModel.name;

    }else if (component== 1){
        
        if (_cityMarr.count > 0) {
            CityModel * cModel = _cityMarr[row];
            title = cModel.name;
        }
        
    }else if (component== 2){
        
        if (_countyMarr.count > 0) {
            CountyModel * disModel = _countyMarr[row];
            title = disModel.name;
        }
        
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //滚动一区的时候
    if (component==0) {
        
        ProvinceModel *pModel = self.provinceMarr[row];
        
        //市
        [self getCityData:pModel.districts];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        //区
        if (self.cityMarr.count > 0) {
            CityModel *cModel = self.cityMarr[0];
            [self getcountyData:cModel.districts];
        }
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
      //滚动二区的时候
    } else if (component==1) {
        
        if (self.cityMarr.count > 0) {
            CityModel *cModel = self.cityMarr[row];
            [self getcountyData:cModel.districts];
        }
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    [self setModelComponent:component Row:row];
}

- (void)setModelComponent:(NSInteger)component Row:(NSInteger)row {
    if (component == 0) {
        
        //省
        ProvinceModel *Prmodel = self.provinceMarr[row];
        self.provinceStr = Prmodel.name;
        self.provinceIDStr = Prmodel.adcode;
        //市
        if (self.cityMarr.count > 0) {
            CityModel *cModel = self.cityMarr.firstObject;
            self.cityStr = cModel.name;
            self.cityIDStr = cModel.adcode;
        }else{
            self.cityStr = @"";
            self.cityIDStr = @"";
        }
        //县
        if (self.countyMarr.count > 0) {
            CountyModel *coModel = self.countyMarr.firstObject;
            self.districtStr= coModel.name;
            self.districtIDStr = coModel.adcode;
        }else{
            self.districtStr= @"";
            self.districtIDStr = @"";
        }
        
    } else if (component==1) {
        
        //市
        if (self.cityMarr.count > 0) {
            CityModel * ciModel = self.cityMarr[row];
            self.cityStr=ciModel.name;
            self.cityIDStr = ciModel.adcode;
        }else{
            self.cityStr = @"";
            self.cityIDStr = @"";
        }
        //县
        if (self.countyMarr.count > 0) {
            CountyModel *coModel = self.countyMarr.firstObject;
            self.districtStr = coModel.name;
            self.districtIDStr = coModel.adcode;
        }else{
            self.districtStr = @"";
            self.districtIDStr = @"";
        }
        
    } else {
        //县
        if (self.countyMarr.count > 0) {
            CountyModel *coModel = self.countyMarr[row];
            self.districtStr = coModel.name;
            self.districtIDStr = coModel.adcode;
        }else{
            self.districtStr = @"";
            self.districtIDStr = @"";
        }
    }
    self.resultsStr=[NSString stringWithFormat:@"%@ %@ %@",self.provinceStr,self.cityStr,self.districtStr];
    self.localIDStr = [NSString stringWithFormat:@"%@|%@|%@",self.provinceIDStr,self.cityIDStr,self.districtIDStr];
}
- (void)show {
    
    self.frame=[UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.35 animations:^{
        self.bgView.y = SCREEN.height-self.bgView.height;
    }];
}
- (void)dismis {
    [UIView animateWithDuration:0.35 animations:^{
        self.bgView.y = SCREEN.height;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

//懒加载
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

