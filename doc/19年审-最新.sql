/*
855555  111111
830558 111111 ������
854518  111111  ��ҵ   (�����)
855905  111111 ��ҵ
890009  111111  ŪЩ�˽���
132967  111111  6 7 8 ���ڸ���
*/

--   ��������  �������� ����Ƿ��  ��������
 
-- ԭ�ɷѹ��ʺͻ����Ǵ� AC02ȡ�� ȡ������ȥirac01ȡ, ���������ǰ�������ת��ȥ�� ac02 ȡ���� irac01ȡ���� ���ٵ���һ�칤����0
     
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
 
--�������
xasi2.pkg_p_yearOfCarefulFinal.prc_p_getJobStartTime
prm_daytype ��������2ǧ��д2
 
--�걨����У��(Ԥ����)
--------------------------------------
XASI2.pkg_p_salaryExamineAdjust

 --modify by fenggg at 20181202 begin
 --�������ջ������Ͳ��˷�,���Ը�������������0
   IF prm_yab139 = '610127' and prm_yac004 < 0 then
      prm_yac004 := 0;
   END IF;
 --modify by fenggg at 20181202 end

 --����û�仯��
   IF prm_yac004 = 0 THEN
      prm_AppCode := gs_FunNo||var_procNo||'02';
      prm_ErrMsg  := '����û�з����仯�����ò���';
      RETURN;
   END IF;
--------------------------------------        
         
 
 

SELECT  
       A.AAC040 AS AAC040,  -- �½ɷѹ��� -->
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
--     sign()  ���� 0 1 -1 ����ֵ          
               
             
select * from xasi2.ac01  where aac002='152325197107182941'
