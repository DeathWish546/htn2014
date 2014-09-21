#import "ViewController.h"

@interface ViewController () {
    AVAudioRecorder *recorder;
    AVAudioPlayer *player, *player_background, *player_background2;
    NSMutableArray *soundsArray;
}

@end

@implementation ViewController
@synthesize stopButton, playButton, recordPauseButton;

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define DOCUMENTS_FOLDER1 [DOCUMENTS_FOLDER stringByAppendingPathComponent:@"Recordering"]
#define FILEPATH [DOCUMENTS_FOLDER stringByAppendingPathComponent:[self dateString]]

- (void)viewDidLoad

{
    [super viewDidLoad];
	
    soundsArray = [NSMutableArray new];
    
    // Disable Stop/Play button when application launches
    [stopButton setEnabled:NO];
    [playButton setEnabled:NO];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"a.m4a",
                               nil];

    NSURL *recordedURL = [NSURL fileURLWithPathComponents:pathComponents];
    NSURL *backgroundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MorrisonTrioSample-AirbyJSBach" ofType:@"m4a"]];
    
    NSString *stringURL = @"http://localhost:9292/files/MyAudioMemo_1.m4a";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    NSString *filePath;
    if ( urlData )
    {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"MyAudioMemo_1.m4a"];
        [urlData writeToFile:filePath atomically:YES];
    }

    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];

    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:recordedURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
    player_background = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundURL error:nil];
    //[soundsArray addObject:player_background];
    
    NSURL *backgroundURL2 = [NSURL fileURLWithPath:filePath];
    player_background2 = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundURL2 error:nil];
    [player_background2 play];
    //[soundsArray addObject:player_background2];
    
    for (AVAudioPlayer *a in soundsArray) [a prepareToPlay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordPauseTapped:(id)sender {
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        
    
        [player_background2 setDelegate:self];
        [player_background2 play];
       
        [recorder performSelector:@selector(record) withObject:nil afterDelay:70.0/1000.0];
        [recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        
        //[player_background2 play];
        
        printf("Hello");

    } else {

        // Pause recording
        [recorder pause];
        [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    }

    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
}

//Stop audio session
- (IBAction)stopTapped:(id)sender {
    [recorder stop];
    for(AVAudioPlayer *a in soundsArray) [a stop];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
   /*NSString *urlString = @"http://localhost:9292/files/MyAudioMemo_1.m4a";
    NSString *filename = @"MyAudioMemo_1";
    
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"MyAudioMemo_1.m4a\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [[NSData alloc] initWithContentsOfFile:[recorder.url path]];
    [postbody appendData:[NSData dataWithData:data]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", returnString);*/
    
    
    /*start of new one
   // NSData *file1Data = [[NSData alloc] initWithContentsOfFile:[recorder.url path]];
    //NSString *urlString = @"http://localhost:9292/upload";
    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
    
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    
//    NSMutableData *body = [NSMutableData data];
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"MyAudioMemo_1.m4a\"\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[NSData dataWithData:file1Data]];
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [request setHTTPBody:body];
//    */
  
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"filename": @"a.m4a"};
    NSURL *filePath = recorder.url;
    [manager POST:@"http://localhost:9292/upload" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"file" error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    //NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    
    //NSLog(@"Return String= %@",returnString);
    
    printf("TETS");
}

- (IBAction)playTapped:(id)sender {
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [soundsArray addObject:player];
        [player play];
        //for(AVAudioPlayer *a in soundsArray) a.currentTime = 0;
        //for(AVAudioPlayer *a in soundsArray) [a play];
        
        [stopButton setEnabled:YES];
    }
}

#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    [stopButton setEnabled:NO];
    [playButton setEnabled:YES];    
}

#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [player_background stop];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                               message: @"Finish playing the recording!"
                              delegate: nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    [alert show];
}



@end
