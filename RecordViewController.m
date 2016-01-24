//
//  RecordViewController.m
//  Beginners-Luck-C
//
//  Created by Sai Reddy on 1/23/16.
//  Copyright © 2016 Sai Reddy. All rights reserved.
//

#import "RecordViewController.h"
#import <MyoKit/MyoKit.h>

@interface RecordViewController ()

- (IBAction)stopRecording:(id)sender;

- (IBAction)startCounter:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *recordStatus;

@property (weak, nonatomic) IBOutlet UIImageView *SignalImage;
@property int counter;
@property NSTimer *timer;
@end


@implementation RecordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.counter = 0;
    // Do any additional setup after loading the view, typically from a nib.
    
    //    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

}

- (void) lightAnimation {

    if(self.counter == 1) {
        self.SignalImage.image =
        [UIImage imageNamed:@"Red.png"];
        self.stopButton.hidden = false;
        self.recordStatus.text = @"Started recording data..";
    }
    else if(self.counter == 2) {
        self.SignalImage.image =
        [UIImage imageNamed:@"Yellow.png"];
    }
    else if(self.counter >= 3) {
        self.SignalImage.image =
        [UIImage imageNamed:@"Green.png"];
        
    }

}

- (void) countUp:(NSTimer *)timer {
    self.startButton.hidden = true;
    self.counter++;
    [self lightAnimation];
}

- (IBAction)stopRecording:(id)sender {
    self.recordStatus.text = @"Click the start button to record gesture";
    self.counter = 0;
    self.startButton.hidden = false;
    self.stopButton.hidden = true;
    [self.timer invalidate];
    self.SignalImage.image =
    [UIImage imageNamed:@"Red.png"];
}

- (IBAction)startCounter:(id)sender {
    //this is where we will have to start recording data
    self.timer = [[NSTimer alloc] init];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                target:self
                selector:@selector(countUp:)
                userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: self.timer forMode: NSDefaultRunLoopMode];
    
   }
@end
