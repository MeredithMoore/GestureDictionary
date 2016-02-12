//
//  Gesture.h
//  Beginners-Luck
//
//  Created by Brian Aberle on 1/23/16.
//  Copyright © 2016 Sai Reddy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Gesture : NSObject  {
   

    
    NSString *title;
    NSString *description;
    
    //Gyro Min/Max threshold
    //NSMutableArray *gyroMax;
    NSMutableArray *gyroMin;
    
    //Accelaromitor Min/Max threshold
    //NSMutableArray *acclMax;
    NSMutableArray *acclMin;
    
    //Orientation Min/Max threshold
    //NSMutableArray *oriMax;
    NSMutableArray *oriMin;
    
    //Emg Min/Max threshold
    //NSMutableArray *emgMax;
    NSMutableArray *emgMin;
    

}

- (id)init;

- (id)initWithGesture:(NSString *)titlePassed secondParameter: (NSString *)descriptionPassed thirdParameter: (NSMutableArray *)emgPassed fourthParameter: (NSMutableArray *)acclerationPassed fifthParameter: (NSMutableArray *)orientationPassed sixthParameter: (NSMutableArray *)gyroPassed;

@end
