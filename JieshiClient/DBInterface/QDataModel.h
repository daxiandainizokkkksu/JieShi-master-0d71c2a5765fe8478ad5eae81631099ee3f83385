//
//  QDataModel.h
//  YDSHClient
//
//  Created by amy.fu on 15/3/30.
//  Copyright (c) 2015年 amy.fu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"
#import "ASUtils.h"

@interface QDataModel : NSObject

+ (void)queryPropertyName:(NSMutableArray **)arrNames andType:(NSMutableArray **)arrTypes;
+ (NSString *)tableName;
+ (NSString *)createSQLString;
+ (NSString *)querySQLStringWithWhereString:(NSString *)whereString;
+ (NSString *)insertSQLString;
+ (NSString *)insertOrUpdateSQLString;
+ (NSString *)createIndexStringOfColumn:(NSString *)columnName;

- (id)initFromFMResultSet:(FMResultSet *)rs;
- (id)initFromDictionary:(NSDictionary *)dict;
- (NSArray *)convertPropertyValueToNSArray;
- (NSString *)updateSQLString;
- (NSArray *)getArrayValuesForUpdate;
- (NSString *)deleteSQLString;
- (NSArray *)getArrayValuesForDelete;

//for detail tables
+ (NSString *)updateSQLString:(BOOL)bDetail;
- (NSArray *)getArrayValuesForUpdate:(BOOL)bDetail;
- (NSString *)queryExistSQLString;

@end

@interface QVersionModel : QDataModel

@property(nonatomic, strong) NSString *version;

@end

@interface QParticularModel : QDataModel

@property (nonatomic, strong) NSString *pOneGeShu;
@property (nonatomic, strong) NSString *pOneZhan;
@property (nonatomic, strong) NSString *pTwoFourGeShu;
@property (nonatomic, strong) NSString *pTwoFourZhan;
@property (nonatomic, strong) NSString *pWarnGenShu;
@property (nonatomic, strong) NSString *pWarnZhan;
@property (nonatomic, strong) NSString *pWGenShu;
@property (nonatomic, strong) NSString *pWXinXi;

+ (QParticularModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QVillageModel : QDataModel

@property (nonatomic, strong) NSString *Adnm;
@property (nonatomic, strong) NSString *Adcd;

+ (QVillageModel *)getModelFromDictionary:(NSDictionary *)dict;
+ (QVillageModel*)allVillageModel;

@end

@interface QWatershedModel : QDataModel

@property (nonatomic, strong) NSString *Rvnm;

+ (QWatershedModel *)getModelFromDictionary:(NSDictionary *)dict;
+ (QWatershedModel*)allWatersModel;

@end

@interface QStationModel : QDataModel

@property (nonatomic, strong) NSString *Stcd;
@property (nonatomic, strong) NSString *Stnm;
@property (nonatomic, strong) NSString *Longitude;
@property (nonatomic, strong) NSString *Latitude;
@property (nonatomic, strong) NSString *Rvnm;
@property (nonatomic, strong) NSString *Adnm;
@property (nonatomic, strong) NSString *Sttp;

+ (QStationModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QRainModel : QDataModel

@property (nonatomic, strong) NSString *Stcd;
@property (nonatomic, strong) NSString *Stnm;
@property (nonatomic, strong) NSString *R;
@property (nonatomic, strong) NSString *Rn;
@property (nonatomic, strong) NSString *Adnm;
@property (nonatomic, strong) NSString *Rvnm;
@property (nonatomic, strong) NSString *Longitude;
@property (nonatomic, strong) NSString *Latitude;

+ (QRainModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QRainDetailModel : QDataModel

@property (nonatomic, strong) NSString *rainFallTime;
@property (nonatomic, strong) NSString *rainFall;
+ (QRainDetailModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QWaterModel : QDataModel

@property (nonatomic, strong) NSString *Stcd;
@property (nonatomic, strong) NSString *Stnm;
@property (nonatomic, strong) NSString *Adnm;
@property (nonatomic, strong) NSString *Rvnm;
@property (nonatomic, strong) NSString *Latitude;
@property (nonatomic, strong) NSString *Longitude;
@property (nonatomic, strong) NSString *tm;
@property (nonatomic, strong) NSString *SW;
@property (nonatomic, strong) NSString *ESW;
@property (nonatomic, strong) NSString *isWarn;

+ (QWaterModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QWaterDetailModel : QDataModel

@property (nonatomic, strong) NSString *sw;
@property (nonatomic, strong) NSString *jjsw;
@property (nonatomic, strong) NSString *swTime;

+ (QWaterDetailModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QWorkWaterModel : QDataModel

@property (nonatomic, strong) NSString *rscd;
@property (nonatomic, strong) NSString *Adnm;
@property (nonatomic, strong) NSString *WorkWaterName;
@property (nonatomic, strong) NSString *WorkWaterTypeName;
@property (nonatomic, strong) NSString *Latitude;
@property (nonatomic, strong) NSString *Longitude;

+ (QWorkWaterModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QWorkWaterDetailModel : QDataModel

@property (nonatomic, strong) NSString *WorkWaterNameNumber;
@property (nonatomic, strong) NSString *WorkWaterName;
@property (nonatomic, strong) NSString *WorkWaterWhere;
@property (nonatomic, strong) NSString *WorkWaterArea;
@property (nonatomic, strong) NSString *WorkWaterStorage;
@property (nonatomic, strong) NSString *WorkWaterFlood;

+ (QWorkWaterDetailModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QWorkStationModel : QDataModel

@property (nonatomic, strong) NSString *stcd;
@property (nonatomic, strong) NSString *Canm;
@property (nonatomic, strong) NSString *Adnm;
@property (nonatomic, strong) NSString *WorkStationName;
@property (nonatomic, strong) NSString *WorkStationTypeName;
@property (nonatomic, strong) NSString *Latitude;
@property (nonatomic, strong) NSString *Longitude;

+ (QWorkStationModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QWorkDikeModel : QDataModel

@property (nonatomic, strong) NSString *rn;
@property (nonatomic, strong) NSString *WorkDikeName;
@property (nonatomic, strong) NSString *dkcd;
@property (nonatomic, strong) NSString *Canm;


+ (QWorkDikeModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QWorkDikeDetailModel : QDataModel

@property (nonatomic, strong) NSString *WorkDikeNameNumber;
@property (nonatomic, strong) NSString *WorkDikeSmallName;
@property (nonatomic, strong) NSString *WorkDikeName;
@property (nonatomic, strong) NSString *WorkDikeBegin;
@property (nonatomic, strong) NSString *WorkDikeEnd;
@property (nonatomic, strong) NSString *WorkDikeType;
@property (nonatomic, strong) NSString *WorkDikeLenght;
@property (nonatomic, strong) NSString *WorkDikehigh;
@property (nonatomic, strong) NSString *WorkDikeArea;
@property (nonatomic, strong) NSString *WorkDikePeople;
@property (nonatomic, strong) NSString *WorkDikeSafe;

+ (QWorkDikeDetailModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QWorkRiverModel : QDataModel
@property (nonatomic, strong) NSString *rn;
@property (nonatomic, strong) NSString *WorkRiverName;
@property (nonatomic, strong) NSString *rvcd;
@property (nonatomic, strong) NSString *Canm;
@property (nonatomic, strong) NSString *Length;

+ (QWorkRiverModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QWorkRiverDetailModel : QDataModel

@property (nonatomic, strong) NSString *WorkRiverNameNumber;
@property (nonatomic, strong) NSString *WorkRiverName;
@property (nonatomic, strong) NSString *WorkRiverWhere;
@property (nonatomic, strong) NSString *WorkRiverLenght;
@property (nonatomic, strong) NSString *WorkRiverArea;
@property (nonatomic, strong) NSString *WorkRiverPeople;
@property (nonatomic, strong) NSString *WorkRiverSafe;
@property (nonatomic, strong) NSString *WorkRiverSmallName;

+ (QWorkRiverDetailModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QWeatherModel : QDataModel

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *hTemperature;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *lTemperature;
@property (nonatomic, strong) NSString *pngPath;
@property (nonatomic, strong) NSString *pngType;
@property (nonatomic, strong) NSString *rain;
@property (nonatomic, strong) NSString *snow;
@property (nonatomic, strong) NSString *week;
@property (nonatomic, strong) NSString *yb;

+ (QWeatherModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QPhoneModel : QDataModel
@property (nonatomic, strong) NSString *PhoneID;
@property (nonatomic, strong) NSString *PhoneName;
@property (nonatomic, strong) NSString *PhoneNumber;
@property (nonatomic, strong) NSString *PhoneTypeName;

+ (QPhoneModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QFloodPlanModel : QDataModel

@property (nonatomic, strong) NSString *PlanID;
@property (nonatomic, strong) NSString *PlanName;
@property (nonatomic, strong) NSString *PlanTime;
@property (nonatomic, strong) NSString *PlanSummary;

+ (QFloodPlanModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QFloodPlanDetailModel : QDataModel

@property (nonatomic, strong) NSString *PlanName;
@property (nonatomic, strong) NSString *PlanTime;
@property (nonatomic, strong) NSString *PlanNeiRong;
@property (nonatomic, strong) NSString *PlanURL;

+ (QFloodPlanDetailModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QWarningModel : QDataModel

@property (nonatomic, strong) NSString *WarnID;
@property (nonatomic, strong) NSString *WarnGradeID;
@property (nonatomic, strong) NSString *WarnGradeNM;
@property (nonatomic, strong) NSString *WarnStatusNM;
@property (nonatomic, strong) NSString *WarnSTM;
@property (nonatomic, strong) NSString *Adcd;
@property (nonatomic, strong) NSString *Adnm;
@property (nonatomic, strong) NSString *Longitude;
@property (nonatomic, strong) NSString *Latitude;

+ (QWarningModel *)getModelFromDictionary:(NSDictionary *)dict;

@end

@interface QRespondModel : QDataModel

@property (nonatomic, strong) NSString *RespondID;
@property (nonatomic, strong) NSString *Adnm;
@property (nonatomic, strong) NSString *Adcd;
@property (nonatomic, strong) NSString *RespGradeID;
@property (nonatomic, strong) NSString *RespGradeNM;
@property (nonatomic, strong) NSString *RespSTime;
@property (nonatomic, strong) NSString *Latitude;
@property (nonatomic, strong) NSString *Longitude;
+ (QRespondModel *)getModelFromDictionary:(NSDictionary *)dict;
@end

@interface QProblemTypeModel : QDataModel
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;

+ (QProblemTypeModel*)getModelFromDictionary:(NSDictionary*)dict;

@end

@interface QDizhiLandModel : QDataModel
@property (nonatomic, strong) NSString *Adnm;
@property (nonatomic, strong) NSString *LandID;
@property (nonatomic, strong) NSString *LandName;
@property (nonatomic, strong) NSString *LandType;
@property (nonatomic, strong) NSString *Latitude;
@property (nonatomic, strong) NSString *Longitude;

+ (QDizhiLandModel*)getModelFromDictionary:(NSDictionary*)dict;

@end

@interface QDizhiLandDetailModel : QDataModel

@property (nonatomic, strong) NSString *Adnm;
@property (nonatomic, strong) NSString *LandBM;
@property (nonatomic, strong) NSString *LandGM;
@property (nonatomic, strong) NSString *LandName;
@property (nonatomic, strong) NSString *LandRY;
@property (nonatomic, strong) NSString *LandTJ;
@property (nonatomic, strong) NSString *LandType;

+ (QDizhiLandDetailModel*)getModelFromDictionary:(NSDictionary*)dict;

@end

