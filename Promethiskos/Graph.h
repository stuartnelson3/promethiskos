//
//  GraphiteGraph.h
//  Promethiskos
//
//  Created by Stuart Nelson on 8/7/15.
//  Copyright (c) 2015 Stuart Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BEMSimpleLineGraphView.h"

@interface Graph : NSObject <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) BEMSimpleLineGraphView* graph;
@property (strong, nonatomic) UIColor* color;

- (instancetype)initWithGraph:(BEMSimpleLineGraphView*)graph withColor:(UIColor*)color withURL:(NSString*)url;

- (void)fetchJSON;
- (void)processJSON:(NSData*)json;
- (void)parseData:(NSArray*)data;

- (NSUInteger)maxYValue;
- (NSUInteger)minYValue;

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView*)graph;
- (CGFloat)lineGraph:(BEMSimpleLineGraphView*)graph valueForPointAtIndex:(NSInteger)index;

@end
