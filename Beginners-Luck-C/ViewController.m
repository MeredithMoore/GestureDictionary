//
//  ViewController.m
//  Beginners-Luck-C
//
//  Created by Sai Reddy on 1/23/16.
//  Copyright © 2016 Sai Reddy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction)settingToConnect:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)settingToConnect:(id)sender {
    UINavigationController *controller = [TLMSettingsViewController settingsInNavigationController];
    // Present the settings view controller modally.
    [self presentViewController:controller animated:YES completion:nil];
}

@end
