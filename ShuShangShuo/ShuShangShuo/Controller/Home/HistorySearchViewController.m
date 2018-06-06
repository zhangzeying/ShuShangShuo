//
//  SearchViewController.m
//  ShuShangShuo
//
//  Created by zhangzey on 05/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "HistorySearchViewController.h"

// ----垂直的距离----
#define distanceV 9
// ----水平间距----
#define distanceH 13

@interface HistorySearchViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UILabel *historySearchLbl;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIView *containerView;
@property(nonatomic,copy)NSString *historyFilePath;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy)NSString *keyword;

@end

@implementation HistorySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"333333"]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(14), NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.titleView = self.searchBar;
    self.historyFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kSearchHistoryFileName]; //历史搜索缓存路径
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.historySearchLbl];
    [self.view addSubview:self.clearBtn];
    [self.view addSubview:self.containerView];
    NSInteger row = 0; //记录行数
    CGFloat lastBtnMaxX = 0;
    CGFloat btnH = 25;
    NSMutableArray *array = (NSMutableArray *)[[self.dataArr reverseObjectEnumerator]allObjects];
    for (int i = 0; i < array.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = Font(12);
        [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithHexString:@"fff"];
        btn.layer.borderWidth = 1.f;
        btn.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
        btn.layer.cornerRadius = 10;
        [btn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"search_btn_bg"] forState:UIControlStateNormal];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn sizeToFit];
        CGFloat btnW = MAX(btn.frame.size.width + 5, 60);
        CGFloat btnX = 0;
        if (i > 0) {
            btnX = lastBtnMaxX + distanceH;
        }
        //换行
        if (btnX + btnW > (ScreenWidth - 15 * 2)) {
            
            row++; //行数加一
            btnX = 0;
        }
        
        lastBtnMaxX = btnX + btnW;
        
        CGFloat btnY = row * (distanceV + btnH);
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [self.containerView addSubview:btn];
    }
    
    self.containerView.frame = CGRectMake(15, self.historySearchLbl.bottom + 20, ScreenWidth - 15 * 2, row * (btnH + distanceV));
}

/**
 * 更新数据
 */
- (void)updateHistoryData {
    
    //替换多个空格为一个空格
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"\\s+"
                                                                 options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];
    self.keyword = [regular stringByReplacingMatchesInString:_keyword options:0 range:NSMakeRange(0, [_keyword length]) withTemplate:@" "];
    
    
    //搜索历史去重
    for (NSString *str in self.dataArr) {
        
        if ([self.keyword isEqualToString:str]) {
            
            [self.dataArr removeObject:str];
            break;
        }
    }
    
    if (self.dataArr.count >= 10) {
        
        [self.dataArr removeObjectAtIndex:0];
        [self.dataArr addObject:self.keyword];
    }else {
        
        [self.dataArr addObject:self.keyword];
    }
    
    [self.dataArr writeToFile:self.historyFilePath atomically:YES];
}

- (void)search {
    [self.searchBar resignFirstResponder];
    self.keyword = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self updateHistoryData];
}

#pragma mark - getter and setter
- (NSMutableArray *)dataArr {
    if(!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithContentsOfFile:self.historyFilePath];
        if (!_dataArr) {
            _dataArr = [NSMutableArray array];
        }
    }
    return _dataArr;
}

- (UISearchBar *)searchBar {
    if(!_searchBar) {
        [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_bg"] forState:UIControlStateNormal];
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 0, ScreenWidth - 40 * 2, 44)];
        UIOffset offect = {10, 0};
        _searchBar.searchTextPositionAdjustment = offect;
        _searchBar.placeholder = @"请输入本地搜索关键字";
        _searchBar.tintColor = [UIColor colorWithHexString:@"BEBEBE"];
//        _searchBar.delegate = self;
        [_searchBar setBackgroundImage:[[UIImage alloc] init]];
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        searchField.leftView = nil;
        [searchField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        [searchField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"font"];
    }
    return _searchBar;
}

- (UILabel *)historySearchLbl {
    if(!_historySearchLbl) {
        _historySearchLbl = [[UILabel alloc]init];
        _historySearchLbl.font = Font(12);
        _historySearchLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _historySearchLbl.text = @"历史搜索";
        [_historySearchLbl sizeToFit];
        _historySearchLbl.frame = CGRectMake(15, kNavigationBarHeight + 40, _historySearchLbl.width, _historySearchLbl.height);
    }
    return _historySearchLbl;
}

- (UIButton *)clearBtn {
    if(!_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBtn setImage:IMAGENAMED(@"trash") forState:UIControlStateNormal];
        [_clearBtn setTitle:@"清空" forState:UIControlStateNormal];
        [_clearBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _clearBtn.titleLabel.font = Font(12);
        _clearBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 5, 0, 0);
        _clearBtn.frame = CGRectMake(ScreenWidth - 45 - 15, 0, 45, 40);
        _clearBtn.centerY = self.historySearchLbl.centerY;
    }
    return _clearBtn;
}

- (UIView *)containerView {
    if(!_containerView) {
        _containerView = [[UIView alloc]init];
    }
    return _containerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
