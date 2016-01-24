//
//  AddViewController.m
//  Beginners-Luck-C
//
//  Created by Eloise Dietz on 1/23/16.
//  Copyright © 2016 Sai Reddy. All rights reserved.
//

#import "AddViewController.h"
#import <MyoKit/MyoKit.h>
#import "Gesture.h"
#import "ViewController.h"

@interface AddViewController ()

@property (weak, nonatomic) IBOutlet UITextField *gestureNameInput;
@property (weak, nonatomic) IBOutlet UITextView *gestureDescriptionTextView;


@end
@implementation AddViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
}

- (IBAction)saveButtonPressed:(id)sender {
    //Gesture *data = [[Gesture alloc] init];
    Gesture *data = [[Gesture alloc] initWithGesture: self.gestureNameInput.text secondParameter: self.gestureDescriptionTextView.text thirdParameter: self.emgMatrix fourthParameter: self.acclMatrix fifthParameter: self.oriMatrix sixthParameter: self.gyroMatrix ];
    
    [data saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
        } else if (error) {
            NSLog(@"%@", error);
        }
    }];

}

@end
