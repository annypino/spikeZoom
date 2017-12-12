//
//  ViewController.h
//  spikeZoom
//
//  Created by Anny Pino on 12/8/17.
//  Copyright © 2017 Anny Pino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<MobileRTCMeetingServiceDelegate>

@property (retain, nonatomic) IBOutlet UITextField *meetingNumberTextfield;
@property (retain, nonatomic) IBOutlet UISwitch *audioSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *videoSwitch;


@end

