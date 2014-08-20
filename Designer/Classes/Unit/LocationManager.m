//
//  LocationManager.m
//  Movie
//
//  Created by bejoy on 14-1-17.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "LocationManager.h"


@implementation LocationManager

static LocationManager *instanceControl;

+ (LocationManager *)share
{
    if (instanceControl == nil)
    {
        instanceControl = [[LocationManager alloc] init];
    }
    return instanceControl;
}

#pragma mark location

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
//    checkinLocation = newLocation;
    //do something else
}

- (void) setupLocationManager {
    locManager = [[CLLocationManager alloc] init];
    locManager.delegate = self;
    locManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [locManager startUpdatingLocation];
    locManager.distanceFilter = 1000.0f;
    
    _currentLatitude = [[NSString alloc]
                           initWithFormat:@"%g",
                           locManager.location.coordinate.latitude];
    _currentLongitude = [[NSString alloc]
                            initWithFormat:@"%g",
                            locManager.location.coordinate.longitude];
    
}

- (BOOL)getLocationServicesEnabled
{
    if ([CLLocationManager locationServicesEnabled] &&
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    }
    else {
        return YES;
    }
}

- (void)getCityName
{
    NSString * str1 = @"http://maps.google.com/maps/api/geocode/json?latlng=";
    NSString * str2 = @",";
    NSString * str3 = @"&language=zh-CN&sensor=true";
    NSString * string = @"";
    string = [string stringByAppendingFormat:@"%@%@%@%@%@",str1,_currentLatitude,str2,_currentLongitude,str3];
    NSURL *url = [NSURL URLWithString:string];
    NSLog(@"%@",string);
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *citystring = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
 

    NSDictionary *dict = [citystring objectFromJSONString];
    
    if ([[dict objectForKey:@"status"] isEqualToString:@"OK"]) {
        
        NSString *name = [[[[[dict objectForKey:@"results"]  objectAtIndex:1] objectForKey:@"address_components"] objectAtIndex:2] objectForKey:@"short_name"];
        
        _cityName=  name ;
    }

    
 
}

- (NSString *)getCityID
{
    
//        NSString *cityId = [[ZHDBData share] getCityIDFromCityName:_cityName];
        return @"";
}

@end
