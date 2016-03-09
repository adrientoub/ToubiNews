//
//  RecentNewsTVC.m
//  ToubiNews
//
//  Created by Adrien Toubiana on 08/06/15.
//  Copyright (c) 2016 ToubInc. All rights reserved.
//

#import "RecentNewsTVC.h"
#import "NewsDetailVC.h"
#import "News.h"
#import "ApiConstants.h"

@interface RecentNewsTVC ()

@end

@implementation RecentNewsTVC

- (void)viewDidLoad {
  [super viewDidLoad];
    
  self.newsArray = [[NSMutableArray alloc] init];

  [self getNews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displayError
{}

- (void)getNews
{
  if (self.updating)
    return;
  self.updating = YES;
  NSString* strURL;
  strURL = [NSString stringWithFormat:@"%@/%@/last?limit=%d&names", kAPI_BASE_URL, kNG_HOST, kRECENT_COUNT];

  [self loadJSON:strURL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  unsigned long count = [self.newsArray count];
  return count;
}

-(UIColor*)backgroundColorForSelectedCellAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  return [UIColor colorWithRed: kSELECTED_RED / 255.0
                         green: kSELECTED_GREEN / 255.0
                          blue: kSELECTED_BLUE / 255.0
                         alpha: 1];
}

-(UIColor*)backgroundColorForCellAtIndexPath:(nonnull NSIndexPath *)indexPath withTableView:(UITableView*)tableView
{
  CGFloat upRed = 2.;
  CGFloat downRed = 31.;
  CGFloat upGreen = 94.;
  CGFloat downGreen = 122.;
  CGFloat upBlue = 146.;
  CGFloat downBlue = 172.;
  NSInteger row = indexPath.row;

  CGFloat red = (row % 2 == 0 ? upRed : downRed) / 255.;
  CGFloat green = (row % 2 == 0 ? upGreen : downGreen) / 255.;
  CGFloat blue = (row % 2 == 0 ? upBlue : downBlue) / 255.;
  return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell"
                                                          forIndexPath:indexPath];
  cell.userInteractionEnabled = YES;

  if ([self.newsArray count] == 0)
  {
    [self getNews];
  }
  if (indexPath.row < [self.newsArray count])
  {
    News* news = [self.newsArray objectAtIndex:indexPath.row];
    [cell.textLabel setText: [news subject]];
    [cell.detailTextLabel setText: [NSString stringWithFormat:@"%@\n%@", news.author, news.newsgroup]];
  }

  UIColor* color = [self backgroundColorForCellAtIndexPath:indexPath withTableView:tableView];
  cell.contentView.backgroundColor = color;
  cell.textLabel.backgroundColor = color;
  cell.detailTextLabel.backgroundColor = color;

  cell.selectionStyle = UITableViewCellSelectionStyleDefault;
  UIView* selectionColor = [[UIView alloc] init];
  selectionColor.backgroundColor = [self backgroundColorForSelectedCellAtIndexPath:indexPath];
  cell.selectedBackgroundView = selectionColor;

  cell.textLabel.textColor = [UIColor whiteColor];
  cell.detailTextLabel.textColor = [UIColor whiteColor];

  return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view

  NewsDetailVC* detail = [segue destinationViewController];
  NSIndexPath* index = [self.tableView indexPathForCell:sender];
  [detail setNews:[self.newsArray objectAtIndex: index.row]];
}

-(void)loadJSON:(NSString*)strURL
{
  NSLog(@"%@", strURL);

  NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
  NSURLSession *session = [NSURLSession sharedSession];
  [[session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                            NSURLResponse *response, NSError *error)
    {
      NSError* jsonError;
      if (!error && [response isKindOfClass:[NSHTTPURLResponse class]] &&
          ((NSHTTPURLResponse *)response).statusCode == 200)
      {
        NSArray *arrayJson = [NSJSONSerialization JSONObjectWithData: data
                                                             options: NSJSONReadingMutableContainers error: &jsonError];

        if (!jsonError)
        {
          [self fetchDatas:arrayJson];
        }
        else
        {
          NSLog(@"json convertion error");
        }
      }
      else
      {
        [self displayError];
      }
    }] resume];
}

- (void)fetchDatas:(NSArray*)jsonArray
{
  NSLog(@"JSON: %@", jsonArray);
  [self parseNews:jsonArray];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
  });
  self.updating = false;
}

- (void)parseNews:(NSArray*)jsonArray
{
  for (NSDictionary* newsDico in jsonArray)
  {
    News* newsTmp = [[News alloc] init];
    newsTmp.iId = [[newsDico objectForKey:@"id"] intValue];
    newsTmp.uid = [newsDico objectForKey:@"uid"];
    newsTmp.subject = [newsDico objectForKey:@"subject"];
    newsTmp.author = [newsDico objectForKey:@"author"];
    newsTmp.creation_date = [newsDico objectForKey:@"creation_date"];
    newsTmp.newsgroup = [newsDico objectForKey:@"groups"][0];

    [self.newsArray addObject:newsTmp];
  }
}

@end
