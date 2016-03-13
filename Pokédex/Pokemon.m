//
//  Pokemon.m
//  Pokédex
//
//  Created by Jellopy on 12/1/2558 BE.
//  Copyright © 2558 Jellopy. All rights reserved.
//

#import "Pokemon.h"

@implementation Pokemon

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.title = dict[@"title"];
        self.subtitle = dict[@"subtitle"];
        self.slug = [[[self.title lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"] stringByReplacingOccurrencesOfString:@"." withString:@""];
        self.modelImageName = [NSString stringWithFormat:@"%@_model.png", self.slug];
        self.iconImageName = [NSString stringWithFormat:@"%@_icon.png", self.slug];
        self.pinImageName = @"pokeball";
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.subtitle forKey:@"subtitle"];
    [coder encodeObject:self.slug forKey:@"slug"];
    [coder encodeObject:self.modelImageName forKey:@"modelImageName"];
    [coder encodeObject:self.iconImageName forKey:@"iconImageName"];
    [coder encodeObject:self.pinImageName forKey:@"pinImageName"];
    [coder encodeFloat:self.coordinate.latitude forKey:@"latitude"];
    [coder encodeFloat:self.coordinate.longitude forKey:@"longitude"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.title = [coder decodeObjectForKey:@"title"];
        self.subtitle = [coder decodeObjectForKey:@"subtitle"];
        self.slug = [coder decodeObjectForKey:@"slug"];
        self.modelImageName = [coder decodeObjectForKey:@"modelImageName"];
        self.iconImageName = [coder decodeObjectForKey:@"iconImageName"];
        self.pinImageName = [coder decodeObjectForKey:@"pinImageName"];
        self.coordinate = CLLocationCoordinate2DMake([coder decodeFloatForKey:@"latitude"], [coder decodeFloatForKey:@"longitude"]);
    }
    
    return self;
}

@end
