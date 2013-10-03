//
//  GraphViewConroller.m
//  Calculator
//
//  Created by Shane Fu on 9/23/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "GraphViewConroller.h"
#import "GraphicView.h"
#import "CalculatorBrain.h"

@interface GraphViewConroller ()

@property (weak, nonatomic) IBOutlet UILabel *functionDisplay;
@end

@implementation GraphViewConroller
@synthesize graphicView = _graphicView;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

-(void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
	if (![_splitViewBarButtonItem isEqual: splitViewBarButtonItem]) {
		NSMutableArray *toolBarItem = [self.toolBar.items mutableCopy];
		if (_splitViewBarButtonItem) {
			[toolBarItem removeObject:_splitViewBarButtonItem];
		}
		if (splitViewBarButtonItem) {
			[toolBarItem insertObject:splitViewBarButtonItem atIndex:0];
		}
		self.toolBar.items = toolBarItem;
		_splitViewBarButtonItem = splitViewBarButtonItem;
	}
}

#pragma mark - setter and getter
-(void)setGraphicView:(GraphicView *)graphicView
{
	_graphicView = graphicView;
	UIGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self.graphicView action:@selector(pinch:)];
	UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.graphicView	action:@selector(pan:)];
	[self.graphicView addGestureRecognizer:pinch];
	[self.graphicView addGestureRecognizer:pan];
}
#pragma mark - gesture handler
-(void)awakeFromNib{
	NSLog(@"awake from nib");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.functionDisplay.text = [self.delegate functionDisplay:self];
	self.graphicView.dataSource = self;
}

//bounds only correct after it appears, cause the graphicView is set
-(void)viewDidAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.graphicView.originPosion = CGPointMake(self.graphicView.bounds.origin.x + self.graphicView.bounds.size.width/2, self.graphicView.bounds.origin.y + self.graphicView.bounds.size.height/2);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backPressed:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)getYValueAtX:(CGFloat)x sender:(GraphicView *)sender{
	double result = [CalculatorBrain calculateFunctionFromString:self.functionDisplay.text withValueOfX:x];
	return result;
}

@end
