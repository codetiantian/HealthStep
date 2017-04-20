//
//  ViewController.m
//  StepDemo
//
//  Created by 这个夏天有点冷 on 2017/4/20.
//  Copyright © 2017年 YLT. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "HealthManager.h"

@interface ViewController ()

@property (strong, nonatomic) CMPedometer *perdometer;

@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self initRecordRun];
    
    [self getCurrentStep];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCurrentStep
{
    __weak typeof(self) ws = self;
    [[HealthManager shareInstance] getRealTimeStepCountCompletionHandler:^(double value, NSError *error) {
        
        if (value == 0) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请打开健康允许访问步数" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:sureAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        ws.stepLabel.text = [NSString stringWithFormat:@"%i", (int)value];
    }];
}

- (void)initRecordRun
{
    self.perdometer = [[CMPedometer alloc] init];
    
    NSDate *startDate = [self getStartTime];
    NSDate *endDate = [self getEndTime];
    
    //  判断功能
    if ([CMPedometer isStepCountingAvailable]) {
        __weak typeof(self) ws = self;
        [self.perdometer queryPedometerDataFromDate:startDate toDate:endDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            if (error) {
                NSLog(@"--%@", error);
            } else {
                NSLog(@"开始时间为：%@", startDate);
                NSLog(@"结束时间为：%@", endDate);
                
                NSLog(@"步数为：%@", pedometerData.numberOfSteps);
                NSLog(@"距离为：%@", pedometerData.distance);
                
                ws.stepLabel.text = [NSString stringWithFormat:@"%@", pedometerData.numberOfSteps];
                ws.distanceLabel.text = [NSString stringWithFormat:@"%@", pedometerData.distance];
            }
        }];
    } else {
        NSLog(@"记步功能不可用");
    }
}

- (NSDate *)getEndTime
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"GMT+0800"];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    return [date dateByAddingTimeInterval:interval];
}

- (NSDate *)getStartTime
{
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    dataFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *stringDate = [dataFormatter stringFromDate:[self getEndTime]];
    NSLog(@"当天日期为：%@", stringDate);
    
    NSDate *tDate = [dataFormatter dateFromString:stringDate];
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"GMT+0800"];
    NSInteger interval = [zone secondsFromGMTForDate:tDate];
    
    return [tDate dateByAddingTimeInterval:interval];
}

@end
