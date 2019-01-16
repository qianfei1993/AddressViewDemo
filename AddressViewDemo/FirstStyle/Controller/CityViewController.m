//
//  CityViewController.m
//  AddressViewDemo
//
//  Created by damai on 2019/1/7.
//  Copyright © 2019 personal. All rights reserved.
//

#import "CityViewController.h"
#import "CustomSearchView.h"
#import "ResultCityController.h"
#import "CityTableViewCell.h"
#import "BMChineseSort.h"
#import "SystemLocationTool.h"
@interface CityViewController ()<CustomSearchViewDelegate,ResultCityControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHieghtConstraint;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) CustomSearchView *searchView; //searchBar所在的view
@property (nonatomic,retain)UIView *blackView; //输入框编辑时的黑色背景view
@property (nonatomic,retain)NSMutableArray *sectionTitlesArray; // 区头数组
@property (nonatomic,retain)NSMutableArray *rightIndexArray; // 右边索引数组
@property (nonatomic,retain)NSMutableArray *dataArray;// cell数据源数组
@property (nonatomic,retain)NSMutableArray *searchArray;// 用于搜索的数组
@property (nonatomic,retain)ResultCityController *resultController;//显示结果的controller
@property (nonatomic,retain)NSArray *locationCityArray;// 定位城市
@property (nonatomic,retain)NSArray *hotCityArray; // 热门城市
@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self initWithTableView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.navHieghtConstraint.constant = kNavBarHeight;
}

- (void)initWithTableView{
    
    self.title = @"选择城市";
    self.searchView = [[CustomSearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    _searchView.delegate = self;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView  = _searchView;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexColor = [UIColor blueColor];
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

#pragma mark --UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.sectionTitlesArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section < 2){
        return 1;
    }else{
        return [self.dataArray[section] count];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *HeaderIdentifier = @"header";
    UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if( headerView == nil){
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderIdentifier];
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 25)];
        titleLabel.tag = 1;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
        [headerView.contentView addSubview:titleLabel];
    }
    headerView.contentView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    UILabel *label = (UILabel *)[headerView viewWithTag:1];
    label.text = self.sectionTitlesArray[section];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){
        return 60;
    }else if (indexPath.section==1){
        return 105;
    }else{
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section<2){
        __weak typeof(self) weakSelf = self;
        CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
        if(cell==nil){
            cell = [[CityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityCell" cityArray:self.dataArray[indexPath.section]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.didSelectedBtn = ^(int tag){
            if(tag==99999){
                weakSelf.selectString(weakSelf.currentCityString,@"定位无code");
            }else{
                
                NSDictionary *dict = self.hotCityArray[tag];
                NSString *cityStr = [NSString stringWithFormat:@"%@",dict[@"name"]];
                NSString *codeStr = [NSString stringWithFormat:@"%@",dict[@"adcode"]];
                weakSelf.selectString(cityStr,codeStr);
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        NSArray *array = self.dataArray[indexPath.section];
        NSDictionary *dict = array[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    for (UIView *view in [tableView subviews]) {
        if ([view isKindOfClass:[NSClassFromString(@"UITableViewIndex") class]]) {
            // 设置字体大小
            [view setValue:kFont(16) forKey:@"_font"];
            //设置view的大小
            view.bounds = CGRectMake(0, 0, 30, 40);
        }
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{

    if(_blackView){
        return nil;
    }else{
        return self.rightIndexArray;
    }
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    //此方法返回的是section的值
    if(index==0){
        [tableView setContentOffset:CGPointZero animated:YES];
        return -1;
    }else{
        return index+1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if(indexPath.section > 1){
        NSDictionary *dict = self.dataArray[indexPath.section][indexPath.row];
        NSString *cityStr = [NSString stringWithFormat:@"%@",dict[@"name"]];
        NSString *cityCode = [NSString stringWithFormat:@"%@",dict[@"adcode"]];
        self.selectString(cityStr,cityCode);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark --CustomSearchViewDelegate
// 开始输入
-(void)searchBeginEditing{
    
    [self.view addSubview:_blackView];
    [UIView animateWithDuration:0.15 animations:^{
        self.blackView.alpha = 0.6;
    }];
}

// 点击取消
-(void)didSelectCancelBtn{
    
    UIView *view1 = (UIView *)[self.view viewWithTag:333];
    [view1 removeFromSuperview];
    [_blackView removeFromSuperview];
    _blackView = nil;
    [self.resultController.view removeFromSuperview];
    self.resultController=nil;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.15 animations:^{
        weakSelf.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight-kNavBarHeight);
        self.searchView.searchBar.text = nil;
        [self.searchView.searchBar setShowsCancelButton:NO animated:YES];
        [self.searchView.searchBar resignFirstResponder];
    }];
}

// 实时搜索
-(void)searchString:(NSString *)string{
    
    //”^[A-Za-z]+$”
    NSMutableArray *resultArray  =  [NSMutableArray array];
    //证明输入的是汉字
    [self.searchArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K CONTAINS[c] %@",@"name",string];
        NSArray *array = [obj filteredArrayUsingPredicate:pred];
        [resultArray addObjectsFromArray:array];
    }];
    self.resultController.dataArray = resultArray;
    [self.resultController.tableView reloadData];
}

#pragma mark --ResultCityControllerDelegate
-(void)didScroll{
    [self.searchView.searchBar resignFirstResponder];
    UIButton *cancelBtn = [self.searchView.searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    cancelBtn.enabled = YES; //把enabled设置为yes
}

-(void)didSelectedString:(NSString *)string :(NSString *)strID{
    
    self.selectString(string,strID);
    [self didSelectCancelBtn];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//加载城市列表数据
-(void)loadData{
   
    kWeakSelf(self);
    //获取数据
    NSError *error;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"json"];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:&error];
    NSArray *resultArr = [jsonDic objectForKey:@"districts"];
    NSMutableArray *totalArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < resultArr.count ; i++) {
        NSDictionary *provinceDict = resultArr[i];
        [totalArr addObject:provinceDict];
        NSArray *cityArray = provinceDict[@"districts"];
        if (cityArray.count > 0) {
            for (int j = 0; j < cityArray.count ; j++) {
                NSDictionary *cityDict = cityArray[j];
                [totalArr addObject:cityDict];
                NSArray *countyArr = cityDict[@"districts"];
                if (countyArr.count > 0) {
                    for (int k = 0; k < countyArr.count; k++) {
                        NSDictionary *countyDict = countyArr[k];
                        [totalArr addObject:countyDict];
                    }
                }
            }
        }
    }
    
    //格式化
    NSMutableArray *formatArr = [[NSMutableArray alloc]init];
    for (int m = 0; m < totalArr.count; m++) {
        NSDictionary *dict = totalArr[m];
        NSMutableDictionary *mdict = [dict mutableCopy];
        [mdict removeObjectForKey:@"districts"];
        [formatArr addObject:[mdict copy]];
    }
    //NSArray *modelArr = [NSArray yy_modelArrayWithClass:[CityModel class] json:formatArr];
    
    self.rightIndexArray = [NSMutableArray array];
    self.sectionTitlesArray = [NSMutableArray array]; //区头字母数组
    self.dataArray = [NSMutableArray array]; //包含所有区数组的大数组
    self.searchArray = [NSMutableArray array];
    
    [BMChineseSort sortAndGroup:formatArr key:@"name" finish:^(bool isSuccess, NSMutableArray *unGroupArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
        if (isSuccess) {
            self.searchArray = [NSMutableArray arrayWithArray:sortedObjArr];
            self.sectionTitlesArray = [NSMutableArray arrayWithArray:sectionTitleArr];
            
            self.dataArray = [NSMutableArray arrayWithArray:self.searchArray];
            [self.rightIndexArray addObjectsFromArray:self.sectionTitlesArray];
            [self.rightIndexArray insertObject:UITableViewIndexSearch atIndex:0];
            [self.sectionTitlesArray insertObject:@"热门城市" atIndex:0];
            [self.sectionTitlesArray insertObject:@"定位城市" atIndex:0];
            
            self.currentCityString = @"定位中...";
            self.locationCityArray = @[@{@"name":self.currentCityString,@"adcode":@"adcode"}];
            self.hotCityArray = @[@{@"name":@"西安",@"adcode":@"adcode"},
                                  @{@"name":@"北京",@"adcode":@"adcode"},
                                  @{@"name":@"郑州",@"adcode":@"adcode"},
                                  @{@"name":@"太原",@"adcode":@"adcode"},
                                  @{@"name":@"成都",@"adcode":@"adcode"},
                                  @{@"name":@"兰州",@"adcode":@"adcode"}];
            [self.dataArray insertObject:self.hotCityArray atIndex:0];
            [self.dataArray insertObject:self.locationCityArray atIndex:0];
            [weakself.tableView reloadData];
            [self getLocation];
        }else{
        }
    }];
//    self.sectionTitlesArray = [BMChineseSort IndexWithArray:formatArr Key:@"name"];
//    self.searchArray = [BMChineseSort sortObjectArray:formatArr Key:@"name"];
}

- (void)getLocation{
    
    __weak typeof(self) weakSelf = self;
    [[SystemLocationTool sharedInstance]getLocationViewController:self Placemark:^(CLPlacemark *placemark) {
        
        weakSelf.currentCityString = [NSString stringWithFormat:@"%@",placemark.locality];
        self.locationCityArray = @[@{@"name":weakSelf.currentCityString,@"adcode":@"adcode"}];
        [self.dataArray replaceObjectAtIndex:0 withObject:self.locationCityArray];
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    } didFailWithError:^(NSError *error) {
        
        weakSelf.currentCityString = @"定位失败";
        self.locationCityArray = @[@{@"name":self.currentCityString,@"adcode":@"adcode"}];
        [self.dataArray replaceObjectAtIndex:0 withObject:self.locationCityArray];
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

// 返回事件
- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 蒙版视图
-(UIView *)blackView{
    
    if(!_blackView){
        _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+44, kScreenWidth, kScreenHeight-kNavBarHeight-44)];
        _blackView.backgroundColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.6];
        _blackView.alpha = 0;
        [self.view addSubview:_blackView];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectCancelBtn)];
        [_blackView addGestureRecognizer:ges];
    }
    return _blackView;
}

// 搜索结果视图
-(ResultCityController *)resultController{
    
    if(!_resultController){
        _resultController = [[ResultCityController alloc] init];
        
        _resultController.view.frame = CGRectMake(0, kNavBarHeight+44, kScreenWidth, kScreenHeight-kNavBarHeight-44);
        _resultController.delegate = self;
        [self.view addSubview:_resultController.view];
    }
    return _resultController;
}
@end
