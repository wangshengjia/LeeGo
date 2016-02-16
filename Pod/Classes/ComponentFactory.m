//
//  CellComponentFactory.m
//  BearBeers
//
//  Created by Victor WANG on 19/06/15.
//  Copyright (c) 2015 AllblueTechnology. All rights reserved.
//

#import "ComponentFactory.h"

@implementation ComponentFactory

+ (UIView *)componentViewFromClass:(Class)componentClass
{
    NSString *classStr = NSStringFromClass(componentClass);
    UIView *view = [[NSClassFromString(classStr) alloc] init];
    return view;
}

@end
