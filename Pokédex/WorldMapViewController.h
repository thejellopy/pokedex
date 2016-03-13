//
//  WorldMapViewController.h
//  Pokédex
//
//  Created by Jellopy on 12/1/2558 BE.
//  Copyright © 2558 Jellopy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "Pokemon.h"
#import "PokemonAnnotation.h"

@interface WorldMapViewController : UIViewController <MKMapViewDelegate,  CLLocationManagerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (strong, nonatomic) IBOutlet UIButton *trackButton;
@property (strong, nonatomic) IBOutlet UIButton *standardButton;
@property (strong, nonatomic) IBOutlet UIButton *satelliteButton;
@property (strong, nonatomic) IBOutlet UIButton *hybridButton;

@property (strong, nonatomic) NSArray *pokemons;

@end
