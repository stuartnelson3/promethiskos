//
//  PageContentViewController.h
//  Promethiskos
//
//  Created by Stuart Nelson on 8/12/15.
//  Copyright (c) 2015 Stuart Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"
#import "Graph.h"

@interface PageContentViewController : UIViewController <BEMSimpleLineGraphDelegate>

@property (nonatomic, strong) NSMutableDictionary* urlToColor;
@property (nonatomic) NSUInteger pageIndex;

@end
