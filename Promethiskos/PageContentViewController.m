//
//  PageContentViewController.m
//  Promethiskos
//
//  Created by Stuart Nelson on 8/12/15.
//  Copyright (c) 2015 Stuart Nelson. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()
@property (strong, nonatomic) NSData* data;
@property (strong, nonatomic) NSMutableDictionary* graphs;
@end

@implementation PageContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;

    UIColor* clear = [UIColor clearColor];
    BOOL showLabel = YES;
    for (NSString* url in self.urlToColor) {
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
        Graph* g = [[Graph alloc] initWithGraph:graph withColor:self.urlToColor[url] withURL:url];
        graph.dataSource = g;

        self.graphs[url] = g;
        [g fetchJSON];
    }
    // double check this doesn't mess up when switching views
    // or if i need to unregister the timer
    //    [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    for (NSString* url in self.graphs) {
        Graph* g = self.graphs[url];
        [g fetchJSON];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
