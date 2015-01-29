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
    string_Std_ID = [[NSString alloc] init];
    [self setupCaptureSession];
    preview.frame = CameraPreview.bounds;
    [CameraPreview.layer addSublayer:preview];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self startRunning];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"%@",string_Std_ID);
    Std_ID.text = string_Std_ID;
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

@end
