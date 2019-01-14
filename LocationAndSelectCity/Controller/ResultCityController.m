//
//  ResultCityController.m
//  AddressViewDemo
//
//  Created by damai on 2019/1/7.
//  Copyright © 2019 personal. All rights reserved.
//

#import "ResultCityController.h"
@interface ResultCityController()
@end

@implementation ResultCityController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"Cell"] ;
    }
    // 一般我们就可以在这开始设置这个cell了，比如设置文字等：
    cell.textLabel.text = _dataArray[indexPath.row][@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = _dataArray[indexPath.row];
    NSString *cityStr = [NSString stringWithFormat:@"%@",dict[@"name"]];
    NSString *cityCode = [NSString stringWithFormat:@"%@",dict[@"adcode"]];
    if([_delegate respondsToSelector:@selector(didSelectedString::)]){
        [_delegate didSelectedString:cityStr :cityCode];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
   if([_delegate respondsToSelector:@selector(didScroll)]){
       [_delegate didScroll];
   }
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
