CREATE OR REPLACE PACKAGE PKG_YEARAPPLY AS
   /*---------------------------------------------------------------------------
   ||  ������� ��PKG_YearApply
   ||  ҵ�񻷽� ��YearApply
   ||  �����б� ��˽�й��̺���
   ||             --------------------------------------------------------------
   ||             ���ù��̺���
   ||             --------------------------------------------------------------
   ||
   ||  ����˵�� ��
   ||  ������� ��
   ||  �汾��� ��Ver 1.0
   ||  �� �� �� ��������                      ������� ��YYYY-MM-DD
   ||-------------------------------------------------------------------------*/

   /*-------------------------------------------------------------------------*/
   /* ����ȫ�ֳ�������                                                        */
   /*-------------------------------------------------------------------------*/
   gn_def_OK  CONSTANT VARCHAR2(12) := 'NOERROR'; -- �ɹ�
   gn_def_ERR CONSTANT VARCHAR2(12) := '9999'; -- ϵͳ����



--���󲹲�У��
PROCEDURE prc_YearSalaryAdjustPaded  (
                                          prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                                          prm_aac001       IN     irac01.aac001%TYPE,--���˱��  �Ǳ���
                                          prm_aac040       IN     xasi2.ac02.aac040%TYPE, --���� �Ǳ���
                                          prm_aae001       IN     NUMBER            ,--�������
                                          prm_aae011       IN     irad31.aae011%TYPE,--������
                                          prm_yab139       IN     VARCHAR2          ,--�α�����������
                                          prm_yab019       IN     xasi2.ac01k8.yab019%TYPE ,--ҵ�����ͱ�־ 1-һ����ҵ��2-������������
                                          prm_AppCode      OUT    VARCHAR2          ,
                                          prm_ErrorMsg     OUT    VARCHAR2          );

--���ϽɷѲ���У��
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
                         prm_ErrMsg     OUT    VARCHAR2);             --������Ϣ


--����У�����
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
                         prm_ErrMsg      OUT      VARCHAR2 );
--����У����̣��ܹ��̣�
PROCEDURE  prc_p_checkData(prm_aab001   IN   xasi2.ab02.aab001%TYPE,   --��λ���
                           prm_yab139   IN   xasi2.ac02.yab139%TYPE,   --�α�����������
                           prm_yab003   IN   xasi2.ac02.yab003%TYPE,   --�籣�������
                           prm_AppCode  OUT  VARCHAR2,           --ִ�д���
                           prm_ErrMsg   OUT  VARCHAR2);          --ִ�н��


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
        prm_ErrorMsg     OUT    VARCHAR2             );
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
        prm_ErrorMsg     OUT    VARCHAR2             );
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
        prm_ErrorMsg     OUT    VARCHAR2             );

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
        prm_ErrorMsg     OUT    VARCHAR2             );
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
        prm_ErrorMsg     OUT    VARCHAR2             );

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
        prm_ErrorMsg     OUT    VARCHAR2             );
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
        prm_ErrorMsg     OUT    VARCHAR2             );

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
                                   prm_ErrorMsg     OUT    VARCHAR2    );
  /*****************************************************************************
   ** �������� : prc_YearInternetAuditRB
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����˶��������(����)
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
   PROCEDURE prc_YearInternetAuditRB(
                                    prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
                                    prm_aae001       IN     xasi2.ac01k8.aae001%TYPE,--������
                                    prm_iaa011       IN     irad51.iaa011%TYPE,--ҵ������
                                   prm_yab019       IN     VARCHAR2 , --���ͱ�־ 1--��ҵ�����걨 2--�������ϻ����걨
                                   prm_AppCode      OUT    VARCHAR2          ,
                                   prm_ErrorMsg     OUT    VARCHAR2    );
   /*****************************************************************************
   ** �������� : prc_YearInternetBC
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����˶˲������
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
                prm_aae001       IN     xasi2_zs.ab05a1.aae001%TYPE,--������
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
                                   prm_iaa011       IN     irad51.iaa011%TYPE,--ҵ������
                                   prm_yab019       IN     VARCHAR2 , --���ͱ�־ 1--��ҵ�����걨 2--�������ϻ����걨
                                   prm_AppCode      OUT    VARCHAR2          ,
                                   prm_ErrorMsg     OUT    VARCHAR2    );

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
        prm_iaa011       IN     irad51.iaa011%TYPE,--ҵ������
        prm_yab019       IN     VARCHAR2 , --���ͱ�־ 1--��ҵ�����걨 2--�������ϻ����걨
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             );
        
   --����AC01K8
   PROCEDURE prc_UpdateAc01k8 (
       prm_aab001       IN     xasi2.ac01k8.aab001%TYPE,--�걨��λ
        prm_aac001       IN     xasi2.ac01k8.aac001%TYPE,--���˱��
        prm_aae001       IN     xasi2.ac01k8.aae001%TYPE,--�걨���
        prm_aac040       IN     xasi2.ac01k8.aac040%TYPE, --�½ɷѹ���
        prm_AppCode   OUT    VARCHAR2,
        prm_ErrorMsg    OUT    VARCHAR2);        
        
--   /*****************************************************************************
--   ** �������� : prc_checkInsertIrac08a1
--   ** ���̱�� ��
--   ** ҵ�񻷽� ��
--   ** �������� ���������ϽɷѼ�¼���
--   ******************************************************************************
--   ** �������� ��������ʶ        ����/���         ����                 ����
--   ******************************************************************************
--   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
--   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--������
--   **           prm_AppCode      OUT    VARCHAR2          ,
--   **           prm_ErrorMsg     OUT    VARCHAR2
--   ******************************************************************************
--   ** ��    �ߣ�yh         �������� ��2013-05-25   �汾��� ��Ver 1.0.0
--   ** ��    �ģ�
--   *****************************************************************************/
--   PROCEDURE prc_checkInsertIrac08a1 (prm_yae099       IN     VARCHAR2,
--                                      prm_aab001       IN     irab01.aab001%TYPE,--�걨��λ
--                                      prm_aae011       IN     VARCHAR2 ,
--                                      prm_AppCode      OUT    VARCHAR2 ,
--                                      prm_ErrorMsg     OUT    VARCHAR2
--                                      );
--   /*****************************************************************************
--   ** �������� : prc_insertIrac08a1
--   ** ���̱�� ��
--   ** ҵ�񻷽� ��
--   ** �������� ���������ϽɷѼ�¼
--   ******************************************************************************
--   ** �������� ��������ʶ        ����/���         ����                 ����
--   ******************************************************************************
--   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--�걨��λ
--   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--������
--   **           prm_AppCode      OUT    VARCHAR2          ,
--   **           prm_ErrorMsg     OUT    VARCHAR2
--   ******************************************************************************
--   ** ��    �ߣ�yh         �������� ��2013-05-25   �汾��� ��Ver 1.0.0
--   ** ��    �ģ�
--   *****************************************************************************/
--   PROCEDURE prc_insertIrac08a1 (prm_yae099       IN     VARCHAR2,
--                                 prm_aab001       IN     irab01.aab001%TYPE,--�걨��λ
--                                 prm_aae002       IN     VARCHAR2 ,
--                                 prm_aae011       IN     VARCHAR2 ,
--                                 prm_AppCode      OUT    VARCHAR2 ,
--                                 prm_ErrorMsg     OUT    VARCHAR2
--                                 );

PROCEDURE prc_YearSalaryBCByYL(prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                               prm_aae001       IN     NUMBER            ,--�������
                               prm_aae002       IN     NUMBER            ,
                               prm_yab222       IN     xasi2.ab08.yab222%TYPE,
                               prm_aae076       IN     xasi2.ab08.aae076%TYPE,
                               prm_type         IN     VARCHAR2,  --1Ϊ��ƽ����ǰ 2Ϊ��ƽ������
                               prm_aae011       IN     irad31.aae011%TYPE,--������
                               prm_yab139       IN     VARCHAR2          ,--�α�����������
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          );
--��ƽ���ʹ����󲹲�
PROCEDURE prc_YearSalaryBCBySP(prm_aab001       IN     irab01.aab001%TYPE,--��λ���  �Ǳ���
                               prm_yab139       IN     VARCHAR2          ,--�α�����������
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          );
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
                               prm_ErrorMsg     OUT    VARCHAR2          );
PROCEDURE prc_YearSalaryByPayInfos (prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                               prm_type         IN     VARCHAR2,   --1 Ϊ��ƽ����ǰ���� 2Ϊ��ƽ�����󲹲�
                               prm_aae003       IN     NUMBER,
                               prm_aae140       IN     VARCHAR2,
                               prm_aae001       IN     NUMBER,
                               prm_yab222       IN     VARCHAR2,
                               prm_aae011       IN     VARCHAR2,
                               prm_yab139       IN     VARCHAR2,
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          );
--��ʼ���󲹲�£�
PROCEDURE prc_YearSalaryBCBegin(prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                               prm_aae001       IN     NUMBER            ,--�������
                               prm_type         IN     VARCHAR2,  --1Ϊ��ƽ����ǰ 2Ϊ��ƽ������
                               prm_aae011       IN     irad31.aae011%TYPE,--������
                               prm_yab139       IN     VARCHAR2          ,--�α�����������
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          );
--�����������
PROCEDURE prc_YearSalaryClear (prm_aab001       IN     irab01.aab001%TYPE,--��λ���  ����
                               prm_aae001       IN     NUMBER            ,--�������
                               prm_aae011       IN     irad31.aae011%TYPE,--������
                               prm_flag         OUT     VARCHAR2,     --�ɹ���־ 0�ɹ� 1 ʧ��
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          );
--�����������(ͬ��λ1�»����Ƚ�)                               
PROCEDURE prc_YearApplyJSProportions (prm_aab001       IN      xasi2.ab01.aab001%TYPE,--��λ���
                               prm_aae001       IN     NUMBER            ,--�������
                               prm_aae011       IN     irad31.aae011%TYPE,--������
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          );
--���ʱ����                               
PROCEDURE pkg_p_createJob( 
                              prm_aab001      IN   xasi2.ab01.aab001%TYPE,  --��λ��� 
                              prm_aae001      IN   xasi2.ab05.aae001%TYPE,  --�������
                              prm_aae011      IN   xasi2.ab08.aae011%TYPE,  --������ 
                              prm_iaa011         IN     irad51.iaa011%TYPE,              --ҵ������
                              prm_yab019        IN     VARCHAR2          ,                 --���ͱ�־
                              prm_yab139      IN   xasi2.ab02.yab139%TYPE,  --���������
                              prm_AppCode   OUT    VARCHAR2 ,   
                              prm_ErrMsg       OUT    VARCHAR2     );   
 -- ����                           
PROCEDURE prc_YearSalaryBCJOB(
                           prm_jobid            IN    VARCHAR2,  
                           prm_aab001        IN     irab01.aab001%TYPE,           --��λ���  ����
                           prm_aae001        IN     NUMBER            ,                  --�������
                           prm_aae011        IN     irad31.aae011%TYPE,            --������
                           prm_yab139        IN     VARCHAR2          ,                 --�α�����������
                           prm_iaa011         IN     irad51.iaa011%TYPE,              --ҵ������
                           prm_yab019        IN     VARCHAR2    );               --���ͱ�־
                             
END PKG_YearApply;