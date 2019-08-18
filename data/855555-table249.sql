 --2
insert into xasi2.ab01
select * from xasi2.ab01@dlk_153 where aab001='855555';

insert into xasi2.ab02
select * from xasi2.ab02@dlk_153 where aab001='855555';

insert into xasi2.ac02
select * from xasi2.ac02@dlk_153 where aab001='855555';

insert into xasi2.ac01
select * from xasi2.ac01@dlk_153 where aac001 in (select aac001 from xasi2.ac02 where aab001='855555');

insert into xasi2.kc01
select * from xasi2.kc01@dlk_153 where aac001 in (select aac001 from xasi2.ac02 where aab001='855555');

insert into wsjb.irac01a3
select * from wsjb.irac01a3@dlk_153 where aac002 in (select aac002 from xasi2.ac01 where aab001='855555');

--3
insert into wsjb.irac01
select * from wsjb.irac01@dlk_153 where aab001='855555' and iaa100 >201812;

insert into wsjb.irad01
select * from wsjb.irad01@dlk_153 where aab001='855555' and iaa100 >201812;

insert into wsjb.irad02
  (iaz005,
   iaz006,
   iaz004,
   iaz007,
   iaz008,
   iad003,
   aac001,
   aae035,
   yab003,
   iaa004,
   iaa014,
   iaa015,
   iaa016,
   aae013,
   iaa020)
  (select iaz005,
          iaz006,
          iaz004,
          iaz007,
          iaz008,
          iad003,
          aac001,
          aae035,
          yab003,
          iaa004,
          iaa014,
          iaa015,
          iaa016,
          aae013,
          iaa020
     from wsjb.irad02@dlk_153
    where iaz004 in
          (select iaz004 from wsjb.irad01 where aab001 = '855555'));

--4
insert into xasi2.ab08
select * from xasi2.ab08@dlk_153 where aab001='855555' and aae042 >201812;

insert into xasi2.ab08a8
select * from xasi2.ab08a8@dlk_153 where aab001='855555' and aae042 >201812;

insert into xasi2.ac08
select * from xasi2.ac08@dlk_153 where aab001='855555' and aae002 >201812;

insert into xasi2.ac08a1
select * from xasi2.ac08a1@dlk_153 where aab001='855555' and aae002 >201812;

insert into wsjb.irac08a1
select * from wsjb.irac08a1@dlk_153 where aab001='855555' and aae002 >201812;

insert into wsjb.irab08
select * from wsjb.irab08@dlk_153 where aab001='855555' and aae042 >201812;
