//
//  FirstViewController.m
//  StudentCheckIn
//
//  Created by Chawatvish Worrapoj on 1/29/2558 BE.
//  Copyright (c) 2558 Chawatvish Worrapoj. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController {
    AVCaptureSession *captureSession;
    AVCaptureDevice *videoDevice;
    AVCaptureInput *videoInput;
    AVCaptureVideoPreviewLayer *preview;
    BOOL running;
    AVCaptureMetadataOutput *metadataOutput;
    NSString *string_Std_ID;
}

@synthesize CameraPreview,Section,Std_ID,submit_bt;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *checkGesture = [[UITapGestureRecognizer alloc]
                                            initWithTarget: self
                                            action: @selector(hideKeyboard:)];
    [checkGesture setNumberOfTouchesRequired:1];
    [[self view] addGestureRecognizer:checkGesture];

    
    string_Std_ID = [[NSString alloc] init];
    [self setupCaptureSession];
    preview.frame = CameraPreview.bounds;
    [CameraPreview.layer addSublayer:preview];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self startRunning];
    Std_ID.text = @"";
    Section.text = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRunning];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideKeyboard:(UITapGestureRecognizer *)sender {
    [Std_ID resignFirstResponder];
    [Section resignFirstResponder];
}

- (void)keyboardWasShown:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    CGFloat height = keyboardFrame.size.height;
    self.keyboardHeight.constant = -height;
    
    [UIView animateWithDuration:0.15 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)keyboardWasHidden:(NSNotification *)aNotification {
    self.keyboardHeight.constant = 21;
    [UIView animateWithDuration:0.15 animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void)setupCaptureSession {
    if (captureSession) return;
    
    videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (!videoDevice) {
        NSLog(@"No video camera on this device!");
        return;
    }
    
    captureSession = [[AVCaptureSession alloc] init];
    //init video input
    videoInput = [[AVCaptureDeviceInput alloc]
                  initWithDevice:videoDevice error:nil];
    
    if ([captureSession canAddInput:videoInput]) {
        [captureSession addInput:videoInput];
    }
    
    // 6
    preview = [[AVCaptureVideoPreviewLayer alloc]
               initWithSession:captureSession];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    // capture and process the metadata
    metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t metadataQueue = dispatch_queue_create("com.Chawatvish.StudentCheckIn.metadata", 0);
    [metadataOutput setMetadataObjectsDelegate:self queue:metadataQueue];
    if ([captureSession canAddOutput:metadataOutput]) {
        [captureSession addOutput:metadataOutput];
    }
}

- (void)startRunning {
    if (running) return;
    [captureSession startRunning];
    metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes;
    running = YES;
}

- (void)stopRunning {
    if (!running) return;
    [captureSession stopRunning];
    running = NO;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
            Std_ID.text = string_Std_ID;
        });
    });
    
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    [metadataObjects enumerateObjectsUsingBlock:^(AVMetadataObject *obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:
              [AVMetadataMachineReadableCodeObject class]])
         {
             // 3
             AVMetadataMachineReadableCodeObject *code = (AVMetadataMachineReadableCodeObject*)
             [preview transformedMetadataObjectForMetadataObject:obj];
             if (code.stringValue) {
                 string_Std_ID = code.stringValue;
                 [self stopRunning];
             }
         }
     }];
}

- (IBAction)ScanCodeAgain:(id)sender {
    if(running == false) {
        Std_ID.text = @"";
        [self startRunning];
    }
}

- (IBAction)CheckIn:(id)sender {
    if ([Std_ID.text intValue] && ([Section.text isEqual:@"1"] || [Section.text isEqual:@"2"] || [Section.text isEqual:@"3"])) {
        UIAlertView *alvshow = [[UIAlertView alloc] initWithTitle:@"" message:@"Check in เรียบร้อย" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alvshow show];
    } else {
        UIAlertView *alvshow = [[UIAlertView alloc] initWithTitle:@"" message:@"กรอกข้อมูลไม่ครบ หรือ กรอกไม่ถูกต้อง" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alvshow show];
    }

}
@end
