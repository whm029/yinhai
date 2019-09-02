CREATE OR REPLACE PACKAGE PKG_P_VALIDATE
/*****************************************************************************/
/*  ������� ��pkg_k_ValidateAab001Privilege                                 */
/*  ҵ�񻷽� ����λȨ����֤                                                  */
/*  �������� ��                                                              */
/*                                                                           */
/*  ��    �� ���Ĵ���Զ��������ɷ����޹�˾                                  */
/*  �������� ��2015-08-28           �汾��� ��Ver 1.0.0                     */
/*---------------------------------------------------------------------------*/
/*  �޸ļ�¼ ��                                                              */
/*****************************************************************************/

AS
  -- ִ�д���
  GN_DEF_OK  CONSTANT VARCHAR2(12) := 'NOERROR'; -- �ɹ�
  GN_DEF_ERR CONSTANT VARCHAR2(12) := '9999'; -- ϵͳ����
  -- �Ƿ�
  GN_DEF_YES CONSTANT VARCHAR2(12) := '��'; -- ��
  GN_DEF_NO  CONSTANT VARCHAR2(12) := '��'; -- ��
  -- ��������
  GS_DEF_DATETIMEFORMAT  CONSTANT VARCHAR2(21) := 'YYYY-MM-DD HH24:MI:SS';
  GS_DEF_DATEFORMAT      CONSTANT VARCHAR2(10) := 'YYYY-MM-DD';
  GS_DEF_YEARMONTHFORMAT CONSTANT VARCHAR2(6) := 'YYYYMM';
  GS_DEF_YEARFORMAT      CONSTANT VARCHAR2(4) := 'YYYY';
  GS_DEF_TIMEFORMAT      CONSTANT VARCHAR2(10) := 'HH24:MI:SS';
  GS_DEF_NUMBERFORMAT    CONSTANT VARCHAR2(15) := '999999999999.99';
  GS_DEF_NOFORMAT        CONSTANT VARCHAR2(15) := '999999999999999';

  /*-------------------------------------------------------------------------*/
  /* ����ȫ�ֱ�������                                                        */
  /*-------------------------------------------------------------------------*/
  --���˲�������
  CZLX_INSERT VARCHAR2(2) := '0'; -- INSERT����
  CZLX_UPDATE VARCHAR2(2) := '1'; -- UPDATE����
  CZLX_DELETE VARCHAR2(2) := '2'; -- DELETE����
  CZLX_OTHER  VARCHAR2(2) := '4'; -- ��ʹ�ô�����

  /*--------------------------------------------------------------------------
   || ҵ�񻷽� ����λȨ����֤
   || �������� ��prc_k_ValidateAab001Privilege
   || �������� ������δͨ����λ����λ��Ϣ�쳣��δ��׼�±�����λȨ�޿��ƣ�
   ||            ��λ�����ںŲ�һ��ʱ��λδͨ����֤
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��cora          ������� ��2015-11-11
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateAab001Privilege(
      prm_aab001          IN            VARCHAR2,     --��λ���
      prm_msg             OUT           VARCHAR2,     -- ������Ϣ
      prm_sign            OUT           VARCHAR2,     -- �����־
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2);    --������Ϣ
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
      prm_ErrorMsg        OUT           VARCHAR2);    --������Ϣ
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
      prm_ErrorMsg        OUT           VARCHAR2);    --������Ϣ
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
      prm_aac001          IN            VARCHAR2,     --���˱��
      prm_msg             OUT           VARCHAR2,     -- ������Ϣ
      prm_sign            OUT           VARCHAR2,     -- �����־
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2);    --������Ϣ
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
      prm_ErrorMsg        OUT           VARCHAR2);    --������Ϣ
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
      prm_ErrorMsg        OUT           VARCHAR2);    --������Ϣ
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
      prm_ErrorMsg        OUT           VARCHAR2);    --������Ϣ
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
      prm_ErrorMsg        OUT           VARCHAR2);    --������Ϣ
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
      prm_ErrorMsg        OUT           VARCHAR2);    --������Ϣ
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
      prm_ErrorMsg        OUT           VARCHAR2);    --������Ϣ
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
      prm_ErrorMsg        OUT           VARCHAR2);    --������Ϣ
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
                                  prm_iaa100     IN     irac01.iaa100%TYPE,--�걨�¶�
                                  prm_iaz018     IN     irac01a2.iaz018%TYPE,  --������������ID
                                  prm_yab139     IN     irac01.yab139%TYPE,--��������
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
                             prm_iaa100     IN     VARCHAR2,--�걨�¶�
                             prm_iaz018     IN     irac01a2.iaz018%TYPE,  --������������ID
                             prm_yab139     IN     irac01.yab139%TYPE,--��������
                             prm_AppCode    OUT    VARCHAR2  ,
                             prm_ErrorMsg   OUT    VARCHAR2 );
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
      prm_ErrorMsg        OUT           VARCHAR2);    --������Ϣ
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
      prm_ErrorMsg        OUT           VARCHAR2);    --������Ϣ
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
   PROCEDURE prc_p_ValidateAddKindYesOrNo(
       prm_aab001          IN            VARCHAR2,     --��λ���
       prm_aac001          IN            VARCHAR2,     --���˱��
       prm_aae140          IN            VARCHAR2,     --����
      prm_yab139          IN            VARCHAR2,     --�������
      prm_flag            OUT           VARCHAR2,     --����״̬��־
      prm_msg             OUT           VARCHAR2,     --��ʾ��Ϣ
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2);    --������Ϣ

   --У��������Ա��������
PROCEDURE prc_p_ValidKindsBatchAddCheck(PRM_IAZ018 IN VARCHAR2,
                                       PRM_AAB001   IN VARCHAR2,
                                       PRM_IAA100   IN VARCHAR2,
                                       PRM_APPCODE  OUT VARCHAR2,
                                       PRM_ERRORMSG OUT VARCHAR2);
   --У��������Ա����
   PROCEDURE prc_p_ValidBatchContinueCheck(PRM_IAZ018 IN VARCHAR2,
                          PRM_AAB001 IN VARCHAR2,
                         PRM_IAA100 IN VARCHAR2,
                         PRM_APPCODE  OUT VARCHAR2,
                         PRM_ERRORMSG OUT VARCHAR2);
   /*--------------------------------------------------------------------------
   || ҵ�񻷽� ��У��α���Ա�Ƿ��������ĳһ������
   || �������� prc_p_ValidateAddKindYesOrNo
   || �������� ��У������
   ||
   || �������� ��������ʶ           ˵��
   ||            --------------------------------------------------------------
   ||
   ||
   || ��    �� ��ycliu         ������� ��2017-02-15
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateContinueYesOrNo(
       prm_aab001          IN            VARCHAR2,     --��λ���
       prm_aac001          IN            VARCHAR2,     --���˱��
       prm_aae140          IN            VARCHAR2,     --����
      prm_yab139          IN            VARCHAR2,     --�������
      prm_flag            OUT           VARCHAR2,     --����״̬��־
      prm_msg             OUT           VARCHAR2,     --��ʾ��Ϣ
      prm_AppCode         OUT           VARCHAR2,     --ִ�д���
      prm_ErrorMsg        OUT           VARCHAR2);    --������Ϣ

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
      prm_ErrorMsg        OUT           VARCHAR2);    --������Ϣ

  /*    --�������˹��� �˻�ת��
  procedure prc_p_accountInto(prm_str    IN CLOB,
                              prm_aaz174 IN VARCHAR2,
                              prm_AppCode OUT   VARCHAR2  ,             --�������
                               prm_ErrorMsg  OUT   VARCHAR2
                              );
        --�˻�ת������
  procedure prc_p_accountOut(prm_rows IN VARCHAR2,
                             prm_log OUT sys_refcursor,
                             prm_AppCode OUT   VARCHAR2,             --�������
                              prm_ErrorMsg  OUT   VARCHAR2
                            );
                              --��д���˱�־
procedure prc_p_accountUpdate(prm_rows IN VARCHAR2,
                           prm_AppCode OUT   VARCHAR2,             --�������
                           prm_ErrorMsg  OUT   VARCHAR2
                          );*/
--������ϢУ��
PROCEDURE prc_p_checkInfoByaac001(prm_aac001 IN VARCHAR2,
                           prm_aab001 IN VARCHAR2,
                           prm_flag    OUT   VARCHAR2, --1У��ʧ�ܣ��޷����� 2У��ɹ������� 3У��ɹ����о� 4У��ɹ����ϲ�����
                           prm_msg     OUT   VARCHAR2,
                           prm_AppCode OUT   VARCHAR2,             --�������
                           prm_ErrorMsg  OUT   VARCHAR2
                          );
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
                            RETURN VARCHAR2;


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
                                prm_dxby60  OUT   VARCHAR2, --���幤�� ����ʧҵ����
                                prm_gxby60  OUT   VARCHAR2, --���幤�� ����ʧҵ����
                                prm_AppCode OUT   VARCHAR2,             --�������
                                prm_ErrorMsg  OUT   VARCHAR2
                              );


END pkg_p_Validate;