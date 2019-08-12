--854518 
     
wsjb.pkg_P_Validate.prc_p_checkInfoByYear

select * from xasi2.ac01k8 where aab001='854518' and aae001='2019' and  aac001='0003488038'
select * from wsjb.irad51 where aab001='854518' 
select * from wsjb.yearapply_confirm  for update  --for update 

select * from wsjb.tmp_ac42


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
 where aab001 = '854518'
   and aae001 = '2019'
   and aac001 = '0003488038'
 
--补差过程
xasi2.pkg_p_yearOfCarefulFinal.prc_p_getJobStartTime
prm_daytype 人数超过2千的写2
 
 
 
 select * from xasi2.aa35 where aae001='2019' for update;
 select * from xasi2.ab05 where aab001='854518' for update;
 select * from xasi2.ab02 where aab001='854518' for update;   
 select * from wsjb.irab08 where aab001='854518' and aae003>201812 --for update;
 
insert into xasi2.aa35 (YAB139, AAE001, AAE030, AAE031, YAE097)
values ('$$$$', 2019, to_date('01-08-2019', 'dd-mm-yyyy'), to_date('31-12-2019', 'dd-mm-yyyy'), 201908);
