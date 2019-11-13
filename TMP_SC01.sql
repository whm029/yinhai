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
  is 'ҵ����ˮ��';
comment on column TMP_SC01.aae123
  is '��������';
comment on column TMP_SC01.aab001
  is '��λ���';
comment on column TMP_SC01.aac001
  is '���˱��';
comment on column TMP_SC01.aae140
  is '����';
comment on column TMP_SC01.aae002
  is '�ѿ�������';
comment on column TMP_SC01.aac040
  is '�걨����';
comment on column TMP_SC01.yac004
  is '�걨����';
comment on column TMP_SC01.yae031
  is '���״̬';
comment on column TMP_SC01.aae011
  is '������';
comment on column TMP_SC01.aae036
  is '����ʱ��';
comment on column TMP_SC01.aae100
  is '��Ч��־';
comment on column TMP_SC01.aae013
  is '��ע';
