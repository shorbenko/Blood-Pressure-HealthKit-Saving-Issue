//
//  ViewController.m
//  Blood-Pressure-HealthKit-Saving-Issue
//
//  Created by Serhii Horbenko on 12/7/17.
//  Copyright © 2017 Serhii. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (atomic,strong) HKHealthStore * healthStore;
@property NSTimer *timer;
@property HKQueryAnchor *savedAnchor;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.healthStore = [HKHealthStore new];
    [self requestAuthorization];
}

#pragma mark - HealthKit

-(void)requestAuthorization
{
    NSSet * requestedTypesSet = [[NSSet alloc] initWithObjects: [HKQuantityType quantityTypeForIdentifier: HKQuantityTypeIdentifierBloodPressureSystolic],
                                 [HKQuantityType quantityTypeForIdentifier: HKQuantityTypeIdentifierBloodPressureDiastolic], nil];
    
    [self.healthStore requestAuthorizationToShareTypes: requestedTypesSet readTypes:requestedTypesSet completion:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"Authorization status: %@, error: %@",@(success),error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self readBloodPressure];
        });
    }];
}

- (void)saveBloodPressureIntoHealthStoreWithSystolic:(double)systolic diastolic:(double)diastolic
{
    HKUnit *unit = [HKUnit millimeterOfMercuryUnit];
    HKQuantity *systolicQuantity = [HKQuantity quantityWithUnit:unit doubleValue:systolic];
    HKQuantity *diastolicQuantity = [HKQuantity quantityWithUnit:unit doubleValue:diastolic];
    
    HKQuantityType *systolicType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    HKQuantityType *diastolicType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    
    NSDate *now = [NSDate date];
    
    HKQuantitySample *systolicSample = [HKQuantitySample quantitySampleWithType:systolicType quantity:systolicQuantity startDate:now endDate:now];
    HKQuantitySample *diastolicSample = [HKQuantitySample quantitySampleWithType:diastolicType quantity:diastolicQuantity startDate:now endDate:now];
    
    NSSet *objects=[NSSet setWithObjects:systolicSample,diastolicSample, nil];
    
    HKCorrelationType *bloodPressureType = [HKObjectType correlationTypeForIdentifier:HKCorrelationTypeIdentifierBloodPressure];
    
    HKCorrelation *bloodPressure = [HKCorrelation correlationWithType:bloodPressureType startDate:now endDate:now objects:objects];
    
    [self.healthStore saveObject:bloodPressure withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"An error occured saving the Blood Pressure sample %@. The error was: %@.", bloodPressure, error);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Blood Pressure sample saved: %@",bloodPressure);
            });
        }
    }];
}

-(void)saveBloodPressure
{
    [self saveBloodPressureIntoHealthStoreWithSystolic:140.0 diastolic:90.0];
}

-(void)readBloodPressure
{
    __weak typeof(self) weakSelf = self;
    HKCorrelationType *bloodPressureType = [HKObjectType correlationTypeForIdentifier:HKCorrelationTypeIdentifierBloodPressure];
    
    HKAnchoredObjectQuery * anchoredObjectQuery = [[HKAnchoredObjectQuery alloc] initWithType:bloodPressureType
                                                                                    predicate:nil
                                                                                       anchor:self.savedAnchor
                                                                                        limit:HKObjectQueryNoLimit
                                                                               resultsHandler:^(HKAnchoredObjectQuery *query, NSArray<__kindof HKSample *> * __nullable results, NSArray<HKDeletedObject *> * __nullable deletedObjects, HKQueryAnchor * __nullable newAnchor, NSError * __nullable error) {
                                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                                       NSLog(@"Blood Pressure Anchored Object Query results: %@, error: %@",results, error);
                                                                                       weakSelf.savedAnchor = newAnchor;
                                                                                   });
                                                                               }];
    [self.healthStore executeQuery:anchoredObjectQuery];
}

#pragma mark - Actions

- (IBAction)addNowAction:(id)sender
{
    [self saveBloodPressure];
}

- (IBAction)launchTimerAction:(id)sender
{
    NSLog(@"Timer Scheduled!");
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:20 repeats:NO block:^(NSTimer * _Nonnull timer) {
        NSLog(@"Timer Fires!");
        [weakSelf saveBloodPressure];
    }];
}

- (IBAction)readBloodPressureAction:(id)sender
{
    [self readBloodPressure];
}
@end
