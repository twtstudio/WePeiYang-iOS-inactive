//
//  NewsTableViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 15/11/17.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "NewsTableViewController.h"
#import "twtSDK.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "NewsData.h"
#import "NewsTableViewCell.h"
#import "MsgDisplay.h"
#import "NewsViewController.h"

@interface NewsTableViewController ()

@end

@implementation NewsTableViewController {
    NSUInteger currentPage;
    NSMutableArray *dataArr;
}

//@synthesize delegate;
@synthesize type;

- (instancetype)init {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"NewsTableViewController"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshData];
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    currentPage = 1;
    dataArr = [[NSMutableArray alloc] init];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)] && self.navigationController.navigationBar.translucent == YES) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + MENU_VIEW_HEIGHT;
        insets.bottom = 49;
        // 同时WMPageController.m的calculateSize函数要加49
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self nextPage];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer.automaticallyHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)getData {
    [twtSDK getNewsListWithType:type page:currentPage success:^(NSURLSessionDataTask *task, id responseObject) {
        if (currentPage == 1) {
            dataArr = [NewsData mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        } else if (currentPage > 1) {
            if (((NSArray *)responseObject[@"data"]).count == 0) {
                [MsgDisplay showErrorMsg:@"已到最后一页"];
                currentPage --;
            } else {
                [dataArr addObjectsFromArray:[NewsData mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            }
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)nextPage {
    currentPage ++;
    [self getData];
}

- (void)refreshData {
    currentPage = 1;
    [self getData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = (NewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"simpleIdentifier"];
    NewsData *tmp = (NewsData *)dataArr[indexPath.row];
    [cell setNewsData:tmp];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsData *tmp = (NewsData *)dataArr[indexPath.row];
//    [delegate pushContentWithIndex:tmp.index];
    [[NSNotificationCenter defaultCenter] postNotificationName:PUSH_NOTIFICATION object:tmp];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
