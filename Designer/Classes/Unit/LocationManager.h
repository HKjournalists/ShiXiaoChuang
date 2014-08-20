//
//  LocationManager.h
//  Movie
//
//  Created by bejoy on 14-1-17.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject<CLLocationManagerDelegate>
{

    CLLocationManager *locManager;
}

@property(nonatomic, retain) NSString * currentLatitude;
@property(nonatomic, retain) NSString * currentLongitude;
@property(nonatomic, retain) NSString * cityName;
@property(nonatomic, retain) NSString * cityID;


+ (LocationManager *)share;

- (void)setupLocationManager;
- (BOOL)getLocationServicesEnabled;


- (NSString *)getCityID;

@end
