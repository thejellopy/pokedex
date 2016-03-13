//
//  HistoryViewController.m
//  Pokédex
//
//  Created by Jellopy on 12/9/2558 BE.
//  Copyright © 2558 Jellopy. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.title = @"Worldmap";
    self.mapView.delegate = self;
    [self pinHistoryAnnotation];
    [self moveMapViewport];
}

- (void)pinHistoryAnnotation {
    HistoryAnnotation *historyAnnotation = [[HistoryAnnotation alloc] initWithPokemon:self.pokemon];
    [self.mapView addAnnotation:historyAnnotation];
}

- (void)moveMapViewport {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.pokemon.coordinate, 800, 800);
    [self.mapView setRegion:region animated:YES];
    NSLog(@"%@", [NSString stringWithFormat:@"moveMapViewport latitude: %f, longitude: %f",
                  self.pokemon.coordinate.latitude,
                  self.pokemon.coordinate.longitude]);
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[HistoryAnnotation class]]) {
        HistoryAnnotation *newAnnotation = (HistoryAnnotation *)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"HISTORY_ANNOTATION"];
        
        if (annotationView) {
            annotationView.annotation = annotation;
            NSLog(@"using existing HistoryAnnotation with reuseIdentifier");
        } else {
            annotationView = newAnnotation.annotationView;
            NSLog(@"creating new HistoryAnnotation with reuseIdentifier");
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
