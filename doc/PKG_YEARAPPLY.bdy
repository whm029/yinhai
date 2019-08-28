CREATE OR REPLACE PACKAGE BODY PKG_YEARAPPLY AS
   /********************************************************************************/
   /*  ������� ��PKG_YearApply                                                    */
   /*  ҵ�񻷽� ����λ���걨                                                       */
   /*  �����б� ���������̺���                                                     */
   /*             01 prc_YearSalaryAdjustPaded           ���걨����У��            */
   /*             02 prc_YearInternetApply               ����λ�걨              */
   /*             03 prc_RBYearInternetApply             ����λ�걨����          */
   /*             04 prc_YearSalary                      ���걨--�޸Ľɷѹ���      */
   /*              05 prc_YearSalaryBC                    ���걨--����              */
   /*             06 prc_YearSalaryBCByYL                ���걨--���ϲ���          */
   /*  ˽�й��̺���                                                                */
   /*             -----------------------ҵ�������------------------------------*/

   /*  ����˵�� ��                                                                 */
   /*                                                                              */
   /*  �� �� �� ��                                                                 */
   /*  ������� ��2013-05-21                                                       */
   /*  �汾��� ��Ver 1.0                                                          */
   /*  �� �� �� ��������                      ������� ��YYYY-MM-DD                   */
   /********************************************************************************/
   PRE_ERRCODE  CONSTANT VARCHAR2(18) := 'YearApply'; -- �����Ĵ�����ǰ׺
PROCEDURE prc_insertIRAC08A1(prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                             prm_aac001       IN     xasi2.ac01.aac001%TYPE,
                             prm_aae002       IN     NUMBER            ,--�������
                             prm_aae003       IN     NUMBER,
                             prm_aac040       IN     xasi2.ac02.aac040%TYPE,
                             prm_yae518       IN     xasi2.ac08a1.yae518%TYPE,
                             prm_aae076       IN     xasi2.ab08.aae076%TYPE,
                             prm_aae011       IN     irad31.aae011%TYPE,--������
                             prm_yab139       IN     VARCHAR2          ,--�α�����������
                             prm_AppCode      OUT    VARCHAR2          ,
                             prm_ErrorMsg     OUT    VARCHAR2          );
PROCEDURE prc_insertAC08A1  (prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                             prm_aac001       IN     xasi2.ac01.aac001%TYPE,
                             prm_aae002       IN     NUMBER            ,--�������
                             prm_aae003       IN     NUMBER,
                             prm_aac040       IN     xasi2.ac02.aac040%TYPE,
                             prm_yae518       IN     xasi2.ac08a1.yae518%TYPE,
                             prm_aae076       IN     xasi2.ab08.aae076%TYPE,
                             prm_aae140       IN     VARCHAR2,
                             prm_aae011       IN     irad31.aae011%TYPE,--������
                             prm_yab139       IN     VARCHAR2          ,--�α�����������
                             prm_AppCode      OUT    VARCHAR2          ,
                             prm_ErrorMsg     OUT    VARCHAR2          );

PROCEDURE prc_YearSalaryRB   ( prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                               prm_aae001       IN     NUMBER            ,--�������
                               prm_iaa011       IN     irad51.iaa011%TYPE,--ҵ������
                               prm_yab019       IN     VARCHAR2     ,--���ͱ�־
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          );

/*****************************************************************************
   ** �������� : prc_YearSalaryAdjustPaded
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ���
   **           prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
   **           prm_aae011       IN     irad31.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-09   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
PROCEDURE prc_YearSalaryAdjustPaded(prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                                    prm_aac001       IN     irac01.aac001%TYPE,--���˱��  �Ǳ���
                                    prm_aac040       IN     xasi2.ac02.aac040%TYPE, --���� �Ǳ���
                                    prm_aae001       IN     NUMBER            ,--�������
                                    prm_aae011       IN     irad31.aae011%TYPE,--������
                                    prm_yab139       IN     VARCHAR2          ,--�α�����������
                                    prm_yab019       IN     xasi2.ac01k8.yab019%TYPE  ,--ҵ�����ͱ�־
                                    prm_AppCode      OUT    VARCHAR2          ,
                                    prm_ErrorMsg     OUT    VARCHAR2          )
   IS
       num_count     NUMBER;
      num_county     NUMBER;
      v_msg        VARCHAR2(300);
      var_aaz002   iraa01.aaz002%TYPE;
      num_aae041_year NUMBER(6);  --���ʼʱ��
      num_yae097   xasi2.ab02.yae097%TYPE; --��λ��������ں�
      var_aae140   xasi2.ab02.aae140%TYPE; --����
      var_aac001   xasi2.ac01.aac001%TYPE; --���˱��
      num_aae002   xasi2.ac08a1.aae002%TYPE;
      num_aac040   xasi2.ac02.aac040%TYPE;
      num_spgz     xasi2.ac02.aac040%TYPE;
      num_yac004   xasi2.ac02.yac004%TYPE;
      var_yab136   xasi2.ab01.yab136%TYPE;
      var_yab275   xasi2.ab01.yab275%TYPE;
      var_aae119   xasi2.ab01.aae119%TYPE;
      var_aab019   xasi2.ab01.aab019%TYPE;
      var_yac503   xasi2.ac02.yac503%TYPE;
      var_yac505   xasi2.ac02.yac505%TYPE;
      num_yac400   tmp_ac42.yac401%TYPE;
      num_yac401   tmp_ac42.yac401%type;           --1�²�����,NUMBER
      num_yac402   tmp_ac42.yac401%type;           --2�²�����,NUMBER
      num_yac403   tmp_ac42.yac401%type;           --3�²�����,NUMBER
      num_yac404   tmp_ac42.yac401%type;           --4�²�����,NUMBER
      num_yac405   tmp_ac42.yac401%type;           --5�²�����,NUMBER
      num_yac406   tmp_ac42.yac401%type;           --6�²�����,NUMBER
      num_yac407   tmp_ac42.yac401%type;           --7�²�����,NUMBER
      num_yac408   tmp_ac42.yac401%type;           --8�²�����,NUMBER
      num_yac409   tmp_ac42.yac401%type;           --9�²�����,NUMBER
      num_yac410   tmp_ac42.yac401%type;           --10�²�����,NUMBER
      num_yac411   tmp_ac42.yac401%type;           --11�²�����,NUMBER
      num_yac412   tmp_ac42.yac401%type;           --12�²�����,NUMBER
      var_procNo   VARCHAR2(5);                    --���̺�
      var_aae013   tmp_ac42.aae013%TYPE;
      var_aae100   VARCHAR2(9);
      var_aae142   xasi2.aa02a3.aae142%TYPE;    --��������
      var_aac008   xasi2.ac01.aac008%TYPE;               --��Ա״̬
      num_aic162   NUMBER(6);
      num_aae002_max NUMBER(6);
      num_yaa006   NUMBER(14,2);
      num_iaa100  NUMBER;
     --��ȡ��λ�α���Ϣ
      CURSOR cur_ab02 IS
       SELECT aae140,             --����
              yae097              --��������ں�
         FROM xasi2.ab02
        WHERE aab001 = prm_aab001
          AND aab051 = xasi2.pkg_comm.AAB051_CBJF
          AND aae140 NOT IN (xasi2.pkg_comm.AAE140_DEYL,'08')    --�����в���
          AND prm_yab019 = '1';
      --���ݽɷѼ�¼��ȡ��Ҫ�������Ա
      CURSOR cur_ab05a1 IS
        SELECT aac001,
               aab001,
               aac002,
               NVL(yac506,0) AS yac506,
               NVL(yac507,0) AS yac507,
               NVL(yac508,0) AS yac508,
               NVL(yac503,0) AS yac503,--�������
               NVL(aac040,0) AS aac040,--�����ɷѹ���
               NVL(yac004,0) AS yac004,--��������Ͻɷѻ���
               NVL(yaa333,0) AS yaa333,--�����ɷѻ���
               NVL(yac005,0) AS yac005--���˽ɷѹ���
          FROM xasi2.ac01k8
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND yab019 = prm_yab019
           AND (AAE013 is null or AAE013 ='1' or AAE013 ='2' or AAE013 ='22')
           AND (1 = NVL(prm_aac001,1) OR aac001 = NVL(prm_aac001,1));
      --��ȡ��ʱ���е�У��ɹ���Ϣ(ҽ��)
      CURSOR cur_tmp IS
        SELECT AAC001,       --���˱���,VARCHAR2
               AAE002,       --�ѿ������ں�,NUMBER
               YAC505,       --���˽ɷ����,VARCHAR2
               AAA040,       --�ɷѱ������,VARCHAR2
               AAE140,       --����,VARCHAR2
               AAE143,       --�ɷ����,VARCHAR2
               YAC503,       --��������,VARCHAR2
               DECODE(aae100,xasi2.pkg_comm.AAE100_WX,0,AAC040) AS AAC040,       --�ɷѹ���,NUMBER
               YAC004,       --���˽ɷѻ���,NUMBER
               YAA333,       --���ʻ�����,NUMBER
               YAE010,       --������Դ,VARCHAR2
               YAA330,       --�ɷѱ���ģʽ,VARCHAR2
               AAA041,       --���˽ɷѱ���,NUMBER
               YAA017,       --���˽ɷѻ���ͳ�����,NUMBER
               AAA042,       --��λ�ɷѱ���,NUMBER
               AAA043,       --��λ�ɷѻ����ʻ�����,NUMBER
               ALA080,       --���˸�������,NUMBER
               AKC023,       --ʵ������,NUMBER
               YAC176,       --����,NUMBER
               AAC008,       --��Ա״̬,VARCHAR2
               AKC021,       --ҽ����Ա���,VARCHAR2
               YKC120,       --ҽ���չ���Ա���,VARCHAR2
               YKC279,       --�Ƿ�д������Ϣ��־,VARCHAR2
               YAC168,       --ũ�񹤱�־,VARCHAR2
               YAA310,       --�������,VARCHAR2
               AAE114,       --�ɷѱ�־,VARCHAR2
               AAE100,       --��Ч��־,VARCHAR2
               AAE013        --��ע,VARCHAR2
          FROM xasi2.tmp_grbs02  --���˲���
         WHERE aac001 = var_aac001
           AND aae140 = var_aae140;
           --AND aae100 = var_aae100;
        --��ȡ��ʱ���е�У��ɹ���Ϣ(����)
      CURSOR cur_irac01c1 IS
        SELECT *
          FROM wsjb.irac01c1
         WHERE aab001 = prm_aab001
           AND yae031 = '1';
   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      var_procNo   :='Y01';
      --��ȡ��λ��ǰ�Ĺ�������
      BEGIN
         SELECT yab136,
                yab275,
                aae119,
                aab019
           INTO var_yab136,
                var_yab275,
                var_aae119,
                var_aab019
           FROM xasi2.ab01
          WHERE aab001 = prm_aab001;
      EXCEPTION
         WHEN OTHERS THEN
            prm_AppCode := ''||var_procNo||'02';
            prm_ErrorMsg  := '��λ����'||prm_aab001||'�籣�������'||prm_yab139||'û�л�ȡ����λ������Ϣ';
            RETURN;
      END;

      --����Ǹ��˹��ʱ���
      IF prm_aac001 IS NOT NULL THEN
         IF prm_aac040 IS NULL THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '���ʲ���Ϊ��';
            RETURN;
         END IF;
      END IF;
      --��ȡ����ʼ�ں�  ȡ��λ��������ں�����
      SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(yae097),'yyyymm'),1),'yyyymm'))   --��ȡ�����ں�
        INTO num_aae002
        FROM xasi2.ab02
       WHERE aab001 = prm_aab001;

      FOR rec_ab05a1 IN cur_ab05a1 LOOP
          var_aac001 := rec_ab05a1.aac001;
          num_aac040 := round(rec_ab05a1.aac040);

          IF prm_aac001 IS NOT NULL THEN
             num_aac040 := round(prm_aac040);
          END IF;
      --ҽ�����յĲ���У��
          FOR rec_ab02 IN cur_ab02 LOOP

              var_aae140 := rec_ab02.aae140;
              num_yae097 := rec_ab02.yae097;

              --��ȡ��λ�����ֵĲ�������ں�

              --��ȡ����Ŀ�ʼʱ��
              BEGIN
                SELECT aae041,           --���ʼʱ��
                       aae142
                  INTO num_aae041_year,
                       var_aae142
                  FROM xasi2.aa02a3
                 WHERE aae140 = var_aae140
                   AND aae001 = prm_aae001
                   AND yab139 = prm_yab139;
                EXCEPTION
                     WHEN OTHERS THEN
                          prm_AppCode  :=  gn_def_ERR;
                          prm_ErrorMsg := var_aae140||'��ȡ���󲹲�����쳣'||prm_aae001||prm_yab139;
                          RETURN;
              END;
              IF var_aae142 = '1' THEN   --�����������Ϊ��������α���Ա
                 SELECT count(1)
                   INTO num_count
                   FROM xasi2.ac02
                  WHERE aac001 = var_aac001
                    AND aab001 = prm_aab001
                    AND aae140 = var_aae140
                    AND aac031 = xasi2.pkg_comm.AAC031_CBJF;

                 --��ѯ��Ա״̬  ��Ҫ�����Ƿ������ݡ�������Ա ��Ϊ���ݡ�������ԱҲҪ���в���
                 SELECT count(1)
                   INTO num_county
                   FROM xasi2.ac01
                  WHERE aac001 = var_aac001;
              IF num_count>0 THEN
                 SELECT AAC008
                   INTO var_aac008
                   FROM xasi2.ac01
                  WHERE aac001 = var_aac001;
               END IF;
                 --�����Աû���ڱ���λ�������α���Ϣ����Ϊ��ְ��Ա�򲻽��в���
                 IF num_count < 1 OR var_aac008 = xasi2.pkg_comm.AAC008_TX THEN
                    GOTO leb_next;
                 END IF;
              END IF;
              --������ʼʱ�����ڵ�λ��������ں��򲻽��в���
              IF num_aae041_year <= num_yae097 THEN
                      --��ȡ��Ա������Ϣ
                      IF rec_ab05a1.yac508 > 0  THEN   --���ԭ�ɷѻ�������0��˵������˲μ�ҽ������

                         IF var_aae140 = xasi2.pkg_comm.aae140_GS THEN
                             var_yac503 := xasi2.pkg_comm.YAC503_SB;
                             var_yac505 := xasi2.pkg_comm.YAC505_GSPT;
                         ELSE
                            BEGIN
                              SELECT yac503,
                                     YAC505
                                INTO var_yac503,
                                     var_yac505
                                FROM xasi2.ac02
                               WHERE aac001 = var_aac001
                                 AND aae140 = var_aae140;
                             EXCEPTION
                                  WHEN OTHERS THEN

                                       IF var_aae140 = xasi2.pkg_comm.AAE140_SYE THEN
                                          var_yac505 := xasi2.pkg_comm.YAC505_SYEPT;
                                       END IF;

                                       IF var_aae140 = xasi2.pkg_comm.AAE140_JBYL THEN
                                          var_yac505 := xasi2.pkg_comm.YAC505_YLPT;
                                       END IF;

                                       IF var_aae140 = xasi2.pkg_comm.AAE140_SYU THEN
                                          var_yac505 := xasi2.pkg_comm.YAC505_SYUPT;
                                       END IF;

     /*                                  IF var_aae140 = xasi2.pkg_comm.AAE140_JGYL THEN
                                          var_yac505 := xasi2.pkg_comm.YAC505_JGYLPT;
                                       END IF;*/
                            END;
                            --�������д�� Ϊ�걨����
                            var_yac503 := xasi2.pkg_comm.YAC503_SB;

                         END IF;

                         IF var_aae140 <> '06' THEN
                             --���ñ��׷ⶥ���̣���ȡ�ɷѻ����ͽɷѹ���
                              SELECT MAX(aae041)
                                INTO num_aae002_max
                                FROM xasi2.AA02
                               WHERE yaa001 = '16'
                                 AND aae140 = var_aae140
                                 AND aae001 = prm_aae001;
                             xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase
                                                                   (var_aac001   ,     --���˱���
                                                                    prm_aab001   ,     --��λ����
                                                                    num_aac040   ,     --�ɷѹ���
                                                                    var_yac503   ,     --�������
                                                                    var_aae140   ,     --��������
                                                                    var_yac505   ,     --�ɷ���Ա���
                                                                    var_yab136   ,     --��λ�������ͣ���������ɷ���Ա��
                                                                    num_aae002_max   ,     --�ѿ�������
                                                                    prm_yab139   ,     --�α�������
                                                                    num_yac004   ,     --�ɷѻ���
                                                                    prm_AppCode  ,     --�������
                                                                    prm_ErrorMsg );    --��������
                             IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                                RETURN;
                             END IF;
                             
                             
                              --�жϸ��幤�̻�(2019����ǰ����������ƽ)
                              IF var_aab019 = '60' and prm_aae001<2019 THEN
                                  --��ȡ��ƽ����
                                  num_spgz := xasi2.pkg_comm.fun_GetAvgSalary(var_aae140,'16',num_aae002_max,PKG_Constant.YAB003_JBFZX);
                                  --�������Ϊ���� �ɷѹ��ʺͽɷѻ���Ϊ��ƽ����
                                   IF var_aae140 = xasi2.pkg_comm.AAE140_GS THEN
                                       num_yac004 := ROUND(num_spgz/12);
                                   ELSE
                                      IF num_aac040 > ROUND(num_spgz/12) THEN
                                       num_yac004 := ROUND(num_spgz/12);
                                      END  IF;
                                   END IF;
                             END IF;  
                             
                             IF var_yac503 = xasi2.pkg_comm.YAC503_LRYLJ THEN
                                num_yac004 := rec_ab05a1.yaa333;
                             END IF;
                         ELSE
                           num_yac004 := rec_ab05a1.yac004;
                         END IF;

                         IF var_aae140 = xasi2.pkg_comm.AAE140_JBYL THEN
                             --�������½ɷ���Ա
                             SELECT count(1)
                               INTO num_count
                               FROM xasi2.ac02_zy
                              WHERE aac001 = var_aac001
                                AND aae120 = '0';
                              IF num_count > 0 THEN
                                 SELECT aic162,
                                        yac004
                                   INTO num_aic162,
                                        num_yac004
                                   FROM xasi2.ac02_zy
                                  WHERE aac001 = var_aac001
                                    AND aae120 = '0';
                                 IF SUBSTR(num_aic162,0,4)= prm_aae001 THEN
                                    num_spgz := xasi2.pkg_comm.fun_GetAvgSalary(var_aae140,'16',prm_aae001||'12',PKG_Constant.YAB003_JBFZX);
                                    num_yac004 := ROUND(num_spgz/12);
                                 END IF;
                              END IF;
                          END IF;

                          DELETE xasi2.tmp_grbs01;                 --�����ʱ��
                          --���벹����ʱ����
                          INSERT INTO xasi2.tmp_grbs01
                                               (aac001,   --���˱���
                                                aae041,   --��ʼ�ں�
                                                aae042,   --��ֹ�ں�
                                                aae140,   --����
                                                yac503,   --�������
                                                aac040,   --�ɷѹ���
                                                yaa333,   --�ʻ�����
                                                aae100,   --��Ч��־
                                                aae013    --��ע
                                                )
                                        VALUES (var_aac001,
                                                num_aae041_year,
                                                num_yae097,
                                                var_aae140,
                                                var_yac503,                                    --�������
                                                num_yac004,                           --�����ɷѹ���  ����ǹ���������ȡ���˵Ľɷѹ��� ��ҪΪ�����ָ��嵥λ
                                                rec_ab05a1.yaa333,
                                                NULL,
                                                NULL);
                          --���ò�����Ĺ���
                         /* xasi2.pkg_p_payAdjust.prc_p_checkData(
                                                                  prm_aab001 ,   --��λ���
                                                                  '1'   ,   --���ʽ��0 �ɷѱ������ 1 �ɷѻ������
                                                                  prm_yab139 ,   --�α�����������
                                                                  prm_yab139 ,   --�籣�������
                                                                  prm_AppCode,   --ִ�д���
                                                                  prm_ErrorMsg   --ִ�н��
                                                                 );
                          IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                             RETURN;
                          END IF;*/

                          --modify by fenggg at 20181208 begin
                          --����У�齫ԭ���Ĺ��� ��xasi2.pkg_p_payAdjust.prc_p_checkData�� �滻Ϊ
                          --�����о�����У����� ��xasi2.pkg_p_salaryexamineadjust.prc_p_checkData����
                          --��������������������㲹�����
                          xasi2.pkg_p_salaryexamineadjust.prc_p_checkData(
                                                                  prm_aab001 ,   --��λ���
                                                                  '1'   ,   --���ʽ��0 �ɷѱ������ 1 �ɷѻ������
                                                                  prm_yab139 ,   --�α�����������
                                                                  prm_yab139 ,   --�籣�������
                                                                  prm_AppCode,   --ִ�д���
                                                                  prm_ErrorMsg   --ִ�н��
                                                                 );
                          IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                             RETURN;
                          END IF;
                          --modify by fenggg at 20181208 end

                          --��ȡ����У��ɹ���Ϣ
--                          SELECT count(1)
--                            INTO num_count
--                            FROM xasi2_zs.tmp_grbs02
--                           WHERE aae100 = xasi2_zs.pkg_comm.AAE100_YX
--                             AND aac001 = var_aac001;
--
--                             var_aae100 := xasi2_zs.pkg_comm.AAE100_WX;
--                             IF var_aae140 = '04' THEN
--                             FOR rec_tmp1 IN cur_tmp LOOP
--                                 var_aae013 := var_aae013||rec_tmp1.AAE002||',';
--                             END LOOP;
--                             prm_AppCode  :=  gn_def_ERR;
--                             prm_ErrorMsg := num_yae097||num_aae041_year||var_aae140||'ҽ�Ʋ���У��ȫ��ʧ��!'|| var_aae013;
--                             RETURN;
--                             END IF;
--

                          --var_aae100 := xasi2_zs.pkg_comm.AAE100_YX;
                          --������ʼ��
                          num_yac400 := 0;
                          num_yac401 := 0;
                          num_yac402 := 0;
                          num_yac403 := 0;
                          num_yac404 := 0;
                          num_yac405 := 0;
                          num_yac406 := 0;
                          num_yac407 := 0;
                          num_yac408 := 0;
                          num_yac409 := 0;
                          num_yac410 := 0;
                          num_yac411 := 0;
                          num_yac412 := 0;

                          --��ȡУ��ɹ�����Ϣ�����ѯ����
                          FOR rec_tmp IN cur_tmp LOOP
                              var_aae013 := rec_tmp.aae013;
                              num_yac400 := rec_tmp.AAC040;
                               --����Ƿ�Ϊ������Ա�ɷ�
--                               SELECT SUM(aaa)
--                                 INTO num_count
--                                 FROM (
--                                        SELECT count(1) AS aaa
--                                          FROM ac08a1
--                                         WHERE aac001 = var_aac001
--                                           AND aab001 = prm_aab001
--                                           AND aae140 = var_aae140
--                                           AND aae002 = rec_tmp.aae002
--                                           AND akc021 = xasi2_zs.pkg_comm.AKC021_TX
--                                        UNION
--                                        SELECT count(1)
--                                          FROM ac08
--                                         WHERE aac001 = var_aac001
--                                           AND aab001 = prm_aab001
--                                           AND aae140 = var_aae140
--                                           AND aae002 = rec_tmp.aae002
--                                           AND akc021 = xasi2_zs.pkg_comm.AKC021_TX
--                                        );
--                                IF num_count > 0 THEN
--                                   num_yac400 := 0;
--                                END IF;
                              IF rec_tmp.aae002 = prm_aae001||'01' THEN
                                 num_yac401 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'02' THEN
                                 num_yac402 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'03' THEN
                                 num_yac403 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'04' THEN
                                 num_yac404 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'05' THEN
                                 num_yac405 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'06' THEN
                                 num_yac406 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'07' THEN
                                 num_yac407 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'08' THEN
                                 num_yac408 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'09' THEN
                                 num_yac409 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'10' THEN
                                 num_yac410 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'11' THEN
                                 num_yac411 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'12' THEN
                                 num_yac412 := num_yac400;
                              END IF;
                          END LOOP;

                        --���벹����ʱ����  ��ҪΪ��ҳ����ʾ
                        SELECT count(1)
                          INTO num_count
                          FROM wsjb.tmp_ac42
                         WHERE aac001 = var_aac001
                           AND aab001 = prm_aab001
                           AND aae001 = prm_aae001
                           AND aae140 = var_aae140;
                        IF num_count < 1 THEN
                            INSERT INTO wsjb.tmp_ac42 (AAC001,             --��Ա���,VARCHAR2
                                                 AAB001,             --��λ���,VARCHAR2
                                                 AAE140,             --����,VARCHAR2
                                                 YAC401,             --1�²�����,NUMBER
                                                 YAC402,             --2�²�����,NUMBER
                                                 YAC403,             --3�²�����,NUMBER
                                                 YAC404,             --4�²�����,NUMBER
                                                 YAC405,             --5�²�����,NUMBER
                                                 YAC406,             --6�²�����,NUMBER
                                                 YAC407,             --7�²�����,NUMBER
                                                 YAC408,             --8�²�����,NUMBER
                                                 YAC409,             --9�²�����,NUMBER
                                                 YAC410,             --10�²�����,NUMBER
                                                 YAC411,             --11�²�����,NUMBER
                                                 YAC412,             --12�²�����,NUMBER
                                                 aae013,
                                                 aae001)
                                         VALUES (var_aac001,
                                                 prm_aab001,
                                                 var_aae140,
                                                 NVL(num_yac401,0),
                                                 NVL(num_yac402,0),
                                                 NVL(num_yac403,0),
                                                 NVL(num_yac404,0),
                                                 NVL(num_yac405,0),
                                                 NVL(num_yac406,0),
                                                 NVL(num_yac407,0),
                                                 NVL(num_yac408,0),
                                                 NVL(num_yac409,0),
                                                 NVL(num_yac410,0),
                                                 NVL(num_yac411,0),
                                                 NVL(num_yac412,0),
                                                 var_aae013,
                                                 prm_aae001);
                           ELSE
                               UPDATE wsjb.tmp_ac42
                                  SET YAC401 = NVL(num_yac401,0),
                                     YAC402 = NVL(num_yac402,0),
                                     YAC403 = NVL(num_yac403,0),
                                     YAC404 = NVL(num_yac404,0),
                                     YAC405 = NVL(num_yac405,0),
                                     YAC406 = NVL(num_yac406,0),
                                     YAC407 = NVL(num_yac407,0),
                                     YAC408 = NVL(num_yac408,0),
                                     YAC409 = NVL(num_yac409,0),
                                     YAC410 = NVL(num_yac410,0),
                                     YAC411 = NVL(num_yac411,0),
                                     YAC412 = NVL(num_yac412,0),
                                     aae013 = var_aae013
                               WHERE aac001 = var_aac001
                                 AND AAB001 = prm_aab001
                                 AND aae140 = var_aae140
                                 AND aae001 = prm_aae001;
                           END IF;
                       END IF;

            END IF;
            <<leb_next>>
            NULL;
          END LOOP;
      END LOOP;


      --���ϵĲ���У��
      IF prm_yab019 <> '2' THEN
      var_aae140 := pkg_Constant.AAE140_YL;
      DELETE xasi2.tmp_grbs01;
      DELETE xasi2.tmp_grbs02;

      BEGIN
        SELECT aae041           --���ʼʱ��
          INTO num_aae041_year
          FROM xasi2.aa02a3
         WHERE aae140 = var_aae140
           AND aae001 = prm_aae001
           AND yab139 = prm_yab139;
        EXCEPTION
             WHEN OTHERS THEN
                  prm_AppCode  :=  gn_def_ERR;
                  prm_ErrorMsg := '��ȡ���󲹲�����쳣';
                  RETURN;
      END;
      --����ȡ����ʼ�ں� ��������ں�����
     SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(aae003),'yyyymm'),1),'yyyymm'))   --��ȡ�����ں�
        INTO num_aae002
        FROM wsjb.irab08
       WHERE AAB001 = prm_aab001
         AND yae517 = 'H01'
         AND aae140 = var_aae140;

      --ȡ���ϵ���������ں�
      SELECT NVL(MAX(aae003),0)
        INTO num_yae097
        FROM wsjb.irab08
       WHERE AAB001 = prm_aab001
         AND yae517 = 'H01'
         AND aae140 = var_aae140;

      --������ʼʱ����ڵ�λ��������ں��򲻽��в���
      IF num_aae041_year <= num_yae097 THEN
          IF num_yae097 > 0 THEN   --�жϵ�λ�Ƿ������ϵĽɷ���Ϣ
              FOR rec_ab05a1 IN cur_ab05a1 LOOP
                  num_yac400 := 0;
                  num_yac401 := 0;
                  num_yac402 := 0;
                  num_yac403 := 0;
                  num_yac404 := 0;
                  num_yac405 := 0;
                  num_yac406 := 0;
                  num_yac407 := 0;
                  num_yac408 := 0;
                  num_yac409 := 0;
                  num_yac410 := 0;
                  num_yac411 := 0;
                  num_yac412 := 0;
                  IF rec_ab05a1.yac507 >0 THEN --���ԭ���Ͻɷѻ�������0��˵������Ա�μ����ϱ���
                     --����Ǹ��˲鿴����Ϊ�������
                     var_aac001 := rec_ab05a1.aac001;

                     --�ж������Ƿ���ǰ������� ���������ǰ�����򲻽��в���(�����������˳���)
                      SELECT count(1)
                        INTO num_count
                        FROM wsjb.irad51a1
                       WHERE aac001 = var_aac001
                         and aab001 = prm_aab001
                         AND yae031 = '1'
                         and aae041 = prm_aae001||'01'
                         and not exists (select 1 from xasi2.ac01k8 where aac001=var_aac001 and aab001=prm_aab001 and aae001=prm_aae001 and aae013='22');
                      IF num_count > 0 THEN
                         GOTO leb_next1;
                      END IF;
                     IF prm_aac001 IS NOT NULL THEN
                        num_aac040 := round(prm_aac040);
                     ELSE
                        num_aac040 := round(rec_ab05a1.aac040);
                     END IF;


                    SELECT MAX(aae041)
                      INTO num_aae002_max
                      FROM xasi2.AA02
                     WHERE yaa001 = '16'
                       AND aae140 = var_aae140
                       AND aae001 = prm_aae001;
                       
                      /*
                     xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase(var_aac001,                --���˱���
                                                                      prm_aab001,                --��λ����
                                                                      num_aac040,                --�ɷѹ���
                                                                      xasi2.pkg_comm.YAC503_SB,--�������
                                                                      var_aae140,                --��������
                                                                      '010',                --�ɷ���Ա���
                                                                      var_yab136,                --��λ�������ͣ���������ɷ���Ա��
                                                                      num_aae002_max,                --�ѿ�������
                                                                      prm_yab139,                --�α�������
                                                                      num_yac004,                --�ɷѻ���
                                                                      prm_AppCode,              --�������
                                                                      prm_ErrorMsg);            --��������
                     
                                                                                        
                      IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                         RETURN;
                      END IF;
                      */   
               -- ʹ�ø��±��׷ⶥ (���ϸ��幤���Ѵ���)     
               SELECT pkg_common.fun_p_getcontributionbase(
                                                    null,                                        --���˱��� aac001
                                                    prm_aab001,                          --��λ���� aab001
                                                    ROUND(num_aac040),          --�ɷѹ��� aac040
                                                    '0',                                          --������� yac503
                                                    var_aae140,                            --�������� aae140
                                                    '1',                                          --�ɷ���Ա��� yac505
                                                    var_yab136,                            --��λ�������ͣ���������ɷ���Ա�� yab136
                                                    num_aae002_max,                  --�ѿ������� aae002
                                                    prm_yab139)                          --�α������� yab139
                  INTO num_yac004
               FROM dual;
                         
                      --������ƽδ����
                      SELECT count(1)
                        INTO num_count
                        FROM xasi2.AA02
                       WHERE yaa001 = '16'
                         AND aae140 = var_aae140
                         AND aae001 = prm_aae001;
                      IF num_count < 2 THEN
                         SELECT yaa006
                           INTO num_yaa006
                           FROM xasi2.aa02a2
                          WHERE aae140 = '01'
                            and aae041 = num_aae002_max
                            AND yaa025 = '1';

                         IF num_aac040 = num_yaa006 THEN
                            num_aac040 := TRUNC(num_aac040*1.1);
                         END IF;
                      END IF;
                      
                      --�жϸ��幤�̻�(2019����ǰ����������ƽ��40%)
                      IF var_aab019 = '60' and  prm_aae001<2019 THEN
                         --��ȡ��ƽ����
                         num_spgz := xasi2.pkg_comm.fun_GetAvgSalary(var_aae140,'16',num_aae002_max,PKG_Constant.YAB003_JBFZX);
                         num_yac004 := num_aac040;
                            IF num_aac040 < TRUNC(num_spgz/12*0.4)+1 THEN
                               num_yac004 := TRUNC(num_spgz/12*0.4)+1;
                            END IF;
                            IF num_aac040 > ROUND(num_spgz/12) THEN
                               num_yac004 := ROUND(num_spgz/12);
                            END  IF;
                       END IF;
                       
                     DELETE xasi2.tmp_grbs01;


                          --���벹����ʱ����
                     INSERT INTO xasi2.tmp_grbs01(aac001,          --���˱���
                                                     aae041,          --��ʼ�ں�
                                                     aae042,          --��ֹ�ں�
                                                     aae140,          --����
                                                     yac503,          --�������
                                                     aac040,          --�ɷѹ���
                                                     yaa333,          --�ʻ�����
                                                     aae100,          --��Ч��־
                                                     aae013)
                                             VALUES (var_aac001,
                                                     num_aae041_year,
                                                     num_yae097,
                                                     var_aae140,
                                                     xasi2.pkg_comm.YAC503_SB,--�������
                                                     num_yac004,--�����ɷѹ���  ����ǹ���������ȡ���˵Ľɷѹ��� ��ҪΪ�����ָ��嵥λ
                                                     rec_ab05a1.yac004,
                                                     NULL,
                                                     NULL);
                          --�������ϲ�����Ĺ���
                        prc_p_checkData(prm_aab001 ,   --��λ���
                                        prm_yab139 ,   --�α�����������
                                        prm_yab139 ,   --�籣�������
                                        prm_AppCode,   --ִ�д���
                                        prm_ErrorMsg); --ִ�н��
                        IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                           RETURN;
                        END IF;

                        --��ȡУ��ɹ�����Ϣ�����ѯ����
                        FOR rec_tmp IN cur_tmp LOOP
                            var_aae013 := rec_tmp.aae013;

                            IF rec_tmp.aae002 = prm_aae001||'01' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '01';
                               if num_count = 0 then
                                  num_yac401 := rec_tmp.AAC040;
                               else
                                  num_yac401 := 0;
                               end if;                     
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'02' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '02';
                               if num_count = 0 then
                                  num_yac402 := rec_tmp.AAC040;
                               else
                                  num_yac402 := 0;
                               end if;  
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'03' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '03';
                               if num_count = 0 then
                                  num_yac403 := rec_tmp.AAC040;
                               else
                                  num_yac403 := 0;
                               end if;  
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'04' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '04';
                               if num_count = 0 then
                                  num_yac404 := rec_tmp.AAC040;
                               else
                                  num_yac404 := 0;
                               end if;
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'05' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '05';
                               if num_count = 0 then
                                  num_yac405 := rec_tmp.AAC040;
                               else
                                  num_yac405 := 0;
                               end if;
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'06' THEN
                               select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '06';
                               if num_count = 0 then
                                  num_yac406 := rec_tmp.AAC040;
                               else
                                  num_yac406 := 0;
                               end if;
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'07' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '07';
                               if num_count = 0 then
                                  num_yac407 := rec_tmp.AAC040;
                               else
                                  num_yac407 := 0;
                               end if;
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'08' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '08';
                               if num_count = 0 then
                                  num_yac408 := rec_tmp.AAC040;
                               else
                                  num_yac408 := 0;
                               end if;
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'09' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '09';
                               if num_count = 0 then
                                  num_yac409 := rec_tmp.AAC040;
                               else
                                  num_yac409 := 0;
                               end if;
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'10' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '10';
                               if num_count = 0 then
                                  num_yac410 := rec_tmp.AAC040;
                               else
                                  num_yac410 := 0;
                               end if;
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'11' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '11';
                               if num_count = 0 then
                                  num_yac411 := rec_tmp.AAC040;
                               else
                                  num_yac411 := 0;
                               end if;
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'12' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '12';
                               if num_count = 0 then
                                  num_yac412 := rec_tmp.AAC040;
                               else
                                  num_yac412 := 0;
                               end if;
                            END IF;
                        END LOOP;
                        <<leb_next1>>
                        --���벹����ʱ����  ��ҪΪ��ҳ����ʾ
                        SELECT count(1)
                          INTO num_count
                          FROM wsjb.tmp_ac42
                         WHERE aac001 = var_aac001
                           AND aab001 = prm_aab001
                           AND aae001 = prm_aae001
                           AND aae140 = var_aae140;
                        IF num_count < 1 THEN
                            INSERT INTO wsjb.tmp_ac42 (AAC001,             --��Ա���,VARCHAR2
                                                 AAB001,             --��λ���,VARCHAR2
                                                 AAE140,             --����,VARCHAR2
                                                 YAC401,             --1�²�����,NUMBER
                                                 YAC402,             --2�²�����,NUMBER
                                                 YAC403,             --3�²�����,NUMBER
                                                 YAC404,             --4�²�����,NUMBER
                                                 YAC405,             --5�²�����,NUMBER
                                                 YAC406,             --6�²�����,NUMBER
                                                 YAC407,             --7�²�����,NUMBER
                                                 YAC408,             --8�²�����,NUMBER
                                                 YAC409,             --9�²�����,NUMBER
                                                 YAC410,             --10�²�����,NUMBER
                                                 YAC411,             --11�²�����,NUMBER
                                                 YAC412,             --12�²�����,NUMBER
                                                 aae013,
                                                 aae001)
                                         VALUES (var_aac001,
                                                 prm_aab001,
                                                 var_aae140,
                                                 NVL(num_yac401,0),
                                                 NVL(num_yac402,0),
                                                 NVL(num_yac403,0),
                                                 NVL(num_yac404,0),
                                                 NVL(num_yac405,0),
                                                 NVL(num_yac406,0),
                                                 NVL(num_yac407,0),
                                                 NVL(num_yac408,0),
                                                 NVL(num_yac409,0),
                                                 NVL(num_yac410,0),
                                                 NVL(num_yac411,0),
                                                 NVL(num_yac412,0),
                                                 var_aae013,
                                                 prm_aae001);
                           ELSE
                               UPDATE wsjb.tmp_ac42
                                  SET YAC401 = NVL(num_yac401,0),
                                     YAC402 = NVL(num_yac402,0),
                                     YAC403 = NVL(num_yac403,0),
                                     YAC404 = NVL(num_yac404,0),
                                     YAC405 = NVL(num_yac405,0),
                                     YAC406 = NVL(num_yac406,0),
                                     YAC407 = NVL(num_yac407,0),
                                     YAC408 = NVL(num_yac408,0),
                                     YAC409 = NVL(num_yac409,0),
                                     YAC410 = NVL(num_yac410,0),
                                     YAC411 = NVL(num_yac411,0),
                                     YAC412 = NVL(num_yac412,0),
                                     aae013 = var_aae013
                               WHERE aac001 = var_aac001
                                 AND AAB001 = prm_aab001
                                 AND aae140 = var_aae140
                                 AND aae001 = prm_aae001;
                           END IF;
                  END IF;
                    NULL;
              END LOOP;
          END IF;
       END IF;
       END IF;
   EXCEPTION
        WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '���ݿ����:'||PRE_ERRCODE || SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() ;
             RETURN;
END prc_YearSalaryAdjustPaded;
/*****************************************************************************
** �������� : prc_p_checkYSJ
** ���̱�� : A02
** ҵ�񻷽� ����λ�ɷѲ���
** �������� ��У���Ӧ�ںŶ�Ӧ���ֵ�Ӧʵ����Ϣ
******************************************************************************
** ��    �ߣ�              �������� ��2009-12-29   �汾��� ��Ver 1.0.0
** ��    ��: Courier New  ��    �� ��10
** ��    �ģ�
******************************************************************************
** ��    ע��
**
*****************************************************************************/
PROCEDURE prc_p_checkYSJ(prm_aac001     IN     xasi2.ac02.aac001%TYPE,      --���˱��
                         prm_aab001     IN     xasi2.ac02.aab001%TYPE,      --��λ���
                         prm_aae002     IN     xasi2.ac08.aae002%TYPE,      --�ѿ�������
                         prm_aae140     IN     xasi2.ac02.aae140%TYPE,      --����
                         prm_yab139     IN     xasi2.ac02.yab139%TYPE,      --�α�����������
                         prm_yab136     IN     xasi2.ab01.yab136%TYPE,      --��λ��������
                         prm_aac040     IN OUT xasi2.ac02.aac040%TYPE,      --�µĽɷѹ���
                         prm_yac503     IN OUT xasi2.ac02.yac503%TYPE,      --�������
                         prm_YAA333     IN OUT xasi2.ac02.YAA333%TYPE,      --�˻�����
                         prm_yac004     OUT    xasi2.ac02.yac004%TYPE,      --�ɷѻ���
                         prm_yac505_old OUT    xasi2.ac02.yac505%TYPE,      --
                         prm_aae114_old OUT    xasi2.ac08.aae114%TYPE,      --�ɷѱ�־
                         prm_AppCode    OUT    VARCHAR2,              --ִ�д���
                         prm_ErrMsg     OUT    VARCHAR2)              --������Ϣ
   IS
      var_procNo            VARCHAR2(5);             --���̺�
      num_yac004_old        NUMBER;
      num_YAA333_old        NUMBER;
      num_aaa041_old        NUMBER;                  --���˽ɷѱ���
      num_aaa042_old        NUMBER;                  --��λ�ɷѱ���
      num_yaa017_old        NUMBER;                  --���˽ɷѻ�ͳ�����
      num_aaa043_old        NUMBER;                  --��λ�ɷѻ��˻�����
      var_yac503            xasi2.ac02.yac503%TYPE;
      num_aac040            NUMBER;
      num_yaa028            NUMBER;
      num_count             NUMBER;
      var_yac168            xasi2.ac01.yac168%TYPE;
      num_aae003            NUMBER;
      var_yac505            xasi2.ac02.yac505%TYPE;
      var_aae119            xasi2.ab01.aae119%TYPE;
      var_akc021            xasi2.kc01.akc021%TYPE;
      prm_aac040_new        NUMBER;
      num_i                 NUMBER;
      var_flag              NUMBER;
      num_aae180            NUMBER;
      var_yae010            xasi2.ab08.yae010%TYPE;
      var_aac001             xasi2.ac01.aac001%TYPE;
   BEGIN
      /*��������*/
      prm_AppCode    := gn_def_OK ;
      prm_ErrMsg     := ''                  ;
      var_procNo     := 'A02';
      prm_aac040_new := prm_aac040;
      num_aae003  := TO_NUMBER(TO_CHAR(SYSDATE,'yyyymm'));

      --����Ƿ����Ӧ�ɵĲ�������
      SELECT COUNT(yae202)
        INTO num_count
        FROM wsjb.irac08a1
       WHERE aab001 = prm_aab001
         AND aac001 = prm_aac001
         AND aae140 = prm_aae140
         AND aae002 = prm_aae002
         AND aae143 IN (xasi2.pkg_comm.AAE143_JSBC,        -- ��������
                        xasi2.pkg_comm.AAE143_BLBC);       -- ��������

      IF num_count > 0 THEN
         prm_AppCode := ''||var_procNo||'01';
         prm_ErrMsg  := '��λ:'||prm_aab001||
                        ';��Ա:'||prm_aac001||
                        ';����:'||xasi2.pkg_COMM.fun_getAaa103('aae140',prm_aae140)||
                        ';�ں�:'||prm_aae002||
                        '����δ�ɷѵĲ�����Ϣ�����ȳ���֮ǰ������Ϣ���ٽ��б��β��������';
         RETURN;
      END IF ;

      --��ȡӦ��ʵ����Ϣ

         --��ȡ���Ӧ��Ӧʵ����Ϣ
         BEGIN
            SELECT NVL(SUM(CASE WHEN aae143 IN(xasi2.pkg_comm.AAE143_ZCJF,  --�����ɷ�
                                               xasi2.pkg_comm.AAE143_BJ  ,  --����
                                               xasi2.pkg_comm.AAE143_BS  ,  --����
                                               xasi2.pkg_comm.AAE143_JSBC,  --��������
                                               xasi2.pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                               xasi2.pkg_comm.AAE143_DLJF)  --������Ա�ɷ�
                                THEN aae180
                                ELSE 0
                                END),0),  --�ɷѻ���
                   NVL(SUM(CASE WHEN aae143 IN(xasi2.pkg_comm.AAE143_ZCJF, --�����ɷ�
                                               xasi2.pkg_comm.AAE143_BJ  , --����
                                               xasi2.pkg_comm.AAE143_BS  , --����
                                               xasi2.pkg_comm.AAE143_JSBC, --��������
                                               xasi2.pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                               xasi2.pkg_comm.AAE143_DLJF) --������Ա�ɷ�
                                THEN YAA333
                                ELSE 0
                                END),0)  --���ʻ�����

              INTO num_yac004_old,                  --�ɷѻ���
                   num_YAA333_old                  --���˻�����

              FROM
                   (SELECT aae143,
                           aae180,
                           YAA333
                      FROM wsjb.irac08a1  a
                     WHERE aac001 = prm_aac001
                       AND aab001 = prm_aab001
                       AND aae002 = prm_aae002
                       AND yab139 = prm_yab139
                       AND aae140 = prm_aae140
                       AND aae143 IN(xasi2.pkg_comm.AAE143_ZCJF, --�����ɷ�
                                     xasi2.pkg_comm.AAE143_JSBC, --��������
                                     xasi2.pkg_comm.AAE143_BJ  , --����
                                     xasi2.pkg_comm.AAE143_BS  , --����
                                     xasi2.pkg_comm.AAE143_DLJF, --������Ա�ɷ�
                                     xasi2.pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                     xasi2.pkg_comm.AAE143_BLBC) --��������
                      AND NOT EXISTS(SELECT 1
                                       FROM wsjb.irac01c1  b
                                      WHERE yae031='1'
                                        AND b.aac001 = a.aac001
                                        AND b.iaa100 = a.aae002
                                        AND b.aab001 = a.aab001)

                     )
                     ;

        IF num_yac004_old = 0 AND num_YAA333_old=0 THEN
        BEGIN

          SELECT aac001
            INTO var_aac001
            FROM wsjb.irac01c1
           WHERE yab029 = prm_aac001
             AND yae031='1'
             AND iaa100 = prm_aae002
             AND aab001 = prm_aab001;

          SELECT NVL(SUM(CASE WHEN aae143 IN(xasi2.pkg_comm.AAE143_ZCJF,  --�����ɷ�
                                               xasi2.pkg_comm.AAE143_BJ  ,  --����
                                               xasi2.pkg_comm.AAE143_BS  ,  --����
                                               xasi2.pkg_comm.AAE143_JSBC,  --��������
                                               xasi2.pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                               xasi2.pkg_comm.AAE143_DLJF)  --������Ա�ɷ�
                                THEN aae180
                                ELSE 0
                                END),0),  --�ɷѻ���
                   NVL(SUM(CASE WHEN aae143 IN(xasi2.pkg_comm.AAE143_ZCJF, --�����ɷ�
                                               xasi2.pkg_comm.AAE143_BJ  , --����
                                               xasi2.pkg_comm.AAE143_BS  , --����
                                               xasi2.pkg_comm.AAE143_JSBC, --��������
                                               xasi2.pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                               xasi2.pkg_comm.AAE143_DLJF) --������Ա�ɷ�
                                THEN YAA333
                                ELSE 0
                                END),0)  --���ʻ�����

              INTO num_yac004_old,                  --�ɷѻ���
                   num_YAA333_old                  --���˻�����

              FROM
                   (SELECT aae143,
                           aae180,
                           YAA333
                      FROM wsjb.irac08a1  a
                     WHERE aac001 = var_aac001
                       AND aab001 = prm_aab001
                       AND aae002 = prm_aae002
                       AND yab139 = prm_yab139
                       AND aae140 = prm_aae140
                       AND aae143 IN(xasi2.pkg_comm.AAE143_ZCJF, --�����ɷ�
                                     xasi2.pkg_comm.AAE143_JSBC, --��������
                                     xasi2.pkg_comm.AAE143_BJ  , --����
                                     xasi2.pkg_comm.AAE143_BS  , --����
                                     xasi2.pkg_comm.AAE143_DLJF, --������Ա�ɷ�
                                     xasi2.pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                     xasi2.pkg_comm.AAE143_BLBC) --��������

                      AND  EXISTS(SELECT 1
                                       FROM wsjb.irac01c1  b
                                      WHERE yae031='1'
                                        AND b.aac001 = a.aac001
                                        AND b.iaa100 = a.aae002
                                        AND b.aab001 = a.aab001)
                     )
                     ;
               EXCEPTION
                WHEN OTHERS THEN
                   prm_AppCode := ''||var_procNo||'01';
                   prm_ErrMsg  := 'û�л�ȡ��������Ϊ'||xasi2.pkg_COMM.fun_getAaa103('aae140',prm_aae140)||prm_aae002||'�Ľɷ���Ϣ';
                   RETURN;
                   END;
          END IF;
                EXCEPTION
                WHEN OTHERS THEN
                   prm_AppCode := ''||var_procNo||'01';
                   prm_ErrMsg  := 'û�л�ȡ��������Ϊ'||xasi2.pkg_COMM.fun_getAaa103('aae140',prm_aae140)||prm_aae002||'�Ľɷ���Ϣ';
                   RETURN;
         END;



         BEGIN
            --��ȡirac08a1�ǲ���ɷѵĽɷѹ������ͷ�����Դ��
          SELECT yac503,
                 aae180,
                 yae010,
                 yac505,
                 xasi2.pkg_comm.AAE114_QJ AS aae114
            INTO var_yac503,
                 num_aac040,
                 var_yae010,
                 prm_yac505_old,                  --�α��ɷ���Ա���
                 prm_aae114_old
            FROM wsjb.irac08a1  a
           WHERE aac001 = prm_aac001
             AND aab001 = prm_aab001
             AND aae002 = prm_aae002
             AND yab139 = prm_yab139
             AND aae140 = prm_aae140
             AND aae143 IN(xasi2.pkg_comm.AAE143_ZCJF,
                           xasi2.pkg_comm.AAE143_BJ,
                           xasi2.pkg_comm.AAE143_BS,
                           xasi2.pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                           xasi2.pkg_comm.AAE143_DLJF)
             AND NOT  EXISTS(SELECT 1
                                       FROM wsjb.irac01c1  b
                                      WHERE yae031='1'
                                        AND b.aac001 = a.aac001
                                        AND b.iaa100 = a.aae002
                                        AND b.aab001 = a.aab001);



             EXCEPTION
              WHEN OTHERS THEN
              BEGIN
             IF   var_yac503 IS NULL AND
              num_aac040 IS NULL AND
              var_yae010 IS NULL AND
              prm_yac505_old IS NULL AND
              prm_aae114_old IS NULL THEN
         SELECT aac001
            INTO var_aac001
            FROM wsjb.irac01c1
           WHERE yab029 = prm_aac001
             AND yae031='1'
             AND iaa100 = prm_aae002
             AND aab001 = prm_aab001;
          SELECT yac503,
                 aae180,
                 yae010,
                 yac505,
                 xasi2.pkg_comm.AAE114_QJ AS aae114
            INTO var_yac503,
                 num_aac040,
                 var_yae010,
                 prm_yac505_old,                  --�α��ɷ���Ա���
                 prm_aae114_old
            FROM wsjb.irac08a1  a
           WHERE aac001 = var_aac001
             AND aab001 = prm_aab001
             AND aae002 = prm_aae002
             AND yab139 = prm_yab139
             AND aae140 = prm_aae140
             AND aae143 IN(xasi2.pkg_comm.AAE143_ZCJF,
                           xasi2.pkg_comm.AAE143_BJ,
                           xasi2.pkg_comm.AAE143_BS,
                           xasi2.pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                           xasi2.pkg_comm.AAE143_DLJF)
             AND  EXISTS(SELECT 1
                                       FROM wsjb.irac01c1  b
                                      WHERE yae031='1'
                                        AND b.aac001 = a.aac001
                                        AND b.iaa100 = a.aae002
                                        AND b.aab001 = a.aab001);
         END IF;
             EXCEPTION
              WHEN OTHERS THEN
                   prm_AppCode := ''||var_procNo||'02';
                   prm_ErrMsg  := var_yac503||'var_yac503'||'û�л�ȡ��������Ϊ'||xasi2.pkg_COMM.fun_getAaa103('aae140',prm_aae140)||'�Ľɷ���Ϣ'||prm_aae002;
                   RETURN;
         END;
         END;

         --�����޸� WL 2013-02-01
         --�Խɷѹ��ʽ��б��׷ⶥ
         xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase(
                                                prm_aac001,             --���˱��
                                                prm_aab001,
                                                prm_aac040,             --�ɷѹ���
                                                prm_yac503,             --�������
                                                prm_aae140,             --��������
                                                prm_yac505_old,         --�ɷ���Ա���
                                                prm_yab136,             --��λ��������
                                                num_aae003,             --�ѿ�������/*����ϵͳ�ں�*//*20100928 �α������ ����¼�빤�ʵĲ��ն�����ǰ��ƽ���ʲ���*/
                                                prm_yab139,             --�α�����������
                                                prm_yac004,             --�ɷѻ���
                                                prm_AppCode,            --ִ�д���
                                                prm_ErrMsg);            --ִ�н��

         IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
            RETURN;
         END IF;

         --�����������
         prm_yac004 := prm_aac040 - num_yac004_old;
         prm_aac040 := prm_yac004;

         IF prm_aae140 IN (xasi2.pkg_comm.aae140_JBYL,     --����ҽ��
                           xasi2.pkg_comm.AAE140_GWYBZ)    --����Ա����
         THEN
            IF prm_yaa333 IS NULL OR prm_yaa333 = 0 THEN
               prm_yaa333 := prm_yac004;
            ELSE
               prm_yaa333 := prm_yaa333 - num_yaa333_old;
            END IF;
         ELSE
            prm_yaa333 := 0;
         END IF;
         --����û�仯��

         IF prm_yac004 = 0 THEN
            prm_AppCode := ''||var_procNo||'02';
            prm_ErrMsg  := '����û�з����仯�����ò���';
            RETURN;
         END IF;
   EXCEPTION
      WHEN OTHERS THEN
           prm_AppCode := ''||var_procNo||'16';
           prm_ErrMsg  := '��ȡӦʵ����Ϣ����:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
           RETURN;
   END prc_p_checkYSJ;
   /*****************************************************************************
   ** �������� : prc_p_checkTmp
   ** ���̱�� : A01
   ** ҵ�񻷽� ����λ�ɷѲ���
   ** �������� ��У����ʱ������
   ******************************************************************************
   ** ��    �ߣ�              �������� ��2009-12-29   �汾��� ��Ver 1.0.0
   ** ��    ��: Courier New  ��    �� ��10
   ** ��    �ģ�
   ******************************************************************************
   ** ��    ע��
   **
   *****************************************************************************/
   PROCEDURE prc_p_checkTmp(prm_aac001      IN       xasi2.ab08.aac001%TYPE,      --���˱��
                            prm_aab001      IN       xasi2.ab08.aab001%TYPE,      --��λ���
                            prm_aae140      IN       xasi2.ab08.aae140%TYPE,      --����
                            prm_aae041      IN       xasi2.ab08.aae041%TYPE,      --��ʼ�ں�
                            prm_aae042      IN       xasi2.ab08.aae042%TYPE,      --��ֹ�ں�
                            prm_yac503      IN       xasi2.ac08.yac503%TYPE,      --�������
                            prm_aac040      IN       xasi2.ac08.aac040%TYPE,      --�ɷѹ���
                            prm_yaa333      IN       xasi2.ac08.yaa333%TYPE,      --�ʻ�����
                            prm_yab003      IN       xasi2.ab08.yab003%TYPE,      --�籣�������
                            prm_yab139      IN       xasi2.ab08.yab139%TYPE,      --�α�����������
                            prm_AppCode     OUT      VARCHAR2        ,      --ִ�д���
                            prm_ErrMsg      OUT      VARCHAR2 )
   IS
      var_procNo            VARCHAR2(5);      --���̺�
      var_yaa310            xasi2.aa05.yaa310%TYPE;      --��������
      var_yaa330            xasi2.aa05.yaa330%TYPE;      --�ɷѱ���ģʽ
      var_yab136            xasi2.ab01.yab136%TYPE;      --��λ��������
      num_count             NUMBER := 0;      --��¼��
      num_aae041            NUMBER;           --��ʼ�ں�
      num_aae042            NUMBER;           --��ֹ�ں�
      num_yac004            NUMBER := 0;      --�ɷѻ���
      num_yac004_new        NUMBER := 0;        --�ɷѻ������£�
      num_aaa041            NUMBER := 0;      --���˽ɷѱ���
      num_yaa017            NUMBER := 0;      --���˻�ͳ�����
      num_aaa042            NUMBER := 0;      --��λ�ɷѱ���
      num_aaa043            NUMBER := 0;      --��λ�ɷѻ���
      num_ala080            NUMBER;           --���˸�������
      num_age               NUMBER;           --����
      num_yac176            NUMBER;           --����
      num_aac040_bd         NUMBER := 0;
      var_yac168            irac01.yac168%TYPE;             --ũ�񹤱�־
      var_yac503            irac01.yac503%TYPE;             --�������
      var_yac505            irac01.yac505%TYPE;             --
      var_aac008            irac01.aac008%TYPE;
      var_aaa040            irab02.aaa040%TYPE;
      var_ykc120            irac08.ykc120%TYPE;             --ҽ���չ���Ա���
      var_akc021            irac01.akc021%TYPE;             --ҽ����Ա���
      num_yaa333            NUMBER;
      var_yae010            xasi2.aa05.yae010%TYPE;
      var_aae143            xasi2.ac08.aae143%TYPE;
      var_aae114            xasi2.ac08.aae114%TYPE;        --�ɷѱ�־

   BEGIN
      --��ʼ������
      prm_AppCode    := xasi2.pkg_COMM.gn_def_OK ;
      prm_ErrMsg     := '' ;
      var_procNo     := 'A01';

      num_aae041 := prm_aae041;
      num_aae042 := prm_aae042;
      num_count  := 0;


      --��ȡ��λ������Ϣ
      SELECT yab136
        INTO var_yab136
        FROM xasi2.ab01
       WHERE aab001 = prm_aab001;


         var_aae143 := xasi2.pkg_comm.aae143_JSBC;


      WHILE num_aae041 <= num_aae042
      LOOP
         num_aac040_bd := prm_aac040;
         var_yac503 := prm_yac503;
         num_yaa333 := prm_yaa333;

         prc_p_checkYSJ(prm_aac001     ,      --���˱��
                        prm_aab001     ,      --��λ���
                        num_aae041     ,      --�ѿ�������
                        prm_aae140     ,      --����
                        prm_yab139     ,      --�α�����������
                        var_yab136     ,      --��λ��������
                        num_aac040_bd     ,      --�µĽɷѹ���
                        var_yac503     ,      --�������
                        num_yaa333     ,      --�˻�����
                        num_yac004     ,      --�ɷѻ���
                        var_yac505 ,      --
                        var_aae114 ,      --�ɷѱ�־
                        prm_AppCode    ,      --ִ�д���
                        prm_ErrMsg    );      --������Ϣ

         IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
            --���쳣�׳�������Ч��־��Ϊ��Ч
            INSERT INTO xasi2.tmp_grbs02(
                                    aac001,  --���˱���
                                    aae002,  --�ѿ������ں�
                                    yac505,  --���˽ɷ����
                                    aaa040,  --�ɷѱ������
                                    aae140,  --����
                                    aae143,  --�ɷ����
                                    yac503,  --��������
                                    aac040,  --�ɷѹ���
                                    yac004,  --���˽ɷѻ���
                                    yaa333,  --���ʻ�����
                                    yae010,  --������Դ
                                    yaa330,  --�ɷѱ���ģʽ
                                    aaa041,  --���˽ɷѱ���
                                    yaa017,  --���˽ɷѻ���ͳ�����
                                    aaa042,  --��λ�ɷѱ���
                                    aaa043,  --��λ�ɷѻ����ʻ�����
                                    ala080,  --���˸�������
                                    akc023,  --ʵ������
                                    yac176,  --����
                                    akc021,  --ҽ����Ա���
                                    ykc120,  --ҽ���չ���Ա���
                                    aac008,  --��Ա״̬
                                    yac168,  --ũ�񹤱�־
                                    yaa310,  --�������
                                    aae114,  --�ɷѱ�־
                                    aae100,  --��Ч��־
                                    aae013)  --��ע
                               VALUES
                               ( prm_aac001,           --���˱��
                                 num_aae041,           --�ѿ������ں�
                                 var_yac505,           --�α��ɷ���Ա���
                                 NULL,           --�ɷѱ������
                                 prm_aae140,           --��������
                                 var_aae143,           --�ɷ����
                                 var_yac503,           --��������
                                 num_aac040_bd,        --�ɷѹ���
                                 num_yac004,           --�ɷѻ���
                                 num_yaa333,           --���ʻ�����
                                 '1'     ,      --������Դ
                                 NULL     ,      --�ɷѱ���ģʽ
                                 0,           --���˽ɷѱ���
                                 0,           --���˻�ͳ�����
                                 0,           --��λ�ɷѱ���
                                 0,           --��λ���ʻ�����
                                 0,           --���˸�������
                                 0,              --����
                                 0,           --����
                                 NULL,           --ҽ�Ʊ�����Ա״̬
                                 NULL,           --ҽ���չ���Ա���
                                 NULL,           --��Ա״̬
                                 NULL,           --ũ�񹤱�־
                                 NULL,           --��������
                                 var_aae114,           --�ɷѱ�־
                                 xasi2.pkg_comm.AAE100_WX,  --��Ч��־ ����Ч
                                 prm_ErrMsg );
            --��������Ϣ�ÿ�
            prm_AppCode    := xasi2.pkg_COMM.gn_def_OK ;
            prm_ErrMsg     := '' ;
         ELSE
            --���쳣�׳�������Ч��־��Ϊ��Ч
          INSERT INTO xasi2.tmp_grbs02(
                                    aac001,  --���˱���
                                    aae002,  --�ѿ������ں�
                                    yac505,  --���˽ɷ����
                                    aaa040,  --�ɷѱ������
                                    aae140,  --����
                                    aae143,  --�ɷ����
                                    yac503,  --��������
                                    aac040,  --�ɷѹ���
                                    yac004,  --���˽ɷѻ���
                                    yaa333,  --���ʻ�����
                                    yae010,  --������Դ
                                    yaa330,  --�ɷѱ���ģʽ
                                    aaa041,  --���˽ɷѱ���
                                    yaa017,  --���˽ɷѻ���ͳ�����
                                    aaa042,  --��λ�ɷѱ���
                                    aaa043,  --��λ�ɷѻ����ʻ�����
                                    ala080,  --���˸�������
                                    akc023,  --ʵ������
                                    yac176,  --����
                                    akc021,  --ҽ����Ա���
                                    ykc120,  --ҽ���չ���Ա���
                                    aac008,  --��Ա״̬
                                    yac168,  --ũ�񹤱�־
                                    yaa310,  --�������
                                    aae114,  --�ɷѱ�־
                                    aae100,  --��Ч��־
                                    aae013)  --��ע
                               VALUES
                               ( prm_aac001,           --���˱��
                                 num_aae041,           --�ѿ������ں�
                                 var_yac505,           --�α��ɷ���Ա���
                                 NULL,           --�ɷѱ������
                                 prm_aae140,           --��������
                                 var_aae143,           --�ɷ����
                                 var_yac503,           --��������
                                 num_aac040_bd,        --�ɷѹ���
                                 num_yac004,           --�ɷѻ���
                                 num_yaa333,           --���ʻ�����
                                 '1'     ,      --������Դ
                                 NULL     ,      --�ɷѱ���ģʽ
                                 0,           --���˽ɷѱ���
                                 0,           --���˻�ͳ�����
                                 0,           --��λ�ɷѱ���
                                 0,           --��λ���ʻ�����
                                 0,           --���˸�������
                                 0,              --����
                                 0,           --����
                                 NULL,           --ҽ�Ʊ�����Ա״̬
                                 NULL,           --ҽ���չ���Ա���
                                 NULL,           --��Ա״̬
                                 NULL,           --ũ�񹤱�־
                                 NULL,           --��������
                                 var_aae114,           --�ɷѱ�־
                                 xasi2.pkg_comm.AAE100_YX,  --��Ч��־ ����Ч
                                 prm_ErrMsg );
         END IF;
         --��ʼ�ںż�1����ѭ��
         num_aae041 := to_number(to_char(ADD_MONTHS(TO_DATE(num_aae041,'yyyymm'),1),'yyyymm')) ;
      END LOOP;
   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := ''||var_procNo||'01';
         prm_ErrMsg  := '����Ч��,����ԭ��:'||num_yac004_new||',,'||num_yac004||'..'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
      RETURN;
   END prc_p_checkTmp;
   /*****************************************************************************
   ** �������� ��prc_p_checkData
   ** ���̱�� : 02
   ** ҵ�񻷽� ����λ�ɷѲ���
   ** �������� ������У��
   ******************************************************************************
   ******************************************************************************
   ** ��    �ߣ�              �������� ��2009-12-29   �汾��� ��Ver 1.0.0
   ** ��    ��: Courier New  ��    �� ��10
   ** ��    �ģ�
   ******************************************************************************
   ** ��    ע��
   **
   *****************************************************************************/
   PROCEDURE  prc_p_checkData(prm_aab001   IN   xasi2.ab02.aab001%TYPE,   --��λ���
                              prm_yab139   IN   xasi2.ac02.yab139%TYPE,   --�α�����������
                              prm_yab003   IN   xasi2.ac02.yab003%TYPE,   --�籣�������
                              prm_AppCode  OUT  VARCHAR2,           --ִ�д���
                              prm_ErrMsg   OUT  VARCHAR2            --ִ�н��
                             )
   IS
     var_procNo             VARCHAR2(5);                --���̺�
      num_count              NUMBER := 0;                --��¼��

      --�����α꣬��ȡ��ʱ������
      CURSOR cur_tmp IS
      SELECT  aac001,   --���˱���
              aae041,   --��ʼ�ں�
              aae042,   --��ֹ�ں�
              aae140,   --����
              yac503,   --�������
              aac040,   --�ɷѹ���
              yaa333,   --�ʻ�����
              aae100,   --��Ч��־
              aae013    --��ע
        FROM xasi2.tmp_grbs01;

   BEGIN
      --��ʼ������
      prm_AppCode    := xasi2.pkg_COMM.gn_def_OK ;
      prm_ErrMsg     := '' ;
      var_procNo     := '02';

      --У�鵥λ����Ƿ�Ϊ��
      IF prm_aab001 IS NULL OR NVL(prm_aab001, '') = '' THEN
         prm_AppCode := ''||var_procNo||'02';
         prm_ErrMsg  := '��λ��Ų���Ϊ�գ�';
         RETURN;
      END IF;

      --�����ʱ������
      DELETE FROM xasi2.tmp_grbs02;

      --���α�
      FOR rec_tmp IN cur_tmp LOOP
          num_count := num_count + 1;
          prc_p_checkTmp(rec_tmp.aac001,      --���˱��
                         prm_aab001,          --��λ���
                         rec_tmp.aae140,      --����
                         rec_tmp.aae041,      --��ʼ�ں�
                         rec_tmp.aae042,      --��ֹ�ں�
                         rec_tmp.yac503,      --�������
                         rec_tmp.aac040,      --�ɷѹ���
                         rec_tmp.yaa333,      --�ʻ�����
                         prm_yab139,          --�α�����������
                         prm_yab003,          --�籣�������
                         prm_AppCode,         --ִ�д���
                         prm_ErrMsg );        --ִ�н��
      END LOOP;

      IF num_count < 1 THEN
         prm_AppCode := ''||var_procNo||'04';
         prm_ErrMsg  := '��λ�ɷѲ�����ʱ��������Ч���ݣ����ʵ��';
         RETURN;
      END IF;

      --�ر��α�
      IF cur_tmp%ISOPEN THEN
         CLOSE cur_tmp;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := ''||var_procNo||'01';
         prm_ErrMsg  := '����Ч��,����ԭ��:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
      RETURN;
   END prc_p_checkData;

    /*****************************************************************************
   ** �������� : prc_queryjishu
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����ѯ��λ�ɷ���Ա������
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--������
                 prm_aae001       IN     VARCHAR2(4),--�걨���
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2013-05-25   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_queryjishu(
        prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
        prm_yae092       IN     iraa01a1.aae011%TYPE,--������
        prm_aae001       IN     VARCHAR2,--�걨���
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             )
    IS
        n_count  number(6);
       n_count1 number(6);
       n_count2 number(6);
       v_aac001 irac01.aac001%TYPE;
       v_aac002 irac01.aac002%TYPE;
       v_aac003 irac01.aac003%TYPE;
       v_aac009 irac01.aac009%TYPE;
       v_yac503 irac01.yac503%TYPE;--�������
       n_yac506 NUMBER(14,2);--ԭ�ɷѹ���
       n_yac507 NUMBER(14,2);--ԭ���ϻ���
       n_yac508 NUMBER(14,2);--ԭ�ɷѻ���
       n_yac005 NUMBER(14,2);--ԭ���˽ɷѻ���
       v_aae110 irac01.aae110%TYPE;
       v_aae210 irac01.aae210%TYPE;
       v_aae310 irac01.aae310%TYPE;
       v_aae410 irac01.aae410%TYPE;
       v_aae510 irac01.aae510%TYPE;
       v_aae311 irac01.aae311%TYPE;
       v_yae310 VARCHAR2(3000);--ҽ�Ʊ�ע
       v_yae110 VARCHAR2(3000);--���ϱ�ע
       v_yae210 VARCHAR2(3000);--ʧҵ��ע
       v_yae410 VARCHAR2(3000);--���˱�ע
       v_yae510 VARCHAR2(3000);--������ע
       num_yae097 NUMBER(6);
       num_aae002_begin NUMBER(6);
       num_aae002_end NUMBER(6);
       maxiaa100 NUMBER(6);
       v_tqjsyf xasi2.ac01k8.yae110%TYPE;

       cursor cur_aac001 is
          SELECT DISTINCT AAC001
            FROM xasi2.ac08 A
           WHERE aae143 = '01'
             AND AAC008 = '1'
             AND a.aae002 >=num_aae002_begin
             AND a.aae002 <= num_aae002_end
             AND AAB001 = prm_aab001
             AND yab139 ='610127'
          UNION
          SELECT DISTINCT AAC001
            FROM xasi2.AC08A1 A
           WHERE aae143 = '01'
             AND AAC008 = '1'
             AND a.aae002 >=num_aae002_begin
             AND a.aae002 <= num_aae002_end
             AND AAB001 = prm_aab001
             AND yab139 ='610127'
           UNION
           SELECT DISTINCT AAC001
             FROM xasi2.AC08A3 A
            WHERE aae143 = '01'
             AND AAC008 = '1'
             AND a.aae002 >=num_aae002_begin
             AND a.aae002 <= num_aae002_end
             AND AAB001 = prm_aab001
             AND yab139 ='610127'
           UNION
           SELECT DISTINCT AAC001
            FROM wsjb.irac08a1  A
           WHERE A.AAB001 = prm_aab001
             AND A.aae143 = '01'
             AND a.aae002 >=num_aae002_begin
             AND a.aae002 <= num_aae002_end
             AND NOT EXISTS (SELECT 1
                               FROM wsjb.irac01c1  B
                              WHERE B.AAC001 = A.AAC001
                                AND B.IAA100 = A.AAE002
                                AND A.AAB001 = B.AAB001
                                AND b.iaa100 >= num_aae002_begin
                                AND B.YAE031 = '1');

      --�����䶯
       cursor cur_aae310 is
           SELECT a.iaa001,
                  a.aac001,
                  a.aab001,
                  a.aac002,
                  a.aac003,
                  a.aac040,
                  a.yac004,
                  a.yac005,
                  a.iaa100,
                  a.aae110,
                  a.aae120,
                  a.aae210,
                  a.aae310,
                  a.aae410,
                  a.aae510,
                  a.aae311
            FROM wsjb.irac01  A
           WHERE A.AAB001 = prm_aab001
             AND A.AAC001 = v_aac001
             AND A.IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND A.iaa002 = '2'
             AND A.iaa100 >= to_number(prm_aae001||'01')
        --     AND NOT EXISTS (SELECT 1
        --                       FROM IRAC01C1 B
        --                      WHERE B.AAC001 = A.AAC001
        --                        AND B.IAA100 = A.IAA100
        --                        AND A.AAB001 = B.AAB001
        --                        AND B.YAE031 = '1')
             ORDER BY IAA100, AAE036;

            /*  ���±�����ύӰ�� ��д�˴��α� ��������˵���� �ָĻ�ȥ��
             SELECT T.iaa001,
                  T.aac001,
                  T.aab001,
                  T.aac002,
                  T.aac003,
                  T.aac040,
                  T.yac004,
                  T.yac005,
                  T.iaa100,
                  T.aae110,
                  T.aae120,
                  T.aae210,
                  T.aae310,
                  T.aae410,
                  T.aae510,
                  T.aae311
             FROM (SELECT a.iaa001,
                  a.aac001,
                  a.aab001,
                  a.aac002,
                  a.aac003,
                  a.aac040,
                  a.yac004,
                  a.yac005,
                  a.iaa100,
                  a.aae110,
                  a.aae120,
                  a.aae210,
                  a.aae310,
                  a.aae410,
                  a.aae510,
                  a.aae311,
                  a.iaa002,
               ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY AAE036 DESC) LEV
          FROM wsjb.irac01 a) T
          WHERE LEV = 1
            AND  T.AAB001 = prm_aab001
             AND T.AAC001 = v_aac001
             AND T.IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND T.iaa002 = '2'
             AND T.iaa100 >= to_number('2019'||'01')
             ORDER BY IAA100; */

     --�ճ���������ÿ�±�����Ա��������Ա
      cursor cur_aac001Ba IS
         SELECT DISTINCT AAC001
            FROM wsjb.irac08a1  A
           WHERE A.AAB001 = prm_aab001
             AND A.aae143 = '01'
             AND a.aae002 >=num_aae002_begin
             AND a.aae002 <= num_aae002_end
             AND EXISTS (SELECT 1
                               FROM wsjb.irac01c1  B
                              WHERE B.AAC001 = A.AAC001
                                AND B.IAA100 = A.AAE002
                                AND A.AAB001 = B.AAB001
                                AND b.iaa100 >= num_aae002_begin
                                AND B.YAE031 = '1');
      cursor cur_aae110Ba IS
          SELECT a.aac001,
                 a.aac002,
                 a.aac003,
                 a.aac009,
                 a.aac040,
                 a.yac004,
                 a.aae110,
                 a.iaa100
            FROM wsjb.irac01c1  a
           WHERE a.aab001=prm_aab001
             AND a.yae031='1'
             AND a.aac001 = v_aac001
             AND a.iaa100 >= num_aae002_begin;

    BEGIN
      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;
      n_count1     :=0;
      n_count2     :=0;
      n_yac506     :=0;
      n_yac507     :=0;
      n_yac508     :=0;
      n_yac005     :=0;
      v_aae110 := '';
      v_aae210 := '';
      v_aae310 := '';
      v_aae410 := '';
      v_aae510 := '';
      v_aae311 := '';
      /*��Ҫ������У��*/
      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '��λ��Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_ErrorMsg := '������Ա��Ų���Ϊ��!';
         RETURN;
      END IF;

      --�ճ������ж���Ա�ɷ�ʱ��
      SELECT MAX(yae097)
        INTO num_yae097
        FROM (
      SELECT MAX(yae097) AS yae097
        FROM xasi2.ab02
       WHERE aab001 = prm_aab001
      UNION ALL
      SELECT MAX(aae003) AS yae097
        FROM wsjb.irab08
       WHERE aab001 = prm_aab001
         AND yae517 = 'H01'
         AND aae140 = '01');

      num_aae002_begin := TO_NUMBER(prm_aae001||'01');
      num_aae002_end := num_yae097;

      IF SUBSTR(num_yae097,0,4) > prm_aae001 THEN
         num_aae002_end :=TO_NUMBER(prm_aae001||'12');
      ELSIF SUBSTR(num_yae097,0,4) < prm_aae001 THEN
         num_aae002_begin :=num_yae097;
      END IF;
      FOR rec_aac001 in cur_aac001 LOOP
        v_yac503 := '0';
        n_count  :=0;
        n_count1 :=0;
        n_count2 :=0;
        n_yac506 :=0;
        n_yac507 :=0;
        n_yac508 :=0;
        n_yac005 :=0;
        v_aae110 := '';
        v_aae210 := '';
        v_aae310 := '';
        v_aae410 := '';
        v_aae510 := '';
        v_aae311 := '';
        v_yae310 := '';
        v_yae110 := '';
        v_yae210 := '';
        v_yae410 := '';
        v_yae510 := '';

        SELECT aac001,aac002,aac003,aac009
          INTO v_aac001,v_aac002,v_aac003,v_aac009
          FROM xasi2.ac01
         WHERE aac001 = rec_aac001.aac001;

        FOR rec_aae310 IN cur_aae310 LOOP  --cur_aae310 �����䶯�α�

             IF rec_aae310.aae310 IN ('1','10') THEN
               v_yae310 := v_yae310||substr(rec_aae310.iaa100,5)||'����/';
             END IF;
             IF rec_aae310.aae310 = '3' THEN
               v_yae310 := v_yae310||substr(rec_aae310.iaa100,5)||'�¼�/';
               v_aae310 := '21';
             END IF;

             IF rec_aae310.aae110 IN ('1','10') THEN
               v_yae110 := v_yae110||substr(rec_aae310.iaa100,5)||'����/';
             END IF;
             IF rec_aae310.aae110 = '3' THEN
               v_yae110 := v_yae110||substr(rec_aae310.iaa100,5)||'�¼�/';
               v_aae110 := '21';
             END IF;

             IF rec_aae310.aae210 IN ('1','10') THEN
               v_yae210 := v_yae210||substr(rec_aae310.iaa100,5)||'����/';
             END IF;
             IF rec_aae310.aae210 = '3' THEN
               v_yae210 := v_yae210||substr(rec_aae310.iaa100,5)||'�¼�/';
               v_aae210 := '21';
             END IF;

             IF rec_aae310.aae410 IN ('1','10') THEN
               v_yae410 := v_yae410||substr(rec_aae310.iaa100,5)||'����/';
             END IF;
             IF rec_aae310.aae410 = '3' THEN
               v_yae410 := v_yae410||substr(rec_aae310.iaa100,5)||'�¼�/';
               v_aae410 := '21';
             END IF;

             IF rec_aae310.aae510 IN ('1','10') THEN
               v_yae510 := v_yae510||substr(rec_aae310.iaa100,5)||'����/';
             END IF;
             IF rec_aae310.aae510 = '3' THEN
               v_yae510 := v_yae510||substr(rec_aae310.iaa100,5)||'�¼�/';
               v_aae510 := '21';
             END IF;

             IF rec_aae310.aae311 = '3' THEN
               v_aae311 := '21';
             END IF;

             IF rec_aae310.iaa001 = '9' AND rec_aae310.aae310 = '2' AND rec_aae310.aae510 = '3' AND rec_aae310.aae311 = '2'THEN
               v_yae310 := v_yae310||substr(rec_aae310.iaa100,5)||'�´���/';
               v_aae310 := '21';
             END IF;
           END LOOP;

      --modify by whm 20190813 ��ǰ������û��������ԭ��λ,������ԭ��λ�������浥��дһ��ac01k8 start

      --����Ƿ�Ϊ������ǰ����
       SELECT count(1)
        INTO n_count
        FROM wsjb.irad51a1
       WHERE aac001 = v_aac001
         AND aab001 = prm_aab001
         AND yae031 = '1'
         AND aae041 >= prm_aae001||'01'
         AND aae041 <= prm_aae001||'12'
         AND not exists (select 1 from wsjb.irac01a3 a where a.aab001=prm_aab001 and a.aac001=v_aac001 and aae110='2');
      IF n_count > 0 THEN
        --ƴ����ǰ����ע��
          select max(decode(aae002, prm_aae001 || '01', '01��/')) ||
                        max(decode(aae002, prm_aae001 || '02', '02��/')) ||
                        max(decode(aae002, prm_aae001 || '03', '03��/')) ||
                        max(decode(aae002, prm_aae001 || '04', '04��/')) ||
                        max(decode(aae002, prm_aae001 || '05', '05��/')) ||
                        max(decode(aae002, prm_aae001 || '06', '06��/'))
                    as tqjsyf into v_tqjsyf
                   from wsjb.irad51a2
                  where aac001 = v_aac001
                    and aae002 >= prm_aae001 || '01'
                    and aae002 <= prm_aae001 || '12';
         v_yae110 := v_yae110||'������ǰ����/'||v_tqjsyf;
      END IF;
      --modify by whm 20190813 ��ǰ������û��������ԭ��λ,������ԭ��λ�������浥��дһ��ac01k8 ac01k8 end



      --�ж��Ƿ��ҽ�Ƽ�¼
        SELECT count(1)
          INTO n_count
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND aae140 = '03';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '03';
        SELECT count(1)
          INTO n_count2
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 IN ('2','3')
           AND aae140 = '03';
         IF n_count1 > 0 THEN
          v_aae310 := '2';
          SELECT aac040,yac004,yac503
            INTO n_yac506,n_yac508,v_yac503
            FROM xasi2.ac02
           WHERE AAB001 = prm_aab001
             AND AAC001 = v_aac001
             AND aac031 = '1'
             AND aae140 = '03';
         END IF;
         IF n_count2 > 0 THEN
          SELECT aac040,yac004,yac503
            INTO n_yac506,n_yac508,v_yac503
            FROM xasi2.ac02
           WHERE AAB001 = prm_aab001
             AND AAC001 = v_aac001
             AND AAC031 IN ('2','3')
             AND aae140 = '03';
         END IF;

       ELSE
           select COUNT(1)
             INTO n_count
              from wsjb.irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
         IF n_count > 0 THEN
            select max(iaa100)
              into maxiaa100
              from wsjb.irac01
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6', '3', '7', '9', '10')
               AND iaa002 = '2'
               AND iaa100 >= to_number(prm_aae001 || '01');
               IF maxiaa100<=201904 THEN
               --modify by wanghm start ���±�����ύӰ�� 4�º�᷵�ض��� 20190729
               select aac040,
                      yac005
                 into n_yac506,
                      n_yac508
               from wsjb.irac01
              where aab001 = prm_aab001
               and aac001 = v_aac001
               and IAA001 IN ('1', '5', '8', '6','3','7','9','10')
               and iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                              WHERE AAB001 = prm_aab001
                                AND AAC001 = v_aac001
                                AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                AND iaa002 = '2'
                                AND iaa100 >= to_number(prm_aae001||'01'));
               ELSE
               select aac040,
                      CASE WHEN aae310 <> 0 THEN yac005 ELSE 0 END
                 into n_yac506,
                      n_yac508
               from wsjb.irac01
               where iac001 = (
                       SELECT iac001
                        FROM (SELECT a.iac001, a.iaa100, a.aac001,
                                     ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY aae036 DESC) LEV
                                FROM wsjb.irad02a1 a) t
                       WHERE LEV = 1
                         and t.aac001 = v_aac001
                          and iaa100 =  (select max(iaa100) from wsjb.irac01
                                                        WHERE AAB001 = prm_aab001
                                                       AND AAC001 = v_aac001
                                                       AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                                       AND iaa002 = '2'
                                                       AND iaa100 >= to_number(2019||'01')));
               END IF;
         END IF;
       END IF;

       --�ж��Ƿ��������¼
        SELECT count(1)
          INTO n_count
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND aae140 = '05';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '05';
        SELECT count(1)
          INTO n_count2
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '2'
           AND aae140 = '05';
         IF n_count1 > 0 THEN
          v_aae510 := '2';
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac508,v_yac503
              FROM xasi2.ac02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '1'
               AND aae140 = '05';
          END IF;

         END IF;
         IF n_count2 > 0 THEN
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac508,v_yac503
              FROM xasi2.ac02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '2'
               AND aae140 = '05';
          END IF;
         END IF;
       ELSE
         select COUNT(1)
             INTO n_count
              from wsjb.irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
         IF n_count > 0 THEN
             IF n_yac506 = 0 AND n_yac508 = 0 THEN
             select max(iaa100)
              into maxiaa100
              from wsjb.irac01
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6', '3', '7', '9', '10')
               AND iaa002 = '2'
               AND iaa100 >= to_number(prm_aae001 || '01');
               IF maxiaa100<=201904 THEN
               --modify by wanghm start ���±�����ύӰ�� 4�º�᷵�ض��� 20190729
               select aac040,
                      yac005
                 into n_yac506,
                      n_yac508
               from wsjb.irac01
              where aab001 = prm_aab001
               and aac001 = v_aac001
               and IAA001 IN ('1', '5', '8', '6','3','7','9','10')
               and iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                              WHERE AAB001 = prm_aab001
                                AND AAC001 = v_aac001
                                AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                AND iaa002 = '2'
                                AND iaa100 >= to_number(prm_aae001||'01'));
               ELSE
               select aac040,
                      CASE WHEN aae510 <> 0 THEN yac005 ELSE 0 END
                 into n_yac506,
                      n_yac508
               from wsjb.irac01
               where iac001 = (
                       SELECT iac001
                        FROM (SELECT a.iac001, a.iaa100, a.aac001,
                                     ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY aae036 DESC) LEV
                                FROM wsjb.irad02a1 a) t
                       WHERE LEV = 1
                         and t.aac001 = v_aac001
                          and iaa100 =  (select max(iaa100) from wsjb.irac01
                                                        WHERE AAB001 = prm_aab001
                                                       AND AAC001 = v_aac001
                                                       AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                                       AND iaa002 = '2'
                                                       AND iaa100 >= to_number(2019||'01')));
               END IF;
             END IF;
          END IF;
       END IF;

        --�ж��Ƿ�δ���¼
        SELECT count(1)
          INTO n_count
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND aae140 = '07';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '07';
        SELECT count(1)
          INTO n_count2
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '2'
           AND aae140 = '07';
         IF n_count1 > 0 THEN
          v_aae311 := '2';
         END IF;
       END IF;


        --�ж��Ƿ��ʧҵ��¼
        SELECT count(1)
          INTO n_count
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = rec_aac001.aac001
           AND aae140 = '02';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = rec_aac001.aac001
           AND AAC031 = '1'
           AND aae140 = '02';
        SELECT count(1)
          INTO n_count2
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = rec_aac001.aac001
           AND AAC031 = '2'
           AND aae140 = '02';
         IF n_count1 > 0 THEN
          v_aae210 := '2';
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac005,v_yac503
              FROM xasi2.ac02
             WHERE AAB001 = prm_aab001
               AND AAC001 = rec_aac001.aac001
               AND aac031 = '1'
               AND aae140 = '02';
         END IF;
         IF n_count2 > 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac005,v_yac503
              FROM xasi2.ac02
             WHERE AAB001 = prm_aab001
               AND AAC001 = rec_aac001.aac001
               AND aac031 = '2'
               AND aae140 = '02';
         END IF;

       ELSE
          select COUNT(1)
             INTO n_count
              from wsjb.irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
        IF n_count > 0 THEN
          IF  n_yac005 = 0 THEN
            IF prm_aae001 <= 2019 THEN  --ʧҵ19��������ǰ����������ƽ
              select max(iaa100)
                into maxiaa100
                from wsjb.irac01
               WHERE AAB001 = prm_aab001
                 AND AAC001 = v_aac001
                 AND IAA001 IN ('1', '5', '8', '6', '3', '7', '9', '10')
                 AND iaa002 = '2'
                 AND iaa100 >= to_number(prm_aae001 || '01');
               IF maxiaa100<=201904 THEN
               --modify by wanghm start ���±�����ύӰ�� 4�º�᷵�ض��� 20190729
               select aac040,
                      yac005
                 into n_yac506,
                      n_yac005
                 from wsjb.irac01
                where aab001 = prm_aab001
                 and aac001 = v_aac001
                 and IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                 and iaa002 = '2'
                 and iaa100 = (select max(iaa100) from wsjb.irac01
                                WHERE AAB001 = prm_aab001
                                  AND AAC001 = v_aac001
                                  AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                  AND iaa002 = '2'
                                  AND iaa100 >= to_number(prm_aae001||'01'));
               ELSE
               select aac040,
                      CASE WHEN aae210 <> 0 THEN yac005 ELSE 0 END
                 into n_yac506,
                      n_yac005
               from wsjb.irac01
               where iac001 = (
                       SELECT iac001
                        FROM (SELECT a.iac001, a.iaa100, a.aac001,
                                     ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY aae036 DESC) LEV
                                FROM wsjb.irad02a1 a) t
                       WHERE LEV = 1
                         and t.aac001 = v_aac001
                          and iaa100 =  (select max(iaa100) from wsjb.irac01
                                                        WHERE AAB001 = prm_aab001
                                                       AND AAC001 = v_aac001
                                                       AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                                       AND iaa002 = '2'
                                                       AND iaa100 >= to_number(2019||'01')));
               END IF;
            ELSE
               select aac040,
                      CASE WHEN aae210 <> 0 THEN yac004 ELSE 0 END
                 into n_yac506,
                      n_yac005
               from wsjb.irac01
               where iac001 = (
                       SELECT iac001
                        FROM (SELECT a.iac001, a.iaa100, a.aac001,
                                     ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY aae036 DESC) LEV
                                FROM wsjb.irad02a1 a) t
                       WHERE LEV = 1
                         and t.aac001 = v_aac001
                          and iaa100 =  (select max(iaa100) from wsjb.irac01
                                                        WHERE AAB001 = prm_aab001
                                                       AND AAC001 = v_aac001
                                                       AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                                       AND iaa002 = '2'
                                                       AND iaa100 >= to_number(2019||'01')));
            END IF;
          END IF;
        END IF;
       END IF;


       --�ж��Ƿ�ι��˼�¼
        SELECT count(1)
          INTO n_count
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND aae140 = '04';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '04';
        SELECT count(1)
          INTO n_count2
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '2'
           AND aae140 = '04';
         IF n_count1 > 0 THEN
          v_aae410 := '2';
          IF n_yac506 = 0 AND n_yac005 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac005,v_yac503
              FROM xasi2.ac02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '1'
               AND aae140 = '04';
          END IF;
         END IF;
         IF n_count2 > 0 THEN
          IF  n_yac005 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac005,v_yac503
              FROM xasi2.ac02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 IN ('2','3')
               AND aae140 = '04';
          END IF;
         END IF;

       ELSE
         select COUNT(1)
             INTO n_count
              from wsjb.irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
          IF n_count > 0 THEN
          IF  n_yac005 = 0 THEN
            IF prm_aae001 <= 2019 THEN  --����19��������ǰ����������ƽ
              select max(iaa100)
                into maxiaa100
                from wsjb.irac01
               WHERE AAB001 = prm_aab001
                 AND AAC001 = v_aac001
                 AND IAA001 IN ('1', '5', '8', '6', '3', '7', '9', '10')
                 AND iaa002 = '2'
                 AND iaa100 >= to_number(prm_aae001 || '01');
               IF maxiaa100<=201904 THEN
               --modify by wanghm start ���±�����ύӰ�� 4�º�᷵�ض��� 20190729
               select aac040,
                      yac005
                 into n_yac506,
                      n_yac005
                 from wsjb.irac01
                where aab001 = prm_aab001
                 and aac001 = v_aac001
                 and IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                 and iaa002 = '2'
                 and iaa100 = (select max(iaa100) from wsjb.irac01
                                WHERE AAB001 = prm_aab001
                                  AND AAC001 = v_aac001
                                  AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                  AND iaa002 = '2'
                                  AND iaa100 >= to_number(prm_aae001||'01'));
               ELSE
               select aac040,
                      CASE WHEN aae410 <> 0 THEN yac005 ELSE 0 END
                 into n_yac506,
                      n_yac005
               from wsjb.irac01
               where iac001 = (
                       SELECT iac001
                        FROM (SELECT a.iac001, a.iaa100, a.aac001,
                                     ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY aae036 DESC) LEV
                                FROM wsjb.irad02a1 a) t
                       WHERE LEV = 1
                         and t.aac001 = v_aac001
                          and iaa100 =  (select max(iaa100) from wsjb.irac01
                                                        WHERE AAB001 = prm_aab001
                                                       AND AAC001 = v_aac001
                                                       AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                                       AND iaa002 = '2'
                                                       AND iaa100 >= to_number(2019||'01')));
               END IF;
            ELSE
               select aac040,
                      CASE WHEN aae410 <> 0 THEN yac004 ELSE 0 END
                 into n_yac506,
                      n_yac005
               from wsjb.irac01
               where iac001 = (
                       SELECT iac001
                        FROM (SELECT a.iac001, a.iaa100, a.aac001,
                                     ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY aae036 DESC) LEV
                                FROM wsjb.irad02a1 a) t
                       WHERE LEV = 1
                         and t.aac001 = v_aac001
                          and iaa100 =  (select max(iaa100) from wsjb.irac01
                                                        WHERE AAB001 = prm_aab001
                                                       AND AAC001 = v_aac001
                                                       AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                                       AND iaa002 = '2'
                                                       AND iaa100 >= to_number(2019||'01')));
            END IF;
          END IF;
        END IF;
       END IF;

       --�ж��Ƿ�����ϼ�¼
       SELECT count(1)
          INTO n_count
          FROM wsjb.IRAC01A3
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001;
       IF n_count > 0 THEN
        SELECT count(1)
          INTO n_count1
          FROM wsjb.IRAC01A3
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAE110 = '2';
        SELECT count(1)
          INTO n_count2
          FROM wsjb.IRAC01A3
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAE110 = '0';
         IF n_count1 > 0 THEN
          v_aae110 := '2';
          SELECT YAC004
            INTO n_yac507
            FROM wsjb.IRAC01A3
           WHERE AAB001 = prm_aab001
             AND AAC001 = v_aac001
             AND AAE110 = '2';
         END IF;
        IF n_count2 > 0 THEN
           --�нɷѼ�¼�Ÿ���ʾ�α�״̬
           SELECT count(1)
            INTO n_count
            FROM wsjb.irac08a1  A
           WHERE A.AAB001 = prm_aab001
             AND a.aac001 = v_aac001
             AND A.aae143 = '01'
             AND A.aae002 >= (SELECT aae041
                                FROM xasi2.AA02A3
                               WHERE aae140 = '01'
                                  AND aae001 = prm_aae001);
           IF n_count >0 THEN
              v_aae110 := '21';
           END IF ;
            SELECT COUNT(1)
               INTO n_count
                FROM wsjb.irac01
              WHERE aab001 = prm_aab001
                 AND aac001 = v_aac001
                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
               AND iaa002 = '2'
                 AND iaa100 = (select max(iaa100) from wsjb.irac01
                                    WHERE AAB001 = prm_aab001
                                   AND AAC001 = v_aac001
                                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                   AND iaa002 = '2'
                                   AND iaa100 >= to_number(prm_aae001||'01'));
           IF n_count > 0 THEN
              --modify by wanghm start ���±�����ύӰ�� 4�º�᷵�ض��� 20190729
              select max(iaa100)
              into maxiaa100
              from wsjb.irac01
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6', '3', '7', '9', '10')
               AND iaa002 = '2'
               AND iaa100 >= to_number(prm_aae001 || '01');

              IF maxiaa100<=201904 THEN
                select distinct (CASE WHEN aae110 <> 0 THEN yac004 ELSE 0 END)
                  into n_yac507
                  from wsjb.irac01
                 where aab001 = prm_aab001
                   and aac001 = v_aac001
                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                 AND iaa002 = '2'
                   and iaa100 = (select max(iaa100) from wsjb.irac01
                                    WHERE AAB001 = prm_aab001
                                   AND AAC001 = v_aac001
                                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                   AND iaa002 = '2'
                                   AND iaa100 >= to_number(prm_aae001||'01'));
             ELSE
             select  CASE WHEN aae110 <> 0 THEN yac004 ELSE 0 END
               into n_yac507
                from wsjb.irac01
               where iac001 = (
                       SELECT iac001
                        FROM (SELECT a.iac001, a.iaa100, a.aac001,
                                     ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY aae036 DESC) LEV
                                FROM wsjb.irad02a1 a) t
                       WHERE LEV = 1
                         and t.aac001 = v_aac001
                          and iaa100 =  (select max(iaa100) from wsjb.irac01
                                                        WHERE AAB001 = prm_aab001
                                                       AND AAC001 = v_aac001
                                                       AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                                       AND iaa002 = '2'
                                                       AND iaa100 >= to_number(prm_aae001||'01')));
              END IF;
           ELSE
             --�нɷѼ�¼�Ÿ���ʾ�ɷѻ���
             SELECT count(1)
              INTO n_count
              FROM wsjb.irac08a1  A
             WHERE A.AAB001 = prm_aab001
               AND a.aac001 = v_aac001
               AND A.aae143 = '01'
               AND A.aae002 >= (SELECT aae041
                                  FROM xasi2.AA02A3
                                 WHERE aae140 = '01'
                                    AND aae001 = prm_aae001);
             IF n_count >0 THEN
                --��ȡ���ϻ���
               SELECT count(1)
                 INTO n_count1
                 FROM wsjb.irac01c1
                WHERE aab001 = prm_aab001
                  AND aac001 = v_aac001
                  AND yae031 = '1';
              IF n_count1 > 0 THEN
               n_yac507 := 0 ;
               ELSE
               SELECT yac004
                 INTO n_yac507
                 FROM wsjb.IRAC01A3
                WHERE aab001 = prm_aab001
                    AND aac001 = v_aac001;
               END IF;
             END IF ;
           END IF;
        END IF;
       ELSE
           select COUNT(1)
             INTO n_count
              from wsjb.irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
         IF n_count > 0 THEN
           --modify by wanghm start ���±�����ύӰ�� 4�º�᷵�ض��� 20190729
           select max(iaa100)
              into maxiaa100
              from wsjb.irac01
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6', '3', '7', '9', '10')
               AND iaa002 = '2'
               AND iaa100 >= to_number('2019' || '01');

           IF maxiaa100<=201904 THEN
           select CASE WHEN aae110 <> 0 THEN yac004 ELSE 0 END
                into n_yac507
                from wsjb.irac01
               where aab001 = prm_aab001
                 and aac001 = v_aac001
                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
               AND iaa002 = '2'
                 and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
           ELSE
           select  CASE WHEN aae110 <> 0 THEN yac004 ELSE 0 END
               into n_yac507
                from wsjb.irac01
               where iac001 = (
                       SELECT iac001
                        FROM (SELECT a.iac001, a.iaa100, a.aac001,
                                     ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY aae036 DESC) LEV
                                FROM wsjb.irad02a1 a) t
                       WHERE LEV = 1
                         and t.aac001 = v_aac001
                          and iaa100 =  (select max(iaa100) from wsjb.irac01
                                                        WHERE AAB001 = prm_aab001
                                                       AND AAC001 = v_aac001
                                                       AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                                       AND iaa002 = '2'
                                                       AND iaa100 >= to_number(prm_aae001||'01')));
           END IF;
         END IF;

       END IF;



       IF n_yac506 IS NULL THEN
          n_yac506 := 0;
       END IF;
       IF n_yac507 IS NULL OR n_yac507 <= 0 THEN
         --�Ƿ�������ϽɷѼ�¼
           SELECT count(1)
             INTO n_count
            FROM wsjb.irac08a1  A
           WHERE A.AAB001 = prm_aab001
             AND A.aae143 = '01'
             AND A.aac001 = v_aac001
             AND A.aae002 >= (SELECT aae041
                                FROM xasi2.AA02A3
                               WHERE aae140 = '01'
                                  AND aae001 = prm_aae001);
           IF n_count > 0 THEN
             --�������ȡ���һ�νɷ��ڵĻ���
            SELECT aae180
              INTO n_yac507
              FROM wsjb.irac08a1
             WHERE aac001 =  v_aac001
               AND aab001 =  prm_aab001
               AND aae143 = '01'
               AND aae002 = (SELECT MAX(aae002)
                                FROM wsjb.irac08a1
                               WHERE aac001 =  v_aac001
                                 AND aab001 =  prm_aab001
                                 AND aae140 = '01'
                                 AND aae143 = '01'
                                 AND aae002 >= (SELECT aae041
                                                  FROM xasi2.AA02A3
                                                 WHERE aae140 = '01'
                                                    AND aae001 = prm_aae001));
          ELSE
            n_yac507 := 0;
          END IF;

       END IF;
       IF n_yac508 IS NULL THEN
           n_yac508 := 0;
       END IF;

       INSERT INTO xasi2.ac01k8 (
                                    aac001,
                                    aab001,
                                    aac002,
                                    aac003,
                                    aac009,
                                    yac506,
                                    yac507,
                                    yac508,
                                    aae110,
                                    aae210,
                                    aae310,
                                    aae410,
                                    aae510,
                                    aae311,
                                    aae001,
                                    yac503,
                                    yac005,
                                    yae092,
                                    iaa002,
                                    yae110,
                                    yae310,
                                    yae210,
                                    yae410,
                                    yae510,
                                    yab019,
                                    aae034
                                    )VALUES(
                                    v_aac001,
                                    prm_aab001,
                                    v_aac002,
                                    v_aac003,
                                    v_aac009,
                                    n_yac506,
                                    n_yac507,
                                    n_yac508,
                                    v_aae110,
                                    v_aae210,
                                    v_aae310,
                                    v_aae410,
                                    v_aae510,
                                    v_aae311,
                                    prm_aae001,
                                    v_yac503,
                                    n_yac005,
                                    prm_yae092,
                                    '0' ,
                                    v_yae110,
                                    v_yae310,
                                    v_yae210,
                                    v_yae410,
                                    v_yae510,
                                    '1',
                                    SYSDATE
                                    );
                                    
      -- ��ǰ����û������������Ա���¾ɽɷѹ��ʺͻ���д��һ����
       SELECT count(1)
        INTO n_count
        FROM wsjb.irad51a1
       WHERE aac001 = v_aac001
         AND aab001 = prm_aab001
         AND yae031 = '1'
         AND aae041 >= prm_aae001||'01'
         AND aae041 <= prm_aae001||'12'
         AND not exists (select 1 from wsjb.irac01a3 a where a.aab001=prm_aab001 and a.aac001=v_aac001 and aae110='2');
        if n_count >0 then
          update xasi2.ac01k8
             set aac040 = n_yac506,
                 yac004 = n_yac507,
                 yaa333 = n_yac508,
                 yaa444 = n_yac005,
                 aae013 = '2' -- 2 : ��ǰ�������
           where aab001 = prm_aab001
             and aac001 = v_aac001
             and aae001 = prm_aae001;
        end if;

        -- ��ǰ����������صĵ���дһ�� AC01K8
           SELECT count(1)
            INTO n_count
            FROM wsjb.irad51a1 a, wsjb.irac01a3 b
           WHERE b.aae110 = '2'
             AND a.aac001 = b.aac001
             AND a.aab001 = b.aab001
             AND a.aac001 = v_aac001
             AND a.aab001 = prm_aab001
             AND a.yae031 = '1'
             AND a.aae041 >= prm_aae001||'01'
             AND a.aae041 <= prm_aae001||'12';
           IF n_count > 0 THEN
                 update xasi2.ac01k8
                   set aae013 = '22' -- 22 : ��ǰ������������ չʾ������һ����¼
                 where aab001 = prm_aab001
                   and aac001 = v_aac001
                   and aae001 = prm_aae001;  
                 --ƴ����ǰ����ע��
                 select max(decode(aae002, prm_aae001 || '01', '01��/')) ||
                        max(decode(aae002, prm_aae001 || '02', '02��/')) ||
                        max(decode(aae002, prm_aae001 || '03', '03��/')) ||
                        max(decode(aae002, prm_aae001 || '04', '04��/')) ||
                        max(decode(aae002, prm_aae001 || '05', '05��/')) ||
                        max(decode(aae002, prm_aae001 || '06', '06��/'))
                    as tqjsyf into v_tqjsyf
                   from wsjb.irad51a2
                  where aac001 = v_aac001
                    and aae002 >= prm_aae001 || '01'
                    and aae002 <= prm_aae001 || '12';
                  v_yae110 := '������ǰ����/'||v_tqjsyf;
                  
                  --��ȡ�����¶ȵĽ������˻���(�����ǰ�����������������AC02��IRAC01ȡ�Ͳ�����,����ȡ����ʱ�Ļ���)
                  select distinct b.yaa334,b.yaa334
                     into n_yac506,n_yac507
                    from irad51a1 a, irad51a2 b
                   where a.yae031 ='1'
                   and a.yae518 =b.yae518
                   and  a.aab001 = prm_aab001
                   and a.aac001 = v_aac001;
                    --��ǰ������¾ɽɷѹ��ʺͻ���д��һ����
                     INSERT INTO xasi2.ac01k8 (
                                            aac001,
                                            aab001,
                                            aac002,
                                            aac003,
                                            aac009,
                                            yac506,
                                            yac507,
                                            yac508,
                                            aac040,
                                            yac004,
                                            yaa333,
                                            aae110,
                                            aae210,
                                            aae310,
                                            aae410,
                                            aae510,
                                            aae311,
                                            aae001,
                                            yac503,
                                            yac005,
                                            yae092,
                                            iaa002,
                                            yae110,
                                            yae310,
                                            yae210,
                                            yae410,
                                            yae510,
                                            yaa444,
                                            yab019,
                                            aae034,
                                            aae013
                                            )VALUES(
                                            v_aac001,
                                            prm_aab001,
                                            v_aac002,
                                            v_aac003,
                                            v_aac009,
                                            n_yac506,
                                            n_yac507,
                                            n_yac508,
                                            n_yac506,
                                            n_yac507,
                                            n_yac508,
                                            v_aae110,
                                            v_aae210,
                                            v_aae310,
                                            v_aae410,
                                            v_aae510,
                                            v_aae311,
                                            prm_aae001,
                                            v_yac503,
                                            n_yac005,
                                            prm_yae092,
                                            '0' ,
                                            v_yae110,
                                            v_yae310,
                                            v_yae210,
                                            v_yae410,
                                            v_yae510,
                                            n_yac005,
                                            '1',
                                            SYSDATE,
                                            '21' -- ��ǰ������������ չʾ��ǰ�����һ����¼
                                            );
            END IF;
            
            --������Աд��־ 
            SELECT count(1)
              INTO n_count
              FROM xasi2.ac02_zy
             where aac001 = v_aac001;
             IF n_count >0 THEN
                update xasi2.ac01k8
                 set aae013 = '1'
                where aab001 = prm_aab001
                 and aac001 = v_aac001
                 and aae001 = prm_aae001;
             END IF;
             
      END LOOP;

   --�������ϱ����� 201811���Ѿ�û�����ҵ����
   FOR rec_aac001Ba in cur_aac001Ba LOOP
        v_yac503 := '0';
        n_count  :=0;
        n_count1 :=0;
        n_count2 :=0;
        n_yac506 :=0;
        n_yac507 :=0;
        n_yac508 :=0;
        n_yac005 :=0;
        v_aae110 := '';
        v_aae210 := '';
        v_aae310 := '';
        v_aae410 := '';
        v_aae510 := '';
        v_aae311 := '';
        v_yae310 := '';
        v_yae110 := '';
        v_yae210 := '';
        v_yae410 := '';
        v_yae510 := '';

        SELECT aac001,aac002,aac003,aac009
          INTO v_aac001,v_aac002,v_aac003,v_aac009
          FROM xasi2.ac01
         WHERE aac001 = rec_aac001Ba.aac001;

        FOR rec_aae110Ba IN cur_aae110Ba LOOP
             IF rec_aae110Ba.aae110 IN ('����') THEN
               v_yae110 := v_yae110||substr(rec_aae110Ba.iaa100,5)||'�±���/';
             END IF;
           END LOOP;

        SELECT YAB029,
               AAC002,
               AAC003,
               AAC009,
               AAC040,
               YAC004,
               AAE110
          INTO v_aac001,
               v_aac002,
               v_aac003,
               v_aac009,
               n_yac506,
               n_yac507,
               v_aae110
          FROM wsjb.irac01c1
         WHERE AAC001 = rec_aac001Ba.AAC001
           AND AAB001 = PRM_AAB001
           AND YAE031 = '1'
           AND IAA100 = (SELECT MAX(IAA100)
                           FROM wsjb.irac01c1
                          WHERE AAC001 = rec_aac001Ba.AAC001
                            AND YAE031 = '1'
                            AND AAB001 = PRM_AAB001);
      --����Ƿ�Ϊ������ǰ����
      SELECT count(1)
        INTO n_count
        FROM wsjb.irad51a1
       WHERE aac001 = v_aac001
         AND aab001 = prm_aab001
         AND yae031 = '1'
         and aae041 = prm_aae001||'01';
      IF n_count > 0 THEN
         v_yae110 := v_yae110||'������ǰ����/';
      END IF;

       INSERT INTO xasi2.ac01k8 (
                                    aac001,
                                    aab001,
                                    aac002,
                                    aac003,
                                    aac009,
                                    yac506,
                                    yac507,
                                    yac508,
                                    aae110,
                                    aae210,
                                    aae310,
                                    aae410,
                                    aae510,
                                    aae311,
                                    aae001,
                                    yac503,
                                    yac005,
                                    yae092,
                                    iaa002,
                                    yae110,
                                    yae310,
                                    yae210,
                                    yae410,
                                    yae510,
                                    yab019,
                                    aae034
                                    )VALUES(
                                    v_aac001,
                                    prm_aab001,
                                    v_aac002,
                                    v_aac003,
                                    v_aac009,
                                    n_yac506,
                                    n_yac507,
                                    n_yac508,
                                    v_aae110,
                                    v_aae210,
                                    v_aae310,
                                    v_aae410,
                                    v_aae510,
                                    v_aae311,
                                    prm_aae001,
                                    v_yac503,
                                    n_yac005,
                                    prm_yae092,
                                    '0' ,
                                    v_yae110,
                                    v_yae310,
                                    v_yae210,
                                    v_yae410,
                                    v_yae510,
                                    '1',
                                    SYSDATE
                                    );
      END LOOP;
   EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;

   END prc_queryjishu;

   /*****************************************************************************
   ** �������� : prc_YLqueryjishu
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����ѯ��λ�ɷ���Ա������(������)
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--������
                 prm_aae001       IN     VARCHAR2(4),--�걨���
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2013-05-25   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_YLqueryjishu(
        prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
        prm_yae092       IN     iraa01a1.aae011%TYPE,--������
        prm_aae001       IN     VARCHAR2,--�걨���
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             )
    IS
        n_count  number(6);
       n_count1 number(6);
       n_count2 number(6);
       v_aac001 irac01.aac001%TYPE;
       v_yab029 irab05.yab029%TYPE;
       v_aac002 irac01.aac002%TYPE;
       v_aac003 irac01.aac003%TYPE;
       v_aac009 irac01.aac009%TYPE;
       v_yac503 irac01.yac503%TYPE;
       n_yac506 NUMBER(14,2);--ԭ�ɷѹ���
       n_yac507 NUMBER(14,2);--ԭ���ϻ���
       n_yac508 NUMBER(14,2);
       n_yac005 NUMBER(14,2);
       v_aae110 irac01.aae110%TYPE;
       v_yae110 VARCHAR2(3000);


       cursor cur_aac001 is
          SELECT DISTINCT AAC001
            FROM wsjb.irac08a1  A
           WHERE A.AAB001 = prm_aab001
             AND A.aae143 = '01'
             AND A.aae002 >= (SELECT aae041 FROM xasi2.AA02A3 WHERE aae140 = '01' AND aae001 = prm_aae001);

       --�����䶯
       cursor cur_aae110 is
           SELECT iaa001,
                  aac001,
                  aab001,
                  aac002,
                  aac003,
                  aac040,
                  yac004,
                  yac005,
                  iaa100,
                  aae110,
                  aae120,
                  aae210,
                  aae310,
                  aae410,
                  aae510,
                  aae311
            FROM wsjb.irac01
           WHERE AAB001 = prm_aab001
             AND AAC001 = v_aac001
             AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
             AND iaa100 >= to_number(prm_aae001||'01')
             ORDER BY IAA100;
        --�ճ���������ÿ�±�����Ա��������Ա

      cursor cur_aae110Ba IS
          SELECT a.aac001,
                 a.aac002,
                 a.aac003,
                 a.aac009,
                 a.aac040,
                 a.yac004,
                 a.aae110,
                 a.iaa100
            FROM wsjb.irac01c1  a
           WHERE a.aab001=prm_aab001
             AND a.yae031='1'
             AND a.aac001 = v_aac001;
    BEGIN
      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;
      n_count1     :=0;
      n_count2     :=0;
      n_yac506     :=0;
      n_yac507     :=0;
      n_yac508     :=0;
      n_yac005     :=0;
      v_aae110 := '';
      v_yae110 := '';
      v_yab029 := '';
       /*��Ҫ������У��*/
      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '��λ��Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_ErrorMsg := '������Ա��Ų���Ϊ��!';
         RETURN;
      END IF;

      FOR rec_aac001 in cur_aac001 LOOP
        n_count      :=0;
        n_count1     :=0;
        n_count2     :=0;
        n_yac506     :=0;
        n_yac507     :=0;
        n_yac508     :=0;
        n_yac005     :=0;
        v_aae110 := '';
        v_yae110 := '';
        v_yab029 := '';

        SELECT count(1)
          INTO n_count
          FROM xasi2.ac01
         WHERE aac001 = rec_aac001.aac001;
      IF n_count >0 THEN
         SELECT aac001,aac002,aac003,aac009
          INTO v_aac001,v_aac002,v_aac003,v_aac009
          FROM xasi2.ac01
         WHERE aac001 = rec_aac001.aac001;
       ELSE
          SELECT aac001,aac002,aac003,aac009,aae110,yab029
          INTO v_aac001,v_aac002,v_aac003,v_aac009,v_aae110,v_yab029
          FROM wsjb.irac01c1
         WHERE aac001 = rec_aac001.aac001;
       END IF;
      FOR rec_aae110 IN cur_aae110 LOOP
             IF rec_aae110.aae110 IN ('1','10') THEN
               v_yae110 := v_yae110||substr(rec_aae110.iaa100,5)||'����/';
             END IF;
             IF rec_aae110.aae110 = '3' THEN
               v_yae110 := v_yae110||substr(rec_aae110.iaa100,5)||'�¼�/';
               v_aae110 := '21';
             END IF;

      END LOOP;
      FOR rec_aae110Ba IN cur_aae110Ba LOOP
        IF rec_aae110Ba.aae110 IN ('����') THEN
               v_yae110 := v_yae110||substr(rec_aae110Ba.iaa100,5)||'�±���/';
             END IF;
        END LOOP;
      --�ж��Ƿ�����ϼ�¼
        SELECT count(1)
          INTO n_count
          FROM wsjb.IRAC01A3
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001;
       IF n_count > 0 THEN
        SELECT count(1)
          INTO n_count1
          FROM wsjb.IRAC01A3
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAE110 = '2';
        SELECT count(1)
          INTO n_count2
          FROM wsjb.IRAC01A3
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAE110 = '0';
         IF n_count1 > 0 THEN
          v_aae110 := '2';
          SELECT aac040 ,yac004
             INTO n_yac506,n_yac507
            FROM wsjb.IRAC01A3
           WHERE AAB001 = prm_aab001
             AND AAC001 = v_aac001
             AND AAE110 = '2';
         END IF;
        IF n_count2 > 0 THEN
           --�нɷѼ�¼�Ÿ���ʾ�α�״̬
             SELECT count(1)
              INTO n_count
              FROM wsjb.irac08a1  A
             WHERE A.AAB001 = prm_aab001
               AND a.aac001 = v_aac001
               AND A.aae143 = '01'
               AND A.aae002 >= (SELECT aae041
                                  FROM xasi2.AA02A3
                                 WHERE aae140 = '01'
                                    AND aae001 = prm_aae001);
             IF n_count >0 THEN
               v_aae110 := '21';
             END IF ;
            select COUNT(1)
               INTO n_count
                from wsjb.irac01
              where aab001 = prm_aab001
                 and aac001 = v_aac001
                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
               AND iaa002 = '2'
                 and iaa100 = (select max(iaa100) from wsjb.irac01
                                    WHERE AAB001 = prm_aab001
                                   AND AAC001 = v_aac001
                                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                   AND iaa002 = '2'
                                   AND iaa100 >= to_number(prm_aae001||'01'));
           IF n_count > 0 THEN
               select aac040 ,yac004
                   INTO n_yac506,n_yac507
                  from wsjb.irac01
                 where aab001 = prm_aab001
                   and aac001 = v_aac001
                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                 AND iaa002 = '2'
                   and iaa100 = (select max(iaa100) from wsjb.irac01
                                    WHERE AAB001 = prm_aab001
                                   AND AAC001 = v_aac001
                                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                   AND iaa002 = '2'
                                   AND iaa100 >= to_number(prm_aae001||'01'));
           ELSE
             --�нɷѼ�¼�Ÿ���ʾ�ɷѻ���
               SELECT count(1)
                INTO n_count
                FROM wsjb.irac08a1  A
               WHERE A.AAB001 = prm_aab001
                 AND a.aac001 = v_aac001
                 AND A.aae143 = '01'
                 AND A.aae002 >= (SELECT aae041
                                    FROM xasi2.AA02A3
                                   WHERE aae140 = '01'
                                      AND aae001 = prm_aae001);
               IF n_count >0 THEN
                  --��ȡ���ϻ���
                 SELECT aac040 ,yac004
                   INTO n_yac506,n_yac507
                   FROM wsjb.IRAC01A3
                  WHERE aab001 = prm_aab001
                      AND aac001 = v_aac001;
               END IF ;
           END IF;
        END IF;
       ELSE
           select COUNT(1)
             INTO n_count
              from wsjb.irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
         IF n_count > 0 THEN
             select aac040 ,yac004
                into n_yac506, n_yac507
                from wsjb.irac01
               where aab001 = prm_aab001
                 and aac001 = v_aac001
                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
               AND iaa002 = '2'
                 and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));

         END IF;

       END IF;
       IF n_yac506 IS NULL THEN
           n_yac506 := 0;
       END IF;
        IF n_yac507 IS NULL THEN
         --�Ƿ�������ϽɷѼ�¼
           SELECT count(1)
             INTO n_count
            FROM wsjb.irac08a1  A
           WHERE A.AAB001 = prm_aab001
             AND A.aae143 = '01'
             AND A.aac001 = v_aac001
             AND A.aae002 >= (SELECT aae041
                                FROM xasi2.AA02A3
                               WHERE aae140 = '01'
                                  AND aae001 = prm_aae001);
           IF n_count > 0 THEN
             --�������ȡ���һ�νɷ��ڵĻ���
            SELECT  aac040,aae180
              INTO n_yac506,n_yac507
              FROM wsjb.irac08a1
             WHERE aac001 =  v_aac001
               AND aab001 =  prm_aab001
               AND aae143 = '01'
               AND aae002 = (SELECT MAX(aae002)
                                FROM wsjb.irac08a1
                               WHERE aac001 =  v_aac001
                                 AND aab001 =  prm_aab001
                                 AND aae140 = '01'
                                 AND aae143 = '01'
                                 AND aae002 >= (SELECT aae041
                                                  FROM xasi2.AA02A3
                                                 WHERE aae140 = '01'
                                                    AND aae001 = prm_aae001));
          ELSE
            n_yac507 := 0;
          END IF;

       END IF;
       IF n_yac506 = 0 AND n_yac507 = 0 THEN
        SELECT aac040,aae180
              INTO n_yac506,n_yac507
              FROM wsjb.irac08a1
             WHERE aac001 =  v_aac001
               AND aab001 =  prm_aab001
               AND aae143 = '01'
               AND aae002 = (SELECT MAX(aae002)
                                FROM wsjb.irac08a1
                               WHERE aac001 =  v_aac001
                                 AND aab001 =  prm_aab001
                                 AND aae140 = '01'
                                 AND aae143 = '01'
                                 AND aae002 >= (SELECT aae041
                                                  FROM xasi2.AA02A3
                                                 WHERE aae140 = '01'
                                                    AND aae001 = prm_aae001));
        END if;
       IF n_yac508 IS NULL THEN
           n_yac508 := 0;
       END IF;

        INSERT INTO xasi2.ac01k8 (
                                    aac001,
                                    aab001,
                                    aac002,
                                    aac003,
                                    aac009,
                                    yac506,
                                    yac507,
                                    yac508,
                                    aae110,
                                    aae210,
                                    aae310,
                                    aae410,
                                    aae510,
                                    aae311,
                                    aae001,
                                    yac503,
                                    yac005,
                                    yae092,
                                    iaa002,
                                    yae110,
                                    yab019,
                                    aae034
                                    )VALUES(
                                    rec_aac001.aac001,
                                    prm_aab001,
                                    v_aac002,
                                    v_aac003,
                                    v_aac009,
                                    n_yac506,
                                    n_yac507,
                                    0,
                                    v_aae110,
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    prm_aae001,
                                    v_yac503,
                                    n_yac005,
                                    prm_yae092,
                                    '0',
                                    v_yae110,
                                    '1',
                                    SYSDATE
                                    );
         IF v_yab029 IS NOT NULL THEN
          UPDATE xasi2.ac01k8
             SET aac001 = v_yab029
           WHERE aac001 = rec_aac001.aac001
             AND aab001 = prm_aab001
             AND aae001 = prm_aae001;
          END IF;

      END LOOP;
      EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE()||v_aac001||' '||v_yab029;
         RETURN;
   END prc_YLqueryjishu;

    /*****************************************************************************
   ** �������� : prc_JGqueryjishu
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����ѯ��λ�ɷ���Ա������(������ҵ��λ)
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2013-05-25   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_JGqueryjishu(
        prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
        prm_yae092       IN     iraa01a1.aae011%TYPE,--������
        prm_aae001       IN     VARCHAR2,
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             )
    IS
        n_count  number(6);
       n_count1 number(6);
       n_count2 number(6);
       v_aac001 irac01.aac001%TYPE;
       v_aac002 irac01.aac002%TYPE;
       v_aac003 irac01.aac003%TYPE;
       v_aac009 irac01.aac009%TYPE;
       v_yac503 irac01.yac503%TYPE;--�������
       n_yac506 NUMBER(14,2);--ԭ�ɷѹ���
       n_yac507 NUMBER(14,2);--ԭ���ϻ���
       n_yac508 NUMBER(14,2);--ԭ�ɷѻ���
       n_yac005 NUMBER(14,2);--ԭ���˽ɷѻ���
       v_aae110 irac01.aae110%TYPE;
       v_aae210 irac01.aae210%TYPE;
       v_aae310 irac01.aae310%TYPE;
       v_aae410 irac01.aae410%TYPE;
       v_aae510 irac01.aae510%TYPE;
       v_aae311 irac01.aae311%TYPE;
       v_yae310 VARCHAR2(3000);--ҽ�Ʊ�ע
       v_yae110 VARCHAR2(3000);--���ϱ�ע
       v_yae210 VARCHAR2(3000);--ʧҵ��ע
       v_yae410 VARCHAR2(3000);--���˱�ע
       v_yae510 VARCHAR2(3000);--������ע

       cursor cur_aac001 is
          SELECT DISTINCT AAC001
            FROM xasi2.ac08 A
           WHERE EXISTS (SELECT 1
                    FROM xasi2.AB08A8
                   WHERE AAB001 = prm_aab001
                     AND AAE041 >= to_number(prm_aae001||'01')
                     AND YAE518 = A.YAE518)
             AND AAC008 = '1'
             AND AAB001 = prm_aab001
             AND AAE002 = (SELECT YAE097 FROM xasi2.AB02 WHERE AAB001 = prm_aab001 AND AAB051 = '1' AND AAE140 = '06' )
          UNION
          SELECT DISTINCT AAC001
            FROM xasi2.AC08A1 A
           WHERE EXISTS (SELECT 1
                    FROM xasi2.AB08
                   WHERE AAB001 = prm_aab001
                     AND AAE041 >= to_number(prm_aae001||'01')
                     AND YAE518 = A.YAE518)
             AND AAC008 = '1'
             AND AAB001 = prm_aab001
             AND AAE002 = (SELECT YAE097 FROM xasi2.AB02 WHERE AAB001 = prm_aab001 AND AAB051 = '1' AND AAE140 = '06' )
           UNION
           SELECT DISTINCT AAC001
            FROM xasi2.AC08A3 A
           WHERE EXISTS (SELECT 1
                    FROM xasi2.AB08A8
                   WHERE AAB001 = prm_aab001
                     AND AAE041 >= to_number(prm_aae001||'01')
                     AND YAE518 = A.YAE518)
             AND AAC008 = '1'
             AND AAB001 = prm_aab001
             AND AAE002 = (SELECT YAE097 FROM xasi2.AB02 WHERE AAB001 = prm_aab001 AND AAB051 = '1' AND AAE140 = '06' );
       --�����䶯
       cursor cur_aae310 is
           SELECT iaa001,
                  aac001,
                  aab001,
                  aac002,
                  aac003,
                  aac040,
                  yac004,
                  yac005,
                  iaa100,
                  aae110,
                  aae120,
                  aae210,
                  aae310,
                  aae410,
                  aae510,
                  aae311
            FROM wsjb.irac01
           WHERE AAB001 = prm_aab001
             AND AAC001 = v_aac001
             AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
             AND iaa100 >= to_number(prm_aae001||'01')
             ORDER BY IAA100;

    BEGIN
      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;
      n_count1     :=0;
      n_count2     :=0;
      n_yac506     :=0;
      n_yac507     :=0;
      n_yac508     :=0;
      n_yac005     :=0;
      v_aae110 := '';
      v_aae210 := '';
      v_aae310 := '';
      v_aae410 := '';
      v_aae510 := '';
      v_aae311 := '';
      /*��Ҫ������У��*/
      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '��λ��Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_ErrorMsg := '������Ա��Ų���Ϊ��!';
         RETURN;
      END IF;

      FOR rec_aac001 in cur_aac001 LOOP
        v_yac503 := '0';
        n_count  :=0;
        n_count1 :=0;
        n_count2 :=0;
        n_yac506 :=0;
        n_yac507 :=0;
        n_yac508 :=0;
        n_yac005 :=0;
        v_aae110 := '';
        v_aae210 := '';
        v_aae310 := '';
        v_aae410 := '';
        v_aae510 := '';
        v_aae311 := '';
        v_yae310 := '';
        v_yae110 := '';
        v_yae210 := '';
        v_yae410 := '';
        v_yae510 := '';

        SELECT aac001,aac002,aac003,aac009
          INTO v_aac001,v_aac002,v_aac003,v_aac009
          FROM xasi2.ac01
         WHERE aac001 = rec_aac001.aac001;

        FOR rec_aae310 IN cur_aae310 LOOP
            --ֻ��ʾ�������ϱ��յ������Ϣ
            /*
             IF rec_aae310.aae310 IN ('1','10') THEN
               v_yae310 := v_yae310||substr(rec_aae310.iaa100,5)||'����/';
             END IF;
             IF rec_aae310.aae310 = '3' THEN
               v_yae310 := v_yae310||substr(rec_aae310.iaa100,5)||'�¼�/';
               v_aae310 := '21';
             END IF;

             IF rec_aae310.aae210 IN ('1','10') THEN
               v_yae210 := v_yae210||substr(rec_aae310.iaa100,5)||'����/';
             END IF;
             IF rec_aae310.aae210 = '3' THEN
               v_yae210 := v_yae210||substr(rec_aae310.iaa100,5)||'�¼�/';
               v_aae210 := '21';
             END IF;

             IF rec_aae310.aae410 IN ('1','10') THEN
               v_yae410 := v_yae410||substr(rec_aae310.iaa100,5)||'����/';
             END IF;
             IF rec_aae310.aae410 = '3' THEN
               v_yae410 := v_yae410||substr(rec_aae310.iaa100,5)||'�¼�/';
               v_aae410 := '21';
             END IF;

             IF rec_aae310.aae510 IN ('1','10') THEN
               v_yae510 := v_yae510||substr(rec_aae310.iaa100,5)||'����/';
             END IF;
             IF rec_aae310.aae510 = '3' THEN
               v_yae510 := v_yae510||substr(rec_aae310.iaa100,5)||'�¼�/';
               v_aae510 := '21';
             END IF;

             IF rec_aae310.aae311 = '3' THEN
               v_aae311 := '21';
             END IF;

             IF rec_aae310.iaa001 = '9' AND rec_aae310.aae310 = '2' AND rec_aae310.aae510 = '3' AND rec_aae310.aae311 = '2'THEN
               v_yae310 := v_yae310||substr(rec_aae310.iaa100,5)||'�´���/';
               v_aae310 := '21';
             END IF;
             */
             IF rec_aae310.aae120 IN ('1','10') THEN
               v_yae110 := v_yae110||substr(rec_aae310.iaa100,5)||'����/';
             END IF;
             IF rec_aae310.aae120 = '3' THEN
               v_yae110 := v_yae110||substr(rec_aae310.iaa100,5)||'�¼�/';
               v_aae110 := '21';
             END IF;
           END LOOP;
      --ֻ��ȡ�������ϵĻ���
     /*
      --�ж��Ƿ��ҽ�Ƽ�¼
        SELECT count(1)
          INTO n_count
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND aae140 = '03';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '03';
        SELECT count(1)
          INTO n_count2
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 IN ('2','3')
           AND aae140 = '03';
         IF n_count1 > 0 THEN
          v_aae310 := '2';
          SELECT aac040,yac004,yac503
            INTO n_yac506,n_yac508,v_yac503
            FROM AC02
           WHERE AAB001 = prm_aab001
             AND AAC001 = v_aac001
             AND aac031 = '1'
             AND aae140 = '03';
         END IF;
         IF n_count2 > 0 THEN
          SELECT aac040,yac004,yac503
            INTO n_yac506,n_yac508,v_yac503
            FROM AC02
           WHERE AAB001 = prm_aab001
             AND AAC001 = v_aac001
             AND aac031 IN ('2','3')
             AND aae140 = '03';
         END IF;

       ELSE
           select COUNT(1)
             INTO n_count
              from irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
         IF n_count > 0 THEN
           select aac040,
                   yac005
              into n_yac506,
                   n_yac508
              from irac01
             where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
              AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from irac01
                              WHERE AAB001 = prm_aab001
                                AND AAC001 = v_aac001
                                AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                AND iaa002 = '2'
                                AND iaa100 >= to_number(prm_aae001||'01'));

           -- SELECT yac503 INTO v_yac503 FROM ac02 WHERE aac001 = v_aac001 and aae140 = '03';
         END IF;
       END IF;


        --�ж��Ƿ��ʧҵ��¼
        SELECT count(1)
          INTO n_count
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = rec_aac001.aac001
           AND aae140 = '02';
       IF n_count > 0 THEN --ac02�вα���¼
       --�Ƿ�Ϊ�α�״̬
         SELECT count(1)
          INTO n_count1
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = rec_aac001.aac001
           AND AAC031 = '1'
           AND aae140 = '02';
        SELECT count(1)
          INTO n_count2
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = rec_aac001.aac001
           AND AAC031 = '2'
           AND aae140 = '02';

         IF n_count1 > 0 THEN--�α�
          v_aae210 := '2';
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac508,v_yac503
              FROM AC02
             WHERE AAB001 = prm_aab001
               AND AAC001 = rec_aac001.aac001
               AND aac031 = '1'
               AND aae140 = '02';
          ELSE
           SELECT count(1)
             INTO n_count1
             FROM AC02
            WHERE AAB001 = prm_aab001
              AND AAC001 = rec_aac001.aac001
              AND AAC031 = '2'
              AND aae140 = '03';
            IF n_count1 > 0 THEN
              SELECT aac040,yac004,yac503
                INTO n_yac506,n_yac508,v_yac503
                FROM AC02
               WHERE AAB001 = prm_aab001
                 AND AAC001 = rec_aac001.aac001
                 AND aac031 = '1'
                 AND aae140 = '02';
            END IF;

          END IF;
         END IF;
         IF n_count2 > 0 THEN --ͣ��
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac508,v_yac503
              FROM AC02
             WHERE AAB001 = prm_aab001
               AND AAC001 = rec_aac001.aac001
               AND aac031 = '2'
               AND aae140 = '02';
          END IF;
         END IF;

       ELSE
          select COUNT(1)
             INTO n_count
              from irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
        IF n_count > 0 THEN
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
                select aac040,
                       yac005
                  into n_yac506,
                       n_yac508
                  from irac01
                 where aab001 = prm_aab001
                   and aac001 = v_aac001
                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                 AND iaa002 = '2'
                   and iaa100 = (select max(iaa100) from irac01
                                    WHERE AAB001 = prm_aab001
                                   AND AAC001 = v_aac001
                                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                   AND iaa002 = '2'
                                   AND iaa100 >= to_number(prm_aae001||'01'));
            --   SELECT yac503 INTO v_yac503 FROM ac02 WHERE aac001 = v_aac001 and aae140 = '02';
           END IF;
        END IF;
       END IF;

       --�ж��Ƿ�ι��˼�¼
        SELECT count(1)
          INTO n_count
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND aae140 = '04';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '04';
        SELECT count(1)
          INTO n_count2
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '2'
           AND aae140 = '04';
         IF n_count1 > 0 THEN
          v_aae410 := '2';
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac508,v_yac503
              FROM AC02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '1'
               AND aae140 = '04';
               n_yac005 := n_yac508;
          ELSE
           SELECT count(1)
             INTO n_count1
             FROM AC02
            WHERE AAB001 = prm_aab001
              AND AAC001 = rec_aac001.aac001
              AND AAC031 = '2'
              AND aae140 = '02';
            IF n_count1 > 0 THEN
              SELECT aac040,yac004,yac503
                INTO n_yac506,n_yac508,v_yac503
                FROM AC02
               WHERE AAB001 = prm_aab001
                 AND AAC001 = rec_aac001.aac001
                 AND aac031 = '1'
                 AND aae140 = '04';
            END IF;
            SELECT yac004
              INTO n_yac005
              FROM AC02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '1'
               AND aae140 = '04';
          END IF;

         END IF;
         IF n_count2 > 0 THEN
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac508,v_yac503
              FROM AC02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '2'
               AND aae140 = '04';
               n_yac005 := n_yac508;
          ELSE
            SELECT yac004
              INTO n_yac005
              FROM AC02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '2'
               AND aae140 = '04';
          END IF;
         END IF;

       ELSE
         select COUNT(1)
             INTO n_count
              from irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
        IF n_count > 0 THEN
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
              select aac040,
                     yac005
                into n_yac506,
                     n_yac508
                from irac01
               where aab001 = prm_aab001
                 and aac001 = v_aac001
                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
               AND iaa002 = '2'
                 and iaa100 = (select max(iaa100) from irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
              -- SELECT yac503 INTO v_yac503 FROM ac02 WHERE aac001 = v_aac001 and aae140 = '04';
               n_yac005 := n_yac508;
          ELSE
            n_yac005 := n_yac508;
          END IF;
         END IF;
       END IF;

       --�ж��Ƿ��������¼
        SELECT count(1)
          INTO n_count
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND aae140 = '05';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '05';
        SELECT count(1)
          INTO n_count2
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '2'
           AND aae140 = '05';
         IF n_count1 > 0 THEN
          v_aae510 := '2';
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac508,v_yac503
              FROM AC02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '1'
               AND aae140 = '05';
          END IF;

         END IF;
         IF n_count2 > 0 THEN
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac508,v_yac503
              FROM AC02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '2'
               AND aae140 = '05';
          END IF;
         END IF;
       ELSE
         select COUNT(1)
             INTO n_count
              from irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
         IF n_count > 0 THEN
             IF n_yac506 = 0 AND n_yac508 = 0 THEN
                select aac040,
                       yac005
                  into n_yac506,
                       n_yac508
                  from irac01
                 where aab001 = prm_aab001
                   and aac001 = v_aac001
                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                 AND iaa002 = '2'
                   and iaa100 = (select max(iaa100) from irac01
                                    WHERE AAB001 = prm_aab001
                                   AND AAC001 = v_aac001
                                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                   AND iaa002 = '2'
                                   AND iaa100 >= to_number(prm_aae001||'01'));
               --  SELECT yac503 INTO v_yac503 FROM ac02 WHERE aac001 = v_aac001 and aae140 = '04';
             END IF;
          END IF;
       END IF;

        --�ж��Ƿ�δ���¼
        SELECT count(1)
          INTO n_count
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND aae140 = '07';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '07';
        SELECT count(1)
          INTO n_count2
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '2'
           AND aae140 = '07';
         IF n_count1 > 0 THEN
          v_aae311 := '2';

         END IF;
       END IF;
       */
        --�ж��Ƿ�λ������ϼ�¼
       SELECT count(1)
          INTO n_count
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAE140 = '06';
      IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '06';
        SELECT count(1)
          INTO n_count2
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '2'
           AND aae140 = '06';
         IF n_count1 > 0 THEN
          v_aae110 := '2';
          IF n_yac507 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac507,v_yac503
              FROM xasi2.ac02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '1'
               AND aae140 = '06';
          END IF;

         END IF;
         IF n_count2 > 0 THEN
          IF n_yac507 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac507,v_yac503
              FROM xasi2.ac02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '2'
               AND aae140 = '06';
          END IF;
         END IF;
       ELSE
         select COUNT(1)
             INTO n_count
              from wsjb.irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
         IF n_count > 0 THEN
             IF n_yac507 = 0 THEN
                SELECT yac004
                  INTO n_yac507
                  FROM wsjb.irac01
                 WHERE aab001 = prm_aab001
                   AND aac001 = v_aac001
                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                 AND iaa002 = '2'
                   AND iaa100 = (select max(iaa100) from wsjb.irac01
                                    WHERE AAB001 = prm_aab001
                                   AND AAC001 = v_aac001
                                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                   AND iaa002 = '2'
                                   AND iaa100 >= to_number(prm_aae001||'01'));
               n_yac506 := n_yac507;
               --  SELECT yac503 INTO v_yac503 FROM ac02 WHERE aac001 = v_aac001 and aae140 = '04';
             END IF;
          END IF;
       END IF;


       IF n_yac506 IS NULL THEN
           n_yac506 := 0;
       END IF;
       IF n_yac507 IS NULL THEN
           n_yac507 := 0;
       END IF;
       IF n_yac508 IS NULL THEN
           n_yac508 := 0;
       END IF;

       INSERT INTO xasi2.ac01k8 (
                                    aac001,
                                    aab001,
                                    aac002,
                                    aac003,
                                    aac009,
                                    yac506,
                                    yac507,
                                    yac508,
                                    aae110,
                                    aae210,
                                    aae310,
                                    aae410,
                                    aae510,
                                    aae311,
                                    aae001,
                                    yac503,
                                    yac005,
                                    yae092,
                                    iaa002,
                                    yae110,
                                    yae310,
                                    yae210,
                                    yae410,
                                    yae510,
                                    yab019,
                                    aae034
                                    )VALUES(
                                    v_aac001,
                                    prm_aab001,
                                    v_aac002,
                                    v_aac003,
                                    v_aac009,
                                    n_yac506,
                                    n_yac507,
                                    n_yac508,
                                    v_aae110,
                                    v_aae210,
                                    v_aae310,
                                    v_aae410,
                                    v_aae510,
                                    v_aae311,
                                    prm_aae001,
                                    v_yac503,
                                    n_yac005,
                                    prm_yae092,
                                    '0' ,
                                    v_yae110,
                                    v_yae310,
                                    v_yae210,
                                    v_yae410,
                                    v_yae510,
                                    '2',
                                    SYSDATE
                                    );
      END LOOP;

   EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;

   END prc_JGqueryjishu;

   /*****************************************************************************
   ** �������� : prc_YearInternetApply
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ������λ�걨
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--������
                 prm_aae001       IN     NUMBER(4),--�걨���
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2013-05-25   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
      PROCEDURE prc_YearInternetApply(
        prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
        prm_yae092       IN     iraa01a1.aae011%TYPE,--������
        prm_aae001       IN     NUMBER,--�걨���
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             )
    IS
      n_count number(6);
      n_aaa010 NUMBER(8);
      v_iaz004 irad02.iaz004%TYPE;
      v_aaz002 iraa01a1.aaz002%TYPE;
      v_iaz051 VARCHAR2(200);
      n_zcgz NUMBER(14,2);--��������
      n_bagz NUMBER(14,2);--��������
      num_yae097 NUMBER(8);
   cursor cur_a IS SELECT DISTINCT aac002
                     FROM wsjb.irac01c1
                    WHERE aab001=prm_aab001
                      AND SUBSTR(iaa100,1,4) = prm_aae001
                      AND yae031 = '1';
    BEGIN
     FOR rec_a IN cur_a LOOP
       SELECT count(1)
         INTO n_count
         FROM xasi2.ac01k8
        WHERE aac002 = rec_a.aac002
          AND aae001 = prm_aae001
          AND aab001 = prm_aab001;
      IF n_count > 1 THEN
       SELECT aac040
         INTO n_zcgz
         FROM xasi2.ac01k8
        WHERE aae001 = prm_aae001
          AND aab001 = prm_aab001
          AND aac002 = rec_a.aac002
          AND aae110 NOT IN ('����');
       SELECT aac040
         INTO n_bagz
         FROM xasi2.ac01k8
        WHERE aae001 = prm_aae001
          AND aab001 = prm_aab001
          AND aac002 = rec_a.aac002
          AND aae110  IN ('����');
        IF  n_zcgz <>  n_bagz THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '���֤����Ϊ!'||rec_a.aac002||'����Ա,�����������뱸�������ʲ�һ�£����飡';
         RETURN;
        END IF;
       END IF;
       END LOOP;
      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;

       /*��Ҫ������У��*/
      IF prm_aab001 IS NULL THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '��λ��Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '������Ա��Ų���Ϊ��!';
         RETURN;
      END IF;
      SELECT count(1)
        INTO n_count
        FROM (SELECT DISTINCT AAC001
                FROM xasi2.ac08 A
               WHERE EXISTS (SELECT 1
                        FROM xasi2.AB08A8
                       WHERE AAB001 = prm_aab001
                         AND AAE041 >= to_number(prm_aae001||'01')
                         AND YAE518 = A.YAE518)
                 AND AAC008 = '1'
                 AND AAB001 = prm_aab001
              UNION
              SELECT DISTINCT AAC001
                FROM xasi2.AC08A1 A
               WHERE EXISTS (SELECT 1
                        FROM xasi2.AB08
                       WHERE AAB001 = prm_aab001
                         AND AAE041 >= to_number(prm_aae001||'01')
                         AND YAE518 = A.YAE518)
                 AND AAC008 = '1'
                 AND AAB001 = prm_aab001
               UNION
               SELECT DISTINCT AAC001
                FROM xasi2.AC08A3 A
               WHERE EXISTS (SELECT 1
                        FROM xasi2.AB08A8
                       WHERE AAB001 = prm_aab001
                         AND AAE041 >= to_number(prm_aae001||'01')
                         AND YAE518 = A.YAE518)
                 AND AAC008 = '1'
                 AND AAB001 = prm_aab001);
     IF n_count <> 0 THEN
        SELECT count(1)
        INTO n_count
        FROM xasi2.ac01k8
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND yab019 = '1';
      IF n_count = 0 THEN
        prm_AppCode  := gn_def_ERR;
        prm_ErrorMsg := 'û���걨��Ա��¼��������ȷ�Ϻ��ύ��';
        RETURN;
      END IF;
     END IF;
      SELECT count(1)
        INTO n_count
        FROM xasi2.ac01k8
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND (aac040 is null OR aac040 = 0)
         AND yab019 = '1';
      IF n_count > 0 THEN
        prm_AppCode  := gn_def_ERR;
        prm_ErrorMsg := '�����걨����Ϊ0��յ���Ա��������ȷ�Ϻ��ύ��';
        RETURN;
      END IF;
      SELECT aaa010
        INTO n_aaa010  --ʡ��͹��ʱ�׼
        FROM xasi2.aa02a1
       WHERE yaa001 = '13'
         AND aae001 = prm_aae001;
       SELECT count(1)
        INTO n_count
        FROM xasi2.ac01k8
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND yab019 = '1'
         AND aac040 < n_aaa010;
      IF n_count > 0 THEN
        prm_ErrorMsg := '�����걨����С��'||n_aaa010||'����Ա��������ʡ��͹��ʱ�׼��������ȷ�Ϻ��ύ��';
        RETURN;
      END IF;

       SELECT count(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A05'
         AND iaa002 = '1'
         AND aae001 = prm_aae001;
      IF n_count > 0 THEN
        prm_ErrorMsg := '�Ѵ��ڵ�λ���Ϊ'||prm_aab001||'��'||to_char(prm_aae001)||'������걨��¼!';
        RETURN;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
         IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'û�л�ȡ�����к�AAZ002!';
            RETURN;
         END IF;
      v_iaz051 := PKG_COMMON.fun_cbbh('JSSB',PKG_Constant.YAB003_JBFZX);
         IF v_iaz051 IS NULL OR v_iaz051 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'û�л�ȡ���������!';
            RETURN;
         END IF;

      -- ���걨����
      prc_YearSalaryAdjustPaded(prm_aab001  ,--��λ���  ����
                                ''  ,--���˱��  �Ǳ���
                                0  , --���� �Ǳ���
                                prm_aae001  ,--�������
                                prm_yae092  ,--������
                                PKG_Constant.YAB003_JBFZX  ,--�α�����������
                                '1',  --ҵ�����ͱ�־ 1-һ����ҵ��2-������������
                                prm_AppCode ,
                                prm_ErrorMsg );
      IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
         RETURN;
      END IF;


      SELECT count(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A05'
         AND iaa002 = '3'
         AND iaa006 = '0'
         AND aae001 = prm_aae001;
     IF n_count > 0 THEN
       UPDATE wsjb.irad51
          SET iaa002 = '1',
              iaz051 = v_iaz051
        WHERE aab001 = prm_aab001
         AND iaa011 = 'A05'
         AND iaa002 = '3'
         AND iaa006 = '0'
         AND aae001 = prm_aae001;

      UPDATE xasi2.ac01k8
          SET iaa002 = '1',
              aae035 = sysdate
        WHERE aab001 = prm_aab001
          AND iaa002 = '3'
          AND aae001 = prm_aae001
          AND yab019 = '1';
     ELSE
       v_iaz004 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ004');
         IF v_iaz004 IS NULL OR v_iaz004 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'û�л�ȡ�����к�IAZ004!';
            RETURN;
         END IF;

          SELECT MAX(yae097)
       INTO num_yae097
       FROM (SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(yae097),'yyyymm'),1),'yyyymm')) AS yae097   --��ȡ�����ں�
               FROM xasi2.ab02
              WHERE aab001 = prm_aab001
              UNION
             SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(aae003),'yyyymm'),1),'yyyymm')) AS yae097
               FROM wsjb.irab08
              WHERE aab001 = prm_aab001
                AND yae517 = 'H01'  );

       INSERT INTO wsjb.irad51  (
                          iaz004,
                          aaz002,
                          iaa011,
                          aae011,
                          aae035,
                          aab001,
                          yab003,
                          iaa002,
                          iaa006,
                          aae001,
                          iaz051,
                          aae003
                          )VALUES(
                          v_iaz004,
                          v_aaz002,
                          'A05',
                          prm_yae092,
                          sysdate,
                          prm_aab001,
                          PKG_Constant.YAB003_JBFZX,
                          '1',
                          '0',
                          prm_aae001,
                          v_iaz051,
                          num_yae097
                          );



       UPDATE xasi2.ac01k8
          SET
              iaz004 = v_iaz004,
              iaa002 = '1',
              aae035 = sysdate
        WHERE aab001 = prm_aab001
          AND iaa002 = '0'
          AND aae001 = prm_aae001
          AND yab019 = '1';
     END IF;



      --��־��¼
      INSERT INTO wsjb.AE02
                 (
                  AAZ002,
                  AAA121,
                  AAE011,
                  YAB003,
                  AAE014,
                  AAE016,
                  AAE216,
                  AAE217,
                  AAE218
                 )
                 VALUES
                 (
                  v_aaz002,
                  PKG_Constant.AAA121_YIR,
                  prm_yae092,
                  PKG_Constant.YAB003_JBFZX,
                  prm_yae092,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate
                 );

          -- ��������仯����
          prc_YearApplyJSProportions (prm_aab001,--��λ���
                       prm_aae001,--�������
                       prm_yae092, --������
                       prm_AppCode,
                       prm_ErrorMsg);


   EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END prc_YearInternetApply;

   /*****************************************************************************
   ** �������� : prc_JGYearInternetApply
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ������λ�걨(������������)
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--������
                 prm_aae001       IN     NUMBER(4),--�걨���
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2013-05-25   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_JGYearInternetApply(
        prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
        prm_yae092       IN     iraa01a1.aae011%TYPE,--������
        prm_aae001       IN     NUMBER,--�걨���
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             )
    IS
       n_count number(6);
      n_aaa010 NUMBER(8);
      v_iaz004 irad02.iaz004%TYPE;
      v_aaz002 irad01.aaz002%TYPE;
      v_iaz051 irad51.iaz051%TYPE;
    BEGIN
      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;

       /*��Ҫ������У��*/
      IF prm_aab001 IS NULL THEN

         prm_ErrorMsg := '��λ��Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN

         prm_ErrorMsg := '������Ա��Ų���Ϊ��!';
         RETURN;
      END IF;

      SELECT count(1)
        INTO n_count
        FROM xasi2.ac01k8
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND yab019 = '2'; --�����������ֻ����걨
      IF n_count = 0 THEN
        prm_ErrorMsg := 'û���걨��Ա��¼��������ȷ�Ϻ��ύ��';
        RETURN;
      END IF;

      SELECT count(1)
        INTO n_count
        FROM xasi2.ac01k8
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND (aac040 is null OR aac040 = 0)
         AND yab019 = '2';
      IF n_count > 0 THEN
        prm_ErrorMsg := '�����걨����Ϊ0��յ���Ա��������ȷ�Ϻ��ύ��';
        RETURN;
      END IF;


       SELECT count(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A16'  --�������ϻ����걨
         AND iaa002 = '1'
         AND aae001 = prm_aae001;
      IF n_count > 0 THEN
        prm_ErrorMsg := '�Ѵ��ڵ�λ���Ϊ'||prm_aab001||'��'||to_char(prm_aae001)||'������걨��¼!';
        RETURN;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
         IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'û�л�ȡ�����к�AAZ002!';
            RETURN;
         END IF;
      v_iaz051 := PKG_COMMON.fun_cbbh('JSSB',PKG_Constant.YAB003_JBFZX);
         IF v_iaz051 IS NULL OR v_iaz051 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'û�л�ȡ���������!';
            RETURN;
         END IF;
      prc_YearSalaryAdjustPaded(prm_aab001  ,--��λ���  ����
                                ''  ,--���˱��  �Ǳ���
                                0  , --���� �Ǳ���
                                prm_aae001  ,--�������
                                prm_yae092  ,--������
                                PKG_Constant.YAB003_JBFZX  ,--�α�����������
                                '2',  --ҵ�����ͱ�־ 1-һ����ҵ��2-������������
                                prm_AppCode ,
                                prm_ErrorMsg );
      IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
         RETURN;
      END IF;


      SELECT count(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A16'
         AND iaa002 = '3'
         AND iaa006 = '0'
         AND aae001 = prm_aae001;
     IF n_count > 0 THEN
       UPDATE wsjb.irad51
          SET iaa002 = '1',
              iaz051 = v_iaz051
        WHERE aab001 = prm_aab001
         AND iaa011 = 'A16'
         AND iaa002 = '3'
         AND iaa006 = '0'
         AND aae001 = prm_aae001;

      UPDATE xasi2.ac01k8
          SET iaa002 = '1',
              aae035 = sysdate
        WHERE aab001 = prm_aab001
          AND iaa002 = '3'
          AND aae001 = prm_aae001
          AND yab019 = '2';
     ELSE
       v_iaz004 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ004');
         IF v_iaz004 IS NULL OR v_iaz004 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'û�л�ȡ�����к�IAZ004!';
            RETURN;
         END IF;
       INSERT INTO wsjb.irad51  (
                          iaz004,
                          aaz002,
                          iaa011,
                          aae011,
                          aae035,
                          aab001,
                          yab003,
                          iaa002,
                          iaa006,
                          aae001,
                          iaz051
                          )VALUES(
                          v_iaz004,
                          v_aaz002,
                          'A16',
                          prm_yae092,
                          sysdate,
                          prm_aab001,
                          PKG_Constant.YAB003_JBFZX,
                          '1',
                          '0',
                          prm_aae001,
                          v_iaz051
                          );
       UPDATE xasi2.ac01k8
          SET iaz004 = v_iaz004,
              iaa002 = '1',
              aae035 = sysdate
        WHERE aab001 = prm_aab001
          AND iaa002 = '0'
          AND aae001 = prm_aae001
          AND yab019 = '2';
     END IF;



      --��־��¼
      INSERT INTO wsjb.AE02
                 (
                  AAZ002,
                  AAA121,
                  AAE011,
                  YAB003,
                  AAE014,
                  AAE016,
                  AAE216,
                  AAE217,
                  AAE218
                 )
                 VALUES
                 (
                  v_aaz002,
                  PKG_Constant.AAA121_YIR,
                  prm_yae092,
                  'A16',
                  prm_yae092,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate
                 );


   EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
         RETURN;
   END prc_JGYearInternetApply;

   /*****************************************************************************
   ** �������� : prc_RBYearInternetApply
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����������λ�걨
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--������
                 prm_aae001       IN     NUMBER(4),--�걨���
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2013-05-25   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_RBYearInternetApply(
        prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
        prm_yae092       IN     iraa01a1.aae011%TYPE,--������
        prm_aae001       IN     NUMBER,--�걨���
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             )
     IS
         n_count NUMBER(6);
        v_iaz004 irad02.iaz004%TYPE;
     BEGIN
      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;

       /*��Ҫ������У��*/
      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '��λ��Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_ErrorMsg := '������Ա��Ų���Ϊ��!';
         RETURN;
      END IF;

      SELECT count(1)
        INTO n_count
        FROM xasi2.ac01k8
       WHERE aab001 = prm_aab001
         AND IAA002 <> '0'
         AND IAA002<>'1'
         AND aae001 = prm_aae001
         AND yab019 = '1';
      IF n_count > 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '�Ѵ�����˵����ݣ����ܳ�������!';
         RETURN;
      END IF;

      SELECT count(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A05'
         AND aae001 = prm_aae001;
      IF n_count = 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := 'û���걨��Ϣ�����ܳ�����!';
         RETURN;
      END IF;
      --������ˮ��
      SELECT iaz004
        INTO v_iaz004
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A05'
         AND aae001 = prm_aae001;
      --����Ƿ�������ԤԼ������Ϣ
      SELECT count(1)
        INTO n_count
        FROM wsjb.iraa16
       WHERE iaz004 = v_iaz004
         AND aaa170 = '0'
         AND aae120 = '0';
      IF n_count > 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '�����걨������ҵ��ԤԼ��Ϣ�����ܳ��������Ƚ�����ҵ��ԤԼ��Ϣ������';
         RETURN;
      END IF;

      DELETE wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A05'
         AND aae001 = prm_aae001;

      UPDATE xasi2.ac01k8
         SET iaz004 = '',
             iaa002 = '0'
       WHERE aab001 = prm_aab001
         AND iaa002 = '1'
         AND aae001 = prm_aae001
         AND yab019 = '1';

      --modify by fenggg at 20181208 begin
      --���������걨ʱͬʱɾ��tmp_ac42
      DELETE wsjb.tmp_ac42
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001;
     --modify by fenggg at 20181208 end

     --modify by whm at 20190812start
     --���������걨��ͬʱɾ��irad54�л������͵ļ�¼
     DELETE wsjb.irad54
       WHERE iaa011 ='A05-1'
         AND aab001 = prm_aab001
         AND aae001 = prm_aae001;
     --modify by whm at 20190812end

      EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
         RETURN;
   END prc_RBYearInternetApply;

 /*****************************************************************************
   ** �������� : prc_RBJGYearInternetApply
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����������λ�걨(������������)
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--������
                 prm_aae001       IN     NUMBER(4),--�걨���
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2013-05-25   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_RBJGYearInternetApply(
        prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
        prm_yae092       IN     iraa01a1.aae011%TYPE,--������
        prm_aae001       IN     NUMBER,--�걨���
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             )
     IS
        n_count NUMBER(6);
     BEGIN
      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;

       /*��Ҫ������У��*/
      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '��λ��Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_ErrorMsg := '������Ա��Ų���Ϊ��!';
         RETURN;
      END IF;

      SELECT count(1)
        INTO n_count
        FROM xasi2.ac01k8
       WHERE aab001 = prm_aab001
         AND IAA002 <> '0'
         AND IAA002<>'1'
         AND aae001 = prm_aae001
         AND yab019 = '2';
      IF n_count > 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '�Ѵ�����˵����ݣ����ܳ�������!';
         RETURN;
      END IF;

      SELECT count(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A16'
         AND aae001 = prm_aae001;
      IF n_count = 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := 'û���걨��Ϣ�����ܳ�����!';
         RETURN;
      END IF;

      DELETE wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A16'
         AND aae001 = prm_aae001;

      UPDATE xasi2.ac01k8
         SET iaz004 = '',
             iaa002 = '0'
       WHERE aab001 = prm_aab001
         AND iaa002 = '1'
         AND aae001 = prm_aae001
         AND yab019 = '2';

      EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
         RETURN;
   END prc_RBJGYearInternetApply;
/*****************************************************************************
   ** �������� : prc_YearSalary
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���--�޸Ĺ���
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ���
   **           prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
   **           prm_aae011       IN     irad31.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-09   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
PROCEDURE prc_YearSalary(prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                         prm_aae001       IN     NUMBER            ,--�������
                         prm_aae011       IN     irad31.aae011%TYPE,--������
                         prm_yab139       IN     VARCHAR2          ,--�α�����������
                         prm_yab019       IN     VARCHAR2 , --���ͱ�־ 1--��ҵ�����걨 2--�������ϻ����걨
                         prm_AppCode      OUT    VARCHAR2          ,
                         prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      num_count     NUMBER;
      v_msg        VARCHAR2(300);
      var_aaz002   irad31.aaz002%TYPE;
      num_aae041_year NUMBER(6);  --���ʼʱ��
      num_yae097   xasi2.ab02.yae097%TYPE; --��λ��������ں�
      var_aae140   xasi2.ab02.aae140%TYPE; --����
      var_aac001   xasi2.ac01.aac001%TYPE; --���˱��
      num_aae002   xasi2.ac08a1.aae002%TYPE;
      num_aac040   xasi2.ac02.aac040%TYPE;
      num_spgz     xasi2.ac02.aac040%TYPE;
      num_yac004   xasi2.ac02.yac004%TYPE;
      var_yab136   xasi2.ab01.yab136%TYPE;
      var_yab275   xasi2.ab01.yab275%TYPE;
      var_aae119   xasi2.ab01.aae119%TYPE;
      var_aab019   xasi2.ab01.aab019%TYPE;
      var_yac503   xasi2.ac02.yac503%TYPE;
      var_yac505   xasi2.ac02.yac505%TYPE;
      num_yac401   tmp_ac42.yac401%type;           --1�²�����,NUMBER
      num_yac402   tmp_ac42.yac401%type;           --2�²�����,NUMBER
      num_yac403   tmp_ac42.yac401%type;           --3�²�����,NUMBER
      num_yac404   tmp_ac42.yac401%type;           --4�²�����,NUMBER
      num_yac405   tmp_ac42.yac401%type;           --5�²�����,NUMBER
      num_yac406   tmp_ac42.yac401%type;           --6�²�����,NUMBER
      num_yac407   tmp_ac42.yac401%type;           --7�²�����,NUMBER
      num_yac408   tmp_ac42.yac401%type;           --8�²�����,NUMBER
      num_yac409   tmp_ac42.yac401%type;           --9�²�����,NUMBER
      num_yac410   tmp_ac42.yac401%type;           --10�²�����,NUMBER
      num_yac411   tmp_ac42.yac401%type;           --11�²�����,NUMBER
      num_yac412   tmp_ac42.yac401%type;           --12�²�����,NUMBER
      var_procNo   VARCHAR2(5);                    --���̺�
      var_aae013   xasi2.ab08a8.aae013%TYPE;
      var_aae100   VARCHAR2(9);
      var_yae099   xasi2.ac04a3.yae099%TYPE;
      num_aic162   NUMBER(6);
      num_yac004_new xasi2.ac02.yac004%TYPE;
      num_yaa333_new xasi2.ac02.yaa333%TYPE;
      --��ȡ��λ�ύ���걨��Ա
      CURSOR cur_ab05a1 IS
        SELECT aac001,
               aab001,
               yac506,
               yac507,
               yac508,
               yac503,--�������
               aac040,--�����ɷѹ���
               yac004,--��������Ͻɷѻ���
               yaa333,--�����ɷѻ���
               yac005 --���˽ɷѹ���
          FROM xasi2.ac01k8
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND yab019 = prm_yab019;
      --��ȡ��Ա�Ĳα���Ϣ
      CURSOR cur_ac02 IS
        SELECT aae140,
               yac503,   --�������
               yac505,   --�ɷ���Ա���
               aac040,
               yac004,
               yaa333
          FROM xasi2.ac02
         WHERE aac001 = var_aac001
           AND aab001 = prm_aab001
           AND aae140 NOT IN (xasi2.pkg_comm.AAE140_DEYL,'06')    --�����в���
           AND prm_yab019 = '1'
       UNION
        SELECT aae140,
               yac503,   --�������
               yac505,   --�ɷ���Ա���
               aac040,
               yac004,
               yaa333
          FROM xasi2.ac02
         WHERE aac001 = var_aac001
           AND aab001 = prm_aab001
           AND aae140 = '06'    --��������
          AND prm_yab019 = '2';

   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      var_procNo   :='Y01';
      var_yae099   := xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAE099');
      --��ȡ��λ��ǰ�Ĺ�������
      BEGIN
         SELECT yab136,
                yab275,
                aae119,
                aab019
           INTO var_yab136,
                var_yab275,
                var_aae119,
                var_aab019
           FROM xasi2.ab01
          WHERE aab001 = prm_aab001;
      EXCEPTION
         WHEN OTHERS THEN
            prm_AppCode := ''||var_procNo||'02';
            prm_ErrorMsg  := '��λ����'||prm_aab001||'�籣�������'||prm_yab139||'û�л�ȡ����λ������Ϣ';
            RETURN;
      END;

      --ҽ�����յ����걨
      FOR rec_ab05a1 IN cur_ab05a1 LOOP

          --��ȡ����ʼ�ں�  ȡ��λ��������ں�����
          SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(yae097),'yyyymm'),1),'yyyymm'))   --��ȡ�����ں�
            INTO num_aae002
            FROM xasi2.ab02
           WHERE aab001 = prm_aab001;

          var_aac001 := rec_ab05a1.aac001;
          num_aac040 := TRUNC(rec_ab05a1.aac040);
          num_yac004_new := TRUNC(rec_ab05a1.yac004);--�����ϻ���
          num_yaa333_new := TRUNC(rec_ab05a1.yaa333);--����������
          --�����������Ա�����»���
          SELECT count(1)
            INTO num_count
            FROM xasi2.kc01
           WHERE aac001 = rec_ab05a1.aac001
             AND akc021 = '21';

          IF num_count = 0 THEN
          --������յ�

             FOR rec_ac02 IN cur_ac02 LOOP
                  var_aae140 := rec_ac02.aae140;
                 var_yac503 := rec_ac02.yac503;
                 var_yac505 := rec_ac02.yac505;
                 IF rec_ab05a1.yac508 > 0 OR var_aae140 = '06' THEN

                  --���ñ��׷ⶥ���̣���ȡ�ɷѻ����ͽɷѹ���
                  xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase
                                                         (var_aac001   ,     --���˱���
                                                          prm_aab001   ,     --��λ����
                                                          num_aac040   ,     --�ɷѹ���
                                                          var_yac503   ,     --�������
                                                          var_aae140   ,     --��������
                                                          var_yac505   ,     --�ɷ���Ա���
                                                          var_yab136   ,     --��λ�������ͣ���������ɷ���Ա��
                                                          num_aae002   ,     --�ѿ�������
                                                          prm_yab139   ,     --�α�������
                                                          num_yac004   ,     --�ɷѻ���
                                                          prm_AppCode  ,     --�������
                                                          prm_ErrorMsg );    --��������
                  IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                     RETURN;
                  END IF;
                  --�жϸ��幤�̻�
                 IF var_aab019 = '60' THEN
                   --��ȡ��ƽ����
                   num_spgz := xasi2.pkg_comm.fun_GetAvgSalary(var_aae140,'16',num_aae002,PKG_Constant.YAB003_JBFZX);
                   --�������Ϊ���� �ɷѹ��ʺͽɷѻ���Ϊ��ƽ����
                   IF var_aae140 = xasi2.pkg_comm.AAE140_GS THEN
                      num_yac004 := ROUND(num_spgz/12);
                    ELSE
                      IF num_aac040 > ROUND(num_spgz/12) THEN
                         num_yac004 := ROUND(num_spgz/12);
                      END  IF;
                    END IF;
                 END IF;
               IF var_aae140 = '06' THEN
                   num_aac040 := rec_ab05a1.yac004;
                   num_yac004 := rec_ab05a1.yac004;
               END IF;
                IF var_aae140 = xasi2.pkg_comm.AAE140_JBYL THEN
                             --�������½ɷ���Ա
                             SELECT count(1)
                               INTO num_count
                               FROM xasi2.ac02_zy
                              WHERE aac001 = var_aac001
                                AND aae120 = '0';
                              IF num_count > 0 THEN
                                 SELECT aic162,
                                        yac004
                                   INTO num_aic162,
                                        num_yac004
                                   FROM xasi2.ac02_zy
                                  WHERE aac001 = var_aac001
                                    AND aae120 = '0';
                                 IF SUBSTR(num_aic162,0,4)= prm_aae001 THEN
                                    num_spgz := xasi2.pkg_comm.fun_GetAvgSalary(var_aae140,'16',prm_aae001||'12',PKG_Constant.YAB003_JBFZX);
                                    num_yac004 := ROUND(num_spgz/12);
                                 END IF;
                              END IF;
                          END IF;
               --������Ա�Ĳα���Ϣ
               UPDATE xasi2.ac02
                  SET aac040 = num_aac040,     -- �걨����
                      yac004 = num_yac004,      -- �ɷѻ���
                      yaa333 = 0
                WHERE aac001 = var_aac001
                  AND aae140 = var_aae140
                  AND aab001 = prm_aab001;

               --д���˽ɷѻ��������¼��
               INSERT INTO xasi2.ac04a3(YAE099,             --ҵ����ˮ��,VARCHAR2
                                           AAC001,             --���˱��,VARCHAR2
                                           AAB001,             --��λ���,VARCHAR2
                                           AAE140,             --��������,VARCHAR2
                                           YAC235,             --���ʱ������,VARCHAR2
                                           YAC506,             --���ǰ����,NUMBER
                                           YAC507,             --���ǰ�ɷѻ���,NUMBER
                                           YAC514,             --���ǰ���ʻ�����,NUMBER
                                           AAC040,             --�ɷѹ���,NUMBER
                                           YAC004,             --�ɷѻ���,NUMBER
                                           YAA333,             --�˻�����,NUMBER
                                           AAE002,             --�ѿ�������,NUMBER
                                           AAE013,             --��ע,VARCHAR2
                                           AAE011,             --������,NUMBER
                                           AAE036,             --����ʱ��,DATE
                                           YAB003,             --�籣�������,VARCHAR2
                                           YAB139,             --�α�����������,VARCHAR2
                                           YAC503,             --�������,VARCHAR2
                                           YAC526              --���ǰ�������,VARCHAR2
                                           )
                                   VALUES (var_yae099,             --ҵ����ˮ��,VARCHAR2
                                           var_aac001,             --���˱��,VARCHAR2
                                           prm_aab001,             --��λ���,VARCHAR2
                                           var_aae140,             --��������,VARCHAR2
                                           xasi2.pkg_comm.YAC235_PL,     --���ʱ������,VARCHAR2
                                           rec_ac02.aac040,         --���ǰ����,NUMBER
                                           rec_ac02.yac004,         --���ǰ�ɷѻ���,NUMBER
                                           rec_ac02.YAA333,         --���ǰ���ʻ�����,NUMBER
                                           num_aac040,             --�ɷѹ���,NUMBER
                                           num_yac004,             --�ɷѻ���,NUMBER
                                           num_yac004,             --�˻�����,NUMBER
                                           num_aae002,             --�ѿ�������,NUMBER
                                           '���걨'  ,                 --��ע,VARCHAR2
                                           prm_aae011,             --������,NUMBER
                                           sysdate,             --����ʱ��,DATE
                                           prm_yab139,             --�籣�������,VARCHAR2
                                           prm_yab139,             --�α�����������,VARCHAR2
                                           var_yac503,             --�������,VARCHAR2
                                           var_yac503);            --���ǰ�������,VARCHAR2
                END IF;
             END LOOP;
           END IF;
           --���ϵ�����
           SELECT count(1)
             INTO num_count
             FROM xasi2.ab02
            WHERE aab001 = prm_aab001
              AND aae140 = '06'
              AND aab051 = '1';
           IF rec_ab05a1.yac507 > 0 AND num_count = 0 THEN
              --��ȡ���ϵ�����ʼ�ں�
              SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(aae003),'yyyymm'),1),'yyyymm'))
                INTO num_aae002
                FROM wsjb.irab08
               WHERE aab001 = prm_aab001
                 AND yae517 = xasi2.pkg_comm.yae517_H01;
              --���ñ��׷ⶥ���̣���ȡ�ɷѻ����ͽɷѹ���
              xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase
                                                     (var_aac001   ,     --���˱���
                                                      prm_aab001   ,     --��λ����
                                                      num_aac040   ,     --�ɷѹ���
                                                      '0'   ,     --�������
                                                      '01'   ,     --��������
                                                      '010'   ,     --�ɷ���Ա���
                                                      var_yab136   ,     --��λ�������ͣ���������ɷ���Ա��
                                                      num_aae002   ,     --�ѿ�������
                                                      prm_yab139   ,     --�α�������
                                                      num_yac004   ,     --�ɷѻ���
                                                      prm_AppCode  ,     --�������
                                                      prm_ErrorMsg );    --��������
              IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                 RETURN;
              END IF;
              IF var_aab019 = '60' THEN
                 --��ȡ��ƽ����
                 num_spgz := xasi2.pkg_comm.fun_GetAvgSalary('01','16',num_aae002,PKG_Constant.YAB003_JBFZX);
                 num_yac004 := num_aac040;

                 --�������Ϊ���� �ɷѹ��ʺͽɷѻ���Ϊ��ƽ����
                 IF num_aac040 < TRUNC(num_spgz/12*0.4)+1 THEN
                    num_yac004 := TRUNC(num_spgz/12*0.4)+1;
                 END IF;

                  IF num_aac040 > ROUND(num_spgz/12) THEN
                     num_yac004 := ROUND(num_spgz/12);
                  END  IF;

               END IF;
              --�������ϵĽɷѹ���
             /** UPDATE irac01a3
                  SET aac040 = num_aac040,     -- �걨����
                      yac004 = num_yac004     -- �ɷѻ���
                WHERE aac001 = var_aac001
                  AND aab001 = prm_aab001; */
                   UPDATE wsjb.IRAC01A3
                  SET aac040 = num_aac040,     -- �걨����
                      yac004 = num_yac004_new     -- �ɷѻ���
                WHERE aac001 = var_aac001
                  AND aab001 = prm_aab001;


              --д���˽ɷѻ��������¼��
               INSERT INTO xasi2.ac04a3(YAE099,             --ҵ����ˮ��,VARCHAR2
                                           AAC001,             --���˱��,VARCHAR2
                                           AAB001,             --��λ���,VARCHAR2
                                           AAE140,             --��������,VARCHAR2
                                           YAC235,             --���ʱ������,VARCHAR2
                                           YAC506,             --���ǰ����,NUMBER
                                           YAC507,             --���ǰ�ɷѻ���,NUMBER
                                           YAC514,             --���ǰ���ʻ�����,NUMBER
                                           AAC040,             --�ɷѹ���,NUMBER
                                           YAC004,             --�ɷѻ���,NUMBER
                                           YAA333,             --�˻�����,NUMBER
                                           AAE002,             --�ѿ�������,NUMBER
                                           AAE013,             --��ע,VARCHAR2
                                           AAE011,             --������,NUMBER
                                           AAE036,             --����ʱ��,DATE
                                           YAB003,             --�籣�������,VARCHAR2
                                           YAB139,             --�α�����������,VARCHAR2
                                           YAC503,             --�������,VARCHAR2
                                           YAC526              --���ǰ�������,VARCHAR2
                                           )
                                   VALUES (var_yae099,             --ҵ����ˮ��,VARCHAR2
                                           var_aac001,             --���˱��,VARCHAR2
                                           prm_aab001,             --��λ���,VARCHAR2
                                           '01',             --��������,VARCHAR2
                                           xasi2.pkg_comm.YAC235_PL,     --���ʱ������,VARCHAR2
                                           rec_ab05a1.AAC040,         --���ǰ����,NUMBER
                                           rec_ab05a1.YAC507,         --���ǰ�ɷѻ���,NUMBER
                                           0,         --���ǰ���ʻ�����,NUMBER
                                           num_aac040,             --�ɷѹ���,NUMBER
                                           num_yac004_new,             --�ɷѻ���,NUMBER
                                           num_yac004,             --�˻�����,NUMBER
                                           num_aae002,             --�ѿ�������,NUMBER
                                           '���걨'  ,                 --��ע,VARCHAR2
                                           prm_aae011,             --������,NUMBER
                                           sysdate,             --����ʱ��,DATE
                                           prm_yab139,             --�籣�������,VARCHAR2
                                           prm_yab139,             --�α�����������,VARCHAR2
                                           '0',             --�������,VARCHAR2
                                           '0');            --���ǰ�������,VARCHAR2
           END IF;
           --��дҵ����ˮ��
           UPDATE xasi2.ac01k8
              SET yae099 = var_yae099,
                  iaa002 = '2',
                  aae036 = sysdate,
                  aae011 = prm_aae011
            WHERE AAB001 = prm_aab001
              AND aac001 = var_aac001
              AND aae001 = prm_aae001
              AND yab019 = prm_yab019;
     END LOOP;


   EXCEPTION
        WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
             RETURN;
END prc_YearSalary;
/*****************************************************************************
   ** �������� : prc_YearSalaryRB
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���--�޸Ĺ���(����)
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ���
   **           prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
   **           prm_aae011       IN     irad31.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-09   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_YearSalaryRB( prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                               prm_aae001       IN     NUMBER            ,--�������
                               prm_iaa011       IN     irad51.iaa011%TYPE,--ҵ������
                               prm_yab019       IN     VARCHAR2     ,--���ͱ�־
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          )
   IS
   n_count    NUMBER;
   v_aac001   irac01.aac001%TYPE;
   v_aab001   irac01.aab001%TYPE;
   v_aae140   irab02.aae140%TYPE;
   n_aac040   NUMBER(14,2);
   n_yac004   NUMBER(14,2);
   n_yaa333   NUMBER(14,2);
   v_yae099   xasi2.ae16.yae099%TYPE;
   CURSOR cur_ac04a3 IS
       SELECT YAE099,             --ҵ����ˮ��,VARCHAR2
             AAC001,             --���˱��,VARCHAR2
             AAB001,             --��λ���,VARCHAR2
             AAE140,             --��������,VARCHAR2
             YAC235,             --���ʱ������,VARCHAR2
             YAC506,             --���ǰ����,NUMBER
             YAC507,             --���ǰ�ɷѻ���,NUMBER
             YAC514,             --���ǰ���ʻ�����,NUMBER
             AAC040,             --�ɷѹ���,NUMBER
             YAC004,             --�ɷѻ���,NUMBER
             YAA333,             --�˻�����,NUMBER
             AAE002              --�ѿ�������,NUMBER
        FROM xasi2.ac04a3
       WHERE yae099 = v_yae099;


   BEGIN
     prm_AppCode  := gn_def_OK;
    prm_ErrorMsg := '';
    n_aac040  := 0;
    n_yac004  := 0;



    --��ѯ���������ˮ��
     SELECT distinct yae099 into v_yae099
       FROM xasi2.ac01k8
      WHERE aab001 = prm_aab001
        AND aae001 = prm_aae001
        AND yab019 = prm_yab019;

     --ѭ�������¼����дԭ����������
     FOR rec_ac04a3 IN cur_ac04a3 LOOP
        v_aac001 := rec_ac04a3.aac001;
        v_aab001 := rec_ac04a3.aab001;
         v_aae140 := rec_ac04a3.aae140;
         n_aac040 := rec_ac04a3.yac506;
         n_yac004 := rec_ac04a3.yac507;
         n_yaa333 := rec_ac04a3.yac514;
         IF v_aae140 = '01' THEN  --���ϻ���
           UPDATE wsjb.IRAC01A3
              SET aac040 = n_aac040,
                  yac004 = n_yac004
            WHERE aab001 = v_aab001
              AND aac001 = v_aac001;
         ELSE                      --�������ջ���
           UPDATE xasi2.ac02
              SET aac040 = n_aac040,
                  yac004 = n_yac004
            WHERE aab001 = v_aab001
              AND aac001 = v_aac001
              AND aae140 = v_aae140;
         END IF;

     END LOOP;
     --ɾ�������¼
     DELETE xasi2.ac04a3
      WHERE yae099 = v_yae099;
     --����
     UPDATE xasi2.ac01k8
        SET yae099 = '',
            iaa002 = '1',
            aae036 = NULL,
            aae011 = NULL
      WHERE AAB001 = prm_aab001
        AND aae001 = prm_aae001
        AND yab019 = prm_yab019;

   EXCEPTION
        WHEN OTHERS THEN
             ROLLBACK;
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
             RETURN;

   END prc_YearSalaryRB;
/*****************************************************************************
   ** �������� : prc_YearSalaryBC
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���--����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ���
   **           prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
   **           prm_aae011       IN     irad31.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-09   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
PROCEDURE prc_YearSalaryBC(prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                           prm_aae001       IN     NUMBER            ,--�������
                           prm_aae011       IN     irad31.aae011%TYPE,--������
                           prm_yab139       IN     VARCHAR2          ,--�α�����������
                           prm_iaa011       IN     irad51.iaa011%TYPE,--ҵ������
                           prm_yab019       IN     VARCHAR2          ,--���ͱ�־
                           prm_AppCode      OUT    VARCHAR2          ,
                           prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      num_count     NUMBER;
      v_msg        VARCHAR2(200);
      var_aaz002   irad51.aaz002%TYPE;
      var_aaz083   ab08.aaz083%TYPE;
      num_aae041_year NUMBER(6);  --���ʼʱ��
      num_yae097   xasi2.ab02.yae097%TYPE; --��λ��������ں�
      var_aae140   xasi2.ab02.aae140%TYPE; --����
      var_aac001   xasi2.ac01.aac001%TYPE; --���˱��
      num_aae002   xasi2.ac08a1.aae002%TYPE;
      num_aac040   xasi2.ac02.aac040%TYPE;
      num_spgz     xasi2.ac02.aac040%TYPE;
      num_yac004   xasi2.ac02.yac004%TYPE;
      var_yab136   xasi2.ab01.yab136%TYPE;
      var_yab275   xasi2.ab01.yab275%TYPE;
      var_aae119   xasi2.ab01.aae119%TYPE;
      var_aab019   xasi2.ab01.aab019%TYPE;
      var_yac503   xasi2.ac02.yac503%TYPE;
      var_yac505   xasi2.ac02.yac505%TYPE;
      num_yac401   tmp_ac42.yac401%type;           --1�²�����,NUMBER
      num_yac402   tmp_ac42.yac401%type;           --2�²�����,NUMBER
      num_yac403   tmp_ac42.yac401%type;           --3�²�����,NUMBER
      num_yac404   tmp_ac42.yac401%type;           --4�²�����,NUMBER
      num_yac405   tmp_ac42.yac401%type;           --5�²�����,NUMBER
      num_yac406   tmp_ac42.yac401%type;           --6�²�����,NUMBER
      num_yac407   tmp_ac42.yac401%type;           --7�²�����,NUMBER
      num_yac408   tmp_ac42.yac401%type;           --8�²�����,NUMBER
      num_yac409   tmp_ac42.yac401%type;           --9�²�����,NUMBER
      num_yac410   tmp_ac42.yac401%type;           --10�²�����,NUMBER
      num_yac411   tmp_ac42.yac401%type;           --11�²�����,NUMBER
      num_yac412   tmp_ac42.yac401%type;           --12�²�����,NUMBER
      var_procNo   VARCHAR2(5);                    --���̺�
      var_aae013   xasi2.ab08a8.aae013%TYPE;
      var_aae100   VARCHAR2(9);
      var_yae099   xasi2.ac04a3.yae099%TYPE;
      var_yab222   xasi2.ab08.yab222%TYPE;
      var_aae076   xasi2.ab08.aae076%TYPE;
      var_yae010_110   xasi2.ab08.yae010%TYPE;
      var_yae010_120   xasi2.ab08.yae010%TYPE;
      var_yae010_210   xasi2.ab08.yae010%TYPE;
      var_yae010_310   xasi2.ab08.yae010%TYPE;
      var_yae010_410   xasi2.ab08.yae010%TYPE;
      var_yae010_510   xasi2.ab08.yae010%TYPE;
      var_yae010   xasi2.ab08.yae010%TYPE;
      var_yae517   xasi2.ab08.yae517%TYPE;


      CURSOR cur_aae140 IS
        SELECT DISTINCT aae140
          FROM wsjb.tmp_ac42
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND aae140 NOT in (PKG_Constant.AAE140_YL,'06')
           AND prm_yab019 = '1'
        UNION
        SELECT DISTINCT aae140
          FROM wsjb.tmp_ac42
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND aae140 = '06'
           AND prm_yab019 = '2' ;

      --��ȡ��λ�ύ���걨��Ա
      CURSOR cur_tmp_ac42 IS
        select AAC001,             --��Ա���,VARCHAR2
               AAB001,             --��λ���,VARCHAR2
               AAE140,             --����,VARCHAR2
               YAC401,             --1�²�����,NUMBER
               YAC402,             --2�²�����,NUMBER
               YAC403,             --3�²�����,NUMBER
               YAC404,             --4�²�����,NUMBER
               YAC405,             --5�²�����,NUMBER
               YAC406,             --6�²�����,NUMBER
               YAC407,             --7�²�����,NUMBER
               YAC408,             --8�²�����,NUMBER
               YAC409,             --9�²�����,NUMBER
               YAC410,             --10�²�����,NUMBER
               YAC411,             --11�²�����,NUMBER
               YAC412,             --12�²�����,NUMBER
               AAE013,             --��ע,VARCHAR2
               aae001
          from wsjb.tmp_ac42   --��Ա���ֲ�����Ϣ��
         WHERE aab001 = prm_aab001
           AND AAC001 = var_aac001
           AND aae001 = prm_aae001
           AND aae140 = var_aae140;
      --��ȡ��Ա�Ĳα���Ϣ
      CURSOR cur_ab05a1 IS
        SELECT aac001,
               aab001,
               NVL(yac506,0) AS yac506,
               NVL(yac507,0) AS yac507,
               NVL(yac503,0) AS yac503,--�������
               NVL(aac040,0) AS aac040,--�����ɷѹ���
               NVL(yac004,0) AS yac004,--��������Ͻɷѻ���
               NVL(yaa333,0) AS yaa333,--�����ɷѻ���
               NVL(yac005,0) AS yac005--���˽ɷѹ���
          FROM xasi2.ac01k8
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND yab019 = prm_yab019
            AND (aae013 is null or aae013 ='1' or aae013 ='22');  
      --�������շ�ʽ���·�����Դ
      CURSOR cur_ab08 IS
      SELECT yae518,
             aae140
        FROM xasi2.AB08
       WHERE aab001 = prm_aab001
         AND yae517 IN (xasi2.pkg_comm.YAE517_H12,xasi2.pkg_comm.YAE517_H17)
         AND aae003 = num_yae097
         AND yab222 = var_yab222;
      --�������շ�ʽ���·�����Դ
      CURSOR cur_ab08a8 IS
      SELECT yae518,
             aae140
        FROM xasi2.AB08A8
       WHERE aab001 = prm_aab001
         AND yae517 = xasi2.pkg_comm.YAE517_H17
         AND aae003 = num_yae097
         AND yab222 = var_yab222;

   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      var_procNo   :='Y01';
      var_yae099   := xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAE099');
      --����У��
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λ��Ų���Ϊ��' ;
         RETURN;
      END IF;

      IF prm_aae001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '������Ȳ���Ϊ��' ;
         RETURN;
      END IF;

      --��ȡ��λ��ǰ�Ĺ�������
      BEGIN
         SELECT yab136,
                yab275,
                aae119,
                aab019
           INTO var_yab136,
                var_yab275,
                var_aae119,
                var_aab019
           FROM xasi2.ab01
          WHERE aab001 = prm_aab001;
      EXCEPTION
         WHEN OTHERS THEN
            prm_AppCode := ''||var_procNo||'02';
            prm_ErrorMsg  := '��λ����'||prm_aab001||'�籣�������'||prm_yab139||'û�л�ȡ����λ������Ϣ';
            RETURN;
      END;


      SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(yae097),'yyyymm'),1),'yyyymm'))   --��ȡ�����ں�
        INTO num_yae097
        FROM xasi2.ab02
       WHERE aab001 = prm_aab001
         AND aab051 = '1';


      num_aae002 := num_yae097;
      var_yab222 := xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAB222');
      --�����ʱ������
      DELETE xasi2.tmp_grbs01;
       --�����ֽ��в���
      FOR rec_aae140 IN cur_aae140 LOOP
          var_aae140 := rec_aae140.aae140;

          FOR rec_ab05a1 IN cur_ab05a1 LOOP
              var_aac001 := rec_ab05a1.aac001;
              num_aac040 := TRUNC(rec_ab05a1.aac040);

              --ѭ����ȡ��Ա�����ʱ��
              FOR rec_tmp_ac42 IN cur_tmp_ac42 LOOP
                  --�ɷѹ��ʱ��׷ⶥ
                  IF var_aae140 = xasi2.pkg_comm.aae140_GS THEN
                     var_yac503 := xasi2.pkg_comm.YAC503_SB;
                     var_yac505 := xasi2.pkg_comm.YAC505_GSPT;
                  ELSE
                      BEGIN
                        SELECT yac503,
                               YAC505
                          INTO var_yac503,
                               var_yac505
                          FROM xasi2.ac02
                         WHERE aac001 = var_aac001
                           AND aab001 = prm_aab001
                           AND aae140 = var_aae140;
                       EXCEPTION
                            WHEN OTHERS THEN
                                 GOTO leb_error;
                      END;
                  END IF;
                  IF var_aae140 <> '06' THEN
                     --���ñ��׷ⶥ���̣���ȡ�ɷѻ����ͽɷѹ���
                     xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase
                                                           (var_aac001   ,     --���˱���
                                                            prm_aab001   ,     --��λ����
                                                            num_aac040   ,     --�ɷѹ���
                                                            var_yac503   ,     --�������
                                                            var_aae140   ,     --��������
                                                            var_yac505   ,     --�ɷ���Ա���
                                                            var_yab136   ,     --��λ�������ͣ���������ɷ���Ա��
                                                            to_number(prm_aae001||'01')   ,     --�ѿ�������
                                                            prm_yab139   ,     --�α�������
                                                            num_yac004   ,     --�ɷѻ���
                                                            prm_AppCode  ,     --�������
                                                            prm_ErrorMsg );    --��������
                     IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                        RETURN;
                     END IF;

                      --�жϸ��幤�̻�
                     IF var_aab019 = '60' THEN
                       --��ȡ��ƽ����
                       num_spgz := xasi2.pkg_comm.fun_GetAvgSalary(var_aae140,'16',num_aae002,PKG_Constant.YAB003_JBFZX);
                       --�������Ϊ���� �ɷѹ��ʺͽɷѻ���Ϊ��ƽ����
                       IF var_aae140 = xasi2.pkg_comm.AAE140_GS THEN
                          num_yac004 := ROUND(num_spgz/12);
                        ELSE
                          IF num_aac040 > ROUND(num_spgz/12) THEN
                             num_yac004 := ROUND(num_spgz/12);
                          END  IF;
                        END IF;
                     END IF;
                   ELSE
                       num_yac004 := rec_ab05a1.yac004;
                   END IF;
                   --����TMP_ac42���벹�����ʱ����
                   --1�²���
                   IF rec_tmp_ac42.yac401 <> 0 THEN
                     INSERT INTO xasi2.tmp_grbs01
                                                   (aac001,   --���˱���
                                                    aae041,   --��ʼ�ں�
                                                    aae042,   --��ֹ�ں�
                                                    aae140,   --����
                                                    yac503,   --�������
                                                    aac040,   --�ɷѹ���
                                                    yaa333,   --�ʻ�����
                                                    aae100,   --��Ч��־
                                                    aae013    --��ע
                                                    )
                                            VALUES (var_aac001,
                                                    rec_tmp_ac42.aae001||'01',
                                                    rec_tmp_ac42.aae001||'01',
                                                    var_aae140,
                                                    rec_ab05a1.yac503,                                    --�������
                                                    num_yac004,                           --�����ɷѹ���  ����ǹ���������ȡ���˵Ľɷѹ��� ��ҪΪ�����ָ��嵥λ
                                                    rec_ab05a1.yaa333,
                                                    NULL,
                                                    NULL);
                   END IF;
                   IF rec_tmp_ac42.yac402 <> 0 THEN   --2�²���
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --���˱���
                                                        aae041,   --��ʼ�ں�
                                                        aae042,   --��ֹ�ں�
                                                        aae140,   --����
                                                        yac503,   --�������
                                                        aac040,   --�ɷѹ���
                                                        yaa333,   --�ʻ�����
                                                        aae100,   --��Ч��־
                                                        aae013    --��ע
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'02',
                                                        rec_tmp_ac42.aae001||'02',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --�������
                                                        num_yac004,                           --�����ɷѹ���  ����ǹ���������ȡ���˵Ľɷѹ��� ��ҪΪ�����ָ��嵥λ
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;
                   IF rec_tmp_ac42.yac403 <> 0 THEN   --���²���
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --���˱���
                                                        aae041,   --��ʼ�ں�
                                                        aae042,   --��ֹ�ں�
                                                        aae140,   --����
                                                        yac503,   --�������
                                                        aac040,   --�ɷѹ���
                                                        yaa333,   --�ʻ�����
                                                        aae100,   --��Ч��־
                                                        aae013    --��ע
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'03',
                                                        rec_tmp_ac42.aae001||'03',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --�������
                                                        num_yac004,                           --�����ɷѹ���  ����ǹ���������ȡ���˵Ľɷѹ��� ��ҪΪ�����ָ��嵥λ
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac404 <> 0 THEN   --4�²���
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --���˱���
                                                        aae041,   --��ʼ�ں�
                                                        aae042,   --��ֹ�ں�
                                                        aae140,   --����
                                                        yac503,   --�������
                                                        aac040,   --�ɷѹ���
                                                        yaa333,   --�ʻ�����
                                                        aae100,   --��Ч��־
                                                        aae013    --��ע
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'04',
                                                        rec_tmp_ac42.aae001||'04',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --�������
                                                        num_yac004,                           --�����ɷѹ���  ����ǹ���������ȡ���˵Ľɷѹ��� ��ҪΪ�����ָ��嵥λ
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac405 <> 0 THEN   --5�²���
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --���˱���
                                                        aae041,   --��ʼ�ں�
                                                        aae042,   --��ֹ�ں�
                                                        aae140,   --����
                                                        yac503,   --�������
                                                        aac040,   --�ɷѹ���
                                                        yaa333,   --�ʻ�����
                                                        aae100,   --��Ч��־
                                                        aae013    --��ע
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'05',
                                                        rec_tmp_ac42.aae001||'05',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --�������
                                                        num_yac004,                           --�����ɷѹ���  ����ǹ���������ȡ���˵Ľɷѹ��� ��ҪΪ�����ָ��嵥λ
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac406 <> 0 THEN    --6�²���
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --���˱���
                                                        aae041,   --��ʼ�ں�
                                                        aae042,   --��ֹ�ں�
                                                        aae140,   --����
                                                        yac503,   --�������
                                                        aac040,   --�ɷѹ���
                                                        yaa333,   --�ʻ�����
                                                        aae100,   --��Ч��־
                                                        aae013    --��ע
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'06',
                                                        rec_tmp_ac42.aae001||'06',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --�������
                                                        num_yac004,                           --�����ɷѹ���  ����ǹ���������ȡ���˵Ľɷѹ��� ��ҪΪ�����ָ��嵥λ
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac407 <> 0 THEN   --7�²���
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --���˱���
                                                        aae041,   --��ʼ�ں�
                                                        aae042,   --��ֹ�ں�
                                                        aae140,   --����
                                                        yac503,   --�������
                                                        aac040,   --�ɷѹ���
                                                        yaa333,   --�ʻ�����
                                                        aae100,   --��Ч��־
                                                        aae013    --��ע
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'07',
                                                        rec_tmp_ac42.aae001||'07',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --�������
                                                        num_yac004,                           --�����ɷѹ���  ����ǹ���������ȡ���˵Ľɷѹ��� ��ҪΪ�����ָ��嵥λ
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac408 <> 0 THEN    --8�²���
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --���˱���
                                                        aae041,   --��ʼ�ں�
                                                        aae042,   --��ֹ�ں�
                                                        aae140,   --����
                                                        yac503,   --�������
                                                        aac040,   --�ɷѹ���
                                                        yaa333,   --�ʻ�����
                                                        aae100,   --��Ч��־
                                                        aae013    --��ע
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'08',
                                                        rec_tmp_ac42.aae001||'08',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --�������
                                                        num_yac004,                           --�����ɷѹ���  ����ǹ���������ȡ���˵Ľɷѹ��� ��ҪΪ�����ָ��嵥λ
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac409 <> 0 THEN   --9�²���
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --���˱���
                                                        aae041,   --��ʼ�ں�
                                                        aae042,   --��ֹ�ں�
                                                        aae140,   --����
                                                        yac503,   --�������
                                                        aac040,   --�ɷѹ���
                                                        yaa333,   --�ʻ�����
                                                        aae100,   --��Ч��־
                                                        aae013    --��ע
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'09',
                                                        rec_tmp_ac42.aae001||'09',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --�������
                                                        num_yac004,                           --�����ɷѹ���  ����ǹ���������ȡ���˵Ľɷѹ��� ��ҪΪ�����ָ��嵥λ
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac410 <> 0 THEN    --10�²���
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --���˱���
                                                        aae041,   --��ʼ�ں�
                                                        aae042,   --��ֹ�ں�
                                                        aae140,   --����
                                                        yac503,   --�������
                                                        aac040,   --�ɷѹ���
                                                        yaa333,   --�ʻ�����
                                                        aae100,   --��Ч��־
                                                        aae013    --��ע
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'10',
                                                        rec_tmp_ac42.aae001||'10',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --�������
                                                        num_yac004,                           --�����ɷѹ���  ����ǹ���������ȡ���˵Ľɷѹ��� ��ҪΪ�����ָ��嵥λ
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac411 <> 0 THEN   --11�²���
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --���˱���
                                                        aae041,   --��ʼ�ں�
                                                        aae042,   --��ֹ�ں�
                                                        aae140,   --����
                                                        yac503,   --�������
                                                        aac040,   --�ɷѹ���
                                                        yaa333,   --�ʻ�����
                                                        aae100,   --��Ч��־
                                                        aae013    --��ע
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'11',
                                                        rec_tmp_ac42.aae001||'11',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --�������
                                                        num_yac004,                           --�����ɷѹ���  ����ǹ���������ȡ���˵Ľɷѹ��� ��ҪΪ�����ָ��嵥λ
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac412 <> 0 THEN   --12�²���
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --���˱���
                                                        aae041,   --��ʼ�ں�
                                                        aae042,   --��ֹ�ں�
                                                        aae140,   --����
                                                        yac503,   --�������
                                                        aac040,   --�ɷѹ���
                                                        yaa333,   --�ʻ�����
                                                        aae100,   --��Ч��־
                                                        aae013    --��ע
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'12',
                                                        rec_tmp_ac42.aae001||'12',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --�������
                                                        num_yac004,                           --�����ɷѹ���  ����ǹ���������ȡ���˵Ľɷѹ��� ��ҪΪ�����ָ��嵥λ
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                  END IF;
                  <<leb_error>>
                  NULL;
              END LOOP;
          END LOOP;

      END LOOP;
 --���û�в�����ʱ��Ͳ���Ҫ����
      SELECT COUNT(1) INTO NUM_COUNT FROM XASI2.TMP_GRBS01;
      IF NUM_COUNT > 0 THEN
        --���tmp_grbs01,������tmp_grbs02��Ϣ
        XASI2.PKG_P_PAYADJUST.PRC_P_CHECKDATA(PRM_AAB001, --��λ���
                                              '1', --���ʽ��0 �ɷѱ������ 1 �ɷѻ������
                                              PRM_YAB139, --�α�����������
                                              PRM_YAB139, --�籣�������
                                              PRM_APPCODE, --ִ�д���
                                              PRM_ERRORMSG); --ִ�н��
        IF PRM_APPCODE <> XASI2.PKG_COMM.GN_DEF_OK THEN
          RETURN;
        END IF;
        VAR_AAZ002 := PKG_COMMON.FUN_GETSEQUENCE(NULL, 'AAZ002');
        var_aaz083 := xasi2.pkg_comm.fun_GetSequence(NULL,'AAZ083');
        --���ò������
        --modify by fenggg at 20181202 begin
        --���õĲ������  XASI2.PKG_P_PAYADJUST.PRC_P_BATCHSALARYADJUSTPADED  ����
        --�滻�ɵ���  xasi2.pkg_p_salaryExamineAdjust.pkg_p_salaryExamineAdjust �������

        /*XASI2.PKG_P_PAYADJUST.PRC_P_BATCHSALARYADJUSTPADED(VAR_AAZ002,
                                                           PRM_AAB001, --��λ���
                                                           NUM_YAE097, --�����ں�
                                                           '1', --���ʽ(0 �ɷѱ������ 1 �ɷѻ������
                                                           '0', --������־(0:��;1:��
                                                           '2', --�˿ʽ(1�����ֽ�2������ת��
                                                           '1', --����Ƿ������Ч�������ݡ�0������顣1����顣
                                                           '0', --��Ϣ��־
                                                           '0', --���ɽ��־
                                                           NULL, --���շ�ʽ
                                                           PRM_YAB139, --�����α�������
                                                           PRM_YAB139, --�籣�������
                                                           PRM_AAE011, --������
                                                           SYSDATE, --����ʱ��
                                                           VAR_YAB222, --�������κ�
                                                           VAR_AAE076, --����ӿ���ˮ��
                                                           PRM_APPCODE, --ִ�д���
                                                           PRM_ERRORMSG); --ִ�н��*/
                                                           
        /* xasi2.pkg_p_salaryExamineAdjust.pkg_p_salaryExamineAdjust(
                                              VAR_AAZ002,
                                              var_aaz083,
                                              prm_aab001      ,  --��λ���
                                              TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(num_yae097,'yyyymm'),1),'yyyymm'))      ,  --�����ں�
                                              '1'             ,  --���ʽ(0 �ɷѱ������ 1 �ɷѻ������
                                              '0'             ,  --��Ч ������־(0:��;1:��
                                              '2'             ,  --��Ч �˿ʽ(1�����ֽ�2������ת��
                                              0               ,  --����Ƿ������Ч�������ݡ�0������顣1����顣
                                              '0'             ,  --��Ч ��Ϣ��־
                                              '0'             ,  --��Ч  ���ɽ��־
                                              NULL            ,  --��Ч  ���շ�ʽ
                                              prm_yab139      ,  --�����α�������
                                              prm_yab139      ,  --�籣�������
                                              prm_aae011      ,  --������
                                              sysdate      ,  --����ʱ��
                                              VAR_YAB222      ,  --�������κ�
                                              var_aae076      ,  --����ӿ���ˮ��
                                              PRM_APPCODE     ,  --ִ�д���
                                              PRM_ERRORMSG ); --ִ�н�� 
           IF PRM_APPCODE <> XASI2.PKG_COMM.GN_DEF_OK THEN
            RETURN;
           END IF;*/
                                              
       --modify by fenggg at 20190716 begin
              --����2019�������жϣ�2019�꼰֮����������µĲ������
              IF prm_aae001 > 2018 THEN
                 xasi2.pkg_p_salaryExamineAdjust.pkg_p_salaryExamineAdjust_ns(
                                                VAR_AAZ002,
                                                var_aaz083,
                                                prm_aab001      ,  --��λ���
                                                TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(num_yae097,'yyyymm'),1),'yyyymm'))      ,  --�����ں�
                                                prm_aae001,        --�������
                                                '1'             ,  --���ʽ(0 �ɷѱ������ 1 �ɷѻ������
                                                '0'             ,  --��Ч ������־(0:��;1:��
                                                '2'             ,  --��Ч �˿ʽ(1�����ֽ�2������ת��
                                                0               ,  --����Ƿ������Ч�������ݡ�0������顣1����顣
                                                '1'             ,  --��Ч ��Ϣ��־
                                                '1'             ,  --��Ч  ���ɽ��־
                                                NULL            ,  --��Ч  ���շ�ʽ
                                                prm_yab139      ,  --�����α�������
                                                prm_yab139      ,  --�籣�������
                                                prm_aae011      ,  --������
                                                sysdate      ,  --����ʱ��
                                                VAR_YAB222      ,  --�������κ�
                                                var_aae076      ,  --����ӿ���ˮ��
                                                prm_AppCode     ,  --ִ�д���
                                                PRM_ERRORMSG      ); --ִ�н��
                 IF prm_AppCode <> XASI2.pkg_comm.gn_def_OK  THEN
                    RETURN;
                 ELSE
                    PRM_ERRORMSG  := '';
                 END IF;
              ELSE  --modify by fenggg at 20190716 end
                 xasi2.pkg_p_salaryExamineAdjust.pkg_p_salaryExamineAdjust(
                                                VAR_AAZ002,
                                                var_aaz083,
                                                prm_aab001      ,  --��λ���
                                                TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(num_yae097,'yyyymm'),1),'yyyymm'))      ,  --�����ں�
                                                '1'             ,  --���ʽ(0 �ɷѱ������ 1 �ɷѻ������
                                                '0'             ,  --��Ч ������־(0:��;1:��
                                                '2'             ,  --��Ч �˿ʽ(1�����ֽ�2������ת��
                                                0               ,  --����Ƿ������Ч�������ݡ�0������顣1����顣
                                                '1'             ,  --��Ч ��Ϣ��־
                                                '1'             ,  --��Ч  ���ɽ��־
                                                NULL            ,  --��Ч  ���շ�ʽ
                                                prm_yab139      ,  --�����α�������
                                                prm_yab139      ,  --�籣�������
                                                prm_aae011      ,  --������
                                                sysdate      ,  --����ʱ��
                                                VAR_YAB222      ,  --�������κ�
                                                var_aae076      ,  --����ӿ���ˮ��
                                                prm_AppCode     ,  --ִ�д���
                                                PRM_ERRORMSG      ); --ִ�н��
                 IF prm_AppCode <> XASI2.pkg_comm.gn_def_OK  THEN
                    RETURN;
                 ELSE
                    PRM_ERRORMSG  := '';
                 END IF;
             END IF;                                              
                                              

           --modify by fenggg at 20181202 end
       
      END IF;

      --���·�����Դ
      BEGIN

      SELECT decode(yae010_110,'3','1','1'),
               decode(yae010_120,'3','1','1'),
               decode(yae010_210,'3','1','1'),
               decode(yae010_310,'3','1','1'),
               decode(yae010_410,'3','1','1'),
               decode(yae010_510,'3','1','1')
          INTO var_yae010_110,
               var_yae010_120,
               var_yae010_210,
               var_yae010_310,
               var_yae010_410,
               var_yae010_510
          FROM wsjb.irab03
         WHERE aab001 = prm_aab001;






      /**  SELECT yae010_110,
               yae010_120,
               yae010_210,
               yae010_310,
               yae010_410,
               yae010_510
          INTO var_yae010_110,
               var_yae010_120,
               var_yae010_210,
               var_yae010_310,
               var_yae010_410,
               var_yae010_510
          FROM wsjb.irab03
         WHERE aab001 = prm_aab001;
         */
       EXCEPTION
            WHEN OTHERS THEN
                 var_yae010_110 := '1';
                 var_yae010_210 := xasi2.pkg_comm.YAE010_ZC; -- YAE010_DSZS �� YAE010_ZC
                 var_yae010_310 := xasi2.pkg_comm.YAE010_ZC;
                 var_yae010_410 := xasi2.pkg_comm.YAE010_ZC;
                 var_yae010_510 := xasi2.pkg_comm.YAE010_ZC;
      END;
      FOR rec_ab08 IN cur_ab08 LOOP
          --ʧҵ
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_SYE THEN
             var_yae010 := var_yae010_210;
          END IF;
          --ҽ��
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_JBYL THEN
             var_yae010 := var_yae010_310;
          END IF;
          --����
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_GS THEN
             var_yae010 := var_yae010_410;
          END IF;
          --����
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_SYU THEN
             var_yae010 := var_yae010_510;
          END IF;
          --��������
          IF rec_ab08.aae140 = '06' THEN
             var_yae010 := var_yae010_120;
          END IF;
          --���·�����Դ
          UPDATE xasi2.AB08
             SET yae010 = var_yae010
           WHERE yae518 = rec_ab08.yae518
             AND yab222 = var_yab222
             AND aae140 = rec_ab08.aae140;

          --������Ա��ϸ
          UPDATE xasi2.AC08A1
             SET yae010 = var_yae010
           WHERE yae518 = rec_ab08.yae518
             AND aae140 = rec_ab08.aae140;
      END LOOP;
      FOR rec_ab08a8 IN cur_ab08a8 LOOP
          --ʧҵ
          IF rec_ab08a8.aae140 = xasi2.pkg_comm.AAE140_SYE THEN
             var_yae010 := var_yae010_210;
          END IF;
          --ҽ��
          IF rec_ab08a8.aae140 = xasi2.pkg_comm.AAE140_JBYL THEN
             var_yae010 := var_yae010_310;
          END IF;
          --����
          IF rec_ab08a8.aae140 = xasi2.pkg_comm.AAE140_GS THEN
             var_yae010 := var_yae010_410;
          END IF;
          --����
          IF rec_ab08a8.aae140 = xasi2.pkg_comm.AAE140_SYU THEN
             var_yae010 := var_yae010_510;
          END IF;

          --���·�����Դ
          UPDATE xasi2.AB08A8
             SET yae010 = var_yae010
           WHERE yae518 = rec_ab08a8.yae518
             AND yab222 = var_yab222
             AND aae140 = rec_ab08a8.aae140;

          --������Ա��ϸ
          UPDATE xasi2.ac08
             SET yae010 = var_yae010
           WHERE yae518 = rec_ab08a8.yae518
             AND aae140 = rec_ab08a8.aae140;
      END LOOP;
      --��˰�ķ�����
      var_yae010 := xasi2.pkg_comm.YAE010_ZC;
      --YAE517 = H12
      FOR rec_aae140 IN cur_aae140 LOOP
          --������ʱ��
          DELETE FROM xasi2.Tmp_yae518;
          INSERT INTO xasi2.tmp_yae518
                                         (yae518,   -- �˶���ˮ��
                                          aae140,   -- ��������
                                          aab001,
                                          yab538,
                                          yae010,
                                          aae041,
                                          yab139)
                                   SELECT yae518,
                                          aae140,
                                          aab001,
                                          yab538, --�ɷ���Ա״̬
                                          YAE010, --������Դ
                                          aae041,
                                          prm_yab139
                                     FROM xasi2.AB08
                                    WHERE aab001 = prm_aab001
                                      AND (aae076 IS NULL OR aae076 = '0')
                                      AND aae140 = rec_aae140.aae140
                                      AND yae517 = xasi2.pkg_Comm.YAE517_H12      --�˶�����
                                      AND aae003 = num_yae097
                                      AND yab222 = var_yab222
                                      AND yae010 =xasi2.pkg_Comm.YAE010_ZC;
        SELECT COUNT(1)
          INTO num_count
          FROM xasi2.tmp_yae518;
        IF num_count > 0 THEN
           var_aae076 := xasi2.pkg_comm.fun_GetSequence(NULL,'aae076');
           --�����������̡����ɵ�����Ϣ�Ͳ���ӿ�����
           xasi2.pkg_p_fundCollection.prc_crtFinaPlan  (
                                                          'P23'    ,      --�ո�����
                                                          xasi2.pkg_comm.YAD052_GTSK,      --�ո����㷽ʽ
                                                          prm_aae011    ,      --������Ա
                                                          prm_yab139    ,      --�籣�������
                                                          var_aae076    ,      --�ƻ���ˮ��
                                                          prm_AppCode   ,      --ִ�д���
                                                          prm_ErrorMsg    );     --ִ�н��
           IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
              RETURN;
           END IF;
        END IF;
     END LOOP;
     --YAE517 = H17
      FOR rec_aae140 IN cur_aae140 LOOP
          --������ʱ��
          DELETE FROM xasi2.Tmp_yae518;
          INSERT INTO xasi2.tmp_yae518
                                         (yae518,   -- �˶���ˮ��
                                          aae140,   -- ��������
                                          aab001,
                                          yab538,
                                          yae010,
                                          aae041,
                                          yab139)
                                   SELECT yae518,
                                          aae140,
                                          aab001,
                                          yab538, --�ɷ���Ա״̬
                                          YAE010, --������Դ
                                          aae041,
                                          prm_yab139
                                     FROM xasi2.AB08
                                    WHERE aab001 = prm_aab001
                                      AND (aae076 IS NULL OR aae076 = '0')
                                      AND aae140 = rec_aae140.aae140
                                      AND yae517 = xasi2.pkg_Comm.YAE517_H17      --�˶�����
                                      AND aae003 = num_yae097
                                      AND yab222 = var_yab222
                                      AND yae010 =xasi2.pkg_Comm.YAE010_ZC;
        SELECT COUNT(1)
          INTO num_count
          FROM xasi2.tmp_yae518;
        IF num_count > 0 THEN
           var_aae076 := xasi2.pkg_comm.fun_GetSequence(NULL,'aae076');
           --�����������̡����ɵ�����Ϣ�Ͳ���ӿ�����
           xasi2.pkg_p_fundCollection.prc_crtFinaPlan  (
                                                          'P19'    ,      --�ո�����
                                                          xasi2.pkg_comm.YAD052_TZ,      --�ո����㷽ʽ
                                                          prm_aae011    ,      --������Ա
                                                          prm_yab139    ,      --�籣�������
                                                          var_aae076    ,      --�ƻ���ˮ��
                                                          prm_AppCode   ,      --ִ�д���
                                                          prm_ErrorMsg    );     --ִ�н��
           IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
              RETURN;
           END IF;
        END IF;
     END LOOP;
     --�Գ�ķ�����
     --YAE517 = H12
      var_aae076 := xasi2.pkg_comm.fun_GetSequence(NULL,'aae076');
      --������ʱ��
      DELETE FROM xasi2.Tmp_yae518;
      INSERT INTO xasi2.tmp_yae518
                                     (yae518,   -- �˶���ˮ��
                                      aae140,   -- ��������
                                      aab001,
                                      yab538,
                                      yae010,
                                      aae041,
                                      yab139)
                               SELECT yae518,
                                      aae140,
                                      aab001,
                                      yab538, --�ɷ���Ա״̬
                                      YAE010, --������Դ
                                      aae041,
                                      prm_yab139
                                 FROM xasi2.AB08
                                WHERE aab001 = prm_aab001
                                  AND (aae076 IS NULL OR aae076 = '0')
                                  AND yae517 = xasi2.pkg_Comm.YAE517_H12      --�˶�����
                                  AND aae003 = num_yae097
                                  AND yab222 = var_yab222
                                  AND yae010 = xasi2.pkg_Comm.YAE010_ZC;
    SELECT COUNT(1)
      INTO num_count
      FROM xasi2.tmp_yae518;
    IF num_count > 0 THEN
       --�����������̡����ɵ�����Ϣ�Ͳ���ӿ�����
       xasi2.pkg_p_fundCollection.prc_crtFinaPlan  (
                                                        'P01'    ,      --�ո�����
                                                        xasi2.pkg_comm.YAD052_GTSK,      --�ո����㷽ʽ
                                                        prm_aae011    ,      --������Ա
                                                        prm_yab139    ,      --�籣�������
                                                        var_aae076    ,      --�ƻ���ˮ��
                                                        prm_AppCode   ,      --ִ�д���
                                                        prm_ErrorMsg    );     --ִ�н��
       IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
          RETURN;
       END IF;
    END IF;
    --YAE517 = H17
      var_aae076 := xasi2.pkg_comm.fun_GetSequence(NULL,'aae076');
      --������ʱ��
      DELETE FROM xasi2.Tmp_yae518;
      INSERT INTO xasi2.tmp_yae518
                                     (yae518,   -- �˶���ˮ��
                                      aae140,   -- ��������
                                      aab001,
                                      yab538,
                                      yae010,
                                      aae041,
                                      yab139)
                               SELECT yae518,
                                      aae140,
                                      aab001,
                                      yab538, --�ɷ���Ա״̬
                                      YAE010, --������Դ
                                      aae041,
                                      prm_yab139
                                 FROM xasi2.AB08
                                WHERE aab001 = prm_aab001
                                  AND (aae076 IS NULL OR aae076 = '0')
                                  AND yae517 = xasi2.pkg_Comm.YAE517_H17      --�˶�����
                                  AND aae003 = num_yae097
                                  AND yab222 = var_yab222
                                  AND yae010 = xasi2.pkg_Comm.YAE010_ZC;
    SELECT COUNT(1)
      INTO num_count
      FROM xasi2.tmp_yae518;
    IF num_count > 0 THEN
       --�����������̡����ɵ�����Ϣ�Ͳ���ӿ�����
       xasi2.pkg_p_fundCollection.prc_crtFinaPlan  (
                                                        'P19'    ,      --�ո�����
                                                        xasi2.pkg_comm.YAD052_TZ,      --�ո����㷽ʽ
                                                        prm_aae011    ,      --������Ա
                                                        prm_yab139    ,      --�籣�������
                                                        var_aae076    ,      --�ƻ���ˮ��
                                                        prm_AppCode   ,      --ִ�д���
                                                        prm_ErrorMsg    );     --ִ�н��
       IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
          RETURN;
       END IF;
    END IF;
      --�������ϲ���
      prc_YearSalaryBCByYL(prm_aab001  ,
                           prm_aae001  ,
                           num_yae097  ,
                           var_yab222  ,
                           var_aae076  ,
                           '1',
                           prm_aae011  ,
                           prm_yab139  ,
                           prm_AppCode ,
                           prm_ErrorMsg);

     IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
         RETURN;
     END IF;


     --�������Ϸ�����Դ
     UPDATE wsjb.irab08
        SET yae010 = var_yae010_110
      WHERE aab001 = prm_aab001
        AND yae517 IN ('H17','H12')
        AND aae140 = '01'
        AND aae003 = num_yae097;
     --�������ϸ��˷�����Դ
     UPDATE wsjb.irac08a1
        SET yae010 = var_yae010_110
      WHERE aab001 = prm_aab001
        AND aae003 = num_yae097
        AND aae140 = '01'
        AND aae143 = '05';

       IF prm_yab019 = '1' THEN  --��ҵ�����걨
       --���뵥λ�����־
       INSERT INTO xasi2.ab05 (aab001,
                                  aae001,
                                  yab007,
                                  aae011)
                          VALUES (prm_aab001,
                                  prm_aae001,
                                  xasi2.pkg_comm.YAB007_YNS,
                                  prm_aae011);
       --���������ֹʱ��
        UPDATE xasi2.ab02
           SET aae042 = prm_aae001||'12'
         WHERE aab001 = prm_aab001;
       END IF ;

     /**  IF prm_yab019 = '2' THEN --������������
         IF prm_yab139 <> PKG_Constant.YAB003_JBFZX THEN --���Ǹ������ĵ�λinsert ab05
             --���뵥λ�����־
           INSERT INTO xasi2.ab05 (aab001,
                                      aae001,
                                      yab007,
                                      aae011)
                              VALUES (prm_aab001,
                                      prm_aae001,
                                      xasi2.pkg_comm.YAB007_YNS,
                                      prm_aae011);
         END IF ;
           --���������ֹʱ��
        UPDATE xasi2.ab02
           SET aae042 = prm_aae001||'12'
         WHERE aab001 = prm_aab001
           AND aae140 = '06';
       END IF ;
     */


     SELECT MAX(yae097)
       INTO num_yae097
       FROM (SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(yae097),'yyyymm'),1),'yyyymm')) AS yae097   --��ȡ�����ں�
               FROM xasi2.ab02
              WHERE aab001 = prm_aab001
              UNION
             SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(aae003),'yyyymm'),1),'yyyymm')) AS yae097
               FROM wsjb.irab08
              WHERE aab001 = prm_aab001
                AND yae517 = 'H01'  );
     --������˱������ں�
     UPDATE wsjb.irad51
        SET aae003 = num_yae097
      WHERE aab001 = prm_aab001
        AND aae001 = prm_aae001
        AND iaa011 = prm_iaa011;
   EXCEPTION
        WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
             RETURN;
END prc_YearSalaryBC;
/*****************************************************************************
   ** �������� : prc_YearSalaryBCByYL
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���--���ϲ���
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ���
   **           prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
   **           prm_aae011       IN     irad31.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-09   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
PROCEDURE prc_YearSalaryBCByYL(prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                               prm_aae001       IN     NUMBER            ,--�������
                               prm_aae002       IN     NUMBER            ,
                               prm_yab222       IN     xasi2.ab08.yab222%TYPE,
                               prm_aae076       IN     xasi2.ab08.aae076%TYPE,
                               prm_type         IN     VARCHAR2,  --1Ϊ��ƽ����ǰ 2Ϊ��ƽ������
                               prm_aae011       IN     irad31.aae011%TYPE,--������
                               prm_yab139       IN     VARCHAR2          ,--�α�����������
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          )
   IS
       num_count     NUMBER;
      v_msg        VARCHAR2(300);
      var_aaz002   irad31.aaz002%TYPE;
      num_aae041_year NUMBER(6);  --���ʼʱ��
      num_yae097   xasi2.ab02.yae097%TYPE; --��λ��������ں�
      var_aae140   xasi2.ab02.aae140%TYPE; --����
      var_aac001   xasi2.ac01.aac001%TYPE; --���˱��
      num_aae002   xasi2.ac08a1.aae002%TYPE;
      num_aac040   xasi2.ac02.aac040%TYPE;
      num_spgz     xasi2.ac02.aac040%TYPE;
      num_yac004   xasi2.ac02.yac004%TYPE;
      var_yab136   xasi2.ab01.yab136%TYPE;
      var_yab275   xasi2.ab01.yab275%TYPE;
      var_aae119   xasi2.ab01.aae119%TYPE;
      var_aab019   xasi2.ab01.aab019%TYPE;
      var_yac503   xasi2.ac02.yac503%TYPE;
      var_yac505   xasi2.ac02.yac505%TYPE;
      num_yac401   tmp_ac42.yac401%type;           --1�²�����,NUMBER
      num_yac402   tmp_ac42.yac401%type;           --2�²�����,NUMBER
      num_yac403   tmp_ac42.yac401%type;           --3�²�����,NUMBER
      num_yac404   tmp_ac42.yac401%type;           --4�²�����,NUMBER
      num_yac405   tmp_ac42.yac401%type;           --5�²�����,NUMBER
      num_yac406   tmp_ac42.yac401%type;           --6�²�����,NUMBER
      num_yac407   tmp_ac42.yac401%type;           --7�²�����,NUMBER
      num_yac408   tmp_ac42.yac401%type;           --8�²�����,NUMBER
      num_yac409   tmp_ac42.yac401%type;           --9�²�����,NUMBER
      num_yac410   tmp_ac42.yac401%type;           --10�²�����,NUMBER
      num_yac411   tmp_ac42.yac401%type;           --11�²�����,NUMBER
      num_yac412   tmp_ac42.yac401%type;           --12�²�����,NUMBER
      var_procNo   VARCHAR2(5);                    --���̺�
      var_aae013   xasi2.ab08a8.aae013%TYPE;
      var_aae100   VARCHAR2(9);
      var_yae099   xasi2.ac04a3.yae099%TYPE;
      var_yae518   xasi2.ab08.yae518%TYPE;
      --��ȡ��λ�ύ���걨��Ա
      CURSOR cur_tmp_ac42 IS
        select AAC001,             --��Ա���,VARCHAR2
               AAB001,             --��λ���,VARCHAR2
               AAE140,             --����,VARCHAR2
               YAC401,             --1�²�����,NUMBER
               YAC402,             --2�²�����,NUMBER
               YAC403,             --3�²�����,NUMBER
               YAC404,             --4�²�����,NUMBER
               YAC405,             --5�²�����,NUMBER
               YAC406,             --6�²�����,NUMBER
               YAC407,             --7�²�����,NUMBER
               YAC408,             --8�²�����,NUMBER
               YAC409,             --9�²�����,NUMBER
               YAC410,             --10�²�����,NUMBER
               YAC411,             --11�²�����,NUMBER
               YAC412,             --12�²�����,NUMBER
               AAE013,             --��ע,VARCHAR2
               aae001
          from wsjb.tmp_ac42   --��Ա���ֲ�����Ϣ��
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND aae140 = PKG_Constant.AAE140_YL
           AND 1 = DECODE(prm_type,'1',1,0)
        UNION
        select AAC001,             --��Ա���,VARCHAR2
               AAB001,             --��λ���,VARCHAR2
               AAE140,             --����,VARCHAR2
               YAC401,             --1�²�����,NUMBER
               YAC402,             --2�²�����,NUMBER
               YAC403,             --3�²�����,NUMBER
               YAC404,             --4�²�����,NUMBER
               YAC405,             --5�²�����,NUMBER
               YAC406,             --6�²�����,NUMBER
               YAC407,             --7�²�����,NUMBER
               YAC408,             --8�²�����,NUMBER
               YAC409,             --9�²�����,NUMBER
               YAC410,             --10�²�����,NUMBER
               YAC411,             --11�²�����,NUMBER
               YAC412,             --12�²�����,NUMBER
               AAE013,             --��ע,VARCHAR2
               aae001
          from wsjb.tmp_ac43   --��Ա���ֶ��β�����Ϣ��
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND aae140 = PKG_Constant.AAE140_YL
           AND 1 = DECODE(prm_type,'2',1,0);


   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      var_procNo   :='Y01';
      var_yae518   := xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAE518');
      num_aae002   := prm_aae002;
      --����У��
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λ��Ų���Ϊ��' ;
         RETURN;
      END IF;

      IF prm_aae001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '������Ȳ���Ϊ��' ;
         RETURN;
      END IF;
      IF num_aae002 IS NULL THEN
         SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(aae003),'yyyymm'),1),'yyyymm'))
           INTO num_aae002
           FROM wsjb.irab08
          WHERE aab001 = prm_aab001
            AND yae517 = xasi2.pkg_comm.yae517_H01;
      END IF;

      --��ȡ��λ��ǰ�Ĺ�������
      BEGIN
         SELECT yab136,
                yab275,
                aae119,
                aab019
           INTO var_yab136,
                var_yab275,
                var_aae119,
                var_aab019
           FROM xasi2.ab01
          WHERE aab001 = prm_aab001;
      EXCEPTION
         WHEN OTHERS THEN
              prm_AppCode := ''||var_procNo||'02';
              prm_ErrorMsg  := '��λ����'||prm_aab001||'�籣�������'||prm_yab139||'û�л�ȡ����λ������Ϣ';
              RETURN;
      END;

      --ѭ����ȡ��Ա�����ʱ��
      FOR rec_tmp_ac42 IN cur_tmp_ac42 LOOP
           --����TMP_ac42���벹�����ʱ����
           var_aac001 := rec_tmp_ac42.aac001;
           --1�²���
           IF rec_tmp_ac42.yac401 <> 0 THEN
               prc_insertIRAC08A1(prm_aab001  ,
                                  var_aac001  ,
                                  prm_aae001||'01'  ,
                                  num_aae002,
                                  rec_tmp_ac42.yac401,
                                  var_yae518  ,
                                  prm_aae076,
                                  prm_aae011  ,
                                  prm_yab139  ,
                                  prm_AppCode ,
                                  prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac402 <> 0 THEN   --2�²���
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'02'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac402,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac403 <> 0 THEN   --���²���
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'03'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac403,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac404 <> 0 THEN   --4�²���
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'04'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac404,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac405 <> 0 THEN   --5�²���
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'05'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac405,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac406 <> 0 THEN    --6�²���
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'06'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac406,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac407 <> 0 THEN   --7�²���
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'07'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac407,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac408 <> 0 THEN    --8�²���
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'08'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac408,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac409 <> 0 THEN   --9�²���
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'09'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac409,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac410 <> 0 THEN    --10�²���
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'10'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac410,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac411 <> 0 THEN   --11�²���
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'11'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac411,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac412 <> 0 THEN   --12�²���
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'12'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac412,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
          END IF;
      END LOOP;


      --����
      INSERT INTO wsjb.irab08 ( YAE518,
                          AAB001,
                          AAE140,
                          AAE003,
                          AAE041,
                          AAE042,
                          YAB538,
                          YAE010,
                          AAB165,
                          AAB166,
                          YAE517,
                          YAB222,
                          YAE231,
                          YAE203,
                          AAB120,
                          AAB121,
                          AAB150,
                          YAB031,
                          AAB151,
                          AAB152,
                          AAB153,
                          YAB040,
                          AAB154,
                          AAB155,
                          YAB217,
                          AAB157,
                          AAB158,
                          AAB159,
                          AAB160,
                          AAB161,
                          AAB162,
                          YAB042,
                          YAB046,
                          YAB059,
                          YAB215,
                          YAB381,
                          YAB146,
                          YAB147,
                          YAB148,
                          YAB149,
                          YAB218,
                          AAB214,
                          AAB156,
                          YAB400,
                          YAB401,
                          AAB163,
                          AAB164,
                          YAB541,
                          YAB542,
                          YAB543,
                          YAB544,
                          YAB546,
                          AAB019,
                          AAB020,
                          AAB021,
                          AAB022,
                          YAE526,
                          AAE068,
                          AAE076,
                          AAB191,
                          YAD180,
                          YAA011,
                          YAA012,
                          YAB139,
                          AAE011,
                          AAE036,
                          YAB003,
                          AAE013)
                   SELECT yae518,
                          aab001,
                          aae140,
                          num_aae002,
                          MIN(aae002),
                          MAX(aae002),
                          '1',
                          yae010,
                          '0',
                          '1',
                          'H12',
                          prm_yab222,
                          count(DISTINCT aac001) yae231,
                          1.0000,
                          sum(aac040) aab120,
                          sum(aac040) aab121,
                          sum(yab157) aab150,
                          SUM(yab158),
                          SUM(AAB212),
                          SUM(AAB213),
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          SUM(yab157+yab158+aab212+aab213),
                          '1',
                          '0',
                          sysdate,
                          sysdate,
                          0,
                          0,
                          0,
                          0,
                          0,
                          null,
                          null,
                          null,
                          null,
                          null,
                          null,
                          prm_aae076,
                          null,
                          null,
                          '2',
                          '1',
                          prm_yab139,
                          prm_aae011,
                          sysdate,
                          prm_yab139,
                          '���ϲ���'
                     FROM wsjb.irac08a1
                    WHERE yae518 = var_yae518
                      AND aac040 >0
                    GROUP BY aae140,yae518,aab001,yae010;
      --����
      INSERT INTO wsjb.irab08 ( YAE518,
                          AAB001,
                          AAE140,
                          AAE003,
                          AAE041,
                          AAE042,
                          YAB538,
                          YAE010,
                          AAB165,
                          AAB166,
                          YAE517,
                          YAB222,
                          YAE231,
                          YAE203,
                          AAB120,
                          AAB121,
                          AAB150,
                          YAB031,
                          AAB151,
                          AAB152,
                          AAB153,
                          YAB040,
                          AAB154,
                          AAB155,
                          YAB217,
                          AAB157,
                          AAB158,
                          AAB159,
                          AAB160,
                          AAB161,
                          AAB162,
                          YAB042,
                          YAB046,
                          YAB059,
                          YAB215,
                          YAB381,
                          YAB146,
                          YAB147,
                          YAB148,
                          YAB149,
                          YAB218,
                          AAB214,
                          AAB156,
                          YAB400,
                          YAB401,
                          AAB163,
                          AAB164,
                          YAB541,
                          YAB542,
                          YAB543,
                          YAB544,
                          YAB546,
                          AAB019,
                          AAB020,
                          AAB021,
                          AAB022,
                          YAE526,
                          AAE068,
                          AAE076,
                          AAB191,
                          YAD180,
                          YAA011,
                          YAA012,
                          YAB139,
                          AAE011,
                          AAE036,
                          YAB003,
                          AAE013)
                   SELECT yae518,
                          aab001,
                          aae140,
                          num_aae002,
                          MIN(aae002),
                          MAX(aae002),
                          '1',
                          yae010,
                          '0',
                          '1',
                          'H17',
                          prm_yab222,
                          count(DISTINCT aac001) yae231,
                          1.0000,
                          sum(aac040) aab120,
                          sum(aac040) aab121,
                          sum(yab157) aab150,
                          SUM(yab158),
                          SUM(AAB212),
                          SUM(AAB213),
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          SUM(yab157+yab158+aab212+aab213),
                          '1',
                          '0',
                          sysdate,
                          sysdate,
                          0,
                          0,
                          0,
                          0,
                          0,
                          null,
                          null,
                          null,
                          null,
                          null,
                          null,
                          prm_aae076,
                          null,
                          null,
                          '2',
                          '1',
                          prm_yab139,
                          prm_aae011,
                          sysdate,
                          prm_yab139,
                          '���ϲ���'
                     FROM wsjb.irac08a1
                    WHERE yae518 = var_yae518
                      AND aac040 < 0
                    GROUP BY aae140,yae518,aab001,yae010;

   EXCEPTION
        WHEN OTHERS THEN
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
             RETURN;
END prc_YearSalaryBCByYL;
/*****************************************************************************
   ** �������� : prc_YearSalaryBC
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���--����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ���
   **           prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
   **           prm_aae011       IN     irad31.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-09   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
PROCEDURE prc_insertIRAC08A1(prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                             prm_aac001       IN     xasi2.ac01.aac001%TYPE,
                             prm_aae002       IN     NUMBER            ,--�������
                             prm_aae003       IN     NUMBER,
                             prm_aac040       IN     xasi2.ac02.aac040%TYPE,
                             prm_yae518       IN     xasi2.ac08a1.yae518%TYPE,
                             prm_aae076       IN     xasi2.ab08.aae076%TYPE,
                             prm_aae011       IN     irad31.aae011%TYPE,--������
                             prm_yab139       IN     VARCHAR2          ,--�α�����������
                             prm_AppCode      OUT    VARCHAR2          ,
                             prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      num_count     NUMBER;
      v_msg        VARCHAR2(300);
      var_yae010   xasi2.ac08a1.yae010%TYPE;
      var_aab019   irab01.aab019%TYPE;

   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      SELECT NVL(yae010_110,1)
        INTO var_yae010
        FROM wsjb.irab03
       WHERE aab001 = prm_aab001;

      SELECT aab019
        INTO var_aab019
        FROM xasi2.ab01
       WHERE aab001 = prm_aab001;

      INSERT INTO wsjb.irac08a1 (YAE202,             --��ϸ��ˮ��,VARCHAR2
                           AAC001,             --���˱��,VARCHAR2
                           AAB001,             --��λ���,VARCHAR2
                           AAE140,             --��������,VARCHAR2
                           AAE003,             --�����ں�,NUMBER
                           AAE002,             --�ѿ�������,NUMBER
                           AAE143,             --�ɷ�����,VARCHAR2
                           YAE010,             --������Դ,VARCHAR2
                           YAC505,             --�α��ɷ���Ա���,VARCHAR2
                           YAC503,             --�������,VARCHAR2
                           AAC040,             --�ɷѹ���,NUMBER
                           YAA333,             --�˻�����,NUMBER
                           AAE180,             --�ɷѻ���,NUMBER
                           YAB157,             --���˽ɷѻ����ʻ����,NUMBER
                           YAB158,             --���˽ɷѻ���ͳ����,NUMBER
                           AAB212,             --��λ�ɷѻ����ʻ����,NUMBER
                           AAB213,             --��λ�ɷѻ���ͳ����,NUMBER
                           AAB162,             --Ӧ�����ɽ���,NUMBER
                           YAE518,             --�˶���ˮ��,VARCHAR2
                           AAE076,             --�ƻ���ˮ��,VARCHAR2
                           AAE011,             --������,NUMBER
                           AAE036,             --����ʱ��,DATE
                           YAB003,             --�籣�������,VARCHAR2
                           YAB139,             --�α�����������,VARCHAR2
                           AAE114)             --�ɷѱ�־,VARCHAR2)
                   VALUES (xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAE202'),
                           prm_aac001,
                           prm_aab001,
                           '01',
                           prm_aae003,
                           prm_aae002,
                           '05',
                           var_yae010,
                           '010',
                           '0',
                           prm_aac040,
                           prm_aac040,
                           prm_aac040,
                           round(prm_aac040*0.08,2),
                           0,
                           0,
                           CASE WHEN var_aab019 = '60' THEN round(prm_aac040*0.12,2) ELSE round(prm_aac040*0.2,2) END,
                           0,
                           prm_yae518,
                           prm_aae076,
                           prm_aae011,
                           sysdate,
                           prm_yab139,
                           prm_yab139,
                           '2');
       IF SQL%ROWCOUNT < 1 THEN
          prm_AppCode  :=  gn_def_ERR;
          prm_ErrorMsg := '��λ���:'||prm_aab001||',�ں�'||prm_aae003||'���ɲ���ɷ���Ϣ��������' ;
          RETURN;
       END IF;

   EXCEPTION
        WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
             RETURN;
END prc_insertIRAC08A1;
    /*****************************************************************************
   ** �������� : prc_YearInternetAudit
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����˶��������
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
                 prm_iaa018       IN     irad52.iaa018%TYPE,--��˱�־
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2013-05-25   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_YearInternetAudit(
                                    prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
                                    prm_aae001       IN     xasi2.ac01k8.aae001%TYPE,--������
                                    prm_iaa018       IN     irad52.iaa018%TYPE,--��˱�־
                                   prm_yae092       IN     iraa01a1.aae011%TYPE,--������
                                   prm_iaa011       IN     irad51.iaa011%TYPE,--ҵ������
                                   prm_yab019       IN     VARCHAR2 , --���ͱ�־ 1--��ҵ�����걨 2--�������ϻ����걨
                                   prm_AppCode      OUT    VARCHAR2          ,
                                   prm_ErrorMsg     OUT    VARCHAR2    )
    IS
      n_count NUMBER(6);
      v_iaz004 irad02.iaz004%TYPE;
      v_iaz009 irad22.iaz009%TYPE;
      v_aaz002 irad51.aaz002%TYPE;

    BEGIN
      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;

      /*��Ҫ������У��*/
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λ��Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '������Ա��Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa018 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��˱�־����Ϊ��!';
         RETURN;
      END IF;

      IF prm_aae001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�����Ȳ���Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := 'ҵ�����Ͳ���Ϊ��!';
         RETURN;
      END IF;

        SELECT count(1)
          INTO n_count
          FROM wsjb.irad51
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND iaa011 = prm_iaa011
           AND iaa002 = '1'
           AND iaa006 = '0';
        IF n_count = 0 THEN
           prm_AppCode := gn_def_ERR;
           prm_ErrorMsg := 'δ�ҵ�������Ϣ!';
           RETURN;
        END IF;

      SELECT iaz004
        INTO v_iaz004
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND iaa011 = prm_iaa011
         AND iaa002 = '1'
         AND iaa006 = '0';


        v_iaz009 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ009');
           IF v_iaz009 IS NULL OR v_iaz009 = '' THEN
              ROLLBACK;
              prm_ErrorMsg := 'û�л�ȡ�����к�IAZ009!';
              RETURN;
           END IF;
         v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
           IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
              ROLLBACK;
              prm_ErrorMsg := 'û�л�ȡ�����к�v_aaz002!';
              RETURN;
           END IF;



      --���ͨ��
      IF prm_iaa018 = '2' THEN
        INSERT INTO wsjb.irad52  (
                            iaz009,
                            aaz002,
                            iaz004,
                            aab001,
                            iaa011,
                            aee011,
                            aae035,
                            yab003,
                            aae001,
                            iaa018)values(
                            v_iaz009,
                            v_aaz002,
                            v_iaz004,
                            prm_aab001,
                            prm_iaa011,
                            prm_yae092,
                            sysdate,
                            PKG_Constant.YAB003_JBFZX,
                            prm_aae001,
                            prm_iaa018
                            );
        prc_YearSalary(prm_aab001,--��λ���  ����
                       prm_aae001,--�������
                       prm_yae092,--������
                       PKG_Constant.YAB003_JBFZX,--�α�����������
                       prm_yab019,
                       prm_AppCode ,
                       prm_ErrorMsg);
       IF prm_AppCode <> gn_def_OK THEN
           ROLLBACK;
          prm_AppCode  :=  gn_def_ERR;
          prm_ErrorMsg := '���ú˶�����prc_YearSalary����:'||prm_ErrorMsg;
          RETURN;
        END IF;
        UPDATE wsjb.irad51
            SET iaa002 = '2'
          WHERE aab001 = prm_aab001
          AND aae001 = prm_aae001
          AND iaa011 = prm_iaa011
          AND iaa002 = '1'
          AND iaa006 = '0';

      ELSIF prm_iaa018 = '3' THEN    --��˲�ͨ��
         UPDATE xasi2.ac01k8
            SET iaa002 = '3',
                aae036 = sysdate,
                aae011 = prm_yae092
          WHERE AAB001 = prm_aab001
            AND aae001 = prm_aae001
            AND yab019 = prm_yab019
            AND iaa002 = '1';

        UPDATE wsjb.irad51
           SET iaa002 = '3'
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND iaa011 = prm_iaa011
           AND iaa002 = '1'
           AND iaa006 = '0';
      ELSE
         prm_AppCode := gn_def_ERR;
         prm_ErrorMsg := '��˱�־����ȷ!';
         RETURN;
      END IF;

      INSERT INTO wsjb.AE02
                 (
                  AAZ002,
                  AAA121,
                  AAE011,
                  YAB003,
                  AAE014,
                  AAE016,
                  AAE216,
                  AAE217,
                  AAE218
                 )
                 VALUES
                 (
                  v_aaz002,
                  PKG_Constant.AAA121_YIR,
                  prm_yae092,
                  PKG_Constant.YAB003_JBFZX,
                  prm_yae092,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate
                 );
    EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
         RETURN;
   END prc_YearInternetAudit;
    /*****************************************************************************
   ** �������� : prc_YearInternetAuditRB
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����˶��������(����)
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
                 prm_iaa018       IN     wsjb.irad52 .iaa018%TYPE,--��˱�־
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2013-05-25   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_YearInternetAuditRB(
                                    prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
                                    prm_aae001       IN     xasi2.ac01k8.aae001%TYPE,--������
                                    prm_iaa011       IN     irad51.iaa011%TYPE,--ҵ������
                                    prm_yab019       IN     VARCHAR2          ,--���ͱ�־
                                   prm_AppCode      OUT    VARCHAR2          ,
                                   prm_ErrorMsg     OUT    VARCHAR2    )
    IS
    n_count NUMBER;
    v_aac001 irac01.aac001%TYPE;
    v_aab001 irac01.aab001%TYPE;
    v_iaz004 irad02.iaz004%TYPE;
    v_iaa018 irad22.iaa018%TYPE ; --��˱�־
    v_iaa002 irad51.iaa002%TYPE ; --���״̬

    CURSOR cur_ab05a1 IS --��ҵ�����걨
     SELECT iaz004,
            aac001,
            aab001,
            iaa002,
            yae099,
            aae001
       FROM xasi2.ac01k8
      WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND yab019 = prm_yab019;
    BEGIN
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;

    --��ѯ�걨��ˮ��
      SELECT DISTINCT iaz004
        INTO v_iaz004
       FROM xasi2.ac01k8
      WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND yab019 = prm_yab019
         AND iaa002 <> '0';

     --�Ƿ�����˼�¼
      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.irad52
       WHERE iaz004 = v_iaz004;
      IF n_count = 0 THEN
        prm_AppCode  := gn_def_ERR;
        prm_ErrorMsg := 'û����˼�¼�����ܻ�����ˣ�';
        RETURN;
      END IF;

      --�Ƿ��Ѿ�����
      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE iaz004 = v_iaz004
         AND iaa006 = '1';
      IF n_count > 0 THEN
        prm_AppCode  := gn_def_ERR;
        prm_ErrorMsg := '�õ�λ���в����¼�����ܻ�����ˣ�';
        RETURN;
      END IF;

      SELECT iaa018
        INTO v_iaa018
        FROM wsjb.irad52
       WHERE iaz004 = v_iaz004;

     IF v_iaa018 = '2' THEN
       --�������ͨ���Ļ���
         prc_YearSalaryRB(prm_aab001,--��λ���  ����
                         prm_aae001,--�������
                         prm_iaa011,--ҵ������
                         prm_yab019,--���ͱ�־
                         prm_AppCode ,
                         prm_ErrorMsg);
       IF prm_AppCode <> gn_def_OK THEN
           ROLLBACK;
          prm_AppCode  :=  gn_def_ERR;
          prm_ErrorMsg := '���ú˶�����prc_YearSalaryRB����:'||prm_ErrorMsg;
          RETURN;
        END IF;
        --�����걨��
        UPDATE wsjb.irad51
           SET iaa002 = '1'
          WHERE aab001 = prm_aab001
          AND aae001 = prm_aae001
          AND iaa011 = prm_iaa011
          AND iaa002 = '2'
          AND iaa006 = '0';
       --ɾ����˱�
       DELETE wsjb.irad52
        WHERE iaz004 = v_iaz004;

     ELSIF v_iaa018 = '3' THEN
       --������Ա���״̬
        UPDATE xasi2.ac01k8
           SET iaa002 = '1',
               aae036 = NULL,
               aae011 = NULL
         WHERE AAB001 = prm_aab001
           AND aae001 = prm_aae001
           AND yab019 = prm_yab019
           AND iaa002 = '2';
        --�����걨��
        UPDATE wsjb.irad51
           SET iaa002 = '1'
          WHERE aab001 = prm_aab001
          AND aae001 = prm_aae001
          AND iaa011 = prm_iaa011
          AND iaa002 = '3'
          AND iaa006 = '0';
       --ɾ����˱�
       DELETE wsjb.irad52
        WHERE iaz004 = v_iaz004;
     ELSE
        prm_AppCode := gn_def_ERR;
       prm_ErrorMsg := '��ȡ��˱�־����ȷ!';
       RETURN;
     END IF;

     EXCEPTION

      WHEN OTHERS THEN
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
         RETURN;
    END prc_YearInternetAuditRB;

    /*****************************************************************************
   ** �������� : prc_YearInternetBC
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����˶˲������
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
                prm_aae001       IN     xasi2_zs.ac01k8.aae001%TYPE,--������
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2013-05-25   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_YearInternetBC(
                                    prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
                                    prm_aae001       IN     xasi2.ac01k8.aae001%TYPE,--������
                                   prm_yae092       IN     iraa01a1.aae011%TYPE,--������
                                   prm_iaa011       IN     irad51.iaa011%TYPE ,--ҵ������
                                   prm_yab019       IN     VARCHAR2          ,--���ͱ�־
                                   prm_AppCode      OUT    VARCHAR2          ,
                                   prm_ErrorMsg     OUT    VARCHAR2    )
   IS
        n_count NUMBER(6);
       v_iaz004 irad02.iaz004%TYPE;
       v_aab004 xasi2.ab01.aab004%TYPE;
       v_msg   VARCHAR2(3000);
   BEGIN
      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;

      /*��Ҫ������У��*/
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λ��Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '������Ա��Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_aae001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�����Ȳ���Ϊ��!';
         RETURN;
      END IF;
      --�Ƿ��о߱��������Ϣ
      SELECT count(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND iaa011 = prm_iaa011
         AND iaa002 = '2'
         AND iaa006 = '0';
      IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := 'δ�ҵ����Բ���ĵ�λ���걨��Ϣ!';
         RETURN;
      END IF;
      --��ȡ�걨��ˮ��
      SELECT iaz004
        INTO v_iaz004
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND iaa011 = prm_iaa011;
      --�Ƿ��Ѿ���������
      SELECT count(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND iaa011 = prm_iaa011
         AND iaa002 = '2'
         AND iaa006 = '1';
      IF n_count > 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := '��λ�Ѿ��������������';
        RETURN;
      END IF;

      prc_YearSalaryBC(prm_aab001,--��λ���  ����
                       prm_aae001,--�������
                       prm_yae092,--������
                       PKG_Constant.YAB003_JBFZX,--�α�����������
                       prm_iaa011,--ҵ������
                       prm_yab019,--���ͱ�־
                       prm_AppCode,
                       prm_ErrorMsg);
      IF prm_AppCode <> gn_def_OK THEN
         ROLLBACK;
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := '���ú˶�����prc_YearSalaryBC����:'||prm_ErrorMsg;
        RETURN;
       END IF;
      UPDATE wsjb.irad51
         SET iaa006 = '1',
              yae092 = prm_yae092,
              aae036 = sysdate
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND iaa011 = prm_iaa011
         AND iaa002 = '2'
         AND iaa006 = '0';
         --��ѯ�Ƿ�������ԤԼ��Ϣ
      SELECT count(1)
        INTO n_count
        FROM wsjb.iraa16
       WHERE aab001 = prm_aab001
         AND iaz004 = v_iaz004
         AND aae120 = '0';
      IF n_count = 1 THEN
        UPDATE wsjb.iraa16  SET aaa170 = '1'
         WHERE aab001 = prm_aab001
         AND iaz004 = v_iaz004;
      END IF ;

      DELETE FROM wsjb.IRAD23_TMP ;
       INSERT INTO wsjb.IRAD23_TMP (aab001) VALUES (prm_aab001);
       SELECT aab004
         INTO v_aab004
         FROM xasi2.ab01
        WHERE  aab001 = prm_aab001;
       v_msg := v_aab004||'�û�������'||prm_aae001||'��Ȼ����걨�����ͨ�������ڣ�'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||',�밴�մ�ӡ���ݾ��첹��.';
       PKG_Insurance.prc_MessageSend(prm_yae092,
                                     prm_iaa011,
                                     v_msg,
                                     prm_AppCode,
                                      prm_ErrorMsg);
       IF prm_AppCode <> gn_def_OK THEN
          ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '������Ϣ���͹���prc_MessageSend����:' ||prm_ErrorMsg || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
       END IF;

      EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
         RETURN;
   END prc_YearInternetBC;
   /*****************************************************************************
   ** �������� : prc_UpdateAb05a1
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����������ab05a1���»���
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2013-05-25   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_UpdateAb05a1(
         prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
         prm_aaz002       IN     tmp_ac40.aaz002%TYPE,--�������κ�
        prm_yae092       IN     iraa01a1.aae011%TYPE,--������
        prm_aae001       IN     VARCHAR2,--�걨���
        prm_iaa011       IN     irad51.iaa011%TYPE ,--ҵ������
        prm_yab019       IN     VARCHAR2           ,--���ͱ�־
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             )
   IS
      n_count NUMBER(8);
      n_aac040 NUMBER(14,2);
      n_yac004 NUMBER(14,2);--���ϻ���
      n_yac005 NUMBER(14,2);--ҽ�ƻ���
      n_yaa444 NUMBER(14,2);--�¹��˻���
      v_aac001 irac01.aac001%TYPE;
      v_aac002 irac01.aac002%TYPE;
      v_aac003 irac01.aac003%TYPE;
      v_aab001 irac01.aab001%TYPE;
      v_aae110 irac01.aae110%TYPE;
      v_aae210 irac01.aae210%TYPE;
      v_aae310 irac01.aae310%TYPE;
      v_aae410 irac01.aae410%TYPE;
      v_aae510 irac01.aae510%TYPE;
      v_aab019 irab01.aab019%TYPE;
      v_aae002 VARCHAR2(9);--�����¶�
      v_yae097 VARCHAR2(9);--��λ���������

      CURSOR cur_tmp_ac40 IS
          SELECT aab001,
                 aac001,
                 aac002,
                 aac003,
                 aac040,
                 yac004
            FROM wsjb.tmp_ac40
           WHERE aaz002 = prm_aaz002
             AND aab001 = prm_aab001;

   BEGIN
     /*��ʼ������*/
    prm_AppCode  := gn_def_OK;
    prm_ErrorMsg := '';
     n_count  :=0;
     n_aac040 :=0;
     n_yac004 :=0;
     n_yac005 :=0;
     n_yaa444 :=0;

     /*��Ҫ������У��*/
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λ��Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '������Ա��Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_aaz002 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�������κŲ���Ϊ��!';
         RETURN;
      END IF;
     SELECT to_char(YAE097) as yae097,
           TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(YAE097), 'yyyyMM'), 1), 'yyyyMM') AS AAE002
      INTO v_yae097,v_aae002
      FROM xasi2.AA35
     WHERE AAE001 = prm_aae001;


     FOR rec_tmp_ac40 IN cur_tmp_ac40 LOOP
         n_aac040 :=0;
         n_yac004 :=0;
         n_yac005 :=0;
         n_yaa444 :=0;
         v_aae110 :='';
         v_aae210 :='';
         v_aae310 :='';
         v_aae410 :='';
         v_aae510 :='';

         v_aac001 := rec_tmp_ac40.aac001;
         v_aac002 := rec_tmp_ac40.aac002;
         v_aac003 := rec_tmp_ac40.aac003;
         v_aab001 := rec_tmp_ac40.aab001;
         n_aac040 := rec_tmp_ac40.aac040;

         SELECT count(1)
           INTO n_count
           FROM xasi2.ac01k8
          WHERE aab001 = v_aab001
            AND aae001 = prm_aae001;
         IF n_count = 0 THEN
           ROLLBACK;
           prm_AppCode  := gn_def_err;
           prm_ErrorMsg := '��λ'||v_aab001||'���������������ա�������ѯ�������ݺ����µ��������걨ģ����!';
           RETURN;
         END IF;
         SELECT count(1)
           INTO n_count
           FROM xasi2.ac01k8
          WHERE aab001 = v_aab001
            AND aac001 = v_aac001
            AND aac002 = v_aac002
            AND aac003 = v_aac003
            AND aae001 = prm_aae001;
         IF n_count = 0 THEN
           ROLLBACK;
           prm_AppCode  := gn_def_err;
           prm_ErrorMsg := 'û���ҵ�'||v_aac003||'('||v_aac002||','||v_aac001||')����Ϣ����������ٵ��롣';
           RETURN;
         END IF;
         IF n_aac040 IS NULL OR n_aac040 = 0 THEN
           ROLLBACK;
           prm_AppCode  := gn_def_err;
           prm_ErrorMsg := v_aac003||'('||v_aac002||','||v_aac001||')�Ĺ�����ϢΪ�ջ�0����������ٵ��롣';
           RETURN;
         END IF;
          IF n_aac040 IS NULL OR n_aac040 < 1800 THEN
           ROLLBACK;
           prm_AppCode  := gn_def_err;
           prm_ErrorMsg := v_aac003||'('||v_aac002||','||v_aac001||')�Ĺ�����ϢС��1800Ԫ����������ٵ��롣';
           RETURN;
         END IF;


       /*  ����ע�͵� ��Ϊ�������� �����Ĺ���prc_UpdateAc01k8  by whm 20190809 start
         --�жϸ�����״̬
        SELECT aae110,aae210,aae310,aae410,aae510
          INTO v_aae110,v_aae210,v_aae310,v_aae410,v_aae510
          FROM xasi2.ac01k8
         WHERE aab001 = v_aab001
            AND aac001 = v_aac001
            AND aac002 = v_aac002
            AND aac003 = v_aac003
            AND aae001 = prm_aae001
            AND yab019 = prm_yab019;

         IF v_aae210 IS NULL AND v_aae310 IS NULL AND v_aae410 IS NULL AND v_aae510 IS NULL THEN
           n_yac005 :=0;
         ELSE
           --ҽ�ƻ���
           SELECT
          pkg_common.fun_p_getcontributionbase(null,v_aab001,TRUNC(n_aac040,0),'0','03','1','1',v_aae002,PKG_Constant.YAB003_JBFZX)
          INTO n_yac005
          FROM dual;
          n_yaa444 := n_yac005;--���˻�����ֵ
        END IF;

         IF v_aae110 IS NOT NULL THEN
           SELECT count(1)
             INTO n_count
             FROM xasi2.ab02
            WHERE aab001 = v_aab001
              AND aae140 = '06'
              AND aab051 = '1';
           IF n_count = 0 THEN
             --���ϻ���
            SELECT
            pkg_common.fun_p_getcontributionbase(null,v_aab001,TRUNC(n_aac040,0),'0','01','1','1',v_aae002,PKG_Constant.YAB003_JBFZX)
            INTO n_yac004
            FROM dual;
          ELSE
            n_yac004 := rec_tmp_ac40.yac004;
          END IF;

         END IF;

        SELECT aab019 INTO v_aab019 FROM xasi2.ab01 WHERE aab001 = v_aab001;
        IF v_aae410 IS NOT NULL AND v_aab019 = '60' THEN
          --���廧���˻���
          SELECT
          pkg_common.fun_p_getcontributionbase(null,v_aab001,TRUNC(n_aac040,0),'0','04','1','1','999999',PKG_Constant.YAB003_JBFZX)
          INTO n_yaa444
          FROM dual;
        END IF;

        UPDATE xasi2.ac01k8
           SET aac040 = n_aac040,
                yac004 = n_yac004,
                yaa333 = n_yac005,
                yaa444 = n_yaa444
         WHERE aab001 = v_aab001
            AND aac001 = v_aac001
            AND aac002 = v_aac002
            AND aac003 = v_aac003
            AND aae001 = prm_aae001
            AND yab019 = prm_yab019;
    ����ע�͵� ��Ϊ�������� �����Ĺ���prc_UpdateAc01k8  by whm 20190809 end;
    */

    -- ���õ����ĸ���Ac01k8
     prc_UpdateAc01k8 (
        v_aab001    ,--�걨��λ
        v_aac001    ,--���˱��
        prm_aae001    ,--�걨���
        n_aac040    , --�½ɷѹ���
        prm_AppCode   ,
        prm_ErrorMsg  );

       END LOOP;


     EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
         RETURN;

   END prc_UpdateAb05a1;

--����AC01K8
PROCEDURE prc_UpdateAc01k8 (
        prm_aab001       IN     xasi2.ac01k8.aab001%TYPE,--�걨��λ
        prm_aac001       IN     xasi2.ac01k8.aac001%TYPE,--���˱��
        prm_aae001       IN     xasi2.ac01k8.aae001%TYPE,--�걨���
        prm_aac040       IN     xasi2.ac01k8.aac040%TYPE, --�½ɷѹ���
        prm_AppCode   OUT    VARCHAR2,
        prm_ErrorMsg    OUT    VARCHAR2)
 IS

 var_yab136     VARCHAR2(6);  --AB01��λ��������
 var_aab019     VARCHAR2(6);
 var_aae002     NUMBER(6);     --�ѿ�������
 var_yab003     VARCHAR2(6);
 num_yaa333     NUMBER(14,2);  --����ƽ����
 num_yac004     NUMBER(14,2);  --ʡ��ƽ����
 num_yaa444     NUMBER(14,2);  --���˻���
 num_spgz       xasi2.ac02.aac040%TYPE;

 cursor cur_aae140 is  --ac01k8 �и��˿��Բ��������(��ר��)
   select decode(aae140,
                 'AAE110','01',
                 'AAE210','02',
                 'AAE310','03',
                 'AAE410','04',
                 'AAE510','05',
                 'AAE311','07') AS aae140,
                 aac031
    from xasi2.ac01k8 unpivot
    (aac031 for aae140 in(aae110,aae210, aae310,aae410,aae510, aae311))
   where aab001 = prm_aab001
     and aac001 = prm_aac001
     and aae001 = prm_aae001;


 BEGIN
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      var_yab003 := '610127';


      SELECT --to_char(YAE097) as yae097,
       TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(YAE097), 'yyyyMM'), 1), 'yyyyMM') AS AAE002
       INTO var_aae002
      FROM xasi2.AA35
     WHERE AAE001 = prm_aae001;


      --��ȡ��λ��ǰ�Ĺ�������
      BEGIN
         SELECT yab136,aab019
           INTO var_yab136, var_aab019
           FROM xasi2.ab01
          WHERE aab001 = prm_aab001;
      EXCEPTION
         WHEN OTHERS THEN
              prm_AppCode  :=  gn_def_ERR;
              prm_ErrorMsg  := '��λ����'||prm_aab001||'û�л�ȡ����λ��������';
              RETURN;
      END;

    FOR rec_aae140 IN cur_aae140 LOOP
      BEGIN
             IF rec_aae140.aae140 IN ('03','05') THEN
                 --����ƽ���׷ⶥ
                 SELECT pkg_common.fun_p_getcontributionbase(
                                                    null,                              --���˱��� aac001
                                                    prm_aab001,                        --��λ���� aab001
                                                    ROUND(prm_aac040),                 --�ɷѹ��� aac040
                                                    '0',                               --������� yac503
                                                    rec_aae140.aae140,                 --�������� aae140
                                                    '1',                               --�ɷ���Ա��� yac505
                                                    var_yab136,                        --��λ�������ͣ���������ɷ���Ա�� yab136
                                                    var_aae002,                        --�ѿ������� aae002
                                                    var_yab003)                         --�α������� yab139
                    INTO num_yaa333
                 FROM dual;

             ELSIF rec_aae140.aae140 IN ('02','04') THEN
                 --ʡ��ƽ���׷ⶥ(19��������ʧҵ һ����ҵ�͸��幤�̶���60%��300% ������yaa444)
                 SELECT pkg_common.fun_p_getcontributionbase(
                                                    null,                                --���˱��� aac001
                                                    prm_aab001,                          --��λ���� aab001
                                                    ROUND(prm_aac040),                   --�ɷѹ��� aac040
                                                    '0',                                 --������� yac503
                                                    rec_aae140.aae140,                   --�������� aae140
                                                    '1',                                 --�ɷ���Ա��� yac505
                                                    var_yab136,                          --��λ�������ͣ���������ɷ���Ա�� yab136
                                                    var_aae002,                          --�ѿ������� aae002
                                                    var_yab003)                          --�α������� yab139
                    INTO num_yaa444
                 FROM dual;

             ELSIF rec_aae140.aae140 = '01'THEN
                     --����(���ϱ��׷ⶥ���Ѿ�������һ����ҵ�͸��幤��)
                     SELECT pkg_common.fun_p_getcontributionbase(
                                                    null,                                --���˱��� aac001
                                                    prm_aab001,                          --��λ���� aab001
                                                    ROUND(prm_aac040),                   --�ɷѹ��� aac040
                                                    '0',                                 --������� yac503
                                                    rec_aae140.aae140,                   --�������� aae140
                                                    '1',                                 --�ɷ���Ա��� yac505
                                                    var_yab136,                          --��λ�������ͣ���������ɷ���Ա�� yab136
                                                    var_aae002,                          --�ѿ������� aae002
                                                    var_yab003)                          --�α������� yab139
                  INTO num_yac004
               FROM dual;
              
            END IF;
      EXCEPTION
         WHEN OTHERS THEN
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg  := '���˱��'||prm_aac001||'û�л�ȡ������:'||rec_aae140.aae140||'�ı��׷ⶥ����';
             RETURN;
      END;
    END LOOP;

    UPDATE xasi2.ac01k8
       SET aac040 = prm_aac040,
              yaa333 = num_yaa333,
              yac004 = num_yac004,
              yaa444 = num_yaa444
     WHERE aab001 = prm_aab001
       AND aac001 = prm_aac001
       AND aae001 = prm_aae001
       AND yab019 = '1'
       AND (aae013 is null or aae013 ='1' or aae013 ='22');     -- ��ǰ����Ĳ���(aae013=2��21)
       

 EXCEPTION
        WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
             RETURN;
END prc_UpdateAc01k8;

   /*****************************************************************************
   ** �������� : prc_YearSalaryBCBySP
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����ƽ�����󲹲�
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2013-05-25   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_YearSalaryBCBySP (prm_aab001       IN     irab01.aab001%TYPE,--��λ���  �Ǳ���
                               prm_yab139       IN     VARCHAR2          ,--�α�����������
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          )
   IS
    var_aae013  VARCHAR2(750);
     num_count    NUMBER;
     num_aae001   NUMBER(4);
     num_aae003  NUMBER(6);
     var_aab001  irab01.aab001%TYPE;
     var_aae140  irab02.aae140%TYPE;
     num_yac004_old  NUMBER(14,2);
     num_yac004  NUMBER(14,2);
     num_yae097  NUMBER(6);
     num_aae041  NUMBER(6);
     num_yac004_ce NUMBER(14,2);
     var_aac001  irac01.aac001%TYPE;
     var_yae235  irad55.yae235%TYPE;
     var_yae238  irad55.yae238%TYPE;
     num_yac401   tmp_ac42.yac401%type;           --1�²�����,NUMBER
     num_yac402   tmp_ac42.yac401%type;           --2�²�����,NUMBER
     num_yac403   tmp_ac42.yac401%type;           --3�²�����,NUMBER
     num_yac404   tmp_ac42.yac401%type;           --4�²�����,NUMBER
     num_yac405   tmp_ac42.yac401%type;           --5�²�����,NUMBER
     num_yac406   tmp_ac42.yac401%type;           --6�²�����,NUMBER
     num_yac407   tmp_ac42.yac401%type;           --7�²�����,NUMBER
     num_yac408   tmp_ac42.yac401%type;           --8�²�����,NUMBER
     num_yac409   tmp_ac42.yac401%type;           --9�²�����,NUMBER
     num_yac410   tmp_ac42.yac401%type;           --10�²�����,NUMBER
     num_yac411   tmp_ac42.yac401%type;           --11�²�����,NUMBER
     num_yac412   tmp_ac42.yac401%type;           --12�²�����,NUMBER
     num_aae002_max NUMBER(6);
     var_yab136    irab01.yab136%TYPE;
     var_yab275    irab01.yab275%TYPE;
     var_aae119    irab01.aae119%TYPE;
     var_aab019    irab01.aab019%TYPE;
     var_yac503    irac01.yac503%TYPE;
     var_yac505    irac01.yac505%TYPE;
     num_spgz      NUMBER(14,2);
     var_yae099    xasi2.ae16.yae099%TYPE;
     cursor cur_irad55 IS
     SELECT *
       FROM wsjb.irad55
      WHERE aae100 = num_aae001
        AND yae235 = '0';
     --��ȡ���󲹲�������Ϣ
     cursor cur_aae140 IS
         SELECT aae140 AS aae140
           FROM xasi2.ab08a8
          WHERE yae517 IN ('H12','H17')
            AND aae003 = num_aae003
            AND aab001 = var_aab001
         UNION
         SELECT aae140 AS aae140
           FROM wsjb.irab08
          WHERE yae517 IN ('H12','H17')
            AND aae003 = num_aae003
            AND aab001 = var_aab001;
     --��ȡ��Ҫ�������Ա��Ϣ
     cursor cur_info IS
     SELECT DISTINCT aac001
       FROM xasi2.ac08 a
      WHERE EXISTS(SELECT 1
                     FROM xasi2.ab08a8
                    WHERE yae517 IN ('H12','H17')
                      AND aae003 = num_aae003
                      AND aab001 = var_aab001
                      AND aae140 = var_aae140
                      AND yae518 = a.yae518)
     UNION
     SELECT DISTINCT aac001
       FROM xasi2.ac08a1 a
      WHERE EXISTS(SELECT 1
                     FROM xasi2.ab08
                    WHERE yae517 IN ('H12','H17')
                      AND aae003 = num_aae003
                      AND aab001 = var_aab001
                      AND aae140 = var_aae140
                      AND yae518 = a.yae518)
     UNION
     SELECT DISTINCT aac001
       FROM wsjb.irac08a1  a
      WHERE EXISTS(SELECT 1
                     FROM  wsjb.irab08
                    WHERE yae517 IN ('H12','H17')
                      AND aae003 = num_aae003
                      AND aab001 = var_aab001
                      AND aae140 = var_aae140
                      AND yae518 = a.yae518);
     cursor cur_yac004 IS
     SELECT aae013 AS yac004 ,
            aac001 AS aac001
       FROM  wsjb.tmp_ac43
      WHERE aab001 = var_aab001
        AND aae140 = var_aae140
        AND aae001 = num_aae001
        AND (yac401 <> 0 OR yac402<>0 OR yac403<>0 OR yac404<>0 OR yac405<>0 OR yac406<>0 OR yac407<>0 OR yac408<>0 OR yac409<>0 OR yac410<>0 OR yac411<>0 OR yac412<>0)
       ;
   BEGIN
     prm_AppCode  := PKG_Constant.gn_def_OK;
      prm_ErrorMsg := '';
      num_aae001 := TO_NUMBER(TO_CHAR(SYSDATE,'yyyy'));
      INSERT INTO wsjb.irad55
      SELECT iaz004,iaa011,aab001,aae001,111,SYSDATE,yab003,'0',NULL,aae003,num_aae001
        FROM wsjb.irad51  a
       WHERE iaa011 = 'A05'
         AND iaa002 = '2'
         AND iaa006 = '1'
         AND NOT EXISTS(SELECT 1 FROM wsjb.irad55  WHERE a.iaz004 = iaz004 AND aae001 = a.aae001 AND aab001 = a.aab001)
         AND (aab001 = prm_aab001 OR NVL(prm_aab001,1) = 1)
         AND aae001 = 2017
         --AND aae036 > TO_DATE('2018-02-05','yyyy-mm-dd')
         ;
      --ѭ��������β��λ
     FOR rec_irad55 IN cur_irad55 LOOP
         var_yae235 := xasi2.pkg_comm.yae235_CG;
         var_yae238 := '';
         var_aab001 := rec_irad55.aab001;
         num_aae003 := rec_irad55.aae003;
         num_aae001 := rec_irad55.aae001;
         BEGIN
           SELECT yab136,
                  yab275,
                  aae119,
                  aab019
             INTO var_yab136,
                  var_yab275,
                  var_aae119,
                  var_aab019
             FROM xasi2.ab01
            WHERE aab001 = prm_aab001;
        EXCEPTION
           WHEN OTHERS THEN
                prm_AppCode := PKG_Constant.gn_def_ERR||'02';
                prm_ErrorMsg  := '��λ����'||prm_aab001||'�籣�������'||prm_yab139||'û�л�ȡ����λ������Ϣ';
                RETURN;
        END;
         --ѭ����������
         num_aae041 := rec_irad55.aae001||'01';
         FOR rec_aae140 IN cur_aae140 LOOP
             var_aae140 := rec_aae140.aae140;
             --��ȡ������������ں�
             IF var_aae140 = '01' THEN
                SELECT MAX(aae003)
                  INTO num_yae097
                  FROM  wsjb.irab08
                 WHERE aab001 = var_aab001
                   AND yae517 = 'H01'
                   AND aae140 = var_aae140;
             ELSE
               SELECT YAE097
                 INTO num_yae097
                 FROM xasi2.ab02
                WHERE aab001 = var_aab001
                  AND aae140 = var_aae140;
             END IF;
             --�����Ϊ������ȣ����ں�Ϊ�������ĩ��
             IF SUBSTR(num_yae097,0,4) > rec_irad55.aae001 THEN
                num_yae097 := rec_irad55.aae001||'12';
             END IF;
             --ѭ��������Ա
             FOR rec_info IN cur_info LOOP
                 var_aac001 := rec_info.aac001;

                 IF var_aae140 = '01' THEN
                    var_yac503 := xasi2.pkg_comm.YAC503_SB;
                    var_yac505 := '010';
                 ELSE
                   --�����Ա���������ɷ�״̬����ԱΪ����״̬���򲻲���
                   SELECT count(1)
                     INTO num_count
                     FROM xasi2.ac02
                    WHERE aac001 = var_aac001
                      AND aae140 = var_aae140
                      AND aac031 IN ('2','3');

                   IF num_count > 0 THEN
                      GOTO leb_next2;
                   END IF;

                   SELECT count(1)
                     INTO num_count
                     FROM xasi2.kc01
                    WHERE aac001 = var_aac001
                      AND akc021 = '21';

                   IF num_count >0 THEN
                      GOTO leb_next2;
                   END IF;

                  BEGIN
                  SELECT yac503,
                         YAC505
                    INTO var_yac503,
                         var_yac505
                    FROM XASI2.ac02
                   WHERE aac001 = var_aac001
                     AND aab001 = var_aab001
                     AND aae140 = var_aae140;
                  EXCEPTION
                       WHEN OTHERS THEN
                            prm_AppCode := PKG_Constant.gn_def_ERR||'02';
                            prm_ErrorMsg  := '���˱��'||var_aac001||'����'||var_aae140||'û�л�ȡ�����˲α���Ϣ';
                            RETURN;
                  END;

                 END IF;


                  num_yac401 := 0;
                  num_yac402 := 0;
                  num_yac403 := 0;
                  num_yac404 := 0;
                  num_yac405 := 0;
                  num_yac406 := 0;
                  num_yac407 := 0;
                  num_yac408 := 0;
                  num_yac409 := 0;
                  num_yac410 := 0;
                  num_yac411 := 0;
                  num_yac412 := 0;
                 WHILE num_aae041 <= num_yae097 LOOP

                   IF var_aae140 = '01' THEN

                      BEGIN
                       SELECT NVL(SUM(aae180),0)
                         INTO num_yac004_old
                         FROM wsjb.irac08a1
                        WHERE aac001 = var_aac001
                         AND aab001 = var_aab001
                         AND aae002 = num_aae041
                         AND aae140 = var_aae140
                         AND aae143 IN(xasi2.pkg_comm.AAE143_ZCJF, --�����ɷ�
                                                 xasi2.pkg_comm.AAE143_JSBC, --��������
                                                 xasi2.pkg_comm.AAE143_BJ  , --����
                                                 xasi2.pkg_comm.AAE143_BS  , --����
                                                 xasi2.pkg_comm.AAE143_DLJF, --������Ա�ɷ�
                                                 xasi2.pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                                 xasi2.pkg_comm.AAE143_BLBC); --��������
                     EXCEPTION
                          WHEN OTHERS THEN
                               GOTO leb_next1;
                     END;
                   ELSE
                     --��ȡ֮ǰ�Ľɷѻ���
                     BEGIN
                        SELECT NVL(SUM(aae180),0)  --�ɷѻ���
                          INTO num_yac004_old
                          FROM
                               (SELECT aae180
                                  FROM xasi2.ac08
                                 WHERE aac001 = var_aac001
                                   AND aab001 = var_aab001
                                   AND aae002 = num_aae041
                                   AND aae140 = var_aae140
                                   AND aae143 IN(xasi2.pkg_comm.AAE143_ZCJF, --�����ɷ�
                                                 xasi2.pkg_comm.AAE143_JSBC, --��������
                                                 xasi2.pkg_comm.AAE143_BJ  , --����
                                                 xasi2.pkg_comm.AAE143_BS  , --����
                                                 xasi2.pkg_comm.AAE143_DLJF, --������Ա�ɷ�
                                                 xasi2.pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                                 xasi2.pkg_comm.AAE143_BLBC) --��������
                                   AND yaa330 = xasi2.pkg_comm.YAA330_BL  --����ģʽ
                               UNION
                                SELECT aae180
                                  FROM xasi2.AC08A1
                                 WHERE aac001 = var_aac001
                                   AND aab001 = var_aab001
                                   AND aae002 = num_aae041
                                   AND aae140 = var_aae140
                                   AND aae143 IN(xasi2.pkg_comm.AAE143_ZCJF, --�����ɷ�
                                                 xasi2.pkg_comm.AAE143_JSBC, --��������
                                                 xasi2.pkg_comm.AAE143_BJ  , --����
                                                 xasi2.pkg_comm.AAE143_BS  , --����
                                                 xasi2.pkg_comm.AAE143_DLJF, --������Ա�ɷ�
                                                 xasi2.pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                                 xasi2.pkg_comm.AAE143_BLBC) --��������
                                   AND yaa330 =  xasi2.pkg_comm.YAA330_BL  --����ģʽ
                                 )
                                 ;
                        EXCEPTION
                             WHEN OTHERS THEN
                                  GOTO leb_next1;
                        END;
                      END IF;

                       --���ñ��׷ⶥ���̣���ȡ�ɷѻ����ͽɷѹ���
                        SELECT MAX(aae041)
                          INTO num_aae002_max
                          FROM xasi2.AA02
                         WHERE yaa001 = '16'
                           AND aae140 = var_aae140
                           AND aae001 = rec_irad55.aae001;
                       xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase
                                                             (var_aac001   ,     --���˱���
                                                              prm_aab001   ,     --��λ����
                                                              num_yac004_old   ,     --�ɷѹ���
                                                              var_yac503  ,     --�������
                                                              var_aae140   ,     --��������
                                                              var_yac505   ,     --�ɷ���Ա���
                                                              var_yab136   ,     --��λ�������ͣ���������ɷ���Ա��
                                                              num_aae002_max   ,     --�ѿ�������
                                                              prm_yab139   ,     --�α�������
                                                              num_yac004   ,     --�ɷѻ���
                                                              prm_AppCode  ,     --�������
                                                              prm_ErrorMsg );    --��������
                       IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                          RETURN;
                       END IF;

                        --�жϸ��幤�̻�
                       IF var_aab019 = '60' THEN
                         --��ȡ��ƽ����
                         num_spgz := xasi2.pkg_comm.fun_GetAvgSalary(var_aae140,'16',num_aae002_max,PKG_Constant.YAB003_JBFZX);
                         --�������Ϊ���� �ɷѹ��ʺͽɷѻ���Ϊ��ƽ����
                         IF var_aae140 = xasi2.pkg_comm.AAE140_GS THEN
                            num_yac004 := ROUND(num_spgz/12);
                          ELSE
                            IF num_yac004 > ROUND(num_spgz/12) THEN
                               num_yac004 := ROUND(num_spgz/12);
                            END  IF;
                          END IF;
                       END IF;

                      --���ݼ����ɷ���Ա�Ƿ���Ҫ���ѣ�������

                      num_yac004_ce := num_yac004 - num_yac004_old;

                      IF SUBSTR(num_aae041,-2)='01' THEN
                         num_yac401 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='02' THEN
                         num_yac402 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='03' THEN
                         num_yac403 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='04' THEN
                         num_yac404 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='05' THEN
                         num_yac405 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='06' THEN
                         num_yac406 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='07' THEN
                         num_yac407 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='08' THEN
                         num_yac408 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='09' THEN
                         num_yac409 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='10' THEN
                         num_yac410 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='11' THEN
                         num_yac411 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='12' THEN
                         num_yac412 := num_yac004_ce;
                      END IF;
                       <<leb_next1>>
                       num_aae041 := TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(num_aae041),'yyyymm'),1),'yyyymm'));
                 END LOOP;

                 INSERT INTO wsjb.tmp_ac43
                 SELECT var_aac001,
                         var_aab001,
                         var_aae140,
                         num_yac401,
                        num_yac402,
                        num_yac403,
                        num_yac404,
                        num_yac405,
                        num_yac406,
                        num_yac407,
                        num_yac408,
                        num_yac409,
                        num_yac410,
                        num_yac411,
                        num_yac412,
                        num_yac004,
                        rec_irad55.aae001
                   FROM dual;
                 <<leb_next2>>
                 var_aac001 := NULL;
             END LOOP;


             --����tmp_ac43 ���ɽɷ���Ϣ
             prc_YearSalaryByPayInfos (var_aab001 ,
                                       '2'   ,
                                       num_yae097 ,
                                       var_aae140 ,
                                       rec_irad55.aae001 ,
                                       xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAB222') ,
                                       110292 ,
                                       prm_yab139,
                                       prm_AppCode,
                                       prm_ErrorMsg);
             IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                 RETURN;
             END IF;


             --�޸Ľɷѻ���

             FOR rec_yac004 IN cur_yac004 LOOP
                 --������Ա�Ĳα���Ϣ

                 IF var_aae140  = '01' THEN

                   UPDATE wsjb.IRAC01A3
                      SET yac004 = rec_yac004.yac004
                    WHERE aac001 = rec_yac004.aac001
                      AND aab001 = var_aab001;
                 ELSE
                   UPDATE xasi2.ac02
                      SET yac004 = rec_yac004.yac004
                    WHERE aac001 = rec_yac004.aac001
                      AND aae140 = var_aae140
                      AND aab001 = var_aab001;
                 END IF;
                 --д���˽ɷѻ��������¼��
                 INSERT INTO xasi2.ac04a3(YAE099,             --ҵ����ˮ��,VARCHAR2
                                             AAC001,             --���˱��,VARCHAR2
                                             AAB001,             --��λ���,VARCHAR2
                                             AAE140,             --��������,VARCHAR2
                                             YAC235,             --���ʱ������,VARCHAR2
                                             YAC506,             --���ǰ����,NUMBER
                                             YAC507,             --���ǰ�ɷѻ���,NUMBER
                                             YAC514,             --���ǰ���ʻ�����,NUMBER
                                             AAC040,             --�ɷѹ���,NUMBER
                                             YAC004,             --�ɷѻ���,NUMBER
                                             YAA333,             --�˻�����,NUMBER
                                             AAE002,             --�ѿ�������,NUMBER
                                             AAE013,             --��ע,VARCHAR2
                                             AAE011,             --������,NUMBER
                                             AAE036,             --����ʱ��,DATE
                                             YAB003,             --�籣�������,VARCHAR2
                                             YAB139,             --�α�����������,VARCHAR2
                                             YAC503,             --�������,VARCHAR2
                                             YAC526              --���ǰ�������,VARCHAR2
                                             )
                                     VALUES (var_yae099,             --ҵ����ˮ��,VARCHAR2
                                             rec_yac004.aac001,             --���˱��,VARCHAR2
                                             var_aab001,             --��λ���,VARCHAR2
                                             var_aae140,             --��������,VARCHAR2
                                             xasi2.pkg_comm.YAC235_PL,     --���ʱ������,VARCHAR2
                                             0,         --���ǰ����,NUMBER
                                             0,         --���ǰ�ɷѻ���,NUMBER
                                             0,         --���ǰ���ʻ�����,NUMBER
                                             0,             --�ɷѹ���,NUMBER
                                             num_yac004,             --�ɷѻ���,NUMBER
                                             num_yac004,             --�˻�����,NUMBER
                                             num_yae097,             --�ѿ�������,NUMBER
                                             '���걨���β���'  ,                 --��ע,VARCHAR2
                                             110292,             --������,NUMBER
                                             sysdate,             --����ʱ��,DATE
                                             prm_yab139,             --�籣�������,VARCHAR2
                                             prm_yab139,             --�α�����������,VARCHAR2
                                             '0',             --�������,VARCHAR2
                                             '0');            --���ǰ�������,VARCHAR2
             END LOOP;
         END LOOP;
         <<leb_next>>
         UPDATE wsjb.irad55
            SET --yae235 = var_yae235,
                yae238 = var_yae238
          WHERE iaz004 = rec_irad55.iaz004
            AND aab001 = rec_irad55.aab001
            AND aae001 = rec_irad55.aae001;
     END LOOP;
   EXCEPTION
    WHEN OTHERS THEN
       prm_AppCode  :=  PKG_Constant.gn_def_ERR;
       prm_ErrorMsg := '���ݿ����:'|| PRE_ERRCODE || SQLERRM ;
       RETURN;
   END prc_YearSalaryBCBySP;
 /*****************************************************************************
   ** �������� : prc_YearSalaryBCBySP
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����ƽ�����󲹲�
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2013-05-25   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_YearSalaryByPayInfos (prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                               prm_type         IN     VARCHAR2,   --1 Ϊ��ƽ����ǰ���� 2Ϊ��ƽ�����󲹲�
                               prm_aae003       IN     NUMBER,
                               prm_aae140       IN     VARCHAR2,
                               prm_aae001       IN     NUMBER,
                               prm_yab222       IN     VARCHAR2,
                               prm_aae011       IN     VARCHAR2,
                               prm_yab139       IN     VARCHAR2,
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          )
   IS
    var_aae013  VARCHAR2(750);
     num_count    NUMBER;
     num_aae001   NUMBER(4);
     num_aae003  NUMBER(6);
     var_aab001  irab01.aab001%TYPE;
     var_aae140  irab02.aae140%TYPE;
     num_yac004_old  NUMBER(14,2);
     num_yac004  NUMBER(14,2);
     num_yae097  NUMBER(6);
     num_aae041  NUMBER(6);
     num_yac004_ce NUMBER(14,2);
     var_aac001  irac01.aac001%TYPE;
     var_yae235  irad55.yae235%TYPE;
     var_yae238  irad55.yae238%TYPE;
     num_yac401   tmp_ac42.yac401%type;           --1�²�����,NUMBER
     num_yac402   tmp_ac42.yac401%type;           --2�²�����,NUMBER
     num_yac403   tmp_ac42.yac401%type;           --3�²�����,NUMBER
     num_yac404   tmp_ac42.yac401%type;           --4�²�����,NUMBER
     num_yac405   tmp_ac42.yac401%type;           --5�²�����,NUMBER
     num_yac406   tmp_ac42.yac401%type;           --6�²�����,NUMBER
     num_yac407   tmp_ac42.yac401%type;           --7�²�����,NUMBER
     num_yac408   tmp_ac42.yac401%type;           --8�²�����,NUMBER
     num_yac409   tmp_ac42.yac401%type;           --9�²�����,NUMBER
     num_yac410   tmp_ac42.yac401%type;           --10�²�����,NUMBER
     num_yac411   tmp_ac42.yac401%type;           --11�²�����,NUMBER
     num_yac412   tmp_ac42.yac401%type;           --12�²�����,NUMBER
     num_aae002_max NUMBER(6);
     var_yab136    irab01.yab136%TYPE;
     var_yab275    irab01.yab275%TYPE;
     var_aae119    irab01.aae119%TYPE;
     var_aab019    irab01.aab019%TYPE;
     var_yac503    irac01.yac503%TYPE;
     var_yac505    irac01.yac505%TYPE;
     num_spgz      NUMBER(14,2);
     var_yae518    ab08.yae518%TYPE;
     cursor cur_info IS
     SELECT *
       FROM wsjb.tmp_ac43
      WHERE aab001 = prm_aab001
        AND aae001 = prm_aae001
        AND aae140 = prm_aae140
        AND 1 = DECODE(prm_type,'2',1,0)
     UNION
     SELECT *
       FROM wsjb.tmp_ac42
      WHERE aab001 = prm_aab001
        AND aae001 = prm_aae001
        AND aae140 = prm_aae140
        AND 1 = DECODE(prm_type,'1',1,0);

   BEGIN
     prm_AppCode  := PKG_Constant.gn_def_OK;
      prm_ErrorMsg := '';


      IF prm_aae140 = '01' THEN
          --�������ϲ���
        prc_YearSalaryBCByYL(prm_aab001  ,
                             prm_aae001  ,
                             num_yae097  ,
                             prm_yab222  ,
                             0  ,
                             '2',
                             prm_aae011  ,
                             prm_yab139  ,
                             prm_AppCode ,
                             prm_ErrorMsg);

       IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
           RETURN;
       END IF;
     ELSE --ҽ������
            prc_YearSalaryBCBy03(prm_aab001,
                               prm_aae001,
                               prm_aae003,
                               prm_yab222,
                               0,
                               '2'  ,
                               prm_aae140,
                               prm_aae011,
                               prm_yab139,
                               prm_AppCode,
                               prm_ErrorMsg);
      END IF;
   EXCEPTION
    WHEN OTHERS THEN
       prm_AppCode  :=  PKG_Constant.gn_def_ERR;
       prm_ErrorMsg := '���ݿ����:'|| PRE_ERRCODE || SQLERRM ;
       RETURN;
   END prc_YearSalaryByPayInfos;
PROCEDURE prc_YearSalaryBCBy03(prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                               prm_aae001       IN     NUMBER            ,--�������
                               prm_aae002       IN     NUMBER            ,
                               prm_yab222       IN     xasi2.ab08.yab222%TYPE,
                               prm_aae076       IN     xasi2.ab08.aae076%TYPE,
                               prm_type         IN     VARCHAR2,  --1Ϊ��ƽ����ǰ 2Ϊ��ƽ������
                               prm_aae140       IN     VARCHAR2,
                               prm_aae011       IN     irad31.aae011%TYPE,--������
                               prm_yab139       IN     VARCHAR2          ,--�α�����������
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      num_count     NUMBER;
      v_msg        VARCHAR2(300);
      var_aaz002   irad31.aaz002%TYPE;
      num_aae041_year NUMBER(6);  --���ʼʱ��
      num_yae097   xasi2.ab02.yae097%TYPE; --��λ��������ں�
      var_aae140   xasi2.ab02.aae140%TYPE; --����
      var_aac001   xasi2.ac01.aac001%TYPE; --���˱��
      num_aae002   xasi2.ac08a1.aae002%TYPE;
      num_aac040   xasi2.ac02.aac040%TYPE;
      num_spgz     xasi2.ac02.aac040%TYPE;
      num_yac004   xasi2.ac02.yac004%TYPE;

      var_yac503   xasi2.ac02.yac503%TYPE;
      var_yac505   xasi2.ac02.yac505%TYPE;
      num_yac401   tmp_ac42.yac401%type;           --1�²�����,NUMBER
      num_yac402   tmp_ac42.yac401%type;           --2�²�����,NUMBER
      num_yac403   tmp_ac42.yac401%type;           --3�²�����,NUMBER
      num_yac404   tmp_ac42.yac401%type;           --4�²�����,NUMBER
      num_yac405   tmp_ac42.yac401%type;           --5�²�����,NUMBER
      num_yac406   tmp_ac42.yac401%type;           --6�²�����,NUMBER
      num_yac407   tmp_ac42.yac401%type;           --7�²�����,NUMBER
      num_yac408   tmp_ac42.yac401%type;           --8�²�����,NUMBER
      num_yac409   tmp_ac42.yac401%type;           --9�²�����,NUMBER
      num_yac410   tmp_ac42.yac401%type;           --10�²�����,NUMBER
      num_yac411   tmp_ac42.yac401%type;           --11�²�����,NUMBER
      num_yac412   tmp_ac42.yac401%type;           --12�²�����,NUMBER
      var_procNo   VARCHAR2(5);                    --���̺�
      var_aae013   xasi2.ab08a8.aae013%TYPE;
      var_aae100   VARCHAR2(9);
      var_yae099   xasi2.ac04a3.yae099%TYPE;
      var_yae518   xasi2.ab08.yae518%TYPE;
      num_aae041   NUMBER(6);
      num_aae042   NUMBER(6);
      sum_new_aab213        NUMBER(14,2);
      new_aab213            NUMBER(14,2);
      sum_aab213            NUMBER(14,2);
      num_ala080_old        NUMBER;
      sum_aae180            NUMBER(14,2);

      sum_yab158            xasi2.AC08A1.aab213%type;
      sum_new_yab158        xasi2.AC08A1.aab213%type;
      new_yab158            xasi2.AC08A1.aab213%type;
      var_yae518_tk         ab08.yae518%TYPE;

       var_yab136      xasi2.ab01.yab136%TYPE  ;  --��λ��������
      var_aab019      xasi2.ab01.aab019%TYPE  ;  --��λ����
      var_aab020      xasi2.ab01.aab020%TYPE  ;  --��������
      var_aab021      xasi2.ab01.aab021%TYPE  ;  --������ϵ
      var_aab022      xasi2.ab01.aab022%TYPE  ;  --��ҵ����
      var_YKB109      xasi2.ab01.YKB109%TYPE  ;  --�Ƿ����ܹ���Աͳ�����
      var_yab275      xasi2.ab01.yab275%TYPE  ;  --ҽ�Ʊ���ִ�а취
      var_aae119      xasi2.ab01.aae119%TYPE;
      var_yab380      xasi2.ab01.yab380%TYPE  ;
      var_yab222      irab08.yab222%TYPE;
       var_yae010_110     varchar2(9);
       var_yae010_120     varchar2(9);
       var_yae010_210     varchar2(9);
       var_yae010_310     varchar2(9);
       var_yae010_410     varchar2(9);
       var_yae010_510     varchar2(9);
      var_aaa040      VARCHAR2(9);
      num_aaa041      xasi2.ac08.aaa041%TYPE;
      num_yaa017      xasi2.ac08.aaa041%TYPE;
      num_aaa042      xasi2.ac08.aaa041%TYPE;
      num_aaa043      xasi2.ac08.aaa041%TYPE;
      var_ykb110      irab01.ykb110%TYPE;
      var_yae010      irab08.yae010%TYPE;
      var_aae076      irab08.aae076%TYPE;
      --��ȡ��λ�ύ���걨��Ա
      CURSOR cur_tmp_ac42 IS
        select AAC001,             --��Ա���,VARCHAR2
               AAB001,             --��λ���,VARCHAR2
               AAE140,             --����,VARCHAR2
               YAC401,             --1�²�����,NUMBER
               YAC402,             --2�²�����,NUMBER
               YAC403,             --3�²�����,NUMBER
               YAC404,             --4�²�����,NUMBER
               YAC405,             --5�²�����,NUMBER
               YAC406,             --6�²�����,NUMBER
               YAC407,             --7�²�����,NUMBER
               YAC408,             --8�²�����,NUMBER
               YAC409,             --9�²�����,NUMBER
               YAC410,             --10�²�����,NUMBER
               YAC411,             --11�²�����,NUMBER
               YAC412,             --12�²�����,NUMBER
               AAE013,             --��ע,VARCHAR2
               aae001
          from wsjb.tmp_ac42   --��Ա���ֲ�����Ϣ��
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND aae140 = prm_aae140
           AND 1 = DECODE(prm_type,'1',1,0)
        UNION
        select AAC001,             --��Ա���,VARCHAR2
               AAB001,             --��λ���,VARCHAR2
               AAE140,             --����,VARCHAR2
               YAC401,             --1�²�����,NUMBER
               YAC402,             --2�²�����,NUMBER
               YAC403,             --3�²�����,NUMBER
               YAC404,             --4�²�����,NUMBER
               YAC405,             --5�²�����,NUMBER
               YAC406,             --6�²�����,NUMBER
               YAC407,             --7�²�����,NUMBER
               YAC408,             --8�²�����,NUMBER
               YAC409,             --9�²�����,NUMBER
               YAC410,             --10�²�����,NUMBER
               YAC411,             --11�²�����,NUMBER
               YAC412,             --12�²�����,NUMBER
               AAE013,             --��ע,VARCHAR2
               aae001
          from wsjb.tmp_ac43   --��Ա���ֶ��β�����Ϣ��
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND aae140 = prm_aae140
           AND 1 = DECODE(prm_type,'2',1,0);
      CURSOR cur_aae041
          IS
          SELECT aae041 AS aae041,
                 aae042 AS aae042
            FROM xasi2.aa05a1
           WHERE aae140 = prm_aae140;
        CURSOR cur_aae180
          IS
          SELECT SUM(DECODE(yac505,'021',0,aae180)) AS aae180,
                   SUM(aae180) AS aae180_1,
                   SUM(aab213) AS aab213,
                   MAX(aaa040) AS aaa040,
                   MAX(ala080) AS ala080,
                   MAX(aaa041) AS aaa041,  --���˽ɷѱ���
                   MAX(yaa017) AS yaa017,  --���˽ɷѻ�ͳ�����
                   MAX(aaa042) AS aaa042,  --��λ�ɷѱ���
                   MAX(aaa043) AS aaa043, --��λ�ɷѻ��˻�����
                   SUM(yab158) AS yab158
              FROM xasi2.ac08a1
             WHERE yae518 = var_yae518  --�˶���ˮ��
               AND aae140 = prm_aae140
             --  AND aae143 <> pkg_Comm.AAE143_JSBC
               AND aae002 >= num_aae041
               AND aae002 <= num_aae042;
     CURSOR cur_ac08a1_sk                                     -- ��ϸ��Ϣ
      IS
         SELECT a.aae140,
                a.yae010,    --������Դ
                MIN(a.aae002) AS aae041,
                MAX(a.aae002) AS aae042,
                COUNT(DISTINCT a.aac001) yae231,   --����
                a.yae203   , --������Դ����
                CASE WHEN a.AKC021 = xasi2.pkg_comm.AKC021_ZZ THEN xasi2.pkg_comm.YAB538_ZZ
                     WHEN a.AKC021 = xasi2.pkg_comm.AKC021_TX THEN xasi2.pkg_comm.YAB538_TX
                     ELSE xasi2.pkg_comm.YAB538_LX
                     END YAB538,
                NVL(SUM(a.yaa333),0) aab120,   --���˽ɷѻ����ܶ�
                NVL(SUM(a.aae180),0) aab121,   --��λ�ɷѻ����ܶ�
                NVL(SUM(a.yab157),0) aab150,   --Ӧ�ɸ��˽ɷѻ����˻����
                NVL(SUM(a.yab158),0) yab031,   --Ӧ�ɸ��˽ɷѻ���ͳ����
                NVL(SUM(a.aab212),0) aab151,   --Ӧ�ɵ�λ�ɷѻ����˻����
                NVL(SUM(a.aab213),0) aab152,   --Ӧ�ɵ�λ�ɷѻ���ͳ����
                NVL(SUM(0),0) aab157     ,   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
                NVL(SUM(0),0) aab158     ,   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
                NVL(SUM(0),0) aab159     ,   --Ӧ�����˻�������Ϣ��λ������
                NVL(SUM(0),0) aab160     ,   --Ӧ�����˻�������Ϣ��λ������
                NVL(SUM(0),0) aab161     ,   --Ӧ����ͳ�������Ϣ���
                NVL(SUM(a.aab162),0) aab162    --Ӧ�����ɽ���
           FROM xasi2.ac08a1 a
          WHERE a.yae518 = var_yae518
            AND a.aab001 = prm_aab001
            AND a.aae003 = num_aae002
          GROUP BY a.aae140,
                   a.yae010,    --������Դ
                   a.yae203,    --������Դ����
                   a.AKC021,
                   CASE WHEN a.AKC021 = xasi2.pkg_comm.AKC021_ZZ THEN xasi2.pkg_comm.YAB538_ZZ
                        WHEN a.AKC021 = xasi2.pkg_comm.AKC021_TX THEN xasi2.pkg_comm.YAB538_TX
                        ELSE xasi2.pkg_comm.YAB538_LX
                        END;

      CURSOR cur_ac08a1_tk                                      -- ��ϸ��Ϣ
      IS
         SELECT a.aae140,
                a.yae010,    --������Դ
                MIN(a.aae002) AS aae041,
                MAX(a.aae002) AS aae042,
                COUNT(DISTINCT a.aac001) yae231,   --����
                a.yae203   , --������Դ����
                CASE WHEN a.AKC021 = xasi2.pkg_comm.AKC021_ZZ THEN xasi2.pkg_comm.YAB538_ZZ
                     WHEN a.AKC021 = xasi2.pkg_comm.AKC021_TX THEN xasi2.pkg_comm.YAB538_TX
                     ELSE xasi2.pkg_comm.YAB538_LX
                     END YAB538,
                NVL(SUM(a.yaa333),0) aab120,   --���˽ɷѻ����ܶ�
                NVL(SUM(a.aae180),0) aab121,   --��λ�ɷѻ����ܶ�
                NVL(SUM(a.yab157),0) aab150,   --Ӧ�ɸ��˽ɷѻ����˻����
                NVL(SUM(a.yab158),0) yab031,   --Ӧ�ɸ��˽ɷѻ���ͳ����
                NVL(SUM(a.aab212),0) aab151,   --Ӧ�ɵ�λ�ɷѻ����˻����
                NVL(SUM(a.aab213),0) aab152,   --Ӧ�ɵ�λ�ɷѻ���ͳ����
                NVL(SUM(0),0) aab157     ,   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
                NVL(SUM(0),0) aab158     ,   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
                NVL(SUM(0),0) aab159     ,   --Ӧ�����˻�������Ϣ��λ������
                NVL(SUM(0),0) aab160     ,   --Ӧ�����˻�������Ϣ��λ������
                NVL(SUM(0),0) aab161     ,   --Ӧ����ͳ�������Ϣ���
                NVL(SUM(a.aab162),0) aab162    --Ӧ�����ɽ���
           FROM xasi2.ac08a1 a
          WHERE a.yae518 = var_yae518_tk
            AND a.aab001 = prm_aab001
            AND a.aae003 = num_aae002
          GROUP BY a.aae140,
                   a.yae010,    --������Դ
                   a.yae203,    --������Դ����
                   a.AKC021,
                   CASE WHEN a.AKC021 = xasi2.pkg_comm.AKC021_ZZ THEN xasi2.pkg_comm.YAB538_ZZ
                        WHEN a.AKC021 = xasi2.pkg_comm.AKC021_TX THEN xasi2.pkg_comm.YAB538_TX
                        ELSE xasi2.pkg_comm.YAB538_LX
                        END;
   --�������շ�ʽ���·�����Դ
      CURSOR cur_ab08 IS
      SELECT yae518,
             aae140
        FROM xasi2.ab08
       WHERE aab001 = prm_aab001
         AND yae517 IN (xasi2.pkg_comm.YAE517_H12,xasi2.pkg_comm.YAE517_H17)
         AND aae003 = num_aae002
         AND yab222 = var_yab222;
      --�������շ�ʽ���·�����Դ
      CURSOR cur_ab08a8 IS
      SELECT yae518,
             aae140
        FROM xasi2.ab08a8
       WHERE aab001 = prm_aab001
         AND yae517 = xasi2.pkg_comm.YAE517_H17
         AND aae003 = num_aae002
         AND yab222 = var_yab222;
   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      var_procNo   :='Y01';
      var_yae518   := xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAE518');
      var_yae518_tk   := xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAE518');
      num_aae002   := prm_aae002;
      var_yab222   :=prm_yab222;
      --����У��
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λ��Ų���Ϊ��' ;
         RETURN;
      END IF;

      IF prm_aae001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '������Ȳ���Ϊ��' ;
         RETURN;
      END IF;
      IF num_aae002 IS NULL THEN
         SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(yae097),'yyyymm'),1),'yyyymm'))
           INTO num_aae002
           FROM xasi2.ab02
          WHERE aab001 = prm_aab001;
      END IF;

      --��ȡ��λ��ǰ�Ĺ�������
      BEGIN
         SELECT yab136,
                yab275,
                aae119,
                aab019
           INTO var_yab136,
                var_yab275,
                var_aae119,
                var_aab019
           FROM xasi2.ab01
          WHERE aab001 = prm_aab001;
      EXCEPTION
         WHEN OTHERS THEN
              prm_AppCode := ''||var_procNo||'02';
              prm_ErrorMsg  := '��λ����'||prm_aab001||'�籣�������'||prm_yab139||'û�л�ȡ����λ������Ϣ';
              RETURN;
      END;

      --ѭ����ȡ��Ա�����ʱ��
      FOR rec_tmp_ac42 IN cur_tmp_ac42 LOOP
           --����TMP_ac42���벹�����ʱ����
           var_aac001 := rec_tmp_ac42.aac001;
           --1�²���
           IF rec_tmp_ac42.yac401 <> 0 THEN
               prc_insertAC08A1(prm_aab001  ,
                                  var_aac001  ,
                                  prm_aae001||'01'  ,
                                  num_aae002,
                                  rec_tmp_ac42.yac401,
                                  case WHEN rec_tmp_ac42.yac401 < 0 THEN var_yae518_tk ELSE var_yae518 END  ,
                                  prm_aae076,
                                  prm_aae140,
                                  prm_aae011  ,
                                  prm_yab139  ,
                                  prm_AppCode ,
                                  prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac402 <> 0 THEN   --2�²���
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'02'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac402,
                                    case WHEN rec_tmp_ac42.yac402 < 0 THEN var_yae518_tk ELSE var_yae518 END  ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac403 <> 0 THEN   --���²���
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'03'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac403,
                                    case WHEN rec_tmp_ac42.yac403 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac404 <> 0 THEN   --4�²���
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'04'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac404,
                                    case WHEN rec_tmp_ac42.yac404 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac405 <> 0 THEN   --5�²���
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'05'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac405,
                                    case WHEN rec_tmp_ac42.yac405 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac406 <> 0 THEN    --6�²���
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'06'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac406,
                                    case WHEN rec_tmp_ac42.yac406 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac407 <> 0 THEN   --7�²���
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'07'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac407,
                                    case WHEN rec_tmp_ac42.yac407 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac408 <> 0 THEN    --8�²���
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'08'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac408,
                                    case WHEN rec_tmp_ac42.yac408 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac409 <> 0 THEN   --9�²���
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'09'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac409,
                                    case WHEN rec_tmp_ac42.yac409 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac410 <> 0 THEN    --10�²���
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'10'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac410,
                                    case WHEN rec_tmp_ac42.yac410 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac411 <> 0 THEN   --11�²���
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'11'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac411,
                                    case WHEN rec_tmp_ac42.yac411 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac412 <> 0 THEN   --12�²���
                 prc_insertAC08A1 (prm_aab001 ,
                                   var_aac001 ,
                                   prm_aae001||'12' ,
                                   num_aae002 ,
                                   rec_tmp_ac42.yac412,
                                   case WHEN rec_tmp_ac42.yac412 < 0 THEN var_yae518_tk ELSE var_yae518 END  ,
                                   prm_aae076 ,
                                   prm_aae140 ,
                                   prm_aae011 ,
                                   prm_yab139 ,
                                   prm_AppCode,
                                   prm_ErrorMsg );
          END IF;
      END LOOP;

     sum_new_yab158 := 0;
      new_yab158     := 0;
      sum_yab158     := 0;
     FOR rec_aae041 IN cur_aae041 LOOP
           num_aae041 := rec_aae041.aae041;
           num_aae042 := rec_aae041.aae042;

           sum_new_yab158 := 0;
           new_yab158     := 0;
           sum_yab158     := 0;
           sum_new_aab213 := 0;
           new_aab213     := 0;
           FOR rec_aae180_06 IN cur_aae180 LOOP
                var_aaa040 := rec_aae180_06.aaa040;
                num_ala080_old := rec_aae180_06.ala080;
                sum_aae180 := rec_aae180_06.aae180;
                sum_aab213 := rec_aae180_06.aab213;
                num_aaa041 := rec_aae180_06.aaa041;
                num_yaa017 := rec_aae180_06.yaa017;
                num_aaa042 := rec_aae180_06.aaa042;
                num_aaa043 := rec_aae180_06.aaa043;
                sum_yab158 := rec_aae180_06.yab158;

                --���¼���Ӧ����Ϣ
                --��λ����
               sum_new_aab213:=round(rec_aae180_06.aae180_1*num_aaa042*(1+num_ala080_old),2);
               new_aab213 := sum_new_aab213 - sum_aab213;
               --���˲���
              sum_new_yab158 := ROUND(sum_aae180*num_yaa017,2);
              new_yab158 := sum_new_yab158-sum_yab158;
                 --���¸�����ϸ��Ϣ  ��������������и��� ����ԭ��Ϊȡ���ɷѻ����е�һ�����и���
               UPDATE xasi2.AC08A1 a
                 SET aab213=aab213+new_aab213,
                     yab158=yab158+new_yab158
               WHERE yae518 = var_yae518  --�˶���ˮ��
                 AND aae140 = prm_aae140
                 AND YAC505 = DECODE(aae140,xasi2.pkg_comm.aae140_SYE,xasi2.pkg_comm.YAC505_SYEPT,yac505)
                 AND yae202 =(SELECT MAX(yae202)
                                FROM xasi2.AC08A1
                               WHERE yae518 = a.yae518
                                 AND aae140 = a.aae140
                                 AND aae002 >= num_aae041
                                 AND aae002 <= num_aae042
                                 AND aae180 = (SELECT MAX(aae180)
                                                 FROM xasi2.AC08A1
                                                WHERE yae518 = var_yae518
                                                  AND aae002 >= num_aae041
                                                  AND aae002 <= num_aae042
                                               )
                                );
           END LOOP;

       END LOOP;


    --��ȡ��λ������Ϣ
      xasi2.pkg_p_checkEmployerFeeCo.prc_p_checkEmployerBase
           (prm_aab001 ,  --��λ����
            var_aab019 ,  --��λ����
            var_aab020 ,  --��������
            var_aab021 ,  --������ϵ
            var_aab022 ,  --��ҵ����
            var_yab136 ,  --��λ��������
            var_YKB109 ,
            var_yab275 ,
            var_yab380 ,
            var_ykb110 ,  --Ԥ���˻���־
            prm_AppCode,  --ִ�д���
            prm_ErrorMsg ); --ִ�н��
      IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK  THEN
         RETURN;
      END IF;
    --���ɵ�λ�ɷ���Ϣ
     FOR rec_ac08a1_sk IN  cur_ac08a1_sk LOOP
         /*���ɺ˶�����Ӧ����Ϣ��*/
         xasi2.pkg_p_checkEmployerFeeCo.prc_p_insertab08(
                             var_yae518, --�˶���ˮ��
                             prm_aab001, --��λ���
                             NULL      , --���˱��
                             rec_ac08a1_sk.aae140, --��������
                             num_aae002, --�����ں�
                             rec_ac08a1_sk.aae041, --��ʼ�ں�
                             rec_ac08a1_sk.aae042, --��ֹ�ں�
                             rec_ac08a1_sk.yab538, --�ɷ���Ա״̬
                             rec_ac08a1_sk.yae010,--������Դ
                             xasi2.pkg_Comm.YAE517_H12, --�˶�����
                             var_yab222, --�������κ�
                             rec_ac08a1_sk.yae231,   --����
                             rec_ac08a1_sk.yae203,   --������Դ����
                             rec_ac08a1_sk.aab120,   --���˽ɷѻ����ܶ�
                             rec_ac08a1_sk.aab121,   --��λ�ɷѻ����ܶ�
                             rec_ac08a1_sk.aab150,   --Ӧ�ɸ��˽ɷѻ����˻����
                             rec_ac08a1_sk.yab031,   --Ӧ�ɸ��˽ɷѻ���ͳ����
                             rec_ac08a1_sk.aab151,   --Ӧ�ɵ�λ�ɷѻ����˻����
                             rec_ac08a1_sk.aab152,   --Ӧ�ɵ�λ�ɷѻ���ͳ����
                             rec_ac08a1_sk.aab157,   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
                             rec_ac08a1_sk.aab158,   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
                             rec_ac08a1_sk.aab159,   --Ӧ�����˻�������Ϣ��λ������
                             rec_ac08a1_sk.aab160,   --Ӧ�����˻�������Ϣ��λ������
                             rec_ac08a1_sk.aab161,   --Ӧ����ͳ�������Ϣ���
                             rec_ac08a1_sk.aab162,   --Ӧ�����ɽ���
                             0,--��ת������
                             var_aab019, --��λ����
                             var_aab020, --���óɷ�
                             var_aab021, --������ϵ
                             var_aab022, --��λ��ҵ
                             prm_aae011, --������
                             SYSDATE,   --����ʱ��
                             prm_yab139, --�α�����������
                             prm_yab139, --�籣�������
                             NULL,
                             NULL,
                             prm_AppCode,         --ִ�д���
                             prm_ErrorMsg );        --ִ�н��
         IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
            prm_ErrorMsg := prm_ErrorMsg||'1';
         END IF;
      END LOOP;
    FOR rec_ac08a1_tk IN  cur_ac08a1_tk LOOP
         /*���ɺ˶�����Ӧ����Ϣ��*/
         xasi2.pkg_p_checkEmployerFeeCo.prc_p_insertab08(
                             var_yae518_tk, --�˶���ˮ��
                             prm_aab001, --��λ���
                             NULL      , --���˱��
                             rec_ac08a1_tk.aae140, --��������
                             num_aae002, --�����ں�
                             rec_ac08a1_tk.aae041, --��ʼ�ں�
                             rec_ac08a1_tk.aae042, --��ֹ�ں�
                             rec_ac08a1_tk.yab538, --�ɷ���Ա״̬
                             rec_ac08a1_tk.yae010,--������Դ
                             xasi2.pkg_Comm.YAE517_H17, --�˶�����
                             var_yab222, --�������κ�
                             rec_ac08a1_tk.yae231,   --����
                             rec_ac08a1_tk.yae203,   --������Դ����
                             rec_ac08a1_tk.aab120,   --���˽ɷѻ����ܶ�
                             rec_ac08a1_tk.aab121,   --��λ�ɷѻ����ܶ�
                             rec_ac08a1_tk.aab150,   --Ӧ�ɸ��˽ɷѻ����˻����
                             rec_ac08a1_tk.yab031,   --Ӧ�ɸ��˽ɷѻ���ͳ����
                             rec_ac08a1_tk.aab151,   --Ӧ�ɵ�λ�ɷѻ����˻����
                             rec_ac08a1_tk.aab152,   --Ӧ�ɵ�λ�ɷѻ���ͳ����
                             rec_ac08a1_tk.aab157,   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
                             rec_ac08a1_tk.aab158,   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
                             rec_ac08a1_tk.aab159,   --Ӧ�����˻�������Ϣ��λ������
                             rec_ac08a1_tk.aab160,   --Ӧ�����˻�������Ϣ��λ������
                             rec_ac08a1_tk.aab161,   --Ӧ����ͳ�������Ϣ���
                             rec_ac08a1_tk.aab162,   --Ӧ�����ɽ���
                             CASE WHEN rec_ac08a1_tk.yae010 = xasi2.pkg_Comm.YAE010_CZ THEN 0
                                  ELSE -(rec_ac08a1_tk.aab150+   --Ӧ�ɸ��˽ɷѻ����˻����
                                         rec_ac08a1_tk.yab031+   --Ӧ�ɸ��˽ɷѻ���ͳ����
                                         rec_ac08a1_tk.aab151+   --Ӧ�ɵ�λ�ɷѻ����˻����
                                         rec_ac08a1_tk.aab152+   --Ӧ�ɵ�λ�ɷѻ���ͳ����
                                         rec_ac08a1_tk.aab157+   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
                                         rec_ac08a1_tk.aab158+   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
                                         rec_ac08a1_tk.aab159+   --Ӧ�����˻�������Ϣ��λ������
                                         rec_ac08a1_tk.aab160+   --Ӧ�����˻�������Ϣ��λ������
                                         rec_ac08a1_tk.aab161+   --Ӧ����ͳ�������Ϣ���
                                         rec_ac08a1_tk.aab162 )  --Ӧ�����ɽ���
                                    END, --��ת������
                             var_aab019, --��λ����
                             var_aab020, --���óɷ�
                             var_aab021, --������ϵ
                             var_aab022, --��λ��ҵ
                             prm_aae011, --������
                             SYSDATE,   --����ʱ��
                             prm_yab139, --�α�����������
                             prm_yab139, --�籣�������
                             NULL,
                             NULL,
                             prm_AppCode,         --ִ�д���
                             prm_ErrorMsg );        --ִ�н��
         IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
            prm_ErrorMsg := prm_ErrorMsg||'2';
            RETURN;
         END IF;
      END LOOP;


  --���·�����Դ
      BEGIN
        SELECT decode(yae010_110,'3','1','1'),
               decode(yae010_120,'3','1','1'),
               decode(yae010_210,'3','1','1'),
               decode(yae010_310,'3','1','1'),
               decode(yae010_410,'3','1','1'),
               decode(yae010_510,'3','1','1')
          INTO var_yae010_110,
               var_yae010_120,
               var_yae010_210,
               var_yae010_310,
               var_yae010_410,
               var_yae010_510
          FROM wsjb.irab03
         WHERE aab001 = prm_aab001;
       EXCEPTION
            WHEN OTHERS THEN
                 var_yae010_110 := xasi2.pkg_comm.YAE010_zc;
                 var_yae010_210 := xasi2.pkg_comm.YAE010_zc;
                 var_yae010_310 := xasi2.pkg_comm.YAE010_zc;
                 var_yae010_410 := xasi2.pkg_comm.YAE010_zc;
                 var_yae010_510 := xasi2.pkg_comm.YAE010_zc;
      END;
      FOR rec_ab08 IN cur_ab08 LOOP
          --ʧҵ
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_SYE THEN
             var_yae010 := var_yae010_210;
          END IF;
          --ҽ��
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_JBYL THEN
             var_yae010 := var_yae010_310;
          END IF;
          --����
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_GS THEN
             var_yae010 := var_yae010_410;
          END IF;
          --����
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_SYU THEN
             var_yae010 := var_yae010_510;
          END IF;
         /* --��������
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_JGYL THEN
             var_yae010 := var_yae010_120;
          END IF;*/
          --���·�����Դ
          UPDATE xasi2.AB08
             SET yae010 = var_yae010
           WHERE yae518 = rec_ab08.yae518
             AND yab222 = var_yab222
             AND aae140 = rec_ab08.aae140;

          --������Ա��ϸ
          UPDATE xasi2.AC08A1
             SET yae010 = var_yae010
           WHERE yae518 = rec_ab08.yae518
             AND aae140 = rec_ab08.aae140;
      END LOOP;
      FOR rec_ab08a8 IN cur_ab08a8 LOOP
          --ʧҵ
          IF rec_ab08a8.aae140 = xasi2.pkg_comm.AAE140_SYE THEN
             var_yae010 := var_yae010_210;
          END IF;
          --ҽ��
          IF rec_ab08a8.aae140 = xasi2.pkg_comm.AAE140_JBYL THEN
             var_yae010 := var_yae010_310;
          END IF;
          --����
          IF rec_ab08a8.aae140 = xasi2.pkg_comm.AAE140_GS THEN
             var_yae010 := var_yae010_410;
          END IF;
          --����
          IF rec_ab08a8.aae140 = xasi2.pkg_comm.AAE140_SYU THEN
             var_yae010 := var_yae010_510;
          END IF;

          --���·�����Դ
          UPDATE xasi2.AB08A8
             SET yae010 = var_yae010
           WHERE yae518 = rec_ab08a8.yae518
             AND yab222 = var_yab222
             AND aae140 = rec_ab08a8.aae140;

          --������Ա��ϸ
          UPDATE xasi2.ac08
             SET yae010 = var_yae010
           WHERE yae518 = rec_ab08a8.yae518
             AND aae140 = rec_ab08a8.aae140;
      END LOOP;
      --��˰�ķ�����
      var_yae010 := xasi2.pkg_comm.YAE010_zc;
      --YAE517 = H12
          --������ʱ��
          DELETE FROM xasi2.Tmp_yae518;
          INSERT INTO xasi2.tmp_yae518
                                         (yae518,   -- �˶���ˮ��
                                          aae140,   -- ��������
                                          aab001,
                                          yab538,
                                          yae010,
                                          aae041,
                                          yab139)
                                   SELECT a.yae518,
                                          a.aae140,
                                          a.aab001,
                                          a.yab538, --�ɷ���Ա״̬
                                          a.YAE010, --������Դ
                                          a.aae041,
                                          prm_yab139
                                     FROM xasi2.AB08 a,xasi2.ab02 b
                                    WHERE a.aab001=b.aab001
                                      AND a.aae140=b.aae140
                                      AND a.aab001 = prm_aab001
                                      AND (aae076 IS NULL OR aae076 = '0')
                                      AND a.aae140 = prm_aae140
                                      AND yae517 = xasi2.pkg_Comm.YAE517_H12      --�˶�����
                                      AND a.aae003 = num_aae002
                                      AND yab222 = var_yab222
                                      AND b.aab033='04';
        SELECT COUNT(1)
          INTO num_count
          FROM xasi2.tmp_yae518;
        IF num_count > 0 THEN
           var_aae076 := xasi2.pkg_comm.fun_GetSequence(NULL,'aae076');
           --�����������̡����ɵ�����Ϣ�Ͳ���ӿ�����
           xasi2.pkg_p_fundCollection.prc_crtFinaPlan  (
                                                          'P01'    ,      --�ո�����
                                                          '18',      --�ո����㷽ʽ
                                                          prm_aae011    ,      --������Ա
                                                          prm_yab139    ,      --�籣�������
                                                          var_aae076    ,      --�ƻ���ˮ��
                                                          prm_AppCode   ,      --ִ�д���
                                                          prm_ErrorMsg    );     --ִ�н��
           IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
              RETURN;
           END IF;
        END IF;
     --YAE517 = H17
          --������ʱ��
          DELETE FROM xasi2.Tmp_yae518;
          INSERT INTO xasi2.tmp_yae518
                                         (yae518,   -- �˶���ˮ��
                                          aae140,   -- ��������
                                          aab001,
                                          yab538,
                                          yae010,
                                          aae041,
                                          yab139)
                                   SELECT a.yae518,
                                          a.aae140,
                                          a.aab001,
                                          a.yab538, --�ɷ���Ա״̬
                                          a.YAE010, --������Դ
                                          a.aae041,
                                          prm_yab139
                                     FROM xasi2.AB08 a,xasi2.ab02 b
                                    WHERE a.aab001=b.aab001
                                      AND a.aae140=b.aae140
                                      AND a.aab001 = prm_aab001
                                      AND (aae076 IS NULL OR aae076 = '0')
                                      AND a.aae140 = prm_aae140
                                      AND yae517 = xasi2.pkg_Comm.YAE517_H17      --�˶�����
                                      AND a.aae003 = num_aae002
                                      AND yab222 = var_yab222
                                      AND b.aab033='04';
        SELECT COUNT(1)
          INTO num_count
          FROM xasi2.tmp_yae518;
        IF num_count > 0 THEN
           var_aae076 := xasi2.pkg_comm.fun_GetSequence(NULL,'aae076');
           --�����������̡����ɵ�����Ϣ�Ͳ���ӿ�����
           xasi2.pkg_p_fundCollection.prc_crtFinaPlan  (
                                                          'P19'    ,      --�ո�����
                                                          '30',      --�ո����㷽ʽ
                                                          prm_aae011    ,      --������Ա
                                                          prm_yab139    ,      --�籣�������
                                                          var_aae076    ,      --�ƻ���ˮ��
                                                          prm_AppCode   ,      --ִ�д���
                                                          prm_ErrorMsg    );     --ִ�н��
           IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
              RETURN;
           END IF;
        END IF;
     --�Գ�ķ�����
     --YAE517 = H12
      var_aae076 := xasi2.pkg_comm.fun_GetSequence(NULL,'aae076');
      --������ʱ��
      DELETE FROM xasi2.Tmp_yae518;
      INSERT INTO xasi2.tmp_yae518
                                     (yae518,   -- �˶���ˮ��
                                      aae140,   -- ��������
                                      aab001,
                                      yab538,
                                      yae010,
                                      aae041,
                                      yab139)
                               SELECT a.yae518,
                                      a.aae140,
                                      a.aab001,
                                      a.yab538, --�ɷ���Ա״̬
                                      a.YAE010, --������Դ
                                      a.aae041,
                                      prm_yab139
                                 FROM xasi2.AB08 a,xasi2.ab02 b
                                WHERE a.aab001=b.aab001
                                  AND a.aae140=b.aae140
                                  AND a.aab001 = prm_aab001
                                  AND (aae076 IS NULL OR aae076 = '0')
                                  AND yae517 = xasi2.pkg_Comm.YAE517_H12      --�˶�����
                                  AND a.aae003 = num_aae002
                                  AND yab222 = var_yab222
                                  AND b.aab033='01';
    SELECT COUNT(1)
      INTO num_count
      FROM xasi2.tmp_yae518;
    IF num_count > 0 THEN
       --�����������̡����ɵ�����Ϣ�Ͳ���ӿ�����
       xasi2.pkg_p_fundCollection.prc_crtFinaPlan  (
                                                        'P01'    ,      --�ո�����
                                                        xasi2.pkg_comm.YAD052_GTSK,      --�ո����㷽ʽ
                                                        prm_aae011    ,      --������Ա
                                                        prm_yab139    ,      --�籣�������
                                                        var_aae076    ,      --�ƻ���ˮ��
                                                        prm_AppCode   ,      --ִ�д���
                                                        prm_ErrorMsg    );     --ִ�н��
       IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
          RETURN;
       END IF;
    END IF;
    --YAE517 = H17
      var_aae076 := xasi2.pkg_comm.fun_GetSequence(NULL,'aae076');
      --������ʱ��
      DELETE FROM xasi2.Tmp_yae518;
      INSERT INTO xasi2.tmp_yae518
                                     (yae518,   -- �˶���ˮ��
                                      aae140,   -- ��������
                                      aab001,
                                      yab538,
                                      yae010,
                                      aae041,
                                      yab139)
                               SELECT a.yae518,
                                      a.aae140,
                                      a.aab001,
                                      a.yab538, --�ɷ���Ա״̬
                                      a.YAE010, --������Դ
                                      a.aae041,
                                      prm_yab139
                                 FROM xasi2.AB08 a,xasi2.ab02 b
                                WHERE a.aab001=b.aab001
                                  AND a.aae140=b.aae140
                                  AND a.aab001 = prm_aab001
                                  AND (aae076 IS NULL OR aae076 = '0')
                                  AND yae517 = xasi2.pkg_Comm.YAE517_H17      --�˶�����
                                  AND a.aae003 = num_aae002
                                  AND yab222 = var_yab222
                                  AND b.aab033='01';
    SELECT COUNT(1)
      INTO num_count
      FROM xasi2.tmp_yae518;
    IF num_count > 0 THEN
       --�����������̡����ɵ�����Ϣ�Ͳ���ӿ�����
       xasi2.pkg_p_fundCollection.prc_crtFinaPlan  (
                                                        'P19'    ,      --�ո�����
                                                        xasi2.pkg_comm.YAD052_TZ,      --�ո����㷽ʽ
                                                        prm_aae011    ,      --������Ա
                                                        prm_yab139    ,      --�籣�������
                                                        var_aae076    ,      --�ƻ���ˮ��
                                                        prm_AppCode   ,      --ִ�д���
                                                        prm_ErrorMsg    );     --ִ�н��
       IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
          RETURN;
       END IF;
    END IF;
   EXCEPTION
        WHEN OTHERS THEN
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
             RETURN;
END prc_YearSalaryBCBy03;
PROCEDURE prc_insertAC08A1  (prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                             prm_aac001       IN     xasi2.ac01.aac001%TYPE,
                             prm_aae002       IN     NUMBER            ,--�������
                             prm_aae003       IN     NUMBER,
                             prm_aac040       IN     xasi2.ac02.aac040%TYPE,
                             prm_yae518       IN     xasi2.ac08a1.yae518%TYPE,
                             prm_aae076       IN     xasi2.ab08.aae076%TYPE,
                             prm_aae140       IN     VARCHAR2,
                             prm_aae011       IN     irad31.aae011%TYPE,--������
                             prm_yab139       IN     VARCHAR2          ,--�α�����������
                             prm_AppCode      OUT    VARCHAR2          ,
                             prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      num_count     NUMBER;
      v_msg        VARCHAR2(300);
      var_yac505   irac01.yac505%TYPE;
      var_aaa040   irab01.aaa040%TYPE;
      var_yac503   irac01.yac503%TYPE;
      var_yae010   irab08.yae010%TYPE;
      var_yaa330   irac08.yaa333%TYPE;
      num_aaa041   xasi2.ac08.aaa041%type;
      num_yaa017   xasi2.ac08.aaa041%type;
      num_aaa042   xasi2.ac08.aaa041%type;
      num_aaa043   xasi2.ac08.aaa041%type;
      num_ala080   xasi2.ac08.aaa041%type;
      num_age      xasi2.ac08.yac176%type;
      num_yac176   xasi2.ac08.yac176%type;
      var_akc021   irac01.akc021%TYPE;
      var_ykc120   irac08.ykc120%TYPE;
      var_yac168   irac08.yac168%TYPE;
      var_yaa310   irac08.yaa310%TYPE;
      var_aae114   irac08a1.aae114%TYPE;
   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      DELETE xasi2.tmp_grbs02;


      --��ȡ֮ǰ�Ľɷ���Ϣ
      SELECT MAX(yac505),
             MAX(aaa040),
             MAX(yac503),
             MAX(yae010),
             MAX(yaa330),
             MAX(aaa041),
             MAX(yaa017),
             MAX(aaa042),
             MAX(aaa043),
             MAX(ala080),
             MAX(akc023),
             MAX(yac176),
             MAX(akc021),
             MAX(ykc120),
             MAX(yac168),
             MAX(yaa310),
             MAX(aae114)
       INTO  var_yac505,
             var_aaa040,
             var_yac503,
             var_yae010,
             var_yaa330,
             num_aaa041,
             num_yaa017,
             num_aaa042,
             num_aaa043,
             num_ala080,
             num_age,
             num_yac176,
             var_akc021,
             var_ykc120,
             var_yac168,
             var_yaa310,
             var_aae114
       FROM (
      SELECT yac505,
             aaa040,
             yac503,
             yae010,
             yaa330,
             aaa041,
             yaa017,
             aaa042,
             aaa043,
             ala080,
             akc023,
             yac176,
             akc021,
             ykc120,
             yac168,
             yaa310,
             aae114
        FROM xasi2.ac08 a
       WHERE aac001 = prm_aac001
         AND aab001 = prm_aab001
         AND aae140 = prm_aae140
         AND aae002 = prm_aae002
         AND aae143 IN (xasi2.pkg_comm.AAE143_JSBC,
                        xasi2.pkg_comm.AAE143_BS,
                        xasi2.pkg_comm.AAE143_ZCJF)
      UNION
      SELECT yac505,
             aaa040,
             yac503,
             yae010,
             yaa330,
             aaa041,
             yaa017,
             aaa042,
             aaa043,
             ala080,
             akc023,
             yac176,
             akc021,
             ykc120,
             yac168,
             yaa310,
             '1'
        FROM xasi2.ac08a1 a
       WHERE aac001 = prm_aac001
         AND aab001 = prm_aab001
         AND aae140 = prm_aae140
         AND aae002 = prm_aae002
         AND aae143 IN (xasi2.pkg_comm.AAE143_JSBC,
                        xasi2.pkg_comm.AAE143_BS,
                        xasi2.pkg_comm.AAE143_ZCJF)

       );
      INSERT INTO xasi2.tmp_grbs02(aac001,  --���˱���
                              aae002,  --�ѿ������ں�
                              yac505,  --���˽ɷ����
                              aaa040,  --�ɷѱ������
                              aae140,  --����
                              aae143,  --�ɷ����
                              yac503,  --��������
                              aac040,  --�ɷѹ���
                              yac004,  --���˽ɷѻ���
                              yaa333,  --���ʻ�����
                              yae010,  --������Դ
                              yaa330,  --�ɷѱ���ģʽ
                              aaa041,  --���˽ɷѱ���
                              yaa017,  --���˽ɷѻ���ͳ�����
                              aaa042,  --��λ�ɷѱ���
                              aaa043,  --��λ�ɷѻ����ʻ�����
                              ala080,  --���˸�������
                              akc023,  --ʵ������
                              yac176,  --����
                              akc021,  --ҽ����Ա���
                              ykc120,  --ҽ���չ���Ա���
                              aac008,  --��Ա״̬
                              yac168,  --ũ�񹤱�־
                              yaa310,  --�������
                              aae114,  --�ɷѱ�־
                              aae100,  --��Ч��־
                              aae013)  --��ע
                         VALUES
                         ( prm_aac001,           --���˱��
                           prm_aae002,
                           var_yac505,           --�α��ɷ���Ա���
                           var_aaa040,           --�ɷѱ������
                           prm_aae140,           --��������
                           xasi2.pkg_comm.aae143_JSBC,           --�ɷ����
                           var_yac503,           --��������
                           prm_aac040,        --�ɷѹ���
                           prm_aac040,           --�ɷѻ���
                           DECODE(prm_aae140,'03',prm_aac040,0),           --���ʻ�����
                           var_yae010     ,      --������Դ
                           var_yaa330     ,      --�ɷѱ���ģʽ
                           num_aaa041,           --���˽ɷѱ���
                           num_yaa017,           --���˻�ͳ�����
                           num_aaa042,           --��λ�ɷѱ���
                           num_aaa043,           --��λ���ʻ�����
                           num_ala080,           --���˸�������
                           num_age,              --����
                           num_yac176,           --����
                           var_akc021,           --ҽ�Ʊ�����Ա״̬
                           var_ykc120,           --ҽ���չ���Ա���
                           DECODE(var_akc021,'21','2','1'),           --��Ա״̬
                           var_yac168,           --ũ�񹤱�־
                           var_yaa310,           --��������
                           var_aae114,           --�ɷѱ�־
                           xasi2.pkg_comm.AAE100_YX,   --��Ч��־ ����Ч
                           NULL );
         --��������AC08a1
         xasi2.pkg_p_interrupt.prc_p_DetailInterrupt(
                                   NULL,
                                   NULL,
                                   prm_yae518  ,  --�˶���ˮ��
                                   prm_aab001  ,  --��λ���
                                   prm_aac001  ,  --���˱��
                                   prm_aae003  ,  --�����ں�
                                   prm_aae140  ,  --��������
                                   prm_aae011  ,  --������
                                   sysdate  ,  --����ʱ��
                                   prm_yab139  ,  --�������
                                   prm_yab139  ,  --�α���Ա���ڷ�����
                                   prm_AppCode ,  --�������
                                   prm_ErrorMsg  ); --��������
            IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
               RETURN;
            END IF;
   EXCEPTION
        WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
             RETURN;
END prc_insertAC08A1;

--��ʼ���󲹲�£�
PROCEDURE prc_YearSalaryBCBegin(prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                               prm_aae001       IN     NUMBER            ,--�������
                               prm_type         IN     VARCHAR2,  --1Ϊ��ƽ����ǰ 2Ϊ��ƽ������
                               prm_aae011       IN     irad31.aae011%TYPE,--������
                               prm_yab139       IN     VARCHAR2          ,--�α�����������
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          )
    IS
      v_yab222  irab08.yab222%TYPE;
      v_aae076  irab08.aae076%TYPE;
      v_aab001  irab08.aab001%TYPE;
      n_aae002  NUMBER;
      num_yae097 NUMBER;
      num_count NUMBER;
          cursor cur_ab02 IS
            SELECT    DECODE(AAE110, '1', '01', '') AS AAE140
              FROM wsjb.IRAB01
             WHERE IAB001 = AAB001
              AND AAB001 = v_aab001
            UNION
              SELECT aae140
                FROM xasi2.ab02
                WHERE aab001= v_aab001
                  AND aab051='1';
      BEGIN
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λ��Ų���Ϊ��' ;
         RETURN;
      END IF;
      IF prm_aae001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '������Ȳ���Ϊ��' ;
         RETURN;
      END IF;
      IF prm_aae011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�����˲���Ϊ��' ;
         RETURN;
      END IF;
      IF prm_yab139 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�α����������Ĳ���Ϊ��' ;
         RETURN;
      END IF;
       IF prm_type IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�������Ͳ���Ϊ��' ;
         RETURN;
      END IF;
        SELECT COUNT(1)
          INTO num_count
          FROM  wsjb.irad51
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND iaa002 = '2'
           AND iaa011 = 'A05';
        IF num_count = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λ��������Ϣ��δͨ����ˣ����ܲ��' ;
         RETURN;
        END IF;
        SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(yae097),'yyyymm'),1),'yyyymm'))
          INTO num_yae097
          FROM (SELECT MAX(aae003) AS yae097 FROM wsjb.irab08  WHERE yae517='H01' AND aab001= prm_aab001
                UNION
                SELECT MAX(yae097) AS yae097 FROM xasi2.ab02 WHERE aab051 = '1' AND aab001 = prm_aab001) ;
        v_yab222 := xasi2.PKG_comm.fun_GetSequence(NULL,'yab222');
        v_aab001 := prm_aab001;
        FOR rec_ab02 IN cur_ab02 LOOP
        v_aae076 := xasi2.PKG_comm.fun_GetSequence(NULL,'aae076');
        IF rec_ab02.aae140 = '01' THEN

          prc_YearSalaryBCByYL(prm_aab001     ,--��λ���  ����
                               prm_aae001     ,--�������
                               n_aae002     ,
                               v_yab222     ,
                               v_aae076     ,
                               prm_type       ,
                               prm_aae011     ,--������
                               prm_yab139     ,--�α�����������
                               prm_AppCode    ,
                               prm_ErrorMsg    );
         ELSE
          prc_YearSalaryBCBy03(prm_aab001     ,
                               prm_aae001     ,
                               n_aae002     ,
                               v_yab222       ,
                               v_aae076     ,
                               prm_type       ,
                               rec_ab02.aae140,
                               prm_aae011     ,
                               prm_yab139     ,
                               prm_AppCode    ,
                               prm_ErrorMsg   );
              END IF;
              END LOOP;
         UPDATE  wsjb.irad51
            SET iaa006 = '1',
                yae092 = prm_aae011,
                aae036 = SYSDATE,
                aae003 = num_yae097
          WHERE aab001 = prm_aab001
            AND aae001 = prm_aae001
            AND iaa011 = 'A05';
         EXCEPTION
        WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
             RETURN;
END prc_YearSalaryBCBegin;


--�����������
PROCEDURE prc_YearSalaryClear (prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                               prm_aae001       IN     NUMBER            ,--�������
                               prm_aae011       IN     irad31.aae011%TYPE,--������
                               prm_flag         OUT     VARCHAR2,     --�ɹ���־ 0�ɹ� 1 ʧ��
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          )
    IS
     num_count NUMBER(6);
      var_iaz004 irad02.iaz004%TYPE;
      var_aae013 irad02.aae013%TYPE;
      BEGIN
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λ��Ų���Ϊ��' ;
         RETURN;
      END IF;
      IF prm_aae001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '������Ȳ���Ϊ��' ;
         RETURN;
      END IF;
      prm_flag := '0';

      SELECT count(1)
        INTO num_count
        FROM  wsjb.irad51
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND iaa011 = 'A05';

      IF num_count > 0 THEN
         prm_flag :='1';
         prm_ErrorMsg := '��Ȼ����걨�Ѿ��ύ�����������';
      END IF;

      SELECT count(1)
        INTO num_count
        FROM wsjb.irad53
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND iaa011 = 'A05';

      IF num_count > 0 THEN
         prm_flag :='1';
         prm_ErrorMsg := '�����籣���Ľ�����ˣ�����δͨ�������ܽ����������ݲ�����';
         RETURN;
      END IF;
      SELECT TO_CHAR(seq_iaz004.nextval)
        INTO var_iaz004
        FROM dual;
      --����AB05A1����
         INSERT INTO  xasi2.AC01K9 SELECT * FROM  xasi2.ac01k8 WHERE aab001 = prm_aab001 AND aae001 = prm_aae001;

         DELETE xasi2.ac01k8 WHERE aab001 = prm_aab001 AND aae001 = prm_aae001;
         UPDATE xasi2.AC01K9
            SET iaz004 = var_iaz004
          WHERE aab001 = prm_aab001
            AND aae001 = prm_aae001;


         INSERT INTO wsjb.irad51a3
              SELECT var_iaz004,
                     'A05',
                     prm_aab001,
                     prm_aae001,
                     prm_aae011,
                     SYSDATE
                FROM dual;

         EXCEPTION
        WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
             RETURN;
END prc_YearSalaryClear;

PROCEDURE prc_YearApplyJSProportions (prm_aab001       IN     xasi2.ab01.aab001%TYPE,--��λ���
                               prm_aae001       IN     NUMBER            ,--�������
                               prm_aae011       IN     irad31.aae011%TYPE, --������
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          )
IS
  num_count NUMBER(6);
  v_minaae041 NUMBER(6);
  v_aab121_old  xasi2.ab08.aab121%type;
  v_aab121_new  xasi2.ab08.aab121%type;
  v_proportions NUMBER(6,2);
  v_proportions_constant NUMBER(6);
  v_proportions_msg  irad54.aae013%type;

  cursor ab02_cur is select aae140 from xasi2.ab02 where  aae140 !='07' and aab051 = '1'  and aab001 = prm_aab001 ;

BEGIN

/*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      v_proportions_constant := -1;
      v_proportions_msg := '';

        -- ��λ�Ƿ���4��
        select count(1)
          into num_count
          from xasi2.ab02
         where aab051 = '1'
           and aae140 !='07'
           and aab001 = prm_aab001;
        -- ������ȡ����������С�˷��ں�
        if num_count >0 then
          select min(aae041)
            into v_minaae041
            from (select aae041
                    from xasi2.ab08
                   where yae517 = 'H01'
                     and aab001 = prm_aab001
                     and aae041 > (prm_aae001 - 1) || 12
                  union
                  select aae041
                    from xasi2.ab08a8
                   where yae517 = 'H01'
                     and aab001 = prm_aab001
                     and aae041 > (prm_aae001 - 1) || 12);
        else --û�����վ��ǵ����ϵ�λȡ����������С�˷��ں�
          select min(aae041)
            into v_minaae041
            from wsjb.irab08
           where yae517 = 'H01'
             and aab001 = prm_aab001
             and aae041 > (prm_aae001 - 1) || 12;
        end if;

        -- �����ֻ�ȡ��������һ�κ˷ѵĵ�λ���� ac01k8 ���»����Ա�
        -- ֻҪ��һ�����ֻ�������ʹ���35%�� ��д��һ��irad54��¼
        if num_count>0 then
          --�ǵ����ϵ�λ������������
          select aab121
            into v_aab121_old
            from wsjb.irab08
           where yae517 = 'H01'
             and aae140 = '01'
             and aab001 = prm_aab001
             and aae041 = v_minaae041;
            select sum(yac004)
             into v_aab121_new
             from xasi2.ac01k8
            where aab001 = prm_aab001
              and aae001 = prm_aae001
              and aae110 is not null;
             --�������
             select (trunc((v_aab121_new / v_aab121_old), 4) - 1) * 100
               into v_proportions
               from DUAL;
              if v_proportions <= v_proportions_constant then
                 v_proportions_msg:='01����'||v_minaae041||'�������ͱ�������';
                 GOTO leb_next;
              end if;
          --�ǵ����ϵ�λ���� 4��
          for ab02_rec in ab02_cur loop
            select aab121
              into v_aab121_old
              from (select aab121
                      from xasi2.ab08
                     where yae517 = 'H01'
                       and aae140 = ab02_rec.aae140
                       and aab001 = prm_aab001
                       and aae041 = v_minaae041
                    union
                    select aab121
                      from xasi2.ab08a8
                     where yae517 = 'H01'
                       and aae140 = ab02_rec.aae140
                       and aab001 = prm_aab001
                       and aae041 = v_minaae041);
            --ʧҵ19���ʹ��ʡ��ƽ
            if ab02_rec.aae140 = '02' and prm_aae001 > 2018 then
               select sum(yac004)
                 into v_aab121_new
                 from xasi2.ac01k8
                where aab001 = prm_aab001
                  and aae210 = '2';
            else
               select sum(yaa333)
                 into v_aab121_new
                 from xasi2.ac01k8
                where aab001 = prm_aab001
                  and aae210 = '2';
            end if;
            --����19���ʹ��ʡ��ƽ
            if ab02_rec.aae140 = '04' and prm_aae001 > 2018 then
               select sum(yac004)
                 into v_aab121_new
                 from xasi2.ac01k8
                where aab001 = prm_aab001
                  and aae410 = '2';
            else
               select sum(yaa333)
                 into v_aab121_new
                 from xasi2.ac01k8
                where aab001 = prm_aab001
                  and aae410 = '2';
            end if;
            --ҽ��ʹ������ƽ
            if ab02_rec.aae140 = '03' then
               select sum(yaa333)
                into v_aab121_new
                from xasi2.ac01k8
               where aab001 = prm_aab001
                 and aae310 = '2';
            end if;
            --����ʹ������ƽ
            if ab02_rec.aae140 = '05' then
               select sum(yaa333)
                into v_aab121_new
                from xasi2.ac01k8
               where aab001 = prm_aab001
                 and aae510 = '2';
            end if;
            --�������
            select (trunc((v_aab121_new / v_aab121_old), 4) - 1) * 100
              into v_proportions
              from DUAL;
              if v_proportions <= v_proportions_constant then
                 v_proportions_msg:=ab02_rec.aae140||'����'||v_minaae041||'�������ͱ�������';
                 GOTO leb_next;
              end if;
          end loop;
        else    --������
            select aab121
               into v_aab121_old
               from wsjb.irab08
              where yae517 = 'H01'
                and aae140 = '01'
                and aab001 = prm_aab001
                and aae041 = v_minaae041;
            select sum(yac004)
               into v_aab121_new
               from xasi2.ac01k8
              where aab001 = prm_aab001
                and aae001 = prm_aae001
                and aae110 is not null;
             --�������
             select (trunc((v_aab121_new / v_aab121_old), 4) - 1) * 100
              into v_proportions
              from DUAL;
              if v_proportions <= v_proportions_constant then
                 v_proportions_msg:='01����'||v_minaae041||'�������ͱ�������';
              end if;
          end if;

         <<leb_next>>

         if v_proportions_msg is not null then
         insert into wsjb.irad54
            (AAB001,
             IAA011,
             AEE011,
             AAE035,
             AAE001,
             AAE013)
          values
            (prm_aab001,
             'A05-1', -- A05-1 �����޻�������д��irad54�� �������ǳ��������ʱ��ɾ������
             prm_aae011,
             sysdate,
             prm_aae001,
             v_proportions_msg);
         end if;

        EXCEPTION
        WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '���ݿ����:'|| SQLERRM ;
             RETURN;
END prc_YearApplyJSProportions;

end PKG_YearApply;
/
