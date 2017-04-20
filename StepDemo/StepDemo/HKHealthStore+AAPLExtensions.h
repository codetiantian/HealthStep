//
//  HKHealthStore+AAPLExtensions.h
//  StepDemo
//
//  Created by 这个夏天有点冷 on 2017/4/20.
//  Copyright © 2017年 YLT. All rights reserved.
//

#import <HealthKit/HealthKit.h>

@interface HKHealthStore (AAPLExtensions)

- (void)aapl_mostRecentQuantitySampleOfType:(HKQuantityType *)quantityType predicate:(NSPredicate *)predicate completion:(void (^)(NSArray *, NSError *))completion;

@end
