//
//  ViewController.m
//  Canvas
//
//  Created by Balachandar Sankar on 2/1/17.
//  Copyright © 2017 Balachandar Sankar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *trayView;
@property (nonatomic, assign) CGPoint trayOriginalCenter;
@property (nonatomic, assign) CGPoint trayCenterWhenOpen;
@property (nonatomic, assign) CGPoint trayCenterWhenClosed;
@property (nonatomic, strong) UIImageView *newlyCreatedFace;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.trayCenterWhenOpen = self.trayView.center;
    self.trayCenterWhenClosed = CGPointMake(self.trayView.center.x, self.trayView.center.y + (self.trayView.center.y * 0.75));
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.trayView.center.y == self.trayCenterWhenClosed.y) {
            self.trayView.center = self.trayCenterWhenOpen;
        } else {
            self.trayView.center = self.trayCenterWhenClosed;
        }
    }
}

- (IBAction)onTrayPanGesture:(UIPanGestureRecognizer *)sender {
    // Absolute (x,y) coordinates in parentView
    CGPoint location = [sender locationInView:self.view];
    CGPoint translation = [sender translationInView:self.view];
    
    CGPoint trayVelocity = [sender velocityInView:self.trayView];
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(location));
        self.trayOriginalCenter = self.trayView.center;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed at: %@", NSStringFromCGPoint(location));
        self.trayView.center = CGPointMake(self.trayOriginalCenter.x,
                                          self.trayOriginalCenter.y + translation.y);
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended at: %@", NSStringFromCGPoint(location));
        if (trayVelocity.y > 0) {
            self.trayView.center = self.trayCenterWhenClosed;
            
        } else {
            self.trayView.center = self.trayCenterWhenOpen;
        }
    }
}

- (IBAction)smileyPan:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
 
    if (sender.state == UIGestureRecognizerStateBegan) {
        // Gesture recognizers know the view they are attached to
        UIImageView *imageView = (UIImageView *)sender.view;
        
        // Create a new image view that has the same image as the one currently panning
        self.newlyCreatedFace = [[UIImageView alloc] initWithImage:imageView.image];
        
        // Add the new face to the tray's parent view.
        [self.view addSubview:self.newlyCreatedFace];
        
        // Initialize the position of the new face.
        self.newlyCreatedFace.center = imageView.center;
        
        // Since the original face is in the tray, but the new face is in the
        // main view, you have to offset the coordinates
        CGPoint faceCenter = self.newlyCreatedFace.center;
        self.newlyCreatedFace.center = CGPointMake(faceCenter.x,
                                                   faceCenter.y + self.trayView.frame.origin.y);
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.newlyCreatedFace.center = location;
    }
}

@end
