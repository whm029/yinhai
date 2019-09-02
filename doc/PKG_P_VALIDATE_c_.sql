CREATE OR REPLACE PACKAGE PKG_P_VALIDATE
/*****************************************************************************/
/*  程序包名 ：pkg_k_ValidateAab001Privilege                                 */
/*  业务环节 ：单位权限验证                                                  */
/*  功能描述 ：                                                              */
/*                                                                           */
/*  作    者 ：四川久远银海软件股份有限公司                                  */
/*  作成日期 ：2015-08-28           版本编号 ：Ver 1.0.0                     */
/*---------------------------------------------------------------------------*/
/*  修改记录 ：                                                              */
/*****************************************************************************/

AS
  -- 执行代码
  GN_DEF_OK  CONSTANT VARCHAR2(12) := 'NOERROR'; -- 成功
  GN_DEF_ERR CONSTANT VARCHAR2(12) := '9999'; -- 系统错误
  -- 是否
  GN_DEF_YES CONSTANT VARCHAR2(12) := '是'; -- 是
  GN_DEF_NO  CONSTANT VARCHAR2(12) := '否'; -- 否
  -- 数据类型
  GS_DEF_DATETIMEFORMAT  CONSTANT VARCHAR2(21) := 'YYYY-MM-DD HH24:MI:SS';
  GS_DEF_DATEFORMAT      CONSTANT VARCHAR2(10) := 'YYYY-MM-DD';
  GS_DEF_YEARMONTHFORMAT CONSTANT VARCHAR2(6) := 'YYYYMM';
  GS_DEF_YEARFORMAT      CONSTANT VARCHAR2(4) := 'YYYY';
  GS_DEF_TIMEFORMAT      CONSTANT VARCHAR2(10) := 'HH24:MI:SS';
  GS_DEF_NUMBERFORMAT    CONSTANT VARCHAR2(15) := '999999999999.99';
  GS_DEF_NOFORMAT        CONSTANT VARCHAR2(15) := '999999999999999';

  /*-------------------------------------------------------------------------*/
  /* 公用全局变量声明                                                        */
  /*-------------------------------------------------------------------------*/
  --回退操作类型
  CZLX_INSERT VARCHAR2(2) := '0'; -- INSERT操作
  CZLX_UPDATE VARCHAR2(2) := '1'; -- UPDATE操作
  CZLX_DELETE VARCHAR2(2) := '2'; -- DELETE操作
  CZLX_OTHER  VARCHAR2(2) := '4'; -- 不使用触发器

  /*--------------------------------------------------------------------------
   || 业务环节 ：单位权限验证
   || 过程名称 ：prc_k_ValidateAab001Privilege
   || 功能描述 ：开户未通过单位，单位信息异常，未批准月报，单位权限控制，
   ||            单位做账期号不一致时单位未通过验证
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：cora          完成日期 ：2015-11-11
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateAab001Privilege(
      prm_aab001          IN            VARCHAR2,     --单位编号
      prm_msg             OUT           VARCHAR2,     -- 错误信息
      prm_sign            OUT           VARCHAR2,     -- 错误标志
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2);    --出错信息
   /*--------------------------------------------------------------------------
   || 业务环节 ：人员新参保网厅验证
   || 过程名称 prc_p_ValidateAac002Privilege
   || 功能描述 ：校验该人员是否能进行新参保的信息录入
   ||
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：zhujing         完成日期 ：2015-11-16
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateAac002Privilege(
       prm_yae181          IN            VARCHAR2,     --证件类型
      prm_aac002          IN            VARCHAR2,     --证件号码
      prm_aab001          IN            VARCHAR2,     --单位编号
      prm_msg             OUT           VARCHAR2,     -- 错误信息
      prm_sign            OUT           VARCHAR2,     -- 错误标志
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2);    --出错信息
   /*--------------------------------------------------------------------------
   || 业务环节 ：人员单个新参保网厅保存验证
   || 过程名称 prc_p_ValidateAac002Privilege
   || 功能描述 ：校验该人员是否能进行新参保的信息录入
   ||
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：zhujing         完成日期 ：2015-11-16
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_checkNewInsur(
       prm_iaz018          IN            VARCHAR2,     --批次号
      prm_yab139          IN            VARCHAR2,     --经办机构
      prm_msg             OUT           VARCHAR2,     -- 错误信息
      prm_sign            OUT           VARCHAR2,     -- 错误标志
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2);    --出错信息
  /*--------------------------------------------------------------------------
   || 业务环节 ：人员续保网厅验证
   || 过程名称 prc_p_ValidateAac002Continue
   || 功能描述 ：校验该人员是否能进行续保的信息录入
   ||
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：zhujing         完成日期 ：2015-11-23
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateAac002Continue(
       prm_yae181          IN            VARCHAR2,     --证件类型
      prm_aac002          IN            VARCHAR2,     --证件号码
      prm_aab001          IN            VARCHAR2,     --单位编号
      prm_iaa100          IN            VARCHAR2,     --月度
      prm_aac001          IN            VARCHAR2,     --个人编号
      prm_msg             OUT           VARCHAR2,     -- 错误信息
      prm_sign            OUT           VARCHAR2,     -- 错误标志
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2);    --出错信息
  /*--------------------------------------------------------------------------
   || 业务环节 ：人员续保网厅验证
   || 过程名称 prc_p_ValidateContinueCheck
   || 功能描述 ：校验该人员录入的续保信息
   ||
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：zhujing         完成日期 ：2015-11-24
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateContinueCheck(
       prm_iaz018          IN            VARCHAR2,     --批次号
      prm_yab139          IN            VARCHAR2,     --经办机构
      prm_msg             OUT           VARCHAR2,     -- 错误信息
      prm_sign            OUT           VARCHAR2,     -- 错误标志
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2);    --出错信息
   /*--------------------------------------------------------------------------
   || 业务环节 ：人员新增险种网厅验证
   || 过程名称 prc_p_ValidateAac002KindAdd
   || 功能描述 ：校验该人员是否能进行新增险种的信息录入
   ||
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：zhujing         完成日期 ：2015-11-23
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateAac002KindAdd(
       prm_yae181          IN            VARCHAR2,     --证件类型
      prm_aac002          IN            VARCHAR2,     --证件号码
      prm_aab001          IN            VARCHAR2,     --单位编号
      prm_iaa100          IN            VARCHAR2,     --月度
      prm_aac001          IN           VARCHAR2,     --个人编号
      prm_msg             OUT           VARCHAR2,     -- 错误信息
      prm_sign            OUT           VARCHAR2,     -- 错误标志
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2);    --出错信息
   /*--------------------------------------------------------------------------
   || 业务环节 ：人员新增险种网厅验证
   || 过程名称 prc_p_ValidateKindAddCheck
   || 功能描述 ：校验该人员录入的新增险种信息
   ||
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：zhujing         完成日期 ：2015-11-24
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateKindAddCheck(
       prm_iaz018          IN            VARCHAR2,     --批次号
      prm_yab139          IN            VARCHAR2,     --经办机构
      prm_msg             OUT           VARCHAR2,     -- 错误信息
      prm_sign            OUT           VARCHAR2,     -- 错误标志
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2);    --出错信息
  /*--------------------------------------------------------------------------
   || 业务环节 ：人员暂停缴费保存网厅验证
   || 过程名称 prc_p_ValidateKindAddCheck
   || 功能描述 ：校验该人员信息
   ||
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：zhujing         完成日期 ：2015-11-24
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateReduceCheck(
       prm_iaz018          IN            VARCHAR2,     --批次号
       prm_aac001          IN            VARCHAR2,     --个人编号
      prm_yab139          IN            VARCHAR2,     --经办机构
      prm_msg             OUT           VARCHAR2,     -- 错误信息
      prm_sign            OUT           VARCHAR2,     -- 错误标志
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2);    --出错信息
    /*--------------------------------------------------------------------------
   || 业务环节 ：人员批量暂停缴费网厅验证
   || 过程名称 prc_p_ValidateKindAddCheck
   || 功能描述 ：校验该人员信息
   ||
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：zhujing         完成日期 ：2015-11-24
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateBatchReduceCheck(
       prm_iaz018          IN            VARCHAR2,     --批次号
      prm_yab139          IN            VARCHAR2,     --经办机构
      prm_msg             OUT           VARCHAR2,     -- 错误信息
      prm_sign            OUT           VARCHAR2,     -- 错误标志
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2);    --出错信息
   /*--------------------------------------------------------------------------
   || 业务环节 ：人员在职转待退保存网厅验证
   || 过程名称 prc_p_ValidateRetireCheck
   || 功能描述 ：校验该人员信息
   ||
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：zhujing         完成日期 ：2015-11-24
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateRetireCheck(
       prm_iaz018          IN            VARCHAR2,     --批次号
       prm_aac001          IN            VARCHAR2,     --个人编号
      prm_yab139          IN            VARCHAR2,     --经办机构
      prm_msg             OUT           VARCHAR2,     -- 错误信息
      prm_sign            OUT           VARCHAR2,     -- 错误标志
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2);    --出错信息
   /*--------------------------------------------------------------------------
   || 业务环节 ：退休人员死亡保存网厅验证
   || 过程名称 prc_p_ValidateDeathCheck
   || 功能描述 ：校验该人员信息
   ||
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：zhujing         完成日期 ：2015-11-24
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateDeathCheck(
       prm_iaz018          IN            VARCHAR2,     --批次号
       prm_aac001          IN            VARCHAR2,     --个人编号
      prm_yab139          IN            VARCHAR2,     --经办机构
      prm_msg             OUT           VARCHAR2,     -- 错误信息
      prm_sign            OUT           VARCHAR2,     -- 错误标志
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2);    --出错信息
   /*****************************************************************************
   ** 过程名称 : prc_batchImportView
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：批量导入
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001     IN     irab01.aab001%TYPE,--单位编号
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-17   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_batchImportView(prm_aab001     IN     irac01.aab001%TYPE,--单位编号
                                  prm_iaa100     IN     irac01.iaa100%TYPE,--申报月度
                                  prm_iaz018     IN     irac01a2.iaz018%TYPE,  --批量导入批次ID
                                  prm_yab139     IN     irac01.yab139%TYPE,--经办中心
                                  prm_AppCode    OUT    VARCHAR2  ,
                                  prm_ErrorMsg   OUT    VARCHAR2 );
   /*****************************************************************************
   ** 过程名称 : prc_batchImport
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：批量导入
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001     IN     irab01.aab001%TYPE,--单位编号
   **           prm_aae011     IN     ab08.aae011%TYPE,  --经办人员
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-17   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_batchImport(prm_aab001     IN     irac01.aab001%TYPE,--单位编号
                             prm_aae011     IN     ae02.aae011%TYPE,  --经办人员
                             prm_iaa100     IN     VARCHAR2,--申报月度
                             prm_iaz018     IN     irac01a2.iaz018%TYPE,  --批量导入批次ID
                             prm_yab139     IN     irac01.yab139%TYPE,--经办中心
                             prm_AppCode    OUT    VARCHAR2  ,
                             prm_ErrorMsg   OUT    VARCHAR2 );
    /*--------------------------------------------------------------------------
   || 业务环节 ：月度缴费申报功能初始化界面校验
   || 过程名称 prc_p_ValidateDeathCheck
   || 功能描述 ：校验月报
   ||
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：zhujing         完成日期 ：2015-12-3
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateMonthApply(
       prm_aab001          IN            VARCHAR2,     --单位编号
      prm_yab139          IN            VARCHAR2,     --经办机构
      prm_iaa100          OUT           VARCHAR2,     --当前使显示申报月度
      prm_flag            OUT           VARCHAR2,     --返回业务状态标志
      prm_msg             OUT           VARCHAR2,     --提示信息
      prm_sign            OUT           VARCHAR2,     --错误标志
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2);    --出错信息
  /*--------------------------------------------------------------------------
   || 业务环节 ：单位参保证明申请权限验证
   || 过程名称 ：prc_p_ValidateProveApply
   || 功能描述 ：
   ||
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：zhujing          完成日期 ：2015-12-18
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateProveApply(
      prm_aab001          IN            VARCHAR2,     --单位编号
      prm_msg             OUT           VARCHAR2,     -- 错误信息
      prm_sign            OUT           VARCHAR2,     -- 错误标志
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2);    --出错信息
     /*--------------------------------------------------------------------------
   || 业务环节 ：校验参保人员是否可以新增某一个险种
   || 过程名称 prc_p_ValidateAddKindYesOrNo
   || 功能描述 ：校验险种新增
   ||
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：ycliu         完成日期 ：2017-02-15
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateAddKindYesOrNo(
       prm_aab001          IN            VARCHAR2,     --单位编号
       prm_aac001          IN            VARCHAR2,     --个人编号
       prm_aae140          IN            VARCHAR2,     --险种
      prm_yab139          IN            VARCHAR2,     --经办机构
      prm_flag            OUT           VARCHAR2,     --返回状态标志
      prm_msg             OUT           VARCHAR2,     --提示信息
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2);    --出错信息

   --校验批量人员新增险种
PROCEDURE prc_p_ValidKindsBatchAddCheck(PRM_IAZ018 IN VARCHAR2,
                                       PRM_AAB001   IN VARCHAR2,
                                       PRM_IAA100   IN VARCHAR2,
                                       PRM_APPCODE  OUT VARCHAR2,
                                       PRM_ERRORMSG OUT VARCHAR2);
   --校验批量人员续保
   PROCEDURE prc_p_ValidBatchContinueCheck(PRM_IAZ018 IN VARCHAR2,
                          PRM_AAB001 IN VARCHAR2,
                         PRM_IAA100 IN VARCHAR2,
                         PRM_APPCODE  OUT VARCHAR2,
                         PRM_ERRORMSG OUT VARCHAR2);
   /*--------------------------------------------------------------------------
   || 业务环节 ：校验参保人员是否可以续保某一个险种
   || 过程名称 prc_p_ValidateAddKindYesOrNo
   || 功能描述 ：校验续保
   ||
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：ycliu         完成日期 ：2017-02-15
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_p_ValidateContinueYesOrNo(
       prm_aab001          IN            VARCHAR2,     --单位编号
       prm_aac001          IN            VARCHAR2,     --个人编号
       prm_aae140          IN            VARCHAR2,     --险种
      prm_yab139          IN            VARCHAR2,     --经办机构
      prm_flag            OUT           VARCHAR2,     --返回状态标志
      prm_msg             OUT           VARCHAR2,     --提示信息
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2);    --出错信息

    /*--------------------------------------------------------------------------
   || 业务环节 ：特殊新参保校验
   || 过程名称 prc_p_ValidateAddKindYesOrNo
   || 功能描述 ：特殊新参保校验
   ||
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：        完成日期 ：2017-02-19
   ||------------------------------------------------------------------------*/

  PROCEDURE prc_p_ValidateAac002Special(
       prm_yae181          IN            VARCHAR2,     --证件类型
      prm_aac002          IN            VARCHAR2,     --证件号码
      prm_aab001          IN            VARCHAR2,     --单位编号
      prm_msg             OUT           VARCHAR2,     -- 错误信息
      prm_sign            OUT           VARCHAR2,     -- 错误标志
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2);    --出错信息

  /*    --续保上账过程 账户转入
  procedure prc_p_accountInto(prm_str    IN CLOB,
                              prm_aaz174 IN VARCHAR2,
                              prm_AppCode OUT   VARCHAR2  ,             --错误代码
                               prm_ErrorMsg  OUT   VARCHAR2
                              );
        --账户转出下账
  procedure prc_p_accountOut(prm_rows IN VARCHAR2,
                             prm_log OUT sys_refcursor,
                             prm_AppCode OUT   VARCHAR2,             --错误代码
                              prm_ErrorMsg  OUT   VARCHAR2
                            );
                              --回写上账标志
procedure prc_p_accountUpdate(prm_rows IN VARCHAR2,
                           prm_AppCode OUT   VARCHAR2,             --错误代码
                           prm_ErrorMsg  OUT   VARCHAR2
                          );*/
--续保信息校验
PROCEDURE prc_p_checkInfoByaac001(prm_aac001 IN VARCHAR2,
                           prm_aab001 IN VARCHAR2,
                           prm_flag    OUT   VARCHAR2, --1校验失败，无法续保 2校验成功，高新 3校验成功，市局 4校验成功，合并数据
                           prm_msg     OUT   VARCHAR2,
                           prm_AppCode OUT   VARCHAR2,             --错误代码
                           prm_ErrorMsg  OUT   VARCHAR2
                          );
 /*****************************************************************************
   ** 过程名称 : FUN_GETAAB020
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：根据工商提取的企业类型代码获取对应的单位经济类型
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab020       IN     irab01.aab020%TYPE  ,--经济类型
   ******************************************************************************
   ** 作    者：z         作成日期 ：2017-09-08   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   /*获取单位经济类型*/
   FUNCTION  FUN_GETAAB020 (prm_aaa100     IN     aa10a1.aaa100%TYPE,  --字段名
                            prm_aaa102    IN      aa10a1.aaa102%TYPE) --字段值
                            RETURN VARCHAR2;


   PROCEDURE prc_p_checkInfoByYear(prm_aab001 IN VARCHAR2,
                                prm_yab139 IN  VARCHAR2,     --经办机构
                                prm_aae001 OUT NUMBER,
                                prm_aae002 OUT NUMBER,
                                prm_disabledBtn    OUT VARCHAR2,
                                prm_msg     OUT   VARCHAR2,
                                prm_dxby01    OUT   VARCHAR2,
                                prm_gxby01    OUT   VARCHAR2,
                                prm_dxby03  OUT   VARCHAR2,
                                prm_gxby03  OUT   VARCHAR2,
                                prm_dxby60  OUT   VARCHAR2, --个体工商 工伤失业低线
                                prm_gxby60  OUT   VARCHAR2, --个体工商 工伤失业高线
                                prm_AppCode OUT   VARCHAR2,             --错误代码
                                prm_ErrorMsg  OUT   VARCHAR2
                              );


END pkg_p_Validate;