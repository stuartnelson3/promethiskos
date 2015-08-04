//
//  ViewController.m
//  Promethiskos
//
//  Created by Stuart Nelson on 8/4/15.
//  Copyright (c) 2015 Stuart Nelson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSData* data;
@property (strong, nonatomic) BEMSimpleLineGraphView* myGraph;
@property (strong, nonatomic) NSMutableDictionary* graphs;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _graphs = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* urlToColor = [NSMutableDictionary dictionaryWithDictionary:@{ @"http://graphite.int.s-cloud.net/render?format=json&from=-3600seconds&target=sumSeries(perSecond(ampelmann.a*.*.public.FRONTEND.5xx))&until=now" : [UIColor redColor],
        @"http://graphite.int.s-cloud.net/render?format=json&from=-3600seconds&target=sumSeries(perSecond(ampelmann.a*.*.public.FRONTEND.2xx))&until=now" : [UIColor greenColor],
        @"http://graphite.int.s-cloud.net/render?format=json&from=-3600seconds&target=sumSeries(perSecond(ampelmann.a*.*.public.FRONTEND.3xx))&until=now" : [UIColor blueColor],
        @"http://graphite.int.s-cloud.net/render?format=json&from=-3600seconds&target=sumSeries(perSecond(ampelmann.a*.*.public.FRONTEND.4xx))&until=now" : [UIColor purpleColor] }];

    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;

    UIColor* clear = [UIColor clearColor];
    BOOL showLabel = YES;
    for (NSString* url in urlToColor) {

        BEMSimpleLineGraphView* graph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];

        graph.delegate = self;
        [self.view addSubview:graph];

        graph.enableTouchReport = YES;
        graph.enablePopUpReport = YES;
        if (showLabel) {
            graph.enableYAxisLabel = YES;
            showLabel = NO;
        }
        // need to set the graph max for 2xx 3xx 4xx
        // autoScale true for 5xx and right side axis
        // graph.autoScaleYAxis = YES;
        graph.alwaysDisplayDots = NO;
        // graph.enableReferenceXAxisLines = YES;
        // graph.enableReferenceYAxisLines = YES;
        graph.enableReferenceAxisFrame = YES;

        graph.widthLine = 2.0; // 1.0 default
        graph.animationGraphStyle = BEMLineAnimationDraw;

        graph.colorBottom = clear;
        graph.colorTop = clear;
        // set alphaBottom for 5xx to have solid appearance
        // will also need to scale it
        // custom colors for graphs
        Graph* g = [[Graph alloc] initWithGraph:graph withColor:urlToColor[url] withURL:url];
        graph.dataSource = g;

        self.graphs[url] = g;
        [g fetchJSON];
    }

    //    [NSTimer scheduledTimerWithTimeInterval:5.0  target:self selector:@selector(createLines) userInfo:nil repeats:YES];

    // Do any additional setup after loading the view, typically from a nib.
}

- (CGFloat)maxValueForLineGraph:(BEMSimpleLineGraphView*)graph
{
    return (CGFloat)40000;
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
    return (CGFloat)10000;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
