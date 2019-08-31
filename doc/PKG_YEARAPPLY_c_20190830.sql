CREATE OR REPLACE PACKAGE PKG_YEARAPPLY AS
   /*---------------------------------------------------------------------------
   ||  程序包名 ：PKG_YearApply
   ||  业务环节 ：YearApply
   ||  对象列表 ：私有过程函数
   ||             --------------------------------------------------------------
   ||             公用过程函数
   ||             --------------------------------------------------------------
   ||
   ||  其它说明 ：
   ||  完成日期 ：
   ||  版本编号 ：Ver 1.0
   ||  审 查 人 ：×××                      审查日期 ：YYYY-MM-DD
   ||-------------------------------------------------------------------------*/

   /*-------------------------------------------------------------------------*/
   /* 公用全局常量声明                                                        */
   /*-------------------------------------------------------------------------*/
   gn_def_OK  CONSTANT VARCHAR2(12) := 'NOERROR'; -- 成功
   gn_def_ERR CONSTANT VARCHAR2(12) := '9999'; -- 系统错误



--年审补差校验
PROCEDURE prc_YearSalaryAdjustPaded  (
                                          prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                                          prm_aac001       IN     irac01.aac001%TYPE,--个人编号  非必填
                                          prm_aac040       IN     xasi2.ac02.aac040%TYPE, --工资 非必填
                                          prm_aae001       IN     NUMBER            ,--年审年度
                                          prm_aae011       IN     irad31.aae011%TYPE,--经办人
                                          prm_yab139       IN     VARCHAR2          ,--参保所属分中心
                                          prm_yab019       IN     xasi2.ac01k8.yab019%TYPE ,--业务类型标志 1-一般企业，2-机关养老险种
                                          prm_AppCode      OUT    VARCHAR2          ,
                                          prm_ErrorMsg     OUT    VARCHAR2          );

--养老缴费补差校验
PROCEDURE prc_p_checkYSJ(prm_aac001     IN     xasi2.ac02.aac001%TYPE,      --个人编号
                         prm_aab001     IN     xasi2.ac02.aab001%TYPE,      --单位编号
                         prm_aae002     IN     xasi2.ac08.aae002%TYPE,      --费款所属期
                         prm_aae140     IN     xasi2.ac02.aae140%TYPE,      --险种
                         prm_yab139     IN     xasi2.ac02.yab139%TYPE,      --参保所属分中心
                         prm_yab136     IN     xasi2.ab01.yab136%TYPE,      --单位管理类型
                         prm_aac040     IN OUT xasi2.ac02.aac040%TYPE,      --新的缴费工资
                         prm_yac503     IN OUT xasi2.ac02.yac503%TYPE,      --工资类别
                         prm_YAA333     IN OUT xasi2.ac02.YAA333%TYPE,      --账户基数
                         prm_yac004     OUT    xasi2.ac02.yac004%TYPE,      --缴费基数
                         prm_yac505_old OUT    xasi2.ac02.yac505%TYPE,      --
                         prm_aae114_old OUT    xasi2.ac08.aae114%TYPE,      --缴费标志
                         prm_AppCode    OUT    VARCHAR2,              --执行代码
                         prm_ErrMsg     OUT    VARCHAR2);             --错误信息


--补差校验过程
PROCEDURE prc_p_checkTmp(prm_aac001      IN       xasi2.ab08.aac001%TYPE,      --个人编号
                         prm_aab001      IN       xasi2.ab08.aab001%TYPE,      --单位编号
                         prm_aae140      IN       xasi2.ab08.aae140%TYPE,      --险种
                         prm_aae041      IN       xasi2.ab08.aae041%TYPE,      --开始期号
                         prm_aae042      IN       xasi2.ab08.aae042%TYPE,      --终止期号
                         prm_yac503      IN       xasi2.ac08.yac503%TYPE,      --工资类别
                         prm_aac040      IN       xasi2.ac08.aac040%TYPE,      --缴费工资
                         prm_yaa333      IN       xasi2.ac08.yaa333%TYPE,      --帐户基数
                         prm_yab003      IN       xasi2.ab08.yab003%TYPE,      --社保经办机构
                         prm_yab139      IN       xasi2.ab08.yab139%TYPE,      --参保所属分中心
                         prm_AppCode     OUT      VARCHAR2        ,      --执行代码
                         prm_ErrMsg      OUT      VARCHAR2 );
--补差校验过程（总过程）
PROCEDURE  prc_p_checkData(prm_aab001   IN   xasi2.ab02.aab001%TYPE,   --单位编号
                           prm_yab139   IN   xasi2.ac02.yab139%TYPE,   --参保所属分中心
                           prm_yab003   IN   xasi2.ac02.yab003%TYPE,   --社保经办机构
                           prm_AppCode  OUT  VARCHAR2,           --执行代码
                           prm_ErrMsg   OUT  VARCHAR2);          --执行结果


 /*****************************************************************************
   ** 过程名称 : prc_queryjishu
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：查询单位缴费人员及基数
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2013-05-25   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_queryjishu(
         prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
        prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
        prm_aae001       IN     VARCHAR2,--申报年度
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             );
 /*****************************************************************************
   ** 过程名称 : prc_YLqueryjishu
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：查询单位缴费人员及基数(单养老)
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
                 prm_aae001       IN     VARCHAR2(4),--申报年度
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2013-05-25   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_YLqueryjishu(
         prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
        prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
        prm_aae001       IN     VARCHAR2,--申报年度
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             );
  /*****************************************************************************
   ** 过程名称 : prc_JGqueryjishu
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：查询单位缴费人员及基数(机关事业单位)
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2013-05-25   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_JGqueryjishu(
         prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
        prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
        prm_aae001       IN     VARCHAR2,
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             );

  /*****************************************************************************
   ** 过程名称 : prc_YearInternetApply
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：年审单位申报
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
                 prm_aae001       IN     NUMBER(4),--申报年度
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2013-05-25   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_YearInternetApply(
         prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
        prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
        prm_aae001       IN     NUMBER,--申报年度
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             );
  /*****************************************************************************
   ** 过程名称 : prc_JGYearInternetApply
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：年审单位申报(机关养老险种)
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
                 prm_aae001       IN     NUMBER(4),--申报年度
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2013-05-25   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_JGYearInternetApply(
         prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
        prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
        prm_aae001       IN     NUMBER,--申报年度
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             );

 /*****************************************************************************
   ** 过程名称 : prc_RBYearInternetApply
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：撤销年审单位申报
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2013-05-25   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_RBYearInternetApply(
         prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
        prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
        prm_aae001       IN     NUMBER,--申报年度
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             );
   /*****************************************************************************
   ** 过程名称 : prc_RBJGYearInternetApply
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：撤销年审单位申报(机关养老险种)
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2013-05-25   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_RBJGYearInternetApply(
         prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
        prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
        prm_aae001       IN     NUMBER,--申报年度
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             );

   /*****************************************************************************
   ** 过程名称 : prc_YearInternetAudit
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：审核端年审审核
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
                 prm_iaa018       IN     irad52.iaa018%TYPE,--审核标志
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2013-05-25   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_YearInternetAudit(
                                    prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
                                    prm_aae001       IN     xasi2.ac01k8.aae001%TYPE,--审核年度
                                    prm_iaa018       IN     irad52.iaa018%TYPE,--审核标志
                                   prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
                                   prm_iaa011       IN     irad51.iaa011%TYPE,--业务类型
                                   prm_yab019       IN     VARCHAR2 , --类型标志 1--企业基数申报 2--机关养老基数申报
                                   prm_AppCode      OUT    VARCHAR2          ,
                                   prm_ErrorMsg     OUT    VARCHAR2    );
  /*****************************************************************************
   ** 过程名称 : prc_YearInternetAuditRB
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：审核端年审审核(回退)
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
                 prm_iaa018       IN     irad52.iaa018%TYPE,--审核标志
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2013-05-25   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_YearInternetAuditRB(
                                    prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
                                    prm_aae001       IN     xasi2.ac01k8.aae001%TYPE,--审核年度
                                    prm_iaa011       IN     irad51.iaa011%TYPE,--业务类型
                                   prm_yab019       IN     VARCHAR2 , --类型标志 1--企业基数申报 2--机关养老基数申报
                                   prm_AppCode      OUT    VARCHAR2          ,
                                   prm_ErrorMsg     OUT    VARCHAR2    );
   /*****************************************************************************
   ** 过程名称 : prc_YearInternetBC
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：审核端补差操作
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
                prm_aae001       IN     xasi2_zs.ab05a1.aae001%TYPE,--审核年度
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2013-05-25   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_YearInternetBC(
                                    prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
                                    prm_aae001       IN     xasi2.ac01k8.aae001%TYPE,--审核年度
                                   prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
                                   prm_iaa011       IN     irad51.iaa011%TYPE,--业务类型
                                   prm_yab019       IN     VARCHAR2 , --类型标志 1--企业基数申报 2--机关养老基数申报
                                   prm_AppCode      OUT    VARCHAR2          ,
                                   prm_ErrorMsg     OUT    VARCHAR2    );

   /*****************************************************************************
   ** 过程名称 : prc_UpdateAb05a1
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：批量更新ab05a1的新基数
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2013-05-25   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_UpdateAb05a1(
         prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
         prm_aaz002       IN     tmp_ac40.aaz002%TYPE,--导入批次号
        prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
        prm_aae001       IN     VARCHAR2,--申报年度
        prm_iaa011       IN     irad51.iaa011%TYPE,--业务类型
        prm_yab019       IN     VARCHAR2 , --类型标志 1--企业基数申报 2--机关养老基数申报
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             );
        
   --更新AC01K8
   PROCEDURE prc_UpdateAc01k8 (
       prm_aab001       IN     xasi2.ac01k8.aab001%TYPE,--申报单位
        prm_aac001       IN     xasi2.ac01k8.aac001%TYPE,--个人编号
        prm_aae001       IN     xasi2.ac01k8.aae001%TYPE,--申报年度
        prm_aac040       IN     xasi2.ac01k8.aac040%TYPE, --新缴费工资
        prm_AppCode   OUT    VARCHAR2,
        prm_ErrorMsg    OUT    VARCHAR2);        
        
--   /*****************************************************************************
--   ** 过程名称 : prc_checkInsertIrac08a1
--   ** 过程编号 ：
--   ** 业务环节 ：
--   ** 功能描述 ：插入养老缴费记录检查
--   ******************************************************************************
--   ** 参数描述 ：参数标识        输入/输出         类型                 名称
--   ******************************************************************************
--   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
--   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
--   **           prm_AppCode      OUT    VARCHAR2          ,
--   **           prm_ErrorMsg     OUT    VARCHAR2
--   ******************************************************************************
--   ** 作    者：yh         作成日期 ：2013-05-25   版本编号 ：Ver 1.0.0
--   ** 修    改：
--   *****************************************************************************/
--   PROCEDURE prc_checkInsertIrac08a1 (prm_yae099       IN     VARCHAR2,
--                                      prm_aab001       IN     irab01.aab001%TYPE,--申报单位
--                                      prm_aae011       IN     VARCHAR2 ,
--                                      prm_AppCode      OUT    VARCHAR2 ,
--                                      prm_ErrorMsg     OUT    VARCHAR2
--                                      );
--   /*****************************************************************************
--   ** 过程名称 : prc_insertIrac08a1
--   ** 过程编号 ：
--   ** 业务环节 ：
--   ** 功能描述 ：插入养老缴费记录
--   ******************************************************************************
--   ** 参数描述 ：参数标识        输入/输出         类型                 名称
--   ******************************************************************************
--   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
--   **           prm_yae092       IN     iraa01a1.aae011%TYPE,--经办人
--   **           prm_AppCode      OUT    VARCHAR2          ,
--   **           prm_ErrorMsg     OUT    VARCHAR2
--   ******************************************************************************
--   ** 作    者：yh         作成日期 ：2013-05-25   版本编号 ：Ver 1.0.0
--   ** 修    改：
--   *****************************************************************************/
--   PROCEDURE prc_insertIrac08a1 (prm_yae099       IN     VARCHAR2,
--                                 prm_aab001       IN     irab01.aab001%TYPE,--申报单位
--                                 prm_aae002       IN     VARCHAR2 ,
--                                 prm_aae011       IN     VARCHAR2 ,
--                                 prm_AppCode      OUT    VARCHAR2 ,
--                                 prm_ErrorMsg     OUT    VARCHAR2
--                                 );

PROCEDURE prc_YearSalaryBCByYL(prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                               prm_aae001       IN     NUMBER            ,--年审年度
                               prm_aae002       IN     NUMBER            ,
                               prm_yab222       IN     xasi2.ab08.yab222%TYPE,
                               prm_aae076       IN     xasi2.ab08.aae076%TYPE,
                               prm_type         IN     VARCHAR2,  --1为社平公布前 2为社平公布后
                               prm_aae011       IN     irad31.aae011%TYPE,--经办人
                               prm_yab139       IN     VARCHAR2          ,--参保所属分中心
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          );
--社平工资公布后补差
PROCEDURE prc_YearSalaryBCBySP(prm_aab001       IN     irab01.aab001%TYPE,--单位编号  非必填
                               prm_yab139       IN     VARCHAR2          ,--参保所属分中心
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          );
PROCEDURE prc_YearSalaryBCBy03(prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                               prm_aae001       IN     NUMBER            ,--年审年度
                               prm_aae002       IN     NUMBER            ,
                               prm_yab222       IN     xasi2.ab08.yab222%TYPE,
                               prm_aae076       IN     xasi2.ab08.aae076%TYPE,
                               prm_type         IN     VARCHAR2,  --1为社平公布前 2为社平公布后
                               prm_aae140       IN     VARCHAR2,
                               prm_aae011       IN     irad31.aae011%TYPE,--经办人
                               prm_yab139       IN     VARCHAR2          ,--参保所属分中心
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          );
PROCEDURE prc_YearSalaryByPayInfos (prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                               prm_type         IN     VARCHAR2,   --1 为社平公布前补差 2为社平公布后补差
                               prm_aae003       IN     NUMBER,
                               prm_aae140       IN     VARCHAR2,
                               prm_aae001       IN     NUMBER,
                               prm_yab222       IN     VARCHAR2,
                               prm_aae011       IN     VARCHAR2,
                               prm_yab139       IN     VARCHAR2,
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          );
--开始年审补差（新）
PROCEDURE prc_YearSalaryBCBegin(prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                               prm_aae001       IN     NUMBER            ,--年审年度
                               prm_type         IN     VARCHAR2,  --1为社平公布前 2为社平公布后
                               prm_aae011       IN     irad31.aae011%TYPE,--经办人
                               prm_yab139       IN     VARCHAR2          ,--参保所属分中心
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          );
--年审数据清除
PROCEDURE prc_YearSalaryClear (prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                               prm_aae001       IN     NUMBER            ,--年审年度
                               prm_aae011       IN     irad31.aae011%TYPE,--经办人
                               prm_flag         OUT     VARCHAR2,     --成功标志 0成功 1 失败
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          );
--年审基数比例(同单位1月基数比较)                               
PROCEDURE prc_YearApplyJSProportions (prm_aab001       IN      xasi2.ab01.aab001%TYPE,--单位编号
                               prm_aae001       IN     NUMBER            ,--年审年度
                               prm_aae011       IN     irad31.aae011%TYPE,--经办人
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          );
--补差定时任务                               
PROCEDURE pkg_p_createJob( 
                              prm_aab001      IN   xasi2.ab01.aab001%TYPE,  --单位编号 
                              prm_aae001      IN   xasi2.ab05.aae001%TYPE,  --年审年份
                              prm_aae011      IN   xasi2.ab08.aae011%TYPE,  --经办人 
                              prm_iaa011         IN     irad51.iaa011%TYPE,              --业务类型
                              prm_yab019        IN     VARCHAR2          ,                 --类型标志
                              prm_yab139      IN   xasi2.ab02.yab139%TYPE,  --经办分中心
                              prm_AppCode   OUT    VARCHAR2 ,   
                              prm_ErrMsg       OUT    VARCHAR2     );   
 -- 补差                           
PROCEDURE prc_YearSalaryBCJOB(
                           prm_jobid            IN    VARCHAR2,  
                           prm_aab001        IN     irab01.aab001%TYPE,           --单位编号  必填
                           prm_aae001        IN     NUMBER            ,                  --年审年度
                           prm_aae011        IN     irad31.aae011%TYPE,            --经办人
                           prm_yab139        IN     VARCHAR2          ,                 --参保所属分中心
                           prm_iaa011         IN     irad51.iaa011%TYPE,              --业务类型
                           prm_yab019        IN     VARCHAR2    );               --类型标志
                             
END PKG_YearApply;