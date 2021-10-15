//
//  HTMyViewController.m
//  AppProgect
//
//  Created by step_zhang on 2021/9/8.
//

#import "HTMyViewController.h"

@interface HTMyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *MyTabview;
@property(nonatomic,strong)NSMutableArray*DataSourceARR;
@end

@implementation HTMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)zw_addSubviews{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    anim.values = @[@0.8, @1, @1.2, @0.9, @1.1, @1];
    anim.duration = 0.6;
    [self.MyTabview emptyViewConfigerBlock:^(FOREmptyAssistantConfiger *configer) {
        configer.emptyTitle = @"识己-致最懂锻炼的你";
        configer.emptyTitleFont = [UIFont boldSystemFontOfSize:22];
        configer.emptySubtitle = @"亲,周末咱们一起锻炼吧~";
        configer.emptyImage = [UIImage imageNamed:@"image_empty"];
        configer.emptySpaceHeight = 20;
        configer.imageAnimation = anim;
        
    }];
    [self.view addSubview:self.MyTabview];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.DataSourceARR.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}
-(UITableView *)MyTabview{
    if (_MyTabview == nil) {
        _MyTabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - ZWTabbarHeight  - ZWTabbarSafeBottomMargin) style:UITableViewStylePlain];
        _MyTabview.dataSource = self;
        _MyTabview.delegate = self;
        _MyTabview.separatorStyle = UITableViewCellSeparatorStyleNone;
        UILabel *botmView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        botmView.textAlignment = NSTextAlignmentCenter;
        botmView.text = @"-----我们是有底线的-----";
        _MyTabview.tableFooterView = botmView;
        _MyTabview.backgroundColor = [UIColor clearColor];
        _MyTabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _MyTabview;
}
-(NSMutableArray *)DataSourceARR{
    if (_DataSourceARR == nil) {
        _DataSourceARR = [[NSMutableArray alloc]init];
    }
    return _DataSourceARR;
}
@end
