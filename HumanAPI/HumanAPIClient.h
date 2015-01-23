//
//  HumanAPIClient.h
//  HumanAPI client implementation
//

#import "AFHTTPSessionManager.h"

@class HumanAPIClient;

// ----  ----  ----  ----
// ENTITIES
// ----  ----  ----  ----

/**
 * Basic entity class.
 */
@interface HumanAPIClientAbstractEntity : NSObject
@property (nonatomic, weak)HumanAPIClient *client;
@property NSString *masterPath;
- (instancetype)initWithClient:(HumanAPIClient *)client
                 andMasterPath:(NSString *)masterPath;
@end

/**
 * Base class for data types that organized in lists with
 * possibility to access details of each object from the same end point.
 * (List queries can be filtered)
 *
 * Used for medical end point for now but not limited to them.
 */
@interface HumanAPIClientAbstractListableEntity : HumanAPIClientAbstractEntity
- (void)listWithOnSuccess:(void (^)(id responseObject))success
                onFailure:(void (^)(NSError *error))failure;
- (void)get:(NSString *)objId
  onSuccess:(void (^)(id responseObject))success
  onFailure:(void (^)(NSError *error))failure;
@end

/**
 * Base class for data types that are discrete measurements and
 * occur at a point in time.
 */
@interface HumanAPIClientAbstractMeasurementEntity : HumanAPIClientAbstractEntity
- (void)latestWithOnSuccess:(void (^)(id responseObject))success
                  onFailure:(void (^)(NSError *error))failure;
- (void)readingsWithOnSuccess:(void (^)(id responseObject))success
                    onFailure:(void (^)(NSError *error))failure;
- (void)reading:(NSString *)objId
      onSuccess:(void (^)(id responseObject))success
      onFailure:(void (^)(NSError *error))failure;
- (void)dailyWithOnSuccess:(void (^)(id responseObject))success
                 onFailure:(void (^)(NSError *error))failure;
- (void)dailyForDay:(NSDate *)day
          onSuccess:(void (^)(id responseObject))success
          onFailure:(void (^)(NSError *error))failure;
@end

/**
 * Base class for data types that occur in time periods
 * with a start and end time.
 *
 * These can be things such as a walk, sleep, or location,
 * that start at a certain time and end at a certain time.
 */
@interface HumanAPIClientAbstractPeriodicalEntity : HumanAPIClientAbstractEntity
- (void)listWithOnSuccess:(void (^)(id responseObject))success
              onFailure:(void (^)(NSError *error))failure;
- (void)get:(NSString *)objId
onSuccess:(void (^)(id responseObject))success
onFailure:(void (^)(NSError *error))failure;
- (void)dailyWithOnSuccess:(void (^)(id responseObject))success
               onFailure:(void (^)(NSError *error))failure;
- (void)dailyForDay:(NSDate *)day
        onSuccess:(void (^)(id responseObject))success
        onFailure:(void (^)(NSError *error))failure;
- (void)summaryWithOnSuccess:(void (^)(id responseObject))success
                 onFailure:(void (^)(NSError *error))failure;
- (void)summaryForDay:(NSDate *)day
          onSuccess:(void (^)(id responseObject))success
          onFailure:(void (^)(NSError *error))failure;
@end

// Human Entity
@interface HumanAPIClientHumanEntity : HumanAPIClientAbstractEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
- (void)getWithOnSuccess:(void (^)(id responseObject))success
               onFailure:(void (^)(NSError *error))failure;
@end

// Profile Entity
@interface HumanAPIClientProfileEntity : HumanAPIClientAbstractEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
- (void)getWithOnSuccess:(void (^)(id responseObject))success
               onFailure:(void (^)(NSError *error))failure;
@end

// Genetic Trait Entity
@interface HumanAPIClientGeneticTraitEntity : HumanAPIClientAbstractEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
- (void)listWithOnSuccess:(void (^)(id responseObject))success
                onFailure:(void (^)(NSError *error))failure;
@end

// Blood Glucose Entity
@interface HumanAPIClientBloodGlucoseEntity : HumanAPIClientAbstractMeasurementEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// Blood Oxygen Entity
@interface HumanAPIClientBloodOxygenEntity : HumanAPIClientAbstractMeasurementEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// Blood Pressure Entity
@interface HumanAPIClientBloodPressureEntity : HumanAPIClientAbstractMeasurementEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// BMI Entity
@interface HumanAPIClientBMIEntity : HumanAPIClientAbstractMeasurementEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// Body Fat Entity
@interface HumanAPIClientBodyFatEntity : HumanAPIClientAbstractMeasurementEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// Heart Rate Entity
@interface HumanAPIClientHeartRateEntity : HumanAPIClientAbstractMeasurementEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// Height Entity
@interface HumanAPIClientHeightEntity : HumanAPIClientAbstractMeasurementEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// Weight Entity
@interface HumanAPIClientWeightEntity : HumanAPIClientAbstractMeasurementEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// Activity Entity
@interface HumanAPIClientActivityEntity : HumanAPIClientAbstractPeriodicalEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// Location Entity
@interface HumanAPIClientLocationEntity : HumanAPIClientAbstractPeriodicalEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// Sleep Entity
@interface HumanAPIClientSleepEntity : HumanAPIClientAbstractPeriodicalEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// MedicalAllergy Entity
@interface HumanAPIClientMedicalAllergyEntity : HumanAPIClientAbstractListableEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// MedicalEncounter Entity
@interface HumanAPIClientMedicalEncounterEntity : HumanAPIClientAbstractListableEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// MedicalImmunization Entity
@interface HumanAPIClientMedicalImmunizationEntity : HumanAPIClientAbstractListableEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// MedicalIssue Entity
@interface HumanAPIClientMedicalIssueEntity : HumanAPIClientAbstractListableEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// MedicalMedication Entity
@interface HumanAPIClientMedicalMedicationEntity : HumanAPIClientAbstractListableEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// MedicalTestResult Entity
@interface HumanAPIClientMedicalTestResultEntity : HumanAPIClientAbstractListableEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// ----  ----  ----  ----
// CLIENT
// ----  ----  ----  ----

@protocol HumanAPIClientDelegate;

@interface HumanAPIClient : AFHTTPSessionManager

@property (nonatomic, weak) id<HumanAPIClientDelegate>delegate;
@property NSString *accessToken;

+ (HumanAPIClient *)sharedHumanAPIClient;
- (instancetype)init;
- (void)execute:(NSString *)path
    onSuccess:(void (^)(id responseObject))success
    onFailure:(void (^)(NSError *error))failure;
- (void)execute:(NSString *)path withParameters:(NSMutableDictionary *)parameters
      onSuccess:(void (^)(id responseObject))success
      onFailure:(void (^)(NSError *error))failure;
- (HumanAPIClientHumanEntity *)human;
- (HumanAPIClientProfileEntity *)profile;
- (HumanAPIClientGeneticTraitEntity *)geneticTrait;
- (HumanAPIClientBloodGlucoseEntity *)bloodGlucose;
- (HumanAPIClientBloodOxygenEntity *)bloodOxygen;
- (HumanAPIClientBloodPressureEntity *)bloodPressure;
- (HumanAPIClientBMIEntity *)bmi;
- (HumanAPIClientBodyFatEntity *)bodyFat;
- (HumanAPIClientHeartRateEntity *)heartRate;
- (HumanAPIClientHeightEntity *)height;
- (HumanAPIClientWeightEntity *)weight;
- (HumanAPIClientActivityEntity *)activity;
- (HumanAPIClientLocationEntity *)location;
- (HumanAPIClientLocationEntity *)sleep;
- (HumanAPIClientMedicalAllergyEntity *)medicalAllergy;
- (HumanAPIClientMedicalEncounterEntity *)medicalEncounter;
- (HumanAPIClientMedicalImmunizationEntity *)medicalImmunization;
- (HumanAPIClientMedicalIssueEntity *)medicalIssue;
- (HumanAPIClientMedicalMedicationEntity *)medicalMedication;
- (HumanAPIClientMedicalTestResultEntity *)medicalTestResult;
@end

@protocol HumanAPIClientDelegate <NSObject>
@optional
-(void)humanAPIClient:(HumanAPIClient *)client didUpdateWithData:(id)data;
-(void)humanAPIClient:(HumanAPIClient *)client didFailWithError:(NSError *)error;
@end
