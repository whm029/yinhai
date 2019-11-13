CREATE OR REPLACE PACKAGE PKG_Insurance AS
   /*---------------------------------------------------------------------------
   ||  ������� ��PKG_Insurance
   ||  ҵ�񻷽� ��Insurance
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



   /*-------------------------------------------------------------------------*/
   /*����һ����¼����*/
   /*-------------------------------------------------------------------------*/
   TYPE rec_change IS RECORD(
        col_name  VARCHAR2(60),
        col_value VARCHAR2(3000));
   TYPE tab_change IS TABLE OF rec_change INDEX BY BINARY_INTEGER;

   /*****************************************************************************
   ** �������� oldEmpManaInfoMove
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
      prm_aae011       IN      irab01.aae011%TYPE,--������
      prm_aae013       IN      irab01.aae013%TYPE,--��ע
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );

   /*-------------------------------------------------------------------------*/
   /* ���ù��̺�������                                                        */
   /*-------------------------------------------------------------------------*/
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
      prm_flag         IN     VARCHAR2          ,--�Ƿ���ҵ�������ֵ��ϵ�λ
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );

   /*-------------------------------------------------------------------------*/
   /* ��ᱣ�յǼ�                                                       */
   /*-------------------------------------------------------------------------*/
   PROCEDURE prc_AddApplyInfo (
      prm_iaz008       IN     irad02.iaz008%TYPE,--�걨������
      prm_iad003       IN     irad02.iad003%TYPE,--�걨��������
      prm_aae013       IN     irad02.aae013%TYPE,--��ע
      prm_aac001       IN     irad02.aac001%TYPE,--�걨��
      prm_flag      IN     VARCHAR2          ,
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );

   /*-------------------------------------------------------------------------*/
   /* ��λ��Ϣά��                                                        */
   /*-------------------------------------------------------------------------*/
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
      prm_ErrorMsg    OUT    VARCHAR2);

    /*****************************************************************************
   ** �������� : prc_UnitBaseInfoMaintain
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����λ������Ϣά��
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
      prm_aab001       IN     irab01.aab001%TYPE, --��λ���
      prm_aab004       IN     irab01.aab004%TYPE, --��λ���
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
      prm_ErrorMsg     OUT    VARCHAR2          );


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
   **           prm_iaa018       IN     irad22.iaa018%TYPE,--��˱�־
   **           prm_iaa028       IN     VARCHAR2          ,--�Ƿ�ȫ��
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--���������ھ������
   **           prm_aae013       IN     iraa02.aae013%TYPE,--��ע
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-12   �汾��� ��Ver 1.0.0
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
      prm_ErrorMsg     OUT    VARCHAR2          );

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
   **            prm_Flag      OUT    VARCHAR2    ,
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
      prm_Flag      OUT    VARCHAR2   ,
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );


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
   **           prm_iaa018       IN     irad22.iaa018%TYPE,--��˱�־
   **           prm_iaa028       IN     VARCHAR2          ,--�Ƿ�ȫ��
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_aae013       IN     iraa02.aae013%TYPE,--��ע
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-12   �汾��� ��Ver 1.0.0
   ** ��    �ģ�
   *****************************************************************************/
   PROCEDURE prc_AuditMonthInternetRNew (
      prm_iaa011       IN     iraa02.iaa011%TYPE,--ҵ������
      prm_iaa003       IN     iraa02.iaa003%TYPE,--ҵ������
      prm_iaa018       IN     irad22.iaa018%TYPE,--��˱�־
      prm_iaa028       IN     VARCHAR2          ,--�Ƿ�ȫ��
      prm_aae011       IN     iraa02.iaa011%TYPE,--������
      prm_aae013       IN     iraa02.aae013%TYPE,--��ע
      prm_aaz002       OUT    VARCHAR2          ,
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );



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
   **           prm_iaa018       IN     irad22.iaa018%TYPE,--��˱�־
   **           prm_iaa028       IN     VARCHAR2          ,--�Ƿ�ȫ��
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--������
   **           prm_aae013       IN     iraa02.aae013%TYPE,--��ע
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** ��    �ߣ�yh         �������� ��2012-08-12   �汾��� ��Ver 1.0.0
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
      prm_ErrorMsg     OUT    VARCHAR2          );

   /*****************************************************************************
   ** �������� : prc_AddNewManage
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ������ר��Ա
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     iraa01.aab001%TYPE,--ר��Ա���ڵ�λ����
   **           prm_aac001       IN     iraa01.aac001%TYPE,--ר��Ա֤������
   **           prm_yab516       IN     iraa01.yab516%TYPE,--ר��Ա֤����
   **           prm_aab016       IN     iraa01.aab016%TYPE,--ר��Ա����
   **           prm_aac004       IN     ad53a4.aac004%TYPE,--ר��Ա����
   **           prm_yae041       IN     ad53a4.yae041%TYPE,--ר��Ա��¼�˺�
   **           prm_yae042       IN     iraa01.yae042%TYPE,--ר��Ա����
   **           prm_yae043       IN     iraa01.yae043%TYPE,--��ʼ����
   **           prm_yab003       IN     ae02.yab003%TYPE,--������
   **           prm_aae011       IN     iraa01.aae011%TYPE,--������
   **           prm_aae013       IN     ae02.aae013%TYPE,  --��ע
   **           prm_shmark       IN     VARCHAR2,          --���ͨ����־
   **           prm_AppCode      OUT    VARCHAR2,
   **           prm_ErrorMsg     OUT    VARCHAR2,
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
     prm_ErrorMsg     OUT    VARCHAR2          );


   /*****************************************************************************
   ** �������� : prc_UnitInfoMaintainAudit
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����λ��Ϣά�����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aab001       IN     iraa01.aab001%TYPE,--ר��Ա���ڵ�λ����
   **           prc_aae015       IN     iraa01.aac001%TYPE,--������
   **           prc_iaa002       IN     iraa01.yab516%TYPE,--��˽��
   **           prm_aae011       IN     iraa01.aae011%TYPE,--������
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
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
     prm_ErrorMsg     OUT    VARCHAR2          );


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
      prm_aac013       IN     irac01.aac013%TYPE,--�ù�����
      prm_yac168       IN     irac01.yac168%TYPE,--ũ�񹤱�־
      prm_aac007        IN    irac01.aac007%TYPE,--�ι�����
      prm_aac012        IN    irac01.aac012%TYPE,--�������
      prm_aae011       IN     irac01.aae011%TYPE,--������
      prm_aac040       IN     irac01.aac040%TYPE,--�걨����
      prm_iac001       OUT    irac01.iac001%TYPE,--�걨���
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );


   /*****************************************************************************
   ** �������� : prc_PersonInfoMaintainDanYL
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����Ա��Ҫ��Ϣά��(��Ե�����)
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aac001       IN     irac01.aac001%TYPE,--���˱��
   **           prm_aab001       IN     irac01.aab001%TYPE,--��λ���
   **           prm_aac002       IN     irac01.aac002%TYPE,--֤������
   **           prm_aac003       IN     irac01.aac003%TYPE,--����
   **           prm_aac004       IN     irac01.aac004%TYPE,--�Ա�
   **           prm_aac006       IN     irac01.aac006%TYPE,--��������
   **           prm_aac009       IN     irac01.aac009%TYPE,--��������
   **           prm_aae011       IN     irac01.aae011%TYPE,--������
   **           prm_aac040       IN     irac01.aac040%TYPE,--�걨����
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
      prm_aac013       IN     irac01.aac013%TYPE,--�ù�����
      prm_yac168       IN     irac01.yac168%TYPE,--ũ�񹤱�־
      prm_aac007        IN    irac01.aac007%TYPE,--�ι�����
      prm_aac012        IN    irac01.aac012%TYPE,--�������
      prm_aae011       IN     irac01.aae011%TYPE,--������
      prm_aac040       IN     irac01.aac040%TYPE,--�걨����
      prm_iac001       OUT    irac01.iac001%TYPE,--�걨���
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );


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
     prm_ErrorMsg     OUT    VARCHAR2          );

   /*****************************************************************************
   ** �������� : prc_RollBackASIR
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ��������ᱣ�յǼ����
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aaz002       IN     ae02.aaz002%TYPE,  --ҵ����־���
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
      prm_ErrorMsg     OUT    VARCHAR2          );

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
      prm_ErrorMsg     OUT    VARCHAR2          );

   /*****************************************************************************
   ** �������� : prc_RollBackAMIR
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ���������걨���
   ******************************************************************************
   ** �������� ��������ʶ        ����/���         ����                 ����
   ******************************************************************************
   **           prm_aaz002       IN     ae02.aaz002%TYPE,  --ҵ����־���
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
      prm_ErrorMsg     OUT    VARCHAR2          );

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
      prm_ErrorMsg     OUT    VARCHAR2          );


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
      prm_ErrorMsg     OUT    VARCHAR2          );


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
      prm_ErrorMsg     OUT    VARCHAR2          );

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
                            RETURN VARCHAR2;
   PROCEDURE prc_GETAAB001C(prm_aab020     IN     irab01.aab020%TYPE,--��������
                            prm_yab006     IN     irab01.yab006%TYPE,--˰�����
                            prm_aab001     OUT    VARCHAR2,          --��λ���
                            prm_AppCode    OUT    VARCHAR2  ,
                            prm_ErrorMsg   OUT    VARCHAR2 );
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
                                  prm_aae002     IN     xasi2.ab08.aae003%TYPE,  --�ѿ�������
                                  prm_yae010     IN     xasi2.aa05.yae010%TYPE,  --������Դ:��˰����
                                  prm_aae011     IN     xasi2.ab08.aae011%TYPE,  --������Ա
                                  prm_flag       IN     VARCHAR2,          --�ύ��־ 0 �ύ 1���ύ
                                  prm_AppCode    OUT    VARCHAR2  ,
                                  prm_ErrorMsg   OUT    VARCHAR2 );

   /*****************************************************************************
   ** �������� : prc_batchImport
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����������
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
                             prm_ErrorMsg   OUT    VARCHAR2 );


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
                             prm_ErrorMsg   OUT    VARCHAR2 );

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
                                    prm_ErrorMsg   OUT    VARCHAR2 );


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
                                          prm_ErrorMsg   OUT    VARCHAR2 );



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
                               prm_ErrorMsg   OUT    VARCHAR2 );


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
                prm_ErrorMsg   OUT    VARCHAR2 );



   /*****************************************************************************
   ** �������� : prc_batchImportView
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����������
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
                                 prm_ErrorMsg   OUT    VARCHAR2 );




   /*****************************************************************************
   ** �������� : prc_pensionImp
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����������������Ϣ
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
                            prm_AppCode    OUT    VARCHAR2  ,
                            prm_ErrorMsg   OUT    VARCHAR2 );


   /*****************************************************************************
   ** �������� : prc_pensionMaintainImp
   ** ���̱�� ��
   ** ҵ�񻷽� ��
   ** �������� ����������������Ϣ
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
                                    prm_ErrorMsg   OUT    VARCHAR2 );

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
      prm_ErrorMsg     OUT    VARCHAR2          );
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
      prm_ErrorMsg     OUT    VARCHAR2          );
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
      prm_ErrorMsg     OUT    VARCHAR2          );

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
      prm_ErrorMsg     OUT    VARCHAR2          );
--�����ϵ�λ����
PROCEDURE prc_RollBackAMIRBYYL (
      prm_aaz002       IN     ae02.aaz002%TYPE,  --ҵ����־���
      prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
      prm_aab001       IN     irad01.aab001%TYPE,--�걨��λ
      prm_aae011       IN     irad31.aae011%TYPE,--������
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );
--�����ϵ�λ����
PROCEDURE prc_ResetASMRBYYL (
      prm_aab001       IN     irab01.aab001%TYPE,--��λ���
      prm_iaa100       IN     irad01.iaa100%TYPE,--�걨�¶�
      prm_aae011       IN     irad31.aae011%TYPE,--������
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );

 PROCEDURE prc_Ab02a8Unit (
      prm_aab001       IN     irab01.aab001%TYPE,--��λ���
      prm_yae099       IN     VARCHAR2,          --ҵ����ˮ��
      prm_AppCode      OUT    VARCHAR2,
      prm_ErrorMsg     OUT    VARCHAR2  );

-- ��λ�ɷѻ�������
PROCEDURE prc_Ab02a8UnitRollBack (
      prm_aab001       IN     varchar2,--��λ���
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );

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
                             prm_ErrMsg       OUT   VARCHAR2  );   --��������


 PROCEDURE prc_insertAC29(
                               prm_aab001  IN irab01.aab001%TYPE, --��λ������
                               prm_iaa100  IN irac01.iaa100%TYPE,
                               prm_aae011  IN irac01.aae011%TYPE, --������
                               prm_AppCode OUT VARCHAR2, --�������
                               prm_ErrorMsg  OUT VARCHAR2); --��������

 PROCEDURE prc_insertIRAD01(
             prm_aab001  IN irab01.aab001%TYPE, --��λ������
             prm_aae011  IN irac01.aae011%TYPE, --������
             prm_AppCode OUT VARCHAR2, --�������
             prm_ErrorMsg  OUT VARCHAR2);
             
 /* ��ְ��Ա���� */
 PROCEDURE prc_SupplementCharge(
             prm_aae123  IN xasi2.tmp_sc01.aae123%TYPE,
             prm_aac040  IN xasi2.tmp_sc01.aac040%TYPE, --�걨����
             prm_yac004  IN xasi2.tmp_sc01.yac004%TYPE, --�걨����
             prm_aab001  IN xasi2.ab01.aab001%TYPE, --��λ������
             prm_aac001  IN xasi2.ac01.aac001%TYPE, --��λ������
             prm_aae011  IN irac01.aae011%TYPE, --������
             prm_AppCode OUT VARCHAR2, --�������
             prm_ErrorMsg  OUT VARCHAR2);
             
END PKG_Insurance;
/
