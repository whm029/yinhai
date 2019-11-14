-- Create table
create table TMP_SC01
(
  yae099 VARCHAR2(20),
  iac001 VARCHAR2(30),
  aae123 VARCHAR2(6),
  aab001 VARCHAR2(15),
  aac001 VARCHAR2(15),
  aae140 VARCHAR2(6),
  aae002 NUMBER(6),
  aac040 NUMBER(14,2),
  yac004 NUMBER(14,2),
  yae031 VARCHAR2(6),
  aae011 VARCHAR2(15),
  aae036 DATE,
  aae100 VARCHAR2(6),
  aae013 VARCHAR2(200)
)
tablespace DATA01
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column TMP_SC01.yae099
  is '业务流水号';
comment on column TMP_SC01.aae123
  is '补收类型';
comment on column TMP_SC01.aab001
  is '单位编号';
comment on column TMP_SC01.aac001
  is '个人编号';
comment on column TMP_SC01.aae140
  is '险种';
comment on column TMP_SC01.aae002
  is '费款所属期';
comment on column TMP_SC01.aac040
  is '申报工资';
comment on column TMP_SC01.yac004
  is '申报基数';
comment on column TMP_SC01.yae031
  is '审核状态';
comment on column TMP_SC01.aae011
  is '经办人';
comment on column TMP_SC01.aae036
  is '经办时间';
comment on column TMP_SC01.aae100
  is '有效标志';
comment on column TMP_SC01.aae013
  is '备注';
