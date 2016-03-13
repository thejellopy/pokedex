//
//  PokemonAnnotation.h
//  Pokédex
//
//  Created by Jellopy on 12/1/2558 BE.
//  Copyright © 2558 Jellopy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Pokemon.h"

@interface PokemonAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) Pokemon *pokemon;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (id)initWithPokemon:(Pokemon *)pokemon;

- (MKAnnotationView *)annotationView;

@end
