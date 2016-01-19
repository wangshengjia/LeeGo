//
//  CellComponentFactory.m
//  BearBeers
//
//  Created by Victor WANG on 19/06/15.
//  Copyright (c) 2015 AllblueTechnology. All rights reserved.
//

#import "CellComponentFactory.h"

    // #import <LeeGo/LeeGo-Swift.h>

@implementation CellComponentFactory

+ (UIView *)createCellComponentFromClass:(Class)componentClass
                            componentKey:(NSString *)componentKey;
{
    NSString *classStr = NSStringFromClass(componentClass);
    UIView *view = [[NSClassFromString(classStr) alloc] init];
    return view;
}

@end
