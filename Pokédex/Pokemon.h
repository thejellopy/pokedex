//
//  Pokemon.h
//  Pokédex
//
//  Created by Jellopy on 12/1/2558 BE.
//  Copyright © 2558 Jellopy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Pokemon : NSObject <NSCoding>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *slug;
@property (copy, nonatomic) NSString *modelImageName;
@property (copy, nonatomic) NSString *iconImageName;
@property (copy, nonatomic) NSString *pinImageName;
@property (strong, nonatomic) UIImage *modelImage;
@property (strong, nonatomic) UIImage *iconImage;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
