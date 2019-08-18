--1
select * from wsjb.ad53a4 where yae092='1000031647'
select * from wsjb.ad53a6 where yae093='1000000021' and  yae092='1000031647'
select * from wsjb.ad53a8 where yae092='1000031647'
select * from wsjb.iraa01 where aab001='855555' and aae100='1'
select * from wsjb.irab01 where aab001='855555'
select * from wsjb.ae02 where aaz002='100000003286394'
select * from xasi2.ab01a3 where aab001='855555'
select * from xagxwt.tauser where loginid='855555'
select * from xagxwt.tauserposition where userid ='1000031647'
select * from xagxwt.taposition where positionid in ('110066','1397415')

--2
select * from xasi2.ab01 where aab001='855555'
select * from xasi2.ab02 where aab001='855555'
select * from xasi2.ac02 where aab001='855555'
select * from xasi2.ac01 where aac001 in (select aac001 from xasi2.ac02 where aab001='855555')
select * from xasi2.kc01 where aac001 in (select aac001 from xasi2.ac02 where aab001='855555')
select * from wsjb.irac01a3 where aac002 in (select aac002 from xasi2.ac01 where aab001='855555')

--3
select * from wsjb.irac01 where aab001='855555'
select * from wsjb.irad01 where aab001='855555'
select * from wsjb.irad02 where iaz004 in (select iaz004 from wsjb.irad01 where aab001='855555')

--4
select * from xasi2.ab08 where aab001='855555'
select * from xasi2.ab08a8 where aab001='855555'
select * from xasi2.ac08 where aab001='855555'
select * from xasi2.ac08a1 where aab001='855555'
select * from wsjb.irac08a1 where aab001='855555'
select * from wsjb.irab08 where aab001='855555'

