//
//  CreateData.h
//  Track-Playing
//
//  Created by coco船长 on 16/6/30.
//  Copyright © 2016年 nevermore. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 此方法，使用类方法，返回一个测试轨迹信息的数组，而具体情况得在开发的具体判断返回。
@interface CreateData : NSObject

+ (NSArray *)createTestData;

@end
