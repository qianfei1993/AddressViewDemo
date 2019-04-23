//
//  LoopImageViewController.h
//  Common
//
//  Created by damai on 2018/9/13.
//  Copyright © 2018年 damai. All rights reserved.
//
#import "FoldCityViewController.h"
#import "Masonry.h"
#import "CustomSearchView.h"
#import "SecondData.h"
#import "FoldCityTableViewCell.h"
#import "BMChineseSort.h"
#import "UITableView+SCIndexView.h"


@interface FoldCityViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,CustomSearchViewDelegate>

@property (nonatomic ,assign)BOOL isSearch;
@property (weak, nonatomic) IBOutlet UIView *searchBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) CustomSearchView *searchView;
@property (nonatomic, strong) NSMutableArray *clickArr;
@property (nonatomic,retain)NSMutableArray *sectionTitlesArray; // 区头数组
@property (nonatomic,retain)NSMutableArray *rightIndexArray; // 右边索引数组
@property (nonatomic,retain)NSMutableArray *dataArray;// cell数据源数组
@property (nonatomic,retain)NSMutableArray *searchResultArray;//搜索结果的数组
@property (nonatomic,retain)NSMutableArray *searchArray;//用于搜索的数组
@property (nonatomic,retain)NSMutableArray *currentCityArr;// 当前城市
@property (nonatomic,retain)NSArray *historyCityArr;// 历史城市
@end

@implementation FoldCityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSearch = NO;
    [self initArray];
    [self loadData];
    [self initWithSearchView];
    [self initWithTableView];
}
- (void)initWithSearchView{

   self.view.backgroundColor = [UIColor whiteColor];
   _searchView = [[CustomSearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
   _searchView.delegate = self;
   [self.searchBgView addSubview:_searchView];
}

- (void)initWithTableView{
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navHeightConstraint.constant = kNavBarHeight;
    self.tableView.backgroundColor = kRGBA(245, 245, 245, 1.0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:kLoadNib(@"FoldCityTableViewCell") forCellReuseIdentifier:@"FoldCityTableViewCellID"];
   // 配置索引
   SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configuration];
   configuration.isGenerator = YES;
   configuration.indexViewStyle = SCIndexViewStyleNone;
   configuration.indexItemRightMargin = 16;
   configuration.indexItemHeight = 16;
   _tableView.sc_indexViewConfiguration = configuration;
   _tableView.sc_translucentForTableViewInNavigationBar = NO;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataArray[section];
    return array.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FoldCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoldCityTableViewCellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 获取选择城市
    kWeakSelf(self);
    cell.nameBlock = ^(NSString *cityName, NSString *areaName) {
        if ([areaName containsString:@"定位"]) {
            [self loadData];
        }else{
            [weakself dismissViewControllerAnimated:YES completion:^{
                if (self.selectCityBlock) {
                    self.selectCityBlock(cityName, areaName);
                }
            }];
        }
    };
    
    if ([self.clickArr containsObject:indexPath]) {
        cell.titleButton.selected = YES;
    }else{
        cell.titleButton.selected = NO;
    }
    cell.dict = self.dataArray[indexPath.section][indexPath.row];
    cell.block = ^(UIButton *button) {
        UIView *v = [button superview];//获取父类view
        FoldCityTableViewCell *btncell = (FoldCityTableViewCell *)[v superview];//获取cell
        NSIndexPath *indexPathAll = [tableView indexPathForCell:btncell];//获取cell对应的section
        if (!button.selected) {
            [self.clickArr addObject:indexPathAll];
        }else{
            [self.clickArr removeObject:indexPathAll];
        }
        NSIndexPath *toReload = [NSIndexPath indexPathForRow:indexPathAll.row inSection:indexPathAll.section];
        [tableView reloadRowsAtIndexPaths:@[toReload] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    if (self.isSearch == NO) {
        
        NSInteger section = kISNullArray(self.historyCityArr) ? 2 : 3;
        if (indexPath.section < section) {
            cell.contentView.backgroundColor = kRGBA(245, 245, 245, 1.0);
            cell.cityCollectionView.backgroundColor = kRGBA(245, 245, 245, 1.0);
            [cell.titleButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            cell.titleButton.hidden = YES;
            [cell.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            [cell.cityCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.top.mas_equalTo(0);
                make.right.mas_equalTo(-31);
                make.bottom.mas_equalTo(0);
            }];
        }else{
            cell.titleButton.tag = indexPath.row + 888;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.cityCollectionView.backgroundColor = [UIColor whiteColor];
            [cell.titleButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(49);
            }];
            cell.titleButton.hidden = NO;
            [cell.cityCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.top.mas_equalTo(49);
                make.right.mas_equalTo(-31);
                make.bottom.mas_equalTo(-6);
            }];
            [cell.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(1);
            }];
        }
    }else{
        cell.titleButton.tag = indexPath.row + 888;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.cityCollectionView.backgroundColor = [UIColor whiteColor];
        [cell.titleButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(49);
        }];
        cell.titleButton.hidden = NO;
        [cell.cityCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(49);
            make.right.mas_equalTo(-31);
            make.bottom.mas_equalTo(-6);
        }];
        [cell.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = self.dataArray[indexPath.section][indexPath.row];
    NSArray *arr = dict[@"districts"];
    if (self.isSearch == NO) {
        NSInteger section = kISNullArray(self.historyCityArr) ? 2 : 3;
        if (indexPath.section < section) {
            return [SecondData tableViewCellHeight:arr];
        }
        if ([self.clickArr containsObject:indexPath]) {
            return [SecondData tableViewCellHeight:arr]+50;
        }else{
            return 50;
        }
    }else{
        if ([self.clickArr containsObject:indexPath]) {
            return [SecondData tableViewCellHeight:arr]+50;
        }else{
            return 50;
        }
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *HeaderIdentifier = @"header";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if( headerView == nil){
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderIdentifier];
        headerView.frame = CGRectMake(0, 0, kScreenWidth, 28);
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 28)];
        titleLabel.tag = 1;
        titleLabel.textColor = [UIColor blackColor];
        [headerView.contentView addSubview:titleLabel];
    }
    headerView.contentView.backgroundColor = kRGBA(245, 245, 245, 1.0);
    UILabel *label = (UILabel *)[headerView viewWithTag:1];
    label.text = self.sectionTitlesArray[section];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
   UIButton *cancelBtn = [self.searchView.searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
   cancelBtn.enabled = YES; //把enabled设置为yes
}

// 搜索
#pragma mark --CustomSearchViewDelegate
// 开始输入
-(void)searchBeginEditing{
   
}

// 点击取消
-(void)didSelectCancelBtn{
   self.isSearch = NO;
   [self.dataArray removeAllObjects];
   [self.sectionTitlesArray removeAllObjects];
   [self loadData];
}

// 实时搜索
-(void)searchString:(NSString *)string{
   
   if (!kISNullString(string)) {
      
      self.isSearch = YES;
      [self.clickArr removeAllObjects];
      [self.dataArray removeAllObjects];
      [self.sectionTitlesArray removeAllObjects];
      [self.searchResultArray removeAllObjects];
      [self.rightIndexArray removeAllObjects];
      
      // 判断是不是拼音
      if ([SecondData isLetter:string]) {
         // 证明输入的是拼音
         [self.searchArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSArray *arr = obj;
            NSMutableArray *mulArr = [NSMutableArray array];
            for (NSDictionary *dict in arr) {
               NSString *name = dict[@"name"];
               NSString *pinyin = [BMChineseSort transformChinese:name];
               NSMutableDictionary *mulDict = dict.mutableCopy;
               [mulDict setObject:pinyin forKey:@"pingyin"];
               [mulArr addObject:mulDict];
            }
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K CONTAINS[c] %@",@"pingyin",string];
            NSArray *array = [mulArr filteredArrayUsingPredicate:pred];
            [self.searchResultArray addObjectsFromArray:array];
         }];
      }else{
         
         //证明输入的不是拼音
         [self.searchArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K CONTAINS[c] %@",@"name",string];
            NSArray *array = [obj filteredArrayUsingPredicate:pred];
            [self.searchResultArray addObjectsFromArray:array];
         }];
      }
      // 排序
      [BMChineseSort sortAndGroup:self.searchResultArray key:@"name" finish:^(bool isSuccess, NSMutableArray *unGroupArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
         if (isSuccess) {
            self.sectionTitlesArray = sectionTitleArr;
            self.dataArray = sortedObjArr;
            [self.rightIndexArray addObjectsFromArray:self.sectionTitlesArray];
            [self.tableView reloadData];
             self.tableView.sc_indexViewDataSource = self.rightIndexArray.copy;
         }
      }];
   }
}

// 初始化
- (void)initArray{
    
    self.clickArr = [NSMutableArray array];
   
    self.currentCityArr = [NSMutableArray array];
    self.searchResultArray = [NSMutableArray array];
    
    self.rightIndexArray = [NSMutableArray array];
   
    self.sectionTitlesArray = [NSMutableArray array]; //区头字母数组
   
    self.dataArray = [NSMutableArray array]; //包含所有区数组的大数组
    
    self.searchArray = [NSMutableArray array];
}

//加载城市列表数据
-(void)loadData{
   __weak typeof(self) weakSelf = self;
   [self.clickArr removeAllObjects];
   [self.currentCityArr removeAllObjects];
   [self.searchResultArray removeAllObjects];
    
   [self.rightIndexArray removeAllObjects];
   [self.sectionTitlesArray removeAllObjects]; //区头字母数组
   [self.dataArray removeAllObjects]; //包含所有区数组的大数组
   [self.searchArray removeAllObjects];
   
   // 读取缓存(历史城市)
   self.historyCityArr = [SecondData getHistoryCity];
   // 获取json数据
   NSArray *jsonDataArr = [SecondData loadJson:@"area"];
   // 获取排序数据()
   [BMChineseSort sortAndGroup:jsonDataArr key:@"name" finish:^(bool isSuccess, NSMutableArray *unGroupArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
      if (isSuccess) {
         self.sectionTitlesArray = sectionTitleArr;
         self.searchArray = sortedObjArr;
         self.dataArray = [NSMutableArray arrayWithArray:self.searchArray];
         [self.rightIndexArray addObjectsFromArray:self.sectionTitlesArray];
         
         // 构造右标数据
         [self.rightIndexArray insertObject:@"热门" atIndex:0];
         if (!kISNullArray(self.historyCityArr)) {
            [self.rightIndexArray insertObject:@"历史" atIndex:0];
         }
         [self.rightIndexArray insertObject:@"定位" atIndex:0];
         // 构造组头数据
         [self.sectionTitlesArray insertObject:@"热门城市" atIndex:0];
         if (!kISNullArray(self.historyCityArr)) {
            [self.sectionTitlesArray insertObject:@"历史访问城市" atIndex:0];
         }
         [self.sectionTitlesArray insertObject:@"定位城市" atIndex:0];
         // 构造显示数据
         // 插入热门城市数据
         [self.dataArray insertObject:[SecondData getHotCity] atIndex:0];
         // 插入历史访问城市
         if (!kISNullArray(self.historyCityArr)) {
            [self.dataArray insertObject:self.historyCityArr atIndex:0];
         }
         // 插入定位城市
         NSArray *locationArr = [SecondData getLocation:self :^{
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
         }];
         [self.dataArray insertObject:locationArr atIndex:0];
         [self.tableView reloadData];
         self.tableView.sc_indexViewDataSource = self.rightIndexArray.copy;
      }
   }];
}

// 返回
- (IBAction)backAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
