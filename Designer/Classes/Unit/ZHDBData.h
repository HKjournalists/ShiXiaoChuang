//
//  ZHDBData.h
//  Dyrs
//
//  Created by mbp  on 13-9-9.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { DLog(@"Failure on line %d", __LINE__); abort(); } }


#define ImageType_Dept                  0
#define ImageType_Case                  1
#define ImageType_Designer_BigAvart     2
#define ImageType_AccessType            3
#define ImageType_Access                4
#define ImageType_Designer_Avart        5


#define Member_Manage     0
#define Member_Designer     1
#define Member_DesignerVIP     2

    

@interface ZHDBData : NSObject
{
    FMDatabase *db;

    
}

+ (ZHDBData *)share;


- (void)stringToDBSqlString:(NSString *)sqlString;
- (void)insertTable:(NSString *)sql;





- (void)updatePicDownLoaded:(NSString *)pid;
- (void)deleteAllData;


- (NSMutableArray *)getPics;


/** 获取设计师信.
 返回：设计师姓名，电话， 邮箱，介绍，
 real_name, mobile, email, adress, introduction 
 */
- (NSMutableDictionary *)getDesignerForD_Id:(NSString * )designer_id;

/** 获取案例列表.
 返回：列表 照片，名称
 
*/
- (NSMutableArray *)getCasesForD_Id:(NSString * )designer_id;
- (NSMutableArray *)get3DCasesForD_Id:(NSString * )designer_id;

//  获取 案例 空间 
- (NSMutableArray *)get3DCasesSpace:(NSString * )Case_id;
- (NSMutableArray *)get3DCasesSpaceImages:(NSString * )Case_id;


/**  获取案例详情.
 返回： 案例图片list，
 */
- (NSMutableArray *)getCasesDetailForC_Id:(NSString * )case_id;
- (NSMutableArray *)get3DCasesDetailForC_Id:(NSString * )case_id;

/** 获取手绘列表.
 返回：图片组
 
*/
- (NSMutableArray *)getPhotoForD_Id:(NSString * )designer_id;

/** 获取设计师 文档 列表.
 返回：文档list ， 名称， 物理地址
 
*/
- (NSMutableArray *)getFilesForD_Id:(NSString * )designer_id;


/** 获取设计师 标签信息.
 返回： 标签
 */
- (NSMutableArray *)getTagsForD_Id:(NSString * )designer_id;

- (NSMutableArray *)getCaseForTags:(NSDictionary * )roomDict mealDict:(NSDictionary *)mealDict price:(NSDictionary *)priceDict workStyle:(NSDictionary *)workStyleDict  area:(NSDictionary *)areaDict;
- (NSMutableArray *)get3DCaseForTags:(NSDictionary * )roomDict mealDict:(NSDictionary *)mealDict price:(NSDictionary *)priceDict workStyle:(NSDictionary *)workStyleDict  area:(NSDictionary *)areaDict;
/** 获取 标签信息 .
 返回： 标签
 */
- (NSMutableArray *)getTagsForSort:(NSString * )sort;
- (NSMutableArray *)get3DTagsForSort:(NSString * )sort;


- (NSMutableArray *)getCaseForTags:(NSMutableArray * )tagsArray;

@end
