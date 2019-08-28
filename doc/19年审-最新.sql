/*
855555  111111
830558 111111 单养老
854518  111111  企业   (已审核)
855905  111111 企业
890009  111111  弄些人进来
132967  111111  6 7 8 月在高新
*/

--   比例补差  基数补差 补差欠费  限制年审
 
-- 原缴费工资和基数是从 AC02取的 取不到再去irac01取, 但是如果提前结算的人转出去了 ac02 取不到 irac01取的是 减少的那一天工资是0
     
wsjb.pkg_P_Validate.prc_p_checkInfoByYear

select * from xasi2.ac01k8 where aab001='855905' and aae001='2019' --for update 
select * from wsjb.irad51 where aab001='855555' 
select * from wsjb.yearapply_confirm -- for update 

select * from wsjb.tmp_ac42 where aab001='855555'  and aac001='1006218794'
select * from xasi2.ac01k8 where aab001='855555' and aae001='2019' and aac001='9910506277' --for update 
select * from xasi2.ac01k8 where aab001='855555' and aae001='2019' and (aae013 is null or aae013 ='1')


select * from irad54 where aab001='855905'-- for update 
select * from irad53 where aab001='855905'-- for update 

select * from  wsjb.irad51a1 for update 
select * from  wsjb.irad51a2 for update 

select * from xasi2.ab05 where aab001='855555' for update 

select * from wsjb.tmp_ac42 where aab001='855555' and aae140='01'
select * from xasi2.ac01k8 where aab001='855555'  



 select  
  decode(aae140,
               'AAE110','01',
               'AAE210','02',
               'AAE310','03',
               'AAE410','04',
               'AAE510','05',
               'AAE311','07') AS aae140, 
   aac031
  from xasi2.ac01k8 
  unpivot(aac031 for aae140 in(aae110,aae210, aae310,aae410,aae510, aae311))
 where aab001 = '855555'
   and aae001 = '2019'
   and aac001 = '1006218794'
 
--补差过程
xasi2.pkg_p_yearOfCarefulFinal.prc_p_getJobStartTime
prm_daytype 人数超过2千的写2
 
--申报补差校验(预览用)
--------------------------------------
XASI2.pkg_p_salaryExamineAdjust

 --modify by fenggg at 20181202 begin
 --高新四险基数降低不退费,所以负补差基数处理成0
   IF prm_yab139 = '610127' and prm_yac004 < 0 then
      prm_yac004 := 0;
   END IF;
 --modify by fenggg at 20181202 end

 --基数没变化。
   IF prm_yac004 = 0 THEN
      prm_AppCode := gs_FunNo||var_procNo||'02';
      prm_ErrMsg  := '基数没有发生变化，不用补差';
      RETURN;
   END IF;
--------------------------------------        
         
 
 

SELECT  
       A.AAC040 AS AAC040,  -- 新缴费工资 -->
        decode(sign(2019-2019),0,A.YAC004,1,A.YAC004,A.YAA333) AS YAA333_02,
        decode(sign(2019-2019),0,A.YAC004,1,A.YAC004,A.YAA333) AS YAA333_04
       FROM xasi2.ac01k8 A, XASI2.AC01A1 B ,XASI2.AC01 C
      WHERE A.AAC001 = B.AAC001(+)
        AND A.AAC001 = C.AAC001(+)
        AND A.AAB001 = '854518'
        AND A.AAE001 = '2019'
        AND A.YAB019 = '1'
      ORDER BY A.YAE110 DESC,
               A.YAE310 DESC,
               A.YAE210 DESC,
               A.YAE410 DESC,
               A.YAE510 DESC,
               A.AAC003
--     sign()  返回 0 1 -1 三个值          
               
             
select * from xasi2.ac01  where aac002='152325197107182941'
