//
//  ViewController.h
//  Promethiskos
//
//  Created by Stuart Nelson on 8/4/15.
//  Copyright (c) 2015 Stuart Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface RootViewController : UIViewController <BEMSimpleLineGraphDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController* PageViewController;

- (PageContentViewController*)viewControllerAtIndex:(NSUInteger)index;

@end
