//
//  HistoryViewController.h
//  Pokédex
//
//  Created by Jellopy on 12/9/2558 BE.
//  Copyright © 2558 Jellopy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Pokemon.h"
#import "HistoryAnnotation.h"

@interface HistoryViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) Pokemon *pokemon;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
