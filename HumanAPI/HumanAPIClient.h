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


@interface HumanAPIClientAbstractObjectEntity: HumanAPIClientAbstractEntity

- (void)getWithOnSuccess:(void (^)(id responseObject))success
               onFailure:(void (^)(NSError *error))failure;

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
- (void)listWithParameters:(NSMutableDictionary *)params
                 onSuccess:(void (^)(id responseObject))success
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
- (void)listWithParameters:(NSMutableDictionary *)params
                 onSuccess:(void (^)(id responseObject))success
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
- (void)summaryForID:(NSString *)objId
          onSuccess:(void (^)(id responseObject))success
          onFailure:(void (^)(NSError *error))failure;
- (void)summariesWithOnSuccess:(void (^)(id responseObject))success
              onFailure:(void (^)(NSError *error))failure;
- (void)summariesWithParameters:(NSMutableDictionary *)params
                      onSuccess:(void (^)(id responseObject))success
                      onFailure:(void (^)(NSError *error))failure;

@end

// Activity Entity
@interface HumanAPIClientActivityEntity : HumanAPIClientAbstractPeriodicalEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
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

// Genetic Trait Entity
@interface HumanAPIClientGeneticTraitEntity : HumanAPIClientAbstractEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
- (void)listWithOnSuccess:(void (^)(id responseObject))success
                onFailure:(void (^)(NSError *error))failure;
@end

// Heart Rate Entity
@interface HumanAPIClientHeartRateEntity : HumanAPIClientAbstractMeasurementEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// Height Entity
@interface HumanAPIClientHeightEntity : HumanAPIClientAbstractMeasurementEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// Human Entity
@interface HumanAPIClientHumanEntity : HumanAPIClientAbstractObjectEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// Location Entity
@interface HumanAPIClientLocationEntity : HumanAPIClientAbstractPeriodicalEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// Meal Entity
@interface HumanAPIClientMealEntity : HumanAPIClientAbstractListableEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// Profile Entity
@interface HumanAPIClientProfileEntity : HumanAPIClientAbstractObjectEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// Sleep Entity
@interface HumanAPIClientSleepEntity : HumanAPIClientAbstractPeriodicalEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// Weight Entity
@interface HumanAPIClientWeightEntity : HumanAPIClientAbstractMeasurementEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end


// MedicalAllergy Entity
@interface HumanAPIClientMedicalAllergyEntity : HumanAPIClientAbstractListableEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// MedicalCCD Entity
@interface HumanAPIClientMedicalCCDEntity : HumanAPIClientAbstractEntity
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

// MedicalNarrative Entity
@interface HumanAPIClientMedicalNarrativeEntity : HumanAPIClientAbstractListableEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// MedicalOrganization Entity
@interface HumanAPIClientMedicalOrganizationEntity : HumanAPIClientAbstractListableEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// MedicalProfile Entity
@interface HumanAPIClientMedicalProfileEntity : HumanAPIClientAbstractObjectEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// MedicalTestResult Entity
@interface HumanAPIClientMedicalTestResultEntity : HumanAPIClientAbstractListableEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// MedicalTimeline Entity
@interface HumanAPIClientMedicalTimelineEntity : HumanAPIClientAbstractObjectEntity
- (instancetype)initWithClient:(HumanAPIClient *)client;
@end

// MedicalVitals Entity
@interface HumanAPIClientMedicalVitalsEntity : HumanAPIClientAbstractListableEntity
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

- (HumanAPIClientActivityEntity *)activity;
- (HumanAPIClientBloodGlucoseEntity *)bloodGlucose;
- (HumanAPIClientBloodOxygenEntity *)bloodOxygen;
- (HumanAPIClientBloodPressureEntity *)bloodPressure;
- (HumanAPIClientBMIEntity *)bmi;
- (HumanAPIClientBodyFatEntity *)bodyFat;
- (HumanAPIClientGeneticTraitEntity *)geneticTrait;
- (HumanAPIClientHeartRateEntity *)heartRate;
- (HumanAPIClientHeightEntity *)height;
- (HumanAPIClientHumanEntity *)human;
- (HumanAPIClientLocationEntity *)location;
- (HumanAPIClientMealEntity *)meal;
- (HumanAPIClientProfileEntity *)profile;
- (HumanAPIClientLocationEntity *)sleep;
- (HumanAPIClientWeightEntity *)weight;


- (HumanAPIClientMedicalAllergyEntity *)medicalAllergy;
- (HumanAPIClientMedicalCCDEntity *)medicalCCD;
- (HumanAPIClientMedicalEncounterEntity *)medicalEncounter;
- (HumanAPIClientMedicalImmunizationEntity *)medicalImmunization;
- (HumanAPIClientMedicalIssueEntity *)medicalIssue;
- (HumanAPIClientMedicalMedicationEntity *)medicalMedication;
- (HumanAPIClientMedicalNarrativeEntity *)medicalNarrative;
- (HumanAPIClientMedicalOrganizationEntity *)medicalOrganization;
- (HumanAPIClientMedicalProfileEntity *)medicalProfile;
- (HumanAPIClientMedicalTestResultEntity *)medicalTestResult;
- (HumanAPIClientMedicalTimelineEntity *)medicalTimeline;
- (HumanAPIClientMedicalVitalsEntity *)medicalVitals;
@end

@protocol HumanAPIClientDelegate <NSObject>
@optional
-(void)humanAPIClient:(HumanAPIClient *)client didUpdateWithData:(id)data;
-(void)humanAPIClient:(HumanAPIClient *)client didFailWithError:(NSError *)error;
@end
