//
//  QDataModel.m
//  YDSHClient
//
//  Created by amy.fu on 15/3/30.
//  Copyright (c) 2015年 amy.fu. All rights reserved.
//

#import "QDataModel.h"
#import <objc/runtime.h>
#import "DBInterface.h"

@implementation QDataModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

+ (NSString *)DBTypeOfNSType:(NSString *)nsType {
    NSString *dbType;
    
    if ([nsType isEqualToString:@"i"])
        dbType = @"integer";
    else if ([nsType isEqualToString:@"f"])
        dbType = @"float";
    else if ([nsType isEqualToString:@"d"])
        dbType = @"double";
    else if ([nsType isEqualToString:@"@\"NSDate\""])
        dbType = @"timestamp";
    else
        dbType = @"text";
    
    return dbType;
}

+ (void)queryPropertyName:(NSMutableArray **)arrNames andType:(NSMutableArray **)arrTypes {
    if (*arrNames == nil)
        *arrNames = [[NSMutableArray alloc] init];
    if (*arrTypes == nil)
        *arrTypes = [[NSMutableArray alloc] init];
    unsigned int nCount;
    Class class = [self class];
    objc_property_t *properties = class_copyPropertyList(class, &nCount);
    for (unsigned int i=0; i<nCount; i++) {
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        NSString *propertyAttribute = [[NSString alloc] initWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
        NSRange range;
        range = [propertyAttribute rangeOfString:@","];
        range = NSMakeRange(1, range.location-1);
        NSString *propertyType = [propertyAttribute substringWithRange:range];
        [*arrNames addObject:propertyName];
        [*arrTypes addObject:propertyType];
    }
    free(properties);
}

+ (NSString *)tableName {
    NSString *className = [[NSString alloc] initWithCString:object_getClassName([self class]) encoding:NSUTF8StringEncoding];
    return className;
}

+ (NSString *)createSQLStringWithPrimaryKey:(NSString *)primaryKey {
    NSMutableArray *arrColNames, *arrColTypes;
    [self queryPropertyName:&arrColNames andType:&arrColTypes];
    NSUInteger nColCount = [arrColNames count];
    if (nColCount <= 0 || nColCount != [arrColTypes count])
        return nil;
    NSMutableString *sqlString = [[NSMutableString alloc] initWithFormat:@"create table %@(", [self tableName]];
    for (int i=0; i<nColCount; i++) {
        [sqlString appendString:arrColNames[i]];
        [sqlString appendString:@" "];
        [sqlString appendString:[self DBTypeOfNSType:arrColTypes[i]]];
        if (i==nColCount-1) {
            if (primaryKey && ![primaryKey isEqualToString:@""]) {
                [sqlString appendString:@", primary key("];
                [sqlString appendString:primaryKey];
                [sqlString appendString:@")"];
            }
            [sqlString appendString:@")"];
        }
        else
            [sqlString appendString:@","];
    }
    return sqlString;
}

+ (NSString *)createSQLString {
    return [self createSQLStringWithPrimaryKey:nil];
}

+ (NSString *)querySQLStringWithWhereString:(NSString *)whereString {
    NSMutableString *sqlString = [[NSMutableString alloc] initWithFormat:@"select * from %@", [self tableName]];
    if (whereString && ![whereString isEqualToString:@""]) {
        [sqlString appendString:@" where "];
        [sqlString appendString:whereString];
    }
    return sqlString;
}

+ (NSString *)insertSQLString {
    NSMutableArray *arrColNames, *arrColTypes;
    [self queryPropertyName:&arrColNames andType:&arrColTypes];
    NSUInteger nColCount = [arrColNames count];
    if (nColCount <= 0 || nColCount != [arrColTypes count])
        return nil;
    NSMutableString *sqlString = [[NSMutableString alloc] initWithFormat:@"insert into %@ values (", [self tableName]];
    for (int i=0; i<nColCount; i++) {
        [sqlString appendString:@"?"];
        if (i==nColCount-1)
            [sqlString appendString:@")"];
        else
            [sqlString appendString:@", "];
    }
    return sqlString;
}

+ (NSString *)insertOrUpdateSQLString {
    NSMutableArray *arrColNames, *arrColTypes;
    [self queryPropertyName:&arrColNames andType:&arrColTypes];
    NSUInteger nColCount = [arrColNames count];
    if (nColCount <= 0 || nColCount != [arrColTypes count])
        return nil;
    NSMutableString *sqlString = [[NSMutableString alloc] initWithFormat:@"replace into %@ values (", [self tableName]];
    for (int i=0; i<nColCount; i++) {
        [sqlString appendString:@"?"];
        if (i==nColCount-1)
            [sqlString appendString:@")"];
        else
            [sqlString appendString:@", "];
    }
    return sqlString;
}

+ (NSString *)createIndexStringOfColumn:(NSString *)columnName {
    NSString *sqlString = [NSString stringWithFormat:@"create index %@_%@ on %@(%@)", [self tableName], columnName, [self tableName], columnName];
    return sqlString;
}


#pragma mark-
- (id)initFromFMResultSet:(FMResultSet *)rs {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initFromDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSArray *)convertPropertyValueToNSArray {
    return nil;
}

- (NSString *)updateSQLString {
    NSMutableArray *arrColNames, *arrColTypes;
    [[self class] queryPropertyName:&arrColNames andType:&arrColTypes];
    NSUInteger nColCount = [arrColNames count];
    if (nColCount <= 0 || nColCount != [arrColTypes count])
        return nil;
    NSMutableString *sqlString = [[NSMutableString alloc] initWithFormat:@"update %@ set ", [[self class] tableName]];
    for (int i=0; i<nColCount; i++) {
        [sqlString appendString:arrColNames[i]];
        [sqlString appendString:@" = ?"];
        if (i<nColCount-1)
            [sqlString appendString:@", "];
    }
    return sqlString;
}

- (NSArray *)getArrayValuesForUpdate {
    return [self convertPropertyValueToNSArray];
}

- (NSString *)deleteSQLString {
    NSMutableString *sqlString = [[NSMutableString alloc] initWithFormat:@"delete from %@", [[self class] tableName]];
    return sqlString;
}

- (NSArray *)getArrayValuesForDelete {
    return nil;
}

#pragma mark-
//for detail tables
+ (NSString *)updateSQLString:(BOOL)bDetail {
    return nil;
}

- (NSArray *)getArrayValuesForUpdate:(BOOL)bDetail {
    return nil;
}

- (NSString *)queryExistSQLString {
    return nil;
}

@end

#pragma mark- QVersionModel
@implementation QVersionModel

- (id)initFromFMResultSet:(FMResultSet *)rs {
    self = [super init];
    if (self) {
        self.version = [rs stringForColumn:@"version"];
    }
    return self;
}

- (id)initFromDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.version = [dict objectForKey:@"version"];
    }
    return self;
}

- (NSArray *)convertPropertyValueToNSArray {
    return [[NSArray alloc] initWithObjects:NSString_No_Nil(self.version), nil];
}

@end

@implementation QParticularModel

+ (QParticularModel *)getModelFromDictionary:(NSDictionary *)dic
{
    QParticularModel *model = [[QParticularModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

@end

@implementation QVillageModel

+ (QVillageModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QVillageModel *model = [[QVillageModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

+ (QVillageModel*)allVillageModel
{
    QVillageModel *model = [[QVillageModel alloc] init];
    model.Adnm = @"所有区域";
    return model;
}

#pragma mark - QVillageModel table

+ (NSString *)createSQLString {
    return [self createSQLStringWithPrimaryKey:@"Adnm"];
}

- (id)initFromFMResultSet:(FMResultSet *)rs {
    self = [super init];
    if (self) {
        self.Adnm = [rs stringForColumn:@"Adnm"];
        self.Adcd = [rs stringForColumn:@"Adcd"];
    }
    return self;
}

- (id)initFromDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (NSArray *)convertPropertyValueToNSArray {
    return [NSArray arrayWithObjects:NSString_No_Nil(self.Adnm), NSString_No_Nil(self.Adcd), nil];
}

- (NSString *)updateSQLString {
    NSMutableString *sqlString = [[NSMutableString alloc] init];
    [sqlString appendString:[super updateSQLString]];
    [sqlString appendString:@" where Adnm = ?"];
    return sqlString;
}

- (NSArray *)getArrayValuesForUpdate {
    NSArray *arr = [self convertPropertyValueToNSArray];
    NSArray *arr2 = [[NSArray alloc] initWithObjects:NSString_No_Nil(self.Adnm), nil];
    return [arr arrayByAddingObjectsFromArray:arr2];
}

- (NSString *)deleteSQLString {
    NSMutableString *sqlString = [[NSMutableString alloc] init];
    [sqlString appendString:[super deleteSQLString]];
    [sqlString appendString:@" where Adnm = ?"];
    return sqlString;
}

- (NSArray *)getArrayValuesForDelete {
    return [[NSArray alloc] initWithObjects:NSString_No_Nil(self.Adnm), nil];
}

@end

@implementation QWatershedModel

+ (QWatershedModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QWatershedModel *model = [[QWatershedModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

+ (QWatershedModel*)allWatersModel
{
    QWatershedModel *model = [[QWatershedModel alloc] init];
    model.Rvnm = @"所有流域";
    return model;
}

#pragma mark - QWatershedModel table

+ (NSString *)createSQLString {
    return [self createSQLStringWithPrimaryKey:@"Rvnm"];
}

- (id)initFromFMResultSet:(FMResultSet *)rs {
    self = [super init];
    if (self) {
        self.Rvnm = [rs stringForColumn:@"Rvnm"];
    }
    return self;
}

- (id)initFromDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (NSArray *)convertPropertyValueToNSArray {
    return [NSArray arrayWithObjects:NSString_No_Nil(self.Rvnm), nil];
}

- (NSString *)updateSQLString {
    NSMutableString *sqlString = [[NSMutableString alloc] init];
    [sqlString appendString:[super updateSQLString]];
    [sqlString appendString:@" where Adnm = ?"];
    return sqlString;
}

- (NSArray *)getArrayValuesForUpdate {
    NSArray *arr = [self convertPropertyValueToNSArray];
    NSArray *arr2 = [[NSArray alloc] initWithObjects:NSString_No_Nil(self.Rvnm), nil];
    return [arr arrayByAddingObjectsFromArray:arr2];
}

- (NSString *)deleteSQLString {
    NSMutableString *sqlString = [[NSMutableString alloc] init];
    [sqlString appendString:[super deleteSQLString]];
    [sqlString appendString:@" where Rvnm = ?"];
    return sqlString;
}

- (NSArray *)getArrayValuesForDelete {
    return [[NSArray alloc] initWithObjects:NSString_No_Nil(self.Rvnm), nil];
}

@end

@implementation QStationModel

+ (QStationModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QStationModel *model = [[QStationModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

#pragma mark - QStationModel table
+ (NSString *)createSQLString {
    return [self createSQLStringWithPrimaryKey:@"Stcd"];
}

- (id)initFromFMResultSet:(FMResultSet *)rs {
    self = [super init];
    if (self) {
        self.Stcd = [rs stringForColumn:@"Stcd"];
        self.Stnm = [rs stringForColumn:@"Stnm"];
        self.Longitude = [rs stringForColumn:@"Longitude"];
        self.Latitude = [rs stringForColumn:@"Latitude"];
        self.Rvnm = [rs stringForColumn:@"Rvnm"];
        self.Adnm = [rs stringForColumn:@"Adnm"];
        self.Sttp = [rs stringForColumn:@"Sttp"];
    }
    return self;
}

- (id)initFromDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (NSArray *)convertPropertyValueToNSArray {
    return [NSArray arrayWithObjects:NSString_No_Nil(self.Stcd),
                                    NSString_No_Nil(self.Stnm),
                                    NSString_No_Nil(self.Longitude),
                                    NSString_No_Nil(self.Latitude),
                                    NSString_No_Nil(self.Rvnm),
                                    NSString_No_Nil(self.Adnm),
                                    NSString_No_Nil(self.Sttp),nil];
}

- (NSString *)updateSQLString {
    NSMutableString *sqlString = [[NSMutableString alloc] init];
    [sqlString appendString:[super updateSQLString]];
    [sqlString appendString:@" where Stcd = ?"];
    return sqlString;
}

- (NSArray *)getArrayValuesForUpdate {
    NSArray *arr = [self convertPropertyValueToNSArray];
    NSArray *arr2 = [[NSArray alloc] initWithObjects:NSString_No_Nil(self.Stcd), nil];
    return [arr arrayByAddingObjectsFromArray:arr2];
}

- (NSString *)deleteSQLString {
    NSMutableString *sqlString = [[NSMutableString alloc] init];
    [sqlString appendString:[super deleteSQLString]];
    [sqlString appendString:@" where Stcd = ?"];
    return sqlString;
}

- (NSArray *)getArrayValuesForDelete {
    return [[NSArray alloc] initWithObjects:NSString_No_Nil(self.Stcd), nil];
}

@end

@implementation QRainModel

+ (QRainModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QRainModel *model = [[QRainModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end

@implementation QRainDetailModel

+ (QRainDetailModel*)getModelFromDictionary:(NSDictionary *)dict
{
    QRainDetailModel *model = [[QRainDetailModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end

@implementation QWaterModel

+ (QWaterModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QWaterModel *model = [[QWaterModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end

@implementation QWaterDetailModel

+ (QWaterDetailModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QWaterDetailModel *model = [[QWaterDetailModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end

@implementation QWorkWaterModel

+ (QWorkWaterModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QWorkWaterModel *model = [[QWorkWaterModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

#pragma mark - QWorkWaterModel table

+ (NSString *)createSQLString {
    return [self createSQLStringWithPrimaryKey:@"rscd"];
}

- (id)initFromFMResultSet:(FMResultSet *)rs {
    self = [super init];
    if (self) {
        self.rscd = [rs stringForColumn:@"rscd"];
        self.Adnm = [rs stringForColumn:@"Adnm"];
        self.WorkWaterName = [rs stringForColumn:@"WorkWaterName"];
        self.WorkWaterTypeName = [rs stringForColumn:@"WorkWaterTypeName"];
        self.Latitude = [rs stringForColumn:@"Latitude"];
        self.Longitude = [rs stringForColumn:@"Longitude"];
    }
    return self;
}

- (id)initFromDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (NSArray *)convertPropertyValueToNSArray {
    return [NSArray arrayWithObjects:NSString_No_Nil(self.rscd),
            NSString_No_Nil(self.Adnm),
            NSString_No_Nil(self.WorkWaterName),
            NSString_No_Nil(self.WorkWaterTypeName),
            NSString_No_Nil(self.Latitude),
            NSString_No_Nil(self.Longitude),nil];
}

- (NSString *)updateSQLString {
    NSMutableString *sqlString = [[NSMutableString alloc] init];
    [sqlString appendString:[super updateSQLString]];
    [sqlString appendString:@" where rscd = ?"];
    return sqlString;
}

- (NSArray *)getArrayValuesForUpdate {
    NSArray *arr = [self convertPropertyValueToNSArray];
    NSArray *arr2 = [[NSArray alloc] initWithObjects:NSString_No_Nil(self.rscd), nil];
    return [arr arrayByAddingObjectsFromArray:arr2];
}

- (NSString *)deleteSQLString {
    NSMutableString *sqlString = [[NSMutableString alloc] init];
    [sqlString appendString:[super deleteSQLString]];
    [sqlString appendString:@" where rscd = ?"];
    return sqlString;
}

- (NSArray *)getArrayValuesForDelete {
    return [[NSArray alloc] initWithObjects:NSString_No_Nil(self.rscd), nil];
}

@end

@implementation QWorkWaterDetailModel

+ (QWorkWaterDetailModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QWorkWaterDetailModel *model = [[QWorkWaterDetailModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end

@implementation QWorkStationModel

+ (QWorkStationModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QWorkStationModel *model = [[QWorkStationModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end

@implementation QWorkDikeModel

+ (QWorkDikeModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QWorkDikeModel *model = [[QWorkDikeModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

#pragma mark - QWorkDikeModel table

+ (NSString *)createSQLString {
    return [self createSQLStringWithPrimaryKey:@"rn"];
}

- (id)initFromFMResultSet:(FMResultSet *)rs {
    self = [super init];
    if (self) {
        self.rn = [rs stringForColumn:@"rn"];
        self.WorkDikeName = [rs stringForColumn:@"WorkDikeName"];
        self.dkcd = [rs stringForColumn:@"dkcd"];
        self.Canm = [rs stringForColumn:@"Canm"];
    }
    return self;
}

- (id)initFromDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (NSArray *)convertPropertyValueToNSArray {
    return [NSArray arrayWithObjects:NSString_No_Nil(self.rn), NSString_No_Nil(self.WorkDikeName), NSString_No_Nil(self.dkcd), NSString_No_Nil(self.Canm), nil];
}

- (NSString *)updateSQLString {
    NSMutableString *sqlString = [[NSMutableString alloc] init];
    [sqlString appendString:[super updateSQLString]];
    [sqlString appendString:@" where rn = ?"];
    return sqlString;
}

- (NSArray *)getArrayValuesForUpdate {
    NSArray *arr = [self convertPropertyValueToNSArray];
    NSArray *arr2 = [[NSArray alloc] initWithObjects:NSString_No_Nil(self.rn), nil];
    return [arr arrayByAddingObjectsFromArray:arr2];
}

- (NSString *)deleteSQLString {
    NSMutableString *sqlString = [[NSMutableString alloc] init];
    [sqlString appendString:[super deleteSQLString]];
    [sqlString appendString:@" where rn = ?"];
    return sqlString;
}

- (NSArray *)getArrayValuesForDelete {
    return [[NSArray alloc] initWithObjects:NSString_No_Nil(self.rn), nil];
}

@end

@implementation QWorkDikeDetailModel

+ (QWorkDikeDetailModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QWorkDikeDetailModel *model = [[QWorkDikeDetailModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end

@implementation QWorkRiverModel

+ (QWorkRiverModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QWorkRiverModel *model = [[QWorkRiverModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

#pragma mark - QWorkRiverModel table

+ (NSString *)createSQLString {
    return [self createSQLStringWithPrimaryKey:@"rn"];
}

- (id)initFromFMResultSet:(FMResultSet *)rs {
    self = [super init];
    if (self) {
        self.rn = [rs stringForColumn:@"rn"];
        self.WorkRiverName = [rs stringForColumn:@"WorkRiverName"];
        self.rvcd = [rs stringForColumn:@"rvcd"];
        self.Canm = [rs stringForColumn:@"Canm"];
        self.Length = [rs stringForColumn:@"Length"];
        
    }
    return self;
}

- (id)initFromDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (NSArray *)convertPropertyValueToNSArray {
    return [NSArray arrayWithObjects:NSString_No_Nil(self.rn), NSString_No_Nil(self.WorkRiverName), NSString_No_Nil(self.rvcd), NSString_No_Nil(self.Canm), NSString_No_Nil(self.Length), nil];
}

- (NSString *)updateSQLString {
    NSMutableString *sqlString = [[NSMutableString alloc] init];
    [sqlString appendString:[super updateSQLString]];
    [sqlString appendString:@" where rn = ?"];
    return sqlString;
}

- (NSArray *)getArrayValuesForUpdate {
    NSArray *arr = [self convertPropertyValueToNSArray];
    NSArray *arr2 = [[NSArray alloc] initWithObjects:NSString_No_Nil(self.rn), nil];
    return [arr arrayByAddingObjectsFromArray:arr2];
}

- (NSString *)deleteSQLString {
    NSMutableString *sqlString = [[NSMutableString alloc] init];
    [sqlString appendString:[super deleteSQLString]];
    [sqlString appendString:@" where rn = ?"];
    return sqlString;
}

- (NSArray *)getArrayValuesForDelete {
    return [[NSArray alloc] initWithObjects:NSString_No_Nil(self.rn), nil];
}

@end

@implementation QWorkRiverDetailModel

+ (QWorkRiverDetailModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QWorkRiverDetailModel *model = [[QWorkRiverDetailModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end

@implementation QWeatherModel

+ (QWeatherModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QWeatherModel *model = [[QWeatherModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end

@implementation QPhoneModel

+ (QPhoneModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QPhoneModel *model = [[QPhoneModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end

@implementation QFloodPlanModel

+ (QFloodPlanModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QFloodPlanModel *model = [[QFloodPlanModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end

@implementation QFloodPlanDetailModel

+ (QFloodPlanDetailModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QFloodPlanDetailModel *model = [[QFloodPlanDetailModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end

@implementation QWarningModel

+ (QWarningModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QWarningModel *model = [[QWarningModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end

@implementation QRespondModel

+ (QRespondModel *)getModelFromDictionary:(NSDictionary *)dict
{
    QRespondModel *model = [[QRespondModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end

@implementation QProblemTypeModel

+ (QProblemTypeModel*)getModelFromDictionary:(NSDictionary*)dict
{
    QProblemTypeModel *model = [[QProblemTypeModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

- (id)valueForUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        return self.ID;
    }
    return nil;
}

@end

@implementation QDizhiLandModel

+ (QDizhiLandModel*)getModelFromDictionary:(NSDictionary*)dict
{
    QDizhiLandModel *model = [[QDizhiLandModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end

@implementation QDizhiLandDetailModel

+ (QDizhiLandDetailModel*)getModelFromDictionary:(NSDictionary*)dict
{
    QDizhiLandDetailModel *model = [[QDizhiLandDetailModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end

