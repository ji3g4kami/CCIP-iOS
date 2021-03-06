//
//  ScheduleViewController.m
//  CCIP
//
//  Created by FrankWu on 2017/7/15.
//  Copyright © 2017年 CPRTeam. All rights reserved.
//

#import "ScheduleViewController.h"
#import "AppDelegate.h"
#import "ScheduleTableViewCell.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    [lbTitle setTextColor:[UIColor whiteColor]];
    [lbTitle setText:NSLocalizedString(@"ScheduleTitle", nil)];
    [self.navigationItem setTitleView:lbTitle];
    [self.navigationItem setTitle:@""];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];

    
    NSDictionary *titleAttribute = @{
                                     NSFontAttributeName: [Constants fontOfAwesomeWithSize:20 inStyle:fontAwesomeStyleSolid],
                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                     };
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:[Constants fontAwesomeWithCode:@"fa-heart"] attributes:titleAttribute];

    UIButton *favButton = [UIButton new];
    [favButton setAttributedTitle:title
                         forState:UIControlStateNormal];
    [favButton addTarget:self
                  action:@selector(showFavoritesTouchDown)
        forControlEvents:UIControlEventTouchDown];
    [favButton addTarget:self
                  action:@selector(showFavoritesTouchUpInside)
        forControlEvents:UIControlEventTouchUpInside];
    [favButton addTarget:self
                  action:@selector(showFavoritesTouchUpOutside)
        forControlEvents:UIControlEventTouchUpOutside];
    [favButton sizeToFit];
    UIBarButtonItem *favoritesButton = [[UIBarButtonItem alloc] initWithCustomView:favButton];
    [self.navigationItem setRightBarButtonItem:favoritesButton];

    NSDictionary *titleAttributeFake = @{
                                     NSFontAttributeName: [Constants fontOfAwesomeWithSize:20 inStyle:fontAwesomeStyleSolid],
                                     NSForegroundColorAttributeName: [UIColor clearColor],
                                     };
    NSAttributedString *titleFake = [[NSAttributedString alloc] initWithString:[Constants fontAwesomeWithCode:@"fa-heart"] attributes:titleAttributeFake];
    UIButton *favButtonFake = [UIButton new];
    [favButtonFake setAttributedTitle:titleFake
                             forState:UIControlStateNormal];
    [favButtonFake setTitleColor:[UIColor clearColor]
                        forState:UIControlStateNormal];
    [favButtonFake sizeToFit];
    UIBarButtonItem *favoritesButtonFake = [[UIBarButtonItem alloc] initWithCustomView:favButtonFake];
    [self.navigationItem setLeftBarButtonItem:favoritesButtonFake];
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 239);
    UIView *headView = [UIView new];
    [headView setFrame:frame];
    [headView setGradientColorFrom:[AppDelegate AppConfigColor:@"ScheduleTitleLeftColor"]
                                to:[AppDelegate AppConfigColor:@"ScheduleTitleRightColor"]
                        startPoint:CGPointMake(-.4f, .5f)
                           toPoint:CGPointMake(1, .5f)];
    [self.view addSubview:headView];
    [self.view sendSubviewToBack:headView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)showFavoritesTouchDown {
    [UIImpactFeedback triggerFeedback:UIImpactFeedbackTypeImpactFeedbackMedium];
}

- (void)showFavoritesTouchUpInside {
    [self performSegueWithIdentifier:@"ShowFavorites"
                              sender:nil];
    [UIImpactFeedback triggerFeedback:UIImpactFeedbackTypeImpactFeedbackLight];
}

- (void)showFavoritesTouchUpOutside {
    [UIImpactFeedback triggerFeedback:UIImpactFeedbackTypeImpactFeedbackLight];
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
