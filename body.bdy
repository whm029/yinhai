create or replace package body PKG_Insurance AS
   /**************************************************************************************/
   /* 程序包名 ：PKG_Insurance                                                           */
   /* 业务环节 ：人员管理                                                                */
   /* 功能描述 ：                                                                        */
   /*------------------------------------------------------------------------------------*/
   /* 对象列表 ：公用过程                                                                */
   /* 过程编号   过程名                                描述                              */
   /*  01        prc_AddNewEmpReg                   单位新立户                           */
   /*  02        prc_AddApplyInfo                   社会保险登记                         */
   /*  03        prc_UnitInfoMaintain               单位信息维护                         */
   /*  04        prc_AuditSocietyInsuranceR         社会保险登记审核                     */
   /*  05        prc_AuditSocietyInsuranceREmp      社会保险登记审核[单位]               */
   /*  06        prc_AuditSocietyInsuranceRPer      社会保险登记审核[个人 新参保 续保]   */
   /*  07        prc_AddNewManage                   新增专管员                           */
   /*  08        prc_MonthInternetRegister          月申报                               */
   /*  09        prc_AuditMonthInternetR            月申报审核                           */

   PRE_ERRCODE  CONSTANT VARCHAR2(12) := 'INSURANCE'; -- 本包的错误编号前缀

   /*****************************************************************************
   ** 过程名称 : prc_AuditSocietyInsuranceREmp
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：社会保险登记审核[单位参保]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-22   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_AuditSocietyInsuranceREmp (
      prm_yae099       IN     VARCHAR2          ,--业务流水号
      prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
      prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
      prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2    );

   /*****************************************************************************
   ** 过程名称 : prc_AuditSocietyInsuranceRPer
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：社会保险登记审核[人员参保]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-24   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_AuditSocietyInsuranceRPer (prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                            prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --单位编码
                                            prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                            prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                            prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                            prm_aae036       IN    irac01.aae036%TYPE ,    --经办时间
                                            prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                            prm_ErrMsg       OUT   VARCHAR2  );   --错误内容


   /***************************************************************************
   ** 过程称 ：prc_AuditMonthInternetRpause
   ** 过程号 ：
   ** 业务节 ：个人停保
   ** 功能述 ：个人停保
   ****************************************************************************
   ** 参数述 ：参数标识        输入/输出           类型               名称
   ****************************************************************************
   **
   ** 作  者：     作成日期 ：2009-11-26   版本编号 ：Ver 1.0.0
   ****************************************************************************
   ** 修  改：
   ****************************************************************************
   ** 备  注：prm_AppCode 构成是:过程编号（2位） ＋ 顺序号（2位）
   ***************************************************************************/
   --个人停保
   PROCEDURE prc_AuditMonthInternetRpause
                            (prm_yae099       IN    xasi2.ac05.YAE099%TYPE  ,     --业务流水号
                             prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --单位编码
                             prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                             prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                             prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                             prm_aae036       IN    irac01.aae036%TYPE ,    --经办时间
                             prm_AppCode     OUT    VARCHAR2          ,     --执行代码
                             prm_ErrMsg      OUT    VARCHAR2          );    --执行结果

   /*****************************************************************************
   ** 过程名称 : prc_RollBackASIREmp
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：回退社会保险登记审核[单位信息回退]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位编号
   **           prm_yea099       IN     ae02a2.yae099%TYPE,--业务流水号
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-06   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_RollBackASIREmp (
      prm_aab001       IN     irab01.aab001%TYPE,--单位编号
      prm_yae099       IN     xasi2.ac02a2.yae099%TYPE,--业务流水号
      prm_aae011       IN     xasi2.ab01.aae011%TYPE  ,--经办人
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );

   /*****************************************************************************
   ** 过程名称 : prc_p_checkQYYL
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：企业养老缴费核定
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位编号
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-22   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_p_checkQYYL (
      prm_aab001       IN     irab01.aab001%TYPE,--单位编号
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );

   /*****************************************************************************
   ** 过程名称 : prc_RollBackASIRPer
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：回退社会保险登记审核[个人信息回退 新参保 续保]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aac001       IN     irac01.aac001%TYPE,--人员编号
   **           prm_yea099       IN     ae02a2.yae099%TYPE,--业务流水号
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-06   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_RollBackASIRPer (
      prm_iac001       IN     irac01.iac001%TYPE,--申报人员编号
      prm_yae099       IN     xasi2.ac02a2.yae099%TYPE,--业务流水号
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );

   /*****************************************************************************
   ** 过程名称 : prc_RollBackAMIRPer
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：回退月申报审核[个人信息回退 停保]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aac001       IN     irac01.aac001%TYPE,--人员编号
   **           prm_yea099       IN     ae02a2.yae099%TYPE,--业务流水号
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-06   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_RollBackAMIRPer (
      prm_iac001       IN     irac01.iac001%TYPE,--申报人员编号
      prm_yae099       IN     xasi2.ac02a2.yae099%TYPE,--业务流水号
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );


   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuCheck
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[人员新参保审核]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuCheck(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                             prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --单位编码
                             prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                             prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                             prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                             prm_aae036       IN    irac01.aae036%TYPE ,    --经办时间
                             prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                             prm_ErrMsg       OUT   VARCHAR2  );   --错误内容


   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuAddCheck
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[人员险种新增审核]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuAddCheck(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --单位编码
                                prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                prm_aae036       IN    irac01.aae036%TYPE ,    --经办时间
                                prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                prm_ErrMsg       OUT   VARCHAR2  );   --错误内容


   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuContinue
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[人员续保审核]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuContinue(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --单位编码
                                prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                prm_aae036       IN    irac01.aae036%TYPE ,    --经办时间
                                prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                prm_ErrMsg       OUT   VARCHAR2  );   --错误内容

   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuPause
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[人员停保审核]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuPause(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                             prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --单位编码
                             prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                             prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                             prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                             prm_aae036       IN    irac01.aae036%TYPE ,    --经办时间
                             prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                             prm_ErrMsg       OUT   VARCHAR2  );   --错误内容


   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuToRetire
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[在职转退休审核]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuToRetire(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --单位编码
                                prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                prm_aae036       IN    irac01.aae036%TYPE ,    --经办时间
                                prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                prm_ErrMsg       OUT   VARCHAR2  );   --错误内容
   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuCheckRollback
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[人员新参保审核]回退
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuCheckRollback(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                     prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                     prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                     prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                     prm_aae013       IN    irac01.aae013%TYPE ,    --备注
                                     prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                     prm_ErrMsg       OUT   VARCHAR2  );   --错误内容

   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuAddCheckRollback
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[人员险种新增审核]回退
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuAddCheckRollback(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                        prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                        prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                        prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                        prm_aae013       IN    irac01.aae013%TYPE ,    --备注
                                        prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                        prm_ErrMsg       OUT   VARCHAR2  );   --错误内容

   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuContinueRollback
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[人员续保审核]回退
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuContinueRollback(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                        prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                        prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                        prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                        prm_aae013       IN    irac01.aae013%TYPE ,    --备注
                                        prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                        prm_ErrMsg       OUT   VARCHAR2  );   --错误内容
   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuPauseRollback
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[人员停保审核]回退
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuPauseRollback(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                    prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                    prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                    prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                    prm_aae013       IN    irac01.aae013%TYPE ,    --备注
                                    prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                    prm_ErrMsg       OUT   VARCHAR2  );   --错误内容

   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuToRetireRollback
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[在职转退休审核]回退
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuToRetireRollback(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                        prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                        prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                        prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                        prm_aae013       IN    irac01.aae013%TYPE ,    --备注
                                        prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                        prm_ErrMsg       OUT   VARCHAR2  );   --错误内容

   /*****************************************************************************
   ** 过程名称 : prc_PersonInfoRepair
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月报审核通过补充个人信息
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_iac001        IN    irac01.iac001%TYPE,--申报编号
   **           prm_aac001       IN    irac01.aac001%TYPE,  --个人编号
   **           prm_aac002       IN    irac01.aac002%TYPE, --证件号
   **           prm_aab001       IN    irab01.aab001%TYPE,  --单位助记码
   **           prm_aae011       IN    irac01.aae011%TYPE ,  --经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2018-12-21   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInfoRepair(prm_yae099       IN    VARCHAR2,  --业务流水号
                                  prm_iac001        IN    irac01.iac001%TYPE,--申报编号
                                  prm_aac001       IN    irac01.aac001%TYPE,  --个人编号
                                  prm_aac002       IN    irac01.aac002%TYPE, --证件号码
                                  prm_aab001       IN    irab01.aab001%TYPE,  --单位助记码
                                  prm_aae011       IN    irac01.aae011%TYPE ,  --经办人
                                  prm_AppCode   OUT   VARCHAR2  ,    --错误代码
                                  prm_ErrMsg       OUT   VARCHAR2  );   --错误内容


   /*****************************************************************************
   ** 过程名称 prc_AddNewEmpReg
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：单位新立户[含单企业养老险种的老单位]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_iab001       IN     irab01.iab001%TYPE,--单位助记码
   **           prm_aab003       IN     irab01.aab003%TYPE,--组织机构代码
   **           prm_aab004       IN     irab01.aab004%TYPE,--单位名称
   **           prm_aab007       IN     irab01.aab007%TYPE,--工商执照号码
   **           prm_aab030       IN     irab01.aab030%TYPE,--税收号码
   **           prm_yab028       IN     irab01.yab028%TYPE,--地税管理代码
   **           prm_yab534       IN     irab01.yab534%TYPE,--开户银行类别
   **           prm_aab024       IN     irab01.aab024%TYPE,--开户银行
   **           prm_aab025       IN     irab01.aab025%TYPE,--银行户名
   **           prm_aab026       IN     irab01.aab026%TYPE,--银行基本账号
   **           prm_aac003       IN     iraa01.aab016%TYPE,--专管员姓名
   **           prm_yae042       IN     iraa01.yae042%TYPE,--专管员密码
   **           prm_yae043       IN     iraa01.yae043%TYPE,--初始密码
   **           prm_aae120       IN     irab01.aae120%TYPE,--机关养老
   **           prm_aae210       IN     irab01.aae210%TYPE,--失业保险
   **           prm_aae310       IN     irab01.aae310%TYPE,--医疗保险
   **           prm_aae410       IN     irab01.aae410%TYPE,--工伤
   **           prm_aae510       IN     irab01.aae510%TYPE,--生育
   **           prm_aae311       IN     irab01.aae311%TYPE,--大病
   **           prm_aae011       IN     irab01.aae011%TYPE,--经办人
   **           prm_yab003       IN     irab01.yab003%TYPE,--经办机构
   **           prm_aae013       IN     irab01.aae013%TYPE,--备注
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          )
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-12   版本编号 ：Ver 1.0.0
   ** 修    改：
   ** 单位新立户[含单企业养老险种的老单位]
   *****************************************************************************/
   PROCEDURE prc_AddNewEmpReg (
      prm_iab001       IN     irab01.iab001%TYPE,--单位助记码
      prm_aab003       IN     irab01.aab003%TYPE,--组织机构代码
      prm_aab004       IN     irab01.aab004%TYPE,--单位名称
      prm_yab028       IN     irab01.yab028%TYPE,--地税管理代码
      prm_yab006       IN     irab01.yab006%TYPE,--税务机构
      prm_aab019       IN     irab01.aab019%TYPE,--单位类型
      prm_aab020       IN     irab01.aab020%TYPE,--经济类型
      prm_aab021       IN     irab01.aab021%TYPE,--隶属关系
      prm_aab022       IN     irab01.aab022%TYPE,--行业代码
      prm_yab022       IN     irab01.yab022%TYPE,--行业标识
      prm_aab030       IN     irab01.aab030%TYPE,--税收号码
      prm_ylb001       IN     irab01.ylb001%TYPE,--工伤行业等级
      prm_yab136       IN     irab01.yab136%TYPE,--单位管理状态
      prm_yab534       IN     irab01.yab534%TYPE,--开户银行类别
      prm_aab024       IN     irab01.aab024%TYPE,--开户银行
      prm_aab025       IN     irab01.aab025%TYPE,--银行户名
      prm_aab026       IN     irab01.aab026%TYPE,--银行基本账号
      prm_aac003       IN     iraa01.aab016%TYPE,--专管员姓名
      prm_yab516       IN     iraa01.yab516%TYPE,--专管员身份证号
      prm_yae042       IN     iraa01.yae042%TYPE,--专管员密码
      prm_yae043       IN     iraa01.yae043%TYPE,--初始密码
      prm_aae110       IN     irab01.aae110%TYPE,--职工养老
      prm_aae120       IN     irab01.aae120%TYPE,--机关养老
      prm_aae210       IN     irab01.aae210%TYPE,--失业保险
      prm_aae310       IN     irab01.aae310%TYPE,--医疗保险
      prm_aae410       IN     irab01.aae410%TYPE,--工伤
      prm_aae510       IN     irab01.aae510%TYPE,--生育
      prm_aae311       IN     irab01.aae311%TYPE,--大病
      prm_yae010_110   IN     irab03.yae010_110%TYPE,--职工养老来源方式
      prm_yae010_120   IN     irab03.yae010_120%TYPE,--机关养老来源方式
      prm_yae010_210   IN     irab03.yae010_210%TYPE,--失业保险来源方式
      prm_yae010_310   IN     irab03.yae010_310%TYPE,--医疗保险来源方式
      prm_yae010_410   IN     irab03.yae010_410%TYPE,--工伤来源方式
      prm_yae010_510   IN     irab03.yae010_510%TYPE,--生育来源方式
      prm_yae010_311   IN     irab03.yae010_311%TYPE,--大病来源方式
      prm_aae011       IN     irab01.aae011%TYPE,--经办人
      prm_yab003       IN     irab01.yab003%TYPE,--经办机构
      prm_aae013       IN     irab01.aae013%TYPE,--备注
      prm_flag         IN     VARCHAR2          , --是否单企业养老险种的老单位
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

      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;

      /*必要的数据校验*/
      IF prm_iab001 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'单位助记码不能为空!';
         RETURN;
      END IF;

      IF prm_aab004 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'单位名称不能为空!';
         RETURN;
      END IF;

      /*
      IF prm_yab534 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'银行类别不能为空!';
         RETURN;
      END IF;

      IF prm_aab024 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'开户银行不能为空!';
         RETURN;
      END IF;

      IF prm_aab025 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'银行户名不能为空!';
         RETURN;
      END IF;

      IF prm_aab026 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'银行基本账号不能为空!';
         RETURN;
      END IF;
      */

      IF prm_aac003 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'专管员姓名不能为空!';
         RETURN;
      END IF;

      IF prm_yae042 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE || '专管员密码不能为空!';
         RETURN;
      END IF;

      IF prm_yae043 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'初始密码不能为空!';
         RETURN;
      END IF;

      IF prm_aae011 IS NULL THEN
         prm_ErrorMsg := PRE_ERRCODE ||'经办人不能为空!';
         RETURN;
      END IF;

      --是否存在相同的单位信息
      /*
      方便虚拟同名的其它性质的单位如：退休单位等
      IF prm_aab003 IS NOT NULL THEN
         SELECT COUNT(1)
           INTO n_count
           FROM AB01
          WHERE aab003 = prm_aab003          --组织机构代码
            AND aab004 = prm_aab004;         --单位名称
         IF n_count > 0 THEN
            prm_ErrorMsg := PRE_ERRCODE ||'已经存在组织机构代码为['|| prm_aab003 ||']的相同的单位['|| prm_aab004 ||']!';
            RETURN;
         END IF;
      END IF;

      IF prm_aab007 IS NOT NULL THEN
         SELECT COUNT(1)
           INTO n_count
           FROM AB01
          WHERE aab007 = prm_aab007;         --工商执照
         IF n_count > 0 THEN
            prm_ErrorMsg := PRE_ERRCODE ||'已经存在工商执照号码为['|| prm_aab007 ||']的相同的单位!';
            RETURN;
         END IF;
      END IF;

      IF prm_aab030 IS NOT NULL THEN
         SELECT COUNT(1)
           INTO n_count
           FROM AB01
          WHERE aab030 = prm_aab030;         --税号
         IF n_count > 0 THEN
            prm_ErrorMsg := PRE_ERRCODE ||'已经存在税字号为['|| prm_aab030 ||']的相同的单位!';
            RETURN;
         END IF;
      END IF;
     */
      IF prm_aab003 IS NULL AND prm_aab030 IS NULL THEN
         SELECT COUNT(1)
           INTO n_count
           FROM xasi2.AB01
          WHERE aab001 = prm_iab001;         --社保助记码
         IF n_count > 0 THEN
            prm_ErrorMsg := PRE_ERRCODE ||'已经存在社保助记码为['|| prm_iab001 ||']的相同的单位!';
            RETURN;
         END IF;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
      IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
         prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号AAZ002!';
         RETURN;
      END IF;

      v_yae092 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'FRAMEWORK');
      IF v_yae092 IS NULL OR v_yae092 = '' THEN
         prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号FRAMEWORK!';
         RETURN;
      END IF;

      v_yae367 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'DEFAULT');
      IF v_yae367 IS NULL OR v_yae367 = '' THEN
         prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号DEFAULT!';
         RETURN;
      END IF;

      /*
         写入申报单位信息：
         确定单位参保险种，
                 专管员,
                 税号，工商执照，组织机构代码，地税管理代码
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
                  AAE119,    --2013-03-14 wl 新增
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
                  PKG_Constant.IAA002_WIR, --0 待申报
                  prm_iab001,
                  prm_aab003,
                  prm_aab004,
                  '1',--新开户
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
                  '1',          --2013-03-14 wl 新增
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
          分配登陆账号口令
      */
      INSERT INTO wsjb.ad53a4  (
           yae092,  -- 操作人员编号
           yab109,  -- 部门编号
           aac003,  -- 姓名
           aac004,  -- 性别
           yab003,  -- 经办机构
           yae041,  -- 登陆号
           yae042,  -- 登陆口令
           yae361,  -- 锁定标志
           yae362,  -- 口令错误次数
           yae363,  -- 最后一次变更时间
           yae114,  -- 排序号
           aae100,  -- 有效标志
           aae011,  -- 经办人
           aae036   -- 经办时间
           )
      VALUES
          (
           v_yae092  ,  -- 操作人员编号
           '0101'    ,  -- 部门编号[单位经办]
           prm_aac003,  -- 姓名
           '9'       ,  -- 性别
           prm_yab003,  -- 经办机构
           prm_iab001,  -- 登陆号=单位编号=单位助记码[默认首任专管员如此]
           prm_yae042,  -- 登陆口令
           '0'       ,  -- 锁定标志
           0         ,  -- 口令错误次数
           SYSDATE,     -- 最后一次变更时间
           0         ,  -- 排序号
           '1'       ,  -- 有效标志
           prm_aae011,  -- 经办人
           SYSDATE      -- 经办时间
      );

      /*
         中心端数据新增：目的 解决中心端经办人员先是问题
      */
      INSERT INTO xasi2.ad53a4 (
           yae092,  -- 操作人员编号
           yab109,  -- 部门编号
           aac003,  -- 姓名
           aac004,  -- 性别
           yab003,  -- 经办机构
           yae041,  -- 登陆号
           yae042,  -- 登陆口令
           yae361,  -- 锁定标志
           yae362,  -- 口令错误次数
           yae363,  -- 最后一次变更时间
           yae114,  -- 排序号
           aae100,  -- 有效标志
           aae011,  -- 经办人
           aae036   -- 经办时间
           )
      VALUES
          (
           v_yae092  ,  -- 操作人员编号
           '0101'    ,  -- 部门编号[单位经办]
           prm_aac003,  -- 姓名
           '9'       ,  -- 性别
           prm_yab003,  -- 经办机构
           prm_iab001,  -- 登陆号=单位编号=单位助记码[默认首任专管员如此]
           prm_yae042,  -- 登陆口令
           '0'       ,  -- 锁定标志
           0         ,  -- 口令错误次数
           SYSDATE,  -- 最后一次变更时间
           0         ,  -- 排序号
           '1'       ,  -- 有效标志
           prm_aae011,  -- 经办人
           SYSDATE      -- 经办时间
      );


      /*
          为操作人员授权为单位经办的岗位
      */
      INSERT INTO  wsjb.AD53A6
                  (
                   yae093,  -- 角色编号
                   yab109,  -- 部门编号
                   yae092,  -- 操作人员编号
                   aae011,  -- 经办人
                   aae036   -- 经办时间
                  )
           VALUES
                  (
                   '1000000021',  -- 角色编号[单位经办]
                   '0101'    ,  -- 部门编号
                   v_yae092  ,  -- 操作人员编号
                   prm_aae011,  -- 经办人
                   SYSDATE      -- 经办时间
      );

      /*
         记录用户岗位变动日志
      */
      INSERT INTO wsjb.ad53a8  (
             yae367,  -- 变动流水号
             yae093,  -- 角色编号
             yab109,  -- 部门编号
             yae092,  -- 操作人员编号
             aae011,  -- 经办人
             aae036,  -- 经办时间
             yae369,  -- 修改人
             yae370,  -- 修改时间
             yae372)  -- 权限变动类型
      VALUES (
             v_yae367 ,  -- 变动流水号
             '1000000021',  -- 角色编号
             '0101',       -- 部门编号
             v_yae092,    -- 操作人员编号
             prm_aae011,  -- 经办人
             SYSDATE   ,  -- 经办时间
             prm_aae011,  -- 修改人
             SYSDATE   ,  -- 修改时间
             '07'        -- 权限变动类型
      );

  --新系统上线后放开注释 20160325
   -----新网厅框架登录帐号设置 start zhujing 20151230
      --个人岗位编号
        SELECT XAGXWT.HIBERNATE_SEQUENCE.NEXTVAL
          INTO var_position
          FROM DUAL;
               --企业专管员
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
                             '110052',--企业单位
                             NULL,
                             NULL);
              --插入个人岗位
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
                             '2',--个人岗位
                             '1',
                             '1/110045/110052',--根据具体组织路径填写 --  '1/110045/110055'
                             '西安高新区/企事业单位/企业公司',--根据具体组织填写 '西安高新区/企事业单位/机关事业单位'
                             NULL,
                             '1',
                             SYSDATE,
                             '0',
                             NULL,
                             NULL,
                             NULL,
                             NULL,
                             NULL);
              --公有岗位
              INSERT INTO XAGXWT.TAUSERPOSITION
                (USERID, POSITIONID, MAINPOSITION, CREATEUSER, CREATETIME)
              VALUES
                   (v_yae092,
                    '110066', --企业公司下的一个专管员岗位id
                    '0', --公有岗位
                    '1',
                    SYSDATE);

          END IF;
          --机关事业单位专管员
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
                             '110055',--机关事业单位
                             NULL,
                             NULL);

            --插入个人岗位
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
                             '110055',--机关事业单位
                             prm_aab004,
                             '2',--个人岗位
                             '1',
                             '1/110045/110055',--根据具体组织路径填写 --
                             '西安高新区/企事业单位/机关事业单位',--根据具体组织填写
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
                         '112605', --'112605'机关单位专管员岗位
                         '0', --公有岗位
                         '1',
                         SYSDATE);
          END IF;
          --个人岗位
          INSERT INTO XAGXWT.TAUSERPOSITION
            (USERID, POSITIONID, MAINPOSITION, CREATEUSER, CREATETIME)
          VALUES
               (v_yae092,
                var_position,
                '1', --个人岗位
                v_yae092,
                SYSDATE);

           -----新网厅框架登录帐号设置 end

      /*
         写入单位专管员信息
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
         prm_ErrorMsg := PRE_ERRCODE ||'没有获取到系统库的序列号:YAE099';
         RETURN;
      END IF;
      /*
          社保系统数据录入 单位信息 单位保险信息
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

    --当年社平公布前开户单位免年审
      IF to_char(sysdate,'MMdd') < '0715' THEN
        insert into xasi2.ab05 values(prm_iab001,to_number(to_char(sysdate,'yyyy')),'03',null,null,null,'1000000121');
      END if;

      --日志记录
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
         /*关闭打开的游标*/
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'||PRE_ERRCODE || SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;
   END prc_AddNewEmpReg;



   /*****************************************************************************
   ** 过程名称 : prc_AddApplyInfo
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：社会保险登记
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_iaz008       IN     irad02.iaz008%TYPE,--申报主体编号
   **           prm_iad003       IN     irad02.iad003%TYPE,--申报主体名称
   **           prm_aae013       IN     irad02.aae013%TYPE,--备注
   **           prm_aac001       IN     irad02.aac001%TYPE,--申报人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-12   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_AddApplyInfo (
      prm_iaz008       IN     irad02.iaz008%TYPE,--申报主体编号
      prm_iad003       IN     irad02.iad003%TYPE,--申报主体名称
      prm_aae013       IN     irad02.aae013%TYPE,--备注
      prm_aac001       IN     irad02.aac001%TYPE,--申报人
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
      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count := 0;

      /*必要的数据校验*/
      IF prm_iaz008 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '单位助记码不能为空!';
         RETURN;
      END IF;

      IF prm_aac001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '专管员编号不能为空!';
         RETURN;
      END IF;

      IF prm_iad003 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '申报主体名称不能为空!';
         RETURN;
      END IF;


      --是否存在申报单位信息
      IF prm_flag = '0' THEN
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAB01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and b.aaa121 = PKG_Constant.AAA121_NER and a.aab001 = prm_iaz008 and (a.iaa002 = PKG_Constant.IAA002_AIR or a.iaa002 = PKG_Constant.IAA002_APS);
      IF n_count > 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '单位编号为['|| prm_iaz008 ||']的单位申报信息已存在!';
            RETURN;
      END IF;
      END IF;

      --是否存在单位信息
      IF prm_flag = '0' THEN
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAB01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and a.aab001 = prm_iaz008 and (a.iaa002 = PKG_Constant.IAA002_WIR OR a.iaa002 = PKG_Constant.IAA002_NPS) and b.aaa121 = PKG_Constant.AAA121_NER;
      IF n_count = 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '单位编号为['|| prm_iaz008 ||']的单位不存在!';
            RETURN;
      END IF;
      END IF;

      /*是否存在待申报人员
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
            prm_ErrorMsg := '单位助记码为['|| prm_iaz008 ||']的单位没有待申报人员!';
            RETURN;
        END IF;
      END IF;
      */

      --是否存在相同的审核级次
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAA02
          WHERE iaa011 = PKG_Constant.IAA011_SIR
          AND iaa005 = PKG_Constant.IAA005_YES;
      IF n_count > 1 THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '系统审核级次信息有误!请联系维护人员';
            RETURN;
      END IF;



      /*获取其他信息*/

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
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误信息:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;
      END;



      --日志记录
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

      /*获取其他信息，写入IRAD01申报事件表*/
      --是否是续保
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
                  nvl(prm_aae013,'无'),
                  to_number(to_char(sysdate,'yyyymm'))
                 );

                  --写入IRAD02申报明细表

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
                  nvl(prm_aae013,'无'),
                  PKG_Constant.IAA020_DW
                 );

        v_iaz003 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ003');
        v_iaa013 := PKG_COMMON.fun_cbbh('DWKH',PKG_Constant.YAB003_JBFZX);
       --插入申报档案编号
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

                 --更新申报单位信息
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
                    --更新申报单位信息
                      UPDATE wsjb.IRAB01   SET
                          iaa002 = PKG_Constant.IAA002_AIR
                      WHERE
                          iab001 = v_iaz008;
                  ELSIF n_count > 1 THEN
                     ROLLBACK;
                     prm_AppCode  :=  gn_def_ERR;
                     prm_ErrorMsg := '单位申报信息有误!请联系维护人员';
                     RETURN;
                  END IF;

                  SELECT COUNT(1)
                  into n_count
                  FROM wsjb.IRAB01  a
                  WHERE a.aab001 = prm_iaz008 AND a.iaa002 = PKG_Constant.IAA002_APS;
                  IF n_count = 0 THEN
                      --写入IRAD02申报明细表

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
                  nvl(prm_aae013,'无'),
                  PKG_Constant.IAA020_DW
                 );
                  END IF;


      END IF;


      /* --写入单位下人员信息申报明细

       FOR cur_result in c_cur LOOP

             v_aac001 := cur_result.aac001;
             v_aac003 := cur_result.aac003;
             v_iac001 := cur_result.iac001;
             v_iaz005 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');

             select nvl(max(iaz005),v_iaz005) into v_iaz006 from irad02 where iaz007 = v_iac001;

             IF v_aac001 IS NULL THEN
                 goto con_null;
             END IF;

             --插入人员申报明细
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

                 --更改人员申报状态
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
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;

   END prc_AddApplyInfo;

   /*****************************************************************************
   ** 过程名称 : prc_UnitBaseInfoMaintain
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：单位基本信息维护
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
      prm_aab001       IN     irab01.aab001%TYPE, --单位编号
      prm_aab004       IN     irab01.aab004%TYPE, --单位名称
      prm_aab005       IN     irab01.aab005%TYPE, --单位电话
      prm_aab006       IN     irab01.aab006%TYPE, --工商登记执照种类
      prm_aab007       IN     irab01.aab007%TYPE, --工商登记执照号码
      prm_yab519       IN     irab01.yab519%TYPE, --单位电子邮箱
      prm_aae014       IN     irab01.aae014%TYPE, --传真
      prm_aae007       IN     irab01.aae007%TYPE, --邮政编码
      prm_aab020       IN     irab01.aab020%TYPE, --经济成分
      prm_aab021       IN     irab01.aab021%TYPE, --隶属关系
      prm_yab007       IN     irab01.yab007%TYPE, --工商登记地
      prm_yab005       IN     irab01.yab005%TYPE, --地税管理科
      prm_aab030       IN     irab01.aab030%TYPE, --税号
      prm_yab534       IN     irab01.yab534%TYPE, --开户银行类别
      prm_aab024       IN     irab01.aab024%TYPE, --开户银行
      prm_aab025       IN     irab01.aab025%TYPE, --银行户名
      prm_aab026       IN     irab01.aab026%TYPE, --银行开户账号
      prm_yab389       IN     irab01.yab389%TYPE, --法人手机号
      prm_aab015       IN     irab01.aab015%TYPE, --法人办公电话
      prm_aae011       IN     irad01.aae011%TYPE, --经办人
      prm_aae013       IN     irad01.aae013%TYPE, --备注
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2013-01-21   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_UnitBaseInfoMaintain (
      prm_aab001       IN     irab01.aab001%TYPE, --单位编号
      prm_aab004       IN     irab01.aab004%TYPE, --单位名称
      prm_aab005       IN     irab01.aab005%TYPE, --单位电话
      prm_yab519       IN     irab01.yab519%TYPE, --单位电子邮箱
      prm_aae014       IN     irab01.aae014%TYPE, --传真
      prm_aae007       IN     irab01.aae007%TYPE, --邮政编码
      prm_aae006       IN     irab01.aae006%TYPE, --地址
      prm_aab013       IN     irab01.aab013%TYPE, --法人姓名 1
      prm_yab388       IN     irab01.yab388%TYPE, --法人证件号 1
      prm_yab389       IN     irab01.yab389%TYPE, --法人手机号
      prm_aab015       IN     irab01.aab015%TYPE, --法人办公电话
      prm_yab007       IN     irab01.yab007%TYPE, --工商登记地
      prm_aab006       IN     irab01.aab006%TYPE, --工商登记执照种类
      prm_aab007       IN     irab01.aab007%TYPE, --工商登记执照号码
      prm_yab005       IN     irab01.yab005%TYPE, --地税管理科
      prm_yab028       IN     irab01.yab028%TYPE, --地税管理代码  1
      prm_yab006       IN     irab01.yab006%TYPE, --税务机构   1
      prm_aab030       IN     irab01.aab030%TYPE, --税号
      prm_aae011       IN     irad01.aae011%TYPE, --经办人
      --prm_aab020       IN     irab01.aab020%TYPE, --经济成分
      --prm_aab021       IN     irab01.aab021%TYPE, --隶属关系
      --prm_yab534       IN     irab01.yab534%TYPE, --开户银行类别
      --prm_aab024       IN     irab01.aab024%TYPE, --开户银行
      --prm_aab025       IN     irab01.aab025%TYPE, --银行户名
      --prm_aab026       IN     irab01.aab026%TYPE, --银行开户账号
      --prm_aae013       IN     irad01.aae013%TYPE, --备注
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )

      IS
      n_count    number(5);
      v_aae007   number(20);
      v_aaz002   varchar2(15);   --业务日志id
      v_iab001   varchar2(15);
      v_iaz012   varchar2(15);  --历史修改事件ID
      v_iaz013   varchar2(15);  -- 历史修改明细ID
      v_iaz004   varchar2(15);  --申报[批次]事件ID
      v_iaz005   varchar2(15);  --申报明细ID
      v_iaz009   varchar2(15);  --审核[批次]事件ID
      v_iaz010   varchar2(15);  --审核明细ID
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

        /*数据校验*/
       IF prm_aab001 IS NULL THEN
           prm_ErrorMsg := '单位编号不能为空!';
           RETURN;
        END IF;

       IF prm_aab005 IS NULL THEN
           prm_ErrorMsg := '单位办公室电话不能为空!';
           RETURN;
        END IF;

        IF prm_aae007 IS NULL THEN
           prm_ErrorMsg := '邮政编码不能为空!';
           RETURN;
        END IF;

        IF prm_aae006 IS NULL THEN
           prm_ErrorMsg := '地址不能为空!';
           RETURN;
        END IF;

       IF prm_aab013 IS NULL THEN
           prm_ErrorMsg := '法人代表姓名不能为空!';
           RETURN;
       END IF;

       IF prm_yab388 IS NULL THEN
           prm_ErrorMsg := '法人代表证件编号不能为空!';
           RETURN;
       END IF;

       IF prm_yab007 IS NULL THEN
           prm_ErrorMsg := '工商登记地不能为空!';
           RETURN;
       END IF;

       IF prm_aab006 IS NULL THEN
           prm_ErrorMsg := '工商执照类型不能为空!';
           RETURN;
        END IF;

       IF prm_aab007 IS NULL THEN
           prm_ErrorMsg := '工商执照号码不能为空!';
           RETURN;
        END IF;

 --       IF prm_aab020 IS NULL THEN
 --          prm_ErrorMsg := '经济成分不能为空!';
 --          RETURN;
 --       END IF;

 --       IF prm_aab021 IS NULL THEN
 --          prm_ErrorMsg := '隶属关系不能为空!';
 --          RETURN;
 --       END IF;

        IF prm_yab005 IS NULL THEN
           prm_ErrorMsg := '地税管理科不能为空!';
           RETURN;
        END IF;

          IF prm_yab028 IS NULL THEN
           prm_ErrorMsg := '地税管理码不能为空!';
           RETURN;
        END IF;

         IF prm_yab005 IS NULL THEN
           prm_ErrorMsg := '税务机构不能为空!';
           RETURN;
        END IF;

        IF prm_aab030 IS NULL THEN
           prm_ErrorMsg := '税字号不能为空!';
           RETURN;
        END IF;

 --      IF prm_yab534 IS NULL THEN
 --          prm_ErrorMsg := '开户银行类别不能为空!';
 --          RETURN;
 --       END IF;

 --       IF prm_aab024 IS NULL THEN
 --         prm_ErrorMsg := '开户银行不能为空!';
 --          RETURN;
 --       END IF;

 --       IF prm_aab025 IS NULL THEN
 --          prm_ErrorMsg := '银行户名不能为空!';
 --          RETURN;
 --       END IF;

  --      IF prm_aab026 IS NULL THEN
  --         prm_ErrorMsg := '银行开户账号不能为空!';
  --         RETURN;
  --      END IF;

        --是否存在AB01单位信息
        SELECT COUNT(1)
          INTO n_count
          FROM xasi2.AB01
         WHERE aab001 = prm_aab001;
        IF n_count = 0 THEN
            prm_ErrorMsg := '单位编号为['|| prm_aab001 ||']的单位信息不存在!';
            RETURN;
        END IF;


        --将参数放进记录中
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



       --插入日志记录
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
                  '无' --nvl('无',prm_aae013)
                 );

      --申报事件表irad01
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
                  '无', --prm_aae013,
                  to_number(to_char(sysdate,'yyyymm'))
                 );

       --申报明细表irad02
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
                 '无', --prm_aae013,
                 PKG_Constant.IAA020_DW
                );

       --历史修改事件
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
                  '无' --nvl('无',prm_aae013)
                 );
      --历史修改明细

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
           /*关闭打开的游标*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'IRAB01表中没有 '|| v_name ||'字段'|| SQLERRM||dbms_utility.format_error_backtrace ;

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
           prm_ErrorMsg := '表' || 'AB01' || '字段' || UPPER(v_name) || '的数据类型为' ||
                           col_type || '。不能处理' ;
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


          --循环插入
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
                       '无', --prm_aae013,
                       '1'
                     );
         END IF;
      END LOOP;

      --插入审核事件irad21
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
                  '无' --prm_aae013
                  );
     --更新irab01中的字段
     UPDATE wsjb.IRAB01
        SET aab005 = prm_aab005, --单位电话
            aab006 = prm_aab006, --工商登记执照种类
            aab007 = prm_aab007, --工商登记执照号码
            yab519 = prm_yab519, --单位电子邮箱
            aae014 = prm_aae014, --传真
            aae007 = prm_aae007, --邮政编码
            --aab020 = prm_aab020, --经济成分
            --aab021 = prm_aab021, --隶属关系
            yab007 = prm_yab007, --工商登记地
            yab005 = prm_yab005, --地税管理科
            aab030 = prm_aab030,  --税号
            --yab534 = prm_yab534,
            --aab024 = prm_aab024,
            --aab025 = prm_aab025,
            --aab026 = prm_aab026,
            yab389 = prm_yab389,
            aab015 = prm_aab015,
            aae006 = prm_aae006,  --地址
            aab013 = prm_aab013,  --法人姓名
            yab388 = prm_yab388,  --法人证件号
            yab028 = prm_yab028,  --地税管理代码
            yab006 = prm_yab006  --税务机构
      WHERE aab001 = iab001 and aab001 = prm_aab001;

      --更新ab01中的字段
      UPDATE xasi2.ab01
        SET aab005 = prm_aab005, --单位电话
            aab006 = prm_aab006, --工商登记执照种类
            aab007 = prm_aab007, --工商登记执照号码
            yab519 = prm_yab519, --单位电子邮箱
            aae014 = prm_aae014, --传真
            aae007 = prm_aae007, --邮政编码
            --aab020 = prm_aab020, --经济成分
            --aab021 = prm_aab021, --隶属关系
            aab030 = prm_aab030,  --税号
            yab389 = prm_yab389,--法人手机号
            aab015 = prm_aab015, --法人办公电话
            aae006 = prm_aae006,  --地址
            aab013 = prm_aab013,  --法人姓名
            yab388 = prm_yab388 --法人证件号
       WHERE aab001 = prm_aab001;

      --审核明细写入irad22
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
                     '无' --prm_aae013
                     );

      EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;

     END prc_UnitBaseInfoMaintain;
   /*****************************************************************************
   ** 过程名称 : prc_UnitInfoMaintain
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：单位信息维护
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
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
   ** 作    者：yh         作成日期 ：2012-08-21   版本编号 ：Ver 1.0.0
   ** 修    改：
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

      /*必要的数据校验*/


      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '单位助记码不能为空!';
         RETURN;
      END IF;

      IF prm_aab004 IS NULL THEN
         prm_ErrorMsg := '单位名称不能为空!';
         RETURN;
      END IF;

 --     IF prm_aab022 IS NULL THEN
 --        prm_ErrorMsg := '单位行业不能为空!';
 --       RETURN;
 --     END IF;

 --    IF prm_aab019 IS NULL THEN
 --       prm_ErrorMsg := '单位类型不能为空!';
 --       RETURN;
 --    END IF;

 --     IF prm_ylb001 IS NULL THEN
 --        prm_ErrorMsg := '单位工伤行业等级不能为空!';
 --        RETURN;
 --     END IF;

 --     IF prm_aab021 IS NULL THEN
 --        prm_ErrorMsg := '单位隶属关系不能为空!';
 --        RETURN;
 --     END IF;

 --     IF prm_yab391 IS NULL THEN
 --        prm_ErrorMsg := '法人证件类型不能为空!';
 --        RETURN;
 --     END IF;

 --     IF prm_yab388 IS NULL THEN
 --        prm_ErrorMsg := '法人证件号码不能为空!';
 --        RETURN;
 --     END IF;

 --     IF prm_yab389 IS NULL THEN
 --        prm_ErrorMsg := '法人手机号码不能为空!';
 --        RETURN;
 --     END IF;

 --     IF prm_aab013 IS NULL THEN
 --        prm_ErrorMsg := '法人姓名不能为空!';
 --        RETURN;
 --     END IF;

 --     IF prm_aab015 IS NULL THEN
 --        prm_ErrorMsg := '法人办公电话不能为空!';
 --        RETURN;
 --     END IF;

--      IF prm_yab515 IS NULL THEN
--         prm_ErrorMsg := '专管员证件类型不能为空!';
--         RETURN;
--      END IF;
--
--      IF prm_yab516 IS NULL THEN
--         prm_ErrorMsg := '专管员证件编号不能为空!';
--         RETURN;
--      END IF;
--
--      IF prm_aab016 IS NULL THEN
--         prm_ErrorMsg := '专管员姓名不能为空!';
--         RETURN;
--      END IF;
--
--      IF prm_yab390 IS NULL THEN
--         prm_ErrorMsg := '专管员手机不能为空!';
--         RETURN;
--      END IF;

--      IF prm_yab028 IS NULL THEN
--         prm_ErrorMsg := '地税管理码不能为空!';
--         RETURN;
--      END IF;

 --     IF prm_yab136 IS NULL THEN
 --        prm_ErrorMsg := '单位管理状态不能为空!';
 --        RETURN;
 --     END IF;

      IF prm_yab009 IS NULL THEN
         prm_ErrorMsg := '单位经营范围不能为空!';
         RETURN;
      END IF;

--      IF prm_yab006 IS NULL THEN
--         prm_ErrorMsg := '单位税务机构不能为空!';
--         RETURN;
 --     END IF;


      --是否存在AB01单位信息
      SELECT COUNT(1)
           into n_count
           FROM xasi2.AB01
          WHERE aab001 = prm_aab001;
      IF n_count = 0 THEN
            prm_ErrorMsg := '单位编号为['|| prm_aab001 ||']的单位信息不存在!';
            RETURN;
      END IF;

      --是否存在已申报信息
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAB01
          WHERE aab001 = prm_aab001 and iaa002 = PKG_Constant.IAA002_AIR;
      IF n_count > 0 THEN
            prm_ErrorMsg := '单位编号为['|| prm_aab001 ||']的单位存在已申报信息！';
            RETURN;
      END IF;


      --是否存在可用的单位申报信息
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAB01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and a.aab001 = prm_aab001 and b.aaa121 = PKG_Constant.AAA121_NER;
      IF n_count = 0 THEN
            prm_ErrorMsg := '没有单位编号为['|| prm_aab001 ||']的可用申报信息!';
            RETURN;
      END IF;
      IF n_count > 1 THEN
            prm_ErrorMsg := '单位编号为['|| prm_aab001 ||']的可用申报信息出错，请联系维护人员!';
            RETURN;
      END IF;

      --是否存在相同的审核级次
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAA02
          WHERE iaa011 = PKG_Constant.IAA011_EIM
          AND iaa005 = PKG_Constant.IAA005_YES;
      IF n_count = 0 THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '没有系统审核级次信息!请联系维护人员';
            RETURN;
      ELSIF n_count > 1 THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '系统审核级次信息有误!请联系维护人员';
            RETURN;
      END IF;



      --将参数放进记录中
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

      --获取其他信息
      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');

      SELECT iaa004
           into v_iaa004
           FROM wsjb.IRAA02
          WHERE iaa011 = PKG_Constant.IAA011_EIM
          AND iaa005 = PKG_Constant.IAA005_YES;


       --日志记录
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
                  '无' --nvl('无',prm_aae013)
                 );


      --插入或者更新IRAB01

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

       --更新单位申报信息表
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


       --历史修改事件
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
                  '无'--nvl('无',prm_aae013)
                 );


      --申报事件表
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
                  '无', --prm_aae013,
                  to_number(to_char(sysdate,'yyyymm'))
                 );

       --申报明细表
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
                 '无', --prm_aae013,
                 PKG_Constant.IAA020_DW
                );
         --插入申报档案编号
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
                      '无', --nvl(prm_aae013,''),
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
           /*关闭打开的游标*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '单位修改信息表中存在错误数据~！'|| SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;
       END;


       --更新单位申报信息表
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

            --更新单位修改信息表
            UPDATE wsjb.irad31  SET
                   aaz002 = v_aaz002,
                   aae011 = prm_aae011,
                   aae035 = sysdate
                   --iaa019 = PKG_Constant.IAA019_IR
            WHERE iaz012 = v_iaz012;

            --更新IRAD32的数据
            UPDATE IRAD32 a SET
                a.aae100 = '0'
            WHERE a.iaz012 = v_iaz012 and a.aae100 = '1';

            --申报明细表
            v_iaz005 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');

            --查询上次ID
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
            /*关闭打开的游标*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '单位申报明细表中存在错误数据！'|| SQLERRM||dbms_utility.format_error_backtrace ;

            RETURN;
            END;

            --更新单位申报信息表
            UPDATE wsjb.IRAD01  SET
                   aaz002 = v_aaz002,
                   aae011 = prm_aae011,
                   aae035 = sysdate,
                  -- iaa019 = PKG_Constant.IAA019_IR,
                   iaa100 = to_number(to_char(sysdate,'yyyymm'))
            WHERE iaz004 = v_iaz004;

            --插入申报明细
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
                 '无',  --prm_aae013
                 PKG_Constant.IAA020_DW
                );

     END IF;


     --历史修改明细

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
           /*关闭打开的游标*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'IRAB01表中没有 '|| v_name ||'字段'|| SQLERRM||dbms_utility.format_error_backtrace ;

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
           prm_ErrorMsg := '表' || 'AB01' || '字段' || UPPER(v_name) || '的数据类型为' ||
                           col_type || '。不能处理' ;

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
                       '无', --prm_aae013,
                       '1'
                     );


         END IF;

     END LOOP;

    EXCEPTION
       WHEN OTHERS THEN
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'||v_name||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
         RETURN;
    END prc_UnitInfoMaintain;

   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuCheck
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[人员新参保审核]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuCheck(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                             prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --单位编码
                             prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                             prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                             prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                             prm_aae036       IN    irac01.aae036%TYPE ,    --经办时间
                             prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                             prm_ErrMsg       OUT   VARCHAR2  )    --错误内容
   IS
      var_procNo      VARCHAR2(2);         --过程序号
      num_count       NUMBER;
      var_yac001      VARCHAR2(20);
      var_yae235      VARCHAR2(6);
      var_yae238      VARCHAR2(2000);
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --个人编号
      var_aae140_01   VARCHAR2(2);         --是否参加了企业养老
      var_aae140_06   VARCHAR2(2);         --是否参加了机关养老
      var_aae140_02   VARCHAR2(2);         --是否参加了失业
      var_aae140_03   VARCHAR2(2);         --是否参加了基本医疗
      var_aae140_04   VARCHAR2(2);         --是否参加了工伤
      var_aae140_05   VARCHAR2(2);         --是否参加了生育
      var_aae140_07   VARCHAR2(2);         --是否参加了大额
      var_aae140_08   VARCHAR2(2);
      num_yac004      NUMBER(14,2); --养老基数
      num_yac005      NUMBER(14,2); --其他基数
      rec_irac01      irac01%rowtype;
      accountac01a1   NUMBER;   --查询到ac01a1对应条数
      v_aad055        VARCHAR2(100);
      prm_aac001_out  VARCHAR2(10);
      var_aab019       ab01.aab019%TYPE;             --单位类型  主要区分个体工伤户   yujj 20191101

   BEGIN
      prm_AppCode  := PKG_Constant.GN_DEF_OK;
      prm_ErrMsg   := '';
      var_aac001   := '';

      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      var_aae140_01 := rec_irac01.aae110;        --是否参加了企业养老
      var_aae140_06 := rec_irac01.aae120;        --是否参加了机关养老
      var_aae140_02 := rec_irac01.aae210;        --是否参加了失业
      var_aae140_03 := rec_irac01.aae310;        --是否参加了基本医疗
      var_aae140_04 := rec_irac01.aae410;        --是否参加了工伤
      var_aae140_05 := rec_irac01.aae510;        --是否参加了生育
      var_aae140_07 := rec_irac01.aae311;        --是否参加了大额
      var_aae140_08 := rec_irac01.aae810;        --是否参加了公务员


      IF var_aae140_06 = '1' OR var_aae140_06 = '10' OR var_aae140_02 = '1' OR var_aae140_02 = '10'
      OR var_aae140_03 = '1' OR var_aae140_03 = '10' OR var_aae140_04 = '1' OR var_aae140_04 = '10'
      OR var_aae140_05 = '1' OR var_aae140_05 = '10' OR var_aae140_07 = '1' OR var_aae140_07 = '10'
      OR var_aae140_08 = '1' OR var_aae140_08 = '10'
       THEN

         --写入临时表数据
         PKG_COMMON.PRC_P_insertAe16Tmp(prm_yae099,
                                       prm_iac001,
                                       '01', --批量报盘新参保
                                       prm_aab001,
                                       prm_aae011,
                                       prm_AppCode,
                                       prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            prm_ErrMsg  := '写入临时表数据:'||prm_ErrMsg;
            RETURN;
         END IF ;

         --临时表数据校验
         xasi2.pkg_gx_insuranceBatch.prc_p_insuranceCheck(prm_yae099,
                                                           prm_aab001,
                                                           PKG_Constant.YAB003_JBFZX,
                                                           PKG_Constant.YAB003_JBFZX,
                                                           prm_aae011,
                                                           prm_AppCode,
                                                           prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            prm_ErrMsg  := '临时表数据校验'||prm_ErrMsg;
            RETURN;
         END IF ;

         SELECT yae235,NVL(yae238,''),aad055
           INTO var_yae235,var_yae238,v_aad055
           FROM xasi2.AE16A1
          WHERE YAE099 = prm_yae099 ;
         IF var_yae235 = '2' THEN
            prm_AppCode := PKG_Constant.gn_def_ERR;
            prm_ErrMsg  := '人员参保信息校验失败:'||var_yae238||v_aad055;
            RETURN;
         END IF;

         --个人批量新参保导盘数据导入
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
            prm_ErrMsg  := '批量新参保导盘数据导入'||prm_AppCode||prm_ErrMsg;
            RETURN;
         END IF ;

         SELECT NVL(AAD059,'')
           INTO var_aac001
           FROM xasi2.AE16A2
          WHERE YAE099 = prm_yae099
                and  YAE235 = '1';
         IF var_aac001 = '' THEN
            prm_AppCode := PKG_Constant.gn_def_ERR;
            prm_ErrMsg  := '人员编号不存在!人员新参保失败!';
            RETURN;
         END IF;

         --更新申报信息的人员编号
         UPDATE IRAC01
            SET AAC001 = var_aac001
          WHERE IAC001 = prm_iac001;

         --更新ac01a1医疗养老编号对应表
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

         --更新申报明细信息的人员编号
         UPDATE wsjb.IRAD02
            SET IAZ008 = var_aac001
          WHERE IAZ007 = prm_iac001;

         --更新参保人员回执信息
         UPDATE xasi2.AC02
            SET AAE013 = AAE013||'数据源自网上经办业务系统'
          WHERE aac001 = var_aac001;

         --更新外国人备案的人员编号 20150408
         UPDATE wsjb.IRAC01A4
            SET AAC001 = var_aac001
          WHERE IAC001 = prm_iac001
            AND IAA002 = '2'
            AND AAE120 = '0';

         --更新外国人备案参保信息的人员编号 20150408
         UPDATE wsjb.IRAC01A5
            SET AAC001 = var_aac001
          WHERE IAC001 = prm_iac001
            AND IAA002 = '2'
            AND AAE120 = '0';
      END IF;

      --检查参保单位是否存在该人员信息
      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.IRAC01A3
       WHERE AAC001 = NVL(var_aac001,rec_irac01.AAC001)
         AND AAB001 = rec_irac01.AAB001;
      IF num_count = 0 THEN
         var_yac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'YAC001');
         IF var_yac001 is null THEN
            prm_AppCode := gn_def_ERR ;
            prm_ErrMsg  := '没有获取到单位人员序列号yac001!';
            RETURN;
         END IF;

         INSERT INTO wsjb.irac01a3 (
                     yac001,
                     aac001,          -- 个人编号
                     aab001,
                     yae181,          -- 证件类型
                     aac002,          -- 身份证号码(证件号码)
                     aac003,          -- 姓名
                     aac004,          -- 性别
                     aac005,
                     aac006,          -- 出生日期
                     aac007,          -- 参加工作日期
                     aac008,          -- 人员状态
                     aac009,
                     aac010,
                     aac012,
                     aac013,
                     aac014,
                     aac015,
                     aac020,
                     yac067,          -- 来源方式
                     yac168,          -- 农民工标志
                     aae004,
                     aae005,          -- 联系电话
                     aae006,          -- 地址
                     aae007,
                     yae222,
                     aae013,
                     aac040,
                     yab139,
                     yab013,
                     aae011,          -- 经办人
                     aae036)          -- 经办时间
            VALUES ( var_yac001,
                     NVL(var_aac001,rec_irac01.AAC001),          -- 个人编号
                     rec_irac01.aab001,
                     rec_irac01.yae181,          -- 证件类型
                     rec_irac01.aac002,          -- 身份证号码(证件号码)
                     rec_irac01.aac003,          -- 姓名
                     rec_irac01.aac004,          -- 性别
                     rec_irac01.aac005,
                     rec_irac01.aac006,          -- 出生日期
                     rec_irac01.aac007,          -- 参加工作日期
                     rec_irac01.aac008,          -- 人员状态
                     rec_irac01.aac009,
                     rec_irac01.aac010,
                     rec_irac01.aac012,
                     rec_irac01.aac013,
                     rec_irac01.aac014,
                     rec_irac01.aac015,
                     rec_irac01.aac020,
                     rec_irac01.yac067,          -- 来源方式
                     rec_irac01.yac168,          -- 农民工标志
                     rec_irac01.aae004,
                     rec_irac01.aae005,          -- 联系电话
                     rec_irac01.aae006,          -- 地址
                     rec_irac01.aae007,
                     rec_irac01.yae222,
                     rec_irac01.aae013,
                     0,
                     PKG_Constant.YAB003_JBFZX,
                     rec_irac01.aab001,
                     prm_aae011,          -- 经办人
                     prm_aae036);         -- 经办时间
      END IF;
     BEGIN  --单位管理状态
     SELECT  aab019
      INTO  var_aab019
   FROM ab01
      WHERE aab001 = rec_irac01.AAB001;
    EXCEPTION
   WHEN OTHERS THEN
        prm_AppCode := PKG_Constant.gn_def_ERR;
        prm_ErrMsg  := '单位编码'||prm_aab001||'没有获取到单位基本信息';
        RETURN;
     END;
      IF var_aae140_01 = '1' OR var_aae140_01 = '10' THEN
      --养老基数保底封顶
      SELECT pkg_common.fun_p_getcontributionbase(null,rec_irac01.aab001,ROUND(rec_irac01.aac040),'0','01','1','1',rec_irac01.iaa100,prm_yab003)
        INTO num_yac004
        FROM dual;
      --医疗基数保底封顶
      SELECT pkg_common.fun_p_getcontributionbase(null,rec_irac01.aab001,ROUND(rec_irac01.aac040),'0','03','1','1',rec_irac01.iaa100,prm_yab003)
        INTO num_yac005
        FROM dual;
       --判断个体工商户---  20191101  yujj
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
        /*关闭打开的游标*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuCheck;

   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuAddCheck
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[人员险种新增审核]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuAddCheck(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --单位编码
                                prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                prm_aae036       IN    irac01.aae036%TYPE ,    --经办时间
                                prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                prm_ErrMsg       OUT   VARCHAR2  )    --错误内容
    IS
      var_procNo      VARCHAR2(2);         --过程序号
      num_count       NUMBER;
      var_yac001      VARCHAR2(20);
      var_yae235      VARCHAR2(6);
      var_yae238      VARCHAR2(2000);
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --个人编号
      var_aae140_01   VARCHAR2(2);         --是否参加了企业养老
      var_aae140_06   VARCHAR2(2);         --是否参加了机关养老
      var_aae140_02   VARCHAR2(2);         --是否参加了失业
      var_aae140_03   VARCHAR2(2);         --是否参加了基本医疗
      var_aae140_04   VARCHAR2(2);         --是否参加了工伤
      var_aae140_05   VARCHAR2(2);         --是否参加了生育
      var_aae140_07   VARCHAR2(2);         --是否参加了大额
      var_aae140_08   VARCHAR2(2);
      num_yac004      NUMBER(14,2); --养老基数
      num_yac005      NUMBER(14,2); --医疗基数
      rec_irac01      irac01%rowtype;
      v_aad055        VARCHAR2(100);
      prm_aac001_out  VARCHAR2(10);
      var_aab019       ab01.aab019%TYPE;             --单位类型  主要区分个体工伤户   yujj 20191101


   BEGIN
      prm_AppCode  := PKG_Constant.GN_DEF_OK;
      prm_ErrMsg   := '';
      var_aac001   := '';

      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      var_aae140_01 := rec_irac01.aae110;        --是否参加了企业养老
      var_aae140_06 := rec_irac01.aae120;        --是否参加了机关养老
      var_aae140_02 := rec_irac01.aae210;        --是否参加了失业
      var_aae140_03 := rec_irac01.aae310;        --是否参加了基本医疗
      var_aae140_04 := rec_irac01.aae410;        --是否参加了工伤
      var_aae140_05 := rec_irac01.aae510;        --是否参加了生育
      var_aae140_07 := rec_irac01.aae311;        --是否参加了大额
      var_aae140_08 := rec_irac01.aae810;

      IF var_aae140_06 = '1' OR var_aae140_06 = '10' OR var_aae140_02 = '1' OR var_aae140_02 = '10'
      OR var_aae140_03 = '1' OR var_aae140_03 = '10' OR var_aae140_04 = '1' OR var_aae140_04 = '10'
      OR var_aae140_05 = '1' OR var_aae140_05 = '10' OR var_aae140_07 = '1' OR var_aae140_07 = '10'
      OR var_aae140_08 = '1' OR var_aae140_08 = '10' THEN
         --写入临时表数据
         PKG_COMMON.PRC_P_insertAe16Tmp(prm_yae099,
                                       prm_iac001,
                                       '01', --批量报盘新参保
                                       prm_aab001,
                                       prm_aae011,
                                       prm_AppCode,
                                       prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;
         --临时表数据校验
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
            prm_ErrMsg  := '人员参保信息校验失败:'||var_yae238||v_aad055;
            RETURN;
         END IF;

         --个人批量新参保导盘数据导入
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

         --更新参保人员回执信息
         UPDATE xasi2.AC02
            SET AAE013 = AAE013||'数据源自网上经办业务系统'
          WHERE aac001 = rec_irac01.AAC001
            and aae011 = prm_aae011;
      END IF;

      --检查参保单位是否存在该人员信息
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
            prm_ErrMsg  := '没有获取到单位人员序列号yac001!';
            RETURN;
         END IF;
         INSERT INTO wsjb.irac01a3 (
                     yac001,
                     aac001,          -- 个人编号
                     aab001,
                     yae181,          -- 证件类型
                     aac002,          -- 身份证号码(证件号码)
                     aac003,          -- 姓名
                     aac004,          -- 性别
                     aac005,
                     aac006,          -- 出生日期
                     aac007,          -- 参加工作日期
                     aac008,          -- 人员状态
                     aac009,
                     aac010,
                     aac012,
                     aac013,
                     aac014,
                     aac015,
                     aac020,
                     yac067,          -- 来源方式
                     yac168,          -- 农民工标志
                     aae004,
                     aae005,          -- 联系电话
                     aae006,          -- 地址
                     aae007,
                     yae222,
                     aae013,
                     aac040,
                     yab139,
                     yab013,
                     aae011,          -- 经办人
                     aae036)          -- 经办时间
            VALUES ( var_yac001,
                     NVL(var_aac001,rec_irac01.AAC001),          -- 个人编号
                     rec_irac01.aab001,
                     rec_irac01.yae181,          -- 证件类型
                     rec_irac01.aac002,          -- 身份证号码(证件号码)
                     rec_irac01.aac003,          -- 姓名
                     rec_irac01.aac004,          -- 性别
                     rec_irac01.aac005,
                     rec_irac01.aac006,          -- 出生日期
                     rec_irac01.aac007,          -- 参加工作日期
                     rec_irac01.aac008,          -- 人员状态
                     rec_irac01.aac009,
                     rec_irac01.aac010,
                     rec_irac01.aac012,
                     rec_irac01.aac013,
                     rec_irac01.aac014,
                     rec_irac01.aac015,
                     rec_irac01.aac020,
                     rec_irac01.yac067,          -- 来源方式
                     rec_irac01.yac168,          -- 农民工标志
                     rec_irac01.aae004,
                     rec_irac01.aae005,          -- 联系电话
                     rec_irac01.aae006,          -- 地址
                     rec_irac01.aae007,
                     rec_irac01.yae222,
                     rec_irac01.aae013,
                     0,
                     PKG_Constant.YAB003_JBFZX,
                     rec_irac01.aab001,
                     prm_aae011,          -- 经办人
                     prm_aae036);         -- 经办时间
      END IF;
       END IF;
     BEGIN  --单位管理状态
     SELECT  aab019
      INTO  var_aab019
   FROM ab01
      WHERE aab001 = rec_irac01.AAB001;
    EXCEPTION
   WHEN OTHERS THEN
        prm_AppCode := PKG_Constant.gn_def_ERR;
        prm_ErrMsg  := '单位编码'||prm_aab001||'没有获取到单位基本信息';
        RETURN;
     END;

      IF var_aae140_01 = '1' OR var_aae140_01 = '10' THEN
     --养老基数保底封顶 2013-12-03
      SELECT pkg_common.fun_p_getcontributionbase(null,rec_irac01.aab001,ROUND(rec_irac01.aac040),'0','01','1','1',rec_irac01.iaa100,prm_yab003)
        INTO num_yac004
        FROM dual;
      --医疗基数保底封顶
      SELECT pkg_common.fun_p_getcontributionbase(null,rec_irac01.aab001,ROUND(rec_irac01.aac040),'0','03','1','1',rec_irac01.iaa100,prm_yab003)
        INTO num_yac005
        FROM dual;
       --判断个体工商户---  20191101  yujj
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
        /*关闭打开的游标*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuAddCheck;

      /*****************************************************************************
   ** 过程名称 : prc_PersonInsuContinue
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[人员续保审核]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuContinue(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --单位编码
                                prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                prm_aae036       IN    irac01.aae036%TYPE ,    --经办时间
                                prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                prm_ErrMsg       OUT   VARCHAR2  )    --错误内容
    IS
      var_procNo      VARCHAR2(2);         --过程序号
      num_count       NUMBER;
      var_yac001      VARCHAR2(20);
      var_yae235      VARCHAR2(6);
      var_yae238      VARCHAR2(2000);
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --个人编号
      var_aae140_01   VARCHAR2(2);         --是否参加了企业养老
      var_aae140_06   VARCHAR2(2);         --是否参加了机关养老
      var_aae140_02   VARCHAR2(2);         --是否参加了失业
      var_aae140_03   VARCHAR2(2);         --是否参加了基本医疗
      var_aae140_04   VARCHAR2(2);         --是否参加了工伤
      var_aae140_05   VARCHAR2(2);         --是否参加了生育
      var_aae140_07   VARCHAR2(2);         --是否参加了大额
      var_aae140_08   VARCHAR2(2);
      num_yac004      NUMBER(14,2); --养老基数
      num_yac005      NUMBER(14,2); --医疗基数
      rec_irac01      irac01%rowtype;
       v_aad055       VARCHAR2(100);
      irac01_aac001   VARCHAR2(15);
      irac01a3_aac001 VARCHAR2(15);
      AAC001_NEW_OLD  VARCHAR2(15);
      --YAC200_NEW      VARCHAR2(6);
      var_aab019       ab01.aab019%TYPE;             --单位类型  主要区分个体工伤户   yujj 20191101

   BEGIN
      prm_AppCode  := PKG_Constant.GN_DEF_OK;
      prm_ErrMsg   := '';
      var_aac001   := '';

      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      var_aae140_01 := rec_irac01.aae110;        --是否参加了企业养老
      var_aae140_06 := rec_irac01.aae120;        --是否参加了机关养老
      var_aae140_02 := rec_irac01.aae210;        --是否参加了失业
      var_aae140_03 := rec_irac01.aae310;        --是否参加了基本医疗
      var_aae140_04 := rec_irac01.aae410;        --是否参加了工伤
      var_aae140_05 := rec_irac01.aae510;        --是否参加了生育
      var_aae140_07 := rec_irac01.aae311;        --是否参加了大额
      var_aae140_08 := rec_irac01.aae810;

      IF var_aae140_01 ='10'  OR var_aae140_01 ='1'
       OR  var_aae140_06 = '1' OR var_aae140_02 = '1'
      OR var_aae140_03 = '1' OR var_aae140_04 = '1'
      OR var_aae140_05 = '1' OR var_aae140_07 = '1' OR var_aae140_08 = '1'
      OR var_aae140_06 = '10' OR var_aae140_02 = '10'
      OR var_aae140_03 = '10' OR var_aae140_04 = '10'
      OR var_aae140_05 = '10' OR var_aae140_07 = '10'
      OR var_aae140_08 = '10' THEN
         --写入临时表数据
         PKG_COMMON.PRC_P_insertAe16Tmp(prm_yae099,
                                       prm_iac001,
                                       '04', --批量报盘续保
                                       prm_aab001,
                                       prm_aae011,
                                       prm_AppCode,
                                       prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;
         --临时表数据校验
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
            prm_ErrMsg  := '人员参保信息校验失败:'||var_yae238||v_aad055;
            RETURN;
         END IF;


          --modify by wangz at 20181112 begin
          -- 取个人编号  续保有两种情况（有ac01 和  无  ac01）
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
       -- 月报审核通过补充个人信息
       PKG_Insurance.prc_PersonInfoRepair(prm_yae099, --业务流水号
                               prm_iac001,--申报编号
                               AAC001_NEW_OLD, --个人编号
                               rec_irac01.aac002 , --证件号码
                               prm_aab001, --单位助记码
                               prm_aae011, --经办人
                               prm_AppCode, --错误代码
                               prm_ErrMsg); --错误内容
          IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;
        --modify by wanghm at 2018-12-21 end

         <<update_ac01_label>>
           null;


         --个人批量新参保导盘数据导入
         xasi2.pkg_p_Person_Batch.prc_p_Person_Continue_treat(prm_yae099,
                                                        prm_aab001,
                                                        '1'       ,    --'1' 只处理检查成功的--'2' 如果存在检查失败数据
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
            prm_ErrMsg  := '人员编号不存在!人员新参保失败!';
            RETURN;
         END IF;

          --更新申报信息的人员编号
         UPDATE IRAC01
            SET AAC001 = var_aac001
          WHERE IAC001 = prm_iac001;

         --更新申报明细信息的人员编号
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
         --更改公务员职级
              UPDATE xasi2.ac01
                SET YAC200=YAC200_NEW
            WHERE aac001=AAC001_NEW_OLD;
        --modify by wangz at 20181126 end
          whm end **/



         --更新参保人员回执信息
         UPDATE xasi2.AC02
            SET AAE013 = AAE013||'续保数据源自网上经办业务系统'
          WHERE aac001 = rec_irac01.aac001
            and aae011 = prm_aae011;
      END IF;

      --检查参保单位是否存在该人员信息
      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.IRAC01A3
       WHERE AAC001 = NVL(AAC001_NEW_OLD,rec_irac01.AAC001)
         AND AAB001 = rec_irac01.AAB001;
      IF num_count = 0 THEN
         var_yac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'YAC001');
         IF var_yac001 is null THEN
            prm_AppCode := gn_def_ERR ;
            prm_ErrMsg  := '没有获取到单位人员序列号yac001!';
            RETURN;
         END IF;
         INSERT INTO wsjb.irac01a3 (
                     yac001,
                     aac001,          -- 个人编号
                     aab001,
                     yae181,          -- 证件类型
                     aac002,          -- 身份证号码(证件号码)
                     aac003,          -- 姓名
                     aac004,          -- 性别
                     aac005,
                     aac006,          -- 出生日期
                     aac007,          -- 参加工作日期
                     aac008,          -- 人员状态
                     aac009,
                     aac010,
                     aac012,
                     aac013,
                     aac014,
                     aac015,
                     aac020,
                     yac067,          -- 来源方式
                     yac168,          -- 农民工标志
                     aae004,
                     aae005,          -- 联系电话
                     aae006,          -- 地址
                     aae007,
                     yae222,
                     aae013,
                     aac040,
                     yab139,
                     yab013,
                     aae011,          -- 经办人
                     aae036)          -- 经办时间
            VALUES ( var_yac001,
                     NVL(AAC001_NEW_OLD,rec_irac01.AAC001),          -- 个人编号
                     rec_irac01.aab001,
                     rec_irac01.yae181,          -- 证件类型
                     rec_irac01.aac002,          -- 身份证号码(证件号码)
                     rec_irac01.aac003,          -- 姓名
                     rec_irac01.aac004,          -- 性别
                     rec_irac01.aac005,
                     rec_irac01.aac006,          -- 出生日期
                     rec_irac01.aac007,          -- 参加工作日期
                     rec_irac01.aac008,          -- 人员状态
                     rec_irac01.aac009,
                     rec_irac01.aac010,
                     rec_irac01.aac012,
                     rec_irac01.aac013,
                     rec_irac01.aac014,
                     rec_irac01.aac015,
                     rec_irac01.aac020,
                     rec_irac01.yac067,          -- 来源方式
                     rec_irac01.yac168,          -- 农民工标志
                     rec_irac01.aae004,
                     rec_irac01.aae005,          -- 联系电话
                     rec_irac01.aae006,          -- 地址
                     rec_irac01.aae007,
                     rec_irac01.yae222,
                     rec_irac01.aae013,
                     0,
                     PKG_Constant.YAB003_JBFZX,
                     rec_irac01.aab001,
                     prm_aae011,          -- 经办人
                     prm_aae036);         -- 经办时间
      END IF;


  --  处理申报数据和养老信息数据
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
                 prm_ErrMsg   :=  '该人员'|| rec_irac01.AAC002 ||'为多编号人员，请选择另外一个个人编号再进行操作';
                  RETURN;

          WHEN OTHERS THEN

              IF    irac01_aac001   <>  irac01a3_aac001 THEN
             prm_AppCode  :=  PKG_Constant.gn_def_ERR;
             prm_ErrMsg   := 'irac01'||irac01_aac001||'与irac01a3'||irac01a3_aac001||'信息不匹配!';
              END IF;
             RETURN;
         END;
          --  end 20190613
     BEGIN  --单位管理状态
     SELECT  aab019
      INTO  var_aab019
   FROM ab01
      WHERE aab001 = rec_irac01.AAB001;
    EXCEPTION
   WHEN OTHERS THEN
        prm_AppCode := PKG_Constant.gn_def_ERR;
        prm_ErrMsg  := '单位编码'||prm_aab001||'没有获取到单位基本信息';
        RETURN;
     END;
      IF var_aae140_01 = '1' OR var_aae140_01 = '10' THEN
        --养老基数保底封顶
        SELECT pkg_common.fun_p_getcontributionbase(null,rec_irac01.aab001,ROUND(rec_irac01.aac040),'0','01','1','1',rec_irac01.iaa100,prm_yab003)
          INTO num_yac004
          FROM dual;

        --医疗基数保底封顶
        SELECT pkg_common.fun_p_getcontributionbase(null,rec_irac01.aab001,ROUND(rec_irac01.aac040),'0','03','1','1',rec_irac01.iaa100,prm_yab003)
          INTO num_yac005
          FROM dual;
       --判断个体工商户---  20191101  yujj
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
        /*关闭打开的游标*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuContinue;

   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuPause
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[人员停保审核]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuPause(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                             prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --单位编码
                             prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                             prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                             prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                             prm_aae036       IN    irac01.aae036%TYPE ,    --经办时间
                             prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                             prm_ErrMsg       OUT   VARCHAR2  )    --错误内容
   IS
      var_procNo      VARCHAR2(2);         --过程序号
      num_count       NUMBER;
      var_yac001      VARCHAR2(20);
      var_yae235      VARCHAR2(6);
      var_yae238      VARCHAR2(2000);
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --个人编号
      var_aae140_01   VARCHAR2(2);         --是否参加了企业养老
      var_aae140_06   VARCHAR2(2);         --是否参加了机关养老
      var_aae140_02   VARCHAR2(2);         --是否参加了失业
      var_aae140_03   VARCHAR2(2);         --是否参加了基本医疗
      var_aae140_04   VARCHAR2(2);         --是否参加了工伤
      var_aae140_05   VARCHAR2(2);         --是否参加了生育
      var_aae140_07   VARCHAR2(2);         --是否参加了大额
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

      var_aae140_01 := rec_irac01.aae110;        --是否参加了企业养老
      var_aae140_06 := rec_irac01.aae120;        --是否参加了机关养老
      var_aae140_02 := rec_irac01.aae210;        --是否参加了失业
      var_aae140_03 := rec_irac01.aae310;        --是否参加了基本医疗
      var_aae140_04 := rec_irac01.aae410;        --是否参加了工伤
      var_aae140_05 := rec_irac01.aae510;        --是否参加了生育
      var_aae140_07 := rec_irac01.aae311;        --是否参加了大额
      var_aae140_08 := rec_irac01.aae810;

      IF var_aae140_06 = '3' OR var_aae140_02 = '3'
      OR var_aae140_03 = '3' OR var_aae140_04 = '3'
      OR var_aae140_05 = '3' OR var_aae140_07 = '3'
      OR var_aae140_08 = '3' THEN
         --写入临时表数据
         PKG_COMMON.PRC_P_insertAe16Tmp(prm_yae099,
                                       prm_iac001,
                                       '03', --批量报盘暂停
                                       prm_aab001,
                                       prm_aae011,
                                       prm_AppCode,
                                       prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;
         --临时表数据校验
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
            prm_ErrMsg  := '人员参保信息校验失败:'||var_yae238||v_aad055;
            RETURN;
         END IF;

         --个人批量暂停导盘数据导入
         xasi2.pkg_p_Person_Batch.prc_p_Person_pause_treat(prm_yae099,
                                                        prm_aab001,
                                                        '1'       ,    --'1' 只处理检查成功的--'2' 如果存在检查失败数据
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
        /*关闭打开的游标*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuPause;

   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuToRetire
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[在职转退休审核]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuToRetire(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                    prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --单位编码
                                    prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                    prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                    prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                    prm_aae036       IN    irac01.aae036%TYPE ,    --经办时间
                                    prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                    prm_ErrMsg       OUT   VARCHAR2  )    --错误内容
   IS
      var_procNo      VARCHAR2(2);         --过程序号
      num_count       NUMBER;
      var_yac001      VARCHAR2(20);
      var_yae235      VARCHAR2(6);
      var_yae238      VARCHAR2(2000);
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --个人编号
      var_aae140_01   VARCHAR2(2);         --是否参加了企业养老
      var_aae140_06   VARCHAR2(2);         --是否参加了机关养老
      var_aae140_02   VARCHAR2(2);         --是否参加了失业
      var_aae140_03   VARCHAR2(2);         --是否参加了基本医疗
      var_aae140_04   VARCHAR2(2);         --是否参加了工伤
      var_aae140_05   VARCHAR2(2);         --是否参加了生育
      var_aae140_07   VARCHAR2(2);         --是否参加了大额
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

      var_aae140_01 := rec_irac01.aae110;        --是否参加了企业养老
      var_aae140_06 := rec_irac01.aae120;        --是否参加了机关养老
      var_aae140_02 := rec_irac01.aae210;        --是否参加了失业
      var_aae140_03 := rec_irac01.aae310;        --是否参加了基本医疗
      var_aae140_04 := rec_irac01.aae410;        --是否参加了工伤
      var_aae140_05 := rec_irac01.aae510;        --是否参加了生育
      var_aae140_07 := rec_irac01.aae311;        --是否参加了大额
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
        /*关闭打开的游标*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuToRetire;

   /*****************************************************************************
   ** 过程名称 : prc_AuditSocietyInsuranceR
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：社会保险登记审核
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_iaa011       IN     iraa02.iaa011%TYPE,--业务类型
   **           prm_iaa003       IN     iraa02.iaa003%TYPE,--业务主体
   **           prm_iaa004       IN     iraa02.iaa011%TYPE,--审核标志
   **           prm_iaa028       IN     VARCHAR2          ,--是否全部
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_aae013       IN     iraa02.aae013%TYPE,--备注
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-21   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_AuditSocietyInsuranceR (
      prm_iaa011       IN     iraa02.iaa011%TYPE,--业务类型
      prm_iaa003       IN     iraa02.iaa003%TYPE,--业务主体
      prm_iaa018       IN     irad22.iaa018%TYPE,--审核标志
      prm_iaa028       IN     VARCHAR2          ,--是否全部
      prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
      prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
      prm_aae013       IN     iraa02.aae013%TYPE,--备注
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

      --定义游标，获取批量审核人员信息
      CURSOR cur_tmp_person IS
      SELECT IAC001, --申报人员信息编号,VARCHAR2
             AAC001, --个人编号,VARCHAR2
             AAB001, --单位编号,VARCHAR2
             AAC002, --公民身份号码,VARCHAR2
             AAC003, --姓名,VARCHAR2
             IAA001, --人员类别
             IAZ005, --申报明细ID
             IAA003  --业务主体
        FROM wsjb.IRAD22_TMP  --批量审核人员信息零时表
        ORDER by iaa003;

   BEGIN

      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;


      /*检查临时表是否存在数据*/
      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.IRAD22_TMP ;
      IF n_count = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'审核临时表无可用数据!';
         RETURN;
      END IF;


      /*必要的数据校验*/
      IF prm_iaa011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'业务类型不能为空!';
         RETURN;
      END IF;

      IF prm_iaa003 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'业务主体不能为空!';
         RETURN;
      END IF;

      IF prm_iaa018 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'审核标志不能为空!';
         RETURN;
      END IF;

      IF prm_iaa028 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'标志[是否全部]不能为空!';
         RETURN;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
      IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号AAZ002!';
         RETURN;
      END IF;

      v_iaz009 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ009');
      IF v_iaz009 IS NULL OR v_iaz009 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号IAZ009!';
         RETURN;
      END IF;

      --审核事件
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

         --申报主体是个人时校验：必须单位信息审核通过才能办理
         IF REC_TMP_PERSON.iaa003 = PKG_Constant.IAA003_PER THEN
            SELECT COUNT(1)
              INTO n_count
              FROM wsjb.IRAB01
             WHERE AAB001 = REC_TMP_PERSON.AAB001
               AND IAA002 = PKG_Constant.IAA002_APS;
            IF n_count = 0 THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'社会保险登记审核时必须单位信息审核通过才能办理人员信息审核!';
               RETURN;
            END IF;
         END IF;
         /*
            如果是以单位为业务主体[审核的是单位信息]
            可以办理的有打回 审核通过 不通过
         */
          /*
            反之是针对人员的信息审核
            可以办理的是打回 通过 不通过 批量通过 全部通过 全不通过
         */

         --审核明细处理
         v_iaz010 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ010');
         IF v_iaz010 IS NULL OR v_iaz010 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号IAZ010!';
            RETURN;
         END IF;

         --查询上次审核情况
         BEGIN
            SELECT IAA015
              INTO v_iaa015
              FROM wsjb.IRAD02
             WHERE IAZ005 = REC_TMP_PERSON.IAZ005;

            IF v_iaa015 in (PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
              prm_ErrorMsg := PRE_ERRCODE ||'审核已经终结!';
              RETURN;
           END IF;

            --提取上次审核信息
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
                                          PKG_Constant.IAA018_DAD, --打回[放弃审核]
                                          PKG_Constant.IAA018_NPS  --不通过 Not Pass
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
                     prm_ErrorMsg := PRE_ERRCODE ||'申报信息处于审核中，但未获取到上次审核信息,请确认上次审核是否终结!';
                     RETURN;
               END;

               v_iaa014 := v_iaa017;
               v_iaa017 := v_iaa017 + 1;
               IF v_iaa017 > v_iaa004 THEN
                  v_iaa017 := v_iaa004;
               END IF;

               --审核级次等于当前级次
               IF v_iaa004 = v_iaa014 AND v_iaa004 = v_iaa017 THEN
                  ROLLBACK;
                  prm_AppCode  := gn_def_ERR;
                  prm_ErrorMsg := PRE_ERRCODE ||'审核已经终结!';
                  RETURN;
               END IF;
            END IF;

            --提取申报明细信息
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
                     prm_ErrorMsg := PRE_ERRCODE ||'没有提取到申报明细信息!';
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
               prm_ErrorMsg := '审核信息提取错误:'|| PRE_ERRCODE || SQLERRM ||dbms_utility.format_error_backtrace ;
               RETURN;
         END;

         --审核明细写入
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
                     IAD005,    --审核意见
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
                     prm_aae013,  --审核意见
                     null
         );

         --打回
         IF prm_iaa018 = PKG_Constant.IAA018_DAD THEN

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_DAD, --打回[修改续报]
                   AAE013 = prm_aae013
             WHERE IAA015 = PKG_Constant.IAA015_WAD --待审
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '1' THEN
               --更新申报单位状态
               UPDATE wsjb.IRAB01
                  SET IAA002 = PKG_Constant.IAA002_ALR  --已打回
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAB001 = REC_TMP_PERSON.AAB001;
            END IF;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --更新申报人员状态
               UPDATE wsjb.irac01
                  SET IAA002 = PKG_Constant.IAA002_ALR  --已打回
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --审核未通过
         IF prm_iaa018 = PKG_Constant.IAA018_NPS THEN

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_ADO, --审核完毕
                   AAE013 = prm_aae013
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --待审/审核中
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '1' THEN
               --更新申报单位状态
               UPDATE wsjb.IRAB01
                  SET IAA002 = PKG_Constant.IAA002_NPS  --未通过
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAB001 = REC_TMP_PERSON.AAB001;
            END IF;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --更新申报人员状态
               UPDATE wsjb.irac01
                  SET IAA002 = PKG_Constant.IAA002_NPS  --未通过
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --审核通过
         IF prm_iaa018 = PKG_Constant.IAA018_PAS AND v_iaa014 = v_iaa004 THEN

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015  =  PKG_Constant.IAA015_ADO --审核完毕
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --待审/审核中
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            v_yae099    := xasi2.PKG_comm.fun_GetSequence(NULL,'yae099');
            IF v_yae099 IS NULL OR v_yae099 = '' THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'没有获取到系统库的序列号:YAE099';
               RETURN;
            END IF;

            IF REC_TMP_PERSON.iaa003 = '1' THEN
               --更新申报单位状态
               UPDATE wsjb.IRAB01
                  SET IAA002 = PKG_Constant.IAA002_APS  --已通过
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAB001 = REC_TMP_PERSON.AAB001;

               /*
                  社保系统数据录入 单位信息 单位保险信息
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
               --更新申报人员状态
               UPDATE wsjb.irac01
                  SET IAA002 = PKG_Constant.IAA002_APS  --已通过
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAC001 = REC_TMP_PERSON.IAC001;

               /*
                  社保系统数据录入 人员信息 人员保险信息
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

      --日志记录
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
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace  ;
         RETURN;
   END prc_AuditSocietyInsuranceR;


   /*****************************************************************************
   ** 过程名称 : prc_AuditSocietyInsuranceREmp
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：社会保险登记审核[单位参保]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-22   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_AuditSocietyInsuranceREmp (
      prm_yae099       IN     VARCHAR2          ,--业务流水号
      prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
      prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
      prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
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

       /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;
      v_aab033     := '04';--默认地税征收;


      SELECT COUNT(1)
        INTO n_count
        FROM xasi2.ab01
       WHERE AAB001 = PRM_AAB001;
      IF n_count > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE || '已经存在该单位信息!'||PRM_AAB001;
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
  /*   --企业基本养老保险
      IF v_aae110 = '1' THEN
          t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE110';
          t_cols(t_cols.COUNT).COL_VALUE := '01';
       END IF;
       --机关事业养老保险
        IF v_aae120 = '1' THEN
          t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE120';
          t_cols(t_cols.COUNT).COL_VALUE := '06';
       END IF;*/
       --失业保险
       IF v_aae210 = '1' THEN
          t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE210';
          t_cols(t_cols.COUNT).COL_VALUE := '02';
       END IF;
       --基本医疗保险
       IF v_aae310 = '1' THEN
          t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE310';
          t_cols(t_cols.COUNT).COL_VALUE := '03';
       END IF;
       --工伤保险
       IF v_aae410 = '1' THEN
          t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE410';
          t_cols(t_cols.COUNT).COL_VALUE := '04';
       END IF;
       --生育保险
       IF v_aae510 = '1' THEN
          t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE510';
          t_cols(t_cols.COUNT).COL_VALUE := '05';
       END IF;
       --大病补充商业保险
       IF v_aae311 = '1' THEN
          t_cols(t_cols.COUNT + 1).COL_NAME := 'AAE311';
          t_cols(t_cols.COUNT).COL_VALUE := '07';
       END IF;

       ----------------------------------------------------------------------------------------------------------

       --写入单位基本信息
       INSERT INTO xasi2.ab01(AAB001 ,--单位编号
                       AAB002 ,--社会保险登记证编码
                       AAB003 ,--组织机构代码
                       AAB004 ,--单位名称
                       AAB005 ,--单位电话
                       AAB006 ,--工商登记执照种类
                       AAB007 ,--工商登记执照号码
                       AAB008 ,--工商登记发照日期
                       AAB009 ,--工商登记有效期限
                       AAB010 ,--批准成立单位
                       AAB011 ,--批准日期
                       AAB012 ,--批准文号
                       AAB013 ,--法定代表人姓名
                       YAB136 ,--单位管理状态
                       AAB019 ,--单位类型
                       AAB020 ,--经济成分
                       AAB021 ,--隶属关系
                       AAB022 ,--单位行业
                       YLB001 ,--工伤行业等级
                       YAB391 ,--法定代表人证件类型
                       YAB388 ,--法定代表人证件编号
                       YAB389 ,--法定代表人手机
                       AAB015 ,--法定代表人办公电话
                       YAB518 ,--成立日期
                       AAE007 ,--邮政编码
                       AAE006 ,--地址
                       YAE225 ,--注册地址
                       YAB519 ,--单位电子邮箱
                       YAB520 ,--单位网址
                       AAE014 ,--传真
                       AAB034 ,--社会保险经办机构编码
                       AAB301 ,--所属行政区划代码
                       YAB322 ,--最近一次换证验证时间
                       YAB274 ,--事业单位资金来源
                       YAB525 ,--是否企业化管理事业单位
                       YAB524 ,--退休人员大额代扣标志
                       YAB521 ,--离休资金来源单位
                       YAB522 ,--二乙资金来源单位
                       YAB523 ,--单位实际编制人数
                       YAB236 ,--机关事业单位法人代码
                       AAE119 ,--单位状态
                       YAB275 ,--社会保险执行办法
                       YAE496 ,--所属街道
                       YAE407 ,--所属社区
                       AAE013 ,--备注
                       AAE011 ,--经办人
                       AAE036 ,--经办时间
                       YAE443 ,--经办人姓名
                       YAB553 ,--高校类型
                       AAB304 ,--经办机构负责人
                       YAE393 ,--经办机构负责人联系电话
                       YAB554 ,--经办机构负责人手机/E-mail
                       YKB110 ,--预划医疗帐户
                       YKB109 ,--是否享受公务员统筹待遇
                       YAB566 ,--是否军转户
                       YAB565 ,--财政拨款文号
                       YAB380 ,--困难企业标志
                       YAB279 ,--医疗一次性补充资金缴纳认定
                       YAB003 ,--经办分中心
                       AAF020 ,--税务机构编号
                       AAB343 ,--一级单位编号
                       AAB030  --税号

                      )
              SELECT AAB001 ,-- 单位编号
                     AAB002 ,-- 社会保险登记证编码
                     AAB003 ,-- 组织机构代码
                     AAB004 ,-- 单位名称
                     AAB005 ,-- 单位电话
                     AAB006 ,-- 工商登记执照种类
                     AAB007 ,-- 工商登记执照号码
                     AAB008 ,-- 工商登记发照日期
                     AAB009 ,-- 工商登记有效期限
                     AAB010 ,-- 批准成立单位
                     AAB011 ,-- 批准日期
                     AAB012 ,-- 批准文号
                     AAB013 ,-- 法定代表人姓名
                     YAB136 ,-- 单位管理状态
                     AAB019 ,-- 单位类型
                     AAB020 ,-- 经济成分
                     AAB021 ,-- 隶属关系
                     AAB022 ,-- 单位行业
                     YLB001 ,-- 工伤行业等级
                     YAB391 ,-- 法定代表人证件类型
                     YAB388 ,-- 法定代表人证件编号
                     YAB389 ,-- 法定代表人手机
                     AAB015 ,-- 法定代表人办公电话
                     YAB518 ,-- 成立日期
                     AAE007 ,-- 邮政编码
                     AAE006 ,-- 地址
                     YAE225 ,-- 注册地址
                     YAB519 ,-- 单位电子邮箱
                     YAB520 ,-- 单位网址
                     AAE014 ,-- 传真
                     AAB034 ,-- 社会保险经办机构编码
                     AAB301 ,-- 所属行政区划代码
                     ''     ,--最近一次换证验证时间
                     ''     ,--事业单位资金来源
                     '0'    ,--是否企业化管理事业单位
                     '0'    ,--退休人员大额代扣标志
                     '0'    ,--离休资金来源单位
                     '0'    ,--二乙资金来源单位
                     '0'    ,--单位实际编制人数
                     '0'    ,--机关事业单位法人代码
                     '1' ,--单位状态
                     YAB275 ,--社会保险执行办法
                     YAE496 ,--所属街道
                     YAE407 ,--所属社区
                     AAE013 ,--备注
                     AAE011 ,--经办人
                     AAE036 ,--经办时间
                     YAE443 ,--经办人姓名
                     YAB553 ,--高校类型
                     AAB304 ,--经办机构负责人
                     YAE393 ,--经办机构负责人联系电话
                     YAB554 ,--经办机构负责人手机/E-mail
                     ''     ,--预划医疗帐户
                     '0'    ,--是否享受公务员统筹待遇
                     '0'    ,--是否军转户
                     ''     ,--财政拨款文号
                     YAB380 ,--困难企业标志
                     '1'    ,--医疗一次性补充资金缴纳认定
                     PKG_Constant.YAB003_JBFZX ,--经办分中心
                     ''     ,--税务机构编号
                     ''     ,--一级单位编号
                     AAB030  --税号
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
         prm_ErrorMsg := PRE_ERRCODE || '已经存在该单位管理代码信息!'||PRM_AAB001;
         RETURN;
      END IF;

      --单位管理代码
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

      --单位助记码
 -- v_aab001 := xasi2.PKG_Comm.Fun_Getsequence(NULL,'AAB001');
    /**  IF v_aab001 IS NULL OR v_aab001 = '' THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号AAB001!';
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
      --专管员信息写入
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



       --单位年审信息

         --获取当前年度
         SELECT TO_NUMBER(TO_CHAR(SYSDATE,'yyyy'))
           INTO n_aae001
           FROM dual;

         --获取年审年度
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
                   prm_ErrorMsg := '获取年审参数错误'|| SQLERRM||dbms_utility.format_error_backtrace  ;
                   RETURN;
         END;

         --如果当前年度大于年审年度
         IF n_aae001 > n_aae001_aa35 THEN
            n_aae001_ab05 := n_aae001_aa35;
         ELSIF n_aae001 = n_aae001_aa35 THEN
            --如果年审开始时间小于当前时间
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

      --单位社会保险写入
      /*咨询后再写 ab02 ,ab06*/
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
            v_aab033 := '04'  ;   --社保征收
         END IF;
         --20141103 添加0409-0.2%缴费比例（机关事业，基金会，会计，律师事务所的aab019='80'）
         IF t_cols(i).COL_VALUE = '04' AND v_aaa040 = '0401' AND v_aab019 = '80' THEN
             v_aaa040 := '0409';
         END IF ;
         IF t_cols(i).COL_VALUE = '04' AND (v_aab019 = '20' OR v_aab019 = '30') THEN
             v_aaa040 := '0409';
         END IF ;
         --单位参保信息
         INSERT INTO xasi2.ab02(
                        AAB001  ,-- 单位编号     -->
                        AAE140  ,-- 险种类型     -->
                        AAB050  ,-- 单位参保日期 -->
                        YAE097  ,-- 最大做账期号 -->
                        AAB051  ,-- 参保状态     -->
                        AAA040  ,-- 比例类别     -->
                        AAB033  ,-- 征收方式     -->
                        YAB139  ,-- 参保所属分中心 -->
                        aae042  ,--工资年审截止期
                        /*YAB534  ,-- 缴费开户银行类别 -->
                        AAB024  ,-- 缴费开户银行 -->
                        AAB025  ,-- 缴费银行户名 -->
                        AAB026  ,-- 缴费银行基本账号 -->
                        YAB535  ,-- 支付开户银行行类别 -->
                        AAB027  ,-- 支付开户银行 -->
                        AAB028  ,-- 支付银行户名 -->
                        AAB029  ,-- 支付银行基本账号 -->*/
                        AAE011  ,-- 经办人       -->
                        AAE036  ,-- 经办时间     -->
                        YAB003  ,-- 社保经办机构 -->
                        AAE013   -- 备注         -->
                      )
                 SELECT AAB001  ,-- 单位编号     -->
                        t_cols(i).COL_VALUE  ,-- 险种类型     -->
                        AAE036  ,-- 单位参保日期 -->
                      --  to_number(to_char(add_months(AAE036,-1),'yyyyMM'))  ,-- 最大做账期号 -->
                         to_number(to_char(add_months(AAE036,0),'yyyyMM'))  ,-- 最大做账期号 -->
                        '1'  ,-- 参保状态     -->
                        v_aaa040  ,-- 比例类别     -->
                        v_aab033  ,-- 征收方式     -->
                        PKG_Constant.YAB003_JBFZX,-- 参保所属分中心 -->
                        to_number(to_char(AAE036,'yyyy')||12),
                        /*YAB534  ,-- 缴费开户银行类别 -->
                        AAB024  ,-- 缴费开户银行 -->
                        AAB025  ,-- 缴费银行户名 -->
                        AAB026  ,-- 缴费银行基本账号 -->
                        YAB535  ,-- 支付开户银行行类别 -->
                        AAB027  ,-- 支付开户银行 -->
                        AAB028  ,-- 支付银行户名 -->
                        AAB029  ,-- 支付银行基本账号 -->*/
                        AAE011  ,-- 经办人       -->
                        AAE036  ,-- 经办时间     -->
                        PKG_Constant.YAB003_JBFZX,-- 社保经办机构 -->
                        AAE013   -- 备注         -->
                   FROM wsjb.IRAB01
                  WHERE aab001 = iab001
                    and aab001 = prm_aab001;
                    --and IAA002 = PKG_Constant.IAA002_APS;





         --单位险种变更信息
         INSERT INTO xasi2.ab06(
                        yae099 ,-- 业务流水号   -->
                        aab001 ,-- 单位编号     -->
                        aae140 ,-- 险种类型     -->
                        aab100 ,-- 单位变更类型 -->
                        aab101 ,-- 单位变更日期 -->
                        aab102 ,-- 单位变更原因 -->
                        aae013 ,-- 备注         -->
                        aae011 ,-- 经办人       -->
                        aae036 ,-- 经办时间     -->
                        yab003 ,-- 社保经办机构 -->
                        yab139  -- 参保所属分中心 -->
                       )
                 VALUES(
                         prm_yae099 ,-- 业务流水号   -->
                         prm_aab001 ,-- 单位编号     -->
                         t_cols(i).COL_VALUE ,-- 险种类型     -->
                         '1' ,-- 单位变更类型 单位新参保-->
                         sysdate ,-- 单位变更日期 -->
                         '单位新参保' ,-- 单位变更原因 -->
                         '' ,-- 备注         -->
                         prm_aae011 ,-- 经办人       -->
                         sysdate ,-- 经办时间     -->
                         PKG_Constant.YAB003_JBFZX ,-- 社保经办机构 -->
                         PKG_Constant.YAB003_JBFZX  -- 参保所属分中心 -->
                        );
      END LOOP;


             --单位参保信息
           INSERT INTO xasi2.ab02a3(
                        AAB001,    --    单位编号
                        AAB022,     --   单位行业
                        AAA040,     --   缴费类别
                        AAE041,     --   开始时间
                        AAE042,    --   截止时间
                        AAE011,     --   经办人
                        AAE036,     --   经办时间
                        YAB003,    --   经办机构
                        YAE031,     --   审核标志
                        YAE032,     --   审核人
                        YAE033,     --   审核时间
                        AAE120,     --   注销标志
                        AAE013     --    备注


                      )
                 SELECT AAB001,-- 单位编号     -->
                        v_aab022,-- 单位行业
                        aaa040,-- 缴费类别
                        null,-- 单位参保日期 -->
                        null,-- 截止时间
                        AAE011  ,-- 经办人       -->
                        AAE036 ,-- 经办时间     -->
                        YAB003,  -- 社保经办机构 -->
                        '1',  --   审核标志
                       AAE011,  --   审核人
                       AAE036,  --   审核时间
                        null,   --   注销标志
                        AAE013   -- 备注  -->
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
         /*关闭打开的游标*/
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace  ;
         RETURN;
   END prc_AuditSocietyInsuranceREmp;

   /*****************************************************************************
   ** 过程名称 : prc_AuditSocietyInsuranceRPer
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：社会保险登记审核[人员参保]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-24   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_AuditSocietyInsuranceRPer (prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                            prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --单位编码
                                            prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                            prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                            prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                            prm_aae036       IN    irac01.aae036%TYPE ,    --经办时间
                                            prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                            prm_ErrMsg       OUT   VARCHAR2  )    --错误内容

   IS
      var_procNo      VARCHAR2(2);          --过程序号
      num_count       NUMBER;
      num_countc      NUMBER;
      num_aae002      NUMBER;
      var_aae140_01   VARCHAR2(2);         --是否参加了企业养老
      var_aae140_06   VARCHAR2(2);         --是否参加了机关养老
      var_aae140_02   VARCHAR2(2);         --是否参加了失业
      var_aae140_03   VARCHAR2(2);         --是否参加了基本医疗
      var_aae140_04   VARCHAR2(2);         --是否参加了工伤
      var_aae140_05   VARCHAR2(2);         --是否参加了生育
      var_aae140_07   VARCHAR2(2);         --是否参加了大额
      var_aae140_08   VARCHAR2(2);
      rec_irac01      irac01%rowtype   ;
      var_yab136      xasi2.ab01.yab136%TYPE  ;            --单位管理状态
      var_yab279      xasi2.ab01.yab279%TYPE  ;            --医疗一次性补充资金缴纳认定
      var_yac001      VARCHAR2(20);
      var_aac001      xasi2.ac01.aac001%TYPE  ;            --个人编号
      var_aac002      xasi2.ac01.aac002%TYPE  ;            --证件号码
      var_aac003      xasi2.ac01.aac003%TYPE  ;            --姓名
      var_aac004      xasi2.ac01.aac004%TYPE  ;            --性别
      var_yae181      xasi2.ac01.yae181%TYPE  ;            --证件类型
      dat_aac006      xasi2.ac01.aac006%TYPE  ;            --出生时间
      var_aac013      xasi2.ac01.aac013%TYPE  ;            --用工形式
      var_yac067      xasi2.ac01.yac067%TYPE  ;            --来源方式
      var_aac008      xasi2.ac01.aac008%TYPE  ;            --人员状态
      var_aae005      xasi2.ac01.aae005%TYPE  ;            --联系电话
      var_aae006      xasi2.ac01.aae006%TYPE  ;            --地址
--    var_aac013      ac01.aac013%TYPE  ;            --用工形式
--    dat_aac030      ac02.aac030%TYPE  ;            --参保日期
      var_aac031      xasi2.ac02.aac031%TYPE  ;            --个人参保状态
      var_yac505      xasi2.ac02.yac505%TYPE  ;            --参保缴费人员类别
      num_yae097      xasi2.ac02.yae097%TYPE  ;            --个人最大做账期号
      num_yae097_ab02 xasi2.ab02.yae097%TYPE  ;            --单位最大做账期号
      dat_aac007      xasi2.ac01.aac007%TYPE  ;            --参加工作时间
      var_yac503      xasi2.ac02.yac503%TYPE  ;            --工资类型
      num_aac040      xasi2.ac02.aac040%TYPE  ;            --申报工资
      num_yac004      xasi2.ac02.yac004%TYPE  ;            --缴费基数
      num_yaa333      xasi2.ac02.yaa333%TYPE  ;            --账户基数
      var_yac168      xasi2.ac01.yac168%TYPE  ;            --农民工标志
      var_ykb109      xasi2.kc01.ykb109%TYPE  ;            --是否享受公务员统筹待遇
      var_ykc150      xasi2.kc01.ykc150%TYPE  ;            --异地安置标志
      num_aic162      xasi2.kc01.aic162%TYPE  ;            --离退休年月
      dat_ykc174      xasi2.kc01.ykc174%TYPE  ;            --待遇开始时间
      var_akc021      xasi2.kc01.akc021%TYPE  ;            --医疗人员类别
      var_ykc120      xasi2.kc01.ykc120%TYPE  ;            -- 医疗照顾人员类别
      var_aae120      xasi2.ac01.aae120%TYPE  ;            --注销标志
      var_yae099      xasi2.ac05.yae099%TYPE  ;            --业务流水号
      var_aac050      xasi2.ac05.aac050%TYPE  ;            --个人变更类型
      var_yae499      xasi2.ac05.yae499%TYPE  ;            --参保变更原因
      var_yac235      xasi2.ac04a3.yac235%TYPE;            --工资变更类型
      var_yad176      xasi2.ac01k1.yad176%TYPE;            --视同缴费年限类型
      var_aae140      xasi2.ac02.aae140%TYPE  ;            --险种
      var_yab275      xasi2.ab01.yab275%TYPE  ;            --医疗保险执行办法
      dat_aac030      xasi2.ac02.aac030%TYPE  ;            --参保时间
      dat_aac030_05_start  xasi2.ac02.aac030%TYPE  ;       --生育最早参保时间
      var_aac030_05_start  VARCHAR2(20);
      t_cols          tab_change       ;
      var_flag        VARCHAR2(2)      ;             --1:新参保 2:险种新增 3:续保 续保和险种新增都存在已在别单位参保的情况
      var_aab001_o    xasi2.ab01.aab001%TYPE ;
      var_aac031_o    xasi2.ac02.aac031%TYPE ;
      var_yae156      VARCHAR2(6)      ;             --制卡状态
      dat_yae102      DATE;
      dat_sysdate     DATE;


   BEGIN
      --初始化变量
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

      var_aac002 := rec_irac01.aac002 ;             --证件号码
      var_aac003 := rec_irac01.aac003 ;             --姓名
--    dat_aac030 := rec_irac01.aac030 ;             --参保日期
      var_aac004 := rec_irac01.aac004 ;             --性别
      var_yae181 := rec_irac01.yae181 ;             --证件类型
      dat_aac006 := rec_irac01.aac006 ;             --出生日期
--    var_aac013 := rec_irac01.aac013 ;             --用工形式
      var_akc021 := rec_irac01.akc021 ;             --医疗人员类别
      dat_aac007 := rec_irac01.aac007 ;             --参加工作时间
      var_aae005 := rec_irac01.aae005 ;             --联系电话
      var_aae006 := rec_irac01.aae006 ;             --地址
      var_aac008 := rec_irac01.aac008 ;             --人员状态
      var_ykc150 := rec_irac01.ykc150 ;             --驻外标志
      var_yac168 := rec_irac01.yac168 ;             --农民工标志
      var_ykb109 := rec_irac01.ykb109 ;             --是否享受公务员统筹待遇
      var_yac503 := rec_irac01.yac503 ;             --工资类型
      num_aac040 := rec_irac01.aac040 ;             --申报工资
      num_yaa333 := rec_irac01.yaa333 ;             --划账户基数
      num_aic162 := rec_irac01.aic162 ;             --离退休年月
      var_aae140_01 := rec_irac01.aae110;        --是否参加了企业养老
      var_aae140_06 := rec_irac01.aae120;        --是否参加了机关养老
      var_aae140_02 := rec_irac01.aae210;        --是否参加了失业
      var_aae140_03 := rec_irac01.aae310;        --是否参加了基本医疗
      var_aae140_04 := rec_irac01.aae410;        --是否参加了工伤
      var_aae140_05 := rec_irac01.aae510;        --是否参加了生育
      var_aae140_07 := rec_irac01.aae311;        --是否参加了大额
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

      --判断出生日期
      IF LENGTH(var_aac002) = 15 THEN
         dat_aac006 := to_date('19'||substr(var_aac002,7,6),'yymmdd');            --出生日期
      END IF;

      IF LENGTH(var_aac002) = 18 THEN
         dat_aac006 := to_date(substr(var_aac002,7,8),'yyyymmdd');          --出生日期
      END IF;

      --获取人员的编号
      BEGIN
         SELECT aac001
           INTO var_aac001
           FROM xasi2.ac01
          WHERE AAC002 = var_aac002;
         EXCEPTION
         WHEN TOO_MANY_ROWS THEN
            prm_AppCode := gn_def_ERR ;
            prm_ErrMsg  := '存在多个重复的人员信息!';
            RETURN;
         WHEN OTHERS THEN
            --如果不存在个人编号 则生成新的个人编号
            IF var_aac001 IS NULL THEN
               var_aac001 := xasi2.PKG_Comm.fun_GetSequence(NULL,'aac001');           --个人编号
               IF var_aac001 is null THEN
                  prm_AppCode := gn_def_ERR ;
                  prm_ErrMsg  := 'link没有获取到个人编号序列号!';
                  RETURN;
               END IF;
               var_flag := '1'; --标志为新参保
            END IF;
      END;

      var_yac168     := PKG_Constant.YAC168_F;
      var_aae120     := PKG_Constant.AAE120_ZC;
      var_yac067     := PKG_Constant.YAC067_IRPLXCB;

      --新参保：插入个人信息表/单位人员信息表
      IF var_flag = 1 THEN
         INSERT INTO xasi2.ac01(
                        aac001,          -- 个人编号
                        yae181,          -- 证件类型
                        aac002,          -- 身份证号码(证件号码)
                        aac003,          -- 姓名
                        aac004,          -- 性别
                        aac005,
                        aac006,          -- 出生日期
                        aac007,          -- 参加工作日期
                        aac008,          -- 人员状态
                        aac009,
                        aac010,
                        aac012,
                        aac013,
                        aac014,
                        aac015,
                        aac020,
                        yac067,          -- 来源方式
                        yac168,          -- 农民工标志
                        aae004,
                        aae005,          -- 联系电话
                        aae006,          -- 地址
                        aae007,
                        yae222,
                        aae013,
                        aae011,          -- 经办人
                        aae036,          -- 经办时间
                        aae120)          -- 注销标志
               VALUES ( var_aac001,          -- 个人编号
                        var_yae181,          -- 证件类型
                        var_aac002,          -- 身份证号码(证件号码)
                        var_aac003,          -- 姓名
                        var_aac004,          -- 性别
                        rec_irac01.aac005,
                        dat_aac006,          -- 出生日期
                        dat_aac007,          -- 参加工作日期
                        var_aac008,          -- 人员状态
                        rec_irac01.aac009,
                        rec_irac01.aac010,
                        rec_irac01.aac012,
                        var_aac013,
                        rec_irac01.aac014,
                        rec_irac01.aac015,
                        rec_irac01.aac020,
                        var_yac067,          -- 来源方式
                        var_yac168,          -- 农民工标志
                        rec_irac01.aae004,
                        var_aae005,          -- 联系电话
                        var_aae006,          -- 地址
                        rec_irac01.aae007,
                        rec_irac01.yae222,
                        rec_irac01.aae013,
                        prm_aae011,          -- 经办人
                        prm_aae036,          -- 经办时间
                        var_aae120);         -- 注销标志

         var_yac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'YAC001');
         IF var_yac001 is null THEN
            ROLLBACK;
            prm_AppCode := gn_def_ERR ;
            prm_ErrMsg  := '没有获取到单位人员序列号yac001!';
            RETURN;
         END IF;
         INSERT INTO wsjb.irac01a3 (
                        yac001,
                        aac001,          -- 个人编号
                        aab001,
                        yae181,          -- 证件类型
                        aac002,          -- 身份证号码(证件号码)
                        aac003,          -- 姓名
                        aac004,          -- 性别
                        aac005,
                        aac006,          -- 出生日期
                        aac007,          -- 参加工作日期
                        aac008,          -- 人员状态
                        aac009,
                        aac010,
                        aac012,
                        aac013,
                        aac014,
                        aac015,
                        aac020,
                        yac067,          -- 来源方式
                        yac168,          -- 农民工标志
                        aae004,
                        aae005,          -- 联系电话
                        aae006,          -- 地址
                        aae007,
                        yae222,
                        aae013,
                        aac040,
                        yab139,
                        yab013,
                        aae011,          -- 经办人
                        aae036)          -- 经办时间
               VALUES ( var_yac001,
                        var_aac001,          -- 个人编号
                        rec_irac01.aab001,
                        var_yae181,          -- 证件类型
                        var_aac002,          -- 身份证号码(证件号码)
                        var_aac003,          -- 姓名
                        var_aac004,          -- 性别
                        rec_irac01.aac005,
                        dat_aac006,          -- 出生日期
                        dat_aac007,          -- 参加工作日期
                        var_aac008,          -- 人员状态
                        rec_irac01.aac009,
                        rec_irac01.aac010,
                        rec_irac01.aac012,
                        var_aac013,
                        rec_irac01.aac014,
                        rec_irac01.aac015,
                        rec_irac01.aac020,
                        var_yac067,          -- 来源方式
                        var_yac168,          -- 农民工标志
                        rec_irac01.aae004,
                        var_aae005,          -- 联系电话
                        var_aae006,          -- 地址
                        rec_irac01.aae007,
                        rec_irac01.yae222,
                        rec_irac01.aae013,
                        0,
                        PKG_Constant.YAB003_JBFZX,
                        rec_irac01.aab001,
                        prm_aae011,          -- 经办人
                        prm_aae036);         -- 经办时间
      ELSE
         --检查参保单位是否存在该人员信息
         SELECT COUNT(1)
           INTO num_count
           FROM wsjb.IRAC01A3
          WHERE AAC001 = var_aac001
            AND AAB001 = rec_irac01.AAB001;
         IF num_count = 0 THEN
            var_yac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'YAC001');
            IF var_yac001 is null THEN
               prm_AppCode := gn_def_ERR ;
               prm_ErrMsg  := '没有获取到单位人员序列号yac001!';
               RETURN;
            END IF;
            INSERT INTO wsjb.irac01a3 (
                        yac001,
                        aac001,          -- 个人编号
                        aab001,
                        yae181,          -- 证件类型
                        aac002,          -- 身份证号码(证件号码)
                        aac003,          -- 姓名
                        aac004,          -- 性别
                        aac005,
                        aac006,          -- 出生日期
                        aac007,          -- 参加工作日期
                        aac008,          -- 人员状态
                        aac009,
                        aac010,
                        aac012,
                        aac013,
                        aac014,
                        aac015,
                        aac020,
                        yac067,          -- 来源方式
                        yac168,          -- 农民工标志
                        aae004,
                        aae005,          -- 联系电话
                        aae006,          -- 地址
                        aae007,
                        yae222,
                        aae013,
                        aac040,
                        yab139,
                        yab013,
                        aae011,          -- 经办人
                        aae036)          -- 经办时间
               VALUES ( var_yac001,
                        var_aac001,          -- 个人编号
                        rec_irac01.aab001,
                        var_yae181,          -- 证件类型
                        var_aac002,          -- 身份证号码(证件号码)
                        var_aac003,          -- 姓名
                        var_aac004,          -- 性别
                        rec_irac01.aac005,
                        dat_aac006,          -- 出生日期
                        dat_aac007,          -- 参加工作日期
                        var_aac008,          -- 人员状态
                        rec_irac01.aac009,
                        rec_irac01.aac010,
                        rec_irac01.aac012,
                        var_aac013,
                        rec_irac01.aac014,
                        rec_irac01.aac015,
                        rec_irac01.aac020,
                        var_yac067,          -- 来源方式
                        var_yac168,          -- 农民工标志
                        rec_irac01.aae004,
                        var_aae005,          -- 联系电话
                        var_aae006,          -- 地址
                        rec_irac01.aae007,
                        rec_irac01.yae222,
                        rec_irac01.aae013,
                        0,
                        PKG_Constant.YAB003_JBFZX,
                        rec_irac01.aab001,
                        prm_aae011,          -- 经办人
                        prm_aae036);         -- 经办时间
         END IF;
      END IF;

      --更新申报信息的人员编号
      UPDATE wsjb.IRAC01
         SET AAC001 = var_aac001
       WHERE IAC001 = prm_iac001;

      --更新申报明细信息的人员编号
      UPDATE wsjb.IRAD02
         SET IAZ008 = var_aac001
       WHERE IAZ007 = prm_iac001;

      --检查临时表是否有险种数据
      IF t_cols.count < 1 THEN
         ROLLBACK;
         prm_AppCode := gn_def_ERR;
         prm_ErrMsg  := var_aac001 || '没有获得要参保的险种信息！';
         RETURN;
      END IF;

      --参保处理
      FOR i in 1 .. t_cols.count LOOP
         --如果有企业养老，直接略过
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

         --已经参保的险种的检查
         IF var_aab001_o IS NOT NULL AND var_aac031_o IS NOT NULL THEN
            --已经在当前单位参保
            IF var_aab001_o = rec_irac01.aab001 THEN
               IF var_aac031_o = PKG_Constant.AAC031_CBJF THEN
                  GOTO nexaae140;
               ELSE
                  var_flag := '3';
               END IF;
            --其它单位参保
            ELSE
               IF var_aac031_o = PKG_Constant.AAC031_CBJF THEN
                  prm_AppCode := gn_def_ERR;
                  prm_ErrMsg  := '编码为['||var_aac001 || ']人员['||rec_irac01.aac003||']在别的单位'|| var_aab001_o ||'还是参保缴费状态,请等待原单位报减成功后再申报审核！';
                  RETURN;
               ELSE
                  var_flag := '3';
               END IF;
            END IF;
         ELSE
            var_flag := '1'; --新参保险种
         END IF;

         dat_aac030     := NULL;
         var_aae140     := t_cols(i).col_value;     --获得险种
         --工资初始化
         IF var_flag = '3' THEN
            var_yac503     := PKG_Constant.YAC503_SB;      --工资类型
         ELSE
            var_yac503     := rec_irac01.yac503 ;
         END IF;

         num_aac040     := rec_irac01.aac040 ;             --申报工资
         num_yaa333     := rec_irac01.yaa333 ;             --划账户基数
         dat_aac030     := rec_irac01.aac030 ;             --参保时间


         --判断缴费人员类别
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
            --如果险种为生育 控制参保时间 如果早于2006-10-01 则生育的参保时间改为2006-10-01
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

         --var_aac031 := PKG_Constant.AAC031_CBJF;        --参保状态
         --99年后逐月缴费退休人员 生育为终止参保  *****
         /*IF var_zyj = '1' AND var_aae140 = PKG_Constant.AAE140_SYU THEN
            var_aac031  := PKG_Constant.AAC031_ZZCB;      --终止参保
         ELSE
            var_aac031 := PKG_Constant.AAC031_CBJF;       --参保状态
         END IF;
         */
         var_aac031 := PKG_Constant.AAC031_CBJF;       --参保状态
         num_yae097 := TO_NUMBER(TO_CHAR(ADD_MONTHS(dat_aac030,-1),'yyyymm'));   --最大做帐期号

         --判断工资类别
         IF var_yac503 <> PKG_Constant.YAC503_SB AND var_yac503 <> PKG_Constant.YAC503_LRYLJ THEN
            num_aac040 := 0 ;
         END IF;


         BEGIN
             --单位管理状态
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
                prm_ErrMsg  := '单位编码'||prm_aab001||'没有获取到单位基本信息';
                RETURN;
         END;
          --费款所属期
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
                prm_ErrMsg  := '单位编码'||prm_aab001||'险种:'||var_aae140||'没有获取到单位参保信息';
                RETURN;
          END;

          IF var_yab136 = PKG_Constant.YAB136_GT THEN
             num_aae002 := TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE,1),'yyyymm'));
          ELSIF var_yab136 <> PKG_Constant.YAB136_GT THEN
             num_aae002 := TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(num_yae097_ab02,'yyyymm'),1),'yyyymm'));
          END IF;


         --调用保底封顶过程，获取缴费基数和缴费工资
         xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase
                               (var_aac001   ,     --个人编码
                                prm_aab001   ,     --单位编码
                                num_aac040   ,     --缴费工资
                                var_yac503   ,     --工资类别
                                var_aae140   ,     --险种类型
                                var_yac505   ,     --缴费人员类别
                                var_yab136   ,     --单位管理类型（区别独立缴费人员）
                                num_aae002   ,     --费款所属期
                                prm_yab003   ,     --参保分中心
                                num_yac004   ,     --缴费基数
                                prm_AppCode  ,     --错误代码
                                prm_ErrMsg   );    --错误内容
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            prm_ErrMsg := '人员:'||var_aac001||'险种'||var_aae140||'出错，'||prm_ErrMsg ;
            RETURN;
         END IF;

         --判断账户基数
         IF var_yab275 <> PKG_Constant.YAB275_GWY THEN
            num_yaa333 := 0 ;
         END IF;

         --判断缴费基数
         IF var_aae140 = PKG_Constant.AAE140_DEYL THEN
            num_aac040 := 0;
            num_yac004 := 0;
         END IF;

         --新参保增加险种
         IF var_flag = '1' THEN
            IF var_aac008 = PKG_Constant.AAC008_ZZ OR (var_aac008 = PKG_Constant.AAC008_TX) THEN
            --记录ac02
            INSERT INTO xasi2.ac02 (
                              aac001,              -- 个人编号
                              aab001,              -- 单位编号
                              aae140,              -- 险种类型
                              aac031,              -- 个人参保状态
                              yac505,              -- 参保缴费人员类别
                              yac033,              -- 个人初次参保日期
                              aac030,              -- 本系统参保日期
                              yae102,              -- 最后一次变更时间
                              yae097,              -- 最大做账期号
                              yac503,              -- 工资类别
                              aac040,              -- 缴费工资
                              yac004,              -- 缴费基数
                              yaa333,              -- 账户基数
                              yab013,              -- 原单位编号
                              yab139,              --参保所属分中心
                              aae011,              -- 经办人
                              aae036,              -- 经办时间
                              yab003)              -- 社保经办机构
                     VALUES ( var_aac001,              -- 个人编号
                              prm_aab001,              -- 单位编号
                              var_aae140,              -- 险种类型
                              var_aac031,              -- 个人参保状态
                              var_yac505,              -- 参保缴费人员类别
                              dat_aac030,              -- 个人初次参保日期
                              dat_aac030,              -- 本系统参保日期
                              dat_aac030,              -- 最后一次变更时间
                              num_yae097,              -- 最大做账期号
                              var_yac503,              -- 工资类别
                              num_aac040,              -- 缴费工资
                              num_yac004,              -- 缴费基数
                              num_yaa333,              -- 账户基数
                              prm_aab001,              -- 原单位编号
                              prm_yab003,              --参保所属分中心
                              prm_aae011,              -- 经办人
                              prm_aae036,              -- 经办时间
                              prm_yab003);             -- 社保经办机构

            var_aac050 := PKG_Constant.AAC050_XCB ;          --个人变更类型
            var_yae499 := PKG_Constant.YAE499_RYXCB;         --参保变更原因

            /*IF var_aac008 = PKG_Constant.AAC008_ZZ THEN
               var_akc021 := PKG_Constant.AKC021_ZZ ;            --医疗人员类别
            END IF;
            --医疗人员类别
            IF (var_zyj = '1' AND var_aac008 = PKG_Constant.AAC008_TX) OR
                  (var_zyj IS NULL AND var_aac008 = PKG_Constant.AAC008_ZZ) THEN
               var_akc021 := PKG_Constant.AKC021_ZZ ;            --在职
            ELSE
               var_akc021 := PKG_Constant.AKC021_TX ;            --退休
            END IF;*/
            var_akc021 := PKG_Constant.AKC021_ZZ ;            --在职

            --记录ac05
            INSERT INTO xasi2.ac05 (
                              yae099,          -- 业务流水号
                              aac001,          -- 个人编号
                              aab001,          -- 单位编号
                              aae140,          -- 险种类型
                              aac050,          -- 个人变更类型
                              yae499,          -- 参保变更原因
                              aae035,          -- 变更日期
                              yae498,          -- 变更前参保状态
                              aac008,          -- 人员状态
                              yac505,          -- 参保缴费人员类别
                              yab013,          -- 原单位编号
                              yac503,          -- 工资类别
                              aac040,          -- 缴费工资
                              yac004,          -- 缴费基数
                              aae002,          -- 费款所属期
                              aae013,          --备注
                              aae011,          -- 经办人
                              aae036,          -- 经办时间
                              yab139,          -- 参保所属分中心
                              akc021,          -- 医疗人员类别
                              yab003,          -- 社保经办机构
                              aae120,          -- 注销标志
                              yae384,          -- 注销人
                              yae385,          -- 注销时间
                              yae406,          -- 注销原因
                              yae556)          -- 注销经办机构
                       VALUES(prm_yae099,          -- 业务流水号
                              var_aac001,          -- 个人编号
                              prm_aab001,          -- 单位编号
                              var_aae140,          -- 险种类型
                              var_aac050,          -- 个人变更类型
                              var_yae499,          -- 参保变更原因
                              SYSDATE,         -- 变更日期
                              NULL,                -- 变更前参保状态
                              var_aac008,          -- 人员状态
                              var_yac505,          -- 参保缴费人员类别
                              prm_aab001,          -- 原单位编号
                              var_yac503,          -- 工资类别
                              num_aac040,          -- 缴费工资
                              num_yac004,          -- 缴费基数
                              num_aae002,          -- 费款所属期
                              '网上申报批量新参保',
                              prm_aae011,          -- 经办人
                              prm_aae036,          -- 经办时间
                              prm_yab003,          -- 参保所属分中心
                              var_akc021,          -- 医疗人员类别
                              prm_yab003,          -- 社保经办机构
                              var_aae120,          -- 注销标志
                              NULL,          -- 注销人
                              NULL,          -- 注销时间
                              NULL,          -- 注销原因
                              NULL);         -- 注销经办机构


            --记录ac04a3
            var_yac235 := PKG_Constant.YAC235_XCB ;          -- 工资变更类型
            INSERT INTO xasi2.ac04a3 (
                                yae099,          -- 业务流水号
                                aac001,          -- 个人编号
                                aab001,          -- 单位编号
                                aae140,          -- 险种类型
                                yac235,          -- 工资变更类型
                                yac506,          -- 变更前工资
                                yac507,          -- 变更前缴费基数
                                yac514,          -- 变更前划帐户基数
                                aac040,          -- 缴费工资
                                yac004,          -- 缴费基数
                                yaa333,          -- 账户基数
                                aae002,          -- 费款所属期
                                aae013,          -- 备注
                                aae011,          -- 经办人
                                aae036,          -- 经办时间
                                yab003,          -- 社保经办机构
                                yab139,          -- 参保所属分中心
                                yac503,          -- 工资类别
                                yac526)          -- 变更前工资类别
                        VALUES (prm_yae099,          -- 业务流水号
                                var_aac001,          -- 个人编号
                                prm_aab001,          -- 单位编号
                                var_aae140,          -- 险种类型
                                var_yac235,          -- 工资变更类型
                                0,                   -- 变更前工资
                                0,                   -- 变更前缴费基数
                                0,                   -- 变更前划帐户基数
                                num_aac040,          -- 缴费工资
                                num_yac004,          -- 缴费基数
                                num_yaa333,          -- 账户基数
                                num_aae002,          -- 费款所属期
                                '网上申报批量新参保',                -- 备注
                                prm_aae011,          -- 经办人
                                prm_aae036,          -- 经办时间
                                prm_yab003,          -- 社保经办机构
                                prm_yab003,          -- 参保所属分中心
                                var_yac503,          -- 工资类别
                                NULL);               -- 变更前工资类别

            END IF;

            --判断 当险种为基本医疗的时候
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
               --记录kc01
               INSERT INTO xasi2.kc01 (
                                  aac001,            -- 个人编号
                                  aab001,            -- 单位编号
                                  akc021,            -- 医疗人员类别
                                  ykc120,            -- 医疗照顾人员类别
                                  ykb109,            -- 是否享受公务员统筹待遇
                                  aic162,            -- 离退休年月
                                  ykc174,            -- 待遇开始时间
                                  yae497,            -- 医疗待遇相关部门审核标志
                                  yae032,            -- 审核人
                                  ykc150)            -- 异地安置标志
                          VALUES (var_aac001,            -- 个人编号
                                  prm_aab001,            -- 单位编号
                                  var_akc021,            -- 医疗人员类别
                                  var_ykc120,            -- 医疗照顾人员类别
                                  var_ykb109,            -- 是否享受公务员统筹待遇
                                  num_aic162,            -- 离退休年月
                                  dat_ykc174,            -- 待遇开始时间
                                  NULL,                  -- 医疗待遇相关部门审核标志
                                  NULL,                  -- 审核人
                                  var_ykc150);            -- 异地安置标志

               --记录kc01k1
               INSERT INTO xasi2.kc01k1 (
                                   yae099,             -- 业务流水号
                                   aac001,             -- 个人编号
                                   aab001,             -- 单位编号
                                   akc021,             -- 医疗人员类别
                                   ykc120,             -- 医疗照顾人员类别
                                   ykb109,             -- 是否享受公务员统筹待遇
                                   aic162,             -- 离退休年月
                                   ykc174,             -- 待遇开始时间
                                   yae497,             -- 医疗待遇相关部门审核标志
                                   yae032,             -- 审核人
                                   aae011,             -- 经办人
                                   aae036,             -- 经办时间
                                   yab003,             -- 社保经办机构
                                   aae013,             -- 备注
                                   aae120,             -- 注销标志
                                   yae384,             -- 注销人
                                   yae385,             -- 注销时间
                                   yae406,             -- 注销原因
                                   yae556,             -- 注销经办机构
                                   ykc150)             -- 异地安置标志
                           VALUES (prm_yae099,             -- 业务流水号
                                   var_aac001,             -- 个人编号
                                   prm_aab001,             -- 单位编号
                                   var_akc021,             -- 医疗人员类别
                                   var_ykc120,             -- 医疗照顾人员类别
                                   var_ykb109,             -- 是否享受公务员统筹待遇
                                   num_aic162,             -- 离退休年月
                                   dat_ykc174,             -- 待遇开始时间
                                   NULL,             -- 医疗待遇相关部门审核标志
                                   NULL,             -- 审核人
                                   prm_aae011,             -- 经办人
                                   prm_aae036,             -- 经办时间
                                   prm_yab003,             -- 社保经办机构
                                   NULL,             -- 备注
                                   var_aae120,             -- 注销标志
                                   NULL,             -- 注销人
                                   NULL,             -- 注销时间
                                   NULL,             -- 注销原因
                                   NULL,             -- 注销经办机构
                                   var_ykc150);      -- 异地安置标志
               --检查是否写过办卡库
           /**    SELECT COUNT(1) INTO num_count  FROM xasi2_zs.ab01k2  WHERE aac001 = var_aac001;
               --检查是否属于制卡单位
               SELECT COUNT(1) INTO num_countc FROM xasi2_zs.ab01k3  WHERE aab001 = prm_aab001;
               --曾经已制卡
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
               /*续保处理如下*/
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

               --非工伤险种续保处理
               IF var_aae140 <> PKG_Constant.aae140_GS THEN
                  --插入制卡库中
                /**  IF var_aae140 = PKG_Constant.aae140_JBYL THEN
                     --检查是否写过办卡库
                     SELECT COUNT(1) INTO num_count  FROM xasi2_zs.ab01k2 WHERE aac001 = var_aac001;
                     --检查是否属于制卡单位
                     SELECT COUNT(1) INTO num_countc FROM xasi2_zs.ab01k3 WHERE aab001 = prm_aab001;
                     --曾经已制卡
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
                  --个体单位不能续费非(基本医疗和大额)
                  IF (var_yab136 = PKG_Constant.YAB136_GT AND
                      var_aae140 NOT IN (PKG_Constant.aae140_JBYL,PKG_Constant.AAE140_DEYL)) THEN
                      GOTO nexaae140;
                  END IF;
                  BEGIN
                     --更新ac02
                     UPDATE xasi2.ac02
                        SET yae102 = dat_yae102,
                            aac031 = PKG_Constant.AAC031_CBJF,
                            aab001 = prm_aab001,
                            aac040 = rec_irac01.aac040,
                            yac004 = case WHEN var_aae140 = PKG_Constant.AAE140_DEYL THEN 0 ELSE num_yac004 END,
                            yac503 = var_yac503,
                            YAA333 = case WHEN var_aae140 = PKG_Constant.AAE140_DEYL THEN 0 ELSE num_yaa333 END, --账户基数
                            yab139 = prm_yab003
                      WHERE aac001 = var_aac001
                        AND aae140 = var_aae140
                        AND aac031 = PKG_Constant.AAC031_ZTJF--这里不带单位编码，不支持一个人的多份同险种参保关系
                        ;

                  EXCEPTION
                     WHEN OTHERS THEN
                        prm_AppCode := gn_def_ERR;
                        prm_ErrMsg  := '个人增加续保更新个人参保信息表出错,出错原因:个人编号：'||var_aac001||' 险种：'||var_aae140||'单位编号：'||prm_aab001||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
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
                           prm_ErrMsg  := '个人批量续保系统出错,出错原因:个人编号：'||var_aac001||'没有找到KC01中参保数据！';
                           RETURN;
                     END;
                     --更新KC01中的单位编号
                     UPDATE xasi2.kc01
                        SET aab001 = prm_aab001
                      WHERE aac001 = var_aac001;
                     --kc01k1记录变更后值，ac05记录变更前值
                     INSERT INTO xasi2.kc01k1(yae099,  --业务流水号
                                          aac001,  --个人编号
                                          aab001,  --单位编号
                                          akc021,  --医疗人员类别
                                          ykc120,  --医疗照顾人员类别
                                          ykb109,  --是否享受公务员统筹待遇
                                          aic162,  --离退休时间
                                          ykc174,  --待遇开始年月
                                          yae497,  --医疗待遇相关部门审核标志
                                          yae032,  --审核人
                                          yae033,  --审核时间
                                          aae011,  --经办人
                                          aae036,  --经办时间
                                          yab003,  --社保经办机构
                                          aae013,  --备注
                                          aae120,  --注销标志
                                          yae384,  --注销人
                                          yae385,  --注销时间
                                          yae406,  --注销原因
                                          yae556)  --注销经办机构
                          SELECT prm_yae099,  --业务流水号
                                 aac001,  --个人编号
                                 aab001,  --单位编号
                                 akc021,  --医疗人员类别
                                 ykc120,  --医疗照顾人员类别
                                 ykb109,  --是否享受公务员统筹待遇
                                 aic162,  --离退休时间
                                 ykc174,  --待遇开始年月
                                 yae497,  --医疗待遇相关部门审核标志
                                 yae032,  --审核人
                                 yae033,  --审核时间
                                 prm_aae011,  --经办人
                                 dat_sysdate,  --经办时间
                                 prm_yab003,   --社保经办机构
                                 '单位编码变更更新',  --备注
                                 NULL,  --注销标志
                                 NULL,  --注销人
                                 NULL,  --注销时间
                                 NULL,  --注销原因
                                 NULL   --注销经办机构
                    FROM xasi2.kc01
                   WHERE aac001 = var_aac001
                  ;
                  END IF;
               ELSE
                  --工伤险种续保处理 只有工伤的情况
                  --个体单位不能续费非(基本医疗和大额)
                  IF (var_yab136 = PKG_Constant.YAB136_GT AND
                      var_aae140 NOT IN (PKG_Constant.aae140_JBYL,PKG_Constant.AAE140_DEYL)) THEN
                      GOTO NEXAAE140;
                  END IF;
                  --记录工伤险种ac02
                  INSERT INTO xasi2.ac02 (
                                    aac001,              -- 个人编号
                                    aab001,              -- 单位编号
                                    aae140,              -- 险种类型
                                    aac031,              -- 个人参保状态
                                    yac505,              -- 参保缴费人员类别
                                    yac033,              -- 个人初次参保日期
                                    aac030,              -- 本系统参保日期
                                    yae102,              -- 最后一次变更时间
                                    yae097,              -- 最大做账期号
                                    yac503,              -- 工资类别
                                    aac040,              -- 缴费工资
                                    yac004,              -- 缴费基数
                                    yaa333,              -- 账户基数
                                    yab013,              -- 原单位编号
                                    yab139,              --参保所属分中心
                                    aae011,              -- 经办人
                                    aae036,              -- 经办时间
                                    yab003)              -- 社保经办机构
                           VALUES ( var_aac001,              -- 个人编号
                                    prm_aab001,              -- 单位编号
                                    var_aae140,              -- 险种类型
                                    var_aac031,              -- 个人参保状态
                                    var_yac505,              -- 参保缴费人员类别
                                    dat_aac030,              -- 个人初次参保日期
                                    dat_aac030,              -- 本系统参保日期
                                    dat_aac030,              -- 最后一次变更时间
                                    num_yae097,              -- 最大做账期号
                                    var_yac503,              -- 工资类别
                                    num_aac040,              -- 缴费工资
                                    num_yac004,              -- 缴费基数
                                    num_yaa333,              -- 账户基数
                                    prm_aab001,              -- 原单位编号
                                    prm_yab003,              --参保所属分中心
                                    prm_aae011,              -- 经办人
                                    prm_aae036,              -- 经办时间
                                    prm_yab003);             -- 社保经办机构
               END IF;
               INSERT INTO xasi2.ac04a3(
                                     yae099,          -- 业务流水号
                                     aac001,          -- 个人编号
                                     aab001,          -- 单位编号
                                     aae140,          -- 险种类型
                                     yac235,          -- 工资变更类型
                                     yac506,          -- 变更前工资
                                     yac507,          -- 变更前缴费基数
                                     yac514,          -- 变更前划帐户基数
                                     aac040,          -- 缴费工资
                                     yac004,          -- 缴费基数
                                     yaa333,          -- 账户基数
                                     aae002,          -- 费款所属期
                                     aae013,          -- 备注
                                     aae011,          -- 经办人
                                     aae036,          -- 经办时间
                                     yab003,          -- 社保经办机构
                                     yab139,          -- 参保所属分中心
                                     yac503,          -- 工资类别
                                     yac526)          -- 变更前工资类别
                              VALUES (prm_yae099,          -- 业务流水号
                                     var_aac001,          -- 个人编号
                                     prm_aab001,          -- 单位编号
                                     var_aae140,          -- 险种类型
                                     PKG_Constant.YAC235_XB, -- 工资变更类型
                                     0,                   -- 变更前工资
                                     0,                   -- 变更前缴费基数
                                     0,                   -- 变更前划帐户基数
                                     rec_irac01.aac040,
                                     case WHEN var_aae140 = PKG_Constant.AAE140_DEYL THEN 0 ELSE num_yac004 END,
                                     case WHEN var_aae140 = PKG_Constant.AAE140_DEYL THEN 0 ELSE num_yaa333 END, --账户基数,
                                     TO_NUMBER(TO_CHAR(ADD_MONTHS(dat_yae102,-1),'yyyymm')),          -- 费款所属期
                                     '网上申报人员增加续保',          -- 备注
                                     prm_aae011,          -- 经办人
                                     SYSDATE,          -- 经办时间
                                     prm_yab003,          -- 社保经办机构
                                     prm_yab003,          -- 参保所属分中心
                                     var_yac503,          -- 工资类别
                                     NULL);               -- 变更前工资类别
               --写入ac05
               INSERT INTO xasi2.ac05(
                     yae099,  --业务流水号
                     aac001,  --个人编号
                     aab001,  --单位编号
                     aae140,  --险种类型
                     aac050,  --个人变更类型
                     yae499,  --参保变更原因
                     aae035,  --变更日期
                     yae498,  --变更前参保状态
                     aac008,  --人员状态
                     yac505,  --参保缴费人员类别
                     yab013,  --原单位编号
                     yac503,  --工资类别
                     aac040,  --缴费工资
                     yac004,  --缴费基数
                     aae002,  --费款所属期
                     aae013,  --备注
                     aae011,  --经办人
                     aae036,  --经办时间
                     yab139,  --参保所属分中心
                     aae120,  --注销标志
                     akc021,  --医疗人员类别
                     yab003,  --社保经办机构
                     yae384,  --注销人
                     yae385,  --注销时间
                     yae406)  --注销原因
               VALUES(prm_yae099,
                      var_aac001,
                      prm_aab001  ,
                      var_aae140  ,
                      PKG_Constant.AAC050_XB,
                      NULL,
                      dat_yae102,
                      PKG_Constant.AAC031_ZTJF,
                      var_aac008,
                      var_yac505,   --参保缴费人员类别
                      var_aab001_o,     --原单位编号
                      var_yac503,   --工资类别
                      case WHEN var_aae140 = PKG_Constant.AAE140_DEYL THEN 0 ELSE num_aac040 END,   --缴费工资
                      case WHEN var_aae140 = PKG_Constant.AAE140_DEYL THEN 0 ELSE num_yac004 END,   --缴费基数
                      num_yae097,            --费款所属期
                      rec_irac01.aae013,       --备注
                      prm_aae011,            --经办人
                      dat_sysdate,           --经办时间
                      prm_yab003,            --原参保所属分中心
                      PKG_Constant.AAE120_ZC,    --注销标志
                      var_akc021,            --医疗人员类别
                      prm_yab003,            --社保经办机构
                      NULL,                  --注销人
                      NULL,                  --注销时间
                      NULL )                 --注销原因
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
           prm_ErrMsg  := '单位编码'||prm_aab001||'身份证号码:'||var_aac002||'进行人员参保处理出错，错误原因为：'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
           RETURN;
   END prc_AuditSocietyInsuranceRPer;

   /*****************************************************************************
   ** 过程名称 : prc_MonthInternetRegister
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_iaa011       IN     iraa02.iaa011%TYPE,--业务类型
   **           prm_iaa003       IN     iraa02.iaa003%TYPE,--业务主体
   **           prm_iaa100       IN     irad01.iaa100%TYPE,--申报月度
   **           prm_aae011       IN     irad01.aae011%TYPE,--经办人
   **           prm_Flag      OUT    VARCHAR2    ,
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-12   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_MonthInternetRegister (
      prm_iaa011       IN     iraa02.iaa011%TYPE,--业务类型
      prm_iaa003       IN     iraa02.iaa003%TYPE,--业务主体
      prm_iaa100       IN     irad01.iaa100%TYPE,--申报月度
      prm_aae011       IN     irad01.aae011%TYPE,--经办人
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
     n_count_reduce  NUMBER(6);--减少人员数
     n_count_all     NUMBER(6);--所有申报人员数
     n_rate          NUMBER(6,2);--减少率
     count_month        number; --是否是新开户单位
     n_account_loginid   number;--是否使用新系统单位
     prm_yae099        Varchar2(20);
     var_sysmonth      varchar2(15);
     var_sysnexmonth   varchar2(15);
     var_yae097        varchar2(15);
     var_yae097nex     varchar2(15);
     var_yae102      date;
      var_aab019       ab01.aab019%TYPE;       --单位类型  主要区分个体工伤户  20191101 yujj

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
      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;
      num_yac004   := 0;
      v_aab001     := NULL;
      n_count_reduce := 0;--减少人员数
      n_count_all    := 0;--所有申报人员数
      n_rate         := 0;--减少率
      prm_yae099     := '';

      /*必要的数据校验*/
      IF prm_iaa011 IS NULL THEN
         prm_ErrorMsg := '业务类型不能为空!';
         RETURN;
      END IF;

      IF prm_iaa003 IS NULL THEN
         prm_ErrorMsg := '业务主体不能为空!';
         RETURN;
      END IF;

      IF prm_iaa100 IS NULL THEN
         prm_ErrorMsg := '申报月度不能为空!';
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
            prm_ErrorMsg := '单位专管员信息无效，请联系管理人员!';
            RETURN;
      END;

       FOR rec_yae102 in cur_yae102 LOOP
        --往月未提交的减少 更新变更时间
        IF rec_yae102.yae102 < sysdate THEN
          update wsjb.irac01
             set yae102 = sysdate
           where iac001 = rec_yae102.iac001;
        END IF;
        --当月续保,当月减少的人员 AC02 YAE102更新成当月最后一天 停保最多是当月最后一天,
        -- 先更一次 否则市上批量停保校验不能通过
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
        2013-08-30修改，新开户单位在批准月报时已经确定yae097
        新单位最大做账期号问题
        检查是否存在参保人员[无论是否暂停]
        不存在则修改单位最大做账期号

      SELECT count(1)
        INTO n_count
        FROM AC02 a
       WHERE a.aab001 = v_aab001;
      IF n_count = 0 THEN
         --不存在参保人员[是新开户单位]
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
        写入正常参保人员的申报基础信息
      */
      --判断是否为单养老
      SELECT count(1)
        INTO num_count2
        FROM xasi2.AB02
       WHERE aab001 = v_aab001
         AND aab051 = '1';
      IF num_count2 > 0 THEN
      INSERT INTO wsjb.IRAC01
             (iac001, -- 申报人员信息编号
              iaa001, -- 申报人员类别
              iaa002, -- 申报状态
              aac001, -- 个人编号
              aab001, -- 单位编号
              aac002, -- 身份证号码(证件号码)
              aac003, -- 姓名
              aac004, -- 性别
              aac005, -- 民族
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
              yab139, -- 参保所属分中心
              yab013, -- 原单位编号
              aae011, -- 经办人
              aae036, -- 经办时间
              aac040, -- 申报工资
              yac005, --其他基数
              yac004, --养老基数
              aae110, -- 企业养老
              aae120, -- 机关养老
              aae210, -- 失业
              aae310, -- 医疗
              aae410, -- 工伤
              aae510, -- 生育
              aae311, -- 大病
              iaa100)
      SELECT TO_CHAR(seq_iac001.nextval ) iac001, -- 申报人员信息编号
             PKG_Constant.IAA001_GEN iaa001, -- 正常参保人员
             PKG_Constant.IAA002_WIR iaa002, -- 待申报,
             p.aac001,p.aab001,
             p.aac002,p.aac003,p.aac004,p.aac005,p.aac006,p.aac007,p.aac008,p.aac009,p.aac011,
             p.aac013,p.aac014,p.aac015,p.aac020,p.yac168,p.yab139,p.aab001 as yab013,p.aae011,p.aae036,
             p.aac040,decode(p.aae310,'0',p.yac005_,'2',p.yac005) yac005,to_number(NVL(TRIM(p.yac004_1),p.yac004_2)) AS yac004,p.aae110,p.aae120,p.aae210,p.aae310,p.aae410,p.aae510,p.aae311,prm_iaa100
        FROM
     (SELECT a.aac001, -- 个人编号
             b.aab001, -- 单位编号
             a.aac002, -- 身份证号码(证件号码)
             a.aac003, -- 姓名
             a.aac004, -- 性别
             a.aac005, -- 民族
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
             a.aae011, -- 经办人
             a.aae036, -- 经办时间
             sum(case when b.aae140 = '03' then b.aac040 else 0 end) as aac040, -- 申报工资
             sum(case when b.aae140 = '03' then b.yac004 else 0 end) as yac005, -- 申报工资
             sum(case when b.aae140 = '04' then b.yac004 else 0 end) as yac005_, -- 工伤的缴费基数
             (select yac004 from wsjb.irac01a3  where aac001 = a.aac001 and aab001 = v_aab001 and aae110 = '2') as yac004_1, --企业养老基数
             (select yac004 from xasi2.ac02 where aac001 = a.aac001 and aab001 = v_aab001 and aae140 = '06' and aac031 = '1') as yac004_2,--机关养老基数
             (select aae110 from wsjb.irac01a3  where aac001 = a.aac001 and aab001 = v_aab001) aae110,             -- 企业养老
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
                         (iac001, -- 申报人员信息编号
                          iaa001, -- 申报人员类别
                          iaa002, -- 申报状态
                          aac001, -- 个人编号
                          aab001, -- 单位编号
                          aac002, -- 身份证号码(证件号码)
                          aac003, -- 姓名
                          aac004, -- 性别
                          aac005, -- 民族
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
                          yab139, -- 参保所属分中心
                          yab013, -- 原单位编号
                          aae011, -- 经办人
                          aae036, -- 经办时间
                          aac040, -- 申报工资
                          yac005, --其他基数
                          yac004, --养老基数
                          aae110, -- 企业养老
                          aae120, -- 机关养老
                          aae210, -- 失业
                          aae310, -- 医疗
                          aae410, -- 工伤
                          aae510, -- 生育
                          aae311, -- 大病
                          iaa100)
                  SELECT TO_CHAR(seq_iac001.nextval) iac001, -- 申报人员信息编号
                         PKG_Constant.IAA001_GEN iaa001, -- 正常参保人员
                         PKG_Constant.IAA002_WIR iaa002, -- 待申报,
                         p.aac001,p.aab001,
                         p.aac002,p.aac003,p.aac004,p.aac005,p.aac006,p.aac007,p.aac008,p.aac009,p.aac011,
                         p.aac013,p.aac014,p.aac015,p.aac020,p.yac168,p.yab139,p.aab001 as yab013,p.aae011,p.aae036,
                         p.aac040,decode(p.aae310,'0',p.yac005_,'2',p.yac005) yac005,to_number(NVL(TRIM(p.yac004_1),p.yac004_2)) AS yac004,p.aae110,p.aae120,p.aae210,p.aae310,p.aae410,p.aae510,p.aae311,prm_iaa100
                    FROM
                 (SELECT a.aac001, -- 个人编号
                         b.aab001, -- 单位编号
                         a.aac002, -- 身份证号码(证件号码)
                         a.aac003, -- 姓名
                         a.aac004, -- 性别
                         a.aac005, -- 民族
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
                         a.aae011, -- 经办人
                         a.aae036, -- 经办时间
                         b.aac040 AS aac040, -- 申报工资
                         0 as yac005, -- 申报工资
                         0 as yac005_, -- 工伤的缴费基数
                         b.yac004 as yac004_1, --企业养老基数
                         0 as yac004_2,--机关养老基数
                         b.aae110 AS aae110,             -- 企业养老
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

      --确定单位人员的企业养老缴费基数
      FOR rec_ac01 IN CUR_AC01 LOOP
         --调用保底封顶过程，获取缴费基数和缴费工资
         IF rec_ac01.AAE110 = '2' AND rec_ac01.yac004 IS NULL THEN
            xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase
                                  (rec_ac01.aac001   ,     --个人编码
                                   rec_ac01.aab001   ,     --单位编码
                                   rec_ac01.aac040   ,     --缴费工资
                                   rec_ac01.yac503   ,     --工资类别
                                   rec_ac01.aae140   ,     --险种类型
                                   '00'                ,     --缴费人员类别
                                   rec_ac01.yab136   ,     --单位管理类型（区别独立缴费人员）
                                   prm_iaa100   ,            --费款所属期
                                   PKG_Constant.YAB003_JBFZX,  --参保分中心
                                   num_yac004   ,     --缴费基数
                                   prm_AppCode  ,     --错误代码
                                   prm_ErrorMsg );    --错误内容
            IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
               ROLLBACK;
               prm_ErrorMsg := '人员:'||rec_ac01.aac001 ||'获取险种养老缴费基数出错，'||prm_ErrorMsg||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
               RETURN;
            END IF;
      BEGIN
         --单位管理状态
        SELECT  aab019
         INTO  var_aab019
         FROM ab01
      WHERE aab001 = rec_ac01.aab001;
      EXCEPTION
     WHEN OTHERS THEN
      prm_ErrorMsg  := '单位编码'||rec_ac01.aab001|| '没有获取到单位基本信息,'||prm_ErrorMsg ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
      RETURN;
   END;
        --判断个体工商户
               --判断个体工商户---  20191101  yujj
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

         --调用保底封顶过程，获取缴费基数和缴费工资
         IF rec_ac01.AAE310 = '2' AND rec_ac01.yac005 IS NULL THEN
            xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase
                                  (rec_ac01.aac001   ,     --个人编码
                                   rec_ac01.aab001   ,     --单位编码
                                   rec_ac01.aac040   ,     --缴费工资
                                   rec_ac01.yac503   ,     --工资类别
                                   PKG_Constant.AAE140_JBYL, --险种类型
                                   '00'                ,     --缴费人员类别
                                   rec_ac01.yab136   ,     --单位管理类型（区别独立缴费人员）
                                   prm_iaa100   ,            --费款所属期
                                   PKG_Constant.YAB003_JBFZX,  --参保分中心
                                   num_yac004   ,     --缴费基数
                                   prm_AppCode  ,     --错误代码
                                   prm_ErrorMsg );    --错误内容
            IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
               ROLLBACK;
               prm_ErrorMsg := '人员:'||rec_ac01.aac001 ||'获取医疗险种缴费基数出错，'||prm_ErrorMsg ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
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
        月度缴费申报
      */
      --是否存在相同的审核级次
      SELECT COUNT(1)
        into n_count
        FROM wsjb.IRAA02
       WHERE iaa011 = PKG_Constant.IAA011_MIR
         AND iaa005 = PKG_Constant.IAA005_YES;
      IF n_count > 1 THEN
         ROLLBACK;
         prm_ErrorMsg := '月申报系统审核级次信息有误!请联系维护人员';
         RETURN;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
      IF  v_aaz002 IS NULL OR v_aaz002 = ''  THEN
         ROLLBACK;
         prm_ErrorMsg := '没有获取到序列号AAZ002';
         RETURN;
      END IF;

      --日志记录
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
         prm_ErrorMsg := '没有获取到审核级次信息';
         RETURN;
      END;

      IF v_iaz004 IS NULL THEN
         /*获取序列号*/
         v_iaz004 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ004');
         IF v_iaz004 IS NULL OR v_iaz004 = '' THEN
            ROLLBACK;
            prm_ErrorMsg := '没有获取到序列号IAZ004';
            RETURN;
         END IF;

        --申报事件
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

      --写入单位下人员信息申报明细

       v_iac002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');
         IF v_iac002 IS NULL OR v_iac002 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '没有获取到序列号IAC002';
         END IF;

      FOR cur_result in c_cur LOOP
         v_aac003 := cur_result.aac003;
         v_iac001 := cur_result.iac001;

         v_aac001 := cur_result.aac001;
         IF v_aac001 IS NULL OR v_aac001 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '没有获取到人员编号';
         END IF;

         v_iaz005 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');
         IF v_iaz005 IS NULL OR v_iaz005 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '没有获取到序列号IAZ005';
         END IF;

         --获取上次申报明细编号
         SELECT NVL(MAX(IAZ005),v_iaz005)
           INTO v_iaz006
           FROM wsjb.IRAD02
          WHERE IAZ007 = v_iac001;

         --插入人员申报明细
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

              --插入人员增减明细
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

         --更改人员申报状态
         UPDATE wsjb.IRAC01
            SET iaa002 = PKG_Constant.IAA002_AIR
          WHERE iac001 = v_iac001;
      END LOOP;


  /*------------------------MODIFY  BY WHM ON 20190314  START----------------------*/
     --获取单位当前最大做账期
    IF num_count2 > 0 THEN      --一般单位做账期号
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
        prm_ErrorMsg  := prm_ErrorMsg || '获取最大做账期号出错！';
       prm_AppCode  :=  gn_def_ERR;
        GOTO leb_suss;
      END IF;
    ELSIF num_count2 = 0 THEN    --单养老单位做账期号
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


   IF var_yae097 =  var_sysmonth THEN  --最大做账期号=当前自然月
     prm_Flag:= '0';
   /*---------------SIGN 月报循环提交不核定 START---------------*/
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

        IF n_count > 0 THEN  --n_count 申报人数
           DELETE FROM wsjb.IRAD22_TMP ;
           INSERT INTO wsjb.IRAD22_TMP
                 (IAC001,   --申报人员信息编号,VARCHAR2
                                  AAC001,   --个人编号,VARCHAR2
                                  AAB001,   --单位编号,VARCHAR2
                                  AAC002,   --公民身份号码,VARCHAR2
                                  AAC003,   --姓名,VARCHAR2
                                  IAA001,   --人员类别
                                  IAZ005,   --申报明细ID
                                  IAA003)    --业务主体
                          SELECT a.IAC001, --申报人员信息编号,VARCHAR2
                                 a.AAC001, --个人编号,VARCHAR2
                                 a.AAB001, --单位编号,VARCHAR2
                                 a.AAC002, --公民身份号码,VARCHAR2
                                 a.AAC003, --姓名,VARCHAR2
                                 a.IAA001, --人员类别
                                 b.IAZ005, --申报明细ID
                                 '2' IAA003  --业务主体
                            FROM wsjb.IRAC01  a,wsjb.IRAD02  b,wsjb.IRAD01  c
                           WHERE a.iac001 = b.iaz007
                             and b.iaz004 = c.iaz004
                             and c.aab001 = v_aab001
                             and a.iaa001 IN ('1','2','3','5','6','7','8')
                             and c.iaa011 = PKG_Constant.IAA011_MIR  --A04
                             and a.iaa002 = PKG_Constant.IAA002_AIR  --1 已申报
                             and c.iaa100 = prm_iaa100;
           IF num_count2 > 0 THEN  --有AB02的单位
             --月申报审核通过
             PKG_Insurance.prc_AuditMonthInternetR(PKG_Constant.IAA011_MIR,  --A04
                                                   PKG_Constant.IAA003_PER,  --2 个人
                                                   PKG_Constant.IAA018_PAS,  --1 通过
                                                   '1',--审核通过
                                                   prm_aae011,
                                                   '1' , --全部
                                                   prm_AppCode,
                                                   prm_ErrorMsg);
             IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                prm_AppCode  :=  gn_def_ERR;
                prm_ErrorMsg := '调用月申报审核过程prc_AuditMonthInternetR出错:' ||prm_ErrorMsg||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                RETURN;
             END IF;
           ELSE  --没有AB02 就是单养老单位
            --月申报审核通过 (单养老)
             PKG_Insurance.prc_YLAuditMonth(PKG_Constant.IAA011_MIR,  --A04
                                            PKG_Constant.IAA003_PER,  --2 个人
                                            PKG_Constant.IAA018_PAS,  --1 通过
                                             '1',--审核通过
                                             prm_aae011,
                                             '1' , --全部
                                             prm_AppCode,
                                             prm_ErrorMsg
                                             );
             IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                prm_AppCode  :=  gn_def_ERR;
                prm_ErrorMsg := '调用月申报审核过程prc_YLAuditMonth出错:' ||prm_ErrorMsg||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                RETURN;
             END IF;
           END IF;
        END IF;

            PKG_Insurance.prc_insertAC29(
                              v_aab001, --单位助记码
                               prm_iaa100  ,
                               prm_aae011, --经办人
                               prm_AppCode, --错误代码
                               prm_ErrorMsg); --错误内容
                IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                prm_AppCode  :=  gn_def_ERR;
                prm_ErrorMsg := '调用制卡过程prc_insertAC29出错:' ||prm_ErrorMsg||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                RETURN;
             END IF;
   /*----------------------SIGN 月报循环提交不核定 END----------------------*/

   ELSIF  var_yae097 <  var_sysmonth  THEN--最大做账期号<当前自然月
   prm_Flag:= '1';
   /*-----------------------------SIGN  原有  START---------------------------*/
     /**
     月度缴费申报的审核[仅针对已申报减少参保人员，减少人员率小于70%，自动审核通过]
     **/
     --查询减少人员率小于100%，自动审核通过
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
     --加上对使用新系统单位的判断 在tauser表中表示使用新单位，减少直接审核有效
     SELECT COUNT(1)
       INTO n_account_loginid
       FROM xagxwt.tauser
      WHERE LOGINID = v_aab001
        AND EFFECTIVE = '0';

     IF n_account_loginid > 0 THEN
       IF n_rate < 100 THEN
         --新系统上线后放开注释 20160325
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

         --存在减少参保人员
         IF n_count > 0 THEN
           DELETE FROM wsjb.IRAD22_TMP;
           INSERT INTO wsjb.IRAD22_TMP
             (IAC001, --申报人员信息编号,VARCHAR2
              AAC001, --个人编号,VARCHAR2
              AAB001, --单位编号,VARCHAR2
              AAC002, --公民身份号码,VARCHAR2
              AAC003, --姓名,VARCHAR2
              IAA001, --人员类别
              IAZ005, --申报明细ID
              IAA003) --业务主体
             SELECT a.IAC001, --申报人员信息编号,VARCHAR2
                    a.AAC001, --个人编号,VARCHAR2
                    a.AAB001, --单位编号,VARCHAR2
                    a.AAC002, --公民身份号码,VARCHAR2
                    a.AAC003, --姓名,VARCHAR2
                    a.IAA001, --人员类别
                    b.IAZ005, --申报明细ID
                    '2' IAA003 --业务主体
               FROM wsjb.IRAC01 a, wsjb.IRAD02 b, wsjb.IRAD01 c
              WHERE a.iac001 = b.iaz007
                and b.iaz004 = c.iaz004
                and c.aab001 = v_aab001
                and a.iaa001 IN ('3', '7', '9', '10')
                and c.iaa011 = PKG_Constant.IAA011_MIR
                and a.iaa002 = PKG_Constant.IAA002_AIR
                and c.iaa100 = prm_iaa100;
           IF num_count2 > 0 THEN
             --月申报审核通过
             PKG_Insurance.prc_AuditMonthInternetR(PKG_Constant.IAA011_MIR,
                                                   PKG_Constant.IAA003_PER,
                                                   PKG_Constant.IAA018_PAS,
                                                   '1', --审核通过
                                                   prm_aae011,
                                                   '1', --全部
                                                   prm_AppCode,
                                                   prm_ErrorMsg);
             IF prm_AppCode <> gn_def_OK THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := '调用月申报审核过程prc_AuditMonthInternetR出错:' ||
                               prm_ErrorMsg ||
                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
               RETURN;
             END IF;
           ELSE
             --月申报审核通过 (单养老)
             PKG_Insurance.prc_YLAuditMonth(PKG_Constant.IAA011_MIR,
                                            PKG_Constant.IAA003_PER,
                                            PKG_Constant.IAA018_PAS,
                                            '1', --审核通过
                                            prm_aae011,
                                            '1', --全部
                                            prm_AppCode,
                                            prm_ErrorMsg);
             IF prm_AppCode <> gn_def_OK THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := '调用月申报审核过程prc_YLAuditMonth出错:' || prm_ErrorMsg ||
                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
               RETURN;
             END IF;
           END IF;
         END IF;
       END IF;
     END IF;
     /**
             prc_MonthInternetRegister
             月度缴费申报的审核[仅针对已申报正常参保人员]
           */

     SELECT COUNT(1)
       INTO n_count
       FROM wsjb.IRAC01 a, wsjb.IRAD02 b, wsjb.IRAD01 c
      WHERE a.iac001 = b.iaz007
        and b.iaz004 = c.iaz004
        and c.aab001 = v_aab001
        AND a.iaa001 = '2' --新系统上线把下一行取消注释本行注释 20160516
           --and a.iaa001 IN ('2','3','7','9','10')
        and c.iaa011 = PKG_Constant.IAA011_MIR
        and a.iaa002 = PKG_Constant.IAA002_AIR
        and c.iaa100 = prm_iaa100;

     --存在已申报正常参保人员
     IF n_count > 0 THEN
       DELETE FROM wsjb.IRAD22_TMP;
       INSERT INTO wsjb.IRAD22_TMP
         (IAC001, --申报人员信息编号,VARCHAR2
          AAC001, --个人编号,VARCHAR2
          AAB001, --单位编号,VARCHAR2
          AAC002, --公民身份号码,VARCHAR2
          AAC003, --姓名,VARCHAR2
          IAA001, --人员类别
          IAZ005, --申报明细ID
          IAA003) --业务主体
         SELECT a.IAC001, --申报人员信息编号,VARCHAR2
                a.AAC001, --个人编号,VARCHAR2
                a.AAB001, --单位编号,VARCHAR2
                a.AAC002, --公民身份号码,VARCHAR2
                a.AAC003, --姓名,VARCHAR2
                a.IAA001, --人员类别
                b.IAZ005, --申报明细ID
                '2' IAA003 --业务主体
           FROM wsjb.IRAC01 a, wsjb.IRAD02 b, wsjb.IRAD01 c
          WHERE a.iac001 = b.iaz007
            and b.iaz004 = c.iaz004
            and c.aab001 = v_aab001
            AND a.iaa001 = '2' --新系统上线把下一行取消注释本行注释 20160516
               -- and a.iaa001 IN ('2','3','7','9','10')
            and c.iaa011 = PKG_Constant.IAA011_MIR
            and a.iaa002 = PKG_Constant.IAA002_AIR
            and c.iaa100 = prm_iaa100;
       IF num_count2 > 0 THEN
         --月申报审核通过
         PKG_Insurance.prc_AuditMonthInternetR(PKG_Constant.IAA011_MIR,
                                               PKG_Constant.IAA003_PER,
                                               PKG_Constant.IAA018_PAS,
                                               '1', --审核通过
                                               prm_aae011,
                                               '1', --全部
                                               prm_AppCode,
                                               prm_ErrorMsg);
         IF prm_AppCode <> gn_def_OK THEN
           ROLLBACK;
           prm_AppCode  := gn_def_ERR;
           prm_ErrorMsg := '调用月申报审核过程prc_AuditMonthInternetR出错:' ||
                           prm_ErrorMsg ||
                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
           RETURN;
         END IF;
       ELSE
         --月申报审核通过 (单养老)
         PKG_Insurance.prc_YLAuditMonth(PKG_Constant.IAA011_MIR,
                                        PKG_Constant.IAA003_PER,
                                        PKG_Constant.IAA018_PAS,
                                        '1', --审核通过
                                        prm_aae011,
                                        '1', --全部
                                        prm_AppCode,
                                        prm_ErrorMsg);
         IF prm_AppCode <> gn_def_OK THEN
           ROLLBACK;
           prm_AppCode  := gn_def_ERR;
           prm_ErrorMsg := '调用月申报审核过程prc_YLAuditMonth出错:' || prm_ErrorMsg ||
                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
           RETURN;
         END IF;
       END IF;
     END IF;

     --- 月度缴费申报的审核[新参保]
     -- 新系统上线后放开注释 20160325
     --查询irad01 如果只有一条 是新开户 不自动通过
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

         --新参保登记审核通过的直接审核通过
         IF n_count > 0 THEN
           DELETE FROM wsjb.IRAD22_TMP;
           INSERT INTO wsjb.IRAD22_TMP
             (IAC001, --申报人员信息编号,VARCHAR2
              AAC001, --个人编号,VARCHAR2
              AAB001, --单位编号,VARCHAR2
              AAC002, --公民身份号码,VARCHAR2
              AAC003, --姓名,VARCHAR2
              IAA001, --人员类别
              IAZ005, --申报明细ID
              IAA003) --业务主体
             SELECT a.IAC001, --申报人员信息编号,VARCHAR2
                    a.AAC001, --个人编号,VARCHAR2
                    a.AAB001, --单位编号,VARCHAR2
                    a.AAC002, --公民身份号码,VARCHAR2
                    a.AAC003, --姓名,VARCHAR2
                    a.IAA001, --人员类别
                    b.IAZ005, --申报明细ID
                    '2' IAA003 --业务主体
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
             --月申报审核通过
             PKG_Insurance.prc_AuditMonthInternetR(PKG_Constant.IAA011_MIR,
                                                   PKG_Constant.IAA003_PER,
                                                   PKG_Constant.IAA018_PAS,
                                                   '1', --审核通过
                                                   prm_aae011,
                                                   '1', --全部
                                                   prm_AppCode,
                                                   prm_ErrorMsg);
             IF prm_AppCode <> gn_def_OK THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := '调用月申报审核过程prc_AuditMonthInternetR出错:' ||
                               prm_ErrorMsg ||
                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
               RETURN;
             END IF;
           ELSE
             --月申报审核通过 (单养老)
             PKG_Insurance.prc_YLAuditMonth(PKG_Constant.IAA011_MIR,
                                            PKG_Constant.IAA003_PER,
                                            PKG_Constant.IAA018_PAS,
                                            '1', --审核通过
                                            prm_aae011,
                                            '1', --全部
                                            prm_AppCode,
                                            prm_ErrorMsg);
             IF prm_AppCode <> gn_def_OK THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := '调用月申报审核过程prc_YLAuditMonth出错:' || prm_ErrorMsg ||
                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
               RETURN;
             END IF;
           END IF;
         END IF;
       END IF;
     END IF;
     /**
              prc_MonthInternetRegister
              应收核定征集[没有人员增减的月申报，直接应收核定征集，没有增加，只有减少的直接核定征集 新参保也直接核定征集]
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
               --单养老的AC02没有人员参保信息 所以加入这个判断区分是否为单养老单位
               SELECT COUNT(1)
                 INTO N_COUNT1
                 FROM xasi2.AC02 A, wsjb.IRAA01 B
                WHERE A.AAB001 = B.AAB001
                  AND B.YAE092 = PRM_AAE011;
               IF N_COUNT1 = 0 THEN
                 prm_ErrorMsg := '单位没有任何人员参保，不存在可申报的信息!';
                 RETURN;
               ELSE
                 --没有人员增减的月申报，直接应收核定征集
                 PKG_Insurance.prc_checkAndFinaPlan(v_aab001,
                                                    to_number(prm_iaa100),
                                                    '3', --地税征收
                                                    to_number(prm_aae011),
                                                    '1',
                                                    prm_AppCode,
                                                    prm_ErrorMsg);
                 IF prm_AppCode <> gn_def_OK THEN
                   ROLLBACK;
                   prm_AppCode  := gn_def_ERR;
                   prm_ErrorMsg := '调用应收核定征集过程prc_checkAndFinaPlan出错111:' ||
                                   prm_ErrorMsg ||
                                   DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                   RETURN;
                 END IF;


                   -- 免审直接调用制卡过程 20190617 begin
                 PKG_Insurance.prc_insertAC29(
                                 v_aab001, --单位助记码
                                 prm_iaa100  ,
                                 prm_aae011, --经办人
                                 prm_AppCode, --错误代码
                                 prm_ErrorMsg); --错误内容
                  IF prm_AppCode <> gn_def_OK THEN
                  ROLLBACK;
                  prm_AppCode  :=  gn_def_ERR;
                  prm_ErrorMsg := '调用制卡过程prc_insertAC29出错:' ||prm_ErrorMsg||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                  RETURN;
                  END IF;
                    -- 免审直接调用制卡过程 20190617  end
               END IF;
             ELSE
               --没有人员增减的月申报，直接应收核定征集 (单养老)
               PKG_Insurance.prc_checkAndFinaPlan(v_aab001,
                                                  to_number(prm_iaa100),
                                                  '3', --地税征收
                                                  to_number(prm_aae011),
                                                  '1',
                                                  prm_AppCode,
                                                  prm_ErrorMsg);
               IF prm_AppCode <> gn_def_OK THEN
                 ROLLBACK;
                 prm_AppCode  := gn_def_ERR;
                 prm_ErrorMsg := '调用应收核定征集过程prc_checkAndFinaPlan出错:' ||
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
           --单养老的AC02没有人员参保信息 所以加入这个判断区分是否为单养老单位
           SELECT COUNT(1)
             INTO N_COUNT1
             FROM xasi2.AC02 A, wsjb.IRAA01 B
            WHERE A.AAB001 = B.AAB001
              AND B.YAE092 = PRM_AAE011;
           IF N_COUNT1 = 0 THEN
             prm_ErrorMsg := '单位没有任何人员参保，不存在可申报的信息!';
             RETURN;
           ELSE
             --没有人员增减的月申报，直接应收核定征集
             PKG_Insurance.prc_checkAndFinaPlan(v_aab001,
                                                to_number(prm_iaa100),
                                                '3', --地税征收
                                                to_number(prm_aae011),
                                                '1',
                                                prm_AppCode,
                                                prm_ErrorMsg);
             IF prm_AppCode <> gn_def_OK THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := '调用应收核定征集过程prc_checkAndFinaPlan出错111:' ||
                               prm_ErrorMsg ||
                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
               RETURN;
             END IF;
           END IF;
         ELSE
           --没有人员增减的月申报，直接应收核定征集 (单养老)
           PKG_Insurance.prc_checkAndFinaPlan(v_aab001,
                                              to_number(prm_iaa100),
                                              '3', --地税征收
                                              to_number(prm_aae011),
                                              '1',
                                              prm_AppCode,
                                              prm_ErrorMsg);
           IF prm_AppCode <> gn_def_OK THEN
             ROLLBACK;
             prm_AppCode  := gn_def_ERR;
             prm_ErrorMsg := '调用应收核定征集过程prc_checkAndFinaPlan出错:' ||
                             prm_ErrorMsg ||
                             DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
             RETURN;
           END IF;
         END IF;
       END IF;
     END IF;

 /*-----------------------------SIGN  原有  END---------------------------*/
   END IF;
  /*------------------------MODIFY  BY WHM ON 20190314  END----------------------*/


     <<leb_suss>>
      n_count :=0;
      EXCEPTION
      WHEN OTHERS THEN
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END prc_MonthInternetRegister;

    /*****************************************************************************
   ** 过程名称 : prc_AuditMonthInternetR
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_iaa011       IN     iraa02.iaa011%TYPE,--业务类型
   **           prm_iaa003       IN     iraa02.iaa003%TYPE,--业务主体
   **           prm_iaa004       IN     iraa02.iaa011%TYPE,--审核标志
   **           prm_iaa028       IN     VARCHAR2          ,--是否全部
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_aae013       IN     iraa02.aae013%TYPE,--备注
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-29   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_AuditMonthInternetR (
      prm_iaa011       IN     iraa02.iaa011%TYPE,--业务类型
      prm_iaa003       IN     iraa02.iaa003%TYPE,--业务主体
      prm_iaa018       IN     irad22.iaa018%TYPE,--审核标志
      prm_iaa028       IN     VARCHAR2          ,--是否全部
      prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
      prm_aae013       IN     iraa02.aae013%TYPE,--备注
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

      --定义游标，获取批量审核人员信息
      CURSOR cur_tmp_person IS
      SELECT a.IAC001, --申报人员信息编号,VARCHAR2
             b.AAC001, --个人编号,VARCHAR2
             a.AAB001, --单位编号,VARCHAR2
             a.AAC002, --公民身份号码,VARCHAR2
             a.AAC003, --姓名,VARCHAR2
             b.IAA001, --人员类别
             a.IAZ005, --申报明细ID
             a.IAA003  --业务主体
        FROM wsjb.IRAD22_TMP  a,wsjb.IRAC01  b --批量审核人员信息零时表
       WHERE a.iac001 = b.iac001
        ORDER by a.iaa003;

      CURSOR cur_tmp_unit IS
      SELECT distinct aab001
        FROM wsjb.IRAD22_TMP  a;

                -- 单位参保游标
   /* CURSOR cur_canbao_company  IS
      SELECT
        AAB001,
        AAE140
       FROM xasi2.ab02
       WHERE  aab001 = var_aab001 and aab051='1' and aae140<>'07';*/


   BEGIN

      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;

      /*检查临时表是否存在数据*/
      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.IRAD22_TMP ;
      IF n_count = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'审核临时表无可用数据!';
         RETURN;
      END IF;


      /*必要的数据校验*/
      IF prm_iaa011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'业务类型不能为空!';
         RETURN;
      END IF;

      IF prm_iaa003 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'业务主体不能为空!';
         RETURN;
      END IF;

      IF prm_iaa018 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'审核标志不能为空!';
         RETURN;
      END IF;

      IF prm_iaa028 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'标志[是否全部]不能为空!';
         RETURN;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
      IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号AAZ002!';
         RETURN;
      END IF;

      v_iaz009 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ009');
      IF v_iaz009 IS NULL OR v_iaz009 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号IAZ009!';
         RETURN;
      END IF;


    /**  v_yae099 := xasi2.PKG_COMM.FUN_GETSEQUENCE(NULL,'YAE099');
      IF v_yae099 IS NULL OR v_yae099 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号YAE099!';
         RETURN;
      END IF;
      */

      --审核事件
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

         --申报主体是个人时校验：必须单位信息审核通过才能办理
         IF REC_TMP_PERSON.iaa003 = PKG_Constant.IAA003_PER THEN
            SELECT COUNT(1)
              INTO n_count
              FROM wsjb.IRAB01
             WHERE AAB001 = REC_TMP_PERSON.AAB001
               AND IAA002 = PKG_Constant.IAA002_APS;
            IF n_count = 0 THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'单位信息审核通过才能办理人员月申报审核!';
               RETURN;
            END IF;
         END IF;

          /*
            针对人员的信息审核
            可以办理的是打回 通过 不通过 批量通过 全部通过 全不通过
         */

         --审核明细处理
         v_iaz010 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ010');
         IF v_iaz010 IS NULL OR v_iaz010 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号IAZ010!';
            RETURN;
         END IF;

         --查询上次审核情况
         BEGIN
            SELECT IAA015
              INTO v_iaa015
              FROM wsjb.IRAD02
             WHERE IAZ005 = REC_TMP_PERSON.IAZ005;

            IF v_iaa015 in (PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
              prm_ErrorMsg := PRE_ERRCODE ||'审核已经终结!';
              RETURN;
           END IF;

            --提取上次审核信息
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
                                          PKG_Constant.IAA018_DAD, --打回[放弃审核]
                                          PKG_Constant.IAA018_NPS  --不通过 Not Pass
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
                     prm_ErrorMsg := PRE_ERRCODE ||'申报信息处于审核中，但未获取到上次审核信息,请确认上次审核是否终结!';
                     RETURN;
               END;

               v_iaa014 := v_iaa017;
               v_iaa017 := v_iaa017 + 1;
               IF v_iaa017 > v_iaa004 THEN
                  v_iaa017 := v_iaa004;
               END IF;

               --审核级次等于当前级次
               IF v_iaa004 = v_iaa014 AND v_iaa004 = v_iaa017 THEN
                  ROLLBACK;
                  prm_AppCode  := gn_def_ERR;
                  prm_ErrorMsg := PRE_ERRCODE ||'审核已经终结!';
                  RETURN;
               END IF;
            END IF;

            --提取申报明细信息
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
                     prm_ErrorMsg := PRE_ERRCODE ||'没有提取到申报明细信息!';
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
               prm_ErrorMsg := '审核信息提取错误:'|| PRE_ERRCODE || SQLERRM ||dbms_utility.format_error_backtrace ;
               RETURN;
         END;

         --审核明细写入
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
                     IAD005,    --审核意见
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
                     prm_aae013,  --审核意见
                     null
         );

         --打回
         IF prm_iaa018 = PKG_Constant.IAA018_DAD THEN

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_DAD,--打回[修改续报]
                   AAE013 = prm_aae013
             WHERE IAA015 = PKG_Constant.IAA015_WAD --待审
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_ALR  --已打回
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --审核未通过
         IF prm_iaa018 = PKG_Constant.IAA018_NPS THEN

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015  = PKG_Constant.IAA015_ADO, --审核完毕
                   AAE013  = prm_aae013
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --待审/审核中
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_NPS  --未通过
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --审核通过
         IF prm_iaa018 = PKG_Constant.IAA018_PAS AND v_iaa014 = v_iaa004 THEN

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015  =  PKG_Constant.IAA015_ADO --审核完毕
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --待审/审核中
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            v_yae099    := xasi2.PKG_comm.fun_GetSequence(NULL,'yae099');
            IF v_yae099 IS NULL OR v_yae099 = '' THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'没有获取到系统库的序列号:YAE099';
               RETURN;
             END IF;

            IF REC_TMP_PERSON.iaa003 = '2' THEN


               /*
                  人员增加[新参保与批量新参保]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_ADD,PKG_Constant.IAA001_PAD) THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[新参保 续保]
                     老方法 prc_AuditSocietyInsuranceRPer
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
                  人员增加[人员险种新增]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_IAD THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[新参保 续保]
                     老方法 prc_AuditSocietyInsuranceRPer
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
                  人员增加[人员续保]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_CIN THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[新参保 续保]
                     老方法 prc_AuditSocietyInsuranceRPer
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
                  人员减少[人员暂停缴费与批量暂停缴费，退休人员死亡(与暂停雷同)]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_MIN,PKG_Constant.IAA001_PMI,PKG_Constant.IAA001_RPD) THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[停保 退休]
                     老方法 prc_AuditMonthInternetRpause
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
                  人员减少[在职转退休]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_RTR THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[停保 退休]
                     老方法 prc_AuditMonthInternetRpause
                  */
                  --退休申请审核 修改个人状态以及更新参保信息
                  v_yae099 := NULL;

                  BEGIN
                     SELECT MAX(yae099)
                       INTO v_yae099
                       FROM XASI2.ac02_apply
                      WHERE AAC001 = REC_TMP_PERSON.AAC001
                        AND AAB001 = REC_TMP_PERSON.AAB001
                        AND YAE031 = '0'                    --未审核
                        AND AAE120 = '0'
                        AND FLAG   = '3';                   --退休申请
                     EXCEPTION
                      WHEN OTHERS THEN
                          prm_AppCode  :=  gn_def_ERR;
                          prm_ErrorMsg :=  PRE_ERRCODE || '退休申请数据没有获取到!';
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


      -- 调用prc_Ab02a8Unit 单位缴费基数
   /*      prc_Ab02a8Unit(     REC_TMP_PERSON.AAB001,
                                v_yae099,
                                prm_AppCode,
                                prm_ErrorMsg
                                        );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;*/


    -- 生成ab02a8数据
    --获取最大年度

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
          (YAE099, --   业务流水号
           AAB001, --   单位编号
           AAE140, --  险种类型
           AAE041, --   开始期号
           AAE042, --   终止期号
           AAB121, --   单位缴费基数总额
           AAE001, --   年度
           AAE011, --   经办人
           AAE036, --    经办时间
           YAB003, --  社保经办机构
           YAE031, --   审核标志
           YAE032, --   审核人
           YAE033, --   审核时间
           YAE569, --  审核经办机构
           YAB139, --   参保所属分中心
           AAE013 --  备注
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
           set AAB121 = sum_YAC004 --   单位缴费基数总额
         where AAB001 = REC_TMP_PERSON.AAB001
           and AAE140 = REC_CANBAO_COMPANY.AAE140;

      end if;
    end LOOP;
    */



               --2013-03-14 王雷  应该是先进行操作最后更新状态
               --更新申报人员状态
               UPDATE wsjb.irac01
                  SET IAA002 = PKG_Constant.IAA002_APS  --已通过
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;
            --回退相关表
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


      --日志记录
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
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
         RETURN;
   END prc_AuditMonthInternetR;

   /***************************************************************************
   ** 过程称 ：prc_AuditMonthInternetRpause
   ** 过程号 ：
   ** 业务节 ：个人停保
   ** 功能述 ：个人停保
   ****************************************************************************
   ** 参数述 ：参数标识        输入/输出           类型               名称
   ****************************************************************************
   **
   ** 作  者：     作成日期 ：2009-11-26   版本编号 ：Ver 1.0.0
   ****************************************************************************
   ** 修  改：
   ****************************************************************************
   ** 备  注：prm_AppCode 构成是:过程编号（2位） ＋ 顺序号（2位）
   ***************************************************************************/
   --个人停保
   PROCEDURE prc_AuditMonthInternetRpause
                            (prm_yae099       IN    xasi2.ac05.YAE099%TYPE  ,     --业务流水号
                             prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --单位编码
                             prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                             prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                             prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                             prm_aae036       IN    irac01.aae036%TYPE ,    --经办时间
                             prm_AppCode     OUT    VARCHAR2          ,     --执行代码
                             prm_ErrMsg      OUT    VARCHAR2          )     --执行结果
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


      --定义游标，获取退休人员的参保缴费信息
      CURSOR cur_pause_aae140(var_aac001 xasi2.ac01.aac001%TYPE) IS
      SELECT AAC001, --个人编号,VARCHAR2
             AAE140  --险种    ,VARCHAR2
        FROM xasi2.AC02    --参保信息表
       WHERE AAC001 = var_aac001
         AND AAB001 = prm_aab001
         AND AAC031 = PKG_Constant.AAC031_CBJF;

   BEGIN
      /*初化变量*/
      prm_AppCode    := gn_def_OK ;
      prm_ErrMsg     := ''       ;
      dat_sysdate    := SYSDATE;
      num_count      := 0;

      IF prm_yae099 IS NULL THEN
         prm_AppCode := gn_def_ERR;
         prm_ErrMsg  := '业务流水号不能为空！';
         RETURN;
      END IF;

      IF prm_aab001 IS NULL THEN
         prm_AppCode := gn_def_ERR;
         prm_ErrMsg  := '单位编号不能为空！';
         RETURN;
      END IF;

      IF prm_iac001 IS NULL THEN
         prm_AppCode := gn_def_ERR;
         prm_ErrMsg  := '人员编号不能为空！';
         RETURN;
      END IF;

      IF prm_aae011 IS NULL THEN
         prm_AppCode := gn_def_ERR;
         prm_ErrMsg  := '经办人不能为空！';
         RETURN;
      END IF;

      IF prm_yab003 IS NULL THEN
         prm_AppCode := gn_def_ERR;
         prm_ErrMsg  := '经办机构不能为空！';
         RETURN;
      END IF;

      SELECT aae119
        INTO var_aae119
        FROM xasi2.ab01
       WHERE aab001 = prm_aab001;

      --人员信息查询
      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      dat_yae102_1  := TRUNC(TO_DATE(rec_irac01.iaa100,'yyyymm'),'month');--以申报月度的1号作为停保日期
      var_aae140_01 := rec_irac01.aae110;        --是否参加了企业养老
      var_aae140_06 := rec_irac01.aae120;        --是否参加了机关养老
      var_aae140_02 := rec_irac01.aae210;        --是否参加了失业
      var_aae140_03 := rec_irac01.aae310;        --是否参加了基本医疗
      var_aae140_04 := rec_irac01.aae410;        --是否参加了工伤
      var_aae140_05 := rec_irac01.aae510;        --是否参加了生育
      var_aae140_07 := rec_irac01.aae311;        --是否参加了大额
      var_aae140_08 := rec_irac01.aae810;

      IF var_aae140_06 = '3' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE120';
         t_cols(t_cols.count).col_value := '06';
      END IF;

      IF var_aae140_02 = '3' THEN
         t_cols(t_cols.COUNT+1).col_name := 'AAE210';
         t_cols(t_cols.count).col_value := '02';
      END IF;

      --仅在职人员才能暂停基本医疗保险
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

      --仅在职人员才能暂停大额补充医疗
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
         prm_ErrMsg  := rec_irac01.aac001 || '没有获得要停保的险种信息！';
         RETURN;
      END IF;

      /*
      暂停校验:
          险种：参保状态;
          停保前是否允许存在欠费
          停保日期之后不允许存在实缴和欠费
          停保日期之后不能存在失业待遇
      */
      FOR i in 1 .. t_cols.count  LOOP
         var_aae140 := t_cols(i).col_value;
         --个人参保状态
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
                  prm_ErrMsg   := '不存在险种：'||xasi2.PKG_COMM.fun_getAaa103('AAE140',var_aae140)||'在指定单位的个人参保关系'||';';
                  RETURN;
               END IF;
         END;
         IF var_aac031 <> PKG_Constant.AAC031_CBJF THEN
            IF var_aae140 <> PKG_Constant.AAE140_SYU THEN
               prm_AppCode := gn_def_ERR;
               prm_ErrMsg   := rec_irac01.aac001|| '险种：'||xasi2.PKG_COMM.fun_getAaa103('AAE140',var_aae140)||'的个人参保关系不为参保缴费，不能暂停'||';';
               RETURN;
            ELSE
               IF rec_irac01.aac008 <> PKG_Constant.AAC008_TX THEN
                  prm_AppCode := gn_def_ERR;
                  prm_ErrMsg   := rec_irac01.aac001 ||'险种：'||xasi2.PKG_COMM.fun_getAaa103('AAE140',var_aae140)||'的个人参保关系不为参保缴费，不能暂停'||';';
                  RETURN;
               END IF;
            END IF;
         END IF;

         --判断停保前是否允许存在欠费
         xasi2.pkg_P_Comm_CZ.prc_p_getYae565
                                     (PKG_Constant.YAB003_JBFZX  ,  --参保分中心
                                      var_aae140         ,        --险种
                                      PKG_Constant.AAC050_TB  ,   --变更类型
                                      var_yae565  ,               --欠费判断标志
                                      prm_AppCode  ,              --错误代码
                                      prm_ErrMsg   );             --错误内容
         IF prm_AppCode <> gn_def_OK THEN
             RETURN;
         END IF;
         IF var_yae565 = '3' THEN
            xasi2.pkg_gx_checkAndQuery.prc_p_checkEmployeeArrearage(
                                                             rec_irac01.aac001 ,                           --个人编号
                                                             var_aae140 ,                                  --险种类型（可以为NULL）
                                                             NULL,      --开始期号（可以为NULL）
                                                             TO_NUMBER(TO_CHAR(ADD_MONTHS(dat_yae102_1,1),'yyyymm')),                                              --终止期号（可以为NULL）
                                                             var_flag      ,                                    --检查结果（1、是；0、否）
                                                             var_ermsg       ,                                  --详细信息
                                                             prm_AppCode   ,
                                                             prm_ErrMsg    );
            IF prm_AppCode <> gn_def_OK THEN
               RETURN;
            ELSE
               IF var_flag = '1' THEN
                  prm_AppCode := gn_def_ERR;
                  prm_ErrMsg   := rec_irac01.aac001||'个人的参保险种'||xasi2.PKG_COMM.fun_getAaa103('AAE140',var_aae140)||'存在欠费信息，不能停保,';
                  RETURN;
               END IF;
            END IF;
         END IF;

         --停保日期之后不允许存在实缴和欠费
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
            prm_ErrMsg   := rec_irac01.aac001||'险种：'||xasi2.PKG_COMM.fun_getAaa103('AAE140',var_aae140)||'在停保日期之后存在实缴或欠费,不能停保';
            RETURN;
         END IF;

         --停保日期之后不能存在失业待遇
         IF var_aae140 = PKG_Constant.aae140_SYE THEN
            xasi2.pkg_p_interface.prc_p_checkEmployeeXZDY(
                                                      rec_irac01.aac001,      --个人编号
                                                      var_aae140       ,      --险种类型（可以为NULL）
                                                      TO_NUMBER(TO_CHAR(ADD_MONTHS(dat_yae102_1,1),'yyyymm')),--开始期号（可以为NULL）
                                                      NULL             ,      --终止期号（可以为NULL）
                                                      PKG_Constant.YAB003_JBFZX,--参保分中心（可以为NULL,目前预留该字段）
                                                      var_flag         ,      --检查结果（1、是；0、否）
                                                      var_msg          ,      --详细信息
                                                      prm_AppCode      ,
                                                      prm_ErrMsg       )
                                                      ;
            IF prm_AppCode <> gn_def_OK THEN
               return;
            END IF;
            IF var_flag = '1' THEN
               prm_AppCode := gn_def_ERR;
               prm_ErrMsg  := rec_irac01.aac001||'停保日期之后存在失业待遇享受,不能停保';
               RETURN;
            END IF;
         END IF;
      END LOOP;

      --暂停处理
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

         --yab136如果为普通单位获取单位最大做账期号,否则就是个人最大做账期号的下期
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
            prm_ErrMsg  := '单位编号：'||prm_aab001||'没有对应的参保信息;险种:'||xasi2.PKG_COMM.fun_getAaa103('AAE140',var_aae140);
            RETURN;
         END;

         num_yae097 := TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(num_yae097),'yyyymm'),1),'yyyymm')) ;
         --更新ac02
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
         --写入ac05
         INSERT INTO xasi2.ac05(
                      yae099,  --业务流水号
                      aac001,  --个人编号
                      aab001,  --单位编号
                      aae140,  --险种类型
                      aac050,  --个人变更类型
                      yae499,  --参保变更原因
                      aae035,  --变更日期
                      yae498,  --变更前参保状态
                      aac008,  --人员状态
                      yac505,  --参保缴费人员类别
                      yab013,  --原单位编号
                      yac503,  --工资类别
                      aac040,  --缴费工资
                      yac004,  --缴费基数
                      aae002,  --费款所属期
                      aae013,  --备注
                      aae011,  --经办人
                      aae036,  --经办时间
                      yab139,  --参保所属分中心
                      aae120,  --注销标志
                      akc021,  --医疗人员类别
                      yab003,  --社保经办机构
                      yae384,  --注销人
                      yae385,  --注销时间
                      yae406)  --注销原因

               SELECT prm_yae099,
                      a.aac001  ,
                      a.aab001  ,
                      a.aae140  ,
                      PKG_Constant.AAC050_TB,
                      NULL,
                      sysdate,
                      PKG_Constant.AAC031_CBJF,
                      b.aac008,   --人员状态
                      a.yac505,   --参保缴费人员类别
                      a.yab013,   --原单位编号
                      a.yac503,   --工资类别
                      a.aac040,   --缴费工资
                      a.yac004,   --缴费基数
                      num_yae097, --费款所属期
                      rec_irac01.aae013,   --备注
                      prm_aae011,   --经办人
                      dat_sysdate,  --经办时间
                      PKG_Constant.YAB003_JBFZX,   --参保所属分中心
                      PKG_Constant.AAE120_ZC,   --注销标志
                      var_akc021,   --医疗人员类别
                      PKG_Constant.YAB003_JBFZX,   --社保经办机构
                      NULL,   --注销人
                      NULL,   --注销时间
                      NULL    --注销原因
                 FROM xasi2.ac02 a,xasi2.ac01 b
                WHERE a.aac001 = b.aac001
                  AND a.aac001 =  rec_irac01.aac001
                  AND a.aae140 =  var_aae140
                  AND a.aab001 =  prm_aab001
                  AND a.yab139 = PKG_Constant.YAB003_JBFZX;
         --如果停保险种为大额 则判断是否为破产单位
         IF var_aae140 = PKG_Constant.AAE140_DEYL THEN
            --如果是大额保险 查询个人大额享受信息
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
               --如果大额医保享受截止期为 3000-01-01 更新享受截止期为停保时间
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

      --改变退休人员的状态
      IF rec_irac01.aac008 = PKG_Constant.AAC008_TX THEN
         UPDATE xasi2.ac01
            SET AAC008 = PKG_Constant.AAC008_TX
          WHERE AAC001 = rec_irac01.aac001
            AND AAC008 = PKG_Constant.AAC008_ZZ;
      END IF;

   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gn_def_ERR;
         prm_ErrMsg  := '个人停保出错,出错原因:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END prc_AuditMonthInternetRpause;

   /*****************************************************************************
   ** 过程名称 : prc_AddNewManage
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：新增专管员申请审核
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **                prm_aab001       IN     iraa01.aab001%TYPE,--专管员所在单位编码
   **                prm_aac001       IN     iraa01.aac001%TYPE,--专管员社保编号
   **                prm_yab516       IN     iraa01.yab516%TYPE,--专管员证件号
   **                prm_aab016       IN     iraa01.aab016%TYPE,--专管员姓名
   **                prm_aac004       IN     ad53a4.aac004%TYPE,--专管员姓名
   **                prm_yae041       IN     ad53a4.yae041%TYPE,--专管员助记码
   **                prm_yae042       IN     iraa01.yae042%TYPE,--专管员密码
   **                prm_yae043       IN     iraa01.yae043%TYPE,--初始密码
   **                prm_yab003       IN     ae02.yab003%TYPE,--经办人
   **                prm_aae011       IN     iraa01.aae011%TYPE,--经办人
   **                prm_aae013       IN     ae02.aae013%TYPE,  --备注
   **                prm_iaz014       IN     iraa01a1.iaz014%TYPE,--新增专管员事件ID
   **                prm_shmark       IN     VARCHAR2,            --审核通过标志
   **                prm_iad005       IN     irad22.iad005%TYPE,--审核意见
   **                prm_AppCode      OUT    VARCHAR2,
   **                prm_ErrorMsg     OUT    VARCHAR2,
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-12   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_AddNewManage (
     prm_aab001       IN     iraa01.aab001%TYPE,--专管员所在单位编码
     prm_aac001       IN     iraa01.aac001%TYPE,--专管员社保编号
     prm_yab516       IN     iraa01.yab516%TYPE,--专管员证件号
     prm_aab016       IN     iraa01.aab016%TYPE,--专管员姓名
     prm_aac004       IN     ad53a4.aac004%TYPE,--专管员姓名
     prm_yae041       IN     ad53a4.yae041%TYPE,--专管员助记码
     prm_yae042       IN     iraa01.yae042%TYPE,--专管员密码
     prm_yae043       IN     iraa01.yae043%TYPE,--初始密码
     prm_yab003       IN     ae02.yab003%TYPE,--经办人
     prm_aae011       IN     iraa01.aae011%TYPE,--经办人
     prm_aae013       IN     ae02.aae013%TYPE,  --备注
     prm_iaz014       IN     iraa01a1.iaz014%TYPE,--新增专管员事件ID
     prm_iad005       IN     irad22.iad005%TYPE,--审核意见
     prm_shmark       IN     VARCHAR2,            --审核通过标志
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
     /*界面数据录入校验*/
        IF prm_aab001 IS NUll THEN
          prm_ErrorMsg:='专管员所在单位单位编码不能为空!';
          RETURN;
        END IF;
        IF prm_yab516 IS NUll THEN
          prm_ErrorMsg:='添加专管员人员不能为空!';
          RETURN;
        END IF;
        IF prm_aab016 IS NUll THEN
          prm_ErrorMsg:='专管员姓名不能为空!';
          RETURN;
        END IF;
        IF prm_aab001 IS NUll THEN
          prm_ErrorMsg:='专管员助记码不能为空!';
          RETURN;
        END IF;
        IF prm_yae042 IS NULL THEN
         prm_ErrorMsg := '专管员密码不能为空!';
         RETURN;
       END IF;

       IF prm_yae043 IS NULL THEN
         prm_ErrorMsg := '初始密码不能为空!';
         RETURN;
       END IF;

       IF prm_iaz014 IS NULL THEN
         prm_ErrorMsg := '获取专管员新增事件ID出错!';
         RETURN;
       END IF;

       IF prm_shmark IS NULL THEN
         prm_ErrorMsg := '审核标志不能为空!';
         RETURN;
       END IF;
      --业务日志ID
      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
      IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
         prm_ErrorMsg := '没有获取到序列号AAZ002!';
         RETURN;
      END IF;
      --审核事件ID
      v_iaz009 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ009');
      IF v_iaz009 IS NULL OR v_iaz009 = '' THEN
         prm_ErrorMsg := '没有获取到序列号IAZ009!';
         RETURN;
      END IF;

      --审核事件ID
      v_iaz010 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ010');
      IF v_iaz010 IS NULL OR v_iaz010 = '' THEN
         prm_ErrorMsg := '没有获取到序列号AAZ010!';
         RETURN;
      END IF;

      --明细ID
      SELECT iaz005
      INTO   v_iaz005
      FROM wsjb.IRAD02
      WHERE iaz007 = prm_iaz014;
      IF v_iaz005 IS NULL OR v_iaz005 = '' THEN
        prm_ErrorMsg := '没有获取到明细ID';
        RETURN;
      END IF;
       --日志记录
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
     --写审核表irad21
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
                  '新增专管员审核'
                );
        --更新表irad02 状态为审核完毕
               UPDATE wsjb.irad02
               SET iaa015 = PKG_Constant.IAA015_ADO
               WHERE iaz005 = v_iaz005;

       --审核通过
       IF prm_shmark = '1' THEN

                  IF prm_yae041 IS NOT NULL THEN
                   SELECT COUNT(1)
                     INTO n_count
                     FROM wsjb.ad53a4  a , wsjb.iraa01  b
                    WHERE a.yae092=b.yae092
                      and a.aae100 = '1'
                      and a.yae041 = prm_yae041;         --专管员助记码
                   IF n_count > 0 THEN
                      prm_ErrorMsg := '已经存在助记码为['|| prm_yae041 ||']的专管员!';
                      RETURN;
                   END IF;
                END IF;
              IF prm_yab516 IS NOT NULL THEN
                   SELECT COUNT(1)
                     INTO n_count
                     FROM  wsjb.iraa01  b
                    WHERE b.yab516=prm_yab516
                      and b.aae100 = '1'
                      and b.aab001 = prm_aab001;         --专管员重复校验
                   IF n_count > 0 THEN
                      prm_ErrorMsg := '该人员已经是专管员!';
                      RETURN;
                   END IF;
                END IF;

                 /*将各个序列号放入变量*/

                v_yae092 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'FRAMEWORK');
                IF v_yae092 IS NULL OR v_yae092 = '' THEN
                   prm_ErrorMsg := '没有获取到序列号FRAMEWORK!';
                   RETURN;
                END IF;

                v_yae367 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'DEFAULT');
                IF v_yae367 IS NULL OR v_yae367 = '' THEN
                   prm_ErrorMsg := '没有获取到序列号DEFAULT!';
                   RETURN;
                END IF;
               /*写入专管员信息、日志、作用域关联信息变更*/
                     /*
                    分配登陆账号口令
                */
                INSERT INTO wsjb.ad53a4  (
                     yae092,  -- 操作人员编号
                     yab109,  -- 部门编号
                     aac003,  -- 姓名
                     aac004,  -- 姓名
                     yab003,  -- 经办机构
                     yae041,  -- 登陆号
                     yae042,  -- 登陆口令
                     yae361,  -- 锁定标志
                     yae362,  -- 口令错误次数
                     yae363,  -- 最后变更时间
                     yae114,  -- 排序号
                     aae100,  -- 有效标志
                     aae011,  -- 经办人
                     aae036   -- 经办时间
                     )
                VALUES
                    (
                     v_yae092  ,  -- 操作人员编号
                     '0101'    ,  -- 部门编号[单位经办]
                     prm_aab016,  -- 姓名
                     prm_aac004,  -- 性别
                     prm_yab003,  -- 经办机构
                     prm_yae041,  -- 专管员助记码[登录账号]
                     prm_yae042,  -- 登陆口令
                     '0'       ,  -- 锁定标志
                     0         ,  -- 口令错误次数
                     SYSDATE,  -- 最后变更时间
                     0         ,  -- 排序号
                     '1'       ,  -- 有效标志
                     prm_aae011,  -- 经办人
                     SYSDATE      -- 经办时间
                );


                /*
                   中心端数据新增：目的 解决中心端经办人员先是问题
                */
                INSERT INTO xasi2.ad53a4 (
                     yae092,  -- 操作人员编号
                     yab109,  -- 部门编号
                     aac003,  -- 姓名
                     aac004,  -- 性别
                     yab003,  -- 经办机构
                     yae041,  -- 登陆号
                     yae042,  -- 登陆口令
                     yae361,  -- 锁定标志
                     yae362,  -- 口令错误次数
                     yae363,  -- 最后变更时间
                     yae114,  -- 排序号
                     aae100,  -- 有效标志
                     aae011,  -- 经办人
                     aae036   -- 经办时间
                     )
                VALUES
                    (
                     v_yae092  ,  -- 操作人员编号
                     '0101'    ,  -- 部门编号[单位经办]
                     prm_aab016,  -- 姓名
                     prm_aac004,  -- 性别
                     prm_yab003,  -- 经办机构
                     prm_yae041,  -- 登陆号=单位编号=单位助记码[默认首任专管员如此]
                     prm_yae042,  -- 登陆口令
                     '0'       ,  -- 锁定标志
                     0         ,  -- 口令错误次数
                     SYSDATE,  -- 最后变更时间
                     0         ,  -- 排序号
                     '1'       ,  -- 有效标志
                     prm_aae011,  -- 经办人
                     SYSDATE      -- 经办时间
                );

                   /*写入单位专管员信息*/
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

                /*写入单位专管员信息ab01a1*/
                v_aac001 := xasi2.PKG_COMM.FUN_GETSEQUENCE(NULL,'AAC001');
                IF v_aac001 IS NULL OR v_aac001 = '' THEN
                   prm_ErrorMsg := '没有获取到序列号v_aac001!';
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
                    为操作人员授权为单位经办的岗位
                */
                INSERT INTO  wsjb.AD53A6
                            (
                             yae093,  -- 角色编号
                             yab109,  -- 部门编号
                             yae092,  -- 操作人员编号
                             aae011,  -- 经办人
                             aae036   -- 经办时间
                            )
                     VALUES
                            (
                             '1000000021',  -- 角色编号[单位经办]
                             '0101'    ,  -- 部门编号
                             v_yae092  ,  -- 操作人员编号
                             prm_aae011,  -- 经办人
                             SYSDATE      -- 经办时间
                );
                      /*
                   记录用户岗位变动日志
                */
                INSERT INTO wsjb.ad53a8  (
                       yae367,  -- 变动流水号
                       yae093,  -- 角色编号
                       yab109,  -- 部门编号
                       yae092,  -- 操作人员编号
                       aae011,  -- 经办人
                       aae036,  -- 经办时间
                       yae369,  -- 修改人
                       yae370,  -- 修改时间
                       yae372)  -- 权限变动类型
                VALUES (
                       v_yae367 ,  -- 变动流水号
                       '1000000021',  -- 角色编号
                       '0101',       -- 部门编号
                       v_yae092,    -- 操作人员编号
                       prm_aae011,  -- 经办人
                       SYSDATE   ,  -- 经办时间
                       prm_aae011,  -- 修改人
                       SYSDATE   ,  -- 修改时间
                       '07'        -- 权限变动类型
                );
                --更新iraa01a1信息
                UPDATE wsjb.iraa01a1
                SET yae092 = v_yae092,
                    yae043 = prm_yae043,
                    yae042 = prm_yae042,
                    iaa002 = '2'
               WHERE iaz014 = prm_iaz014;

             --写审核表irad22
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
        --更新表iraa01a1 状态为未通过
               UPDATE wsjb.iraa01a1
               SET iaa002 = PKG_Constant.IAA002_NPS
               WHERE iaz014 = prm_iaz014;

              --写审核表irad22
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
   /*关闭打开的游标*/
   prm_AppCode  :=  gn_def_ERR;
   prm_ErrorMsg := '数据库错误:'|| SQLERRM||dbms_utility.format_error_backtrace  ;
   RETURN;
   END prc_AddNewManage;


   /*****************************************************************************
   ** 过程名称 : Prc_Unitinfomaintainaudit
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：单位信息维护审核
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     wsjb.irad31 .aab001%TYPE,--专管员所在单位编码
   **           prm_aae013       IN     irad31.aae013%TYPE,--审核意见
   **           prm_iaa018       IN     irad22.iaa018%TYPE,--审核结果
   **           prm_aae011       IN     irad31.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          )
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-12   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_UnitInfoMaintainAudit (
     prm_aab001       IN     irad31.aab001%TYPE,--专管员所在单位编码
     prm_aae013       IN     irad31.aae013%TYPE,--审核意见
     prm_iaa018       IN     irad22.iaa018%TYPE,--审核结果
     prm_aae011       IN     irad31.aae011%TYPE,--经办人
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
      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;


      /*必要的数据校验*/
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '单位助记码不能为空!';
         RETURN;
      END IF;

      IF prm_iaa018 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '审核结果不能为空!';
         RETURN;
      END IF;

      IF prm_aae011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '经办人不能为空!';
         RETURN;
      END IF;


      --是否存在申报单位信息
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAB01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and b.aaa121 = PKG_Constant.AAA121_EIM and a.aab001 = prm_aab001 and (a.iaa002 = PKG_Constant.IAA002_AIR OR a.iaa002 = PKG_Constant.IAA002_NPS);
      IF n_count = 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '单位编号为['|| prm_aab001 ||']的单位申报信息不存在!';
            RETURN;
      ELSIF n_count > 1 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '单位编号为['|| prm_aab001 ||']的单位申报信息出错，请联系维护人员!';
            RETURN;
      END IF;

      --是否存在单位信息
      SELECT COUNT(1)
           into n_count
           FROM xasi2.AB01 a
          WHERE a.aab001 = prm_aab001;
      IF n_count = 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '单位编号为['|| prm_aab001 ||']的单位信息不存在!';
            RETURN;
      END IF;

      --是否存在单位开户信息
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAB01  a,wsjb.AE02  b
          WHERE a.aab001 = prm_aab001
          AND a.aaz002 = b.aaz002
          AND b.aaa121 = PKG_Constant.AAA121_NER;
      IF n_count = 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '单位编号为['|| prm_aab001 ||']的单位信息不存在!';
            RETURN;
      END IF;


      /*获取其他信息*/



      --日志记录
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

      --审核事件
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


      --审核明细处理
      v_iaz010 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ010');
         IF v_iaz010 IS NULL OR v_iaz010 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号IAZ010!';
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
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '单位维护信息出现错误，请联系维护人员！！！'|| SQLERRM||dbms_utility.format_error_backtrace  ;
         RETURN;
       END;

      --审核明细写入

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
                     IAD005,    --审核意见
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
                     prm_aae013,  --审核意见
                     null
                     );


      END;

      --更新IRAD01
      UPDATE wsjb.IRAD01  SET
             aae013 = prm_aae013
      WHERE
             iaz004 = v_iaz004;
      --更新IRAD02的数据
      UPDATE wsjb.IRAD02  SET
            iaa015 = PKG_Constant.IAA015_ADO,
            aae013 = prm_aae013
      WHERE
            iaz005 = v_iaz005;


      --更新IRAD41的数据
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
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '预约信息出现错误！！！'|| SQLERRM||dbms_utility.format_error_backtrace  ;
         RETURN;
      END;

      --更新AB01的数据
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
           --  aae014,  类型不一致  number
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

        --更新工伤行业等级
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


        --更新IRAB01
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

    --更新AB01A6的数据
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
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '更新地税管理码时出错！！！'|| SQLERRM||dbms_utility.format_error_backtrace  ;
         RETURN;
    END;

    --更新IRAD31的数据
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
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;

   END prc_UnitInfoMaintainAudit;


   /*****************************************************************************
   ** 过程名称 : prc_PersonInfoMaintain
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：人员重要信息维护
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **                 prm_aac001       IN     irac01.aac001%TYPE,--个人编号
   **                 prm_aab001       IN     irac01.aab001%TYPE,--单位编号
   **                 prm_aac002       IN     irac01.aac002%TYPE,--证件号码
   **                 prm_aac003       IN     irac01.aac003%TYPE,--姓名
   **                 prm_aac004       IN     irac01.aac004%TYPE,--性别
   **                 prm_aac006       IN     irac01.aac006%TYPE,--出生日期
   **                 prm_aac009       IN     irac01.aac009%TYPE,--户口性质
   **                 prm_aae011       IN     irac01.aae011%TYPE,--经办人
   **                 prm_aac040       IN     irac01.aac040%TYPE,--申报工资
   **           prm_AppCode      OUT    VARCHAR2    ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-4   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
     PROCEDURE prc_PersonInfoMaintain (
      prm_aac001       IN     irac01.aac001%TYPE,--个人编号
      prm_aab001       IN     irac01.aab001%TYPE,--单位编号
      prm_aac002       IN     irac01.aac002%TYPE,--证件号码
      prm_aac003       IN     irac01.aac003%TYPE,--姓名
      prm_aac004       IN     irac01.aac004%TYPE,--性别
      prm_aac006       IN     irac01.aac006%TYPE,--出生日期
      prm_aac009       IN     irac01.aac009%TYPE,--户口性质
      prm_aac013       IN     irac01.aac013%TYPE,--用工形式
      prm_yac168       IN     irac01.yac168%TYPE,--农民工标志
      prm_aac007        IN    irac01.aac007%TYPE,--参工日期
      prm_aac012        IN    irac01.aac012%TYPE,--个人身份
      prm_aae011       IN     irac01.aae011%TYPE,--经办人
      prm_aac040       IN     irac01.aac040%TYPE,--申报工资
      prm_iac001       OUT    irac01.iac001%TYPE,--申报编号
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )

    IS
      n_count    number(5);
      v_aaz002   varchar2(15);--日志ID
      v_iac001   varchar2(15);--申报人员申报ID
      v_iaz012   varchar2(15);--历史修改事件ID
      v_iaz013   varchar2(15);--历史修改明细ID
      v_iaz004   varchar2(15);--申报批次事件ID
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

      /*必要的数据校验*/


      IF prm_aac001 IS NULL THEN
         prm_ErrorMsg := '个人编号不能为空!';
         RETURN;
      END IF;

      IF prm_aac009 IS NULL THEN
         prm_ErrorMsg := '户口性质不能为空!';
         RETURN;
      END IF;

      --是否存在AC01人员信息
      SELECT COUNT(1)
           into n_count
           FROM xasi2.AC01
          WHERE aac001 = prm_aac001;
      IF n_count = 0 THEN
            prm_ErrorMsg := '个人编号为['|| prm_aac001 ||']的人员信息不存在!';
            RETURN;
      END IF;

      --校验是否存在人员信息
      SELECT COUNT(1)
           into n_count
           FROM xasi2.AC01 a,xasi2.AC02 b
          WHERE a.aac001 = prm_aac001 and a.aac001=b.aac001;
      IF n_count = 0 THEN
            prm_ErrorMsg := '不存在人员编号为['|| prm_aac001 ||']的人员信息！';
            RETURN;
      END IF;

      --是否存在已经申报维护信息
      SELECT COUNT(1)
           into n_count
           FROM wsjb.irac01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and a.aac001 = prm_aac001 and b.aaa121 = PKG_Constant.AAA121_PIM and a.iaa002 = PKG_Constant.IAA002_AIR;
      IF n_count > 0 THEN
            prm_ErrorMsg := '已经存在个人编号为['|| prm_aac001 ||']的维护申报信息!';
            RETURN;
      END IF;

      --是否存在相同的审核级次
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAA02
          WHERE iaa011 = PKG_Constant.IAA011_PIM
          AND iaa005 = PKG_Constant.IAA005_YES;
      IF n_count = 0 THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '没有系统审核级次信息!请联系维护人员';
            RETURN;
      ELSIF n_count > 1 THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '系统审核级次信息有误!请联系维护人员';
            RETURN;
      END IF;



      --将参数放进记录中
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

      --获取其他信息
      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');--获取日志ID

      SELECT iaa004
           into v_iaa004
           FROM wsjb.IRAA02
          WHERE iaa011 = PKG_Constant.IAA011_PIM
          AND iaa005 = PKG_Constant.IAA005_YES;

       --写入日志记录
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
                  '人员重要信息维护'
                 );


      --插入或者更新IRAC01

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

             --更新人员申报信息表
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

       --写入历史修改事件
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
                  '无'
                 );


      --申报事件表
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
                  '人员重要信息维护',
                  to_number(to_char(sysdate,'yyyymm'))
                 );
       --申报明细表
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
         --插入申报档案编号
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
           /*关闭打开的游标*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '人员修改信息表中存在错误数据！'|| SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;
       END;


       --更新人员申报信息表
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

            --更新r人员修改信息表
            UPDATE wsjb.IRAD31  SET
                   aaz002 = v_aaz002,
                   aae011 = prm_aae011,
                   aae035 = sysdate
                   --iaa019 = PKG_Constant.IAA019_IR
            WHERE iaz012 = v_iaz012;

            --更新IRAD32的数据
            UPDATE wsjb.IRAD32  a SET
                a.aae100 = '0'
            WHERE a.iaz012 = v_iaz012 and a.aae100 = '1';

                        --申报明细表
            v_iaz005 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');

            --查询上次ID
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
            /*关闭打开的游标*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '人员修改信息表中存在错误数据！'|| SQLERRM||dbms_utility.format_error_backtrace ;

            RETURN;
            END;

            --更新人员申报信息表
            UPDATE wsjb.IRAD01  SET
                   aaz002 = v_aaz002,
                   aae011 = prm_aae011,
                   aae035 = sysdate,
                  -- iaa019 = PKG_Constant.IAA019_IR,
                   iaa100 = to_number(to_char(sysdate,'yyyymm'))
            WHERE iaz004 = v_iaz004;

            --插入申报明细
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
     --提取申报编号
     prm_iac001 := v_iac001;

           --历史修改明细

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
           /*关闭打开的游标*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'AC01表中没有 '|| v_name ||'字段'|| SQLERRM||dbms_utility.format_error_backtrace ;

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
           prm_ErrorMsg := '表' || 'AC01' || '字段' || UPPER(v_name) || '的数据类型为' ||
                           col_type || '。不能处理' ;

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
                       '人员重要信息维护',
                       '1'
                     );

         END IF;

     END LOOP;
    EXCEPTION
           -- WHEN NO_DATA_FOUND THEN
          -- WHEN TOO_MANY_ROWS THEN
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
           /*关闭打开的游标*/
           ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;

    END prc_PersonInfoMaintain;

   /*****************************************************************************
   ** 过程名称 : prc_PersonInfoMaintainDanYL
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：人员重要信息维护(针对单养老)
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **                 prm_aac001       IN     irac01.aac001%TYPE,--个人编号
   **                 prm_aab001       IN     irac01.aab001%TYPE,--单位编号
   **                 prm_aac002       IN     irac01.aac002%TYPE,--证件号码
   **                 prm_aac003       IN     irac01.aac003%TYPE,--姓名
   **                 prm_aac004       IN     irac01.aac004%TYPE,--性别
   **                 prm_aac006       IN     irac01.aac006%TYPE,--出生日期
   **                 prm_aac009       IN     irac01.aac009%TYPE,--户口性质
   **                 prm_aae011       IN     irac01.aae011%TYPE,--经办人
   **                 prm_aac040       IN     irac01.aac040%TYPE,--申报工资
   **           prm_AppCode      OUT    VARCHAR2    ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-4   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
  PROCEDURE prc_PersonInfoMaintainDanYL (
      prm_aac001       IN     irac01.aac001%TYPE,--个人编号
      prm_aab001       IN     irac01.aab001%TYPE,--单位编号
      prm_aac002       IN     irac01.aac002%TYPE,--证件号码
      prm_aac003       IN     irac01.aac003%TYPE,--姓名
      prm_aac004       IN     irac01.aac004%TYPE,--性别
      prm_aac006       IN     irac01.aac006%TYPE,--出生日期
      prm_aac009       IN     irac01.aac009%TYPE,--户口性质
      prm_aac013       IN     irac01.aac013%TYPE,--用工形式
      prm_yac168       IN     irac01.yac168%TYPE,--农民工标志
      prm_aac007        IN    irac01.aac007%TYPE,--参工日期
      prm_aac012        IN    irac01.aac012%TYPE,--个人身份
      prm_aae011       IN     irac01.aae011%TYPE,--经办人
      prm_aac040       IN     irac01.aac040%TYPE,--申报工资
      prm_iac001       OUT    irac01.iac001%TYPE,--申报编号
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )

    IS
      n_count    number(5);
      v_aaz002   varchar2(15);--日志ID
      v_iac001   varchar2(15);--申报人员申报ID
      v_iaz012   varchar2(15);--历史修改事件ID
      v_iaz013   varchar2(15);--历史修改明细ID
      v_iaz004   varchar2(15);--申报批次事件ID
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

      /*必要的数据校验*/


      IF prm_aac001 IS NULL THEN
         prm_ErrorMsg := '个人编号不能为空!';
         RETURN;
      END IF;

      IF prm_aac009 IS NULL THEN
         prm_ErrorMsg := '户口性质不能为空!';
         RETURN;
      END IF;

      --是否存在AC01人员信息
      SELECT COUNT(1)
           into n_count
           FROM xasi2.AC01
          WHERE aac001 = prm_aac001;
      IF n_count = 0 THEN
            prm_ErrorMsg := '个人编号为['|| prm_aac001 ||']的人员信息不存在!';
            RETURN;
      END IF;

      --校验是否存在人员信息
      SELECT COUNT(1)
           into n_count
           FROM xasi2.AC01 a,wsjb.irac01a3  b
          WHERE a.aac001 = prm_aac001 and a.aac001=b.aac001;
      IF n_count = 0 THEN
            prm_ErrorMsg := '不存在人员编号为['|| prm_aac001 ||']的人员信息！';
            RETURN;
      END IF;

      --是否存在已经申报维护信息
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAC01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and a.aac001 = prm_aac001 and b.aaa121 = PKG_Constant.AAA121_PIM and a.iaa002 = PKG_Constant.IAA002_AIR;
      IF n_count > 0 THEN
            prm_ErrorMsg := '已经存在个人编号为['|| prm_aac001 ||']的维护申报信息!';
            RETURN;
      END IF;

      --是否存在相同的审核级次
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAA02
          WHERE iaa011 = PKG_Constant.IAA011_PIM
          AND iaa005 = PKG_Constant.IAA005_YES;
      IF n_count = 0 THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '没有系统审核级次信息!请联系维护人员';
            RETURN;
      ELSIF n_count > 1 THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '系统审核级次信息有误!请联系维护人员';
            RETURN;
      END IF;



      --将参数放进记录中
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

      --获取其他信息
      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');--获取日志ID

      SELECT iaa004
           into v_iaa004
           FROM wsjb.IRAA02
          WHERE iaa011 = PKG_Constant.IAA011_PIM
          AND iaa005 = PKG_Constant.IAA005_YES;

       --写入日志记录
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
                  '人员重要信息维护'
                 );


      --插入或者更新IRAC01

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

             --更新人员申报信息表
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

       --写入历史修改事件
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
                  '无'
                 );


      --申报事件表
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
                  '人员重要信息维护',
                  to_number(to_char(sysdate,'yyyymm'))
                 );
       --申报明细表
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
           /*关闭打开的游标*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '人员修改信息表中存在错误数据！'|| SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;
       END;


       --更新人员申报信息表
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

            --更新r人员修改信息表
            UPDATE wsjb.IRAD31  SET
                   aaz002 = v_aaz002,
                   aae011 = prm_aae011,
                   aae035 = sysdate
                   --iaa019 = PKG_Constant.IAA019_IR
            WHERE iaz012 = v_iaz012;

            --更新IRAD32的数据
            UPDATE wsjb.IRAD32  a SET
                a.aae100 = '0'
            WHERE a.iaz012 = v_iaz012 and a.aae100 = '1';

                        --申报明细表
            v_iaz005 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');

            --查询上次ID
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
            /*关闭打开的游标*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '人员修改信息表中存在错误数据！'|| SQLERRM||dbms_utility.format_error_backtrace ;

            RETURN;
            END;

            --更新人员申报信息表
            UPDATE wsjb.IRAD01  SET
                   aaz002 = v_aaz002,
                   aae011 = prm_aae011,
                   aae035 = sysdate,
                  -- iaa019 = PKG_Constant.IAA019_IR,
                   iaa100 = to_number(to_char(sysdate,'yyyymm'))
            WHERE iaz004 = v_iaz004;

            --插入申报明细
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
     --提取申报编号
     prm_iac001 := v_iac001;

           --历史修改明细

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
           /*关闭打开的游标*/
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := 'AC01表中没有 '|| v_name ||'字段'|| SQLERRM||dbms_utility.format_error_backtrace ;

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
           prm_ErrorMsg := '表' || 'AC01' || '字段' || UPPER(v_name) || '的数据类型为' ||
                           col_type || '。不能处理' ;

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
                       '人员重要信息维护',
                       '1'
                     );

         END IF;

     END LOOP;
    EXCEPTION
           -- WHEN NO_DATA_FOUND THEN
          -- WHEN TOO_MANY_ROWS THEN
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
           /*关闭打开的游标*/
           ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;

    END prc_PersonInfoMaintainDanYL;


   /*****************************************************************************
   ** 过程名称 : prc_PersonInfoMaintainAudit
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：个人信息维护审核
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aac001       IN     irad31.aab001%TYPE,--个人编号
   **           prm_aae013       IN     irad31.aae013%TYPE,--审核意见
   **           prm_iaa018       IN     irad22.iaa018%TYPE,--审核结果
   **           prm_aae011       IN     irad31.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-12   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInfoMaintainAudit (
     prm_aac001       IN     irac01.aac001%TYPE,--个人编号
     prm_aab001       IN     irac01.aab001%TYPE,--单位编号
     prm_aae013       IN     irad31.aae013%TYPE,--审核意见
     prm_iaa018       IN     irad22.iaa018%TYPE,--审核结果
     prm_aae011       IN     irad31.aae011%TYPE,--经办人
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

      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;

      /*必要的数据校验*/
      IF prm_aac001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '个人编号不能为空!';
         RETURN;
      END IF;

      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '单位助记码不能为空!';
         RETURN;
      END IF;

      IF prm_iaa018 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '审核结果不能为空!';
         RETURN;
      END IF;

      IF prm_aae011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '经办人不能为空!';
         RETURN;
      END IF;


      --是否存在申报个人维护信息
      SELECT COUNT(1)
           into n_count
           FROM wsjb.irac01  a,wsjb.AE02  b
          WHERE a.aaz002 = b.aaz002 and b.aaa121 = PKG_Constant.IAA011_PIM and a.aac001 = prm_aac001 and (a.iaa002 = PKG_Constant.IAA002_AIR OR a.iaa002 = PKG_Constant.IAA002_NPS);
      IF n_count = 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '个人编号为['|| prm_aac001 ||']的个人申报信息不存在!';
            RETURN;
      ELSIF n_count > 1 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '个人编号为['|| prm_aac001 ||']的个人申报信息出错，请联系维护人员!';
            RETURN;
      END IF;

       --是否存在个人信息
      SELECT COUNT(1)
           into n_count
           FROM xasi2.AC01 a
          WHERE a.aac001 = prm_aac001;
      IF n_count = 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '个人编号为['|| prm_aac001 ||']的个人信息不存在!';
            RETURN;
      END IF;

      --是否存在个人信息
      SELECT COUNT(1)
           into n_count
           FROM xasi2.AC01 a
          WHERE a.aac001 = prm_aac001;
      IF n_count = 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '个人编号为['|| prm_aac001 ||']的个人信息不存在!';
            RETURN;
      END IF;

    /*  --是否存在IRAC01A3信息
      SELECT COUNT(1)
           into n_count
           FROM IRAC01A3 a
          WHERE a.aac001 = prm_aac001;
      IF n_count = 0 THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '个人编号为['|| prm_aac001 ||']的个人信息在A3中不存在!';
            RETURN;
      END IF;
      */

       --日志记录
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

      --审核事件
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


      --审核明细处理
      v_iaz010 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ010');
         IF v_iaz010 IS NULL OR v_iaz010 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号IAZ010!';
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
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '个人维护信息出现错误，请联系维护人员！！！'|| SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;
       END;


       --审核明细写入

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
                     IAD005,    --审核意见
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
                     prm_aae013,  --审核意见
                     null
                     );
      END;

       --更新IRAD01
      UPDATE wsjb.IRAD01  SET
             aae013 = prm_aae013
      WHERE
             iaz004 = v_iaz004;
      --更新IRAD02的数据
      UPDATE wsjb.IRAD02  SET
            iaa015 = PKG_Constant.IAA015_ADO,
            aae013 = prm_aae013
      WHERE
            iaz005 = v_iaz005;


       --更新IRAD41的数据
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
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '预约信息出现错误！！！'|| SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;
      END;



       --更新AC01的数据
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
               prm_ErrorMsg := '农民工标志为空！';
               RETURN;
          -- WHEN DUP_VAL_ON_INDEX THEN
            WHEN OTHERS THEN
             /*关闭打开的游标*/
              ROLLBACK;
              prm_AppCode  :=  gn_def_ERR;
              prm_ErrorMsg := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
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
        --是否存在IRAC01A3信息
         SELECT COUNT(1)
           INTO n_count
           FROM wsjb.IRAC01A3  a
          WHERE a.aac001 = prm_aac001;
        IF n_count > 0 THEN
        --更新IRAC01A3的数据
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
            aae013 = '通过'
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
            aae013 = '打回'
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
            aae013 = '未通过'
        WHERE
            iaz007 = v_iac001
            and iaa011 = PKG_Constant.IAA011_PIM
            and iaa019 = PKG_Constant.IAA019_IR;
      END IF;

      EXCEPTION
         WHEN OTHERS THEN
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| SQLERRM||dbms_utility.format_error_backtrace  ;
         RETURN;

     END prc_PersonInfoMaintainAudit;
   /*****************************************************************************
   ** 过程名称 : prc_RollBackASIR
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：回退社会保险登记审核
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aaz002       IN     ae02.aaz002%TYPE  ,--业务日志编号
   **           prm_iaa100       IN     irad01.iaa100%TYPE,--申报月度
   **           prm_aae011       IN     irad31.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-06   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_RollBackASIR (
      prm_aaz002       IN     ae02.aaz002%TYPE,  --业务日志编号
      prm_iaa100       IN     irad01.iaa100%TYPE,--申报月度
      prm_aae011       IN     irad31.aae011%TYPE,--经办人
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum     NUMBER;
      var_yae099   xasi2.ac02a2.YAE099%TYPE;
      var_iaa020   irad02.iaa020%TYPE; --申报业务主体
      --需要回退的数据
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

      --对审核完毕的数据处于再申报待审时不能回退
      SELECT count(1)
        INTO countnum
        FROM wsjb.irad21  a,wsjb.irad22  b,wsjb.irad02  c
       WHERE a.iaz009 = b.iaz009
         AND b.iaz005 = c.iaz006
         AND c.iaa015 = PKG_Constant.IAA015_WAD  --待审
         AND a.aaz002 = prm_aaz002;
      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '存在待审的数据，不能回退！';
         RETURN;
      END IF;

      --对审核完毕的数据处于应收核定之后不能回退
      SELECT count(1)
        INTO countnum
        FROM xasi2.ab08 a,wsjb.irad01  b
       WHERE a.aab001 = b.aab001
         AND a.aae003 = prm_iaa100
         AND a.yae517 = 'H01'       --正常应收核定
         AND b.aaz002 = prm_aaz002;
      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据已经做过应收核定，不能回退！';
         RETURN;
      END IF;

      --对审核完毕的数据处于实收分配之后不能回退
      SELECT count(1)
        INTO countnum
        FROM xasi2.ab08a8 a,wsjb.irad01  b
       WHERE a.aab001 = b.aab001
         AND a.aae003 = prm_iaa100
         AND a.yae517 = 'H01'       --正常应收核定
         AND b.aaz002 = prm_aaz002;
      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据已经做过实收分配，不能回退！';
         RETURN;
      END IF;

      --检查是否存在可回退的数据
      SELECT count(1)
        INTO countnum
        FROM wsjb.irad21  a,wsjb.irad22  b,wsjb.irad02  c
       WHERE a.iaz009 = b.iaz009
         AND b.iaz005 = c.iaz005
         AND c.iaa015 IN(PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)  --审核完毕或者放弃审核
         AND a.aaz002 = prm_aaz002;
      IF countnum = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '不存在可回退的数据，不能回退！';
         RETURN;
      END IF;

      --循环处理
      FOR REC_TMP_PERSON in personCur LOOP

         --打回
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_DAD THEN
            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD, --待审
                   AAE013 = NULL
             WHERE IAA015 = PKG_Constant.IAA015_DAD --打回[放弃审核]
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            --审核的是单位
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_DW THEN
               --更新申报单位状态
               UPDATE IRAB01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --已申报
                WHERE IAA002 = PKG_Constant.IAA002_NPS  --未通过
                  AND IAB001 = REC_TMP_PERSON.IAZ007;
            END IF;
            --审核的是个人
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --已申报
                WHERE IAA002 = PKG_Constant.IAA002_NPS  --未通过
                  AND IAC001 = REC_TMP_PERSON.IAZ007;
            END IF;
         END IF;

         --不通过
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_NPS THEN
            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD, --待审
                   AAE013 = NULL
             WHERE IAA015 = PKG_Constant.IAA015_ADO --审核完毕
               AND IAZ005 =  REC_TMP_PERSON.IAZ005;

            --审核的是单位
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_DW THEN
               --更新申报单位状态
               UPDATE wsjb.IRAB01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --已申报
                WHERE IAA002 = PKG_Constant.IAA002_NPS  --未通过
                  AND IAB001 = REC_TMP_PERSON.IAZ007;
            END IF;
            --审核的是个人
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --已申报
                WHERE IAA002 = PKG_Constant.IAA002_NPS  --未通过
                  AND IAC001 = REC_TMP_PERSON.IAZ007;
            END IF;
         END IF;

         --通过
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_PAS THEN

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD --待审
             WHERE IAA015 = PKG_Constant.IAA015_ADO --审核完毕
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            --审核的是单位
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_DW THEN
               --更新申报单位状态
               UPDATE IRAB01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --已申报
                WHERE IAA002 = PKG_Constant.IAA002_APS  --已通过
                  AND IAB001 = REC_TMP_PERSON.IAZ007;
                --zj 2013-08-20修改
              /* --调用单位回退过程
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
            --审核的是个人
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN

               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --已申报
                WHERE IAA002 = PKG_Constant.IAA002_APS  --已通过
                  AND IAC001 = REC_TMP_PERSON.IAZ007;
               --调用人员回退过程
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
         AND c.iaa015 IN(PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)  --审核完毕或者放弃审核
         AND a.aaz002 = prm_aaz002;
      IF countnum > 0 THEN
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '还存在可回退的数据！';
         RETURN;
      END IF;

      --删除审核明细
      DELETE
        FROM wsjb.IRAD22  a
       WHERE EXISTS
             (
              SELECT iaz009
                FROM wsjb.IRAD21
               WHERE iaz009 = a.iaz009
                 AND aaz002 = prm_aaz002
             );

      --删除审核事件
      DELETE
        FROM wsjb.IRAD21
       WHERE aaz002 = prm_aaz002;

      --删除日志记录
      DELETE
        FROM wsjb.AE02
       WHERE aaz002 = prm_aaz002;

   EXCEPTION
      WHEN OTHERS THEN
      /*关闭打开的游标*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '数据库错误:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
      RETURN;
   END prc_RollBackASIR;

   /*****************************************************************************
   ** 过程名称 : prc_RollBackASIREmp
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：回退社会保险登记审核[单位信息回退]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位编号
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-06   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_RollBackASIREmp (
      prm_aab001       IN     irab01.aab001%TYPE,--单位编号
      prm_yae099       IN     xasi2.ac02a2.yae099%TYPE,--业务流水号
      prm_aae011       IN     xasi2.ab01.aae011%TYPE,  --经办人
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
         prm_ErrorMsg := '不存在指定回退的单位，请确认数据是否正确!';
         RETURN;
      END IF;

      --回退单位基本信息
      --回退之前先进行备份  wl 2013-03-28
      INSERT INTO xasi2.AB01_Rollback(AAB001,             --单位编号,VARCHAR2
                                         AAB002,             --社会保险登记证编码,VARCHAR2
                                         AAB003,             --组织机构代码,VARCHAR2
                                         AAB004,             --单位名称,VARCHAR2
                                         AAB005,             --单位电话,VARCHAR2
                                         AAB006,             --工商登记执照种类,VARCHAR2
                                         AAB007,             --工商登记执照号码,VARCHAR2
                                         AAB008,             --工商登记发照日期,DATE
                                         AAB009,             --工商登记有效期限,NUMBER
                                         AAB010,             --批准成立单位,VARCHAR2
                                         AAB011,             --批准日期,DATE
                                         AAB012,             --批准文号,VARCHAR2
                                         AAB013,             --法定代表人姓名,VARCHAR2
                                         YAB136,             --单位管理状态,VARCHAR2
                                         AAB019,             --单位类型,VARCHAR2
                                         AAB020,             --经济成分,VARCHAR2
                                         AAB021,             --隶属关系,VARCHAR2
                                         AAB022,             --单位行业,VARCHAR2
                                         YLB001,             --工伤行业等级,VARCHAR2
                                         YAB391,             --法定代表人证件类型,VARCHAR2
                                         YAB388,             --法定代表人证件编号,VARCHAR2
                                         YAB389,             --法定代表人手机,VARCHAR2
                                         AAB015,             --法定代表人办公电话,VARCHAR2
                                         YAB515,             --专管员证件类型,VARCHAR2
                                         YAB516,             --专管员证件编号,VARCHAR2
                                         AAB016,             --专管员姓名,VARCHAR2
                                         YAB237,             --专管员所在部门,VARCHAR2
                                         YAB390,             --专管员手机,VARCHAR2
                                         AAB018,             --专管员办公电话,VARCHAR2
                                         YAB517,             --专管员电子邮箱,VARCHAR2
                                         AAB023,             --主管部门或主管机构,VARCHAR2
                                         YAB518,             --成立日期,DATE
                                         AAE007,             --邮政编码,NUMBER
                                         AAE006,             --地址,VARCHAR2
                                         YAE225,             --注册地址,VARCHAR2
                                         YAB519,             --单位电子邮箱,VARCHAR2
                                         YAB520,             --单位网址,VARCHAR2
                                         AAE014,             --传真,VARCHAR2
                                         AAB034,             --社会保险经办机构编码,VARCHAR2
                                         AAB301,             --所属行政区划代码,VARCHAR2
                                         YAB322,             --最近一次换证验证时间,DATE
                                         YAB274,             --事业单位资金来源,VARCHAR2
                                         YAB525,             --是否企业化管理事业单位,VARCHAR2
                                         YAB524,             --退休人员大额代扣标志,VARCHAR2
                                         YAB521,             --离休资金来源单位,VARCHAR2
                                         YAB522,             --二乙资金来源单位,VARCHAR2
                                         YAB523,             --单位实际编制人数,NUMBER
                                         YAB236,             --机关事业单位法人代码,VARCHAR2
                                         AAE119,             --单位状态,VARCHAR2
                                         YAB275,             --社会保险执行办法,VARCHAR2
                                         YAE496,             --所属街道,VARCHAR2
                                         YAE407,             --所属社区,VARCHAR2
                                         AAE013,             --备注,VARCHAR2
                                         AAE011,             --经办人,NUMBER
                                         AAE036,             --经办时间,DATE
                                         YAE443,             --经办人姓名,VARCHAR2
                                         YAB553,             --高校类型,VARCHAR2
                                         AAB304,             --经办机构负责人,VARCHAR2
                                         YAE393,             --经办机构负责人联系电话,VARCHAR2
                                         YAB554,             --经办机构负责人手机/E-mail,VARCHAR2
                                         YKB110,             --预划医疗帐户,VARCHAR2
                                         YKB109,             --是否享受公务员统筹待遇,VARCHAR2
                                         YAB566,             --是否军转户,VARCHAR2
                                         YAB565,             --财政拨款文号,VARCHAR2
                                         YAB380,             --困难企业标志,VARCHAR2
                                         YAB279,             --医疗一次性补充资金缴纳认定,VARCHAR2
                                         YAB003,             --经办分中心,VARCHAR2
                                         AAF020,             --税务机构编号,VARCHAR2
                                         AAB343,             --一级单位编号,VARCHAR2
                                         AAB030)             --税号,VARCHAR2
                                  SELECT AAB001,             --单位编号,VARCHAR2
                                         AAB002,             --社会保险登记证编码,VARCHAR2
                                         AAB003,             --组织机构代码,VARCHAR2
                                         AAB004,             --单位名称,VARCHAR2
                                         AAB005,             --单位电话,VARCHAR2
                                         AAB006,             --工商登记执照种类,VARCHAR2
                                         AAB007,             --工商登记执照号码,VARCHAR2
                                         AAB008,             --工商登记发照日期,DATE
                                         AAB009,             --工商登记有效期限,NUMBER
                                         AAB010,             --批准成立单位,VARCHAR2
                                         AAB011,             --批准日期,DATE
                                         AAB012,             --批准文号,VARCHAR2
                                         AAB013,             --法定代表人姓名,VARCHAR2
                                         YAB136,             --单位管理状态,VARCHAR2
                                         AAB019,             --单位类型,VARCHAR2
                                         AAB020,             --经济成分,VARCHAR2
                                         AAB021,             --隶属关系,VARCHAR2
                                         AAB022,             --单位行业,VARCHAR2
                                         YLB001,             --工伤行业等级,VARCHAR2
                                         YAB391,             --法定代表人证件类型,VARCHAR2
                                         YAB388,             --法定代表人证件编号,VARCHAR2
                                         YAB389,             --法定代表人手机,VARCHAR2
                                         AAB015,             --法定代表人办公电话,VARCHAR2
                                         YAB515,             --专管员证件类型,VARCHAR2
                                         YAB516,             --专管员证件编号,VARCHAR2
                                         AAB016,             --专管员姓名,VARCHAR2
                                         YAB237,             --专管员所在部门,VARCHAR2
                                         YAB390,             --专管员手机,VARCHAR2
                                         AAB018,             --专管员办公电话,VARCHAR2
                                         YAB517,             --专管员电子邮箱,VARCHAR2
                                         AAB023,             --主管部门或主管机构,VARCHAR2
                                         YAB518,             --成立日期,DATE
                                         AAE007,             --邮政编码,NUMBER
                                         AAE006,             --地址,VARCHAR2
                                         YAE225,             --注册地址,VARCHAR2
                                         YAB519,             --单位电子邮箱,VARCHAR2
                                         YAB520,             --单位网址,VARCHAR2
                                         AAE014,             --传真,VARCHAR2
                                         AAB034,             --社会保险经办机构编码,VARCHAR2
                                         AAB301,             --所属行政区划代码,VARCHAR2
                                         YAB322,             --最近一次换证验证时间,DATE
                                         YAB274,             --事业单位资金来源,VARCHAR2
                                         YAB525,             --是否企业化管理事业单位,VARCHAR2
                                         YAB524,             --退休人员大额代扣标志,VARCHAR2
                                         YAB521,             --离休资金来源单位,VARCHAR2
                                         YAB522,             --二乙资金来源单位,VARCHAR2
                                         YAB523,             --单位实际编制人数,NUMBER
                                         YAB236,             --机关事业单位法人代码,VARCHAR2
                                         AAE119,             --单位状态,VARCHAR2
                                         YAB275,             --社会保险执行办法,VARCHAR2
                                         YAE496,             --所属街道,VARCHAR2
                                         YAE407,             --所属社区,VARCHAR2
                                         '社会保险登记审核[单位信息回退]'||aae011||'，'||aae036,             --备注,VARCHAR2
                                         prm_aae011,             --经办人,NUMBER
                                         SYSDATE,             --经办时间,DATE
                                         YAE443,             --经办人姓名,VARCHAR2
                                         YAB553,             --高校类型,VARCHAR2
                                         AAB304,             --经办机构负责人,VARCHAR2
                                         YAE393,             --经办机构负责人联系电话,VARCHAR2
                                         YAB554,             --经办机构负责人手机/E-mail,VARCHAR2
                                         YKB110,             --预划医疗帐户,VARCHAR2
                                         YKB109,             --是否享受公务员统筹待遇,VARCHAR2
                                         YAB566,             --是否军转户,VARCHAR2
                                         YAB565,             --财政拨款文号,VARCHAR2
                                         YAB380,             --困难企业标志,VARCHAR2
                                         YAB279,             --医疗一次性补充资金缴纳认定,VARCHAR2
                                         YAB003,             --经办分中心,VARCHAR2
                                         AAF020,             --税务机构编号,VARCHAR2
                                         AAB343,             --一级单位编号,VARCHAR2
                                         AAB030              --税号,VARCHAR2
                                    FROM xasi2.AB01
                                   WHERE aab001 = prm_aab001;
      DELETE
        FROM xasi2.AB01
       WHERE aab001 = prm_aab001;


      --回退单位管理代码
      INSERT INTO xasi2.AB01A6_ROLLBACK(AAB001,             --单位编号,VARCHAR2
                                  YAB028,             --单位管理代码,VARCHAR2
                                  aae013,             --备注
                                  aae011,
                                  aae036)
                           SELECT aab001,
                                  yab028,
                                  '社会保险登记审核[单位信息回退]',
                                  prm_aae011,
                                  SYSDATE
                             FROM xasi2.ab01a7
                            WHERE aab001 = prm_aab001;
      DELETE
        FROM xasi2.AB01A7
       WHERE aab001 = prm_aab001;

      --回退单位助记码
      INSERT INTO xasi2.ab01a2_rollback(AAB001,             --单位编号,VARCHAR2
                                  YAB021,             --单位助记码,VARCHAR2
                                  YAB022,             --失业险种助记码,VARCHAR2
                                  YAB023,             --基本医疗险种助记码,VARCHAR2
                                  YAB024,             --工伤险种助记码,VARCHAR2
                                  YAB025,             --生育险种助记码,VARCHAR2
                                  YAB027,             --大额险种助记码,VARCHAR2
                                  YAB028,             --机关养老险种助记码,VARCHAR2
                                  YAB026,             --企业养老险种助记码,VARCHAR2
                                  aae013,
                                  aae011,
                                  aae036)
                           SELECT AAB001,             --单位编号,VARCHAR2
                                  YAB021,             --单位助记码,VARCHAR2
                                  YAB022,             --失业险种助记码,VARCHAR2
                                  YAB023,             --基本医疗险种助记码,VARCHAR2
                                  YAB024,             --工伤险种助记码,VARCHAR2
                                  YAB025,             --生育险种助记码,VARCHAR2
                                  YAB027,             --大额险种助记码,VARCHAR2
                                  YAB028,             --机关养老险种助记码,VARCHAR2
                                  YAB026,             --企业养老险种助记码,VARCHAR2
                                  '社会保险登记审核[单位信息回退]',
                                  prm_aae011,
                                  SYSDATE
                             FROM xasi2.ab01a2
                            WHERE yab021 = prm_aab001;
      DELETE xasi2.AB01A2

       WHERE yab021 = prm_aab001;

      --回退专管员信息
      INSERT INTO xasi2.ab01a1_rollback(AAC001,             --个人编号,VARCHAR2
                                  AAB001,             --单位编号,VARCHAR2
                                  YAB515,             --专管员证件类型,VARCHAR2
                                  YAB516,             --专管员证件编号,VARCHAR2
                                  AAB016,             --专管员姓名,VARCHAR2
                                  AAB018,             --专管员办公电话,VARCHAR2
                                  YAB390,             --专管员手机,VARCHAR2
                                  YAB237,             --专管员所在部门,VARCHAR2
                                  YAB517,             --专管员电子邮箱,VARCHAR2
                                  aae011,
                                  aae036,
                                  aae013)
                           SELECT AAC001,             --个人编号,VARCHAR2
                                  AAB001,             --单位编号,VARCHAR2
                                  YAB515,             --专管员证件类型,VARCHAR2
                                  YAB516,             --专管员证件编号,VARCHAR2
                                  AAB016,             --专管员姓名,VARCHAR2
                                  AAB018,             --专管员办公电话,VARCHAR2
                                  YAB390,             --专管员手机,VARCHAR2
                                  YAB237,             --专管员所在部门,VARCHAR2
                                  YAB517,             --专管员电子邮箱,VARCHAR2
                                  prm_aae011,
                                  SYSDATE,
                                  '社会保险登记审核[单位信息回退]'
                             FROM xasi2.ab01a3
                            WHERE aab001 = prm_aab001;
      DELETE
        FROM xasi2.AB01A3
       WHERE aab001 = prm_aab001;

      --回退单位社会保险信息
      INSERT INTO xasi2.ab02_rollback(AAB001,             --单位编号,VARCHAR2
                                AAE140,             --险种类型,VARCHAR2
                                AAB050,             --单位参保日期,DATE
                                YAE097,             --最大做账期号,NUMBER
                                AAB051,             --参保状态,VARCHAR2
                                AAA040,             --比例类别,VARCHAR2
                                AAB033,             --征收方式,VARCHAR2
                                YAB139,             --参保所属分中心,VARCHAR2
                                YAE102,             --最后一次变更时间,DATE
                                AAE042,             --工资年审截止期,NUMBER
                                YAB534,             --缴费开户银行类别,VARCHAR2
                                AAB024,             --缴费开户银行,VARCHAR2
                                AAB025,             --缴费银行户名,VARCHAR2
                                AAB026,             --缴费银行基本账号,VARCHAR2
                                YAB535,             --支付开户银行行类别,VARCHAR2
                                AAB027,             --支付开户银行,VARCHAR2
                                AAB028,             --支付银行户名,VARCHAR2
                                AAB029,             --支付银行基本账号,VARCHAR2
                                AAE011,             --经办人,NUMBER
                                AAE036,             --经办时间,DATE
                                YAB003,             --社保经办机构,VARCHAR2
                                AAE013,             --备注,VARCHAR2
                                AAE003)              --
                        SELECT  AAB001,             --单位编号,VARCHAR2
                                AAE140,             --险种类型,VARCHAR2
                                AAB050,             --单位参保日期,DATE
                                YAE097,             --最大做账期号,NUMBER
                                AAB051,             --参保状态,VARCHAR2
                                AAA040,             --比例类别,VARCHAR2
                                AAB033,             --征收方式,VARCHAR2
                                YAB139,             --参保所属分中心,VARCHAR2
                                YAE102,             --最后一次变更时间,DATE
                                AAE042,             --工资年审截止期,NUMBER
                                YAB534,             --缴费开户银行类别,VARCHAR2
                                AAB024,             --缴费开户银行,VARCHAR2
                                AAB025,             --缴费银行户名,VARCHAR2
                                AAB026,             --缴费银行基本账号,VARCHAR2
                                YAB535,             --支付开户银行行类别,VARCHAR2
                                AAB027,             --支付开户银行,VARCHAR2
                                AAB028,             --支付银行户名,VARCHAR2
                                AAB029,             --支付银行基本账号,VARCHAR2
                                prm_aae011,             --经办人,NUMBER
                                SYSDATE,             --经办时间,DATE
                                YAB003,             --社保经办机构,VARCHAR2
                                '社会保险登记审核[单位信息回退]'||aae011||','||aae036,             --备注,VARCHAR2
                                AAE003              --
                           FROM xasi2.ab02
                          WHERE aab001 = prm_aab001;
      DELETE
        FROM xasi2.AB02
       WHERE aab001 = prm_aab001;

      --回退单位险种变更信息
      INSERT INTO xasi2.ab06_rollback(YAE099,             --业务流水号,VARCHAR2
                                AAB001,             --单位编号,VARCHAR2
                                AAE140,             --险种类型,VARCHAR2
                                AAB100,             --单位变更类型,VARCHAR2
                                AAB101,             --单位变更日期,DATE
                                AAB102,             --单位变更原因,VARCHAR2
                                AAE013,             --备注,VARCHAR2
                                AAE011,             --经办人,NUMBER
                                AAE036,             --经办时间,DATE
                                YAB003,             --社保经办机构,VARCHAR2
                                YAB139)             --参保所属分中心,VARCHAR2
                         SELECT YAE099,             --业务流水号,VARCHAR2
                                AAB001,             --单位编号,VARCHAR2
                                AAE140,             --险种类型,VARCHAR2
                                AAB100,             --单位变更类型,VARCHAR2
                                AAB101,             --单位变更日期,DATE
                                AAB102,             --单位变更原因,VARCHAR2
                                '社会保险登记审核[单位信息回退]'||aae011||','||aae036,             --备注,VARCHAR2
                                prm_aae011,             --经办人,NUMBER
                                SYSDATE,             --经办时间,DATE
                                YAB003,             --社保经办机构,VARCHAR2
                                YAB139              --参保所属分中心,VARCHAR2
                           FROM xasi2.ab06
                          WHERE aab001 = prm_aab001;
      DELETE
        FROM xasi2.AB06
       WHERE aab001 = prm_aab001;

   EXCEPTION
      WHEN OTHERS THEN
      /*关闭打开的游标*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '数据库错误:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
      RETURN;
   END prc_RollBackASIREmp;

   /*****************************************************************************
   ** 过程名称 : prc_RollBackASIRPer
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：回退社会保险登记审核[个人信息回退 新参保 续保]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aac001       IN     irac01.aac001%TYPE,--人员编号
   **           prm_yea099       IN     ae02a2.yae099%TYPE,--业务流水号
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-06   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_RollBackASIRPer (
      prm_iac001       IN     irac01.iac001%TYPE,--申报人员编号
      prm_yae099       IN     xasi2.ac02a2.yae099%TYPE,--业务流水号
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum        NUMBER;
      var_aac050      VARCHAR2(2);
      var_existsxb    VARCHAR2(2);
      var_aae140_01   VARCHAR2(2);         --是否参加了企业养老
      var_aae140_06   VARCHAR2(2);         --是否参加了机关养老
      var_aae140_02   VARCHAR2(2);         --是否参加了失业
      var_aae140_03   VARCHAR2(2);         --是否参加了基本医疗
      var_aae140_04   VARCHAR2(2);         --是否参加了工伤
      var_aae140_05   VARCHAR2(2);         --是否参加了生育
      var_aae140_07   VARCHAR2(2);         --是否参加了大额
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

      var_aae140_01 := rec_irac01.aae110;        --是否参加了企业养老
      var_aae140_06 := rec_irac01.aae120;        --是否参加了机关养老
      var_aae140_02 := rec_irac01.aae210;        --是否参加了失业
      var_aae140_03 := rec_irac01.aae310;        --是否参加了基本医疗
      var_aae140_04 := rec_irac01.aae410;        --是否参加了工伤
      var_aae140_05 := rec_irac01.aae510;        --是否参加了生育
      var_aae140_07 := rec_irac01.aae311;        --是否参加了大额

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

      --是否存在续保数据
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

         --检查险种是否新增或者续保
         SELECT AAC050
           INTO var_aac050
           FROM xasi2.AC05 a
          WHERE a.aac001 = rec_irac01.AAC001
            AND a.aae140 = t_cols(i).col_value
            AND a.yae099 = prm_yae099;

         --险种新增回退
         IF var_aac050 =  PKG_Constant.AAC050_XCB THEN
            --回退参保信息
            DELETE
              FROM xasi2.AC02
             WHERE aae140 = t_cols(i).col_value
               AND aac001 = rec_irac01.AAC001;
            --基本医疗的处理情况
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

         --续保回退
         IF var_aac050 =  PKG_Constant.AAC050_XB THEN
            --回退参保信息
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
            --基本医疗的处理情况
            IF t_cols(i).col_value = PKG_Constant.AAE140_JBYL THEN
               --回退医疗保险信息
               UPDATE xasi2.KC01
                  SET aab001 = (SELECT yab013
                                  FROM xasi2.AC05
                                 WHERE aac001 = rec_irac01.AAC001
                                   AND aae140 = PKG_Constant.AAE140_JBYL
                                   AND yae099 = prm_yae099)
                WHERE aac001 = rec_irac01.AAC001;
               --回退制卡库信息
               DELETE
                 FROM xasi2.KC01K1
                WHERE aac001 = rec_irac01.AAC001
                  AND yae099 = prm_yae099;
               --回退制卡库信息

            END IF;
         END IF;

         --回退事件信息
         DELETE
           FROM xasi2.AC05
          WHERE aae140 = t_cols(i).col_value
            AND aac001 = rec_irac01.AAC001
            AND yae099 = prm_yae099;

         --回退基数事件
         DELETE
           FROM xasi2.AC04A3
          WHERE aae140 = t_cols(i).col_value
            AND aac001 = rec_irac01.AAC001
            AND yae099 = prm_yae099;

      END LOOP;

      --没有续保存在，回退个人信息
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
      /*关闭打开的游标*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '数据库错误:'|| SQLERRM||dbms_utility.format_error_backtrace  ;
      RETURN;
   END prc_RollBackASIRPer;

   /*****************************************************************************
   ** 过程名称 : prc_ResetASIR
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：重置社会保险登记审核
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位编号
   **           prm_iaa100       IN     irad01.iaa100%TYPE,--申报月度
   **           prm_aae011       IN     irad31.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-09   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_ResetASIR (
      prm_aab001       IN     irab01.aab001%TYPE,--单位编号
      prm_iaa100       IN     irad01.iaa100%TYPE,--申报月度
      prm_aae011       IN     irad31.aae011%TYPE,--经办人
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum     NUMBER;

      --需要重置的申报数据
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

      --需要重置的审核数据
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

      --检查是否符合重置条件
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
         prm_ErrorMsg := '当前社保助记码单位不存在申报的社会保险登记数据，不能重置!';
         RETURN;
      END IF;

      --是否存在申报后的增减变动记录
      SELECT count(1)
        INTO countnum
        FROM wsjb.IRAC01
       WHERE IAA001 NOT IN ('2', '4')
         AND IAA002 = '0'
         AND IAA100 IS NULL
         AND AAB001 = prm_aab001;
      IF countnum > 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '当前社保助记码单位存在申报后的增减变动记录数据，不能重置!请单位回退后再重置！';
         RETURN;
      END IF;

      --检查是否存在审核记录
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

      --有审核记录，回退所有审核
      IF countnum > 0 THEN
         FOR rec_irad21 in irad21Cur LOOP
             prc_RollBackASIR(rec_irad21.aaz002,--审核业务日志
                              prm_iaa100       ,--申报月度
                              prm_aae011       ,--经办人
                              prm_AppCode      ,
                              prm_ErrorMsg
                              );
             IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                RETURN;
             END IF;
         END LOOP;
      END IF;

      --回退申报过程
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
      /*关闭打开的游标*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '数据库错误:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
      RETURN;
   END prc_ResetASIR;

   /*****************************************************************************
   ** 过程名称 : prc_RollBackAMIR
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：回退月申报审核
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aaz002       IN     ae02.aaz002%TYPE  ,--业务日志编号
   **           prm_iaa100       IN     irad01.iaa100%TYPE,--申报月度
   **           prm_aae011       IN     irad31.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-06   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_RollBackAMIR (
      prm_aaz002       IN     ae02.aaz002%TYPE,  --业务日志编号
      prm_iaa100       IN     irad01.iaa100%TYPE,--申报月度
      prm_aab001       IN     irad01.aab001%TYPE,--申报单位
      prm_aae011       IN     irad31.aae011%TYPE,--经办人
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum     NUMBER;
      var_yae099   xasi2.ac02a2.YAE099%TYPE;
      var_iaa020   irad02.iaa020%TYPE; --申报业务主体
      var_aab001   varchar(6);
      --需要回退的数据
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

      --对审核完毕的数据处于再申报待审时不能回退
      /*SELECT count(1)
        INTO countnum
        FROM irad21 a,irad22 b,irad02 c
       WHERE a.iaz009 = b.iaz009
         AND b.iaz005 = c.iaz006
         AND c.iaa015 = PKG_Constant.IAA015_WAD  --待审
         AND a.aaz002 = prm_aaz002;
      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '存在待审的数据，不能回退！';
         RETURN;
      END IF;*/

      --对审核完毕的数据处于应收核定之后不能回退
      SELECT count(1)
        INTO countnum
        FROM xasi2.ab08
       WHERE aab001 = prm_aab001
         AND aae003 = prm_iaa100
         AND yae517 = 'H01';       --正常应收核定
      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据已经做过应收核定，不能回退！';
         RETURN;
      END IF;

      --对审核完毕的数据处于实收分配之后不能回退
      SELECT count(1)
        INTO countnum
        FROM xasi2.ab08a8
       WHERE aab001 = prm_aab001
         AND aae003 = prm_iaa100
         AND YAB538 = '1' -- modify by whm 不卡离退休的 20190419
         AND yae517 = 'H01';       --正常应收核定
      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据已经做过实收分配，不能回退！';
         RETURN;
      END IF;

      --检查是否存在可回退的数据
      SELECT count(1)
        INTO countnum
        FROM wsjb.irad21  a,wsjb.irad22  b,wsjb.irad02  c
       WHERE a.iaz009 = b.iaz009
         AND b.iaz005 = c.iaz005
         AND c.iaa015 IN(PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)  --审核完毕或者放弃审核
         AND a.aaz002 = prm_aaz002;
      IF countnum = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '不存在可回退的数据，不能回退！';
         RETURN;
      END IF;

      --循环处理
      FOR REC_TMP_PERSON in personCur LOOP

         --打回
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_DAD THEN
            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD, --待审
                   AAE013 = NULL
             WHERE IAA015 = PKG_Constant.IAA015_DAD --打回[放弃审核]
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            --审核的是个人
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --已申报
                WHERE IAA002 = PKG_Constant.IAA002_ALR  --已打回
                  AND IAC001 = REC_TMP_PERSON.IAZ007;
            END IF;
         END IF;

         --不通过
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_NPS THEN
            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD, --待审
                   AAE013 = NULL
             WHERE IAA015 = PKG_Constant.IAA015_ADO --审核完毕
               AND IAZ005 =  REC_TMP_PERSON.IAZ005;

            --审核的是个人
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --已申报
                WHERE IAA002 = PKG_Constant.IAA002_NPS  --未通过
                  AND IAC001 = REC_TMP_PERSON.IAZ007;
            END IF;
         END IF;

         --通过
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_PAS THEN

            SELECT yae099,aab001
              INTO var_yae099 ,var_aab001
              FROM wsjb.AE02A1
             WHERE aac001 = REC_TMP_PERSON.iaz007
               AND aaz002 = prm_aaz002;

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD --待审
             WHERE IAA015 = PKG_Constant.IAA015_ADO --审核完毕
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            --审核的是个人
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --已申报
                WHERE IAA002 = PKG_Constant.IAA002_APS  --已通过
                  AND IAC001 = REC_TMP_PERSON.IAZ007;

               /*--人员增加的回退
               IF REC_TMP_PERSON.iaa001 = PKG_Constant.IAA001_ADD THEN
                  --调用人员回退过程
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

               --人员减少的回退
               IF REC_TMP_PERSON.iaa001 = PKG_Constant.IAA001_MIN THEN
                  --调用人员回退过程
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
                  人员增加[新参保与批量新参保]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_ADD,PKG_Constant.IAA001_PAD) THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[新参保 续保]
                     老方法 prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuCheckRollback(var_yae099,
                                  REC_TMP_PERSON.IAC001,
                                  prm_aae011,
                                  PKG_Constant.YAB003_JBFZX,
                                  '网上经办回退',
                                  prm_AppCode,
                                  prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  人员增加[人员险种新增]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_IAD THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[新参保 续保]
                     老方法 prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuAddCheckRollback(var_yae099,
                                    REC_TMP_PERSON.IAC001,
                                    prm_aae011,
                                    PKG_Constant.YAB003_JBFZX,
                                    '网上经办回退',
                                    prm_AppCode,
                                    prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  人员增加[人员续保]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_CIN THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[新参保 续保]
                     老方法 prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuContinueRollback(var_yae099,
                                    REC_TMP_PERSON.IAC001,
                                    prm_aae011,
                                    PKG_Constant.YAB003_JBFZX,
                                    '网上经办回退',
                                    prm_AppCode,
                                    prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  人员减少[人员暂停缴费与批量暂停缴费，退休人员死亡(与暂停雷同)]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_MIN,PKG_Constant.IAA001_PMI,PKG_Constant.IAA001_RPD) THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[停保 退休]
                     老方法 prc_AuditMonthInternetRpause
                  */

                  prc_PersonInsuPauseRollback(var_yae099,
                                      REC_TMP_PERSON.IAC001,
                                      prm_aae011,
                                      PKG_Constant.YAB003_JBFZX,
                                      '网上经办回退',
                                      prm_AppCode,
                                      prm_ErrorMsg
                                      );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  人员减少[在职转退休]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_RTR THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[停保 退休]
                     老方法 prc_AuditMonthInternetRpause
                  */

                  prc_PersonInsuPauseRollback(var_yae099,
                                      REC_TMP_PERSON.IAC001,
                                      prm_aae011,
                                      PKG_Constant.YAB003_JBFZX,
                                      '网上经办回退',
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


--回退单位缴费基数  ab02a8
    prc_Ab02a8UnitRollBack (
               var_aab001      ,
               prm_AppCode       ,
               prm_ErrorMsg     );

      IF prm_AppCode <> gn_def_OK THEN
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '回退单位缴费基数出错:' ||prm_ErrorMsg;
         RETURN;
      END IF;
      --删除审核明细
      DELETE
        FROM wsjb.IRAD22  a
       WHERE EXISTS
             (
              SELECT iaz009
                FROM wsjb.IRAD21
               WHERE iaz009 = a.iaz009
                 AND aaz002 = prm_aaz002
             );

      --删除审核事件
      DELETE
        FROM wsjb.IRAD21
       WHERE aaz002 = prm_aaz002;

      --删除日志记录
      DELETE
        FROM wsjb.AE02
       WHERE aaz002 = prm_aaz002;

      SELECT count(1)
        INTO countnum
        FROM wsjb.irad21  a,wsjb.irad22  b,wsjb.irad02  c
       WHERE a.iaz009 = b.iaz009
         AND b.iaz005 = c.iaz005
         AND c.iaa015 IN(PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)  --审核完毕或者放弃审核
         AND a.aaz002 = prm_aaz002;
      IF countnum > 0 THEN
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '还存在可回退的数据！';
         RETURN;
      END IF;

   EXCEPTION
      WHEN OTHERS THEN
      /*关闭打开的游标*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '数据库错误:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
      RETURN;
   END prc_RollBackAMIR;

   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuCheckRollback
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[人员新参保审核]回退
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuCheckRollback(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                     prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                     prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                     prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                     prm_aae013       IN    irac01.aae013%TYPE ,    --备注
                                     prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                     prm_ErrMsg       OUT   VARCHAR2  )    --错误内容
   IS
      num_count       NUMBER;
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --个人编号
      var_aae140_01   VARCHAR2(2);         --是否参加了企业养老
      var_aae140_06   VARCHAR2(2);         --是否参加了机关养老
      var_aae140_02   VARCHAR2(2);         --是否参加了失业
      var_aae140_03   VARCHAR2(2);         --是否参加了基本医疗
      var_aae140_04   VARCHAR2(2);         --是否参加了工伤
      var_aae140_05   VARCHAR2(2);         --是否参加了生育
      var_aae140_07   VARCHAR2(2);         --是否参加了大额
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

      var_aac001    := rec_irac01.aac001;        --人员编号
      var_aae140_01 := rec_irac01.aae110;        --是否参加了企业养老
      var_aae140_06 := rec_irac01.aae120;        --是否参加了机关养老
      var_aae140_02 := rec_irac01.aae210;        --是否参加了失业
      var_aae140_03 := rec_irac01.aae310;        --是否参加了基本医疗
      var_aae140_04 := rec_irac01.aae410;        --是否参加了工伤
      var_aae140_05 := rec_irac01.aae510;        --是否参加了生育
      var_aae140_07 := rec_irac01.aae311;        --是否参加了大额
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

      ELSE  --如果是单养老的话
       DELETE FROM XASI2.ac01 WHERE aac001 = rec_irac01.aac001;
      END IF;

      --更新申报信息的人员编号
     UPDATE wsjb.IRAC01
        SET AAC001 = prm_iac001
      WHERE IAC001 = prm_iac001;

     --更新申报明细信息的人员编号
     UPDATE wsjb.IRAD02
        SET IAZ008 = prm_iac001
      WHERE IAZ007 = prm_iac001;

      DELETE
        FROM wsjb.IRAC01A3
       WHERE aac001 = var_aac001
         AND aab001 = rec_irac01.aab001;

   EXCEPTION
      WHEN OTHERS THEN
        /*关闭打开的游标*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuCheckRollback;

   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuAddCheckRollback
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[人员险种新增审核]回退
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuAddCheckRollback(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                        prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                        prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                        prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                        prm_aae013       IN    irac01.aae013%TYPE ,    --备注
                                        prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                        prm_ErrMsg       OUT   VARCHAR2  )    --错误内容
   IS
      num_count       NUMBER;
      var_aac001      xasi2.ac01.aac001%TYPE;    --个人编号
      var_aae140_01   VARCHAR2(2);         --是否参加了企业养老
      var_aae140_06   VARCHAR2(2);         --是否参加了机关养老
      var_aae140_02   VARCHAR2(2);         --是否参加了失业
      var_aae140_03   VARCHAR2(2);         --是否参加了基本医疗
      var_aae140_04   VARCHAR2(2);         --是否参加了工伤
      var_aae140_05   VARCHAR2(2);         --是否参加了生育
      var_aae140_07   VARCHAR2(2);         --是否参加了大额
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

      var_aac001    := rec_irac01.aac001;        --人员编号
      var_aae140_01 := rec_irac01.aae110;        --是否参加了企业养老
      var_aae140_06 := rec_irac01.aae120;        --是否参加了机关养老
      var_aae140_02 := rec_irac01.aae210;        --是否参加了失业
      var_aae140_03 := rec_irac01.aae310;        --是否参加了基本医疗
      var_aae140_04 := rec_irac01.aae410;        --是否参加了工伤
      var_aae140_05 := rec_irac01.aae510;        --是否参加了生育
      var_aae140_07 := rec_irac01.aae311;        --是否参加了大额
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
        /*关闭打开的游标*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuAddCheckRollback;

   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuContinueRollback
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[人员续保审核]回退
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuContinueRollback(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                        prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                        prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                        prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                        prm_aae013       IN    irac01.aae013%TYPE ,    --备注
                                        prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                        prm_ErrMsg       OUT   VARCHAR2  )    --错误内容
   IS
      num_count       NUMBER;
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --个人编号
      var_aae140_01   VARCHAR2(2);         --是否参加了企业养老
      var_aae140_06   VARCHAR2(2);         --是否参加了机关养老
      var_aae140_02   VARCHAR2(2);         --是否参加了失业
      var_aae140_03   VARCHAR2(2);         --是否参加了基本医疗
      var_aae140_04   VARCHAR2(2);         --是否参加了工伤
      var_aae140_05   VARCHAR2(2);         --是否参加了生育
      var_aae140_07   VARCHAR2(2);         --是否参加了大额
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

      var_aac001    := rec_irac01.aac001;        --人员编号
      var_aae140_01 := rec_irac01.aae110;        --是否参加了企业养老
      var_aae140_06 := rec_irac01.aae120;        --是否参加了机关养老
      var_aae140_02 := rec_irac01.aae210;        --是否参加了失业
      var_aae140_03 := rec_irac01.aae310;        --是否参加了基本医疗
      var_aae140_04 := rec_irac01.aae410;        --是否参加了工伤
      var_aae140_05 := rec_irac01.aae510;        --是否参加了生育
      var_aae140_07 := rec_irac01.aae311;        --是否参加了大额
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
        /*关闭打开的游标*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuContinueRollback;

   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuPauseRollback
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[人员停保审核]回退
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuPauseRollback(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                    prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                    prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                    prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                    prm_aae013       IN    irac01.aae013%TYPE ,    --备注
                                    prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                    prm_ErrMsg       OUT   VARCHAR2  )    --错误内容
   IS
      num_count       NUMBER;
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --个人编号
      var_aae140_01   VARCHAR2(2);         --是否参加了企业养老
      var_aae140_06   VARCHAR2(2);         --是否参加了机关养老
      var_aae140_02   VARCHAR2(2);         --是否参加了失业
      var_aae140_03   VARCHAR2(2);         --是否参加了基本医疗
      var_aae140_04   VARCHAR2(2);         --是否参加了工伤
      var_aae140_05   VARCHAR2(2);         --是否参加了生育
      var_aae140_07   VARCHAR2(2);         --是否参加了大额
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
      var_aae140_01 := rec_irac01.aae110;        --是否参加了企业养老
      var_aae140_06 := rec_irac01.aae120;        --是否参加了机关养老
      var_aae140_02 := rec_irac01.aae210;        --是否参加了失业
      var_aae140_03 := rec_irac01.aae310;        --是否参加了基本医疗
      var_aae140_04 := rec_irac01.aae410;        --是否参加了工伤
      var_aae140_05 := rec_irac01.aae510;        --是否参加了生育
      var_aae140_07 := rec_irac01.aae311;        --是否参加了大额
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
        /*关闭打开的游标*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuPauseRollback;

   /*****************************************************************************
   ** 过程名称 : prc_PersonInsuToRetireRollback
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[在职转退休审核]回退
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuToRetireRollback(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                        prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                                        prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                                        prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                                        prm_aae013       IN    irac01.aae013%TYPE ,    --备注
                                        prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                                        prm_ErrMsg       OUT   VARCHAR2  )    --错误内容
   IS
      num_count       NUMBER;
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --个人编号
   BEGIN
      prm_AppCode  := PKG_Constant.GN_DEF_OK;
      prm_ErrMsg   := '';
      var_aac001   := '';

   EXCEPTION
      WHEN OTHERS THEN
        /*关闭打开的游标*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuToRetireRollback;

   /*****************************************************************************
   ** 过程名称 : prc_RollBackAMIRPer
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：回退月申报审核[个人信息回退 停保]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aac001       IN     irac01.aac001%TYPE,--人员编号
   **           prm_yea099       IN     ae02a2.yae099%TYPE,--业务流水号
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-06   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_RollBackAMIRPer (
      prm_iac001       IN     irac01.iac001%TYPE,--申报人员编号
      prm_yae099       IN     xasi2.ac02a2.yae099%TYPE,--业务流水号
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      --定义游标，获取暂停缴费人员的信息
      CURSOR cur_pause_aae140 IS
      SELECT a.AAC001, --个人编号,VARCHAR2
             b.AAB001, --单位编号,VARCHAR2
             a.AAE140  --险种    ,VARCHAR2
        FROM xasi2.AC02A2 a,wsjb.IRAC01  b  --参保信息表
       WHERE a.AAC001 = b.aac001
         AND b.iac001 = prm_iac001
         AND a.yae099 = prm_yae099
         AND a.AAC031 = PKG_Constant.AAC031_CBJF;
   BEGIN

      prm_AppCode := PKG_Constant.gn_def_OK ;
      prm_ErrorMsg:= '';

      IF prm_yae099 IS NULL THEN
         prm_AppCode := gn_def_ERR;
         prm_ErrorMsg  := '业务流水号不能为空！';
         RETURN;
      END IF;

      IF prm_iac001 IS NULL THEN
         prm_AppCode := gn_def_ERR;
         prm_ErrorMsg  := '申报人员编号不能为空！';
         RETURN;
      END IF;

      FOR rec_pause_aae140 in cur_pause_aae140 LOOP
         --回退停保信息
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
         --回退事件信息
         DELETE
           FROM xasi2.AC05
          WHERE aae140 = rec_pause_aae140.aae140
            AND aac001 = rec_pause_aae140.AAC001
            AND yae099 = prm_yae099;

         --回退单位人员险种信息
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
      /*关闭打开的游标*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '数据库错误:'|| SQLERRM||dbms_utility.format_error_backtrace  ;
      RETURN;
   END prc_RollBackAMIRPer;

   /*****************************************************************************
   ** 过程名称 : prc_ResetASMR
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：重置月申报审核
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位编号
   **           prm_iaa100       IN     irad01.iaa100%TYPE,--申报月度
   **           prm_aae011       IN     irad31.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-09   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_ResetASMR (
      prm_aab001       IN     irab01.aab001%TYPE,--单位编号
      prm_iaa100       IN     irad01.iaa100%TYPE,--申报月度
      prm_aae011       IN     irad31.aae011%TYPE,--经办人
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum     NUMBER;
      v_msg        VARCHAR2(200);
      var_aaz002   VARCHAR2(15);
      --需要重置的申报数据
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

      --需要重置的审核数据
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
      -- 检查ab08是否有数据
      SELECT count(1)
        INTO countnum
        FROM xasi2.ab08 a
       WHERE a.aab001 = prm_aab001
         AND a.aae003 = prm_iaa100
         AND a.yae517 = 'H01';
      IF countnum > 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '当前社保助记码单位已有核定数据，不能重置!';
         RETURN;
      END IF;

      -- 检查irab08是否有数据
      SELECT count(1)
        INTO countnum
        FROM wsjb.irab08  a
       WHERE a.aab001 = prm_aab001
         AND a.aae003 = prm_iaa100
         AND a.yae517 = 'H01';
      IF countnum > 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '当前社保助记码单位已有养老核定数据，不能重置!';
         RETURN;
      END IF;



      --检查是否符合重置条件
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
         prm_ErrorMsg := '当前社保助记码单位不存在月申报数据，不能重置!';
         RETURN;
      END IF;

      --检查是否存在审核记录
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





      --有审核记录，回退所有审核
      IF countnum > 0 THEN
         FOR rec_irad21 in irad21Cur LOOP
             prc_RollBackAMIR(rec_irad21.aaz002,--审核业务日志
                              prm_iaa100       ,--申报月度
                              prm_aab001       ,--申报单位
                              prm_aae011       ,--经办人
                              prm_AppCode      ,
                              prm_ErrorMsg
                              );
             IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                RETURN;
             END IF;
         END LOOP;
      END IF;

      --回退正常的人员信息
      DELETE
        FROM wsjb.IRAC01
       WHERE aab001 = prm_aab001
         AND iaa100 = prm_iaa100
         AND iaa001 = PKG_Constant.IAA001_GEN;

      --回退申报过程
      FOR rec_person in personCur LOOP
         IF rec_person.iaa020 = PKG_Constant.IAA020_GR THEN
            --回退申报信息状态
            UPDATE wsjb.IRAC01
               SET iaa002 = PKG_Constant.IAA002_WIR,
                   iaa100 = NULL
             WHERE IAC001 = rec_person.iaz007;
         END IF;
         --回退申报明细
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

      --回退申报事件
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
      /*关闭打开的游标*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '数据库错误:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
      RETURN;
   END prc_ResetASMR;


   /*****************************************************************************
   ** 过程名称 : prc_UnitInfoMaintainAuditRollback
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：回退单位信息维护审核
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE  ,--单位编号
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-011   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_UnitInfoAuditRollback (
      prm_aab001       IN     irab01.aab001%TYPE,  --单位编号
      prm_iab001       IN     irab01.iab001%TYPE,  --单位信息编号
      prm_iaz005       IN     irad02.iaz005%TYPE,  --申报明细ID
      prm_iaz009       IN     irad21.iaz009%TYPE,  --审核事件ID
      prm_iaz012       IN     irad32.iaz012%TYPE,  --修改事件ID
      prm_iaa002       IN     irab01.iaa002%TYPE,  --审核结果
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

      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;

      /*必要的数据校验*/
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '单位助记码不能为空!';
         RETURN;
      END IF;

      IF prm_iab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '单位信息编号不能为空!';
         RETURN;
      END IF;

      IF prm_iaz005 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '申报明细ID不能为空!';
         RETURN;
      END IF;

      IF prm_iaa002 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '审核结果不能为空!';
         RETURN;
      END IF;

       --是否存在审核记录
       SELECT COUNT(1) INTO n_count FROM
        wsjb.IRAD22  a WHERE a.iaz005 = prm_iaz005;
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := '没有找到对应的审核信息！！！';
        RETURN;
       END IF;

       --是否存在申报信息
       SELECT COUNT(1) INTO n_count FROM
        wsjb.IRAD02  a WHERE a.iaz005 = prm_iaz005;
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := '没有找到对应的申报信息！！！';
        RETURN;
       END IF;

       --是否存在修改信息
       SELECT COUNT(1) INTO n_count FROM
        wsjb.IRAD32  a WHERE a.iaz012 = prm_iaz012 and a.aae100 = '1';
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := '没有找到对应的修改明细信息！！！';
        RETURN;
       END IF;

       --是否存在单位申报信息
       SELECT COUNT(1) INTO n_count FROM
        wsjb.IRAB01  a WHERE a.iab001 = prm_iab001;
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := '没有找到对应的单位申报信息！！！';
        RETURN;
       END IF;

       --是否存在单位信息
       SELECT COUNT(1) INTO n_count FROM
        xasi2.AB01 a WHERE a.aab001 = prm_aab001;
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := '没有找到对应的单位信息！！！';
        RETURN;
       END IF;

       /*获取其他信息*/
       --申报批次号
       SELECT iaz004
       into v_iaz004
       From wsjb.IRAD02
       where iaz005 = prm_iaz005;


       --根据审核结果进行回退
       IF prm_iaa002 = '2' THEN
        --拼接更新字符串
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

       --更新IRAD41的数据
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
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '预约信息出现错误！！！'|| SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;
      END;

       --更新IRAD02申报明细表
       UPDATE wsjb.IRAD02  SET
            iaa015 = PKG_Constant.IAA015_WAD,
            aae013 = null
       WHERE
            iaz005 = prm_iaz005;

       --更新IRAD01
       UPDATE wsjb.IRAD01  SET
             aae013 = null
       WHERE
             iaz004 = v_iaz004;

       --更新IRAB01
       UPDATE wsjb.IRAB01  SET
            iaa002 = PKG_Constant.IAA002_AIR
       WHERE
            iab001 = prm_iab001;

       --更新IRAD31
       UPDATE wsjb.IRAD31  SET
            iaa019 = PKG_Constant.IAA019_IR
       WHERE
            iaz007 = prm_iab001
            and iaa011 = PKG_Constant.IAA011_EIM
            and iaa019 = PKG_Constant.IAA019_AD;

       --删除审核记录和审核明细
       SELECT aaz002
       into v_aaz002
       FROM wsjb.irad21  where iaz009 = prm_iaz009;

       DELETE FROM wsjb.IRAD22
       WHERE iaz009 = prm_iaz009;

       DELETE FROM wsjb.IRAD21
       WHERE iaz009 = prm_iaz009;

       --删除日志
       DELETE FROM wsjb.AE02
       WHERE aaz002 = v_aaz002;

   EXCEPTION
      WHEN OTHERS THEN
      /*关闭打开的游标*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '数据库错误:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
      RETURN;
   END prc_UnitInfoAuditRollback;


    /*****************************************************************************
   ** 过程名称 : prc_PersonInfoAuditRollback
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：回退个人信息维护审核
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aac001       IN     irab01.aab001%TYPE  ,--个人编号
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-011   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInfoAuditRollback (
      prm_aac001       IN     irac01.aac001%TYPE,  --个人编号
      prm_iac001       IN     irac01.iac001%TYPE,  --个人信息编号
      prm_iaz005       IN     irad02.iaz005%TYPE,  --申报明细ID
      prm_iaz009       IN     irad21.iaz009%TYPE,  --审核事件ID
      prm_iaz012       IN     irad32.iaz012%TYPE,  --修改事件ID
      prm_iaa002       IN     irab01.iaa002%TYPE,  --审核结果
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

      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;

      /*必要的数据校验*/
      IF prm_aac001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '个人编号不能为空!';
         RETURN;
      END IF;

      IF prm_iac001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '个人信息编号不能为空!';
         RETURN;
      END IF;

      IF prm_iaz005 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '申报明细ID不能为空!';
         RETURN;
      END IF;

      IF prm_iaa002 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '审核结果不能为空!';
         RETURN;
      END IF;

       --是否存在审核记录
       SELECT COUNT(1) INTO n_count FROM
        wsjb.IRAD22  a WHERE a.iaz005 = prm_iaz005;
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := '没有找到对应的审核信息！！！';
        RETURN;
       END IF;

       --是否存在申报信息
       SELECT COUNT(1) INTO n_count FROM
        wsjb.IRAD02  a WHERE a.iaz005 = prm_iaz005;
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := '没有找到对应的申报信息！！！';
        RETURN;
       END IF;

       --是否存在修改信息
       SELECT COUNT(1) INTO n_count FROM
        wsjb.IRAD32 a WHERE a.iaz012 = prm_iaz012 and a.aae100 = '1';
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := '没有找到对应的修改明细信息！！！';
        RETURN;
       END IF;

       --是否存在个人申报信息
       SELECT COUNT(1) INTO n_count FROM
         wsjb.irac01  a WHERE a.iac001 = prm_iac001;
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := '没有找到对应的单位申报信息！！！';
        RETURN;
       END IF;

       --是否存在个人信息
       SELECT COUNT(1) INTO n_count FROM
        xasi2.AC01 a WHERE a.aac001 = prm_aac001;
       IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := '没有找到对应的个人信息！！！';
        RETURN;
       END IF;

       /*获取其他信息*/
       --申报批次号
       SELECT iaz004
       into v_iaz004
       From wsjb.IRAD02
       where iaz005 = prm_iaz005;

       --单位编号
       SELECT aab001
       into v_aab001
       From wsjb.IRAC01
       where iac001 = prm_iac001;


       --根据审核结果进行回退
       IF prm_iaa002 = '2' THEN
        --拼接更新字符串
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

       --更新IRAD41的数据
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
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '预约信息出现错误！！！'|| SQLERRM||dbms_utility.format_error_backtrace  ;
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
             prm_ErrorMsg := '农民工标志为空！！！'|| SQLERRM||dbms_utility.format_error_backtrace  ;
             RETURN;
          -- WHEN TOO_MANY_ROWS THEN
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
             /*关闭打开的游标*/
             ROLLBACK;
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '农民工标志出现错误！！！'|| SQLERRM ||dbms_utility.format_error_backtrace ;
             RETURN;
       END;

       --更新IRAD02申报明细表
       UPDATE wsjb.IRAD02  SET
            iaa015 = PKG_Constant.IAA015_WAD,
            aae013 = null
       WHERE
            iaz005 = prm_iaz005;

       --更新IRAD01
       UPDATE wsjb.IRAD01  SET
             aae013 = null
       WHERE
             iaz004 = v_iaz004;

       --更新IRAC01
       UPDATE wsjb.IRAC01  SET
            iaa002 = PKG_Constant.IAA002_AIR
       WHERE
            iac001 = prm_iac001;

       --更新IRAD31
       UPDATE wsjb.IRAD31  SET
            iaa019 = PKG_Constant.IAA019_IR
       WHERE
            iaz007 = prm_iac001
            and iaa011 = PKG_Constant.IAA011_PIM
            and iaa019 = PKG_Constant.IAA019_AD;

       --删除审核记录和审核明细
       SELECT aaz002
       into v_aaz002
       FROM wsjb.irad21  where iaz009 = prm_iaz009;

       DELETE FROM wsjb.IRAD22
       WHERE iaz009 = prm_iaz009;

       DELETE FROM wsjb.IRAD21
       WHERE iaz009 = prm_iaz009;

       --删除日志
       DELETE FROM wsjb.AE02
       WHERE aaz002 = v_aaz002;

   EXCEPTION
      WHEN OTHERS THEN
      /*关闭打开的游标*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '数据库错误:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
      RETURN;
   END prc_PersonInfoAuditRollback;

   /*****************************************************************************
   ** 过程名称 : FUN_GETAAB001C
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：获取社保助记码
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab020       IN     irab01.aab001%TYPE  ,--个人编号
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-011   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
  /*获取社保助记码*/
 PROCEDURE prc_GETAAB001C(prm_aab020     IN     irab01.aab020%TYPE,--经济类型
                          prm_yab006     IN     irab01.yab006%TYPE,--税务机构
                          prm_aab001     OUT    VARCHAR2,          --单位编号
                          prm_AppCode    OUT    VARCHAR2  ,
                          prm_ErrorMsg   OUT    VARCHAR2 )
  IS
     str_Prefixion    VARCHAR2(2);
     str_Sequence     VARCHAR2(20);
     v_aab001         VARCHAR2(15);
     str_name         VARCHAR2(20);
  BEGIN

    /*初始化变量*/
    prm_AppCode  := gn_def_OK;
    prm_ErrorMsg := '';
    prm_aab001 := '';

    --第一类 前缀'0' 代表 国有、国有独资
    IF prm_aab020 IN ('110','151') THEN
       str_Prefixion :='0';
       str_name :='SEQ_0_AAB001';
    END IF;
    --二类 前缀 '1' 代表 集体企业
    IF prm_aab020 = '120' THEN
       str_Prefixion :='1';
       str_name :='SEQ_1_AAB001';
    END IF;
    --第三类 前缀 '2'、'4'、'5'、'6'、'7' 满位递增 代表 股份、私营、其他等
    IF prm_aab020 IN ('130','140','141','142','143','149','150','159','160','170','171','172','173','174','190') THEN
       BEGIN
         str_Prefixion :='2';
         str_name :='SEQ_2_AAB001';
         EXECUTE IMMEDIATE 'SELECT '||str_name||'.NEXTVAL FROM DUAL'
         INTO v_aab001;
          EXCEPTION
             WHEN OTHERS THEN
             IF LENGTH(v_aab001) > 4 OR v_aab001 IS NULL THEN --如果前缀'2'的后四位用完 则使用前缀为'5'的序列号 20141217 zhujing
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
       IF LENGTH(v_aab001) > 4 OR v_aab001 IS NULL THEN --如果前缀'2'的后四位用完 则使用前缀为'5'的序列号 20141217 zhujing
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

       --直接将序列号返回
       str_Sequence := '00000'||v_aab001;--补位到4位数
       v_aab001 := SUBSTR(str_Sequence,LENGTH(str_Sequence)-3,4);
       v_aab001 := str_Prefixion || v_aab001;
       prm_aab001 := v_aab001;
       RETURN;
    END IF;
    --第四类 前缀'3' 代表 港澳台、中外合资,外资等
    IF prm_aab020 IN('200','210','220','230','240','300','310','320','330','340') THEN
       str_Prefixion :='3';
       str_name :='SEQ_3_AAB001';
    END IF;
    --第五类 前缀'8' 高新区管委会
    IF prm_aab020 = '800' THEN
       str_Prefixion :='8';
       str_name :='SEQ_8_AAB001';
    END IF;
    --第六类 前缀'9' 其他参保单位和参保人
    IF prm_aab020 IN('100','175','179','290','390','900') THEN
       str_Prefixion :='9';
       str_name :='SEQ_9_AAB001';
    END IF;
    --第七类 前缀'66' 沣渭企业单位
    IF prm_aab020 = '701' THEN
       str_Prefixion :='66';
       str_name :='SEQ_6_AAB001';
    END IF;
    --第八类 前缀'72' 沣渭机关单位
    IF prm_aab020 = '700' THEN
       str_Prefixion :='72';
       str_name :='SEQ_7_AAB001';
    END IF;

    EXECUTE IMMEDIATE 'SELECT '||str_name||'.NEXTVAL FROM DUAL'
     INTO v_aab001;

    --直接将序列号返回
    str_Sequence := '00000'||v_aab001;--补位到4位数
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
       /*关闭打开的游标*/
       ROLLBACK;
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '数据库错误:'|| SQLERRM||dbms_utility.format_error_backtrace  ;
       RETURN;
   END prc_GETAAB001C;

   /*****************************************************************************
   ** 过程名称 : FUN_GETAAB001
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：获取社保助记码
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab020       IN     irab01.aab001%TYPE  ,--个人编号
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-011   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   /*获取社保助记码*/
   FUNCTION  FUN_GETAAB001 (prm_aab020     IN     irab01.aab020%TYPE, --经济类型
                            prm_yab006     IN     irab01.yab006%TYPE) --税务机构
   RETURN VARCHAR2
   IS
      n_count          NUMBER;
      v_aab001c        VARCHAR2(15);
      s_Appcode        VARCHAR2(12);
      s_Errormsg       VARCHAR2(200);
   BEGIN

      /*初始化变量*/
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
       /*关闭打开的游标*/
       RETURN '';
   END FUN_GETAAB001;

   /*****************************************************************************
   ** 过程名称 : prc_checkAndFinaPlan
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：单位应收核定和征集
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001     IN     irab01.aab001%TYPE,--单位编号
   **           prm_aae002     IN     ab08.aae003%TYPE,  --费款所属期
   **           prm_yae010     IN     aa05.yae010%TYPE,  --费用来源:地税征收
   **           prm_aae011     IN     ab08.aae011%TYPE,  --经办人员
   **           prm_yab003     IN     ab02.yab003%TYPE,  --社保经办机构
   **           prm_flag       IN     VARCHAR2,          --提交标志 0 提交 1不提交
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-17   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   /*单位应收核定和征集*/
   PROCEDURE prc_checkAndFinaPlan(prm_aab001     IN     irab01.aab001%TYPE,--单位编号
                                  prm_aae002     IN      xasi2.ab08.aae003%TYPE,  --费款所属期
                                  prm_yae010     IN      xasi2.aa05.yae010%TYPE,  --费用来源:地税征收
                                  prm_aae011     IN      xasi2.ab08.aae011%TYPE,  --经办人员
                                  prm_flag       IN     VARCHAR2,          --提交标志 0 提交 1不提交
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

      --所有地税险种，分险种征集
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
         and a.aab166 = '0'      --未征集
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
      /*初始化变量*/
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
         prm_ErrorMsg := '单位没有可用的征集方式.';
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
            prm_ErrorMsg := '单位已经存在核定月份的企业养老应收核定数据:';
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
         prm_ErrorMsg := '单位已经存在核定月份的应收核定数据:';
         RETURN;
      END IF;

     -- 申报过程原代码
      SELECT COUNT(1)
        INTO countnum
        FROM xasi2.AB08A8
       WHERE AAB001 = NVL(prm_aab001,v_aab001)
         AND YAE517 = 'H01'
         AND YAB538 = '1' -- modify by whm 不卡离退休的 20190419
         AND AAE003 = prm_aae002;

      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '单位已经存在核定月份的实收数据:';
         RETURN;
      END IF;

      v_yae518 := xasi2.PKG_COMM.FUN_GETSEQUENCE(NULL,'YAE518');
      FOR rec_ac01a3 IN CUR_AC01A3 LOOP
        n_aab213     :=0;
        IF rec_ac01a3.yac004 IS NULL OR rec_ac01a3.yac004 = 0 THEN
         --调用保底封顶过程，获取缴费基数和缴费工资
         xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase
                               (rec_ac01a3.aac001   ,     --个人编码
                                rec_ac01a3.aab001   ,     --单位编码
                                rec_ac01a3.aac040   ,     --缴费工资
                                rec_ac01a3.yac503   ,     --工资类别
                                rec_ac01a3.aae140   ,     --险种类型
                                '00'                ,     --缴费人员类别
                                rec_ac01a3.yab136   ,     --单位管理类型（区别独立缴费人员）
                                prm_aae002   ,     --费款所属期
                                PKG_Constant.YAB003_JBFZX,     --参保分中心
                                num_yac004   ,     --缴费基数
                                prm_AppCode  ,     --错误代码
                                prm_ErrorMsg );    --错误内容
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            ROLLBACK;
            prm_ErrorMsg := '人员:'||rec_ac01a3.aac001 ||'险种'||rec_ac01a3.aae140||'出错，'||prm_ErrorMsg ;
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

     -- modify by whm 20190428 201905 后养老单位部分调整为0.16 start
     --单位划统筹
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
      else    --201905 以前的不变
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
      -- modify by whm 20190428 201905 后养老单位部分调整为0.16 end

     var_YAE202:=  xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAE202');
        --插入人员明细
        INSERT INTO wsjb.irac08a1 (YAE202,             --明细流水号,VARCHAR2
                               AAC001,             --个人编号,VARCHAR2
                               AAB001,             --单位编号,VARCHAR2
                               AAE140,             --险种类型,VARCHAR2
                               AAE003,             --做帐期号,NUMBER
                               AAE002,             --费款所属期,NUMBER
                               AAE143,             --缴费类型,VARCHAR2
                               YAE010,             --费用来源,VARCHAR2
                               YAC505,             --参保缴费人员类别,VARCHAR2
                               YAC503,             --工资类别,VARCHAR2
                               AAC040,             --缴费工资,NUMBER
                               YAA333,             --账户基数,NUMBER
                               AAE180,             --缴费基数,NUMBER
                               YAB157,             --个人缴费划入帐户金额,NUMBER
                               YAB158,             --个人缴费划入统筹金额,NUMBER
                               AAB212,             --单位缴费划入帐户金额,NUMBER
                               AAB213,             --单位缴费划入统筹金额,NUMBER
                               AAB162,             --应缴滞纳金金额,NUMBER
                               YAE518,             --核定流水号,VARCHAR2
                               AAE076,             --计划流水号,VARCHAR2
                               AAE011,             --经办人,NUMBER
                               AAE036,             --经办时间,DATE
                               YAB003,             --社保经办机构,VARCHAR2
                               YAB139,             --参保所属分中心,VARCHAR2
                               AAE114)             --缴费标志,VARCHAR2)
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
                  '0申报');
      END IF;


--------------------------------------------------------------------------------------------
--      FOR rec_ac01a3 IN CUR_AC01A3 LOOP
--         --调用保底封顶过程，获取缴费基数和缴费工资
--         xasi2_zs.pkg_P_Comm_CZ.prc_P_getContributionBase
--                               (rec_ac01a3.aac001   ,     --个人编码
--                                rec_ac01a3.aab001   ,     --单位编码
--                                rec_ac01a3.aac040   ,     --缴费工资
--                                rec_ac01a3.yac503   ,     --工资类别
--                                rec_ac01a3.aae140   ,     --险种类型
--                                '00'                ,     --缴费人员类别
--                                rec_ac01a3.yab136   ,     --单位管理类型（区别独立缴费人员）
--                                prm_aae002   ,     --费款所属期
--                                PKG_Constant.YAB003_JBFZX,     --参保分中心
--                                num_yac004   ,     --缴费基数
--                                prm_AppCode  ,     --错误代码
--                                prm_ErrorMsg );    --错误内容
--         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
--            ROLLBACK;
--            prm_ErrorMsg := '人员:'||rec_ac01a3.aac001 ||'险种'||rec_ac01a3.aae140||'出错，'||prm_ErrorMsg ;
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
--             INSERT INTO irac08a1(YAE202,             --明细流水号,VARCHAR2
--                               AAC001,             --个人编号,VARCHAR2
--                               AAB001,             --单位编号,VARCHAR2
--                               AAE140,             --险种类型,VARCHAR2
--                               AAE003,             --做帐期号,NUMBER
--                               AAE002,             --费款所属期,NUMBER
--                               AAE143,             --缴费类型,VARCHAR2
--                               YAE010,             --费用来源,VARCHAR2
--                               YAC505,             --参保缴费人员类别,VARCHAR2
--                               YAC503,             --工资类别,VARCHAR2
--                               AAC040,             --缴费工资,NUMBER
--                               YAA333,             --账户基数,NUMBER
--                               AAE180,             --缴费基数,NUMBER
--                               YAB157,             --个人缴费划入帐户金额,NUMBER
--                               YAB158,             --个人缴费划入统筹金额,NUMBER
--                               AAB212,             --单位缴费划入帐户金额,NUMBER
--                               AAB213,             --单位缴费划入统筹金额,NUMBER
--                               AAB162,             --应缴滞纳金金额,NUMBER
--                               YAE518,             --核定流水号,VARCHAR2
--                               AAE076,             --计划流水号,VARCHAR2
--                               AAE011,             --经办人,NUMBER
--                               AAE036,             --经办时间,DATE
--                               YAB003,             --社保经办机构,VARCHAR2
--                               YAB139,             --参保所属分中心,VARCHAR2
--                               AAE114)             --缴费标志,VARCHAR2)
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
            prm_ErrorMsg := '没有获取到序列号yab222';
            RETURN;
         END IF;


         FOR rec_yae010 IN CUR_YAE010_HD LOOP
            DELETE FROM xasi2.TMP_yshd_ab02 WHERE aab001 = NVL(prm_aab001,v_aab001);
            --核定临时数据
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
               prm_ErrorMsg := '没有获取到序列号jobid';
               RETURN;
           END IF;
            --判断临时表是否存在数据
            SELECT COUNT(1)
              INTO countnum
              FROM xasi2.TMP_yshd_ab02
             WHERE yab222 = v_yab222;

            IF countnum < 1 THEN
              prm_AppCode  :=  gn_def_ERR;
              prm_ErrorMsg     := '没有需要做账的临时表数据'||countnum;
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
               prm_ErrorMsg := '调用核定过程prc_p_checkallControl出错:' ||prm_ErrorMsg||v_jobid;
               RETURN;
           END IF;
         END LOOP;

         /*
         0申报 即没有缴费人员的核定情况不存在应收核定数据，而只有到账的数据；
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
            prm_ErrorMsg := '没有核定成功!';
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
            SET AAE013 = AAE013||'网报核定:'||V_AAC003
          WHERE aab001 = NVL(prm_aab001,v_aab001)
            --and yae010 = prm_yae010
            and aae003 = prm_aae002
            and yab222 = v_yab222
            and aab166 = '0';

         --地税征集

      SELECT COUNT(1)
        INTO n_count
        FROM  xasi2.AB08 a,xasi2.ab02 b
       WHERE a.aab001 = b.aab001
         and a.aae140 = b.aae140
         and a.aab001 = NVL(prm_aab001,v_aab001)
         and a.aae003 = prm_aae002
         and a.yae517 = 'H01'
         and a.aab166 = '0'      --未征集
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
                                and a.aab166 = '0'      --未征集
                                and b.aab033 = '04';

               v_aae076 := xasi2.PKG_comm.fun_GetSequence(NULL,'aae076');
               IF v_aae076 IS NULL THEN
                  prm_AppCode  :=  gn_def_ERR;
                  prm_ErrorMsg := '没有获取到序列号aae076';
                  RETURN;
               END IF;
               xasi2.pkg_p_fundCollection.prc_crtFinaPlan('P01',--地税征收
                                                       '18',--柜台收款
                                                       prm_aae011,
                                                       PKG_Constant.YAB003_JBFZX,
                                                       v_aae076  ,
                                                       prm_AppCode,
                                                       prm_ErrorMsg);
               IF prm_AppCode <> gn_def_OK THEN
                  ROLLBACK;
                  prm_AppCode  :=  gn_def_ERR;
                  prm_ErrorMsg := '调用征集过程prc_crtFinaPlan出错:' ||prm_ErrorMsg||v_jobid;
                  RETURN;
               END IF;
            END LOOP;
         END IF;

         --自筹资金征集

       SELECT COUNT(1)
        INTO n_count
        FROM  xasi2.AB08 a,xasi2.ab02 b
       WHERE a.aab001 = b.aab001
         and a.aae140 = b.aae140
         and a.aab001 = NVL(prm_aab001,v_aab001)
         and a.aae003 = prm_aae002
         and a.yae517 = 'H01'
         and a.aab166 = '0'      --未征集
         and b.aab033 IN('01','02');     --自筹资金

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
                          and a.aab166 = '0'      --未征集
                          and b.aab033 IN('01','02');      --自筹资金

            v_aae076 := xasi2.PKG_comm.fun_GetSequence(NULL,'aae076');
            IF v_aae076 IS NULL THEN
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := '没有获取到序列号aae076';
               RETURN;
            END IF;
            xasi2.pkg_p_fundCollection.prc_crtFinaPlan('P01',--柜台自收
                                                     '10',--柜台收款
                                                     prm_aae011,
                                                     PKG_Constant.YAB003_JBFZX,
                                                     v_aae076  ,
                                                     prm_AppCode,
                                                     prm_ErrorMsg);
            IF prm_AppCode <> gn_def_OK THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := '调用征集过程prc_crtFinaPlan自筹资金时出错:' ||prm_ErrorMsg||v_jobid;
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
            --插入自筹月报档案编号
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
        发送短消息
      */

      DELETE FROM wsjb.IRAD23_TMP ;
      INSERT INTO wsjb.IRAD23_TMP (aab001) VALUES (v_aab001);
      SELECT aab004
        INTO v_aab004
        FROM xasi2.ab01
       WHERE  aab001 = v_aab001;
      v_msg := v_aab004||'用户：您的'||prm_aae002||'月度申报审核已通过，审于：'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||',请按照打印单据尽快缴费.';
      PKG_Insurance.prc_MessageSend(prm_aae011,
                                    'A04',
                                    v_msg,
                                    prm_AppCode,
                                    prm_ErrorMsg);
      IF prm_AppCode <> gn_def_OK THEN
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '调用消息发送过程prc_MessageSend出错:' ||prm_ErrorMsg || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
      END IF;

   EXCEPTION
     -- WHEN NO_DATA_FOUND THEN
     -- WHEN TOO_MANY_ROWS THEN
     -- WHEN DUP_VAL_ON_INDEX THEN
     WHEN OTHERS THEN
       /*关闭打开的游标*/
       ROLLBACK;
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '数据库错误1:'|| SQLERRM ||v_jobid||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
       RETURN;
   END prc_checkAndFinaPlan;



   /*****************************************************************************
   ** 过程名称 : prc_batchImport
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：批量新参保导入保存
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
                             prm_iaz018     IN     irac01a2.iaz018%TYPE,  --批量导入批次ID
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
              aac025,--婚姻状况
              aac026,--是否婚否
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
    /*初始化变量*/
    prm_AppCode  := PKG_Constant.GN_DEF_OK;
    prm_ErrorMsg := '';
    n_count := 0;
    v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
    /*参数判空*/
    IF prm_aab001 IS NULL THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '没有获取到单位编号！';
       RETURN;
    END IF;

    IF prm_aae011 IS NULL THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '没有获取到经办人员编号！';
       RETURN;
    END IF;

    --判断是否存在该单位
    SELECT COUNT(1)
       into n_count
       FROM wsjb.IRAB01
       WHERE aab001 = prm_aab001;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '单位编号为['|| prm_aab001 ||']的单位信息不存在!';
       RETURN;
    END IF;



    --判断是否存在该专管员
    SELECT COUNT(1)
       into n_count
       FROM wsjb.IRAA01
       WHERE yae092 = prm_aae011;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '专管员编号为['|| prm_aae011 ||']的信息不存在!';
       RETURN;
    END IF;

    --判断是否存在批量导入信息
    SELECT COUNT(1)
       into n_count
       FROM wsjb.IRAC01A2
       WHERE iaz018 = prm_iaz018;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '导入批次ID为['|| prm_iaz018 ||']的信息不存在!';
       RETURN;
    END IF;

        --日志记录
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
            prm_aab001||'单位批量导入'
           );


    --循环检验提取数据
    FOR REC_TMP_PERSON IN impCur LOOP

      --初始化标志位
       var_flag := 0;
       v_message := null;

      /**检验数据**/
      --身份证非空校验
       IF REC_TMP_PERSON.aac002 IS NULL THEN
         v_message := v_message ||'身份证号码不能为空！';
         var_flag  := 1;
       END IF;
      --身份证位数处理
       IF LENGTH(trim(REC_TMP_PERSON.aac002)) = 18  THEN
               xasi2.pkg_P_Comm_CZ.prc_P_getID( UPPER(REC_TMP_PERSON.aac002),   --传入身份证
                                       v_aac002,   --传出身份证
                                       prm_AppCode,   --错误代码
                                       prm_ErrorMsg) ;  --错误内容
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
--               xasi2_zs.pkg_P_Comm_CZ.prc_P_getID( UPPER(REC_TMP_PERSON.aac002),   --传入身份证
--                                       v_aac002,   --传出身份证
--                                       prm_AppCode,   --错误代码
--                                       prm_ErrorMsg) ;  --错误内容
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
             v_message := v_message||REC_TMP_PERSON.aac002||'身份证位数不合法;';
             var_flag  := 1;
       END IF;

      --检查是否存在重复身份号码
      select count(1)
        into n_count
        from wsjb.IRAC01A2
       where iaz018 = prm_iaz018
         and aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d);
      IF n_count > 1 THEN
         v_message := v_message||'身份证号码重复;';
         var_flag   := 1;
      END IF;

      --18位身份证号是否新参保校验
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

            v_message := v_message||'该人员在'||v_aab004||'['||v_aab001||']有申报记录，不属于新参保范畴！';
            var_flag  := 1;
            END IF;
      END IF;

      --18位身份证号是否新参保校验
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
              v_message := v_message||'该人员在'||v_aab004||'['||v_aab001||']有参保记录，不属于新参保范畴！';
              var_flag  := 1;
            END IF;


       IF REC_TMP_PERSON.aab001 IS NULL THEN
         v_message := v_message||'没有找到单位编号！';
         var_flag  := 1;
       END IF;

       SELECT COUNT(1)
       INTO n_count
       FROM xasi2.ab01
       WHERE aab001 = REC_TMP_PERSON.aab001;
       IF n_count = 0 THEN
         v_message := v_message||'没有找到单位信息';
         var_flag  := 1;
       END IF;

       SELECT COUNT(1)
       INTO n_count
       FROM wsjb.irab01
       WHERE aab001 = REC_TMP_PERSON.aab001;
       IF n_count = 0 THEN
         v_message := v_message||'没有找到网报单位信息';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac003 IS NULL THEN
         v_message := v_message||'导入姓名不能为空！';
         var_flag  := 1;
       END IF;
       IF REC_TMP_PERSON.aac004 IS NOT NULL THEN
         IF REC_TMP_PERSON.aac004 <> '1' AND REC_TMP_PERSON.aac004 <> '2' AND REC_TMP_PERSON.aac004 <> '9' THEN
              v_message := v_message||'性别码值出错!';
              var_flag  := 1;
         END IF;
       END IF;

       IF REC_TMP_PERSON.aac005 IS  NOT  NULL THEN
         IF  LENGTH(trim(REC_TMP_PERSON.aac005)) <> 2 THEN
              v_message := v_message||'码值码值出错!';
              var_flag  := 1;
         END IF;
       END IF;

       IF REC_TMP_PERSON.aac009 IS NULL THEN
         v_message := v_message||'户口性质不能为空！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aac009 <> '10' AND REC_TMP_PERSON.aac009 <> '20' AND REC_TMP_PERSON.aac009 <> '30' AND REC_TMP_PERSON.aac009 <> '40' AND REC_TMP_PERSON.aac009 <> '90' THEN
                  v_message := v_message||'户口性质码值出错!';
                  var_flag  :=1;
            END IF;
       END IF;

        IF REC_TMP_PERSON.aac010 IS NULL OR LENGTH(REC_TMP_PERSON.aac010)< 8 THEN
         v_message := v_message||'户籍地址不能为空,或字数不达8位！';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aae006 IS NULL OR LENGTH(REC_TMP_PERSON.aae006)< 8 THEN
         v_message := v_message||'联系地址不能为空,或字数不达8位！';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac011 IS NULL THEN
         v_message := v_message||'学历不能为空！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aac011 <> '11' AND REC_TMP_PERSON.aac011 <> '12' AND REC_TMP_PERSON.aac011 <> '21'
               AND REC_TMP_PERSON.aac011 <> '31' AND REC_TMP_PERSON.aac011 <> '40' AND REC_TMP_PERSON.aac011 <> '50'
               AND REC_TMP_PERSON.aac011 <> '61' AND REC_TMP_PERSON.aac011 <> '62' AND REC_TMP_PERSON.aac011 <> '70'
               AND REC_TMP_PERSON.aac011 <> '80' AND REC_TMP_PERSON.aac011 <> '90' AND REC_TMP_PERSON.aac011 <> '99' THEN
                  v_message := v_message||'学历码值出错!';
                  var_flag  :=1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aac021 IS NULL THEN
         v_message := v_message||'毕业时间不能为空！';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac022 IS NULL THEN
         v_message := v_message||'毕业院校不能为空！';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac025 IS NULL THEN
         v_message := v_message||'婚姻状况不能为空！';
         var_flag  := 1;
         ELSE
            IF REC_TMP_PERSON.aac025 <> '1' AND REC_TMP_PERSON.aac025 <> '2' AND REC_TMP_PERSON.aac025 <> '3'
               AND REC_TMP_PERSON.aac025 <> '4' AND REC_TMP_PERSON.aac025 <> '9' THEN
                  v_message := v_message||'婚姻状况码值出错!';
                  var_flag  :=1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aac026 IS NULL THEN
         v_message := v_message||'是否服役不能为空！';
         var_flag  := 1;
         ELSE
            IF REC_TMP_PERSON.aac026 <> '0' AND REC_TMP_PERSON.aac026 <> '1' THEN
                  v_message := v_message||'是否服役码值出错!';
                  var_flag  :=1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aac012 IS NULL THEN
         v_message := v_message||'个人身份不能为空！';
         var_flag  := 1;
         ELSE
            IF REC_TMP_PERSON.aac012 <> '1' AND REC_TMP_PERSON.aac012 <> '4' THEN
                  v_message := v_message||'个人身份码值出错!';
                  var_flag  :=1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.yac168 IS NULL THEN
         v_message := v_message||'外来务工标志不能为空！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.yac168 <> '0' AND REC_TMP_PERSON.yac168 <> '1' THEN
                    v_message := v_message||'农民工标志码值出错!';
                    var_flag  := 1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aac030 IS NULL THEN
         v_message := v_message||'参保时间不能为空！';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.yac503 IS NULL THEN
         v_message := v_message||'工资类别不能为空！';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac040 IS NULL THEN
         v_message := v_message||'申报工资不能为空！';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aae110 IS NULL THEN
         v_message := v_message||'企业职工养老保险不能导入空项！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae110 <> '0' AND REC_TMP_PERSON.aae110 <> '1' THEN
                v_message := v_message||'企业职工养老保险码值出错!';
                var_flag  := 1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aae120 IS NULL THEN
         v_message := v_message||'机关事业养老保险不能导入空项！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae120 <> '0' AND REC_TMP_PERSON.aae120 <> '1' THEN
                v_message := v_message||'机关事业养老保险码值出错!';
                var_flag  := 1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aae210 IS NULL THEN
         v_message := v_message||'失业保险不能导入空项！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae210 <> '0' AND REC_TMP_PERSON.aae210 <> '1' THEN
                v_message := v_message||'失业保险码值出错!';
                var_flag  := 1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aae310 IS NULL THEN
         v_message := v_message||'基本医疗保险不能导入空项！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae310 <> '0' AND REC_TMP_PERSON.aae310 <> '1' THEN
                v_message := v_message||'基本医疗保险码值出错!';
                var_flag  := 1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aae410 IS NULL THEN
         v_message := v_message||'工伤保险不能导入空项！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae410 <> '0' AND REC_TMP_PERSON.aae410 <> '1' THEN
                v_message := v_message||'工伤保险码值出错!';
                var_flag  := 1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aae510 IS NULL THEN
         v_message := v_message||'生育保险不能导入空项！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae510 <> '0' AND REC_TMP_PERSON.aae510 <> '1' THEN
                v_message := v_message||'生育保险码值出错!';
                var_flag  := 1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aae311 IS NULL THEN
         v_message := v_message||'大病补充医疗保险不能导入空项！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae311 <> '0' AND REC_TMP_PERSON.aae311 <> '1' THEN
                v_message := v_message||'大额补充医疗保险码值出错!';
                var_flag  := 1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aae810 IS NULL THEN
         v_message := v_message||'公务员补助保险不能导入空项！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae810 <> '0' AND REC_TMP_PERSON.aae810 <> '1' THEN
                v_message := v_message||'公务员补助保险码值出错!';
                var_flag  := 1;
            END IF;
       END IF;
        --企业职工养老保险校验
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
             v_message := v_message||'所在单位没有参加企业职工养老保险!';
             var_flag := 1;
           END IF;
       END IF;

      --机关事业养老保险校验
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
             v_message := v_message||'所在单位没有参加机关事业养老保险!';
             var_flag := 1;
           END IF;

       END IF;

      --失业保险校验
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
             v_message := v_message||'所在单位没有参失业保险!';
             var_flag := 1;
           END IF;

       END IF;

      --基本医疗保险校验
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
             v_message := v_message||'所在单位没有参加基本医疗保险!';
             var_flag := 1;
           END IF;

       END IF;

      --工伤保险校验
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
             v_message := v_message||'所在单位没有参加机工伤保险!';
             var_flag := 1;
           END IF;

       END IF;

       --生育保险校验
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
             v_message := v_message||'所在单位没有参加生育保险!';
             var_flag := 1;
           END IF;

       END IF;

      --大额补充医疗保险校验
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
             v_message := v_message||'所在单位没有参加大额补充医疗保险!';
             var_flag := 1;
           END IF;

       END IF;

       --公务员补助保险校验
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
             v_message := v_message||'所在单位没有参加公务员补助保险!';
             var_flag := 1;
           END IF;

       END IF;

       --险种互斥校验
       IF REC_TMP_PERSON.aae110 = '1' AND REC_TMP_PERSON.aae120 = '1' THEN
              v_message:= v_message||'企业职工养老保险和机关养老保险不能一起参保!';
              var_flag := 1;
       END IF;
       IF REC_TMP_PERSON.aae410 = '0' AND v_aae410 = '2' THEN
              v_message:= v_message||'工伤保险为必参项!';
              var_flag := 1;
       END IF;
       /*根据单位险种绑定个人参保险种*/
       --单位参保险种有：医疗、失业、生育、大额
       IF v_aae210 = '2' AND v_aae510 = '2' AND v_aae311 = '2' AND v_aae310 = '2' THEN

             IF REC_TMP_PERSON.aae310 = '1' THEN
                   IF  REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae510 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                        v_message := v_message||'医疗、失业、生育、大额补充四险种必须一起参保!';
                        var_flag  := 1;
                   END IF;
             END IF;

             IF REC_TMP_PERSON.aae210 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae510 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                        v_message := v_message||'医疗、失业、生育、大额补充四险种必须一起参保!';
                        var_flag  := 1;
                   END IF;
             END IF;

             IF REC_TMP_PERSON.aae510 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                        v_message := v_message||'医疗、失业、生育、大额补充四险种必须一起参保!';
                        var_flag  := 1;
                   END IF;
             END IF;

             IF REC_TMP_PERSON.aae311 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae510 = '0' THEN
                        v_message := v_message||'医疗、失业、生育、大额补充四险种必须一起参保!';
                        var_flag  := 1;
                   END IF;
             END IF;

       END IF;
       --单位参保险种有：医疗、生育、大额
       IF v_aae510 = '2' AND v_aae311 = '2' AND v_aae310 = '2' THEN

             IF REC_TMP_PERSON.aae510 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                        v_message := v_message||'没有参加基本医疗和大额补充,不能参加生育!';
                        var_flag  := 1;
                   END IF;
             END IF;

             IF REC_TMP_PERSON.aae311 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0'  THEN
                        v_message := v_message||'没有参加基本医疗保险,不能参加大额补充医疗!';
                        var_flag  := 1;
                   END IF;
             END IF;

       END IF;

       --单位参保险种有：医疗、大额
       IF  v_aae311 = '2' AND v_aae310 = '2' THEN

             IF REC_TMP_PERSON.aae311 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0'  THEN
                        v_message := v_message||'没有参加基本医疗保险,不能参加大额补充医疗!';
                        var_flag  := 1;
                   END IF;
             END IF;

       END IF;

       IF REC_TMP_PERSON.aac009 = '20' AND REC_TMP_PERSON.yac168 = '0' THEN
              v_message:= v_message||'户口性质为农业户口,农民工标志不能为‘否’!';
              var_flag := 1;
       END IF;
       IF REC_TMP_PERSON.aac009 <> '20' AND REC_TMP_PERSON.yac168 = '1' THEN
              v_message:= v_message||'农民工标志为‘否’,户口性质必须为农业户口!';
              var_flag := 1;
       END IF;

          --参保时间、参工时间、首次参保时间校验
       IF REC_TMP_PERSON.aac030 IS NOT NULL THEN
            IF REC_TMP_PERSON.aac030 > sysdate THEN
                  v_message:= v_message||'本单位参保时间不能晚于系统时间!';
                  var_flag := 1;
          END IF;
       END IF;

      IF REC_TMP_PERSON.yac033 IS NOT NULL THEN
            IF REC_TMP_PERSON.yac033 > sysdate THEN
                  v_message:= v_message||'本单位参保时间不能晚于系统时间!';
                  var_flag := 1;
          END IF;
       END IF;

       IF REC_TMP_PERSON.aac007 IS NOT NULL THEN
            IF REC_TMP_PERSON.aac007 > sysdate THEN
                  v_message:= v_message||'参工时间不能晚于系统时间!';
                  var_flag := 1;
          END IF;
      END IF;

       IF REC_TMP_PERSON.aac007 IS NOT NULL AND REC_TMP_PERSON.aac030 IS NOT NULL THEN
            IF REC_TMP_PERSON.aac007 > REC_TMP_PERSON.aac030 THEN
                  v_message:= v_message||'参工时间不能晚于参保时间!';
                  var_flag := 1;
          END IF;
      END IF;

      --新增重复校验
        IF REC_TMP_PERSON.aac002 IS NOT NULL THEN
          SELECT COUNT(1)
            INTO n_count
            FROM wsjb.irac01  a
          WHERE a.iaa002 = PKG_Constant.IAA002_WIR
            AND a.aac002 = v_aac002
            AND a.iaa001 = PKG_Constant.IAA001_ADD ;
          IF n_count>0 THEN
          v_message := v_message||'已经存在人员新参保申请信息,不能继续新增!';
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
          v_message := v_message||'已经存在险种新增申请信息,不能继续新增!';
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
          v_message := v_message||'已经存在批量新参保申请信息,不能继续新增!';
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
          v_message := v_message||'已经存在暂停缴费申请信息,不能继续新增!';
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
          v_message := v_message||'已经存在批量暂停申请信息,不能继续新增!';
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
          v_message := v_message||'已经存在在职转退休申请信息,不能继续新增!';
          var_flag  := 1;
        END IF;
      END IF;
      --根据身份证号截取出生日期
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
        --提取IRAC01A2的数据到IRAC01
          v_iac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAC001');
         BEGIN
             INSERT INTO
                   wsjb.irac01
                   (
                    iac001,-- 申报人员信息编号 -->
                    iaa001,-- 申报人员类别 -->
                    iaa002,-- 申报人员信息状态 -->
                    aac001,-- 个人编号     -->
                    aab001,-- 单位编号     -->
                    yae181,-- 证件类型     -->
                    yac067,-- 来源方式     -->
                    aac002,-- 身份证号码(证件号码) -->
                    aac003,-- 姓名         -->
                    aac004,-- 性别         -->
                    aac005,-- 民族         -->
                    aac006,-- 出生日期     -->
                    aac007,-- 参加工作日期 -->
                    aac008,-- 人员状态     -->
                    aac009,-- 户口性质     -->
                    aac010,-- 户口所在地   -->
                    aac011,-- 文化程度     -->
                    aac021,--毕业日期
                    aac022,--毕业院校
                    aac025,--婚姻情况
                    aac026,--是否服役
                    aac012,-- 个人身份     -->
                    aac013,-- 用工形式     -->
                    aac014,-- 专业技术职务 -->
                    aac015,-- 工人技术等级 -->
                    aac020,-- 行政职务     -->
                    yac168,-- 农民工标志   -->
                    yac197,-- 劳模级别     -->
                    yac501,-- 农牧团场职工 -->
                    yac170,-- 军转干标志   -->
                    yac502,-- 是否原工商业者 -->
                    yae407,-- 所属社区     -->
                    yae496,-- 所属街道     -->
                    yic067,-- 建国前老工人 -->
                    aae004,-- 联系人姓名   -->
                    aae005,-- 联系电话     -->
                    aae006,-- 地址         -->
                    aae007,-- 邮政编码     -->
                    yae222,-- EMAIL        -->
                    yac200,-- 公务员补助职级 -->
                    aae110,-- 职工养老     -->
                    aac031,-- 个人参保状态 -->
                    yac505,-- 参保缴费人员类别 -->
                    yac033,-- 个人初次参保日期 -->
                    aac030,-- 本系统参保日期 -->
                    yae102,-- 最后一次变更时间 -->
                    yae097,-- 最大做账期号 -->
                    yac503,-- 工资类别     -->
                    aac040,-- 缴费工资     -->
                    yac004,-- 缴费基数[养老] -->
                    yaa333,-- 账户基数     -->
                    yab013,-- 原单位编号   -->
                    yac002,-- 企业内序号（工号） -->
                    yab139,-- 参保所属分中心 -->
                    aae011,-- 经办人       -->
                    aae036,-- 经办时间     -->
                    yab003,-- 社保经办机构 -->
                    aae013,-- 备注         -->
                    aaz002,-- 业务日志     -->
                    aae120,-- 机关养老     -->
                    aae210,-- 失业         -->
                    aae310,-- 医疗         -->
                    aae410,-- 工伤         -->
                    aae510,-- 生育         -->
                    aae311,-- 大病         -->
                    akc021,-- 医疗人员类别 -->
                    ykc150,-- 驻外标志     -->
                    ykb109,-- 是否享受公务员统筹待遇 -->
                    aic162,-- 离退休年月   -->
                    yac005,-- 缴费基数[其它] -->
                    aae810
                   ) VALUES (
                    v_iac001,
                    PKG_Constant.IAA001_PAD,
                    PKG_Constant.IAA002_WIR,
                    v_iac001,             -- 个人编号     -->
                    REC_TMP_PERSON.aab001,-- 单位编号     -->
                    '1',
                    PKG_Constant.YAC067_TQXCB,-- 来源方式     -->
                    v_aac002,             -- 身份证号码(证件号码) -->
                    REC_TMP_PERSON.aac003,-- 姓名         -->
                    v_aac004,             -- 性别         -->
                    REC_TMP_PERSON.aac005,-- 民族         -->
                    d_aac006             ,-- 出生日期     -->
                    REC_TMP_PERSON.aac007,-- 参加工作日期 -->
                    PKG_Constant.AAC008_ZZ,
                    REC_TMP_PERSON.aac009,-- 户口性质     -->
                    REC_TMP_PERSON.aac010,-- 户口所在地   -->
                    REC_TMP_PERSON.aac011,-- 文化程度     -->
                    REC_TMP_PERSON.aac021,--毕业时间
                    REC_TMP_PERSON.aac022,--毕业院校
                    REC_TMP_PERSON.aac025,--婚姻情况
                    REC_TMP_PERSON.aac026,--是否服役
                    REC_TMP_PERSON.aac012,--个人身份
                    PKG_Constant.AAC013_QT,-- 用工形式     -->
                    '5',                  -- 专业技术职务 -->
                    '9',                  -- 工人技术等级 -->
                    '190',                -- 行政职务     -->
                    v_yac168,             -- 农民工标志   -->
                    REC_TMP_PERSON.yac197,-- 劳模级别     -->
                    REC_TMP_PERSON.yac501,-- 农牧团场职工 -->
                    PKG_Constant.YAC170_FOU,-- 军转干标志   -->
                    REC_TMP_PERSON.yac502,-- 是否原工商业者 -->
                    REC_TMP_PERSON.yae407,-- 所属社区     -->
                    REC_TMP_PERSON.yae496,-- 所属街道     -->
                    REC_TMP_PERSON.yic067,-- 建国前老工人 -->
                    REC_TMP_PERSON.aae004,-- 联系人姓名   -->
                    REC_TMP_PERSON.aae005,-- 联系电话     -->
                    REC_TMP_PERSON.aae006,-- 地址         -->
                    REC_TMP_PERSON.aae007,-- 邮政编码     -->
                    REC_TMP_PERSON.yae222,-- EMAIL        -->
                    REC_TMP_PERSON.yac200,-- 公务员补助职级 -->
                    REC_TMP_PERSON.aae110,-- 职工养老     -->
                    REC_TMP_PERSON.aac031,-- 个人参保状态 -->
                    REC_TMP_PERSON.yac505,-- 参保缴费人员类别 -->
                    REC_TMP_PERSON.yac033,-- 个人初次参保日期 -->
                    REC_TMP_PERSON.aac030,-- 本系统参保日期 -->
                    REC_TMP_PERSON.yae102,-- 最后一次变更时间 -->
                    REC_TMP_PERSON.yae097,-- 最大做账期号 -->
                    PKG_Constant.YAC503_SB,
                    REC_TMP_PERSON.aac040,-- 缴费工资     -->
                    n_yac004,-- 缴费基数[养老] -->
                    REC_TMP_PERSON.yaa333,-- 账户基数     -->
                    REC_TMP_PERSON.yab013,-- 原单位编号   -->
                    REC_TMP_PERSON.yac002,-- 企业内序号（工号） -->
                    PKG_Constant.YAB003_JBFZX,
                    REC_TMP_PERSON.aae011,-- 经办人       -->
                    REC_TMP_PERSON.aae036,-- 经办时间     -->
                    REC_TMP_PERSON.yab003,-- 社保经办机构 -->
                    REC_TMP_PERSON.aae013,-- 备注         -->
                    v_aaz002,
                    REC_TMP_PERSON.aae120,-- 机关养老     -->
                    REC_TMP_PERSON.aae210,-- 失业         -->
                    REC_TMP_PERSON.aae310,-- 医疗         -->
                    REC_TMP_PERSON.aae410,-- 工伤         -->
                    REC_TMP_PERSON.aae510,-- 生育         -->
                    REC_TMP_PERSON.aae311,-- 大病         -->
                    REC_TMP_PERSON.akc021,-- 医疗人员类别 -->
                    REC_TMP_PERSON.ykc150,-- 驻外标志     -->
                    REC_TMP_PERSON.ykb109,-- 是否享受公务员统筹待遇 -->
                    REC_TMP_PERSON.aic162,-- 离退休年月   -->
                    n_yac005,-- 缴费基数[其它] -->
                    REC_TMP_PERSON.aae810
                   );

              --回写irac01a2 导入成功标志为成功
             UPDATE IRAC01A2 a
                SET a.aae100 = '1',
                    a.errormsg = '数据已导入'
              WHERE a.iaz018 = prm_iaz018
                AND a.aac002 = REC_TMP_PERSON.aac002
                AND a.aac003 = REC_TMP_PERSON.aac003;

       END;
     ElSIF var_flag = 1 THEN
          --回写irac01a2 导入成功标志为未成功同时回写失败原因
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
   /*关闭打开的游标*/
   ROLLBACK;
   prm_AppCode  :=  gn_def_ERR;
   prm_ErrorMsg := '数据库错误:'|| SQLERRM||dbms_utility.format_error_backtrace  ;
   RETURN;
   END prc_batchImport;

   /*****************************************************************************
   ** 过程名称 : prc_p_checkQYYL
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：企业养老缴费核定
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位编号
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-22   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_p_checkQYYL (
      prm_aab001       IN     irab01.aab001%TYPE,--单位编号
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum    NUMBER;
      v_aab001    VARCHAR2(15);
      v_jobid     VARCHAR2(10);
      v_yab222    VARCHAR2(15);
      v_aae076    VARCHAR2(20);

   BEGIN
      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      countnum     := 0;


   EXCEPTION
     -- WHEN NO_DATA_FOUND THEN
     -- WHEN TOO_MANY_ROWS THEN
     -- WHEN DUP_VAL_ON_INDEX THEN
     WHEN OTHERS THEN
       /*关闭打开的游标*/
       ROLLBACK;
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '数据库错误1:'|| SQLERRM||dbms_utility.format_error_backtrace ;
       RETURN;
   END prc_p_checkQYYL;

   /*****************************************************************************
   ** 过程名称 prc_oldEmpManaInfoMove
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：老单位开通网上经办协议
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_iab001       IN     irab01.iab001%TYPE,--单位助记码
   **           prm_aae011       IN     irab01.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          )
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-12   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_oldEmpManaInfoMove (
      prm_aae011       IN     irab01.aae011%TYPE,--经办人
      prm_aae013       IN     irab01.aae013%TYPE,--备注
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

      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;

      SELECT count(1)
        into n_count
        from wsjb.IRAA01_TMP  a
       where NOT EXISTS(select aab001 from wsjb.IRAB01  where aab001= iab001 and aab001 = a.aab001);
      IF n_count = 0 THEN
         prm_ErrorMsg := PRE_ERRCODE ||'临时表没有数据，不能做老单位开通网上经办协议!';
         RETURN;
      END IF;


      FOR rec_iraa01 in cur_IRAA01_TMP LOOP

         v_errmsg := NULL;

         SELECT count(1)
           INTO n_count
           FROM xasi2.ab01
          WHERE aab001= rec_iraa01.aab001;
         IF n_count = 0 THEN
            --v_errmsg := rec_iraa01.aab001||'单位信息不存在，请确定社保助记码是否正确!';
            --GOTO NEXTAAB001;
            prm_ErrorMsg := rec_iraa01.aab001||'单位信息不存在，请确定社保助记码是否正确!';
            RETURN;
         END IF;

         SELECT count(1)
           INTO n_count
           FROM wsjb.IRAB01
          WHERE aab001 = iab001
            and aab001 = rec_iraa01.aab001;
         IF n_count > 0 THEN
            --v_errmsg := rec_iraa01.aab001||'单位已经开通网上经办协议!';
            --GOTO NEXTAAB001;
            prm_ErrorMsg := rec_iraa01.aab001||'单位已经开通网上经办协议!';
            RETURN;
         END IF;

         /*
            写入申报单位信息：
            确定单位参保险种，
                    专管员,
                    税号，工商执照，组织机构代码，地税管理代码
         */

          v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
          IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
             prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号AAZ002!';
             RETURN;
          END IF;

          v_yae092 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'FRAMEWORK');
          IF v_yae092 IS NULL OR v_yae092 = '' THEN
             prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号FRAMEWORK!';
             RETURN;
          END IF;

          v_yae367 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'DEFAULT');
          IF v_yae367 IS NULL OR v_yae367 = '' THEN
             prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号DEFAULT!';
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
                    '2' yab004, --老单位信息补齐
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
             分配登陆账号口令
         */
         INSERT INTO wsjb.ad53a4  (
              yae092,  -- 操作人员编号
              yab109,  -- 部门编号
              aac003,  -- 姓名
              aac004,  -- 性别
              yab003,  -- 经办机构
              yae041,  -- 登陆号
              yae042,  -- 登陆口令
              yae361,  -- 锁定标志
              yae362,  -- 口令错误次数
              yae363,  -- 最后变更时间
              yae114,  -- 排序号
              aae100,  -- 有效标志
              aae011,  -- 经办人
              aae036   -- 经办时间
              )
         VALUES
             (
              v_yae092  ,  -- 操作人员编号
              '0101'    ,  -- 部门编号[单位经办]
              rec_iraa01.aab016,  -- 姓名
              '9'       ,  -- 性别
              PKG_Constant.YAB003_JBFZX,  -- 经办机构
              rec_iraa01.aab001,  -- 登陆号=单位编号=单位助记码[默认首任专管员如此]
              rec_iraa01.yae042,  -- 登陆口令
              '0'       ,  -- 锁定标志
              0         ,  -- 口令错误次数
              SYSDATE,  -- 最后变更时间
              0         ,  -- 排序号
              '1'       ,  -- 有效标志
              prm_aae011,  -- 经办人
              SYSDATE      -- 经办时间
         );


         /*
            中心端数据新增：目的 解决中心端经办人员先是问题
         */
         INSERT INTO wsjb.ad53a4  (
              yae092,  -- 操作人员编号
              yab109,  -- 部门编号
              aac003,  -- 姓名
              aac004,  -- 性别
              yab003,  -- 经办机构
              yae041,  -- 登陆号
              yae042,  -- 登陆口令
              yae361,  -- 锁定标志
              yae362,  -- 口令错误次数
              yae363,  -- 最后变更时间
              yae114,  -- 排序号
              aae100,  -- 有效标志
              aae011,  -- 经办人
              aae036   -- 经办时间
              )
         VALUES
             (
              v_yae092  ,  -- 操作人员编号
              '0101'    ,  -- 部门编号[单位经办]
              rec_iraa01.aab016,  -- 姓名
              '9'       ,  -- 性别
              PKG_Constant.YAB003_JBFZX,  -- 经办机构
              rec_iraa01.aab001,  -- 登陆号=单位编号=单位助记码[默认首任专管员如此]
              rec_iraa01.yae042,  -- 登陆口令
              '0'       ,  -- 锁定标志
              0         ,  -- 口令错误次数
              SYSDATE,  -- 最后变更时间
              0         ,  -- 排序号
              '1'       ,  -- 有效标志
              prm_aae011,  -- 经办人
              SYSDATE      -- 经办时间
         );


         /*
             为操作人员授权为单位经办的岗位
         */
         INSERT INTO  wsjb.AD53A6
                     (
                      yae093,  -- 角色编号
                      yab109,  -- 部门编号
                      yae092,  -- 操作人员编号
                      aae011,  -- 经办人
                      aae036   -- 经办时间
                     )
              VALUES
                     (
                      '1000000021',  -- 角色编号[单位经办]
                      '0101'    ,  -- 部门编号
                      v_yae092  ,  -- 操作人员编号
                      prm_aae011,  -- 经办人
                      SYSDATE      -- 经办时间
         );

         /*
            记录用户岗位变动日志
         */
         INSERT INTO wsjb.ad53a8  (
                yae367,  -- 变动流水号
                yae093,  -- 角色编号
                yab109,  -- 部门编号
                yae092,  -- 操作人员编号
                aae011,  -- 经办人
                aae036,  -- 经办时间
                yae369,  -- 修改人
                yae370,  -- 修改时间
                yae372)  -- 权限变动类型
         VALUES (
                v_yae367 ,  -- 变动流水号
                '1000000021',  -- 角色编号
                '0101',       -- 部门编号
                v_yae092,    -- 操作人员编号
                prm_aae011,  -- 经办人
                SYSDATE   ,  -- 经办时间
                prm_aae011,  -- 修改人
                SYSDATE   ,  -- 修改时间
                '07'        -- 权限变动类型
         );

         /*
            写入单位专管员信息
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

         --日志记录
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
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace  ;
         RETURN;
   END prc_oldEmpManaInfoMove;


    /*****************************************************************************
   ** 过程名称 : prc_MeetingMessageSend
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：会议通知发送短消息
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2013-04-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_MeetingMessageSend(prm_aae011     IN     ae02.aae011%TYPE,
                                    prm_iaa011     IN     irad23.iaa011%TYPE,
                                    prm_iaa022     IN     irad24.iaa022%TYPE,
                                    prm_AppCode    OUT    VARCHAR2  ,
                                    prm_ErrorMsg   OUT    VARCHAR2 )
   IS

   BEGIN
     /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';

      /*必要的数据校验*/
      IF prm_iaa011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '业务类型不能为空!';

      END IF;

      IF prm_iaa022 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '发送内容不能为空!';

      END IF;

      INSERT INTO wsjb.IRAD23_TMP  (AAB001)
        SELECT DISTINCT AAB001 FROM wsjb.IRAB01  WHERE AAB001 = IAB001;
      --调用短消息发送过程
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
       /*关闭打开的游标*/
       ROLLBACK;
       DELETE wsjb.IRAD23_TMP  WHERE 1=1;
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '数据库错误:'|| SQLERRM||dbms_utility.format_error_backtrace ;
       RETURN;
   END prc_MeetingMessageSend;

     /*****************************************************************************
   ** 过程名称 : prc_MessageSend
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：发送短消息
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-17   版本编号 ：Ver 1.0.0
   ** 修    改：
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
      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count     := 0;

      /*必要的数据校验*/
      IF prm_iaa011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '业务类型不能为空!';
         goto con_delete;
      END IF;

      IF prm_iaa022 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '发送内容不能为空!';
         goto con_delete;
      END IF;

      --检查单位编号是否正确
      FOR c_row in c_cur LOOP

        SELECT COUNT(1) INTO n_count FROM
          wsjb.IRAB01  a WHERE a.aab001 = c_row.aab001;
         IF n_count = 0 THEN
          prm_AppCode  :=  gn_def_ERR;
          prm_ErrorMsg := '没有找到'||c_row.aab001||'的单位信息！！！';
          goto con_delete;
         END IF;

      END LOOP;


      --写入日志
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

      --写入IRAD23短消息事件
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

      --写入IRAD24短消息事件
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
       /*关闭打开的游标*/
       ROLLBACK;
       DELETE wsjb.IRAD23_TMP  WHERE 1=1;
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '数据库错误:'|| SQLERRM||dbms_utility.format_error_backtrace ;
       RETURN;
   END prc_MessageSend;



   /*****************************************************************************
   ** 过程名称 : prc_writeToIrad25
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：接收短消息
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-17   版本编号 ：Ver 1.0.0
   ** 修    改：
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
      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count     := 0;

      /*必要的数据校验*/
      IF prc_iaa024 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '接受对象不能为空!';
         RETURN;
      END IF;

      IF prc_iaa003 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '接收主体不能为空!';
         RETURN;
      END IF;


      --写入IRAD24短消息事件
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
       /*关闭打开的游标*/
       ROLLBACK;
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '数据库错误:'|| SQLERRM||dbms_utility.format_error_backtrace ;
       RETURN;
   END prc_writeToIrad25;



   /*****************************************************************************
   ** 过程名称 : prc_rollbackUnitInfoMaintain
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：单位修改信息回退
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-17   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_rollbackUnitInfoMaintain(prm_aab001     IN     irab01.aab001%TYPE,--单位编号
                                          prm_AppCode    OUT    VARCHAR2  ,
                                          prm_ErrorMsg   OUT    VARCHAR2 )
   IS
     n_count    NUMBER;
     v_iab001   varchar2(15);
     v_iaz004   varchar2(15);

   BEGIN

     prm_AppCode  := PKG_Constant.GN_DEF_OK;
     prm_ErrorMsg := '';


     /*必要的数据校验*/
      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '单位助记码不能为空!';
         RETURN;
      END IF;

      --是否存在AB01单位信息
      SELECT COUNT(1)
           into n_count
           FROM xasi2.ab01
          WHERE aab001 = prm_aab001;
      IF n_count = 0 THEN
            prm_ErrorMsg := '单位编号为['|| prm_aab001 ||']的单位信息不存在!';
            RETURN;
      END IF;

      --是否存在IRAB01单位已申报修改信息
      SELECT COUNT(1)
           into n_count
           FROM wsjb.IRAB01  a,wsjb.AE02  b
          WHERE a.aab001 = prm_aab001
          AND a.aaz002 = b.aaz002
          AND b.aaa121 = PKG_Constant.AAA121_EIM
          AND a.iaa002 = PKG_Constant.IAA002_AIR;
      IF n_count != 1 THEN
            prm_ErrorMsg := '单位编号为['|| prm_aab001 ||']的单位不存在已申报的修改信息!';
            RETURN;
      END IF;

      --获取单位修改信息的编号
      SELECT max(a.iab001)
           into v_iab001
           FROM wsjb.IRAB01  a,wsjb.AE02  b
          WHERE a.aab001 = prm_aab001
          AND a.aaz002 = b.aaz002
          AND b.aaa121 = PKG_Constant.AAA121_EIM
          AND a.iaa002 = PKG_Constant.IAA002_AIR;

      --删除已经写入的修改信息
      DELETE FROM IRAD32
       WHERE iaz012 = (SELECT iaz012 from irad31 where iaz007 = v_iab001);

      DELETE FROM IRAD31
       WHERE iaz007 = v_iab001;

      --保存申报批次号
      SELECT distinct(iaz004)
        INTO v_iaz004
        FROM wsjb.IRAD02
        WHERE iaz007 = v_iab001
       AND iaa020 = PKG_Constant.IAA020_DW
       AND iaa015 = PKG_Constant.IAA015_WAD
       AND iaa016 = PKG_Constant.IAA016_DIR_NO;

      --删除申报信息
      DELETE FROM wsjb.IRAD02
       WHERE iaz007 = v_iab001
       AND iaa020 = PKG_Constant.IAA020_DW
       AND iaa016 = PKG_Constant.IAA016_DIR_NO;

      DELETE FROM wsjb.IRAD01
       WHERE iaz004 = v_iaz004;

      --删除日志
      DELETE FROM wsjb.AE02
       WHERE aaz002 = (SELECT aaz002 from wsjb.IRAB01  where iab001 = v_iab001);

      --删除修改记录
      DELETE FROM wsjb.IRAB01
       WHERE iab001 = v_iab001;


      EXCEPTION
           -- WHEN NO_DATA_FOUND THEN
          -- WHEN TOO_MANY_ROWS THEN
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
           /*关闭打开的游标*/
           ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;


   END prc_rollbackUnitInfoMaintain;



   /*****************************************************************************
   ** 过程名称 : prc_rollbackPersonInfoMaintain
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：个人修改信息回退
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-16   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_rollbackPersonInfoMaintain(
                prm_aac001     IN     irac01.aac001%TYPE,--个人编号
                prm_aab001     IN     irac01.aab001%TYPE,--单位编号
                prm_iac001     IN     irac01.iac001%TYPE,--申报编号
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


     /*必要的数据校验*/
      IF prm_aac001 IS NULL THEN
         prm_ErrorMsg := '个人编号不能为空!';
         RETURN;
      END IF;


      --是否存在IRAC01单位已申报修改信息
      SELECT COUNT(1)
           into n_count
           FROM wsjb.irac01  a,wsjb.AE02  b
          WHERE a.iac001 = prm_iac001
          AND a.aaz002 = b.aaz002
          AND b.aaa121 = PKG_Constant.AAA121_PIM
          AND a.iaa002 = PKG_Constant.IAA002_AIR;
      IF n_count != 1 THEN
            prm_ErrorMsg := '个人编号为['|| prm_aac001 ||']的人员不存在已申报的修改信息!';
            RETURN;
      END IF;

      --获取人员信息修改业务日志ID
      SELECT a.aaz002
        INTO v_aaz002
        FROM wsjb.irac01  a
       WHERE a.iac001 = prm_iac001
         AND  a.iaa001 = PKG_Constant.IAA001_MDF
         AND  a.iaa002 = PKG_Constant.IAA002_AIR;
      IF v_aaz002 IS NULL THEN
         prm_ErrorMsg := '没有获取到该人员信息修改的业务日志，请联系维护人员!';
         RETURN;
      END IF;

      --获取人员信息修改申报批次ID
      SELECT a.iaz004
        INTO v_iaz004
        FROM wsjb.IRAD01  a
        WHERE a.aaz002 = v_aaz002
        AND a.iaa011 = PKG_Constant.IAA011_PIM
        AND a.aab001 = prm_aab001;
        IF v_iaz004 IS NULL THEN
          prm_ErrorMsg := '获取申报[批次]ID出现错误,请联系维护人员处理!';
        RETURN;
      END IF;
      --获取申报明细ID
       SELECT a.iaz005 ,a.iaz007
       INTO v_iaz005 ,v_iaz007
       FROM wsjb.IRAD02  a
       WHERE a.iaz008 = prm_aac001
       AND a.iaz004 = v_iaz004
       AND a.iaa020 = PKG_Constant.IAA020_GR
       AND a.iaa015 = PKG_Constant.IAA015_WAD
       AND a.iaa016 = PKG_Constant.IAA016_DIR_NO;
       IF v_iaz005 IS NULL OR v_iaz007 IS NULL THEN
       prm_ErrorMsg:= '获取申报明细ID或者基础信息ID出现错误,请联系维护人员处理!';
       RETURN;
      END IF;
      --获取历史修改ID
      SELECT a.iaz012
        INTO v_iaz012
        FROM irad31 a
       WHERE a.aaz002 = v_aaz002
       AND a.iaz007 = v_iaz007
       AND a.aab001 = prm_aab001
       AND a.iaa011 = PKG_Constant.IAA011_PIM
       AND a.iaa019 = PKG_Constant.IAA019_IR;
       IF v_iaz012 IS NULL THEN
       prm_ErrorMsg:= '获取历史事件ID出错,请联系维护人员!';
       RETURN;
       END IF;

      --删除已经写入的修改信息
      DELETE FROM IRAD32
       WHERE iaz012 = v_iaz012;

      DELETE FROM IRAD31
       WHERE iaz007 = v_iaz007
         AND  iaz012 = v_iaz012;


      --删除申报信息
      DELETE  FROM wsjb.IRAD02
       WHERE iaz005 = v_iaz005;

      DELETE FROM wsjb.IRAD01
       WHERE iaz004 = v_iaz004;

      --删除日志
      DELETE FROM wsjb.AE02
       WHERE aaz002 = v_aaz002;

      --删除修改记录
      DELETE FROM wsjb.irac01
       WHERE iac001 = prm_iac001;


      EXCEPTION
           -- WHEN NO_DATA_FOUND THEN
          -- WHEN TOO_MANY_ROWS THEN
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
           /*关闭打开的游标*/
           ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;


   END prc_rollbackPersonInfoMaintain;


   /*****************************************************************************
   ** 过程名称 : prc_batchImportView
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：批量新参保导入预览
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001     IN     irab01.aab001%TYPE,--单位编号
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-17   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_batchImportView(prm_aab001     IN     irac01.aab001%TYPE,--单位编号
                                 prm_iaz018     IN     irac01a2.iaz018%TYPE,  --批量导入批次ID
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
    /*初始化变量*/
    prm_AppCode  := PKG_Constant.GN_DEF_OK;
    prm_ErrorMsg := '';
    n_count := 0;
    /*参数判空*/
    IF prm_aab001 IS NULL THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '没有获取到单位编号！';
       RETURN;
    END IF;


    --判断是否存在该单位
    SELECT COUNT(1)
       into n_count
       FROM wsjb.IRAB01
       WHERE aab001 = prm_aab001;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '单位编号为['|| prm_aab001 ||']的单位信息不存在!';
       RETURN;
    END IF;





    --判断是否存在批量导入信息
    SELECT COUNT(1)
       into n_count
       FROM IRAC01A2
       WHERE iaz018 = prm_iaz018;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '导入批次ID为['|| prm_iaz018 ||']的信息不存在!';
       RETURN;
    END IF;


    --循环检验提取数据
    FOR REC_TMP_PERSON IN impCur LOOP

      --初始化标志位
       var_flag := 0;
       v_message := null;
      /**检验数据**/
      --身份证非空校验
       IF REC_TMP_PERSON.aac002 IS NULL THEN
         v_message := v_message||'身份证号码不能为空！';
         var_flag  := 1;
       END IF;
      --身份证位数处理
       IF LENGTH(trim(REC_TMP_PERSON.aac002)) = 18  THEN
          xasi2.pkg_P_Comm_CZ.prc_P_getID( UPPER(REC_TMP_PERSON.aac002),   --传入身份证
                                  v_aac002,   --传出身份证
                                  prm_AppCode,   --错误代码
                                  prm_ErrorMsg) ;  --错误内容
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
--               xasi2_zs.pkg_P_Comm_CZ.prc_P_getID( UPPER(REC_TMP_PERSON.aac002),   --传入身份证
--                                       v_aac002,   --传出身份证
--                                       prm_AppCode,   --错误代码
--                                       prm_ErrorMsg) ;  --错误内容
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
             v_message := v_message||REC_TMP_PERSON.aac002||'身份证位数不合法;';
             var_flag   := 1;
       END IF;

      --检查是否存在重复身份号码
      select count(1)
        into n_count
        from IRAC01A2
       where iaz018 = prm_iaz018
         and aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d);
      IF n_count > 1 THEN
         v_message := v_message||'身份证号码重复;';
         var_flag   := 1;
      END IF;
      --18位身份证号是否新参保校验
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

        v_message := v_message||'该人员在'||v_aab004||'['||v_aab001||']有申报记录，不属于新参保范畴！';
        var_flag  := 1;
        END IF;

      --18位身份证号是否新参保校验
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
          v_message := v_message||'该人员在'||v_aab004||'['||v_aab001||']有参保记录，不属于新参保范畴！';
          var_flag  := 1;
        END IF;


       IF REC_TMP_PERSON.aab001 IS NULL THEN
         v_message := v_message||'没有找到单位编号！';
         var_flag  := 1;
       END IF;

       SELECT COUNT(1)
       INTO n_count
       FROM xasi2.ab01
       WHERE aab001 = REC_TMP_PERSON.aab001;
       IF n_count = 0 THEN
         v_message := v_message||'没有找到单位信息';
         var_flag  := 1;
       END IF;

       SELECT COUNT(1)
       INTO n_count
       FROM wsjb.IRAB01
       WHERE aab001 = REC_TMP_PERSON.aab001;
       IF n_count = 0 THEN
         v_message := v_message||'没有找到网报单位信息';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac003 IS NULL THEN
         v_message := v_message||'导入姓名不能为空！';
         var_flag  := 1;
       END IF;
       IF REC_TMP_PERSON.aac004 IS NOT NULL THEN
         IF REC_TMP_PERSON.aac004 <> '1' AND REC_TMP_PERSON.aac004 <> '2' AND REC_TMP_PERSON.aac004 <> '9' THEN
              v_message := v_message||'性别码值出错!';
              var_flag  := 1;
         END IF;
       END IF;

       IF REC_TMP_PERSON.aac005 IS  NOT  NULL THEN
         IF  LENGTH(trim(REC_TMP_PERSON.aac005)) <> 2 THEN
              v_message := v_message||'码值码值出错!';
              var_flag  := 1;
         END IF;
       END IF;

       IF REC_TMP_PERSON.aac009 IS NULL THEN
         v_message := v_message||'户口性质不能为空！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aac009 <> '10' AND REC_TMP_PERSON.aac009 <> '20' AND REC_TMP_PERSON.aac009 <> '30' AND REC_TMP_PERSON.aac009 <> '40' AND REC_TMP_PERSON.aac009 <> '90' THEN
                  v_message := v_message||'户口性质码值出错!';
                  var_flag  :=1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aac010 IS NULL AND LENGTH(REC_TMP_PERSON.aac010)< 8 THEN
         v_message := v_message||'户籍地址不能为空,或字数不达8位！';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aae006 IS NULL AND LENGTH(REC_TMP_PERSON.aae006)< 8 THEN
         v_message := v_message||'联系地址不能为空,或字数不达8位！';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac011 IS NULL THEN
         v_message := v_message||'学历不能为空！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aac011 <> '11' AND REC_TMP_PERSON.aac011 <> '12' AND REC_TMP_PERSON.aac011 <> '21'
               AND REC_TMP_PERSON.aac011 <> '31' AND REC_TMP_PERSON.aac011 <> '40' AND REC_TMP_PERSON.aac011 <> '50'
               AND REC_TMP_PERSON.aac011 <> '61' AND REC_TMP_PERSON.aac011 <> '62' AND REC_TMP_PERSON.aac011 <> '70'
               AND REC_TMP_PERSON.aac011 <> '80' AND REC_TMP_PERSON.aac011 <> '90' AND REC_TMP_PERSON.aac011 <> '99' THEN
                  v_message := v_message||'学历码值出错!';
                  var_flag  :=1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aac021 IS NULL THEN
         v_message := v_message||'毕业时间不能为空！';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac022 IS NULL THEN
         v_message := v_message||'毕业院校不能为空！';
         var_flag  := 1;
       END IF;

        IF REC_TMP_PERSON.aac025 IS NULL THEN
         v_message := v_message||'婚姻状况不能为空！';
         var_flag  := 1;
         ELSE
            IF REC_TMP_PERSON.aac025 <> '1' AND REC_TMP_PERSON.aac025 <> '2' AND REC_TMP_PERSON.aac025 <> '3'
               AND REC_TMP_PERSON.aac025 <> '4' AND REC_TMP_PERSON.aac025 <> '9' THEN
                  v_message := v_message||'婚姻状况码值出错!';
                  var_flag  :=1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aac026 IS NULL THEN
         v_message := v_message||'是否服役不能为空！';
         var_flag  := 1;
         ELSE
            IF REC_TMP_PERSON.aac026 <> '0' AND REC_TMP_PERSON.aac026 <> '1' THEN
                  v_message := v_message||'是否服役码值出错!';
                  var_flag  :=1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aac012 IS NULL THEN
         v_message := v_message||'个人身份不能为空！';
         var_flag  := 1;
         ELSE
            IF REC_TMP_PERSON.aac012 <> '1' AND REC_TMP_PERSON.aac012 <> '4' THEN
                  v_message := v_message||'个人身份码值出错!';
                  var_flag  :=1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.yac168 IS NULL THEN
         v_message := v_message||'外来务工标志不能为空！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.yac168 <> '0' AND REC_TMP_PERSON.yac168 <> '1' THEN
                    v_message := v_message||'农民工标志码值出错!';
                    var_flag  := 1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aac030 IS NULL THEN
         v_message := v_message||'参保时间不能为空！';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac007 IS NULL THEN
         v_message := v_message||'参工时间不能为空！';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.yac503 IS NULL THEN
         v_message := v_message||'工资类别不能为空！';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac040 IS NULL THEN
         v_message := v_message||'申报工资不能为空！';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aae110 IS NULL THEN
         v_message := v_message||'企业职工养老保险不能导入空项！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae110 <> '0' AND REC_TMP_PERSON.aae110 <> '1' THEN
                v_message := v_message||'企业职工养老保险码值出错!';
                var_flag  := 1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aae120 IS NULL THEN
         v_message := v_message||'机关事业养老保险不能导入空项！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae120 <> '0' AND REC_TMP_PERSON.aae120 <> '1' THEN
                v_message := v_message||'机关事业养老保险码值出错!';
                var_flag  := 1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aae210 IS NULL THEN
         v_message := v_message||'失业保险不能导入空项！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae210 <> '0' AND REC_TMP_PERSON.aae210 <> '1' THEN
                v_message := v_message||'失业保险码值出错!';
                var_flag  := 1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aae310 IS NULL THEN
         v_message := v_message||'基本医疗保险不能导入空项！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae310 <> '0' AND REC_TMP_PERSON.aae310 <> '1' THEN
                v_message := v_message||'基本医疗保险码值出错!';
                var_flag  := 1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aae410 IS NULL THEN
         v_message := v_message||'工伤保险不能导入空项！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae410 <> '0' AND REC_TMP_PERSON.aae410 <> '1' THEN
                v_message := v_message||'工伤保险码值出错!';
                var_flag  := 1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aae510 IS NULL THEN
         v_message := v_message||'生育保险不能导入空项！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae510 <> '0' AND REC_TMP_PERSON.aae510 <> '1' THEN
                v_message := v_message||'生育保险码值出错!';
                var_flag  := 1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.aae311 IS NULL THEN
         v_message := v_message||'大病补充医疗保险不能导入空项！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae311 <> '0' AND REC_TMP_PERSON.aae311 <> '1' THEN
                v_message := v_message||'大额补充医疗保险码值出错!';
                var_flag  := 1;
            END IF;
       END IF;

      IF REC_TMP_PERSON.aae810 IS NULL THEN
         v_message := v_message||'公务员补助保险不能导入空项！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.aae810 <> '0' AND REC_TMP_PERSON.aae810 <> '1' THEN
                v_message := v_message||'公务员补助保险码值出错!';
                var_flag  := 1;
            END IF;
       END IF;
        --企业职工养老保险校验
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
             v_message := v_message||'所在单位没有参加企业职工养老保险!';
             var_flag := 1;
           END IF;
       END IF;

      --机关事业养老保险校验
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
             v_message := v_message||'所在单位没有参加机关事业养老保险!';
             var_flag := 1;
           END IF;

       END IF;

      --失业保险校验
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
             v_message := v_message||'所在单位没有参失业保险!';
             var_flag := 1;
           END IF;

       END IF;

      --基本医疗保险校验
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
             v_message := v_message||'所在单位没有参加基本医疗保险!';
             var_flag := 1;
           END IF;

       END IF;

      --工伤保险校验
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
             v_message := v_message||'所在单位没有参加机工伤保险!';
             var_flag := 1;
           END IF;

       END IF;

       --生育保险校验
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
             v_message := v_message||'所在单位没有参加生育保险!';
             var_flag := 1;
           END IF;

       END IF;

      --大额补充医疗保险校验
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
             v_message := v_message||'所在单位没有参加大额补充医疗保险!';
             var_flag := 1;
           END IF;

       END IF;

       --公务员补助保险校验
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
             v_message := v_message||'所在单位没有参加公务员补助保险!';
             var_flag := 1;
           END IF;

           IF NVL(REC_TMP_PERSON.yaa333,0) <= 0 THEN
              v_message := v_message||'账户基数不能为空!';
              var_flag := 1;
           END IF;

       END IF;

       --险种互斥校验
       IF REC_TMP_PERSON.aae110 = '1' AND REC_TMP_PERSON.aae120 = '1' THEN
              v_message:= v_message||'企业职工养老保险和机关养老保险不能一起参保!';
              var_flag := 1;
       END IF;
       IF REC_TMP_PERSON.aae410 = '0' AND v_aae410 = '2' THEN
              v_message:= v_message||'工伤保险为必参项!';
              var_flag := 1;
       END IF;
       /*根据单位险种绑定个人参保险种*/
       --单位参保险种有：医疗、失业、生育、大额
       IF v_aae210 = '2' AND v_aae510 = '2' AND v_aae311 = '2' AND v_aae310 = '2' THEN

             IF REC_TMP_PERSON.aae310 = '1' THEN
                   IF  REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae510 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                        v_message := v_message||'医疗、失业、生育、大额补充四险种必须一起参保!';
                        var_flag  := 1;
                   END IF;
             END IF;

             IF REC_TMP_PERSON.aae210 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae510 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                        v_message := v_message||'医疗、失业、生育、大额补充四险种必须一起参保!';
                        var_flag  := 1;
                   END IF;
             END IF;

             IF REC_TMP_PERSON.aae510 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                        v_message := v_message||'医疗、失业、生育、大额补充四险种必须一起参保!';
                        var_flag  := 1;
                   END IF;
             END IF;

             IF REC_TMP_PERSON.aae311 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae510 = '0' THEN
                        v_message := v_message||'医疗、失业、生育、大额补充四险种必须一起参保!';
                        var_flag  := 1;
                   END IF;
             END IF;

       END IF;
       --单位参保险种有：医疗、生育、大额
       IF v_aae510 = '2' AND v_aae311 = '2' AND v_aae310 = '2' THEN

             IF REC_TMP_PERSON.aae510 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                        v_message := v_message||'没有参加基本医疗和大额补充,不能参加生育!';
                        var_flag  := 1;
                   END IF;
             END IF;

             IF REC_TMP_PERSON.aae311 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0'  THEN
                        v_message := v_message||'没有参加基本医疗保险,不能参加大额补充医疗!';
                        var_flag  := 1;
                   END IF;
             END IF;

       END IF;

       --单位参保险种有：医疗、大额
       IF  v_aae311 = '2' AND v_aae310 = '2' THEN

             IF REC_TMP_PERSON.aae311 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0'  THEN
                        v_message := v_message||'没有参加基本医疗保险,不能参加大额补充医疗!';
                        var_flag  := 1;
                   END IF;
             END IF;

       END IF;

       IF REC_TMP_PERSON.aac009 = '20' AND REC_TMP_PERSON.yac168 = '0' THEN
              v_message:= v_message||'户口性质为农业户口,农民工标志不能为‘否’!';
              var_flag := 1;
       END IF;
       IF REC_TMP_PERSON.aac009 <> '20' AND REC_TMP_PERSON.yac168 = '1' THEN
              v_message:= v_message||'农民工标志为‘否’,户口性质必须为农业户口!';
              var_flag := 1;
       END IF;

          --参保时间、参工时间、首次参保时间校验
       IF REC_TMP_PERSON.aac030 IS NOT NULL THEN
            IF REC_TMP_PERSON.aac030 > sysdate THEN
                  v_message:= v_message||'本单位参保时间不能晚于系统时间!';
                  var_flag := 1;
          END IF;
       END IF;

      IF REC_TMP_PERSON.yac033 IS NOT NULL THEN
            IF REC_TMP_PERSON.yac033 > sysdate THEN
                  v_message:= v_message||'本单位参保时间不能晚于系统时间!';
                  var_flag := 1;
          END IF;
       END IF;

       IF REC_TMP_PERSON.aac007 IS NOT NULL THEN
            IF REC_TMP_PERSON.aac007 > sysdate THEN
                  v_message:= v_message||'参工时间不能晚于系统时间!';
                  var_flag := 1;
          END IF;
      END IF;

       IF REC_TMP_PERSON.aac007 IS NOT NULL AND REC_TMP_PERSON.aac030 IS NOT NULL THEN
            IF REC_TMP_PERSON.aac007 > REC_TMP_PERSON.aac030 THEN
                  v_message:= v_message||'参工时间不能晚于参保时间!';
                  var_flag := 1;
          END IF;
      END IF;

      --新增重复校验
        IF REC_TMP_PERSON.aac002 IS NOT NULL THEN
          SELECT COUNT(1)
            INTO n_count
            FROM wsjb.irac01  a
          WHERE a.iaa002 = PKG_Constant.IAA002_WIR
            AND a.aac002 = v_aac002
            AND a.iaa001 = PKG_Constant.IAA001_ADD ;
          IF n_count>0 THEN
          v_message := v_message||'已经存在人员新参保申请信息,不能继续新增!';
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
          v_message := v_message||'已经存在批量新参保申请信息,不能继续新增!';
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
          v_message := v_message||'已经存在暂停缴费申请信息,不能继续新增!';
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
          v_message := v_message||'已经存在批量暂停申请信息,不能继续新增!';
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
          v_message := v_message||'已经存在在职转退休申请信息,不能继续新增!';
          var_flag  := 1;
        END IF;
      END IF;
      --根据身份证号截取出生日期
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
        --提取IRAC01A2的数据到IRAC01
          v_iac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAC001');
         BEGIN
          --回写irac01a2 原因为成功
            UPDATE IRAC01A2  a
              SET  a.errormsg = '数据可以导入'
             WHERE a.iaz018 = prm_iaz018
               AND a.aac002 = REC_TMP_PERSON.aac002
               AND a.aac003 = REC_TMP_PERSON.aac003;

       END;
     ElSIF var_flag = 1 THEN
          --回写irac01a2 回写失败原因
            UPDATE IRAC01A2  a
              SET  a.errormsg = v_message
             WHERE a.iaz018 = prm_iaz018
               AND a.aac002 = REC_TMP_PERSON.aac002
               AND a.aac003 = REC_TMP_PERSON.aac003;
      END IF;

      END LOOP;
   EXCEPTION
   WHEN OTHERS THEN
   /*关闭打开的游标*/
   ROLLBACK;
   prm_AppCode  :=  gn_def_ERR;
   prm_ErrorMsg := '数据库错误:'|| SQLERRM ||dbms_utility.format_error_backtrace ;
   RETURN;
   END prc_batchImportView;




   /*****************************************************************************
   ** 过程名称 : prc_pensionImp
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：批量检查养老信息
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001     IN     irab01.aab001%TYPE,--单位编号
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-17   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_pensionImp(prm_aaz002     IN     ae02.aaz002%TYPE,--日志ID
                            prm_aae011     IN     ae02.aae011%TYPE,  --经办人
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


     /*必要的数据校验*/
      IF prm_aaz002 IS NULL THEN
         prm_ErrorMsg := '业务日志ID不能为空!';
         RETURN;
      END IF;

      IF prm_aae011 IS NULL THEN
         prm_ErrorMsg := '经办人不能为空!';
         RETURN;
      END IF;

      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '单位社保助记码不能为空!';
         RETURN;
      END IF;

      --是否存在养老同步信息
      SELECT COUNT(1) INTO n_count FROM
          IRAC36 a WHERE a.aaz002 = prm_aaz002;
         IF n_count = 0 THEN
          prm_AppCode  :=  gn_def_ERR;
          prm_ErrorMsg := '没有找到该批次的养老同步信息！！！';
          RETURN;
         END IF;

      --日志记录
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


      --校验数据
      FOR cur_result in c_cur LOOP
        v_aac001 := '';
        v_msg := '';
        v_aae100 := '1';

        --是否存在AB01单位信息
        SELECT COUNT(1)
             into n_count
             FROM xasi2.ab01
            WHERE aab001 = cur_result.aab001;
        IF n_count = 0 THEN
              v_msg := v_msg||'没有找到单位'||cur_result.aab001||';';
              v_aae100 := '0';
        END IF;




      /**检验数据**/
      --身份证非空校验
       IF cur_result.aac002 IS NULL THEN
         v_msg := v_msg ||'身份证号码不能为空;';
         v_aae100 := '0';
       END IF;
      --身份证位数处理
       IF LENGTH(trim(cur_result.aac002)) = 18  THEN
               xasi2.pkg_P_Comm_CZ.prc_P_getID( UPPER(cur_result.aac002),   --传入身份证
                                       v_aac002,   --传出身份证
                                       prm_AppCode,   --错误代码
                                       prm_ErrorMsg) ;  --错误内容
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
               xasi2.pkg_P_Comm_CZ.prc_P_getID( UPPER(cur_result.aac002),   --传入身份证
                                       v_aac002,   --传出身份证
                                       prm_AppCode,   --错误代码
                                       prm_ErrorMsg) ;  --错误内容
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
             v_msg := v_msg||cur_result.aac002||'身份证位数不合法;';
             v_aae100 := '0';
       END IF;

        --是否存在AC01单位信息
        SELECT COUNT(1)
             into n_count
             FROM xasi2.ac01
            WHERE aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d);
        IF n_count = 0 THEN
              v_msg := v_msg||'没有找到人员'||cur_result.aac002||';';
              v_aae100 := '0';
        END IF;


        --是否存在AC01信息
        SELECT COUNT(1)
             into n_count
             FROM xasi2.ac01 a,xasi2.ac02 b
            WHERE a.aac001 = b.aac001
            AND b.aab001 = cur_result.aab001
            AND a.aac003 = cur_result.aac003
            AND a.aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d);

        IF n_count = 0 THEN
              v_msg := v_msg||'没有找到单位 '||cur_result.aab001||' 下的人员 '||cur_result.aac003||cur_result.aac002||';';
              v_aae100 := '0';
        END IF;

         BEGIN

          SELECT aac001
             into v_aac001
             FROM xasi2.ac01
            WHERE aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d);

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_msg := v_msg||'人员信息有误，请联系维护人员！;';
              v_aae100 := '0';
            WHEN TOO_MANY_ROWS THEN
              v_msg := v_msg||'人员信息有误，请联系维护人员！;';
              v_aae100 := '0';
          -- WHEN DUP_VAL_ON_INDEX THEN
          WHEN OTHERS THEN
           /*关闭打开的游标*/

            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
         END;

        IF cur_result.yac004 < 1953 THEN
              v_msg := v_msg||'养老基数低于下限1953;';
              v_aae100 := '0';
        END IF;

        IF cur_result.yac004 > 9760 THEN
              v_msg := v_msg||'养老基数高于上限9760;';
              v_aae100 := '0';
        END IF;

        --更新校验信息
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
           /*关闭打开的游标*/
           ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;

           RETURN;


   END prc_pensionImp;





   /*****************************************************************************
   ** 过程名称 : prc_pensionMaintainImp
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：批量检查养老信息
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001     IN     irab01.aab001%TYPE,--单位编号
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-17   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_pensionMaintainImp(prm_aaz002     IN     ae02.aaz002%TYPE,--日志ID
                                    prm_aae011     IN     ae02.aae011%TYPE,  --经办人
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


     /*必要的数据校验*/
      IF prm_aaz002 IS NULL THEN
         prm_ErrorMsg := '业务日志ID不能为空!';
         RETURN;
      END IF;

      IF prm_aae011 IS NULL THEN
         prm_ErrorMsg := '经办人不能为空!';
         RETURN;
      END IF;

      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '单位社保助记码不能为空!';
         RETURN;
      END IF;

      --是否已授权
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
          prm_ErrorMsg := '授权信息有误！！！'||to_number(to_char(prm_aae035,'yyyyMMdd'));
          RETURN;
         END IF;

      --获取授权信息
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
          prm_ErrorMsg := '剩余次数有误！！！';
          RETURN;
        END IF;

      --是否存在养老同步信息
      SELECT COUNT(1) INTO n_count FROM
          wsjb.IRAC36 a WHERE a.aaz002 = prm_aaz002;
         IF n_count = 0 THEN
          prm_AppCode  :=  gn_def_ERR;
          prm_ErrorMsg := '没有找到该批次的养老同步信息！！！';
          RETURN;
         END IF;

      --日志记录
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


      --校验数据
      FOR cur_result in c_cur LOOP
        v_aac001 := '';
        v_msg := '';
        v_aae100 := '1';

        --是否存在AB01单位信息
        SELECT COUNT(1)
             into n_count
             FROM xasi2.ab01
            WHERE aab001 = prm_aab001;
        IF n_count = 0 THEN
              v_msg := v_msg||'没有找到单位'||prm_aab001||';';
              v_aae100 := '0';
        END IF;

        --是否存在AC01单位信息
        SELECT COUNT(1)
             into n_count
             FROM xasi2.ac01
            WHERE aac002 = cur_result.aac002;
        IF n_count = 0 THEN
              v_msg := v_msg||'没有找到人员'||cur_result.aac002||';';
              v_aae100 := '0';
        END IF;

        --是否存在AC01信息
        SELECT COUNT(1)
             into n_count
             FROM xasi2.ac01 a,xasi2.ac02 b
            WHERE a.aac001 = b.aac001
            AND b.aab001 = prm_aab001
            AND a.aac003 = cur_result.aac003
            AND a.aac002 = cur_result.aac002
            AND a.aac001 = cur_result.aac001;

        IF n_count = 0 THEN
              v_msg := v_msg||'没有找到单位 '||prm_aab001||' 下的人员 '||cur_result.aac003||cur_result.aac002||';';
              v_aae100 := '0';
        END IF;

        --是否存在IRAC01A3信息
        SELECT COUNT(1)
             into n_count
             FROM wsjb.IRAC01A3 a
            WHERE a.aab001 = prm_aab001
            AND a.aac003 = cur_result.aac003
            AND a.aac002 = cur_result.aac002
            AND a.aac001 = cur_result.aac001;

        IF n_count = 0 THEN
              v_msg := v_msg||'没有找到单位 '||prm_aab001||' 下的人员 '||cur_result.aac003||cur_result.aac002||'的养老信息;';
              v_aae100 := '0';
        END IF;

        IF cur_result.yac004 < 1953 THEN
              v_msg := v_msg||'养老基数低于下限1953;';
              v_aae100 := '0';
        END IF;

        IF cur_result.yac004 > 9760 THEN
              v_msg := v_msg||'养老基数高于上限9760;';
              v_aae100 := '0';
        END IF;

        --更新校验信息
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
           /*关闭打开的游标*/
           ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
           RETURN;
   END prc_pensionMaintainImp;
  /*****************************************************************************
   ** 过程名称 : prc_AuditRecoveryandSuspendPayment
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：人员恢复暂停缴费审核[中心端]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aaa121       IN     ae02.aaa121%TYPE,--业务类型编码
   **           prm_iaa011       IN     iraa02.iaa011%TYPE,--业务类型
   **           prm_iaa003       IN     iraa02.iaa003%TYPE,--业务主体
   **           prm_iaa004       IN     iraa02.iaa011%TYPE,--审核标志
   **           prm_iaa028       IN     VARCHAR2          ,--是否全部
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_aae013       IN     iraa02.aae013%TYPE,--备注
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：zhangwj         作成日期 ：2012-08-29   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_AuditRecoverySuspend (
      prm_aaa121       IN     ae02.aaa121%TYPE,--业务类型编码
      prm_iaa011       IN     iraa02.iaa011%TYPE,--业务类型
      prm_iaa003       IN     iraa02.iaa003%TYPE,--业务主体
      prm_iaa018       IN     irad22.iaa018%TYPE,--审核标志
      prm_iaa028       IN     VARCHAR2          ,--是否全部
      prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
      prm_aae013       IN     iraa02.aae013%TYPE,--备注
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

      --定义游标，获取批量审核人员信息
      CURSOR cur_tmp_person IS
      SELECT a.IAC001, --申报人员信息编号,VARCHAR2
             b.AAC001, --个人编号,VARCHAR2
             a.AAB001, --单位编号,VARCHAR2
             a.AAC002, --公民身份号码,VARCHAR2
             a.AAC003, --姓名,VARCHAR2
             b.IAA001, --人员类别
             a.IAZ005, --申报明细ID
             a.IAA003  --业务主体
        FROM wsjb.IRAD22_TMP  a,wsjb.IRAC01  b --批量审核人员信息零时表
       WHERE a.iac001 = b.iac001
        ORDER by a.iaa003;

   BEGIN

      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;


      /*检查临时表是否存在数据*/
      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.IRAD22_TMP ;
      IF n_count = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'审核临时表无可用数据!';
         RETURN;
      END IF;


      /*必要的数据校验*/
      IF prm_iaa011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'业务类型不能为空!';
         RETURN;
      END IF;

      IF prm_iaa003 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'业务主体不能为空!';
         RETURN;
      END IF;

      IF prm_iaa018 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'审核标志不能为空!';
         RETURN;
      END IF;

      IF prm_iaa028 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'标志[是否全部]不能为空!';
         RETURN;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
      IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号AAZ002!';
         RETURN;
      END IF;

      v_iaz009 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ009');
      IF v_iaz009 IS NULL OR v_iaz009 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号IAZ009!';
         RETURN;
      END IF;

      --审核事件
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

         --申报主体是个人时校验：必须单位信息审核通过才能办理
         IF REC_TMP_PERSON.iaa003 = PKG_Constant.IAA003_PER THEN
            SELECT COUNT(1)
              INTO n_count
              FROM wsjb.IRAB01
             WHERE AAB001 = REC_TMP_PERSON.AAB001
               AND IAA002 = PKG_Constant.IAA002_APS;
            IF n_count = 0 THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'单位信息审核通过才能办理业务!';
               RETURN;
            END IF;
         END IF;

          /*
            针对人员的信息审核
            可以办理的是打回 通过 不通过 批量通过 全部通过 全不通过
         */

         --审核明细处理
         v_iaz010 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ010');
         IF v_iaz010 IS NULL OR v_iaz010 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号IAZ010!';
            RETURN;
         END IF;

         --查询上次审核情况
         BEGIN
            SELECT IAA015
              INTO v_iaa015
              FROM wsjb.IRAD02
             WHERE IAZ005 = REC_TMP_PERSON.IAZ005;

            IF v_iaa015 in (PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
              prm_ErrorMsg := PRE_ERRCODE ||'审核已经终结!';
              RETURN;
           END IF;

            --提取上次审核信息
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
                                          PKG_Constant.IAA018_DAD, --打回[放弃审核]
                                          PKG_Constant.IAA018_NPS  --不通过 Not Pass
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
                     prm_ErrorMsg := PRE_ERRCODE ||'申报信息处于审核中，但未获取到上次审核信息,请确认上次审核是否终结!';
                     RETURN;
               END;

               v_iaa014 := v_iaa017;
               v_iaa017 := v_iaa017 + 1;
               IF v_iaa017 > v_iaa004 THEN
                  v_iaa017 := v_iaa004;
               END IF;

               --审核级次等于当前级次
               IF v_iaa004 = v_iaa014 AND v_iaa004 = v_iaa017 THEN
                  ROLLBACK;
                  prm_AppCode  := gn_def_ERR;
                  prm_ErrorMsg := PRE_ERRCODE ||'审核已经终结!';
                  RETURN;
               END IF;
            END IF;

            --提取申报明细信息
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
                     prm_ErrorMsg := PRE_ERRCODE ||'没有提取到申报明细信息!';
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
               prm_ErrorMsg := '审核信息提取错误:'|| PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace  ;
               RETURN;
         END;

         --审核明细写入
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
                     IAD005,    --审核意见
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
                     prm_aae013,  --审核意见
                     null
         );

         --打回
         IF prm_iaa018 = PKG_Constant.IAA018_DAD THEN

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_DAD,--打回[修改续报]
                   AAE013 = prm_aae013
             WHERE IAA015 = PKG_Constant.IAA015_WAD --待审
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_ALR  --已打回
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --审核未通过
         IF prm_iaa018 = PKG_Constant.IAA018_NPS THEN

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015  = PKG_Constant.IAA015_ADO, --审核完毕
                   AAE013  = prm_aae013
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --待审/审核中
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_NPS  --未通过
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --审核通过
         IF prm_iaa018 = PKG_Constant.IAA018_PAS AND v_iaa014 = v_iaa004 THEN

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015  =  PKG_Constant.IAA015_ADO --审核完毕
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --待审/审核中
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            v_yae099    := xasi2.PKG_comm.fun_GetSequence(NULL,'yae099');
            IF v_yae099 IS NULL OR v_yae099 = '' THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'没有获取到系统库的序列号:YAE099';
               RETURN;
            END IF;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_APS  --已通过
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAC001 = REC_TMP_PERSON.IAC001;


               /*
                  人员增加[人员续保]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_CIN THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[新参保 续保]
                     老方法 prc_AuditSocietyInsuranceRPer
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
                  人员减少[人员暂停缴费]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_MIN THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[停保 退休]
                     老方法 prc_AuditMonthInternetRpause
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
            --回退相关表
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

      --日志记录
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
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| PRE_ERRCODE || SQLERRM ||dbms_utility.format_error_backtrace ;
         RETURN;
   END prc_AuditRecoverySuspend;


/*****************************************************************************
   ** 过程名称 : prc_preview
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报缴费预览
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_iaa100       IN     irac01a4.iaa100%TYPE,--申报月度
   **           prm_aae110       IN     irac01a4.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-12   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
  PROCEDURE prc_preview (
      prm_aab001       IN     irab01.aab001%TYPE,
      prm_yae099       IN     VARCHAR2,
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
   var_procNo            VARCHAR2(2);          --过程序号
   var_aac001            xasi2.ac01.aac001%TYPE;     --个人编号
   var_aae140            xasi2.ac02.aae140%TYPE;     --险种
   num_yac004            xasi2.ac02.aac040%TYPE;     --缴费基数
   num_count             NUMBER;
   num_per_count         NUMBER;               --人数
   num_nmg_count         NUMBER;               --参失业的农民工人数
   num_aab120            xasi2.ab08.aab120%TYPE;     --缴费基数总额
   num_aab156            xasi2.ab08.aab156%TYPE;     --单位欠费金额
   num_person            xasi2.ab08.aab156%TYPE;     --个人缴费金额
   num_danwei            xasi2.ab08.aab156%TYPE;     --单位缴费金额
   num_aaa041            NUMBER(13,4);         --个人缴费比例
   num_aaa043            NUMBER(13,4);         --单位缴费比例
   var_yac168            xasi2.ac01.yac168%TYPE;     --农民工标识
   var_aaa040            xasi2.ab02.aaa040%TYPE;     --比例类别
   var_akc021            VARCHAR2(6);          --医疗人员状态
   var_aab019            VARCHAR2(6);          --单位类型
   --查询出单位未申报的人员信息(中心数据库)
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
           yac168 AS yac168,          --农民工标识
           yac005 AS yac005,          --缴费基数
           yac004 AS yac004,          --养老基数
           aae110 AS aae110,          --职工养老
           aae120 AS aae120,          --机关养老
           aae210 AS aae210,          --失业
           aae310 AS aae310,          --医疗
           aae410 AS aae410,          --工伤
           aae510 AS aae510,          --生育
           aae311 AS aae311           --大额
      FROM wsjb.irac01
     WHERE aab001 = prm_aab001
       AND iaa001 IN ('1','5','6','8')   --申报人员类别
       AND iaa002 = '0'
       AND iaa100 IS NULL;             --申报人员信息状态
    BEGIN
    prm_AppCode    := gn_def_OK ;
    prm_ErrorMsg     := ''                  ;
    var_procNo     := '06';
    --计算养老以外的险种
    FOR rec_aae140 IN cur_aae140 LOOP
        var_aae140 := rec_aae140.aae140;
        num_aab120 := 0;
        num_per_count := 0;
        num_nmg_count := 0;
        num_aab156 := 0;
        num_person := 0;
        num_danwei := 0;
         --获取单位缴费比例
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
        --判断减少人员
        FOR rec_ac02 IN cur_ac02 LOOP
            var_aac001 := rec_ac02.aac001;
            num_yac004 := rec_ac02.yac004;

            --获取缴费比例
            IF var_aae140 = '03' THEN
               num_aaa041 := 0.02;
               num_aaa043 := 0.07;
               SELECT AKC021
                 INTO VAR_AKC021
                 FROM XASI2.KC01
                WHERE AAB001 = PRM_AAB001
                  AND AAC001 = REC_AC02.AAC001;
            ELSIF var_aae140 = '02' THEN
               --获取农民工标志
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
            --查询人员是否存在减少申报中(不包括在职转退休)
            SELECT count(1)
              INTO num_count
              FROM wsjb.irac01
             WHERE aac001 = var_aac001
               AND iaa001 IN ('3','7','9','10')
               AND iaa002 = '0'
               AND iaa100 IS NULL;
            --如果人员不存在则缴费人数加1
            IF num_count < 1 THEN
               num_per_count := num_per_count + 1;
               IF var_yac168 = '1' AND var_aae140 = '02' THEN
                  num_nmg_count := num_nmg_count + 1;
               END IF;
               --如果是大额只交8块钱
               IF var_aae140 = '07' THEN
                 num_aab120 := 0;
                 num_person := num_person+1.6;
                 num_danwei := num_danwei+6.4;
                 num_aab156 := num_aab156+8;
               ELSE
                 --缴费基数总额累加
                 num_aab120 := num_aab120+num_yac004;
                 --如果为退休人员缴费金额加0
                 IF var_aae140 = '03' AND var_akc021 = '21' THEN
                   --个人缴费金额累加
                   num_person := num_person + 0;
                   --单位缴费金额累加
                   num_danwei := num_danwei + 0;
                   --单位缴费总额累加
                   num_aab156 := num_aab156 + 0;
                ELSE
                 --个人缴费金额累加
                 num_person := num_person + ROUND(num_yac004*num_aaa041,2);
                 --单位缴费金额累加
                 num_danwei := num_danwei + ROUND(num_yac004*num_aaa043,2);
                 --单位缴费总额累加
                 num_aab156 := num_aab156 + ROUND(num_yac004*num_aaa041,2) + ROUND(num_yac004*num_aaa043,2);
                END IF;
               END IF;
            END IF;
            --如果是在职转退休人员
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
        --判断新增人员
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
      --计算出来的金额插入临时表中

      INSERT INTO wsjb.TMP_AB08_VIEW (aab001,   --单位编号
                                aae140,   --险种
                                aab120,   --缴费基数
                                yae231,   --人数
                                aab152,   --个人缴费金额
                                aab150,   --单位缴费金额
                                aab156,   --应缴金额
                                yae099,
                                yae232)   --参失业农民工人数
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
    --重新计算养老
    num_person := 0;
    num_per_count := 0;
    num_aab120 := 0;
    num_aab156 := 0;
    num_danwei := 0;
    --养老基本人数,金额
    SELECT NVL(SUM(yac004),0),
           count(1)
      INTO num_aab120,
           num_per_count
      FROM wsjb.IRAC01A3
     WHERE aab001 = prm_aab001
       AND aae110 = '2';
    --除去养老暂停的人数，金额
    SELECT num_aab120-NVL(SUM(yac004),0),
           num_per_count-count(1)
      INTO num_aab120,
           num_per_count
      FROM wsjb.IRAC01
     WHERE aab001 = prm_aab001
       AND iaa001 IN ('3','7','9','10')
       AND iaa002 = '0'
       AND aae110 = '3'    --养老暂停
       AND iaa100 IS NULL;
     -- 加上养老新增、续保的人数、金额
     SELECT num_aab120+NVL(SUM(yac004),0),
            num_per_count+count(1)
       INTO num_aab120,
            num_per_count
       FROM  wsjb.irac01
      WHERE aab001 = prm_aab001
        AND iaa001 IN ('1','5','6','8')   --申报人员类别
        AND iaa002 = '0'
        AND aae110 in ('1','10')    --养老新增
        AND iaa100 IS NULL;
      --计算出来的金额插入临时表中
      SELECT aab019
        INTO var_aab019
        FROM xasi2.ab01
       WHERE aab001 = prm_aab001;
       IF var_aab019 = '60' THEN --个体工商户养老比例
        INSERT INTO wsjb.TMP_AB08_VIEW (aab001,   --单位编号
                                aae140,   --险种
                                aab120,   --缴费基数
                                yae231,   --人数
                                aab152,   --个人缴费金额
                                aab150,   --单位缴费金额
                                aab156,   --应缴金额
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
        INSERT INTO wsjb.TMP_AB08_VIEW (aab001,   --单位编号
                                aae140,   --险种
                                aab120,   --缴费基数
                                yae231,   --人数
                                aab152,   --个人缴费金额
                                aab150,   --单位缴费金额
                                aab156,   --应缴金额
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
      --将非失业险种农民工人数更新为null
      UPDATE wsjb.TMP_AB08_VIEW  SET yae232 = NULL WHERE aab001 = prm_aab001 AND aae140 <> '02';
    EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := '00';
         prm_ErrorMsg  := '单位预览出错,出错原因:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
END prc_preview;

/*****************************************************************************
   ** 过程名称 : prc_repreview
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：单位打回月申报缴费预览
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-12   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
  PROCEDURE prc_repreview (
      prm_aab001       IN     irab01.aab001%TYPE,
      prm_iaa100       IN     irad01.iaa100%TYPE,
      prm_yae099       IN     VARCHAR2,
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
   var_procNo            VARCHAR2(2);          --过程序号
   var_aac001            xasi2.ac01.aac001%TYPE;     --个人编号
   var_aae140            xasi2.ac02.aae140%TYPE;     --险种
   num_yac004            xasi2.ac02.aac040%TYPE;     --缴费基数
   num_count             NUMBER;
   num_per_count         NUMBER;               --人数
   num_nmg_count         NUMBER;               --参失业的农民工人数
   num_aab120            xasi2.ab08.aab120%TYPE;     --缴费基数总额
   num_aab156            xasi2.ab08.aab156%TYPE;     --单位欠费金额
   num_person            xasi2.ab08.aab156%TYPE;     --个人缴费金额
   num_danwei            xasi2.ab08.aab156%TYPE;     --单位缴费金额
   num_aaa041            NUMBER(13,4);         --个人缴费比例
   num_aaa043            NUMBER(13,4);         --单位缴费比例
   var_yac168            xasi2.ac01.yac168%TYPE;     --农民工标识
   var_aaa040            xasi2.ab02.aaa040%TYPE;     --比例类别
   var_akc021            VARCHAR2(6);          --医疗人员状态
   var_aab019            VARCHAR2(6);          --单位类型
   --查询出单位未申报的人员信息(中心数据库)
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
           yac168 AS yac168,          --农民工标识
           yac005 AS yac005,          --缴费基数
           yac004 AS yac004,          --养老基数
           aae110 AS aae110,          --职工养老
           aae120 AS aae120,          --机关养老
           aae210 AS aae210,          --失业
           aae310 AS aae310,          --医疗
           aae410 AS aae410,          --工伤
           aae510 AS aae510,          --生育
           aae311 AS aae311           --大额
      FROM  wsjb.irac01
     WHERE aab001 = prm_aab001
       AND iaa100 = prm_iaa100            --申报月度
       AND iaa001 IN ('1','5','6','8')   --申报人员类别
       AND iaa002 IN ('1','4');

    BEGIN
    prm_AppCode    := gn_def_OK ;
    prm_ErrorMsg     := '';
    var_procNo     := '06';
    --计算养老以外的险种
    FOR rec_aae140 IN cur_aae140 LOOP
        var_aae140 := rec_aae140.aae140;
        num_aab120 := 0;
        num_per_count := 0;
        num_nmg_count := 0;
        num_aab156 := 0;
        num_person := 0;
        num_danwei := 0;
        --获取单位缴费比例
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
        --判断减少人员
        FOR rec_ac02 IN cur_ac02 LOOP
            var_aac001 := rec_ac02.aac001;
            num_yac004 := rec_ac02.yac004;

            --获取缴费比例
            IF var_aae140 = '03' THEN
               num_aaa041 := 0.02;
               num_aaa043 := 0.07;
               SELECT AKC021
                 INTO VAR_AKC021
                 FROM XASI2.KC01
                WHERE AAB001 = PRM_AAB001
                  AND AAC001 = REC_AC02.AAC001;
            ELSIF var_aae140 = '02' THEN
               --获取农民工标志
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
            --查询人员是否存在减少申报中(不包括在职转退休)
            SELECT count(1)
              INTO num_count
              FROM  wsjb.irac01
             WHERE aac001 = var_aac001
               AND aab001 = prm_aab001
               AND iaa001 IN ('3','7','9','10')
               AND iaa002 IN ('1','4')
               AND iaa100 =prm_iaa100;
            --如果人员不存在则缴费人数加1
            IF num_count < 1 THEN
               num_per_count := num_per_count + 1;
               IF var_yac168 = '1' AND var_aae140 = '02' THEN
                  num_nmg_count := num_nmg_count + 1;
               END IF;
               --如果是大额只交8块钱
               IF var_aae140 = '07' THEN
                 num_aab120 := 0;
                 num_person := num_person+1.6;
                 num_danwei := num_danwei+6.4;
                 num_aab156 := num_aab156+8;
               ELSE
                 --缴费基数总额累加
                 num_aab120 := num_aab120+num_yac004;
                 --如果为退休人员缴费金额加0
                 IF var_aae140 = '03' AND var_akc021 = '21' THEN
                   --个人缴费金额累加
                   num_person := num_person + 0;
                   --单位缴费金额累加
                   num_danwei := num_danwei + 0;
                   --单位缴费总额累加
                   num_aab156 := num_aab156 + 0;
                ELSE
                 --个人缴费金额累加
                 num_person := num_person + ROUND(num_yac004*num_aaa041,2);
                 --单位缴费金额累加
                 num_danwei := num_danwei + ROUND(num_yac004*num_aaa043,2);
                 --单位缴费总额累加
                 num_aab156 := num_aab156 + ROUND(num_yac004*num_aaa041,2) + ROUND(num_yac004*num_aaa043,2);
                END IF;
               END IF;
            END IF;
            --如果是在职转退休人员
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
        --判断新增人员
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
      --计算出来的金额插入临时表中

      INSERT INTO wsjb.TMP_AB08_VIEW (aab001,   --单位编号
                                aae140,   --险种
                                aab120,   --缴费基数
                                yae231,   --人数
                                aab152,   --个人缴费金额
                                aab150,   --单位缴费金额
                                aab156,   --应缴金额
                                yae099,
                                yae232)   --参失业农民工人数
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
    --重新计算养老
    num_person := 0;
    num_per_count := 0;
    num_aab120 := 0;
    num_aab156 := 0;
    num_danwei := 0;
    --养老基本人数,金额
    SELECT NVL(SUM(yac004),0),
           count(1)
      INTO num_aab120,
           num_per_count
      FROM wsjb.IRAC01A3
     WHERE aab001 = prm_aab001
       AND aae110 = '2';
    --除去养老暂停的人数，金额
    SELECT num_aab120-NVL(SUM(yac004),0),
           num_per_count-count(1)
      INTO num_aab120,
           num_per_count
      FROM  wsjb.irac01
     WHERE aab001 = prm_aab001
       AND iaa001 IN ('3','7','9','10')
       AND iaa002 IN ('1','4')
       AND aae110 = '3'    --养老暂停
       AND iaa100 = prm_iaa100;
     -- 加上养老新增、续保的人数、金额
     SELECT num_aab120+NVL(SUM(yac004),0),
            num_per_count+count(1)
       INTO num_aab120,
            num_per_count
       FROM  wsjb.irac01
      WHERE aab001 = prm_aab001
        AND iaa001 IN ('1','5','6','8')   --申报人员类别
        AND iaa002 IN ('1','4')
        AND aae110 in ('1','10')    --养老新增
        AND iaa100 = prm_iaa100;
      --计算出来的金额插入临时表中
      SELECT aab019
        INTO var_aab019
        FROM xasi2.ab01
       WHERE aab001 = prm_aab001;
       IF var_aab019 = '60' THEN --个体工商户养老比例
        INSERT INTO  wsjb.TMP_AB08_VIEW (aab001,   --单位编号
                                aae140,   --险种
                                aab120,   --缴费基数
                                yae231,   --人数
                                aab152,   --个人缴费金额
                                aab150,   --单位缴费金额
                                aab156,   --应缴金额
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
        INSERT INTO  wsjb.TMP_AB08_VIEW (aab001,   --单位编号
                                aae140,   --险种
                                aab120,   --缴费基数
                                yae231,   --人数
                                aab152,   --个人缴费金额
                                aab150,   --单位缴费金额
                                aab156,   --应缴金额
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


      --将非失业险种农民工人数更新为null
      UPDATE wsjb.TMP_AB08_VIEW  SET yae232 = NULL WHERE aab001 = prm_aab001 AND aae140 <> '02';
    EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := '00';
         prm_ErrorMsg  := '打回单位预览出错,出错原因:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
END prc_repreview;

/*****************************************************************************
   ** 过程名称 : prc_YLAuditMonth
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：单养老单位月申报审核
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_iaa011       IN     iraa02.iaa011%TYPE,--业务类型
   **           prm_iaa003       IN     iraa02.iaa003%TYPE,--业务主体
   **           prm_iaa004       IN     iraa02.iaa011%TYPE,--审核标志
   **           prm_iaa028       IN     VARCHAR2          ,--是否全部
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_aae013       IN     iraa02.aae013%TYPE,--备注
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2013-05-16   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_YLAuditMonth(
      prm_iaa011       IN     iraa02.iaa011%TYPE,--业务类型
      prm_iaa003       IN     iraa02.iaa003%TYPE,--业务主体
      prm_iaa018       IN     irad22.iaa018%TYPE,--审核标志
      prm_iaa028       IN     VARCHAR2          ,--是否全部
      prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
      prm_aae013       IN     iraa02.aae013%TYPE,--备注
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
      var_aae140_01   VARCHAR2(2);         --是否参加了企业养老
      rec_irac01      irac01%rowtype;
      var_yac001      VARCHAR2(20);
      var_aac001      VARCHAR2(15);
      var_yae235      VARCHAR2(6);
      var_yae238      VARCHAR2(2000);

      --定义游标，获取批量审核人员信息
      CURSOR cur_tmp_person IS
      SELECT a.IAC001, --申报人员信息编号,VARCHAR2
             b.AAC001, --个人编号,VARCHAR2
             a.AAB001, --单位编号,VARCHAR2
             a.AAC002, --公民身份号码,VARCHAR2
             a.AAC003, --姓名,VARCHAR2
             b.IAA001, --人员类别
             a.IAZ005, --申报明细ID
             a.IAA003  --业务主体
        FROM wsjb.IRAD22_TMP  a, wsjb.irac01  b --批量审核人员信息零时表
       WHERE a.iac001 = b.iac001
        ORDER by a.iaa003;

   BEGIN

      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;


      /*检查临时表是否存在数据*/
      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.IRAD22_TMP ;
      IF n_count = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'审核临时表无可用数据!';
         RETURN;
      END IF;


      /*必要的数据校验*/
      IF prm_iaa011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'业务类型不能为空!';
         RETURN;
      END IF;

      IF prm_iaa003 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'业务主体不能为空!';
         RETURN;
      END IF;

      IF prm_iaa018 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'审核标志不能为空!';
         RETURN;
      END IF;

      IF prm_iaa028 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'标志[是否全部]不能为空!';
         RETURN;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
      IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号AAZ002!';
         RETURN;
      END IF;

      v_iaz009 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ009');
      IF v_iaz009 IS NULL OR v_iaz009 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号IAZ009!';
         RETURN;
      END IF;

      --审核事件
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

         --申报主体是个人时校验：必须单位信息审核通过才能办理
         IF REC_TMP_PERSON.iaa003 = PKG_Constant.IAA003_PER THEN
            SELECT COUNT(1)
              INTO n_count
              FROM wsjb.IRAB01
             WHERE AAB001 = REC_TMP_PERSON.AAB001
               AND IAA002 = PKG_Constant.IAA002_APS;
            IF n_count = 0 THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'单位信息审核通过才能办理人员月申报审核!';
               RETURN;
            END IF;
         END IF;

          /*
            针对人员的信息审核
            可以办理的是打回 通过 不通过 批量通过 全部通过 全不通过
         */

         --审核明细处理
         v_iaz010 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ010');
         IF v_iaz010 IS NULL OR v_iaz010 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号IAZ010!';
            RETURN;
         END IF;

         --查询上次审核情况
         BEGIN
            SELECT IAA015
              INTO v_iaa015
              FROM wsjb.IRAD02
             WHERE IAZ005 = REC_TMP_PERSON.IAZ005;

            IF v_iaa015 in (PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
              prm_ErrorMsg := PRE_ERRCODE ||'审核已经终结!';
              RETURN;
           END IF;

            --提取上次审核信息
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
                                          PKG_Constant.IAA018_DAD, --打回[放弃审核]
                                          PKG_Constant.IAA018_NPS  --不通过 Not Pass
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
                     prm_ErrorMsg := PRE_ERRCODE ||'申报信息处于审核中，但未获取到上次审核信息,请确认上次审核是否终结!';
                     RETURN;
               END;

               v_iaa014 := v_iaa017;
               v_iaa017 := v_iaa017 + 1;
               IF v_iaa017 > v_iaa004 THEN
                  v_iaa017 := v_iaa004;
               END IF;

               --审核级次等于当前级次
               IF v_iaa004 = v_iaa014 AND v_iaa004 = v_iaa017 THEN
                  ROLLBACK;
                  prm_AppCode  := gn_def_ERR;
                  prm_ErrorMsg := PRE_ERRCODE ||'审核已经终结!';
                  RETURN;
               END IF;
            END IF;

            --提取申报明细信息
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
                     prm_ErrorMsg := PRE_ERRCODE ||'没有提取到申报明细信息!';
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
               prm_ErrorMsg := '审核信息提取错误:'|| PRE_ERRCODE || SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
               RETURN;
         END;

         --审核明细写入
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
                     IAD005,    --审核意见
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
                     prm_aae013,  --审核意见
                     null
         );

         --打回
         IF prm_iaa018 = PKG_Constant.IAA018_DAD THEN

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_DAD,--打回[修改续报]
                   AAE013 = prm_aae013
             WHERE IAA015 = PKG_Constant.IAA015_WAD --待审
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_ALR  --已打回
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --审核未通过
         IF prm_iaa018 = PKG_Constant.IAA018_NPS THEN

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015  = PKG_Constant.IAA015_ADO, --审核完毕
                   AAE013  = prm_aae013
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --待审/审核中
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_NPS  --未通过
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --审核通过
         IF prm_iaa018 = PKG_Constant.IAA018_PAS AND v_iaa014 = v_iaa004 THEN

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015  =  PKG_Constant.IAA015_ADO --审核完毕
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --待审/审核中
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            v_yae099 := xasi2.PKG_comm.fun_GetSequence(NULL,'yae099');
            IF v_yae099 IS NULL OR v_yae099 = '' THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'没有获取到系统库的序列号:YAE099';
               RETURN;
            END IF;

            SELECT *
              INTO rec_irac01
              FROM wsjb.IRAC01
             WHERE IAC001 = REC_TMP_PERSON.IAC001;

            IF REC_TMP_PERSON.iaa003 = '2' THEN


               /*
                  人员增加[新参保与批量新参保]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_ADD,PKG_Constant.IAA001_PAD) THEN


                  var_aae140_01 := rec_irac01.aae110;        --是否参加了企业养老
                  IF var_aae140_01 = '1' THEN
                    SELECT COUNT(1)
                      INTO n_count
                      FROM xasi2.ac01
                     WHERE aac002 = rec_irac01.aac002;
                    IF n_count > 0 THEN
                        prm_AppCode := gn_def_ERR ;
                        prm_ErrorMsg  := '存在身份证号['||rec_irac01.aac002||']的人员信息，请检查！';
                        RETURN;
                    END IF;
                    var_aac001 := xasi2.pkg_comm.fun_GetSequence(NULL,'aac001');
                    IF var_aac001 is null THEN
                        prm_AppCode := gn_def_ERR ;
                        prm_ErrorMsg  := '没有获取到人员编号aac001!';
                        RETURN;
                    END IF;

                    SELECT count(1)
                      INTO n_count
                      FROM xasi2.ac01
                     WHERE aac001 = var_aac001;
                     IF n_count = 0 THEN
                       --插入个人信息表
                       INSERT INTO xasi2.ac01(
                                       aac001,          -- 个人编号
                                       yae181,          -- 证件类型
                                       aac002,          -- 身份证号码(证件号码)
                                       aac003,          -- 姓名
                                       aac004,          -- 性别
                                       aac005,          -- 民族
                                       aac006,          -- 出生日期
                                       aac007,          -- 参加工作日期
                                       aac008,          -- 人员状态
                                       aac009,          -- 户口性质
                                       aac013,          -- 用工形式
                                       yac067,          -- 来源方式
                                       yac168,          -- 农民工标志
                                       aae005,          -- 联系电话
                                       aae006,          -- 地址
                                       aae011,          -- 经办人
                                       aae036,          -- 经办时间
                                       aae120,          -- 注销标志
                                       aae013)
                              VALUES ( var_aac001,                 -- 个人编号
                                       rec_irac01.yae181,          -- 证件类型
                                       rec_irac01.aac002,          -- 身份证号码(证件号码)
                                       rec_irac01.aac003,          -- 姓名
                                       rec_irac01.aac004,          -- 性别
                                       rec_irac01.aac005,          -- 民族
                                       rec_irac01.aac006,          -- 出生日期
                                       rec_irac01.aac007,          -- 参加工作日期
                                       rec_irac01.aac008,          -- 人员状态
                                       rec_irac01.aac009,          -- 户口性质
                                       rec_irac01.aac013,          -- 用工形式
                                       '1',                        -- 来源方式
                                       rec_irac01.yac168,          -- 农民工标志
                                       rec_irac01.aae005,          -- 联系电话
                                       rec_irac01.aae006,          -- 地址
                                       prm_aae011,                 -- 经办人
                                       sysdate,                 -- 经办时间
                                       '0',                        -- 注销标志
                                       '单养老险种单位新增养老人员'); --备注
                   ELSIF n_count >0 THEN
                       prm_AppCode := gn_def_ERR ;
                       prm_ErrorMsg  := '个人编号'||var_aac001||'医疗库存在数据，请核实！';
                       RETURN;
                   END IF;

                   --更新申报信息的人员编号
                   UPDATE wsjb.IRAC01
                      SET AAC001 = var_aac001
                    WHERE IAC001 = REC_TMP_PERSON.IAC001;

                   --更新申报明细信息的人员编号
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
                          prm_ErrorMsg  := '没有获取到单位人员序列号yac001!';
                          RETURN;
                       END IF;
                       INSERT INTO wsjb.irac01a3 (
                                   yac001,
                                   aac001,          -- 个人编号
                                   aab001,
                                   yae181,          -- 证件类型
                                   aac002,          -- 身份证号码(证件号码)
                                   aac003,          -- 姓名
                                   aac004,          -- 性别
                                   aac005,
                                   aac006,          -- 出生日期
                                   aac007,          -- 参加工作日期
                                   aac008,          -- 人员状态
                                   aac009,
                                   aac010,
                                   aac012,
                                   aac013,
                                   aac014,
                                   aac015,
                                   aac020,
                                   yac067,          -- 来源方式
                                   yac168,          -- 农民工标志
                                   aae004,
                                   aae005,          -- 联系电话
                                   aae006,          -- 地址
                                   aae007,
                                   yae222,
                                   aae013,
                                   aac040,
                                   yab139,
                                   yab013,
                                   aae011,          -- 经办人
                                   aae036)          -- 经办时间
                          VALUES ( var_yac001,
                                   NVL(var_aac001,rec_irac01.AAC001),          -- 个人编号
                                   rec_irac01.aab001,
                                   rec_irac01.yae181,          -- 证件类型
                                   rec_irac01.aac002,          -- 身份证号码(证件号码)
                                   rec_irac01.aac003,          -- 姓名
                                   rec_irac01.aac004,          -- 性别
                                   rec_irac01.aac005,
                                   rec_irac01.aac006,          -- 出生日期
                                   rec_irac01.aac007,          -- 参加工作日期
                                   rec_irac01.aac008,          -- 人员状态
                                   rec_irac01.aac009,
                                   rec_irac01.aac010,
                                   rec_irac01.aac012,
                                   rec_irac01.aac013,
                                   rec_irac01.aac014,
                                   rec_irac01.aac015,
                                   rec_irac01.aac020,
                                   rec_irac01.yac067,          -- 来源方式
                                   rec_irac01.yac168,          -- 农民工标志
                                   rec_irac01.aae004,
                                   rec_irac01.aae005,          -- 联系电话
                                   rec_irac01.aae006,          -- 地址
                                   rec_irac01.aae007,
                                   rec_irac01.yae222,
                                   rec_irac01.aae013,
                                   0,
                                   PKG_Constant.YAB003_JBFZX,
                                   rec_irac01.aab001,
                                   prm_aae011,          -- 经办人
                                   sysdate);         -- 经办时间
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
                  人员续保
               */
              IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_CIN THEN


                  var_aae140_01 := rec_irac01.aae110;        --是否参加了企业养老
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
                            prm_ErrorMsg  := '没有获取到单位人员序列号yac001!';
                            RETURN;
                         END IF;
                         INSERT INTO wsjb.irac01a3 (
                                     yac001,
                                     aac001,          -- 个人编号
                                     aab001,
                                     yae181,          -- 证件类型
                                     aac002,          -- 身份证号码(证件号码)
                                     aac003,          -- 姓名
                                     aac004,          -- 性别
                                     aac005,
                                     aac006,          -- 出生日期
                                     aac007,          -- 参加工作日期
                                     aac008,          -- 人员状态
                                     aac009,
                                     aac010,
                                     aac012,
                                     aac013,
                                     aac014,
                                     aac015,
                                     aac020,
                                     yac067,          -- 来源方式
                                     yac168,          -- 农民工标志
                                     aae004,
                                     aae005,          -- 联系电话
                                     aae006,          -- 地址
                                     aae007,
                                     yae222,
                                     aae013,
                                     aac040,
                                     yab139,
                                     yab013,
                                     aae011,          -- 经办人
                                     aae036)          -- 经办时间
                            VALUES ( var_yac001,
                                     NVL(var_aac001,rec_irac01.AAC001),          -- 个人编号
                                     rec_irac01.aab001,
                                     rec_irac01.yae181,          -- 证件类型
                                     rec_irac01.aac002,          -- 身份证号码(证件号码)
                                     rec_irac01.aac003,          -- 姓名
                                     rec_irac01.aac004,          -- 性别
                                     rec_irac01.aac005,
                                     rec_irac01.aac006,          -- 出生日期
                                     rec_irac01.aac007,          -- 参加工作日期
                                     rec_irac01.aac008,          -- 人员状态
                                     rec_irac01.aac009,
                                     rec_irac01.aac010,
                                     rec_irac01.aac012,
                                     rec_irac01.aac013,
                                     rec_irac01.aac014,
                                     rec_irac01.aac015,
                                     rec_irac01.aac020,
                                     rec_irac01.yac067,          -- 来源方式
                                     rec_irac01.yac168,          -- 农民工标志
                                     rec_irac01.aae004,
                                     rec_irac01.aae005,          -- 联系电话
                                     rec_irac01.aae006,          -- 地址
                                     rec_irac01.aae007,
                                     rec_irac01.yae222,
                                     rec_irac01.aae013,
                                     0,
                                     PKG_Constant.YAB003_JBFZX,
                                     rec_irac01.aab001,
                                     prm_aae011,          -- 经办人
                                     sysdate);         -- 经办时间
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
                  人员减少[人员暂停缴费与批量暂停缴费，退休人员死亡(与暂停雷同),在职转退休(单养老只有停保)]
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
                        prm_ErrorMsg  := '没有从irac01a3中获取参保信息';
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

               --2013-03-14 王雷  应该是先进行操作最后更新状态
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_APS  --已通过
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;
            --回退相关表
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

      --日志记录
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
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| PRE_ERRCODE || SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END prc_YLAuditMonth;
/*****************************************************************************
   ** 过程名称 : prc_RollBackAMIRBYYL
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：回退月申报审核(单养老单位)
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aaz002       IN     ae02.aaz002%TYPE  ,--业务日志编号
   **           prm_iaa100       IN     irad01.iaa100%TYPE,--申报月度
   **           prm_aae011       IN     irad31.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-06   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_RollBackAMIRBYYL (
      prm_aaz002       IN     ae02.aaz002%TYPE,  --业务日志编号
      prm_iaa100       IN     irad01.iaa100%TYPE,--申报月度
      prm_aab001       IN     irad01.aab001%TYPE,--申报单位
      prm_aae011       IN     irad31.aae011%TYPE,--经办人
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum     NUMBER;
      var_yae099   xasi2.ac02a2.YAE099%TYPE;
      var_iaa020   irad02.iaa020%TYPE; --申报业务主体
      --需要回退的数据
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

      --对审核完毕的数据处于再申报待审时不能回退
      /*SELECT count(1)
        INTO countnum
        FROM irad21 a,irad22 b,irad02 c
       WHERE a.iaz009 = b.iaz009
         AND b.iaz005 = c.iaz006
         AND c.iaa015 = PKG_Constant.IAA015_WAD  --待审
         AND a.aaz002 = prm_aaz002;
      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '存在待审的数据，不能回退！';
         RETURN;
      END IF;*/

      --对审核完毕的数据处于应收核定之后不能回退
      SELECT count(1)
        INTO countnum
        FROM wsjb.irab08
       WHERE aab001 = prm_aab001
         AND aae003 = prm_iaa100
         AND yae517 = 'H01';       --正常应收核定
      IF countnum > 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据已经做过应收核定，不能回退！';
         RETURN;
      END IF;

      --对审核完毕的数据处于实收分配之后不能回退
--      SELECT count(1)
--        INTO countnum
--        FROM ab08a8
--       WHERE aab001 = prm_aab001
--         AND aae003 = prm_iaa100
--         AND yae517 = 'H01';       --正常应收核定
--      IF countnum > 0 THEN
--         prm_AppCode  :=  gn_def_ERR;
--         prm_ErrorMsg := '数据已经做过实收分配，不能回退！';
--         RETURN;
--      END IF;

      --检查是否存在可回退的数据
      SELECT count(1)
        INTO countnum
        FROM wsjb.irad21  a,wsjb.irad22  b,wsjb.irad02  c
       WHERE a.iaz009 = b.iaz009
         AND b.iaz005 = c.iaz005
         AND c.iaa015 IN(PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)  --审核完毕或者放弃审核
         AND a.aaz002 = prm_aaz002;
      IF countnum = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '不存在可回退的数据，不能回退！';
         RETURN;
      END IF;

      --循环处理
      FOR REC_TMP_PERSON in personCur LOOP

         --打回
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_DAD THEN
            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD, --待审
                   AAE013 = NULL
             WHERE IAA015 = PKG_Constant.IAA015_DAD --打回[放弃审核]
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            --审核的是个人
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --已申报
                WHERE IAA002 = PKG_Constant.IAA002_ALR  --已打回
                  AND IAC001 = REC_TMP_PERSON.IAZ007;
            END IF;
         END IF;

         --不通过
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_NPS THEN
            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD, --待审
                   AAE013 = NULL
             WHERE IAA015 = PKG_Constant.IAA015_ADO --审核完毕
               AND IAZ005 =  REC_TMP_PERSON.IAZ005;

            --审核的是个人
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --已申报
                WHERE IAA002 = PKG_Constant.IAA002_NPS  --未通过
                  AND IAC001 = REC_TMP_PERSON.IAZ007;
            END IF;
         END IF;

         --通过
         IF REC_TMP_PERSON.iaa018 = PKG_Constant.IAA018_PAS THEN

            SELECT yae099
              INTO var_yae099
              FROM wsjb.AE02A1
             WHERE aac001 = REC_TMP_PERSON.iaz007
               AND aaz002 = prm_aaz002;

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_WAD --待审
             WHERE IAA015 = PKG_Constant.IAA015_ADO --审核完毕
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            --审核的是个人
            IF REC_TMP_PERSON.iaa020 = PKG_Constant.IAA020_GR THEN
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_AIR  --已申报
                WHERE IAA002 = PKG_Constant.IAA002_APS  --已通过
                  AND IAC001 = REC_TMP_PERSON.IAZ007;

               /*--人员增加的回退
               IF REC_TMP_PERSON.iaa001 = PKG_Constant.IAA001_ADD THEN
                  --调用人员回退过程
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

               --人员减少的回退
               IF REC_TMP_PERSON.iaa001 = PKG_Constant.IAA001_MIN THEN
                  --调用人员回退过程
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
                  人员增加[新参保与批量新参保]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_ADD,PKG_Constant.IAA001_PAD) THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[新参保 续保]
                     老方法 prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuCheckRollback(var_yae099,
                                  REC_TMP_PERSON.IAC001,
                                  prm_aae011,
                                  PKG_Constant.YAB003_JBFZX,
                                  '网上经办回退',
                                  prm_AppCode,
                                  prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  人员增加[人员险种新增]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_IAD THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[新参保 续保]
                     老方法 prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuAddCheckRollback(var_yae099,
                                    REC_TMP_PERSON.IAC001,
                                    prm_aae011,
                                    PKG_Constant.YAB003_JBFZX,
                                    '网上经办回退',
                                    prm_AppCode,
                                    prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  人员增加[人员续保]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_CIN THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[新参保 续保]
                     老方法 prc_AuditSocietyInsuranceRPer
                  */
                  prc_PersonInsuContinueRollback(var_yae099,
                                    REC_TMP_PERSON.IAC001,
                                    prm_aae011,
                                    PKG_Constant.YAB003_JBFZX,
                                    '网上经办回退',
                                    prm_AppCode,
                                    prm_ErrorMsg);
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  人员减少[人员暂停缴费与批量暂停缴费，退休人员死亡(与暂停雷同)]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_MIN,PKG_Constant.IAA001_PMI,PKG_Constant.IAA001_RPD) THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[停保 退休]
                     老方法 prc_AuditMonthInternetRpause
                  */

                  prc_PersonInsuPauseRollback(var_yae099,
                                      REC_TMP_PERSON.IAC001,
                                      prm_aae011,
                                      PKG_Constant.YAB003_JBFZX,
                                      '网上经办回退',
                                      prm_AppCode,
                                      prm_ErrorMsg
                                      );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;
               END IF;

               /*
                  人员减少[在职转退休]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_RTR THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[停保 退休]
                     老方法 prc_AuditMonthInternetRpause
                  */

                  prc_PersonInsuPauseRollback(var_yae099,
                                      REC_TMP_PERSON.IAC001,
                                      prm_aae011,
                                      PKG_Constant.YAB003_JBFZX,
                                      '网上经办回退',
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

      --删除审核明细
      DELETE
        FROM wsjb.IRAD22  a
       WHERE EXISTS
             (
              SELECT iaz009
                FROM wsjb.IRAD21
               WHERE iaz009 = a.iaz009
                 AND aaz002 = prm_aaz002
             );

      --删除审核事件
      DELETE
        FROM wsjb.IRAD21
       WHERE aaz002 = prm_aaz002;

      --删除日志记录
      DELETE
        FROM wsjb.AE02
       WHERE aaz002 = prm_aaz002;

      SELECT count(1)
        INTO countnum
        FROM wsjb.irad21  a,wsjb.irad22  b,wsjb.irad02  c
       WHERE a.iaz009 = b.iaz009
         AND b.iaz005 = c.iaz005
         AND c.iaa015 IN(PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)  --审核完毕或者放弃审核
         AND a.aaz002 = prm_aaz002;
      IF countnum > 0 THEN
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '还存在可回退的数据！';
         RETURN;
      END IF;

   EXCEPTION
      WHEN OTHERS THEN
      /*关闭打开的游标*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '数据库错误:'|| SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
      RETURN;
   END prc_RollBackAMIRBYYL;
/*****************************************************************************
   ** 过程名称 : prc_ResetASMR
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：重置月申报审核(单养老)
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位编号
   **           prm_iaa100       IN     irad01.iaa100%TYPE,--申报月度
   **           prm_aae011       IN     irad31.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-09   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_ResetASMRBYYL (
      prm_aab001       IN     irab01.aab001%TYPE,--单位编号
      prm_iaa100       IN     irad01.iaa100%TYPE,--申报月度
      prm_aae011       IN     irad31.aae011%TYPE,--经办人
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum     NUMBER;
      v_msg        VARCHAR2(200);
      var_aaz002   VARCHAR2(15);
      --需要重置的申报数据
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

      --需要重置的审核数据
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

      --检查是否符合重置条件
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
         prm_ErrorMsg := '当前社保助记码单位不存在月申报数据，不能重置!';
         RETURN;
      END IF;

      --检查是否存在审核记录
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

      --有审核记录，回退所有审核
      IF countnum > 0 THEN
         FOR rec_irad21 in irad21Cur LOOP
             prc_RollBackAMIRBYYL(rec_irad21.aaz002,--审核业务日志
                              prm_iaa100       ,--申报月度
                              prm_aab001       ,--申报单位
                              prm_aae011       ,--经办人
                              prm_AppCode      ,
                              prm_ErrorMsg
                              );
             IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                RETURN;
             END IF;
         END LOOP;
      END IF;

      --回退正常的人员信息
      DELETE
        FROM wsjb.IRAC01
       WHERE aab001 = prm_aab001
         AND iaa100 = prm_iaa100
         AND iaa001 = PKG_Constant.IAA001_GEN;

      --回退申报过程
      FOR rec_person in personCur LOOP
         IF rec_person.iaa020 = PKG_Constant.IAA020_GR THEN
            --回退申报信息状态
            UPDATE wsjb.IRAC01
               SET iaa002 = PKG_Constant.IAA002_WIR,
                   iaa100 = NULL
             WHERE IAC001 = rec_person.iaz007;
         END IF;
         --回退申报明细
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

      --回退申报事件
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
        发送短消息
      */
      DELETE FROM wsjb.IRAD23_TMP ;
      INSERT INTO wsjb.IRAD23_TMP (aab001) VALUES (prm_aab001);
      v_msg := '贵单位'||prm_iaa100||'月度的人员增减申报问题已经处理，请尽快修改相关信息，提交申报.';
      PKG_Insurance.prc_MessageSend(prm_aae011,
                                    'A04',
                                    v_msg,
                                    prm_AppCode,
                                    prm_ErrorMsg);
      IF prm_AppCode <> gn_def_OK THEN
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '调用消息发送过程prc_MessageSend出错:' ||prm_ErrorMsg;
         RETURN;
      END IF;

   EXCEPTION
      WHEN OTHERS THEN
      /*关闭打开的游标*/
      ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '数据库错误:'|| SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() ;
      RETURN;
   END prc_ResetASMRBYYL;


    /*****************************************************************************
   ** 过程名称 : prc_Ab02a8Unit
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：单位缴费基数
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **             prm_aab001       IN     irab01.aab001%TYPE   单位编号
   **             prm_yae099       IN     ab02a9.yae099%TYPE   业务流水号
   **             prm_AppCode      OUT    VARCHAR2
   **             prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-09-09   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/

 PROCEDURE prc_Ab02a8Unit (
      prm_aab001       IN     irab01.aab001%TYPE,--单位编号
      prm_yae099       IN     VARCHAR2,        --业务流水号
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

      --游标  获取单位参保险种
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
         prm_ErrorMsg := '单位编号为空';

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
         prm_ErrorMsg := '该单位年度为空';

         RETURN;

      END IF;

      max_ny_aae001 := max_aae001||'01';

      -- 获取上一年度
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
          (YAE099, --   业务流水号
           AAB001, --   单位编号
           AAE140, --  险种类型
           AAE041, --   开始期号
           AAE042, --   终止期号
           AAB121, --   单位缴费基数总额
           AAE001, --   年度
           AAE011, --   经办人
           AAE036, --    经办时间
           YAB003, --  社保经办机构
           YAE031, --   审核标志
           YAE032, --   审核人
           YAE033, --   审核时间
           YAE569, --  审核经办机构
           YAB139, --   参保所属分中心
           AAE013 --  备注
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

                YAE099,   --业务流水号
                AAB001,   -- 单位编号
                AAE140,   --险种类型
                AAC001,   --个人编号
                AAC050,   --变更类型
                AAE003,   --     期号
                AAB122,   --  变更前单位缴费基数
                AAB121,   --  变更后单位缴费基数
                AAE001,   --   年度
                AAE011,   --    经办人
                AAE036,   --    经办时间
                YAB003,   --     经办机构
                YAB139,   --     参保分中心
                AAE013   --     备注
           )
            select
                 xasi2.PKG_COMM.FUN_GETSEQUENCE(NULL,'YAE099'), --   业务流水号
                 AAB001, --   单位编号
                 AAE140, --  险种类型
                 NULL,
                 NULL,
                 NULL,
                 0,      -- 变更前单位缴费基数
                 AAB121, -- 变更后单位缴费基数
                 AAE001, --   年度
                 AAE011, --   经办人
                 AAE036, --    经办时间
                 YAB003, --  社保经办机构
                 YAB139, --     参保分中心
                 AAE013 --  备注
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

                YAE099,   --业务流水号
                AAB001,   -- 单位编号
                AAE140,   --险种类型
                AAC001,   --个人编号
                AAC050,   --变更类型
                AAE003,   --     期号
                AAB122,   --  变更前单位缴费基数
                AAB121,   --  变更后单位缴费基数
                AAE001,   --   年度
                AAE011,   --    经办人
                AAE036,   --    经办时间
                YAB003,   --     经办机构
                YAB139,   --     参保分中心
                AAE013   --     备注
           )
            select
                xasi2.PKG_COMM.FUN_GETSEQUENCE(NULL,'YAE099'), --   业务流水号
                 AAB001, --   单位编号
                 AAE140, --  险种类型
                 NULL,
                 NULL,
                 NULL,
                 AAB121,      -- 变更前单位缴费基数
                 sum_YAC004, -- 变更后单位缴费基数
                 AAE001, --   年度
                 AAE011, --   经办人
                 AAE036, --    经办时间
                 YAB003, --  社保经办机构
                 YAB139,   --     参保分中心
                 AAE013   --  备注
               from xasi2.ab02a8
               where AAB001 = prm_aab001
                    AND AAE140= REC_CANBAO_COMPANY.AAE140;

        update xasi2.ab02a8
           set AAB121 = sum_YAC004 --   单位缴费基数总额
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
      prm_ErrorMsg := '数据库错误:'|| SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
      RETURN;
   END prc_Ab02a8Unit;


-- 单位缴费基数回退

 PROCEDURE prc_Ab02a8UnitRollBack (
      prm_aab001       IN     VARCHAR2,--单位编号
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      countnum      NUMBER;
      max_ny_aae001 NUMBER(6);
      max_aae001    NUMBER(4);
      n_count       NUMBER;
      sum_YAC004    NUMBER(12,2);

      --游标  获取单位参保险种
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
         prm_ErrorMsg := '该回退单位编号为空';
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
         prm_ErrorMsg := '单位缴费基数不存在:' ||prm_ErrorMsg;
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
           set AAB121 = sum_YAC004, --   单位缴费基数总额
               AAE036 = sysdate
         where AAB001 = REC_CANBAO_COMPANY.AAB001
           and AAE140 = REC_CANBAO_COMPANY.AAE140;


           INSERT INTO xasi2.ab02a9(

                YAE099,   --业务流水号
                AAB001,   -- 单位编号
                AAE140,   --险种类型
                AAC001,   --个人编号
                AAC050,   --变更类型
                AAE003,   --     期号
                AAB122,   --  变更前单位缴费基数
                AAB121,   --  变更后单位缴费基数
                AAE001,   --   年度
                AAE011,   --    经办人
                AAE036,   --    经办时间
                YAB003,   --     经办机构
                YAB139,   --     参保分中心
                AAE013   --     备注
           )
            select
                xasi2.PKG_COMM.FUN_GETSEQUENCE(NULL,'YAE099'), --   业务流水号
                 AAB001, --   单位编号
                 AAE140, --  险种类型
                 NULL,
                 NULL,
                 NULL,
                 sum_YAC004,      -- 变更前单位缴费基数
                 AAB121, -- 变更后单位缴费基数
                 AAE001, --   年度
                 AAE011, --   经办人
                 sysdate, --    经办时间
                 YAB003, --  社保经办机构
                 YAB139,   --     参保分中心
                 AAE013   --  备注
               from xasi2.ab02a8
               where AAB001 = prm_aab001
                AND AAE140= REC_CANBAO_COMPANY.AAE140;

    end LOOP;


   EXCEPTION
      WHEN OTHERS THEN
       ROLLBACK;
      prm_AppCode  :=  gn_def_ERR;
      prm_ErrorMsg := '数据库错误:'|| SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() ;
      RETURN;
   END prc_Ab02a8UnitRollBack;







 --YAE099


 PROCEDURE prc_AuditMonthInternetRNew (
      prm_iaa011       IN     iraa02.iaa011%TYPE,--业务类型
      prm_iaa003       IN     iraa02.iaa003%TYPE,--业务主体
      prm_iaa018       IN     irad22.iaa018%TYPE,--审核标志
      prm_iaa028       IN     VARCHAR2          ,--是否全部
      prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
      prm_aae013       IN     iraa02.aae013%TYPE,--备注
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

      --定义游标，获取批量审核人员信息
      CURSOR cur_tmp_person IS
      SELECT a.IAC001, --申报人员信息编号,VARCHAR2
             b.AAC001, --个人编号,VARCHAR2
             a.AAB001, --单位编号,VARCHAR2
             a.AAC002, --公民身份号码,VARCHAR2
             a.AAC003, --姓名,VARCHAR2
             b.IAA001, --人员类别
             a.IAZ005, --申报明细ID
             a.IAA003  --业务主体
        FROM wsjb.IRAD22_TMP  a,wsjb.IRAC01  b --批量审核人员信息零时表
       WHERE a.iac001 = b.iac001
        ORDER by a.iaa003;

                 -- 单位参保游标
    CURSOR cur_canbao_company  IS
      SELECT
        AAB001,
        AAE140
       FROM xasi2.ab02
       WHERE  aab001 = var_aab001 and aab051='1' and aae140<>'07';


   BEGIN

      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      := 0;
      prm_aaz002   :='';

      /*检查临时表是否存在数据*/
      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.IRAD22_TMP ;
      IF n_count = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'审核临时表无可用数据!';
         RETURN;
      END IF;


      /*必要的数据校验*/
      IF prm_iaa011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'业务类型不能为空!';
         RETURN;
      END IF;

      IF prm_iaa003 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'业务主体不能为空!';
         RETURN;
      END IF;

      IF prm_iaa018 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'审核标志不能为空!';
         RETURN;
      END IF;

      IF prm_iaa028 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'标志[是否全部]不能为空!';
         RETURN;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
      IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号AAZ002!';
         RETURN;
      END IF;

      v_iaz009 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ009');
      IF v_iaz009 IS NULL OR v_iaz009 = '' THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号IAZ009!';
         RETURN;
      END IF;

      prm_aaz002 :=v_aaz002;



      --审核事件
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

         --申报主体是个人时校验：必须单位信息审核通过才能办理
         IF REC_TMP_PERSON.iaa003 = PKG_Constant.IAA003_PER THEN
            SELECT COUNT(1)
              INTO n_count
              FROM wsjb.IRAB01
             WHERE AAB001 = REC_TMP_PERSON.AAB001
               AND IAA002 = PKG_Constant.IAA002_APS;
            IF n_count = 0 THEN
               ROLLBACK;
               prm_AppCode  :=  gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'单位信息审核通过才能办理人员月申报审核!';
               RETURN;
            END IF;
         END IF;

          /*
            针对人员的信息审核
            可以办理的是打回 通过 不通过 批量通过 全部通过 全不通过
         */

         --审核明细处理
         v_iaz010 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ010');
         IF v_iaz010 IS NULL OR v_iaz010 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := PRE_ERRCODE ||'没有获取到序列号IAZ010!';
            RETURN;
         END IF;

         --查询上次审核情况
         BEGIN
            SELECT IAA015
              INTO v_iaa015
              FROM wsjb.IRAD02
             WHERE IAZ005 = REC_TMP_PERSON.IAZ005;

            IF v_iaa015 in (PKG_Constant.IAA015_ADO,PKG_Constant.IAA015_DAD)THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
              prm_ErrorMsg := PRE_ERRCODE ||'审核已经终结!';
              RETURN;
           END IF;

            --提取上次审核信息
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
                                          PKG_Constant.IAA018_DAD, --打回[放弃审核]
                                          PKG_Constant.IAA018_NPS  --不通过 Not Pass
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
                     prm_ErrorMsg := PRE_ERRCODE ||'申报信息处于审核中，但未获取到上次审核信息,请确认上次审核是否终结!';
                     RETURN;
               END;

               v_iaa014 := v_iaa017;
               v_iaa017 := v_iaa017 + 1;
               IF v_iaa017 > v_iaa004 THEN
                  v_iaa017 := v_iaa004;
               END IF;

               --审核级次等于当前级次
               IF v_iaa004 = v_iaa014 AND v_iaa004 = v_iaa017 THEN
                  ROLLBACK;
                  prm_AppCode  := gn_def_ERR;
                  prm_ErrorMsg := PRE_ERRCODE ||'审核已经终结!';
                  RETURN;
               END IF;
            END IF;

            --提取申报明细信息
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
                     prm_ErrorMsg := PRE_ERRCODE ||'没有提取到申报明细信息!';
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
               prm_ErrorMsg := '审核信息提取错误:'|| PRE_ERRCODE || SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() ;
               RETURN;
         END;

         --审核明细写入
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
                     IAD005,    --审核意见
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
                     prm_aae013,  --审核意见
                     null
         );

         --打回
         IF prm_iaa018 = PKG_Constant.IAA018_DAD THEN

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015 = PKG_Constant.IAA015_DAD,--打回[修改续报]
                   AAE013 = prm_aae013
             WHERE IAA015 = PKG_Constant.IAA015_WAD --待审
               AND IAZ005 = REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_ALR  --已打回
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --审核未通过
         IF prm_iaa018 = PKG_Constant.IAA018_NPS THEN

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015  = PKG_Constant.IAA015_ADO, --审核完毕
                   AAE013  = prm_aae013
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --待审/审核中
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

            IF REC_TMP_PERSON.iaa003 = '2' THEN
               --更新申报人员状态
               UPDATE wsjb.IRAC01
                  SET IAA002 = PKG_Constant.IAA002_NPS  --未通过
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;

         END IF;

         --审核通过
         IF prm_iaa018 = PKG_Constant.IAA018_PAS AND v_iaa014 = v_iaa004 THEN

            --更新申报明细
            UPDATE wsjb.IRAD02
               SET IAA015  =  PKG_Constant.IAA015_ADO --审核完毕
             WHERE IAA015 in (PKG_Constant.IAA015_WAD,PKG_Constant.IAA015_ADI) --待审/审核中
               AND IAZ005  =  REC_TMP_PERSON.IAZ005;

           v_yae099    := xasi2.PKG_comm.fun_GetSequence(NULL,'yae099');
            IF v_yae099 IS NULL OR v_yae099 = '' THEN
               ROLLBACK;
               prm_AppCode  := gn_def_ERR;
               prm_ErrorMsg := PRE_ERRCODE ||'没有获取到系统库的序列号:YAE099';
               RETURN;
             END IF;


            IF REC_TMP_PERSON.iaa003 = '2' THEN


               /*
                  人员增加[新参保与批量新参保]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_ADD,PKG_Constant.IAA001_PAD) THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[新参保 续保]
                     老方法 prc_AuditSocietyInsuranceRPer
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
                  人员增加[人员险种新增]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_IAD THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[新参保 续保]
                     老方法 prc_AuditSocietyInsuranceRPer
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
                  人员增加[人员续保]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_CIN THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[新参保 续保]
                     老方法 prc_AuditSocietyInsuranceRPer
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
                  人员减少[人员暂停缴费与批量暂停缴费，退休人员死亡(与暂停雷同)]
               */
               IF REC_TMP_PERSON.IAA001 IN(PKG_Constant.IAA001_MIN,PKG_Constant.IAA001_PMI,PKG_Constant.IAA001_RPD) THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[停保 退休]
                     老方法 prc_AuditMonthInternetRpause
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
                  人员减少[在职转退休]
               */
               IF REC_TMP_PERSON.IAA001 = PKG_Constant.IAA001_RTR THEN
                  /*
                     社保系统数据录入 人员信息 人员保险信息[停保 退休]
                     老方法 prc_AuditMonthInternetRpause
                  */
                  --退休申请审核 修改个人状态以及更新参保信息
                  v_yae099 := NULL;

                  BEGIN
                     SELECT MAX(yae099)
                       INTO v_yae099
                       FROM XASI2.ac02_apply
                      WHERE AAC001 = REC_TMP_PERSON.AAC001
                        AND AAB001 = REC_TMP_PERSON.AAB001
                        AND YAE031 = '0'                    --未审核
                        AND AAE120 = '0'
                        AND FLAG   = '3';                   --退休申请
                     EXCEPTION
                      WHEN OTHERS THEN
                          prm_AppCode  :=  gn_def_ERR;
                          prm_ErrorMsg :=  PRE_ERRCODE || '退休申请数据没有获取到!';
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


      -- 调用prc_Ab02a8Unit 单位缴费基数
         prc_Ab02a8Unit(     REC_TMP_PERSON.AAB001,
                                v_yae099,
                                prm_AppCode,
                                prm_ErrorMsg
                                        );
                  IF prm_AppCode <> gn_def_OK THEN
                     ROLLBACK;
                     RETURN;
                  END IF;


    -- 生成ab02a8数据
    --获取最大年度

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
          (YAE099, --   业务流水号
           AAB001, --   单位编号
           AAE140, --  险种类型
           AAE041, --   开始期号
           AAE042, --   终止期号
           AAB121, --   单位缴费基数总额
           AAE001, --   年度
           AAE011, --   经办人
           AAE036, --    经办时间
           YAB003, --  社保经办机构
           YAE031, --   审核标志
           YAE032, --   审核人
           YAE033, --   审核时间
           YAE569, --  审核经办机构
           YAB139, --   参保所属分中心
           AAE013 --  备注
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
           set AAB121 = sum_YAC004 --   单位缴费基数总额
         where AAB001 = REC_TMP_PERSON.AAB001
           and AAE140 = REC_CANBAO_COMPANY.AAE140;

      end if;
    end LOOP;
    */



               --2013-03-14 王雷  应该是先进行操作最后更新状态
               --更新申报人员状态
               UPDATE wsjb.irac01
                  SET IAA002 = PKG_Constant.IAA002_APS  --已通过
                WHERE IAA002 = PKG_Constant.IAA002_AIR  --已申报
                  AND IAC001 = REC_TMP_PERSON.IAC001;
            END IF;
            --回退相关表
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





      --日志记录
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
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| PRE_ERRCODE || SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END prc_AuditMonthInternetRNew;




  /*****************************************************************************
 ** 过程名称 : prc_PersonInfoRepair
 ** 过程编号 ：
 ** 业务环节 ：
 ** 功能描述 ：月报审核通过补充个人信息
 ******************************************************************************
 ** 参数描述 ：参数标识        输入/输出         类型                 名称
 ******************************************************************************
 **           prm_yae099       IN     VARCHAR2          ,--业务流水号
 **           prm_iac001        IN    irac01.iac001%TYPE,--申报编号
 **           prm_aac001       IN    irac01.aac001%TYPE,  --个人编号
 **           prm_aac002       IN    irac01.aac002%TYPE, --证件号
 **           prm_aab001       IN    irab01.aab001%TYPE,  --单位助记码
 **           prm_aae011       IN    irac01.aae011%TYPE ,  --经办人
 **           prm_AppCode      OUT    VARCHAR2          ,
 **           prm_ErrorMsg     OUT    VARCHAR2
 ******************************************************************************
 ** 作    者：yh         作成日期 ：2018-12-21   版本编号 ：Ver 1.0.0
 ** 修    改：
 *****************************************************************************/
  PROCEDURE prc_PersonInfoRepair(prm_yae099 IN VARCHAR2, --业务流水号
                               prm_iac001   IN irac01.iac001%TYPE,--申报编号
                               prm_aac001  IN irac01.aac001%TYPE, --个人编号
                               prm_aac002  IN irac01.aac002%TYPE, --证件号码
                               prm_aab001  IN irab01.aab001%TYPE, --单位助记码
                               prm_aae011  IN irac01.aae011%TYPE, --经办人
                               prm_AppCode OUT VARCHAR2, --错误代码
                               prm_ErrMsg  OUT VARCHAR2) --错误内容
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

     -- wangz 处理工资类别    申报信息提取
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
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac007','0','参加工作日期',prm_aae011);
       end if ;
       if  var_chk_aac005 ='0' and rec_irac01.aac005 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac005','0','民族',prm_aae011);
       end if ;
      if  var_chk_aac014 ='0' and rec_irac01.aac014 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac014','0','专业技术职务',prm_aae011);
       end if ;
       if  var_chk_aac015 ='0' and rec_irac01.aac015 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac015','0','工人技术等级',prm_aae011);
       end if ;
       if  var_chk_aac020='0' and rec_irac01.aac020 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac020','0','行政职务',prm_aae011);
       end if ;
       if  var_chk_yac200 ='0' and rec_irac01.yac200 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'yac200','0','公务员补助职级',prm_aae011);
       end if ;
       if  var_chk_aac010 ='0' and rec_irac01.aac010 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac010','0','户口所在地',prm_aae011);
       end if ;
       if  var_chk_aac011 ='0' and rec_irac01.aac011 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac011','0','文化程度',prm_aae011);
       end if ;
       if  var_chk_aac021 ='0' and rec_irac01.aac021 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac021','0','毕业日期',prm_aae011);
       end if ;
       if  var_chk_aac022 ='0' and rec_irac01.aac022 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aac022','0','毕业院校',prm_aae011);
       end if ;
       if  var_chk_aae005 ='0' and rec_irac01.aae005 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aae005','0','联系电话',prm_aae011);
       end if ;
       if  var_chk_aae006 ='0' and rec_irac01.aae006 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aae006','0','地址',prm_aae011);
       end if ;
       if  var_chk_yae222 ='0' and rec_irac01.yae222 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'yae222','0','EMAIL',prm_aae011);
       end if ;
       if  var_chk_aae007 ='0' and rec_irac01.aae007 is not null then
           insert into wsjb.chk_ac01 (aac001,aab001,col,nullsign,comm,aae011) values (prm_aac001,prm_aab001,'aae007','0','邮编',prm_aae011);
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
                                '人员续保个人信息补齐',
                                '人员续保个人信息补齐',
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

  --  只维护正常人员工资类别
  select count(1) INTO zc_count from xasi2.ac01 a,xasi2.kc01 b where a.aac001 = b.aac001
                                             and a.aac008 = PKG_Constant.AAC008_ZZ
                                             and b.akc021 = PKG_Constant.AKC021_ZZ
                                             and a.aac001 = prm_aac001;

  --处理工资类别
  if zc_count > 0 then
    --for Sb_shenBao_irac01 in  shenBao_irac01 loop
     --var_sb_aac001 := Sb_shenBao_irac01.aac001;
     select count(1) into yac503_count from xasi2.ac02 where aac001 = prm_aac001
                                    and aac031  = PKG_Constant.AAC031_ZTJF
                                    and yac503 <> PKG_Constant.YAC503_SB;
             if  yac503_count > 0 then
               --更改ac02 工资类别
                 for gg_yac503_ac02 in  yac503_ac02 loop
                   var_before_yac503 := gg_yac503_ac02.yac503;
                    update xasi2.ac02 set yac503 = PKG_Constant.YAC503_SB  where aac001 = prm_aac001
                                                               and aac031  = PKG_Constant.AAC031_ZTJF
                                                               and aae140  = gg_yac503_ac02.aae140;
                -- 写更改信息ae15
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
                                '人员续保个人信息维护',
                                '人员续保个人信息维护',
                                'ac02',
                                'yac503',
                                '工资类别',
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
        /*关闭打开的游标*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '数据库错误:'||PRE_ERRCODE ||SQLERRM||dbms_utility.format_error_backtrace ||'; iac001:'||prm_iac001||'; aac001:'||prm_aac001||'; aac002:'||prm_aac002;
        RETURN;

  END prc_PersonInfoRepair;



    /*****************************************************************************
   ** 过程名称 : prc_PersonInsuPause
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：月申报审核[人员停保审核]
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_yae099       IN     VARCHAR2          ,--业务流水号
   **           prm_aab001       IN     irab01.aab001%TYPE,--单位助记码
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-10-19   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_PersonInsuPauseTS(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                             prm_aab001       IN    xasi2.ab01.aab001%TYPE   ,    --单位编码
                             prm_iac001       IN    irac01.iac001%TYPE ,    --申报人编号
                             prm_aae011       IN    irac01.aae011%TYPE ,    --经办人
                             prm_yab003       IN    irac01.yab003%TYPE ,    --社保经办机构
                             prm_aae036       IN    irac01.aae036%TYPE ,    --经办时间
                             prm_AppCode      OUT   VARCHAR2  ,    --错误代码
                             prm_ErrMsg       OUT   VARCHAR2  )    --错误内容
   IS
      var_procNo      VARCHAR2(2);         --过程序号
      num_count       NUMBER;
      var_yac001      VARCHAR2(20);
      var_yae235      VARCHAR2(6);
      var_yae238      VARCHAR2(2000);
      var_aac001      xasi2.ac01.aac001%TYPE  ;  --个人编号
      var_aae140_01   VARCHAR2(2);         --是否参加了企业养老
      var_aae140_06   VARCHAR2(2);         --是否参加了机关养老
      var_aae140_02   VARCHAR2(2);         --是否参加了失业
      var_aae140_03   VARCHAR2(2);         --是否参加了基本医疗
      var_aae140_04   VARCHAR2(2);         --是否参加了工伤
      var_aae140_05   VARCHAR2(2);         --是否参加了生育
      var_aae140_07   VARCHAR2(2);         --是否参加了大额
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

      var_aae140_01 := rec_irac01.aae110;        --是否参加了企业养老
      var_aae140_06 := rec_irac01.aae120;        --是否参加了机关养老
      var_aae140_02 := rec_irac01.aae210;        --是否参加了失业
      var_aae140_03 := rec_irac01.aae310;        --是否参加了基本医疗
      var_aae140_04 := rec_irac01.aae410;        --是否参加了工伤
      var_aae140_05 := rec_irac01.aae510;        --是否参加了生育
      var_aae140_07 := rec_irac01.aae311;        --是否参加了大额
      var_aae140_08 := rec_irac01.aae810;

      IF var_aae140_06 = '3' OR var_aae140_02 = '3'
      OR var_aae140_03 = '3' OR var_aae140_04 = '3'
      OR var_aae140_05 = '3' OR var_aae140_07 = '3'
      OR var_aae140_08 = '3' THEN
         --写入临时表数据
         PKG_COMMON.PRC_P_insertAe16Tmp(prm_yae099,
                                       prm_iac001,
                                       '03', --批量报盘暂停
                                       prm_aab001,
                                       prm_aae011,
                                       prm_AppCode,
                                       prm_ErrMsg);
         IF prm_AppCode <> PKG_Constant.gn_def_OK THEN
            RETURN;
         END IF ;
         --临时表数据校验
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
            prm_ErrMsg  := '人员参保信息校验失败:'||var_yae238||v_aad055;
            RETURN;
         END IF;

         --个人批量暂停导盘数据导入
         xasi2.pkg_p_Person_Batch.prc_p_Person_pause_treat(prm_yae099,
                                                        prm_aab001,
                                                        '1'       ,    --'1' 只处理检查成功的--'2' 如果存在检查失败数据
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
        /*关闭打开的游标*/
        ROLLBACK;
        prm_AppCode  :=  PKG_Constant.gn_def_ERR;
        prm_ErrMsg   := '数据库错误:'||PRE_ERRCODE || SQLERRM||dbms_utility.format_error_backtrace ;
        RETURN;
   END prc_PersonInsuPauseTS;




PROCEDURE prc_insertAC29(

                               prm_aab001  IN irab01.aab001%TYPE, --单位助记码
                               prm_iaa100  IN irac01.iaa100%TYPE,
                               prm_aae011  IN irac01.aae011%TYPE, --经办人
                               prm_AppCode OUT VARCHAR2, --错误代码
                               prm_ErrorMsg  OUT VARCHAR2) --错误内容
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
   VAR_YAE566 XASI2.AC29.YAE566%TYPE; --制卡商密码
   NUM_YAE540 NUMBER(6);
   VAR_YAC150 XASI2.AC29.YAC150%TYPE; --发卡人员类型

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
            (AAC001, --个人编号,VARCHAR2
             YAC150, --发卡时人员类型,VARCHAR2
             YAC139, --社保卡状态,VARCHAR2
             YAC137, --制卡状态,VARCHAR2
             YAC005, --卡号,VARCHAR2
             YAE096, --密码,VARCHAR2
             YAC136, --制卡清单批次号,VARCHAR2
             AAC003, --卡面姓名,VARCHAR2
             YAE567, --卡面编号,VARCHAR2
             YAC527, --卡号密文,VARCHAR2
             YAE566, --制卡商密码,VARCHAR2
             AKC140, --发卡日期,DATE
             YAE540, --导出制卡次数,NUMBER
             AAE011, --经办人,NUMBER
             AAE036, --经办时间,DATE
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
            (YAE099, --业务流水号,VARCHAR2
             AAC001, --个人编号,VARCHAR2
             AAB001, --单位编号,VARCHAR2
             YAC005, --卡号,VARCHAR2
             AAE011, --经办人,NUMBER
             AAE036, --经办时间,DATE
             YAB003 --经办分中心,VARCHAR2
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
         (YAE099, -- 业务流水号   -->
          AAB001, -- 单位编号     -->
          YAB500, -- 发卡数量     -->
          AAE011, -- 经办人       -->
          AAE036, -- 经办时间     -->
          YAB003, -- 经办机构     -->
          YAE017)
         SELECT YAE099,
                AAB001, -- 单位编号     -->
                COUNT(1) AS YAB500, -- 发卡数量     -->
                NUM_AAE011, -- 经办人       -->
                DAT_AAE036, -- 经办时间     -->
                '610127', -- 经办机构     -->
                '0'
           FROM XASI2.AC29A2
          WHERE YAE099 = VAR_YAE099
          GROUP BY YAE099, AAB001;

     EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| PRE_ERRCODE || SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
END prc_insertAC29;




--没有增减的单位 补写 irac01 irad01 irad02
 PROCEDURE prc_insertIRAD01(
             prm_aab001  IN irab01.aab001%TYPE, --单位助记码
             prm_aae011  IN irac01.aae011%TYPE, --经办人
             prm_AppCode OUT VARCHAR2, --错误代码
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

   --单位最大做账期号
   SELECT COUNT(1)
     INTO COUNT_AB02
     FROM xasi2.AB02
    WHERE aab001 = prm_aab001
      AND aab051 = '1';
   IF COUNT_AB02 > 0 THEN      --一般单位做账期号
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
        prm_ErrorMsg := prm_ErrorMsg || '获取最大做账期号出错！';
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

   --月报最大申报月度
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
                -------- 写数据 start  --------
                IF COUNT_AB02 > 0 THEN  -- 一般单位
                INSERT INTO wsjb.IRAC01
                       (iac001, -- 申报人员信息编号
                        iaa001, -- 申报人员类别
                        iaa002, -- 申报状态
                        aac001, -- 个人编号
                        aab001, -- 单位编号
                        aac002, -- 身份证号码(证件号码)
                        aac003, -- 姓名
                        aac004, -- 性别
                        aac005, -- 民族
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
                        yab139, -- 参保所属分中心
                        yab013, -- 原单位编号
                        aae011, -- 经办人
                        aae036, -- 经办时间
                        aac040, -- 申报工资
                        yac005, --其他基数
                        yac004, --养老基数
                        aae110, -- 企业养老
                        aae120, -- 机关养老
                        aae210, -- 失业
                        aae310, -- 医疗
                        aae410, -- 工伤
                        aae510, -- 生育
                        aae311, -- 大病
                        iaa100)
                SELECT TO_CHAR(seq_iac001.nextval ) iac001, -- 申报人员信息编号
                       PKG_Constant.IAA001_GEN iaa001, -- 正常参保人员
                       PKG_Constant.IAA002_WIR iaa002, -- 待申报,
                       p.aac001,p.aab001,
                       p.aac002,p.aac003,p.aac004,p.aac005,p.aac006,p.aac007,p.aac008,p.aac009,p.aac011,
                       p.aac013,p.aac014,p.aac015,p.aac020,p.yac168,p.yab139,p.aab001 as yab013,p.aae011,p.aae036,
                       p.aac040,decode(p.aae310,'0',p.yac005_,'2',p.yac005) yac005,to_number(NVL(TRIM(p.yac004_1),p.yac004_2)) AS yac004,p.aae110,p.aae120,p.aae210,p.aae310,p.aae410,p.aae510,p.aae311,REC_IAA100S.IAA100L
                  FROM
               (SELECT a.aac001, -- 个人编号
                       b.aab001, -- 单位编号
                       a.aac002, -- 身份证号码(证件号码)
                       a.aac003, -- 姓名
                       a.aac004, -- 性别
                       a.aac005, -- 民族
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
                       a.aae011, -- 经办人
                       a.aae036, -- 经办时间
                       sum(case when b.aae140 = '03' then b.aac040 else 0 end) as aac040, -- 申报工资
                       sum(case when b.aae140 = '03' then b.yac004 else 0 end) as yac005, -- 申报工资
                       sum(case when b.aae140 = '04' then b.yac004 else 0 end) as yac005_, -- 工伤的缴费基数
                       (select yac004 from wsjb.irac01a3  where aac001 = a.aac001 and aab001 = prm_aab001 and aae110 = '2') as yac004_1, --企业养老基数
                       (select yac004 from xasi2.ac02 where aac001 = a.aac001 and aab001 = prm_aab001 and aae140 = '06' and aac031 = '1') as yac004_2,--机关养老基数
                       (select aae110 from wsjb.irac01a3  where aac001 = a.aac001 and aab001 = prm_aab001) aae110,             -- 企业养老
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
                ELSE  -- 单养老单位
                INSERT INTO wsjb.IRAC01
                                   (iac001, -- 申报人员信息编号
                                    iaa001, -- 申报人员类别
                                    iaa002, -- 申报状态
                                    aac001, -- 个人编号
                                    aab001, -- 单位编号
                                    aac002, -- 身份证号码(证件号码)
                                    aac003, -- 姓名
                                    aac004, -- 性别
                                    aac005, -- 民族
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
                                    yab139, -- 参保所属分中心
                                    yab013, -- 原单位编号
                                    aae011, -- 经办人
                                    aae036, -- 经办时间
                                    aac040, -- 申报工资
                                    yac005, --其他基数
                                    yac004, --养老基数
                                    aae110, -- 企业养老
                                    aae120, -- 机关养老
                                    aae210, -- 失业
                                    aae310, -- 医疗
                                    aae410, -- 工伤
                                    aae510, -- 生育
                                    aae311, -- 大病
                                    iaa100)
                            SELECT TO_CHAR(seq_iac001.nextval) iac001, -- 申报人员信息编号
                                   PKG_Constant.IAA001_GEN iaa001, -- 正常参保人员
                                   PKG_Constant.IAA002_WIR iaa002, -- 待申报,
                                   p.aac001,p.aab001,
                                   p.aac002,p.aac003,p.aac004,p.aac005,p.aac006,p.aac007,p.aac008,p.aac009,p.aac011,
                                   p.aac013,p.aac014,p.aac015,p.aac020,p.yac168,p.yab139,p.aab001 as yab013,p.aae011,p.aae036,
                                   p.aac040,decode(p.aae310,'0',p.yac005_,'2',p.yac005) yac005,to_number(NVL(TRIM(p.yac004_1),p.yac004_2)) AS yac004,p.aae110,p.aae120,p.aae210,p.aae310,p.aae410,p.aae510,p.aae311,REC_IAA100S.IAA100L
                              FROM
                           (SELECT a.aac001, -- 个人编号
                                   b.aab001, -- 单位编号
                                   a.aac002, -- 身份证号码(证件号码)
                                   a.aac003, -- 姓名
                                   a.aac004, -- 性别
                                   a.aac005, -- 民族
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
                                   a.aae011, -- 经办人
                                   a.aae036, -- 经办时间
                                   b.aac040 AS aac040, -- 申报工资
                                   0 as yac005, -- 申报工资
                                   0 as yac005_, -- 工伤的缴费基数
                                   b.yac004 as yac004_1, --企业养老基数
                                   0 as yac004_2,--机关养老基数
                                   b.aae110 AS aae110,             -- 企业养老
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
                     -----写irad01  irad02
                  --是否存在相同的审核级次
                  SELECT COUNT(1)
                    INTO N_COUNT
                    FROM wsjb.IRAA02
                   WHERE iaa011 = PKG_Constant.IAA011_MIR
                     AND iaa005 = PKG_Constant.IAA005_YES;
                  IF N_COUNT > 1 THEN
                     ROLLBACK;
                     prm_ErrorMsg := '月申报系统审核级次信息有误!请联系维护人员';
                     RETURN;
                  END IF;

                  VAR_AAZ002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
                  IF  VAR_AAZ002 IS NULL OR VAR_AAZ002 = ''  THEN
                     ROLLBACK;
                     prm_ErrorMsg := '没有获取到序列号AAZ002';
                     RETURN;
                  END IF;

                  --日志记录
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
                              '补录'
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
                     prm_ErrorMsg := '没有获取到审核级次信息';
                     RETURN;
                  END;

                  IF VAR_IAZ004 IS NULL THEN
                     /*获取序列号*/
                     VAR_IAZ004 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ004');
                     IF VAR_IAZ004 IS NULL OR VAR_IAZ004 = '' THEN
                        ROLLBACK;
                        prm_ErrorMsg := '没有获取到序列号IAZ004';
                        RETURN;
                     END IF;

                    --申报事件
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
                                 '补录',
                                 TAR_IAA100
                                );
                  END IF;

                  --写入单位下人员信息申报明细

                   VAR_IAC002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');
                     IF VAR_IAC002 IS NULL OR VAR_IAC002 = '' THEN
                        ROLLBACK;
                        prm_AppCode  :=  gn_def_ERR;
                        prm_ErrorMsg := '没有获取到序列号IAC002';
                     END IF;



                  FOR REC_IRAC01 in CUR_IRAC01 LOOP
                     VAR_AAC003 := REC_IRAC01.aac003;
                     VAR_IAC001 := REC_IRAC01.iac001;
                     VAR_AAC001 := REC_IRAC01.aac001;
                     IF VAR_AAC001 IS NULL OR VAR_AAC001 = '' THEN
                        ROLLBACK;
                        prm_AppCode  :=  gn_def_ERR;
                        prm_ErrorMsg := '没有获取到人员编号';
                     END IF;

                     VAR_IAZ005 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ005');
                     IF VAR_IAZ005 IS NULL OR VAR_IAZ005 = '' THEN
                        ROLLBACK;
                        prm_AppCode  :=  gn_def_ERR;
                        prm_ErrorMsg := '没有获取到序列号IAZ005';
                     END IF;

                     --获取上次申报明细编号
                     SELECT NVL(MAX(IAZ005),VAR_IAZ005)
                       INTO VAR_IAZ006
                       FROM wsjb.IRAD02
                      WHERE IAZ007 = VAR_IAC001;

                     --插入人员申报明细
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
                          '补录',
                          PKG_Constant.IAA020_GR
                         );

                     --更改人员申报状态
                     UPDATE wsjb.IRAC01
                        SET iaa002 = PKG_Constant.IAA002_AIR
                      WHERE iac001 = VAR_IAC001;
                  END LOOP;
                -------- 写数据 end   --------

                -- 审核 start --



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

        IF n_count > 0 THEN  --n_count 申报人数
           DELETE FROM wsjb.IRAD22_TMP ;
           INSERT INTO wsjb.IRAD22_TMP
                 (IAC001,   --申报人员信息编号,VARCHAR2
                                  AAC001,   --个人编号,VARCHAR2
                                  AAB001,   --单位编号,VARCHAR2
                                  AAC002,   --公民身份号码,VARCHAR2
                                  AAC003,   --姓名,VARCHAR2
                                  IAA001,   --人员类别
                                  IAZ005,   --申报明细ID
                                  IAA003)    --业务主体
                          SELECT a.IAC001, --申报人员信息编号,VARCHAR2
                                 a.AAC001, --个人编号,VARCHAR2
                                 a.AAB001, --单位编号,VARCHAR2
                                 a.AAC002, --公民身份号码,VARCHAR2
                                 a.AAC003, --姓名,VARCHAR2
                                 a.IAA001, --人员类别
                                 b.IAZ005, --申报明细ID
                                 '2' IAA003  --业务主体
                            FROM wsjb.IRAC01  a,wsjb.IRAD02  b,wsjb.IRAD01  c
                           WHERE a.iac001 = b.iaz007
                             and b.iaz004 = c.iaz004
                             and c.aab001 = prm_aab001
                             and a.iaa001 IN ('1','2','3','5','6','7','8')
                             and c.iaa011 = PKG_Constant.IAA011_MIR  --A04
                             and a.iaa002 = PKG_Constant.IAA002_AIR  --1 已申报
                             and c.iaa100 = TAR_IAA100;

           IF COUNT_AB02 > 0 THEN  --有AB02的单位
             --月申报审核通过
             PKG_Insurance.prc_AuditMonthInternetR(PKG_Constant.IAA011_MIR,  --A04
                                                   PKG_Constant.IAA003_PER,  --2 个人
                                                   PKG_Constant.IAA018_PAS,  --1 通过
                                                   '1',--审核通过
                                                   prm_aae011,
                                                   '1' , --全部
                                                   prm_AppCode,
                                                   prm_ErrorMsg);
             IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                prm_AppCode  :=  gn_def_ERR;
                prm_ErrorMsg := '调用月申报审核过程prc_AuditMonthInternetR出错:' ||prm_ErrorMsg||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                RETURN;
             END IF;
           ELSE  --没有AB02 就是单养老单位
            --月申报审核通过 (单养老)
             PKG_Insurance.prc_YLAuditMonth(PKG_Constant.IAA011_MIR,  --A04
                                            PKG_Constant.IAA003_PER,  --2 个人
                                            PKG_Constant.IAA018_PAS,  --1 通过
                                             '1',--审核通过
                                             prm_aae011,
                                             '1' , --全部
                                             prm_AppCode,
                                             prm_ErrorMsg
                                             );
             IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                prm_AppCode  :=  gn_def_ERR;
                prm_ErrorMsg := '调用月申报审核过程prc_YLAuditMonth出错:' ||prm_ErrorMsg||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                RETURN;
             END IF;
           END IF;
        END IF;

          /*  PKG_Insurance.prc_insertAC29(
                              prm_aab001, --单位助记码
                               TAR_IAA100  ,
                               prm_aae011, --经办人
                               prm_AppCode, --错误代码
                               prm_ErrorMsg); --错误内容
                IF prm_AppCode <> gn_def_OK THEN
                ROLLBACK;
                prm_AppCode  :=  gn_def_ERR;
                prm_ErrorMsg := '调用制卡过程prc_insertAC29出错:' ||prm_ErrorMsg||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
                RETURN;
             END IF;*/

                  -- 审核 start --
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
       /*关闭打开的游标*/
       ROLLBACK;
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '数据库错误:'|| PRE_ERRCODE || SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
       RETURN;
 END prc_insertIRAD01;


 /* 在职人员补收 */
 PROCEDURE prc_SupplementCharge(
             prm_aae123  IN xasi2.tmp_sc01.aae123%TYPE,
             prm_aac040  IN xasi2.tmp_sc01.aac040%TYPE, --申报工资
             prm_yac004  IN xasi2.tmp_sc01.yac004%TYPE, --申报基数
             prm_aab001  IN xasi2.ab01.aab001%TYPE, --单位助记码
             prm_aac001  IN xasi2.ac01.aac001%TYPE, --单位助记码
             prm_aae011  IN irac01.aae011%TYPE, --经办人
             prm_AppCode OUT VARCHAR2, --错误代码
             prm_ErrorMsg  OUT VARCHAR2)

 IS
  --N_COUNT           NUMBER(6);
  VAR_MIN_AAB050    NUMBER(6); --参保时间(作为开户时间)
  VAR_MAX_AAE002    xasi2.ac08a1.aae002%TYPE; --个人4险核费的最大费款所属期
  VAR_SPGZ          xasi2.ac02.aac040%TYPE; --社平工资
  VAR_YAC004_EARLY  xasi2.ac02.yac004%TYPE; --往年基数
  VAR_AAE140        xasi2.ac02.aae140%TYPE; --险种
  VAR_AAE001_NOW    xasi2.ab05.aae001%TYPE; --系统时间当前年度
  
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

  --系统时间当前年度
  SELECT EXTRACT(YEAR FROM SYSDATE) INTO VAR_AAE001_NOW FROM DUAL;

  --单位险种参保日期 (以最早的日期为准)
  SELECT MIN(to_number(to_char(aab050, 'yyyymm')))
    INTO VAR_MIN_AAB050
    FROM xasi2.ab02
   WHERE aab001 = prm_aab001;

  FOR REC1 IN CUR_AAE140 LOOP
    
    VAR_AAE140 := REC1.aae140;
    
    --个人4险核费的最大费款所属期
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
 
    -- 插入可补收的月度
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
                                   
    -- 更新往年基数为当年社平
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
  /*关闭打开的游标*/
   ROLLBACK;
   prm_AppCode  :=  gn_def_ERR;
   prm_ErrorMsg := '数据库错误:'|| PRE_ERRCODE || SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
   RETURN;

 END prc_SupplementCharge;

end PKG_Insurance;
/
