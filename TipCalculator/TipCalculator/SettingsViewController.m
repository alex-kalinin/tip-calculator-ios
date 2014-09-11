//
//  SettingsViewController.m
//  TipCalculator
//
//  Created by Alex Kalinin on 9/10/14.
//  Copyright (c) 2014 Alex Kalinin. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation SettingsViewController
{
    float _tipPercent;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) setTipPercent:(float)tipPercent
{
    _tipPercent = tipPercent;
}

-(NSString*) formatFloat:(float) num
{
    return [NSString stringWithFormat:@"%0.2f", num];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.tipLabel.text = [NSString stringWithFormat:@"%i%%", (int)(_tipPercent * 100)];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
