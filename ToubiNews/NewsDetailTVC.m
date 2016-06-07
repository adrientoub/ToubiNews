//
//  NewsDetailTVC.m
//  ToubiNews
//
//  Created by Adrien Toubiana on 03/05/2016.
//  Copyright © 2016 Toub. All rights reserved.
//

#import "NewsDetailTVC.h"
#import "ApiConstants.h"
#import "NewsTableViewCell.h"

@implementation NewsDetailTVC
//
//  NewsDetailTVC.m
//  ToubiNews
//
//  Created by Adrien Toubiana on 08/06/15.
//  Copyright (c) 2015 ToubInc. All rights reserved.
//

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  self.newsList = [[NSMutableArray alloc] init];
  [self.tableView registerNib: [UINib nibWithNibName: @"NewsCell"
                                              bundle: [NSBundle mainBundle]]
              forCellReuseIdentifier: @"newsDetailCell"];

  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 200.0;

  [self.newsList addObject: self.news];
  [self getNewsDetails];
}

+ (NSDate *)parseDate:(NSString *)dateString
{
  NSDateFormatter *timestampFormater = [[NSDateFormatter alloc] init];
  [timestampFormater setLocale: [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
  [timestampFormater setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];

  NSDate *theDate = nil;
  NSError *error = nil;
  if (![timestampFormater getObjectValue:&theDate forString:dateString range:nil error:&error]) {
    NSLog(@"Date '%@' could not be parsed: %@", dateString, error);
  }

  return theDate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsDetailCell"
                                                            forIndexPath:indexPath];

  News* news = [self.newsList objectAtIndex: indexPath.row];
  [cell.titleLabel setText: news.subject];
  [cell.authorLabel setText: news.author];
  NSString* text = news.content;
  if (text == nil)
    text = @"";
  [cell.contentTextView setText: [text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
  NSDate* date = [NewsDetailTVC parseDate: news.creation_date];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateStyle = NSDateFormatterFullStyle;
  formatter.timeStyle = NSDateFormatterMediumStyle;
  [cell.dateLabel setText: [formatter stringFromDate: date]];
  [cell.newsgroupLabel setText: news.newsgroup];

  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.newsList count];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)displayError
{
}

- (void)getNewsDetails
{
  NSString* strURL = [NSString stringWithFormat:@"%@%@/%d", kAPI_BASE_URL, kAPI_TOPIC, [self.news iId]];
  NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
  NSURLSession *session = [NSURLSession sharedSession];
  [[session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                            NSURLResponse *response, NSError *error)
    {
      NSError* jsonError;
      if (!error && [response isKindOfClass:[NSHTTPURLResponse class]] &&
          ((NSHTTPURLResponse *)response).statusCode == 200)
      {
        NSDictionary *arrayJson = [NSJSONSerialization JSONObjectWithData: data
                                                                  options: NSJSONReadingMutableContainers error: &jsonError];
        if (!jsonError)
        {
          [self fetchDatas: arrayJson];
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

- (void)fetchDatas:(NSDictionary*)jsonArray
{
  NSLog(@"JSON: %@", jsonArray);
  dispatch_async(dispatch_get_main_queue(), ^{
    [self parseJSON: jsonArray];
    [self.tableView reloadData];
  });
}

-(void)parseNews: (NSDictionary*)jsonArray
{
  News* news = [[News alloc] init];
  news.iId = [[jsonArray objectForKey:@"id"] intValue];
  news.uid = [jsonArray objectForKey:@"uid"];
  news.subject = [jsonArray objectForKey:@"subject"];
  news.author = [jsonArray objectForKey:@"author"];
  news.creation_date = [jsonArray objectForKey:@"creation_date"];
  news.content = [jsonArray objectForKey:@"content"];
  news.newsgroup = [[jsonArray objectForKey:@"groups"] objectAtIndex: 0];
  [self.newsList addObject: news];

  NSArray* children = [jsonArray objectForKey:@"children"];
  for (NSDictionary* newsObject in children)
  {
    [self parseNews: newsObject];
  }
}

- (void)parseJSON:(NSDictionary*)jsonArray
{
  [self.newsList removeAllObjects];
  [self parseNews: jsonArray];
}

@end
