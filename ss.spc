CREATE OR REPLACE PACKAGE PKG_Insurance AS
   /*---------------------------------------------------------------------------
   ||  程序包名 ：PKG_Insurance
   ||  业务环节 ：Insurance
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



   /*-------------------------------------------------------------------------*/
   /*定义一个记录类型*/
   /*-------------------------------------------------------------------------*/
   TYPE rec_change IS RECORD(
        col_name  VARCHAR2(60),
        col_value VARCHAR2(3000));
   TYPE tab_change IS TABLE OF rec_change INDEX BY BINARY_INTEGER;

   /*****************************************************************************
   ** 过程名称 oldEmpManaInfoMove
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
      prm_aae011       IN      irab01.aae011%TYPE,--经办人
      prm_aae013       IN      irab01.aae013%TYPE,--备注
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );

   /*-------------------------------------------------------------------------*/
   /* 公用过程函数声明                                                        */
   /*-------------------------------------------------------------------------*/
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
      prm_flag         IN     VARCHAR2          ,--是否单企业养老险种的老单位
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );

   /*-------------------------------------------------------------------------*/
   /* 社会保险登记                                                       */
   /*-------------------------------------------------------------------------*/
   PROCEDURE prc_AddApplyInfo (
      prm_iaz008       IN     irad02.iaz008%TYPE,--申报主体编号
      prm_iad003       IN     irad02.iad003%TYPE,--申报主体名称
      prm_aae013       IN     irad02.aae013%TYPE,--备注
      prm_aac001       IN     irad02.aac001%TYPE,--申报人
      prm_flag      IN     VARCHAR2          ,
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );

   /*-------------------------------------------------------------------------*/
   /* 单位信息维护                                                        */
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
   ** 过程名称 : prc_UnitBaseInfoMaintain
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：单位基本信息维护
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
      prm_aab001       IN     irab01.aab001%TYPE, --单位编号
      prm_aab004       IN     irab01.aab004%TYPE, --单位编号
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
      prm_ErrorMsg     OUT    VARCHAR2          );


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
   **           prm_iaa018       IN     irad22.iaa018%TYPE,--审核标志
   **           prm_iaa028       IN     VARCHAR2          ,--是否全部
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_yab003       IN     ae02.yab003%TYPE  ,--经办人所在经办机构
   **           prm_aae013       IN     iraa02.aae013%TYPE,--备注
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-12   版本编号 ：Ver 1.0.0
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
      prm_ErrorMsg     OUT    VARCHAR2          );

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
   **            prm_Flag      OUT    VARCHAR2    ,
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
      prm_Flag      OUT    VARCHAR2   ,
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );


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
   **           prm_iaa018       IN     irad22.iaa018%TYPE,--审核标志
   **           prm_iaa028       IN     VARCHAR2          ,--是否全部
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_aae013       IN     iraa02.aae013%TYPE,--备注
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-12   版本编号 ：Ver 1.0.0
   ** 修    改：
   *****************************************************************************/
   PROCEDURE prc_AuditMonthInternetRNew (
      prm_iaa011       IN     iraa02.iaa011%TYPE,--业务类型
      prm_iaa003       IN     iraa02.iaa003%TYPE,--业务主体
      prm_iaa018       IN     irad22.iaa018%TYPE,--审核标志
      prm_iaa028       IN     VARCHAR2          ,--是否全部
      prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
      prm_aae013       IN     iraa02.aae013%TYPE,--备注
      prm_aaz002       OUT    VARCHAR2          ,
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );



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
   **           prm_iaa018       IN     irad22.iaa018%TYPE,--审核标志
   **           prm_iaa028       IN     VARCHAR2          ,--是否全部
   **           prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
   **           prm_aae013       IN     iraa02.aae013%TYPE,--备注
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2          );
   ******************************************************************************
   ** 作    者：yh         作成日期 ：2012-08-12   版本编号 ：Ver 1.0.0
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
      prm_ErrorMsg     OUT    VARCHAR2          );

   /*****************************************************************************
   ** 过程名称 : prc_AddNewManage
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：新增专管员
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     iraa01.aab001%TYPE,--专管员所在单位编码
   **           prm_aac001       IN     iraa01.aac001%TYPE,--专管员证件类型
   **           prm_yab516       IN     iraa01.yab516%TYPE,--专管员证件号
   **           prm_aab016       IN     iraa01.aab016%TYPE,--专管员姓名
   **           prm_aac004       IN     ad53a4.aac004%TYPE,--专管员姓名
   **           prm_yae041       IN     ad53a4.yae041%TYPE,--专管员登录账号
   **           prm_yae042       IN     iraa01.yae042%TYPE,--专管员密码
   **           prm_yae043       IN     iraa01.yae043%TYPE,--初始密码
   **           prm_yab003       IN     ae02.yab003%TYPE,--经办人
   **           prm_aae011       IN     iraa01.aae011%TYPE,--经办人
   **           prm_aae013       IN     ae02.aae013%TYPE,  --备注
   **           prm_shmark       IN     VARCHAR2,          --审核通过标志
   **           prm_AppCode      OUT    VARCHAR2,
   **           prm_ErrorMsg     OUT    VARCHAR2,
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
     prm_ErrorMsg     OUT    VARCHAR2          );


   /*****************************************************************************
   ** 过程名称 : prc_UnitInfoMaintainAudit
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：单位信息维护审核
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     iraa01.aab001%TYPE,--专管员所在单位编码
   **           prc_aae015       IN     iraa01.aac001%TYPE,--审核意见
   **           prc_iaa002       IN     iraa01.yab516%TYPE,--审核结果
   **           prm_aae011       IN     iraa01.aae011%TYPE,--经办人
   **           prm_AppCode      OUT    VARCHAR2          ,
   **           prm_ErrorMsg     OUT    VARCHAR2
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
     prm_ErrorMsg     OUT    VARCHAR2          );


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
      prm_aac013       IN     irac01.aac013%TYPE,--用工性质
      prm_yac168       IN     irac01.yac168%TYPE,--农民工标志
      prm_aac007        IN    irac01.aac007%TYPE,--参工日期
      prm_aac012        IN    irac01.aac012%TYPE,--个人身份
      prm_aae011       IN     irac01.aae011%TYPE,--经办人
      prm_aac040       IN     irac01.aac040%TYPE,--申报工资
      prm_iac001       OUT    irac01.iac001%TYPE,--申报编号
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );


   /*****************************************************************************
   ** 过程名称 : prc_PersonInfoMaintainDanYL
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：人员重要信息维护(针对单养老)
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aac001       IN     irac01.aac001%TYPE,--个人编号
   **           prm_aab001       IN     irac01.aab001%TYPE,--单位编号
   **           prm_aac002       IN     irac01.aac002%TYPE,--证件号码
   **           prm_aac003       IN     irac01.aac003%TYPE,--姓名
   **           prm_aac004       IN     irac01.aac004%TYPE,--性别
   **           prm_aac006       IN     irac01.aac006%TYPE,--出生日期
   **           prm_aac009       IN     irac01.aac009%TYPE,--户口性质
   **           prm_aae011       IN     irac01.aae011%TYPE,--经办人
   **           prm_aac040       IN     irac01.aac040%TYPE,--申报工资
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
      prm_aac013       IN     irac01.aac013%TYPE,--用工性质
      prm_yac168       IN     irac01.yac168%TYPE,--农民工标志
      prm_aac007        IN    irac01.aac007%TYPE,--参工日期
      prm_aac012        IN    irac01.aac012%TYPE,--个人身份
      prm_aae011       IN     irac01.aae011%TYPE,--经办人
      prm_aac040       IN     irac01.aac040%TYPE,--申报工资
      prm_iac001       OUT    irac01.iac001%TYPE,--申报编号
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );


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
     prm_ErrorMsg     OUT    VARCHAR2          );

   /*****************************************************************************
   ** 过程名称 : prc_RollBackASIR
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：回退社会保险登记审核
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aaz002       IN     ae02.aaz002%TYPE,  --业务日志编号
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
      prm_ErrorMsg     OUT    VARCHAR2          );

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
      prm_ErrorMsg     OUT    VARCHAR2          );

   /*****************************************************************************
   ** 过程名称 : prc_RollBackAMIR
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：回退月申报审核
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aaz002       IN     ae02.aaz002%TYPE,  --业务日志编号
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
      prm_ErrorMsg     OUT    VARCHAR2          );

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
      prm_ErrorMsg     OUT    VARCHAR2          );


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
      prm_ErrorMsg     OUT    VARCHAR2          );


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
      prm_ErrorMsg     OUT    VARCHAR2          );

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
                            RETURN VARCHAR2;
   PROCEDURE prc_GETAAB001C(prm_aab020     IN     irab01.aab020%TYPE,--经济类型
                            prm_yab006     IN     irab01.yab006%TYPE,--税务机构
                            prm_aab001     OUT    VARCHAR2,          --单位编号
                            prm_AppCode    OUT    VARCHAR2  ,
                            prm_ErrorMsg   OUT    VARCHAR2 );
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
                                  prm_aae002     IN     xasi2.ab08.aae003%TYPE,  --费款所属期
                                  prm_yae010     IN     xasi2.aa05.yae010%TYPE,  --费用来源:地税征收
                                  prm_aae011     IN     xasi2.ab08.aae011%TYPE,  --经办人员
                                  prm_flag       IN     VARCHAR2,          --提交标志 0 提交 1不提交
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
                             prm_iaz018     IN     irac01a2.iaz018%TYPE,  --批量导入批次ID
                             prm_AppCode    OUT    VARCHAR2  ,
                             prm_ErrorMsg   OUT    VARCHAR2 );


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
                             prm_ErrorMsg   OUT    VARCHAR2 );

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
                                    prm_ErrorMsg   OUT    VARCHAR2 );


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
                                          prm_ErrorMsg   OUT    VARCHAR2 );



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
                               prm_ErrorMsg   OUT    VARCHAR2 );


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
                prm_ErrorMsg   OUT    VARCHAR2 );



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
                                 prm_iaz018     IN     irac01a2.iaz018%TYPE,  --批量导入批次ID
                                 prm_AppCode    OUT    VARCHAR2  ,
                                 prm_ErrorMsg   OUT    VARCHAR2 );




   /*****************************************************************************
   ** 过程名称 : prc_pensionImp
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：批量导入养老信息
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
                            prm_AppCode    OUT    VARCHAR2  ,
                            prm_ErrorMsg   OUT    VARCHAR2 );


   /*****************************************************************************
   ** 过程名称 : prc_pensionMaintainImp
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：批量导入养老信息
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
                                    prm_ErrorMsg   OUT    VARCHAR2 );

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
      prm_ErrorMsg     OUT    VARCHAR2          );
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
      prm_ErrorMsg     OUT    VARCHAR2          );
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
      prm_ErrorMsg     OUT    VARCHAR2          );

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
      prm_ErrorMsg     OUT    VARCHAR2          );
--单养老单位回退
PROCEDURE prc_RollBackAMIRBYYL (
      prm_aaz002       IN     ae02.aaz002%TYPE,  --业务日志编号
      prm_iaa100       IN     irad01.iaa100%TYPE,--申报月度
      prm_aab001       IN     irad01.aab001%TYPE,--申报单位
      prm_aae011       IN     irad31.aae011%TYPE,--经办人
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );
--单养老单位重置
PROCEDURE prc_ResetASMRBYYL (
      prm_aab001       IN     irab01.aab001%TYPE,--单位编号
      prm_iaa100       IN     irad01.iaa100%TYPE,--申报月度
      prm_aae011       IN     irad31.aae011%TYPE,--经办人
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );

 PROCEDURE prc_Ab02a8Unit (
      prm_aab001       IN     irab01.aab001%TYPE,--单位编号
      prm_yae099       IN     VARCHAR2,          --业务流水号
      prm_AppCode      OUT    VARCHAR2,
      prm_ErrorMsg     OUT    VARCHAR2  );

-- 单位缴费基数回退
PROCEDURE prc_Ab02a8UnitRollBack (
      prm_aab001       IN     varchar2,--单位编号
      prm_AppCode      OUT    VARCHAR2          ,
      prm_ErrorMsg     OUT    VARCHAR2          );

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
                             prm_ErrMsg       OUT   VARCHAR2  );   --错误内容


 PROCEDURE prc_insertAC29(
                               prm_aab001  IN irab01.aab001%TYPE, --单位助记码
                               prm_iaa100  IN irac01.iaa100%TYPE,
                               prm_aae011  IN irac01.aae011%TYPE, --经办人
                               prm_AppCode OUT VARCHAR2, --错误代码
                               prm_ErrorMsg  OUT VARCHAR2); --错误内容

 PROCEDURE prc_insertIRAD01(
             prm_aab001  IN irab01.aab001%TYPE, --单位助记码
             prm_aae011  IN irac01.aae011%TYPE, --经办人
             prm_AppCode OUT VARCHAR2, --错误代码
             prm_ErrorMsg  OUT VARCHAR2);
             
 /* 在职人员补收 */
 PROCEDURE prc_SupplementCharge(
             prm_aae123  IN xasi2.tmp_sc01.aae123%TYPE,
             prm_aac040  IN xasi2.tmp_sc01.aac040%TYPE, --申报工资
             prm_yac004  IN xasi2.tmp_sc01.yac004%TYPE, --申报基数
             prm_aab001  IN xasi2.ab01.aab001%TYPE, --单位助记码
             prm_aac001  IN xasi2.ac01.aac001%TYPE, --单位助记码
             prm_aae011  IN irac01.aae011%TYPE, --经办人
             prm_AppCode OUT VARCHAR2, --错误代码
             prm_ErrorMsg  OUT VARCHAR2);
             
END PKG_Insurance;
/
