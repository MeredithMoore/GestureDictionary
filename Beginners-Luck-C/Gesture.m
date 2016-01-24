//
//  Gesture.m
//  Beginners-Luck
//
//  Created by Brian Aberle on 1/23/16.
//  Copyright © 2016 Sai Reddy. All rights reserved.
//

#import "Gesture.h"

@implementation Gesture

- (id)init {
    self->title = @"";
    self->description = @"";
    
    //Gyro Min/Max threshold
    //NSMutableArray *gyroMax;
    self->gyroMin = [NSMutableArray new];
    
    //Accelaromitor Min/Max threshold
    //NSMutableArray *acclMax;
    self->acclMin = [NSMutableArray new];
    
    //Orientation Min/Max threshold
    //NSMutableArray *oriMax;
    self->oriMin = [NSMutableArray new];
    
    //Emg Min/Max threshold
    //NSMutableArray *emgMax;
    self->emgMin = [NSMutableArray new];
    
    return self;
}

- (id)initWithGesture:(NSString *)titlePassed secondParameter: (NSString *)descriptionPassed thirdParameter: (NSMutableArray *)emgPassed fourthParameter: (NSMutableArray *)acclerationPassed fifthParameter: (NSMutableArray *)orientationPassed sixthParameter: (NSMutableArray *)gyroPassed {
    
    self->title = titlePassed;
    self->description = descriptionPassed;
    self->emgMin = emgPassed;
    self->acclMin = acclerationPassed;
    self->oriMin = orientationPassed;
    self->gyroMin = gyroPassed;
    
    return self;
    
}

@end
