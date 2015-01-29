//
//  FirstViewController.h
//  StudentCheckIn
//
//  Created by Chawatvish Worrapoj on 1/29/2558 BE.
//  Copyright (c) 2558 Chawatvish Worrapoj. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@interface FirstViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *CameraPreview;
@property (weak, nonatomic) IBOutlet UITextField *Section;
@property (weak, nonatomic) IBOutlet UITextField *Std_ID;
@property (weak, nonatomic) IBOutlet UIButton *submit_bt;

@end

