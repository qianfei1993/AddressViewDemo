//
//  RootViewController.m
//  AddressViewDemo
//
//  Created by damai on 2019/1/7.
//  Copyright © 2019 personal. All rights reserved.
//

#import "RootViewController.h"
#import "CityViewController.h"
@interface RootViewController ()
@property (nonatomic, strong) CityViewController *cityCtrl;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.cityCtrl = [[CityViewController alloc]init];
    self.cityCtrl.selectString = ^(NSString *string, NSString *strID) {
        NSLog(@"string = %@\nstrID = %@",string,strID);
        [weakSelf.cityButton setTitle:string forState:UIControlStateNormal];
    };
}

- (IBAction)cityListViewAction:(UIButton *)sender {
    [self presentViewController:self.cityCtrl animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
