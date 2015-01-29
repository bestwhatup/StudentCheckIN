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
}

@synthesize CameraPreview,Section,Std_ID,submit_bt;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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

@end
