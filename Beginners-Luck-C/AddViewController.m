//
//  AddViewController.m
//  Beginners-Luck-C
//
//  Created by Eloise Dietz on 1/23/16.
//  Copyright © 2016 Sai Reddy. All rights reserved.
//

#import "AddViewController.h"
#import <MyoKit/MyoKit.h>

@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *gestureName;
@property (weak, nonatomic) IBOutlet UITextView *gestureDescription;


@end
@implementation AddViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
}


@end
