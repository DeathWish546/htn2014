#import "ViewController.h"

@interface ViewController () {
    AVAudioRecorder *recorder;
    AVAudioPlayer *player, *player_background;
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
                               @"MyAudioMemo_1.m4a",
                               nil];

    NSURL *recordedURL = [NSURL fileURLWithPathComponents:pathComponents];
    NSURL *backgroundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MorrisonTrioSample-AirbyJSBach" ofType:@"m4a"]];

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
    [soundsArray addObject:player_background];
    for (AVAudioPlayer *a in soundsArray) [a prepareToPlay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordWithPlayer:(id)sender {
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
        [recorder record];
        [recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        
        [player_background setDelegate:self];
        [player_background play];
        
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
    
   /*NSString *urlString = @"localhost:9292/upload.php";
    NSString *filename = @"MyAudioMemo_1";
    NSMutableURLRequest *request= [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.m4a\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:YOUR_NSDATA_HERE]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", returnString);*/
}

- (IBAction)playTapped:(id)sender {
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [soundsArray addObject:player];
        
        for(AVAudioPlayer *a in soundsArray) a.currentTime = 0;
        for(AVAudioPlayer *a in soundsArray) [a play];
        
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
