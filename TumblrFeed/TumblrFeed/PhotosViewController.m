//
//  PhotosViewController.m
//  TumblrFeed
//
//  Created by Nico Salinas on 6/27/18.
//  Copyright © 2018 Nico Salinas. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"
#import "UIImageView+AFNetworking.h"


@interface PhotosViewController() <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tumblrTableView;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            // Get the dictionary from the response key
            NSDictionary *responseDictionary = dataDictionary[@"response"];
            // Store the returned array of dictionaries in our posts property
            self.posts = responseDictionary[@"posts"];
             [self.tumblrTableView reloadData];
            // TODO: Get the posts and store in posts property
            // TODO: Reload the table view
        }
    }];
    [task resume];
    // Do any additional setup after loading the view.

    self.tumblrTableView.dataSource = self;
    self.tumblrTableView.delegate = self;
    self.tumblrTableView.rowHeight = 240;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tumblrTableView numberOfRowsInSection:(NSInteger)section {
    return _posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
    //cell.textLabel.text = [NSString stringWithFormat:@"This is row %ld", (long)indexPath.row];
    
    NSDictionary *post = self.posts[indexPath.row];
    NSArray *photos = post[@"photos"];
    
    NSDictionary *photo = photos[0];
    NSDictionary *originalSize =  photo[@"original_size"];
    NSString *urlString = originalSize[@"url"];
    NSURL *url = [NSURL URLWithString:urlString];
    [cell.PhotoImageView setImageWithURL:url];
    return cell;


}

/*
 

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
