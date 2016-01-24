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
//    Gesture *data = [[Gesture alloc] initWithGesture: self.gestureNameInput.text secondParameter: self.gestureDescriptionTextView.text thirdParameter: self.emgMatrix fourthParameter: self.acclMatrix fifthParameter: self.oriMatrix sixthParameter: self.gyroMatrix ];
    
    PFObject *data = [PFObject objectWithClassName:@"Gesture"];
    
    data[@"title"] = self.gestureNameInput.text;
    data[@"description"] = self.gestureDescriptionTextView.text;
    
    
    
    [data addObject:self.emgMatrix.mutableCopy forKey:@"emg"];
    [data addObject:self.gyroMatrix.mutableCopy forKey:@"gryo"];
    [data addObject:self.oriMatrix.mutableCopy forKey:@"ori"];
    [data addObject:self.acclMatrix.mutableCopy forKey:@"accl"];

    
//    data[@"emg"] = self.emgMatrix;
//    data[@"gyro"] = self.gyroMatrix;
//    data[@"ori"] = self.oriMatrix;
//    data[@"accl"] = self.acclMatrix;
NSLog(@"%@, %@, %@, %@", self.emgMatrix, self.gyroMatrix, self. oriMatrix, self.acclMatrix);
    
    [data saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Save successful");
        } else if (error) {
            NSLog(@"%@", error);
        }
    }];

}

@end
