//
//  GraphiteGraph.m
//  Promethiskos
//
//  Created by Stuart Nelson on 8/7/15.
//  Copyright (c) 2015 Stuart Nelson. All rights reserved.
//

#import "Graph.h"

@interface Graph ()

@property (strong, nonatomic) NSMutableArray* arrayOfValues;
@property (strong, nonatomic) NSMutableArray* arrayOfDates;

@end

@implementation Graph

- (instancetype)initWithGraph:(BEMSimpleLineGraphView*)graph withColor:(UIColor*)color withURL:(NSString*)url
{
    self = [super init];
    if (self) {
        _graph = graph;
        _color = color;
        _url = url;
        self.graph.colorLine = color;

        // 5xx
        if ([color isEqual:[UIColor redColor]]) {
            graph.positionYAxisRight = YES;
            graph.colorBottom = color;
            graph.alphaBottom = 0.5;
            graph.enableYAxisLabel = YES;

            // set graph delegate to self to return alternate max/min yAxis values
            graph.delegate = self;
        }
    }

    return self;
}

- (NSUInteger)maxYValue
{
    return (NSUInteger)[self.arrayOfValues valueForKeyPath:@"@min.intValue"];
}

- (NSUInteger)minYValue
{
    return (NSUInteger)[self.arrayOfValues valueForKeyPath:@"@max.intValue"];
}

- (CGFloat)maxValueForLineGraph:(BEMSimpleLineGraphView*)graph
{
    return (CGFloat)500;
}

- (CGFloat)minValueForLineGraph:(BEMSimpleLineGraphView*)graph
{
    return (CGFloat)0;
}

- (CGFloat)baseValueForYAxisOnLineGraph:(BEMSimpleLineGraphView*)graph
{
    return (CGFloat)0;
}

- (CGFloat)incrementValueForYAxisOnLineGraph:(BEMSimpleLineGraphView*)graph
{
    return (CGFloat)100;
}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView*)graph
{
    return (int)[self.arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView*)graph valueForPointAtIndex:(NSInteger)index
{
    return [[self.arrayOfValues objectAtIndex:index] doubleValue];
}

- (void)fetchJSON
{
    NSURLSession* session = [NSURLSession sharedSession];

    NSURLSessionDataTask* dataTask = [session dataTaskWithURL:[NSURL URLWithString:self.url]
                                            completionHandler:^(NSData* data,
                                                                  NSURLResponse* response,
                                                                  NSError* error) {

                                                [self processJSON:data];

                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self.graph reloadGraph];
                                                });
                                            }];
    [dataTask resume];
}

- (void)processJSON:(NSData*)json
{
    id object = [NSJSONSerialization
        JSONObjectWithData:json
                   options:0
                     error:nil];
    NSArray* d = object;

    NSDictionary* dataDict = d[0];

    NSArray* datapoints = [dataDict objectForKey:@"datapoints"];
    [self parseData:datapoints];
}

- (void)parseData:(NSArray*)data
{
    // Reset the arrays of values (Y-Axis points) and dates (X-Axis points / labels)
    if (!self.arrayOfValues)
        self.arrayOfValues = [[NSMutableArray alloc] init];
    if (!self.arrayOfDates)
        self.arrayOfDates = [[NSMutableArray alloc] init];
    [self.arrayOfValues removeAllObjects];
    [self.arrayOfDates removeAllObjects];

    for (NSArray* dataPoint in data) {
        NSString* unixTimeString = dataPoint[1];
        if (unixTimeString == (id)[NSNull null]) {
            continue;
        }

        if (dataPoint[0] == (id)[NSNull null]) {
            continue;
        }
        [self.arrayOfValues addObject:dataPoint[0]];

        float unixTime = [unixTimeString floatValue];
        NSDate* d = [NSDate dateWithTimeIntervalSince1970:unixTime];
        [self.arrayOfDates addObject:d];
    }
}

@end
