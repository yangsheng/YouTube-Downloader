//
//  iPhoneDownloadsViewController.m
//  Youtube_DL
//
//  Created by Majd Alfhaily on 10/2/13.
//  Copyright (c) 2013 Majd Alfhaily. All rights reserved.
//

#import "iPhoneDownloadsViewController.h"

@interface iPhoneDownloadsViewController ()

@end

@implementation iPhoneDownloadsViewController

NSArray *filesArray;
NSString *docDir;
MPMoviePlayerViewController *moviePlayerViewController;

- (NSString *)findDoc
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return docDir;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Downloads";
    [self findDoc];
    filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docDir error:nil];
    filesArray = [filesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.mp4'"]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(closeView)];
    if (![filesArray count] == 0)
    {
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    cell.textLabel.text = filesArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlToSaveFile = [docDir stringByAppendingPathComponent:filesArray[indexPath.row]];
    urlToSaveFile = [@"file://" stringByAppendingString:urlToSaveFile];
    urlToSaveFile = [urlToSaveFile stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self saveToCameraRoll:[NSURL URLWithString:urlToSaveFile]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [[NSFileManager defaultManager] removeItemAtPath:[docDir stringByAppendingPathComponent:filesArray[indexPath.row]] error:nil];
        filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docDir error:nil];
        filesArray = [filesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.mp4'"]];
        [self.tableView reloadData];
    }
    
}


- (void) saveToCameraRoll:(NSURL *)srcURL
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    ALAssetsLibraryWriteVideoCompletionBlock videoWriteCompletionBlock =
    ^(NSURL *newURL, NSError *error) {
        if (!error) {
        [[[TWNotification alloc] init]initWithTitle:@"Video"
                                                message:@"Saved to Camera Roll"
                                              alignment:Center
                                              withStyle:TWNotificationStyleSuccess
                                      orUseACustomColor:nil
                                                 inView:self.navigationController.view
                                              hideAfter:1.5f];
        }
    };
    
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:srcURL])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:srcURL
                                    completionBlock:videoWriteCompletionBlock];
    } else
    {
        [[[TWNotification alloc] init]initWithTitle:@"Video"
                                            message:@"Video type not supported"
                                          alignment:Center
                                          withStyle:TWNotificationStyleError
                                  orUseACustomColor:nil
                                             inView:self.navigationController.view
                                          hideAfter:1.5f];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *videoPath = [docDir stringByAppendingPathComponent:filesArray[indexPath.row]];
    videoPath = [@"file://" stringByAppendingString:videoPath];
    videoPath = [videoPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self prepareMoviePlayer:[NSURL URLWithString:videoPath]];
}

-(void)prepareMoviePlayer:(NSURL *)moviePath {
    moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:moviePath];
    if ([[moviePlayerViewController moviePlayer] respondsToSelector:@selector(loadState)]) {
        [[moviePlayerViewController moviePlayer] setControlStyle:MPMovieControlStyleFullscreen];
        [[moviePlayerViewController moviePlayer] setFullscreen:NO];
        [[moviePlayerViewController moviePlayer] prepareToPlay];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerLoadStateDidChange:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieEventFullscreenHandler:)
                                                     name:MPMoviePlayerWillEnterFullscreenNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieEventFullscreenHandler:)
                                                     name:MPMoviePlayerDidEnterFullscreenNotification
                                                   object:nil];
        

    }
}

- (void)movieEventFullscreenHandler:(NSNotification*)notification {
    [[moviePlayerViewController moviePlayer] setFullscreen:NO animated:NO];
    [[moviePlayerViewController moviePlayer] setControlStyle:MPMovieControlStyleEmbedded];
}

    
- (void)moviePlayerLoadStateDidChange:(NSNotification *)notification {
        if ([[moviePlayerViewController moviePlayer] loadState] == MPMovieLoadStateStalled) {
            //NSLog(@"Movie Playback Stalled");
        } else if([[moviePlayerViewController moviePlayer] loadState] != MPMovieLoadStateUnknown) {
            
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:MPMoviePlayerLoadStateDidChangeNotification
                                                          object:nil];
            
            [[[moviePlayerViewController moviePlayer] view] setFrame:self.view.bounds];
            [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
            [[moviePlayerViewController moviePlayer] play];
        }
    }


- (void)closeView
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
