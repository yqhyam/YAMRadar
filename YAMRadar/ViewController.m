//
//  ViewController.m
//  YAMRadar
//
//  Created by YaM on 2023/9/20.
//

#import "ViewController.h"
#import "GIRadarView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:10/255.0 green:27/255.0 blue:53/255.0 alpha:1];
    
    GIRadarView *radarView = [[GIRadarView alloc] initWithFrame:CGRectMake(0, 170, 375, 375)];
    [self.view addSubview:radarView];
    [radarView start];
}


@end
