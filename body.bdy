create or replace package body PKG_Insurance AS
   /**************************************************************************************/
   /* ������� ��PKG_Insurance                                                           */
   /* ҵ�񻷽� ����Ա����                                                                */
   /* �������� ��                                                                        */
   /*------------------------------------------------------------------------------------*/
   /* �����б� �����ù���                                                                */
   /* ���̱��   ������                                ����                              */
   /*  01        prc_AddNewEmpReg                   ��λ������                           */
   /*  02        prc_AddApplyInfo                   ��ᱣ�յǼ�                         */
   /*  03        prc_UnitInfoMaintain               ��λ��Ϣά��                         */
   /*  04        prc_AuditSocietyInsuranceR         ��ᱣ�յǼ����                     */
   /*  05        prc_AuditSocietyInsuranceREmp      ��ᱣ�յǼ����[��λ]               */
   /*  06        prc_AuditSocietyInsuranceRPer      ��ᱣ�յǼ����[���� �²α� ����]   */
   /*  07        prc_AddNewManage                   ����ר��Ա                           */
   /*  08        prc_MonthInternetRegister          ���걨                               */
   /*  09        prc_AuditMonthInternetR            ���걨���                           */

   PRE_ERRCODE  CONSTANT VARCHAR2(12) := 'INSURANCE'; -- �����Ĵ�����ǰ׺

   /*****************************************************************************
   ** �������� : prc_AuditSocietyInsuranceREmp
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����ᱣ�յǼ����[��λ�α�]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-22   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_AuditSocietyInsuranceREmp (
      prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
      prm_aab001       IN     irab01.aab001%TYPE,--��λ������
      prm_aae011       IN     iraa02.iaa011%TYPE,--������
      prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2    );

   /*****************************************************************************
   ** �������� : prc_AuditSocietyInsuranceRPer
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����ᱣ�յǼ����[��Ա�α�]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-24   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_AuditSocietyInsuranceRPer (prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                            prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --��λ����
                                            prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                            prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                            prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                            prm_aae036       IN    irac01.aae036%TYPE ,    --����ʱ��
                                            prm_AppCode      OUT   VARCHAR2  ,    --�������
                                            prm_ErrMsg       OUT   VARCHAR2  );   --��������


   /***************************************************************************
   ** ���̳� ��prc_AuditMonthInternetRpause
   ** ���̺� ��
   ** ҵ��� ������ͣ��
   ** ������ ������ͣ��
   ****************************************************************************
   ** ������ ��������ʶ        ����/���           ����               ����
   ****************************************************************************
   **
   ** ��  �ߣ�     �������� ��2009-11-26   �汾��� ��Ver 1.0.0
   ****************************************************************************
   ** ��  �ģ�
   ****************************************************************************
   ** ��  ע��prm_AppCode ������:���̱�ţ�2λ�� �� ˳��ţ�2λ��
   ***************************************************************************/
   --����ͣ��
   PROCEDURE prc_AuditMonthInternetRpause
                            (prm_yae099       IN    xasi2.ac05.YAE099%TYPE  ,     --ҵ����ˮ��
                             prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --��λ����
                             prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                             prm_aae011       IN    irac01.aae011%TYPE ,    --������
                             prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                             prm_aae036       IN    irac01.aae036%TYPE ,    --����ʱ��
                             prm_AppCode     OUT    VARCHAR2          ,     --ִ�д���
                             prm_ErrMsg      OUT    VARCHAR2          );    --ִ�н��

   /*****************************************************************************
   ** �������� : prc_RollBackASIREmp
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ��������ᱣ�յǼ����[��λ��Ϣ����]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ���
   **           prm_yea099       IN     ae02a2.yae099%TYPE,--ҵ����ˮ��
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-06   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_RollBackASIREmp (
      prm_aab001       IN     irab01.aab001%TYPE,--��λ���
      prm_yae099       IN     xasi2.ac02a2.yae099%TYPE,--ҵ����ˮ��
      prm_aae011       IN     xasi2.ab01.aae011%TYPE  ,--������
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );

   /*****************************************************************************
   ** �������� : prc_p_checkQYYL
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����ҵ���ϽɷѺ˶�
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ���
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-22   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_p_checkQYYL (
      prm_aab001       IN     irab01.aab001%TYPE,--��λ���
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );

   /*****************************************************************************
   ** �������� : prc_RollBackASIRPer
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ��������ᱣ�յǼ����[������Ϣ���� �²α� ����]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aac001       IN     irac01.aac001%TYPE,--��Ա���
   **           prm_yea099       IN     ae02a2.yae099%TYPE,--ҵ����ˮ��
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-06   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_RollBackASIRPer (
      prm_iac001       IN     irac01.iac001%TYPE,--�걨��Ա���
      prm_yae099       IN     xasi2.ac02a2.yae099%TYPE,--ҵ����ˮ��
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );

   /*****************************************************************************
   ** �������� : prc_RollBackAMIRPer
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ���������걨���[������Ϣ���� ͣ��]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aac001       IN     irac01.aac001%TYPE,--��Ա���
   **           prm_yea099       IN     ae02a2.yae099%TYPE,--ҵ����ˮ��
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-06   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_RollBackAMIRPer (
      prm_iac001       IN     irac01.iac001%TYPE,--�걨��Ա���
      prm_yae099       IN     xasi2.ac02a2.yae099%TYPE,--ҵ����ˮ��
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );


   /*****************************************************************************
   ** �������� : prc_PersonInsuCheck
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��Ա�²α����]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuCheck(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                             prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --��λ����
                             prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                             prm_aae011       IN    irac01.aae011%TYPE ,    --������
                             prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                             prm_aae036       IN    irac01.aae036%TYPE ,    --����ʱ��
                             prm_AppCode      OUT   VARCHAR2  ,    --�������
                             prm_ErrMsg       OUT   VARCHAR2  );   --��������


   /*****************************************************************************
   ** �������� : prc_PersonInsuAddCheck
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��Ա�����������]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuAddCheck(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --��λ����
                                prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                prm_aae036       IN    irac01.aae036%TYPE ,    --����ʱ��
                                prm_AppCode      OUT   VARCHAR2  ,    --�������
                                prm_ErrMsg       OUT   VARCHAR2  );   --��������


   /*****************************************************************************
   ** �������� : prc_PersonInsuContinue
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��Ա�������]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuContinue(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --��λ����
                                prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                prm_aae036       IN    irac01.aae036%TYPE ,    --����ʱ��
                                prm_AppCode      OUT   VARCHAR2  ,    --�������
                                prm_ErrMsg       OUT   VARCHAR2  );   --��������

   /*****************************************************************************
   ** �������� : prc_PersonInsuPause
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��Աͣ�����]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuPause(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                             prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --��λ����
                             prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                             prm_aae011       IN    irac01.aae011%TYPE ,    --������
                             prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                             prm_aae036       IN    irac01.aae036%TYPE ,    --����ʱ��
                             prm_AppCode      OUT   VARCHAR2  ,    --�������
                             prm_ErrMsg       OUT   VARCHAR2  );   --��������


   /*****************************************************************************
   ** �������� : prc_PersonInsuToRetire
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��ְת�������]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuToRetire(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --��λ����
                                prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                prm_aae036       IN    irac01.aae036%TYPE ,    --����ʱ��
                                prm_AppCode      OUT   VARCHAR2  ,    --�������
                                prm_ErrMsg       OUT   VARCHAR2  );   --��������
   /*****************************************************************************
   ** �������� : prc_PersonInsuCheckRollback
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��Ա�²α����]����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuCheckRollback(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                     prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                     prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                     prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                     prm_aae013       IN    irac01.aae013%TYPE ,    --��ע
                                     prm_AppCode      OUT   VARCHAR2  ,    --�������
                                     prm_ErrMsg       OUT   VARCHAR2  );   --��������

   /*****************************************************************************
   ** �������� : prc_PersonInsuAddCheckRollback
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��Ա�����������]����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuAddCheckRollback(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                        prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                        prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                        prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                        prm_aae013       IN    irac01.aae013%TYPE ,    --��ע
                                        prm_AppCode      OUT   VARCHAR2  ,    --�������
                                        prm_ErrMsg       OUT   VARCHAR2  );   --��������

   /*****************************************************************************
   ** �������� : prc_PersonInsuContinueRollback
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��Ա�������]����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuContinueRollback(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                        prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                        prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                        prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                        prm_aae013       IN    irac01.aae013%TYPE ,    --��ע
                                        prm_AppCode      OUT   VARCHAR2  ,    --�������
                                        prm_ErrMsg       OUT   VARCHAR2  );   --��������
   /*****************************************************************************
   ** �������� : prc_PersonInsuPauseRollback
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��Աͣ�����]����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuPauseRollback(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                    prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                    prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                    prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                    prm_aae013       IN    irac01.aae013%TYPE ,    --��ע
                                    prm_AppCode      OUT   VARCHAR2  ,    --�������
                                    prm_ErrMsg       OUT   VARCHAR2  );   --��������

   /*****************************************************************************
   ** �������� : prc_PersonInsuToRetireRollback
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��ְת�������]����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuToRetireRollback(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                        prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                        prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                        prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                        prm_aae013       IN    irac01.aae013%TYPE ,    --��ע
                                        prm_AppCode      OUT   VARCHAR2  ,    --�������
                                        prm_ErrMsg       OUT   VARCHAR2  );   --��������

   /*****************************************************************************
   ** �������� : prc_PersonInfoRepair
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ���±����ͨ�����������Ϣ
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_iac001        IN    irac01.iac001%TYPE,--�걨���
   **           prm_aac001       IN    irac01.aac001%TYPE,  --���˱��
   **           prm_aac002       IN    irac01.aac002%TYPE, --֤����
   **           prm_aab001       IN    irab01.aab001%TYPE,  --��λ������
   **           prm_aae011       IN    irac01.aae011%TYPE ,  --������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2018-12-21   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInfoRepair(prm_yae099       IN    VARCHAR2,  --ҵ����ˮ��
                                  prm_iac001        IN    irac01.iac001%TYPE,--�걨���
                                  prm_aac001       IN    irac01.aac001%TYPE,  --���˱��
                                  prm_aac002       IN    irac01.aac002%TYPE, --֤������
                                  prm_aab001       IN    irab01.aab001%TYPE,  --��λ������
                                  prm_aae011       IN    irac01.aae011%TYPE ,  --������
                                  prm_AppCode   OUT   VARCHAR2  ,    --�������
                                  prm_ErrMsg       OUT   VARCHAR2  );   --��������


   /*****************************************************************************
   ** �������� prc_AddNewEmpReg
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����λ������[������ҵ�������ֵ��ϵ�λ]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_iab001       IN     irab01.iab001%TYPE,--��λ������
   **           prm_aab003       IN     irab01.aab003%TYPE,--��֯��������
   **           prm_aab004       IN     irab01.aab004%TYPE,--��λ����
   **           prm_aab007       IN     irab01.aab007%TYPE,--����ִ�պ���
   **           prm_aab030       IN     irab01.aab030%TYPE,--˰�պ���
   **           prm_yab028       IN     irab01.yab028%TYPE,--��˰�������
   **           prm_yab534       IN     irab01.yab534%TYPE,--�����������
   **           prm_aab024       IN     irab01.aab024%TYPE,--��������
   **           prm_aab025       IN     irab01.aab025%TYPE,--���л���
   **           prm_aab026       IN     irab01.aab026%TYPE,--���л����˺�
   **           prm_aac003       IN     iraa01.aab016%TYPE,--ר��Ա����
   **           prm_yae042       IN     iraa01.yae042%TYPE,--ר��Ա����
   **           prm_yae043       IN     iraa01.yae043%TYPE,--��ʼ����
   **           prm_aae120       IN     irab01.aae120%TYPE,--��������
   **           prm_aae210       IN     irab01.aae210%TYPE,--ʧҵ����
   **           prm_aae310       IN     irab01.aae310%TYPE,--ҽ�Ʊ���
   **           prm_aae410       IN     irab01.aae410%TYPE,--����
   **           prm_aae510       IN     irab01.aae510%TYPE,--����
   **           prm_aae311       IN     irab01.aae311%TYPE,--��
   **           prm_aae011       IN     irab01.aae011%TYPE,--������
   **           prm_yab003       IN     irab01.yab003%TYPE,--�������
   **           prm_aae013       IN     irab01.aae013%TYPE,--��ע
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          )
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-12   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   ** ��λ������[������ҵ�������ֵ��ϵ�λ]
   *****************************************************************************/
   PROCEDURE prc_AddNewEmpReg (
      prm_iab001       IN     irab01.iab001%TYPE,--��λ������
      prm_aab003       IN     irab01.aab003%TYPE,--��֯��������
      prm_aab004       IN     irab01.aab004%TYPE,--��λ����
      prm_yab028       IN     irab01.yab028%TYPE,--��˰�������
      prm_yab006       IN     irab01.yab006%TYPE,--˰�����
      prm_aab019       IN     irab01.aab019%TYPE,--��λ����
      prm_aab020       IN     irab01.aab020%TYPE,--��������
      prm_aab021       IN     irab01.aab021%TYPE,--������ϵ
      prm_aab022       IN     irab01.aab022%TYPE,--��ҵ����
      prm_yab022       IN     irab01.yab022%TYPE,--��ҵ��ʶ
      prm_aab030       IN     irab01.aab030%TYPE,--˰�պ���
      prm_ylb001       IN     irab01.ylb001%TYPE,--������ҵ�ȼ�
      prm_yab136       IN     irab01.yab136%TYPE,--��λ����״̬
      prm_yab534       IN     irab01.yab534%TYPE,--�����������
      prm_aab024       IN     irab01.aab024%TYPE,--��������
      prm_aab025       IN     irab01.aab025%TYPE,--���л���
      prm_aab026       IN     irab01.aab026%TYPE,--���л����˺�
      prm_aac003       IN     iraa01.aab016%TYPE,--ר��Ա����
      prm_yab516       IN     iraa01.yab516%TYPE,--ר��Ա���֤��
      prm_yae042       IN     iraa01.yae042%TYPE,--ר��Ա����
      prm_yae043       IN     iraa01.yae043%TYPE,--��ʼ����
      prm_aae110       IN     irab01.aae110%TYPE,--ְ������
      prm_aae120       IN     irab01.aae120%TYPE,--��������
      prm_aae210       IN     irab01.aae210%TYPE,--ʧҵ����
      prm_aae310       IN     irab01.aae310%TYPE,--ҽ�Ʊ���
      prm_aae410       IN     irab01.aae410%TYPE,--����
      prm_aae510       IN     irab01.aae510%TYPE,--����
      prm_aae311       IN     irab01.aae311%TYPE,--��
      prm_yae010_110   IN     irab03.yae010_110%TYPE,--ְ��������Դ��ʽ
      prm_yae010_120   IN     irab03.yae010_120%TYPE,--����������Դ��ʽ
      prm_yae010_210   IN     irab03.yae010_210%TYPE,--ʧҵ������Դ��ʽ
      prm_yae010_310   IN     irab03.yae010_310%TYPE,--ҽ�Ʊ�����Դ��ʽ
      prm_yae010_410   IN     irab03.yae010_410%TYPE,--������Դ��ʽ
      prm_yae010_510   IN     irab03.yae010_510%TYPE,--������Դ��ʽ
      prm_yae010_311   IN     irab03.yae010_311%TYPE,--����Դ��ʽ
      prm_aae011       IN     irab01.aae011%TYPE,--������
      prm_yab003       IN     irab01.yab003%TYPE,--�������
      prm_aae013       IN     irab01.aae013%TYPE,--��ע
      prm_flag         IN     VARCHAR2          , --�Ƿ���ҵ�������ֵ��ϵ�λ
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      n_count    number(2);
      v_yae092   varchar2(15);
      v_aaz002   varchar2(15);
      v_yae367   varchar2(15);
      v_yae099   varchar2(15);
      var_position varchar2(15);
      temp_count  number(3);
   BEGIN

      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;

      /*��Ҫ������У��*/
      IF prm_iab001 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'��λ�����벻��Ϊ��!';
         RETURN;
      END IF;

      IF prm_aab004 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'��λ���Ʋ���Ϊ��!';
         RETURN;
      END IF;

      /*
      IF prm_yab534 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'���������Ϊ��!';
         RETURN;
      END IF;

      IF prm_aab024 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'�������в���Ϊ��!';
         RETURN;
      END IF;

      IF prm_aab025 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'���л�������Ϊ��!';
         RETURN;
      END IF;

      IF prm_aab026 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'���л����˺Ų���Ϊ��!';
         RETURN;
      END IF;
      */

      IF prm_aac003 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'ר��Ա��������Ϊ��!';
         RETURN;
      END IF;

      IF prm_yae042 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE || 'ר��Ա���벻��Ϊ��!';
         RETURN;
      END IF;

      IF prm_yae043 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'��ʼ���벻��Ϊ��!';
         RETURN;
      END IF;

      IF prm_aae011 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'�����˲���Ϊ��!';
         RETURN;
      END IF;

      --�Ƿ������ͬ�ĵ�λ��Ϣ
      /*
      ��������ͬ�����������ʵĵ�λ�磺���ݵ�λ��
      IF prm_aab003 IS NOT NULL THEN
         SELECT COUNT(1)
           INTO n_count
           FROM AB01
          WHERE aab003 = prm_aab003          --��֯��������
            AND aab004 = prm_aab004;         --��λ����
         IF n_count > 0 THEN
            prm_ErrorMsg := PRE_ERRCODE ||'�Ѿ�������֯��������Ϊ['|| prm_aab003 ||']����ͬ�ĵ�λ['|| prm_aab004 ||']!';
            RETURN;
         END IF;
      END IF;

      IF prm_aab007 IS NOT NULL THEN
         SELECT COUNT(1)
           INTO n_count
           FROM AB01
          WHERE aab007 = prm_aab007;         --����ִ��
         IF n_count > 0 THEN
            prm_ErrorMsg := PRE_ERRCODE ||'�Ѿ����ڹ���ִ�պ���Ϊ['|| prm_aab007 ||']����ͬ�ĵ�λ!';
            RETURN;
         END IF;
      END IF;

      IF prm_aab030 IS NOT NULL THEN
         SELECT COUNT(1)
           INTO n_count
           FROM AB01
          WHERE aab030 = prm_aab030;         --˰��
         IF n_count > 0 THEN
            prm_ErrorMsg := PRE_ERRCODE ||'�Ѿ�����˰�ֺ�Ϊ['|| prm_aab030 ||']����ͬ�ĵ�λ!';
            RETURN;
         END IF;
      END IF;
     */
      IF prm_aab003 IS NULL AND prm_aab030 IS NULL THEN
         SELECT COUNT(1)
           INTO n_count
           FROM xasi2.AB01
          WHERE aab001 = prm_iab001;         --�籣������
         IF n_count > 0 THEN
            prm_ErrorMsg := PRE_ERRCODE ||'�Ѿ������籣������Ϊ['|| prm_iab001 ||']����ͬ�ĵ�λ!';
            RETURN;
         END IF;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
      IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
         prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�AAZ002!';
         RETURN;
      END IF;

      v_yae092 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'FRAMEWORK');
      IF v_yae092 IS NULL OR v_yae092 = '' THEN
         prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�FRAMEWORK!';
         RETURN;
      END IF;

      v_yae367 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'DEFAULT');
      IF v_yae367 IS NULL OR v_yae367 = '' THEN
         prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�DEFAULT!';
         RETURN;
      END IF;

      /*
         д���걨��λ��Ϣ��
         ȷ����λ�α����֣�
                 ר��Ա,
                 ˰�ţ�����ִ�գ���֯�������룬��˰�������
      */
      INSERT INTO wsjb.IRAB01
                 (
                  IAB001,
                  IAA002,
                  AAB001,
                  AAB003,
                  AAB004,
                  YAB004,
                  YAB006,
                  AAB007,
                  YAB516,
                  AAB016,
                  AAB019,
                  AAB020,
                  AAB021,
                  AAB022,
                  AAB030,
                  YLB001,
                  YAB136,
                  AAE119,    --2013-03-14 wl ����
                  YAB275,
                  YAB380,
                  YAB028,
                  AAE110,
                  AAE120,
                  AAE210,
                  AAE310,
                  AAE410,
                  AAE510,
                  AAE311,
                  AAE011,
                  AAE036,
                  AAE013,
                  AAZ002,
                  YAB011,
                  YAB534,
                  AAB024,
                  AAB025,
                  AAB026,
                  YAB022
                 )
                 VALUES
                 (
                  prm_iab001,
                  PKG_Constant.IAA002_WIR, --0 ���걨
                  prm_iab001,
                  prm_aab003,
                  prm_aab004,
                  '1',--�¿���
                  prm_yab006,
                  prm_aab003,  --  NULL  20190219 wz
                  prm_yab516,
                  prm_aac003,
                  prm_aab019,
                  prm_aab020,
                  prm_aab021,
                  prm_aab022,
                  prm_aab030,
                  prm_ylb001,
                  prm_yab136,
                  '1',          --2013-03-14 wl ����
                  PKG_Constant.YAB275_QY,
                  '0',
                  prm_yab028,
                  prm_aae110,
                  prm_aae120,
                  prm_aae210,
                  prm_aae310,
                  prm_aae410,
                  prm_aae510,
                  prm_aae311,
                  prm_aae011,
                  SYSDATE,
                  prm_aae013,
                  v_aaz002,
                  '1',
                  prm_yab534,
                  prm_aab024,
                  prm_aab025,
                  prm_aab026,
                  PRM_YAB022
      );

      select   count(*) into temp_count  from  wsjb.IRAB01  where AAB001=prm_iab001;

      IF prm_flag = '1' THEN
         UPDATE wsjb.IRAB01
            SET IAA002 = '2',
                YAB010 = '1',
                YAB011 = '0',
                YAB004 = '2'
          WHERE AAB001 = prm_iab001;
      END if;

      INSERT INTO wsjb.irab03 (
                AAB001,
                YAE010_110,
                YAE010_120,
                YAE010_210,
                YAE010_310,
                YAE010_410,
                YAE010_510,
                YAE010_311,
                AAE011)
         VALUES
              (
                prm_iab001,
                prm_yae010_110,
                prm_yae010_120,
                prm_yae010_210,
                prm_yae010_310,
                prm_yae010_410,
                prm_yae010_510,
                prm_yae010_311,
                prm_aae011
              );


      /*
          �����½�˺ſ���
      */
      INSERT INTO wsjb.ad53a4  (
           yae092,  -- ������Ա���
           yab109,  -- ���ű��
           aac003,  -- ����
           aac004,  -- �Ա�
           yab003,  -- �������
           yae041,  -- ��½��
           yae042,  -- ��½����
           yae361,  -- ������־
           yae362,  -- ����������
           yae363,  -- ���һ�α��ʱ��
           yae114,  -- �����
           aae100,  -- ��Ч��־
           aae011,  -- ������
           aae036   -- ����ʱ��
           )
      VALUES
          (
           v_yae092  ,  -- ������Ա���
           '0101'    ,  -- ���ű��[��λ����]
           prm_aac003,  -- ����
           '9'       ,  -- �Ա�
           prm_yab003,  -- �������
           prm_iab001,  -- ��½��=��λ���=��λ������[Ĭ������ר��Ա���]
           prm_yae042,  -- ��½����
           '0'       ,  -- ������־
           0         ,  -- ����������
           SYSDATE,     -- ���һ�α��ʱ��
           0         ,  -- �����
           '1'       ,  -- ��Ч��־
           prm_aae011,  -- ������
           SYSDATE      -- ����ʱ��
      );

      /*
         ���Ķ�����������Ŀ�� ������Ķ˾�����Ա��������
      */
      INSERT INTO xasi2.ad53a4 (
           yae092,  -- ������Ա���
           yab109,  -- ���ű��
           aac003,  -- ����
           aac004,  -- �Ա�
           yab003,  -- �������
           yae041,  -- ��½��
           yae042,  -- ��½����
           yae361,  -- ������־
           yae362,  -- ����������
           yae363,  -- ���һ�α��ʱ��
           yae114,  -- �����
           aae100,  -- ��Ч��־
           aae011,  -- ������
           aae036   -- ����ʱ��
           )
      VALUES
          (
           v_yae092  ,  -- ������Ա���
           '0101'    ,  -- ���ű��[��λ����]
           prm_aac003,  -- ����
           '9'       ,  -- �Ա�
           prm_yab003,  -- �������
           prm_iab001,  -- ��½��=��λ���=��λ������[Ĭ������ר��Ա���]
           prm_yae042,  -- ��½����
           '0'       ,  -- ������־
           0         ,  -- ����������
           SYSDATE,  -- ���һ�α��ʱ��
           0         ,  -- �����
           '1'       ,  -- ��Ч��־
           prm_aae011,  -- ������
           SYSDATE      -- ����ʱ��
      );


      /*
          Ϊ������Ա��ȨΪ��λ����ĸ�λ
      */
      INSERT INTO  wsjb.AD53A6
                  (
                   yae093,  -- ��ɫ���
                   yab109,  -- ���ű��
                   yae092,  -- ������Ա���
                   aae011,  -- ������
                   aae036   -- ����ʱ��
                  )
           VALUES
                  (
                   '1000000021',  -- ��ɫ���[��λ����]
                   '0101'    ,  -- ���ű��
                   v_yae092  ,  -- ������Ա���
                   prm_aae011,  -- ������
                   SYSDATE      -- ����ʱ��
      );

      /*
         ��¼�û���λ�䶯��־
      */
      INSERT INTO wsjb.ad53a8  (
             yae367,  -- �䶯��ˮ��
             yae093,  -- ��ɫ���
             yab109,  -- ���ű��
             yae092,  -- ������Ա���
             aae011,  -- ������
             aae036,  -- ����ʱ��
             yae369,  -- �޸���
             yae370,  -- �޸�ʱ��
             yae372)  -- Ȩ�ޱ䶯����
      VALUES (
             v_yae367 ,  -- �䶯��ˮ��
             '1000000021',  -- ��ɫ���
             '0101',       -- ���ű��
             v_yae092,    -- ������Ա���
             prm_aae011,  -- ������
             SYSDATE   ,  -- ����ʱ��
             prm_aae011,  -- �޸���
             SYSDATE   ,  -- �޸�ʱ��
             '07'        -- Ȩ�ޱ䶯����
      );

  --��ϵͳ���ߺ�ſ�ע�� 20160325
   -----��������ܵ�¼�ʺ����� start zhujing 20151230
      --���˸�λ���
        SELECT XAGXWT.HIBERNATE_SEQUENCE.NEXTVAL
          INTO var_position
          FROM DUAL;
               --��ҵר��Ա
            IF SUBSTR(prm_iab001,1,2) <> '88' THEN
               INSERT INTO XAGXWT.TAUSER
                            (USERID,
                             NAME,
                             SEX,
                             LOGINID,
                             PASSWORD,
                             PASSWORDFAULTNUM,
                             PWDLASTMODIFYDATE,
                             ISLOCK,
                             SORT,
                             EFFECTIVE,
                             TEL,
                             CREATEUSER,
                             CREATETIME,
                             DIRECTORGID,
                             DESTORY,
                             TYPEFLAG)
                      VALUES
                            (v_yae092,
                             prm_aac003,
                             '0',
                             prm_iab001,
                             prm_yae042,
                             0,
                             NULL,
                             '0',
                             NULL,
                             '0',
                             NULL,
                             '1',
                             SYSDATE,
                             '110052',--��ҵ��λ
                             NULL,
                             NULL);
              --������˸�λ
              INSERT INTO XAGXWT.TAPOSITION
                            (POSITIONID,
                             ORGID,
                             POSITIONNAME,
                             POSITIONTYPE,
                             CREATEPOSITIONID,
                             ORGIDPATH,
                             ORGNAMEPATH,
                             VALIDTIME,
                             CREATEUSER,
                             CREATETIME,
                             EFFECTIVE,
                             ISADMIN,
                             ISSHARE,
                             ISCOPY,
                             POSITIONCATEGORY,
                             TYPEFLAG)
                          VALUES
                            (var_position,
                             '110052',--110055
                             prm_aab004,
                             '2',--���˸�λ
                             '1',
                             '1/110045/110052',--���ݾ�����֯·����д --  '1/110045/110055'
                             '����������/����ҵ��λ/��ҵ��˾',--���ݾ�����֯��д '����������/����ҵ��λ/������ҵ��λ'
                             NULL,
                             '1',
                             SYSDATE,
                             '0',
                             NULL,
                             NULL,
                             NULL,
                             NULL,
                             NULL);
              --���и�λ
              INSERT INTO XAGXWT.TAUSERPOSITION
                (USERID, POSITIONID, MAINPOSITION, CREATEUSER, CREATETIME)
              VALUES
                   (v_yae092,
                    '110066', --��ҵ��˾�µ�һ��ר��Ա��λid
                    '0', --���и�λ
                    '1',
                    SYSDATE);

          END IF;
          --������ҵ��λר��Ա
          IF SUBSTR(prm_iab001,1,2) = '88' THEN
               INSERT INTO XAGXWT.TAUSER
                            (USERID,
                             NAME,
                             SEX,
                             LOGINID,
                             PASSWORD,
                             PASSWORDFAULTNUM,
                             PWDLASTMODIFYDATE,
                             ISLOCK,
                             SORT,
                             EFFECTIVE,
                             TEL,
                             CREATEUSER,
                             CREATETIME,
                             DIRECTORGID,
                             DESTORY,
                             TYPEFLAG)
                      VALUES
                            (v_yae092,
                             prm_aac003,
                             '0',
                             prm_iab001,
                             prm_yae042,
                             0,
                             NULL,
                             '0',
                             NULL,
                             '0',
                             NULL,
                             '1',
                             SYSDATE,
                             '110055',--������ҵ��λ
                             NULL,
                             NULL);

            --������˸�λ
              INSERT INTO XAGXWT.TAPOSITION
                            (POSITIONID,
                             ORGID,
                             POSITIONNAME,
                             POSITIONTYPE,
                             CREATEPOSITIONID,
                             ORGIDPATH,
                             ORGNAMEPATH,
                             VALIDTIME,
                             CREATEUSER,
                             CREATETIME,
                             EFFECTIVE,
                             ISADMIN,
                             ISSHARE,
                             ISCOPY,
                             POSITIONCATEGORY,
                             TYPEFLAG)
                          VALUES
                            (var_position,
                             '110055',--������ҵ��λ
                             prm_aab004,
                             '2',--���˸�λ
                             '1',
                             '1/110045/110055',--���ݾ�����֯·����д --
                             '����������/����ҵ��λ/������ҵ��λ',--���ݾ�����֯��д
                             NULL,
                             '1',
                             SYSDATE,
                             '0',
                             NULL,
                             NULL,
                             NULL,
                             NULL,
                             NULL);
            INSERT INTO XAGXWT.TAUSERPOSITION
                        (USERID, POSITIONID, MAINPOSITION, CREATEUSER, CREATETIME)
                 VALUES
                        (v_yae092,
                         '112605', --'112605'���ص�λר��Ա��λ
                         '0', --���и�λ
                         '1',
                         SYSDATE);
          END IF;
          --���˸�λ
          INSERT INTO XAGXWT.TAUSERPOSITION
            (USERID, POSITIONID, MAINPOSITION, CREATEUSER, CREATETIME)
          VALUES
               (v_yae092,
                var_position,
                '1', --���˸�λ
                v_yae092,
                SYSDATE);

           -----��������ܵ�¼�ʺ����� end

      /*
         д�뵥λר��Ա��Ϣ
      */
      INSERT INTO wsjb.iraa01
                 (
                  AAB001,
                  YAB515,
                  YAB516,
                  AAB016,
                  YAE092,
                  AAZ002,
                  IAB001,
                  AAE011,
                  AAE035,
                  AAE036,
                  YAE043,
                  YAE042,
                  AAE100
                 )
                 VALUES
                 (
                  prm_iab001,
                  '1',
                  prm_yab516,
                  prm_aac003,
                  v_yae092  ,
                  v_aaz002  ,
                  prm_iab001,
                  prm_aae011,
                  sysdate,
                  sysdate,
                  prm_yae043,
                  prm_yae042,
                  '1'
                 );

      v_yae099 := xasi2.PKG_comm.fun_GetSequence(NULL,'yae099');
      IF v_yae099 IS NULL OR v_yae099 = '' THEN
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ��ϵͳ������к�:YAE099';
         RETURN;
      END IF;
      /*
          �籣ϵͳ����¼�� ��λ��Ϣ ��λ������Ϣ
      */
      prc_AuditSocietyInsuranceREmp(v_yae099,
                                    prm_iab001,
                                    prm_aae011,
                                    PKG_Constant.YAB003_JBFZX,
                                    prm_AppCode,
                                    prm_ErrorMsg);
      IF prm_AppCode <> gn_def_OK THEN
         ROLLBACK;
         RETURN;
      END IF;

    --������ƽ����ǰ������λ������
      IF to_char(sysdate,'MMdd') < '0715' THEN
        insert into xasi2.ab05 values(prm_iab001,to_number(to_char(sysdate,'yyyy')),'03',null,null,null,'1000000121');
      END if;

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
                  AAE218,
                  AAE013
                 )
                 VALUES
                 (
                  v_aaz002,
                  PKG_Constant.AAA121_NER,
                  prm_aae011,
                  prm_yab003,
                  prm_aae011,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate,
                  prm_aae013
                 );
   EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'||PRE_ERRCODE || SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;
   END prc_AddNewEmpReg;



   /*****************************************************************************
   ** �������� : prc_AddApplyInfo
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����ᱣ�յǼ�
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_iaz008       IN     irad02.iaz008%TYPE,--�걨������
   **           prm_iad003       IN     irad02.iad003%TYPE,--�걨��������
   **           prm_aae013       IN     irad02.aae013%TYPE,--��ע
   **           prm_aac001       IN     irad02.aac001%TYPE,--�걨��
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-12   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_AddApplyInfo (
      prm_iaz008       IN     irad02.iaz008%TYPE,--�걨������
      prm_iad003       IN     irad02.iad003%TYPE,--�걨��������
      prm_aae013       IN     irad02.aae013%TYPE,--��ע
      prm_aac001       IN     irad02.aac001%TYPE,--�걨��
      prm_flag      IN     VARCHAR2          ,
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      n_count    number(2);
      v_iaz004   varchar2(15);
      v_iaz005   varchar2(15);
      v_iaz006   varchar2(15);
      v_aaz002   varchar2(15);
      v_iaa004   number(1);
      v_aac001   varchar2(15);
      v_aac003   varchar2(60);
      v_iac001   varchar2(15);
      v_iaz008   varchar2(15);
      v_iaz003 IRAD03.iaz003%TYPE;
      v_iaa013 IRAD03.iaa013%TYPE;
      cursor c_cur is SELECT iac001,aac001,aac003,iaa002 From wsjb.irac01  WHERE aab001 = prm_iaz008 and iaa001 in (PKG_Constant.IAA001_ADD,PKG_Constant.IAA001_PAD) and (iaa002 = PKG_Constant.IAA002_WIR or iaa002 = PKG_Constant.IAA002_NPS);

   BEGIN
      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count := 0;

      /*��Ҫ������У��*/
      IF prm_iaz008 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λ�����벻��Ϊ��!';
         RETURN;
      END IF;

      IF prm_aac001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := 'ר��Ա��Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_iad003 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�걨�������Ʋ���Ϊ��!';
         RETURN;
      END IF;


      --�Ƿ�����걨��λ��Ϣ
      IF prm_flag = '0' THEN
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAB01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and b.aaa121 = PKG_Constant.AAA121_NER and a.aab001 = prm_iaz008 and (a.iaa002 = PKG_Constant.IAA002_AIR or a.iaa002 = PKG_Constant.IAA002_APS);
      IF n_count > 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '��λ���Ϊ['|| prm_iaz008 ||']�ĵ�λ�걨��Ϣ�Ѵ���!';
            RETURN;
      END IF;
      END IF;

      --�Ƿ���ڵ�λ��Ϣ
      IF prm_flag = '0' THEN
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAB01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and a.aab001 = prm_iaz008 and (a.iaa002 = PKG_Constant.IAA002_WIR OR a.iaa002 = PKG_Constant.IAA002_NPS) and b.aaa121 = PKG_Constant.AAA121_NER;
      IF n_count = 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '��λ���Ϊ['|| prm_iaz008 ||']�ĵ�λ������!';
            RETURN;
      END IF;
      END IF;

      /*�Ƿ���ڴ��걨��Ա
      SELECT COUNT(1)
           into n_count
           FROM IRAB01 a,AE02 b
          WHERE a.aaz002 = b.aaz002 and a.aab001 = prm_iaz008 and a.iaa002 = PKG_Constant.IAA002_NPS and b.aaa121 = PKG_Constant.AAA121_NER;
      IF n_count = 0 THEN
        SELECT COUNT(1)
           into n_count
           FROM IRAC01
          WHERE aab001 = prm_iaz008 AND (iaa002 = PKG_Constant.IAA002_WIR OR iaa002 = PKG_Constant.IAA002_NPS);
        IF n_count = 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '��λ������Ϊ['|| prm_iaz008 ||']�ĵ�λû�д��걨��Ա!';
            RETURN;
        END IF;
      END IF;
      */

      --�Ƿ������ͬ����˼���
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAA02
          WHERE iaa011 = PKG_Constant.IAA011_SIR
          AND iaa005 = PKG_Constant.IAA005_YES;
      IF n_count > 1 THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'ϵͳ��˼�����Ϣ����!����ϵά����Ա';
            RETURN;
      END IF;



      /*��ȡ������Ϣ*/

      v_iaz005 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');
      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');

      BEGIN
      SELECT iaa004
           into v_iaa004
           FROM wsjb.IRAA02
          WHERE iaa011 = PKG_Constant.IAA011_SIR
          AND iaa005 = PKG_Constant.IAA005_YES;

      SELECT iab001
           into v_iaz008
           FROM wsjb.IRAB01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and b.aaa121 = PKG_Constant.AAA121_NER and a.aab001 = prm_iaz008 ;
      EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ������Ϣ:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;
      END;



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
                  AAE218,
                  AAE013
                 )
                 VALUES
                 (
                  v_aaz002,
                  PKG_Constant.AAA121_SIR,
                  prm_aac001,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aac001,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate,
                  prm_aae013
                 );

      /*��ȡ������Ϣ��д��IRAD01�걨�¼���*/
      --�Ƿ�������
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAD01  a,wsjb.IRAD02  b
          WHERE a.iaz004 = b.iaz004
          AND b.iaz008 = prm_iaz008
          AND b.iaa020 = PKG_Constant.IAA020_DW
          AND a.iaa011 = PKG_Constant.IAA011_SIR;

      IF n_count = 0 THEN

         v_iaz004 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ004');

         INSERT INTO wsjb.IRAD01
                 (
                  iaz004,
                  aaz002,
                  iaa011,
                  aae011,
                  aae035,
                  aab001,
                  yab003,
                  aae013,
                  iaa100
                 )
                 VALUES
                 (
                  v_iaz004,
                  v_aaz002,
                  PKG_Constant.IAA011_SIR,
                  prm_aac001,
                  sysdate,
                  prm_iaz008,
                  PKG_Constant.YAB003_JBFZX,
                  nvl(prm_aae013,'��'),
                  to_number(to_char(sysdate,'yyyymm'))
                 );

                  --д��IRAD02�걨��ϸ��

           INSERT INTO wsjb.IRAD02
                 (
                  iaz005,
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
                 )
                 VALUES
                 (
                  v_iaz005,
                  v_iaz005,
                  v_iaz004,
                  v_iaz008,
                  prm_iaz008,
                  prm_iad003,
                  prm_aac001,
                  sysdate,
                  PKG_Constant.YAB003_JBFZX,
                  v_iaa004,
                  0,
                  PKG_Constant.IAA015_WAD,
                  PKG_Constant.IAA016_DIR_NO,
                  nvl(prm_aae013,'��'),
                  PKG_Constant.IAA020_DW
                 );

        v_iaz003 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ003');
        v_iaa013 := PKG_COMMON.fun_cbbh('DWKH',PKG_Constant.YAB003_JBFZX);
       --�����걨�������
         INSERT INTO wsjb.IRAD03
                     (
                      iaz003 ,
                      iaz004 ,
                      iaa011 ,
                      iaa013 ,
                      aae035 ,
                      yae092 ,
                      yab003 ,
                      aae013 ,
                      aae120
                     )
                     VALUES
                     (
                      v_iaz003,
                      v_iaz004,
                      PKG_Constant.IAA011_SIR,
                      v_iaa013,
                      sysdate,
                      prm_aac001,
                      PKG_Constant.YAB003_JBFZX,
                      nvl(prm_aae013,''),
                      '0'
                     );

                 --�����걨��λ��Ϣ
                      UPDATE wsjb.IRAB01   SET
                          iaa002 = PKG_Constant.IAA002_AIR
                      WHERE
                          iab001 = v_iaz008;

      ELSIF n_count > 0 THEN

          SELECT DISTINCT a.iaz004
           into v_iaz004
           FROM wsjb.IRAD01  a,wsjb.IRAD02  b
          WHERE a.iaz004 = b.iaz004
          AND b.iaz008 = prm_iaz008
          AND b.iaa020 = PKG_Constant.IAA020_DW
          AND a.iaa011 = PKG_Constant.AAA121_SIR;

          UPDATE wsjb.IRAD01
             SET aae035 = sysdate
           WHERE iaz004 = v_iaz004;

          SELECT max(iaz005) into v_iaz006 FROM wsjb.IRAD02  a WHERE a.iaa020 = PKG_Constant.IAA020_DW AND a.iaz008 = prm_iaz008;

                  SELECT COUNT(1)
                       into n_count
                       FROM wsjb.IRAB01
                       WHERE iab001 = v_iaz008 AND iaa002 = PKG_Constant.IAA002_APS;
                  IF n_count = 0 THEN
                    --�����걨��λ��Ϣ
                      UPDATE wsjb.IRAB01   SET
                          iaa002 = PKG_Constant.IAA002_AIR
                      WHERE
                          iab001 = v_iaz008;
                  ELSIF n_count > 1 THEN
                     ROLLBACK;
                     prm_AppCode  :=  gn_def_ERR;
                     prm_ErrorMsg := '��λ�걨��Ϣ����!����ϵά����Ա';
                     RETURN;
                  END IF;

                  SELECT COUNT(1)
                  into n_count
                  FROM wsjb.IRAB01  a
                  WHERE a.aab001 = prm_iaz008 AND a.iaa002 = PKG_Constant.IAA002_APS;
                  IF n_count = 0 THEN
                      --д��IRAD02�걨��ϸ��

                  INSERT INTO wsjb.IRAD02
                 (
                  iaz005,
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
                 )
                 VALUES
                 (
                  v_iaz005,
                  v_iaz006,
                  v_iaz004,
                  v_iaz008,
                  prm_iaz008,
                  prm_iad003,
                  prm_aac001,
                  sysdate,
                  PKG_Constant.YAB003_JBFZX,
                  v_iaa004,
                  0,
                  PKG_Constant.IAA015_WAD,
                  PKG_Constant.IAA016_DIR_NO,
                  nvl(prm_aae013,'��'),
                  PKG_Constant.IAA020_DW
                 );
                  END IF;


      END IF;


      /* --д�뵥λ����Ա��Ϣ�걨��ϸ

       FOR cur_result in c_cur LOOP

             v_aac001 := cur_result.aac001;
             v_aac003 := cur_result.aac003;
             v_iac001 := cur_result.iac001;
             v_iaz005 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');

             select nvl(max(iaz005),v_iaz005) into v_iaz006 from irad02 where iaz007 = v_iac001;

             IF v_aac001 IS NULL THEN
                 goto con_null;
             END IF;

             --������Ա�걨��ϸ
             INSERT INTO IRAD02
                 (
                  iaz005,
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
                 )
                 VALUES
                 (
                  v_iaz005,
                  v_iaz006,
                  v_iaz004,
                  v_iac001,
                  v_aac001,
                  v_aac003,
                  prm_aac001,
                  sysdate,
                  PKG_Constant.YAB003_JBFZX,
                  v_iaa004,
                  0,
                  PKG_Constant.IAA015_WAD,
                  PKG_Constant.IAA016_DIR_NO,
                  null,
                  PKG_Constant.IAA020_GR
                 );

                 --������Ա�걨״̬
                 UPDATE  IRAC01  SET
                     iaa002 = PKG_Constant.IAA002_AIR
                 WHERE
                     iac001 = v_iac001;

                 <<con_null>>
                 null;
      END LOOP;
*/


      EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;

   END prc_AddApplyInfo;

   /*****************************************************************************
   ** �������� : prc_UnitBaseInfoMaintain
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����λ������Ϣά��
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
      prm_aab001       IN     irab01.aab001%TYPE, --��λ���
      prm_aab004       IN     irab01.aab004%TYPE, --��λ����
      prm_aab005       IN     irab01.aab005%TYPE, --��λ�绰
      prm_aab006       IN     irab01.aab006%TYPE, --���̵Ǽ�ִ������
      prm_aab007       IN     irab01.aab007%TYPE, --���̵Ǽ�ִ�պ���
      prm_yab519       IN     irab01.yab519%TYPE, --��λ��������
      prm_aae014       IN     irab01.aae014%TYPE, --����
      prm_aae007       IN     irab01.aae007%TYPE, --��������
      prm_aab020       IN     irab01.aab020%TYPE, --���óɷ�
      prm_aab021       IN     irab01.aab021%TYPE, --������ϵ
      prm_yab007       IN     irab01.yab007%TYPE, --���̵Ǽǵ�
      prm_yab005       IN     irab01.yab005%TYPE, --��˰�����
      prm_aab030       IN     irab01.aab030%TYPE, --˰��
      prm_yab534       IN     irab01.yab534%TYPE, --�����������
      prm_aab024       IN     irab01.aab024%TYPE, --��������
      prm_aab025       IN     irab01.aab025%TYPE, --���л���
      prm_aab026       IN     irab01.aab026%TYPE, --���п����˺�
      prm_yab389       IN     irab01.yab389%TYPE, --�����ֻ���
      prm_aab015       IN     irab01.aab015%TYPE, --���˰칫�绰
      prm_aae011       IN     irad01.aae011%TYPE, --������
      prm_aae013       IN     irad01.aae013%TYPE, --��ע
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2013-01-21   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_UnitBaseInfoMaintain (
      prm_aab001       IN     irab01.aab001%TYPE, --��λ���
      prm_aab004       IN     irab01.aab004%TYPE, --��λ����
      prm_aab005       IN     irab01.aab005%TYPE, --��λ�绰
      prm_yab519       IN     irab01.yab519%TYPE, --��λ��������
      prm_aae014       IN     irab01.aae014%TYPE, --����
      prm_aae007       IN     irab01.aae007%TYPE, --��������
      prm_aae006       IN     irab01.aae006%TYPE, --��ַ
      prm_aab013       IN     irab01.aab013%TYPE, --�������� 1
      prm_yab388       IN     irab01.yab388%TYPE, --����֤���� 1
      prm_yab389       IN     irab01.yab389%TYPE, --�����ֻ���
      prm_aab015       IN     irab01.aab015%TYPE, --���˰칫�绰
      prm_yab007       IN     irab01.yab007%TYPE, --���̵Ǽǵ�
      prm_aab006       IN     irab01.aab006%TYPE, --���̵Ǽ�ִ������
      prm_aab007       IN     irab01.aab007%TYPE, --���̵Ǽ�ִ�պ���
      prm_yab005       IN     irab01.yab005%TYPE, --��˰�����
      prm_yab028       IN     irab01.yab028%TYPE, --��˰�������  1
      prm_yab006       IN     irab01.yab006%TYPE, --˰�����   1
      prm_aab030       IN     irab01.aab030%TYPE, --˰��
      prm_aae011       IN     irad01.aae011%TYPE, --������
      --prm_aab020       IN     irab01.aab020%TYPE, --���óɷ�
      --prm_aab021       IN     irab01.aab021%TYPE, --������ϵ
      --prm_yab534       IN     irab01.yab534%TYPE, --�����������
      --prm_aab024       IN     irab01.aab024%TYPE, --��������
      --prm_aab025       IN     irab01.aab025%TYPE, --���л���
      --prm_aab026       IN     irab01.aab026%TYPE, --���п����˺�
      --prm_aae013       IN     irad01.aae013%TYPE, --��ע
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )

      IS
      n_count    number(5);
      v_aae007   number(20);
      v_aaz002   varchar2(15);   --ҵ����־id
      v_iab001   varchar2(15);
      v_iaz012   varchar2(15);  --��ʷ�޸��¼�ID
      v_iaz013   varchar2(15);  -- ��ʷ�޸���ϸID
      v_iaz004   varchar2(15);  --�걨[����]�¼�ID
      v_iaz005   varchar2(15);  --�걨��ϸID
      v_iaz009   varchar2(15);  --���[����]�¼�ID
      v_iaz010   varchar2(15);  --�����ϸID
      col_type   varchar2(106);
      v_varchar  varchar2(1000);
      v_number   number(20);
      v_date     date;
      v_comments varchar2(200);
      t_cols     tab_change;
      v_sql      varchar2(200);
      v_name     varchar2(50);
      v_value    varchar2(1000);

      BEGIN
        prm_AppCode  := PKG_Constant.GN_DEF_OK;
        prm_ErrorMsg := '';

        /*����У��*/
       IF prm_aab001 IS NULL THEN
           prm_ErrorMsg := '��λ��Ų���Ϊ��!';
           RETURN;
        END IF;

       IF prm_aab005 IS NULL THEN
           prm_ErrorMsg := '��λ�칫�ҵ绰����Ϊ��!';
           RETURN;
        END IF;

        IF prm_aae007 IS NULL THEN
           prm_ErrorMsg := '�������벻��Ϊ��!';
           RETURN;
        END IF;

        IF prm_aae006 IS NULL THEN
           prm_ErrorMsg := '��ַ����Ϊ��!';
           RETURN;
        END IF;

       IF prm_aab013 IS NULL THEN
           prm_ErrorMsg := '���˴�����������Ϊ��!';
           RETURN;
       END IF;

       IF prm_yab388 IS NULL THEN
           prm_ErrorMsg := '���˴���֤����Ų���Ϊ��!';
           RETURN;
       END IF;

       IF prm_yab007 IS NULL THEN
           prm_ErrorMsg := '���̵Ǽǵز���Ϊ��!';
           RETURN;
       END IF;

       IF prm_aab006 IS NULL THEN
           prm_ErrorMsg := '����ִ�����Ͳ���Ϊ��!';
           RETURN;
        END IF;

       IF prm_aab007 IS NULL THEN
           prm_ErrorMsg := '����ִ�պ��벻��Ϊ��!';
           RETURN;
        END IF;

 --       IF prm_aab020 IS NULL THEN
 --          prm_ErrorMsg := '���óɷֲ���Ϊ��!';
 --          RETURN;
 --       END IF;

 --       IF prm_aab021 IS NULL THEN
 --          prm_ErrorMsg := '������ϵ����Ϊ��!';
 --          RETURN;
 --       END IF;

        IF prm_yab005 IS NULL THEN
           prm_ErrorMsg := '��˰����Ʋ���Ϊ��!';
           RETURN;
        END IF;

          IF prm_yab028 IS NULL THEN
           prm_ErrorMsg := '��˰�����벻��Ϊ��!';
           RETURN;
        END IF;

         IF prm_yab005 IS NULL THEN
           prm_ErrorMsg := '˰���������Ϊ��!';
           RETURN;
        END IF;

        IF prm_aab030 IS NULL THEN
           prm_ErrorMsg := '˰�ֺŲ���Ϊ��!';
           RETURN;
        END IF;

 --      IF prm_yab534 IS NULL THEN
 --          prm_ErrorMsg := '�������������Ϊ��!';
 --          RETURN;
 --       END IF;

 --       IF prm_aab024 IS NULL THEN
 --         prm_ErrorMsg := '�������в���Ϊ��!';
 --          RETURN;
 --       END IF;

 --       IF prm_aab025 IS NULL THEN
 --          prm_ErrorMsg := '���л�������Ϊ��!';
 --          RETURN;
 --       END IF;

  --      IF prm_aab026 IS NULL THEN
  --         prm_ErrorMsg := '���п����˺Ų���Ϊ��!';
  --         RETURN;
  --      END IF;

        --�Ƿ����AB01��λ��Ϣ
        SELECT COUNT(1)
          INTO n_count
          FROM xasi2.AB01
         WHERE aab001 = prm_aab001;
        IF n_count = 0 THEN
            prm_ErrorMsg := '��λ���Ϊ['|| prm_aab001 ||']�ĵ�λ��Ϣ������!';
            RETURN;
        END IF;


        --�������Ž���¼��
      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB001';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aab001;

     t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB004';
     t_cols(t_cols.COUNT).COL_VALUE := prm_aab004;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB005';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aab005;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB006';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aab006;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB007';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aab007;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB519';
      t_cols(t_cols.COUNT).COL_VALUE := prm_yab519;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE014';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aae014;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE007';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aae007;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB020';
--     t_cols(t_cols.COUNT).COL_VALUE := prm_aab020;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB021';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_aab021;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB007';
      t_cols(t_cols.COUNT).COL_VALUE := prm_yab007;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB005';
      t_cols(t_cols.COUNT).COL_VALUE := prm_yab005;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB030';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aab030;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB534';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_yab534;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB024';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_aab024;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB025';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_aab025;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB026';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_aab026;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB389';
      t_cols(t_cols.COUNT).COL_VALUE := prm_yab389;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB015';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aab015;



      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE006';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aae006;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB013';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aab013;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB388';
      t_cols(t_cols.COUNT).COL_VALUE := prm_yab388;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB028';
      t_cols(t_cols.COUNT).COL_VALUE := prm_yab028;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB006';
      t_cols(t_cols.COUNT).COL_VALUE := prm_yab006;



       --������־��¼
      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
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
                  AAE218,
                  AAE013
                 )
                 VALUES
                 (
                  v_aaz002,
                  PKG_Constant.AAA121_EDI,
                  prm_aae011,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae011,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate,
                  '��' --nvl('��',prm_aae013)
                 );

      --�걨�¼���irad01
      v_iaz004 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ004');
      INSERT INTO wsjb.IRAD01
                 (
                 iaz004,
                 aaz002,
                 iaa011,
                 aae011,
                 aae035,
                 aab001,
                 yab003,
                 aae013,
                 iaa100
                 )
                 VALUES
                 (
                  v_iaz004,
                  v_aaz002,
                  PKG_Constant.IAA011_EDI,
                  prm_aae011,
                  sysdate,
                  prm_aab001,
                  PKG_Constant.YAB003_JBFZX,
                  '��', --prm_aae013,
                  to_number(to_char(sysdate,'yyyymm'))
                 );

       --�걨��ϸ��irad02
       v_iaz005 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');
       INSERT INTO wsjb.IRAD02
                (
                 iaz005,
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
                ) VALUES (
                 v_iaz005,
                 v_iaz005,
                 v_iaz004,
                 prm_aab001,
                 prm_aab001,
                 prm_aab004,
                 prm_aae011,
                 sysdate,
                 PKG_Constant.YAB003_JBFZX,
                 '0',
                 '0',
                 PKG_Constant.IAA015_ADO,
                 PKG_Constant.IAA016_DIR_NO,
                 '��', --prm_aae013,
                 PKG_Constant.IAA020_DW
                );

       --��ʷ�޸��¼�
      v_iaz012 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ012');
      INSERT INTO IRAD31
                 (
                  iaz012,
                  aaz002,
                  iaz007,
                  aae011,
                  aae035,
                  aab001,
                  yab003,
                  iaa019,
                  iaa011,
                  aae013
                 )
                 VALUES
                 (
                  v_iaz012,
                  v_aaz002,
                  prm_aab001,
                  prm_aae011,
                  sysdate,
                  prm_aab001,
                  PKG_Constant.YAB003_JBFZX,
                  PKG_Constant.IAA019_AD,
                  PKG_Constant.IAA011_EDI,
                  '��' --nvl('��',prm_aae013)
                 );
      --��ʷ�޸���ϸ

    FOR i in 1 .. t_cols.count LOOP

        v_name := t_cols(i).COL_NAME;
        v_value := t_cols(i).COL_VALUE;

        BEGIN

         SELECT COMMENTS INTO v_comments FROM USER_COL_COMMENTS where TABLE_NAME = 'IRAB01' and COLUMN_NAME = v_name;

         SELECT DATA_TYPE INTO col_type FROM USER_TAB_COLUMNS where TABLE_NAME = 'IRAB01' and COLUMN_NAME = v_name;

        EXCEPTION
          -- WHEN NO_DATA_FOUND THEN
          -- WHEN TOO_MANY_ROWS THEN
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
           /*�رմ򿪵��α�*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'IRAB01����û�� '|| v_name ||'�ֶ�'|| SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;

        END;
     IF v_name = 'YAB005' THEN
           v_sql := 'SELECT '||v_name||' FROM wsjb.IRAB01  where IAB001 = AAB001 AND AAB001 = '''||prm_aab001||'''';
     ELSIF v_name = 'YAB028' THEN
           v_sql := 'SELECT '||v_name||' FROM xasi2.AB01A7 where AAB001 = '''||prm_aab001||'''';
     ELSIF v_name = 'YAB006' THEN
           v_sql := 'SELECT max(a.YAB006) FROM wsjb.IRAB01  a,wsjb.AE02  b where a.aaz002 = b.aaz002 and b.aaa121 = '''||PKG_Constant.AAA121_NER||''' and a.AAB001 = '''||prm_aab001||'''';
     ELSIF v_name = 'YAB007' THEN
           v_sql := 'SELECT YAB007 FROM wsjb.IRAB01  where IAB001 = AAB001 AND AAB001 = '''||prm_aab001||'''';
     ELSIF v_name = 'YAB534' THEN
           v_sql := 'SELECT YAB534 FROM wsjb.IRAB01  where IAB001 = AAB001 AND AAB001 = '''||prm_aab001||'''';
     ELSIF v_name = 'AAB024' THEN
           v_sql := 'SELECT AAB024 FROM wsjb.IRAB01  where IAB001 = AAB001 AND AAB001 = '''||prm_aab001||'''';
     ELSIF v_name = 'AAB025' THEN
           v_sql := 'SELECT AAB025 FROM wsjb.IRAB01  where IAB001 = AAB001 AND AAB001 = '''||prm_aab001||'''';
     ELSIF v_name = 'AAB026' THEN
           v_sql := 'SELECT AAB026 FROM wsjb.IRAB01  where IAB001 = AAB001 AND AAB001 = '''||prm_aab001||'''';
     ELSIF col_type IN ('CHAR', 'VARCHAR', 'VARCHAR2') THEN
           v_sql := 'SELECT '||v_name||' FROM xasi2.AB01 where AAB001 = '''||prm_aab001||'''';
     ELSIF col_type IN ('NUMBER', 'INTEGER', 'FLOAT') THEN
           IF v_value = -1 THEN
              v_value := null;
           END IF;
           v_sql := 'SELECT to_char(nvl('||v_name||','''')) FROM AB01 where AAB001 = '''||prm_aab001||'''';
     ELSIF col_type IN ('DATE') THEN
           v_value := to_char(v_value,'yyyy-mm-dd');
           v_sql := 'SELECT decode(null,null,to_char(' || v_name ||
                                          ',''yyyy-mm-dd''))' || ' FROM AB01 where AAB001 = '''||prm_aab001||'''';
      ELSE
           ROLLBACK;
           prm_AppCode  := Pkg_Constant.GN_DEF_ERR;
           prm_ErrorMsg := '��' || 'AB01' || '�ֶ�' || UPPER(v_name) || '����������Ϊ' ||
                           col_type || '�����ܴ���' ;
           RETURN;
       END IF;

        EXECUTE IMMEDIATE v_sql
                        INTO v_varchar;
                    v_varchar := nvl(v_varchar, '');

         IF nvl(TRIM(v_varchar), '@*yinhai#^%@') != nvl(TRIM(v_value), '@*yinhai#^%@') THEN

           v_iaz013 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ013');
           IF Prm_Appcode != pkg_constant.GN_DEF_OK THEN
               ROLLBACK;
               RETURN;
           END IF;


          --ѭ������
           INSERT INTO IRAD32
                     (
                      iaz013,
                      iaz012,
                      iaz008,
                      iad004,
                      iad006,
                      iad007,
                      iad008,
                      iad009,
                      aae011,
                      aae035,
                      aab001,
                      yab003,
                      aae013,
                      aae100
                     ) VALUES
                     (
                       v_iaz013,
                       v_iaz012,
                       prm_aab001,
                       decode(v_name,'YAB007','IRAB01','YAB005','IRAB01','YAB534','IRAB01','AAB024','IRAB01','AAB025','IRAB01','AAB026','IRAB01','AB01'),
                       v_name,
                       v_comments,
                       v_varchar,
                       v_value,
                       prm_aae011,
                       sysdate,
                       prm_aab001,
                       PKG_Constant.YAB003_JBFZX,
                       '��', --prm_aae013,
                       '1'
                     );
         END IF;
      END LOOP;

      --��������¼�irad21
      v_iaz009 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ009');

      INSERT INTO wsjb.IRAD21
                  (
                  IAZ009,
                  AAZ002,
                  IAA011,
                  AEE011,
                  AAE035,
                  YAB003,
                  AAE013
                  )
                  VALUES
                  (
                  v_iaz009,
                  v_aaz002,
                  'A12_',
                  prm_aae011,
                  sysdate,
                  PKG_Constant.YAB003_JBFZX,
                  '��' --prm_aae013
                  );
     --����irab01�е��ֶ�
     UPDATE wsjb.IRAB01
        SET aab005 = prm_aab005, --��λ�绰
            aab006 = prm_aab006, --���̵Ǽ�ִ������
            aab007 = prm_aab007, --���̵Ǽ�ִ�պ���
            yab519 = prm_yab519, --��λ��������
            aae014 = prm_aae014, --����
            aae007 = prm_aae007, --��������
            --aab020 = prm_aab020, --���óɷ�
            --aab021 = prm_aab021, --������ϵ
            yab007 = prm_yab007, --���̵Ǽǵ�
            yab005 = prm_yab005, --��˰�����
            aab030 = prm_aab030,  --˰��
            --yab534 = prm_yab534,
            --aab024 = prm_aab024,
            --aab025 = prm_aab025,
            --aab026 = prm_aab026,
            yab389 = prm_yab389,
            aab015 = prm_aab015,
            aae006 = prm_aae006,  --��ַ
            aab013 = prm_aab013,  --��������
            yab388 = prm_yab388,  --����֤����
            yab028 = prm_yab028,  --��˰�������
            yab006 = prm_yab006  --˰�����
      WHERE aab001 = iab001 and aab001 = prm_aab001;

      --����ab01�е��ֶ�
      UPDATE xasi2.ab01
        SET aab005 = prm_aab005, --��λ�绰
            aab006 = prm_aab006, --���̵Ǽ�ִ������
            aab007 = prm_aab007, --���̵Ǽ�ִ�պ���
            yab519 = prm_yab519, --��λ��������
            aae014 = prm_aae014, --����
            aae007 = prm_aae007, --��������
            --aab020 = prm_aab020, --���óɷ�
            --aab021 = prm_aab021, --������ϵ
            aab030 = prm_aab030,  --˰��
            yab389 = prm_yab389,--�����ֻ���
            aab015 = prm_aab015, --���˰칫�绰
            aae006 = prm_aae006,  --��ַ
            aab013 = prm_aab013,  --��������
            yab388 = prm_yab388 --����֤����
       WHERE aab001 = prm_aab001;

      --�����ϸд��irad22
      v_iaz010 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ010');

         INSERT INTO wsjb.IRAD22
                    (
                     IAZ010,
                     IAZ011,
                     IAZ009,
                     IAZ005,
                     IAA004,
                     IAA014,
                     IAA017,
                     AAE011,
                     AAE035,
                     YAB003,
                     IAA018,
                     AAE013
                     )
                    VALUES
                    (
                     v_iaz010,
                     v_iaz010,
                     v_iaz009,
                     v_iaz005,
                     '0',
                     '0',
                     '0',
                     prm_aae011,
                     sysdate,
                     PKG_Constant.YAB003_JBFZX,
                     '1',
                     '��' --prm_aae013
                     );

      EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;

     END prc_UnitBaseInfoMaintain;
   /*****************************************************************************
   ** �������� : prc_UnitInfoMaintain
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����λ��Ϣά��
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_iab001       IN     irab01.iab001%TYPE,
   **           prm_aab001       IN     irab01.aab001%TYPE,
   **           prm_aab003       IN     irab01.aab003%TYPE,
   **           prm_aab022       IN     irab01.aab022%TYPE,
   **           prm_aab004       IN     irab01.aab004%TYPE,
   **           prm_aab005       IN     irab01.aab005%TYPE,
   **           prm_aae006       IN     irab01.aae006%TYPE,
   **           prm_aae007       IN     irab01.aae007%TYPE,
   **           prm_yab519       IN     irab01.yab519%TYPE,
   **           prm_aae014       IN     irab01.aae014%TYPE,
   **           prm_aab019       IN     irab01.aab019%TYPE,
   **           prm_aab020       IN     irab01.aab020%TYPE,
   **           prm_ylb001       IN     irab01.ylb001%TYPE,
   **           prm_aab021       IN     irab01.aab021%TYPE,
   **           prm_yab275       IN     irab01.yab275%TYPE,
   **           prm_aab023       IN     irab01.aab023%TYPE,
   **           prm_yae225       IN     irab01.yae225%TYPE,
   **           prm_yab518       IN     irab01.yab518%TYPE,
   **           prm_aae013       IN     irab01.aae013%TYPE,
   **           prm_yab391       IN     irab01.yab391%TYPE,
   **           prm_yab388       IN     irab01.yab388%TYPE,
   **           prm_aab013       IN     irab01.aab013%TYPE,
   **           prm_yab389       IN     irab01.yab389%TYPE,
   **           prm_aab015       IN     irab01.aab015%TYPE,
   **           prm_yab515       IN     irab01.yab515%TYPE,
   **           prm_yab516       IN     irab01.yab516%TYPE,
   **           prm_aab016       IN     irab01.aab016%TYPE,
   **           prm_yab237       IN     irab01.yab237%TYPE,
   **           prm_yab390       IN     irab01.yab390%TYPE,
   **           prm_yab517       IN     irab01.yab517%TYPE,
   **           prm_aab018       IN     irab01.aab018%TYPE,
   **           prm_aaf020       IN     irab01.aaf020%TYPE,
   **           prm_yab028       IN     irab01.yab028%TYPE,
   **           prm_aab030       IN     irab01.aab030%TYPE,
   **           prm_aae011       IN     irab01.aae011%TYPE,
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-21   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_UnitInfoMaintain (
      prm_aab001       IN     irab01.aab001%TYPE,
      prm_aab004       IN     irab01.aab004%TYPE,
      prm_yab009       IN     irab01.yab009%TYPE,
      prm_aab024       IN     irab01.aab024%TYPE,
      prm_aab025       IN     irab01.aab025%TYPE,
      prm_aab026       IN     irab01.aab026%TYPE,
      prm_yab534       IN     irab01.yab534%TYPE,
      prm_aae011       IN     irab01.aae011%TYPE,
      prm_AppCode   OUT    VARCHAR2,
      prm_ErrorMsg   OUT    VARCHAR2)

    IS
      n_count    number(5);
      v_aae007   number(20);
      v_aaz002   varchar2(15);
      v_iab001   varchar2(15);
      v_iaz012   varchar2(15);
      v_iaz013   varchar2(15);
      v_iaz004   varchar2(15);
      v_iaz005   varchar2(15);
      col_type   varchar2(106);
      v_varchar  varchar2(3000);
      v_number   number(20);
      v_date     date;
      v_comments varchar2(2000);
      t_cols     tab_change;
      v_sql      varchar2(3000);
      v_name     varchar2(100);
      v_value    varchar2(3000);
      v_iaa004   number(1);
      v_iaz006   varchar2(15);
    BEGIN

        prm_AppCode  := PKG_Constant.GN_DEF_OK;
        prm_ErrorMsg := '';

      /*��Ҫ������У��*/


      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '��λ�����벻��Ϊ��!';
         RETURN;
      END IF;

      IF prm_aab004 IS NULL THEN
         prm_ErrorMsg := '��λ���Ʋ���Ϊ��!';
         RETURN;
      END IF;

 --     IF prm_aab022 IS NULL THEN
 --        prm_ErrorMsg := '��λ��ҵ����Ϊ��!';
 --       RETURN;
 --     END IF;

 --    IF prm_aab019 IS NULL THEN
 --       prm_ErrorMsg := '��λ���Ͳ���Ϊ��!';
 --       RETURN;
 --    END IF;

 --     IF prm_ylb001 IS NULL THEN
 --        prm_ErrorMsg := '��λ������ҵ�ȼ�����Ϊ��!';
 --        RETURN;
 --     END IF;

 --     IF prm_aab021 IS NULL THEN
 --        prm_ErrorMsg := '��λ������ϵ����Ϊ��!';
 --        RETURN;
 --     END IF;

 --     IF prm_yab391 IS NULL THEN
 --        prm_ErrorMsg := '����֤�����Ͳ���Ϊ��!';
 --        RETURN;
 --     END IF;

 --     IF prm_yab388 IS NULL THEN
 --        prm_ErrorMsg := '����֤�����벻��Ϊ��!';
 --        RETURN;
 --     END IF;

 --     IF prm_yab389 IS NULL THEN
 --        prm_ErrorMsg := '�����ֻ����벻��Ϊ��!';
 --        RETURN;
 --     END IF;

 --     IF prm_aab013 IS NULL THEN
 --        prm_ErrorMsg := '������������Ϊ��!';
 --        RETURN;
 --     END IF;

 --     IF prm_aab015 IS NULL THEN
 --        prm_ErrorMsg := '���˰칫�绰����Ϊ��!';
 --        RETURN;
 --     END IF;

--      IF prm_yab515 IS NULL THEN
--         prm_ErrorMsg := 'ר��Ա֤�����Ͳ���Ϊ��!';
--         RETURN;
--      END IF;
--
--      IF prm_yab516 IS NULL THEN
--         prm_ErrorMsg := 'ר��Ա֤����Ų���Ϊ��!';
--         RETURN;
--      END IF;
--
--      IF prm_aab016 IS NULL THEN
--         prm_ErrorMsg := 'ר��Ա��������Ϊ��!';
--         RETURN;
--      END IF;
--
--      IF prm_yab390 IS NULL THEN
--         prm_ErrorMsg := 'ר��Ա�ֻ�����Ϊ��!';
--         RETURN;
--      END IF;

--      IF prm_yab028 IS NULL THEN
--         prm_ErrorMsg := '��˰�����벻��Ϊ��!';
--         RETURN;
--      END IF;

 --     IF prm_yab136 IS NULL THEN
 --        prm_ErrorMsg := '��λ����״̬����Ϊ��!';
 --        RETURN;
 --     END IF;

      IF prm_yab009 IS NULL THEN
         prm_ErrorMsg := '��λ��Ӫ��Χ����Ϊ��!';
         RETURN;
      END IF;

--      IF prm_yab006 IS NULL THEN
--         prm_ErrorMsg := '��λ˰���������Ϊ��!';
--         RETURN;
 --     END IF;


      --�Ƿ����AB01��λ��Ϣ
      SELECT COUNT(1)
           into n_count
           FROM xasi2.AB01
          WHERE aab001 = prm_aab001;
      IF n_count = 0 THEN
            prm_ErrorMsg := '��λ���Ϊ['|| prm_aab001 ||']�ĵ�λ��Ϣ������!';
            RETURN;
      END IF;

      --�Ƿ�������걨��Ϣ
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAB01
          WHERE aab001 = prm_aab001 and iaa002 = PKG_Constant.IAA002_AIR;
      IF n_count > 0 THEN
            prm_ErrorMsg := '��λ���Ϊ['|| prm_aab001 ||']�ĵ�λ�������걨��Ϣ��';
            RETURN;
      END IF;


      --�Ƿ���ڿ��õĵ�λ�걨��Ϣ
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAB01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and a.aab001 = prm_aab001 and b.aaa121 = PKG_Constant.AAA121_NER;
      IF n_count = 0 THEN
            prm_ErrorMsg := 'û�е�λ���Ϊ['|| prm_aab001 ||']�Ŀ����걨��Ϣ!';
            RETURN;
      END IF;
      IF n_count > 1 THEN
            prm_ErrorMsg := '��λ���Ϊ['|| prm_aab001 ||']�Ŀ����걨��Ϣ��������ϵά����Ա!';
            RETURN;
      END IF;

      --�Ƿ������ͬ����˼���
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAA02
          WHERE iaa011 = PKG_Constant.IAA011_EIM
          AND iaa005 = PKG_Constant.IAA005_YES;
      IF n_count = 0 THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'û��ϵͳ��˼�����Ϣ!����ϵά����Ա';
            RETURN;
      ELSIF n_count > 1 THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'ϵͳ��˼�����Ϣ����!����ϵά����Ա';
            RETURN;
      END IF;



      --�������Ž���¼��
      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB001';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aab001;

--    t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB003';
--    t_cols(t_cols.COUNT).COL_VALUE := prm_aab003;

--     t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB022';
--     t_cols(t_cols.COUNT).COL_VALUE := prm_aab022;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB004';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aab004;

--    t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB005';
--    t_cols(t_cols.COUNT).COL_VALUE := prm_aab005;

--    t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE006';
--    t_cols(t_cols.COUNT).COL_VALUE := prm_aae006;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE007';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_aae007;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB519';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_yab519;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE014';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_aae014;

--     t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB019';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_aab019;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB020';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_aab020;

--     t_cols(t_cols.COUNT + 1).COL_NAME := 'YLB001';
--     t_cols(t_cols.COUNT).COL_VALUE := prm_ylb001;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB021';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_aab021;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB275';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_yab275;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB023';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_aab023;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAE225';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_yae225;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB518';
--      t_cols(t_cols.COUNT).COL_VALUE := to_char(prm_yab518,'yyyy-mm-dd');

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE013';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_aae013;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB389';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_yab389;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB015';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_aab015;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB515';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_yab515;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB516';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_yab516;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB016';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_aab016;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB237';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_yab237;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB390';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_yab390;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB517';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_yab517;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB018';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_aab018;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAF020';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_aaf020;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB030';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_aab030;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE011';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aae011;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB136';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_yab136;

--     t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB028';
--     t_cols(t_cols.COUNT).COL_VALUE := prm_yab028;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB009';
      t_cols(t_cols.COUNT).COL_VALUE := prm_yab009;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB388';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_yab388;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB013';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_aab013;

--      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB006';
--      t_cols(t_cols.COUNT).COL_VALUE := prm_yab006;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAB534';
      t_cols(t_cols.COUNT).COL_VALUE := prm_yab534;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB024';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aab024;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB025';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aab025;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAB026';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aab026;

      --��ȡ������Ϣ
      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');

      SELECT iaa004
           into v_iaa004
           FROM wsjb.IRAA02
          WHERE iaa011 = PKG_Constant.IAA011_EIM
          AND iaa005 = PKG_Constant.IAA005_YES;


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
                  AAE218,
                  AAE013
                 )
                 VALUES
                 (
                  v_aaz002,
                  PKG_Constant.AAA121_EIM,
                  prm_aae011,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae011,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate,
                  '��' --nvl('��',prm_aae013)
                 );


      --������߸���IRAB01

      SELECT count(1)
           into
            n_count
           FROM wsjb.IRAB01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and b.aaa121 = PKG_Constant.AAA121_EIM and a.aab001 = prm_aab001 and a.iaa002 = PKG_Constant.IAA002_NPS;

          IF n_count = 0 THEN

           v_iab001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAB001');

           INSERT INTO wsjb.IRAB01  (
           iab001,
           iaa002,
           aab001,
           aab002,
           aab003,
           aab004,
           aab005,
           aab006,
           aab007,
           aab008,
           aab009,
           aab010,
           aab011,
           aab012,
           aab013,
           yab136,
           aab019,
           aab020,
           aab021,
           aab022,
           ylb001,
           yab391,
           yab388,
           yab389,
           aab015,
           yab515,
           yab516,
           aab016,
           yab237,
           yab390,
           aab018,
           yab517,
           aab023,
           yab518,
           aae007,
           aae006,
           yae225,
           yab519,
           yab520,
           aae014,
           aab034,
           aab301,
           yab322,
           yab274,
           yab525,
           yab524,
           yab521,
           yab522,
           yab523,
           yab236,
           aae119,
           yab275,
           yae496,
           yae407,
           aae013,
           aae011,
           aae036,
           yae443,
           yab553,
           aab304,
           yae393,
           yab554,
           ykb110,
           ykb109,
           yab566,
           yab565,
           yab380,
           yab279,
           yab003,
           aaf020,
           aab343,
           aab030,
           aaz002,
           --yab028,
           yab009,
           yab006
           )
    SELECT
           v_iab001,
           PKG_Constant.IAA002_AIR,
           aab001,
           aab002,
           aab003,
           aab004,
           aab005,
           aab006,
           aab007,
           aab008,
           aab009,
           aab010,
           aab011,
           aab012,
           aab013,
           yab136,
           aab019,
           aab020,
           aab021,
           aab022,
           ylb001,
           yab391,
           yab388,
           yab389,
           aab015,
           yab515,
           yab516,
           aab016,
           yab237,
           yab390,
           aab018,
           yab517,
           aab023,
           yab518,
           aae007,
           aae006,
           yae225,
           yab519,
           yab520,
           aae014,
           aab034,
           aab301,
           yab322,
           yab274,
           yab525,
           yab524,
           yab521,
           yab522,
           yab523,
           yab236,
           aae119,
           yab275,
           yae496,
           yae407,
           aae013,
           aae011,
           aae036,
           yae443,
           yab553,
           aab304,
           yae393,
           yab554,
           ykb110,
           ykb109,
           yab566,
           yab565,
           yab380,
           yab279,
           yab003,
           aaf020,
           aab343,
           aab030,
           v_aaz002,
           --prm_yab028,
           prm_yab009,
           (SELECT yab006 FROM wsjb.IRAB01  WHERE aab001 = prm_aab001 AND aab001 = iab001) as yab006
           FROM xasi2.AB01 WHERE aab001 = prm_aab001;

       --���µ�λ�걨��Ϣ��
       --v_aae007 := prm_aae007;
       -- if prm_aae007 = -1 THEN
       --      v_aae007 := null;
       --END IF;
            UPDATE wsjb.IRAB01  SET
                   aab001 = prm_aab001,
                   --aab003 = prm_aab003,
                   --aab022 = prm_aab022,
                   aab004 = prm_aab004,
                   --aab005 = prm_aab005,
                   --aae006 = prm_aae006,
                   --aae007 = v_aae007,
                   --yab519 = prm_yab519,
                   --aae014 = prm_aae014,
                   --aab019 = prm_aab019,
                   --aab020 = prm_aab020,
                   --ylb001 = prm_ylb001,
                   --aab021 = prm_aab021,
                   --yab275 = prm_yab275,
                   --aab023 = prm_aab023,
                   --yae225 = prm_yae225,
                   --yab518 = prm_yab518,
                   --aae013 = prm_aae013,
                   --yab391 = prm_yab391,
                   --yab388 = prm_yab388,
                   --aab013 = prm_aab013,
                   --yab389 = prm_yab389,
                   --aab015 = prm_aab015,
                   --yab515 = prm_yab515,
                   --yab516 = prm_yab516,
                   --aab016 = prm_aab016,
                   --yab237 = prm_yab237,
                   --yab390 = prm_yab390,
                   --yab517 = prm_yab517,
                   --aab018 = prm_aab018,
                   --aaf020 = prm_aaf020,
                   --yab028 = prm_yab028,
                   yab009 = prm_yab009,
                   --aab030 = prm_aab030,
                   aae011 = prm_aae011,
                   --aaz002 = v_aaz002,
                   --yab136 = prm_yab136,
                   --yab006 = prm_yab006,
                   yab534 = prm_yab534,
                   aab024 = prm_aab024,
                   aab025 = prm_aab025,
                   aab026 = prm_aab026
            WHERE iab001 = v_iab001;


       --��ʷ�޸��¼�
      v_iaz012 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ012');
      INSERT INTO IRAD31
                 (
                  iaz012,
                  aaz002,
                  iaz007,
                  aae011,
                  aae035,
                  aab001,
                  yab003,
                  iaa019,
                  iaa011,
                  aae013
                 )
                 VALUES
                 (
                  v_iaz012,
                  v_aaz002,
                  v_iab001,
                  prm_aae011,
                  sysdate,
                  prm_aab001,
                  PKG_Constant.YAB003_JBFZX,
                  PKG_Constant.IAA019_IR,
                  PKG_Constant.IAA011_EIM,
                  '��'--nvl('��',prm_aae013)
                 );


      --�걨�¼���
      v_iaz004 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ004');
      INSERT INTO wsjb.IRAD01
                 (
                 iaz004,
                 aaz002,
                 iaa011,
                 aae011,
                 aae035,
                 aab001,
                 yab003,
                 aae013,
                 iaa100
                 )
                 VALUES
                 (
                  v_iaz004,
                  v_aaz002,
                  PKG_Constant.IAA011_EIM,
                  prm_aae011,
                  sysdate,
                  prm_aab001,
                  PKG_Constant.YAB003_JBFZX,
                  '��', --prm_aae013,
                  to_number(to_char(sysdate,'yyyymm'))
                 );

       --�걨��ϸ��
       v_iaz005 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');
       INSERT INTO wsjb.IRAD02
                (
                 iaz005,
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
                ) VALUES (
                 v_iaz005,
                 v_iaz005,
                 v_iaz004,
                 v_iab001,
                 prm_aab001,
                 prm_aab004,
                 prm_aae011,
                 sysdate,
                 PKG_Constant.YAB003_JBFZX,
                 v_iaa004,
                 '0',
                 PKG_Constant.IAA015_WAD,
                 PKG_Constant.IAA016_DIR_NO,
                 '��', --prm_aae013,
                 PKG_Constant.IAA020_DW
                );
         --�����걨�������
         INSERT INTO wsjb.IRAD03
                     (
                      iaz003 ,
                      iaz004 ,
                      iaa011 ,
                      iaa013 ,
                      aae035 ,
                      yae092 ,
                      yab003 ,
                      aae013 ,
                      aae120
                     )
                     VALUES
                     (
                      PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ003'),
                      v_iaz004,
                      PKG_Constant.IAA011_EIM,
                      PKG_COMMON.fun_cbbh('DWBG',PKG_Constant.YAB003_JBFZX),
                      sysdate,
                      prm_aae011,
                      PKG_Constant.YAB003_JBFZX,
                      '��', --nvl(prm_aae013,''),
                      '0'
                     );

      ELSIF n_count != 0 THEN

      BEGIN

       SELECT a.iaz012,b.iab001
           into
            v_iaz012,v_iab001
           FROM wsjb.IRAD31  a,wsjb.IRAB01  b,wsjb.AE02  c
          WHERE b.aab001 = prm_aab001 and a.iaz007 = b.iab001 and b.aaz002 = c.aaz002 and c.aaa121 = PKG_Constant.AAA121_EIM and b.iaa002 = PKG_Constant.IAA002_NPS;

           EXCEPTION
           -- WHEN NO_DATA_FOUND THEN
          -- WHEN TOO_MANY_ROWS THEN
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
           /*�رմ򿪵��α�*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '��λ�޸���Ϣ���д��ڴ�������~��'|| SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;
       END;


       --���µ�λ�걨��Ϣ��
       --v_aae007 := prm_aae007;
       --if prm_aae007 = -1 THEN
       --     v_aae007 := null;
       --END IF;
            UPDATE wsjb.IRAB01  SET
                   iaa002 = PKG_Constant.IAA002_AIR,
                   aab001 = prm_aab001,
                   --aab003 = prm_aab003,
                   --aab022 = prm_aab022,
                   aab004 = prm_aab004,
                   --aab005 = prm_aab005,
                   --aae006 = prm_aae006,
                   --aae007 = v_aae007,
                   --yab519 = prm_yab519,
                   --aae014 = prm_aae014,
                   --aab019 = prm_aab019,
                   --aab020 = prm_aab020,
                   --ylb001 = prm_ylb001,
                   --aab021 = prm_aab021,
                   --yab275 = prm_yab275,
                   --aab023 = prm_aab023,
                   --yae225 = prm_yae225,
                   --yab518 = prm_yab518,
                   --aae013 = prm_aae013,
                   --yab391 = prm_yab391,
                   --yab388 = prm_yab388,
                   --aab013 = prm_aab013,
                   --yab389 = prm_yab389,
                   --aab015 = prm_aab015,
                   --yab515 = prm_yab515,
                   --yab516 = prm_yab516,
                   --aab016 = prm_aab016,
                   --yab237 = prm_yab237,
                   --yab390 = prm_yab390,
                   --yab517 = prm_yab517,
                   --aab018 = prm_aab018,
                   --aaf020 = prm_aaf020,
                   --yab028 = prm_yab028,
                   yab009 = prm_yab009
                   --aab030 = prm_aab030,
                   --aae011 = prm_aae011,
                   --aaz002 = v_aaz002,
                   --yab136 = prm_yab136,
                   --yab006 = prm_yab006
            WHERE iab001 = v_iab001;

            --���µ�λ�޸���Ϣ��
            UPDATE wsjb.irad31  SET
                   aaz002 = v_aaz002,
                   aae011 = prm_aae011,
                   aae035 = sysdate
                   --iaa019 = PKG_Constant.IAA019_IR
            WHERE iaz012 = v_iaz012;

            --����IRAD32������
            UPDATE IRAD32 a SET
                a.aae100 = '0'
            WHERE a.iaz012 = v_iaz012 and a.aae100 = '1';

            --�걨��ϸ��
            v_iaz005 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');

            --��ѯ�ϴ�ID
            BEGIN
              SELECT iaz005,iaz004
                    INTO v_iaz006,v_iaz004
                    FROM wsjb.IRAD02  where iaz005 = (
                   SELECT max(b.iaz005)
                   FROM wsjb.IRAD01  a,wsjb.IRAD02  b
                   where a.iaz004 = b.iaz004
                   and a.iaa011 = PKG_Constant.AAA121_EIM
                   and b.iaz008 = prm_aab001
                   and b.iaa020 = PKG_Constant.IAA020_DW
                   and b.iaa015 = PKG_Constant.IAA015_ADO);
            EXCEPTION
            -- WHEN NO_DATA_FOUND THEN
            -- WHEN TOO_MANY_ROWS THEN
            -- WHEN DUP_VAL_ON_INDEX THEN
            WHEN OTHERS THEN
            /*�رմ򿪵��α�*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '��λ�걨��ϸ���д��ڴ������ݣ�'|| SQLERRM||dbms_utility.format_error_backtrace ;

            RETURN;
            END;

            --���µ�λ�걨��Ϣ��
            UPDATE wsjb.IRAD01  SET
                   aaz002 = v_aaz002,
                   aae011 = prm_aae011,
                   aae035 = sysdate,
                  -- iaa019 = PKG_Constant.IAA019_IR,
                   iaa100 = to_number(to_char(sysdate,'yyyymm'))
            WHERE iaz004 = v_iaz004;

            --�����걨��ϸ
            INSERT INTO wsjb.IRAD02
                (
                 iaz005,
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
                ) VALUES (
                 v_iaz005,
                 v_iaz006,
                 v_iaz004,
                 v_iab001,
                 prm_aab001,
                 prm_aab004,
                 prm_aae011,
                 sysdate,
                 PKG_Constant.YAB003_JBFZX,
                 v_iaa004,
                 '0',
                 PKG_Constant.IAA015_WAD,
                 PKG_Constant.IAA016_DIR_NO,
                 '��',  --prm_aae013
                 PKG_Constant.IAA020_DW
                );

     END IF;


     --��ʷ�޸���ϸ

    FOR i in 1 .. t_cols.count LOOP

        v_name := t_cols(i).COL_NAME;
        v_value := t_cols(i).COL_VALUE;

        BEGIN

         SELECT COMMENTS INTO v_comments FROM USER_COL_COMMENTS where TABLE_NAME = 'IRAB01' and COLUMN_NAME = v_name;

         SELECT DATA_TYPE INTO col_type FROM USER_TAB_COLUMNS where TABLE_NAME = 'IRAB01' and COLUMN_NAME = v_name;

        EXCEPTION
           -- WHEN NO_DATA_FOUND THEN
          -- WHEN TOO_MANY_ROWS THEN
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
           /*�رմ򿪵��α�*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'IRAB01����û�� '|| v_name ||'�ֶ�'|| SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;

        END;

        IF v_name = 'YAB028' THEN
           v_sql := 'SELECT '||v_name||' FROM AB01A7 where AAB001 = '''||prm_aab001||'''';
        ELSIF v_name = 'YAB009' THEN
           v_sql := 'SELECT max(a.YAB009) FROM wsjb.IRAB01  a,wsjb.AE02  b where a.aaz002 = b.aaz002 and b.aaa121 = '''||PKG_Constant.AAA121_NER||''' and a.AAB001 = '''||prm_aab001||'''';
        ELSIF v_name = 'YAB006' THEN
           v_sql := 'SELECT max(a.YAB006) FROM wsjb.IRAB01  a,wsjb.AE02  b where a.aaz002 = b.aaz002 and b.aaa121 = '''||PKG_Constant.AAA121_NER||''' and a.AAB001 = '''||prm_aab001||'''';
        ELSIF v_name = 'YAB534' THEN
           v_sql := 'SELECT max(a.YAB534) FROM wsjb.IRAB01  a,wsjb.AE02  b where a.aaz002 = b.aaz002 and b.aaa121 = '''||PKG_Constant.AAA121_NER||''' and a.AAB001 = '''||prm_aab001||'''';
        ELSIF v_name = 'AAB024' THEN
           v_sql := 'SELECT max(a.AAB024) FROM wsjb.IRAB01  a,wsjb.AE02  b where a.aaz002 = b.aaz002 and b.aaa121 = '''||PKG_Constant.AAA121_NER||''' and a.AAB001 = '''||prm_aab001||'''';
        ELSIF v_name = 'AAB025' THEN
           v_sql := 'SELECT max(a.AAB025) FROM wsjb.IRAB01  a,wsjb.AE02  b where a.aaz002 = b.aaz002 and b.aaa121 = '''||PKG_Constant.AAA121_NER||''' and a.AAB001 = '''||prm_aab001||'''';
        ELSIF v_name = 'AAB026' THEN
           v_sql := 'SELECT max(a.AAB026) FROM wsjb.IRAB01  a,wsjb.AE02  b where a.aaz002 = b.aaz002 and b.aaa121 = '''||PKG_Constant.AAA121_NER||''' and a.AAB001 = '''||prm_aab001||'''';
        ELSIF col_type IN ('CHAR', 'VARCHAR', 'VARCHAR2') THEN
           v_sql := 'SELECT '||v_name||' FROM AB01 where AAB001 = '''||prm_aab001||'''';
        ELSIF col_type IN ('NUMBER', 'INTEGER', 'FLOAT') THEN
           if v_value = -1 THEN
            v_value := null;
           END IF;
           v_sql := 'SELECT to_char(nvl('||v_name||','''')) FROM AB01 where AAB001 = '''||prm_aab001||'''';


        ELSIF col_type IN ('DATE') THEN
           v_value := to_char(v_value,'yyyy-mm-dd');
           v_sql := 'SELECT decode(null,null,to_char(' || v_name ||
                                          ',''yyyy-mm-dd''))' || ' FROM AB01 where AAB001 = '''||prm_aab001||'''';
        ELSE
          ROLLBACK;
           prm_AppCode  := Pkg_Constant.GN_DEF_ERR;
           prm_ErrorMsg := '��' || 'AB01' || '�ֶ�' || UPPER(v_name) || '����������Ϊ' ||
                           col_type || '�����ܴ���' ;

           RETURN;
        END IF;

        EXECUTE IMMEDIATE v_sql
                        INTO v_varchar;
                    v_varchar := nvl(v_varchar, '');

         IF nvl(TRIM(v_varchar), '@*yinhai#^%@') != nvl(TRIM(v_value), '@*yinhai#^%@') THEN

           v_iaz013 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ013');
           IF Prm_Appcode != pkg_constant.GN_DEF_OK THEN
             ROLLBACK;
              RETURN;
           END IF;



           INSERT INTO IRAD32
                     (
                      iaz013,
                      iaz012,
                      iaz008,
                      iad004,
                      iad006,
                      iad007,
                      iad008,
                      iad009,
                      aae011,
                      aae035,
                      aab001,
                      yab003,
                      aae013,
                      aae100
                     ) VALUES
                     (
                       v_iaz013,
                       v_iaz012,
                       prm_aab001,
                       decode(v_name,'YAB028','AB01A6','AB01'),
                       v_name,
                       v_comments,
                       v_varchar,
                       v_value,
                       prm_aae011,
                       sysdate,
                       prm_aab001,
                       PKG_Constant.YAB003_JBFZX,
                       '��', --prm_aae013,
                       '1'
                     );


         END IF;

     END LOOP;

    EXCEPTION
       WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'||v_name||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
         RETURN;
    END prc_UnitInfoMaintain;

   /*****************************************************************************
   ** �������� : prc_PersonInsuCheck
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��Ա�²α����]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuCheck(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                             prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --��λ����
                             prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                             prm_aae011       IN    irac01.aae011%TYPE ,    --������
                             prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                             prm_aae036       IN    irac01.aae036%TYPE ,    --����ʱ��
                             prm_AppCode      OUT   VARCHAR2  ,    --�������
                             prm_ErrMsg       OUT   VARCHAR2  )    --��������
   IS
      var_procNo      VARCHAR2(2);         --�������
      num_count       NUMBER;
      var_yac001      VARCHAR2(20);
      var_yae235      VARCHAR2(6);
      var_yae238      VARCHAR2(2000);
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --���˱��
      var_aae140_01   VARCHAR2(2);         --�Ƿ�μ�����ҵ����
      var_aae140_06   VARCHAR2(2);         --�Ƿ�μ��˻�������
      var_aae140_02   VARCHAR2(2);         --�Ƿ�μ���ʧҵ
      var_aae140_03   VARCHAR2(2);         --�Ƿ�μ��˻���ҽ��
      var_aae140_04   VARCHAR2(2);         --�Ƿ�μ��˹���
      var_aae140_05   VARCHAR2(2);         --�Ƿ�μ�������
      var_aae140_07   VARCHAR2(2);         --�Ƿ�μ��˴��
      var_aae140_08   VARCHAR2(2);
      num_yac004      NUMBER(14,2); --���ϻ���
      num_yac005      NUMBER(14,2); --��������
      rec_irac01      irac01%rowtype;
      accountac01a1   NUMBER;   --��ѯ��ac01a1��Ӧ����
      v_aad055        VARCHAR2(100);
      prm_aac001_out  VARCHAR2(10);
      var_aab019       ab01.aab019%TYPE;             --��λ����  ��Ҫ���ָ��幤�˻�   yujj 20191101

   BEGIN
      prm_AppCode  := PKG_Constant.GN_DEF_OK;
      prm_ErrMsg   := '';
      var_aac001   := '';

      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      var_aae140_01 := rec_irac01.aae110;        --�Ƿ�μ�����ҵ����
      var_aae140_06 := rec_irac01.aae120;        --�Ƿ�μ��˻�������
      var_aae140_02 := rec_irac01.aae210;        --�Ƿ�μ���ʧҵ
      var_aae140_03 := rec_irac01.aae310;        --�Ƿ�μ��˻���ҽ��
      var_aae140_04 := rec_irac01.aae410;        --�Ƿ�μ��˹���
      var_aae140_05 := rec_irac01.aae510;        --�Ƿ�μ�������
      var_aae140_07 := rec_irac01.aae311;        --�Ƿ�μ��˴��
      var_aae140_08 := rec_irac01.aae810;        --�Ƿ�μ��˹���Ա


      IF var_aae140_06 = '1' OR var_aae140_06 = '10' OR var_aae140_02 = '1' OR var_aae140_02 = '10'
      OR var_aae140_03 = '1' OR var_aae140_03 = '10' OR var_aae140_04 = '1' OR var_aae140_04 = '10'
      OR var_aae140_05 = '1' OR var_aae140_05 = '10' OR var_aae140_07 = '1' OR var_aae140_07 = '10'
      OR var_aae140_08 = '1' OR var_aae140_08 = '10'
       THEN

         --д����ʱ������
         PKG_COMMON.PRC_P_insertAe16Tmp(prm_yae099,
                                       prm_iac001,
                                       '01', --���������²α�
                                       prm_aab001,
                                       prm_aae011,
                                       prm_AppCode,
                                       prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            prm_ErrMsg  := 'д����ʱ������:'||prm_ErrMsg;
            RETURN;
         END IF ;

         --��ʱ������У��
         xasi2.pkg_gx_insuranceBatch.prc_p_insuranceCheck(prm_yae099,
                                                           prm_aab001,
                                                           PKG_Constant.YAB003_JBFZX,
                                                           PKG_Constant.YAB003_JBFZX,
                                                           prm_aae011,
                                                           prm_AppCode,
                                                           prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            prm_ErrMsg  := '��ʱ������У��'||prm_ErrMsg;
            RETURN;
         END IF ;

         SELECT yae235,NVL(yae238,''),aad055
           INTO var_yae235,var_yae238,v_aad055
           FROM xasi2.AE16A1
          WHERE YAE099 = prm_yae099 ;
         IF var_yae235 = '2' THEN
            prm_AppCode := PKG_Constant.gn_def_ERR;
            prm_ErrMsg  := '��Ա�α���ϢУ��ʧ��:'||var_yae238||v_aad055;
            RETURN;
         END IF;

         --���������²α��������ݵ���
         xasi2.pkg_gx_insuranceBatch.prc_p_intoInfo(prm_yae099,
                                                      prm_aab001,
                                                      PKG_Constant.YAB003_JBFZX,
                                                      PKG_Constant.YAB003_JBFZX,
                                                      prm_aae011,
                                                      sysdate,
                                                      rec_irac01.aac030,
                                                      prm_AppCode,
                                                      prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            prm_ErrMsg  := '�����²α��������ݵ���'||prm_AppCode||prm_ErrMsg;
            RETURN;
         END IF ;

         SELECT NVL(AAD059,'')
           INTO var_aac001
           FROM xasi2.AE16A2
          WHERE YAE099 = prm_yae099
                and  YAE235 = '1';
         IF var_aac001 = '' THEN
            prm_AppCode := PKG_Constant.gn_def_ERR;
            prm_ErrMsg  := '��Ա��Ų�����!��Ա�²α�ʧ��!';
            RETURN;
         END IF;

         --�����걨��Ϣ����Ա���
         UPDATE IRAC01
            SET AAC001 = var_aac001
          WHERE IAC001 = prm_iac001;

         --����ac01a1ҽ�����ϱ�Ŷ�Ӧ��
         if var_aae140_01 = '1' THEN
           select count(1)
              into  accountac01a1
           from xasi2.ac01a1
           where aac001=prm_iac001;
           IF accountac01a1=1  THEN
           UPDATE xasi2.ac01a1
              SET aac001 = var_aac001
           WHERE  aac001=prm_iac001;
           END IF;
         END IF;

         --�����걨��ϸ��Ϣ����Ա���
         UPDATE wsjb.IRAD02
            SET IAZ008 = var_aac001
          WHERE IAZ007 = prm_iac001;

         --���²α���Ա��ִ��Ϣ
         UPDATE xasi2.AC02
            SET AAE013 = AAE013||'����Դ�����Ͼ���ҵ��ϵͳ'
          WHERE aac001 = var_aac001;

         --��������˱�������Ա��� 20150408
         UPDATE wsjb.IRAC01A4
            SET AAC001 = var_aac001
          WHERE IAC001 = prm_iac001
            AND IAA002 = '2'
            AND AAE120 = '0';

         --��������˱����α���Ϣ����Ա��� 20150408
         UPDATE wsjb.IRAC01A5
            SET AAC001 = var_aac001
          WHERE IAC001 = prm_iac001
            AND IAA002 = '2'
            AND AAE120 = '0';
      END IF;

      --���α���λ�Ƿ���ڸ���Ա��Ϣ
      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.IRAC01A3
       WHERE AAC001 = NVL(var_aac001,rec_irac01.AAC001)
         AND AAB001 = rec_irac01.AAB001;
      IF num_count = 0 THEN
         var_yac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'YAC001');
         IF var_yac001 is null THEN
            prm_AppCode := gn_def_ERR ;
            prm_ErrMsg  := 'û�л�ȡ����λ��Ա���к�yac001!';
            RETURN;
         END IF;

         INSERT INTO wsjb.irac01a3 (
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
                     NVL(var_aac001,rec_irac01.AAC001),          -- ���˱��
                     rec_irac01.aab001,
                     rec_irac01.yae181,          -- ֤������
                     rec_irac01.aac002,          -- ���֤����(֤������)
                     rec_irac01.aac003,          -- ����
                     rec_irac01.aac004,          -- �Ա�
                     rec_irac01.aac005,
                     rec_irac01.aac006,          -- ��������
                     rec_irac01.aac007,          -- �μӹ�������
                     rec_irac01.aac008,          -- ��Ա״̬
                     rec_irac01.aac009,
                     rec_irac01.aac010,
                     rec_irac01.aac012,
                     rec_irac01.aac013,
                     rec_irac01.aac014,
                     rec_irac01.aac015,
                     rec_irac01.aac020,
                     rec_irac01.yac067,          -- ��Դ��ʽ
                     rec_irac01.yac168,          -- ũ�񹤱�־
                     rec_irac01.aae004,
                     rec_irac01.aae005,          -- ��ϵ�绰
                     rec_irac01.aae006,          -- ��ַ
                     rec_irac01.aae007,
                     rec_irac01.yae222,
                     rec_irac01.aae013,
                     0,
                     PKG_Constant.YAB003_JBFZX,
                     rec_irac01.aab001,
                     prm_aae011,          -- ������
                     prm_aae036);         -- ����ʱ��
      END IF;
     BEGIN  --��λ����״̬
     SELECT  aab019
      INTO  var_aab019
   FROM ab01
      WHERE aab001 = rec_irac01.AAB001;
    EXCEPTION
   WHEN OTHERS THEN
        prm_AppCode := PKG_Constant.gn_def_ERR;
        prm_ErrMsg  := '��λ����'||prm_aab001||'û�л�ȡ����λ������Ϣ';
        RETURN;
     END;
      IF var_aae140_01 = '1' OR var_aae140_01 = '10' THEN
      --���ϻ������׷ⶥ
      SELECT pkg_common.fun_p_getcontributionbase(null,rec_irac01.aab001,ROUND(rec_irac01.aac040),'0','01','1','1',rec_irac01.iaa100,prm_yab003)
        INTO num_yac004
        FROM dual;
      --ҽ�ƻ������׷ⶥ
      SELECT pkg_common.fun_p_getcontributionbase(null,rec_irac01.aab001,ROUND(rec_irac01.aac040),'0','03','1','1',rec_irac01.iaa100,prm_yab003)
        INTO num_yac005
        FROM dual;
       --�жϸ��幤�̻�---  20191101  yujj
     IF var_aab019 = '60' THEN
      UPDATE wsjb.irac01
         SET yaa333 = num_yac004,
             yac005 = num_yac005
       WHERE IAC001 = prm_iac001;
     ELSE
            UPDATE wsjb.irac01
         SET yac004 = num_yac004,
             yac005 = num_yac005
       WHERE IAC001 = prm_iac001;
      END IF ;
      END IF ;
      UPDATE wsjb.IRAC01A3
         SET AAE110 = DECODE(var_aae140_01,'1','2','10','2',var_aae140_01),
             AAE120 = DECODE(var_aae140_06,'1','2',var_aae140_06),
             AAE210 = DECODE(var_aae140_02,'1','2',var_aae140_02),
             AAE310 = DECODE(var_aae140_03,'1','2',var_aae140_03),
             AAE410 = DECODE(var_aae140_04,'1','2',var_aae140_04),
             AAE510 = DECODE(var_aae140_05,'1','2',var_aae140_05),
             AAE311 = DECODE(var_aae140_07,'1','2',var_aae140_07),
             AAC040 = rec_irac01.aac040,
             YAC004 = DECODE(var_aae140_01,'1',num_yac004,'10',num_yac004,YAC004),
             YAC005 = num_yac005
       WHERE AAC001 = var_aac001
         AND AAB001 = rec_irac01.AAB001;



   EXCEPTION
      WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuCheck;

   /*****************************************************************************
   ** �������� : prc_PersonInsuAddCheck
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��Ա�����������]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuAddCheck(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --��λ����
                                prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                prm_aae036       IN    irac01.aae036%TYPE ,    --����ʱ��
                                prm_AppCode      OUT   VARCHAR2  ,    --�������
                                prm_ErrMsg       OUT   VARCHAR2  )    --��������
    IS
      var_procNo      VARCHAR2(2);         --�������
      num_count       NUMBER;
      var_yac001      VARCHAR2(20);
      var_yae235      VARCHAR2(6);
      var_yae238      VARCHAR2(2000);
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --���˱��
      var_aae140_01   VARCHAR2(2);         --�Ƿ�μ�����ҵ����
      var_aae140_06   VARCHAR2(2);         --�Ƿ�μ��˻�������
      var_aae140_02   VARCHAR2(2);         --�Ƿ�μ���ʧҵ
      var_aae140_03   VARCHAR2(2);         --�Ƿ�μ��˻���ҽ��
      var_aae140_04   VARCHAR2(2);         --�Ƿ�μ��˹���
      var_aae140_05   VARCHAR2(2);         --�Ƿ�μ�������
      var_aae140_07   VARCHAR2(2);         --�Ƿ�μ��˴��
      var_aae140_08   VARCHAR2(2);
      num_yac004      NUMBER(14,2); --���ϻ���
      num_yac005      NUMBER(14,2); --ҽ�ƻ���
      rec_irac01      irac01%rowtype;
      v_aad055        VARCHAR2(100);
      prm_aac001_out  VARCHAR2(10);
      var_aab019       ab01.aab019%TYPE;             --��λ����  ��Ҫ���ָ��幤�˻�   yujj 20191101


   BEGIN
      prm_AppCode  := PKG_Constant.GN_DEF_OK;
      prm_ErrMsg   := '';
      var_aac001   := '';

      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      var_aae140_01 := rec_irac01.aae110;        --�Ƿ�μ�����ҵ����
      var_aae140_06 := rec_irac01.aae120;        --�Ƿ�μ��˻�������
      var_aae140_02 := rec_irac01.aae210;        --�Ƿ�μ���ʧҵ
      var_aae140_03 := rec_irac01.aae310;        --�Ƿ�μ��˻���ҽ��
      var_aae140_04 := rec_irac01.aae410;        --�Ƿ�μ��˹���
      var_aae140_05 := rec_irac01.aae510;        --�Ƿ�μ�������
      var_aae140_07 := rec_irac01.aae311;        --�Ƿ�μ��˴��
      var_aae140_08 := rec_irac01.aae810;

      IF var_aae140_06 = '1' OR var_aae140_06 = '10' OR var_aae140_02 = '1' OR var_aae140_02 = '10'
      OR var_aae140_03 = '1' OR var_aae140_03 = '10' OR var_aae140_04 = '1' OR var_aae140_04 = '10'
      OR var_aae140_05 = '1' OR var_aae140_05 = '10' OR var_aae140_07 = '1' OR var_aae140_07 = '10'
      OR var_aae140_08 = '1' OR var_aae140_08 = '10' THEN
         --д����ʱ������
         PKG_COMMON.PRC_P_insertAe16Tmp(prm_yae099,
                                       prm_iac001,
                                       '01', --���������²α�
                                       prm_aab001,
                                       prm_aae011,
                                       prm_AppCode,
                                       prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;
         --��ʱ������У��
         xasi2.pkg_gx_insuranceBatch.prc_p_insuranceCheck(prm_yae099,
                                                           prm_aab001,
                                                           PKG_Constant.YAB003_JBFZX,
                                                           PKG_Constant.YAB003_JBFZX,
                                                           prm_aae011,
                                                           prm_AppCode,
                                                           prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;

         SELECT yae235,NVL(yae238,''),aad055
           INTO var_yae235,var_yae238,v_aad055
           FROM xasi2.AE16A1
          WHERE YAE099 = prm_yae099;
         IF var_yae235 = '2' THEN
            prm_AppCode := PKG_Constant.gn_def_ERR;
            prm_ErrMsg  := '��Ա�α���ϢУ��ʧ��:'||var_yae238||v_aad055;
            RETURN;
         END IF;

         --���������²α��������ݵ���
         xasi2.pkg_gx_insuranceBatch.prc_p_intoInfo(prm_yae099,
                                                      prm_aab001,
                                                      PKG_Constant.YAB003_JBFZX,
                                                      PKG_Constant.YAB003_JBFZX,
                                                      prm_aae011,
                                                      sysdate,
                                                      rec_irac01.aac030,
                                                      prm_AppCode,
                                                      prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;

         --���²α���Ա��ִ��Ϣ
         UPDATE xasi2.AC02
            SET AAE013 = AAE013||'����Դ�����Ͼ���ҵ��ϵͳ'
          WHERE aac001 = rec_irac01.AAC001
            and aae011 = prm_aae011;
      END IF;

      --���α���λ�Ƿ���ڸ���Ա��Ϣ
      IF var_aae140_01 = '1' OR var_aae140_01 = '10' THEN
      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.IRAC01A3
       WHERE AAC001 = NVL(var_aac001,rec_irac01.AAC001)
         AND AAB001 = rec_irac01.AAB001;
      IF num_count = 0 THEN
         var_yac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'YAC001');
         IF var_yac001 is null THEN
            prm_AppCode := gn_def_ERR ;
            prm_ErrMsg  := 'û�л�ȡ����λ��Ա���к�yac001!';
            RETURN;
         END IF;
         INSERT INTO wsjb.irac01a3 (
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
                     NVL(var_aac001,rec_irac01.AAC001),          -- ���˱��
                     rec_irac01.aab001,
                     rec_irac01.yae181,          -- ֤������
                     rec_irac01.aac002,          -- ���֤����(֤������)
                     rec_irac01.aac003,          -- ����
                     rec_irac01.aac004,          -- �Ա�
                     rec_irac01.aac005,
                     rec_irac01.aac006,          -- ��������
                     rec_irac01.aac007,          -- �μӹ�������
                     rec_irac01.aac008,          -- ��Ա״̬
                     rec_irac01.aac009,
                     rec_irac01.aac010,
                     rec_irac01.aac012,
                     rec_irac01.aac013,
                     rec_irac01.aac014,
                     rec_irac01.aac015,
                     rec_irac01.aac020,
                     rec_irac01.yac067,          -- ��Դ��ʽ
                     rec_irac01.yac168,          -- ũ�񹤱�־
                     rec_irac01.aae004,
                     rec_irac01.aae005,          -- ��ϵ�绰
                     rec_irac01.aae006,          -- ��ַ
                     rec_irac01.aae007,
                     rec_irac01.yae222,
                     rec_irac01.aae013,
                     0,
                     PKG_Constant.YAB003_JBFZX,
                     rec_irac01.aab001,
                     prm_aae011,          -- ������
                     prm_aae036);         -- ����ʱ��
      END IF;
       END IF;
     BEGIN  --��λ����״̬
     SELECT  aab019
      INTO  var_aab019
   FROM ab01
      WHERE aab001 = rec_irac01.AAB001;
    EXCEPTION
   WHEN OTHERS THEN
        prm_AppCode := PKG_Constant.gn_def_ERR;
        prm_ErrMsg  := '��λ����'||prm_aab001||'û�л�ȡ����λ������Ϣ';
        RETURN;
     END;

      IF var_aae140_01 = '1' OR var_aae140_01 = '10' THEN
     --���ϻ������׷ⶥ 2013-12-03
      SELECT pkg_common.fun_p_getcontributionbase(null,rec_irac01.aab001,ROUND(rec_irac01.aac040),'0','01','1','1',rec_irac01.iaa100,prm_yab003)
        INTO num_yac004
        FROM dual;
      --ҽ�ƻ������׷ⶥ
      SELECT pkg_common.fun_p_getcontributionbase(null,rec_irac01.aab001,ROUND(rec_irac01.aac040),'0','03','1','1',rec_irac01.iaa100,prm_yab003)
        INTO num_yac005
        FROM dual;
       --�жϸ��幤�̻�---  20191101  yujj
        IF var_aab019 = '60' THEN
      UPDATE wsjb.irac01
         SET yaa333 = num_yac004,
             yac005 = num_yac005
       WHERE IAC001 = prm_iac001;
     ELSE
            UPDATE wsjb.irac01
         SET yac004 = num_yac004,
             yac005 = num_yac005
       WHERE IAC001 = prm_iac001;
      END IF ;
      END IF ;
      UPDATE wsjb.IRAC01A3
         SET AAE110 = DECODE(var_aae140_01,'1','2','10','2',var_aae140_01),
             AAE120 = DECODE(var_aae140_06,'1','2',var_aae140_06),
             AAE210 = DECODE(var_aae140_02,'1','2',var_aae140_02),
             AAE310 = DECODE(var_aae140_03,'1','2',var_aae140_03),
             AAE410 = DECODE(var_aae140_04,'1','2',var_aae140_04),
             AAE510 = DECODE(var_aae140_05,'1','2',var_aae140_05),
             AAE311 = DECODE(var_aae140_07,'1','2',var_aae140_07),
             AAC040 = rec_irac01.aac040,
             YAC004 = DECODE(var_aae140_01,'1',num_yac004,'10',num_yac004,YAC004),
             YAC005 = num_yac005
       WHERE AAC001 = rec_irac01.aac001
         AND AAB001 = rec_irac01.AAB001;

   EXCEPTION
      WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuAddCheck;

      /*****************************************************************************
   ** �������� : prc_PersonInsuContinue
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��Ա�������]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuContinue(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --��λ����
                                prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                prm_aae036       IN    irac01.aae036%TYPE ,    --����ʱ��
                                prm_AppCode      OUT   VARCHAR2  ,    --�������
                                prm_ErrMsg       OUT   VARCHAR2  )    --��������
    IS
      var_procNo      VARCHAR2(2);         --�������
      num_count       NUMBER;
      var_yac001      VARCHAR2(20);
      var_yae235      VARCHAR2(6);
      var_yae238      VARCHAR2(2000);
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --���˱��
      var_aae140_01   VARCHAR2(2);         --�Ƿ�μ�����ҵ����
      var_aae140_06   VARCHAR2(2);         --�Ƿ�μ��˻�������
      var_aae140_02   VARCHAR2(2);         --�Ƿ�μ���ʧҵ
      var_aae140_03   VARCHAR2(2);         --�Ƿ�μ��˻���ҽ��
      var_aae140_04   VARCHAR2(2);         --�Ƿ�μ��˹���
      var_aae140_05   VARCHAR2(2);         --�Ƿ�μ�������
      var_aae140_07   VARCHAR2(2);         --�Ƿ�μ��˴��
      var_aae140_08   VARCHAR2(2);
      num_yac004      NUMBER(14,2); --���ϻ���
      num_yac005      NUMBER(14,2); --ҽ�ƻ���
      rec_irac01      irac01%rowtype;
       v_aad055       VARCHAR2(100);
      irac01_aac001   VARCHAR2(15);
      irac01a3_aac001 VARCHAR2(15);
      AAC001_NEW_OLD  VARCHAR2(15);
      --YAC200_NEW      VARCHAR2(6);
      var_aab019       ab01.aab019%TYPE;             --��λ����  ��Ҫ���ָ��幤�˻�   yujj 20191101

   BEGIN
      prm_AppCode  := PKG_Constant.GN_DEF_OK;
      prm_ErrMsg   := '';
      var_aac001   := '';

      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      var_aae140_01 := rec_irac01.aae110;        --�Ƿ�μ�����ҵ����
      var_aae140_06 := rec_irac01.aae120;        --�Ƿ�μ��˻�������
      var_aae140_02 := rec_irac01.aae210;        --�Ƿ�μ���ʧҵ
      var_aae140_03 := rec_irac01.aae310;        --�Ƿ�μ��˻���ҽ��
      var_aae140_04 := rec_irac01.aae410;        --�Ƿ�μ��˹���
      var_aae140_05 := rec_irac01.aae510;        --�Ƿ�μ�������
      var_aae140_07 := rec_irac01.aae311;        --�Ƿ�μ��˴��
      var_aae140_08 := rec_irac01.aae810;

      IF var_aae140_01 ='10'  OR var_aae140_01 ='1'
       OR  var_aae140_06 = '1' OR var_aae140_02 = '1'
      OR var_aae140_03 = '1' OR var_aae140_04 = '1'
      OR var_aae140_05 = '1' OR var_aae140_07 = '1' OR var_aae140_08 = '1'
      OR var_aae140_06 = '10' OR var_aae140_02 = '10'
      OR var_aae140_03 = '10' OR var_aae140_04 = '10'
      OR var_aae140_05 = '10' OR var_aae140_07 = '10'
      OR var_aae140_08 = '10' THEN
         --д����ʱ������
         PKG_COMMON.PRC_P_insertAe16Tmp(prm_yae099,
                                       prm_iac001,
                                       '04', --������������
                                       prm_aab001,
                                       prm_aae011,
                                       prm_AppCode,
                                       prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;
         --��ʱ������У��
         xasi2.pkg_p_Person_Batch.prc_p_Person_Continue_check(prm_yae099,
                                                           prm_aab001,
                                                           PKG_Constant.YAB003_JBFZX,
                                                           prm_aae011,
                                                           PKG_Constant.YAB003_JBFZX,
                                                           prm_AppCode,
                                                           prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;

         SELECT yae235,NVL(yae238,''),aad055
           INTO var_yae235,var_yae238,v_aad055
           FROM xasi2.AE16A1
          WHERE YAE099 = prm_yae099;
         IF var_yae235 = '2' THEN
            prm_AppCode := PKG_Constant.gn_def_ERR;
            prm_ErrMsg  := '��Ա�α���ϢУ��ʧ��:'||var_yae238||v_aad055;
            RETURN;
         END IF;


          --modify by wangz at 20181112 begin
          -- ȡ���˱��  �����������������ac01 ��  ��  ac01��
        begin
          SELECT AAC001
            INTO AAC001_NEW_OLD
            FROM wsjb.IRAC01
           WHERE IAC001 = prm_iac001;
        exception
          when others then
            goto update_ac01_label;
        end;
        --modify by wangz at 20181112 end


         --modify by wanghm at 2018-12-21 begin
       -- �±����ͨ�����������Ϣ
       PKG_Insurance.prc_PersonInfoRepair(prm_yae099, --ҵ����ˮ��
                               prm_iac001,--�걨���
                               AAC001_NEW_OLD, --���˱��
                               rec_irac01.aac002 , --֤������
                               prm_aab001, --��λ������
                               prm_aae011, --������
                               prm_AppCode, --�������
                               prm_ErrMsg); --��������
          IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;
        --modify by wanghm at 2018-12-21 end

         <<update_ac01_label>>
           null;


         --���������²α��������ݵ���
         xasi2.pkg_p_Person_Batch.prc_p_Person_Continue_treat(prm_yae099,
                                                        prm_aab001,
                                                        '1'       ,    --'1' ֻ������ɹ���--'2' ������ڼ��ʧ������
                                                        PKG_Constant.YAB003_JBFZX,
                                                        prm_aae011,
                                                        PKG_Constant.YAB003_JBFZX,
                                                        prm_AppCode,
                                                        prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;




        /* SELECT NVL(AAD059,'')
           INTO var_aac001
           FROM xasi2_zs.AE16A1
          WHERE YAE099 = prm_yae099;
         IF var_aac001 = '' THEN
            prm_AppCode := PKG_Constant.gn_def_ERR;
            prm_ErrMsg  := '��Ա��Ų�����!��Ա�²α�ʧ��!';
            RETURN;
         END IF;

          --�����걨��Ϣ����Ա���
         UPDATE IRAC01
            SET AAC001 = var_aac001
          WHERE IAC001 = prm_iac001;

         --�����걨��ϸ��Ϣ����Ա���
         UPDATE IRAD02
            SET IAZ008 = var_aac001
          WHERE IAZ007 = prm_iac001;  */

         /**  whm begin
        --modify by wangz at 20181112 begin
        SELECT AAC001,YAC200
          INTO AAC001_NEW_OLD,YAC200_NEW
          FROM wsjb.IRAC01
         WHERE IAC001 = prm_iac001;
        --modify by wangz at 20181112 end

         --modify by wangz at 20181126 begin
         --���Ĺ���Աְ��
              UPDATE xasi2.ac01
                SET YAC200=YAC200_NEW
            WHERE aac001=AAC001_NEW_OLD;
        --modify by wangz at 20181126 end
          whm end **/



         --���²α���Ա��ִ��Ϣ
         UPDATE xasi2.AC02
            SET AAE013 = AAE013||'��������Դ�����Ͼ���ҵ��ϵͳ'
          WHERE aac001 = rec_irac01.aac001
            and aae011 = prm_aae011;
      END IF;

      --���α���λ�Ƿ���ڸ���Ա��Ϣ
      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.IRAC01A3
       WHERE AAC001 = NVL(AAC001_NEW_OLD,rec_irac01.AAC001)
         AND AAB001 = rec_irac01.AAB001;
      IF num_count = 0 THEN
         var_yac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'YAC001');
         IF var_yac001 is null THEN
            prm_AppCode := gn_def_ERR ;
            prm_ErrMsg  := 'û�л�ȡ����λ��Ա���к�yac001!';
            RETURN;
         END IF;
         INSERT INTO wsjb.irac01a3 (
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
                     NVL(AAC001_NEW_OLD,rec_irac01.AAC001),          -- ���˱��
                     rec_irac01.aab001,
                     rec_irac01.yae181,          -- ֤������
                     rec_irac01.aac002,          -- ���֤����(֤������)
                     rec_irac01.aac003,          -- ����
                     rec_irac01.aac004,          -- �Ա�
                     rec_irac01.aac005,
                     rec_irac01.aac006,          -- ��������
                     rec_irac01.aac007,          -- �μӹ�������
                     rec_irac01.aac008,          -- ��Ա״̬
                     rec_irac01.aac009,
                     rec_irac01.aac010,
                     rec_irac01.aac012,
                     rec_irac01.aac013,
                     rec_irac01.aac014,
                     rec_irac01.aac015,
                     rec_irac01.aac020,
                     rec_irac01.yac067,          -- ��Դ��ʽ
                     rec_irac01.yac168,          -- ũ�񹤱�־
                     rec_irac01.aae004,
                     rec_irac01.aae005,          -- ��ϵ�绰
                     rec_irac01.aae006,          -- ��ַ
                     rec_irac01.aae007,
                     rec_irac01.yae222,
                     rec_irac01.aae013,
                     0,
                     PKG_Constant.YAB003_JBFZX,
                     rec_irac01.aab001,
                     prm_aae011,          -- ������
                     prm_aae036);         -- ����ʱ��
      END IF;


  --  �����걨���ݺ�������Ϣ����
        BEGIN
         SELECT aac001  INTO irac01_aac001  FROM wsjb.irac01
                     WHERE aac002 =  rec_irac01.AAC002
                     AND aab001 =  prm_aab001
                     AND  IAA002='1'
                     AND IAA001 <> '4'
                     AND iaa100 = rec_irac01.iaa100;
          SELECT aac001  INTO irac01a3_aac001   FROM wsjb.irac01a3
                     WHERE  aac002 = rec_irac01.AAC002 AND aab001 =  prm_aab001;

           EXCEPTION

              WHEN NO_DATA_FOUND THEN
                 RETURN;
              WHEN TOO_MANY_ROWS THEN
                 prm_AppCode  :=  PKG_Constant.gn_def_ERR;
                 prm_ErrMsg   :=  '����Ա'|| rec_irac01.AAC002 ||'Ϊ������Ա����ѡ������һ�����˱���ٽ��в���';
                  RETURN;

          WHEN OTHERS THEN

              IF    irac01_aac001   <>  irac01a3_aac001 THEN
             prm_AppCode  :=  PKG_Constant.gn_def_ERR;
             prm_ErrMsg   := 'irac01'||irac01_aac001||'��irac01a3'||irac01a3_aac001||'��Ϣ��ƥ��!';
              END IF;
             RETURN;
         END;
          --  end 20190613
     BEGIN  --��λ����״̬
     SELECT  aab019
      INTO  var_aab019
   FROM ab01
      WHERE aab001 = rec_irac01.AAB001;
    EXCEPTION
   WHEN OTHERS THEN
        prm_AppCode := PKG_Constant.gn_def_ERR;
        prm_ErrMsg  := '��λ����'||prm_aab001||'û�л�ȡ����λ������Ϣ';
        RETURN;
     END;
      IF var_aae140_01 = '1' OR var_aae140_01 = '10' THEN
        --���ϻ������׷ⶥ
        SELECT pkg_common.fun_p_getcontributionbase(null,rec_irac01.aab001,ROUND(rec_irac01.aac040),'0','01','1','1',rec_irac01.iaa100,prm_yab003)
          INTO num_yac004
          FROM dual;

        --ҽ�ƻ������׷ⶥ
        SELECT pkg_common.fun_p_getcontributionbase(null,rec_irac01.aab001,ROUND(rec_irac01.aac040),'0','03','1','1',rec_irac01.iaa100,prm_yab003)
          INTO num_yac005
          FROM dual;
       --�жϸ��幤�̻�---  20191101  yujj
        IF var_aab019 = '60' THEN
      UPDATE wsjb.irac01
         SET yaa333 = num_yac004,
             yac005 = num_yac005
       WHERE IAC001 = prm_iac001;
     ELSE
            UPDATE wsjb.irac01
         SET yac004 = num_yac004,
             yac005 = num_yac005
       WHERE IAC001 = prm_iac001;
      END IF ;
      END IF ;

      SELECT aac001 INTO var_aac001
        FROM wsjb.irac01
        WHERE iac001 = prm_iac001;

      UPDATE wsjb.IRAC01A3
         SET AAE110 = DECODE(var_aae140_01,'1','2','10','2',var_aae140_01),
             AAE120 = DECODE(var_aae140_06,'1','2','10','2',var_aae140_06),
             AAE210 = DECODE(var_aae140_02,'1','2','10','2',var_aae140_02),
             AAE310 = DECODE(var_aae140_03,'1','2','10','2',var_aae140_03),
             AAE410 = DECODE(var_aae140_04,'1','2','10','2',var_aae140_04),
             AAE510 = DECODE(var_aae140_05,'1','2','10','2',var_aae140_05),
             AAE311 = DECODE(var_aae140_07,'1','2','10','2',var_aae140_07),
             AAC040 = rec_irac01.aac040,
             YAC004 = DECODE(var_aae140_01,'1',num_yac004,'10',num_yac004,YAC004),
             YAC005 = num_yac005,
             AAC001 = var_aac001
       WHERE AAC001 = NVL(AAC001_NEW_OLD,rec_irac01.AAC001)
         AND AAB001 = rec_irac01.AAB001;

   EXCEPTION
      WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuContinue;

   /*****************************************************************************
   ** �������� : prc_PersonInsuPause
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��Աͣ�����]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuPause(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                             prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --��λ����
                             prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                             prm_aae011       IN    irac01.aae011%TYPE ,    --������
                             prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                             prm_aae036       IN    irac01.aae036%TYPE ,    --����ʱ��
                             prm_AppCode      OUT   VARCHAR2  ,    --�������
                             prm_ErrMsg       OUT   VARCHAR2  )    --��������
   IS
      var_procNo      VARCHAR2(2);         --�������
      num_count       NUMBER;
      var_yac001      VARCHAR2(20);
      var_yae235      VARCHAR2(6);
      var_yae238      VARCHAR2(2000);
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --���˱��
      var_aae140_01   VARCHAR2(2);         --�Ƿ�μ�����ҵ����
      var_aae140_06   VARCHAR2(2);         --�Ƿ�μ��˻�������
      var_aae140_02   VARCHAR2(2);         --�Ƿ�μ���ʧҵ
      var_aae140_03   VARCHAR2(2);         --�Ƿ�μ��˻���ҽ��
      var_aae140_04   VARCHAR2(2);         --�Ƿ�μ��˹���
      var_aae140_05   VARCHAR2(2);         --�Ƿ�μ�������
      var_aae140_07   VARCHAR2(2);         --�Ƿ�μ��˴��
      var_aae140_08   VARCHAR2(2);
      rec_irac01      irac01%rowtype;
       v_aad055       VARCHAR2(100);
       prm_aac001_out   VARCHAR2(10);
   BEGIN
      prm_AppCode  := PKG_Constant.GN_DEF_OK;
      prm_ErrMsg   := '';
      var_aac001   := '';

      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      var_aae140_01 := rec_irac01.aae110;        --�Ƿ�μ�����ҵ����
      var_aae140_06 := rec_irac01.aae120;        --�Ƿ�μ��˻�������
      var_aae140_02 := rec_irac01.aae210;        --�Ƿ�μ���ʧҵ
      var_aae140_03 := rec_irac01.aae310;        --�Ƿ�μ��˻���ҽ��
      var_aae140_04 := rec_irac01.aae410;        --�Ƿ�μ��˹���
      var_aae140_05 := rec_irac01.aae510;        --�Ƿ�μ�������
      var_aae140_07 := rec_irac01.aae311;        --�Ƿ�μ��˴��
      var_aae140_08 := rec_irac01.aae810;

      IF var_aae140_06 = '3' OR var_aae140_02 = '3'
      OR var_aae140_03 = '3' OR var_aae140_04 = '3'
      OR var_aae140_05 = '3' OR var_aae140_07 = '3'
      OR var_aae140_08 = '3' THEN
         --д����ʱ������
         PKG_COMMON.PRC_P_insertAe16Tmp(prm_yae099,
                                       prm_iac001,
                                       '03', --����������ͣ
                                       prm_aab001,
                                       prm_aae011,
                                       prm_AppCode,
                                       prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;
         --��ʱ������У��
         xasi2.pkg_p_Person_Batch.prc_p_Person_pause_check(prm_yae099,
                                                           prm_aab001,
                                                           PKG_Constant.YAB003_JBFZX,
                                                           prm_aae011,
                                                           PKG_Constant.YAB003_JBFZX,
                                                           prm_AppCode,
                                                           prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;

         SELECT yae235,NVL(yae238,''),aad055
           INTO var_yae235,var_yae238,v_aad055
           FROM xasi2.AE16A1
          WHERE YAE099 = prm_yae099;
         IF var_yae235 = '2' THEN
            prm_AppCode := PKG_Constant.gn_def_ERR;
            prm_ErrMsg  := '��Ա�α���ϢУ��ʧ��:'||var_yae238||v_aad055;
            RETURN;
         END IF;

         --����������ͣ�������ݵ���
         xasi2.pkg_p_Person_Batch.prc_p_Person_pause_treat(prm_yae099,
                                                        prm_aab001,
                                                        '1'       ,    --'1' ֻ������ɹ���--'2' ������ڼ��ʧ������
                                                        PKG_Constant.YAB003_JBFZX,
                                                        prm_aae011,
                                                        PKG_Constant.YAB003_JBFZX,
                                                        prm_AppCode,
                                                        prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;

      END IF;

           UPDATE wsjb.IRAC01A3
         SET AAE110 = DECODE(var_aae140_01,'3','0',var_aae140_01),
             AAE120 = DECODE(var_aae140_06,'3','0',var_aae140_06),
             AAE210 = DECODE(var_aae140_02,'3','0',var_aae140_02),
             AAE310 = DECODE(var_aae140_03,'3','0',var_aae140_03),
             AAE410 = DECODE(var_aae140_04,'3','0',var_aae140_04),
             AAE510 = DECODE(var_aae140_05,'3','0',var_aae140_05),
             AAE311 = DECODE(var_aae140_07,'3','0',var_aae140_07)
       WHERE AAC001 = rec_irac01.aac001
         AND AAB001 = rec_irac01.AAB001;


   EXCEPTION
      WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuPause;

   /*****************************************************************************
   ** �������� : prc_PersonInsuToRetire
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��ְת�������]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuToRetire(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                    prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --��λ����
                                    prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                    prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                    prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                    prm_aae036       IN    irac01.aae036%TYPE ,    --����ʱ��
                                    prm_AppCode      OUT   VARCHAR2  ,    --�������
                                    prm_ErrMsg       OUT   VARCHAR2  )    --��������
   IS
      var_procNo      VARCHAR2(2);         --�������
      num_count       NUMBER;
      var_yac001      VARCHAR2(20);
      var_yae235      VARCHAR2(6);
      var_yae238      VARCHAR2(2000);
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --���˱��
      var_aae140_01   VARCHAR2(2);         --�Ƿ�μ�����ҵ����
      var_aae140_06   VARCHAR2(2);         --�Ƿ�μ��˻�������
      var_aae140_02   VARCHAR2(2);         --�Ƿ�μ���ʧҵ
      var_aae140_03   VARCHAR2(2);         --�Ƿ�μ��˻���ҽ��
      var_aae140_04   VARCHAR2(2);         --�Ƿ�μ��˹���
      var_aae140_05   VARCHAR2(2);         --�Ƿ�μ�������
      var_aae140_07   VARCHAR2(2);         --�Ƿ�μ��˴��
      var_aae140_08   VARCHAR2(2);
      rec_irac01      irac01%rowtype;

   BEGIN
      prm_AppCode  := PKG_Constant.GN_DEF_OK;
      prm_ErrMsg   := '';
      var_aac001   := '';

      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      var_aae140_01 := rec_irac01.aae110;        --�Ƿ�μ�����ҵ����
      var_aae140_06 := rec_irac01.aae120;        --�Ƿ�μ��˻�������
      var_aae140_02 := rec_irac01.aae210;        --�Ƿ�μ���ʧҵ
      var_aae140_03 := rec_irac01.aae310;        --�Ƿ�μ��˻���ҽ��
      var_aae140_04 := rec_irac01.aae410;        --�Ƿ�μ��˹���
      var_aae140_05 := rec_irac01.aae510;        --�Ƿ�μ�������
      var_aae140_07 := rec_irac01.aae311;        --�Ƿ�μ��˴��
      var_aae140_08 := rec_irac01.aae810;

     /* IF var_aae140_06 = '3' OR var_aae140_02 = '3'
      OR var_aae140_03 = '3' OR var_aae140_04 = '3'
      OR var_aae140_05 = '3' OR var_aae140_07 = '3' THEN*/
          xasi2.pkg_p_gxPackge.prc_p_txsqsh(prm_yae099,
                                               rec_irac01.AAC001,
                                               rec_irac01.AAB001,
                                               prm_aae011,
                                               sysdate,
                                               PKG_Constant.YAB003_JBFZX,
                                               PKG_Constant.YAB003_JBFZX,
                                               prm_AppCode,
                                               prm_ErrMsg);
         IF prm_AppCode <> gn_def_OK THEN
            ROLLBACK;
            RETURN;
         END IF;
      /*END IF;*/

      UPDATE wsjb.IRAC01A3
         SET AAE110 = DECODE(var_aae140_01,'3','0',var_aae140_01),
             AAE120 = DECODE(var_aae140_06,'3','0',var_aae140_06),
             AAE210 = DECODE(var_aae140_02,'3','0',var_aae140_02),
             AAE310 = DECODE(var_aae140_03,'3','0',var_aae140_03),
             AAE410 = DECODE(var_aae140_04,'3','0',var_aae140_04),
             AAE510 = DECODE(var_aae140_05,'3','0',var_aae140_05),
             AAE311 = DECODE(var_aae140_07,'3','0',var_aae140_07)
       WHERE AAC001 = rec_irac01.aac001
         AND AAB001 = rec_irac01.AAB001;

   EXCEPTION
      WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuToRetire;

   /*****************************************************************************
   ** �������� : prc_AuditSocietyInsuranceR
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����ᱣ�յǼ����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_iaa011       IN     iraa02.iaa011%TYPE,--ҵ������
   **           prm_iaa003       IN     iraa02.iaa003%TYPE,--ҵ������
   **           prm_iaa004       IN     iraa02.iaa011%TYPE,--��˱�־
   **           prm_iaa028       IN     VARCHAR2          ,--�Ƿ�ȫ��
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_aae013       IN     iraa02.aae013%TYPE,--��ע
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-21   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_AuditSocietyInsuranceR (
      prm_iaa011       IN     iraa02.iaa011%TYPE,--ҵ������
      prm_iaa003       IN     iraa02.iaa003%TYPE,--ҵ������
      prm_iaa018       IN     irad22.iaa018%TYPE,--��˱�־
      prm_iaa028       IN     VARCHAR2          ,--�Ƿ�ȫ��
      prm_aae011       IN     iraa02.iaa011%TYPE,--������
      prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
      prm_aae013       IN     iraa02.aae013%TYPE,--��ע
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      n_count    number(2);
      v_iaz011   varchar2(15);
      v_iaz009   varchar2(15);
      v_iaz010   varchar2(15);
      v_aaz002   varchar2(15);
      v_iaa015   varchar2(1);
      v_iaa004   number(1);
      v_iaa014   number(1);
      v_iaa017   number(1);
      v_yae099   varchar2(15);

      --�����α꣬��ȡ���������Ա��Ϣ
      CURSOR cur_tmp_person IS
      SELECT IAC001, --�걨��Ա��Ϣ���,VARCHAR2
             AAC001, --���˱��,VARCHAR2
             AAB001, --��λ���,VARCHAR2
             AAC002, --������ݺ���,VARCHAR2
             AAC003, --����,VARCHAR2
             IAA001, --��Ա���
             IAZ005, --�걨��ϸID
             IAA003  --ҵ������
        FROM wsjb.IRAD22_TMP  --���������Ա��Ϣ��ʱ��
        ORDER by iaa003;

   BEGIN

      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;


      /*�����ʱ���Ƿ��������*/
      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.IRAD22_TMP ;
      IF n_count = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'�����ʱ���޿�������!';
         RETURN;
      END IF;


      /*��Ҫ������У��*/
      IF prm_iaa011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'ҵ�����Ͳ���Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa003 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'ҵ�����岻��Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa018 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'��˱�־����Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa028 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'��־[�Ƿ�ȫ��]����Ϊ��!';
         RETURN;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
      IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�AAZ002!';
         RETURN;
      END IF;

      v_iaz009 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ009');
      IF v_iaz009 IS NULL OR v_iaz009 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�IAZ009!';
         RETURN;
      END IF;

      --����¼�
      INSERT INTO wsjb.IRAD21
                 (
                  IAZ009,
                  AAZ002,
                  IAA011,
                  AEE011,
                  AAE035,
                  YAB003,
                  AAE013
                  )
                  VALUES
                  (
                  v_iaz009,
                  v_aaz002,
                  prm_iaa011,
                  prm_aae011,
                  sysdate,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae013
      );

      FOR REC_TMP_PERSON IN cur_tmp_person LOOP

         --�걨�����Ǹ���ʱУ�飺���뵥λ��Ϣ���ͨ�����ܰ���
         IF REC_TMP_PERSON.iaa003 = PKG_Constant.IAA003_PER THEN
            SELECT COUNT(1)
              INTO n_count
              FROM wsjb.IRAB01
             WHERE AAB001 = REC_TMP_PERSON.AAB001
               AND IAA002 = PKG_Constant.IAA002_APS;
            IF n_count = 0 THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'��ᱣ�յǼ����ʱ���뵥λ��Ϣ���ͨ�����ܰ�����Ա��Ϣ���!';
               RETURN;
            END IF;
         END IF;
         /*
            ������Ե�λΪҵ������[��˵��ǵ�λ��Ϣ]
            ���԰�����д�� ���ͨ�� ��ͨ��
         */
          /*
            ��֮�������Ա����Ϣ���
            ���԰�����Ǵ�� ͨ�� ��ͨ�� ����ͨ�� ȫ��ͨ�� ȫ��ͨ��
         */

         --�����ϸ����
         v_iaz010 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ010');
         IF v_iaz010 IS NULL OR v_iaz010 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�IAZ010!';
            RETURN;
         END IF;

         --��ѯ�ϴ�������
         BEGIN
            SELECT IAA015
              INTO v_iaa015
              FROM wsjb.IRAD02
             WHERE IAZ005 = REC_TMP_PERSON.IAZ005;

            IF v_iaa015 in (PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
              prm_ErrorMsg := PRE_ERRCODE ||'����Ѿ��ս�!';
              RETURN;
           END IF;

            --��ȡ�ϴ������Ϣ
            IF v_iaa015 = PKG_Constant.IAA015_ADI THEN
               BEGIN
                  SELECT A.IAZ010,
                         A.IAA004,
                         A.IAA014,
                         A.IAA017
                    INTO v_iaz011,
                         v_iaa004,
                         v_iaa014,
                         v_iaa017
                    FROM wsjb.IRAD22  A
                   WHERE A.IAA018 NOT IN (
                                          PKG_Constant.IAA018_DAD, --���[�������]
                                          PKG_Constant.IAA018_NPS  --��ͨ�� Not Pass
                                         )
                     AND A.IAZ005 = REC_TMP_PERSON.IAZ005
                     AND A.IAZ010 = (
                                      SELECT MAX(IAZ010)
                                        FROM wsjb.IRAD22
                                       WHERE IAZ005 = A.IAZ005
                                         AND IAA018 = A.IAA018
                                    );
                  EXCEPTION
                  WHEN OTHERS THEN
                     ROLLBACK;
                     prm_AppCode  := gn_def_ERR;
                     prm_ErrorMsg := PRE_ERRCODE ||'�걨��Ϣ��������У���δ��ȡ���ϴ������Ϣ,��ȷ���ϴ�����Ƿ��ս�!';
                     RETURN;
               END;

               v_iaa014 := v_iaa017;
               v_iaa017 := v_iaa017 + 1;
               IF v_iaa017 > v_iaa004 THEN
                  v_iaa017 := v_iaa004;
               END IF;

               --��˼��ε��ڵ�ǰ����
               IF v_iaa004 = v_iaa014 AND v_iaa004 = v_iaa017 THEN
                  ROLLBACK;
                  prm_AppCode  := gn_def_ERR;
                  prm_ErrorMsg := PRE_ERRCODE ||'����Ѿ��ս�!';
                  RETURN;
               END IF;
            END IF;

            --��ȡ�걨��ϸ��Ϣ
            IF v_iaa015 = PKG_Constant.IAA015_WAD THEN
               BEGIN
                  SELECT A.IAA004,
                         A.IAA014
                    INTO v_iaa004,
                         v_iaa014
                    FROM wsjb.IRAD02  A
                   WHERE A.IAZ005 = REC_TMP_PERSON.IAZ005;
                  EXCEPTION
                  WHEN OTHERS THEN
                     ROLLBACK;
                     prm_AppCode  := gn_def_ERR;
                     prm_ErrorMsg := PRE_ERRCODE ||'û����ȡ���걨��ϸ��Ϣ!';
                     RETURN;
               END;
               v_iaz011 := v_iaz010;
               v_iaa014 := v_iaa014 + 1;
               v_iaa017 := v_iaa014 + 1;
               IF v_iaa017 > v_iaa004 THEN
                  v_iaa017 := v_iaa004;
               END IF;
            END IF;

            EXCEPTION
            WHEN OTHERS THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := '�����Ϣ��ȡ����:'|| PRE_ERRCODE || SQLERRM ||dbms_utility.format_error_backtrace ;
               RETURN;
         END;

         --�����ϸд��
         INSERT INTO wsjb.IRAD22
                    (
                     IAZ010,
                     IAZ011,
                     IAZ009,
                     IAZ005,
                     IAA004,
                     IAA014,
                     IAA017,
                     AAE011,
                     AAE035,
                     YAB003,
                     IAA018,
                     IAD005,    --������
                     AAE013
                     )
                    VALUES
                    (
                     v_iaz010,
                     v_iaz011,
                     v_iaz009,
                     REC_TMP_PERSON.IAZ005,
                     v_iaa004,
                     v_iaa014,
                     v_iaa017,
                     prm_aae011,
                     sysdate,
                     PKG_Constant.YAB003_JBFZX,
                     prm_iaa018,
                     prm_aae013,  --������
                     null
         );

         --���
         IF prm_iaa018 = PKG_Constant.IAA018_DAD THEN

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_DAD, --���[�޸�����]
                   AAE013 = prm_aae013
             WHERE IAA015 = PKG_Constant.IAA015_WAD --����
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '1' THEN
               --�����걨��λ״̬
               UPDATE wsjb.IRAB01
                  SET IAA002 = PKG_Constant.IAA002_ALR  --�Ѵ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAB001 = REC_TMP_PERSON.AAB001;
            END IF;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --�����걨��Ա״̬
               UPDATE wsjb.irac01
                  SET IAA002 = PKG_Constant.IAA002_ALR  --�Ѵ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --���δͨ��
         IF prm_iaa018 = PKG_Constant.IAA018_NPS THEN

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_ADO, --������
                   AAE013 = prm_aae013
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --����/�����
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '1' THEN
               --�����걨��λ״̬
               UPDATE wsjb.IRAB01
                  SET IAA002 = PKG_Constant.IAA002_NPS  --δͨ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAB001 = REC_TMP_PERSON.AAB001;
            END IF;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --�����걨��Ա״̬
               UPDATE wsjb.irac01
                  SET IAA002 = PKG_Constant.IAA002_NPS  --δͨ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --���ͨ��
         IF prm_iaa018 = PKG_Constant.IAA018_PAS AND v_iaa014 = v_iaa004 THEN

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015  =  PKG_Constant.IAA015_ADO --������
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --����/�����
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            v_yae099    := xasi2.PKG_comm.fun_GetSequence(NULL,'yae099');
            IF v_yae099 IS NULL OR v_yae099 = '' THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ��ϵͳ������к�:YAE099';
               RETURN;
            END IF;

            IF REC_TMP_PERSON.iaa003 = '1' THEN
               --�����걨��λ״̬
               UPDATE wsjb.IRAB01
                  SET IAA002 = PKG_Constant.IAA002_APS  --��ͨ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAB001 = REC_TMP_PERSON.AAB001;

               /*
                  �籣ϵͳ����¼�� ��λ��Ϣ ��λ������Ϣ
               */
               /*
               prc_AuditSocietyInsuranceREmp(v_yae099,
                                             REC_TMP_PERSON.AAB001,
                                             prm_aae011,
                                             PKG_Constant.YAB003_JBFZX,
                                             prm_AppCode,
                                             prm_ErrorMsg);
               IF prm_AppCode <> gn_def_OK THEN
                  ROLLBACK;
                  RETURN;
               END IF;*/
               UPDATE xasi2.AB01
                  SET(AB01.AAB002,
                      AB01.AAB003,
                      AB01.AAB004,
                      AB01.AAB005,
                      AB01.AAB006,
                      AB01.AAB007,
                      AB01.AAB008,
                      AB01.AAB009,
                      AB01.AAB010,
                      AB01.AAB011,
                      AB01.AAB012,
                      AB01.AAB013,
                      --AB01.YAB136,
                      AB01.AAB019,
                      AB01.AAB020,
                      AB01.AAB021,
                      AB01.AAB022,
                      AB01.YLB001,
                      AB01.YAB391,
                      AB01.YAB388,
                      AB01.YAB389,
                      AB01.AAB015,
                      AB01.YAB515,
                      AB01.YAB516,
                      AB01.AAB016,
                      AB01.YAB237,
                      AB01.YAB390,
                      AB01.AAB018,
                      AB01.YAB517,
                      AB01.AAB023,
                      AB01.YAB518,
                      AB01.AAE007,
                      AB01.AAE006,
                      AB01.YAE225,
                      AB01.YAB519,
                      AB01.YAB520,
                      AB01.AAE014,
                      AB01.AAB034,
                      AB01.AAB301,
                      AB01.YAB322,
                      AB01.YAB274,
                      AB01.YAB525,
                      AB01.YAB524,
                      AB01.YAB521,
                      AB01.YAB522,
                      AB01.YAB523,
                      AB01.YAB236,
                      --AB01.AAE119,
                      --AB01.YAB275,
                      AB01.YAE496,
                      AB01.YAE407,
                      AB01.AAE013,
                      AB01.AAE011,
                      AB01.AAE036,
                      AB01.YAE443,
                      AB01.YAB553,
                      AB01.AAB304,
                      AB01.YAE393,
                      AB01.YAB554,
                      AB01.YKB110,
                      AB01.YKB109,
                      AB01.YAB566,
                      AB01.YAB565,
                      AB01.YAB279,
                      AB01.YAB003,
                      AB01.AAF020,
                      AB01.AAB343,
                      AB01.AAB030
                      )=
                  (SELECT B.AAB002,
                          B.AAB003,
                          B.AAB004,
                          B.AAB005,
                          B.AAB006,
                          B.AAB007,
                          B.AAB008,
                          B.AAB009,
                          B.AAB010,
                          B.AAB011,
                          B.AAB012,
                          B.AAB013,
                          --B.YAB136,
                          B.AAB019,
                          B.AAB020,
                          B.AAB021,
                          B.AAB022,
                          B.YLB001,
                          B.YAB391,
                          B.YAB388,
                          B.YAB389,
                          B.AAB015,
                          B.YAB515,
                          B.YAB516,
                          B.AAB016,
                          B.YAB237,
                          B.YAB390,
                          B.AAB018,
                          B.YAB517,
                          B.AAB023,
                          B.YAB518,
                          B.AAE007,
                          B.AAE006,
                          B.YAE225,
                          B.YAB519,
                          B.YAB520,
                          B.AAE014,
                          B.AAB034,
                          B.AAB301,
                          B.YAB322,
                          B.YAB274,
                          B.YAB525,
                          B.YAB524,
                          B.YAB521,
                          B.YAB522,
                          B.YAB523,
                          B.YAB236,
                          --B.AAE119,
                          --B.YAB275,
                          B.YAE496,
                          B.YAE407,
                          B.AAE013,
                          B.AAE011,
                          B.AAE036,
                          B.YAE443,
                          B.YAB553,
                          B.AAB304,
                          B.YAE393,
                          B.YAB554,
                          B.YKB110,
                          B.YKB109,
                          B.YAB566,
                          B.YAB565,
                          B.YAB279,
                          B.YAB003,
                          B.AAF020,
                          B.AAB343,
                          B.AAB030
                     FROM wsjb.IRAB01  B
                    WHERE B.IAB001 = B.AAB001
                      AND B.AAB001 = REC_TMP_PERSON.AAB001
                  )
               WHERE aab001 = REC_TMP_PERSON.AAB001;
            END IF;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --�����걨��Ա״̬
               UPDATE wsjb.irac01
                  SET IAA002 = PKG_Constant.IAA002_APS  --��ͨ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAC001 = REC_TMP_PERSON.IAC001;

               /*
                  �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ
               */
               prc_AuditSocietyInsuranceRPer(v_yae099,
                                             REC_TMP_PERSON.AAB001,
                                             REC_TMP_PERSON.IAC001,
                                             prm_aae011,
                                             PKG_Constant.YAB003_JBFZX,
                                             sysdate,
                                             prm_AppCode,
                                             prm_ErrorMsg);
               IF prm_AppCode <> gn_def_OK THEN
                  ROLLBACK;
                  RETURN;
               END IF;
            END IF;

            INSERT INTO wsjb.AE02A1
                        (
                         AAZ002,
                         YAE099,
                         IAA020,
                         AAB001,
                         AAC001,
                         IAA001
                        )
                  VALUES(
                        v_aaz002,
                        v_yae099,
                        REC_TMP_PERSON.iaa003,
                        REC_TMP_PERSON.AAB001,
                        REC_TMP_PERSON.IAC001,
                        REC_TMP_PERSON.IAA001
                        );
         END IF;

      END LOOP;

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
                  AAE218,
                  AAE013
                 )
                 VALUES
                 (
                  v_aaz002,
                  PKG_Constant.AAA121_SIA,
                  prm_aae011,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae011,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate,
                  prm_aae013
                 );
   EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace  ;
         RETURN;
   END prc_AuditSocietyInsuranceR;


   /*****************************************************************************
   ** �������� : prc_AuditSocietyInsuranceREmp
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����ᱣ�յǼ����[��λ�α�]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-22   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_AuditSocietyInsuranceREmp (
      prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
      prm_aab001       IN     irab01.aab001%TYPE,--��λ������
      prm_aae011       IN     iraa02.iaa011%TYPE,--������
      prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   AS
      n_count    number(2);
      v_yab136   irab01.yab136%TYPE;
      v_yab275   irab01.yab275%TYPE;
      v_ylb001   irab01.ylb001%TYPE;
      v_yab380   irab01.yab380%TYPE;
      v_aaa040   xasi2.ab02.aaa040%TYPE;
      v_aab033   varchar2(2);
      v_aab001   varchar2(15);
      v_aae110   varchar2(2);
      v_aae120   varchar2(2);
      v_aae210   varchar2(2);
      v_aae310   varchar2(2);
      v_aae410   varchar2(2);
      v_aae510   varchar2(2);
      v_aae311   varchar2(2);
      t_cols     tab_change;
      n_aae001   NUMBER(4);
      n_aae001_aa35   NUMBER(4);
      d_aae030   irab01.aae036%TYPE;
      n_aae001_ab05 NUMBER(4);
      v_aab019   VARCHAR2(6);

      v_aab022   varchar2(6);
      v_aaa103   VARCHAR2(1000);

   BEGIN

       /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;
      v_aab033     := '04';--Ĭ�ϵ�˰����;


      SELECT COUNT(1)
        INTO n_count
        FROM xasi2.ab01
       WHERE AAB001 = PRM_AAB001;
      IF n_count > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE || '�Ѿ����ڸõ�λ��Ϣ!'||PRM_AAB001;
         RETURN;
      END IF;

       SELECT NVL(AAE110,'0') AAE110,
              NVL(AAE120,'0') AAE120,
              NVL(AAE210,'0') AAE210,
              NVL(AAE310,'0') AAE310,
              NVL(AAE410,'0') AAE410,
              NVL(AAE510,'0') AAE510,
              NVL(AAE311,'0') AAE311,
              yab136,
              yab275,
              ylb001,
              yab380,
              aab019,
              aab022
         INTO v_aae110,
              v_aae120,
              v_aae210,
              v_aae310,
              v_aae410,
              v_aae510,
              v_aae311,
              v_yab136,
              v_yab275,
              v_ylb001,
              v_yab380,
              v_aab019,
              v_aab022
         FROM wsjb.IRAB01
        WHERE aab001 = iab001
          AND AAB001 = PRM_AAB001;
  /*   --��ҵ�������ϱ���
      IF v_aae110 = '1' THEN
          t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE110';
          t_cols(t_cols.COUNT).COL_VALUE := '01';
       END IF;
       --������ҵ���ϱ���
        IF v_aae120 = '1' THEN
          t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE120';
          t_cols(t_cols.COUNT).COL_VALUE := '06';
       END IF;*/
       --ʧҵ����
       IF v_aae210 = '1' THEN
          t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE210';
          t_cols(t_cols.COUNT).COL_VALUE := '02';
       END IF;
       --����ҽ�Ʊ���
       IF v_aae310 = '1' THEN
          t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE310';
          t_cols(t_cols.COUNT).COL_VALUE := '03';
       END IF;
       --���˱���
       IF v_aae410 = '1' THEN
          t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE410';
          t_cols(t_cols.COUNT).COL_VALUE := '04';
       END IF;
       --��������
       IF v_aae510 = '1' THEN
          t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE510';
          t_cols(t_cols.COUNT).COL_VALUE := '05';
       END IF;
       --�󲡲�����ҵ����
       IF v_aae311 = '1' THEN
          t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE311';
          t_cols(t_cols.COUNT).COL_VALUE := '07';
       END IF;

       ----------------------------------------------------------------------------------------------------------

       --д�뵥λ������Ϣ
       INSERT INTO xasi2.ab01(AAB001 ,--��λ���
                       AAB002 ,--��ᱣ�յǼ�֤����
                       AAB003 ,--��֯��������
                       AAB004 ,--��λ����
                       AAB005 ,--��λ�绰
                       AAB006 ,--���̵Ǽ�ִ������
                       AAB007 ,--���̵Ǽ�ִ�պ���
                       AAB008 ,--���̵ǼǷ�������
                       AAB009 ,--���̵Ǽ���Ч����
                       AAB010 ,--��׼������λ
                       AAB011 ,--��׼����
                       AAB012 ,--��׼�ĺ�
                       AAB013 ,--��������������
                       YAB136 ,--��λ����״̬
                       AAB019 ,--��λ����
                       AAB020 ,--���óɷ�
                       AAB021 ,--������ϵ
                       AAB022 ,--��λ��ҵ
                       YLB001 ,--������ҵ�ȼ�
                       YAB391 ,--����������֤������
                       YAB388 ,--����������֤�����
                       YAB389 ,--�����������ֻ�
                       AAB015 ,--���������˰칫�绰
                       YAB518 ,--��������
                       AAE007 ,--��������
                       AAE006 ,--��ַ
                       YAE225 ,--ע���ַ
                       YAB519 ,--��λ��������
                       YAB520 ,--��λ��ַ
                       AAE014 ,--����
                       AAB034 ,--��ᱣ�վ����������
                       AAB301 ,--����������������
                       YAB322 ,--���һ�λ�֤��֤ʱ��
                       YAB274 ,--��ҵ��λ�ʽ���Դ
                       YAB525 ,--�Ƿ���ҵ��������ҵ��λ
                       YAB524 ,--������Ա�����۱�־
                       YAB521 ,--�����ʽ���Դ��λ
                       YAB522 ,--�����ʽ���Դ��λ
                       YAB523 ,--��λʵ�ʱ�������
                       YAB236 ,--������ҵ��λ���˴���
                       AAE119 ,--��λ״̬
                       YAB275 ,--��ᱣ��ִ�а취
                       YAE496 ,--�����ֵ�
                       YAE407 ,--��������
                       AAE013 ,--��ע
                       AAE011 ,--������
                       AAE036 ,--����ʱ��
                       YAE443 ,--����������
                       YAB553 ,--��У����
                       AAB304 ,--�������������
                       YAE393 ,--���������������ϵ�绰
                       YAB554 ,--��������������ֻ�/E-mail
                       YKB110 ,--Ԥ��ҽ���ʻ�
                       YKB109 ,--�Ƿ����ܹ���Աͳ�����
                       YAB566 ,--�Ƿ��ת��
                       YAB565 ,--���������ĺ�
                       YAB380 ,--������ҵ��־
                       YAB279 ,--ҽ��һ���Բ����ʽ�����϶�
                       YAB003 ,--���������
                       AAF020 ,--˰��������
                       AAB343 ,--һ����λ���
                       AAB030  --˰��

                      )
              SELECT AAB001 ,-- ��λ���
                     AAB002 ,-- ��ᱣ�յǼ�֤����
                     AAB003 ,-- ��֯��������
                     AAB004 ,-- ��λ����
                     AAB005 ,-- ��λ�绰
                     AAB006 ,-- ���̵Ǽ�ִ������
                     AAB007 ,-- ���̵Ǽ�ִ�պ���
                     AAB008 ,-- ���̵ǼǷ�������
                     AAB009 ,-- ���̵Ǽ���Ч����
                     AAB010 ,-- ��׼������λ
                     AAB011 ,-- ��׼����
                     AAB012 ,-- ��׼�ĺ�
                     AAB013 ,-- ��������������
                     YAB136 ,-- ��λ����״̬
                     AAB019 ,-- ��λ����
                     AAB020 ,-- ���óɷ�
                     AAB021 ,-- ������ϵ
                     AAB022 ,-- ��λ��ҵ
                     YLB001 ,-- ������ҵ�ȼ�
                     YAB391 ,-- ����������֤������
                     YAB388 ,-- ����������֤�����
                     YAB389 ,-- �����������ֻ�
                     AAB015 ,-- ���������˰칫�绰
                     YAB518 ,-- ��������
                     AAE007 ,-- ��������
                     AAE006 ,-- ��ַ
                     YAE225 ,-- ע���ַ
                     YAB519 ,-- ��λ��������
                     YAB520 ,-- ��λ��ַ
                     AAE014 ,-- ����
                     AAB034 ,-- ��ᱣ�վ����������
                     AAB301 ,-- ����������������
                     ''     ,--���һ�λ�֤��֤ʱ��
                     ''     ,--��ҵ��λ�ʽ���Դ
                     '0'    ,--�Ƿ���ҵ��������ҵ��λ
                     '0'    ,--������Ա�����۱�־
                     '0'    ,--�����ʽ���Դ��λ
                     '0'    ,--�����ʽ���Դ��λ
                     '0'    ,--��λʵ�ʱ�������
                     '0'    ,--������ҵ��λ���˴���
                     '1' ,--��λ״̬
                     YAB275 ,--��ᱣ��ִ�а취
                     YAE496 ,--�����ֵ�
                     YAE407 ,--��������
                     AAE013 ,--��ע
                     AAE011 ,--������
                     AAE036 ,--����ʱ��
                     YAE443 ,--����������
                     YAB553 ,--��У����
                     AAB304 ,--�������������
                     YAE393 ,--���������������ϵ�绰
                     YAB554 ,--��������������ֻ�/E-mail
                     ''     ,--Ԥ��ҽ���ʻ�
                     '0'    ,--�Ƿ����ܹ���Աͳ�����
                     '0'    ,--�Ƿ��ת��
                     ''     ,--���������ĺ�
                     YAB380 ,--������ҵ��־
                     '1'    ,--ҽ��һ���Բ����ʽ�����϶�
                     PKG_Constant.YAB003_JBFZX ,--���������
                     ''     ,--˰��������
                     ''     ,--һ����λ���
                     AAB030  --˰��
                FROM wsjb.IRAB01
               WHERE aab001 = iab001
                 and aab001 = prm_aab001;
                 --and IAA002 = PKG_Constant.IAA002_APS;

      SELECT COUNT(1)
        INTO n_count
        FROM xasi2.ab01a7
       WHERE AAB001 = PRM_AAB001;
      IF n_count > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE || '�Ѿ����ڸõ�λ���������Ϣ!'||PRM_AAB001;
         RETURN;
      END IF;

      --��λ�������
      insert into xasi2.ab01a7(aab001,
                         yab028,
                         yab128)
                  SELECT prm_aab001,
                         yab028,
                         aab003
                    FROM wsjb.IRAB01
                   WHERE aab001 = iab001
                     and aab001 = prm_aab001;
                     --and IAA002 = PKG_Constant.IAA002_APS;

      --��λ������
 -- v_aab001 := xasi2.PKG_Comm.Fun_Getsequence(NULL,'AAB001');
    /**  IF v_aab001 IS NULL OR v_aab001 = '' THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�AAB001!';
         RETURN;
      END IF;
      */
      insert into xasi2.ab01a2 (aab001,
                          yab021,
                          yab022,
                          yab023,
                          yab024,
                          yab025,
                          yab027)
                 values ( prm_aab001,
                          prm_aab001,
                          null,
                          prm_aab001,
                          null,
                          prm_aab001,
                          prm_aab001);

      ----------------------------------------------------------------------------------------------------------
      --ר��Ա��Ϣд��
      INSERT INTO xasi2.ab01a3
                    (AAC001,
                     AAB001,
                     YAB515,
                     YAB516,
                     AAB016,
                     AAB018,
                     YAB390,
                     YAB237,
                     YAB517)
              SELECT NVL(AAC001,'999999999'),
                     AAB001,
                     YAB515,
                     YAB516,
                     AAB016,
                     NVL(AAB018,0),
                     YAB390,
                     YAB237,
                     YAB517
                FROM wsjb.iraa01
               WHERE aab001 = prm_aab001;



       --��λ������Ϣ

         --��ȡ��ǰ���
         SELECT TO_NUMBER(TO_CHAR(SYSDATE,'yyyy'))
           INTO n_aae001
           FROM dual;

         --��ȡ�������
         BEGIN
           SELECT aae001,
                  aae030
             INTO n_aae001_aa35,
                  d_aae030
             FROM xasi2.aa35
            WHERE yab139 = prm_yab003 or yab139 = '$$$$'
              AND aae001 = (SELECT MAX(aae001) FROM xasi2.aa35);
         EXCEPTION
              WHEN OTHERS THEN
                   prm_AppCode  :=  gn_def_ERR;
                   prm_ErrorMsg := '��ȡ�����������'|| SQLERRM||dbms_utility.format_error_backtrace  ;
                   RETURN;
         END;

         --�����ǰ��ȴ����������
         IF n_aae001 > n_aae001_aa35 THEN
            n_aae001_ab05 := n_aae001_aa35;
         ELSIF n_aae001 = n_aae001_aa35 THEN
            --�������ʼʱ��С�ڵ�ǰʱ��
            IF SYSDATE > d_aae030 THEN
               n_aae001_ab05 := n_aae001_aa35;
            ELSE
               n_aae001_ab05 := n_aae001_aa35 - 1;
            END IF;
         END IF;

         INSERT INTO xasi2.ab05(
                     aab001,
                     aae001,
                     yab007,
                     aae030,
                     aae031,
                     yae099,
                     aae011
                     )
             VALUES (prm_aab001,
                     n_aae001_ab05,
                     '03',
                     NULL,
                     NULL,
                     NULL,
                     prm_aae011);

      --��λ��ᱣ��д��
      /*��ѯ����д ab02 ,ab06*/
      FOR i in 1 .. t_cols.count LOOP
         IF t_cols(i).COL_VALUE <> '04' THEN

              SELECT aaa040
              INTO v_aaa040
              FROM xasi2.aa05a3
             WHERE yab139 = '$$$$'
               AND yab136 = v_yab136
               AND yab380 = decode(aae140,'03','0','$$')
               AND yab275 = v_yab275
               AND aae140 = t_cols(i).COL_VALUE
               AND ylb001 = decode(aae140,'04',v_ylb001,'$$')
               AND aab033 = '04';

               v_aab033 := '04';
        ELSE
      select a.aaa040, c.aaa103
        INTO v_aaa040, v_aaa103
       from xasi2.aa11l2 a, xasi2.aa05 b, xasi2.aa10a1 c
       where a.aaa040 = b.aaa040
         and a.aaa040 = c.aaa102
         AND c.aaa100 = 'AAA040'
         and a.yae010 = b.yae010
         and a.aab033 = '04'
         and a.aab022 = v_aab022
          and b.aae140 = '04';

          --  v_aaa040 := '0601';
            v_aab033 := '04'  ;   --�籣����
         END IF;
         --20141103 ���0409-0.2%�ɷѱ�����������ҵ������ᣬ��ƣ���ʦ��������aab019='80'��
         IF t_cols(i).COL_VALUE = '04' AND v_aaa040 = '0401' AND v_aab019 = '80' THEN
             v_aaa040 := '0409';
         END IF ;
         IF t_cols(i).COL_VALUE = '04' AND (v_aab019 = '20' OR v_aab019 = '30') THEN
             v_aaa040 := '0409';
         END IF ;
         --��λ�α���Ϣ
         INSERT INTO xasi2.ab02(
                        AAB001  ,-- ��λ���     -->
                        AAE140  ,-- ��������     -->
                        AAB050  ,-- ��λ�α����� -->
                        YAE097  ,-- ��������ں� -->
                        AAB051  ,-- �α�״̬     -->
                        AAA040  ,-- �������     -->
                        AAB033  ,-- ���շ�ʽ     -->
                        YAB139  ,-- �α����������� -->
                        aae042  ,--���������ֹ��
                        /*YAB534  ,-- �ɷѿ���������� -->
                        AAB024  ,-- �ɷѿ������� -->
                        AAB025  ,-- �ɷ����л��� -->
                        AAB026  ,-- �ɷ����л����˺� -->
                        YAB535  ,-- ֧��������������� -->
                        AAB027  ,-- ֧���������� -->
                        AAB028  ,-- ֧�����л��� -->
                        AAB029  ,-- ֧�����л����˺� -->*/
                        AAE011  ,-- ������       -->
                        AAE036  ,-- ����ʱ��     -->
                        YAB003  ,-- �籣������� -->
                        AAE013   -- ��ע         -->
                      )
                 SELECT AAB001  ,-- ��λ���     -->
                        t_cols(i).COL_VALUE  ,-- ��������     -->
                        AAE036  ,-- ��λ�α����� -->
                      --  to_number(to_char(add_months(AAE036,-1),'yyyyMM'))  ,-- ��������ں� -->
                         to_number(to_char(add_months(AAE036,0),'yyyyMM'))  ,-- ��������ں� -->
                        '1'  ,-- �α�״̬     -->
                        v_aaa040  ,-- �������     -->
                        v_aab033  ,-- ���շ�ʽ     -->
                        PKG_Constant.YAB003_JBFZX,-- �α����������� -->
                        to_number(to_char(AAE036,'yyyy')||12),
                        /*YAB534  ,-- �ɷѿ���������� -->
                        AAB024  ,-- �ɷѿ������� -->
                        AAB025  ,-- �ɷ����л��� -->
                        AAB026  ,-- �ɷ����л����˺� -->
                        YAB535  ,-- ֧��������������� -->
                        AAB027  ,-- ֧���������� -->
                        AAB028  ,-- ֧�����л��� -->
                        AAB029  ,-- ֧�����л����˺� -->*/
                        AAE011  ,-- ������       -->
                        AAE036  ,-- ����ʱ��     -->
                        PKG_Constant.YAB003_JBFZX,-- �籣������� -->
                        AAE013   -- ��ע         -->
                   FROM wsjb.IRAB01
                  WHERE aab001 = iab001
                    and aab001 = prm_aab001;
                    --and IAA002 = PKG_Constant.IAA002_APS;





         --��λ���ֱ����Ϣ
         INSERT INTO xasi2.ab06(
                        yae099 ,-- ҵ����ˮ��   -->
                        aab001 ,-- ��λ���     -->
                        aae140 ,-- ��������     -->
                        aab100 ,-- ��λ������� -->
                        aab101 ,-- ��λ������� -->
                        aab102 ,-- ��λ���ԭ�� -->
                        aae013 ,-- ��ע         -->
                        aae011 ,-- ������       -->
                        aae036 ,-- ����ʱ��     -->
                        yab003 ,-- �籣������� -->
                        yab139  -- �α����������� -->
                       )
                 VALUES(
                         prm_yae099 ,-- ҵ����ˮ��   -->
                         prm_aab001 ,-- ��λ���     -->
                         t_cols(i).COL_VALUE ,-- ��������     -->
                         '1' ,-- ��λ������� ��λ�²α�-->
                         sysdate ,-- ��λ������� -->
                         '��λ�²α�' ,-- ��λ���ԭ�� -->
                         '' ,-- ��ע         -->
                         prm_aae011 ,-- ������       -->
                         sysdate ,-- ����ʱ��     -->
                         PKG_Constant.YAB003_JBFZX ,-- �籣������� -->
                         PKG_Constant.YAB003_JBFZX  -- �α����������� -->
                        );
      END LOOP;


             --��λ�α���Ϣ
           INSERT INTO xasi2.ab02a3(
                        AAB001,    --    ��λ���
                        AAB022,     --   ��λ��ҵ
                        AAA040,     --   �ɷ����
                        AAE041,     --   ��ʼʱ��
                        AAE042,    --   ��ֹʱ��
                        AAE011,     --   ������
                        AAE036,     --   ����ʱ��
                        YAB003,    --   �������
                        YAE031,     --   ��˱�־
                        YAE032,     --   �����
                        YAE033,     --   ���ʱ��
                        AAE120,     --   ע����־
                        AAE013     --    ��ע


                      )
                 SELECT AAB001,-- ��λ���     -->
                        v_aab022,-- ��λ��ҵ
                        aaa040,-- �ɷ����
                        null,-- ��λ�α����� -->
                        null,-- ��ֹʱ��
                        AAE011  ,-- ������       -->
                        AAE036 ,-- ����ʱ��     -->
                        YAB003,  -- �籣������� -->
                        '1',  --   ��˱�־
                       AAE011,  --   �����
                       AAE036,  --   ���ʱ��
                        null,   --   ע����־
                        AAE013   -- ��ע  -->
                   FROM xasi2.ab02
                  WHERE aab001 = aab001
                    and AAE140 ='04'
                    and aab001 = prm_aab001;
      ----------------------------------------------------------------------------------------------------------
   EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace  ;
         RETURN;
   END prc_AuditSocietyInsuranceREmp;

   /*****************************************************************************
   ** �������� : prc_AuditSocietyInsuranceRPer
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����ᱣ�յǼ����[��Ա�α�]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-24   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_AuditSocietyInsuranceRPer (prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                            prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --��λ����
                                            prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                            prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                            prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                            prm_aae036       IN    irac01.aae036%TYPE ,    --����ʱ��
                                            prm_AppCode      OUT   VARCHAR2  ,    --�������
                                            prm_ErrMsg       OUT   VARCHAR2  )    --��������

   IS
      var_procNo      VARCHAR2(2);          --�������
      num_count       NUMBER;
      num_countc      NUMBER;
      num_aae002      NUMBER;
      var_aae140_01   VARCHAR2(2);         --�Ƿ�μ�����ҵ����
      var_aae140_06   VARCHAR2(2);         --�Ƿ�μ��˻�������
      var_aae140_02   VARCHAR2(2);         --�Ƿ�μ���ʧҵ
      var_aae140_03   VARCHAR2(2);         --�Ƿ�μ��˻���ҽ��
      var_aae140_04   VARCHAR2(2);         --�Ƿ�μ��˹���
      var_aae140_05   VARCHAR2(2);         --�Ƿ�μ�������
      var_aae140_07   VARCHAR2(2);         --�Ƿ�μ��˴��
      var_aae140_08   VARCHAR2(2);
      rec_irac01      irac01%rowtype   ;
      var_yab136      xasi2.ab01.yab136%TYPE  ;            --��λ����״̬
      var_yab279      xasi2.ab01.yab279%TYPE  ;            --ҽ��һ���Բ����ʽ�����϶�
      var_yac001      VARCHAR2(20);
      var_aac001      xasi2.ac01.aac001%TYPE  ;            --���˱��
      var_aac002      xasi2.ac01.aac002%TYPE  ;            --֤������
      var_aac003      xasi2.ac01.aac003%TYPE  ;            --����
      var_aac004      xasi2.ac01.aac004%TYPE  ;            --�Ա�
      var_yae181      xasi2.ac01.yae181%TYPE  ;            --֤������
      dat_aac006      xasi2.ac01.aac006%TYPE  ;            --����ʱ��
      var_aac013      xasi2.ac01.aac013%TYPE  ;            --�ù���ʽ
      var_yac067      xasi2.ac01.yac067%TYPE  ;            --��Դ��ʽ
      var_aac008      xasi2.ac01.aac008%TYPE  ;            --��Ա״̬
      var_aae005      xasi2.ac01.aae005%TYPE  ;            --��ϵ�绰
      var_aae006      xasi2.ac01.aae006%TYPE  ;            --��ַ
--    var_aac013      ac01.aac013%TYPE  ;            --�ù���ʽ
--    dat_aac030      ac02.aac030%TYPE  ;            --�α�����
      var_aac031      xasi2.ac02.aac031%TYPE  ;            --���˲α�״̬
      var_yac505      xasi2.ac02.yac505%TYPE  ;            --�α��ɷ���Ա���
      num_yae097      xasi2.ac02.yae097%TYPE  ;            --������������ں�
      num_yae097_ab02 xasi2.ab02.yae097%TYPE  ;            --��λ��������ں�
      dat_aac007      xasi2.ac01.aac007%TYPE  ;            --�μӹ���ʱ��
      var_yac503      xasi2.ac02.yac503%TYPE  ;            --��������
      num_aac040      xasi2.ac02.aac040%TYPE  ;            --�걨����
      num_yac004      xasi2.ac02.yac004%TYPE  ;            --�ɷѻ���
      num_yaa333      xasi2.ac02.yaa333%TYPE  ;            --�˻�����
      var_yac168      xasi2.ac01.yac168%TYPE  ;            --ũ�񹤱�־
      var_ykb109      xasi2.kc01.ykb109%TYPE  ;            --�Ƿ����ܹ���Աͳ�����
      var_ykc150      xasi2.kc01.ykc150%TYPE  ;            --��ذ��ñ�־
      num_aic162      xasi2.kc01.aic162%TYPE  ;            --����������
      dat_ykc174      xasi2.kc01.ykc174%TYPE  ;            --������ʼʱ��
      var_akc021      xasi2.kc01.akc021%TYPE  ;            --ҽ����Ա���
      var_ykc120      xasi2.kc01.ykc120%TYPE  ;            -- ҽ���չ���Ա���
      var_aae120      xasi2.ac01.aae120%TYPE  ;            --ע����־
      var_yae099      xasi2.ac05.yae099%TYPE  ;            --ҵ����ˮ��
      var_aac050      xasi2.ac05.aac050%TYPE  ;            --���˱������
      var_yae499      xasi2.ac05.yae499%TYPE  ;            --�α����ԭ��
      var_yac235      xasi2.ac04a3.yac235%TYPE;            --���ʱ������
      var_yad176      xasi2.ac01k1.yad176%TYPE;            --��ͬ�ɷ���������
      var_aae140      xasi2.ac02.aae140%TYPE  ;            --����
      var_yab275      xasi2.ab01.yab275%TYPE  ;            --ҽ�Ʊ���ִ�а취
      dat_aac030      xasi2.ac02.aac030%TYPE  ;            --�α�ʱ��
      dat_aac030_05_start  xasi2.ac02.aac030%TYPE  ;       --��������α�ʱ��
      var_aac030_05_start  VARCHAR2(20);
      t_cols          tab_change       ;
      var_flag        VARCHAR2(2)      ;             --1:�²α� 2:�������� 3:���� �����������������������ڱ�λ�α������
      var_aab001_o    xasi2.ab01.aab001%TYPE ;
      var_aac031_o    xasi2.ac02.aac031%TYPE ;
      var_yae156      VARCHAR2(6)      ;             --�ƿ�״̬
      dat_yae102      DATE;
      dat_sysdate     DATE;


   BEGIN
      --��ʼ������
      prm_AppCode    := PKG_Constant.gn_def_OK ;
      prm_ErrMsg     := '';
      var_procNo     := '05';
      var_aac013     := PKG_Constant.AAC013_CZHTZ;
      var_flag       := NULL;
      dat_yae102     := sysdate;

      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      var_aac002 := rec_irac01.aac002 ;             --֤������
      var_aac003 := rec_irac01.aac003 ;             --����
--    dat_aac030 := rec_irac01.aac030 ;             --�α�����
      var_aac004 := rec_irac01.aac004 ;             --�Ա�
      var_yae181 := rec_irac01.yae181 ;             --֤������
      dat_aac006 := rec_irac01.aac006 ;             --��������
--    var_aac013 := rec_irac01.aac013 ;             --�ù���ʽ
      var_akc021 := rec_irac01.akc021 ;             --ҽ����Ա���
      dat_aac007 := rec_irac01.aac007 ;             --�μӹ���ʱ��
      var_aae005 := rec_irac01.aae005 ;             --��ϵ�绰
      var_aae006 := rec_irac01.aae006 ;             --��ַ
      var_aac008 := rec_irac01.aac008 ;             --��Ա״̬
      var_ykc150 := rec_irac01.ykc150 ;             --פ���־
      var_yac168 := rec_irac01.yac168 ;             --ũ�񹤱�־
      var_ykb109 := rec_irac01.ykb109 ;             --�Ƿ����ܹ���Աͳ�����
      var_yac503 := rec_irac01.yac503 ;             --��������
      num_aac040 := rec_irac01.aac040 ;             --�걨����
      num_yaa333 := rec_irac01.yaa333 ;             --���˻�����
      num_aic162 := rec_irac01.aic162 ;             --����������
      var_aae140_01 := rec_irac01.aae110;        --�Ƿ�μ�����ҵ����
      var_aae140_06 := rec_irac01.aae120;        --�Ƿ�μ��˻�������
      var_aae140_02 := rec_irac01.aae210;        --�Ƿ�μ���ʧҵ
      var_aae140_03 := rec_irac01.aae310;        --�Ƿ�μ��˻���ҽ��
      var_aae140_04 := rec_irac01.aae410;        --�Ƿ�μ��˹���
      var_aae140_05 := rec_irac01.aae510;        --�Ƿ�μ�������
      var_aae140_07 := rec_irac01.aae311;        --�Ƿ�μ��˴��
      var_aae140_08 := rec_irac01.aae810;
      IF var_aae140_01 = '1' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE110';
         t_cols(t_cols.count).col_value := '01';
      END IF;

      IF var_aae140_06 = '1' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE120';
         t_cols(t_cols.count).col_value := '06';
      END IF;

      IF var_aae140_02 = '1' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE210';
         t_cols(t_cols.count).col_value := '02';
      END IF;

      IF var_aae140_03 = '1' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE310';
         t_cols(t_cols.count).col_value := '03';
      END IF;

      IF var_aae140_04 = '1' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE410';
         t_cols(t_cols.count).col_value := '04';
      END IF;

      IF var_aae140_05 = '1' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE510';
         t_cols(t_cols.count).col_value := '05';
      END IF;

      IF var_aae140_07 = '1' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE311';
         t_cols(t_cols.count).col_value := '07';
      END IF;

      --�жϳ�������
      IF LENGTH(var_aac002) = 15 THEN
         dat_aac006 := to_date('19'||substr(var_aac002,7,6),'yymmdd');            --��������
      END IF;

      IF LENGTH(var_aac002) = 18 THEN
         dat_aac006 := to_date(substr(var_aac002,7,8),'yyyymmdd');          --��������
      END IF;

      --��ȡ��Ա�ı��
      BEGIN
         SELECT aac001
           INTO var_aac001
           FROM xasi2.ac01
          WHERE AAC002 = var_aac002;
         EXCEPTION
         WHEN TOO_MANY_ROWS THEN
            prm_AppCode := gn_def_ERR ;
            prm_ErrMsg  := '���ڶ���ظ�����Ա��Ϣ!';
            RETURN;
         WHEN OTHERS THEN
            --��������ڸ��˱�� �������µĸ��˱��
            IF var_aac001 IS NULL THEN
               var_aac001 := xasi2.PKG_Comm.fun_GetSequence(NULL,'aac001');           --���˱��
               IF var_aac001 is null THEN
                  prm_AppCode := gn_def_ERR ;
                  prm_ErrMsg  := 'linkû�л�ȡ�����˱�����к�!';
                  RETURN;
               END IF;
               var_flag := '1'; --��־Ϊ�²α�
            END IF;
      END;

      var_yac168     := PKG_Constant.YAC168_F;
      var_aae120     := PKG_Constant.AAE120_ZC;
      var_yac067     := PKG_Constant.YAC067_IRPLXCB;

      --�²α������������Ϣ��/��λ��Ա��Ϣ��
      IF var_flag = 1 THEN
         INSERT INTO xasi2.ac01(
                        aac001,          -- ���˱��
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
                        aae011,          -- ������
                        aae036,          -- ����ʱ��
                        aae120)          -- ע����־
               VALUES ( var_aac001,          -- ���˱��
                        var_yae181,          -- ֤������
                        var_aac002,          -- ���֤����(֤������)
                        var_aac003,          -- ����
                        var_aac004,          -- �Ա�
                        rec_irac01.aac005,
                        dat_aac006,          -- ��������
                        dat_aac007,          -- �μӹ�������
                        var_aac008,          -- ��Ա״̬
                        rec_irac01.aac009,
                        rec_irac01.aac010,
                        rec_irac01.aac012,
                        var_aac013,
                        rec_irac01.aac014,
                        rec_irac01.aac015,
                        rec_irac01.aac020,
                        var_yac067,          -- ��Դ��ʽ
                        var_yac168,          -- ũ�񹤱�־
                        rec_irac01.aae004,
                        var_aae005,          -- ��ϵ�绰
                        var_aae006,          -- ��ַ
                        rec_irac01.aae007,
                        rec_irac01.yae222,
                        rec_irac01.aae013,
                        prm_aae011,          -- ������
                        prm_aae036,          -- ����ʱ��
                        var_aae120);         -- ע����־

         var_yac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'YAC001');
         IF var_yac001 is null THEN
            ROLLBACK;
            prm_AppCode := gn_def_ERR ;
            prm_ErrMsg  := 'û�л�ȡ����λ��Ա���к�yac001!';
            RETURN;
         END IF;
         INSERT INTO wsjb.irac01a3 (
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
                        rec_irac01.aab001,
                        var_yae181,          -- ֤������
                        var_aac002,          -- ���֤����(֤������)
                        var_aac003,          -- ����
                        var_aac004,          -- �Ա�
                        rec_irac01.aac005,
                        dat_aac006,          -- ��������
                        dat_aac007,          -- �μӹ�������
                        var_aac008,          -- ��Ա״̬
                        rec_irac01.aac009,
                        rec_irac01.aac010,
                        rec_irac01.aac012,
                        var_aac013,
                        rec_irac01.aac014,
                        rec_irac01.aac015,
                        rec_irac01.aac020,
                        var_yac067,          -- ��Դ��ʽ
                        var_yac168,          -- ũ�񹤱�־
                        rec_irac01.aae004,
                        var_aae005,          -- ��ϵ�绰
                        var_aae006,          -- ��ַ
                        rec_irac01.aae007,
                        rec_irac01.yae222,
                        rec_irac01.aae013,
                        0,
                        PKG_Constant.YAB003_JBFZX,
                        rec_irac01.aab001,
                        prm_aae011,          -- ������
                        prm_aae036);         -- ����ʱ��
      ELSE
         --���α���λ�Ƿ���ڸ���Ա��Ϣ
         SELECT COUNT(1)
           INTO num_count
           FROM wsjb.IRAC01A3
          WHERE AAC001 = var_aac001
            AND AAB001 = rec_irac01.AAB001;
         IF num_count = 0 THEN
            var_yac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'YAC001');
            IF var_yac001 is null THEN
               prm_AppCode := gn_def_ERR ;
               prm_ErrMsg  := 'û�л�ȡ����λ��Ա���к�yac001!';
               RETURN;
            END IF;
            INSERT INTO wsjb.irac01a3 (
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
                        rec_irac01.aab001,
                        var_yae181,          -- ֤������
                        var_aac002,          -- ���֤����(֤������)
                        var_aac003,          -- ����
                        var_aac004,          -- �Ա�
                        rec_irac01.aac005,
                        dat_aac006,          -- ��������
                        dat_aac007,          -- �μӹ�������
                        var_aac008,          -- ��Ա״̬
                        rec_irac01.aac009,
                        rec_irac01.aac010,
                        rec_irac01.aac012,
                        var_aac013,
                        rec_irac01.aac014,
                        rec_irac01.aac015,
                        rec_irac01.aac020,
                        var_yac067,          -- ��Դ��ʽ
                        var_yac168,          -- ũ�񹤱�־
                        rec_irac01.aae004,
                        var_aae005,          -- ��ϵ�绰
                        var_aae006,          -- ��ַ
                        rec_irac01.aae007,
                        rec_irac01.yae222,
                        rec_irac01.aae013,
                        0,
                        PKG_Constant.YAB003_JBFZX,
                        rec_irac01.aab001,
                        prm_aae011,          -- ������
                        prm_aae036);         -- ����ʱ��
         END IF;
      END IF;

      --�����걨��Ϣ����Ա���
      UPDATE wsjb.IRAC01
         SET AAC001 = var_aac001
       WHERE IAC001 = prm_iac001;

      --�����걨��ϸ��Ϣ����Ա���
      UPDATE wsjb.IRAD02
         SET IAZ008 = var_aac001
       WHERE IAZ007 = prm_iac001;

      --�����ʱ���Ƿ�����������
      IF t_cols.count < 1 THEN
         ROLLBACK;
         prm_AppCode := gn_def_ERR;
         prm_ErrMsg  := var_aac001 || 'û�л��Ҫ�α���������Ϣ��';
         RETURN;
      END IF;

      --�α�����
      FOR i in 1 .. t_cols.count LOOP
         --�������ҵ���ϣ�ֱ���Թ�
         IF t_cols(i).col_value = '01' THEN
            GOTO nexaae140;
         END IF;
         var_aab001_o := NULL;
         var_aac031_o := NULL;
         BEGIN
            SELECT aab001,
                   aac031
              INTO var_aab001_o,
                   var_aac031_o
              FROM xasi2.AC02
             WHERE AAC001 = var_aac001
               AND AAE140 = t_cols(i).col_value;
            EXCEPTION
            WHEN OTHERS THEN
               var_aab001_o := NULL;
               var_aac031_o := NULL;
         END;

         --�Ѿ��α������ֵļ��
         IF var_aab001_o IS NOT NULL AND var_aac031_o IS NOT NULL THEN
            --�Ѿ��ڵ�ǰ��λ�α�
            IF var_aab001_o = rec_irac01.aab001 THEN
               IF var_aac031_o = PKG_Constant.AAC031_CBJF THEN
                  GOTO nexaae140;
               ELSE
                  var_flag := '3';
               END IF;
            --������λ�α�
            ELSE
               IF var_aac031_o = PKG_Constant.AAC031_CBJF THEN
                  prm_AppCode := gn_def_ERR;
                  prm_ErrMsg  := '����Ϊ['||var_aac001 || ']��Ա['||rec_irac01.aac003||']�ڱ�ĵ�λ'|| var_aab001_o ||'���ǲα��ɷ�״̬,��ȴ�ԭ��λ�����ɹ������걨��ˣ�';
                  RETURN;
               ELSE
                  var_flag := '3';
               END IF;
            END IF;
         ELSE
            var_flag := '1'; --�²α�����
         END IF;

         dat_aac030     := NULL;
         var_aae140     := t_cols(i).col_value;     --�������
         --���ʳ�ʼ��
         IF var_flag = '3' THEN
            var_yac503     := PKG_Constant.YAC503_SB;      --��������
         ELSE
            var_yac503     := rec_irac01.yac503 ;
         END IF;

         num_aac040     := rec_irac01.aac040 ;             --�걨����
         num_yaa333     := rec_irac01.yaa333 ;             --���˻�����
         dat_aac030     := rec_irac01.aac030 ;             --�α�ʱ��


         --�жϽɷ���Ա���
         IF var_aae140 = PKG_Constant.AAE140_JGYL THEN
            var_yac505 := PKG_Constant.YAC505_JGYLPT;
         END IF;

         IF var_aae140 = PKG_Constant.AAE140_SYE THEN
            var_yac505 := PKG_Constant.YAC505_SYEPT;
         END IF;

         IF var_aae140 = PKG_Constant.AAE140_SYE AND var_yac168 = PKG_Constant.YAC168_S THEN
            var_yac505 := PKG_Constant.YAC505_SYENMG;
         END IF;

         IF var_aae140 = PKG_Constant.AAE140_JBYL THEN
            var_yac505 := PKG_Constant.YAC505_YLPT;
         END IF;

         IF var_aae140 = PKG_Constant.AAE140_GS THEN
            var_yac505 := PKG_Constant.YAC505_GSPT;
         END IF;

         IF var_aae140 = PKG_Constant.AAE140_SYU THEN
            var_yac505 := PKG_Constant.YAC505_SYUPT;
            --�������Ϊ���� ���Ʋα�ʱ�� �������2006-10-01 �������Ĳα�ʱ���Ϊ2006-10-01
            var_aac030_05_start := '2006-10-01';
            dat_aac030_05_start := TO_DATE(var_aac030_05_start,'yyyy-MM-dd');
            IF (dat_aac030 < dat_aac030_05_start) THEN
               dat_aac030 := dat_aac030_05_start;
            END IF;
         END IF;

         IF var_aae140 = PKG_Constant.AAE140_DEYL THEN
            var_yac505 := PKG_Constant.YAC505_DEPT;
         END IF;

         IF var_aae140 = PKG_Constant.AAE140_GWYBZ THEN
            var_yac505 := PKG_Constant.YAC505_GWYBZPT;
         END IF;

         --var_aac031 := PKG_Constant.AAC031_CBJF;        --�α�״̬
         --99������½ɷ�������Ա ����Ϊ��ֹ�α�  *****
         /*IF var_zyj = '1' AND var_aae140 = PKG_Constant.AAE140_SYU THEN
            var_aac031  := PKG_Constant.AAC031_ZZCB;      --��ֹ�α�
         ELSE
            var_aac031 := PKG_Constant.AAC031_CBJF;       --�α�״̬
         END IF;
         */
         var_aac031 := PKG_Constant.AAC031_CBJF;       --�α�״̬
         num_yae097 := TO_NUMBER(TO_CHAR(ADD_MONTHS(dat_aac030,-1),'yyyymm'));   --��������ں�

         --�жϹ������
         IF var_yac503 <> PKG_Constant.YAC503_SB AND var_yac503 <> PKG_Constant.YAC503_LRYLJ THEN
            num_aac040 := 0 ;
         END IF;


         BEGIN
             --��λ����״̬
             SELECT yab136,
                    yab275,
                    ykb109
               INTO var_yab136,
                    var_yab275,
                    var_ykb109
               FROM xasi2.ab01
              WHERE aab001 = prm_aab001;
           EXCEPTION
           WHEN OTHERS THEN
                prm_AppCode := gn_def_ERR;
                prm_ErrMsg  := '��λ����'||prm_aab001||'û�л�ȡ����λ������Ϣ';
                RETURN;
         END;
          --�ѿ�������
          BEGIN
            SELECT yae097
              INTO num_yae097_ab02
              FROM xasi2.ab02
             WHERE aab001 = prm_aab001
               AND aae140 = var_aae140
               AND yab139 = prm_yab003;
          EXCEPTION
             WHEN OTHERS THEN
                prm_AppCode := gn_def_ERR;
                prm_ErrMsg  := '��λ����'||prm_aab001||'����:'||var_aae140||'û�л�ȡ����λ�α���Ϣ';
                RETURN;
          END;

          IF var_yab136 = PKG_Constant.YAB136_GT THEN
             num_aae002 := TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE,1),'yyyymm'));
          ELSIF var_yab136 <> PKG_Constant.YAB136_GT THEN
             num_aae002 := TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(num_yae097_ab02,'yyyymm'),1),'yyyymm'));
          END IF;


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
                                prm_yab003   ,     --�α�������
                                num_yac004   ,     --�ɷѻ���
                                prm_AppCode  ,     --�������
                                prm_ErrMsg   );    --��������
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            prm_ErrMsg := '��Ա:'||var_aac001||'����'||var_aae140||'����'||prm_ErrMsg ;
            RETURN;
         END IF;

         --�ж��˻�����
         IF var_yab275 <> PKG_Constant.YAB275_GWY THEN
            num_yaa333 := 0 ;
         END IF;

         --�жϽɷѻ���
         IF var_aae140 = PKG_Constant.AAE140_DEYL THEN
            num_aac040 := 0;
            num_yac004 := 0;
         END IF;

         --�²α���������
         IF var_flag = '1' THEN
            IF var_aac008 = PKG_Constant.AAC008_ZZ OR (var_aac008 = PKG_Constant.AAC008_TX) THEN
            --��¼ac02
            INSERT INTO xasi2.ac02 (
                              aac001,              -- ���˱��
                              aab001,              -- ��λ���
                              aae140,              -- ��������
                              aac031,              -- ���˲α�״̬
                              yac505,              -- �α��ɷ���Ա���
                              yac033,              -- ���˳��βα�����
                              aac030,              -- ��ϵͳ�α�����
                              yae102,              -- ���һ�α��ʱ��
                              yae097,              -- ��������ں�
                              yac503,              -- �������
                              aac040,              -- �ɷѹ���
                              yac004,              -- �ɷѻ���
                              yaa333,              -- �˻�����
                              yab013,              -- ԭ��λ���
                              yab139,              --�α�����������
                              aae011,              -- ������
                              aae036,              -- ����ʱ��
                              yab003)              -- �籣�������
                     VALUES ( var_aac001,              -- ���˱��
                              prm_aab001,              -- ��λ���
                              var_aae140,              -- ��������
                              var_aac031,              -- ���˲α�״̬
                              var_yac505,              -- �α��ɷ���Ա���
                              dat_aac030,              -- ���˳��βα�����
                              dat_aac030,              -- ��ϵͳ�α�����
                              dat_aac030,              -- ���һ�α��ʱ��
                              num_yae097,              -- ��������ں�
                              var_yac503,              -- �������
                              num_aac040,              -- �ɷѹ���
                              num_yac004,              -- �ɷѻ���
                              num_yaa333,              -- �˻�����
                              prm_aab001,              -- ԭ��λ���
                              prm_yab003,              --�α�����������
                              prm_aae011,              -- ������
                              prm_aae036,              -- ����ʱ��
                              prm_yab003);             -- �籣�������

            var_aac050 := PKG_Constant.AAC050_XCB ;          --���˱������
            var_yae499 := PKG_Constant.YAE499_RYXCB;         --�α����ԭ��

            /*IF var_aac008 = PKG_Constant.AAC008_ZZ THEN
               var_akc021 := PKG_Constant.AKC021_ZZ ;            --ҽ����Ա���
            END IF;
            --ҽ����Ա���
            IF (var_zyj = '1' AND var_aac008 = PKG_Constant.AAC008_TX) OR
                  (var_zyj IS NULL AND var_aac008 = PKG_Constant.AAC008_ZZ) THEN
               var_akc021 := PKG_Constant.AKC021_ZZ ;            --��ְ
            ELSE
               var_akc021 := PKG_Constant.AKC021_TX ;            --����
            END IF;*/
            var_akc021 := PKG_Constant.AKC021_ZZ ;            --��ְ

            --��¼ac05
            INSERT INTO xasi2.ac05 (
                              yae099,          -- ҵ����ˮ��
                              aac001,          -- ���˱��
                              aab001,          -- ��λ���
                              aae140,          -- ��������
                              aac050,          -- ���˱������
                              yae499,          -- �α����ԭ��
                              aae035,          -- �������
                              yae498,          -- ���ǰ�α�״̬
                              aac008,          -- ��Ա״̬
                              yac505,          -- �α��ɷ���Ա���
                              yab013,          -- ԭ��λ���
                              yac503,          -- �������
                              aac040,          -- �ɷѹ���
                              yac004,          -- �ɷѻ���
                              aae002,          -- �ѿ�������
                              aae013,          --��ע
                              aae011,          -- ������
                              aae036,          -- ����ʱ��
                              yab139,          -- �α�����������
                              akc021,          -- ҽ����Ա���
                              yab003,          -- �籣�������
                              aae120,          -- ע����־
                              yae384,          -- ע����
                              yae385,          -- ע��ʱ��
                              yae406,          -- ע��ԭ��
                              yae556)          -- ע���������
                       VALUES(prm_yae099,          -- ҵ����ˮ��
                              var_aac001,          -- ���˱��
                              prm_aab001,          -- ��λ���
                              var_aae140,          -- ��������
                              var_aac050,          -- ���˱������
                              var_yae499,          -- �α����ԭ��
                              SYSDATE,         -- �������
                              NULL,                -- ���ǰ�α�״̬
                              var_aac008,          -- ��Ա״̬
                              var_yac505,          -- �α��ɷ���Ա���
                              prm_aab001,          -- ԭ��λ���
                              var_yac503,          -- �������
                              num_aac040,          -- �ɷѹ���
                              num_yac004,          -- �ɷѻ���
                              num_aae002,          -- �ѿ�������
                              '�����걨�����²α�',
                              prm_aae011,          -- ������
                              prm_aae036,          -- ����ʱ��
                              prm_yab003,          -- �α�����������
                              var_akc021,          -- ҽ����Ա���
                              prm_yab003,          -- �籣�������
                              var_aae120,          -- ע����־
                              NULL,          -- ע����
                              NULL,          -- ע��ʱ��
                              NULL,          -- ע��ԭ��
                              NULL);         -- ע���������


            --��¼ac04a3
            var_yac235 := PKG_Constant.YAC235_XCB ;          -- ���ʱ������
            INSERT INTO xasi2.ac04a3 (
                                yae099,          -- ҵ����ˮ��
                                aac001,          -- ���˱��
                                aab001,          -- ��λ���
                                aae140,          -- ��������
                                yac235,          -- ���ʱ������
                                yac506,          -- ���ǰ����
                                yac507,          -- ���ǰ�ɷѻ���
                                yac514,          -- ���ǰ���ʻ�����
                                aac040,          -- �ɷѹ���
                                yac004,          -- �ɷѻ���
                                yaa333,          -- �˻�����
                                aae002,          -- �ѿ�������
                                aae013,          -- ��ע
                                aae011,          -- ������
                                aae036,          -- ����ʱ��
                                yab003,          -- �籣�������
                                yab139,          -- �α�����������
                                yac503,          -- �������
                                yac526)          -- ���ǰ�������
                        VALUES (prm_yae099,          -- ҵ����ˮ��
                                var_aac001,          -- ���˱��
                                prm_aab001,          -- ��λ���
                                var_aae140,          -- ��������
                                var_yac235,          -- ���ʱ������
                                0,                   -- ���ǰ����
                                0,                   -- ���ǰ�ɷѻ���
                                0,                   -- ���ǰ���ʻ�����
                                num_aac040,          -- �ɷѹ���
                                num_yac004,          -- �ɷѻ���
                                num_yaa333,          -- �˻�����
                                num_aae002,          -- �ѿ�������
                                '�����걨�����²α�',                -- ��ע
                                prm_aae011,          -- ������
                                prm_aae036,          -- ����ʱ��
                                prm_yab003,          -- �籣�������
                                prm_yab003,          -- �α�����������
                                var_yac503,          -- �������
                                NULL);               -- ���ǰ�������

            END IF;

            --�ж� ������Ϊ����ҽ�Ƶ�ʱ��
            IF var_aae140 = PKG_Constant.AAE140_JBYL THEN
               var_ykc120 := PKG_Constant.YKC120_PT ;
            END IF;

            IF num_aic162 <> 0 THEN
               dat_ykc174 := ADD_MONTHS(TO_DATE(num_aic162 || -01,'yyyy-mm-dd'),+1);
            END IF;

            IF num_aic162 IS NULL OR num_aic162 = 0 THEN
               dat_ykc174 := dat_aac030;
            END IF;

            IF var_aae140 = PKG_Constant.AAE140_JBYL THEN
               --��¼kc01
               INSERT INTO xasi2.kc01 (
                                  aac001,            -- ���˱��
                                  aab001,            -- ��λ���
                                  akc021,            -- ҽ����Ա���
                                  ykc120,            -- ҽ���չ���Ա���
                                  ykb109,            -- �Ƿ����ܹ���Աͳ�����
                                  aic162,            -- ����������
                                  ykc174,            -- ������ʼʱ��
                                  yae497,            -- ҽ�ƴ�����ز�����˱�־
                                  yae032,            -- �����
                                  ykc150)            -- ��ذ��ñ�־
                          VALUES (var_aac001,            -- ���˱��
                                  prm_aab001,            -- ��λ���
                                  var_akc021,            -- ҽ����Ա���
                                  var_ykc120,            -- ҽ���չ���Ա���
                                  var_ykb109,            -- �Ƿ����ܹ���Աͳ�����
                                  num_aic162,            -- ����������
                                  dat_ykc174,            -- ������ʼʱ��
                                  NULL,                  -- ҽ�ƴ�����ز�����˱�־
                                  NULL,                  -- �����
                                  var_ykc150);            -- ��ذ��ñ�־

               --��¼kc01k1
               INSERT INTO xasi2.kc01k1 (
                                   yae099,             -- ҵ����ˮ��
                                   aac001,             -- ���˱��
                                   aab001,             -- ��λ���
                                   akc021,             -- ҽ����Ա���
                                   ykc120,             -- ҽ���չ���Ա���
                                   ykb109,             -- �Ƿ����ܹ���Աͳ�����
                                   aic162,             -- ����������
                                   ykc174,             -- ������ʼʱ��
                                   yae497,             -- ҽ�ƴ�����ز�����˱�־
                                   yae032,             -- �����
                                   aae011,             -- ������
                                   aae036,             -- ����ʱ��
                                   yab003,             -- �籣�������
                                   aae013,             -- ��ע
                                   aae120,             -- ע����־
                                   yae384,             -- ע����
                                   yae385,             -- ע��ʱ��
                                   yae406,             -- ע��ԭ��
                                   yae556,             -- ע���������
                                   ykc150)             -- ��ذ��ñ�־
                           VALUES (prm_yae099,             -- ҵ����ˮ��
                                   var_aac001,             -- ���˱��
                                   prm_aab001,             -- ��λ���
                                   var_akc021,             -- ҽ����Ա���
                                   var_ykc120,             -- ҽ���չ���Ա���
                                   var_ykb109,             -- �Ƿ����ܹ���Աͳ�����
                                   num_aic162,             -- ����������
                                   dat_ykc174,             -- ������ʼʱ��
                                   NULL,             -- ҽ�ƴ�����ز�����˱�־
                                   NULL,             -- �����
                                   prm_aae011,             -- ������
                                   prm_aae036,             -- ����ʱ��
                                   prm_yab003,             -- �籣�������
                                   NULL,             -- ��ע
                                   var_aae120,             -- ע����־
                                   NULL,             -- ע����
                                   NULL,             -- ע��ʱ��
                                   NULL,             -- ע��ԭ��
                                   NULL,             -- ע���������
                                   var_ykc150);      -- ��ذ��ñ�־
               --����Ƿ�д���쿨��
           /**    SELECT COUNT(1) INTO num_count  FROM xasi2_zs.ab01k2  WHERE aac001 = var_aac001;
               --����Ƿ������ƿ���λ
               SELECT COUNT(1) INTO num_countc FROM xasi2_zs.ab01k3  WHERE aab001 = prm_aab001;
               --�������ƿ�
               IF num_count > 0 THEN
                  UPDATE xasi2_zs.ab01k2  SET aab001 = prm_aab001,yab139 = prm_yab003  WHERE aac001 = var_aac001;
               ELSE
                  IF num_countc > 0 THEN
                     INSERT INTO xasi2_zs.ab01k2(aab001,
                                      aac001,
                                      yae156,
                                      yab139,
                                      aac100,
                                      aab111)
                               VALUES (prm_aab001,
                                       var_aac001,
                                       PKG_Constant.YAE156_Y,
                                       prm_yab003,
                                       NULL,
                                       NULL);
                  END IF;
               END IF;*/
            END IF;
            ELSE
               /*������������*/
               INSERT INTO xasi2.AC02A2(
                           YAE099,
                           AAC001,
                           AAB001,
                           AAE140,
                           AAC031,
                           YAC505,
                           YAC033,
                           AAC030,
                           YAE102,
                           YAE097,
                           YAC503,
                           AAC040,
                           YAC004,
                           YAA333,
                           YAB013,
                           YAC002,
                           AAE009,
                           AAE008,
                           AAE010,
                           YAB139,
                           AAE011,
                           AAE036,
                           YAB003,
                           AAE013,
                           YAD050)
                    SELECT prm_yae099,
                           AAC001,
                           AAB001,
                           AAE140,
                           AAC031,
                           YAC505,
                           YAC033,
                           AAC030,
                           YAE102,
                           YAE097,
                           YAC503,
                           AAC040,
                           YAC004,
                           YAA333,
                           YAB013,
                           YAC002,
                           AAE009,
                           AAE008,
                           AAE010,
                           YAB139,
                           AAE011,
                           AAE036,
                           YAB003,
                           AAE013,
                           YAD050
                      FROM xasi2.AC02
                     WHERE AAC001 = var_aac001
                       AND AAE140 = var_aae140;

               --�ǹ���������������
               IF var_aae140 <> PKG_Constant.aae140_GS THEN
                  --�����ƿ�����
                /**  IF var_aae140 = PKG_Constant.aae140_JBYL THEN
                     --����Ƿ�д���쿨��
                     SELECT COUNT(1) INTO num_count  FROM xasi2_zs.ab01k2 WHERE aac001 = var_aac001;
                     --����Ƿ������ƿ���λ
                     SELECT COUNT(1) INTO num_countc FROM xasi2_zs.ab01k3 WHERE aab001 = prm_aab001;
                     --�������ƿ�
                     IF num_count > 0 THEN
                        UPDATE xasi2_zs.ab01k2 SET aab001 = prm_aab001,yab139 = prm_yab003 WHERE aac001 = var_aac001;
                     ELSE
                        IF num_countc > 0 THEN
                           INSERT INTO xasi2_zs.ab01k2 (aab001,
                                            aac001,
                                            yae156,
                                            yab139,
                                            aac100,
                                            aab111)
                                     VALUES (prm_aab001,
                                             var_aac001,
                                             PKG_Constant.YAE156_Y,
                                             prm_yab003,
                                             NULL,
                                             NULL);
                        END IF;
                     END IF;
                  END IF;*/
                  --���嵥λ�������ѷ�(����ҽ�ƺʹ��)
                  IF (var_yab136 = PKG_Constant.YAB136_GT AND
                      var_aae140 NOT IN (PKG_Constant.aae140_JBYL,PKG_Constant.AAE140_DEYL)) THEN
                      GOTO nexaae140;
                  END IF;
                  BEGIN
                     --����ac02
                     UPDATE xasi2.ac02
                        SET yae102 = dat_yae102,
                            aac031 = PKG_Constant.AAC031_CBJF,
                            aab001 = prm_aab001,
                            aac040 = rec_irac01.aac040,
                            yac004 = case WHEN var_aae140 = PKG_Constant.AAE140_DEYL THEN 0 ELSE num_yac004 END,
                            yac503 = var_yac503,
                            YAA333 = case WHEN var_aae140 = PKG_Constant.AAE140_DEYL THEN 0 ELSE num_yaa333 END, --�˻�����
                            yab139 = prm_yab003
                      WHERE aac001 = var_aac001
                        AND aae140 = var_aae140
                        AND aac031 = PKG_Constant.AAC031_ZTJF--���ﲻ����λ���룬��֧��һ���˵Ķ��ͬ���ֲα���ϵ
                        ;

                  EXCEPTION
                     WHEN OTHERS THEN
                        prm_AppCode := gn_def_ERR;
                        prm_ErrMsg  := '���������������¸��˲α���Ϣ�����,����ԭ��:���˱�ţ�'||var_aac001||' ���֣�'||var_aae140||'��λ��ţ�'||prm_aab001||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                        RETURN;
                  END;

                  IF var_aae140 = PKG_Constant.aae140_JBYL AND prm_aab001 <> var_aab001_o THEN
                     BEGIN
                        SELECT akc021
                          INTO var_akc021
                          FROM xasi2.kc01
                         WHERE aac001 = var_aac001;
                     EXCEPTION
                        WHEN OTHERS THEN
                           prm_AppCode := gn_def_ERR;
                           prm_ErrMsg  := '������������ϵͳ����,����ԭ��:���˱�ţ�'||var_aac001||'û���ҵ�KC01�вα����ݣ�';
                           RETURN;
                     END;
                     --����KC01�еĵ�λ���
                     UPDATE xasi2.kc01
                        SET aab001 = prm_aab001
                      WHERE aac001 = var_aac001;
                     --kc01k1��¼�����ֵ��ac05��¼���ǰֵ
                     INSERT INTO xasi2.kc01k1(yae099,  --ҵ����ˮ��
                                          aac001,  --���˱��
                                          aab001,  --��λ���
                                          akc021,  --ҽ����Ա���
                                          ykc120,  --ҽ���չ���Ա���
                                          ykb109,  --�Ƿ����ܹ���Աͳ�����
                                          aic162,  --������ʱ��
                                          ykc174,  --������ʼ����
                                          yae497,  --ҽ�ƴ�����ز�����˱�־
                                          yae032,  --�����
                                          yae033,  --���ʱ��
                                          aae011,  --������
                                          aae036,  --����ʱ��
                                          yab003,  --�籣�������
                                          aae013,  --��ע
                                          aae120,  --ע����־
                                          yae384,  --ע����
                                          yae385,  --ע��ʱ��
                                          yae406,  --ע��ԭ��
                                          yae556)  --ע���������
                          SELECT prm_yae099,  --ҵ����ˮ��
                                 aac001,  --���˱��
                                 aab001,  --��λ���
                                 akc021,  --ҽ����Ա���
                                 ykc120,  --ҽ���չ���Ա���
                                 ykb109,  --�Ƿ����ܹ���Աͳ�����
                                 aic162,  --������ʱ��
                                 ykc174,  --������ʼ����
                                 yae497,  --ҽ�ƴ�����ز�����˱�־
                                 yae032,  --�����
                                 yae033,  --���ʱ��
                                 prm_aae011,  --������
                                 dat_sysdate,  --����ʱ��
                                 prm_yab003,   --�籣�������
                                 '��λ����������',  --��ע
                                 NULL,  --ע����־
                                 NULL,  --ע����
                                 NULL,  --ע��ʱ��
                                 NULL,  --ע��ԭ��
                                 NULL   --ע���������
                    FROM xasi2.kc01
                   WHERE aac001 = var_aac001
                  ;
                  END IF;
               ELSE
                  --���������������� ֻ�й��˵����
                  --���嵥λ�������ѷ�(����ҽ�ƺʹ��)
                  IF (var_yab136 = PKG_Constant.YAB136_GT AND
                      var_aae140 NOT IN (PKG_Constant.aae140_JBYL,PKG_Constant.AAE140_DEYL)) THEN
                      GOTO NEXAAE140;
                  END IF;
                  --��¼��������ac02
                  INSERT INTO xasi2.ac02 (
                                    aac001,              -- ���˱��
                                    aab001,              -- ��λ���
                                    aae140,              -- ��������
                                    aac031,              -- ���˲α�״̬
                                    yac505,              -- �α��ɷ���Ա���
                                    yac033,              -- ���˳��βα�����
                                    aac030,              -- ��ϵͳ�α�����
                                    yae102,              -- ���һ�α��ʱ��
                                    yae097,              -- ��������ں�
                                    yac503,              -- �������
                                    aac040,              -- �ɷѹ���
                                    yac004,              -- �ɷѻ���
                                    yaa333,              -- �˻�����
                                    yab013,              -- ԭ��λ���
                                    yab139,              --�α�����������
                                    aae011,              -- ������
                                    aae036,              -- ����ʱ��
                                    yab003)              -- �籣�������
                           VALUES ( var_aac001,              -- ���˱��
                                    prm_aab001,              -- ��λ���
                                    var_aae140,              -- ��������
                                    var_aac031,              -- ���˲α�״̬
                                    var_yac505,              -- �α��ɷ���Ա���
                                    dat_aac030,              -- ���˳��βα�����
                                    dat_aac030,              -- ��ϵͳ�α�����
                                    dat_aac030,              -- ���һ�α��ʱ��
                                    num_yae097,              -- ��������ں�
                                    var_yac503,              -- �������
                                    num_aac040,              -- �ɷѹ���
                                    num_yac004,              -- �ɷѻ���
                                    num_yaa333,              -- �˻�����
                                    prm_aab001,              -- ԭ��λ���
                                    prm_yab003,              --�α�����������
                                    prm_aae011,              -- ������
                                    prm_aae036,              -- ����ʱ��
                                    prm_yab003);             -- �籣�������
               END IF;
               INSERT INTO xasi2.ac04a3(
                                     yae099,          -- ҵ����ˮ��
                                     aac001,          -- ���˱��
                                     aab001,          -- ��λ���
                                     aae140,          -- ��������
                                     yac235,          -- ���ʱ������
                                     yac506,          -- ���ǰ����
                                     yac507,          -- ���ǰ�ɷѻ���
                                     yac514,          -- ���ǰ���ʻ�����
                                     aac040,          -- �ɷѹ���
                                     yac004,          -- �ɷѻ���
                                     yaa333,          -- �˻�����
                                     aae002,          -- �ѿ�������
                                     aae013,          -- ��ע
                                     aae011,          -- ������
                                     aae036,          -- ����ʱ��
                                     yab003,          -- �籣�������
                                     yab139,          -- �α�����������
                                     yac503,          -- �������
                                     yac526)          -- ���ǰ�������
                              VALUES (prm_yae099,          -- ҵ����ˮ��
                                     var_aac001,          -- ���˱��
                                     prm_aab001,          -- ��λ���
                                     var_aae140,          -- ��������
                                     PKG_Constant.YAC235_XB, -- ���ʱ������
                                     0,                   -- ���ǰ����
                                     0,                   -- ���ǰ�ɷѻ���
                                     0,                   -- ���ǰ���ʻ�����
                                     rec_irac01.aac040,
                                     case WHEN var_aae140 = PKG_Constant.AAE140_DEYL THEN 0 ELSE num_yac004 END,
                                     case WHEN var_aae140 = PKG_Constant.AAE140_DEYL THEN 0 ELSE num_yaa333 END, --�˻�����,
                                     TO_NUMBER(TO_CHAR(ADD_MONTHS(dat_yae102,-1),'yyyymm')),          -- �ѿ�������
                                     '�����걨��Ա��������',          -- ��ע
                                     prm_aae011,          -- ������
                                     SYSDATE,          -- ����ʱ��
                                     prm_yab003,          -- �籣�������
                                     prm_yab003,          -- �α�����������
                                     var_yac503,          -- �������
                                     NULL);               -- ���ǰ�������
               --д��ac05
               INSERT INTO xasi2.ac05(
                     yae099,  --ҵ����ˮ��
                     aac001,  --���˱��
                     aab001,  --��λ���
                     aae140,  --��������
                     aac050,  --���˱������
                     yae499,  --�α����ԭ��
                     aae035,  --�������
                     yae498,  --���ǰ�α�״̬
                     aac008,  --��Ա״̬
                     yac505,  --�α��ɷ���Ա���
                     yab013,  --ԭ��λ���
                     yac503,  --�������
                     aac040,  --�ɷѹ���
                     yac004,  --�ɷѻ���
                     aae002,  --�ѿ�������
                     aae013,  --��ע
                     aae011,  --������
                     aae036,  --����ʱ��
                     yab139,  --�α�����������
                     aae120,  --ע����־
                     akc021,  --ҽ����Ա���
                     yab003,  --�籣�������
                     yae384,  --ע����
                     yae385,  --ע��ʱ��
                     yae406)  --ע��ԭ��
               VALUES(prm_yae099,
                      var_aac001,
                      prm_aab001  ,
                      var_aae140  ,
                      PKG_Constant.AAC050_XB,
                      NULL,
                      dat_yae102,
                      PKG_Constant.AAC031_ZTJF,
                      var_aac008,
                      var_yac505,   --�α��ɷ���Ա���
                      var_aab001_o,     --ԭ��λ���
                      var_yac503,   --�������
                      case WHEN var_aae140 = PKG_Constant.AAE140_DEYL THEN 0 ELSE num_aac040 END,   --�ɷѹ���
                      case WHEN var_aae140 = PKG_Constant.AAE140_DEYL THEN 0 ELSE num_yac004 END,   --�ɷѻ���
                      num_yae097,            --�ѿ�������
                      rec_irac01.aae013,       --��ע
                      prm_aae011,            --������
                      dat_sysdate,           --����ʱ��
                      prm_yab003,            --ԭ�α�����������
                      PKG_Constant.AAE120_ZC,    --ע����־
                      var_akc021,            --ҽ����Ա���
                      prm_yab003,            --�籣�������
                      NULL,                  --ע����
                      NULL,                  --ע��ʱ��
                      NULL )                 --ע��ԭ��
                      ;
         END IF;

         <<NEXAAE140>>
         NULL;
      END LOOP;

      UPDATE wsjb.IRAC01A3
         SET AAE110 = DECODE(var_aae140_01,'1','2',AAE110),
             AAE120 = DECODE(var_aae140_06,'1','2',AAE120),
             AAE210 = DECODE(var_aae140_02,'1','2',AAE210),
             AAE310 = DECODE(var_aae140_03,'1','2',AAE310),
             AAE410 = DECODE(var_aae140_04,'1','2',AAE410),
             AAE510 = DECODE(var_aae140_05,'1','2',AAE510),
             AAE311 = DECODE(var_aae140_07,'1','2',AAE311),
             AAE810 = DECODE(var_aae140_08,'1','2',AAE810),
             AAC040 = rec_irac01.aac040,
             YAC004 = rec_irac01.yac004,
             YAC005 = rec_irac01.yac005
       WHERE AAC001 = var_aac001
         AND AAB001 = rec_irac01.AAB001;

     EXCEPTION
        WHEN OTHERS THEN
           prm_AppCode := gn_def_ERR;
           prm_ErrMsg  := '��λ����'||prm_aab001||'���֤����:'||var_aac002||'������Ա�α������������ԭ��Ϊ��'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
           RETURN;
   END prc_AuditSocietyInsuranceRPer;

   /*****************************************************************************
   ** �������� : prc_MonthInternetRegister
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_iaa011       IN     iraa02.iaa011%TYPE,--ҵ������
   **           prm_iaa003       IN     iraa02.iaa003%TYPE,--ҵ������
   **           prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
   **           prm_aae011       IN     irad01.aae011%TYPE,--������
   **           prm_Flag      OUT    VARCHAR2    ,
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-12   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_MonthInternetRegister (
      prm_iaa011       IN     iraa02.iaa011%TYPE,--ҵ������
      prm_iaa003       IN     iraa02.iaa003%TYPE,--ҵ������
      prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
      prm_aae011       IN     irad01.aae011%TYPE,--������
      prm_Flag      OUT    VARCHAR2    ,
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      n_count    number(5);
      n_count1   number(5);
      n_count8    number(5);
      num_count   number(5);
      num_count2 NUMBER(5);
      num_yac004 number;
      v_iaz004   varchar2(15);
      v_iaz005   varchar2(15);
      v_iaz006   varchar2(15);
      v_aaz002   varchar2(15);
      v_iaa004   number(5);
      v_aac001   varchar2(15);
      v_aac003   varchar2(60);
      v_iac001   varchar2(15);
      v_iac002   varchar2(15);
      v_aab001   varchar2(15);
      d_yae097   number(6);
      t_yae097   number(6);
     n_count_reduce  NUMBER(6);--������Ա��
     n_count_all     NUMBER(6);--�����걨��Ա��
     n_rate          NUMBER(6,2);--������
     count_month        number; --�Ƿ����¿�����λ
     n_account_loginid   number;--�Ƿ�ʹ����ϵͳ��λ
     prm_yae099        Varchar2(20);
     var_sysmonth      varchar2(15);
     var_sysnexmonth   varchar2(15);
     var_yae097        varchar2(15);
     var_yae097nex     varchar2(15);
     var_yae102      date;
      var_aab019       ab01.aab019%TYPE;       --��λ����  ��Ҫ���ָ��幤�˻�  20191101 yujj

      CURSOR c_cur is
         SELECT a.iac001,a.aac001,a.aac003,a.iaa002,a.iaa001
           From wsjb.irac01  a,wsjb.iraa01  b
          WHERE a.aab001 = b.aab001
            AND a.iaa001 <> '4'
            AND (a.iaa002 = PKG_Constant.IAA002_WIR OR a.iaa002 = PKG_Constant.IAA002_ALR)
            AND b.yae092 = prm_aae011
            AND a.iaa100 = prm_iaa100;

      CURSOR CUR_AC01 IS
         SELECT A.AAC001,
                A.AAB001,
                A.AAC040,
                A.AAC002,
                NVL(A.YAC503,0) YAC503,
                C.YAB136,
                A.AAE110,
                A.AAE310,
                '01' AAE140,
                A.YAC004,
                A.YAC005
           FROM wsjb.irac01  A,wsjb.iraa01  B,wsjb.IRAB01  C
          WHERE A.AAB001 = B.AAB001
            AND A.AAB001 = C.AAB001
            AND C.AAB001 = C.IAB001
            AND B.yae092 = prm_aae011
            AND (A.YAC004 IS NULL OR A.YAC005 IS NULL);



       CURSOR cur_yae102 is
         SELECT a.iac001,a.yae102, a.aab001, a.aac001
           From wsjb.irac01  a,wsjb.iraa01  b
          WHERE a.aab001 = b.aab001
            AND a.iaa001 in ('3','7')
            AND a.iaa002 = '0'
            AND b.yae092 = prm_aae011
            AND a.iaa100 = prm_iaa100;

   BEGIN
      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;
      num_yac004   := 0;
      v_aab001     := NULL;
      n_count_reduce := 0;--������Ա��
      n_count_all    := 0;--�����걨��Ա��
      n_rate         := 0;--������
      prm_yae099     := '';

      /*��Ҫ������У��*/
      IF prm_iaa011 IS NULL THEN
         prm_ErrorMsg := 'ҵ�����Ͳ���Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa003 IS NULL THEN
         prm_ErrorMsg := 'ҵ�����岻��Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa100 IS NULL THEN
         prm_ErrorMsg := '�걨�¶Ȳ���Ϊ��!';
         RETURN;
      END IF;

      BEGIN
         SELECT a.aab001
           INTO v_aab001
           FROM wsjb.iraa01  a
          WHERE a.yae092 = prm_aae011
            AND a.aae100 = '1';
         EXCEPTION
         WHEN OTHERS THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '��λר��Ա��Ϣ��Ч������ϵ������Ա!';
            RETURN;
      END;

       FOR rec_yae102 in cur_yae102 LOOP
        --����δ�ύ�ļ��� ���±��ʱ��
        IF rec_yae102.yae102 < sysdate THEN
          update wsjb.irac01
             set yae102 = sysdate
           where iac001 = rec_yae102.iac001;
        END IF;
        --��������,���¼��ٵ���Ա AC02 YAE102���³ɵ������һ�� ͣ������ǵ������һ��,
        -- �ȸ�һ�� ������������ͣ��У�鲻��ͨ��
        select count(1)
          into n_count8
          from wsjb.irac01
         where iaa001 in ('1','2','5','6','8')
           and iaa002 = '2'
           and aab001 = rec_yae102.aab001
           and aac001 = rec_yae102.aac001
           and iaa100 = prm_iaa100;
        IF n_count8 >0 then
          update xasi2.ac02
             set yae102 = trunc(sysdate, 'mm')
           where aac001 = rec_yae102.aac001
             and aab001 = rec_yae102.aab001
             and aac031 = '1';
        END IF;
      END LOOP;


      /*
        2013-08-30�޸ģ��¿�����λ����׼�±�ʱ�Ѿ�ȷ��yae097
        �µ�λ��������ں�����
        ����Ƿ���ڲα���Ա[�����Ƿ���ͣ]
        ���������޸ĵ�λ��������ں�

      SELECT count(1)
        INTO n_count
        FROM AC02 a
       WHERE a.aab001 = v_aab001;
      IF n_count = 0 THEN
         --�����ڲα���Ա[���¿�����λ]
         SELECT max(YAE097)
           INTO d_yae097
           FROM AB02
          WHERE AAB001 = v_aab001;
         t_yae097 := TO_NUMBER(to_char(add_months(to_date(prm_iaa100,'yyyymm'),-1),'yyyymm'));
         IF d_yae097 <> t_yae097 THEN
            UPDATE AB02
               SET YAE097 = t_yae097
             WHERE AAB001 = v_aab001;
         END IF;
      END IF;
      */
      /**
        prc_MonthInternetRegister
        д�������α���Ա���걨������Ϣ
      */
      --�ж��Ƿ�Ϊ������
      SELECT count(1)
        INTO num_count2
        FROM xasi2.AB02
       WHERE aab001 = v_aab001
         AND aab051 = '1';
      IF num_count2 > 0 THEN
      INSERT INTO wsjb.IRAC01
             (iac001, -- �걨��Ա��Ϣ���
              iaa001, -- �걨��Ա���
              iaa002, -- �걨״̬
              aac001, -- ���˱��
              aab001, -- ��λ���
              aac002, -- ���֤����(֤������)
              aac003, -- ����
              aac004, -- �Ա�
              aac005, -- ����
              aac006,
              aac007,
              aac008,
              aac009,
              aac011,
              aac013,
              aac014,
              aac015,
              aac020,
              yac168,
              yab139, -- �α�����������
              yab013, -- ԭ��λ���
              aae011, -- ������
              aae036, -- ����ʱ��
              aac040, -- �걨����
              yac005, --��������
              yac004, --���ϻ���
              aae110, -- ��ҵ����
              aae120, -- ��������
              aae210, -- ʧҵ
              aae310, -- ҽ��
              aae410, -- ����
              aae510, -- ����
              aae311, -- ��
              iaa100)
      SELECT TO_CHAR(seq_iac001.nextval ) iac001, -- �걨��Ա��Ϣ���
             PKG_Constant.IAA001_GEN iaa001, -- �����α���Ա
             PKG_Constant.IAA002_WIR iaa002, -- ���걨,
             p.aac001,p.aab001,
             p.aac002,p.aac003,p.aac004,p.aac005,p.aac006,p.aac007,p.aac008,p.aac009,p.aac011,
             p.aac013,p.aac014,p.aac015,p.aac020,p.yac168,p.yab139,p.aab001 as yab013,p.aae011,p.aae036,
             p.aac040,decode(p.aae310,'0',p.yac005_,'2',p.yac005) yac005,to_number(NVL(TRIM(p.yac004_1),p.yac004_2)) AS yac004,p.aae110,p.aae120,p.aae210,p.aae310,p.aae410,p.aae510,p.aae311,prm_iaa100
        FROM
     (SELECT a.aac001, -- ���˱��
             b.aab001, -- ��λ���
             a.aac002, -- ���֤����(֤������)
             a.aac003, -- ����
             a.aac004, -- �Ա�
             a.aac005, -- ����
             a.aac006,
             a.aac007,
             a.aac008,
             a.aac009,
             a.aac011,
             a.aac013,
             a.aac014,
             a.aac015,
             a.aac020,
             a.yac168,
             PKG_Constant.YAB003_JBFZX yab139,
             a.aae011, -- ������
             a.aae036, -- ����ʱ��
             sum(case when b.aae140 = '03' then b.aac040 else 0 end) as aac040, -- �걨����
             sum(case when b.aae140 = '03' then b.yac004 else 0 end) as yac005, -- �걨����
             sum(case when b.aae140 = '04' then b.yac004 else 0 end) as yac005_, -- ���˵Ľɷѻ���
             (select yac004 from wsjb.irac01a3  where aac001 = a.aac001 and aab001 = v_aab001 and aae110 = '2') as yac004_1, --��ҵ���ϻ���
             (select yac004 from xasi2.ac02 where aac001 = a.aac001 and aab001 = v_aab001 and aae140 = '06' and aac031 = '1') as yac004_2,--�������ϻ���
             (select aae110 from wsjb.irac01a3  where aac001 = a.aac001 and aab001 = v_aab001) aae110,             -- ��ҵ����
             sum(case  when b.aae140 = '06' then 2 else 0 end) as aae120,
             sum(case  when b.aae140 = '02' then 2 else 0 end) as aae210,
             sum(case  when b.aae140 = '03' then 2 else 0 end) as aae310,
             sum(case  when b.aae140 = '04' then 2 else 0 end) as aae410,
             sum(case  when b.aae140 = '05' then 2 else 0 end) as aae510,
             sum(case  when b.aae140 = '07' then 2 else 0 end) as aae311
        from xasi2.ac01 a, xasi2.ac02 b, wsjb.iraa01  c
       where a.aac001 = b.aac001
         and b.aab001 = c.aab001
         and c.yae092 = prm_aae011
         and b.aac031 = '1'
         AND NOT EXISTS
             (SELECT AAC001
                FROM wsjb.IRAC01
               WHERE aac002 = a.aac002
                 AND aab001 = v_aab001
                 AND iaa001 <> PKG_Constant.IAA001_MDF
                 AND iaa100 = prm_iaa100)
       group by a.aac001,
                b.aab001,
                a.aac002,
                a.aac003,
                a.aac004,
                a.aac005,
                a.aac006,
                a.aac007,
                a.aac008,
                a.aac009,
                a.aac011,
                a.aac013,
                a.aac014,
                a.aac015,
                a.aac020,
                a.yac168,
                a.aae011,
                a.aae036) p
      ;
      ELSE
        INSERT INTO wsjb.IRAC01
                         (iac001, -- �걨��Ա��Ϣ���
                          iaa001, -- �걨��Ա���
                          iaa002, -- �걨״̬
                          aac001, -- ���˱��
                          aab001, -- ��λ���
                          aac002, -- ���֤����(֤������)
                          aac003, -- ����
                          aac004, -- �Ա�
                          aac005, -- ����
                          aac006,
                          aac007,
                          aac008,
                          aac009,
                          aac011,
                          aac013,
                          aac014,
                          aac015,
                          aac020,
                          yac168,
                          yab139, -- �α�����������
                          yab013, -- ԭ��λ���
                          aae011, -- ������
                          aae036, -- ����ʱ��
                          aac040, -- �걨����
                          yac005, --��������
                          yac004, --���ϻ���
                          aae110, -- ��ҵ����
                          aae120, -- ��������
                          aae210, -- ʧҵ
                          aae310, -- ҽ��
                          aae410, -- ����
                          aae510, -- ����
                          aae311, -- ��
                          iaa100)
                  SELECT TO_CHAR(seq_iac001.nextval) iac001, -- �걨��Ա��Ϣ���
                         PKG_Constant.IAA001_GEN iaa001, -- �����α���Ա
                         PKG_Constant.IAA002_WIR iaa002, -- ���걨,
                         p.aac001,p.aab001,
                         p.aac002,p.aac003,p.aac004,p.aac005,p.aac006,p.aac007,p.aac008,p.aac009,p.aac011,
                         p.aac013,p.aac014,p.aac015,p.aac020,p.yac168,p.yab139,p.aab001 as yab013,p.aae011,p.aae036,
                         p.aac040,decode(p.aae310,'0',p.yac005_,'2',p.yac005) yac005,to_number(NVL(TRIM(p.yac004_1),p.yac004_2)) AS yac004,p.aae110,p.aae120,p.aae210,p.aae310,p.aae410,p.aae510,p.aae311,prm_iaa100
                    FROM
                 (SELECT a.aac001, -- ���˱��
                         b.aab001, -- ��λ���
                         a.aac002, -- ���֤����(֤������)
                         a.aac003, -- ����
                         a.aac004, -- �Ա�
                         a.aac005, -- ����
                         a.aac006,
                         a.aac007,
                         a.aac008,
                         a.aac009,
                         a.aac011,
                         a.aac013,
                         a.aac014,
                         a.aac015,
                         a.aac020,
                         a.yac168,
                         PKG_Constant.YAB003_JBFZX yab139,
                         a.aae011, -- ������
                         a.aae036, -- ����ʱ��
                         b.aac040 AS aac040, -- �걨����
                         0 as yac005, -- �걨����
                         0 as yac005_, -- ���˵Ľɷѻ���
                         b.yac004 as yac004_1, --��ҵ���ϻ���
                         0 as yac004_2,--�������ϻ���
                         b.aae110 AS aae110,             -- ��ҵ����
                         0 AS aae120,
                         0 as aae210,
                         0 as aae310,
                         0 as aae410,
                         0 as aae510,
                         0 as aae311
                    from xasi2.ac01 a, wsjb.irac01a3  b, wsjb.iraa01  c
                   where a.aac001 = b.aac001
                     and b.aab001 = c.aab001
                     and c.yae092 = prm_aae011
                     and b.aae110 = '2'
                     AND NOT EXISTS
                         (SELECT AAC001
                            FROM wsjb.IRAC01
                           WHERE aac002 = a.aac002
                             AND aab001 = v_aab001
                             AND iaa001 <> PKG_Constant.IAA001_MDF
                             AND iaa100 = prm_iaa100)
                   ) p
                  ;
      END IF;

      --ȷ����λ��Ա����ҵ���Ͻɷѻ���
      FOR rec_ac01 IN CUR_AC01 LOOP
         --���ñ��׷ⶥ���̣���ȡ�ɷѻ����ͽɷѹ���
         IF rec_ac01.AAE110 = '2' AND rec_ac01.yac004 IS NULL THEN
            xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase
                                  (rec_ac01.aac001   ,     --���˱���
                                   rec_ac01.aab001   ,     --��λ����
                                   rec_ac01.aac040   ,     --�ɷѹ���
                                   rec_ac01.yac503   ,     --�������
                                   rec_ac01.aae140   ,     --��������
                                   '00'                ,     --�ɷ���Ա���
                                   rec_ac01.yab136   ,     --��λ�������ͣ���������ɷ���Ա��
                                   prm_iaa100   ,            --�ѿ�������
                                   PKG_Constant.YAB003_JBFZX,  --�α�������
                                   num_yac004   ,     --�ɷѻ���
                                   prm_AppCode  ,     --�������
                                   prm_ErrorMsg );    --��������
            IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
               ROLLBACK;
               prm_ErrorMsg := '��Ա:'||rec_ac01.aac001 ||'��ȡ�������Ͻɷѻ�������'||prm_ErrorMsg||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
               RETURN;
            END IF;
      BEGIN
         --��λ����״̬
        SELECT  aab019
         INTO  var_aab019
         FROM ab01
      WHERE aab001 = rec_ac01.aab001;
      EXCEPTION
     WHEN OTHERS THEN
      prm_ErrorMsg  := '��λ����'||rec_ac01.aab001|| 'û�л�ȡ����λ������Ϣ,'||prm_ErrorMsg ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
      RETURN;
   END;
        --�жϸ��幤�̻�
               --�жϸ��幤�̻�---  20191101  yujj
   IF var_aab019 = '60' THEN
      UPDATE wsjb.IRAC01
               SET yaa333 = num_yac004
             WHERE AAC001 = rec_ac01.aac001
               AND AAB001 = rec_ac01.aab001;
     ELSE
        UPDATE wsjb.IRAC01
               SET YAC004 = num_yac004
             WHERE AAC001 = rec_ac01.aac001
               AND AAB001 = rec_ac01.aab001;
      END IF ;
      END IF;

         --���ñ��׷ⶥ���̣���ȡ�ɷѻ����ͽɷѹ���
         IF rec_ac01.AAE310 = '2' AND rec_ac01.yac005 IS NULL THEN
            xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase
                                  (rec_ac01.aac001   ,     --���˱���
                                   rec_ac01.aab001   ,     --��λ����
                                   rec_ac01.aac040   ,     --�ɷѹ���
                                   rec_ac01.yac503   ,     --�������
                                   PKG_Constant.AAE140_JBYL, --��������
                                   '00'                ,     --�ɷ���Ա���
                                   rec_ac01.yab136   ,     --��λ�������ͣ���������ɷ���Ա��
                                   prm_iaa100   ,            --�ѿ�������
                                   PKG_Constant.YAB003_JBFZX,  --�α�������
                                   num_yac004   ,     --�ɷѻ���
                                   prm_AppCode  ,     --�������
                                   prm_ErrorMsg );    --��������
            IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
               ROLLBACK;
               prm_ErrorMsg := '��Ա:'||rec_ac01.aac001 ||'��ȡҽ�����ֽɷѻ�������'||prm_ErrorMsg ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
               RETURN;
            END IF;

            UPDATE wsjb.IRAC01
               SET YAC005 = num_yac004
             WHERE AAC001 = rec_ac01.aac001
               AND AAB001 = rec_ac01.aab001;
         END IF;
      END LOOP;


      /**
        prc_MonthInternetRegister
        �¶Ƚɷ��걨
      */
      --�Ƿ������ͬ����˼���
      SELECT COUNT(1)
        into n_count
        FROM wsjb.IRAA02
       WHERE iaa011 = PKG_Constant.IAA011_MIR
         AND iaa005 = PKG_Constant.IAA005_YES;
      IF n_count > 1 THEN
         ROLLBACK;
         prm_ErrorMsg := '���걨ϵͳ��˼�����Ϣ����!����ϵά����Ա';
         RETURN;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
      IF  v_aaz002 IS NULL OR v_aaz002 = ''  THEN
         ROLLBACK;
         prm_ErrorMsg := 'û�л�ȡ�����к�AAZ002';
         RETURN;
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
                  AAE218,
                  AAE013
                 )
                 VALUES
                 (
                  v_aaz002,
                  PKG_Constant.AAA121_MIR,
                  prm_aae011,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae011,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate,
                  null
                 );

       BEGIN
         SELECT DISTINCT a.iaz004
           into v_iaz004
           FROM wsjb.IRAD01  a,wsjb.IRAA01  b
          WHERE a.aab001 = b.aab001
            AND a.iaa100 = prm_iaa100
            AND a.iaa011 = PKG_Constant.AAA121_MIR
            AND b.yae092 = prm_aae011;
         EXCEPTION
         WHEN OTHERS THEN
            v_iaz004 := NULL;
      END;

      BEGIN
         SELECT iaa004
           INTO v_iaa004
           FROM wsjb.IRAA02
          WHERE iaa011 = PKG_Constant.IAA011_MIR
            AND iaa005 = PKG_Constant.IAA005_YES;
         EXCEPTION
      WHEN OTHERS THEN
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := 'û�л�ȡ����˼�����Ϣ';
         RETURN;
      END;

      IF v_iaz004 IS NULL THEN
         /*��ȡ���к�*/
         v_iaz004 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ004');
         IF v_iaz004 IS NULL OR v_iaz004 = '' THEN
            ROLLBACK;
            prm_ErrorMsg := 'û�л�ȡ�����к�IAZ004';
            RETURN;
         END IF;

        --�걨�¼�
        INSERT INTO wsjb.IRAD01
                    (
                     iaz004,
                     aaz002,
                     iaa011,
                     aae011,
                     aae035,
                     aab001,
                     yab003,
                     aae013,
                     iaa100
                    )
                    VALUES
                    (
                     v_iaz004,
                     v_aaz002,
                     PKG_Constant.IAA011_MIR,
                     prm_aae011,
                     sysdate,
                     v_aab001,
                     PKG_Constant.YAB003_JBFZX,
                     null,
                     prm_iaa100
                    );
      END IF;

      --д�뵥λ����Ա��Ϣ�걨��ϸ

       v_iac002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');
         IF v_iac002 IS NULL OR v_iac002 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'û�л�ȡ�����к�IAC002';
         END IF;

      FOR cur_result in c_cur LOOP
         v_aac003 := cur_result.aac003;
         v_iac001 := cur_result.iac001;

         v_aac001 := cur_result.aac001;
         IF v_aac001 IS NULL OR v_aac001 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'û�л�ȡ����Ա���';
         END IF;

         v_iaz005 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');
         IF v_iaz005 IS NULL OR v_iaz005 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'û�л�ȡ�����к�IAZ005';
         END IF;

         --��ȡ�ϴ��걨��ϸ���
         SELECT NVL(MAX(IAZ005),v_iaz005)
           INTO v_iaz006
           FROM wsjb.IRAD02
          WHERE IAZ007 = v_iac001;

         --������Ա�걨��ϸ
         INSERT INTO wsjb.IRAD02
             (
              iaz005,
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
             )
             VALUES
             (
              v_iaz005,
              v_iaz006,
              v_iaz004,
              v_iac001,
              v_aac001,
              v_aac003,
              prm_aae011,
              sysdate,
              PKG_Constant.YAB003_JBFZX,
              v_iaa004,
              0,
              PKG_Constant.IAA015_WAD,
              PKG_Constant.IAA016_DIR_NO,
              null,
              PKG_Constant.IAA020_GR
             );

              --������Ա������ϸ
             IF cur_result.iaa001  IN ('1','3','5','6','7','8') THEN
             INSERT INTO wsjb.IRAD02A1
             (
             iac002,
             iac001,
             iaz004,
             iaz005,
             aac001,
             aae011,
             aae036,
             aab001,
             iaa100
             )
             VALUES
             (
             v_iac002,
             v_iac001,
             v_iaz004,
             v_iaz005,
             v_aac001,
             prm_aae011,
             sysdate,
             v_aab001,
             prm_iaa100
             );
             END IF;

         --������Ա�걨״̬
         UPDATE wsjb.IRAC01
            SET iaa002 = PKG_Constant.IAA002_AIR
          WHERE iac001 = v_iac001;
      END LOOP;


  /*------------------------MODIFY  BY WHM ON 20190314  START----------------------*/
     --��ȡ��λ��ǰ���������
    IF num_count2 > 0 THEN      --һ�㵥λ�����ں�
      SELECT TO_CHAR(SYSDATE, 'yyyymm') sysmonth,
             TO_CHAR(ADD_MONTHS(SYSDATE, 1), 'yyyymm') sysnexmonth,
             TO_CHAR(NVL(MAX(YAE097), '999999')) yae097,
             TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(NVL(MAX(YAE097),TO_CHAR(SYSDATE,'yyyymm'))),'yyyymm'),1),'yyyymm') yae097nex
        INTO var_sysmonth, var_sysnexmonth, var_yae097, var_yae097nex
        FROM (SELECT YAE097
                FROM xasi2.ab02
               WHERE AAB001 = v_aab001
                 AND AAB051 = '1'
              UNION
              SELECT AAE003 AS YAE097
                FROM wsjb.irab08
               WHERE AAB001 = v_aab001
                 AND YAE517 = 'H01'
                 AND AAE140 = '01');
      IF var_yae097 = '999999' THEN
        prm_ErrorMsg  := prm_ErrorMsg || '��ȡ��������ںų���';
       prm_AppCode  :=  gn_def_ERR;
        GOTO leb_suss;
      END IF;
    ELSIF num_count2 = 0 THEN    --�����ϵ�λ�����ں�
      SELECT count(1)
        INTO num_count
        FROM wsjb.irab08
       WHERE AAB001 = v_aab001
         AND YAE517 = 'H01'
         AND AAE140 = '01';
      IF num_count > 0 THEN
        SELECT TO_CHAR(SYSDATE, 'yyyymm') sysmonth,
               TO_CHAR(ADD_MONTHS(SYSDATE, 1), 'yyyymm') sysnexmonth,
               TO_CHAR(NVL(MAX(YAE097), '999999')) yae097,
               TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(NVL(MAX(YAE097),TO_CHAR(SYSDATE,'yyyymm'))),'yyyymm'),1),'yyyymm') yae097nex
          INTO var_sysmonth, var_sysnexmonth, var_yae097, var_yae097nex
          FROM (SELECT AAE003 AS YAE097
                  FROM wsjb.irab08
                 WHERE AAB001 = v_aab001
                   AND YAE517 = 'H01'
                   AND AAE140 = '01');
      ELSIF num_count = 0 THEN
        SELECT TO_CHAR(SYSDATE, 'yyyyMM') INTO var_yae097nex FROM dual;
        SELECT TO_CHAR(SYSDATE, 'yyyymm') sysmonth,
               TO_CHAR(ADD_MONTHS(SYSDATE, 1), 'yyyymm') sysnexmonth,
               TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'yyyymm') yae097
          INTO var_sysmonth, var_sysnexmonth, var_yae097
          FROM dual;
      END IF;
    END IF;


   IF var_yae097 =  var_sysmonth THEN  --��������ں�=��ǰ��Ȼ��
     prm_Flag:= '0';
   /*---------------SIGN �±�ѭ���ύ���˶� START---------------*/
     SELECT COUNT(1)
          INTO n_count
          FROM wsjb.IRAC01  a,wsjb.IRAD02  b,wsjb.IRAD01  c
         WHERE a.iac001 = b.iaz007
           and b.iaz004 = c.iaz004
           and c.aab001 = v_aab001
           and a.iaa001 IN ('1','2','3','5','6','7','8')
           and c.iaa011 = PKG_Constant.IAA011_MIR  --A04
           and a.iaa002 = PKG_Constant.IAA002_AIR  --1
           and c.iaa100 = prm_iaa100;

        IF n_count > 0 THEN  --n_count �걨����
           DELETE FROM wsjb.IRAD22_TMP ;
           INSERT INTO wsjb.IRAD22_TMP
                 (IAC001,   --�걨��Ա��Ϣ���,VARCHAR2
                                  AAC001,   --���˱��,VARCHAR2
                                  AAB001,   --��λ���,VARCHAR2
                                  AAC002,   --������ݺ���,VARCHAR2
                                  AAC003,   --����,VARCHAR2
                                  IAA001,   --��Ա���
                                  IAZ005,   --�걨��ϸID
                                  IAA003)    --ҵ������
                          SELECT a.IAC001, --�걨��Ա��Ϣ���,VARCHAR2
                                 a.AAC001, --���˱��,VARCHAR2
                                 a.AAB001, --��λ���,VARCHAR2
                                 a.AAC002, --������ݺ���,VARCHAR2
                                 a.AAC003, --����,VARCHAR2
                                 a.IAA001, --��Ա���
                                 b.IAZ005, --�걨��ϸID
                                 '2' IAA003  --ҵ������
                            FROM wsjb.IRAC01  a,wsjb.IRAD02  b,wsjb.IRAD01  c
                           WHERE a.iac001 = b.iaz007
                             and b.iaz004 = c.iaz004
                             and c.aab001 = v_aab001
                             and a.iaa001 IN ('1','2','3','5','6','7','8')
                             and c.iaa011 = PKG_Constant.IAA011_MIR  --A04
                             and a.iaa002 = PKG_Constant.IAA002_AIR  --1 ���걨
                             and c.iaa100 = prm_iaa100;
           IF num_count2 > 0 THEN  --��AB02�ĵ�λ
             --���걨���ͨ��
             PKG_Insurance.prc_AuditMonthInternetR(PKG_Constant.IAA011_MIR,  --A04
                                                   PKG_Constant.IAA003_PER,  --2 ����
                                                   PKG_Constant.IAA018_PAS,  --1 ͨ��
                                                   '1',--���ͨ��
                                                   prm_aae011,
                                                   '1' , --ȫ��
                                                   prm_AppCode,
                                                   prm_ErrorMsg);
             IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                prm_AppCode  :=  gn_def_ERR;
                prm_ErrorMsg := '�������걨��˹���prc_AuditMonthInternetR����:' ||prm_ErrorMsg||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                RETURN;
             END IF;
           ELSE  --û��AB02 ���ǵ����ϵ�λ
            --���걨���ͨ�� (������)
             PKG_Insurance.prc_YLAuditMonth(PKG_Constant.IAA011_MIR,  --A04
                                            PKG_Constant.IAA003_PER,  --2 ����
                                            PKG_Constant.IAA018_PAS,  --1 ͨ��
                                             '1',--���ͨ��
                                             prm_aae011,
                                             '1' , --ȫ��
                                             prm_AppCode,
                                             prm_ErrorMsg
                                             );
             IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                prm_AppCode  :=  gn_def_ERR;
                prm_ErrorMsg := '�������걨��˹���prc_YLAuditMonth����:' ||prm_ErrorMsg||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                RETURN;
             END IF;
           END IF;
        END IF;

            PKG_Insurance.prc_insertAC29(
                              v_aab001, --��λ������
                               prm_iaa100  ,
                               prm_aae011, --������
                               prm_AppCode, --�������
                               prm_ErrorMsg); --��������
                IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                prm_AppCode  :=  gn_def_ERR;
                prm_ErrorMsg := '�����ƿ�����prc_insertAC29����:' ||prm_ErrorMsg||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                RETURN;
             END IF;
   /*----------------------SIGN �±�ѭ���ύ���˶� END----------------------*/

   ELSIF  var_yae097 <  var_sysmonth  THEN--��������ں�<��ǰ��Ȼ��
   prm_Flag:= '1';
   /*-----------------------------SIGN  ԭ��  START---------------------------*/
     /**
     �¶Ƚɷ��걨�����[��������걨���ٲα���Ա��������Ա��С��70%���Զ����ͨ��]
     **/
     --��ѯ������Ա��С��100%���Զ����ͨ��
     SELECT COUNT(1)
       INTO n_count_all
       FROM wsjb.IRAC01 a, wsjb.IRAD02 b, wsjb.IRAD01 c
      WHERE a.iac001 = b.iaz007
        and b.iaz004 = c.iaz004
        and c.aab001 = v_aab001
        and c.iaa011 = PKG_Constant.IAA011_MIR
        and a.iaa002 = PKG_Constant.IAA002_AIR
        and c.iaa100 = prm_iaa100;

     SELECT COUNT(1)
       INTO n_count_reduce
       FROM wsjb.IRAC01 a, wsjb.IRAD02 b, wsjb.IRAD01 c
      WHERE a.iac001 = b.iaz007
        and b.iaz004 = c.iaz004
        and c.aab001 = v_aab001
        and a.iaa001 IN ('3', '7', '9', '10')
        and c.iaa011 = PKG_Constant.IAA011_MIR
        and a.iaa002 = PKG_Constant.IAA002_AIR
        and c.iaa100 = prm_iaa100;

     -- IF n_count_all > 15 AND n_count_reduce >=0 THEN
     IF n_count_all > 0 AND n_count_reduce > 0 THEN
       n_rate := ROUND(n_count_reduce / n_count_all, 2) * 100;
     END IF;
     --���϶�ʹ����ϵͳ��λ���ж� ��tauser���б�ʾʹ���µ�λ������ֱ�������Ч
     SELECT COUNT(1)
       INTO n_account_loginid
       FROM xagxwt.tauser
      WHERE LOGINID = v_aab001
        AND EFFECTIVE = '0';

     IF n_account_loginid > 0 THEN
       IF n_rate < 100 THEN
         --��ϵͳ���ߺ�ſ�ע�� 20160325
         SELECT COUNT(1)
           INTO n_count
           FROM wsjb.IRAC01 a, wsjb.IRAD02 b, wsjb.IRAD01 c
          WHERE a.iac001 = b.iaz007
            and b.iaz004 = c.iaz004
            and c.aab001 = v_aab001
            and a.iaa001 IN ('3', '7', '9', '10')
            and c.iaa011 = PKG_Constant.IAA011_MIR
            and a.iaa002 = PKG_Constant.IAA002_AIR
            and c.iaa100 = prm_iaa100;

         --���ڼ��ٲα���Ա
         IF n_count > 0 THEN
           DELETE FROM wsjb.IRAD22_TMP;
           INSERT INTO wsjb.IRAD22_TMP
             (IAC001, --�걨��Ա��Ϣ���,VARCHAR2
              AAC001, --���˱��,VARCHAR2
              AAB001, --��λ���,VARCHAR2
              AAC002, --������ݺ���,VARCHAR2
              AAC003, --����,VARCHAR2
              IAA001, --��Ա���
              IAZ005, --�걨��ϸID
              IAA003) --ҵ������
             SELECT a.IAC001, --�걨��Ա��Ϣ���,VARCHAR2
                    a.AAC001, --���˱��,VARCHAR2
                    a.AAB001, --��λ���,VARCHAR2
                    a.AAC002, --������ݺ���,VARCHAR2
                    a.AAC003, --����,VARCHAR2
                    a.IAA001, --��Ա���
                    b.IAZ005, --�걨��ϸID
                    '2' IAA003 --ҵ������
               FROM wsjb.IRAC01 a, wsjb.IRAD02 b, wsjb.IRAD01 c
              WHERE a.iac001 = b.iaz007
                and b.iaz004 = c.iaz004
                and c.aab001 = v_aab001
                and a.iaa001 IN ('3', '7', '9', '10')
                and c.iaa011 = PKG_Constant.IAA011_MIR
                and a.iaa002 = PKG_Constant.IAA002_AIR
                and c.iaa100 = prm_iaa100;
           IF num_count2 > 0 THEN
             --���걨���ͨ��
             PKG_Insurance.prc_AuditMonthInternetR(PKG_Constant.IAA011_MIR,
                                                   PKG_Constant.IAA003_PER,
                                                   PKG_Constant.IAA018_PAS,
                                                   '1', --���ͨ��
                                                   prm_aae011,
                                                   '1', --ȫ��
                                                   prm_AppCode,
                                                   prm_ErrorMsg);
             IF prm_AppCode <> gn_def_OK THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := '�������걨��˹���prc_AuditMonthInternetR����:' ||
                               prm_ErrorMsg ||
                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
               RETURN;
             END IF;
           ELSE
             --���걨���ͨ�� (������)
             PKG_Insurance.prc_YLAuditMonth(PKG_Constant.IAA011_MIR,
                                            PKG_Constant.IAA003_PER,
                                            PKG_Constant.IAA018_PAS,
                                            '1', --���ͨ��
                                            prm_aae011,
                                            '1', --ȫ��
                                            prm_AppCode,
                                            prm_ErrorMsg);
             IF prm_AppCode <> gn_def_OK THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := '�������걨��˹���prc_YLAuditMonth����:' || prm_ErrorMsg ||
                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
               RETURN;
             END IF;
           END IF;
         END IF;
       END IF;
     END IF;
     /**
             prc_MonthInternetRegister
             �¶Ƚɷ��걨�����[��������걨�����α���Ա]
           */

     SELECT COUNT(1)
       INTO n_count
       FROM wsjb.IRAC01 a, wsjb.IRAD02 b, wsjb.IRAD01 c
      WHERE a.iac001 = b.iaz007
        and b.iaz004 = c.iaz004
        and c.aab001 = v_aab001
        AND a.iaa001 = '2' --��ϵͳ���߰���һ��ȡ��ע�ͱ���ע�� 20160516
           --and a.iaa001 IN ('2','3','7','9','10')
        and c.iaa011 = PKG_Constant.IAA011_MIR
        and a.iaa002 = PKG_Constant.IAA002_AIR
        and c.iaa100 = prm_iaa100;

     --�������걨�����α���Ա
     IF n_count > 0 THEN
       DELETE FROM wsjb.IRAD22_TMP;
       INSERT INTO wsjb.IRAD22_TMP
         (IAC001, --�걨��Ա��Ϣ���,VARCHAR2
          AAC001, --���˱��,VARCHAR2
          AAB001, --��λ���,VARCHAR2
          AAC002, --������ݺ���,VARCHAR2
          AAC003, --����,VARCHAR2
          IAA001, --��Ա���
          IAZ005, --�걨��ϸID
          IAA003) --ҵ������
         SELECT a.IAC001, --�걨��Ա��Ϣ���,VARCHAR2
                a.AAC001, --���˱��,VARCHAR2
                a.AAB001, --��λ���,VARCHAR2
                a.AAC002, --������ݺ���,VARCHAR2
                a.AAC003, --����,VARCHAR2
                a.IAA001, --��Ա���
                b.IAZ005, --�걨��ϸID
                '2' IAA003 --ҵ������
           FROM wsjb.IRAC01 a, wsjb.IRAD02 b, wsjb.IRAD01 c
          WHERE a.iac001 = b.iaz007
            and b.iaz004 = c.iaz004
            and c.aab001 = v_aab001
            AND a.iaa001 = '2' --��ϵͳ���߰���һ��ȡ��ע�ͱ���ע�� 20160516
               -- and a.iaa001 IN ('2','3','7','9','10')
            and c.iaa011 = PKG_Constant.IAA011_MIR
            and a.iaa002 = PKG_Constant.IAA002_AIR
            and c.iaa100 = prm_iaa100;
       IF num_count2 > 0 THEN
         --���걨���ͨ��
         PKG_Insurance.prc_AuditMonthInternetR(PKG_Constant.IAA011_MIR,
                                               PKG_Constant.IAA003_PER,
                                               PKG_Constant.IAA018_PAS,
                                               '1', --���ͨ��
                                               prm_aae011,
                                               '1', --ȫ��
                                               prm_AppCode,
                                               prm_ErrorMsg);
         IF prm_AppCode <> gn_def_OK THEN
           ROLLBACK;
           prm_AppCode  := gn_def_ERR;
           prm_ErrorMsg := '�������걨��˹���prc_AuditMonthInternetR����:' ||
                           prm_ErrorMsg ||
                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
           RETURN;
         END IF;
       ELSE
         --���걨���ͨ�� (������)
         PKG_Insurance.prc_YLAuditMonth(PKG_Constant.IAA011_MIR,
                                        PKG_Constant.IAA003_PER,
                                        PKG_Constant.IAA018_PAS,
                                        '1', --���ͨ��
                                        prm_aae011,
                                        '1', --ȫ��
                                        prm_AppCode,
                                        prm_ErrorMsg);
         IF prm_AppCode <> gn_def_OK THEN
           ROLLBACK;
           prm_AppCode  := gn_def_ERR;
           prm_ErrorMsg := '�������걨��˹���prc_YLAuditMonth����:' || prm_ErrorMsg ||
                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
           RETURN;
         END IF;
       END IF;
     END IF;

     --- �¶Ƚɷ��걨�����[�²α�]
     -- ��ϵͳ���ߺ�ſ�ע�� 20160325
     --��ѯirad01 ���ֻ��һ�� ���¿��� ���Զ�ͨ��
     SELECT COUNT(1)
       INTO count_month
       FROM wsjb.irad01
      WHERE aab001 = v_aab001
        and iaa011 = 'A04';
     IF count_month > 1 THEN
       IF n_account_loginid > 0 THEN
         SELECT COUNT(1)
           INTO n_count
           FROM wsjb.IRAC01 a, wsjb.IRAD02 b, wsjb.IRAD01 c
          WHERE a.iac001 = b.iaz007
            and b.iaz004 = c.iaz004
            and c.aab001 = v_aab001
            and a.iaa001 in ('1', '6')
            and c.iaa011 = PKG_Constant.IAA011_MIR
            and a.iaa002 = PKG_Constant.IAA002_AIR
            and c.iaa100 = prm_iaa100;
         -- AND a.aae011 <> prm_aae011;

         --�²α��Ǽ����ͨ����ֱ�����ͨ��
         IF n_count > 0 THEN
           DELETE FROM wsjb.IRAD22_TMP;
           INSERT INTO wsjb.IRAD22_TMP
             (IAC001, --�걨��Ա��Ϣ���,VARCHAR2
              AAC001, --���˱��,VARCHAR2
              AAB001, --��λ���,VARCHAR2
              AAC002, --������ݺ���,VARCHAR2
              AAC003, --����,VARCHAR2
              IAA001, --��Ա���
              IAZ005, --�걨��ϸID
              IAA003) --ҵ������
             SELECT a.IAC001, --�걨��Ա��Ϣ���,VARCHAR2
                    a.AAC001, --���˱��,VARCHAR2
                    a.AAB001, --��λ���,VARCHAR2
                    a.AAC002, --������ݺ���,VARCHAR2
                    a.AAC003, --����,VARCHAR2
                    a.IAA001, --��Ա���
                    b.IAZ005, --�걨��ϸID
                    '2' IAA003 --ҵ������
               FROM wsjb.IRAC01 a, wsjb.IRAD02 b, wsjb.IRAD01 c
              WHERE a.iac001 = b.iaz007
                and b.iaz004 = c.iaz004
                and c.aab001 = v_aab001
                and a.iaa001 in ('1', '6')
                and c.iaa011 = PKG_Constant.IAA011_MIR
                and a.iaa002 = PKG_Constant.IAA002_AIR
                and c.iaa100 = prm_iaa100;
           --  AND a.aae011 <> prm_aae011;
           IF num_count2 > 0 THEN
             --���걨���ͨ��
             PKG_Insurance.prc_AuditMonthInternetR(PKG_Constant.IAA011_MIR,
                                                   PKG_Constant.IAA003_PER,
                                                   PKG_Constant.IAA018_PAS,
                                                   '1', --���ͨ��
                                                   prm_aae011,
                                                   '1', --ȫ��
                                                   prm_AppCode,
                                                   prm_ErrorMsg);
             IF prm_AppCode <> gn_def_OK THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := '�������걨��˹���prc_AuditMonthInternetR����:' ||
                               prm_ErrorMsg ||
                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
               RETURN;
             END IF;
           ELSE
             --���걨���ͨ�� (������)
             PKG_Insurance.prc_YLAuditMonth(PKG_Constant.IAA011_MIR,
                                            PKG_Constant.IAA003_PER,
                                            PKG_Constant.IAA018_PAS,
                                            '1', --���ͨ��
                                            prm_aae011,
                                            '1', --ȫ��
                                            prm_AppCode,
                                            prm_ErrorMsg);
             IF prm_AppCode <> gn_def_OK THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := '�������걨��˹���prc_YLAuditMonth����:' || prm_ErrorMsg ||
                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
               RETURN;
             END IF;
           END IF;
         END IF;
       END IF;
     END IF;
     /**
              prc_MonthInternetRegister
              Ӧ�պ˶�����[û����Ա���������걨��ֱ��Ӧ�պ˶�������û�����ӣ�ֻ�м��ٵ�ֱ�Ӻ˶����� �²α�Ҳֱ�Ӻ˶�����]
           */
     IF n_account_loginid > 0 THEN
       IF count_month > 1 THEN
         IF n_rate < 100 THEN
           SELECT COUNT(1)
             INTO n_count
             FROM wsjb.IRAC01 a, wsjb.IRAA01 b
            WHERE a.aab001 = b.aab001
              AND a.iaa002 = PKG_Constant.IAA002_AIR
              AND b.yae092 = prm_aae011
              AND a.iaa001 in ('5', '8') --  NOT IN ('2','4')
              AND a.iaa100 = prm_iaa100;
           IF n_count = 0 THEN
             IF num_count2 > 0 THEN
               --�����ϵ�AC02û����Ա�α���Ϣ ���Լ�������ж������Ƿ�Ϊ�����ϵ�λ
               SELECT COUNT(1)
                 INTO N_COUNT1
                 FROM xasi2.AC02 A, wsjb.IRAA01 B
                WHERE A.AAB001 = B.AAB001
                  AND B.YAE092 = PRM_AAE011;
               IF N_COUNT1 = 0 THEN
                 prm_ErrorMsg := '��λû���κ���Ա�α��������ڿ��걨����Ϣ!';
                 RETURN;
               ELSE
                 --û����Ա���������걨��ֱ��Ӧ�պ˶�����
                 PKG_Insurance.prc_checkAndFinaPlan(v_aab001,
                                                    to_number(prm_iaa100),
                                                    '3', --��˰����
                                                    to_number(prm_aae011),
                                                    '1',
                                                    prm_AppCode,
                                                    prm_ErrorMsg);
                 IF prm_AppCode <> gn_def_OK THEN
                   ROLLBACK;
                   prm_AppCode  := gn_def_ERR;
                   prm_ErrorMsg := '����Ӧ�պ˶���������prc_checkAndFinaPlan����111:' ||
                                   prm_ErrorMsg ||
                                   DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                   RETURN;
                 END IF;


                   -- ����ֱ�ӵ����ƿ����� 20190617 begin
                 PKG_Insurance.prc_insertAC29(
                                 v_aab001, --��λ������
                                 prm_iaa100  ,
                                 prm_aae011, --������
                                 prm_AppCode, --�������
                                 prm_ErrorMsg); --��������
                  IF prm_AppCode <> gn_def_OK THEN
                  ROLLBACK;
                  prm_AppCode  :=  gn_def_ERR;
                  prm_ErrorMsg := '�����ƿ�����prc_insertAC29����:' ||prm_ErrorMsg||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                  RETURN;
                  END IF;
                    -- ����ֱ�ӵ����ƿ����� 20190617  end
               END IF;
             ELSE
               --û����Ա���������걨��ֱ��Ӧ�պ˶����� (������)
               PKG_Insurance.prc_checkAndFinaPlan(v_aab001,
                                                  to_number(prm_iaa100),
                                                  '3', --��˰����
                                                  to_number(prm_aae011),
                                                  '1',
                                                  prm_AppCode,
                                                  prm_ErrorMsg);
               IF prm_AppCode <> gn_def_OK THEN
                 ROLLBACK;
                 prm_AppCode  := gn_def_ERR;
                 prm_ErrorMsg := '����Ӧ�պ˶���������prc_checkAndFinaPlan����:' ||
                                 prm_ErrorMsg ||
                                 DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                 RETURN;
               END IF;
             END IF;
           END IF;
         END IF;
       END IF;
     ELSE
       SELECT COUNT(1)
         INTO n_count
         FROM wsjb.IRAC01 a, wsjb.IRAA01 b
        WHERE a.aab001 = b.aab001
          AND a.iaa002 = PKG_Constant.IAA002_AIR
          AND b.yae092 = prm_aae011
          AND a.iaa001 not in
              (PKG_Constant.IAA001_GEN, PKG_Constant.IAA001_MDF) --IN ('1','5','8','6')
          AND a.iaa100 = prm_iaa100;
       IF n_count = 0 THEN
         IF num_count2 > 0 THEN
           --�����ϵ�AC02û����Ա�α���Ϣ ���Լ�������ж������Ƿ�Ϊ�����ϵ�λ
           SELECT COUNT(1)
             INTO N_COUNT1
             FROM xasi2.AC02 A, wsjb.IRAA01 B
            WHERE A.AAB001 = B.AAB001
              AND B.YAE092 = PRM_AAE011;
           IF N_COUNT1 = 0 THEN
             prm_ErrorMsg := '��λû���κ���Ա�α��������ڿ��걨����Ϣ!';
             RETURN;
           ELSE
             --û����Ա���������걨��ֱ��Ӧ�պ˶�����
             PKG_Insurance.prc_checkAndFinaPlan(v_aab001,
                                                to_number(prm_iaa100),
                                                '3', --��˰����
                                                to_number(prm_aae011),
                                                '1',
                                                prm_AppCode,
                                                prm_ErrorMsg);
             IF prm_AppCode <> gn_def_OK THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := '����Ӧ�պ˶���������prc_checkAndFinaPlan����111:' ||
                               prm_ErrorMsg ||
                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
               RETURN;
             END IF;
           END IF;
         ELSE
           --û����Ա���������걨��ֱ��Ӧ�պ˶����� (������)
           PKG_Insurance.prc_checkAndFinaPlan(v_aab001,
                                              to_number(prm_iaa100),
                                              '3', --��˰����
                                              to_number(prm_aae011),
                                              '1',
                                              prm_AppCode,
                                              prm_ErrorMsg);
           IF prm_AppCode <> gn_def_OK THEN
             ROLLBACK;
             prm_AppCode  := gn_def_ERR;
             prm_ErrorMsg := '����Ӧ�պ˶���������prc_checkAndFinaPlan����:' ||
                             prm_ErrorMsg ||
                             DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
             RETURN;
           END IF;
         END IF;
       END IF;
     END IF;

 /*-----------------------------SIGN  ԭ��  END---------------------------*/
   END IF;
  /*------------------------MODIFY  BY WHM ON 20190314  END----------------------*/


     <<leb_suss>>
      n_count :=0;
      EXCEPTION
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END prc_MonthInternetRegister;

    /*****************************************************************************
   ** �������� : prc_AuditMonthInternetR
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_iaa011       IN     iraa02.iaa011%TYPE,--ҵ������
   **           prm_iaa003       IN     iraa02.iaa003%TYPE,--ҵ������
   **           prm_iaa004       IN     iraa02.iaa011%TYPE,--��˱�־
   **           prm_iaa028       IN     VARCHAR2          ,--�Ƿ�ȫ��
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_aae013       IN     iraa02.aae013%TYPE,--��ע
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-29   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_AuditMonthInternetR (
      prm_iaa011       IN     iraa02.iaa011%TYPE,--ҵ������
      prm_iaa003       IN     iraa02.iaa003%TYPE,--ҵ������
      prm_iaa018       IN     irad22.iaa018%TYPE,--��˱�־
      prm_iaa028       IN     VARCHAR2          ,--�Ƿ�ȫ��
      prm_aae011       IN     iraa02.iaa011%TYPE,--������
      prm_aae013       IN     iraa02.aae013%TYPE,--��ע
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      n_count    number(5);
      v_iaz011   varchar2(15);
      v_iaz009   varchar2(15);
      v_iaz010   varchar2(15);
      v_aaz002   varchar2(15);
      v_iaa015   varchar2(1);
      v_iaa004   number(1);
      v_iaa014   number(1);
      v_iaa017   number(1);
      v_yae099   varchar2(15);
      max_aae001 number(4);
      sum_YAC004 number(12,2);
      var_aab001 varchar2(6);
      max_ny_aae001 number(6);

      --�����α꣬��ȡ���������Ա��Ϣ
      CURSOR cur_tmp_person IS
      SELECT a.IAC001, --�걨��Ա��Ϣ���,VARCHAR2
             b.AAC001, --���˱��,VARCHAR2
             a.AAB001, --��λ���,VARCHAR2
             a.AAC002, --������ݺ���,VARCHAR2
             a.AAC003, --����,VARCHAR2
             b.IAA001, --��Ա���
             a.IAZ005, --�걨��ϸID
             a.IAA003  --ҵ������
        FROM wsjb.IRAD22_TMP  a,wsjb.IRAC01  b --���������Ա��Ϣ��ʱ��
       WHERE a.iac001 = b.iac001
        ORDER by a.iaa003;

      CURSOR cur_tmp_unit IS
      SELECT distinct aab001
        FROM wsjb.IRAD22_TMP  a;

                -- ��λ�α��α�
   /* CURSOR cur_canbao_company  IS
      SELECT
        AAB001,
        AAE140
       FROM xasi2.ab02
       WHERE  aab001 = var_aab001 and aab051='1' and aae140<>'07';*/


   BEGIN

      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;

      /*�����ʱ���Ƿ��������*/
      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.IRAD22_TMP ;
      IF n_count = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'�����ʱ���޿�������!';
         RETURN;
      END IF;


      /*��Ҫ������У��*/
      IF prm_iaa011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'ҵ�����Ͳ���Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa003 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'ҵ�����岻��Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa018 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'��˱�־����Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa028 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'��־[�Ƿ�ȫ��]����Ϊ��!';
         RETURN;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
      IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�AAZ002!';
         RETURN;
      END IF;

      v_iaz009 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ009');
      IF v_iaz009 IS NULL OR v_iaz009 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�IAZ009!';
         RETURN;
      END IF;


    /**  v_yae099 := xasi2.PKG_COMM.FUN_GETSEQUENCE(NULL,'YAE099');
      IF v_yae099 IS NULL OR v_yae099 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�YAE099!';
         RETURN;
      END IF;
      */

      --����¼�
      INSERT INTO wsjb.IRAD21
                 (
                  IAZ009,
                  AAZ002,
                  IAA011,
                  AEE011,
                  AAE035,
                  YAB003,
                  AAE013
                  )
                  VALUES
                  (
                  v_iaz009,
                  v_aaz002,
                  prm_iaa011,
                  prm_aae011,
                  sysdate,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae013
      );

      FOR REC_TMP_PERSON IN cur_tmp_person LOOP

         --�걨�����Ǹ���ʱУ�飺���뵥λ��Ϣ���ͨ�����ܰ���
         IF REC_TMP_PERSON.iaa003 = PKG_Constant.IAA003_PER THEN
            SELECT COUNT(1)
              INTO n_count
              FROM wsjb.IRAB01
             WHERE AAB001 = REC_TMP_PERSON.AAB001
               AND IAA002 = PKG_Constant.IAA002_APS;
            IF n_count = 0 THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'��λ��Ϣ���ͨ�����ܰ�����Ա���걨���!';
               RETURN;
            END IF;
         END IF;

          /*
            �����Ա����Ϣ���
            ���԰�����Ǵ�� ͨ�� ��ͨ�� ����ͨ�� ȫ��ͨ�� ȫ��ͨ��
         */

         --�����ϸ����
         v_iaz010 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ010');
         IF v_iaz010 IS NULL OR v_iaz010 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�IAZ010!';
            RETURN;
         END IF;

         --��ѯ�ϴ�������
         BEGIN
            SELECT IAA015
              INTO v_iaa015
              FROM wsjb.IRAD02
             WHERE IAZ005 = REC_TMP_PERSON.IAZ005;

            IF v_iaa015 in (PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
              prm_ErrorMsg := PRE_ERRCODE ||'����Ѿ��ս�!';
              RETURN;
           END IF;

            --��ȡ�ϴ������Ϣ
            IF v_iaa015 = PKG_Constant.IAA015_ADI THEN
               BEGIN
                  SELECT A.IAZ010,
                         A.IAA004,
                         A.IAA014,
                         A.IAA017
                    INTO v_iaz011,
                         v_iaa004,
                         v_iaa014,
                         v_iaa017
                    FROM wsjb.IRAD22  A
                   WHERE A.IAA018 NOT IN (
                                          PKG_Constant.IAA018_DAD, --���[�������]
                                          PKG_Constant.IAA018_NPS  --��ͨ�� Not Pass
                                         )
                     AND A.IAZ005 = REC_TMP_PERSON.IAZ005
                     AND A.IAZ010 = (
                                      SELECT MAX(IAZ010)
                                        FROM wsjb.IRAD22
                                       WHERE IAZ005 = A.IAZ005
                                         AND IAA018 = A.IAA018
                                    );
                  EXCEPTION
                  WHEN OTHERS THEN
                     ROLLBACK;
                     prm_AppCode  := gn_def_ERR;
                     prm_ErrorMsg := PRE_ERRCODE ||'�걨��Ϣ��������У���δ��ȡ���ϴ������Ϣ,��ȷ���ϴ�����Ƿ��ս�!';
                     RETURN;
               END;

               v_iaa014 := v_iaa017;
               v_iaa017 := v_iaa017 + 1;
               IF v_iaa017 > v_iaa004 THEN
                  v_iaa017 := v_iaa004;
               END IF;

               --��˼��ε��ڵ�ǰ����
               IF v_iaa004 = v_iaa014 AND v_iaa004 = v_iaa017 THEN
                  ROLLBACK;
                  prm_AppCode  := gn_def_ERR;
                  prm_ErrorMsg := PRE_ERRCODE ||'����Ѿ��ս�!';
                  RETURN;
               END IF;
            END IF;

            --��ȡ�걨��ϸ��Ϣ
            IF v_iaa015 = PKG_Constant.IAA015_WAD THEN
               BEGIN
                  SELECT A.IAA004,
                         A.IAA014
                    INTO v_iaa004,
                         v_iaa014
                    FROM wsjb.IRAD02  A
                   WHERE A.IAZ005 = REC_TMP_PERSON.IAZ005;
                  EXCEPTION
                  WHEN OTHERS THEN
                     ROLLBACK;
                     prm_AppCode  := gn_def_ERR;
                     prm_ErrorMsg := PRE_ERRCODE ||'û����ȡ���걨��ϸ��Ϣ!';
                     RETURN;
               END;
               v_iaz011 := v_iaz010;
               v_iaa014 := v_iaa014 + 1;
               v_iaa017 := v_iaa014 + 1;
               IF v_iaa017 > v_iaa004 THEN
                  v_iaa017 := v_iaa004;
               END IF;
            END IF;

            EXCEPTION
            WHEN OTHERS THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := '�����Ϣ��ȡ����:'|| PRE_ERRCODE || SQLERRM ||dbms_utility.format_error_backtrace ;
               RETURN;
         END;

         --�����ϸд��
         INSERT INTO wsjb.IRAD22
                    (
                     IAZ010,
                     IAZ011,
                     IAZ009,
                     IAZ005,
                     IAA004,
                     IAA014,
                     IAA017,
                     AAE011,
                     AAE035,
                     YAB003,
                     IAA018,
                     IAD005,    --������
                     AAE013
                     )
                    VALUES
                    (
                     v_iaz010,
                     v_iaz011,
                     v_iaz009,
                     REC_TMP_PERSON.IAZ005,
                     v_iaa004,
                     v_iaa014,
                     v_iaa017,
                     prm_aae011,
                     sysdate,
                     PKG_Constant.YAB003_JBFZX,
                     prm_iaa018,
                     prm_aae013,  --������
                     null
         );

         --���
         IF prm_iaa018 = PKG_Constant.IAA018_DAD THEN

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_DAD,--���[�޸�����]
                   AAE013 = prm_aae013
             WHERE IAA015 = PKG_Constant.IAA015_WAD --����
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_ALR  --�Ѵ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --���δͨ��
         IF prm_iaa018 = PKG_Constant.IAA018_NPS THEN

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015  = PKG_Constant.IAA015_ADO, --������
                   AAE013  = prm_aae013
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --����/�����
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_NPS  --δͨ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --���ͨ��
         IF prm_iaa018 = PKG_Constant.IAA018_PAS AND v_iaa014 = v_iaa004 THEN

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015  =  PKG_Constant.IAA015_ADO --������
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --����/�����
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            v_yae099    := xasi2.PKG_comm.fun_GetSequence(NULL,'yae099');
            IF v_yae099 IS NULL OR v_yae099 = '' THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ��ϵͳ������к�:YAE099';
               RETURN;
             END IF;

            IF REC_TMP_PERSON.iaa003 = '2' THEN


               /*
                  ��Ա����[�²α��������²α�]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_ADD,PKG_Constant.IAA001_PAD) THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[�²α� ����]
                     �Ϸ��� prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuCheck(v_yae099,
                                  REC_TMP_PERSON.AAB001,
                                  REC_TMP_PERSON.IAC001,
                                  prm_aae011,
                                  PKG_Constant.YAB003_JBFZX,
                                  sysdate,
                                  prm_AppCode,
                                  prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  ��Ա����[��Ա��������]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_IAD THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[�²α� ����]
                     �Ϸ��� prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuAddCheck(v_yae099,
                                    REC_TMP_PERSON.AAB001,
                                    REC_TMP_PERSON.IAC001,
                                    prm_aae011,
                                    PKG_Constant.YAB003_JBFZX,
                                    sysdate,
                                    prm_AppCode,
                                    prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  ��Ա����[��Ա����]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_CIN THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[�²α� ����]
                     �Ϸ��� prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuContinue(v_yae099,
                                    REC_TMP_PERSON.AAB001,
                                    REC_TMP_PERSON.IAC001,
                                    prm_aae011,
                                    PKG_Constant.YAB003_JBFZX,
                                    sysdate,
                                    prm_AppCode,
                                    prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  ��Ա����[��Ա��ͣ�ɷ���������ͣ�ɷѣ�������Ա����(����ͣ��ͬ)]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_MIN,PKG_Constant.IAA001_PMI,PKG_Constant.IAA001_RPD) THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[ͣ�� ����]
                     �Ϸ��� prc_AuditMonthInternetRpause
                  */

                  prc_PersonInsuPause(v_yae099,
                                      REC_TMP_PERSON.AAB001,
                                      REC_TMP_PERSON.IAC001,
                                      prm_aae011,
                                      PKG_Constant.YAB003_JBFZX,
                                      sysdate,
                                      prm_AppCode,
                                      prm_ErrorMsg
                                      );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  ��Ա����[��ְת����]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_RTR THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[ͣ�� ����]
                     �Ϸ��� prc_AuditMonthInternetRpause
                  */
                  --����������� �޸ĸ���״̬�Լ����²α���Ϣ
                  v_yae099 := NULL;

                  BEGIN
                     SELECT MAX(yae099)
                       INTO v_yae099
                       FROM XASI2.ac02_apply
                      WHERE AAC001 = REC_TMP_PERSON.AAC001
                        AND AAB001 = REC_TMP_PERSON.AAB001
                        AND YAE031 = '0'                    --δ���
                        AND AAE120 = '0'
                        AND FLAG   = '3';                   --��������
                     EXCEPTION
                      WHEN OTHERS THEN
                          prm_AppCode  :=  gn_def_ERR;
                          prm_ErrorMsg :=  PRE_ERRCODE || '������������û�л�ȡ��!';
                          RETURN;
                  END;

                  prc_PersonInsuToRetire(v_yae099,
                                        REC_TMP_PERSON.AAB001,
                                        REC_TMP_PERSON.IAC001,
                                        prm_aae011,
                                        PKG_Constant.YAB003_JBFZX,
                                        sysdate,
                                        prm_AppCode,
                                        prm_ErrorMsg
                                        );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;


      -- ����prc_Ab02a8Unit ��λ�ɷѻ���
   /*      prc_Ab02a8Unit(     REC_TMP_PERSON.AAB001,
                                v_yae099,
                                prm_AppCode,
                                prm_ErrorMsg
                                        );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;*/


    -- ����ab02a8����
    --��ȡ������

  /**  select max(AAE001)
      into max_aae001
      from xasi2.ab05
     where aab001 = REC_TMP_PERSON.AAB001
       and YAB007 = '03';
     max_ny_aae001 := max_aae001||'01';

      var_aab001 := REC_TMP_PERSON.AAB001;
    FOR REC_CANBAO_COMPANY IN cur_canbao_company LOOP

      SELECT COUNT(1)
        INTO n_count
        FROM xasi2.ab02a8
       where aab001 = REC_TMP_PERSON.AAB001
         and aae001 = max_aae001
         and aae140 = REC_CANBAO_COMPANY.AAE140;

      IF n_count = 0 THEN

        Insert Into xasi2.ab02a8
          (YAE099, --   ҵ����ˮ��
           AAB001, --   ��λ���
           AAE140, --  ��������
           AAE041, --   ��ʼ�ں�
           AAE042, --   ��ֹ�ں�
           AAB121, --   ��λ�ɷѻ����ܶ�
           AAE001, --   ���
           AAE011, --   ������
           AAE036, --    ����ʱ��
           YAB003, --  �籣�������
           YAE031, --   ��˱�־
           YAE032, --   �����
           YAE033, --   ���ʱ��
           YAE569, --  ��˾������
           YAB139, --   �α�����������
           AAE013 --  ��ע
           )
         select  v_yae099,
                 AAB001,
                 REC_CANBAO_COMPANY.AAE140,
                 max_ny_aae001,
                 null,
                (select sum(YAC004)
                  from xasi2.ac02
           where AAb001 = REC_TMP_PERSON.AAB001
             and YAc503 in( '0','5')
             and AAC031 = '1'
             and AAE140 = REC_CANBAO_COMPANY.AAE140)  yac004 ,
                 max_aae001,
                 AAE011,
                 AAE036,
                 YAB003,
                 '1',
                 AAE011,
                 AAE036,
                 YAB003,
                 YAB139,
                 AAE013
            from xasi2.ab02
           where
             AAb001=REC_TMP_PERSON.AAB001
            and   aab051='1'
            and AAE140 = REC_CANBAO_COMPANY.AAE140;


      end if;

      IF n_count = 1 THEN

        select sum(YAC004)
          into sum_YAC004
          from xasi2.ac02
         where AAE140 = REC_CANBAO_COMPANY.AAE140
           and AAB001 = REC_TMP_PERSON.AAB001
           and YAc503 in( '0','5')
           and AAC031 = '1';

        update xasi2.ab02a8
           set AAB121 = sum_YAC004 --   ��λ�ɷѻ����ܶ�
         where AAB001 = REC_TMP_PERSON.AAB001
           and AAE140 = REC_CANBAO_COMPANY.AAE140;

      end if;
    end LOOP;
    */



               --2013-03-14 ����  Ӧ�����Ƚ��в���������״̬
               --�����걨��Ա״̬
               UPDATE wsjb.irac01
                  SET IAA002 = PKG_Constant.IAA002_APS  --��ͨ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;
            --������ر�
            INSERT INTO wsjb.AE02A1
                        (
                         AAZ002,
                         YAE099,
                         IAA020,
                         AAB001,
                         AAC001,
                         IAA001
                        )
                  VALUES(
                        v_aaz002,
                        v_yae099,
                        REC_TMP_PERSON.iaa003,
                        REC_TMP_PERSON.AAB001,
                        REC_TMP_PERSON.IAC001,
                        REC_TMP_PERSON.IAA001
                        );
         END IF;

      END LOOP;
    for aunit in cur_tmp_unit loop
       v_yae099    := xasi2.PKG_comm.fun_GetSequence(NULL,'yae099');
           prc_Ab02a8Unit(     aunit.AAB001,
                                v_yae099,
                                prm_AppCode,
                                prm_ErrorMsg
                                        );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
     end loop;


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
                  PKG_Constant.AAA121_MIA,
                  prm_aae011,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae011,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate,
                  prm_aae013
                 );
   EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
         RETURN;
   END prc_AuditMonthInternetR;

   /***************************************************************************
   ** ���̳� ��prc_AuditMonthInternetRpause
   ** ���̺� ��
   ** ҵ��� ������ͣ��
   ** ������ ������ͣ��
   ****************************************************************************
   ** ������ ��������ʶ        ����/���           ����               ����
   ****************************************************************************
   **
   ** ��  �ߣ�     �������� ��2009-11-26   �汾��� ��Ver 1.0.0
   ****************************************************************************
   ** ��  �ģ�
   ****************************************************************************
   ** ��  ע��prm_AppCode ������:���̱�ţ�2λ�� �� ˳��ţ�2λ��
   ***************************************************************************/
   --����ͣ��
   PROCEDURE prc_AuditMonthInternetRpause
                            (prm_yae099       IN    xasi2.ac05.YAE099%TYPE  ,     --ҵ����ˮ��
                             prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --��λ����
                             prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                             prm_aae011       IN    irac01.aae011%TYPE ,    --������
                             prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                             prm_aae036       IN    irac01.aae036%TYPE ,    --����ʱ��
                             prm_AppCode     OUT    VARCHAR2          ,     --ִ�д���
                             prm_ErrMsg      OUT    VARCHAR2          )     --ִ�н��
   IS
      var_aae140            xasi2.ac02.aae140%TYPE;
      dat_sysdate           DATE;
      num_count             NUMBER;
      num_yae097            NUMBER;
      var_aae119            xasi2.ab01.aae119%TYPE;
      dat_aae030            xasi2.kc08.aae030%TYPE;
      var_akc021            xasi2.kc01.akc021%TYPE;
      var_aae140_01         VARCHAR2(2);
      var_aae140_06         VARCHAR2(2);
      var_aae140_02         VARCHAR2(2);
      var_aae140_03         VARCHAR2(2);
      var_aae140_04         VARCHAR2(2);
      var_aae140_05         VARCHAR2(2);
      var_aae140_07         VARCHAR2(2);
      var_aae140_08         VARCHAR2(2);
      rec_irac01            irac01%rowtype;
      t_cols                tab_change;
      dat_yae102            xasi2.ac02.yae102%TYPE;
      dat_yae102_1          xasi2.ac02.yae102%TYPE;
      var_aac031            xasi2.ac02.aac031%TYPE;
      var_yae565            VARCHAR2(2);
      var_ermsg             VARCHAR2(100);
      var_msg               VARCHAR2(200);
      var_flag              VARCHAR2(1);


      --�����α꣬��ȡ������Ա�Ĳα��ɷ���Ϣ
      CURSOR cur_pause_aae140(var_aac001 xasi2.ac01.aac001%TYPE) IS
      SELECT AAC001, --���˱��,VARCHAR2
             AAE140  --����    ,VARCHAR2
        FROM xasi2.AC02    --�α���Ϣ��
       WHERE AAC001 = var_aac001
         AND AAB001 = prm_aab001
         AND AAC031 = PKG_Constant.AAC031_CBJF;

   BEGIN
      /*��������*/
      prm_AppCode    := gn_def_OK ;
      prm_ErrMsg     := ''       ;
      dat_sysdate    := SYSDATE;
      num_count      := 0;

      IF prm_yae099 IS NULL THEN
         prm_AppCode := gn_def_ERR;
         prm_ErrMsg  := 'ҵ����ˮ�Ų���Ϊ�գ�';
         RETURN;
      END IF;

      IF prm_aab001 IS NULL THEN
         prm_AppCode := gn_def_ERR;
         prm_ErrMsg  := '��λ��Ų���Ϊ�գ�';
         RETURN;
      END IF;

      IF prm_iac001 IS NULL THEN
         prm_AppCode := gn_def_ERR;
         prm_ErrMsg  := '��Ա��Ų���Ϊ�գ�';
         RETURN;
      END IF;

      IF prm_aae011 IS NULL THEN
         prm_AppCode := gn_def_ERR;
         prm_ErrMsg  := '�����˲���Ϊ�գ�';
         RETURN;
      END IF;

      IF prm_yab003 IS NULL THEN
         prm_AppCode := gn_def_ERR;
         prm_ErrMsg  := '�����������Ϊ�գ�';
         RETURN;
      END IF;

      SELECT aae119
        INTO var_aae119
        FROM xasi2.ab01
       WHERE aab001 = prm_aab001;

      --��Ա��Ϣ��ѯ
      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      dat_yae102_1  := TRUNC(TO_DATE(rec_irac01.iaa100,'yyyymm'),'month');--���걨�¶ȵ�1����Ϊͣ������
      var_aae140_01 := rec_irac01.aae110;        --�Ƿ�μ�����ҵ����
      var_aae140_06 := rec_irac01.aae120;        --�Ƿ�μ��˻�������
      var_aae140_02 := rec_irac01.aae210;        --�Ƿ�μ���ʧҵ
      var_aae140_03 := rec_irac01.aae310;        --�Ƿ�μ��˻���ҽ��
      var_aae140_04 := rec_irac01.aae410;        --�Ƿ�μ��˹���
      var_aae140_05 := rec_irac01.aae510;        --�Ƿ�μ�������
      var_aae140_07 := rec_irac01.aae311;        --�Ƿ�μ��˴��
      var_aae140_08 := rec_irac01.aae810;

      IF var_aae140_06 = '3' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE120';
         t_cols(t_cols.count).col_value := '06';
      END IF;

      IF var_aae140_02 = '3' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE210';
         t_cols(t_cols.count).col_value := '02';
      END IF;

      --����ְ��Ա������ͣ����ҽ�Ʊ���
      IF rec_irac01.aac008 = PKG_Constant.AAC008_ZZ THEN
         IF var_aae140_03 = '3' THEN
            t_cols(t_cols.COUNT+1).col_name := 'AAE310';
            t_cols(t_cols.count).col_value := '03';
         END IF;
      END IF;

      IF var_aae140_04 = '3' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE410';
         t_cols(t_cols.count).col_value := '04';
      END IF;

      IF var_aae140_05 = '3' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE510';
         t_cols(t_cols.count).col_value := '05';
      END IF;

      --����ְ��Ա������ͣ����ҽ��
      IF rec_irac01.aac008 = PKG_Constant.AAC008_ZZ THEN
         IF var_aae140_07 = '3' THEN
            t_cols(t_cols.COUNT+1).col_name := 'AAE311';
            t_cols(t_cols.count).col_value := '07';
         END IF;
      END IF;

      IF rec_irac01.aac008 = PKG_Constant.AAC008_ZZ THEN
         IF var_aae140_08 = '3' THEN
            t_cols(t_cols.COUNT+1).col_name := 'AAE810';
            t_cols(t_cols.count).col_value := '08';
         END IF;
      END IF;
      IF t_cols.count < 1 THEN
         prm_AppCode := gn_def_ERR;
         prm_ErrMsg  := rec_irac01.aac001 || 'û�л��Ҫͣ����������Ϣ��';
         RETURN;
      END IF;

      /*
      ��ͣУ��:
          ���֣��α�״̬;
          ͣ��ǰ�Ƿ��������Ƿ��
          ͣ������֮���������ʵ�ɺ�Ƿ��
          ͣ������֮���ܴ���ʧҵ����
      */
      FOR i in 1 .. t_cols.count  LOOP
         var_aae140 := t_cols(i).col_value;
         --���˲α�״̬
         BEGIN
            SELECT aac031,
                   yae102
              INTO var_aac031,
                   dat_yae102
              FROM xasi2.ac02
             WHERE aac001 = rec_irac01.aac001
               AND aab001 = prm_aab001
               AND aae140 = var_aae140
               AND yab139 = PKG_Constant.YAB003_JBFZX;
         EXCEPTION
            WHEN OTHERS THEN
               IF rec_irac01.aac008 = PKG_Constant.AAC008_ZZ THEN
                  prm_AppCode := gn_def_ERR;
                  prm_ErrMsg   := '���������֣�'||xasi2.PKG_COMM.fun_getAaa103('AAE140',var_aae140)||'��ָ����λ�ĸ��˲α���ϵ'||';';
                  RETURN;
               END IF;
         END;
         IF var_aac031 <> PKG_Constant.AAC031_CBJF THEN
            IF var_aae140 <> PKG_Constant.AAE140_SYU THEN
               prm_AppCode := gn_def_ERR;
               prm_ErrMsg   := rec_irac01.aac001|| '���֣�'||xasi2.PKG_COMM.fun_getAaa103('AAE140',var_aae140)||'�ĸ��˲α���ϵ��Ϊ�α��ɷѣ�������ͣ'||';';
               RETURN;
            ELSE
               IF rec_irac01.aac008 <> PKG_Constant.AAC008_TX THEN
                  prm_AppCode := gn_def_ERR;
                  prm_ErrMsg   := rec_irac01.aac001 ||'���֣�'||xasi2.PKG_COMM.fun_getAaa103('AAE140',var_aae140)||'�ĸ��˲α���ϵ��Ϊ�α��ɷѣ�������ͣ'||';';
                  RETURN;
               END IF;
            END IF;
         END IF;

         --�ж�ͣ��ǰ�Ƿ��������Ƿ��
         xasi2.pkg_P_Comm_CZ.prc_p_getYae565
                                     (PKG_Constant.YAB003_JBFZX  ,  --�α�������
                                      var_aae140         ,        --����
                                      PKG_Constant.AAC050_TB  ,   --�������
                                      var_yae565  ,               --Ƿ���жϱ�־
                                      prm_AppCode  ,              --�������
                                      prm_ErrMsg   );             --��������
         IF prm_AppCode <> gn_def_OK THEN
             RETURN;
         END IF;
         IF var_yae565 = '3' THEN
            xasi2.pkg_gx_checkAndQuery.prc_p_checkEmployeeArrearage(
                                                             rec_irac01.aac001 ,                           --���˱��
                                                             var_aae140 ,                                  --�������ͣ�����ΪNULL��
                                                             NULL,      --��ʼ�ںţ�����ΪNULL��
                                                             TO_NUMBER(TO_CHAR(ADD_MONTHS(dat_yae102_1,1),'yyyymm')),                                              --��ֹ�ںţ�����ΪNULL��
                                                             var_flag      ,                                    --�������1���ǣ�0����
                                                             var_ermsg       ,                                  --��ϸ��Ϣ
                                                             prm_AppCode   ,
                                                             prm_ErrMsg    );
            IF prm_AppCode <> gn_def_OK THEN
               RETURN;
            ELSE
               IF var_flag = '1' THEN
                  prm_AppCode := gn_def_ERR;
                  prm_ErrMsg   := rec_irac01.aac001||'���˵Ĳα�����'||xasi2.PKG_COMM.fun_getAaa103('AAE140',var_aae140)||'����Ƿ����Ϣ������ͣ��,';
                  RETURN;
               END IF;
            END IF;
         END IF;

         --ͣ������֮���������ʵ�ɺ�Ƿ��
         SELECT COUNT(1)
           INTO num_count
           FROM (SELECT yae202
                   FROM xasi2.ac08
                  WHERE aac001 = rec_irac01.aac001
                    AND aae140 = var_aae140
                    AND aae002 > TO_NUMBER(TO_CHAR(dat_yae102_1,'yyyymm'))
                 UNION
                 SELECT yae202
                   FROM xasi2.ac08a1
                  WHERE aac001 = rec_irac01.aac001
                    AND aae140 = var_aae140
                    AND aae002 > TO_NUMBER(TO_CHAR(dat_yae102_1,'yyyymm')));
         IF num_count > 0 THEN
            prm_AppCode  := gn_def_ERR;
            prm_ErrMsg   := rec_irac01.aac001||'���֣�'||xasi2.PKG_COMM.fun_getAaa103('AAE140',var_aae140)||'��ͣ������֮�����ʵ�ɻ�Ƿ��,����ͣ��';
            RETURN;
         END IF;

         --ͣ������֮���ܴ���ʧҵ����
         IF var_aae140 = PKG_Constant.aae140_SYE THEN
            xasi2.pkg_p_interface.prc_p_checkEmployeeXZDY(
                                                      rec_irac01.aac001,      --���˱��
                                                      var_aae140       ,      --�������ͣ�����ΪNULL��
                                                      TO_NUMBER(TO_CHAR(ADD_MONTHS(dat_yae102_1,1),'yyyymm')),--��ʼ�ںţ�����ΪNULL��
                                                      NULL             ,      --��ֹ�ںţ�����ΪNULL��
                                                      PKG_Constant.YAB003_JBFZX,--�α������ģ�����ΪNULL,ĿǰԤ�����ֶΣ�
                                                      var_flag         ,      --�������1���ǣ�0����
                                                      var_msg          ,      --��ϸ��Ϣ
                                                      prm_AppCode      ,
                                                      prm_ErrMsg       )
                                                      ;
            IF prm_AppCode <> gn_def_OK THEN
               return;
            END IF;
            IF var_flag = '1' THEN
               prm_AppCode := gn_def_ERR;
               prm_ErrMsg  := rec_irac01.aac001||'ͣ������֮�����ʧҵ��������,����ͣ��';
               RETURN;
            END IF;
         END IF;
      END LOOP;

      --��ͣ����
      FOR i in 1 .. t_cols.count  LOOP

         var_aae140 := t_cols(i).col_value;
         var_akc021 := PKG_Constant.AKC021_ZZ;

         INSERT INTO xasi2.AC02A2
                     (
                      YAE099,
                      AAC001,
                      AAB001,
                      AAE140,
                      AAC031,
                      YAC505,
                      YAC033,
                      AAC030,
                      YAE102,
                      YAE097,
                      YAC503,
                      AAC040,
                      YAC004,
                      YAA333,
                      YAB013,
                      YAC002,
                      AAE009,
                      AAE008,
                      AAE010,
                      YAB139,
                      AAE011,
                      AAE036,
                      YAB003,
                      AAE013,
                      YAD050)
               SELECT prm_yae099,
                      AAC001,
                      AAB001,
                      AAE140,
                      AAC031,
                      YAC505,
                      YAC033,
                      AAC030,
                      YAE102,
                      YAE097,
                      YAC503,
                      AAC040,
                      YAC004,
                      YAA333,
                      YAB013,
                      YAC002,
                      AAE009,
                      AAE008,
                      AAE010,
                      YAB139,
                      AAE011,
                      AAE036,
                      YAB003,
                      AAE013,
                      YAD050
                 FROM xasi2.AC02
                WHERE AAC001 = rec_irac01.aac001
                  AND AAE140 = var_aae140;

         --yab136���Ϊ��ͨ��λ��ȡ��λ��������ں�,������Ǹ�����������ںŵ�����
         BEGIN
            SELECT yae097
              INTO num_yae097
              FROM xasi2.ab02
             WHERE aab001 = prm_aab001
               AND aae140 = var_aae140
               AND yab139 = PKG_Constant.YAB003_JBFZX
               ;
            EXCEPTION
            WHEN OTHERS THEN
            prm_AppCode := gn_def_ERR;
            prm_ErrMsg  := '��λ��ţ�'||prm_aab001||'û�ж�Ӧ�Ĳα���Ϣ;����:'||xasi2.PKG_COMM.fun_getAaa103('AAE140',var_aae140);
            RETURN;
         END;

         num_yae097 := TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(num_yae097),'yyyymm'),1),'yyyymm')) ;
         --����ac02
         UPDATE xasi2.ac02
            SET yae102 = sysdate,
                aac031 = PKG_Constant.AAC031_ZTJF
          WHERE aac001 = rec_irac01.aac001
            AND aab001 = prm_aab001
            AND aae140 = var_aae140
            AND aac031 = PKG_Constant.AAC031_CBJF
            AND yab139 = PKG_Constant.YAB003_JBFZX
            ;
         IF var_aae140 IN (PKG_Constant.AAE140_JBYL,PKG_Constant.AAE140_DEYL) THEN
            SELECT akc021
              INTO var_akc021
              FROM xasi2.kc01
             WHERE aac001 = rec_irac01.aac001;
         END IF;
         --д��ac05
         INSERT INTO xasi2.ac05(
                      yae099,  --ҵ����ˮ��
                      aac001,  --���˱��
                      aab001,  --��λ���
                      aae140,  --��������
                      aac050,  --���˱������
                      yae499,  --�α����ԭ��
                      aae035,  --�������
                      yae498,  --���ǰ�α�״̬
                      aac008,  --��Ա״̬
                      yac505,  --�α��ɷ���Ա���
                      yab013,  --ԭ��λ���
                      yac503,  --�������
                      aac040,  --�ɷѹ���
                      yac004,  --�ɷѻ���
                      aae002,  --�ѿ�������
                      aae013,  --��ע
                      aae011,  --������
                      aae036,  --����ʱ��
                      yab139,  --�α�����������
                      aae120,  --ע����־
                      akc021,  --ҽ����Ա���
                      yab003,  --�籣�������
                      yae384,  --ע����
                      yae385,  --ע��ʱ��
                      yae406)  --ע��ԭ��

               SELECT prm_yae099,
                      a.aac001  ,
                      a.aab001  ,
                      a.aae140  ,
                      PKG_Constant.AAC050_TB,
                      NULL,
                      sysdate,
                      PKG_Constant.AAC031_CBJF,
                      b.aac008,   --��Ա״̬
                      a.yac505,   --�α��ɷ���Ա���
                      a.yab013,   --ԭ��λ���
                      a.yac503,   --�������
                      a.aac040,   --�ɷѹ���
                      a.yac004,   --�ɷѻ���
                      num_yae097, --�ѿ�������
                      rec_irac01.aae013,   --��ע
                      prm_aae011,   --������
                      dat_sysdate,  --����ʱ��
                      PKG_Constant.YAB003_JBFZX,   --�α�����������
                      PKG_Constant.AAE120_ZC,   --ע����־
                      var_akc021,   --ҽ����Ա���
                      PKG_Constant.YAB003_JBFZX,   --�籣�������
                      NULL,   --ע����
                      NULL,   --ע��ʱ��
                      NULL    --ע��ԭ��
                 FROM xasi2.ac02 a,xasi2.ac01 b
                WHERE a.aac001 = b.aac001
                  AND a.aac001 =  rec_irac01.aac001
                  AND a.aae140 =  var_aae140
                  AND a.aab001 =  prm_aab001
                  AND a.yab139 = PKG_Constant.YAB003_JBFZX;
         --���ͣ������Ϊ��� ���ж��Ƿ�Ϊ�Ʋ���λ
         IF var_aae140 = PKG_Constant.AAE140_DEYL THEN
            --����Ǵ��� ��ѯ���˴��������Ϣ
            IF var_aae119 = PKG_Constant.AAE119_PC THEN
               BEGIN
                  SELECT aae030
                    INTO dat_aae030
                    FROM xasi2.kc08
                   WHERE aac001 = rec_irac01.aac001
                     AND ykc157 = PKG_Constant.YKC157_DE
                     AND aae031 = TO_DATE('30000101','yyyymmdd');
               EXCEPTION
                  WHEN no_data_found THEN
                     dat_aae030 := NULL;
               END;
               --������ҽ�����ܽ�ֹ��Ϊ 3000-01-01 �������ܽ�ֹ��Ϊͣ��ʱ��
               IF dat_aae030 IS NOT NULL THEN
                  UPDATE xasi2.kc08
                     SET aae031 = LAST_DAY(sysdate)
                   WHERE aac001 = rec_irac01.aac001
                    AND  ykc157 = PKG_Constant.YKC157_DE
                    AND  aae030 = dat_aae030;
               END IF;
            END IF;
         END IF;
      END LOOP;

      UPDATE WSjb.IRAC01A3
         SET AAE110 = DECODE(var_aae140_01,'3','0',AAE110),
             AAE120 = DECODE(var_aae140_06,'3','0',AAE120),
             AAE210 = DECODE(var_aae140_02,'3','0',AAE210),
             AAE310 = DECODE(var_aae140_03,'3','0',AAE310),
             AAE410 = DECODE(var_aae140_04,'3','0',AAE410),
             AAE510 = DECODE(var_aae140_05,'3','0',AAE510),
             AAE311 = DECODE(var_aae140_07,'3','0',AAE311),
             AAE810 = DECODE(var_aae140_08,'3','0',AAE810)
       WHERE AAC001 = rec_irac01.AAC001
         AND AAB001 = rec_irac01.AAB001;

      --�ı�������Ա��״̬
      IF rec_irac01.aac008 = PKG_Constant.AAC008_TX THEN
         UPDATE xasi2.ac01
            SET AAC008 = PKG_Constant.AAC008_TX
          WHERE AAC001 = rec_irac01.aac001
            AND AAC008 = PKG_Constant.AAC008_ZZ;
      END IF;

   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gn_def_ERR;
         prm_ErrMsg  := '����ͣ������,����ԭ��:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END prc_AuditMonthInternetRpause;

   /*****************************************************************************
   ** �������� : prc_AddNewManage
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ������ר��Ա�������
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **                prm_aab001       IN     iraa01.aab001%TYPE,--ר��Ա���ڵ�λ����
   **                prm_aac001       IN     iraa01.aac001%TYPE,--ר��Ա�籣���
   **                prm_yab516       IN     iraa01.yab516%TYPE,--ר��Ա֤����
   **                prm_aab016       IN     iraa01.aab016%TYPE,--ר��Ա����
   **                prm_aac004       IN     ad53a4.aac004%TYPE,--ר��Ա����
   **                prm_yae041       IN     ad53a4.yae041%TYPE,--ר��Ա������
   **                prm_yae042       IN     iraa01.yae042%TYPE,--ר��Ա����
   **                prm_yae043       IN     iraa01.yae043%TYPE,--��ʼ����
   **                prm_yab003       IN     ae02.yab003%TYPE,--������
   **                prm_aae011       IN     iraa01.aae011%TYPE,--������
   **                prm_aae013       IN     ae02.aae013%TYPE,  --��ע
   **                prm_iaz014       IN     iraa01a1.iaz014%TYPE,--����ר��Ա�¼�ID
   **                prm_shmark       IN     VARCHAR2,            --���ͨ����־
   **                prm_iad005       IN     irad22.iad005%TYPE,--������
   **                prm_AppCode      OUT    VARCHAR2,
   **                prm_ErrorMsg     OUT    VARCHAR2,
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-12   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_AddNewManage (
     prm_aab001       IN     iraa01.aab001%TYPE,--ר��Ա���ڵ�λ����
     prm_aac001       IN     iraa01.aac001%TYPE,--ר��Ա�籣���
     prm_yab516       IN     iraa01.yab516%TYPE,--ר��Ա֤����
     prm_aab016       IN     iraa01.aab016%TYPE,--ר��Ա����
     prm_aac004       IN     ad53a4.aac004%TYPE,--ר��Ա����
     prm_yae041       IN     ad53a4.yae041%TYPE,--ר��Ա������
     prm_yae042       IN     iraa01.yae042%TYPE,--ר��Ա����
     prm_yae043       IN     iraa01.yae043%TYPE,--��ʼ����
     prm_yab003       IN     ae02.yab003%TYPE,--������
     prm_aae011       IN     iraa01.aae011%TYPE,--������
     prm_aae013       IN     ae02.aae013%TYPE,  --��ע
     prm_iaz014       IN     iraa01a1.iaz014%TYPE,--����ר��Ա�¼�ID
     prm_iad005       IN     irad22.iad005%TYPE,--������
     prm_shmark       IN     VARCHAR2,            --���ͨ����־
     prm_AppCode      OUT    VARCHAR2          ,
     prm_ErrorMsg     OUT    VARCHAR2          )
   IS
     n_count    number(2);
     v_yae092   varchar2(15);
     v_aaz002   varchar2(15);
     v_iaz005   varchar2(15);
     v_iaz009   varchar2(15);
     v_iaz010   varchar2(15);
     v_yae367   varchar2(15);
     v_yab390   varchar2(15);
     v_aab018   varchar2(20);
     v_aac001   varchar2(15);


   begin
       prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;
     /*��������¼��У��*/
        IF prm_aab001 IS NUll THEN
          prm_ErrorMsg:='ר��Ա���ڵ�λ��λ���벻��Ϊ��!';
          RETURN;
        END IF;
        IF prm_yab516 IS NUll THEN
          prm_ErrorMsg:='���ר��Ա��Ա����Ϊ��!';
          RETURN;
        END IF;
        IF prm_aab016 IS NUll THEN
          prm_ErrorMsg:='ר��Ա��������Ϊ��!';
          RETURN;
        END IF;
        IF prm_aab001 IS NUll THEN
          prm_ErrorMsg:='ר��Ա�����벻��Ϊ��!';
          RETURN;
        END IF;
        IF prm_yae042 IS NULL THEN
         prm_ErrorMsg := 'ר��Ա���벻��Ϊ��!';
         RETURN;
       END IF;

       IF prm_yae043 IS NULL THEN
         prm_ErrorMsg := '��ʼ���벻��Ϊ��!';
         RETURN;
       END IF;

       IF prm_iaz014 IS NULL THEN
         prm_ErrorMsg := '��ȡר��Ա�����¼�ID����!';
         RETURN;
       END IF;

       IF prm_shmark IS NULL THEN
         prm_ErrorMsg := '��˱�־����Ϊ��!';
         RETURN;
       END IF;
      --ҵ����־ID
      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
      IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
         prm_ErrorMsg := 'û�л�ȡ�����к�AAZ002!';
         RETURN;
      END IF;
      --����¼�ID
      v_iaz009 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ009');
      IF v_iaz009 IS NULL OR v_iaz009 = '' THEN
         prm_ErrorMsg := 'û�л�ȡ�����к�IAZ009!';
         RETURN;
      END IF;

      --����¼�ID
      v_iaz010 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ010');
      IF v_iaz010 IS NULL OR v_iaz010 = '' THEN
         prm_ErrorMsg := 'û�л�ȡ�����к�AAZ010!';
         RETURN;
      END IF;

      --��ϸID
      SELECT iaz005
      INTO   v_iaz005
      FROM wsjb.IRAD02
      WHERE iaz007 = prm_iaz014;
      IF v_iaz005 IS NULL OR v_iaz005 = '' THEN
        prm_ErrorMsg := 'û�л�ȡ����ϸID';
        RETURN;
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
                   AAE218,
                   AAE013
                  )
                  VALUES
                  (
                   v_aaz002,
                   PKG_Constant.AAA121_ASA,
                   prm_aae011,
                   prm_yab003,
                   prm_aae011,
                   '1',
                   sysdate,
                   sysdate,
                   sysdate,
                   prm_aae013
                  );
     --д��˱�irad21
     INSERT INTO wsjb.irad21
                (
                  iaz009,
                  aaz002,
                  iaa011,
                  aee011,
                  aae035,
                  yab003,
                  aae013
                )
                VALUES
                (
                  v_iaz009,
                  v_aaz002,
                  PKG_Constant.IAA011_ASC,
                  prm_aae011,
                  sysdate,
                  PKG_Constant.YAB003_JBFZX,
                  '����ר��Ա���'
                );
        --���±�irad02 ״̬Ϊ������
               UPDATE wsjb.irad02
               SET iaa015 = PKG_Constant.IAA015_ADO
               WHERE iaz005 = v_iaz005;

       --���ͨ��
       IF prm_shmark = '1' THEN

                  IF prm_yae041 IS NOT NULL THEN
                   SELECT COUNT(1)
                     INTO n_count
                     FROM wsjb.ad53a4  a , wsjb.iraa01  b
                    WHERE a.yae092=b.yae092
                      and a.aae100 = '1'
                      and a.yae041 = prm_yae041;         --ר��Ա������
                   IF n_count > 0 THEN
                      prm_ErrorMsg := '�Ѿ�����������Ϊ['|| prm_yae041 ||']��ר��Ա!';
                      RETURN;
                   END IF;
                END IF;
              IF prm_yab516 IS NOT NULL THEN
                   SELECT COUNT(1)
                     INTO n_count
                     FROM  wsjb.iraa01  b
                    WHERE b.yab516=prm_yab516
                      and b.aae100 = '1'
                      and b.aab001 = prm_aab001;         --ר��Ա�ظ�У��
                   IF n_count > 0 THEN
                      prm_ErrorMsg := '����Ա�Ѿ���ר��Ա!';
                      RETURN;
                   END IF;
                END IF;

                 /*���������кŷ������*/

                v_yae092 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'FRAMEWORK');
                IF v_yae092 IS NULL OR v_yae092 = '' THEN
                   prm_ErrorMsg := 'û�л�ȡ�����к�FRAMEWORK!';
                   RETURN;
                END IF;

                v_yae367 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'DEFAULT');
                IF v_yae367 IS NULL OR v_yae367 = '' THEN
                   prm_ErrorMsg := 'û�л�ȡ�����к�DEFAULT!';
                   RETURN;
                END IF;
               /*д��ר��Ա��Ϣ����־�������������Ϣ���*/
                     /*
                    �����½�˺ſ���
                */
                INSERT INTO wsjb.ad53a4  (
                     yae092,  -- ������Ա���
                     yab109,  -- ���ű��
                     aac003,  -- ����
                     aac004,  -- ����
                     yab003,  -- �������
                     yae041,  -- ��½��
                     yae042,  -- ��½����
                     yae361,  -- ������־
                     yae362,  -- ����������
                     yae363,  -- �����ʱ��
                     yae114,  -- �����
                     aae100,  -- ��Ч��־
                     aae011,  -- ������
                     aae036   -- ����ʱ��
                     )
                VALUES
                    (
                     v_yae092  ,  -- ������Ա���
                     '0101'    ,  -- ���ű��[��λ����]
                     prm_aab016,  -- ����
                     prm_aac004,  -- �Ա�
                     prm_yab003,  -- �������
                     prm_yae041,  -- ר��Ա������[��¼�˺�]
                     prm_yae042,  -- ��½����
                     '0'       ,  -- ������־
                     0         ,  -- ����������
                     SYSDATE,  -- �����ʱ��
                     0         ,  -- �����
                     '1'       ,  -- ��Ч��־
                     prm_aae011,  -- ������
                     SYSDATE      -- ����ʱ��
                );


                /*
                   ���Ķ�����������Ŀ�� ������Ķ˾�����Ա��������
                */
                INSERT INTO xasi2.ad53a4 (
                     yae092,  -- ������Ա���
                     yab109,  -- ���ű��
                     aac003,  -- ����
                     aac004,  -- �Ա�
                     yab003,  -- �������
                     yae041,  -- ��½��
                     yae042,  -- ��½����
                     yae361,  -- ������־
                     yae362,  -- ����������
                     yae363,  -- �����ʱ��
                     yae114,  -- �����
                     aae100,  -- ��Ч��־
                     aae011,  -- ������
                     aae036   -- ����ʱ��
                     )
                VALUES
                    (
                     v_yae092  ,  -- ������Ա���
                     '0101'    ,  -- ���ű��[��λ����]
                     prm_aab016,  -- ����
                     prm_aac004,  -- �Ա�
                     prm_yab003,  -- �������
                     prm_yae041,  -- ��½��=��λ���=��λ������[Ĭ������ר��Ա���]
                     prm_yae042,  -- ��½����
                     '0'       ,  -- ������־
                     0         ,  -- ����������
                     SYSDATE,  -- �����ʱ��
                     0         ,  -- �����
                     '1'       ,  -- ��Ч��־
                     prm_aae011,  -- ������
                     SYSDATE      -- ����ʱ��
                );

                   /*д�뵥λר��Ա��Ϣ*/
                SELECT YAB390,AAB018 INTO v_yab390,v_aab018 FROM IRAA01A1 WHERE IAZ014 = prm_iaz014;
                INSERT INTO wsjb.iraa01
                           (
                            AAC001,
                            AAB001,
                            YAB516,
                            AAB016,
                            AAB018,
                            YAB390,
                            YAE092,
                            AAZ002,
                            IAB001,
                            AAE011,
                            AAE035,
                            AAE036,
                            YAE043,
                            YAE042,
                            AAE100
                           )
                           VALUES
                           (
                            prm_aac001,
                            prm_aab001,
                            prm_yab516,
                            prm_aab016,
                            v_aab018,
                            v_yab390,
                            v_yae092  ,
                            v_aaz002  ,
                            prm_aab001,
                            prm_aae011,
                            sysdate,
                            sysdate,
                            prm_yae043,
                            prm_yae042,
                            '1'
                           );

                /*д�뵥λר��Ա��Ϣab01a1*/
                v_aac001 := xasi2.PKG_COMM.FUN_GETSEQUENCE(NULL,'AAC001');
                IF v_aac001 IS NULL OR v_aac001 = '' THEN
                   prm_ErrorMsg := 'û�л�ȡ�����к�v_aac001!';
                   RETURN;
                END IF;
                INSERT INTO xasi2.ab01a3
                           (
                            AAC001,
                            AAB001,
                            YAB515,
                            YAB516,
                            AAB016,
                            AAB018,
                            YAB390
                           )
                           VALUES
                           (
                            v_aac001,
                            prm_aab001,
                            '1',
                            prm_yab516,
                            prm_aab016,
                            v_aab018,
                            v_yab390
                           );

                /*
                    Ϊ������Ա��ȨΪ��λ����ĸ�λ
                */
                INSERT INTO  wsjb.AD53A6
                            (
                             yae093,  -- ��ɫ���
                             yab109,  -- ���ű��
                             yae092,  -- ������Ա���
                             aae011,  -- ������
                             aae036   -- ����ʱ��
                            )
                     VALUES
                            (
                             '1000000021',  -- ��ɫ���[��λ����]
                             '0101'    ,  -- ���ű��
                             v_yae092  ,  -- ������Ա���
                             prm_aae011,  -- ������
                             SYSDATE      -- ����ʱ��
                );
                      /*
                   ��¼�û���λ�䶯��־
                */
                INSERT INTO wsjb.ad53a8  (
                       yae367,  -- �䶯��ˮ��
                       yae093,  -- ��ɫ���
                       yab109,  -- ���ű��
                       yae092,  -- ������Ա���
                       aae011,  -- ������
                       aae036,  -- ����ʱ��
                       yae369,  -- �޸���
                       yae370,  -- �޸�ʱ��
                       yae372)  -- Ȩ�ޱ䶯����
                VALUES (
                       v_yae367 ,  -- �䶯��ˮ��
                       '1000000021',  -- ��ɫ���
                       '0101',       -- ���ű��
                       v_yae092,    -- ������Ա���
                       prm_aae011,  -- ������
                       SYSDATE   ,  -- ����ʱ��
                       prm_aae011,  -- �޸���
                       SYSDATE   ,  -- �޸�ʱ��
                       '07'        -- Ȩ�ޱ䶯����
                );
                --����iraa01a1��Ϣ
                UPDATE wsjb.iraa01a1
                SET yae092 = v_yae092,
                    yae043 = prm_yae043,
                    yae042 = prm_yae042,
                    iaa002 = '2'
               WHERE iaz014 = prm_iaz014;

             --д��˱�irad22
              INSERT INTO wsjb.irad22
                        (
                          iaz010,
                          iaz011,
                          iaz009,
                          iaz005,
                          iaa004,
                          iaa014,
                          iaa017,
                          aae011,
                          aae035,
                          yab003,
                          iaa018
                        )
                        VALUES
                        (
                          v_iaz010,
                          v_iaz010,
                          v_iaz009,
                          v_iaz005,
                          PKG_Constant.IAA004_LV1,
                          '1',
                          '1',
                          prm_aae011,
                          sysdate,
                          PKG_Constant.YAB003_JBFZX,
                          PKG_Constant.IAA018_PAS
                        );
        ELSE
        --���±�iraa01a1 ״̬Ϊδͨ��
               UPDATE wsjb.iraa01a1
               SET iaa002 = PKG_Constant.IAA002_NPS
               WHERE iaz014 = prm_iaz014;

              --д��˱�irad22
              INSERT INTO wsjb.irad22
                        (
                          iaz010,
                          iaz011,
                          iaz009,
                          iaz005,
                          iaa004,
                          iaa014,
                          iaa017,
                          aae011,
                          aae035,
                          yab003,
                          iaa018,
                          iad005,
                          aae013
                        )
                        VALUES
                        (
                          v_iaz010,
                          v_iaz010,
                          v_iaz009,
                          v_iaz005,
                          PKG_Constant.IAA004_LV1,
                          '1',
                          '1',
                          prm_aae011,
                          sysdate,
                          PKG_Constant.YAB003_JBFZX,
                          PKG_Constant.IAA018_NPS,
                          prm_iad005,
                          null
                        );
        END IF;
   EXCEPTION
   WHEN OTHERS THEN
   /*�رմ򿪵��α�*/
   prm_AppCode  :=  gn_def_ERR;
   prm_ErrorMsg := '���ݿ����:'|| SQLERRM||dbms_utility.format_error_backtrace  ;
   RETURN;
   END prc_AddNewManage;


   /*****************************************************************************
   ** �������� : Prc_Unitinfomaintainaudit
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����λ��Ϣά�����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     wsjb.irad31 .aab001%TYPE,--ר��Ա���ڵ�λ����
   **           prm_aae013       IN     irad31.aae013%TYPE,--������
   **           prm_iaa018       IN     irad22.iaa018%TYPE,--��˽��
   **           prm_aae011       IN     irad31.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          )
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-12   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_UnitInfoMaintainAudit (
     prm_aab001       IN     irad31.aab001%TYPE,--ר��Ա���ڵ�λ����
     prm_aae013       IN     irad31.aae013%TYPE,--������
     prm_iaa018       IN     irad22.iaa018%TYPE,--��˽��
     prm_aae011       IN     irad31.aae011%TYPE,--������
     prm_AppCode      OUT    VARCHAR2          ,
     prm_ErrorMsg     OUT    VARCHAR2          )

   IS
      n_count    number(2);
      v_iab001   varchar2(15);
      v_aaz002   varchar2(15);
      v_iaz009   varchar2(15);
      v_iaz010   varchar2(15);
      v_iaz005   varchar2(15);
      v_iaz004   varchar2(15);
      v_iaz003   varchar2(15);
      v_iaa004   number(1);
      v_iaa014   number(1);
      v_iaa017   number(1);
      v_iad009   irad32.iad009%TYPE;

   BEGIN
      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;


      /*��Ҫ������У��*/
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λ�����벻��Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa018 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��˽������Ϊ��!';
         RETURN;
      END IF;

      IF prm_aae011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�����˲���Ϊ��!';
         RETURN;
      END IF;


      --�Ƿ�����걨��λ��Ϣ
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAB01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and b.aaa121 = PKG_Constant.AAA121_EIM and a.aab001 = prm_aab001 and (a.iaa002 = PKG_Constant.IAA002_AIR OR a.iaa002 = PKG_Constant.IAA002_NPS);
      IF n_count = 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '��λ���Ϊ['|| prm_aab001 ||']�ĵ�λ�걨��Ϣ������!';
            RETURN;
      ELSIF n_count > 1 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '��λ���Ϊ['|| prm_aab001 ||']�ĵ�λ�걨��Ϣ��������ϵά����Ա!';
            RETURN;
      END IF;

      --�Ƿ���ڵ�λ��Ϣ
      SELECT COUNT(1)
           into n_count
           FROM xasi2.AB01 a
          WHERE a.aab001 = prm_aab001;
      IF n_count = 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '��λ���Ϊ['|| prm_aab001 ||']�ĵ�λ��Ϣ������!';
            RETURN;
      END IF;

      --�Ƿ���ڵ�λ������Ϣ
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAB01  a,wsjb.AE02  b
          WHERE a.aab001 = prm_aab001
          AND a.aaz002 = b.aaz002
          AND b.aaa121 = PKG_Constant.AAA121_NER;
      IF n_count = 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '��λ���Ϊ['|| prm_aab001 ||']�ĵ�λ��Ϣ������!';
            RETURN;
      END IF;


      /*��ȡ������Ϣ*/



      --��־��¼
      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');

      INSERT INTO wsjb.AE02
             (
              aaz002,
              aaa121,
              aae011,
              yab003,
              aae014,
              aae016,
              aae216,
              aae217,
              aae218,
              aae013
             ) VALUES (
              v_aaz002,
              PKG_Constant.AAA121_EIA,
              prm_aae011,
              PKG_Constant.YAB003_JBFZX,
              prm_aae011,
              '1',
              sysdate,
              sysdate,
              sysdate,
              prm_aae013
             );



      BEGIN

      --����¼�
      v_iaz009 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ009');

      INSERT INTO wsjb.IRAD21
                  (
                  IAZ009,
                  AAZ002,
                  IAA011,
                  AEE011,
                  AAE035,
                  YAB003,
                  AAE013
                  )
                  VALUES
                  (
                  v_iaz009,
                  v_aaz002,
                  PKG_Constant.AAA121_EIA,
                  prm_aae011,
                  sysdate,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae013
      );


      --�����ϸ����
      v_iaz010 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ010');
         IF v_iaz010 IS NULL OR v_iaz010 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�IAZ010!';
            RETURN;
         END IF;

      BEGIN
      SELECT a.iab001,b.iaz005,b.iaa004,b.iaa014,d.iaz004
               INTO v_iab001,v_iaz005,v_iaa004,v_iaa014,v_iaz004
               FROM wsjb.irab01  a,wsjb.irad02  b,wsjb.ae02  c,wsjb.irad01  d
               WHERE a.iab001 = b.iaz007
               and a.aaz002 = c.aaz002
               and c.aaz002 = d.aaz002
               and a.aab001 = b.iaz008
               and a.aab001 = d.aab001
               and d.iaz004 = b.iaz004
               and d.iaa011 = PKG_Constant.AAA121_EIM
               and c.aaa121 = PKG_Constant.AAA121_EIM
               and b.iaa020 = PKG_Constant.IAA020_DW
               and a.iaa002 = PKG_Constant.IAA002_AIR
               and b.iaa016 = PKG_Constant.IAA016_DIR_NO
               and b.iaa015 = PKG_Constant.IAA015_WAD
               and a.aab001 = prm_aab001;

       v_iaa014 := v_iaa014 + 1;

       IF v_iaa004 = v_iaa014 THEN
        v_iaa017 := v_iaa014;
       ELSE
        v_iaa017 := v_iaa014 + 1;
       END IF;

        EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λά����Ϣ���ִ�������ϵά����Ա������'|| SQLERRM||dbms_utility.format_error_backtrace  ;
         RETURN;
       END;

      --�����ϸд��

         INSERT INTO wsjb.IRAD22
                    (
                     IAZ010,
                     IAZ011,
                     IAZ009,
                     IAZ005,
                     IAA004,
                     IAA014,
                     IAA017,
                     AAE011,
                     AAE035,
                     YAB003,
                     IAA018,
                     IAD005,    --������
                     AAE013
                     )
                    VALUES
                    (
                     v_iaz010,
                     v_iaz010,
                     v_iaz009,
                     v_iaz005,
                     v_iaa004,
                     v_iaa014,
                     v_iaa017,
                     prm_aae011,
                     sysdate,
                     PKG_Constant.YAB003_JBFZX,
                     prm_iaa018,
                     prm_aae013,  --������
                     null
                     );


      END;

      --����IRAD01
      UPDATE wsjb.IRAD01  SET
             aae013 = prm_aae013
      WHERE
             iaz004 = v_iaz004;
      --����IRAD02������
      UPDATE wsjb.IRAD02  SET
            iaa015 = PKG_Constant.IAA015_ADO,
            aae013 = prm_aae013
      WHERE
            iaz005 = v_iaz005;


      --����IRAD41������
      BEGIN

      SELECT a.iaz003 INTO v_iaz003 FROM wsjb.IRAD41  a,wsjb.IRAD01  b,wsjb.IRAD02  c
      WHERE a.iaz004 = b.iaz004 and b.iaa011 = PKG_Constant.AAA121_EIM
      and b.aab001 = prm_aab001 and a.iaa012 = PKG_Constant.IAA012_WDW
      and b.iaz004 = c.iaz004 and c.iaa015 = PKG_Constant.IAA015_WAD
      and c.iaa016 = PKG_Constant.IAA016_DIR_NO;

      UPDATE wsjb.IRAD41  SET
            iaa012 = PKG_Constant.IAA012_ODW,
            aae036 = sysdate,
            aae013 = prm_aae013
      WHERE
            iaz003 = v_iaz003;

      EXCEPTION
       WHEN NO_DATA_FOUND THEN
       null;
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := 'ԤԼ��Ϣ���ִ��󣡣���'|| SQLERRM||dbms_utility.format_error_backtrace  ;
         RETURN;
      END;

      --����AB01������
      IF prm_iaa018 = '1' THEN

        UPDATE wsjb.IRAB01  SET
            iaa002 = PKG_Constant.IAA002_APS
        WHERE
            iab001 = v_iab001;

        UPDATE xasi2.AB01 SET
            (aab003,
             aab022,
             aab004,
             aab005,
             aae006,
             aae007,
             yab519,
           --  aae014,  ���Ͳ�һ��  number
             aab019,
             aab020,
             ylb001,
             aab021,
             yab275,
             aab023,
             yae225,
             yab518,
             aae013,
             yab391,
             yab388,
             aab013,
             yab389,
             aab015,
             yab515,
             yab516,
             aab016,
             yab237,
             yab390,
             yab517,
             aab018,
             aaf020,
             aab030,
             aae011,
             yab136)
            =
            (SELECT
             a.aab003,
             a.aab022,
             a.aab004,
             a.aab005,
             a.aae006,
             a.aae007,
             a.yab519,
            -- a.aae014,
             a.aab019,
             a.aab020,
             a.ylb001,
             a.aab021,
             a.yab275,
             a.aab023,
             a.yae225,
             a.yab518,
             a.aae013,
             a.yab391,
             a.yab388,
             a.aab013,
             a.yab389,
             a.aab015,
             a.yab515,
             a.yab516,
             a.aab016,
             a.yab237,
             a.yab390,
             a.yab517,
             a.aab018,
             a.aaf020,
             a.aab030,
             a.aae011,
             a.yab136
             FROM wsjb.irab01  a where
             a.iab001 = v_iab001
             )
             where aab001 = prm_aab001;

        --���¹�����ҵ�ȼ�
        UPDATE xasi2.AB02  SET
            (aaa040)
             =
            (SELECT
             '040'||nvl(ylb001,'1')
             FROM wsjb.irab01  a where
             a.iab001 = v_iab001)
             where aab001 = prm_aab001
             and aae140 = '04'
             and aab051 = '1';


        --����IRAB01
        UPDATE wsjb.IRAB01  SET
            (aab003,
             aab022,
             aab004,
             aab005,
             aae006,
             aae007,
             yab519,
             aae014,
             aab019,
             aab020,
             ylb001,
             aab021,
             yab275,
             aab023,
             yae225,
             yab518,
             aae013,
             yab391,
             yab388,
             aab013,
             yab389,
             aab015,
             aaf020,
             aab030,
             aae011,
             yab136,
           --  yab028,
             yab009,
             yab006,
             yab534,
             aab024,
             aab025,
             aab026)
            =
            (SELECT
             a.aab003,
             a.aab022,
             a.aab004,
             a.aab005,
             a.aae006,
             a.aae007,
             a.yab519,
             a.aae014,
             a.aab019,
             a.aab020,
             a.ylb001,
             a.aab021,
             a.yab275,
             a.aab023,
             a.yae225,
             a.yab518,
             a.aae013,
             a.yab391,
             a.yab388,
             a.aab013,
             a.yab389,
             a.aab015,
             a.aaf020,
             a.aab030,
             a.aae011,
             a.yab136,
            -- a.yab028,
             a.yab009,
             a.yab006,
             a.yab534,
             a.aab024,
             a.aab025,
             a.aab026
             FROM wsjb.irab01  a where
             a.iab001 = v_iab001
             )
             where aab001 = (
             SELECT aab001
             FROM wsjb.IRAB01  a,wsjb.ae02  b WHERE
             a.aaz002 = b.aaz002
             AND b.aaa121 = PKG_Constant.AAA121_NER
             AND a.aab001 = prm_aab001
             ) AND iab001=aab001;

    --����AB01A6������
    BEGIN

        SELECT iad009 into v_iad009 from wsjb.irad32
        where
        iad006 = 'YAB028'
        and iaz012 = (SELECT iaz012 from irad31
        where
        iaz007 = v_iab001
        and iaa011 = PKG_Constant.IAA011_EIM
        and iaa019 = PKG_Constant.IAA019_IR) and aae100 = '1';

        UPDATE xasi2.AB01A7 SET
               yab028 = (SELECT yab028 from wsjb.IRAB01  where iab001 = v_iab001)
               where aab001 = prm_aab001;

      EXCEPTION
      WHEN NO_DATA_FOUND THEN
      null;
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���µ�˰������ʱ��������'|| SQLERRM||dbms_utility.format_error_backtrace  ;
         RETURN;
    END;

    --����IRAD31������
        UPDATE wsjb.IRAD31  SET
            iaa019 = PKG_Constant.IAA019_AD
        WHERE
            iaz007 = v_iab001
            and iaa011 = PKG_Constant.IAA011_EIM
            and iaa019 = PKG_Constant.IAA019_IR;

      ELSIF prm_iaa018 = '0' THEN
        UPDATE wsjb.IRAB01  SET
            iaa002 = PKG_Constant.IAA002_ALR
        WHERE
            iab001 = v_iab001;

        UPDATE wsjb.IRAD02  SET
            iaa015 = PKG_Constant.IAA015_DAD
        WHERE
            iaz005 = v_iaz005;

      ELSE
        UPDATE wsjb.IRAB01  SET
            iaa002 = PKG_Constant.IAA002_NPS
        WHERE
            iab001 = v_iab001;

      END IF;



      EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;

   END prc_UnitInfoMaintainAudit;


   /*****************************************************************************
   ** �������� : prc_PersonInfoMaintain
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����Ա��Ҫ��Ϣά��
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **                 prm_aac001       IN     irac01.aac001%TYPE,--���˱��
   **                 prm_aab001       IN     irac01.aab001%TYPE,--��λ���
   **                 prm_aac002       IN     irac01.aac002%TYPE,--֤������
   **                 prm_aac003       IN     irac01.aac003%TYPE,--����
   **                 prm_aac004       IN     irac01.aac004%TYPE,--�Ա�
   **                 prm_aac006       IN     irac01.aac006%TYPE,--��������
   **                 prm_aac009       IN     irac01.aac009%TYPE,--��������
   **                 prm_aae011       IN     irac01.aae011%TYPE,--������
   **                 prm_aac040       IN     irac01.aac040%TYPE,--�걨����
   **           prm_AppCode      OUT    VARCHAR2    ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-4   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
     PROCEDURE prc_PersonInfoMaintain (
      prm_aac001       IN     irac01.aac001%TYPE,--���˱��
      prm_aab001       IN     irac01.aab001%TYPE,--��λ���
      prm_aac002       IN     irac01.aac002%TYPE,--֤������
      prm_aac003       IN     irac01.aac003%TYPE,--����
      prm_aac004       IN     irac01.aac004%TYPE,--�Ա�
      prm_aac006       IN     irac01.aac006%TYPE,--��������
      prm_aac009       IN     irac01.aac009%TYPE,--��������
      prm_aac013       IN     irac01.aac013%TYPE,--�ù���ʽ
      prm_yac168       IN     irac01.yac168%TYPE,--ũ�񹤱�־
      prm_aac007        IN    irac01.aac007%TYPE,--�ι�����
      prm_aac012        IN    irac01.aac012%TYPE,--�������
      prm_aae011       IN     irac01.aae011%TYPE,--������
      prm_aac040       IN     irac01.aac040%TYPE,--�걨����
      prm_iac001       OUT    irac01.iac001%TYPE,--�걨���
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )

    IS
      n_count    number(5);
      v_aaz002   varchar2(15);--��־ID
      v_iac001   varchar2(15);--�걨��Ա�걨ID
      v_iaz012   varchar2(15);--��ʷ�޸��¼�ID
      v_iaz013   varchar2(15);--��ʷ�޸���ϸID
      v_iaz004   varchar2(15);--�걨�����¼�ID
      v_iaz005   varchar2(15);
      col_type   varchar2(106);
      v_varchar  varchar2(200);
      v_number   number(20);
      v_date     date;
      v_comments varchar2(200);
      t_cols     tab_change;
      v_sql      varchar2(200);
      v_name     varchar2(50);
      v_value     varchar2(200);
      v_iaa004   number(1);
      v_iaz006   varchar2(15);
      v_idnumber varchar2(50);
      v_username varchar2(50);
      v_familypaper varchar2(50);
      d_aac030  date;

    BEGIN

        prm_AppCode  := PKG_Constant.GN_DEF_OK;
        prm_ErrorMsg := '';

      /*��Ҫ������У��*/


      IF prm_aac001 IS NULL THEN
         prm_ErrorMsg := '���˱�Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_aac009 IS NULL THEN
         prm_ErrorMsg := '�������ʲ���Ϊ��!';
         RETURN;
      END IF;

      --�Ƿ����AC01��Ա��Ϣ
      SELECT COUNT(1)
           into n_count
           FROM xasi2.AC01
          WHERE aac001 = prm_aac001;
      IF n_count = 0 THEN
            prm_ErrorMsg := '���˱��Ϊ['|| prm_aac001 ||']����Ա��Ϣ������!';
            RETURN;
      END IF;

      --У���Ƿ������Ա��Ϣ
      SELECT COUNT(1)
           into n_count
           FROM xasi2.AC01 a,xasi2.AC02 b
          WHERE a.aac001 = prm_aac001 and a.aac001=b.aac001;
      IF n_count = 0 THEN
            prm_ErrorMsg := '��������Ա���Ϊ['|| prm_aac001 ||']����Ա��Ϣ��';
            RETURN;
      END IF;

      --�Ƿ�����Ѿ��걨ά����Ϣ
      SELECT COUNT(1)
           into n_count
           FROM wsjb.irac01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and a.aac001 = prm_aac001 and b.aaa121 = PKG_Constant.AAA121_PIM and a.iaa002 = PKG_Constant.IAA002_AIR;
      IF n_count > 0 THEN
            prm_ErrorMsg := '�Ѿ����ڸ��˱��Ϊ['|| prm_aac001 ||']��ά���걨��Ϣ!';
            RETURN;
      END IF;

      --�Ƿ������ͬ����˼���
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAA02
          WHERE iaa011 = PKG_Constant.IAA011_PIM
          AND iaa005 = PKG_Constant.IAA005_YES;
      IF n_count = 0 THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'û��ϵͳ��˼�����Ϣ!����ϵά����Ա';
            RETURN;
      ELSIF n_count > 1 THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'ϵͳ��˼�����Ϣ����!����ϵά����Ա';
            RETURN;
      END IF;



      --�������Ž���¼��
      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC001';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aac001;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC002';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aac002;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC003';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aac003;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC004';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aac004;


      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC006';
      t_cols(t_cols.COUNT).COL_VALUE := to_char(prm_aac006,'yyyy-mm-dd');

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC009';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aac009;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC013';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aac013;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAC168';
      t_cols(t_cols.COUNT).COL_VALUE := prm_yac168;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC007';
      t_cols(t_cols.COUNT).COL_VALUE := to_char(prm_aac007,'yyyy-mm-dd');

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC012';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aac012;

      --��ȡ������Ϣ
      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');--��ȡ��־ID

      SELECT iaa004
           into v_iaa004
           FROM wsjb.IRAA02
          WHERE iaa011 = PKG_Constant.IAA011_PIM
          AND iaa005 = PKG_Constant.IAA005_YES;

       --д����־��¼
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
                  AAE218,
                  AAE013
                 )
                 VALUES
                 (
                  v_aaz002,
                  PKG_Constant.AAA121_PIM,
                  prm_aae011,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae011,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate,
                  '��Ա��Ҫ��Ϣά��'
                 );


      --������߸���IRAC01

      SELECT count(1)
           into
            n_count
           FROM wsjb.irac01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and b.aaa121 = PKG_Constant.AAA121_PIM and a.aac001 = prm_aac001 and a.iaa002 = PKG_Constant.IAA002_NPS;

          IF n_count = 0 THEN

           v_iac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAC001');

           INSERT INTO wsjb.irac01  (
           iac001,
           iaa001,
           iaa002,
           aac001,
           aab001,
           yae181,
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
           yac170,
           yac502,
           yae407,
           yae496,
           aae004,
           aae005,
           aae006,
           aae007,
           yae222,
           aac040,
           yab013,
           yab139,
           aaz002,
           iaa100
           )
    SELECT
           v_iac001,
           PKG_Constant.IAA001_MDF,
           PKG_Constant.IAA002_AIR,
           aac001,
           prm_aab001,
           yae181,
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
           yac170,
           yac502,
           yae407,
           yae496,
           aae004,
           aae005,
           aae006,
           aae007,
           yae222,
           prm_aac040,
           prm_aab001,
           PKG_Constant.YAB003_JBFZX,
           v_aaz002,
           to_number(to_char(sysdate,'yyyymm'))
      FROM xasi2.AC01 WHERE aac001 = prm_aac001;

             --������Ա�걨��Ϣ��
            UPDATE wsjb.IRAC01  SET
                   aac001 = prm_aac001,
                   aac002 = prm_aac002,
                   aac003 = prm_aac003,
                   aac004 = prm_aac004,
                   aac006 = prm_aac006,
                   aac009 = prm_aac009,
                   aac013 = prm_aac013,
                   yac168 = prm_yac168,
                   aac007 = prm_aac007,
                   aac012 = prm_aac012,
                   aae036 = sysdate,
                   aaz002 = v_aaz002,
                   iaa100 = to_number(to_char(sysdate,'yyyymm'))
            WHERE iac001 = v_iac001;

       --д����ʷ�޸��¼�
      v_iaz012 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ012');
      INSERT INTO wsjb.IRAD31
                 (
                  iaz012,
                  aaz002,
                  iaz007,
                  aae011,
                  aae035,
                  aab001,
                  yab003,
                  iaa019,
                  iaa011,
                  aae013
                 )
                 VALUES
                 (
                  v_iaz012,
                  v_aaz002,
                  v_iac001,
                  prm_aae011,
                  sysdate,
                  prm_aab001,
                  PKG_Constant.YAB003_JBFZX,
                  PKG_Constant.IAA019_IR,
                  PKG_Constant.IAA011_PIM,
                  '��'
                 );


      --�걨�¼���
      v_iaz004 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ004');
      INSERT INTO wsjb.IRAD01
                 (
                 iaz004,
                 aaz002,
                 iaa011,
                 aae011,
                 aae035,
                 aab001,
                 yab003,
                 aae013,
                 iaa100
                 )
                 VALUES
                 (
                  v_iaz004,
                  v_aaz002,
                  PKG_Constant.IAA011_PIM,
                  prm_aae011,
                  sysdate,
                  prm_aab001,
                  PKG_Constant.YAB003_JBFZX,
                  '��Ա��Ҫ��Ϣά��',
                  to_number(to_char(sysdate,'yyyymm'))
                 );
       --�걨��ϸ��
       v_iaz005 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');
       INSERT INTO wsjb.IRAD02
                (
                 iaz005,
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
                ) VALUES (
                 v_iaz005,
                 v_iaz005,
                 v_iaz004,
                 v_iac001,
                 prm_aac001,
                 prm_aac003,
                 prm_aae011,
                 sysdate,
                 PKG_Constant.YAB003_JBFZX,
                 v_iaa004,
                 '0',
                 PKG_Constant.IAA015_WAD,
                 PKG_Constant.IAA016_DIR_NO,
                 null,
                 PKG_Constant.IAA020_GR
                );
         --�����걨�������
         INSERT INTO wsjb.IRAD03
                     (
                      iaz003 ,
                      iaz004 ,
                      iaa011 ,
                      iaa013 ,
                      aae035 ,
                      yae092 ,
                      yab003 ,
                      aae013 ,
                      aae120
                     )
                     VALUES
                     (
                      PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ003'),
                      v_iaz004,
                      PKG_Constant.IAA011_PIM,
                      PKG_COMMON.fun_cbbh('GRBG',PKG_Constant.YAB003_JBFZX),
                      sysdate,
                      prm_aae011,
                      PKG_Constant.YAB003_JBFZX,
                      '',
                      '0'
                     );

      ELSIF n_count != 0 THEN

      BEGIN

       SELECT a.iaz012,b.iac001
           into
            v_iaz012,v_iac001
           FROM wsjb.IRAD31  a,wsjb.IRAC01  b,wsjb.AE02  c
          WHERE a.iaz007 = b.iac001 and b.aaz002 = c.aaz002 and c.aaa121 = PKG_Constant.AAA121_PIM and b.iaa002 = PKG_Constant.IAA002_NPS and b.aac001=prm_aac001;

           EXCEPTION
           -- WHEN NO_DATA_FOUND THEN
          -- WHEN TOO_MANY_ROWS THEN
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
           /*�رմ򿪵��α�*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '��Ա�޸���Ϣ���д��ڴ������ݣ�'|| SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;
       END;


       --������Ա�걨��Ϣ��
            UPDATE wsjb.IRAC01  SET
                   aac001 = prm_aac001,
                   iaa001 = PKG_Constant.IAA001_MDF,
                   iaa002 = PKG_Constant.IAA002_AIR,
                   aac002 = prm_aac002,
                   aac003 = prm_aac003,
                   aac004 = prm_aac004,
                   aac006 = prm_aac006,
                   aac009 = prm_aac009,
                   aac013 = prm_aac013,
                   yac168 = prm_yac168,
                   aac007 = prm_aac007,
                   aac012 = prm_aac012,
                   aae011 = prm_aae011,
                   aae036 = sysdate,
                   aaz002 = v_aaz002,
                   iaa100 = to_number(to_char(sysdate,'yyyymm'))
            WHERE iac001 = v_iac001;

            --����r��Ա�޸���Ϣ��
            UPDATE wsjb.IRAD31  SET
                   aaz002 = v_aaz002,
                   aae011 = prm_aae011,
                   aae035 = sysdate
                   --iaa019 = PKG_Constant.IAA019_IR
            WHERE iaz012 = v_iaz012;

            --����IRAD32������
            UPDATE wsjb.IRAD32  a SET
                a.aae100 = '0'
            WHERE a.iaz012 = v_iaz012 and a.aae100 = '1';

                        --�걨��ϸ��
            v_iaz005 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');

            --��ѯ�ϴ�ID
            BEGIN
              SELECT iaz005,iaz004
                    INTO v_iaz006,v_iaz004
                    FROM wsjb.irad02  where iaz005 = (
                   SELECT max(b.iaz005)
                   FROM wsjb.irad01  a,wsjb.irad02  b
                   where a.iaz004 = b.iaz004
                   and a.iaa011 = PKG_Constant.AAA121_PIM
                   and b.iaz008 = prm_aac001
                   and b.iaa020 = PKG_Constant.IAA020_GR
                   and b.iaa015 = PKG_Constant.IAA015_ADO);
            EXCEPTION
            -- WHEN NO_DATA_FOUND THEN
            -- WHEN TOO_MANY_ROWS THEN
            -- WHEN DUP_VAL_ON_INDEX THEN
            WHEN OTHERS THEN
            /*�رմ򿪵��α�*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '��Ա�޸���Ϣ���д��ڴ������ݣ�'|| SQLERRM||dbms_utility.format_error_backtrace ;

            RETURN;
            END;

            --������Ա�걨��Ϣ��
            UPDATE wsjb.IRAD01  SET
                   aaz002 = v_aaz002,
                   aae011 = prm_aae011,
                   aae035 = sysdate,
                  -- iaa019 = PKG_Constant.IAA019_IR,
                   iaa100 = to_number(to_char(sysdate,'yyyymm'))
            WHERE iaz004 = v_iaz004;

            --�����걨��ϸ
            INSERT INTO wsjb.IRAD02
                (
                 iaz005,
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
                ) VALUES (
                 v_iaz005,
                 v_iaz006,
                 v_iaz004,
                 v_iac001,
                 prm_aac001,
                 prm_aac003,
                 prm_aae011,
                 sysdate,
                 PKG_Constant.YAB003_JBFZX,
                 v_iaa004,
                 '0',
                 PKG_Constant.IAA015_WAD,
                 PKG_Constant.IAA016_DIR_NO,
                 null,
                 PKG_Constant.IAA020_GR
                );

     END IF;
     --��ȡ�걨���
     prm_iac001 := v_iac001;

           --��ʷ�޸���ϸ

    FOR i in 1 .. t_cols.count LOOP

        v_name := t_cols(i).COL_NAME;
        v_value := t_cols(i).COL_VALUE;

        BEGIN

         SELECT COMMENTS INTO v_comments FROM USER_COL_COMMENTS where TABLE_NAME = 'IRAC01' and COLUMN_NAME = v_name;

         SELECT DATA_TYPE INTO col_type FROM USER_TAB_COLUMNS where TABLE_NAME = 'IRAC01' and COLUMN_NAME = v_name;

        EXCEPTION
           -- WHEN NO_DATA_FOUND THEN
          -- WHEN TOO_MANY_ROWS THEN
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
           /*�رմ򿪵��α�*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'AC01����û�� '|| v_name ||'�ֶ�'|| SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;

        END;


        IF col_type IN ('CHAR', 'VARCHAR', 'VARCHAR2') THEN
           v_sql := 'SELECT '||v_name||' FROM AC01 where AAC001 = '''||prm_aac001||'''';
        ELSIF col_type IN ('NUMBER', 'INTEGER', 'FLOAT') THEN
           v_sql := 'SELECT to_char(nvl('||v_name||','''')) FROM AC01 where AAC001 = '''||prm_aac001||'''';
        ELSIF col_type IN ('DATE') THEN
           v_sql := 'SELECT decode(null,null,to_char(' || v_name ||
                                          ',''yyyy-mm-dd''))' || ' FROM AC01 where AAC001 = '''||prm_aac001||'''';
        ELSE
          ROLLBACK;
           prm_AppCode  := Pkg_Constant.GN_DEF_ERR;
           prm_ErrorMsg := '��' || 'AC01' || '�ֶ�' || UPPER(v_name) || '����������Ϊ' ||
                           col_type || '�����ܴ���' ;

           RETURN;
        END IF;

        EXECUTE IMMEDIATE v_sql
                        INTO v_varchar;
                    v_varchar := nvl(v_varchar, '');

         IF nvl(TRIM(v_varchar), '@*yinhai#^%@') != nvl(TRIM(v_value), '@*yinhai#^%@') THEN
           v_iaz013 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ013');
           IF Prm_Appcode != pkg_constant.GN_DEF_OK THEN
             ROLLBACK;
              RETURN;
           END IF;

           INSERT INTO wsjb.IRAD32
                     (
                      iaz013,
                      iaz012,
                      iaz008,
                      iad004,
                      iad006,
                      iad007,
                      iad008,
                      iad009,
                      aae011,
                      aae035,
                      aab001,
                      yab003,
                      aae013,
                      aae100
                     ) VALUES
                     (
                       v_iaz013,
                       v_iaz012,
                       prm_aac001,
                       'AC01',
                       v_name,
                       v_comments,
                       v_varchar,
                       v_value,
                       prm_aae011,
                       sysdate,
                       prm_aab001,
                       PKG_Constant.YAB003_JBFZX,
                       '��Ա��Ҫ��Ϣά��',
                       '1'
                     );

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
            prm_ErrorMsg := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;

    END prc_PersonInfoMaintain;

   /*****************************************************************************
   ** �������� : prc_PersonInfoMaintainDanYL
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����Ա��Ҫ��Ϣά��(��Ե�����)
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **                 prm_aac001       IN     irac01.aac001%TYPE,--���˱��
   **                 prm_aab001       IN     irac01.aab001%TYPE,--��λ���
   **                 prm_aac002       IN     irac01.aac002%TYPE,--֤������
   **                 prm_aac003       IN     irac01.aac003%TYPE,--����
   **                 prm_aac004       IN     irac01.aac004%TYPE,--�Ա�
   **                 prm_aac006       IN     irac01.aac006%TYPE,--��������
   **                 prm_aac009       IN     irac01.aac009%TYPE,--��������
   **                 prm_aae011       IN     irac01.aae011%TYPE,--������
   **                 prm_aac040       IN     irac01.aac040%TYPE,--�걨����
   **           prm_AppCode      OUT    VARCHAR2    ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-4   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
  PROCEDURE prc_PersonInfoMaintainDanYL (
      prm_aac001       IN     irac01.aac001%TYPE,--���˱��
      prm_aab001       IN     irac01.aab001%TYPE,--��λ���
      prm_aac002       IN     irac01.aac002%TYPE,--֤������
      prm_aac003       IN     irac01.aac003%TYPE,--����
      prm_aac004       IN     irac01.aac004%TYPE,--�Ա�
      prm_aac006       IN     irac01.aac006%TYPE,--��������
      prm_aac009       IN     irac01.aac009%TYPE,--��������
      prm_aac013       IN     irac01.aac013%TYPE,--�ù���ʽ
      prm_yac168       IN     irac01.yac168%TYPE,--ũ�񹤱�־
      prm_aac007        IN    irac01.aac007%TYPE,--�ι�����
      prm_aac012        IN    irac01.aac012%TYPE,--�������
      prm_aae011       IN     irac01.aae011%TYPE,--������
      prm_aac040       IN     irac01.aac040%TYPE,--�걨����
      prm_iac001       OUT    irac01.iac001%TYPE,--�걨���
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )

    IS
      n_count    number(5);
      v_aaz002   varchar2(15);--��־ID
      v_iac001   varchar2(15);--�걨��Ա�걨ID
      v_iaz012   varchar2(15);--��ʷ�޸��¼�ID
      v_iaz013   varchar2(15);--��ʷ�޸���ϸID
      v_iaz004   varchar2(15);--�걨�����¼�ID
      v_iaz005   varchar2(15);
      col_type   varchar2(106);
      v_varchar  varchar2(200);
      v_number   number(20);
      v_date     date;
      v_comments varchar2(200);
      t_cols     tab_change;
      v_sql      varchar2(200);
      v_name     varchar2(50);
      v_value     varchar2(200);
      v_iaa004   number(1);
      v_iaz006   varchar2(15);
      v_idnumber varchar2(50);
      v_username varchar2(50);
      v_familypaper varchar2(50);
      d_aac030  date;

    BEGIN

        prm_AppCode  := PKG_Constant.GN_DEF_OK;
        prm_ErrorMsg := '';

      /*��Ҫ������У��*/


      IF prm_aac001 IS NULL THEN
         prm_ErrorMsg := '���˱�Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_aac009 IS NULL THEN
         prm_ErrorMsg := '�������ʲ���Ϊ��!';
         RETURN;
      END IF;

      --�Ƿ����AC01��Ա��Ϣ
      SELECT COUNT(1)
           into n_count
           FROM xasi2.AC01
          WHERE aac001 = prm_aac001;
      IF n_count = 0 THEN
            prm_ErrorMsg := '���˱��Ϊ['|| prm_aac001 ||']����Ա��Ϣ������!';
            RETURN;
      END IF;

      --У���Ƿ������Ա��Ϣ
      SELECT COUNT(1)
           into n_count
           FROM xasi2.AC01 a,wsjb.irac01a3  b
          WHERE a.aac001 = prm_aac001 and a.aac001=b.aac001;
      IF n_count = 0 THEN
            prm_ErrorMsg := '��������Ա���Ϊ['|| prm_aac001 ||']����Ա��Ϣ��';
            RETURN;
      END IF;

      --�Ƿ�����Ѿ��걨ά����Ϣ
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAC01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and a.aac001 = prm_aac001 and b.aaa121 = PKG_Constant.AAA121_PIM and a.iaa002 = PKG_Constant.IAA002_AIR;
      IF n_count > 0 THEN
            prm_ErrorMsg := '�Ѿ����ڸ��˱��Ϊ['|| prm_aac001 ||']��ά���걨��Ϣ!';
            RETURN;
      END IF;

      --�Ƿ������ͬ����˼���
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAA02
          WHERE iaa011 = PKG_Constant.IAA011_PIM
          AND iaa005 = PKG_Constant.IAA005_YES;
      IF n_count = 0 THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'û��ϵͳ��˼�����Ϣ!����ϵά����Ա';
            RETURN;
      ELSIF n_count > 1 THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'ϵͳ��˼�����Ϣ����!����ϵά����Ա';
            RETURN;
      END IF;



      --�������Ž���¼��
      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC001';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aac001;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC002';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aac002;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC003';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aac003;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC004';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aac004;


      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC006';
      t_cols(t_cols.COUNT).COL_VALUE := to_char(prm_aac006,'yyyy-mm-dd');

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC009';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aac009;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC013';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aac013;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'YAC168';
      t_cols(t_cols.COUNT).COL_VALUE := prm_yac168;

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC007';
      t_cols(t_cols.COUNT).COL_VALUE := to_char(prm_aac007,'yyyy-mm-dd');

      t_cols(t_cols.COUNT + 1).COL_NAME := 'AAC012';
      t_cols(t_cols.COUNT).COL_VALUE := prm_aac012;

      --��ȡ������Ϣ
      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');--��ȡ��־ID

      SELECT iaa004
           into v_iaa004
           FROM wsjb.IRAA02
          WHERE iaa011 = PKG_Constant.IAA011_PIM
          AND iaa005 = PKG_Constant.IAA005_YES;

       --д����־��¼
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
                  AAE218,
                  AAE013
                 )
                 VALUES
                 (
                  v_aaz002,
                  PKG_Constant.AAA121_PIM,
                  prm_aae011,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae011,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate,
                  '��Ա��Ҫ��Ϣά��'
                 );


      --������߸���IRAC01

      SELECT count(1)
           into
            n_count
           FROM wsjb.IRAC01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and b.aaa121 = PKG_Constant.AAA121_PIM and a.aac001 = prm_aac001 and a.iaa002 = PKG_Constant.IAA002_NPS;

          IF n_count = 0 THEN

           v_iac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAC001');

           INSERT INTO wsjb.irac01  (
           iac001,
           iaa001,
           iaa002,
           aac001,
           aab001,
           yae181,
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
           yac170,
           yac502,
           yae407,
           yae496,
           aae004,
           aae005,
           aae006,
           aae007,
           yae222,
           aac040,
           yab013,
           yab139,
           aaz002,
           iaa100
           )
    SELECT
           v_iac001,
           PKG_Constant.IAA001_MDF,
           PKG_Constant.IAA002_AIR,
           aac001,
           prm_aab001,
           yae181,
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
           yac170,
           yac502,
           yae407,
           yae496,
           aae004,
           aae005,
           aae006,
           aae007,
           yae222,
           prm_aac040,
           prm_aab001,
           PKG_Constant.YAB003_JBFZX,
           v_aaz002,
           to_number(to_char(sysdate,'yyyymm'))
      FROM xasi2.AC01 WHERE aac001 = prm_aac001;

             --������Ա�걨��Ϣ��
            UPDATE wsjb.IRAC01  SET
                   aac001 = prm_aac001,
                   aac002 = prm_aac002,
                   aac003 = prm_aac003,
                   aac004 = prm_aac004,
                   aac006 = prm_aac006,
                   aac009 = prm_aac009,
                   aac013 = prm_aac013,
                   yac168 = prm_yac168,
                  aac007 = prm_aac007,
                   aac012 = prm_aac012,
                   aae036 = sysdate,
                   aaz002 = v_aaz002,
                   iaa100 = to_number(to_char(sysdate,'yyyymm'))
            WHERE iac001 = v_iac001;

       --д����ʷ�޸��¼�
      v_iaz012 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ012');
      INSERT INTO wsjb.IRAD31
                 (
                  iaz012,
                  aaz002,
                  iaz007,
                  aae011,
                  aae035,
                  aab001,
                  yab003,
                  iaa019,
                  iaa011,
                  aae013
                 )
                 VALUES
                 (
                  v_iaz012,
                  v_aaz002,
                  v_iac001,
                  prm_aae011,
                  sysdate,
                  prm_aab001,
                  PKG_Constant.YAB003_JBFZX,
                  PKG_Constant.IAA019_IR,
                  PKG_Constant.IAA011_PIM,
                  '��'
                 );


      --�걨�¼���
      v_iaz004 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ004');
      INSERT INTO wsjb.IRAD01
                 (
                 iaz004,
                 aaz002,
                 iaa011,
                 aae011,
                 aae035,
                 aab001,
                 yab003,
                 aae013,
                 iaa100
                 )
                 VALUES
                 (
                  v_iaz004,
                  v_aaz002,
                  PKG_Constant.IAA011_PIM,
                  prm_aae011,
                  sysdate,
                  prm_aab001,
                  PKG_Constant.YAB003_JBFZX,
                  '��Ա��Ҫ��Ϣά��',
                  to_number(to_char(sysdate,'yyyymm'))
                 );
       --�걨��ϸ��
       v_iaz005 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');
       INSERT INTO wsjb.IRAD02
                (
                 iaz005,
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
                ) VALUES (
                 v_iaz005,
                 v_iaz005,
                 v_iaz004,
                 v_iac001,
                 prm_aac001,
                 prm_aac003,
                 prm_aae011,
                 sysdate,
                 PKG_Constant.YAB003_JBFZX,
                 v_iaa004,
                 '0',
                 PKG_Constant.IAA015_WAD,
                 PKG_Constant.IAA016_DIR_NO,
                 null,
                 PKG_Constant.IAA020_GR
                );


      ELSIF n_count != 0 THEN

      BEGIN

       SELECT a.iaz012,b.iac001
           into
            v_iaz012,v_iac001
           FROM wsjb.IRAD31  a,wsjb.IRAC01  b,wsjb.AE02  c
          WHERE a.iaz007 = b.iac001 and b.aaz002 = c.aaz002 and c.aaa121 = PKG_Constant.AAA121_PIM and b.iaa002 = PKG_Constant.IAA002_NPS and b.aac001=prm_aac001;

           EXCEPTION
           -- WHEN NO_DATA_FOUND THEN
          -- WHEN TOO_MANY_ROWS THEN
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
           /*�رմ򿪵��α�*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '��Ա�޸���Ϣ���д��ڴ������ݣ�'|| SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;
       END;


       --������Ա�걨��Ϣ��
            UPDATE wsjb.IRAC01  SET
                   aac001 = prm_aac001,
                   iaa001 = PKG_Constant.IAA001_MDF,
                   iaa002 = PKG_Constant.IAA002_AIR,
                   aac002 = prm_aac002,
                   aac003 = prm_aac003,
                   aac004 = prm_aac004,
                   aac006 = prm_aac006,
                   aac009 = prm_aac009,
                   aac013 = prm_aac013,
                   yac168 = prm_yac168,
                   aac007 = prm_aac007,
                   aac012 = prm_aac012,
                   aae011 = prm_aae011,
                   aae036 = sysdate,
                   aaz002 = v_aaz002,
                   iaa100 = to_number(to_char(sysdate,'yyyymm'))
            WHERE iac001 = v_iac001;

            --����r��Ա�޸���Ϣ��
            UPDATE wsjb.IRAD31  SET
                   aaz002 = v_aaz002,
                   aae011 = prm_aae011,
                   aae035 = sysdate
                   --iaa019 = PKG_Constant.IAA019_IR
            WHERE iaz012 = v_iaz012;

            --����IRAD32������
            UPDATE wsjb.IRAD32  a SET
                a.aae100 = '0'
            WHERE a.iaz012 = v_iaz012 and a.aae100 = '1';

                        --�걨��ϸ��
            v_iaz005 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');

            --��ѯ�ϴ�ID
            BEGIN
              SELECT iaz005,iaz004
                    INTO v_iaz006,v_iaz004
                    FROM wsjb.IRAD02  where iaz005 = (
                   SELECT max(b.iaz005)
                   FROM wsjb.irad01  a,wsjb.irad02  b
                   where a.iaz004 = b.iaz004
                   and a.iaa011 = PKG_Constant.AAA121_PIM
                   and b.iaz008 = prm_aac001
                   and b.iaa020 = PKG_Constant.IAA020_GR
                   and b.iaa015 = PKG_Constant.IAA015_ADO);
            EXCEPTION
            -- WHEN NO_DATA_FOUND THEN
            -- WHEN TOO_MANY_ROWS THEN
            -- WHEN DUP_VAL_ON_INDEX THEN
            WHEN OTHERS THEN
            /*�رմ򿪵��α�*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '��Ա�޸���Ϣ���д��ڴ������ݣ�'|| SQLERRM||dbms_utility.format_error_backtrace ;

            RETURN;
            END;

            --������Ա�걨��Ϣ��
            UPDATE wsjb.IRAD01  SET
                   aaz002 = v_aaz002,
                   aae011 = prm_aae011,
                   aae035 = sysdate,
                  -- iaa019 = PKG_Constant.IAA019_IR,
                   iaa100 = to_number(to_char(sysdate,'yyyymm'))
            WHERE iaz004 = v_iaz004;

            --�����걨��ϸ
            INSERT INTO wsjb.IRAD02
                (
                 iaz005,
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
                ) VALUES (
                 v_iaz005,
                 v_iaz006,
                 v_iaz004,
                 v_iac001,
                 prm_aac001,
                 prm_aac003,
                 prm_aae011,
                 sysdate,
                 PKG_Constant.YAB003_JBFZX,
                 v_iaa004,
                 '0',
                 PKG_Constant.IAA015_WAD,
                 PKG_Constant.IAA016_DIR_NO,
                 null,
                 PKG_Constant.IAA020_GR
                );

     END IF;
     --��ȡ�걨���
     prm_iac001 := v_iac001;

           --��ʷ�޸���ϸ

    FOR i in 1 .. t_cols.count LOOP

        v_name := t_cols(i).COL_NAME;
        v_value := t_cols(i).COL_VALUE;

        BEGIN

         SELECT COMMENTS INTO v_comments FROM USER_COL_COMMENTS where TABLE_NAME = 'IRAC01' and COLUMN_NAME = v_name;

         SELECT DATA_TYPE INTO col_type FROM USER_TAB_COLUMNS where TABLE_NAME = 'IRAC01' and COLUMN_NAME = v_name;

        EXCEPTION
           -- WHEN NO_DATA_FOUND THEN
          -- WHEN TOO_MANY_ROWS THEN
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
           /*�رմ򿪵��α�*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'AC01����û�� '|| v_name ||'�ֶ�'|| SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;

        END;


        IF col_type IN ('CHAR', 'VARCHAR', 'VARCHAR2') THEN
           v_sql := 'SELECT '||v_name||' FROM AC01 where AAC001 = '''||prm_aac001||'''';
        ELSIF col_type IN ('NUMBER', 'INTEGER', 'FLOAT') THEN
           v_sql := 'SELECT to_char(nvl('||v_name||','''')) FROM AC01 where AAC001 = '''||prm_aac001||'''';
        ELSIF col_type IN ('DATE') THEN
           v_sql := 'SELECT decode(null,null,to_char(' || v_name ||
                                          ',''yyyy-mm-dd''))' || ' FROM AC01 where AAC001 = '''||prm_aac001||'''';
        ELSE
          ROLLBACK;
           prm_AppCode  := Pkg_Constant.GN_DEF_ERR;
           prm_ErrorMsg := '��' || 'AC01' || '�ֶ�' || UPPER(v_name) || '����������Ϊ' ||
                           col_type || '�����ܴ���' ;

           RETURN;
        END IF;

        EXECUTE IMMEDIATE v_sql
                        INTO v_varchar;
                    v_varchar := nvl(v_varchar, '');

         IF nvl(TRIM(v_varchar), '@*yinhai#^%@') != nvl(TRIM(v_value), '@*yinhai#^%@') THEN
           v_iaz013 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ013');
           IF Prm_Appcode != pkg_constant.GN_DEF_OK THEN
             ROLLBACK;
              RETURN;
           END IF;

           INSERT INTO IRAD32
                     (
                      iaz013,
                      iaz012,
                      iaz008,
                      iad004,
                      iad006,
                      iad007,
                      iad008,
                      iad009,
                      aae011,
                      aae035,
                      aab001,
                      yab003,
                      aae013,
                      aae100
                     ) VALUES
                     (
                       v_iaz013,
                       v_iaz012,
                       prm_aac001,
                       'AC01',
                       v_name,
                       v_comments,
                       v_varchar,
                       v_value,
                       prm_aae011,
                       sysdate,
                       prm_aab001,
                       PKG_Constant.YAB003_JBFZX,
                       '��Ա��Ҫ��Ϣά��',
                       '1'
                     );

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
            prm_ErrorMsg := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;

    END prc_PersonInfoMaintainDanYL;


   /*****************************************************************************
   ** �������� : prc_PersonInfoMaintainAudit
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ��������Ϣά�����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aac001       IN     irad31.aab001%TYPE,--���˱��
   **           prm_aae013       IN     irad31.aae013%TYPE,--������
   **           prm_iaa018       IN     irad22.iaa018%TYPE,--��˽��
   **           prm_aae011       IN     irad31.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-12   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInfoMaintainAudit (
     prm_aac001       IN     irac01.aac001%TYPE,--���˱��
     prm_aab001       IN     irac01.aab001%TYPE,--��λ���
     prm_aae013       IN     irad31.aae013%TYPE,--������
     prm_iaa018       IN     irad22.iaa018%TYPE,--��˽��
     prm_aae011       IN     irad31.aae011%TYPE,--������
     prm_AppCode      OUT    VARCHAR2          ,
     prm_ErrorMsg     OUT    VARCHAR2          )

     IS

      n_count    number(2);
      v_iac001   varchar2(15);
      v_aaz002   varchar2(15);
      v_iaz009   varchar2(15);
      v_iaz010   varchar2(15);
      v_iaz005   varchar2(15);
      v_iaz004   varchar2(15);
      v_iaz003   varchar2(15);
      v_yac168   varchar2(2);
      v_iaa004   number(1);
      v_iaa014   number(1);
      v_iaa017   number(1);


     BEGIN

      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;

      /*��Ҫ������У��*/
      IF prm_aac001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���˱�Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λ�����벻��Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa018 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��˽������Ϊ��!';
         RETURN;
      END IF;

      IF prm_aae011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�����˲���Ϊ��!';
         RETURN;
      END IF;


      --�Ƿ�����걨����ά����Ϣ
      SELECT COUNT(1)
           into n_count
           FROM wsjb.irac01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and b.aaa121 = PKG_Constant.IAA011_PIM and a.aac001 = prm_aac001 and (a.iaa002 = PKG_Constant.IAA002_AIR OR a.iaa002 = PKG_Constant.IAA002_NPS);
      IF n_count = 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '���˱��Ϊ['|| prm_aac001 ||']�ĸ����걨��Ϣ������!';
            RETURN;
      ELSIF n_count > 1 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '���˱��Ϊ['|| prm_aac001 ||']�ĸ����걨��Ϣ��������ϵά����Ա!';
            RETURN;
      END IF;

       --�Ƿ���ڸ�����Ϣ
      SELECT COUNT(1)
           into n_count
           FROM xasi2.AC01 a
          WHERE a.aac001 = prm_aac001;
      IF n_count = 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '���˱��Ϊ['|| prm_aac001 ||']�ĸ�����Ϣ������!';
            RETURN;
      END IF;

      --�Ƿ���ڸ�����Ϣ
      SELECT COUNT(1)
           into n_count
           FROM xasi2.AC01 a
          WHERE a.aac001 = prm_aac001;
      IF n_count = 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '���˱��Ϊ['|| prm_aac001 ||']�ĸ�����Ϣ������!';
            RETURN;
      END IF;

    /*  --�Ƿ����IRAC01A3��Ϣ
      SELECT COUNT(1)
           into n_count
           FROM IRAC01A3 a
          WHERE a.aac001 = prm_aac001;
      IF n_count = 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '���˱��Ϊ['|| prm_aac001 ||']�ĸ�����Ϣ��A3�в�����!';
            RETURN;
      END IF;
      */

       --��־��¼
      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');

      INSERT INTO wsjb.AE02
             (
              aaz002,
              aaa121,
              aae011,
              yab003,
              aae014,
              aae016,
              aae216,
              aae217,
              aae218,
              aae013
             ) VALUES (
              v_aaz002,
              PKG_Constant.AAA121_PIA,
              prm_aae011,
              PKG_Constant.YAB003_JBFZX,
              prm_aae011,
              '1',
              sysdate,
              sysdate,
              sysdate,
              prm_aae013
             );



      BEGIN

      --����¼�
      v_iaz009 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ009');

      INSERT INTO wsjb.IRAD21
                  (
                  IAZ009,
                  AAZ002,
                  IAA011,
                  AEE011,
                  AAE035,
                  YAB003,
                  AAE013
                  )
                  VALUES
                  (
                  v_iaz009,
                  v_aaz002,
                  PKG_Constant.IAA011_PIM,
                  prm_aae011,
                  sysdate,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae013
      );


      --�����ϸ����
      v_iaz010 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ010');
         IF v_iaz010 IS NULL OR v_iaz010 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�IAZ010!';
            RETURN;
         END IF;

      BEGIN
      SELECT a.iac001,b.iaz005,b.iaa004,b.iaa014,d.iaz004
               INTO v_iac001,v_iaz005,v_iaa004,v_iaa014,v_iaz004
               FROM wsjb.irac01  a,wsjb.irad02  b,wsjb.ae02  c,wsjb.irad01  d
               WHERE a.iac001 = b.iaz007
               and a.aaz002 = c.aaz002
               and d.aaz002 = c.aaz002
               and a.aac001 = b.iaz008
               and d.iaz004 = b.iaz004
               and d.iaa011 = PKG_Constant.IAA011_PIM
               and c.aaa121 = PKG_Constant.IAA011_PIM
               and b.iaa020 = PKG_Constant.IAA020_GR
               and a.iaa002 = PKG_Constant.IAA002_AIR
               and b.iaa016 = PKG_Constant.IAA016_DIR_NO
               and b.iaa015 = PKG_Constant.IAA015_WAD
               and a.aac001 = prm_aac001;

       v_iaa014 := v_iaa014 + 1;

       IF v_iaa004 = v_iaa014 THEN
        v_iaa017 := v_iaa014;
       ELSE
        v_iaa017 := v_iaa014 + 1;
       END IF;

        EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '����ά����Ϣ���ִ�������ϵά����Ա������'|| SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;
       END;


       --�����ϸд��

         INSERT INTO wsjb.IRAD22
                    (
                     IAZ010,
                     IAZ011,
                     IAZ009,
                     IAZ005,
                     IAA004,
                     IAA014,
                     IAA017,
                     AAE011,
                     AAE035,
                     YAB003,
                     IAA018,
                     IAD005,    --������
                     AAE013
                     )
                    VALUES
                    (
                     v_iaz010,
                     v_iaz010,
                     v_iaz009,
                     v_iaz005,
                     v_iaa004,
                     v_iaa014,
                     v_iaa017,
                     prm_aae011,
                     sysdate,
                     PKG_Constant.YAB003_JBFZX,
                     prm_iaa018,
                     prm_aae013,  --������
                     null
                     );
      END;

       --����IRAD01
      UPDATE wsjb.IRAD01  SET
             aae013 = prm_aae013
      WHERE
             iaz004 = v_iaz004;
      --����IRAD02������
      UPDATE wsjb.IRAD02  SET
            iaa015 = PKG_Constant.IAA015_ADO,
            aae013 = prm_aae013
      WHERE
            iaz005 = v_iaz005;


       --����IRAD41������
      BEGIN

        SELECT a.iaz003 INTO v_iaz003 FROM wsjb.IRAD41  a,wsjb.IRAD01  b,wsjb.IRAD02  c
        WHERE a.iaz004 = b.iaz004 and b.iaa011 = PKG_Constant.IAA011_PIM
        and b.aab001 = prm_aab001 and a.iaa012 = PKG_Constant.IAA012_WDW
        and b.iaz004 = c.iaz004 and c.iaa015 = PKG_Constant.IAA015_WAD
        and c.iaz008 = prm_aac001
        and c.iaa016 = PKG_Constant.IAA016_DIR_NO;

        UPDATE wsjb.IRAD41  SET
              iaa012 = PKG_Constant.IAA012_ODW,
              aae036 = sysdate,
              aae013 = prm_aae013
        WHERE
              iaz003 = v_iaz003;

      EXCEPTION
       WHEN NO_DATA_FOUND THEN
       null;
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := 'ԤԼ��Ϣ���ִ��󣡣���'|| SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;
      END;



       --����AC01������
      IF prm_iaa018 = '1' THEN

        UPDATE wsjb.IRAC01  SET
            iaa002 = PKG_Constant.IAA002_APS
        WHERE
            iac001 = v_iac001;

        UPDATE xasi2.AC01 SET
            (
             yae181,
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
             yac170,
             yac502,
             yae407,
             yae496,
             aae004,
             aae005,
             aae006,
             aae007,
             yae222,
             aae013
             )
            =
            (SELECT
             yae181,
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
             yac170,
             yac502,
             yae407,
             yae496,
             aae004,
             aae005,
             aae006,
             aae007,
             yae222,
             aae013
             FROM wsjb.irac01  a where
             a.iac001 = v_iac001
             )
             where aac001 = prm_aac001;

             UPDATE wsjb.irac01  SET
                  (yae181,
                   aac002,
                   aac003,
                   aac004,
                   aac007,
                   aac012,
                   aac006)
                   =(SELECT
                     yae181,
                     aac002,
                     aac003,
                     aac004,
                     aac007,
                     aac012,
                     aac006
                     FROM wsjb.irac01  a
                     WHERE a.iac001 = v_iac001)
               WHERE aac001 = prm_aac001
                 AND aab001 = prm_aab001
                 AND iaa001 <> '4';



        BEGIN

            SELECT A.YAC168
            INTO v_yac168
            FROM xasi2.AC01 A WHERE A.AAC001 = prm_aac001;

            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := 'ũ�񹤱�־Ϊ�գ�';
               RETURN;
          -- WHEN DUP_VAL_ON_INDEX THEN
            WHEN OTHERS THEN
             /*�رմ򿪵��α�*/
              ROLLBACK;
              prm_AppCode  :=  gn_def_ERR;
              prm_ErrorMsg := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
              RETURN;
        END;

        IF v_yac168 = PKG_Constant.YAC168_F THEN

          UPDATE xasi2.AC02 a SET
            a.yac505 = PKG_Constant.YAC505_SYEPT
          WHERE
              --a.aac031 = PKG_Constant.AAC031_CBJF
                a.aae140 = PKG_Constant.AAE140_SYE
              and a.aab001 = prm_aab001
              and a.aac001 = prm_aac001;

        ELSIF v_yac168 = PKG_Constant.YAC168_S THEN

          UPDATE xasi2.AC02 a SET
            a.yac505 = PKG_Constant.YAC505_SYENMG
          WHERE
              --a.aac031 = PKG_Constant.AAC031_CBJF
              a.aae140 = PKG_Constant.AAE140_SYE
              and a.aab001 = prm_aab001
              and a.aac001 = prm_aac001;

        END IF;
        --�Ƿ����IRAC01A3��Ϣ
         SELECT COUNT(1)
           INTO n_count
           FROM wsjb.IRAC01A3  a
          WHERE a.aac001 = prm_aac001;
        IF n_count > 0 THEN
        --����IRAC01A3������
        UPDATE wsjb.IRAC01A3  SET
            (
             yae181,
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
             yac170,
             yac502,
             yae407,
             yae496,
             aae004,
             aae005,
             aae006,
             aae007,
             yae222,
             aae013
             )
            =
            (SELECT
             yae181,
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
             yac170,
             yac502,
             yae407,
             yae496,
             aae004,
             aae005,
             aae006,
             aae007,
             yae222,
             aae013
             FROM wsjb.irac01  a where
             a.iac001 = v_iac001
             )
             where aac001 = prm_aac001;
      END IF ;


      UPDATE wsjb.IRAD31  SET
            iaa019 = PKG_Constant.IAA019_AD,
            aae013 = 'ͨ��'
        WHERE
            iaz007 = v_iac001
            and iaa011 = PKG_Constant.IAA011_PIM
            and iaa019 = PKG_Constant.IAA019_IR;


      ELSIF prm_iaa018 = '0' THEN
        UPDATE wsjb.IRAC01  SET
            iaa002 = PKG_Constant.IAA002_ALR
        WHERE
            iac001 = v_iac001;

        UPDATE wsjb.IRAD02  SET
            iaa015 = PKG_Constant.IAA015_DAD
        WHERE
            iaz005 = v_iaz005;
        UPDATE IRAD31  SET
            iaa019 = PKG_Constant.IAA019_AD,
            aae013 = '���'
        WHERE
            iaz007 = v_iac001
            and iaa011 = PKG_Constant.IAA011_PIM
            and iaa019 = PKG_Constant.IAA019_IR;

      ELSE
        UPDATE wsjb.IRAC01  SET
            iaa002 = PKG_Constant.IAA002_NPS
        WHERE
            iac001 = v_iac001;

       UPDATE wsjb.IRAD31   SET
            iaa019 = PKG_Constant.IAA019_AD,
            aae013 = 'δͨ��'
        WHERE
            iaz007 = v_iac001
            and iaa011 = PKG_Constant.IAA011_PIM
            and iaa019 = PKG_Constant.IAA019_IR;
      END IF;

      EXCEPTION
         WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| SQLERRM||dbms_utility.format_error_backtrace  ;
         RETURN;

     END prc_PersonInfoMaintainAudit;
   /*****************************************************************************
   ** �������� : prc_RollBackASIR
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ��������ᱣ�յǼ����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aaz002       IN     ae02.aaz002%TYPE  ,--ҵ����־���
   **           prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
   **           prm_aae011       IN     irad31.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-06   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_RollBackASIR (
      prm_aaz002       IN     ae02.aaz002%TYPE,  --ҵ����־���
      prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
      prm_aae011       IN     irad31.aae011%TYPE,--������
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum     NUMBER;
      var_yae099   xasi2.ac02a2.YAE099%TYPE;
      var_iaa020   irad02.iaa020%TYPE; --�걨ҵ������
      --��Ҫ���˵�����
      CURSOR personCur IS
      SELECT c.iaa018,
             d.iaa020,
             d.iaa015,
             d.iaa016,
             d.iaz004,
             d.iaz005,
             d.iaz006,
             d.iaz007,
             d.iaz008,
             d.iad003,
             d.aae013
        FROM wsjb.ae02  a,wsjb.irad22  c,wsjb.irad02  d,wsjb.irad21  b
       WHERE a.aaz002 = b.aaz002
         AND b.iaz009 = c.iaz009
         AND c.iaz005 = d.iaz005
         AND b.aaz002 = prm_aaz002;

   BEGIN
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      countnum := 0;

      --�������ϵ����ݴ������걨����ʱ���ܻ���
      SELECT count(1)
        INTO countnum
        FROM wsjb.irad21  a,wsjb.irad22  b,wsjb.irad02  c
       WHERE a.iaz009 = b.iaz009
         AND b.iaz005 = c.iaz006
         AND c.iaa015 = PKG_Constant.IAA015_WAD  --����
         AND a.aaz002 = prm_aaz002;
      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ڴ�������ݣ����ܻ��ˣ�';
         RETURN;
      END IF;

      --�������ϵ����ݴ���Ӧ�պ˶�֮���ܻ���
      SELECT count(1)
        INTO countnum
        FROM xasi2.ab08 a,wsjb.irad01  b
       WHERE a.aab001 = b.aab001
         AND a.aae003 = prm_iaa100
         AND a.yae517 = 'H01'       --����Ӧ�պ˶�
         AND b.aaz002 = prm_aaz002;
      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�����Ѿ�����Ӧ�պ˶������ܻ��ˣ�';
         RETURN;
      END IF;

      --�������ϵ����ݴ���ʵ�շ���֮���ܻ���
      SELECT count(1)
        INTO countnum
        FROM xasi2.ab08a8 a,wsjb.irad01  b
       WHERE a.aab001 = b.aab001
         AND a.aae003 = prm_iaa100
         AND a.yae517 = 'H01'       --����Ӧ�պ˶�
         AND b.aaz002 = prm_aaz002;
      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�����Ѿ�����ʵ�շ��䣬���ܻ��ˣ�';
         RETURN;
      END IF;

      --����Ƿ���ڿɻ��˵�����
      SELECT count(1)
        INTO countnum
        FROM wsjb.irad21  a,wsjb.irad22  b,wsjb.irad02  c
       WHERE a.iaz009 = b.iaz009
         AND b.iaz005 = c.iaz005
         AND c.iaa015 IN(PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)  --�����ϻ��߷������
         AND a.aaz002 = prm_aaz002;
      IF countnum = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�����ڿɻ��˵����ݣ����ܻ��ˣ�';
         RETURN;
      END IF;

      --ѭ������
      FOR REC_TMP_PERSON in personCur LOOP

         --���
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_DAD THEN
            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD, --����
                   AAE013 = NULL
             WHERE IAA015 = PKG_Constant.IAA015_DAD --���[�������]
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            --��˵��ǵ�λ
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_DW THEN
               --�����걨��λ״̬
               UPDATE IRAB01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --���걨
                WHERE IAA002 = PKG_Constant.IAA002_NPS  --δͨ��
                  AND IAB001 = REC_TMP_PERSON.IAZ007;
            END IF;
            --��˵��Ǹ���
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --���걨
                WHERE IAA002 = PKG_Constant.IAA002_NPS  --δͨ��
                  AND IAC001 = REC_TMP_PERSON.IAZ007;
            END IF;
         END IF;

         --��ͨ��
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_NPS THEN
            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD, --����
                   AAE013 = NULL
             WHERE IAA015 = PKG_Constant.IAA015_ADO --������
               AND IAZ005 =  REC_TMP_PERSON.IAZ005;

            --��˵��ǵ�λ
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_DW THEN
               --�����걨��λ״̬
               UPDATE wsjb.IRAB01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --���걨
                WHERE IAA002 = PKG_Constant.IAA002_NPS  --δͨ��
                  AND IAB001 = REC_TMP_PERSON.IAZ007;
            END IF;
            --��˵��Ǹ���
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --���걨
                WHERE IAA002 = PKG_Constant.IAA002_NPS  --δͨ��
                  AND IAC001 = REC_TMP_PERSON.IAZ007;
            END IF;
         END IF;

         --ͨ��
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_PAS THEN

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD --����
             WHERE IAA015 = PKG_Constant.IAA015_ADO --������
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            --��˵��ǵ�λ
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_DW THEN
               --�����걨��λ״̬
               UPDATE IRAB01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --���걨
                WHERE IAA002 = PKG_Constant.IAA002_APS  --��ͨ��
                  AND IAB001 = REC_TMP_PERSON.IAZ007;
                --zj 2013-08-20�޸�
              /* --���õ�λ���˹���
               SELECT yae099
                 INTO var_yae099
                 FROM AE02A1
                WHERE aab001 = REC_TMP_PERSON.iaz008
                  AND aaz002 = prm_aaz002;

               prc_RollBackASIREmp(
                                  REC_TMP_PERSON.IAZ008,
                                  var_yae099,
                                  prm_aae011,
                                  prm_AppCode,
                                  prm_ErrorMsg
                                  );
               IF prm_AppCode <> gn_def_OK THEN
                  ROLLBACK;
                  RETURN;
               END IF;
               */
            END IF;
            --��˵��Ǹ���
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN

               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --���걨
                WHERE IAA002 = PKG_Constant.IAA002_APS  --��ͨ��
                  AND IAC001 = REC_TMP_PERSON.IAZ007;
               --������Ա���˹���
               SELECT yae099
                 INTO var_yae099
                 FROM AE02A1
                WHERE aac001 = REC_TMP_PERSON.iaz007
                  AND aaz002 = prm_aaz002;

               prc_RollBackASIRPer(
                                  REC_TMP_PERSON.IAZ007,
                                  var_yae099,
                                  prm_AppCode,
                                  prm_ErrorMsg
                                  );
               IF prm_AppCode <> gn_def_OK THEN
                  ROLLBACK;
                  RETURN;
               END IF;
            END IF;
         END IF;
      END LOOP;

      SELECT count(1)
        INTO countnum
        FROM wsjb.irad21  a,wsjb.IRAD22  b,wsjb.IRAD02  c
       WHERE a.iaz009 = b.iaz009
         AND b.iaz005 = c.iaz005
         AND c.iaa015 IN(PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)  --�����ϻ��߷������
         AND a.aaz002 = prm_aaz002;
      IF countnum > 0 THEN
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�����ڿɻ��˵����ݣ�';
         RETURN;
      END IF;

      --ɾ�������ϸ
      DELETE
        FROM wsjb.IRAD22  a
       WHERE EXISTS
             (
              SELECT iaz009
                FROM wsjb.IRAD21
               WHERE iaz009 = a.iaz009
                 AND aaz002 = prm_aaz002
             );

      --ɾ������¼�
      DELETE
        FROM wsjb.IRAD21
       WHERE aaz002 = prm_aaz002;

      --ɾ����־��¼
      DELETE
        FROM wsjb.AE02
       WHERE aaz002 = prm_aaz002;

   EXCEPTION
      WHEN OTHERS THEN
      /*�رմ򿪵��α�*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
      RETURN;
   END prc_RollBackASIR;

   /*****************************************************************************
   ** �������� : prc_RollBackASIREmp
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ��������ᱣ�յǼ����[��λ��Ϣ����]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ���
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-06   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_RollBackASIREmp (
      prm_aab001       IN     irab01.aab001%TYPE,--��λ���
      prm_yae099       IN     xasi2.ac02a2.yae099%TYPE,--ҵ����ˮ��
      prm_aae011       IN     xasi2.ab01.aae011%TYPE,  --������
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum     NUMBER;
   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      countnum := 0;

      SELECT COUNT(1)
        INTO countnum
        FROM xasi2.AB01
       WHERE aab001 = prm_aab001;
      IF countnum = 0 THEN
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '������ָ�����˵ĵ�λ����ȷ�������Ƿ���ȷ!';
         RETURN;
      END IF;

      --���˵�λ������Ϣ
      --����֮ǰ�Ƚ��б���  wl 2013-03-28
      INSERT INTO xasi2.AB01_Rollback(AAB001,             --��λ���,VARCHAR2
                                         AAB002,             --��ᱣ�յǼ�֤����,VARCHAR2
                                         AAB003,             --��֯��������,VARCHAR2
                                         AAB004,             --��λ����,VARCHAR2
                                         AAB005,             --��λ�绰,VARCHAR2
                                         AAB006,             --���̵Ǽ�ִ������,VARCHAR2
                                         AAB007,             --���̵Ǽ�ִ�պ���,VARCHAR2
                                         AAB008,             --���̵ǼǷ�������,DATE
                                         AAB009,             --���̵Ǽ���Ч����,NUMBER
                                         AAB010,             --��׼������λ,VARCHAR2
                                         AAB011,             --��׼����,DATE
                                         AAB012,             --��׼�ĺ�,VARCHAR2
                                         AAB013,             --��������������,VARCHAR2
                                         YAB136,             --��λ����״̬,VARCHAR2
                                         AAB019,             --��λ����,VARCHAR2
                                         AAB020,             --���óɷ�,VARCHAR2
                                         AAB021,             --������ϵ,VARCHAR2
                                         AAB022,             --��λ��ҵ,VARCHAR2
                                         YLB001,             --������ҵ�ȼ�,VARCHAR2
                                         YAB391,             --����������֤������,VARCHAR2
                                         YAB388,             --����������֤�����,VARCHAR2
                                         YAB389,             --�����������ֻ�,VARCHAR2
                                         AAB015,             --���������˰칫�绰,VARCHAR2
                                         YAB515,             --ר��Ա֤������,VARCHAR2
                                         YAB516,             --ר��Ա֤�����,VARCHAR2
                                         AAB016,             --ר��Ա����,VARCHAR2
                                         YAB237,             --ר��Ա���ڲ���,VARCHAR2
                                         YAB390,             --ר��Ա�ֻ�,VARCHAR2
                                         AAB018,             --ר��Ա�칫�绰,VARCHAR2
                                         YAB517,             --ר��Ա��������,VARCHAR2
                                         AAB023,             --���ܲ��Ż����ܻ���,VARCHAR2
                                         YAB518,             --��������,DATE
                                         AAE007,             --��������,NUMBER
                                         AAE006,             --��ַ,VARCHAR2
                                         YAE225,             --ע���ַ,VARCHAR2
                                         YAB519,             --��λ��������,VARCHAR2
                                         YAB520,             --��λ��ַ,VARCHAR2
                                         AAE014,             --����,VARCHAR2
                                         AAB034,             --��ᱣ�վ����������,VARCHAR2
                                         AAB301,             --����������������,VARCHAR2
                                         YAB322,             --���һ�λ�֤��֤ʱ��,DATE
                                         YAB274,             --��ҵ��λ�ʽ���Դ,VARCHAR2
                                         YAB525,             --�Ƿ���ҵ��������ҵ��λ,VARCHAR2
                                         YAB524,             --������Ա�����۱�־,VARCHAR2
                                         YAB521,             --�����ʽ���Դ��λ,VARCHAR2
                                         YAB522,             --�����ʽ���Դ��λ,VARCHAR2
                                         YAB523,             --��λʵ�ʱ�������,NUMBER
                                         YAB236,             --������ҵ��λ���˴���,VARCHAR2
                                         AAE119,             --��λ״̬,VARCHAR2
                                         YAB275,             --��ᱣ��ִ�а취,VARCHAR2
                                         YAE496,             --�����ֵ�,VARCHAR2
                                         YAE407,             --��������,VARCHAR2
                                         AAE013,             --��ע,VARCHAR2
                                         AAE011,             --������,NUMBER
                                         AAE036,             --����ʱ��,DATE
                                         YAE443,             --����������,VARCHAR2
                                         YAB553,             --��У����,VARCHAR2
                                         AAB304,             --�������������,VARCHAR2
                                         YAE393,             --���������������ϵ�绰,VARCHAR2
                                         YAB554,             --��������������ֻ�/E-mail,VARCHAR2
                                         YKB110,             --Ԥ��ҽ���ʻ�,VARCHAR2
                                         YKB109,             --�Ƿ����ܹ���Աͳ�����,VARCHAR2
                                         YAB566,             --�Ƿ��ת��,VARCHAR2
                                         YAB565,             --���������ĺ�,VARCHAR2
                                         YAB380,             --������ҵ��־,VARCHAR2
                                         YAB279,             --ҽ��һ���Բ����ʽ�����϶�,VARCHAR2
                                         YAB003,             --���������,VARCHAR2
                                         AAF020,             --˰��������,VARCHAR2
                                         AAB343,             --һ����λ���,VARCHAR2
                                         AAB030)             --˰��,VARCHAR2
                                  SELECT AAB001,             --��λ���,VARCHAR2
                                         AAB002,             --��ᱣ�յǼ�֤����,VARCHAR2
                                         AAB003,             --��֯��������,VARCHAR2
                                         AAB004,             --��λ����,VARCHAR2
                                         AAB005,             --��λ�绰,VARCHAR2
                                         AAB006,             --���̵Ǽ�ִ������,VARCHAR2
                                         AAB007,             --���̵Ǽ�ִ�պ���,VARCHAR2
                                         AAB008,             --���̵ǼǷ�������,DATE
                                         AAB009,             --���̵Ǽ���Ч����,NUMBER
                                         AAB010,             --��׼������λ,VARCHAR2
                                         AAB011,             --��׼����,DATE
                                         AAB012,             --��׼�ĺ�,VARCHAR2
                                         AAB013,             --��������������,VARCHAR2
                                         YAB136,             --��λ����״̬,VARCHAR2
                                         AAB019,             --��λ����,VARCHAR2
                                         AAB020,             --���óɷ�,VARCHAR2
                                         AAB021,             --������ϵ,VARCHAR2
                                         AAB022,             --��λ��ҵ,VARCHAR2
                                         YLB001,             --������ҵ�ȼ�,VARCHAR2
                                         YAB391,             --����������֤������,VARCHAR2
                                         YAB388,             --����������֤�����,VARCHAR2
                                         YAB389,             --�����������ֻ�,VARCHAR2
                                         AAB015,             --���������˰칫�绰,VARCHAR2
                                         YAB515,             --ר��Ա֤������,VARCHAR2
                                         YAB516,             --ר��Ա֤�����,VARCHAR2
                                         AAB016,             --ר��Ա����,VARCHAR2
                                         YAB237,             --ר��Ա���ڲ���,VARCHAR2
                                         YAB390,             --ר��Ա�ֻ�,VARCHAR2
                                         AAB018,             --ר��Ա�칫�绰,VARCHAR2
                                         YAB517,             --ר��Ա��������,VARCHAR2
                                         AAB023,             --���ܲ��Ż����ܻ���,VARCHAR2
                                         YAB518,             --��������,DATE
                                         AAE007,             --��������,NUMBER
                                         AAE006,             --��ַ,VARCHAR2
                                         YAE225,             --ע���ַ,VARCHAR2
                                         YAB519,             --��λ��������,VARCHAR2
                                         YAB520,             --��λ��ַ,VARCHAR2
                                         AAE014,             --����,VARCHAR2
                                         AAB034,             --��ᱣ�վ����������,VARCHAR2
                                         AAB301,             --����������������,VARCHAR2
                                         YAB322,             --���һ�λ�֤��֤ʱ��,DATE
                                         YAB274,             --��ҵ��λ�ʽ���Դ,VARCHAR2
                                         YAB525,             --�Ƿ���ҵ��������ҵ��λ,VARCHAR2
                                         YAB524,             --������Ա�����۱�־,VARCHAR2
                                         YAB521,             --�����ʽ���Դ��λ,VARCHAR2
                                         YAB522,             --�����ʽ���Դ��λ,VARCHAR2
                                         YAB523,             --��λʵ�ʱ�������,NUMBER
                                         YAB236,             --������ҵ��λ���˴���,VARCHAR2
                                         AAE119,             --��λ״̬,VARCHAR2
                                         YAB275,             --��ᱣ��ִ�а취,VARCHAR2
                                         YAE496,             --�����ֵ�,VARCHAR2
                                         YAE407,             --��������,VARCHAR2
                                         '��ᱣ�յǼ����[��λ��Ϣ����]'||aae011||'��'||aae036,             --��ע,VARCHAR2
                                         prm_aae011,             --������,NUMBER
                                         SYSDATE,             --����ʱ��,DATE
                                         YAE443,             --����������,VARCHAR2
                                         YAB553,             --��У����,VARCHAR2
                                         AAB304,             --�������������,VARCHAR2
                                         YAE393,             --���������������ϵ�绰,VARCHAR2
                                         YAB554,             --��������������ֻ�/E-mail,VARCHAR2
                                         YKB110,             --Ԥ��ҽ���ʻ�,VARCHAR2
                                         YKB109,             --�Ƿ����ܹ���Աͳ�����,VARCHAR2
                                         YAB566,             --�Ƿ��ת��,VARCHAR2
                                         YAB565,             --���������ĺ�,VARCHAR2
                                         YAB380,             --������ҵ��־,VARCHAR2
                                         YAB279,             --ҽ��һ���Բ����ʽ�����϶�,VARCHAR2
                                         YAB003,             --���������,VARCHAR2
                                         AAF020,             --˰��������,VARCHAR2
                                         AAB343,             --һ����λ���,VARCHAR2
                                         AAB030              --˰��,VARCHAR2
                                    FROM xasi2.AB01
                                   WHERE aab001 = prm_aab001;
      DELETE
        FROM xasi2.AB01
       WHERE aab001 = prm_aab001;


      --���˵�λ�������
      INSERT INTO xasi2.AB01A6_ROLLBACK(AAB001,             --��λ���,VARCHAR2
                                  YAB028,             --��λ�������,VARCHAR2
                                  aae013,             --��ע
                                  aae011,
                                  aae036)
                           SELECT aab001,
                                  yab028,
                                  '��ᱣ�յǼ����[��λ��Ϣ����]',
                                  prm_aae011,
                                  SYSDATE
                             FROM xasi2.ab01a7
                            WHERE aab001 = prm_aab001;
      DELETE
        FROM xasi2.AB01A7
       WHERE aab001 = prm_aab001;

      --���˵�λ������
      INSERT INTO xasi2.ab01a2_rollback(AAB001,             --��λ���,VARCHAR2
                                  YAB021,             --��λ������,VARCHAR2
                                  YAB022,             --ʧҵ����������,VARCHAR2
                                  YAB023,             --����ҽ������������,VARCHAR2
                                  YAB024,             --��������������,VARCHAR2
                                  YAB025,             --��������������,VARCHAR2
                                  YAB027,             --�������������,VARCHAR2
                                  YAB028,             --������������������,VARCHAR2
                                  YAB026,             --��ҵ��������������,VARCHAR2
                                  aae013,
                                  aae011,
                                  aae036)
                           SELECT AAB001,             --��λ���,VARCHAR2
                                  YAB021,             --��λ������,VARCHAR2
                                  YAB022,             --ʧҵ����������,VARCHAR2
                                  YAB023,             --����ҽ������������,VARCHAR2
                                  YAB024,             --��������������,VARCHAR2
                                  YAB025,             --��������������,VARCHAR2
                                  YAB027,             --�������������,VARCHAR2
                                  YAB028,             --������������������,VARCHAR2
                                  YAB026,             --��ҵ��������������,VARCHAR2
                                  '��ᱣ�յǼ����[��λ��Ϣ����]',
                                  prm_aae011,
                                  SYSDATE
                             FROM xasi2.ab01a2
                            WHERE yab021 = prm_aab001;
      DELETE xasi2.AB01A2

       WHERE yab021 = prm_aab001;

      --����ר��Ա��Ϣ
      INSERT INTO xasi2.ab01a1_rollback(AAC001,             --���˱��,VARCHAR2
                                  AAB001,             --��λ���,VARCHAR2
                                  YAB515,             --ר��Ա֤������,VARCHAR2
                                  YAB516,             --ר��Ա֤�����,VARCHAR2
                                  AAB016,             --ר��Ա����,VARCHAR2
                                  AAB018,             --ר��Ա�칫�绰,VARCHAR2
                                  YAB390,             --ר��Ա�ֻ�,VARCHAR2
                                  YAB237,             --ר��Ա���ڲ���,VARCHAR2
                                  YAB517,             --ר��Ա��������,VARCHAR2
                                  aae011,
                                  aae036,
                                  aae013)
                           SELECT AAC001,             --���˱��,VARCHAR2
                                  AAB001,             --��λ���,VARCHAR2
                                  YAB515,             --ר��Ա֤������,VARCHAR2
                                  YAB516,             --ר��Ա֤�����,VARCHAR2
                                  AAB016,             --ר��Ա����,VARCHAR2
                                  AAB018,             --ר��Ա�칫�绰,VARCHAR2
                                  YAB390,             --ר��Ա�ֻ�,VARCHAR2
                                  YAB237,             --ר��Ա���ڲ���,VARCHAR2
                                  YAB517,             --ר��Ա��������,VARCHAR2
                                  prm_aae011,
                                  SYSDATE,
                                  '��ᱣ�յǼ����[��λ��Ϣ����]'
                             FROM xasi2.ab01a3
                            WHERE aab001 = prm_aab001;
      DELETE
        FROM xasi2.AB01A3
       WHERE aab001 = prm_aab001;

      --���˵�λ��ᱣ����Ϣ
      INSERT INTO xasi2.ab02_rollback(AAB001,             --��λ���,VARCHAR2
                                AAE140,             --��������,VARCHAR2
                                AAB050,             --��λ�α�����,DATE
                                YAE097,             --��������ں�,NUMBER
                                AAB051,             --�α�״̬,VARCHAR2
                                AAA040,             --�������,VARCHAR2
                                AAB033,             --���շ�ʽ,VARCHAR2
                                YAB139,             --�α�����������,VARCHAR2
                                YAE102,             --���һ�α��ʱ��,DATE
                                AAE042,             --���������ֹ��,NUMBER
                                YAB534,             --�ɷѿ����������,VARCHAR2
                                AAB024,             --�ɷѿ�������,VARCHAR2
                                AAB025,             --�ɷ����л���,VARCHAR2
                                AAB026,             --�ɷ����л����˺�,VARCHAR2
                                YAB535,             --֧���������������,VARCHAR2
                                AAB027,             --֧����������,VARCHAR2
                                AAB028,             --֧�����л���,VARCHAR2
                                AAB029,             --֧�����л����˺�,VARCHAR2
                                AAE011,             --������,NUMBER
                                AAE036,             --����ʱ��,DATE
                                YAB003,             --�籣�������,VARCHAR2
                                AAE013,             --��ע,VARCHAR2
                                AAE003)              --
                        SELECT  AAB001,             --��λ���,VARCHAR2
                                AAE140,             --��������,VARCHAR2
                                AAB050,             --��λ�α�����,DATE
                                YAE097,             --��������ں�,NUMBER
                                AAB051,             --�α�״̬,VARCHAR2
                                AAA040,             --�������,VARCHAR2
                                AAB033,             --���շ�ʽ,VARCHAR2
                                YAB139,             --�α�����������,VARCHAR2
                                YAE102,             --���һ�α��ʱ��,DATE
                                AAE042,             --���������ֹ��,NUMBER
                                YAB534,             --�ɷѿ����������,VARCHAR2
                                AAB024,             --�ɷѿ�������,VARCHAR2
                                AAB025,             --�ɷ����л���,VARCHAR2
                                AAB026,             --�ɷ����л����˺�,VARCHAR2
                                YAB535,             --֧���������������,VARCHAR2
                                AAB027,             --֧����������,VARCHAR2
                                AAB028,             --֧�����л���,VARCHAR2
                                AAB029,             --֧�����л����˺�,VARCHAR2
                                prm_aae011,             --������,NUMBER
                                SYSDATE,             --����ʱ��,DATE
                                YAB003,             --�籣�������,VARCHAR2
                                '��ᱣ�յǼ����[��λ��Ϣ����]'||aae011||','||aae036,             --��ע,VARCHAR2
                                AAE003              --
                           FROM xasi2.ab02
                          WHERE aab001 = prm_aab001;
      DELETE
        FROM xasi2.AB02
       WHERE aab001 = prm_aab001;

      --���˵�λ���ֱ����Ϣ
      INSERT INTO xasi2.ab06_rollback(YAE099,             --ҵ����ˮ��,VARCHAR2
                                AAB001,             --��λ���,VARCHAR2
                                AAE140,             --��������,VARCHAR2
                                AAB100,             --��λ�������,VARCHAR2
                                AAB101,             --��λ�������,DATE
                                AAB102,             --��λ���ԭ��,VARCHAR2
                                AAE013,             --��ע,VARCHAR2
                                AAE011,             --������,NUMBER
                                AAE036,             --����ʱ��,DATE
                                YAB003,             --�籣�������,VARCHAR2
                                YAB139)             --�α�����������,VARCHAR2
                         SELECT YAE099,             --ҵ����ˮ��,VARCHAR2
                                AAB001,             --��λ���,VARCHAR2
                                AAE140,             --��������,VARCHAR2
                                AAB100,             --��λ�������,VARCHAR2
                                AAB101,             --��λ�������,DATE
                                AAB102,             --��λ���ԭ��,VARCHAR2
                                '��ᱣ�յǼ����[��λ��Ϣ����]'||aae011||','||aae036,             --��ע,VARCHAR2
                                prm_aae011,             --������,NUMBER
                                SYSDATE,             --����ʱ��,DATE
                                YAB003,             --�籣�������,VARCHAR2
                                YAB139              --�α�����������,VARCHAR2
                           FROM xasi2.ab06
                          WHERE aab001 = prm_aab001;
      DELETE
        FROM xasi2.AB06
       WHERE aab001 = prm_aab001;

   EXCEPTION
      WHEN OTHERS THEN
      /*�رմ򿪵��α�*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
      RETURN;
   END prc_RollBackASIREmp;

   /*****************************************************************************
   ** �������� : prc_RollBackASIRPer
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ��������ᱣ�յǼ����[������Ϣ���� �²α� ����]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aac001       IN     irac01.aac001%TYPE,--��Ա���
   **           prm_yea099       IN     ae02a2.yae099%TYPE,--ҵ����ˮ��
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-06   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_RollBackASIRPer (
      prm_iac001       IN     irac01.iac001%TYPE,--�걨��Ա���
      prm_yae099       IN     xasi2.ac02a2.yae099%TYPE,--ҵ����ˮ��
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum        NUMBER;
      var_aac050      VARCHAR2(2);
      var_existsxb    VARCHAR2(2);
      var_aae140_01   VARCHAR2(2);         --�Ƿ�μ�����ҵ����
      var_aae140_06   VARCHAR2(2);         --�Ƿ�μ��˻�������
      var_aae140_02   VARCHAR2(2);         --�Ƿ�μ���ʧҵ
      var_aae140_03   VARCHAR2(2);         --�Ƿ�μ��˻���ҽ��
      var_aae140_04   VARCHAR2(2);         --�Ƿ�μ��˹���
      var_aae140_05   VARCHAR2(2);         --�Ƿ�μ�������
      var_aae140_07   VARCHAR2(2);         --�Ƿ�μ��˴��
      rec_irac01      irac01%rowtype   ;
      t_cols          tab_change       ;
   BEGIN

      prm_AppCode    := PKG_Constant.gn_def_OK ;
      prm_ErrorMsg   := '';

      var_existsxb   := '0';
      countnum := 0;

      SELECT *
        INTO rec_irac01
        FROM wsjb.irac01
       WHERE IAC001 = prm_iac001;

      var_aae140_01 := rec_irac01.aae110;        --�Ƿ�μ�����ҵ����
      var_aae140_06 := rec_irac01.aae120;        --�Ƿ�μ��˻�������
      var_aae140_02 := rec_irac01.aae210;        --�Ƿ�μ���ʧҵ
      var_aae140_03 := rec_irac01.aae310;        --�Ƿ�μ��˻���ҽ��
      var_aae140_04 := rec_irac01.aae410;        --�Ƿ�μ��˹���
      var_aae140_05 := rec_irac01.aae510;        --�Ƿ�μ�������
      var_aae140_07 := rec_irac01.aae311;        --�Ƿ�μ��˴��

      IF var_aae140_06 = '1' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE120';
         t_cols(t_cols.count).col_value := '06';
      END IF;

      IF var_aae140_02 = '1' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE210';
         t_cols(t_cols.count).col_value := '02';
      END IF;

      IF var_aae140_03 = '1' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE310';
         t_cols(t_cols.count).col_value := '03';
      END IF;

      IF var_aae140_04 = '1' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE410';
         t_cols(t_cols.count).col_value := '04';
      END IF;

      IF var_aae140_05 = '1' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE510';
         t_cols(t_cols.count).col_value := '05';
      END IF;

      IF var_aae140_07 = '1' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE311';
         t_cols(t_cols.count).col_value := '07';
      END IF;

      --�Ƿ������������
      SELECT COUNT(1)
        INTO COUNTNUM
        FROM xasi2.AC05 a
       WHERE a.aac001 = rec_irac01.AAC001
         AND a.aac050 = PKG_Constant.AAC050_XB
         AND a.yae099 = prm_yae099;
      IF COUNTNUM > 0 THEN
         var_existsxb := '1';
      END IF;

      FOR i in 1 .. t_cols.count LOOP

         --��������Ƿ�������������
         SELECT AAC050
           INTO var_aac050
           FROM xasi2.AC05 a
          WHERE a.aac001 = rec_irac01.AAC001
            AND a.aae140 = t_cols(i).col_value
            AND a.yae099 = prm_yae099;

         --������������
         IF var_aac050 =  PKG_Constant.AAC050_XCB THEN
            --���˲α���Ϣ
            DELETE
              FROM xasi2.AC02
             WHERE aae140 = t_cols(i).col_value
               AND aac001 = rec_irac01.AAC001;
            --����ҽ�ƵĴ������
            IF t_cols(i).col_value = PKG_Constant.AAE140_JBYL THEN
               DELETE
                 FROM xasi2.KC01
                WHERE aac001 = rec_irac01.AAC001;
               DELETE
                 FROM xasi2.KC01K1
                WHERE aac001 = rec_irac01.AAC001
                  AND yae099 = prm_yae099;
            END IF;
         END IF;

         --��������
         IF var_aac050 =  PKG_Constant.AAC050_XB THEN
            --���˲α���Ϣ
            UPDATE xasi2.AC02
               SET (AC02.aab001,
                    AC02.yae102,
                    AC02.aac031,
                    AC02.aac040,
                    AC02.yac004,
                    AC02.yac503,
                    AC02.YAA333,
                    AC02.yab139
                   ) =
              (SELECT  B.aab001,
                       B.yae102,
                       B.aac031,
                       B.aac040,
                       B.yac004,
                       B.yac503,
                       B.YAA333,
                       B.yab139
                  FROM xasi2.AC02A2 B
                 WHERE B.aae140 = AC02.aae140
                   AND B.aac001 = AC02.aac001)
             WHERE EXISTS (SELECT 1
                      FROM xasi2.AC02A2 T
                     WHERE T.aac001 = AC02.aac001
                       and T.aae140 = AC02.aae140
                       AND T.aae140 = t_cols(i).col_value
                       AND T.aac001 = rec_irac01.AAC001
                       and T.yae099 = prm_yae099);

            IF t_cols(i).col_value = PKG_Constant.aae140_GS THEN
               DELETE
                 FROM xasi2.AC02
                WHERE aae140 = t_cols(i).col_value
                  AND aac001 = rec_irac01.AAC001
                  AND aab001 = rec_irac01.aab001;
            END IF;
            --����ҽ�ƵĴ������
            IF t_cols(i).col_value = PKG_Constant.AAE140_JBYL THEN
               --����ҽ�Ʊ�����Ϣ
               UPDATE xasi2.KC01
                  SET aab001 = (SELECT yab013
                                  FROM xasi2.AC05
                                 WHERE aac001 = rec_irac01.AAC001
                                   AND aae140 = PKG_Constant.AAE140_JBYL
                                   AND yae099 = prm_yae099)
                WHERE aac001 = rec_irac01.AAC001;
               --�����ƿ�����Ϣ
               DELETE
                 FROM xasi2.KC01K1
                WHERE aac001 = rec_irac01.AAC001
                  AND yae099 = prm_yae099;
               --�����ƿ�����Ϣ

            END IF;
         END IF;

         --�����¼���Ϣ
         DELETE
           FROM xasi2.AC05
          WHERE aae140 = t_cols(i).col_value
            AND aac001 = rec_irac01.AAC001
            AND yae099 = prm_yae099;

         --���˻����¼�
         DELETE
           FROM xasi2.AC04A3
          WHERE aae140 = t_cols(i).col_value
            AND aac001 = rec_irac01.AAC001
            AND yae099 = prm_yae099;

      END LOOP;

      --û���������ڣ����˸�����Ϣ
      IF var_existsxb = '0' THEN
         DELETE
           FROM xasi2.AC01
          WHERE AAC001 = rec_irac01.AAC001;

         DELETE
           FROM wsjb.IRAC01A3
          WHERE AAC001 = rec_irac01.AAC001
            AND AAB001 = rec_irac01.AAB001;

         UPDATE wsjb.IRAC01
            SET AAC001 = rec_irac01.IAC001
          WHERE IAC001 = rec_irac01.IAC001;

         UPDATE wsjb.IRAD02
            SET IAZ008 = rec_irac01.IAC001
          WHERE IAZ007 = rec_irac01.IAC001;
      ELSE
         UPDATE wsjb.IRAC01A3
            SET AAE110 = DECODE(var_aae140_01,'1','0',AAE110),
                AAE120 = DECODE(var_aae140_06,'1','0',AAE120),
                AAE210 = DECODE(var_aae140_02,'1','0',AAE210),
                AAE310 = DECODE(var_aae140_03,'1','0',AAE310),
                AAE410 = DECODE(var_aae140_04,'1','0',AAE410),
                AAE510 = DECODE(var_aae140_05,'1','0',AAE510),
                AAE311 = DECODE(var_aae140_07,'1','0',AAE311)
          WHERE AAC001 = rec_irac01.AAC001
            AND AAB001 = rec_irac01.AAB001;
      END IF;

   EXCEPTION
      WHEN OTHERS THEN
      /*�رմ򿪵��α�*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '���ݿ����:'|| SQLERRM||dbms_utility.format_error_backtrace  ;
      RETURN;
   END prc_RollBackASIRPer;

   /*****************************************************************************
   ** �������� : prc_ResetASIR
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ��������ᱣ�յǼ����
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
   PROCEDURE prc_ResetASIR (
      prm_aab001       IN     irab01.aab001%TYPE,--��λ���
      prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
      prm_aae011       IN     irad31.aae011%TYPE,--������
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum     NUMBER;

      --��Ҫ���õ��걨����
      CURSOR personCur IS
      SELECT c.iaz004,
             c.iaz005,
             c.iaz007,
             c.iaz008,
             c.iad003,
             c.iaa020
        FROM wsjb.ae02  a,wsjb.irad01  b,wsjb.irad02  c
       WHERE a.aaz002 = b.aaz002
         AND b.iaz004 = c.iaz004
         AND a.aaa121 = PKG_Constant.aaa121_SIR
         AND b.aab001 = prm_aab001
         AND b.iaa100 = prm_iaa100;

      --��Ҫ���õ��������
      CURSOR irad21Cur IS
      SELECT distinct a.aaz002
        FROM wsjb.ae02  a,wsjb.irad22  c,wsjb.irad01  e,wsjb.irad02  d,wsjb.irad21  b
       WHERE a.aaz002 = b.aaz002
         AND b.iaz009 = c.iaz009
         AND c.iaz005 = d.iaz005
         AND e.iaz004 = d.iaz004
         AND b.iaa011 = PKG_Constant.IAA011_SIR
         AND a.aaa121 = PKG_Constant.aaa121_SIA
         AND e.aab001 = prm_aab001
         AND e.iaa100 = prm_iaa100;
   BEGIN
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      countnum := 0;

      --����Ƿ������������
      SELECT count(1)
        INTO countnum
        FROM wsjb.ae02  a,wsjb.irad01  b,wsjb.irad02  c
       WHERE a.aaz002 = b.aaz002
         AND b.iaz004 = c.iaz004
         AND a.aaa121 = PKG_Constant.aaa121_SIR
         AND b.aab001 = prm_aab001
         AND b.iaa100 = prm_iaa100;
      IF countnum = 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '��ǰ�籣�����뵥λ�������걨����ᱣ�յǼ����ݣ���������!';
         RETURN;
      END IF;

      --�Ƿ�����걨��������䶯��¼
      SELECT count(1)
        INTO countnum
        FROM wsjb.IRAC01
       WHERE IAA001 NOT IN ('2', '4')
         AND IAA002 = '0'
         AND IAA100 IS NULL
         AND AAB001 = prm_aab001;
      IF countnum > 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '��ǰ�籣�����뵥λ�����걨��������䶯��¼���ݣ���������!�뵥λ���˺������ã�';
         RETURN;
      END IF;

      --����Ƿ������˼�¼
      SELECT count(1)
        INTO countnum
        FROM wsjb.ae02  a,wsjb.irad22  c,wsjb.irad01  e,wsjb.irad02  d,wsjb.irad21  b
       WHERE a.aaz002 = b.aaz002
         AND b.iaz009 = c.iaz009
         AND c.iaz005 = d.iaz005
         AND e.iaz004 = d.iaz004
         AND b.iaa011 = PKG_Constant.IAA011_SIR
         AND a.aaa121 = PKG_Constant.aaa121_SIA
         AND e.aab001 = prm_aab001
         AND e.iaa100 = prm_iaa100;

      --����˼�¼�������������
      IF countnum > 0 THEN
         FOR rec_irad21 in irad21Cur LOOP
             prc_RollBackASIR(rec_irad21.aaz002,--���ҵ����־
                              prm_iaa100       ,--�걨�¶�
                              prm_aae011       ,--������
                              prm_AppCode      ,
                              prm_ErrorMsg
                              );
             IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                RETURN;
             END IF;
         END LOOP;
      END IF;

      --�����걨����
      FOR rec_person in personCur LOOP
         IF rec_person.iaa020 = PKG_Constant.IAA020_DW THEN
            UPDATE wsjb.IRAB01
               SET iaa002 = PKG_Constant.IAA002_WIR
             WHERE IAB001 = rec_person.iaz007;
         END IF;
         IF rec_person.iaa020 = PKG_Constant.IAA020_GR THEN
            UPDATE wsjb.IRAC01
               SET iaa002 = PKG_Constant.IAA002_WIR
             WHERE IAC001 = rec_person.iaz007;
         END IF;
         DELETE
           FROM wsjb.IRAD02
          WHERE IAZ005 = rec_person.iaz005;
      END LOOP;

      DELETE
        FROM wsjb.IRAD01
       WHERE aab001 = prm_aab001
         AND iaa100 = prm_iaa100
         AND iaa011 = PKG_Constant.IAA011_SIR;

      DELETE
        FROM wsjb.AE02  a
       WHERE a.AAA121 = PKG_Constant.AAA121_SIR
         AND EXISTS (SELECT yae092
                       FROM wsjb.IRAA01
                      WHERE yae092 = a.aae011
                        AND aab001 = prm_aab001
                    )
         ;
   EXCEPTION
      WHEN OTHERS THEN
      /*�رմ򿪵��α�*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
      RETURN;
   END prc_ResetASIR;

   /*****************************************************************************
   ** �������� : prc_RollBackAMIR
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ���������걨���
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aaz002       IN     ae02.aaz002%TYPE  ,--ҵ����־���
   **           prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
   **           prm_aae011       IN     irad31.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-06   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_RollBackAMIR (
      prm_aaz002       IN     ae02.aaz002%TYPE,  --ҵ����־���
      prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
      prm_aab001       IN     irad01.aab001%TYPE,--�걨��λ
      prm_aae011       IN     irad31.aae011%TYPE,--������
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum     NUMBER;
      var_yae099   xasi2.ac02a2.YAE099%TYPE;
      var_iaa020   irad02.iaa020%TYPE; --�걨ҵ������
      var_aab001   varchar(6);
      --��Ҫ���˵�����
      CURSOR personCur IS
      SELECT c.iaa018,
             e.iaa001,
             e.iac001,
             d.iaa020,
             d.iaa015,
             d.iaa016,
             d.iaz004,
             d.iaz005,
             d.iaz006,
             d.iaz007,
             d.iaz008,
             d.iad003,
             d.aae013
        FROM wsjb.ae02  a,wsjb.irad22  c,wsjb.irad02  d,wsjb.irac01  e,wsjb.irad21  b
       WHERE a.aaz002 = b.aaz002
         AND b.iaz009 = c.iaz009
         AND c.iaz005 = d.iaz005
         AND d.iaz007 = e.iac001
         AND b.aaz002 = prm_aaz002;

   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      countnum := 0;

      --�������ϵ����ݴ������걨����ʱ���ܻ���
      /*SELECT count(1)
        INTO countnum
        FROM irad21 a,irad22 b,irad02 c
       WHERE a.iaz009 = b.iaz009
         AND b.iaz005 = c.iaz006
         AND c.iaa015 = PKG_Constant.IAA015_WAD  --����
         AND a.aaz002 = prm_aaz002;
      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ڴ�������ݣ����ܻ��ˣ�';
         RETURN;
      END IF;*/

      --�������ϵ����ݴ���Ӧ�պ˶�֮���ܻ���
      SELECT count(1)
        INTO countnum
        FROM xasi2.ab08
       WHERE aab001 = prm_aab001
         AND aae003 = prm_iaa100
         AND yae517 = 'H01';       --����Ӧ�պ˶�
      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�����Ѿ�����Ӧ�պ˶������ܻ��ˣ�';
         RETURN;
      END IF;

      --�������ϵ����ݴ���ʵ�շ���֮���ܻ���
      SELECT count(1)
        INTO countnum
        FROM xasi2.ab08a8
       WHERE aab001 = prm_aab001
         AND aae003 = prm_iaa100
         AND YAB538 = '1' -- modify by whm ���������ݵ� 20190419
         AND yae517 = 'H01';       --����Ӧ�պ˶�
      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�����Ѿ�����ʵ�շ��䣬���ܻ��ˣ�';
         RETURN;
      END IF;

      --����Ƿ���ڿɻ��˵�����
      SELECT count(1)
        INTO countnum
        FROM wsjb.irad21  a,wsjb.irad22  b,wsjb.irad02  c
       WHERE a.iaz009 = b.iaz009
         AND b.iaz005 = c.iaz005
         AND c.iaa015 IN(PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)  --�����ϻ��߷������
         AND a.aaz002 = prm_aaz002;
      IF countnum = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�����ڿɻ��˵����ݣ����ܻ��ˣ�';
         RETURN;
      END IF;

      --ѭ������
      FOR REC_TMP_PERSON in personCur LOOP

         --���
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_DAD THEN
            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD, --����
                   AAE013 = NULL
             WHERE IAA015 = PKG_Constant.IAA015_DAD --���[�������]
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            --��˵��Ǹ���
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --���걨
                WHERE IAA002 = PKG_Constant.IAA002_ALR  --�Ѵ��
                  AND IAC001 = REC_TMP_PERSON.IAZ007;
            END IF;
         END IF;

         --��ͨ��
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_NPS THEN
            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD, --����
                   AAE013 = NULL
             WHERE IAA015 = PKG_Constant.IAA015_ADO --������
               AND IAZ005 =  REC_TMP_PERSON.IAZ005;

            --��˵��Ǹ���
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --���걨
                WHERE IAA002 = PKG_Constant.IAA002_NPS  --δͨ��
                  AND IAC001 = REC_TMP_PERSON.IAZ007;
            END IF;
         END IF;

         --ͨ��
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_PAS THEN

            SELECT yae099,aab001
              INTO var_yae099 ,var_aab001
              FROM wsjb.AE02A1
             WHERE aac001 = REC_TMP_PERSON.iaz007
               AND aaz002 = prm_aaz002;

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD --����
             WHERE IAA015 = PKG_Constant.IAA015_ADO --������
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            --��˵��Ǹ���
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --���걨
                WHERE IAA002 = PKG_Constant.IAA002_APS  --��ͨ��
                  AND IAC001 = REC_TMP_PERSON.IAZ007;

               /*--��Ա���ӵĻ���
               IF REC_TMP_PERSON.iaa001 = PKG_Constant.IAA001_ADD THEN
                  --������Ա���˹���
                  prc_RollBackASIRPer(
                                     REC_TMP_PERSON.IAZ007,
                                     var_yae099,
                                     prm_AppCode,
                                     prm_ErrorMsg
                                     );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               --��Ա���ٵĻ���
               IF REC_TMP_PERSON.iaa001 = PKG_Constant.IAA001_MIN THEN
                  --������Ա���˹���
                  prc_RollBackAMIRPer(
                                     REC_TMP_PERSON.IAZ007,
                                     var_yae099,
                                     prm_AppCode,
                                     prm_ErrorMsg
                                     );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;*/

                              /*
                  ��Ա����[�²α��������²α�]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_ADD,PKG_Constant.IAA001_PAD) THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[�²α� ����]
                     �Ϸ��� prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuCheckRollback(var_yae099,
                                  REC_TMP_PERSON.IAC001,
                                  prm_aae011,
                                  PKG_Constant.YAB003_JBFZX,
                                  '���Ͼ������',
                                  prm_AppCode,
                                  prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  ��Ա����[��Ա��������]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_IAD THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[�²α� ����]
                     �Ϸ��� prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuAddCheckRollback(var_yae099,
                                    REC_TMP_PERSON.IAC001,
                                    prm_aae011,
                                    PKG_Constant.YAB003_JBFZX,
                                    '���Ͼ������',
                                    prm_AppCode,
                                    prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  ��Ա����[��Ա����]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_CIN THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[�²α� ����]
                     �Ϸ��� prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuContinueRollback(var_yae099,
                                    REC_TMP_PERSON.IAC001,
                                    prm_aae011,
                                    PKG_Constant.YAB003_JBFZX,
                                    '���Ͼ������',
                                    prm_AppCode,
                                    prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  ��Ա����[��Ա��ͣ�ɷ���������ͣ�ɷѣ�������Ա����(����ͣ��ͬ)]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_MIN,PKG_Constant.IAA001_PMI,PKG_Constant.IAA001_RPD) THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[ͣ�� ����]
                     �Ϸ��� prc_AuditMonthInternetRpause
                  */

                  prc_PersonInsuPauseRollback(var_yae099,
                                      REC_TMP_PERSON.IAC001,
                                      prm_aae011,
                                      PKG_Constant.YAB003_JBFZX,
                                      '���Ͼ������',
                                      prm_AppCode,
                                      prm_ErrorMsg
                                      );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  ��Ա����[��ְת����]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_RTR THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[ͣ�� ����]
                     �Ϸ��� prc_AuditMonthInternetRpause
                  */

                  prc_PersonInsuPauseRollback(var_yae099,
                                      REC_TMP_PERSON.IAC001,
                                      prm_aae011,
                                      PKG_Constant.YAB003_JBFZX,
                                      '���Ͼ������',
                                      prm_AppCode,
                                      prm_ErrorMsg
                                      );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

            END IF;
         END IF;
      END LOOP;


--���˵�λ�ɷѻ���  ab02a8
    prc_Ab02a8UnitRollBack (
               var_aab001      ,
               prm_AppCode       ,
               prm_ErrorMsg     );

      IF prm_AppCode <> gn_def_OK THEN
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���˵�λ�ɷѻ�������:' ||prm_ErrorMsg;
         RETURN;
      END IF;
      --ɾ�������ϸ
      DELETE
        FROM wsjb.IRAD22  a
       WHERE EXISTS
             (
              SELECT iaz009
                FROM wsjb.IRAD21
               WHERE iaz009 = a.iaz009
                 AND aaz002 = prm_aaz002
             );

      --ɾ������¼�
      DELETE
        FROM wsjb.IRAD21
       WHERE aaz002 = prm_aaz002;

      --ɾ����־��¼
      DELETE
        FROM wsjb.AE02
       WHERE aaz002 = prm_aaz002;

      SELECT count(1)
        INTO countnum
        FROM wsjb.irad21  a,wsjb.irad22  b,wsjb.irad02  c
       WHERE a.iaz009 = b.iaz009
         AND b.iaz005 = c.iaz005
         AND c.iaa015 IN(PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)  --�����ϻ��߷������
         AND a.aaz002 = prm_aaz002;
      IF countnum > 0 THEN
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�����ڿɻ��˵����ݣ�';
         RETURN;
      END IF;

   EXCEPTION
      WHEN OTHERS THEN
      /*�رմ򿪵��α�*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
      RETURN;
   END prc_RollBackAMIR;

   /*****************************************************************************
   ** �������� : prc_PersonInsuCheckRollback
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��Ա�²α����]����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuCheckRollback(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                     prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                     prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                     prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                     prm_aae013       IN    irac01.aae013%TYPE ,    --��ע
                                     prm_AppCode      OUT   VARCHAR2  ,    --�������
                                     prm_ErrMsg       OUT   VARCHAR2  )    --��������
   IS
      num_count       NUMBER;
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --���˱��
      var_aae140_01   VARCHAR2(2);         --�Ƿ�μ�����ҵ����
      var_aae140_06   VARCHAR2(2);         --�Ƿ�μ��˻�������
      var_aae140_02   VARCHAR2(2);         --�Ƿ�μ���ʧҵ
      var_aae140_03   VARCHAR2(2);         --�Ƿ�μ��˻���ҽ��
      var_aae140_04   VARCHAR2(2);         --�Ƿ�μ��˹���
      var_aae140_05   VARCHAR2(2);         --�Ƿ�μ�������
      var_aae140_07   VARCHAR2(2);         --�Ƿ�μ��˴��
      var_aae140_08   VARCHAR2(2);
      rec_irac01      irac01%rowtype;

   BEGIN
      prm_AppCode  := PKG_Constant.GN_DEF_OK;
      prm_ErrMsg   := '';
      var_aac001   := '';

      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      var_aac001    := rec_irac01.aac001;        --��Ա���
      var_aae140_01 := rec_irac01.aae110;        --�Ƿ�μ�����ҵ����
      var_aae140_06 := rec_irac01.aae120;        --�Ƿ�μ��˻�������
      var_aae140_02 := rec_irac01.aae210;        --�Ƿ�μ���ʧҵ
      var_aae140_03 := rec_irac01.aae310;        --�Ƿ�μ��˻���ҽ��
      var_aae140_04 := rec_irac01.aae410;        --�Ƿ�μ��˹���
      var_aae140_05 := rec_irac01.aae510;        --�Ƿ�μ�������
      var_aae140_07 := rec_irac01.aae311;        --�Ƿ�μ��˴��
      var_aae140_08 := rec_irac01.aae810;

      IF var_aae140_06 = '1' OR var_aae140_02 = '1'
      OR var_aae140_03 = '1' OR var_aae140_04 = '1'
      OR var_aae140_05 = '1' OR var_aae140_07 = '1'
      OR var_aae140_08 = '1' THEN
         XASI2.pkg_gx_RollBack.prc_P_PersorNewRollBack(var_aac001,
                                                         rec_irac01.aab001,
                                                         prm_aae011,
                                                         prm_yab003,
                                                         prm_aae013,
                                                         prm_AppCode,
                                                         prm_ErrMsg);
         IF prm_AppCode <> gn_def_OK THEN
            ROLLBACK;
            RETURN;
         END IF;

      ELSE  --����ǵ����ϵĻ�
       DELETE FROM XASI2.ac01 WHERE aac001 = rec_irac01.aac001;
      END IF;

      --�����걨��Ϣ����Ա���
     UPDATE wsjb.IRAC01
        SET AAC001 = prm_iac001
      WHERE IAC001 = prm_iac001;

     --�����걨��ϸ��Ϣ����Ա���
     UPDATE wsjb.IRAD02
        SET IAZ008 = prm_iac001
      WHERE IAZ007 = prm_iac001;

      DELETE
        FROM wsjb.IRAC01A3
       WHERE aac001 = var_aac001
         AND aab001 = rec_irac01.aab001;

   EXCEPTION
      WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuCheckRollback;

   /*****************************************************************************
   ** �������� : prc_PersonInsuAddCheckRollback
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��Ա�����������]����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuAddCheckRollback(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                        prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                        prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                        prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                        prm_aae013       IN    irac01.aae013%TYPE ,    --��ע
                                        prm_AppCode      OUT   VARCHAR2  ,    --�������
                                        prm_ErrMsg       OUT   VARCHAR2  )    --��������
   IS
      num_count       NUMBER;
      var_aac001      xasi2.ac01.aac001%TYPE;    --���˱��
      var_aae140_01   VARCHAR2(2);         --�Ƿ�μ�����ҵ����
      var_aae140_06   VARCHAR2(2);         --�Ƿ�μ��˻�������
      var_aae140_02   VARCHAR2(2);         --�Ƿ�μ���ʧҵ
      var_aae140_03   VARCHAR2(2);         --�Ƿ�μ��˻���ҽ��
      var_aae140_04   VARCHAR2(2);         --�Ƿ�μ��˹���
      var_aae140_05   VARCHAR2(2);         --�Ƿ�μ�������
      var_aae140_07   VARCHAR2(2);         --�Ƿ�μ��˴��
      var_aae140_08   VARCHAR2(2);
      rec_irac01      irac01%rowtype;

   BEGIN
      prm_AppCode  := PKG_Constant.GN_DEF_OK;
      prm_ErrMsg   := '';
      var_aac001   := '';

      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      var_aac001    := rec_irac01.aac001;        --��Ա���
      var_aae140_01 := rec_irac01.aae110;        --�Ƿ�μ�����ҵ����
      var_aae140_06 := rec_irac01.aae120;        --�Ƿ�μ��˻�������
      var_aae140_02 := rec_irac01.aae210;        --�Ƿ�μ���ʧҵ
      var_aae140_03 := rec_irac01.aae310;        --�Ƿ�μ��˻���ҽ��
      var_aae140_04 := rec_irac01.aae410;        --�Ƿ�μ��˹���
      var_aae140_05 := rec_irac01.aae510;        --�Ƿ�μ�������
      var_aae140_07 := rec_irac01.aae311;        --�Ƿ�μ��˴��
      var_aae140_08 := rec_irac01.aae810;

      IF var_aae140_06 = '1' OR var_aae140_02 = '1'
      OR var_aae140_03 = '1' OR var_aae140_04 = '1'
      OR var_aae140_05 = '1' OR var_aae140_07 = '1'
      OR var_aae140_08 = '1' THEN
         XASI2.pkg_P_RollBack.prc_P_PersorContinuRollBack(prm_yae099,
                                                             var_aac001,
                                                             prm_aae011,
                                                             prm_yab003,
                                                             prm_aae013,
                                                             prm_AppCode,
                                                             prm_ErrMsg);
         IF prm_AppCode <> gn_def_OK THEN
            ROLLBACK;
            RETURN;
         END IF;
      END IF;

      UPDATE wsjb.IRAC01A3
         SET AAE110 = DECODE(var_aae140_01,'1','0',AAE110),
             AAE120 = DECODE(var_aae140_06,'1','0',AAE120),
             AAE210 = DECODE(var_aae140_02,'1','0',AAE210),
             AAE310 = DECODE(var_aae140_03,'1','0',AAE310),
             AAE410 = DECODE(var_aae140_04,'1','0',AAE410),
             AAE510 = DECODE(var_aae140_05,'1','0',AAE510),
             AAE311 = DECODE(var_aae140_07,'1','0',AAE311),
             AAE810 = DECODE(var_aae140_08,'1','0',AAE810),
             AAC040 = rec_irac01.aac040,
             YAC004 = rec_irac01.yac004,
             YAC005 = rec_irac01.yac005
       WHERE AAC001 = rec_irac01.aac001
         AND AAB001 = rec_irac01.AAB001;



   EXCEPTION
      WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuAddCheckRollback;

   /*****************************************************************************
   ** �������� : prc_PersonInsuContinueRollback
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��Ա�������]����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuContinueRollback(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                        prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                        prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                        prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                        prm_aae013       IN    irac01.aae013%TYPE ,    --��ע
                                        prm_AppCode      OUT   VARCHAR2  ,    --�������
                                        prm_ErrMsg       OUT   VARCHAR2  )    --��������
   IS
      num_count       NUMBER;
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --���˱��
      var_aae140_01   VARCHAR2(2);         --�Ƿ�μ�����ҵ����
      var_aae140_06   VARCHAR2(2);         --�Ƿ�μ��˻�������
      var_aae140_02   VARCHAR2(2);         --�Ƿ�μ���ʧҵ
      var_aae140_03   VARCHAR2(2);         --�Ƿ�μ��˻���ҽ��
      var_aae140_04   VARCHAR2(2);         --�Ƿ�μ��˹���
      var_aae140_05   VARCHAR2(2);         --�Ƿ�μ�������
      var_aae140_07   VARCHAR2(2);         --�Ƿ�μ��˴��
      var_aae140_08   VARCHAR2(2);
      rec_irac01      irac01%rowtype;

   BEGIN
      prm_AppCode  := PKG_Constant.GN_DEF_OK;
      prm_ErrMsg   := '';
      var_aac001   := '';

      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      var_aac001    := rec_irac01.aac001;        --��Ա���
      var_aae140_01 := rec_irac01.aae110;        --�Ƿ�μ�����ҵ����
      var_aae140_06 := rec_irac01.aae120;        --�Ƿ�μ��˻�������
      var_aae140_02 := rec_irac01.aae210;        --�Ƿ�μ���ʧҵ
      var_aae140_03 := rec_irac01.aae310;        --�Ƿ�μ��˻���ҽ��
      var_aae140_04 := rec_irac01.aae410;        --�Ƿ�μ��˹���
      var_aae140_05 := rec_irac01.aae510;        --�Ƿ�μ�������
      var_aae140_07 := rec_irac01.aae311;        --�Ƿ�μ��˴��
      var_aae140_08 := rec_irac01.aae810;

      IF var_aae140_06 = '1' OR var_aae140_02 = '1'
      OR var_aae140_03 = '1' OR var_aae140_04 = '1'
      OR var_aae140_05 = '1' OR var_aae140_07 = '1' OR var_aae140_08 = '1'
      OR var_aae140_06 = '10' OR var_aae140_02 = '10'
      OR var_aae140_03 = '10' OR var_aae140_04 = '10'
      OR var_aae140_05 = '10' OR var_aae140_07 = '10' OR var_aae140_08 = '10' THEN
          XASI2.pkg_gx_RollBack.prc_P_PersorContinuRollBack(prm_yae099,
                                                             var_aac001,
                                                             prm_aae011,
                                                             prm_yab003,
                                                             prm_aae013,
                                                             prm_AppCode,
                                                             prm_ErrMsg);
         IF prm_AppCode <> gn_def_OK THEN
            ROLLBACK;
            RETURN;
         END IF;
      END IF;

      UPDATE IRAC01A3
         SET AAE110 = DECODE(var_aae140_01,'1','0','10','21',AAE110),
             AAE120 = DECODE(var_aae140_06,'1','0','10','21',AAE120),
             AAE210 = DECODE(var_aae140_02,'1','0','10','21',AAE210),
             AAE310 = DECODE(var_aae140_03,'1','0','10','21',AAE310),
             AAE410 = DECODE(var_aae140_04,'1','0','10','21',AAE410),
             AAE510 = DECODE(var_aae140_05,'1','0','10','21',AAE510),
             AAE311 = DECODE(var_aae140_07,'1','0','10','21',AAE311),
             AAE810 = DECODE(var_aae140_08,'1','0','10','21',AAE810)
       WHERE AAC001 = rec_irac01.aac001
         AND AAB001 = rec_irac01.AAB001;

   EXCEPTION
      WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuContinueRollback;

   /*****************************************************************************
   ** �������� : prc_PersonInsuPauseRollback
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��Աͣ�����]����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuPauseRollback(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                    prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                    prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                    prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                    prm_aae013       IN    irac01.aae013%TYPE ,    --��ע
                                    prm_AppCode      OUT   VARCHAR2  ,    --�������
                                    prm_ErrMsg       OUT   VARCHAR2  )    --��������
   IS
      num_count       NUMBER;
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --���˱��
      var_aae140_01   VARCHAR2(2);         --�Ƿ�μ�����ҵ����
      var_aae140_06   VARCHAR2(2);         --�Ƿ�μ��˻�������
      var_aae140_02   VARCHAR2(2);         --�Ƿ�μ���ʧҵ
      var_aae140_03   VARCHAR2(2);         --�Ƿ�μ��˻���ҽ��
      var_aae140_04   VARCHAR2(2);         --�Ƿ�μ��˹���
      var_aae140_05   VARCHAR2(2);         --�Ƿ�μ�������
      var_aae140_07   VARCHAR2(2);         --�Ƿ�μ��˴��
      var_aae140_08   VARCHAR2(2);
      rec_irac01      irac01%rowtype;

   BEGIN
      prm_AppCode  := PKG_Constant.GN_DEF_OK;
      prm_ErrMsg   := '';
      var_aac001   := '';

      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      var_aac001    := rec_irac01.aac001;
      var_aae140_01 := rec_irac01.aae110;        --�Ƿ�μ�����ҵ����
      var_aae140_06 := rec_irac01.aae120;        --�Ƿ�μ��˻�������
      var_aae140_02 := rec_irac01.aae210;        --�Ƿ�μ���ʧҵ
      var_aae140_03 := rec_irac01.aae310;        --�Ƿ�μ��˻���ҽ��
      var_aae140_04 := rec_irac01.aae410;        --�Ƿ�μ��˹���
      var_aae140_05 := rec_irac01.aae510;        --�Ƿ�μ�������
      var_aae140_07 := rec_irac01.aae311;        --�Ƿ�μ��˴��
      var_aae140_08 := rec_irac01.aae810;

      IF var_aae140_06 = '3' OR var_aae140_02 = '3'
      OR var_aae140_03 = '3' OR var_aae140_04 = '3'
      OR var_aae140_05 = '3' OR var_aae140_07 = '3'
      OR var_aae140_08 = '3' THEN
         XASI2.pkg_gx_RollBack.prc_P_PersorSuspensionRollBack(prm_yae099,
                                                                var_aac001,
                                                                prm_aae011,
                                                                prm_yab003,
                                                                prm_aae013,
                                                                prm_AppCode,
                                                                prm_ErrMsg);
         IF prm_AppCode <> gn_def_OK THEN
            ROLLBACK;
            RETURN;
         END IF;
      END IF;

      UPDATE wsjb.IRAC01A3
         SET AAE110 = DECODE(var_aae140_01,'3','2',AAE110),
             AAE120 = DECODE(var_aae140_06,'3','2',AAE120),
             AAE210 = DECODE(var_aae140_02,'3','2',AAE210),
             AAE310 = DECODE(var_aae140_03,'3','2',AAE310),
             AAE410 = DECODE(var_aae140_04,'3','2',AAE410),
             AAE510 = DECODE(var_aae140_05,'3','2',AAE510),
             AAE311 = DECODE(var_aae140_07,'3','2',AAE311),
             AAE810 = DECODE(var_aae140_08,'3','2',AAE810)
       WHERE AAC001 = rec_irac01.aac001
         AND AAB001 = rec_irac01.AAB001;

   EXCEPTION
      WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuPauseRollback;

   /*****************************************************************************
   ** �������� : prc_PersonInsuToRetireRollback
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��ְת�������]����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuToRetireRollback(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                                        prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                                        prm_aae011       IN    irac01.aae011%TYPE ,    --������
                                        prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                                        prm_aae013       IN    irac01.aae013%TYPE ,    --��ע
                                        prm_AppCode      OUT   VARCHAR2  ,    --�������
                                        prm_ErrMsg       OUT   VARCHAR2  )    --��������
   IS
      num_count       NUMBER;
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --���˱��
   BEGIN
      prm_AppCode  := PKG_Constant.GN_DEF_OK;
      prm_ErrMsg   := '';
      var_aac001   := '';

   EXCEPTION
      WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuToRetireRollback;

   /*****************************************************************************
   ** �������� : prc_RollBackAMIRPer
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ���������걨���[������Ϣ���� ͣ��]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aac001       IN     irac01.aac001%TYPE,--��Ա���
   **           prm_yea099       IN     ae02a2.yae099%TYPE,--ҵ����ˮ��
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-06   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_RollBackAMIRPer (
      prm_iac001       IN     irac01.iac001%TYPE,--�걨��Ա���
      prm_yae099       IN     xasi2.ac02a2.yae099%TYPE,--ҵ����ˮ��
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      --�����α꣬��ȡ��ͣ�ɷ���Ա����Ϣ
      CURSOR cur_pause_aae140 IS
      SELECT a.AAC001, --���˱��,VARCHAR2
             b.AAB001, --��λ���,VARCHAR2
             a.AAE140  --����    ,VARCHAR2
        FROM xasi2.AC02A2 a,wsjb.IRAC01  b  --�α���Ϣ��
       WHERE a.AAC001 = b.aac001
         AND b.iac001 = prm_iac001
         AND a.yae099 = prm_yae099
         AND a.AAC031 = PKG_Constant.AAC031_CBJF;
   BEGIN

      prm_AppCode := PKG_Constant.gn_def_OK ;
      prm_ErrorMsg:= '';

      IF prm_yae099 IS NULL THEN
         prm_AppCode := gn_def_ERR;
         prm_ErrorMsg  := 'ҵ����ˮ�Ų���Ϊ�գ�';
         RETURN;
      END IF;

      IF prm_iac001 IS NULL THEN
         prm_AppCode := gn_def_ERR;
         prm_ErrorMsg  := '�걨��Ա��Ų���Ϊ�գ�';
         RETURN;
      END IF;

      FOR rec_pause_aae140 in cur_pause_aae140 LOOP
         --����ͣ����Ϣ
         UPDATE xasi2.AC02
             SET (AC02.yae102,
                  AC02.aac031
                 ) =
            (SELECT  B.yae102,
                     B.aac031
                FROM xasi2.AC02A2 B
               WHERE B.aae140 = AC02.aae140
                 AND B.aac001 = AC02.aac001)
          WHERE EXISTS (SELECT 1
                    FROM xasi2.AC02A2 T
                   WHERE T.aac001 = AC02.aac001
                     and T.aae140 = AC02.aae140
                     AND T.aae140 = rec_pause_aae140.aae140
                     AND T.aac001 = rec_pause_aae140.AAC001
                     and T.yae099 = prm_yae099);
         --�����¼���Ϣ
         DELETE
           FROM xasi2.AC05
          WHERE aae140 = rec_pause_aae140.aae140
            AND aac001 = rec_pause_aae140.AAC001
            AND yae099 = prm_yae099;

         --���˵�λ��Ա������Ϣ
         IF rec_pause_aae140.aae140 = PKG_Constant.AAE140_JBYL THEN
            UPDATE wsjb.IRAC01A3
               SET AAE310 = '2'
             WHERE AAB001 = rec_pause_aae140.aab001
               AND AAC001 = rec_pause_aae140.AAC001;
         END IF;
         IF rec_pause_aae140.aae140 = PKG_Constant.AAE140_SYE THEN
            UPDATE wsjb.IRAC01A3
               SET AAE210 = '2'
             WHERE AAB001 = rec_pause_aae140.aab001
               AND AAC001 = rec_pause_aae140.AAC001;
         END IF;
         IF rec_pause_aae140.aae140 = PKG_Constant.AAE140_GS THEN
            UPDATE wsjb.IRAC01A3
               SET AAE410 = '2'
             WHERE AAB001 = rec_pause_aae140.aab001
               AND AAC001 = rec_pause_aae140.AAC001;
         END IF;
         IF rec_pause_aae140.aae140 = PKG_Constant.AAE140_SYU THEN
            UPDATE wsjb.IRAC01A3
               SET AAE510 = '2'
             WHERE AAB001 = rec_pause_aae140.aab001
               AND AAC001 = rec_pause_aae140.AAC001;
         END IF;
         IF rec_pause_aae140.aae140 = PKG_Constant.AAE140_DEYL THEN
            UPDATE wsjb.IRAC01A3
               SET AAE311 = '2'
             WHERE AAB001 = rec_pause_aae140.aab001
               AND AAC001 = rec_pause_aae140.AAC001;
         END IF;
         IF rec_pause_aae140.aae140 = PKG_Constant.AAE140_JGYL THEN
            UPDATE wsjb.IRAC01A3
               SET AAE120 = '2'
             WHERE AAB001 = rec_pause_aae140.aab001
               AND AAC001 = rec_pause_aae140.AAC001;
         END IF;
      END LOOP;
   EXCEPTION
      WHEN OTHERS THEN
      /*�رմ򿪵��α�*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '���ݿ����:'|| SQLERRM||dbms_utility.format_error_backtrace  ;
      RETURN;
   END prc_RollBackAMIRPer;

   /*****************************************************************************
   ** �������� : prc_ResetASMR
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ���������걨���
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
   PROCEDURE prc_ResetASMR (
      prm_aab001       IN     irab01.aab001%TYPE,--��λ���
      prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
      prm_aae011       IN     irad31.aae011%TYPE,--������
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum     NUMBER;
      v_msg        VARCHAR2(200);
      var_aaz002   VARCHAR2(15);
      --��Ҫ���õ��걨����
      CURSOR personCur IS
      SELECT c.iaz004,
             c.iaz005,
             c.iaz007,
             c.iaz008,
             c.iad003,
             c.iaa020
        FROM wsjb.ae02  a,wsjb.irad01  b,wsjb.irad02  c
       WHERE a.aaz002 = b.aaz002
         AND b.iaz004 = c.iaz004
         AND a.aaa121 = PKG_Constant.aaa121_MIR
         AND b.aab001 = prm_aab001
         AND b.iaa100 = prm_iaa100;

      --��Ҫ���õ��������
      CURSOR irad21Cur IS
      SELECT distinct a.aaz002
        FROM wsjb.ae02  a,wsjb.irad22  c,wsjb.irad01  e,wsjb.irad02  d,wsjb.irad21  b
       WHERE a.aaz002 = b.aaz002
         AND b.iaz009 = c.iaz009
         AND c.iaz005 = d.iaz005
         AND e.iaz004 = d.iaz004
         AND b.iaa011 = PKG_Constant.IAA011_MIR
         AND a.aaa121 = PKG_Constant.aaa121_MIA
         AND e.aab001 = prm_aab001
         AND e.iaa100 = prm_iaa100;
   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      v_msg    := NULL;
      countnum := 0;
      -- ���ab08�Ƿ�������
      SELECT count(1)
        INTO countnum
        FROM xasi2.ab08 a
       WHERE a.aab001 = prm_aab001
         AND a.aae003 = prm_iaa100
         AND a.yae517 = 'H01';
      IF countnum > 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '��ǰ�籣�����뵥λ���к˶����ݣ���������!';
         RETURN;
      END IF;

      -- ���irab08�Ƿ�������
      SELECT count(1)
        INTO countnum
        FROM wsjb.irab08  a
       WHERE a.aab001 = prm_aab001
         AND a.aae003 = prm_iaa100
         AND a.yae517 = 'H01';
      IF countnum > 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '��ǰ�籣�����뵥λ�������Ϻ˶����ݣ���������!';
         RETURN;
      END IF;



      --����Ƿ������������
      SELECT count(1)
        INTO countnum
        FROM wsjb.ae02  a,wsjb.irad01  b,wsjb.irad02  c
       WHERE a.aaz002 = b.aaz002
         AND b.iaz004 = c.iaz004
         AND a.aaa121 = PKG_Constant.aaa121_MIR
         AND b.aab001 = prm_aab001
         AND b.iaa100 = prm_iaa100;
      IF countnum = 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '��ǰ�籣�����뵥λ���������걨���ݣ���������!';
         RETURN;
      END IF;

      --����Ƿ������˼�¼
      SELECT count(1)
        INTO countnum
        FROM wsjb.ae02  a,wsjb.irad22  c,wsjb.irad01  e,wsjb.irad02  d,wsjb.irad21  b
       WHERE a.aaz002 = b.aaz002
         AND b.iaz009 = c.iaz009
         AND c.iaz005 = d.iaz005
         AND e.iaz004 = d.iaz004
         AND b.iaa011 = PKG_Constant.IAA011_MIR
         AND a.aaa121 = PKG_Constant.aaa121_MIA
         AND e.aab001 = prm_aab001
         AND e.iaa100 = prm_iaa100;





      --����˼�¼�������������
      IF countnum > 0 THEN
         FOR rec_irad21 in irad21Cur LOOP
             prc_RollBackAMIR(rec_irad21.aaz002,--���ҵ����־
                              prm_iaa100       ,--�걨�¶�
                              prm_aab001       ,--�걨��λ
                              prm_aae011       ,--������
                              prm_AppCode      ,
                              prm_ErrorMsg
                              );
             IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                RETURN;
             END IF;
         END LOOP;
      END IF;

      --������������Ա��Ϣ
      DELETE
        FROM wsjb.IRAC01
       WHERE aab001 = prm_aab001
         AND iaa100 = prm_iaa100
         AND iaa001 = PKG_Constant.IAA001_GEN;

      --�����걨����
      FOR rec_person in personCur LOOP
         IF rec_person.iaa020 = PKG_Constant.IAA020_GR THEN
            --�����걨��Ϣ״̬
            UPDATE wsjb.IRAC01
               SET iaa002 = PKG_Constant.IAA002_WIR,
                   iaa100 = NULL
             WHERE IAC001 = rec_person.iaz007;
         END IF;
         --�����걨��ϸ
         DELETE
           FROM wsjb.IRAD02
          WHERE IAZ005 = rec_person.iaz005;
      END LOOP;

      SELECT aaz002
        INTO var_aaz002
        FROM wsjb.IRAD01
       WHERE aab001 = prm_aab001
         AND iaa100 = prm_iaa100
         AND iaa011 = PKG_Constant.IAA011_MIR;

      --�����걨�¼�
      DELETE
        FROM wsjb.IRAD01
       WHERE aab001 = prm_aab001
         AND iaa100 = prm_iaa100
         AND iaa011 = PKG_Constant.IAA011_MIR;

      DELETE
        FROM wsjb.AE02  a
       WHERE a.AAA121 = PKG_Constant.AAA121_MIR
         AND a.aaz002 = var_aaz002
         AND EXISTS (SELECT yae092
                       FROM wsjb.IRAA01
                      WHERE yae092 = a.aae011
                        AND aab001 = prm_aab001
                    );

   EXCEPTION
      WHEN OTHERS THEN
      /*�رմ򿪵��α�*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
      RETURN;
   END prc_ResetASMR;


   /*****************************************************************************
   ** �������� : prc_UnitInfoMaintainAuditRollback
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����˵�λ��Ϣά�����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE  ,--��λ���
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-011   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_UnitInfoAuditRollback (
      prm_aab001       IN     irab01.aab001%TYPE,  --��λ���
      prm_iab001       IN     irab01.iab001%TYPE,  --��λ��Ϣ���
      prm_iaz005       IN     irad02.iaz005%TYPE,  --�걨��ϸID
      prm_iaz009       IN     irad21.iaz009%TYPE,  --����¼�ID
      prm_iaz012       IN     irad32.iaz012%TYPE,  --�޸��¼�ID
      prm_iaa002       IN     irab01.iaa002%TYPE,  --��˽��
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      n_count    number(2);
      v_iaz004   varchar2(15);
      v_iaz003   varchar2(15);
      v_aaz002   varchar2(15);
      str_sql2   varchar2(500);
      str_sql    varchar2(500);
      cursor c_cur  IS SELECT iad004,iad006,iad008,iad009 FROM IRAD32 where iaz012 = prm_iaz012 and iaz008 = prm_aab001 and aae100 = '1';
   BEGIN

      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;

      /*��Ҫ������У��*/
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λ�����벻��Ϊ��!';
         RETURN;
      END IF;

      IF prm_iab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λ��Ϣ��Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaz005 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�걨��ϸID����Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa002 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��˽������Ϊ��!';
         RETURN;
      END IF;

       --�Ƿ������˼�¼
       SELECT COUNT(1) INTO n_count FROM
        wsjb.IRAD22  a WHERE a.iaz005 = prm_iaz005;
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := 'û���ҵ���Ӧ�������Ϣ������';
        RETURN;
       END IF;

       --�Ƿ�����걨��Ϣ
       SELECT COUNT(1) INTO n_count FROM
        wsjb.IRAD02  a WHERE a.iaz005 = prm_iaz005;
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := 'û���ҵ���Ӧ���걨��Ϣ������';
        RETURN;
       END IF;

       --�Ƿ�����޸���Ϣ
       SELECT COUNT(1) INTO n_count FROM
        wsjb.IRAD32  a WHERE a.iaz012 = prm_iaz012 and a.aae100 = '1';
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := 'û���ҵ���Ӧ���޸���ϸ��Ϣ������';
        RETURN;
       END IF;

       --�Ƿ���ڵ�λ�걨��Ϣ
       SELECT COUNT(1) INTO n_count FROM
        wsjb.IRAB01  a WHERE a.iab001 = prm_iab001;
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := 'û���ҵ���Ӧ�ĵ�λ�걨��Ϣ������';
        RETURN;
       END IF;

       --�Ƿ���ڵ�λ��Ϣ
       SELECT COUNT(1) INTO n_count FROM
        xasi2.AB01 a WHERE a.aab001 = prm_aab001;
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := 'û���ҵ���Ӧ�ĵ�λ��Ϣ������';
        RETURN;
       END IF;

       /*��ȡ������Ϣ*/
       --�걨���κ�
       SELECT iaz004
       into v_iaz004
       From wsjb.IRAD02
       where iaz005 = prm_iaz005;


       --������˽�����л���
       IF prm_iaa002 = '2' THEN
        --ƴ�Ӹ����ַ���
        str_sql := 'UPDATE AB01 SET aab001='''||prm_aab001||'''';
        str_sql2 := 'UPDATE wsjb.IRAB01  SET aab001='''||prm_aab001||'''';

        for c_row in c_cur LOOP

          str_sql2 := str_sql2||','||c_row.iad006||' = '''||c_row.iad008||'''';

          IF c_row.iad006 != 'YAB028' and c_row.iad006 != 'YAB009' and c_row.iad006 != 'YAB006' THEN

            str_sql := str_sql||','||c_row.iad006||' = '''||c_row.iad008||'''';

            IF c_row.iad006 = 'YLB001' THEN
              UPDATE xasi2.AB02 SET
                   aaa040 = '040'||c_row.iad008
                   where aab001 = prm_aab001
                   and aae140 = '04'
                   and aab051 = '1';
            END IF;

          ELSIF c_row.iad006 = 'YAB028' THEN

            UPDATE xasi2.AB01A7 SET
                   yab028 = c_row.iad008
                   where aab001 = prm_aab001;

          END IF;

        END LOOP;

        str_sql := str_sql||' where aab001 = '''||prm_aab001||'''';
        str_sql2 := str_sql2||' where iab001 = '||'
        (SELECT iab001 FROM wsjb.IRAB01  a,wsjb.AE02  b
        where a.aaz002 = b.aaz002 and b.aaa121 = '''||PKG_Constant.AAA121_NER||'''
        and a.aab001 = '''||prm_aab001||''')';

        EXECUTE IMMEDIATE str_sql ;
        EXECUTE IMMEDIATE str_sql2 ;

       END IF;

       --����IRAD41������
      BEGIN

      SELECT a.iaz003 INTO v_iaz003 FROM IRAD41 a
      where a.iaz004 = v_iaz004 and a.iaa012 = PKG_Constant.IAA012_ODW;

      UPDATE wsjb.IRAD41  SET
            iaa012 = PKG_Constant.IAA012_IDW,
            aae036 = null,
            aae013 = null
      WHERE
            iaz003 = v_iaz003;

      EXCEPTION
       WHEN NO_DATA_FOUND THEN
       null;
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := 'ԤԼ��Ϣ���ִ��󣡣���'|| SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;
      END;

       --����IRAD02�걨��ϸ��
       UPDATE wsjb.IRAD02  SET
            iaa015 = PKG_Constant.IAA015_WAD,
            aae013 = null
       WHERE
            iaz005 = prm_iaz005;

       --����IRAD01
       UPDATE wsjb.IRAD01  SET
             aae013 = null
       WHERE
             iaz004 = v_iaz004;

       --����IRAB01
       UPDATE wsjb.IRAB01  SET
            iaa002 = PKG_Constant.IAA002_AIR
       WHERE
            iab001 = prm_iab001;

       --����IRAD31
       UPDATE wsjb.IRAD31  SET
            iaa019 = PKG_Constant.IAA019_IR
       WHERE
            iaz007 = prm_iab001
            and iaa011 = PKG_Constant.IAA011_EIM
            and iaa019 = PKG_Constant.IAA019_AD;

       --ɾ����˼�¼�������ϸ
       SELECT aaz002
       into v_aaz002
       FROM wsjb.irad21  where iaz009 = prm_iaz009;

       DELETE FROM wsjb.IRAD22
       WHERE iaz009 = prm_iaz009;

       DELETE FROM wsjb.IRAD21
       WHERE iaz009 = prm_iaz009;

       --ɾ����־
       DELETE FROM wsjb.AE02
       WHERE aaz002 = v_aaz002;

   EXCEPTION
      WHEN OTHERS THEN
      /*�رմ򿪵��α�*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
      RETURN;
   END prc_UnitInfoAuditRollback;


    /*****************************************************************************
   ** �������� : prc_PersonInfoAuditRollback
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����˸�����Ϣά�����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aac001       IN     irab01.aab001%TYPE  ,--���˱��
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-011   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInfoAuditRollback (
      prm_aac001       IN     irac01.aac001%TYPE,  --���˱��
      prm_iac001       IN     irac01.iac001%TYPE,  --������Ϣ���
      prm_iaz005       IN     irad02.iaz005%TYPE,  --�걨��ϸID
      prm_iaz009       IN     irad21.iaz009%TYPE,  --����¼�ID
      prm_iaz012       IN     irad32.iaz012%TYPE,  --�޸��¼�ID
      prm_iaa002       IN     irab01.iaa002%TYPE,  --��˽��
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      n_count    number(2);
      v_iaz004   varchar2(15);
      v_aab001   varchar2(15);
      v_iaz003   varchar2(15);
      v_aaz002   varchar2(15);
      v_yac168   varchar2(2);
      str_sql    varchar2(500);
      str_sql2   varchar2(500);
      str_sql3   varchar2(500);
      cursor c_cur  IS SELECT iad004,iad006,iad008,iad009 FROM IRAD32 where iaz012 = prm_iaz012 and iaz008 = prm_aac001 and aae100 = '1';
   BEGIN

      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;

      /*��Ҫ������У��*/
      IF prm_aac001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���˱�Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_iac001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '������Ϣ��Ų���Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaz005 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�걨��ϸID����Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa002 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��˽������Ϊ��!';
         RETURN;
      END IF;

       --�Ƿ������˼�¼
       SELECT COUNT(1) INTO n_count FROM
        wsjb.IRAD22  a WHERE a.iaz005 = prm_iaz005;
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := 'û���ҵ���Ӧ�������Ϣ������';
        RETURN;
       END IF;

       --�Ƿ�����걨��Ϣ
       SELECT COUNT(1) INTO n_count FROM
        wsjb.IRAD02  a WHERE a.iaz005 = prm_iaz005;
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := 'û���ҵ���Ӧ���걨��Ϣ������';
        RETURN;
       END IF;

       --�Ƿ�����޸���Ϣ
       SELECT COUNT(1) INTO n_count FROM
        wsjb.IRAD32 a WHERE a.iaz012 = prm_iaz012 and a.aae100 = '1';
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := 'û���ҵ���Ӧ���޸���ϸ��Ϣ������';
        RETURN;
       END IF;

       --�Ƿ���ڸ����걨��Ϣ
       SELECT COUNT(1) INTO n_count FROM
         wsjb.irac01  a WHERE a.iac001 = prm_iac001;
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := 'û���ҵ���Ӧ�ĵ�λ�걨��Ϣ������';
        RETURN;
       END IF;

       --�Ƿ���ڸ�����Ϣ
       SELECT COUNT(1) INTO n_count FROM
        xasi2.AC01 a WHERE a.aac001 = prm_aac001;
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := 'û���ҵ���Ӧ�ĸ�����Ϣ������';
        RETURN;
       END IF;

       /*��ȡ������Ϣ*/
       --�걨���κ�
       SELECT iaz004
       into v_iaz004
       From wsjb.IRAD02
       where iaz005 = prm_iaz005;

       --��λ���
       SELECT aab001
       into v_aab001
       From wsjb.IRAC01
       where iac001 = prm_iac001;


       --������˽�����л���
       IF prm_iaa002 = '2' THEN
        --ƴ�Ӹ����ַ���
        str_sql := 'UPDATE AC01 SET aac001='''||prm_aac001||'''';

        str_sql2 := 'Update Irac01A3 Set aac001='''||prm_aac001||'''';

        str_sql3 := 'Update wsjb.irac01  Set aac001='''||prm_aac001||'''';

        for c_row in c_cur LOOP

          IF c_row.iad006 = 'AAC006' OR c_row.iad006 = 'AAC007' THEN

            str_sql := str_sql||','||c_row.iad006||' = to_date('''||c_row.iad008||''',''yyyy-mm-dd'')';

            str_sql2 := str_sql2||','||c_row.iad006||' = to_date('''||c_row.iad008||''',''yyyy-mm-dd'')';

          ELSIF c_row.iad006 = 'AAC003' OR c_row.iad006 = 'AAC002' OR c_row.iad006 = 'AAC004' OR c_row.iad006 = 'AAC006' OR c_row.iad006 = 'YAE181' THEN
            str_sql := str_sql||','||c_row.iad006||' = '''||c_row.iad008||'''';

            str_sql2 := str_sql2||','||c_row.iad006||' = '''||c_row.iad008||'''';

            str_sql3 := str_sql3||','||c_row.iad006||' = '''||c_row.iad008||'''';
          ELSE

            str_sql := str_sql||','||c_row.iad006||' = '''||c_row.iad008||'''';

            str_sql2 := str_sql2||','||c_row.iad006||' = '''||c_row.iad008||'''';

          END IF;

        END LOOP;

        str_sql := str_sql||' where aac001 = '''||prm_aac001||'''';
        str_sql2 := str_sql2||' where aac001 = '''||prm_aac001||''' and aab001 = '''||v_aab001||'''';
        str_sql3 := str_sql3||' where aac001 = '''||prm_aac001||''' and aab001 = '''||v_aab001||'''and iaa001 <> ''4''';

        EXECUTE IMMEDIATE str_sql ;
        EXECUTE IMMEDIATE str_sql2 ;
        EXECUTE IMMEDIATE str_sql3 ;

       END IF;

       --����IRAD41������
      BEGIN

      SELECT a.iaz003 INTO v_iaz003 FROM IRAD41 a
      where a.iaz004 = v_iaz004 and a.iaa012 = PKG_Constant.IAA012_ODW;

      UPDATE wsjb.IRAD41  SET
            iaa012 = PKG_Constant.IAA012_IDW,
            aae036 = null,
            aae013 = null
      WHERE
            iaz003 = v_iaz003;

      EXCEPTION
       WHEN NO_DATA_FOUND THEN
       null;
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := 'ԤԼ��Ϣ���ִ��󣡣���'|| SQLERRM||dbms_utility.format_error_backtrace  ;
         RETURN;
      END;

      BEGIN
        SELECT A.YAC168
              INTO v_yac168
              FROM xasi2.AC01 A WHERE A.AAC001 = prm_aac001;

        IF v_yac168 = PKG_Constant.YAC168_F THEN

            UPDATE xasi2.AC02 a SET
              a.yac505 = PKG_Constant.YAC505_SYEPT
            WHERE
                a.aac031 = PKG_Constant.AAC031_CBJF
                and a.aae140 = PKG_Constant.AAE140_SYE
                and a.aac001 = prm_aac001;

          ELSIF v_yac168 = PKG_Constant.YAC168_S THEN

            UPDATE xasi2.AC02 a SET
              a.yac505 = PKG_Constant.YAC505_SYENMG
            WHERE
                a.aac031 = PKG_Constant.AAC031_CBJF
                and a.aae140 = PKG_Constant.AAE140_SYE
                and a.aac001 = prm_aac001;

          END IF;

          EXCEPTION
           WHEN NO_DATA_FOUND THEN
            ROLLBACK;
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := 'ũ�񹤱�־Ϊ�գ�����'|| SQLERRM||dbms_utility.format_error_backtrace  ;
             RETURN;
          -- WHEN TOO_MANY_ROWS THEN
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
             /*�رմ򿪵��α�*/
             ROLLBACK;
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := 'ũ�񹤱�־���ִ��󣡣���'|| SQLERRM ||dbms_utility.format_error_backtrace ;
             RETURN;
       END;

       --����IRAD02�걨��ϸ��
       UPDATE wsjb.IRAD02  SET
            iaa015 = PKG_Constant.IAA015_WAD,
            aae013 = null
       WHERE
            iaz005 = prm_iaz005;

       --����IRAD01
       UPDATE wsjb.IRAD01  SET
             aae013 = null
       WHERE
             iaz004 = v_iaz004;

       --����IRAC01
       UPDATE wsjb.IRAC01  SET
            iaa002 = PKG_Constant.IAA002_AIR
       WHERE
            iac001 = prm_iac001;

       --����IRAD31
       UPDATE wsjb.IRAD31  SET
            iaa019 = PKG_Constant.IAA019_IR
       WHERE
            iaz007 = prm_iac001
            and iaa011 = PKG_Constant.IAA011_PIM
            and iaa019 = PKG_Constant.IAA019_AD;

       --ɾ����˼�¼�������ϸ
       SELECT aaz002
       into v_aaz002
       FROM wsjb.irad21  where iaz009 = prm_iaz009;

       DELETE FROM wsjb.IRAD22
       WHERE iaz009 = prm_iaz009;

       DELETE FROM wsjb.IRAD21
       WHERE iaz009 = prm_iaz009;

       --ɾ����־
       DELETE FROM wsjb.AE02
       WHERE aaz002 = v_aaz002;

   EXCEPTION
      WHEN OTHERS THEN
      /*�رմ򿪵��α�*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
      RETURN;
   END prc_PersonInfoAuditRollback;

   /*****************************************************************************
   ** �������� : FUN_GETAAB001C
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����ȡ�籣������
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab020       IN     irab01.aab001%TYPE  ,--���˱��
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-011   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
  /*��ȡ�籣������*/
 PROCEDURE prc_GETAAB001C(prm_aab020     IN     irab01.aab020%TYPE,--��������
                          prm_yab006     IN     irab01.yab006%TYPE,--˰�����
                          prm_aab001     OUT    VARCHAR2,          --��λ���
                          prm_AppCode    OUT    VARCHAR2  ,
                          prm_ErrorMsg   OUT    VARCHAR2 )
  IS
     str_Prefixion    VARCHAR2(2);
     str_Sequence     VARCHAR2(20);
     v_aab001         VARCHAR2(15);
     str_name         VARCHAR2(20);
  BEGIN

    /*��ʼ������*/
    prm_AppCode  := gn_def_OK;
    prm_ErrorMsg := '';
    prm_aab001 := '';

    --��һ�� ǰ׺'0' ���� ���С����ж���
    IF prm_aab020 IN ('110','151') THEN
       str_Prefixion :='0';
       str_name :='SEQ_0_AAB001';
    END IF;
    --���� ǰ׺ '1' ���� ������ҵ
    IF prm_aab020 = '120' THEN
       str_Prefixion :='1';
       str_name :='SEQ_1_AAB001';
    END IF;
    --������ ǰ׺ '2'��'4'��'5'��'6'��'7' ��λ���� ���� �ɷݡ�˽Ӫ��������
    IF prm_aab020 IN ('130','140','141','142','143','149','150','159','160','170','171','172','173','174','190') THEN
       BEGIN
         str_Prefixion :='2';
         str_name :='SEQ_2_AAB001';
         EXECUTE IMMEDIATE 'SELECT '||str_name||'.NEXTVAL FROM DUAL'
         INTO v_aab001;
          EXCEPTION
             WHEN OTHERS THEN
             IF LENGTH(v_aab001) > 4 OR v_aab001 IS NULL THEN --���ǰ׺'2'�ĺ���λ���� ��ʹ��ǰ׺Ϊ'5'�����к� 20141217 zhujing
                BEGIN
                  str_Prefixion :='5';
                  str_name :='SEQ_5_AAB001';
                  EXECUTE IMMEDIATE 'SELECT '||str_name||'.NEXTVAL FROM DUAL'
                  INTO v_aab001;
                  EXCEPTION
                     WHEN OTHERS THEN
                     IF LENGTH(v_aab001) > 4 OR v_aab001 IS NULL THEN
                         str_Prefixion :='4';
                         str_name :='SEQ_4_AAB001';
                         EXECUTE IMMEDIATE 'SELECT '||str_name||'.NEXTVAL FROM DUAL'
                         INTO v_aab001;
                      END IF;
                END ;

             END IF;
       END;
       IF LENGTH(v_aab001) > 4 OR v_aab001 IS NULL THEN --���ǰ׺'2'�ĺ���λ���� ��ʹ��ǰ׺Ϊ'5'�����к� 20141217 zhujing
                BEGIN
                  str_Prefixion :='5';
                  str_name :='SEQ_5_AAB001';
                  EXECUTE IMMEDIATE 'SELECT '||str_name||'.NEXTVAL FROM DUAL'
                  INTO v_aab001;
                  EXCEPTION
                     WHEN OTHERS THEN
                     IF LENGTH(v_aab001) > 4 OR v_aab001 IS NULL THEN
                         str_Prefixion :='4';
                         str_name :='SEQ_4_AAB001';
                         EXECUTE IMMEDIATE 'SELECT '||str_name||'.NEXTVAL FROM DUAL'
                         INTO v_aab001;
                      END IF;
                END ;

        END IF;

       --ֱ�ӽ����кŷ���
       str_Sequence := '00000'||v_aab001;--��λ��4λ��
       v_aab001 := SUBSTR(str_Sequence,LENGTH(str_Sequence)-3,4);
       v_aab001 := str_Prefixion || v_aab001;
       prm_aab001 := v_aab001;
       RETURN;
    END IF;
    --������ ǰ׺'3' ���� �۰�̨���������,���ʵ�
    IF prm_aab020 IN('200','210','220','230','240','300','310','320','330','340') THEN
       str_Prefixion :='3';
       str_name :='SEQ_3_AAB001';
    END IF;
    --������ ǰ׺'8' ��������ί��
    IF prm_aab020 = '800' THEN
       str_Prefixion :='8';
       str_name :='SEQ_8_AAB001';
    END IF;
    --������ ǰ׺'9' �����α���λ�Ͳα���
    IF prm_aab020 IN('100','175','179','290','390','900') THEN
       str_Prefixion :='9';
       str_name :='SEQ_9_AAB001';
    END IF;
    --������ ǰ׺'66' ��μ��ҵ��λ
    IF prm_aab020 = '701' THEN
       str_Prefixion :='66';
       str_name :='SEQ_6_AAB001';
    END IF;
    --�ڰ��� ǰ׺'72' ��μ���ص�λ
    IF prm_aab020 = '700' THEN
       str_Prefixion :='72';
       str_name :='SEQ_7_AAB001';
    END IF;

    EXECUTE IMMEDIATE 'SELECT '||str_name||'.NEXTVAL FROM DUAL'
     INTO v_aab001;

    --ֱ�ӽ����кŷ���
    str_Sequence := '00000'||v_aab001;--��λ��4λ��
    IF prm_aab020 IN('701','700') THEN
       v_aab001 := SUBSTR(str_Sequence,LENGTH(str_Sequence)-2,3);
    ELSE
       v_aab001 := SUBSTR(str_Sequence,LENGTH(str_Sequence)-3,4);
    END IF;

    v_aab001 := str_Prefixion || v_aab001;
    prm_aab001 := v_aab001;

   EXCEPTION
     -- WHEN NO_DATA_FOUND THEN
     -- WHEN TOO_MANY_ROWS THEN
     -- WHEN DUP_VAL_ON_INDEX THEN
     WHEN OTHERS THEN
       /*�رմ򿪵��α�*/
       ROLLBACK;
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '���ݿ����:'|| SQLERRM||dbms_utility.format_error_backtrace  ;
       RETURN;
   END prc_GETAAB001C;

   /*****************************************************************************
   ** �������� : FUN_GETAAB001
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����ȡ�籣������
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab020       IN     irab01.aab001%TYPE  ,--���˱��
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-011   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   /*��ȡ�籣������*/
   FUNCTION  FUN_GETAAB001 (prm_aab020     IN     irab01.aab020%TYPE, --��������
                            prm_yab006     IN     irab01.yab006%TYPE) --˰�����
   RETURN VARCHAR2
   IS
      n_count          NUMBER;
      v_aab001c        VARCHAR2(15);
      s_Appcode        VARCHAR2(12);
      s_Errormsg       VARCHAR2(200);
   BEGIN

      /*��ʼ������*/
      s_Appcode  := gn_def_OK;
      s_Errormsg := '';
      n_count    := 1;

      WHILE (n_count <> 0) LOOP
         PKG_Insurance.prc_GETAAB001C(prm_aab020,prm_yab006,v_aab001c,s_Appcode,s_Errormsg);
         if v_aab001c is null  then
            RETURN '';
         end if;
         SELECT count(1)
           INTO n_count
          FROM (SELECT AAB001
                  FROM wsjb.IRAB01
                 WHERE AAB001 = IAB001
                   and aab001 = v_aab001c
                UNION
                SELECT AAB001
                  FROM xasi2.AB01
                 WHERE AAB001 = v_aab001c
                UNION
                SELECT AAB001
                  FROM wsjb.IRAB01_BACK
                 WHERE AAB001 = v_aab001c) A;
      END LOOP;

      RETURN v_aab001c;

   EXCEPTION
     -- WHEN NO_DATA_FOUND THEN
     -- WHEN TOO_MANY_ROWS THEN
     -- WHEN DUP_VAL_ON_INDEX THEN
     WHEN OTHERS THEN
       /*�رմ򿪵��α�*/
       RETURN '';
   END FUN_GETAAB001;

   /*****************************************************************************
   ** �������� : prc_checkAndFinaPlan
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����λӦ�պ˶�������
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001     IN     irab01.aab001%TYPE,--��λ���
   **           prm_aae002     IN     ab08.aae003%TYPE,  --�ѿ�������
   **           prm_yae010     IN     aa05.yae010%TYPE,  --������Դ:��˰����
   **           prm_aae011     IN     ab08.aae011%TYPE,  --������Ա
   **           prm_yab003     IN     ab02.yab003%TYPE,  --�籣�������
   **           prm_flag       IN     VARCHAR2,          --�ύ��־ 0 �ύ 1���ύ
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-17   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   /*��λӦ�պ˶�������*/
   PROCEDURE prc_checkAndFinaPlan(prm_aab001     IN     irab01.aab001%TYPE,--��λ���
                                  prm_aae002     IN      xasi2.ab08.aae003%TYPE,  --�ѿ�������
                                  prm_yae010     IN      xasi2.aa05.yae010%TYPE,  --������Դ:��˰����
                                  prm_aae011     IN      xasi2.ab08.aae011%TYPE,  --������Ա
                                  prm_flag       IN     VARCHAR2,          --�ύ��־ 0 �ύ 1���ύ
                                  prm_AppCode    OUT    VARCHAR2  ,
                                  prm_ErrorMsg   OUT    VARCHAR2 )
   IS
      countnum    NUMBER;
      v_aab001    VARCHAR2(15);
      v_aab004    VARCHAR2(120);
      v_yae518    VARCHAR2(20);
      v_jobid     VARCHAR2(10);
      v_yab222    VARCHAR2(15);
      v_aae076    VARCHAR2(20);
      v_aac003    VARCHAR2(20);
      v_yae010_110    VARCHAR2(2);
      v_yae010_120    VARCHAR2(2);
      v_yae010_210    VARCHAR2(2);
      v_yae010_310    VARCHAR2(2);
      v_yae010_410    VARCHAR2(2);
      v_yae010_510    VARCHAR2(2);
      v_yae010_311    VARCHAR2(2);
      v_yae010_810    VARCHAR2(2);
      v_msg       VARCHAR2(2000);
      num_yac004  NUMBER;
      n_count     NUMBER(2);
      n_aab213    NUMBER(14,2);
      v_iaz004    VARCHAR2(15);
      var_YAE202 varchar2(20);
      var_iaz003 varchar2(15);
      var_iaa013  vARCHAR2(200);

--      CURSOR CUR_AC01A3
--      IS
--      SELECT A.AAC001,
--             A.AAB001,
--             A.AAC040,
--             A.AAC002,
--             NVL(A.YAC503,0) YAC503,
--             B.YAB136,
--             '01' AAE140
--        FROM IRAC01 A,IRAB01 B
--       WHERE A.AAB001 = B.AAB001
--         AND B.AAB001 = B.IAB001
--         AND B.AAB001 = NVL(prm_aab001,v_aab001)
--         AND A.iaa001 in('1','2','5','6','8')
--         AND A.aae110 in('1','2','10')
--         AND A.iaa002 = PKG_Constant.IAA002_APS
--         AND A.YAC004 IS NULL;
      CURSOR CUR_AC01A3
      IS
      SELECT A.AAC001,
             A.AAB001,
             A.AAC040,
             A.AAC002,
             A.YAC004,
             NVL(A.YAC503,0) YAC503,
             B.YAB136,
             '01' AAE140
        FROM wsjb.IRAC01A3  A,wsjb.IRAB01  B
       WHERE A.AAB001 = B.AAB001
         AND B.AAB001 = B.IAB001
         AND B.AAB001 = NVL(prm_aab001,v_aab001)
         AND A.aae110 = '2'
      UNION ALL
      SELECT AAC001,
             AAB001,
             AAC040,
             AAC002,
             YAC004,
             '0',
             '610127',
             '01' AAE140
        FROM wsjb.irac01c1
        WHERE aab001 = prm_aab001
          AND iaa100 = prm_aae002 ;

      --���е�˰���֣�����������
      CURSOR CUR_AAE140_DS
      IS
      SELECT distinct
             a.aae140,
             a.aab001
       FROM  xasi2.AB08 a,xasi2.ab02 b
       WHERE a.aab001 = b.aab001
         and a.aae140 = b.aae140
         and a.aab001 = NVL(prm_aab001,v_aab001)
         and a.aae003 = prm_aae002
         and a.yae517 = 'H01'
         and a.aab166 = '0'      --δ����
         and b.aab033 = '04';



      CURSOR CUR_YAE010_HD
      IS
      SELECT distinct
             a.yae010
        FROM wsjb.IRAB04  a,xasi2.AB02 b
       WHERE a.aae140 = b.aae140
         AND a.aab001 = b.aab001
         AND a.aab001 = prm_aab001
         AND a.iaa100 = prm_aae002
         AND b.aab051 = '1';

   BEGIN
      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      countnum     := 0;
      n_count      := 0;
      v_msg        := '';
      n_aab213     :=0;

      DELETE wsjb.IRAB04
       WHERE AAB001 = PRM_AAB001;

      IF prm_aab001 IS NULL THEN
         SELECT aab001
           INTO v_aab001
           FROM wsjb.IRAA01
          WHERE YAE092 = prm_aae011;
      ELSE
         v_aab001 := prm_aab001;
      END IF;

      SELECT COUNT(1)
        INTO countnum
        FROM wsjb.IRAB03
       WHERE AAB001 = NVL(prm_aab001,v_aab001);
      IF countnum = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λû�п��õ�������ʽ.';
         RETURN;
      ELSE
         SELECT
               yae010_110,
               yae010_120,
               yae010_210,
               yae010_310,
               yae010_410,
               yae010_510,
               yae010_311,
               '1'
           INTO
               v_yae010_110,
               v_yae010_120,
               v_yae010_210,
               v_yae010_310,
               v_yae010_410,
               v_yae010_510,
               v_yae010_311,
               v_yae010_810
           FROM wsjb.IRAB03
          WHERE AAB001 = NVL(prm_aab001,v_aab001);
         /*
         IF v_yae010_110 IS NOT NULL THEN
            INSERT INTO irab04(aab001,aae140,yae010,iaa100)VALUES(v_aab001,'01',v_yae010_110,prm_aae002);
         END IF;
         */
         IF v_yae010_120 IS NOT NULL AND v_yae010_120 <> 0 THEN
            INSERT INTO wsjb.irab04 (aab001,aae140,yae010,iaa100)VALUES(v_aab001,'06',v_yae010_120,prm_aae002);
         END IF;
         IF v_yae010_210 IS NOT NULL  AND v_yae010_210 <> 0 THEN
            INSERT INTO wsjb.irab04 (aab001,aae140,yae010,iaa100)VALUES(v_aab001,'02',v_yae010_210,prm_aae002);
         END IF;
         IF v_yae010_310 IS NOT NULL  AND v_yae010_310 <> 0 THEN
            INSERT INTO wsjb.irab04 (aab001,aae140,yae010,iaa100)VALUES(v_aab001,'03',v_yae010_310,prm_aae002);
         END IF;
         IF v_yae010_410 IS NOT NULL  AND v_yae010_410 <> 0 THEN
            INSERT INTO wsjb.irab04 (aab001,aae140,yae010,iaa100)VALUES(v_aab001,'04',v_yae010_410,prm_aae002);
         END IF;
         IF v_yae010_510 IS NOT NULL  AND v_yae010_510 <> 0 THEN
            INSERT INTO wsjb.irab04 (aab001,aae140,yae010,iaa100)VALUES(v_aab001,'05',v_yae010_510,prm_aae002);
         END IF;
         IF v_yae010_311 IS NOT NULL  AND v_yae010_311 <> 0 THEN
            INSERT INTO wsjb.irab04 (aab001,aae140,yae010,iaa100)VALUES(v_aab001,'07',v_yae010_311,prm_aae002);
         END IF;
         IF v_yae010_810 IS NOT NULL  AND v_yae010_810 <> 0 THEN
            SELECT count(1)
              INTO countnum
              FROM XASI2.AB02
             WHERE AAB001 = NVL(prm_aab001,v_aab001)
               AND aae140 = '08'
               AND aab051 = '1';
            IF countnum > 0 THEN
            INSERT INTO wsjb.irab04 (aab001,aae140,yae010,iaa100)VALUES(v_aab001,'08',v_yae010_810,prm_aae002);
            END IF;
         END IF;
      END IF;

      SELECT COUNT(1)
        INTO countnum
        FROM wsjb.IRAB08
       WHERE AAB001 = NVL(prm_aab001,v_aab001)
         AND AAE003 = prm_aae002
         AND yae517 = 'H01';
      IF countnum > 0 THEN
         SELECT COUNT(1)
           INTO n_count
           FROM wsjb.IRAB04
          WHERE AAB001 = NVL(prm_aab001,v_aab001)
            AND iaa100 = prm_aae002;
         IF n_count > 0 THEN
            DELETE
              FROM wsjb.IRAB08
             WHERE AAB001 = NVL(prm_aab001,v_aab001)
               AND AAE003 = prm_aae002
               AND yae517 = 'H01';
         ELSE
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '��λ�Ѿ����ں˶��·ݵ���ҵ����Ӧ�պ˶�����:';
            RETURN;
         END IF;
      END IF;

      SELECT COUNT(1)
        INTO countnum
        FROM xasi2.AB08
       WHERE AAB001 = NVL(prm_aab001,v_aab001)
         AND YAE517 = 'H01'
         AND AAE003 = prm_aae002;
      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λ�Ѿ����ں˶��·ݵ�Ӧ�պ˶�����:';
         RETURN;
      END IF;

     -- �걨����ԭ����
      SELECT COUNT(1)
        INTO countnum
        FROM xasi2.AB08A8
       WHERE AAB001 = NVL(prm_aab001,v_aab001)
         AND YAE517 = 'H01'
         AND YAB538 = '1' -- modify by whm ���������ݵ� 20190419
         AND AAE003 = prm_aae002;

      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λ�Ѿ����ں˶��·ݵ�ʵ������:';
         RETURN;
      END IF;

      v_yae518 := xasi2.PKG_COMM.FUN_GETSEQUENCE(NULL,'YAE518');
      FOR rec_ac01a3 IN CUR_AC01A3 LOOP
        n_aab213     :=0;
        IF rec_ac01a3.yac004 IS NULL OR rec_ac01a3.yac004 = 0 THEN
         --���ñ��׷ⶥ���̣���ȡ�ɷѻ����ͽɷѹ���
         xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase
                               (rec_ac01a3.aac001   ,     --���˱���
                                rec_ac01a3.aab001   ,     --��λ����
                                rec_ac01a3.aac040   ,     --�ɷѹ���
                                rec_ac01a3.yac503   ,     --�������
                                rec_ac01a3.aae140   ,     --��������
                                '00'                ,     --�ɷ���Ա���
                                rec_ac01a3.yab136   ,     --��λ�������ͣ���������ɷ���Ա��
                                prm_aae002   ,     --�ѿ�������
                                PKG_Constant.YAB003_JBFZX,     --�α�������
                                num_yac004   ,     --�ɷѻ���
                                prm_AppCode  ,     --�������
                                prm_ErrorMsg );    --��������
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            ROLLBACK;
            prm_ErrorMsg := '��Ա:'||rec_ac01a3.aac001 ||'����'||rec_ac01a3.aae140||'����'||prm_ErrorMsg ;
            RETURN;
         END IF;

         UPDATE wsjb.IRAC01A3
            SET YAC004 = num_yac004
          WHERE AAC001 = rec_ac01a3.aac001
            AND AAB001 = rec_ac01a3.aab001
            AND AAE110 = '2';
        END IF ;
       BEGIN
        SELECT yac004 INTO num_yac004
          FROM irac01a3
         WHERE AAC001 = rec_ac01a3.aac001
           AND AAB001 = rec_ac01a3.aab001
           AND AAE110 = '2';
         EXCEPTION
        WHEN NO_DATA_FOUND THEN
         num_yac004 := rec_ac01a3.yac004;
      END;

     -- modify by whm 20190428 201905 �����ϵ�λ���ֵ���Ϊ0.16 start
     --��λ��ͳ��
      if prm_aae002 >= 201905 then
       BEGIN
        SELECT (case when (SELECT aab019 FROM xasi2.ab01 WHERE aab001 = rec_ac01a3.aab001) = '60' THEN ROUND(a.yac004*0.12,2) ELSE  ROUND(a.yac004*0.16,2) END)
          INTO n_aab213
          FROM wsjb.irac01a3  a
         WHERE AAC001 = rec_ac01a3.aac001
           AND AAB001 = rec_ac01a3.aab001
           AND AAE110 = '2';
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
         SELECT (case when (SELECT aab019 FROM xasi2.ab01 WHERE aab001 = rec_ac01a3.aab001) = '60' THEN ROUND(rec_ac01a3.yac004*0.12,2) ELSE  ROUND(rec_ac01a3.yac004*0.16,2) END)
          INTO n_aab213
          FROM dual;
       END;
      else    --201905 ��ǰ�Ĳ���
       BEGIN
        SELECT (case when (SELECT aab019 FROM xasi2.ab01 WHERE aab001 = rec_ac01a3.aab001) = '60' THEN ROUND(a.yac004*0.12,2) ELSE  ROUND(a.yac004*0.2,2) END)
          INTO n_aab213
          FROM wsjb.irac01a3  a
         WHERE AAC001 = rec_ac01a3.aac001
           AND AAB001 = rec_ac01a3.aab001
           AND AAE110 = '2';
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
         SELECT (case when (SELECT aab019 FROM xasi2.ab01 WHERE aab001 = rec_ac01a3.aab001) = '60' THEN ROUND(rec_ac01a3.yac004*0.12,2) ELSE  ROUND(rec_ac01a3.yac004*0.2,2) END)
          INTO n_aab213
          FROM dual;
       END;
      end if;
      -- modify by whm 20190428 201905 �����ϵ�λ���ֵ���Ϊ0.16 end

     var_YAE202:=  xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAE202');
        --������Ա��ϸ
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
                            VALUES(
                               var_YAE202,
                               rec_ac01a3.aac001,
                               rec_ac01a3.aab001,
                               '01',
                               prm_aae002,
                               prm_aae002,
                               '01',
                               decode(v_yae010_110,'3','1',v_yae010_110),
                               '010',
                               '0',
                               rec_ac01a3.aac040,
                               num_yac004,
                               num_yac004,
                               ROUND(num_yac004*0.08,2),
                               0,
                               0,
                               n_aab213,
                               0,
                               v_yae518,
                               0,
                               prm_aae011,
                               SYSDATE,
                               PKG_Constant.YAB003_JBFZX,
                               PKG_Constant.YAB003_JBFZX,
                               '2');

      END LOOP;
      SELECT count(1) INTO countnum
        FROM wsjb.irac08a1  a
       WHERE a.yae518 = v_yae518;
     IF countnum > 0 THEN
      INSERT INTO wsjb.IRAB08 (
                  YAE518,
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
           SELECT v_yae518,
                  MAX(a.aab001),
                  '01',
                  prm_aae002,
                  prm_aae002,
                  prm_aae002,
                  '1',
                  decode(v_yae010_110,'3','1',v_yae010_110),
                  '0',
                  '1',
                  'H01',
                  NULL,
                  count(a.aac001) yae231,
                  1.0000,
                  sum(a.aae180) aab120,
                  sum(a.aae180) aab121,
                  sum(a.yab157) aab150,
                  0 yab031,
                  0 aab151,
                  sum(a.aab213) aab152,
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
                  0,
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
                  null,
                  null,
                  null,
                  '2',
                  '1',
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae011,
                  sysdate,
                  PKG_Constant.YAB003_JBFZX,
                  null
             FROM wsjb.irac08a1  a
            WHERE a.yae518 = v_yae518;
          --  WHERE a.AAB001 = NVL(prm_aab001,v_aab001)
          --    AND a.aae003 = prm_aae002
          --    AND a.aae002 = prm_aae002
          --    AND a.aae143 = '01';
      ELSE
        INSERT INTO wsjb.IRAB08 (
                  YAE518,
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
           VALUES(
                  v_yae518,
                  NVL(prm_aab001,v_aab001),
                  '01',
                  prm_aae002,
                  prm_aae002,
                  prm_aae002,
                  '1',
                  '1',
                  '0',
                  '1',
                  'H01',
                  NULL,
                  0,
                  1.0000,
                  0 ,
                  0 ,
                  0 ,
                  0 ,
                  0 ,
                  0 ,
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
                  0,
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
                  null,
                  null,
                  null,
                  '2',
                  '1',
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae011,
                  sysdate,
                  PKG_Constant.YAB003_JBFZX,
                  '0�걨');
      END IF;


--------------------------------------------------------------------------------------------
--      FOR rec_ac01a3 IN CUR_AC01A3 LOOP
--         --���ñ��׷ⶥ���̣���ȡ�ɷѻ����ͽɷѹ���
--         xasi2_zs.pkg_P_Comm_CZ.prc_P_getContributionBase
--                               (rec_ac01a3.aac001   ,     --���˱���
--                                rec_ac01a3.aab001   ,     --��λ����
--                                rec_ac01a3.aac040   ,     --�ɷѹ���
--                                rec_ac01a3.yac503   ,     --�������
--                                rec_ac01a3.aae140   ,     --��������
--                                '00'                ,     --�ɷ���Ա���
--                                rec_ac01a3.yab136   ,     --��λ�������ͣ���������ɷ���Ա��
--                                prm_aae002   ,     --�ѿ�������
--                                PKG_Constant.YAB003_JBFZX,     --�α�������
--                                num_yac004   ,     --�ɷѻ���
--                                prm_AppCode  ,     --�������
--                                prm_ErrorMsg );    --��������
--         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
--            ROLLBACK;
--            prm_ErrorMsg := '��Ա:'||rec_ac01a3.aac001 ||'����'||rec_ac01a3.aae140||'����'||prm_ErrorMsg ;
--            RETURN;
--         END IF;
--
--         UPDATE IRAC01
--            SET YAC004 = num_yac004
--          WHERE AAC001 = rec_ac01a3.aac001
--            AND AAB001 = rec_ac01a3.aab001;
--      END LOOP;
--
--      v_yae518 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'YAE518');
--
--      INSERT INTO IRAB08(
--                  YAE518,
--                  AAB001,
--                  AAE140,
--                  AAE003,
--                  AAE041,
--                  AAE042,
--                  YAB538,
--                  YAE010,
--                  AAB165,
--                  AAB166,
--                  YAE517,
--                  YAB222,
--                  YAE231,
--                  YAE203,
--                  AAB120,
--                  AAB121,
--                  AAB150,
--                  YAB031,
--                  AAB151,
--                  AAB152,
--                  AAB153,
--                  YAB040,
--                  AAB154,
--                  AAB155,
--                  YAB217,
--                  AAB157,
--                  AAB158,
--                  AAB159,
--                  AAB160,
--                  AAB161,
--                  AAB162,
--                  YAB042,
--                  YAB046,
--                  YAB059,
--                  YAB215,
--                  YAB381,
--                  YAB146,
--                  YAB147,
--                  YAB148,
--                  YAB149,
--                  YAB218,
--                  AAB214,
--                  AAB156,
--                  YAB400,
--                  YAB401,
--                  AAB163,
--                  AAB164,
--                  YAB541,
--                  YAB542,
--                  YAB543,
--                  YAB544,
--                  YAB546,
--                  AAB019,
--                  AAB020,
--                  AAB021,
--                  AAB022,
--                  YAE526,
--                  AAE068,
--                  AAE076,
--                  AAB191,
--                  YAD180,
--                  YAA011,
--                  YAA012,
--                  YAB139,
--                  AAE011,
--                  AAE036,
--                  YAB003,
--                  AAE013)
--           SELECT v_yae518,
--                  a.aab001,
--                  '01',
--                  prm_aae002,
--                  prm_aae002,
--                  prm_aae002,
--                  '1',
--                  v_yae010_110,
--                  '0',
--                  '1',
--                  'H01',
--                  NULL,
--                  count(a.aac001) yae231,
--                  1.0000,
--                  sum(a.yac004) aab120,
--                  sum(a.yac004) aab121,
--                  sum(ROUND(a.yac004*0.08,2)) aab150,
--                  0 yab031,
--                  0 aab151,
--                  (case when b.aab019 = '60' then sum(ROUND(a.yac004*0.12,2))
--                        else sum(ROUND(a.yac004*0.2,2)) end) aab152,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  '1',
--                  '0',
--                  sysdate,
--                  sysdate,
--                  0,
--                  0,
--                  0,
--                  0,
--                  0,
--                  null,
--                  null,
--                  null,
--                  null,
--                  null,
--                  null,
--                  null,
--                  null,
--                  null,
--                  '2',
--                  '1',
--                  PKG_Constant.YAB003_JBFZX,
--                  prm_aae011,
--                  sysdate,
--                  PKG_Constant.YAB003_JBFZX,
--                  null
--             FROM IRAC01 a,AB01 b
--            WHERE a.aab001 = b.aab001
--              AND a.AAB001 = NVL(prm_aab001,v_aab001)
--              AND a.iaa001 in('1','2','5','6','8')
--              AND (a.AAC030 IS NULL OR TO_NUMBER(TO_CHAR(a.AAC030,'YYYYMM')) <= prm_aae002)
--              AND a.aae110 in('1','10','2')
--              AND a.iaa002 = PKG_Constant.IAA002_APS
--              AND a.iaa100 = prm_aae002
--             GROUP BY a.AAB001,b.aab019;
--
--             INSERT INTO irac08a1(YAE202,             --��ϸ��ˮ��,VARCHAR2
--                               AAC001,             --���˱��,VARCHAR2
--                               AAB001,             --��λ���,VARCHAR2
--                               AAE140,             --��������,VARCHAR2
--                               AAE003,             --�����ں�,NUMBER
--                               AAE002,             --�ѿ�������,NUMBER
--                               AAE143,             --�ɷ�����,VARCHAR2
--                               YAE010,             --������Դ,VARCHAR2
--                               YAC505,             --�α��ɷ���Ա���,VARCHAR2
--                               YAC503,             --�������,VARCHAR2
--                               AAC040,             --�ɷѹ���,NUMBER
--                               YAA333,             --�˻�����,NUMBER
--                               AAE180,             --�ɷѻ���,NUMBER
--                               YAB157,             --���˽ɷѻ����ʻ����,NUMBER
--                               YAB158,             --���˽ɷѻ���ͳ����,NUMBER
--                               AAB212,             --��λ�ɷѻ����ʻ����,NUMBER
--                               AAB213,             --��λ�ɷѻ���ͳ����,NUMBER
--                               AAB162,             --Ӧ�����ɽ���,NUMBER
--                               YAE518,             --�˶���ˮ��,VARCHAR2
--                               AAE076,             --�ƻ���ˮ��,VARCHAR2
--                               AAE011,             --������,NUMBER
--                               AAE036,             --����ʱ��,DATE
--                               YAB003,             --�籣�������,VARCHAR2
--                               YAB139,             --�α�����������,VARCHAR2
--                               AAE114)             --�ɷѱ�־,VARCHAR2)
--                       SELECT  xasi2_zs.pkg_comm.FUN_GETSEQUENCE(NULL,'YAE202'),
--                               a.aac001,
--                               a.aab001,
--                               '01',
--                               prm_aae002,
--                               prm_aae002,
--                               '01',
--                               v_yae010_110,
--                               '010',
--                               '0',
--                               a.aac040,
--                               a.yac004,
--                               a.yac004,
--                               ROUND(a.yac004*0.08,2),
--                               0,
--                               0,
--                               (case when b.aab019 = '60' then ROUND(a.yac004*0.12,2) ELSE  ROUND(a.yac004*0.2,2) END),
--                               0,
--                               v_yae518,
--                               0,
--                               prm_aae011,
--                               SYSDATE,
--                               PKG_Constant.YAB003_JBFZX,
--                               PKG_Constant.YAB003_JBFZX,
--                               '2'
--                         FROM  irac01 a,AB01 b
--                        WHERE a.aab001 = b.aab001
--                          AND a.AAB001 = NVL(prm_aab001,v_aab001)
--                          AND a.iaa001 in('1','2','5','6','8')
--                          AND (a.AAC030 IS NULL OR TO_NUMBER(TO_CHAR(a.AAC030,'YYYYMM')) <= prm_aae002)
--                          AND a.aae110 in('1','10','2')
--                          AND a.iaa002 = PKG_Constant.IAA002_APS
--                          AND a.iaa100 = prm_aae002;
-------------------------------------------------------------------------------------------------------------------------
      SELECT COUNT(1)
        INTO countnum
        FROM wsjb.IRAB04
       WHERE AAB001 = NVL(prm_aab001,v_aab001)
         AND iaa100 = prm_aae002;

      IF countnum > 0 THEN
         v_yab222 := xasi2.PKG_comm.fun_GetSequence(NULL,'yab222');
         IF v_yab222 IS NULL THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'û�л�ȡ�����к�yab222';
            RETURN;
         END IF;


         FOR rec_yae010 IN CUR_YAE010_HD LOOP
            DELETE FROM xasi2.TMP_yshd_ab02 WHERE aab001 = NVL(prm_aab001,v_aab001);
            --�˶���ʱ����
            INSERT INTO xasi2.TMP_yshd_ab02
                        (aab001,
                         aae140,
                         yab139,
                         yab222)
                 SELECT a.AAB001,
                        a.AAE140,
                        PKG_Constant.YAB003_JBFZX,
                        v_yab222
                   FROM xasi2.ab02 a,wsjb.irab04  b
                  WHERE a.aab001 = b.aab001
                    AND a.aae140 = b.aae140
                    AND b.yae010 = rec_yae010.yae010
                    AND b.iaa100 = prm_aae002
                    AND a.AAB001 = NVL(prm_aab001,v_aab001)
                    AND a.AAB051 = '1'
                    AND NOT EXISTS
                    (
                        SELECT AAB001
                        FROM xasi2.AB08
                       WHERE aab001 = a.aab001
                         AND yae517 = 'H01'
                         AND AAE003 = prm_aae002
                         AND AAE140 = a.aae140
                    )
            ;

            v_jobid  := xasi2.PKG_comm.fun_GetSequence(NULL,'jobid');
            IF v_jobid IS NULL THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := 'û�л�ȡ�����к�jobid';
               RETURN;
           END IF;
            --�ж���ʱ���Ƿ��������
            SELECT COUNT(1)
              INTO countnum
              FROM xasi2.TMP_yshd_ab02
             WHERE yab222 = v_yab222;

            IF countnum < 1 THEN
              prm_AppCode  :=  gn_def_ERR;
              prm_ErrorMsg     := 'û����Ҫ���˵���ʱ������'||countnum;
              RETURN;
            END IF;

           xasi2.pkg_p_checkEmployerFeeCo.prc_p_checkallControl(prm_aae002,
                                                            prm_aae002,
                                                            prm_aae011,
                                                            PKG_Constant.YAB003_JBFZX,

                                                            v_jobid,
                                                            v_yab222,
                                                            '',
                                                            prm_AppCode,
                                                            prm_ErrorMsg);
           IF prm_AppCode <> gn_def_OK THEN
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := '���ú˶�����prc_p_checkallControl����:' ||prm_ErrorMsg||v_jobid;
               RETURN;
           END IF;
         END LOOP;

         /*
         0�걨 ��û�нɷ���Ա�ĺ˶����������Ӧ�պ˶����ݣ���ֻ�е��˵����ݣ�
         SELECT count(1)
           INTO countnum
           FROM AB08
          WHERE aab001 = NVL(prm_aab001,v_aab001)
            --and yae010 = prm_yae010
            and yae517 = 'H01'
            and aae003 = prm_aae002
            and yab222 = v_yab222
            and aab166 = '0';
         IF countnum = 0 THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'û�к˶��ɹ�!';
            RETURN;
         END IF;
         */

         BEGIN
         SELECT AAC003
           INTO V_AAC003
           FROM wsjb.ad53a4
          WHERE YAE092 = PRM_AAE011;
         EXCEPTION
              WHEN OTHERS THEN
                   V_AAC003:='';
         END;
         UPDATE xasi2.AB08
            SET AAE013 = AAE013||'�����˶�:'||V_AAC003
          WHERE aab001 = NVL(prm_aab001,v_aab001)
            --and yae010 = prm_yae010
            and aae003 = prm_aae002
            and yab222 = v_yab222
            and aab166 = '0';

         --��˰����

      SELECT COUNT(1)
        INTO n_count
        FROM  xasi2.AB08 a,xasi2.ab02 b
       WHERE a.aab001 = b.aab001
         and a.aae140 = b.aae140
         and a.aab001 = NVL(prm_aab001,v_aab001)
         and a.aae003 = prm_aae002
         and a.yae517 = 'H01'
         and a.aab166 = '0'      --δ����
         and b.aab033 = '04';

         IF n_count > 0 THEN
            FOR rec_aae140 IN CUR_AAE140_DS LOOP
               DELETE FROM xasi2.Tmp_yae518;
                INSERT INTO xasi2.Tmp_yae518(
                                     yae518,
                                     aae140,
                                     aab001,
                                     yab538,
                                     yae010,
                                     aae041,
                                     yab139)
                              SELECT a.yae518,
                                     a.aae140,
                                     a.aab001,
                                     a.yab538,
                                     a.yae010,
                                     a.aae041,
                                     a.yab139
                                FROM  xasi2.AB08 a,xasi2.ab02 b
                                WHERE a.aab001 = b.aab001
                                and a.aae140 = b.aae140
                                AND a.aae140 = rec_aae140.aae140
                                and a.aab001 = NVL(prm_aab001,v_aab001)
                                and a.aae003 = prm_aae002
                                and a.yae517 = 'H01'
                                and a.aab166 = '0'      --δ����
                                and b.aab033 = '04';

               v_aae076 := xasi2.PKG_comm.fun_GetSequence(NULL,'aae076');
               IF v_aae076 IS NULL THEN
                  prm_AppCode  :=  gn_def_ERR;
                  prm_ErrorMsg := 'û�л�ȡ�����к�aae076';
                  RETURN;
               END IF;
               xasi2.pkg_p_fundCollection.prc_crtFinaPlan('P01',--��˰����
                                                       '18',--��̨�տ�
                                                       prm_aae011,
                                                       PKG_Constant.YAB003_JBFZX,
                                                       v_aae076  ,
                                                       prm_AppCode,
                                                       prm_ErrorMsg);
               IF prm_AppCode <> gn_def_OK THEN
                  ROLLBACK;
                  prm_AppCode  :=  gn_def_ERR;
                  prm_ErrorMsg := '������������prc_crtFinaPlan����:' ||prm_ErrorMsg||v_jobid;
                  RETURN;
               END IF;
            END LOOP;
         END IF;

         --�Գ��ʽ�����

       SELECT COUNT(1)
        INTO n_count
        FROM  xasi2.AB08 a,xasi2.ab02 b
       WHERE a.aab001 = b.aab001
         and a.aae140 = b.aae140
         and a.aab001 = NVL(prm_aab001,v_aab001)
         and a.aae003 = prm_aae002
         and a.yae517 = 'H01'
         and a.aab166 = '0'      --δ����
         and b.aab033 IN('01','02');     --�Գ��ʽ�

         IF n_count > 0 THEN
            DELETE FROM xasi2.Tmp_yae518;
            INSERT INTO xasi2.Tmp_yae518(
                               yae518,
                               aae140,
                               aab001,
                               yab538,
                               yae010,
                               aae041,
                               yab139)
                        SELECT a.yae518,
                               a.aae140,
                               a.aab001,
                               a.yab538,
                               a.yae010,
                               a.aae041,
                               a.yab139
                          FROM  xasi2.AB08 a,xasi2.ab02 b
                          WHERE a.aab001 = b.aab001
                          and a.aae140 = b.aae140
                          and a.aab001 = NVL(prm_aab001,v_aab001)
                          and a.aae003 = prm_aae002
                          and a.yae517 = 'H01'
                          and a.aab166 = '0'      --δ����
                          and b.aab033 IN('01','02');      --�Գ��ʽ�

            v_aae076 := xasi2.PKG_comm.fun_GetSequence(NULL,'aae076');
            IF v_aae076 IS NULL THEN
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := 'û�л�ȡ�����к�aae076';
               RETURN;
            END IF;
            xasi2.pkg_p_fundCollection.prc_crtFinaPlan('P01',--��̨����
                                                     '10',--��̨�տ�
                                                     prm_aae011,
                                                     PKG_Constant.YAB003_JBFZX,
                                                     v_aae076  ,
                                                     prm_AppCode,
                                                     prm_ErrorMsg);
            IF prm_AppCode <> gn_def_OK THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := '������������prc_crtFinaPlan�Գ��ʽ�ʱ����:' ||prm_ErrorMsg||v_jobid;
               RETURN;
            END IF;

         END IF;

      END IF;

      IF v_yae010_110 = '1' OR v_yae010_120 = '1'OR v_yae010_210 = '1' OR v_yae010_310 ='1'
        OR v_yae010_410 = '1' OR v_yae010_510 = '1' OR v_yae010_311 = '1' OR v_yae010_810 = '1' THEN
            SELECT iaz004
              INTO v_iaz004
              FROM wsjb.IRAD01
             WHERE aab001 = prm_aab001
               AND iaa011 = 'A04'
               AND iaa100 = prm_aae002;

         var_iaz003:=  PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ003') ;
         var_iaa013:=  PKG_COMMON.fun_cbbh('DWYB',PKG_Constant.YAB003_JBFZX);
            --�����Գ��±��������
         INSERT INTO wsjb.IRAD03 (
                      iaz003 ,
                      iaz004 ,
                      iaa011 ,
                      iaa013 ,
                      aae035 ,
                      yae092 ,
                      yab003 ,
                      aae013 ,
                      aae120
                     )
                     VALUES
                     (
                      var_iaz003,
                      v_iaz004,
                      PKG_Constant.IAA011_MIR,
                      var_iaa013,
                      sysdate,
                      prm_aae011,
                      PKG_Constant.YAB003_JBFZX,
                      '',
                      '0'
                     );
      END IF ;
      /*
        ���Ͷ���Ϣ
      */

      DELETE FROM wsjb.IRAD23_TMP ;
      INSERT INTO wsjb.IRAD23_TMP (aab001) VALUES (v_aab001);
      SELECT aab004
        INTO v_aab004
        FROM xasi2.ab01
       WHERE  aab001 = v_aab001;
      v_msg := v_aab004||'�û�������'||prm_aae002||'�¶��걨�����ͨ�������ڣ�'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||',�밴�մ�ӡ���ݾ���ɷ�.';
      PKG_Insurance.prc_MessageSend(prm_aae011,
                                    'A04',
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
       prm_ErrorMsg := '���ݿ����1:'|| SQLERRM ||v_jobid||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
       RETURN;
   END prc_checkAndFinaPlan;



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
                             prm_iaz018     IN     irac01a2.iaz018%TYPE,  --������������ID
                             prm_AppCode    OUT    VARCHAR2  ,
                             prm_ErrorMsg   OUT    VARCHAR2 )

   IS
     n_count    number(5);
     v_iac001   varchar2(15);
     v_aac001   varchar2(15);
     v_aab001   varchar2(15);
     v_aab004   varchar2(120);
     v_aaz002   varchar2(15);
     var_flag   number(1);
     v_aac002   varchar2(20);
     v_aac002_l   varchar2(20);
     v_aac002_u   varchar2(20);
     v_aac002d  varchar2(20);
     d_aac006   DATE;
     v_aac004   varchar2(6);
     v_aae110   varchar2(6);
     v_aae120   varchar2(6);
     v_aae210   varchar2(6);
     v_aae310   varchar2(6);
     v_aae410   varchar2(6);
     v_aae510   varchar2(6);
     v_aae311   varchar2(6);
     v_aae810   VARCHAR2(6);
     v_message  varchar2(2000);
     v_yac168   varchar2(6);
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
              aae100
            FROM wsjb.IRAC01A2
            WHERE iaz018 = prm_iaz018;

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
       FROM wsjb.IRAB01
       WHERE aab001 = prm_aab001;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '��λ���Ϊ['|| prm_aab001 ||']�ĵ�λ��Ϣ������!';
       RETURN;
    END IF;



    --�ж��Ƿ���ڸ�ר��Ա
    SELECT COUNT(1)
       into n_count
       FROM wsjb.IRAA01
       WHERE yae092 = prm_aae011;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := 'ר��Ա���Ϊ['|| prm_aae011 ||']����Ϣ������!';
       RETURN;
    END IF;

    --�ж��Ƿ��������������Ϣ
    SELECT COUNT(1)
       into n_count
       FROM wsjb.IRAC01A2
       WHERE iaz018 = prm_iaz018;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '��������IDΪ['|| prm_iaz018 ||']����Ϣ������!';
       RETURN;
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
       v_message := null;

      /**��������**/
      --���֤�ǿ�У��
       IF REC_TMP_PERSON.aac002 IS NULL THEN
         v_message := v_message ||'���֤���벻��Ϊ�գ�';
         var_flag  := 1;
       END IF;
      --���֤λ������
       IF LENGTH(trim(REC_TMP_PERSON.aac002)) = 18  THEN
               xasi2.pkg_P_Comm_CZ.prc_P_getID( UPPER(REC_TMP_PERSON.aac002),   --�������֤
                                       v_aac002,   --�������֤
                                       prm_AppCode,   --�������
                                       prm_ErrorMsg) ;  --��������
               IF prm_AppCode <> PKG_Constant.GN_DEF_OK THEN
                   v_message := v_message || prm_ErrorMsg;
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
--               xasi2_zs.pkg_P_Comm_CZ.prc_P_getID( UPPER(REC_TMP_PERSON.aac002),   --�������֤
--                                       v_aac002,   --�������֤
--                                       prm_AppCode,   --�������
--                                       prm_ErrorMsg) ;  --��������
--               IF prm_AppCode <> PKG_Constant.GN_DEF_OK THEN
--                   v_message := v_message || prm_ErrorMsg;
--                   prm_AppCode := PKG_Constant.GN_DEF_OK;
--                   prm_ErrorMsg := '';
--                   var_flag :=1;
--               END IF;
--
--          SELECT  UPPER(v_aac002)
--            INTO  v_aac002_u
--            FROM  dual;
--
--          SELECT  LOWER(v_aac002)
--            INTO  v_aac002_l
--            FROM  dual;
--           v_aac002d := trim(REC_TMP_PERSON.aac002);

       ELSE
             v_message := v_message||REC_TMP_PERSON.aac002||'���֤λ�����Ϸ�;';
             var_flag  := 1;
       END IF;

      --����Ƿ�����ظ���ݺ���
      select count(1)
        into n_count
        from wsjb.IRAC01A2
       where iaz018 = prm_iaz018
         and aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d);
      IF n_count > 1 THEN
         v_message := v_message||'���֤�����ظ�;';
         var_flag   := 1;
      END IF;

      --18λ���֤���Ƿ��²α�У��
      IF v_aac002 IS NOT NULL  THEN
          SELECT COUNT(1)
            INTO n_count
            FROM  wsjb.irac01  a
          WHERE  a.aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
            AND  a.aae120 = '0';

            IF n_count >0 THEN

            SELECT aab001
            INTO  v_aab001
            FROM wsjb.irac01
            WHERE aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
            AND  rownum = 1;

            IF v_aab001 IS NOT NULL THEN
                  SELECT aab004
                  INTO v_aab004
                  FROM wsjb.irab01
                  WHERE aab001 = v_aab001
                   AND rownum = 1;
            END IF;

            v_message := v_message||'����Ա��'||v_aab004||'['||v_aab001||']���걨��¼���������²α����룡';
            var_flag  := 1;
            END IF;
      END IF;

      --18λ���֤���Ƿ��²α�У��
          SELECT COUNT(1)
            INTO n_count
            FROM xasi2.ac01 a
          WHERE  a.aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
            AND  a.aae120 = '0';

            IF n_count >0 THEN
              SELECT aac001
              INTO v_aac001
              FROM xasi2.ac01
              WHERE aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
               AND rownum = 1;

              IF v_aac001 IS NOT NULL THEN
                    SELECT aab001
                    INTO v_aab001
                    FROM xasi2.ac02
                    WHERE aac001 = v_aac001
                      AND rownum = 1;

                    IF v_aab001 IS NOT NULL THEN
                        SELECT aab004
                        INTO v_aab004
                        FROM xasi2.ab01
                        WHERE aab001 = v_aab001;
                    END IF;
              END IF;
              v_message := v_message||'����Ա��'||v_aab004||'['||v_aab001||']�вα���¼���������²α����룡';
              var_flag  := 1;
            END IF;


       IF REC_TMP_PERSON.aab001 IS NULL THEN
         v_message := v_message||'û���ҵ���λ��ţ�';
         var_flag  := 1;
       END IF;

       SELECT COUNT(1)
       INTO n_count
       FROM xasi2.ab01
       WHERE aab001 = REC_TMP_PERSON.aab001;
       IF n_count = 0 THEN
         v_message := v_message||'û���ҵ���λ��Ϣ';
         var_flag  := 1;
       END IF;

       SELECT COUNT(1)
       INTO n_count
       FROM wsjb.irab01
       WHERE aab001 = REC_TMP_PERSON.aab001;
       IF n_count = 0 THEN
         v_message := v_message||'û���ҵ�������λ��Ϣ';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac003 IS NULL THEN
         v_message := v_message||'������������Ϊ�գ�';
         var_flag  := 1;
       END IF;
       IF REC_TMP_PERSON.aac004 IS NOT NULL THEN
         IF REC_TMP_PERSON.aac004 <> '1' AND REC_TMP_PERSON.aac004 <> '2' AND REC_TMP_PERSON.aac004 <> '9' THEN
              v_message := v_message||'�Ա���ֵ����!';
              var_flag  := 1;
         END IF;
       END IF;

       IF REC_TMP_PERSON.aac005 IS  NOT  NULL THEN
         IF  LENGTH(trim(REC_TMP_PERSON.aac005)) <> 2 THEN
              v_message := v_message||'��ֵ��ֵ����!';
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
            IF REC_TMP_PERSON.aac012 <> '1' AND REC_TMP_PERSON.aac012 <> '4' THEN
                  v_message := v_message||'���������ֵ����!';
                  var_flag  :=1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.yac168 IS NULL THEN
         v_message := v_message||'�����񹤱�־����Ϊ�գ�';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.yac168 <> '0' AND REC_TMP_PERSON.yac168 <> '1' THEN
                    v_message := v_message||'ũ�񹤱�־��ֵ����!';
                    var_flag  := 1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aac030 IS NULL THEN
         v_message := v_message||'�α�ʱ�䲻��Ϊ�գ�';
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
        --��ҵְ�����ϱ���У��
       IF REC_TMP_PERSON.aae110 IS NOT NULL THEN
               SELECT COUNT(1)
               INTO n_count
               FROM  wsjb.IRAB01  a,wsjb.AE02  b
               WHERE a.aaz002 = b.AAZ002
                  AND b.aaa121 = PKG_Constant.AAA121_NER
                  AND a.aab001 = prm_aab001;
               IF n_count > 0 THEN
                   SELECT nvl(a.aae110,'0')
                     INTO  v_aae110
                     FROM wsjb.IRAB01  a,wsjb.AE02  b
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
            ElSE
                  v_aae120 := '0';
            END IF;

           IF  (v_aae120 = '0' AND REC_TMP_PERSON.aae120 = '1') THEN
             v_message := v_message||'���ڵ�λû�вμӻ�����ҵ���ϱ���!';
             var_flag := 1;
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
            ElSE
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
            ElSE
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
            ElSE
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
            ElSE
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
            ElSE
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
                     INTO v_aae810
                     FROM xasi2.ab02
                    WHERE aab001 = prm_aab001
                      AND aae140 = '08';
            ElSE
                  v_aae810 := '0';
            END IF;

           IF  (v_aae810 = '0' AND REC_TMP_PERSON.aae810 = '1') THEN
             v_message := v_message||'���ڵ�λû�вμӹ���Ա��������!';
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
       IF v_aae210 = '2' AND v_aae510 = '2' AND v_aae311 = '2' AND v_aae310 = '2' THEN

             IF REC_TMP_PERSON.aae310 = '1' THEN
                   IF  REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae510 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                        v_message := v_message||'ҽ�ơ�ʧҵ�����������������ֱ���һ��α�!';
                        var_flag  := 1;
                   END IF;
             END IF;

             IF REC_TMP_PERSON.aae210 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae510 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                        v_message := v_message||'ҽ�ơ�ʧҵ�����������������ֱ���һ��α�!';
                        var_flag  := 1;
                   END IF;
             END IF;

             IF REC_TMP_PERSON.aae510 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                        v_message := v_message||'ҽ�ơ�ʧҵ�����������������ֱ���һ��α�!';
                        var_flag  := 1;
                   END IF;
             END IF;

             IF REC_TMP_PERSON.aae311 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae510 = '0' THEN
                        v_message := v_message||'ҽ�ơ�ʧҵ�����������������ֱ���һ��α�!';
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
            IF REC_TMP_PERSON.aac030 > sysdate THEN
                  v_message:= v_message||'����λ�α�ʱ�䲻������ϵͳʱ��!';
                  var_flag := 1;
          END IF;
       END IF;

      IF REC_TMP_PERSON.yac033 IS NOT NULL THEN
            IF REC_TMP_PERSON.yac033 > sysdate THEN
                  v_message:= v_message||'����λ�α�ʱ�䲻������ϵͳʱ��!';
                  var_flag := 1;
          END IF;
       END IF;

       IF REC_TMP_PERSON.aac007 IS NOT NULL THEN
            IF REC_TMP_PERSON.aac007 > sysdate THEN
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
          v_message := v_message||'�Ѿ�������������������Ϣ,���ܼ�������!';
          var_flag  := 1;
        END IF;
      END IF;

       IF REC_TMP_PERSON.aac002 IS NOT NULL THEN
          SELECT COUNT(1)
            INTO n_count
            FROM wsjb.irac01  a
          WHERE a.iaa002 = PKG_Constant.IAA002_WIR
            AND a.aac002 = v_aac002
            AND a.iaa001 = PKG_Constant.IAA001_PAD ;
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
      END IF;

      IF LENGTH(TRIM(v_aac002)) = 15 THEN
            SELECT to_date(( '19' ||  substr(v_aac002,7,6)) ,'yyyy-mm-dd')
              INTO d_aac006
              FROM dual;
            SELECT decode(mod(to_number(substr(TRIM(v_aac002),15,1)),2),1,'1',0,'2','9')
              INTO v_aac004
              FROM dual;
      END IF;

      SELECT decode(REC_TMP_PERSON.aac009,'10','0','20','1')
        INTO v_yac168
        FROM dual;

     SELECT  to_number(to_char(sysdate,'yyyymm'))
       INTO n_aae002
       FROM dual;

     IF REC_TMP_PERSON.aae310 = 1 THEN
        SELECT
        pkg_common.fun_p_getcontributionbase(null,REC_TMP_PERSON.aab001,REC_TMP_PERSON.aac040,'0','03','1','1',n_aae002,PKG_Constant.YAB003_JBFZX)
        INTO n_yac005
        FROM dual;
     ELSE
        SELECT
        pkg_common.fun_p_getcontributionbase(null,REC_TMP_PERSON.aab001,REC_TMP_PERSON.aac040,'0','04','1','1',n_aae002,PKG_Constant.YAB003_JBFZX)
        INTO n_yac005
        FROM dual;
     END IF;
     IF REC_TMP_PERSON.aae110 = 1 THEN
        SELECT
         pkg_common.fun_p_getcontributionbase(null,REC_TMP_PERSON.aab001,REC_TMP_PERSON.aac040,'0','01','1','1',n_aae002,PKG_Constant.YAB003_JBFZX)
        INTO n_yac004
        FROM dual;

     ELSIF REC_TMP_PERSON.aae120 = 1 THEN
        n_yac004 := REC_TMP_PERSON.yac004;
     END IF;

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
                    v_aac002,             -- ���֤����(֤������) -->
                    REC_TMP_PERSON.aac003,-- ����         -->
                    v_aac004,             -- �Ա�         -->
                    REC_TMP_PERSON.aac005,-- ����         -->
                    d_aac006             ,-- ��������     -->
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
                    v_yac168,             -- ũ�񹤱�־   -->
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
                    n_yac004,-- �ɷѻ���[����] -->
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
                    n_yac005,-- �ɷѻ���[����] -->
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
     ElSIF var_flag = 1 THEN
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
   prm_ErrorMsg := '���ݿ����:'|| SQLERRM||dbms_utility.format_error_backtrace  ;
   RETURN;
   END prc_batchImport;

   /*****************************************************************************
   ** �������� : prc_p_checkQYYL
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����ҵ���ϽɷѺ˶�
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ���
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-22   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_p_checkQYYL (
      prm_aab001       IN     irab01.aab001%TYPE,--��λ���
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum    NUMBER;
      v_aab001    VARCHAR2(15);
      v_jobid     VARCHAR2(10);
      v_yab222    VARCHAR2(15);
      v_aae076    VARCHAR2(20);

   BEGIN
      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      countnum     := 0;


   EXCEPTION
     -- WHEN NO_DATA_FOUND THEN
     -- WHEN TOO_MANY_ROWS THEN
     -- WHEN DUP_VAL_ON_INDEX THEN
     WHEN OTHERS THEN
       /*�رմ򿪵��α�*/
       ROLLBACK;
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '���ݿ����1:'|| SQLERRM||dbms_utility.format_error_backtrace ;
       RETURN;
   END prc_p_checkQYYL;

   /*****************************************************************************
   ** �������� prc_oldEmpManaInfoMove
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ���ϵ�λ��ͨ���Ͼ���Э��
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_iab001       IN     irab01.iab001%TYPE,--��λ������
   **           prm_aae011       IN     irab01.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          )
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-12   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_oldEmpManaInfoMove (
      prm_aae011       IN     irab01.aae011%TYPE,--������
      prm_aae013       IN     irab01.aae013%TYPE,--��ע
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      n_count    number(4);
      v_yae092   varchar2(15);
      v_aaz002   varchar2(15);
      v_yae367   varchar2(15);
      v_errmsg   varchar2(2000);

      CURSOR cur_IRAA01_TMP IS
      SELECT aab001,
             aab004,
             aab016,
             yae043,
             yae042,
             yae010_110,
             yae010_210,
             yae010_310,
             yae010_410,
             yae010_510,
             yae010_311,
             yae010_120
        FROM wsjb.IRAA01_TMP  a
        where NOT EXISTS(select aab001 from wsjb.IRAB01  where aab001= iab001 and aab001 = a.aab001);
   BEGIN

      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;

      SELECT count(1)
        into n_count
        from wsjb.IRAA01_TMP  a
       where NOT EXISTS(select aab001 from wsjb.IRAB01  where aab001= iab001 and aab001 = a.aab001);
      IF n_count = 0 THEN
         prm_ErrorMsg := PRE_ERRCODE ||'��ʱ��û�����ݣ��������ϵ�λ��ͨ���Ͼ���Э��!';
         RETURN;
      END IF;


      FOR rec_iraa01 in cur_IRAA01_TMP LOOP

         v_errmsg := NULL;

         SELECT count(1)
           INTO n_count
           FROM xasi2.ab01
          WHERE aab001= rec_iraa01.aab001;
         IF n_count = 0 THEN
            --v_errmsg := rec_iraa01.aab001||'��λ��Ϣ�����ڣ���ȷ���籣�������Ƿ���ȷ!';
            --GOTO NEXTAAB001;
            prm_ErrorMsg := rec_iraa01.aab001||'��λ��Ϣ�����ڣ���ȷ���籣�������Ƿ���ȷ!';
            RETURN;
         END IF;

         SELECT count(1)
           INTO n_count
           FROM wsjb.IRAB01
          WHERE aab001 = iab001
            and aab001 = rec_iraa01.aab001;
         IF n_count > 0 THEN
            --v_errmsg := rec_iraa01.aab001||'��λ�Ѿ���ͨ���Ͼ���Э��!';
            --GOTO NEXTAAB001;
            prm_ErrorMsg := rec_iraa01.aab001||'��λ�Ѿ���ͨ���Ͼ���Э��!';
            RETURN;
         END IF;

         /*
            д���걨��λ��Ϣ��
            ȷ����λ�α����֣�
                    ר��Ա,
                    ˰�ţ�����ִ�գ���֯�������룬��˰�������
         */

          v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
          IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
             prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�AAZ002!';
             RETURN;
          END IF;

          v_yae092 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'FRAMEWORK');
          IF v_yae092 IS NULL OR v_yae092 = '' THEN
             prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�FRAMEWORK!';
             RETURN;
          END IF;

          v_yae367 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'DEFAULT');
          IF v_yae367 IS NULL OR v_yae367 = '' THEN
             prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�DEFAULT!';
             RETURN;
          END IF;


         INSERT INTO wsjb.IRAB01
                    (
                     IAB001,
                     IAA002,
                     AAB001,
                     AAB003,
                     AAB004,
                     YAB004,
                     AAB007,
                     YAB516,
                     AAB016,
                     AAB019,
                     AAB020,
                     AAB021,
                     AAB022,
                     AAB030,
                     YLB001,
                     YAB136,
                     YAB275,
                     YAB380,
                     YAB028,
                     AAE110,
                     AAE210,
                     AAE310,
                     AAE410,
                     AAE510,
                     AAE120,
                     AAE311,
                     AAE011,
                     AAE036,
                     AAE013,
                     AAZ002,
                     YAB010
                    )
             SELECT a.aab001,
                    PKG_Constant.IAA002_APS iaa002,
                    a.aab001,
                    nvl(a.aab003,a.aab001),
                    a.aab004,
                    '2' yab004, --�ϵ�λ��Ϣ����
                    NULL aab007,
                    a.yab516,
                    nvl(a.aab016,a.aab001),
                    a.aab019,
                    a.aab020,
                    a.aab021,
                    a.aab022,
                    a.aab030,
                    a.ylb001,
                    a.yab136,
                    a.yab275,
                    a.yab380,
                    nvl(c.yab028,a.aab001),
                    to_char(case when a.aab019 in('20','30') then '0'
                         else '1' end) as aae110,
                    to_char(sum(case when b.aae140 = '02' then '1'
                         else '0' end)) as aae210,
                    to_char(sum(case when b.aae140 = '03' then '1'
                         else '0' end)) as aae310,
                    to_char(sum(case when b.aae140 = '04' then '1'
                         else '0'  end)) as aae410,
                    to_char(sum(case  when b.aae140 = '05' then '1'
                         else '0' end)) as aae510,
                    to_char(sum(case  when b.aae140 = '06' then '1'
                         else '0' end)) as aae120,
                    to_char(sum(case  when b.aae140 = '07' then '1'
                         else '0' end)) as aae311,
                    a.aae011,
                    SYSDATE aae036,
                    prm_aae013,
                    v_aaz002 aaz002,
                    '1'
               FROM xasi2.ab01 a, xasi2.ab02 b,xasi2.ab01a7 c
              WHERE a.aab001 = b.aab001
                and a.aab001 = c.aab001(+)
                and a.aab001 = rec_iraa01.aab001
                group by a.aab001,
                    a.aab001,
                    a.aab003,
                    a.aab004,
                    null,
                    a.yab516,
                    a.aab016,
                    a.aab019,
                    a.aab020,
                    a.aab021,
                    a.aab022,
                    a.aab030,
                    a.ylb001,
                    a.yab136,
                    a.yab275,
                    a.yab380,
                    c.yab028,
                    a.aae011,
                    SYSDATE,
                    a.aae013;

         INSERT INTO wsjb.IRAB03 (
                AAB001,
                YAE010_110,
                YAE010_120,
                YAE010_210,
                YAE010_310,
                YAE010_410,
                YAE010_510,
                YAE010_311,
                AAE011)
         VALUES
              (
                rec_iraa01.aab001,
                rec_iraa01.yae010_110,
                rec_iraa01.yae010_120,
                rec_iraa01.yae010_210,
                rec_iraa01.yae010_310,
                rec_iraa01.yae010_410,
                rec_iraa01.yae010_510,
                rec_iraa01.yae010_311,
                prm_aae011
              );

         /*
             �����½�˺ſ���
         */
         INSERT INTO wsjb.ad53a4  (
              yae092,  -- ������Ա���
              yab109,  -- ���ű��
              aac003,  -- ����
              aac004,  -- �Ա�
              yab003,  -- �������
              yae041,  -- ��½��
              yae042,  -- ��½����
              yae361,  -- ������־
              yae362,  -- ����������
              yae363,  -- �����ʱ��
              yae114,  -- �����
              aae100,  -- ��Ч��־
              aae011,  -- ������
              aae036   -- ����ʱ��
              )
         VALUES
             (
              v_yae092  ,  -- ������Ա���
              '0101'    ,  -- ���ű��[��λ����]
              rec_iraa01.aab016,  -- ����
              '9'       ,  -- �Ա�
              PKG_Constant.YAB003_JBFZX,  -- �������
              rec_iraa01.aab001,  -- ��½��=��λ���=��λ������[Ĭ������ר��Ա���]
              rec_iraa01.yae042,  -- ��½����
              '0'       ,  -- ������־
              0         ,  -- ����������
              SYSDATE,  -- �����ʱ��
              0         ,  -- �����
              '1'       ,  -- ��Ч��־
              prm_aae011,  -- ������
              SYSDATE      -- ����ʱ��
         );


         /*
            ���Ķ�����������Ŀ�� ������Ķ˾�����Ա��������
         */
         INSERT INTO wsjb.ad53a4  (
              yae092,  -- ������Ա���
              yab109,  -- ���ű��
              aac003,  -- ����
              aac004,  -- �Ա�
              yab003,  -- �������
              yae041,  -- ��½��
              yae042,  -- ��½����
              yae361,  -- ������־
              yae362,  -- ����������
              yae363,  -- �����ʱ��
              yae114,  -- �����
              aae100,  -- ��Ч��־
              aae011,  -- ������
              aae036   -- ����ʱ��
              )
         VALUES
             (
              v_yae092  ,  -- ������Ա���
              '0101'    ,  -- ���ű��[��λ����]
              rec_iraa01.aab016,  -- ����
              '9'       ,  -- �Ա�
              PKG_Constant.YAB003_JBFZX,  -- �������
              rec_iraa01.aab001,  -- ��½��=��λ���=��λ������[Ĭ������ר��Ա���]
              rec_iraa01.yae042,  -- ��½����
              '0'       ,  -- ������־
              0         ,  -- ����������
              SYSDATE,  -- �����ʱ��
              0         ,  -- �����
              '1'       ,  -- ��Ч��־
              prm_aae011,  -- ������
              SYSDATE      -- ����ʱ��
         );


         /*
             Ϊ������Ա��ȨΪ��λ����ĸ�λ
         */
         INSERT INTO  wsjb.AD53A6
                     (
                      yae093,  -- ��ɫ���
                      yab109,  -- ���ű��
                      yae092,  -- ������Ա���
                      aae011,  -- ������
                      aae036   -- ����ʱ��
                     )
              VALUES
                     (
                      '1000000021',  -- ��ɫ���[��λ����]
                      '0101'    ,  -- ���ű��
                      v_yae092  ,  -- ������Ա���
                      prm_aae011,  -- ������
                      SYSDATE      -- ����ʱ��
         );

         /*
            ��¼�û���λ�䶯��־
         */
         INSERT INTO wsjb.ad53a8  (
                yae367,  -- �䶯��ˮ��
                yae093,  -- ��ɫ���
                yab109,  -- ���ű��
                yae092,  -- ������Ա���
                aae011,  -- ������
                aae036,  -- ����ʱ��
                yae369,  -- �޸���
                yae370,  -- �޸�ʱ��
                yae372)  -- Ȩ�ޱ䶯����
         VALUES (
                v_yae367 ,  -- �䶯��ˮ��
                '1000000021',  -- ��ɫ���
                '0101',       -- ���ű��
                v_yae092,    -- ������Ա���
                prm_aae011,  -- ������
                SYSDATE   ,  -- ����ʱ��
                prm_aae011,  -- �޸���
                SYSDATE   ,  -- �޸�ʱ��
                '07'        -- Ȩ�ޱ䶯����
         );

         /*
            д�뵥λר��Ա��Ϣ
         */
         INSERT INTO wsjb.IRAA01
                    (
                     AAB001,
                     YAB516,
                     AAB016,
                     YAE092,
                     AAZ002,
                     IAB001,
                     AAE011,
                     AAE035,
                     AAE036,
                     YAE043,
                     YAE042,
                     AAE100
                    )
                    VALUES
                    (
                     rec_iraa01.aab001,
                     null,
                     rec_iraa01.aab016,
                     v_yae092  ,
                     v_aaz002  ,
                     rec_iraa01.aab001,
                     prm_aae011,
                     sysdate,
                     sysdate,
                     rec_iraa01.yae043,
                     rec_iraa01.yae042,
                     '1'
                    );

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
                     AAE218,
                     AAE013
                    )
                    VALUES
                    (
                     v_aaz002,
                     PKG_Constant.AAA121_NER,
                     prm_aae011,
                     PKG_Constant.YAB003_JBFZX,
                     prm_aae011,
                     '1',
                     sysdate,
                     sysdate,
                     sysdate,
                     prm_aae013
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
         prm_ErrorMsg := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace  ;
         RETURN;
   END prc_oldEmpManaInfoMove;


    /*****************************************************************************
   ** �������� : prc_MeetingMessageSend
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ������֪ͨ���Ͷ���Ϣ
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2013-04-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_MeetingMessageSend(prm_aae011     IN     ae02.aae011%TYPE,
                                    prm_iaa011     IN     irad23.iaa011%TYPE,
                                    prm_iaa022     IN     irad24.iaa022%TYPE,
                                    prm_AppCode    OUT    VARCHAR2  ,
                                    prm_ErrorMsg   OUT    VARCHAR2 )
   IS

   BEGIN
     /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';

      /*��Ҫ������У��*/
      IF prm_iaa011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := 'ҵ�����Ͳ���Ϊ��!';

      END IF;

      IF prm_iaa022 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�������ݲ���Ϊ��!';

      END IF;

      INSERT INTO wsjb.IRAD23_TMP  (AAB001)
        SELECT DISTINCT AAB001 FROM wsjb.IRAB01  WHERE AAB001 = IAB001;
      --���ö���Ϣ���͹���
      prc_MessageSend(prm_aae011,
                      prm_iaa011,
                      prm_iaa022,
                      prm_AppCode,
                      prm_ErrorMsg);

     EXCEPTION
     -- WHEN NO_DATA_FOUND THEN
     -- WHEN TOO_MANY_ROWS THEN
     -- WHEN DUP_VAL_ON_INDEX THEN
     WHEN OTHERS THEN
       /*�رմ򿪵��α�*/
       ROLLBACK;
       DELETE wsjb.IRAD23_TMP  WHERE 1=1;
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '���ݿ����:'|| SQLERRM||dbms_utility.format_error_backtrace ;
       RETURN;
   END prc_MeetingMessageSend;

     /*****************************************************************************
   ** �������� : prc_MessageSend
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����Ͷ���Ϣ
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-17   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_MessageSend(prm_aae011     IN     ae02.aae011%TYPE,
                             prm_iaa011     IN     irad23.iaa011%TYPE,
                             prm_iaa022     IN     irad24.iaa022%TYPE,
                             prm_AppCode    OUT    VARCHAR2  ,
                             prm_ErrorMsg   OUT    VARCHAR2 )

   IS
      n_count    NUMBER;
      v_aab001    VARCHAR2(15);
      v_aaz002    VARCHAR2(15);
      v_iaz015    VARCHAR2(15);
      v_iaz016    VARCHAR2(15);
      cursor c_cur  IS SELECT aab001 FROM wsjb.IRAD23_TMP ;

   BEGIN
      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count     := 0;

      /*��Ҫ������У��*/
      IF prm_iaa011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := 'ҵ�����Ͳ���Ϊ��!';
         goto con_delete;
      END IF;

      IF prm_iaa022 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�������ݲ���Ϊ��!';
         goto con_delete;
      END IF;

      --��鵥λ����Ƿ���ȷ
      FOR c_row in c_cur LOOP

        SELECT COUNT(1) INTO n_count FROM
          wsjb.IRAB01  a WHERE a.aab001 = c_row.aab001;
         IF n_count = 0 THEN
          prm_AppCode  :=  gn_def_ERR;
          prm_ErrorMsg := 'û���ҵ�'||c_row.aab001||'�ĵ�λ��Ϣ������';
          goto con_delete;
         END IF;

      END LOOP;


      --д����־
      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
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
                  PKG_Constant.AAA121_MIA,
                  prm_aae011,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae011,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate
                 );

      --д��IRAD23����Ϣ�¼�
      v_iaz015 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ015');
      INSERT INTO IRAD23
                  (
                   iaz015,
                   aaz002,
                   aae011,
                   iaa011,
                   aae035,
                   yab003,
                   aae013
                  )
                  VALUES
                  (
                   v_iaz015,
                   v_aaz002,
                   prm_aae011,
                   prm_iaa011,
                   sysdate,
                   PKG_Constant.YAB003_JBFZX,
                   ''
                  );

      --д��IRAD24����Ϣ�¼�
      FOR c_row in c_cur LOOP

        v_iaz016 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ016');
        INSERT INTO IRAD24
                    (
                      iaz016,
                      iaz015,
                      iaa021,
                      iaa022,
                      iaa023,
                      iaa024,
                      iaa003,
                      iaa025,
                      iaa028
                    )
                    VALUES
                    (
                     v_iaz016,
                     v_iaz015,
                     '1',
                     prm_iaa022,
                     prm_aae011,
                     c_row.aab001,
                     '1',
                     PKG_Constant.YAB003_JBFZX,
                     sysdate
                    );

      END LOOP;

      <<con_delete>>
      DELETE wsjb.IRAD23_TMP  WHERE 1=1;




     EXCEPTION
     -- WHEN NO_DATA_FOUND THEN
     -- WHEN TOO_MANY_ROWS THEN
     -- WHEN DUP_VAL_ON_INDEX THEN
     WHEN OTHERS THEN
       /*�رմ򿪵��α�*/
       ROLLBACK;
       DELETE wsjb.IRAD23_TMP  WHERE 1=1;
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '���ݿ����:'|| SQLERRM||dbms_utility.format_error_backtrace ;
       RETURN;
   END prc_MessageSend;



   /*****************************************************************************
   ** �������� : prc_writeToIrad25
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����ն���Ϣ
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-17   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_writeToIrad25(prc_iaa024     IN     irad24.iaa024%TYPE,
                               prc_iaa003     IN     irad24.iaa003%TYPE,
                               prm_AppCode    OUT    VARCHAR2  ,
                               prm_ErrorMsg   OUT    VARCHAR2 )

   IS
      n_count    NUMBER;
      v_iaz017    VARCHAR2(15);
      cursor c_cur  IS SELECT * FROM IRAD24 a
      WHERE a.iaa003 = prc_iaa003
      AND a.iaa024 = prc_iaa024
      AND a.iaa021 in ('1','2');

   BEGIN
      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count     := 0;

      /*��Ҫ������У��*/
      IF prc_iaa024 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ܶ�����Ϊ��!';
         RETURN;
      END IF;

      IF prc_iaa003 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�������岻��Ϊ��!';
         RETURN;
      END IF;


      --д��IRAD24����Ϣ�¼�
      FOR c_row in c_cur LOOP

        v_iaz017 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ017');
        INSERT INTO wsjb.IRAD25
                    (
                     iaz017,
                     iaz016,
                     iaa026,
                     iaa003,
                     iaa027,
                     aae035,
                     iaa023,
                     iaa028,
                     iaa021,
                     iaa029
                    )
                    VALUES
                    (
                     v_iaz017,
                     c_row.iaz016,
                     c_row.iaa024,
                     c_row.iaa003,
                     c_row.iaa022,
                     sysdate,
                     c_row.iaa023,
                     c_row.iaa028,
                     '3',
                     prc_iaa024
                    );
      END LOOP;

      UPDATE irad24 SET
        iaa021 = '3'
      WHERE 1 = 1
      AND iaa024 = prc_iaa024
      AND iaa003 = prc_iaa003
      AND iaa021 in ('1','2');


     EXCEPTION
     -- WHEN NO_DATA_FOUND THEN
     -- WHEN TOO_MANY_ROWS THEN
     -- WHEN DUP_VAL_ON_INDEX THEN
     WHEN OTHERS THEN
       /*�رմ򿪵��α�*/
       ROLLBACK;
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '���ݿ����:'|| SQLERRM||dbms_utility.format_error_backtrace ;
       RETURN;
   END prc_writeToIrad25;



   /*****************************************************************************
   ** �������� : prc_rollbackUnitInfoMaintain
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����λ�޸���Ϣ����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-17   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_rollbackUnitInfoMaintain(prm_aab001     IN     irab01.aab001%TYPE,--��λ���
                                          prm_AppCode    OUT    VARCHAR2  ,
                                          prm_ErrorMsg   OUT    VARCHAR2 )
   IS
     n_count    NUMBER;
     v_iab001   varchar2(15);
     v_iaz004   varchar2(15);

   BEGIN

     prm_AppCode  := PKG_Constant.GN_DEF_OK;
     prm_ErrorMsg := '';


     /*��Ҫ������У��*/
      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '��λ�����벻��Ϊ��!';
         RETURN;
      END IF;

      --�Ƿ����AB01��λ��Ϣ
      SELECT COUNT(1)
           into n_count
           FROM xasi2.ab01
          WHERE aab001 = prm_aab001;
      IF n_count = 0 THEN
            prm_ErrorMsg := '��λ���Ϊ['|| prm_aab001 ||']�ĵ�λ��Ϣ������!';
            RETURN;
      END IF;

      --�Ƿ����IRAB01��λ���걨�޸���Ϣ
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAB01  a,wsjb.AE02  b
          WHERE a.aab001 = prm_aab001
          AND a.aaz002 = b.aaz002
          AND b.aaa121 = PKG_Constant.AAA121_EIM
          AND a.iaa002 = PKG_Constant.IAA002_AIR;
      IF n_count != 1 THEN
            prm_ErrorMsg := '��λ���Ϊ['|| prm_aab001 ||']�ĵ�λ���������걨���޸���Ϣ!';
            RETURN;
      END IF;

      --��ȡ��λ�޸���Ϣ�ı��
      SELECT max(a.iab001)
           into v_iab001
           FROM wsjb.IRAB01  a,wsjb.AE02  b
          WHERE a.aab001 = prm_aab001
          AND a.aaz002 = b.aaz002
          AND b.aaa121 = PKG_Constant.AAA121_EIM
          AND a.iaa002 = PKG_Constant.IAA002_AIR;

      --ɾ���Ѿ�д����޸���Ϣ
      DELETE FROM IRAD32
       WHERE iaz012 = (SELECT iaz012 from irad31 where iaz007 = v_iab001);

      DELETE FROM IRAD31
       WHERE iaz007 = v_iab001;

      --�����걨���κ�
      SELECT distinct(iaz004)
        INTO v_iaz004
        FROM wsjb.IRAD02
        WHERE iaz007 = v_iab001
       AND iaa020 = PKG_Constant.IAA020_DW
       AND iaa015 = PKG_Constant.IAA015_WAD
       AND iaa016 = PKG_Constant.IAA016_DIR_NO;

      --ɾ���걨��Ϣ
      DELETE FROM wsjb.IRAD02
       WHERE iaz007 = v_iab001
       AND iaa020 = PKG_Constant.IAA020_DW
       AND iaa016 = PKG_Constant.IAA016_DIR_NO;

      DELETE FROM wsjb.IRAD01
       WHERE iaz004 = v_iaz004;

      --ɾ����־
      DELETE FROM wsjb.AE02
       WHERE aaz002 = (SELECT aaz002 from wsjb.IRAB01  where iab001 = v_iab001);

      --ɾ���޸ļ�¼
      DELETE FROM wsjb.IRAB01
       WHERE iab001 = v_iab001;


      EXCEPTION
           -- WHEN NO_DATA_FOUND THEN
          -- WHEN TOO_MANY_ROWS THEN
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
           /*�رմ򿪵��α�*/
           ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;


   END prc_rollbackUnitInfoMaintain;



   /*****************************************************************************
   ** �������� : prc_rollbackPersonInfoMaintain
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �������޸���Ϣ����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-16   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_rollbackPersonInfoMaintain(
                prm_aac001     IN     irac01.aac001%TYPE,--���˱��
                prm_aab001     IN     irac01.aab001%TYPE,--��λ���
                prm_iac001     IN     irac01.iac001%TYPE,--�걨���
                prm_AppCode    OUT    VARCHAR2 ,
                prm_ErrorMsg   OUT    VARCHAR2 )
   IS
     n_count    NUMBER;
     v_aaz002   varchar2(15);
     v_iaz004   varchar2(15);
     v_iaz005   varchar2(15);
     v_iaz007   varchar2(15);
     v_iaz012   varchar2(15);

   BEGIN

     prm_AppCode  := PKG_Constant.GN_DEF_OK;
     prm_ErrorMsg := '';


     /*��Ҫ������У��*/
      IF prm_aac001 IS NULL THEN
         prm_ErrorMsg := '���˱�Ų���Ϊ��!';
         RETURN;
      END IF;


      --�Ƿ����IRAC01��λ���걨�޸���Ϣ
      SELECT COUNT(1)
           into n_count
           FROM wsjb.irac01  a,wsjb.AE02  b
          WHERE a.iac001 = prm_iac001
          AND a.aaz002 = b.aaz002
          AND b.aaa121 = PKG_Constant.AAA121_PIM
          AND a.iaa002 = PKG_Constant.IAA002_AIR;
      IF n_count != 1 THEN
            prm_ErrorMsg := '���˱��Ϊ['|| prm_aac001 ||']����Ա���������걨���޸���Ϣ!';
            RETURN;
      END IF;

      --��ȡ��Ա��Ϣ�޸�ҵ����־ID
      SELECT a.aaz002
        INTO v_aaz002
        FROM wsjb.irac01  a
       WHERE a.iac001 = prm_iac001
         AND  a.iaa001 = PKG_Constant.IAA001_MDF
         AND  a.iaa002 = PKG_Constant.IAA002_AIR;
      IF v_aaz002 IS NULL THEN
         prm_ErrorMsg := 'û�л�ȡ������Ա��Ϣ�޸ĵ�ҵ����־������ϵά����Ա!';
         RETURN;
      END IF;

      --��ȡ��Ա��Ϣ�޸��걨����ID
      SELECT a.iaz004
        INTO v_iaz004
        FROM wsjb.IRAD01  a
        WHERE a.aaz002 = v_aaz002
        AND a.iaa011 = PKG_Constant.IAA011_PIM
        AND a.aab001 = prm_aab001;
        IF v_iaz004 IS NULL THEN
          prm_ErrorMsg := '��ȡ�걨[����]ID���ִ���,����ϵά����Ա����!';
        RETURN;
      END IF;
      --��ȡ�걨��ϸID
       SELECT a.iaz005 ,a.iaz007
       INTO v_iaz005 ,v_iaz007
       FROM wsjb.IRAD02  a
       WHERE a.iaz008 = prm_aac001
       AND a.iaz004 = v_iaz004
       AND a.iaa020 = PKG_Constant.IAA020_GR
       AND a.iaa015 = PKG_Constant.IAA015_WAD
       AND a.iaa016 = PKG_Constant.IAA016_DIR_NO;
       IF v_iaz005 IS NULL OR v_iaz007 IS NULL THEN
       prm_ErrorMsg:= '��ȡ�걨��ϸID���߻�����ϢID���ִ���,����ϵά����Ա����!';
       RETURN;
      END IF;
      --��ȡ��ʷ�޸�ID
      SELECT a.iaz012
        INTO v_iaz012
        FROM irad31 a
       WHERE a.aaz002 = v_aaz002
       AND a.iaz007 = v_iaz007
       AND a.aab001 = prm_aab001
       AND a.iaa011 = PKG_Constant.IAA011_PIM
       AND a.iaa019 = PKG_Constant.IAA019_IR;
       IF v_iaz012 IS NULL THEN
       prm_ErrorMsg:= '��ȡ��ʷ�¼�ID����,����ϵά����Ա!';
       RETURN;
       END IF;

      --ɾ���Ѿ�д����޸���Ϣ
      DELETE FROM IRAD32
       WHERE iaz012 = v_iaz012;

      DELETE FROM IRAD31
       WHERE iaz007 = v_iaz007
         AND  iaz012 = v_iaz012;


      --ɾ���걨��Ϣ
      DELETE  FROM wsjb.IRAD02
       WHERE iaz005 = v_iaz005;

      DELETE FROM wsjb.IRAD01
       WHERE iaz004 = v_iaz004;

      --ɾ����־
      DELETE FROM wsjb.AE02
       WHERE aaz002 = v_aaz002;

      --ɾ���޸ļ�¼
      DELETE FROM wsjb.irac01
       WHERE iac001 = prm_iac001;


      EXCEPTION
           -- WHEN NO_DATA_FOUND THEN
          -- WHEN TOO_MANY_ROWS THEN
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
           /*�رմ򿪵��α�*/
           ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;


   END prc_rollbackPersonInfoMaintain;


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
                                 prm_iaz018     IN     irac01a2.iaz018%TYPE,  --������������ID
                                 prm_AppCode    OUT    VARCHAR2  ,
                                 prm_ErrorMsg   OUT    VARCHAR2 )

   IS
     n_count    number(5);
     v_iac001   varchar2(15);
     v_aac001   varchar2(15);
     v_aab001   varchar2(15);
     v_aab004   varchar2(120);
     var_flag   number(1);
     v_aac002   varchar2(20);
     v_aac002_l varchar2(20);
     v_aac002_u varchar2(20);
     v_aac002d  varchar2(20);
     d_aac006   DATE;
     v_aac004   varchar2(6);
     v_aae110   varchar2(6);
     v_aae120   varchar2(6);
     v_aae210   varchar2(6);
     v_aae310   varchar2(6);
     v_aae410   varchar2(6);
     v_aae510   varchar2(6);
     v_aae311   varchar2(6);
     v_aae810   VARCHAR2(6);
     v_message  varchar2(2000);
     v_yac168   varchar2(6);
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
              aae100
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
       FROM wsjb.IRAB01
       WHERE aab001 = prm_aab001;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '��λ���Ϊ['|| prm_aab001 ||']�ĵ�λ��Ϣ������!';
       RETURN;
    END IF;





    --�ж��Ƿ��������������Ϣ
    SELECT COUNT(1)
       into n_count
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
       v_message := null;
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
--               xasi2_zs.pkg_P_Comm_CZ.prc_P_getID( UPPER(REC_TMP_PERSON.aac002),   --�������֤
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
         v_message := v_message||'���֤�����ظ�;';
         var_flag   := 1;
      END IF;
      --18λ���֤���Ƿ��²α�У��
      SELECT COUNT(1)
        INTO n_count
        FROM  wsjb.irac01  a
      WHERE  a.aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d);

        IF n_count >0 THEN

        SELECT aab001
        INTO  v_aab001
        FROM wsjb.irac01
        WHERE aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
        AND  rownum = 1;

        IF v_aab001 IS NOT NULL THEN
            SELECT aab004
            INTO v_aab004
            FROM wsjb.IRAB01
            WHERE aab001 = v_aab001
              AND rownum = 1;
        END IF;

        v_message := v_message||'����Ա��'||v_aab004||'['||v_aab001||']���걨��¼���������²α����룡';
        var_flag  := 1;
        END IF;

      --18λ���֤���Ƿ��²α�У��
      SELECT COUNT(1)
        INTO n_count
        FROM xasi2.ac01 a
      WHERE  a.aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d);

        IF n_count >0 THEN
          SELECT aac001
          INTO v_aac001
          FROM xasi2.ac01
          WHERE aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
            AND aae120 = '0'
            AND rownum = 1;

          IF v_aac001 IS NOT NULL THEN
              SELECT aab001
              INTO v_aab001
              FROM xasi2.ac02
              WHERE aac001 = v_aac001
                AND rownum = 1;

              IF v_aab001 IS NOT NULL THEN
                  SELECT aab004
                  INTO v_aab004
                  FROM xasi2.ab01
                  WHERE aab001 = v_aab001;
              END IF;
          END IF;
          v_message := v_message||'����Ա��'||v_aab004||'['||v_aab001||']�вα���¼���������²α����룡';
          var_flag  := 1;
        END IF;


       IF REC_TMP_PERSON.aab001 IS NULL THEN
         v_message := v_message||'û���ҵ���λ��ţ�';
         var_flag  := 1;
       END IF;

       SELECT COUNT(1)
       INTO n_count
       FROM xasi2.ab01
       WHERE aab001 = REC_TMP_PERSON.aab001;
       IF n_count = 0 THEN
         v_message := v_message||'û���ҵ���λ��Ϣ';
         var_flag  := 1;
       END IF;

       SELECT COUNT(1)
       INTO n_count
       FROM wsjb.IRAB01
       WHERE aab001 = REC_TMP_PERSON.aab001;
       IF n_count = 0 THEN
         v_message := v_message||'û���ҵ�������λ��Ϣ';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac003 IS NULL THEN
         v_message := v_message||'������������Ϊ�գ�';
         var_flag  := 1;
       END IF;
       IF REC_TMP_PERSON.aac004 IS NOT NULL THEN
         IF REC_TMP_PERSON.aac004 <> '1' AND REC_TMP_PERSON.aac004 <> '2' AND REC_TMP_PERSON.aac004 <> '9' THEN
              v_message := v_message||'�Ա���ֵ����!';
              var_flag  := 1;
         END IF;
       END IF;

       IF REC_TMP_PERSON.aac005 IS  NOT  NULL THEN
         IF  LENGTH(trim(REC_TMP_PERSON.aac005)) <> 2 THEN
              v_message := v_message||'��ֵ��ֵ����!';
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

       IF REC_TMP_PERSON.aac010 IS NULL AND LENGTH(REC_TMP_PERSON.aac010)< 8 THEN
         v_message := v_message||'������ַ����Ϊ��,����������8λ��';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aae006 IS NULL AND LENGTH(REC_TMP_PERSON.aae006)< 8 THEN
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
            IF REC_TMP_PERSON.aac012 <> '1' AND REC_TMP_PERSON.aac012 <> '4' THEN
                  v_message := v_message||'���������ֵ����!';
                  var_flag  :=1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.yac168 IS NULL THEN
         v_message := v_message||'�����񹤱�־����Ϊ�գ�';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.yac168 <> '0' AND REC_TMP_PERSON.yac168 <> '1' THEN
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
        --��ҵְ�����ϱ���У��
       IF REC_TMP_PERSON.aae110 IS NOT NULL THEN
               SELECT COUNT(1)
               INTO n_count
               FROM  wsjb.IRAB01  a,wsjb.AE02  b
               WHERE a.aaz002 = b.AAZ002
                  AND b.aaa121 = PKG_Constant.AAA121_NER
                  AND a.aab001 = prm_aab001;
               IF n_count > 0 THEN
                   SELECT nvl(a.aae110,'0')
                     INTO  v_aae110
                     FROM wsjb.IRAB01  a,wsjb.AE02  b
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
            ElSE
                  v_aae120 := '0';
            END IF;

           IF  (v_aae120 = '0' AND REC_TMP_PERSON.aae120 = '1') THEN
             v_message := v_message||'���ڵ�λû�вμӻ�����ҵ���ϱ���!';
             var_flag := 1;
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
            ElSE
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
            ElSE
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
            ElSE
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
            ElSE
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
            ElSE
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
            ElSE
                  v_aae810 := '0';
            END IF;

           IF  (v_aae810 = '0' AND REC_TMP_PERSON.aae810 = '1') THEN
             v_message := v_message||'���ڵ�λû�вμӹ���Ա��������!';
             var_flag := 1;
           END IF;

           IF NVL(REC_TMP_PERSON.yaa333,0) <= 0 THEN
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
       IF v_aae210 = '2' AND v_aae510 = '2' AND v_aae311 = '2' AND v_aae310 = '2' THEN

             IF REC_TMP_PERSON.aae310 = '1' THEN
                   IF  REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae510 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                        v_message := v_message||'ҽ�ơ�ʧҵ�����������������ֱ���һ��α�!';
                        var_flag  := 1;
                   END IF;
             END IF;

             IF REC_TMP_PERSON.aae210 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae510 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                        v_message := v_message||'ҽ�ơ�ʧҵ�����������������ֱ���һ��α�!';
                        var_flag  := 1;
                   END IF;
             END IF;

             IF REC_TMP_PERSON.aae510 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                        v_message := v_message||'ҽ�ơ�ʧҵ�����������������ֱ���һ��α�!';
                        var_flag  := 1;
                   END IF;
             END IF;

             IF REC_TMP_PERSON.aae311 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae510 = '0' THEN
                        v_message := v_message||'ҽ�ơ�ʧҵ�����������������ֱ���һ��α�!';
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
            IF REC_TMP_PERSON.aac030 > sysdate THEN
                  v_message:= v_message||'����λ�α�ʱ�䲻������ϵͳʱ��!';
                  var_flag := 1;
          END IF;
       END IF;

      IF REC_TMP_PERSON.yac033 IS NOT NULL THEN
            IF REC_TMP_PERSON.yac033 > sysdate THEN
                  v_message:= v_message||'����λ�α�ʱ�䲻������ϵͳʱ��!';
                  var_flag := 1;
          END IF;
       END IF;

       IF REC_TMP_PERSON.aac007 IS NOT NULL THEN
            IF REC_TMP_PERSON.aac007 > sysdate THEN
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
      END IF;

      IF LENGTH(TRIM(v_aac002)) = 15 THEN
            SELECT to_date(( '19' ||  substr(v_aac002,7,6)) ,'yyyy-mm-dd')
              INTO d_aac006
              FROM dual;
            SELECT decode(mod(to_number(substr(TRIM(v_aac002),15,1)),2),1,'1',0,'2','9')
              INTO v_aac004
              FROM dual;
      END IF;

      SELECT decode('10','20','1','0')
        INTO v_yac168
        FROM dual;

     IF var_flag = 0 THEN
        --��ȡIRAC01A2�����ݵ�IRAC01
          v_iac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAC001');
         BEGIN
          --��дirac01a2 ԭ��Ϊ�ɹ�
            UPDATE IRAC01A2  a
              SET  a.errormsg = '���ݿ��Ե���'
             WHERE a.iaz018 = prm_iaz018
               AND a.aac002 = REC_TMP_PERSON.aac002
               AND a.aac003 = REC_TMP_PERSON.aac003;

       END;
     ElSIF var_flag = 1 THEN
          --��дirac01a2 ��дʧ��ԭ��
            UPDATE IRAC01A2  a
              SET  a.errormsg = v_message
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
   prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
   RETURN;
   END prc_batchImportView;




   /*****************************************************************************
   ** �������� : prc_pensionImp
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ���������������Ϣ
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001     IN     irab01.aab001%TYPE,--��λ���
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-17   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_pensionImp(prm_aaz002     IN     ae02.aaz002%TYPE,--��־ID
                            prm_aae011     IN     ae02.aae011%TYPE,  --������
                            prm_aab001     IN     xasi2.ab01.aab001%TYPE,
                            prm_AppCode    OUT    VARCHAR2,
                            prm_ErrorMsg   OUT    VARCHAR2)
   IS
     n_count    NUMBER;
     v_msg      VARCHAR2(2000);
     v_aae100   VARCHAR2(1);
     v_aac001   VARCHAR2(20);
     v_aac002   VARCHAR2(20);
     v_aac002_l   VARCHAR2(20);
     v_aac002_u   VARCHAR2(20);
     v_aac002d  VARCHAR2(20);
     cursor c_cur  IS SELECT a.aaz184,a.aab001,a.aac002,a.aac003,a.yac004
     FROM IRAC36 a WHERE a.AAZ002 = prm_aaz002;

   BEGIN

     prm_AppCode  := PKG_Constant.GN_DEF_OK;
     prm_ErrorMsg := '';
     n_count      := 0;


     /*��Ҫ������У��*/
      IF prm_aaz002 IS NULL THEN
         prm_ErrorMsg := 'ҵ����־ID����Ϊ��!';
         RETURN;
      END IF;

      IF prm_aae011 IS NULL THEN
         prm_ErrorMsg := '�����˲���Ϊ��!';
         RETURN;
      END IF;

      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '��λ�籣�����벻��Ϊ��!';
         RETURN;
      END IF;

      --�Ƿ��������ͬ����Ϣ
      SELECT COUNT(1) INTO n_count FROM
          IRAC36 a WHERE a.aaz002 = prm_aaz002;
         IF n_count = 0 THEN
          prm_AppCode  :=  gn_def_ERR;
          prm_ErrorMsg := 'û���ҵ������ε�����ͬ����Ϣ������';
          RETURN;
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
                  prm_aaz002,
                  PKG_Constant.AAA121_PSM,
                  prm_aae011,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae011,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate
                 );


      --У������
      FOR cur_result in c_cur LOOP
        v_aac001 := '';
        v_msg := '';
        v_aae100 := '1';

        --�Ƿ����AB01��λ��Ϣ
        SELECT COUNT(1)
             into n_count
             FROM xasi2.ab01
            WHERE aab001 = cur_result.aab001;
        IF n_count = 0 THEN
              v_msg := v_msg||'û���ҵ���λ'||cur_result.aab001||';';
              v_aae100 := '0';
        END IF;




      /**��������**/
      --���֤�ǿ�У��
       IF cur_result.aac002 IS NULL THEN
         v_msg := v_msg ||'���֤���벻��Ϊ��;';
         v_aae100 := '0';
       END IF;
      --���֤λ������
       IF LENGTH(trim(cur_result.aac002)) = 18  THEN
               xasi2.pkg_P_Comm_CZ.prc_P_getID( UPPER(cur_result.aac002),   --�������֤
                                       v_aac002,   --�������֤
                                       prm_AppCode,   --�������
                                       prm_ErrorMsg) ;  --��������
               IF prm_AppCode <> PKG_Constant.GN_DEF_OK THEN
                   v_msg := v_msg || prm_ErrorMsg;
                   prm_AppCode := PKG_Constant.GN_DEF_OK;
                   prm_ErrorMsg := '';
                   v_aae100 := '0';
               END IF;

          SELECT  substr(trim(cur_result.aac002),1,6) || substr(trim(cur_result.aac002),9,9)
            INTO v_aac002d
            FROM dual;

          SELECT  UPPER(v_aac002)
            INTO  v_aac002_u
            FROM  dual;

          SELECT  LOWER(v_aac002)
            INTO  v_aac002_l
            FROM  dual;
       ElSIF LENGTH(trim(cur_result.aac002)) = 15 THEN
               xasi2.pkg_P_Comm_CZ.prc_P_getID( UPPER(cur_result.aac002),   --�������֤
                                       v_aac002,   --�������֤
                                       prm_AppCode,   --�������
                                       prm_ErrorMsg) ;  --��������
               IF prm_AppCode <> PKG_Constant.GN_DEF_OK THEN
                   v_msg := v_msg || prm_ErrorMsg;
                   prm_AppCode := PKG_Constant.GN_DEF_OK;
                   prm_ErrorMsg := '';
                   v_aae100 := '0';
               END IF;

          SELECT  UPPER(v_aac002)
            INTO  v_aac002_u
            FROM  dual;

          SELECT  LOWER(v_aac002)
            INTO  v_aac002_l
            FROM  dual;
           v_aac002d := trim(cur_result.aac002);

       ELSE
             v_msg := v_msg||cur_result.aac002||'���֤λ�����Ϸ�;';
             v_aae100 := '0';
       END IF;

        --�Ƿ����AC01��λ��Ϣ
        SELECT COUNT(1)
             into n_count
             FROM xasi2.ac01
            WHERE aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d);
        IF n_count = 0 THEN
              v_msg := v_msg||'û���ҵ���Ա'||cur_result.aac002||';';
              v_aae100 := '0';
        END IF;


        --�Ƿ����AC01��Ϣ
        SELECT COUNT(1)
             into n_count
             FROM xasi2.ac01 a,xasi2.ac02 b
            WHERE a.aac001 = b.aac001
            AND b.aab001 = cur_result.aab001
            AND a.aac003 = cur_result.aac003
            AND a.aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d);

        IF n_count = 0 THEN
              v_msg := v_msg||'û���ҵ���λ '||cur_result.aab001||' �µ���Ա '||cur_result.aac003||cur_result.aac002||';';
              v_aae100 := '0';
        END IF;

         BEGIN

          SELECT aac001
             into v_aac001
             FROM xasi2.ac01
            WHERE aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d);

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_msg := v_msg||'��Ա��Ϣ��������ϵά����Ա��;';
              v_aae100 := '0';
            WHEN TOO_MANY_ROWS THEN
              v_msg := v_msg||'��Ա��Ϣ��������ϵά����Ա��;';
              v_aae100 := '0';
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
           /*�رմ򿪵��α�*/

            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
         END;

        IF cur_result.yac004 < 1953 THEN
              v_msg := v_msg||'���ϻ�����������1953;';
              v_aae100 := '0';
        END IF;

        IF cur_result.yac004 > 9760 THEN
              v_msg := v_msg||'���ϻ�����������9760;';
              v_aae100 := '0';
        END IF;

        --����У����Ϣ
        IF v_aae100 = '0' THEN
          UPDATE wsjb.IRAC36  SET
          aae100 = v_aae100,
          errmsg = v_msg
          WHERE aaz184 = cur_result.aaz184;
        END IF;

        IF v_aae100 = '1' THEN

          UPDATE wsjb.IRAC36  SET
          aac001 = v_aac001,
          aae100 = v_aae100,
          errmsg = v_msg
          WHERE aaz184 = cur_result.aaz184;

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
            prm_ErrorMsg := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;


   END prc_pensionImp;





   /*****************************************************************************
   ** �������� : prc_pensionMaintainImp
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ���������������Ϣ
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001     IN     irab01.aab001%TYPE,--��λ���
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-17   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_pensionMaintainImp(prm_aaz002     IN     ae02.aaz002%TYPE,--��־ID
                                    prm_aae011     IN     ae02.aae011%TYPE,  --������
                                    prm_aab001     IN     xasi2.ab01.aab001%TYPE,
                                    prm_aae035     IN     iraa09.iaa038%TYPE,
                                    prm_AppCode    OUT    VARCHAR2  ,
                                    prm_ErrorMsg   OUT    VARCHAR2 )
   IS
     n_count    NUMBER;
     v_msg      VARCHAR2(2000);
     v_aae100   VARCHAR2(1);
     v_aac001   VARCHAR2(20);
     v_iaz023   VARCHAR2(20);
     v_iaa040    NUMBER;
     v_iaa041    NUMBER;
     v_iaa042    NUMBER;
     cursor c_cur  IS SELECT a.aaz184,a.aab001,a.aac001,a.aac002,a.aac003,a.yac004
     FROM wsjb.IRAC36 a WHERE a.AAZ002 = prm_aaz002;

   BEGIN

     prm_AppCode  := PKG_Constant.GN_DEF_OK;
     prm_ErrorMsg := '';
     n_count      := 0;
     v_iaa040      := 0;
     v_iaa041      := 0;
     v_iaa042      := 0;


     /*��Ҫ������У��*/
      IF prm_aaz002 IS NULL THEN
         prm_ErrorMsg := 'ҵ����־ID����Ϊ��!';
         RETURN;
      END IF;

      IF prm_aae011 IS NULL THEN
         prm_ErrorMsg := '�����˲���Ϊ��!';
         RETURN;
      END IF;

      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '��λ�籣�����벻��Ϊ��!';
         RETURN;
      END IF;

      --�Ƿ�����Ȩ
      SELECT count(1)
          INTO n_count
      FROM
          wsjb.IRAA08 a,wsjb.IRAA09 b
      WHERE a.iaz022 = b.iaz022
      AND b.iaa042 > 0
      AND to_number(to_char(b.iaa038,'yyyyMMdd')) <= to_number(to_char(prm_aae035,'yyyyMMdd'))
      AND to_number(to_char(b.iaa039,'yyyyMMdd')) >= to_number(to_char(prm_aae035,'yyyyMMdd'))
      AND b.iaz008 = prm_aab001;

      IF n_count != 1 THEN
          prm_AppCode  :=  gn_def_ERR;
          prm_ErrorMsg := '��Ȩ��Ϣ���󣡣���'||to_number(to_char(prm_aae035,'yyyyMMdd'));
          RETURN;
         END IF;

      --��ȡ��Ȩ��Ϣ
      SELECT b.iaz023,b.iaa040,b.iaa041,b.iaa042
          INTO v_iaz023,v_iaa040,v_iaa041,v_iaa042
      FROM
          wsjb.IRAA08 a,wsjb.IRAA09 b
      WHERE a.iaz022 = b.iaz022
      AND b.iaa042 > 0
      AND to_number(to_char(b.iaa038,'yyyyMMdd')) <= to_number(to_char(prm_aae035,'yyyyMMdd'))
      AND to_number(to_char(b.iaa039,'yyyyMMdd')) >= to_number(to_char(prm_aae035,'yyyyMMdd'))
      AND b.iaz008 = prm_aab001;

      IF v_iaa042 = 0 THEN
          prm_AppCode  :=  gn_def_ERR;
          prm_ErrorMsg := 'ʣ��������󣡣���';
          RETURN;
        END IF;

      --�Ƿ��������ͬ����Ϣ
      SELECT COUNT(1) INTO n_count FROM
          wsjb.IRAC36 a WHERE a.aaz002 = prm_aaz002;
         IF n_count = 0 THEN
          prm_AppCode  :=  gn_def_ERR;
          prm_ErrorMsg := 'û���ҵ������ε�����ͬ����Ϣ������';
          RETURN;
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
                  prm_aaz002,
                  PKG_Constant.AAA121_PSM,
                  prm_aae011,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae011,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate
                 );


      --У������
      FOR cur_result in c_cur LOOP
        v_aac001 := '';
        v_msg := '';
        v_aae100 := '1';

        --�Ƿ����AB01��λ��Ϣ
        SELECT COUNT(1)
             into n_count
             FROM xasi2.ab01
            WHERE aab001 = prm_aab001;
        IF n_count = 0 THEN
              v_msg := v_msg||'û���ҵ���λ'||prm_aab001||';';
              v_aae100 := '0';
        END IF;

        --�Ƿ����AC01��λ��Ϣ
        SELECT COUNT(1)
             into n_count
             FROM xasi2.ac01
            WHERE aac002 = cur_result.aac002;
        IF n_count = 0 THEN
              v_msg := v_msg||'û���ҵ���Ա'||cur_result.aac002||';';
              v_aae100 := '0';
        END IF;

        --�Ƿ����AC01��Ϣ
        SELECT COUNT(1)
             into n_count
             FROM xasi2.ac01 a,xasi2.ac02 b
            WHERE a.aac001 = b.aac001
            AND b.aab001 = prm_aab001
            AND a.aac003 = cur_result.aac003
            AND a.aac002 = cur_result.aac002
            AND a.aac001 = cur_result.aac001;

        IF n_count = 0 THEN
              v_msg := v_msg||'û���ҵ���λ '||prm_aab001||' �µ���Ա '||cur_result.aac003||cur_result.aac002||';';
              v_aae100 := '0';
        END IF;

        --�Ƿ����IRAC01A3��Ϣ
        SELECT COUNT(1)
             into n_count
             FROM wsjb.IRAC01A3 a
            WHERE a.aab001 = prm_aab001
            AND a.aac003 = cur_result.aac003
            AND a.aac002 = cur_result.aac002
            AND a.aac001 = cur_result.aac001;

        IF n_count = 0 THEN
              v_msg := v_msg||'û���ҵ���λ '||prm_aab001||' �µ���Ա '||cur_result.aac003||cur_result.aac002||'��������Ϣ;';
              v_aae100 := '0';
        END IF;

        IF cur_result.yac004 < 1953 THEN
              v_msg := v_msg||'���ϻ�����������1953;';
              v_aae100 := '0';
        END IF;

        IF cur_result.yac004 > 9760 THEN
              v_msg := v_msg||'���ϻ�����������9760;';
              v_aae100 := '0';
        END IF;

        --����У����Ϣ
        IF v_aae100 = '0' THEN
          UPDATE wsjb.IRAC36  SET
          aae100 = v_aae100,
          errmsg = v_msg
          WHERE aaz184 = cur_result.aaz184;
        END IF;

        IF v_aae100 = '1' THEN

          UPDATE wsjb.IRAC01A3  SET
          yac004 = cur_result.yac004
          WHERE aab001 = prm_aab001
          AND aac001 = cur_result.aac001;

          UPDATE wsjb.IRAC36  SET
          aae100 = v_aae100
          WHERE aaz184 = cur_result.aaz184;
        END IF;
      END LOOP;

      v_iaa041 := v_iaa041 + 1;
      v_iaa042 := v_iaa042 - 1;

      UPDATE wsjb.IRAA09  SET
      iaa040 = v_iaa040,
      iaa041 = v_iaa041,
      iaa042 = v_iaa042
      WHERE iaz023 = v_iaz023;

      EXCEPTION
          -- WHEN NO_DATA_FOUND THEN
          -- WHEN TOO_MANY_ROWS THEN
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
           /*�رմ򿪵��α�*/
           ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
           RETURN;
   END prc_pensionMaintainImp;
  /*****************************************************************************
   ** �������� : prc_AuditRecoveryandSuspendPayment
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����Ա�ָ���ͣ�ɷ����[���Ķ�]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aaa121       IN     ae02.aaa121%TYPE,--ҵ�����ͱ���
   **           prm_iaa011       IN     iraa02.iaa011%TYPE,--ҵ������
   **           prm_iaa003       IN     iraa02.iaa003%TYPE,--ҵ������
   **           prm_iaa004       IN     iraa02.iaa011%TYPE,--��˱�־
   **           prm_iaa028       IN     VARCHAR2          ,--�Ƿ�ȫ��
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_aae013       IN     iraa02.aae013%TYPE,--��ע
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�zhangwj         �������� ��2012-08-29   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_AuditRecoverySuspend (
      prm_aaa121       IN     ae02.aaa121%TYPE,--ҵ�����ͱ���
      prm_iaa011       IN     iraa02.iaa011%TYPE,--ҵ������
      prm_iaa003       IN     iraa02.iaa003%TYPE,--ҵ������
      prm_iaa018       IN     irad22.iaa018%TYPE,--��˱�־
      prm_iaa028       IN     VARCHAR2          ,--�Ƿ�ȫ��
      prm_aae011       IN     iraa02.iaa011%TYPE,--������
      prm_aae013       IN     iraa02.aae013%TYPE,--��ע
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      n_count    number(5);
      v_iaz011   varchar2(15);
      v_iaz009   varchar2(15);
      v_iaz010   varchar2(15);
      v_aaz002   varchar2(15);
      v_iaa015   varchar2(1);
      v_iaa004   number(1);
      v_iaa014   number(1);
      v_iaa017   number(1);
      v_yae099   varchar2(15);

      --�����α꣬��ȡ���������Ա��Ϣ
      CURSOR cur_tmp_person IS
      SELECT a.IAC001, --�걨��Ա��Ϣ���,VARCHAR2
             b.AAC001, --���˱��,VARCHAR2
             a.AAB001, --��λ���,VARCHAR2
             a.AAC002, --������ݺ���,VARCHAR2
             a.AAC003, --����,VARCHAR2
             b.IAA001, --��Ա���
             a.IAZ005, --�걨��ϸID
             a.IAA003  --ҵ������
        FROM wsjb.IRAD22_TMP  a,wsjb.IRAC01  b --���������Ա��Ϣ��ʱ��
       WHERE a.iac001 = b.iac001
        ORDER by a.iaa003;

   BEGIN

      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;


      /*�����ʱ���Ƿ��������*/
      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.IRAD22_TMP ;
      IF n_count = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'�����ʱ���޿�������!';
         RETURN;
      END IF;


      /*��Ҫ������У��*/
      IF prm_iaa011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'ҵ�����Ͳ���Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa003 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'ҵ�����岻��Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa018 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'��˱�־����Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa028 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'��־[�Ƿ�ȫ��]����Ϊ��!';
         RETURN;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
      IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�AAZ002!';
         RETURN;
      END IF;

      v_iaz009 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ009');
      IF v_iaz009 IS NULL OR v_iaz009 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�IAZ009!';
         RETURN;
      END IF;

      --����¼�
      INSERT INTO wsjb.IRAD21
                 (
                  IAZ009,
                  AAZ002,
                  IAA011,
                  AEE011,
                  AAE035,
                  YAB003,
                  AAE013
                  )
                  VALUES
                  (
                  v_iaz009,
                  v_aaz002,
                  prm_iaa011,
                  prm_aae011,
                  sysdate,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae013
      );

      FOR REC_TMP_PERSON IN cur_tmp_person LOOP

         --�걨�����Ǹ���ʱУ�飺���뵥λ��Ϣ���ͨ�����ܰ���
         IF REC_TMP_PERSON.iaa003 = PKG_Constant.IAA003_PER THEN
            SELECT COUNT(1)
              INTO n_count
              FROM wsjb.IRAB01
             WHERE AAB001 = REC_TMP_PERSON.AAB001
               AND IAA002 = PKG_Constant.IAA002_APS;
            IF n_count = 0 THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'��λ��Ϣ���ͨ�����ܰ���ҵ��!';
               RETURN;
            END IF;
         END IF;

          /*
            �����Ա����Ϣ���
            ���԰�����Ǵ�� ͨ�� ��ͨ�� ����ͨ�� ȫ��ͨ�� ȫ��ͨ��
         */

         --�����ϸ����
         v_iaz010 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ010');
         IF v_iaz010 IS NULL OR v_iaz010 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�IAZ010!';
            RETURN;
         END IF;

         --��ѯ�ϴ�������
         BEGIN
            SELECT IAA015
              INTO v_iaa015
              FROM wsjb.IRAD02
             WHERE IAZ005 = REC_TMP_PERSON.IAZ005;

            IF v_iaa015 in (PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
              prm_ErrorMsg := PRE_ERRCODE ||'����Ѿ��ս�!';
              RETURN;
           END IF;

            --��ȡ�ϴ������Ϣ
            IF v_iaa015 = PKG_Constant.IAA015_ADI THEN
               BEGIN
                  SELECT A.IAZ010,
                         A.IAA004,
                         A.IAA014,
                         A.IAA017
                    INTO v_iaz011,
                         v_iaa004,
                         v_iaa014,
                         v_iaa017
                    FROM wsjb.IRAD22  A
                   WHERE A.IAA018 NOT IN (
                                          PKG_Constant.IAA018_DAD, --���[�������]
                                          PKG_Constant.IAA018_NPS  --��ͨ�� Not Pass
                                         )
                     AND A.IAZ005 = REC_TMP_PERSON.IAZ005
                     AND A.IAZ010 = (
                                      SELECT MAX(IAZ010)
                                        FROM wsjb.IRAD22
                                       WHERE IAZ005 = A.IAZ005
                                         AND IAA018 = A.IAA018
                                    );
                  EXCEPTION
                  WHEN OTHERS THEN
                     ROLLBACK;
                     prm_AppCode  := gn_def_ERR;
                     prm_ErrorMsg := PRE_ERRCODE ||'�걨��Ϣ��������У���δ��ȡ���ϴ������Ϣ,��ȷ���ϴ�����Ƿ��ս�!';
                     RETURN;
               END;

               v_iaa014 := v_iaa017;
               v_iaa017 := v_iaa017 + 1;
               IF v_iaa017 > v_iaa004 THEN
                  v_iaa017 := v_iaa004;
               END IF;

               --��˼��ε��ڵ�ǰ����
               IF v_iaa004 = v_iaa014 AND v_iaa004 = v_iaa017 THEN
                  ROLLBACK;
                  prm_AppCode  := gn_def_ERR;
                  prm_ErrorMsg := PRE_ERRCODE ||'����Ѿ��ս�!';
                  RETURN;
               END IF;
            END IF;

            --��ȡ�걨��ϸ��Ϣ
            IF v_iaa015 = PKG_Constant.IAA015_WAD THEN
               BEGIN
                  SELECT A.IAA004,
                         A.IAA014
                    INTO v_iaa004,
                         v_iaa014
                    FROM wsjb.IRAD02  A
                   WHERE A.IAZ005 = REC_TMP_PERSON.IAZ005;
                  EXCEPTION
                  WHEN OTHERS THEN
                     ROLLBACK;
                     prm_AppCode  := gn_def_ERR;
                     prm_ErrorMsg := PRE_ERRCODE ||'û����ȡ���걨��ϸ��Ϣ!';
                     RETURN;
               END;
               v_iaz011 := v_iaz010;
               v_iaa014 := v_iaa014 + 1;
               v_iaa017 := v_iaa014 + 1;
               IF v_iaa017 > v_iaa004 THEN
                  v_iaa017 := v_iaa004;
               END IF;
            END IF;

            EXCEPTION
            WHEN OTHERS THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := '�����Ϣ��ȡ����:'|| PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace  ;
               RETURN;
         END;

         --�����ϸд��
         INSERT INTO wsjb.IRAD22
                    (
                     IAZ010,
                     IAZ011,
                     IAZ009,
                     IAZ005,
                     IAA004,
                     IAA014,
                     IAA017,
                     AAE011,
                     AAE035,
                     YAB003,
                     IAA018,
                     IAD005,    --������
                     AAE013
                     )
                    VALUES
                    (
                     v_iaz010,
                     v_iaz011,
                     v_iaz009,
                     REC_TMP_PERSON.IAZ005,
                     v_iaa004,
                     v_iaa014,
                     v_iaa017,
                     prm_aae011,
                     sysdate,
                     PKG_Constant.YAB003_JBFZX,
                     prm_iaa018,
                     prm_aae013,  --������
                     null
         );

         --���
         IF prm_iaa018 = PKG_Constant.IAA018_DAD THEN

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_DAD,--���[�޸�����]
                   AAE013 = prm_aae013
             WHERE IAA015 = PKG_Constant.IAA015_WAD --����
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_ALR  --�Ѵ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --���δͨ��
         IF prm_iaa018 = PKG_Constant.IAA018_NPS THEN

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015  = PKG_Constant.IAA015_ADO, --������
                   AAE013  = prm_aae013
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --����/�����
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_NPS  --δͨ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --���ͨ��
         IF prm_iaa018 = PKG_Constant.IAA018_PAS AND v_iaa014 = v_iaa004 THEN

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015  =  PKG_Constant.IAA015_ADO --������
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --����/�����
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            v_yae099    := xasi2.PKG_comm.fun_GetSequence(NULL,'yae099');
            IF v_yae099 IS NULL OR v_yae099 = '' THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ��ϵͳ������к�:YAE099';
               RETURN;
            END IF;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_APS  --��ͨ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAC001 = REC_TMP_PERSON.IAC001;


               /*
                  ��Ա����[��Ա����]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_CIN THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[�²α� ����]
                     �Ϸ��� prc_AuditSocietyInsuranceRPer
                  */
                prc_PersonInsuContinue(v_yae099,
                                    REC_TMP_PERSON.AAB001,
                                    REC_TMP_PERSON.IAC001,
                                    prm_aae011,
                                    PKG_Constant.YAB003_JBFZX,
                                    sysdate,
                                    prm_AppCode,
                                    prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  ��Ա����[��Ա��ͣ�ɷ�]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_MIN THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[ͣ�� ����]
                     �Ϸ��� prc_AuditMonthInternetRpause
                  */

                  prc_PersonInsuPauseTS(v_yae099,
                                      REC_TMP_PERSON.AAB001,
                                      REC_TMP_PERSON.IAC001,
                                      prm_aae011,
                                      PKG_Constant.YAB003_JBFZX,
                                      sysdate,
                                      prm_AppCode,
                                      prm_ErrorMsg
                                      );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;
            END IF;
            --������ر�
            INSERT INTO wsjb.AE02A1
                        (
                         AAZ002,
                         YAE099,
                         IAA020,
                         AAB001,
                         AAC001,
                         IAA001
                        )
                  VALUES(
                        v_aaz002,
                        v_yae099,
                        REC_TMP_PERSON.iaa003,
                        REC_TMP_PERSON.AAB001,
                        REC_TMP_PERSON.IAC001,
                        REC_TMP_PERSON.IAA001
                        );
         END IF;

      END LOOP;

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
                  AAE218,
                  AAE013
                 )
                 VALUES
                 (
                  v_aaz002,
                  prm_aaa121,
                  prm_aae011,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae011,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate,
                  prm_aae013
                 );
   EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| PRE_ERRCODE || SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;
   END prc_AuditRecoverySuspend;


/*****************************************************************************
   ** �������� : prc_preview
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨�ɷ�Ԥ��
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_iaa100       IN     irac01a4.iaa100%TYPE,--�걨�¶�
   **           prm_aae110       IN     irac01a4.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-12   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
  PROCEDURE prc_preview (
      prm_aab001       IN     irab01.aab001%TYPE,
      prm_yae099       IN     VARCHAR2,
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
   var_procNo            VARCHAR2(2);          --�������
   var_aac001            xasi2.ac01.aac001%TYPE;     --���˱��
   var_aae140            xasi2.ac02.aae140%TYPE;     --����
   num_yac004            xasi2.ac02.aac040%TYPE;     --�ɷѻ���
   num_count             NUMBER;
   num_per_count         NUMBER;               --����
   num_nmg_count         NUMBER;               --��ʧҵ��ũ������
   num_aab120            xasi2.ab08.aab120%TYPE;     --�ɷѻ����ܶ�
   num_aab156            xasi2.ab08.aab156%TYPE;     --��λǷ�ѽ��
   num_person            xasi2.ab08.aab156%TYPE;     --���˽ɷѽ��
   num_danwei            xasi2.ab08.aab156%TYPE;     --��λ�ɷѽ��
   num_aaa041            NUMBER(13,4);         --���˽ɷѱ���
   num_aaa043            NUMBER(13,4);         --��λ�ɷѱ���
   var_yac168            xasi2.ac01.yac168%TYPE;     --ũ�񹤱�ʶ
   var_aaa040            xasi2.ab02.aaa040%TYPE;     --�������
   var_akc021            VARCHAR2(6);          --ҽ����Ա״̬
   var_aab019            VARCHAR2(6);          --��λ����
   --��ѯ����λδ�걨����Ա��Ϣ(�������ݿ�)
   CURSOR cur_ac02 IS
    SELECT aac001 AS aac001,
           yac004 AS yac004,
           aae140 AS aae140
      FROM xasi2.ac02
     WHERE aab001 = prm_aab001
       AND aac031 = '1'
       AND aae140 = var_aae140;
   CURSOR cur_aae140 IS
    SELECT aae140 AS aae140
      FROM xasi2.ab02
     WHERE aab001 = prm_aab001
       AND aab051 = '1';
   CURSOR cur_irac01 IS
    SELECT iac001 AS iac001,
           aac001 AS aac001,
           yac168 AS yac168,          --ũ�񹤱�ʶ
           yac005 AS yac005,          --�ɷѻ���
           yac004 AS yac004,          --���ϻ���
           aae110 AS aae110,          --ְ������
           aae120 AS aae120,          --��������
           aae210 AS aae210,          --ʧҵ
           aae310 AS aae310,          --ҽ��
           aae410 AS aae410,          --����
           aae510 AS aae510,          --����
           aae311 AS aae311           --���
      FROM wsjb.irac01
     WHERE aab001 = prm_aab001
       AND iaa001 IN ('1','5','6','8')   --�걨��Ա���
       AND iaa002 = '0'
       AND iaa100 IS NULL;             --�걨��Ա��Ϣ״̬
    BEGIN
    prm_AppCode    := gn_def_OK ;
    prm_ErrorMsg     := ''                  ;
    var_procNo     := '06';
    --�����������������
    FOR rec_aae140 IN cur_aae140 LOOP
        var_aae140 := rec_aae140.aae140;
        num_aab120 := 0;
        num_per_count := 0;
        num_nmg_count := 0;
        num_aab156 := 0;
        num_person := 0;
        num_danwei := 0;
         --��ȡ��λ�ɷѱ���
            IF var_aae140 = '03' THEN
               num_aaa043 := 0.07;
            ELSIF var_aae140 = '02' THEN
               num_aaa043 := 0.02;
            ELSIF var_aae140 = '04' THEN
               SELECT aaa040
                 INTO var_aaa040
                 FROM xasi2.ab02
                WHERE aab001 = prm_aab001
                  AND aae140 = var_aae140;
               IF var_aaa040 = '0401' THEN
                  num_aaa043 := 0.005;
               ELSIF var_aaa040 = '0402' THEN
                  num_aaa043 := 0.01;
               ELSE
                  num_aaa043 := 0.02;
               END IF;
            ELSIF var_aae140 = '05' THEN
              num_aaa043 := 0.005;
            ELSIF var_aae140 = '06' THEN
              num_aaa043 := 0.23;
            ELSE
              num_aaa043 := 0.8;
            END IF;
        --�жϼ�����Ա
        FOR rec_ac02 IN cur_ac02 LOOP
            var_aac001 := rec_ac02.aac001;
            num_yac004 := rec_ac02.yac004;

            --��ȡ�ɷѱ���
            IF var_aae140 = '03' THEN
               num_aaa041 := 0.02;
               num_aaa043 := 0.07;
               SELECT AKC021
                 INTO VAR_AKC021
                 FROM XASI2.KC01
                WHERE AAB001 = PRM_AAB001
                  AND AAC001 = REC_AC02.AAC001;
            ELSIF var_aae140 = '02' THEN
               --��ȡũ�񹤱�־
               SELECT yac168
                 INTO var_yac168
                 FROM xasi2.ac01
                WHERE aac001  = var_aac001;
               IF var_yac168 = '0' THEN
                  num_aaa041 := 0.01;
               ELSE
                  num_aaa041 := 0;
               END IF;
               num_aaa043 := 0.02;
            ELSIF var_aae140 = '04' THEN
               SELECT aaa040
                 INTO var_aaa040
                 FROM xasi2.ab02
                WHERE aab001 = prm_aab001
                  AND aae140 = var_aae140;
               IF var_aaa040 = '0401' THEN
                  num_aaa043 := 0.005;
               ELSIF var_aaa040 = '0402' THEN
                  num_aaa043 := 0.01;
               ELSE
                  num_aaa043 := 0.02;
               END IF;
               num_aaa041 := 0;
            ELSIF var_aae140 = '05' THEN
              num_aaa041 := 0;
              num_aaa043 := 0.005;
            ELSIF var_aae140 = '06' THEN
              num_aaa041 := 0.08;
              num_aaa043 := 0.23;
            ELSE
              num_aaa041 := 0.2;
              num_aaa043 := 0.8;
            END IF;
            --��ѯ��Ա�Ƿ���ڼ����걨��(��������ְת����)
            SELECT count(1)
              INTO num_count
              FROM wsjb.irac01
             WHERE aac001 = var_aac001
               AND iaa001 IN ('3','7','9','10')
               AND iaa002 = '0'
               AND iaa100 IS NULL;
            --�����Ա��������ɷ�������1
            IF num_count < 1 THEN
               num_per_count := num_per_count + 1;
               IF var_yac168 = '1' AND var_aae140 = '02' THEN
                  num_nmg_count := num_nmg_count + 1;
               END IF;
               --����Ǵ��ֻ��8��Ǯ
               IF var_aae140 = '07' THEN
                 num_aab120 := 0;
                 num_person := num_person+1.6;
                 num_danwei := num_danwei+6.4;
                 num_aab156 := num_aab156+8;
               ELSE
                 --�ɷѻ����ܶ��ۼ�
                 num_aab120 := num_aab120+num_yac004;
                 --���Ϊ������Ա�ɷѽ���0
                 IF var_aae140 = '03' AND var_akc021 = '21' THEN
                   --���˽ɷѽ���ۼ�
                   num_person := num_person + 0;
                   --��λ�ɷѽ���ۼ�
                   num_danwei := num_danwei + 0;
                   --��λ�ɷ��ܶ��ۼ�
                   num_aab156 := num_aab156 + 0;
                ELSE
                 --���˽ɷѽ���ۼ�
                 num_person := num_person + ROUND(num_yac004*num_aaa041,2);
                 --��λ�ɷѽ���ۼ�
                 num_danwei := num_danwei + ROUND(num_yac004*num_aaa043,2);
                 --��λ�ɷ��ܶ��ۼ�
                 num_aab156 := num_aab156 + ROUND(num_yac004*num_aaa041,2) + ROUND(num_yac004*num_aaa043,2);
                END IF;
               END IF;
            END IF;
            --�������ְת������Ա
            SELECT count(1)
              INTO num_count
              FROM wsjb.irac01
             WHERE aac001 = var_aac001
               AND aab001 = prm_aab001
               AND iaa001 = '9'
               AND iaa100 IS NULL;
            IF num_count > 0 AND var_aae140 = '07' THEN
               num_per_count := num_per_count + 1;
               num_aab120 := 0;
               num_person := num_person+1.6;
               num_danwei := num_danwei+6.4;
               num_aab156 := num_aab156+8;
            END IF;


        END LOOP;
        --�ж�������Ա
        FOR rec_irac01 IN cur_irac01 LOOP
            IF var_aae140 = '02' THEN
               SELECT yac168
                 INTO var_yac168
                 FROM wsjb.irac01
                WHERE iac001  = rec_irac01.iac001;
               IF var_yac168 = '0' THEN
                  num_aaa041 := 0.01;
               ELSE
                  num_aaa041 := 0;
               END IF;
               IF rec_irac01.aae210 IN ('1','10') THEN
                  num_per_count := num_per_count+1;
                  IF var_yac168 = '1' THEN
                    num_nmg_count := num_nmg_count + 1;
                  END IF;
                  num_aab120 := num_aab120+rec_irac01.yac005;
                  num_person := num_person + ROUND(rec_irac01.yac005*num_aaa041,2);
                  num_danwei := num_danwei + ROUND(rec_irac01.yac005*num_aaa043,2);
                  num_aab156 := num_aab156 + ROUND(rec_irac01.yac005*num_aaa041,2) + ROUND(rec_irac01.yac005*num_aaa043,2);
               END IF;
            END IF;
            IF var_aae140 = '03' THEN
               IF rec_irac01.aae310 IN ('1','10') THEN
                  num_per_count := num_per_count+1;
                  num_aab120 := num_aab120+rec_irac01.yac005;
                  num_person := num_person + ROUND(rec_irac01.yac005*num_aaa041,2);
                  num_danwei := num_danwei + ROUND(rec_irac01.yac005*num_aaa043,2);
                  num_aab156 := num_aab156 + ROUND(rec_irac01.yac005*num_aaa041,2) + ROUND(rec_irac01.yac005*num_aaa043,2);
               END IF;
            END IF;
            IF var_aae140 = '04' THEN
               IF rec_irac01.aae410 IN ('1','10') THEN
                  num_per_count := num_per_count+1;
                  num_aab120 := num_aab120+rec_irac01.yac005;
                  num_person := num_person + ROUND(rec_irac01.yac005*num_aaa041,2);
                  num_danwei := num_danwei + ROUND(rec_irac01.yac005*num_aaa043,2);
                  num_aab156 := num_aab156 + ROUND(rec_irac01.yac005*num_aaa041,2) + ROUND(rec_irac01.yac005*num_aaa043,2);
               END IF;
            END IF;
            IF var_aae140 = '05' THEN
               IF rec_irac01.aae510 IN ('1','10') THEN
                  num_per_count := num_per_count+1;
                  num_aab120 := num_aab120+rec_irac01.yac005;
                  num_person := num_person + ROUND(rec_irac01.yac005*num_aaa041,2);
                  num_danwei := num_danwei + ROUND(rec_irac01.yac005*num_aaa043,2);
                  num_aab156 := num_aab156 + ROUND(rec_irac01.yac005*num_aaa041,2) + ROUND(rec_irac01.yac005*num_aaa043,2);
               END IF;
            END IF;
            IF var_aae140 = '06' THEN
               IF rec_irac01.aae120 IN ('1','10') THEN
                  num_per_count := num_per_count+1;
                  num_aab120 := num_aab120+rec_irac01.yac004;
                  num_person := num_person + ROUND(rec_irac01.yac004*num_aaa041,2);
                  num_danwei := num_danwei + ROUND(rec_irac01.yac004*num_aaa043,2);
                  num_aab156 := num_aab156 + ROUND(rec_irac01.yac004*num_aaa041,2) + ROUND(rec_irac01.yac004*num_aaa043,2);
               END IF;
            END IF;
            IF var_aae140 = '07' THEN
               IF rec_irac01.aae311 IN ('1','10') THEN
                  num_per_count := num_per_count+1;
                  num_aab120 := num_aab120+0;
                  num_person := num_person + 1.6;
                  num_danwei := num_danwei + 6.4;
                  num_aab156 := num_aab156 + 8;
               END IF;
            END IF;
        END LOOP;
      --��������Ľ�������ʱ����

      INSERT INTO wsjb.TMP_AB08_VIEW (aab001,   --��λ���
                                aae140,   --����
                                aab120,   --�ɷѻ���
                                yae231,   --����
                                aab152,   --���˽ɷѽ��
                                aab150,   --��λ�ɷѽ��
                                aab156,   --Ӧ�ɽ��
                                yae099,
                                yae232)   --��ʧҵũ������
                        VALUES (prm_aab001,
                                var_aae140,
                                num_aab120,
                                num_per_count,
                                num_person,
                                num_danwei,
                                num_aab156,
                                prm_yae099,
                                num_nmg_count);
    END LOOP;
    --���¼�������
    num_person := 0;
    num_per_count := 0;
    num_aab120 := 0;
    num_aab156 := 0;
    num_danwei := 0;
    --���ϻ�������,���
    SELECT NVL(SUM(yac004),0),
           count(1)
      INTO num_aab120,
           num_per_count
      FROM wsjb.IRAC01A3
     WHERE aab001 = prm_aab001
       AND aae110 = '2';
    --��ȥ������ͣ�����������
    SELECT num_aab120-NVL(SUM(yac004),0),
           num_per_count-count(1)
      INTO num_aab120,
           num_per_count
      FROM wsjb.IRAC01
     WHERE aab001 = prm_aab001
       AND iaa001 IN ('3','7','9','10')
       AND iaa002 = '0'
       AND aae110 = '3'    --������ͣ
       AND iaa100 IS NULL;
     -- �����������������������������
     SELECT num_aab120+NVL(SUM(yac004),0),
            num_per_count+count(1)
       INTO num_aab120,
            num_per_count
       FROM  wsjb.irac01
      WHERE aab001 = prm_aab001
        AND iaa001 IN ('1','5','6','8')   --�걨��Ա���
        AND iaa002 = '0'
        AND aae110 in ('1','10')    --��������
        AND iaa100 IS NULL;
      --��������Ľ�������ʱ����
      SELECT aab019
        INTO var_aab019
        FROM xasi2.ab01
       WHERE aab001 = prm_aab001;
       IF var_aab019 = '60' THEN --���幤�̻����ϱ���
        INSERT INTO wsjb.TMP_AB08_VIEW (aab001,   --��λ���
                                aae140,   --����
                                aab120,   --�ɷѻ���
                                yae231,   --����
                                aab152,   --���˽ɷѽ��
                                aab150,   --��λ�ɷѽ��
                                aab156,   --Ӧ�ɽ��
                                yae099)
                        VALUES (prm_aab001,
                                '01',
                                num_aab120,
                                num_per_count,
                                num_aab120*0.08,
                                num_aab120*0.12,
                                num_aab120*0.20,
                                prm_yae099);

       ELSE
        INSERT INTO wsjb.TMP_AB08_VIEW (aab001,   --��λ���
                                aae140,   --����
                                aab120,   --�ɷѻ���
                                yae231,   --����
                                aab152,   --���˽ɷѽ��
                                aab150,   --��λ�ɷѽ��
                                aab156,   --Ӧ�ɽ��
                                yae099)
                        VALUES (prm_aab001,
                                '01',
                                num_aab120,
                                num_per_count,
                                num_aab120*0.08,
                                num_aab120*0.2,
                                num_aab120*0.28,
                                prm_yae099);
       END IF ;
      --����ʧҵ����ũ����������Ϊnull
      UPDATE wsjb.TMP_AB08_VIEW  SET yae232 = NULL WHERE aab001 = prm_aab001 AND aae140 <> '02';
    EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := '00';
         prm_ErrorMsg  := '��λԤ������,����ԭ��:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
END prc_preview;

/*****************************************************************************
   ** �������� : prc_repreview
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����λ������걨�ɷ�Ԥ��
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-12   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
  PROCEDURE prc_repreview (
      prm_aab001       IN     irab01.aab001%TYPE,
      prm_iaa100       IN     irad01.iaa100%TYPE,
      prm_yae099       IN     VARCHAR2,
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
   var_procNo            VARCHAR2(2);          --�������
   var_aac001            xasi2.ac01.aac001%TYPE;     --���˱��
   var_aae140            xasi2.ac02.aae140%TYPE;     --����
   num_yac004            xasi2.ac02.aac040%TYPE;     --�ɷѻ���
   num_count             NUMBER;
   num_per_count         NUMBER;               --����
   num_nmg_count         NUMBER;               --��ʧҵ��ũ������
   num_aab120            xasi2.ab08.aab120%TYPE;     --�ɷѻ����ܶ�
   num_aab156            xasi2.ab08.aab156%TYPE;     --��λǷ�ѽ��
   num_person            xasi2.ab08.aab156%TYPE;     --���˽ɷѽ��
   num_danwei            xasi2.ab08.aab156%TYPE;     --��λ�ɷѽ��
   num_aaa041            NUMBER(13,4);         --���˽ɷѱ���
   num_aaa043            NUMBER(13,4);         --��λ�ɷѱ���
   var_yac168            xasi2.ac01.yac168%TYPE;     --ũ�񹤱�ʶ
   var_aaa040            xasi2.ab02.aaa040%TYPE;     --�������
   var_akc021            VARCHAR2(6);          --ҽ����Ա״̬
   var_aab019            VARCHAR2(6);          --��λ����
   --��ѯ����λδ�걨����Ա��Ϣ(�������ݿ�)
   CURSOR cur_ac02 IS
    SELECT aac001 AS aac001,
           yac004 AS yac004,
           aae140 AS aae140
      FROM xasi2.ac02
     WHERE aab001 = prm_aab001
       AND aac031 = '1'
       AND aae140 = var_aae140;
   CURSOR cur_aae140 IS
    SELECT aae140 AS aae140
      FROM xasi2.ab02
     WHERE aab001 = prm_aab001
       AND aab051 = '1';
   CURSOR cur_irac01 IS
    SELECT iac001 AS iac001,
           aac001 AS aac001,
           yac168 AS yac168,          --ũ�񹤱�ʶ
           yac005 AS yac005,          --�ɷѻ���
           yac004 AS yac004,          --���ϻ���
           aae110 AS aae110,          --ְ������
           aae120 AS aae120,          --��������
           aae210 AS aae210,          --ʧҵ
           aae310 AS aae310,          --ҽ��
           aae410 AS aae410,          --����
           aae510 AS aae510,          --����
           aae311 AS aae311           --���
      FROM  wsjb.irac01
     WHERE aab001 = prm_aab001
       AND iaa100 = prm_iaa100            --�걨�¶�
       AND iaa001 IN ('1','5','6','8')   --�걨��Ա���
       AND iaa002 IN ('1','4');

    BEGIN
    prm_AppCode    := gn_def_OK ;
    prm_ErrorMsg     := '';
    var_procNo     := '06';
    --�����������������
    FOR rec_aae140 IN cur_aae140 LOOP
        var_aae140 := rec_aae140.aae140;
        num_aab120 := 0;
        num_per_count := 0;
        num_nmg_count := 0;
        num_aab156 := 0;
        num_person := 0;
        num_danwei := 0;
        --��ȡ��λ�ɷѱ���
            IF var_aae140 = '03' THEN
               num_aaa043 := 0.07;
            ELSIF var_aae140 = '02' THEN
               num_aaa043 := 0.02;
            ELSIF var_aae140 = '04' THEN
               SELECT aaa040
                 INTO var_aaa040
                 FROM xasi2.ab02
                WHERE aab001 = prm_aab001
                  AND aae140 = var_aae140;
               IF var_aaa040 = '0401' THEN
                  num_aaa043 := 0.005;
               ELSIF var_aaa040 = '0402' THEN
                  num_aaa043 := 0.01;
               ELSE
                  num_aaa043 := 0.02;
               END IF;
            ELSIF var_aae140 = '05' THEN
              num_aaa043 := 0.005;
            ELSIF var_aae140 = '06' THEN
              num_aaa043 := 0.23;
            ELSE
              num_aaa043 := 0.8;
            END IF;
        --�жϼ�����Ա
        FOR rec_ac02 IN cur_ac02 LOOP
            var_aac001 := rec_ac02.aac001;
            num_yac004 := rec_ac02.yac004;

            --��ȡ�ɷѱ���
            IF var_aae140 = '03' THEN
               num_aaa041 := 0.02;
               num_aaa043 := 0.07;
               SELECT AKC021
                 INTO VAR_AKC021
                 FROM XASI2.KC01
                WHERE AAB001 = PRM_AAB001
                  AND AAC001 = REC_AC02.AAC001;
            ELSIF var_aae140 = '02' THEN
               --��ȡũ�񹤱�־
               SELECT yac168
                 INTO var_yac168
                 FROM xasi2.ac01
                WHERE aac001  = var_aac001;
               IF var_yac168 = '0' THEN
                  num_aaa041 := 0.01;
               ELSE
                  num_aaa041 := 0;
               END IF;
               num_aaa043 := 0.02;
            ELSIF var_aae140 = '04' THEN
               SELECT aaa040
                 INTO var_aaa040
                 FROM xasi2.ab02
                WHERE aab001 = prm_aab001
                  AND aae140 = var_aae140;
               IF var_aaa040 = '0401' THEN
                  num_aaa043 := 0.005;
               ELSIF var_aaa040 = '0402' THEN
                  num_aaa043 := 0.01;
               ELSE
                  num_aaa043 := 0.02;
               END IF;
               num_aaa041 := 0;
            ELSIF var_aae140 = '05' THEN
              num_aaa041 := 0;
              num_aaa043 := 0.005;
            ELSIF var_aae140 = '06' THEN
              num_aaa041 := 0.08;
              num_aaa043 := 0.23;
            ELSE
              num_aaa041 := 0.2;
              num_aaa043 := 0.8;
            END IF;
            --��ѯ��Ա�Ƿ���ڼ����걨��(��������ְת����)
            SELECT count(1)
              INTO num_count
              FROM  wsjb.irac01
             WHERE aac001 = var_aac001
               AND aab001 = prm_aab001
               AND iaa001 IN ('3','7','9','10')
               AND iaa002 IN ('1','4')
               AND iaa100 =prm_iaa100;
            --�����Ա��������ɷ�������1
            IF num_count < 1 THEN
               num_per_count := num_per_count + 1;
               IF var_yac168 = '1' AND var_aae140 = '02' THEN
                  num_nmg_count := num_nmg_count + 1;
               END IF;
               --����Ǵ��ֻ��8��Ǯ
               IF var_aae140 = '07' THEN
                 num_aab120 := 0;
                 num_person := num_person+1.6;
                 num_danwei := num_danwei+6.4;
                 num_aab156 := num_aab156+8;
               ELSE
                 --�ɷѻ����ܶ��ۼ�
                 num_aab120 := num_aab120+num_yac004;
                 --���Ϊ������Ա�ɷѽ���0
                 IF var_aae140 = '03' AND var_akc021 = '21' THEN
                   --���˽ɷѽ���ۼ�
                   num_person := num_person + 0;
                   --��λ�ɷѽ���ۼ�
                   num_danwei := num_danwei + 0;
                   --��λ�ɷ��ܶ��ۼ�
                   num_aab156 := num_aab156 + 0;
                ELSE
                 --���˽ɷѽ���ۼ�
                 num_person := num_person + ROUND(num_yac004*num_aaa041,2);
                 --��λ�ɷѽ���ۼ�
                 num_danwei := num_danwei + ROUND(num_yac004*num_aaa043,2);
                 --��λ�ɷ��ܶ��ۼ�
                 num_aab156 := num_aab156 + ROUND(num_yac004*num_aaa041,2) + ROUND(num_yac004*num_aaa043,2);
                END IF;
               END IF;
            END IF;
            --�������ְת������Ա
            SELECT count(1)
              INTO num_count
              FROM  wsjb.irac01
             WHERE aac001 = var_aac001
               AND aab001 = prm_aab001
               AND iaa001 = '9'
               AND iaa002 IN ('1','4')
               AND iaa100 =prm_iaa100;
            IF num_count > 0 AND var_aae140 = '07' THEN
               num_per_count := num_per_count + 1;
               num_aab120 := 0;
               num_person := num_person+1.6;
               num_danwei := num_danwei+6.4;
               num_aab156 := num_aab156+8;
            END IF;


        END LOOP;
        --�ж�������Ա
        FOR rec_irac01 IN cur_irac01 LOOP
            IF var_aae140 = '02' THEN
               SELECT yac168
                 INTO var_yac168
                 FROM  wsjb.irac01
                WHERE iac001  = rec_irac01.iac001;
               IF var_yac168 = '0' THEN
                  num_aaa041 := 0.01;
               ELSE
                  num_aaa041 := 0;
               END IF;
               IF rec_irac01.aae210 IN ('1','10') THEN
                  num_per_count := num_per_count+1;
                  IF var_yac168 = '1' THEN
                    num_nmg_count := num_nmg_count + 1;
                  END IF;
                  num_aab120 := num_aab120+rec_irac01.yac005;
                  num_person := num_person + ROUND(rec_irac01.yac005*num_aaa041,2);
                  num_danwei := num_danwei + ROUND(rec_irac01.yac005*num_aaa043,2);
                  num_aab156 := num_aab156 + ROUND(rec_irac01.yac005*num_aaa041,2) + ROUND(rec_irac01.yac005*num_aaa043,2);
               END IF;
            END IF;
            IF var_aae140 = '03' THEN
               IF rec_irac01.aae310 IN ('1','10') THEN
                  num_per_count := num_per_count+1;
                  num_aab120 := num_aab120+rec_irac01.yac005;
                  num_person := num_person + ROUND(rec_irac01.yac005*num_aaa041,2);
                  num_danwei := num_danwei + ROUND(rec_irac01.yac005*num_aaa043,2);
                  num_aab156 := num_aab156 + ROUND(rec_irac01.yac005*num_aaa041,2) + ROUND(rec_irac01.yac005*num_aaa043,2);
               END IF;
            END IF;
            IF var_aae140 = '04' THEN
               IF rec_irac01.aae410 IN ('1','10') THEN
                  num_per_count := num_per_count+1;
                  num_aab120 := num_aab120+rec_irac01.yac005;
                  num_person := num_person + ROUND(rec_irac01.yac005*num_aaa041,2);
                  num_danwei := num_danwei + ROUND(rec_irac01.yac005*num_aaa043,2);
                  num_aab156 := num_aab156 + ROUND(rec_irac01.yac005*num_aaa041,2) + ROUND(rec_irac01.yac005*num_aaa043,2);
               END IF;
            END IF;
            IF var_aae140 = '05' THEN
               IF rec_irac01.aae510 IN ('1','10') THEN
                  num_per_count := num_per_count+1;
                  num_aab120 := num_aab120+rec_irac01.yac005;
                  num_person := num_person + ROUND(rec_irac01.yac005*num_aaa041,2);
                  num_danwei := num_danwei + ROUND(rec_irac01.yac005*num_aaa043,2);
                  num_aab156 := num_aab156 + ROUND(rec_irac01.yac005*num_aaa041,2) + ROUND(rec_irac01.yac005*num_aaa043,2);
               END IF;
            END IF;
            IF var_aae140 = '06' THEN
               IF rec_irac01.aae120 IN ('1','10') THEN
                  num_per_count := num_per_count+1;
                  num_aab120 := num_aab120+rec_irac01.yac004;
                  num_person := num_person + ROUND(rec_irac01.yac004*num_aaa041,2);
                  num_danwei := num_danwei + ROUND(rec_irac01.yac004*num_aaa043,2);
                  num_aab156 := num_aab156 + ROUND(rec_irac01.yac004*num_aaa041,2) + ROUND(rec_irac01.yac004*num_aaa043,2);
               END IF;
            END IF;
            IF var_aae140 = '07' THEN
               IF rec_irac01.aae311 IN ('1','10') THEN
                  num_per_count := num_per_count+1;
                  num_aab120 := num_aab120+0;
                  num_person := num_person + 1.6;
                  num_danwei := num_danwei + 6.4;
                  num_aab156 := num_aab156 + 8;
               END IF;
            END IF;
        END LOOP;
      --��������Ľ�������ʱ����

      INSERT INTO wsjb.TMP_AB08_VIEW (aab001,   --��λ���
                                aae140,   --����
                                aab120,   --�ɷѻ���
                                yae231,   --����
                                aab152,   --���˽ɷѽ��
                                aab150,   --��λ�ɷѽ��
                                aab156,   --Ӧ�ɽ��
                                yae099,
                                yae232)   --��ʧҵũ������
                        VALUES (prm_aab001,
                                var_aae140,
                                num_aab120,
                                num_per_count,
                                num_person,
                                num_danwei,
                                num_aab156,
                                prm_yae099,
                                num_nmg_count);
    END LOOP;
    --���¼�������
    num_person := 0;
    num_per_count := 0;
    num_aab120 := 0;
    num_aab156 := 0;
    num_danwei := 0;
    --���ϻ�������,���
    SELECT NVL(SUM(yac004),0),
           count(1)
      INTO num_aab120,
           num_per_count
      FROM wsjb.IRAC01A3
     WHERE aab001 = prm_aab001
       AND aae110 = '2';
    --��ȥ������ͣ�����������
    SELECT num_aab120-NVL(SUM(yac004),0),
           num_per_count-count(1)
      INTO num_aab120,
           num_per_count
      FROM  wsjb.irac01
     WHERE aab001 = prm_aab001
       AND iaa001 IN ('3','7','9','10')
       AND iaa002 IN ('1','4')
       AND aae110 = '3'    --������ͣ
       AND iaa100 = prm_iaa100;
     -- �����������������������������
     SELECT num_aab120+NVL(SUM(yac004),0),
            num_per_count+count(1)
       INTO num_aab120,
            num_per_count
       FROM  wsjb.irac01
      WHERE aab001 = prm_aab001
        AND iaa001 IN ('1','5','6','8')   --�걨��Ա���
        AND iaa002 IN ('1','4')
        AND aae110 in ('1','10')    --��������
        AND iaa100 = prm_iaa100;
      --��������Ľ�������ʱ����
      SELECT aab019
        INTO var_aab019
        FROM xasi2.ab01
       WHERE aab001 = prm_aab001;
       IF var_aab019 = '60' THEN --���幤�̻����ϱ���
        INSERT INTO  wsjb.TMP_AB08_VIEW (aab001,   --��λ���
                                aae140,   --����
                                aab120,   --�ɷѻ���
                                yae231,   --����
                                aab152,   --���˽ɷѽ��
                                aab150,   --��λ�ɷѽ��
                                aab156,   --Ӧ�ɽ��
                                yae099)
                        VALUES (prm_aab001,
                                '01',
                                num_aab120,
                                num_per_count,
                                num_aab120*0.08,
                                num_aab120*0.12,
                                num_aab120*0.20,
                                prm_yae099);

       ELSE
        INSERT INTO  wsjb.TMP_AB08_VIEW (aab001,   --��λ���
                                aae140,   --����
                                aab120,   --�ɷѻ���
                                yae231,   --����
                                aab152,   --���˽ɷѽ��
                                aab150,   --��λ�ɷѽ��
                                aab156,   --Ӧ�ɽ��
                                yae099)
                        VALUES (prm_aab001,
                                '01',
                                num_aab120,
                                num_per_count,
                                num_aab120*0.08,
                                num_aab120*0.2,
                                num_aab120*0.28,
                                prm_yae099);
       END IF ;


      --����ʧҵ����ũ����������Ϊnull
      UPDATE wsjb.TMP_AB08_VIEW  SET yae232 = NULL WHERE aab001 = prm_aab001 AND aae140 <> '02';
    EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := '00';
         prm_ErrorMsg  := '��ص�λԤ������,����ԭ��:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
END prc_repreview;

/*****************************************************************************
   ** �������� : prc_YLAuditMonth
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �������ϵ�λ���걨���
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_iaa011       IN     iraa02.iaa011%TYPE,--ҵ������
   **           prm_iaa003       IN     iraa02.iaa003%TYPE,--ҵ������
   **           prm_iaa004       IN     iraa02.iaa011%TYPE,--��˱�־
   **           prm_iaa028       IN     VARCHAR2          ,--�Ƿ�ȫ��
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_aae013       IN     iraa02.aae013%TYPE,--��ע
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2013-05-16   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_YLAuditMonth(
      prm_iaa011       IN     iraa02.iaa011%TYPE,--ҵ������
      prm_iaa003       IN     iraa02.iaa003%TYPE,--ҵ������
      prm_iaa018       IN     irad22.iaa018%TYPE,--��˱�־
      prm_iaa028       IN     VARCHAR2          ,--�Ƿ�ȫ��
      prm_aae011       IN     iraa02.iaa011%TYPE,--������
      prm_aae013       IN     iraa02.aae013%TYPE,--��ע
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      n_count    number(5);
      v_iaz011   varchar2(15);
      v_iaz009   varchar2(15);
      v_iaz010   varchar2(15);
      v_aaz002   varchar2(15);
      v_iaa015   varchar2(1);
      v_iaa004   number(1);
      v_iaa014   number(1);
      v_iaa017   number(1);
      v_yae099   varchar2(15);
      var_aae140_01   VARCHAR2(2);         --�Ƿ�μ�����ҵ����
      rec_irac01      irac01%rowtype;
      var_yac001      VARCHAR2(20);
      var_aac001      VARCHAR2(15);
      var_yae235      VARCHAR2(6);
      var_yae238      VARCHAR2(2000);

      --�����α꣬��ȡ���������Ա��Ϣ
      CURSOR cur_tmp_person IS
      SELECT a.IAC001, --�걨��Ա��Ϣ���,VARCHAR2
             b.AAC001, --���˱��,VARCHAR2
             a.AAB001, --��λ���,VARCHAR2
             a.AAC002, --������ݺ���,VARCHAR2
             a.AAC003, --����,VARCHAR2
             b.IAA001, --��Ա���
             a.IAZ005, --�걨��ϸID
             a.IAA003  --ҵ������
        FROM wsjb.IRAD22_TMP  a, wsjb.irac01  b --���������Ա��Ϣ��ʱ��
       WHERE a.iac001 = b.iac001
        ORDER by a.iaa003;

   BEGIN

      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;


      /*�����ʱ���Ƿ��������*/
      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.IRAD22_TMP ;
      IF n_count = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'�����ʱ���޿�������!';
         RETURN;
      END IF;


      /*��Ҫ������У��*/
      IF prm_iaa011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'ҵ�����Ͳ���Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa003 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'ҵ�����岻��Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa018 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'��˱�־����Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa028 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'��־[�Ƿ�ȫ��]����Ϊ��!';
         RETURN;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
      IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�AAZ002!';
         RETURN;
      END IF;

      v_iaz009 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ009');
      IF v_iaz009 IS NULL OR v_iaz009 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�IAZ009!';
         RETURN;
      END IF;

      --����¼�
      INSERT INTO  wsjb.IRAD21
                 (
                  IAZ009,
                  AAZ002,
                  IAA011,
                  AEE011,
                  AAE035,
                  YAB003,
                  AAE013
                  )
                  VALUES
                  (
                  v_iaz009,
                  v_aaz002,
                  prm_iaa011,
                  prm_aae011,
                  sysdate,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae013
      );

      FOR REC_TMP_PERSON IN cur_tmp_person LOOP

         --�걨�����Ǹ���ʱУ�飺���뵥λ��Ϣ���ͨ�����ܰ���
         IF REC_TMP_PERSON.iaa003 = PKG_Constant.IAA003_PER THEN
            SELECT COUNT(1)
              INTO n_count
              FROM wsjb.IRAB01
             WHERE AAB001 = REC_TMP_PERSON.AAB001
               AND IAA002 = PKG_Constant.IAA002_APS;
            IF n_count = 0 THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'��λ��Ϣ���ͨ�����ܰ�����Ա���걨���!';
               RETURN;
            END IF;
         END IF;

          /*
            �����Ա����Ϣ���
            ���԰�����Ǵ�� ͨ�� ��ͨ�� ����ͨ�� ȫ��ͨ�� ȫ��ͨ��
         */

         --�����ϸ����
         v_iaz010 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ010');
         IF v_iaz010 IS NULL OR v_iaz010 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�IAZ010!';
            RETURN;
         END IF;

         --��ѯ�ϴ�������
         BEGIN
            SELECT IAA015
              INTO v_iaa015
              FROM wsjb.IRAD02
             WHERE IAZ005 = REC_TMP_PERSON.IAZ005;

            IF v_iaa015 in (PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
              prm_ErrorMsg := PRE_ERRCODE ||'����Ѿ��ս�!';
              RETURN;
           END IF;

            --��ȡ�ϴ������Ϣ
            IF v_iaa015 = PKG_Constant.IAA015_ADI THEN
               BEGIN
                  SELECT A.IAZ010,
                         A.IAA004,
                         A.IAA014,
                         A.IAA017
                    INTO v_iaz011,
                         v_iaa004,
                         v_iaa014,
                         v_iaa017
                    FROM wsjb.IRAD22  A
                   WHERE A.IAA018 NOT IN (
                                          PKG_Constant.IAA018_DAD, --���[�������]
                                          PKG_Constant.IAA018_NPS  --��ͨ�� Not Pass
                                         )
                     AND A.IAZ005 = REC_TMP_PERSON.IAZ005
                     AND A.IAZ010 = (
                                      SELECT MAX(IAZ010)
                                        FROM wsjb.IRAD22
                                       WHERE IAZ005 = A.IAZ005
                                         AND IAA018 = A.IAA018
                                    );
                  EXCEPTION
                  WHEN OTHERS THEN
                     ROLLBACK;
                     prm_AppCode  := gn_def_ERR;
                     prm_ErrorMsg := PRE_ERRCODE ||'�걨��Ϣ��������У���δ��ȡ���ϴ������Ϣ,��ȷ���ϴ�����Ƿ��ս�!';
                     RETURN;
               END;

               v_iaa014 := v_iaa017;
               v_iaa017 := v_iaa017 + 1;
               IF v_iaa017 > v_iaa004 THEN
                  v_iaa017 := v_iaa004;
               END IF;

               --��˼��ε��ڵ�ǰ����
               IF v_iaa004 = v_iaa014 AND v_iaa004 = v_iaa017 THEN
                  ROLLBACK;
                  prm_AppCode  := gn_def_ERR;
                  prm_ErrorMsg := PRE_ERRCODE ||'����Ѿ��ս�!';
                  RETURN;
               END IF;
            END IF;

            --��ȡ�걨��ϸ��Ϣ
            IF v_iaa015 = PKG_Constant.IAA015_WAD THEN
               BEGIN
                  SELECT A.IAA004,
                         A.IAA014
                    INTO v_iaa004,
                         v_iaa014
                    FROM wsjb.IRAD02  A
                   WHERE A.IAZ005 = REC_TMP_PERSON.IAZ005;
                  EXCEPTION
                  WHEN OTHERS THEN
                     ROLLBACK;
                     prm_AppCode  := gn_def_ERR;
                     prm_ErrorMsg := PRE_ERRCODE ||'û����ȡ���걨��ϸ��Ϣ!';
                     RETURN;
               END;
               v_iaz011 := v_iaz010;
               v_iaa014 := v_iaa014 + 1;
               v_iaa017 := v_iaa014 + 1;
               IF v_iaa017 > v_iaa004 THEN
                  v_iaa017 := v_iaa004;
               END IF;
            END IF;

            EXCEPTION
            WHEN OTHERS THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := '�����Ϣ��ȡ����:'|| PRE_ERRCODE || SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
               RETURN;
         END;

         --�����ϸд��
         INSERT INTO wsjb.IRAD22
                    (
                     IAZ010,
                     IAZ011,
                     IAZ009,
                     IAZ005,
                     IAA004,
                     IAA014,
                     IAA017,
                     AAE011,
                     AAE035,
                     YAB003,
                     IAA018,
                     IAD005,    --������
                     AAE013
                     )
                    VALUES
                    (
                     v_iaz010,
                     v_iaz011,
                     v_iaz009,
                     REC_TMP_PERSON.IAZ005,
                     v_iaa004,
                     v_iaa014,
                     v_iaa017,
                     prm_aae011,
                     sysdate,
                     PKG_Constant.YAB003_JBFZX,
                     prm_iaa018,
                     prm_aae013,  --������
                     null
         );

         --���
         IF prm_iaa018 = PKG_Constant.IAA018_DAD THEN

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_DAD,--���[�޸�����]
                   AAE013 = prm_aae013
             WHERE IAA015 = PKG_Constant.IAA015_WAD --����
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_ALR  --�Ѵ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --���δͨ��
         IF prm_iaa018 = PKG_Constant.IAA018_NPS THEN

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015  = PKG_Constant.IAA015_ADO, --������
                   AAE013  = prm_aae013
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --����/�����
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_NPS  --δͨ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --���ͨ��
         IF prm_iaa018 = PKG_Constant.IAA018_PAS AND v_iaa014 = v_iaa004 THEN

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015  =  PKG_Constant.IAA015_ADO --������
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --����/�����
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            v_yae099 := xasi2.PKG_comm.fun_GetSequence(NULL,'yae099');
            IF v_yae099 IS NULL OR v_yae099 = '' THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ��ϵͳ������к�:YAE099';
               RETURN;
            END IF;

            SELECT *
              INTO rec_irac01
              FROM wsjb.IRAC01
             WHERE IAC001 = REC_TMP_PERSON.IAC001;

            IF REC_TMP_PERSON.iaa003 = '2' THEN


               /*
                  ��Ա����[�²α��������²α�]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_ADD,PKG_Constant.IAA001_PAD) THEN


                  var_aae140_01 := rec_irac01.aae110;        --�Ƿ�μ�����ҵ����
                  IF var_aae140_01 = '1' THEN
                    SELECT COUNT(1)
                      INTO n_count
                      FROM xasi2.ac01
                     WHERE aac002 = rec_irac01.aac002;
                    IF n_count > 0 THEN
                        prm_AppCode := gn_def_ERR ;
                        prm_ErrorMsg  := '�������֤��['||rec_irac01.aac002||']����Ա��Ϣ�����飡';
                        RETURN;
                    END IF;
                    var_aac001 := xasi2.pkg_comm.fun_GetSequence(NULL,'aac001');
                    IF var_aac001 is null THEN
                        prm_AppCode := gn_def_ERR ;
                        prm_ErrorMsg  := 'û�л�ȡ����Ա���aac001!';
                        RETURN;
                    END IF;

                    SELECT count(1)
                      INTO n_count
                      FROM xasi2.ac01
                     WHERE aac001 = var_aac001;
                     IF n_count = 0 THEN
                       --���������Ϣ��
                       INSERT INTO xasi2.ac01(
                                       aac001,          -- ���˱��
                                       yae181,          -- ֤������
                                       aac002,          -- ���֤����(֤������)
                                       aac003,          -- ����
                                       aac004,          -- �Ա�
                                       aac005,          -- ����
                                       aac006,          -- ��������
                                       aac007,          -- �μӹ�������
                                       aac008,          -- ��Ա״̬
                                       aac009,          -- ��������
                                       aac013,          -- �ù���ʽ
                                       yac067,          -- ��Դ��ʽ
                                       yac168,          -- ũ�񹤱�־
                                       aae005,          -- ��ϵ�绰
                                       aae006,          -- ��ַ
                                       aae011,          -- ������
                                       aae036,          -- ����ʱ��
                                       aae120,          -- ע����־
                                       aae013)
                              VALUES ( var_aac001,                 -- ���˱��
                                       rec_irac01.yae181,          -- ֤������
                                       rec_irac01.aac002,          -- ���֤����(֤������)
                                       rec_irac01.aac003,          -- ����
                                       rec_irac01.aac004,          -- �Ա�
                                       rec_irac01.aac005,          -- ����
                                       rec_irac01.aac006,          -- ��������
                                       rec_irac01.aac007,          -- �μӹ�������
                                       rec_irac01.aac008,          -- ��Ա״̬
                                       rec_irac01.aac009,          -- ��������
                                       rec_irac01.aac013,          -- �ù���ʽ
                                       '1',                        -- ��Դ��ʽ
                                       rec_irac01.yac168,          -- ũ�񹤱�־
                                       rec_irac01.aae005,          -- ��ϵ�绰
                                       rec_irac01.aae006,          -- ��ַ
                                       prm_aae011,                 -- ������
                                       sysdate,                 -- ����ʱ��
                                       '0',                        -- ע����־
                                       '���������ֵ�λ����������Ա'); --��ע
                   ELSIF n_count >0 THEN
                       prm_AppCode := gn_def_ERR ;
                       prm_ErrorMsg  := '���˱��'||var_aac001||'ҽ�ƿ�������ݣ����ʵ��';
                       RETURN;
                   END IF;

                   --�����걨��Ϣ����Ա���
                   UPDATE wsjb.IRAC01
                      SET AAC001 = var_aac001
                    WHERE IAC001 = REC_TMP_PERSON.IAC001;

                   --�����걨��ϸ��Ϣ����Ա���
                   UPDATE wsjb.IRAD02
                      SET IAZ008 = var_aac001
                    WHERE IAZ007 = REC_TMP_PERSON.IAC001;


                  SELECT COUNT(1)
                      INTO n_count
                      FROM wsjb.IRAC01A3
                     WHERE AAC001 = NVL(var_aac001,rec_irac01.AAC001)
                       AND AAB001 = rec_irac01.AAB001;
                    IF n_count = 0 THEN
                       var_yac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'YAC001');
                       IF var_yac001 is null THEN
                          prm_AppCode := gn_def_ERR ;
                          prm_ErrorMsg  := 'û�л�ȡ����λ��Ա���к�yac001!';
                          RETURN;
                       END IF;
                       INSERT INTO wsjb.irac01a3 (
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
                                   NVL(var_aac001,rec_irac01.AAC001),          -- ���˱��
                                   rec_irac01.aab001,
                                   rec_irac01.yae181,          -- ֤������
                                   rec_irac01.aac002,          -- ���֤����(֤������)
                                   rec_irac01.aac003,          -- ����
                                   rec_irac01.aac004,          -- �Ա�
                                   rec_irac01.aac005,
                                   rec_irac01.aac006,          -- ��������
                                   rec_irac01.aac007,          -- �μӹ�������
                                   rec_irac01.aac008,          -- ��Ա״̬
                                   rec_irac01.aac009,
                                   rec_irac01.aac010,
                                   rec_irac01.aac012,
                                   rec_irac01.aac013,
                                   rec_irac01.aac014,
                                   rec_irac01.aac015,
                                   rec_irac01.aac020,
                                   rec_irac01.yac067,          -- ��Դ��ʽ
                                   rec_irac01.yac168,          -- ũ�񹤱�־
                                   rec_irac01.aae004,
                                   rec_irac01.aae005,          -- ��ϵ�绰
                                   rec_irac01.aae006,          -- ��ַ
                                   rec_irac01.aae007,
                                   rec_irac01.yae222,
                                   rec_irac01.aae013,
                                   0,
                                   PKG_Constant.YAB003_JBFZX,
                                   rec_irac01.aab001,
                                   prm_aae011,          -- ������
                                   sysdate);         -- ����ʱ��
                    END IF;

                    UPDATE wsjb.IRAC01A3
                       SET AAE110 = DECODE(var_aae140_01,'1','2','0'),
                           AAE120 = '0',
                           AAE210 = '0',
                           AAE310 = '0',
                           AAE410 = '0',
                           AAE510 = '0',
                           AAE311 = '0',
                           AAC040 = rec_irac01.aac040,
                           YAC004 = rec_irac01.yac004,
                           YAC005 = null
                     WHERE AAC001 = NVL(var_aac001,rec_irac01.AAC001)
                       AND AAB001 = rec_irac01.AAB001;

                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
                END IF;
               END IF;


              /*
                  ��Ա����
               */
              IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_CIN THEN


                  var_aae140_01 := rec_irac01.aae110;        --�Ƿ�μ�����ҵ����
                  var_aac001 := rec_irac01.aac001;
                  IF var_aae140_01 = '1' OR var_aae140_01 = '10'THEN


                      SELECT COUNT(1)
                        INTO n_count
                        FROM wsjb.IRAC01A3
                       WHERE AAC001 = NVL(var_aac001,rec_irac01.AAC001)
                         AND AAB001 = rec_irac01.AAB001;
                      IF n_count = 0 THEN
                         var_yac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'YAC001');
                         IF var_yac001 is null THEN
                            prm_AppCode := gn_def_ERR ;
                            prm_ErrorMsg  := 'û�л�ȡ����λ��Ա���к�yac001!';
                            RETURN;
                         END IF;
                         INSERT INTO wsjb.irac01a3 (
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
                                     NVL(var_aac001,rec_irac01.AAC001),          -- ���˱��
                                     rec_irac01.aab001,
                                     rec_irac01.yae181,          -- ֤������
                                     rec_irac01.aac002,          -- ���֤����(֤������)
                                     rec_irac01.aac003,          -- ����
                                     rec_irac01.aac004,          -- �Ա�
                                     rec_irac01.aac005,
                                     rec_irac01.aac006,          -- ��������
                                     rec_irac01.aac007,          -- �μӹ�������
                                     rec_irac01.aac008,          -- ��Ա״̬
                                     rec_irac01.aac009,
                                     rec_irac01.aac010,
                                     rec_irac01.aac012,
                                     rec_irac01.aac013,
                                     rec_irac01.aac014,
                                     rec_irac01.aac015,
                                     rec_irac01.aac020,
                                     rec_irac01.yac067,          -- ��Դ��ʽ
                                     rec_irac01.yac168,          -- ũ�񹤱�־
                                     rec_irac01.aae004,
                                     rec_irac01.aae005,          -- ��ϵ�绰
                                     rec_irac01.aae006,          -- ��ַ
                                     rec_irac01.aae007,
                                     rec_irac01.yae222,
                                     rec_irac01.aae013,
                                     0,
                                     PKG_Constant.YAB003_JBFZX,
                                     rec_irac01.aab001,
                                     prm_aae011,          -- ������
                                     sysdate);         -- ����ʱ��
                      END IF;

                      UPDATE wsjb.IRAC01A3
                         SET AAE110 = DECODE(var_aae140_01,'1','2','10','2',var_aae140_01),
                             AAE120 = '0',
                             AAE210 = '0',
                             AAE310 = '0',
                             AAE410 = '0',
                             AAE510 = '0',
                             AAE311 = '0',
                             AAC040 = rec_irac01.aac040,
                             YAC004 = rec_irac01.yac004,
                             YAC005 = null
                       WHERE AAC001 = NVL(var_aac001,rec_irac01.AAC001)
                         AND AAB001 = rec_irac01.AAB001;
                  END IF;

              END IF;

               /*
                  ��Ա����[��Ա��ͣ�ɷ���������ͣ�ɷѣ�������Ա����(����ͣ��ͬ),��ְת����(������ֻ��ͣ��)]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_MIN,PKG_Constant.IAA001_PMI,PKG_Constant.IAA001_RPD,PKG_Constant.IAA001_RTR) THEN
                  var_aae140_01 := rec_irac01.aae110;
                  var_aac001 := rec_irac01.aac001;
                  IF var_aae140_01 = '3' OR var_aae140_01='21' THEN
                     SELECT COUNT(1)
                        INTO n_count
                        FROM IRAC01A3
                       WHERE AAC001 = NVL(var_aac001,rec_irac01.AAC001)
                         AND AAB001 = rec_irac01.AAB001;
                     IF n_count = 0 THEN
                        prm_AppCode := gn_def_ERR ;
                        prm_ErrorMsg  := 'û�д�irac01a3�л�ȡ�α���Ϣ';
                        RETURN;
                     END IF;
                     UPDATE IRAC01A3
                     SET AAE110 = DECODE(var_aae140_01,'3','0',var_aae140_01),
                         AAE120 = '0',
                         AAE210 = '0',
                         AAE310 = '0',
                         AAE410 = '0',
                         AAE510 = '0',
                         AAE311 = '0'
                   WHERE AAC001 = NVL(var_aac001,rec_irac01.AAC001)
                     AND AAB001 = rec_irac01.aab001;
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;

                  END IF;

               END IF;

               --2013-03-14 ����  Ӧ�����Ƚ��в���������״̬
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_APS  --��ͨ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;
            --������ر�
            INSERT INTO wsjb.AE02A1
                        (
                         AAZ002,
                         YAE099,
                         IAA020,
                         AAB001,
                         AAC001,
                         IAA001
                        )
                  VALUES(
                        v_aaz002,
                        v_yae099,
                        REC_TMP_PERSON.iaa003,
                        REC_TMP_PERSON.AAB001,
                        REC_TMP_PERSON.IAC001,
                        REC_TMP_PERSON.IAA001
                        );
         END IF;

      END LOOP;

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
                  AAE218,
                  AAE013
                 )
                 VALUES
                 (
                  v_aaz002,
                  PKG_Constant.AAA121_MIA,
                  prm_aae011,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae011,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate,
                  prm_aae013
                 );
   EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| PRE_ERRCODE || SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END prc_YLAuditMonth;
/*****************************************************************************
   ** �������� : prc_RollBackAMIRBYYL
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ���������걨���(�����ϵ�λ)
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aaz002       IN     ae02.aaz002%TYPE  ,--ҵ����־���
   **           prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
   **           prm_aae011       IN     irad31.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-06   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_RollBackAMIRBYYL (
      prm_aaz002       IN     ae02.aaz002%TYPE,  --ҵ����־���
      prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
      prm_aab001       IN     irad01.aab001%TYPE,--�걨��λ
      prm_aae011       IN     irad31.aae011%TYPE,--������
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum     NUMBER;
      var_yae099   xasi2.ac02a2.YAE099%TYPE;
      var_iaa020   irad02.iaa020%TYPE; --�걨ҵ������
      --��Ҫ���˵�����
      CURSOR personCur IS
      SELECT c.iaa018,
             e.iaa001,
             e.iac001,
             d.iaa020,
             d.iaa015,
             d.iaa016,
             d.iaz004,
             d.iaz005,
             d.iaz006,
             d.iaz007,
             d.iaz008,
             d.iad003,
             d.aae013
        FROM wsjb.ae02  a,wsjb.irad22  c,wsjb.irad02  d,wsjb.irac01  e,wsjb.irad21  b
       WHERE a.aaz002 = b.aaz002
         AND b.iaz009 = c.iaz009
         AND c.iaz005 = d.iaz005
         AND d.iaz007 = e.iac001
         AND b.aaz002 = prm_aaz002;

   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      countnum := 0;

      --�������ϵ����ݴ������걨����ʱ���ܻ���
      /*SELECT count(1)
        INTO countnum
        FROM irad21 a,irad22 b,irad02 c
       WHERE a.iaz009 = b.iaz009
         AND b.iaz005 = c.iaz006
         AND c.iaa015 = PKG_Constant.IAA015_WAD  --����
         AND a.aaz002 = prm_aaz002;
      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ڴ�������ݣ����ܻ��ˣ�';
         RETURN;
      END IF;*/

      --�������ϵ����ݴ���Ӧ�պ˶�֮���ܻ���
      SELECT count(1)
        INTO countnum
        FROM wsjb.irab08
       WHERE aab001 = prm_aab001
         AND aae003 = prm_iaa100
         AND yae517 = 'H01';       --����Ӧ�պ˶�
      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�����Ѿ�����Ӧ�պ˶������ܻ��ˣ�';
         RETURN;
      END IF;

      --�������ϵ����ݴ���ʵ�շ���֮���ܻ���
--      SELECT count(1)
--        INTO countnum
--        FROM ab08a8
--       WHERE aab001 = prm_aab001
--         AND aae003 = prm_iaa100
--         AND yae517 = 'H01';       --����Ӧ�պ˶�
--      IF countnum > 0 THEN
--         prm_AppCode  :=  gn_def_ERR;
--         prm_ErrorMsg := '�����Ѿ�����ʵ�շ��䣬���ܻ��ˣ�';
--         RETURN;
--      END IF;

      --����Ƿ���ڿɻ��˵�����
      SELECT count(1)
        INTO countnum
        FROM wsjb.irad21  a,wsjb.irad22  b,wsjb.irad02  c
       WHERE a.iaz009 = b.iaz009
         AND b.iaz005 = c.iaz005
         AND c.iaa015 IN(PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)  --�����ϻ��߷������
         AND a.aaz002 = prm_aaz002;
      IF countnum = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�����ڿɻ��˵����ݣ����ܻ��ˣ�';
         RETURN;
      END IF;

      --ѭ������
      FOR REC_TMP_PERSON in personCur LOOP

         --���
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_DAD THEN
            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD, --����
                   AAE013 = NULL
             WHERE IAA015 = PKG_Constant.IAA015_DAD --���[�������]
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            --��˵��Ǹ���
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --���걨
                WHERE IAA002 = PKG_Constant.IAA002_ALR  --�Ѵ��
                  AND IAC001 = REC_TMP_PERSON.IAZ007;
            END IF;
         END IF;

         --��ͨ��
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_NPS THEN
            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD, --����
                   AAE013 = NULL
             WHERE IAA015 = PKG_Constant.IAA015_ADO --������
               AND IAZ005 =  REC_TMP_PERSON.IAZ005;

            --��˵��Ǹ���
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --���걨
                WHERE IAA002 = PKG_Constant.IAA002_NPS  --δͨ��
                  AND IAC001 = REC_TMP_PERSON.IAZ007;
            END IF;
         END IF;

         --ͨ��
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_PAS THEN

            SELECT yae099
              INTO var_yae099
              FROM wsjb.AE02A1
             WHERE aac001 = REC_TMP_PERSON.iaz007
               AND aaz002 = prm_aaz002;

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD --����
             WHERE IAA015 = PKG_Constant.IAA015_ADO --������
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            --��˵��Ǹ���
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --���걨
                WHERE IAA002 = PKG_Constant.IAA002_APS  --��ͨ��
                  AND IAC001 = REC_TMP_PERSON.IAZ007;

               /*--��Ա���ӵĻ���
               IF REC_TMP_PERSON.iaa001 = PKG_Constant.IAA001_ADD THEN
                  --������Ա���˹���
                  prc_RollBackASIRPer(
                                     REC_TMP_PERSON.IAZ007,
                                     var_yae099,
                                     prm_AppCode,
                                     prm_ErrorMsg
                                     );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               --��Ա���ٵĻ���
               IF REC_TMP_PERSON.iaa001 = PKG_Constant.IAA001_MIN THEN
                  --������Ա���˹���
                  prc_RollBackAMIRPer(
                                     REC_TMP_PERSON.IAZ007,
                                     var_yae099,
                                     prm_AppCode,
                                     prm_ErrorMsg
                                     );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;*/

                              /*
                  ��Ա����[�²α��������²α�]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_ADD,PKG_Constant.IAA001_PAD) THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[�²α� ����]
                     �Ϸ��� prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuCheckRollback(var_yae099,
                                  REC_TMP_PERSON.IAC001,
                                  prm_aae011,
                                  PKG_Constant.YAB003_JBFZX,
                                  '���Ͼ������',
                                  prm_AppCode,
                                  prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  ��Ա����[��Ա��������]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_IAD THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[�²α� ����]
                     �Ϸ��� prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuAddCheckRollback(var_yae099,
                                    REC_TMP_PERSON.IAC001,
                                    prm_aae011,
                                    PKG_Constant.YAB003_JBFZX,
                                    '���Ͼ������',
                                    prm_AppCode,
                                    prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  ��Ա����[��Ա����]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_CIN THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[�²α� ����]
                     �Ϸ��� prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuContinueRollback(var_yae099,
                                    REC_TMP_PERSON.IAC001,
                                    prm_aae011,
                                    PKG_Constant.YAB003_JBFZX,
                                    '���Ͼ������',
                                    prm_AppCode,
                                    prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  ��Ա����[��Ա��ͣ�ɷ���������ͣ�ɷѣ�������Ա����(����ͣ��ͬ)]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_MIN,PKG_Constant.IAA001_PMI,PKG_Constant.IAA001_RPD) THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[ͣ�� ����]
                     �Ϸ��� prc_AuditMonthInternetRpause
                  */

                  prc_PersonInsuPauseRollback(var_yae099,
                                      REC_TMP_PERSON.IAC001,
                                      prm_aae011,
                                      PKG_Constant.YAB003_JBFZX,
                                      '���Ͼ������',
                                      prm_AppCode,
                                      prm_ErrorMsg
                                      );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  ��Ա����[��ְת����]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_RTR THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[ͣ�� ����]
                     �Ϸ��� prc_AuditMonthInternetRpause
                  */

                  prc_PersonInsuPauseRollback(var_yae099,
                                      REC_TMP_PERSON.IAC001,
                                      prm_aae011,
                                      PKG_Constant.YAB003_JBFZX,
                                      '���Ͼ������',
                                      prm_AppCode,
                                      prm_ErrorMsg
                                      );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

            END IF;
         END IF;
      END LOOP;

      --ɾ�������ϸ
      DELETE
        FROM wsjb.IRAD22  a
       WHERE EXISTS
             (
              SELECT iaz009
                FROM wsjb.IRAD21
               WHERE iaz009 = a.iaz009
                 AND aaz002 = prm_aaz002
             );

      --ɾ������¼�
      DELETE
        FROM wsjb.IRAD21
       WHERE aaz002 = prm_aaz002;

      --ɾ����־��¼
      DELETE
        FROM wsjb.AE02
       WHERE aaz002 = prm_aaz002;

      SELECT count(1)
        INTO countnum
        FROM wsjb.irad21  a,wsjb.irad22  b,wsjb.irad02  c
       WHERE a.iaz009 = b.iaz009
         AND b.iaz005 = c.iaz005
         AND c.iaa015 IN(PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)  --�����ϻ��߷������
         AND a.aaz002 = prm_aaz002;
      IF countnum > 0 THEN
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '�����ڿɻ��˵����ݣ�';
         RETURN;
      END IF;

   EXCEPTION
      WHEN OTHERS THEN
      /*�رմ򿪵��α�*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
      RETURN;
   END prc_RollBackAMIRBYYL;
/*****************************************************************************
   ** �������� : prc_ResetASMR
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ���������걨���(������)
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
   PROCEDURE prc_ResetASMRBYYL (
      prm_aab001       IN     irab01.aab001%TYPE,--��λ���
      prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
      prm_aae011       IN     irad31.aae011%TYPE,--������
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum     NUMBER;
      v_msg        VARCHAR2(200);
      var_aaz002   VARCHAR2(15);
      --��Ҫ���õ��걨����
      CURSOR personCur IS
      SELECT c.iaz004,
             c.iaz005,
             c.iaz007,
             c.iaz008,
             c.iad003,
             c.iaa020
        FROM wsjb.ae02  a,wsjb.irad01  b,wsjb.irad02  c
       WHERE a.aaz002 = b.aaz002
         AND b.iaz004 = c.iaz004
         AND a.aaa121 = PKG_Constant.aaa121_MIR
         AND b.aab001 = prm_aab001
         AND b.iaa100 = prm_iaa100;

      --��Ҫ���õ��������
      CURSOR irad21Cur IS
      SELECT distinct a.aaz002
        FROM wsjb.ae02  a,wsjb.irad22  c,wsjb.irad01  e,wsjb.irad02  d,wsjb.irad21  b
       WHERE a.aaz002 = b.aaz002
         AND b.iaz009 = c.iaz009
         AND c.iaz005 = d.iaz005
         AND e.iaz004 = d.iaz004
         AND b.iaa011 = PKG_Constant.IAA011_MIR
         AND a.aaa121 = PKG_Constant.aaa121_MIA
         AND e.aab001 = prm_aab001
         AND e.iaa100 = prm_iaa100;
   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      v_msg    := NULL;
      countnum := 0;

      --����Ƿ������������
      SELECT count(1)
        INTO countnum
        FROM wsjb.ae02  a,wsjb.irad01  b,wsjb.irad02  c
       WHERE a.aaz002 = b.aaz002
         AND b.iaz004 = c.iaz004
         AND a.aaa121 = PKG_Constant.aaa121_MIR
         AND b.aab001 = prm_aab001
         AND b.iaa100 = prm_iaa100;
      IF countnum = 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '��ǰ�籣�����뵥λ���������걨���ݣ���������!';
         RETURN;
      END IF;

      --����Ƿ������˼�¼
      SELECT count(1)
        INTO countnum
        FROM wsjb.ae02  a,wsjb.irad22  c,wsjb.irad01  e,wsjb.irad02  d,wsjb.irad21  b
       WHERE a.aaz002 = b.aaz002
         AND b.iaz009 = c.iaz009
         AND c.iaz005 = d.iaz005
         AND e.iaz004 = d.iaz004
         AND b.iaa011 = PKG_Constant.IAA011_MIR
         AND a.aaa121 = PKG_Constant.aaa121_MIA
         AND e.aab001 = prm_aab001
         AND e.iaa100 = prm_iaa100;

      --����˼�¼�������������
      IF countnum > 0 THEN
         FOR rec_irad21 in irad21Cur LOOP
             prc_RollBackAMIRBYYL(rec_irad21.aaz002,--���ҵ����־
                              prm_iaa100       ,--�걨�¶�
                              prm_aab001       ,--�걨��λ
                              prm_aae011       ,--������
                              prm_AppCode      ,
                              prm_ErrorMsg
                              );
             IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                RETURN;
             END IF;
         END LOOP;
      END IF;

      --������������Ա��Ϣ
      DELETE
        FROM wsjb.IRAC01
       WHERE aab001 = prm_aab001
         AND iaa100 = prm_iaa100
         AND iaa001 = PKG_Constant.IAA001_GEN;

      --�����걨����
      FOR rec_person in personCur LOOP
         IF rec_person.iaa020 = PKG_Constant.IAA020_GR THEN
            --�����걨��Ϣ״̬
            UPDATE wsjb.IRAC01
               SET iaa002 = PKG_Constant.IAA002_WIR,
                   iaa100 = NULL
             WHERE IAC001 = rec_person.iaz007;
         END IF;
         --�����걨��ϸ
         DELETE
           FROM wsjb.IRAD02
          WHERE IAZ005 = rec_person.iaz005;
      END LOOP;

      SELECT aaz002
        INTO var_aaz002
        FROM wsjb.IRAD01
       WHERE aab001 = prm_aab001
         AND iaa100 = prm_iaa100
         AND iaa011 = PKG_Constant.IAA011_MIR;

      --�����걨�¼�
      DELETE
        FROM wsjb.IRAD01
       WHERE aab001 = prm_aab001
         AND iaa100 = prm_iaa100
         AND iaa011 = PKG_Constant.IAA011_MIR;

      DELETE
        FROM wsjb.AE02  a
       WHERE a.AAA121 = PKG_Constant.AAA121_MIR
         AND a.aaz002 = var_aaz002
         AND EXISTS (SELECT yae092
                       FROM wsjb.IRAA01
                      WHERE yae092 = a.aae011
                        AND aab001 = prm_aab001
                    )
         ;
      /*
        ���Ͷ���Ϣ
      */
      DELETE FROM wsjb.IRAD23_TMP ;
      INSERT INTO wsjb.IRAD23_TMP (aab001) VALUES (prm_aab001);
      v_msg := '��λ'||prm_iaa100||'�¶ȵ���Ա�����걨�����Ѿ������뾡���޸������Ϣ���ύ�걨.';
      PKG_Insurance.prc_MessageSend(prm_aae011,
                                    'A04',
                                    v_msg,
                                    prm_AppCode,
                                    prm_ErrorMsg);
      IF prm_AppCode <> gn_def_OK THEN
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '������Ϣ���͹���prc_MessageSend����:' ||prm_ErrorMsg;
         RETURN;
      END IF;

   EXCEPTION
      WHEN OTHERS THEN
      /*�رմ򿪵��α�*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '���ݿ����:'|| SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() ;
      RETURN;
   END prc_ResetASMRBYYL;


    /*****************************************************************************
   ** �������� : prc_Ab02a8Unit
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����λ�ɷѻ���
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **             prm_aab001       IN     irab01.aab001%TYPE   ��λ���
   **             prm_yae099       IN     ab02a9.yae099%TYPE   ҵ����ˮ��
   **             prm_AppCode      OUT    VARCHAR2
   **             prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-09-09   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/

 PROCEDURE prc_Ab02a8Unit (
      prm_aab001       IN     irab01.aab001%TYPE,--��λ���
      prm_yae099       IN     VARCHAR2,        --ҵ����ˮ��
      prm_AppCode      OUT    VARCHAR2,
      prm_ErrorMsg     OUT    VARCHAR2)
   IS
      countnum      NUMBER;
      max_ny_aae001 NUMBER(6);
      end_ny_aae042 NUMBER(6);
      max_aae001    NUMBER(4);
      end_aae042    NUMBER(4);
      n_count       NUMBER;
      sum_YAC004    NUMBER(12,2);

      --�α�  ��ȡ��λ�α�����
      CURSOR cur_canbao_company  IS
      SELECT
        AAB001,
        AAE140
       FROM xasi2.ab02
       WHERE  aab001 = prm_aab001 and aab051='1' and aae140<>'07';


   BEGIN
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      countnum := 0;

      IF prm_aab001 IS null OR prm_aab001 = '' THEN
          ROLLBACK;
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '��λ���Ϊ��';

         RETURN;
      END IF;

     select max(AAE001)
      into max_aae001
      from xasi2.ab05
      where aab001 =  prm_aab001
       and YAB007 = '03';

     IF max_aae001 IS null   THEN
         ROLLBACK;
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '�õ�λ���Ϊ��';

         RETURN;

      END IF;

      max_ny_aae001 := max_aae001||'01';

      -- ��ȡ��һ���
      select  (max_aae001-1) INTO  end_aae042   from dual;

       end_ny_aae042 := end_aae042||'12';

    FOR REC_CANBAO_COMPANY IN cur_canbao_company LOOP

      SELECT COUNT(1)
        INTO n_count
        FROM xasi2.ab02a8
       where aab001 = REC_CANBAO_COMPANY.AAB001
         and aae001 = max_aae001
         and aae140 = REC_CANBAO_COMPANY.AAE140;

      IF n_count = 0 THEN

        Insert Into xasi2.ab02a8
          (YAE099, --   ҵ����ˮ��
           AAB001, --   ��λ���
           AAE140, --  ��������
           AAE041, --   ��ʼ�ں�
           AAE042, --   ��ֹ�ں�
           AAB121, --   ��λ�ɷѻ����ܶ�
           AAE001, --   ���
           AAE011, --   ������
           AAE036, --    ����ʱ��
           YAB003, --  �籣�������
           YAE031, --   ��˱�־
           YAE032, --   �����
           YAE033, --   ���ʱ��
           YAE569, --  ��˾������
           YAB139, --   �α�����������
           AAE013 --  ��ע
           )
         select  prm_yae099,
                 AAB001,
                 REC_CANBAO_COMPANY.AAE140,
                 max_ny_aae001,
                 null,
                (select   sum(yac004)    from xasi2.ac02 a
        where exists(select * from xasi2.ac01 b where a.aac001 = b.aac001 and b.aac008 = '1')
             and aab001 = REC_CANBAO_COMPANY.AAB001
             and aac031 = '1'
             and aae140 = REC_CANBAO_COMPANY.AAE140)  yac004 ,
                 max_aae001,
                 AAE011,
                 AAE036,
                 YAB003,
                 '1',
                 AAE011,
                 AAE036,
                 YAB003,
                 YAB139,
                 AAE013
            from xasi2.ab02
           where
             AAb001=REC_CANBAO_COMPANY.AAB001
            and   aab051='1'
            and AAE140 = REC_CANBAO_COMPANY.AAE140;


            INSERT INTO xasi2.ab02a9(

                YAE099,   --ҵ����ˮ��
                AAB001,   -- ��λ���
                AAE140,   --��������
                AAC001,   --���˱��
                AAC050,   --�������
                AAE003,   --     �ں�
                AAB122,   --  ���ǰ��λ�ɷѻ���
                AAB121,   --  �����λ�ɷѻ���
                AAE001,   --   ���
                AAE011,   --    ������
                AAE036,   --    ����ʱ��
                YAB003,   --     �������
                YAB139,   --     �α�������
                AAE013   --     ��ע
           )
            select
                 xasi2.PKG_COMM.FUN_GETSEQUENCE(NULL,'YAE099'), --   ҵ����ˮ��
                 AAB001, --   ��λ���
                 AAE140, --  ��������
                 NULL,
                 NULL,
                 NULL,
                 0,      -- ���ǰ��λ�ɷѻ���
                 AAB121, -- �����λ�ɷѻ���
                 AAE001, --   ���
                 AAE011, --   ������
                 AAE036, --    ����ʱ��
                 YAB003, --  �籣�������
                 YAB139, --     �α�������
                 AAE013 --  ��ע
               from xasi2.ab02a8
               where AAB001 = prm_aab001
                    AND AAE140= REC_CANBAO_COMPANY.AAE140;

      end if;

      IF n_count = 1 THEN



           select   sum(yac004)   into sum_YAC004  from xasi2.ac02 a
        where exists(select * from xasi2.ac01 b where a.aac001 = b.aac001 and b.aac008 = '1')
             and aab001 = REC_CANBAO_COMPANY.AAB001
             and aac031 = '1'
             and aae140 = REC_CANBAO_COMPANY.AAE140;

      INSERT INTO xasi2.ab02a9(

                YAE099,   --ҵ����ˮ��
                AAB001,   -- ��λ���
                AAE140,   --��������
                AAC001,   --���˱��
                AAC050,   --�������
                AAE003,   --     �ں�
                AAB122,   --  ���ǰ��λ�ɷѻ���
                AAB121,   --  �����λ�ɷѻ���
                AAE001,   --   ���
                AAE011,   --    ������
                AAE036,   --    ����ʱ��
                YAB003,   --     �������
                YAB139,   --     �α�������
                AAE013   --     ��ע
           )
            select
                xasi2.PKG_COMM.FUN_GETSEQUENCE(NULL,'YAE099'), --   ҵ����ˮ��
                 AAB001, --   ��λ���
                 AAE140, --  ��������
                 NULL,
                 NULL,
                 NULL,
                 AAB121,      -- ���ǰ��λ�ɷѻ���
                 sum_YAC004, -- �����λ�ɷѻ���
                 AAE001, --   ���
                 AAE011, --   ������
                 AAE036, --    ����ʱ��
                 YAB003, --  �籣�������
                 YAB139,   --     �α�������
                 AAE013   --  ��ע
               from xasi2.ab02a8
               where AAB001 = prm_aab001
                    AND AAE140= REC_CANBAO_COMPANY.AAE140;

        update xasi2.ab02a8
           set AAB121 = sum_YAC004 --   ��λ�ɷѻ����ܶ�
         where AAB001 = REC_CANBAO_COMPANY.AAB001
           and AAE140 = REC_CANBAO_COMPANY.AAE140;



      end if;
    end LOOP;

      Update xasi2.ab02a8
         SET AAE042 = end_ny_aae042
       where aab001 = prm_aab001
         and AAE001 = end_aae042
         and AAE140 IN (xasi2.PKG_COMM.AAE140_SYE,
                        xasi2.PKG_COMM.AAE140_JBYL,
                        xasi2.PKG_COMM.AAE140_GS,
                        xasi2.PKG_COMM.AAE140_SYU);
   EXCEPTION
      WHEN OTHERS THEN
       ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '���ݿ����:'|| SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
      RETURN;
   END prc_Ab02a8Unit;


-- ��λ�ɷѻ�������

 PROCEDURE prc_Ab02a8UnitRollBack (
      prm_aab001       IN     VARCHAR2,--��λ���
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum      NUMBER;
      max_ny_aae001 NUMBER(6);
      max_aae001    NUMBER(4);
      n_count       NUMBER;
      sum_YAC004    NUMBER(12,2);

      --�α�  ��ȡ��λ�α�����
      CURSOR cur_canbao_company  IS
      SELECT
        AAB001,
        AAE140
       FROM xasi2.ab02
       WHERE  aab001 = prm_aab001 and aab051='1' and aae140<>'07';


   BEGIN
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      countnum := 0;

   /** IF prm_aab001 = null   THEN
         ROLLBACK;
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '�û��˵�λ���Ϊ��';
         RETURN;

    END IF;
*/
     select max(AAE001)
      into max_aae001
      from xasi2.ab05
      where aab001 =  prm_aab001
       and YAB007 = '03';

      max_ny_aae001 := max_aae001||'01';


    FOR REC_CANBAO_COMPANY IN cur_canbao_company LOOP

      SELECT COUNT(1)
        INTO n_count
        FROM xasi2.ab02a8
       where aab001 = REC_CANBAO_COMPANY.AAB001
         and aae001 = max_aae001
         and aae140 = REC_CANBAO_COMPANY.AAE140;

      IF n_count < 0 THEN
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '��λ�ɷѻ���������:' ||prm_ErrorMsg;
         RETURN;
      END IF;

        select sum(YAC004)
          into sum_YAC004
          from xasi2.ac02
         where AAE140 = REC_CANBAO_COMPANY.AAE140
           and AAB001 = REC_CANBAO_COMPANY.AAB001
           and YAc503 in( '0','5')
           and AAC031 = '1';


          IF sum_YAC004 = null THEN
             sum_YAC004 := 0;
          END IF;

             update xasi2.ab02a8
           set AAB121 = sum_YAC004, --   ��λ�ɷѻ����ܶ�
               AAE036 = sysdate
         where AAB001 = REC_CANBAO_COMPANY.AAB001
           and AAE140 = REC_CANBAO_COMPANY.AAE140;


           INSERT INTO xasi2.ab02a9(

                YAE099,   --ҵ����ˮ��
                AAB001,   -- ��λ���
                AAE140,   --��������
                AAC001,   --���˱��
                AAC050,   --�������
                AAE003,   --     �ں�
                AAB122,   --  ���ǰ��λ�ɷѻ���
                AAB121,   --  �����λ�ɷѻ���
                AAE001,   --   ���
                AAE011,   --    ������
                AAE036,   --    ����ʱ��
                YAB003,   --     �������
                YAB139,   --     �α�������
                AAE013   --     ��ע
           )
            select
                xasi2.PKG_COMM.FUN_GETSEQUENCE(NULL,'YAE099'), --   ҵ����ˮ��
                 AAB001, --   ��λ���
                 AAE140, --  ��������
                 NULL,
                 NULL,
                 NULL,
                 sum_YAC004,      -- ���ǰ��λ�ɷѻ���
                 AAB121, -- �����λ�ɷѻ���
                 AAE001, --   ���
                 AAE011, --   ������
                 sysdate, --    ����ʱ��
                 YAB003, --  �籣�������
                 YAB139,   --     �α�������
                 AAE013   --  ��ע
               from xasi2.ab02a8
               where AAB001 = prm_aab001
                AND AAE140= REC_CANBAO_COMPANY.AAE140;

    end LOOP;


   EXCEPTION
      WHEN OTHERS THEN
       ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '���ݿ����:'|| SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() ;
      RETURN;
   END prc_Ab02a8UnitRollBack;







 --YAE099


 PROCEDURE prc_AuditMonthInternetRNew (
      prm_iaa011       IN     iraa02.iaa011%TYPE,--ҵ������
      prm_iaa003       IN     iraa02.iaa003%TYPE,--ҵ������
      prm_iaa018       IN     irad22.iaa018%TYPE,--��˱�־
      prm_iaa028       IN     VARCHAR2          ,--�Ƿ�ȫ��
      prm_aae011       IN     iraa02.iaa011%TYPE,--������
      prm_aae013       IN     iraa02.aae013%TYPE,--��ע
      prm_aaz002       OUT    VARCHAR2          ,
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      n_count    number(5);
      v_iaz011   varchar2(15);
      v_iaz009   varchar2(15);
      v_iaz010   varchar2(15);
      v_aaz002   varchar2(15);
      v_iaa015   varchar2(1);
      v_iaa004   number(1);
      v_iaa014   number(1);
      v_iaa017   number(1);
      v_yae099   varchar2(15);
      max_aae001 number(4);
      sum_YAC004 number(12,2);
      var_aab001 varchar2(6);
      max_ny_aae001 number(6);
      v_aab001     varchar(6);

      --�����α꣬��ȡ���������Ա��Ϣ
      CURSOR cur_tmp_person IS
      SELECT a.IAC001, --�걨��Ա��Ϣ���,VARCHAR2
             b.AAC001, --���˱��,VARCHAR2
             a.AAB001, --��λ���,VARCHAR2
             a.AAC002, --������ݺ���,VARCHAR2
             a.AAC003, --����,VARCHAR2
             b.IAA001, --��Ա���
             a.IAZ005, --�걨��ϸID
             a.IAA003  --ҵ������
        FROM wsjb.IRAD22_TMP  a,wsjb.IRAC01  b --���������Ա��Ϣ��ʱ��
       WHERE a.iac001 = b.iac001
        ORDER by a.iaa003;

                 -- ��λ�α��α�
    CURSOR cur_canbao_company  IS
      SELECT
        AAB001,
        AAE140
       FROM xasi2.ab02
       WHERE  aab001 = var_aab001 and aab051='1' and aae140<>'07';


   BEGIN

      /*��ʼ������*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;
      prm_aaz002   :='';

      /*�����ʱ���Ƿ��������*/
      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.IRAD22_TMP ;
      IF n_count = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'�����ʱ���޿�������!';
         RETURN;
      END IF;


      /*��Ҫ������У��*/
      IF prm_iaa011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'ҵ�����Ͳ���Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa003 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'ҵ�����岻��Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa018 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'��˱�־����Ϊ��!';
         RETURN;
      END IF;

      IF prm_iaa028 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'��־[�Ƿ�ȫ��]����Ϊ��!';
         RETURN;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
      IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�AAZ002!';
         RETURN;
      END IF;

      v_iaz009 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ009');
      IF v_iaz009 IS NULL OR v_iaz009 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�IAZ009!';
         RETURN;
      END IF;

      prm_aaz002 :=v_aaz002;



      --����¼�
      INSERT INTO wsjb.IRAD21
                 (
                  IAZ009,
                  AAZ002,
                  IAA011,
                  AEE011,
                  AAE035,
                  YAB003,
                  AAE013
                  )
                  VALUES
                  (
                  v_iaz009,
                  v_aaz002,
                  prm_iaa011,
                  prm_aae011,
                  sysdate,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae013
      );




      FOR REC_TMP_PERSON IN cur_tmp_person LOOP

         --�걨�����Ǹ���ʱУ�飺���뵥λ��Ϣ���ͨ�����ܰ���
         IF REC_TMP_PERSON.iaa003 = PKG_Constant.IAA003_PER THEN
            SELECT COUNT(1)
              INTO n_count
              FROM wsjb.IRAB01
             WHERE AAB001 = REC_TMP_PERSON.AAB001
               AND IAA002 = PKG_Constant.IAA002_APS;
            IF n_count = 0 THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'��λ��Ϣ���ͨ�����ܰ�����Ա���걨���!';
               RETURN;
            END IF;
         END IF;

          /*
            �����Ա����Ϣ���
            ���԰�����Ǵ�� ͨ�� ��ͨ�� ����ͨ�� ȫ��ͨ�� ȫ��ͨ��
         */

         --�����ϸ����
         v_iaz010 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ010');
         IF v_iaz010 IS NULL OR v_iaz010 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ�����к�IAZ010!';
            RETURN;
         END IF;

         --��ѯ�ϴ�������
         BEGIN
            SELECT IAA015
              INTO v_iaa015
              FROM wsjb.IRAD02
             WHERE IAZ005 = REC_TMP_PERSON.IAZ005;

            IF v_iaa015 in (PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
              prm_ErrorMsg := PRE_ERRCODE ||'����Ѿ��ս�!';
              RETURN;
           END IF;

            --��ȡ�ϴ������Ϣ
            IF v_iaa015 = PKG_Constant.IAA015_ADI THEN
               BEGIN
                  SELECT A.IAZ010,
                         A.IAA004,
                         A.IAA014,
                         A.IAA017
                    INTO v_iaz011,
                         v_iaa004,
                         v_iaa014,
                         v_iaa017
                    FROM wsjb.IRAD22  A
                   WHERE A.IAA018 NOT IN (
                                          PKG_Constant.IAA018_DAD, --���[�������]
                                          PKG_Constant.IAA018_NPS  --��ͨ�� Not Pass
                                         )
                     AND A.IAZ005 = REC_TMP_PERSON.IAZ005
                     AND A.IAZ010 = (
                                      SELECT MAX(IAZ010)
                                        FROM wsjb.IRAD22
                                       WHERE IAZ005 = A.IAZ005
                                         AND IAA018 = A.IAA018
                                    );
                  EXCEPTION
                  WHEN OTHERS THEN
                     ROLLBACK;
                     prm_AppCode  := gn_def_ERR;
                     prm_ErrorMsg := PRE_ERRCODE ||'�걨��Ϣ��������У���δ��ȡ���ϴ������Ϣ,��ȷ���ϴ�����Ƿ��ս�!';
                     RETURN;
               END;

               v_iaa014 := v_iaa017;
               v_iaa017 := v_iaa017 + 1;
               IF v_iaa017 > v_iaa004 THEN
                  v_iaa017 := v_iaa004;
               END IF;

               --��˼��ε��ڵ�ǰ����
               IF v_iaa004 = v_iaa014 AND v_iaa004 = v_iaa017 THEN
                  ROLLBACK;
                  prm_AppCode  := gn_def_ERR;
                  prm_ErrorMsg := PRE_ERRCODE ||'����Ѿ��ս�!';
                  RETURN;
               END IF;
            END IF;

            --��ȡ�걨��ϸ��Ϣ
            IF v_iaa015 = PKG_Constant.IAA015_WAD THEN
               BEGIN
                  SELECT A.IAA004,
                         A.IAA014
                    INTO v_iaa004,
                         v_iaa014
                    FROM wsjb.IRAD02  A
                   WHERE A.IAZ005 = REC_TMP_PERSON.IAZ005;
                  EXCEPTION
                  WHEN OTHERS THEN
                     ROLLBACK;
                     prm_AppCode  := gn_def_ERR;
                     prm_ErrorMsg := PRE_ERRCODE ||'û����ȡ���걨��ϸ��Ϣ!';
                     RETURN;
               END;
               v_iaz011 := v_iaz010;
               v_iaa014 := v_iaa014 + 1;
               v_iaa017 := v_iaa014 + 1;
               IF v_iaa017 > v_iaa004 THEN
                  v_iaa017 := v_iaa004;
               END IF;
            END IF;

            EXCEPTION
            WHEN OTHERS THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := '�����Ϣ��ȡ����:'|| PRE_ERRCODE || SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() ;
               RETURN;
         END;

         --�����ϸд��
         INSERT INTO wsjb.IRAD22
                    (
                     IAZ010,
                     IAZ011,
                     IAZ009,
                     IAZ005,
                     IAA004,
                     IAA014,
                     IAA017,
                     AAE011,
                     AAE035,
                     YAB003,
                     IAA018,
                     IAD005,    --������
                     AAE013
                     )
                    VALUES
                    (
                     v_iaz010,
                     v_iaz011,
                     v_iaz009,
                     REC_TMP_PERSON.IAZ005,
                     v_iaa004,
                     v_iaa014,
                     v_iaa017,
                     prm_aae011,
                     sysdate,
                     PKG_Constant.YAB003_JBFZX,
                     prm_iaa018,
                     prm_aae013,  --������
                     null
         );

         --���
         IF prm_iaa018 = PKG_Constant.IAA018_DAD THEN

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_DAD,--���[�޸�����]
                   AAE013 = prm_aae013
             WHERE IAA015 = PKG_Constant.IAA015_WAD --����
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_ALR  --�Ѵ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --���δͨ��
         IF prm_iaa018 = PKG_Constant.IAA018_NPS THEN

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015  = PKG_Constant.IAA015_ADO, --������
                   AAE013  = prm_aae013
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --����/�����
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --�����걨��Ա״̬
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_NPS  --δͨ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --���ͨ��
         IF prm_iaa018 = PKG_Constant.IAA018_PAS AND v_iaa014 = v_iaa004 THEN

            --�����걨��ϸ
            UPDATE wsjb.IRAD02
               SET IAA015  =  PKG_Constant.IAA015_ADO --������
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --����/�����
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

           v_yae099    := xasi2.PKG_comm.fun_GetSequence(NULL,'yae099');
            IF v_yae099 IS NULL OR v_yae099 = '' THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'û�л�ȡ��ϵͳ������к�:YAE099';
               RETURN;
             END IF;


            IF REC_TMP_PERSON.iaa003 = '2' THEN


               /*
                  ��Ա����[�²α��������²α�]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_ADD,PKG_Constant.IAA001_PAD) THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[�²α� ����]
                     �Ϸ��� prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuCheck(v_yae099,
                                  REC_TMP_PERSON.AAB001,
                                  REC_TMP_PERSON.IAC001,
                                  prm_aae011,
                                  PKG_Constant.YAB003_JBFZX,
                                  sysdate,
                                  prm_AppCode,
                                  prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  ��Ա����[��Ա��������]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_IAD THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[�²α� ����]
                     �Ϸ��� prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuAddCheck(v_yae099,
                                    REC_TMP_PERSON.AAB001,
                                    REC_TMP_PERSON.IAC001,
                                    prm_aae011,
                                    PKG_Constant.YAB003_JBFZX,
                                    sysdate,
                                    prm_AppCode,
                                    prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  ��Ա����[��Ա����]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_CIN THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[�²α� ����]
                     �Ϸ��� prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuContinue(v_yae099,
                                    REC_TMP_PERSON.AAB001,
                                    REC_TMP_PERSON.IAC001,
                                    prm_aae011,
                                    PKG_Constant.YAB003_JBFZX,
                                    sysdate,
                                    prm_AppCode,
                                    prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  ��Ա����[��Ա��ͣ�ɷ���������ͣ�ɷѣ�������Ա����(����ͣ��ͬ)]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_MIN,PKG_Constant.IAA001_PMI,PKG_Constant.IAA001_RPD) THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[ͣ�� ����]
                     �Ϸ��� prc_AuditMonthInternetRpause
                  */

                  prc_PersonInsuPause(v_yae099,
                                      REC_TMP_PERSON.AAB001,
                                      REC_TMP_PERSON.IAC001,
                                      prm_aae011,
                                      PKG_Constant.YAB003_JBFZX,
                                      sysdate,
                                      prm_AppCode,
                                      prm_ErrorMsg
                                      );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  ��Ա����[��ְת����]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_RTR THEN
                  /*
                     �籣ϵͳ����¼�� ��Ա��Ϣ ��Ա������Ϣ[ͣ�� ����]
                     �Ϸ��� prc_AuditMonthInternetRpause
                  */
                  --����������� �޸ĸ���״̬�Լ����²α���Ϣ
                  v_yae099 := NULL;

                  BEGIN
                     SELECT MAX(yae099)
                       INTO v_yae099
                       FROM XASI2.ac02_apply
                      WHERE AAC001 = REC_TMP_PERSON.AAC001
                        AND AAB001 = REC_TMP_PERSON.AAB001
                        AND YAE031 = '0'                    --δ���
                        AND AAE120 = '0'
                        AND FLAG   = '3';                   --��������
                     EXCEPTION
                      WHEN OTHERS THEN
                          prm_AppCode  :=  gn_def_ERR;
                          prm_ErrorMsg :=  PRE_ERRCODE || '������������û�л�ȡ��!';
                          RETURN;
                  END;

                  prc_PersonInsuToRetire(v_yae099,
                                        REC_TMP_PERSON.AAB001,
                                        REC_TMP_PERSON.IAC001,
                                        prm_aae011,
                                        PKG_Constant.YAB003_JBFZX,
                                        sysdate,
                                        prm_AppCode,
                                        prm_ErrorMsg
                                        );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;


      -- ����prc_Ab02a8Unit ��λ�ɷѻ���
         prc_Ab02a8Unit(     REC_TMP_PERSON.AAB001,
                                v_yae099,
                                prm_AppCode,
                                prm_ErrorMsg
                                        );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;


    -- ����ab02a8����
    --��ȡ������

  /**  select max(AAE001)
      into max_aae001
      from xasi2.ab05
     where aab001 = REC_TMP_PERSON.AAB001
       and YAB007 = '03';
     max_ny_aae001 := max_aae001||'01';

      var_aab001 := REC_TMP_PERSON.AAB001;
    FOR REC_CANBAO_COMPANY IN cur_canbao_company LOOP

      SELECT COUNT(1)
        INTO n_count
        FROM xasi2.ab02a8
       where aab001 = REC_TMP_PERSON.AAB001
         and aae001 = max_aae001
         and aae140 = REC_CANBAO_COMPANY.AAE140;

      IF n_count = 0 THEN

        Insert Into xasi2.ab02a8
          (YAE099, --   ҵ����ˮ��
           AAB001, --   ��λ���
           AAE140, --  ��������
           AAE041, --   ��ʼ�ں�
           AAE042, --   ��ֹ�ں�
           AAB121, --   ��λ�ɷѻ����ܶ�
           AAE001, --   ���
           AAE011, --   ������
           AAE036, --    ����ʱ��
           YAB003, --  �籣�������
           YAE031, --   ��˱�־
           YAE032, --   �����
           YAE033, --   ���ʱ��
           YAE569, --  ��˾������
           YAB139, --   �α�����������
           AAE013 --  ��ע
           )
         select  v_yae099,
                 AAB001,
                 REC_CANBAO_COMPANY.AAE140,
                 max_ny_aae001,
                 null,
                (select sum(YAC004)
                  from xasi2.ac02
           where AAb001 = REC_TMP_PERSON.AAB001
             and YAc503 in( '0','5')
             and AAC031 = '1'
             and AAE140 = REC_CANBAO_COMPANY.AAE140)  yac004 ,
                 max_aae001,
                 AAE011,
                 AAE036,
                 YAB003,
                 '1',
                 AAE011,
                 AAE036,
                 YAB003,
                 YAB139,
                 AAE013
            from xasi2.ab02
           where
             AAb001=REC_TMP_PERSON.AAB001
            and   aab051='1'
            and AAE140 = REC_CANBAO_COMPANY.AAE140;


      end if;

      IF n_count = 1 THEN

        select sum(YAC004)
          into sum_YAC004
          from xasi2.ac02
         where AAE140 = REC_CANBAO_COMPANY.AAE140
           and AAB001 = REC_TMP_PERSON.AAB001
           and YAc503 in( '0','5')
           and AAC031 = '1';

        update xasi2.ab02a8
           set AAB121 = sum_YAC004 --   ��λ�ɷѻ����ܶ�
         where AAB001 = REC_TMP_PERSON.AAB001
           and AAE140 = REC_CANBAO_COMPANY.AAE140;

      end if;
    end LOOP;
    */



               --2013-03-14 ����  Ӧ�����Ƚ��в���������״̬
               --�����걨��Ա״̬
               UPDATE wsjb.irac01
                  SET IAA002 = PKG_Constant.IAA002_APS  --��ͨ��
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --���걨
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;
            --������ر�
            INSERT INTO wsjb.AE02A1
                        (
                         AAZ002,
                         YAE099,
                         IAA020,
                         AAB001,
                         AAC001,
                         IAA001
                        )
                  VALUES(
                        v_aaz002,
                        v_yae099,
                        REC_TMP_PERSON.iaa003,
                        REC_TMP_PERSON.AAB001,
                        REC_TMP_PERSON.IAC001,
                        REC_TMP_PERSON.IAA001
                        );
         END IF;

      END LOOP;





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
                  PKG_Constant.AAA121_MIA,
                  prm_aae011,
                  PKG_Constant.YAB003_JBFZX,
                  prm_aae011,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate,
                  prm_aae013
                 );
   EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| PRE_ERRCODE || SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END prc_AuditMonthInternetRNew;




  /*****************************************************************************
 ** �������� : prc_PersonInfoRepair
 ** ���̱�� ��
 ** ҵ�񻷽� ��
 ** �������� ���±����ͨ�����������Ϣ
 ******************************************************************************
 ** �������� ��������ʶ        ����/���         ����                 ����
 ******************************************************************************
 **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
 **           prm_iac001        IN    irac01.iac001%TYPE,--�걨���
 **           prm_aac001       IN    irac01.aac001%TYPE,  --���˱��
 **           prm_aac002       IN    irac01.aac002%TYPE, --֤����
 **           prm_aab001       IN    irab01.aab001%TYPE,  --��λ������
 **           prm_aae011       IN    irac01.aae011%TYPE ,  --������
 **           prm_AppCode      OUT    VARCHAR2          ,
 **           prm_ErrorMsg     OUT    VARCHAR2
 ******************************************************************************
 ** ��    �ߣ�yh         �������� ��2018-12-21   �汾��� ��Ver 1.0.0
 ** ��    �ģ�
 *****************************************************************************/
  PROCEDURE prc_PersonInfoRepair(prm_yae099 IN VARCHAR2, --ҵ����ˮ��
                               prm_iac001   IN irac01.iac001%TYPE,--�걨���
                               prm_aac001  IN irac01.aac001%TYPE, --���˱��
                               prm_aac002  IN irac01.aac002%TYPE, --֤������
                               prm_aab001  IN irab01.aab001%TYPE, --��λ������
                               prm_aae011  IN irac01.aae011%TYPE, --������
                               prm_AppCode OUT VARCHAR2, --�������
                               prm_ErrMsg  OUT VARCHAR2) --��������
   IS
     num_count_ac01     number;
     num_count_chkac01     number;
     var_chk_aac007    varchar2 (2);
     var_chk_aac005    varchar2 (2);
     var_chk_aac012    varchar2 (2);
     var_chk_aac014    varchar2 (2);
     var_chk_aac015    varchar2 (2);
     var_chk_aac020    varchar2 (2);
     var_chk_yac200    varchar2 (2);
     var_chk_aac010    varchar2 (2);
     var_chk_aac011    varchar2 (2);
     var_chk_aac021    varchar2 (2);
     var_chk_aac022    varchar2 (2);
     var_chk_aae005    varchar2 (2);
     var_chk_aae006    varchar2 (2);
     var_chk_yae222    varchar2 (2);
     var_chk_aae007    varchar2 (2);
     rec_irac01    irac01%rowtype;
     var_col         varchar2(10);
     var_val         varchar2(200);
     var_sql         varchar2(200);
     var_sb_aac001  irac01.aac001%type;
     var_before_yac503 xasi2.ac02.yac503%type;
     yac503_count    number(3);
     zc_count        number(3);

   cursor  cur_chk_ac01(var_aac001 varchar2 , var_aab001 varchar2 ) is
      select *
         from wsjb.chk_ac01
      where nullsign ='0'
         and aac001 = var_aac001
         and aab001 = var_aab001;

     -- wangz ���������    �걨��Ϣ��ȡ
  --  cursor   shenBao_irac01  is  select  * from wsjb.irac01
                            --     where aab001 = prm_aab001 and iaa001 = PKG_Constant.IAA001_CIN  and  iaa002 = PKG_Constant.IAA002_AIR;
    cursor   yac503_ac02     is select aac001,aae140 ,yac503 from xasi2.ac02
                                 where aac001 = prm_aac001 and aac031 = PKG_Constant.AAC031_ZTJF and yac503 <> '0'  group by aac001, aae140,yac503 ;
  BEGIN
        prm_AppCode  := PKG_Constant.GN_DEF_OK;
        prm_ErrMsg := '';


   select count(1)
      into num_count_ac01
   from xasi2.ac01
      where aac001 = prm_aac001
          and aac002 = prm_aac002
          and (aac007 is null
          or aac005 is null
          or aac012 is null
          or aac014 is null
          or aac015 is null
          or aac020 is null
          or yac200 is null
          or aac010 is null
          or aac011 is null
          or aac021 is null
          or aac022 is null
          or aae005 is null
          or aae006 is null
          or yae222 is null
          or aae007 is null);

   if num_count_ac01=1 then
       select
          case when aac007 is null then '0' else '1' end as aac007,
          case when aac005 is null then '0' else '1' end as aac005,
          case when aac012 is null then '0' else '1' end as aac012,
          case when aac014 is null then '0' else '1' end as aac014,
          case when aac015 is null then '0' else '1' end as aac015,
          case when aac020 is null then '0' else '1' end as aac020,
          case when yac200 is null then '0' else '1' end as yac200,
          case when aac010 is null then '0' else '1' end as aac010,
          case when aac011 is null then '0' else '1' end as aac011,
          case when aac021 is null then '0' else '1' end as aac021,
          case when aac022 is null then '0' else '1' end as aac022,
          case when aae005 is null then '0' else '1' end as aae005,
          case when aae006 is null then '0' else '1' end as aae006,
          case when yae222 is null then '0' else '1' end as yae222,
          case when aae007 is null then '0' else '1' end as aae007
       into
          var_chk_aac007 ,
          var_chk_aac005 ,
          var_chk_aac012 ,
          var_chk_aac014 ,
          var_chk_aac015 ,
          var_chk_aac020 ,
          var_chk_yac200 ,
          var_chk_aac010 ,
          var_chk_aac011 ,
          var_chk_aac021 ,
          var_chk_aac022 ,
          var_chk_aae005 ,
          var_chk_aae006 ,
          var_chk_yae222 ,
          var_chk_aae007
       from xasi2.ac01
       where aac001 = prm_aac001
           and aac002 = prm_aac002;


      select
          aac007,
          aac005,
          aac012,
          aac014,
          aac015,
          aac020,
          yac200,
          aac010,
          aac011,
          aac021,
          aac022,
          aae005,
          aae006,
          yae222,
          aae007
       into
          rec_irac01.aac007 ,
          rec_irac01.aac005 ,
          rec_irac01.aac012 ,
          rec_irac01.aac014 ,
          rec_irac01.aac015 ,
          rec_irac01.aac020 ,
          rec_irac01.yac200 ,
          rec_irac01.aac010 ,
          rec_irac01.aac011 ,
          rec_irac01.aac021 ,
          rec_irac01.aac022 ,
          rec_irac01.aae005 ,
          rec_irac01.aae006 ,
          rec_irac01.yae222 ,
          rec_irac01.aae007
       from wsjb.irac01
       where aac001 = prm_aac001
           and aac002 = prm_aac002
           and iac001 = prm_iac001;


       if  var_chk_aac007 ='0' and  rec_irac01.aac007 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac007','0','�μӹ�������',prm_aae011);
       end if ;
       if  var_chk_aac005 ='0' and rec_irac01.aac005 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac005','0','����',prm_aae011);
       end if ;
      if  var_chk_aac014 ='0' and rec_irac01.aac014 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac014','0','רҵ����ְ��',prm_aae011);
       end if ;
       if  var_chk_aac015 ='0' and rec_irac01.aac015 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac015','0','���˼����ȼ�',prm_aae011);
       end if ;
       if  var_chk_aac020='0' and rec_irac01.aac020 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac020','0','����ְ��',prm_aae011);
       end if ;
       if  var_chk_yac200 ='0' and rec_irac01.yac200 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'yac200','0','����Ա����ְ��',prm_aae011);
       end if ;
       if  var_chk_aac010 ='0' and rec_irac01.aac010 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac010','0','�������ڵ�',prm_aae011);
       end if ;
       if  var_chk_aac011 ='0' and rec_irac01.aac011 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac011','0','�Ļ��̶�',prm_aae011);
       end if ;
       if  var_chk_aac021 ='0' and rec_irac01.aac021 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac021','0','��ҵ����',prm_aae011);
       end if ;
       if  var_chk_aac022 ='0' and rec_irac01.aac022 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac022','0','��ҵԺУ',prm_aae011);
       end if ;
       if  var_chk_aae005 ='0' and rec_irac01.aae005 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aae005','0','��ϵ�绰',prm_aae011);
       end if ;
       if  var_chk_aae006 ='0' and rec_irac01.aae006 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aae006','0','��ַ',prm_aae011);
       end if ;
       if  var_chk_yae222 ='0' and rec_irac01.yae222 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'yae222','0','EMAIL',prm_aae011);
       end if ;
       if  var_chk_aae007 ='0' and rec_irac01.aae007 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aae007','0','�ʱ�',prm_aae011);
       end if ;


   for rec_chk_ac01 in cur_chk_ac01(prm_aac001,prm_aab001) loop
          select count(1)
            into num_count_chkac01
            from wsjb.chk_ac01
           where nullsign ='0'
               and aac001 = prm_aac001
               and aab001 = prm_aab001;

        if num_count_chkac01 > 0 then

        var_col := rec_chk_ac01.col;
        var_sql := 'SELECT '||var_col||' FROM wsjb.irac01 where iAC001 = '''||prm_iac001||'''';
        EXECUTE IMMEDIATE var_sql INTO var_val;
        var_val := to_char(var_val);

              insert into xasi2.ae15(
                                yae099,
                                yae011,
                                aac001,
                                aab001,
                                aae140,
                                yae337,
                                yae338,
                                yae339,
                                yae340,
                                yae341,
                                yae342,
                                yae343,
                                yae344,
                                yae345,
                                aae013,
                                aae011,
                                aae036,
                                yab139,
                                yab003)
                     select prm_yae099,
                                xasi2.pkg_comm.fun_getsequence(null,'yae011'),
                                rec_chk_ac01.aac001,
                                rec_chk_ac01.aab001,
                                null,
                                '��Ա����������Ϣ����',
                                '��Ա����������Ϣ����',
                                'ac01',
                                rec_chk_ac01.col,
                                rec_chk_ac01.comm,
                                null,  --old
                                null,
                                var_val,  --new
                                null,
                                null,
                                rec_chk_ac01.aae011,
                                sysdate,
                                '610127',
                                '610127'
                       from  dual;
           end if;
      end loop;

      select *
        into rec_irac01
        from wsjb.irac01
      where iac001 = prm_iac001;

       update xasi2.ac01
         set aac007 = (case when aac007 is null then rec_irac01.aac007 else aac007 end),
               aac005 = (case when aac005 is null then rec_irac01.aac005 else aac005 end),
               aac012 = (case when aac012 is null then rec_irac01.aac012 else aac012 end),
               aac014 = (case when aac014 is null then rec_irac01.aac014 else aac014 end),
               aac015 = (case when aac015 is null then rec_irac01.aac015 else aac015 end),
               aac020 = (case when aac020 is null then rec_irac01.aac020 else aac020 end),
               yac200 = (case when yac200 is null then rec_irac01.yac200 else yac200 end),
               aac010 = (case when aac010 is null then rec_irac01.aac010 else aac010 end),
               aac011 = (case when aac011 is null then rec_irac01.aac011 else aac011 end),
               aac021 = (case when aac021 is null then rec_irac01.aac021 else aac021 end),
               aac022 = (case when aac022 is null then rec_irac01.aac022 else aac022 end),
               aae005 = (case when aae005 is null then rec_irac01.aae005 else aae005 end),
               aae006 = (case when aae006 is null then rec_irac01.aae006 else aae006 end),
               yae222 = (case when yae222 is null then rec_irac01.yae222 else yae222 end),
               aae007 = (case when aae007 is null then rec_irac01.aae007 else aae007 end)
         where aac001 = prm_aac001
             and aac002 = prm_aac002;
  end if;

  --  ֻά��������Ա�������
  select count(1) INTO zc_count from xasi2.ac01 a,xasi2.kc01 b where a.aac001 = b.aac001
                                             and a.aac008 = PKG_Constant.AAC008_ZZ
                                             and b.akc021 = PKG_Constant.AKC021_ZZ
                                             and a.aac001 = prm_aac001;

  --���������
  if zc_count > 0 then
    --for Sb_shenBao_irac01 in  shenBao_irac01 loop
     --var_sb_aac001 := Sb_shenBao_irac01.aac001;
     select count(1) into yac503_count from xasi2.ac02 where aac001 = prm_aac001
                                    and aac031  = PKG_Constant.AAC031_ZTJF
                                    and yac503 <> PKG_Constant.YAC503_SB;
             if  yac503_count > 0 then
               --����ac02 �������
                 for gg_yac503_ac02 in  yac503_ac02 loop
                   var_before_yac503 := gg_yac503_ac02.yac503;
                    update xasi2.ac02 set yac503 = PKG_Constant.YAC503_SB  where aac001 = prm_aac001
                                                               and aac031  = PKG_Constant.AAC031_ZTJF
                                                               and aae140  = gg_yac503_ac02.aae140;
                -- д������Ϣae15
                      insert into xasi2.ae15(
                                yae099,
                                yae011,
                                aac001,
                                aab001,
                                aae140,
                                yae337,
                                yae338,
                                yae339,
                                yae340,
                                yae341,
                                yae342,
                                yae343,
                                yae344,
                                yae345,
                                aae013,
                                aae011,
                                aae036,
                                yab139,
                                yab003,
                                aae016)

                     select     prm_yae099,
                                xasi2.pkg_comm.fun_getsequence(null,'yae011'),
                                gg_yac503_ac02.aac001,
                                prm_aab001,
                                null,
                                '��Ա����������Ϣά��',
                                '��Ա����������Ϣά��',
                                'ac02',
                                'yac503',
                                '�������',
                                var_before_yac503,  --old
                                null,
                                '0',  --new
                                null,
                                null,
                                prm_aae011,
                                sysdate,
                                '610127',
                                '610127',
                                gg_yac503_ac02.aae140
                       from  dual;

                 end loop;
             end if ;

   --  end loop;
   end if;

  EXCEPTION
      WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '���ݿ����:'||PRE_ERRCODE ||SQLERRM||dbms_utility.format_error_backtrace ||'; iac001:'||prm_iac001||'; aac001:'||prm_aac001||'; aac002:'||prm_aac002;
        RETURN;

  END prc_PersonInfoRepair;



    /*****************************************************************************
   ** �������� : prc_PersonInsuPause
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� �����걨���[��Աͣ�����]
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--ҵ����ˮ��
   **           prm_aab001       IN     irab01.aab001%TYPE,--��λ������
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-10-19   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_PersonInsuPauseTS(prm_yae099       IN    VARCHAR2   ,    --ҵ����ˮ��
                             prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --��λ����
                             prm_iac001       IN    irac01.iac001%TYPE ,    --�걨�˱��
                             prm_aae011       IN    irac01.aae011%TYPE ,    --������
                             prm_yab003       IN    irac01.yab003%TYPE ,    --�籣�������
                             prm_aae036       IN    irac01.aae036%TYPE ,    --����ʱ��
                             prm_AppCode      OUT   VARCHAR2  ,    --�������
                             prm_ErrMsg       OUT   VARCHAR2  )    --��������
   IS
      var_procNo      VARCHAR2(2);         --�������
      num_count       NUMBER;
      var_yac001      VARCHAR2(20);
      var_yae235      VARCHAR2(6);
      var_yae238      VARCHAR2(2000);
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --���˱��
      var_aae140_01   VARCHAR2(2);         --�Ƿ�μ�����ҵ����
      var_aae140_06   VARCHAR2(2);         --�Ƿ�μ��˻�������
      var_aae140_02   VARCHAR2(2);         --�Ƿ�μ���ʧҵ
      var_aae140_03   VARCHAR2(2);         --�Ƿ�μ��˻���ҽ��
      var_aae140_04   VARCHAR2(2);         --�Ƿ�μ��˹���
      var_aae140_05   VARCHAR2(2);         --�Ƿ�μ�������
      var_aae140_07   VARCHAR2(2);         --�Ƿ�μ��˴��
      var_aae140_08   VARCHAR2(2);
      rec_irac01      irac01%rowtype;
       v_aad055       VARCHAR2(100);
       prm_aac001_out   VARCHAR2(10);
   BEGIN
      prm_AppCode  := PKG_Constant.GN_DEF_OK;
      prm_ErrMsg   := '';
      var_aac001   := '';

      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      var_aae140_01 := rec_irac01.aae110;        --�Ƿ�μ�����ҵ����
      var_aae140_06 := rec_irac01.aae120;        --�Ƿ�μ��˻�������
      var_aae140_02 := rec_irac01.aae210;        --�Ƿ�μ���ʧҵ
      var_aae140_03 := rec_irac01.aae310;        --�Ƿ�μ��˻���ҽ��
      var_aae140_04 := rec_irac01.aae410;        --�Ƿ�μ��˹���
      var_aae140_05 := rec_irac01.aae510;        --�Ƿ�μ�������
      var_aae140_07 := rec_irac01.aae311;        --�Ƿ�μ��˴��
      var_aae140_08 := rec_irac01.aae810;

      IF var_aae140_06 = '3' OR var_aae140_02 = '3'
      OR var_aae140_03 = '3' OR var_aae140_04 = '3'
      OR var_aae140_05 = '3' OR var_aae140_07 = '3'
      OR var_aae140_08 = '3' THEN
         --д����ʱ������
         PKG_COMMON.PRC_P_insertAe16Tmp(prm_yae099,
                                       prm_iac001,
                                       '03', --����������ͣ
                                       prm_aab001,
                                       prm_aae011,
                                       prm_AppCode,
                                       prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;
         --��ʱ������У��
         xasi2.pkg_p_Person_Batch.prc_p_Person_pause_check(prm_yae099,
                                                           prm_aab001,
                                                           PKG_Constant.YAB003_JBFZX,
                                                           prm_aae011,
                                                           PKG_Constant.YAB003_JBFZX,
                                                           prm_AppCode,
                                                           prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;

         SELECT yae235,NVL(yae238,''),aad055
           INTO var_yae235,var_yae238,v_aad055
           FROM xasi2.AE16A1
          WHERE YAE099 = prm_yae099;
         IF var_yae235 = '2' THEN
            prm_AppCode := PKG_Constant.gn_def_ERR;
            prm_ErrMsg  := '��Ա�α���ϢУ��ʧ��:'||var_yae238||v_aad055;
            RETURN;
         END IF;

         --����������ͣ�������ݵ���
         xasi2.pkg_p_Person_Batch.prc_p_Person_pause_treat(prm_yae099,
                                                        prm_aab001,
                                                        '1'       ,    --'1' ֻ������ɹ���--'2' ������ڼ��ʧ������
                                                        PKG_Constant.YAB003_JBFZX,
                                                        prm_aae011,
                                                        PKG_Constant.YAB003_JBFZX,
                                                        prm_AppCode,
                                                        prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;

      END IF;

          IF  var_aae140_01 is  NULL THEN
           UPDATE wsjb.IRAC01A3
         SET
             AAE120 = DECODE(var_aae140_06,'3','0',var_aae140_06),
             AAE210 = DECODE(var_aae140_02,'3','0',var_aae140_02),
             AAE310 = DECODE(var_aae140_03,'3','0',var_aae140_03),
             AAE410 = DECODE(var_aae140_04,'3','0',var_aae140_04),
             AAE510 = DECODE(var_aae140_05,'3','0',var_aae140_05),
             AAE311 = DECODE(var_aae140_07,'3','0',var_aae140_07)
       WHERE AAC001 = rec_irac01.aac001
         AND AAB001 = rec_irac01.AAB001;
        ELSE
           UPDATE wsjb.IRAC01A3
         SET
             AAE110 = DECODE(var_aae140_01,'3','0',var_aae140_01),
             AAE120 = DECODE(var_aae140_06,'3','0',var_aae140_06),
             AAE210 = DECODE(var_aae140_02,'3','0',var_aae140_02),
             AAE310 = DECODE(var_aae140_03,'3','0',var_aae140_03),
             AAE410 = DECODE(var_aae140_04,'3','0',var_aae140_04),
             AAE510 = DECODE(var_aae140_05,'3','0',var_aae140_05),
             AAE311 = DECODE(var_aae140_07,'3','0',var_aae140_07)
       WHERE AAC001 = rec_irac01.aac001
         AND AAB001 = rec_irac01.AAB001;


        END IF;

   EXCEPTION
      WHEN OTHERS THEN
        /*�رմ򿪵��α�*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '���ݿ����:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuPauseTS;




PROCEDURE prc_insertAC29(

                               prm_aab001  IN irab01.aab001%TYPE, --��λ������
                               prm_iaa100  IN irac01.iaa100%TYPE,
                               prm_aae011  IN irac01.aae011%TYPE, --������
                               prm_AppCode OUT VARCHAR2, --�������
                               prm_ErrorMsg  OUT VARCHAR2) --��������
   IS

    VAR_IAA001  IRAC01.IAA001%TYPE;
     VAR_COUNT  NUMBER(6);
     VAR_YAB136   XASI2.AB01.YAB136%TYPE;
     VAR_YAB275   XASI2.AB01.YAB275%TYPE;
      MAX_YAC005  XASI2.AC29.YAC005%TYPE;



   VAR_AAB001 XASI2.AB01.AAB001%TYPE;
   VAR_AAC001 XASI2.AC01.AAC001%TYPE;
   VAR_YAB139 XASI2.AB02.YAB139%TYPE;
   DAT_AAE036 XASI2.AB01.AAE036%TYPE;
   NUM_AAE011 XASI2.AB01.AAE011%TYPE;
   VAR_YAE099 XASI2.AE16.YAE099%TYPE;
   VAR_AAC003 XASI2.AC01.AAC003%TYPE;
   VAR_YAC136 XASI2.AC29.YAC136%TYPE;
   VAR_YAC005 XASI2.AC29.YAC005%TYPE;
   VAR_YAE096 XASI2.AC29.YAE096%TYPE;
   VAR_YAE567 XASI2.AC29.YAE567%TYPE;
   VAR_YAC527 XASI2.AC29.YAC527%TYPE;
   VAR_YAE566 XASI2.AC29.YAE566%TYPE; --�ƿ�������
   NUM_YAE540 NUMBER(6);
   VAR_YAC150 XASI2.AC29.YAC150%TYPE; --������Ա����

   /*
   CURSOR CUR_AC01 IS
      SELECT DISTINCT AAC001, AAC003, aab001
        FROM jh_20181012_ac01 a
       WHERE aab001 is not null
         and NOT EXISTS
       (SELECT 1 FROM XASI2.AC29 WHERE A.AAC001 = AAC001);
   */

   CURSOR CUR IS

    SELECT
       a.iaa001 as iaa001,
       a.aac001 as aac001,
       a.aab001 as aab001,
       a.aac003 as aac003,
       a.aac002 as aac002
      FROM wsjb.irac01 a
       WHERE a.aab001 = prm_aab001
        and  a.IAA100 = prm_iaa100
        and  a.IAA001 in ('1','5','6','8')
        and  a.AAE310 in ('1','2','10')
        and  a.IAA002 = '2';


BEGIN

        prm_AppCode  := PKG_Constant.GN_DEF_OK;
        prm_ErrorMsg := '';

      DAT_AAE036 := to_date(sysdate);
      NUM_AAE011 := prm_aae011;

      SELECT XASI2.SEQ_YAE099.NEXTVAL INTO VAR_YAE099 FROM DUAL;
      SELECT XASI2.SEQ_YAC136.NEXTVAL INTO VAR_YAC136 FROM DUAL;

      FOR REC IN CUR
      LOOP




      SELECT
          count(1) into  VAR_COUNT
      FROM xasi2.ac29 a
     WHERE 1 = 1
    AND a.aac001 = rec.aac001;





   IF VAR_COUNT = 0 THEN

         VAR_AAB001 := REC.AAB001;
         VAR_AAC001 := REC.AAC001;
         VAR_AAC003 := REC.AAC003;

         VAR_YAC005 := VAR_AAC001 || '001';
         IF LENGTH(VAR_AAC001) < 10 THEN
            VAR_YAC005 := '9' || VAR_AAC001 || '001';
         END IF;

         VAR_YAE096 := '1';
         SELECT XASI2.PKG_COMM.FUN_K_ENCRYPTSTRING_MM(VAR_YAE096)
           INTO VAR_YAE096
           FROM DUAL;
         VAR_YAE567 := 'SI' || VAR_AAC001;
         IF LENGTH(VAR_AAC001) < 10 THEN
            VAR_YAE567 := 'SI9' || VAR_AAC001;
         END IF;

         SELECT XASI2.PKG_COMM.FUN_K_ENCRYPTSTRING(VAR_YAC005)
           INTO VAR_YAC527
           FROM DUAL;

         SELECT XASI2.PKG_COMM.FUN_K_ENCRYPTMANUFACTURER(VAR_YAC005)
           INTO VAR_YAE566
           FROM DUAL;

         NUM_YAE540 := 0;
         VAR_YAC150 := '03';
         INSERT INTO XASI2.AC29
            (AAC001, --���˱��,VARCHAR2
             YAC150, --����ʱ��Ա����,VARCHAR2
             YAC139, --�籣��״̬,VARCHAR2
             YAC137, --�ƿ�״̬,VARCHAR2
             YAC005, --����,VARCHAR2
             YAE096, --����,VARCHAR2
             YAC136, --�ƿ��嵥���κ�,VARCHAR2
             AAC003, --��������,VARCHAR2
             YAE567, --������,VARCHAR2
             YAC527, --��������,VARCHAR2
             YAE566, --�ƿ�������,VARCHAR2
             AKC140, --��������,DATE
             YAE540, --�����ƿ�����,NUMBER
             AAE011, --������,NUMBER
             AAE036, --����ʱ��,DATE
             YAB003)
         VALUES
            (VAR_AAC001,
             VAR_YAC150,
             '0',
             '1',
             VAR_YAC005,
             VAR_YAE096,
             VAR_YAC136,
             VAR_AAC003,
             VAR_YAE567,
             VAR_YAC527,
             VAR_YAE566,
             DAT_AAE036,
             NUM_YAE540,
             NUM_AAE011,
             DAT_AAE036,
             '610127');
         INSERT INTO XASI2.AC29A2
            (YAE099, --ҵ����ˮ��,VARCHAR2
             AAC001, --���˱��,VARCHAR2
             AAB001, --��λ���,VARCHAR2
             YAC005, --����,VARCHAR2
             AAE011, --������,NUMBER
             AAE036, --����ʱ��,DATE
             YAB003 --���������,VARCHAR2
             )
         VALUES
            (VAR_YAE099,
             VAR_AAC001,
             VAR_AAB001,
             VAR_YAC005,
             NUM_AAE011,
             DAT_AAE036,
             '610127');

             END IF;
      END LOOP;
      INSERT INTO XASI2.AC29A3
         (YAE099, -- ҵ����ˮ��   -->
          AAB001, -- ��λ���     -->
          YAB500, -- ��������     -->
          AAE011, -- ������       -->
          AAE036, -- ����ʱ��     -->
          YAB003, -- �������     -->
          YAE017)
         SELECT YAE099,
                AAB001, -- ��λ���     -->
                COUNT(1) AS YAB500, -- ��������     -->
                NUM_AAE011, -- ������       -->
                DAT_AAE036, -- ����ʱ��     -->
                '610127', -- �������     -->
                '0'
           FROM XASI2.AC29A2
          WHERE YAE099 = VAR_YAE099
          GROUP BY YAE099, AAB001;

     EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*�رմ򿪵��α�*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '���ݿ����:'|| PRE_ERRCODE || SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
END prc_insertAC29;




--û�������ĵ�λ ��д irac01 irad01 irad02
 PROCEDURE prc_insertIRAD01(
             prm_aab001  IN irab01.aab001%TYPE, --��λ������
             prm_aae011  IN irac01.aae011%TYPE, --������
             prm_AppCode OUT VARCHAR2, --�������
             prm_ErrorMsg  OUT VARCHAR2)

 IS
      N_COUNT    NUMBER(6);
      COUNT_AB02    NUMBER(6);
      COUNT_IRAB08    NUMBER(6);
      COUNT_IRAD01    NUMBER(6);
      VAR_SYSMONTH    VARCHAR2(8);
      VAR_SYSNEXMONTH    VARCHAR2(8);
      VAR_YAE097    VARCHAR2(8);
      VAR_YAE097NEX    VARCHAR2(8);
      MAX_IAA100    VARCHAR2(8);

VAR_AAZ002    VARCHAR2(15);
VAR_IAZ004    VARCHAR2(15);
VAR_IAA004    NUMBER(5);
VAR_IAC002    VARCHAR2(15);
VAR_AAC003    VARCHAR2(60);
VAR_IAC001    VARCHAR2(15);
VAR_AAC001    VARCHAR2(15);
VAR_IAZ005   VARCHAR2(15);
VAR_IAZ006   VARCHAR2(15);

TAR_IAA100   VARCHAR2(8);


   CURSOR CUR_IAA100S IS
          SELECT a.IAA100L
            FROM (SELECT DISTINCT TO_CHAR(LEVEL + TO_DATE(MAX_IAA100, 'yyyymm') - 1,'yyyymm') + 1 AS IAA100L
                    FROM DUAL a
                  CONNECT BY LEVEL <= TO_DATE(VAR_YAE097, 'yyyymm') - TO_DATE(MAX_IAA100, 'yyyymm')
                   ORDER BY IAA100L) a
           WHERE EXISTS
           (SELECT 1
                    FROM (
                          SELECT AAE042
                            FROM (SELECT AAE042
                                     FROM xasi2.ab08
                                    WHERE aab001 = prm_aab001
                                      AND yae517 = 'H01'
                                   UNION
                                   SELECT AAE042
                                     FROM xasi2.ab08a8
                                    WHERE aab001 = prm_aab001
                                      AND yae517 = 'H01'
                                   UNION
                                   SELECT AAE042
                                     FROM wsjb.irab08
                                    WHERE aab001 = prm_aab001
                                      AND yae517 = 'H01')
                          ) b
                   WHERE a.IAA100L =b. AAE042);


   CURSOR CUR_IRAC01 IS
         SELECT a.iac001,a.aac001,a.aac003,a.iaa002,a.iaa001
           FROM wsjb.irac01  a,wsjb.iraa01  b
          WHERE a.aab001 = b.aab001
            AND a.iaa001 <> '4'
            AND (a.iaa002 = PKG_Constant.IAA002_WIR OR a.iaa002 = PKG_Constant.IAA002_ALR)
            AND b.yae092 = prm_aae011
            AND a.iaa100 =TAR_IAA100;


 BEGIN

   prm_AppCode  := gn_def_OK;
   prm_ErrorMsg := '';
   TAR_IAA100:='';

   --��λ��������ں�
   SELECT COUNT(1)
     INTO COUNT_AB02
     FROM xasi2.AB02
    WHERE aab001 = prm_aab001
      AND aab051 = '1';
   IF COUNT_AB02 > 0 THEN      --һ�㵥λ�����ں�
      SELECT
           TO_CHAR(SYSDATE, 'yyyymm') sysmonth,
           TO_CHAR(ADD_MONTHS(SYSDATE, 1), 'yyyymm') sysnexmonth,
           TO_CHAR(NVL(MAX(YAE097), '999999')) yae097,
           TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(NVL(MAX(YAE097),TO_CHAR(SYSDATE,'yyyymm'))),'yyyymm'),1),'yyyymm') yae097nex
        INTO var_sysmonth, var_sysnexmonth, var_yae097, var_yae097nex
        FROM (SELECT YAE097
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
        prm_ErrorMsg := prm_ErrorMsg || '��ȡ��������ںų���';
        prm_AppCode  := gn_def_ERR;
        GOTO LABEL_OUT;
      END IF;
   ELSIF COUNT_AB02 = 0 THEN
    SELECT count(1)
        INTO COUNT_IRAB08
        FROM wsjb.irab08
       WHERE AAB001 = prm_aab001
         AND YAE517 = 'H01'
         AND AAE140 = '01';
      IF COUNT_IRAB08 > 0 THEN
        SELECT
               TO_CHAR(SYSDATE, 'yyyymm') sysmonth,
               TO_CHAR(ADD_MONTHS(SYSDATE, 1), 'yyyymm') sysnexmonth,
               TO_CHAR(NVL(MAX(YAE097), '999999')) yae097,
               TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(NVL(MAX(YAE097),TO_CHAR(SYSDATE,'yyyymm'))),'yyyymm'),1),'yyyymm') yae097nex
          INTO VAR_SYSMONTH, VAR_SYSNEXMONTH, VAR_YAE097, VAR_YAE097NEX
          FROM (SELECT AAE003 AS YAE097
                  FROM wsjb.irab08
                 WHERE AAB001 = prm_aab001
                   AND YAE517 = 'H01'
                   AND AAE140 = '01');
      ELSIF COUNT_IRAB08 = 0 THEN
        SELECT TO_CHAR(SYSDATE, 'yyyyMM') INTO var_yae097nex FROM dual;
        SELECT
               TO_CHAR(SYSDATE, 'yyyymm') sysmonth,
               TO_CHAR(ADD_MONTHS(SYSDATE, 1), 'yyyymm') sysnexmonth,
               TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'yyyymm') yae097
          INTO VAR_SYSMONTH, VAR_SYSNEXMONTH, VAR_YAE097
          FROM dual;
      END IF;
   END IF;

   --�±�����걨�¶�
   SELECT MAX(iaa100)
     INTO MAX_IAA100
     FROM irad01
    WHERE iaa011 = 'A04'
      AND aab001 = prm_aab001;

   IF VAR_YAE097 > MAX_IAA100 THEN
      FOR REC_IAA100S IN CUR_IAA100S LOOP

        TAR_IAA100 := REC_IAA100S.IAA100L;

        SELECT COUNT(1)
          INTO COUNT_IRAD01
          FROM irad01
         WHERE iaa011 = 'A04'
           AND iaa100 = REC_IAA100S.IAA100L
           AND aab001 = prm_aab001;

           IF COUNT_IRAD01 = 0 THEN
                -------- д���� start  --------
                IF COUNT_AB02 > 0 THEN  -- һ�㵥λ
                INSERT INTO wsjb.IRAC01
                       (iac001, -- �걨��Ա��Ϣ���
                        iaa001, -- �걨��Ա���
                        iaa002, -- �걨״̬
                        aac001, -- ���˱��
                        aab001, -- ��λ���
                        aac002, -- ���֤����(֤������)
                        aac003, -- ����
                        aac004, -- �Ա�
                        aac005, -- ����
                        aac006,
                        aac007,
                        aac008,
                        aac009,
                        aac011,
                        aac013,
                        aac014,
                        aac015,
                        aac020,
                        yac168,
                        yab139, -- �α�����������
                        yab013, -- ԭ��λ���
                        aae011, -- ������
                        aae036, -- ����ʱ��
                        aac040, -- �걨����
                        yac005, --��������
                        yac004, --���ϻ���
                        aae110, -- ��ҵ����
                        aae120, -- ��������
                        aae210, -- ʧҵ
                        aae310, -- ҽ��
                        aae410, -- ����
                        aae510, -- ����
                        aae311, -- ��
                        iaa100)
                SELECT TO_CHAR(seq_iac001.nextval ) iac001, -- �걨��Ա��Ϣ���
                       PKG_Constant.IAA001_GEN iaa001, -- �����α���Ա
                       PKG_Constant.IAA002_WIR iaa002, -- ���걨,
                       p.aac001,p.aab001,
                       p.aac002,p.aac003,p.aac004,p.aac005,p.aac006,p.aac007,p.aac008,p.aac009,p.aac011,
                       p.aac013,p.aac014,p.aac015,p.aac020,p.yac168,p.yab139,p.aab001 as yab013,p.aae011,p.aae036,
                       p.aac040,decode(p.aae310,'0',p.yac005_,'2',p.yac005) yac005,to_number(NVL(TRIM(p.yac004_1),p.yac004_2)) AS yac004,p.aae110,p.aae120,p.aae210,p.aae310,p.aae410,p.aae510,p.aae311,REC_IAA100S.IAA100L
                  FROM
               (SELECT a.aac001, -- ���˱��
                       b.aab001, -- ��λ���
                       a.aac002, -- ���֤����(֤������)
                       a.aac003, -- ����
                       a.aac004, -- �Ա�
                       a.aac005, -- ����
                       a.aac006,
                       a.aac007,
                       a.aac008,
                       a.aac009,
                       a.aac011,
                       a.aac013,
                       a.aac014,
                       a.aac015,
                       a.aac020,
                       a.yac168,
                       PKG_Constant.YAB003_JBFZX yab139,
                       a.aae011, -- ������
                       a.aae036, -- ����ʱ��
                       sum(case when b.aae140 = '03' then b.aac040 else 0 end) as aac040, -- �걨����
                       sum(case when b.aae140 = '03' then b.yac004 else 0 end) as yac005, -- �걨����
                       sum(case when b.aae140 = '04' then b.yac004 else 0 end) as yac005_, -- ���˵Ľɷѻ���
                       (select yac004 from wsjb.irac01a3  where aac001 = a.aac001 and aab001 = prm_aab001 and aae110 = '2') as yac004_1, --��ҵ���ϻ���
                       (select yac004 from xasi2.ac02 where aac001 = a.aac001 and aab001 = prm_aab001 and aae140 = '06' and aac031 = '1') as yac004_2,--�������ϻ���
                       (select aae110 from wsjb.irac01a3  where aac001 = a.aac001 and aab001 = prm_aab001) aae110,             -- ��ҵ����
                       sum(case  when b.aae140 = '06' then 2 else 0 end) as aae120,
                       sum(case  when b.aae140 = '02' then 2 else 0 end) as aae210,
                       sum(case  when b.aae140 = '03' then 2 else 0 end) as aae310,
                       sum(case  when b.aae140 = '04' then 2 else 0 end) as aae410,
                       sum(case  when b.aae140 = '05' then 2 else 0 end) as aae510,
                       sum(case  when b.aae140 = '07' then 2 else 0 end) as aae311
                  from xasi2.ac01 a, xasi2.ac02 b, wsjb.iraa01  c
                 where a.aac001 = b.aac001
                   and b.aab001 = c.aab001
                   and c.yae092 = prm_aae011
                   and b.aac031 = '1'
                   AND NOT EXISTS
                       (SELECT AAC001
                          FROM wsjb.IRAC01
                         WHERE aac002 = a.aac002
                           AND aab001 = prm_aab001
                           AND iaa001 <> PKG_Constant.IAA001_MDF
                           AND iaa100 = REC_IAA100S.IAA100L)
                 group by a.aac001,
                          b.aab001,
                          a.aac002,
                          a.aac003,
                          a.aac004,
                          a.aac005,
                          a.aac006,
                          a.aac007,
                          a.aac008,
                          a.aac009,
                          a.aac011,
                          a.aac013,
                          a.aac014,
                          a.aac015,
                          a.aac020,
                          a.yac168,
                          a.aae011,
                          a.aae036) p;
                ELSE  -- �����ϵ�λ
                INSERT INTO wsjb.IRAC01
                                   (iac001, -- �걨��Ա��Ϣ���
                                    iaa001, -- �걨��Ա���
                                    iaa002, -- �걨״̬
                                    aac001, -- ���˱��
                                    aab001, -- ��λ���
                                    aac002, -- ���֤����(֤������)
                                    aac003, -- ����
                                    aac004, -- �Ա�
                                    aac005, -- ����
                                    aac006,
                                    aac007,
                                    aac008,
                                    aac009,
                                    aac011,
                                    aac013,
                                    aac014,
                                    aac015,
                                    aac020,
                                    yac168,
                                    yab139, -- �α�����������
                                    yab013, -- ԭ��λ���
                                    aae011, -- ������
                                    aae036, -- ����ʱ��
                                    aac040, -- �걨����
                                    yac005, --��������
                                    yac004, --���ϻ���
                                    aae110, -- ��ҵ����
                                    aae120, -- ��������
                                    aae210, -- ʧҵ
                                    aae310, -- ҽ��
                                    aae410, -- ����
                                    aae510, -- ����
                                    aae311, -- ��
                                    iaa100)
                            SELECT TO_CHAR(seq_iac001.nextval) iac001, -- �걨��Ա��Ϣ���
                                   PKG_Constant.IAA001_GEN iaa001, -- �����α���Ա
                                   PKG_Constant.IAA002_WIR iaa002, -- ���걨,
                                   p.aac001,p.aab001,
                                   p.aac002,p.aac003,p.aac004,p.aac005,p.aac006,p.aac007,p.aac008,p.aac009,p.aac011,
                                   p.aac013,p.aac014,p.aac015,p.aac020,p.yac168,p.yab139,p.aab001 as yab013,p.aae011,p.aae036,
                                   p.aac040,decode(p.aae310,'0',p.yac005_,'2',p.yac005) yac005,to_number(NVL(TRIM(p.yac004_1),p.yac004_2)) AS yac004,p.aae110,p.aae120,p.aae210,p.aae310,p.aae410,p.aae510,p.aae311,REC_IAA100S.IAA100L
                              FROM
                           (SELECT a.aac001, -- ���˱��
                                   b.aab001, -- ��λ���
                                   a.aac002, -- ���֤����(֤������)
                                   a.aac003, -- ����
                                   a.aac004, -- �Ա�
                                   a.aac005, -- ����
                                   a.aac006,
                                   a.aac007,
                                   a.aac008,
                                   a.aac009,
                                   a.aac011,
                                   a.aac013,
                                   a.aac014,
                                   a.aac015,
                                   a.aac020,
                                   a.yac168,
                                   PKG_Constant.YAB003_JBFZX yab139,
                                   a.aae011, -- ������
                                   a.aae036, -- ����ʱ��
                                   b.aac040 AS aac040, -- �걨����
                                   0 as yac005, -- �걨����
                                   0 as yac005_, -- ���˵Ľɷѻ���
                                   b.yac004 as yac004_1, --��ҵ���ϻ���
                                   0 as yac004_2,--�������ϻ���
                                   b.aae110 AS aae110,             -- ��ҵ����
                                   0 AS aae120,
                                   0 as aae210,
                                   0 as aae310,
                                   0 as aae410,
                                   0 as aae510,
                                   0 as aae311
                              from xasi2.ac01 a, wsjb.irac01a3  b, wsjb.iraa01  c
                             where a.aac001 = b.aac001
                               and b.aab001 = c.aab001
                               and c.yae092 = prm_aae011
                               and b.aae110 = '2'
                               AND NOT EXISTS
                                   (SELECT AAC001
                                      FROM wsjb.IRAC01
                                     WHERE aac002 = a.aac002
                                       AND aab001 = prm_aab001
                                       AND iaa001 <> PKG_Constant.IAA001_MDF
                                       AND iaa100 = REC_IAA100S.IAA100L)
                             ) p;

                END IF;
                     -----дirad01  irad02
                  --�Ƿ������ͬ����˼���
                  SELECT COUNT(1)
                    INTO N_COUNT
                    FROM wsjb.IRAA02
                   WHERE iaa011 = PKG_Constant.IAA011_MIR
                     AND iaa005 = PKG_Constant.IAA005_YES;
                  IF N_COUNT > 1 THEN
                     ROLLBACK;
                     prm_ErrorMsg := '���걨ϵͳ��˼�����Ϣ����!����ϵά����Ա';
                     RETURN;
                  END IF;

                  VAR_AAZ002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
                  IF  VAR_AAZ002 IS NULL OR VAR_AAZ002 = ''  THEN
                     ROLLBACK;
                     prm_ErrorMsg := 'û�л�ȡ�����к�AAZ002';
                     RETURN;
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
                              AAE218,
                              AAE013
                             )
                             VALUES
                             (
                              VAR_AAZ002,
                              PKG_Constant.AAA121_MIR,
                              prm_aae011,
                              PKG_Constant.YAB003_JBFZX,
                              prm_aae011,
                              '1',
                              sysdate,
                              sysdate,
                              sysdate,
                              '��¼'
                             );

                   BEGIN
                     SELECT DISTINCT a.iaz004
                       into VAR_IAZ004
                       FROM wsjb.IRAD01  a,wsjb.IRAA01  b
                      WHERE a.aab001 = b.aab001
                        AND a.iaa100 = TAR_IAA100
                        AND a.iaa011 = PKG_Constant.AAA121_MIR
                        AND b.yae092 = prm_aae011;
                     EXCEPTION
                     WHEN OTHERS THEN
                        VAR_IAZ004 := NULL;
                  END;

                  BEGIN
                     SELECT iaa004
                       INTO VAR_IAA004
                       FROM wsjb.IRAA02
                      WHERE iaa011 = PKG_Constant.IAA011_MIR
                        AND iaa005 = PKG_Constant.IAA005_YES;
                     EXCEPTION
                  WHEN OTHERS THEN
                     ROLLBACK;
                     prm_AppCode  :=  gn_def_ERR;
                     prm_ErrorMsg := 'û�л�ȡ����˼�����Ϣ';
                     RETURN;
                  END;

                  IF VAR_IAZ004 IS NULL THEN
                     /*��ȡ���к�*/
                     VAR_IAZ004 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ004');
                     IF VAR_IAZ004 IS NULL OR VAR_IAZ004 = '' THEN
                        ROLLBACK;
                        prm_ErrorMsg := 'û�л�ȡ�����к�IAZ004';
                        RETURN;
                     END IF;

                    --�걨�¼�
                    INSERT INTO wsjb.IRAD01
                                (
                                 iaz004,
                                 aaz002,
                                 iaa011,
                                 aae011,
                                 aae035,
                                 aab001,
                                 yab003,
                                 aae013,
                                 iaa100
                                )
                                VALUES
                                (
                                 VAR_IAZ004,
                                 VAR_AAZ002,
                                 PKG_Constant.IAA011_MIR,
                                 prm_aae011,
                                 sysdate,
                                 prm_aab001,
                                 PKG_Constant.YAB003_JBFZX,
                                 '��¼',
                                 TAR_IAA100
                                );
                  END IF;

                  --д�뵥λ����Ա��Ϣ�걨��ϸ

                   VAR_IAC002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');
                     IF VAR_IAC002 IS NULL OR VAR_IAC002 = '' THEN
                        ROLLBACK;
                        prm_AppCode  :=  gn_def_ERR;
                        prm_ErrorMsg := 'û�л�ȡ�����к�IAC002';
                     END IF;



                  FOR REC_IRAC01 in CUR_IRAC01 LOOP
                     VAR_AAC003 := REC_IRAC01.aac003;
                     VAR_IAC001 := REC_IRAC01.iac001;
                     VAR_AAC001 := REC_IRAC01.aac001;
                     IF VAR_AAC001 IS NULL OR VAR_AAC001 = '' THEN
                        ROLLBACK;
                        prm_AppCode  :=  gn_def_ERR;
                        prm_ErrorMsg := 'û�л�ȡ����Ա���';
                     END IF;

                     VAR_IAZ005 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');
                     IF VAR_IAZ005 IS NULL OR VAR_IAZ005 = '' THEN
                        ROLLBACK;
                        prm_AppCode  :=  gn_def_ERR;
                        prm_ErrorMsg := 'û�л�ȡ�����к�IAZ005';
                     END IF;

                     --��ȡ�ϴ��걨��ϸ���
                     SELECT NVL(MAX(IAZ005),VAR_IAZ005)
                       INTO VAR_IAZ006
                       FROM wsjb.IRAD02
                      WHERE IAZ007 = VAR_IAC001;

                     --������Ա�걨��ϸ
                     INSERT INTO wsjb.IRAD02
                         (
                          iaz005,
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
                         )
                         VALUES
                         (
                          VAR_IAZ005,
                          VAR_IAZ006,
                          VAR_IAZ004,
                          VAR_IAC001,
                          VAR_AAC001,
                          VAR_AAC003,
                          prm_aae011,
                          sysdate,
                          PKG_Constant.YAB003_JBFZX,
                          VAR_IAA004,
                          0,
                          PKG_Constant.IAA015_WAD,
                          PKG_Constant.IAA016_DIR_NO,
                          '��¼',
                          PKG_Constant.IAA020_GR
                         );

                     --������Ա�걨״̬
                     UPDATE wsjb.IRAC01
                        SET iaa002 = PKG_Constant.IAA002_AIR
                      WHERE iac001 = VAR_IAC001;
                  END LOOP;
                -------- д���� end   --------

                -- ��� start --



         SELECT COUNT(1)
          INTO n_count
          FROM wsjb.IRAC01  a,wsjb.IRAD02  b,wsjb.IRAD01  c
         WHERE a.iac001 = b.iaz007
           and b.iaz004 = c.iaz004
           and c.aab001 = prm_aab001
           and a.iaa001 IN ('1','2','3','5','6','7','8')
           and c.iaa011 = PKG_Constant.IAA011_MIR  --A04
           and a.iaa002 = PKG_Constant.IAA002_AIR  --1
           and c.iaa100 = TAR_IAA100;

        IF n_count > 0 THEN  --n_count �걨����
           DELETE FROM wsjb.IRAD22_TMP ;
           INSERT INTO wsjb.IRAD22_TMP
                 (IAC001,   --�걨��Ա��Ϣ���,VARCHAR2
                                  AAC001,   --���˱��,VARCHAR2
                                  AAB001,   --��λ���,VARCHAR2
                                  AAC002,   --������ݺ���,VARCHAR2
                                  AAC003,   --����,VARCHAR2
                                  IAA001,   --��Ա���
                                  IAZ005,   --�걨��ϸID
                                  IAA003)    --ҵ������
                          SELECT a.IAC001, --�걨��Ա��Ϣ���,VARCHAR2
                                 a.AAC001, --���˱��,VARCHAR2
                                 a.AAB001, --��λ���,VARCHAR2
                                 a.AAC002, --������ݺ���,VARCHAR2
                                 a.AAC003, --����,VARCHAR2
                                 a.IAA001, --��Ա���
                                 b.IAZ005, --�걨��ϸID
                                 '2' IAA003  --ҵ������
                            FROM wsjb.IRAC01  a,wsjb.IRAD02  b,wsjb.IRAD01  c
                           WHERE a.iac001 = b.iaz007
                             and b.iaz004 = c.iaz004
                             and c.aab001 = prm_aab001
                             and a.iaa001 IN ('1','2','3','5','6','7','8')
                             and c.iaa011 = PKG_Constant.IAA011_MIR  --A04
                             and a.iaa002 = PKG_Constant.IAA002_AIR  --1 ���걨
                             and c.iaa100 = TAR_IAA100;

           IF COUNT_AB02 > 0 THEN  --��AB02�ĵ�λ
             --���걨���ͨ��
             PKG_Insurance.prc_AuditMonthInternetR(PKG_Constant.IAA011_MIR,  --A04
                                                   PKG_Constant.IAA003_PER,  --2 ����
                                                   PKG_Constant.IAA018_PAS,  --1 ͨ��
                                                   '1',--���ͨ��
                                                   prm_aae011,
                                                   '1' , --ȫ��
                                                   prm_AppCode,
                                                   prm_ErrorMsg);
             IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                prm_AppCode  :=  gn_def_ERR;
                prm_ErrorMsg := '�������걨��˹���prc_AuditMonthInternetR����:' ||prm_ErrorMsg||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                RETURN;
             END IF;
           ELSE  --û��AB02 ���ǵ����ϵ�λ
            --���걨���ͨ�� (������)
             PKG_Insurance.prc_YLAuditMonth(PKG_Constant.IAA011_MIR,  --A04
                                            PKG_Constant.IAA003_PER,  --2 ����
                                            PKG_Constant.IAA018_PAS,  --1 ͨ��
                                             '1',--���ͨ��
                                             prm_aae011,
                                             '1' , --ȫ��
                                             prm_AppCode,
                                             prm_ErrorMsg
                                             );
             IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                prm_AppCode  :=  gn_def_ERR;
                prm_ErrorMsg := '�������걨��˹���prc_YLAuditMonth����:' ||prm_ErrorMsg||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                RETURN;
             END IF;
           END IF;
        END IF;

          /*  PKG_Insurance.prc_insertAC29(
                              prm_aab001, --��λ������
                               TAR_IAA100  ,
                               prm_aae011, --������
                               prm_AppCode, --�������
                               prm_ErrorMsg); --��������
                IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                prm_AppCode  :=  gn_def_ERR;
                prm_ErrorMsg := '�����ƿ�����prc_insertAC29����:' ||prm_ErrorMsg||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                RETURN;
             END IF;*/

                  -- ��� start --
           END IF;
      END LOOP;
   END IF;


    <<LABEL_OUT>>
    NULL;
    EXCEPTION
    -- WHEN NO_DATA_FOUND THEN
    -- WHEN TOO_MANY_ROWS THEN
    -- WHEN DUP_VAL_ON_INDEX THEN
    WHEN OTHERS THEN
       /*�رմ򿪵��α�*/
       ROLLBACK;
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '���ݿ����:'|| PRE_ERRCODE || SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
       RETURN;
 END prc_insertIRAD01;


 /* ��ְ��Ա���� */
 PROCEDURE prc_SupplementCharge(
             prm_aae123  IN xasi2.tmp_sc01.aae123%TYPE,
             prm_aac040  IN xasi2.tmp_sc01.aac040%TYPE, --�걨����
             prm_yac004  IN xasi2.tmp_sc01.yac004%TYPE, --�걨����
             prm_aab001  IN xasi2.ab01.aab001%TYPE, --��λ������
             prm_aac001  IN xasi2.ac01.aac001%TYPE, --��λ������
             prm_aae011  IN irac01.aae011%TYPE, --������
             prm_AppCode OUT VARCHAR2, --�������
             prm_ErrorMsg  OUT VARCHAR2)

 IS
  --N_COUNT           NUMBER(6);
  VAR_MIN_AAB050    NUMBER(6); --�α�ʱ��(��Ϊ����ʱ��)
  VAR_MAX_AAE002    xasi2.ac08a1.aae002%TYPE; --����4�պ˷ѵ����ѿ�������
  VAR_SPGZ          xasi2.ac02.aac040%TYPE; --��ƽ����
  VAR_YAC004_EARLY  xasi2.ac02.yac004%TYPE; --�������
  VAR_AAE140        xasi2.ac02.aae140%TYPE; --����
  VAR_AAE001_NOW    xasi2.ab05.aae001%TYPE; --ϵͳʱ�䵱ǰ���
  
  CURSOR CUR_AAE140 is
    SELECT aae140
      FROM (SELECT DISTINCT aae140
              FROM xasi2.ac08
             WHERE aac001 = prm_aac001
               AND aab001 = prm_aab001
               AND aae143 = '01'
            UNION
            SELECT DISTINCT aae140
              FROM xasi2.ac08a1
             WHERE aac001 = prm_aac001
               AND aab001 = prm_aab001
               AND aae143 = '01');
               
  CURSOR CUR_AAE002 is          
    SELECT yae099, aae002
      FROM xasi2.tmp_sc01
     WHERE yae031 = '0'
       and aae100 = '1'
       and aae140 = VAR_AAE140
       and aac001 = prm_aac001
       and aab001 = prm_aab001;


 BEGIN

  prm_AppCode  := gn_def_OK;
  prm_ErrorMsg := '';

  --ϵͳʱ�䵱ǰ���
  SELECT EXTRACT(YEAR FROM SYSDATE) INTO VAR_AAE001_NOW FROM DUAL;

  --��λ���ֲα����� (�����������Ϊ׼)
  SELECT MIN(to_number(to_char(aab050, 'yyyymm')))
    INTO VAR_MIN_AAB050
    FROM xasi2.ab02
   WHERE aab001 = prm_aab001;

  FOR REC1 IN CUR_AAE140 LOOP
    
    VAR_AAE140 := REC1.aae140;
    
    --����4�պ˷ѵ����ѿ�������
    SELECT MAX(AAE002)
      INTO VAR_MAX_AAE002
      FROM (SELECT aae002
              FROM xasi2.ac08
             WHERE aac001 = prm_aac001
               AND aab001 = prm_aab001
               AND aae140 = VAR_AAE140
               AND aae143 = '01'
            UNION
            SELECT aae002
              FROM xasi2.ac08a1
             WHERE aac001 = prm_aac001
               AND aab001 = prm_aab001
               AND aae140 = VAR_AAE140
               AND aae143 = '01');

   /*
   INSERT INTO xasi2.tmp_sc01
     (yae099, aae123, aab001, aac001, aae140, aae041, aae042)
     (SELECT to_char(XASI2.SEQ_YAE099.NEXTVAL),
             prm_aae123,
             prm_aab001,
             prm_aac001,
             rec.aae140,
             aae041,
             aae042
        FROM (
              SELECT MIN(aae002_ex) aae041, MAX(aae002_ex) aae042 --, LX - RN
                FROM (SELECT aae002_ex,
                              (aae002_ex - 200000) LX,
                              row_number() OVER(ORDER BY t.aae002_ex) RN
                         FROM (SELECT TO_CHAR(ADD_MONTHS(TO_DATE(VAR_MIN_AAB050,
                                                                 'YYYYMM'),
                                                         ROWNUM - 1),
                                              'YYYYMM') aae002_ex
                                 FROM DUAL
                               CONNECT BY ROWNUM <=
                                          MONTHS_BETWEEN(TO_DATE(VAR_MAX_AAE002,
                                                                 'yyyymm'),
                                                         TO_DATE(VAR_MIN_AAB050,
                                                                 'yyyymm')) + 1) t
                        WHERE aae002_ex NOT IN
                              (SELECT aae002
                                 FROM xasi2.ac08
                                WHERE aac001 = prm_aac001
                                  AND aab001 = prm_aab001
                                  AND aae140 = REC.aae140
                                  AND aae143 = '01'
                               UNION
                               SELECT aae002
                                 FROM xasi2.ac08a1
                                WHERE aac001 = prm_aac001
                                  AND aab001 = prm_aab001
                                  AND aae140 = REC.aae140
                                  AND aae143 = '01')) n
               GROUP BY n.LX - RN
              ));*/
 
    -- ����ɲ��յ��¶�
    INSERT INTO xasi2.tmp_sc01
      (aae123, aab001, aac001, aae140,aac040,yac004,yae031,aae011,aae100, yae099, aae002)
      (SELECT prm_aae123,
              prm_aab001,
              prm_aac001,
              VAR_AAE140,
              prm_aac040,
              prm_yac004,
              '0',
              prm_aae011,
              '1',
              to_char(XASI2.SEQ_YAE099.NEXTVAL),
              aae002_ex
         FROM (SELECT TO_CHAR(ADD_MONTHS(TO_DATE(VAR_MIN_AAB050, 'YYYYMM'),
                                         ROWNUM - 1),
                              'YYYYMM') aae002_ex
                 FROM DUAL
               CONNECT BY ROWNUM <=
                          MONTHS_BETWEEN(TO_DATE(VAR_MAX_AAE002, 'yyyymm'),
                                         TO_DATE(VAR_MIN_AAB050, 'yyyymm')) + 1) t
        WHERE aae002_ex NOT IN (SELECT aae002
                                  FROM xasi2.ac08
                                 WHERE aac001 = prm_aac001
                                   AND aab001 = prm_aab001
                                   AND aae140 = VAR_AAE140
                                   AND aae143 = '01'
                                UNION
                                SELECT aae002
                                  FROM xasi2.ac08a1
                                 WHERE aac001 = prm_aac001
                                   AND aab001 = prm_aab001
                                   AND aae140 = VAR_AAE140
                                   AND aae143 = '01'
                                UNION
                                SELECT aae002
                                  FROM xasi2.tmp_sc01
                                 WHERE aac001 = prm_aac001
                                   AND aab001 = prm_aab001
                                   AND aae140 = VAR_AAE140));
                                   
    -- �����������Ϊ������ƽ
    FOR REC2 IN CUR_AAE002 LOOP
        IF SUBSTR(REC2.AAE002,1,4) < VAR_AAE001_NOW THEN
           VAR_SPGZ := xasi2.pkg_comm.fun_GetAvgSalary(VAR_AAE140,'16',SUBSTR(REC2.AAE002,1,4)||01,PKG_Constant.YAB003_JBFZX);
           VAR_YAC004_EARLY := ROUND(VAR_SPGZ/12);
           update xasi2.tmp_sc01
              set yac004 = VAR_YAC004_EARLY
            where yae099 = REC2.YAE099;
        END IF;  
    END LOOP;                                                                
  END LOOP;
  
  


 EXCEPTION
  -- WHEN NO_DATA_FOUND THEN
  -- WHEN TOO_MANY_ROWS THEN
  -- WHEN DUP_VAL_ON_INDEX THEN
 WHEN OTHERS THEN
  /*�رմ򿪵��α�*/
   ROLLBACK;
   prm_AppCode  :=  gn_def_ERR;
   prm_ErrorMsg := '���ݿ����:'|| PRE_ERRCODE || SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
   RETURN;

 END prc_SupplementCharge;

end PKG_Insurance;
/
