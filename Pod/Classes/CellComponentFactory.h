//
//  CellComponentFactory.h
//  BearBeers
//
//  Created by Victor WANG on 19/06/15.
//  Copyright (c) 2015 AllblueTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellComponentFactory : NSObject

+ (UIView *)createCellComponentFromClass:(Class)componentClass
                            componentKey:(NSString *)componentKey;

@end
