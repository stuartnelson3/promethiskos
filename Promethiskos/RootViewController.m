//
//  ViewController.m
//  Promethiskos
//
//  Created by Stuart Nelson on 8/4/15.
//  Copyright (c) 2015 Stuart Nelson. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
@property (strong, nonatomic) NSData* data;
@property (strong, nonatomic) NSMutableDictionary* graphs;
@property (strong, nonatomic) NSMutableArray* urlDicts;
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _graphs = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* urlToColor = [NSMutableDictionary dictionaryWithDictionary:@{ @"http://graphite.int.s-cloud.net/render?format=json&from=-3600seconds&target=sumSeries(perSecond(ampelmann.a*.*.public.FRONTEND.5xx))&until=now" : [UIColor redColor],
        @"http://graphite.int.s-cloud.net/render?format=json&from=-3600seconds&target=sumSeries(perSecond(ampelmann.a*.*.public.FRONTEND.2xx))&until=now" : [UIColor greenColor],
        @"http://graphite.int.s-cloud.net/render?format=json&from=-3600seconds&target=sumSeries(perSecond(ampelmann.a*.*.public.FRONTEND.3xx))&until=now" : [UIColor blueColor],
        @"http://graphite.int.s-cloud.net/render?format=json&from=-3600seconds&target=sumSeries(perSecond(ampelmann.a*.*.public.FRONTEND.4xx))&until=now" : [UIColor purpleColor] }];

    NSMutableDictionary* urlToColor2 = [NSMutableDictionary dictionaryWithDictionary:@{ @"http://graphite.int.s-cloud.net/render?format=json&from=-86400seconds&target=sumSeries(perSecond(ampelmann.a*.*.public.FRONTEND.5xx))&until=now" : [UIColor redColor],
        @"http://graphite.int.s-cloud.net/render?format=json&from=-86400seconds&target=sumSeries(perSecond(ampelmann.a*.*.public.FRONTEND.2xx))&until=now" : [UIColor greenColor],
        @"http://graphite.int.s-cloud.net/render?format=json&from=-86400seconds&target=sumSeries(perSecond(ampelmann.a*.*.public.FRONTEND.3xx))&until=now" : [UIColor blueColor],
        @"http://graphite.int.s-cloud.net/render?format=json&from=-86400seconds&target=sumSeries(perSecond(ampelmann.a*.*.public.FRONTEND.4xx))&until=now" : [UIColor purpleColor] }];

    _urlDicts = [[NSMutableArray alloc] initWithObjects:urlToColor, urlToColor2, nil];

    // Create page view controller
    self.PageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.PageViewController.dataSource = self;

    PageContentViewController* startingViewController = [self viewControllerAtIndex:0];
    NSArray* viewControllers = @[ startingViewController ];
    [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    // Change the size of page view controller
    self.PageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);

    [self addChildViewController:_PageViewController];
    [self.view addSubview:_PageViewController.view];
    [self.PageViewController didMoveToParentViewController:self];

    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - Page View Controller Data Source

- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerBeforeViewController:(UIViewController*)viewController
{
    NSUInteger index = ((PageContentViewController*)viewController).pageIndex;

    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }

    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerAfterViewController:(UIViewController*)viewController
{
    NSUInteger index = ((PageContentViewController*)viewController).pageIndex;

    if (index == NSNotFound) {
        return nil;
    }

    index++;
    if (index == [self.urlDicts count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController*)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.urlDicts count] == 0) || (index >= [self.urlDicts count])) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    PageContentViewController* pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.urlToColor = self.urlDicts[index];
    pageContentViewController.pageIndex = index;

    return pageContentViewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
