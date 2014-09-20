#import "APPViewController.h"

@interface APPViewController ()

@end

@implementation APPViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.movieController = [[MPMoviePlayerController alloc] init];
    [self.movieController setContentURL:self.movieURL];
    
    [self.movieController.view setFrame:CGRectMake ( 0, 0, 320, 476)];
    
    [self.view addSubview:self.movieController.view];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(moviePlayBackDidFinish:)
                                          name:MPMoviePlayerPlaybackDidFinishNotification
                                          object:self.movieController];
    [self.movieController play];
    
}


- (IBAction)takeVideo:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.movieURL = info[UIImagePickerControllerMediaURL];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
 */

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString*)kUTTypeMovie]) {
        //save the video
        self.movieURL = [info objectForKey:UIImagePickerControllerMediaURL];
        UISaveVideoAtPathToSavedPhotosAlbum([self.movieURL relativePath], self, @selector(movie:didFinishSavingWithError:contextInfo:), nil);
    }
    //self.movieURL = info[UIImagePickerControllerMediaURL];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)movie:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)moviePlayBackDidFinish:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [self.movieController stop];
    [self.movieController.view removeFromSuperview];
    self.movieController = nil;
     
}

@end
