//
//  HumanAPIClient.m
//  HumanAPI client implementation
//

#import "HumanAPIClient.h"

// Human API root URL
static NSString * const API_ROOT = @"https://api.humanapi.co/v1/human";

// ----  ----  ----  ----
// CLIENT
// ----  ----  ----  ----

@implementation HumanAPIClient

+ (HumanAPIClient *)sharedHumanAPIClient
{
    static HumanAPIClient *_sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
    });
    
    return _sharedClient;
}

- (instancetype)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:API_ROOT]];
    return self;
}

- (void)execute:(NSString *)path
    onSuccess:(void (^)(id responseObject))success
    onFailure:(void (^)(NSError *error))failure;
{
    NSMutableDictionary *empty = [NSMutableDictionary dictionary];
    [self execute:path withParameters:empty onSuccess:success onFailure:failure];
}

- (void)execute:(NSString *)path withParameters:(NSMutableDictionary *)parameters
    onSuccess:(void (^)(id responseObject))success
    onFailure:(void (^)(NSError *error))failure;
{
    NSMutableDictionary *myParams = [NSMutableDictionary dictionaryWithDictionary:parameters];
    myParams[@"access_token"] = self.accessToken;
    NSString *fullPath = [NSString stringWithFormat:@"%@?", path];
    //NSString *fullPath = [NSString stringWithFormat:@"%@/?access_token=%@", path, self.accessToken];
    [self GET:fullPath parameters:myParams
      success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (HumanAPIClientHumanEntity *)human
{
    return [[HumanAPIClientHumanEntity alloc] initWithClient:self];
}

- (HumanAPIClientProfileEntity *)profile
{
    return [[HumanAPIClientProfileEntity alloc] initWithClient:self];
}

- (HumanAPIClientGeneticTraitEntity *)geneticTrait
{
    return [[HumanAPIClientGeneticTraitEntity alloc] initWithClient:self];
}

- (HumanAPIClientBloodGlucoseEntity *)bloodGlucose
{
    return [[HumanAPIClientBloodGlucoseEntity alloc] initWithClient:self];
}

- (HumanAPIClientBloodOxygenEntity *)bloodOxygen
{
    return [[HumanAPIClientBloodOxygenEntity alloc] initWithClient:self];
}

- (HumanAPIClientBloodPressureEntity *)bloodPressure
{
    return [[HumanAPIClientBloodPressureEntity alloc] initWithClient:self];
}

- (HumanAPIClientBMIEntity *)bmi
{
    return [[HumanAPIClientBMIEntity alloc] initWithClient:self];
}

- (HumanAPIClientBodyFatEntity *)bodyFat
{
    return [[HumanAPIClientBodyFatEntity alloc] initWithClient:self];
}

- (HumanAPIClientHeartRateEntity *)heartRate
{
    return [[HumanAPIClientHeartRateEntity alloc] initWithClient:self];
}

- (HumanAPIClientHeightEntity *)height
{
    return [[HumanAPIClientHeightEntity alloc] initWithClient:self];
}

- (HumanAPIClientWeightEntity *)weight
{
    return [[HumanAPIClientWeightEntity alloc] initWithClient:self];
}

- (HumanAPIClientActivityEntity *)activity
{
    return [[HumanAPIClientActivityEntity alloc] initWithClient:self];
}

- (HumanAPIClientLocationEntity *)location
{
    return [[HumanAPIClientLocationEntity alloc] initWithClient:self];
}

- (HumanAPIClientSleepEntity *)sleep
{
    return [[HumanAPIClientSleepEntity alloc] initWithClient:self];
}

- (HumanAPIClientMedicalAllergyEntity *)medicalAllergy
{
    return [[HumanAPIClientMedicalAllergyEntity alloc] initWithClient:self];
}

- (HumanAPIClientMedicalEncounterEntity *)medicalEncounter
{
    return [[HumanAPIClientMedicalEncounterEntity alloc] initWithClient:self];
}

- (HumanAPIClientMedicalImmunizationEntity *)medicalImmunization
{
    return [[HumanAPIClientMedicalImmunizationEntity alloc] initWithClient:self];
}

- (HumanAPIClientMedicalIssueEntity *)medicalIssue
{
    return [[HumanAPIClientMedicalIssueEntity alloc] initWithClient:self];
}

- (HumanAPIClientMedicalMedicationEntity *)medicalMedication
{
    return [[HumanAPIClientMedicalMedicationEntity alloc] initWithClient:self];
}

- (HumanAPIClientMedicalTestResultEntity *)medicalTestResult
{
    return [[HumanAPIClientMedicalTestResultEntity alloc] initWithClient:self];
}

@end


// ----  ----  ----  ----
// ENTITIES
// ----  ----  ----  ----

// AbstractEntity
@implementation HumanAPIClientAbstractEntity

- (instancetype)initWithClient:(HumanAPIClient *)client
                 andMasterPath:(NSString *)masterPath
{
    self = [super init];
    self.client = client;
    self.masterPath = masterPath;
    return self;
}

@end

// Abstract Measurement Entity
@implementation HumanAPIClientAbstractMeasurementEntity

- (void)latestWithOnSuccess:(void (^)(id responseObject))success
                  onFailure:(void (^)(NSError *error))failure
{
    [self.client execute:[self.masterPath stringByAppendingString:@""]
               onSuccess:success onFailure:failure];
}

- (void)readingsWithOnSuccess:(void (^)(id responseObject))success
                    onFailure:(void (^)(NSError *error))failure
{
    [self.client execute:[self.masterPath stringByAppendingString:@"/readings"]
               onSuccess:success onFailure:failure];
}

- (void)reading:(NSString *)objId
      onSuccess:(void (^)(id responseObject))success
      onFailure:(void (^)(NSError *error))failure
{
    NSString *rdpath = [@"/readings/" stringByAppendingString:objId];
    [self.client execute:[self.masterPath stringByAppendingString:rdpath]
               onSuccess:success onFailure:failure];
}

- (void)dailyWithOnSuccess:(void (^)(id responseObject))success
                 onFailure:(void (^)(NSError *error))failure
{
    [self dailyForDay:[NSDate date] onSuccess:success onFailure:failure];
}

- (void)dailyForDay:(NSDate *)day
          onSuccess:(void (^)(id responseObject))success
          onFailure:(void (^)(NSError *error))failure
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *iso = [dateFormat stringFromDate:day];
    NSString *dpath = [@"/readings/daily/" stringByAppendingString:iso];
    [self.client execute:[self.masterPath stringByAppendingString:dpath]
               onSuccess:success onFailure:failure];
}

@end

// Abstract Listable Entity
@implementation HumanAPIClientAbstractListableEntity

- (void)listWithOnSuccess:(void (^)(id responseObject))success
                onFailure:(void (^)(NSError *error))failure
{
    [self.client execute:[self.masterPath stringByAppendingString:@""]
               onSuccess:success onFailure:failure];
}

- (void)get:(NSString *)objId
  onSuccess:(void (^)(id responseObject))success
  onFailure:(void (^)(NSError *error))failure
{
    NSString *acpath = [@"/" stringByAppendingString:objId];
    [self.client execute:[self.masterPath stringByAppendingString:acpath]
               onSuccess:success onFailure:failure];
}

@end

// Abstract Periodical Entity
@implementation HumanAPIClientAbstractPeriodicalEntity

- (void)listWithOnSuccess:(void (^)(id responseObject))success
                onFailure:(void (^)(NSError *error))failure
{
    [self.client execute:[self.masterPath stringByAppendingString:@""]
               onSuccess:success onFailure:failure];
}

- (void)get:(NSString *)objId
  onSuccess:(void (^)(id responseObject))success
  onFailure:(void (^)(NSError *error))failure
{
    NSString *acpath = [@"/" stringByAppendingString:objId];
    [self.client execute:[self.masterPath stringByAppendingString:acpath]
               onSuccess:success onFailure:failure];
}

- (void)dailyWithOnSuccess:(void (^)(id responseObject))success
                 onFailure:(void (^)(NSError *error))failure
{
    [self dailyForDay:[NSDate date] onSuccess:success onFailure:failure];
}

- (void)dailyForDay:(NSDate *)day
          onSuccess:(void (^)(id responseObject))success
          onFailure:(void (^)(NSError *error))failure
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *iso = [dateFormat stringFromDate:day];
    NSString *dpath = [@"/daily/" stringByAppendingString:iso];
    [self.client execute:[self.masterPath stringByAppendingString:dpath]
               onSuccess:success onFailure:failure];
}

- (void)summaryWithOnSuccess:(void (^)(id responseObject))success
                   onFailure:(void (^)(NSError *error))failure
{
    [self summaryForDay:[NSDate date] onSuccess:success onFailure:failure];
}

- (void)summaryForDay:(NSDate *)day
            onSuccess:(void (^)(id responseObject))success
            onFailure:(void (^)(NSError *error))failure
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *iso = [dateFormat stringFromDate:day];
    NSString *spath = [@"/summary/" stringByAppendingString:iso];
    [self.client execute:[self.masterPath stringByAppendingString:spath]
               onSuccess:success onFailure:failure];
}

@end

// Human Entity
@implementation HumanAPIClientHumanEntity

- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@""];
}

- (void)getWithOnSuccess:(void (^)(id responseObject))success
               onFailure:(void (^)(NSError *error))failure;
{
    return [self.client execute:@"" onSuccess:success onFailure:failure];
}

@end

// Profile Entity
@implementation HumanAPIClientProfileEntity

- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@""];
}

- (void)getWithOnSuccess:(void (^)(id responseObject))success
               onFailure:(void (^)(NSError *error))failure;
{
    [self.client execute:@"profile" onSuccess:success onFailure:failure];
}

@end

// Genetic Trait Entity
@implementation HumanAPIClientGeneticTraitEntity

- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@""];
}

- (void)listWithOnSuccess:(void (^)(id responseObject))success
                onFailure:(void (^)(NSError *error))failure;
{
    [self.client execute:@"genetic/traits" onSuccess:success onFailure:failure];
}

@end

// Blood Glucose Entity
@implementation HumanAPIClientBloodGlucoseEntity
- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@"blood_glucose"];
}
@end

// Blood Oxygen Entity
@implementation HumanAPIClientBloodOxygenEntity
- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@"blood_oxygen"];
}
@end

// Blood Pressure Entity
@implementation HumanAPIClientBloodPressureEntity
- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@"blood_pressure"];
}
@end

// BMI Entity
@implementation HumanAPIClientBMIEntity
- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@"bmi"];
}
@end

// Body Fat Entity
@implementation HumanAPIClientBodyFatEntity
- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@"body_fat"];
}
@end

// Heart Rate Entity
@implementation HumanAPIClientHeartRateEntity
- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@"heart_rate"];
}
@end

// Height Entity
@implementation HumanAPIClientHeightEntity
- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@"height"];
}
@end

// Weight Entity
@implementation HumanAPIClientWeightEntity
- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@"weight"];
}
@end

// Activity Entity
@implementation HumanAPIClientActivityEntity
- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@"activities"];
}
@end

// Location Entity
@implementation HumanAPIClientLocationEntity
- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@"locations"];
}
@end

// Sleep Entity
@implementation HumanAPIClientSleepEntity
- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@"sleeps"];
}
@end

// MedicalAllergy Entity
@implementation HumanAPIClientMedicalAllergyEntity
- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@"medical/allergies"];
}
@end

// MedicalEncounter Entity
@implementation HumanAPIClientMedicalEncounterEntity
- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@"medical/encounters"];
}
@end

// MedicalImmunization Entity
@implementation HumanAPIClientMedicalImmunizationEntity
- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@"medical/immunizations"];
}
@end

// MedicalIssue Entity
@implementation HumanAPIClientMedicalIssueEntity
- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@"medical/issues"];
}
@end

// MedicalMedication Entity
@implementation HumanAPIClientMedicalMedicationEntity
- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@"medical/medications"];
}
@end

// MedicalTestResult Entity
@implementation HumanAPIClientMedicalTestResultEntity
- (instancetype)initWithClient:(HumanAPIClient *)client
{
    return [super initWithClient:client andMasterPath:@"medical/test_results"];
}
@end