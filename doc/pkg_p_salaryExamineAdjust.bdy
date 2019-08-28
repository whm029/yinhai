CREATE OR REPLACE PACKAGE BODY XASI2.pkg_p_salaryExamineAdjust
AS
   /********************************************************************************/
   /*  程序包名 pkg_p_payAdjust                                                    */
   /*  业务环节 ：单位缴费补差                                                     */
   /*  对象列表 ：                                                                 */
   /*  公共过程函数                                                                */
   /*             01 pkg_p_salaryExamineAdjust            单位年审补差             */
   /*             02 prc_p_checkData                      数据校验                 */
   /*  私有过程函数                                                                */
   /*             ------------------------数据效验过程-----------------------------*/
   /*             A01 prc_p_checkTmp                       校验临时表数据          */
   /*             A02 prc_p_checkYSJ                       检查应实缴信息          */
   /*             -----------------------业务处理过程------------------------------*/
   /*                                                                              */
   /*  其它说明 ：                                                                 */
   /*                                                                              */
   /*  完 成 人 ：                                                                 */
   /*  完成日期 ：2009-12                                                          */
   /*  版本编号 ：Ver 1.0                                                          */
   /*  审 查 人 ：×××                      审查日期 ：YYYY-MM-DD                   */
   /********************************************************************************/

   --效验临时表数据过程
   PROCEDURE prc_p_checkTmp(prm_aac001      IN       ab08.aac001%TYPE,      --个人编号
                            prm_aab001      IN       ab08.aab001%TYPE,      --单位编号
                            prm_aae140      IN       ab08.aae140%TYPE,      --险种
                            prm_aae041      IN       ab08.aae041%TYPE,      --开始期号
                            prm_aae042      IN       ab08.aae042%TYPE,      --终止期号
                            prm_yac503      IN       ac08.yac503%TYPE,      --工资类别
                            prm_aac040      IN       ac08.aac040%TYPE,      --缴费工资
                            prm_yaa333      IN       ac08.yaa333%TYPE,      --帐户基数
                            prm_bcfs        IN       VARCHAR2,              --补差方式
                            prm_yab003      IN       ab08.yab003%TYPE,      --社保经办机构
                            prm_yab139      IN       ab08.yab139%TYPE,      --参保所属分中心
                            prm_AppCode     OUT      VARCHAR2        ,      --执行代码
                            prm_ErrMsg      OUT      VARCHAR2 )
                            ;
   --效验对应期实缴过程
   PROCEDURE prc_p_checkYSJ(prm_aac001     IN     ac02.aac001%TYPE,      --个人编号
                            prm_aab001     IN     ac02.aab001%TYPE,      --单位编号
                            prm_aae002     IN     ac08.aae002%TYPE,      --费款所属期
                            prm_aae140     IN     ac02.aae140%TYPE,      --险种
                            prm_bcfs       IN     VARCHAR2,              --补差方式
                            prm_yab139     IN     ac02.yab139%TYPE,      --参保所属分中心
                            prm_yab003     IN     ac02.yab003%TYPE,      --社保经办机构
                            prm_yab136     IN     ab01.yab136%TYPE,      --单位管理类型
                            prm_aac040     IN OUT ac02.aac040%TYPE,      --新的缴费工资
                            prm_yac503     IN OUT ac02.yac503%TYPE,      --工资类别
                            prm_YAA333     IN OUT ac02.YAA333%TYPE,      --账户基数
                            prm_yac004     OUT    ac02.yac004%TYPE,      --缴费基数
                            prm_aaa041     OUT    aa05.aaa041%TYPE,      --个人缴费比例
                            prm_yaa017     OUT    aa05.yaa017%TYPE,      --个人划统筹比
                            prm_aaa042     OUT    aa05.aaa042%TYPE,      --单位缴费比例
                            prm_aaa043     OUT    aa05.aaa043%TYPE,      --单位缴费划帐
                            prm_ala080     OUT    ac08.ala080%TYPE,      --工伤浮动费率
                            prm_yac168_old OUT    ac01.yac168%TYPE,      --农民工标志
                            prm_yac505_old OUT    ac02.yac505%TYPE,      --
                            prm_aac008_old OUT    ac01.aac008%TYPE,      --
                            prm_aaa040_old OUT    aa05.aaa040%TYPE,
                            prm_ykc120_old OUT    ac08.ykc120%TYPE,      --医疗照顾人员类别
                            prm_akc021_old OUT    ac08.akc021%TYPE,      --医疗人员类别
                            prm_aae114_old OUT    ac08.aae114%TYPE,      --缴费标志
                            prm_age        OUT    ac08.akc023%TYPE,      --年龄
                            prm_yac176     OUT    ac08.yac176%TYPE,      --工龄
                            prm_yaa310     OUT    ac08.yaa310%TYPE,      --比例类型
                            prm_yae010     OUT    ac08.yae010%TYPE,      --费用来源
                            prm_yaa330     OUT    ac08.yaa330%TYPE,      --缴费比例模式
                            prm_AppCode    OUT    VARCHAR2,              --执行代码
                            prm_ErrMsg     OUT    VARCHAR2)              --错误信息
                            ;

   --人员各个险种写入明细
   PROCEDURE prc_p_CreateDetail
                         (prm_aaz002      IN  VARCHAR2,
                          prm_aaz083      IN  VARCHAR2,
                          prm_yae518      IN   ac08.yae518%TYPE,   --核定流水号
                          prm_aab001      IN   ac08.aab001%TYPE,   --单位编号
                          prm_aac001      IN   ac08.aac001%TYPE,   --个人编号
                          prm_aae003      IN   ac08.aae003%TYPE,   --做帐期号
                          prm_yab139      IN   ab08.yab139%TYPE,   --所属参保分中心
                          prm_yab003      IN   ab08.yab003%TYPE,   --社保经办机构
                          prm_aae011      IN   ab08.aae011%TYPE,   --经办人
                          prm_aae036      IN   ab08.aae036%TYPE,   --经办时间
                          prm_AppCode     OUT  VARCHAR2,           --执行代码
                          prm_ErrMsg      OUT  VARCHAR2            --执行结果
                         )
                         ;
                         
   --迁移数据 add by fenggg at 20190709 
   PROCEDURE prc_p_moveDetail(prm_yae518      IN       ac08a1.yae518%type,    --核定流水号
                              prm_aaz002      IN       ae23.aaz002%TYPE,    
                              prm_aaz083      IN       ae23.aaz083%TYPE,    
                              prm_aab001      IN       ab08.aab001%TYPE,      --单位编号
                              prm_aae001      IN       ab05.aae001%TYPE,      --年审年份
                              prm_yae010      IN       ab08.yae010%TYPE,      --费用来源   
                              prm_aae011      IN       ab08.aae011%TYPE,      --经办人   
                              prm_yab003      IN       ab08.yab003%TYPE,      --社保经办机构
                              prm_yab139      IN       ab08.yab139%TYPE,      --参保所属分中心
                              prm_AppCode     OUT      VARCHAR2        ,      --执行代码
                              prm_ErrMsg      OUT      VARCHAR2 );
                    
   /*****************************************************************************
   ** 过程名称 pkg_p_salaryExamineAdjust
   ** 过程编号 : 03
   ** 业务环节 ：批量补差
   ** 功能描述 ：根据每期基数或比例的不同产生不同的差额，批量对单位进行补差
   ******************************************************************************
   ** 作    者：            作成日期 ：2009-12-29   版本编号 ：Ver 1.0.0
   ** 字    体: Courier New  字    号 ：10
   ** 修    改：
   ******************************************************************************
   ** 备    注：
   **
   *****************************************************************************/
   PROCEDURE pkg_p_salaryExamineAdjust(
                                     prm_aaz002      IN  VARCHAR2,
                                     prm_aaz083      IN  VARCHAR2,
                                     prm_aab001      IN   ab02.aab001%TYPE, --单位编号
                                     prm_aae003      IN   ac08.aae003%TYPE, --做帐期号
                                     prm_bcfs        IN   NUMBER          , --补差方式(0 缴费比例补差， 1 缴费基数补差）
                                     prm_collectflag IN   NUMBER          , --征集标志(0:否;1:是
                                     prm_tkfs        IN   NUMBER          , --退款方式(1、退现金；2、进待转）
                                     prm_check       IN   NUMBER          , --检查是否存在有效补差数据。0、不检查。1、检查。
                                     prm_yab401      IN   ab08.yab401%TYPE, --利息标志
                                     prm_yab400      IN   ab08.yab400%TYPE, --滞纳金标志
                                     prm_aab033      IN   ab02.aab033%TYPE, --征收方式
                                     prm_yab139      IN   ab08.yab139%TYPE, --所属参保分中心
                                     prm_yab003      IN   ab08.yab003%TYPE, --社保经办机构
                                     prm_aae011      IN   ab08.aae011%TYPE, --经办人
                                     prm_aae036      IN   ab08.aae036%TYPE, --经办时间
                                     prm_yab222      IN   ab08.yab222%TYPE, --做帐批次号
                                     prm_aae076      OUT  ab08.aae076%TYPE, --财务接口流水号
                                     prm_AppCode     OUT  VARCHAR2,         --执行代码
                                     prm_ErrMsg      OUT  VARCHAR2)         --执行结果
   IS
      var_procNo      VARCHAR2(5);         --过程号

      num_count       NUMBER     ;         --

      var_aac001      ac01.aac001%TYPE  ;  --个人编号

      num_aab156      ab08.aab156%TYPE  ;  --欠费金额
      var_aae140      ab08.aae140%TYPE  ;  --险种信息
      var_yae010      ab08.yae010%TYPE  ;  --费用来源

      var_yad052      ab15a1.yad052%TYPE;
      var_yad060      ab15a1.yad060%TYPE;

      var_yab136      ab01.yab136%TYPE  ;  --单位管理类型
      var_aab019      ab01.aab019%TYPE  ;  --单位类型
      var_aab020      ab01.aab020%TYPE  ;  --经济类型
      var_aab021      ab01.aab021%TYPE  ;  --隶属关系
      var_aab022      ab01.aab022%TYPE  ;  --行业代码
      var_YKB109      ab01.YKB109%TYPE  ;  --是否享受公务员统筹待遇
      var_yab275      ab01.yab275%TYPE  ;  --医疗保险执行办法
      var_yab380      ab01.yab380%TYPE  ;
      var_ykb110      ab01.ykb110%TYPE  ;  --预划账户标志
      var_aae076      ab08.aae076%TYPE  ;  --
      var_yae518_sk   ab08.yae518%TYPE  ;  --核定流水号
      var_yae518_tk   ab08.yae518%TYPE  ;  --
      var_yae518_dz   ab08.yae518%TYPE  ;  --核定流水号
      num_aae002      NUMBER;

      var_flag        VARCHAR2(3)       ;  --是否进行了补差操作0 ：没有；1：进行了。

      --每个人每个险种进行一次明细写入
      CURSOR cur_aac001
      IS
         SELECT DISTINCT aac001
           FROM tmp_grbs02
          WHERE aae100 = pkg_comm.AAE100_YX;

      --本次要生成退收的数据
      CURSOR cur_tmp_grbs02_ts
      IS
         SELECT aac001,
                aae002,  --费款所属期号
                aae140   --险种
           FROM tmp_grbs02
          WHERE aae100 = pkg_comm.AAE100_YX       --有效标志：有效
            AND yac004 < 0 ;

      --实缴退款数据
      CURSOR cur_ab08_sjts
      IS
         SELECT SUM(aab156) AS aab156,
                aae140               ,
                MIN(aae041) AS aae041,
                MAX(aae042) AS aae042
           FROM ab08
          WHERE yae518 = var_yae518_tk
            AND yae517 = pkg_Comm.YAE517_H17    --补差退收
            AND yae010 = pkg_comm.YAE010_ZC
       GROUP BY aae140;

      CURSOR cur_ac08a1_sk                                     -- 明细信息
      IS
         SELECT a.aae140,
                a.yae010,    --费用来源
                MIN(a.aae002) AS aae041,
                MAX(a.aae002) AS aae042,
                COUNT(DISTINCT a.aac001) yae231,   --人数
                a.yae203   , --费用来源比例
                max(CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                     WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                     ELSE pkg_comm.YAB538_LX
                     END) YAB538,
                NVL(SUM(a.aae180),0) aab120,   --个人缴费基数总额
                NVL(SUM(a.aae180),0) aab121,   --单位缴费基数总额
                NVL(SUM(a.yab157),0) aab150,   --应缴个人缴费划入账户金额
                NVL(SUM(a.yab158),0) yab031,   --应缴个人缴费划入统筹金额
                NVL(SUM(a.aab212),0) aab151,   --应缴单位缴费划入账户金额
                NVL(SUM(a.aab213),0) aab152,   --应缴单位缴费划入统筹金额
                NVL(SUM(0),0) aab157     ,   --应补缴个人缴费划入账户本年利息
                NVL(SUM(0),0) aab158     ,   --应补缴个人缴费划入账户跨年利息
                NVL(SUM(0),0) aab159     ,   --应补缴账户本年利息单位划入金额
                NVL(SUM(0),0) aab160     ,   --应补缴账户跨年利息单位划入金额
                NVL(SUM(0),0) aab161     ,   --应补缴统筹跨年利息金额
                NVL(SUM(a.aab162),0) aab162    --应缴滞纳金金额
           FROM ac08a1check a
          WHERE a.yae518 = var_yae518_sk
            AND a.aab001 = prm_aab001
            AND a.aae003 = prm_aae003
          GROUP BY a.aae140,
                   a.yae010,    --费用来源
                   a.yae203,    --费用来源比例
                   CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                        WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                        ELSE pkg_comm.YAB538_LX
                        END;

      CURSOR cur_ac08a1_tk                                      -- 明细信息
      IS
         SELECT a.aae140,
                a.yae010,    --费用来源
                MIN(a.aae002) AS aae041,
                MAX(a.aae002) AS aae042,
                COUNT(DISTINCT a.aac001) yae231,   --人数
                a.yae203   , --费用来源比例
                max(CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                     WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                     ELSE pkg_comm.YAB538_LX
                     END) YAB538,
                NVL(SUM(a.aae180),0) aab120,   --个人缴费基数总额
                NVL(SUM(a.aae180),0) aab121,   --单位缴费基数总额
                NVL(SUM(a.yab157),0) aab150,   --应缴个人缴费划入账户金额
                NVL(SUM(a.yab158),0) yab031,   --应缴个人缴费划入统筹金额
                NVL(SUM(a.aab212),0) aab151,   --应缴单位缴费划入账户金额
                NVL(SUM(a.aab213),0) aab152,   --应缴单位缴费划入统筹金额
                NVL(SUM(0),0) aab157     ,   --应补缴个人缴费划入账户本年利息
                NVL(SUM(0),0) aab158     ,   --应补缴个人缴费划入账户跨年利息
                NVL(SUM(0),0) aab159     ,   --应补缴账户本年利息单位划入金额
                NVL(SUM(0),0) aab160     ,   --应补缴账户跨年利息单位划入金额
                NVL(SUM(0),0) aab161     ,   --应补缴统筹跨年利息金额
                NVL(SUM(a.aab162),0) aab162    --应缴滞纳金金额
           FROM ac08a1check a
          WHERE a.yae518 = var_yae518_tk
            AND a.aab001 = prm_aab001
            AND a.aae003 = prm_aae003
          GROUP BY a.aae140,
                   a.yae010,    --费用来源
                   a.yae203,    --费用来源比例
                   CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                        WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                        ELSE pkg_comm.YAB538_LX
                        END;
   BEGIN
      --初始化变量
      prm_AppCode    := pkg_COMM.gn_def_OK ;
      prm_ErrMsg     := '' ;
      var_procNo     := '03';
      var_flag       := '0' ;  --是否进行了补差操作0 ：没有；1：进行了。

      SELECT COUNT(1)
        INTO num_count
        FROM tmp_grbs01;
      IF num_count <= 0 THEN
         prm_AppCode := gs_FunNo||var_procNo||'01';
         prm_ErrMsg  := '批量缴费补差出错，出错原因：没有写入tmp_grbs01信息';
         RETURN;
      END IF;

      --检查tmp_grbs01,并生成tmp_grbs02信息
      prc_p_checkData(prm_aab001   ,   --单位编号
                      prm_bcfs     ,   --补差方式（0 缴费比例补差， 1 缴费基数补差）
                      prm_yab139   ,   --参保所属分中心
                      prm_yab003   ,   --社保经办机构
                      prm_AppCode  ,           --执行代码
                      prm_ErrMsg   );            --执行结果
      IF prm_AppCode <> pkg_COMM.gn_def_OK THEN
         RETURN;
      END IF;

      --检查是否存在有效的补差数据
      INSERT INTO tmp_grbc02 SELECT * FROM tmp_grbs02 WHERE aae100 = pkg_comm.AAE100_YX;
      IF SQL%ROWCOUNT <= 0 THEN
         IF prm_check = 0 THEN
            RETURN ;
         ELSE
            prm_AppCode := gs_FunNo||var_procNo||'02';
            prm_ErrMsg  := '批量缴费补差出错，出错原因：没有需要补差的数据'||prm_check;
            RETURN;
         END IF ;
      END IF;
      --检查费用来源
      BEGIN
         SELECT DISTINCT yae010
           INTO var_yae010
           FROM tmp_grbc02
          WHERE aae100 = pkg_comm.AAE100_YX;       --有效标志：有效
      EXCEPTION
         WHEN TOO_MANY_ROWS THEN
            prm_AppCode    := gs_FunNo||var_procNo||'01';
            prm_ErrMsg     := '本次补差数据中存在多种费用来源，不能继续，请确认！' ;
            RETURN;
         WHEN OTHERS THEN
            prm_AppCode    := gs_FunNo||var_procNo||'01';
            prm_ErrMsg     := '本次补差数据中获取费用来源出错，不能继续，请确认！' ||SQLERRM ;
            RETURN;
      END ;

      --获取单位基本信息
      pkg_p_checkEmployerFeeCo.prc_p_checkEmployerBase
           (prm_aab001 ,  --单位编码
            var_aab019 ,  --单位类型
            var_aab020 ,  --经济类型
            var_aab021 ,  --隶属关系
            var_aab022 ,  --行业代码
            var_yab136 ,  --单位管理类型
            var_YKB109 ,
            var_yab275 ,
            var_yab380 ,
            var_ykb110 ,  --预划账户标志
            prm_AppCode,  --执行代码
            prm_ErrMsg ); --执行结果
      IF prm_AppCode <> pkg_comm.gn_def_OK  THEN
         RETURN;
      END IF;

      --正数补差、欠费补差退收 生成明细
      DELETE tmp_grbs02;
      INSERT INTO tmp_grbs02 SELECT * FROM tmp_grbc02 WHERE NOT (aae114 = pkg_comm.AAE114_YSJ AND yac004 < 0 );
      var_yae518_sk := NULL;
      --生成个人明细
       INSERT INTO AE23(
                         aaz083, --当事人征缴计划事件ID
                         aaz002, --业务日志ID
                         aaz010, --当事人ID
                         aae013, --备注
                         aae011, --经办人
                         aae036, --经办时间
                         yab003, --经办所属机构
                         aae016,  --复核标志
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
                            var_yae518_sk  ,   --核定流水号
                            prm_aab001     ,   --单位编号
                            var_aac001     ,   --个人编号
                            prm_aae003     ,   --做帐期号
                            prm_yab139     ,   --所属参保分中心
                            prm_yab003     ,   --社保经办机构
                            prm_aae011     ,   --经办人
                            prm_aae036     ,   --经办时间
                            prm_AppCode    ,   --执行代码
                            prm_ErrMsg         --执行结果
                         );
         IF prm_AppCode <> pkg_COMM.gn_def_OK THEN
            GOTO label_ERROR ;
         END IF;

      END LOOP;

      --正数补差、欠费补差退收 写成一个ab08
      FOR rec_ac08a1_sk IN  cur_ac08a1_sk LOOP
         /*生成核定汇总应收信息表*/
         pkg_p_checkEmployerFeeCo.prc_p_insertab08check(
                             var_yae518_sk, --核定流水号
                             prm_aab001, --单位编号
                             NULL      , --个人编号
                             rec_ac08a1_sk.aae140, --险种类型
                             prm_aae003, --做帐期号
                             rec_ac08a1_sk.aae041, --开始期号
                             rec_ac08a1_sk.aae042, --终止期号
                             rec_ac08a1_sk.yab538, --缴费人员状态
                             rec_ac08a1_sk.yae010,--费用来源
                             pkg_Comm.YAE517_H12, --核定类型
                             prm_yab222, --做帐批次号
                             rec_ac08a1_sk.yae231,   --人数
                             rec_ac08a1_sk.yae203,   --费用来源比例
                             rec_ac08a1_sk.aab120,   --个人缴费基数总额
                             rec_ac08a1_sk.aab121,   --单位缴费基数总额
                             rec_ac08a1_sk.aab150,   --应缴个人缴费划入账户金额
                             rec_ac08a1_sk.yab031,   --应缴个人缴费划入统筹金额
                             rec_ac08a1_sk.aab151,   --应缴单位缴费划入账户金额
                             rec_ac08a1_sk.aab152,   --应缴单位缴费划入统筹金额
                             rec_ac08a1_sk.aab157,   --应补缴个人缴费划入账户本年利息
                             rec_ac08a1_sk.aab158,   --应补缴个人缴费划入账户跨年利息
                             rec_ac08a1_sk.aab159,   --应补缴账户本年利息单位划入金额
                             rec_ac08a1_sk.aab160,   --应补缴账户跨年利息单位划入金额
                             rec_ac08a1_sk.aab161,   --应补缴统筹跨年利息金额
                             rec_ac08a1_sk.aab162,   --应缴滞纳金金额
                             0,--待转基金金额
                             var_aab019, --单位类型
                             var_aab020, --经济成分
                             var_aab021, --隶属关系
                             var_aab022, --单位行业
                             prm_aae011, --经办人
                             prm_aae036,   --经办时间
                             prm_yab139, --参保所属分中心
                             prm_yab003, --社保经办机构
                             prm_aaz002,
                             prm_aaz083,
                             prm_AppCode,         --执行代码
                             prm_ErrMsg );        --执行结果
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            prm_ErrMsg := prm_ErrMsg||'1';
         END IF;

         var_flag := '1';
      END LOOP;

      ----实缴负数补差退款，生成明细
      DELETE tmp_grbs02;
      INSERT INTO tmp_grbs02 SELECT * FROM tmp_grbc02 WHERE aae114 = pkg_comm.AAE114_YSJ AND yac004 < 0 ;
      var_yae518_tk := NULL;
      --生成个人明细
      FOR rec_aac001 IN cur_aac001 LOOP
         IF var_yae518_tk IS NULL THEN
            var_yae518_tk := pkg_comm.fun_GetSequence(NULL,'yae518');
         END IF ;
         var_aac001 := rec_aac001.aac001;
         prc_p_CreateDetail(prm_aaz002     ,
                            prm_aaz083     ,
                            var_yae518_tk  ,   --核定流水号
                            prm_aab001     ,   --单位编号
                            var_aac001     ,   --个人编号
                            prm_aae003     ,   --做帐期号
                            prm_yab139     ,   --所属参保分中心
                            prm_yab003     ,   --社保经办机构
                            prm_aae011     ,   --经办人
                            prm_aae036     ,   --经办时间
                            prm_AppCode    ,   --执行代码
                            prm_ErrMsg         --执行结果
                         );
         IF prm_AppCode <> pkg_COMM.gn_def_OK THEN
            GOTO label_ERROR ;
         END IF;


      END LOOP;

      --实缴负数补差生成一个ab08,并且进行征集
      FOR rec_ac08a1_tk IN  cur_ac08a1_tk LOOP
         /*生成核定汇总应收信息表*/
         pkg_p_checkEmployerFeeCo.prc_p_insertab08check(
                             var_yae518_tk, --核定流水号
                             prm_aab001, --单位编号
                             NULL      , --个人编号
                             rec_ac08a1_tk.aae140, --险种类型
                             prm_aae003, --做帐期号
                             rec_ac08a1_tk.aae041, --开始期号
                             rec_ac08a1_tk.aae042, --终止期号
                             rec_ac08a1_tk.yab538, --缴费人员状态
                             rec_ac08a1_tk.yae010,--费用来源
                             pkg_Comm.YAE517_H17, --核定类型
                             prm_yab222, --做帐批次号
                             rec_ac08a1_tk.yae231,   --人数
                             rec_ac08a1_tk.yae203,   --费用来源比例
                             rec_ac08a1_tk.aab120,   --个人缴费基数总额
                             rec_ac08a1_tk.aab121,   --单位缴费基数总额
                             rec_ac08a1_tk.aab150,   --应缴个人缴费划入账户金额
                             rec_ac08a1_tk.yab031,   --应缴个人缴费划入统筹金额
                             rec_ac08a1_tk.aab151,   --应缴单位缴费划入账户金额
                             rec_ac08a1_tk.aab152,   --应缴单位缴费划入统筹金额
                             rec_ac08a1_tk.aab157,   --应补缴个人缴费划入账户本年利息
                             rec_ac08a1_tk.aab158,   --应补缴个人缴费划入账户跨年利息
                             rec_ac08a1_tk.aab159,   --应补缴账户本年利息单位划入金额
                             rec_ac08a1_tk.aab160,   --应补缴账户跨年利息单位划入金额
                             rec_ac08a1_tk.aab161,   --应补缴统筹跨年利息金额
                             rec_ac08a1_tk.aab162,   --应缴滞纳金金额
                             CASE WHEN var_yae010 = pkg_Comm.YAE010_CZ THEN 0
                                  ELSE -(rec_ac08a1_tk.aab150+   --应缴个人缴费划入账户金额
                                         rec_ac08a1_tk.yab031+   --应缴个人缴费划入统筹金额
                                         rec_ac08a1_tk.aab151+   --应缴单位缴费划入账户金额
                                         rec_ac08a1_tk.aab152+   --应缴单位缴费划入统筹金额
                                         rec_ac08a1_tk.aab157+   --应补缴个人缴费划入账户本年利息
                                         rec_ac08a1_tk.aab158+   --应补缴个人缴费划入账户跨年利息
                                         rec_ac08a1_tk.aab159+   --应补缴账户本年利息单位划入金额
                                         rec_ac08a1_tk.aab160+   --应补缴账户跨年利息单位划入金额
                                         rec_ac08a1_tk.aab161+   --应补缴统筹跨年利息金额
                                         rec_ac08a1_tk.aab162 )  --应缴滞纳金金额
                                    END, --待转基金金额
                             var_aab019, --单位类型
                             var_aab020, --经济成分
                             var_aab021, --隶属关系
                             var_aab022, --单位行业
                             prm_aae011, --经办人
                             prm_aae036,   --经办时间
                             prm_yab139, --参保所属分中心
                             prm_yab003, --社保经办机构
                             prm_aaz002,
                             prm_aaz083,
                             prm_AppCode,         --执行代码
                             prm_ErrMsg );        --执行结果
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            prm_ErrMsg := prm_ErrMsg||'2';
            RETURN;
         END IF;

         var_flag := '1';
      END LOOP;
        --迁移ab08check.ac08a1check数据到ab08,ac08a1
      pkg_p_interrupt.prc_p_batchInterruptCheck(
                         prm_aaz002        ,
                         prm_aab001        ,  --单位编号
                         '0'    ,  --征集标志
                         null        ,  --征收方式    需要征集的时候才传
                         '1'         ,  --复核标志
                         prm_aae011        ,  --经办人
                         prm_aae036         ,  --经办时间
                         prm_yab003        ,  --社保经办机构
                         prm_Appcode        ,  --错误代码
                         prm_Errmsg         );   --错误内容

      IF var_flag = '0' THEN
         prm_AppCode := gs_FunNo||var_procNo||'10';
         prm_ErrMsg := '无有效的单位缴费补差数据，请核实！aae003:'||prm_aae003||'; aab001:'||prm_aab001;
         RETURN;
      END IF;

      /*生成tmp_yae518 为征集做准备*/
      DELETE tmp_yae518 ;
      --费用来源是财政 则所有数据都需要生成tmp_yae518
      IF var_yae010 = pkg_Comm.YAE010_CZ THEN
         NULL ;
      ELSE
         --费用来源是单位 只有退款部分需要生成，并且需要生成一个H26的信息
         --写入临时表
         INSERT INTO tmp_yae518
                   (yae518,   -- 核定流水号
                    aae140,   -- 险种类型
                    aab001,
                    yab538,
                    yae010,
                    aae041,
                    yab139)
             SELECT yae518,
                    aae140,
                    prm_aab001,
                    yab538, --缴费人员状态
                    YAE010, --费用来源
                    aae041,
                    prm_yab139
               FROM ab08
              WHERE yae518 = var_yae518_tk
                AND (aae076 IS NULL OR aae076 = '0')
                AND yae517 = pkg_Comm.YAE517_H17      --核定类型
                AND yae010 = var_yae010
                ;

         var_yad052 := pkg_comm.YAD052_TZ ;  --调账
         var_yad060 := pkg_comm.YAD060_P19;  --单位退款
      END IF;

      /*生成征集*/
      SELECT COUNT(1)
        INTO num_count
        FROM tmp_yae518;
      IF num_count > 0 THEN
         --申请计划流水号
         var_aae076 := pkg_comm.fun_GetSequence(NULL,'aae076');
         --调用征集过程。生成单据信息和财务接口数据
         pkg_p_fundCollection.prc_crtFinaPlan  (
                                  var_yad060    ,      --收付种类
                                  var_yad052    ,      --收付结算方式
                                  prm_aae011    ,      --经办人员
                                  prm_yab003    ,      --社保经办机构
                                  var_aae076    ,      --计划流水号
                                  prm_AppCode   ,      --执行代码
                                  prm_ErrMsg    );     --执行结果
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
         prm_ErrMsg  := '批量缴费补差出错，出错原因：'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END pkg_p_salaryExamineAdjust;

   /*****************************************************************************
   ** 过程名称 ：prc_p_CreateDetail
   ** 过程编号 : B01
   ** 业务环节 ：单位缴费补差
   ** 功能描述 ：数据校验
   ******************************************************************************
   ******************************************************************************
   ** 作    者：              作成日期 ：2009-12-29   版本编号 ：Ver 1.0.0
   ** 字    体: Courier New  字    号 ：10
   ** 修    改：
   ******************************************************************************
   ** 备    注：
   **
   *****************************************************************************/
   PROCEDURE prc_p_CreateDetail(
                          prm_aaz002      IN  VARCHAR2,
                          prm_aaz083      IN  VARCHAR2,
                          prm_yae518      IN   ac08.yae518%TYPE,   --核定流水号
                          prm_aab001      IN   ac08.aab001%TYPE,   --单位编号
                          prm_aac001      IN   ac08.aac001%TYPE,   --个人编号
                          prm_aae003      IN   ac08.aae003%TYPE,   --做帐期号
                          prm_yab139      IN   ab08.yab139%TYPE,   --所属参保分中心
                          prm_yab003      IN   ab08.yab003%TYPE,   --社保经办机构
                          prm_aae011      IN   ab08.aae011%TYPE,   --经办人
                          prm_aae036      IN   ab08.aae036%TYPE,   --经办时间
                          prm_AppCode     OUT  VARCHAR2,           --执行代码
                          prm_ErrMsg      OUT  VARCHAR2            --执行结果
                         )
   IS
      var_procNo             VARCHAR2(5);                --过程号
      num_count              NUMBER := 0;                --记录数

      var_aae140             ac08.aae140%TYPE;           --险种
      num_aae002             ac08.aae002%TYPE;           --费款所属期

      --差额补收数据
      CURSOR cur_aae140
      IS
          SELECT DISTINCT
                 aae140                            --险种类型
            FROM tmp_grbs02
           WHERE aae100 = pkg_comm.AAE100_YX       --有效标志：有效
             AND aac001 = prm_aac001               --个人编号
           GROUP BY aae140;                        --险种类型
   BEGIN
      --初始化变量
      prm_AppCode    := pkg_COMM.gn_def_OK ;
      prm_ErrMsg     := '' ;
      var_procNo     := 'B01';

      --生成明细
      FOR rec_aae140 IN cur_aae140 LOOP
         var_aae140 := rec_aae140.aae140;
         --调用补差过程
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
                                   prm_yae518  ,  --核定流水号
                                   prm_aab001  ,  --单位编号
                                   prm_aac001  ,  --个人编号
                                   prm_aae003  ,  --做帐期号
                                   var_aae140  ,  --险种类型
                                   prm_aae011  ,  --经办人
                                   prm_aae036  ,  --经办时间
                                   prm_yab003  ,  --经办机构
                                   prm_yab139  ,  --参保人员所在分钟心
                                   prm_Appcode ,  --错误代码
                                   prm_Errmsg  ); --错误内容
            IF prm_AppCode <> pkg_comm.gn_def_OK THEN
               RETURN;
            END IF;
         END IF;
      END LOOP;

   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'00';
         prm_ErrMsg  := '批量缴费补差出错，出错原因：'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END prc_p_CreateDetail;
   /*****************************************************************************
   ** 过程名称 ：prc_p_checkData
   ** 过程编号 : 02
   ** 业务环节 ：单位缴费补差
   ** 功能描述 ：数据校验
   ******************************************************************************
   ******************************************************************************
   ** 作    者：              作成日期 ：2009-12-29   版本编号 ：Ver 1.0.0
   ** 字    体: Courier New  字    号 ：10
   ** 修    改：
   ******************************************************************************
   ** 备    注：
   **
   *****************************************************************************/
   PROCEDURE  prc_p_checkData(
                              prm_aab001   IN   ab02.aab001%TYPE,   --单位编号
                              prm_bcfs     IN   VARCHAR2,           --补差方式（0 缴费比例补差， 1 缴费基数补差）
                              prm_yab139   IN   ac02.yab139%TYPE,   --参保所属分中心
                              prm_yab003   IN   ac02.yab003%TYPE,   --社保经办机构
                              prm_AppCode  OUT  VARCHAR2,           --执行代码
                              prm_ErrMsg   OUT  VARCHAR2            --执行结果
                             )
   IS
      var_procNo             VARCHAR2(5);                --过程号
      num_count              NUMBER := 0;                --记录数

      --定义游标，获取临时表数据
      CURSOR cur_tmp IS
      SELECT  aac001,   --个人编码
              aae041,   --开始期号
              aae042,   --终止期号
              aae140,   --险种
              yac503,   --工资类别
              aac040,   --缴费工资
              yaa333,   --帐户基数
              aae100,   --有效标志
              aae013    --备注
        FROM tmp_grbs01;
   BEGIN
      --初始化变量
      prm_AppCode    := pkg_COMM.gn_def_OK ;
      prm_ErrMsg     := '' ;
      var_procNo     := '02';

      --校验单位编号是否为空
      IF prm_aab001 IS NULL OR NVL(prm_aab001, '') = '' THEN
         prm_AppCode := gs_FunNo||var_procNo||'02';
         prm_ErrMsg  := '单位编号不能为空！';
         RETURN;
      END IF;

      --清空临时表数据
      DELETE FROM tmp_grbs02;

      --打开游标
      FOR rec_tmp IN cur_tmp LOOP
          num_count := num_count + 1;
          prc_p_checkTmp(rec_tmp.aac001,      --个人编号
                         prm_aab001,          --单位编号
                         rec_tmp.aae140,      --险种
                         rec_tmp.aae041,      --开始期号
                         rec_tmp.aae042,      --终止期号
                         rec_tmp.yac503,      --工资类别
                         rec_tmp.aac040,      --缴费工资
                         rec_tmp.yaa333,      --帐户基数
                         prm_bcfs,            --补差方式
                         prm_yab139,          --参保所属分中心
                         prm_yab003,          --社保经办机构
                         prm_AppCode,         --执行代码
                         prm_ErrMsg );        --执行结果
      END LOOP;

      IF num_count < 1 THEN
         prm_AppCode := gs_FunNo||var_procNo||'04';
         prm_ErrMsg  := '单位缴费补差临时表内无有效数据，请核实！';
         RETURN;
      END IF;

      --关闭游标
      IF cur_tmp%ISOPEN THEN
         CLOSE cur_tmp;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'01';
         prm_ErrMsg  := '数据效验,出错原因:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
      RETURN;
   END prc_p_checkData;

   /*****************************************************************************
   ** 过程名称 : prc_p_checkTmp
   ** 过程编号 : A01
   ** 业务环节 ：单位缴费补差
   ** 功能描述 ：校验临时表数据
   ******************************************************************************
   ** 作    者：              作成日期 ：2009-12-29   版本编号 ：Ver 1.0.0
   ** 字    体: Courier New  字    号 ：10
   ** 修    改：
   ******************************************************************************
   ** 备    注：
   **
   *****************************************************************************/
   PROCEDURE prc_p_checkTmp(prm_aac001      IN       ab08.aac001%TYPE,      --个人编号
                            prm_aab001      IN       ab08.aab001%TYPE,      --单位编号
                            prm_aae140      IN       ab08.aae140%TYPE,      --险种
                            prm_aae041      IN       ab08.aae041%TYPE,      --开始期号
                            prm_aae042      IN       ab08.aae042%TYPE,      --终止期号
                            prm_yac503      IN       ac08.yac503%TYPE,      --工资类别
                            prm_aac040      IN       ac08.aac040%TYPE,      --缴费工资
                            prm_yaa333      IN       ac08.yaa333%TYPE,      --帐户基数
                            prm_bcfs        IN       VARCHAR2,              --补差方式
                            prm_yab003      IN       ab08.yab003%TYPE,      --社保经办机构
                            prm_yab139      IN       ab08.yab139%TYPE,      --参保所属分中心
                            prm_AppCode     OUT      VARCHAR2        ,      --执行代码
                            prm_ErrMsg      OUT      VARCHAR2 )
   IS
      var_procNo            VARCHAR2(5);      --过程号
      var_yaa310            ac08.yaa310%type;      --比例类型
      var_yaa330            ac08.yaa310%type;      --缴费比例模式
      var_yab136            ab01.yab136%type;      --单位管理类型
      num_count             NUMBER := 0;      --记录数
      num_aae041            NUMBER;           --开始期号
      num_aae042            NUMBER;           --终止期号
      num_yac004            NUMBER := 0;      --缴费基数
      num_yac004_new        NUMBER := 0;        --缴费基数（新）
      num_aaa041            NUMBER := 0;      --个人缴费比例
      num_yaa017            NUMBER := 0;      --个人划统筹比例
      num_aaa042            NUMBER := 0;      --单位缴费比例
      num_aaa043            NUMBER := 0;      --单位缴费划帐
      num_ala080            NUMBER;           --工伤浮动费率
      num_age               NUMBER;           --年龄
      num_yac176            NUMBER;           --工龄
      num_aac040_bd         NUMBER := 0;
      var_yac168            ac08.yac168%type;             --农民工标志
      var_yac503            ac08.yac503%type;             --工资类别
      var_yac505            ac08.yac505%type;             --
      var_aac008            ac08.aac008%type;
      var_aaa040           ac08.aaa040%type;
      var_ykc120            ac08.ykc120%type;             --医疗照顾人员类别
      var_akc021            ac08.akc021%type;             --医疗人员类别
      num_yaa333            NUMBER;
      var_yae010            aa05.yae010%TYPE;
      var_aae143            ac08.aae143%TYPE;
      var_aae114            ac08.aae114%TYPE;        --缴费标志

   BEGIN
      --初始化变量
      prm_AppCode    := pkg_COMM.gn_def_OK ;
      prm_ErrMsg     := '' ;
      var_procNo     := 'A01';

      num_aae041 := prm_aae041;
      num_aae042 := prm_aae042;
      num_count  := 0;


      --校验单位相应险种参保状态是否为终止缴费状态
      SELECT COUNT(1)
        INTO num_count
        FROM ab02
       WHERE aab001 = prm_aab001
         AND aae140 = prm_aae140
         AND aab051 <> pkg_comm.AAB051_ZZJF
         AND yab139 = prm_yab139;

      IF num_count = 0 THEN
         prm_AppCode := gs_FunNo||var_procNo||'01';
         prm_ErrMsg  := '单位编号['||prm_aab001||']险种['||pkg_COMM.fun_getAaa103('aae140',prm_aae140)||'参保状态为终止缴费状态，不能进行缴费补差';
      END IF;

      --校验个人相对应险种参保状态是否为终止缴费状态
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
         prm_ErrMsg  := '个人编号['||prm_aac001||']险种['||pkg_COMM.fun_getAaa103('aae140',prm_aae140)||'单位编号['||prm_aab001||']参保状态为终止缴费状态，不能进行缴费补差';
      END IF;

      --获取单位基本信息
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

         prc_p_checkYSJ( prm_aac001     ,      --个人编号
                         prm_aab001     ,      --单位编号
                         num_aae041     ,      --费款所属期
                         prm_aae140     ,      --险种
                         prm_bcfs       ,      --补差方式
                         prm_yab139     ,      --参保所属分中心
                         prm_yab003     ,      --社保经办机构
                         var_yab136     ,      --单位管理类型
                         num_aac040_bd  ,      --新的缴费工资       prm_aac040     IN OUT ac02.aac040%TYPE,      --新的缴费工资
                         var_yac503     ,      --工资类别           prm_yac503     IN OUT ac02.yac503%TYPE,      --工资类别
                         num_yaa333     ,      --账户基数           prm_YAA333     IN OUT ac02.YAA333%TYPE,      --账户基数
                         num_yac004     ,      --缴费基数           prm_yac004     OUT    ac02.yac004%TYPE,      --缴费基数
                         num_aaa041     ,      --个人缴费比例       prm_aaa041     OUT    aa05.aaa041%TYPE,      --个人缴费比例
                         num_yaa017     ,      --个人划统筹比       prm_yaa017     OUT    aa05.yaa017%TYPE,      --个人划统筹比
                         num_aaa042     ,      --单位缴费比例       prm_aaa042     OUT    aa05.aaa042%TYPE,      --单位缴费比例
                         num_aaa043     ,      --单位缴费划帐       prm_aaa043     OUT    aa05.aaa043%TYPE,      --单位缴费划帐
                         num_ala080     ,      --工伤浮动费率       prm_ala080     OUT    ac08.ala080%TYPE,      --工伤浮动费率
                         var_yac168     ,      --农民工标志         prm_yac168_old OUT    ac01.yac168%TYPE,      --农民工标志
                         var_yac505     ,      --参保缴费人员类别   prm_yac505_old OUT    ac02.yac505%TYPE,      --
                         var_aac008     ,      --人员状态           prm_aac008_old OUT    ac01.aac008%TYPE,      --
                         var_aaa040     ,      --缴费比例类别       prm_aaa040_old OUT    aa05.aaa040%TYPE,
                         var_ykc120     ,      --医疗照顾人员类别   prm_ykc120_old OUT    ac08.ykc120%TYPE,      --医疗照顾人员类别
                         var_akc021     ,      --医疗人员类别       prm_akc021_old OUT    ac08.akc021%TYPE,      --医疗人员类别
                         var_aae114     ,      --缴费标志           prm_aae114_old OUT    ac08.aae114%TYPE,      --缴费标志
                         num_age        ,      --年龄               prm_age        OUT    ac08.akc023%TYPE,      --年龄
                         num_yac176     ,      --工龄               prm_yac176     OUT    ac08.yac176%TYPE,      --工龄
                         var_yaa310     ,      --比例类型           prm_yaa310     OUT    ac08.yaa310%TYPE,      --比例类型
                         var_yae010     ,      --费用来源           prm_yae010     OUT    ac08.yae010%TYPE,      --费用来源
                         var_yaa330     ,      --缴费比例模式       prm_yaa330     OUT    ac08.yaa330%TYPE,      --缴费比例模式
                         prm_AppCode    ,      --执行代码
                         prm_ErrMsg    )       --错误信息
                         ;
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            --有异常抛出，将有效标志置为无效
            INSERT INTO tmp_grbs02(
                                    aac001,  --个人编码
                                    aae002,  --费款所属期号
                                    yac505,  --个人缴费类别
                                    aaa040,  --缴费比例类别
                                    aae140,  --险种
                                    aae143,  --缴费类别
                                    yac503,  --工资类型
                                    aac040,  --缴费工资
                                    yac004,  --个人缴费基数
                                    yaa333,  --划帐户基数
                                    yae010,  --费用来源
                                    yaa330,  --缴费比例模式
                                    aaa041,  --个人缴费比例
                                    yaa017,  --个人缴费划入统筹比例
                                    aaa042,  --单位缴费比例
                                    aaa043,  --单位缴费划入帐户比例
                                    ala080,  --工伤浮动费率
                                    akc023,  --实足年龄
                                    yac176,  --工龄
                                    akc021,  --医疗人员类别
                                    ykc120,  --医疗照顾人员类别
                                    aac008,  --人员状态
                                    yac168,  --农民工标志
                                    yaa310,  --比例类别
                                    aae114,  --缴费标志
                                    aae100,  --有效标志
                                    aae013)  --备注
                               VALUES
                               ( prm_aac001,           --个人编号
                                 num_aae041,           --费款所属期号
                                 var_yac505,           --参保缴费人员类别
                                 var_aaa040,           --缴费比例类别
                                 prm_aae140,           --险种类型
                                 var_aae143,           --缴费类别
                                 var_yac503,           --工资类型
                                 num_aac040_bd,        --缴费工资
                                 num_yac004,           --缴费基数
                                 num_yaa333,           --划帐户基数
                                 var_yae010     ,      --费用来源
                                 var_yaa330     ,      --缴费比例模式
                                 num_aaa041,           --个人缴费比例
                                 num_yaa017,           --个人划统筹比例
                                 num_aaa042,           --单位缴费比例
                                 num_aaa043,           --单位划帐户比例
                                 num_ala080,           --工伤浮动费率
                                 num_age,              --年龄
                                 num_yac176,           --工龄
                                 var_akc021,           --医疗保险人员状态
                                 var_ykc120,           --医疗照顾人员类别
                                 var_aac008,           --人员状态
                                 var_yac168,           --农民工标志
                                 var_yaa310,           --比例类型
                                 var_aae114,           --缴费标志
                                 pkg_comm.AAE100_WX,  --有效标志 ：无效
                                 prm_ErrMsg );
            --将错误信息置空
            prm_AppCode    := pkg_COMM.gn_def_OK ;
            prm_ErrMsg     := '' ;
         ELSE
            --无异常抛出，将有效标志置为有效
           INSERT INTO tmp_grbs02(
                                    aac001,  --个人编码
                                    aae002,  --费款所属期号
                                    yac505,  --个人缴费类别
                                    aaa040,  --缴费比例类别
                                    aae140,  --险种
                                    aae143,  --缴费类别
                                    yac503,  --工资类型
                                    aac040,  --缴费工资
                                    yac004,  --个人缴费基数
                                    yaa333,  --划帐户基数
                                    yae010,  --费用来源
                                    yaa330,  --缴费比例模式
                                    aaa041,  --个人缴费比例
                                    yaa017,  --个人缴费划入统筹比例
                                    aaa042,  --单位缴费比例
                                    aaa043,  --单位缴费划入帐户比例
                                    ala080,  --工伤浮动费率
                                    akc023,  --实足年龄
                                    yac176,  --工龄
                                    akc021,  --医疗人员类别
                                    ykc120,  --医疗照顾人员类别
                                    aac008,  --人员状态
                                    yac168,  --农民工标志
                                    yaa310,  --比例类别
                                    aae114,  --缴费标志
                                    aae100,  --有效标志
                                    aae013)  --备注
                               VALUES
                               ( prm_aac001,           --个人编号
                                 num_aae041,
                                 var_yac505,           --参保缴费人员类别
                                 var_aaa040,           --缴费比例类别
                                 prm_aae140,           --险种类型
                                 var_aae143,           --缴费类别
                                 var_yac503,           --工资类型
                                 num_aac040_bd,        --缴费工资
                                 num_yac004,           --缴费基数
                                 num_yaa333,           --划帐户基数
                                 var_yae010     ,      --费用来源
                                 var_yaa330     ,      --缴费比例模式
                                 num_aaa041,           --个人缴费比例
                                 num_yaa017,           --个人划统筹比例
                                 num_aaa042,           --单位缴费比例
                                 num_aaa043,           --单位划帐户比例
                                 num_ala080,           --工伤浮动费率
                                 num_age,              --年龄
                                 num_yac176,           --工龄
                                 var_akc021,           --医疗保险人员状态
                                 var_ykc120,           --医疗照顾人员类别
                                 var_aac008,           --人员状态
                                 var_yac168,           --农民工标志
                                 var_yaa310,           --比例类型
                                 var_aae114,           --缴费标志
                                 pkg_comm.AAE100_YX,   --有效标志 ：有效
                                 prm_ErrMsg );
         END IF;
         --开始期号加1进行循环
         num_aae041 := to_number(to_char(ADD_MONTHS(TO_DATE(num_aae041,'yyyymm'),1),'yyyymm')) ;
      END LOOP;
   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'01';
         prm_ErrMsg  := '数据效验,出错原因:'||num_yac004_new||',,'||num_yac004||'..'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
      RETURN;
   END prc_p_checkTmp;

   /*****************************************************************************
   ** 过程名称 : prc_p_checkYSJ
   ** 过程编号 : A02
   ** 业务环节 ：单位缴费补差
   ** 功能描述 ：校验对应期号对应险种的应实缴信息
   ******************************************************************************
   ** 作    者：              作成日期 ：2009-12-29   版本编号 ：Ver 1.0.0
   ** 字    体: Courier New  字    号 ：10
   ** 修    改：
   ******************************************************************************
   ** 备    注：
   **
   *****************************************************************************/
   PROCEDURE prc_p_checkYSJ(prm_aac001     IN     ac02.aac001%TYPE,      --个人编号
                            prm_aab001     IN     ac02.aab001%TYPE,      --单位编号
                            prm_aae002     IN     ac08.aae002%TYPE,      --费款所属期
                            prm_aae140     IN     ac02.aae140%TYPE,      --险种
                            prm_bcfs       IN     VARCHAR2,              --补差方式
                            prm_yab139     IN     ac02.yab139%TYPE,      --参保所属分中心
                            prm_yab003     IN     ac02.yab003%TYPE,      --社保经办机构
                            prm_yab136     IN     ab01.yab136%TYPE,      --单位管理类型
                            prm_aac040     IN OUT ac02.aac040%TYPE,      --新的缴费工资
                            prm_yac503     IN OUT ac02.yac503%TYPE,      --工资类别
                            prm_YAA333     IN OUT ac02.YAA333%TYPE,      --账户基数
                            prm_yac004     OUT    ac02.yac004%TYPE,      --缴费基数
                            prm_aaa041     OUT    aa05.aaa041%TYPE,      --个人缴费比例
                            prm_yaa017     OUT    aa05.yaa017%TYPE,      --个人划统筹比
                            prm_aaa042     OUT    aa05.aaa042%TYPE,      --单位缴费比例
                            prm_aaa043     OUT    aa05.aaa043%TYPE,      --单位缴费划帐
                            prm_ala080     OUT    ac08.ala080%TYPE,      --工伤浮动费率
                            prm_yac168_old OUT    ac01.yac168%TYPE,      --农民工标志
                            prm_yac505_old OUT    ac02.yac505%TYPE,      --
                            prm_aac008_old OUT    ac01.aac008%TYPE,      --
                            prm_aaa040_old OUT    aa05.aaa040%TYPE,
                            prm_ykc120_old OUT    ac08.ykc120%TYPE,      --医疗照顾人员类别
                            prm_akc021_old OUT    ac08.akc021%TYPE,      --医疗人员类别
                            prm_aae114_old OUT    ac08.aae114%TYPE,      --缴费标志
                            prm_age        OUT    ac08.akc023%TYPE,      --年龄
                            prm_yac176     OUT    ac08.yac176%TYPE,      --工龄
                            prm_yaa310     OUT    ac08.yaa310%TYPE,      --比例类型
                            prm_yae010     OUT    ac08.yae010%TYPE,      --费用来源
                            prm_yaa330     OUT    ac08.yaa330%TYPE,      --缴费比例模式
                            prm_AppCode    OUT    VARCHAR2,              --执行代码
                            prm_ErrMsg     OUT    VARCHAR2)              --错误信息
   IS
      var_procNo            VARCHAR2(5);             --过程号
      num_yac004_old        NUMBER;
      num_YAA333_old        NUMBER;
      num_aaa041_old        NUMBER;                  --个人缴费比例
      num_aaa042_old        NUMBER;                  --单位缴费比例
      num_yaa017_old        NUMBER;                  --个人缴费划统筹比例
      num_aaa043_old        NUMBER;                  --单位缴费划账户比例
      var_yac503            ac02.yac503%TYPE;
      num_aac040            NUMBER;
      num_yaa028            NUMBER;
      num_count             NUMBER;
      num_ala080_old        NUMBER;
      num_aae003            NUMBER;

      var_aae119            ab01.aae119%TYPE;
      var_akc021            kc01.akc021%TYPE;
      var_aac008            ac01.aac008%TYPE;

      --检查对应月份在年审前，是否老系统进行了退休操作。
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
      /*初化变量*/
      prm_AppCode    := pkg_COMM.gn_def_OK ;
      prm_ErrMsg     := ''                  ;
      var_procNo     := 'A02';
      prm_aac040_new := prm_aac040;
      num_aae003  := TO_NUMBER(TO_CHAR(SYSDATE,'yyyymm'));

      --检查是否存在应缴的补差数据
      SELECT COUNT(yae202)
        INTO num_count
        FROM ac08a1
       WHERE aab001 = prm_aab001
         AND aac001 = prm_aac001
         AND aae140 = prm_aae140
         AND aae002 = prm_aae002
         AND aae143 IN (pkg_comm.AAE143_JSBC,        -- 基数补差
                        pkg_comm.AAE143_BLBC);       -- 比例补差
      IF num_count > 0 THEN
         prm_AppCode := gs_FunNo||var_procNo||'01';
         prm_ErrMsg  := '单位:'||prm_aab001||
                        ';人员:'||prm_aac001||
                        ';险种:'||pkg_COMM.fun_getAaa103('aae140',prm_aae140)||
                        ';期号:'||prm_aae002||
                        '存在未缴费的差额补收信息，请先撤销之前补差信息，再进行本次补差操作！';
         RETURN;
      END IF ;
      --获取单位参保状态
      /*
      破产单位的退休人员只能对退休缴费部分进行补差
      */
      SELECT aae119
        INTO var_aae119
        FROM ab01
       WHERE aab001 = prm_aab001;
      --获取人员状态
      SELECT aac008
        INTO var_aac008
        FROM ac01
       WHERE aac001 = prm_aac001;
      --获取应缴实缴信息
      IF prm_aae140 IN(  pkg_comm.AAE140_SYE ,
                         pkg_comm.AAE140_JBYL,
                         pkg_comm.AAE140_GS  ,
                         pkg_comm.AAE140_SYU ,
                         pkg_comm.AAE140_GWYBZ)
      THEN
         --获取相对应期应实缴信息
         BEGIN
            SELECT NVL(SUM(CASE WHEN aae143 IN(pkg_comm.AAE143_ZCJF,  --正常缴费
                                               pkg_comm.AAE143_ZYJF,  --退休逐月缴费
                                               pkg_comm.AAE143_BJ  ,  --补缴
                                               pkg_comm.AAE143_BS  ,  --补收
                                               pkg_comm.AAE143_JSBC,  --基数补差
                                               pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                               pkg_comm.AAE143_DLJF)  --独立人员缴费                                               pkg_co

                                THEN aae180
                                ELSE 0
                                END),0),  --缴费基数
                   NVL(SUM(CASE WHEN aae143 IN(pkg_comm.AAE143_ZCJF, --正常缴费
                                               pkg_comm.AAE143_ZYJF,  --退休逐月缴费
                                               pkg_comm.AAE143_BJ  , --补缴
                                               pkg_comm.AAE143_BS  , --补收
                                               pkg_comm.AAE143_JSBC, --基数补差
                                               pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                               pkg_comm.AAE143_DLJF) --独立人员缴费
                                THEN YAA333
                                ELSE 0
                                END),0),  --划帐户基数
                   NVL(SUM(CASE WHEN aae143 IN(pkg_comm.AAE143_ZCJF, --正常缴费
                                               pkg_comm.AAE143_ZYJF,  --退休逐月缴费
                                               pkg_comm.AAE143_BJ  , --补缴
                                               pkg_comm.AAE143_BS  , --补收
                                               pkg_comm.AAE143_BLBC, --比例补差
                                               pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                               pkg_comm.AAE143_DLJF) --独立人员缴费
                                THEN aaa041
                                ELSE 0
                                END),0),  --个人缴费比例
                   NVL(SUM(CASE WHEN aae143 IN(pkg_comm.AAE143_ZCJF, --正常缴费
                                               pkg_comm.AAE143_ZYJF,  --退休逐月缴费
                                               pkg_comm.AAE143_BJ  , --补缴
                                               pkg_comm.AAE143_BS  , --补收
                                               pkg_comm.AAE143_BLBC, --比例补差
                                               pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                               pkg_comm.AAE143_DLJF) --独立人员缴费
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
                                END),0),  --单位缴费比例
                   NVL(SUM(CASE WHEN aae143 IN(pkg_comm.AAE143_ZCJF, --正常缴费
                                               pkg_comm.AAE143_ZYJF,  --退休逐月缴费
                                               pkg_comm.AAE143_BJ  , --补缴
                                               pkg_comm.AAE143_BS  , --补收
                                               pkg_comm.AAE143_BLBC, --比例补差
                                               pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                               pkg_comm.AAE143_DLJF) --独立人员缴费
                                THEN yaa017
                                ELSE 0
                                END),0),  --个人缴费划统筹比例
                   NVL(SUM(CASE WHEN aae143 IN(pkg_comm.AAE143_ZCJF, --正常缴费
                                               pkg_comm.AAE143_ZYJF,  --退休逐月缴费
                                               pkg_comm.AAE143_BJ  , --补缴
                                               pkg_comm.AAE143_BS  , --补收
                                               pkg_comm.AAE143_BLBC, --比例补差
                                               pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                               pkg_comm.AAE143_DLJF) --独立人员缴费
                                THEN aaa043
                                ELSE 0
                                END),0),   --单位缴费划帐户比例
                  NVL(SUM(CASE WHEN aae143 IN(pkg_comm.AAE143_ZCJF, --正常缴费
                                               pkg_comm.AAE143_ZYJF,  --退休逐月缴费
                                               pkg_comm.AAE143_BJ  , --补缴
                                               pkg_comm.AAE143_BS  , --补收
                                               pkg_comm.AAE143_BLBC, --比例补差
                                               pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                               pkg_comm.AAE143_DLJF) --独立人员缴费
                                THEN ala080
                                ELSE 0
                                END),0)

              INTO num_yac004_old,                  --缴费基数
                   num_YAA333_old,                  --划账户比例
                   num_aaa041_old,                  --个人缴费比例
                   num_aaa042_old,                  --单位缴费比例
                   num_yaa017_old,                  --个人缴费划统筹比例
                   num_aaa043_old,                  --单位缴费划账户比例
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
                       AND aae143 IN(pkg_comm.AAE143_ZCJF, --正常缴费
                                     pkg_comm.AAE143_ZYJF,  --退休逐月缴费
                                     pkg_comm.AAE143_JSBC, --基数补差
                                     pkg_comm.AAE143_BJ  , --补缴
                                     pkg_comm.AAE143_BS  , --补收
                                     pkg_comm.AAE143_DLJF, --独立人员缴费
                                     pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                     pkg_comm.AAE143_BLBC) --比例补差
                       AND yaa330 = pkg_comm.YAA330_BL  --比例模式
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
                       AND aae143 IN(pkg_comm.AAE143_ZCJF, --正常缴费
                                     pkg_comm.AAE143_ZYJF,  --退休逐月缴费
                                     pkg_comm.AAE143_JSBC, --基数补差
                                     pkg_comm.AAE143_BJ  , --补缴
                                     pkg_comm.AAE143_BS  , --补收
                                     pkg_comm.AAE143_DLJF, --独立人员缴费
                                     pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                     pkg_comm.AAE143_BLBC) --比例补差
                       AND yaa330 = pkg_comm.YAA330_BL  --比例模式
                     )
                     ;
            EXCEPTION
               WHEN OTHERS THEN
                  prm_AppCode := gs_FunNo||var_procNo||'01';
                  prm_ErrMsg  := '没有获取险种类型为'||pkg_COMM.fun_getAaa103('aae140',prm_aae140)||'的缴费信息'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
               RETURN;
         END;



         BEGIN
            --获取ac08非补差缴费的缴费工资类别和费用来源等
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
                   prm_yac168_old,                  --农民工标志
                   prm_yac505_old,                  --参保缴费人员类别
                   prm_aaa040_old,                  --比例类别
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
                                     pkg_comm.AAE143_ZYJF,  --退休逐月缴费
                                     pkg_comm.AAE143_BJ,
                                     pkg_comm.AAE143_BS,
                                     pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                     pkg_comm.AAE143_DLJF)
                       AND yaa330 = pkg_comm.YAA330_BL  --比例模式
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
                                     pkg_comm.AAE143_ZYJF,  --退休逐月缴费
                                     pkg_comm.AAE143_BJ,
                                     pkg_comm.AAE143_BS,
                                     pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                     pkg_comm.AAE143_DLJF)
                       AND yaa330 = pkg_comm.YAA330_BL  --比例模式
                       )
                       ;
            --2010-10-04
            --老系统201009之前的欠费,aac008为退休，但是akc021为在职(新老系统数据结转时只能这样处理)。
            --所以在补差的时候，201009前的数据 aac008为退休akc021为在职，则将akc021转为退休来处理。
            IF prm_aae002 <= 201009 THEN
               IF prm_aac008_old = pkg_comm.AAC008_TX AND prm_akc021_old = pkg_comm.AKC021_ZZ THEN
                  prm_akc021_old := pkg_comm.AKC021_TX;
               END IF ;
            END IF ;
         EXCEPTION
            WHEN OTHERS THEN
               prm_AppCode := gs_FunNo||var_procNo||'02';
               prm_ErrMsg  := '没有获取险种类型为'||pkg_COMM.fun_getAaa103('aae140',prm_aae140)||'的缴费信息'||prm_aae002;
            RETURN;
         END;
         --如果获取旧的缴费比例和大于1 则提示不能进行缴费补差操作
         IF prm_aaa041 + prm_aaa042 + prm_yaa017 + prm_aaa043 > 1 THEN
            prm_AppCode := gs_FunNo||var_procNo||'02';
            prm_ErrMsg  := '缴费比例和大于1，无法进行缴费补差操作';
            RETURN;
         END IF;
      END IF;

      IF prm_bcfs = '0' THEN --比例补差
         --获取缴费比例
         pkg_P_Comm_CZ.prc_P_getPaymentProportion(
                                                     prm_aac001,       --个人编号(主要针对医疗的划入帐户比例,其它险种不需要传入)
                                                     prm_aab001,       --单位编号
                                                     prm_Yab139,       --参保所属分中心
                                                     prm_aae140,       --险种
                                                     prm_akc021_old,   --医疗人员类别
                                                     prm_ykc120_old,   --医疗照顾人员类别
                                                     prm_aae002,       --开始期号
                                                     prm_aaa040_old,   --比例类别代码
                                                     prm_aaa041,       --个人缴费比例
                                                     prm_yaa017,       --个人缴费划统筹比例
                                                     prm_aaa042,       --单位缴费比例
                                                     prm_aaa043,       --单位缴费划账户比例
                                                     num_yaa028,       --划入帐户比例
                                                     prm_ala080,       --工伤浮动费率
                                                     prm_age   ,       --年龄
                                                     prm_yac176,       --工龄
                                                     prm_yaa310,       --比例类型
                                                     prm_yaa330,       --缴费比例模式
                                                     prm_yae010,       --费用来源
                                                     prm_AppCode,      --执行代码
                                                     prm_ErrMsg)
                                                     ;
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            RETURN;
         END IF;
         --比例补差用ac08里面的基数
         prm_yac503 := var_yac503;
         prm_aac040 := num_aac040;
         prm_yaa333 := num_yaa333_old;
         prm_yac004 := num_yac004_old;
         prm_aaa041 := prm_aaa041 - num_aaa041_old;                  --个人缴费比例
         prm_yaa017 := prm_yaa017 - num_yaa017_old;                  --单位缴费比例
         prm_aaa042 := prm_aaa042 - num_aaa042_old;                  --个人缴费划统筹比例
         prm_aaa043 := prm_aaa043 - num_aaa043_old;                  --单位缴费划账户比例

      END IF;
      IF prm_bcfs = '1' THEN --基数补差
         --原有工资为在职缴费类别，新工资为退休录入养老金。
         IF var_yac503 <> prm_yac503 AND prm_yac503 = pkg_comm.YAC503_LRYLJ THEN
            prm_AppCode := gs_FunNo||var_procNo||'02';
            prm_ErrMsg  := '原有工资类别和补差的工资类别不同，不能进行补差。';
            RETURN;
         END IF ;
         --对缴费工资进行保底封顶
         --破产单位的在职人员不进行工资变更
         IF var_aae119 = pkg_comm.AAE119_PC AND var_aac008 = pkg_comm.AAC008_ZZ THEN
            prm_aac040 := num_yac004_old ;     -- 申报工资
            prm_yac004 := num_yac004_old ;     -- 缴费基数
            prm_yaa333 := num_yaa333_old ;     -- 帐户基数
         ELSE
            pkg_P_Comm_CZ.prc_P_getContributionBase(
                                                   prm_aac001,             --个人编号
                                                   prm_aab001,
                                                   prm_aac040,             --缴费工资
                                                   prm_yac503,             --工资类别
                                                   prm_aae140,             --险种类型
                                                   prm_yac505_old,         --缴费人员类别
                                                   prm_yab136,             --单位管理类型
                                                   prm_aae002,             --费款所属期/*都用系统期号*//*20100928 参保科提出 所有录入工资的补收都按当前社平工资补差*/
                                                   prm_yab139,             --参保所属分中心
                                                   prm_yac004,             --缴费基数
                                                   prm_AppCode,            --执行代码
                                                   prm_ErrMsg);            --执行结果

            IF prm_AppCode <> pkg_comm.gn_def_OK THEN
               RETURN;
            END IF;
         END IF ;
         --保存基数差额部分
         prm_yac004 := prm_yac004 - num_yac004_old;
         prm_aac040 := prm_yac004;

         IF prm_aae140 IN (pkg_comm.aae140_JBYL,     --基本医疗
                           pkg_comm.AAE140_GWYBZ)    --公务员补助
         THEN
            IF prm_yaa333 IS NULL OR prm_yaa333 = 0 THEN
               prm_yaa333 := prm_yac004;
            ELSE
               prm_yaa333 := prm_yaa333 - num_yaa333_old;
            END IF;
         ELSE
            prm_yaa333 := 0;
         END IF;

         prm_aaa041 := num_aaa041_old;                  --个人缴费比例
         prm_yaa017 := num_yaa017_old;                  --单位缴费比例
         prm_aaa042 := num_aaa042_old;                  --个人缴费划统筹比例
         prm_aaa043 := num_aaa043_old;                  --单位缴费划账户比例
         prm_ala080 := num_ala080_old;

         --modify by fenggg at 20181202 begin
         --2019年以前，高新四险基数降低不退费,所以负补差基数处理成0 ，2019及以后退费 
         IF prm_yab139 = '610127' and substr(prm_aae002,1,4) < 2019 and prm_yac004 < 0 then
            prm_yac004 := 0;
         END IF;
         --modify by fenggg at 20181202 end

         --基数没变化。
         IF prm_yac004 = 0 THEN
            prm_AppCode := gs_FunNo||var_procNo||'02';
            prm_ErrMsg  := '基数没有发生变化，不用补差';
            RETURN;
         END IF;

         /** 参保科 3楼大厅 张文集 ， 尹晓莉 ，刘华升
             尹晓莉 提出 取消该限制，张文集同意，刘华升参与
             2010-11-22  修改
         --基本医疗缴费基数申报高了，进行退款操作
         IF prm_aae140 = pkg_comm.aae140_JBYL THEN
            IF prm_akc021_old <> pkg_comm.akc021_ZZ THEN
               IF prm_yac004 < 0 THEN
                  prm_AppCode := gs_FunNo||var_procNo||'02';
                  prm_ErrMsg  := '基本医疗退休人员只针对在职缴费基数申报低了进行处理';
                  RETURN;
               END IF;
            END IF;
         END IF;
         */

         --公务员补助只针对缴费基数申报低了
         IF prm_aae140 = pkg_comm.aae140_GWYBZ THEN
            IF prm_yaa333 <= 0 THEN
               prm_AppCode := gs_FunNo||var_procNo||'02';
               prm_ErrMsg  := '公务员补助只针对缴费基数申报低了进行处理';
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
            --人员当前为退休，但是缴费记录为在职，则不允许进行补差
            IF var_akc021 = pkg_comm.AKC021_TX AND prm_akc021_old = pkg_comm.AKC021_ZZ THEN
               prm_AppCode := gs_FunNo||var_procNo||'03';
               prm_ErrMsg  := '破产单位的退休人员，只能对退休部分进行补差';
               RETURN;
            END IF ;
         END IF ;
      END IF ;

      --检查对应月份在年审前，是否老系统进行了退休操作。
      IF prm_bcfs = '1' THEN --基数补差
         num_i := 0;
         var_flag := 0;
         FOR rec_ac08 IN cur_ac08 LOOP
            num_i := num_i + 1;
            IF rec_ac08.yac234 = -1 THEN
               var_flag := 1;
               num_aae180 := rec_ac08.aae180;
            END IF;
         END LOOP;
         --存在老系统退休补差数据 并且人员还为进行过基数补差操作。
         IF var_flag = 1 AND num_i = 1 THEN
            SELECT akc021
              INTO var_akc021
              FROM kc01
             WHERE aac001 = prm_aac001 ;
            --人员不为在退休人员则报错
            IF var_akc021 <> pkg_comm.AKC021_TX  THEN
               --报错
               prm_AppCode := gs_FunNo||var_procNo||'03';
               prm_ErrMsg  := '人员在老系统办理过在职转退休，并在老系统中产生了补差信息。当前人员状态不为退休，新系统不支持该类人员本期进行补差';
               RETURN;
            ELSE
               prm_yac004 := prm_aac040_new - num_aae180;                  --缴费基数
               IF prm_yac004 = 0 THEN
                  prm_AppCode := gs_FunNo||var_procNo||'03';
                  prm_ErrMsg  := '工资没有发生变化,不需要补差!';
                  RETURN;
               END IF ;
               prm_aac040 := prm_yac004;
               prm_yaa333 := prm_yac004;

               prm_aaa041 := 0;                  --个人缴费比例
               prm_yaa017 := 0;                  --单位缴费比例
               prm_aaa042 := 0;                  --个人缴费划统筹比例
               prm_aaa043 := 0.05;               --单位缴费划账户比例

               prm_akc021_old := pkg_comm.AKC021_TX;
            END IF ;
         ELSIF var_flag = 1 AND num_i > 1 THEN
            --报错
            prm_AppCode := gs_FunNo||var_procNo||'03';
            prm_ErrMsg  := '人员在老系统办理过在职转退休，并在老系统中产生了补差信息。新系统不支持该类人员本期进行多次补差';
            RETURN;
         ELSE
            NULL;
         END IF;
      END IF ;
   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'16';
         prm_ErrMsg  := '获取应实缴信息出错:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END prc_p_checkYSJ;

   /*****************************************************************************
   ** 过程名称 pkg_p_salaryExamineAdjust_ns  (add by fenggg at 20190709)
   ** 过程编号 : 03
   ** 业务环节 ：年审专用补差
   ** 功能描述 ：根据每期基数或比例的不同产生不同的差额，批量对单位进行补差
   ******************************************************************************
   ** 作    者：            作成日期 ：2019-07-09   版本编号 ：Ver 1.0.0
   ** 字    体: Courier New  字    号 ：10
   ** 修    改：
   ******************************************************************************
   ** 备    注：
   **
   *****************************************************************************/
   PROCEDURE pkg_p_salaryExamineAdjust_ns(
                                     prm_aaz002      IN  VARCHAR2,
                                     prm_aaz083      IN  VARCHAR2,
                                     prm_aab001      IN   ab02.aab001%TYPE, --单位编号
                                     prm_aae003      IN   ac08.aae003%TYPE, --做帐期号
                                     prm_aae001      IN   ab05.aae001%TYPE, --年审年份
                                     prm_bcfs        IN   NUMBER          , --补差方式(0 缴费比例补差， 1 缴费基数补差）
                                     prm_collectflag IN   NUMBER          , --征集标志(0:否;1:是
                                     prm_tkfs        IN   NUMBER          , --退款方式(1、退现金；2、进待转）
                                     prm_check       IN   NUMBER          , --检查是否存在有效补差数据。0、不检查。1、检查。
                                     prm_yab401      IN   ab08.yab401%TYPE, --利息标志
                                     prm_yab400      IN   ab08.yab400%TYPE, --滞纳金标志
                                     prm_aab033      IN   ab02.aab033%TYPE, --征收方式
                                     prm_yab139      IN   ab08.yab139%TYPE, --所属参保分中心
                                     prm_yab003      IN   ab08.yab003%TYPE, --社保经办机构
                                     prm_aae011      IN   ab08.aae011%TYPE, --经办人
                                     prm_aae036      IN   ab08.aae036%TYPE, --经办时间
                                     prm_yab222      IN   ab08.yab222%TYPE, --做帐批次号
                                     prm_aae076      OUT  ab08.aae076%TYPE, --财务接口流水号
                                     prm_AppCode     OUT  VARCHAR2,         --执行代码
                                     prm_ErrMsg      OUT  VARCHAR2)         --执行结果
   IS
      var_procNo      VARCHAR2(5);         --过程号

      num_count       NUMBER     ;         --

      var_aac001      ac01.aac001%TYPE  ;  --个人编号

      num_aab156      ab08.aab156%TYPE  ;  --欠费金额
      var_aae140      ab08.aae140%TYPE  ;  --险种信息
      var_yae010      ab08.yae010%TYPE  ;  --费用来源

      var_yad052      ab15a1.yad052%TYPE;
      var_yad060      ab15a1.yad060%TYPE;

      var_yab136      ab01.yab136%TYPE  ;  --单位管理类型
      var_aab019      ab01.aab019%TYPE  ;  --单位类型
      var_aab020      ab01.aab020%TYPE  ;  --经济类型
      var_aab021      ab01.aab021%TYPE  ;  --隶属关系
      var_aab022      ab01.aab022%TYPE  ;  --行业代码
      var_YKB109      ab01.YKB109%TYPE  ;  --是否享受公务员统筹待遇
      var_yab275      ab01.yab275%TYPE  ;  --医疗保险执行办法
      var_yab380      ab01.yab380%TYPE  ;
      var_ykb110      ab01.ykb110%TYPE  ;  --预划账户标志
      var_aae076      ab08.aae076%TYPE  ;  --征集流水号
      var_yae518_sk   ab08.yae518%TYPE  ;  --核定流水号
      var_yae518_tk   ab08.yae518%TYPE  ;  --实收退款核定流水号
      var_yae518_qftk ab08.yae518%TYPE  ;  --欠费退款核定流水号
      var_yae518_dz   ab08.yae518%TYPE  ;  --核定流水号
      num_aae002      NUMBER;

      var_flag        VARCHAR2(3)       ;  --是否进行了补差操作0 ：没有；1：进行了。

      --每个人每个险种进行一次明细写入
      CURSOR cur_aac001
      IS
         SELECT DISTINCT aac001
           FROM tmp_grbs02
          WHERE aae100 = pkg_comm.AAE100_YX;

      --本次要生成退收的数据
      CURSOR cur_tmp_grbs02_ts
      IS
         SELECT aac001,
                aae002,  --费款所属期号
                aae140   --险种
           FROM tmp_grbs02
          WHERE aae100 = pkg_comm.AAE100_YX       --有效标志：有效
            AND yac004 < 0 ;

      --实缴退款数据
      CURSOR cur_ab08_sjts
      IS
         SELECT SUM(aab156) AS aab156,
                aae140               ,
                MIN(aae041) AS aae041,
                MAX(aae042) AS aae042
           FROM ab08
          WHERE yae518 = var_yae518_tk
            AND yae517 = pkg_Comm.YAE517_H17    --补差退收
            AND yae010 = pkg_comm.YAE010_ZC
       GROUP BY aae140;

      CURSOR cur_ac08a1_sk                                     -- 明细信息
      IS
         SELECT a.aae140,
                a.yae010,    --费用来源
                MIN(a.aae002) AS aae041,
                MAX(a.aae002) AS aae042,
                COUNT(DISTINCT a.aac001) yae231,   --人数
                a.yae203   , --费用来源比例
                max(CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                     WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                     ELSE pkg_comm.YAB538_LX
                     END) YAB538,
                NVL(SUM(a.aae180),0) aab120,   --个人缴费基数总额
                NVL(SUM(a.aae180),0) aab121,   --单位缴费基数总额
                NVL(SUM(a.yab157),0) aab150,   --应缴个人缴费划入账户金额
                NVL(SUM(a.yab158),0) yab031,   --应缴个人缴费划入统筹金额
                NVL(SUM(a.aab212),0) aab151,   --应缴单位缴费划入账户金额
                NVL(SUM(a.aab213),0) aab152,   --应缴单位缴费划入统筹金额
                NVL(SUM(0),0) aab157     ,   --应补缴个人缴费划入账户本年利息
                NVL(SUM(0),0) aab158     ,   --应补缴个人缴费划入账户跨年利息
                NVL(SUM(0),0) aab159     ,   --应补缴账户本年利息单位划入金额
                NVL(SUM(0),0) aab160     ,   --应补缴账户跨年利息单位划入金额
                NVL(SUM(0),0) aab161     ,   --应补缴统筹跨年利息金额
                NVL(SUM(a.aab162),0) aab162    --应缴滞纳金金额
           FROM ac08a1check a
          WHERE a.yae518 = var_yae518_sk
            AND a.aab001 = prm_aab001
            AND a.aae003 = prm_aae003
          GROUP BY a.aae140,
                   a.yae010,    --费用来源
                   a.yae203,    --费用来源比例
                   CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                        WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                        ELSE pkg_comm.YAB538_LX
                        END;

      CURSOR cur_ac08a1_tk                                      -- 明细信息
      IS
         SELECT a.aae140,
                a.yae010,    --费用来源
                MIN(a.aae002) AS aae041,
                MAX(a.aae002) AS aae042,
                COUNT(DISTINCT a.aac001) yae231,   --人数
                a.yae203   , --费用来源比例
                max(CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                     WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                     ELSE pkg_comm.YAB538_LX
                     END) YAB538,
                NVL(SUM(a.aae180),0) aab120,   --个人缴费基数总额
                NVL(SUM(a.aae180),0) aab121,   --单位缴费基数总额
                NVL(SUM(a.yab157),0) aab150,   --应缴个人缴费划入账户金额
                NVL(SUM(a.yab158),0) yab031,   --应缴个人缴费划入统筹金额
                NVL(SUM(a.aab212),0) aab151,   --应缴单位缴费划入账户金额
                NVL(SUM(a.aab213),0) aab152,   --应缴单位缴费划入统筹金额
                NVL(SUM(0),0) aab157     ,   --应补缴个人缴费划入账户本年利息
                NVL(SUM(0),0) aab158     ,   --应补缴个人缴费划入账户跨年利息
                NVL(SUM(0),0) aab159     ,   --应补缴账户本年利息单位划入金额
                NVL(SUM(0),0) aab160     ,   --应补缴账户跨年利息单位划入金额
                NVL(SUM(0),0) aab161     ,   --应补缴统筹跨年利息金额
                NVL(SUM(a.aab162),0) aab162    --应缴滞纳金金额
           FROM ac08a1check a
          WHERE a.yae518 = var_yae518_tk
            AND a.aab001 = prm_aab001
            AND a.aae003 = prm_aae003
          GROUP BY a.aae140,
                   a.yae010,    --费用来源
                   a.yae203,    --费用来源比例
                   CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                        WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                        ELSE pkg_comm.YAB538_LX
                        END;
                        
      --add by fenggg at 20190709 begin               
      CURSOR cur_ac08a1_tsk                                     
      IS
         SELECT a.aae140,
                a.yae010,    --费用来源
                MIN(a.aae002) AS aae041,
                MAX(a.aae002) AS aae042,
                COUNT(DISTINCT a.aac001) yae231,   --人数
                a.yae203   , --费用来源比例
                max(CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                     WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                     ELSE pkg_comm.YAB538_LX
                     END) YAB538,
                NVL(SUM(a.aae180),0) aab120,   --个人缴费基数总额
                NVL(SUM(a.aae180),0) aab121,   --单位缴费基数总额
                NVL(SUM(a.yab157),0) aab150,   --应缴个人缴费划入账户金额
                NVL(SUM(a.yab158),0) yab031,   --应缴个人缴费划入统筹金额
                NVL(SUM(a.aab212),0) aab151,   --应缴单位缴费划入账户金额
                NVL(SUM(a.aab213),0) aab152,   --应缴单位缴费划入统筹金额
                NVL(SUM(0),0) aab157     ,   --应补缴个人缴费划入账户本年利息
                NVL(SUM(0),0) aab158     ,   --应补缴个人缴费划入账户跨年利息
                NVL(SUM(0),0) aab159     ,   --应补缴账户本年利息单位划入金额
                NVL(SUM(0),0) aab160     ,   --应补缴账户跨年利息单位划入金额
                NVL(SUM(0),0) aab161     ,   --应补缴统筹跨年利息金额
                NVL(SUM(a.aab162),0) aab162    --应缴滞纳金金额
           FROM ac08a1check a
          WHERE a.yae518 = var_yae518_qftk
            AND a.aab001 = prm_aab001
            AND a.aae003 = prm_aae003
          GROUP BY a.aae140,
                   a.yae010,    --费用来源
                   a.yae203,    --费用来源比例
                   CASE WHEN a.AKC021 = pkg_comm.AKC021_ZZ THEN pkg_comm.YAB538_ZZ
                        WHEN a.AKC021 = pkg_comm.AKC021_TX THEN pkg_comm.YAB538_TX
                        ELSE pkg_comm.YAB538_LX
                        END;
                        
      --add by fenggg at 20190709 end           
                        
   BEGIN
      --初始化变量
      prm_AppCode    := pkg_COMM.gn_def_OK ;
      prm_ErrMsg     := '' ;
      var_procNo     := '03';
      var_flag       := '0' ;  --是否进行了补差操作0 ：没有；1：进行了。

      SELECT COUNT(1)
        INTO num_count
        FROM tmp_grbs01;
      IF num_count <= 0 THEN
         prm_AppCode := gs_FunNo||var_procNo||'01';
         prm_ErrMsg  := '批量缴费补差出错，出错原因：没有写入tmp_grbs01信息';
         RETURN;
      END IF;

      --检查tmp_grbs01,并生成tmp_grbs02信息
      prc_p_checkData(prm_aab001   ,   --单位编号
                      prm_bcfs     ,   --补差方式（0 缴费比例补差， 1 缴费基数补差）
                      prm_yab139   ,   --参保所属分中心
                      prm_yab003   ,   --社保经办机构
                      prm_AppCode  ,           --执行代码
                      prm_ErrMsg   );            --执行结果
      IF prm_AppCode <> pkg_COMM.gn_def_OK THEN
         RETURN;
      END IF;

      insert into tmp_grbs01_20190822 select * from tmp_grbs01;
      insert into tmp_grbs02_20190822 select * from tmp_grbs02;
      
      --检查是否存在有效的补差数据
      INSERT INTO tmp_grbc02 SELECT * FROM tmp_grbs02 WHERE aae100 = pkg_comm.AAE100_YX;
      IF SQL%ROWCOUNT <= 0 THEN
         IF prm_check = 0 THEN
            RETURN ;
         ELSE
            prm_AppCode := gs_FunNo||var_procNo||'02';
            prm_ErrMsg  := '批量缴费补差出错，出错原因：没有需要补差的数据'||prm_check;
            RETURN;
         END IF ;
      END IF;
      --检查费用来源
      BEGIN
         SELECT DISTINCT yae010
           INTO var_yae010
           FROM tmp_grbc02
          WHERE aae100 = pkg_comm.AAE100_YX;       --有效标志：有效
      EXCEPTION
         WHEN TOO_MANY_ROWS THEN
            prm_AppCode    := gs_FunNo||var_procNo||'01';
            prm_ErrMsg     := '本次补差数据中存在多种费用来源，不能继续，请确认！' ;
            RETURN;
         WHEN OTHERS THEN
            prm_AppCode    := gs_FunNo||var_procNo||'01';
            prm_ErrMsg     := '本次补差数据中获取费用来源出错，不能继续，请确认！' ||SQLERRM ;
            RETURN;
      END ;

      --获取单位基本信息
      pkg_p_checkEmployerFeeCo.prc_p_checkEmployerBase
           (prm_aab001 ,  --单位编码
            var_aab019 ,  --单位类型
            var_aab020 ,  --经济类型
            var_aab021 ,  --隶属关系
            var_aab022 ,  --行业代码
            var_yab136 ,  --单位管理类型
            var_YKB109 ,
            var_yab275 ,
            var_yab380 ,
            var_ykb110 ,  --预划账户标志
            prm_AppCode,  --执行代码
            prm_ErrMsg ); --执行结果
      IF prm_AppCode <> pkg_comm.gn_def_OK  THEN
         RETURN;
      END IF;
      
      --欠费补差 
      --正数补差（正补差） 生成明细
      DELETE tmp_grbs02;
      INSERT INTO tmp_grbs02 SELECT * FROM tmp_grbc02 WHERE NOT （(aae114 = pkg_comm.AAE114_YSJ AND yac004 < 0 ) OR (aae114 = pkg_comm.AAE114_QJ AND yac004 < 0 ));
      var_yae518_sk := NULL;
      --生成个人明细
       INSERT INTO AE23(
                         aaz083, --当事人征缴计划事件ID
                         aaz002, --业务日志ID
                         aaz010, --当事人ID
                         aae013, --备注
                         aae011, --经办人
                         aae036, --经办时间
                         yab003, --经办所属机构
                         aae016,  --复核标志
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
                            var_yae518_sk  ,   --核定流水号
                            prm_aab001     ,   --单位编号
                            var_aac001     ,   --个人编号
                            prm_aae003     ,   --做帐期号
                            prm_yab139     ,   --所属参保分中心
                            prm_yab003     ,   --社保经办机构
                            prm_aae011     ,   --经办人
                            prm_aae036     ,   --经办时间
                            prm_AppCode    ,   --执行代码
                            prm_ErrMsg         --执行结果
                         );
         IF prm_AppCode <> pkg_COMM.gn_def_OK THEN
            GOTO label_ERROR ;
         END IF;

      END LOOP;

      --正数补差、欠费补差退收 写成一个ab08
      FOR rec_ac08a1_sk IN  cur_ac08a1_sk LOOP
         /*生成核定汇总应收信息表*/
         pkg_p_checkEmployerFeeCo.prc_p_insertab08check(
                             var_yae518_sk, --核定流水号
                             prm_aab001, --单位编号
                             NULL      , --个人编号
                             rec_ac08a1_sk.aae140, --险种类型
                             prm_aae003, --做帐期号
                             rec_ac08a1_sk.aae041, --开始期号
                             rec_ac08a1_sk.aae042, --终止期号
                             rec_ac08a1_sk.yab538, --缴费人员状态
                             rec_ac08a1_sk.yae010,--费用来源
                             pkg_Comm.YAE517_H12, --核定类型
                             prm_yab222, --做帐批次号
                             rec_ac08a1_sk.yae231,   --人数
                             rec_ac08a1_sk.yae203,   --费用来源比例
                             rec_ac08a1_sk.aab120,   --个人缴费基数总额
                             rec_ac08a1_sk.aab121,   --单位缴费基数总额
                             rec_ac08a1_sk.aab150,   --应缴个人缴费划入账户金额
                             rec_ac08a1_sk.yab031,   --应缴个人缴费划入统筹金额
                             rec_ac08a1_sk.aab151,   --应缴单位缴费划入账户金额
                             rec_ac08a1_sk.aab152,   --应缴单位缴费划入统筹金额
                             rec_ac08a1_sk.aab157,   --应补缴个人缴费划入账户本年利息
                             rec_ac08a1_sk.aab158,   --应补缴个人缴费划入账户跨年利息
                             rec_ac08a1_sk.aab159,   --应补缴账户本年利息单位划入金额
                             rec_ac08a1_sk.aab160,   --应补缴账户跨年利息单位划入金额
                             rec_ac08a1_sk.aab161,   --应补缴统筹跨年利息金额
                             rec_ac08a1_sk.aab162,   --应缴滞纳金金额
                             0,--待转基金金额
                             var_aab019, --单位类型
                             var_aab020, --经济成分
                             var_aab021, --隶属关系
                             var_aab022, --单位行业
                             prm_aae011, --经办人
                             prm_aae036,   --经办时间
                             prm_yab139, --参保所属分中心
                             prm_yab003, --社保经办机构
                             prm_aaz002,
                             prm_aaz083,
                             prm_AppCode,         --执行代码
                             prm_ErrMsg );        --执行结果
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            prm_ErrMsg := prm_ErrMsg||'1';
         END IF;

         var_flag := '1';
      END LOOP;
      
      --欠费补差 begin  modify fenggg at 20190709 begin
      --负数补差 （基数降低，欠费导致生成欠费负补差，把这些数据分离单独生成一个yae518，待补差当月实缴后进行退收）
      --           数据生成时，直接生成H17的欠费，不生成H12的欠费，这样便于后续处理退费
      DELETE tmp_grbs02;
      INSERT INTO tmp_grbs02 SELECT * FROM tmp_grbc02 WHERE aae114 = pkg_comm.AAE114_QJ AND yac004 < 0 ;
      var_yae518_qftk := NULL;
      --生成个人明细
      FOR rec_aac001 IN cur_aac001 LOOP
         IF var_yae518_qftk IS NULL THEN
            var_yae518_qftk := pkg_comm.fun_GetSequence(NULL,'yae518');
         END IF ;
         var_aac001 := rec_aac001.aac001;
         prc_p_CreateDetail(prm_aaz002     ,
                            prm_aaz083     ,
                            var_yae518_qftk  ,   --核定流水号
                            prm_aab001     ,   --单位编号
                            var_aac001     ,   --个人编号
                            prm_aae003     ,   --做帐期号
                            prm_yab139     ,   --所属参保分中心
                            prm_yab003     ,   --社保经办机构
                            prm_aae011     ,   --经办人
                            prm_aae036     ,   --经办时间
                            prm_AppCode    ,   --执行代码
                            prm_ErrMsg         --执行结果
                         );
         IF prm_AppCode <> pkg_COMM.gn_def_OK THEN
            GOTO label_ERROR ;
         END IF;
      END LOOP;

      --欠缴 负数补差生成一个ab08
      FOR rec_ac08a1_tk IN  cur_ac08a1_tsk LOOP
         /*生成核定汇总应收信息表*/
         pkg_p_checkEmployerFeeCo.prc_p_insertab08check(
                             var_yae518_qftk, --核定流水号
                             prm_aab001, --单位编号
                             NULL      , --个人编号
                             rec_ac08a1_tk.aae140, --险种类型
                             prm_aae003, --做帐期号
                             rec_ac08a1_tk.aae041, --开始期号
                             rec_ac08a1_tk.aae042, --终止期号
                             rec_ac08a1_tk.yab538, --缴费人员状态
                             rec_ac08a1_tk.yae010,--费用来源
                             pkg_Comm.YAE517_H17, --核定类型
                             prm_yab222, --做帐批次号
                             rec_ac08a1_tk.yae231,   --人数
                             rec_ac08a1_tk.yae203,   --费用来源比例
                             rec_ac08a1_tk.aab120,   --个人缴费基数总额
                             rec_ac08a1_tk.aab121,   --单位缴费基数总额
                             rec_ac08a1_tk.aab150,   --应缴个人缴费划入账户金额
                             rec_ac08a1_tk.yab031,   --应缴个人缴费划入统筹金额
                             rec_ac08a1_tk.aab151,   --应缴单位缴费划入账户金额
                             rec_ac08a1_tk.aab152,   --应缴单位缴费划入统筹金额
                             rec_ac08a1_tk.aab157,   --应补缴个人缴费划入账户本年利息
                             rec_ac08a1_tk.aab158,   --应补缴个人缴费划入账户跨年利息
                             rec_ac08a1_tk.aab159,   --应补缴账户本年利息单位划入金额
                             rec_ac08a1_tk.aab160,   --应补缴账户跨年利息单位划入金额
                             rec_ac08a1_tk.aab161,   --应补缴统筹跨年利息金额
                             rec_ac08a1_tk.aab162,   --应缴滞纳金金额
                             CASE WHEN var_yae010 = pkg_Comm.YAE010_CZ THEN 0
                                  ELSE -(rec_ac08a1_tk.aab150+   --应缴个人缴费划入账户金额
                                         rec_ac08a1_tk.yab031+   --应缴个人缴费划入统筹金额
                                         rec_ac08a1_tk.aab151+   --应缴单位缴费划入账户金额
                                         rec_ac08a1_tk.aab152+   --应缴单位缴费划入统筹金额
                                         rec_ac08a1_tk.aab157+   --应补缴个人缴费划入账户本年利息
                                         rec_ac08a1_tk.aab158+   --应补缴个人缴费划入账户跨年利息
                                         rec_ac08a1_tk.aab159+   --应补缴账户本年利息单位划入金额
                                         rec_ac08a1_tk.aab160+   --应补缴账户跨年利息单位划入金额
                                         rec_ac08a1_tk.aab161+   --应补缴统筹跨年利息金额
                                         rec_ac08a1_tk.aab162 )  --应缴滞纳金金额
                                    END, --待转基金金额
                             var_aab019, --单位类型
                             var_aab020, --经济成分
                             var_aab021, --隶属关系
                             var_aab022, --单位行业
                             prm_aae011, --经办人
                             prm_aae036,   --经办时间
                             prm_yab139, --参保所属分中心
                             prm_yab003, --社保经办机构
                             prm_aaz002,
                             prm_aaz083,
                             prm_AppCode,         --执行代码
                             prm_ErrMsg );        --执行结果
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            prm_ErrMsg := prm_ErrMsg||'2';
            RETURN;
         END IF;

         var_flag := '1';
      END LOOP;
      --欠费补差 end  modify fenggg at 20190709 end

      ----实缴负数补差退款，生成明细
      DELETE tmp_grbs02;
      INSERT INTO tmp_grbs02 SELECT * FROM tmp_grbc02 WHERE aae114 = pkg_comm.AAE114_YSJ AND yac004 < 0 ;
      var_yae518_tk := NULL;
      --生成个人明细
      FOR rec_aac001 IN cur_aac001 LOOP
         IF var_yae518_tk IS NULL THEN
            var_yae518_tk := pkg_comm.fun_GetSequence(NULL,'yae518');
         END IF ;
         var_aac001 := rec_aac001.aac001;
         prc_p_CreateDetail(prm_aaz002     ,
                            prm_aaz083     ,
                            var_yae518_tk  ,   --核定流水号
                            prm_aab001     ,   --单位编号
                            var_aac001     ,   --个人编号
                            prm_aae003     ,   --做帐期号
                            prm_yab139     ,   --所属参保分中心
                            prm_yab003     ,   --社保经办机构
                            prm_aae011     ,   --经办人
                            prm_aae036     ,   --经办时间
                            prm_AppCode    ,   --执行代码
                            prm_ErrMsg         --执行结果
                         );
         IF prm_AppCode <> pkg_COMM.gn_def_OK THEN
            GOTO label_ERROR ;
         END IF;
      END LOOP;

      --实缴负数补差生成一个ab08,并且进行征集
      FOR rec_ac08a1_tk IN  cur_ac08a1_tk LOOP
         /*生成核定汇总应收信息表*/
         pkg_p_checkEmployerFeeCo.prc_p_insertab08check(
                             var_yae518_tk, --核定流水号
                             prm_aab001, --单位编号
                             NULL      , --个人编号
                             rec_ac08a1_tk.aae140, --险种类型
                             prm_aae003, --做帐期号
                             rec_ac08a1_tk.aae041, --开始期号
                             rec_ac08a1_tk.aae042, --终止期号
                             rec_ac08a1_tk.yab538, --缴费人员状态
                             rec_ac08a1_tk.yae010,--费用来源
                             pkg_Comm.YAE517_H17, --核定类型
                             prm_yab222, --做帐批次号
                             rec_ac08a1_tk.yae231,   --人数
                             rec_ac08a1_tk.yae203,   --费用来源比例
                             rec_ac08a1_tk.aab120,   --个人缴费基数总额
                             rec_ac08a1_tk.aab121,   --单位缴费基数总额
                             rec_ac08a1_tk.aab150,   --应缴个人缴费划入账户金额
                             rec_ac08a1_tk.yab031,   --应缴个人缴费划入统筹金额
                             rec_ac08a1_tk.aab151,   --应缴单位缴费划入账户金额
                             rec_ac08a1_tk.aab152,   --应缴单位缴费划入统筹金额
                             rec_ac08a1_tk.aab157,   --应补缴个人缴费划入账户本年利息
                             rec_ac08a1_tk.aab158,   --应补缴个人缴费划入账户跨年利息
                             rec_ac08a1_tk.aab159,   --应补缴账户本年利息单位划入金额
                             rec_ac08a1_tk.aab160,   --应补缴账户跨年利息单位划入金额
                             rec_ac08a1_tk.aab161,   --应补缴统筹跨年利息金额
                             rec_ac08a1_tk.aab162,   --应缴滞纳金金额
                             CASE WHEN var_yae010 = pkg_Comm.YAE010_CZ THEN 0
                                  ELSE -(rec_ac08a1_tk.aab150+   --应缴个人缴费划入账户金额
                                         rec_ac08a1_tk.yab031+   --应缴个人缴费划入统筹金额
                                         rec_ac08a1_tk.aab151+   --应缴单位缴费划入账户金额
                                         rec_ac08a1_tk.aab152+   --应缴单位缴费划入统筹金额
                                         rec_ac08a1_tk.aab157+   --应补缴个人缴费划入账户本年利息
                                         rec_ac08a1_tk.aab158+   --应补缴个人缴费划入账户跨年利息
                                         rec_ac08a1_tk.aab159+   --应补缴账户本年利息单位划入金额
                                         rec_ac08a1_tk.aab160+   --应补缴账户跨年利息单位划入金额
                                         rec_ac08a1_tk.aab161+   --应补缴统筹跨年利息金额
                                         rec_ac08a1_tk.aab162 )  --应缴滞纳金金额
                                    END, --待转基金金额
                             var_aab019, --单位类型
                             var_aab020, --经济成分
                             var_aab021, --隶属关系
                             var_aab022, --单位行业
                             prm_aae011, --经办人
                             prm_aae036,   --经办时间
                             prm_yab139, --参保所属分中心
                             prm_yab003, --社保经办机构
                             prm_aaz002,
                             prm_aaz083,
                             prm_AppCode,         --执行代码
                             prm_ErrMsg );        --执行结果
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            prm_ErrMsg := prm_ErrMsg||'2';
            RETURN;
         END IF;

         var_flag := '1';
      END LOOP;
      
      --迁移ab08check.ac08a1check数据到ab08,ac08a1
      pkg_p_interrupt.prc_p_batchInterruptCheck(
                         prm_aaz002        ,
                         prm_aab001        ,  --单位编号
                         '0'    ,  --征集标志
                         null        ,  --征收方式    需要征集的时候才传
                         '1'         ,  --复核标志
                         prm_aae011        ,  --经办人
                         prm_aae036         ,  --经办时间
                         prm_yab003        ,  --社保经办机构
                         prm_Appcode        ,  --错误代码
                         prm_Errmsg         );   --错误内容
      IF var_flag = '0' THEN
         prm_AppCode := gs_FunNo||var_procNo||'10';
         prm_ErrMsg := '无有效的单位缴费补差数据，请核实！aae003:'||prm_aae003||'; aab001:'||prm_aab001;
         RETURN;
      END IF;
      
      --modify by fenggg at 20190709  begin
      --由于欠费负补差无法直接退款，所以做以下处理
      --将欠费补差（负补差）信息暂时搬走，同时删除ac08a1、ac08a1check、ab08、ab08check中对应数据，待补差相应月份实缴后，再搬回来进行退费处理
      --ac08a1check → ac08a1check_nsmx
      --ac08a1 → ac08a1_nsmx
      --ab08 → ab08_nshz
      --ab08check → ab08check_nshz
      --同时写入ab08_ns表，待处理信息直接查询ab08_ns,处理完成后更新处理标识
      prc_p_moveDetail( var_yae518_qftk,    --核定流水号
                        prm_aaz002,
                        prm_aaz083,
                        prm_aab001,      --单位编号
                        prm_aae001,      --年审年份
                        var_yae010,      --费用来源
                        prm_yab003,      --社保经办机构
                        prm_aae011,      --经办人
                        prm_yab139,      --参保所属分中心
                        prm_AppCode,      --执行代码
                        prm_ErrMsg );
      IF prm_AppCode <> pkg_comm.gn_def_OK THEN
         prm_AppCode := gs_FunNo||var_procNo||'13';
         prm_ErrMsg := '年审补差出错：'||prm_ErrMsg;
         RETURN;
      END IF;
      --modify by fenggg at 20190709 end

      /*生成tmp_yae518 为征集做准备*/
      DELETE tmp_yae518 ;
      --费用来源是财政 则所有数据都需要生成tmp_yae518
      IF var_yae010 = pkg_Comm.YAE010_CZ THEN
         NULL ;
      ELSE
         --费用来源是单位 只有退款部分需要生成，并且需要生成一个H26的信息
         --写入临时表
         INSERT INTO tmp_yae518
                   (yae518,   -- 核定流水号
                    aae140,   -- 险种类型
                    aab001,
                    yab538,
                    yae010,
                    aae041,
                    yab139)
             SELECT yae518,
                    aae140,
                    prm_aab001,
                    yab538, --缴费人员状态
                    YAE010, --费用来源
                    aae041,
                    prm_yab139
               FROM ab08
              WHERE yae518 = var_yae518_tk
                AND (aae076 IS NULL OR aae076 = '0')
                AND yae517 = pkg_Comm.YAE517_H17      --核定类型
                AND yae010 = var_yae010;

         var_yad052 := pkg_comm.YAD052_TZ ;  --调账
         var_yad060 := pkg_comm.YAD060_P19;  --单位退款
      END IF;

      /*生成征集*/
      SELECT COUNT(1)
        INTO num_count
        FROM tmp_yae518;
      IF num_count > 0 THEN
         --申请计划流水号
         var_aae076 := pkg_comm.fun_GetSequence(NULL,'aae076');
         --调用征集过程。生成单据信息和财务接口数据
         pkg_p_fundCollection.prc_crtFinaPlan  (
                                  var_yad060    ,      --收付种类
                                  var_yad052    ,      --收付结算方式
                                  prm_aae011    ,      --经办人员
                                  prm_yab003    ,      --社保经办机构
                                  var_aae076    ,      --计划流水号
                                  prm_AppCode   ,      --执行代码
                                  prm_ErrMsg    );     --执行结果
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
         prm_ErrMsg  := '批量缴费补差出错，出错原因：'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END pkg_p_salaryExamineAdjust_ns;
   
   
    /*****************************************************************************
   ** 过程名称 prc_p_insertAc08a1_nsmx
   ** 过程编号 : 03
   ** 业务环节 ：年审专用补差 数据迁移 Ac08a1 → Ac08a1_nsmx
   ** 功能描述 ：
   ******************************************************************************
   ** 作    者：            作成日期 ：2019-07-09   版本编号 ：Ver 1.0.0
   ** 字    体: Courier New  字    号 ：10
   ** 修    改：
   ******************************************************************************
   ** 备    注：
   **
   *****************************************************************************/
   PROCEDURE prc_p_moveDetail(prm_yae518      IN       ac08a1.yae518%type,    --核定流水号
                              prm_aaz002      IN       ae23.aaz002%TYPE,    
                              prm_aaz083      IN       ae23.aaz083%TYPE,    
                              prm_aab001      IN       ab08.aab001%TYPE,      --单位编号
                              prm_aae001      IN       ab05.aae001%TYPE,      --年审年份
                              prm_yae010      IN       ab08.yae010%TYPE,      --费用来源  
                              prm_aae011      IN       ab08.aae011%TYPE,      --经办人       
                              prm_yab003      IN       ab08.yab003%TYPE,      --社保经办机构
                              prm_yab139      IN       ab08.yab139%TYPE,      --参保所属分中心
                              prm_AppCode     OUT      VARCHAR2,               --执行代码
                              prm_ErrMsg      OUT      VARCHAR2)
    IS
       var_procNo      VARCHAR2(5);         --过程号   
       
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
       
       --业务流水号关联各张表
       var_yae099 := pkg_comm.fun_GetSequence(NULL,'yae099');
       
       select count(1)
         into num_ac08a1
         from ac08a1 a
        where yae518 = prm_yae518
          and aab001 = prm_aab001;
         
       --迁移ac08a1 
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
              prm_ErrMsg := '年审生成补差信息，迁移数据ac08a1出错:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
              return;
          end if;
            
       end if;
       
       
       --迁移ab08
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
              prm_ErrMsg := '年审生成补差信息，迁移数据ab08出错:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
              return;
          end if;
       end if;
       
       --迁移ac08a1check
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
              prm_ErrMsg := '年审生成补差信息，迁移数据ac08a1check出错:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
              return;
          end if;
       end if;
       
       --迁移ab08check
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
              prm_ErrMsg := '年审生成补差信息，迁移数据ab08check出错:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
              return;
          end if;   
          
       end if;
       
       --把失业、工伤的yae518和医疗、生育分开，方便后续处理
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
          
          
       --写入待处理信息表,待处理信息只写失业、医疗、工伤，医疗生育一起处理
       insert into ab08_ns
         (yae099, -- 业务流水号
          yae518, -- 核定流水号
          aaz002,
          aaz083,
          yae399, -- 业务类型 20
          aab001, -- 单位编号
          aae140, --险种
          aae001, -- 年份
          yae010, -- 费用来源
          pernum, -- 待处理人数
          aae120, -- 有效性
          yae031, -- 处理标识(0未处理 1已处理)
          yab139, -- 经办分中心
          aae011, -- 经办人
          aae036, -- 经办时间
          aae012, -- 处理人
          aae037 -- 处理时间
          )
         select yae099,        -- 业务流水号
                yae518,        -- 核定流水号
                prm_aaz002,
                prm_aaz083,
                var_yae399,    -- 业务类型 20
                aab001,        -- 单位编号
                aae140,        --险种
                prm_aae001,    -- 年份
                yae010,        -- 费用来源
                yae231,        -- 待处理人数
                '0',           -- 有效性
                '0',           -- 处理标识(0未处理 1已处理)
                yab139,        -- 经办分中心
                aae011,        -- 经办人
                sysdate,       -- 经办时间
                '',            -- 处理人
                null           -- 处理时间
           from ab08_nshz
          where yae518 in (prm_yae518,var_yae518_sye,var_yae518_gs)
            and aab001 = prm_aab001
            and aae140 in (PKG_COMM.AAE140_SYE,
                           PKG_COMM.AAE140_JBYL,
                           PKG_COMM.AAE140_GS);
                           
    EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'00';
         prm_ErrMsg  := '年审补差迁移数据出错，出错原因：'||prm_ErrMsg||','||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END prc_p_moveDetail;
   
   /********************************************************************************/
   /*  程序包名 pkg_p_bcDataRefund                                                 */
   /*  业务环节 ：年审欠费负补差退费主过程                                         */
   /*                                                                              */
   /*  其它说明 ：                                                                 */
   /*                                                                              */
   /*  完 成 人 ：fenggg                                                           */
   /*  完成日期 ：2019-07                                                          */
   /*  版本编号 ：Ver 1.0                                                          */
   /*  审 查 人 ：×××                      审查日期 ：YYYY-MM-DD                   */
   /********************************************************************************/
   --年审欠费负补差退费
    PROCEDURE pkg_p_bcDataRefund( prm_yae099      IN   ae16.yae099%TYPE, --业务流水号
                                  prm_yae518      IN   ab08.yae518%TYPE, --核定流水号
                                  prm_aab001      IN   ab02.aab001%TYPE, --单位编号
                                  prm_aae001      IN   ab05.aae001%TYPE, --年审年份
                                  prm_aae140      IN   ab08.aae140%TYPE, --险种
                                  prm_yae010      IN   ab08.yae010%TYPE, --费用来源
                                  prm_yab139      IN   ab08.yab139%TYPE, --所属参保分中心
                                  prm_aae011      IN   ab08.aae011%TYPE, --经办人
                                  prm_AppCode     OUT  VARCHAR2,         --执行代码
                                  prm_ErrMsg      OUT  VARCHAR2)         --执行结果
    IS
      var_procNo      VARCHAR2(5);         --过程号  
      
      num_ac08a1      NUMBER;
      num_ab08        NUMBER;
      num_ac08a1check NUMBER;
      num_ab08check   NUMBER;
      num_count       NUMBER;
      NUM_YAE518      NUMBER;
      
      var_yae010      ab08.yae010%TYPE;    --费用来源
      var_yad052      ab15a1.yad052%TYPE;
      var_yad060      ab15a1.yad060%TYPE;
      var_aae076      ab08.aae076%TYPE  ;  --征集流水号
      
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
         prm_ErrMsg  := '欠费退款出错，出错原因：业务流水号不能为空!';
         RETURN;
      END IF;
      
      IF prm_yae518 IS NULL THEN
         prm_AppCode := gs_FunNo||var_procNo||'02';
         prm_ErrMsg  := '欠费退款出错，出错原因：核定流水号不能为空!';
         RETURN;
      END IF;
      
      IF prm_aab001 IS NULL THEN
         prm_AppCode := gs_FunNo||var_procNo||'03';
         prm_ErrMsg  := '欠费退款出错，出错原因：单位编号不能为空!';
         RETURN;
      END IF;

      IF prm_aae001 IS NULL THEN
         prm_AppCode := gs_FunNo||var_procNo||'04';
         prm_ErrMsg  := '欠费退款出错，出错原因：年审年度不能为空!';
         RETURN;
      END IF;
      
      IF prm_aae001 < 2019 THEN
         prm_AppCode := gs_FunNo||var_procNo||'04';
         prm_ErrMsg  := '欠费退款出错，出错原因：年审年度不能小于2019!';
         RETURN;
      END IF;
      
      IF prm_aae140 IS NULL THEN
         prm_AppCode := gs_FunNo||var_procNo||'01';
         prm_ErrMsg  := '欠费退款出错，出错原因：险种不能为空!';
         RETURN;
      END IF;
      
      IF var_yae010 IS NULL THEN
         prm_AppCode := gs_FunNo||var_procNo||'05';
         prm_ErrMsg  := '欠费退款出错，出错原因：费用来源不能为空!';
         RETURN;
      END IF;
      
      --校验是否可以处理,欠费清完之后才可以处理退费,失业、工伤各自单独处理，医疗、大额一起处理
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
         prm_ErrMsg  := '欠费退款出错，出错原因:单位编号'||prm_aab001||' 开始期号：'||num_aae002_min||'，截止期号：'||num_aae002_max||'，存在欠费信息，请实收后再退费!';
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
         prm_ErrMsg  := '欠费退款出错，出错原因:单位编号'||prm_aab001||'，核定流水号：'||prm_yae518||'，退费已处理完成，请勿重复提交处理!';
         RETURN;
      END IF;
        
      --迁移待处理数据 begin
      --迁移ac08a1
      insert into ac08a1(
        yae202,	  --明细流水号
        aac001,   --个人编号
        aab001,   --单位编号
        aae140,   --险种类型
        aae003,   --做帐期号
        aae002,   --费款所属期
        aae143,   --缴费类型
        yae010,   --费用来源
        yac505,   --参保缴费人员类别
        aac008,   --人员状态
        akc021,   --医疗人员类别
        aaa040,   --比例类别
        yaa310,   --比例类型
        yae203,   --费用来源比例
        aaa041,   --个人缴费比例
        yaa017,   --个人缴费划入统筹比例
        aaa042,   --单位缴费比例
        aaa043,   --单位缴费划入帐户比例
        ala080,   --工伤浮动费率值
        akc023,   --实足年龄
        yac176,   --工龄
        yac503,   --工资类别
        aac040,   --缴费工资
        yaa333,   --账户基数
        aae180,   --缴费基数
        yab157,   --个人缴费划入帐户金额
        yab158,   --个人缴费划入统筹金额
        aab157,   --应补缴个人缴费划入账户本年利息
        aab158,   --应补缴个人缴费划入账户跨年利息
        yab555,   --应补缴个人缴费统筹部分本年利息
        yab556,   --应补缴个人缴费统筹部分跨年利息
        aab212,   --单位缴费划入帐户金额
        aab213,   --单位缴费划入统筹金额
        aab159,   --应补缴单位缴费划入帐户本年利息
        aab160,   --应补缴单位缴费划入帐户跨年利息
        yab557,   --应补缴单位缴费统筹部分本年利息
        yab558,   --应补缴单位缴费统筹部分跨年利息
        aab162,   --应缴滞纳金金额
        aae061,   --补缴核定流水号
        yae518,   --核定流水号
        aae076,   --计划流水号
        aab019,   --单位类型
        aab020,   --经济成分
        yac168,   --农民工标志
        aae011,   --经办人
        aae036,   --经办时间
        yab003,   --社保经办机构
        yab139,   --参保所属分中心
        yac234,   --缴费月数
        ykc120,   --医疗照顾人员类别
        ykc279,   --已写享受信息标志
        ykb109,   --是否享受公务员统筹待遇
        yab275,   --医疗保险执行办法
        ykb110,   --预划医疗帐户
        yje003,   --失业登记证号
        yaa330,   --缴费比例模式
        yac200    --公务员职级
      
      )select 
            yae202,	  --明细流水号
            aac001,   --个人编号
            aab001,   --单位编号
            aae140,   --险种类型
            aae003,   --做帐期号
            aae002,   --费款所属期
            aae143,   --缴费类型
            yae010,   --费用来源
            yac505,   --参保缴费人员类别
            aac008,   --人员状态
            akc021,   --医疗人员类别
            aaa040,   --比例类别
            yaa310,   --比例类型
            yae203,   --费用来源比例
            aaa041,   --个人缴费比例
            yaa017,   --个人缴费划入统筹比例
            aaa042,   --单位缴费比例
            aaa043,   --单位缴费划入帐户比例
            ala080,   --工伤浮动费率值
            akc023,   --实足年龄
            yac176,   --工龄
            yac503,   --工资类别
            aac040,   --缴费工资
            yaa333,   --账户基数
            aae180,   --缴费基数
            yab157,   --个人缴费划入帐户金额
            yab158,   --个人缴费划入统筹金额
            aab157,   --应补缴个人缴费划入账户本年利息
            aab158,   --应补缴个人缴费划入账户跨年利息
            yab555,   --应补缴个人缴费统筹部分本年利息
            yab556,   --应补缴个人缴费统筹部分跨年利息
            aab212,   --单位缴费划入帐户金额
            aab213,   --单位缴费划入统筹金额
            aab159,   --应补缴单位缴费划入帐户本年利息
            aab160,   --应补缴单位缴费划入帐户跨年利息
            yab557,   --应补缴单位缴费统筹部分本年利息
            yab558,   --应补缴单位缴费统筹部分跨年利息
            aab162,   --应缴滞纳金金额
            aae061,   --补缴核定流水号
            yae518,   --核定流水号
            aae076,   --计划流水号
            aab019,   --单位类型
            aab020,   --经济成分
            yac168,   --农民工标志
            aae011,   --经办人
            aae036,   --经办时间
            yab003,   --社保经办机构
            yab139,   --参保所属分中心
            yac234,   --缴费月数
            ykc120,   --医疗照顾人员类别
            ykc279,   --已写享受信息标志
            ykb109,   --是否享受公务员统筹待遇
            yab275,   --医疗保险执行办法
            ykb110,   --预划医疗帐户
            yje003,   --失业登记证号
            yaa330,   --缴费比例模式
            yac200    --公务员职级
      from ac08a1_nsmx
     where yae518 = prm_yae518
       and yae099 = prm_yae099
       and aab001 = prm_aab001;
       
      --迁移ac08a1check
      insert into ac08a1check(
          YAE202,  -- 明细流水号
          AAC001,  -- 个人编号
          AAB001,  -- 单位编号
          AAE140,  -- 险种类型
          AAE003,  -- 做帐期号
          AAE002,  -- 费款所属期
          AAE143,  -- 缴费类型
          YAE010,  -- 费用来源
          YAC505,  -- 参保缴费人员类别
          AAC008,  -- 人员状态
          AKC021,  -- 医疗人员类别
          AAA040,  -- 比例类别
          YAA310,  -- 比例类型
          YAE203,  -- 费用来源比例
          AAA041,  -- 个人缴费比例
          YAA017,  -- 个人缴费划入统筹比例
          AAA042,  -- 单位缴费比例
          AAA043,  -- 单位缴费划入帐户比例
          ALA080,  -- 工伤浮动费率值
          AKC023,  -- 实足年龄
          YAC176,  -- 工龄
          YAC503,  -- 工资类别
          AAC040,  -- 缴费工资
          YAA333,  -- 账户基数
          AAE180,  -- 缴费基数
          YAB157,  -- 个人缴费划入帐户金额
          YAB158,  -- 个人缴费划入统筹金额
          AAB157,  -- 应补缴个人缴费划入账户本年利息
          AAB158,  -- 应补缴个人缴费划入账户跨年利息
          YAB555,  -- 应补缴个人缴费统筹部分本年利息
          YAB556,  -- 应补缴个人缴费统筹部分跨年利息
          AAB212,  -- 单位缴费划入帐户金额
          AAB213,  -- 单位缴费划入统筹金额
          AAB159,  -- 应补缴单位缴费划入帐户本年利息
          AAB160,  -- 应补缴单位缴费划入帐户跨年利息
          YAB557,  -- 应补缴单位缴费统筹部分本年利息
          YAB558,  -- 应补缴单位缴费统筹部分跨年利息
          AAB162,  -- 应缴滞纳金金额
          AAE061,  -- 补缴核定流水号
          YAE518,  -- 核定流水号
          AAE076,  -- 计划流水号
          AAB019,  -- 单位类型
          AAB020,  -- 经济成分
          YAC168,  -- 农民工标志
          AAE011,  -- 经办人
          AAE036,  -- 经办时间
          YAB003,  -- 社保经办机构
          YAB139,  -- 参保所属分中心
          YAC234,  -- 缴费月数
          YKC120,  -- 医疗照顾人员类别
          YKC279,  -- 已写享受信息标志
          YKB109,  -- 是否享受公务员统筹待遇
          YAB275,  -- 医疗保险执行办法
          YKB110,  -- 预划医疗帐户
          YJE003,  -- 失业登记证号
          YAA330,  -- 缴费比例模式
          YAC200,  -- 公务员职级
          AAZ083,  -- 事件编号
          AAZ002   -- 业务日志号
      
      )select 
            YAE202,  -- 明细流水号
            AAC001,  -- 个人编号
            AAB001,  -- 单位编号
            AAE140,  -- 险种类型
            AAE003,  -- 做帐期号
            AAE002,  -- 费款所属期
            AAE143,  -- 缴费类型
            YAE010,  -- 费用来源
            YAC505,  -- 参保缴费人员类别
            AAC008,  -- 人员状态
            AKC021,  -- 医疗人员类别
            AAA040,  -- 比例类别
            YAA310,  -- 比例类型
            YAE203,  -- 费用来源比例
            AAA041,  -- 个人缴费比例
            YAA017,  -- 个人缴费划入统筹比例
            AAA042,  -- 单位缴费比例
            AAA043,  -- 单位缴费划入帐户比例
            ALA080,  -- 工伤浮动费率值
            AKC023,  -- 实足年龄
            YAC176,  -- 工龄
            YAC503,  -- 工资类别
            AAC040,  -- 缴费工资
            YAA333,  -- 账户基数
            AAE180,  -- 缴费基数
            YAB157,  -- 个人缴费划入帐户金额
            YAB158,  -- 个人缴费划入统筹金额
            AAB157,  -- 应补缴个人缴费划入账户本年利息
            AAB158,  -- 应补缴个人缴费划入账户跨年利息
            YAB555,  -- 应补缴个人缴费统筹部分本年利息
            YAB556,  -- 应补缴个人缴费统筹部分跨年利息
            AAB212,  -- 单位缴费划入帐户金额
            AAB213,  -- 单位缴费划入统筹金额
            AAB159,  -- 应补缴单位缴费划入帐户本年利息
            AAB160,  -- 应补缴单位缴费划入帐户跨年利息
            YAB557,  -- 应补缴单位缴费统筹部分本年利息
            YAB558,  -- 应补缴单位缴费统筹部分跨年利息
            AAB162,  -- 应缴滞纳金金额
            AAE061,  -- 补缴核定流水号
            YAE518,  -- 核定流水号
            AAE076,  -- 计划流水号
            AAB019,  -- 单位类型
            AAB020,  -- 经济成分
            YAC168,  -- 农民工标志
            AAE011,  -- 经办人
            AAE036,  -- 经办时间
            YAB003,  -- 社保经办机构
            YAB139,  -- 参保所属分中心
            YAC234,  -- 缴费月数
            YKC120,  -- 医疗照顾人员类别
            YKC279,  -- 已写享受信息标志
            YKB109,  -- 是否享受公务员统筹待遇
            YAB275,  -- 医疗保险执行办法
            YKB110,  -- 预划医疗帐户
            YJE003,  -- 失业登记证号
            YAA330,  -- 缴费比例模式
            YAC200,  -- 公务员职级
            AAZ083,  -- 事件编号
            AAZ002   -- 业务日志号
      from ac08a1check_nsmx
     where yae518 = prm_yae518
       and yae099 = prm_yae099
       and aab001 = prm_aab001;
       
     --迁移ab08
     insert into ab08(
          yae518,  -- 核定流水号
          aab001,  -- 单位编号
          aac001,  -- 个人编号
          aae140,  -- 险种类型
          aae003,  -- 做帐期号
          aae041,  -- 开始期号
          aae042,  -- 终止期号
          yab538,  -- 缴费人员状态
          yae010,  -- 费用来源
          aab165,  -- 单位缴费标志
          aab166,  -- 征集通知标志
          yae517,  -- 核定类型
          yab222,  -- 做帐批次号
          yae231,  -- 人数
          yae203,  -- 费用来源比例
          aab120,  -- 个人缴费基数总额
          aab121,  -- 单位缴费基数总额
          aab150,  -- 应缴个人缴费划入账户金额
          yab031,  -- 应缴个人缴费划入统筹金额
          aab151,  -- 应缴单位缴费划入账户金额
          aab152,  -- 应缴单位缴费划入统筹金额
          yab216,  -- 应缴归集部分金额
          aab153,  -- 已缴个人缴费划入账户金额
          yab040,  -- 已缴个人缴费划入统筹金额
          aab154,  -- 已缴单位缴费划入账户金额
          aab155,  -- 已缴单位缴费划入统筹金额
          yab217,  -- 已缴归集部分金额
          aab157,  -- 应补缴个人缴费划入账户本年利息
          aab158,  -- 应补缴个人缴费划入账户跨年利息
          aab159,  -- 应补缴账户本年利息单位划入金额
          aab160,  -- 应补缴账户跨年利息单位划入金额
          aab161,  -- 应补缴统筹跨年利息金额
          aab162,  -- 应缴滞纳金金额
          yab042,  -- 已缴个人缴费划入账户利息
          yab046,  -- 已缴单位缴费划入账户利息
          yab059,  -- 已缴统筹利息金额yab059
          yab215,  -- 已缴滞纳金总额
          yab381,  -- 减免滞纳金金额yab381
          yab146,  -- 应退帐个人缴费划帐户金额
          yab147,  -- 应退帐个人缴费划统筹金额
          yab148,  -- 应退帐单位缴费划帐户金额
          yab149,  -- 应退帐单位缴费划统筹金额
          yab218,  -- 应退帐归集部分金额
          aab214,  -- 待转基金金额
          aab156,  -- 欠缴金额
          yab400,  -- 滞纳金计算标志
          yab401,  -- 利息计算标志
          aab163,  -- 利息计算截止日期
          aab164,  -- 滞纳金计算截止日期
          yab541,  -- 个人缴纳部分是否挂账
          yab542,  -- 单位缴纳划入账户部分是否挂账
          yab543,  -- 单位缴纳划入统筹部分是否挂账
          yab544,  -- 利息是否挂账
          yab546,  -- 滞纳金是否挂账
          aab019,  -- 单位类型
          aab020,  -- 经济成分
          aab021,  -- 隶属关系
          aab022,  -- 单位行业
          yae526,  -- 原核定流水号
          aae068,  -- 基金配置流水号
          aae076,  -- 计划流水号
          aab191,  -- 到账/登账日期
          yad180,  -- 财务结算日期
          yaa011,  -- 业务处理标志
          yaa012,  -- 财务处理标志
          yab139,  -- 参保所属分中心
          aae011,  -- 经办人
          aae036,  -- 经办时间
          yab003,  -- 社保经办机构
          aae013,  -- 备注
          aaz083   -- 当事人征缴计划事件id
     
     )select 
          yae518,  -- 核定流水号
          aab001,  -- 单位编号
          aac001,  -- 个人编号
          aae140,  -- 险种类型
          aae003,  -- 做帐期号
          aae041,  -- 开始期号
          aae042,  -- 终止期号
          yab538,  -- 缴费人员状态
          yae010,  -- 费用来源
          aab165,  -- 单位缴费标志
          aab166,  -- 征集通知标志
          yae517,  -- 核定类型
          yab222,  -- 做帐批次号
          yae231,  -- 人数
          yae203,  -- 费用来源比例
          aab120,  -- 个人缴费基数总额
          aab121,  -- 单位缴费基数总额
          aab150,  -- 应缴个人缴费划入账户金额
          yab031,  -- 应缴个人缴费划入统筹金额
          aab151,  -- 应缴单位缴费划入账户金额
          aab152,  -- 应缴单位缴费划入统筹金额
          yab216,  -- 应缴归集部分金额
          aab153,  -- 已缴个人缴费划入账户金额
          yab040,  -- 已缴个人缴费划入统筹金额
          aab154,  -- 已缴单位缴费划入账户金额
          aab155,  -- 已缴单位缴费划入统筹金额
          yab217,  -- 已缴归集部分金额
          aab157,  -- 应补缴个人缴费划入账户本年利息
          aab158,  -- 应补缴个人缴费划入账户跨年利息
          aab159,  -- 应补缴账户本年利息单位划入金额
          aab160,  -- 应补缴账户跨年利息单位划入金额
          aab161,  -- 应补缴统筹跨年利息金额
          aab162,  -- 应缴滞纳金金额
          yab042,  -- 已缴个人缴费划入账户利息
          yab046,  -- 已缴单位缴费划入账户利息
          yab059,  -- 已缴统筹利息金额yab059
          yab215,  -- 已缴滞纳金总额
          yab381,  -- 减免滞纳金金额yab381
          yab146,  -- 应退帐个人缴费划帐户金额
          yab147,  -- 应退帐个人缴费划统筹金额
          yab148,  -- 应退帐单位缴费划帐户金额
          yab149,  -- 应退帐单位缴费划统筹金额
          yab218,  -- 应退帐归集部分金额
          aab214,  -- 待转基金金额
          aab156,  -- 欠缴金额
          yab400,  -- 滞纳金计算标志
          yab401,  -- 利息计算标志
          aab163,  -- 利息计算截止日期
          aab164,  -- 滞纳金计算截止日期
          yab541,  -- 个人缴纳部分是否挂账
          yab542,  -- 单位缴纳划入账户部分是否挂账
          yab543,  -- 单位缴纳划入统筹部分是否挂账
          yab544,  -- 利息是否挂账
          yab546,  -- 滞纳金是否挂账
          aab019,  -- 单位类型
          aab020,  -- 经济成分
          aab021,  -- 隶属关系
          aab022,  -- 单位行业
          yae526,  -- 原核定流水号
          aae068,  -- 基金配置流水号
          aae076,  -- 计划流水号
          aab191,  -- 到账/登账日期
          yad180,  -- 财务结算日期
          yaa011,  -- 业务处理标志
          yaa012,  -- 财务处理标志
          yab139,  -- 参保所属分中心
          aae011,  -- 经办人
          aae036,  -- 经办时间
          yab003,  -- 社保经办机构
          aae013,  -- 备注
          aaz083   -- 当事人征缴计划事件id
     from ab08_nshz
    where yae518 = prm_yae518
      and yae099 = prm_yae099
      and aab001 = prm_aab001;
      
     insert into ab08check(
          yae518,   --核定流水号
          aab001,   --单位编号
          aac001,   --个人编号
          aae140,   --险种类型
          aae003,   --做帐期号
          aae041,   --开始期号
          aae042,   --终止期号
          yab538,   --缴费人员状态
          yae010,   --费用来源
          aab165,   --单位缴费标志
          aab166,   --征集通知标志
          yae517,   --核定类型
          yab222,   --做帐批次号
          yae231,   --人数
          yae203,   --费用来源比例
          aab120,   --个人缴费基数总额
          aab121,   --单位缴费基数总额
          aab150,   --应缴个人缴费划入账户金额
          yab031,   --应缴个人缴费划入统筹金额
          aab151,   --应缴单位缴费划入账户金额
          aab152,   --应缴单位缴费划入统筹金额
          yab216,   --应缴归集部分金额
          aab153,   --已缴个人缴费划入账户金额
          yab040,   --已缴个人缴费划入统筹金额
          aab154,   --已缴单位缴费划入账户金额
          aab155,   --已缴单位缴费划入统筹金额
          yab217,   --已缴归集部分金额
          aab157,   --应补缴个人缴费划入账户本年利息
          aab158,   --应补缴个人缴费划入账户跨年利息
          aab159,   --应补缴账户本年利息单位划入金额
          aab160,   --应补缴账户跨年利息单位划入金额
          aab161,   --应补缴统筹跨年利息金额
          aab162,   --应缴滞纳金金额
          yab042,   --已缴个人缴费划入账户利息
          yab046,   --已缴单位缴费划入账户利息
          yab059,   --已缴统筹利息金额yab059
          yab215,   --已缴滞纳金总额
          yab381,   --减免滞纳金金额yab381
          yab146,   --应退帐个人缴费划帐户金额
          yab147,   --应退帐个人缴费划统筹金额
          yab148,   --应退帐单位缴费划帐户金额
          yab149,   --应退帐单位缴费划统筹金额
          yab218,   --应退帐归集部分金额
          aab214,   --待转基金金额
          aab156,   --欠缴金额
          yab400,   --滞纳金计算标志
          yab401,   --利息计算标志
          aab163,   --利息计算截止日期
          aab164,   --滞纳金计算截止日期
          yab541,   --个人缴纳部分是否挂账
          yab542,   --单位缴纳划入账户部分是否挂账
          yab543,   --单位缴纳划入统筹部分是否挂账
          yab544,   --利息是否挂账
          yab546,   --滞纳金是否挂账
          aab019,   --单位类型
          aab020,   --经济成分
          aab021,   --隶属关系
          aab022,   --单位行业
          yae526,   --原核定流水号
          aae068,   --基金配置流水号
          aae076,   --计划流水号
          aab191,   --到账/登账日期
          yad180,   --财务结算日期
          yaa011,   --业务处理标志
          yaa012,   --财务处理标志
          yab139,   --参保所属分中心
          aae011,   --经办人
          aae036,   --经办时间
          yab003,   --社保经办机构
          aae013,   --备注
          aaz083,   --当事人征缴计划事件id
          aaz002    --业务日志id
     
     )select  
          yae518,   --核定流水号
          aab001,   --单位编号
          aac001,   --个人编号
          aae140,   --险种类型
          aae003,   --做帐期号
          aae041,   --开始期号
          aae042,   --终止期号
          yab538,   --缴费人员状态
          yae010,   --费用来源
          aab165,   --单位缴费标志
          aab166,   --征集通知标志
          yae517,   --核定类型
          yab222,   --做帐批次号
          yae231,   --人数
          yae203,   --费用来源比例
          aab120,   --个人缴费基数总额
          aab121,   --单位缴费基数总额
          aab150,   --应缴个人缴费划入账户金额
          yab031,   --应缴个人缴费划入统筹金额
          aab151,   --应缴单位缴费划入账户金额
          aab152,   --应缴单位缴费划入统筹金额
          yab216,   --应缴归集部分金额
          aab153,   --已缴个人缴费划入账户金额
          yab040,   --已缴个人缴费划入统筹金额
          aab154,   --已缴单位缴费划入账户金额
          aab155,   --已缴单位缴费划入统筹金额
          yab217,   --已缴归集部分金额
          aab157,   --应补缴个人缴费划入账户本年利息
          aab158,   --应补缴个人缴费划入账户跨年利息
          aab159,   --应补缴账户本年利息单位划入金额
          aab160,   --应补缴账户跨年利息单位划入金额
          aab161,   --应补缴统筹跨年利息金额
          aab162,   --应缴滞纳金金额
          yab042,   --已缴个人缴费划入账户利息
          yab046,   --已缴单位缴费划入账户利息
          yab059,   --已缴统筹利息金额yab059
          yab215,   --已缴滞纳金总额
          yab381,   --减免滞纳金金额yab381
          yab146,   --应退帐个人缴费划帐户金额
          yab147,   --应退帐个人缴费划统筹金额
          yab148,   --应退帐单位缴费划帐户金额
          yab149,   --应退帐单位缴费划统筹金额
          yab218,   --应退帐归集部分金额
          aab214,   --待转基金金额
          aab156,   --欠缴金额
          yab400,   --滞纳金计算标志
          yab401,   --利息计算标志
          aab163,   --利息计算截止日期
          aab164,   --滞纳金计算截止日期
          yab541,   --个人缴纳部分是否挂账
          yab542,   --单位缴纳划入账户部分是否挂账
          yab543,   --单位缴纳划入统筹部分是否挂账
          yab544,   --利息是否挂账
          yab546,   --滞纳金是否挂账
          aab019,   --单位类型
          aab020,   --经济成分
          aab021,   --隶属关系
          aab022,   --单位行业
          yae526,   --原核定流水号
          aae068,   --基金配置流水号
          aae076,   --计划流水号
          aab191,   --到账/登账日期
          yad180,   --财务结算日期
          yaa011,   --业务处理标志
          yaa012,   --财务处理标志
          yab139,   --参保所属分中心
          aae011,   --经办人
          aae036,   --经办时间
          yab003,   --社保经办机构
          aae013,   --备注
          aaz083,   --当事人征缴计划事件id
          aaz002    --业务日志id
      from ab08check_nshz
     where yae518 = prm_yae518
       and yae099 = prm_yae099
       and aab001 = prm_aab001;
     --迁移待处理数据 end 
     
     
     --征集 实收 begin
      /*生成tmp_yae518 为征集做准备*/
      DELETE tmp_yae518 ;
      --费用来源是财政 则所有数据都需要生成tmp_yae518
      IF var_yae010 = pkg_Comm.YAE010_CZ THEN
         NULL ;
      ELSE
         --费用来源是单位 只有退款部分需要生成，并且需要生成一个H26的信息
         --写入临时表
         INSERT INTO tmp_yae518
                   (yae518,   -- 核定流水号
                    aae140,   -- 险种类型
                    aab001,
                    yab538,
                    yae010,
                    aae041,
                    yab139)
             SELECT yae518,
                    aae140,
                    prm_aab001,
                    yab538, --缴费人员状态
                    YAE010, --费用来源
                    aae041,
                    prm_yab139
               FROM ab08
              WHERE yae518 = prm_yae518
                AND (aae076 IS NULL OR aae076 = '0')
                AND yae517 = pkg_Comm.YAE517_H17      --核定类型
                AND yae010 = var_yae010;

         var_yad052 := pkg_comm.YAD052_TZ ;  --调账
         var_yad060 := pkg_comm.YAD060_P19;  --单位退款
      END IF;

      /*生成征集*/
      SELECT COUNT(1)
        INTO num_count
        FROM tmp_yae518;
      IF num_count > 0 THEN
         --申请计划流水号
         var_aae076 := pkg_comm.fun_GetSequence(NULL,'aae076');
         --调用征集过程。生成单据信息和财务接口数据
         pkg_p_fundCollection.prc_crtFinaPlan  (
                                  var_yad060    ,      --收付种类
                                  var_yad052    ,      --收付结算方式
                                  prm_aae011    ,      --经办人员
                                  prm_yab139    ,      --社保经办机构
                                  var_aae076    ,      --计划流水号
                                  prm_AppCode   ,      --执行代码
                                  prm_ErrMsg    );     --执行结果
         IF prm_AppCode <> pkg_comm.gn_def_OK THEN
            RETURN;
         END IF;
      END IF;
     --征集 实收 end
     
     --更新处理标记为已处理
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
         prm_ErrMsg  := '年审补差迁移数据出错，出错原因：'||prm_ErrMsg||','||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END pkg_p_bcDataRefund;
   
   
   /********************************************************************************/
   /*  程序包名 pkg_p_batchBcDataRefund                                            */
   /*  业务环节 ：批量年审欠费负补差退费                                           */
   /*                                                                              */
   /*  其它说明 ：                                                                 */
   /*                                                                              */
   /*  完 成 人 ：                                                                 */
   /*  完成日期 ：2019-07                                                          */
   /*  版本编号 ：Ver 1.0                                                          */
   /*  审 查 人 ：×××                      审查日期 ：YYYY-MM-DD                */
   /********************************************************************************/
   --批量年审欠费负补差退费
    PROCEDURE pkg_p_batchBcDataRefund( prm_jobid       IN   QRTZ_JOB_MSGS.Jobid%TYPE,--jobid
                                       prm_aab001      IN   ab01.aab001%TYPE, --单位编号（可以不传，如果传值则单个处理，否则，批量处理）
                                       prm_aae001      IN   ab05.aae001%TYPE, --年审年份
                                       prm_yab139      IN   ab08.yab139%TYPE, --所属参保分中心
                                       prm_aae011      IN   ab08.aae011%TYPE  --经办人
                                      -- prm_AppCode     OUT  VARCHAR2,         --执行代码
                                      -- prm_ErrMsg      OUT  VARCHAR2          --执行结果
                                      )          
   IS
      var_procNo      VARCHAR2(5);         --过程号  
      
      var_yae099      ae16.yae099%type;
      var_yae399      ae16.yae399%type;
      var_yae518      ab08.yae518%type;
      var_aab001      ab01.aab001%type;
      var_yae010      ab08.yae010%type;
      var_aae140      ab08.aae140%type;
      
      var_starttime         VARCHAR2(30);     --开始时间
      var_endtime           VARCHAR2(30);     --终止时间
      var_issuccess         qrtz_job_msgs.issuccess%TYPE  ; --成功标志
      var_successmsg        qrtz_job_msgs.successmsg%TYPE ; --成功信息
      var_failmsg           qrtz_job_msgs.errormsg%TYPE   ; --失败消息
      var_result            qrtz_job_msgs.errormsg%TYPE; --定时执行结果
      
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
         prm_ErrMsg := '年审欠费负补差退费出错：年审年度不能小于2019;';
         RETURN;
      END IF;
      
      IF prm_yab139 IS NULL THEN
         prm_AppCode := pkg_COMM.GN_DEF_ERR;
         prm_ErrMsg := '年审欠费负补差退费出错：经办分中心不能为空!';
         RETURN;
      END IF;
      
      IF prm_aab001 IS NULL THEN  --批量处理
         SELECT COUNT(1)
          INTO NUM_AB08_NS
          FROM AB08_NS
         WHERE aae001 = prm_aae001
           AND yab139 = prm_yab139
           AND yae031 = '0'       --未处理
           AND aae120 = '0';      --有效
          
      ELSE     --单个处理
         SELECT COUNT(1)
          INTO NUM_AB08_NS
          FROM AB08_NS
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND yab139 = prm_yab139       
           AND yae031 = '0'              --未处理
           AND aae120 = '0';             --有效
           
      END IF;
      
         
      IF NUM_AB08_NS = 0 THEN
         prm_AppCode  := pkg_COMM.gn_def_ERR ;
         prm_ErrMsg   := prm_aab001 || '年审欠费退费处理，不存在待处理数据！' ;
         
         var_issuccess   := '0';  --成功标志
         var_successmsg  := NULL; --成功信息
         var_failmsg     := prm_ErrMsg; --失败消息
         var_endtime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
         insertQRTZ_JOB_MSGS(prm_jobid,var_aab001,prm_aae011,var_starttime,var_endtime,var_issuccess,var_successmsg,var_failmsg);
             
         RETURN;
      END IF;
      
      IF prm_aab001 IS NULL THEN  --按区县批量处理
        
         FOR cur_1 in cur_ab01_all LOOP
        
              var_starttime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');  
              
              var_yae099 := cur_1.yae099;
              var_yae518 := cur_1.yae518;
              var_aab001 := cur_1.aab001;
              var_yae010 := cur_1.yae010;
              var_aae140 := cur_1.aae140;
              
              pkg_p_bcDataRefund( var_yae099 , --业务流水号
                                  var_yae518 , --核定流水号
                                  var_aab001 , --单位编号
                                  prm_aae001 , --年审年份
                                  var_aae140 , --险种
                                  var_yae010 , --费用来源
                                  prm_yab139 , --所属参保分中心
                                  prm_aae011 , --经办人
                                  prm_AppCode ,         --执行代码
                                  prm_ErrMsg            --执行结果
                                );
                       
              IF prm_AppCode <> pkg_comm.gn_def_OK THEN
                 var_issuccess   := '0';  --成功标志
                 var_successmsg  := NULL; --成功信息
                 var_failmsg     := '单位：' || cur_1.aab001||' 业务流水号'||cur_1.yae099||' 日常年审欠费退费出错:'||prm_ErrMsg; --失败消息
                 var_endtime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
                 insertQRTZ_JOB_MSGS(prm_jobid,var_aab001,prm_aae011,var_starttime,var_endtime,var_issuccess,var_successmsg,var_failmsg);
                 ROLLBACK;
              ELSE
                 var_issuccess   := '1';  --成功标志
                 var_successmsg  := '单位：' || cur_1.aab001||' 业务流水号'||cur_1.yae099||' 日常年审欠费退费成功!'; --成功信息
                 var_failmsg     := NULL; --失败消息
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
               
              pkg_p_bcDataRefund( var_yae099 , --业务流水号
                                  var_yae518 , --核定流水号
                                  var_aab001 , --单位编号
                                  prm_aae001 , --年审年份
                                  var_aae140 , --险种
                                  var_yae010 , --费用来源
                                  prm_yab139 , --所属参保分中心
                                  prm_aae011 , --经办人
                                  prm_AppCode ,         --执行代码
                                  prm_ErrMsg            --执行结果
                                );
                       
              IF prm_AppCode <> pkg_comm.gn_def_OK THEN
                 var_issuccess   := '0';  --成功标志
                 var_successmsg  := NULL; --成功信息
                 var_failmsg     := '单位：' || cur_1.aab001||' 业务流水号'||cur_1.yae099||' 日常年审欠费退费出错:'||prm_ErrMsg; --失败消息
                 var_endtime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
                 insertQRTZ_JOB_MSGS(prm_jobid,var_aab001,prm_aae011,var_starttime,var_endtime,var_issuccess,var_successmsg,var_failmsg);
                 ROLLBACK;
              ELSE
                 var_issuccess   := '1';  --成功标志
                 var_successmsg  := '单位：' || cur_1.aab001||' 业务流水号'||cur_1.yae099||' 日常年审欠费退费成功'; --成功信息
                 var_failmsg     := NULL; --失败消息
                 var_endtime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
                 insertQRTZ_JOB_MSGS(prm_jobid,var_aab001,prm_aae011,var_starttime,var_endtime,var_issuccess,var_successmsg,var_failmsg);
                 COMMIT;
              END IF;
       END LOOP;
       
       deleteYH_HTCONTRO(var_aab001,var_ywlx,prm_yab139);
       
    END IF;
    
    UPDATE YHCIP_ORACLE_JOBS 
       SET ENDTIME = SYSDATE,
           RESULT = '处理完成'
     WHERE jobid = prm_jobid; 
                   
   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'00';
         prm_ErrMsg  := '年审补差迁移数据出错，出错原因：'||prm_ErrMsg||','||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END pkg_p_batchBcDataRefund; 
   
   
   /********************************************************************************/
   /*  程序包名 pkg_p_batchBcDataRefund                                            */
   /*  业务环节 ：批量年审欠费负补差退费                                           */
   /*            （后台定时任务使用，全市一起执行，不带yab139）                    */
   /*                                                                              */
   /*  其它说明 ：                                                                 */
   /*           此方法为后台定时任务使用，批量年审欠费负补差退费，全市统一执行     */
   /*           注意：游标查询不带经办分中心yab139，前台功能勿调用，以免做错       */                                                    
   /*  完 成 人 ：fenggg                                                           */
   /*  完成日期 ：2019-07                                                          */
   /*  版本编号 ：Ver 1.0                                                          */
   /*  审 查 人 ：×××                      审查日期 ：YYYY-MM-DD                */
   /********************************************************************************/
    PROCEDURE pkg_p_batchBcDataRefundJob( prm_aae001      IN   ab05.aae001%TYPE, --年审年份
                                          prm_aae011      IN   ab08.aae011%TYPE  --经办人  
                                        )
    IS
      var_procNo      VARCHAR2(5);         --过程号  
      
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
      
      var_starttime         VARCHAR2(30);     --开始时间
      var_endtime           VARCHAR2(30);     --终止时间
      var_issuccess         qrtz_job_msgs.issuccess%TYPE  ; --成功标志
      var_successmsg        qrtz_job_msgs.successmsg%TYPE ; --成功信息
      var_failmsg           qrtz_job_msgs.errormsg%TYPE   ; --失败消息
      var_result            qrtz_job_msgs.errormsg%TYPE; --定时执行结果
      
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
      var_jobname := to_char(sysdate,'yyyymmdd')||'(后台定时任务)日常年审欠费退费';
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
         prm_ErrMsg := '(定时任务)日常年审欠费退费出错：年审年度不能小于2019;';
         
         var_issuccess   := '0';  --成功标志
         var_successmsg  := NULL; --成功信息
         var_failmsg     := prm_ErrMsg; --失败消息
         var_endtime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
         insertQRTZ_JOB_MSGS(num_jobid,var_aab001,prm_aae011,var_starttime,var_endtime,var_issuccess,var_successmsg,var_failmsg);
         
         GOTO end_label;
      END IF;
      
      SELECT COUNT(1)
        INTO NUM_AB08_NS
        FROM AB08_NS
       WHERE aae001 = prm_aae001
         AND yae031 = '0'       --未处理
         AND aae120 = '0';      --有效
      
      IF NUM_AB08_NS = 0 THEN
         prm_AppCode  := pkg_COMM.gn_def_ERR ;
         prm_ErrMsg   := '(定时任务)日常年审欠费退费，不存在待处理数据！' ;
         
         var_issuccess   := '0';  --成功标志
         var_successmsg  := NULL; --成功信息
         var_failmsg     := prm_ErrMsg; --失败消息
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
              
          pkg_p_bcDataRefund( var_yae099 , --业务流水号
                              var_yae518 , --核定流水号
                              var_aab001 , --单位编号
                              prm_aae001 , --年审年份
                              var_aae140 , --险种
                              var_yae010 , --费用来源
                              var_yab139 , --所属参保分中心
                              prm_aae011 , --经办人
                              prm_AppCode ,         --执行代码
                              prm_ErrMsg            --执行结果
                             );
          IF prm_AppCode <> pkg_comm.gn_def_OK THEN
             var_issuccess   := '0';  --成功标志
             var_successmsg  := NULL; --成功信息
             var_failmsg     := '单位：' || cur_1.aab001||' 业务流水号'||cur_1.yae099||' 欠费退费出错:'||prm_ErrMsg; --失败消息
             var_endtime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
             insertQRTZ_JOB_MSGS(num_jobid,var_aab001,prm_aae011,var_starttime,var_endtime,var_issuccess,var_successmsg,var_failmsg);
           --  ROLLBACK;
          ELSE
             var_issuccess   := '1';  --成功标志
             var_successmsg  := '单位：' || cur_1.aab001||' 业务流水号'||cur_1.yae099||' 欠费退费成功'; --成功信息
             var_failmsg     := NULL; --失败消息
             var_endtime  := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
             insertQRTZ_JOB_MSGS(num_jobid,var_aab001,prm_aae011,var_starttime,var_endtime,var_issuccess,var_successmsg,var_failmsg);
             COMMIT;
          END IF;
       END LOOP;
       
       <<end_label>>
         UPDATE YHCIP_ORACLE_JOBS 
            SET ENDTIME = SYSDATE,
                RESULT = '处理完成'
          WHERE jobid = num_jobid; 
          
    EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'00';
         prm_ErrMsg  := '年审定时任务出错，出错原因：'||prm_ErrMsg||','||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
    END pkg_p_batchBcDataRefundJob;    
    /********************************************************************************/
   /*  程序包名 pkg_p_batchBcDataRefund                                            */
   /*  业务环节 ：批量年审欠费负补差退费 定时任务（前台方法调用）                  */
   /*                                                                              */
   /*  其它说明 ：                                                                 */
   /*                                                                              */
   /*  完 成 人 ：fenggg                                                           */
   /*  完成日期 ：2019-07                                                          */
   /*  版本编号 ：Ver 1.0                                                          */
   /*  审 查 人 ：×××                      审查日期 ：YYYY-MM-DD                */
   /********************************************************************************/
   --批量年审欠费负补差退费(定时任务)
    PROCEDURE pkg_p_createBcDataRefundJob( prm_aab001      IN   ab01.aab001%TYPE, --单位编号
                                           prm_aae001      IN   ab05.aae001%TYPE, --年审年份
                                           prm_yab139      IN   ab08.yab139%TYPE, --所属参保分中心
                                           prm_aae011      IN   ab08.aae011%TYPE, --经办人
                                           prm_AppCode     OUT  VARCHAR2,         --执行代码
                                           prm_ErrMsg      OUT  VARCHAR2          --执行结果
                                          )
    IS
      var_procNo      VARCHAR2(5);         --过程号  
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
         prm_ErrMsg := '日常年审欠费退费创建定时任务出错：年审年度不能小于2019!';
         RETURN;
      END IF;
      
      IF prm_yab139 IS NULL THEN
         prm_AppCode := pkg_COMM.GN_DEF_ERR;
         prm_ErrMsg := '日常年审欠费退费创建定时任务出错：经办分中心不能为空!';
         RETURN;
      END IF;
      
      select trim(to_char(sysdate,'day','NLS_DATE_LANGUAGE=AMERICAN')) into var_week from dual;
      
      num_jobid := pkg_comm.fun_GetSequence(NULL,'JOBID');
      var_jobname := to_char(sysdate,'yyyymmdd')||'日常年审欠费退费'||prm_aab001;
      var_interval := '';   
      var_what := 'pkg_p_salaryExamineAdjust.pkg_p_batchBcDataRefund('''|| num_jobid  ||''','''
                                                                        || prm_aab001 ||''','''
                                                                        || prm_aae001 ||''','''
                                                                        || prm_yab139 ||''','''
                                                                        || prm_aae011 ||''');';
                                                                        --|| prm_AppCode ||''','''
                                                                        --|| prm_ErrMsg ||'''
                                                                        
                                
      
      --单位编号为空 则是处理全部单位，晚上23.30执行定时任务
      --周五往后延迟一天执行
      NUM_AB08_PERNUM := 0;
      IF prm_aab001 IS NULL THEN
        
         var_ywzb := var_ywzb||prm_yab139;  
         var_jobname := to_char(sysdate,'yyyymmdd')||'日常年审欠费退费(批量)'||prm_yab139;                                   

         IF var_week = 'friday' THEN
            var_next_date := 'to_date(to_char(sysdate + 1,''yyyymmdd'')||''23:30:00'',''yyyymmdd hh24:mi:ss'')';
         ELSE
            var_next_date := 'to_date(to_char(sysdate ,''yyyymmdd'')||''23:30:00'',''yyyymmdd hh24:mi:ss'')';
         END IF;  

      ELSE --单位编号非空，则只处理该单位，人数小于1000 1分钟以后执行,人数大于1000 晚上20：00执行，周五往后延迟一天执行
         var_ywzb := prm_aab001;
         
         SELECT NVL(max(PERNUM),0),COUNT(1)
           INTO NUM_AB08_PERNUM,NUM_COUNT1
           FROM AB08_NS
          WHERE AAB001 = prm_aab001
            AND YAE031 = '0';
            
         IF NUM_COUNT1 < 1 THEN
            prm_AppCode := pkg_COMM.GN_DEF_ERR;
            prm_ErrMsg := '日常年审欠费退费创建定时任务,单位:'||prm_aab001||'不存在需要处理的数据';
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
      
      --校验是否存在待执行的定时任务
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
         prm_ErrMsg := '日常年审欠费退费创建定时任务出错：经办分中心'||prm_yab139||'已经存在待执行的定时任务，请勿重复提交!';
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
         prm_ErrMsg := '日常年审欠费退费创建定时任务出错：'||prm_ErrMsg||','||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
      ELSE
         prm_AppCode := pkg_COMM.GN_DEF_OK;
         prm_ErrMsg := '';
         insertYH_HTCONTRO(var_ywzb,var_ywlx,prm_yab139,prm_aae011);
      END IF;
                                     
    EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := gs_FunNo||var_procNo||'00';
         prm_ErrMsg  := '年审批量处理欠费退款创建定时任务出错，出错原因：'||prm_ErrMsg||','||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END pkg_p_createBcDataRefundJob;
   
   
   /********************************************************************************/
   /*  程序包名 insertQRTZ_JOB_MSGS                                            */
   /*  业务环节 ：记录日志                                     */
   /*                                                                              */
   /*  其它说明 ：                                                                 */
   /*                                                                              */
   /*  完 成 人 ：fenggg                                                           */
   /*  完成日期 ：2019-07                                                          */
   /*  版本编号 ：Ver 1.0                                                          */
   /*  审 查 人 ：×××                      审查日期 ：YYYY-MM-DD                */
   /********************************************************************************/                                   
    PROCEDURE insertYHCIP_ORACLE_JOBS(
      prm_jobid                          IN     VARCHAR2      ,--jobid外部传进来的是用于YHCIP_ORACLE_JOBS表的主键，出去的是oracle生成的jobid
      prm_jobname                        IN     VARCHAR2      ,--任务名称
      prm_what                           IN     VARCHAR2      ,--执行过程，需要“;”分号结尾
      prm_next_date                      IN     VARCHAR2      ,--执行时间
      prm_interval                       IN     VARCHAR2      ,--间隔循环时间
      prm_userid                         IN     VARCHAR2       --用户id
   ) 
   IS
      var_procNo      VARCHAR2(5);         --过程号  
      pragma autonomous_transaction;
      
   BEGIN
     
      INSERT INTO YHCIP_ORACLE_JOBS
        (JOBID, --代表一个定时任务
         JOBNAME, --定时任务的名称
         STARTTIME, --开始执行时间
         USERID, --执行的用户
         oraclejobid,
         what,
         interval) --oracle的jobid
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
         'LOG:创建成功');
         
     COMMIT;
   END insertYHCIP_ORACLE_JOBS;
  


   /*****************************************************************************
   ** 过程名称 insertYH_HTCONTRO
   ** 过程编号 ：05
   ** 业务环节 ：记录日志
   ** 功能描述 ：
   *****************************************************************************
   ** 作        作成日期 ：2016-07-19   版本编号 ：Ver 1.0.0
   ******************************************************************************
   ** 修    改：
   ******************************************************************************
   ** 备    注：prm_AppCode 构成是:过程编号（2位） ＋ 顺序号（2位）
   *****************************************************************************/
   PROCEDURE insertQRTZ_JOB_MSGS(
       prm_jobid  in  yhcip_oracle_jobs.jobid%TYPE,    --jobid
       prm_aab001 in  ab01.aab001%TYPE,                --单位id
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
                 prm_aab001||'日常年审欠费退费',
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
   ** 过程名称 insertYH_HTCONTRO
   ** 过程编号 ：05
   ** 业务环节 ：公共－年审导盘控制重复提交
   ** 功能描述 ：
   *****************************************************************************
   ** 作        作成日期 ：2016-07-19   版本编号 ：Ver 1.0.0
   ******************************************************************************
   ** 修    改：
   ******************************************************************************
   ** 备    注：prm_AppCode 构成是:过程编号（2位） ＋ 顺序号（2位）
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
   ** 过程名称 deleteYH_HTCONTRO
   ** 过程编号 ：06
   ** 业务环节 ：公共－年审导盘控制重复提交删除
   ** 功能描述 ：
   *****************************************************************************
   ** 作        作成日期 ：2016-07-19   版本编号 ：Ver 1.0.0
   ******************************************************************************
   ** 修    改：
   ******************************************************************************
   ** 备    注：prm_AppCode 构成是:过程编号（2位） ＋ 顺序号（2位）
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
