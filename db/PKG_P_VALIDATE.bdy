CREATE OR REPLACE PACKAGE BODY "PKG_P_VALIDATE"
/*****************************************************************************/
/*  ������� ��pkg_P_Validate                                                */
/*  ҵ�񻷽� ����λȨ����֤                                                  */
/*  �������� ��                                                              */
/*                                                                           */
/*  ��    �� ���Ĵ���Զ��������ɷ����޹�˾                                  */
/*  �������� ��2015-11-11           �汾��� ��Ver 1.0.0                     */
/*---------------------------------------------------------------------------*/
/*  �޸ļ�¼ ��                                                              */
/*****************************************************************************/
AS

   PRE_ERRCODE CONSTANT VARCHAR2(45) := 'prc_p_ValidatePrivilege'; --�����Ĵ�����ǰ׺

  /*--------------------------------------------------------------------------
   || ҵ�񻷽� ����λȨ����֤
   || �������� ��prc_P_ValidateAab001Privilege
   || �������� ������δͨ������λ��Ϣ�쳣��δ��׼�±�����λȨ�޿��ƣ���λ�����ںŲ�һ��ʱ�޷�������λ
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��cora          ������� ��2015-11-11
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_P_ValidateAab001Privilege(
      prm_aab001          IN            VARCHAR2,     --��λ���
      prm_msg             OUT           VARCHAR2,     --������Ϣ
      prm_sign            OUT           VARCHAR2,     --�����־
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2)     --������Ϣ
   IS
       /*�ֶζ���*/
      var_iaa002     VARCHAR2(30); -- ��˱�־
      var_yab010     irab01.yab010%TYPE;  -- δ��׼�±�
      num_count1     NUMBER(6);    --  aab001�Ƿ���ڶ�����Ϣ
      num_count2     NUMBER(6);    --  irab01 ��λ�Ƿ���ڶ�����Ϣ
      num_count3     NUMBER(6);    --  irab01 �жϵ�λ��������ں��Ƿ�һ��
      /*�α�����*/


   BEGIN
       /*��ʼ������*/
      prm_AppCode  := GN_DEF_OK;
      prm_ErrorMsg := '';
      prm_msg :='��ʾ��Ϣ��';
      prm_sign :='0';

      --У�����
      IF prm_aab001 IS NULL  THEN

         prm_msg :=  prm_msg||'��������������ʵ������';
         prm_sign := '1';
         GOTO label_ERROR;
       END IF;

      -- ���ڶ�����λ��Ϣ
      SELECT COUNT(1)
        INTO num_count1
        FROM wsjb.irab01
       WHERE IAB001 = AAB001
         AND AAB001 = prm_aab001;

       IF num_count1 <> 1 THEN

           prm_msg :=  prm_msg||'���ڶ�����λ��Ϣ����α���λ��ϵ�籣����������Ĵ���';
           prm_sign := '1';
           GOTO label_ERROR;
        END IF;

       --  ����λ��˱�־��������2 ���޷������õ�λ
       SELECT IAA002
         INTO var_iaa002
         FROM wsjb.irab01
        WHERE IAB001 = AAB001
          AND AAB001 = prm_aab001;

        IF var_iaa002 != '2' THEN
           prm_msg :=  prm_msg||'��λ����δ���ͨ��״̬,���޷������õ�λ����������';
           prm_sign := '1';
           GOTO label_ERROR;
        END IF;

       --  �ж��Ƿ�δ��׼�±�
       SELECT YAB010
         INTO var_yab010
         FROM wsjb.irab01
        WHERE AAB001= prm_aab001
          AND iab001 = AAB001;

        IF var_yab010 != '1' THEN
           prm_msg :=  prm_msg||'�õ�λ��δ��׼�±����뵥λ��ԱЯ��������ϵ�����������ĸ���';
           prm_sign := '1';
           GOTO label_ERROR;
        END IF;

       --   �жϵ�λ�����ں��Ƿ�һ��
        SELECT COUNT(DISTINCT yae097) INTO num_count2
          FROM xasi2.ab02
         WHERE aab001=prm_aab001
           AND aab051='1';

          IF num_count2 >1 THEN

          prm_msg :=  prm_msg||'�õ�λ��������ں��в�һ�µ��������α���λ��ϵ�籣����������Ĵ���';
          prm_sign := '1';
          GOTO label_ERROR;
        END IF;

       --  ��λȨ�޿���
       SELECT COUNT(*)
         INTO num_count3
         FROM wsjb.irab01a2
        WHERE AAB001=prm_aab001;

       IF num_count3 >0 THEN
           prm_msg :=  prm_msg||'�õ�λ����һЩ������ƣ���α���λ��ϵ�籣����������Ĵ���!';
           prm_sign := '1';
           GOTO label_ERROR;
        END IF;

      /*����ʧ��*/
      <<label_ERROR>>
      num_count1 := 0;


   EXCEPTION
     WHEN OTHERS THEN
          /*�رմ򿪵��α�*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '���ݿ����'|| SQLERRM ;
          RETURN;
   END prc_P_ValidateAab001Privilege;
   /*--------------------------------------------------------------------------
   || ҵ�񻷽� ����Ա�²α�������֤
   || �������� prc_p_ValidateAac002Privilege
   || �������� ��У�����Ա�Ƿ��ܽ����²α�����Ϣ¼��
   ||
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��zhujing         ������� ��2015-11-16
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateAac002Privilege(
      prm_yae181          IN            VARCHAR2,     --֤������
      prm_aac002          IN            VARCHAR2,     --֤������
      prm_aab001          IN            VARCHAR2,     --��λ���
      prm_msg             OUT           VARCHAR2,     -- ������Ϣ
      prm_sign            OUT           VARCHAR2,     -- �����־
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2)    --������Ϣ
   IS
    sj_acount       NUMBER(6);
   num_count        NUMBER(6);
   num_count1        NUMBER(6);
   num_count_ab     NUMBER(6);
   var_aac002Low    irac01.aac002%TYPE;
   var_15aac002     irac01.aac002%TYPE;
   var_aab001       irac01.aab001%TYPE;
   var_aac031        irac01.aac031%TYPE;
   var_aab004        irab01.aab004%TYPE;
   var_aac003       irac01.aac003%TYPE;
   var_aac001        irac01.aac001%TYPE;
   sj_count          NUMBER(6);
   sj_count1        NUMBER(6);
   count_jm         NUMBER(6);
   BEGIN
    /*��ʼ������*/
      prm_AppCode  := GN_DEF_OK;
      prm_ErrorMsg := '';
      prm_msg :='';
      prm_sign :='0';
   --У�����
      IF prm_yae181 IS NULL  THEN
         prm_msg :=  prm_msg||'����֤������Ϊ�գ����ʵ������';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
      IF prm_aab001 IS NULL  THEN
         prm_msg :=  prm_msg||'���뵥λ���Ϊ�գ����ʵ������';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
      IF prm_aac002 IS NULL  THEN
         prm_msg :=  prm_msg||'����֤������Ϊ�գ����ʵ������';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
       --���֤����
     IF prm_yae181 = 1 THEN
        --��ȡ������ʽ��֤������
         var_15aac002 := SUBSTR(prm_aac002,1,6)||SUBSTR(prm_aac002,9, 9);
         var_aac002Low := LOWER(prm_aac002);

        SELECT count(1)
          INTO num_count
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
           AND AAC003 NOT LIKE '%�ظ�%';

         IF num_count > 0 THEN
            SELECT COUNT(1)
              INTO count_jm
              FROM XASI2.AC02K1
             WHERE AAC001 IN (SELECT AAC001
                                FROM XASI2.AC01
                               WHERE AAE120 = '0'
                                 AND AAC002 = PRM_AAC002
                                 AND AAC003 NOT LIKE '%�ظ�%');
              IF count_jm>0 THEN
                prm_msg := '����Ա���ھ���ҽ���α���¼��';
                prm_sign :='1';
                GOTO label_ERROR ;
              END IF;
            BEGIN
             SELECT aac001,
                    aac003
               INTO var_aac001,
                    var_aac003
               FROM xasi2.ac01
              WHERE AAE120 = '0'
              AND aac002 = prm_aac002
              AND AAC003 NOT LIKE '%�ظ�%';
             EXCEPTION
                  WHEN OTHERS THEN
                       prm_msg := '����Ա���ڶ���˻�����˶Ը���Ա�Ƿ���ڶ���ҽ���˻��������ڣ�����Ҫ�ϲ����������ڶ���ҽ���˻�����������ģ�������';
                       prm_sign :='1';
                       GOTO label_ERROR ;
            END;
            BEGIN
             SELECT aab001,
                    aac031
               INTO var_aab001,
                    var_aac031
               FROM xasi2.ac02
              WHERE aac001 = var_aac001
                AND aae140='03';
            EXCEPTION
                 WHEN OTHERS THEN
                      BEGIN
                       SELECT aab001,
                              aac031
                         INTO var_aab001,
                              var_aac031
                         FROM xasi2.ac02
                        WHERE aac001 = var_aac001
                          AND aae140='02';
                       EXCEPTION
                            WHEN OTHERS THEN
                             BEGIN
                                 SELECT aab001,
                                        aac031
                                   INTO var_aab001,
                                        var_aac031
                                   FROM xasi2.ac02
                                  WHERE aac001 = var_aac001
                                    AND aae140='05';
                              EXCEPTION
                               WHEN OTHERS THEN
                               BEGIN
                               SELECT aab001,
                                        aac031
                                   INTO var_aab001,
                                        var_aac031
                                   FROM xasi2.ac02
                                  WHERE aac001 = var_aac001
                                    AND aae140='04';
                                    EXCEPTION
                                      WHEN OTHERS THEN
                                      NULL;
                                    END;
                               END;
                       END;
            END;
             IF var_aac031='1' THEN
                 var_aac031 :='�α��ɷ�';
             ELSIF var_aac031='2' THEN
                 var_aac031 :='��ͣ�ɷ�';
             ELSIF var_aac031='3' THEN
                 var_aac031 :='��ֹ�ɷ�';
             END IF;
             SELECT aab004 INTO var_aab004 FROM xasi2.ab01 WHERE aab001 = var_aab001;
               prm_msg := '��Ա�²α��Ǽ���֤��ͨ���������֤������Աҽ�Ʊ��չ�ϵĿǰ���籣����,����'||var_aac003||',��λ���ƣ�'||var_aab004||'�α����α�״̬:'||var_aac031||'��';
               prm_sign :='1';
               GOTO label_ERROR ;
         END IF ;

         SELECT count(1)
          INTO num_count1
          FROM wsjb.irac01  A
         WHERE A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
           AND a.iaa001 <> '4'
           AND A.IAA002 <> '3'
           AND  rownum = 1;

         IF num_count = 0 AND num_count1 > 0 THEN
          SELECT a.aab001
            INTO var_aab001
            FROM wsjb.irac01  A
           WHERE A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
             AND a.iaa001 <> '4'
             AND A.IAA002 <> '3'
             AND rownum =1;
           prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա�ڵ�λ'||var_aab001||'���걨��¼,��������!';
           prm_sign :='1';
           GOTO label_ERROR ;
         END IF;


  /*       SELECT count(1)
            INTO sj_acount
            FROM sjxt.ac01
         WHERE aac002 = prm_aac002;
         IF sj_acount=1 THEN
             SELECT aac001,aac003
               INTO var_aac001,var_aac003
               FROM sjxt.ac01
             WHERE aac002 = prm_aac002;

             SELECT count(DISTINCT aab001)
               INTO sj_count FROM sjxt.ac02
             WHERE aac001 = var_aac001
               AND aac031='1'
               AND aae140 IN (SELECT aae140 FROM ab02 WHERE aab001 = prm_aab001 AND aab051 = '1');
             IF sj_count > 0 THEN
                SELECT aab001,aac031
                  INTO var_aab001,var_aac031
                  FROM sjxt.ac02
                WHERE aac001 = var_aac001
                  AND aac031='1'
                  AND ROWNUM =1;
             ELSIF sj_count = 0 THEN
                SELECT count(DISTINCT aab001)
                  INTO sj_count1
                  FROM sjxt.ac02
                  WHERE aac001 = var_aac001
                    AND aae140 IN (SELECT aae140 FROM ab02 WHERE aab001 = prm_aab001 AND aab051 = '1')
                    AND aac031='2';
                  IF sj_count1 > 0 then
                     SELECT aab001,aac031
                       INTO var_aab001,var_aac031
                       FROM sjxt.ac02
                       WHERE aac001 = var_aac001
                       and aac031='2'
                       AND ROWNUM =1;
                  ELSIF sj_count1 = 0 then
                        --prm_msg := '��Ա�²α��Ǽ���֤��ͨ���������֤������Աҽ�Ʊ��չ�ϵĿǰ���������籣����,����'||var_aac003;
                       --prm_sign :='1';
                   GOTO label_ERROR ;
                  END IF;
              end if;
              IF var_aac031='1' THEN
                 var_aac031 :='�α��ɷ�';
             ELSIF var_aac031='2' THEN
                 var_aac031 :='��ͣ�ɷ�';
             ELSIF var_aac031='3' THEN
                 var_aac031 :='��ֹ�ɷ�';
             END IF;
             BEGIN
              SELECT aab004
                INTO var_aab004
                FROM sjxt.ab01
               WHERE aab001 = var_aab001;
             EXCEPTION
                  WHEN OTHERS THEN
                       var_aab004 :='';
             END;
           prm_msg := '��Ա�²α��Ǽ���֤��ͨ���������֤������Աҽ�Ʊ��չ�ϵĿǰ���������籣����,����'||var_aac003||',��λ���ƣ�'||var_aab004||'�α����α�״̬:'||var_aac031||'��';
           prm_sign :='1';
           GOTO label_ERROR ;
       END IF;*/




     END IF;
     --��������
     IF prm_yae181 <> '1' THEN
       SELECT count(1)
          INTO num_count
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.AAC002 = prm_aac002
           AND AAC003 NOT LIKE '%�ظ�%';

         IF num_count > 0 THEN
           prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա�Ѵ��ڸ�����Ϣ����������ģ�������';
           prm_sign :='1';
           GOTO label_ERROR;
         END IF;

         SELECT count(1)
          INTO num_count1
          FROM wsjb.irac01  A
         WHERE A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
           AND a.iaa001 <> '4'
           AND A.IAA002 <> '3'
           AND  rownum = 1;

         IF num_count = 0 AND num_count1 > 0 THEN
          SELECT a.aab001
            INTO var_aab001
            FROM wsjb.irac01  A
           WHERE A.AAC002 = prm_aac002
             AND A.iaa001 <> '4'
             AND A.IAA002 <> '3'
             AND rownum =1;
           prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա�ڵ�λ'||var_aab001||'���걨��¼,��������!';
           prm_sign :='1';
           GOTO label_ERROR ;
         END IF;

     END IF;

     <<label_ERROR>>
      num_count := 0;


   EXCEPTION
     WHEN OTHERS THEN
          /*�رմ򿪵��α�*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '���ݿ����'|| SQLERRM ;
          RETURN;
   END prc_p_ValidateAac002Privilege;

   /*--------------------------------------------------------------------------
   || ҵ�񻷽� ����Ա�����²α�����������֤
   || �������� prc_p_ValidateAac002Privilege
   || �������� ��У�����Ա�Ƿ��ܽ����²α�����Ϣ¼��
   ||
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��zhujing         ������� ��2015-11-16
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_checkNewInsur(
       prm_iaz018          IN            VARCHAR2,     --���κ�
      prm_yab139          IN            VARCHAR2,     --�������
      prm_msg             OUT           VARCHAR2,     -- ������Ϣ
      prm_sign            OUT           VARCHAR2,     -- �����־
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2)    --������Ϣ

   IS
   num_count        NUMBER(6);
   rec_tmp_irac01a2 tmp_irac01a2%ROWTYPE;
   dat_aac006       DATE ;--��������
   dat_aac007       DATE ;--�ι�����
   dat_aac030       DATE ;--��ϵͳ�α�����
   dat_yac033       DATE ;--���˳��βα�����
   var_aab001       irab01.aab001%TYPE;
   var_aae140       irab02.aae140%TYPE;
   num_aac040       NUMBER(14,2); --�ɷѹ���
   num_yac004       NUMBER(14,2); --���ϻ���
   num_yac005       NUMBER(14,2); --��������
   var_iaa100       varchar2(6);  --�걨�¶�
   var_iaa100_a      DATE;
   var_aac004       irac01.aac004%TYPE;  --�Ա�
   var_aac008       irac01.aac008%TYPE;  --��Ա״̬
   dat_yearAge      DATE;  --��������
   var_aac012       irac01.aac012%TYPE;  --��Ա���
   BEGIN
   /*��ʼ������*/
     prm_AppCode  := GN_DEF_OK;
     prm_ErrorMsg := '';
     prm_msg :='';
     prm_sign :='0';



     SELECT *
     INTO rec_tmp_irac01a2
     FROM wsjb.tmp_irac01a2
    WHERE iaz018 = prm_iaz018;
     --У�����
    IF prm_iaz018 IS NULL  THEN
      prm_msg :=  prm_msg||'����У����ˮ��Ϊ�գ����ʵ������';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    var_aab001 := rec_tmp_irac01a2.aab001;
   --�ж��Ƿ��ǵ����ϵ�λ
    SELECT COUNT(1)
      INTO num_count
      FROM xasi2.ab02
     WHERE AAB001 = var_aab001
       AND AAB051 = '1';

    IF num_count = 0 THEN
    --������������Ϊ0
      UPDATE wsjb.tmp_irac01a2
         SET yac005 = 0
       WHERE iaz018 = prm_iaz018;
    END IF;

    dat_aac006 := rec_tmp_irac01a2.aac006;--��������
    dat_aac007 := rec_tmp_irac01a2.aac007;--�ι�����
    dat_aac030 := rec_tmp_irac01a2.aac030;--��ϵͳ�α�����
    dat_yac033 := rec_tmp_irac01a2.yac033;--���˳��βα�����
    var_iaa100 := rec_tmp_irac01a2.iaa100;--�걨�¶�
    SELECT to_date(rec_tmp_irac01a2.iaa100||'01','yyyy-MM-dd hh:mi:ss') INTO var_iaa100_a FROM dual;
    var_aac004 := rec_tmp_irac01a2.aac004;--�Ա�
    var_aac008 := rec_tmp_irac01a2.aac008;--��Ա״̬
    var_aac012 := rec_tmp_irac01a2.aac012;--��Ա���
    IF dat_aac007 > dat_aac030 THEN
      prm_msg :=  prm_msg||'�״βμӹ������ڲ������ڵ�����λ�α�����!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_aac007 > var_iaa100_a THEN
      prm_msg :=  prm_msg||'�ι����ڲ��������걨�¶�'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_yac033 > var_iaa100_a THEN
      prm_msg :=  prm_msg||'���˳��βα����ڲ������������걨�¶�'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
--    IF dat_aac030 > SYSDATE THEN
--      prm_msg :=  prm_msg||'������λ�α����ڲ�������ϵͳ����'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||'!';
--      prm_sign := '1';
--      GOTO label_ERROR;
--    END IF;
    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) > TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'������λ�α����ڲ������ڵ�ǰ���걨�¶�'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_aac006 > dat_aac007 THEN
      prm_msg :=  prm_msg||'�״βμӹ������ڲ������ڳ�������!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_aac006 > dat_aac030 THEN
      prm_msg :=  prm_msg||'����λ�α����ڲ������ڳ�������!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_aac006 > dat_yac033 THEN
      prm_msg :=  prm_msg||'���˳��βα����ڲ������ڳ�������!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    /**
     --У�����֤����
     prc_p_ValidateAac002Privilege(
                                   rec_tmp_irac01a2.yae181   ,     --֤������
                                   rec_tmp_irac01a2.aac002   ,     --֤������
                                   rec_tmp_irac01a2.aab001   ,     --��λ���
                                   prm_msg      ,     -- ������Ϣ
                                   prm_sign     ,     -- �����־
                                   prm_AppCode  ,     --ִ�д���
                                   prm_ErrorMsg );    --������Ϣ
     IF prm_sign = '1' THEN
      GOTO label_ERROR;
     END IF ;
     **/
     --������Ա�α���Ҫ��ʾ
     IF var_aac008 = '1' THEN

         IF var_aac004 = '1' THEN --�� 60��
           dat_yearAge := ADD_MONTHS(dat_aac006,60*12);
         ELSIF var_aac004 = '2' AND var_aac012 = '4' THEN --Ů�ɲ� 55��
           dat_yearAge := ADD_MONTHS(dat_aac006,55*12);
         ELSIF var_aac004 = '2' AND var_aac012 = '1' THEN --Ů���� 50��
           dat_yearAge := ADD_MONTHS(dat_aac006,50*12);
         ELSE
           prm_msg := '�Ա��ȡʧ��';
           prm_sign := '1';
           GOTO label_ERROR;
         END IF;
         IF dat_yearAge < SYSDATE THEN
           prm_msg :=  prm_msg||'���ã���Ա���ѳ����������䣬���ʵ����������Ϊ���˽�����ᱣ�ա�ȷ��������������ṩ���˵���������籣����������˴��ڱ���!';
            prm_sign := '1';
           GOTO label_ERROR;
         END IF;

     END IF;

     --�������֤�������������пո�
     IF rec_tmp_irac01a2.yae181 = '1' THEN
       UPDATE wsjb.tmp_irac01a2
         SET aac003 = REPLACE(aac003,' ','')
       WHERE iaz018 = prm_iaz018;
     END IF;

     --����У��
     IF rec_tmp_irac01a2.aae110 = '0' AND
        rec_tmp_irac01a2.aae120 = '0' AND
        rec_tmp_irac01a2.aae210 = '0' AND
        rec_tmp_irac01a2.aae310 = '0' AND
        rec_tmp_irac01a2.aae410 = '0' AND
        rec_tmp_irac01a2.aae510 = '0' AND
        rec_tmp_irac01a2.aae311 = '0' AND
        rec_tmp_irac01a2.aae810 = '0' THEN

        prm_msg :=  prm_msg||'δ��ȡ����ѡ�α���������Ϣ!';
        prm_sign := '1';
        GOTO label_ERROR;

     END IF;
     --����Ա��������У��
     IF rec_tmp_irac01a2.aae810 = '1' THEN

        IF rec_tmp_irac01a2.yac200 IS NULL THEN
          prm_msg :=  prm_msg||'����Աְ������Ϊ��!';
           prm_sign := '1';
           GOTO label_ERROR;
        END IF;

     END IF;



     --����У��
     num_aac040 := rec_tmp_irac01a2.aac040;--�ɷѹ���
     IF rec_tmp_irac01a2.aae110 = '1' THEN
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,var_aab001,num_aac040,'0','01','1','1',var_iaa100,prm_yab139))
          INTO num_yac004
          FROM  dual ;
        IF ROUND(num_yac004) <> rec_tmp_irac01a2.yac004 THEN
          --��ҵ���ϻ�������
          UPDATE wsjb.tmp_irac01a2
             SET yac004 = ROUND(num_yac004)
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;

     IF rec_tmp_irac01a2.aae120 = '1' THEN

        IF num_aac040 <> rec_tmp_irac01a2.yac004 THEN
          --�������ϻ�������
          UPDATE wsjb.tmp_irac01a2
             SET yac004 = num_aac040
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;

     IF rec_tmp_irac01a2.aae210 = '1' OR
        rec_tmp_irac01a2.aae310 = '1' OR
        rec_tmp_irac01a2.aae410 = '1' OR
        rec_tmp_irac01a2.aae510 = '1' OR
        rec_tmp_irac01a2.aae810 = '1' THEN
        --��һ������Ϊ׼
        SELECT aae140
          INTO var_aae140
          FROM xasi2.AB02
         WHERE aab051 = '1'
           AND (aae140 = '02' OR aae140 = '03' OR aae140 = '04' OR aae140 = '05' )
           AND aab001 = var_aab001
           AND ROWNUM = 1;
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,var_aab001,num_aac040,'0',var_aae140,'1','1',var_iaa100,prm_yab139))
          INTO num_yac005
          FROM  dual ;
        IF ROUND(num_yac005) <> rec_tmp_irac01a2.yac005 THEN
          --������������
          UPDATE wsjb.tmp_irac01a2
             SET yac005 = ROUND(num_yac005),
                 yaa333 = ROUND(num_yac005)
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;



     /*����ʧ��*/
      <<label_ERROR>>

        num_count :=0;

   EXCEPTION
     WHEN OTHERS THEN
          /*�رմ򿪵��α�*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '���ݿ����'|| SQLERRM ;
          RETURN;
   END prc_p_checkNewInsur;

     /*--------------------------------------------------------------------------
   || ҵ�񻷽� ����Ա����������֤
   || �������� prc_p_ValidateAac002Continue
   || �������� ��У�����Ա�Ƿ��ܽ�����������Ϣ¼��
   ||
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��zhujing         ������� ��2015-11-23
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateAac002Continue(
       prm_yae181          IN            VARCHAR2,     --֤������
      prm_aac002          IN            VARCHAR2,     --֤������
      prm_aab001          IN            VARCHAR2,     --��λ���
      prm_iaa100          IN            VARCHAR2,     --�¶�
      prm_aac001          IN           VARCHAR2,     --���˱��
      prm_msg             OUT           VARCHAR2,     -- ������Ϣ
      prm_sign            OUT           VARCHAR2,     -- �����־
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2)    --������Ϣ

   IS
     sj_count       NUMBER;--��ѯac01�о�
    sj_acount       NUMBER;
    aac001_sj        irac01.aac001%TYPE;
   num_count        NUMBER(6);
   num_count1       NUMBER(6);
   var_aac002Low    irac01.aac002%TYPE;
   var_15aac002     irac01.aac002%TYPE;
   var_aab001       irab01.aab001%TYPE;
   var_aac001       irac01.aac001%TYPE;
   num_ab02count    NUMBER;
   var_akc021       irac01.akc021%TYPE;
   var_aac008       irac01.aac008%TYPE;
   var_yab013       irac01.yab013%TYPE;--ԭ��λ���
   BEGIN
    /*��ʼ������*/
      prm_AppCode  := GN_DEF_OK;
      prm_ErrorMsg := '';
      prm_msg :='';
      prm_sign :='0';
   --У�����
      IF prm_yae181 IS NULL  THEN
         prm_msg :=  prm_msg||'����֤������Ϊ�գ����ʵ������';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
      IF prm_aab001 IS NULL  THEN
         prm_msg :=  prm_msg||'���뵥λ���Ϊ�գ����ʵ������';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
      IF prm_aac002 IS NULL  THEN
         prm_msg :=  prm_msg||'����֤������Ϊ�գ����ʵ������';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;

       --���֤����
     IF prm_yae181 = 1 THEN
      SELECT count(1)
       INTO  num_ab02count
       FROM xasi2.ab02 a
       WHERE aab051='1'
       AND  aab001= prm_aab001;
        --��ȡ������ʽ��֤������
         var_15aac002 := SUBSTR(prm_aac002,1,6)||SUBSTR(prm_aac002,9, 9);
         var_aac002Low := LOWER(prm_aac002);
        IF prm_aac001 IS NULL  THEN
               SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '0'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '���˴��ڴ��걨��������Ϣ,���Ȱ����걨ҵ��!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 IN ('3','7')
         AND A.IAA002 = '0'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '���˴��ڴ��걨����ͣ��Ϣ,���Ȱ����걨ҵ��!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '1'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '���˴������걨��������Ϣ,��ȴ����ͨ��!!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '4'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '���˴��ڱ���ص�������Ϣ,�뵽[���걨]�������޸������Ϣ�����걨!!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '5'
         AND A.IAA002 = '0'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '���˴��ڴ��걨������������Ϣ,���Ȱ����걨ҵ��!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '5'
         AND A.IAA002 = '1'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '���˴������걨������������Ϣ,��ȴ����ͨ��!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;
         GOTO label_ERROR;
        END IF;

        SELECT count(1)
          INTO num_count
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
           AND AAC003 NOT LIKE '%�ظ�%';

             /*IF num_count = 0 THEN
             select count(*)
               into sj_count
               from sjxt.ac01
               where aac002 = prm_aac002 ;

              IF sj_count=0 THEN
                 prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա�����ڸ�����Ϣ�������²α�ģ���������';
                 prm_sign :='1';
                 GOTO label_ERROR ;
               END IF;
               IF sj_count>1 THEN
                 prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա���оִ��ڶ�����Ϣ����ע�⣡';
                 prm_sign :='1';
                 GOTO label_ERROR ;
               END IF;
            \***               --��ѯ������
                         select xasi2.seq_aac001.nextval into var_aac001 from dual;
                         --�оֶ�Ӧ��aac001
                             select aac001
                         INTO aac001_sj
                         from sjxt.ac01
                       where aac002 = prm_aac002 ;
                       --�����Ӧ��
                          insert into xasi2.ac01d1(
                          aac001,
                          aac002,
                          aac001_s,
                          aae036
                          )
                          values(
                          var_aac001,
                          prm_aac002,
                          aac001_sj,
                          sysdate
                          );
                          --ʹ���оֵ�aac008; ��ȡ��ʽ����
                    --       select    aac008     INTO    var_aac008
                    --  from sjxt.ac01
                     --  where aac002 = prm_aac002 ;
                   ***\
            END IF ;*/
        IF num_count > 1 THEN
            SELECT count(1) INTO num_count1
              FROM xasi2.ac01 a,xasi2.ac02 b
              WHERE a.aac001=b.aac001
              AND   a.aac003 NOT LIKE '%�ظ�%'
              AND    b.aac031='2'
              AND   b.aae140='03'
              AND   a.aac002 = prm_aac002;

        END IF ;
          /*IF num_count1 >1 THEN
             prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա���ڶ���������Ϣ��������ϵ�籣���ģ�';
             prm_sign :='1';
             GOTO label_ERROR ;
           END IF;
          if num_count1=1 THEN
             SELECT a.aac001 INTO var_aac001
              FROM xasi2.ac01 a,xasi2.ac02 b
              WHERE a.aac001=b.aac001
              AND   a.aac003 NOT LIKE '%�ظ�%'
              AND    b.aac031='2'
              AND   b.aae140='03'
              AND   a.aac002 = prm_aac002;
          END IF;
*/

             IF num_count = 1 THEN
                    SELECT aac001,
                           aac008
                      INTO var_aac001,
                           var_aac008
                      FROM xasi2.ac01 A
                     WHERE AAE120 = '0'
                       AND A.aac001=prm_aac001
                       AND AAC003 NOT LIKE '%�ظ�%';

                ELSIF  num_count > 1  THEN

                    SELECT aac001,
                           aac008
                      INTO var_aac001,
                           var_aac008
                      FROM xasi2.ac01 A
                     WHERE AAE120 = '0'
                       AND A.aac001=prm_aac001
                       AND AAC003 NOT LIKE '%�ظ�%';
               END IF;
   ELSE
        SELECT count(1)
          INTO num_count
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.AAC002 = prm_aac002
           AND AAC003 NOT LIKE '%�ظ�%';

       /* IF num_count = 0 THEN
          select count(*)
           into sj_count
           from sjxt.ac01
           where aac002 = prm_aac002 ;

          IF sj_count=0 THEN
           prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա�����ڸ�����Ϣ�������²α�ģ���������';
           prm_sign :='1';
           GOTO label_ERROR ;
           END IF;
           IF sj_count>1 THEN
           prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա���оִ��ڶ�����Ϣ����ע�⣡';
           prm_sign :='1';
           GOTO label_ERROR ;
           END IF;

        END IF ;*/
        /*IF num_count > 1 THEN
           prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա���ڶ���������Ϣ��������ϵ�籣���ģ�';
           prm_sign :='1';
           GOTO label_ERROR ;
        END IF ;

       IF num_count = 1 THEN*/
        SELECT aac001,
               aac008
          INTO var_aac001,
               var_aac008
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.aac001=prm_aac001
           AND AAC003 NOT LIKE '%�ظ�%';
          /*ELSE IF num_count >1 THEN
           prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա���ڶ���������Ϣ��������ϵ�籣���ģ�';
           prm_sign :='1';
           GOTO label_ERROR ;*/
          /**  --��ѯ������
             select xasi2.seq_aac001.nextval into var_aac001 from dual;
             --�оֶ�Ӧ��aac001
                 select aac001
             INTO aac001_sj
             from sjxt.ac01
           where aac002 = prm_aac002 ;
           --�����Ӧ��
              insert into xasi2.ac01d1(
              aac001,
              aac002,
              aac001_s,
              aae036
              )
              values(
              var_aac001,
              prm_aac002,
              aac001_sj,
              sysdate
              );
              --ʹ���оֵ�aac008; ��ȡ��ʽ����
          --     select    aac008    INTO     var_aac008
         -- from sjxt.ac01
          -- where aac002 = prm_aac002 ;
          **/
        -- END IF ;
     END IF;
   --END IF;
      /*  SELECT count(1)
          INTO num_count
          FROM xasi2.KC01 A
         WHERE A.AAC001 = var_aac001;
      IF num_count > 0 THEN
        SELECT A.AKC021
          INTO var_akc021
          FROM xasi2.KC01 A
         WHERE A.AAC001 = var_aac001;
       IF var_aac008 = '2' AND var_akc021 = '11' THEN
           prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա���ڰ������ҵ��,���ܰ���������������Ҫ������ϵ�籣���ģ�';
          prm_sign :='1';
          GOTO label_ERROR ;
       END IF;
      END IF;*/


      -- prm_aac001 := var_aac001;
        --����ȫ�εĲ�����������

       SELECT count(1)
         INTO num_count
         FROM xasi2.ac02
        WHERE AAC001 = var_aac001
          AND AAB001 = prm_aab001
          AND aac031 = '1'
          AND aae140 <> '06';
       IF num_count = 5 THEN
           prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա�ڱ���λֻ�������ϱ���δ�α����뵽�������ֹ����������������֣�';
          prm_sign :='1';
          GOTO label_ERROR ;
       END IF;
/*
         --��ѯ�о������������α���Ϣ
           SELECT count(*)
         into sj_acount
          from sjxt.ac02 where aac031='1' and
          aac001 in(select aac001 from sjxt.ac01
              where aac002 = prm_aac002 );
         IF sj_acount > 0 THEN
             prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա���оֵ�λ�����ڲα������֣�';
            prm_sign :='1';
            GOTO label_ERROR ;
             END IF;
*/     --�ڱ���λ�Ƿ������α�
      SELECT COUNT(1) AS COUNT1
          INTO num_count
          FROM xasi2.ac01 A, xasi2.ac02 B
         WHERE A.AAC001 = B.AAC001
           AND A.AAE120 = '0'
           AND B.AAC031 = '1'
           AND A.AAC001 = var_aac001
           AND B.AAB001 = prm_aab001;
           IF num_count >0 THEN
            prm_msg := '�����ڱ���λ�������α������֣��뵽�������ֹ����²���';
          prm_sign :='1';
          GOTO label_ERROR ;
           END IF;
       --�ڱ�ĵ�λ�Ƿ��вα��ɷѼ�¼
       SELECT SUM(COUNT1)
         INTO num_count
         FROM (SELECT COUNT(*) AS COUNT1
                  FROM xasi2.ac01 A, xasi2.ac02 B
                 WHERE A.AAC001 = B.AAC001
                   AND A.AAE120 = '0'
                   AND B.AAC031 = '1'
                   AND B.AAE140 <> '04'
                   AND A.AAC001 = var_aac001
                   AND B.AAB001 <> prm_aab001
                UNION
                SELECT COUNT(1) AS COUNT1
                  FROM wsjb.irac01a3
                 WHERE AAB001 <> prm_aab001
                   AND AAC001 = var_aac001
                   AND AAE110 = '2');
      IF num_count = 0 THEN
        SELECT count(1)
          INTO num_count
          FROM wsjb.irac01
         WHERE AAC001 = var_aac001
           AND IAA001 = '4'
           AND IAA002 = '1';
        IF num_count > 0 THEN
          prm_msg := '���˴��ڴ���˵ġ���Ա��Ҫ��Ϣ���������,����ʾ���˾���Я��������ϵ��籣���Ľ�����˰�������ɹ��󣬷��ɽ�������������';
          prm_sign :='1';
          GOTO label_ERROR ;
        END IF;
      ELSE
        SELECT COUNT(1) AS COUNT1
          INTO num_count
          FROM xasi2.ac01 A, xasi2.ac02 B
         WHERE A.AAC001 = B.AAC001
           AND A.AAE120 = '0'
           AND B.AAC031 = '1'
           AND B.AAE140 = '04'
           AND A.AAC001 = var_aac001
           AND B.AAB001 = prm_aab001;
         IF num_count > 0 THEN
             prm_msg := '������������λ������δ����ͣ�����ڱ���λҲ�Ѳι������֣�';
            prm_sign :='1';
            GOTO label_ERROR ;
         END IF;

        SELECT COUNT(*) AS COUNT1
          INTO num_count
          FROM xasi2.ac01 A, xasi2.ac02 B, xasi2.ab01 C
         WHERE A.AAC001 = B.AAC001
           AND B.AAB001 = C.AAB001
           AND A.AAE120 = '0'
           AND B.AAC031 = '1'
           AND B.AAE140 IN ('03', '07')
           AND A.AAC001 = var_aac001
           AND C.YAB136 = '001';
        IF num_count > 0 THEN
           prm_msg := '���������´������������δ����ͣ,����ͣ����������';
           prm_sign :='1';
           GOTO label_ERROR ;
        END IF;

      prm_msg := '������������λ������δ����ͣ,����λֻ�ܲα������գ�';
      prm_sign :='2';
      GOTO label_ERROR ;
      END IF;

      SELECT SUM(I)
        INTO num_count
        FROM (SELECT COUNT(1) AS I
                FROM xasi2.ac08 A, wsjb.irab01a5  B
               WHERE A.AAB001 = B.AAB001
                 AND AAC001 = var_aac001
                 AND AAE140 = '03'
                 AND AAE002 = prm_iaa100
              UNION
              SELECT COUNT(1) AS I
                FROM xasi2.ac08a1 A, wsjb.irab01a5  B
               WHERE A.AAB001 = B.AAB001
                 AND AAC001 = var_aac001
                 AND AAE140 = '03'
                 AND AAE002 = prm_iaa100);
      IF num_count > 0 THEN
         prm_msg := '����'||prm_iaa100||'����ҽ�ƽɷѼ�¼��Ϣ,������������ϸ����ѯ�籣����!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;
      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '0'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '���˴��ڴ��걨��������Ϣ,���Ȱ����걨ҵ��!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 IN ('3','7')
         AND A.IAA002 = '0'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '���˴��ڴ��걨����ͣ��Ϣ,���Ȱ����걨ҵ��!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '1'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '���˴������걨��������Ϣ,��ȴ����ͨ��!!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '4'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '���˴��ڱ���ص�������Ϣ,�뵽[���걨]�������޸������Ϣ�����걨!!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '5'
         AND A.IAA002 = '0'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '���˴��ڴ��걨������������Ϣ,���Ȱ����걨ҵ��!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '5'
         AND A.IAA002 = '1'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '���˴������걨������������Ϣ,��ȴ����ͨ��!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 IN ('3', '7', '9', '10')
         AND A.IAA002 = '2'
         AND A.AAC001 = var_aac001
         AND A.IAA100 = prm_iaa100;
      IF num_count > 0 THEN
        SELECT aab001
          INTO var_yab013
          FROM wsjb.irac01  A
         WHERE A.IAA001 IN ('3', '7', '9', '10')
           AND A.IAA002 = '2'
           AND A.AAC001 = var_aac001
           AND A.IAA100 = prm_iaa100
           AND ROWNUM = 1;
/***-----------------------------------
        SELECT SUM(I) as i
          INTO num_count
          FROM (SELECT COUNT(1) I
                  FROM AB08
                 WHERE AAB001 = var_yab013
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01'
                UNION ALL
                SELECT COUNT(1) I
                  FROM AB08A8
                 WHERE AAB001 = var_yab013
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01'
                UNION ALL
                SELECT COUNT(1) I
                  FROM IRAB08
                 WHERE AAB001 = var_yab013
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01');
       IF num_count > 0 THEN
          prm_msg := '���˴��ڴ���˵���Ա������Ϣ���ߵ�ǰ�·ݴ��ڽɷѼ�¼�����ܰ�������,��ȴ����ͨ��!';
         prm_sign :='1';
         GOTO label_ERROR ;
       END IF;
       ---------------------***/
      END IF;
      SELECT SUM(I) as i
          INTO num_count
          FROM (SELECT COUNT(1) I
                  FROM xasi2.ab08
                 WHERE AAC001 = var_aac001
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01'
                UNION ALL
                SELECT COUNT(1) I
                  FROM xasi2.ab08a8
                 WHERE AAC001 = var_aac001
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01'
                UNION ALL
                SELECT COUNT(1) I
                  FROM wsjb.irab08
                 WHERE AAC001 = var_aac001
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01');
       IF num_count > 0 THEN
          prm_msg := '���˵�ǰ�·ݴ��ڽɷѼ�¼�����ܰ�������!';
         prm_sign :='1';
         GOTO label_ERROR ;
       END IF;


      /*����ʧ��*/
      <<label_ERROR>>

       num_count :=0;
  EXCEPTION
     WHEN OTHERS THEN
          /*�رմ򿪵��α�*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '���ݿ����'|| SQLERRM ;
          RETURN;
   END prc_p_ValidateAac002Continue;


  /*--------------------------------------------------------------------------
   || ҵ�񻷽� ����Ա����������֤
   || �������� prc_p_ValidateContinueCheck
   || �������� ��У�����Ա¼���������Ϣ
   ||
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��zhujing         ������� ��2015-11-24
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateContinueCheck(
       prm_iaz018          IN            VARCHAR2,     --���κ�
      prm_yab139          IN            VARCHAR2,     --�������
      prm_msg             OUT           VARCHAR2,     -- ������Ϣ
      prm_sign            OUT           VARCHAR2,     -- �����־
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2)    --������Ϣ
  IS
   num_count        NUMBER(6);
   rec_tmp_irac01a2 tmp_irac01a2%ROWTYPE;
   dat_aac006       DATE ;--��������
   dat_aac007       DATE ;--�ι�����
   dat_aac030       DATE ;--��ϵͳ�α�����
   dat_yac033       DATE ;--���˳��βα�����
   var_aab001       irab01.aab001%TYPE;
   var_aae140       irab02.aae140%TYPE;
   num_aac040       NUMBER(14,2); --�ɷѹ���
   num_yac004       NUMBER(14,2); --���ϻ���
   num_yac005       NUMBER(14,2); --��������
   var_iaa100       VARCHAR2(6);  --�걨�¶�
   dat_iaa100        DATE;
   var_aac001       irac01.aac001%TYPE;
   var_aac002       irac01.aac002%TYPE;
   var_aac009       irac01.aac009%TYPE;  --��������
   var_aac008       irac01.aac008%TYPE;
   var_aae110       irac01.aae110%TYPE;
   var_aae120       irac01.aae120%TYPE;
   var_aae210       irac01.aae210%TYPE;
   var_aae310       irac01.aae310%TYPE;
   var_aae410       irac01.aae410%TYPE;
   var_aae510       irac01.aae510%TYPE;
   var_aae311       irac01.aae311%TYPE;
   var_aae810       irac01.aae810%TYPE;
   var_yac001       irac01a3.yac001%TYPE;
   count_repeat_zg  NUMBER(3);
   var_aab004       VARCHAR2(100);
   ac02_count_04    NUMBER(3);
   ac01_count       NUMBER(3);
   var_aae011       irac01a3.aae011%TYPE;
   var_aae036       irac01a3.aae036%TYPE;
   var_yae181       irac01a3.yae181%TYPE;
   var_aac003       irac01a3.aac003%TYPE;
   var_aac004       irac01a3.aac004%TYPE;
   var_aac005       irac01a3.aac005%TYPE;
   var_aac006       irac01.aac006%TYPE;
   var_aae013       irac01a3.aae013%TYPE;
   var_yae222       irac01a3.yae222%TYPE;
   var_aae007       irac01a3.aae007%TYPE;
   var_aae004       irac01a3.aae004%TYPE;
   var_aae005       irac01a3.aae005%TYPE;
   var_aae006       irac01a3.aae006%TYPE;
   var_aac007       irac01a3.aac007%TYPE;
   var_yac168       irac01a3.yac168%TYPE;
   var_yac067       irac01a3.yac067%TYPE;
   var_aac010       irac01a3.aae010%TYPE;
   var_aac020       irac01a3.aac020%TYPE;
   var_aac012       irac01a3.aac012%TYPE;
   var_aac013       irac01a3.aac013%TYPE;
   var_aac014       irac01a3.aac014%TYPE;
   var_aac015       irac01a3.aac015%TYPE;
   var_iaa100_new   irac01.iaa100%TYPE;
   irac01_aac001    irac01.aac001%TYPE;
   irac01a3_aac001   irac01a3.aac001%TYPE;
   var_iaz018       VARCHAR2(30);
   ac01_irac01a3_count NUMBER;
   count_aab001_irac01a3 NUMBER;
   yl_count    NUMBER;   
   zy_akc021     VARCHAR2(30);
   X            VARCHAR2(30);
   woman_months  NUMBER(6);
   woman_worker_months  NUMBER(6);
   sj_months         NUMBER(6);
   var_aac006_ac01   NUMBER(8);
   
   num_count_tmp_irac01a2  number;

   irac01a3_count  number(5);
        --�����˲α���Ϣ
      CURSOR cur_aae140 IS
         SELECT aae140
           FROM xasi2.tmp_aae140
          WHERE yae099 = var_aac001
            AND aab001 = var_aab001;


      --����Ƿ��������ҽ�����
      CURSOR cur_aac001 IS
         SELECT aac001,aac002,aac003
           FROM xasi2.ac01
          WHERE aac001 <> var_aac001
            AND aac002 = var_aac002;

   BEGIN



   /*��ʼ������*/
     prm_AppCode  := GN_DEF_OK;
     prm_ErrorMsg := '';
     prm_msg :='';
     prm_sign :='0';
     woman_months := 660;
    woman_worker_months :=600;


     SELECT *
     INTO rec_tmp_irac01a2
     FROM wsjb.tmp_irac01a2
    WHERE iaz018 = prm_iaz018;
     --У�����
    IF prm_iaz018 IS NULL  THEN
      prm_msg :=  prm_msg||'����У����ˮ��Ϊ�գ����ʵ������';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    var_aab001 := rec_tmp_irac01a2.aab001;
    var_aac001 := rec_tmp_irac01a2.aac001;
    var_aac002 := rec_tmp_irac01a2.aac002;
    var_aac008 := rec_tmp_irac01a2.aac008;
    var_aae110 := rec_tmp_irac01a2.aae110;
    var_aae120 := rec_tmp_irac01a2.aae120;
    var_aae210 := rec_tmp_irac01a2.aae210;
    var_aae310 := rec_tmp_irac01a2.aae310;
    var_aae410 := rec_tmp_irac01a2.aae410;
    var_aae510 := rec_tmp_irac01a2.aae510;
    var_aae311 := rec_tmp_irac01a2.aae311;
    var_aae810 := rec_tmp_irac01a2.aae810;
    --irac01a3 ����
    var_iaz018 := rec_tmp_irac01a2.iaz018;
    var_aae011 := rec_tmp_irac01a2.aae011;
    var_aae036 := rec_tmp_irac01a2.aae036;
    var_yae181 := rec_tmp_irac01a2.yae181;
    var_aac003 := rec_tmp_irac01a2.aac003;
    var_aac004 := rec_tmp_irac01a2.aac004;
    var_aac005 := rec_tmp_irac01a2.aac005;
    var_aac006 := rec_tmp_irac01a2.aac006;
    var_aae013 := rec_tmp_irac01a2.aae013;
    var_yae222 := rec_tmp_irac01a2.yae222;
    var_aae007 := rec_tmp_irac01a2.aae007;
    var_aae004 := rec_tmp_irac01a2.aae004;
    var_aae005 := rec_tmp_irac01a2.aae005;
    var_aae006 := rec_tmp_irac01a2.aae006;
    var_aac007 := rec_tmp_irac01a2.aac007;
    var_yac168 := rec_tmp_irac01a2.yac168;
    var_aac009 := rec_tmp_irac01a2.aac009;
    var_aac010 := rec_tmp_irac01a2.aac010;
    var_yac168 := rec_tmp_irac01a2.yac168;
    var_yac067 := rec_tmp_irac01a2.yac067;
    var_aac020 := rec_tmp_irac01a2.aac020;
    var_aac012 := rec_tmp_irac01a2.aac012;
    var_aac013 := rec_tmp_irac01a2.aac013;
    var_aac014 := rec_tmp_irac01a2.aac014;
    var_aac015 := rec_tmp_irac01a2.aac015;
    var_iaa100_new := rec_tmp_irac01a2.iaa100;
    
    
    --  AAC012  ������� ����  50  �ɲ� 55 
     var_aac012 := rec_tmp_irac01a2.aac012;
    
      IF var_aac012 IS NULL  THEN
      prm_msg :=  prm_msg||'����������Ϊ�գ����ʵ������';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;


   --  ����irac01 �� irac01a3   aac001 ��һ������
   -- begin wangz 20190605
   -- ��ac01 ����У��
   select count(1) INTO ac01_irac01a3_count from xasi2.ac01 where aac002  = var_aac002 and aac003 = var_aac003; 
  IF ac01_irac01a3_count > 0 THEN 
    -- IF 1=1 THEN 
      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.IRAC01A3
       WHERE AAC001 = var_aac001
         AND AAB001 = var_aab001;
      IF num_count = 0 THEN
         var_yac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'YAC001');
         IF var_yac001 is null THEN
            prm_AppCode := gn_def_ERR ;
            prm_msg  := 'û�л�ȡ����λ��Ա���к�yac001!';
            RETURN;
         END IF;
        INSERT INTO wsjb.tmp_irac01a3 (
       --  INSERT INTO wsjb.irac01a3 (
                     yac001,
                     aac001,          -- ���˱��
                     aab001,
                     yae181,          -- ֤������
                     aac002,          -- ���֤����(֤������)
                     aac003,          -- ����
                     aac004,          -- �Ա�
                     aac005,
                     aac006,          -- ��������
                     aac007,          -- �μӹ�������
                     aac008,          -- ��Ա״̬
                     aac009,
                     aac010,
                     aac012,
                     aac013,
                     aac014,
                     aac015,
                     aac020,
                     yac067,          -- ��Դ��ʽ
                     yac168,          -- ũ�񹤱�־
                     aae004,
                     aae005,          -- ��ϵ�绰
                     aae006,          -- ��ַ
                     aae007,
                     yae222,
                     aae013,
                     aac040,
                     yab139,
                     yab013,
                     aae011,          -- ������
                     aae036)          -- ����ʱ��
            VALUES ( var_yac001,
                     var_aac001,          -- ���˱��
                     var_aab001,
                     var_yae181,          -- ֤������
                     var_aac002,          -- ���֤����(֤������)
                     var_aac003,          -- ����
                     var_aac004,          -- �Ա�
                     var_aac005,
                     var_aac006,          -- ��������
                     var_aac007,          -- �μӹ�������
                     var_aac008,          -- ��Ա״̬
                     var_aac009,
                     var_aac010,
                     var_aac012,
                     var_aac013,
                     var_aac014,
                     var_aac015,
                     var_aac020,
                     var_yac067,          -- ��Դ��ʽ
                     var_yac168,          -- ũ�񹤱�־
                     var_aae004,
                     var_aae005,          -- ��ϵ�绰
                     var_aae006,          -- ��ַ
                     var_aae007,
                     var_yae222,
                     var_aae013,
                     0,
                     PKG_Constant.YAB003_JBFZX,
                     var_aab001,
                     var_aae011,          -- ������
                     sysdate);         -- ����ʱ��
      END IF;

    --  �����걨���ݺ�������Ϣ����
    --  ����֮ǰ��irac01a3 ����
    -- ��ǰ��λ������ 
     SELECT count(1) INTO count_aab001_irac01a3  FROM wsjb.irac01a3 WHERE aac002 = var_aac002  AND aab001 = var_aab001;
   
    IF  count_aab001_irac01a3 > 0  THEN
    
     INSERT INTO wsjb.tmp_irac01a3 SELECT * FROM wsjb.irac01a3 WHERE aac002 = var_aac002  AND aac003 = var_aac003;
     
         BEGIN
          
               select count(1) 
                 into num_count_tmp_irac01a2 
                 from wsjb.tmp_irac01a2 
                where aac002 =  var_aac002
                    AND aab001 = var_aab001
                     AND  IAA002='0'
                     AND IAA001 <> '4'
                     --AND IAA100 = var_iaa100_new ;
                     AND IAA100  IS NULL;
              if  num_count_tmp_irac01a2 < 1 then
                  prm_msg := prm_msg|| 'tmp_irac01a2û�пɴ�����Ϣ��';
                  return;
              end if;
         
             SELECT aac001  INTO irac01_aac001  FROM wsjb.tmp_irac01a2 
                    WHERE aac002 =  var_aac002
                    AND aab001 = var_aab001
                     AND  IAA002='0'
                     AND IAA001 <> '4'
                     --AND IAA100 = var_iaa100_new ;
                     AND IAA100  IS NULL ;
                 
            SELECT aac001  INTO irac01a3_aac001   FROM wsjb.tmp_irac01a3
                         WHERE  aac002 = var_aac002 AND aab001 =  var_aab001;
                        
                         
              /*  SELECT aac001  INTO irac01a3_aac001   FROM wsjb.irac01a3
                WHERE  aac002 = var_aac002 AND aab001 =  var_aab001;
                   */ 

           EXCEPTION

              WHEN NO_DATA_FOUND THEN
                 prm_sign := '1'; 
                  prm_msg := prm_msg|| 'δ��ȡ�����ϻ�����Ϣ';
              -- prm_ErrorMsg := prm_msg;
               --   GOTO label_ERROR;
                RETURN;
              WHEN TOO_MANY_ROWS THEN
                 
                  --prm_AppCode  :=  PKG_Constant.;
                  prm_msg := prm_msg|| '�����֤��'|| var_aac002 ||'Ϊ������Ա����ѡ������һ�����˱���ٽ��в���';
                  -- prm_ErrorMsg := prm_msg;
                   prm_sign := '1'; 
                  -- delete from wsjb.irac01a3 where  aac002 = var_aac002 and aac001 = var_aac001 and aac003 = var_aac003;
               --   GOTO label_ERROR;
                 RETURN;

          WHEN OTHERS THEN

                
             IF    irac01_aac001   <>  irac01a3_aac001 THEN
             -- prm_AppCode  :=  PKG_Constant.gn_def_ERR;
               prm_msg   := 'irac01'||irac01_aac001||'��irac01a3'||irac01a3_aac001||'��Ϣ��ƥ��!';
               prm_ErrorMsg := prm_msg;
               prm_sign := '1'; 
              END IF;
              -- GOTO label_ERROR; 
           
             RETURN;
         END;
       END IF;
   END IF;
   --  end wangz 20190605
   
   
    -- begin wangz 20190708
   /*
     IF  var_aac006 is null  THEN
            prm_sign := '1';
            prm_msg  := '����Ա��������Ϊ��!!��';
            GOTO label_ERROR;
     END IF ;

      --  select trunc(months_between(sysdate,to_date(to_char(var_aac006,'yyyymm'),'yyyymm'))) INTO sj_months from dual;
     --   select trunc(months_between(sysdate,to_date(to_number(to_char(var_aac006,'yyyyMMdd'),'yyyymm')),'yyyymm')) INTO sj_months from dual;
    --  select  months_between(sysdate,to_date(to_number(substr(replace(var_aac006,'-',''),0,6)),'yyyyMM'))   INTO sj_months   from dual;
      select to_number(to_char(min(aac006),'yyyymm'))   INTO var_aac006_ac01  
            from xasi2.ac01
           where aac002 = var_aac002
           and aac001   = var_aac001
             AND rownum = 1   ;

           select trunc(months_between(sysdate,to_date(var_aac006_ac01,'yyyymm'))) INTO sj_months from dual;
   
    
        --select akc021  INTO  zy_akc021 from xasi2.kc01    where aac001 = var_aac001;

         IF   var_aae110 = '1' and  var_aac004 = '2' and var_aac004 IS NOT NULL  THEN --  �����״βα�
                select X INTO X from dual;
         
             --  ����ɲ�  55 4  ���� 50  1  ���Ů��   
                 IF   sj_months > woman_worker_months  and var_aac012 = '1' THEN
                      prm_sign := '1';
                      prm_msg  := '����Ա�������Ϊ���ˣ�������Ҫ��������ͣ�';
                       GOTO label_ERROR;
                 ELSIF   sj_months >=  woman_months and  var_aac012 = '4'  THEN
                      prm_sign := '1';
                      prm_msg  := '����Ա�������Ϊ�ɲ���������Ҫ��������ͣ�';
                       GOTO label_ERROR;
                 END IF;
             
             END IF;
   
   */
    --  end  20190708

   --�ж��Ƿ��ǵ����ϵ�λ
    SELECT COUNT(1)
      INTO num_count
      FROM xasi2.ab02
     WHERE AAB001 = var_aab001
       AND AAB051 = '1';

    IF num_count = 0 THEN
    --������������Ϊ0
      UPDATE wsjb.tmp_irac01a2
         SET yac005 = 0
       WHERE iaz018 = prm_iaz018;
    END IF;

    dat_aac006 := rec_tmp_irac01a2.aac006;--��������
    dat_aac007 := rec_tmp_irac01a2.aac007;--�ι�����
    dat_aac030 := rec_tmp_irac01a2.aac030;--��ϵͳ�α�����
    dat_yac033 := rec_tmp_irac01a2.yac033;--���˳��βα�����
    var_iaa100 := rec_tmp_irac01a2.iaa100;--�걨�¶�
  --  SELECT TO_DATE(var_iaa100||'01','yyyy-MM-dd HH:MI:SS') INTO dat_iaa100 FROM dual;
    IF dat_aac007 > dat_aac030 THEN
      prm_msg :=  prm_msg||'�״βμӹ������ڲ������ڵ�����λ�α�����!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) > TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'������λ�α����ڲ������ڵ�ǰ���걨�¶�'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_aac006 > dat_aac007 THEN
      prm_msg :=  prm_msg||'�״βμӹ������ڲ������ڳ�������!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_aac006 > dat_aac030 THEN
      prm_msg :=  prm_msg||'����λ�α����ڲ������ڳ�������!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;


     --У��֤����Ϣ
     prc_p_ValidateAac002Continue(rec_tmp_irac01a2.yae181,     --֤������
                                  rec_tmp_irac01a2.aac002,     --֤������
                                  var_aab001,     --��λ���
                                  var_iaa100,     --�¶�
                                  var_aac001,     --���˱��
                                  prm_msg ,     -- ������Ϣ
                                  prm_sign,     -- �����־
                                  prm_AppCode,     --ִ�д���
                                  prm_ErrorMsg);    --������Ϣ
     IF prm_sign = '1' THEN

      GOTO label_ERROR;
     END IF ;

     --����У��
     IF rec_tmp_irac01a2.aae110 = '0' AND
        rec_tmp_irac01a2.aae120 = '0' AND
        rec_tmp_irac01a2.aae210 = '0' AND
        rec_tmp_irac01a2.aae310 = '0' AND
        rec_tmp_irac01a2.aae410 = '0' AND
        rec_tmp_irac01a2.aae510 = '0' AND
        rec_tmp_irac01a2.aae311 = '0' AND
        rec_tmp_irac01a2.aae810 = '0' THEN

        prm_msg :=  prm_msg||'δ��ȡ����ѡ�α���������Ϣ!';
        prm_sign := '1';
        GOTO label_ERROR;

     END IF;

      -- ������� ���ڵ�ǰ��Ųι��� ��ʾ�������� begin

       SELECT count(1) into ac01_count
           FROM xasi2.ac01
          WHERE aac001 <> var_aac001
            AND aac002  = var_aac002;

         IF    ac01_count > 0 THEN
          -- У���ڵ�ǰ��λ�ι���
         FOR rec_aac001 IN cur_aac001 LOOP
         select count(1) INTO ac02_count_04 from xasi2.ac02 where aac001  in (
               SELECT  aac001
           FROM xasi2.ac01
          WHERE aac001 <> var_aac001
            AND aac002  = var_aac002
            )
            and aab001 = var_aab001
            and aae140 = '04'
            and aac031 = PKG_Constant.AAC031_CBJF;

            IF  ac02_count_04 > 0 THEN
                Select aab004 INTO  var_aab004 from xasi2.ab01 where aab001 =  var_aab001;
                prm_msg := '���˱��:'||rec_aac001.aac001||'����:'
                                    ||rec_aac001.aac003||'���֤��:'||rec_aac001.aac002
                                    ||' ����' ||var_aab004|| '�������ڱ���λ�μӹ������֣�������Ա��������ģ���²�����'||';';
                prm_sign:= '1';
            END IF ;
          END LOOP;
         END IF ;

     -- ������� ���ڵ�ǰ��Ųι��� ��ʾ�������� end



     -- ����У��   201812229 begin  wangz


         --�ж���Ա�Ƿ���ڲα���Ϣac02,���κ�ְ���α���Ϣ����У��
         IF ( var_aae210  = '1'  or  var_aae210  = '10'    ) THEN
         INSERT INTO XASI2.TMP_AAE140(  yae099,--���˱���-->
                                         aab001,--��λ���� -->
                                         aae140,--����-->
                                         yab139 --�α�������-->
                                         )
                                  VALUES (var_aac001       ,--���˱���-->
                                          var_aab001 , --��λ���� -->
                                          '02', --����-->
                                          PKG_Constant.YAB003_JBFZX  --�α�������-->
                                         );
      END IF;
      IF (var_aae310  = '1'  or  var_aae310  = '10'   ) THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--���˱���-->
                                         aab001,--��λ���� -->
                                         aae140,--����-->
                                         yab139 --�α�������-->
                                         )
                                  VALUES (var_aac001       ,--���˱���-->
                                          var_aab001 , --��λ���� -->
                                          '03', --����-->
                                          PKG_Constant.YAB003_JBFZX  --�α�������-->
                                         );
      END IF;
      IF ( var_aae410  = '1'  or  var_aae410  = '10'  ) THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--���˱���-->
                                         aab001,--��λ���� -->
                                         aae140,--����-->
                                         yab139 --�α�������-->
                                         )
                                  VALUES (var_aac001       ,--���˱���-->
                                          var_aab001, --��λ���� -->
                                          '04', --����-->
                                          PKG_Constant.YAB003_JBFZX  --�α�������-->
                                         );
      END IF;
      IF (var_aae510  = '1'  or  var_aae510  = '10') THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--���˱���-->
                                         aab001,--��λ���� -->
                                         aae140,--����-->
                                         yab139 --�α�������-->
                                         )
                                  VALUES (var_aac001       ,--���˱���-->
                                          var_aab001, --��λ���� -->
                                          '05', --����-->
                                          PKG_Constant.YAB003_JBFZX  --�α�������-->
                                         );
      END IF;
      IF ( var_aae311 = '1'  or  var_aae311  = '10') THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--���˱���-->
                                         aab001,--��λ���� -->
                                         aae140,--����-->
                                         yab139 --�α�������-->
                                         )
                                  VALUES (var_aac001       ,--���˱���-->
                                          var_aab001, --��λ���� -->
                                          '07', --����-->
                                          PKG_Constant.YAB003_JBFZX  --�α�������-->
                                         );
      END IF;
      IF ( var_aae120 = '1'  or  var_aae120  = '10') THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--���˱���-->
                                         aab001,--��λ���� -->
                                         aae140,--����-->
                                         yab139 --�α�������-->
                                         )
                                  VALUES (var_aac001       ,--���˱���-->
                                          var_aab001, --��λ���� -->
                                          '06', --����-->
                                          PKG_Constant.YAB003_JBFZX  --�α�������-->
                                         );
      END IF;
      IF (var_aae810 = '1'  or  var_aae810  = '10' ) THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--���˱���-->
                                         aab001,--��λ���� -->
                                         aae140,--����-->
                                         yab139 --�α�������-->
                                         )
                                  VALUES (var_aac001       ,--���˱���-->
                                          var_aab001  , --��λ���� -->
                                          '08', --����-->
                                          PKG_Constant.YAB003_JBFZX  --�α�������-->
                                         );
      END IF;




         SELECT COUNT(1)
           INTO NUM_COUNT
           FROM xasi2.AC02
          WHERE AAC001 = var_aac001;

          IF (NUM_COUNT = 0 or NUM_COUNT != 0)   AND var_aac008 <> xasi2.PKG_COMM.AAC008_TX THEN
             --����λ����ѭ�������˲α���Ϣ
           FOR rec_aae140 IN cur_aae140 LOOP
               var_aae140 := rec_aae140.aae140;
               FOR rec_aac001 IN cur_aac001 LOOP
                 IF var_aae140 = '03' OR var_aae140 = '05' OR var_aae140 = '07' OR var_aae140 = '08' OR var_aae140 = '02' THEN
                   SELECT COUNT(1)
                     INTO count_repeat_zg
                     FROM xasi2.ac02
                    WHERE aac001 = rec_aac001.aac001
                      AND aae140 IN ('03','05','07','08','02')
                      AND aac031 = '1';
                   IF count_repeat_zg > 0 THEN
              Select aab004 INTO  var_aab004 from xasi2.ab01 where aab001 = (SELECT
                      distinct  aab001
                      FROM xasi2.ac02
                     WHERE aac001 = rec_aac001.aac001
                      AND aae140 IN ('03','05','07','08','02')
                       AND aac031 = '1');
                      prm_msg := '���˱��:'||rec_aac001.aac001||'����:'
                                    ||rec_aac001.aac003||'���֤��:'||rec_aac001.aac002
                                    ||' ����' ||var_aab004|| '�μ�ְ��ҽ����˵������α�״̬Ϊ��ͣ�ɷѣ���������ģ���������α�״̬Ϊ�α��ɷѣ�������ԭ��λ������ͣ�ɷѺ��ٲ���������'||';';
                       prm_sign:= '1';
                   END IF;

                 END IF;
               END LOOP;
            END LOOP;
          END IF;


     -- ����У��   201812229 begin  wangz

     --����Ա��������У��
     IF rec_tmp_irac01a2.aae810 = '1' THEN

        IF rec_tmp_irac01a2.yac200 IS NULL THEN
          prm_msg :=  prm_msg||'����Աְ������Ϊ��!';
           prm_sign := '1';
           GOTO label_ERROR;
        END IF;

     END IF;



     --����У��
     num_aac040 := rec_tmp_irac01a2.aac040;--�ɷѹ���
 IF rec_tmp_irac01a2.iaa100 IS NOT NULL THEN
     IF rec_tmp_irac01a2.aae110 IN  ('1','10') THEN
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,var_aab001,num_aac040,'0','01','1','1',var_iaa100,prm_yab139))
          INTO num_yac004
          FROM  dual ;
        IF ROUND(num_yac004) <> rec_tmp_irac01a2.yac004 THEN
          --��ҵ���ϻ�������
          UPDATE wsjb.tmp_irac01a2
             SET yac004 = ROUND(num_yac004)
           WHERE iaz018 = prm_iaz018
           AND   aac002 = rec_tmp_irac01a2.aac002;
        END IF;
    ELSE
     UPDATE wsjb.tmp_irac01a2
             SET yac004 = ''
           WHERE iaz018 = prm_iaz018
           AND   aac002 = rec_tmp_irac01a2.aac002;
     END IF;

     IF rec_tmp_irac01a2.aae120 = '1' THEN

        IF num_aac040 <> rec_tmp_irac01a2.yac004 THEN
          --�������ϻ�������
          UPDATE wsjb.tmp_irac01a2
             SET yac004 = num_aac040
           WHERE iaz018 = prm_iaz018
           AND   aac002 = rec_tmp_irac01a2.aac002;
        END IF;
      END IF;
     END IF;
/*
     IF rec_tmp_irac01a2.aae210 = '1' OR
        rec_tmp_irac01a2.aae310 = '1' OR
        rec_tmp_irac01a2.aae410 = '1' OR
        rec_tmp_irac01a2.aae510 = '1' OR
        rec_tmp_irac01a2.aae810 = '1' THEN
        --��һ������Ϊ׼
        SELECT aae140
          INTO var_aae140
          FROM xasi2.AB02
         WHERE aab051 = '1'
           AND (aae140 = '02' OR aae140 = '03' OR aae140 = '04' OR aae140 = '05' )
           AND aab001 = var_aab001
           AND ROWNUM = 1;
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,var_aab001,num_aac040,'0',var_aae140,'1','1',var_iaa100,prm_yab139))
          INTO num_yac005
          FROM  dual ;
        IF ROUND(num_yac005) <> rec_tmp_irac01a2.yac005 THEN
          --������������
          UPDATE tmp_irac01a2
             SET yac005 = ROUND(num_yac005),
                 yaa333 = ROUND(num_yac005)
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;   */
     --����״̬�ж�
/*
     --ְ������
     IF rec_tmp_irac01a2.aae110 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM IRAC01A3
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aae110 = '0';
        IF num_count > 0 THEN
          UPDATE tmp_irac01a2
             SET aae110 = '10'  --����
           WHERE iaz018 = prm_iaz018;

        ELSE
          UPDATE tmp_irac01a2
             SET aae110 = '1'  --����
           WHERE iaz018 = prm_iaz018;
        END IF;


     ELSIF rec_tmp_irac01a2.aae110 = '0' THEN
        --δ��ѡ����
        SELECT count(1)
           INTO num_count
           FROM IRAC01A3
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aae110 = '2';
         IF num_count > 0 THEN
          UPDATE tmp_irac01a2
             SET aae110 = '2'   --�α��ɷ�
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
           FROM IRAC01A3
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aae110 = '0';
         IF num_count > 0 THEN
          UPDATE tmp_irac01a2
             SET aae110 = '0'  --��ͣ�ɷ�
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;
*/
      --��������
     IF rec_tmp_irac01a2.aae120 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '06';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '06';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae120 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'�����������ֲ�Ϊ��ͣ�ɷ�״̬��';
            prm_sign := '1';
            GOTO label_ERROR;
          END IF ;
        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae120 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae120 = '0' THEN
        --δ��ѡ����
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '06';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae120 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '06';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae120 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

     --����
     IF rec_tmp_irac01a2.aae410 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '04';
        IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '10'
           WHERE iaz018 = prm_iaz018;
        ELSE
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '1'
           WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae410 = '0' THEN
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '04';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '04';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;
     --ʧҵ
     IF rec_tmp_irac01a2.aae210 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '02';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '02';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae210 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'ʧҵ���ֲ�Ϊ��ͣ�ɷ�״̬��';
            prm_sign := '1';
            GOTO label_ERROR;

          END IF ;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae210 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae210 = '0' THEN
        --δ��ѡ����
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '02';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae210 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '02';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae210 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

      --ҽ��
     IF rec_tmp_irac01a2.aae310 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '03';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '03';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae310 = '10'
             WHERE iaz018 = prm_iaz018;

          ELSE
            prm_msg :=  prm_msg||'ҽ�����ֲ�Ϊ��ͣ�ɷ�״̬��';
            prm_sign := '1';
            GOTO label_ERROR;

          END IF ;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae310 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae310 = '0' THEN
        --δ��ѡ����
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '03';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae310 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '03';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae310 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

      --����
     IF rec_tmp_irac01a2.aae510 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '05';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '05';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae510 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'�������ֲ�Ϊ��ͣ�ɷ�״̬��';
            prm_sign := '1';
            GOTO label_ERROR;
          END IF ;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae510 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae510 = '0' THEN
        --δ��ѡ����
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '05';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae510 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '05';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae510 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

      --���
     IF rec_tmp_irac01a2.aae311 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '07';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '07';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae311 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'�������ֲ�Ϊ��ͣ�ɷ�״̬��';
            prm_sign := '1';
            GOTO label_ERROR;
          END IF ;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae311 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae311 = '0' THEN
        --δ��ѡ����
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '07';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae311 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '07';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae311 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

     --����Ա����
     IF rec_tmp_irac01a2.aae810 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '08';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '08';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae810 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'����Ա�������ֲ�Ϊ��ͣ�ɷ�״̬��';
            prm_sign := '1';
            GOTO label_ERROR;
          END IF;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae810 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae810 = '0' THEN
        --δ��ѡ����
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '08';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae810 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '08';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae810 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;



     /*У��������*/
      --�����޸Ļ�������
    var_aac009 := rec_tmp_irac01a2.aac009;
    IF var_aac009 = '10' THEN
      UPDATE wsjb.tmp_irac01a2
         SET aac009 = '10',
             aac013 = '2',
             yac168 = '0'
       WHERE iaz018 = prm_iaz018;

      UPDATE xasi2.ac01
         SET aac009 = '10',
             aac013 = '2',
             yac168 = '0'
       WHERE aac001 = var_aac001;



       UPDATE xasi2.ac02
          SET yac505 = '020'
        WHERE aac001 = var_aac001
          AND aae140 = '02';

    ELSIF var_aac009 = '20' THEN
      UPDATE wsjb.tmp_irac01a2
         SET aac009 = '20',
             aac013 = '3',
             yac168 = '1'
       WHERE iaz018 = prm_iaz018;

      UPDATE xasi2.ac01
         SET aac009 = '20',
             aac013 = '3',
             yac168 = '1'
       WHERE aac001 = var_aac001;

       UPDATE xasi2.ac02
          SET yac505 = '021'
        WHERE aac001 = var_aac001
          AND aae140 = '02';
    END IF;
    UPDATE wsjb.tmp_irac01a2
       SET iaa100 = ''
       WHERE iaz018 = prm_iaz018;
     /*����ʧ��*/
      <<label_ERROR>>

        num_count :=0;

   EXCEPTION
     WHEN OTHERS THEN
          /*�رմ򿪵��α�*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '���ݿ����'|| SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() ;
          RETURN;
   END prc_p_ValidateContinueCheck;

   /*--------------------------------------------------------------------------
   || ҵ�񻷽� ����Ա��������������֤
   || �������� prc_p_ValidateAac002KindAdd
   || �������� ��У�����Ա�Ƿ��ܽ����������ֵ���Ϣ¼��
   ||
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��zhujing         ������� ��2015-11-23
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateAac002KindAdd(
       prm_yae181          IN            VARCHAR2,     --֤������
      prm_aac002          IN            VARCHAR2,     --֤������
      prm_aab001          IN            VARCHAR2,     --��λ���
      prm_iaa100          IN            VARCHAR2,     --�¶�
      prm_aac001          IN           VARCHAR2,     --���˱��
      prm_msg             OUT           VARCHAR2,     -- ������Ϣ
      prm_sign            OUT           VARCHAR2,     -- �����־
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2)    --������Ϣ

   IS
   num_count        NUMBER(6);
   num_count1       NUMBER(6);
   var_aac002Low    irac01.aac002%TYPE;
   var_15aac002     irac01.aac002%TYPE;
   var_aab001       irab01.aab001%TYPE;
   var_aac001       irac01.aac001%TYPE;
   var_akc021       irac01.akc021%TYPE;
   var_aac008       irac01.aac008%TYPE;
   var_yab013       irac01.yab013%TYPE;--ԭ��λ���
   BEGIN
    /*��ʼ������*/
      prm_AppCode  := GN_DEF_OK;
      prm_ErrorMsg := '';
      prm_msg :='';
      prm_sign :='0';
   --У�����
      IF prm_yae181 IS NULL  THEN
         prm_msg :=  prm_msg||'����֤������Ϊ�գ����ʵ������';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
      IF prm_aab001 IS NULL  THEN
         prm_msg :=  prm_msg||'���뵥λ���Ϊ�գ����ʵ������';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
      IF prm_aac002 IS NULL  THEN
         prm_msg :=  prm_msg||'����֤������Ϊ�գ����ʵ������';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
       --���֤����
     IF prm_yae181 = 1 THEN
        --��ȡ������ʽ��֤������
         var_15aac002 := SUBSTR(prm_aac002,1,6)||SUBSTR(prm_aac002,9, 9);
         var_aac002Low := LOWER(prm_aac002);

        SELECT count(1)
          INTO num_count
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
           AND AAC003 NOT LIKE '%�ظ�%';

        IF num_count = 0 THEN
           prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա�����ڸ�����Ϣ�������²α�ģ�������1��';
           prm_sign :='1';
           GOTO label_ERROR ;
        END IF ;
/*        IF num_count > 1 THEN
           prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա���ڶ���������Ϣ��������ϵ�籣���ģ�';
           prm_sign :='1';
           GOTO label_ERROR ;
        END IF ;
*/

        SELECT aac001,
               aac008
          INTO var_aac001,
               var_aac008
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.AAC001=prm_aac001
           AND AAC003 NOT LIKE '%�ظ�%';

             --�жϴ����ڱ���λ�Ƿ��������α�״̬
       SELECT SUM(count)
        INTO num_count
        FROM (SELECT count(*) AS count
        FROM xasi2.ac02
        WHERE aac001 =prm_aac001
        AND aab001 = prm_aab001
        AND aac031='1'
    --    AND aae140<>'04'
        UNION
        SELECT count(1) AS count
        FROM wsjb.irac01a3
        WHERE aac002 = prm_aac002
        AND aab001 = prm_aab001
        AND aae110 = '2');
        IF num_count = 0 THEN
         prm_msg := '�����ڱ���λû�������α������֣��뵽����ģ�������';
         prm_sign :='1';
         GOTO label_ERROR ;
          END IF;

   ELSE
        SELECT count(1)
          INTO num_count
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.AAC002 = prm_aac002
           AND AAC003 NOT LIKE '%�ظ�%';

        IF num_count = 0 THEN
           prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա�����ڸ�����Ϣ�������²α�ģ�������2��';
           prm_sign :='1';
           GOTO label_ERROR ;
        END IF ;
       /* IF num_count > 1 THEN
           prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա���ڶ���������Ϣ��������ϵ�籣���ģ�';
           prm_sign :='1';
           GOTO label_ERROR ;
        END IF ;*/

        SELECT aac001,
               aac008
          INTO var_aac001,
               var_aac008
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.AAC001 = prm_aac001
           AND AAC003 NOT LIKE '%�ظ�%';
     END IF;
  SELECT count(1) INTO num_count FROM xasi2.kc01 WHERE aac001 = prm_aac001;

  IF num_count >0 THEN--��������Ա�������ּ���num_count����0
        SELECT A.AKC021
          INTO var_akc021
          FROM xasi2.KC01 A
         WHERE A.AAC001 = prm_aac001;
       IF var_aac008 = '2' AND var_akc021 = '11' THEN
           prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա���ڰ������ҵ��,���ܰ���������������Ҫ������ϵ�籣���ģ�';
          prm_sign :='1';
          GOTO label_ERROR ;
       END IF;
END IF;


       --�ڱ�ĵ�λ�Ƿ��вα��ɷѼ�¼
       SELECT SUM(COUNT1)
         INTO num_count
         FROM (SELECT COUNT(*) AS COUNT1
                  FROM xasi2.ac01 A, xasi2.ac02 B
                 WHERE A.AAC001 = B.AAC001
                   AND A.AAE120 = '0'
                   AND B.AAC031 = '1'
                   AND B.AAE140 <> '04'
                   AND A.AAC001 = prm_aac001
                   AND B.AAB001 <> prm_aab001
                UNION
                SELECT COUNT(1) AS COUNT1
                  FROM wsjb.irac01a3
                 WHERE AAB001 <> prm_aab001
                   AND AAC001 = prm_aac001
                   AND AAE110 = '2');
      IF num_count = 0 THEN
        SELECT count(1)
          INTO num_count
          FROM wsjb.irac01
         WHERE AAC001 = prm_aac001
           AND IAA001 = '4'
           AND IAA002 = '1';
        IF num_count > 0 THEN
          prm_msg := '���˴��ڴ���˵ġ���Ա��Ҫ��Ϣ���������,����ʾ���˾���Я��������ϵ��籣���Ľ�����˰�������ɹ��󣬷��ɽ�������������';
          prm_sign :='1';
          GOTO label_ERROR ;
        END IF;


      ELSE
        SELECT COUNT(1) AS COUNT1
          INTO num_count
          FROM xasi2.ac01 A, xasi2.ac02 B
         WHERE A.AAC001 = B.AAC001
           AND A.AAE120 = '0'
           AND B.AAC031 = '1'
           AND B.AAE140 = '04'
           AND A.AAC001 = prm_aac001
           AND B.AAB001 = prm_aab001;
         IF num_count > 0 THEN
             prm_msg := '������������λ������δ����ͣ�����ڱ���λ�Ѳι������֣�';
            prm_sign :='1';
            GOTO label_ERROR ;
         END IF;

        SELECT COUNT(*) AS COUNT1
          INTO num_count
          FROM xasi2.ac01 A, xasi2.ac02 B, xasi2.ab01 C
         WHERE A.AAC001 = B.AAC001
           AND B.AAB001 = C.AAB001
           AND A.AAE120 = '0'
           AND B.AAC031 = '1'
           AND B.AAE140 IN ('03', '07')
           AND A.AAC001 = prm_aac001
           AND C.YAB136 = '001';
        IF num_count > 0 THEN
           prm_msg := '���������´������������δ����ͣ,����ͣ����������';
           prm_sign :='1';
           GOTO label_ERROR ;
        END IF;

      prm_msg := '������������λ������δ����ͣ,����λֻ�ܲα������գ�';
      prm_sign :='2';
      GOTO label_ERROR ;
      END IF;

      SELECT SUM(I)
        INTO num_count
        FROM (SELECT COUNT(1) AS I
                FROM xasi2.ac08 A, wsjb.irab01a5  B
               WHERE A.AAB001 = B.AAB001
                 AND AAC001 = prm_aac001
                 AND AAE140 = '03'
                 AND AAE002 = prm_iaa100
              UNION
              SELECT COUNT(1) AS I
                FROM xasi2.ac08a1 A, wsjb.irab01a5  B
               WHERE A.AAB001 = B.AAB001
                 AND AAC001 = prm_aac001
                 AND AAE140 = '03'
                 AND AAE002 = prm_iaa100);
      IF num_count > 0 THEN
         prm_msg := '����'||prm_iaa100||'����ҽ�ƽɷѼ�¼��Ϣ,������������ϸ����ѯ�籣����!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

       SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 IN ('3','7')
         AND A.IAA002 = '0'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '���˴��ڴ��걨����ͣ��Ϣ,���Ȱ����걨ҵ��!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '0'
         AND A.AAC001 = prm_aac001;
      IF num_count > 0 THEN
         prm_msg := '���˴��ڴ��걨��������Ϣ,���Ȱ����걨ҵ��!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '1'
         AND A.AAC001 = prm_aac001;
      IF num_count > 0 THEN
         prm_msg := '���˴������걨��������Ϣ,��ȴ����ͨ��!!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '4'
         AND A.AAC001 = prm_aac001;
      IF num_count > 0 THEN
         prm_msg := '���˴��ڱ���ص�������Ϣ,�뵽[���걨]�������޸������Ϣ�����걨!!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '5'
         AND A.IAA002 = '0'
         AND A.AAC001 = prm_aac001;
      IF num_count > 0 THEN
         prm_msg := '���˴��ڴ��걨������������Ϣ,���Ȱ����걨ҵ��!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '5'
         AND A.IAA002 = '1'
         AND A.AAC001 = prm_aac001;
      IF num_count > 0 THEN
         prm_msg := '���˴������걨������������Ϣ,��ȴ����ͨ��!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 IN ('3', '7', '9', '10')
         AND A.IAA002 = '2'
         AND A.AAC001 = prm_aac001
         AND A.IAA100 = prm_iaa100;
      IF num_count > 0 THEN
        SELECT aab001
          INTO var_yab013
          FROM wsjb.irac01  A
         WHERE A.IAA001 IN ('3', '7', '9', '10')
           AND A.IAA002 = '2'
           AND A.AAC001 = prm_aac001
           AND A.IAA100 = prm_iaa100
           AND ROWNUM = 1;

        SELECT SUM(I) as i
          INTO num_count
          FROM (SELECT COUNT(1) I
                  FROM xasi2.ab08
                 WHERE AAB001 = var_yab013
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01'
                UNION ALL
                SELECT COUNT(1) I
                  FROM xasi2.ab08a8
                 WHERE AAB001 = var_yab013
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01'
                UNION ALL
                SELECT COUNT(1) I
                  FROM wsjb.irab08
                 WHERE AAB001 = var_yab013
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01');
  /***
       IF num_count > 0 THEN
          prm_msg := '���˴��ڴ���˵���Ա������Ϣ�����ܰ�������,��ȴ����ͨ��!';
         prm_sign :='1';
         GOTO label_ERROR ;
       END IF;
***/

      END IF;



      /*����ʧ��*/
      <<label_ERROR>>

       num_count :=0;
  EXCEPTION
     WHEN OTHERS THEN
          /*�رմ򿪵��α�*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '���ݿ����'|| SQLERRM||dbms_utility.format_error_backtrace ;
          RETURN;
   END prc_p_ValidateAac002KindAdd;

    /*--------------------------------------------------------------------------
   || ҵ�񻷽� ����Ա��������������֤
   || �������� prc_p_ValidateKindAddCheck
   || �������� ��У�����Ա¼�������������Ϣ
   ||
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��zhujing         ������� ��2015-11-24
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateKindAddCheck(
       prm_iaz018          IN            VARCHAR2,     --���κ�
      prm_yab139          IN            VARCHAR2,     --�������
      prm_msg             OUT           VARCHAR2,     -- ������Ϣ
      prm_sign            OUT           VARCHAR2,     -- �����־
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2)    --������Ϣ
  IS
   num_count        NUMBER(6);
   rec_tmp_irac01a2 tmp_irac01a2%ROWTYPE;
   dat_aac006       DATE ;--��������
   dat_aac007       DATE ;--�ι�����
   dat_aac030       DATE ;--��ϵͳ�α�����
   dat_yac033       DATE ;--���˳��βα�����
   var_aab001       irab01.aab001%TYPE;
   var_aae140       irab02.aae140%TYPE;
   num_aac040       NUMBER(14,2); --�ɷѹ���
   num_yac004       NUMBER(14,2); --���ϻ���
   num_yac005       NUMBER(14,2); --��������
   var_iaa100       VARCHAR2(6);  --�걨�¶�
   var_aac001       irac01.aac001%TYPE;
   var_aac009       irac01.aac009%TYPE;  --��������
   BEGIN
   /*��ʼ������*/
     prm_AppCode  := GN_DEF_OK;
     prm_ErrorMsg := '';
     prm_msg :='';
     prm_sign :='0';



     SELECT *
     INTO rec_tmp_irac01a2
     FROM wsjb.tmp_irac01a2
    WHERE iaz018 = prm_iaz018;
     --У�����
    IF prm_iaz018 IS NULL  THEN
      prm_msg :=  prm_msg||'����У����ˮ��Ϊ�գ����ʵ������';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    var_aab001 := rec_tmp_irac01a2.aab001;
    var_aac001 := rec_tmp_irac01a2.aac001;

   --�ж��Ƿ��ǵ����ϵ�λ
    SELECT COUNT(1)
      INTO num_count
      FROM xasi2.ab02
     WHERE AAB001 = var_aab001
       AND AAB051 = '1';

    IF num_count = 0 THEN
    --������������Ϊ0
      UPDATE wsjb.tmp_irac01a2
         SET yac005 = 0
       WHERE iaz018 = prm_iaz018;
    END IF;

    dat_aac006 := rec_tmp_irac01a2.aac006;--��������
    dat_aac007 := rec_tmp_irac01a2.aac007;--�ι�����
    dat_aac030 := rec_tmp_irac01a2.aac030;--��ϵͳ�α�����
    dat_yac033 := rec_tmp_irac01a2.yac033;--���˳��βα�����
    var_iaa100 := rec_tmp_irac01a2.iaa100;--�걨�¶�

    IF dat_aac007 > dat_aac030 THEN
      prm_msg :=  prm_msg||'�״βμӹ������ڲ������ڵ�����λ�α�����!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
--    IF dat_aac030 > SYSDATE THEN
--      prm_msg :=  prm_msg||'������λ�α����ڲ�������ϵͳ����'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||'!';
--      prm_sign := '1';
--      GOTO label_ERROR;
--    END IF;
    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) > TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'������λ�α����ڲ������ڵ�ǰ���걨�¶�'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_aac006 > dat_aac007 THEN
      prm_msg :=  prm_msg||'�״βμӹ������ڲ������ڳ�������!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_aac006 > dat_aac030 THEN
      prm_msg :=  prm_msg||'����λ�α����ڲ������ڳ�������!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;


     --У��֤����Ϣ
     prc_p_ValidateAac002KindAdd(rec_tmp_irac01a2.yae181,     --֤������
                                  rec_tmp_irac01a2.aac002,     --֤������
                                  var_aab001,     --��λ���
                                  var_iaa100,     --�¶�
                                  var_aac001,     --���˱��
                                  prm_msg ,     -- ������Ϣ
                                  prm_sign,     -- �����־
                                  prm_AppCode,     --ִ�д���
                                  prm_ErrorMsg);    --������Ϣ
     IF prm_sign = '1' THEN

      GOTO label_ERROR;
     END IF ;

     --����У��
     IF rec_tmp_irac01a2.aae110 = '0' AND
        rec_tmp_irac01a2.aae120 = '0' AND
        rec_tmp_irac01a2.aae210 = '0' AND
        rec_tmp_irac01a2.aae310 = '0' AND
        rec_tmp_irac01a2.aae410 = '0' AND
        rec_tmp_irac01a2.aae510 = '0' AND
        rec_tmp_irac01a2.aae311 = '0' AND
        rec_tmp_irac01a2.aae810 = '0' THEN

        prm_msg :=  prm_msg||'δ��ȡ����ѡ�α���������Ϣ!';
        prm_sign := '1';
        GOTO label_ERROR;

     END IF;
     --����Ա��������У��
     IF rec_tmp_irac01a2.aae810 = '1' THEN

        IF rec_tmp_irac01a2.yac200 IS NULL THEN
          prm_msg :=  prm_msg||'����Աְ������Ϊ��!';
           prm_sign := '1';
           GOTO label_ERROR;
        END IF;

     END IF;



/*     --����У��
     num_aac040 := rec_tmp_irac01a2.aac040;--�ɷѹ���

     IF rec_tmp_irac01a2.aae110 IN ('1','10') THEN
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,var_aab001,num_aac040,'0','01','1','1',var_iaa100,prm_yab139))
          INTO num_yac004
          FROM  dual ;
        IF ROUND(num_yac004) <> rec_tmp_irac01a2.yac004 THEN

          --��ҵ���ϻ�������
          UPDATE tmp_irac01a2
             SET yac004 = ROUND(num_yac004)
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;

     IF rec_tmp_irac01a2.aae120 = '1' THEN

        IF num_aac040 <> rec_tmp_irac01a2.yac004 THEN
          --�������ϻ�������
          UPDATE tmp_irac01a2
             SET yac004 = num_aac040
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;

     IF rec_tmp_irac01a2.aae210 = '1' OR
        rec_tmp_irac01a2.aae310 = '1' OR
        rec_tmp_irac01a2.aae410 = '1' OR
        rec_tmp_irac01a2.aae510 = '1' OR
        rec_tmp_irac01a2.aae810 = '1' THEN
        --��һ������Ϊ׼
        SELECT aae140
          INTO var_aae140
          FROM xasi2.AB02
         WHERE aab051 = '1'
           AND (aae140 = '02' OR aae140 = '03' OR aae140 = '04' OR aae140 = '05' )
           AND aab001 = var_aab001
           AND ROWNUM = 1;
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,var_aab001,num_aac040,'0',var_aae140,'1','1',var_iaa100,prm_yab139))
          INTO num_yac005
          FROM  dual ;
        IF ROUND(num_yac005) <> rec_tmp_irac01a2.yac005 THEN
          --������������
          UPDATE tmp_irac01a2
             SET yac005 = ROUND(num_yac005),
                 yaa333 = ROUND(num_yac005)
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;  */
     --����״̬�ж�

     --ְ������
     IF rec_tmp_irac01a2.aae110 = '1' THEN
         UPDATE wsjb.tmp_irac01a2
             SET aae110 = '1'  --�²α�
           WHERE iaz018 = prm_iaz018;


    ELSIF rec_tmp_irac01a2.aae110 = '10' THEN
      UPDATE wsjb.tmp_irac01a2
             SET aae110 = '10'  --����
           WHERE iaz018 = prm_iaz018;
     ELSIF rec_tmp_irac01a2.aae110 = '0' THEN
        --δ��ѡ����
        SELECT count(1)
           INTO num_count
           FROM wsjb.irac01a3
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aae110 = '2';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae110 = '2'   --�α��ɷ�
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
           FROM wsjb.irac01a3
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aae110 = '0';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae110 = '0'  --��ͣ�ɷ�
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;

      --��������
     IF rec_tmp_irac01a2.aae120 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '06';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '06';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae120 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'�����������ֲ�Ϊ��ͣ�ɷ�״̬��';
            prm_sign := '1';
            GOTO label_ERROR;
          END IF ;
        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae120 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae120 = '0' THEN
        --δ��ѡ����
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '06';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae120 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '06';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae120 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

     --����
     IF rec_tmp_irac01a2.aae410 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '04';
        IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '10'
           WHERE iaz018 = prm_iaz018;
        ELSE
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '1'
           WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae410 = '0' THEN
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '04';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '04';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;
     --ʧҵ
     IF rec_tmp_irac01a2.aae210 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '02';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '02';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae210 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'ʧҵ���ֲ�Ϊ��ͣ�ɷ�״̬��';
            prm_sign := '1';
            GOTO label_ERROR;

          END IF ;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae210 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae210 = '0' THEN
        --δ��ѡ����
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '02';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae210 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '02';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae210 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

      --ҽ��
     IF rec_tmp_irac01a2.aae310 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '03';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '03';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae310 = '10'
             WHERE iaz018 = prm_iaz018;

          ELSE
            prm_msg :=  prm_msg||'ҽ�����ֲ�Ϊ��ͣ�ɷ�״̬��';
            prm_sign := '1';
            GOTO label_ERROR;

          END IF ;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae310 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae310 = '0' THEN
        --δ��ѡ����
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '03';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae310 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '03';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae310 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

      --����
     IF rec_tmp_irac01a2.aae510 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '05';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '05';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae510 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'�������ֲ�Ϊ��ͣ�ɷ�״̬��';
            prm_sign := '1';
            GOTO label_ERROR;
          END IF ;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae510 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae510 = '0' THEN
        --δ��ѡ����
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '05';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae510 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '05';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae510 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

      --���
     IF rec_tmp_irac01a2.aae311 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '07';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '07';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae311 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'�������ֲ�Ϊ��ͣ�ɷ�״̬��';
            prm_sign := '1';
            GOTO label_ERROR;
          END IF ;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae311 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae311 = '0' THEN
        --δ��ѡ����
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '07';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae311 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '07';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae311 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

     --����Ա����
     IF rec_tmp_irac01a2.aae810 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '08';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '08';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae810 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'����Ա�������ֲ�Ϊ��ͣ�ɷ�״̬��';
            prm_sign := '1';
            GOTO label_ERROR;
          END IF;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae810 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae810 = '0' THEN
        --δ��ѡ����
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '08';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae810 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '08';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae810 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;



     /*У��������*/
      --�����޸Ļ�������
    var_aac009 := rec_tmp_irac01a2.aac009;
    IF var_aac009 = '10' THEN
      UPDATE wsjb.tmp_irac01a2
         SET aac009 = '10',
             aac013 = '2',
             yac168 = '0'
       WHERE iaz018 = prm_iaz018;

      UPDATE xasi2.ac01
         SET aac009 = '10',
             aac013 = '2',
             yac168 = '0'
       WHERE aac001 = var_aac001;



       UPDATE xasi2.ac02
          SET yac505 = '020'
        WHERE aac001 = var_aac001
          AND aae140 = '02';

    ELSIF var_aac009 = '20' THEN
      UPDATE wsjb.tmp_irac01a2
         SET aac009 = '20',
             aac013 = '3',
             yac168 = '1'
       WHERE iaz018 = prm_iaz018;

      UPDATE xasi2.ac01
         SET aac009 = '20',
             aac013 = '3',
             yac168 = '1'
       WHERE aac001 = var_aac001;

       UPDATE xasi2.ac02
          SET yac505 = '021'
        WHERE aac001 = var_aac001
          AND aae140 = '02';
    END IF;
    UPDATE wsjb.tmp_irac01a2
         SET iaa100=''
       WHERE iaz018 = prm_iaz018;
     /*����ʧ��*/
      <<label_ERROR>>

        num_count :=0;

   EXCEPTION
     WHEN OTHERS THEN
          /*�رմ򿪵��α�*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '���ݿ����'|| SQLERRM ;
          RETURN;
   END prc_p_ValidateKindAddCheck;

  /*--------------------------------------------------------------------------
   || ҵ�񻷽� ����Ա��ͣ�ɷѱ���������֤
   || �������� prc_p_ValidateKindAddCheck
   || �������� ��У�����Ա��Ϣ
   ||
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��zhujing         ������� ��2015-11-24
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateReduceCheck(
       prm_iaz018          IN            VARCHAR2,     --���κ�
      prm_aac001          IN            VARCHAR2,     --���˱��
      prm_yab139          IN            VARCHAR2,     --�������
      prm_msg             OUT           VARCHAR2,     -- ������Ϣ
      prm_sign            OUT           VARCHAR2,     -- �����־
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2)    --������Ϣ
  IS
   num_count        NUMBER(6);
   rec_tmp_irac01a4 tmp_irac01a4%ROWTYPE;
   dat_aac006       DATE ;--��������
   dat_aac007       DATE ;--�ι�����
   dat_aac030       DATE ;--��ϵͳ�α�����
   dat_yac033       DATE ;--���˳��βα�����
   var_aab001       irab01.aab001%TYPE;
   var_aae140       irab02.aae140%TYPE;
   num_aac040       NUMBER(14,2); --�ɷѹ���
   num_yac004       NUMBER(14,2); --���ϻ���
   num_yac005       NUMBER(14,2); --��������
   var_iaa100       VARCHAR2(6);  --�걨�¶�
   var_aac001       irac01.aac001%TYPE;
   var_aac009       irac01.aac009%TYPE;  --��������
   dat_iaa100        DATE;
   BEGIN
   /*��ʼ������*/
     prm_AppCode  := GN_DEF_OK;
     prm_ErrorMsg := '';
     prm_msg :='';
     prm_sign :='0';
       --У�����
    IF prm_iaz018 IS NULL  THEN
      prm_msg :=  prm_msg||'����У����ˮ��Ϊ�գ����ʵ������';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
     --У�����
    IF prm_aac001 IS NULL  THEN
      prm_msg :=  prm_msg||'������˱��Ϊ�գ����ʵ������';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

      SELECT *
     INTO rec_tmp_irac01a4
     FROM wsjb.tmp_irac01a4
    WHERE iaz018 = prm_iaz018
      AND aac001 = prm_aac001;


    var_aab001 := rec_tmp_irac01a4.aab001;
    var_aac001 := prm_aac001;

    dat_aac030 := rec_tmp_irac01a4.aac030;
    var_iaa100 := rec_tmp_irac01a4.iaa100;
    SELECT TO_DATE(rec_tmp_irac01a4.iaa100||'01','yyyy-MM-dd HH:MI:SS') INTO dat_iaa100 FROM dual;
    IF dat_aac030 > dat_iaa100 THEN
      prm_msg :=  prm_msg||'ͣ�����ڲ��������걨�¶�'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) > TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'ͣ�����ڲ������ڵ�ǰ���걨�¶�'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) <> TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'ͣ���¶Ⱥ��걨�¶Ȳ�һ��'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --�Ƿ��Ѿ������걨��¼
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '0'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'����Ա�Ѵ��ڴ��걨��Ϣ!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --�Ƿ��Ѿ������걨��¼
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '1'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'����Ա�Ѵ����걨��Ϣ!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
  --�Ƿ��Ѿ������걨��¼
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '4'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'����Ա�Ѵ��ڴ�ص��걨��Ϣ���뵽���걨�����²����������������٣�';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --�Ƿ��Ѿ������걨��¼

    IF rec_tmp_irac01a4.aae013 = '251' THEN
      prm_msg :=  prm_msg||'��Ա��ְת�����뵽ר�õ�ģ���½��У�';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;


   --��ͣ�ɷѻ���
    IF rec_tmp_irac01a4.aae110 = '2' THEN
        SELECT yac004
          INTO num_yac004
          FROM wsjb.irac01a3
         WHERE aac001 = var_aac001
           AND aab001 = var_aab001
           AND aae110 = '2';


          --��ҵ���ϻ�������
          UPDATE wsjb.tmp_irac01a4
             SET yac004 = ROUND(num_yac004),
                 aae110 = '3'
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;

   --  ELSIF rec_tmp_irac01a4.aae110 = '0' THEN
          --��ҵ���ϻ�������
    --      UPDATE tmp_irac01a4
    --         SET yac004 = '',
    --             aae110 = '0'
    --       WHERE aac001 = var_aac001
     --      AND aab001 = var_aab001;
     END IF;

     IF rec_tmp_irac01a4.aae120 = '2' THEN
        SELECT yac004
          INTO num_yac004
          FROM xasi2.ac02
         WHERE aac001 = var_aac001
           AND aab001 = var_aab001
           AND aac031 = '1'
           AND aae140 = '06';

          --�������ϻ�������
          UPDATE wsjb.tmp_irac01a4
             SET yac004 = num_aac040,
                 aae120 = '3'
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;


     END IF;

     IF rec_tmp_irac01a4.aae210 = '2' OR
        rec_tmp_irac01a4.aae310 = '2' OR
        rec_tmp_irac01a4.aae410 = '2' OR
        rec_tmp_irac01a4.aae510 = '2' OR
        rec_tmp_irac01a4.aae311 = '2' OR
        rec_tmp_irac01a4.aae810 = '2' OR
        rec_tmp_irac01a4.aae120 = '2' THEN
        --��һ������Ϊ׼
        SELECT yac004
          INTO num_yac005
          FROM xasi2.Ac02
         WHERE aac031 = '1'
           AND (aae140 = '02' OR aae140 = '03' OR aae140 = '04' OR aae140 = '05' )
           AND aab001 = var_aab001
           AND aac001 = var_aac001
           AND ROWNUM = 1;


          --������������
          UPDATE wsjb.tmp_irac01a4
             SET yac005 = ROUND(num_yac005),
                 yaa333 = ROUND(num_yac005)
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;


        --�����α������ֱ���ɼ���
        IF rec_tmp_irac01a4.aae210 = '2' THEN
          UPDATE wsjb.tmp_irac01a4
             SET aae210 = '3'
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;
        END IF;
        IF rec_tmp_irac01a4.aae310 = '2' THEN
          UPDATE wsjb.tmp_irac01a4
             SET aae310 = '3'
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;
        END IF;
        IF rec_tmp_irac01a4.aae410 = '2' THEN
          UPDATE wsjb.tmp_irac01a4
             SET aae410 = '3'
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;
        END IF;
        IF rec_tmp_irac01a4.aae510 = '2' THEN
          UPDATE wsjb.tmp_irac01a4
             SET aae510 = '3'
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;
        END IF;
        IF rec_tmp_irac01a4.aae311 = '2' THEN
          UPDATE wsjb.tmp_irac01a4
             SET aae311 = '3'
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;
        END IF;
        IF rec_tmp_irac01a4.aae810 = '2' THEN
          UPDATE wsjb.tmp_irac01a4
             SET aae810 = '3'
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;
        END IF;

     END IF;
     UPDATE wsjb.tmp_irac01a4  SET iaa100=''
            WHERE aac001 = var_aac001
           AND aab001 = var_aab001;
     /*����ʧ��*/
      <<label_ERROR>>
        num_count :=0;

  EXCEPTION
     WHEN OTHERS THEN
          /*�رմ򿪵��α�*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '���ݿ����'|| SQLERRM ;

          RETURN;
  END prc_p_ValidateReduceCheck;
  /*--------------------------------------------------------------------------
   || ҵ�񻷽� ����Ա������ͣ�ɷ�������֤
   || �������� prc_p_ValidateKindAddCheck
   || �������� ��У�����Ա��Ϣ
   ||
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��zhujing         ������� ��2015-11-24
   ||------------------------------------------------------------------------*/
  PROCEDURE prc_p_ValidateBatchReduceCheck(
      prm_iaz018          IN            VARCHAR2,     --���κ�
      prm_yab139          IN            VARCHAR2,     --�������
      prm_msg             OUT           VARCHAR2,     -- ������Ϣ
      prm_sign            OUT           VARCHAR2,     -- �����־
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2)    --������Ϣ
   IS
   num_count        NUMBER(6);
   rec_tmp_irac01a4 tmp_irac01a4%ROWTYPE;
   dat_aac006       DATE ;--��������
   dat_aac007       DATE ;--�ι�����
   dat_aac030       DATE ;--��ϵͳ�α�����
   dat_yac033       DATE ;--���˳��βα�����
   var_aab001       irac01.aab001%TYPE;
   var_aae140       irab02.aae140%TYPE;
   num_aac040       NUMBER(14,2); --�ɷѹ���
   num_yac004       NUMBER(14,2); --���ϻ���
   num_yac005       NUMBER(14,2); --��������
   var_iaa100       VARCHAR2(6);  --�걨�¶�
   var_aac001       irac01.aac001%TYPE;
   var_aac009       irac01.aac009%TYPE;  --��������
   var_yae181       irac01.yae181%TYPE;
   var_aac004       irac01.aac004%TYPE;
   var_yac168       irac01.yac168%TYPE;


   var_aae110       irac01.aae110%TYPE;--ְ������
   var_aae120       irac01.aae120%TYPE;--��������
   var_aae210       irac01.aae210%TYPE;--ʧҵ
   var_aae310       irac01.aae310%TYPE;--ҽ��
   var_aae410       irac01.aae410%TYPE;--����
   var_aae510       irac01.aae510%TYPE;--����
   var_aae311       irac01.aae311%TYPE;--���
   var_aae810       irac01.aae810%TYPE;--����Ա����

   cursor cur_tmp_irac01a4 IS
   SELECT iaz018,
          iaa001,
          iaa002,
          aac001,
          aab001,
          yae181,
          yac067,
          aac002,
          aac003,
          aac004,
          aac005,
          aac006,
          aac007,
          aac008,
          aac009,
          aac010,
          aac011,
          aac012,
          aac013,
          aac014,
          aac015,
          aac020,
          yac168,
          yac197,
          yac501,
          yac170,
          yac502,
          yae407,
          yae496,
          yic067,
          aae004,
          aae005,
          aae006,
          aae007,
          yae222,
          yac200,
          aae110,
          aac031,
          yac505,
          yac033,
          aac030,
          yae102,
          yae097,
          yac503,
          aac040,
          yac004,
          yaa333,
          yab013,
          yac002,
          yab139,
          aae011,
          aae036,
          yab003,
          aae013,
          aaz002,
          aae120,
          aae210,
          aae310,
          aae410,
          aae510,
          aae311,
          akc021,
          ykc150,
          ykb109,
          aic162,
          yac005,
          aae100,
          errormsg,
          aac021,
          aac022,
          aac025,
          aac026,
          aae810,
          iaa100,
          aae009,
          aae008,
          aae010,
          yad050
     FROM wsjb.tmp_irac01a4
    WHERE iaz018 = prm_iaz018;


   BEGIN
   /*��ʼ������*/
     prm_AppCode  := GN_DEF_OK;
     prm_ErrorMsg := '';
     prm_msg :='';
     prm_sign :='0';
    --У�����
    IF prm_iaz018 IS NULL  THEN
      prm_AppCode  := GN_DEF_ERR;
      prm_ErrorMsg :=  prm_msg||'����У����ˮ��iaz018Ϊ�գ����ʵ������';
      RETURN;
    END IF;
    FOR rec_tmp_irac01a4 IN cur_tmp_irac01a4 LOOP
    --����У���Ƿ�ͨ��
     IF rec_tmp_irac01a4.errormsg IS NOT  NULL  THEN
       prm_sign := '1';
       prm_msg := rec_tmp_irac01a4.errormsg;
       GOTO label_ERROR;
      RETURN;
    END IF;
     --��ѯ���˱��
     SELECT count(1)
        INTO num_count
        FROM xasi2.ac01
       WHERE aac002 = rec_tmp_irac01a4.aac002
         AND aac003 = rec_tmp_irac01a4.aac003
         AND aae120 = '0';
     IF num_count <> 1 THEN
        prm_msg :=  prm_msg||rec_tmp_irac01a4.aac002||'��Ա��Ϣû���ҵ�����˶���Ϣ��';
       prm_sign := '1';
       GOTO label_ERROR;
     END IF ;
      SELECT aac001
        INTO var_aac001
        FROM xasi2.ac01
       WHERE aac002 = rec_tmp_irac01a4.aac002
         AND aac003 = rec_tmp_irac01a4.aac003;

      UPDATE wsjb.tmp_irac01a4
         SET aac001 = var_aac001
       WHERE iaz018 = prm_iaz018
         AND aac002 = rec_tmp_irac01a4.aac002
         AND aac003 = rec_tmp_irac01a4.aac003;

     var_aab001 := rec_tmp_irac01a4.aab001;

      --��ѯ�α���Ϣ
      SELECT count(1)
        INTO num_count
        FROM xasi2.AC01 A, xasi2.AC02 B
       WHERE A.AAC001 = B.AAC001
         AND A.AAC008 = '1'
         AND B.AAC031 = '1'
         AND B.AAB001 = var_aab001
         AND A.AAC001 = var_aac001;
      IF num_count > 0 THEN
        SELECT DISTINCT a.YAE181 AS YAE181,
                        a.aac004 as aac004,
                        a.aac009 as aac009,
                        a.yac168 as yac168,
                        (SELECT AAE110
                           FROM wsjb.irac01a3
                          WHERE AAC001 = A.AAC001
                            AND AAB001 = var_aab001) AAE110,
                        (SELECT DECODE(AAC031, '1', '2', '2', '21', '3', '')
                           FROM xasi2.AC02
                          WHERE AAC001 = A.AAC001
                            AND AAB001 = var_aab001
                            AND AAE140 = '06') AAE120,
                        (SELECT DECODE(AAC031, '1', '2', '2', '21', '3', '')
                           FROM xasi2.AC02
                          WHERE AAC001 = A.AAC001
                            AND AAB001 = var_aab001
                            AND AAE140 = '02') AAE210,
                        (SELECT DECODE(AAC031, '1', '2', '2', '21', '3', '')
                           FROM xasi2.AC02
                          WHERE AAC001 = A.AAC001
                            AND AAB001 = var_aab001
                            AND AAE140 = '03') AAE310,
                        (SELECT DECODE(AAC031, '1', '2', '2', '21', '3', '')
                           FROM xasi2.AC02
                          WHERE AAC001 = A.AAC001
                            AND AAB001 = var_aab001
                            AND AAE140 = '04') AAE410,
                        (SELECT DECODE(AAC031, '1', '2', '2', '21', '3', '')
                           FROM xasi2.AC02
                          WHERE AAC001 = A.AAC001
                            AND AAB001 = var_aab001
                            AND AAE140 = '05') AAE510,
                        (SELECT DECODE(AAC031, '1', '2', '2', '21', '3', '')
                           FROM xasi2.AC02
                          WHERE AAC001 = A.AAC001
                            AND AAB001 = var_aab001
                            AND AAE140 = '07') AAE311,
                        (SELECT DECODE(AAC031, '1', '2', '2', '21', '3', '')
                           FROM xasi2.AC02
                          WHERE AAC001 = A.AAC001
                            AND AAB001 = var_aab001
                            AND AAE140 = '08') AAE810
          INTO
                var_yae181,
                var_aac004,
                var_aac009,
                var_yac168,
                var_aae110,
                var_aae120,
                var_aae210,
                var_aae310,
                var_aae410,
                var_aae510,
                var_aae311,
                var_aae810
          FROM xasi2.AC01 A, xasi2.AC02 B
         WHERE A.AAC001 = B.AAC001
           AND B.AAB001 = var_aab001
           AND B.AAC031 = '1'
           AND A.AAC008 = '1'
           AND A.AAC001 = var_aac001;
      ELSE
        SELECT count(1)
          INTO num_count
          FROM xasi2.AC01 A, wsjb.irac01a3  B
         WHERE A.AAC001 = B.AAC001
           AND A.AAC008 = '1'
           AND B.AAE110 = '2'
           AND B.AAB001 = var_aab001
           AND A.AAC001 = var_aac001;
        IF num_count = 1 THEN
          select DISTINCT a.YAE181 AS YAE181,
                          a.aac004 as aac004,
                          a.aac009 as aac009,
                          a.yac168 as yac168,
                          b.aae110 as aae110,
                          '0' as aae120,
                          '0' as aae210,
                          '0' as aae310,
                          '0' as aae410,
                          '0' as aae510,
                          '0' as aae311,
                          '0' as aae810
                    INTO  var_yae181,
                          var_aac004,
                          var_aac009,
                          var_yac168,
                          var_aae110,
                          var_aae120,
                          var_aae210,
                          var_aae310,
                          var_aae410,
                          var_aae510,
                          var_aae311,
                          var_aae810
                     from xasi2.ac01 a,wsjb.irac01a3  b
                    where  a.aac001 = b.aac001
                      and b.aab001 = var_aab001
                      and b.aae110 = '2'
                      and a.aac008 = '1'
                      and a.aac001 = var_aac001;
        ELSE
          prm_msg :=  prm_msg||rec_tmp_irac01a4.aac002||'��Աû�вα����֣�';
          prm_sign := '1';
          GOTO label_ERROR;
        END IF;

      END IF;
      --����У���Ҫ��Ϣ
      UPDATE wsjb.tmp_irac01a4
         SET yae181 = var_yae181,
             aac004 = var_aac004,
             aac009 = var_aac009,
             yac168 = var_yac168,
             aae110 = var_aae110,
             aae120 = var_aae120,
             aae210 = var_aae210,
             aae310 = var_aae310,
             aae410 = var_aae410,
             aae510 = var_aae510,
             aae311 = var_aae311,
             aae810 = var_aae810
       WHERE iaz018 = prm_iaz018
         AND aac001 =var_aac001;

      prc_p_ValidateReduceCheck(prm_iaz018  ,     --���κ�
                                 var_aac001  ,     --���˱��
                                prm_yab139  ,     --�������
                                prm_msg     ,     -- ������Ϣ
                                prm_sign    ,     -- �����־
                                prm_AppCode ,     --ִ�д���
                                prm_ErrorMsg);    --������Ϣ
      IF prm_sign <> '0' THEN
          prm_msg :=  prm_msg;
          prm_sign := '1';
          GOTO label_ERROR;
      END IF;

    <<label_ERROR>>
    UPDATE wsjb.tmp_irac01a4
       SET aae100 = '1',
           errormsg = prm_msg
     WHERE iaz018 = prm_iaz018
       AND aac002 = rec_tmp_irac01a4.aac002
       AND aac003 = rec_tmp_irac01a4.aac003;

    END LOOP;

  EXCEPTION
     WHEN OTHERS THEN
          /*�رմ򿪵��α�*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '���ݿ����'|| SQLERRM ;
          RETURN;
  END prc_p_ValidateBatchReduceCheck;
 /*--------------------------------------------------------------------------
   || ҵ�񻷽� ����Ա��ְת���˱���������֤
   || �������� prc_p_ValidateRetireCheck
   || �������� ��У�����Ա��Ϣ
   ||
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��zhujing         ������� ��2015-11-24
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateRetireCheck(
       prm_iaz018          IN            VARCHAR2,     --���κ�
       prm_aac001          IN            VARCHAR2,     --���˱��
      prm_yab139          IN            VARCHAR2,     --�������
      prm_msg             OUT           VARCHAR2,     -- ������Ϣ
      prm_sign            OUT           VARCHAR2,     -- �����־
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2)    --������Ϣ
  IS
   num_count        NUMBER(6);
   rec_tmp_irac01a2 tmp_irac01a2%ROWTYPE;
   dat_aac006       DATE ;--��������
   dat_aac007       DATE ;--�ι�����
   dat_aac030       DATE ;--��ϵͳ�α�����
   dat_yac033       DATE ;--���˳��βα�����
   var_aab001       irac01.aab001%TYPE;
   var_aae140       irab02.aae140%TYPE;
   num_aac040       NUMBER(14,2); --�ɷѹ���
   num_yac004       NUMBER(14,2); --���ϻ���
   num_yac005       NUMBER(14,2); --��������
   var_iaa100       VARCHAR2(6);  --�걨�¶�
   var_aac001       irac01.aac001%TYPE;
   var_aac009       irac01.aac009%TYPE;  --��������
   BEGIN
   /*��ʼ������*/
     prm_AppCode  := GN_DEF_OK;
     prm_ErrorMsg := '';
     prm_msg :='';
     prm_sign :='0';
       --У�����
    IF prm_iaz018 IS NULL  THEN
      prm_msg :=  prm_msg||'����У����ˮ��Ϊ�գ����ʵ������';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
     --У�����
    IF prm_aac001 IS NULL  THEN
      prm_msg :=  prm_msg||'������˱��Ϊ�գ����ʵ������';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

      SELECT *
     INTO rec_tmp_irac01a2
     FROM wsjb.tmp_irac01a2
    WHERE iaz018 = prm_iaz018
      AND aac001 = prm_aac001;


    var_aab001 := rec_tmp_irac01a2.aab001;
    var_aac001 := prm_aac001;

    dat_aac030 := rec_tmp_irac01a2.aac030;
    var_iaa100 := rec_tmp_irac01a2.iaa100;

    IF dat_aac030 > SYSDATE THEN
      prm_msg :=  prm_msg||'ͣ�����ڲ�������ϵͳ����'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) > TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'ͣ�����ڲ������ڵ�ǰ���걨�¶�'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) <> TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'ͣ���¶Ⱥ��걨�¶Ȳ�һ��'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --�Ƿ��Ѿ������걨��¼
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '0'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'����Ա�Ѵ��ڴ��걨��Ϣ!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --�Ƿ��Ѿ������걨��¼
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '1'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'����Ա�Ѵ����걨��Ϣ!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
  --�Ƿ��Ѿ������걨��¼
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '4'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'����Ա�Ѵ��ڴ�ص��걨��Ϣ���뵽���걨�����²����������������˲�����';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --�Ƿ��Ѿ������걨��¼

    IF rec_tmp_irac01a2.aae013 <> '251' THEN
      prm_msg :=  prm_msg||'��Աͣ��ԭ��Ϊ��ְת���ˣ����飡';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;


   --��ͣ�ɷѻ���
    IF rec_tmp_irac01a2.aae110 = '2' THEN
        SELECT yac004
          INTO num_yac004
          FROM wsjb.irac01a3
         WHERE aac001 = var_aac001
           AND aab001 = var_aab001
           AND aae110 = '2';


          --��ҵ���ϻ�������
          UPDATE wsjb.tmp_irac01a2
             SET yac004 = ROUND(num_yac004),
                 aae110 = '3'
           WHERE iaz018 = prm_iaz018;


     END IF;

     IF rec_tmp_irac01a2.aae120 = '2' THEN
        SELECT yac004
          INTO num_yac004
          FROM xasi2.ac02
         WHERE aac001 = var_aac001
           AND aab001 = var_aab001
           AND aac031 = '1';

          --�������ϻ�������
          UPDATE wsjb.tmp_irac01a2
             SET yac004 = num_aac040,
                 aae120 = '3'
           WHERE iaz018 = prm_iaz018;


     END IF;

     IF rec_tmp_irac01a2.aae210 = '2' OR
        rec_tmp_irac01a2.aae310 = '2' OR
        rec_tmp_irac01a2.aae410 = '2' OR
        rec_tmp_irac01a2.aae510 = '2' OR
        rec_tmp_irac01a2.aae311 = '2' OR
        rec_tmp_irac01a2.aae810 = '2' THEN
        --��һ������Ϊ׼
        SELECT yac004
          INTO num_yac005
          FROM xasi2.Ac02
         WHERE aac031 = '1'
           AND (aae140 = '02' OR aae140 = '03' OR aae140 = '04' OR aae140 = '05' )
           AND aab001 = var_aab001
           AND aac001 = var_aac001
           AND ROWNUM = 1;


          --������������
          UPDATE wsjb.tmp_irac01a2
             SET yac005 = ROUND(num_yac005),
                 yaa333 = ROUND(num_yac005)
           WHERE iaz018 = prm_iaz018;


        --�����α������ֱ���ɼ���
        IF rec_tmp_irac01a2.aae210 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae210 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae310 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae310 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae410 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae510 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae510 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae311 = '2' THEN --��ͣ��
          UPDATE wsjb.tmp_irac01a2
             SET aae311 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae810 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae810 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;

     /*����ʧ��*/
      <<label_ERROR>>
        num_count :=0;

  EXCEPTION
     WHEN OTHERS THEN
          /*�رմ򿪵��α�*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '���ݿ����'|| SQLERRM ;
          RETURN;
  END prc_p_ValidateRetireCheck;
   /*--------------------------------------------------------------------------
   || ҵ�񻷽� ��������Ա��������������֤
   || �������� prc_p_ValidateDeathCheck
   || �������� ��У�����Ա��Ϣ
   ||
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��zhujing         ������� ��2015-11-24
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateDeathCheck(
       prm_iaz018          IN            VARCHAR2,     --���κ�
       prm_aac001          IN            VARCHAR2,     --���˱��
      prm_yab139          IN            VARCHAR2,     --�������
      prm_msg             OUT           VARCHAR2,     -- ������Ϣ
      prm_sign            OUT           VARCHAR2,     -- �����־
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2)    --������Ϣ
  IS
   num_count        NUMBER(6);
   rec_tmp_irac01a2 tmp_irac01a2%ROWTYPE;
   dat_aac006       DATE ;--��������
   dat_aac007       DATE ;--�ι�����
   dat_aac030       DATE ;--��ϵͳ�α�����
   dat_yac033       DATE ;--���˳��βα�����
   var_aab001       irac01.aab001%TYPE;
   var_aae140       irab02.aae140%TYPE;
   num_aac040       NUMBER(14,2); --�ɷѹ���
   num_yac004       NUMBER(14,2); --���ϻ���
   num_yac005       NUMBER(14,2); --��������
   var_iaa100       VARCHAR2(6);  --�걨�¶�
   var_aac001       irac01.aac001%TYPE;
   var_aac009       irac01.aac009%TYPE;  --��������
   BEGIN
   /*��ʼ������*/
     prm_AppCode  := GN_DEF_OK;
     prm_ErrorMsg := '';
     prm_msg :='';
     prm_sign :='0';
       --У�����
    IF prm_iaz018 IS NULL  THEN
      prm_msg :=  prm_msg||'����У����ˮ��Ϊ�գ����ʵ������';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
     --У�����
    IF prm_aac001 IS NULL  THEN
      prm_msg :=  prm_msg||'������˱��Ϊ�գ����ʵ������';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

      SELECT *
     INTO rec_tmp_irac01a2
     FROM wsjb.tmp_irac01a2
    WHERE iaz018 = prm_iaz018
      AND aac001 = prm_aac001;


    var_aab001 := rec_tmp_irac01a2.aab001;
    var_aac001 := prm_aac001;

    dat_aac030 := rec_tmp_irac01a2.aac030;
    var_iaa100 := rec_tmp_irac01a2.iaa100;

    IF dat_aac030 > SYSDATE THEN
      prm_msg :=  prm_msg||'ͣ�����ڲ�������ϵͳ����'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) > TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'ͣ�����ڲ������ڵ�ǰ���걨�¶�'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) <> TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'ͣ���¶Ⱥ��걨�¶Ȳ�һ��'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --�Ƿ��Ѿ������걨��¼
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '0'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'����Ա�Ѵ��ڴ��걨��Ϣ!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --�Ƿ��Ѿ������걨��¼
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '1'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'����Ա�Ѵ����걨��Ϣ!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
  --�Ƿ��Ѿ������걨��¼
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '4'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'����Ա�Ѵ��ڴ�ص��걨��Ϣ���뵽���걨�����²����������������˲�����';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --�Ƿ��Ѿ������걨��¼

    IF rec_tmp_irac01a2.aae013 <> '211' THEN
      prm_msg :=  prm_msg||'��Աͣ��ԭ��Ϊ��ְ��Ա���������飡';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;


   --��ͣ�ɷѻ���
    IF rec_tmp_irac01a2.aae110 = '2' THEN
        SELECT yac004
          INTO num_yac004
          FROM wsjb.irac01a3
         WHERE aac001 = var_aac001
           AND aab001 = var_aab001
           AND aae110 = '2';


          --��ҵ���ϻ�������
          UPDATE wsjb.tmp_irac01a2
             SET yac004 = ROUND(num_yac004),
                 aae110 = '3'
           WHERE iaz018 = prm_iaz018;


     END IF;

     IF rec_tmp_irac01a2.aae120 = '2' THEN
        SELECT yac004
          INTO num_yac004
          FROM xasi2.ac02
         WHERE aac001 = var_aac001
           AND aab001 = var_aab001
           AND aac031 = '1';

          --�������ϻ�������
          UPDATE wsjb.tmp_irac01a2
             SET yac004 = num_aac040,
                 aae120 = '3'
           WHERE iaz018 = prm_iaz018;


     END IF;

     IF rec_tmp_irac01a2.aae210 = '2' OR
        rec_tmp_irac01a2.aae310 = '2' OR
        rec_tmp_irac01a2.aae410 = '2' OR
        rec_tmp_irac01a2.aae510 = '2' OR
        rec_tmp_irac01a2.aae311 = '2' OR
        rec_tmp_irac01a2.aae810 = '2' THEN
        --��һ������Ϊ׼
        SELECT yac004
          INTO num_yac005
          FROM xasi2.Ac02
         WHERE aac031 = '1'
           AND (aae140 = '02' OR aae140 = '03' OR aae140 = '04' OR aae140 = '05' )
           AND aab001 = var_aab001
           AND aac001 = var_aac001
           AND ROWNUM = 1;


          --������������
          UPDATE wsjb.tmp_irac01a2
             SET yac005 = ROUND(num_yac005),
                 yaa333 = ROUND(num_yac005)
           WHERE iaz018 = prm_iaz018;


        --�����α������ֱ���ɼ���
        IF rec_tmp_irac01a2.aae210 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae210 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae310 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae310 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae410 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae510 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae510 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae311 = '2' THEN --���ͣ��
          UPDATE wsjb.tmp_irac01a2
             SET aae311 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae810 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae810 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;

     /*����ʧ��*/
      <<label_ERROR>>
        num_count :=0;

  EXCEPTION
     WHEN OTHERS THEN
          /*�رմ򿪵��α�*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '���ݿ����'|| SQLERRM ;
          RETURN;
  END prc_p_ValidateDeathCheck;
   /*****************************************************************************
   ** �������� : prc_batchImportView
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �������²α�����Ԥ��
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001     IN     irab01.aab001%TYPE,--��λ���
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-17   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_batchImportView(prm_aab001     IN     irac01.aab001%TYPE,--��λ���
                                 prm_iaa100     IN     irac01.iaa100%TYPE,--�걨�¶�
                                  prm_iaz018     IN     irac01a2.iaz018%TYPE,  --������������ID
                                  prm_yab139     IN     irac01.yab139%TYPE,--��������
                                  prm_AppCode    OUT    VARCHAR2  ,
                                  prm_ErrorMsg   OUT    VARCHAR2 )

   IS
      n_count    number(5);
      v_aac003    irac01.aac003%TYPE;
      v_aac031   irac01.aac031%TYPE;
      v_iac001   irac01.iac001%TYPE;
      v_aac001   irac01.aac001%TYPE;
      v_aab001   irac01.aab001%TYPE;
      v_aab004   irab01.aab004%TYPE;
      var_flag   number(1);
      v_aac002   irac01.aac002%TYPE;
      v_aac002_l irac01.aac002%TYPE;
      v_aac002_u irac01.aac002%TYPE;
      v_aac002d  irac01.aac002%TYPE;
      d_aac006    DATE;
      v_aac004   irac01.aac004%TYPE;
      v_aae110   irac01.aae110%TYPE;
      v_aae120   irac01.aae120%TYPE;
      v_aae210   irac01.aae210%TYPE;
      v_aae310   irac01.aae310%TYPE;
      v_aae410   irac01.aae410%TYPE;
      v_aae510   irac01.aae510%TYPE;
      v_aae311   irac01.aae311%TYPE;
      v_aae810   irac01.aae810%TYPE;
      v_message  varchar2(3000);
      v_yac168   irac01.yac168%TYPE;
      num_aac040 NUMBER(14,2);
      num_yac004 NUMBER(14,2);
      num_yac005 NUMBER(14,2);
      var_aae140 irab02.aae140%TYPE;
     sj_acount  NUMBER;
     sj_count   NUMBER;
     sj_count1  NUMBER;
     count_jm   NUMBER;
     v_aac012   irac01.aac012%TYPE;
     v_aac008   irac01.aac012%TYPE;
     dat_aac006  irac01.aac006%TYPE;
     dat_yearAge      DATE;  --��������
      dat_AAE030     DATE;--����ʱ�� 20190808

    
      CURSOR impCur IS
             SELECT
              iaz018,
              iaa001,
              iaa002,
              aac001,
              aab001,
              yae181,
              yac067,
              aac002,
              aac003,
              aac004,
              aac005,
              aac006,
              aac007,
              aac008,
              aac009,
              aac010,
              aac011,
              aac021,
              aac022,
              aac025,--
              aac026,--
              aac012,
              aac013,
              aac014,
              aac015,
              aac020,
              yac168,
              yac197,
              yac501,
              yac170,
              yac502,
              yae407,
              yae496,
              yic067,
              aae004,
              aae005,
              aae006,
              aae007,
              yae222,
              yac200,
              aae110,
              aac031,
              yac505,
              yac033,
              aac030,
              yae102,
              yae097,
              yac503,
              aac040,
              yac004,
              yaa333,
              yab013,
              yac002,
              yab139,
              aae011,
              aae036,
              yab003,
              aae013,
              aae120,
              aae210,
              aae310,
              aae410,
              aae510,
              aae311,
              aae810,
              akc021,
              ykc150,
              ykb109,
              aic162,
              yac005,
              aae100,
              errormsg
             FROM IRAC01A2
             WHERE iaz018 = prm_iaz018;

   BEGIN
     /*��ʼ������*/
     prm_AppCode  := PKG_Constant.GN_DEF_OK;
    prm_ErrorMsg := '';
     n_count := 0;
     /*�����п�*/
     IF prm_aab001 IS NULL THEN
        prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := 'û�л�ȡ����λ��ţ�';
       RETURN;
    END IF;


     --�ж��Ƿ���ڸõ�λ
     SELECT COUNT(1)
       into n_count
       FROM wsjb.irab01
       WHERE iab001 = prm_aab001;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '��λ���Ϊ['|| prm_aab001 ||']�ĵ�λ��Ϣ������!';
       RETURN;
    END IF;

    --�ж��Ƿ��������������Ϣ
    SELECT COUNT(1)
      INTO  n_count
      FROM IRAC01A2
     WHERE iaz018 = prm_iaz018;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '��������IDΪ['|| prm_iaz018 ||']����Ϣ������!';
       RETURN;
    END IF;


    --ѭ��������ȡ����
    FOR REC_TMP_PERSON IN impCur LOOP

      --��ʼ����־λ
       var_flag := 0;
       v_message := '';
       -- У��ɲ�����
       v_aac012 := REC_TMP_PERSON.Aac012; 
       v_aac008 := REC_TMP_PERSON.aac008;
       v_aac004 := REC_TMP_PERSON.aac004;
       dat_aac006 := REC_TMP_PERSON.aac006;--��������
       
       /**���Ͻӿ�У���Ƿ�ͨ��**/
       IF REC_TMP_PERSON.aae100 ='0' AND REC_TMP_PERSON.errormsg IS NOT NULL THEN
       v_message := REC_TMP_PERSON.errormsg;
       var_flag  := 1;
       END IF;
      /**��������**/
      --���֤�ǿ�У��
       IF REC_TMP_PERSON.aac002 IS NULL THEN
         v_message := v_message||'���֤���벻��Ϊ�գ�';
         var_flag  := 1;
       END IF;
      --���֤λ������
       IF LENGTH(trim(REC_TMP_PERSON.aac002)) = 18  THEN
          xasi2.pkg_P_Comm_CZ.prc_P_getID( UPPER(REC_TMP_PERSON.aac002),   --�������֤
                                  v_aac002,   --�������֤
                                  prm_AppCode,   --�������
                                  prm_ErrorMsg) ;  --��������
          IF prm_AppCode <> PKG_Constant.GN_DEF_OK THEN
              v_message :=  v_message||prm_ErrorMsg;
              prm_AppCode := PKG_Constant.GN_DEF_OK;
              prm_ErrorMsg := '';
              var_flag :=1;
          END IF;

          SELECT  substr(trim(REC_TMP_PERSON.aac002),1,6) || substr(trim(REC_TMP_PERSON.aac002),9,9)
            INTO v_aac002d
            FROM dual;

          SELECT  UPPER(v_aac002)
            INTO  v_aac002_u
            FROM  dual;

          SELECT  LOWER(v_aac002)
            INTO  v_aac002_l
            FROM  dual;
--       ElSIF LENGTH(trim(REC_TMP_PERSON.aac002)) = 15 THEN
--               xasi2.pkg_P_Comm_CZ.prc_P_getID( UPPER(REC_TMP_PERSON.aac002),   --�������֤
--                                       v_aac002,   --�������֤
--                                       prm_AppCode,   --�������
--                                       prm_ErrorMsg) ;  --��������
--               IF prm_AppCode <> PKG_Constant.GN_DEF_OK THEN
--                   v_message :=  v_message||prm_ErrorMsg;
--                   prm_AppCode := PKG_Constant.GN_DEF_OK;
--                   prm_ErrorMsg := '';
--                   var_flag :=1;
--               END IF;
--            SELECT  UPPER(v_aac002)
--            INTO  v_aac002_u
--            FROM  dual;
--
--          SELECT  LOWER(v_aac002)
--            INTO  v_aac002_l
--            FROM  dual;
--              v_aac002d := trim(REC_TMP_PERSON.aac002);
       ELSE
             v_message := v_message||REC_TMP_PERSON.aac002||'���֤λ�����Ϸ�;';
             var_flag   := 1;
       END IF;

      --����Ƿ�����ظ���ݺ���
      select count(1)
        into n_count
        from IRAC01A2
       where iaz018 = prm_iaz018
         and aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d);
      IF n_count > 1 THEN
         v_message := v_message||'�������������֤�������ظ�;';
         var_flag   := 1;
      END IF;


      --18λ���֤���Ƿ��²α�У��(����)
      SELECT COUNT(1)
        INTO n_count
        FROM xasi2.ac01 a
       WHERE a.aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
         AND a.aae120 = '0'
         AND a.aac003 NOT LIKE '%�ظ�%';
        IF n_count >1 THEN
           v_message := '�����֤���Ѿ����ڶ��ҽ����ţ������²α���';
           var_flag :='1';
           GOTO label_ERROR ;
        END IF;
             
       -- begin 20190708 wangz ���� ��λ ����
        IF v_aac008 = '1' THEN

         IF v_aac004 = '1' THEN --�� 60��
           dat_yearAge := ADD_MONTHS(dat_aac006,60*12);
         ELSIF v_aac004 = '2' AND v_aac012 = '4' THEN --Ů�ɲ� 55��
           dat_yearAge := ADD_MONTHS(dat_aac006,55*12);
         ELSIF v_aac004 = '2' AND v_aac012 = '1' THEN --Ů���� 50��
           dat_yearAge := ADD_MONTHS(dat_aac006,50*12);
         ELSE
           v_message := '�Ա��ȡʧ��';
           var_flag := '1';
           GOTO label_ERROR;
         END IF;
         IF dat_yearAge < SYSDATE THEN
           v_message :=  v_message||'���ã���Ա���ѳ����������䣬���ʵ����������Ϊ���˽�����ᱣ�ա�ȷ��������������ṩ���˵���������籣����������˴��ڱ���!';
            var_flag := '1';
           GOTO label_ERROR;
         END IF;

     END IF;
        
        
        
    -- end 20190708 wangz
        
        IF n_count =1 THEN
         SELECT AAC001
           INTO v_aac001
           FROM XASI2.AC01
          WHERE AAE120 = '0'
            AND aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
            AND AAC003 NOT LIKE '%�ظ�%';
         SELECT COUNT(1)
        INTO COUNT_JM
        FROM XASI2.AC02K1
       WHERE AAC001 = v_aac001
         AND AAC031 = '1';
      IF COUNT_JM > 0 THEN
       SELECT AAB004
         INTO V_AAB004
         FROM XASI2.AB01
        WHERE AAB001 = (SELECT aab001
                          FROM XASI2.AC02K1
                         WHERE AAC001 = v_aac001
                           AND AAC031 = '1');
        v_message  := V_MESSAGE ||'�����֤������Աҽ�Ʊ��չ�ϵĿǰ��������' || V_AAB004 || '�μӾ���ҽ��������:'  ||'���˱�ţ�'||v_aac001|| ',�α�״̬:�α��ɷѡ�';
        var_flag := '1';
      END IF;

        SELECT aac001,
                    aac003
               INTO v_aac001,
                    v_aac003
               FROM xasi2.ac01
              WHERE AAE120 = '0'
              AND aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
              AND AAC003 NOT LIKE '%�ظ�%';
        BEGIN
          SELECT AAB001, AAC031
            INTO V_AAB001, V_AAC031
            FROM XASI2.AC02
           WHERE AAC001 = V_AAC001
             AND AAE140 = '03';
        EXCEPTION
          WHEN OTHERS THEN
            BEGIN
              SELECT AAB001, AAC031
                INTO V_AAB001, V_AAC031
                FROM XASI2.AC02
               WHERE AAC001 = V_AAC001
                 AND AAE140 = '02';
            EXCEPTION
              WHEN OTHERS THEN
                BEGIN
                  SELECT AAB001, AAC031
                    INTO V_AAB001, V_AAC031
                    FROM XASI2.AC02
                   WHERE AAC001 = V_AAC001
                     AND AAE140 = '05';
                EXCEPTION
                  WHEN OTHERS THEN
                    BEGIN
                      SELECT AAB001, AAC031
                        INTO V_AAB001, V_AAC031
                        FROM XASI2.AC02
                       WHERE AAC001 = V_AAC001
                         AND AAE140 = '04';
                    EXCEPTION
                      WHEN OTHERS THEN
                        NULL;
                    END;
                END;
            END;
        END;

        IF V_AAC031 = '1' THEN
          V_AAC031 := '�α��ɷ�';
        ELSIF V_AAC031 = '2' THEN
          V_AAC031 := '��ͣ�ɷ�';
        ELSIF V_AAC031 = '3' THEN
          V_AAC031 := '��ֹ�ɷ�';
        END IF;
          --  ���� V_AAB001  �Ƿ����
        IF  V_AAB001 IS NOT NULL OR V_AAB001 != '' THEN


          SELECT AAB004
            INTO V_AAB004
            FROM XASI2.AB01
          WHERE AAB001 = V_AAB001;

          V_MESSAGE := V_MESSAGE || '��Ա�²α��Ǽ���֤��ͨ���������֤������Աҽ�Ʊ��չ�ϵĿǰ�ڵ�λ���ƣ�' ||
                       V_AAB004 || ',�α�������' || V_AAC003 || ',�α�״̬:' ||
                       V_AAC031 || '��';
          VAR_FLAG  := 1;
           END IF;
        END IF;
        
   
        
        
        
        
        
        
        
        
        --18λ���֤���Ƿ��²α�У��(�о�)
      /*SELECT count(1)
           INTO sj_acount
           FROM sjxt.ac01
            WHERE aac002 = REC_TMP_PERSON.aac002;
         IF sj_acount=1 THEN
         SELECT aac001,aac003 INTO v_aac001,v_aac003 FROM sjxt.ac01 WHERE aac002 = REC_TMP_PERSON.aac002;
         SELECT count(DISTINCT aab001) INTO sj_count FROM sjxt.ac02 WHERE aac001 = v_aac001 AND aac031='1';
         IF sj_count > 0 THEN
          SELECT aab001,aac031 INTO v_aab001,v_aac031 FROM sjxt.ac02 WHERE aac001 = v_aac001 and aac031='1' AND ROWNUM =1;
          IF v_aac031='1' THEN
             v_aac031 :='�α��ɷ�';
         ELSIF v_aac031='2' THEN
             v_aac031 :='��ͣ�ɷ�';
         ELSIF v_aac031='3' THEN
             v_aac031 :='��ֹ�ɷ�';
         END IF;
         IF v_aab001 IS NOT NULL THEN
          BEGIN
         SELECT aab004 INTO v_aab004 FROM sjxt.ab01 WHERE aab001 = v_aab001;
           EXCEPTION
             WHEN OTHERS THEN
              BEGIN
                v_aab004 :='';
                END;
                END;
         END IF;
                v_message := v_message|| '��Ա�²α��Ǽ���֤��ͨ���������֤������Աҽ�Ʊ��չ�ϵĿǰ���������籣����,����'||v_aac003||',��λ���ƣ�'||v_aab004||'�α����α�״̬:'||v_aac031||'��';
               var_flag :='1';
          ELSIF sj_count = 0 THEN
          SELECT count(DISTINCT aab001) INTO sj_count1 FROM sjxt.ac02 WHERE aac001 = v_aac001 AND aac031='2';
          IF sj_count1 > 0 THEN
           SELECT aab001,aac031 INTO v_aab001,v_aac031 FROM sjxt.ac02 WHERE aac001 = v_aac001 and aac031='2' AND ROWNUM =1;
           IF v_aac031='1' THEN
             v_aac031 :='�α��ɷ�';
         ELSIF v_aac031='2' THEN
             v_aac031 :='��ͣ�ɷ�';
         ELSIF v_aac031='3' THEN
             v_aac031 :='��ֹ�ɷ�';
         END IF;
         IF v_aab001 IS NOT NULL THEN
          BEGIN
         SELECT aab004 INTO v_aab004 FROM sjxt.ab01 WHERE aab001 = v_aab001;
           EXCEPTION
             WHEN OTHERS THEN
              BEGIN
                v_aab004 :='';
                END;
                END;
         END IF;
                v_message := v_message|| '��Ա�²α��Ǽ���֤��ͨ���������֤������Աҽ�Ʊ��չ�ϵĿǰ���������籣����,����'||v_aac003||',��λ���ƣ�'||v_aab004||'�α����α�״̬:'||v_aac031||'��';
               var_flag :='1';
            elsif sj_count1 = 0 then
                v_message := v_message|| '��Ա�²α��Ǽ���֤��ͨ���������֤������Աҽ�Ʊ��չ�ϵĿǰ���������籣����,����'||v_aac003;
               var_flag :='1';
          END IF;
          END IF;

             END IF;*/
             --18λ���֤���Ƿ��²α�У��
      SELECT COUNT(1)
        INTO n_count
        FROM  wsjb.irac01  a
      WHERE  a.aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
        AND A.iaa001 <> '4'
        AND A.IAA002 <> '3'
        AND ROWNUM = 1;

      IF n_count >0 THEN

        SELECT aab001
          INTO  v_aab001
          FROM wsjb.irac01
         WHERE aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
           AND iaa001 <> '4'
           AND IAA002 <> '3'
           AND  rownum = 1;

        IF v_aab001 IS NOT NULL THEN
            SELECT aab004
              INTO v_aab004
              FROM wsjb.irab01
             WHERE iab001 = v_aab001
               AND rownum = 1;
        END IF;
        v_message := v_message||'����Ա��'||v_aab004||'['||v_aab001||']���걨��¼����������ģ���������';
        var_flag  := 1;
      END IF;

       IF REC_TMP_PERSON.aab001 IS NULL THEN
         v_message := v_message||'û���ҵ���λ��ţ�';
         var_flag  := 1;
       END IF;


      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.irab01
       WHERE iab001 = REC_TMP_PERSON.aab001;
       IF n_count = 0 THEN
         v_message := v_message||'û���ҵ�������λ��Ϣ';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac003 IS NULL THEN
         v_message := v_message||'������������Ϊ�գ�';
         var_flag  := 1;
       END IF;
       IF REC_TMP_PERSON.aac004 IS NULL THEN
       v_message := v_message||'�Ա���Ϊ�գ�';
         var_flag  := 1;
       END IF;
       IF REC_TMP_PERSON.aac004 IS NOT NULL THEN
          IF REC_TMP_PERSON.aac004 <> '1' AND REC_TMP_PERSON.aac004 <> '2' AND REC_TMP_PERSON.aac004 <> '9' THEN
                v_message := v_message||'�Ա���ֵ����!';
                var_flag  := 1;
          END IF;
       END IF;
       IF REC_TMP_PERSON.aac005 IS   NULL THEN
          v_message := v_message||'���岻��Ϊ��!';
                var_flag  := 1;
       END IF;
       IF REC_TMP_PERSON.aac005 IS  NOT  NULL THEN
          IF  LENGTH(trim(REC_TMP_PERSON.aac005)) <> 2 THEN
                v_message := v_message||'������ֵ����!';
                var_flag  := 1;
          END IF;
       END IF;

       IF REC_TMP_PERSON.aac009 IS NULL THEN
         v_message := v_message||'�������ʲ���Ϊ�գ�';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aac009 <> '10' AND REC_TMP_PERSON.aac009 <> '20' AND REC_TMP_PERSON.aac009 <> '30' AND REC_TMP_PERSON.aac009 <> '40' AND REC_TMP_PERSON.aac009 <> '90' THEN
                  v_message := v_message||'����������ֵ����!';
                  var_flag  :=1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aac010 IS NULL OR LENGTH(REC_TMP_PERSON.aac010)< 8 THEN
         v_message := v_message||'������ַ����Ϊ��,����������8λ��';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aae006 IS NULL OR LENGTH(REC_TMP_PERSON.aae006)< 8 THEN
         v_message := v_message||'��ϵ��ַ����Ϊ��,����������8λ��';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac011 IS NULL THEN
         v_message := v_message||'ѧ������Ϊ�գ�';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aac011 <> '11' AND REC_TMP_PERSON.aac011 <> '12' AND REC_TMP_PERSON.aac011 <> '21'
               AND REC_TMP_PERSON.aac011 <> '31' AND REC_TMP_PERSON.aac011 <> '40' AND REC_TMP_PERSON.aac011 <> '50'
               AND REC_TMP_PERSON.aac011 <> '61' AND REC_TMP_PERSON.aac011 <> '62' AND REC_TMP_PERSON.aac011 <> '70'
               AND REC_TMP_PERSON.aac011 <> '80' AND REC_TMP_PERSON.aac011 <> '90' AND REC_TMP_PERSON.aac011 <> '99' THEN
                  v_message := v_message||'ѧ����ֵ����!';
                  var_flag  :=1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aac021 IS NULL THEN
         v_message := v_message||'��ҵʱ�䲻��Ϊ�գ�';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac022 IS NULL THEN
         v_message := v_message||'��ҵԺУ����Ϊ�գ�';
         var_flag  := 1;
       END IF;

        IF REC_TMP_PERSON.aac025 IS NULL THEN
         v_message := v_message||'����״������Ϊ�գ�';
         var_flag  := 1;
         ELSE
            IF REC_TMP_PERSON.aac025 <> '1' AND REC_TMP_PERSON.aac025 <> '2' AND REC_TMP_PERSON.aac025 <> '3'
               AND REC_TMP_PERSON.aac025 <> '4' AND REC_TMP_PERSON.aac025 <> '9' THEN
                  v_message := v_message||'����״����ֵ����!';
                  var_flag  :=1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aac026 IS NULL THEN
         v_message := v_message||'�Ƿ���۲���Ϊ�գ�';
         var_flag  := 1;
         ELSE
            IF REC_TMP_PERSON.aac026 <> '0' AND REC_TMP_PERSON.aac026 <> '1' THEN
                   v_message := v_message||'�Ƿ������ֵ����!';
                  var_flag  :=1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aac012 IS NULL THEN
         v_message := v_message||'������ݲ���Ϊ�գ�';
         var_flag  := 1;
         ELSE
            IF REC_TMP_PERSON.aac012 NOT IN ('1','4') THEN
                   v_message := v_message||'���������ֵ����!';
                  var_flag  :=1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.yac168 IS NULL THEN
         v_message := v_message||'�����񹤱�־����Ϊ�գ�';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.yac168 NOT IN ('0','1') THEN
                    v_message := v_message||'ũ�񹤱�־��ֵ����!';
                    var_flag  := 1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aac030 IS NULL THEN
         v_message := v_message||'�α�ʱ�䲻��Ϊ�գ�';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac007 IS NULL THEN
         v_message := v_message||'�ι�ʱ�䲻��Ϊ�գ�';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.yac503 IS NULL THEN
         v_message := v_message||'���������Ϊ�գ�';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac040 IS NULL THEN
         v_message := v_message||'�걨���ʲ���Ϊ�գ�';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aae110 IS NULL THEN
         v_message := v_message||'��ҵְ�����ϱ��ղ��ܵ�����';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae110 <> '0' AND REC_TMP_PERSON.aae110 <> '1' THEN
                v_message := v_message||'��ҵְ�����ϱ�����ֵ����!';
                var_flag  := 1;
             END IF;
       END IF;

       IF REC_TMP_PERSON.aae120 IS NULL THEN
         v_message := v_message||'������ҵ���ϱ��ղ��ܵ�����';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae120 <> '0' AND REC_TMP_PERSON.aae120 <> '1' THEN
                v_message := v_message||'������ҵ���ϱ�����ֵ����!';
                var_flag  := 1;
             END IF;
       END IF;

       IF REC_TMP_PERSON.aae210 IS NULL THEN
         v_message := v_message||'ʧҵ���ղ��ܵ�����';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae210 <> '0' AND REC_TMP_PERSON.aae210 <> '1' THEN
                v_message := v_message||'ʧҵ������ֵ����!';
                var_flag  := 1;
             END IF;
       END IF;

       IF REC_TMP_PERSON.aae310 IS NULL THEN
         v_message := v_message||'����ҽ�Ʊ��ղ��ܵ�����';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae310 <> '0' AND REC_TMP_PERSON.aae310 <> '1' THEN
                v_message := v_message||'����ҽ�Ʊ�����ֵ����!';
                var_flag  := 1;
             END IF;
       END IF;

       IF REC_TMP_PERSON.aae410 IS NULL THEN
         v_message := v_message||'���˱��ղ��ܵ�����';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae410 <> '0' AND REC_TMP_PERSON.aae410 <> '1' THEN
                v_message := v_message||'���˱�����ֵ����!';
                var_flag  := 1;
             END IF;
       END IF;

       IF REC_TMP_PERSON.aae510 IS NULL THEN
         v_message := v_message||'�������ղ��ܵ�����';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae510 <> '0' AND REC_TMP_PERSON.aae510 <> '1' THEN
                v_message := v_message||'����������ֵ����!';
                var_flag  := 1;
             END IF;
       END IF;

       IF REC_TMP_PERSON.aae311 IS NULL THEN
         v_message := v_message||'�󲡲���ҽ�Ʊ��ղ��ܵ�����';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae311 <> '0' AND REC_TMP_PERSON.aae311 <> '1' THEN
                v_message := v_message||'����ҽ�Ʊ�����ֵ����!';
                var_flag  := 1;
             END IF;
       END IF;

      IF REC_TMP_PERSON.aae810 IS NULL THEN
         v_message := v_message||'����Ա�������ղ��ܵ�����';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae810 <> '0' AND REC_TMP_PERSON.aae810 <> '1' THEN
                v_message := v_message||'����Ա����������ֵ����!';
                var_flag  := 1;
             END IF;
       END IF;
       num_aac040 := REC_TMP_PERSON.aac040;
        --��ҵְ�����ϱ���У��
       IF REC_TMP_PERSON.aae110 IS NOT NULL THEN
             SELECT COUNT(1)
               INTO n_count
               FROM wsjb.irab01  a,AE02 b
              WHERE a.aaz002 = b.AAZ002
                AND b.aaa121 = PKG_Constant.AAA121_NER
                AND a.aab001 = prm_aab001;
             IF n_count > 0 THEN
                   SELECT nvl(a.aae110,'0')
                     INTO  v_aae110
                     FROM wsjb.irab01  a,AE02 b
                    WHERE a.aaz002 = b.AAZ002
                      AND b.aaa121 = PKG_Constant.AAA121_NER
                      AND a.aab001 = prm_aab001;
             ELSE
                    v_aae110 := '0';
             END IF;
           IF  (v_aae110 = '0' AND REC_TMP_PERSON.aae110 = '1') THEN
             v_message := v_message||'���ڵ�λû�вμ���ҵְ�����ϱ���!';
             var_flag := 1;
           END IF;
           
           IF (v_aae110 = '1' AND REC_TMP_PERSON.aae110 = '1') THEN
               SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,prm_aab001,num_aac040,'0','01','1','1',prm_iaa100,prm_yab139))
                INTO num_yac004
                FROM  dual ;
              UPDATE IRAC01A2
                 SET yac004 = ROUND(num_yac004)
               WHERE aac002 = REC_TMP_PERSON.aac002
                 AND aac003 = REC_TMP_PERSON.aac003
                 AND iaz018 = prm_iaz018;
           END IF;

       END IF;

      --������ҵ���ϱ���У��
       IF REC_TMP_PERSON.aae120 IS NOT NULL THEN
           SELECT COUNT(1)
             INTO  n_count
             FROM xasi2.ab02
            WHERE aab001 = prm_aab001
              AND  aae140 = '06';

            IF n_count > 0 THEN
                   SELECT decode(aab051,'1','2','0')
                     INTO  v_aae120
                     FROM xasi2.ab02
                    WHERE aab001 = prm_aab001
                      AND aae140 = '06';
            ELSE
                  v_aae120 := '0';
            END IF;

           IF  (v_aae120 = '0' AND REC_TMP_PERSON.aae120 = '1') THEN
             v_message := v_message||'���ڵ�λû�вμӻ�����ҵ���ϱ���!';
             var_flag := 1;
           END IF;
           IF (v_aae120 = '1' AND REC_TMP_PERSON.aae120 = '1') THEN

              UPDATE IRAC01A2
                 SET yac004 = num_aac040
               WHERE aac002 = REC_TMP_PERSON.aac002
                 AND aac003 = REC_TMP_PERSON.aac003
                 AND iaz018 = prm_iaz018;
           END IF;

       END IF;
       /**
       ----��һ������Ϊ׼
        SELECT aae140
          INTO var_aae140
          FROM xasi2.AB02
         WHERE aab051 = '1'
           AND (aae140 = '02' OR aae140 = '03' OR aae140 = '04' OR aae140 = '05' )
           AND aab001 = prm_aab001
           AND ROWNUM = 1;
       --��ȡ��������
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,prm_aab001,num_aac040,'0',var_aae140,'1','1',prm_iaa100,prm_yab139))
          INTO num_yac005
          FROM  dual ;
        UPDATE IRAC01A2
           SET yac005 = ROUND(num_yac005),
               yaa333 = ROUND(num_yac005)
         WHERE aac002 = REC_TMP_PERSON.aac002
           AND aac003 = REC_TMP_PERSON.aac003
           AND iaz018 = prm_iaz018;
*/
------˫���� ���ϡ�ʧҵ������ͬ������ҽ�ơ�����ͬ����   20190807 modify by yujj
  SELECT COUNT(1)
             INTO  n_count
             FROM xasi2.ab05
            WHERE aab001 = prm_aab001
              AND  AAE001 = 2019
              AND YAB007='03';
  IF n_count < 1 AND prm_iaa100<201901    THEN
           SELECT aae140
          INTO var_aae140
          FROM xasi2.AB02
         WHERE aab051 = '1'
           AND (aae140 = '02' OR aae140 = '03' OR aae140 = '04' OR aae140 = '05' )
           AND aab001 = prm_aab001
           AND ROWNUM = 1;
       --��ȡ��������
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,prm_aab001,num_aac040,'0',var_aae140,'1','1',prm_iaa100,prm_yab139))
          INTO num_yac005
          FROM  dual ;
        UPDATE IRAC01A2
           SET yac005 = ROUND(num_yac005),
               yaa333 = ROUND(num_yac005)
         WHERE aac002 = REC_TMP_PERSON.aac002
           AND aac003 = REC_TMP_PERSON.aac003
           AND iaz018 = prm_iaz018;
     
ELSE   
    SELECT aae030 
    INTO  dat_AAE030 
    FROM xasi2.aa35 
    WHERE aae001=2019 ;
   IF     prm_iaa100>201812 AND  SYSDATE >dat_AAE030  THEN 
       ----��һ������Ϊ׼
        SELECT aae140
          INTO var_aae140
          FROM xasi2.AB02
         WHERE aab051 = '1'
           AND (aae140 = '02'  OR aae140 = '04'   )
           AND aab001 = prm_aab001
           AND ROWNUM = 1;
       --��ȡʧҵ�����˻���
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,prm_aab001,num_aac040,'0',var_aae140,'1','1',prm_iaa100,prm_yab139))
          INTO num_yac004
          FROM  dual ;
        UPDATE IRAC01A2
           SET yac004 = ROUND(num_yac004)
         WHERE aac002 = REC_TMP_PERSON.aac002
           AND aac003 = REC_TMP_PERSON.aac003
           AND iaz018 = prm_iaz018; 
       ----��ҽ������Ϊ׼
        SELECT aae140
          INTO var_aae140
          FROM xasi2.AB02
         WHERE aab051 = '1'
           AND (  aae140 = '03'  OR aae140 = '05' )
           AND aab001 = prm_aab001
           AND ROWNUM = 1;
      IF REC_TMP_PERSON.aae310 = '1' THEN
       --��ȡ��������
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,prm_aab001,num_aac040,'0',var_aae140,'1','1',prm_iaa100,prm_yab139))
          INTO num_yac005
          FROM  dual ;
        UPDATE IRAC01A2
           SET yac005 = ROUND(num_yac005),
               yaa333 = ROUND(num_yac005)
         WHERE aac002 = REC_TMP_PERSON.aac002
           AND aac003 = REC_TMP_PERSON.aac003
           AND iaz018 = prm_iaz018;
      END IF;
     END IF;
   END IF;
 
      --ʧҵ����У��
       IF REC_TMP_PERSON.aae210 IS NOT NULL THEN
           SELECT COUNT(1)
           INTO  n_count
           FROM xasi2.ab02
           WHERE aab001 = prm_aab001
            AND  aae140 = '02';

            IF n_count > 0 THEN
                   SELECT decode(aab051,'1','2','0')
                     INTO  v_aae210
                     FROM xasi2.ab02
                    WHERE aab001 = prm_aab001
                      AND aae140 = '02';
            ELSE
                  v_aae210 := '0';
            END IF;

           IF  (v_aae210 = '0' AND REC_TMP_PERSON.aae210 = '1') THEN
             v_message := v_message||'���ڵ�λû�в�ʧҵ����!';
             var_flag := 1;
           END IF;

       END IF;

      --����ҽ�Ʊ���У��
       IF REC_TMP_PERSON.aae310 IS NOT NULL THEN
           SELECT COUNT(1)
           INTO  n_count
           FROM xasi2.ab02
           WHERE aab001 = prm_aab001
            AND  aae140 = '03';

            IF n_count > 0 THEN
                   SELECT decode(aab051,'1','2','0')
                     INTO  v_aae310
                     FROM xasi2.ab02
                    WHERE aab001 = prm_aab001
                      AND aae140 = '03';
            ELSE
                  v_aae310 := '0';
            END IF;

           IF  (v_aae310 = '0' AND REC_TMP_PERSON.aae310 = '1') THEN
             v_message := v_message||'���ڵ�λû�вμӻ���ҽ�Ʊ���!';
             var_flag := 1;
           END IF;

       END IF;

      --���˱���У��
       IF REC_TMP_PERSON.aae410 IS NOT NULL THEN
           SELECT COUNT(1)
           INTO  n_count
           FROM xasi2.ab02
           WHERE aab001 = prm_aab001
            AND  aae140 = '04';

            IF n_count > 0 THEN
                   SELECT decode(aab051,'1','2','0')
                     INTO  v_aae410
                     FROM xasi2.ab02
                    WHERE aab001 = prm_aab001
                      AND aae140 = '04';
            ELSE
                  v_aae410 := '0';
            END IF;

           IF  (v_aae410 = '0' AND REC_TMP_PERSON.aae410 = '1') THEN
             v_message := v_message||'���ڵ�λû�вμӻ����˱���!';
             var_flag := 1;
           END IF;

       END IF;

       --��������У��
       IF REC_TMP_PERSON.aae510 IS NOT NULL THEN
           SELECT COUNT(1)
           INTO  n_count
           FROM xasi2.ab02
           WHERE aab001 = prm_aab001
            AND  aae140 = '05';

            IF n_count > 0 THEN
                   SELECT decode(aab051,'1','2','0')
                     INTO  v_aae510
                     FROM xasi2.ab02
                    WHERE aab001 = prm_aab001
                      AND aae140 = '05';
            ELSE
                  v_aae510 := '0';
            END IF;

           IF  (v_aae510 = '0' AND REC_TMP_PERSON.aae510 = '1') THEN
             v_message := v_message||'���ڵ�λû�вμ���������!';
             var_flag := 1;
           END IF;

       END IF;

      --����ҽ�Ʊ���У��
       IF REC_TMP_PERSON.aae311 IS NOT NULL THEN
           SELECT COUNT(1)
           INTO  n_count
           FROM xasi2.ab02
           WHERE aab001 = prm_aab001
            AND  aae140 = '07';

            IF n_count > 0 THEN
                   SELECT decode(aab051,'1','2','0')
                     INTO  v_aae311
                     FROM xasi2.ab02
                    WHERE aab001 = prm_aab001
                      AND aae140 = '07';
            ELSE
                  v_aae311 := '0';
            END IF;

           IF  (v_aae311 = '0' AND REC_TMP_PERSON.aae311 = '1') THEN
             v_message := v_message||'���ڵ�λû�вμӴ���ҽ�Ʊ���!';
             var_flag := 1;
           END IF;

       END IF;

       --����Ա��������У��
       IF REC_TMP_PERSON.aae810 IS NOT NULL THEN
           SELECT COUNT(1)
           INTO  n_count
           FROM xasi2.ab02
           WHERE aab001 = prm_aab001
            AND  aae140 = '08';

            IF n_count > 0 THEN
                   SELECT decode(aab051,'1','2','0')
                     INTO  v_aae810
                     FROM xasi2.ab02
                    WHERE aab001 = prm_aab001
                      AND aae140 = '08';
            ELSE
                  v_aae810 := '0';
            END IF;

           IF  (v_aae810 = '0' AND REC_TMP_PERSON.aae810 = '1') THEN
             v_message := v_message||'���ڵ�λû�вμӹ���Ա��������!';
             var_flag := 1;
           END IF;

           IF v_aae810 = '1' AND NVL(REC_TMP_PERSON.yaa333,0) <= 0 THEN
               v_message := v_message||'�˻���������Ϊ��!';
              var_flag := 1;
           END IF;

       END IF;

       --���ֻ���У��
       IF REC_TMP_PERSON.aae110 = '1' AND REC_TMP_PERSON.aae120 = '1' THEN
               v_message:= v_message||'��ҵְ�����ϱ��պͻ������ϱ��ղ���һ��α�!';
              var_flag := 1;
       END IF;
       IF REC_TMP_PERSON.aae410 = '0' AND v_aae410 = '2' THEN
               v_message:= v_message||'���˱���Ϊ�ز���!';
              var_flag := 1;
       END IF;
       /*���ݵ�λ���ְ󶨸��˲α�����*/
       --��λ�α������У�ҽ�ơ�ʧҵ�����������
       IF  v_aae510 = '2' AND v_aae311 = '2' AND v_aae310 = '2' THEN

             IF REC_TMP_PERSON.aae310 = '1' THEN
                   IF   REC_TMP_PERSON.aae510 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                         v_message := v_message||'ҽ�ơ����������������ֱ���һ��α�!';
                         var_flag  := 1;
                    END IF;
             END IF;
/*
             IF REC_TMP_PERSON.aae210 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae510 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                         v_message := v_message||'ҽ�ơ����������������ֱ���һ��α�!';
                         var_flag  := 1;
                    END IF;
             END IF;
*/
             IF REC_TMP_PERSON.aae510 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0'  OR REC_TMP_PERSON.aae311 = '0' THEN
                         v_message := v_message||'ҽ�ơ����������������ֱ���һ��α�!';
                         var_flag  := 1;
                    END IF;
             END IF;

             IF REC_TMP_PERSON.aae311 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0'  OR REC_TMP_PERSON.aae510 = '0' THEN
                         v_message := v_message||'ҽ�ơ����������������ֱ���һ��α�!';
                         var_flag  := 1;
                    END IF;
             END IF;

       END IF;
       --��λ�α������У�ҽ�ơ����������
       IF v_aae510 = '2' AND v_aae311 = '2' AND v_aae310 = '2' THEN

             IF REC_TMP_PERSON.aae510 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                         v_message := v_message||'û�вμӻ���ҽ�ƺʹ���,���ܲμ�����!';
                         var_flag  := 1;
                    END IF;
             END IF;

             IF REC_TMP_PERSON.aae311 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0'  THEN
                         v_message := v_message||'û�вμӻ���ҽ�Ʊ���,���ܲμӴ���ҽ��!';
                         var_flag  := 1;
                    END IF;
             END IF;

       END IF;

       --��λ�α������У�ҽ�ơ����
       IF  v_aae311 = '2' AND v_aae310 = '2' THEN

             IF REC_TMP_PERSON.aae311 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0'  THEN
                         v_message := v_message||'û�вμӻ���ҽ�Ʊ���,���ܲμӴ���ҽ��!';
                         var_flag  := 1;
                    END IF;
             END IF;

       END IF;

       IF REC_TMP_PERSON.aac009 = '20' AND REC_TMP_PERSON.yac168 = '0' THEN
               v_message:= v_message||'��������Ϊũҵ����,ũ�񹤱�־����Ϊ����!';
              var_flag := 1;
       END IF;
       IF REC_TMP_PERSON.aac009 <> '20' AND REC_TMP_PERSON.yac168 = '1' THEN
               v_message:= v_message||'ũ�񹤱�־Ϊ����,�������ʱ���Ϊũҵ����!';
              var_flag := 1;
       END IF;

            --�α�ʱ�䡢�ι�ʱ�䡢�״βα�ʱ��У��
       IF REC_TMP_PERSON.aac030 IS NOT NULL THEN
          IF REC_TMP_PERSON.aac030 >  last_day(to_date(prm_iaa100,'yyyymm')) THEN
                  v_message:= v_message||'����λ�α�ʱ�䲻������ϵͳʱ��!';
                  var_flag := 1;
          END IF;
       END IF;

      IF REC_TMP_PERSON.yac033 IS NOT NULL THEN
          IF REC_TMP_PERSON.yac033 > last_day(to_date(prm_iaa100,'yyyymm'))  THEN
                  v_message:= v_message||'���βα�ʱ�䲻������ϵͳʱ��!';
                  var_flag := 1;
          END IF;
       END IF;

        IF REC_TMP_PERSON.aac007 IS NOT NULL THEN
            IF REC_TMP_PERSON.aac007 > last_day(to_date(prm_iaa100,'yyyymm'))  THEN
                  v_message:= v_message||'�ι�ʱ�䲻������ϵͳʱ��!';
                  var_flag := 1;
          END IF;
      END IF;

        IF REC_TMP_PERSON.aac007 IS NOT NULL AND REC_TMP_PERSON.aac030 IS NOT NULL THEN
            IF REC_TMP_PERSON.aac007 > REC_TMP_PERSON.aac030 THEN
                  v_message:= v_message||'�ι�ʱ�䲻�����ڲα�ʱ��!';
                  var_flag := 1;
          END IF;
      END IF;

      IF REC_TMP_PERSON.aac030 IS NOT NULL THEN
          IF TO_NUMBER(TO_CHAR(REC_TMP_PERSON.aac030,'yyyyMM')) > TO_NUMBER(prm_iaa100) THEN
                  v_message:= v_message||'����λ�α�ʱ�䲻�������걨�¶�!';
                  var_flag := 1;
          END IF;
      END IF;

      --�����ظ�У��
        IF REC_TMP_PERSON.aac002 IS NOT NULL THEN
          SELECT COUNT(1)
            INTO n_count
            FROM wsjb.irac01  a
          WHERE a.iaa002 = PKG_Constant.IAA002_WIR
            AND a.aac002 = v_aac002
            AND a.iaa001 = PKG_Constant.IAA001_ADD ;
          IF n_count>0 THEN
          v_message := v_message||'�Ѿ�������Ա�²α�������Ϣ,���ܼ�������!';
          var_flag  := 1;
        END IF;
      END IF;

       IF REC_TMP_PERSON.aac002 IS NOT NULL THEN
          SELECT COUNT(1)
            INTO n_count
            FROM wsjb.irac01  a
          WHERE a.iaa002 = PKG_Constant.IAA002_WIR
            AND a.aac002 = v_aac002
            AND a.iaa001 = PKG_Constant.IAA001_IAD ;
          IF n_count>0 THEN
          v_message := v_message||'�Ѿ����������²α�������Ϣ,���ܼ�������!';
          var_flag  := 1;
        END IF;
      END IF;

      IF REC_TMP_PERSON.aac002 IS NOT NULL THEN
          SELECT COUNT(1)
            INTO n_count
            FROM wsjb.irac01  a
          WHERE a.iaa002 = PKG_Constant.IAA002_WIR
            AND a.aac002 = v_aac002
            AND a.iaa001 = PKG_Constant.IAA001_MIN;
          IF n_count>0 THEN
          v_message := v_message||'�Ѿ�������ͣ�ɷ�������Ϣ,���ܼ�������!';
          var_flag  := 1;
        END IF;
      END IF;

      IF REC_TMP_PERSON.aac002 IS NOT NULL THEN
          SELECT COUNT(1)
            INTO n_count
            FROM wsjb.irac01  a
          WHERE a.iaa002 = PKG_Constant.IAA002_WIR
            AND a.aac002 = v_aac002
            AND a.iaa001 = PKG_Constant.IAA001_PMI;
          IF n_count>0 THEN
          v_message := v_message||'�Ѿ�����������ͣ������Ϣ,���ܼ�������!';
          var_flag  := 1;
        END IF;
      END IF;

      IF REC_TMP_PERSON.aac002 IS NOT NULL THEN
          SELECT COUNT(1)
            INTO n_count
            FROM wsjb.irac01  a
          WHERE a.iaa002 = PKG_Constant.IAA002_WIR
            AND a.aac002 = v_aac002
            AND a.iaa001 = PKG_Constant.IAA001_RTR;
          IF n_count>0 THEN
          v_message := v_message||'�Ѿ�������ְת����������Ϣ,���ܼ�������!';
          var_flag  := 1;
        END IF;
      END IF;
      --�������֤�Ž�ȡ��������
      IF LENGTH(TRIM(v_aac002)) = 18 THEN
             SELECT to_date( substr(TRIM(v_aac002),7,8 ),'yyyy-mm-dd')
              INTO  d_aac006
              FROM dual;
             SELECT decode(mod(to_number(substr(TRIM(v_aac002),17,1)),2),1,'1',0,'2','9')
              INTO  v_aac004
              FROM dual;

            UPDATE IRAC01A2  a
                 SET a.aac006 = d_aac006,
                     a.aac004 = v_aac004
              WHERE a.iaz018 = prm_iaz018
                AND a.aac002 = REC_TMP_PERSON.aac002
                AND a.aac003 = REC_TMP_PERSON.aac003;
      END IF;

      IF LENGTH(TRIM(v_aac002)) = 15 THEN
             SELECT to_date(( '19' ||  substr(v_aac002,7,6)) ,'yyyy-mm-dd')
               INTO d_aac006
               FROM dual;
             SELECT decode(mod(to_number(substr(TRIM(v_aac002),15,1)),2),1,'1',0,'2','9')
              INTO v_aac004
              FROM dual;
              UPDATE IRAC01A2  a
                   SET a.aac006 = d_aac006,
                       a.aac004 = v_aac004
                WHERE a.iaz018 = prm_iaz018
                  AND a.aac002 = REC_TMP_PERSON.aac002
                  AND a.aac003 = REC_TMP_PERSON.aac003;
      END IF;

      SELECT decode(REC_TMP_PERSON.aac009,'10','0','20','1')
        INTO v_yac168
        FROM dual;

      UPDATE IRAC01A2  a
          SET a.yac168 = v_yac168
        WHERE a.iaz018 = prm_iaz018
          AND a.aac002 = REC_TMP_PERSON.aac002
          AND a.aac003 = REC_TMP_PERSON.aac003;
     <<label_ERROR>>
     IF var_flag = 0 THEN
        --��ȡIRAC01A2�����ݵ�IRAC01
        --  v_iac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAC001');
         BEGIN
          --��дirac01a2 ԭ��Ϊ�ɹ�
             UPDATE IRAC01A2  a
                SET  a.errormsg = '���ݿ��Ե��뱣��',
                     a.aae100 = '2'
              WHERE a.iaz018 = prm_iaz018
                AND a.aac002 = REC_TMP_PERSON.aac002
                AND a.aac003 = REC_TMP_PERSON.aac003;

       END;
     ELSIF var_flag = 1 THEN
          --��дirac01a2 ��дʧ��ԭ��
             UPDATE IRAC01A2  a
                SET  a.errormsg = v_message,
                     a.aae100 = '0'
              WHERE a.iaz018 = prm_iaz018
                AND a.aac002 = REC_TMP_PERSON.aac002
                AND a.aac003 = REC_TMP_PERSON.aac003;
      END IF;

      END LOOP;
   EXCEPTION
   WHEN OTHERS THEN
   /*�رմ򿪵��α�*/
   ROLLBACK;
   prm_AppCode  :=  gn_def_ERR;
   prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
   RETURN;
   END prc_batchImportView;
    /*****************************************************************************
   ** �������� : prc_batchImport
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �������²α����뱣��
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001     IN     irab01.aab001%TYPE,--��λ���
   **           prm_aae011     IN     ab08.aae011%TYPE,  --������Ա
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-17   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_batchImport(prm_aab001     IN     irac01.aab001%TYPE,--��λ���
                             prm_aae011     IN     ae02.aae011%TYPE,  --������Ա
                             prm_iaa100     IN     VARCHAR2,--�걨�¶�
                             prm_iaz018     IN     irac01a2.iaz018%TYPE,  --������������ID
                             prm_yab139     IN     irac01.yab139%TYPE,--��������
                             prm_AppCode    OUT    VARCHAR2  ,
                             prm_ErrorMsg   OUT    VARCHAR2 )

   IS
      n_count    number(5);
      v_iac001   irac01.iac001%TYPE;
      v_aac001   irac01.aac001%TYPE;
      v_aab001   irac01.aab001%TYPE;
      v_aab004   irab01.aab004%TYPE;
      v_aaz002   varchar2(23);
      var_flag   number(1);
      v_aac002   irac01.aac002%TYPE;
      v_aac002_l   irac01.aac002%TYPE;
      v_aac002_u   irac01.aac002%TYPE;
      v_aac002d  irac01.aac002%TYPE;
      d_aac006    DATE;
      v_aac004   irac01.aac004%TYPE;
      v_aae110   irac01.aae110%TYPE;
      v_aae120   irac01.aae120%TYPE;
      v_aae210   irac01.aae210%TYPE;
      v_aae310   irac01.aae310%TYPE;
      v_aae410   irac01.aae410%TYPE;
      v_aae510   irac01.aae510%TYPE;
      v_aae311   irac01.aae311%TYPE;
     v_aae810     irac01.aae810%TYPE;
      v_message  varchar2(3000);
      v_yac168   irac01.yac168%TYPE;
      n_aae002   number(14);
      n_yac004   number(14);
      n_yac005   number(14);
      CURSOR impCur IS
             SELECT
              iaz018,
              iaa001,
              iaa002,
              aac001,
              aab001,
              yae181,
              yac067,
              aac002,
              REPLACE(aac003,' ','') AS aac003,
              aac004,
              aac005,
              aac006,
              aac007,
              aac008,
              aac009,
              aac010,
              aac011,
              aac021,
              aac022,
              aac025,--����״��
              aac026,--�Ƿ���
              aac012,
              aac013,
              aac014,
              aac015,
              aac020,
              yac168,
              yac197,
              yac501,
              yac170,
              yac502,
              yae407,
              yae496,
              yic067,
              aae004,
              aae005,
              aae006,
              aae007,
              yae222,
              yac200,
              aae110,
              aac031,
              yac505,
              yac033,
              aac030,
              yae102,
              yae097,
              yac503,
              aac040,
              yac004,
              yaa333,
              yab013,
              yac002,
              yab139,
              aae011,
              aae036,
              yab003,
              aae013,
              aaz002,
              aae120,
              aae210,
              aae310,
              aae410,
              aae510,
              aae311,
              aae810,
              akc021,
              ykc150,
              ykb109,
              aic162,
              yac005,
              aae100,
              errormsg
             FROM IRAC01A2
             WHERE iaz018 = prm_iaz018
               AND aae100 = '2';

   BEGIN
     /*��ʼ������*/
     prm_AppCode  := PKG_Constant.GN_DEF_OK;
    prm_ErrorMsg := '';
     n_count := 0;
     v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
     /*�����п�*/
     IF prm_aab001 IS NULL THEN
        prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := 'û�л�ȡ����λ��ţ�';
       RETURN;
    END IF;

    IF prm_aae011 IS NULL THEN
        prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := 'û�л�ȡ��������Ա��ţ�';
       RETURN;
    END IF;

     --�ж��Ƿ���ڸõ�λ
     SELECT COUNT(1)
       into n_count
       FROM wsjb.irab01
       WHERE aab001 = prm_aab001;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '��λ���Ϊ['|| prm_aab001 ||']�ĵ�λ��Ϣ������!';
       RETURN;
    END IF;



    --�ж��Ƿ���ڸ�ר��Ա
      SELECT COUNT(1)
       INTO n_count
       FROM IRAA01
       WHERE yae092 = prm_aae011;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := 'ר��Ա���Ϊ['|| prm_aae011 ||']����Ϣ������!';
       RETURN;
    END IF;

    --�ж��Ƿ��������������Ϣ
     SELECT COUNT(1)
       INTO n_count
       FROM IRAC01A2
      WHERE iaz018 = prm_iaz018;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '��������IDΪ['|| prm_iaz018 ||']����Ϣ������!';
       RETURN;
    END IF;

          --��־��¼
    INSERT INTO AE02
           (
            AAZ002,
            AAA121,
            AAE011,
            YAB003,
            AAE014,
            AAE016,
            AAE216,
            AAE217,
            AAE218,
            AAE013
            )
            VALUES
           (
            v_aaz002,
            PKG_Constant.AAA121_PPA,
            prm_aae011,
            PKG_Constant.YAB003_JBFZX,
            prm_aae011,
            '1',
            sysdate,
            sysdate,
            sysdate,
            prm_aab001||'��λ��������'
           );


    --ѭ��������ȡ����
    FOR REC_TMP_PERSON IN impCur LOOP
      --��ʼ����־λ
       var_flag := 0;
       v_message := '';
       /**���Ͻӿڷ�����Ϣ�������Ϊ�����ܱ��棩**/
       IF REC_TMP_PERSON.AAE100 = '0' THEN
       v_message := REC_TMP_PERSON.ERRORMSG;
       var_flag :=1;
       END IF;
      /**��������**/
      --���֤�ǿ�У��
       IF REC_TMP_PERSON.aac002 IS NULL THEN
         v_message := v_message||'���֤���벻��Ϊ�գ�';
         var_flag  := 1;
       END IF;
      --���֤λ������
       IF LENGTH(trim(REC_TMP_PERSON.aac002)) = 18  THEN
          xasi2.pkg_P_Comm_CZ.prc_P_getID( UPPER(REC_TMP_PERSON.aac002),   --�������֤
                                  v_aac002,   --�������֤
                                  prm_AppCode,   --�������
                                  prm_ErrorMsg) ;  --��������
          IF prm_AppCode <> PKG_Constant.GN_DEF_OK THEN
              v_message :=  v_message||prm_ErrorMsg;
              prm_AppCode := PKG_Constant.GN_DEF_OK;
              prm_ErrorMsg := '';
              var_flag :=1;
          END IF;

          SELECT  substr(trim(REC_TMP_PERSON.aac002),1,6) || substr(trim(REC_TMP_PERSON.aac002),9,9)
            INTO v_aac002d
            FROM dual;

          SELECT  UPPER(v_aac002)
            INTO  v_aac002_u
            FROM  dual;

          SELECT  LOWER(v_aac002)
            INTO  v_aac002_l
            FROM  dual;
--       ElSIF LENGTH(trim(REC_TMP_PERSON.aac002)) = 15 THEN
--               xasi2.pkg_P_Comm_CZ.prc_P_getID( UPPER(REC_TMP_PERSON.aac002),   --�������֤
--                                       v_aac002,   --�������֤
--                                       prm_AppCode,   --�������
--                                       prm_ErrorMsg) ;  --��������
--               IF prm_AppCode <> PKG_Constant.GN_DEF_OK THEN
--                   v_message :=  v_message||prm_ErrorMsg;
--                   prm_AppCode := PKG_Constant.GN_DEF_OK;
--                   prm_ErrorMsg := '';
--                   var_flag :=1;
--               END IF;
--            SELECT  UPPER(v_aac002)
--            INTO  v_aac002_u
--            FROM  dual;
--
--          SELECT  LOWER(v_aac002)
--            INTO  v_aac002_l
--            FROM  dual;
--              v_aac002d := trim(REC_TMP_PERSON.aac002);
       ELSE
             v_message := v_message||REC_TMP_PERSON.aac002||'���֤λ�����Ϸ�;';
             var_flag   := 1;
       END IF;

      --����Ƿ�����ظ���ݺ���
      select count(1)
        into n_count
        from IRAC01A2
       where iaz018 = prm_iaz018
         and aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d);
      IF n_count > 1 THEN
         v_message := v_message||'�������������֤�������ظ�;';
         var_flag   := 1;
      END IF;


      --18λ���֤���Ƿ��²α�У��
      SELECT COUNT(1)
        INTO n_count
        FROM xasi2.ac01 a
       WHERE a.aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
         AND a.aae120 = '0';

        IF n_count >0 THEN
          v_message := v_message||'֤����Ϊ��['||v_aac002||']����Ա�Ѵ��ڸ�����Ϣ����������ģ���������';
          var_flag  := 1;
        END IF;

             --18λ���֤���Ƿ��²α�У��
      SELECT COUNT(1)
        INTO n_count
        FROM  wsjb.irac01  a
      WHERE  a.aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
        AND A.iaa001 <> '4'
        AND A.IAA002 <> '3'
        AND ROWNUM = 1;

      IF n_count >0 THEN

        SELECT aab001
          INTO v_aab001
          FROM wsjb.irac01
         WHERE aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
           AND iaa001 <> '4'
           AND IAA002 <> '3'
           AND ROWNUM = 1;

        IF v_aab001 IS NOT NULL THEN
            SELECT aab004
              INTO v_aab004
              FROM wsjb.irab01
             WHERE iab001 = v_aab001
               AND rownum = 1;
        END IF;
        v_message := v_message||'����Ա��'||v_aab004||'['||v_aab001||']���걨��¼����������ģ���������';
        var_flag  := 1;
      END IF;

       IF REC_TMP_PERSON.aab001 IS NULL THEN
         v_message := v_message||'û���ҵ���λ��ţ�';
         var_flag  := 1;
       END IF;


      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.irab01
       WHERE iab001 = REC_TMP_PERSON.aab001;
       IF n_count = 0 THEN
         v_message := v_message||'û���ҵ�������λ��Ϣ';
         var_flag  := 1;
       END IF;

--
--       IF REC_TMP_PERSON.aac003 IS NULL THEN
--         v_message := v_message||'������������Ϊ�գ�';
--         var_flag  := 1;
--       END IF;
--       IF REC_TMP_PERSON.aac004 IS NOT NULL THEN
--          IF REC_TMP_PERSON.aac004 <> '1' AND REC_TMP_PERSON.aac004 <> '2' AND REC_TMP_PERSON.aac004 <> '9' THEN
--                v_message := v_message||'�Ա���ֵ����!';
--                var_flag  := 1;
--          END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aac005 IS  NOT  NULL THEN
--          IF  LENGTH(trim(REC_TMP_PERSON.aac005)) <> 2 THEN
--                v_message := v_message||'��ֵ��ֵ����!';
--                var_flag  := 1;
--          END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aac009 IS NULL THEN
--         v_message := v_message||'�������ʲ���Ϊ�գ�';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aac009 <> '10' AND REC_TMP_PERSON.aac009 <> '20' AND REC_TMP_PERSON.aac009 <> '30' AND REC_TMP_PERSON.aac009 <> '40' AND REC_TMP_PERSON.aac009 <> '90' THEN
--                  v_message := v_message||'����������ֵ����!';
--                  var_flag  :=1;
--            END IF;
--       END IF;
--
--        IF REC_TMP_PERSON.aac010 IS NULL AND LENGTH(REC_TMP_PERSON.aac010)< 8 THEN
--         v_message := v_message||'������ַ����Ϊ��,����������8λ��';
--         var_flag  := 1;
--       END IF;
--
--       IF REC_TMP_PERSON.aae006 IS NULL AND LENGTH(REC_TMP_PERSON.aae006)< 8 THEN
--         v_message := v_message||'��ϵ��ַ����Ϊ��,����������8λ��';
--         var_flag  := 1;
--       END IF;
--
--       IF REC_TMP_PERSON.aac011 IS NULL THEN
--         v_message := v_message||'ѧ������Ϊ�գ�';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aac011 <> '11' AND REC_TMP_PERSON.aac011 <> '12' AND REC_TMP_PERSON.aac011 <> '21'
--               AND REC_TMP_PERSON.aac011 <> '31' AND REC_TMP_PERSON.aac011 <> '40' AND REC_TMP_PERSON.aac011 <> '50'
--               AND REC_TMP_PERSON.aac011 <> '61' AND REC_TMP_PERSON.aac011 <> '62' AND REC_TMP_PERSON.aac011 <> '70'
--               AND REC_TMP_PERSON.aac011 <> '80' AND REC_TMP_PERSON.aac011 <> '90' AND REC_TMP_PERSON.aac011 <> '99' THEN
--                  v_message := v_message||'ѧ����ֵ����!';
--                  var_flag  :=1;
--            END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aac021 IS NULL THEN
--         v_message := v_message||'��ҵʱ�䲻��Ϊ�գ�';
--         var_flag  := 1;
--       END IF;
--
--       IF REC_TMP_PERSON.aac022 IS NULL THEN
--         v_message := v_message||'��ҵԺУ����Ϊ�գ�';
--         var_flag  := 1;
--       END IF;
--
--       IF REC_TMP_PERSON.aac025 IS NULL THEN
--         v_message := v_message||'����״������Ϊ�գ�';
--         var_flag  := 1;
--         ELSE
--            IF REC_TMP_PERSON.aac025 <> '1' AND REC_TMP_PERSON.aac025 <> '2' AND REC_TMP_PERSON.aac025 <> '3'
--               AND REC_TMP_PERSON.aac025 <> '4' AND REC_TMP_PERSON.aac025 <> '9' THEN
--                  v_message := v_message||'����״����ֵ����!';
--                  var_flag  :=1;
--            END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aac026 IS NULL THEN
--         v_message := v_message||'�Ƿ���۲���Ϊ�գ�';
--         var_flag  := 1;
--         ELSE
--            IF REC_TMP_PERSON.aac026 <> '0' AND REC_TMP_PERSON.aac026 <> '1' THEN
--                   v_message := v_message||'�Ƿ������ֵ����!';
--                  var_flag  :=1;
--            END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aac012 IS NULL THEN
--         v_message := v_message||'������ݲ���Ϊ�գ�';
--         var_flag  := 1;
--         ELSE
--            IF REC_TMP_PERSON.aac012 <> '1' AND REC_TMP_PERSON.aac012 <> '4' THEN
--                   v_message := v_message||'���������ֵ����!';
--                  var_flag  :=1;
--            END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.yac168 IS NULL THEN
--         v_message := v_message||'�����񹤱�־����Ϊ�գ�';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.yac168 <> '0' AND REC_TMP_PERSON.yac168 <> '1' THEN
--                    v_message := v_message||'ũ�񹤱�־��ֵ����!';
--                    var_flag  := 1;
--            END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aac030 IS NULL THEN
--         v_message := v_message||'�α�ʱ�䲻��Ϊ�գ�';
--         var_flag  := 1;
--       END IF;
--
--       IF REC_TMP_PERSON.yac503 IS NULL THEN
--         v_message := v_message||'���������Ϊ�գ�';
--         var_flag  := 1;
--       END IF;
--
--       IF REC_TMP_PERSON.aac040 IS NULL THEN
--         v_message := v_message||'�걨���ʲ���Ϊ�գ�';
--         var_flag  := 1;
--       END IF;
--
--       IF REC_TMP_PERSON.aae110 IS NULL THEN
--         v_message := v_message||'��ҵְ�����ϱ��ղ��ܵ�����';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aae110 <> '0' AND REC_TMP_PERSON.aae110 <> '1' THEN
--                v_message := v_message||'��ҵְ�����ϱ�����ֵ����!';
--                var_flag  := 1;
--             END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aae120 IS NULL THEN
--         v_message := v_message||'������ҵ���ϱ��ղ��ܵ�����';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aae120 <> '0' AND REC_TMP_PERSON.aae120 <> '1' THEN
--                v_message := v_message||'������ҵ���ϱ�����ֵ����!';
--                var_flag  := 1;
--             END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aae210 IS NULL THEN
--         v_message := v_message||'ʧҵ���ղ��ܵ�����';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aae210 <> '0' AND REC_TMP_PERSON.aae210 <> '1' THEN
--                v_message := v_message||'ʧҵ������ֵ����!';
--                var_flag  := 1;
--             END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aae310 IS NULL THEN
--         v_message := v_message||'����ҽ�Ʊ��ղ��ܵ�����';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aae310 <> '0' AND REC_TMP_PERSON.aae310 <> '1' THEN
--                v_message := v_message||'����ҽ�Ʊ�����ֵ����!';
--                var_flag  := 1;
--             END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aae410 IS NULL THEN
--         v_message := v_message||'���˱��ղ��ܵ�����';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aae410 <> '0' AND REC_TMP_PERSON.aae410 <> '1' THEN
--                v_message := v_message||'���˱�����ֵ����!';
--                var_flag  := 1;
--             END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aae510 IS NULL THEN
--         v_message := v_message||'�������ղ��ܵ�����';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aae510 <> '0' AND REC_TMP_PERSON.aae510 <> '1' THEN
--                v_message := v_message||'����������ֵ����!';
--                var_flag  := 1;
--             END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aae311 IS NULL THEN
--         v_message := v_message||'�󲡲���ҽ�Ʊ��ղ��ܵ�����';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aae311 <> '0' AND REC_TMP_PERSON.aae311 <> '1' THEN
--                v_message := v_message||'����ҽ�Ʊ�����ֵ����!';
--                var_flag  := 1;
--             END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aae810 IS NULL THEN
--         v_message := v_message||'����Ա�������ղ��ܵ�����';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aae810 <> '0' AND REC_TMP_PERSON.aae810 <> '1' THEN
--                v_message := v_message||'����Ա����������ֵ����!';
--                var_flag  := 1;
--             END IF;
--       END IF;
--        --��ҵְ�����ϱ���У��
--       IF REC_TMP_PERSON.aae110 IS NOT NULL THEN
--               SELECT COUNT(1)
--               INTO n_count
--               FROM  IRAB01 a,AE02 b
--               WHERE a.aaz002 = b.AAZ002
--                  AND b.aaa121 = PKG_Constant.AAA121_NER
--                  AND a.aab001 = prm_aab001;
--               IF n_count > 0 THEN
--                   SELECT nvl(a.aae110,'0')
--                     INTO  v_aae110
--                     FROM IRAB01 a,AE02 b
--                    WHERE a.aaz002 = b.AAZ002
--                      AND b.aaa121 = PKG_Constant.AAA121_NER
--                      AND a.aab001 = prm_aab001;
--                ELSE
--                    v_aae110 := '0';
--                END IF;
--           IF  (v_aae110 = '0' AND REC_TMP_PERSON.aae110 = '1') THEN
--             v_message := v_message||'���ڵ�λû�вμ���ҵְ�����ϱ���!';
--             var_flag := 1;
--           END IF;
--       END IF;
--
--      --������ҵ���ϱ���У��
--       IF REC_TMP_PERSON.aae120 IS NOT NULL THEN
--           SELECT COUNT(1)
--           INTO  n_count
--           FROM ab02
--           WHERE aab001 = prm_aab001
--            AND  aae140 = '06';
--
--            IF n_count > 0 THEN
--                   SELECT decode(aab051,'1','2','0')
--                     INTO  v_aae120
--                     FROM ab02
--                    WHERE aab001 = prm_aab001
--                      AND aae140 = '06';
--            ElSE
--                  v_aae120 := '0';
--            END IF;
--
--           IF  (v_aae120 = '0' AND REC_TMP_PERSON.aae120 = '1') THEN
--             v_message := v_message||'���ڵ�λû�вμӻ�����ҵ���ϱ���!';
--             var_flag := 1;
--           END IF;
--
--       END IF;
--
--      --ʧҵ����У��
--       IF REC_TMP_PERSON.aae210 IS NOT NULL THEN
--           SELECT COUNT(1)
--           INTO  n_count
--           FROM ab02
--           WHERE aab001 = prm_aab001
--            AND  aae140 = '02';
--
--            IF n_count > 0 THEN
--                   SELECT decode(aab051,'1','2','0')
--                     INTO  v_aae210
--                     FROM ab02
--                    WHERE aab001 = prm_aab001
--                      AND aae140 = '02';
--            ElSE
--                  v_aae210 := '0';
--            END IF;
--
--           IF  (v_aae210 = '0' AND REC_TMP_PERSON.aae210 = '1') THEN
--             v_message := v_message||'���ڵ�λû�в�ʧҵ����!';
--             var_flag := 1;
--           END IF;
--
--       END IF;
--
--      --����ҽ�Ʊ���У��
--       IF REC_TMP_PERSON.aae310 IS NOT NULL THEN
--           SELECT COUNT(1)
--           INTO  n_count
--           FROM ab02
--           WHERE aab001 = prm_aab001
--            AND  aae140 = '03';
--
--            IF n_count > 0 THEN
--                   SELECT decode(aab051,'1','2','0')
--                     INTO  v_aae310
--                     FROM ab02
--                    WHERE aab001 = prm_aab001
--                      AND aae140 = '03';
--            ElSE
--                  v_aae310 := '0';
--            END IF;
--
--           IF  (v_aae310 = '0' AND REC_TMP_PERSON.aae310 = '1') THEN
--             v_message := v_message||'���ڵ�λû�вμӻ���ҽ�Ʊ���!';
--             var_flag := 1;
--           END IF;
--
--       END IF;
--
--      --���˱���У��
--       IF REC_TMP_PERSON.aae410 IS NOT NULL THEN
--           SELECT COUNT(1)
--           INTO  n_count
--           FROM ab02
--           WHERE aab001 = prm_aab001
--            AND  aae140 = '04';
--
--            IF n_count > 0 THEN
--                   SELECT decode(aab051,'1','2','0')
--                     INTO  v_aae410
--                     FROM ab02
--                    WHERE aab001 = prm_aab001
--                      AND aae140 = '04';
--            ElSE
--                  v_aae410 := '0';
--            END IF;
--
--           IF  (v_aae410 = '0' AND REC_TMP_PERSON.aae410 = '1') THEN
--             v_message := v_message||'���ڵ�λû�вμӻ����˱���!';
--             var_flag := 1;
--           END IF;
--
--       END IF;
--
--       --��������У��
--       IF REC_TMP_PERSON.aae510 IS NOT NULL THEN
--           SELECT COUNT(1)
--           INTO  n_count
--           FROM ab02
--           WHERE aab001 = prm_aab001
--            AND  aae140 = '05';
--
--            IF n_count > 0 THEN
--                   SELECT decode(aab051,'1','2','0')
--                     INTO  v_aae510
--                     FROM ab02
--                    WHERE aab001 = prm_aab001
--                      AND aae140 = '05';
--            ElSE
--                  v_aae510 := '0';
--            END IF;
--
--           IF  (v_aae510 = '0' AND REC_TMP_PERSON.aae510 = '1') THEN
--             v_message := v_message||'���ڵ�λû�вμ���������!';
--             var_flag := 1;
--           END IF;
--
--       END IF;
--
--      --����ҽ�Ʊ���У��
--       IF REC_TMP_PERSON.aae311 IS NOT NULL THEN
--           SELECT COUNT(1)
--           INTO  n_count
--           FROM ab02
--           WHERE aab001 = prm_aab001
--            AND  aae140 = '07';
--
--            IF n_count > 0 THEN
--                   SELECT decode(aab051,'1','2','0')
--                     INTO  v_aae311
--                     FROM ab02
--                    WHERE aab001 = prm_aab001
--                      AND aae140 = '07';
--            ElSE
--                  v_aae311 := '0';
--            END IF;
--
--           IF  (v_aae311 = '0' AND REC_TMP_PERSON.aae311 = '1') THEN
--             v_message := v_message||'���ڵ�λû�вμӴ���ҽ�Ʊ���!';
--             var_flag := 1;
--           END IF;
--
--       END IF;
--
--       --����Ա��������У��
--       IF REC_TMP_PERSON.aae810 IS NOT NULL THEN
--           SELECT COUNT(1)
--           INTO  n_count
--           FROM ab02
--           WHERE aab001 = prm_aab001
--            AND  aae140 = '08';
--
--            IF n_count > 0 THEN
--                   SELECT decode(aab051,'1','2','0')
--                     INTO v_aae810
--                     FROM ab02
--                    WHERE aab001 = prm_aab001
--                      AND aae140 = '08';
--            ElSE
--                  v_aae810 := '0';
--            END IF;
--
--           IF  (v_aae810 = '0' AND REC_TMP_PERSON.aae810 = '1') THEN
--             v_message := v_message||'���ڵ�λû�вμӹ���Ա��������!';
--             var_flag := 1;
--           END IF;
--
--       END IF;
--
--       --���ֻ���У��
--       IF REC_TMP_PERSON.aae110 = '1' AND REC_TMP_PERSON.aae120 = '1' THEN
--               v_message:= v_message||'��ҵְ�����ϱ��պͻ������ϱ��ղ���һ��α�!';
--              var_flag := 1;
--       END IF;
--       IF REC_TMP_PERSON.aae410 = '0' AND v_aae410 = '2' THEN
--               v_message:= v_message||'���˱���Ϊ�ز���!';
--              var_flag := 1;
--       END IF;
--       /*���ݵ�λ���ְ󶨸��˲α�����*/
--       --��λ�α������У�ҽ�ơ�ʧҵ�����������
--       IF v_aae210 = '2' AND v_aae510 = '2' AND v_aae311 = '2' AND v_aae310 = '2' THEN
--
--             IF REC_TMP_PERSON.aae310 = '1' THEN
--                   IF  REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae510 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
--                         v_message := v_message||'ҽ�ơ�ʧҵ�����������������ֱ���һ��α�!';
--                         var_flag  := 1;
--                    END IF;
--             END IF;
--
--             IF REC_TMP_PERSON.aae210 = '1' THEN
--                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae510 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
--                         v_message := v_message||'ҽ�ơ�ʧҵ�����������������ֱ���һ��α�!';
--                         var_flag  := 1;
--                    END IF;
--             END IF;
--
--             IF REC_TMP_PERSON.aae510 = '1' THEN
--                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
--                         v_message := v_message||'ҽ�ơ�ʧҵ�����������������ֱ���һ��α�!';
--                         var_flag  := 1;
--                    END IF;
--             END IF;
--
--             IF REC_TMP_PERSON.aae311 = '1' THEN
--                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae510 = '0' THEN
--                         v_message := v_message||'ҽ�ơ�ʧҵ�����������������ֱ���һ��α�!';
--                         var_flag  := 1;
--                    END IF;
--             END IF;
--
--       END IF;
--       --��λ�α������У�ҽ�ơ����������
--       IF v_aae510 = '2' AND v_aae311 = '2' AND v_aae310 = '2' THEN
--
--             IF REC_TMP_PERSON.aae510 = '1' THEN
--                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
--                         v_message := v_message||'û�вμӻ���ҽ�ƺʹ���,���ܲμ�����!';
--                         var_flag  := 1;
--                    END IF;
--             END IF;
--
--             IF REC_TMP_PERSON.aae311 = '1' THEN
--                   IF  REC_TMP_PERSON.aae310 = '0'  THEN
--                         v_message := v_message||'û�вμӻ���ҽ�Ʊ���,���ܲμӴ���ҽ��!';
--                         var_flag  := 1;
--                    END IF;
--             END IF;
--
--       END IF;
--
--       --��λ�α������У�ҽ�ơ����
--       IF  v_aae311 = '2' AND v_aae310 = '2' THEN
--
--             IF REC_TMP_PERSON.aae311 = '1' THEN
--                   IF  REC_TMP_PERSON.aae310 = '0'  THEN
--                         v_message := v_message||'û�вμӻ���ҽ�Ʊ���,���ܲμӴ���ҽ��!';
--                         var_flag  := 1;
--                    END IF;
--             END IF;
--
--       END IF;
--
--       IF REC_TMP_PERSON.aac009 = '20' AND REC_TMP_PERSON.yac168 = '0' THEN
--               v_message:= v_message||'��������Ϊũҵ����,ũ�񹤱�־����Ϊ����!';
--              var_flag := 1;
--       END IF;
--       IF REC_TMP_PERSON.aac009 <> '20' AND REC_TMP_PERSON.yac168 = '1' THEN
--               v_message:= v_message||'ũ�񹤱�־Ϊ����,�������ʱ���Ϊũҵ����!';
--              var_flag := 1;
--       END IF;
--
--          --�α�ʱ�䡢�ι�ʱ�䡢�״βα�ʱ��У��
--       IF REC_TMP_PERSON.aac030 IS NOT NULL THEN
--            IF REC_TMP_PERSON.aac030 > sysdate THEN
--                  v_message:= v_message||'����λ�α�ʱ�䲻������ϵͳʱ��!';
--                  var_flag := 1;
--          END IF;
--       END IF;
--
--      IF REC_TMP_PERSON.yac033 IS NOT NULL THEN
--            IF REC_TMP_PERSON.yac033 > sysdate THEN
--                  v_message:= v_message||'����λ�α�ʱ�䲻������ϵͳʱ��!';
--                  var_flag := 1;
--          END IF;
--       END IF;
--
--        IF REC_TMP_PERSON.aac007 IS NOT NULL THEN
--            IF REC_TMP_PERSON.aac007 > sysdate THEN
--                  v_message:= v_message||'�ι�ʱ�䲻������ϵͳʱ��!';
--                  var_flag := 1;
--          END IF;
--      END IF;
--
--        IF REC_TMP_PERSON.aac007 IS NOT NULL AND REC_TMP_PERSON.aac030 IS NOT NULL THEN
--            IF REC_TMP_PERSON.aac007 > REC_TMP_PERSON.aac030 THEN
--                  v_message:= v_message||'�ι�ʱ�䲻�����ڲα�ʱ��!';
--                  var_flag := 1;
--          END IF;
--      END IF;

       --�����ظ�У��
        IF REC_TMP_PERSON.aac002 IS NOT NULL THEN
          SELECT COUNT(1)
            INTO n_count
            FROM wsjb.irac01  a
          WHERE a.iaa002 = PKG_Constant.IAA002_WIR
            AND a.aac002 = v_aac002
            AND a.iaa001 = PKG_Constant.IAA001_ADD ;
          IF n_count>0 THEN
          v_message := v_message||'�Ѿ�������Ա�²α�������Ϣ,���ܼ�������!';
          var_flag  := 1;
        END IF;
      END IF;

       IF REC_TMP_PERSON.aac002 IS NOT NULL THEN
          SELECT COUNT(1)
            INTO n_count
            FROM wsjb.irac01  a
          WHERE a.iaa002 = PKG_Constant.IAA002_WIR
            AND a.aac002 = v_aac002
            AND a.iaa001 = PKG_Constant.IAA001_IAD ;
          IF n_count>0 THEN
          v_message := v_message||'�Ѿ����������²α�������Ϣ,���ܼ�������!';
          var_flag  := 1;
        END IF;
      END IF;

      IF REC_TMP_PERSON.aac002 IS NOT NULL THEN
          SELECT COUNT(1)
            INTO n_count
            FROM wsjb.irac01  a
          WHERE a.iaa002 = PKG_Constant.IAA002_WIR
            AND a.aac002 = v_aac002
            AND a.iaa001 = PKG_Constant.IAA001_MIN;
          IF n_count>0 THEN
          v_message := v_message||'�Ѿ�������ͣ�ɷ�������Ϣ,���ܼ�������!';
          var_flag  := 1;
        END IF;
      END IF;

      IF REC_TMP_PERSON.aac002 IS NOT NULL THEN
          SELECT COUNT(1)
            INTO n_count
            FROM wsjb.irac01  a
          WHERE a.iaa002 = PKG_Constant.IAA002_WIR
            AND a.aac002 = v_aac002
            AND a.iaa001 = PKG_Constant.IAA001_PMI;
          IF n_count>0 THEN
          v_message := v_message||'�Ѿ�����������ͣ������Ϣ,���ܼ�������!';
          var_flag  := 1;
        END IF;
      END IF;

      IF REC_TMP_PERSON.aac002 IS NOT NULL THEN
          SELECT COUNT(1)
            INTO n_count
            FROM wsjb.irac01  a
          WHERE a.iaa002 = PKG_Constant.IAA002_WIR
            AND a.aac002 = v_aac002
            AND a.iaa001 = PKG_Constant.IAA001_RTR;
          IF n_count>0 THEN
          v_message := v_message||'�Ѿ�������ְת����������Ϣ,���ܼ�������!';
          var_flag  := 1;
        END IF;
      END IF;
      --�������֤�Ž�ȡ��������
--      IF LENGTH(TRIM(v_aac002)) = 18 THEN
--             SELECT to_date( substr(TRIM(v_aac002),7,8 ),'yyyy-mm-dd')
--              INTO  d_aac006
--              FROM dual;
--             SELECT decode(mod(to_number(substr(TRIM(v_aac002),17,1)),2),1,'1',0,'2','9')
--              INTO  v_aac004
--              FROM dual;
--      END IF;
--
--      IF LENGTH(TRIM(v_aac002)) = 15 THEN
--             SELECT to_date(( '19' ||  substr(v_aac002,7,6)) ,'yyyy-mm-dd')
--               INTO d_aac006
--               FROM dual;
--             SELECT decode(mod(to_number(substr(TRIM(v_aac002),15,1)),2),1,'1',0,'2','9')
--              INTO v_aac004
--              FROM dual;
--      END IF;
--
--      SELECT decode(REC_TMP_PERSON.aac009,'10','0','20','1')
--        INTO v_yac168
--        FROM dual;
--
--     SELECT  to_number(to_char(sysdate,'yyyymm'))
--       INTO n_aae002
--       FROM dual;
--
--     IF REC_TMP_PERSON.aae310 = 1 THEN
--        SELECT
--        pkg_common.fun_p_getcontributionbase(null,REC_TMP_PERSON.aab001,REC_TMP_PERSON.aac040,'0','03','1','1',n_aae002,PKG_Constant.YAB003_JBFZX)
--        INTO n_yac005
--        FROM dual;
--     ELSE
--        SELECT
--        pkg_common.fun_p_getcontributionbase(null,REC_TMP_PERSON.aab001,REC_TMP_PERSON.aac040,'0','04','1','1',n_aae002,PKG_Constant.YAB003_JBFZX)
--        INTO n_yac005
--        FROM dual;
--     END IF;
--     IF REC_TMP_PERSON.aae110 = 1 THEN
--        SELECT
--         pkg_common.fun_p_getcontributionbase(null,REC_TMP_PERSON.aab001,REC_TMP_PERSON.aac040,'0','01','1','1',n_aae002,PKG_Constant.YAB003_JBFZX)
--        INTO n_yac004
--        FROM dual;
--
--     ELSIF REC_TMP_PERSON.aae120 = 1 THEN
--        n_yac004 := REC_TMP_PERSON.yac004;
--     END IF;

     IF var_flag = 0 THEN
        --��ȡIRAC01A2�����ݵ�IRAC01
          v_iac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAC001');
         BEGIN
             INSERT INTO
                   wsjb.irac01
                   (
                    iac001,-- �걨��Ա��Ϣ��� -->
                     iaa001,-- �걨��Ա��� -->
                     iaa002,-- �걨��Ա��Ϣ״̬ -->
                     aac001,-- ���˱��     -->
                     aab001,-- ��λ���     -->
                     yae181,-- ֤������     -->
                     yac067,-- ��Դ��ʽ     -->
                     aac002,-- ���֤����(֤������) -->
                     aac003,-- ����         -->
                     aac004,-- �Ա�         -->
                     aac005,-- ����         -->
                     aac006,-- ��������     -->
                     aac007,-- �μӹ������� -->
                     aac008,-- ��Ա״̬     -->
                     aac009,-- ��������     -->
                     aac010,-- �������ڵ�   -->
                     aac011,-- �Ļ��̶�     -->
                     aac021,--��ҵ����
                     aac022,--��ҵԺУ
                     aac025,--�������
                     aac026,--�Ƿ����
                     aac012,-- �������     -->
                     aac013,-- �ù���ʽ     -->
                     aac014,-- רҵ����ְ�� -->
                     aac015,-- ���˼����ȼ� -->
                     aac020,-- ����ְ��     -->
                     yac168,-- ũ�񹤱�־   -->
                     yac197,-- ��ģ����     -->
                     yac501,-- ũ���ų�ְ�� -->
                     yac170,-- ��ת�ɱ�־   -->
                     yac502,-- �Ƿ�ԭ����ҵ�� -->
                     yae407,-- ��������     -->
                     yae496,-- �����ֵ�     -->
                     yic067,-- ����ǰ�Ϲ��� -->
                     aae004,-- ��ϵ������   -->
                     aae005,-- ��ϵ�绰     -->
                     aae006,-- ��ַ         -->
                     aae007,-- ��������     -->
                     yae222,-- EMAIL        -->
                     yac200,-- ����Ա����ְ�� -->
                     aae110,-- ְ������     -->
                     aac031,-- ���˲α�״̬ -->
                     yac505,-- �α��ɷ���Ա��� -->
                     yac033,-- ���˳��βα����� -->
                     aac030,-- ��ϵͳ�α����� -->
                     yae102,-- ���һ�α��ʱ�� -->
                     yae097,-- ��������ں� -->
                     yac503,-- �������     -->
                     aac040,-- �ɷѹ���     -->
                     yac004,-- �ɷѻ���[����] -->
                     yaa333,-- �˻�����     -->
                     yab013,-- ԭ��λ���   -->
                     yac002,-- ��ҵ����ţ����ţ� -->
                     yab139,-- �α����������� -->
                     aae011,-- ������       -->
                     aae036,-- ����ʱ��     -->
                     yab003,-- �籣������� -->
                     aae013,-- ��ע         -->
                     aaz002,-- ҵ����־     -->
                     aae120,-- ��������     -->
                     aae210,-- ʧҵ         -->
                     aae310,-- ҽ��         -->
                     aae410,-- ����         -->
                     aae510,-- ����         -->
                     aae311,-- ��         -->
                     akc021,-- ҽ����Ա��� -->
                     ykc150,-- פ���־     -->
                     ykb109,-- �Ƿ����ܹ���Աͳ����� -->
                     aic162,-- ����������   -->
                     yac005,-- �ɷѻ���[����] -->
                     aae810
                   ) VALUES (
                    v_iac001,
                    PKG_Constant.IAA001_PAD,
                     PKG_Constant.IAA002_WIR,
                     v_iac001,             -- ���˱��     -->
                     REC_TMP_PERSON.aab001,-- ��λ���     -->
                     '1',
                     PKG_Constant.YAC067_TQXCB,-- ��Դ��ʽ     -->
                     REC_TMP_PERSON.aac002,             -- ���֤����(֤������) -->
                     REC_TMP_PERSON.aac003,-- ����         -->
                     REC_TMP_PERSON.aac004,             -- �Ա�         -->
                     REC_TMP_PERSON.aac005,-- ����         -->
                     REC_TMP_PERSON.aac006             ,-- ��������     -->
                     REC_TMP_PERSON.aac007,-- �μӹ������� -->
                     PKG_Constant.AAC008_ZZ,
                     REC_TMP_PERSON.aac009,-- ��������     -->
                     REC_TMP_PERSON.aac010,-- �������ڵ�   -->
                     REC_TMP_PERSON.aac011,-- �Ļ��̶�     -->
                     REC_TMP_PERSON.aac021,--��ҵʱ��
                     REC_TMP_PERSON.aac022,--��ҵԺУ
                     REC_TMP_PERSON.aac025,--�������
                     REC_TMP_PERSON.aac026,--�Ƿ����
                     REC_TMP_PERSON.aac012,--�������
                     PKG_Constant.AAC013_QT,-- �ù���ʽ     -->
                     '5',                  -- רҵ����ְ�� -->
                     '9',                  -- ���˼����ȼ� -->
                     '190',                -- ����ְ��     -->
                     REC_TMP_PERSON.yac168,             -- ũ�񹤱�־   -->
                     REC_TMP_PERSON.yac197,-- ��ģ����     -->
                     REC_TMP_PERSON.yac501,-- ũ���ų�ְ�� -->
                     PKG_Constant.YAC170_FOU,-- ��ת�ɱ�־   -->
                     REC_TMP_PERSON.yac502,-- �Ƿ�ԭ����ҵ�� -->
                     REC_TMP_PERSON.yae407,-- ��������     -->
                     REC_TMP_PERSON.yae496,-- �����ֵ�     -->
                     REC_TMP_PERSON.yic067,-- ����ǰ�Ϲ��� -->
                     REC_TMP_PERSON.aae004,-- ��ϵ������   -->
                     REC_TMP_PERSON.aae005,-- ��ϵ�绰     -->
                     REC_TMP_PERSON.aae006,-- ��ַ         -->
                     REC_TMP_PERSON.aae007,-- ��������     -->
                     REC_TMP_PERSON.yae222,-- EMAIL        -->
                     REC_TMP_PERSON.yac200,-- ����Ա����ְ�� -->
                     REC_TMP_PERSON.aae110,-- ְ������     -->
                     REC_TMP_PERSON.aac031,-- ���˲α�״̬ -->
                     REC_TMP_PERSON.yac505,-- �α��ɷ���Ա��� -->
                     REC_TMP_PERSON.yac033,-- ���˳��βα����� -->
                     REC_TMP_PERSON.aac030,-- ��ϵͳ�α����� -->
                     REC_TMP_PERSON.yae102,-- ���һ�α��ʱ�� -->
                     REC_TMP_PERSON.yae097,-- ��������ں� -->
                     PKG_Constant.YAC503_SB,
                     REC_TMP_PERSON.aac040,-- �ɷѹ���     -->
                     REC_TMP_PERSON.yac004,-- �ɷѻ���[����] -->
                     REC_TMP_PERSON.yaa333,-- �˻�����     -->
                     REC_TMP_PERSON.yab013,-- ԭ��λ���   -->
                     REC_TMP_PERSON.yac002,-- ��ҵ����ţ����ţ� -->
                     PKG_Constant.YAB003_JBFZX,
                     REC_TMP_PERSON.aae011,-- ������       -->
                     REC_TMP_PERSON.aae036,-- ����ʱ��     -->
                     REC_TMP_PERSON.yab003,-- �籣������� -->
                     REC_TMP_PERSON.aae013,-- ��ע         -->
                     v_aaz002,
                     REC_TMP_PERSON.aae120,-- ��������     -->
                     REC_TMP_PERSON.aae210,-- ʧҵ         -->
                     REC_TMP_PERSON.aae310,-- ҽ��         -->
                     REC_TMP_PERSON.aae410,-- ����         -->
                     REC_TMP_PERSON.aae510,-- ����         -->
                     REC_TMP_PERSON.aae311,-- ��         -->
                     REC_TMP_PERSON.akc021,-- ҽ����Ա��� -->
                     REC_TMP_PERSON.ykc150,-- פ���־     -->
                     REC_TMP_PERSON.ykb109,-- �Ƿ����ܹ���Աͳ����� -->
                     REC_TMP_PERSON.aic162,-- ����������   -->
                     REC_TMP_PERSON.yac005,-- �ɷѻ���[����] -->
                     REC_TMP_PERSON.aae810
                   );

              --��дirac01a2 ����ɹ���־Ϊ�ɹ�
             UPDATE IRAC01A2 a
                SET a.aae100 = '1',
                    a.errormsg = '�����ѵ���'
              WHERE a.iaz018 = prm_iaz018
                AND a.aac002 = REC_TMP_PERSON.aac002
                AND a.aac003 = REC_TMP_PERSON.aac003;

       END;
     ELSIF var_flag = 1 THEN
          --��дirac01a2 ����ɹ���־Ϊδ�ɹ�ͬʱ��дʧ��ԭ��
             UPDATE IRAC01A2  a
                SET a.aae100 = '0',
                   a.errormsg = v_message
              WHERE a.iaz018 = prm_iaz018
                AND a.aac002 = REC_TMP_PERSON.aac002
                AND a.aac003 = REC_TMP_PERSON.aac003;
      END IF;

      END LOOP;
   EXCEPTION
   WHEN OTHERS THEN
   /*�رմ򿪵��α�*/
   ROLLBACK;
   prm_AppCode  :=  gn_def_ERR;
   prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
   RETURN;
   END prc_batchImport;
     /*--------------------------------------------------------------------------
   || ҵ�񻷽� ���¶Ƚɷ��걨���ܳ�ʼ������У��
   || �������� prc_p_ValidateDeathCheck
   || �������� ��У���±�
   ||
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��zhujing         ������� ��2015-12-3
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateMonthApply(
       prm_aab001          IN            VARCHAR2,     --��λ���
      prm_yab139          IN            VARCHAR2,     --�������
      prm_iaa100          OUT           VARCHAR2,     --��ǰʹ��ʾ�걨�¶�
      prm_flag            OUT           VARCHAR2,     --����ҵ��״̬��־
      prm_msg             OUT           VARCHAR2,     --��ʾ��Ϣ
      prm_sign            OUT           VARCHAR2,     --�����־
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2)    --������Ϣ
    IS
      num_count           NUMBER(6);
      var_iaa100          VARCHAR2(15);--��λ������걨�¶�
      var_iaa100nex       VARCHAR2(15);--��λ�걨�¶ȵ��¸��¶�
      var_sysmonth        VARCHAR2(23);--��ǰʱ���¶�
      var_sysnexmonth     VARCHAR2(23);--��ǰʱ����¸��¶�
      var_yae097          VARCHAR2(23);--���������
      var_yae097nex       VARCHAR2(23);--��������ڵ��¸��¶�
      num_ab02count        NUMBER;--��Ե������¿�����λ�ж�
    BEGIN
      /*��ʼ������*/
       prm_AppCode  := GN_DEF_OK;
       prm_ErrorMsg := '';
       prm_msg :='';
       prm_sign :='0';
       prm_flag :='';--0�״ν����걨��1�����걨��2���������  3��˴��  4���ͨ�� 5��δ�����걨ʱ��
      --�ж��Ƿ�Ϊ�����ϵ�λ
      SELECT count(1)
        INTO num_ab02count
        FROM xasi2.ab02 a
        WHERE a.aab001 = prm_aab001
        AND a.aab051='1';
       --��λ������ʽȷ��
       SELECT count(1)
         INTO num_count
        FROM wsjb.irab03  a
       WHERE a.aab001 = prm_aab001;
      IF num_count = 0 THEN
         prm_msg :=  'û�п��õĵ�λ������ʽ������ϵ��ѯ�籣���ģ�';
        prm_sign := '1';
        GOTO label_OUT;
      END IF;
      IF num_ab02count>0 THEN
       --��ȡ��λ��ǰ���������
       SELECT TO_CHAR(SYSDATE, 'yyyymm') SYS100,
             TO_CHAR(ADD_MONTHS(SYSDATE, 1), 'yyyymm') SYSNEX,
             TO_CHAR(NVL(MAX(YAE097), '999999')) IAA100,
             TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(NVL(MAX(YAE097),TO_CHAR(SYSDATE,'yyyymm'))),'yyyymm'),1),'yyyymm') NEX100
        INTO var_sysmonth,
             var_sysnexmonth,
             var_yae097,
             var_yae097nex
       FROM ( SELECT YAE097
                FROM xasi2.ab02
               WHERE AAB001 = prm_aab001
                 AND AAB051 = '1'
              UNION
              SELECT AAE003 AS YAE097
                FROM wsjb.irab08
               WHERE AAB001 = prm_aab001
                 AND YAE517 = 'H01'
                 AND AAE140 = '01');
       IF var_yae097 = '999999' THEN
         prm_msg :=  prm_msg||'��ȡ��������ںų���';
        prm_sign := '1';
        GOTO label_OUT;
       END IF;
       ELSIF num_ab02count = 0 THEN
       SELECT count(1)
        INTO  num_count
        FROM wsjb.irab08
        WHERE AAB001 = prm_aab001
         AND YAE517 = 'H01'
         AND AAE140 = '01';
       IF num_count>0 THEN
       --��ȡ��λ��ǰ���������
       SELECT TO_CHAR(SYSDATE, 'yyyymm') SYS100,
             TO_CHAR(ADD_MONTHS(SYSDATE, 1), 'yyyymm') SYSNEX,
             TO_CHAR(NVL(MAX(YAE097), '999999')) IAA100,
             TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(NVL(MAX(YAE097),TO_CHAR(SYSDATE,'yyyymm'))),'yyyymm'),1),'yyyymm') NEX100
        INTO var_sysmonth,
             var_sysnexmonth,
             var_yae097,
             var_yae097nex
       FROM ( SELECT AAE003 AS YAE097
                FROM wsjb.irab08
               WHERE AAB001 = prm_aab001
                 AND YAE517 = 'H01'
                 AND AAE140 = '01');
       ELSIF num_count = 0 THEN
       SELECT TO_CHAR(SYSDATE,'yyyyMM')
         INTO var_yae097nex
         FROM dual;
       SELECT TO_CHAR(SYSDATE, 'yyyymm') SYS100,
             TO_CHAR(ADD_MONTHS(SYSDATE, 1), 'yyyymm') SYSNEX,
             TO_CHAR(ADD_MONTHS(SYSDATE,-1), 'yyyymm') IAA100
       INTO var_sysmonth,
             var_sysnexmonth,
             var_yae097
       FROM dual;
       END IF;
       END IF;
       --Ĭ����������ڵ���һ��
       prm_iaa100 := var_yae097nex;

       --��ȡ��λ����걨�¶�
        SELECT NVL(MAX(A.IAA100), '999999') IAA100,
              TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(NVL(MAX(A.IAA100),TO_CHAR(SYSDATE,'yyyymm'))),'yyyymm'),1),'yyyymm') NEX100
         INTO var_iaa100,
              var_iaa100nex
         FROM wsjb.irad01  A
        WHERE A.IAA011 = 'A04'
          AND A.AAB001 = prm_aab001;
      IF var_iaa100 = '999999' THEN --��û���걨������һ�ν�ϵͳ��
        IF var_yae097  <= var_sysmonth THEN
          prm_iaa100 := var_yae097nex;
           prm_msg :=  '��ǰ���걨���¶�Ϊ'||prm_iaa100||'��';
          prm_flag := '0';
          GOTO label_OUT;
        ELSE
          prm_iaa100 := var_yae097nex;
           prm_msg :=  '��δ�����걨ʱ�䣡';
          prm_flag := '5';
          GOTO label_OUT;
        END IF;
       END IF;

       --��������� �� ��ǰʱ���¶� �Ƚ�
       --��������� < ��ǰʱ���¶�
       IF var_yae097 < var_sysmonth THEN
         --��������� < ����걨�¶ȣ��Ѿ��걨��
         IF var_yae097 < var_iaa100 THEN

           --�Ƿ���ڴ����Ϣ
           SELECT count(1)
             INTO num_count
             FROM wsjb.irac01
            WHERE aab001 = prm_aab001
              AND iaa100 = var_iaa100
              AND iaa002 = '4';
           IF num_count > 0 THEN
             prm_iaa100 := var_iaa100;
             prm_msg :=  '�Ѿ��걨�¶�Ϊ��'||var_iaa100||'����Ա��Ϣ,���ڴ����Ϣ����Ҫ�޸����ݼ����걨!';
            prm_flag := '3';
            GOTO label_OUT;
           END IF;

           --�Ƿ��������
           SELECT count(1)
             INTO num_count
             FROM wsjb.irac01
            WHERE aab001 = prm_aab001
              AND iaa100 = var_iaa100
              AND iaa002 = '1';
           IF num_count > 0 THEN
             prm_iaa100 := var_iaa100;
             prm_msg :=  '�Ѿ��걨�¶�Ϊ��'||var_iaa100||'����Ա��Ϣ����������У�����������Ա����������';
            prm_flag := '2';
            GOTO label_OUT;
           END IF;

          --�Ƿ�˶�
          -- ��˰ƽ̨  20181224
       --   IF  to_number(var_iaa100) > 201812  THEN

          SELECT SUM(n)
            INTO num_count
            FROM ( SELECT COUNT(1) N
                     FROM xasi2.AB08 A
                    WHERE A.AAB001 = prm_aab001
                      AND A.YAE517 = 'H01'
                      AND A.AAE003 = var_iaa100
                   UNION ALL
                   SELECT COUNT(1) N
                     FROM xasi2.AB08A8 A
                    WHERE A.AAB001 = prm_aab001
                      AND A.YAE517 = 'H01'
                      AND A.AAE003 = var_iaa100
                   UNION ALL
                   SELECT COUNT(1) N
                     FROM wsjb.irab08  A
                    WHERE A.AAB001 = prm_aab001
                      AND A.YAE517 = 'H01'
                      AND A.AAE003 = var_iaa100 );
           IF num_count = 0 THEN
             prm_iaa100 := var_iaa100;
             prm_msg :=  '�Ѿ��걨�¶�Ϊ��'||var_iaa100||'����Ա��Ϣ����������У�����������Ա����������';
            prm_flag := '2';
            GOTO label_OUT;
           END IF;

       --  END IF;


         END IF;

         --��������� = ����걨�¶ȣ������걨��
         IF var_yae097 = var_iaa100 THEN
           prm_iaa100 := var_yae097nex;
           prm_msg :=  '��ǰ���걨���¶�Ϊ'||prm_iaa100||'��';
          prm_flag := '1';
          GOTO label_OUT;
         END IF;

        /*  201904��ǰ��
       ELSIF var_yae097 = var_sysmonth THEN --��������� = ��ǰʱ���¶� �������Ѿ��˶���ɣ�
         prm_iaa100 := var_yae097;
         prm_msg :=  prm_iaa100||'�¶ȣ��¶Ƚɷ��걨�����ɣ�';
        prm_flag := '4';
        */
          /*201904�Ժ��*/
        ELSIF var_yae097 = var_sysmonth THEN --��������� = ��ǰʱ���¶� ����������һ��������
        prm_msg :=  '���Խ���'||prm_iaa100||'�¶ȵ���Ա�����걨��';
        prm_flag := '6';
        GOTO label_OUT;
      ELSE
       -- prm_iaa100 := var_yae097;
        prm_msg :=  prm_iaa100||'�¶���Ա������δ���걨�ڣ�';
        prm_sign := '1';
        GOTO label_OUT;
       END IF;
       /*201904�Ժ��*/


    <<label_OUT>>
     num_count := 0;

   EXCEPTION
     WHEN OTHERS THEN
     /*�رմ򿪵��α�*/
     ROLLBACK;
     prm_AppCode  :=  gn_def_ERR;
     prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
     RETURN;
    END prc_p_ValidateMonthApply;
    /*--------------------------------------------------------------------------
   || ҵ�񻷽� ����λ�α�֤������Ȩ����֤
   || �������� ��prc_p_ValidateProveApply
   || �������� ��
   ||
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��zhujing          ������� ��2015-12-18
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateProveApply(
      prm_aab001          IN            VARCHAR2,     --��λ���
      prm_msg             OUT           VARCHAR2,     -- ������Ϣ
      prm_sign            OUT           VARCHAR2,     -- �����־
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2)    --������Ϣ

   IS
       num_count           NUMBER(6);
      var_aae003          VARCHAR2(23);--�ѿ�������
      var_aae003pre       VARCHAR2(23);--��ǰʱ�����һ���¶�
      var_aae003pre2       VARCHAR2(23);--��ǰʱ�����һ���¶�


   BEGIN
      /*��ʼ������*/
       prm_AppCode  := GN_DEF_OK;
       prm_ErrorMsg := '';
       prm_msg :='';
       prm_sign :='0';

    --�����ǰʱ�����15�ţ����жϵ����Ƿ��±�
    IF to_char(SYSDATE,'dd')>15 THEN
      var_aae003 := to_char(SYSDATE,'yyyymm');
      SELECT SUM(I)
        INTO num_count
        FROM (SELECT COUNT(1) AS I
                FROM wsjb.irab08
               WHERE YAE517 = 'H01'
                 AND AAB001 = prm_aab001
                 AND AAE003 = var_aae003
              UNION
              SELECT COUNT(1) AS I
                FROM xasi2.AB08
               WHERE YAE517 = 'H01'
                 AND AAB001 = prm_aab001
                 AND AAE003 = var_aae003
              UNION
              SELECT COUNT(1) AS I
                FROM xasi2.AB08A8
               WHERE YAE517 = 'H01'
                 AND AAB001 = prm_aab001
                 AND AAE003 = var_aae003);
      IF num_count = 0 THEN
         prm_msg :=  '��λ'||var_aae003||'�¶Ƚɷ��걨��δ��ɣ�����ɺ��ٽ����籣֤�����룡';
        prm_sign := '1';
        GOTO label_OUT;
      END IF;
    END IF;
    --�����Ƿ��±�
    var_aae003pre := to_char(add_months(SYSDATE,-1),'yyyyMM');
    SELECT SUM(I)
      INTO num_count
      FROM (SELECT COUNT(1) AS I
              FROM wsjb.irab08
             WHERE YAE517 = 'H01'
               AND AAB001 = prm_aab001
               AND AAE003 = var_aae003pre
            UNION
            SELECT COUNT(1) AS I
              FROM xasi2.AB08
             WHERE YAE517 = 'H01'
               AND AAB001 = prm_aab001
               AND AAE003 = var_aae003pre
            UNION
            SELECT COUNT(1) AS I
              FROM xasi2.AB08A8
             WHERE YAE517 = 'H01'
               AND AAB001 = prm_aab001
               AND AAE003 = var_aae003pre);
    IF num_count = 0 THEN
       prm_msg :=  '��λ'||var_aae003pre||'�¶Ƚɷ��걨��δ��ɣ�����ɺ��ٽ����籣֤�����룡';
      prm_sign := '1';
      GOTO label_OUT;
    END IF;
    --�жϵ�λ�Ƿ��ҽ�Ʊ��գ�������Σ�����ʵ�գ���ǰʱ����������£��ж�
    SELECT COUNT(1)
      INTO num_count
      FROM xasi2.AB02
     WHERE AAB001 = prm_aab001
       AND AAE140 = '03'
       AND AAB051 = '1';
    IF num_count > 0 THEN
      --��ǰ�µ���������
      var_aae003pre2 := to_char(add_months(SYSDATE,-2),'yyyyMM');
      --��������ҽ���Ƿ�ʵ��
      SELECT COUNT(1) AS I
        INTO num_count
        FROM xasi2.AB08A8
       WHERE YAE517 = 'H01'
         AND AAE140 = '03'
         AND AAB001 = prm_aab001
         AND AAE003 = var_aae003pre2;
      IF num_count = 0 THEN
        prm_msg :=  '��λ'||var_aae003pre2||'ҽ�Ʊ���������δ���ˣ����ȵ��籣���ľ�������˶Ժ��ٽ��г��ߣ�';
        prm_sign := '1';
        GOTO label_OUT;
      END IF;
    END IF;

    --�жϵ�λ�Ƿ���ڴ���˵��±���¼
    SELECT SUM(C) AS C
      INTO num_count
      FROM (SELECT COUNT(1) AS C
              FROM (SELECT (SELECT COUNT(1)
                              FROM xasi2.ab08
                             WHERE AAB001 = B.AAB001
                               AND AAE003 = B.IAA100
                               AND YAE517 = 'H01') +
                           (SELECT COUNT(1)
                              FROM xasi2.ab08a8
                             WHERE AAB001 = B.AAB001
                               AND AAE003 = B.IAA100
                               AND YAE517 = 'H01') +
                           (SELECT COUNT(1)
                              FROM wsjb.irab08
                             WHERE AAB001 = B.AAB001
                               AND AAE003 = B.IAA100
                               AND YAE517 = 'H01') AAE003
                      FROM wsjb.irab01  A, wsjb.irad01  B
                     WHERE A.AAB001 = B.AAB001
                       AND A.AAB001 = A.IAB001
                       AND A.IAA002 = '2'
                       AND B.IAA011 = 'A04'
                       AND A.AAB001 = prm_aab001
                       AND NOT EXISTS (SELECT IAZ004
                              FROM wsjb.irad02 , wsjb.irac01  C
                             WHERE IAZ004 = B.IAZ004
                               AND IAZ007 = C.IAC001
                               AND C.IAA002 IN ('1', '4')))
               WHERE AAE003 = 0
              UNION ALL
              SELECT COUNT(1) AS C
                FROM wsjb.irab01  A, wsjb.irad01  B
               WHERE A.AAB001 = B.AAB001
                 AND A.AAB001 = A.IAB001
                 AND A.IAA002 = '2'
                 AND B.IAA011 = 'A04'
                 AND A.AAB001 = prm_aab001
                 AND EXISTS (SELECT IAZ004
                        FROM wsjb.irad02 , wsjb.irac01  C
                       WHERE IAZ004 = B.IAZ004
                         AND IAZ007 = C.IAC001
                         AND C.IAA002 IN ('1', '4')));
     IF num_count > 0 THEN
         prm_msg :=  '��λ�¶Ƚɷ��걨δ�����ɣ��������ɺ��ٽ���֤�����ߡ�';
        prm_sign := '1';
        GOTO label_OUT;
     END IF;

    <<label_OUT>>
     num_count := 0;

   EXCEPTION
     WHEN OTHERS THEN
     /*�رմ򿪵��α�*/
     ROLLBACK;
     prm_AppCode  :=  gn_def_ERR;
     prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
     RETURN;
   END prc_p_ValidateProveApply;

    /*--------------------------------------------------------------------------
   || ҵ�񻷽� ��У��α���Ա�Ƿ��������ĳһ������
   || �������� prc_p_ValidateAddKindYesOrNo
   || �������� ��У����������
   ||
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��ycliu         ������� ��2017-02-15
   ||------------------------------------------------------------------------*/
  PROCEDURE prc_p_ValidateAddKindYesOrNo(prm_aab001   IN VARCHAR2, --��λ���
                                         prm_aac001   IN VARCHAR2, --���˱��
                                         prm_aae140   IN VARCHAR2, --����
                                         prm_yab139   IN VARCHAR2, --�������
                                         prm_flag     OUT VARCHAR2, --����״̬��־
                                         prm_msg      OUT VARCHAR2, --��ʾ��Ϣ
                                         prm_AppCode  OUT VARCHAR2, --ִ�д���
                                         prm_ErrorMsg OUT VARCHAR2) --������Ϣ
   IS
    v_flag   varchar2(1);
    v_msg    varchar2(4500);
    v_yon    varchar2(9);
    v_aab001 irac01.aab001%TYPE;
    v_aac031 irac01.aac031%TYPE;
  BEGIN
    --��ʼ������
    prm_AppCode  := GN_DEF_OK;
    prm_ErrorMsg := '';
    v_flag   := '0'; --����(0--������1--����2--����)
    v_msg    := '';
    v_yon    := '';
    v_aab001 := '';
    v_aac031 := '0'; --Ĭ��δ�α�

    --�жϸõ�λ�Ƿ�μӴ�����

    BEGIN
      select 1
        into v_yon
        from (select b.aae140
                from xasi2.ab02 b
               where 1 = 1
                 and b.aab001 = prm_aab001
                 and b.aab051 = '1'
              union
              select '01' as aae140
                from wsjb.irab01  a
               where a.iab001 = a.aab001
                 and a.iaa002 = '2'
                 and a.aab001 = prm_aab001
                 and a.aae110 = '1') r
       where r.aae140 = prm_aae140;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_flag := '1';
        v_msg  := '��λû�вμ�' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  ',�������������֣�';
        goto label_out;
      WHEN TOO_MANY_ROWS THEN
        v_flag := '1';
        v_msg  := '��λ�ҵ�����' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  '�α���¼,����ϵ�籣���ģ�';
        goto label_out;
      WHEN OTHERS THEN
        v_flag := '1';
        v_msg  := 'δ֪��������ϵϵͳά����Ա��';
        goto label_out;
    END;

    if v_yon <> '1' then
      v_flag := '1';
      v_msg  := '��λû�вμ�' ||
                xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                ',�������������֣�';
      goto label_out;
    end if;

    if prm_aae140 = '04' then
      begin
        select r.aab001, r.aac031
          into v_aab001, v_aac031
          from (select a.aab001, a.aae140, a.aac031
                  from xasi2.ac02 a
                 where a.aac001 = prm_aac001
                union
                select b.aab001,
                       '01' as aae140,
                       decode(b.aae110, '2', '1', '21', '2', '0', '') as aac031
                  from wsjb.irac01a3  b
                 where b.aac001 = prm_aac001
                   and b.aae110 = '2') r
         where r.aae140 = prm_aae140
           and r.aab001 = prm_aab001;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_flag := '0';
          goto label_out;
      end;

      if v_aab001 is not null or v_aac031 = '1' then
        v_flag := '1';
        v_msg  := '�����Ѿ��ڱ���λ��' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  'Ϊ'||xasi2.pkg_comm.fun_getAaa103('AAC031', v_aac031)||'״̬��';
        goto label_out;
      end if;

      /*begin
        select r.aab001, r.aac031
          into v_aab001, v_aac031
          from (select a.aab001, a.aae140, a.aac031
                  from xasi2.ac02 a
                 where a.aac001 = prm_aac001
                union
                select b.aab001,
                       '01' as aae140,
                       decode(b.aae110, '2', '1', '21', '2', '0', '') as aac031
                  from irac01a3 b
                 where b.aac001 = prm_aac001
                   and b.aae110 = '2') r
         where r.aae140 = prm_aae140
           and r.aab001 <> prm_aab001;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_flag := '0';
          goto label_out;
      end;

      if v_aab001 is not null or v_aac031 = '1' then
        v_flag := '1';
        v_msg  := '�����Ѿ���' || v_aab001 || '��λ�μ���' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  ',�������������֣�';
        goto label_out;
      end if;*/
    else

      --�ж���Ա�������Ƿ������α�
      BEGIN
        select r.aab001, r.aac031
          into v_aab001, v_aac031
          from (select a.aab001, a.aae140, a.aac031
                  from xasi2.ac02 a
                 where a.aac001 = prm_aac001
                union
                select b.aab001,
                       '01' as aae140,
                       decode(b.aae110, '2', '1', '21', '2', '0', '') as aac031
                  from wsjb.irac01a3  b
                 where b.aac001 = prm_aac001
                   and b.aae110 = '2') r
         where r.aae140 = prm_aae140;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_flag := '0';
          goto label_out;
        WHEN TOO_MANY_ROWS THEN
          v_flag := '1';
          v_msg  := '�����ҵ�����' ||
                    xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                    '�α���¼,����ϵ�籣���ģ�';
          goto label_out;
        WHEN OTHERS THEN
          v_flag := '1';
          v_msg  := 'δ֪��������ϵϵͳά����Ա��';
          goto label_out;
      END;

      if v_aab001 is not null or v_aac031 is not null then
        v_flag := '1';
        v_msg  := '�����Ѿ���' || v_aab001 || '��λ��' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  'Ϊ'||xasi2.pkg_comm.fun_getAaa103('AAC031', v_aac031)||'״̬��';
        goto label_out;
      end if;
    end if;

    <<label_out>>
    prm_flag := v_flag;
    prm_msg  := v_msg;

  EXCEPTION
    WHEN OTHERS THEN
      /*�رմ򿪵��α�*/
      ROLLBACK;
      prm_AppCode  := gn_def_ERR;
      prm_ErrorMsg := '���ݿ����:' || SQLERRM;
      RETURN;
  END prc_p_ValidateAddKindYesOrNo;

--У��������Ա��������
PROCEDURE prc_p_ValidKindsBatchAddCheck(PRM_IAZ018 IN VARCHAR2,
                                       PRM_AAB001   IN VARCHAR2,
                                       PRM_IAA100   IN VARCHAR2,
                                       PRM_APPCODE  OUT VARCHAR2,
                                       PRM_ERRORMSG OUT VARCHAR2) IS
  v_aac001      irac01.aac001%TYPE;
  v_flag        varchar2(3);
  v_msg         varchar2(4500);
  v_aaa010      number(14, 2);
  v_aac004      irac01.aac004%TYPE;
  v_aac005      irac01.aac005%TYPE;
  v_aac006      date;
  v_aac007      date;
  v_aac008      irac01.aac008%TYPE;
  v_aac009      irac01.aac009%TYPE;
  v_aac013      irac01.aac013%TYPE;
  v_yac033      date;
  v_yac005      number(14, 2);
  v_yac004      number(14, 2);
  var_15aac002  irac01.aac002%TYPE;
  var_aac002Low irac01.aac002%TYPE;
  num_count     number(6);
  v_aac040_old  number(14, 2);
  v_aae210       irac01.aae210%TYPE;
  v_aae310       irac01.aae310%TYPE;
  v_aae410       irac01.aae410%TYPE;
  v_aae510       irac01.aae510%TYPE;
  v_aae311       irac01.aae311%TYPE;
  v_aae120       irac01.aae120%TYPE;
  cursor cur_temp is
    SELECT a.iaz018,
       a.iaa001,
       a.iaa002,
       a.aac001,
       a.aab001,
       a.yae181,
       a.yac067,
       a.aac002,
       a.aac003,
       a.aac004,
       a.aac005,
       a.aac006,
       a.aac007,
       a.aac008,
       a.aac009,
       a.aac010,
       a.aac011,
       a.aac012,
       a.aac013,
       a.aac014,
       a.aac015,
       a.aac020,
       a.yac168,
       a.yac197,
       a.yac502,
       a.yae407,
       a.yae496,
       a.yic067,
       a.aae004,
       a.aae005,
       a.aae006,
       a.aae007,
       a.yae222,
       a.yac200,
       a.aae110,
       a.aac031,
       a.yac505,
       a.yac033,
       a.aac030,
       a.yae102,
       a.yae097,
       a.yac503,
       a.aac040,
       a.yac004,
       a.yaa333,
       a.yab013,
       a.yac002,
       a.yab139,
       a.aae011,
       a.aae036,
       a.yab003,
       a.aae013,
       a.aaz002,
       a.aae120,
       a.aae210,
       a.aae310,
       a.aae410,
       a.aae510,
       a.aae311,
       a.akc021,
       a.ykc150,
       a.ykb109,
       a.aic162,
       a.yac005,
       a.aae100,
       a.errormsg,
       a.aac021,
       a.aac022,
       a.aac025,
       a.aac026,
       a.aae810,
       a.iaa100,
       a.aae009,
       a.aae008,
       a.aae010,
       a.yad050
       FROM wsjb.tmp_irac01a2 a
       WHERE iaz018 = prm_iaz018;

BEGIN
  prm_AppCode  := GN_DEF_OK;
  prm_ErrorMsg := '';
  v_aaa010   := 0;

  IF prm_aab001 IS NULL THEN
    prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
    prm_ErrorMsg := 'prm_aab001��λ��Ų���Ϊ�գ�';
    RETURN;
  END IF;

  IF PRM_IAA100 IS NULL THEN
    prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
    prm_ErrorMsg := 'prm_iaa100�걨�¶Ȳ���Ϊ�գ�';
    RETURN;
  END IF;

  --��ȡ���ʡ����͹���
  SELECT aaa010
    into v_aaa010
    FROM xasi2.AA02A1
   WHERE YAB139 = '610127'
     AND AAE001 = substr(prm_iaa100, 0, 4)
     AND YAA001 = '13';

  FOR REC_TEMP IN CUR_TEMP LOOP
    v_aae210  :='0';
    v_aae310  :='0';
    v_aae410  :='0';
    v_aae510  :='0';
    v_aae311  :='0';
    v_aae120  :='0';

    v_flag       := '0'; --У���־��0-������1-����2 -���棩
    v_msg        := '';
    num_count    := 0;
    v_aac040_old := 0;

    --��ȡ������ʽ��֤������
    var_15aac002  := SUBSTR(rec_temp.aac002, 1, 6) ||
                     SUBSTR(rec_temp.aac002, 9, 9);
    var_aac002Low := LOWER(rec_temp.aac002);

    SELECT count(1)
      INTO num_count
      FROM xasi2.ac01 A
     WHERE AAE120 = '0'
       AND A.AAC002 IN (var_15aac002, var_aac002Low, rec_temp.aac002)
       and replace(a.aac003, ' ', '') = rec_temp.aac003
       AND AAC003 NOT LIKE '%�ظ�%';

    IF num_count = 0 THEN
      v_msg  := '֤����Ϊ��[' || rec_temp.aac002 ||
                ']����Ա�����ڸ�����Ϣ�����������������²α�ģ���������';
      v_flag := '1';
    END IF;
    IF num_count > 1 THEN
      v_msg  := '֤����Ϊ��[' || rec_temp.aac002 || ']����Ա���ڶ���������Ϣ��������ϵ�籣���ģ�';
      v_flag := '1';
    END IF;

    begin
      SELECT aac001
        INTO v_aac001
        FROM xasi2.ac01 A
       WHERE AAE120 = '0'
         AND A.AAC002 IN (var_15aac002, var_aac002Low, rec_temp.aac002)
         and replace(a.aac003, ' ', '') = rec_temp.aac003
         AND AAC003 NOT LIKE '%�ظ�%';
    exception
      when no_data_found then
        v_flag := '1';
        v_msg  := '֤����Ϊ��[' || rec_temp.aac002 ||
                  ']����Ա�����ڸ�����Ϣ�����������������²α�ģ���������';
    end;

    if v_flag = '0' then
      pkg_p_validate.prc_p_ValidateAac002KindAdd('1',
                                                 rec_temp.aac002,
                                                 prm_aab001,
                                                 prm_iaa100,
                                                 v_aac001,
                                                 v_msg,
                                                 v_flag,
                                                 prm_AppCode,
                                                 prm_ErrorMsg);
    end if;

   /* if v_flag = '0' and rec_temp.aac040 < v_aaa010 then
      v_flag := '1';
      v_msg  := '�걨���ʵ�������ʡ��͹��ʱ�׼' || v_aaa010 || '!';
    end if;*/

    if v_flag = '0' then
      SELECT to_number(MIN(AAC040))
        into v_aac040_old
        FROM (SELECT AAC040
                FROM xasi2.AC02
               WHERE AAB001 = prm_aab001
                 AND AAC001 = v_aac001
                 AND AAE140 NOT IN ('06', '07', '08')
                 and aac031 = '1'
              UNION ALL
              SELECT AAC040
                FROM wsjb.irac01a3
               WHERE AAB001 = prm_aab001
                 AND AAC001 = v_aac001
                 AND AAE110 = '2');
      if v_aac040_old != rec_temp.aac040 then
        v_flag := '1';
        v_msg  := '�걨����' || rec_temp.aac040 || '��֮ǰ�α�����' || v_aac040_old ||
                  '��һ��!';
      end if;
    end if;

    if v_flag = '0' and rec_temp.aae110 = '1' then
      prc_p_ValidateAddKindYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '01',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae210 = '1' then
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aab001 = prm_aab001 AND aae140='02' AND aac031='1';
      IF num_count = 0 THEN
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aae140='02' AND aac031='2';
      IF num_count =0 THEN
       v_aae210 :='1';
       ELSIF num_count =1 THEN
       v_aae210 :='10';
       END IF;
      ELSIF num_count = 1 THEN
      v_aae210 :='2';
      END IF;
    end if;

    if v_flag = '0' and rec_temp.aae310 = '1' then
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aab001 = prm_aab001 AND aae140='03' AND aac031='1';
      IF num_count = 0 THEN
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aae140='02' AND aac031='2';
      IF num_count =0 THEN
       v_aae310 :='1';
       ELSIF num_count =1 THEN
       v_aae310 :='10';
       END IF;
      ELSIF num_count = 1 THEN
      v_aae310 :='2';
      END IF;
    end if;

    if v_flag = '0' and rec_temp.aae410 = '1' then
       SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aab001 = prm_aab001 AND aae140='04' AND aac031='1';
      IF num_count = 0 THEN
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aae140='02' AND aac031='2';
      IF num_count =0 THEN
       v_aae410 :='1';
       ELSIF num_count =1 THEN
       v_aae410 :='10';
       END IF;
      ELSIF num_count = 1 THEN
      v_aae410 :='2';
      END IF;
    end if;

    if v_flag = '0' and rec_temp.aae510 = '1' then
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aab001 = prm_aab001 AND aae140='05' AND aac031='1';
      IF num_count = 0 THEN
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aae140='02' AND aac031='2';
      IF num_count =0 THEN
       v_aae510 :='1';
       ELSIF num_count =1 THEN
       v_aae510 :='10';
       END IF;
      ELSIF num_count = 1 THEN
      v_aae510 :='2';
      END IF;
    end if;

    if v_flag = '0' and rec_temp.aae120 = '1' then
       SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aab001 = prm_aab001 AND aae140='06' AND aac031='1';
      IF num_count = 0 THEN
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aae140='02' AND aac031='2';
      IF num_count =0 THEN
       v_aae120 :='1';
       ELSIF num_count =1 THEN
       v_aae120 :='10';
       END IF;
      ELSIF num_count = 1 THEN
      v_aae120 :='2';
      END IF;
    end if;

    if v_flag = '0' and rec_temp.aae311 = '1' then
       SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aab001 = prm_aab001 AND aae140='07' AND aac031='1';
      IF num_count = 0 THEN
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aae140='02' AND aac031='2';
      IF num_count =0 THEN
       v_aae311 :='1';
       ELSIF num_count =1 THEN
       v_aae311 :='10';
       END IF;
      ELSIF num_count = 1 THEN
      v_aae311 :='2';
      END IF;
    end if;

    if v_flag = '0' and rec_temp.aae810 = '1' then
      prc_p_ValidateAddKindYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '08',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae110 = '1' and rec_temp.aae120 = '1' then
      v_flag := '1';
      v_msg  := '��ҵ���Ϻͻ����������ֲ���ͬʱ�α���';
    end if;

    if v_flag is null then
      v_flag := '0';
    end if;

    if v_msg is null then
      v_msg := '';
    end if;

    if v_flag = '0' then

      SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,
                                                             prm_aab001,
                                                             rec_temp.aac040,
                                                             '0',
                                                             decode(rec_temp.aae310,
                                                                    '1',
                                                                    '03',
                                                                    '04'),
                                                             '1',
                                                             '1',
                                                             prm_iaa100,
                                                             '610127'))
        into v_yac005
        FROM dual;

      if rec_temp.aae110 = '1' OR rec_temp.aae110 ='10' then
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,
                                                               prm_aab001,
                                                               rec_temp.aac040,
                                                               '0',
                                                               '01',
                                                               '1',
                                                               '1',
                                                               prm_iaa100,
                                                               '610127'))
          into v_yac004
          FROM dual;
      elsif rec_temp.aae120 = '1' then
        v_yac004 := rec_temp.aac040;
      else
        v_yac004 := 0;
      end if;

      select a.aac004,
             a.aac005,
             a.aac006,
             a.aac007,
             a.aac008,
             a.aac009,
             a.aac013
        into v_aac004,
             v_aac005,
             v_aac006,
             v_aac007,
             v_aac008,
             v_aac009,
             v_aac013
        from xasi2.ac01 a
       where a.aae120 = '0'
         and a.aac001 = v_aac001;

      select min(yac033)
        into v_yac033
        from xasi2.ac02
       where aac001 = v_aac001;

      update wsjb.tmp_irac01a2  a
         set a.aae100 = '0',
             a.errormsg = a.errormsg||v_msg,
             a.iaa100    = '',
             a.aac001    = v_aac001,
             a.aab001    = prm_aab001,
             a.yac004    = v_yac004,
             a.yac005    = v_yac005,
             a.aae210    = v_aae210,
             a.aae310     = v_aae310,
             a.aae410     = v_aae410,
             a.aae510     = v_aae510,
             a.aae311     = v_aae311
       where a.iaz018 = prm_iaz018
       AND    a.aac002 = rec_temp.aac002;

      if sql%rowcount = 0 then
        prm_appcode  := PRE_ERRCODE || GN_DEF_ERR;
        prm_errormsg := 'prc_p_ValidKindBatchAddCheck����,����ԭ��:û�и��µ�У������Ϣ��';
        return;
      end if;

      if sql%rowcount > 1 then
        prm_appcode  := PRE_ERRCODE || GN_DEF_ERR;
        prm_errormsg := 'prc_p_ValidKindBatchAddCheck����,����ԭ��:���µ�����У������Ϣ��';
        return;
      end if;
    else
      update wsjb.tmp_irac01a2  a
         set a.aae100 = '1',
             a.errormsg = a.errormsg||v_msg,
             a.iaa100    = '',
             a.aab001    = prm_aab001,
             a.aac001    = v_aac001,
             a.yac004    = v_yac004,
             a.yac005    = v_yac005,
             a.aae210    = v_aae210,
             a.aae310     = v_aae310,
             a.aae410     = v_aae410,
             a.aae510     = v_aae510,
             a.aae311     = v_aae311
       where a.iaz018 = prm_iaz018
       AND    a.aac002 = rec_temp.aac002;

      if sql%rowcount = 0 then
        prm_appcode  := PRE_ERRCODE || GN_DEF_ERR;
        prm_errormsg := 'prc_p_ValidKindBatchAddCheck����,����ԭ��:û�и��µ�У������Ϣ��';
        return;
      end if;

      if sql%rowcount > 1 then
        prm_appcode  := PRE_ERRCODE || GN_DEF_ERR;
        prm_errormsg := 'prc_p_ValidKindBatchAddCheck����,����ԭ��:���µ�����У������Ϣ��';
        return;
      end if;
    end if;

  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    PRM_APPCODE  := PRE_ERRCODE || GN_DEF_ERR;
    PRM_ERRORMSG := 'prc_p_ValidKindBatchAddCheck����,����ԭ��:' || SQLERRM ||
                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
    RETURN;
END prc_p_ValidKindsBatchAddCheck;

 --У��������Ա����
PROCEDURE prc_p_ValidBatchContinueCheck(PRM_IAZ018 IN VARCHAR2,
                                       PRM_AAB001   IN VARCHAR2,
                                       PRM_IAA100   IN VARCHAR2,
                                       PRM_APPCODE  OUT VARCHAR2,
                                       PRM_ERRORMSG OUT VARCHAR2) IS
  v_aac001      irac01.aac001%TYPE;
  v_flag        varchar2(3);
  prm_flag      VARCHAR2(3);
  v_msg         varchar2(4500);
  v_aaa010      number(14, 2);
  v_aac004      irac01.aac004%TYPE;
  v_aac005      irac01.aac005%TYPE;
  v_aac006      date;
  v_aac007      date;
  v_aac008      irac01.aac008%TYPE;
  v_aac009      irac01.aac009%TYPE;
  v_aac013      irac01.aac013%TYPE;
  v_yac033      date;
  v_yac005      number(14, 2);
  v_yac004      number(14, 2);
  var_15aac002  irac01.aac002%TYPE;
  var_aac002Low irac01.aac002%TYPE;
  num_count     number(6);
  v_aac040_old  number(14, 2);
  v_ab02aae210  irac01.aae210%TYPE;
  v_ab02aae310  irac01.aae310%TYPE;
  v_ab02aae410  irac01.aae410%TYPE;
  v_ab02aae510  irac01.aae510%TYPE;
  v_ab02aae311  irac01.aae311%TYPE;
  v_aae210      irac01.aae210%TYPE;
  v_aae310      irac01.aae310%TYPE;
  v_aae410      irac01.aae410%TYPE;
  v_aae510      irac01.aae510%TYPE;
  v_aae311      irac01.aae311%TYPE;
  v_aac012      irac01.aac012%TYPE; 
  n_ac02count    NUMBER;
  n_ab02count    NUMBER;
  COUNT_JM       NUMBER;
  Count_ZG       NUMBER;
  var_18aac002   irac01.aac002%TYPE;
  var_aac003     irac01.aac003%TYPE;
  var_aac001_more   irac01.aac001%TYPE;
  VAR_AAB004     irab01.aab004%TYPE;
   nl_aac006        NUMBER;
   sj_months        NUMBER;
   xb_aac004      irac01.aac004%TYPE;
   man_months    NUMBER;
   woman_months    NUMBER;
   zy_aac008     irac01.aac008%TYPE;
   zy_akc021     irac01.akc021%TYPE;
  v_errmsg      VARCHAR2(4500);
  yl_count  NUMBER;
  X            VARCHAR2(6);
  var_aac006   irac01.aac006%TYPE;
  woman_worker_months  NUMBER;
  var_aae110     VARCHAR2(9); 
  cursor cur_temp is
    SELECT a.iaz018,
       a.iaa001,
       a.iaa002,
       a.aac001,
       a.aab001,
       a.yae181,
       a.yac067,
       a.aac002,
       a.aac003,
       a.aac004,
       a.aac005,
       a.aac006,
       a.aac007,
       a.aac008,
       a.aac009,
       a.aac010,
       a.aac011,
       a.aac012,
       a.aac013,
       a.aac014,
       a.aac015,
       a.aac020,
       a.yac168,
       a.yac197,
       a.yac502,
       a.yae407,
       a.yae496,
       a.yic067,
       a.aae004,
       a.aae005,
       a.aae006,
       a.aae007,
       a.yae222,
       a.yac200,
       a.aae110,
       a.aac031,
       a.yac505,
       a.yac033,
       a.aac030,
       a.yae102,
       a.yae097,
       a.yac503,
       a.aac040,
       a.yac004,
       a.yaa333,
       a.yab013,
       a.yac002,
       a.yab139,
       a.aae011,
       a.aae036,
       a.yab003,
       a.aae013,
       a.aaz002,
       a.aae120,
       a.aae210,
       a.aae310,
       a.aae410,
       a.aae510,
       a.aae311,
       a.akc021,
       a.ykc150,
       a.ykb109,
       a.aic162,
       a.yac005,
       a.aae100,
       a.errormsg,
       a.aac021,
       a.aac022,
       a.aac025,
       a.aac026,
       a.aae810,
       a.iaa100,
       a.aae009,
       a.aae008,
       a.aae010,
       a.yad050
       FROM wsjb.tmp_irac01a2 a
       WHERE iaz018 = prm_iaz018;
  cursor cur_ab02 IS SELECT * FROM xasi2.ab02 WHERE aab001=prm_aab001 AND aab051='1';

  cursor cur_ac01 IS SELECT *   FROM xasi2.ac01 A
      WHERE AAE120 = '0'
       AND A.AAC002 IN (var_15aac002, var_aac002Low, var_18aac002)
       and replace(a.aac003, ' ', '') = var_aac003
       AND AAC003 NOT LIKE '%�ظ�%';

BEGIN
  prm_AppCode  := GN_DEF_OK;
  prm_ErrorMsg := '';
  v_aaa010   := 0;
  man_months := 720;
  woman_months := 660;
  woman_worker_months :=600;

  SELECT count(1) INTO n_ab02count FROM xasi2.ab02 WHERE aab001=prm_aab001 AND aab051='1';
  IF prm_iaz018 IS NULL THEN
    prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
    prm_ErrorMsg := '��ˮ�Ų���Ϊ�գ�';
    RETURN;
  END IF;
  IF prm_aab001 IS NULL THEN
    prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
    prm_ErrorMsg := 'prm_aab001��λ��Ų���Ϊ�գ�';
    RETURN;
  END IF;

  IF PRM_IAA100 IS NULL THEN
    prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
    prm_ErrorMsg := 'prm_iaa100�걨�¶Ȳ���Ϊ�գ�';
    RETURN;
  END IF;

  --��ȡ���ʡ����͹���
  SELECT aaa010
    into v_aaa010
    FROM xasi2.AA02A1
   WHERE YAB139 = '610127'
     AND AAE001 = substr(prm_iaa100, 0, 4)
     AND YAA001 = '13';

  FOR REC_TEMP IN CUR_TEMP LOOP
    v_flag       := '0'; --У���־��0-������1-����2 -���棩
    v_msg        := '';
    num_count    := 0;
    v_aac040_old := 0;
    v_aae310     := rec_temp.aae310;
    v_aae510     := rec_temp.aae510;
    v_aae311     := rec_temp.aae311;
    var_aac006   := rec_temp.aac006;
    var_aae110   := rec_temp.aae110;
    xb_aac004    := rec_temp.aac004;
    v_aac012     := rec_temp.aac012;
     

      SELECT count(1)
     INTO num_count
    FROM  wsjb.tmp_irac01a2
    WHERE aac002 = rec_temp.aac002;
    IF num_count >1 THEN
    v_msg  := v_errmsg||'���֤��Ϊ'||rec_temp.aac002||'����Ϊ'||rec_temp.aac003||'�����ظ�������Ϣ�����ظ����ӣ�'||v_msg;
    v_flag := '1';
    END IF;
    --��ȡ������ʽ��֤������
    var_15aac002  := SUBSTR(rec_temp.aac002, 1, 6) ||
                     SUBSTR(rec_temp.aac002, 9, 9);
    var_aac002Low := LOWER(rec_temp.aac002);

    var_18aac002  := rec_temp.aac002;

    var_aac003   := rec_temp.aac003;

    SELECT count(1)
      INTO num_count
      FROM xasi2.ac01 A
     WHERE AAE120 = '0'
       AND A.AAC002 IN (var_15aac002, var_aac002Low, rec_temp.aac002)
       and replace(a.aac003, ' ', '') = rec_temp.aac003
       AND AAC003 NOT LIKE '%�ظ�%';

    /*IF num_count = 0 THEN
     SELECT count(1)
      INTO num_count
      FROM sjxt.AC01 A
     WHERE AAE120 = '0'
       AND A.AAC002 IN (var_15aac002, var_aac002Low, rec_temp.aac002)
       and replace(a.aac003, ' ', '') = rec_temp.aac003
       AND AAC003 NOT LIKE '%�ظ�%';
       IF num_count = 0 THEN
      v_msg  := v_errmsg||v_msg|| '֤����Ϊ��[' || rec_temp.aac002 ||
                ']����Ա�����ڸ�����Ϣ�����������������²α�ģ���������';
      v_flag := '1';
      ELSIF num_count > 1 THEN
      v_msg  :=  v_errmsg||v_msg||'֤����Ϊ��[' || rec_temp.aac002 || ']����Ա���ڶ���������Ϣ��������ϵ�籣���ģ�';
      v_flag := '1';
    END IF;*/




     IF num_count = 1  THEN


    SELECT aac001
        INTO v_aac001
        FROM xasi2.ac01 A
       WHERE AAE120 = '0'
         AND A.AAC002 IN (var_15aac002, var_aac002Low, rec_temp.aac002)
         and replace(a.aac003, ' ', '') = rec_temp.aac003
         AND AAC003 NOT LIKE '%�ظ�%';

     END  IF ;

     IF   num_count > 1 THEN

           v_msg := '�����֤���Ѿ����ڶ��ҽ�����,���ڵ�������ģ�������';
           v_flag :='1';

     END  IF;

         IF num_count =1 THEN

           select to_number(to_char(min(aac006),'yyyymm')),aac004,aac008   INTO nl_aac006 ,xb_aac004,zy_aac008
            from xasi2.ac01
           where aac002 IN (var_15aac002, var_aac002Low,var_18aac002)
             AND AAC003 NOT LIKE '%�ظ�%'
             AND rownum = 1
             group by aac004 , aac008;

           select trunc(months_between(sysdate,to_date(nl_aac006,'yyyymm'))) INTO sj_months from dual;

           --  ����������Ա  ac01   aac008  2   kc01  akc021 11
             
           select count(1)
             into yl_count from wsjb.irac01a7_yl
            where aae123 = '2'
              and aac002  IN (var_15aac002, var_aac002Low,var_18aac002);
                   
      IF  yl_count = 0 THEN
     

        IF xb_aac004 = '1' and xb_aac004 IS NOT NULL  and  sj_months >=  man_months  THEN


           select akc021  INTO  zy_akc021 from xasi2.kc01    where aac001 = v_aac001;
         
           
               IF   zy_aac008 = 2 and  zy_akc021 =11 THEN
                  --  ����ҵ����
                 select akc021  INTO  zy_akc021 from xasi2.kc01   where aac001 = v_aac001;

                ELSIF  (xb_aac004 = '1' and xb_aac004 IS NOT NULL  and  sj_months >=  man_months)   THEN

                   v_flag := '1';
                   v_msg  := '����Ա��ͳ�����Ҫ��������ͣ�';

               END IF;
          END IF;



          IF xb_aac004 = '2' and xb_aac004 IS NOT NULL  and  sj_months >=  woman_months  THEN
            IF   zy_aac008 = 2 and  zy_akc021 =11 THEN
               --  ����ҵ����
             select akc021  INTO  zy_akc021 from xasi2.kc01   where aac001 = v_aac001;
              ELSIF    (xb_aac004 = '2' and xb_aac004 IS NOT NULL  and  sj_months >=  woman_months)  THEN
                
              v_flag := '1';
              v_msg  := '����Ա��ͳ�����Ҫ��������ͣ�';
            END IF;
         END IF;
         
        END IF ; --  ���ϼ����ɷѱ�־
          
          
        -- begin 20190703  
       select to_number(to_char(min(aac006),'yyyymm'))    INTO nl_aac006  
            from xasi2.ac01
           where aac002 IN (var_15aac002, var_aac002Low,var_18aac002)
             AND AAC003 NOT LIKE '%�ظ�%'
             AND rownum = 1
            ;

           select trunc(months_between(sysdate,to_date(nl_aac006,'yyyymm'))) INTO sj_months from dual;
           
         IF   var_aae110 = '1' and  xb_aac004 = '2' and xb_aac004 IS NOT NULL  THEN --  �����״βα�
                select X INTO X from dual;
         
             --  ����ɲ�  55 4  ���� 50  1  ���Ů��   
                 IF   sj_months > woman_worker_months  and v_aac012 = '1' THEN
                      v_flag := '1';
                      v_msg  := '����Ա�������Ϊ���ˣ�������Ҫ��������ͣ�';
                     
                 ELSIF   sj_months >=  woman_months and  v_aac012 = '4'  THEN
                      v_flag := '1';
                      v_msg  := '����Ա�������Ϊ�ɲ���������Ҫ��������ͣ�';
                      
                 END IF;
             
             END IF;
   
          -- end  20190708
         
      END IF;


     IF  num_count >= 1 THEN

       --ѭ��У��ac01
        FOR rec_cur_ac01 IN cur_ac01 LOOP
    --  BEGIN
         SELECT aac001 INTO var_aac001_more   FROM xasi2.ac01 A
         WHERE AAE120 = '0'
         AND A.aac001 = rec_cur_ac01.aac001
         AND A.AAC002 IN (var_15aac002, var_aac002Low, rec_cur_ac01.aac002)
         and replace(a.aac003, ' ', '') = rec_cur_ac01.aac003
         AND AAC003 NOT LIKE '%�ظ�%';
      --  EXCEPTION
         --    WHEN others THEN
           IF var_aac001_more IS NULL  OR var_aac001_more = '' THEN
             v_msg := v_errmsg||v_msg||'��ȡ�������˱��!';
             v_flag  := '1';
            END IF;
         --  RETURN;
     --  END;

          SELECT COUNT(1)
        INTO COUNT_JM
        FROM XASI2.AC02K1
       WHERE AAC001 = var_aac001_more
         AND AAC031 = '1';
      IF COUNT_JM > 0 THEN
       SELECT AAB004
         INTO VAR_AAB004
         FROM XASI2.AB01
        WHERE AAB001 = (SELECT aab001
                          FROM XASI2.AC02K1
                         WHERE AAC001 = var_aac001_more
                           AND AAC031 = '1');
        v_msg  := '�����֤������Աҽ�Ʊ��չ�ϵĿǰ��������' || VAR_AAB004 || '�μӾ���ҽ��������:'  ||'���˱�ţ�'||var_aac001_more|| ',�α�״̬:�α��ɷѡ�';
        v_flag := '3';
       END IF;
        END LOOP;


   /* IF num_count > 1 THEN

      select aac001 INTO v_aac001 from xasi2.ac01
       where aac001 <> rec_temp.aac001
         and aac002 IN (var_15aac002, var_aac002Low, rec_temp.aac002)
         and replace(aac003, ' ', '') = rec_temp.aac003
         AND AAC003 NOT LIKE '%�ظ�%';
         IF v_aac001 IS NULL  OR  v_aac001 = '' THEN
            v_msg := v_errmsg||v_msg||'��ȡ�������˱��!';
            v_flag  := '1';
      END IF;

     SELECT COUNT(1)
        INTO COUNT_JM
        FROM XASI2.AC02K1
       WHERE AAC001 = v_aac001
         AND AAC031 = '1';
      IF COUNT_JM > 0 THEN
       SELECT AAB004
         INTO VAR_AAB004
         FROM XASI2.AB01
        WHERE AAB001 = (SELECT aab001
                          FROM XASI2.AC02K1
                         WHERE AAC001 = v_aac001
                           AND AAC031 = '1');
        v_msg  := '�����֤������Աҽ�Ʊ��չ�ϵĿǰ��������' || VAR_AAB004 || '�μӾ���ҽ��������:'  ||'���˱�ţ�'||v_aac001|| ',�α�״̬:�α��ɷѡ�';
        v_flag := '3';

      END IF;
     END IF;
     */

  -- �ж��Ƿ���������λ�α�

   /* SElECT  count(*) INTO  Count_ZG  FROM  xasi2.ac02 where aac001 =   v_aac001
    and aab001 <> prm_aab001  and aac031 ='1' and  aae140 <> 04;
    IF   Count_ZG > 0 THEN
       v_msg  := '�����֤������Ա��������λ�μ�ְ��ҽ��������:'  ||'���˱�ţ�'||v_aac001|| ',�α�״̬:�α��ɷѡ�';
        v_flag := '5';
    END IF;
  */

    --�ж�ʧҵ�Ƿ�Ϊ��
    IF  rec_temp.aae210 = '1' THEN
    SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001 = v_aac001 AND aae140='02';
    IF num_count > 0 THEN
    UPDATE wsjb.tmp_irac01a2  SET aae210 ='10' WHERE aac002 = REC_TEMP.aac002 AND iaz018 = prm_iaz018 ;
    END IF;
    END IF;
   --�ж�ҽ���Ƿ�Ϊ��
    IF rec_temp.aae310 = '1' THEN
    SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001 = v_aac001 AND aae140='03';
    IF num_count > 0 THEN
    UPDATE wsjb.tmp_irac01a2  SET aae310 ='10' WHERE aac002 = REC_TEMP.aac002 AND iaz018 = prm_iaz018 ;
    END IF;
    END IF;
     --�жϹ����Ƿ�Ϊ��
    IF  rec_temp.aae410 = '1' THEN
    SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001 = v_aac001 AND aae140='04';
    IF num_count > 0 THEN
    UPDATE wsjb.tmp_irac01a2  SET aae410 ='10' WHERE aac002 = REC_TEMP.aac002 AND iaz018 = prm_iaz018 ;
    END IF;
    END IF;
     --�ж������Ƿ�Ϊ��
    IF  rec_temp.aae210 = '1' THEN
    SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001 = v_aac001 AND aae140='05';
    IF num_count > 0 THEN
    UPDATE wsjb.tmp_irac01a2  SET aae510 ='10' WHERE aac002 = REC_TEMP.aac002 AND iaz018 = prm_iaz018 ;
    END IF;
    END IF;
     --�жϴ���Ƿ�Ϊ��
    IF  rec_temp.aae311 = '1' THEN
    SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001 = v_aac001 AND aae140='07';
    IF num_count > 0 THEN
    UPDATE wsjb.tmp_irac01a2  SET aae311 ='10' WHERE aac002 = REC_TEMP.aac002 AND iaz018 = prm_iaz018 ;
    END IF;
    END IF;
     --�жϻ����Ƿ�Ϊ��
    IF rec_temp.aae120 = '1' THEN
    SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001 = v_aac001 AND aae140='06';
    IF num_count > 0 THEN
    UPDATE wsjb.tmp_irac01a2  SET aae120 ='10' WHERE aac002 = REC_TEMP.aac002 AND iaz018 = prm_iaz018 ;
    END IF;
    END IF;
     --�жϹ���Ա�����Ƿ�Ϊ��
    IF rec_temp.aae810 = '1' THEN
    SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001 = v_aac001 AND aae140='08';
    IF num_count > 0 THEN
    UPDATE wsjb.tmp_irac01a2  SET aae810 ='10' WHERE aac002 = REC_TEMP.aac002 AND iaz018 = prm_iaz018 ;
    END IF;
    END IF;
    ELSIF num_count > 1 THEN
      v_msg  :=  v_errmsg||v_msg||'֤����Ϊ��[' || rec_temp.aac002 || ']����Ա���ڶ���������Ϣ��������ϵ�籣���ģ�';
      v_flag := '1';
    END IF;


        --�ж�ҽ����������
    IF v_aae310 = '1' THEN

                   IF  (v_aae510 = '0') OR (v_aae311 = '0') THEN

                         v_msg :=v_errmsg||v_msg|| 'ҽ�ơ����������������ֱ���һ��α�!';
                         v_flag  := '1';
                    END IF;
             END IF;
      IF v_aae510 = '1' THEN
                   IF  v_aae310 = '0' OR v_aae311 = '0' THEN
                         v_msg := v_errmsg||v_msg||'ҽ�ơ����������������ֱ���һ��α�!';
                         v_flag  := '1';
                    END IF;
             END IF;
      IF v_aae311 = '1' THEN
                   IF  v_aae310 = '0' OR v_aae510 = '0' THEN
                         v_msg := v_errmsg||v_msg||'ҽ�ơ����������������ֱ���һ��α�!';
                         v_flag  := '1';
                    END IF;
             END IF;



    v_errmsg :=v_msg;
    IF v_flag = '0' THEN
    prc_p_checkInfoByaac001(v_aac001 ,
                           rec_temp.aac003 ,
                           prm_flag    , --1У��ʧ�ܣ��޷����� 2У��ɹ������� 3У��ɹ����о� 4У��ɹ����ϲ����� 5У��ɹ���������������  6.δ�鵽 ҽ����Ϣ
                           v_msg     ,
                           prm_AppCode ,             --�������
                           prm_ErrorMsg   );
    IF prm_flag = '1' THEN
    v_flag :='1';
    v_msg :=v_errmsg||v_msg||'����Ա�α�����δ����ͣ���ж���˻�������������������';
    END IF;
    IF prm_flag = '2' THEN
    v_flag :=v_flag;
    v_msg :=v_errmsg;
    END IF;
    IF prm_flag = '3' THEN
    v_flag :=v_flag;
    v_msg :=v_errmsg;
    END IF;
    IF prm_flag = '4' THEN
    v_flag :=v_flag;
    v_msg :=v_errmsg;
    END IF;
    /*IF prm_flag ='5' THEN
    IF n_ab02count<5 THEN
    FOR rec_ab02 IN cur_ab02 LOOP
    IF rec_ab02.aae140 ='02' THEN
    SELECT count(1) INTO n_ac02count
     FROM sjxt.ac01 a,sjxt.ac02 b
     WHERE a.aac001=b.aac001
     and a.aac002=rec_temp.aac002
     and aae140=rec_ab02.aae140
     and aac031='1';
     IF n_ac02count>0 THEN
     v_aae210 := '';
     ELSE
      v_aae210:='1';
     END IF;
    END IF;
    IF rec_ab02.aae140 ='03' THEN
    SELECT count(1) INTO n_ac02count
     FROM sjxt.ac01 a,sjxt.ac02 b
     WHERE a.aac001=b.aac001
     and a.aac002=rec_temp.aac002
     and aae140=rec_ab02.aae140
     and aac031='1';
     IF n_ac02count>0 THEN
     v_aae310 := '';
     ELSE
      v_aae310:='1';
     END IF;
    END IF;
    IF rec_ab02.aae140 ='04' THEN
    SELECT count(1) INTO n_ac02count
     FROM sjxt.ac01 a,sjxt.ac02 b
     WHERE a.aac001=b.aac001
     and a.aac002=rec_temp.aac002
     and aae140=rec_ab02.aae140
     and aac031='1';
     IF n_ac02count>0 THEN
     v_aae410 := '';
     ELSE
      v_aae410:='1';
     END IF;
    END IF;
    IF rec_ab02.aae140 ='05' THEN
    SELECT count(1) INTO n_ac02count
     FROM sjxt.ac01 a,sjxt.ac02 b
     WHERE a.aac001=b.aac001
     and a.aac002=rec_temp.aac002
     and aae140=rec_ab02.aae140
     and aac031='1';
     IF n_ac02count>0 THEN
     v_aae510 := '';
     ELSE
      v_aae510:='1';
     END IF;
    END IF;
    IF rec_ab02.aae140 ='07' THEN
    SELECT count(1) INTO n_ac02count
     FROM sjxt.ac01 a,sjxt.ac02 b
     WHERE a.aac001=b.aac001
     and a.aac002=rec_temp.aac002
     and aae140=rec_ab02.aae140
     and aac031='1';
     IF n_ac02count>0 THEN
     v_aae311 := '';
     ELSE
      v_aae311:='1';
     END IF;
    END IF;
    v_flag :='0';
    END LOOP;
    ELSE
    v_flag :='1';
    v_msg :=v_errmsg||v_msg||'����Ա����������������α�����Ϣ��';
    END IF;
    END IF;*/
      IF prm_flag ='6' THEN
    IF REC_TEMP.aae110 = '0' THEN
    v_flag :='1';
    v_msg :=v_errmsg||v_msg||'δ�鵽����Ա����Ϣ�������²α�ģ�������';
    END IF;
    END IF;
    END IF;

    if v_flag = '0' then
      pkg_p_validate.prc_p_ValidateAac002Continue('1',
                                                 rec_temp.aac002,
                                                 prm_aab001,
                                                 prm_iaa100,
                                                 v_aac001,
                                                 v_msg,
                                                 v_flag,
                                                 prm_AppCode,
                                                 prm_ErrorMsg);
    end if;

  /*  if v_flag = '0' and rec_temp.aac040 < v_aaa010 then
      v_flag := '1';
      v_msg  := v_errmsg||v_msg||'�걨���ʵ�������ʡ��͹��ʱ�׼' || v_aaa010 || '!';
    end if;
    */

   /* if v_flag = '0' then
      SELECT to_number(MIN(AAC040))
        into v_aac040_old
        FROM (SELECT AAC040
                FROM xasi2.AC02
               WHERE AAB001 = prm_aab001
                 AND AAC001 = v_aac001
                 AND AAE140 NOT IN ('06', '07', '08')
                 and aac031 = '1'
              UNION ALL
              SELECT AAC040
                FROM IRAC01A3
               WHERE AAB001 = prm_aab001
                 AND AAC001 = v_aac001
                 AND AAE110 = '2');
      if v_aac040_old != rec_temp.sbgz then
        v_flag := '1';
        v_msg  := '�걨����' || rec_temp.sbgz || '��֮ǰ�α�����' || v_aac040_old ||
                  '��һ��!';
      end if;
    end if;

    if v_flag = '0' and rec_temp.aae110 = '1' THEN
      pkg_p_validate.prc_p_ValidateContinueYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '01',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;
*/
    if v_flag = '0' and rec_temp.aae210 = '1' THEN
      pkg_p_validate.prc_p_ValidateContinueYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '02',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae310 = '1' then
      pkg_p_validate.prc_p_ValidateContinueYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '03',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae410 = '1' then
      pkg_p_validate.prc_p_ValidateContinueYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '04',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae510 = '1' then
      pkg_p_validate.prc_p_ValidateContinueYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '05',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae120 = '1' then
      pkg_p_validate.prc_p_ValidateContinueYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '06',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae311 = '1' then
      pkg_p_validate.prc_p_ValidateContinueYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '07',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae810 = '1' then
      pkg_p_validate.prc_p_ValidateContinueYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '08',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae110 = '1' and rec_temp.aae120 = '1' then
      v_flag := '1';
      v_msg  := v_errmsg||v_msg||'��ҵ���Ϻͻ����������ֲ���ͬʱ�α���';
    end if;

    if v_flag is null then
      v_flag := '0';
    end if;

    if v_msg is null then
      v_msg := '';
    end if;

    if v_flag = '0' then

      SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,
                                                             prm_aab001,
                                                             rec_temp.aac040,
                                                             '0',
                                                             decode(rec_temp.aae310,
                                                                    '1',
                                                                    '03',
                                                                    '04'),
                                                             '1',
                                                             '1',
                                                             prm_iaa100,
                                                             '610127'))
        into v_yac005
        FROM dual;

      if rec_temp.aae110 = '1' OR rec_temp.aae110='10' then
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,
                                                               prm_aab001,
                                                               rec_temp.aac040,
                                                               '0',
                                                               '01',
                                                               '1',
                                                               '1',
                                                               prm_iaa100,
                                                               '610127'))
          into v_yac004
          FROM dual;
      elsif rec_temp.aae120 = '1' then
        v_yac004 := rec_temp.aac040;
      else
        v_yac004 := 0;
      end if;


  update wsjb.tmp_irac01a2  a
         set a.aae100 = '1',
              a.aac001 = v_aac001,
             a.errormsg  = a.errormsg||v_msg,
             a.yac004    = v_yac004,
             a.yac005    = v_yac005,
             a.iaa100     =''
       where iaz018 = prm_iaz018
       AND a.aac002 = rec_temp.aac002;

      if sql%rowcount = 0 then
        prm_appcode  := PRE_ERRCODE || GN_DEF_ERR;
        prm_errormsg := 'prc_p_ValidBatchContinueCheck����,����ԭ��:û�и��µ�У������Ϣ��';
        return;
      end if;

      if sql%rowcount > 1 then
        prm_appcode  := PRE_ERRCODE || GN_DEF_ERR;
        prm_errormsg := 'prc_p_ValidBatchContinueCheck����,����ԭ��:���µ�����У������Ϣ��';
        return;
      end if;
    ELSE


      update wsjb.tmp_irac01a2  a
         set a.aae100 = '0', a.errormsg = a.errormsg||v_msg,
          a.iaa100     ='',
          a.aac001 = v_aac001
       where iaz018 = prm_iaz018
       AND a.aac002 = rec_temp.aac002;

      if sql%rowcount = 0 then
        prm_appcode  := PRE_ERRCODE || GN_DEF_ERR;
        prm_errormsg := 'prc_p_ValidBatchContinueCheck����,����ԭ��:û�и��µ�У������Ϣ��';
        return;
      end if;

      if sql%rowcount > 1 then
        prm_appcode  := PRE_ERRCODE || GN_DEF_ERR;
        prm_errormsg := 'prc_p_ValidBatchContinueCheck����,����ԭ��:���µ�����У������Ϣ��';
        return;
      end if;
    end if;

  END LOOP;

EXCEPTION

  WHEN OTHERS THEN
    ROLLBACK;
    PRM_APPCODE  := PRE_ERRCODE || GN_DEF_ERR;
    PRM_ERRORMSG := 'prc_p_ValidBatchContinueCheck����,����ԭ��:' || SQLERRM ||
                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
    RETURN;
END prc_p_ValidBatchContinueCheck;
/*--------------------------------------------------------------------------
   || ҵ�񻷽� ��У��α���Ա�Ƿ��������ĳһ������
   || �������� prc_p_ValidateAddKindYesOrNo
   || �������� ��У����������
   ||
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��ycliu         ������� ��2017-02-15
   ||------------------------------------------------------------------------*/
  PROCEDURE prc_p_ValidateContinueYesOrNo(prm_aab001   IN VARCHAR2, --��λ���
                                         prm_aac001   IN VARCHAR2, --���˱��
                                         prm_aae140   IN VARCHAR2, --����
                                         prm_yab139   IN VARCHAR2, --�������
                                         prm_flag     OUT VARCHAR2, --����״̬��־
                                         prm_msg      OUT VARCHAR2, --��ʾ��Ϣ
                                         prm_AppCode  OUT VARCHAR2, --ִ�д���
                                         prm_ErrorMsg OUT VARCHAR2) --������Ϣ
   IS
    v_flag   varchar2(2);
    v_msg    varchar2(4500);
    v_yon    varchar2(9);
    v_aab001 irab01.aab001%TYPE;
    v_aac031 irac01.aac031%TYPE;
  BEGIN
    --��ʼ������
    prm_AppCode  := GN_DEF_OK;
    prm_ErrorMsg := '';
    v_flag   := '0'; --����(0--������1--����2--����)
    v_msg    := '';
    v_yon    := '';
    v_aab001 := '';
    v_aac031 := '0'; --Ĭ��δ�α�

    --�жϸõ�λ�Ƿ�μӴ�����

    BEGIN
      select 1
        into v_yon
        from (select b.aae140
                from xasi2.ab02 b
               where 1 = 1
                 and b.aab001 = prm_aab001
                 and b.aab051 = '1'
              union
              select '01' as aae140
                from wsjb.irab01  a
               where a.iab001 = a.aab001
                 and a.iaa002 = '2'
                 and a.aab001 = prm_aab001
                 and a.aae110 = '1') r
       where r.aae140 = prm_aae140;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_flag := '1';
        v_msg  := '��λû�вμ�' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  ',�������������֣�';
        goto label_out;
      WHEN TOO_MANY_ROWS THEN
        v_flag := '1';
        v_msg  := '��λ�ҵ�����' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  '�α���¼,����ϵ�籣���ģ�';
        goto label_out;
      WHEN OTHERS THEN
        v_flag := '1';
        v_msg  := 'δ֪��������ϵϵͳά����Ա��';
        goto label_out;
    END;

    if v_yon <> '1' then
      v_flag := '1';
      v_msg  := '��λû�вμ�' ||
                xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                ',�������������֣�';
      goto label_out;
    end if;

    if prm_aae140 = '04' then
      begin
        select r.aab001, r.aac031
          into v_aab001, v_aac031
          from (select a.aab001, a.aae140, a.aac031
                  from xasi2.ac02 a
                 where a.aac001 = prm_aac001
                union
                select b.aab001,
                       '01' as aae140,
                       decode(b.aae110, '2', '1', '21', '2', '0', '') as aac031
                  from wsjb.irac01a3  b
                 where b.aac001 = prm_aac001
                   and b.aae110 = '2') r
         where r.aae140 = prm_aae140
           and r.aab001 = prm_aab001;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_flag := '0';
          goto label_out;
      end;

      if v_aab001 is not null AND v_aac031 = '1' then
        v_flag := '1';
        v_msg  := '�����Ѿ��ڱ���λ��' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  'Ϊ'||xasi2.pkg_comm.fun_getAaa103('AAC031', v_aac031)||'״̬��';
        goto label_out;
      end if;

     /* begin
        select r.aab001, r.aac031
          into v_aab001, v_aac031
          from (select a.aab001, a.aae140, a.aac031
                  from xasi2.ac02 a
                 where a.aac001 = prm_aac001
                union
                select b.aab001,
                       '01' as aae140,
                       decode(b.aae110, '2', '1', '21', '2', '0', '') as aac031
                  from irac01a3 b
                 where b.aac001 = prm_aac001
                   and b.aae110 = '2') r
         where r.aae140 = prm_aae140
           and r.aab001 <> prm_aab001;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_flag := '0';
          goto label_out;
      end;

      if v_aab001 is not null or v_aac031 = '1' then
        v_flag := '1';
        v_msg  := '�����Ѿ���' || v_aab001 || '��λ�μ���' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  ',�������������֣�';
        goto label_out;
      end if;*/
    else

      --�ж���Ա�������Ƿ������α�
      BEGIN
        select r.aab001, r.aac031
          into v_aab001, v_aac031
          from (select a.aab001, a.aae140, a.aac031
                  from xasi2.ac02 a
                 where a.aac001 = prm_aac001
                union
                select b.aab001,
                       '01' as aae140,
                       decode(b.aae110, '2', '1', '21', '2', '0', '') as aac031
                  from wsjb.irac01a3  b
                 where b.aac001 = prm_aac001
                   and b.aae110 = '2') r
         where r.aae140 = prm_aae140;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_flag := '0';
          goto label_out;
        WHEN TOO_MANY_ROWS THEN
          v_flag := '1';
          v_msg  := '�����ҵ�����' ||
                    xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                    '�α���¼,����ϵ�籣���ģ�';
          goto label_out;
        WHEN OTHERS THEN
          v_flag := '1';
          v_msg  := 'δ֪��������ϵϵͳά����Ա��';
          goto label_out;
      END;

      if v_aab001 is not null AND v_aac031 = '1' then
        v_flag := '1';
        v_msg  := '�����Ѿ���' || v_aab001 || '��λ��' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  'Ϊ'||xasi2.pkg_comm.fun_getAaa103('AAC031', v_aac031)||'״̬��';
        goto label_out;
      end if;
    end if;

    <<label_out>>
    prm_flag := v_flag;
    prm_msg  := v_msg;

  EXCEPTION
    WHEN OTHERS THEN
      /*�رմ򿪵��α�*/
      ROLLBACK;
      prm_AppCode  := gn_def_ERR;
      prm_ErrorMsg := '���ݿ����:' || SQLERRM;
      RETURN;
  END prc_p_ValidateContinueYesOrNo;

  /*--------------------------------------------------------------------------
   || ҵ�񻷽� �������²α�У��
   || �������� prc_p_ValidateAddKindYesOrNo
   || �������� �������²α�У��
   ||
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��        ������� ��2017-02-19
   ||------------------------------------------------------------------------*/

  PROCEDURE prc_p_ValidateAac002Special(
       prm_yae181          IN            VARCHAR2,     --֤������
      prm_aac002          IN            VARCHAR2,     --֤������
      prm_aab001          IN            VARCHAR2,     --��λ���
      prm_msg             OUT           VARCHAR2,     -- ������Ϣ
      prm_sign            OUT           VARCHAR2,     -- �����־
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2)    --������Ϣ
   IS
     num_count        NUMBER(6);
     var_aac001       irac01.aac001%TYPE;
   num_count1        NUMBER(6);
   var_aac002Low    irac01.aac002%TYPE;
   var_15aac002     irac01.aac002%TYPE;
   var_aab001       irac01.aab001%TYPE;
   BEGIN
    /*��ʼ������*/
      prm_AppCode  := GN_DEF_OK;
      prm_ErrorMsg := '';
      prm_msg :='';
      prm_sign :='0';
   --У�����
      IF prm_yae181 IS NULL  THEN
         prm_msg :=  prm_msg||'����֤������Ϊ�գ����ʵ������';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
      IF prm_aab001 IS NULL  THEN
         prm_msg :=  prm_msg||'���뵥λ���Ϊ�գ����ʵ������';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
      IF prm_aac002 IS NULL  THEN
         prm_msg :=  prm_msg||'����֤������Ϊ�գ����ʵ������';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
       --���֤����
     IF prm_yae181 = 1 THEN
        --��ȡ������ʽ��֤������
         var_15aac002 := SUBSTR(prm_aac002,1,6)||SUBSTR(prm_aac002,9, 9);
         var_aac002Low := LOWER(prm_aac002);

        SELECT count(1)
          INTO num_count
          FROM xasi2.ac01 A
         WHERE A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
           AND AAC003 NOT LIKE '%�ظ�%';

         IF num_count = 0 THEN
           prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա�����ڸ�����Ϣ�������²α�ģ�������';
           prm_sign :='1';
           GOTO label_ERROR ;
         END IF ;

         SELECT count(1)
          INTO num_count1
          FROM wsjb.irac01  A
         WHERE A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
           AND a.iaa001 <> '4'
           AND A.IAA002 ='0'
           AND  rownum = 1;

         IF  num_count1 > 0 THEN
          SELECT a.aab001
            INTO var_aab001
            FROM wsjb.irac01  A
           WHERE A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
             AND a.iaa001 <> '4'
             AND A.IAA002 ='0'
             AND rownum =1;
           prm_msg := '֤����Ϊ��['||prm_aac002||']����Ա�ڵ�λ'||var_aab001||'���걨��¼,��������!';
           prm_sign :='1';
           GOTO label_ERROR ;
         END IF;

       SELECT aac001
               INTO var_aac001
               FROM xasi2.ac01 a
               WHERE a.aac002 IN (var_15aac002, var_aac002Low, prm_aac002)
           AND AAC003 NOT LIKE '%�ظ�%';

       SELECT COUNT(*)
         INTO num_count
         FROM xasi2.ac06
         WHERE aac001=var_aac001;
         IF num_count>0 THEN
           SELECT COUNT(*)
          INTO num_count
          FROM xasi2.ac02
          WHERE aac001=var_aac001
          AND aac031='3';
           END IF;


     END IF;


     <<label_ERROR>>
      num_count := 0;

       EXCEPTION
    WHEN OTHERS THEN
      /*�رմ򿪵��α�*/
      ROLLBACK;
      prm_AppCode  := gn_def_ERR;
      prm_ErrorMsg := '���ݿ����:' || SQLERRM;
      RETURN;
 END prc_p_ValidateAac002Special;

  /*--�˻�ת��
  procedure prc_p_accountInto(prm_str    IN CLOB,
                              prm_aaz174 IN VARCHAR2,
                              prm_AppCode OUT   VARCHAR2  ,             --�������
                               prm_ErrorMsg  OUT   VARCHAR2
                              )
  is
  var_aac001  xasi2.ac01.aac001%TYPE;
  var_aac002_18  VARCHAR2(18);
  n_aae001 NUMBER(4);
  num_count NUMBER;
  var_yae099  VARCHAR2(20);
  xmlPar xmlparser.Parser := xmlparser.newParser;
  doc xmldom.DOMDocument;
  len Integer;
  ac02List xmldom.DOMNodeList;
  chilNodes xmldom.DOMNodeList;
  ac02Node xmldom.DOMNode;
  ac02ArrMap xmldom.DOMNamedNodeMap;
  var_nac001 VARCHAR2(15);
  var_aac002 VARCHAR2(18);
  var_aac003 VARCHAR2(60);
  num_nkc087 NUMBER(14,2);
  num_akc087 NUMBER(14,2);
  var_flag VARCHAR2(6);
  var_aae013 VARCHAR2(120);
  var_yae235 VARCHAR2(6);
  var_yae238 VARCHAR2(800);
  var_aaz174 VARCHAR2(15);
  var_aaz175 VARCHAR2(15);
  var_aaz176 VARCHAR2(15);
  dat_aae036 date;
  begin
     prm_AppCode := GN_DEF_OK;
     prm_ErrorMsg := '';
     xmlPar := xmlparser.newParser;
     xmlparser.parseClob(xmlPar,prm_str);
     doc := xmlparser.getDocument(xmlPar);
     --�ͷ�
    xmlparser.freeParser(xmlPar);
    ac02List := xmldom.getElementsByTagName(doc,'row');
    len := xmldom.getLength(ac02List);
    n_aae001:=TO_NUMBER(substr(to_char(sysdate,'yyyy-MM-dd'),0,4));
    dat_aae036 := sysdate;
    for i in 0..len-1 loop
      var_aac001 := '';
      var_nac001 := '';
      var_aac002 := '';
      var_aac003 := '';
      var_flag := '';--���˳ɹ���־
      var_aae013 := '';
      num_nkc087 := 0;
      num_akc087 := 0;
      var_yae235 := '1';--���˳ɹ�Ϊ1������ʧ��Ϊ2
      var_yae238 := '';
      --��ȡ��i��ac08
      ac02Node := xmldom.item(ac02List,i);
      --��ȡ����
     -- ac08ArrMap := xmldom.getAttributes(ac02Node);
      --��ȡ�ӽڵ�
      chilNodes := xmldom.getChildNodes(ac02Node);
      var_nac001 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,0)));
      var_aac002 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,1)));
      var_aac003 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,2)));
       num_nkc087 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,3)));
      var_flag := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,4)));
      var_aae013 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,5)));
      --�Է���aaz175��Ӧ��ߵ�aaz176
      var_aaz176 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,6)));
      if var_flag = '2' then
         var_yae235 := '2';
         var_yae238 := '�����˳������ܽ�������!';
         GOTO label_next;
      end if;
      --��ѯ���˱��
      begin
        select aac001
          into var_aac001
          from xasi2.ac01
         where aac002 = var_aac002
           and replace(aac003,' ','') = replace(var_aac003,' ','');
        exception
          WHEN NO_DATA_FOUND THEN
            --δ��ȡ�����˻�����Ϣ
            var_yae235 := '2';
            var_yae238 := 'δ��ȡ�����֤Ϊ'||var_aac002||'��Ա�Ļ�����Ϣ��';
            GOTO label_next;
          WHEN TOO_MANY_ROWS THEN
            --���֤���������ڶ�����˱��
            var_yae235 := '2';
            var_yae238 := '�����֤������ڶ�����˱��,���֤��Ϊ:'||var_aac002;
            GOTO label_next;
      end;
      --��ѯ����Ա�Ƿ����ڲα�
      select count(*)
        INTO num_count
        from xasi2.ac02
       where aac001 = var_aac001
         and aae140 = '03'
         and aac031 = '1';
      IF num_count = 0 THEN
         --����Աδ�л���ҽ�Ʋα���Ϣ,����ת���˻�
         var_yae235 := '2';
         var_yae238 := '��Աδ���ڻ���ҽ�Ʋα���Ϣ������ת���˻�!';
         GOTO label_next;
      END IF;

      --var_akc087 := to_number(prm_akc087);
      select xasi2.seq_yae099.nextval into var_yae099 from dual;
      --��¼����һ��ϵͳ�õ��Ľ��͸��˱��
      --insert into kc04k9(yae099,
                        --aac001,
                         --iac001,
                        -- akc087,
                        -- aae120)
                  --VALUES(var_yae099,--ҵ����ˮ��
                        -- var_aac001,--��ϵͳ���˱��
                        -- prm_aac001,--��һ��ϵͳ�еĸ��˱��
                        -- var_akc087,--��һ��ϵͳת��Ľ��
                        -- '0'--��Ч��־
                      --  );

      --��ѯ��Ա�ڱ�ϵͳ�е��˻����
      begin
        select akc087
          into num_akc087
          from xasi2.kc04
         where aac001 = var_aac001;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            num_akc087 := 0 ;
      end;
      --�����оִ����˻����,������Ҫ��ѯһ��ת��Ľ�� ,
      update xasi2.kc04
         set akc082 = akc082 + num_nkc087,--(ת������)
              akc087 = akc087 + num_nkc087
       where aac001 = var_aac001
         and aae001 = n_aae001;
      IF SQL%ROWCOUNT < 1 THEN --���û���˻���ֱ�Ӳ���һ��
         INSERT INTO xasi2.KC04
                 (aac001,   --���˱��
                  aae001,   --���
                  ykc203,   --�ʻ�״̬
                  akc081,   --����ҽ���˻����˽ɷѲ��ֱ��������ܶ�
                  akc082,   --����ҽ���˻���λ�ɷѻ��벿�ֱ��������ܶ�
                  ykc061,   --����ҽ���˻������ת���
                  ykc025,   --����Ա�˻����������ܶ�
                  ykc062,   --����Ա�˻������ת���
                  ykc252,   --����Աע���ʽ���������
                  ykc255,   --����Աע���ʽ������ת���
                  ykc026,   --����̳и��˽ɷѽ��
                  ykc027,   --����̳е�λ������
                  ykc028,   --����̳й���Ա���
                  ykc244,   --����̳й���Աע���ʽ���
                  akc087,   --��ǰ������
                  yka147,   --����ҽ�������˻���Ϣ
                  yka148,   --����ҽ�Ʊ����˻���Ϣ
                  yka149,   --����Ա�����˻���Ϣ
                  yka150,   --����Ա�����˻���Ϣ
                  ykc256,   --����Աע���ʽ������˻���Ϣ
                  ykc253,   --����Աע���ʽ����˻���Ϣ
                  ykc074,   --����ҽ�������˻�֧���ܶ�
                  ykc075,   --����ҽ�Ʊ����˻�֧���ܶ�
                  ykc076,   --����Ա�����˻�֧���ܶ�
                  ykc077,   --����Ա�����˻�֧���ܶ�
                  ykc257,   --����Աע���ʽ�����֧���ܶ�
                  ykc254,   --����Աע���ʽ���֧���ܶ�
                  ykc250,   --����Ա���ﲹ�������ת���
                  ykc036,   --��ֹ����ĩ�ۼ�Ӧ�ɷ�����
                  akc096,   --��ֹ����ĩ�ۼ�ʵ�ɷ�����
                  ykc204,   --ת���ۼƽɷ�����
                  ykc035,   --����ҽ�Ʊ���Ӧ������
                  akc085,   --ҽ�Ʊ���ɷ�����
                  akc095,   --�˻��޸�����
                  ykc031,   --�������ҽ���˻���Ϣ����
                  akc094,   --�������ҽ���˻���Ϣ����
                  ykc032,   --���깫��Ա�˻��������
                  ykc033,   --���깫��Ա�˻��������
                  ykc260,   --���깫��Աע���ʽ��Ϣ����
                  ykc242,   --���깫��Աע���ʽ��Ϣ����
                  yke104)   --�����ݰ汾��
           VALUES(var_aac001,   --���˱��
                  TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),   --���
                  '1',   --�ʻ�״̬����
                  0,   --����ҽ���˻����˽ɷѲ��ֱ��������ܶ�
                  num_nkc087,   --����ҽ���˻���λ�ɷѻ��벿�ֱ��������ܶ�
                  0,   --����ҽ���˻������ת���
                  0,   --����Ա�˻����������ܶ�
                  0,   --����Ա�˻������ת���
                  0,   --����Աע���ʽ���������
                  0,   --����Աע���ʽ������ת���
                  0,   --����̳и��˽ɷѽ��
                  0,   --����̳е�λ������
                  0,   --����̳й���Ա���
                  0,   --����̳й���Աע���ʽ���
                  num_nkc087,   --��ǰ������
                  0,   --����ҽ�������˻���Ϣ
                  0,   --����ҽ�Ʊ����˻���Ϣ
                  0,   --����Ա�����˻���Ϣ
                  0,   --����Ա�����˻���Ϣ
                  0,   --����Աע���ʽ������˻���Ϣ
                  0,   --����Աע���ʽ����˻���Ϣ
                  0,   --����ҽ�������˻�֧���ܶ�
                  0,   --����ҽ�Ʊ����˻�֧���ܶ�
                  0,   --����Ա�����˻�֧���ܶ�
                  0,   --����Ա�����˻�֧���ܶ�
                  0,   --����Աע���ʽ�����֧���ܶ�
                  0,   --����Աע���ʽ���֧���ܶ�
                  0,   --����Ա���ﲹ�������ת���
                  0,   --��ֹ����ĩ�ۼ�Ӧ�ɷ�����
                  0,   --��ֹ����ĩ�ۼ�ʵ�ɷ�����
                  0,   --ת���ۼƽɷ�����
                  0,   --����ҽ�Ʊ���Ӧ������
                  0,   --ҽ�Ʊ���ɷ�����
                  SYSDATE,   --�˻��޸�����
                  0,   --�������ҽ���˻���Ϣ����
                  0,   --�������ҽ���˻���Ϣ����
                  0,   --���깫��Ա�˻��������
                  0,   --���깫��Ա�˻��������
                  0,   --���깫��Աע���ʽ��Ϣ����
                  0,   --���깫��Աע���ʽ��Ϣ����
                  TO_NUMBER(TO_CHAR(SYSDATE,'yyyymmdd')));     --�����ݰ汾��
         END IF;
         <<label_next>>
         select xasi2.seq_aaz175.nextval into var_aaz175 from dual;
         insert into xasi2_zs_n.kc04a2(AAZ174,
                           AAZ175,
                           AAZ176,
                           AAC001,
                           NAC001,
                           AAC002,
                           AAC003,
                           NKC087,
                           AKC087,
                           AAE036,
                           FLAG,
                           AAE013,
                           YAE235,
                           YAE238
                           )
                     values(
                            prm_aaz174,
                            var_aaz175,
                            var_aaz176,--��¼�����aaz175��Ϊ��д��־
                            var_aac001,
                            var_nac001,
                            var_aac002,
                            var_aac003,
                            num_nkc087,
                            num_akc087,
                            dat_aae036,
                            var_flag,
                            var_aae013,
                            var_yae235,
                            var_yae238
                           );
     end loop;

   EXCEPTION
       WHEN OTHERS THEN
       --���ô洢���̳���
       prm_AppCode := '-1';
      prm_ErrorMsg := '�������˴洢���̳���';
      RETURN;
  END prc_p_accountInto;
  --�˻�ת������
  procedure prc_p_accountOut(prm_rows IN VARCHAR2,
                             prm_log OUT sys_refcursor,
                             prm_AppCode OUT   VARCHAR2,             --�������
                              prm_ErrorMsg  OUT   VARCHAR2
                            )
  is
  xmlPar xmlparser.Parser := xmlparser.newParser;
  doc xmldom.DOMDocument;
  len Integer;
  ac02List xmldom.DOMNodeList;
  chilNodes xmldom.DOMNodeList;
  ac02Node xmldom.DOMNode;
  ac02ArrMap xmldom.DOMNamedNodeMap;
  var_aac001 VARCHAR2(20);
  n_aae001 NUMBER;
  var_yae099 VARCHAR2(20);
  num_count  NUMBER;
  var_aac002 VARCHAR2(18);
  var_aac003 VARCHAR2(60);
  dat_aae036 date;
  num_akc087 NUMBER(14,2);
  var_aaz174 VARCHAR2(15);
  var_aaz175 VARCHAR2(15);
  var_flag VARCHAR2(6);
  var_aae013 VARCHAR2(120);
  begin
    --��ѯ���˱��
    prm_AppCode := '1';
    prm_ErrorMsg  := '';
    xmlPar := xmlparser.newParser;
    xmlparser.parseClob(xmlPar,prm_rows);
    doc := xmlparser.getDocument(xmlPar);
    --�ͷ�
    xmlparser.freeParser(xmlPar);
    ac02List := xmldom.getElementsByTagName(doc,'row');
    len := xmldom.getLength(ac02List);
    dat_aae036 := sysdate;
    select xasi2.seq_aaz174.nextval
      into var_aaz174
      from dual;

    --��ѯ��Ϣ�����ͷ�
    for i in 0..len-1 loop
      var_aac001 := '';
      var_aac002 := '';
      var_aac003 := '';
      var_flag := '1';--���˳ɹ���־
      var_aae013 := '';
      num_akc087 := 0;
      --��ȡ��i��ac08
      ac02Node := xmldom.item(ac02List,i);
      --��ȡ����
     -- ac08ArrMap := xmldom.getAttributes(ac02Node);
      --��ȡ�ӽڵ�
      chilNodes := xmldom.getChildNodes(ac02Node);
      var_aac002 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,0)));
      var_aac003 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,1)));

      n_aae001:=TO_NUMBER(substr(to_char(sysdate,'yyyy-MM-dd'),0,4));
      --��ѯ���˱��
      begin
        select aac001
          into var_aac001
          from xasi2.ac01
         where aac002 = var_aac002
           and replace(aac003,' ','') = replace(var_aac003,' ','');
        exception
          WHEN NO_DATA_FOUND THEN
            --δ��ȡ�����˻�����Ϣ
            var_flag := '2'; --ʧ��
            var_aae013 := 'δ��ȡ�����֤Ϊ'||var_aac002||'��Ա�Ļ�����Ϣ��';
            GOTO label_next;
          WHEN TOO_MANY_ROWS THEN
            --���֤���������ڶ�����˱��
            var_flag := '2';
            var_aae013 := '�����֤������ڶ�����˱��,���֤��Ϊ:'||var_aac002;
            GOTO label_next;
      end;
      --��ѯ����Ա�Ƿ����ڲα�
      select count(*)
        INTO num_count
        from xasi2.ac02
       where aac001 = var_aac001
         and aae140 = '03'
         and aac031 = '2';
      IF num_count = 0 THEN
         --����Աδ�л���ҽ�Ʋα���Ϣ,����ת���˻�
         var_flag := '2';
         var_aae013 := '��Աδ���ڻ���ҽ�Ʋα���Ϣ�����ҽ�Ʊ���δ��ͣ�ɷ�!';
         GOTO label_next;
      END IF;

      select xasi2.seq_yae099.nextval into var_yae099 from dual;
      --prm_aac001 := var_aac001;
      --��ѯ����Ա�Ƿ�����˻���Ϣ
      BEGIN
        SELECT akc087
          INTO num_akc087
          FROM xasi2.kc04
         WHERE aac001 = var_aac001
           AND aae001 = n_aae001;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
             var_flag := '2';
             var_aae013 := '����Աδ�����˻���Ϣ��';
             GOTO label_next;
      END;

      --�˻�Ϊ������Ϊ����ʧ��
      IF num_akc087 < 0 THEN
         var_flag := '2';
          var_aae013 := '����Աδ�����˻����Ϊ��!';
          GOTO label_next;
      END IF;

      --�������˻���Ϣд�����,���Ҽ�¼���������
      BEGIN
         INSERT INTO xasi2.kc04k4
                  ( yae099,   -- ҵ����ˮ��
                    aac001, --���˱��
                    aae001, --���
                    ykc203, --�ʻ�״̬
                    akc081, --����ҽ���˻����˽ɷѲ��ֱ��������ܶ�
                    akc082, --����ҽ���˻���λ�ɷѻ��벿�ֱ��������ܶ�
                    ykc061, --����ҽ���˻������ת���
                    ykc025, --����Ա�˻����������ܶ�
                    ykc062, --����Ա�˻������ת���
                    ykc252, --����Աע���ʽ���������
                    ykc255, --����Աע���ʽ������ת���
                    ykc026, --����̳и��˽ɷѽ��
                    ykc027, --����̳е�λ������
                    ykc028, --����̳й���Ա���
                    ykc244, --����̳й���Աע���ʽ���
                    akc087, --��ǰ������
                    yka147, --����ҽ�������˻���Ϣ
                    yka148, --����ҽ�Ʊ����˻���Ϣ
                    yka149, --����Ա�����˻���Ϣ
                    yka150, --����Ա�����˻���Ϣ
                    ykc256, --����Աע���ʽ������˻���Ϣ
                    ykc253, --����Աע���ʽ����˻���Ϣ
                    ykc074, --����ҽ�������˻�֧���ܶ�
                    ykc075, --����ҽ�Ʊ����˻�֧���ܶ�
                    ykc076, --����Ա�����˻�֧���ܶ�
                    ykc077, --����Ա�����˻�֧���ܶ�
                    ykc257, --����Աע���ʽ�����֧���ܶ�
                    ykc254, --����Աע���ʽ���֧���ܶ�
                    ykc250, --����Ա���ﲹ�������ת���
                    ykc036, --��ֹ����ĩ�ۼ�Ӧ�ɷ�����
                    akc096, --��ֹ����ĩ�ۼ�ʵ�ɷ�����
                    ykc204, --ת���ۼƽɷ�����
                    ykc035, --����ҽ�Ʊ���Ӧ������
                    akc085, --ҽ�Ʊ���ɷ�����
                    akc095, --�˻��޸�����
                    ykc031, --�������ҽ���˻���Ϣ����
                    akc094, --�������ҽ���˻���Ϣ����
                    ykc032, --���깫��Ա�˻��������
                    ykc033, --���깫��Ա�˻��������
                    ykc260, --���깫��Աע���ʽ��Ϣ����
                    ykc242, --���깫��Աע���ʽ��Ϣ����
                    yke104) --�����ݰ汾��
             SELECT var_yae099,   -- ҵ����ˮ��
                    a.aac001,  --���˱��
                    a.aae001,  --���
                    a.ykc203,  --�ʻ�״̬
                    a.akc081, --����ҽ���˻����˽ɷѲ��ֱ��������ܶ�
                    a.akc082, --����ҽ���˻���λ�ɷѻ��벿�ֱ��������ܶ�
                    a.ykc061, --����ҽ���˻������ת���
                    a.ykc025, --����Ա�˻����������ܶ�
                    a.ykc062, --����Ա�˻������ת���
                    a.ykc252, --����Աע���ʽ���������
                    a.ykc255, --����Աע���ʽ������ת���
                    a.ykc026, --����̳и��˽ɷѽ��
                    a.ykc027, --����̳е�λ������
                    a.ykc028, --����̳й���Ա���
                    a.ykc244, --����̳й���Աע���ʽ���
                    a.akc087, --��ǰ������
                    a.yka147, --����ҽ�������˻���Ϣ
                    a.yka148, --����ҽ�Ʊ����˻���Ϣ
                    a.yka149, --����Ա�����˻���Ϣ
                    a.yka150, --����Ա�����˻���Ϣ
                    a.ykc256, --����Աע���ʽ������˻���Ϣ
                    a.ykc253, --����Աע���ʽ����˻���Ϣ
                    a.ykc074, --����ҽ�������˻�֧���ܶ�
                    a.ykc075, --����ҽ�Ʊ����˻�֧���ܶ�
                    a.ykc076, --����Ա�����˻�֧���ܶ�
                    a.ykc077, --����Ա�����˻�֧���ܶ�
                    a.ykc257, --����Աע���ʽ�����֧���ܶ�
                    a.ykc254, --����Աע���ʽ���֧���ܶ�
                    a.ykc250, --����Ա���ﲹ�������ת���
                    a.ykc036, --��ֹ����ĩ�ۼ�Ӧ�ɷ�����
                    a.akc096, --��ֹ����ĩ�ۼ�ʵ�ɷ�����
                    a.ykc204, --ת���ۼƽɷ�����
                    a.ykc035, --����ҽ�Ʊ���Ӧ������
                    a.akc085, --ҽ�Ʊ���ɷ�����
                    a.akc095, --�˻��޸�����
                    a.ykc031, --�������ҽ���˻���Ϣ����
                    a.akc094, --�������ҽ���˻���Ϣ����
                    a.ykc032, --���깫��Ա�˻��������
                    a.ykc033, --���깫��Ա�˻��������
                    a.ykc260, --���깫��Աע���ʽ��Ϣ����
                    a.ykc242, --���깫��Աע���ʽ��Ϣ����
                    a.yke104
           FROM xasi2.kc04 a
          WHERE a.aac001 = var_aac001
            AND a.aae001 = n_aae001;
            IF SQL%rowcount = 0 THEN
               var_flag := '2';
               var_aae013 := 'û�а�kc04���ݵ�ҽ�Ƹ����˻����!';
               GOTO label_next;
            END IF;
     EXCEPTION
       WHEN OTHERS THEN
          var_flag := '2';
          var_aae013 := '���ݵ�ҽ�Ƹ����˻��������!';
          GOTO label_next;
     END;
      --�������˻�����
      delete from xasi2.kc04 where aac001 = var_aac001;
      IF SQL%ROWCOUNT < 1 THEN
         var_flag := '2';
         var_aae013 := '�����˻����˳���!';
         GOTO label_next;
      END IF;

      <<label_next>>
      select xasi2.seq_aaz175.nextval
        into var_aaz175
        from dual;
      --������־kc04a1
      insert into xasi2.kc04a1(aaz174,
                         aaz175,
                         aac001,
                         aac002,
                         aac003,
                         akc087,
                         aae036,
                         flag,
                         aae013
                        )
                  values(
                         var_aaz174,
                         var_aaz175,
                         var_aac001,
                         var_aac002,
                         var_aac003,
                         num_akc087,
                         dat_aae036,
                         var_flag,
                         var_aae013
                        );
    end loop;
    --�ͷ��ĵ�����
    xmldom.freeDocument(doc);
    --��ѯ�����˵���Ϣ�����α�
    open prm_log for select aac001,--���˱��
                            aac002,--���֤
                            aac003,--����
                            akc087,--���˽��
                            flag, --���˱�־
                            aae013,--���� ʧ��ԭ��
                            aaz175
                       from xasi2.kc04a1
                      where aaz174 = var_aaz174;
    EXCEPTION
      WHEN OTHERS THEN
         --���ô洢���̳���
         prm_AppCode := '-1';
        prm_ErrorMsg := '�������˴洢���̳���'||SQLERRM||'�������ջ:' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
        RETURN;
  END prc_p_accountOut;
  --��д���˱�־
procedure prc_p_accountUpdate(prm_rows IN VARCHAR2,
                           prm_AppCode OUT   VARCHAR2,             --�������
                           prm_ErrorMsg  OUT   VARCHAR2
                          )
  IS
    xmlPar xmlparser.Parser := xmlparser.newParser;
    doc xmldom.DOMDocument;
    len Integer;
    ac02List xmldom.DOMNodeList;
    chilNodes xmldom.DOMNodeList;
    ac02Node xmldom.DOMNode;
    ac02ArrMap xmldom.DOMNamedNodeMap;
    var_aac001 VARCHAR2(15);
    var_aac002 VARCHAR2(18);
    var_aac003 VARCHAR2(60);
    var_yae235 VARCHAR2(6);
    var_yae238 VARCHAR2(500);
    var_aaz175 VARCHAR2(15);
  BEGIN
    prm_AppCode := '1';
    prm_ErrorMsg  := '';
    xmlPar := xmlparser.newParser;
    xmlparser.parseClob(xmlPar,prm_rows);
    doc := xmlparser.getDocument(xmlPar);
    --�ͷ�
    xmlparser.freeParser(xmlPar);
    ac02List := xmldom.getElementsByTagName(doc,'row');
    len := xmldom.getLength(ac02List);
    for i in 0..len-1 loop
      var_aac001 := '';
      var_aac002 := '';
      var_aac003 := '';
      var_yae235 := '';--���˳ɹ�Ϊ1������ʧ��Ϊ2
      var_yae238 := '';
      var_aaz175 := '';
      --��ȡ��i��
      ac02Node := xmldom.item(ac02List,i);
      --��ȡ����
     -- ac08ArrMap := xmldom.getAttributes(ac02Node);
      --��ȡ�ӽڵ�
      chilNodes := xmldom.getChildNodes(ac02Node);
      var_aac001 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,0)));
      var_aac002 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,1)));
      var_aac003 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,2)));
       var_yae235 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,3)));
      var_yae238 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,4)));
      var_aaz175 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,5)));
      update xasi2.kc04a1
         set yae235 = var_yae235,
             yae238 = var_yae238
       where aac001 = var_aac001
          and aac002 = var_aac002
         and aac003 = var_aac003
         and aaz175 = var_aaz175;
     end loop;
    EXCEPTION
      WHEN OTHERS THEN
        prm_AppCode := '-1';
        prm_ErrorMsg  := '���û�д���˱�־�洢����ʧ��!';
        RETURN;
  END prc_p_accountUpdate;*/

PROCEDURE prc_p_checkInfoByaac001(prm_aac001 IN VARCHAR2,
                           prm_aab001  IN VARCHAR2,
                           prm_flag    OUT   VARCHAR2, --1У��ʧ�ܣ��޷����� 2У��ɹ������� 3У��ɹ����о� 4У��ɹ����ϲ����� 5У��ɹ���������������  6.δ�鵽 ҽ����Ϣ
                           prm_msg     OUT   VARCHAR2,
                           prm_AppCode OUT   VARCHAR2,             --�������
                           prm_ErrorMsg  OUT   VARCHAR2 )
  IS

    var_aac001 irac01.aac001%TYPE;
    var_aac001_sj irac01.aac001%TYPE;
    var_aac002 irac01.aac002%TYPE;
    var_aac003 irac01.aac003%TYPE;
    var_yae235 irad55.yae235%TYPE;
    var_yab139 irac01.yab139%TYPE;
    var_yae238 irad55.yae238%TYPE;
    num_count  NUMBER(6);
    var_aab001       irac01.aab001%TYPE;
   var_aac031        irac01.aac031%TYPE;
   var_aab004        irab01.aab004%TYPE;
   var_aac002_jm     irac01.aac002%TYPE;
   var_15aac002    irac01.aac002%TYPE;
   var_18aac002    irac01.aac002%TYPE;
   var_aac002Low    irac01.aac002%TYPE;
   var_aac001_more  irac01.aac001%TYPE;
   nl_aac006        NUMBER;
   sj_months        NUMBER;
   xb_aac004      irac01.aac004%TYPE;
   zy_aac008      irac01.aac008%TYPE;
   zy_akc021      irac01.akc021%TYPE;
   count_aac002   NUMBER;
   man_months    NUMBER;
   woman_months    NUMBER;
   num_count1  NUMBER;
  count_jm NUMBER;
  X    varchar2(6);
  v_aac012  irac01.aac012%TYPE;
  woman_worker_months NUMBER;
  VAR_YAE097 NUMBER;
  sjqf_count NUMBER; -- �ж�ʵ�ɻ�Ƿ��
  sjqf_aab001  NUMBER; -- ʵ�ɻ�Ƿ�ѵĵ�λ���
  sjqf_aab004  irab01.aab004%TYPE; -- ʵ�ɻ�Ƿ�ѵĵ�λ����
  jzh_count NUMBER; -- �жϾ�ר��
  yl_count NUMBER; --  ���Ͻɷѱ�־

    cursor cur_ac01 IS SELECT *   FROM xasi2.ac01 A
      WHERE AAE120 = '0'
       AND A.AAC002 IN (var_15aac002, var_aac002Low, var_18aac002)

       AND AAC003 NOT LIKE '%�ظ�%';

  BEGIN
    prm_AppCode := xasi2.pkg_comm.gn_def_OK ;
    prm_ErrorMsg  := '';
    man_months := 720;
    woman_months := 660;
    woman_worker_months :=600;

/*    IF prm_aac001 IS NULL THEN
       prm_AppCode := '1';
       prm_ErrorMsg  := '������˱��Ϊ��!';
       RETURN;
    END IF;
*/    prm_flag:=2;
      PRM_MSG := '�벹¼ȱʧ��Ϣ��';

        /*SELECT aac002
        INTO count_aac002
        FROM XASI2.AC01
       WHERE AAC001 = PRM_AAC001;
       */
     IF   PRM_AAC001 IS NOT NULL  OR  PRM_AAC001 != '' THEN

     SELECT aac002
        INTO var_aac002_jm
        FROM XASI2.AC01
       WHERE AAC001 = PRM_AAC001;


       --��ȡ������ʽ��֤������
    var_15aac002  := SUBSTR(var_aac002_jm, 1, 6) ||
                     SUBSTR(var_aac002_jm, 9, 9);
    var_aac002Low := LOWER(var_aac002_jm);

    var_18aac002  := var_aac002_jm;

    SELECT count(1)
      INTO num_count
      FROM xasi2.ac01 A
     WHERE AAE120 = '0'
       AND A.AAC002 IN (var_15aac002, var_aac002Low,var_18aac002)

       AND AAC003 NOT LIKE '%�ظ�%';

       -- wanghm modify ����Ч��ʵ�ɻ�Ƿ��  ��ת����������� start 20190210
       IF num_count>0 THEN

 select max(YAE097)
       into var_yae097
       from xasi2.ab02
      where aae140 <> '04'
        and aab001 = prm_aab001
        and aab051 = 1;

     IF var_yae097 IS NOT NULL THEN
     FOR rec_ac01 IN cur_ac01 LOOP
       SELECT COUNT(1)
        INTO sjqf_count
        FROM (SELECT yae202
                FROM ac08
               WHERE aac001 = rec_ac01.aac001
                 AND aae140 <>'04'
                 AND aae002 > var_yae097
                 AND aab001 not in (select aab001 from wsjb.yac170_info )
              UNION
              SELECT yae202
                FROM ac08a1
               WHERE aac001 = rec_ac01.aac001
                 AND aae140 <>'04'
                 AND aae002 > var_yae097
                 AND aab001 not in (select aab001 from wsjb.yac170_info ));
      IF sjqf_count > 0 THEN
          SELECT a.aab001,b.aab004
            INTO  sjqf_aab001 , sjqf_aab004
            FROM (SELECT aab001
                FROM ac08
               WHERE aac001 = rec_ac01.aac001
                 AND aae140 <>'04'
                 AND aae002 = to_char(add_months(to_date(var_yae097,'yyyymm'),1),'yyyymm')
              UNION
              SELECT aab001
                FROM ac08a1
               WHERE aac001 = rec_ac01.aac001
                 AND aae140 <>'04'
                 AND aae002 = to_char(add_months(to_date(var_yae097,'yyyymm'),1),'yyyymm')) a , xasi2.ab01 b
               WHERE a.aab001=b.aab001;
          PRM_FLAG := '6';
          PRM_MSG  := '����Ա�����ڵ�λ'||sjqf_aab001||sjqf_aab004||'�Ѵ��ڽɷѼ�¼��';
          GOTO LEB_OVER;
       END IF;
     END LOOP;
     END IF;
     END IF;
   -- wanghm modify ����Ч��ʵ�ɻ�Ƿ��  ��ת����������� end 20190210

    IF num_count>0 THEN
        select to_number(to_char(min(aac006),'yyyymm')),aac004,aac008   INTO nl_aac006 ,xb_aac004,zy_aac008
            from xasi2.ac01
           where aac002 IN (var_15aac002, var_aac002Low,var_18aac002)
             AND AAC003 NOT LIKE '%�ظ�%'
             AND rownum = 1
             group by aac004 , aac008;

           select trunc(months_between(sysdate,to_date(nl_aac006,'yyyymm'))) INTO sj_months from dual;
           
           --  rec_ac01
           select aac012 INTO v_aac012  from xasi2.ac01  where   aac002 IN (var_15aac002, var_aac002Low,var_18aac002)
             AND AAC003 NOT LIKE '%�ظ�%'    AND rownum = 1;

      select count(1)
             into yl_count from wsjb.irac01a7_yl
            where aae123 = '2'
              and aac002  IN (var_15aac002, var_aac002Low,var_18aac002);
                   
      IF  yl_count = 0 THEN


           IF xb_aac004 = '1' and xb_aac004 IS NOT NULL  and  sj_months >=  man_months  THEN

              select akc021  INTO  zy_akc021 from xasi2.kc01    where aac001 = prm_aac001;

              IF   zy_aac008 = 2 and  zy_akc021 =11 THEN
                --  ����ҵ����
                select akc021  INTO  zy_akc021 from xasi2.kc01   where aac001 = prm_aac001;
                ELSIF    xb_aac004 = '1' and xb_aac004 IS NOT NULL  and  sj_months >=  man_months  THEN

              PRM_FLAG := '1';
              PRM_MSG  := '����Ա��ͳ�����Ҫ��������ͣ�';
            GOTO LEB_OVER;
              END  IF;
         END IF;

          IF xb_aac004 = '2' and xb_aac004 IS NOT NULL  and  sj_months >=  woman_months  THEN
             IF   zy_aac008 = 2 and  zy_akc021 =11 THEN
                 --  ����ҵ����
                select akc021  INTO  zy_akc021 from xasi2.kc01   where aac001 = prm_aac001;
                ELSIF   xb_aac004 = '2' and xb_aac004 IS NOT NULL  and  sj_months >=  woman_months  THEN
              PRM_FLAG := '1';
              PRM_MSG  := '����Ա��ͳ�����Ҫ��������ͣ�';
            GOTO LEB_OVER;
            END  IF;
        END IF;
        
        
       /*  IF   (zy_aac008 = 2 and  zy_akc021 =11)  THEN -- ���²�����
            select X INTO X from dual;
          ELSIF    xb_aac004 = '2' and xb_aac004 IS NOT NULL    THEN  
             --  ����ɲ�  55 4  ���� 50  1  ���Ů��  ���²����� 20190703  
               
                 IF   sj_months > woman_worker_months  and v_aac012 = '1' THEN
                      PRM_FLAG := '1';
                      PRM_MSG  := '����Ա�������Ϊ���ˣ�������Ҫ��������ͣ�';
                       GOTO LEB_OVER;
                 ELSIF   sj_months >=  woman_months and  v_aac012 = '4'  THEN
                      PRM_FLAG := '1';
                      PRM_MSG  := '����Ա�������Ϊ�ɲ���������Ҫ��������ͣ�';
                       GOTO LEB_OVER;
                 END IF;
             
             END IF;
         */
        
        END IF;  
        
      END IF;





             IF  num_count > 1 OR  num_count = 1 THEN

             --ѭ��У��ac01
              FOR rec_cur_ac01 IN cur_ac01 LOOP

               SELECT aac001 INTO var_aac001_more   FROM xasi2.ac01 A
               WHERE AAE120 = '0'
               AND A.aac001 = rec_cur_ac01.aac001
               AND A.AAC002 IN (var_15aac002, var_aac002Low,var_18aac002)
                AND AAC003 NOT LIKE '%�ظ�%';


                SELECT COUNT(1)
              INTO COUNT_JM
              FROM XASI2.AC02K1
             WHERE AAC001 = var_aac001_more
               AND AAC031 = '1';
            IF COUNT_JM > 0 THEN
             SELECT AAB004
               INTO VAR_AAB004
               FROM XASI2.AB01
              WHERE AAB001 = (SELECT aab001
                                FROM XASI2.AC02K1
                               WHERE AAC001 = var_aac001_more
                                 AND AAC031 = '1');
              PRM_MSG  := '�����֤������Աҽ�Ʊ��չ�ϵĿǰ��������' || VAR_AAB004 || '�μӾ���ҽ��������:'  ||'���˱�ţ�'||var_aac001_more|| ',�α�״̬:�α��ɷѡ�';
              PRM_FLAG := '3';
               GOTO LEB_OVER;
             END IF;
           END LOOP;
          END IF;


          --У������  20181229



  END  IF ;

 /*   SELECT COUNT(1)
        INTO COUNT_JM
        FROM XASI2.AC02K1
       WHERE AAC001 = PRM_AAC001
         AND AAC031 = '1';

      IF COUNT_JM > 0 THEN
       SELECT AAB004
         INTO VAR_AAB004
         FROM XASI2.AB01
        WHERE AAB001 = (SELECT aab001
                          FROM XASI2.AC02K1
                         WHERE AAC001 = PRM_AAC001
                           AND AAC031 = '1');
        PRM_MSG  := '�����֤������Աҽ�Ʊ��չ�ϵĿǰ��������' || VAR_AAB004 || '�μӾ���ҽ��������:'  ||'���˱�ţ�'||var_aac001|| ',�α�״̬:�α��ɷѡ�';
        PRM_FLAG := '3';

        GOTO LEB_OVER;
      END IF;
       */

    -- wanghm modify �Ƿ��ھ�ר���²α� start 20190210
     IF num_count>0 THEN
     FOR rec_ac01 IN cur_ac01 LOOP
       select count(1) into jzh_count
         from xasi2.ac02 a, wsjb.yac170_info b
        where a.aab001 = b.aab001
          and aae140 = '03'
          and aac031 = '1'
          and a.aac001 = rec_ac01.aac001;
      IF jzh_count > 0 THEN
          PRM_FLAG := '7';
          --PRM_MSG  := '����Ա�ھ�ר���²α�ҽ����,���Բα�������Ϊʧҵ�����˺����ϣ�';
          GOTO LEB_OVER;
       END IF;
     END LOOP;
     END IF;
   -- wanghm modify �Ƿ��ھ�ר���²α� end 20190210

      SELECT COUNT(1)
        INTO NUM_COUNT
        FROM XASI2.AC02
       WHERE AAC001 = PRM_AAC001
         AND AAC031 = '1'
         AND AAB001 <> PRM_AAB001
         AND AAE140 IN ('03', '07', '02', '05', '08');
      IF NUM_COUNT > 0 THEN
        SELECT COUNT(1)
          INTO num_count1
          FROM XASI2.AC02
         WHERE AAC001 = PRM_AAC001
           AND aab001 = prm_aab001
           AND aae140='04'
           AND AAC031 = '1';
         IF num_count1 > 0 THEN
           PRM_FLAG := '1';
           PRM_MSG  := '����Աû�з����������������֣�';
        GOTO LEB_OVER;
         END IF;
        SELECT DISTINCT AAB001
          INTO VAR_AAB001
          FROM XASI2.AC02
         WHERE AAC001 = PRM_AAC001
           AND aae140 <>'04'
           AND AAC031 = '1';
        SELECT AAB004
          INTO VAR_AAB004
          FROM XASI2.AB01
         WHERE AAB001 = VAR_AAB001;
        PRM_FLAG := '5';
        PRM_MSG  := '�����֤������ԱĿǰ���ڲα�����λ���ƣ�' || VAR_AAB004 || '�α�������:' ||
                    VAR_AAC003 || ',�α�״̬:�α��ɷѣ�';
        GOTO LEB_OVER;
      END IF;
    <<leb_over>>
      num_count :=0;
    EXCEPTION
      WHEN OTHERS THEN
        prm_AppCode := '-1';
        prm_ErrorMsg  := '��������У��洢����ʧ��!'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
        RETURN;
  END prc_p_checkInfoByaac001;
/*****************************************************************************
   ** �������� : FUN_GETAAB020
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����ݹ�����ȡ����ҵ���ʹ����ȡ��Ӧ�ĵ�λ��������
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab020       IN     irab01.aab020%TYPE  ,--��������
   ******************************************************************************
   ** ��    �ߣ�z         �������� ��2017-09-08   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   /*��ȡ��λ��������*/
   FUNCTION  FUN_GETAAB020 (prm_aaa100     IN     aa10a1.aaa100%TYPE,  --�ֶ���
                            prm_aaa102    IN      aa10a1.aaa102%TYPE) --�ֶ�ֵ
          RETURN VARCHAR2
   IS
      n_count          NUMBER;
      v_aab020        irab01.aab020%TYPE;--��λ����
      v_aab022        irab01.aab022%TYPE;--��ҵ����
      v_yab534        irab01.yab534%TYPE;--�������
      v_yae010        irab04.yae010%TYPE;--�ɷѷ�ʽ
      v_bab503        VARCHAR2(30);--֧���������
      s_Appcode        VARCHAR2(18);
      s_Errormsg       VARCHAR2(300);
   BEGIN

      /*��ʼ������*/
      s_Appcode  := gn_def_OK;
      s_Errormsg := '';
      n_count    := 1;
      --��λ��������
      IF prm_aaa100 = 'aab020'THEN
      --���ʣ��������ι�˾��
      IF prm_aaa102 IN ('1100','1110','1123','1130','1140','1150','1151','1152','1153',
                        '2000','2100','2110','2130','2140','2151','2152','2153','5190') THEN
      v_aab020 :='150';
      --����
      ELSIF prm_aaa102 IN ('1122','5110','5111','5130','5140','5150','5600','5800','5810','6110',
                            '6150','6810','6890') THEN
      v_aab020 :='330';
      --�����������ι�˾
      ELSIF prm_aaa102 IN ('2190','1190') THEN
      v_aab020 :='159';

      ELSE
      v_aab020 :='900';
      END IF;
      RETURN v_aab020;
      END IF;
    IF prm_aaa100 = 'aab022' THEN
    IF prm_aaa102 IN ('A1','A2','A3','A4','A5') THEN
      v_aab022 :='01';
      ELSIF prm_aaa102 IN ('B6','B7','B8','B9','B10','B11','B12') THEN
      v_aab022 :='02';
      ELSIF prm_aaa102 IN ('C13','C14','C15','C16','C17','C18','C19','C20','C21','C22','C23','C24','C25','C26','C27','C28','C29','C30','C31','C32','C33','C34','C35','C36','C37','C38','C39','C40','C41','C42','C43') THEN
      v_aab022 :='03';
      ELSIF prm_aaa102 IN ('D44','D45','D46') THEN
      v_aab022 :='04';
      ELSIF prm_aaa102 IN ('E47','E48','E49','E50') THEN
      v_aab022 :='05';
      ELSIF prm_aaa102 IN ('G53','G54','G55','G56','G57','G58','G59','G60') THEN
      v_aab022 :='06';
      ELSIF prm_aaa102 IN ('I63','I64','I65') THEN
      v_aab022 :='07';
      ELSIF prm_aaa102 IN ('F51','F52') THEN
      v_aab022 :='08';
      ELSIF prm_aaa102 IN ('H61','H62') THEN
      v_aab022 :='09';
      ELSIF prm_aaa102 IN ('J66','J67','J68','J69') THEN
      v_aab022 :='10';
      ELSIF prm_aaa102 IN ('K70') THEN
      v_aab022 :='11';
      ELSIF prm_aaa102 IN ('L71','L72') THEN
      v_aab022 :='12';
      ELSIF prm_aaa102 IN ('M73','M74') THEN
      v_aab022 :='13';
      ELSIF prm_aaa102 IN ('N76','N77','N78') THEN
      v_aab022 :='14';
      ELSIF prm_aaa102 IN ('O79','O80','O81') THEN
      v_aab022 :='15';
      ELSIF prm_aaa102 IN ('P82') THEN
      v_aab022 :='16';
      ELSIF prm_aaa102 IN ('Q83','Q84','S93') THEN
      v_aab022 :='17';
      ELSIF prm_aaa102 IN ('R85','R86','R87','R88','R89') THEN
      v_aab022 :='18';
      ELSIF prm_aaa102 IN ('S94') THEN
      v_aab022 :='19';
      ELSIF prm_aaa102 IN ('T96') THEN
      v_aab022 :='20';
      ELSE
      v_aab022 :='00';
      END IF;
    RETURN v_aab022;
    END IF;
   IF prm_aaa100 = 'yab534' THEN
     IF prm_aaa102 = '2' THEN
      v_yab534 := 'GH';
      ELSIF prm_aaa102 = '3' THEN
      v_yab534 := 'ZH';
      ELSIF prm_aaa102 = '4' THEN
      v_yab534 := 'JH';
      ELSIF prm_aaa102 = '5' THEN
      v_yab534 := 'NH';
      ELSIF prm_aaa102 = '6' THEN
      v_yab534 := 'JT';
      ELSIF prm_aaa102 = '7' THEN
      v_yab534 := 'XH';
      ELSIF prm_aaa102 = '9' THEN
      v_yab534 := 'ZS';
      ELSE
      v_yab534 := 'ZH';
      END IF;
      RETURN v_yab534;
      END IF;
   IF prm_aaa100 = 'yae010' THEN
      IF prm_aaa102 = '1' THEN
      v_yae010 := '3';
      ELSIF prm_aaa102 = '3' THEN
      v_yae010 := '2';
      ELSE
      v_yae010 := '9';
      END IF;
      RETURN v_yae010;
      END IF;

   IF prm_aaa100 = 'bab503' THEN
      IF prm_aaa102 = '2' THEN
      v_bab503 := '102';
      ELSIF prm_aaa102 = '3' THEN
      v_bab503 := '104';
      ELSIF prm_aaa102 = '4' THEN
      v_bab503 := '105';
      ELSIF prm_aaa102 = '5' THEN
      v_bab503 := '103';
      ELSIF prm_aaa102 = '6' THEN
      v_bab503 := '301';
      ELSIF prm_aaa102 = '9' THEN
      v_bab503 := '308';
      ELSE
      v_bab503 := '000';
      END IF;
      RETURN v_bab503;
      END IF;

   EXCEPTION
     -- WHEN NO_DATA_FOUND THEN
     -- WHEN TOO_MANY_ROWS THEN
     -- WHEN DUP_VAL_ON_INDEX THEN
     WHEN OTHERS THEN
       /*�رմ򿪵��α�*/
       RETURN '';
   END FUN_GETAAB020;


PROCEDURE prc_p_checkInfoByYear(prm_aab001 IN VARCHAR2,
                                prm_yab139 IN  VARCHAR2,     --�������
                                prm_aae001 OUT NUMBER,
                                prm_aae002 OUT NUMBER,
                                prm_disabledBtn    OUT VARCHAR2,
                                prm_msg     OUT   VARCHAR2,
                                prm_dxby01    OUT   VARCHAR2,
                                prm_gxby01    OUT   VARCHAR2,
                                prm_dxby03  OUT   VARCHAR2,
                                prm_gxby03  OUT   VARCHAR2,
                                prm_AppCode OUT   VARCHAR2,             --�������
                                prm_ErrorMsg  OUT   VARCHAR2
                              )
  IS


    num_count  NUMBER(6);
    num_yae097_min NUMBER(6);
    num_yae097_max NUMBER(6);
    num_aae001 NUMBER(4);
    var_iaa002 irab01.iaa002%TYPE;
    var_iaa006 irad51.iaa006%TYPE;
    dat_aae036 DATE;
    num_aae002 NUMBER(6);


  BEGIN
    prm_AppCode := xasi2.pkg_comm.gn_def_OK ;
    prm_ErrorMsg  := '';
    --���鴫�����
    IF prm_aab001 IS NULL THEN
       prm_AppCode := '1';
       prm_ErrorMsg  := '���뵥λ��Ų���Ϊ��!';
       RETURN;
    END IF;

    prm_disabledBtn :='printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,cancelBtn';


    SELECT count(1)
      INTO num_count
      FROM xasi2.ab02
     WHERE aab001 = prm_aab001;
    IF num_count > 0 THEN
       --�����������ں��Ƿ�����
        SELECT MAX(yae097)
          INTO num_yae097_max
          FROM xasi2.ab02
         WHERE aab001 = prm_aab001
           and AAB051 = '1' ;

         SELECT MIN(yae097)
          INTO num_yae097_min
          FROM xasi2.ab02
         WHERE aab001 = prm_aab001
           and  AAB051 = '1' ;

         IF num_yae097_min <> num_yae097_max THEN
            prm_msg :='��λ��������ںŲ�һ�£�';
            GOTO leb_over;
         END IF;

      --modify by whm 20190429  ȡ������� start
      SELECT MAX(aae042)
        INTO num_yae097_max
        FROM xasi2.ab02
       WHERE aab001 = prm_aab001
         AND AAB051 = '1';
     --modify by whm 20190429  ȡ������� end

--         IF var_yae097_max < 201712 THEN
--            prm_msg := '���ɷ��ں�С��201712!';
--            GOTO leb_over;
--          END IF;
     ELSE
        SELECT MAX(aae003)
          INTO num_yae097_max
          FROM wsjb.IRAB08
         WHERE aab001 = prm_aab001
           AND yae517 = 'H01'
           AND aae140 = '01';

--         IF var_yae097_max < 201712 THEN
--            prm_msg := '���ɷ��ں�С��201712!';
--            GOTO leb_over;
--          END IF;
     END IF;

     --����������
     num_aae001 :=SUBSTR(num_yae097_max,0,4)+1;
     
       SELECT count(1)
       INTO num_count
       FROM wsjb.irad54
      WHERE aab001 = prm_aab001
        AND aae001 = num_aae001
        AND iaa011 = 'A05';
     IF num_count > 0 THEN
        prm_msg :='���ύ������Ϣ�����������ҵ��ԤԼ������ӡ��ر���Я��������ϣ����籣������ˣ��緢�����󣬿����г����ύ���޸���ȷ���ٴ��ύ��';
        prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,delBtn';
        GOTO leb_over;
     END IF;

     SELECT count(1)
       INTO num_count
       FROM wsjb.irad51
      WHERE aab001 = prm_aab001
        AND aae001 = num_aae001
        AND iaa011 = 'A05';

     IF num_count > 0 THEN
        SELECT IAA002,
               iaa006,
               aae036+5
          INTO var_iaa002,
               var_iaa006,
               dat_aae036
          FROM wsjb.irad51
         WHERE aab001 = prm_aab001
           AND aae001 = num_aae001
           AND iaa011 = 'A05';

        IF var_iaa002 = '1' THEN
           --prm_msg :='���ύ������Ϣ�����ӡ��ر������籣������ˣ��緢�����󣬿����г����ύ���޸���ȷ���ٴ��ύ��';
           prm_msg :='���ύ������Ϣ����ȴ��籣������ˣ��緢�����󣬿����г����ύ���޸���ȷ���ٴ��ύ��';
           prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,delBtn';
           GOTO leb_over;
        END IF;
        IF var_iaa002 = '2' AND var_iaa006 ='0' THEN
           prm_msg :='���걨��Ϣ������˵���...';
           prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,cancelBtn,printBtn3,printBtn4,delBtn,printBtn5';
           GOTO leb_over;
        END IF;
        IF var_iaa002 = '3' AND var_iaa006 ='0' THEN
           prm_msg :='���걨��Ϣ���δͨ�����޸ĺ�����ύ!';
           prm_disabledBtn :='printBtn3,printBtn4,printBtn5,delBtn';
        END IF;

        IF var_iaa002 = '2' AND var_iaa006 ='1' THEN

           IF dat_aae036 > SYSDATE THEN
               prm_msg :='���걨��Ϣ�����ɣ����ӡ��ر�����ʱ�ɷѣ�';
               prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,cancelBtn,delBtn';
               GOTO leb_over;
           ELSE
               IF num_yae097_max < TO_NUMBER(TO_CHAR(num_aae001||'12')) THEN
                  prm_msg :='��λ�������ڻ�δ��'||TO_CHAR(num_aae001||'12')||'����������ϵͳ���걨��'||TO_CHAR(num_aae001||'12')||'�¶�!';
                  prm_disabledBtn :='queryBtn,exportBtn,importBtn,retainBtn,viewBtn,applyBtn,cancelBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5';
                  GOTO leb_over;
               END IF;
                num_aae001 := num_aae001 + 1;
           END IF;
        END IF;
    ELSE
       --����Ƿ���������ǰ��������δ���
    SELECT count(1)
      INTO num_count
      FROM irad51a1
      WHERE aab001 = prm_aab001
        AND yae031='0';
    IF num_count > 0 THEN

     prm_msg :='��λ��δ�������ϱ�����ǰ����ҵ�񣬲��������������';
     prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,cancelBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,viewBtn';
     GOTO leb_over;
     END IF;
     --����Ƿ���δ�ύ����Ա����
     SELECT count(1)
      INTO num_count
      FROM wsjb.irac01
      WHERE aab001 = prm_aab001
        AND iaa001 IN ('1','3','5','6','7','8')
        AND iaa100 IS NULL;
    IF num_count > 0 THEN

     prm_msg :='��λ��δ�ύ����Ա������Ϣ�����ύ�±�����������Ϣ�����½������������';
     prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,cancelBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,viewBtn';
     GOTO leb_over;
     END IF;
     --����Ƿ���δ�ύ������δת�뱸��
     SELECT count(1)
      INTO num_count
      FROM wsjb.irac01c1
      WHERE aab001 = prm_aab001
        AND yae031='0';
    IF num_count > 0 THEN
     prm_msg :='��λ��δ�ύ������δת�뱸����Ϣ�����ύ���������½������������';
     prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,cancelBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,viewBtn';
     GOTO leb_over;
     END IF;
     --��鵥λ�Ƿ���δ��˵����걨��Ϣ
     SELECT count(1)
      INTO num_count
      FROM wsjb.irad01
      WHERE aab001 = prm_aab001
        AND iaa100 >= prm_aae001||01
        AND iaa011 = 'A04';
    IF num_count > 0 THEN
      SELECT MAX(iaa100)
      INTO num_aae002
      FROM wsjb.irad01
      WHERE aab001 = prm_aab001
        AND iaa100 >= prm_aae001||01
        AND iaa011 = 'A04';
        SELECT SUM(coun)
          INTO num_count
          FROM
         (SELECT COUNT(1) AS coun
                 FROM xasi2.ab08
                WHERE aab001 = prm_aab001
                  AND yae517 = 'H01'
                  AND aae003 = num_aae002
               UNION
                SELECT COUNT(1) AS coun
                  FROM wsjb.irab08
                  WHERE aab001 = prm_aab001
                  AND yae517 = 'H01'
                  AND aae003 = num_aae002);
       IF num_count = 0 THEN
         prm_msg :='��λ�ύ�����걨��δ���ͨ������ͨ�����ٽ������������';
         prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,cancelBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,viewBtn';
         GOTO leb_over;
             END IF;


     END IF;
     SELECT count(1)
       INTO num_count
       FROM wsjb.irac01c1
      WHERE aab001 = prm_aab001
        AND yae031='1';
      IF num_count >0 THEN
       SELECT MAX(iaa100)
         INTO num_aae002
         FROM wsjb.irac01c1
        WHERE aab001 = prm_aab001
          AND yae031='1';
        SELECT count(1)
          INTO num_count
          FROM wsjb.irab08
         WHERE aab001 = prm_aab001
           AND aae003 = num_aae002
           AND yae517 = 'H01';
       IF num_count = 0 THEN
        prm_msg :='�㵥λ������δ�걨������δת�뱸����Ϣ�����ύ�±�����������Ϣ������½������������';
         prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,cancelBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,viewBtn';
         GOTO leb_over;
        END IF;
       END IF;
     --����Ƿ�����Ϣ���ҵ��
     SELECT count(1)
       INTO num_count
      FROM IRAD31 A, IRAD32 B
       WHERE A.IAZ012 = B.IAZ012
         AND A.AAB001 = PRM_AAB001
         AND A.IAA019 = '1'
         AND A.IAA011 = 'A03';
       IF num_count >0 THEN
        prm_msg :='��λ��δ������Ա��Ҫ��Ϣ���ҵ���밴Ҫ�󵽹�̨��˻������ٽ������������';
        prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,cancelBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,viewBtn';
        GOTO leb_over;
        END IF;
     END IF;





    --��ȡ�ɷ�������
    --����
    SELECT MAX(aae041)
      INTO num_aae002
      FROM xasi2.AA02
     WHERE yaa001 = '16'
       AND aae140 = '01'
       AND aae001 = num_aae001;
    SELECT to_char(PKG_COMMON.fun_p_getcontributionbase(null,prm_aab001,1,'0','01','1','1',num_aae002,prm_yab139))
      INTO prm_dxby01
      FROM dual;
    SELECT count(1)
      INTO num_count
      FROM xasi2.AA02
     WHERE yaa001 = '16'
       AND aae140 = '01';
    IF num_count <2 THEN
      SELECT to_char(TRUNC(PKG_COMMON.fun_p_getcontributionbase(null,prm_aab001,20000000,'0','01','1','1',num_aae002,prm_yab139)*1.1))
        INTO prm_gxby01
        FROM dual;
    ELSE
      SELECT to_char(TRUNC(PKG_COMMON.fun_p_getcontributionbase(null,prm_aab001,20000000,'0','01','1','1',num_aae002,prm_yab139)))
        INTO prm_gxby01
        FROM dual;
    END IF;
    --ҽ��
    SELECT MAX(aae041)
      INTO num_aae002
      FROM xasi2.AA02
     WHERE yaa001 = '16'
       AND aae140 = '03'
       AND aae001 = num_aae001;
    SELECT to_char(PKG_COMMON.fun_p_getcontributionbase(null,prm_aab001,1,'0','03','1','1',num_aae002,prm_yab139))
      INTO prm_dxby03
      FROM dual;
    SELECT to_char(PKG_COMMON.fun_p_getcontributionbase(null,prm_aab001,20000000,'0','03','1','1',num_aae002,prm_yab139))
      INTO prm_gxby03
      FROM dual;
    <<leb_over>>
    num_count :=0;
    prm_aae001 := num_aae001;
    prm_aae002 := num_aae001||'01';
    EXCEPTION
      WHEN OTHERS THEN
        prm_AppCode := '-1';
        prm_ErrorMsg  := '��������У��洢����ʧ��!'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
        RETURN;
  END prc_p_checkInfoByYear;
END pkg_P_Validate;
/
