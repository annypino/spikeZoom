//
//  ViewController.m
//  spikeZoom
//
//  Created by Anny Pino on 12/8/17.
//  Copyright © 2017 Anny Pino. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [_audioSwitch setOn:YES animated:NO];
    [_audioSwitch addTarget:self action:@selector(onHideMeetingAudio:) forControlEvents:UIControlEventValueChanged];
    
    [_videoSwitch setOn:YES animated:NO];
    [_videoSwitch addTarget:self action:@selector(onHideMeetingVideo:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)joinaMeetingTouchUpInside:(UIButton *)sender {
    NSString *meetingNumber = [[NSString alloc] init];
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if (!ms)
    {
        return;
    }
    meetingNumber = _meetingNumberTextfield.text;
    [self joinMeeting:meetingNumber];
    
   
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_meetingNumberTextfield resignFirstResponder];
}


- (void)dealloc {
    [_meetingNumberTextfield release];
    [_audioSwitch release];
    [_videoSwitch release];
    [super dealloc];
}

- (void)onHideMeetingAudio:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [[MobileRTC sharedRTC] getMeetingSettings].meetingAudioHidden = !sv.on;
    [[[MobileRTC sharedRTC] getMeetingSettings] setMuteAudioWhenJoinMeeting:!sv.on];
     NSLog(@"meetingAudioHidden: %d, MuteAudioWhenJoinMeeting: %d", [[MobileRTC sharedRTC] getMeetingSettings].meetingAudioHidden, [[MobileRTC sharedRTC] getMeetingSettings].muteAudioWhenJoinMeeting);
}

- (void)onHideMeetingVideo:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [[MobileRTC sharedRTC] getMeetingSettings].meetingVideoHidden = !sv.on;
    NSLog(@"meetingVideoHidden: %d", [[MobileRTC sharedRTC] getMeetingSettings].meetingVideoHidden);
}

- (void)joinMeeting:(NSString*)meetingNo
{
    if (![meetingNo length])
        return;
    
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if (ms)
    {
        //customize meeting title
        [ms customizeMeetingTitle:@"Spike Zoom Title"];

        ms.delegate = self;
        
        //For Join a meeting with password
        NSDictionary *paramDict = @{
                                    kMeetingParam_Username:@"",
                                    kMeetingParam_MeetingNumber:meetingNo,
                                    kMeetingParam_MeetingPassword:@"",
                                    //kMeetingParam_ParticipantID:kParticipantID,
                                    //kMeetingParam_WebinarToken:kWebinarToken,
                                    //kMeetingParam_NoAudio:@(YES),
                                    //kMeetingParam_NoVideo:@(YES),
                                    };
        //            //For Join a meeting
        //            NSDictionary *paramDict = @{
        //                                        kMeetingParam_Username:kSDKUserName,
        //                                        kMeetingParam_MeetingNumber:meetingNo,
        //                                        kMeetingParam_MeetingPassword:pwd,
        //                                        };
        
        MobileRTCMeetError ret = [ms joinMeetingWithDictionary:paramDict];
        
        NSLog(@"onJoinaMeeting ret:%d", ret);
    }
}

#pragma mark - Meeting Service Delegate

- (void)onMeetingReturn:(MobileRTCMeetError)error internalError:(NSInteger)internalError
{
    NSLog(@"onMeetingReturn:%d, internalError:%zd", error, internalError);
}

- (void)onMeetingStateChange:(MobileRTCMeetingState)state
{
    NSLog(@"onMeetingStateChange:%d", state);
    
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    
#if 1
    if (state == MobileRTCMeetingState_InMeeting)
    {
        //For customizing the content of Invite by SMS
        NSString *meetingNumber = [[MobileRTCInviteHelper sharedInstance] ongoingMeetingNumber];
        NSString *smsMessage = [NSString stringWithFormat:NSLocalizedString(@"Please join meeting with ID: %@", @""), meetingNumber];
        [[MobileRTCInviteHelper sharedInstance] setInviteSMS:smsMessage];
        
        //For customizing the content of Copy URL
        NSString *joinURL = [[MobileRTCInviteHelper sharedInstance] joinMeetingURL];
        NSString *copyURLMsg = [NSString stringWithFormat:NSLocalizedString(@"Meeting URL: %@", @""), joinURL];
        [[MobileRTCInviteHelper sharedInstance] setInviteCopyURL:copyURLMsg];
    }
#endif
    

    // Para Ipad muestra como agregar una vista personalizada
    //For adding customize view above the meeting view
    if (state == MobileRTCMeetingState_InMeeting)
    {
        MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
        UIView *v = [ms meetingView];
     
        
        CGFloat offsetY = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 220 : 180;
        UIView *sv = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, v.frame.size.width, 50)];
        sv.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
        sv.backgroundColor = [UIColor redColor];
        [v addSubview:sv];
        [sv release];
    }
    

}



@end
