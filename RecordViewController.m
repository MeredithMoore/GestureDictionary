//


//  RecordViewController.m
//  Beginners-Luck-C
//
//  Created by Sai Reddy on 1/23/16.
//  Copyright © 2016 Sai Reddy. All rights reserved.
//

#import "RecordViewController.h"
#import <MyoKit/MyoKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "AddViewController.h"

@interface RecordViewController ()

- (IBAction)stopRecording:(id)sender;
- (IBAction)startCounter:(id)sender;
- (void)lightAnimation;
- (void)preparePlayer;
- (IBAction)didTapSettings:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *redoButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *recordStatus;
@property (weak, nonatomic) IBOutlet UIImageView *SignalImage;

@property (strong, nonatomic) TLMPose *currentPose;
@property (strong, nonatomic) TLMMyo *myo;
@property int counter;
@property NSTimer *timer;
@property AVAudioPlayer *player;
@property NSMutableArray *emgMatrix;
@property NSMutableArray *accMatrix;
@property NSMutableArray *gyroMatrix;
@property int emgCount ;

@end


@implementation RecordViewController


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self preparePlayer];
    self.emgMatrix = [[NSMutableArray alloc] initWithCapacity:1];
    self.accMatrix = [[NSMutableArray alloc] initWithCapacity:1];
    self.gyroMatrix = [[NSMutableArray alloc] initWithCapacity:1];
    self.emgCount = 0;
    // Data notifications are received through NSNotificationCenter.
    // Posted whenever a TLMMyo connects
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didConnectDevice:)
                                                 name:TLMHubDidConnectDeviceNotification
                                               object:nil];
    // Posted whenever a TLMMyo disconnects.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDisconnectDevice:)
                                                 name:TLMHubDidDisconnectDeviceNotification
                                               object:nil];
    // Posted whenever the user does a successful Sync Gesture.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSyncArm:)
                                                 name:TLMMyoDidReceiveArmSyncEventNotification
                                               object:nil];
    // Posted whenever Myo loses sync with an arm (when Myo is taken off, or moved enough on the user's arm).
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUnsyncArm:)
                                                 name:TLMMyoDidReceiveArmUnsyncEventNotification
                                               object:nil];
    // Posted whenever Myo is unlocked and the application uses TLMLockingUnPolicyStandard.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUnlockDevice:)
                                                 name:TLMMyoDidReceiveUnlockEventNotification
                                               object:nil];
    // Posted whenever Myo is locked and the application uses TLMLockingPolicyStandard.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLockDevice:)
                                                 name:TLMMyoDidReceiveLockEventNotification
                                               object:nil];
    // Posted when a new orientation event is available from a TLMMyo. Notifications are posted at a rate of 50 Hz.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveOrientationEvent:)
                                                 name:TLMMyoDidReceiveOrientationEventNotification
                                               object:nil];
    // Posted when a new accelerometer event is available from a TLMMyo. Notifications are posted at a rate of 50 Hz.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveAccelerometerEvent:)
                                                 name:TLMMyoDidReceiveAccelerometerEventNotification
                                               object:nil];
    // Posted when a new pose is available from a TLMMyo.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePoseChange:)
                                                 name:TLMMyoDidReceivePoseChangedNotification
                                               object:nil];
    // Posted when a new pose is available from a TLMEmgEvent.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveEmgEvent:)
                                                 name:TLMMyoDidReceiveEmgEventNotification
                                               object:nil];
    
    // Posted when a new pose is available from a TLMEmgEvent.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveGyroEvent:)
                                                 name:TLMMyoDidReceiveGyroscopeEventNotification
                                               object:nil];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSNotificationCenter Methods

-(void) didReceiveGyroEvent:(NSNotification *) notification {
    TLMAccelerometerEvent *accelerometerEvent = notification.userInfo[kTLMKeyGyroscopeEvent];
    TLMVector3 accelerationVector = accelerometerEvent.vector;
    float x = accelerationVector.x;
    float y = accelerationVector.y;
    float z = accelerationVector.z;
    NSMutableArray *tempa = [[NSMutableArray alloc] init];
    NSNumber *num ;
    //NSLog(@"******%d*********", self.counter);
    if(self.counter >= 1 && self.counter <= 5) {
        
        num = [NSNumber numberWithFloat:x];
        [tempa addObject:num];
        num = [NSNumber numberWithFloat:y];
        [tempa addObject:num];
        num = [NSNumber numberWithFloat:z];
        [tempa addObject:num];
    }
    [self.gyroMatrix addObject:tempa];
}


- (void)didConnectDevice:(NSNotification *)notification {
    // Access the connected device.
    self.myo = notification.userInfo[kTLMKeyMyo];
    NSLog(@"Connected to %@.", self.myo.name);
    self.gestureStatus.text = @"Connected-Perform Sync Gesture";
}

- (void)didDisconnectDevice:(NSNotification *)notification {
    // Access the disconnected device.
    self.myo = notification.userInfo[kTLMKeyMyo];
    NSLog(@"Disconnected from %@.", self.myo.name);
    self.gestureStatus.text = @"Disconnected to Myo";

}

- (void)didUnlockDevice:(NSNotification *)notification {
    // Update the label to reflect Myo's lock state.
    self.gestureStatus.text = @"Myo Unlocked";
}

- (void)didLockDevice:(NSNotification *)notification {
    // Update the label to reflect Myo's lock state.
    self.gestureStatus.text = @"Myo Locked";
}

- (void)didSyncArm:(NSNotification *)notification {
    // Retrieve the arm event from the notification's userInfo with the kTLMKeyArmSyncEvent key.
    TLMArmSyncEvent *armEvent = notification.userInfo[kTLMKeyArmSyncEvent];
    
    // Update the armLabel with arm information.
    NSString *armString = armEvent.arm == TLMArmRight ? @"Right" : @"Left";
    NSString *directionString = armEvent.xDirection == TLMArmXDirectionTowardWrist ? @"Toward Wrist" : @"Toward Elbow";
//    self.armLabel.text = [NSString stringWithFormat:@"Arm: %@ X-Direction: %@", armString, directionString];
//    self.lockLabel.text = @"Locked";
}

- (void)didUnsyncArm:(NSNotification *)notification {
    // Reset the labels.
//    self.armLabel.text = @"Perform the Sync Gesture";
//    self.helloLabel.text = @"Hello Myo";
//    self.lockLabel.text = @"";
//    self.helloLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:50];
//    self.helloLabel.textColor = [UIColor blackColor];
}

- (void)didReceiveOrientationEvent:(NSNotification *)notification {
    // Retrieve the orientation from the NSNotification's userInfo with the kTLMKeyOrientationEvent key.
    TLMOrientationEvent *orientationEvent = notification.userInfo[kTLMKeyOrientationEvent];
    
    // Create Euler angles from the quaternion of the orientation.
    TLMEulerAngles *angles = [TLMEulerAngles anglesWithQuaternion:orientationEvent.quaternion];
    
    // Next, we want to apply a rotation and perspective transformation based on the pitch, yaw, and roll.
    CATransform3D rotationAndPerspectiveTransform = CATransform3DConcat(CATransform3DConcat(CATransform3DRotate (CATransform3DIdentity, angles.pitch.radians, -1.0, 0.0, 0.0), CATransform3DRotate(CATransform3DIdentity, angles.yaw.radians, 0.0, 1.0, 0.0)), CATransform3DRotate(CATransform3DIdentity, angles.roll.radians, 0.0, 0.0, -1.0));
    
    // Apply the rotation and perspective transform to helloLabel.
   // self.helloLabel.layer.transform = rotationAndPerspectiveTransform;
}

- (void)didReceiveAccelerometerEvent:(NSNotification *)notification {
    // Retrieve the accelerometer event from the NSNotification's userInfo with the kTLMKeyAccelerometerEvent.
    TLMAccelerometerEvent *accelerometerEvent = notification.userInfo[kTLMKeyAccelerometerEvent];
    
    // Get the acceleration vector from the accelerometer event.
    TLMVector3 accelerationVector = accelerometerEvent.vector;
    
    // Calculate the magnitude of the acceleration vector.
    float magnitude = TLMVector3Length(accelerationVector);
    
    // Update the progress bar based on the magnitude of the acceleration vector.
    //self.accelerationProgressBar.progress = magnitude / 8;
    
    
     float x = accelerationVector.x;
     float y = accelerationVector.y;
     float z = accelerationVector.z;
    NSMutableArray *tempa = [[NSMutableArray alloc] init];
    NSNumber *num ;
    //NSLog(@"******%d*********", self.counter);
    if(self.counter >= 1 && self.counter <= 5) {
    
        num = [NSNumber numberWithFloat:x];
        [tempa addObject:num];
        num = [NSNumber numberWithFloat:y];
        [tempa addObject:num];
        num = [NSNumber numberWithFloat:z];
        [tempa addObject:num];
    }
    [self.accMatrix addObject:tempa];
}

- (void)didReceiveEmgEvent:(NSNotification *)notification {
    //NSLog(@"HEEeeeee");
    TLMEmgEvent *emgEvent = notification.userInfo[kTLMKeyEMGEvent];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for( int i=0; i<8; i++){
        [temp addObject:emgEvent.rawData[i]];
    }
    //NSLog(@"%@",emgEvent.rawData);
    [self.emgMatrix addObject:temp];
}

- (void)didReceivePoseChange:(NSNotification *)notification {
    // Retrieve the pose from the NSNotification's userInfo with the kTLMKeyPose key.
    
    TLMPose *pose = notification.userInfo[kTLMKeyPose];
    self.currentPose = pose;
    
    // Handle the cases of the TLMPoseType enumeration, and change the color of helloLabel based on the pose we receive.
    switch (pose.type) {
        case TLMPoseTypeUnknown:
        case TLMPoseTypeRest:
        case TLMPoseTypeDoubleTap:
            // Changes helloLabel's font to Helvetica Neue when the user is in a rest or unknown pose.
//            self.helloLabel.text = @"Hello Myo";
//            self.helloLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:50];
//            self.helloLabel.textColor = [UIColor blackColor];
            break;
        case TLMPoseTypeFist:
            // Changes helloLabel's font to Noteworthy when the user is in a fist pose.
            self.gestureStatus.text = @"Gesture: Fist";
//            self.helloLabel.font = [UIFont fontWithName:@"Noteworthy" size:50];
//            self.helloLabel.textColor = [UIColor greenColor];
            break;
        case TLMPoseTypeWaveIn:
            // Changes helloLabel's font to Courier New when the user is in a wave in pose.
            self.gestureStatus.text = @"Gesture: Wave In";
//            self.helloLabel.font = [UIFont fontWithName:@"Courier New" size:50];
//            self.helloLabel.textColor = [UIColor greenColor];
            break;
        case TLMPoseTypeWaveOut:
            // Changes helloLabel's font to Snell Roundhand when the user is in a wave out pose.
            self.gestureStatus.text = @"Gesture: Wave Out";
//            self.helloLabel.font = [UIFont fontWithName:@"Snell Roundhand" size:50];
//            self.helloLabel.textColor = [UIColor greenColor];
            break;
        case TLMPoseTypeFingersSpread:
            // Changes helloLabel's font to Chalkduster when the user is in a fingers spread pose.
            self.gestureStatus.text = @"Gesture: Fingers Spread";
//            self.helloLabel.font = [UIFont fontWithName:@"Chalkduster" size:50];
//            self.helloLabel.textColor = [UIColor greenColor];
            break;
    }
    
    // Unlock the Myo whenever we receive a pose
    if (pose.type == TLMPoseTypeUnknown || pose.type == TLMPoseTypeRest) {
        // Causes the Myo to lock after a short period.
        [pose.myo unlockWithType:TLMUnlockTypeTimed];
    } else {
        // Keeps the Myo unlocked until specified.
        // This is required to keep Myo unlocked while holding a pose, but if a pose is not being held, use
        // TLMUnlockTypeTimed to restart the timer.
        [pose.myo unlockWithType:TLMUnlockTypeHold];
        // Indicates that a user action has been performed.
        [pose.myo indicateUserAction];
    }
}

- (void)lightAnimation {

    if(self.counter == 1) {
        self.SignalImage.image =
        [UIImage imageNamed:@"Red.png"];
        self.recordStatus.text = @"Started recording data..";
    }
    else if(self.counter == 2) {
        self.SignalImage.image =
        [UIImage imageNamed:@"Yellow.png"];
    }
    else if(self.counter >= 3) {
       
        // start recording
        [self.myo setStreamEmg:TLMStreamEmgEnabled];
        self.SignalImage.image =
        [UIImage imageNamed:@"Green.png"];
        self.stopButton.hidden = false;
    }
    

}

- (void)preparePlayer {
    
    NSString *path = [NSString stringWithFormat:@"%@/4 Beep.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url  error:nil];
}

- (IBAction)didTapSettings:(id)sender {
    UINavigationController *controller = [TLMSettingsViewController settingsInNavigationController];
    // Present the settings view controller modally.
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void) countUp:(NSTimer *)timer {
    self.startButton.hidden = true;
    self.counter++;
    if(self.counter == 8){
        [self.myo setStreamEmg:TLMStreamEmgDisabled];
        NSLog(@"Data recording stopped.");
        self.recordStatus.text = @"Click the start button to record gesture";
        self.counter = 0;
        self.startButton.hidden = true;
        self.stopButton.hidden = true;
        self.redoButton.hidden = false;
        self.addButton.hidden = false;
        [self.timer invalidate];
        self.SignalImage.image =
        [UIImage imageNamed:@"Red.png"];
        //NSLog(@"Total rows: %ld",[self.emgMatrix count]);
        self.gestureStatus.text = @"Gesture data captured.";
        NSLog(@"Total EMG rows: %ld",[self.emgMatrix count]);
        NSLog(@"Total Acc rows: %ld",[self.accMatrix count]);
        NSLog(@"Total Gyro rows: %ld",[self.gyroMatrix count]);

    }
    [self lightAnimation];
}


- (IBAction)stopRecording:(id)sender {
    [self.myo setStreamEmg:TLMStreamEmgDisabled];
    NSLog(@"Data recording stopped.");
    self.recordStatus.text = @"Click the start button to record gesture";
    self.counter = 0;
    self.startButton.hidden = true;
    self.stopButton.hidden = true;
    self.redoButton.hidden = false;
    self.addButton.hidden = false;
    [self.timer invalidate];
    self.SignalImage.image =
    [UIImage imageNamed:@"Red.png"];
    NSLog(@"Total EMG rows: %ld",[self.emgMatrix count]);
    NSLog(@"Total Acc rows: %ld",[self.accMatrix count]);
    NSLog(@"Total Gyro rows: %ld",[self.gyroMatrix count]);
}
- (IBAction)redo:(id)sender {
    self.startButton.hidden = false;
}

- (IBAction)startCounter:(id)sender {
    //this is where we will have to start recording data
    self.timer = [[NSTimer alloc] init];
    [self.player play];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                target:self
                selector:@selector(countUp:)
                userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    NSLog(@"Data Recording Started......");
    [runner addTimer: self.timer forMode: NSDefaultRunLoopMode];
    
}


 #pragma mark - Navigation
 
// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"addSegue"]) {
        
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        AddViewController *controller = (AddViewController *)navController.topViewController;
        controller.emgMatrix = self.emgMatrix;
        
    }

}


@end
