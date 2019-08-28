CREATE OR REPLACE PACKAGE BODY XASI2.pkg_p_salaryExamineAdjust
AS
   /********************************************************************************/
   /*  ������� pkg_p_payAdjust                                                    */
   /*  ҵ�񻷽� ����λ�ɷѲ���                                                     */
   /*  �����б� ��                                                                 */
   /*  �������̺���                                                                */
   /*             01 pkg_p_salaryExamineAdjust            ��λ���󲹲�             */
   /*             02 prc_p_checkData                      ����У��                 */
   /*  ˽�й��̺���                                                                */
   /*             ------------------------����Ч�����-----------------------------*/
   /*             A01 prc_p_checkTmp                       У����ʱ������          */
   /*             A02 prc_p_checkYSJ                       ���Ӧʵ����Ϣ          */
   /*             -----------------------ҵ�������------------------------------*/
   /*                                                                              */
   /*  ����˵�� ��                                                                 */
   /*                                                                              */
   /*  �� �� �� ��                                                                 */
   /*  ������� ��2009-12                                                          */
   /*  �汾��� ��Ver 1.0                                                          */
   /*  �� �� �� ��������                      ������� ��YYYY-MM-DD                   */
   /********************************************************************************/

   --Ч����ʱ�����ݹ���
   PROCEDURE prc_p_checkTmp(prm_aac001      IN       ab08.aac001%TYPE,      --���˱��
                            prm_aab001      IN       ab08.aab001%TYPE,      --��λ���
                            prm_aae140      IN       ab08.aae140%TYPE,      --����
                            prm_aae041      IN       ab08.aae041%TYPE,      --��ʼ�ں�
                            prm_aae042      IN       ab08.aae042%TYPE,      --��ֹ�ں�
                            prm_yac503      IN       ac08.yac503%TYPE,      --�������
                            prm_aac040      IN       ac08.aac040%TYPE,      --�ɷѹ���
                            prm_yaa333      IN       ac08.yaa333%TYPE,      --�ʻ�����
                            prm_bcfs        IN       VARCHAR2,              --���ʽ
                            prm_yab003      IN       ab08.yab003%TYPE,      --�籣�������
                            prm_yab139      IN       ab08.yab139%TYPE,      --�α�����������
                            prm_AppCode     OUT      VARCHAR2        ,      --ִ�д���
                            prm_ErrMsg      OUT      VARCHAR2 )
                            ;
   --Ч���Ӧ��ʵ�ɹ���
   PROCEDURE prc_p_checkYSJ(prm_aac001     IN     ac02.aac001%TYPE,      --���˱��
                            prm_aab001     IN     ac02.aab001%TYPE,      --��λ���
                            prm_aae002     IN     ac08.aae002%TYPE,      --�ѿ�������
                            prm_aae140     IN     ac02.aae140%TYPE,      --����
                            prm_bcfs       IN     VARCHAR2,              --���ʽ
                            prm_yab139     IN     ac02.yab139%TYPE,      --�α�����������
                            prm_yab003     IN     ac02.yab003%TYPE,      --�籣�������
                            prm_yab136     IN     ab01.yab136%TYPE,      --��λ��������
                            prm_aac040     IN OUT ac02.aac040%TYPE,      --�µĽɷѹ���
                            prm_yac503     IN OUT ac02.yac503%TYPE,      --�������
                            prm_YAA333     IN OUT ac02.YAA333%TYPE,      --�˻�����
                            prm_yac004     OUT    ac02.yac004%TYPE,      --�ɷѻ���
                            prm_aaa041     OUT    aa05.aaa041%TYPE,      --���˽ɷѱ���
                            prm_yaa017     OUT    aa05.yaa017%TYPE,      --���˻�ͳ���
                            prm_aaa042     OUT    aa05.aaa042%TYPE,      --��λ�ɷѱ���
                            prm_aaa043     OUT    aa05.aaa043%TYPE,      --��λ�ɷѻ���
                            prm_ala080     OUT    ac08.ala080%TYPE,      --���˸�������
                            prm_yac168_old OUT    ac01.yac168%TYPE,      --ũ�񹤱�־
                            prm_yac505_old OUT    ac02.yac505%TYPE,      --
                            prm_aac008_old OUT    ac01.aac008%TYPE,      --
                            prm_aaa040_old OUT    aa05.aaa040%TYPE,
                            prm_ykc120_old OUT    ac08.ykc120%TYPE,      --ҽ���չ���Ա���
                            prm_akc021_old OUT    ac08.akc021%TYPE,      --ҽ����Ա���
                            prm_aae114_old OUT    ac08.aae114%TYPE,      --�ɷѱ�־
                            prm_age        OUT    ac08.akc023%TYPE,      --����
                            prm_yac176     OUT    ac08.yac176%TYPE,      --����
                            prm_yaa310     OUT    ac08.yaa310%TYPE,      --��������
                            prm_yae010     OUT    ac08.yae010%TYPE,      --������Դ
                            prm_yaa330     OUT    ac08.yaa330%TYPE,      --�ɷѱ���ģʽ
                            prm_AppCode    OUT    VARCHAR2,              --ִ�д���
                            prm_ErrMsg     OUT    VARCHAR2)              --������Ϣ
                            ;

   --��Ա��������д����ϸ
   PROCEDURE prc_p_CreateDetail
                         (prm_aaz002      IN  VARCHAR2,
                          prm_aaz083      IN  VARCHAR2,
                          prm_yae518      IN   ac08.yae518%TYPE,   --�˶���ˮ��
                          prm_aab001      IN   ac08.aab001%TYPE,   --��λ���
                          prm_aac001      IN   ac08.aac001%TYPE,   --���˱��
                          prm_aae003      IN   ac08.aae003%TYPE,   --�����ں�
                          prm_yab139      IN   ab08.yab139%TYPE,   --�����α�������
                          prm_yab003      IN   ab08.yab003%TYPE,   --�籣�������
                          prm_aae011      IN   ab08.aae011%TYPE,   --������
                          prm_aae036      IN   ab08.aae036%TYPE,   --����ʱ��
                          prm_AppCode     OUT  VARCHAR2,           --ִ�д���
                          prm_ErrMsg      OUT  VARCHAR2            --ִ�н��
                         )
                         ;
                         
   --Ǩ������ add by fenggg at 20190709 
   PROCEDURE prc_p_moveDetail(prm_yae518      IN       ac08a1.yae518%type,    --�˶���ˮ��
                              prm_aaz002      IN       ae23.aaz002%TYPE,    
                              prm_aaz083      IN       ae23.aaz083%TYPE,    
                              prm_aab001      IN       ab08.aab001%TYPE,      --��λ���
                              prm_aae001      IN       ab05.aae001%TYPE,      --�������
                              prm_yae010      IN       ab08.yae010%TYPE,      --������Դ   
                              prm_aae011      IN       ab08.aae011%TYPE,      --������   
                              prm_yab003      IN       ab08.yab003%TYPE,      --�籣�������
                              prm_yab139      IN       ab08.yab139%TYPE,      --�α�����������
                              prm_AppCode     OUT      VARCHAR2        ,      --ִ�д���
                              prm_ErrMsg      OUT      VARCHAR2 );
                    
   /*****************************************************************************
   ** �������� pkg_p_salaryExamineAdjust
   ** ���̱�� : 03
   ** ҵ�񻷽� ����������
   ** �������� ������ÿ�ڻ���������Ĳ�ͬ������ͬ�Ĳ������Ե�λ���в���
   ******************************************************************************
   ** ��    �ߣ�            �������� ��2009-12-29   �汾��� ��Ver 1.0.0
   ** ��    ��: Courier New  ��    �� ��10
   ** ��    �ģ�
   ******************************************************************************
   ** ��    ע��
   **
   *****************************************************************************/
   PROCEDURE pkg_p_salaryExamineAdjust(
                                     prm_aaz002      IN  VARCHAR2,
                                     prm_aaz083      IN  VARCHAR2,
                                     prm_aab001      IN   ab02.aab001%TYPE, --��λ���
                                     prm_aae003      IN   ac08.aae003%TYPE, --�����ں�
                                     prm_bcfs        IN   NUMBER          , --���ʽ(0 �ɷѱ������ 1 �ɷѻ������
                                     prm_collectflag IN   NUMBER          , --������־(0:��;1:��
                                     prm_tkfs        IN   NUMBER          , --�˿ʽ(1�����ֽ�2������ת��
                                     prm_check       IN   NUMBER          , --����Ƿ������Ч�������ݡ�0������顣1����顣
                                     prm_yab401      IN   ab08.yab401%TYPE, --��Ϣ��־
                                     prm_yab400      IN   ab08.yab400%TYPE, --���ɽ��־
                                     prm_aab033      IN   ab02.aab033%TYPE, --���շ�ʽ
                                     prm_yab139      IN   ab08.yab139%TYPE, --�����α�������
                                     prm_yab003      IN   ab08.yab003%TYPE, --�籣�������
                                     prm_aae011      IN   ab08.aae011%TYPE, --������
                                     prm_aae036      IN   ab08.aae036%TYPE, --����ʱ��
                                     prm_yab222      IN   ab08.yab222%TYPE, --�������κ�
                                     prm_aae076      OUT  ab08.aae076%TYPE, --����ӿ���ˮ��
                                     prm_AppCode     OUT  VARCHAR2,         --ִ�д���
                                     prm_ErrMsg      OUT  VARCHAR2)         --ִ�н��
   IS
      var_procNo      VARCHAR2(5);         --���̺�

      num_count       NUMBER     ;         --

      var_aac001      ac01.aac001%TYPE  ;  --���˱��

      num_aab156      ab08.aab156%TYPE  ;  --Ƿ�ѽ��
      var_aae140      ab08.aae140%TYPE  ;  --������Ϣ
      var_yae010      ab08.yae010%TYPE  ;  --������Դ

      var_yad052      ab15a1.yad052%TYPE;
      var_yad060      ab15a1.yad060%TYPE;

      var_yab136      ab01.yab136%TYPE  ;  --��λ��������
      var_aab019      ab01.aab019%TYPE  ;  --��λ����
      var_aab020      ab01.aab020%TYPE  ;  --��������
      var_aab021      ab01.aab021%TYPE  ;  --������ϵ
      var_aab022      ab01.aab022%TYPE  ;  --��ҵ����
      var_YKB109      ab01.YKB109%TYPE  ;  --�Ƿ����ܹ���Աͳ�����
      var_yab275      ab01.yab275%TYPE  ;  --ҽ�Ʊ���ִ�а취
      var_yab380      ab01.yab380%TYPE  ;
      var_ykb110      ab01.ykb110%TYPE  ;  --Ԥ���˻���־
      var_aae076      ab08.aae076%TYPE  ;  --
      var_yae518_sk   ab08.yae518%TYPE  ;  --�˶���ˮ��
      var_yae518_tk   ab08.yae518%TYPE  ;  --
      var_yae518_dz   ab08.yae518%TYPE  ;  --�˶���ˮ��
      num_aae002      NUMBER;

      var_flag        VARCHAR2(3)       ;  --�Ƿ�����˲������0 ��û�У�1�������ˡ�

      --ÿ����ÿ�����ֽ���һ����ϸд��
      CURSOR cur_aac001
      IS
         SELECT DISTINCT aac001
           FROM tmp_grbs02
          WHERE aae100 = pkg_comm.AAE100_YX;

      --����Ҫ�������յ�����
      CURSOR cur_tmp_grbs02_ts
      IS
         SELECT aac001,
                aae002,  --�ѿ������ں�
                aae140   --����
           FROM tmp_grbs02
          WHERE aae100 = pkg_comm.AAE100_YX       --��Ч��־����Ч
            AND yac004 < 0 ;

      --ʵ���˿�����
      CURSOR cur_ab08_sjts
      IS
         SELECT SUM(aab156) AS aab156,
                aae140               ,
                MIN(aae041) AS aae041,
                MAX(aae042) AS aae042
           FROM ab08
          WHERE yae518 = var_yae518_tk
            AND yae517 = pkg_Comm.YAE517_H17    --��������
            AND yae010 = pkg_comm.YAE010_ZC
       GROUP BY aae140;

      CURSOR cur_ac08a1_sk                                     -- ��ϸ��Ϣ
      IS
         SELECT a.aae140,
                a.yae010,    --������Դ
                MIN(a.aae002) AS aae041,
                MAX(a.aae002) AS aae042,
                COUNT(DISTINCT a.aac001) yae231,   --����
                a.yae203   , --������Դ����
                max(CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                     WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                     ELSE pkg_comm.YAB538_LX
                     END) YAB538,
                NVL(SUM(a.aae180),0) aab120,   --���˽ɷѻ����ܶ�
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
           FROM ac08a1check a
          WHERE a.yae518 = var_yae518_sk
            AND a.aab001 = prm_aab001
            AND a.aae003 = prm_aae003
          GROUP BY a.aae140,
                   a.yae010,    --������Դ
                   a.yae203,    --������Դ����
                   CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                        WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                        ELSE pkg_comm.YAB538_LX
                        END;

      CURSOR cur_ac08a1_tk                                      -- ��ϸ��Ϣ
      IS
         SELECT a.aae140,
                a.yae010,    --������Դ
                MIN(a.aae002) AS aae041,
                MAX(a.aae002) AS aae042,
                COUNT(DISTINCT a.aac001) yae231,   --����
                a.yae203   , --������Դ����
                max(CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                     WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                     ELSE pkg_comm.YAB538_LX
                     END) YAB538,
                NVL(SUM(a.aae180),0) aab120,   --���˽ɷѻ����ܶ�
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
           FROM ac08a1check a
          WHERE a.yae518 = var_yae518_tk
            AND a.aab001 = prm_aab001
            AND a.aae003 = prm_aae003
          GROUP BY a.aae140,
                   a.yae010,    --������Դ
                   a.yae203,    --������Դ����
                   CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                        WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                        ELSE pkg_comm.YAB538_LX
                        END;
   BEGIN
      --��ʼ������
      prm_AppCode    := pkg_COMM.gn_def_OK ;
      prm_ErrMsg     := '' ;
      var_procNo     := '03';
      var_flag       := '0' ;  --�Ƿ�����˲������0 ��û�У�1�������ˡ�

      SELECT COUNT(1)
        INTO num_count
        FROM tmp_grbs01;
      IF num_count <= 0 THEN
         prm_AppCode := gs_FunNo||var_procNo||'01';
         prm_ErrMsg  := '�����ɷѲ����������ԭ��û��д��tmp_grbs01��Ϣ';
         RETURN;
      END IF;

      --���tmp_grbs01,������tmp_grbs02��Ϣ
      prc_p_checkData(prm_aab001   ,   --��λ���
                      prm_bcfs     ,   --���ʽ��0 �ɷѱ������ 1 �ɷѻ������
                      prm_yab139   ,   --�α�����������
                      prm_yab003   ,   --�籣�������
                      prm_AppCode  ,           --ִ�д���
                      prm_ErrMsg   );            --ִ�н��
      IF prm_AppCode <> pkg_COMM.gn_def_OK THEN
         RETURN;
      END IF;

      --����Ƿ������Ч�Ĳ�������
      INSERT INTO tmp_grbc02 SELECT * FROM tmp_grbs02 WHERE aae100 = pkg_comm.AAE100_YX;
      IF SQL%ROWCOUNT <= 0 THEN
         IF prm_check = 0 THEN
            RETURN ;
         ELSE
            prm_AppCode := gs_FunNo||var_procNo||'02';
            prm_ErrMsg  := '�����ɷѲ����������ԭ��û����Ҫ���������'||prm_check;
            RETURN;
         END IF ;
      END IF;
      --��������Դ
      BEGIN
         SELECT DISTINCT yae010
           INTO var_yae010
           FROM tmp_grbc02
          WHERE aae100 = pkg_comm.AAE100_YX;       --��Ч��־����Ч
      EXCEPTION
         WHEN TOO_MANY_ROWS THEN
            prm_AppCode    := gs_FunNo||var_procNo||'01';
            prm_ErrMsg     := '���β��������д��ڶ��ַ�����Դ�����ܼ�������ȷ�ϣ�' ;
            RETURN;
         WHEN OTHERS THEN
            prm_AppCode    := gs_FunNo||var_procNo||'01';
            prm_ErrMsg     := '���β��������л�ȡ������Դ�������ܼ�������ȷ�ϣ�' ||SQLERRM ;
            RETURN;
      END ;

      --��ȡ��λ������Ϣ
      pkg_p_checkEmployerFeeCo.prc_p_checkEmployerBase
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
            prm_ErrMsg ); --ִ�н��
      IF prm_AppCode <> pkg_comm.gn_def_OK  THEN
         RETURN;
      END IF;

      --�������Ƿ�Ѳ������� ������ϸ
      DELETE tmp_grbs02;
      INSERT INTO tmp_grbs02 SELECT * FROM tmp_grbc02 WHERE NOT (aae114 = pkg_comm.AAE114_YSJ AND yac004 < 0 );
      var_yae518_sk := NULL;
      --���ɸ�����ϸ
       INSERT INTO AE23(
                         aaz083, --���������ɼƻ��¼�ID
                         aaz002, --ҵ����־ID
                         aaz010, --������ID
                         aae013, --��ע
                         aae011, --������
                         aae036, --����ʱ��
                         yab003, --������������
                         aae016,  --���˱�־
                         yae099
                         )
                values(
                         prm_aaz083,
                         prm_aaz002,
                         prm_aab001,
                         null,
                         prm_aae011,
                         prm_aae036,
                         prm_yab003,
                         '0',
                         null
                         );
      FOR rec_aac001 IN cur_aac001 LOOP
         IF var_yae518_sk IS NULL THEN
            var_yae518_sk := pkg_comm.fun_GetSequence(NULL,'yae518');
         END IF ;
         var_aac001 := rec_aac001.aac001;
         prc_p_CreateDetail(prm_aaz002     ,
                            prm_aaz083     ,
                            var_yae518_sk  ,   --�˶���ˮ��
                            prm_aab001     ,   --��λ���
                            var_aac001     ,   --���˱��
                            prm_aae003     ,   --�����ں�
                            prm_yab139     ,   --�����α�������
                            prm_yab003     ,   --�籣�������
                            prm_aae011     ,   --������
                            prm_aae036     ,   --����ʱ��
                            prm_AppCode    ,   --ִ�д���
                            prm_ErrMsg         --ִ�н��
                         );
         IF prm_AppCode <> pkg_COMM.gn_def_OK THEN
            GOTO label_ERROR ;
         END IF;

      END LOOP;

      --�������Ƿ�Ѳ������� д��һ��ab08
      FOR rec_ac08a1_sk IN  cur_ac08a1_sk LOOP
         /*���ɺ˶�����Ӧ����Ϣ��*/
         pkg_p_checkEmployerFeeCo.prc_p_insertab08check(
                             var_yae518_sk, --�˶���ˮ��
                             prm_aab001, --��λ���
                             NULL      , --���˱��
                             rec_ac08a1_sk.aae140, --��������
                             prm_aae003, --�����ں�
                             rec_ac08a1_sk.aae041, --��ʼ�ں�
                             rec_ac08a1_sk.aae042, --��ֹ�ں�
                             rec_ac08a1_sk.yab538, --�ɷ���Ա״̬
                             rec_ac08a1_sk.yae010,--������Դ
                             pkg_Comm.YAE517_H12, --�˶�����
                             prm_yab222, --�������κ�
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
                             prm_aae036,   --����ʱ��
                             prm_yab139, --�α�����������
                             prm_yab003, --�籣�������
                             prm_aaz002,
                             prm_aaz083,
                             prm_AppCode,         --ִ�д���
                             prm_ErrMsg );        --ִ�н��
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            prm_ErrMsg := prm_ErrMsg||'1';
         END IF;

         var_flag := '1';
      END LOOP;

      ----ʵ�ɸ��������˿������ϸ
      DELETE tmp_grbs02;
      INSERT INTO tmp_grbs02 SELECT * FROM tmp_grbc02 WHERE aae114 = pkg_comm.AAE114_YSJ AND yac004 < 0 ;
      var_yae518_tk := NULL;
      --���ɸ�����ϸ
      FOR rec_aac001 IN cur_aac001 LOOP
         IF var_yae518_tk IS NULL THEN
            var_yae518_tk := pkg_comm.fun_GetSequence(NULL,'yae518');
         END IF ;
         var_aac001 := rec_aac001.aac001;
         prc_p_CreateDetail(prm_aaz002     ,
                            prm_aaz083     ,
                            var_yae518_tk  ,   --�˶���ˮ��
                            prm_aab001     ,   --��λ���
                            var_aac001     ,   --���˱��
                            prm_aae003     ,   --�����ں�
                            prm_yab139     ,   --�����α�������
                            prm_yab003     ,   --�籣�������
                            prm_aae011     ,   --������
                            prm_aae036     ,   --����ʱ��
                            prm_AppCode    ,   --ִ�д���
                            prm_ErrMsg         --ִ�н��
                         );
         IF prm_AppCode <> pkg_COMM.gn_def_OK THEN
            GOTO label_ERROR ;
         END IF;


      END LOOP;

      --ʵ�ɸ�����������һ��ab08,���ҽ�������
      FOR rec_ac08a1_tk IN  cur_ac08a1_tk LOOP
         /*���ɺ˶�����Ӧ����Ϣ��*/
         pkg_p_checkEmployerFeeCo.prc_p_insertab08check(
                             var_yae518_tk, --�˶���ˮ��
                             prm_aab001, --��λ���
                             NULL      , --���˱��
                             rec_ac08a1_tk.aae140, --��������
                             prm_aae003, --�����ں�
                             rec_ac08a1_tk.aae041, --��ʼ�ں�
                             rec_ac08a1_tk.aae042, --��ֹ�ں�
                             rec_ac08a1_tk.yab538, --�ɷ���Ա״̬
                             rec_ac08a1_tk.yae010,--������Դ
                             pkg_Comm.YAE517_H17, --�˶�����
                             prm_yab222, --�������κ�
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
                             CASE WHEN var_yae010 = pkg_Comm.YAE010_CZ THEN 0
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
                             prm_aae036,   --����ʱ��
                             prm_yab139, --�α�����������
                             prm_yab003, --�籣�������
                             prm_aaz002,
                             prm_aaz083,
                             prm_AppCode,         --ִ�д���
                             prm_ErrMsg );        --ִ�н��
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            prm_ErrMsg := prm_ErrMsg||'2';
            RETURN;
         END IF;

         var_flag := '1';
      END LOOP;
        --Ǩ��ab08check.ac08a1check���ݵ�ab08,ac08a1
      pkg_p_interrupt.prc_p_batchInterruptCheck(
                         prm_aaz002        ,
                         prm_aab001        ,  --��λ���
                         '0'    ,  --������־
                         null        ,  --���շ�ʽ    ��Ҫ������ʱ��Ŵ�
                         '1'         ,  --���˱�־
                         prm_aae011        ,  --������
                         prm_aae036         ,  --����ʱ��
                         prm_yab003        ,  --�籣�������
                         prm_Appcode        ,  --�������
                         prm_Errmsg         );   --��������

      IF var_flag = '0' THEN
         prm_AppCode := gs_FunNo||var_procNo||'10';
         prm_ErrMsg := '����Ч�ĵ�λ�ɷѲ������ݣ����ʵ��aae003:'||prm_aae003||'; aab001:'||prm_aab001;
         RETURN;
      END IF;

      /*����tmp_yae518 Ϊ������׼��*/
      DELETE tmp_yae518 ;
      --������Դ�ǲ��� ���������ݶ���Ҫ����tmp_yae518
      IF var_yae010 = pkg_Comm.YAE010_CZ THEN
         NULL ;
      ELSE
         --������Դ�ǵ�λ ֻ���˿����Ҫ���ɣ�������Ҫ����һ��H26����Ϣ
         --д����ʱ��
         INSERT INTO tmp_yae518
                   (yae518,   -- �˶���ˮ��
                    aae140,   -- ��������
                    aab001,
                    yab538,
                    yae010,
                    aae041,
                    yab139)
             SELECT yae518,
                    aae140,
                    prm_aab001,
                    yab538, --�ɷ���Ա״̬
                    YAE010, --������Դ
                    aae041,
                    prm_yab139
               FROM ab08
              WHERE yae518 = var_yae518_tk
                AND (aae076 IS NULL OR aae076 = '0')
                AND yae517 = pkg_Comm.YAE517_H17      --�˶�����
                AND yae010 = var_yae010
                ;

         var_yad052 := pkg_comm.YAD052_TZ ;  --����
         var_yad060 := pkg_comm.YAD060_P19;  --��λ�˿�
      END IF;

      /*��������*/
      SELECT COUNT(1)
        INTO num_count
        FROM tmp_yae518;
      IF num_count > 0 THEN
         --����ƻ���ˮ��
         var_aae076 := pkg_comm.fun_GetSequence(NULL,'aae076');
         --�����������̡����ɵ�����Ϣ�Ͳ���ӿ�����
         pkg_p_fundCollection.prc_crtFinaPlan  (
                                  var_yad060    ,      --�ո�����
                                  var_yad052    ,      --�ո����㷽ʽ
                                  prm_aae011    ,      --������Ա
                                  prm_yab003    ,      --�籣�������
                                  var_aae076    ,      --�ƻ���ˮ��
                                  prm_AppCode   ,      --ִ�д���
                                  prm_ErrMsg    );     --ִ�н��
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            RETURN;
         END IF;
      END IF;

      <<label_ERROR>>
      IF cur_aac001%ISOPEN THEN
         CLOSE cur_aac001;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'00';
         prm_ErrMsg  := '�����ɷѲ����������ԭ��'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END pkg_p_salaryExamineAdjust;

   /*****************************************************************************
   ** �������� ��prc_p_CreateDetail
   ** ���̱�� : B01
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
   PROCEDURE prc_p_CreateDetail(
                          prm_aaz002      IN  VARCHAR2,
                          prm_aaz083      IN  VARCHAR2,
                          prm_yae518      IN   ac08.yae518%TYPE,   --�˶���ˮ��
                          prm_aab001      IN   ac08.aab001%TYPE,   --��λ���
                          prm_aac001      IN   ac08.aac001%TYPE,   --���˱��
                          prm_aae003      IN   ac08.aae003%TYPE,   --�����ں�
                          prm_yab139      IN   ab08.yab139%TYPE,   --�����α�������
                          prm_yab003      IN   ab08.yab003%TYPE,   --�籣�������
                          prm_aae011      IN   ab08.aae011%TYPE,   --������
                          prm_aae036      IN   ab08.aae036%TYPE,   --����ʱ��
                          prm_AppCode     OUT  VARCHAR2,           --ִ�д���
                          prm_ErrMsg      OUT  VARCHAR2            --ִ�н��
                         )
   IS
      var_procNo             VARCHAR2(5);                --���̺�
      num_count              NUMBER := 0;                --��¼��

      var_aae140             ac08.aae140%TYPE;           --����
      num_aae002             ac08.aae002%TYPE;           --�ѿ�������

      --��������
      CURSOR cur_aae140
      IS
          SELECT DISTINCT
                 aae140                            --��������
            FROM tmp_grbs02
           WHERE aae100 = pkg_comm.AAE100_YX       --��Ч��־����Ч
             AND aac001 = prm_aac001               --���˱��
           GROUP BY aae140;                        --��������
   BEGIN
      --��ʼ������
      prm_AppCode    := pkg_COMM.gn_def_OK ;
      prm_ErrMsg     := '' ;
      var_procNo     := 'B01';

      --������ϸ
      FOR rec_aae140 IN cur_aae140 LOOP
         var_aae140 := rec_aae140.aae140;
         --���ò������
         IF var_aae140 IN( pkg_comm.AAE140_SYE,
                           pkg_comm.AAE140_JBYL,
                           pkg_comm.AAE140_GS,
                           pkg_comm.AAE140_SYU,
                           pkg_comm.AAE140_GWYBZ)
         THEN
            num_count := num_count + 1;
            pkg_p_interrupt.prc_p_DetailInterrupt(
                                   prm_aaz002  ,
                                   prm_aaz083  ,
                                   prm_yae518  ,  --�˶���ˮ��
                                   prm_aab001  ,  --��λ���
                                   prm_aac001  ,  --���˱��
                                   prm_aae003  ,  --�����ں�
                                   var_aae140  ,  --��������
                                   prm_aae011  ,  --������
                                   prm_aae036  ,  --����ʱ��
                                   prm_yab003  ,  --�������
                                   prm_yab139  ,  --�α���Ա���ڷ�����
                                   prm_Appcode ,  --�������
                                   prm_Errmsg  ); --��������
            IF prm_AppCode <> pkg_comm.gn_def_OK THEN
               RETURN;
            END IF;
         END IF;
      END LOOP;

   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'00';
         prm_ErrMsg  := '�����ɷѲ����������ԭ��'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END prc_p_CreateDetail;
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
   PROCEDURE  prc_p_checkData(
                              prm_aab001   IN   ab02.aab001%TYPE,   --��λ���
                              prm_bcfs     IN   VARCHAR2,           --���ʽ��0 �ɷѱ������ 1 �ɷѻ������
                              prm_yab139   IN   ac02.yab139%TYPE,   --�α�����������
                              prm_yab003   IN   ac02.yab003%TYPE,   --�籣�������
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
        FROM tmp_grbs01;
   BEGIN
      --��ʼ������
      prm_AppCode    := pkg_COMM.gn_def_OK ;
      prm_ErrMsg     := '' ;
      var_procNo     := '02';

      --У�鵥λ����Ƿ�Ϊ��
      IF prm_aab001 IS NULL OR NVL(prm_aab001, '') = '' THEN
         prm_AppCode := gs_FunNo||var_procNo||'02';
         prm_ErrMsg  := '��λ��Ų���Ϊ�գ�';
         RETURN;
      END IF;

      --�����ʱ������
      DELETE FROM tmp_grbs02;

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
                         prm_bcfs,            --���ʽ
                         prm_yab139,          --�α�����������
                         prm_yab003,          --�籣�������
                         prm_AppCode,         --ִ�д���
                         prm_ErrMsg );        --ִ�н��
      END LOOP;

      IF num_count < 1 THEN
         prm_AppCode := gs_FunNo||var_procNo||'04';
         prm_ErrMsg  := '��λ�ɷѲ�����ʱ��������Ч���ݣ����ʵ��';
         RETURN;
      END IF;

      --�ر��α�
      IF cur_tmp%ISOPEN THEN
         CLOSE cur_tmp;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'01';
         prm_ErrMsg  := '����Ч��,����ԭ��:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
      RETURN;
   END prc_p_checkData;

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
   PROCEDURE prc_p_checkTmp(prm_aac001      IN       ab08.aac001%TYPE,      --���˱��
                            prm_aab001      IN       ab08.aab001%TYPE,      --��λ���
                            prm_aae140      IN       ab08.aae140%TYPE,      --����
                            prm_aae041      IN       ab08.aae041%TYPE,      --��ʼ�ں�
                            prm_aae042      IN       ab08.aae042%TYPE,      --��ֹ�ں�
                            prm_yac503      IN       ac08.yac503%TYPE,      --�������
                            prm_aac040      IN       ac08.aac040%TYPE,      --�ɷѹ���
                            prm_yaa333      IN       ac08.yaa333%TYPE,      --�ʻ�����
                            prm_bcfs        IN       VARCHAR2,              --���ʽ
                            prm_yab003      IN       ab08.yab003%TYPE,      --�籣�������
                            prm_yab139      IN       ab08.yab139%TYPE,      --�α�����������
                            prm_AppCode     OUT      VARCHAR2        ,      --ִ�д���
                            prm_ErrMsg      OUT      VARCHAR2 )
   IS
      var_procNo            VARCHAR2(5);      --���̺�
      var_yaa310            ac08.yaa310%type;      --��������
      var_yaa330            ac08.yaa310%type;      --�ɷѱ���ģʽ
      var_yab136            ab01.yab136%type;      --��λ��������
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
      var_yac168            ac08.yac168%type;             --ũ�񹤱�־
      var_yac503            ac08.yac503%type;             --�������
      var_yac505            ac08.yac505%type;             --
      var_aac008            ac08.aac008%type;
      var_aaa040           ac08.aaa040%type;
      var_ykc120            ac08.ykc120%type;             --ҽ���չ���Ա���
      var_akc021            ac08.akc021%type;             --ҽ����Ա���
      num_yaa333            NUMBER;
      var_yae010            aa05.yae010%TYPE;
      var_aae143            ac08.aae143%TYPE;
      var_aae114            ac08.aae114%TYPE;        --�ɷѱ�־

   BEGIN
      --��ʼ������
      prm_AppCode    := pkg_COMM.gn_def_OK ;
      prm_ErrMsg     := '' ;
      var_procNo     := 'A01';

      num_aae041 := prm_aae041;
      num_aae042 := prm_aae042;
      num_count  := 0;


      --У�鵥λ��Ӧ���ֲα�״̬�Ƿ�Ϊ��ֹ�ɷ�״̬
      SELECT COUNT(1)
        INTO num_count
        FROM ab02
       WHERE aab001 = prm_aab001
         AND aae140 = prm_aae140
         AND aab051 <> pkg_comm.AAB051_ZZJF
         AND yab139 = prm_yab139;

      IF num_count = 0 THEN
         prm_AppCode := gs_FunNo||var_procNo||'01';
         prm_ErrMsg  := '��λ���['||prm_aab001||']����['||pkg_COMM.fun_getAaa103('aae140',prm_aae140)||'�α�״̬Ϊ��ֹ�ɷ�״̬�����ܽ��нɷѲ���';
      END IF;

      --У��������Ӧ���ֲα�״̬�Ƿ�Ϊ��ֹ�ɷ�״̬
      SELECT COUNT(1)
        INTO num_count
        FROM ac02
       WHERE aab001 = prm_aab001
         AND aac001 = prm_aac001
         AND aae140 = prm_aae140
         AND aac031 <> pkg_comm.AAC031_ZZCB
         AND yab139 = prm_yab139;
      IF num_count = 0 THEN
         prm_AppCode := gs_FunNo||var_procNo||'02';
         prm_ErrMsg  := '���˱��['||prm_aac001||']����['||pkg_COMM.fun_getAaa103('aae140',prm_aae140)||'��λ���['||prm_aab001||']�α�״̬Ϊ��ֹ�ɷ�״̬�����ܽ��нɷѲ���';
      END IF;

      --��ȡ��λ������Ϣ
      SELECT yab136
        INTO var_yab136
        FROM ab01
       WHERE aab001 = prm_aab001;

      IF prm_bcfs = '0' THEN
         var_aae143 := pkg_comm.aae143_BLBC;
      END IF;

      IF prm_bcfs = '1' THEN
         var_aae143 := pkg_comm.aae143_JSBC;
      END IF;

      WHILE num_aae041 <= num_aae042
      LOOP
         num_aac040_bd := prm_aac040;
         var_yac503 := prm_yac503;
         num_yaa333 := prm_yaa333;

         prc_p_checkYSJ( prm_aac001     ,      --���˱��
                         prm_aab001     ,      --��λ���
                         num_aae041     ,      --�ѿ�������
                         prm_aae140     ,      --����
                         prm_bcfs       ,      --���ʽ
                         prm_yab139     ,      --�α�����������
                         prm_yab003     ,      --�籣�������
                         var_yab136     ,      --��λ��������
                         num_aac040_bd  ,      --�µĽɷѹ���       prm_aac040     IN OUT ac02.aac040%TYPE,      --�µĽɷѹ���
                         var_yac503     ,      --�������           prm_yac503     IN OUT ac02.yac503%TYPE,      --�������
                         num_yaa333     ,      --�˻�����           prm_YAA333     IN OUT ac02.YAA333%TYPE,      --�˻�����
                         num_yac004     ,      --�ɷѻ���           prm_yac004     OUT    ac02.yac004%TYPE,      --�ɷѻ���
                         num_aaa041     ,      --���˽ɷѱ���       prm_aaa041     OUT    aa05.aaa041%TYPE,      --���˽ɷѱ���
                         num_yaa017     ,      --���˻�ͳ���       prm_yaa017     OUT    aa05.yaa017%TYPE,      --���˻�ͳ���
                         num_aaa042     ,      --��λ�ɷѱ���       prm_aaa042     OUT    aa05.aaa042%TYPE,      --��λ�ɷѱ���
                         num_aaa043     ,      --��λ�ɷѻ���       prm_aaa043     OUT    aa05.aaa043%TYPE,      --��λ�ɷѻ���
                         num_ala080     ,      --���˸�������       prm_ala080     OUT    ac08.ala080%TYPE,      --���˸�������
                         var_yac168     ,      --ũ�񹤱�־         prm_yac168_old OUT    ac01.yac168%TYPE,      --ũ�񹤱�־
                         var_yac505     ,      --�α��ɷ���Ա���   prm_yac505_old OUT    ac02.yac505%TYPE,      --
                         var_aac008     ,      --��Ա״̬           prm_aac008_old OUT    ac01.aac008%TYPE,      --
                         var_aaa040     ,      --�ɷѱ������       prm_aaa040_old OUT    aa05.aaa040%TYPE,
                         var_ykc120     ,      --ҽ���չ���Ա���   prm_ykc120_old OUT    ac08.ykc120%TYPE,      --ҽ���չ���Ա���
                         var_akc021     ,      --ҽ����Ա���       prm_akc021_old OUT    ac08.akc021%TYPE,      --ҽ����Ա���
                         var_aae114     ,      --�ɷѱ�־           prm_aae114_old OUT    ac08.aae114%TYPE,      --�ɷѱ�־
                         num_age        ,      --����               prm_age        OUT    ac08.akc023%TYPE,      --����
                         num_yac176     ,      --����               prm_yac176     OUT    ac08.yac176%TYPE,      --����
                         var_yaa310     ,      --��������           prm_yaa310     OUT    ac08.yaa310%TYPE,      --��������
                         var_yae010     ,      --������Դ           prm_yae010     OUT    ac08.yae010%TYPE,      --������Դ
                         var_yaa330     ,      --�ɷѱ���ģʽ       prm_yaa330     OUT    ac08.yaa330%TYPE,      --�ɷѱ���ģʽ
                         prm_AppCode    ,      --ִ�д���
                         prm_ErrMsg    )       --������Ϣ
                         ;
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            --���쳣�׳�������Ч��־��Ϊ��Ч
            INSERT INTO tmp_grbs02(
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
                                 var_aaa040,           --�ɷѱ������
                                 prm_aae140,           --��������
                                 var_aae143,           --�ɷ����
                                 var_yac503,           --��������
                                 num_aac040_bd,        --�ɷѹ���
                                 num_yac004,           --�ɷѻ���
                                 num_yaa333,           --���ʻ�����
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
                                 var_aac008,           --��Ա״̬
                                 var_yac168,           --ũ�񹤱�־
                                 var_yaa310,           --��������
                                 var_aae114,           --�ɷѱ�־
                                 pkg_comm.AAE100_WX,  --��Ч��־ ����Ч
                                 prm_ErrMsg );
            --��������Ϣ�ÿ�
            prm_AppCode    := pkg_COMM.gn_def_OK ;
            prm_ErrMsg     := '' ;
         ELSE
            --���쳣�׳�������Ч��־��Ϊ��Ч
           INSERT INTO tmp_grbs02(
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
                                 num_aae041,
                                 var_yac505,           --�α��ɷ���Ա���
                                 var_aaa040,           --�ɷѱ������
                                 prm_aae140,           --��������
                                 var_aae143,           --�ɷ����
                                 var_yac503,           --��������
                                 num_aac040_bd,        --�ɷѹ���
                                 num_yac004,           --�ɷѻ���
                                 num_yaa333,           --���ʻ�����
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
                                 var_aac008,           --��Ա״̬
                                 var_yac168,           --ũ�񹤱�־
                                 var_yaa310,           --��������
                                 var_aae114,           --�ɷѱ�־
                                 pkg_comm.AAE100_YX,   --��Ч��־ ����Ч
                                 prm_ErrMsg );
         END IF;
         --��ʼ�ںż�1����ѭ��
         num_aae041 := to_number(to_char(ADD_MONTHS(TO_DATE(num_aae041,'yyyymm'),1),'yyyymm')) ;
      END LOOP;
   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'01';
         prm_ErrMsg  := '����Ч��,����ԭ��:'||num_yac004_new||',,'||num_yac004||'..'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
      RETURN;
   END prc_p_checkTmp;

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
   PROCEDURE prc_p_checkYSJ(prm_aac001     IN     ac02.aac001%TYPE,      --���˱��
                            prm_aab001     IN     ac02.aab001%TYPE,      --��λ���
                            prm_aae002     IN     ac08.aae002%TYPE,      --�ѿ�������
                            prm_aae140     IN     ac02.aae140%TYPE,      --����
                            prm_bcfs       IN     VARCHAR2,              --���ʽ
                            prm_yab139     IN     ac02.yab139%TYPE,      --�α�����������
                            prm_yab003     IN     ac02.yab003%TYPE,      --�籣�������
                            prm_yab136     IN     ab01.yab136%TYPE,      --��λ��������
                            prm_aac040     IN OUT ac02.aac040%TYPE,      --�µĽɷѹ���
                            prm_yac503     IN OUT ac02.yac503%TYPE,      --�������
                            prm_YAA333     IN OUT ac02.YAA333%TYPE,      --�˻�����
                            prm_yac004     OUT    ac02.yac004%TYPE,      --�ɷѻ���
                            prm_aaa041     OUT    aa05.aaa041%TYPE,      --���˽ɷѱ���
                            prm_yaa017     OUT    aa05.yaa017%TYPE,      --���˻�ͳ���
                            prm_aaa042     OUT    aa05.aaa042%TYPE,      --��λ�ɷѱ���
                            prm_aaa043     OUT    aa05.aaa043%TYPE,      --��λ�ɷѻ���
                            prm_ala080     OUT    ac08.ala080%TYPE,      --���˸�������
                            prm_yac168_old OUT    ac01.yac168%TYPE,      --ũ�񹤱�־
                            prm_yac505_old OUT    ac02.yac505%TYPE,      --
                            prm_aac008_old OUT    ac01.aac008%TYPE,      --
                            prm_aaa040_old OUT    aa05.aaa040%TYPE,
                            prm_ykc120_old OUT    ac08.ykc120%TYPE,      --ҽ���չ���Ա���
                            prm_akc021_old OUT    ac08.akc021%TYPE,      --ҽ����Ա���
                            prm_aae114_old OUT    ac08.aae114%TYPE,      --�ɷѱ�־
                            prm_age        OUT    ac08.akc023%TYPE,      --����
                            prm_yac176     OUT    ac08.yac176%TYPE,      --����
                            prm_yaa310     OUT    ac08.yaa310%TYPE,      --��������
                            prm_yae010     OUT    ac08.yae010%TYPE,      --������Դ
                            prm_yaa330     OUT    ac08.yaa330%TYPE,      --�ɷѱ���ģʽ
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
      var_yac503            ac02.yac503%TYPE;
      num_aac040            NUMBER;
      num_yaa028            NUMBER;
      num_count             NUMBER;
      num_ala080_old        NUMBER;
      num_aae003            NUMBER;

      var_aae119            ab01.aae119%TYPE;
      var_akc021            kc01.akc021%TYPE;
      var_aac008            ac01.aac008%TYPE;

      --����Ӧ�·�������ǰ���Ƿ���ϵͳ���������ݲ�����
      CURSOR cur_ac08
      IS
         SELECT yae202,
                yac234,
                aae180
           FROM ac08
          WHERE aab001 = prm_aab001
            AND aac001 = prm_aac001
            AND aae140 = prm_aae140
            AND aae002 = prm_aae002
            AND aae143 = pkg_comm.AAE143_JSBC
         UNION
         SELECT yae202,
                yac234,
                aae180
           FROM ac08a1
          WHERE aab001 = prm_aab001
            AND aac001 = prm_aac001
            AND aae140 = prm_aae140
            AND aae002 = prm_aae002
            AND aae143 = pkg_comm.AAE143_JSBC;
      prm_aac040_new        NUMBER;
      num_i                 NUMBER;
      var_flag              NUMBER;
      num_aae180            NUMBER;

   BEGIN
      /*��������*/
      prm_AppCode    := pkg_COMM.gn_def_OK ;
      prm_ErrMsg     := ''                  ;
      var_procNo     := 'A02';
      prm_aac040_new := prm_aac040;
      num_aae003  := TO_NUMBER(TO_CHAR(SYSDATE,'yyyymm'));

      --����Ƿ����Ӧ�ɵĲ�������
      SELECT COUNT(yae202)
        INTO num_count
        FROM ac08a1
       WHERE aab001 = prm_aab001
         AND aac001 = prm_aac001
         AND aae140 = prm_aae140
         AND aae002 = prm_aae002
         AND aae143 IN (pkg_comm.AAE143_JSBC,        -- ��������
                        pkg_comm.AAE143_BLBC);       -- ��������
      IF num_count > 0 THEN
         prm_AppCode := gs_FunNo||var_procNo||'01';
         prm_ErrMsg  := '��λ:'||prm_aab001||
                        ';��Ա:'||prm_aac001||
                        ';����:'||pkg_COMM.fun_getAaa103('aae140',prm_aae140)||
                        ';�ں�:'||prm_aae002||
                        '����δ�ɷѵĲ�����Ϣ�����ȳ���֮ǰ������Ϣ���ٽ��б��β��������';
         RETURN;
      END IF ;
      --��ȡ��λ�α�״̬
      /*
      �Ʋ���λ��������Աֻ�ܶ����ݽɷѲ��ֽ��в���
      */
      SELECT aae119
        INTO var_aae119
        FROM ab01
       WHERE aab001 = prm_aab001;
      --��ȡ��Ա״̬
      SELECT aac008
        INTO var_aac008
        FROM ac01
       WHERE aac001 = prm_aac001;
      --��ȡӦ��ʵ����Ϣ
      IF prm_aae140 IN(  pkg_comm.AAE140_SYE ,
                         pkg_comm.AAE140_JBYL,
                         pkg_comm.AAE140_GS  ,
                         pkg_comm.AAE140_SYU ,
                         pkg_comm.AAE140_GWYBZ)
      THEN
         --��ȡ���Ӧ��Ӧʵ����Ϣ
         BEGIN
            SELECT NVL(SUM(CASE WHEN aae143 IN(pkg_comm.AAE143_ZCJF,  --�����ɷ�
                                               pkg_comm.AAE143_ZYJF,  --�������½ɷ�
                                               pkg_comm.AAE143_BJ  ,  --����
                                               pkg_comm.AAE143_BS  ,  --����
                                               pkg_comm.AAE143_JSBC,  --��������
                                               pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                               pkg_comm.AAE143_DLJF)  --������Ա�ɷ�                                               pkg_co

                                THEN aae180
                                ELSE 0
                                END),0),  --�ɷѻ���
                   NVL(SUM(CASE WHEN aae143 IN(pkg_comm.AAE143_ZCJF, --�����ɷ�
                                               pkg_comm.AAE143_ZYJF,  --�������½ɷ�
                                               pkg_comm.AAE143_BJ  , --����
                                               pkg_comm.AAE143_BS  , --����
                                               pkg_comm.AAE143_JSBC, --��������
                                               pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                               pkg_comm.AAE143_DLJF) --������Ա�ɷ�
                                THEN YAA333
                                ELSE 0
                                END),0),  --���ʻ�����
                   NVL(SUM(CASE WHEN aae143 IN(pkg_comm.AAE143_ZCJF, --�����ɷ�
                                               pkg_comm.AAE143_ZYJF,  --�������½ɷ�
                                               pkg_comm.AAE143_BJ  , --����
                                               pkg_comm.AAE143_BS  , --����
                                               pkg_comm.AAE143_BLBC, --��������
                                               pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                               pkg_comm.AAE143_DLJF) --������Ա�ɷ�
                                THEN aaa041
                                ELSE 0
                                END),0),  --���˽ɷѱ���
                   NVL(SUM(CASE WHEN aae143 IN(pkg_comm.AAE143_ZCJF, --�����ɷ�
                                               pkg_comm.AAE143_ZYJF,  --�������½ɷ�
                                               pkg_comm.AAE143_BJ  , --����
                                               pkg_comm.AAE143_BS  , --����
                                               pkg_comm.AAE143_BLBC, --��������
                                               pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                               pkg_comm.AAE143_DLJF) --������Ա�ɷ�
                                               AND yae518 NOT IN (SELECT A.YAE518
                                                                    FROM ab08b1 A
                                                                   WHERE A.AAB001 = PRM_AAB001
                                                                     AND A.AAE041 <= PRM_AAE002
                                                                     AND A.AAE042 >= PRM_AAE002
                                                                     AND A.YAB139 = PRM_YAB139
                                                                     AND A.AAE140 = PRM_AAE140
                                                                     AND A.YAE517_OLD = 'H12'
                                                                     AND (EXISTS (SELECT *
                                                                                    FROM AC08A1 B
                                                                                   WHERE A.YAE518 = B.YAE518
                                                                                     AND B.AAC001 = PRM_AAC001
                                                                                     AND b.AAB001 = PRM_AAB001
                                                                                     AND b.aae002 = PRM_AAE002
                                                                                     AND b.aae140 = PRM_AAE140) OR EXISTS
                                                                          (SELECT *
                                                                             FROM AC08 B
                                                                            WHERE A.YAE518 = B.YAE518
                                                                              AND B.AAC001 = PRM_AAC001
                                                                              AND b.AAB001 = PRM_AAB001
                                                                              AND b.aae002 = PRM_AAE002
                                                                              AND b.aae140 = PRM_AAE140)))
                                THEN aaa042
                                ELSE 0
                                END),0),  --��λ�ɷѱ���
                   NVL(SUM(CASE WHEN aae143 IN(pkg_comm.AAE143_ZCJF, --�����ɷ�
                                               pkg_comm.AAE143_ZYJF,  --�������½ɷ�
                                               pkg_comm.AAE143_BJ  , --����
                                               pkg_comm.AAE143_BS  , --����
                                               pkg_comm.AAE143_BLBC, --��������
                                               pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                               pkg_comm.AAE143_DLJF) --������Ա�ɷ�
                                THEN yaa017
                                ELSE 0
                                END),0),  --���˽ɷѻ�ͳ�����
                   NVL(SUM(CASE WHEN aae143 IN(pkg_comm.AAE143_ZCJF, --�����ɷ�
                                               pkg_comm.AAE143_ZYJF,  --�������½ɷ�
                                               pkg_comm.AAE143_BJ  , --����
                                               pkg_comm.AAE143_BS  , --����
                                               pkg_comm.AAE143_BLBC, --��������
                                               pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                               pkg_comm.AAE143_DLJF) --������Ա�ɷ�
                                THEN aaa043
                                ELSE 0
                                END),0),   --��λ�ɷѻ��ʻ�����
                  NVL(SUM(CASE WHEN aae143 IN(pkg_comm.AAE143_ZCJF, --�����ɷ�
                                               pkg_comm.AAE143_ZYJF,  --�������½ɷ�
                                               pkg_comm.AAE143_BJ  , --����
                                               pkg_comm.AAE143_BS  , --����
                                               pkg_comm.AAE143_BLBC, --��������
                                               pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                               pkg_comm.AAE143_DLJF) --������Ա�ɷ�
                                THEN ala080
                                ELSE 0
                                END),0)

              INTO num_yac004_old,                  --�ɷѻ���
                   num_YAA333_old,                  --���˻�����
                   num_aaa041_old,                  --���˽ɷѱ���
                   num_aaa042_old,                  --��λ�ɷѱ���
                   num_yaa017_old,                  --���˽ɷѻ�ͳ�����
                   num_aaa043_old,                  --��λ�ɷѻ��˻�����
                   num_ala080_old
              FROM
                   (SELECT aae143,
                           aae180,
                           YAA333,
                           aaa041,
                           aaa042,
                           yaa017,
                           aaa043,
                           ala080,
                           yae518
                      FROM ac08
                     WHERE aac001 = prm_aac001
                       AND aab001 = prm_aab001
                       AND aae002 = prm_aae002
                       AND yab139 = prm_yab139
                       AND aae140 = prm_aae140
                       AND aae143 IN(pkg_comm.AAE143_ZCJF, --�����ɷ�
                                     pkg_comm.AAE143_ZYJF,  --�������½ɷ�
                                     pkg_comm.AAE143_JSBC, --��������
                                     pkg_comm.AAE143_BJ  , --����
                                     pkg_comm.AAE143_BS  , --����
                                     pkg_comm.AAE143_DLJF, --������Ա�ɷ�
                                     pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                     pkg_comm.AAE143_BLBC) --��������
                       AND yaa330 = pkg_comm.YAA330_BL  --����ģʽ
                     UNION
                    SELECT aae143,
                           aae180,
                           YAA333,
                           aaa041,
                           aaa042,
                           yaa017,
                           aaa043,
                           ala080,
                           yae518
                      FROM ac08a1
                     WHERE aac001 = prm_aac001
                       AND aab001 = prm_aab001
                       AND aae002 = prm_aae002
                       AND yab139 = prm_yab139
                       AND aae140 = prm_aae140
                       AND aae143 IN(pkg_comm.AAE143_ZCJF, --�����ɷ�
                                     pkg_comm.AAE143_ZYJF,  --�������½ɷ�
                                     pkg_comm.AAE143_JSBC, --��������
                                     pkg_comm.AAE143_BJ  , --����
                                     pkg_comm.AAE143_BS  , --����
                                     pkg_comm.AAE143_DLJF, --������Ա�ɷ�
                                     pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                     pkg_comm.AAE143_BLBC) --��������
                       AND yaa330 = pkg_comm.YAA330_BL  --����ģʽ
                     )
                     ;
            EXCEPTION
               WHEN OTHERS THEN
                  prm_AppCode := gs_FunNo||var_procNo||'01';
                  prm_ErrMsg  := 'û�л�ȡ��������Ϊ'||pkg_COMM.fun_getAaa103('aae140',prm_aae140)||'�Ľɷ���Ϣ'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
               RETURN;
         END;



         BEGIN
            --��ȡac08�ǲ���ɷѵĽɷѹ������ͷ�����Դ��
            SELECT yac503,
                   aac040,
                   yae010,
                   akc023,
                   yac176,
                   yac168,
                   yac505,
                   aaa040,
                   yaa330,
                   yaa310,
                   akc021,
                   ykc120,
                   aac008,
                   aae114
              INTO var_yac503,
                   num_aac040,
                   prm_yae010,
                   prm_age,
                   prm_yac176,
                   prm_yac168_old,                  --ũ�񹤱�־
                   prm_yac505_old,                  --�α��ɷ���Ա���
                   prm_aaa040_old,                  --�������
                   prm_yaa330,
                   prm_yaa310,
                   prm_akc021_old,
                   prm_ykc120_old,
                   prm_aac008_old,
                   prm_aae114_old
              FROM (SELECT yac503,
                           aac040,
                           yae010,
                           akc023,
                           yac176,
                           yac168,
                           yac505,
                           aaa040,
                           yaa330,
                           yaa310,
                           akc021,
                           ykc120,
                           aac008,
                           pkg_comm.AAE114_YSJ AS aae114
                      FROM ac08
                     WHERE aac001 = prm_aac001
                       AND aab001 = prm_aab001
                       AND aae002 = prm_aae002
                       AND yab139 = prm_yab139
                       AND aae140 = prm_aae140
                       AND aae143 IN(pkg_comm.AAE143_ZCJF,
                                     pkg_comm.AAE143_ZYJF,  --�������½ɷ�
                                     pkg_comm.AAE143_BJ,
                                     pkg_comm.AAE143_BS,
                                     pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                     pkg_comm.AAE143_DLJF)
                       AND yaa330 = pkg_comm.YAA330_BL  --����ģʽ
                     UNION
                    SELECT yac503,
                           aac040,
                           yae010,
                           akc023,
                           yac176,
                           yac168,
                           yac505,
                           aaa040,
                           yaa330,
                           yaa310,
                           akc021,
                           ykc120,
                           aac008,
                           pkg_comm.AAE114_QJ AS aae114
                      FROM ac08a1
                     WHERE aac001 = prm_aac001
                       AND aab001 = prm_aab001
                       AND aae002 = prm_aae002
                       AND yab139 = prm_yab139
                       AND aae140 = prm_aae140
                       AND aae143 IN(pkg_comm.AAE143_ZCJF,
                                     pkg_comm.AAE143_ZYJF,  --�������½ɷ�
                                     pkg_comm.AAE143_BJ,
                                     pkg_comm.AAE143_BS,
                                     pkg_comm.AAE143_TXBHZH, --������Ա�����ʻ�
                                     pkg_comm.AAE143_DLJF)
                       AND yaa330 = pkg_comm.YAA330_BL  --����ģʽ
                       )
                       ;
            --2010-10-04
            --��ϵͳ201009֮ǰ��Ƿ��,aac008Ϊ���ݣ�����akc021Ϊ��ְ(����ϵͳ���ݽ�תʱֻ����������)��
            --�����ڲ����ʱ��201009ǰ������ aac008Ϊ����akc021Ϊ��ְ����akc021תΪ����������
            IF prm_aae002 <= 201009 THEN
               IF prm_aac008_old = pkg_comm.AAC008_TX AND prm_akc021_old = pkg_comm.AKC021_ZZ THEN
                  prm_akc021_old := pkg_comm.AKC021_TX;
               END IF ;
            END IF ;
         EXCEPTION
            WHEN OTHERS THEN
               prm_AppCode := gs_FunNo||var_procNo||'02';
               prm_ErrMsg  := 'û�л�ȡ��������Ϊ'||pkg_COMM.fun_getAaa103('aae140',prm_aae140)||'�Ľɷ���Ϣ'||prm_aae002;
            RETURN;
         END;
         --�����ȡ�ɵĽɷѱ����ʹ���1 ����ʾ���ܽ��нɷѲ������
         IF prm_aaa041 + prm_aaa042 + prm_yaa017 + prm_aaa043 > 1 THEN
            prm_AppCode := gs_FunNo||var_procNo||'02';
            prm_ErrMsg  := '�ɷѱ����ʹ���1���޷����нɷѲ������';
            RETURN;
         END IF;
      END IF;

      IF prm_bcfs = '0' THEN --��������
         --��ȡ�ɷѱ���
         pkg_P_Comm_CZ.prc_P_getPaymentProportion(
                                                     prm_aac001,       --���˱��(��Ҫ���ҽ�ƵĻ����ʻ�����,�������ֲ���Ҫ����)
                                                     prm_aab001,       --��λ���
                                                     prm_Yab139,       --�α�����������
                                                     prm_aae140,       --����
                                                     prm_akc021_old,   --ҽ����Ա���
                                                     prm_ykc120_old,   --ҽ���չ���Ա���
                                                     prm_aae002,       --��ʼ�ں�
                                                     prm_aaa040_old,   --����������
                                                     prm_aaa041,       --���˽ɷѱ���
                                                     prm_yaa017,       --���˽ɷѻ�ͳ�����
                                                     prm_aaa042,       --��λ�ɷѱ���
                                                     prm_aaa043,       --��λ�ɷѻ��˻�����
                                                     num_yaa028,       --�����ʻ�����
                                                     prm_ala080,       --���˸�������
                                                     prm_age   ,       --����
                                                     prm_yac176,       --����
                                                     prm_yaa310,       --��������
                                                     prm_yaa330,       --�ɷѱ���ģʽ
                                                     prm_yae010,       --������Դ
                                                     prm_AppCode,      --ִ�д���
                                                     prm_ErrMsg)
                                                     ;
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            RETURN;
         END IF;
         --����������ac08����Ļ���
         prm_yac503 := var_yac503;
         prm_aac040 := num_aac040;
         prm_yaa333 := num_yaa333_old;
         prm_yac004 := num_yac004_old;
         prm_aaa041 := prm_aaa041 - num_aaa041_old;                  --���˽ɷѱ���
         prm_yaa017 := prm_yaa017 - num_yaa017_old;                  --��λ�ɷѱ���
         prm_aaa042 := prm_aaa042 - num_aaa042_old;                  --���˽ɷѻ�ͳ�����
         prm_aaa043 := prm_aaa043 - num_aaa043_old;                  --��λ�ɷѻ��˻�����

      END IF;
      IF prm_bcfs = '1' THEN --��������
         --ԭ�й���Ϊ��ְ�ɷ�����¹���Ϊ����¼�����Ͻ�
         IF var_yac503 <> prm_yac503 AND prm_yac503 = pkg_comm.YAC503_LRYLJ THEN
            prm_AppCode := gs_FunNo||var_procNo||'02';
            prm_ErrMsg  := 'ԭ�й������Ͳ���Ĺ������ͬ�����ܽ��в��';
            RETURN;
         END IF ;
         --�Խɷѹ��ʽ��б��׷ⶥ
         --�Ʋ���λ����ְ��Ա�����й��ʱ��
         IF var_aae119 = pkg_comm.AAE119_PC AND var_aac008 = pkg_comm.AAC008_ZZ THEN
            prm_aac040 := num_yac004_old ;     -- �걨����
            prm_yac004 := num_yac004_old ;     -- �ɷѻ���
            prm_yaa333 := num_yaa333_old ;     -- �ʻ�����
         ELSE
            pkg_P_Comm_CZ.prc_P_getContributionBase(
                                                   prm_aac001,             --���˱��
                                                   prm_aab001,
                                                   prm_aac040,             --�ɷѹ���
                                                   prm_yac503,             --�������
                                                   prm_aae140,             --��������
                                                   prm_yac505_old,         --�ɷ���Ա���
                                                   prm_yab136,             --��λ��������
                                                   prm_aae002,             --�ѿ�������/*����ϵͳ�ں�*//*20100928 �α������ ����¼�빤�ʵĲ��ն�����ǰ��ƽ���ʲ���*/
                                                   prm_yab139,             --�α�����������
                                                   prm_yac004,             --�ɷѻ���
                                                   prm_AppCode,            --ִ�д���
                                                   prm_ErrMsg);            --ִ�н��

            IF prm_AppCode <> pkg_comm.gn_def_OK THEN
               RETURN;
            END IF;
         END IF ;
         --�����������
         prm_yac004 := prm_yac004 - num_yac004_old;
         prm_aac040 := prm_yac004;

         IF prm_aae140 IN (pkg_comm.aae140_JBYL,     --����ҽ��
                           pkg_comm.AAE140_GWYBZ)    --����Ա����
         THEN
            IF prm_yaa333 IS NULL OR prm_yaa333 = 0 THEN
               prm_yaa333 := prm_yac004;
            ELSE
               prm_yaa333 := prm_yaa333 - num_yaa333_old;
            END IF;
         ELSE
            prm_yaa333 := 0;
         END IF;

         prm_aaa041 := num_aaa041_old;                  --���˽ɷѱ���
         prm_yaa017 := num_yaa017_old;                  --��λ�ɷѱ���
         prm_aaa042 := num_aaa042_old;                  --���˽ɷѻ�ͳ�����
         prm_aaa043 := num_aaa043_old;                  --��λ�ɷѻ��˻�����
         prm_ala080 := num_ala080_old;

         --modify by fenggg at 20181202 begin
         --2019����ǰ���������ջ������Ͳ��˷�,���Ը�������������0 ��2019���Ժ��˷� 
         IF prm_yab139 = '610127' and substr(prm_aae002,1,4) < 2019 and prm_yac004 < 0 then
            prm_yac004 := 0;
         END IF;
         --modify by fenggg at 20181202 end

         --����û�仯��
         IF prm_yac004 = 0 THEN
            prm_AppCode := gs_FunNo||var_procNo||'02';
            prm_ErrMsg  := '����û�з����仯�����ò���';
            RETURN;
         END IF;

         /** �α��� 3¥���� ���ļ� �� ������ ��������
             ������ ��� ȡ�������ƣ����ļ�ͬ�⣬����������
             2010-11-22  �޸�
         --����ҽ�ƽɷѻ����걨���ˣ������˿����
         IF prm_aae140 = pkg_comm.aae140_JBYL THEN
            IF prm_akc021_old <> pkg_comm.akc021_ZZ THEN
               IF prm_yac004 < 0 THEN
                  prm_AppCode := gs_FunNo||var_procNo||'02';
                  prm_ErrMsg  := '����ҽ��������Աֻ�����ְ�ɷѻ����걨���˽��д���';
                  RETURN;
               END IF;
            END IF;
         END IF;
         */

         --����Ա����ֻ��Խɷѻ����걨����
         IF prm_aae140 = pkg_comm.aae140_GWYBZ THEN
            IF prm_yaa333 <= 0 THEN
               prm_AppCode := gs_FunNo||var_procNo||'02';
               prm_ErrMsg  := '����Ա����ֻ��Խɷѻ����걨���˽��д���';
               RETURN;
            END IF;
         END IF;
      END IF;

      IF prm_aae140 = pkg_comm.AAE140_JBYL THEN

         IF var_aae119 = pkg_comm.AAE119_PC THEN
            SELECT akc021
              INTO var_akc021
              FROM kc01
             WHERE aac001 = prm_aac001;
            --��Ա��ǰΪ���ݣ����ǽɷѼ�¼Ϊ��ְ����������в���
            IF var_akc021 = pkg_comm.AKC021_TX AND prm_akc021_old = pkg_comm.AKC021_ZZ THEN
               prm_AppCode := gs_FunNo||var_procNo||'03';
               prm_ErrMsg  := '�Ʋ���λ��������Ա��ֻ�ܶ����ݲ��ֽ��в���';
               RETURN;
            END IF ;
         END IF ;
      END IF ;

      --����Ӧ�·�������ǰ���Ƿ���ϵͳ���������ݲ�����
      IF prm_bcfs = '1' THEN --��������
         num_i := 0;
         var_flag := 0;
         FOR rec_ac08 IN cur_ac08 LOOP
            num_i := num_i + 1;
            IF rec_ac08.yac234 = -1 THEN
               var_flag := 1;
               num_aae180 := rec_ac08.aae180;
            END IF;
         END LOOP;
         --������ϵͳ���ݲ������� ������Ա��Ϊ���й��������������
         IF var_flag = 1 AND num_i = 1 THEN
            SELECT akc021
              INTO var_akc021
              FROM kc01
             WHERE aac001 = prm_aac001 ;
            --��Ա��Ϊ��������Ա�򱨴�
            IF var_akc021 <> pkg_comm.AKC021_TX  THEN
               --����
               prm_AppCode := gs_FunNo||var_procNo||'03';
               prm_ErrMsg  := '��Ա����ϵͳ�������ְת���ݣ�������ϵͳ�в����˲�����Ϣ����ǰ��Ա״̬��Ϊ���ݣ���ϵͳ��֧�ָ�����Ա���ڽ��в���';
               RETURN;
            ELSE
               prm_yac004 := prm_aac040_new - num_aae180;                  --�ɷѻ���
               IF prm_yac004 = 0 THEN
                  prm_AppCode := gs_FunNo||var_procNo||'03';
                  prm_ErrMsg  := '����û�з����仯,����Ҫ����!';
                  RETURN;
               END IF ;
               prm_aac040 := prm_yac004;
               prm_yaa333 := prm_yac004;

               prm_aaa041 := 0;                  --���˽ɷѱ���
               prm_yaa017 := 0;                  --��λ�ɷѱ���
               prm_aaa042 := 0;                  --���˽ɷѻ�ͳ�����
               prm_aaa043 := 0.05;               --��λ�ɷѻ��˻�����

               prm_akc021_old := pkg_comm.AKC021_TX;
            END IF ;
         ELSIF var_flag = 1 AND num_i > 1 THEN
            --����
            prm_AppCode := gs_FunNo||var_procNo||'03';
            prm_ErrMsg  := '��Ա����ϵͳ�������ְת���ݣ�������ϵͳ�в����˲�����Ϣ����ϵͳ��֧�ָ�����Ա���ڽ��ж�β���';
            RETURN;
         ELSE
            NULL;
         END IF;
      END IF ;
   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'16';
         prm_ErrMsg  := '��ȡӦʵ����Ϣ����:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END prc_p_checkYSJ;

   /*****************************************************************************
   ** �������� pkg_p_salaryExamineAdjust_ns  (add by fenggg at 20190709)
   ** ���̱�� : 03
   ** ҵ�񻷽� ������ר�ò���
   ** �������� ������ÿ�ڻ���������Ĳ�ͬ������ͬ�Ĳ������Ե�λ���в���
   ******************************************************************************
   ** ��    �ߣ�            �������� ��2019-07-09   �汾��� ��Ver 1.0.0
   ** ��    ��: Courier New  ��    �� ��10
   ** ��    �ģ�
   ******************************************************************************
   ** ��    ע��
   **
   *****************************************************************************/
   PROCEDURE pkg_p_salaryExamineAdjust_ns(
                                     prm_aaz002      IN  VARCHAR2,
                                     prm_aaz083      IN  VARCHAR2,
                                     prm_aab001      IN   ab02.aab001%TYPE, --��λ���
                                     prm_aae003      IN   ac08.aae003%TYPE, --�����ں�
                                     prm_aae001      IN   ab05.aae001%TYPE, --�������
                                     prm_bcfs        IN   NUMBER          , --���ʽ(0 �ɷѱ������ 1 �ɷѻ������
                                     prm_collectflag IN   NUMBER          , --������־(0:��;1:��
                                     prm_tkfs        IN   NUMBER          , --�˿ʽ(1�����ֽ�2������ת��
                                     prm_check       IN   NUMBER          , --����Ƿ������Ч�������ݡ�0������顣1����顣
                                     prm_yab401      IN   ab08.yab401%TYPE, --��Ϣ��־
                                     prm_yab400      IN   ab08.yab400%TYPE, --���ɽ��־
                                     prm_aab033      IN   ab02.aab033%TYPE, --���շ�ʽ
                                     prm_yab139      IN   ab08.yab139%TYPE, --�����α�������
                                     prm_yab003      IN   ab08.yab003%TYPE, --�籣�������
                                     prm_aae011      IN   ab08.aae011%TYPE, --������
                                     prm_aae036      IN   ab08.aae036%TYPE, --����ʱ��
                                     prm_yab222      IN   ab08.yab222%TYPE, --�������κ�
                                     prm_aae076      OUT  ab08.aae076%TYPE, --����ӿ���ˮ��
                                     prm_AppCode     OUT  VARCHAR2,         --ִ�д���
                                     prm_ErrMsg      OUT  VARCHAR2)         --ִ�н��
   IS
      var_procNo      VARCHAR2(5);         --���̺�

      num_count       NUMBER     ;         --

      var_aac001      ac01.aac001%TYPE  ;  --���˱��

      num_aab156      ab08.aab156%TYPE  ;  --Ƿ�ѽ��
      var_aae140      ab08.aae140%TYPE  ;  --������Ϣ
      var_yae010      ab08.yae010%TYPE  ;  --������Դ

      var_yad052      ab15a1.yad052%TYPE;
      var_yad060      ab15a1.yad060%TYPE;

      var_yab136      ab01.yab136%TYPE  ;  --��λ��������
      var_aab019      ab01.aab019%TYPE  ;  --��λ����
      var_aab020      ab01.aab020%TYPE  ;  --��������
      var_aab021      ab01.aab021%TYPE  ;  --������ϵ
      var_aab022      ab01.aab022%TYPE  ;  --��ҵ����
      var_YKB109      ab01.YKB109%TYPE  ;  --�Ƿ����ܹ���Աͳ�����
      var_yab275      ab01.yab275%TYPE  ;  --ҽ�Ʊ���ִ�а취
      var_yab380      ab01.yab380%TYPE  ;
      var_ykb110      ab01.ykb110%TYPE  ;  --Ԥ���˻���־
      var_aae076      ab08.aae076%TYPE  ;  --������ˮ��
      var_yae518_sk   ab08.yae518%TYPE  ;  --�˶���ˮ��
      var_yae518_tk   ab08.yae518%TYPE  ;  --ʵ���˿�˶���ˮ��
      var_yae518_qftk ab08.yae518%TYPE  ;  --Ƿ���˿�˶���ˮ��
      var_yae518_dz   ab08.yae518%TYPE  ;  --�˶���ˮ��
      num_aae002      NUMBER;

      var_flag        VARCHAR2(3)       ;  --�Ƿ�����˲������0 ��û�У�1�������ˡ�

      --ÿ����ÿ�����ֽ���һ����ϸд��
      CURSOR cur_aac001
      IS
         SELECT DISTINCT aac001
           FROM tmp_grbs02
          WHERE aae100 = pkg_comm.AAE100_YX;

      --����Ҫ�������յ�����
      CURSOR cur_tmp_grbs02_ts
      IS
         SELECT aac001,
                aae002,  --�ѿ������ں�
                aae140   --����
           FROM tmp_grbs02
          WHERE aae100 = pkg_comm.AAE100_YX       --��Ч��־����Ч
            AND yac004 < 0 ;

      --ʵ���˿�����
      CURSOR cur_ab08_sjts
      IS
         SELECT SUM(aab156) AS aab156,
                aae140               ,
                MIN(aae041) AS aae041,
                MAX(aae042) AS aae042
           FROM ab08
          WHERE yae518 = var_yae518_tk
            AND yae517 = pkg_Comm.YAE517_H17    --��������
            AND yae010 = pkg_comm.YAE010_ZC
       GROUP BY aae140;

      CURSOR cur_ac08a1_sk                                     -- ��ϸ��Ϣ
      IS
         SELECT a.aae140,
                a.yae010,    --������Դ
                MIN(a.aae002) AS aae041,
                MAX(a.aae002) AS aae042,
                COUNT(DISTINCT a.aac001) yae231,   --����
                a.yae203   , --������Դ����
                max(CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                     WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                     ELSE pkg_comm.YAB538_LX
                     END) YAB538,
                NVL(SUM(a.aae180),0) aab120,   --���˽ɷѻ����ܶ�
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
           FROM ac08a1check a
          WHERE a.yae518 = var_yae518_sk
            AND a.aab001 = prm_aab001
            AND a.aae003 = prm_aae003
          GROUP BY a.aae140,
                   a.yae010,    --������Դ
                   a.yae203,    --������Դ����
                   CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                        WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                        ELSE pkg_comm.YAB538_LX
                        END;

      CURSOR cur_ac08a1_tk                                      -- ��ϸ��Ϣ
      IS
         SELECT a.aae140,
                a.yae010,    --������Դ
                MIN(a.aae002) AS aae041,
                MAX(a.aae002) AS aae042,
                COUNT(DISTINCT a.aac001) yae231,   --����
                a.yae203   , --������Դ����
                max(CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                     WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                     ELSE pkg_comm.YAB538_LX
                     END) YAB538,
                NVL(SUM(a.aae180),0) aab120,   --���˽ɷѻ����ܶ�
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
           FROM ac08a1check a
          WHERE a.yae518 = var_yae518_tk
            AND a.aab001 = prm_aab001
            AND a.aae003 = prm_aae003
          GROUP BY a.aae140,
                   a.yae010,    --������Դ
                   a.yae203,    --������Դ����
                   CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                        WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                        ELSE pkg_comm.YAB538_LX
                        END;
                        
      --add by fenggg at 20190709 begin               
      CURSOR cur_ac08a1_tsk                                     
      IS
         SELECT a.aae140,
                a.yae010,    --������Դ
                MIN(a.aae002) AS aae041,
                MAX(a.aae002) AS aae042,
                COUNT(DISTINCT a.aac001) yae231,   --����
                a.yae203   , --������Դ����
                max(CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                     WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                     ELSE pkg_comm.YAB538_LX
                     END) YAB538,
                NVL(SUM(a.aae180),0) aab120,   --���˽ɷѻ����ܶ�
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
           FROM ac08a1check a
          WHERE a.yae518 = var_yae518_qftk
            AND a.aab001 = prm_aab001
            AND a.aae003 = prm_aae003
          GROUP BY a.aae140,
                   a.yae010,    --������Դ
                   a.yae203,    --������Դ����
                   CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                        WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                        ELSE pkg_comm.YAB538_LX
                        END;
                        
      --add by fenggg at 20190709 end           
                        
   BEGIN
      --��ʼ������
      prm_AppCode    := pkg_COMM.gn_def_OK ;
      prm_ErrMsg     := '' ;
      var_procNo     := '03';
      var_flag       := '0' ;  --�Ƿ�����˲������0 ��û�У�1�������ˡ�

      SELECT COUNT(1)
        INTO num_count
        FROM tmp_grbs01;
      IF num_count <= 0 THEN
         prm_AppCode := gs_FunNo||var_procNo||'01';
         prm_ErrMsg  := '�����ɷѲ����������ԭ��û��д��tmp_grbs01��Ϣ';
         RETURN;
      END IF;

      --���tmp_grbs01,������tmp_grbs02��Ϣ
      prc_p_checkData(prm_aab001   ,   --��λ���
                      prm_bcfs     ,   --���ʽ��0 �ɷѱ������ 1 �ɷѻ������
                      prm_yab139   ,   --�α�����������
                      prm_yab003   ,   --�籣�������
                      prm_AppCode  ,           --ִ�д���
                      prm_ErrMsg   );            --ִ�н��
      IF prm_AppCode <> pkg_COMM.gn_def_OK THEN
         RETURN;
      END IF;

      insert into tmp_grbs01_20190822 select * from tmp_grbs01;
      insert into tmp_grbs02_20190822 select * from tmp_grbs02;
      
      --����Ƿ������Ч�Ĳ�������
      INSERT INTO tmp_grbc02 SELECT * FROM tmp_grbs02 WHERE aae100 = pkg_comm.AAE100_YX;
      IF SQL%ROWCOUNT <= 0 THEN
         IF prm_check = 0 THEN
            RETURN ;
         ELSE
            prm_AppCode := gs_FunNo||var_procNo||'02';
            prm_ErrMsg  := '�����ɷѲ����������ԭ��û����Ҫ���������'||prm_check;
            RETURN;
         END IF ;
      END IF;
      --��������Դ
      BEGIN
         SELECT DISTINCT yae010
           INTO var_yae010
           FROM tmp_grbc02
          WHERE aae100 = pkg_comm.AAE100_YX;       --��Ч��־����Ч
      EXCEPTION
         WHEN TOO_MANY_ROWS THEN
            prm_AppCode    := gs_FunNo||var_procNo||'01';
            prm_ErrMsg     := '���β��������д��ڶ��ַ�����Դ�����ܼ�������ȷ�ϣ�' ;
            RETURN;
         WHEN OTHERS THEN
            prm_AppCode    := gs_FunNo||var_procNo||'01';
            prm_ErrMsg     := '���β��������л�ȡ������Դ�������ܼ�������ȷ�ϣ�' ||SQLERRM ;
            RETURN;
      END ;

      --��ȡ��λ������Ϣ
      pkg_p_checkEmployerFeeCo.prc_p_checkEmployerBase
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
            prm_ErrMsg ); --ִ�н��
      IF prm_AppCode <> pkg_comm.gn_def_OK  THEN
         RETURN;
      END IF;
      
      --Ƿ�Ѳ��� 
      --������������ ������ϸ
      DELETE tmp_grbs02;
      INSERT INTO tmp_grbs02 SELECT * FROM tmp_grbc02 WHERE NOT ��(aae114 = pkg_comm.AAE114_YSJ AND yac004 < 0 ) OR (aae114 = pkg_comm.AAE114_QJ AND yac004 < 0 ));
      var_yae518_sk := NULL;
      --���ɸ�����ϸ
       INSERT INTO AE23(
                         aaz083, --���������ɼƻ��¼�ID
                         aaz002, --ҵ����־ID
                         aaz010, --������ID
                         aae013, --��ע
                         aae011, --������
                         aae036, --����ʱ��
                         yab003, --������������
                         aae016,  --���˱�־
                         yae099
                         )
                values(
                         prm_aaz083,
                         prm_aaz002,
                         prm_aab001,
                         null,
                         prm_aae011,
                         prm_aae036,
                         prm_yab003,
                         '0',
                         null
                         );
      FOR rec_aac001 IN cur_aac001 LOOP
         IF var_yae518_sk IS NULL THEN
            var_yae518_sk := pkg_comm.fun_GetSequence(NULL,'yae518');
         END IF ;
         var_aac001 := rec_aac001.aac001;
         prc_p_CreateDetail(prm_aaz002     ,
                            prm_aaz083     ,
                            var_yae518_sk  ,   --�˶���ˮ��
                            prm_aab001     ,   --��λ���
                            var_aac001     ,   --���˱��
                            prm_aae003     ,   --�����ں�
                            prm_yab139     ,   --�����α�������
                            prm_yab003     ,   --�籣�������
                            prm_aae011     ,   --������
                            prm_aae036     ,   --����ʱ��
                            prm_AppCode    ,   --ִ�д���
                            prm_ErrMsg         --ִ�н��
                         );
         IF prm_AppCode <> pkg_COMM.gn_def_OK THEN
            GOTO label_ERROR ;
         END IF;

      END LOOP;

      --�������Ƿ�Ѳ������� д��һ��ab08
      FOR rec_ac08a1_sk IN  cur_ac08a1_sk LOOP
         /*���ɺ˶�����Ӧ����Ϣ��*/
         pkg_p_checkEmployerFeeCo.prc_p_insertab08check(
                             var_yae518_sk, --�˶���ˮ��
                             prm_aab001, --��λ���
                             NULL      , --���˱��
                             rec_ac08a1_sk.aae140, --��������
                             prm_aae003, --�����ں�
                             rec_ac08a1_sk.aae041, --��ʼ�ں�
                             rec_ac08a1_sk.aae042, --��ֹ�ں�
                             rec_ac08a1_sk.yab538, --�ɷ���Ա״̬
                             rec_ac08a1_sk.yae010,--������Դ
                             pkg_Comm.YAE517_H12, --�˶�����
                             prm_yab222, --�������κ�
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
                             prm_aae036,   --����ʱ��
                             prm_yab139, --�α�����������
                             prm_yab003, --�籣�������
                             prm_aaz002,
                             prm_aaz083,
                             prm_AppCode,         --ִ�д���
                             prm_ErrMsg );        --ִ�н��
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            prm_ErrMsg := prm_ErrMsg||'1';
         END IF;

         var_flag := '1';
      END LOOP;
      
      --Ƿ�Ѳ��� begin  modify fenggg at 20190709 begin
      --�������� ���������ͣ�Ƿ�ѵ�������Ƿ�Ѹ��������Щ���ݷ��뵥������һ��yae518���������ʵ�ɺ�������գ�
      --           ��������ʱ��ֱ������H17��Ƿ�ѣ�������H12��Ƿ�ѣ��������ں��������˷�
      DELETE tmp_grbs02;
      INSERT INTO tmp_grbs02 SELECT * FROM tmp_grbc02 WHERE aae114 = pkg_comm.AAE114_QJ AND yac004 < 0 ;
      var_yae518_qftk := NULL;
      --���ɸ�����ϸ
      FOR rec_aac001 IN cur_aac001 LOOP
         IF var_yae518_qftk IS NULL THEN
            var_yae518_qftk := pkg_comm.fun_GetSequence(NULL,'yae518');
         END IF ;
         var_aac001 := rec_aac001.aac001;
         prc_p_CreateDetail(prm_aaz002     ,
                            prm_aaz083     ,
                            var_yae518_qftk  ,   --�˶���ˮ��
                            prm_aab001     ,   --��λ���
                            var_aac001     ,   --���˱��
                            prm_aae003     ,   --�����ں�
                            prm_yab139     ,   --�����α�������
                            prm_yab003     ,   --�籣�������
                            prm_aae011     ,   --������
                            prm_aae036     ,   --����ʱ��
                            prm_AppCode    ,   --ִ�д���
                            prm_ErrMsg         --ִ�н��
                         );
         IF prm_AppCode <> pkg_COMM.gn_def_OK THEN
            GOTO label_ERROR ;
         END IF;
      END LOOP;

      --Ƿ�� ������������һ��ab08
      FOR rec_ac08a1_tk IN  cur_ac08a1_tsk LOOP
         /*���ɺ˶�����Ӧ����Ϣ��*/
         pkg_p_checkEmployerFeeCo.prc_p_insertab08check(
                             var_yae518_qftk, --�˶���ˮ��
                             prm_aab001, --��λ���
                             NULL      , --���˱��
                             rec_ac08a1_tk.aae140, --��������
                             prm_aae003, --�����ں�
                             rec_ac08a1_tk.aae041, --��ʼ�ں�
                             rec_ac08a1_tk.aae042, --��ֹ�ں�
                             rec_ac08a1_tk.yab538, --�ɷ���Ա״̬
                             rec_ac08a1_tk.yae010,--������Դ
                             pkg_Comm.YAE517_H17, --�˶�����
                             prm_yab222, --�������κ�
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
                             CASE WHEN var_yae010 = pkg_Comm.YAE010_CZ THEN 0
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
                             prm_aae036,   --����ʱ��
                             prm_yab139, --�α�����������
                             prm_yab003, --�籣�������
                             prm_aaz002,
                             prm_aaz083,
                             prm_AppCode,         --ִ�д���
                             prm_ErrMsg );        --ִ�н��
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            prm_ErrMsg := prm_ErrMsg||'2';
            RETURN;
         END IF;

         var_flag := '1';
      END LOOP;
      --Ƿ�Ѳ��� end  modify fenggg at 20190709 end

      ----ʵ�ɸ��������˿������ϸ
      DELETE tmp_grbs02;
      INSERT INTO tmp_grbs02 SELECT * FROM tmp_grbc02 WHERE aae114 = pkg_comm.AAE114_YSJ AND yac004 < 0 ;
      var_yae518_tk := NULL;
      --���ɸ�����ϸ
      FOR rec_aac001 IN cur_aac001 LOOP
         IF var_yae518_tk IS NULL THEN
            var_yae518_tk := pkg_comm.fun_GetSequence(NULL,'yae518');
         END IF ;
         var_aac001 := rec_aac001.aac001;
         prc_p_CreateDetail(prm_aaz002     ,
                            prm_aaz083     ,
                            var_yae518_tk  ,   --�˶���ˮ��
                            prm_aab001     ,   --��λ���
                            var_aac001     ,   --���˱��
                            prm_aae003     ,   --�����ں�
                            prm_yab139     ,   --�����α�������
                            prm_yab003     ,   --�籣�������
                            prm_aae011     ,   --������
                            prm_aae036     ,   --����ʱ��
                            prm_AppCode    ,   --ִ�д���
                            prm_ErrMsg         --ִ�н��
                         );
         IF prm_AppCode <> pkg_COMM.gn_def_OK THEN
            GOTO label_ERROR ;
         END IF;
      END LOOP;

      --ʵ�ɸ�����������һ��ab08,���ҽ�������
      FOR rec_ac08a1_tk IN  cur_ac08a1_tk LOOP
         /*���ɺ˶�����Ӧ����Ϣ��*/
         pkg_p_checkEmployerFeeCo.prc_p_insertab08check(
                             var_yae518_tk, --�˶���ˮ��
                             prm_aab001, --��λ���
                             NULL      , --���˱��
                             rec_ac08a1_tk.aae140, --��������
                             prm_aae003, --�����ں�
                             rec_ac08a1_tk.aae041, --��ʼ�ں�
                             rec_ac08a1_tk.aae042, --��ֹ�ں�
                             rec_ac08a1_tk.yab538, --�ɷ���Ա״̬
                             rec_ac08a1_tk.yae010,--������Դ
                             pkg_Comm.YAE517_H17, --�˶�����
                             prm_yab222, --�������κ�
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
                             CASE WHEN var_yae010 = pkg_Comm.YAE010_CZ THEN 0
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
                             prm_aae036,   --����ʱ��
                             prm_yab139, --�α�����������
                             prm_yab003, --�籣�������
                             prm_aaz002,
                             prm_aaz083,
                             prm_AppCode,         --ִ�д���
                             prm_ErrMsg );        --ִ�н��
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            prm_ErrMsg := prm_ErrMsg||'2';
            RETURN;
         END IF;

         var_flag := '1';
      END LOOP;
      
      --Ǩ��ab08check.ac08a1check���ݵ�ab08,ac08a1
      pkg_p_interrupt.prc_p_batchInterruptCheck(
                         prm_aaz002        ,
                         prm_aab001        ,  --��λ���
                         '0'    ,  --������־
                         null        ,  --���շ�ʽ    ��Ҫ������ʱ��Ŵ�
                         '1'         ,  --���˱�־
                         prm_aae011        ,  --������
                         prm_aae036         ,  --����ʱ��
                         prm_yab003        ,  --�籣�������
                         prm_Appcode        ,  --�������
                         prm_Errmsg         );   --��������
      IF var_flag = '0' THEN
         prm_AppCode := gs_FunNo||var_procNo||'10';
         prm_ErrMsg := '����Ч�ĵ�λ�ɷѲ������ݣ����ʵ��aae003:'||prm_aae003||'; aab001:'||prm_aab001;
         RETURN;
      END IF;
      
      --modify by fenggg at 20190709  begin
      --����Ƿ�Ѹ������޷�ֱ���˿���������´���
      --��Ƿ�Ѳ���������Ϣ��ʱ���ߣ�ͬʱɾ��ac08a1��ac08a1check��ab08��ab08check�ж�Ӧ���ݣ���������Ӧ�·�ʵ�ɺ��ٰ���������˷Ѵ���
      --ac08a1check �� ac08a1check_nsmx
      --ac08a1 �� ac08a1_nsmx
      --ab08 �� ab08_nshz
      --ab08check �� ab08check_nshz
      --ͬʱд��ab08_ns����������Ϣֱ�Ӳ�ѯab08_ns,������ɺ���´����ʶ
      prc_p_moveDetail( var_yae518_qftk,    --�˶���ˮ��
                        prm_aaz002,
                        prm_aaz083,
                        prm_aab001,      --��λ���
                        prm_aae001,      --�������
                        var_yae010,      --������Դ
                        prm_yab003,      --�籣�������
                        prm_aae011,      --������
                        prm_yab139,      --�α�����������
                        prm_AppCode,      --ִ�д���
                        prm_ErrMsg );
      IF prm_AppCode <> pkg_comm.gn_def_OK THEN
         prm_AppCode := gs_FunNo||var_procNo||'13';
         prm_ErrMsg := '���󲹲����'||prm_ErrMsg;
         RETURN;
      END IF;
      --modify by fenggg at 20190709 end

      /*����tmp_yae518 Ϊ������׼��*/
      DELETE tmp_yae518 ;
      --������Դ�ǲ��� ���������ݶ���Ҫ����tmp_yae518
      IF var_yae010 = pkg_Comm.YAE010_CZ THEN
         NULL ;
      ELSE
         --������Դ�ǵ�λ ֻ���˿����Ҫ���ɣ�������Ҫ����һ��H26����Ϣ
         --д����ʱ��
         INSERT INTO tmp_yae518
                   (yae518,   -- �˶���ˮ��
                    aae140,   -- ��������
                    aab001,
                    yab538,
                    yae010,
                    aae041,
                    yab139)
             SELECT yae518,
                    aae140,
                    prm_aab001,
                    yab538, --�ɷ���Ա״̬
                    YAE010, --������Դ
                    aae041,
                    prm_yab139
               FROM ab08
              WHERE yae518 = var_yae518_tk
                AND (aae076 IS NULL OR aae076 = '0')
                AND yae517 = pkg_Comm.YAE517_H17      --�˶�����
                AND yae010 = var_yae010;

         var_yad052 := pkg_comm.YAD052_TZ ;  --����
         var_yad060 := pkg_comm.YAD060_P19;  --��λ�˿�
      END IF;

      /*��������*/
      SELECT COUNT(1)
        INTO num_count
        FROM tmp_yae518;
      IF num_count > 0 THEN
         --����ƻ���ˮ��
         var_aae076 := pkg_comm.fun_GetSequence(NULL,'aae076');
         --�����������̡����ɵ�����Ϣ�Ͳ���ӿ�����
         pkg_p_fundCollection.prc_crtFinaPlan  (
                                  var_yad060    ,      --�ո�����
                                  var_yad052    ,      --�ո����㷽ʽ
                                  prm_aae011    ,      --������Ա
                                  prm_yab003    ,      --�籣�������
                                  var_aae076    ,      --�ƻ���ˮ��
                                  prm_AppCode   ,      --ִ�д���
                                  prm_ErrMsg    );     --ִ�н��
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            RETURN;
         END IF;
      END IF;

      <<label_ERROR>>
      IF cur_aac001%ISOPEN THEN
         CLOSE cur_aac001;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'00';
         prm_ErrMsg  := '�����ɷѲ����������ԭ��'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END pkg_p_salaryExamineAdjust_ns;
   
   
    /*****************************************************************************
   ** �������� prc_p_insertAc08a1_nsmx
   ** ���̱�� : 03
   ** ҵ�񻷽� ������ר�ò��� ����Ǩ�� Ac08a1 �� Ac08a1_nsmx
   ** �������� ��
   ******************************************************************************
   ** ��    �ߣ�            �������� ��2019-07-09   �汾��� ��Ver 1.0.0
   ** ��    ��: Courier New  ��    �� ��10
   ** ��    �ģ�
   ******************************************************************************
   ** ��    ע��
   **
   *****************************************************************************/
   PROCEDURE prc_p_moveDetail(prm_yae518      IN       ac08a1.yae518%type,    --�˶���ˮ��
                              prm_aaz002      IN       ae23.aaz002%TYPE,    
                              prm_aaz083      IN       ae23.aaz083%TYPE,    
                              prm_aab001      IN       ab08.aab001%TYPE,      --��λ���
                              prm_aae001      IN       ab05.aae001%TYPE,      --�������
                              prm_yae010      IN       ab08.yae010%TYPE,      --������Դ  
                              prm_aae011      IN       ab08.aae011%TYPE,      --������       
                              prm_yab003      IN       ab08.yab003%TYPE,      --�籣�������
                              prm_yab139      IN       ab08.yab139%TYPE,      --�α�����������
                              prm_AppCode     OUT      VARCHAR2,               --ִ�д���
                              prm_ErrMsg      OUT      VARCHAR2)
    IS
       var_procNo      VARCHAR2(5);         --���̺�   
       
       var_yae099      ae16.yae099%type;
       var_yae399      ae16.yae399%type;
       num_ac08a1      number;
       num_ab08        number;
       num_ac08a1check number;
       num_ab08check   number;
       
       var_yae518_sye  VARCHAR2(30);
       var_yae518_gs   VARCHAR2(30);
                  
    BEGIN
       prm_AppCode := pkg_COMM.gn_def_OK ;
       prm_ErrMsg  := '' ;
       var_procNo  := 'A06';
       var_yae399  := '42';
       
       --ҵ����ˮ�Ź������ű�
       var_yae099 := pkg_comm.fun_GetSequence(NULL,'yae099');
       
       select count(1)
         into num_ac08a1
         from ac08a1 a
        where yae518 = prm_yae518
          and aab001 = prm_aab001;
         
       --Ǩ��ac08a1 
       if num_ac08a1 > 0 then
       
          insert into ac08a1_nsmx
           select a.*,var_yae099
             from ac08a1 a
            where yae518 = prm_yae518
              and aab001 = prm_aab001;
              
          delete from ac08a1
           where yae518 = prm_yae518
             and aab001 = prm_aab001;
          if  sql%rowcount <> num_ac08a1 then
              prm_AppCode := pkg_COMM.GN_DEF_ERR;
              prm_ErrMsg := '�������ɲ�����Ϣ��Ǩ������ac08a1����:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
              return;
          end if;
            
       end if;
       
       
       --Ǩ��ab08
       select count(1)
         into num_ab08
         from ab08 a
        where yae518 = prm_yae518
          and aab001 = prm_aab001;
          
       if num_ab08 > 0 then
         
         insert into ab08_nshz
           select a.*,var_yae099
             from ab08 a
            where yae518 = prm_yae518
              and aab001 = prm_aab001;
              
          delete from ab08
           where yae518 = prm_yae518
             and aab001 = prm_aab001;
          if  sql%rowcount <> num_ab08 then
              prm_AppCode := pkg_COMM.GN_DEF_ERR;
              prm_ErrMsg := '�������ɲ�����Ϣ��Ǩ������ab08����:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
              return;
          end if;
       end if;
       
       --Ǩ��ac08a1check
       select count(1)
         into num_ac08a1check
         from ac08a1check a
        where yae518 = prm_yae518
          and aab001 = prm_aab001;

       if num_ac08a1check > 0 then
          insert into ac08a1check_nsmx
           select a.*,var_yae099
             from ac08a1check a
            where yae518 = prm_yae518
              and aab001 = prm_aab001;
         
         delete from ac08a1check
          where yae518 = prm_yae518
            and aab001 = prm_aab001;
            
          if  sql%rowcount <> num_ac08a1check then
              prm_AppCode := pkg_COMM.GN_DEF_ERR;
              prm_ErrMsg := '�������ɲ�����Ϣ��Ǩ������ac08a1check����:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
              return;
          end if;
       end if;
       
       --Ǩ��ab08check
       select count(1)
         into num_ab08check
         from ab08check a
        where yae518 = prm_yae518
          and aab001 = prm_aab001;
       
       if num_ab08check > 0 then
          insert into ab08check_nshz
           select a.*,var_yae099
             from ab08check a
            where yae518 = prm_yae518
              and aab001 = prm_aab001;
          
          delete from ab08check
           where yae518 = prm_yae518
             and aab001 = prm_aab001;
          if  sql%rowcount <> num_ab08check then
              prm_AppCode := pkg_COMM.GN_DEF_ERR;
              prm_ErrMsg := '�������ɲ�����Ϣ��Ǩ������ab08check����:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
              return;
          end if;   
          
       end if;
       
       --��ʧҵ�����˵�yae518��ҽ�ơ������ֿ��������������
       var_yae518_sye := null;
       var_yae518_sye := pkg_comm.fun_GetSequence(NULL,'yae518');
       
       UPDATE ac08a1_nsmx
          SET yae518 = var_yae518_sye
        WHERE yae518 = prm_yae518
          and yae099 = var_yae099
          and aab001 = prm_aab001
          and aae140 = pkg_comm.AAE140_SYE;
       UPDATE ac08a1check_nsmx
          SET yae518 = var_yae518_sye
        WHERE yae518 = prm_yae518
          and yae099 = var_yae099
          and aab001 = prm_aab001
          and aae140 = pkg_comm.AAE140_SYE;
       UPDATE ab08_nshz
          SET yae518 = var_yae518_sye
        WHERE yae518 = prm_yae518
          and yae099 = var_yae099
          and aab001 = prm_aab001
          and aae140 = pkg_comm.AAE140_SYE;
       UPDATE ab08check_nshz
          SET yae518 = var_yae518_sye
        WHERE yae518 = prm_yae518
          and yae099 = var_yae099
          and aab001 = prm_aab001
          and aae140 = pkg_comm.AAE140_SYE;
       
       
       var_yae518_gs := null;
       var_yae518_gs := pkg_comm.fun_GetSequence(NULL,'yae518');
       
       UPDATE ac08a1_nsmx
          SET yae518 = var_yae518_gs
        WHERE yae518 = prm_yae518
          and yae099 = var_yae099
          and aab001 = prm_aab001
          and aae140 = pkg_comm.AAE140_GS;
       UPDATE ac08a1check_nsmx
          SET yae518 = var_yae518_gs
        WHERE yae518 = prm_yae518
          and yae099 = var_yae099
          and aab001 = prm_aab001
          and aae140 = pkg_comm.AAE140_GS;
       UPDATE ab08_nshz
          SET yae518 = var_yae518_gs
        WHERE yae518 = prm_yae518
          and yae099 = var_yae099
          and aab001 = prm_aab001
          and aae140 = pkg_comm.AAE140_GS;
       UPDATE ab08check_nshz
          SET yae518 = var_yae518_gs
        WHERE yae518 = prm_yae518
          and yae099 = var_yae099
          and aab001 = prm_aab001
          and aae140 = pkg_comm.AAE140_GS;
          
          
       --д���������Ϣ��,��������Ϣֻдʧҵ��ҽ�ơ����ˣ�ҽ������һ����
       insert into ab08_ns
         (yae099, -- ҵ����ˮ��
          yae518, -- �˶���ˮ��
          aaz002,
          aaz083,
          yae399, -- ҵ������ 20
          aab001, -- ��λ���
          aae140, --����
          aae001, -- ���
          yae010, -- ������Դ
          pernum, -- ����������
          aae120, -- ��Ч��
          yae031, -- �����ʶ(0δ���� 1�Ѵ���)
          yab139, -- ���������
          aae011, -- ������
          aae036, -- ����ʱ��
          aae012, -- ������
          aae037 -- ����ʱ��
          )
         select yae099,        -- ҵ����ˮ��
                yae518,        -- �˶���ˮ��
                prm_aaz002,
                prm_aaz083,
                var_yae399,    -- ҵ������ 20
                aab001,        -- ��λ���
                aae140,        --����
                prm_aae001,    -- ���
                yae010,        -- ������Դ
                yae231,        -- ����������
                '0',           -- ��Ч��
                '0',           -- �����ʶ(0δ���� 1�Ѵ���)
                yab139,        -- ���������
                aae011,        -- ������
                sysdate,       -- ����ʱ��
                '',            -- ������
                null           -- ����ʱ��
           from ab08_nshz
          where yae518 in (prm_yae518,var_yae518_sye,var_yae518_gs)
            and aab001 = prm_aab001
            and aae140 in (PKG_COMM.AAE140_SYE,
                           PKG_COMM.AAE140_JBYL,
                           PKG_COMM.AAE140_GS);
                           
    EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'00';
         prm_ErrMsg  := '���󲹲�Ǩ�����ݳ�������ԭ��'||prm_ErrMsg||','||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END prc_p_moveDetail;
   
   /********************************************************************************/
   /*  ������� pkg_p_bcDataRefund                                                 */
   /*  ҵ�񻷽� ������Ƿ�Ѹ������˷�������                                         */
   /*                                                                              */
   /*  ����˵�� ��                                                                 */
   /*                                                                              */
   /*  �� �� �� ��fenggg                                                           */
   /*  ������� ��2019-07                                                          */
   /*  �汾��� ��Ver 1.0                                                          */
   /*  �� �� �� ��������                      ������� ��YYYY-MM-DD                   */
   /********************************************************************************/
   --����Ƿ�Ѹ������˷�
    PROCEDURE pkg_p_bcDataRefund( prm_yae099      IN   ae16.yae099%TYPE, --ҵ����ˮ��
                                  prm_yae518      IN   ab08.yae518%TYPE, --�˶���ˮ��
                                  prm_aab001      IN   ab02.aab001%TYPE, --��λ���
                                  prm_aae001      IN   ab05.aae001%TYPE, --�������
                                  prm_aae140      IN   ab08.aae140%TYPE, --����
                                  prm_yae010      IN   ab08.yae010%TYPE, --������Դ
                                  prm_yab139      IN   ab08.yab139%TYPE, --�����α�������
                                  prm_aae011      IN   ab08.aae011%TYPE, --������
                                  prm_AppCode     OUT  VARCHAR2,         --ִ�д���
                                  prm_ErrMsg      OUT  VARCHAR2)         --ִ�н��
    IS
      var_procNo      VARCHAR2(5);         --���̺�  
      
      num_ac08a1      NUMBER;
      num_ab08        NUMBER;
      num_ac08a1check NUMBER;
      num_ab08check   NUMBER;
      num_count       NUMBER;
      NUM_YAE518      NUMBER;
      
      var_yae010      ab08.yae010%TYPE;    --������Դ
      var_yad052      ab15a1.yad052%TYPE;
      var_yad060      ab15a1.yad060%TYPE;
      var_aae076      ab08.aae076%TYPE  ;  --������ˮ��
      
      num_aae002_min  number;
      num_aae002_max  number;
      NUM_COUNT_AC08A1 number;
      
    BEGIN
      prm_AppCode  := pkg_COMM.gn_def_OK ;
      prm_ErrMsg   := '' ;
      var_procNo   := 'A07'; 
      
      var_yae010 := prm_yae010;
      IF prm_yae099 IS NULL THEN
         prm_AppCode := gs_FunNo||var_procNo||'01';
         prm_ErrMsg  := 'Ƿ���˿��������ԭ��ҵ����ˮ�Ų���Ϊ��!';
         RETURN;
      END IF;
      
      IF prm_yae518 IS NULL THEN
         prm_AppCode := gs_FunNo||var_procNo||'02';
         prm_ErrMsg  := 'Ƿ���˿��������ԭ�򣺺˶���ˮ�Ų���Ϊ��!';
         RETURN;
      END IF;
      
      IF prm_aab001 IS NULL THEN
         prm_AppCode := gs_FunNo||var_procNo||'03';
         prm_ErrMsg  := 'Ƿ���˿��������ԭ�򣺵�λ��Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_aae001 IS NULL THEN
         prm_AppCode := gs_FunNo||var_procNo||'04';
         prm_ErrMsg  := 'Ƿ���˿��������ԭ��������Ȳ���Ϊ��!';
         RETURN;
      END IF;
      
      IF prm_aae001 < 2019 THEN
         prm_AppCode := gs_FunNo||var_procNo||'04';
         prm_ErrMsg  := 'Ƿ���˿��������ԭ��������Ȳ���С��2019!';
         RETURN;
      END IF;
      
      IF prm_aae140 IS NULL THEN
         prm_AppCode := gs_FunNo||var_procNo||'01';
         prm_ErrMsg  := 'Ƿ���˿��������ԭ�����ֲ���Ϊ��!';
         RETURN;
      END IF;
      
      IF var_yae010 IS NULL THEN
         prm_AppCode := gs_FunNo||var_procNo||'05';
         prm_ErrMsg  := 'Ƿ���˿��������ԭ�򣺷�����Դ����Ϊ��!';
         RETURN;
      END IF;
      
      --У���Ƿ���Դ���,Ƿ������֮��ſ��Դ����˷�,ʧҵ�����˸��Ե�������ҽ�ơ����һ����
      IF prm_aae140 = pkg_comm.AAE140_JBYL THEN
         SELECT MIN(AAE002), MAX(AAE002)
           INTO num_aae002_min, num_aae002_max
           FROM ac08a1_nsmx
          WHERE yae518 = prm_yae518
            AND yae099 = prm_yae099
            AND aab001 = prm_aab001
            AND AAE140 IN (PKG_COMM.AAE140_JBYL,PKG_COMM.AAE140_SYU);
            
         SELECT COUNT(1)
           INTO NUM_COUNT_AC08A1
           FROM AC08A1
          WHERE AAB001 = prm_aab001
            AND AAE002 >= num_aae002_min
            AND AAE002 <= num_aae002_max
            AND AAE140 IN (PKG_COMM.AAE140_JBYL,PKG_COMM.AAE140_SYU)
            AND AAE143 IN (pkg_comm.AAE143_ZCJF,
                           pkg_comm.AAE143_BJ,
                           pkg_comm.AAE143_DLJF,
                           pkg_comm.AAE143_BS);
      ELSE 
          SELECT MIN(AAE002), MAX(AAE002)
            INTO num_aae002_min, num_aae002_max
            FROM ac08a1_nsmx
           WHERE yae518 = prm_yae518
             AND yae099 = prm_yae099
             AND aab001 = prm_aab001
             AND AAE140 = prm_aae140;
             
          SELECT COUNT(1)
           INTO NUM_COUNT_AC08A1
           FROM AC08A1
          WHERE AAB001 = prm_aab001
            AND AAE002 >= num_aae002_min
            AND AAE002 <= num_aae002_max
             AND AAE140 = prm_aae140
            AND AAE143 IN (pkg_comm.AAE143_ZCJF,
                           pkg_comm.AAE143_BJ,
                           pkg_comm.AAE143_DLJF,
                           pkg_comm.AAE143_BS);
           
      END IF;
   
      IF NUM_COUNT_AC08A1 > 0 THEN
         prm_AppCode := gs_FunNo||var_procNo||'06';
         prm_ErrMsg  := 'Ƿ���˿��������ԭ��:��λ���'||prm_aab001||' ��ʼ�ںţ�'||num_aae002_min||'����ֹ�ںţ�'||num_aae002_max||'������Ƿ����Ϣ����ʵ�պ����˷�!';
         RETURN;
      END IF;
      
     SELECT (SELECT COUNT(1)
               FROM AB08
              WHERE YAE518 = prm_yae518) 
             +
             (SELECT COUNT(1) 
               FROM AB08A8 
              WHERE YAE518 = prm_yae518)
       INTO NUM_YAE518
       FROM DUAL;
       
      IF NUM_YAE518 > 0 THEN
         prm_AppCode := gs_FunNo||var_procNo||'07';
         prm_ErrMsg  := 'Ƿ���˿��������ԭ��:��λ���'||prm_aab001||'���˶���ˮ�ţ�'||prm_yae518||'���˷��Ѵ�����ɣ������ظ��ύ����!';
         RETURN;
      END IF;
        
      --Ǩ�ƴ��������� begin
      --Ǩ��ac08a1
      insert into ac08a1(
        yae202,	  --��ϸ��ˮ��
        aac001,   --���˱��
        aab001,   --��λ���
        aae140,   --��������
        aae003,   --�����ں�
        aae002,   --�ѿ�������
        aae143,   --�ɷ�����
        yae010,   --������Դ
        yac505,   --�α��ɷ���Ա���
        aac008,   --��Ա״̬
        akc021,   --ҽ����Ա���
        aaa040,   --�������
        yaa310,   --��������
        yae203,   --������Դ����
        aaa041,   --���˽ɷѱ���
        yaa017,   --���˽ɷѻ���ͳ�����
        aaa042,   --��λ�ɷѱ���
        aaa043,   --��λ�ɷѻ����ʻ�����
        ala080,   --���˸�������ֵ
        akc023,   --ʵ������
        yac176,   --����
        yac503,   --�������
        aac040,   --�ɷѹ���
        yaa333,   --�˻�����
        aae180,   --�ɷѻ���
        yab157,   --���˽ɷѻ����ʻ����
        yab158,   --���˽ɷѻ���ͳ����
        aab157,   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
        aab158,   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
        yab555,   --Ӧ���ɸ��˽ɷ�ͳ�ﲿ�ֱ�����Ϣ
        yab556,   --Ӧ���ɸ��˽ɷ�ͳ�ﲿ�ֿ�����Ϣ
        aab212,   --��λ�ɷѻ����ʻ����
        aab213,   --��λ�ɷѻ���ͳ����
        aab159,   --Ӧ���ɵ�λ�ɷѻ����ʻ�������Ϣ
        aab160,   --Ӧ���ɵ�λ�ɷѻ����ʻ�������Ϣ
        yab557,   --Ӧ���ɵ�λ�ɷ�ͳ�ﲿ�ֱ�����Ϣ
        yab558,   --Ӧ���ɵ�λ�ɷ�ͳ�ﲿ�ֿ�����Ϣ
        aab162,   --Ӧ�����ɽ���
        aae061,   --���ɺ˶���ˮ��
        yae518,   --�˶���ˮ��
        aae076,   --�ƻ���ˮ��
        aab019,   --��λ����
        aab020,   --���óɷ�
        yac168,   --ũ�񹤱�־
        aae011,   --������
        aae036,   --����ʱ��
        yab003,   --�籣�������
        yab139,   --�α�����������
        yac234,   --�ɷ�����
        ykc120,   --ҽ���չ���Ա���
        ykc279,   --��д������Ϣ��־
        ykb109,   --�Ƿ����ܹ���Աͳ�����
        yab275,   --ҽ�Ʊ���ִ�а취
        ykb110,   --Ԥ��ҽ���ʻ�
        yje003,   --ʧҵ�Ǽ�֤��
        yaa330,   --�ɷѱ���ģʽ
        yac200    --����Աְ��
      
      )select 
            yae202,	  --��ϸ��ˮ��
            aac001,   --���˱��
            aab001,   --��λ���
            aae140,   --��������
            aae003,   --�����ں�
            aae002,   --�ѿ�������
            aae143,   --�ɷ�����
            yae010,   --������Դ
            yac505,   --�α��ɷ���Ա���
            aac008,   --��Ա״̬
            akc021,   --ҽ����Ա���
            aaa040,   --�������
            yaa310,   --��������
            yae203,   --������Դ����
            aaa041,   --���˽ɷѱ���
            yaa017,   --���˽ɷѻ���ͳ�����
            aaa042,   --��λ�ɷѱ���
            aaa043,   --��λ�ɷѻ����ʻ�����
            ala080,   --���˸�������ֵ
            akc023,   --ʵ������
            yac176,   --����
            yac503,   --�������
            aac040,   --�ɷѹ���
            yaa333,   --�˻�����
            aae180,   --�ɷѻ���
            yab157,   --���˽ɷѻ����ʻ����
            yab158,   --���˽ɷѻ���ͳ����
            aab157,   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
            aab158,   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
            yab555,   --Ӧ���ɸ��˽ɷ�ͳ�ﲿ�ֱ�����Ϣ
            yab556,   --Ӧ���ɸ��˽ɷ�ͳ�ﲿ�ֿ�����Ϣ
            aab212,   --��λ�ɷѻ����ʻ����
            aab213,   --��λ�ɷѻ���ͳ����
            aab159,   --Ӧ���ɵ�λ�ɷѻ����ʻ�������Ϣ
            aab160,   --Ӧ���ɵ�λ�ɷѻ����ʻ�������Ϣ
            yab557,   --Ӧ���ɵ�λ�ɷ�ͳ�ﲿ�ֱ�����Ϣ
            yab558,   --Ӧ���ɵ�λ�ɷ�ͳ�ﲿ�ֿ�����Ϣ
            aab162,   --Ӧ�����ɽ���
            aae061,   --���ɺ˶���ˮ��
            yae518,   --�˶���ˮ��
            aae076,   --�ƻ���ˮ��
            aab019,   --��λ����
            aab020,   --���óɷ�
            yac168,   --ũ�񹤱�־
            aae011,   --������
            aae036,   --����ʱ��
            yab003,   --�籣�������
            yab139,   --�α�����������
            yac234,   --�ɷ�����
            ykc120,   --ҽ���չ���Ա���
            ykc279,   --��д������Ϣ��־
            ykb109,   --�Ƿ����ܹ���Աͳ�����
            yab275,   --ҽ�Ʊ���ִ�а취
            ykb110,   --Ԥ��ҽ���ʻ�
            yje003,   --ʧҵ�Ǽ�֤��
            yaa330,   --�ɷѱ���ģʽ
            yac200    --����Աְ��
      from ac08a1_nsmx
     where yae518 = prm_yae518
       and yae099 = prm_yae099
       and aab001 = prm_aab001;
       
      --Ǩ��ac08a1check
      insert into ac08a1check(
          YAE202,  -- ��ϸ��ˮ��
          AAC001,  -- ���˱��
          AAB001,  -- ��λ���
          AAE140,  -- ��������
          AAE003,  -- �����ں�
          AAE002,  -- �ѿ�������
          AAE143,  -- �ɷ�����
          YAE010,  -- ������Դ
          YAC505,  -- �α��ɷ���Ա���
          AAC008,  -- ��Ա״̬
          AKC021,  -- ҽ����Ա���
          AAA040,  -- �������
          YAA310,  -- ��������
          YAE203,  -- ������Դ����
          AAA041,  -- ���˽ɷѱ���
          YAA017,  -- ���˽ɷѻ���ͳ�����
          AAA042,  -- ��λ�ɷѱ���
          AAA043,  -- ��λ�ɷѻ����ʻ�����
          ALA080,  -- ���˸�������ֵ
          AKC023,  -- ʵ������
          YAC176,  -- ����
          YAC503,  -- �������
          AAC040,  -- �ɷѹ���
          YAA333,  -- �˻�����
          AAE180,  -- �ɷѻ���
          YAB157,  -- ���˽ɷѻ����ʻ����
          YAB158,  -- ���˽ɷѻ���ͳ����
          AAB157,  -- Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
          AAB158,  -- Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
          YAB555,  -- Ӧ���ɸ��˽ɷ�ͳ�ﲿ�ֱ�����Ϣ
          YAB556,  -- Ӧ���ɸ��˽ɷ�ͳ�ﲿ�ֿ�����Ϣ
          AAB212,  -- ��λ�ɷѻ����ʻ����
          AAB213,  -- ��λ�ɷѻ���ͳ����
          AAB159,  -- Ӧ���ɵ�λ�ɷѻ����ʻ�������Ϣ
          AAB160,  -- Ӧ���ɵ�λ�ɷѻ����ʻ�������Ϣ
          YAB557,  -- Ӧ���ɵ�λ�ɷ�ͳ�ﲿ�ֱ�����Ϣ
          YAB558,  -- Ӧ���ɵ�λ�ɷ�ͳ�ﲿ�ֿ�����Ϣ
          AAB162,  -- Ӧ�����ɽ���
          AAE061,  -- ���ɺ˶���ˮ��
          YAE518,  -- �˶���ˮ��
          AAE076,  -- �ƻ���ˮ��
          AAB019,  -- ��λ����
          AAB020,  -- ���óɷ�
          YAC168,  -- ũ�񹤱�־
          AAE011,  -- ������
          AAE036,  -- ����ʱ��
          YAB003,  -- �籣�������
          YAB139,  -- �α�����������
          YAC234,  -- �ɷ�����
          YKC120,  -- ҽ���չ���Ա���
          YKC279,  -- ��д������Ϣ��־
          YKB109,  -- �Ƿ����ܹ���Աͳ�����
          YAB275,  -- ҽ�Ʊ���ִ�а취
          YKB110,  -- Ԥ��ҽ���ʻ�
          YJE003,  -- ʧҵ�Ǽ�֤��
          YAA330,  -- �ɷѱ���ģʽ
          YAC200,  -- ����Աְ��
          AAZ083,  -- �¼����
          AAZ002   -- ҵ����־��
      
      )select 
            YAE202,  -- ��ϸ��ˮ��
            AAC001,  -- ���˱��
            AAB001,  -- ��λ���
            AAE140,  -- ��������
            AAE003,  -- �����ں�
            AAE002,  -- �ѿ�������
            AAE143,  -- �ɷ�����
            YAE010,  -- ������Դ
            YAC505,  -- �α��ɷ���Ա���
            AAC008,  -- ��Ա״̬
            AKC021,  -- ҽ����Ա���
            AAA040,  -- �������
            YAA310,  -- ��������
            YAE203,  -- ������Դ����
            AAA041,  -- ���˽ɷѱ���
            YAA017,  -- ���˽ɷѻ���ͳ�����
            AAA042,  -- ��λ�ɷѱ���
            AAA043,  -- ��λ�ɷѻ����ʻ�����
            ALA080,  -- ���˸�������ֵ
            AKC023,  -- ʵ������
            YAC176,  -- ����
            YAC503,  -- �������
            AAC040,  -- �ɷѹ���
            YAA333,  -- �˻�����
            AAE180,  -- �ɷѻ���
            YAB157,  -- ���˽ɷѻ����ʻ����
            YAB158,  -- ���˽ɷѻ���ͳ����
            AAB157,  -- Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
            AAB158,  -- Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
            YAB555,  -- Ӧ���ɸ��˽ɷ�ͳ�ﲿ�ֱ�����Ϣ
            YAB556,  -- Ӧ���ɸ��˽ɷ�ͳ�ﲿ�ֿ�����Ϣ
            AAB212,  -- ��λ�ɷѻ����ʻ����
            AAB213,  -- ��λ�ɷѻ���ͳ����
            AAB159,  -- Ӧ���ɵ�λ�ɷѻ����ʻ�������Ϣ
            AAB160,  -- Ӧ���ɵ�λ�ɷѻ����ʻ�������Ϣ
            YAB557,  -- Ӧ���ɵ�λ�ɷ�ͳ�ﲿ�ֱ�����Ϣ
            YAB558,  -- Ӧ���ɵ�λ�ɷ�ͳ�ﲿ�ֿ�����Ϣ
            AAB162,  -- Ӧ�����ɽ���
            AAE061,  -- ���ɺ˶���ˮ��
            YAE518,  -- �˶���ˮ��
            AAE076,  -- �ƻ���ˮ��
            AAB019,  -- ��λ����
            AAB020,  -- ���óɷ�
            YAC168,  -- ũ�񹤱�־
            AAE011,  -- ������
            AAE036,  -- ����ʱ��
            YAB003,  -- �籣�������
            YAB139,  -- �α�����������
            YAC234,  -- �ɷ�����
            YKC120,  -- ҽ���չ���Ա���
            YKC279,  -- ��д������Ϣ��־
            YKB109,  -- �Ƿ����ܹ���Աͳ�����
            YAB275,  -- ҽ�Ʊ���ִ�а취
            YKB110,  -- Ԥ��ҽ���ʻ�
            YJE003,  -- ʧҵ�Ǽ�֤��
            YAA330,  -- �ɷѱ���ģʽ
            YAC200,  -- ����Աְ��
            AAZ083,  -- �¼����
            AAZ002   -- ҵ����־��
      from ac08a1check_nsmx
     where yae518 = prm_yae518
       and yae099 = prm_yae099
       and aab001 = prm_aab001;
       
     --Ǩ��ab08
     insert into ab08(
          yae518,  -- �˶���ˮ��
          aab001,  -- ��λ���
          aac001,  -- ���˱��
          aae140,  -- ��������
          aae003,  -- �����ں�
          aae041,  -- ��ʼ�ں�
          aae042,  -- ��ֹ�ں�
          yab538,  -- �ɷ���Ա״̬
          yae010,  -- ������Դ
          aab165,  -- ��λ�ɷѱ�־
          aab166,  -- ����֪ͨ��־
          yae517,  -- �˶�����
          yab222,  -- �������κ�
          yae231,  -- ����
          yae203,  -- ������Դ����
          aab120,  -- ���˽ɷѻ����ܶ�
          aab121,  -- ��λ�ɷѻ����ܶ�
          aab150,  -- Ӧ�ɸ��˽ɷѻ����˻����
          yab031,  -- Ӧ�ɸ��˽ɷѻ���ͳ����
          aab151,  -- Ӧ�ɵ�λ�ɷѻ����˻����
          aab152,  -- Ӧ�ɵ�λ�ɷѻ���ͳ����
          yab216,  -- Ӧ�ɹ鼯���ֽ��
          aab153,  -- �ѽɸ��˽ɷѻ����˻����
          yab040,  -- �ѽɸ��˽ɷѻ���ͳ����
          aab154,  -- �ѽɵ�λ�ɷѻ����˻����
          aab155,  -- �ѽɵ�λ�ɷѻ���ͳ����
          yab217,  -- �ѽɹ鼯���ֽ��
          aab157,  -- Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
          aab158,  -- Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
          aab159,  -- Ӧ�����˻�������Ϣ��λ������
          aab160,  -- Ӧ�����˻�������Ϣ��λ������
          aab161,  -- Ӧ����ͳ�������Ϣ���
          aab162,  -- Ӧ�����ɽ���
          yab042,  -- �ѽɸ��˽ɷѻ����˻���Ϣ
          yab046,  -- �ѽɵ�λ�ɷѻ����˻���Ϣ
          yab059,  -- �ѽ�ͳ����Ϣ���yab059
          yab215,  -- �ѽ����ɽ��ܶ�
          yab381,  -- �������ɽ���yab381
          yab146,  -- Ӧ���ʸ��˽ɷѻ��ʻ����
          yab147,  -- Ӧ���ʸ��˽ɷѻ�ͳ����
          yab148,  -- Ӧ���ʵ�λ�ɷѻ��ʻ����
          yab149,  -- Ӧ���ʵ�λ�ɷѻ�ͳ����
          yab218,  -- Ӧ���ʹ鼯���ֽ��
          aab214,  -- ��ת������
          aab156,  -- Ƿ�ɽ��
          yab400,  -- ���ɽ�����־
          yab401,  -- ��Ϣ�����־
          aab163,  -- ��Ϣ�����ֹ����
          aab164,  -- ���ɽ�����ֹ����
          yab541,  -- ���˽��ɲ����Ƿ����
          yab542,  -- ��λ���ɻ����˻������Ƿ����
          yab543,  -- ��λ���ɻ���ͳ�ﲿ���Ƿ����
          yab544,  -- ��Ϣ�Ƿ����
          yab546,  -- ���ɽ��Ƿ����
          aab019,  -- ��λ����
          aab020,  -- ���óɷ�
          aab021,  -- ������ϵ
          aab022,  -- ��λ��ҵ
          yae526,  -- ԭ�˶���ˮ��
          aae068,  -- ����������ˮ��
          aae076,  -- �ƻ���ˮ��
          aab191,  -- ����/��������
          yad180,  -- �����������
          yaa011,  -- ҵ�����־
          yaa012,  -- �������־
          yab139,  -- �α�����������
          aae011,  -- ������
          aae036,  -- ����ʱ��
          yab003,  -- �籣�������
          aae013,  -- ��ע
          aaz083   -- ���������ɼƻ��¼�id
     
     )select 
          yae518,  -- �˶���ˮ��
          aab001,  -- ��λ���
          aac001,  -- ���˱��
          aae140,  -- ��������
          aae003,  -- �����ں�
          aae041,  -- ��ʼ�ں�
          aae042,  -- ��ֹ�ں�
          yab538,  -- �ɷ���Ա״̬
          yae010,  -- ������Դ
          aab165,  -- ��λ�ɷѱ�־
          aab166,  -- ����֪ͨ��־
          yae517,  -- �˶�����
          yab222,  -- �������κ�
          yae231,  -- ����
          yae203,  -- ������Դ����
          aab120,  -- ���˽ɷѻ����ܶ�
          aab121,  -- ��λ�ɷѻ����ܶ�
          aab150,  -- Ӧ�ɸ��˽ɷѻ����˻����
          yab031,  -- Ӧ�ɸ��˽ɷѻ���ͳ����
          aab151,  -- Ӧ�ɵ�λ�ɷѻ����˻����
          aab152,  -- Ӧ�ɵ�λ�ɷѻ���ͳ����
          yab216,  -- Ӧ�ɹ鼯���ֽ��
          aab153,  -- �ѽɸ��˽ɷѻ����˻����
          yab040,  -- �ѽɸ��˽ɷѻ���ͳ����
          aab154,  -- �ѽɵ�λ�ɷѻ����˻����
          aab155,  -- �ѽɵ�λ�ɷѻ���ͳ����
          yab217,  -- �ѽɹ鼯���ֽ��
          aab157,  -- Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
          aab158,  -- Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
          aab159,  -- Ӧ�����˻�������Ϣ��λ������
          aab160,  -- Ӧ�����˻�������Ϣ��λ������
          aab161,  -- Ӧ����ͳ�������Ϣ���
          aab162,  -- Ӧ�����ɽ���
          yab042,  -- �ѽɸ��˽ɷѻ����˻���Ϣ
          yab046,  -- �ѽɵ�λ�ɷѻ����˻���Ϣ
          yab059,  -- �ѽ�ͳ����Ϣ���yab059
          yab215,  -- �ѽ����ɽ��ܶ�
          yab381,  -- �������ɽ���yab381
          yab146,  -- Ӧ���ʸ��˽ɷѻ��ʻ����
          yab147,  -- Ӧ���ʸ��˽ɷѻ�ͳ����
          yab148,  -- Ӧ���ʵ�λ�ɷѻ��ʻ����
          yab149,  -- Ӧ���ʵ�λ�ɷѻ�ͳ����
          yab218,  -- Ӧ���ʹ鼯���ֽ��
          aab214,  -- ��ת������
          aab156,  -- Ƿ�ɽ��
          yab400,  -- ���ɽ�����־
          yab401,  -- ��Ϣ�����־
          aab163,  -- ��Ϣ�����ֹ����
          aab164,  -- ���ɽ�����ֹ����
          yab541,  -- ���˽��ɲ����Ƿ����
          yab542,  -- ��λ���ɻ����˻������Ƿ����
          yab543,  -- ��λ���ɻ���ͳ�ﲿ���Ƿ����
          yab544,  -- ��Ϣ�Ƿ����
          yab546,  -- ���ɽ��Ƿ����
          aab019,  -- ��λ����
          aab020,  -- ���óɷ�
          aab021,  -- ������ϵ
          aab022,  -- ��λ��ҵ
          yae526,  -- ԭ�˶���ˮ��
          aae068,  -- ����������ˮ��
          aae076,  -- �ƻ���ˮ��
          aab191,  -- ����/��������
          yad180,  -- �����������
          yaa011,  -- ҵ�����־
          yaa012,  -- �������־
          yab139,  -- �α�����������
          aae011,  -- ������
          aae036,  -- ����ʱ��
          yab003,  -- �籣�������
          aae013,  -- ��ע
          aaz083   -- ���������ɼƻ��¼�id
     from ab08_nshz
    where yae518 = prm_yae518
      and yae099 = prm_yae099
      and aab001 = prm_aab001;
      
     insert into ab08check(
          yae518,   --�˶���ˮ��
          aab001,   --��λ���
          aac001,   --���˱��
          aae140,   --��������
          aae003,   --�����ں�
          aae041,   --��ʼ�ں�
          aae042,   --��ֹ�ں�
          yab538,   --�ɷ���Ա״̬
          yae010,   --������Դ
          aab165,   --��λ�ɷѱ�־
          aab166,   --����֪ͨ��־
          yae517,   --�˶�����
          yab222,   --�������κ�
          yae231,   --����
          yae203,   --������Դ����
          aab120,   --���˽ɷѻ����ܶ�
          aab121,   --��λ�ɷѻ����ܶ�
          aab150,   --Ӧ�ɸ��˽ɷѻ����˻����
          yab031,   --Ӧ�ɸ��˽ɷѻ���ͳ����
          aab151,   --Ӧ�ɵ�λ�ɷѻ����˻����
          aab152,   --Ӧ�ɵ�λ�ɷѻ���ͳ����
          yab216,   --Ӧ�ɹ鼯���ֽ��
          aab153,   --�ѽɸ��˽ɷѻ����˻����
          yab040,   --�ѽɸ��˽ɷѻ���ͳ����
          aab154,   --�ѽɵ�λ�ɷѻ����˻����
          aab155,   --�ѽɵ�λ�ɷѻ���ͳ����
          yab217,   --�ѽɹ鼯���ֽ��
          aab157,   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
          aab158,   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
          aab159,   --Ӧ�����˻�������Ϣ��λ������
          aab160,   --Ӧ�����˻�������Ϣ��λ������
          aab161,   --Ӧ����ͳ�������Ϣ���
          aab162,   --Ӧ�����ɽ���
          yab042,   --�ѽɸ��˽ɷѻ����˻���Ϣ
          yab046,   --�ѽɵ�λ�ɷѻ����˻���Ϣ
          yab059,   --�ѽ�ͳ����Ϣ���yab059
          yab215,   --�ѽ����ɽ��ܶ�
          yab381,   --�������ɽ���yab381
          yab146,   --Ӧ���ʸ��˽ɷѻ��ʻ����
          yab147,   --Ӧ���ʸ��˽ɷѻ�ͳ����
          yab148,   --Ӧ���ʵ�λ�ɷѻ��ʻ����
          yab149,   --Ӧ���ʵ�λ�ɷѻ�ͳ����
          yab218,   --Ӧ���ʹ鼯���ֽ��
          aab214,   --��ת������
          aab156,   --Ƿ�ɽ��
          yab400,   --���ɽ�����־
          yab401,   --��Ϣ�����־
          aab163,   --��Ϣ�����ֹ����
          aab164,   --���ɽ�����ֹ����
          yab541,   --���˽��ɲ����Ƿ����
          yab542,   --��λ���ɻ����˻������Ƿ����
          yab543,   --��λ���ɻ���ͳ�ﲿ���Ƿ����
          yab544,   --��Ϣ�Ƿ����
          yab546,   --���ɽ��Ƿ����
          aab019,   --��λ����
          aab020,   --���óɷ�
          aab021,   --������ϵ
          aab022,   --��λ��ҵ
          yae526,   --ԭ�˶���ˮ��
          aae068,   --����������ˮ��
          aae076,   --�ƻ���ˮ��
          aab191,   --����/��������
          yad180,   --�����������
          yaa011,   --ҵ�����־
          yaa012,   --�������־
          yab139,   --�α�����������
          aae011,   --������
          aae036,   --����ʱ��
          yab003,   --�籣�������
          aae013,   --��ע
          aaz083,   --���������ɼƻ��¼�id
          aaz002    --ҵ����־id
     
     )select  
          yae518,   --�˶���ˮ��
          aab001,   --��λ���
          aac001,   --���˱��
          aae140,   --��������
          aae003,   --�����ں�
          aae041,   --��ʼ�ں�
          aae042,   --��ֹ�ں�
          yab538,   --�ɷ���Ա״̬
          yae010,   --������Դ
          aab165,   --��λ�ɷѱ�־
          aab166,   --����֪ͨ��־
          yae517,   --�˶�����
          yab222,   --�������κ�
          yae231,   --����
          yae203,   --������Դ����
          aab120,   --���˽ɷѻ����ܶ�
          aab121,   --��λ�ɷѻ����ܶ�
          aab150,   --Ӧ�ɸ��˽ɷѻ����˻����
          yab031,   --Ӧ�ɸ��˽ɷѻ���ͳ����
          aab151,   --Ӧ�ɵ�λ�ɷѻ����˻����
          aab152,   --Ӧ�ɵ�λ�ɷѻ���ͳ����
          yab216,   --Ӧ�ɹ鼯���ֽ��
          aab153,   --�ѽɸ��˽ɷѻ����˻����
          yab040,   --�ѽɸ��˽ɷѻ���ͳ����
          aab154,   --�ѽɵ�λ�ɷѻ����˻����
          aab155,   --�ѽɵ�λ�ɷѻ���ͳ����
          yab217,   --�ѽɹ鼯���ֽ��
          aab157,   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
          aab158,   --Ӧ���ɸ��˽ɷѻ����˻�������Ϣ
          aab159,   --Ӧ�����˻�������Ϣ��λ������
          aab160,   --Ӧ�����˻�������Ϣ��λ������
          aab161,   --Ӧ����ͳ�������Ϣ���
          aab162,   --Ӧ�����ɽ���
          yab042,   --�ѽɸ��˽ɷѻ����˻���Ϣ
          yab046,   --�ѽɵ�λ�ɷѻ����˻���Ϣ
          yab059,   --�ѽ�ͳ����Ϣ���yab059
          yab215,   --�ѽ����ɽ��ܶ�
          yab381,   --�������ɽ���yab381
          yab146,   --Ӧ���ʸ��˽ɷѻ��ʻ����
          yab147,   --Ӧ���ʸ��˽ɷѻ�ͳ����
          yab148,   --Ӧ���ʵ�λ�ɷѻ��ʻ����
          yab149,   --Ӧ���ʵ�λ�ɷѻ�ͳ����
          yab218,   --Ӧ���ʹ鼯���ֽ��
          aab214,   --��ת������
          aab156,   --Ƿ�ɽ��
          yab400,   --���ɽ�����־
          yab401,   --��Ϣ�����־
          aab163,   --��Ϣ�����ֹ����
          aab164,   --���ɽ�����ֹ����
          yab541,   --���˽��ɲ����Ƿ����
          yab542,   --��λ���ɻ����˻������Ƿ����
          yab543,   --��λ���ɻ���ͳ�ﲿ���Ƿ����
          yab544,   --��Ϣ�Ƿ����
          yab546,   --���ɽ��Ƿ����
          aab019,   --��λ����
          aab020,   --���óɷ�
          aab021,   --������ϵ
          aab022,   --��λ��ҵ
          yae526,   --ԭ�˶���ˮ��
          aae068,   --����������ˮ��
          aae076,   --�ƻ���ˮ��
          aab191,   --����/��������
          yad180,   --�����������
          yaa011,   --ҵ�����־
          yaa012,   --�������־
          yab139,   --�α�����������
          aae011,   --������
          aae036,   --����ʱ��
          yab003,   --�籣�������
          aae013,   --��ע
          aaz083,   --���������ɼƻ��¼�id
          aaz002    --ҵ����־id
      from ab08check_nshz
     where yae518 = prm_yae518
       and yae099 = prm_yae099
       and aab001 = prm_aab001;
     --Ǩ�ƴ��������� end 
     
     
     --���� ʵ�� begin
      /*����tmp_yae518 Ϊ������׼��*/
      DELETE tmp_yae518 ;
      --������Դ�ǲ��� ���������ݶ���Ҫ����tmp_yae518
      IF var_yae010 = pkg_Comm.YAE010_CZ THEN
         NULL ;
      ELSE
         --������Դ�ǵ�λ ֻ���˿����Ҫ���ɣ�������Ҫ����һ��H26����Ϣ
         --д����ʱ��
         INSERT INTO tmp_yae518
                   (yae518,   -- �˶���ˮ��
                    aae140,   -- ��������
                    aab001,
                    yab538,
                    yae010,
                    aae041,
                    yab139)
             SELECT yae518,
                    aae140,
                    prm_aab001,
                    yab538, --�ɷ���Ա״̬
                    YAE010, --������Դ
                    aae041,
                    prm_yab139
               FROM ab08
              WHERE yae518 = prm_yae518
                AND (aae076 IS NULL OR aae076 = '0')
                AND yae517 = pkg_Comm.YAE517_H17      --�˶�����
                AND yae010 = var_yae010;

         var_yad052 := pkg_comm.YAD052_TZ ;  --����
         var_yad060 := pkg_comm.YAD060_P19;  --��λ�˿�
      END IF;

      /*��������*/
      SELECT COUNT(1)
        INTO num_count
        FROM tmp_yae518;
      IF num_count > 0 THEN
         --����ƻ���ˮ��
         var_aae076 := pkg_comm.fun_GetSequence(NULL,'aae076');
         --�����������̡����ɵ�����Ϣ�Ͳ���ӿ�����
         pkg_p_fundCollection.prc_crtFinaPlan  (
                                  var_yad060    ,      --�ո�����
                                  var_yad052    ,      --�ո����㷽ʽ
                                  prm_aae011    ,      --������Ա
                                  prm_yab139    ,      --�籣�������
                                  var_aae076    ,      --�ƻ���ˮ��
                                  prm_AppCode   ,      --ִ�д���
                                  prm_ErrMsg    );     --ִ�н��
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            RETURN;
         END IF;
      END IF;
     --���� ʵ�� end
     
     --���´�����Ϊ�Ѵ���
     UPDATE ab08_ns
        SET yae031 = '1', 
            aae012 = prm_aae011, 
            aae037 = sysdate
      WHERE yae099 = prm_yae099
        AND yae518 = prm_yae518
        AND aab001 = prm_aab001
        AND aae001 = prm_aae001
        AND aae140 = prm_aae140;
     
     
    EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'00';
         prm_ErrMsg  := '���󲹲�Ǩ�����ݳ�������ԭ��'||prm_ErrMsg||','||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END pkg_p_bcDataRefund;
   
   
   /********************************************************************************/
   /*  ������� pkg_p_batchBcDataRefund                                            */
   /*  ҵ�񻷽� ����������Ƿ�Ѹ������˷�                                           */
   /*                                                                              */
   /*  ����˵�� ��                                                                 */
   /*                                                                              */
   /*  �� �� �� ��                                                                 */
   /*  ������� ��2019-07                                                          */
   /*  �汾��� ��Ver 1.0                                                          */
   /*  �� �� �� ��������                      ������� ��YYYY-MM-DD                */
   /********************************************************************************/
   --��������Ƿ�Ѹ������˷�
    PROCEDURE pkg_p_batchBcDataRefund( prm_jobid       IN   QRTZ_JOB_MSGS.Jobid%TYPE,--jobid
                                       prm_aab001      IN   ab01.aab001%TYPE, --��λ��ţ����Բ����������ֵ�򵥸�����������������
                                       prm_aae001      IN   ab05.aae001%TYPE, --�������
                                       prm_yab139      IN   ab08.yab139%TYPE, --�����α�������
                                       prm_aae011      IN   ab08.aae011%TYPE  --������
                                      -- prm_AppCode     OUT  VARCHAR2,         --ִ�д���
                                      -- prm_ErrMsg      OUT  VARCHAR2          --ִ�н��
                                      )          
   IS
      var_procNo      VARCHAR2(5);         --���̺�  
      
      var_yae099      ae16.yae099%type;
      var_yae399      ae16.yae399%type;
      var_yae518      ab08.yae518%type;
      var_aab001      ab01.aab001%type;
      var_yae010      ab08.yae010%type;
      var_aae140      ab08.aae140%type;
      
      var_starttime         VARCHAR2(30);     --��ʼʱ��
      var_endtime           VARCHAR2(30);     --��ֹʱ��
      var_issuccess         qrtz_job_msgs.issuccess%TYPE  ; --�ɹ���־
      var_successmsg        qrtz_job_msgs.successmsg%TYPE ; --�ɹ���Ϣ
      var_failmsg           qrtz_job_msgs.errormsg%TYPE   ; --ʧ����Ϣ
      var_result            qrtz_job_msgs.errormsg%TYPE; --��ʱִ�н��
      
      num_ab08_ns     number;
      var_ywlx        varchar2(20);
      var_ywzb        varchar2(20);
      
      prm_AppCode     varchar2(30);
      prm_ErrMsg      varchar2(2000);
      
      cursor cur_ab01_single is
        select *
          from ab08_ns
         where aab001 = prm_aab001
           and aae001 = prm_aae001
           and yab139 = prm_yab139
           and yae031 = '0'
           and aae120 = '0';
           
           
      cursor cur_ab01_all is
        select *
          from ab08_ns
         where aae001 = prm_aae001
           and yab139 = prm_yab139
           and yae031 = '0'
           and aae120 = '0';

   BEGIN
      
      prm_AppCode  := pkg_COMM.gn_def_OK ;
      prm_ErrMsg   := '' ;
      var_procNo   := 'A08'; 
      var_ywlx     := '42'; 
      var_ywzb     := 'PLNSQFTF';
      
      var_starttime := NULL;
      var_endtime := NULL;
      
      IF prm_aae001 < 2019 THEN
         prm_AppCode := pkg_COMM.GN_DEF_ERR;
         prm_ErrMsg := '����Ƿ�Ѹ������˷ѳ���������Ȳ���С��2019;';
         RETURN;
      END IF;
      
      IF prm_yab139 IS NULL THEN
         prm_AppCode := pkg_COMM.GN_DEF_ERR;
         prm_ErrMsg := '����Ƿ�Ѹ������˷ѳ�����������Ĳ���Ϊ��!';
         RETURN;
      END IF;
      
      IF prm_aab001 IS NULL THEN  --��������
         SELECT COUNT(1)
          INTO NUM_AB08_NS
          FROM AB08_NS
         WHERE aae001 = prm_aae001
           AND yab139 = prm_yab139
           AND yae031 = '0'       --δ����
           AND aae120 = '0';      --��Ч
          
      ELSE     --��������
         SELECT COUNT(1)
          INTO NUM_AB08_NS
          FROM AB08_NS
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND yab139 = prm_yab139       
           AND yae031 = '0'              --δ����
           AND aae120 = '0';             --��Ч
           
      END IF;
      
         
      IF NUM_AB08_NS = 0 THEN
         prm_AppCode  := pkg_COMM.gn_def_ERR ;
         prm_ErrMsg   := prm_aab001 || '����Ƿ���˷Ѵ��������ڴ��������ݣ�' ;
         
         var_issuccess   := '0';  --�ɹ���־
         var_successmsg  := NULL; --�ɹ���Ϣ
         var_failmsg     := prm_ErrMsg; --ʧ����Ϣ
         var_endtime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
         insertQRTZ_JOB_MSGS(prm_jobid,var_aab001,prm_aae011,var_starttime,var_endtime,var_issuccess,var_successmsg,var_failmsg);
             
         RETURN;
      END IF;
      
      IF prm_aab001 IS NULL THEN  --��������������
        
         FOR cur_1 in cur_ab01_all LOOP
        
              var_starttime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');  
              
              var_yae099 := cur_1.yae099;
              var_yae518 := cur_1.yae518;
              var_aab001 := cur_1.aab001;
              var_yae010 := cur_1.yae010;
              var_aae140 := cur_1.aae140;
              
              pkg_p_bcDataRefund( var_yae099 , --ҵ����ˮ��
                                  var_yae518 , --�˶���ˮ��
                                  var_aab001 , --��λ���
                                  prm_aae001 , --�������
                                  var_aae140 , --����
                                  var_yae010 , --������Դ
                                  prm_yab139 , --�����α�������
                                  prm_aae011 , --������
                                  prm_AppCode ,         --ִ�д���
                                  prm_ErrMsg            --ִ�н��
                                );
                       
              IF prm_AppCode <> pkg_comm.gn_def_OK THEN
                 var_issuccess   := '0';  --�ɹ���־
                 var_successmsg  := NULL; --�ɹ���Ϣ
                 var_failmsg     := '��λ��' || cur_1.aab001||' ҵ����ˮ��'||cur_1.yae099||' �ճ�����Ƿ���˷ѳ���:'||prm_ErrMsg; --ʧ����Ϣ
                 var_endtime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
                 insertQRTZ_JOB_MSGS(prm_jobid,var_aab001,prm_aae011,var_starttime,var_endtime,var_issuccess,var_successmsg,var_failmsg);
                 ROLLBACK;
              ELSE
                 var_issuccess   := '1';  --�ɹ���־
                 var_successmsg  := '��λ��' || cur_1.aab001||' ҵ����ˮ��'||cur_1.yae099||' �ճ�����Ƿ���˷ѳɹ�!'; --�ɹ���Ϣ
                 var_failmsg     := NULL; --ʧ����Ϣ
                 var_endtime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
                 insertQRTZ_JOB_MSGS(prm_jobid,var_aab001,prm_aae011,var_starttime,var_endtime,var_issuccess,var_successmsg,var_failmsg);
                 COMMIT;
              END IF;
       END LOOP;
        
       deleteYH_HTCONTRO(var_ywzb||prm_yab139,var_ywlx,prm_yab139);
    ELSE
      
       FOR cur_1 in cur_ab01_single LOOP
        
              var_starttime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');  
              
              var_yae099 := cur_1.yae099;
              var_yae518 := cur_1.yae518;
              var_aab001 := cur_1.aab001;
              var_yae010 := cur_1.yae010;
              var_aae140 := cur_1.aae140;
               
              pkg_p_bcDataRefund( var_yae099 , --ҵ����ˮ��
                                  var_yae518 , --�˶���ˮ��
                                  var_aab001 , --��λ���
                                  prm_aae001 , --�������
                                  var_aae140 , --����
                                  var_yae010 , --������Դ
                                  prm_yab139 , --�����α�������
                                  prm_aae011 , --������
                                  prm_AppCode ,         --ִ�д���
                                  prm_ErrMsg            --ִ�н��
                                );
                       
              IF prm_AppCode <> pkg_comm.gn_def_OK THEN
                 var_issuccess   := '0';  --�ɹ���־
                 var_successmsg  := NULL; --�ɹ���Ϣ
                 var_failmsg     := '��λ��' || cur_1.aab001||' ҵ����ˮ��'||cur_1.yae099||' �ճ�����Ƿ���˷ѳ���:'||prm_ErrMsg; --ʧ����Ϣ
                 var_endtime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
                 insertQRTZ_JOB_MSGS(prm_jobid,var_aab001,prm_aae011,var_starttime,var_endtime,var_issuccess,var_successmsg,var_failmsg);
                 ROLLBACK;
              ELSE
                 var_issuccess   := '1';  --�ɹ���־
                 var_successmsg  := '��λ��' || cur_1.aab001||' ҵ����ˮ��'||cur_1.yae099||' �ճ�����Ƿ���˷ѳɹ�'; --�ɹ���Ϣ
                 var_failmsg     := NULL; --ʧ����Ϣ
                 var_endtime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
                 insertQRTZ_JOB_MSGS(prm_jobid,var_aab001,prm_aae011,var_starttime,var_endtime,var_issuccess,var_successmsg,var_failmsg);
                 COMMIT;
              END IF;
       END LOOP;
       
       deleteYH_HTCONTRO(var_aab001,var_ywlx,prm_yab139);
       
    END IF;
    
    UPDATE YHCIP_ORACLE_JOBS 
       SET ENDTIME = SYSDATE,
           RESULT = '�������'
     WHERE jobid = prm_jobid; 
                   
   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'00';
         prm_ErrMsg  := '���󲹲�Ǩ�����ݳ�������ԭ��'||prm_ErrMsg||','||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END pkg_p_batchBcDataRefund; 
   
   
   /********************************************************************************/
   /*  ������� pkg_p_batchBcDataRefund                                            */
   /*  ҵ�񻷽� ����������Ƿ�Ѹ������˷�                                           */
   /*            ����̨��ʱ����ʹ�ã�ȫ��һ��ִ�У�����yab139��                    */
   /*                                                                              */
   /*  ����˵�� ��                                                                 */
   /*           �˷���Ϊ��̨��ʱ����ʹ�ã���������Ƿ�Ѹ������˷ѣ�ȫ��ͳһִ��     */
   /*           ע�⣺�α��ѯ�������������yab139��ǰ̨��������ã���������       */                                                    
   /*  �� �� �� ��fenggg                                                           */
   /*  ������� ��2019-07                                                          */
   /*  �汾��� ��Ver 1.0                                                          */
   /*  �� �� �� ��������                      ������� ��YYYY-MM-DD                */
   /********************************************************************************/
    PROCEDURE pkg_p_batchBcDataRefundJob( prm_aae001      IN   ab05.aae001%TYPE, --�������
                                          prm_aae011      IN   ab08.aae011%TYPE  --������  
                                        )
    IS
      var_procNo      VARCHAR2(5);         --���̺�  
      
      var_yae099      ae16.yae099%type;
      var_yae399      ae16.yae399%type;
      var_yae518      ab08.yae518%type;
      var_aab001      ab01.aab001%type;
      var_yae010      ab08.yae010%type;
      var_yab139      ab08.yab139%type;
      var_aae140      ab08.aae140%type;
      num_jobid       number;
      var_jobname     varchar2(200);
      var_what        varchar2(200);
      var_next_date   varchar2(200);
      
      var_starttime         VARCHAR2(30);     --��ʼʱ��
      var_endtime           VARCHAR2(30);     --��ֹʱ��
      var_issuccess         qrtz_job_msgs.issuccess%TYPE  ; --�ɹ���־
      var_successmsg        qrtz_job_msgs.successmsg%TYPE ; --�ɹ���Ϣ
      var_failmsg           qrtz_job_msgs.errormsg%TYPE   ; --ʧ����Ϣ
      var_result            qrtz_job_msgs.errormsg%TYPE; --��ʱִ�н��
      
      num_ab08_ns     number;
      var_ywlx        varchar2(20);
      var_ywzb        varchar2(20);
      
      prm_AppCode     varchar2(20);
      prm_ErrMsg      varchar2(2000);
      
      cursor cur_ab01_all is
        select *
          from ab08_ns
         where aae001 = prm_aae001
           and yae031 = '0'
           and aae120 = '0'
         order by aae036;
         
    BEGIN

      var_procNo   := 'A08'; 
      var_ywlx     := '42'; 
      var_ywzb     := 'PLNSQFTF';
      num_jobid := pkg_comm.fun_GetSequence(NULL,'JOBID');
      
      var_starttime := NULL;
      var_endtime := NULL;
      var_next_date := to_char(sysdate,'yyyymmdd hh24:mi:ss');
      var_jobname := to_char(sysdate,'yyyymmdd')||'(��̨��ʱ����)�ճ�����Ƿ���˷�';
      var_what := 'pkg_p_salaryExamineAdjust.pkg_p_batchBcDataRefundJob('''||prm_aae001||''','''||prm_aae011||''')';
      
      insertYHCIP_ORACLE_JOBS(
               num_jobid,
               var_jobname,
               var_what,
               var_next_date,
               null,
               prm_aae011
      );    
     
      IF prm_aae001 < 2019 THEN
         prm_AppCode := pkg_COMM.GN_DEF_ERR;
         prm_ErrMsg := '(��ʱ����)�ճ�����Ƿ���˷ѳ���������Ȳ���С��2019;';
         
         var_issuccess   := '0';  --�ɹ���־
         var_successmsg  := NULL; --�ɹ���Ϣ
         var_failmsg     := prm_ErrMsg; --ʧ����Ϣ
         var_endtime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
         insertQRTZ_JOB_MSGS(num_jobid,var_aab001,prm_aae011,var_starttime,var_endtime,var_issuccess,var_successmsg,var_failmsg);
         
         GOTO end_label;
      END IF;
      
      SELECT COUNT(1)
        INTO NUM_AB08_NS
        FROM AB08_NS
       WHERE aae001 = prm_aae001
         AND yae031 = '0'       --δ����
         AND aae120 = '0';      --��Ч
      
      IF NUM_AB08_NS = 0 THEN
         prm_AppCode  := pkg_COMM.gn_def_ERR ;
         prm_ErrMsg   := '(��ʱ����)�ճ�����Ƿ���˷ѣ������ڴ��������ݣ�' ;
         
         var_issuccess   := '0';  --�ɹ���־
         var_successmsg  := NULL; --�ɹ���Ϣ
         var_failmsg     := prm_ErrMsg; --ʧ����Ϣ
         var_endtime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
         insertQRTZ_JOB_MSGS(num_jobid,var_aab001,prm_aae011,var_starttime,var_endtime,var_issuccess,var_successmsg,var_failmsg);
             
         GOTO end_label;
      END IF;
      
      FOR cur_1 in cur_ab01_all LOOP
        
          var_starttime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');  
              
          var_yae099 := cur_1.yae099;
          var_yae518 := cur_1.yae518;
          var_aab001 := cur_1.aab001;
          var_yae010 := cur_1.yae010;
          var_yab139 := cur_1.yab139;
              
          pkg_p_bcDataRefund( var_yae099 , --ҵ����ˮ��
                              var_yae518 , --�˶���ˮ��
                              var_aab001 , --��λ���
                              prm_aae001 , --�������
                              var_aae140 , --����
                              var_yae010 , --������Դ
                              var_yab139 , --�����α�������
                              prm_aae011 , --������
                              prm_AppCode ,         --ִ�д���
                              prm_ErrMsg            --ִ�н��
                             );
          IF prm_AppCode <> pkg_comm.gn_def_OK THEN
             var_issuccess   := '0';  --�ɹ���־
             var_successmsg  := NULL; --�ɹ���Ϣ
             var_failmsg     := '��λ��' || cur_1.aab001||' ҵ����ˮ��'||cur_1.yae099||' Ƿ���˷ѳ���:'||prm_ErrMsg; --ʧ����Ϣ
             var_endtime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
             insertQRTZ_JOB_MSGS(num_jobid,var_aab001,prm_aae011,var_starttime,var_endtime,var_issuccess,var_successmsg,var_failmsg);
           --  ROLLBACK;
          ELSE
             var_issuccess   := '1';  --�ɹ���־
             var_successmsg  := '��λ��' || cur_1.aab001||' ҵ����ˮ��'||cur_1.yae099||' Ƿ���˷ѳɹ�'; --�ɹ���Ϣ
             var_failmsg     := NULL; --ʧ����Ϣ
             var_endtime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
             insertQRTZ_JOB_MSGS(num_jobid,var_aab001,prm_aae011,var_starttime,var_endtime,var_issuccess,var_successmsg,var_failmsg);
             COMMIT;
          END IF;
       END LOOP;
       
       <<end_label>>
         UPDATE YHCIP_ORACLE_JOBS 
            SET ENDTIME = SYSDATE,
                RESULT = '�������'
          WHERE jobid = num_jobid; 
          
    EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'00';
         prm_ErrMsg  := '����ʱ�����������ԭ��'||prm_ErrMsg||','||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
    END pkg_p_batchBcDataRefundJob;    
    /********************************************************************************/
   /*  ������� pkg_p_batchBcDataRefund                                            */
   /*  ҵ�񻷽� ����������Ƿ�Ѹ������˷� ��ʱ����ǰ̨�������ã�                  */
   /*                                                                              */
   /*  ����˵�� ��                                                                 */
   /*                                                                              */
   /*  �� �� �� ��fenggg                                                           */
   /*  ������� ��2019-07                                                          */
   /*  �汾��� ��Ver 1.0                                                          */
   /*  �� �� �� ��������                      ������� ��YYYY-MM-DD                */
   /********************************************************************************/
   --��������Ƿ�Ѹ������˷�(��ʱ����)
    PROCEDURE pkg_p_createBcDataRefundJob( prm_aab001      IN   ab01.aab001%TYPE, --��λ���
                                           prm_aae001      IN   ab05.aae001%TYPE, --�������
                                           prm_yab139      IN   ab08.yab139%TYPE, --�����α�������
                                           prm_aae011      IN   ab08.aae011%TYPE, --������
                                           prm_AppCode     OUT  VARCHAR2,         --ִ�д���
                                           prm_ErrMsg      OUT  VARCHAR2          --ִ�н��
                                          )
    IS
      var_procNo      VARCHAR2(5);         --���̺�  
    	num_jobid       NUMBER;
      jobid           BINARY_INTEGER;
      var_jobname     VARCHAR2(60);
      var_what        VARCHAR2(4000);
      var_next_date   VARCHAR2(100);
      var_interval    VARCHAR2(100);
      
      var_week        VARCHAR2(20);
      NUM_AB08_PERNUM NUMBER;
      NUM_COUNT       NUMBER;
      NUM_COUNT1      NUMBER;
      var_ywlx        VARCHAR2(20);
      var_ywzb        VARCHAR2(20);
 
    BEGIN
      prm_AppCode  := '';
      prm_ErrMsg   := '' ;
      var_procNo   := 'A09';
      var_ywlx     := '42'; 
      var_ywzb     := 'PLNSQFTF';
 
      
      IF prm_aae001 < 2019 THEN
         prm_AppCode := pkg_COMM.GN_DEF_ERR;
         prm_ErrMsg := '�ճ�����Ƿ���˷Ѵ�����ʱ�������������Ȳ���С��2019!';
         RETURN;
      END IF;
      
      IF prm_yab139 IS NULL THEN
         prm_AppCode := pkg_COMM.GN_DEF_ERR;
         prm_ErrMsg := '�ճ�����Ƿ���˷Ѵ�����ʱ���������������Ĳ���Ϊ��!';
         RETURN;
      END IF;
      
      select trim(to_char(sysdate,'day','NLS_DATE_LANGUAGE=AMERICAN')) into var_week from dual;
      
      num_jobid := pkg_comm.fun_GetSequence(NULL,'JOBID');
      var_jobname := to_char(sysdate,'yyyymmdd')||'�ճ�����Ƿ���˷�'||prm_aab001;
      var_interval := '';   
      var_what := 'pkg_p_salaryExamineAdjust.pkg_p_batchBcDataRefund('''|| num_jobid  ||''','''
                                                                        || prm_aab001 ||''','''
                                                                        || prm_aae001 ||''','''
                                                                        || prm_yab139 ||''','''
                                                                        || prm_aae011 ||''');';
                                                                        --|| prm_AppCode ||''','''
                                                                        --|| prm_ErrMsg ||'''
                                                                        
                                
      
      --��λ���Ϊ�� ���Ǵ���ȫ����λ������23.30ִ�ж�ʱ����
      --���������ӳ�һ��ִ��
      NUM_AB08_PERNUM := 0;
      IF prm_aab001 IS NULL THEN
        
         var_ywzb := var_ywzb||prm_yab139;  
         var_jobname := to_char(sysdate,'yyyymmdd')||'�ճ�����Ƿ���˷�(����)'||prm_yab139;                                   

         IF var_week = 'friday' THEN
            var_next_date := 'to_date(to_char(sysdate + 1,''yyyymmdd'')||''23:30:00'',''yyyymmdd hh24:mi:ss'')';
         ELSE
            var_next_date := 'to_date(to_char(sysdate ,''yyyymmdd'')||''23:30:00'',''yyyymmdd hh24:mi:ss'')';
         END IF;  

      ELSE --��λ��ŷǿգ���ֻ����õ�λ������С��1000 1�����Ժ�ִ��,��������1000 ����20��00ִ�У����������ӳ�һ��ִ��
         var_ywzb := prm_aab001;
         
         SELECT NVL(max(PERNUM),0),COUNT(1)
           INTO NUM_AB08_PERNUM,NUM_COUNT1
           FROM AB08_NS
          WHERE AAB001 = prm_aab001
            AND YAE031 = '0';
            
         IF NUM_COUNT1 < 1 THEN
            prm_AppCode := pkg_COMM.GN_DEF_ERR;
            prm_ErrMsg := '�ճ�����Ƿ���˷Ѵ�����ʱ����,��λ:'||prm_aab001||'��������Ҫ���������';
            RETURN;
         END IF;
         
         IF NUM_AB08_PERNUM > 1500 THEN
            IF var_week = 'friday' THEN
               var_next_date := 'to_date(to_char(sysdate + 1,''yyyymmdd'')||''20:00:00'',''yyyymmdd hh24:mi:ss'')';
            ELSE
               var_next_date := 'to_date(to_char(sysdate,''yyyymmdd'')||''20:00:00'',''yyyymmdd hh24:mi:ss'')';
            END IF;  
         ELSE
            var_next_date := 'sysdate + 1/1440';
         END IF;
      END IF;
      
      --У���Ƿ���ڴ�ִ�еĶ�ʱ����
      SELECT (SELECT COUNT(1)
                FROM YH_HTCONTRO
               WHERE ywzb = 'PLNSQFTF'||prm_yab139
                 AND ywlx = var_ywlx
                 AND yab003 = prm_yab139) 
             +
             (SELECT COUNT(1)
                FROM YH_HTCONTRO
               WHERE ywzb = prm_aab001
                 AND ywlx = var_ywlx
                 AND yab003 = prm_yab139)
        INTO NUM_COUNT
        FROM DUAL;
         
      IF NUM_COUNT > 0 THEN
         prm_AppCode := pkg_COMM.GN_DEF_ERR;
         prm_ErrMsg := '�ճ�����Ƿ���˷Ѵ�����ʱ����������������'||prm_yab139||'�Ѿ����ڴ�ִ�еĶ�ʱ���������ظ��ύ!';
         RETURN;
      END IF;
      
      pkg_YHCIP.prc_oracleJob(num_jobid,    
                              var_jobname,
                              var_what,
                              var_next_date,
                              var_interval,
                              prm_aae011,
                              prm_AppCode,
                              prm_ErrMsg
                              );
      IF prm_AppCode <> pkg_comm.gn_def_OK THEN
         prm_AppCode := pkg_COMM.GN_DEF_ERR;
         prm_ErrMsg := '�ճ�����Ƿ���˷Ѵ�����ʱ�������'||prm_ErrMsg||','||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
      ELSE
         prm_AppCode := pkg_COMM.GN_DEF_OK;
         prm_ErrMsg := '';
         insertYH_HTCONTRO(var_ywzb,var_ywlx,prm_yab139,prm_aae011);
      END IF;
                                     
    EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'00';
         prm_ErrMsg  := '������������Ƿ���˿����ʱ�����������ԭ��'||prm_ErrMsg||','||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END pkg_p_createBcDataRefundJob;
   
   
   /********************************************************************************/
   /*  ������� insertQRTZ_JOB_MSGS                                            */
   /*  ҵ�񻷽� ����¼��־                                     */
   /*                                                                              */
   /*  ����˵�� ��                                                                 */
   /*                                                                              */
   /*  �� �� �� ��fenggg                                                           */
   /*  ������� ��2019-07                                                          */
   /*  �汾��� ��Ver 1.0                                                          */
   /*  �� �� �� ��������                      ������� ��YYYY-MM-DD                */
   /********************************************************************************/                                   
    PROCEDURE insertYHCIP_ORACLE_JOBS(
      prm_jobid                          IN     VARCHAR2      ,--jobid�ⲿ��������������YHCIP_ORACLE_JOBS�����������ȥ����oracle���ɵ�jobid
      prm_jobname                        IN     VARCHAR2      ,--��������
      prm_what                           IN     VARCHAR2      ,--ִ�й��̣���Ҫ��;���ֺŽ�β
      prm_next_date                      IN     VARCHAR2      ,--ִ��ʱ��
      prm_interval                       IN     VARCHAR2      ,--���ѭ��ʱ��
      prm_userid                         IN     VARCHAR2       --�û�id
   ) 
   IS
      var_procNo      VARCHAR2(5);         --���̺�  
      pragma autonomous_transaction;
      
   BEGIN
     
      INSERT INTO YHCIP_ORACLE_JOBS
        (JOBID, --����һ����ʱ����
         JOBNAME, --��ʱ���������
         STARTTIME, --��ʼִ��ʱ��
         USERID, --ִ�е��û�
         oraclejobid,
         what,
         interval) --oracle��jobid
      VALUES
        (prm_jobid,
         prm_jobname,
         prm_next_date,
         prm_userid,
         prm_jobid,
         prm_what,
         null);
      
      INSERT INTO QRTZ_JOB_MSGS
        (ID,
         JOBID,
         JOB_NAME,
         JOB_GROUP,
         USERID,
         EXECSTARTTIME,
         EXECENDTIME,
         ISSUCCESS,
         SUCCESSMSG)
      VALUES
        (SEQ_DEFAULT.NEXTVAL,
         prm_jobid,
         prm_jobname,
         'DEFAULT',
         prm_userid,
         to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'),
         to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'),
         '0',
         'LOG:�����ɹ�');
         
     COMMIT;
   END insertYHCIP_ORACLE_JOBS;
  


   /*****************************************************************************
   ** �������� insertYH_HTCONTRO
   ** ���̱�� ��05
   ** ҵ�񻷽� ����¼��־
   ** �������� ��
   *****************************************************************************
   ** ��        �������� ��2016-07-19   �汾��� ��Ver 1.0.0
   ******************************************************************************
   ** ��    �ģ�
   ******************************************************************************
   ** ��    ע��prm_AppCode ������:���̱�ţ�2λ�� �� ˳��ţ�2λ��
   *****************************************************************************/
   PROCEDURE insertQRTZ_JOB_MSGS(
       prm_jobid  in  yhcip_oracle_jobs.jobid%TYPE,    --jobid
       prm_aab001 in  ab01.aab001%TYPE,                --��λid
       prm_aae011 in  ad04a1.aae011%TYPE,
       prm_starttime  in QRTZ_JOB_MSGS.Execstarttime%TYPE,
       prm_endtime    in QRTZ_JOB_MSGS.Execendtime%TYPE,
       prm_issuccess in qrtz_job_msgs.issuccess%TYPE,
       prm_successmsg in qrtz_job_msgs.successmsg%TYPE,
       prm_failmsg in qrtz_job_msgs.errormsg%TYPE
   ) 
  IS
      pragma autonomous_transaction;
  BEGIN
          INSERT INTO QRTZ_JOB_MSGS
                (ID,
                 JOBID,
                 JOB_NAME,
                 JOB_GROUP,
                 USERID,
                 EXECSTARTTIME,
                 EXECENDTIME,
                 ISSUCCESS,
                 SUCCESSMSG,
                 ERRORMSG)
              VALUES
                (SEQ_DEFAULT.NEXTVAL,
                 prm_jobid,
                 prm_aab001||'�ճ�����Ƿ���˷�',
                 'DEFAULT',
                 prm_aae011,
                 prm_starttime,
                 prm_endtime,
                 prm_issuccess,
                 prm_successmsg,
                 prm_failmsg);
     COMMIT;
  END insertQRTZ_JOB_MSGS;
  
  /*****************************************************************************
   ** �������� insertYH_HTCONTRO
   ** ���̱�� ��05
   ** ҵ�񻷽� �������������̿����ظ��ύ
   ** �������� ��
   *****************************************************************************
   ** ��        �������� ��2016-07-19   �汾��� ��Ver 1.0.0
   ******************************************************************************
   ** ��    �ģ�
   ******************************************************************************
   ** ��    ע��prm_AppCode ������:���̱�ţ�2λ�� �� ˳��ţ�2λ��
   *****************************************************************************/
   procedure insertYH_HTCONTRO(
       prm_ywzb   YH_HTCONTRO.ywzb%type,
       prm_ywlx   YH_HTCONTRO.Ywlx%type,
       prm_yab139 YH_HTCONTRO.YAB003%TYPE,
       prm_aae011 YH_HTCONTRO.AAE011%TYPE
       
   ) is
    pragma autonomous_transaction;
    VAR_BFID  VARCHAR2(20);
  begin
    SELECT SEQ_BFID.NEXTVAL INTO VAR_BFID FROM DUAL;
    insert into YH_HTCONTRO(bfid,ywlx,aae030,yab003,aae011,ywzb)
         values (VAR_BFID,prm_ywlx,SYSDATE,prm_yab139,prm_aae011,prm_ywzb);
    commit;
  end;
  /*****************************************************************************
   ** �������� deleteYH_HTCONTRO
   ** ���̱�� ��06
   ** ҵ�񻷽� �������������̿����ظ��ύɾ��
   ** �������� ��
   *****************************************************************************
   ** ��        �������� ��2016-07-19   �汾��� ��Ver 1.0.0
   ******************************************************************************
   ** ��    �ģ�
   ******************************************************************************
   ** ��    ע��prm_AppCode ������:���̱�ţ�2λ�� �� ˳��ţ�2λ��
   *****************************************************************************/
   procedure deleteYH_HTCONTRO(
       prm_ywzb   YH_HTCONTRO.ywzb%type,
       prm_ywlx   YH_HTCONTRO.Ywlx%type,
       prm_yab139 YH_HTCONTRO.YAB003%TYPE
   ) is
    pragma autonomous_transaction;
  begin
    DELETE YH_HTCONTRO WHERE ywzb = prm_ywzb and ywlx = prm_ywlx and yab003 = prm_yab139;
    commit;
  end;
END pkg_p_salaryExamineAdjust;
/
