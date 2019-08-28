CREATE OR REPLACE PACKAGE BODY PKG_YEARAPPLY AS
   /********************************************************************************/
   /*  程序包名 ：PKG_YearApply                                                    */
   /*  业务环节 ：单位年申报                                                       */
   /*  对象列表 ：公共过程函数                                                     */
   /*             01 prc_YearSalaryAdjustPaded           年申报补差校验            */
   /*             02 prc_YearInternetApply               年审单位申报              */
   /*             03 prc_RBYearInternetApply             年审单位申报撤销          */
   /*             04 prc_YearSalary                      年申报--修改缴费工资      */
   /*              05 prc_YearSalaryBC                    年申报--补差              */
   /*             06 prc_YearSalaryBCByYL                年申报--养老补差          */
   /*  私有过程函数                                                                */
   /*             -----------------------业务处理过程------------------------------*/

   /*  其它说明 ：                                                                 */
   /*                                                                              */
   /*  完 成 人 ：                                                                 */
   /*  完成日期 ：2013-05-21                                                       */
   /*  版本编号 ：Ver 1.0                                                          */
   /*  审 查 人 ：×××                      审查日期 ：YYYY-MM-DD                   */
   /********************************************************************************/
   PRE_ERRCODE  CONSTANT VARCHAR2(18) := 'YearApply'; -- 本包的错误编号前缀
PROCEDURE prc_insertIRAC08A1(prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                             prm_aac001       IN     xasi2.ac01.aac001%TYPE,
                             prm_aae002       IN     NUMBER            ,--年审年度
                             prm_aae003       IN     NUMBER,
                             prm_aac040       IN     xasi2.ac02.aac040%TYPE,
                             prm_yae518       IN     xasi2.ac08a1.yae518%TYPE,
                             prm_aae076       IN     xasi2.ab08.aae076%TYPE,
                             prm_aae011       IN     irad31.aae011%TYPE,--经办人
                             prm_yab139       IN     VARCHAR2          ,--参保所属分中心
                             prm_AppCode      OUT    VARCHAR2          ,
                             prm_ErrorMsg     OUT    VARCHAR2          );
PROCEDURE prc_insertAC08A1  (prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                             prm_aac001       IN     xasi2.ac01.aac001%TYPE,
                             prm_aae002       IN     NUMBER            ,--年审年度
                             prm_aae003       IN     NUMBER,
                             prm_aac040       IN     xasi2.ac02.aac040%TYPE,
                             prm_yae518       IN     xasi2.ac08a1.yae518%TYPE,
                             prm_aae076       IN     xasi2.ab08.aae076%TYPE,
                             prm_aae140       IN     VARCHAR2,
                             prm_aae011       IN     irad31.aae011%TYPE,--经办人
                             prm_yab139       IN     VARCHAR2          ,--参保所属分中心
                             prm_AppCode      OUT    VARCHAR2          ,
                             prm_ErrorMsg     OUT    VARCHAR2          );

PROCEDURE prc_YearSalaryRB   ( prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                               prm_aae001       IN     NUMBER            ,--年审年度
                               prm_iaa011       IN     irad51.iaa011%TYPE,--业务类型
                               prm_yab019       IN     VARCHAR2     ,--类型标志
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          );

/*****************************************************************************
   ** 过程名称 : prc_YearSalaryAdjustPaded
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：年申报补差
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
PROCEDURE prc_YearSalaryAdjustPaded(prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                                    prm_aac001       IN     irac01.aac001%TYPE,--个人编号  非必填
                                    prm_aac040       IN     xasi2.ac02.aac040%TYPE, --工资 非必填
                                    prm_aae001       IN     NUMBER            ,--年审年度
                                    prm_aae011       IN     irad31.aae011%TYPE,--经办人
                                    prm_yab139       IN     VARCHAR2          ,--参保所属分中心
                                    prm_yab019       IN     xasi2.ac01k8.yab019%TYPE  ,--业务类型标志
                                    prm_AppCode      OUT    VARCHAR2          ,
                                    prm_ErrorMsg     OUT    VARCHAR2          )
   IS
       num_count     NUMBER;
      num_county     NUMBER;
      v_msg        VARCHAR2(300);
      var_aaz002   iraa01.aaz002%TYPE;
      num_aae041_year NUMBER(6);  --补差开始时间
      num_yae097   xasi2.ab02.yae097%TYPE; --单位最大做帐期号
      var_aae140   xasi2.ab02.aae140%TYPE; --险种
      var_aac001   xasi2.ac01.aac001%TYPE; --个人编号
      num_aae002   xasi2.ac08a1.aae002%TYPE;
      num_aac040   xasi2.ac02.aac040%TYPE;
      num_spgz     xasi2.ac02.aac040%TYPE;
      num_yac004   xasi2.ac02.yac004%TYPE;
      var_yab136   xasi2.ab01.yab136%TYPE;
      var_yab275   xasi2.ab01.yab275%TYPE;
      var_aae119   xasi2.ab01.aae119%TYPE;
      var_aab019   xasi2.ab01.aab019%TYPE;
      var_yac503   xasi2.ac02.yac503%TYPE;
      var_yac505   xasi2.ac02.yac505%TYPE;
      num_yac400   tmp_ac42.yac401%TYPE;
      num_yac401   tmp_ac42.yac401%type;           --1月补差金额,NUMBER
      num_yac402   tmp_ac42.yac401%type;           --2月补差金额,NUMBER
      num_yac403   tmp_ac42.yac401%type;           --3月补差金额,NUMBER
      num_yac404   tmp_ac42.yac401%type;           --4月补差金额,NUMBER
      num_yac405   tmp_ac42.yac401%type;           --5月补差金额,NUMBER
      num_yac406   tmp_ac42.yac401%type;           --6月补差金额,NUMBER
      num_yac407   tmp_ac42.yac401%type;           --7月补差金额,NUMBER
      num_yac408   tmp_ac42.yac401%type;           --8月补差金额,NUMBER
      num_yac409   tmp_ac42.yac401%type;           --9月补差金额,NUMBER
      num_yac410   tmp_ac42.yac401%type;           --10月补差金额,NUMBER
      num_yac411   tmp_ac42.yac401%type;           --11月补差金额,NUMBER
      num_yac412   tmp_ac42.yac401%type;           --12月补差金额,NUMBER
      var_procNo   VARCHAR2(5);                    --过程号
      var_aae013   tmp_ac42.aae013%TYPE;
      var_aae100   VARCHAR2(9);
      var_aae142   xasi2.aa02a3.aae142%TYPE;    --补差类型
      var_aac008   xasi2.ac01.aac008%TYPE;               --人员状态
      num_aic162   NUMBER(6);
      num_aae002_max NUMBER(6);
      num_yaa006   NUMBER(14,2);
      num_iaa100  NUMBER;
     --获取单位参保信息
      CURSOR cur_ab02 IS
       SELECT aae140,             --险种
              yae097              --最大做帐期号
         FROM xasi2.ab02
        WHERE aab001 = prm_aab001
          AND aab051 = xasi2.pkg_comm.AAB051_CBJF
          AND aae140 NOT IN (xasi2.pkg_comm.AAE140_DEYL,'08')    --大额不进行补差
          AND prm_yab019 = '1';
      --根据缴费记录获取需要补差的人员
      CURSOR cur_ab05a1 IS
        SELECT aac001,
               aab001,
               aac002,
               NVL(yac506,0) AS yac506,
               NVL(yac507,0) AS yac507,
               NVL(yac508,0) AS yac508,
               NVL(yac503,0) AS yac503,--工资类别
               NVL(aac040,0) AS aac040,--变更后缴费工资
               NVL(yac004,0) AS yac004,--变更后养老缴费基数
               NVL(yaa333,0) AS yaa333,--变更后缴费基数
               NVL(yac005,0) AS yac005--工伤缴费工资
          FROM xasi2.ac01k8
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND yab019 = prm_yab019
           AND (AAE013 is null or AAE013 ='1' or AAE013 ='2' or AAE013 ='22')
           AND (1 = NVL(prm_aac001,1) OR aac001 = NVL(prm_aac001,1));
      --获取临时表中的校验成功信息(医疗)
      CURSOR cur_tmp IS
        SELECT AAC001,       --个人编码,VARCHAR2
               AAE002,       --费款所属期号,NUMBER
               YAC505,       --个人缴费类别,VARCHAR2
               AAA040,       --缴费比例类别,VARCHAR2
               AAE140,       --险种,VARCHAR2
               AAE143,       --缴费类别,VARCHAR2
               YAC503,       --工资类型,VARCHAR2
               DECODE(aae100,xasi2.pkg_comm.AAE100_WX,0,AAC040) AS AAC040,       --缴费工资,NUMBER
               YAC004,       --个人缴费基数,NUMBER
               YAA333,       --划帐户基数,NUMBER
               YAE010,       --费用来源,VARCHAR2
               YAA330,       --缴费比例模式,VARCHAR2
               AAA041,       --个人缴费比例,NUMBER
               YAA017,       --个人缴费划入统筹比例,NUMBER
               AAA042,       --单位缴费比例,NUMBER
               AAA043,       --单位缴费划入帐户比例,NUMBER
               ALA080,       --工伤浮动费率,NUMBER
               AKC023,       --实足年龄,NUMBER
               YAC176,       --工龄,NUMBER
               AAC008,       --人员状态,VARCHAR2
               AKC021,       --医疗人员类别,VARCHAR2
               YKC120,       --医疗照顾人员类别,VARCHAR2
               YKC279,       --是否写享受信息标志,VARCHAR2
               YAC168,       --农民工标志,VARCHAR2
               YAA310,       --比例类别,VARCHAR2
               AAE114,       --缴费标志,VARCHAR2
               AAE100,       --有效标志,VARCHAR2
               AAE013        --备注,VARCHAR2
          FROM xasi2.tmp_grbs02  --个人补收
         WHERE aac001 = var_aac001
           AND aae140 = var_aae140;
           --AND aae100 = var_aae100;
        --获取临时表中的校验成功信息(养老)
      CURSOR cur_irac01c1 IS
        SELECT *
          FROM wsjb.irac01c1
         WHERE aab001 = prm_aab001
           AND yae031 = '1';
   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      var_procNo   :='Y01';
      --获取单位当前的管理类型
      BEGIN
         SELECT yab136,
                yab275,
                aae119,
                aab019
           INTO var_yab136,
                var_yab275,
                var_aae119,
                var_aab019
           FROM xasi2.ab01
          WHERE aab001 = prm_aab001;
      EXCEPTION
         WHEN OTHERS THEN
            prm_AppCode := ''||var_procNo||'02';
            prm_ErrorMsg  := '单位编码'||prm_aab001||'社保经办机构'||prm_yab139||'没有获取到单位基本信息';
            RETURN;
      END;

      --如果是个人工资必填
      IF prm_aac001 IS NOT NULL THEN
         IF prm_aac040 IS NULL THEN
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '工资不能为空';
            RETURN;
         END IF;
      END IF;
      --获取年审开始期号  取单位最大做帐期号下期
      SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(yae097),'yyyymm'),1),'yyyymm'))   --获取做帐期号
        INTO num_aae002
        FROM xasi2.ab02
       WHERE aab001 = prm_aab001;

      FOR rec_ab05a1 IN cur_ab05a1 LOOP
          var_aac001 := rec_ab05a1.aac001;
          num_aac040 := round(rec_ab05a1.aac040);

          IF prm_aac001 IS NOT NULL THEN
             num_aac040 := round(prm_aac040);
          END IF;
      --医疗四险的补差校验
          FOR rec_ab02 IN cur_ab02 LOOP

              var_aae140 := rec_ab02.aae140;
              num_yae097 := rec_ab02.yae097;

              --获取单位各险种的补差结束期号

              --获取补差的开始时间
              BEGIN
                SELECT aae041,           --补差开始时间
                       aae142
                  INTO num_aae041_year,
                       var_aae142
                  FROM xasi2.aa02a3
                 WHERE aae140 = var_aae140
                   AND aae001 = prm_aae001
                   AND yab139 = prm_yab139;
                EXCEPTION
                     WHEN OTHERS THEN
                          prm_AppCode  :=  gn_def_ERR;
                          prm_ErrorMsg := var_aae140||'获取年审补差参数异常'||prm_aae001||prm_yab139;
                          RETURN;
              END;
              IF var_aae142 = '1' THEN   --如果补差类型为针对正常参保人员
                 SELECT count(1)
                   INTO num_count
                   FROM xasi2.ac02
                  WHERE aac001 = var_aac001
                    AND aab001 = prm_aab001
                    AND aae140 = var_aae140
                    AND aac031 = xasi2.pkg_comm.AAC031_CBJF;

                 --查询人员状态  主要区分是否是退休、待退人员 因为退休、待退人员也要进行补差
                 SELECT count(1)
                   INTO num_county
                   FROM xasi2.ac01
                  WHERE aac001 = var_aac001;
              IF num_count>0 THEN
                 SELECT AAC008
                   INTO var_aac008
                   FROM xasi2.ac01
                  WHERE aac001 = var_aac001;
               END IF;
                 --如果人员没有在本单位的正常参保信息并且为在职人员则不进行补差
                 IF num_count < 1 OR var_aac008 = xasi2.pkg_comm.AAC008_TX THEN
                    GOTO leb_next;
                 END IF;
              END IF;
              --如果补差开始时间晚于单位最大做帐期号则不进行补差
              IF num_aae041_year <= num_yae097 THEN
                      --获取人员补差信息
                      IF rec_ab05a1.yac508 > 0  THEN   --如果原缴费基数大于0则说明这个人参加医疗四险

                         IF var_aae140 = xasi2.pkg_comm.aae140_GS THEN
                             var_yac503 := xasi2.pkg_comm.YAC503_SB;
                             var_yac505 := xasi2.pkg_comm.YAC505_GSPT;
                         ELSE
                            BEGIN
                              SELECT yac503,
                                     YAC505
                                INTO var_yac503,
                                     var_yac505
                                FROM xasi2.ac02
                               WHERE aac001 = var_aac001
                                 AND aae140 = var_aae140;
                             EXCEPTION
                                  WHEN OTHERS THEN

                                       IF var_aae140 = xasi2.pkg_comm.AAE140_SYE THEN
                                          var_yac505 := xasi2.pkg_comm.YAC505_SYEPT;
                                       END IF;

                                       IF var_aae140 = xasi2.pkg_comm.AAE140_JBYL THEN
                                          var_yac505 := xasi2.pkg_comm.YAC505_YLPT;
                                       END IF;

                                       IF var_aae140 = xasi2.pkg_comm.AAE140_SYU THEN
                                          var_yac505 := xasi2.pkg_comm.YAC505_SYUPT;
                                       END IF;

     /*                                  IF var_aae140 = xasi2.pkg_comm.AAE140_JGYL THEN
                                          var_yac505 := xasi2.pkg_comm.YAC505_JGYLPT;
                                       END IF;*/
                            END;
                            --工资类别写死 为申报工资
                            var_yac503 := xasi2.pkg_comm.YAC503_SB;

                         END IF;

                         IF var_aae140 <> '06' THEN
                             --调用保底封顶过程，获取缴费基数和缴费工资
                              SELECT MAX(aae041)
                                INTO num_aae002_max
                                FROM xasi2.AA02
                               WHERE yaa001 = '16'
                                 AND aae140 = var_aae140
                                 AND aae001 = prm_aae001;
                             xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase
                                                                   (var_aac001   ,     --个人编码
                                                                    prm_aab001   ,     --单位编码
                                                                    num_aac040   ,     --缴费工资
                                                                    var_yac503   ,     --工资类别
                                                                    var_aae140   ,     --险种类型
                                                                    var_yac505   ,     --缴费人员类别
                                                                    var_yab136   ,     --单位管理类型（区别独立缴费人员）
                                                                    num_aae002_max   ,     --费款所属期
                                                                    prm_yab139   ,     --参保分中心
                                                                    num_yac004   ,     --缴费基数
                                                                    prm_AppCode  ,     --错误代码
                                                                    prm_ErrorMsg );    --错误内容
                             IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                                RETURN;
                             END IF;
                             
                             
                              --判断个体工商户(2019年以前工伤险是社平)
                              IF var_aab019 = '60' and prm_aae001<2019 THEN
                                  --获取社平工资
                                  num_spgz := xasi2.pkg_comm.fun_GetAvgSalary(var_aae140,'16',num_aae002_max,PKG_Constant.YAB003_JBFZX);
                                  --如果险种为工伤 缴费工资和缴费基数为社平工资
                                   IF var_aae140 = xasi2.pkg_comm.AAE140_GS THEN
                                       num_yac004 := ROUND(num_spgz/12);
                                   ELSE
                                      IF num_aac040 > ROUND(num_spgz/12) THEN
                                       num_yac004 := ROUND(num_spgz/12);
                                      END  IF;
                                   END IF;
                             END IF;  
                             
                             IF var_yac503 = xasi2.pkg_comm.YAC503_LRYLJ THEN
                                num_yac004 := rec_ab05a1.yaa333;
                             END IF;
                         ELSE
                           num_yac004 := rec_ab05a1.yac004;
                         END IF;

                         IF var_aae140 = xasi2.pkg_comm.AAE140_JBYL THEN
                             --退休逐月缴费人员
                             SELECT count(1)
                               INTO num_count
                               FROM xasi2.ac02_zy
                              WHERE aac001 = var_aac001
                                AND aae120 = '0';
                              IF num_count > 0 THEN
                                 SELECT aic162,
                                        yac004
                                   INTO num_aic162,
                                        num_yac004
                                   FROM xasi2.ac02_zy
                                  WHERE aac001 = var_aac001
                                    AND aae120 = '0';
                                 IF SUBSTR(num_aic162,0,4)= prm_aae001 THEN
                                    num_spgz := xasi2.pkg_comm.fun_GetAvgSalary(var_aae140,'16',prm_aae001||'12',PKG_Constant.YAB003_JBFZX);
                                    num_yac004 := ROUND(num_spgz/12);
                                 END IF;
                              END IF;
                          END IF;

                          DELETE xasi2.tmp_grbs01;                 --清空临时表
                          --插入补差临时表中
                          INSERT INTO xasi2.tmp_grbs01
                                               (aac001,   --个人编码
                                                aae041,   --开始期号
                                                aae042,   --终止期号
                                                aae140,   --险种
                                                yac503,   --工资类别
                                                aac040,   --缴费工资
                                                yaa333,   --帐户基数
                                                aae100,   --有效标志
                                                aae013    --备注
                                                )
                                        VALUES (var_aac001,
                                                num_aae041_year,
                                                num_yae097,
                                                var_aae140,
                                                var_yac503,                                    --工资类别
                                                num_yac004,                           --变更后缴费工资  如果是工伤险种则取工伤的缴费工资 主要为了区分个体单位
                                                rec_ab05a1.yaa333,
                                                NULL,
                                                NULL);
                          --调用补差检查的过程
                         /* xasi2.pkg_p_payAdjust.prc_p_checkData(
                                                                  prm_aab001 ,   --单位编号
                                                                  '1'   ,   --补差方式（0 缴费比例补差， 1 缴费基数补差）
                                                                  prm_yab139 ,   --参保所属分中心
                                                                  prm_yab139 ,   --社保经办机构
                                                                  prm_AppCode,   --执行代码
                                                                  prm_ErrorMsg   --执行结果
                                                                 );
                          IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                             RETURN;
                          END IF;*/

                          --modify by fenggg at 20181208 begin
                          --年审校验将原来的过程 （xasi2.pkg_p_payAdjust.prc_p_checkData） 替换为
                          --调用市局年审校验过程 （xasi2.pkg_p_salaryexamineadjust.prc_p_checkData），
                          --往年年审用往年基数计算补差基数
                          xasi2.pkg_p_salaryexamineadjust.prc_p_checkData(
                                                                  prm_aab001 ,   --单位编号
                                                                  '1'   ,   --补差方式（0 缴费比例补差， 1 缴费基数补差）
                                                                  prm_yab139 ,   --参保所属分中心
                                                                  prm_yab139 ,   --社保经办机构
                                                                  prm_AppCode,   --执行代码
                                                                  prm_ErrorMsg   --执行结果
                                                                 );
                          IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                             RETURN;
                          END IF;
                          --modify by fenggg at 20181208 end

                          --获取补差校验成功信息
--                          SELECT count(1)
--                            INTO num_count
--                            FROM xasi2_zs.tmp_grbs02
--                           WHERE aae100 = xasi2_zs.pkg_comm.AAE100_YX
--                             AND aac001 = var_aac001;
--
--                             var_aae100 := xasi2_zs.pkg_comm.AAE100_WX;
--                             IF var_aae140 = '04' THEN
--                             FOR rec_tmp1 IN cur_tmp LOOP
--                                 var_aae013 := var_aae013||rec_tmp1.AAE002||',';
--                             END LOOP;
--                             prm_AppCode  :=  gn_def_ERR;
--                             prm_ErrorMsg := num_yae097||num_aae041_year||var_aae140||'医疗补差校验全部失败!'|| var_aae013;
--                             RETURN;
--                             END IF;
--

                          --var_aae100 := xasi2_zs.pkg_comm.AAE100_YX;
                          --变量初始化
                          num_yac400 := 0;
                          num_yac401 := 0;
                          num_yac402 := 0;
                          num_yac403 := 0;
                          num_yac404 := 0;
                          num_yac405 := 0;
                          num_yac406 := 0;
                          num_yac407 := 0;
                          num_yac408 := 0;
                          num_yac409 := 0;
                          num_yac410 := 0;
                          num_yac411 := 0;
                          num_yac412 := 0;

                          --获取校验成功的信息放入查询表中
                          FOR rec_tmp IN cur_tmp LOOP
                              var_aae013 := rec_tmp.aae013;
                              num_yac400 := rec_tmp.AAC040;
                               --检查是否为退休人员缴费
--                               SELECT SUM(aaa)
--                                 INTO num_count
--                                 FROM (
--                                        SELECT count(1) AS aaa
--                                          FROM ac08a1
--                                         WHERE aac001 = var_aac001
--                                           AND aab001 = prm_aab001
--                                           AND aae140 = var_aae140
--                                           AND aae002 = rec_tmp.aae002
--                                           AND akc021 = xasi2_zs.pkg_comm.AKC021_TX
--                                        UNION
--                                        SELECT count(1)
--                                          FROM ac08
--                                         WHERE aac001 = var_aac001
--                                           AND aab001 = prm_aab001
--                                           AND aae140 = var_aae140
--                                           AND aae002 = rec_tmp.aae002
--                                           AND akc021 = xasi2_zs.pkg_comm.AKC021_TX
--                                        );
--                                IF num_count > 0 THEN
--                                   num_yac400 := 0;
--                                END IF;
                              IF rec_tmp.aae002 = prm_aae001||'01' THEN
                                 num_yac401 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'02' THEN
                                 num_yac402 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'03' THEN
                                 num_yac403 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'04' THEN
                                 num_yac404 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'05' THEN
                                 num_yac405 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'06' THEN
                                 num_yac406 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'07' THEN
                                 num_yac407 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'08' THEN
                                 num_yac408 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'09' THEN
                                 num_yac409 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'10' THEN
                                 num_yac410 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'11' THEN
                                 num_yac411 := num_yac400;
                              END IF;

                              IF rec_tmp.aae002 = prm_aae001||'12' THEN
                                 num_yac412 := num_yac400;
                              END IF;
                          END LOOP;

                        --插入补差临时表中  主要为了页面显示
                        SELECT count(1)
                          INTO num_count
                          FROM wsjb.tmp_ac42
                         WHERE aac001 = var_aac001
                           AND aab001 = prm_aab001
                           AND aae001 = prm_aae001
                           AND aae140 = var_aae140;
                        IF num_count < 1 THEN
                            INSERT INTO wsjb.tmp_ac42 (AAC001,             --人员编号,VARCHAR2
                                                 AAB001,             --单位编号,VARCHAR2
                                                 AAE140,             --险种,VARCHAR2
                                                 YAC401,             --1月补差金额,NUMBER
                                                 YAC402,             --2月补差金额,NUMBER
                                                 YAC403,             --3月补差金额,NUMBER
                                                 YAC404,             --4月补差金额,NUMBER
                                                 YAC405,             --5月补差金额,NUMBER
                                                 YAC406,             --6月补差金额,NUMBER
                                                 YAC407,             --7月补差金额,NUMBER
                                                 YAC408,             --8月补差金额,NUMBER
                                                 YAC409,             --9月补差金额,NUMBER
                                                 YAC410,             --10月补差金额,NUMBER
                                                 YAC411,             --11月补差金额,NUMBER
                                                 YAC412,             --12月补差金额,NUMBER
                                                 aae013,
                                                 aae001)
                                         VALUES (var_aac001,
                                                 prm_aab001,
                                                 var_aae140,
                                                 NVL(num_yac401,0),
                                                 NVL(num_yac402,0),
                                                 NVL(num_yac403,0),
                                                 NVL(num_yac404,0),
                                                 NVL(num_yac405,0),
                                                 NVL(num_yac406,0),
                                                 NVL(num_yac407,0),
                                                 NVL(num_yac408,0),
                                                 NVL(num_yac409,0),
                                                 NVL(num_yac410,0),
                                                 NVL(num_yac411,0),
                                                 NVL(num_yac412,0),
                                                 var_aae013,
                                                 prm_aae001);
                           ELSE
                               UPDATE wsjb.tmp_ac42
                                  SET YAC401 = NVL(num_yac401,0),
                                     YAC402 = NVL(num_yac402,0),
                                     YAC403 = NVL(num_yac403,0),
                                     YAC404 = NVL(num_yac404,0),
                                     YAC405 = NVL(num_yac405,0),
                                     YAC406 = NVL(num_yac406,0),
                                     YAC407 = NVL(num_yac407,0),
                                     YAC408 = NVL(num_yac408,0),
                                     YAC409 = NVL(num_yac409,0),
                                     YAC410 = NVL(num_yac410,0),
                                     YAC411 = NVL(num_yac411,0),
                                     YAC412 = NVL(num_yac412,0),
                                     aae013 = var_aae013
                               WHERE aac001 = var_aac001
                                 AND AAB001 = prm_aab001
                                 AND aae140 = var_aae140
                                 AND aae001 = prm_aae001;
                           END IF;
                       END IF;

            END IF;
            <<leb_next>>
            NULL;
          END LOOP;
      END LOOP;


      --养老的补差校验
      IF prm_yab019 <> '2' THEN
      var_aae140 := pkg_Constant.AAE140_YL;
      DELETE xasi2.tmp_grbs01;
      DELETE xasi2.tmp_grbs02;

      BEGIN
        SELECT aae041           --补差开始时间
          INTO num_aae041_year
          FROM xasi2.aa02a3
         WHERE aae140 = var_aae140
           AND aae001 = prm_aae001
           AND yab139 = prm_yab139;
        EXCEPTION
             WHEN OTHERS THEN
                  prm_AppCode  :=  gn_def_ERR;
                  prm_ErrorMsg := '获取年审补差参数异常';
                  RETURN;
      END;
      --养老取年审开始期号 最大做帐期号下期
     SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(aae003),'yyyymm'),1),'yyyymm'))   --获取做帐期号
        INTO num_aae002
        FROM wsjb.irab08
       WHERE AAB001 = prm_aab001
         AND yae517 = 'H01'
         AND aae140 = var_aae140;

      --取养老的最大做帐期号
      SELECT NVL(MAX(aae003),0)
        INTO num_yae097
        FROM wsjb.irab08
       WHERE AAB001 = prm_aab001
         AND yae517 = 'H01'
         AND aae140 = var_aae140;

      --如果补差开始时间大于单位最大做帐期号则不进行补差
      IF num_aae041_year <= num_yae097 THEN
          IF num_yae097 > 0 THEN   --判断单位是否有养老的缴费信息
              FOR rec_ab05a1 IN cur_ab05a1 LOOP
                  num_yac400 := 0;
                  num_yac401 := 0;
                  num_yac402 := 0;
                  num_yac403 := 0;
                  num_yac404 := 0;
                  num_yac405 := 0;
                  num_yac406 := 0;
                  num_yac407 := 0;
                  num_yac408 := 0;
                  num_yac409 := 0;
                  num_yac410 := 0;
                  num_yac411 := 0;
                  num_yac412 := 0;
                  IF rec_ab05a1.yac507 >0 THEN --如果原养老缴费基数大于0则说明该人员参加养老保险
                     --如果是个人查看则工资为传入参数
                     var_aac001 := rec_ab05a1.aac001;

                     --判断养老是否提前申请结算 如果养老提前结算则不进行补差(又续回来的人除外)
                      SELECT count(1)
                        INTO num_count
                        FROM wsjb.irad51a1
                       WHERE aac001 = var_aac001
                         and aab001 = prm_aab001
                         AND yae031 = '1'
                         and aae041 = prm_aae001||'01'
                         and not exists (select 1 from xasi2.ac01k8 where aac001=var_aac001 and aab001=prm_aab001 and aae001=prm_aae001 and aae013='22');
                      IF num_count > 0 THEN
                         GOTO leb_next1;
                      END IF;
                     IF prm_aac001 IS NOT NULL THEN
                        num_aac040 := round(prm_aac040);
                     ELSE
                        num_aac040 := round(rec_ab05a1.aac040);
                     END IF;


                    SELECT MAX(aae041)
                      INTO num_aae002_max
                      FROM xasi2.AA02
                     WHERE yaa001 = '16'
                       AND aae140 = var_aae140
                       AND aae001 = prm_aae001;
                       
                      /*
                     xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase(var_aac001,                --个人编码
                                                                      prm_aab001,                --单位编码
                                                                      num_aac040,                --缴费工资
                                                                      xasi2.pkg_comm.YAC503_SB,--工资类别
                                                                      var_aae140,                --险种类型
                                                                      '010',                --缴费人员类别
                                                                      var_yab136,                --单位管理类型（区别独立缴费人员）
                                                                      num_aae002_max,                --费款所属期
                                                                      prm_yab139,                --参保分中心
                                                                      num_yac004,                --缴费基数
                                                                      prm_AppCode,              --错误代码
                                                                      prm_ErrorMsg);            --错误内容
                     
                                                                                        
                      IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                         RETURN;
                      END IF;
                      */   
               -- 使用高新保底封顶 (养老个体工商已处理)     
               SELECT pkg_common.fun_p_getcontributionbase(
                                                    null,                                        --个人编码 aac001
                                                    prm_aab001,                          --单位编码 aab001
                                                    ROUND(num_aac040),          --缴费工资 aac040
                                                    '0',                                          --工资类别 yac503
                                                    var_aae140,                            --险种类型 aae140
                                                    '1',                                          --缴费人员类别 yac505
                                                    var_yab136,                            --单位管理类型（区别独立缴费人员） yab136
                                                    num_aae002_max,                  --费款所属期 aae002
                                                    prm_yab139)                          --参保分中心 yab139
                  INTO num_yac004
               FROM dual;
                         
                      --当年社平未公布
                      SELECT count(1)
                        INTO num_count
                        FROM xasi2.AA02
                       WHERE yaa001 = '16'
                         AND aae140 = var_aae140
                         AND aae001 = prm_aae001;
                      IF num_count < 2 THEN
                         SELECT yaa006
                           INTO num_yaa006
                           FROM xasi2.aa02a2
                          WHERE aae140 = '01'
                            and aae041 = num_aae002_max
                            AND yaa025 = '1';

                         IF num_aac040 = num_yaa006 THEN
                            num_aac040 := TRUNC(num_aac040*1.1);
                         END IF;
                      END IF;
                      
                      --判断个体工商户(2019年以前养老险是社平的40%)
                      IF var_aab019 = '60' and  prm_aae001<2019 THEN
                         --获取社平工资
                         num_spgz := xasi2.pkg_comm.fun_GetAvgSalary(var_aae140,'16',num_aae002_max,PKG_Constant.YAB003_JBFZX);
                         num_yac004 := num_aac040;
                            IF num_aac040 < TRUNC(num_spgz/12*0.4)+1 THEN
                               num_yac004 := TRUNC(num_spgz/12*0.4)+1;
                            END IF;
                            IF num_aac040 > ROUND(num_spgz/12) THEN
                               num_yac004 := ROUND(num_spgz/12);
                            END  IF;
                       END IF;
                       
                     DELETE xasi2.tmp_grbs01;


                          --插入补差临时表中
                     INSERT INTO xasi2.tmp_grbs01(aac001,          --个人编码
                                                     aae041,          --开始期号
                                                     aae042,          --终止期号
                                                     aae140,          --险种
                                                     yac503,          --工资类别
                                                     aac040,          --缴费工资
                                                     yaa333,          --帐户基数
                                                     aae100,          --有效标志
                                                     aae013)
                                             VALUES (var_aac001,
                                                     num_aae041_year,
                                                     num_yae097,
                                                     var_aae140,
                                                     xasi2.pkg_comm.YAC503_SB,--工资类别
                                                     num_yac004,--变更后缴费工资  如果是工伤险种则取工伤的缴费工资 主要为了区分个体单位
                                                     rec_ab05a1.yac004,
                                                     NULL,
                                                     NULL);
                          --调用养老补差检查的过程
                        prc_p_checkData(prm_aab001 ,   --单位编号
                                        prm_yab139 ,   --参保所属分中心
                                        prm_yab139 ,   --社保经办机构
                                        prm_AppCode,   --执行代码
                                        prm_ErrorMsg); --执行结果
                        IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                           RETURN;
                        END IF;

                        --获取校验成功的信息放入查询表中
                        FOR rec_tmp IN cur_tmp LOOP
                            var_aae013 := rec_tmp.aae013;

                            IF rec_tmp.aae002 = prm_aae001||'01' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '01';
                               if num_count = 0 then
                                  num_yac401 := rec_tmp.AAC040;
                               else
                                  num_yac401 := 0;
                               end if;                     
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'02' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '02';
                               if num_count = 0 then
                                  num_yac402 := rec_tmp.AAC040;
                               else
                                  num_yac402 := 0;
                               end if;  
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'03' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '03';
                               if num_count = 0 then
                                  num_yac403 := rec_tmp.AAC040;
                               else
                                  num_yac403 := 0;
                               end if;  
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'04' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '04';
                               if num_count = 0 then
                                  num_yac404 := rec_tmp.AAC040;
                               else
                                  num_yac404 := 0;
                               end if;
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'05' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '05';
                               if num_count = 0 then
                                  num_yac405 := rec_tmp.AAC040;
                               else
                                  num_yac405 := 0;
                               end if;
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'06' THEN
                               select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '06';
                               if num_count = 0 then
                                  num_yac406 := rec_tmp.AAC040;
                               else
                                  num_yac406 := 0;
                               end if;
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'07' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '07';
                               if num_count = 0 then
                                  num_yac407 := rec_tmp.AAC040;
                               else
                                  num_yac407 := 0;
                               end if;
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'08' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '08';
                               if num_count = 0 then
                                  num_yac408 := rec_tmp.AAC040;
                               else
                                  num_yac408 := 0;
                               end if;
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'09' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '09';
                               if num_count = 0 then
                                  num_yac409 := rec_tmp.AAC040;
                               else
                                  num_yac409 := 0;
                               end if;
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'10' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '10';
                               if num_count = 0 then
                                  num_yac410 := rec_tmp.AAC040;
                               else
                                  num_yac410 := 0;
                               end if;
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'11' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '11';
                               if num_count = 0 then
                                  num_yac411 := rec_tmp.AAC040;
                               else
                                  num_yac411 := 0;
                               end if;
                            END IF;

                            IF rec_tmp.aae002 = prm_aae001||'12' THEN
                             select count(1)
                               into num_count
                               from wsjb.irad51a1 a, wsjb.irad51a2 b
                              where a.aab001 = prm_aab001
                                and a.aac001 = var_aac001
                                and a.aac001 = b.aac001
                                and aae002 = prm_aae001 || '12';
                               if num_count = 0 then
                                  num_yac412 := rec_tmp.AAC040;
                               else
                                  num_yac412 := 0;
                               end if;
                            END IF;
                        END LOOP;
                        <<leb_next1>>
                        --插入补差临时表中  主要为了页面显示
                        SELECT count(1)
                          INTO num_count
                          FROM wsjb.tmp_ac42
                         WHERE aac001 = var_aac001
                           AND aab001 = prm_aab001
                           AND aae001 = prm_aae001
                           AND aae140 = var_aae140;
                        IF num_count < 1 THEN
                            INSERT INTO wsjb.tmp_ac42 (AAC001,             --人员编号,VARCHAR2
                                                 AAB001,             --单位编号,VARCHAR2
                                                 AAE140,             --险种,VARCHAR2
                                                 YAC401,             --1月补差金额,NUMBER
                                                 YAC402,             --2月补差金额,NUMBER
                                                 YAC403,             --3月补差金额,NUMBER
                                                 YAC404,             --4月补差金额,NUMBER
                                                 YAC405,             --5月补差金额,NUMBER
                                                 YAC406,             --6月补差金额,NUMBER
                                                 YAC407,             --7月补差金额,NUMBER
                                                 YAC408,             --8月补差金额,NUMBER
                                                 YAC409,             --9月补差金额,NUMBER
                                                 YAC410,             --10月补差金额,NUMBER
                                                 YAC411,             --11月补差金额,NUMBER
                                                 YAC412,             --12月补差金额,NUMBER
                                                 aae013,
                                                 aae001)
                                         VALUES (var_aac001,
                                                 prm_aab001,
                                                 var_aae140,
                                                 NVL(num_yac401,0),
                                                 NVL(num_yac402,0),
                                                 NVL(num_yac403,0),
                                                 NVL(num_yac404,0),
                                                 NVL(num_yac405,0),
                                                 NVL(num_yac406,0),
                                                 NVL(num_yac407,0),
                                                 NVL(num_yac408,0),
                                                 NVL(num_yac409,0),
                                                 NVL(num_yac410,0),
                                                 NVL(num_yac411,0),
                                                 NVL(num_yac412,0),
                                                 var_aae013,
                                                 prm_aae001);
                           ELSE
                               UPDATE wsjb.tmp_ac42
                                  SET YAC401 = NVL(num_yac401,0),
                                     YAC402 = NVL(num_yac402,0),
                                     YAC403 = NVL(num_yac403,0),
                                     YAC404 = NVL(num_yac404,0),
                                     YAC405 = NVL(num_yac405,0),
                                     YAC406 = NVL(num_yac406,0),
                                     YAC407 = NVL(num_yac407,0),
                                     YAC408 = NVL(num_yac408,0),
                                     YAC409 = NVL(num_yac409,0),
                                     YAC410 = NVL(num_yac410,0),
                                     YAC411 = NVL(num_yac411,0),
                                     YAC412 = NVL(num_yac412,0),
                                     aae013 = var_aae013
                               WHERE aac001 = var_aac001
                                 AND AAB001 = prm_aab001
                                 AND aae140 = var_aae140
                                 AND aae001 = prm_aae001;
                           END IF;
                  END IF;
                    NULL;
              END LOOP;
          END IF;
       END IF;
       END IF;
   EXCEPTION
        WHEN OTHERS THEN
        /*关闭打开的游标*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '数据库错误:'||PRE_ERRCODE || SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() ;
             RETURN;
END prc_YearSalaryAdjustPaded;
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
                         prm_ErrMsg     OUT    VARCHAR2)              --错误信息
   IS
      var_procNo            VARCHAR2(5);             --过程号
      num_yac004_old        NUMBER;
      num_YAA333_old        NUMBER;
      num_aaa041_old        NUMBER;                  --个人缴费比例
      num_aaa042_old        NUMBER;                  --单位缴费比例
      num_yaa017_old        NUMBER;                  --个人缴费划统筹比例
      num_aaa043_old        NUMBER;                  --单位缴费划账户比例
      var_yac503            xasi2.ac02.yac503%TYPE;
      num_aac040            NUMBER;
      num_yaa028            NUMBER;
      num_count             NUMBER;
      var_yac168            xasi2.ac01.yac168%TYPE;
      num_aae003            NUMBER;
      var_yac505            xasi2.ac02.yac505%TYPE;
      var_aae119            xasi2.ab01.aae119%TYPE;
      var_akc021            xasi2.kc01.akc021%TYPE;
      prm_aac040_new        NUMBER;
      num_i                 NUMBER;
      var_flag              NUMBER;
      num_aae180            NUMBER;
      var_yae010            xasi2.ab08.yae010%TYPE;
      var_aac001             xasi2.ac01.aac001%TYPE;
   BEGIN
      /*初化变量*/
      prm_AppCode    := gn_def_OK ;
      prm_ErrMsg     := ''                  ;
      var_procNo     := 'A02';
      prm_aac040_new := prm_aac040;
      num_aae003  := TO_NUMBER(TO_CHAR(SYSDATE,'yyyymm'));

      --检查是否存在应缴的补差数据
      SELECT COUNT(yae202)
        INTO num_count
        FROM wsjb.irac08a1
       WHERE aab001 = prm_aab001
         AND aac001 = prm_aac001
         AND aae140 = prm_aae140
         AND aae002 = prm_aae002
         AND aae143 IN (xasi2.pkg_comm.AAE143_JSBC,        -- 基数补差
                        xasi2.pkg_comm.AAE143_BLBC);       -- 比例补差

      IF num_count > 0 THEN
         prm_AppCode := ''||var_procNo||'01';
         prm_ErrMsg  := '单位:'||prm_aab001||
                        ';人员:'||prm_aac001||
                        ';险种:'||xasi2.pkg_COMM.fun_getAaa103('aae140',prm_aae140)||
                        ';期号:'||prm_aae002||
                        '存在未缴费的差额补收信息，请先撤销之前补差信息，再进行本次补差操作！';
         RETURN;
      END IF ;

      --获取应缴实缴信息

         --获取相对应期应实缴信息
         BEGIN
            SELECT NVL(SUM(CASE WHEN aae143 IN(xasi2.pkg_comm.AAE143_ZCJF,  --正常缴费
                                               xasi2.pkg_comm.AAE143_BJ  ,  --补缴
                                               xasi2.pkg_comm.AAE143_BS  ,  --补收
                                               xasi2.pkg_comm.AAE143_JSBC,  --基数补差
                                               xasi2.pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                               xasi2.pkg_comm.AAE143_DLJF)  --独立人员缴费
                                THEN aae180
                                ELSE 0
                                END),0),  --缴费基数
                   NVL(SUM(CASE WHEN aae143 IN(xasi2.pkg_comm.AAE143_ZCJF, --正常缴费
                                               xasi2.pkg_comm.AAE143_BJ  , --补缴
                                               xasi2.pkg_comm.AAE143_BS  , --补收
                                               xasi2.pkg_comm.AAE143_JSBC, --基数补差
                                               xasi2.pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                               xasi2.pkg_comm.AAE143_DLJF) --独立人员缴费
                                THEN YAA333
                                ELSE 0
                                END),0)  --划帐户基数

              INTO num_yac004_old,                  --缴费基数
                   num_YAA333_old                  --划账户比例

              FROM
                   (SELECT aae143,
                           aae180,
                           YAA333
                      FROM wsjb.irac08a1  a
                     WHERE aac001 = prm_aac001
                       AND aab001 = prm_aab001
                       AND aae002 = prm_aae002
                       AND yab139 = prm_yab139
                       AND aae140 = prm_aae140
                       AND aae143 IN(xasi2.pkg_comm.AAE143_ZCJF, --正常缴费
                                     xasi2.pkg_comm.AAE143_JSBC, --基数补差
                                     xasi2.pkg_comm.AAE143_BJ  , --补缴
                                     xasi2.pkg_comm.AAE143_BS  , --补收
                                     xasi2.pkg_comm.AAE143_DLJF, --独立人员缴费
                                     xasi2.pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                     xasi2.pkg_comm.AAE143_BLBC) --比例补差
                      AND NOT EXISTS(SELECT 1
                                       FROM wsjb.irac01c1  b
                                      WHERE yae031='1'
                                        AND b.aac001 = a.aac001
                                        AND b.iaa100 = a.aae002
                                        AND b.aab001 = a.aab001)

                     )
                     ;

        IF num_yac004_old = 0 AND num_YAA333_old=0 THEN
        BEGIN

          SELECT aac001
            INTO var_aac001
            FROM wsjb.irac01c1
           WHERE yab029 = prm_aac001
             AND yae031='1'
             AND iaa100 = prm_aae002
             AND aab001 = prm_aab001;

          SELECT NVL(SUM(CASE WHEN aae143 IN(xasi2.pkg_comm.AAE143_ZCJF,  --正常缴费
                                               xasi2.pkg_comm.AAE143_BJ  ,  --补缴
                                               xasi2.pkg_comm.AAE143_BS  ,  --补收
                                               xasi2.pkg_comm.AAE143_JSBC,  --基数补差
                                               xasi2.pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                               xasi2.pkg_comm.AAE143_DLJF)  --独立人员缴费
                                THEN aae180
                                ELSE 0
                                END),0),  --缴费基数
                   NVL(SUM(CASE WHEN aae143 IN(xasi2.pkg_comm.AAE143_ZCJF, --正常缴费
                                               xasi2.pkg_comm.AAE143_BJ  , --补缴
                                               xasi2.pkg_comm.AAE143_BS  , --补收
                                               xasi2.pkg_comm.AAE143_JSBC, --基数补差
                                               xasi2.pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                               xasi2.pkg_comm.AAE143_DLJF) --独立人员缴费
                                THEN YAA333
                                ELSE 0
                                END),0)  --划帐户基数

              INTO num_yac004_old,                  --缴费基数
                   num_YAA333_old                  --划账户比例

              FROM
                   (SELECT aae143,
                           aae180,
                           YAA333
                      FROM wsjb.irac08a1  a
                     WHERE aac001 = var_aac001
                       AND aab001 = prm_aab001
                       AND aae002 = prm_aae002
                       AND yab139 = prm_yab139
                       AND aae140 = prm_aae140
                       AND aae143 IN(xasi2.pkg_comm.AAE143_ZCJF, --正常缴费
                                     xasi2.pkg_comm.AAE143_JSBC, --基数补差
                                     xasi2.pkg_comm.AAE143_BJ  , --补缴
                                     xasi2.pkg_comm.AAE143_BS  , --补收
                                     xasi2.pkg_comm.AAE143_DLJF, --独立人员缴费
                                     xasi2.pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                     xasi2.pkg_comm.AAE143_BLBC) --比例补差

                      AND  EXISTS(SELECT 1
                                       FROM wsjb.irac01c1  b
                                      WHERE yae031='1'
                                        AND b.aac001 = a.aac001
                                        AND b.iaa100 = a.aae002
                                        AND b.aab001 = a.aab001)
                     )
                     ;
               EXCEPTION
                WHEN OTHERS THEN
                   prm_AppCode := ''||var_procNo||'01';
                   prm_ErrMsg  := '没有获取险种类型为'||xasi2.pkg_COMM.fun_getAaa103('aae140',prm_aae140)||prm_aae002||'的缴费信息';
                   RETURN;
                   END;
          END IF;
                EXCEPTION
                WHEN OTHERS THEN
                   prm_AppCode := ''||var_procNo||'01';
                   prm_ErrMsg  := '没有获取险种类型为'||xasi2.pkg_COMM.fun_getAaa103('aae140',prm_aae140)||prm_aae002||'的缴费信息';
                   RETURN;
         END;



         BEGIN
            --获取irac08a1非补差缴费的缴费工资类别和费用来源等
          SELECT yac503,
                 aae180,
                 yae010,
                 yac505,
                 xasi2.pkg_comm.AAE114_QJ AS aae114
            INTO var_yac503,
                 num_aac040,
                 var_yae010,
                 prm_yac505_old,                  --参保缴费人员类别
                 prm_aae114_old
            FROM wsjb.irac08a1  a
           WHERE aac001 = prm_aac001
             AND aab001 = prm_aab001
             AND aae002 = prm_aae002
             AND yab139 = prm_yab139
             AND aae140 = prm_aae140
             AND aae143 IN(xasi2.pkg_comm.AAE143_ZCJF,
                           xasi2.pkg_comm.AAE143_BJ,
                           xasi2.pkg_comm.AAE143_BS,
                           xasi2.pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                           xasi2.pkg_comm.AAE143_DLJF)
             AND NOT  EXISTS(SELECT 1
                                       FROM wsjb.irac01c1  b
                                      WHERE yae031='1'
                                        AND b.aac001 = a.aac001
                                        AND b.iaa100 = a.aae002
                                        AND b.aab001 = a.aab001);



             EXCEPTION
              WHEN OTHERS THEN
              BEGIN
             IF   var_yac503 IS NULL AND
              num_aac040 IS NULL AND
              var_yae010 IS NULL AND
              prm_yac505_old IS NULL AND
              prm_aae114_old IS NULL THEN
         SELECT aac001
            INTO var_aac001
            FROM wsjb.irac01c1
           WHERE yab029 = prm_aac001
             AND yae031='1'
             AND iaa100 = prm_aae002
             AND aab001 = prm_aab001;
          SELECT yac503,
                 aae180,
                 yae010,
                 yac505,
                 xasi2.pkg_comm.AAE114_QJ AS aae114
            INTO var_yac503,
                 num_aac040,
                 var_yae010,
                 prm_yac505_old,                  --参保缴费人员类别
                 prm_aae114_old
            FROM wsjb.irac08a1  a
           WHERE aac001 = var_aac001
             AND aab001 = prm_aab001
             AND aae002 = prm_aae002
             AND yab139 = prm_yab139
             AND aae140 = prm_aae140
             AND aae143 IN(xasi2.pkg_comm.AAE143_ZCJF,
                           xasi2.pkg_comm.AAE143_BJ,
                           xasi2.pkg_comm.AAE143_BS,
                           xasi2.pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                           xasi2.pkg_comm.AAE143_DLJF)
             AND  EXISTS(SELECT 1
                                       FROM wsjb.irac01c1  b
                                      WHERE yae031='1'
                                        AND b.aac001 = a.aac001
                                        AND b.iaa100 = a.aae002
                                        AND b.aab001 = a.aab001);
         END IF;
             EXCEPTION
              WHEN OTHERS THEN
                   prm_AppCode := ''||var_procNo||'02';
                   prm_ErrMsg  := var_yac503||'var_yac503'||'没有获取险种类型为'||xasi2.pkg_COMM.fun_getAaa103('aae140',prm_aae140)||'的缴费信息'||prm_aae002;
                   RETURN;
         END;
         END;

         --高新修改 WL 2013-02-01
         --对缴费工资进行保底封顶
         xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase(
                                                prm_aac001,             --个人编号
                                                prm_aab001,
                                                prm_aac040,             --缴费工资
                                                prm_yac503,             --工资类别
                                                prm_aae140,             --险种类型
                                                prm_yac505_old,         --缴费人员类别
                                                prm_yab136,             --单位管理类型
                                                num_aae003,             --费款所属期/*都用系统期号*//*20100928 参保科提出 所有录入工资的补收都按当前社平工资补差*/
                                                prm_yab139,             --参保所属分中心
                                                prm_yac004,             --缴费基数
                                                prm_AppCode,            --执行代码
                                                prm_ErrMsg);            --执行结果

         IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
            RETURN;
         END IF;

         --保存基数差额部分
         prm_yac004 := prm_aac040 - num_yac004_old;
         prm_aac040 := prm_yac004;

         IF prm_aae140 IN (xasi2.pkg_comm.aae140_JBYL,     --基本医疗
                           xasi2.pkg_comm.AAE140_GWYBZ)    --公务员补助
         THEN
            IF prm_yaa333 IS NULL OR prm_yaa333 = 0 THEN
               prm_yaa333 := prm_yac004;
            ELSE
               prm_yaa333 := prm_yaa333 - num_yaa333_old;
            END IF;
         ELSE
            prm_yaa333 := 0;
         END IF;
         --基数没变化。

         IF prm_yac004 = 0 THEN
            prm_AppCode := ''||var_procNo||'02';
            prm_ErrMsg  := '基数没有发生变化，不用补差';
            RETURN;
         END IF;
   EXCEPTION
      WHEN OTHERS THEN
           prm_AppCode := ''||var_procNo||'16';
           prm_ErrMsg  := '获取应实缴信息出错:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
           RETURN;
   END prc_p_checkYSJ;
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
                            prm_ErrMsg      OUT      VARCHAR2 )
   IS
      var_procNo            VARCHAR2(5);      --过程号
      var_yaa310            xasi2.aa05.yaa310%TYPE;      --比例类型
      var_yaa330            xasi2.aa05.yaa330%TYPE;      --缴费比例模式
      var_yab136            xasi2.ab01.yab136%TYPE;      --单位管理类型
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
      var_yac168            irac01.yac168%TYPE;             --农民工标志
      var_yac503            irac01.yac503%TYPE;             --工资类别
      var_yac505            irac01.yac505%TYPE;             --
      var_aac008            irac01.aac008%TYPE;
      var_aaa040            irab02.aaa040%TYPE;
      var_ykc120            irac08.ykc120%TYPE;             --医疗照顾人员类别
      var_akc021            irac01.akc021%TYPE;             --医疗人员类别
      num_yaa333            NUMBER;
      var_yae010            xasi2.aa05.yae010%TYPE;
      var_aae143            xasi2.ac08.aae143%TYPE;
      var_aae114            xasi2.ac08.aae114%TYPE;        --缴费标志

   BEGIN
      --初始化变量
      prm_AppCode    := xasi2.pkg_COMM.gn_def_OK ;
      prm_ErrMsg     := '' ;
      var_procNo     := 'A01';

      num_aae041 := prm_aae041;
      num_aae042 := prm_aae042;
      num_count  := 0;


      --获取单位基本信息
      SELECT yab136
        INTO var_yab136
        FROM xasi2.ab01
       WHERE aab001 = prm_aab001;


         var_aae143 := xasi2.pkg_comm.aae143_JSBC;


      WHILE num_aae041 <= num_aae042
      LOOP
         num_aac040_bd := prm_aac040;
         var_yac503 := prm_yac503;
         num_yaa333 := prm_yaa333;

         prc_p_checkYSJ(prm_aac001     ,      --个人编号
                        prm_aab001     ,      --单位编号
                        num_aae041     ,      --费款所属期
                        prm_aae140     ,      --险种
                        prm_yab139     ,      --参保所属分中心
                        var_yab136     ,      --单位管理类型
                        num_aac040_bd     ,      --新的缴费工资
                        var_yac503     ,      --工资类别
                        num_yaa333     ,      --账户基数
                        num_yac004     ,      --缴费基数
                        var_yac505 ,      --
                        var_aae114 ,      --缴费标志
                        prm_AppCode    ,      --执行代码
                        prm_ErrMsg    );      --错误信息

         IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
            --有异常抛出，将有效标志置为无效
            INSERT INTO xasi2.tmp_grbs02(
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
                                 NULL,           --缴费比例类别
                                 prm_aae140,           --险种类型
                                 var_aae143,           --缴费类别
                                 var_yac503,           --工资类型
                                 num_aac040_bd,        --缴费工资
                                 num_yac004,           --缴费基数
                                 num_yaa333,           --划帐户基数
                                 '1'     ,      --费用来源
                                 NULL     ,      --缴费比例模式
                                 0,           --个人缴费比例
                                 0,           --个人划统筹比例
                                 0,           --单位缴费比例
                                 0,           --单位划帐户比例
                                 0,           --工伤浮动费率
                                 0,              --年龄
                                 0,           --工龄
                                 NULL,           --医疗保险人员状态
                                 NULL,           --医疗照顾人员类别
                                 NULL,           --人员状态
                                 NULL,           --农民工标志
                                 NULL,           --比例类型
                                 var_aae114,           --缴费标志
                                 xasi2.pkg_comm.AAE100_WX,  --有效标志 ：无效
                                 prm_ErrMsg );
            --将错误信息置空
            prm_AppCode    := xasi2.pkg_COMM.gn_def_OK ;
            prm_ErrMsg     := '' ;
         ELSE
            --无异常抛出，将有效标志置为有效
          INSERT INTO xasi2.tmp_grbs02(
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
                                 NULL,           --缴费比例类别
                                 prm_aae140,           --险种类型
                                 var_aae143,           --缴费类别
                                 var_yac503,           --工资类型
                                 num_aac040_bd,        --缴费工资
                                 num_yac004,           --缴费基数
                                 num_yaa333,           --划帐户基数
                                 '1'     ,      --费用来源
                                 NULL     ,      --缴费比例模式
                                 0,           --个人缴费比例
                                 0,           --个人划统筹比例
                                 0,           --单位缴费比例
                                 0,           --单位划帐户比例
                                 0,           --工伤浮动费率
                                 0,              --年龄
                                 0,           --工龄
                                 NULL,           --医疗保险人员状态
                                 NULL,           --医疗照顾人员类别
                                 NULL,           --人员状态
                                 NULL,           --农民工标志
                                 NULL,           --比例类型
                                 var_aae114,           --缴费标志
                                 xasi2.pkg_comm.AAE100_YX,  --有效标志 ：无效
                                 prm_ErrMsg );
         END IF;
         --开始期号加1进行循环
         num_aae041 := to_number(to_char(ADD_MONTHS(TO_DATE(num_aae041,'yyyymm'),1),'yyyymm')) ;
      END LOOP;
   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := ''||var_procNo||'01';
         prm_ErrMsg  := '数据效验,出错原因:'||num_yac004_new||',,'||num_yac004||'..'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
      RETURN;
   END prc_p_checkTmp;
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
   PROCEDURE  prc_p_checkData(prm_aab001   IN   xasi2.ab02.aab001%TYPE,   --单位编号
                              prm_yab139   IN   xasi2.ac02.yab139%TYPE,   --参保所属分中心
                              prm_yab003   IN   xasi2.ac02.yab003%TYPE,   --社保经办机构
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
        FROM xasi2.tmp_grbs01;

   BEGIN
      --初始化变量
      prm_AppCode    := xasi2.pkg_COMM.gn_def_OK ;
      prm_ErrMsg     := '' ;
      var_procNo     := '02';

      --校验单位编号是否为空
      IF prm_aab001 IS NULL OR NVL(prm_aab001, '') = '' THEN
         prm_AppCode := ''||var_procNo||'02';
         prm_ErrMsg  := '单位编号不能为空！';
         RETURN;
      END IF;

      --清空临时表数据
      DELETE FROM xasi2.tmp_grbs02;

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
                         prm_yab139,          --参保所属分中心
                         prm_yab003,          --社保经办机构
                         prm_AppCode,         --执行代码
                         prm_ErrMsg );        --执行结果
      END LOOP;

      IF num_count < 1 THEN
         prm_AppCode := ''||var_procNo||'04';
         prm_ErrMsg  := '单位缴费补差临时表内无有效数据，请核实！';
         RETURN;
      END IF;

      --关闭游标
      IF cur_tmp%ISOPEN THEN
         CLOSE cur_tmp;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         prm_AppCode := ''||var_procNo||'01';
         prm_ErrMsg  := '数据效验,出错原因:'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
      RETURN;
   END prc_p_checkData;

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
                 prm_aae001       IN     VARCHAR2(4),--申报年度
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
        prm_ErrorMsg     OUT    VARCHAR2             )
    IS
        n_count  number(6);
       n_count1 number(6);
       n_count2 number(6);
       v_aac001 irac01.aac001%TYPE;
       v_aac002 irac01.aac002%TYPE;
       v_aac003 irac01.aac003%TYPE;
       v_aac009 irac01.aac009%TYPE;
       v_yac503 irac01.yac503%TYPE;--工资类别
       n_yac506 NUMBER(14,2);--原缴费工资
       n_yac507 NUMBER(14,2);--原养老基数
       n_yac508 NUMBER(14,2);--原缴费基数
       n_yac005 NUMBER(14,2);--原工伤缴费基数
       v_aae110 irac01.aae110%TYPE;
       v_aae210 irac01.aae210%TYPE;
       v_aae310 irac01.aae310%TYPE;
       v_aae410 irac01.aae410%TYPE;
       v_aae510 irac01.aae510%TYPE;
       v_aae311 irac01.aae311%TYPE;
       v_yae310 VARCHAR2(3000);--医疗备注
       v_yae110 VARCHAR2(3000);--养老备注
       v_yae210 VARCHAR2(3000);--失业备注
       v_yae410 VARCHAR2(3000);--工伤备注
       v_yae510 VARCHAR2(3000);--生育备注
       num_yae097 NUMBER(6);
       num_aae002_begin NUMBER(6);
       num_aae002_end NUMBER(6);
       maxiaa100 NUMBER(6);
       v_tqjsyf xasi2.ac01k8.yae110%TYPE;

       cursor cur_aac001 is
          SELECT DISTINCT AAC001
            FROM xasi2.ac08 A
           WHERE aae143 = '01'
             AND AAC008 = '1'
             AND a.aae002 >=num_aae002_begin
             AND a.aae002 <= num_aae002_end
             AND AAB001 = prm_aab001
             AND yab139 ='610127'
          UNION
          SELECT DISTINCT AAC001
            FROM xasi2.AC08A1 A
           WHERE aae143 = '01'
             AND AAC008 = '1'
             AND a.aae002 >=num_aae002_begin
             AND a.aae002 <= num_aae002_end
             AND AAB001 = prm_aab001
             AND yab139 ='610127'
           UNION
           SELECT DISTINCT AAC001
             FROM xasi2.AC08A3 A
            WHERE aae143 = '01'
             AND AAC008 = '1'
             AND a.aae002 >=num_aae002_begin
             AND a.aae002 <= num_aae002_end
             AND AAB001 = prm_aab001
             AND yab139 ='610127'
           UNION
           SELECT DISTINCT AAC001
            FROM wsjb.irac08a1  A
           WHERE A.AAB001 = prm_aab001
             AND A.aae143 = '01'
             AND a.aae002 >=num_aae002_begin
             AND a.aae002 <= num_aae002_end
             AND NOT EXISTS (SELECT 1
                               FROM wsjb.irac01c1  B
                              WHERE B.AAC001 = A.AAC001
                                AND B.IAA100 = A.AAE002
                                AND A.AAB001 = B.AAB001
                                AND b.iaa100 >= num_aae002_begin
                                AND B.YAE031 = '1');

      --增减变动
       cursor cur_aae310 is
           SELECT a.iaa001,
                  a.aac001,
                  a.aab001,
                  a.aac002,
                  a.aac003,
                  a.aac040,
                  a.yac004,
                  a.yac005,
                  a.iaa100,
                  a.aae110,
                  a.aae120,
                  a.aae210,
                  a.aae310,
                  a.aae410,
                  a.aae510,
                  a.aae311
            FROM wsjb.irac01  A
           WHERE A.AAB001 = prm_aab001
             AND A.AAC001 = v_aac001
             AND A.IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND A.iaa002 = '2'
             AND A.iaa100 >= to_number(prm_aae001||'01')
        --     AND NOT EXISTS (SELECT 1
        --                       FROM IRAC01C1 B
        --                      WHERE B.AAC001 = A.AAC001
        --                        AND B.IAA100 = A.IAA100
        --                        AND A.AAB001 = B.AAB001
        --                        AND B.YAE031 = '1')
             ORDER BY IAA100, AAE036;

            /*  受月报多次提交影响 重写了此游标 但是张钊说不用 又改回去了
             SELECT T.iaa001,
                  T.aac001,
                  T.aab001,
                  T.aac002,
                  T.aac003,
                  T.aac040,
                  T.yac004,
                  T.yac005,
                  T.iaa100,
                  T.aae110,
                  T.aae120,
                  T.aae210,
                  T.aae310,
                  T.aae410,
                  T.aae510,
                  T.aae311
             FROM (SELECT a.iaa001,
                  a.aac001,
                  a.aab001,
                  a.aac002,
                  a.aac003,
                  a.aac040,
                  a.yac004,
                  a.yac005,
                  a.iaa100,
                  a.aae110,
                  a.aae120,
                  a.aae210,
                  a.aae310,
                  a.aae410,
                  a.aae510,
                  a.aae311,
                  a.iaa002,
               ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY AAE036 DESC) LEV
          FROM wsjb.irac01 a) T
          WHERE LEV = 1
            AND  T.AAB001 = prm_aab001
             AND T.AAC001 = v_aac001
             AND T.IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND T.iaa002 = '2'
             AND T.iaa100 >= to_number('2019'||'01')
             ORDER BY IAA100; */

     --日常年审区分每月备案人员与正常人员
      cursor cur_aac001Ba IS
         SELECT DISTINCT AAC001
            FROM wsjb.irac08a1  A
           WHERE A.AAB001 = prm_aab001
             AND A.aae143 = '01'
             AND a.aae002 >=num_aae002_begin
             AND a.aae002 <= num_aae002_end
             AND EXISTS (SELECT 1
                               FROM wsjb.irac01c1  B
                              WHERE B.AAC001 = A.AAC001
                                AND B.IAA100 = A.AAE002
                                AND A.AAB001 = B.AAB001
                                AND b.iaa100 >= num_aae002_begin
                                AND B.YAE031 = '1');
      cursor cur_aae110Ba IS
          SELECT a.aac001,
                 a.aac002,
                 a.aac003,
                 a.aac009,
                 a.aac040,
                 a.yac004,
                 a.aae110,
                 a.iaa100
            FROM wsjb.irac01c1  a
           WHERE a.aab001=prm_aab001
             AND a.yae031='1'
             AND a.aac001 = v_aac001
             AND a.iaa100 >= num_aae002_begin;

    BEGIN
      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;
      n_count1     :=0;
      n_count2     :=0;
      n_yac506     :=0;
      n_yac507     :=0;
      n_yac508     :=0;
      n_yac005     :=0;
      v_aae110 := '';
      v_aae210 := '';
      v_aae310 := '';
      v_aae410 := '';
      v_aae510 := '';
      v_aae311 := '';
      /*必要的数据校验*/
      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '单位编号不能为空!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_ErrorMsg := '操作人员编号不能为空!';
         RETURN;
      END IF;

      --日常年审判断人员缴费时间
      SELECT MAX(yae097)
        INTO num_yae097
        FROM (
      SELECT MAX(yae097) AS yae097
        FROM xasi2.ab02
       WHERE aab001 = prm_aab001
      UNION ALL
      SELECT MAX(aae003) AS yae097
        FROM wsjb.irab08
       WHERE aab001 = prm_aab001
         AND yae517 = 'H01'
         AND aae140 = '01');

      num_aae002_begin := TO_NUMBER(prm_aae001||'01');
      num_aae002_end := num_yae097;

      IF SUBSTR(num_yae097,0,4) > prm_aae001 THEN
         num_aae002_end :=TO_NUMBER(prm_aae001||'12');
      ELSIF SUBSTR(num_yae097,0,4) < prm_aae001 THEN
         num_aae002_begin :=num_yae097;
      END IF;
      FOR rec_aac001 in cur_aac001 LOOP
        v_yac503 := '0';
        n_count  :=0;
        n_count1 :=0;
        n_count2 :=0;
        n_yac506 :=0;
        n_yac507 :=0;
        n_yac508 :=0;
        n_yac005 :=0;
        v_aae110 := '';
        v_aae210 := '';
        v_aae310 := '';
        v_aae410 := '';
        v_aae510 := '';
        v_aae311 := '';
        v_yae310 := '';
        v_yae110 := '';
        v_yae210 := '';
        v_yae410 := '';
        v_yae510 := '';

        SELECT aac001,aac002,aac003,aac009
          INTO v_aac001,v_aac002,v_aac003,v_aac009
          FROM xasi2.ac01
         WHERE aac001 = rec_aac001.aac001;

        FOR rec_aae310 IN cur_aae310 LOOP  --cur_aae310 增减变动游标

             IF rec_aae310.aae310 IN ('1','10') THEN
               v_yae310 := v_yae310||substr(rec_aae310.iaa100,5)||'月增/';
             END IF;
             IF rec_aae310.aae310 = '3' THEN
               v_yae310 := v_yae310||substr(rec_aae310.iaa100,5)||'月减/';
               v_aae310 := '21';
             END IF;

             IF rec_aae310.aae110 IN ('1','10') THEN
               v_yae110 := v_yae110||substr(rec_aae310.iaa100,5)||'月增/';
             END IF;
             IF rec_aae310.aae110 = '3' THEN
               v_yae110 := v_yae110||substr(rec_aae310.iaa100,5)||'月减/';
               v_aae110 := '21';
             END IF;

             IF rec_aae310.aae210 IN ('1','10') THEN
               v_yae210 := v_yae210||substr(rec_aae310.iaa100,5)||'月增/';
             END IF;
             IF rec_aae310.aae210 = '3' THEN
               v_yae210 := v_yae210||substr(rec_aae310.iaa100,5)||'月减/';
               v_aae210 := '21';
             END IF;

             IF rec_aae310.aae410 IN ('1','10') THEN
               v_yae410 := v_yae410||substr(rec_aae310.iaa100,5)||'月增/';
             END IF;
             IF rec_aae310.aae410 = '3' THEN
               v_yae410 := v_yae410||substr(rec_aae310.iaa100,5)||'月减/';
               v_aae410 := '21';
             END IF;

             IF rec_aae310.aae510 IN ('1','10') THEN
               v_yae510 := v_yae510||substr(rec_aae310.iaa100,5)||'月增/';
             END IF;
             IF rec_aae310.aae510 = '3' THEN
               v_yae510 := v_yae510||substr(rec_aae310.iaa100,5)||'月减/';
               v_aae510 := '21';
             END IF;

             IF rec_aae310.aae311 = '3' THEN
               v_aae311 := '21';
             END IF;

             IF rec_aae310.iaa001 = '9' AND rec_aae310.aae310 = '2' AND rec_aae310.aae510 = '3' AND rec_aae310.aae311 = '2'THEN
               v_yae310 := v_yae310||substr(rec_aae310.iaa100,5)||'月待退/';
               v_aae310 := '21';
             END IF;
           END LOOP;

      --modify by whm 20190813 提前结算且没有续保回原单位,续保回原单位的在下面单独写一条ac01k8 start

      --检查是否为养老提前结算
       SELECT count(1)
        INTO n_count
        FROM wsjb.irad51a1
       WHERE aac001 = v_aac001
         AND aab001 = prm_aab001
         AND yae031 = '1'
         AND aae041 >= prm_aae001||'01'
         AND aae041 <= prm_aae001||'12'
         AND not exists (select 1 from wsjb.irac01a3 a where a.aab001=prm_aab001 and a.aac001=v_aac001 and aae110='2');
      IF n_count > 0 THEN
        --拼接提前结算注释
          select max(decode(aae002, prm_aae001 || '01', '01月/')) ||
                        max(decode(aae002, prm_aae001 || '02', '02月/')) ||
                        max(decode(aae002, prm_aae001 || '03', '03月/')) ||
                        max(decode(aae002, prm_aae001 || '04', '04月/')) ||
                        max(decode(aae002, prm_aae001 || '05', '05月/')) ||
                        max(decode(aae002, prm_aae001 || '06', '06月/'))
                    as tqjsyf into v_tqjsyf
                   from wsjb.irad51a2
                  where aac001 = v_aac001
                    and aae002 >= prm_aae001 || '01'
                    and aae002 <= prm_aae001 || '12';
         v_yae110 := v_yae110||'养老提前结算/'||v_tqjsyf;
      END IF;
      --modify by whm 20190813 提前结算且没有续保回原单位,续保回原单位的在下面单独写一条ac01k8 ac01k8 end



      --判断是否参医疗记录
        SELECT count(1)
          INTO n_count
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND aae140 = '03';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '03';
        SELECT count(1)
          INTO n_count2
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 IN ('2','3')
           AND aae140 = '03';
         IF n_count1 > 0 THEN
          v_aae310 := '2';
          SELECT aac040,yac004,yac503
            INTO n_yac506,n_yac508,v_yac503
            FROM xasi2.ac02
           WHERE AAB001 = prm_aab001
             AND AAC001 = v_aac001
             AND aac031 = '1'
             AND aae140 = '03';
         END IF;
         IF n_count2 > 0 THEN
          SELECT aac040,yac004,yac503
            INTO n_yac506,n_yac508,v_yac503
            FROM xasi2.ac02
           WHERE AAB001 = prm_aab001
             AND AAC001 = v_aac001
             AND AAC031 IN ('2','3')
             AND aae140 = '03';
         END IF;

       ELSE
           select COUNT(1)
             INTO n_count
              from wsjb.irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
         IF n_count > 0 THEN
            select max(iaa100)
              into maxiaa100
              from wsjb.irac01
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6', '3', '7', '9', '10')
               AND iaa002 = '2'
               AND iaa100 >= to_number(prm_aae001 || '01');
               IF maxiaa100<=201904 THEN
               --modify by wanghm start 受月报多次提交影响 4月后会返回多行 20190729
               select aac040,
                      yac005
                 into n_yac506,
                      n_yac508
               from wsjb.irac01
              where aab001 = prm_aab001
               and aac001 = v_aac001
               and IAA001 IN ('1', '5', '8', '6','3','7','9','10')
               and iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                              WHERE AAB001 = prm_aab001
                                AND AAC001 = v_aac001
                                AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                AND iaa002 = '2'
                                AND iaa100 >= to_number(prm_aae001||'01'));
               ELSE
               select aac040,
                      CASE WHEN aae310 <> 0 THEN yac005 ELSE 0 END
                 into n_yac506,
                      n_yac508
               from wsjb.irac01
               where iac001 = (
                       SELECT iac001
                        FROM (SELECT a.iac001, a.iaa100, a.aac001,
                                     ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY aae036 DESC) LEV
                                FROM wsjb.irad02a1 a) t
                       WHERE LEV = 1
                         and t.aac001 = v_aac001
                          and iaa100 =  (select max(iaa100) from wsjb.irac01
                                                        WHERE AAB001 = prm_aab001
                                                       AND AAC001 = v_aac001
                                                       AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                                       AND iaa002 = '2'
                                                       AND iaa100 >= to_number(2019||'01')));
               END IF;
         END IF;
       END IF;

       --判断是否参生育记录
        SELECT count(1)
          INTO n_count
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND aae140 = '05';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '05';
        SELECT count(1)
          INTO n_count2
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '2'
           AND aae140 = '05';
         IF n_count1 > 0 THEN
          v_aae510 := '2';
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac508,v_yac503
              FROM xasi2.ac02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '1'
               AND aae140 = '05';
          END IF;

         END IF;
         IF n_count2 > 0 THEN
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac508,v_yac503
              FROM xasi2.ac02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '2'
               AND aae140 = '05';
          END IF;
         END IF;
       ELSE
         select COUNT(1)
             INTO n_count
              from wsjb.irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
         IF n_count > 0 THEN
             IF n_yac506 = 0 AND n_yac508 = 0 THEN
             select max(iaa100)
              into maxiaa100
              from wsjb.irac01
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6', '3', '7', '9', '10')
               AND iaa002 = '2'
               AND iaa100 >= to_number(prm_aae001 || '01');
               IF maxiaa100<=201904 THEN
               --modify by wanghm start 受月报多次提交影响 4月后会返回多行 20190729
               select aac040,
                      yac005
                 into n_yac506,
                      n_yac508
               from wsjb.irac01
              where aab001 = prm_aab001
               and aac001 = v_aac001
               and IAA001 IN ('1', '5', '8', '6','3','7','9','10')
               and iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                              WHERE AAB001 = prm_aab001
                                AND AAC001 = v_aac001
                                AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                AND iaa002 = '2'
                                AND iaa100 >= to_number(prm_aae001||'01'));
               ELSE
               select aac040,
                      CASE WHEN aae510 <> 0 THEN yac005 ELSE 0 END
                 into n_yac506,
                      n_yac508
               from wsjb.irac01
               where iac001 = (
                       SELECT iac001
                        FROM (SELECT a.iac001, a.iaa100, a.aac001,
                                     ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY aae036 DESC) LEV
                                FROM wsjb.irad02a1 a) t
                       WHERE LEV = 1
                         and t.aac001 = v_aac001
                          and iaa100 =  (select max(iaa100) from wsjb.irac01
                                                        WHERE AAB001 = prm_aab001
                                                       AND AAC001 = v_aac001
                                                       AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                                       AND iaa002 = '2'
                                                       AND iaa100 >= to_number(2019||'01')));
               END IF;
             END IF;
          END IF;
       END IF;

        --判断是否参大额记录
        SELECT count(1)
          INTO n_count
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND aae140 = '07';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '07';
        SELECT count(1)
          INTO n_count2
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '2'
           AND aae140 = '07';
         IF n_count1 > 0 THEN
          v_aae311 := '2';
         END IF;
       END IF;


        --判断是否参失业记录
        SELECT count(1)
          INTO n_count
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = rec_aac001.aac001
           AND aae140 = '02';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = rec_aac001.aac001
           AND AAC031 = '1'
           AND aae140 = '02';
        SELECT count(1)
          INTO n_count2
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = rec_aac001.aac001
           AND AAC031 = '2'
           AND aae140 = '02';
         IF n_count1 > 0 THEN
          v_aae210 := '2';
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac005,v_yac503
              FROM xasi2.ac02
             WHERE AAB001 = prm_aab001
               AND AAC001 = rec_aac001.aac001
               AND aac031 = '1'
               AND aae140 = '02';
         END IF;
         IF n_count2 > 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac005,v_yac503
              FROM xasi2.ac02
             WHERE AAB001 = prm_aab001
               AND AAC001 = rec_aac001.aac001
               AND aac031 = '2'
               AND aae140 = '02';
         END IF;

       ELSE
          select COUNT(1)
             INTO n_count
              from wsjb.irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
        IF n_count > 0 THEN
          IF  n_yac005 = 0 THEN
            IF prm_aae001 <= 2019 THEN  --失业19年年审以前都是用市社平
              select max(iaa100)
                into maxiaa100
                from wsjb.irac01
               WHERE AAB001 = prm_aab001
                 AND AAC001 = v_aac001
                 AND IAA001 IN ('1', '5', '8', '6', '3', '7', '9', '10')
                 AND iaa002 = '2'
                 AND iaa100 >= to_number(prm_aae001 || '01');
               IF maxiaa100<=201904 THEN
               --modify by wanghm start 受月报多次提交影响 4月后会返回多行 20190729
               select aac040,
                      yac005
                 into n_yac506,
                      n_yac005
                 from wsjb.irac01
                where aab001 = prm_aab001
                 and aac001 = v_aac001
                 and IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                 and iaa002 = '2'
                 and iaa100 = (select max(iaa100) from wsjb.irac01
                                WHERE AAB001 = prm_aab001
                                  AND AAC001 = v_aac001
                                  AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                  AND iaa002 = '2'
                                  AND iaa100 >= to_number(prm_aae001||'01'));
               ELSE
               select aac040,
                      CASE WHEN aae210 <> 0 THEN yac005 ELSE 0 END
                 into n_yac506,
                      n_yac005
               from wsjb.irac01
               where iac001 = (
                       SELECT iac001
                        FROM (SELECT a.iac001, a.iaa100, a.aac001,
                                     ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY aae036 DESC) LEV
                                FROM wsjb.irad02a1 a) t
                       WHERE LEV = 1
                         and t.aac001 = v_aac001
                          and iaa100 =  (select max(iaa100) from wsjb.irac01
                                                        WHERE AAB001 = prm_aab001
                                                       AND AAC001 = v_aac001
                                                       AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                                       AND iaa002 = '2'
                                                       AND iaa100 >= to_number(2019||'01')));
               END IF;
            ELSE
               select aac040,
                      CASE WHEN aae210 <> 0 THEN yac004 ELSE 0 END
                 into n_yac506,
                      n_yac005
               from wsjb.irac01
               where iac001 = (
                       SELECT iac001
                        FROM (SELECT a.iac001, a.iaa100, a.aac001,
                                     ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY aae036 DESC) LEV
                                FROM wsjb.irad02a1 a) t
                       WHERE LEV = 1
                         and t.aac001 = v_aac001
                          and iaa100 =  (select max(iaa100) from wsjb.irac01
                                                        WHERE AAB001 = prm_aab001
                                                       AND AAC001 = v_aac001
                                                       AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                                       AND iaa002 = '2'
                                                       AND iaa100 >= to_number(2019||'01')));
            END IF;
          END IF;
        END IF;
       END IF;


       --判断是否参工伤记录
        SELECT count(1)
          INTO n_count
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND aae140 = '04';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '04';
        SELECT count(1)
          INTO n_count2
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '2'
           AND aae140 = '04';
         IF n_count1 > 0 THEN
          v_aae410 := '2';
          IF n_yac506 = 0 AND n_yac005 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac005,v_yac503
              FROM xasi2.ac02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '1'
               AND aae140 = '04';
          END IF;
         END IF;
         IF n_count2 > 0 THEN
          IF  n_yac005 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac005,v_yac503
              FROM xasi2.ac02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 IN ('2','3')
               AND aae140 = '04';
          END IF;
         END IF;

       ELSE
         select COUNT(1)
             INTO n_count
              from wsjb.irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
          IF n_count > 0 THEN
          IF  n_yac005 = 0 THEN
            IF prm_aae001 <= 2019 THEN  --工伤19年年审以前都是用市社平
              select max(iaa100)
                into maxiaa100
                from wsjb.irac01
               WHERE AAB001 = prm_aab001
                 AND AAC001 = v_aac001
                 AND IAA001 IN ('1', '5', '8', '6', '3', '7', '9', '10')
                 AND iaa002 = '2'
                 AND iaa100 >= to_number(prm_aae001 || '01');
               IF maxiaa100<=201904 THEN
               --modify by wanghm start 受月报多次提交影响 4月后会返回多行 20190729
               select aac040,
                      yac005
                 into n_yac506,
                      n_yac005
                 from wsjb.irac01
                where aab001 = prm_aab001
                 and aac001 = v_aac001
                 and IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                 and iaa002 = '2'
                 and iaa100 = (select max(iaa100) from wsjb.irac01
                                WHERE AAB001 = prm_aab001
                                  AND AAC001 = v_aac001
                                  AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                  AND iaa002 = '2'
                                  AND iaa100 >= to_number(prm_aae001||'01'));
               ELSE
               select aac040,
                      CASE WHEN aae410 <> 0 THEN yac005 ELSE 0 END
                 into n_yac506,
                      n_yac005
               from wsjb.irac01
               where iac001 = (
                       SELECT iac001
                        FROM (SELECT a.iac001, a.iaa100, a.aac001,
                                     ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY aae036 DESC) LEV
                                FROM wsjb.irad02a1 a) t
                       WHERE LEV = 1
                         and t.aac001 = v_aac001
                          and iaa100 =  (select max(iaa100) from wsjb.irac01
                                                        WHERE AAB001 = prm_aab001
                                                       AND AAC001 = v_aac001
                                                       AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                                       AND iaa002 = '2'
                                                       AND iaa100 >= to_number(2019||'01')));
               END IF;
            ELSE
               select aac040,
                      CASE WHEN aae410 <> 0 THEN yac004 ELSE 0 END
                 into n_yac506,
                      n_yac005
               from wsjb.irac01
               where iac001 = (
                       SELECT iac001
                        FROM (SELECT a.iac001, a.iaa100, a.aac001,
                                     ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY aae036 DESC) LEV
                                FROM wsjb.irad02a1 a) t
                       WHERE LEV = 1
                         and t.aac001 = v_aac001
                          and iaa100 =  (select max(iaa100) from wsjb.irac01
                                                        WHERE AAB001 = prm_aab001
                                                       AND AAC001 = v_aac001
                                                       AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                                       AND iaa002 = '2'
                                                       AND iaa100 >= to_number(2019||'01')));
            END IF;
          END IF;
        END IF;
       END IF;

       --判断是否参养老记录
       SELECT count(1)
          INTO n_count
          FROM wsjb.IRAC01A3
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001;
       IF n_count > 0 THEN
        SELECT count(1)
          INTO n_count1
          FROM wsjb.IRAC01A3
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAE110 = '2';
        SELECT count(1)
          INTO n_count2
          FROM wsjb.IRAC01A3
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAE110 = '0';
         IF n_count1 > 0 THEN
          v_aae110 := '2';
          SELECT YAC004
            INTO n_yac507
            FROM wsjb.IRAC01A3
           WHERE AAB001 = prm_aab001
             AND AAC001 = v_aac001
             AND AAE110 = '2';
         END IF;
        IF n_count2 > 0 THEN
           --有缴费记录才给显示参保状态
           SELECT count(1)
            INTO n_count
            FROM wsjb.irac08a1  A
           WHERE A.AAB001 = prm_aab001
             AND a.aac001 = v_aac001
             AND A.aae143 = '01'
             AND A.aae002 >= (SELECT aae041
                                FROM xasi2.AA02A3
                               WHERE aae140 = '01'
                                  AND aae001 = prm_aae001);
           IF n_count >0 THEN
              v_aae110 := '21';
           END IF ;
            SELECT COUNT(1)
               INTO n_count
                FROM wsjb.irac01
              WHERE aab001 = prm_aab001
                 AND aac001 = v_aac001
                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
               AND iaa002 = '2'
                 AND iaa100 = (select max(iaa100) from wsjb.irac01
                                    WHERE AAB001 = prm_aab001
                                   AND AAC001 = v_aac001
                                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                   AND iaa002 = '2'
                                   AND iaa100 >= to_number(prm_aae001||'01'));
           IF n_count > 0 THEN
              --modify by wanghm start 受月报多次提交影响 4月后会返回多行 20190729
              select max(iaa100)
              into maxiaa100
              from wsjb.irac01
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6', '3', '7', '9', '10')
               AND iaa002 = '2'
               AND iaa100 >= to_number(prm_aae001 || '01');

              IF maxiaa100<=201904 THEN
                select distinct (CASE WHEN aae110 <> 0 THEN yac004 ELSE 0 END)
                  into n_yac507
                  from wsjb.irac01
                 where aab001 = prm_aab001
                   and aac001 = v_aac001
                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                 AND iaa002 = '2'
                   and iaa100 = (select max(iaa100) from wsjb.irac01
                                    WHERE AAB001 = prm_aab001
                                   AND AAC001 = v_aac001
                                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                   AND iaa002 = '2'
                                   AND iaa100 >= to_number(prm_aae001||'01'));
             ELSE
             select  CASE WHEN aae110 <> 0 THEN yac004 ELSE 0 END
               into n_yac507
                from wsjb.irac01
               where iac001 = (
                       SELECT iac001
                        FROM (SELECT a.iac001, a.iaa100, a.aac001,
                                     ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY aae036 DESC) LEV
                                FROM wsjb.irad02a1 a) t
                       WHERE LEV = 1
                         and t.aac001 = v_aac001
                          and iaa100 =  (select max(iaa100) from wsjb.irac01
                                                        WHERE AAB001 = prm_aab001
                                                       AND AAC001 = v_aac001
                                                       AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                                       AND iaa002 = '2'
                                                       AND iaa100 >= to_number(prm_aae001||'01')));
              END IF;
           ELSE
             --有缴费记录才给显示缴费基数
             SELECT count(1)
              INTO n_count
              FROM wsjb.irac08a1  A
             WHERE A.AAB001 = prm_aab001
               AND a.aac001 = v_aac001
               AND A.aae143 = '01'
               AND A.aae002 >= (SELECT aae041
                                  FROM xasi2.AA02A3
                                 WHERE aae140 = '01'
                                    AND aae001 = prm_aae001);
             IF n_count >0 THEN
                --获取养老基数
               SELECT count(1)
                 INTO n_count1
                 FROM wsjb.irac01c1
                WHERE aab001 = prm_aab001
                  AND aac001 = v_aac001
                  AND yae031 = '1';
              IF n_count1 > 0 THEN
               n_yac507 := 0 ;
               ELSE
               SELECT yac004
                 INTO n_yac507
                 FROM wsjb.IRAC01A3
                WHERE aab001 = prm_aab001
                    AND aac001 = v_aac001;
               END IF;
             END IF ;
           END IF;
        END IF;
       ELSE
           select COUNT(1)
             INTO n_count
              from wsjb.irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
         IF n_count > 0 THEN
           --modify by wanghm start 受月报多次提交影响 4月后会返回多行 20190729
           select max(iaa100)
              into maxiaa100
              from wsjb.irac01
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6', '3', '7', '9', '10')
               AND iaa002 = '2'
               AND iaa100 >= to_number('2019' || '01');

           IF maxiaa100<=201904 THEN
           select CASE WHEN aae110 <> 0 THEN yac004 ELSE 0 END
                into n_yac507
                from wsjb.irac01
               where aab001 = prm_aab001
                 and aac001 = v_aac001
                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
               AND iaa002 = '2'
                 and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
           ELSE
           select  CASE WHEN aae110 <> 0 THEN yac004 ELSE 0 END
               into n_yac507
                from wsjb.irac01
               where iac001 = (
                       SELECT iac001
                        FROM (SELECT a.iac001, a.iaa100, a.aac001,
                                     ROW_NUMBER() OVER(PARTITION BY aac001 ORDER BY aae036 DESC) LEV
                                FROM wsjb.irad02a1 a) t
                       WHERE LEV = 1
                         and t.aac001 = v_aac001
                          and iaa100 =  (select max(iaa100) from wsjb.irac01
                                                        WHERE AAB001 = prm_aab001
                                                       AND AAC001 = v_aac001
                                                       AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                                       AND iaa002 = '2'
                                                       AND iaa100 >= to_number(prm_aae001||'01')));
           END IF;
         END IF;

       END IF;



       IF n_yac506 IS NULL THEN
          n_yac506 := 0;
       END IF;
       IF n_yac507 IS NULL OR n_yac507 <= 0 THEN
         --是否存在养老缴费记录
           SELECT count(1)
             INTO n_count
            FROM wsjb.irac08a1  A
           WHERE A.AAB001 = prm_aab001
             AND A.aae143 = '01'
             AND A.aac001 = v_aac001
             AND A.aae002 >= (SELECT aae041
                                FROM xasi2.AA02A3
                               WHERE aae140 = '01'
                                  AND aae001 = prm_aae001);
           IF n_count > 0 THEN
             --存在则获取最大一次缴费期的基数
            SELECT aae180
              INTO n_yac507
              FROM wsjb.irac08a1
             WHERE aac001 =  v_aac001
               AND aab001 =  prm_aab001
               AND aae143 = '01'
               AND aae002 = (SELECT MAX(aae002)
                                FROM wsjb.irac08a1
                               WHERE aac001 =  v_aac001
                                 AND aab001 =  prm_aab001
                                 AND aae140 = '01'
                                 AND aae143 = '01'
                                 AND aae002 >= (SELECT aae041
                                                  FROM xasi2.AA02A3
                                                 WHERE aae140 = '01'
                                                    AND aae001 = prm_aae001));
          ELSE
            n_yac507 := 0;
          END IF;

       END IF;
       IF n_yac508 IS NULL THEN
           n_yac508 := 0;
       END IF;

       INSERT INTO xasi2.ac01k8 (
                                    aac001,
                                    aab001,
                                    aac002,
                                    aac003,
                                    aac009,
                                    yac506,
                                    yac507,
                                    yac508,
                                    aae110,
                                    aae210,
                                    aae310,
                                    aae410,
                                    aae510,
                                    aae311,
                                    aae001,
                                    yac503,
                                    yac005,
                                    yae092,
                                    iaa002,
                                    yae110,
                                    yae310,
                                    yae210,
                                    yae410,
                                    yae510,
                                    yab019,
                                    aae034
                                    )VALUES(
                                    v_aac001,
                                    prm_aab001,
                                    v_aac002,
                                    v_aac003,
                                    v_aac009,
                                    n_yac506,
                                    n_yac507,
                                    n_yac508,
                                    v_aae110,
                                    v_aae210,
                                    v_aae310,
                                    v_aae410,
                                    v_aae510,
                                    v_aae311,
                                    prm_aae001,
                                    v_yac503,
                                    n_yac005,
                                    prm_yae092,
                                    '0' ,
                                    v_yae110,
                                    v_yae310,
                                    v_yae210,
                                    v_yae410,
                                    v_yae510,
                                    '1',
                                    SYSDATE
                                    );
                                    
      -- 提前结算没有再续保的人员把新旧缴费工资和基数写成一样的
       SELECT count(1)
        INTO n_count
        FROM wsjb.irad51a1
       WHERE aac001 = v_aac001
         AND aab001 = prm_aab001
         AND yae031 = '1'
         AND aae041 >= prm_aae001||'01'
         AND aae041 <= prm_aae001||'12'
         AND not exists (select 1 from wsjb.irac01a3 a where a.aab001=prm_aab001 and a.aac001=v_aac001 and aae110='2');
        if n_count >0 then
          update xasi2.ac01k8
             set aac040 = n_yac506,
                 yac004 = n_yac507,
                 yaa333 = n_yac508,
                 yaa444 = n_yac005,
                 aae013 = '2' -- 2 : 提前结算的人
           where aab001 = prm_aab001
             and aac001 = v_aac001
             and aae001 = prm_aae001;
        end if;

        -- 提前结算后又续回的单独写一条 AC01K8
           SELECT count(1)
            INTO n_count
            FROM wsjb.irad51a1 a, wsjb.irac01a3 b
           WHERE b.aae110 = '2'
             AND a.aac001 = b.aac001
             AND a.aab001 = b.aab001
             AND a.aac001 = v_aac001
             AND a.aab001 = prm_aab001
             AND a.yae031 = '1'
             AND a.aae041 >= prm_aae001||'01'
             AND a.aae041 <= prm_aae001||'12';
           IF n_count > 0 THEN
                 update xasi2.ac01k8
                   set aae013 = '22' -- 22 : 提前结算又续保的 展示续保的一条记录
                 where aab001 = prm_aab001
                   and aac001 = v_aac001
                   and aae001 = prm_aae001;  
                 --拼接提前结算注释
                 select max(decode(aae002, prm_aae001 || '01', '01月/')) ||
                        max(decode(aae002, prm_aae001 || '02', '02月/')) ||
                        max(decode(aae002, prm_aae001 || '03', '03月/')) ||
                        max(decode(aae002, prm_aae001 || '04', '04月/')) ||
                        max(decode(aae002, prm_aae001 || '05', '05月/')) ||
                        max(decode(aae002, prm_aae001 || '06', '06月/'))
                    as tqjsyf into v_tqjsyf
                   from wsjb.irad51a2
                  where aac001 = v_aac001
                    and aae002 >= prm_aae001 || '01'
                    and aae002 <= prm_aae001 || '12';
                  v_yae110 := '养老提前结算/'||v_tqjsyf;
                  
                  --获取结算月度的结算上账基数(如果提前结算的人续保回来从AC02或IRAC01取就不对了,所以取结算时的基数)
                  select distinct b.yaa334,b.yaa334
                     into n_yac506,n_yac507
                    from irad51a1 a, irad51a2 b
                   where a.yae031 ='1'
                   and a.yae518 =b.yae518
                   and  a.aab001 = prm_aab001
                   and a.aac001 = v_aac001;
                    --提前结算的新旧缴费工资和基数写成一样的
                     INSERT INTO xasi2.ac01k8 (
                                            aac001,
                                            aab001,
                                            aac002,
                                            aac003,
                                            aac009,
                                            yac506,
                                            yac507,
                                            yac508,
                                            aac040,
                                            yac004,
                                            yaa333,
                                            aae110,
                                            aae210,
                                            aae310,
                                            aae410,
                                            aae510,
                                            aae311,
                                            aae001,
                                            yac503,
                                            yac005,
                                            yae092,
                                            iaa002,
                                            yae110,
                                            yae310,
                                            yae210,
                                            yae410,
                                            yae510,
                                            yaa444,
                                            yab019,
                                            aae034,
                                            aae013
                                            )VALUES(
                                            v_aac001,
                                            prm_aab001,
                                            v_aac002,
                                            v_aac003,
                                            v_aac009,
                                            n_yac506,
                                            n_yac507,
                                            n_yac508,
                                            n_yac506,
                                            n_yac507,
                                            n_yac508,
                                            v_aae110,
                                            v_aae210,
                                            v_aae310,
                                            v_aae410,
                                            v_aae510,
                                            v_aae311,
                                            prm_aae001,
                                            v_yac503,
                                            n_yac005,
                                            prm_yae092,
                                            '0' ,
                                            v_yae110,
                                            v_yae310,
                                            v_yae210,
                                            v_yae410,
                                            v_yae510,
                                            n_yac005,
                                            '1',
                                            SYSDATE,
                                            '21' -- 提前结算又续保的 展示提前结算的一条记录
                                            );
            END IF;
            
            --逐月人员写标志 
            SELECT count(1)
              INTO n_count
              FROM xasi2.ac02_zy
             where aac001 = v_aac001;
             IF n_count >0 THEN
                update xasi2.ac01k8
                 set aae013 = '1'
                where aab001 = prm_aab001
                 and aac001 = v_aac001
                 and aae001 = prm_aae001;
             END IF;
             
      END LOOP;

   --这是养老备案的 201811后已经没有这个业务了
   FOR rec_aac001Ba in cur_aac001Ba LOOP
        v_yac503 := '0';
        n_count  :=0;
        n_count1 :=0;
        n_count2 :=0;
        n_yac506 :=0;
        n_yac507 :=0;
        n_yac508 :=0;
        n_yac005 :=0;
        v_aae110 := '';
        v_aae210 := '';
        v_aae310 := '';
        v_aae410 := '';
        v_aae510 := '';
        v_aae311 := '';
        v_yae310 := '';
        v_yae110 := '';
        v_yae210 := '';
        v_yae410 := '';
        v_yae510 := '';

        SELECT aac001,aac002,aac003,aac009
          INTO v_aac001,v_aac002,v_aac003,v_aac009
          FROM xasi2.ac01
         WHERE aac001 = rec_aac001Ba.aac001;

        FOR rec_aae110Ba IN cur_aae110Ba LOOP
             IF rec_aae110Ba.aae110 IN ('备案') THEN
               v_yae110 := v_yae110||substr(rec_aae110Ba.iaa100,5)||'月备案/';
             END IF;
           END LOOP;

        SELECT YAB029,
               AAC002,
               AAC003,
               AAC009,
               AAC040,
               YAC004,
               AAE110
          INTO v_aac001,
               v_aac002,
               v_aac003,
               v_aac009,
               n_yac506,
               n_yac507,
               v_aae110
          FROM wsjb.irac01c1
         WHERE AAC001 = rec_aac001Ba.AAC001
           AND AAB001 = PRM_AAB001
           AND YAE031 = '1'
           AND IAA100 = (SELECT MAX(IAA100)
                           FROM wsjb.irac01c1
                          WHERE AAC001 = rec_aac001Ba.AAC001
                            AND YAE031 = '1'
                            AND AAB001 = PRM_AAB001);
      --检查是否为养老提前结算
      SELECT count(1)
        INTO n_count
        FROM wsjb.irad51a1
       WHERE aac001 = v_aac001
         AND aab001 = prm_aab001
         AND yae031 = '1'
         and aae041 = prm_aae001||'01';
      IF n_count > 0 THEN
         v_yae110 := v_yae110||'养老提前结算/';
      END IF;

       INSERT INTO xasi2.ac01k8 (
                                    aac001,
                                    aab001,
                                    aac002,
                                    aac003,
                                    aac009,
                                    yac506,
                                    yac507,
                                    yac508,
                                    aae110,
                                    aae210,
                                    aae310,
                                    aae410,
                                    aae510,
                                    aae311,
                                    aae001,
                                    yac503,
                                    yac005,
                                    yae092,
                                    iaa002,
                                    yae110,
                                    yae310,
                                    yae210,
                                    yae410,
                                    yae510,
                                    yab019,
                                    aae034
                                    )VALUES(
                                    v_aac001,
                                    prm_aab001,
                                    v_aac002,
                                    v_aac003,
                                    v_aac009,
                                    n_yac506,
                                    n_yac507,
                                    n_yac508,
                                    v_aae110,
                                    v_aae210,
                                    v_aae310,
                                    v_aae410,
                                    v_aae510,
                                    v_aae311,
                                    prm_aae001,
                                    v_yac503,
                                    n_yac005,
                                    prm_yae092,
                                    '0' ,
                                    v_yae110,
                                    v_yae310,
                                    v_yae210,
                                    v_yae410,
                                    v_yae510,
                                    '1',
                                    SYSDATE
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
         prm_ErrorMsg := '数据库错误:'|| SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;

   END prc_queryjishu;

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
        prm_ErrorMsg     OUT    VARCHAR2             )
    IS
        n_count  number(6);
       n_count1 number(6);
       n_count2 number(6);
       v_aac001 irac01.aac001%TYPE;
       v_yab029 irab05.yab029%TYPE;
       v_aac002 irac01.aac002%TYPE;
       v_aac003 irac01.aac003%TYPE;
       v_aac009 irac01.aac009%TYPE;
       v_yac503 irac01.yac503%TYPE;
       n_yac506 NUMBER(14,2);--原缴费工资
       n_yac507 NUMBER(14,2);--原养老基数
       n_yac508 NUMBER(14,2);
       n_yac005 NUMBER(14,2);
       v_aae110 irac01.aae110%TYPE;
       v_yae110 VARCHAR2(3000);


       cursor cur_aac001 is
          SELECT DISTINCT AAC001
            FROM wsjb.irac08a1  A
           WHERE A.AAB001 = prm_aab001
             AND A.aae143 = '01'
             AND A.aae002 >= (SELECT aae041 FROM xasi2.AA02A3 WHERE aae140 = '01' AND aae001 = prm_aae001);

       --增减变动
       cursor cur_aae110 is
           SELECT iaa001,
                  aac001,
                  aab001,
                  aac002,
                  aac003,
                  aac040,
                  yac004,
                  yac005,
                  iaa100,
                  aae110,
                  aae120,
                  aae210,
                  aae310,
                  aae410,
                  aae510,
                  aae311
            FROM wsjb.irac01
           WHERE AAB001 = prm_aab001
             AND AAC001 = v_aac001
             AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
             AND iaa100 >= to_number(prm_aae001||'01')
             ORDER BY IAA100;
        --日常年审区分每月备案人员与正常人员

      cursor cur_aae110Ba IS
          SELECT a.aac001,
                 a.aac002,
                 a.aac003,
                 a.aac009,
                 a.aac040,
                 a.yac004,
                 a.aae110,
                 a.iaa100
            FROM wsjb.irac01c1  a
           WHERE a.aab001=prm_aab001
             AND a.yae031='1'
             AND a.aac001 = v_aac001;
    BEGIN
      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;
      n_count1     :=0;
      n_count2     :=0;
      n_yac506     :=0;
      n_yac507     :=0;
      n_yac508     :=0;
      n_yac005     :=0;
      v_aae110 := '';
      v_yae110 := '';
      v_yab029 := '';
       /*必要的数据校验*/
      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '单位编号不能为空!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_ErrorMsg := '操作人员编号不能为空!';
         RETURN;
      END IF;

      FOR rec_aac001 in cur_aac001 LOOP
        n_count      :=0;
        n_count1     :=0;
        n_count2     :=0;
        n_yac506     :=0;
        n_yac507     :=0;
        n_yac508     :=0;
        n_yac005     :=0;
        v_aae110 := '';
        v_yae110 := '';
        v_yab029 := '';

        SELECT count(1)
          INTO n_count
          FROM xasi2.ac01
         WHERE aac001 = rec_aac001.aac001;
      IF n_count >0 THEN
         SELECT aac001,aac002,aac003,aac009
          INTO v_aac001,v_aac002,v_aac003,v_aac009
          FROM xasi2.ac01
         WHERE aac001 = rec_aac001.aac001;
       ELSE
          SELECT aac001,aac002,aac003,aac009,aae110,yab029
          INTO v_aac001,v_aac002,v_aac003,v_aac009,v_aae110,v_yab029
          FROM wsjb.irac01c1
         WHERE aac001 = rec_aac001.aac001;
       END IF;
      FOR rec_aae110 IN cur_aae110 LOOP
             IF rec_aae110.aae110 IN ('1','10') THEN
               v_yae110 := v_yae110||substr(rec_aae110.iaa100,5)||'月增/';
             END IF;
             IF rec_aae110.aae110 = '3' THEN
               v_yae110 := v_yae110||substr(rec_aae110.iaa100,5)||'月减/';
               v_aae110 := '21';
             END IF;

      END LOOP;
      FOR rec_aae110Ba IN cur_aae110Ba LOOP
        IF rec_aae110Ba.aae110 IN ('备案') THEN
               v_yae110 := v_yae110||substr(rec_aae110Ba.iaa100,5)||'月备案/';
             END IF;
        END LOOP;
      --判断是否参养老记录
        SELECT count(1)
          INTO n_count
          FROM wsjb.IRAC01A3
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001;
       IF n_count > 0 THEN
        SELECT count(1)
          INTO n_count1
          FROM wsjb.IRAC01A3
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAE110 = '2';
        SELECT count(1)
          INTO n_count2
          FROM wsjb.IRAC01A3
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAE110 = '0';
         IF n_count1 > 0 THEN
          v_aae110 := '2';
          SELECT aac040 ,yac004
             INTO n_yac506,n_yac507
            FROM wsjb.IRAC01A3
           WHERE AAB001 = prm_aab001
             AND AAC001 = v_aac001
             AND AAE110 = '2';
         END IF;
        IF n_count2 > 0 THEN
           --有缴费记录才给显示参保状态
             SELECT count(1)
              INTO n_count
              FROM wsjb.irac08a1  A
             WHERE A.AAB001 = prm_aab001
               AND a.aac001 = v_aac001
               AND A.aae143 = '01'
               AND A.aae002 >= (SELECT aae041
                                  FROM xasi2.AA02A3
                                 WHERE aae140 = '01'
                                    AND aae001 = prm_aae001);
             IF n_count >0 THEN
               v_aae110 := '21';
             END IF ;
            select COUNT(1)
               INTO n_count
                from wsjb.irac01
              where aab001 = prm_aab001
                 and aac001 = v_aac001
                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
               AND iaa002 = '2'
                 and iaa100 = (select max(iaa100) from wsjb.irac01
                                    WHERE AAB001 = prm_aab001
                                   AND AAC001 = v_aac001
                                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                   AND iaa002 = '2'
                                   AND iaa100 >= to_number(prm_aae001||'01'));
           IF n_count > 0 THEN
               select aac040 ,yac004
                   INTO n_yac506,n_yac507
                  from wsjb.irac01
                 where aab001 = prm_aab001
                   and aac001 = v_aac001
                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                 AND iaa002 = '2'
                   and iaa100 = (select max(iaa100) from wsjb.irac01
                                    WHERE AAB001 = prm_aab001
                                   AND AAC001 = v_aac001
                                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                   AND iaa002 = '2'
                                   AND iaa100 >= to_number(prm_aae001||'01'));
           ELSE
             --有缴费记录才给显示缴费基数
               SELECT count(1)
                INTO n_count
                FROM wsjb.irac08a1  A
               WHERE A.AAB001 = prm_aab001
                 AND a.aac001 = v_aac001
                 AND A.aae143 = '01'
                 AND A.aae002 >= (SELECT aae041
                                    FROM xasi2.AA02A3
                                   WHERE aae140 = '01'
                                      AND aae001 = prm_aae001);
               IF n_count >0 THEN
                  --获取养老基数
                 SELECT aac040 ,yac004
                   INTO n_yac506,n_yac507
                   FROM wsjb.IRAC01A3
                  WHERE aab001 = prm_aab001
                      AND aac001 = v_aac001;
               END IF ;
           END IF;
        END IF;
       ELSE
           select COUNT(1)
             INTO n_count
              from wsjb.irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
         IF n_count > 0 THEN
             select aac040 ,yac004
                into n_yac506, n_yac507
                from wsjb.irac01
               where aab001 = prm_aab001
                 and aac001 = v_aac001
                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
               AND iaa002 = '2'
                 and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));

         END IF;

       END IF;
       IF n_yac506 IS NULL THEN
           n_yac506 := 0;
       END IF;
        IF n_yac507 IS NULL THEN
         --是否存在养老缴费记录
           SELECT count(1)
             INTO n_count
            FROM wsjb.irac08a1  A
           WHERE A.AAB001 = prm_aab001
             AND A.aae143 = '01'
             AND A.aac001 = v_aac001
             AND A.aae002 >= (SELECT aae041
                                FROM xasi2.AA02A3
                               WHERE aae140 = '01'
                                  AND aae001 = prm_aae001);
           IF n_count > 0 THEN
             --存在则获取最大一次缴费期的基数
            SELECT  aac040,aae180
              INTO n_yac506,n_yac507
              FROM wsjb.irac08a1
             WHERE aac001 =  v_aac001
               AND aab001 =  prm_aab001
               AND aae143 = '01'
               AND aae002 = (SELECT MAX(aae002)
                                FROM wsjb.irac08a1
                               WHERE aac001 =  v_aac001
                                 AND aab001 =  prm_aab001
                                 AND aae140 = '01'
                                 AND aae143 = '01'
                                 AND aae002 >= (SELECT aae041
                                                  FROM xasi2.AA02A3
                                                 WHERE aae140 = '01'
                                                    AND aae001 = prm_aae001));
          ELSE
            n_yac507 := 0;
          END IF;

       END IF;
       IF n_yac506 = 0 AND n_yac507 = 0 THEN
        SELECT aac040,aae180
              INTO n_yac506,n_yac507
              FROM wsjb.irac08a1
             WHERE aac001 =  v_aac001
               AND aab001 =  prm_aab001
               AND aae143 = '01'
               AND aae002 = (SELECT MAX(aae002)
                                FROM wsjb.irac08a1
                               WHERE aac001 =  v_aac001
                                 AND aab001 =  prm_aab001
                                 AND aae140 = '01'
                                 AND aae143 = '01'
                                 AND aae002 >= (SELECT aae041
                                                  FROM xasi2.AA02A3
                                                 WHERE aae140 = '01'
                                                    AND aae001 = prm_aae001));
        END if;
       IF n_yac508 IS NULL THEN
           n_yac508 := 0;
       END IF;

        INSERT INTO xasi2.ac01k8 (
                                    aac001,
                                    aab001,
                                    aac002,
                                    aac003,
                                    aac009,
                                    yac506,
                                    yac507,
                                    yac508,
                                    aae110,
                                    aae210,
                                    aae310,
                                    aae410,
                                    aae510,
                                    aae311,
                                    aae001,
                                    yac503,
                                    yac005,
                                    yae092,
                                    iaa002,
                                    yae110,
                                    yab019,
                                    aae034
                                    )VALUES(
                                    rec_aac001.aac001,
                                    prm_aab001,
                                    v_aac002,
                                    v_aac003,
                                    v_aac009,
                                    n_yac506,
                                    n_yac507,
                                    0,
                                    v_aae110,
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    prm_aae001,
                                    v_yac503,
                                    n_yac005,
                                    prm_yae092,
                                    '0',
                                    v_yae110,
                                    '1',
                                    SYSDATE
                                    );
         IF v_yab029 IS NOT NULL THEN
          UPDATE xasi2.ac01k8
             SET aac001 = v_yab029
           WHERE aac001 = rec_aac001.aac001
             AND aab001 = prm_aab001
             AND aae001 = prm_aae001;
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
         prm_ErrorMsg := '数据库错误:'|| SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE()||v_aac001||' '||v_yab029;
         RETURN;
   END prc_YLqueryjishu;

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
        prm_ErrorMsg     OUT    VARCHAR2             )
    IS
        n_count  number(6);
       n_count1 number(6);
       n_count2 number(6);
       v_aac001 irac01.aac001%TYPE;
       v_aac002 irac01.aac002%TYPE;
       v_aac003 irac01.aac003%TYPE;
       v_aac009 irac01.aac009%TYPE;
       v_yac503 irac01.yac503%TYPE;--工资类别
       n_yac506 NUMBER(14,2);--原缴费工资
       n_yac507 NUMBER(14,2);--原养老基数
       n_yac508 NUMBER(14,2);--原缴费基数
       n_yac005 NUMBER(14,2);--原工伤缴费基数
       v_aae110 irac01.aae110%TYPE;
       v_aae210 irac01.aae210%TYPE;
       v_aae310 irac01.aae310%TYPE;
       v_aae410 irac01.aae410%TYPE;
       v_aae510 irac01.aae510%TYPE;
       v_aae311 irac01.aae311%TYPE;
       v_yae310 VARCHAR2(3000);--医疗备注
       v_yae110 VARCHAR2(3000);--养老备注
       v_yae210 VARCHAR2(3000);--失业备注
       v_yae410 VARCHAR2(3000);--工伤备注
       v_yae510 VARCHAR2(3000);--生育备注

       cursor cur_aac001 is
          SELECT DISTINCT AAC001
            FROM xasi2.ac08 A
           WHERE EXISTS (SELECT 1
                    FROM xasi2.AB08A8
                   WHERE AAB001 = prm_aab001
                     AND AAE041 >= to_number(prm_aae001||'01')
                     AND YAE518 = A.YAE518)
             AND AAC008 = '1'
             AND AAB001 = prm_aab001
             AND AAE002 = (SELECT YAE097 FROM xasi2.AB02 WHERE AAB001 = prm_aab001 AND AAB051 = '1' AND AAE140 = '06' )
          UNION
          SELECT DISTINCT AAC001
            FROM xasi2.AC08A1 A
           WHERE EXISTS (SELECT 1
                    FROM xasi2.AB08
                   WHERE AAB001 = prm_aab001
                     AND AAE041 >= to_number(prm_aae001||'01')
                     AND YAE518 = A.YAE518)
             AND AAC008 = '1'
             AND AAB001 = prm_aab001
             AND AAE002 = (SELECT YAE097 FROM xasi2.AB02 WHERE AAB001 = prm_aab001 AND AAB051 = '1' AND AAE140 = '06' )
           UNION
           SELECT DISTINCT AAC001
            FROM xasi2.AC08A3 A
           WHERE EXISTS (SELECT 1
                    FROM xasi2.AB08A8
                   WHERE AAB001 = prm_aab001
                     AND AAE041 >= to_number(prm_aae001||'01')
                     AND YAE518 = A.YAE518)
             AND AAC008 = '1'
             AND AAB001 = prm_aab001
             AND AAE002 = (SELECT YAE097 FROM xasi2.AB02 WHERE AAB001 = prm_aab001 AND AAB051 = '1' AND AAE140 = '06' );
       --增减变动
       cursor cur_aae310 is
           SELECT iaa001,
                  aac001,
                  aab001,
                  aac002,
                  aac003,
                  aac040,
                  yac004,
                  yac005,
                  iaa100,
                  aae110,
                  aae120,
                  aae210,
                  aae310,
                  aae410,
                  aae510,
                  aae311
            FROM wsjb.irac01
           WHERE AAB001 = prm_aab001
             AND AAC001 = v_aac001
             AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
             AND iaa100 >= to_number(prm_aae001||'01')
             ORDER BY IAA100;

    BEGIN
      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;
      n_count1     :=0;
      n_count2     :=0;
      n_yac506     :=0;
      n_yac507     :=0;
      n_yac508     :=0;
      n_yac005     :=0;
      v_aae110 := '';
      v_aae210 := '';
      v_aae310 := '';
      v_aae410 := '';
      v_aae510 := '';
      v_aae311 := '';
      /*必要的数据校验*/
      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '单位编号不能为空!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_ErrorMsg := '操作人员编号不能为空!';
         RETURN;
      END IF;

      FOR rec_aac001 in cur_aac001 LOOP
        v_yac503 := '0';
        n_count  :=0;
        n_count1 :=0;
        n_count2 :=0;
        n_yac506 :=0;
        n_yac507 :=0;
        n_yac508 :=0;
        n_yac005 :=0;
        v_aae110 := '';
        v_aae210 := '';
        v_aae310 := '';
        v_aae410 := '';
        v_aae510 := '';
        v_aae311 := '';
        v_yae310 := '';
        v_yae110 := '';
        v_yae210 := '';
        v_yae410 := '';
        v_yae510 := '';

        SELECT aac001,aac002,aac003,aac009
          INTO v_aac001,v_aac002,v_aac003,v_aac009
          FROM xasi2.ac01
         WHERE aac001 = rec_aac001.aac001;

        FOR rec_aae310 IN cur_aae310 LOOP
            --只显示机关养老保险的相关信息
            /*
             IF rec_aae310.aae310 IN ('1','10') THEN
               v_yae310 := v_yae310||substr(rec_aae310.iaa100,5)||'月增/';
             END IF;
             IF rec_aae310.aae310 = '3' THEN
               v_yae310 := v_yae310||substr(rec_aae310.iaa100,5)||'月减/';
               v_aae310 := '21';
             END IF;

             IF rec_aae310.aae210 IN ('1','10') THEN
               v_yae210 := v_yae210||substr(rec_aae310.iaa100,5)||'月增/';
             END IF;
             IF rec_aae310.aae210 = '3' THEN
               v_yae210 := v_yae210||substr(rec_aae310.iaa100,5)||'月减/';
               v_aae210 := '21';
             END IF;

             IF rec_aae310.aae410 IN ('1','10') THEN
               v_yae410 := v_yae410||substr(rec_aae310.iaa100,5)||'月增/';
             END IF;
             IF rec_aae310.aae410 = '3' THEN
               v_yae410 := v_yae410||substr(rec_aae310.iaa100,5)||'月减/';
               v_aae410 := '21';
             END IF;

             IF rec_aae310.aae510 IN ('1','10') THEN
               v_yae510 := v_yae510||substr(rec_aae310.iaa100,5)||'月增/';
             END IF;
             IF rec_aae310.aae510 = '3' THEN
               v_yae510 := v_yae510||substr(rec_aae310.iaa100,5)||'月减/';
               v_aae510 := '21';
             END IF;

             IF rec_aae310.aae311 = '3' THEN
               v_aae311 := '21';
             END IF;

             IF rec_aae310.iaa001 = '9' AND rec_aae310.aae310 = '2' AND rec_aae310.aae510 = '3' AND rec_aae310.aae311 = '2'THEN
               v_yae310 := v_yae310||substr(rec_aae310.iaa100,5)||'月待退/';
               v_aae310 := '21';
             END IF;
             */
             IF rec_aae310.aae120 IN ('1','10') THEN
               v_yae110 := v_yae110||substr(rec_aae310.iaa100,5)||'月增/';
             END IF;
             IF rec_aae310.aae120 = '3' THEN
               v_yae110 := v_yae110||substr(rec_aae310.iaa100,5)||'月减/';
               v_aae110 := '21';
             END IF;
           END LOOP;
      --只提取机关养老的基数
     /*
      --判断是否参医疗记录
        SELECT count(1)
          INTO n_count
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND aae140 = '03';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '03';
        SELECT count(1)
          INTO n_count2
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 IN ('2','3')
           AND aae140 = '03';
         IF n_count1 > 0 THEN
          v_aae310 := '2';
          SELECT aac040,yac004,yac503
            INTO n_yac506,n_yac508,v_yac503
            FROM AC02
           WHERE AAB001 = prm_aab001
             AND AAC001 = v_aac001
             AND aac031 = '1'
             AND aae140 = '03';
         END IF;
         IF n_count2 > 0 THEN
          SELECT aac040,yac004,yac503
            INTO n_yac506,n_yac508,v_yac503
            FROM AC02
           WHERE AAB001 = prm_aab001
             AND AAC001 = v_aac001
             AND aac031 IN ('2','3')
             AND aae140 = '03';
         END IF;

       ELSE
           select COUNT(1)
             INTO n_count
              from irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
         IF n_count > 0 THEN
           select aac040,
                   yac005
              into n_yac506,
                   n_yac508
              from irac01
             where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
              AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from irac01
                              WHERE AAB001 = prm_aab001
                                AND AAC001 = v_aac001
                                AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                AND iaa002 = '2'
                                AND iaa100 >= to_number(prm_aae001||'01'));

           -- SELECT yac503 INTO v_yac503 FROM ac02 WHERE aac001 = v_aac001 and aae140 = '03';
         END IF;
       END IF;


        --判断是否参失业记录
        SELECT count(1)
          INTO n_count
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = rec_aac001.aac001
           AND aae140 = '02';
       IF n_count > 0 THEN --ac02有参保记录
       --是否为参保状态
         SELECT count(1)
          INTO n_count1
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = rec_aac001.aac001
           AND AAC031 = '1'
           AND aae140 = '02';
        SELECT count(1)
          INTO n_count2
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = rec_aac001.aac001
           AND AAC031 = '2'
           AND aae140 = '02';

         IF n_count1 > 0 THEN--参保
          v_aae210 := '2';
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac508,v_yac503
              FROM AC02
             WHERE AAB001 = prm_aab001
               AND AAC001 = rec_aac001.aac001
               AND aac031 = '1'
               AND aae140 = '02';
          ELSE
           SELECT count(1)
             INTO n_count1
             FROM AC02
            WHERE AAB001 = prm_aab001
              AND AAC001 = rec_aac001.aac001
              AND AAC031 = '2'
              AND aae140 = '03';
            IF n_count1 > 0 THEN
              SELECT aac040,yac004,yac503
                INTO n_yac506,n_yac508,v_yac503
                FROM AC02
               WHERE AAB001 = prm_aab001
                 AND AAC001 = rec_aac001.aac001
                 AND aac031 = '1'
                 AND aae140 = '02';
            END IF;

          END IF;
         END IF;
         IF n_count2 > 0 THEN --停保
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac508,v_yac503
              FROM AC02
             WHERE AAB001 = prm_aab001
               AND AAC001 = rec_aac001.aac001
               AND aac031 = '2'
               AND aae140 = '02';
          END IF;
         END IF;

       ELSE
          select COUNT(1)
             INTO n_count
              from irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
        IF n_count > 0 THEN
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
                select aac040,
                       yac005
                  into n_yac506,
                       n_yac508
                  from irac01
                 where aab001 = prm_aab001
                   and aac001 = v_aac001
                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                 AND iaa002 = '2'
                   and iaa100 = (select max(iaa100) from irac01
                                    WHERE AAB001 = prm_aab001
                                   AND AAC001 = v_aac001
                                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                   AND iaa002 = '2'
                                   AND iaa100 >= to_number(prm_aae001||'01'));
            --   SELECT yac503 INTO v_yac503 FROM ac02 WHERE aac001 = v_aac001 and aae140 = '02';
           END IF;
        END IF;
       END IF;

       --判断是否参工伤记录
        SELECT count(1)
          INTO n_count
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND aae140 = '04';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '04';
        SELECT count(1)
          INTO n_count2
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '2'
           AND aae140 = '04';
         IF n_count1 > 0 THEN
          v_aae410 := '2';
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac508,v_yac503
              FROM AC02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '1'
               AND aae140 = '04';
               n_yac005 := n_yac508;
          ELSE
           SELECT count(1)
             INTO n_count1
             FROM AC02
            WHERE AAB001 = prm_aab001
              AND AAC001 = rec_aac001.aac001
              AND AAC031 = '2'
              AND aae140 = '02';
            IF n_count1 > 0 THEN
              SELECT aac040,yac004,yac503
                INTO n_yac506,n_yac508,v_yac503
                FROM AC02
               WHERE AAB001 = prm_aab001
                 AND AAC001 = rec_aac001.aac001
                 AND aac031 = '1'
                 AND aae140 = '04';
            END IF;
            SELECT yac004
              INTO n_yac005
              FROM AC02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '1'
               AND aae140 = '04';
          END IF;

         END IF;
         IF n_count2 > 0 THEN
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac508,v_yac503
              FROM AC02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '2'
               AND aae140 = '04';
               n_yac005 := n_yac508;
          ELSE
            SELECT yac004
              INTO n_yac005
              FROM AC02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '2'
               AND aae140 = '04';
          END IF;
         END IF;

       ELSE
         select COUNT(1)
             INTO n_count
              from irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
        IF n_count > 0 THEN
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
              select aac040,
                     yac005
                into n_yac506,
                     n_yac508
                from irac01
               where aab001 = prm_aab001
                 and aac001 = v_aac001
                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
               AND iaa002 = '2'
                 and iaa100 = (select max(iaa100) from irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
              -- SELECT yac503 INTO v_yac503 FROM ac02 WHERE aac001 = v_aac001 and aae140 = '04';
               n_yac005 := n_yac508;
          ELSE
            n_yac005 := n_yac508;
          END IF;
         END IF;
       END IF;

       --判断是否参生育记录
        SELECT count(1)
          INTO n_count
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND aae140 = '05';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '05';
        SELECT count(1)
          INTO n_count2
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '2'
           AND aae140 = '05';
         IF n_count1 > 0 THEN
          v_aae510 := '2';
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac508,v_yac503
              FROM AC02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '1'
               AND aae140 = '05';
          END IF;

         END IF;
         IF n_count2 > 0 THEN
          IF n_yac506 = 0 AND n_yac508 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac508,v_yac503
              FROM AC02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '2'
               AND aae140 = '05';
          END IF;
         END IF;
       ELSE
         select COUNT(1)
             INTO n_count
              from irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
         IF n_count > 0 THEN
             IF n_yac506 = 0 AND n_yac508 = 0 THEN
                select aac040,
                       yac005
                  into n_yac506,
                       n_yac508
                  from irac01
                 where aab001 = prm_aab001
                   and aac001 = v_aac001
                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                 AND iaa002 = '2'
                   and iaa100 = (select max(iaa100) from irac01
                                    WHERE AAB001 = prm_aab001
                                   AND AAC001 = v_aac001
                                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                   AND iaa002 = '2'
                                   AND iaa100 >= to_number(prm_aae001||'01'));
               --  SELECT yac503 INTO v_yac503 FROM ac02 WHERE aac001 = v_aac001 and aae140 = '04';
             END IF;
          END IF;
       END IF;

        --判断是否参大额记录
        SELECT count(1)
          INTO n_count
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND aae140 = '07';
       IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '07';
        SELECT count(1)
          INTO n_count2
          FROM AC02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '2'
           AND aae140 = '07';
         IF n_count1 > 0 THEN
          v_aae311 := '2';

         END IF;
       END IF;
       */
        --判断是否参机关养老记录
       SELECT count(1)
          INTO n_count
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAE140 = '06';
      IF n_count > 0 THEN
         SELECT count(1)
          INTO n_count1
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '1'
           AND aae140 = '06';
        SELECT count(1)
          INTO n_count2
          FROM xasi2.ac02
         WHERE AAB001 = prm_aab001
           AND AAC001 = v_aac001
           AND AAC031 = '2'
           AND aae140 = '06';
         IF n_count1 > 0 THEN
          v_aae110 := '2';
          IF n_yac507 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac507,v_yac503
              FROM xasi2.ac02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '1'
               AND aae140 = '06';
          END IF;

         END IF;
         IF n_count2 > 0 THEN
          IF n_yac507 = 0 THEN
            SELECT aac040,yac004,yac503
              INTO n_yac506,n_yac507,v_yac503
              FROM xasi2.ac02
             WHERE AAB001 = prm_aab001
               AND AAC001 = v_aac001
               AND aac031 = '2'
               AND aae140 = '06';
          END IF;
         END IF;
       ELSE
         select COUNT(1)
             INTO n_count
              from wsjb.irac01
            where aab001 = prm_aab001
               and aac001 = v_aac001
               AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
             AND iaa002 = '2'
               and iaa100 = (select max(iaa100) from wsjb.irac01
                                  WHERE AAB001 = prm_aab001
                                 AND AAC001 = v_aac001
                                 AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                 AND iaa002 = '2'
                                 AND iaa100 >= to_number(prm_aae001||'01'));
         IF n_count > 0 THEN
             IF n_yac507 = 0 THEN
                SELECT yac004
                  INTO n_yac507
                  FROM wsjb.irac01
                 WHERE aab001 = prm_aab001
                   AND aac001 = v_aac001
                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                 AND iaa002 = '2'
                   AND iaa100 = (select max(iaa100) from wsjb.irac01
                                    WHERE AAB001 = prm_aab001
                                   AND AAC001 = v_aac001
                                   AND IAA001 IN ('1', '5', '8', '6','3','7','9','10')
                                   AND iaa002 = '2'
                                   AND iaa100 >= to_number(prm_aae001||'01'));
               n_yac506 := n_yac507;
               --  SELECT yac503 INTO v_yac503 FROM ac02 WHERE aac001 = v_aac001 and aae140 = '04';
             END IF;
          END IF;
       END IF;


       IF n_yac506 IS NULL THEN
           n_yac506 := 0;
       END IF;
       IF n_yac507 IS NULL THEN
           n_yac507 := 0;
       END IF;
       IF n_yac508 IS NULL THEN
           n_yac508 := 0;
       END IF;

       INSERT INTO xasi2.ac01k8 (
                                    aac001,
                                    aab001,
                                    aac002,
                                    aac003,
                                    aac009,
                                    yac506,
                                    yac507,
                                    yac508,
                                    aae110,
                                    aae210,
                                    aae310,
                                    aae410,
                                    aae510,
                                    aae311,
                                    aae001,
                                    yac503,
                                    yac005,
                                    yae092,
                                    iaa002,
                                    yae110,
                                    yae310,
                                    yae210,
                                    yae410,
                                    yae510,
                                    yab019,
                                    aae034
                                    )VALUES(
                                    v_aac001,
                                    prm_aab001,
                                    v_aac002,
                                    v_aac003,
                                    v_aac009,
                                    n_yac506,
                                    n_yac507,
                                    n_yac508,
                                    v_aae110,
                                    v_aae210,
                                    v_aae310,
                                    v_aae410,
                                    v_aae510,
                                    v_aae311,
                                    prm_aae001,
                                    v_yac503,
                                    n_yac005,
                                    prm_yae092,
                                    '0' ,
                                    v_yae110,
                                    v_yae310,
                                    v_yae210,
                                    v_yae410,
                                    v_yae510,
                                    '2',
                                    SYSDATE
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
         prm_ErrorMsg := '数据库错误:'|| SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;

   END prc_JGqueryjishu;

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
        prm_ErrorMsg     OUT    VARCHAR2             )
    IS
      n_count number(6);
      n_aaa010 NUMBER(8);
      v_iaz004 irad02.iaz004%TYPE;
      v_aaz002 iraa01a1.aaz002%TYPE;
      v_iaz051 VARCHAR2(200);
      n_zcgz NUMBER(14,2);--正常工资
      n_bagz NUMBER(14,2);--备案工资
      num_yae097 NUMBER(8);
   cursor cur_a IS SELECT DISTINCT aac002
                     FROM wsjb.irac01c1
                    WHERE aab001=prm_aab001
                      AND SUBSTR(iaa100,1,4) = prm_aae001
                      AND yae031 = '1';
    BEGIN
     FOR rec_a IN cur_a LOOP
       SELECT count(1)
         INTO n_count
         FROM xasi2.ac01k8
        WHERE aac002 = rec_a.aac002
          AND aae001 = prm_aae001
          AND aab001 = prm_aab001;
      IF n_count > 1 THEN
       SELECT aac040
         INTO n_zcgz
         FROM xasi2.ac01k8
        WHERE aae001 = prm_aae001
          AND aab001 = prm_aab001
          AND aac002 = rec_a.aac002
          AND aae110 NOT IN ('备案');
       SELECT aac040
         INTO n_bagz
         FROM xasi2.ac01k8
        WHERE aae001 = prm_aae001
          AND aab001 = prm_aab001
          AND aac002 = rec_a.aac002
          AND aae110  IN ('备案');
        IF  n_zcgz <>  n_bagz THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '身份证号码为!'||rec_a.aac002||'的人员,正常年审工资与备案年审工资不一致，请检查！';
         RETURN;
        END IF;
       END IF;
       END LOOP;
      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;

       /*必要的数据校验*/
      IF prm_aab001 IS NULL THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '单位编号不能为空!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '操作人员编号不能为空!';
         RETURN;
      END IF;
      SELECT count(1)
        INTO n_count
        FROM (SELECT DISTINCT AAC001
                FROM xasi2.ac08 A
               WHERE EXISTS (SELECT 1
                        FROM xasi2.AB08A8
                       WHERE AAB001 = prm_aab001
                         AND AAE041 >= to_number(prm_aae001||'01')
                         AND YAE518 = A.YAE518)
                 AND AAC008 = '1'
                 AND AAB001 = prm_aab001
              UNION
              SELECT DISTINCT AAC001
                FROM xasi2.AC08A1 A
               WHERE EXISTS (SELECT 1
                        FROM xasi2.AB08
                       WHERE AAB001 = prm_aab001
                         AND AAE041 >= to_number(prm_aae001||'01')
                         AND YAE518 = A.YAE518)
                 AND AAC008 = '1'
                 AND AAB001 = prm_aab001
               UNION
               SELECT DISTINCT AAC001
                FROM xasi2.AC08A3 A
               WHERE EXISTS (SELECT 1
                        FROM xasi2.AB08A8
                       WHERE AAB001 = prm_aab001
                         AND AAE041 >= to_number(prm_aae001||'01')
                         AND YAE518 = A.YAE518)
                 AND AAC008 = '1'
                 AND AAB001 = prm_aab001);
     IF n_count <> 0 THEN
        SELECT count(1)
        INTO n_count
        FROM xasi2.ac01k8
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND yab019 = '1';
      IF n_count = 0 THEN
        prm_AppCode  := gn_def_ERR;
        prm_ErrorMsg := '没有申报人员记录，请认真确认后提交！';
        RETURN;
      END IF;
     END IF;
      SELECT count(1)
        INTO n_count
        FROM xasi2.ac01k8
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND (aac040 is null OR aac040 = 0)
         AND yab019 = '1';
      IF n_count > 0 THEN
        prm_AppCode  := gn_def_ERR;
        prm_ErrorMsg := '存在申报工资为0或空的人员，请认真确认后提交！';
        RETURN;
      END IF;
      SELECT aaa010
        INTO n_aaa010  --省最低工资标准
        FROM xasi2.aa02a1
       WHERE yaa001 = '13'
         AND aae001 = prm_aae001;
       SELECT count(1)
        INTO n_count
        FROM xasi2.ac01k8
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND yab019 = '1'
         AND aac040 < n_aaa010;
      IF n_count > 0 THEN
        prm_ErrorMsg := '存在申报工资小于'||n_aaa010||'的人员，不符合省最低工资标准，请认真确认后提交！';
        RETURN;
      END IF;

       SELECT count(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A05'
         AND iaa002 = '1'
         AND aae001 = prm_aae001;
      IF n_count > 0 THEN
        prm_ErrorMsg := '已存在单位编号为'||prm_aab001||'的'||to_char(prm_aae001)||'年的年申报记录!';
        RETURN;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
         IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '没有获取到序列号AAZ002!';
            RETURN;
         END IF;
      v_iaz051 := PKG_COMMON.fun_cbbh('JSSB',PKG_Constant.YAB003_JBFZX);
         IF v_iaz051 IS NULL OR v_iaz051 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '没有获取到档案编号!';
            RETURN;
         END IF;

      -- 年申报补差
      prc_YearSalaryAdjustPaded(prm_aab001  ,--单位编号  必填
                                ''  ,--个人编号  非必填
                                0  , --工资 非必填
                                prm_aae001  ,--年审年度
                                prm_yae092  ,--经办人
                                PKG_Constant.YAB003_JBFZX  ,--参保所属分中心
                                '1',  --业务类型标志 1-一般企业，2-机关养老险种
                                prm_AppCode ,
                                prm_ErrorMsg );
      IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
         RETURN;
      END IF;


      SELECT count(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A05'
         AND iaa002 = '3'
         AND iaa006 = '0'
         AND aae001 = prm_aae001;
     IF n_count > 0 THEN
       UPDATE wsjb.irad51
          SET iaa002 = '1',
              iaz051 = v_iaz051
        WHERE aab001 = prm_aab001
         AND iaa011 = 'A05'
         AND iaa002 = '3'
         AND iaa006 = '0'
         AND aae001 = prm_aae001;

      UPDATE xasi2.ac01k8
          SET iaa002 = '1',
              aae035 = sysdate
        WHERE aab001 = prm_aab001
          AND iaa002 = '3'
          AND aae001 = prm_aae001
          AND yab019 = '1';
     ELSE
       v_iaz004 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ004');
         IF v_iaz004 IS NULL OR v_iaz004 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '没有获取到序列号IAZ004!';
            RETURN;
         END IF;

          SELECT MAX(yae097)
       INTO num_yae097
       FROM (SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(yae097),'yyyymm'),1),'yyyymm')) AS yae097   --获取做帐期号
               FROM xasi2.ab02
              WHERE aab001 = prm_aab001
              UNION
             SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(aae003),'yyyymm'),1),'yyyymm')) AS yae097
               FROM wsjb.irab08
              WHERE aab001 = prm_aab001
                AND yae517 = 'H01'  );

       INSERT INTO wsjb.irad51  (
                          iaz004,
                          aaz002,
                          iaa011,
                          aae011,
                          aae035,
                          aab001,
                          yab003,
                          iaa002,
                          iaa006,
                          aae001,
                          iaz051,
                          aae003
                          )VALUES(
                          v_iaz004,
                          v_aaz002,
                          'A05',
                          prm_yae092,
                          sysdate,
                          prm_aab001,
                          PKG_Constant.YAB003_JBFZX,
                          '1',
                          '0',
                          prm_aae001,
                          v_iaz051,
                          num_yae097
                          );



       UPDATE xasi2.ac01k8
          SET
              iaz004 = v_iaz004,
              iaa002 = '1',
              aae035 = sysdate
        WHERE aab001 = prm_aab001
          AND iaa002 = '0'
          AND aae001 = prm_aae001
          AND yab019 = '1';
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
                  v_aaz002,
                  PKG_Constant.AAA121_YIR,
                  prm_yae092,
                  PKG_Constant.YAB003_JBFZX,
                  prm_yae092,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate
                 );

          -- 计算基数变化比例
          prc_YearApplyJSProportions (prm_aab001,--单位编号
                       prm_aae001,--年审年度
                       prm_yae092, --经办人
                       prm_AppCode,
                       prm_ErrorMsg);


   EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| SQLERRM ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
         RETURN;
   END prc_YearInternetApply;

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
        prm_ErrorMsg     OUT    VARCHAR2             )
    IS
       n_count number(6);
      n_aaa010 NUMBER(8);
      v_iaz004 irad02.iaz004%TYPE;
      v_aaz002 irad01.aaz002%TYPE;
      v_iaz051 irad51.iaz051%TYPE;
    BEGIN
      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;

       /*必要的数据校验*/
      IF prm_aab001 IS NULL THEN

         prm_ErrorMsg := '单位编号不能为空!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN

         prm_ErrorMsg := '操作人员编号不能为空!';
         RETURN;
      END IF;

      SELECT count(1)
        INTO n_count
        FROM xasi2.ac01k8
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND yab019 = '2'; --机关养老险种基数申报
      IF n_count = 0 THEN
        prm_ErrorMsg := '没有申报人员记录，请认真确认后提交！';
        RETURN;
      END IF;

      SELECT count(1)
        INTO n_count
        FROM xasi2.ac01k8
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND (aac040 is null OR aac040 = 0)
         AND yab019 = '2';
      IF n_count > 0 THEN
        prm_ErrorMsg := '存在申报工资为0或空的人员，请认真确认后提交！';
        RETURN;
      END IF;


       SELECT count(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A16'  --机关养老基数申报
         AND iaa002 = '1'
         AND aae001 = prm_aae001;
      IF n_count > 0 THEN
        prm_ErrorMsg := '已存在单位编号为'||prm_aab001||'的'||to_char(prm_aae001)||'年的年申报记录!';
        RETURN;
      END IF;

      v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
         IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '没有获取到序列号AAZ002!';
            RETURN;
         END IF;
      v_iaz051 := PKG_COMMON.fun_cbbh('JSSB',PKG_Constant.YAB003_JBFZX);
         IF v_iaz051 IS NULL OR v_iaz051 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '没有获取到档案编号!';
            RETURN;
         END IF;
      prc_YearSalaryAdjustPaded(prm_aab001  ,--单位编号  必填
                                ''  ,--个人编号  非必填
                                0  , --工资 非必填
                                prm_aae001  ,--年审年度
                                prm_yae092  ,--经办人
                                PKG_Constant.YAB003_JBFZX  ,--参保所属分中心
                                '2',  --业务类型标志 1-一般企业，2-机关养老险种
                                prm_AppCode ,
                                prm_ErrorMsg );
      IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
         RETURN;
      END IF;


      SELECT count(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A16'
         AND iaa002 = '3'
         AND iaa006 = '0'
         AND aae001 = prm_aae001;
     IF n_count > 0 THEN
       UPDATE wsjb.irad51
          SET iaa002 = '1',
              iaz051 = v_iaz051
        WHERE aab001 = prm_aab001
         AND iaa011 = 'A16'
         AND iaa002 = '3'
         AND iaa006 = '0'
         AND aae001 = prm_aae001;

      UPDATE xasi2.ac01k8
          SET iaa002 = '1',
              aae035 = sysdate
        WHERE aab001 = prm_aab001
          AND iaa002 = '3'
          AND aae001 = prm_aae001
          AND yab019 = '2';
     ELSE
       v_iaz004 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ004');
         IF v_iaz004 IS NULL OR v_iaz004 = '' THEN
            ROLLBACK;
            prm_AppCode  :=  gn_def_ERR;
            prm_ErrorMsg := '没有获取到序列号IAZ004!';
            RETURN;
         END IF;
       INSERT INTO wsjb.irad51  (
                          iaz004,
                          aaz002,
                          iaa011,
                          aae011,
                          aae035,
                          aab001,
                          yab003,
                          iaa002,
                          iaa006,
                          aae001,
                          iaz051
                          )VALUES(
                          v_iaz004,
                          v_aaz002,
                          'A16',
                          prm_yae092,
                          sysdate,
                          prm_aab001,
                          PKG_Constant.YAB003_JBFZX,
                          '1',
                          '0',
                          prm_aae001,
                          v_iaz051
                          );
       UPDATE xasi2.ac01k8
          SET iaz004 = v_iaz004,
              iaa002 = '1',
              aae035 = sysdate
        WHERE aab001 = prm_aab001
          AND iaa002 = '0'
          AND aae001 = prm_aae001
          AND yab019 = '2';
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
                  v_aaz002,
                  PKG_Constant.AAA121_YIR,
                  prm_yae092,
                  'A16',
                  prm_yae092,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate
                 );


   EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
         RETURN;
   END prc_JGYearInternetApply;

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
                 prm_aae001       IN     NUMBER(4),--申报年度
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
        prm_ErrorMsg     OUT    VARCHAR2             )
     IS
         n_count NUMBER(6);
        v_iaz004 irad02.iaz004%TYPE;
     BEGIN
      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;

       /*必要的数据校验*/
      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '单位编号不能为空!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_ErrorMsg := '操作人员编号不能为空!';
         RETURN;
      END IF;

      SELECT count(1)
        INTO n_count
        FROM xasi2.ac01k8
       WHERE aab001 = prm_aab001
         AND IAA002 <> '0'
         AND IAA002<>'1'
         AND aae001 = prm_aae001
         AND yab019 = '1';
      IF n_count > 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '已存在审核的数据，不能撤销申请!';
         RETURN;
      END IF;

      SELECT count(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A05'
         AND aae001 = prm_aae001;
      IF n_count = 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '没有申报信息，不能撤销！!';
         RETURN;
      END IF;
      --检索流水号
      SELECT iaz004
        INTO v_iaz004
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A05'
         AND aae001 = prm_aae001;
      --检查是否有年审预约申请信息
      SELECT count(1)
        INTO n_count
        FROM wsjb.iraa16
       WHERE iaz004 = v_iaz004
         AND aaa170 = '0'
         AND aae120 = '0';
      IF n_count > 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '存在申报的年审业务预约信息，不能撤销，请先将年审业务预约信息撤销！';
         RETURN;
      END IF;

      DELETE wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A05'
         AND aae001 = prm_aae001;

      UPDATE xasi2.ac01k8
         SET iaz004 = '',
             iaa002 = '0'
       WHERE aab001 = prm_aab001
         AND iaa002 = '1'
         AND aae001 = prm_aae001
         AND yab019 = '1';

      --modify by fenggg at 20181208 begin
      --撤销年审申报时同时删除tmp_ac42
      DELETE wsjb.tmp_ac42
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001;
     --modify by fenggg at 20181208 end

     --modify by whm at 20190812start
     --撤销年审申报的同时删除irad54中基数降低的记录
     DELETE wsjb.irad54
       WHERE iaa011 ='A05-1'
         AND aab001 = prm_aab001
         AND aae001 = prm_aae001;
     --modify by whm at 20190812end

      EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
         RETURN;
   END prc_RBYearInternetApply;

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
                 prm_aae001       IN     NUMBER(4),--申报年度
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
        prm_ErrorMsg     OUT    VARCHAR2             )
     IS
        n_count NUMBER(6);
     BEGIN
      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;

       /*必要的数据校验*/
      IF prm_aab001 IS NULL THEN
         prm_ErrorMsg := '单位编号不能为空!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_ErrorMsg := '操作人员编号不能为空!';
         RETURN;
      END IF;

      SELECT count(1)
        INTO n_count
        FROM xasi2.ac01k8
       WHERE aab001 = prm_aab001
         AND IAA002 <> '0'
         AND IAA002<>'1'
         AND aae001 = prm_aae001
         AND yab019 = '2';
      IF n_count > 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '已存在审核的数据，不能撤销申请!';
         RETURN;
      END IF;

      SELECT count(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A16'
         AND aae001 = prm_aae001;
      IF n_count = 0 THEN
         prm_AppCode  := gn_def_ERR;
         prm_ErrorMsg := '没有申报信息，不能撤销！!';
         RETURN;
      END IF;

      DELETE wsjb.irad51
       WHERE aab001 = prm_aab001
         AND iaa011 = 'A16'
         AND aae001 = prm_aae001;

      UPDATE xasi2.ac01k8
         SET iaz004 = '',
             iaa002 = '0'
       WHERE aab001 = prm_aab001
         AND iaa002 = '1'
         AND aae001 = prm_aae001
         AND yab019 = '2';

      EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
         RETURN;
   END prc_RBJGYearInternetApply;
/*****************************************************************************
   ** 过程名称 : prc_YearSalary
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：年申报审核--修改工资
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
PROCEDURE prc_YearSalary(prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                         prm_aae001       IN     NUMBER            ,--年审年度
                         prm_aae011       IN     irad31.aae011%TYPE,--经办人
                         prm_yab139       IN     VARCHAR2          ,--参保所属分中心
                         prm_yab019       IN     VARCHAR2 , --类型标志 1--企业基数申报 2--机关养老基数申报
                         prm_AppCode      OUT    VARCHAR2          ,
                         prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      num_count     NUMBER;
      v_msg        VARCHAR2(300);
      var_aaz002   irad31.aaz002%TYPE;
      num_aae041_year NUMBER(6);  --补差开始时间
      num_yae097   xasi2.ab02.yae097%TYPE; --单位最大做帐期号
      var_aae140   xasi2.ab02.aae140%TYPE; --险种
      var_aac001   xasi2.ac01.aac001%TYPE; --个人编号
      num_aae002   xasi2.ac08a1.aae002%TYPE;
      num_aac040   xasi2.ac02.aac040%TYPE;
      num_spgz     xasi2.ac02.aac040%TYPE;
      num_yac004   xasi2.ac02.yac004%TYPE;
      var_yab136   xasi2.ab01.yab136%TYPE;
      var_yab275   xasi2.ab01.yab275%TYPE;
      var_aae119   xasi2.ab01.aae119%TYPE;
      var_aab019   xasi2.ab01.aab019%TYPE;
      var_yac503   xasi2.ac02.yac503%TYPE;
      var_yac505   xasi2.ac02.yac505%TYPE;
      num_yac401   tmp_ac42.yac401%type;           --1月补差金额,NUMBER
      num_yac402   tmp_ac42.yac401%type;           --2月补差金额,NUMBER
      num_yac403   tmp_ac42.yac401%type;           --3月补差金额,NUMBER
      num_yac404   tmp_ac42.yac401%type;           --4月补差金额,NUMBER
      num_yac405   tmp_ac42.yac401%type;           --5月补差金额,NUMBER
      num_yac406   tmp_ac42.yac401%type;           --6月补差金额,NUMBER
      num_yac407   tmp_ac42.yac401%type;           --7月补差金额,NUMBER
      num_yac408   tmp_ac42.yac401%type;           --8月补差金额,NUMBER
      num_yac409   tmp_ac42.yac401%type;           --9月补差金额,NUMBER
      num_yac410   tmp_ac42.yac401%type;           --10月补差金额,NUMBER
      num_yac411   tmp_ac42.yac401%type;           --11月补差金额,NUMBER
      num_yac412   tmp_ac42.yac401%type;           --12月补差金额,NUMBER
      var_procNo   VARCHAR2(5);                    --过程号
      var_aae013   xasi2.ab08a8.aae013%TYPE;
      var_aae100   VARCHAR2(9);
      var_yae099   xasi2.ac04a3.yae099%TYPE;
      num_aic162   NUMBER(6);
      num_yac004_new xasi2.ac02.yac004%TYPE;
      num_yaa333_new xasi2.ac02.yaa333%TYPE;
      --获取单位提交的申报人员
      CURSOR cur_ab05a1 IS
        SELECT aac001,
               aab001,
               yac506,
               yac507,
               yac508,
               yac503,--工资类别
               aac040,--变更后缴费工资
               yac004,--变更后养老缴费基数
               yaa333,--变更后缴费基数
               yac005 --工伤缴费工资
          FROM xasi2.ac01k8
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND yab019 = prm_yab019;
      --获取人员的参保信息
      CURSOR cur_ac02 IS
        SELECT aae140,
               yac503,   --工资类别
               yac505,   --缴费人员类别
               aac040,
               yac004,
               yaa333
          FROM xasi2.ac02
         WHERE aac001 = var_aac001
           AND aab001 = prm_aab001
           AND aae140 NOT IN (xasi2.pkg_comm.AAE140_DEYL,'06')    --大额不进行补差
           AND prm_yab019 = '1'
       UNION
        SELECT aae140,
               yac503,   --工资类别
               yac505,   --缴费人员类别
               aac040,
               yac004,
               yaa333
          FROM xasi2.ac02
         WHERE aac001 = var_aac001
           AND aab001 = prm_aab001
           AND aae140 = '06'    --机关养老
          AND prm_yab019 = '2';

   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      var_procNo   :='Y01';
      var_yae099   := xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAE099');
      --获取单位当前的管理类型
      BEGIN
         SELECT yab136,
                yab275,
                aae119,
                aab019
           INTO var_yab136,
                var_yab275,
                var_aae119,
                var_aab019
           FROM xasi2.ab01
          WHERE aab001 = prm_aab001;
      EXCEPTION
         WHEN OTHERS THEN
            prm_AppCode := ''||var_procNo||'02';
            prm_ErrorMsg  := '单位编码'||prm_aab001||'社保经办机构'||prm_yab139||'没有获取到单位基本信息';
            RETURN;
      END;

      --医疗四险的年申报
      FOR rec_ab05a1 IN cur_ab05a1 LOOP

          --获取年审开始期号  取单位最大做帐期号下期
          SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(yae097),'yyyymm'),1),'yyyymm'))   --获取做帐期号
            INTO num_aae002
            FROM xasi2.ab02
           WHERE aab001 = prm_aab001;

          var_aac001 := rec_ab05a1.aac001;
          num_aac040 := TRUNC(rec_ab05a1.aac040);
          num_yac004_new := TRUNC(rec_ab05a1.yac004);--新养老基数
          num_yaa333_new := TRUNC(rec_ab05a1.yaa333);--新其他基数
          --如果是退休人员不更新基数
          SELECT count(1)
            INTO num_count
            FROM xasi2.kc01
           WHERE aac001 = rec_ab05a1.aac001
             AND akc021 = '21';

          IF num_count = 0 THEN
          --针对四险的

             FOR rec_ac02 IN cur_ac02 LOOP
                  var_aae140 := rec_ac02.aae140;
                 var_yac503 := rec_ac02.yac503;
                 var_yac505 := rec_ac02.yac505;
                 IF rec_ab05a1.yac508 > 0 OR var_aae140 = '06' THEN

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
                                                          prm_yab139   ,     --参保分中心
                                                          num_yac004   ,     --缴费基数
                                                          prm_AppCode  ,     --错误代码
                                                          prm_ErrorMsg );    --错误内容
                  IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                     RETURN;
                  END IF;
                  --判断个体工商户
                 IF var_aab019 = '60' THEN
                   --获取社平工资
                   num_spgz := xasi2.pkg_comm.fun_GetAvgSalary(var_aae140,'16',num_aae002,PKG_Constant.YAB003_JBFZX);
                   --如果险种为工伤 缴费工资和缴费基数为社平工资
                   IF var_aae140 = xasi2.pkg_comm.AAE140_GS THEN
                      num_yac004 := ROUND(num_spgz/12);
                    ELSE
                      IF num_aac040 > ROUND(num_spgz/12) THEN
                         num_yac004 := ROUND(num_spgz/12);
                      END  IF;
                    END IF;
                 END IF;
               IF var_aae140 = '06' THEN
                   num_aac040 := rec_ab05a1.yac004;
                   num_yac004 := rec_ab05a1.yac004;
               END IF;
                IF var_aae140 = xasi2.pkg_comm.AAE140_JBYL THEN
                             --退休逐月缴费人员
                             SELECT count(1)
                               INTO num_count
                               FROM xasi2.ac02_zy
                              WHERE aac001 = var_aac001
                                AND aae120 = '0';
                              IF num_count > 0 THEN
                                 SELECT aic162,
                                        yac004
                                   INTO num_aic162,
                                        num_yac004
                                   FROM xasi2.ac02_zy
                                  WHERE aac001 = var_aac001
                                    AND aae120 = '0';
                                 IF SUBSTR(num_aic162,0,4)= prm_aae001 THEN
                                    num_spgz := xasi2.pkg_comm.fun_GetAvgSalary(var_aae140,'16',prm_aae001||'12',PKG_Constant.YAB003_JBFZX);
                                    num_yac004 := ROUND(num_spgz/12);
                                 END IF;
                              END IF;
                          END IF;
               --更新人员的参保信息
               UPDATE xasi2.ac02
                  SET aac040 = num_aac040,     -- 申报工资
                      yac004 = num_yac004,      -- 缴费基数
                      yaa333 = 0
                WHERE aac001 = var_aac001
                  AND aae140 = var_aae140
                  AND aab001 = prm_aab001;

               --写个人缴费基数变更记录表
               INSERT INTO xasi2.ac04a3(YAE099,             --业务流水号,VARCHAR2
                                           AAC001,             --个人编号,VARCHAR2
                                           AAB001,             --单位编号,VARCHAR2
                                           AAE140,             --险种类型,VARCHAR2
                                           YAC235,             --工资变更类型,VARCHAR2
                                           YAC506,             --变更前工资,NUMBER
                                           YAC507,             --变更前缴费基数,NUMBER
                                           YAC514,             --变更前划帐户基数,NUMBER
                                           AAC040,             --缴费工资,NUMBER
                                           YAC004,             --缴费基数,NUMBER
                                           YAA333,             --账户基数,NUMBER
                                           AAE002,             --费款所属期,NUMBER
                                           AAE013,             --备注,VARCHAR2
                                           AAE011,             --经办人,NUMBER
                                           AAE036,             --经办时间,DATE
                                           YAB003,             --社保经办机构,VARCHAR2
                                           YAB139,             --参保所属分中心,VARCHAR2
                                           YAC503,             --工资类别,VARCHAR2
                                           YAC526              --变更前工资类别,VARCHAR2
                                           )
                                   VALUES (var_yae099,             --业务流水号,VARCHAR2
                                           var_aac001,             --个人编号,VARCHAR2
                                           prm_aab001,             --单位编号,VARCHAR2
                                           var_aae140,             --险种类型,VARCHAR2
                                           xasi2.pkg_comm.YAC235_PL,     --工资变更类型,VARCHAR2
                                           rec_ac02.aac040,         --变更前工资,NUMBER
                                           rec_ac02.yac004,         --变更前缴费基数,NUMBER
                                           rec_ac02.YAA333,         --变更前划帐户基数,NUMBER
                                           num_aac040,             --缴费工资,NUMBER
                                           num_yac004,             --缴费基数,NUMBER
                                           num_yac004,             --账户基数,NUMBER
                                           num_aae002,             --费款所属期,NUMBER
                                           '年申报'  ,                 --备注,VARCHAR2
                                           prm_aae011,             --经办人,NUMBER
                                           sysdate,             --经办时间,DATE
                                           prm_yab139,             --社保经办机构,VARCHAR2
                                           prm_yab139,             --参保所属分中心,VARCHAR2
                                           var_yac503,             --工资类别,VARCHAR2
                                           var_yac503);            --变更前工资类别,VARCHAR2
                END IF;
             END LOOP;
           END IF;
           --养老的年审
           SELECT count(1)
             INTO num_count
             FROM xasi2.ab02
            WHERE aab001 = prm_aab001
              AND aae140 = '06'
              AND aab051 = '1';
           IF rec_ab05a1.yac507 > 0 AND num_count = 0 THEN
              --获取养老的年审开始期号
              SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(aae003),'yyyymm'),1),'yyyymm'))
                INTO num_aae002
                FROM wsjb.irab08
               WHERE aab001 = prm_aab001
                 AND yae517 = xasi2.pkg_comm.yae517_H01;
              --调用保底封顶过程，获取缴费基数和缴费工资
              xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase
                                                     (var_aac001   ,     --个人编码
                                                      prm_aab001   ,     --单位编码
                                                      num_aac040   ,     --缴费工资
                                                      '0'   ,     --工资类别
                                                      '01'   ,     --险种类型
                                                      '010'   ,     --缴费人员类别
                                                      var_yab136   ,     --单位管理类型（区别独立缴费人员）
                                                      num_aae002   ,     --费款所属期
                                                      prm_yab139   ,     --参保分中心
                                                      num_yac004   ,     --缴费基数
                                                      prm_AppCode  ,     --错误代码
                                                      prm_ErrorMsg );    --错误内容
              IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                 RETURN;
              END IF;
              IF var_aab019 = '60' THEN
                 --获取社平工资
                 num_spgz := xasi2.pkg_comm.fun_GetAvgSalary('01','16',num_aae002,PKG_Constant.YAB003_JBFZX);
                 num_yac004 := num_aac040;

                 --如果险种为工伤 缴费工资和缴费基数为社平工资
                 IF num_aac040 < TRUNC(num_spgz/12*0.4)+1 THEN
                    num_yac004 := TRUNC(num_spgz/12*0.4)+1;
                 END IF;

                  IF num_aac040 > ROUND(num_spgz/12) THEN
                     num_yac004 := ROUND(num_spgz/12);
                  END  IF;

               END IF;
              --更新养老的缴费工资
             /** UPDATE irac01a3
                  SET aac040 = num_aac040,     -- 申报工资
                      yac004 = num_yac004     -- 缴费基数
                WHERE aac001 = var_aac001
                  AND aab001 = prm_aab001; */
                   UPDATE wsjb.IRAC01A3
                  SET aac040 = num_aac040,     -- 申报工资
                      yac004 = num_yac004_new     -- 缴费基数
                WHERE aac001 = var_aac001
                  AND aab001 = prm_aab001;


              --写个人缴费基数变更记录表
               INSERT INTO xasi2.ac04a3(YAE099,             --业务流水号,VARCHAR2
                                           AAC001,             --个人编号,VARCHAR2
                                           AAB001,             --单位编号,VARCHAR2
                                           AAE140,             --险种类型,VARCHAR2
                                           YAC235,             --工资变更类型,VARCHAR2
                                           YAC506,             --变更前工资,NUMBER
                                           YAC507,             --变更前缴费基数,NUMBER
                                           YAC514,             --变更前划帐户基数,NUMBER
                                           AAC040,             --缴费工资,NUMBER
                                           YAC004,             --缴费基数,NUMBER
                                           YAA333,             --账户基数,NUMBER
                                           AAE002,             --费款所属期,NUMBER
                                           AAE013,             --备注,VARCHAR2
                                           AAE011,             --经办人,NUMBER
                                           AAE036,             --经办时间,DATE
                                           YAB003,             --社保经办机构,VARCHAR2
                                           YAB139,             --参保所属分中心,VARCHAR2
                                           YAC503,             --工资类别,VARCHAR2
                                           YAC526              --变更前工资类别,VARCHAR2
                                           )
                                   VALUES (var_yae099,             --业务流水号,VARCHAR2
                                           var_aac001,             --个人编号,VARCHAR2
                                           prm_aab001,             --单位编号,VARCHAR2
                                           '01',             --险种类型,VARCHAR2
                                           xasi2.pkg_comm.YAC235_PL,     --工资变更类型,VARCHAR2
                                           rec_ab05a1.AAC040,         --变更前工资,NUMBER
                                           rec_ab05a1.YAC507,         --变更前缴费基数,NUMBER
                                           0,         --变更前划帐户基数,NUMBER
                                           num_aac040,             --缴费工资,NUMBER
                                           num_yac004_new,             --缴费基数,NUMBER
                                           num_yac004,             --账户基数,NUMBER
                                           num_aae002,             --费款所属期,NUMBER
                                           '年申报'  ,                 --备注,VARCHAR2
                                           prm_aae011,             --经办人,NUMBER
                                           sysdate,             --经办时间,DATE
                                           prm_yab139,             --社保经办机构,VARCHAR2
                                           prm_yab139,             --参保所属分中心,VARCHAR2
                                           '0',             --工资类别,VARCHAR2
                                           '0');            --变更前工资类别,VARCHAR2
           END IF;
           --回写业务流水号
           UPDATE xasi2.ac01k8
              SET yae099 = var_yae099,
                  iaa002 = '2',
                  aae036 = sysdate,
                  aae011 = prm_aae011
            WHERE AAB001 = prm_aab001
              AND aac001 = var_aac001
              AND aae001 = prm_aae001
              AND yab019 = prm_yab019;
     END LOOP;


   EXCEPTION
        WHEN OTHERS THEN
        /*关闭打开的游标*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
             RETURN;
END prc_YearSalary;
/*****************************************************************************
   ** 过程名称 : prc_YearSalaryRB
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：年申报审核--修改工资(回退)
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
   PROCEDURE prc_YearSalaryRB( prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                               prm_aae001       IN     NUMBER            ,--年审年度
                               prm_iaa011       IN     irad51.iaa011%TYPE,--业务类型
                               prm_yab019       IN     VARCHAR2     ,--类型标志
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          )
   IS
   n_count    NUMBER;
   v_aac001   irac01.aac001%TYPE;
   v_aab001   irac01.aab001%TYPE;
   v_aae140   irab02.aae140%TYPE;
   n_aac040   NUMBER(14,2);
   n_yac004   NUMBER(14,2);
   n_yaa333   NUMBER(14,2);
   v_yae099   xasi2.ae16.yae099%TYPE;
   CURSOR cur_ac04a3 IS
       SELECT YAE099,             --业务流水号,VARCHAR2
             AAC001,             --个人编号,VARCHAR2
             AAB001,             --单位编号,VARCHAR2
             AAE140,             --险种类型,VARCHAR2
             YAC235,             --工资变更类型,VARCHAR2
             YAC506,             --变更前工资,NUMBER
             YAC507,             --变更前缴费基数,NUMBER
             YAC514,             --变更前划帐户基数,NUMBER
             AAC040,             --缴费工资,NUMBER
             YAC004,             --缴费基数,NUMBER
             YAA333,             --账户基数,NUMBER
             AAE002              --费款所属期,NUMBER
        FROM xasi2.ac04a3
       WHERE yae099 = v_yae099;


   BEGIN
     prm_AppCode  := gn_def_OK;
    prm_ErrorMsg := '';
    n_aac040  := 0;
    n_yac004  := 0;



    --查询基数变更流水号
     SELECT distinct yae099 into v_yae099
       FROM xasi2.ac01k8
      WHERE aab001 = prm_aab001
        AND aae001 = prm_aae001
        AND yab019 = prm_yab019;

     --循环变更记录，回写原基数，工资
     FOR rec_ac04a3 IN cur_ac04a3 LOOP
        v_aac001 := rec_ac04a3.aac001;
        v_aab001 := rec_ac04a3.aab001;
         v_aae140 := rec_ac04a3.aae140;
         n_aac040 := rec_ac04a3.yac506;
         n_yac004 := rec_ac04a3.yac507;
         n_yaa333 := rec_ac04a3.yac514;
         IF v_aae140 = '01' THEN  --养老基数
           UPDATE wsjb.IRAC01A3
              SET aac040 = n_aac040,
                  yac004 = n_yac004
            WHERE aab001 = v_aab001
              AND aac001 = v_aac001;
         ELSE                      --其他四险基数
           UPDATE xasi2.ac02
              SET aac040 = n_aac040,
                  yac004 = n_yac004
            WHERE aab001 = v_aab001
              AND aac001 = v_aac001
              AND aae140 = v_aae140;
         END IF;

     END LOOP;
     --删除变更记录
     DELETE xasi2.ac04a3
      WHERE yae099 = v_yae099;
     --更新
     UPDATE xasi2.ac01k8
        SET yae099 = '',
            iaa002 = '1',
            aae036 = NULL,
            aae011 = NULL
      WHERE AAB001 = prm_aab001
        AND aae001 = prm_aae001
        AND yab019 = prm_yab019;

   EXCEPTION
        WHEN OTHERS THEN
             ROLLBACK;
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
             RETURN;

   END prc_YearSalaryRB;
/*****************************************************************************
   ** 过程名称 : prc_YearSalaryBC
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：年申报审核--补差
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
PROCEDURE prc_YearSalaryBC(prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                           prm_aae001       IN     NUMBER            ,--年审年度
                           prm_aae011       IN     irad31.aae011%TYPE,--经办人
                           prm_yab139       IN     VARCHAR2          ,--参保所属分中心
                           prm_iaa011       IN     irad51.iaa011%TYPE,--业务类型
                           prm_yab019       IN     VARCHAR2          ,--类型标志
                           prm_AppCode      OUT    VARCHAR2          ,
                           prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      num_count     NUMBER;
      v_msg        VARCHAR2(200);
      var_aaz002   irad51.aaz002%TYPE;
      var_aaz083   ab08.aaz083%TYPE;
      num_aae041_year NUMBER(6);  --补差开始时间
      num_yae097   xasi2.ab02.yae097%TYPE; --单位最大做帐期号
      var_aae140   xasi2.ab02.aae140%TYPE; --险种
      var_aac001   xasi2.ac01.aac001%TYPE; --个人编号
      num_aae002   xasi2.ac08a1.aae002%TYPE;
      num_aac040   xasi2.ac02.aac040%TYPE;
      num_spgz     xasi2.ac02.aac040%TYPE;
      num_yac004   xasi2.ac02.yac004%TYPE;
      var_yab136   xasi2.ab01.yab136%TYPE;
      var_yab275   xasi2.ab01.yab275%TYPE;
      var_aae119   xasi2.ab01.aae119%TYPE;
      var_aab019   xasi2.ab01.aab019%TYPE;
      var_yac503   xasi2.ac02.yac503%TYPE;
      var_yac505   xasi2.ac02.yac505%TYPE;
      num_yac401   tmp_ac42.yac401%type;           --1月补差金额,NUMBER
      num_yac402   tmp_ac42.yac401%type;           --2月补差金额,NUMBER
      num_yac403   tmp_ac42.yac401%type;           --3月补差金额,NUMBER
      num_yac404   tmp_ac42.yac401%type;           --4月补差金额,NUMBER
      num_yac405   tmp_ac42.yac401%type;           --5月补差金额,NUMBER
      num_yac406   tmp_ac42.yac401%type;           --6月补差金额,NUMBER
      num_yac407   tmp_ac42.yac401%type;           --7月补差金额,NUMBER
      num_yac408   tmp_ac42.yac401%type;           --8月补差金额,NUMBER
      num_yac409   tmp_ac42.yac401%type;           --9月补差金额,NUMBER
      num_yac410   tmp_ac42.yac401%type;           --10月补差金额,NUMBER
      num_yac411   tmp_ac42.yac401%type;           --11月补差金额,NUMBER
      num_yac412   tmp_ac42.yac401%type;           --12月补差金额,NUMBER
      var_procNo   VARCHAR2(5);                    --过程号
      var_aae013   xasi2.ab08a8.aae013%TYPE;
      var_aae100   VARCHAR2(9);
      var_yae099   xasi2.ac04a3.yae099%TYPE;
      var_yab222   xasi2.ab08.yab222%TYPE;
      var_aae076   xasi2.ab08.aae076%TYPE;
      var_yae010_110   xasi2.ab08.yae010%TYPE;
      var_yae010_120   xasi2.ab08.yae010%TYPE;
      var_yae010_210   xasi2.ab08.yae010%TYPE;
      var_yae010_310   xasi2.ab08.yae010%TYPE;
      var_yae010_410   xasi2.ab08.yae010%TYPE;
      var_yae010_510   xasi2.ab08.yae010%TYPE;
      var_yae010   xasi2.ab08.yae010%TYPE;
      var_yae517   xasi2.ab08.yae517%TYPE;


      CURSOR cur_aae140 IS
        SELECT DISTINCT aae140
          FROM wsjb.tmp_ac42
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND aae140 NOT in (PKG_Constant.AAE140_YL,'06')
           AND prm_yab019 = '1'
        UNION
        SELECT DISTINCT aae140
          FROM wsjb.tmp_ac42
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND aae140 = '06'
           AND prm_yab019 = '2' ;

      --获取单位提交的申报人员
      CURSOR cur_tmp_ac42 IS
        select AAC001,             --人员编号,VARCHAR2
               AAB001,             --单位编号,VARCHAR2
               AAE140,             --险种,VARCHAR2
               YAC401,             --1月补差金额,NUMBER
               YAC402,             --2月补差金额,NUMBER
               YAC403,             --3月补差金额,NUMBER
               YAC404,             --4月补差金额,NUMBER
               YAC405,             --5月补差金额,NUMBER
               YAC406,             --6月补差金额,NUMBER
               YAC407,             --7月补差金额,NUMBER
               YAC408,             --8月补差金额,NUMBER
               YAC409,             --9月补差金额,NUMBER
               YAC410,             --10月补差金额,NUMBER
               YAC411,             --11月补差金额,NUMBER
               YAC412,             --12月补差金额,NUMBER
               AAE013,             --备注,VARCHAR2
               aae001
          from wsjb.tmp_ac42   --人员险种补差信息表
         WHERE aab001 = prm_aab001
           AND AAC001 = var_aac001
           AND aae001 = prm_aae001
           AND aae140 = var_aae140;
      --获取人员的参保信息
      CURSOR cur_ab05a1 IS
        SELECT aac001,
               aab001,
               NVL(yac506,0) AS yac506,
               NVL(yac507,0) AS yac507,
               NVL(yac503,0) AS yac503,--工资类别
               NVL(aac040,0) AS aac040,--变更后缴费工资
               NVL(yac004,0) AS yac004,--变更后养老缴费基数
               NVL(yaa333,0) AS yaa333,--变更后缴费基数
               NVL(yac005,0) AS yac005--工伤缴费工资
          FROM xasi2.ac01k8
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND yab019 = prm_yab019
            AND (aae013 is null or aae013 ='1' or aae013 ='22');  
      --根据征收方式更新费用来源
      CURSOR cur_ab08 IS
      SELECT yae518,
             aae140
        FROM xasi2.AB08
       WHERE aab001 = prm_aab001
         AND yae517 IN (xasi2.pkg_comm.YAE517_H12,xasi2.pkg_comm.YAE517_H17)
         AND aae003 = num_yae097
         AND yab222 = var_yab222;
      --根据征收方式更新费用来源
      CURSOR cur_ab08a8 IS
      SELECT yae518,
             aae140
        FROM xasi2.AB08A8
       WHERE aab001 = prm_aab001
         AND yae517 = xasi2.pkg_comm.YAE517_H17
         AND aae003 = num_yae097
         AND yab222 = var_yab222;

   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      var_procNo   :='Y01';
      var_yae099   := xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAE099');
      --参数校验
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '单位编号不能为空' ;
         RETURN;
      END IF;

      IF prm_aae001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '年审年度不能为空' ;
         RETURN;
      END IF;

      --获取单位当前的管理类型
      BEGIN
         SELECT yab136,
                yab275,
                aae119,
                aab019
           INTO var_yab136,
                var_yab275,
                var_aae119,
                var_aab019
           FROM xasi2.ab01
          WHERE aab001 = prm_aab001;
      EXCEPTION
         WHEN OTHERS THEN
            prm_AppCode := ''||var_procNo||'02';
            prm_ErrorMsg  := '单位编码'||prm_aab001||'社保经办机构'||prm_yab139||'没有获取到单位基本信息';
            RETURN;
      END;


      SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(yae097),'yyyymm'),1),'yyyymm'))   --获取做帐期号
        INTO num_yae097
        FROM xasi2.ab02
       WHERE aab001 = prm_aab001
         AND aab051 = '1';


      num_aae002 := num_yae097;
      var_yab222 := xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAB222');
      --清空临时表数据
      DELETE xasi2.tmp_grbs01;
       --分险种进行补差
      FOR rec_aae140 IN cur_aae140 LOOP
          var_aae140 := rec_aae140.aae140;

          FOR rec_ab05a1 IN cur_ab05a1 LOOP
              var_aac001 := rec_ab05a1.aac001;
              num_aac040 := TRUNC(rec_ab05a1.aac040);

              --循环获取人员补差的时间
              FOR rec_tmp_ac42 IN cur_tmp_ac42 LOOP
                  --缴费工资保底封顶
                  IF var_aae140 = xasi2.pkg_comm.aae140_GS THEN
                     var_yac503 := xasi2.pkg_comm.YAC503_SB;
                     var_yac505 := xasi2.pkg_comm.YAC505_GSPT;
                  ELSE
                      BEGIN
                        SELECT yac503,
                               YAC505
                          INTO var_yac503,
                               var_yac505
                          FROM xasi2.ac02
                         WHERE aac001 = var_aac001
                           AND aab001 = prm_aab001
                           AND aae140 = var_aae140;
                       EXCEPTION
                            WHEN OTHERS THEN
                                 GOTO leb_error;
                      END;
                  END IF;
                  IF var_aae140 <> '06' THEN
                     --调用保底封顶过程，获取缴费基数和缴费工资
                     xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase
                                                           (var_aac001   ,     --个人编码
                                                            prm_aab001   ,     --单位编码
                                                            num_aac040   ,     --缴费工资
                                                            var_yac503   ,     --工资类别
                                                            var_aae140   ,     --险种类型
                                                            var_yac505   ,     --缴费人员类别
                                                            var_yab136   ,     --单位管理类型（区别独立缴费人员）
                                                            to_number(prm_aae001||'01')   ,     --费款所属期
                                                            prm_yab139   ,     --参保分中心
                                                            num_yac004   ,     --缴费基数
                                                            prm_AppCode  ,     --错误代码
                                                            prm_ErrorMsg );    --错误内容
                     IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                        RETURN;
                     END IF;

                      --判断个体工商户
                     IF var_aab019 = '60' THEN
                       --获取社平工资
                       num_spgz := xasi2.pkg_comm.fun_GetAvgSalary(var_aae140,'16',num_aae002,PKG_Constant.YAB003_JBFZX);
                       --如果险种为工伤 缴费工资和缴费基数为社平工资
                       IF var_aae140 = xasi2.pkg_comm.AAE140_GS THEN
                          num_yac004 := ROUND(num_spgz/12);
                        ELSE
                          IF num_aac040 > ROUND(num_spgz/12) THEN
                             num_yac004 := ROUND(num_spgz/12);
                          END  IF;
                        END IF;
                     END IF;
                   ELSE
                       num_yac004 := rec_ab05a1.yac004;
                   END IF;
                   --根据TMP_ac42插入补差的临时表中
                   --1月补差
                   IF rec_tmp_ac42.yac401 <> 0 THEN
                     INSERT INTO xasi2.tmp_grbs01
                                                   (aac001,   --个人编码
                                                    aae041,   --开始期号
                                                    aae042,   --终止期号
                                                    aae140,   --险种
                                                    yac503,   --工资类别
                                                    aac040,   --缴费工资
                                                    yaa333,   --帐户基数
                                                    aae100,   --有效标志
                                                    aae013    --备注
                                                    )
                                            VALUES (var_aac001,
                                                    rec_tmp_ac42.aae001||'01',
                                                    rec_tmp_ac42.aae001||'01',
                                                    var_aae140,
                                                    rec_ab05a1.yac503,                                    --工资类别
                                                    num_yac004,                           --变更后缴费工资  如果是工伤险种则取工伤的缴费工资 主要为了区分个体单位
                                                    rec_ab05a1.yaa333,
                                                    NULL,
                                                    NULL);
                   END IF;
                   IF rec_tmp_ac42.yac402 <> 0 THEN   --2月补差
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --个人编码
                                                        aae041,   --开始期号
                                                        aae042,   --终止期号
                                                        aae140,   --险种
                                                        yac503,   --工资类别
                                                        aac040,   --缴费工资
                                                        yaa333,   --帐户基数
                                                        aae100,   --有效标志
                                                        aae013    --备注
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'02',
                                                        rec_tmp_ac42.aae001||'02',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --工资类别
                                                        num_yac004,                           --变更后缴费工资  如果是工伤险种则取工伤的缴费工资 主要为了区分个体单位
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;
                   IF rec_tmp_ac42.yac403 <> 0 THEN   --三月补差
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --个人编码
                                                        aae041,   --开始期号
                                                        aae042,   --终止期号
                                                        aae140,   --险种
                                                        yac503,   --工资类别
                                                        aac040,   --缴费工资
                                                        yaa333,   --帐户基数
                                                        aae100,   --有效标志
                                                        aae013    --备注
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'03',
                                                        rec_tmp_ac42.aae001||'03',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --工资类别
                                                        num_yac004,                           --变更后缴费工资  如果是工伤险种则取工伤的缴费工资 主要为了区分个体单位
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac404 <> 0 THEN   --4月补差
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --个人编码
                                                        aae041,   --开始期号
                                                        aae042,   --终止期号
                                                        aae140,   --险种
                                                        yac503,   --工资类别
                                                        aac040,   --缴费工资
                                                        yaa333,   --帐户基数
                                                        aae100,   --有效标志
                                                        aae013    --备注
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'04',
                                                        rec_tmp_ac42.aae001||'04',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --工资类别
                                                        num_yac004,                           --变更后缴费工资  如果是工伤险种则取工伤的缴费工资 主要为了区分个体单位
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac405 <> 0 THEN   --5月补差
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --个人编码
                                                        aae041,   --开始期号
                                                        aae042,   --终止期号
                                                        aae140,   --险种
                                                        yac503,   --工资类别
                                                        aac040,   --缴费工资
                                                        yaa333,   --帐户基数
                                                        aae100,   --有效标志
                                                        aae013    --备注
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'05',
                                                        rec_tmp_ac42.aae001||'05',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --工资类别
                                                        num_yac004,                           --变更后缴费工资  如果是工伤险种则取工伤的缴费工资 主要为了区分个体单位
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac406 <> 0 THEN    --6月补差
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --个人编码
                                                        aae041,   --开始期号
                                                        aae042,   --终止期号
                                                        aae140,   --险种
                                                        yac503,   --工资类别
                                                        aac040,   --缴费工资
                                                        yaa333,   --帐户基数
                                                        aae100,   --有效标志
                                                        aae013    --备注
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'06',
                                                        rec_tmp_ac42.aae001||'06',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --工资类别
                                                        num_yac004,                           --变更后缴费工资  如果是工伤险种则取工伤的缴费工资 主要为了区分个体单位
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac407 <> 0 THEN   --7月补差
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --个人编码
                                                        aae041,   --开始期号
                                                        aae042,   --终止期号
                                                        aae140,   --险种
                                                        yac503,   --工资类别
                                                        aac040,   --缴费工资
                                                        yaa333,   --帐户基数
                                                        aae100,   --有效标志
                                                        aae013    --备注
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'07',
                                                        rec_tmp_ac42.aae001||'07',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --工资类别
                                                        num_yac004,                           --变更后缴费工资  如果是工伤险种则取工伤的缴费工资 主要为了区分个体单位
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac408 <> 0 THEN    --8月补差
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --个人编码
                                                        aae041,   --开始期号
                                                        aae042,   --终止期号
                                                        aae140,   --险种
                                                        yac503,   --工资类别
                                                        aac040,   --缴费工资
                                                        yaa333,   --帐户基数
                                                        aae100,   --有效标志
                                                        aae013    --备注
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'08',
                                                        rec_tmp_ac42.aae001||'08',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --工资类别
                                                        num_yac004,                           --变更后缴费工资  如果是工伤险种则取工伤的缴费工资 主要为了区分个体单位
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac409 <> 0 THEN   --9月补差
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --个人编码
                                                        aae041,   --开始期号
                                                        aae042,   --终止期号
                                                        aae140,   --险种
                                                        yac503,   --工资类别
                                                        aac040,   --缴费工资
                                                        yaa333,   --帐户基数
                                                        aae100,   --有效标志
                                                        aae013    --备注
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'09',
                                                        rec_tmp_ac42.aae001||'09',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --工资类别
                                                        num_yac004,                           --变更后缴费工资  如果是工伤险种则取工伤的缴费工资 主要为了区分个体单位
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac410 <> 0 THEN    --10月补差
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --个人编码
                                                        aae041,   --开始期号
                                                        aae042,   --终止期号
                                                        aae140,   --险种
                                                        yac503,   --工资类别
                                                        aac040,   --缴费工资
                                                        yaa333,   --帐户基数
                                                        aae100,   --有效标志
                                                        aae013    --备注
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'10',
                                                        rec_tmp_ac42.aae001||'10',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --工资类别
                                                        num_yac004,                           --变更后缴费工资  如果是工伤险种则取工伤的缴费工资 主要为了区分个体单位
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac411 <> 0 THEN   --11月补差
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --个人编码
                                                        aae041,   --开始期号
                                                        aae042,   --终止期号
                                                        aae140,   --险种
                                                        yac503,   --工资类别
                                                        aac040,   --缴费工资
                                                        yaa333,   --帐户基数
                                                        aae100,   --有效标志
                                                        aae013    --备注
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'11',
                                                        rec_tmp_ac42.aae001||'11',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --工资类别
                                                        num_yac004,                           --变更后缴费工资  如果是工伤险种则取工伤的缴费工资 主要为了区分个体单位
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                   END IF;

                   IF rec_tmp_ac42.yac412 <> 0 THEN   --12月补差
                         INSERT INTO xasi2.tmp_grbs01
                                                       (aac001,   --个人编码
                                                        aae041,   --开始期号
                                                        aae042,   --终止期号
                                                        aae140,   --险种
                                                        yac503,   --工资类别
                                                        aac040,   --缴费工资
                                                        yaa333,   --帐户基数
                                                        aae100,   --有效标志
                                                        aae013    --备注
                                                        )
                                                VALUES (var_aac001,
                                                        rec_tmp_ac42.aae001||'12',
                                                        rec_tmp_ac42.aae001||'12',
                                                        var_aae140,
                                                        rec_ab05a1.yac503,                                    --工资类别
                                                        num_yac004,                           --变更后缴费工资  如果是工伤险种则取工伤的缴费工资 主要为了区分个体单位
                                                        rec_ab05a1.yaa333,
                                                        NULL,
                                                        NULL);
                  END IF;
                  <<leb_error>>
                  NULL;
              END LOOP;
          END LOOP;

      END LOOP;
 --如果没有插入临时表就不需要补差
      SELECT COUNT(1) INTO NUM_COUNT FROM XASI2.TMP_GRBS01;
      IF NUM_COUNT > 0 THEN
        --检查tmp_grbs01,并生成tmp_grbs02信息
        XASI2.PKG_P_PAYADJUST.PRC_P_CHECKDATA(PRM_AAB001, --单位编号
                                              '1', --补差方式（0 缴费比例补差， 1 缴费基数补差）
                                              PRM_YAB139, --参保所属分中心
                                              PRM_YAB139, --社保经办机构
                                              PRM_APPCODE, --执行代码
                                              PRM_ERRORMSG); --执行结果
        IF PRM_APPCODE <> XASI2.PKG_COMM.GN_DEF_OK THEN
          RETURN;
        END IF;
        VAR_AAZ002 := PKG_COMMON.FUN_GETSEQUENCE(NULL, 'AAZ002');
        var_aaz083 := xasi2.pkg_comm.fun_GetSequence(NULL,'AAZ083');
        --调用补差过程
        --modify by fenggg at 20181202 begin
        --调用的补差过程  XASI2.PKG_P_PAYADJUST.PRC_P_BATCHSALARYADJUSTPADED  有误
        --替换成调用  xasi2.pkg_p_salaryExamineAdjust.pkg_p_salaryExamineAdjust 补差过程

        /*XASI2.PKG_P_PAYADJUST.PRC_P_BATCHSALARYADJUSTPADED(VAR_AAZ002,
                                                           PRM_AAB001, --单位编号
                                                           NUM_YAE097, --做帐期号
                                                           '1', --补差方式(0 缴费比例补差， 1 缴费基数补差）
                                                           '0', --征集标志(0:否;1:是
                                                           '2', --退款方式(1、退现金；2、进待转）
                                                           '1', --检查是否存在有效补差数据。0、不检查。1、检查。
                                                           '0', --利息标志
                                                           '0', --滞纳金标志
                                                           NULL, --征收方式
                                                           PRM_YAB139, --所属参保分中心
                                                           PRM_YAB139, --社保经办机构
                                                           PRM_AAE011, --经办人
                                                           SYSDATE, --经办时间
                                                           VAR_YAB222, --做帐批次号
                                                           VAR_AAE076, --财务接口流水号
                                                           PRM_APPCODE, --执行代码
                                                           PRM_ERRORMSG); --执行结果*/
                                                           
        /* xasi2.pkg_p_salaryExamineAdjust.pkg_p_salaryExamineAdjust(
                                              VAR_AAZ002,
                                              var_aaz083,
                                              prm_aab001      ,  --单位编号
                                              TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(num_yae097,'yyyymm'),1),'yyyymm'))      ,  --做帐期号
                                              '1'             ,  --补差方式(0 缴费比例补差， 1 缴费基数补差）
                                              '0'             ,  --无效 征集标志(0:否;1:是
                                              '2'             ,  --无效 退款方式(1、退现金；2、进待转）
                                              0               ,  --检查是否存在有效补差数据。0、不检查。1、检查。
                                              '0'             ,  --无效 利息标志
                                              '0'             ,  --无效  滞纳金标志
                                              NULL            ,  --无效  征收方式
                                              prm_yab139      ,  --所属参保分中心
                                              prm_yab139      ,  --社保经办机构
                                              prm_aae011      ,  --经办人
                                              sysdate      ,  --经办时间
                                              VAR_YAB222      ,  --做帐批次号
                                              var_aae076      ,  --财务接口流水号
                                              PRM_APPCODE     ,  --执行代码
                                              PRM_ERRORMSG ); --执行结果 
           IF PRM_APPCODE <> XASI2.PKG_COMM.GN_DEF_OK THEN
            RETURN;
           END IF;*/
                                              
       --modify by fenggg at 20190716 begin
              --增加2019年年审判断，2019年及之后年审调用新的补差过程
              IF prm_aae001 > 2018 THEN
                 xasi2.pkg_p_salaryExamineAdjust.pkg_p_salaryExamineAdjust_ns(
                                                VAR_AAZ002,
                                                var_aaz083,
                                                prm_aab001      ,  --单位编号
                                                TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(num_yae097,'yyyymm'),1),'yyyymm'))      ,  --做帐期号
                                                prm_aae001,        --年审年度
                                                '1'             ,  --补差方式(0 缴费比例补差， 1 缴费基数补差）
                                                '0'             ,  --无效 征集标志(0:否;1:是
                                                '2'             ,  --无效 退款方式(1、退现金；2、进待转）
                                                0               ,  --检查是否存在有效补差数据。0、不检查。1、检查。
                                                '1'             ,  --无效 利息标志
                                                '1'             ,  --无效  滞纳金标志
                                                NULL            ,  --无效  征收方式
                                                prm_yab139      ,  --所属参保分中心
                                                prm_yab139      ,  --社保经办机构
                                                prm_aae011      ,  --经办人
                                                sysdate      ,  --经办时间
                                                VAR_YAB222      ,  --做帐批次号
                                                var_aae076      ,  --财务接口流水号
                                                prm_AppCode     ,  --执行代码
                                                PRM_ERRORMSG      ); --执行结果
                 IF prm_AppCode <> XASI2.pkg_comm.gn_def_OK  THEN
                    RETURN;
                 ELSE
                    PRM_ERRORMSG  := '';
                 END IF;
              ELSE  --modify by fenggg at 20190716 end
                 xasi2.pkg_p_salaryExamineAdjust.pkg_p_salaryExamineAdjust(
                                                VAR_AAZ002,
                                                var_aaz083,
                                                prm_aab001      ,  --单位编号
                                                TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(num_yae097,'yyyymm'),1),'yyyymm'))      ,  --做帐期号
                                                '1'             ,  --补差方式(0 缴费比例补差， 1 缴费基数补差）
                                                '0'             ,  --无效 征集标志(0:否;1:是
                                                '2'             ,  --无效 退款方式(1、退现金；2、进待转）
                                                0               ,  --检查是否存在有效补差数据。0、不检查。1、检查。
                                                '1'             ,  --无效 利息标志
                                                '1'             ,  --无效  滞纳金标志
                                                NULL            ,  --无效  征收方式
                                                prm_yab139      ,  --所属参保分中心
                                                prm_yab139      ,  --社保经办机构
                                                prm_aae011      ,  --经办人
                                                sysdate      ,  --经办时间
                                                VAR_YAB222      ,  --做帐批次号
                                                var_aae076      ,  --财务接口流水号
                                                prm_AppCode     ,  --执行代码
                                                PRM_ERRORMSG      ); --执行结果
                 IF prm_AppCode <> XASI2.pkg_comm.gn_def_OK  THEN
                    RETURN;
                 ELSE
                    PRM_ERRORMSG  := '';
                 END IF;
             END IF;                                              
                                              

           --modify by fenggg at 20181202 end
       
      END IF;

      --更新费用来源
      BEGIN

      SELECT decode(yae010_110,'3','1','1'),
               decode(yae010_120,'3','1','1'),
               decode(yae010_210,'3','1','1'),
               decode(yae010_310,'3','1','1'),
               decode(yae010_410,'3','1','1'),
               decode(yae010_510,'3','1','1')
          INTO var_yae010_110,
               var_yae010_120,
               var_yae010_210,
               var_yae010_310,
               var_yae010_410,
               var_yae010_510
          FROM wsjb.irab03
         WHERE aab001 = prm_aab001;






      /**  SELECT yae010_110,
               yae010_120,
               yae010_210,
               yae010_310,
               yae010_410,
               yae010_510
          INTO var_yae010_110,
               var_yae010_120,
               var_yae010_210,
               var_yae010_310,
               var_yae010_410,
               var_yae010_510
          FROM wsjb.irab03
         WHERE aab001 = prm_aab001;
         */
       EXCEPTION
            WHEN OTHERS THEN
                 var_yae010_110 := '1';
                 var_yae010_210 := xasi2.pkg_comm.YAE010_ZC; -- YAE010_DSZS 改 YAE010_ZC
                 var_yae010_310 := xasi2.pkg_comm.YAE010_ZC;
                 var_yae010_410 := xasi2.pkg_comm.YAE010_ZC;
                 var_yae010_510 := xasi2.pkg_comm.YAE010_ZC;
      END;
      FOR rec_ab08 IN cur_ab08 LOOP
          --失业
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_SYE THEN
             var_yae010 := var_yae010_210;
          END IF;
          --医疗
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_JBYL THEN
             var_yae010 := var_yae010_310;
          END IF;
          --工伤
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_GS THEN
             var_yae010 := var_yae010_410;
          END IF;
          --生育
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_SYU THEN
             var_yae010 := var_yae010_510;
          END IF;
          --机关养老
          IF rec_ab08.aae140 = '06' THEN
             var_yae010 := var_yae010_120;
          END IF;
          --更新费用来源
          UPDATE xasi2.AB08
             SET yae010 = var_yae010
           WHERE yae518 = rec_ab08.yae518
             AND yab222 = var_yab222
             AND aae140 = rec_ab08.aae140;

          --更新人员明细
          UPDATE xasi2.AC08A1
             SET yae010 = var_yae010
           WHERE yae518 = rec_ab08.yae518
             AND aae140 = rec_ab08.aae140;
      END LOOP;
      FOR rec_ab08a8 IN cur_ab08a8 LOOP
          --失业
          IF rec_ab08a8.aae140 = xasi2.pkg_comm.AAE140_SYE THEN
             var_yae010 := var_yae010_210;
          END IF;
          --医疗
          IF rec_ab08a8.aae140 = xasi2.pkg_comm.AAE140_JBYL THEN
             var_yae010 := var_yae010_310;
          END IF;
          --工伤
          IF rec_ab08a8.aae140 = xasi2.pkg_comm.AAE140_GS THEN
             var_yae010 := var_yae010_410;
          END IF;
          --生育
          IF rec_ab08a8.aae140 = xasi2.pkg_comm.AAE140_SYU THEN
             var_yae010 := var_yae010_510;
          END IF;

          --更新费用来源
          UPDATE xasi2.AB08A8
             SET yae010 = var_yae010
           WHERE yae518 = rec_ab08a8.yae518
             AND yab222 = var_yab222
             AND aae140 = rec_ab08a8.aae140;

          --更新人员明细
          UPDATE xasi2.ac08
             SET yae010 = var_yae010
           WHERE yae518 = rec_ab08a8.yae518
             AND aae140 = rec_ab08a8.aae140;
      END LOOP;
      --地税的发征集
      var_yae010 := xasi2.pkg_comm.YAE010_ZC;
      --YAE517 = H12
      FOR rec_aae140 IN cur_aae140 LOOP
          --插入临时表，
          DELETE FROM xasi2.Tmp_yae518;
          INSERT INTO xasi2.tmp_yae518
                                         (yae518,   -- 核定流水号
                                          aae140,   -- 险种类型
                                          aab001,
                                          yab538,
                                          yae010,
                                          aae041,
                                          yab139)
                                   SELECT yae518,
                                          aae140,
                                          aab001,
                                          yab538, --缴费人员状态
                                          YAE010, --费用来源
                                          aae041,
                                          prm_yab139
                                     FROM xasi2.AB08
                                    WHERE aab001 = prm_aab001
                                      AND (aae076 IS NULL OR aae076 = '0')
                                      AND aae140 = rec_aae140.aae140
                                      AND yae517 = xasi2.pkg_Comm.YAE517_H12      --核定类型
                                      AND aae003 = num_yae097
                                      AND yab222 = var_yab222
                                      AND yae010 =xasi2.pkg_Comm.YAE010_ZC;
        SELECT COUNT(1)
          INTO num_count
          FROM xasi2.tmp_yae518;
        IF num_count > 0 THEN
           var_aae076 := xasi2.pkg_comm.fun_GetSequence(NULL,'aae076');
           --调用征集过程。生成单据信息和财务接口数据
           xasi2.pkg_p_fundCollection.prc_crtFinaPlan  (
                                                          'P23'    ,      --收付种类
                                                          xasi2.pkg_comm.YAD052_GTSK,      --收付结算方式
                                                          prm_aae011    ,      --经办人员
                                                          prm_yab139    ,      --社保经办机构
                                                          var_aae076    ,      --计划流水号
                                                          prm_AppCode   ,      --执行代码
                                                          prm_ErrorMsg    );     --执行结果
           IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
              RETURN;
           END IF;
        END IF;
     END LOOP;
     --YAE517 = H17
      FOR rec_aae140 IN cur_aae140 LOOP
          --插入临时表，
          DELETE FROM xasi2.Tmp_yae518;
          INSERT INTO xasi2.tmp_yae518
                                         (yae518,   -- 核定流水号
                                          aae140,   -- 险种类型
                                          aab001,
                                          yab538,
                                          yae010,
                                          aae041,
                                          yab139)
                                   SELECT yae518,
                                          aae140,
                                          aab001,
                                          yab538, --缴费人员状态
                                          YAE010, --费用来源
                                          aae041,
                                          prm_yab139
                                     FROM xasi2.AB08
                                    WHERE aab001 = prm_aab001
                                      AND (aae076 IS NULL OR aae076 = '0')
                                      AND aae140 = rec_aae140.aae140
                                      AND yae517 = xasi2.pkg_Comm.YAE517_H17      --核定类型
                                      AND aae003 = num_yae097
                                      AND yab222 = var_yab222
                                      AND yae010 =xasi2.pkg_Comm.YAE010_ZC;
        SELECT COUNT(1)
          INTO num_count
          FROM xasi2.tmp_yae518;
        IF num_count > 0 THEN
           var_aae076 := xasi2.pkg_comm.fun_GetSequence(NULL,'aae076');
           --调用征集过程。生成单据信息和财务接口数据
           xasi2.pkg_p_fundCollection.prc_crtFinaPlan  (
                                                          'P19'    ,      --收付种类
                                                          xasi2.pkg_comm.YAD052_TZ,      --收付结算方式
                                                          prm_aae011    ,      --经办人员
                                                          prm_yab139    ,      --社保经办机构
                                                          var_aae076    ,      --计划流水号
                                                          prm_AppCode   ,      --执行代码
                                                          prm_ErrorMsg    );     --执行结果
           IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
              RETURN;
           END IF;
        END IF;
     END LOOP;
     --自筹的发征集
     --YAE517 = H12
      var_aae076 := xasi2.pkg_comm.fun_GetSequence(NULL,'aae076');
      --插入临时表，
      DELETE FROM xasi2.Tmp_yae518;
      INSERT INTO xasi2.tmp_yae518
                                     (yae518,   -- 核定流水号
                                      aae140,   -- 险种类型
                                      aab001,
                                      yab538,
                                      yae010,
                                      aae041,
                                      yab139)
                               SELECT yae518,
                                      aae140,
                                      aab001,
                                      yab538, --缴费人员状态
                                      YAE010, --费用来源
                                      aae041,
                                      prm_yab139
                                 FROM xasi2.AB08
                                WHERE aab001 = prm_aab001
                                  AND (aae076 IS NULL OR aae076 = '0')
                                  AND yae517 = xasi2.pkg_Comm.YAE517_H12      --核定类型
                                  AND aae003 = num_yae097
                                  AND yab222 = var_yab222
                                  AND yae010 = xasi2.pkg_Comm.YAE010_ZC;
    SELECT COUNT(1)
      INTO num_count
      FROM xasi2.tmp_yae518;
    IF num_count > 0 THEN
       --调用征集过程。生成单据信息和财务接口数据
       xasi2.pkg_p_fundCollection.prc_crtFinaPlan  (
                                                        'P01'    ,      --收付种类
                                                        xasi2.pkg_comm.YAD052_GTSK,      --收付结算方式
                                                        prm_aae011    ,      --经办人员
                                                        prm_yab139    ,      --社保经办机构
                                                        var_aae076    ,      --计划流水号
                                                        prm_AppCode   ,      --执行代码
                                                        prm_ErrorMsg    );     --执行结果
       IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
          RETURN;
       END IF;
    END IF;
    --YAE517 = H17
      var_aae076 := xasi2.pkg_comm.fun_GetSequence(NULL,'aae076');
      --插入临时表，
      DELETE FROM xasi2.Tmp_yae518;
      INSERT INTO xasi2.tmp_yae518
                                     (yae518,   -- 核定流水号
                                      aae140,   -- 险种类型
                                      aab001,
                                      yab538,
                                      yae010,
                                      aae041,
                                      yab139)
                               SELECT yae518,
                                      aae140,
                                      aab001,
                                      yab538, --缴费人员状态
                                      YAE010, --费用来源
                                      aae041,
                                      prm_yab139
                                 FROM xasi2.AB08
                                WHERE aab001 = prm_aab001
                                  AND (aae076 IS NULL OR aae076 = '0')
                                  AND yae517 = xasi2.pkg_Comm.YAE517_H17      --核定类型
                                  AND aae003 = num_yae097
                                  AND yab222 = var_yab222
                                  AND yae010 = xasi2.pkg_Comm.YAE010_ZC;
    SELECT COUNT(1)
      INTO num_count
      FROM xasi2.tmp_yae518;
    IF num_count > 0 THEN
       --调用征集过程。生成单据信息和财务接口数据
       xasi2.pkg_p_fundCollection.prc_crtFinaPlan  (
                                                        'P19'    ,      --收付种类
                                                        xasi2.pkg_comm.YAD052_TZ,      --收付结算方式
                                                        prm_aae011    ,      --经办人员
                                                        prm_yab139    ,      --社保经办机构
                                                        var_aae076    ,      --计划流水号
                                                        prm_AppCode   ,      --执行代码
                                                        prm_ErrorMsg    );     --执行结果
       IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
          RETURN;
       END IF;
    END IF;
      --调用养老补差
      prc_YearSalaryBCByYL(prm_aab001  ,
                           prm_aae001  ,
                           num_yae097  ,
                           var_yab222  ,
                           var_aae076  ,
                           '1',
                           prm_aae011  ,
                           prm_yab139  ,
                           prm_AppCode ,
                           prm_ErrorMsg);

     IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
         RETURN;
     END IF;


     --更新养老费用来源
     UPDATE wsjb.irab08
        SET yae010 = var_yae010_110
      WHERE aab001 = prm_aab001
        AND yae517 IN ('H17','H12')
        AND aae140 = '01'
        AND aae003 = num_yae097;
     --更新养老个人费用来源
     UPDATE wsjb.irac08a1
        SET yae010 = var_yae010_110
      WHERE aab001 = prm_aab001
        AND aae003 = num_yae097
        AND aae140 = '01'
        AND aae143 = '05';

       IF prm_yab019 = '1' THEN  --企业基数申报
       --插入单位年审标志
       INSERT INTO xasi2.ab05 (aab001,
                                  aae001,
                                  yab007,
                                  aae011)
                          VALUES (prm_aab001,
                                  prm_aae001,
                                  xasi2.pkg_comm.YAB007_YNS,
                                  prm_aae011);
       --更新年审截止时间
        UPDATE xasi2.ab02
           SET aae042 = prm_aae001||'12'
         WHERE aab001 = prm_aab001;
       END IF ;

     /**  IF prm_yab019 = '2' THEN --机关养老险种
         IF prm_yab139 <> PKG_Constant.YAB003_JBFZX THEN --不是高新区的单位insert ab05
             --插入单位年审标志
           INSERT INTO xasi2.ab05 (aab001,
                                      aae001,
                                      yab007,
                                      aae011)
                              VALUES (prm_aab001,
                                      prm_aae001,
                                      xasi2.pkg_comm.YAB007_YNS,
                                      prm_aae011);
         END IF ;
           --更新年审截止时间
        UPDATE xasi2.ab02
           SET aae042 = prm_aae001||'12'
         WHERE aab001 = prm_aab001
           AND aae140 = '06';
       END IF ;
     */


     SELECT MAX(yae097)
       INTO num_yae097
       FROM (SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(yae097),'yyyymm'),1),'yyyymm')) AS yae097   --获取做帐期号
               FROM xasi2.ab02
              WHERE aab001 = prm_aab001
              UNION
             SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(aae003),'yyyymm'),1),'yyyymm')) AS yae097
               FROM wsjb.irab08
              WHERE aab001 = prm_aab001
                AND yae517 = 'H01'  );
     --更新审核表做帐期号
     UPDATE wsjb.irad51
        SET aae003 = num_yae097
      WHERE aab001 = prm_aab001
        AND aae001 = prm_aae001
        AND iaa011 = prm_iaa011;
   EXCEPTION
        WHEN OTHERS THEN
        /*关闭打开的游标*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
             RETURN;
END prc_YearSalaryBC;
/*****************************************************************************
   ** 过程名称 : prc_YearSalaryBCByYL
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：年申报审核--养老补差
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
PROCEDURE prc_YearSalaryBCByYL(prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                               prm_aae001       IN     NUMBER            ,--年审年度
                               prm_aae002       IN     NUMBER            ,
                               prm_yab222       IN     xasi2.ab08.yab222%TYPE,
                               prm_aae076       IN     xasi2.ab08.aae076%TYPE,
                               prm_type         IN     VARCHAR2,  --1为社平公布前 2为社平公布后
                               prm_aae011       IN     irad31.aae011%TYPE,--经办人
                               prm_yab139       IN     VARCHAR2          ,--参保所属分中心
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          )
   IS
       num_count     NUMBER;
      v_msg        VARCHAR2(300);
      var_aaz002   irad31.aaz002%TYPE;
      num_aae041_year NUMBER(6);  --补差开始时间
      num_yae097   xasi2.ab02.yae097%TYPE; --单位最大做帐期号
      var_aae140   xasi2.ab02.aae140%TYPE; --险种
      var_aac001   xasi2.ac01.aac001%TYPE; --个人编号
      num_aae002   xasi2.ac08a1.aae002%TYPE;
      num_aac040   xasi2.ac02.aac040%TYPE;
      num_spgz     xasi2.ac02.aac040%TYPE;
      num_yac004   xasi2.ac02.yac004%TYPE;
      var_yab136   xasi2.ab01.yab136%TYPE;
      var_yab275   xasi2.ab01.yab275%TYPE;
      var_aae119   xasi2.ab01.aae119%TYPE;
      var_aab019   xasi2.ab01.aab019%TYPE;
      var_yac503   xasi2.ac02.yac503%TYPE;
      var_yac505   xasi2.ac02.yac505%TYPE;
      num_yac401   tmp_ac42.yac401%type;           --1月补差金额,NUMBER
      num_yac402   tmp_ac42.yac401%type;           --2月补差金额,NUMBER
      num_yac403   tmp_ac42.yac401%type;           --3月补差金额,NUMBER
      num_yac404   tmp_ac42.yac401%type;           --4月补差金额,NUMBER
      num_yac405   tmp_ac42.yac401%type;           --5月补差金额,NUMBER
      num_yac406   tmp_ac42.yac401%type;           --6月补差金额,NUMBER
      num_yac407   tmp_ac42.yac401%type;           --7月补差金额,NUMBER
      num_yac408   tmp_ac42.yac401%type;           --8月补差金额,NUMBER
      num_yac409   tmp_ac42.yac401%type;           --9月补差金额,NUMBER
      num_yac410   tmp_ac42.yac401%type;           --10月补差金额,NUMBER
      num_yac411   tmp_ac42.yac401%type;           --11月补差金额,NUMBER
      num_yac412   tmp_ac42.yac401%type;           --12月补差金额,NUMBER
      var_procNo   VARCHAR2(5);                    --过程号
      var_aae013   xasi2.ab08a8.aae013%TYPE;
      var_aae100   VARCHAR2(9);
      var_yae099   xasi2.ac04a3.yae099%TYPE;
      var_yae518   xasi2.ab08.yae518%TYPE;
      --获取单位提交的申报人员
      CURSOR cur_tmp_ac42 IS
        select AAC001,             --人员编号,VARCHAR2
               AAB001,             --单位编号,VARCHAR2
               AAE140,             --险种,VARCHAR2
               YAC401,             --1月补差金额,NUMBER
               YAC402,             --2月补差金额,NUMBER
               YAC403,             --3月补差金额,NUMBER
               YAC404,             --4月补差金额,NUMBER
               YAC405,             --5月补差金额,NUMBER
               YAC406,             --6月补差金额,NUMBER
               YAC407,             --7月补差金额,NUMBER
               YAC408,             --8月补差金额,NUMBER
               YAC409,             --9月补差金额,NUMBER
               YAC410,             --10月补差金额,NUMBER
               YAC411,             --11月补差金额,NUMBER
               YAC412,             --12月补差金额,NUMBER
               AAE013,             --备注,VARCHAR2
               aae001
          from wsjb.tmp_ac42   --人员险种补差信息表
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND aae140 = PKG_Constant.AAE140_YL
           AND 1 = DECODE(prm_type,'1',1,0)
        UNION
        select AAC001,             --人员编号,VARCHAR2
               AAB001,             --单位编号,VARCHAR2
               AAE140,             --险种,VARCHAR2
               YAC401,             --1月补差金额,NUMBER
               YAC402,             --2月补差金额,NUMBER
               YAC403,             --3月补差金额,NUMBER
               YAC404,             --4月补差金额,NUMBER
               YAC405,             --5月补差金额,NUMBER
               YAC406,             --6月补差金额,NUMBER
               YAC407,             --7月补差金额,NUMBER
               YAC408,             --8月补差金额,NUMBER
               YAC409,             --9月补差金额,NUMBER
               YAC410,             --10月补差金额,NUMBER
               YAC411,             --11月补差金额,NUMBER
               YAC412,             --12月补差金额,NUMBER
               AAE013,             --备注,VARCHAR2
               aae001
          from wsjb.tmp_ac43   --人员险种二次补差信息表
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND aae140 = PKG_Constant.AAE140_YL
           AND 1 = DECODE(prm_type,'2',1,0);


   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      var_procNo   :='Y01';
      var_yae518   := xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAE518');
      num_aae002   := prm_aae002;
      --参数校验
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '单位编号不能为空' ;
         RETURN;
      END IF;

      IF prm_aae001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '年审年度不能为空' ;
         RETURN;
      END IF;
      IF num_aae002 IS NULL THEN
         SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(aae003),'yyyymm'),1),'yyyymm'))
           INTO num_aae002
           FROM wsjb.irab08
          WHERE aab001 = prm_aab001
            AND yae517 = xasi2.pkg_comm.yae517_H01;
      END IF;

      --获取单位当前的管理类型
      BEGIN
         SELECT yab136,
                yab275,
                aae119,
                aab019
           INTO var_yab136,
                var_yab275,
                var_aae119,
                var_aab019
           FROM xasi2.ab01
          WHERE aab001 = prm_aab001;
      EXCEPTION
         WHEN OTHERS THEN
              prm_AppCode := ''||var_procNo||'02';
              prm_ErrorMsg  := '单位编码'||prm_aab001||'社保经办机构'||prm_yab139||'没有获取到单位基本信息';
              RETURN;
      END;

      --循环获取人员补差的时间
      FOR rec_tmp_ac42 IN cur_tmp_ac42 LOOP
           --根据TMP_ac42插入补差的临时表中
           var_aac001 := rec_tmp_ac42.aac001;
           --1月补差
           IF rec_tmp_ac42.yac401 <> 0 THEN
               prc_insertIRAC08A1(prm_aab001  ,
                                  var_aac001  ,
                                  prm_aae001||'01'  ,
                                  num_aae002,
                                  rec_tmp_ac42.yac401,
                                  var_yae518  ,
                                  prm_aae076,
                                  prm_aae011  ,
                                  prm_yab139  ,
                                  prm_AppCode ,
                                  prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac402 <> 0 THEN   --2月补差
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'02'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac402,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac403 <> 0 THEN   --三月补差
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'03'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac403,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac404 <> 0 THEN   --4月补差
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'04'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac404,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac405 <> 0 THEN   --5月补差
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'05'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac405,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac406 <> 0 THEN    --6月补差
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'06'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac406,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac407 <> 0 THEN   --7月补差
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'07'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac407,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac408 <> 0 THEN    --8月补差
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'08'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac408,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac409 <> 0 THEN   --9月补差
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'09'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac409,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac410 <> 0 THEN    --10月补差
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'10'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac410,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac411 <> 0 THEN   --11月补差
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'11'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac411,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac412 <> 0 THEN   --12月补差
                 prc_insertIRAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'12'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac412,
                                    var_yae518  ,
                                    prm_aae076,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
          END IF;
      END LOOP;


      --补收
      INSERT INTO wsjb.irab08 ( YAE518,
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
                   SELECT yae518,
                          aab001,
                          aae140,
                          num_aae002,
                          MIN(aae002),
                          MAX(aae002),
                          '1',
                          yae010,
                          '0',
                          '1',
                          'H12',
                          prm_yab222,
                          count(DISTINCT aac001) yae231,
                          1.0000,
                          sum(aac040) aab120,
                          sum(aac040) aab121,
                          sum(yab157) aab150,
                          SUM(yab158),
                          SUM(AAB212),
                          SUM(AAB213),
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
                          SUM(yab157+yab158+aab212+aab213),
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
                          prm_aae076,
                          null,
                          null,
                          '2',
                          '1',
                          prm_yab139,
                          prm_aae011,
                          sysdate,
                          prm_yab139,
                          '养老补差'
                     FROM wsjb.irac08a1
                    WHERE yae518 = var_yae518
                      AND aac040 >0
                    GROUP BY aae140,yae518,aab001,yae010;
      --退收
      INSERT INTO wsjb.irab08 ( YAE518,
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
                   SELECT yae518,
                          aab001,
                          aae140,
                          num_aae002,
                          MIN(aae002),
                          MAX(aae002),
                          '1',
                          yae010,
                          '0',
                          '1',
                          'H17',
                          prm_yab222,
                          count(DISTINCT aac001) yae231,
                          1.0000,
                          sum(aac040) aab120,
                          sum(aac040) aab121,
                          sum(yab157) aab150,
                          SUM(yab158),
                          SUM(AAB212),
                          SUM(AAB213),
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
                          SUM(yab157+yab158+aab212+aab213),
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
                          prm_aae076,
                          null,
                          null,
                          '2',
                          '1',
                          prm_yab139,
                          prm_aae011,
                          sysdate,
                          prm_yab139,
                          '养老补差'
                     FROM wsjb.irac08a1
                    WHERE yae518 = var_yae518
                      AND aac040 < 0
                    GROUP BY aae140,yae518,aab001,yae010;

   EXCEPTION
        WHEN OTHERS THEN
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
             RETURN;
END prc_YearSalaryBCByYL;
/*****************************************************************************
   ** 过程名称 : prc_YearSalaryBC
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：年申报审核--补差
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
PROCEDURE prc_insertIRAC08A1(prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                             prm_aac001       IN     xasi2.ac01.aac001%TYPE,
                             prm_aae002       IN     NUMBER            ,--年审年度
                             prm_aae003       IN     NUMBER,
                             prm_aac040       IN     xasi2.ac02.aac040%TYPE,
                             prm_yae518       IN     xasi2.ac08a1.yae518%TYPE,
                             prm_aae076       IN     xasi2.ab08.aae076%TYPE,
                             prm_aae011       IN     irad31.aae011%TYPE,--经办人
                             prm_yab139       IN     VARCHAR2          ,--参保所属分中心
                             prm_AppCode      OUT    VARCHAR2          ,
                             prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      num_count     NUMBER;
      v_msg        VARCHAR2(300);
      var_yae010   xasi2.ac08a1.yae010%TYPE;
      var_aab019   irab01.aab019%TYPE;

   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      SELECT NVL(yae010_110,1)
        INTO var_yae010
        FROM wsjb.irab03
       WHERE aab001 = prm_aab001;

      SELECT aab019
        INTO var_aab019
        FROM xasi2.ab01
       WHERE aab001 = prm_aab001;

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
                   VALUES (xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAE202'),
                           prm_aac001,
                           prm_aab001,
                           '01',
                           prm_aae003,
                           prm_aae002,
                           '05',
                           var_yae010,
                           '010',
                           '0',
                           prm_aac040,
                           prm_aac040,
                           prm_aac040,
                           round(prm_aac040*0.08,2),
                           0,
                           0,
                           CASE WHEN var_aab019 = '60' THEN round(prm_aac040*0.12,2) ELSE round(prm_aac040*0.2,2) END,
                           0,
                           prm_yae518,
                           prm_aae076,
                           prm_aae011,
                           sysdate,
                           prm_yab139,
                           prm_yab139,
                           '2');
       IF SQL%ROWCOUNT < 1 THEN
          prm_AppCode  :=  gn_def_ERR;
          prm_ErrorMsg := '单位编号:'||prm_aab001||',期号'||prm_aae003||'生成补差缴费信息有误，请检查' ;
          RETURN;
       END IF;

   EXCEPTION
        WHEN OTHERS THEN
        /*关闭打开的游标*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
             RETURN;
END prc_insertIRAC08A1;
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
                                   prm_ErrorMsg     OUT    VARCHAR2    )
    IS
      n_count NUMBER(6);
      v_iaz004 irad02.iaz004%TYPE;
      v_iaz009 irad22.iaz009%TYPE;
      v_aaz002 irad51.aaz002%TYPE;

    BEGIN
      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;

      /*必要的数据校验*/
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '单位编号不能为空!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '操作人员编号不能为空!';
         RETURN;
      END IF;

      IF prm_iaa018 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '审核标志不能为空!';
         RETURN;
      END IF;

      IF prm_aae001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '审核年度不能为空!';
         RETURN;
      END IF;

      IF prm_iaa011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '业务类型不能为空!';
         RETURN;
      END IF;

        SELECT count(1)
          INTO n_count
          FROM wsjb.irad51
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND iaa011 = prm_iaa011
           AND iaa002 = '1'
           AND iaa006 = '0';
        IF n_count = 0 THEN
           prm_AppCode := gn_def_ERR;
           prm_ErrorMsg := '未找到待审信息!';
           RETURN;
        END IF;

      SELECT iaz004
        INTO v_iaz004
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND iaa011 = prm_iaa011
         AND iaa002 = '1'
         AND iaa006 = '0';


        v_iaz009 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAZ009');
           IF v_iaz009 IS NULL OR v_iaz009 = '' THEN
              ROLLBACK;
              prm_ErrorMsg := '没有获取到序列号IAZ009!';
              RETURN;
           END IF;
         v_aaz002 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'AAZ002');
           IF v_aaz002 IS NULL OR v_aaz002 = '' THEN
              ROLLBACK;
              prm_ErrorMsg := '没有获取到序列号v_aaz002!';
              RETURN;
           END IF;



      --审核通过
      IF prm_iaa018 = '2' THEN
        INSERT INTO wsjb.irad52  (
                            iaz009,
                            aaz002,
                            iaz004,
                            aab001,
                            iaa011,
                            aee011,
                            aae035,
                            yab003,
                            aae001,
                            iaa018)values(
                            v_iaz009,
                            v_aaz002,
                            v_iaz004,
                            prm_aab001,
                            prm_iaa011,
                            prm_yae092,
                            sysdate,
                            PKG_Constant.YAB003_JBFZX,
                            prm_aae001,
                            prm_iaa018
                            );
        prc_YearSalary(prm_aab001,--单位编号  必填
                       prm_aae001,--年审年度
                       prm_yae092,--经办人
                       PKG_Constant.YAB003_JBFZX,--参保所属分中心
                       prm_yab019,
                       prm_AppCode ,
                       prm_ErrorMsg);
       IF prm_AppCode <> gn_def_OK THEN
           ROLLBACK;
          prm_AppCode  :=  gn_def_ERR;
          prm_ErrorMsg := '调用核定过程prc_YearSalary出错:'||prm_ErrorMsg;
          RETURN;
        END IF;
        UPDATE wsjb.irad51
            SET iaa002 = '2'
          WHERE aab001 = prm_aab001
          AND aae001 = prm_aae001
          AND iaa011 = prm_iaa011
          AND iaa002 = '1'
          AND iaa006 = '0';

      ELSIF prm_iaa018 = '3' THEN    --审核不通过
         UPDATE xasi2.ac01k8
            SET iaa002 = '3',
                aae036 = sysdate,
                aae011 = prm_yae092
          WHERE AAB001 = prm_aab001
            AND aae001 = prm_aae001
            AND yab019 = prm_yab019
            AND iaa002 = '1';

        UPDATE wsjb.irad51
           SET iaa002 = '3'
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND iaa011 = prm_iaa011
           AND iaa002 = '1'
           AND iaa006 = '0';
      ELSE
         prm_AppCode := gn_def_ERR;
         prm_ErrorMsg := '审核标志不正确!';
         RETURN;
      END IF;

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
                  PKG_Constant.AAA121_YIR,
                  prm_yae092,
                  PKG_Constant.YAB003_JBFZX,
                  prm_yae092,
                  '1',
                  sysdate,
                  sysdate,
                  sysdate
                 );
    EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
         RETURN;
   END prc_YearInternetAudit;
    /*****************************************************************************
   ** 过程名称 : prc_YearInternetAuditRB
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：审核端年审审核(回退)
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
                 prm_iaa018       IN     wsjb.irad52 .iaa018%TYPE,--审核标志
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
                                    prm_yab019       IN     VARCHAR2          ,--类型标志
                                   prm_AppCode      OUT    VARCHAR2          ,
                                   prm_ErrorMsg     OUT    VARCHAR2    )
    IS
    n_count NUMBER;
    v_aac001 irac01.aac001%TYPE;
    v_aab001 irac01.aab001%TYPE;
    v_iaz004 irad02.iaz004%TYPE;
    v_iaa018 irad22.iaa018%TYPE ; --审核标志
    v_iaa002 irad51.iaa002%TYPE ; --审核状态

    CURSOR cur_ab05a1 IS --企业基数申报
     SELECT iaz004,
            aac001,
            aab001,
            iaa002,
            yae099,
            aae001
       FROM xasi2.ac01k8
      WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND yab019 = prm_yab019;
    BEGIN
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;

    --查询申报流水号
      SELECT DISTINCT iaz004
        INTO v_iaz004
       FROM xasi2.ac01k8
      WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND yab019 = prm_yab019
         AND iaa002 <> '0';

     --是否有审核记录
      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.irad52
       WHERE iaz004 = v_iaz004;
      IF n_count = 0 THEN
        prm_AppCode  := gn_def_ERR;
        prm_ErrorMsg := '没有审核记录，不能回退审核！';
        RETURN;
      END IF;

      --是否已经补差
      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE iaz004 = v_iaz004
         AND iaa006 = '1';
      IF n_count > 0 THEN
        prm_AppCode  := gn_def_ERR;
        prm_ErrorMsg := '该单位已有补差记录，不能回退审核！';
        RETURN;
      END IF;

      SELECT iaa018
        INTO v_iaa018
        FROM wsjb.irad52
       WHERE iaz004 = v_iaz004;

     IF v_iaa018 = '2' THEN
       --调用审核通过的回退
         prc_YearSalaryRB(prm_aab001,--单位编号  必填
                         prm_aae001,--年审年度
                         prm_iaa011,--业务类型
                         prm_yab019,--类型标志
                         prm_AppCode ,
                         prm_ErrorMsg);
       IF prm_AppCode <> gn_def_OK THEN
           ROLLBACK;
          prm_AppCode  :=  gn_def_ERR;
          prm_ErrorMsg := '调用核定过程prc_YearSalaryRB出错:'||prm_ErrorMsg;
          RETURN;
        END IF;
        --更新申报表
        UPDATE wsjb.irad51
           SET iaa002 = '1'
          WHERE aab001 = prm_aab001
          AND aae001 = prm_aae001
          AND iaa011 = prm_iaa011
          AND iaa002 = '2'
          AND iaa006 = '0';
       --删除审核表
       DELETE wsjb.irad52
        WHERE iaz004 = v_iaz004;

     ELSIF v_iaa018 = '3' THEN
       --更新人员审核状态
        UPDATE xasi2.ac01k8
           SET iaa002 = '1',
               aae036 = NULL,
               aae011 = NULL
         WHERE AAB001 = prm_aab001
           AND aae001 = prm_aae001
           AND yab019 = prm_yab019
           AND iaa002 = '2';
        --更新申报表
        UPDATE wsjb.irad51
           SET iaa002 = '1'
          WHERE aab001 = prm_aab001
          AND aae001 = prm_aae001
          AND iaa011 = prm_iaa011
          AND iaa002 = '3'
          AND iaa006 = '0';
       --删除审核表
       DELETE wsjb.irad52
        WHERE iaz004 = v_iaz004;
     ELSE
        prm_AppCode := gn_def_ERR;
       prm_ErrorMsg := '提取审核标志不正确!';
       RETURN;
     END IF;

     EXCEPTION

      WHEN OTHERS THEN
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
         RETURN;
    END prc_YearInternetAuditRB;

    /*****************************************************************************
   ** 过程名称 : prc_YearInternetBC
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：审核端补差操作
   ******************************************************************************
   ** 参数描述 ：参数标识        输入/输出         类型                 名称
   ******************************************************************************
   **           prm_aab001       IN     iraa01a1.aab001%TYPE,--申报单位
                prm_aae001       IN     xasi2_zs.ac01k8.aae001%TYPE,--审核年度
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
                                   prm_iaa011       IN     irad51.iaa011%TYPE ,--业务类型
                                   prm_yab019       IN     VARCHAR2          ,--类型标志
                                   prm_AppCode      OUT    VARCHAR2          ,
                                   prm_ErrorMsg     OUT    VARCHAR2    )
   IS
        n_count NUMBER(6);
       v_iaz004 irad02.iaz004%TYPE;
       v_aab004 xasi2.ab01.aab004%TYPE;
       v_msg   VARCHAR2(3000);
   BEGIN
      /*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      n_count      :=0;

      /*必要的数据校验*/
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '单位编号不能为空!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '操作人员编号不能为空!';
         RETURN;
      END IF;

      IF prm_aae001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '审核年度不能为空!';
         RETURN;
      END IF;
      --是否有具备补差的信息
      SELECT count(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND iaa011 = prm_iaa011
         AND iaa002 = '2'
         AND iaa006 = '0';
      IF n_count = 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := '未找到可以补差的单位年申报信息!';
         RETURN;
      END IF;
      --获取申报流水号
      SELECT iaz004
        INTO v_iaz004
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND iaa011 = prm_iaa011;
      --是否已经做过补差
      SELECT count(1)
        INTO n_count
        FROM wsjb.irad51
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND iaa011 = prm_iaa011
         AND iaa002 = '2'
         AND iaa006 = '1';
      IF n_count > 0 THEN
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := '单位已经做过补差操作！';
        RETURN;
      END IF;

      prc_YearSalaryBC(prm_aab001,--单位编号  必填
                       prm_aae001,--年审年度
                       prm_yae092,--经办人
                       PKG_Constant.YAB003_JBFZX,--参保所属分中心
                       prm_iaa011,--业务类型
                       prm_yab019,--类型标志
                       prm_AppCode,
                       prm_ErrorMsg);
      IF prm_AppCode <> gn_def_OK THEN
         ROLLBACK;
        prm_AppCode  :=  gn_def_ERR;
        prm_ErrorMsg := '调用核定过程prc_YearSalaryBC出错:'||prm_ErrorMsg;
        RETURN;
       END IF;
      UPDATE wsjb.irad51
         SET iaa006 = '1',
              yae092 = prm_yae092,
              aae036 = sysdate
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND iaa011 = prm_iaa011
         AND iaa002 = '2'
         AND iaa006 = '0';
         --查询是否有年审预约信息
      SELECT count(1)
        INTO n_count
        FROM wsjb.iraa16
       WHERE aab001 = prm_aab001
         AND iaz004 = v_iaz004
         AND aae120 = '0';
      IF n_count = 1 THEN
        UPDATE wsjb.iraa16  SET aaa170 = '1'
         WHERE aab001 = prm_aab001
         AND iaz004 = v_iaz004;
      END IF ;

      DELETE FROM wsjb.IRAD23_TMP ;
       INSERT INTO wsjb.IRAD23_TMP (aab001) VALUES (prm_aab001);
       SELECT aab004
         INTO v_aab004
         FROM xasi2.ab01
        WHERE  aab001 = prm_aab001;
       v_msg := v_aab004||'用户：您的'||prm_aae001||'年度基数申报审核已通过，审于：'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||',请按照打印单据尽快补缴.';
       PKG_Insurance.prc_MessageSend(prm_yae092,
                                     prm_iaa011,
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
         prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
         RETURN;
   END prc_YearInternetBC;
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
        prm_iaa011       IN     irad51.iaa011%TYPE ,--业务类型
        prm_yab019       IN     VARCHAR2           ,--类型标志
        prm_AppCode      OUT    VARCHAR2          ,
        prm_ErrorMsg     OUT    VARCHAR2             )
   IS
      n_count NUMBER(8);
      n_aac040 NUMBER(14,2);
      n_yac004 NUMBER(14,2);--养老基数
      n_yac005 NUMBER(14,2);--医疗基数
      n_yaa444 NUMBER(14,2);--新工伤基数
      v_aac001 irac01.aac001%TYPE;
      v_aac002 irac01.aac002%TYPE;
      v_aac003 irac01.aac003%TYPE;
      v_aab001 irac01.aab001%TYPE;
      v_aae110 irac01.aae110%TYPE;
      v_aae210 irac01.aae210%TYPE;
      v_aae310 irac01.aae310%TYPE;
      v_aae410 irac01.aae410%TYPE;
      v_aae510 irac01.aae510%TYPE;
      v_aab019 irab01.aab019%TYPE;
      v_aae002 VARCHAR2(9);--年审月度
      v_yae097 VARCHAR2(9);--单位最大做账期

      CURSOR cur_tmp_ac40 IS
          SELECT aab001,
                 aac001,
                 aac002,
                 aac003,
                 aac040,
                 yac004
            FROM wsjb.tmp_ac40
           WHERE aaz002 = prm_aaz002
             AND aab001 = prm_aab001;

   BEGIN
     /*初始化变量*/
    prm_AppCode  := gn_def_OK;
    prm_ErrorMsg := '';
     n_count  :=0;
     n_aac040 :=0;
     n_yac004 :=0;
     n_yac005 :=0;
     n_yaa444 :=0;

     /*必要的数据校验*/
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '单位编号不能为空!';
         RETURN;
      END IF;

      IF prm_yae092 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '操作人员编号不能为空!';
         RETURN;
      END IF;

      IF prm_aaz002 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '导入批次号不能为空!';
         RETURN;
      END IF;
     SELECT to_char(YAE097) as yae097,
           TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(YAE097), 'yyyyMM'), 1), 'yyyyMM') AS AAE002
      INTO v_yae097,v_aae002
      FROM xasi2.AA35
     WHERE AAE001 = prm_aae001;


     FOR rec_tmp_ac40 IN cur_tmp_ac40 LOOP
         n_aac040 :=0;
         n_yac004 :=0;
         n_yac005 :=0;
         n_yaa444 :=0;
         v_aae110 :='';
         v_aae210 :='';
         v_aae310 :='';
         v_aae410 :='';
         v_aae510 :='';

         v_aac001 := rec_tmp_ac40.aac001;
         v_aac002 := rec_tmp_ac40.aac002;
         v_aac003 := rec_tmp_ac40.aac003;
         v_aab001 := rec_tmp_ac40.aab001;
         n_aac040 := rec_tmp_ac40.aac040;

         SELECT count(1)
           INTO n_count
           FROM xasi2.ac01k8
          WHERE aab001 = v_aab001
            AND aae001 = prm_aae001;
         IF n_count = 0 THEN
           ROLLBACK;
           prm_AppCode  := gn_def_err;
           prm_ErrorMsg := '单位'||v_aab001||'的年审填报数据已清空。请点击查询生成数据后重新导出年审申报模板后填报!';
           RETURN;
         END IF;
         SELECT count(1)
           INTO n_count
           FROM xasi2.ac01k8
          WHERE aab001 = v_aab001
            AND aac001 = v_aac001
            AND aac002 = v_aac002
            AND aac003 = v_aac003
            AND aae001 = prm_aae001;
         IF n_count = 0 THEN
           ROLLBACK;
           prm_AppCode  := gn_def_err;
           prm_ErrorMsg := '没有找到'||v_aac003||'('||v_aac002||','||v_aac001||')的信息。请更正后再导入。';
           RETURN;
         END IF;
         IF n_aac040 IS NULL OR n_aac040 = 0 THEN
           ROLLBACK;
           prm_AppCode  := gn_def_err;
           prm_ErrorMsg := v_aac003||'('||v_aac002||','||v_aac001||')的工资信息为空或0。请更正后再导入。';
           RETURN;
         END IF;
          IF n_aac040 IS NULL OR n_aac040 < 1800 THEN
           ROLLBACK;
           prm_AppCode  := gn_def_err;
           prm_ErrorMsg := v_aac003||'('||v_aac002||','||v_aac001||')的工资信息小于1800元。请更正后再导入。';
           RETURN;
         END IF;


       /*  这里注释掉 改为批量调用 单个的过程prc_UpdateAc01k8  by whm 20190809 start
         --判断各险种状态
        SELECT aae110,aae210,aae310,aae410,aae510
          INTO v_aae110,v_aae210,v_aae310,v_aae410,v_aae510
          FROM xasi2.ac01k8
         WHERE aab001 = v_aab001
            AND aac001 = v_aac001
            AND aac002 = v_aac002
            AND aac003 = v_aac003
            AND aae001 = prm_aae001
            AND yab019 = prm_yab019;

         IF v_aae210 IS NULL AND v_aae310 IS NULL AND v_aae410 IS NULL AND v_aae510 IS NULL THEN
           n_yac005 :=0;
         ELSE
           --医疗基数
           SELECT
          pkg_common.fun_p_getcontributionbase(null,v_aab001,TRUNC(n_aac040,0),'0','03','1','1',v_aae002,PKG_Constant.YAB003_JBFZX)
          INTO n_yac005
          FROM dual;
          n_yaa444 := n_yac005;--工伤基数赋值
        END IF;

         IF v_aae110 IS NOT NULL THEN
           SELECT count(1)
             INTO n_count
             FROM xasi2.ab02
            WHERE aab001 = v_aab001
              AND aae140 = '06'
              AND aab051 = '1';
           IF n_count = 0 THEN
             --养老基数
            SELECT
            pkg_common.fun_p_getcontributionbase(null,v_aab001,TRUNC(n_aac040,0),'0','01','1','1',v_aae002,PKG_Constant.YAB003_JBFZX)
            INTO n_yac004
            FROM dual;
          ELSE
            n_yac004 := rec_tmp_ac40.yac004;
          END IF;

         END IF;

        SELECT aab019 INTO v_aab019 FROM xasi2.ab01 WHERE aab001 = v_aab001;
        IF v_aae410 IS NOT NULL AND v_aab019 = '60' THEN
          --个体户工伤基数
          SELECT
          pkg_common.fun_p_getcontributionbase(null,v_aab001,TRUNC(n_aac040,0),'0','04','1','1','999999',PKG_Constant.YAB003_JBFZX)
          INTO n_yaa444
          FROM dual;
        END IF;

        UPDATE xasi2.ac01k8
           SET aac040 = n_aac040,
                yac004 = n_yac004,
                yaa333 = n_yac005,
                yaa444 = n_yaa444
         WHERE aab001 = v_aab001
            AND aac001 = v_aac001
            AND aac002 = v_aac002
            AND aac003 = v_aac003
            AND aae001 = prm_aae001
            AND yab019 = prm_yab019;
    这里注释掉 改为批量调用 单个的过程prc_UpdateAc01k8  by whm 20190809 end;
    */

    -- 调用单个的更新Ac01k8
     prc_UpdateAc01k8 (
        v_aab001    ,--申报单位
        v_aac001    ,--个人编号
        prm_aae001    ,--申报年度
        n_aac040    , --新缴费工资
        prm_AppCode   ,
        prm_ErrorMsg  );

       END LOOP;


     EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*关闭打开的游标*/
         ROLLBACK;
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
         RETURN;

   END prc_UpdateAb05a1;

--更新AC01K8
PROCEDURE prc_UpdateAc01k8 (
        prm_aab001       IN     xasi2.ac01k8.aab001%TYPE,--申报单位
        prm_aac001       IN     xasi2.ac01k8.aac001%TYPE,--个人编号
        prm_aae001       IN     xasi2.ac01k8.aae001%TYPE,--申报年度
        prm_aac040       IN     xasi2.ac01k8.aac040%TYPE, --新缴费工资
        prm_AppCode   OUT    VARCHAR2,
        prm_ErrorMsg    OUT    VARCHAR2)
 IS

 var_yab136     VARCHAR2(6);  --AB01单位管理类型
 var_aab019     VARCHAR2(6);
 var_aae002     NUMBER(6);     --费款所属期
 var_yab003     VARCHAR2(6);
 num_yaa333     NUMBER(14,2);  --市社平基数
 num_yac004     NUMBER(14,2);  --省社平基数
 num_yaa444     NUMBER(14,2);  --工伤基数
 num_spgz       xasi2.ac02.aac040%TYPE;

 cursor cur_aae140 is  --ac01k8 中个人可以补差的险种(行专列)
   select decode(aae140,
                 'AAE110','01',
                 'AAE210','02',
                 'AAE310','03',
                 'AAE410','04',
                 'AAE510','05',
                 'AAE311','07') AS aae140,
                 aac031
    from xasi2.ac01k8 unpivot
    (aac031 for aae140 in(aae110,aae210, aae310,aae410,aae510, aae311))
   where aab001 = prm_aab001
     and aac001 = prm_aac001
     and aae001 = prm_aae001;


 BEGIN
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      var_yab003 := '610127';


      SELECT --to_char(YAE097) as yae097,
       TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(YAE097), 'yyyyMM'), 1), 'yyyyMM') AS AAE002
       INTO var_aae002
      FROM xasi2.AA35
     WHERE AAE001 = prm_aae001;


      --获取单位当前的管理类型
      BEGIN
         SELECT yab136,aab019
           INTO var_yab136, var_aab019
           FROM xasi2.ab01
          WHERE aab001 = prm_aab001;
      EXCEPTION
         WHEN OTHERS THEN
              prm_AppCode  :=  gn_def_ERR;
              prm_ErrorMsg  := '单位编码'||prm_aab001||'没有获取到单位管理类型';
              RETURN;
      END;

    FOR rec_aae140 IN cur_aae140 LOOP
      BEGIN
             IF rec_aae140.aae140 IN ('03','05') THEN
                 --市社平保底封顶
                 SELECT pkg_common.fun_p_getcontributionbase(
                                                    null,                              --个人编码 aac001
                                                    prm_aab001,                        --单位编码 aab001
                                                    ROUND(prm_aac040),                 --缴费工资 aac040
                                                    '0',                               --工资类别 yac503
                                                    rec_aae140.aae140,                 --险种类型 aae140
                                                    '1',                               --缴费人员类别 yac505
                                                    var_yab136,                        --单位管理类型（区别独立缴费人员） yab136
                                                    var_aae002,                        --费款所属期 aae002
                                                    var_yab003)                         --参保分中心 yab139
                    INTO num_yaa333
                 FROM dual;

             ELSIF rec_aae140.aae140 IN ('02','04') THEN
                 --省社平保底封顶(19年年审工伤失业 一般企业和个体工商都是60%到300% 所以用yaa444)
                 SELECT pkg_common.fun_p_getcontributionbase(
                                                    null,                                --个人编码 aac001
                                                    prm_aab001,                          --单位编码 aab001
                                                    ROUND(prm_aac040),                   --缴费工资 aac040
                                                    '0',                                 --工资类别 yac503
                                                    rec_aae140.aae140,                   --险种类型 aae140
                                                    '1',                                 --缴费人员类别 yac505
                                                    var_yab136,                          --单位管理类型（区别独立缴费人员） yab136
                                                    var_aae002,                          --费款所属期 aae002
                                                    var_yab003)                          --参保分中心 yab139
                    INTO num_yaa444
                 FROM dual;

             ELSIF rec_aae140.aae140 = '01'THEN
                     --养老(养老保底封顶中已经区分了一般企业和个体工商)
                     SELECT pkg_common.fun_p_getcontributionbase(
                                                    null,                                --个人编码 aac001
                                                    prm_aab001,                          --单位编码 aab001
                                                    ROUND(prm_aac040),                   --缴费工资 aac040
                                                    '0',                                 --工资类别 yac503
                                                    rec_aae140.aae140,                   --险种类型 aae140
                                                    '1',                                 --缴费人员类别 yac505
                                                    var_yab136,                          --单位管理类型（区别独立缴费人员） yab136
                                                    var_aae002,                          --费款所属期 aae002
                                                    var_yab003)                          --参保分中心 yab139
                  INTO num_yac004
               FROM dual;
              
            END IF;
      EXCEPTION
         WHEN OTHERS THEN
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg  := '个人编号'||prm_aac001||'没有获取到险种:'||rec_aae140.aae140||'的保底封顶基数';
             RETURN;
      END;
    END LOOP;

    UPDATE xasi2.ac01k8
       SET aac040 = prm_aac040,
              yaa333 = num_yaa333,
              yac004 = num_yac004,
              yaa444 = num_yaa444
     WHERE aab001 = prm_aab001
       AND aac001 = prm_aac001
       AND aae001 = prm_aae001
       AND yab019 = '1'
       AND (aae013 is null or aae013 ='1' or aae013 ='22');     -- 提前结算的不更(aae013=2或21)
       

 EXCEPTION
        WHEN OTHERS THEN
        /*关闭打开的游标*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
             RETURN;
END prc_UpdateAc01k8;

   /*****************************************************************************
   ** 过程名称 : prc_YearSalaryBCBySP
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：社平公布后补差
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
   PROCEDURE prc_YearSalaryBCBySP (prm_aab001       IN     irab01.aab001%TYPE,--单位编号  非必填
                               prm_yab139       IN     VARCHAR2          ,--参保所属分中心
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          )
   IS
    var_aae013  VARCHAR2(750);
     num_count    NUMBER;
     num_aae001   NUMBER(4);
     num_aae003  NUMBER(6);
     var_aab001  irab01.aab001%TYPE;
     var_aae140  irab02.aae140%TYPE;
     num_yac004_old  NUMBER(14,2);
     num_yac004  NUMBER(14,2);
     num_yae097  NUMBER(6);
     num_aae041  NUMBER(6);
     num_yac004_ce NUMBER(14,2);
     var_aac001  irac01.aac001%TYPE;
     var_yae235  irad55.yae235%TYPE;
     var_yae238  irad55.yae238%TYPE;
     num_yac401   tmp_ac42.yac401%type;           --1月补差金额,NUMBER
     num_yac402   tmp_ac42.yac401%type;           --2月补差金额,NUMBER
     num_yac403   tmp_ac42.yac401%type;           --3月补差金额,NUMBER
     num_yac404   tmp_ac42.yac401%type;           --4月补差金额,NUMBER
     num_yac405   tmp_ac42.yac401%type;           --5月补差金额,NUMBER
     num_yac406   tmp_ac42.yac401%type;           --6月补差金额,NUMBER
     num_yac407   tmp_ac42.yac401%type;           --7月补差金额,NUMBER
     num_yac408   tmp_ac42.yac401%type;           --8月补差金额,NUMBER
     num_yac409   tmp_ac42.yac401%type;           --9月补差金额,NUMBER
     num_yac410   tmp_ac42.yac401%type;           --10月补差金额,NUMBER
     num_yac411   tmp_ac42.yac401%type;           --11月补差金额,NUMBER
     num_yac412   tmp_ac42.yac401%type;           --12月补差金额,NUMBER
     num_aae002_max NUMBER(6);
     var_yab136    irab01.yab136%TYPE;
     var_yab275    irab01.yab275%TYPE;
     var_aae119    irab01.aae119%TYPE;
     var_aab019    irab01.aab019%TYPE;
     var_yac503    irac01.yac503%TYPE;
     var_yac505    irac01.yac505%TYPE;
     num_spgz      NUMBER(14,2);
     var_yae099    xasi2.ae16.yae099%TYPE;
     cursor cur_irad55 IS
     SELECT *
       FROM wsjb.irad55
      WHERE aae100 = num_aae001
        AND yae235 = '0';
     --获取年审补差险种信息
     cursor cur_aae140 IS
         SELECT aae140 AS aae140
           FROM xasi2.ab08a8
          WHERE yae517 IN ('H12','H17')
            AND aae003 = num_aae003
            AND aab001 = var_aab001
         UNION
         SELECT aae140 AS aae140
           FROM wsjb.irab08
          WHERE yae517 IN ('H12','H17')
            AND aae003 = num_aae003
            AND aab001 = var_aab001;
     --获取需要补差的人员信息
     cursor cur_info IS
     SELECT DISTINCT aac001
       FROM xasi2.ac08 a
      WHERE EXISTS(SELECT 1
                     FROM xasi2.ab08a8
                    WHERE yae517 IN ('H12','H17')
                      AND aae003 = num_aae003
                      AND aab001 = var_aab001
                      AND aae140 = var_aae140
                      AND yae518 = a.yae518)
     UNION
     SELECT DISTINCT aac001
       FROM xasi2.ac08a1 a
      WHERE EXISTS(SELECT 1
                     FROM xasi2.ab08
                    WHERE yae517 IN ('H12','H17')
                      AND aae003 = num_aae003
                      AND aab001 = var_aab001
                      AND aae140 = var_aae140
                      AND yae518 = a.yae518)
     UNION
     SELECT DISTINCT aac001
       FROM wsjb.irac08a1  a
      WHERE EXISTS(SELECT 1
                     FROM  wsjb.irab08
                    WHERE yae517 IN ('H12','H17')
                      AND aae003 = num_aae003
                      AND aab001 = var_aab001
                      AND aae140 = var_aae140
                      AND yae518 = a.yae518);
     cursor cur_yac004 IS
     SELECT aae013 AS yac004 ,
            aac001 AS aac001
       FROM  wsjb.tmp_ac43
      WHERE aab001 = var_aab001
        AND aae140 = var_aae140
        AND aae001 = num_aae001
        AND (yac401 <> 0 OR yac402<>0 OR yac403<>0 OR yac404<>0 OR yac405<>0 OR yac406<>0 OR yac407<>0 OR yac408<>0 OR yac409<>0 OR yac410<>0 OR yac411<>0 OR yac412<>0)
       ;
   BEGIN
     prm_AppCode  := PKG_Constant.gn_def_OK;
      prm_ErrorMsg := '';
      num_aae001 := TO_NUMBER(TO_CHAR(SYSDATE,'yyyy'));
      INSERT INTO wsjb.irad55
      SELECT iaz004,iaa011,aab001,aae001,111,SYSDATE,yab003,'0',NULL,aae003,num_aae001
        FROM wsjb.irad51  a
       WHERE iaa011 = 'A05'
         AND iaa002 = '2'
         AND iaa006 = '1'
         AND NOT EXISTS(SELECT 1 FROM wsjb.irad55  WHERE a.iaz004 = iaz004 AND aae001 = a.aae001 AND aab001 = a.aab001)
         AND (aab001 = prm_aab001 OR NVL(prm_aab001,1) = 1)
         AND aae001 = 2017
         --AND aae036 > TO_DATE('2018-02-05','yyyy-mm-dd')
         ;
      --循环年审二次补差单位
     FOR rec_irad55 IN cur_irad55 LOOP
         var_yae235 := xasi2.pkg_comm.yae235_CG;
         var_yae238 := '';
         var_aab001 := rec_irad55.aab001;
         num_aae003 := rec_irad55.aae003;
         num_aae001 := rec_irad55.aae001;
         BEGIN
           SELECT yab136,
                  yab275,
                  aae119,
                  aab019
             INTO var_yab136,
                  var_yab275,
                  var_aae119,
                  var_aab019
             FROM xasi2.ab01
            WHERE aab001 = prm_aab001;
        EXCEPTION
           WHEN OTHERS THEN
                prm_AppCode := PKG_Constant.gn_def_ERR||'02';
                prm_ErrorMsg  := '单位编码'||prm_aab001||'社保经办机构'||prm_yab139||'没有获取到单位基本信息';
                RETURN;
        END;
         --循环补差险种
         num_aae041 := rec_irad55.aae001||'01';
         FOR rec_aae140 IN cur_aae140 LOOP
             var_aae140 := rec_aae140.aae140;
             --获取补差最大做帐期号
             IF var_aae140 = '01' THEN
                SELECT MAX(aae003)
                  INTO num_yae097
                  FROM  wsjb.irab08
                 WHERE aab001 = var_aab001
                   AND yae517 = 'H01'
                   AND aae140 = var_aae140;
             ELSE
               SELECT YAE097
                 INTO num_yae097
                 FROM xasi2.ab02
                WHERE aab001 = var_aab001
                  AND aae140 = var_aae140;
             END IF;
             --如果不为年审年度，则期号为年审年度末月
             IF SUBSTR(num_yae097,0,4) > rec_irad55.aae001 THEN
                num_yae097 := rec_irad55.aae001||'12';
             END IF;
             --循环补差人员
             FOR rec_info IN cur_info LOOP
                 var_aac001 := rec_info.aac001;

                 IF var_aae140 = '01' THEN
                    var_yac503 := xasi2.pkg_comm.YAC503_SB;
                    var_yac505 := '010';
                 ELSE
                   --如果人员不是正常缴费状态或人员为退休状态，则不补差
                   SELECT count(1)
                     INTO num_count
                     FROM xasi2.ac02
                    WHERE aac001 = var_aac001
                      AND aae140 = var_aae140
                      AND aac031 IN ('2','3');

                   IF num_count > 0 THEN
                      GOTO leb_next2;
                   END IF;

                   SELECT count(1)
                     INTO num_count
                     FROM xasi2.kc01
                    WHERE aac001 = var_aac001
                      AND akc021 = '21';

                   IF num_count >0 THEN
                      GOTO leb_next2;
                   END IF;

                  BEGIN
                  SELECT yac503,
                         YAC505
                    INTO var_yac503,
                         var_yac505
                    FROM XASI2.ac02
                   WHERE aac001 = var_aac001
                     AND aab001 = var_aab001
                     AND aae140 = var_aae140;
                  EXCEPTION
                       WHEN OTHERS THEN
                            prm_AppCode := PKG_Constant.gn_def_ERR||'02';
                            prm_ErrorMsg  := '个人编号'||var_aac001||'险种'||var_aae140||'没有获取到个人参保信息';
                            RETURN;
                  END;

                 END IF;


                  num_yac401 := 0;
                  num_yac402 := 0;
                  num_yac403 := 0;
                  num_yac404 := 0;
                  num_yac405 := 0;
                  num_yac406 := 0;
                  num_yac407 := 0;
                  num_yac408 := 0;
                  num_yac409 := 0;
                  num_yac410 := 0;
                  num_yac411 := 0;
                  num_yac412 := 0;
                 WHILE num_aae041 <= num_yae097 LOOP

                   IF var_aae140 = '01' THEN

                      BEGIN
                       SELECT NVL(SUM(aae180),0)
                         INTO num_yac004_old
                         FROM wsjb.irac08a1
                        WHERE aac001 = var_aac001
                         AND aab001 = var_aab001
                         AND aae002 = num_aae041
                         AND aae140 = var_aae140
                         AND aae143 IN(xasi2.pkg_comm.AAE143_ZCJF, --正常缴费
                                                 xasi2.pkg_comm.AAE143_JSBC, --基数补差
                                                 xasi2.pkg_comm.AAE143_BJ  , --补缴
                                                 xasi2.pkg_comm.AAE143_BS  , --补收
                                                 xasi2.pkg_comm.AAE143_DLJF, --独立人员缴费
                                                 xasi2.pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                                 xasi2.pkg_comm.AAE143_BLBC); --比例补差
                     EXCEPTION
                          WHEN OTHERS THEN
                               GOTO leb_next1;
                     END;
                   ELSE
                     --获取之前的缴费基数
                     BEGIN
                        SELECT NVL(SUM(aae180),0)  --缴费基数
                          INTO num_yac004_old
                          FROM
                               (SELECT aae180
                                  FROM xasi2.ac08
                                 WHERE aac001 = var_aac001
                                   AND aab001 = var_aab001
                                   AND aae002 = num_aae041
                                   AND aae140 = var_aae140
                                   AND aae143 IN(xasi2.pkg_comm.AAE143_ZCJF, --正常缴费
                                                 xasi2.pkg_comm.AAE143_JSBC, --基数补差
                                                 xasi2.pkg_comm.AAE143_BJ  , --补缴
                                                 xasi2.pkg_comm.AAE143_BS  , --补收
                                                 xasi2.pkg_comm.AAE143_DLJF, --独立人员缴费
                                                 xasi2.pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                                 xasi2.pkg_comm.AAE143_BLBC) --比例补差
                                   AND yaa330 = xasi2.pkg_comm.YAA330_BL  --比例模式
                               UNION
                                SELECT aae180
                                  FROM xasi2.AC08A1
                                 WHERE aac001 = var_aac001
                                   AND aab001 = var_aab001
                                   AND aae002 = num_aae041
                                   AND aae140 = var_aae140
                                   AND aae143 IN(xasi2.pkg_comm.AAE143_ZCJF, --正常缴费
                                                 xasi2.pkg_comm.AAE143_JSBC, --基数补差
                                                 xasi2.pkg_comm.AAE143_BJ  , --补缴
                                                 xasi2.pkg_comm.AAE143_BS  , --补收
                                                 xasi2.pkg_comm.AAE143_DLJF, --独立人员缴费
                                                 xasi2.pkg_comm.AAE143_TXBHZH, --退休人员补划帐户
                                                 xasi2.pkg_comm.AAE143_BLBC) --比例补差
                                   AND yaa330 =  xasi2.pkg_comm.YAA330_BL  --比例模式
                                 )
                                 ;
                        EXCEPTION
                             WHEN OTHERS THEN
                                  GOTO leb_next1;
                        END;
                      END IF;

                       --调用保底封顶过程，获取缴费基数和缴费工资
                        SELECT MAX(aae041)
                          INTO num_aae002_max
                          FROM xasi2.AA02
                         WHERE yaa001 = '16'
                           AND aae140 = var_aae140
                           AND aae001 = rec_irad55.aae001;
                       xasi2.pkg_P_Comm_CZ.prc_P_getContributionBase
                                                             (var_aac001   ,     --个人编码
                                                              prm_aab001   ,     --单位编码
                                                              num_yac004_old   ,     --缴费工资
                                                              var_yac503  ,     --工资类别
                                                              var_aae140   ,     --险种类型
                                                              var_yac505   ,     --缴费人员类别
                                                              var_yab136   ,     --单位管理类型（区别独立缴费人员）
                                                              num_aae002_max   ,     --费款所属期
                                                              prm_yab139   ,     --参保分中心
                                                              num_yac004   ,     --缴费基数
                                                              prm_AppCode  ,     --错误代码
                                                              prm_ErrorMsg );    --错误内容
                       IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                          RETURN;
                       END IF;

                        --判断个体工商户
                       IF var_aab019 = '60' THEN
                         --获取社平工资
                         num_spgz := xasi2.pkg_comm.fun_GetAvgSalary(var_aae140,'16',num_aae002_max,PKG_Constant.YAB003_JBFZX);
                         --如果险种为工伤 缴费工资和缴费基数为社平工资
                         IF var_aae140 = xasi2.pkg_comm.AAE140_GS THEN
                            num_yac004 := ROUND(num_spgz/12);
                          ELSE
                            IF num_yac004 > ROUND(num_spgz/12) THEN
                               num_yac004 := ROUND(num_spgz/12);
                            END  IF;
                          END IF;
                       END IF;

                      --退休继续缴费人员是否需要补费？？？？

                      num_yac004_ce := num_yac004 - num_yac004_old;

                      IF SUBSTR(num_aae041,-2)='01' THEN
                         num_yac401 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='02' THEN
                         num_yac402 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='03' THEN
                         num_yac403 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='04' THEN
                         num_yac404 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='05' THEN
                         num_yac405 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='06' THEN
                         num_yac406 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='07' THEN
                         num_yac407 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='08' THEN
                         num_yac408 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='09' THEN
                         num_yac409 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='10' THEN
                         num_yac410 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='11' THEN
                         num_yac411 := num_yac004_ce;
                      END IF;
                      IF SUBSTR(num_aae041,-2)='12' THEN
                         num_yac412 := num_yac004_ce;
                      END IF;
                       <<leb_next1>>
                       num_aae041 := TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(num_aae041),'yyyymm'),1),'yyyymm'));
                 END LOOP;

                 INSERT INTO wsjb.tmp_ac43
                 SELECT var_aac001,
                         var_aab001,
                         var_aae140,
                         num_yac401,
                        num_yac402,
                        num_yac403,
                        num_yac404,
                        num_yac405,
                        num_yac406,
                        num_yac407,
                        num_yac408,
                        num_yac409,
                        num_yac410,
                        num_yac411,
                        num_yac412,
                        num_yac004,
                        rec_irad55.aae001
                   FROM dual;
                 <<leb_next2>>
                 var_aac001 := NULL;
             END LOOP;


             --根据tmp_ac43 生成缴费信息
             prc_YearSalaryByPayInfos (var_aab001 ,
                                       '2'   ,
                                       num_yae097 ,
                                       var_aae140 ,
                                       rec_irad55.aae001 ,
                                       xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAB222') ,
                                       110292 ,
                                       prm_yab139,
                                       prm_AppCode,
                                       prm_ErrorMsg);
             IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
                 RETURN;
             END IF;


             --修改缴费基数

             FOR rec_yac004 IN cur_yac004 LOOP
                 --更新人员的参保信息

                 IF var_aae140  = '01' THEN

                   UPDATE wsjb.IRAC01A3
                      SET yac004 = rec_yac004.yac004
                    WHERE aac001 = rec_yac004.aac001
                      AND aab001 = var_aab001;
                 ELSE
                   UPDATE xasi2.ac02
                      SET yac004 = rec_yac004.yac004
                    WHERE aac001 = rec_yac004.aac001
                      AND aae140 = var_aae140
                      AND aab001 = var_aab001;
                 END IF;
                 --写个人缴费基数变更记录表
                 INSERT INTO xasi2.ac04a3(YAE099,             --业务流水号,VARCHAR2
                                             AAC001,             --个人编号,VARCHAR2
                                             AAB001,             --单位编号,VARCHAR2
                                             AAE140,             --险种类型,VARCHAR2
                                             YAC235,             --工资变更类型,VARCHAR2
                                             YAC506,             --变更前工资,NUMBER
                                             YAC507,             --变更前缴费基数,NUMBER
                                             YAC514,             --变更前划帐户基数,NUMBER
                                             AAC040,             --缴费工资,NUMBER
                                             YAC004,             --缴费基数,NUMBER
                                             YAA333,             --账户基数,NUMBER
                                             AAE002,             --费款所属期,NUMBER
                                             AAE013,             --备注,VARCHAR2
                                             AAE011,             --经办人,NUMBER
                                             AAE036,             --经办时间,DATE
                                             YAB003,             --社保经办机构,VARCHAR2
                                             YAB139,             --参保所属分中心,VARCHAR2
                                             YAC503,             --工资类别,VARCHAR2
                                             YAC526              --变更前工资类别,VARCHAR2
                                             )
                                     VALUES (var_yae099,             --业务流水号,VARCHAR2
                                             rec_yac004.aac001,             --个人编号,VARCHAR2
                                             var_aab001,             --单位编号,VARCHAR2
                                             var_aae140,             --险种类型,VARCHAR2
                                             xasi2.pkg_comm.YAC235_PL,     --工资变更类型,VARCHAR2
                                             0,         --变更前工资,NUMBER
                                             0,         --变更前缴费基数,NUMBER
                                             0,         --变更前划帐户基数,NUMBER
                                             0,             --缴费工资,NUMBER
                                             num_yac004,             --缴费基数,NUMBER
                                             num_yac004,             --账户基数,NUMBER
                                             num_yae097,             --费款所属期,NUMBER
                                             '年申报二次补差'  ,                 --备注,VARCHAR2
                                             110292,             --经办人,NUMBER
                                             sysdate,             --经办时间,DATE
                                             prm_yab139,             --社保经办机构,VARCHAR2
                                             prm_yab139,             --参保所属分中心,VARCHAR2
                                             '0',             --工资类别,VARCHAR2
                                             '0');            --变更前工资类别,VARCHAR2
             END LOOP;
         END LOOP;
         <<leb_next>>
         UPDATE wsjb.irad55
            SET --yae235 = var_yae235,
                yae238 = var_yae238
          WHERE iaz004 = rec_irad55.iaz004
            AND aab001 = rec_irad55.aab001
            AND aae001 = rec_irad55.aae001;
     END LOOP;
   EXCEPTION
    WHEN OTHERS THEN
       prm_AppCode  :=  PKG_Constant.gn_def_ERR;
       prm_ErrorMsg := '数据库错误:'|| PRE_ERRCODE || SQLERRM ;
       RETURN;
   END prc_YearSalaryBCBySP;
 /*****************************************************************************
   ** 过程名称 : prc_YearSalaryBCBySP
   ** 过程编号 ：
   ** 业务环节 ：
   ** 功能描述 ：社平公布后补差
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
   PROCEDURE prc_YearSalaryByPayInfos (prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                               prm_type         IN     VARCHAR2,   --1 为社平公布前补差 2为社平公布后补差
                               prm_aae003       IN     NUMBER,
                               prm_aae140       IN     VARCHAR2,
                               prm_aae001       IN     NUMBER,
                               prm_yab222       IN     VARCHAR2,
                               prm_aae011       IN     VARCHAR2,
                               prm_yab139       IN     VARCHAR2,
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          )
   IS
    var_aae013  VARCHAR2(750);
     num_count    NUMBER;
     num_aae001   NUMBER(4);
     num_aae003  NUMBER(6);
     var_aab001  irab01.aab001%TYPE;
     var_aae140  irab02.aae140%TYPE;
     num_yac004_old  NUMBER(14,2);
     num_yac004  NUMBER(14,2);
     num_yae097  NUMBER(6);
     num_aae041  NUMBER(6);
     num_yac004_ce NUMBER(14,2);
     var_aac001  irac01.aac001%TYPE;
     var_yae235  irad55.yae235%TYPE;
     var_yae238  irad55.yae238%TYPE;
     num_yac401   tmp_ac42.yac401%type;           --1月补差金额,NUMBER
     num_yac402   tmp_ac42.yac401%type;           --2月补差金额,NUMBER
     num_yac403   tmp_ac42.yac401%type;           --3月补差金额,NUMBER
     num_yac404   tmp_ac42.yac401%type;           --4月补差金额,NUMBER
     num_yac405   tmp_ac42.yac401%type;           --5月补差金额,NUMBER
     num_yac406   tmp_ac42.yac401%type;           --6月补差金额,NUMBER
     num_yac407   tmp_ac42.yac401%type;           --7月补差金额,NUMBER
     num_yac408   tmp_ac42.yac401%type;           --8月补差金额,NUMBER
     num_yac409   tmp_ac42.yac401%type;           --9月补差金额,NUMBER
     num_yac410   tmp_ac42.yac401%type;           --10月补差金额,NUMBER
     num_yac411   tmp_ac42.yac401%type;           --11月补差金额,NUMBER
     num_yac412   tmp_ac42.yac401%type;           --12月补差金额,NUMBER
     num_aae002_max NUMBER(6);
     var_yab136    irab01.yab136%TYPE;
     var_yab275    irab01.yab275%TYPE;
     var_aae119    irab01.aae119%TYPE;
     var_aab019    irab01.aab019%TYPE;
     var_yac503    irac01.yac503%TYPE;
     var_yac505    irac01.yac505%TYPE;
     num_spgz      NUMBER(14,2);
     var_yae518    ab08.yae518%TYPE;
     cursor cur_info IS
     SELECT *
       FROM wsjb.tmp_ac43
      WHERE aab001 = prm_aab001
        AND aae001 = prm_aae001
        AND aae140 = prm_aae140
        AND 1 = DECODE(prm_type,'2',1,0)
     UNION
     SELECT *
       FROM wsjb.tmp_ac42
      WHERE aab001 = prm_aab001
        AND aae001 = prm_aae001
        AND aae140 = prm_aae140
        AND 1 = DECODE(prm_type,'1',1,0);

   BEGIN
     prm_AppCode  := PKG_Constant.gn_def_OK;
      prm_ErrorMsg := '';


      IF prm_aae140 = '01' THEN
          --调用养老补差
        prc_YearSalaryBCByYL(prm_aab001  ,
                             prm_aae001  ,
                             num_yae097  ,
                             prm_yab222  ,
                             0  ,
                             '2',
                             prm_aae011  ,
                             prm_yab139  ,
                             prm_AppCode ,
                             prm_ErrorMsg);

       IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
           RETURN;
       END IF;
     ELSE --医疗四险
            prc_YearSalaryBCBy03(prm_aab001,
                               prm_aae001,
                               prm_aae003,
                               prm_yab222,
                               0,
                               '2'  ,
                               prm_aae140,
                               prm_aae011,
                               prm_yab139,
                               prm_AppCode,
                               prm_ErrorMsg);
      END IF;
   EXCEPTION
    WHEN OTHERS THEN
       prm_AppCode  :=  PKG_Constant.gn_def_ERR;
       prm_ErrorMsg := '数据库错误:'|| PRE_ERRCODE || SQLERRM ;
       RETURN;
   END prc_YearSalaryByPayInfos;
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
                               prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      num_count     NUMBER;
      v_msg        VARCHAR2(300);
      var_aaz002   irad31.aaz002%TYPE;
      num_aae041_year NUMBER(6);  --补差开始时间
      num_yae097   xasi2.ab02.yae097%TYPE; --单位最大做帐期号
      var_aae140   xasi2.ab02.aae140%TYPE; --险种
      var_aac001   xasi2.ac01.aac001%TYPE; --个人编号
      num_aae002   xasi2.ac08a1.aae002%TYPE;
      num_aac040   xasi2.ac02.aac040%TYPE;
      num_spgz     xasi2.ac02.aac040%TYPE;
      num_yac004   xasi2.ac02.yac004%TYPE;

      var_yac503   xasi2.ac02.yac503%TYPE;
      var_yac505   xasi2.ac02.yac505%TYPE;
      num_yac401   tmp_ac42.yac401%type;           --1月补差金额,NUMBER
      num_yac402   tmp_ac42.yac401%type;           --2月补差金额,NUMBER
      num_yac403   tmp_ac42.yac401%type;           --3月补差金额,NUMBER
      num_yac404   tmp_ac42.yac401%type;           --4月补差金额,NUMBER
      num_yac405   tmp_ac42.yac401%type;           --5月补差金额,NUMBER
      num_yac406   tmp_ac42.yac401%type;           --6月补差金额,NUMBER
      num_yac407   tmp_ac42.yac401%type;           --7月补差金额,NUMBER
      num_yac408   tmp_ac42.yac401%type;           --8月补差金额,NUMBER
      num_yac409   tmp_ac42.yac401%type;           --9月补差金额,NUMBER
      num_yac410   tmp_ac42.yac401%type;           --10月补差金额,NUMBER
      num_yac411   tmp_ac42.yac401%type;           --11月补差金额,NUMBER
      num_yac412   tmp_ac42.yac401%type;           --12月补差金额,NUMBER
      var_procNo   VARCHAR2(5);                    --过程号
      var_aae013   xasi2.ab08a8.aae013%TYPE;
      var_aae100   VARCHAR2(9);
      var_yae099   xasi2.ac04a3.yae099%TYPE;
      var_yae518   xasi2.ab08.yae518%TYPE;
      num_aae041   NUMBER(6);
      num_aae042   NUMBER(6);
      sum_new_aab213        NUMBER(14,2);
      new_aab213            NUMBER(14,2);
      sum_aab213            NUMBER(14,2);
      num_ala080_old        NUMBER;
      sum_aae180            NUMBER(14,2);

      sum_yab158            xasi2.AC08A1.aab213%type;
      sum_new_yab158        xasi2.AC08A1.aab213%type;
      new_yab158            xasi2.AC08A1.aab213%type;
      var_yae518_tk         ab08.yae518%TYPE;

       var_yab136      xasi2.ab01.yab136%TYPE  ;  --单位管理类型
      var_aab019      xasi2.ab01.aab019%TYPE  ;  --单位类型
      var_aab020      xasi2.ab01.aab020%TYPE  ;  --经济类型
      var_aab021      xasi2.ab01.aab021%TYPE  ;  --隶属关系
      var_aab022      xasi2.ab01.aab022%TYPE  ;  --行业代码
      var_YKB109      xasi2.ab01.YKB109%TYPE  ;  --是否享受公务员统筹待遇
      var_yab275      xasi2.ab01.yab275%TYPE  ;  --医疗保险执行办法
      var_aae119      xasi2.ab01.aae119%TYPE;
      var_yab380      xasi2.ab01.yab380%TYPE  ;
      var_yab222      irab08.yab222%TYPE;
       var_yae010_110     varchar2(9);
       var_yae010_120     varchar2(9);
       var_yae010_210     varchar2(9);
       var_yae010_310     varchar2(9);
       var_yae010_410     varchar2(9);
       var_yae010_510     varchar2(9);
      var_aaa040      VARCHAR2(9);
      num_aaa041      xasi2.ac08.aaa041%TYPE;
      num_yaa017      xasi2.ac08.aaa041%TYPE;
      num_aaa042      xasi2.ac08.aaa041%TYPE;
      num_aaa043      xasi2.ac08.aaa041%TYPE;
      var_ykb110      irab01.ykb110%TYPE;
      var_yae010      irab08.yae010%TYPE;
      var_aae076      irab08.aae076%TYPE;
      --获取单位提交的申报人员
      CURSOR cur_tmp_ac42 IS
        select AAC001,             --人员编号,VARCHAR2
               AAB001,             --单位编号,VARCHAR2
               AAE140,             --险种,VARCHAR2
               YAC401,             --1月补差金额,NUMBER
               YAC402,             --2月补差金额,NUMBER
               YAC403,             --3月补差金额,NUMBER
               YAC404,             --4月补差金额,NUMBER
               YAC405,             --5月补差金额,NUMBER
               YAC406,             --6月补差金额,NUMBER
               YAC407,             --7月补差金额,NUMBER
               YAC408,             --8月补差金额,NUMBER
               YAC409,             --9月补差金额,NUMBER
               YAC410,             --10月补差金额,NUMBER
               YAC411,             --11月补差金额,NUMBER
               YAC412,             --12月补差金额,NUMBER
               AAE013,             --备注,VARCHAR2
               aae001
          from wsjb.tmp_ac42   --人员险种补差信息表
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND aae140 = prm_aae140
           AND 1 = DECODE(prm_type,'1',1,0)
        UNION
        select AAC001,             --人员编号,VARCHAR2
               AAB001,             --单位编号,VARCHAR2
               AAE140,             --险种,VARCHAR2
               YAC401,             --1月补差金额,NUMBER
               YAC402,             --2月补差金额,NUMBER
               YAC403,             --3月补差金额,NUMBER
               YAC404,             --4月补差金额,NUMBER
               YAC405,             --5月补差金额,NUMBER
               YAC406,             --6月补差金额,NUMBER
               YAC407,             --7月补差金额,NUMBER
               YAC408,             --8月补差金额,NUMBER
               YAC409,             --9月补差金额,NUMBER
               YAC410,             --10月补差金额,NUMBER
               YAC411,             --11月补差金额,NUMBER
               YAC412,             --12月补差金额,NUMBER
               AAE013,             --备注,VARCHAR2
               aae001
          from wsjb.tmp_ac43   --人员险种二次补差信息表
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND aae140 = prm_aae140
           AND 1 = DECODE(prm_type,'2',1,0);
      CURSOR cur_aae041
          IS
          SELECT aae041 AS aae041,
                 aae042 AS aae042
            FROM xasi2.aa05a1
           WHERE aae140 = prm_aae140;
        CURSOR cur_aae180
          IS
          SELECT SUM(DECODE(yac505,'021',0,aae180)) AS aae180,
                   SUM(aae180) AS aae180_1,
                   SUM(aab213) AS aab213,
                   MAX(aaa040) AS aaa040,
                   MAX(ala080) AS ala080,
                   MAX(aaa041) AS aaa041,  --个人缴费比例
                   MAX(yaa017) AS yaa017,  --个人缴费划统筹比例
                   MAX(aaa042) AS aaa042,  --单位缴费比例
                   MAX(aaa043) AS aaa043, --单位缴费划账户比例
                   SUM(yab158) AS yab158
              FROM xasi2.ac08a1
             WHERE yae518 = var_yae518  --核定流水号
               AND aae140 = prm_aae140
             --  AND aae143 <> pkg_Comm.AAE143_JSBC
               AND aae002 >= num_aae041
               AND aae002 <= num_aae042;
     CURSOR cur_ac08a1_sk                                     -- 明细信息
      IS
         SELECT a.aae140,
                a.yae010,    --费用来源
                MIN(a.aae002) AS aae041,
                MAX(a.aae002) AS aae042,
                COUNT(DISTINCT a.aac001) yae231,   --人数
                a.yae203   , --费用来源比例
                CASE WHEN a.AKC021 = xasi2.pkg_comm.AKC021_ZZ THEN xasi2.pkg_comm.YAB538_ZZ
                     WHEN a.AKC021 = xasi2.pkg_comm.AKC021_TX THEN xasi2.pkg_comm.YAB538_TX
                     ELSE xasi2.pkg_comm.YAB538_LX
                     END YAB538,
                NVL(SUM(a.yaa333),0) aab120,   --个人缴费基数总额
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
           FROM xasi2.ac08a1 a
          WHERE a.yae518 = var_yae518
            AND a.aab001 = prm_aab001
            AND a.aae003 = num_aae002
          GROUP BY a.aae140,
                   a.yae010,    --费用来源
                   a.yae203,    --费用来源比例
                   a.AKC021,
                   CASE WHEN a.AKC021 = xasi2.pkg_comm.AKC021_ZZ THEN xasi2.pkg_comm.YAB538_ZZ
                        WHEN a.AKC021 = xasi2.pkg_comm.AKC021_TX THEN xasi2.pkg_comm.YAB538_TX
                        ELSE xasi2.pkg_comm.YAB538_LX
                        END;

      CURSOR cur_ac08a1_tk                                      -- 明细信息
      IS
         SELECT a.aae140,
                a.yae010,    --费用来源
                MIN(a.aae002) AS aae041,
                MAX(a.aae002) AS aae042,
                COUNT(DISTINCT a.aac001) yae231,   --人数
                a.yae203   , --费用来源比例
                CASE WHEN a.AKC021 = xasi2.pkg_comm.AKC021_ZZ THEN xasi2.pkg_comm.YAB538_ZZ
                     WHEN a.AKC021 = xasi2.pkg_comm.AKC021_TX THEN xasi2.pkg_comm.YAB538_TX
                     ELSE xasi2.pkg_comm.YAB538_LX
                     END YAB538,
                NVL(SUM(a.yaa333),0) aab120,   --个人缴费基数总额
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
           FROM xasi2.ac08a1 a
          WHERE a.yae518 = var_yae518_tk
            AND a.aab001 = prm_aab001
            AND a.aae003 = num_aae002
          GROUP BY a.aae140,
                   a.yae010,    --费用来源
                   a.yae203,    --费用来源比例
                   a.AKC021,
                   CASE WHEN a.AKC021 = xasi2.pkg_comm.AKC021_ZZ THEN xasi2.pkg_comm.YAB538_ZZ
                        WHEN a.AKC021 = xasi2.pkg_comm.AKC021_TX THEN xasi2.pkg_comm.YAB538_TX
                        ELSE xasi2.pkg_comm.YAB538_LX
                        END;
   --根据征收方式更新费用来源
      CURSOR cur_ab08 IS
      SELECT yae518,
             aae140
        FROM xasi2.ab08
       WHERE aab001 = prm_aab001
         AND yae517 IN (xasi2.pkg_comm.YAE517_H12,xasi2.pkg_comm.YAE517_H17)
         AND aae003 = num_aae002
         AND yab222 = var_yab222;
      --根据征收方式更新费用来源
      CURSOR cur_ab08a8 IS
      SELECT yae518,
             aae140
        FROM xasi2.ab08a8
       WHERE aab001 = prm_aab001
         AND yae517 = xasi2.pkg_comm.YAE517_H17
         AND aae003 = num_aae002
         AND yab222 = var_yab222;
   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      var_procNo   :='Y01';
      var_yae518   := xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAE518');
      var_yae518_tk   := xasi2.pkg_comm.FUN_GETSEQUENCE(NULL,'YAE518');
      num_aae002   := prm_aae002;
      var_yab222   :=prm_yab222;
      --参数校验
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '单位编号不能为空' ;
         RETURN;
      END IF;

      IF prm_aae001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '年审年度不能为空' ;
         RETURN;
      END IF;
      IF num_aae002 IS NULL THEN
         SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(yae097),'yyyymm'),1),'yyyymm'))
           INTO num_aae002
           FROM xasi2.ab02
          WHERE aab001 = prm_aab001;
      END IF;

      --获取单位当前的管理类型
      BEGIN
         SELECT yab136,
                yab275,
                aae119,
                aab019
           INTO var_yab136,
                var_yab275,
                var_aae119,
                var_aab019
           FROM xasi2.ab01
          WHERE aab001 = prm_aab001;
      EXCEPTION
         WHEN OTHERS THEN
              prm_AppCode := ''||var_procNo||'02';
              prm_ErrorMsg  := '单位编码'||prm_aab001||'社保经办机构'||prm_yab139||'没有获取到单位基本信息';
              RETURN;
      END;

      --循环获取人员补差的时间
      FOR rec_tmp_ac42 IN cur_tmp_ac42 LOOP
           --根据TMP_ac42插入补差的临时表中
           var_aac001 := rec_tmp_ac42.aac001;
           --1月补差
           IF rec_tmp_ac42.yac401 <> 0 THEN
               prc_insertAC08A1(prm_aab001  ,
                                  var_aac001  ,
                                  prm_aae001||'01'  ,
                                  num_aae002,
                                  rec_tmp_ac42.yac401,
                                  case WHEN rec_tmp_ac42.yac401 < 0 THEN var_yae518_tk ELSE var_yae518 END  ,
                                  prm_aae076,
                                  prm_aae140,
                                  prm_aae011  ,
                                  prm_yab139  ,
                                  prm_AppCode ,
                                  prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac402 <> 0 THEN   --2月补差
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'02'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac402,
                                    case WHEN rec_tmp_ac42.yac402 < 0 THEN var_yae518_tk ELSE var_yae518 END  ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac403 <> 0 THEN   --三月补差
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'03'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac403,
                                    case WHEN rec_tmp_ac42.yac403 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac404 <> 0 THEN   --4月补差
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'04'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac404,
                                    case WHEN rec_tmp_ac42.yac404 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac405 <> 0 THEN   --5月补差
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'05'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac405,
                                    case WHEN rec_tmp_ac42.yac405 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac406 <> 0 THEN    --6月补差
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'06'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac406,
                                    case WHEN rec_tmp_ac42.yac406 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac407 <> 0 THEN   --7月补差
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'07'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac407,
                                    case WHEN rec_tmp_ac42.yac407 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac408 <> 0 THEN    --8月补差
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'08'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac408,
                                    case WHEN rec_tmp_ac42.yac408 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac409 <> 0 THEN   --9月补差
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'09'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac409,
                                    case WHEN rec_tmp_ac42.yac409 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac410 <> 0 THEN    --10月补差
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'10'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac410,
                                    case WHEN rec_tmp_ac42.yac410 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac411 <> 0 THEN   --11月补差
                 prc_insertAC08A1(prm_aab001  ,
                                    var_aac001  ,
                                    prm_aae001||'11'  ,
                                    num_aae002,
                                    rec_tmp_ac42.yac411,
                                    case WHEN rec_tmp_ac42.yac411 < 0 THEN var_yae518_tk ELSE var_yae518 END   ,
                                    prm_aae076,
                                    prm_aae140,
                                    prm_aae011  ,
                                    prm_yab139  ,
                                    prm_AppCode ,
                                    prm_ErrorMsg);
           END IF;
           IF rec_tmp_ac42.yac412 <> 0 THEN   --12月补差
                 prc_insertAC08A1 (prm_aab001 ,
                                   var_aac001 ,
                                   prm_aae001||'12' ,
                                   num_aae002 ,
                                   rec_tmp_ac42.yac412,
                                   case WHEN rec_tmp_ac42.yac412 < 0 THEN var_yae518_tk ELSE var_yae518 END  ,
                                   prm_aae076 ,
                                   prm_aae140 ,
                                   prm_aae011 ,
                                   prm_yab139 ,
                                   prm_AppCode,
                                   prm_ErrorMsg );
          END IF;
      END LOOP;

     sum_new_yab158 := 0;
      new_yab158     := 0;
      sum_yab158     := 0;
     FOR rec_aae041 IN cur_aae041 LOOP
           num_aae041 := rec_aae041.aae041;
           num_aae042 := rec_aae041.aae042;

           sum_new_yab158 := 0;
           new_yab158     := 0;
           sum_yab158     := 0;
           sum_new_aab213 := 0;
           new_aab213     := 0;
           FOR rec_aae180_06 IN cur_aae180 LOOP
                var_aaa040 := rec_aae180_06.aaa040;
                num_ala080_old := rec_aae180_06.ala080;
                sum_aae180 := rec_aae180_06.aae180;
                sum_aab213 := rec_aae180_06.aab213;
                num_aaa041 := rec_aae180_06.aaa041;
                num_yaa017 := rec_aae180_06.yaa017;
                num_aaa042 := rec_aae180_06.aaa042;
                num_aaa043 := rec_aae180_06.aaa043;
                sum_yab158 := rec_aae180_06.yab158;

                --重新计算应缴信息
                --单位部分
               sum_new_aab213:=round(rec_aae180_06.aae180_1*num_aaa042*(1+num_ala080_old),2);
               new_aab213 := sum_new_aab213 - sum_aab213;
               --个人部分
              sum_new_yab158 := ROUND(sum_aae180*num_yaa017,2);
              new_yab158 := sum_new_yab158-sum_yab158;
                 --更新个人明细信息  如果存在误差则进行更新 更新原则为取最大缴费基数中的一个进行更新
               UPDATE xasi2.AC08A1 a
                 SET aab213=aab213+new_aab213,
                     yab158=yab158+new_yab158
               WHERE yae518 = var_yae518  --核定流水号
                 AND aae140 = prm_aae140
                 AND YAC505 = DECODE(aae140,xasi2.pkg_comm.aae140_SYE,xasi2.pkg_comm.YAC505_SYEPT,yac505)
                 AND yae202 =(SELECT MAX(yae202)
                                FROM xasi2.AC08A1
                               WHERE yae518 = a.yae518
                                 AND aae140 = a.aae140
                                 AND aae002 >= num_aae041
                                 AND aae002 <= num_aae042
                                 AND aae180 = (SELECT MAX(aae180)
                                                 FROM xasi2.AC08A1
                                                WHERE yae518 = var_yae518
                                                  AND aae002 >= num_aae041
                                                  AND aae002 <= num_aae042
                                               )
                                );
           END LOOP;

       END LOOP;


    --获取单位基本信息
      xasi2.pkg_p_checkEmployerFeeCo.prc_p_checkEmployerBase
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
            prm_ErrorMsg ); --执行结果
      IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK  THEN
         RETURN;
      END IF;
    --生成单位缴费信息
     FOR rec_ac08a1_sk IN  cur_ac08a1_sk LOOP
         /*生成核定汇总应收信息表*/
         xasi2.pkg_p_checkEmployerFeeCo.prc_p_insertab08(
                             var_yae518, --核定流水号
                             prm_aab001, --单位编号
                             NULL      , --个人编号
                             rec_ac08a1_sk.aae140, --险种类型
                             num_aae002, --做帐期号
                             rec_ac08a1_sk.aae041, --开始期号
                             rec_ac08a1_sk.aae042, --终止期号
                             rec_ac08a1_sk.yab538, --缴费人员状态
                             rec_ac08a1_sk.yae010,--费用来源
                             xasi2.pkg_Comm.YAE517_H12, --核定类型
                             var_yab222, --做帐批次号
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
                             SYSDATE,   --经办时间
                             prm_yab139, --参保所属分中心
                             prm_yab139, --社保经办机构
                             NULL,
                             NULL,
                             prm_AppCode,         --执行代码
                             prm_ErrorMsg );        --执行结果
         IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
            prm_ErrorMsg := prm_ErrorMsg||'1';
         END IF;
      END LOOP;
    FOR rec_ac08a1_tk IN  cur_ac08a1_tk LOOP
         /*生成核定汇总应收信息表*/
         xasi2.pkg_p_checkEmployerFeeCo.prc_p_insertab08(
                             var_yae518_tk, --核定流水号
                             prm_aab001, --单位编号
                             NULL      , --个人编号
                             rec_ac08a1_tk.aae140, --险种类型
                             num_aae002, --做帐期号
                             rec_ac08a1_tk.aae041, --开始期号
                             rec_ac08a1_tk.aae042, --终止期号
                             rec_ac08a1_tk.yab538, --缴费人员状态
                             rec_ac08a1_tk.yae010,--费用来源
                             xasi2.pkg_Comm.YAE517_H17, --核定类型
                             var_yab222, --做帐批次号
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
                             CASE WHEN rec_ac08a1_tk.yae010 = xasi2.pkg_Comm.YAE010_CZ THEN 0
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
                             SYSDATE,   --经办时间
                             prm_yab139, --参保所属分中心
                             prm_yab139, --社保经办机构
                             NULL,
                             NULL,
                             prm_AppCode,         --执行代码
                             prm_ErrorMsg );        --执行结果
         IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
            prm_ErrorMsg := prm_ErrorMsg||'2';
            RETURN;
         END IF;
      END LOOP;


  --更新费用来源
      BEGIN
        SELECT decode(yae010_110,'3','1','1'),
               decode(yae010_120,'3','1','1'),
               decode(yae010_210,'3','1','1'),
               decode(yae010_310,'3','1','1'),
               decode(yae010_410,'3','1','1'),
               decode(yae010_510,'3','1','1')
          INTO var_yae010_110,
               var_yae010_120,
               var_yae010_210,
               var_yae010_310,
               var_yae010_410,
               var_yae010_510
          FROM wsjb.irab03
         WHERE aab001 = prm_aab001;
       EXCEPTION
            WHEN OTHERS THEN
                 var_yae010_110 := xasi2.pkg_comm.YAE010_zc;
                 var_yae010_210 := xasi2.pkg_comm.YAE010_zc;
                 var_yae010_310 := xasi2.pkg_comm.YAE010_zc;
                 var_yae010_410 := xasi2.pkg_comm.YAE010_zc;
                 var_yae010_510 := xasi2.pkg_comm.YAE010_zc;
      END;
      FOR rec_ab08 IN cur_ab08 LOOP
          --失业
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_SYE THEN
             var_yae010 := var_yae010_210;
          END IF;
          --医疗
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_JBYL THEN
             var_yae010 := var_yae010_310;
          END IF;
          --工伤
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_GS THEN
             var_yae010 := var_yae010_410;
          END IF;
          --生育
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_SYU THEN
             var_yae010 := var_yae010_510;
          END IF;
         /* --机关养老
          IF rec_ab08.aae140 = xasi2.pkg_comm.AAE140_JGYL THEN
             var_yae010 := var_yae010_120;
          END IF;*/
          --更新费用来源
          UPDATE xasi2.AB08
             SET yae010 = var_yae010
           WHERE yae518 = rec_ab08.yae518
             AND yab222 = var_yab222
             AND aae140 = rec_ab08.aae140;

          --更新人员明细
          UPDATE xasi2.AC08A1
             SET yae010 = var_yae010
           WHERE yae518 = rec_ab08.yae518
             AND aae140 = rec_ab08.aae140;
      END LOOP;
      FOR rec_ab08a8 IN cur_ab08a8 LOOP
          --失业
          IF rec_ab08a8.aae140 = xasi2.pkg_comm.AAE140_SYE THEN
             var_yae010 := var_yae010_210;
          END IF;
          --医疗
          IF rec_ab08a8.aae140 = xasi2.pkg_comm.AAE140_JBYL THEN
             var_yae010 := var_yae010_310;
          END IF;
          --工伤
          IF rec_ab08a8.aae140 = xasi2.pkg_comm.AAE140_GS THEN
             var_yae010 := var_yae010_410;
          END IF;
          --生育
          IF rec_ab08a8.aae140 = xasi2.pkg_comm.AAE140_SYU THEN
             var_yae010 := var_yae010_510;
          END IF;

          --更新费用来源
          UPDATE xasi2.AB08A8
             SET yae010 = var_yae010
           WHERE yae518 = rec_ab08a8.yae518
             AND yab222 = var_yab222
             AND aae140 = rec_ab08a8.aae140;

          --更新人员明细
          UPDATE xasi2.ac08
             SET yae010 = var_yae010
           WHERE yae518 = rec_ab08a8.yae518
             AND aae140 = rec_ab08a8.aae140;
      END LOOP;
      --地税的发征集
      var_yae010 := xasi2.pkg_comm.YAE010_zc;
      --YAE517 = H12
          --插入临时表，
          DELETE FROM xasi2.Tmp_yae518;
          INSERT INTO xasi2.tmp_yae518
                                         (yae518,   -- 核定流水号
                                          aae140,   -- 险种类型
                                          aab001,
                                          yab538,
                                          yae010,
                                          aae041,
                                          yab139)
                                   SELECT a.yae518,
                                          a.aae140,
                                          a.aab001,
                                          a.yab538, --缴费人员状态
                                          a.YAE010, --费用来源
                                          a.aae041,
                                          prm_yab139
                                     FROM xasi2.AB08 a,xasi2.ab02 b
                                    WHERE a.aab001=b.aab001
                                      AND a.aae140=b.aae140
                                      AND a.aab001 = prm_aab001
                                      AND (aae076 IS NULL OR aae076 = '0')
                                      AND a.aae140 = prm_aae140
                                      AND yae517 = xasi2.pkg_Comm.YAE517_H12      --核定类型
                                      AND a.aae003 = num_aae002
                                      AND yab222 = var_yab222
                                      AND b.aab033='04';
        SELECT COUNT(1)
          INTO num_count
          FROM xasi2.tmp_yae518;
        IF num_count > 0 THEN
           var_aae076 := xasi2.pkg_comm.fun_GetSequence(NULL,'aae076');
           --调用征集过程。生成单据信息和财务接口数据
           xasi2.pkg_p_fundCollection.prc_crtFinaPlan  (
                                                          'P01'    ,      --收付种类
                                                          '18',      --收付结算方式
                                                          prm_aae011    ,      --经办人员
                                                          prm_yab139    ,      --社保经办机构
                                                          var_aae076    ,      --计划流水号
                                                          prm_AppCode   ,      --执行代码
                                                          prm_ErrorMsg    );     --执行结果
           IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
              RETURN;
           END IF;
        END IF;
     --YAE517 = H17
          --插入临时表，
          DELETE FROM xasi2.Tmp_yae518;
          INSERT INTO xasi2.tmp_yae518
                                         (yae518,   -- 核定流水号
                                          aae140,   -- 险种类型
                                          aab001,
                                          yab538,
                                          yae010,
                                          aae041,
                                          yab139)
                                   SELECT a.yae518,
                                          a.aae140,
                                          a.aab001,
                                          a.yab538, --缴费人员状态
                                          a.YAE010, --费用来源
                                          a.aae041,
                                          prm_yab139
                                     FROM xasi2.AB08 a,xasi2.ab02 b
                                    WHERE a.aab001=b.aab001
                                      AND a.aae140=b.aae140
                                      AND a.aab001 = prm_aab001
                                      AND (aae076 IS NULL OR aae076 = '0')
                                      AND a.aae140 = prm_aae140
                                      AND yae517 = xasi2.pkg_Comm.YAE517_H17      --核定类型
                                      AND a.aae003 = num_aae002
                                      AND yab222 = var_yab222
                                      AND b.aab033='04';
        SELECT COUNT(1)
          INTO num_count
          FROM xasi2.tmp_yae518;
        IF num_count > 0 THEN
           var_aae076 := xasi2.pkg_comm.fun_GetSequence(NULL,'aae076');
           --调用征集过程。生成单据信息和财务接口数据
           xasi2.pkg_p_fundCollection.prc_crtFinaPlan  (
                                                          'P19'    ,      --收付种类
                                                          '30',      --收付结算方式
                                                          prm_aae011    ,      --经办人员
                                                          prm_yab139    ,      --社保经办机构
                                                          var_aae076    ,      --计划流水号
                                                          prm_AppCode   ,      --执行代码
                                                          prm_ErrorMsg    );     --执行结果
           IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
              RETURN;
           END IF;
        END IF;
     --自筹的发征集
     --YAE517 = H12
      var_aae076 := xasi2.pkg_comm.fun_GetSequence(NULL,'aae076');
      --插入临时表，
      DELETE FROM xasi2.Tmp_yae518;
      INSERT INTO xasi2.tmp_yae518
                                     (yae518,   -- 核定流水号
                                      aae140,   -- 险种类型
                                      aab001,
                                      yab538,
                                      yae010,
                                      aae041,
                                      yab139)
                               SELECT a.yae518,
                                      a.aae140,
                                      a.aab001,
                                      a.yab538, --缴费人员状态
                                      a.YAE010, --费用来源
                                      a.aae041,
                                      prm_yab139
                                 FROM xasi2.AB08 a,xasi2.ab02 b
                                WHERE a.aab001=b.aab001
                                  AND a.aae140=b.aae140
                                  AND a.aab001 = prm_aab001
                                  AND (aae076 IS NULL OR aae076 = '0')
                                  AND yae517 = xasi2.pkg_Comm.YAE517_H12      --核定类型
                                  AND a.aae003 = num_aae002
                                  AND yab222 = var_yab222
                                  AND b.aab033='01';
    SELECT COUNT(1)
      INTO num_count
      FROM xasi2.tmp_yae518;
    IF num_count > 0 THEN
       --调用征集过程。生成单据信息和财务接口数据
       xasi2.pkg_p_fundCollection.prc_crtFinaPlan  (
                                                        'P01'    ,      --收付种类
                                                        xasi2.pkg_comm.YAD052_GTSK,      --收付结算方式
                                                        prm_aae011    ,      --经办人员
                                                        prm_yab139    ,      --社保经办机构
                                                        var_aae076    ,      --计划流水号
                                                        prm_AppCode   ,      --执行代码
                                                        prm_ErrorMsg    );     --执行结果
       IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
          RETURN;
       END IF;
    END IF;
    --YAE517 = H17
      var_aae076 := xasi2.pkg_comm.fun_GetSequence(NULL,'aae076');
      --插入临时表，
      DELETE FROM xasi2.Tmp_yae518;
      INSERT INTO xasi2.tmp_yae518
                                     (yae518,   -- 核定流水号
                                      aae140,   -- 险种类型
                                      aab001,
                                      yab538,
                                      yae010,
                                      aae041,
                                      yab139)
                               SELECT a.yae518,
                                      a.aae140,
                                      a.aab001,
                                      a.yab538, --缴费人员状态
                                      a.YAE010, --费用来源
                                      a.aae041,
                                      prm_yab139
                                 FROM xasi2.AB08 a,xasi2.ab02 b
                                WHERE a.aab001=b.aab001
                                  AND a.aae140=b.aae140
                                  AND a.aab001 = prm_aab001
                                  AND (aae076 IS NULL OR aae076 = '0')
                                  AND yae517 = xasi2.pkg_Comm.YAE517_H17      --核定类型
                                  AND a.aae003 = num_aae002
                                  AND yab222 = var_yab222
                                  AND b.aab033='01';
    SELECT COUNT(1)
      INTO num_count
      FROM xasi2.tmp_yae518;
    IF num_count > 0 THEN
       --调用征集过程。生成单据信息和财务接口数据
       xasi2.pkg_p_fundCollection.prc_crtFinaPlan  (
                                                        'P19'    ,      --收付种类
                                                        xasi2.pkg_comm.YAD052_TZ,      --收付结算方式
                                                        prm_aae011    ,      --经办人员
                                                        prm_yab139    ,      --社保经办机构
                                                        var_aae076    ,      --计划流水号
                                                        prm_AppCode   ,      --执行代码
                                                        prm_ErrorMsg    );     --执行结果
       IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
          RETURN;
       END IF;
    END IF;
   EXCEPTION
        WHEN OTHERS THEN
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
             RETURN;
END prc_YearSalaryBCBy03;
PROCEDURE prc_insertAC08A1  (prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                             prm_aac001       IN     xasi2.ac01.aac001%TYPE,
                             prm_aae002       IN     NUMBER            ,--年审年度
                             prm_aae003       IN     NUMBER,
                             prm_aac040       IN     xasi2.ac02.aac040%TYPE,
                             prm_yae518       IN     xasi2.ac08a1.yae518%TYPE,
                             prm_aae076       IN     xasi2.ab08.aae076%TYPE,
                             prm_aae140       IN     VARCHAR2,
                             prm_aae011       IN     irad31.aae011%TYPE,--经办人
                             prm_yab139       IN     VARCHAR2          ,--参保所属分中心
                             prm_AppCode      OUT    VARCHAR2          ,
                             prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      num_count     NUMBER;
      v_msg        VARCHAR2(300);
      var_yac505   irac01.yac505%TYPE;
      var_aaa040   irab01.aaa040%TYPE;
      var_yac503   irac01.yac503%TYPE;
      var_yae010   irab08.yae010%TYPE;
      var_yaa330   irac08.yaa333%TYPE;
      num_aaa041   xasi2.ac08.aaa041%type;
      num_yaa017   xasi2.ac08.aaa041%type;
      num_aaa042   xasi2.ac08.aaa041%type;
      num_aaa043   xasi2.ac08.aaa041%type;
      num_ala080   xasi2.ac08.aaa041%type;
      num_age      xasi2.ac08.yac176%type;
      num_yac176   xasi2.ac08.yac176%type;
      var_akc021   irac01.akc021%TYPE;
      var_ykc120   irac08.ykc120%TYPE;
      var_yac168   irac08.yac168%TYPE;
      var_yaa310   irac08.yaa310%TYPE;
      var_aae114   irac08a1.aae114%TYPE;
   BEGIN

      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      DELETE xasi2.tmp_grbs02;


      --获取之前的缴费信息
      SELECT MAX(yac505),
             MAX(aaa040),
             MAX(yac503),
             MAX(yae010),
             MAX(yaa330),
             MAX(aaa041),
             MAX(yaa017),
             MAX(aaa042),
             MAX(aaa043),
             MAX(ala080),
             MAX(akc023),
             MAX(yac176),
             MAX(akc021),
             MAX(ykc120),
             MAX(yac168),
             MAX(yaa310),
             MAX(aae114)
       INTO  var_yac505,
             var_aaa040,
             var_yac503,
             var_yae010,
             var_yaa330,
             num_aaa041,
             num_yaa017,
             num_aaa042,
             num_aaa043,
             num_ala080,
             num_age,
             num_yac176,
             var_akc021,
             var_ykc120,
             var_yac168,
             var_yaa310,
             var_aae114
       FROM (
      SELECT yac505,
             aaa040,
             yac503,
             yae010,
             yaa330,
             aaa041,
             yaa017,
             aaa042,
             aaa043,
             ala080,
             akc023,
             yac176,
             akc021,
             ykc120,
             yac168,
             yaa310,
             aae114
        FROM xasi2.ac08 a
       WHERE aac001 = prm_aac001
         AND aab001 = prm_aab001
         AND aae140 = prm_aae140
         AND aae002 = prm_aae002
         AND aae143 IN (xasi2.pkg_comm.AAE143_JSBC,
                        xasi2.pkg_comm.AAE143_BS,
                        xasi2.pkg_comm.AAE143_ZCJF)
      UNION
      SELECT yac505,
             aaa040,
             yac503,
             yae010,
             yaa330,
             aaa041,
             yaa017,
             aaa042,
             aaa043,
             ala080,
             akc023,
             yac176,
             akc021,
             ykc120,
             yac168,
             yaa310,
             '1'
        FROM xasi2.ac08a1 a
       WHERE aac001 = prm_aac001
         AND aab001 = prm_aab001
         AND aae140 = prm_aae140
         AND aae002 = prm_aae002
         AND aae143 IN (xasi2.pkg_comm.AAE143_JSBC,
                        xasi2.pkg_comm.AAE143_BS,
                        xasi2.pkg_comm.AAE143_ZCJF)

       );
      INSERT INTO xasi2.tmp_grbs02(aac001,  --个人编码
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
                           prm_aae002,
                           var_yac505,           --参保缴费人员类别
                           var_aaa040,           --缴费比例类别
                           prm_aae140,           --险种类型
                           xasi2.pkg_comm.aae143_JSBC,           --缴费类别
                           var_yac503,           --工资类型
                           prm_aac040,        --缴费工资
                           prm_aac040,           --缴费基数
                           DECODE(prm_aae140,'03',prm_aac040,0),           --划帐户基数
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
                           DECODE(var_akc021,'21','2','1'),           --人员状态
                           var_yac168,           --农民工标志
                           var_yaa310,           --比例类型
                           var_aae114,           --缴费标志
                           xasi2.pkg_comm.AAE100_YX,   --有效标志 ：有效
                           NULL );
         --调用生成AC08a1
         xasi2.pkg_p_interrupt.prc_p_DetailInterrupt(
                                   NULL,
                                   NULL,
                                   prm_yae518  ,  --核定流水号
                                   prm_aab001  ,  --单位编号
                                   prm_aac001  ,  --个人编号
                                   prm_aae003  ,  --做帐期号
                                   prm_aae140  ,  --险种类型
                                   prm_aae011  ,  --经办人
                                   sysdate  ,  --经办时间
                                   prm_yab139  ,  --经办机构
                                   prm_yab139  ,  --参保人员所在分钟心
                                   prm_AppCode ,  --错误代码
                                   prm_ErrorMsg  ); --错误内容
            IF prm_AppCode <> xasi2.pkg_comm.gn_def_OK THEN
               RETURN;
            END IF;
   EXCEPTION
        WHEN OTHERS THEN
        /*关闭打开的游标*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
             RETURN;
END prc_insertAC08A1;

--开始年审补差（新）
PROCEDURE prc_YearSalaryBCBegin(prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                               prm_aae001       IN     NUMBER            ,--年审年度
                               prm_type         IN     VARCHAR2,  --1为社平公布前 2为社平公布后
                               prm_aae011       IN     irad31.aae011%TYPE,--经办人
                               prm_yab139       IN     VARCHAR2          ,--参保所属分中心
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          )
    IS
      v_yab222  irab08.yab222%TYPE;
      v_aae076  irab08.aae076%TYPE;
      v_aab001  irab08.aab001%TYPE;
      n_aae002  NUMBER;
      num_yae097 NUMBER;
      num_count NUMBER;
          cursor cur_ab02 IS
            SELECT    DECODE(AAE110, '1', '01', '') AS AAE140
              FROM wsjb.IRAB01
             WHERE IAB001 = AAB001
              AND AAB001 = v_aab001
            UNION
              SELECT aae140
                FROM xasi2.ab02
                WHERE aab001= v_aab001
                  AND aab051='1';
      BEGIN
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '单位编号不能为空' ;
         RETURN;
      END IF;
      IF prm_aae001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '年审年度不能为空' ;
         RETURN;
      END IF;
      IF prm_aae011 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '经办人不能为空' ;
         RETURN;
      END IF;
      IF prm_yab139 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '参保所属分中心不能为空' ;
         RETURN;
      END IF;
       IF prm_type IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '补差类型不能为空' ;
         RETURN;
      END IF;
        SELECT COUNT(1)
          INTO num_count
          FROM  wsjb.irad51
         WHERE aab001 = prm_aab001
           AND aae001 = prm_aae001
           AND iaa002 = '2'
           AND iaa011 = 'A05';
        IF num_count = 0 THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '单位的年审信息还未通过审核，不能补差！' ;
         RETURN;
        END IF;
        SELECT TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(MAX(yae097),'yyyymm'),1),'yyyymm'))
          INTO num_yae097
          FROM (SELECT MAX(aae003) AS yae097 FROM wsjb.irab08  WHERE yae517='H01' AND aab001= prm_aab001
                UNION
                SELECT MAX(yae097) AS yae097 FROM xasi2.ab02 WHERE aab051 = '1' AND aab001 = prm_aab001) ;
        v_yab222 := xasi2.PKG_comm.fun_GetSequence(NULL,'yab222');
        v_aab001 := prm_aab001;
        FOR rec_ab02 IN cur_ab02 LOOP
        v_aae076 := xasi2.PKG_comm.fun_GetSequence(NULL,'aae076');
        IF rec_ab02.aae140 = '01' THEN

          prc_YearSalaryBCByYL(prm_aab001     ,--单位编号  必填
                               prm_aae001     ,--年审年度
                               n_aae002     ,
                               v_yab222     ,
                               v_aae076     ,
                               prm_type       ,
                               prm_aae011     ,--经办人
                               prm_yab139     ,--参保所属分中心
                               prm_AppCode    ,
                               prm_ErrorMsg    );
         ELSE
          prc_YearSalaryBCBy03(prm_aab001     ,
                               prm_aae001     ,
                               n_aae002     ,
                               v_yab222       ,
                               v_aae076     ,
                               prm_type       ,
                               rec_ab02.aae140,
                               prm_aae011     ,
                               prm_yab139     ,
                               prm_AppCode    ,
                               prm_ErrorMsg   );
              END IF;
              END LOOP;
         UPDATE  wsjb.irad51
            SET iaa006 = '1',
                yae092 = prm_aae011,
                aae036 = SYSDATE,
                aae003 = num_yae097
          WHERE aab001 = prm_aab001
            AND aae001 = prm_aae001
            AND iaa011 = 'A05';
         EXCEPTION
        WHEN OTHERS THEN
        /*关闭打开的游标*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
             RETURN;
END prc_YearSalaryBCBegin;


--年审数据清除
PROCEDURE prc_YearSalaryClear (prm_aab001       IN     irab01.aab001%TYPE,--单位编号  必填
                               prm_aae001       IN     NUMBER            ,--年审年度
                               prm_aae011       IN     irad31.aae011%TYPE,--经办人
                               prm_flag         OUT     VARCHAR2,     --成功标志 0成功 1 失败
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          )
    IS
     num_count NUMBER(6);
      var_iaz004 irad02.iaz004%TYPE;
      var_aae013 irad02.aae013%TYPE;
      BEGIN
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      IF prm_aab001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '单位编号不能为空' ;
         RETURN;
      END IF;
      IF prm_aae001 IS NULL THEN
         prm_AppCode  :=  gn_def_ERR;
         prm_ErrorMsg := '年审年度不能为空' ;
         RETURN;
      END IF;
      prm_flag := '0';

      SELECT count(1)
        INTO num_count
        FROM  wsjb.irad51
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND iaa011 = 'A05';

      IF num_count > 0 THEN
         prm_flag :='1';
         prm_ErrorMsg := '年度基数申报已经提交，不能清除！';
      END IF;

      SELECT count(1)
        INTO num_count
        FROM wsjb.irad53
       WHERE aab001 = prm_aab001
         AND aae001 = prm_aae001
         AND iaa011 = 'A05';

      IF num_count > 0 THEN
         prm_flag :='1';
         prm_ErrorMsg := '已在社保中心进行审核，但尚未通过，不能进行清空填报数据操作！';
         RETURN;
      END IF;
      SELECT TO_CHAR(seq_iaz004.nextval)
        INTO var_iaz004
        FROM dual;
      --备份AB05A1数据
         INSERT INTO  xasi2.AC01K9 SELECT * FROM  xasi2.ac01k8 WHERE aab001 = prm_aab001 AND aae001 = prm_aae001;

         DELETE xasi2.ac01k8 WHERE aab001 = prm_aab001 AND aae001 = prm_aae001;
         UPDATE xasi2.AC01K9
            SET iaz004 = var_iaz004
          WHERE aab001 = prm_aab001
            AND aae001 = prm_aae001;


         INSERT INTO wsjb.irad51a3
              SELECT var_iaz004,
                     'A05',
                     prm_aab001,
                     prm_aae001,
                     prm_aae011,
                     SYSDATE
                FROM dual;

         EXCEPTION
        WHEN OTHERS THEN
        /*关闭打开的游标*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
             RETURN;
END prc_YearSalaryClear;

PROCEDURE prc_YearApplyJSProportions (prm_aab001       IN     xasi2.ab01.aab001%TYPE,--单位编号
                               prm_aae001       IN     NUMBER            ,--年审年度
                               prm_aae011       IN     irad31.aae011%TYPE, --经办人
                               prm_AppCode      OUT    VARCHAR2          ,
                               prm_ErrorMsg     OUT    VARCHAR2          )
IS
  num_count NUMBER(6);
  v_minaae041 NUMBER(6);
  v_aab121_old  xasi2.ab08.aab121%type;
  v_aab121_new  xasi2.ab08.aab121%type;
  v_proportions NUMBER(6,2);
  v_proportions_constant NUMBER(6);
  v_proportions_msg  irad54.aae013%type;

  cursor ab02_cur is select aae140 from xasi2.ab02 where  aae140 !='07' and aab051 = '1'  and aab001 = prm_aab001 ;

BEGIN

/*初始化变量*/
      prm_AppCode  := gn_def_OK;
      prm_ErrorMsg := '';
      v_proportions_constant := -1;
      v_proportions_msg := '';

        -- 单位是否有4险
        select count(1)
          into num_count
          from xasi2.ab02
         where aab051 = '1'
           and aae140 !='07'
           and aab001 = prm_aab001;
        -- 有四险取当年四险最小核费期号
        if num_count >0 then
          select min(aae041)
            into v_minaae041
            from (select aae041
                    from xasi2.ab08
                   where yae517 = 'H01'
                     and aab001 = prm_aab001
                     and aae041 > (prm_aae001 - 1) || 12
                  union
                  select aae041
                    from xasi2.ab08a8
                   where yae517 = 'H01'
                     and aab001 = prm_aab001
                     and aae041 > (prm_aae001 - 1) || 12);
        else --没有四险就是单养老单位取当年养老最小核费期号
          select min(aae041)
            into v_minaae041
            from wsjb.irab08
           where yae517 = 'H01'
             and aab001 = prm_aab001
             and aae041 > (prm_aae001 - 1) || 12;
        end if;

        -- 按险种获取当年最早一次核费的单位基数 ac01k8 中新基数对比
        -- 只要有一个险种基数补差降低大于35%的 就写入一条irad54记录
        if num_count>0 then
          --非单养老单位处理养老险种
          select aab121
            into v_aab121_old
            from wsjb.irab08
           where yae517 = 'H01'
             and aae140 = '01'
             and aab001 = prm_aab001
             and aae041 = v_minaae041;
            select sum(yac004)
             into v_aab121_new
             from xasi2.ac01k8
            where aab001 = prm_aab001
              and aae001 = prm_aae001
              and aae110 is not null;
             --计算比例
             select (trunc((v_aab121_new / v_aab121_old), 4) - 1) * 100
               into v_proportions
               from DUAL;
              if v_proportions <= v_proportions_constant then
                 v_proportions_msg:='01险种'||v_minaae041||'基数降低比例过高';
                 GOTO leb_next;
              end if;
          --非单养老单位处理 4险
          for ab02_rec in ab02_cur loop
            select aab121
              into v_aab121_old
              from (select aab121
                      from xasi2.ab08
                     where yae517 = 'H01'
                       and aae140 = ab02_rec.aae140
                       and aab001 = prm_aab001
                       and aae041 = v_minaae041
                    union
                    select aab121
                      from xasi2.ab08a8
                     where yae517 = 'H01'
                       and aae140 = ab02_rec.aae140
                       and aab001 = prm_aab001
                       and aae041 = v_minaae041);
            --失业19年后使用省社平
            if ab02_rec.aae140 = '02' and prm_aae001 > 2018 then
               select sum(yac004)
                 into v_aab121_new
                 from xasi2.ac01k8
                where aab001 = prm_aab001
                  and aae210 = '2';
            else
               select sum(yaa333)
                 into v_aab121_new
                 from xasi2.ac01k8
                where aab001 = prm_aab001
                  and aae210 = '2';
            end if;
            --工伤19年后使用省社平
            if ab02_rec.aae140 = '04' and prm_aae001 > 2018 then
               select sum(yac004)
                 into v_aab121_new
                 from xasi2.ac01k8
                where aab001 = prm_aab001
                  and aae410 = '2';
            else
               select sum(yaa333)
                 into v_aab121_new
                 from xasi2.ac01k8
                where aab001 = prm_aab001
                  and aae410 = '2';
            end if;
            --医疗使用市社平
            if ab02_rec.aae140 = '03' then
               select sum(yaa333)
                into v_aab121_new
                from xasi2.ac01k8
               where aab001 = prm_aab001
                 and aae310 = '2';
            end if;
            --生育使用市社平
            if ab02_rec.aae140 = '05' then
               select sum(yaa333)
                into v_aab121_new
                from xasi2.ac01k8
               where aab001 = prm_aab001
                 and aae510 = '2';
            end if;
            --计算比例
            select (trunc((v_aab121_new / v_aab121_old), 4) - 1) * 100
              into v_proportions
              from DUAL;
              if v_proportions <= v_proportions_constant then
                 v_proportions_msg:=ab02_rec.aae140||'险种'||v_minaae041||'基数降低比例过高';
                 GOTO leb_next;
              end if;
          end loop;
        else    --单养老
            select aab121
               into v_aab121_old
               from wsjb.irab08
              where yae517 = 'H01'
                and aae140 = '01'
                and aab001 = prm_aab001
                and aae041 = v_minaae041;
            select sum(yac004)
               into v_aab121_new
               from xasi2.ac01k8
              where aab001 = prm_aab001
                and aae001 = prm_aae001
                and aae110 is not null;
             --计算比例
             select (trunc((v_aab121_new / v_aab121_old), 4) - 1) * 100
              into v_proportions
              from DUAL;
              if v_proportions <= v_proportions_constant then
                 v_proportions_msg:='01险种'||v_minaae041||'基数降低比例过高';
              end if;
          end if;

         <<leb_next>>

         if v_proportions_msg is not null then
         insert into wsjb.irad54
            (AAB001,
             IAA011,
             AEE011,
             AAE035,
             AAE001,
             AAE013)
          values
            (prm_aab001,
             'A05-1', -- A05-1 是年限基数降低写到irad54的 用这个标记撤销年审的时候删除这条
             prm_aae011,
             sysdate,
             prm_aae001,
             v_proportions_msg);
         end if;

        EXCEPTION
        WHEN OTHERS THEN
        /*关闭打开的游标*/
             prm_AppCode  :=  gn_def_ERR;
             prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
             RETURN;
END prc_YearApplyJSProportions;

end PKG_YearApply;
/
