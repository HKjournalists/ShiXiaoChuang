//
//  ZHDBData.m
//  Dyrs
//
//  Created by mbp  on 13-9-9.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "ZHDBData.h"
#import "ZHDBControl.h"


ZHDBData *dbData;


@implementation ZHDBData

+ (ZHDBData *)share
{
    if (dbData == nil)
    {
        dbData = [[ZHDBData alloc] init];
    }
    
    return dbData;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        
//        if ([[ZHDBControl share] checkDB]) {            
            NSString *dbPath = nil;
            
            dbPath = [KDocumentDirectory stringByAppendingPathComponent:db_name];
            db = [[FMDatabase alloc]initWithPath:dbPath];
            
//        }
    }
    return self;
}

- (void)dealloc
{
    
    if (![db open]) {
        return;
    }
    db = nil;
}


#pragma mark  命令执行

- (void)insertTable:(NSString *)sql
{
    
    //    create table
    if ([db open]) {
        
        
        NSArray * commands = [sql componentsSeparatedByString:@";"];
        for(NSString * sqlString in commands)
        {
            BOOL res = [db executeUpdate:sqlString];
            if (!res) {
                DLog(@"error===========  %@", sqlString);
            } else {
                DLog(@"succ ");
            }
            
        }
        
        [db close];
    }
    else {
        DLog(@"error=========== when open db");
    }
}



- (void)stringToDBSqlString:(NSString *)sqlString
{
    
    if (!sqlString) {
        return;
    }
    
    if ([db open]) {
        
        bool statue =  [db executeUpdate:
                        sqlString];
        if (statue) {
            
        }
        else {
            DLog(@"statue:%i error: %@", statue, sqlString);
        }
        
    }
    else {
        DLog(@"db Not  open");
    }
}

- (void)dictToDB:(NSDictionary *)dict sqlString:(NSString *)sqlString
{
    if (!sqlString) {
        return;
    }
    
    if ([db open]) {

        bool statue =  [db executeUpdate:
                        sqlString withParameterDictionary:dict];
        
        if (statue) {
        }
        else {
            DLog(@"statue:%i error: %@,  \n lasterror:%@", statue, sqlString, db.lastError);
        }
    }
}


#pragma mark -

- (NSMutableArray *)getNumForModle:(NSString * )modle
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select DISTINCT number from product_base where letter = %@ order by number asc", modle];
    

    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[rs stringForColumn:@"number"] forKey:@"number"];

            
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;

}

- (NSMutableArray *)getNameForModle:(NSString * )modle Num:(NSString * )num
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select pd.product_id, pb.remark pb_remark, pb.letter pb_letter, pb.number pb_number,pd.name pd_name, ct.name ct_name from product_base pb, product_detil pd, category ct WHERE pb.product_id = pd.product_id and  pb.cate_id = ct.cate_id  and pb.letter = %@ and pb.number = %@", modle, num];
    

    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:[rs intForColumn:@"product_id"]] forKey:@"product_id"];
            [dict setValue:[rs stringForColumn:@"pd_name"] forKey:@"pd_name"];
            [dict setValue:[rs stringForColumn:@"ct_name"] forKey:@"ct_name"];
            [dict setValue:[rs stringForColumn:@"pb_number"] forKey:@"pb_number"];
            [dict setValue:[rs stringForColumn:@"pb_letter"] forKey:@"pb_letter"];
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
}


- (NSMutableArray *)getNameForModle:(NSString * )modle Num:(NSString * )num name:(NSString *)name
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select  DISTINCT pd.product_id, pb.remark pb_remark, pb.letter pb_letter, pb.number pb_number,pd.name pd_name, ct.name ct_name from product_base pb, product_detil pd, category ct WHERE pb.product_id = pd.product_id and  pb.cate_id = ct.cate_id  and pb.letter = %@ and pb.number = '%@' ", modle, num];
    
    if (name) {
        sqlString = [NSString stringWithFormat:
                      @"select   pd.product_id, pb.remark pb_remark, pb.letter pb_letter, pb.number pb_number,pd.name pd_name, ct.name ct_name from product_base pb, product_detil pd, category ct WHERE pb.product_id = pd.product_id and  pb.cate_id = ct.cate_id  and pb.letter = %@ and pb.number = '%@' and pd.name = '%@'  ", modle, num, name];
    }
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:[rs intForColumn:@"product_id"]] forKey:@"product_id"];
            [dict setValue:[rs stringForColumn:@"pd_name"] forKey:@"pd_name"];
            [dict setValue:[rs stringForColumn:@"ct_name"] forKey:@"ct_name"];
            [dict setValue:[rs stringForColumn:@"pb_number"] forKey:@"pb_number"];
            [dict setValue:[rs stringForColumn:@"pb_letter"] forKey:@"pb_letter"];
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
}



- (NSMutableArray *)getPics
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select fid, houseTypeUrls, workPicUrls from APP_360Works"];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:[rs intForColumn:@"fid"]] forKey:@"fid"];
            [dict setValue:[rs stringForColumn:@"houseTypeUrls"] forKey:@"url"];
            [dict setValue:[[rs stringForColumn:@"houseTypeUrls"] md5]forKey:@"name"];
            
            [dataArray addObject:dict];
            
            
//            workPicUrls
            NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
            [dict1 setValue:[NSNumber numberWithInt:[rs intForColumn:@"fid"]] forKey:@"fid"];
            [dict1 setValue:[rs stringForColumn:@"workPicUrls"] forKey:@"url"];
            [dict1 setValue:[[rs stringForColumn:@"workPicUrls"] md5]forKey:@"name"];
            
            [dataArray addObject:dict1];
            
            
            
        }
        
        sqlString = @"select fid, WorksSpaceID,workscontentpic from APP_360WorksContent";
        rs = [db executeQuery:sqlString];
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[rs stringForColumn:@"fid"]  forKey:@"fid"];
            [dict setValue:[rs stringForColumn:@"workscontentpic"] forKey:@"url"];
            
            NSArray *array = [[rs stringForColumn:@"WorksContentPic"] componentsSeparatedByString:@"/"];
            NSString *fileNameStr = [array lastObject];
            NSString *filePath = [NSString stringWithFormat:@"%@%@", [rs stringForColumn:@"WorksSpaceID"] , fileNameStr];
            [dict setValue:filePath forKey:@"name"];
            
            [dataArray addObject:dict];
            
        }

        sqlString = @"select fid, APP_designerInfo.designerPic from APP_designerInfo";
        rs = [db executeQuery:sqlString];
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:[rs intForColumn:@"fid"]] forKey:@"fid"];
            [dict setValue:[rs stringForColumn:@"designerPic"] forKey:@"url"];
            [dict setValue:[[rs stringForColumn:@"designerPic"] md5]forKey:@"name"];
            
            [dataArray addObject:dict];
            
        }
        
        sqlString = @"select fid, workPicUrls from APP_designerWorks";
        rs = [db executeQuery:sqlString];
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:[rs intForColumn:@"fid"]] forKey:@"fid"];
            [dict setValue:[rs stringForColumn:@"workPicUrls"] forKey:@"url"];
            [dict setValue:[[rs stringForColumn:@"workPicUrls"] md5]forKey:@"name"];
            
            [dataArray addObject:dict];
            
        }
        sqlString = @"select fid, WorksContentPic  from APP_designerWorksContent";
        rs = [db executeQuery:sqlString];
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:[rs intForColumn:@"fid"]] forKey:@"fid"];
            [dict setValue:[rs stringForColumn:@"WorksContentPic"] forKey:@"url"];
            [dict setValue:[[rs stringForColumn:@"WorksContentPic"] md5] forKey:@"name"];

            [dataArray addObject:dict];
            
        }
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
}


- (NSMutableArray *)getPicsForProductId:(NSString *)pro_id
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select *  from picture  where statue = 1 and product_id = %@", pro_id];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:[rs intForColumn:@"picture_id"]] forKey:@"picture_id"];
            [dict setValue:[rs stringForColumn:@"url"] forKey:@"url"];
            [dict setValue:[rs stringForColumn:@"name"] forKey:@"name"];
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;

}


- (NSMutableArray *)getDetailForProductId:(NSString *)pro_id
{
    
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select pd.standard, pd.name, pd.price, pb.remark   from product_detil pd, product_base pb where pb.product_id = pd.product_id and pd.product_id =  %@", pro_id];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:[rs doubleForColumn:@"price"]] forKey:@"price"];
            [dict setValue:[rs stringForColumn:@"standard"] forKey:@"standard"];
            [dict setValue:[rs stringForColumn:@"name"] forKey:@"name"];
            [dict setValue:[rs stringForColumn:@"remark"] forKey:@"remark"];
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
    
    
    
}


- (NSMutableArray *)getProductForCategory:(NSString * )cateId
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select   pd.product_id, pb.remark pb_remark, pb.letter pb_letter, pb.number pb_number,pd.name pd_name, ct.name ct_name from product_base pb, product_detil pd, category ct WHERE pb.product_id = pd.product_id and  pb.cate_id = ct.cate_id  and pb.cate_id = %@ GROUP BY pb.product_id", cateId];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:[rs intForColumn:@"product_id"]] forKey:@"product_id"];
            [dict setValue:[rs stringForColumn:@"pd_name"] forKey:@"pd_name"];
            [dict setValue:[rs stringForColumn:@"ct_name"] forKey:@"ct_name"];
            [dict setValue:[rs stringForColumn:@"pb_number"] forKey:@"pb_number"];
            [dict setValue:[rs stringForColumn:@"pb_letter"] forKey:@"pb_letter"];
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    return dataArray;
}


- (NSMutableArray *)getSubCateForCategory:(NSString * )cateId
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select *  from category  where fid = %@", cateId];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:[rs intForColumn:@"cate_id"]] forKey:@"cate_id"];
            [dict setValue:[rs stringForColumn:@"name"] forKey:@"name"];
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
}


- (NSMutableArray *)getProductForSerices:(NSString * )sericesId
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select   pd.product_id, pb.remark remark,pb.letter pb_letter, pb.number pb_number,pd.name pd_name, ct.name ct_name from product_base pb, product_detil pd, category ct WHERE pb.product_id = pd.product_id and  pb.cate_id = ct.cate_id  and pb.series_id = %@ GROUP BY pb.product_id", sericesId];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:[rs intForColumn:@"product_id"]] forKey:@"product_id"];
            [dict setValue:[rs stringForColumn:@"pd_name"] forKey:@"pd_name"];
            [dict setValue:[rs stringForColumn:@"ct_name"] forKey:@"ct_name"];
            [dict setValue:[rs stringForColumn:@"pb_number"] forKey:@"pb_number"];
            [dict setValue:[rs stringForColumn:@"pb_letter"] forKey:@"pb_letter"];
            
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
}







- (void)updatePicDownLoaded:(NSString *)pid
{
    NSString *sqlString = [NSString stringWithFormat:
                           @"update picture set statue = 1 where picture_id = %@", pid];
    
    [self stringToDBSqlString:sqlString];
}




- (void)deleteAllData
{
    NSString *sqlString = [NSString stringWithFormat:
                           @"DELETE from APP_360Works; DELETE from APP_360WorksContent;DELETE from APP_360WorksSpace; DELETE from APP_designerInfo;DELETE from APP_designerWorks; DELETE from APP_designerWorksContent;DELETE from APP_prototypePICs; DELETE from APP_prototypeRoom;"];
    
    [self insertTable:sqlString];
    

}

- (NSMutableDictionary *)getDesignerForD_Id:(NSString * )designer_id
{
    
    
    NSMutableDictionary *dataDict  = [[NSMutableDictionary alloc] init];
    
//    select real_name, mobile, email, adress, introduction from "d_designer" d, "d_user" u where d.user_ID = u.id
//    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select * from APP_designerInfo"];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:[rs intForColumn:@"fid"]] forKey:@"fid"];
            [dict setValue:[rs stringForColumn:@"designerName"] forKey:@"designerName"];
            [dict setValue:[rs stringForColumn:@"designerPic"] forKey:@"designerPic"];
            [dict setValue:[rs stringForColumn:@"designerDes"] forKey:@"designerDes"];

            
            

            dataDict = dict;
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataDict;

}

// 获取案例列表

- (NSMutableArray *)getCasesForD_Id:(NSString * )designer_id
{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select fid,workPicUrls, workStyle, Price, Room, description from APP_designerWorks"];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue: [rs stringForColumn:@"fid"]  forKey:@"fid"];
            [dict setValue:[rs stringForColumn:@"workPicUrls"] forKey:@"workPicUrls"];
            [dict setValue:[rs stringForColumn:@"workStyle"] forKey:@"workStyle"];
            [dict setValue:[rs stringForColumn:@"Price"] forKey:@"Price"];
            [dict setValue:[rs stringForColumn:@"Room"] forKey:@"Room"];
            [dict setValue:[rs stringForColumn:@"description"] forKey:@"description"];

            
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }

    return dataArray;
}

- (NSMutableArray *)get3DCasesSpace:(NSString * )Case_id
{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select fid,WorksID, workPicUrl, StyleRoom from APP_360WorksSpace where WorksID = '%@'", Case_id];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue: [rs stringForColumn:@"fid"]     forKey:@"fid"];
            [dict setValue:[rs stringForColumn:@"WorksID"] forKey:@"WorksID"];
            [dict setValue:[rs stringForColumn:@"workPicUrl"] forKey:@"workPicUrl"];
            [dict setValue:[rs stringForColumn:@"StyleRoom"] forKey:@"StyleRoom"];

            
            
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    return dataArray;
}

- (NSMutableArray *)get3DCasesSpaceImages:(NSString * )Case_id
{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select * from APP_360WorksContent where WorksSpaceID = '%@'", Case_id];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue: [rs stringForColumn:@"fid"]     forKey:@"fid"];
            [dict setValue:[rs stringForColumn:@"WorksContentPic"] forKey:@"WorksContentPic"];

            
            
            
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    return dataArray;
}



- (NSMutableArray *)get3DCasesForD_Id:(NSString * )designer_id;
{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select fid,workPicUrls, houseTypeUrls, workStyle, Price, Room from APP_360Works"];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue: [rs stringForColumn:@"fid"]     forKey:@"fid"];
            [dict setValue:[rs stringForColumn:@"workPicUrls"] forKey:@"workPicUrls"];
            [dict setValue:[rs stringForColumn:@"houseTypeUrls"] forKey:@"houseTypeUrls"];
            [dict setValue:[rs stringForColumn:@"workStyle"] forKey:@"workStyle"];
            [dict setValue:[rs stringForColumn:@"Price"] forKey:@"Price"];
            [dict setValue:[rs stringForColumn:@"Room"] forKey:@"Room"];
            [dict setValue:[rs stringForColumn:@"description"] forKey:@"description"];
            [dict setValue:[rs stringForColumn:@"houseTypeUrls"] forKey:@"houseTypeUrls"];
            
            
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    return dataArray;
}


- (NSMutableArray *)getCasesDetailForC_Id:(NSString * )case_id
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
//    select p.id , ap.photo_id, p.name, p.path, p.store_name from d_ablum_photo ap, d_photo p where ap.photo_id = p.id and  ap.ablum_id = 1

    NSString *sqlString = [NSString stringWithFormat:
                           @"select * from APP_designerWorksContent where fid =  %@;", case_id];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue: [rs stringForColumn:@"fid"]   forKey:@"fid"];
            [dict setValue:[rs stringForColumn:@"WorksContentPic"] forKey:@"WorksContentPic"];
            [dict setValue:[rs stringForColumn:@"designerWorksID"] forKey:@"designerWorksID"];

            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    
    

    
    return dataArray;
}


- (NSMutableArray *)get3DCasesDetailForC_Id:(NSString * )case_id
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select * from  APP_360WorksContent WHERE WorksSpaceID = '%@';", case_id];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue: [rs stringForColumn:@"fid"]  forKey:@"fid"];
            [dict setValue:[rs stringForColumn:@"WorksContentPic"] forKey:@"WorksContentPic"];
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    
    
    
    
    return dataArray;
}


// 获取手绘列表
- (NSMutableArray *)getPhotoForD_Id:(NSString * )designer_id
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    //    select p.id , ap.photo_id, p.name, p.path, p.store_name from d_ablum_photo ap, d_photo p where ap.photo_id = p.id and  ap.ablum_id = 1
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select p.id , ap.photo_id, p.name, p.path, p.store_name from d_ablum_photo ap, d_photo p where ap.photo_id = p.id and  ap.ablum_id = %@;", designer_id];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:[rs intForColumn:@"id"]] forKey:@"id"];
            [dict setValue:[rs stringForColumn:@"photo_id"] forKey:@"photo_id"];
            [dict setValue:[rs stringForColumn:@"name"] forKey:@"name"];
            [dict setValue:[rs stringForColumn:@"path"] forKey:@"path"];
            [dict setValue:[rs stringForColumn:@"store_name"] forKey:@"store_name"];
            
            
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    
    
    
    
    return dataArray;
}

// 获取设计师 文档 列表
- (NSMutableArray *)getFilesForD_Id:(NSString * )designer_id
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"SELECT p.name, p.id, store_name, path from d_photo_rela pr , d_photo p where pr.designer_id = p.id and pr.designer_id = %@", designer_id];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:[rs intForColumn:@"id"]] forKey:@"id"];
            [dict setValue:[rs stringForColumn:@"show_name"] forKey:@"show_name"];
            [dict setValue:[rs stringForColumn:@"path"] forKey:@"path"];

            
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
}


- (NSMutableArray *)getTagsForD_Id:(NSString * )designer_id
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select sort, name from d_tag where des_id = %@ group by sort ", designer_id];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:[rs intForColumn:@"sort"]] forKey:@"sort"];
            [dict setValue:[rs stringForColumn:@"name"] forKey:@"name"];
            
            
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
}

- (NSMutableArray *)getCaseForTags:(NSDictionary * )roomDict mealDict:(NSDictionary *)mealDict price:(NSDictionary *)priceDict workStyle:(NSDictionary *)workStyleDict area:(NSDictionary *)areaDict
{
    
    NSMutableString *str = [NSMutableString stringWithFormat:@""];
    
    if (roomDict != nil) {
        [str appendFormat:@"Room = '%@' and ", roomDict[@"Room"]];
    }
    if (mealDict != nil) {
        [str appendFormat:@"setMeal = '%@' and ",  mealDict[@"setMeal"]];
    }
    if (priceDict != nil) {
        [str appendFormat:@"priceInterval = '%@' and ",    priceDict[@"priceInterval"]];
    }
    if (workStyleDict != nil) {
      [str appendFormat:@"workStyle= '%@' and ",  workStyleDict[@"workStyle"]];
    }
    if (areaDict != nil) {
        [str appendFormat:@"areaInterval= '%@' and ",  areaDict[@"areaInterval"]];
    }
    


    if (str.length > 1) {
        str = (NSMutableString *)[str substringWithRange:NSMakeRange(0, str.length-4)];
    }
    
    
    
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"SELECT * from APP_designerWorks WHERE %@ ", str];
    if (str.length == 0) {
        sqlString = @"SELECT * from APP_designerWorks";
    }
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue: [rs stringForColumn:@"fid"]  forKey:@"fid"];
            [dict setValue:[rs stringForColumn:@"workPicUrls"] forKey:@"workPicUrls"];
            [dict setValue:[rs stringForColumn:@"workStyle"] forKey:@"workStyle"];
            [dict setValue:[rs stringForColumn:@"Price"] forKey:@"Price"];
            [dict setValue:[rs stringForColumn:@"Room"] forKey:@"Room"];
            
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
    
}

- (NSMutableArray *)get3DCaseForTags:(NSDictionary * )roomDict mealDict:(NSDictionary *)mealDict price:(NSDictionary *)priceDict workStyle:(NSDictionary *)workStyleDict  area:(NSDictionary *)areaDict
{
    
    NSMutableString *str = [NSMutableString stringWithFormat:@""];
    
    if (roomDict != nil) {
        [str appendFormat:@"Room = '%@' and ", roomDict[@"Room"]];
    }
    if (mealDict != nil) {
        [str appendFormat:@"setMeal = '%@' and ",  mealDict[@"setMeal"]];
    }
    if (priceDict != nil) {
        [str appendFormat:@"priceInterval = '%@' and ",    priceDict[@"priceInterval"]];
    }
    if (workStyleDict != nil) {
        [str appendFormat:@"workStyle= '%@' and ",  workStyleDict[@"workStyle"]];
    }
    if (areaDict != nil) {
        [str appendFormat:@"areaInterval= '%@' and ",  areaDict[@"areaInterval"]];
    }
    
    

    if (str.length > 1) {
        str = (NSMutableString *)[str substringWithRange:NSMakeRange(0, str.length-4)];
    }
    
    
    
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"SELECT * from APP_360Works WHERE %@ ", str];
    if (str.length == 0) {
        sqlString = @"SELECT * from APP_360Works";
    }
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue: [rs stringForColumn:@"fid"]  forKey:@"fid"];
            [dict setValue:[rs stringForColumn:@"workPicUrls"] forKey:@"workPicUrls"];
            [dict setValue:[rs stringForColumn:@"workStyle"] forKey:@"workStyle"];
            [dict setValue:[rs stringForColumn:@"Price"] forKey:@"Price"];
            [dict setValue:[rs stringForColumn:@"Room"] forKey:@"Room"];
            
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
    
}


- (NSMutableArray *)getTagsForSort:(NSString * )sort
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableString *sqlString = [NSMutableString stringWithFormat:
                           @"select id,sort, name  from d_tag " ];
    

    if ([sort isEqualToString:@"户型"]) {
        sqlString = [NSMutableString stringWithFormat:
                     @"SELECT DISTINCT(  Room  ) from APP_designerWorks  "];

    }
    else if ([sort isEqualToString:@"套餐"]) {
        sqlString = [NSMutableString stringWithFormat:
                     @"SELECT DISTINCT(  setMeal ) from APP_designerWorks  "];
    }
    else if ([sort isEqualToString:@"价格"]) {
        sqlString = [NSMutableString stringWithFormat:
                     @"SELECT DISTINCT(  priceInterval ) from APP_designerWorks  "];
    }
    else if ([sort isEqualToString:@"风格"]) {
        sqlString = [NSMutableString stringWithFormat:
                     @"SELECT DISTINCT(  workStyle ) from APP_designerWorks  "];
    }
    else if ([sort isEqualToString:@"面积"]) {
        sqlString = [NSMutableString stringWithFormat:
                     @"SELECT DISTINCT(  areaInterval ) from APP_360Works  "];
    }
    
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

            [dict setValue:[rs stringForColumn:@"Room"] forKey:@"Room"];
            [dict setValue:[rs stringForColumn:@"Room"] forKey:@"Room"];
            [dict setValue:[rs stringForColumn:@"setMeal"] forKey:@"setMeal"];
            [dict setValue:[rs stringForColumn:@"Price"] forKey:@"Price"];
            [dict setValue:[rs stringForColumn:@"workStyle"] forKey:@"workStyle"];
            
            [dict setValue:[rs stringForColumn:@"priceInterval"] forKey:@"priceInterval"];
            [dict setValue:[rs stringForColumn:@"areaInterval"] forKey:@"areaInterval"];
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
}


- (NSMutableArray *)get3DTagsForSort:(NSString * )sort
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableString *sqlString = [NSMutableString stringWithFormat:
                                  @"select id,sort, name  from d_tag " ];
    
    
    if ([sort isEqualToString:@"户型"]) {
        sqlString = [NSMutableString stringWithFormat:
                     @"SELECT DISTINCT(  Room  ) from APP_360Works  "];
        
    }
    else if ([sort isEqualToString:@"套餐"]) {
        sqlString = [NSMutableString stringWithFormat:
                     @"SELECT DISTINCT(  setMeal ) from APP_360Works  "];
    }
    else if ([sort isEqualToString:@"价格"]) {
        sqlString = [NSMutableString stringWithFormat:
                     @"SELECT DISTINCT(  priceInterval ) from APP_360Works  "];
    }
    else if ([sort isEqualToString:@"风格"]) {
        sqlString = [NSMutableString stringWithFormat:
                     @"SELECT DISTINCT(  workStyle ) from APP_360Works  "];
    }
    else if ([sort isEqualToString:@"面积"]) {
        sqlString = [NSMutableString stringWithFormat:
                     @"SELECT DISTINCT(  areaInterval ) from APP_360Works  "];
    }
    
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            [dict setValue:[rs stringForColumn:@"Room"] forKey:@"Room"];
            [dict setValue:[rs stringForColumn:@"Room"] forKey:@"Room"];
            [dict setValue:[rs stringForColumn:@"setMeal"] forKey:@"setMeal"];
            [dict setValue:[rs stringForColumn:@"priceInterval"] forKey:@"Price"];
            [dict setValue:[rs stringForColumn:@"workStyle"] forKey:@"workStyle"];
            
            [dict setValue:[rs stringForColumn:@"priceInterval"] forKey:@"priceInterval"];
            [dict setValue:[rs stringForColumn:@"areaInterval"] forKey:@"areaInterval"];
            
            
            [dataArray addObject:dict];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
}


@end
