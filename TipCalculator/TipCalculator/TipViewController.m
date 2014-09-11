//
//  TipViewController.m
//  TipCalculator
//
//  Created by Alex Kalinin on 9/9/14.
//  Copyright (c) 2014 Alex Kalinin. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textBill;
@property (strong, nonatomic) IBOutlet UILabel *labelTip;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *tipControl;
- (IBAction)onTap:(id)sender;

@end
//------------------------------------------------------------------------------
@implementation TipViewController
//------------------------------------------------------------------------------
-(id)init
{
    self = [super self];
    return self;
}
//------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Tip Calculator";
    }
    return self;
}
//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self readSettings];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    // Do any additional setup after loading the view from its nib.
    [self updateValues];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Settings"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(onSettingsButton)];
}
//------------------------------------------------------------------------------
-(void) onSettingsButton
{
    SettingsViewController* sc = [[SettingsViewController alloc]init];
    [sc setTipPercent:[self getTipPercent]];
    [self.navigationController pushViewController:sc animated:YES];
}
//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//------------------------------------------------------------------------------
- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    [self updateValues];
}

-(void)saveSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.tipControl.selectedSegmentIndex forKey:@"tipIndex"];
    [defaults synchronize];
    
    float curBill = [self.textBill.text floatValue];
    float savedBillAmount = [defaults floatForKey:@"billAmout"];
    NSDate* billSaved = [defaults objectForKey:@"billSavedDate"];
    
    if (savedBillAmount != curBill || !billSaved) {
        // Reset history
        billSaved = [NSDate date];
        [defaults setFloat:curBill forKey:@"billAmount"];
        [defaults setObject:billSaved forKey:@"billSavedDate"];
    }
}

-(void) readSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.tipControl.selectedSegmentIndex = [defaults integerForKey:@"tipIndex"];
    
    NSDate* billSaved = [defaults objectForKey:@"billSavedDate"];
    if (billSaved) {
        NSDate* now = [NSDate date];
        int seconds = [now timeIntervalSinceDate:billSaved];
        if (seconds <= 60) {
            self.textBill.text = [self formatFloat:[defaults floatForKey:@"billAmount"]];
        }
        else {
            [defaults setObject:nil forKey:@"billSavedDate"];
        }
    }
}
-(float) getTipPercent
{
    NSArray* tipValues = @[@(0.12), @(0.15), @(0.18)];
    return [tipValues[self.tipControl.selectedSegmentIndex] floatValue];
}
//------------------------------------------------------------------------------
-(NSString*) formatFloat:(float) num
{
    return [NSString stringWithFormat:@"%0.2f", num];
}

-(void) updateValues
{
    float billAmount = [self.textBill.text floatValue];
    float tipAmount = billAmount * [self getTipPercent];
    float totalAmount = billAmount + tipAmount;
    self.labelTip.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
    
    [self saveSettings];
}
@end
