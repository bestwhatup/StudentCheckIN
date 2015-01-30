//
//  FirstViewController.h
//  StudentCheckIn
//
//  Created by Chawatvish Worrapoj on 1/29/2558 BE.
//  Copyright (c) 2558 Chawatvish Worrapoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@import AVFoundation;

@interface FirstViewController : UIViewController <UITextFieldDelegate,AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *CameraPreview;
@property (weak, nonatomic) IBOutlet UITextField *Section;
@property (weak, nonatomic) IBOutlet UITextField *Std_ID;
@property (weak, nonatomic) IBOutlet UIButton *submit_bt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;

- (IBAction)ScanCodeAgain:(id)sender;
- (IBAction)CheckIn:(id)sender;

@end

