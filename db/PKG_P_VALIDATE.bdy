CREATE OR REPLACE PACKAGE BODY "PKG_P_VALIDATE"
/*****************************************************************************/
/*  程序包名 ：pkg_P_Validate                                                */
/*  业务环节 ：单位权限验证                                                  */
/*  功能描述 ：                                                              */
/*                                                                           */
/*  作    者 ：四川久远银海软件股份有限公司                                  */
/*  作成日期 ：2015-11-11           版本编号 ：Ver 1.0.0                     */
/*---------------------------------------------------------------------------*/
/*  修改记录 ：                                                              */
/*****************************************************************************/
AS

   PRE_ERRCODE CONSTANT VARCHAR2(45) := 'prc_p_ValidatePrivilege'; --本包的错误编号前缀

  /*--------------------------------------------------------------------------
   || 业务环节 ：单位权限验证
   || 过程名称 ：prc_P_ValidateAab001Privilege
   || 功能描述 ：开户未通过，单位信息异常，未批准月报，单位权限控制，单位做账期号不一致时无法操作单位
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：cora          完成日期 ：2015-11-11
   ||------------------------------------------------------------------------*/
   PROCEDURE prc_P_ValidateAab001Privilege(
      prm_aab001          IN            VARCHAR2,     --单位编号
      prm_msg             OUT           VARCHAR2,     --错误信息
      prm_sign            OUT           VARCHAR2,     --错误标志
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2)     --出错信息
   IS
       /*字段定义*/
      var_iaa002     VARCHAR2(30); -- 审核标志
      var_yab010     irab01.yab010%TYPE;  -- 未批准月报
      num_count1     NUMBER(6);    --  aab001是否存在多条信息
      num_count2     NUMBER(6);    --  irab01 单位是否存在多条信息
      num_count3     NUMBER(6);    --  irab01 判断单位最大做账期号是否一致
      /*游标声明*/


   BEGIN
       /*初始化变量*/
      prm_AppCode  := GN_DEF_OK;
      prm_ErrorMsg := '';
      prm_msg :='提示信息：';
      prm_sign :='0';

      --校验参数
      IF prm_aab001 IS NULL  THEN

         prm_msg :=  prm_msg||'传入参数有误，请核实。。。';
         prm_sign := '1';
         GOTO label_ERROR;
       END IF;

      -- 存在多条单位信息
      SELECT COUNT(1)
        INTO num_count1
        FROM wsjb.irab01
       WHERE IAB001 = AAB001
         AND AAB001 = prm_aab001;

       IF num_count1 <> 1 THEN

           prm_msg :=  prm_msg||'存在多条单位信息，请参保单位联系社保基金管理中心处理！';
           prm_sign := '1';
           GOTO label_ERROR;
        END IF;

       --  若单位审核标志若不等于2 则无法操作该单位
       SELECT IAA002
         INTO var_iaa002
         FROM wsjb.irab01
        WHERE IAB001 = AAB001
          AND AAB001 = prm_aab001;

        IF var_iaa002 != '2' THEN
           prm_msg :=  prm_msg||'单位处于未审核通过状态,则无法操作该单位！！。。。';
           prm_sign := '1';
           GOTO label_ERROR;
        END IF;

       --  判断是否未批准月报
       SELECT YAB010
         INTO var_yab010
         FROM wsjb.irab01
        WHERE AAB001= prm_aab001
          AND iab001 = AAB001;

        IF var_yab010 != '1' THEN
           prm_msg :=  prm_msg||'该单位还未批准月报！请单位人员携带相关资料到基金管理中心复审！';
           prm_sign := '1';
           GOTO label_ERROR;
        END IF;

       --   判断单位做账期号是否不一致
        SELECT COUNT(DISTINCT yae097) INTO num_count2
          FROM xasi2.ab02
         WHERE aab001=prm_aab001
           AND aab051='1';

          IF num_count2 >1 THEN

          prm_msg :=  prm_msg||'该单位最大做账期号有不一致的情况！请参保单位联系社保基金管理中心处理！';
          prm_sign := '1';
          GOTO label_ERROR;
        END IF;

       --  单位权限控制
       SELECT COUNT(*)
         INTO num_count3
         FROM wsjb.irab01a2
        WHERE AAB001=prm_aab001;

       IF num_count3 >0 THEN
           prm_msg :=  prm_msg||'该单位存在一些特殊控制，请参保单位联系社保基金管理中心处理!';
           prm_sign := '1';
           GOTO label_ERROR;
        END IF;

      /*处理失败*/
      <<label_ERROR>>
      num_count1 := 0;


   EXCEPTION
     WHEN OTHERS THEN
          /*关闭打开的游标*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '数据库错误！'|| SQLERRM ;
          RETURN;
   END prc_P_ValidateAab001Privilege;
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
      prm_ErrorMsg        OUT           VARCHAR2)    --出错信息
   IS
    sj_acount       NUMBER(6);
   num_count        NUMBER(6);
   num_count1        NUMBER(6);
   num_count_ab     NUMBER(6);
   var_aac002Low    irac01.aac002%TYPE;
   var_15aac002     irac01.aac002%TYPE;
   var_aab001       irac01.aab001%TYPE;
   var_aac031        irac01.aac031%TYPE;
   var_aab004        irab01.aab004%TYPE;
   var_aac003       irac01.aac003%TYPE;
   var_aac001        irac01.aac001%TYPE;
   sj_count          NUMBER(6);
   sj_count1        NUMBER(6);
   count_jm         NUMBER(6);
   BEGIN
    /*初始化变量*/
      prm_AppCode  := GN_DEF_OK;
      prm_ErrorMsg := '';
      prm_msg :='';
      prm_sign :='0';
   --校验参数
      IF prm_yae181 IS NULL  THEN
         prm_msg :=  prm_msg||'传入证件类型为空，请核实。。。';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
      IF prm_aab001 IS NULL  THEN
         prm_msg :=  prm_msg||'传入单位编号为空，请核实。。。';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
      IF prm_aac002 IS NULL  THEN
         prm_msg :=  prm_msg||'传入证件号码为空，请核实。。。';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
       --身份证类型
     IF prm_yae181 = 1 THEN
        --获取各种形式的证件号码
         var_15aac002 := SUBSTR(prm_aac002,1,6)||SUBSTR(prm_aac002,9, 9);
         var_aac002Low := LOWER(prm_aac002);

        SELECT count(1)
          INTO num_count
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
           AND AAC003 NOT LIKE '%重复%';

         IF num_count > 0 THEN
            SELECT COUNT(1)
              INTO count_jm
              FROM XASI2.AC02K1
             WHERE AAC001 IN (SELECT AAC001
                                FROM XASI2.AC01
                               WHERE AAE120 = '0'
                                 AND AAC002 = PRM_AAC002
                                 AND AAC003 NOT LIKE '%重复%');
              IF count_jm>0 THEN
                prm_msg := '该人员存在居民医保参保记录！';
                prm_sign :='1';
                GOTO label_ERROR ;
              END IF;
            BEGIN
             SELECT aac001,
                    aac003
               INTO var_aac001,
                    var_aac003
               FROM xasi2.ac01
              WHERE AAE120 = '0'
              AND aac002 = prm_aac002
              AND AAC003 NOT LIKE '%重复%';
             EXCEPTION
                  WHEN OTHERS THEN
                       prm_msg := '该人员存在多个账户，请核对该人员是否存在多条医疗账户，若存在，则需要合并；若不存在多条医疗账户，请在续保模块操作！';
                       prm_sign :='1';
                       GOTO label_ERROR ;
            END;
            BEGIN
             SELECT aab001,
                    aac031
               INTO var_aab001,
                    var_aac031
               FROM xasi2.ac02
              WHERE aac001 = var_aac001
                AND aae140='03';
            EXCEPTION
                 WHEN OTHERS THEN
                      BEGIN
                       SELECT aab001,
                              aac031
                         INTO var_aab001,
                              var_aac031
                         FROM xasi2.ac02
                        WHERE aac001 = var_aac001
                          AND aae140='02';
                       EXCEPTION
                            WHEN OTHERS THEN
                             BEGIN
                                 SELECT aab001,
                                        aac031
                                   INTO var_aab001,
                                        var_aac031
                                   FROM xasi2.ac02
                                  WHERE aac001 = var_aac001
                                    AND aae140='05';
                              EXCEPTION
                               WHEN OTHERS THEN
                               BEGIN
                               SELECT aab001,
                                        aac031
                                   INTO var_aab001,
                                        var_aac031
                                   FROM xasi2.ac02
                                  WHERE aac001 = var_aac001
                                    AND aae140='04';
                                    EXCEPTION
                                      WHEN OTHERS THEN
                                      NULL;
                                    END;
                               END;
                       END;
            END;
             IF var_aac031='1' THEN
                 var_aac031 :='参保缴费';
             ELSIF var_aac031='2' THEN
                 var_aac031 :='暂停缴费';
             ELSIF var_aac031='3' THEN
                 var_aac031 :='终止缴费';
             END IF;
             SELECT aab004 INTO var_aab004 FROM xasi2.ab01 WHERE aab001 = var_aab001;
               prm_msg := '人员新参保登记验证不通过！此身份证号码人员医疗保险关系目前在社保中心,姓名'||var_aac003||',单位名称：'||var_aab004||'参保，参保状态:'||var_aac031||'。';
               prm_sign :='1';
               GOTO label_ERROR ;
         END IF ;

         SELECT count(1)
          INTO num_count1
          FROM wsjb.irac01  A
         WHERE A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
           AND a.iaa001 <> '4'
           AND A.IAA002 <> '3'
           AND  rownum = 1;

         IF num_count = 0 AND num_count1 > 0 THEN
          SELECT a.aab001
            INTO var_aab001
            FROM wsjb.irac01  A
           WHERE A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
             AND a.iaa001 <> '4'
             AND A.IAA002 <> '3'
             AND rownum =1;
           prm_msg := '证件号为：['||prm_aac002||']的人员在单位'||var_aab001||'有申报记录,不能新增!';
           prm_sign :='1';
           GOTO label_ERROR ;
         END IF;


  /*       SELECT count(1)
            INTO sj_acount
            FROM sjxt.ac01
         WHERE aac002 = prm_aac002;
         IF sj_acount=1 THEN
             SELECT aac001,aac003
               INTO var_aac001,var_aac003
               FROM sjxt.ac01
             WHERE aac002 = prm_aac002;

             SELECT count(DISTINCT aab001)
               INTO sj_count FROM sjxt.ac02
             WHERE aac001 = var_aac001
               AND aac031='1'
               AND aae140 IN (SELECT aae140 FROM ab02 WHERE aab001 = prm_aab001 AND aab051 = '1');
             IF sj_count > 0 THEN
                SELECT aab001,aac031
                  INTO var_aab001,var_aac031
                  FROM sjxt.ac02
                WHERE aac001 = var_aac001
                  AND aac031='1'
                  AND ROWNUM =1;
             ELSIF sj_count = 0 THEN
                SELECT count(DISTINCT aab001)
                  INTO sj_count1
                  FROM sjxt.ac02
                  WHERE aac001 = var_aac001
                    AND aae140 IN (SELECT aae140 FROM ab02 WHERE aab001 = prm_aab001 AND aab051 = '1')
                    AND aac031='2';
                  IF sj_count1 > 0 then
                     SELECT aab001,aac031
                       INTO var_aab001,var_aac031
                       FROM sjxt.ac02
                       WHERE aac001 = var_aac001
                       and aac031='2'
                       AND ROWNUM =1;
                  ELSIF sj_count1 = 0 then
                        --prm_msg := '人员新参保登记验证不通过！此身份证号码人员医疗保险关系目前在西安市社保中心,姓名'||var_aac003;
                       --prm_sign :='1';
                   GOTO label_ERROR ;
                  END IF;
              end if;
              IF var_aac031='1' THEN
                 var_aac031 :='参保缴费';
             ELSIF var_aac031='2' THEN
                 var_aac031 :='暂停缴费';
             ELSIF var_aac031='3' THEN
                 var_aac031 :='终止缴费';
             END IF;
             BEGIN
              SELECT aab004
                INTO var_aab004
                FROM sjxt.ab01
               WHERE aab001 = var_aab001;
             EXCEPTION
                  WHEN OTHERS THEN
                       var_aab004 :='';
             END;
           prm_msg := '人员新参保登记验证不通过！此身份证号码人员医疗保险关系目前在西安市社保中心,姓名'||var_aac003||',单位名称：'||var_aab004||'参保，参保状态:'||var_aac031||'。';
           prm_sign :='1';
           GOTO label_ERROR ;
       END IF;*/




     END IF;
     --护照类型
     IF prm_yae181 <> '1' THEN
       SELECT count(1)
          INTO num_count
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.AAC002 = prm_aac002
           AND AAC003 NOT LIKE '%重复%';

         IF num_count > 0 THEN
           prm_msg := '证件号为：['||prm_aac002||']的人员已存在个人信息，请在续保模块里操作';
           prm_sign :='1';
           GOTO label_ERROR;
         END IF;

         SELECT count(1)
          INTO num_count1
          FROM wsjb.irac01  A
         WHERE A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
           AND a.iaa001 <> '4'
           AND A.IAA002 <> '3'
           AND  rownum = 1;

         IF num_count = 0 AND num_count1 > 0 THEN
          SELECT a.aab001
            INTO var_aab001
            FROM wsjb.irac01  A
           WHERE A.AAC002 = prm_aac002
             AND A.iaa001 <> '4'
             AND A.IAA002 <> '3'
             AND rownum =1;
           prm_msg := '证件号为：['||prm_aac002||']的人员在单位'||var_aab001||'有申报记录,不能新增!';
           prm_sign :='1';
           GOTO label_ERROR ;
         END IF;

     END IF;

     <<label_ERROR>>
      num_count := 0;


   EXCEPTION
     WHEN OTHERS THEN
          /*关闭打开的游标*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '数据库错误！'|| SQLERRM ;
          RETURN;
   END prc_p_ValidateAac002Privilege;

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
      prm_ErrorMsg        OUT           VARCHAR2)    --出错信息

   IS
   num_count        NUMBER(6);
   rec_tmp_irac01a2 tmp_irac01a2%ROWTYPE;
   dat_aac006       DATE ;--出生日期
   dat_aac007       DATE ;--参工日期
   dat_aac030       DATE ;--本系统参保日期
   dat_yac033       DATE ;--个人初次参保日期
   var_aab001       irab01.aab001%TYPE;
   var_aae140       irab02.aae140%TYPE;
   num_aac040       NUMBER(14,2); --缴费工资
   num_yac004       NUMBER(14,2); --养老基数
   num_yac005       NUMBER(14,2); --其他基数
   var_iaa100       varchar2(6);  --申报月度
   var_iaa100_a      DATE;
   var_aac004       irac01.aac004%TYPE;  --性别
   var_aac008       irac01.aac008%TYPE;  --人员状态
   dat_yearAge      DATE;  --到龄日期
   var_aac012       irac01.aac012%TYPE;  --人员身份
   BEGIN
   /*初始化变量*/
     prm_AppCode  := GN_DEF_OK;
     prm_ErrorMsg := '';
     prm_msg :='';
     prm_sign :='0';



     SELECT *
     INTO rec_tmp_irac01a2
     FROM wsjb.tmp_irac01a2
    WHERE iaz018 = prm_iaz018;
     --校验参数
    IF prm_iaz018 IS NULL  THEN
      prm_msg :=  prm_msg||'传入校验流水号为空，请核实。。。';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    var_aab001 := rec_tmp_irac01a2.aab001;
   --判断是否是单养老单位
    SELECT COUNT(1)
      INTO num_count
      FROM xasi2.ab02
     WHERE AAB001 = var_aab001
       AND AAB051 = '1';

    IF num_count = 0 THEN
    --其他基数更新为0
      UPDATE wsjb.tmp_irac01a2
         SET yac005 = 0
       WHERE iaz018 = prm_iaz018;
    END IF;

    dat_aac006 := rec_tmp_irac01a2.aac006;--出生日期
    dat_aac007 := rec_tmp_irac01a2.aac007;--参工日期
    dat_aac030 := rec_tmp_irac01a2.aac030;--本系统参保日期
    dat_yac033 := rec_tmp_irac01a2.yac033;--个人初次参保日期
    var_iaa100 := rec_tmp_irac01a2.iaa100;--申报月度
    SELECT to_date(rec_tmp_irac01a2.iaa100||'01','yyyy-MM-dd hh:mi:ss') INTO var_iaa100_a FROM dual;
    var_aac004 := rec_tmp_irac01a2.aac004;--性别
    var_aac008 := rec_tmp_irac01a2.aac008;--人员状态
    var_aac012 := rec_tmp_irac01a2.aac012;--人员身份
    IF dat_aac007 > dat_aac030 THEN
      prm_msg :=  prm_msg||'首次参加工作日期不能晚于到本单位参保日期!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_aac007 > var_iaa100_a THEN
      prm_msg :=  prm_msg||'参工日期不能晚于申报月度'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_yac033 > var_iaa100_a THEN
      prm_msg :=  prm_msg||'个人初次参保日期不能晚于晚于申报月度'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
--    IF dat_aac030 > SYSDATE THEN
--      prm_msg :=  prm_msg||'到本单位参保日期不能晚于系统日期'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||'!';
--      prm_sign := '1';
--      GOTO label_ERROR;
--    END IF;
    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) > TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'到本单位参保日期不能晚于当前可申报月度'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_aac006 > dat_aac007 THEN
      prm_msg :=  prm_msg||'首次参加工作日期不能早于出生日期!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_aac006 > dat_aac030 THEN
      prm_msg :=  prm_msg||'本单位参保日期不能早于出生日期!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_aac006 > dat_yac033 THEN
      prm_msg :=  prm_msg||'个人初次参保日期不能早于出生日期!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    /**
     --校验身份证号码
     prc_p_ValidateAac002Privilege(
                                   rec_tmp_irac01a2.yae181   ,     --证件类型
                                   rec_tmp_irac01a2.aac002   ,     --证件号码
                                   rec_tmp_irac01a2.aab001   ,     --单位编号
                                   prm_msg      ,     -- 错误信息
                                   prm_sign     ,     -- 错误标志
                                   prm_AppCode  ,     --执行代码
                                   prm_ErrorMsg );    --出错信息
     IF prm_sign = '1' THEN
      GOTO label_ERROR;
     END IF ;
     **/
     --超龄人员参保需要提示
     IF var_aac008 = '1' THEN

         IF var_aac004 = '1' THEN --男 60岁
           dat_yearAge := ADD_MONTHS(dat_aac006,60*12);
         ELSIF var_aac004 = '2' AND var_aac012 = '4' THEN --女干部 55岁
           dat_yearAge := ADD_MONTHS(dat_aac006,55*12);
         ELSIF var_aac004 = '2' AND var_aac012 = '1' THEN --女工人 50岁
           dat_yearAge := ADD_MONTHS(dat_aac006,50*12);
         ELSE
           prm_msg := '性别获取失败';
           prm_sign := '1';
           GOTO label_ERROR;
         END IF;
         IF dat_yearAge < SYSDATE THEN
           prm_msg :=  prm_msg||'您好，此员工已超过退休年龄，请核实因何种情况需为此人缴纳社会保险。确有特殊情况，请提供相关说明材料至社保中心网上审核窗口备案!';
            prm_sign := '1';
           GOTO label_ERROR;
         END IF;

     END IF;

     --如是身份证，则姓名不能有空格
     IF rec_tmp_irac01a2.yae181 = '1' THEN
       UPDATE wsjb.tmp_irac01a2
         SET aac003 = REPLACE(aac003,' ','')
       WHERE iaz018 = prm_iaz018;
     END IF;

     --险种校验
     IF rec_tmp_irac01a2.aae110 = '0' AND
        rec_tmp_irac01a2.aae120 = '0' AND
        rec_tmp_irac01a2.aae210 = '0' AND
        rec_tmp_irac01a2.aae310 = '0' AND
        rec_tmp_irac01a2.aae410 = '0' AND
        rec_tmp_irac01a2.aae510 = '0' AND
        rec_tmp_irac01a2.aae311 = '0' AND
        rec_tmp_irac01a2.aae810 = '0' THEN

        prm_msg :=  prm_msg||'未获取到勾选参保的险种信息!';
        prm_sign := '1';
        GOTO label_ERROR;

     END IF;
     --公务员补助险种校验
     IF rec_tmp_irac01a2.aae810 = '1' THEN

        IF rec_tmp_irac01a2.yac200 IS NULL THEN
          prm_msg :=  prm_msg||'公务员职级不能为空!';
           prm_sign := '1';
           GOTO label_ERROR;
        END IF;

     END IF;



     --基数校验
     num_aac040 := rec_tmp_irac01a2.aac040;--缴费工资
     IF rec_tmp_irac01a2.aae110 = '1' THEN
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,var_aab001,num_aac040,'0','01','1','1',var_iaa100,prm_yab139))
          INTO num_yac004
          FROM  dual ;
        IF ROUND(num_yac004) <> rec_tmp_irac01a2.yac004 THEN
          --企业养老基数更新
          UPDATE wsjb.tmp_irac01a2
             SET yac004 = ROUND(num_yac004)
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;

     IF rec_tmp_irac01a2.aae120 = '1' THEN

        IF num_aac040 <> rec_tmp_irac01a2.yac004 THEN
          --机关养老基数更新
          UPDATE wsjb.tmp_irac01a2
             SET yac004 = num_aac040
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;

     IF rec_tmp_irac01a2.aae210 = '1' OR
        rec_tmp_irac01a2.aae310 = '1' OR
        rec_tmp_irac01a2.aae410 = '1' OR
        rec_tmp_irac01a2.aae510 = '1' OR
        rec_tmp_irac01a2.aae810 = '1' THEN
        --以一个险种为准
        SELECT aae140
          INTO var_aae140
          FROM xasi2.AB02
         WHERE aab051 = '1'
           AND (aae140 = '02' OR aae140 = '03' OR aae140 = '04' OR aae140 = '05' )
           AND aab001 = var_aab001
           AND ROWNUM = 1;
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,var_aab001,num_aac040,'0',var_aae140,'1','1',var_iaa100,prm_yab139))
          INTO num_yac005
          FROM  dual ;
        IF ROUND(num_yac005) <> rec_tmp_irac01a2.yac005 THEN
          --其他基数更新
          UPDATE wsjb.tmp_irac01a2
             SET yac005 = ROUND(num_yac005),
                 yaa333 = ROUND(num_yac005)
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;



     /*处理失败*/
      <<label_ERROR>>

        num_count :=0;

   EXCEPTION
     WHEN OTHERS THEN
          /*关闭打开的游标*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '数据库错误！'|| SQLERRM ;
          RETURN;
   END prc_p_checkNewInsur;

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
      prm_aac001          IN           VARCHAR2,     --个人编号
      prm_msg             OUT           VARCHAR2,     -- 错误信息
      prm_sign            OUT           VARCHAR2,     -- 错误标志
      prm_AppCode         OUT           VARCHAR2,     --执行代码
      prm_ErrorMsg        OUT           VARCHAR2)    --出错信息

   IS
     sj_count       NUMBER;--查询ac01市局
    sj_acount       NUMBER;
    aac001_sj        irac01.aac001%TYPE;
   num_count        NUMBER(6);
   num_count1       NUMBER(6);
   var_aac002Low    irac01.aac002%TYPE;
   var_15aac002     irac01.aac002%TYPE;
   var_aab001       irab01.aab001%TYPE;
   var_aac001       irac01.aac001%TYPE;
   num_ab02count    NUMBER;
   var_akc021       irac01.akc021%TYPE;
   var_aac008       irac01.aac008%TYPE;
   var_yab013       irac01.yab013%TYPE;--原单位编号
   BEGIN
    /*初始化变量*/
      prm_AppCode  := GN_DEF_OK;
      prm_ErrorMsg := '';
      prm_msg :='';
      prm_sign :='0';
   --校验参数
      IF prm_yae181 IS NULL  THEN
         prm_msg :=  prm_msg||'传入证件类型为空，请核实。。。';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
      IF prm_aab001 IS NULL  THEN
         prm_msg :=  prm_msg||'传入单位编号为空，请核实。。。';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
      IF prm_aac002 IS NULL  THEN
         prm_msg :=  prm_msg||'传入证件号码为空，请核实。。。';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;

       --身份证类型
     IF prm_yae181 = 1 THEN
      SELECT count(1)
       INTO  num_ab02count
       FROM xasi2.ab02 a
       WHERE aab051='1'
       AND  aab001= prm_aab001;
        --获取各种形式的证件号码
         var_15aac002 := SUBSTR(prm_aac002,1,6)||SUBSTR(prm_aac002,9, 9);
         var_aac002Low := LOWER(prm_aac002);
        IF prm_aac001 IS NULL  THEN
               SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '0'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '此人存在待申报的续保信息,请先办理申报业务!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 IN ('3','7')
         AND A.IAA002 = '0'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '此人存在待申报的暂停信息,请先办理申报业务!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '1'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '此人存在已申报的续保信息,请等待审核通过!!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '4'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '此人存在被打回的续保信息,请到[月申报]功能下修改相关信息继续申报!!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '5'
         AND A.IAA002 = '0'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '此人存在待申报的险种新增信息,请先办理申报业务!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '5'
         AND A.IAA002 = '1'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '此人存在已申报的险种新增信息,请等待审核通过!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;
         GOTO label_ERROR;
        END IF;

        SELECT count(1)
          INTO num_count
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
           AND AAC003 NOT LIKE '%重复%';

             /*IF num_count = 0 THEN
             select count(*)
               into sj_count
               from sjxt.ac01
               where aac002 = prm_aac002 ;

              IF sj_count=0 THEN
                 prm_msg := '证件号为：['||prm_aac002||']的人员不存在个人信息，请在新参保模块里操作！';
                 prm_sign :='1';
                 GOTO label_ERROR ;
               END IF;
               IF sj_count>1 THEN
                 prm_msg := '证件号为：['||prm_aac002||']的人员在市局存在多条信息，请注意！';
                 prm_sign :='1';
                 GOTO label_ERROR ;
               END IF;
            \***               --查询新序列
                         select xasi2.seq_aac001.nextval into var_aac001 from dual;
                         --市局对应的aac001
                             select aac001
                         INTO aac001_sj
                         from sjxt.ac01
                       where aac002 = prm_aac002 ;
                       --插入对应表
                          insert into xasi2.ac01d1(
                          aac001,
                          aac002,
                          aac001_s,
                          aae036
                          )
                          values(
                          var_aac001,
                          prm_aac002,
                          aac001_sj,
                          sysdate
                          );
                          --使用市局的aac008; 获取方式待定
                    --       select    aac008     INTO    var_aac008
                    --  from sjxt.ac01
                     --  where aac002 = prm_aac002 ;
                   ***\
            END IF ;*/
        IF num_count > 1 THEN
            SELECT count(1) INTO num_count1
              FROM xasi2.ac01 a,xasi2.ac02 b
              WHERE a.aac001=b.aac001
              AND   a.aac003 NOT LIKE '%重复%'
              AND    b.aac031='2'
              AND   b.aae140='03'
              AND   a.aac002 = prm_aac002;

        END IF ;
          /*IF num_count1 >1 THEN
             prm_msg := '证件号为：['||prm_aac002||']的人员存在多条个人信息，请在联系社保中心！';
             prm_sign :='1';
             GOTO label_ERROR ;
           END IF;
          if num_count1=1 THEN
             SELECT a.aac001 INTO var_aac001
              FROM xasi2.ac01 a,xasi2.ac02 b
              WHERE a.aac001=b.aac001
              AND   a.aac003 NOT LIKE '%重复%'
              AND    b.aac031='2'
              AND   b.aae140='03'
              AND   a.aac002 = prm_aac002;
          END IF;
*/

             IF num_count = 1 THEN
                    SELECT aac001,
                           aac008
                      INTO var_aac001,
                           var_aac008
                      FROM xasi2.ac01 A
                     WHERE AAE120 = '0'
                       AND A.aac001=prm_aac001
                       AND AAC003 NOT LIKE '%重复%';

                ELSIF  num_count > 1  THEN

                    SELECT aac001,
                           aac008
                      INTO var_aac001,
                           var_aac008
                      FROM xasi2.ac01 A
                     WHERE AAE120 = '0'
                       AND A.aac001=prm_aac001
                       AND AAC003 NOT LIKE '%重复%';
               END IF;
   ELSE
        SELECT count(1)
          INTO num_count
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.AAC002 = prm_aac002
           AND AAC003 NOT LIKE '%重复%';

       /* IF num_count = 0 THEN
          select count(*)
           into sj_count
           from sjxt.ac01
           where aac002 = prm_aac002 ;

          IF sj_count=0 THEN
           prm_msg := '证件号为：['||prm_aac002||']的人员不存在个人信息，请在新参保模块里操作！';
           prm_sign :='1';
           GOTO label_ERROR ;
           END IF;
           IF sj_count>1 THEN
           prm_msg := '证件号为：['||prm_aac002||']的人员在市局存在多条信息，请注意！';
           prm_sign :='1';
           GOTO label_ERROR ;
           END IF;

        END IF ;*/
        /*IF num_count > 1 THEN
           prm_msg := '证件号为：['||prm_aac002||']的人员存在多条个人信息，请在联系社保中心！';
           prm_sign :='1';
           GOTO label_ERROR ;
        END IF ;

       IF num_count = 1 THEN*/
        SELECT aac001,
               aac008
          INTO var_aac001,
               var_aac008
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.aac001=prm_aac001
           AND AAC003 NOT LIKE '%重复%';
          /*ELSE IF num_count >1 THEN
           prm_msg := '证件号为：['||prm_aac002||']的人员存在多条个人信息，请在联系社保中心！';
           prm_sign :='1';
           GOTO label_ERROR ;*/
          /**  --查询新序列
             select xasi2.seq_aac001.nextval into var_aac001 from dual;
             --市局对应的aac001
                 select aac001
             INTO aac001_sj
             from sjxt.ac01
           where aac002 = prm_aac002 ;
           --插入对应表
              insert into xasi2.ac01d1(
              aac001,
              aac002,
              aac001_s,
              aae036
              )
              values(
              var_aac001,
              prm_aac002,
              aac001_sj,
              sysdate
              );
              --使用市局的aac008; 获取方式待定
          --     select    aac008    INTO     var_aac008
         -- from sjxt.ac01
          -- where aac002 = prm_aac002 ;
          **/
        -- END IF ;
     END IF;
   --END IF;
      /*  SELECT count(1)
          INTO num_count
          FROM xasi2.KC01 A
         WHERE A.AAC001 = var_aac001;
      IF num_count > 0 THEN
        SELECT A.AKC021
          INTO var_akc021
          FROM xasi2.KC01 A
         WHERE A.AAC001 = var_aac001;
       IF var_aac008 = '2' AND var_akc021 = '11' THEN
           prm_msg := '证件号为：['||prm_aac002||']的人员正在办理待退业务,不能办理续保手续，如要办理联系社保中心！';
          prm_sign :='1';
          GOTO label_ERROR ;
       END IF;
      END IF;*/


      -- prm_aac001 := var_aac001;
        --四险全参的不能续保养老

       SELECT count(1)
         INTO num_count
         FROM xasi2.ac02
        WHERE AAC001 = var_aac001
          AND AAB001 = prm_aab001
          AND aac031 = '1'
          AND aae140 <> '06';
       IF num_count = 5 THEN
           prm_msg := '证件号为：['||prm_aac002||']的人员在本单位只可能养老保险未参保，请到新增险种功能下新增养老险种！';
          prm_sign :='1';
          GOTO label_ERROR ;
       END IF;
/*
         --查询市局数据有无正参保信息
           SELECT count(*)
         into sj_acount
          from sjxt.ac02 where aac031='1' and
          aac001 in(select aac001 from sjxt.ac01
              where aac002 = prm_aac002 );
         IF sj_acount > 0 THEN
             prm_msg := '证件号为：['||prm_aac002||']的人员在市局单位有正在参保的险种！';
            prm_sign :='1';
            GOTO label_ERROR ;
             END IF;
*/     --在本单位是否正常参保
      SELECT COUNT(1) AS COUNT1
          INTO num_count
          FROM xasi2.ac01 A, xasi2.ac02 B
         WHERE A.AAC001 = B.AAC001
           AND A.AAE120 = '0'
           AND B.AAC031 = '1'
           AND A.AAC001 = var_aac001
           AND B.AAB001 = prm_aab001;
           IF num_count >0 THEN
            prm_msg := '此人在本单位有正常参保的险种，请到新增险种功能下操作';
          prm_sign :='1';
          GOTO label_ERROR ;
           END IF;
       --在别的单位是否有参保缴费记录
       SELECT SUM(COUNT1)
         INTO num_count
         FROM (SELECT COUNT(*) AS COUNT1
                  FROM xasi2.ac01 A, xasi2.ac02 B
                 WHERE A.AAC001 = B.AAC001
                   AND A.AAE120 = '0'
                   AND B.AAC031 = '1'
                   AND B.AAE140 <> '04'
                   AND A.AAC001 = var_aac001
                   AND B.AAB001 <> prm_aab001
                UNION
                SELECT COUNT(1) AS COUNT1
                  FROM wsjb.irac01a3
                 WHERE AAB001 <> prm_aab001
                   AND AAC001 = var_aac001
                   AND AAE110 = '2');
      IF num_count = 0 THEN
        SELECT count(1)
          INTO num_count
          FROM wsjb.irac01
         WHERE AAC001 = var_aac001
           AND IAA001 = '4'
           AND IAA002 = '1';
        IF num_count > 0 THEN
          prm_msg := '此人存在待审核的“人员重要信息变更”申请,请提示本人尽快携带相关资料到社保中心进行审核办理。办理成功后，方可进行续保操作！';
          prm_sign :='1';
          GOTO label_ERROR ;
        END IF;
      ELSE
        SELECT COUNT(1) AS COUNT1
          INTO num_count
          FROM xasi2.ac01 A, xasi2.ac02 B
         WHERE A.AAC001 = B.AAC001
           AND A.AAE120 = '0'
           AND B.AAC031 = '1'
           AND B.AAE140 = '04'
           AND A.AAC001 = var_aac001
           AND B.AAB001 = prm_aab001;
         IF num_count > 0 THEN
             prm_msg := '此人在其他单位有险种未做暂停，且在本单位也已参工伤险种！';
            prm_sign :='1';
            GOTO label_ERROR ;
         END IF;

        SELECT COUNT(*) AS COUNT1
          INTO num_count
          FROM xasi2.ac01 A, xasi2.ac02 B, xasi2.ab01 C
         WHERE A.AAC001 = B.AAC001
           AND B.AAB001 = C.AAB001
           AND A.AAE120 = '0'
           AND B.AAC031 = '1'
           AND B.AAE140 IN ('03', '07')
           AND A.AAC001 = var_aac001
           AND C.YAB136 = '001';
        IF num_count > 0 THEN
           prm_msg := '此人在人事代理机构有险种未做暂停,请暂停后再续保！';
           prm_sign :='1';
           GOTO label_ERROR ;
        END IF;

      prm_msg := '此人在其他单位有险种未做暂停,本单位只能参保工伤险！';
      prm_sign :='2';
      GOTO label_ERROR ;
      END IF;

      SELECT SUM(I)
        INTO num_count
        FROM (SELECT COUNT(1) AS I
                FROM xasi2.ac08 A, wsjb.irab01a5  B
               WHERE A.AAB001 = B.AAB001
                 AND AAC001 = var_aac001
                 AND AAE140 = '03'
                 AND AAE002 = prm_iaa100
              UNION
              SELECT COUNT(1) AS I
                FROM xasi2.ac08a1 A, wsjb.irab01a5  B
               WHERE A.AAB001 = B.AAB001
                 AND AAC001 = var_aac001
                 AND AAE140 = '03'
                 AND AAE002 = prm_iaa100);
      IF num_count > 0 THEN
         prm_msg := '此人'||prm_iaa100||'存在医疗缴费记录信息,不能续保。详细请咨询社保中心!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;
      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '0'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '此人存在待申报的续保信息,请先办理申报业务!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 IN ('3','7')
         AND A.IAA002 = '0'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '此人存在待申报的暂停信息,请先办理申报业务!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '1'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '此人存在已申报的续保信息,请等待审核通过!!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '4'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '此人存在被打回的续保信息,请到[月申报]功能下修改相关信息继续申报!!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '5'
         AND A.IAA002 = '0'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '此人存在待申报的险种新增信息,请先办理申报业务!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '5'
         AND A.IAA002 = '1'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '此人存在已申报的险种新增信息,请等待审核通过!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 IN ('3', '7', '9', '10')
         AND A.IAA002 = '2'
         AND A.AAC001 = var_aac001
         AND A.IAA100 = prm_iaa100;
      IF num_count > 0 THEN
        SELECT aab001
          INTO var_yab013
          FROM wsjb.irac01  A
         WHERE A.IAA001 IN ('3', '7', '9', '10')
           AND A.IAA002 = '2'
           AND A.AAC001 = var_aac001
           AND A.IAA100 = prm_iaa100
           AND ROWNUM = 1;
/***-----------------------------------
        SELECT SUM(I) as i
          INTO num_count
          FROM (SELECT COUNT(1) I
                  FROM AB08
                 WHERE AAB001 = var_yab013
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01'
                UNION ALL
                SELECT COUNT(1) I
                  FROM AB08A8
                 WHERE AAB001 = var_yab013
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01'
                UNION ALL
                SELECT COUNT(1) I
                  FROM IRAB08
                 WHERE AAB001 = var_yab013
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01');
       IF num_count > 0 THEN
          prm_msg := '此人存在待审核的人员减少信息或者当前月份存在缴费记录，不能办理续保,请等待审核通过!';
         prm_sign :='1';
         GOTO label_ERROR ;
       END IF;
       ---------------------***/
      END IF;
      SELECT SUM(I) as i
          INTO num_count
          FROM (SELECT COUNT(1) I
                  FROM xasi2.ab08
                 WHERE AAC001 = var_aac001
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01'
                UNION ALL
                SELECT COUNT(1) I
                  FROM xasi2.ab08a8
                 WHERE AAC001 = var_aac001
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01'
                UNION ALL
                SELECT COUNT(1) I
                  FROM wsjb.irab08
                 WHERE AAC001 = var_aac001
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01');
       IF num_count > 0 THEN
          prm_msg := '此人当前月份存在缴费记录，不能办理续保!';
         prm_sign :='1';
         GOTO label_ERROR ;
       END IF;


      /*处理失败*/
      <<label_ERROR>>

       num_count :=0;
  EXCEPTION
     WHEN OTHERS THEN
          /*关闭打开的游标*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '数据库错误！'|| SQLERRM ;
          RETURN;
   END prc_p_ValidateAac002Continue;


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
      prm_ErrorMsg        OUT           VARCHAR2)    --出错信息
  IS
   num_count        NUMBER(6);
   rec_tmp_irac01a2 tmp_irac01a2%ROWTYPE;
   dat_aac006       DATE ;--出生日期
   dat_aac007       DATE ;--参工日期
   dat_aac030       DATE ;--本系统参保日期
   dat_yac033       DATE ;--个人初次参保日期
   var_aab001       irab01.aab001%TYPE;
   var_aae140       irab02.aae140%TYPE;
   num_aac040       NUMBER(14,2); --缴费工资
   num_yac004       NUMBER(14,2); --养老基数
   num_yac005       NUMBER(14,2); --其他基数
   var_iaa100       VARCHAR2(6);  --申报月度
   dat_iaa100        DATE;
   var_aac001       irac01.aac001%TYPE;
   var_aac002       irac01.aac002%TYPE;
   var_aac009       irac01.aac009%TYPE;  --户口性质
   var_aac008       irac01.aac008%TYPE;
   var_aae110       irac01.aae110%TYPE;
   var_aae120       irac01.aae120%TYPE;
   var_aae210       irac01.aae210%TYPE;
   var_aae310       irac01.aae310%TYPE;
   var_aae410       irac01.aae410%TYPE;
   var_aae510       irac01.aae510%TYPE;
   var_aae311       irac01.aae311%TYPE;
   var_aae810       irac01.aae810%TYPE;
   var_yac001       irac01a3.yac001%TYPE;
   count_repeat_zg  NUMBER(3);
   var_aab004       VARCHAR2(100);
   ac02_count_04    NUMBER(3);
   ac01_count       NUMBER(3);
   var_aae011       irac01a3.aae011%TYPE;
   var_aae036       irac01a3.aae036%TYPE;
   var_yae181       irac01a3.yae181%TYPE;
   var_aac003       irac01a3.aac003%TYPE;
   var_aac004       irac01a3.aac004%TYPE;
   var_aac005       irac01a3.aac005%TYPE;
   var_aac006       irac01.aac006%TYPE;
   var_aae013       irac01a3.aae013%TYPE;
   var_yae222       irac01a3.yae222%TYPE;
   var_aae007       irac01a3.aae007%TYPE;
   var_aae004       irac01a3.aae004%TYPE;
   var_aae005       irac01a3.aae005%TYPE;
   var_aae006       irac01a3.aae006%TYPE;
   var_aac007       irac01a3.aac007%TYPE;
   var_yac168       irac01a3.yac168%TYPE;
   var_yac067       irac01a3.yac067%TYPE;
   var_aac010       irac01a3.aae010%TYPE;
   var_aac020       irac01a3.aac020%TYPE;
   var_aac012       irac01a3.aac012%TYPE;
   var_aac013       irac01a3.aac013%TYPE;
   var_aac014       irac01a3.aac014%TYPE;
   var_aac015       irac01a3.aac015%TYPE;
   var_iaa100_new   irac01.iaa100%TYPE;
   irac01_aac001    irac01.aac001%TYPE;
   irac01a3_aac001   irac01a3.aac001%TYPE;
   var_iaz018       VARCHAR2(30);
   ac01_irac01a3_count NUMBER;
   count_aab001_irac01a3 NUMBER;
   yl_count    NUMBER;   
   zy_akc021     VARCHAR2(30);
   X            VARCHAR2(30);
   woman_months  NUMBER(6);
   woman_worker_months  NUMBER(6);
   sj_months         NUMBER(6);
   var_aac006_ac01   NUMBER(8);
   
   num_count_tmp_irac01a2  number;

   irac01a3_count  number(5);
        --检查个人参保信息
      CURSOR cur_aae140 IS
         SELECT aae140
           FROM xasi2.tmp_aae140
          WHERE yae099 = var_aac001
            AND aab001 = var_aab001;


      --检查是否存在其他医保编号
      CURSOR cur_aac001 IS
         SELECT aac001,aac002,aac003
           FROM xasi2.ac01
          WHERE aac001 <> var_aac001
            AND aac002 = var_aac002;

   BEGIN



   /*初始化变量*/
     prm_AppCode  := GN_DEF_OK;
     prm_ErrorMsg := '';
     prm_msg :='';
     prm_sign :='0';
     woman_months := 660;
    woman_worker_months :=600;


     SELECT *
     INTO rec_tmp_irac01a2
     FROM wsjb.tmp_irac01a2
    WHERE iaz018 = prm_iaz018;
     --校验参数
    IF prm_iaz018 IS NULL  THEN
      prm_msg :=  prm_msg||'传入校验流水号为空，请核实。。。';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    var_aab001 := rec_tmp_irac01a2.aab001;
    var_aac001 := rec_tmp_irac01a2.aac001;
    var_aac002 := rec_tmp_irac01a2.aac002;
    var_aac008 := rec_tmp_irac01a2.aac008;
    var_aae110 := rec_tmp_irac01a2.aae110;
    var_aae120 := rec_tmp_irac01a2.aae120;
    var_aae210 := rec_tmp_irac01a2.aae210;
    var_aae310 := rec_tmp_irac01a2.aae310;
    var_aae410 := rec_tmp_irac01a2.aae410;
    var_aae510 := rec_tmp_irac01a2.aae510;
    var_aae311 := rec_tmp_irac01a2.aae311;
    var_aae810 := rec_tmp_irac01a2.aae810;
    --irac01a3 新增
    var_iaz018 := rec_tmp_irac01a2.iaz018;
    var_aae011 := rec_tmp_irac01a2.aae011;
    var_aae036 := rec_tmp_irac01a2.aae036;
    var_yae181 := rec_tmp_irac01a2.yae181;
    var_aac003 := rec_tmp_irac01a2.aac003;
    var_aac004 := rec_tmp_irac01a2.aac004;
    var_aac005 := rec_tmp_irac01a2.aac005;
    var_aac006 := rec_tmp_irac01a2.aac006;
    var_aae013 := rec_tmp_irac01a2.aae013;
    var_yae222 := rec_tmp_irac01a2.yae222;
    var_aae007 := rec_tmp_irac01a2.aae007;
    var_aae004 := rec_tmp_irac01a2.aae004;
    var_aae005 := rec_tmp_irac01a2.aae005;
    var_aae006 := rec_tmp_irac01a2.aae006;
    var_aac007 := rec_tmp_irac01a2.aac007;
    var_yac168 := rec_tmp_irac01a2.yac168;
    var_aac009 := rec_tmp_irac01a2.aac009;
    var_aac010 := rec_tmp_irac01a2.aac010;
    var_yac168 := rec_tmp_irac01a2.yac168;
    var_yac067 := rec_tmp_irac01a2.yac067;
    var_aac020 := rec_tmp_irac01a2.aac020;
    var_aac012 := rec_tmp_irac01a2.aac012;
    var_aac013 := rec_tmp_irac01a2.aac013;
    var_aac014 := rec_tmp_irac01a2.aac014;
    var_aac015 := rec_tmp_irac01a2.aac015;
    var_iaa100_new := rec_tmp_irac01a2.iaa100;
    
    
    --  AAC012  个人身份 工人  50  干部 55 
     var_aac012 := rec_tmp_irac01a2.aac012;
    
      IF var_aac012 IS NULL  THEN
      prm_msg :=  prm_msg||'传入个人身份为空，请核实。。。';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;


   --  处理irac01 和 irac01a3   aac001 不一致问题
   -- begin wangz 20190605
   -- 无ac01 调过校验
   select count(1) INTO ac01_irac01a3_count from xasi2.ac01 where aac002  = var_aac002 and aac003 = var_aac003; 
  IF ac01_irac01a3_count > 0 THEN 
    -- IF 1=1 THEN 
      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.IRAC01A3
       WHERE AAC001 = var_aac001
         AND AAB001 = var_aab001;
      IF num_count = 0 THEN
         var_yac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'YAC001');
         IF var_yac001 is null THEN
            prm_AppCode := gn_def_ERR ;
            prm_msg  := '没有获取到单位人员序列号yac001!';
            RETURN;
         END IF;
        INSERT INTO wsjb.tmp_irac01a3 (
       --  INSERT INTO wsjb.irac01a3 (
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
                     var_aab001,
                     var_yae181,          -- 证件类型
                     var_aac002,          -- 身份证号码(证件号码)
                     var_aac003,          -- 姓名
                     var_aac004,          -- 性别
                     var_aac005,
                     var_aac006,          -- 出生日期
                     var_aac007,          -- 参加工作日期
                     var_aac008,          -- 人员状态
                     var_aac009,
                     var_aac010,
                     var_aac012,
                     var_aac013,
                     var_aac014,
                     var_aac015,
                     var_aac020,
                     var_yac067,          -- 来源方式
                     var_yac168,          -- 农民工标志
                     var_aae004,
                     var_aae005,          -- 联系电话
                     var_aae006,          -- 地址
                     var_aae007,
                     var_yae222,
                     var_aae013,
                     0,
                     PKG_Constant.YAB003_JBFZX,
                     var_aab001,
                     var_aae011,          -- 经办人
                     sysdate);         -- 经办时间
      END IF;

    --  处理申报数据和养老信息数据
    --  处理之前的irac01a3 数据
    -- 当前单位有数据 
     SELECT count(1) INTO count_aab001_irac01a3  FROM wsjb.irac01a3 WHERE aac002 = var_aac002  AND aab001 = var_aab001;
   
    IF  count_aab001_irac01a3 > 0  THEN
    
     INSERT INTO wsjb.tmp_irac01a3 SELECT * FROM wsjb.irac01a3 WHERE aac002 = var_aac002  AND aac003 = var_aac003;
     
         BEGIN
          
               select count(1) 
                 into num_count_tmp_irac01a2 
                 from wsjb.tmp_irac01a2 
                where aac002 =  var_aac002
                    AND aab001 = var_aab001
                     AND  IAA002='0'
                     AND IAA001 <> '4'
                     --AND IAA100 = var_iaa100_new ;
                     AND IAA100  IS NULL;
              if  num_count_tmp_irac01a2 < 1 then
                  prm_msg := prm_msg|| 'tmp_irac01a2没有可处理信息！';
                  return;
              end if;
         
             SELECT aac001  INTO irac01_aac001  FROM wsjb.tmp_irac01a2 
                    WHERE aac002 =  var_aac002
                    AND aab001 = var_aab001
                     AND  IAA002='0'
                     AND IAA001 <> '4'
                     --AND IAA100 = var_iaa100_new ;
                     AND IAA100  IS NULL ;
                 
            SELECT aac001  INTO irac01a3_aac001   FROM wsjb.tmp_irac01a3
                         WHERE  aac002 = var_aac002 AND aab001 =  var_aab001;
                        
                         
              /*  SELECT aac001  INTO irac01a3_aac001   FROM wsjb.irac01a3
                WHERE  aac002 = var_aac002 AND aab001 =  var_aab001;
                   */ 

           EXCEPTION

              WHEN NO_DATA_FOUND THEN
                 prm_sign := '1'; 
                  prm_msg := prm_msg|| '未获取到养老基本信息';
              -- prm_ErrorMsg := prm_msg;
               --   GOTO label_ERROR;
                RETURN;
              WHEN TOO_MANY_ROWS THEN
                 
                  --prm_AppCode  :=  PKG_Constant.;
                  prm_msg := prm_msg|| '该身份证号'|| var_aac002 ||'为多编号人员，请选择另外一个个人编号再进行操作';
                  -- prm_ErrorMsg := prm_msg;
                   prm_sign := '1'; 
                  -- delete from wsjb.irac01a3 where  aac002 = var_aac002 and aac001 = var_aac001 and aac003 = var_aac003;
               --   GOTO label_ERROR;
                 RETURN;

          WHEN OTHERS THEN

                
             IF    irac01_aac001   <>  irac01a3_aac001 THEN
             -- prm_AppCode  :=  PKG_Constant.gn_def_ERR;
               prm_msg   := 'irac01'||irac01_aac001||'与irac01a3'||irac01a3_aac001||'信息不匹配!';
               prm_ErrorMsg := prm_msg;
               prm_sign := '1'; 
              END IF;
              -- GOTO label_ERROR; 
           
             RETURN;
         END;
       END IF;
   END IF;
   --  end wangz 20190605
   
   
    -- begin wangz 20190708
   /*
     IF  var_aac006 is null  THEN
            prm_sign := '1';
            prm_msg  := '该人员出生日期为空!!！';
            GOTO label_ERROR;
     END IF ;

      --  select trunc(months_between(sysdate,to_date(to_char(var_aac006,'yyyymm'),'yyyymm'))) INTO sj_months from dual;
     --   select trunc(months_between(sysdate,to_date(to_number(to_char(var_aac006,'yyyyMMdd'),'yyyymm')),'yyyymm')) INTO sj_months from dual;
    --  select  months_between(sysdate,to_date(to_number(substr(replace(var_aac006,'-',''),0,6)),'yyyyMM'))   INTO sj_months   from dual;
      select to_number(to_char(min(aac006),'yyyymm'))   INTO var_aac006_ac01  
            from xasi2.ac01
           where aac002 = var_aac002
           and aac001   = var_aac001
             AND rownum = 1   ;

           select trunc(months_between(sysdate,to_date(var_aac006_ac01,'yyyymm'))) INTO sj_months from dual;
   
    
        --select akc021  INTO  zy_akc021 from xasi2.kc01    where aac001 = var_aac001;

         IF   var_aae110 = '1' and  var_aac004 = '2' and var_aac004 IS NOT NULL  THEN --  养老首次参保
                select X INTO X from dual;
         
             --  处理干部  55 4  工人 50  1  针对女性   
                 IF   sj_months > woman_worker_months  and var_aac012 = '1' THEN
                      prm_sign := '1';
                      prm_msg  := '该人员个人身份为工人，超过需要续保的年纪！';
                       GOTO label_ERROR;
                 ELSIF   sj_months >=  woman_months and  var_aac012 = '4'  THEN
                      prm_sign := '1';
                      prm_msg  := '该人员个人身份为干部，超过需要续保的年纪！';
                       GOTO label_ERROR;
                 END IF;
             
             END IF;
   
   */
    --  end  20190708

   --判断是否是单养老单位
    SELECT COUNT(1)
      INTO num_count
      FROM xasi2.ab02
     WHERE AAB001 = var_aab001
       AND AAB051 = '1';

    IF num_count = 0 THEN
    --其他基数更新为0
      UPDATE wsjb.tmp_irac01a2
         SET yac005 = 0
       WHERE iaz018 = prm_iaz018;
    END IF;

    dat_aac006 := rec_tmp_irac01a2.aac006;--出生日期
    dat_aac007 := rec_tmp_irac01a2.aac007;--参工日期
    dat_aac030 := rec_tmp_irac01a2.aac030;--本系统参保日期
    dat_yac033 := rec_tmp_irac01a2.yac033;--个人初次参保日期
    var_iaa100 := rec_tmp_irac01a2.iaa100;--申报月度
  --  SELECT TO_DATE(var_iaa100||'01','yyyy-MM-dd HH:MI:SS') INTO dat_iaa100 FROM dual;
    IF dat_aac007 > dat_aac030 THEN
      prm_msg :=  prm_msg||'首次参加工作日期不能晚于到本单位参保日期!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) > TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'到本单位参保日期不能晚于当前可申报月度'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_aac006 > dat_aac007 THEN
      prm_msg :=  prm_msg||'首次参加工作日期不能早于出生日期!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_aac006 > dat_aac030 THEN
      prm_msg :=  prm_msg||'本单位参保日期不能早于出生日期!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;


     --校验证件信息
     prc_p_ValidateAac002Continue(rec_tmp_irac01a2.yae181,     --证件类型
                                  rec_tmp_irac01a2.aac002,     --证件号码
                                  var_aab001,     --单位编号
                                  var_iaa100,     --月度
                                  var_aac001,     --个人编号
                                  prm_msg ,     -- 错误信息
                                  prm_sign,     -- 错误标志
                                  prm_AppCode,     --执行代码
                                  prm_ErrorMsg);    --出错信息
     IF prm_sign = '1' THEN

      GOTO label_ERROR;
     END IF ;

     --险种校验
     IF rec_tmp_irac01a2.aae110 = '0' AND
        rec_tmp_irac01a2.aae120 = '0' AND
        rec_tmp_irac01a2.aae210 = '0' AND
        rec_tmp_irac01a2.aae310 = '0' AND
        rec_tmp_irac01a2.aae410 = '0' AND
        rec_tmp_irac01a2.aae510 = '0' AND
        rec_tmp_irac01a2.aae311 = '0' AND
        rec_tmp_irac01a2.aae810 = '0' THEN

        prm_msg :=  prm_msg||'未获取到勾选参保的险种信息!';
        prm_sign := '1';
        GOTO label_ERROR;

     END IF;

      -- 解决多编号 有在当前编号参工商 提示险种新增 begin

       SELECT count(1) into ac01_count
           FROM xasi2.ac01
          WHERE aac001 <> var_aac001
            AND aac002  = var_aac002;

         IF    ac01_count > 0 THEN
          -- 校验在当前单位参工伤
         FOR rec_aac001 IN cur_aac001 LOOP
         select count(1) INTO ac02_count_04 from xasi2.ac02 where aac001  in (
               SELECT  aac001
           FROM xasi2.ac01
          WHERE aac001 <> var_aac001
            AND aac002  = var_aac002
            )
            and aab001 = var_aab001
            and aae140 = '04'
            and aac031 = PKG_Constant.AAC031_CBJF;

            IF  ac02_count_04 > 0 THEN
                Select aab004 INTO  var_aab004 from xasi2.ab01 where aab001 =  var_aab001;
                prm_msg := '个人编号:'||rec_aac001.aac001||'姓名:'
                                    ||rec_aac001.aac003||'身份证号:'||rec_aac001.aac002
                                    ||' 正在' ||var_aab004|| '此人已在本单位参加工伤险种，请在人员新增险种模块下操作！'||';';
                prm_sign:= '1';
            END IF ;
          END LOOP;
         END IF ;

     -- 解决多编号 有在当前编号参工商 提示险种新增 end



     -- 险种校验   201812229 begin  wangz


         --判断人员是否存在参保信息ac02,无任何职工参保信息跳过校验
         IF ( var_aae210  = '1'  or  var_aae210  = '10'    ) THEN
         INSERT INTO XASI2.TMP_AAE140(  yae099,--个人编码-->
                                         aab001,--单位编码 -->
                                         aae140,--险种-->
                                         yab139 --参保分中心-->
                                         )
                                  VALUES (var_aac001       ,--个人编码-->
                                          var_aab001 , --单位编码 -->
                                          '02', --险种-->
                                          PKG_Constant.YAB003_JBFZX  --参保分中心-->
                                         );
      END IF;
      IF (var_aae310  = '1'  or  var_aae310  = '10'   ) THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--个人编码-->
                                         aab001,--单位编码 -->
                                         aae140,--险种-->
                                         yab139 --参保分中心-->
                                         )
                                  VALUES (var_aac001       ,--个人编码-->
                                          var_aab001 , --单位编码 -->
                                          '03', --险种-->
                                          PKG_Constant.YAB003_JBFZX  --参保分中心-->
                                         );
      END IF;
      IF ( var_aae410  = '1'  or  var_aae410  = '10'  ) THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--个人编码-->
                                         aab001,--单位编码 -->
                                         aae140,--险种-->
                                         yab139 --参保分中心-->
                                         )
                                  VALUES (var_aac001       ,--个人编码-->
                                          var_aab001, --单位编码 -->
                                          '04', --险种-->
                                          PKG_Constant.YAB003_JBFZX  --参保分中心-->
                                         );
      END IF;
      IF (var_aae510  = '1'  or  var_aae510  = '10') THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--个人编码-->
                                         aab001,--单位编码 -->
                                         aae140,--险种-->
                                         yab139 --参保分中心-->
                                         )
                                  VALUES (var_aac001       ,--个人编码-->
                                          var_aab001, --单位编码 -->
                                          '05', --险种-->
                                          PKG_Constant.YAB003_JBFZX  --参保分中心-->
                                         );
      END IF;
      IF ( var_aae311 = '1'  or  var_aae311  = '10') THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--个人编码-->
                                         aab001,--单位编码 -->
                                         aae140,--险种-->
                                         yab139 --参保分中心-->
                                         )
                                  VALUES (var_aac001       ,--个人编码-->
                                          var_aab001, --单位编码 -->
                                          '07', --险种-->
                                          PKG_Constant.YAB003_JBFZX  --参保分中心-->
                                         );
      END IF;
      IF ( var_aae120 = '1'  or  var_aae120  = '10') THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--个人编码-->
                                         aab001,--单位编码 -->
                                         aae140,--险种-->
                                         yab139 --参保分中心-->
                                         )
                                  VALUES (var_aac001       ,--个人编码-->
                                          var_aab001, --单位编码 -->
                                          '06', --险种-->
                                          PKG_Constant.YAB003_JBFZX  --参保分中心-->
                                         );
      END IF;
      IF (var_aae810 = '1'  or  var_aae810  = '10' ) THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--个人编码-->
                                         aab001,--单位编码 -->
                                         aae140,--险种-->
                                         yab139 --参保分中心-->
                                         )
                                  VALUES (var_aac001       ,--个人编码-->
                                          var_aab001  , --单位编码 -->
                                          '08', --险种-->
                                          PKG_Constant.YAB003_JBFZX  --参保分中心-->
                                         );
      END IF;




         SELECT COUNT(1)
           INTO NUM_COUNT
           FROM xasi2.AC02
          WHERE AAC001 = var_aac001;

          IF (NUM_COUNT = 0 or NUM_COUNT != 0)   AND var_aac008 <> xasi2.PKG_COMM.AAC008_TX THEN
             --按单位险种循环检查个人参保信息
           FOR rec_aae140 IN cur_aae140 LOOP
               var_aae140 := rec_aae140.aae140;
               FOR rec_aac001 IN cur_aac001 LOOP
                 IF var_aae140 = '03' OR var_aae140 = '05' OR var_aae140 = '07' OR var_aae140 = '08' OR var_aae140 = '02' THEN
                   SELECT COUNT(1)
                     INTO count_repeat_zg
                     FROM xasi2.ac02
                    WHERE aac001 = rec_aac001.aac001
                      AND aae140 IN ('03','05','07','08','02')
                      AND aac031 = '1';
                   IF count_repeat_zg > 0 THEN
              Select aab004 INTO  var_aab004 from xasi2.ab01 where aab001 = (SELECT
                      distinct  aab001
                      FROM xasi2.ac02
                     WHERE aac001 = rec_aac001.aac001
                      AND aae140 IN ('03','05','07','08','02')
                       AND aac031 = '1');
                      prm_msg := '个人编号:'||rec_aac001.aac001||'姓名:'
                                    ||rec_aac001.aac003||'身份证号:'||rec_aac001.aac002
                                    ||' 正在' ||var_aab004|| '参加职工医保！说明：如参保状态为暂停缴费，请在续保模块操作；如参保状态为参保缴费，请先在原单位办理暂停缴费后，再操作续保。'||';';
                       prm_sign:= '1';
                   END IF;

                 END IF;
               END LOOP;
            END LOOP;
          END IF;


     -- 险种校验   201812229 begin  wangz

     --公务员补助险种校验
     IF rec_tmp_irac01a2.aae810 = '1' THEN

        IF rec_tmp_irac01a2.yac200 IS NULL THEN
          prm_msg :=  prm_msg||'公务员职级不能为空!';
           prm_sign := '1';
           GOTO label_ERROR;
        END IF;

     END IF;



     --基数校验
     num_aac040 := rec_tmp_irac01a2.aac040;--缴费工资
 IF rec_tmp_irac01a2.iaa100 IS NOT NULL THEN
     IF rec_tmp_irac01a2.aae110 IN  ('1','10') THEN
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,var_aab001,num_aac040,'0','01','1','1',var_iaa100,prm_yab139))
          INTO num_yac004
          FROM  dual ;
        IF ROUND(num_yac004) <> rec_tmp_irac01a2.yac004 THEN
          --企业养老基数更新
          UPDATE wsjb.tmp_irac01a2
             SET yac004 = ROUND(num_yac004)
           WHERE iaz018 = prm_iaz018
           AND   aac002 = rec_tmp_irac01a2.aac002;
        END IF;
    ELSE
     UPDATE wsjb.tmp_irac01a2
             SET yac004 = ''
           WHERE iaz018 = prm_iaz018
           AND   aac002 = rec_tmp_irac01a2.aac002;
     END IF;

     IF rec_tmp_irac01a2.aae120 = '1' THEN

        IF num_aac040 <> rec_tmp_irac01a2.yac004 THEN
          --机关养老基数更新
          UPDATE wsjb.tmp_irac01a2
             SET yac004 = num_aac040
           WHERE iaz018 = prm_iaz018
           AND   aac002 = rec_tmp_irac01a2.aac002;
        END IF;
      END IF;
     END IF;
/*
     IF rec_tmp_irac01a2.aae210 = '1' OR
        rec_tmp_irac01a2.aae310 = '1' OR
        rec_tmp_irac01a2.aae410 = '1' OR
        rec_tmp_irac01a2.aae510 = '1' OR
        rec_tmp_irac01a2.aae810 = '1' THEN
        --以一个险种为准
        SELECT aae140
          INTO var_aae140
          FROM xasi2.AB02
         WHERE aab051 = '1'
           AND (aae140 = '02' OR aae140 = '03' OR aae140 = '04' OR aae140 = '05' )
           AND aab001 = var_aab001
           AND ROWNUM = 1;
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,var_aab001,num_aac040,'0',var_aae140,'1','1',var_iaa100,prm_yab139))
          INTO num_yac005
          FROM  dual ;
        IF ROUND(num_yac005) <> rec_tmp_irac01a2.yac005 THEN
          --其他基数更新
          UPDATE tmp_irac01a2
             SET yac005 = ROUND(num_yac005),
                 yaa333 = ROUND(num_yac005)
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;   */
     --险种状态判断
/*
     --职工养老
     IF rec_tmp_irac01a2.aae110 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM IRAC01A3
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aae110 = '0';
        IF num_count > 0 THEN
          UPDATE tmp_irac01a2
             SET aae110 = '10'  --续保
           WHERE iaz018 = prm_iaz018;

        ELSE
          UPDATE tmp_irac01a2
             SET aae110 = '1'  --新增
           WHERE iaz018 = prm_iaz018;
        END IF;


     ELSIF rec_tmp_irac01a2.aae110 = '0' THEN
        --未勾选险种
        SELECT count(1)
           INTO num_count
           FROM IRAC01A3
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aae110 = '2';
         IF num_count > 0 THEN
          UPDATE tmp_irac01a2
             SET aae110 = '2'   --参保缴费
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
           FROM IRAC01A3
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aae110 = '0';
         IF num_count > 0 THEN
          UPDATE tmp_irac01a2
             SET aae110 = '0'  --暂停缴费
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;
*/
      --机关养老
     IF rec_tmp_irac01a2.aae120 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '06';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '06';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae120 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'机关养老险种不为暂停缴费状态！';
            prm_sign := '1';
            GOTO label_ERROR;
          END IF ;
        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae120 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae120 = '0' THEN
        --未勾选险种
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '06';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae120 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '06';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae120 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

     --工伤
     IF rec_tmp_irac01a2.aae410 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '04';
        IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '10'
           WHERE iaz018 = prm_iaz018;
        ELSE
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '1'
           WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae410 = '0' THEN
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '04';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '04';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;
     --失业
     IF rec_tmp_irac01a2.aae210 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '02';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '02';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae210 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'失业险种不为暂停缴费状态！';
            prm_sign := '1';
            GOTO label_ERROR;

          END IF ;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae210 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae210 = '0' THEN
        --未勾选险种
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '02';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae210 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '02';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae210 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

      --医疗
     IF rec_tmp_irac01a2.aae310 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '03';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '03';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae310 = '10'
             WHERE iaz018 = prm_iaz018;

          ELSE
            prm_msg :=  prm_msg||'医疗险种不为暂停缴费状态！';
            prm_sign := '1';
            GOTO label_ERROR;

          END IF ;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae310 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae310 = '0' THEN
        --未勾选险种
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '03';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae310 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '03';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae310 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

      --生育
     IF rec_tmp_irac01a2.aae510 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '05';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '05';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae510 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'生育险种不为暂停缴费状态！';
            prm_sign := '1';
            GOTO label_ERROR;
          END IF ;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae510 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae510 = '0' THEN
        --未勾选险种
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '05';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae510 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '05';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae510 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

      --大额
     IF rec_tmp_irac01a2.aae311 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '07';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '07';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae311 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'大额补充险种不为暂停缴费状态！';
            prm_sign := '1';
            GOTO label_ERROR;
          END IF ;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae311 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae311 = '0' THEN
        --未勾选险种
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '07';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae311 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '07';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae311 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

     --公务员补助
     IF rec_tmp_irac01a2.aae810 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '08';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '08';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae810 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'公务员补助险种不为暂停缴费状态！';
            prm_sign := '1';
            GOTO label_ERROR;
          END IF;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae810 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae810 = '0' THEN
        --未勾选险种
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '08';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae810 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '08';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae810 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;



     /*校验无误处理*/
      --续保修改户口性质
    var_aac009 := rec_tmp_irac01a2.aac009;
    IF var_aac009 = '10' THEN
      UPDATE wsjb.tmp_irac01a2
         SET aac009 = '10',
             aac013 = '2',
             yac168 = '0'
       WHERE iaz018 = prm_iaz018;

      UPDATE xasi2.ac01
         SET aac009 = '10',
             aac013 = '2',
             yac168 = '0'
       WHERE aac001 = var_aac001;



       UPDATE xasi2.ac02
          SET yac505 = '020'
        WHERE aac001 = var_aac001
          AND aae140 = '02';

    ELSIF var_aac009 = '20' THEN
      UPDATE wsjb.tmp_irac01a2
         SET aac009 = '20',
             aac013 = '3',
             yac168 = '1'
       WHERE iaz018 = prm_iaz018;

      UPDATE xasi2.ac01
         SET aac009 = '20',
             aac013 = '3',
             yac168 = '1'
       WHERE aac001 = var_aac001;

       UPDATE xasi2.ac02
          SET yac505 = '021'
        WHERE aac001 = var_aac001
          AND aae140 = '02';
    END IF;
    UPDATE wsjb.tmp_irac01a2
       SET iaa100 = ''
       WHERE iaz018 = prm_iaz018;
     /*处理失败*/
      <<label_ERROR>>

        num_count :=0;

   EXCEPTION
     WHEN OTHERS THEN
          /*关闭打开的游标*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '数据库错误！'|| SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() ;
          RETURN;
   END prc_p_ValidateContinueCheck;

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
      prm_ErrorMsg        OUT           VARCHAR2)    --出错信息

   IS
   num_count        NUMBER(6);
   num_count1       NUMBER(6);
   var_aac002Low    irac01.aac002%TYPE;
   var_15aac002     irac01.aac002%TYPE;
   var_aab001       irab01.aab001%TYPE;
   var_aac001       irac01.aac001%TYPE;
   var_akc021       irac01.akc021%TYPE;
   var_aac008       irac01.aac008%TYPE;
   var_yab013       irac01.yab013%TYPE;--原单位编号
   BEGIN
    /*初始化变量*/
      prm_AppCode  := GN_DEF_OK;
      prm_ErrorMsg := '';
      prm_msg :='';
      prm_sign :='0';
   --校验参数
      IF prm_yae181 IS NULL  THEN
         prm_msg :=  prm_msg||'传入证件类型为空，请核实。。。';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
      IF prm_aab001 IS NULL  THEN
         prm_msg :=  prm_msg||'传入单位编号为空，请核实。。。';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
      IF prm_aac002 IS NULL  THEN
         prm_msg :=  prm_msg||'传入证件号码为空，请核实。。。';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
       --身份证类型
     IF prm_yae181 = 1 THEN
        --获取各种形式的证件号码
         var_15aac002 := SUBSTR(prm_aac002,1,6)||SUBSTR(prm_aac002,9, 9);
         var_aac002Low := LOWER(prm_aac002);

        SELECT count(1)
          INTO num_count
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
           AND AAC003 NOT LIKE '%重复%';

        IF num_count = 0 THEN
           prm_msg := '证件号为：['||prm_aac002||']的人员不存在个人信息，请在新参保模块里操作1！';
           prm_sign :='1';
           GOTO label_ERROR ;
        END IF ;
/*        IF num_count > 1 THEN
           prm_msg := '证件号为：['||prm_aac002||']的人员存在多条个人信息，请在联系社保中心！';
           prm_sign :='1';
           GOTO label_ERROR ;
        END IF ;
*/

        SELECT aac001,
               aac008
          INTO var_aac001,
               var_aac008
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.AAC001=prm_aac001
           AND AAC003 NOT LIKE '%重复%';

             --判断此人在本单位是否是正常参保状态
       SELECT SUM(count)
        INTO num_count
        FROM (SELECT count(*) AS count
        FROM xasi2.ac02
        WHERE aac001 =prm_aac001
        AND aab001 = prm_aab001
        AND aac031='1'
    --    AND aae140<>'04'
        UNION
        SELECT count(1) AS count
        FROM wsjb.irac01a3
        WHERE aac002 = prm_aac002
        AND aab001 = prm_aab001
        AND aae110 = '2');
        IF num_count = 0 THEN
         prm_msg := '此人在本单位没有正常参保的险种，请到续保模块操作！';
         prm_sign :='1';
         GOTO label_ERROR ;
          END IF;

   ELSE
        SELECT count(1)
          INTO num_count
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.AAC002 = prm_aac002
           AND AAC003 NOT LIKE '%重复%';

        IF num_count = 0 THEN
           prm_msg := '证件号为：['||prm_aac002||']的人员不存在个人信息，请在新参保模块里操作2！';
           prm_sign :='1';
           GOTO label_ERROR ;
        END IF ;
       /* IF num_count > 1 THEN
           prm_msg := '证件号为：['||prm_aac002||']的人员存在多条个人信息，请在联系社保中心！';
           prm_sign :='1';
           GOTO label_ERROR ;
        END IF ;*/

        SELECT aac001,
               aac008
          INTO var_aac001,
               var_aac008
          FROM xasi2.ac01 A
         WHERE AAE120 = '0'
           AND A.AAC001 = prm_aac001
           AND AAC003 NOT LIKE '%重复%';
     END IF;
  SELECT count(1) INTO num_count FROM xasi2.kc01 WHERE aac001 = prm_aac001;

  IF num_count >0 THEN--单工伤人员新增险种加入num_count大于0
        SELECT A.AKC021
          INTO var_akc021
          FROM xasi2.KC01 A
         WHERE A.AAC001 = prm_aac001;
       IF var_aac008 = '2' AND var_akc021 = '11' THEN
           prm_msg := '证件号为：['||prm_aac002||']的人员正在办理待退业务,不能办理续保手续，如要办理联系社保中心！';
          prm_sign :='1';
          GOTO label_ERROR ;
       END IF;
END IF;


       --在别的单位是否有参保缴费记录
       SELECT SUM(COUNT1)
         INTO num_count
         FROM (SELECT COUNT(*) AS COUNT1
                  FROM xasi2.ac01 A, xasi2.ac02 B
                 WHERE A.AAC001 = B.AAC001
                   AND A.AAE120 = '0'
                   AND B.AAC031 = '1'
                   AND B.AAE140 <> '04'
                   AND A.AAC001 = prm_aac001
                   AND B.AAB001 <> prm_aab001
                UNION
                SELECT COUNT(1) AS COUNT1
                  FROM wsjb.irac01a3
                 WHERE AAB001 <> prm_aab001
                   AND AAC001 = prm_aac001
                   AND AAE110 = '2');
      IF num_count = 0 THEN
        SELECT count(1)
          INTO num_count
          FROM wsjb.irac01
         WHERE AAC001 = prm_aac001
           AND IAA001 = '4'
           AND IAA002 = '1';
        IF num_count > 0 THEN
          prm_msg := '此人存在待审核的“人员重要信息变更”申请,请提示本人尽快携带相关资料到社保中心进行审核办理。办理成功后，方可进行续保操作！';
          prm_sign :='1';
          GOTO label_ERROR ;
        END IF;


      ELSE
        SELECT COUNT(1) AS COUNT1
          INTO num_count
          FROM xasi2.ac01 A, xasi2.ac02 B
         WHERE A.AAC001 = B.AAC001
           AND A.AAE120 = '0'
           AND B.AAC031 = '1'
           AND B.AAE140 = '04'
           AND A.AAC001 = prm_aac001
           AND B.AAB001 = prm_aab001;
         IF num_count > 0 THEN
             prm_msg := '此人在其他单位有险种未做暂停，且在本单位已参工伤险种！';
            prm_sign :='1';
            GOTO label_ERROR ;
         END IF;

        SELECT COUNT(*) AS COUNT1
          INTO num_count
          FROM xasi2.ac01 A, xasi2.ac02 B, xasi2.ab01 C
         WHERE A.AAC001 = B.AAC001
           AND B.AAB001 = C.AAB001
           AND A.AAE120 = '0'
           AND B.AAC031 = '1'
           AND B.AAE140 IN ('03', '07')
           AND A.AAC001 = prm_aac001
           AND C.YAB136 = '001';
        IF num_count > 0 THEN
           prm_msg := '此人在人事代理机构有险种未做暂停,请暂停后再续保！';
           prm_sign :='1';
           GOTO label_ERROR ;
        END IF;

      prm_msg := '此人在其他单位有险种未做暂停,本单位只能参保工伤险！';
      prm_sign :='2';
      GOTO label_ERROR ;
      END IF;

      SELECT SUM(I)
        INTO num_count
        FROM (SELECT COUNT(1) AS I
                FROM xasi2.ac08 A, wsjb.irab01a5  B
               WHERE A.AAB001 = B.AAB001
                 AND AAC001 = prm_aac001
                 AND AAE140 = '03'
                 AND AAE002 = prm_iaa100
              UNION
              SELECT COUNT(1) AS I
                FROM xasi2.ac08a1 A, wsjb.irab01a5  B
               WHERE A.AAB001 = B.AAB001
                 AND AAC001 = prm_aac001
                 AND AAE140 = '03'
                 AND AAE002 = prm_iaa100);
      IF num_count > 0 THEN
         prm_msg := '此人'||prm_iaa100||'存在医疗缴费记录信息,不能续保。详细请咨询社保中心!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

       SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 IN ('3','7')
         AND A.IAA002 = '0'
         AND A.AAC002 = prm_aac002;
      IF num_count > 0 THEN
         prm_msg := '此人存在待申报的暂停信息,请先办理申报业务!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '0'
         AND A.AAC001 = prm_aac001;
      IF num_count > 0 THEN
         prm_msg := '此人存在待申报的续保信息,请先办理申报业务!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '1'
         AND A.AAC001 = prm_aac001;
      IF num_count > 0 THEN
         prm_msg := '此人存在已申报的续保信息,请等待审核通过!!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '8'
         AND A.IAA002 = '4'
         AND A.AAC001 = prm_aac001;
      IF num_count > 0 THEN
         prm_msg := '此人存在被打回的续保信息,请到[月申报]功能下修改相关信息继续申报!!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '5'
         AND A.IAA002 = '0'
         AND A.AAC001 = prm_aac001;
      IF num_count > 0 THEN
         prm_msg := '此人存在待申报的险种新增信息,请先办理申报业务!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 = '5'
         AND A.IAA002 = '1'
         AND A.AAC001 = prm_aac001;
      IF num_count > 0 THEN
         prm_msg := '此人存在已申报的险种新增信息,请等待审核通过!';
         prm_sign :='1';
         GOTO label_ERROR ;
      END IF;

      SELECT COUNT(1)
        INTO num_count
        FROM wsjb.irac01  A
       WHERE A.IAA001 IN ('3', '7', '9', '10')
         AND A.IAA002 = '2'
         AND A.AAC001 = prm_aac001
         AND A.IAA100 = prm_iaa100;
      IF num_count > 0 THEN
        SELECT aab001
          INTO var_yab013
          FROM wsjb.irac01  A
         WHERE A.IAA001 IN ('3', '7', '9', '10')
           AND A.IAA002 = '2'
           AND A.AAC001 = prm_aac001
           AND A.IAA100 = prm_iaa100
           AND ROWNUM = 1;

        SELECT SUM(I) as i
          INTO num_count
          FROM (SELECT COUNT(1) I
                  FROM xasi2.ab08
                 WHERE AAB001 = var_yab013
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01'
                UNION ALL
                SELECT COUNT(1) I
                  FROM xasi2.ab08a8
                 WHERE AAB001 = var_yab013
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01'
                UNION ALL
                SELECT COUNT(1) I
                  FROM wsjb.irab08
                 WHERE AAB001 = var_yab013
                   AND AAE003 = prm_iaa100
                   AND YAE517 = 'H01');
  /***
       IF num_count > 0 THEN
          prm_msg := '此人存在待审核的人员减少信息，不能办理续保,请等待审核通过!';
         prm_sign :='1';
         GOTO label_ERROR ;
       END IF;
***/

      END IF;



      /*处理失败*/
      <<label_ERROR>>

       num_count :=0;
  EXCEPTION
     WHEN OTHERS THEN
          /*关闭打开的游标*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '数据库错误！'|| SQLERRM||dbms_utility.format_error_backtrace ;
          RETURN;
   END prc_p_ValidateAac002KindAdd;

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
      prm_ErrorMsg        OUT           VARCHAR2)    --出错信息
  IS
   num_count        NUMBER(6);
   rec_tmp_irac01a2 tmp_irac01a2%ROWTYPE;
   dat_aac006       DATE ;--出生日期
   dat_aac007       DATE ;--参工日期
   dat_aac030       DATE ;--本系统参保日期
   dat_yac033       DATE ;--个人初次参保日期
   var_aab001       irab01.aab001%TYPE;
   var_aae140       irab02.aae140%TYPE;
   num_aac040       NUMBER(14,2); --缴费工资
   num_yac004       NUMBER(14,2); --养老基数
   num_yac005       NUMBER(14,2); --其他基数
   var_iaa100       VARCHAR2(6);  --申报月度
   var_aac001       irac01.aac001%TYPE;
   var_aac009       irac01.aac009%TYPE;  --户口性质
   BEGIN
   /*初始化变量*/
     prm_AppCode  := GN_DEF_OK;
     prm_ErrorMsg := '';
     prm_msg :='';
     prm_sign :='0';



     SELECT *
     INTO rec_tmp_irac01a2
     FROM wsjb.tmp_irac01a2
    WHERE iaz018 = prm_iaz018;
     --校验参数
    IF prm_iaz018 IS NULL  THEN
      prm_msg :=  prm_msg||'传入校验流水号为空，请核实。。。';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    var_aab001 := rec_tmp_irac01a2.aab001;
    var_aac001 := rec_tmp_irac01a2.aac001;

   --判断是否是单养老单位
    SELECT COUNT(1)
      INTO num_count
      FROM xasi2.ab02
     WHERE AAB001 = var_aab001
       AND AAB051 = '1';

    IF num_count = 0 THEN
    --其他基数更新为0
      UPDATE wsjb.tmp_irac01a2
         SET yac005 = 0
       WHERE iaz018 = prm_iaz018;
    END IF;

    dat_aac006 := rec_tmp_irac01a2.aac006;--出生日期
    dat_aac007 := rec_tmp_irac01a2.aac007;--参工日期
    dat_aac030 := rec_tmp_irac01a2.aac030;--本系统参保日期
    dat_yac033 := rec_tmp_irac01a2.yac033;--个人初次参保日期
    var_iaa100 := rec_tmp_irac01a2.iaa100;--申报月度

    IF dat_aac007 > dat_aac030 THEN
      prm_msg :=  prm_msg||'首次参加工作日期不能晚于到本单位参保日期!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
--    IF dat_aac030 > SYSDATE THEN
--      prm_msg :=  prm_msg||'到本单位参保日期不能晚于系统日期'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||'!';
--      prm_sign := '1';
--      GOTO label_ERROR;
--    END IF;
    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) > TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'到本单位参保日期不能晚于当前可申报月度'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_aac006 > dat_aac007 THEN
      prm_msg :=  prm_msg||'首次参加工作日期不能早于出生日期!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF dat_aac006 > dat_aac030 THEN
      prm_msg :=  prm_msg||'本单位参保日期不能早于出生日期!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;


     --校验证件信息
     prc_p_ValidateAac002KindAdd(rec_tmp_irac01a2.yae181,     --证件类型
                                  rec_tmp_irac01a2.aac002,     --证件号码
                                  var_aab001,     --单位编号
                                  var_iaa100,     --月度
                                  var_aac001,     --个人编号
                                  prm_msg ,     -- 错误信息
                                  prm_sign,     -- 错误标志
                                  prm_AppCode,     --执行代码
                                  prm_ErrorMsg);    --出错信息
     IF prm_sign = '1' THEN

      GOTO label_ERROR;
     END IF ;

     --险种校验
     IF rec_tmp_irac01a2.aae110 = '0' AND
        rec_tmp_irac01a2.aae120 = '0' AND
        rec_tmp_irac01a2.aae210 = '0' AND
        rec_tmp_irac01a2.aae310 = '0' AND
        rec_tmp_irac01a2.aae410 = '0' AND
        rec_tmp_irac01a2.aae510 = '0' AND
        rec_tmp_irac01a2.aae311 = '0' AND
        rec_tmp_irac01a2.aae810 = '0' THEN

        prm_msg :=  prm_msg||'未获取到勾选参保的险种信息!';
        prm_sign := '1';
        GOTO label_ERROR;

     END IF;
     --公务员补助险种校验
     IF rec_tmp_irac01a2.aae810 = '1' THEN

        IF rec_tmp_irac01a2.yac200 IS NULL THEN
          prm_msg :=  prm_msg||'公务员职级不能为空!';
           prm_sign := '1';
           GOTO label_ERROR;
        END IF;

     END IF;



/*     --基数校验
     num_aac040 := rec_tmp_irac01a2.aac040;--缴费工资

     IF rec_tmp_irac01a2.aae110 IN ('1','10') THEN
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,var_aab001,num_aac040,'0','01','1','1',var_iaa100,prm_yab139))
          INTO num_yac004
          FROM  dual ;
        IF ROUND(num_yac004) <> rec_tmp_irac01a2.yac004 THEN

          --企业养老基数更新
          UPDATE tmp_irac01a2
             SET yac004 = ROUND(num_yac004)
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;

     IF rec_tmp_irac01a2.aae120 = '1' THEN

        IF num_aac040 <> rec_tmp_irac01a2.yac004 THEN
          --机关养老基数更新
          UPDATE tmp_irac01a2
             SET yac004 = num_aac040
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;

     IF rec_tmp_irac01a2.aae210 = '1' OR
        rec_tmp_irac01a2.aae310 = '1' OR
        rec_tmp_irac01a2.aae410 = '1' OR
        rec_tmp_irac01a2.aae510 = '1' OR
        rec_tmp_irac01a2.aae810 = '1' THEN
        --以一个险种为准
        SELECT aae140
          INTO var_aae140
          FROM xasi2.AB02
         WHERE aab051 = '1'
           AND (aae140 = '02' OR aae140 = '03' OR aae140 = '04' OR aae140 = '05' )
           AND aab001 = var_aab001
           AND ROWNUM = 1;
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,var_aab001,num_aac040,'0',var_aae140,'1','1',var_iaa100,prm_yab139))
          INTO num_yac005
          FROM  dual ;
        IF ROUND(num_yac005) <> rec_tmp_irac01a2.yac005 THEN
          --其他基数更新
          UPDATE tmp_irac01a2
             SET yac005 = ROUND(num_yac005),
                 yaa333 = ROUND(num_yac005)
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;  */
     --险种状态判断

     --职工养老
     IF rec_tmp_irac01a2.aae110 = '1' THEN
         UPDATE wsjb.tmp_irac01a2
             SET aae110 = '1'  --新参保
           WHERE iaz018 = prm_iaz018;


    ELSIF rec_tmp_irac01a2.aae110 = '10' THEN
      UPDATE wsjb.tmp_irac01a2
             SET aae110 = '10'  --续保
           WHERE iaz018 = prm_iaz018;
     ELSIF rec_tmp_irac01a2.aae110 = '0' THEN
        --未勾选险种
        SELECT count(1)
           INTO num_count
           FROM wsjb.irac01a3
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aae110 = '2';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae110 = '2'   --参保缴费
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
           FROM wsjb.irac01a3
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aae110 = '0';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae110 = '0'  --暂停缴费
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;

      --机关养老
     IF rec_tmp_irac01a2.aae120 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '06';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '06';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae120 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'机关养老险种不为暂停缴费状态！';
            prm_sign := '1';
            GOTO label_ERROR;
          END IF ;
        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae120 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae120 = '0' THEN
        --未勾选险种
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '06';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae120 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '06';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae120 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

     --工伤
     IF rec_tmp_irac01a2.aae410 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '04';
        IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '10'
           WHERE iaz018 = prm_iaz018;
        ELSE
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '1'
           WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae410 = '0' THEN
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '04';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '04';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;
     --失业
     IF rec_tmp_irac01a2.aae210 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '02';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '02';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae210 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'失业险种不为暂停缴费状态！';
            prm_sign := '1';
            GOTO label_ERROR;

          END IF ;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae210 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae210 = '0' THEN
        --未勾选险种
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '02';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae210 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '02';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae210 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

      --医疗
     IF rec_tmp_irac01a2.aae310 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '03';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '03';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae310 = '10'
             WHERE iaz018 = prm_iaz018;

          ELSE
            prm_msg :=  prm_msg||'医疗险种不为暂停缴费状态！';
            prm_sign := '1';
            GOTO label_ERROR;

          END IF ;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae310 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae310 = '0' THEN
        --未勾选险种
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '03';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae310 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '03';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae310 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

      --生育
     IF rec_tmp_irac01a2.aae510 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '05';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '05';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae510 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'生育险种不为暂停缴费状态！';
            prm_sign := '1';
            GOTO label_ERROR;
          END IF ;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae510 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae510 = '0' THEN
        --未勾选险种
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '05';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae510 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '05';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae510 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

      --大额
     IF rec_tmp_irac01a2.aae311 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '07';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '07';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae311 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'大额补充险种不为暂停缴费状态！';
            prm_sign := '1';
            GOTO label_ERROR;
          END IF ;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae311 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae311 = '0' THEN
        --未勾选险种
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '07';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae311 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '07';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae311 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;

     --公务员补助
     IF rec_tmp_irac01a2.aae810 = '1' THEN
         SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aac001 = rec_tmp_irac01a2.aac001
            AND aae140 = '08';
        IF num_count > 0 THEN
          SELECT count(1)
             INTO num_count
             FROM xasi2.ac02
            WHERE aac001 = rec_tmp_irac01a2.aac001
              AND aac031 = '2'
              AND aae140 = '08';
          IF num_count > 0 THEN
            UPDATE wsjb.tmp_irac01a2
               SET aae810 = '10'
             WHERE iaz018 = prm_iaz018;
          ELSE
            prm_msg :=  prm_msg||'公务员补助险种不为暂停缴费状态！';
            prm_sign := '1';
            GOTO label_ERROR;
          END IF;

        ELSE
          UPDATE wsjb.tmp_irac01a2
               SET aae810 = '1'
             WHERE iaz018 = prm_iaz018;
        END IF;
     ELSIF rec_tmp_irac01a2.aae810 = '0' THEN
        --未勾选险种
        SELECT count(1)
           INTO num_count
           FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '1'
            AND aae140 = '08';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae810 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;

        SELECT count(1)
           INTO num_count
         FROM xasi2.ac02
          WHERE aab001 = var_aab001
            AND aac001 = rec_tmp_irac01a2.aac001
            AND aac031 = '2'
            AND aae140 = '08';
         IF num_count > 0 THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae810 = '21'
           WHERE iaz018 = prm_iaz018;
        END IF;
     END IF;



     /*校验无误处理*/
      --续保修改户口性质
    var_aac009 := rec_tmp_irac01a2.aac009;
    IF var_aac009 = '10' THEN
      UPDATE wsjb.tmp_irac01a2
         SET aac009 = '10',
             aac013 = '2',
             yac168 = '0'
       WHERE iaz018 = prm_iaz018;

      UPDATE xasi2.ac01
         SET aac009 = '10',
             aac013 = '2',
             yac168 = '0'
       WHERE aac001 = var_aac001;



       UPDATE xasi2.ac02
          SET yac505 = '020'
        WHERE aac001 = var_aac001
          AND aae140 = '02';

    ELSIF var_aac009 = '20' THEN
      UPDATE wsjb.tmp_irac01a2
         SET aac009 = '20',
             aac013 = '3',
             yac168 = '1'
       WHERE iaz018 = prm_iaz018;

      UPDATE xasi2.ac01
         SET aac009 = '20',
             aac013 = '3',
             yac168 = '1'
       WHERE aac001 = var_aac001;

       UPDATE xasi2.ac02
          SET yac505 = '021'
        WHERE aac001 = var_aac001
          AND aae140 = '02';
    END IF;
    UPDATE wsjb.tmp_irac01a2
         SET iaa100=''
       WHERE iaz018 = prm_iaz018;
     /*处理失败*/
      <<label_ERROR>>

        num_count :=0;

   EXCEPTION
     WHEN OTHERS THEN
          /*关闭打开的游标*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '数据库错误！'|| SQLERRM ;
          RETURN;
   END prc_p_ValidateKindAddCheck;

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
      prm_ErrorMsg        OUT           VARCHAR2)    --出错信息
  IS
   num_count        NUMBER(6);
   rec_tmp_irac01a4 tmp_irac01a4%ROWTYPE;
   dat_aac006       DATE ;--出生日期
   dat_aac007       DATE ;--参工日期
   dat_aac030       DATE ;--本系统参保日期
   dat_yac033       DATE ;--个人初次参保日期
   var_aab001       irab01.aab001%TYPE;
   var_aae140       irab02.aae140%TYPE;
   num_aac040       NUMBER(14,2); --缴费工资
   num_yac004       NUMBER(14,2); --养老基数
   num_yac005       NUMBER(14,2); --其他基数
   var_iaa100       VARCHAR2(6);  --申报月度
   var_aac001       irac01.aac001%TYPE;
   var_aac009       irac01.aac009%TYPE;  --户口性质
   dat_iaa100        DATE;
   BEGIN
   /*初始化变量*/
     prm_AppCode  := GN_DEF_OK;
     prm_ErrorMsg := '';
     prm_msg :='';
     prm_sign :='0';
       --校验参数
    IF prm_iaz018 IS NULL  THEN
      prm_msg :=  prm_msg||'传入校验流水号为空，请核实。。。';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
     --校验参数
    IF prm_aac001 IS NULL  THEN
      prm_msg :=  prm_msg||'传入个人编号为空，请核实。。。';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

      SELECT *
     INTO rec_tmp_irac01a4
     FROM wsjb.tmp_irac01a4
    WHERE iaz018 = prm_iaz018
      AND aac001 = prm_aac001;


    var_aab001 := rec_tmp_irac01a4.aab001;
    var_aac001 := prm_aac001;

    dat_aac030 := rec_tmp_irac01a4.aac030;
    var_iaa100 := rec_tmp_irac01a4.iaa100;
    SELECT TO_DATE(rec_tmp_irac01a4.iaa100||'01','yyyy-MM-dd HH:MI:SS') INTO dat_iaa100 FROM dual;
    IF dat_aac030 > dat_iaa100 THEN
      prm_msg :=  prm_msg||'停保日期不能晚于申报月度'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) > TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'停保日期不能晚于当前可申报月度'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) <> TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'停保月度和申报月度不一致'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --是否已经存在申报记录
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '0'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'该人员已存在待申报信息!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --是否已经存在申报记录
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '1'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'该人员已存在申报信息!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
  --是否已经存在申报记录
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '4'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'该人员已存在打回的申报信息，请到月申报功能下操作，不能再做减少！';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --是否已经存在申报记录

    IF rec_tmp_irac01a4.aae013 = '251' THEN
      prm_msg :=  prm_msg||'人员在职转退休请到专用的模块下进行！';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;


   --暂停缴费基数
    IF rec_tmp_irac01a4.aae110 = '2' THEN
        SELECT yac004
          INTO num_yac004
          FROM wsjb.irac01a3
         WHERE aac001 = var_aac001
           AND aab001 = var_aab001
           AND aae110 = '2';


          --企业养老基数更新
          UPDATE wsjb.tmp_irac01a4
             SET yac004 = ROUND(num_yac004),
                 aae110 = '3'
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;

   --  ELSIF rec_tmp_irac01a4.aae110 = '0' THEN
          --企业养老基数更新
    --      UPDATE tmp_irac01a4
    --         SET yac004 = '',
    --             aae110 = '0'
    --       WHERE aac001 = var_aac001
     --      AND aab001 = var_aab001;
     END IF;

     IF rec_tmp_irac01a4.aae120 = '2' THEN
        SELECT yac004
          INTO num_yac004
          FROM xasi2.ac02
         WHERE aac001 = var_aac001
           AND aab001 = var_aab001
           AND aac031 = '1'
           AND aae140 = '06';

          --机关养老基数更新
          UPDATE wsjb.tmp_irac01a4
             SET yac004 = num_aac040,
                 aae120 = '3'
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;


     END IF;

     IF rec_tmp_irac01a4.aae210 = '2' OR
        rec_tmp_irac01a4.aae310 = '2' OR
        rec_tmp_irac01a4.aae410 = '2' OR
        rec_tmp_irac01a4.aae510 = '2' OR
        rec_tmp_irac01a4.aae311 = '2' OR
        rec_tmp_irac01a4.aae810 = '2' OR
        rec_tmp_irac01a4.aae120 = '2' THEN
        --以一个险种为准
        SELECT yac004
          INTO num_yac005
          FROM xasi2.Ac02
         WHERE aac031 = '1'
           AND (aae140 = '02' OR aae140 = '03' OR aae140 = '04' OR aae140 = '05' )
           AND aab001 = var_aab001
           AND aac001 = var_aac001
           AND ROWNUM = 1;


          --其他基数更新
          UPDATE wsjb.tmp_irac01a4
             SET yac005 = ROUND(num_yac005),
                 yaa333 = ROUND(num_yac005)
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;


        --正常参保的险种变更成减少
        IF rec_tmp_irac01a4.aae210 = '2' THEN
          UPDATE wsjb.tmp_irac01a4
             SET aae210 = '3'
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;
        END IF;
        IF rec_tmp_irac01a4.aae310 = '2' THEN
          UPDATE wsjb.tmp_irac01a4
             SET aae310 = '3'
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;
        END IF;
        IF rec_tmp_irac01a4.aae410 = '2' THEN
          UPDATE wsjb.tmp_irac01a4
             SET aae410 = '3'
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;
        END IF;
        IF rec_tmp_irac01a4.aae510 = '2' THEN
          UPDATE wsjb.tmp_irac01a4
             SET aae510 = '3'
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;
        END IF;
        IF rec_tmp_irac01a4.aae311 = '2' THEN
          UPDATE wsjb.tmp_irac01a4
             SET aae311 = '3'
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;
        END IF;
        IF rec_tmp_irac01a4.aae810 = '2' THEN
          UPDATE wsjb.tmp_irac01a4
             SET aae810 = '3'
           WHERE aac001 = var_aac001
           AND aab001 = var_aab001;
        END IF;

     END IF;
     UPDATE wsjb.tmp_irac01a4  SET iaa100=''
            WHERE aac001 = var_aac001
           AND aab001 = var_aab001;
     /*处理失败*/
      <<label_ERROR>>
        num_count :=0;

  EXCEPTION
     WHEN OTHERS THEN
          /*关闭打开的游标*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '数据库错误！'|| SQLERRM ;

          RETURN;
  END prc_p_ValidateReduceCheck;
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
      prm_ErrorMsg        OUT           VARCHAR2)    --出错信息
   IS
   num_count        NUMBER(6);
   rec_tmp_irac01a4 tmp_irac01a4%ROWTYPE;
   dat_aac006       DATE ;--出生日期
   dat_aac007       DATE ;--参工日期
   dat_aac030       DATE ;--本系统参保日期
   dat_yac033       DATE ;--个人初次参保日期
   var_aab001       irac01.aab001%TYPE;
   var_aae140       irab02.aae140%TYPE;
   num_aac040       NUMBER(14,2); --缴费工资
   num_yac004       NUMBER(14,2); --养老基数
   num_yac005       NUMBER(14,2); --其他基数
   var_iaa100       VARCHAR2(6);  --申报月度
   var_aac001       irac01.aac001%TYPE;
   var_aac009       irac01.aac009%TYPE;  --户口性质
   var_yae181       irac01.yae181%TYPE;
   var_aac004       irac01.aac004%TYPE;
   var_yac168       irac01.yac168%TYPE;


   var_aae110       irac01.aae110%TYPE;--职工养老
   var_aae120       irac01.aae120%TYPE;--机关养老
   var_aae210       irac01.aae210%TYPE;--失业
   var_aae310       irac01.aae310%TYPE;--医疗
   var_aae410       irac01.aae410%TYPE;--工伤
   var_aae510       irac01.aae510%TYPE;--生育
   var_aae311       irac01.aae311%TYPE;--大额
   var_aae810       irac01.aae810%TYPE;--公务员补助

   cursor cur_tmp_irac01a4 IS
   SELECT iaz018,
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
          akc021,
          ykc150,
          ykb109,
          aic162,
          yac005,
          aae100,
          errormsg,
          aac021,
          aac022,
          aac025,
          aac026,
          aae810,
          iaa100,
          aae009,
          aae008,
          aae010,
          yad050
     FROM wsjb.tmp_irac01a4
    WHERE iaz018 = prm_iaz018;


   BEGIN
   /*初始化变量*/
     prm_AppCode  := GN_DEF_OK;
     prm_ErrorMsg := '';
     prm_msg :='';
     prm_sign :='0';
    --校验参数
    IF prm_iaz018 IS NULL  THEN
      prm_AppCode  := GN_DEF_ERR;
      prm_ErrorMsg :=  prm_msg||'传入校验流水号iaz018为空，请核实。。。';
      RETURN;
    END IF;
    FOR rec_tmp_irac01a4 IN cur_tmp_irac01a4 LOOP
    --养老校验是否通过
     IF rec_tmp_irac01a4.errormsg IS NOT  NULL  THEN
       prm_sign := '1';
       prm_msg := rec_tmp_irac01a4.errormsg;
       GOTO label_ERROR;
      RETURN;
    END IF;
     --查询个人编号
     SELECT count(1)
        INTO num_count
        FROM xasi2.ac01
       WHERE aac002 = rec_tmp_irac01a4.aac002
         AND aac003 = rec_tmp_irac01a4.aac003
         AND aae120 = '0';
     IF num_count <> 1 THEN
        prm_msg :=  prm_msg||rec_tmp_irac01a4.aac002||'人员信息没有找到，请核对信息！';
       prm_sign := '1';
       GOTO label_ERROR;
     END IF ;
      SELECT aac001
        INTO var_aac001
        FROM xasi2.ac01
       WHERE aac002 = rec_tmp_irac01a4.aac002
         AND aac003 = rec_tmp_irac01a4.aac003;

      UPDATE wsjb.tmp_irac01a4
         SET aac001 = var_aac001
       WHERE iaz018 = prm_iaz018
         AND aac002 = rec_tmp_irac01a4.aac002
         AND aac003 = rec_tmp_irac01a4.aac003;

     var_aab001 := rec_tmp_irac01a4.aab001;

      --查询参保信息
      SELECT count(1)
        INTO num_count
        FROM xasi2.AC01 A, xasi2.AC02 B
       WHERE A.AAC001 = B.AAC001
         AND A.AAC008 = '1'
         AND B.AAC031 = '1'
         AND B.AAB001 = var_aab001
         AND A.AAC001 = var_aac001;
      IF num_count > 0 THEN
        SELECT DISTINCT a.YAE181 AS YAE181,
                        a.aac004 as aac004,
                        a.aac009 as aac009,
                        a.yac168 as yac168,
                        (SELECT AAE110
                           FROM wsjb.irac01a3
                          WHERE AAC001 = A.AAC001
                            AND AAB001 = var_aab001) AAE110,
                        (SELECT DECODE(AAC031, '1', '2', '2', '21', '3', '')
                           FROM xasi2.AC02
                          WHERE AAC001 = A.AAC001
                            AND AAB001 = var_aab001
                            AND AAE140 = '06') AAE120,
                        (SELECT DECODE(AAC031, '1', '2', '2', '21', '3', '')
                           FROM xasi2.AC02
                          WHERE AAC001 = A.AAC001
                            AND AAB001 = var_aab001
                            AND AAE140 = '02') AAE210,
                        (SELECT DECODE(AAC031, '1', '2', '2', '21', '3', '')
                           FROM xasi2.AC02
                          WHERE AAC001 = A.AAC001
                            AND AAB001 = var_aab001
                            AND AAE140 = '03') AAE310,
                        (SELECT DECODE(AAC031, '1', '2', '2', '21', '3', '')
                           FROM xasi2.AC02
                          WHERE AAC001 = A.AAC001
                            AND AAB001 = var_aab001
                            AND AAE140 = '04') AAE410,
                        (SELECT DECODE(AAC031, '1', '2', '2', '21', '3', '')
                           FROM xasi2.AC02
                          WHERE AAC001 = A.AAC001
                            AND AAB001 = var_aab001
                            AND AAE140 = '05') AAE510,
                        (SELECT DECODE(AAC031, '1', '2', '2', '21', '3', '')
                           FROM xasi2.AC02
                          WHERE AAC001 = A.AAC001
                            AND AAB001 = var_aab001
                            AND AAE140 = '07') AAE311,
                        (SELECT DECODE(AAC031, '1', '2', '2', '21', '3', '')
                           FROM xasi2.AC02
                          WHERE AAC001 = A.AAC001
                            AND AAB001 = var_aab001
                            AND AAE140 = '08') AAE810
          INTO
                var_yae181,
                var_aac004,
                var_aac009,
                var_yac168,
                var_aae110,
                var_aae120,
                var_aae210,
                var_aae310,
                var_aae410,
                var_aae510,
                var_aae311,
                var_aae810
          FROM xasi2.AC01 A, xasi2.AC02 B
         WHERE A.AAC001 = B.AAC001
           AND B.AAB001 = var_aab001
           AND B.AAC031 = '1'
           AND A.AAC008 = '1'
           AND A.AAC001 = var_aac001;
      ELSE
        SELECT count(1)
          INTO num_count
          FROM xasi2.AC01 A, wsjb.irac01a3  B
         WHERE A.AAC001 = B.AAC001
           AND A.AAC008 = '1'
           AND B.AAE110 = '2'
           AND B.AAB001 = var_aab001
           AND A.AAC001 = var_aac001;
        IF num_count = 1 THEN
          select DISTINCT a.YAE181 AS YAE181,
                          a.aac004 as aac004,
                          a.aac009 as aac009,
                          a.yac168 as yac168,
                          b.aae110 as aae110,
                          '0' as aae120,
                          '0' as aae210,
                          '0' as aae310,
                          '0' as aae410,
                          '0' as aae510,
                          '0' as aae311,
                          '0' as aae810
                    INTO  var_yae181,
                          var_aac004,
                          var_aac009,
                          var_yac168,
                          var_aae110,
                          var_aae120,
                          var_aae210,
                          var_aae310,
                          var_aae410,
                          var_aae510,
                          var_aae311,
                          var_aae810
                     from xasi2.ac01 a,wsjb.irac01a3  b
                    where  a.aac001 = b.aac001
                      and b.aab001 = var_aab001
                      and b.aae110 = '2'
                      and a.aac008 = '1'
                      and a.aac001 = var_aac001;
        ELSE
          prm_msg :=  prm_msg||rec_tmp_irac01a4.aac002||'人员没有参保险种！';
          prm_sign := '1';
          GOTO label_ERROR;
        END IF;

      END IF;
      --更新校验必要信息
      UPDATE wsjb.tmp_irac01a4
         SET yae181 = var_yae181,
             aac004 = var_aac004,
             aac009 = var_aac009,
             yac168 = var_yac168,
             aae110 = var_aae110,
             aae120 = var_aae120,
             aae210 = var_aae210,
             aae310 = var_aae310,
             aae410 = var_aae410,
             aae510 = var_aae510,
             aae311 = var_aae311,
             aae810 = var_aae810
       WHERE iaz018 = prm_iaz018
         AND aac001 =var_aac001;

      prc_p_ValidateReduceCheck(prm_iaz018  ,     --批次号
                                 var_aac001  ,     --个人编号
                                prm_yab139  ,     --经办机构
                                prm_msg     ,     -- 错误信息
                                prm_sign    ,     -- 错误标志
                                prm_AppCode ,     --执行代码
                                prm_ErrorMsg);    --出错信息
      IF prm_sign <> '0' THEN
          prm_msg :=  prm_msg;
          prm_sign := '1';
          GOTO label_ERROR;
      END IF;

    <<label_ERROR>>
    UPDATE wsjb.tmp_irac01a4
       SET aae100 = '1',
           errormsg = prm_msg
     WHERE iaz018 = prm_iaz018
       AND aac002 = rec_tmp_irac01a4.aac002
       AND aac003 = rec_tmp_irac01a4.aac003;

    END LOOP;

  EXCEPTION
     WHEN OTHERS THEN
          /*关闭打开的游标*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '数据库错误！'|| SQLERRM ;
          RETURN;
  END prc_p_ValidateBatchReduceCheck;
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
      prm_ErrorMsg        OUT           VARCHAR2)    --出错信息
  IS
   num_count        NUMBER(6);
   rec_tmp_irac01a2 tmp_irac01a2%ROWTYPE;
   dat_aac006       DATE ;--出生日期
   dat_aac007       DATE ;--参工日期
   dat_aac030       DATE ;--本系统参保日期
   dat_yac033       DATE ;--个人初次参保日期
   var_aab001       irac01.aab001%TYPE;
   var_aae140       irab02.aae140%TYPE;
   num_aac040       NUMBER(14,2); --缴费工资
   num_yac004       NUMBER(14,2); --养老基数
   num_yac005       NUMBER(14,2); --其他基数
   var_iaa100       VARCHAR2(6);  --申报月度
   var_aac001       irac01.aac001%TYPE;
   var_aac009       irac01.aac009%TYPE;  --户口性质
   BEGIN
   /*初始化变量*/
     prm_AppCode  := GN_DEF_OK;
     prm_ErrorMsg := '';
     prm_msg :='';
     prm_sign :='0';
       --校验参数
    IF prm_iaz018 IS NULL  THEN
      prm_msg :=  prm_msg||'传入校验流水号为空，请核实。。。';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
     --校验参数
    IF prm_aac001 IS NULL  THEN
      prm_msg :=  prm_msg||'传入个人编号为空，请核实。。。';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

      SELECT *
     INTO rec_tmp_irac01a2
     FROM wsjb.tmp_irac01a2
    WHERE iaz018 = prm_iaz018
      AND aac001 = prm_aac001;


    var_aab001 := rec_tmp_irac01a2.aab001;
    var_aac001 := prm_aac001;

    dat_aac030 := rec_tmp_irac01a2.aac030;
    var_iaa100 := rec_tmp_irac01a2.iaa100;

    IF dat_aac030 > SYSDATE THEN
      prm_msg :=  prm_msg||'停保日期不能晚于系统日期'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) > TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'停保日期不能晚于当前可申报月度'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) <> TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'停保月度和申报月度不一致'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --是否已经存在申报记录
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '0'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'该人员已存在待申报信息!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --是否已经存在申报记录
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '1'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'该人员已存在申报信息!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
  --是否已经存在申报记录
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '4'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'该人员已存在打回的申报信息，请到月申报功能下操作，不能再做待退操作！';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --是否已经存在申报记录

    IF rec_tmp_irac01a2.aae013 <> '251' THEN
      prm_msg :=  prm_msg||'人员停保原因不为在职转待退，请检查！';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;


   --暂停缴费基数
    IF rec_tmp_irac01a2.aae110 = '2' THEN
        SELECT yac004
          INTO num_yac004
          FROM wsjb.irac01a3
         WHERE aac001 = var_aac001
           AND aab001 = var_aab001
           AND aae110 = '2';


          --企业养老基数更新
          UPDATE wsjb.tmp_irac01a2
             SET yac004 = ROUND(num_yac004),
                 aae110 = '3'
           WHERE iaz018 = prm_iaz018;


     END IF;

     IF rec_tmp_irac01a2.aae120 = '2' THEN
        SELECT yac004
          INTO num_yac004
          FROM xasi2.ac02
         WHERE aac001 = var_aac001
           AND aab001 = var_aab001
           AND aac031 = '1';

          --机关养老基数更新
          UPDATE wsjb.tmp_irac01a2
             SET yac004 = num_aac040,
                 aae120 = '3'
           WHERE iaz018 = prm_iaz018;


     END IF;

     IF rec_tmp_irac01a2.aae210 = '2' OR
        rec_tmp_irac01a2.aae310 = '2' OR
        rec_tmp_irac01a2.aae410 = '2' OR
        rec_tmp_irac01a2.aae510 = '2' OR
        rec_tmp_irac01a2.aae311 = '2' OR
        rec_tmp_irac01a2.aae810 = '2' THEN
        --以一个险种为准
        SELECT yac004
          INTO num_yac005
          FROM xasi2.Ac02
         WHERE aac031 = '1'
           AND (aae140 = '02' OR aae140 = '03' OR aae140 = '04' OR aae140 = '05' )
           AND aab001 = var_aab001
           AND aac001 = var_aac001
           AND ROWNUM = 1;


          --其他基数更新
          UPDATE wsjb.tmp_irac01a2
             SET yac005 = ROUND(num_yac005),
                 yaa333 = ROUND(num_yac005)
           WHERE iaz018 = prm_iaz018;


        --正常参保的险种变更成减少
        IF rec_tmp_irac01a2.aae210 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae210 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae310 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae310 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae410 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae510 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae510 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae311 = '2' THEN --大额不停保
          UPDATE wsjb.tmp_irac01a2
             SET aae311 = '2'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae810 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae810 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;

     /*处理失败*/
      <<label_ERROR>>
        num_count :=0;

  EXCEPTION
     WHEN OTHERS THEN
          /*关闭打开的游标*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '数据库错误！'|| SQLERRM ;
          RETURN;
  END prc_p_ValidateRetireCheck;
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
      prm_ErrorMsg        OUT           VARCHAR2)    --出错信息
  IS
   num_count        NUMBER(6);
   rec_tmp_irac01a2 tmp_irac01a2%ROWTYPE;
   dat_aac006       DATE ;--出生日期
   dat_aac007       DATE ;--参工日期
   dat_aac030       DATE ;--本系统参保日期
   dat_yac033       DATE ;--个人初次参保日期
   var_aab001       irac01.aab001%TYPE;
   var_aae140       irab02.aae140%TYPE;
   num_aac040       NUMBER(14,2); --缴费工资
   num_yac004       NUMBER(14,2); --养老基数
   num_yac005       NUMBER(14,2); --其他基数
   var_iaa100       VARCHAR2(6);  --申报月度
   var_aac001       irac01.aac001%TYPE;
   var_aac009       irac01.aac009%TYPE;  --户口性质
   BEGIN
   /*初始化变量*/
     prm_AppCode  := GN_DEF_OK;
     prm_ErrorMsg := '';
     prm_msg :='';
     prm_sign :='0';
       --校验参数
    IF prm_iaz018 IS NULL  THEN
      prm_msg :=  prm_msg||'传入校验流水号为空，请核实。。。';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
     --校验参数
    IF prm_aac001 IS NULL  THEN
      prm_msg :=  prm_msg||'传入个人编号为空，请核实。。。';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

      SELECT *
     INTO rec_tmp_irac01a2
     FROM wsjb.tmp_irac01a2
    WHERE iaz018 = prm_iaz018
      AND aac001 = prm_aac001;


    var_aab001 := rec_tmp_irac01a2.aab001;
    var_aac001 := prm_aac001;

    dat_aac030 := rec_tmp_irac01a2.aac030;
    var_iaa100 := rec_tmp_irac01a2.iaa100;

    IF dat_aac030 > SYSDATE THEN
      prm_msg :=  prm_msg||'停保日期不能晚于系统日期'||TO_CHAR(SYSDATE,'yyyy-MM-dd')||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) > TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'停保日期不能晚于当前可申报月度'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    IF TO_NUMBER(TO_CHAR(dat_aac030,'yyyyMM')) <> TO_NUMBER(var_iaa100) THEN
      prm_msg :=  prm_msg||'停保月度和申报月度不一致'||var_iaa100||'!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --是否已经存在申报记录
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '0'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'该人员已存在待申报信息!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --是否已经存在申报记录
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '1'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'该人员已存在申报信息!';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;
  --是否已经存在申报记录
    SELECT count(1)
      INTO num_count
      FROM wsjb.irac01  a
     WHERE a.aac001 = var_aac001
       AND a.iaa002 = '4'
       AND a.aab001 = var_aab001;
    IF num_count > 0 THEN
      prm_msg :=  prm_msg||'该人员已存在打回的申报信息，请到月申报功能下操作，不能再做待退操作！';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;

    --是否已经存在申报记录

    IF rec_tmp_irac01a2.aae013 <> '211' THEN
      prm_msg :=  prm_msg||'人员停保原因不为在职人员死亡，请检查！';
      prm_sign := '1';
      GOTO label_ERROR;
    END IF;


   --暂停缴费基数
    IF rec_tmp_irac01a2.aae110 = '2' THEN
        SELECT yac004
          INTO num_yac004
          FROM wsjb.irac01a3
         WHERE aac001 = var_aac001
           AND aab001 = var_aab001
           AND aae110 = '2';


          --企业养老基数更新
          UPDATE wsjb.tmp_irac01a2
             SET yac004 = ROUND(num_yac004),
                 aae110 = '3'
           WHERE iaz018 = prm_iaz018;


     END IF;

     IF rec_tmp_irac01a2.aae120 = '2' THEN
        SELECT yac004
          INTO num_yac004
          FROM xasi2.ac02
         WHERE aac001 = var_aac001
           AND aab001 = var_aab001
           AND aac031 = '1';

          --机关养老基数更新
          UPDATE wsjb.tmp_irac01a2
             SET yac004 = num_aac040,
                 aae120 = '3'
           WHERE iaz018 = prm_iaz018;


     END IF;

     IF rec_tmp_irac01a2.aae210 = '2' OR
        rec_tmp_irac01a2.aae310 = '2' OR
        rec_tmp_irac01a2.aae410 = '2' OR
        rec_tmp_irac01a2.aae510 = '2' OR
        rec_tmp_irac01a2.aae311 = '2' OR
        rec_tmp_irac01a2.aae810 = '2' THEN
        --以一个险种为准
        SELECT yac004
          INTO num_yac005
          FROM xasi2.Ac02
         WHERE aac031 = '1'
           AND (aae140 = '02' OR aae140 = '03' OR aae140 = '04' OR aae140 = '05' )
           AND aab001 = var_aab001
           AND aac001 = var_aac001
           AND ROWNUM = 1;


          --其他基数更新
          UPDATE wsjb.tmp_irac01a2
             SET yac005 = ROUND(num_yac005),
                 yaa333 = ROUND(num_yac005)
           WHERE iaz018 = prm_iaz018;


        --正常参保的险种变更成减少
        IF rec_tmp_irac01a2.aae210 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae210 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae310 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae310 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae410 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae410 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae510 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae510 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae311 = '2' THEN --大额停保
          UPDATE wsjb.tmp_irac01a2
             SET aae311 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;
        IF rec_tmp_irac01a2.aae810 = '2' THEN
          UPDATE wsjb.tmp_irac01a2
             SET aae810 = '3'
           WHERE iaz018 = prm_iaz018;
        END IF;

     END IF;

     /*处理失败*/
      <<label_ERROR>>
        num_count :=0;

  EXCEPTION
     WHEN OTHERS THEN
          /*关闭打开的游标*/
          prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
          prm_ErrorMsg := '数据库错误！'|| SQLERRM ;
          RETURN;
  END prc_p_ValidateDeathCheck;
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
                                 prm_iaa100     IN     irac01.iaa100%TYPE,--申报月度
                                  prm_iaz018     IN     irac01a2.iaz018%TYPE,  --批量导入批次ID
                                  prm_yab139     IN     irac01.yab139%TYPE,--经办中心
                                  prm_AppCode    OUT    VARCHAR2  ,
                                  prm_ErrorMsg   OUT    VARCHAR2 )

   IS
      n_count    number(5);
      v_aac003    irac01.aac003%TYPE;
      v_aac031   irac01.aac031%TYPE;
      v_iac001   irac01.iac001%TYPE;
      v_aac001   irac01.aac001%TYPE;
      v_aab001   irac01.aab001%TYPE;
      v_aab004   irab01.aab004%TYPE;
      var_flag   number(1);
      v_aac002   irac01.aac002%TYPE;
      v_aac002_l irac01.aac002%TYPE;
      v_aac002_u irac01.aac002%TYPE;
      v_aac002d  irac01.aac002%TYPE;
      d_aac006    DATE;
      v_aac004   irac01.aac004%TYPE;
      v_aae110   irac01.aae110%TYPE;
      v_aae120   irac01.aae120%TYPE;
      v_aae210   irac01.aae210%TYPE;
      v_aae310   irac01.aae310%TYPE;
      v_aae410   irac01.aae410%TYPE;
      v_aae510   irac01.aae510%TYPE;
      v_aae311   irac01.aae311%TYPE;
      v_aae810   irac01.aae810%TYPE;
      v_message  varchar2(3000);
      v_yac168   irac01.yac168%TYPE;
      num_aac040 NUMBER(14,2);
      num_yac004 NUMBER(14,2);
      num_yac005 NUMBER(14,2);
      var_aae140 irab02.aae140%TYPE;
     sj_acount  NUMBER;
     sj_count   NUMBER;
     sj_count1  NUMBER;
     count_jm   NUMBER;
     v_aac012   irac01.aac012%TYPE;
     v_aac008   irac01.aac012%TYPE;
     dat_aac006  irac01.aac006%TYPE;
     dat_yearAge      DATE;  --到龄日期
      dat_AAE030     DATE;--年审时间 20190808

    
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
              aae100,
              errormsg
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
       FROM wsjb.irab01
       WHERE iab001 = prm_aab001;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '单位编号为['|| prm_aab001 ||']的单位信息不存在!';
       RETURN;
    END IF;

    --判断是否存在批量导入信息
    SELECT COUNT(1)
      INTO  n_count
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
       v_message := '';
       -- 校验干部工人
       v_aac012 := REC_TMP_PERSON.Aac012; 
       v_aac008 := REC_TMP_PERSON.aac008;
       v_aac004 := REC_TMP_PERSON.aac004;
       dat_aac006 := REC_TMP_PERSON.aac006;--出生日期
       
       /**养老接口校验是否通过**/
       IF REC_TMP_PERSON.aae100 ='0' AND REC_TMP_PERSON.errormsg IS NOT NULL THEN
       v_message := REC_TMP_PERSON.errormsg;
       var_flag  := 1;
       END IF;
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
--               xasi2.pkg_P_Comm_CZ.prc_P_getID( UPPER(REC_TMP_PERSON.aac002),   --传入身份证
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
         v_message := v_message||'导入数据中身份证号码有重复;';
         var_flag   := 1;
      END IF;


      --18位身份证号是否新参保校验(高新)
      SELECT COUNT(1)
        INTO n_count
        FROM xasi2.ac01 a
       WHERE a.aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
         AND a.aae120 = '0'
         AND a.aac003 NOT LIKE '%重复%';
        IF n_count >1 THEN
           v_message := '该身份证号已经存在多个医保编号，不能新参保！';
           var_flag :='1';
           GOTO label_ERROR ;
        END IF;
             
       -- begin 20190708 wangz 处理 单位 工人
        IF v_aac008 = '1' THEN

         IF v_aac004 = '1' THEN --男 60岁
           dat_yearAge := ADD_MONTHS(dat_aac006,60*12);
         ELSIF v_aac004 = '2' AND v_aac012 = '4' THEN --女干部 55岁
           dat_yearAge := ADD_MONTHS(dat_aac006,55*12);
         ELSIF v_aac004 = '2' AND v_aac012 = '1' THEN --女工人 50岁
           dat_yearAge := ADD_MONTHS(dat_aac006,50*12);
         ELSE
           v_message := '性别获取失败';
           var_flag := '1';
           GOTO label_ERROR;
         END IF;
         IF dat_yearAge < SYSDATE THEN
           v_message :=  v_message||'您好，此员工已超过退休年龄，请核实因何种情况需为此人缴纳社会保险。确有特殊情况，请提供相关说明材料至社保中心网上审核窗口备案!';
            var_flag := '1';
           GOTO label_ERROR;
         END IF;

     END IF;
        
        
        
    -- end 20190708 wangz
        
        IF n_count =1 THEN
         SELECT AAC001
           INTO v_aac001
           FROM XASI2.AC01
          WHERE AAE120 = '0'
            AND aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
            AND AAC003 NOT LIKE '%重复%';
         SELECT COUNT(1)
        INTO COUNT_JM
        FROM XASI2.AC02K1
       WHERE AAC001 = v_aac001
         AND AAC031 = '1';
      IF COUNT_JM > 0 THEN
       SELECT AAB004
         INTO V_AAB004
         FROM XASI2.AB01
        WHERE AAB001 = (SELECT aab001
                          FROM XASI2.AC02K1
                         WHERE AAC001 = v_aac001
                           AND AAC031 = '1');
        v_message  := V_MESSAGE ||'此身份证号码人员医疗保险关系目前在社区：' || V_AAB004 || '参加居民医保，姓名:'  ||'个人编号：'||v_aac001|| ',参保状态:参保缴费。';
        var_flag := '1';
      END IF;

        SELECT aac001,
                    aac003
               INTO v_aac001,
                    v_aac003
               FROM xasi2.ac01
              WHERE AAE120 = '0'
              AND aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
              AND AAC003 NOT LIKE '%重复%';
        BEGIN
          SELECT AAB001, AAC031
            INTO V_AAB001, V_AAC031
            FROM XASI2.AC02
           WHERE AAC001 = V_AAC001
             AND AAE140 = '03';
        EXCEPTION
          WHEN OTHERS THEN
            BEGIN
              SELECT AAB001, AAC031
                INTO V_AAB001, V_AAC031
                FROM XASI2.AC02
               WHERE AAC001 = V_AAC001
                 AND AAE140 = '02';
            EXCEPTION
              WHEN OTHERS THEN
                BEGIN
                  SELECT AAB001, AAC031
                    INTO V_AAB001, V_AAC031
                    FROM XASI2.AC02
                   WHERE AAC001 = V_AAC001
                     AND AAE140 = '05';
                EXCEPTION
                  WHEN OTHERS THEN
                    BEGIN
                      SELECT AAB001, AAC031
                        INTO V_AAB001, V_AAC031
                        FROM XASI2.AC02
                       WHERE AAC001 = V_AAC001
                         AND AAE140 = '04';
                    EXCEPTION
                      WHEN OTHERS THEN
                        NULL;
                    END;
                END;
            END;
        END;

        IF V_AAC031 = '1' THEN
          V_AAC031 := '参保缴费';
        ELSIF V_AAC031 = '2' THEN
          V_AAC031 := '暂停缴费';
        ELSIF V_AAC031 = '3' THEN
          V_AAC031 := '终止缴费';
        END IF;
          --  检验 V_AAB001  是否存在
        IF  V_AAB001 IS NOT NULL OR V_AAB001 != '' THEN


          SELECT AAB004
            INTO V_AAB004
            FROM XASI2.AB01
          WHERE AAB001 = V_AAB001;

          V_MESSAGE := V_MESSAGE || '人员新参保登记验证不通过！此身份证号码人员医疗保险关系目前在单位名称：' ||
                       V_AAB004 || ',参保姓名：' || V_AAC003 || ',参保状态:' ||
                       V_AAC031 || '。';
          VAR_FLAG  := 1;
           END IF;
        END IF;
        
   
        
        
        
        
        
        
        
        
        --18位身份证号是否新参保校验(市局)
      /*SELECT count(1)
           INTO sj_acount
           FROM sjxt.ac01
            WHERE aac002 = REC_TMP_PERSON.aac002;
         IF sj_acount=1 THEN
         SELECT aac001,aac003 INTO v_aac001,v_aac003 FROM sjxt.ac01 WHERE aac002 = REC_TMP_PERSON.aac002;
         SELECT count(DISTINCT aab001) INTO sj_count FROM sjxt.ac02 WHERE aac001 = v_aac001 AND aac031='1';
         IF sj_count > 0 THEN
          SELECT aab001,aac031 INTO v_aab001,v_aac031 FROM sjxt.ac02 WHERE aac001 = v_aac001 and aac031='1' AND ROWNUM =1;
          IF v_aac031='1' THEN
             v_aac031 :='参保缴费';
         ELSIF v_aac031='2' THEN
             v_aac031 :='暂停缴费';
         ELSIF v_aac031='3' THEN
             v_aac031 :='终止缴费';
         END IF;
         IF v_aab001 IS NOT NULL THEN
          BEGIN
         SELECT aab004 INTO v_aab004 FROM sjxt.ab01 WHERE aab001 = v_aab001;
           EXCEPTION
             WHEN OTHERS THEN
              BEGIN
                v_aab004 :='';
                END;
                END;
         END IF;
                v_message := v_message|| '人员新参保登记验证不通过！此身份证号码人员医疗保险关系目前在西安市社保中心,姓名'||v_aac003||',单位名称：'||v_aab004||'参保，参保状态:'||v_aac031||'。';
               var_flag :='1';
          ELSIF sj_count = 0 THEN
          SELECT count(DISTINCT aab001) INTO sj_count1 FROM sjxt.ac02 WHERE aac001 = v_aac001 AND aac031='2';
          IF sj_count1 > 0 THEN
           SELECT aab001,aac031 INTO v_aab001,v_aac031 FROM sjxt.ac02 WHERE aac001 = v_aac001 and aac031='2' AND ROWNUM =1;
           IF v_aac031='1' THEN
             v_aac031 :='参保缴费';
         ELSIF v_aac031='2' THEN
             v_aac031 :='暂停缴费';
         ELSIF v_aac031='3' THEN
             v_aac031 :='终止缴费';
         END IF;
         IF v_aab001 IS NOT NULL THEN
          BEGIN
         SELECT aab004 INTO v_aab004 FROM sjxt.ab01 WHERE aab001 = v_aab001;
           EXCEPTION
             WHEN OTHERS THEN
              BEGIN
                v_aab004 :='';
                END;
                END;
         END IF;
                v_message := v_message|| '人员新参保登记验证不通过！此身份证号码人员医疗保险关系目前在西安市社保中心,姓名'||v_aac003||',单位名称：'||v_aab004||'参保，参保状态:'||v_aac031||'。';
               var_flag :='1';
            elsif sj_count1 = 0 then
                v_message := v_message|| '人员新参保登记验证不通过！此身份证号码人员医疗保险关系目前在西安市社保中心,姓名'||v_aac003;
               var_flag :='1';
          END IF;
          END IF;

             END IF;*/
             --18位身份证号是否新参保校验
      SELECT COUNT(1)
        INTO n_count
        FROM  wsjb.irac01  a
      WHERE  a.aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
        AND A.iaa001 <> '4'
        AND A.IAA002 <> '3'
        AND ROWNUM = 1;

      IF n_count >0 THEN

        SELECT aab001
          INTO  v_aab001
          FROM wsjb.irac01
         WHERE aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
           AND iaa001 <> '4'
           AND IAA002 <> '3'
           AND  rownum = 1;

        IF v_aab001 IS NOT NULL THEN
            SELECT aab004
              INTO v_aab004
              FROM wsjb.irab01
             WHERE iab001 = v_aab001
               AND rownum = 1;
        END IF;
        v_message := v_message||'该人员在'||v_aab004||'['||v_aab001||']有申报记录，请在续保模块里操作！';
        var_flag  := 1;
      END IF;

       IF REC_TMP_PERSON.aab001 IS NULL THEN
         v_message := v_message||'没有找到单位编号！';
         var_flag  := 1;
       END IF;


      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.irab01
       WHERE iab001 = REC_TMP_PERSON.aab001;
       IF n_count = 0 THEN
         v_message := v_message||'没有找到网报单位信息';
         var_flag  := 1;
       END IF;

       IF REC_TMP_PERSON.aac003 IS NULL THEN
         v_message := v_message||'导入姓名不能为空！';
         var_flag  := 1;
       END IF;
       IF REC_TMP_PERSON.aac004 IS NULL THEN
       v_message := v_message||'性别不能为空！';
         var_flag  := 1;
       END IF;
       IF REC_TMP_PERSON.aac004 IS NOT NULL THEN
          IF REC_TMP_PERSON.aac004 <> '1' AND REC_TMP_PERSON.aac004 <> '2' AND REC_TMP_PERSON.aac004 <> '9' THEN
                v_message := v_message||'性别码值出错!';
                var_flag  := 1;
          END IF;
       END IF;
       IF REC_TMP_PERSON.aac005 IS   NULL THEN
          v_message := v_message||'民族不能为空!';
                var_flag  := 1;
       END IF;
       IF REC_TMP_PERSON.aac005 IS  NOT  NULL THEN
          IF  LENGTH(trim(REC_TMP_PERSON.aac005)) <> 2 THEN
                v_message := v_message||'民族码值出错!';
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
            IF REC_TMP_PERSON.aac012 NOT IN ('1','4') THEN
                   v_message := v_message||'个人身份码值出错!';
                  var_flag  :=1;
            END IF;
       END IF;

       IF REC_TMP_PERSON.yac168 IS NULL THEN
         v_message := v_message||'外来务工标志不能为空！';
         var_flag  := 1;
       ELSE
            IF REC_TMP_PERSON.yac168 NOT IN ('0','1') THEN
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
       num_aac040 := REC_TMP_PERSON.aac040;
        --企业职工养老保险校验
       IF REC_TMP_PERSON.aae110 IS NOT NULL THEN
             SELECT COUNT(1)
               INTO n_count
               FROM wsjb.irab01  a,AE02 b
              WHERE a.aaz002 = b.AAZ002
                AND b.aaa121 = PKG_Constant.AAA121_NER
                AND a.aab001 = prm_aab001;
             IF n_count > 0 THEN
                   SELECT nvl(a.aae110,'0')
                     INTO  v_aae110
                     FROM wsjb.irab01  a,AE02 b
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
           
           IF (v_aae110 = '1' AND REC_TMP_PERSON.aae110 = '1') THEN
               SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,prm_aab001,num_aac040,'0','01','1','1',prm_iaa100,prm_yab139))
                INTO num_yac004
                FROM  dual ;
              UPDATE IRAC01A2
                 SET yac004 = ROUND(num_yac004)
               WHERE aac002 = REC_TMP_PERSON.aac002
                 AND aac003 = REC_TMP_PERSON.aac003
                 AND iaz018 = prm_iaz018;
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
            ELSE
                  v_aae120 := '0';
            END IF;

           IF  (v_aae120 = '0' AND REC_TMP_PERSON.aae120 = '1') THEN
             v_message := v_message||'所在单位没有参加机关事业养老保险!';
             var_flag := 1;
           END IF;
           IF (v_aae120 = '1' AND REC_TMP_PERSON.aae120 = '1') THEN

              UPDATE IRAC01A2
                 SET yac004 = num_aac040
               WHERE aac002 = REC_TMP_PERSON.aac002
                 AND aac003 = REC_TMP_PERSON.aac003
                 AND iaz018 = prm_iaz018;
           END IF;

       END IF;
       /**
       ----以一个险种为准
        SELECT aae140
          INTO var_aae140
          FROM xasi2.AB02
         WHERE aab051 = '1'
           AND (aae140 = '02' OR aae140 = '03' OR aae140 = '04' OR aae140 = '05' )
           AND aab001 = prm_aab001
           AND ROWNUM = 1;
       --获取其他基数
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,prm_aab001,num_aac040,'0',var_aae140,'1','1',prm_iaa100,prm_yab139))
          INTO num_yac005
          FROM  dual ;
        UPDATE IRAC01A2
           SET yac005 = ROUND(num_yac005),
               yaa333 = ROUND(num_yac005)
         WHERE aac002 = REC_TMP_PERSON.aac002
           AND aac003 = REC_TMP_PERSON.aac003
           AND iaz018 = prm_iaz018;
*/
------双社评 养老、失业、工伤同基数，医疗、生育同基数   20190807 modify by yujj
  SELECT COUNT(1)
             INTO  n_count
             FROM xasi2.ab05
            WHERE aab001 = prm_aab001
              AND  AAE001 = 2019
              AND YAB007='03';
  IF n_count < 1 AND prm_iaa100<201901    THEN
           SELECT aae140
          INTO var_aae140
          FROM xasi2.AB02
         WHERE aab051 = '1'
           AND (aae140 = '02' OR aae140 = '03' OR aae140 = '04' OR aae140 = '05' )
           AND aab001 = prm_aab001
           AND ROWNUM = 1;
       --获取其他基数
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,prm_aab001,num_aac040,'0',var_aae140,'1','1',prm_iaa100,prm_yab139))
          INTO num_yac005
          FROM  dual ;
        UPDATE IRAC01A2
           SET yac005 = ROUND(num_yac005),
               yaa333 = ROUND(num_yac005)
         WHERE aac002 = REC_TMP_PERSON.aac002
           AND aac003 = REC_TMP_PERSON.aac003
           AND iaz018 = prm_iaz018;
     
ELSE   
    SELECT aae030 
    INTO  dat_AAE030 
    FROM xasi2.aa35 
    WHERE aae001=2019 ;
   IF     prm_iaa100>201812 AND  SYSDATE >dat_AAE030  THEN 
       ----以一个险种为准
        SELECT aae140
          INTO var_aae140
          FROM xasi2.AB02
         WHERE aab051 = '1'
           AND (aae140 = '02'  OR aae140 = '04'   )
           AND aab001 = prm_aab001
           AND ROWNUM = 1;
       --获取失业、工伤基数
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,prm_aab001,num_aac040,'0',var_aae140,'1','1',prm_iaa100,prm_yab139))
          INTO num_yac004
          FROM  dual ;
        UPDATE IRAC01A2
           SET yac004 = ROUND(num_yac004)
         WHERE aac002 = REC_TMP_PERSON.aac002
           AND aac003 = REC_TMP_PERSON.aac003
           AND iaz018 = prm_iaz018; 
       ----以医疗险种为准
        SELECT aae140
          INTO var_aae140
          FROM xasi2.AB02
         WHERE aab051 = '1'
           AND (  aae140 = '03'  OR aae140 = '05' )
           AND aab001 = prm_aab001
           AND ROWNUM = 1;
      IF REC_TMP_PERSON.aae310 = '1' THEN
       --获取其他基数
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,prm_aab001,num_aac040,'0',var_aae140,'1','1',prm_iaa100,prm_yab139))
          INTO num_yac005
          FROM  dual ;
        UPDATE IRAC01A2
           SET yac005 = ROUND(num_yac005),
               yaa333 = ROUND(num_yac005)
         WHERE aac002 = REC_TMP_PERSON.aac002
           AND aac003 = REC_TMP_PERSON.aac003
           AND iaz018 = prm_iaz018;
      END IF;
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
            ELSE
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
            ELSE
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
            ELSE
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
            ELSE
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
            ELSE
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
            ELSE
                  v_aae810 := '0';
            END IF;

           IF  (v_aae810 = '0' AND REC_TMP_PERSON.aae810 = '1') THEN
             v_message := v_message||'所在单位没有参加公务员补助保险!';
             var_flag := 1;
           END IF;

           IF v_aae810 = '1' AND NVL(REC_TMP_PERSON.yaa333,0) <= 0 THEN
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
       IF  v_aae510 = '2' AND v_aae311 = '2' AND v_aae310 = '2' THEN

             IF REC_TMP_PERSON.aae310 = '1' THEN
                   IF   REC_TMP_PERSON.aae510 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                         v_message := v_message||'医疗、生育、大额补充四险种必须一起参保!';
                         var_flag  := 1;
                    END IF;
             END IF;
/*
             IF REC_TMP_PERSON.aae210 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae510 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
                         v_message := v_message||'医疗、生育、大额补充四险种必须一起参保!';
                         var_flag  := 1;
                    END IF;
             END IF;
*/
             IF REC_TMP_PERSON.aae510 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0'  OR REC_TMP_PERSON.aae311 = '0' THEN
                         v_message := v_message||'医疗、生育、大额补充四险种必须一起参保!';
                         var_flag  := 1;
                    END IF;
             END IF;

             IF REC_TMP_PERSON.aae311 = '1' THEN
                   IF  REC_TMP_PERSON.aae310 = '0'  OR REC_TMP_PERSON.aae510 = '0' THEN
                         v_message := v_message||'医疗、生育、大额补充四险种必须一起参保!';
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
          IF REC_TMP_PERSON.aac030 >  last_day(to_date(prm_iaa100,'yyyymm')) THEN
                  v_message:= v_message||'本单位参保时间不能晚于系统时间!';
                  var_flag := 1;
          END IF;
       END IF;

      IF REC_TMP_PERSON.yac033 IS NOT NULL THEN
          IF REC_TMP_PERSON.yac033 > last_day(to_date(prm_iaa100,'yyyymm'))  THEN
                  v_message:= v_message||'初次参保时间不能晚于系统时间!';
                  var_flag := 1;
          END IF;
       END IF;

        IF REC_TMP_PERSON.aac007 IS NOT NULL THEN
            IF REC_TMP_PERSON.aac007 > last_day(to_date(prm_iaa100,'yyyymm'))  THEN
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

      IF REC_TMP_PERSON.aac030 IS NOT NULL THEN
          IF TO_NUMBER(TO_CHAR(REC_TMP_PERSON.aac030,'yyyyMM')) > TO_NUMBER(prm_iaa100) THEN
                  v_message:= v_message||'本单位参保时间不能晚于申报月度!';
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

            UPDATE IRAC01A2  a
                 SET a.aac006 = d_aac006,
                     a.aac004 = v_aac004
              WHERE a.iaz018 = prm_iaz018
                AND a.aac002 = REC_TMP_PERSON.aac002
                AND a.aac003 = REC_TMP_PERSON.aac003;
      END IF;

      IF LENGTH(TRIM(v_aac002)) = 15 THEN
             SELECT to_date(( '19' ||  substr(v_aac002,7,6)) ,'yyyy-mm-dd')
               INTO d_aac006
               FROM dual;
             SELECT decode(mod(to_number(substr(TRIM(v_aac002),15,1)),2),1,'1',0,'2','9')
              INTO v_aac004
              FROM dual;
              UPDATE IRAC01A2  a
                   SET a.aac006 = d_aac006,
                       a.aac004 = v_aac004
                WHERE a.iaz018 = prm_iaz018
                  AND a.aac002 = REC_TMP_PERSON.aac002
                  AND a.aac003 = REC_TMP_PERSON.aac003;
      END IF;

      SELECT decode(REC_TMP_PERSON.aac009,'10','0','20','1')
        INTO v_yac168
        FROM dual;

      UPDATE IRAC01A2  a
          SET a.yac168 = v_yac168
        WHERE a.iaz018 = prm_iaz018
          AND a.aac002 = REC_TMP_PERSON.aac002
          AND a.aac003 = REC_TMP_PERSON.aac003;
     <<label_ERROR>>
     IF var_flag = 0 THEN
        --提取IRAC01A2的数据到IRAC01
        --  v_iac001 := PKG_COMMON.FUN_GETSEQUENCE(NULL,'IAC001');
         BEGIN
          --回写irac01a2 原因为成功
             UPDATE IRAC01A2  a
                SET  a.errormsg = '数据可以导入保存',
                     a.aae100 = '2'
              WHERE a.iaz018 = prm_iaz018
                AND a.aac002 = REC_TMP_PERSON.aac002
                AND a.aac003 = REC_TMP_PERSON.aac003;

       END;
     ELSIF var_flag = 1 THEN
          --回写irac01a2 回写失败原因
             UPDATE IRAC01A2  a
                SET  a.errormsg = v_message,
                     a.aae100 = '0'
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
   prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
   RETURN;
   END prc_batchImportView;
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
                             prm_iaa100     IN     VARCHAR2,--申报月度
                             prm_iaz018     IN     irac01a2.iaz018%TYPE,  --批量导入批次ID
                             prm_yab139     IN     irac01.yab139%TYPE,--经办中心
                             prm_AppCode    OUT    VARCHAR2  ,
                             prm_ErrorMsg   OUT    VARCHAR2 )

   IS
      n_count    number(5);
      v_iac001   irac01.iac001%TYPE;
      v_aac001   irac01.aac001%TYPE;
      v_aab001   irac01.aab001%TYPE;
      v_aab004   irab01.aab004%TYPE;
      v_aaz002   varchar2(23);
      var_flag   number(1);
      v_aac002   irac01.aac002%TYPE;
      v_aac002_l   irac01.aac002%TYPE;
      v_aac002_u   irac01.aac002%TYPE;
      v_aac002d  irac01.aac002%TYPE;
      d_aac006    DATE;
      v_aac004   irac01.aac004%TYPE;
      v_aae110   irac01.aae110%TYPE;
      v_aae120   irac01.aae120%TYPE;
      v_aae210   irac01.aae210%TYPE;
      v_aae310   irac01.aae310%TYPE;
      v_aae410   irac01.aae410%TYPE;
      v_aae510   irac01.aae510%TYPE;
      v_aae311   irac01.aae311%TYPE;
     v_aae810     irac01.aae810%TYPE;
      v_message  varchar2(3000);
      v_yac168   irac01.yac168%TYPE;
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
              aae100,
              errormsg
             FROM IRAC01A2
             WHERE iaz018 = prm_iaz018
               AND aae100 = '2';

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
       FROM wsjb.irab01
       WHERE aab001 = prm_aab001;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '单位编号为['|| prm_aab001 ||']的单位信息不存在!';
       RETURN;
    END IF;



    --判断是否存在该专管员
      SELECT COUNT(1)
       INTO n_count
       FROM IRAA01
       WHERE yae092 = prm_aae011;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '专管员编号为['|| prm_aae011 ||']的信息不存在!';
       RETURN;
    END IF;

    --判断是否存在批量导入信息
     SELECT COUNT(1)
       INTO n_count
       FROM IRAC01A2
      WHERE iaz018 = prm_iaz018;
    IF n_count = 0 THEN
       prm_AppCode  :=  gn_def_ERR;
       prm_ErrorMsg := '导入批次ID为['|| prm_iaz018 ||']的信息不存在!';
       RETURN;
    END IF;

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
       v_message := '';
       /**养老接口返回信息（如果不为空则不能保存）**/
       IF REC_TMP_PERSON.AAE100 = '0' THEN
       v_message := REC_TMP_PERSON.ERRORMSG;
       var_flag :=1;
       END IF;
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
--               xasi2.pkg_P_Comm_CZ.prc_P_getID( UPPER(REC_TMP_PERSON.aac002),   --传入身份证
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
         v_message := v_message||'导入数据中身份证号码有重复;';
         var_flag   := 1;
      END IF;


      --18位身份证号是否新参保校验
      SELECT COUNT(1)
        INTO n_count
        FROM xasi2.ac01 a
       WHERE a.aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
         AND a.aae120 = '0';

        IF n_count >0 THEN
          v_message := v_message||'证件号为：['||v_aac002||']的人员已存在个人信息，请在续保模块里操作！';
          var_flag  := 1;
        END IF;

             --18位身份证号是否新参保校验
      SELECT COUNT(1)
        INTO n_count
        FROM  wsjb.irac01  a
      WHERE  a.aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
        AND A.iaa001 <> '4'
        AND A.IAA002 <> '3'
        AND ROWNUM = 1;

      IF n_count >0 THEN

        SELECT aab001
          INTO v_aab001
          FROM wsjb.irac01
         WHERE aac002 in (v_aac002,v_aac002_l,v_aac002_u,v_aac002d)
           AND iaa001 <> '4'
           AND IAA002 <> '3'
           AND ROWNUM = 1;

        IF v_aab001 IS NOT NULL THEN
            SELECT aab004
              INTO v_aab004
              FROM wsjb.irab01
             WHERE iab001 = v_aab001
               AND rownum = 1;
        END IF;
        v_message := v_message||'该人员在'||v_aab004||'['||v_aab001||']有申报记录，请在续保模块里操作！';
        var_flag  := 1;
      END IF;

       IF REC_TMP_PERSON.aab001 IS NULL THEN
         v_message := v_message||'没有找到单位编号！';
         var_flag  := 1;
       END IF;


      SELECT COUNT(1)
        INTO n_count
        FROM wsjb.irab01
       WHERE iab001 = REC_TMP_PERSON.aab001;
       IF n_count = 0 THEN
         v_message := v_message||'没有找到网报单位信息';
         var_flag  := 1;
       END IF;

--
--       IF REC_TMP_PERSON.aac003 IS NULL THEN
--         v_message := v_message||'导入姓名不能为空！';
--         var_flag  := 1;
--       END IF;
--       IF REC_TMP_PERSON.aac004 IS NOT NULL THEN
--          IF REC_TMP_PERSON.aac004 <> '1' AND REC_TMP_PERSON.aac004 <> '2' AND REC_TMP_PERSON.aac004 <> '9' THEN
--                v_message := v_message||'性别码值出错!';
--                var_flag  := 1;
--          END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aac005 IS  NOT  NULL THEN
--          IF  LENGTH(trim(REC_TMP_PERSON.aac005)) <> 2 THEN
--                v_message := v_message||'码值码值出错!';
--                var_flag  := 1;
--          END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aac009 IS NULL THEN
--         v_message := v_message||'户口性质不能为空！';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aac009 <> '10' AND REC_TMP_PERSON.aac009 <> '20' AND REC_TMP_PERSON.aac009 <> '30' AND REC_TMP_PERSON.aac009 <> '40' AND REC_TMP_PERSON.aac009 <> '90' THEN
--                  v_message := v_message||'户口性质码值出错!';
--                  var_flag  :=1;
--            END IF;
--       END IF;
--
--        IF REC_TMP_PERSON.aac010 IS NULL AND LENGTH(REC_TMP_PERSON.aac010)< 8 THEN
--         v_message := v_message||'户籍地址不能为空,或字数不达8位！';
--         var_flag  := 1;
--       END IF;
--
--       IF REC_TMP_PERSON.aae006 IS NULL AND LENGTH(REC_TMP_PERSON.aae006)< 8 THEN
--         v_message := v_message||'联系地址不能为空,或字数不达8位！';
--         var_flag  := 1;
--       END IF;
--
--       IF REC_TMP_PERSON.aac011 IS NULL THEN
--         v_message := v_message||'学历不能为空！';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aac011 <> '11' AND REC_TMP_PERSON.aac011 <> '12' AND REC_TMP_PERSON.aac011 <> '21'
--               AND REC_TMP_PERSON.aac011 <> '31' AND REC_TMP_PERSON.aac011 <> '40' AND REC_TMP_PERSON.aac011 <> '50'
--               AND REC_TMP_PERSON.aac011 <> '61' AND REC_TMP_PERSON.aac011 <> '62' AND REC_TMP_PERSON.aac011 <> '70'
--               AND REC_TMP_PERSON.aac011 <> '80' AND REC_TMP_PERSON.aac011 <> '90' AND REC_TMP_PERSON.aac011 <> '99' THEN
--                  v_message := v_message||'学历码值出错!';
--                  var_flag  :=1;
--            END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aac021 IS NULL THEN
--         v_message := v_message||'毕业时间不能为空！';
--         var_flag  := 1;
--       END IF;
--
--       IF REC_TMP_PERSON.aac022 IS NULL THEN
--         v_message := v_message||'毕业院校不能为空！';
--         var_flag  := 1;
--       END IF;
--
--       IF REC_TMP_PERSON.aac025 IS NULL THEN
--         v_message := v_message||'婚姻状况不能为空！';
--         var_flag  := 1;
--         ELSE
--            IF REC_TMP_PERSON.aac025 <> '1' AND REC_TMP_PERSON.aac025 <> '2' AND REC_TMP_PERSON.aac025 <> '3'
--               AND REC_TMP_PERSON.aac025 <> '4' AND REC_TMP_PERSON.aac025 <> '9' THEN
--                  v_message := v_message||'婚姻状况码值出错!';
--                  var_flag  :=1;
--            END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aac026 IS NULL THEN
--         v_message := v_message||'是否服役不能为空！';
--         var_flag  := 1;
--         ELSE
--            IF REC_TMP_PERSON.aac026 <> '0' AND REC_TMP_PERSON.aac026 <> '1' THEN
--                   v_message := v_message||'是否服役码值出错!';
--                  var_flag  :=1;
--            END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aac012 IS NULL THEN
--         v_message := v_message||'个人身份不能为空！';
--         var_flag  := 1;
--         ELSE
--            IF REC_TMP_PERSON.aac012 <> '1' AND REC_TMP_PERSON.aac012 <> '4' THEN
--                   v_message := v_message||'个人身份码值出错!';
--                  var_flag  :=1;
--            END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.yac168 IS NULL THEN
--         v_message := v_message||'外来务工标志不能为空！';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.yac168 <> '0' AND REC_TMP_PERSON.yac168 <> '1' THEN
--                    v_message := v_message||'农民工标志码值出错!';
--                    var_flag  := 1;
--            END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aac030 IS NULL THEN
--         v_message := v_message||'参保时间不能为空！';
--         var_flag  := 1;
--       END IF;
--
--       IF REC_TMP_PERSON.yac503 IS NULL THEN
--         v_message := v_message||'工资类别不能为空！';
--         var_flag  := 1;
--       END IF;
--
--       IF REC_TMP_PERSON.aac040 IS NULL THEN
--         v_message := v_message||'申报工资不能为空！';
--         var_flag  := 1;
--       END IF;
--
--       IF REC_TMP_PERSON.aae110 IS NULL THEN
--         v_message := v_message||'企业职工养老保险不能导入空项！';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aae110 <> '0' AND REC_TMP_PERSON.aae110 <> '1' THEN
--                v_message := v_message||'企业职工养老保险码值出错!';
--                var_flag  := 1;
--             END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aae120 IS NULL THEN
--         v_message := v_message||'机关事业养老保险不能导入空项！';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aae120 <> '0' AND REC_TMP_PERSON.aae120 <> '1' THEN
--                v_message := v_message||'机关事业养老保险码值出错!';
--                var_flag  := 1;
--             END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aae210 IS NULL THEN
--         v_message := v_message||'失业保险不能导入空项！';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aae210 <> '0' AND REC_TMP_PERSON.aae210 <> '1' THEN
--                v_message := v_message||'失业保险码值出错!';
--                var_flag  := 1;
--             END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aae310 IS NULL THEN
--         v_message := v_message||'基本医疗保险不能导入空项！';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aae310 <> '0' AND REC_TMP_PERSON.aae310 <> '1' THEN
--                v_message := v_message||'基本医疗保险码值出错!';
--                var_flag  := 1;
--             END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aae410 IS NULL THEN
--         v_message := v_message||'工伤保险不能导入空项！';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aae410 <> '0' AND REC_TMP_PERSON.aae410 <> '1' THEN
--                v_message := v_message||'工伤保险码值出错!';
--                var_flag  := 1;
--             END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aae510 IS NULL THEN
--         v_message := v_message||'生育保险不能导入空项！';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aae510 <> '0' AND REC_TMP_PERSON.aae510 <> '1' THEN
--                v_message := v_message||'生育保险码值出错!';
--                var_flag  := 1;
--             END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aae311 IS NULL THEN
--         v_message := v_message||'大病补充医疗保险不能导入空项！';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aae311 <> '0' AND REC_TMP_PERSON.aae311 <> '1' THEN
--                v_message := v_message||'大额补充医疗保险码值出错!';
--                var_flag  := 1;
--             END IF;
--       END IF;
--
--       IF REC_TMP_PERSON.aae810 IS NULL THEN
--         v_message := v_message||'公务员补助保险不能导入空项！';
--         var_flag  := 1;
--       ELSE
--            IF REC_TMP_PERSON.aae810 <> '0' AND REC_TMP_PERSON.aae810 <> '1' THEN
--                v_message := v_message||'公务员补助保险码值出错!';
--                var_flag  := 1;
--             END IF;
--       END IF;
--        --企业职工养老保险校验
--       IF REC_TMP_PERSON.aae110 IS NOT NULL THEN
--               SELECT COUNT(1)
--               INTO n_count
--               FROM  IRAB01 a,AE02 b
--               WHERE a.aaz002 = b.AAZ002
--                  AND b.aaa121 = PKG_Constant.AAA121_NER
--                  AND a.aab001 = prm_aab001;
--               IF n_count > 0 THEN
--                   SELECT nvl(a.aae110,'0')
--                     INTO  v_aae110
--                     FROM IRAB01 a,AE02 b
--                    WHERE a.aaz002 = b.AAZ002
--                      AND b.aaa121 = PKG_Constant.AAA121_NER
--                      AND a.aab001 = prm_aab001;
--                ELSE
--                    v_aae110 := '0';
--                END IF;
--           IF  (v_aae110 = '0' AND REC_TMP_PERSON.aae110 = '1') THEN
--             v_message := v_message||'所在单位没有参加企业职工养老保险!';
--             var_flag := 1;
--           END IF;
--       END IF;
--
--      --机关事业养老保险校验
--       IF REC_TMP_PERSON.aae120 IS NOT NULL THEN
--           SELECT COUNT(1)
--           INTO  n_count
--           FROM ab02
--           WHERE aab001 = prm_aab001
--            AND  aae140 = '06';
--
--            IF n_count > 0 THEN
--                   SELECT decode(aab051,'1','2','0')
--                     INTO  v_aae120
--                     FROM ab02
--                    WHERE aab001 = prm_aab001
--                      AND aae140 = '06';
--            ElSE
--                  v_aae120 := '0';
--            END IF;
--
--           IF  (v_aae120 = '0' AND REC_TMP_PERSON.aae120 = '1') THEN
--             v_message := v_message||'所在单位没有参加机关事业养老保险!';
--             var_flag := 1;
--           END IF;
--
--       END IF;
--
--      --失业保险校验
--       IF REC_TMP_PERSON.aae210 IS NOT NULL THEN
--           SELECT COUNT(1)
--           INTO  n_count
--           FROM ab02
--           WHERE aab001 = prm_aab001
--            AND  aae140 = '02';
--
--            IF n_count > 0 THEN
--                   SELECT decode(aab051,'1','2','0')
--                     INTO  v_aae210
--                     FROM ab02
--                    WHERE aab001 = prm_aab001
--                      AND aae140 = '02';
--            ElSE
--                  v_aae210 := '0';
--            END IF;
--
--           IF  (v_aae210 = '0' AND REC_TMP_PERSON.aae210 = '1') THEN
--             v_message := v_message||'所在单位没有参失业保险!';
--             var_flag := 1;
--           END IF;
--
--       END IF;
--
--      --基本医疗保险校验
--       IF REC_TMP_PERSON.aae310 IS NOT NULL THEN
--           SELECT COUNT(1)
--           INTO  n_count
--           FROM ab02
--           WHERE aab001 = prm_aab001
--            AND  aae140 = '03';
--
--            IF n_count > 0 THEN
--                   SELECT decode(aab051,'1','2','0')
--                     INTO  v_aae310
--                     FROM ab02
--                    WHERE aab001 = prm_aab001
--                      AND aae140 = '03';
--            ElSE
--                  v_aae310 := '0';
--            END IF;
--
--           IF  (v_aae310 = '0' AND REC_TMP_PERSON.aae310 = '1') THEN
--             v_message := v_message||'所在单位没有参加基本医疗保险!';
--             var_flag := 1;
--           END IF;
--
--       END IF;
--
--      --工伤保险校验
--       IF REC_TMP_PERSON.aae410 IS NOT NULL THEN
--           SELECT COUNT(1)
--           INTO  n_count
--           FROM ab02
--           WHERE aab001 = prm_aab001
--            AND  aae140 = '04';
--
--            IF n_count > 0 THEN
--                   SELECT decode(aab051,'1','2','0')
--                     INTO  v_aae410
--                     FROM ab02
--                    WHERE aab001 = prm_aab001
--                      AND aae140 = '04';
--            ElSE
--                  v_aae410 := '0';
--            END IF;
--
--           IF  (v_aae410 = '0' AND REC_TMP_PERSON.aae410 = '1') THEN
--             v_message := v_message||'所在单位没有参加机工伤保险!';
--             var_flag := 1;
--           END IF;
--
--       END IF;
--
--       --生育保险校验
--       IF REC_TMP_PERSON.aae510 IS NOT NULL THEN
--           SELECT COUNT(1)
--           INTO  n_count
--           FROM ab02
--           WHERE aab001 = prm_aab001
--            AND  aae140 = '05';
--
--            IF n_count > 0 THEN
--                   SELECT decode(aab051,'1','2','0')
--                     INTO  v_aae510
--                     FROM ab02
--                    WHERE aab001 = prm_aab001
--                      AND aae140 = '05';
--            ElSE
--                  v_aae510 := '0';
--            END IF;
--
--           IF  (v_aae510 = '0' AND REC_TMP_PERSON.aae510 = '1') THEN
--             v_message := v_message||'所在单位没有参加生育保险!';
--             var_flag := 1;
--           END IF;
--
--       END IF;
--
--      --大额补充医疗保险校验
--       IF REC_TMP_PERSON.aae311 IS NOT NULL THEN
--           SELECT COUNT(1)
--           INTO  n_count
--           FROM ab02
--           WHERE aab001 = prm_aab001
--            AND  aae140 = '07';
--
--            IF n_count > 0 THEN
--                   SELECT decode(aab051,'1','2','0')
--                     INTO  v_aae311
--                     FROM ab02
--                    WHERE aab001 = prm_aab001
--                      AND aae140 = '07';
--            ElSE
--                  v_aae311 := '0';
--            END IF;
--
--           IF  (v_aae311 = '0' AND REC_TMP_PERSON.aae311 = '1') THEN
--             v_message := v_message||'所在单位没有参加大额补充医疗保险!';
--             var_flag := 1;
--           END IF;
--
--       END IF;
--
--       --公务员补助保险校验
--       IF REC_TMP_PERSON.aae810 IS NOT NULL THEN
--           SELECT COUNT(1)
--           INTO  n_count
--           FROM ab02
--           WHERE aab001 = prm_aab001
--            AND  aae140 = '08';
--
--            IF n_count > 0 THEN
--                   SELECT decode(aab051,'1','2','0')
--                     INTO v_aae810
--                     FROM ab02
--                    WHERE aab001 = prm_aab001
--                      AND aae140 = '08';
--            ElSE
--                  v_aae810 := '0';
--            END IF;
--
--           IF  (v_aae810 = '0' AND REC_TMP_PERSON.aae810 = '1') THEN
--             v_message := v_message||'所在单位没有参加公务员补助保险!';
--             var_flag := 1;
--           END IF;
--
--       END IF;
--
--       --险种互斥校验
--       IF REC_TMP_PERSON.aae110 = '1' AND REC_TMP_PERSON.aae120 = '1' THEN
--               v_message:= v_message||'企业职工养老保险和机关养老保险不能一起参保!';
--              var_flag := 1;
--       END IF;
--       IF REC_TMP_PERSON.aae410 = '0' AND v_aae410 = '2' THEN
--               v_message:= v_message||'工伤保险为必参项!';
--              var_flag := 1;
--       END IF;
--       /*根据单位险种绑定个人参保险种*/
--       --单位参保险种有：医疗、失业、生育、大额
--       IF v_aae210 = '2' AND v_aae510 = '2' AND v_aae311 = '2' AND v_aae310 = '2' THEN
--
--             IF REC_TMP_PERSON.aae310 = '1' THEN
--                   IF  REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae510 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
--                         v_message := v_message||'医疗、失业、生育、大额补充四险种必须一起参保!';
--                         var_flag  := 1;
--                    END IF;
--             END IF;
--
--             IF REC_TMP_PERSON.aae210 = '1' THEN
--                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae510 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
--                         v_message := v_message||'医疗、失业、生育、大额补充四险种必须一起参保!';
--                         var_flag  := 1;
--                    END IF;
--             END IF;
--
--             IF REC_TMP_PERSON.aae510 = '1' THEN
--                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
--                         v_message := v_message||'医疗、失业、生育、大额补充四险种必须一起参保!';
--                         var_flag  := 1;
--                    END IF;
--             END IF;
--
--             IF REC_TMP_PERSON.aae311 = '1' THEN
--                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae210 = '0' OR REC_TMP_PERSON.aae510 = '0' THEN
--                         v_message := v_message||'医疗、失业、生育、大额补充四险种必须一起参保!';
--                         var_flag  := 1;
--                    END IF;
--             END IF;
--
--       END IF;
--       --单位参保险种有：医疗、生育、大额
--       IF v_aae510 = '2' AND v_aae311 = '2' AND v_aae310 = '2' THEN
--
--             IF REC_TMP_PERSON.aae510 = '1' THEN
--                   IF  REC_TMP_PERSON.aae310 = '0' OR REC_TMP_PERSON.aae311 = '0' THEN
--                         v_message := v_message||'没有参加基本医疗和大额补充,不能参加生育!';
--                         var_flag  := 1;
--                    END IF;
--             END IF;
--
--             IF REC_TMP_PERSON.aae311 = '1' THEN
--                   IF  REC_TMP_PERSON.aae310 = '0'  THEN
--                         v_message := v_message||'没有参加基本医疗保险,不能参加大额补充医疗!';
--                         var_flag  := 1;
--                    END IF;
--             END IF;
--
--       END IF;
--
--       --单位参保险种有：医疗、大额
--       IF  v_aae311 = '2' AND v_aae310 = '2' THEN
--
--             IF REC_TMP_PERSON.aae311 = '1' THEN
--                   IF  REC_TMP_PERSON.aae310 = '0'  THEN
--                         v_message := v_message||'没有参加基本医疗保险,不能参加大额补充医疗!';
--                         var_flag  := 1;
--                    END IF;
--             END IF;
--
--       END IF;
--
--       IF REC_TMP_PERSON.aac009 = '20' AND REC_TMP_PERSON.yac168 = '0' THEN
--               v_message:= v_message||'户口性质为农业户口,农民工标志不能为‘否’!';
--              var_flag := 1;
--       END IF;
--       IF REC_TMP_PERSON.aac009 <> '20' AND REC_TMP_PERSON.yac168 = '1' THEN
--               v_message:= v_message||'农民工标志为‘否’,户口性质必须为农业户口!';
--              var_flag := 1;
--       END IF;
--
--          --参保时间、参工时间、首次参保时间校验
--       IF REC_TMP_PERSON.aac030 IS NOT NULL THEN
--            IF REC_TMP_PERSON.aac030 > sysdate THEN
--                  v_message:= v_message||'本单位参保时间不能晚于系统时间!';
--                  var_flag := 1;
--          END IF;
--       END IF;
--
--      IF REC_TMP_PERSON.yac033 IS NOT NULL THEN
--            IF REC_TMP_PERSON.yac033 > sysdate THEN
--                  v_message:= v_message||'本单位参保时间不能晚于系统时间!';
--                  var_flag := 1;
--          END IF;
--       END IF;
--
--        IF REC_TMP_PERSON.aac007 IS NOT NULL THEN
--            IF REC_TMP_PERSON.aac007 > sysdate THEN
--                  v_message:= v_message||'参工时间不能晚于系统时间!';
--                  var_flag := 1;
--          END IF;
--      END IF;
--
--        IF REC_TMP_PERSON.aac007 IS NOT NULL AND REC_TMP_PERSON.aac030 IS NOT NULL THEN
--            IF REC_TMP_PERSON.aac007 > REC_TMP_PERSON.aac030 THEN
--                  v_message:= v_message||'参工时间不能晚于参保时间!';
--                  var_flag := 1;
--          END IF;
--      END IF;

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
--      IF LENGTH(TRIM(v_aac002)) = 18 THEN
--             SELECT to_date( substr(TRIM(v_aac002),7,8 ),'yyyy-mm-dd')
--              INTO  d_aac006
--              FROM dual;
--             SELECT decode(mod(to_number(substr(TRIM(v_aac002),17,1)),2),1,'1',0,'2','9')
--              INTO  v_aac004
--              FROM dual;
--      END IF;
--
--      IF LENGTH(TRIM(v_aac002)) = 15 THEN
--             SELECT to_date(( '19' ||  substr(v_aac002,7,6)) ,'yyyy-mm-dd')
--               INTO d_aac006
--               FROM dual;
--             SELECT decode(mod(to_number(substr(TRIM(v_aac002),15,1)),2),1,'1',0,'2','9')
--              INTO v_aac004
--              FROM dual;
--      END IF;
--
--      SELECT decode(REC_TMP_PERSON.aac009,'10','0','20','1')
--        INTO v_yac168
--        FROM dual;
--
--     SELECT  to_number(to_char(sysdate,'yyyymm'))
--       INTO n_aae002
--       FROM dual;
--
--     IF REC_TMP_PERSON.aae310 = 1 THEN
--        SELECT
--        pkg_common.fun_p_getcontributionbase(null,REC_TMP_PERSON.aab001,REC_TMP_PERSON.aac040,'0','03','1','1',n_aae002,PKG_Constant.YAB003_JBFZX)
--        INTO n_yac005
--        FROM dual;
--     ELSE
--        SELECT
--        pkg_common.fun_p_getcontributionbase(null,REC_TMP_PERSON.aab001,REC_TMP_PERSON.aac040,'0','04','1','1',n_aae002,PKG_Constant.YAB003_JBFZX)
--        INTO n_yac005
--        FROM dual;
--     END IF;
--     IF REC_TMP_PERSON.aae110 = 1 THEN
--        SELECT
--         pkg_common.fun_p_getcontributionbase(null,REC_TMP_PERSON.aab001,REC_TMP_PERSON.aac040,'0','01','1','1',n_aae002,PKG_Constant.YAB003_JBFZX)
--        INTO n_yac004
--        FROM dual;
--
--     ELSIF REC_TMP_PERSON.aae120 = 1 THEN
--        n_yac004 := REC_TMP_PERSON.yac004;
--     END IF;

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
                     REC_TMP_PERSON.aac002,             -- 身份证号码(证件号码) -->
                     REC_TMP_PERSON.aac003,-- 姓名         -->
                     REC_TMP_PERSON.aac004,             -- 性别         -->
                     REC_TMP_PERSON.aac005,-- 民族         -->
                     REC_TMP_PERSON.aac006             ,-- 出生日期     -->
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
                     REC_TMP_PERSON.yac168,             -- 农民工标志   -->
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
                     REC_TMP_PERSON.yac004,-- 缴费基数[养老] -->
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
                     REC_TMP_PERSON.yac005,-- 缴费基数[其它] -->
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
     ELSIF var_flag = 1 THEN
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
   prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
   RETURN;
   END prc_batchImport;
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
      prm_ErrorMsg        OUT           VARCHAR2)    --出错信息
    IS
      num_count           NUMBER(6);
      var_iaa100          VARCHAR2(15);--单位最近的申报月度
      var_iaa100nex       VARCHAR2(15);--单位申报月度的下个月度
      var_sysmonth        VARCHAR2(23);--当前时间月度
      var_sysnexmonth     VARCHAR2(23);--当前时间的下个月度
      var_yae097          VARCHAR2(23);--最大做账期
      var_yae097nex       VARCHAR2(23);--最大做账期的下个月度
      num_ab02count        NUMBER;--针对单养老新开户单位判断
    BEGIN
      /*初始化变量*/
       prm_AppCode  := GN_DEF_OK;
       prm_ErrorMsg := '';
       prm_msg :='';
       prm_sign :='0';
       prm_flag :='';--0首次进入申报，1进入申报，2正在审核中  3审核打回  4审核通过 5还未到达申报时间
      --判断是否为单养老单位
      SELECT count(1)
        INTO num_ab02count
        FROM xasi2.ab02 a
        WHERE a.aab001 = prm_aab001
        AND a.aab051='1';
       --单位征集方式确定
       SELECT count(1)
         INTO num_count
        FROM wsjb.irab03  a
       WHERE a.aab001 = prm_aab001;
      IF num_count = 0 THEN
         prm_msg :=  '没有可用的单位征集方式，请联系咨询社保中心！';
        prm_sign := '1';
        GOTO label_OUT;
      END IF;
      IF num_ab02count>0 THEN
       --获取单位当前最大做账期
       SELECT TO_CHAR(SYSDATE, 'yyyymm') SYS100,
             TO_CHAR(ADD_MONTHS(SYSDATE, 1), 'yyyymm') SYSNEX,
             TO_CHAR(NVL(MAX(YAE097), '999999')) IAA100,
             TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(NVL(MAX(YAE097),TO_CHAR(SYSDATE,'yyyymm'))),'yyyymm'),1),'yyyymm') NEX100
        INTO var_sysmonth,
             var_sysnexmonth,
             var_yae097,
             var_yae097nex
       FROM ( SELECT YAE097
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
         prm_msg :=  prm_msg||'获取最大做账期号出错！';
        prm_sign := '1';
        GOTO label_OUT;
       END IF;
       ELSIF num_ab02count = 0 THEN
       SELECT count(1)
        INTO  num_count
        FROM wsjb.irab08
        WHERE AAB001 = prm_aab001
         AND YAE517 = 'H01'
         AND AAE140 = '01';
       IF num_count>0 THEN
       --获取单位当前最大做账期
       SELECT TO_CHAR(SYSDATE, 'yyyymm') SYS100,
             TO_CHAR(ADD_MONTHS(SYSDATE, 1), 'yyyymm') SYSNEX,
             TO_CHAR(NVL(MAX(YAE097), '999999')) IAA100,
             TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(NVL(MAX(YAE097),TO_CHAR(SYSDATE,'yyyymm'))),'yyyymm'),1),'yyyymm') NEX100
        INTO var_sysmonth,
             var_sysnexmonth,
             var_yae097,
             var_yae097nex
       FROM ( SELECT AAE003 AS YAE097
                FROM wsjb.irab08
               WHERE AAB001 = prm_aab001
                 AND YAE517 = 'H01'
                 AND AAE140 = '01');
       ELSIF num_count = 0 THEN
       SELECT TO_CHAR(SYSDATE,'yyyyMM')
         INTO var_yae097nex
         FROM dual;
       SELECT TO_CHAR(SYSDATE, 'yyyymm') SYS100,
             TO_CHAR(ADD_MONTHS(SYSDATE, 1), 'yyyymm') SYSNEX,
             TO_CHAR(ADD_MONTHS(SYSDATE,-1), 'yyyymm') IAA100
       INTO var_sysmonth,
             var_sysnexmonth,
             var_yae097
       FROM dual;
       END IF;
       END IF;
       --默认最大做账期的下一期
       prm_iaa100 := var_yae097nex;

       --获取单位最大申报月度
        SELECT NVL(MAX(A.IAA100), '999999') IAA100,
              TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(NVL(MAX(A.IAA100),TO_CHAR(SYSDATE,'yyyymm'))),'yyyymm'),1),'yyyymm') NEX100
         INTO var_iaa100,
              var_iaa100nex
         FROM wsjb.irad01  A
        WHERE A.IAA011 = 'A04'
          AND A.AAB001 = prm_aab001;
      IF var_iaa100 = '999999' THEN --还没有申报过（第一次进系统）
        IF var_yae097  <= var_sysmonth THEN
          prm_iaa100 := var_yae097nex;
           prm_msg :=  '当前可申报的月度为'||prm_iaa100||'！';
          prm_flag := '0';
          GOTO label_OUT;
        ELSE
          prm_iaa100 := var_yae097nex;
           prm_msg :=  '还未到达申报时间！';
          prm_flag := '5';
          GOTO label_OUT;
        END IF;
       END IF;

       --最大做账期 和 当前时间月度 比较
       --最大做账期 < 当前时间月度
       IF var_yae097 < var_sysmonth THEN
         --最大做账期 < 最大申报月度（已经申报）
         IF var_yae097 < var_iaa100 THEN

           --是否存在打回信息
           SELECT count(1)
             INTO num_count
             FROM wsjb.irac01
            WHERE aab001 = prm_aab001
              AND iaa100 = var_iaa100
              AND iaa002 = '4';
           IF num_count > 0 THEN
             prm_iaa100 := var_iaa100;
             prm_msg :=  '已经申报月度为：'||var_iaa100||'的人员信息,存在打回信息，需要修改内容继续申报!';
            prm_flag := '3';
            GOTO label_OUT;
           END IF;

           --是否还在审核中
           SELECT count(1)
             INTO num_count
             FROM wsjb.irac01
            WHERE aab001 = prm_aab001
              AND iaa100 = var_iaa100
              AND iaa002 = '1';
           IF num_count > 0 THEN
             prm_iaa100 := var_iaa100;
             prm_msg :=  '已经申报月度为：'||var_iaa100||'的人员信息，还在审核中，不能再做人员增减操作！';
            prm_flag := '2';
            GOTO label_OUT;
           END IF;

          --是否核定
          -- 地税平台  20181224
       --   IF  to_number(var_iaa100) > 201812  THEN

          SELECT SUM(n)
            INTO num_count
            FROM ( SELECT COUNT(1) N
                     FROM xasi2.AB08 A
                    WHERE A.AAB001 = prm_aab001
                      AND A.YAE517 = 'H01'
                      AND A.AAE003 = var_iaa100
                   UNION ALL
                   SELECT COUNT(1) N
                     FROM xasi2.AB08A8 A
                    WHERE A.AAB001 = prm_aab001
                      AND A.YAE517 = 'H01'
                      AND A.AAE003 = var_iaa100
                   UNION ALL
                   SELECT COUNT(1) N
                     FROM wsjb.irab08  A
                    WHERE A.AAB001 = prm_aab001
                      AND A.YAE517 = 'H01'
                      AND A.AAE003 = var_iaa100 );
           IF num_count = 0 THEN
             prm_iaa100 := var_iaa100;
             prm_msg :=  '已经申报月度为：'||var_iaa100||'的人员信息，还在审核中，不能再做人员增减操作！';
            prm_flag := '2';
            GOTO label_OUT;
           END IF;

       --  END IF;


         END IF;

         --最大做账期 = 最大申报月度（可以申报）
         IF var_yae097 = var_iaa100 THEN
           prm_iaa100 := var_yae097nex;
           prm_msg :=  '当前可申报的月度为'||prm_iaa100||'！';
          prm_flag := '1';
          GOTO label_OUT;
         END IF;

        /*  201904以前的
       ELSIF var_yae097 = var_sysmonth THEN --最大做账期 = 当前时间月度 （当月已经核定完成）
         prm_iaa100 := var_yae097;
         prm_msg :=  prm_iaa100||'月度，月度缴费申报审核完成！';
        prm_flag := '4';
        */
          /*201904以后的*/
        ELSIF var_yae097 = var_sysmonth THEN --最大做账期 = 当前时间月度 （可以做下一期增减）
        prm_msg :=  '可以进行'||prm_iaa100||'月度的人员增减申报！';
        prm_flag := '6';
        GOTO label_OUT;
      ELSE
       -- prm_iaa100 := var_yae097;
        prm_msg :=  prm_iaa100||'月度人员增减尚未到申报期！';
        prm_sign := '1';
        GOTO label_OUT;
       END IF;
       /*201904以后的*/


    <<label_OUT>>
     num_count := 0;

   EXCEPTION
     WHEN OTHERS THEN
     /*关闭打开的游标*/
     ROLLBACK;
     prm_AppCode  :=  gn_def_ERR;
     prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
     RETURN;
    END prc_p_ValidateMonthApply;
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
      prm_ErrorMsg        OUT           VARCHAR2)    --出错信息

   IS
       num_count           NUMBER(6);
      var_aae003          VARCHAR2(23);--费款所属期
      var_aae003pre       VARCHAR2(23);--当前时间的上一个月度
      var_aae003pre2       VARCHAR2(23);--当前时间的上一个月度


   BEGIN
      /*初始化变量*/
       prm_AppCode  := GN_DEF_OK;
       prm_ErrorMsg := '';
       prm_msg :='';
       prm_sign :='0';

    --如果当前时间大于15号，则判断当月是否月报
    IF to_char(SYSDATE,'dd')>15 THEN
      var_aae003 := to_char(SYSDATE,'yyyymm');
      SELECT SUM(I)
        INTO num_count
        FROM (SELECT COUNT(1) AS I
                FROM wsjb.irab08
               WHERE YAE517 = 'H01'
                 AND AAB001 = prm_aab001
                 AND AAE003 = var_aae003
              UNION
              SELECT COUNT(1) AS I
                FROM xasi2.AB08
               WHERE YAE517 = 'H01'
                 AND AAB001 = prm_aab001
                 AND AAE003 = var_aae003
              UNION
              SELECT COUNT(1) AS I
                FROM xasi2.AB08A8
               WHERE YAE517 = 'H01'
                 AND AAB001 = prm_aab001
                 AND AAE003 = var_aae003);
      IF num_count = 0 THEN
         prm_msg :=  '单位'||var_aae003||'月度缴费申报尚未完成，请完成后再进行社保证明申请！';
        prm_sign := '1';
        GOTO label_OUT;
      END IF;
    END IF;
    --上月是否月报
    var_aae003pre := to_char(add_months(SYSDATE,-1),'yyyyMM');
    SELECT SUM(I)
      INTO num_count
      FROM (SELECT COUNT(1) AS I
              FROM wsjb.irab08
             WHERE YAE517 = 'H01'
               AND AAB001 = prm_aab001
               AND AAE003 = var_aae003pre
            UNION
            SELECT COUNT(1) AS I
              FROM xasi2.AB08
             WHERE YAE517 = 'H01'
               AND AAB001 = prm_aab001
               AND AAE003 = var_aae003pre
            UNION
            SELECT COUNT(1) AS I
              FROM xasi2.AB08A8
             WHERE YAE517 = 'H01'
               AND AAB001 = prm_aab001
               AND AAE003 = var_aae003pre);
    IF num_count = 0 THEN
       prm_msg :=  '单位'||var_aae003pre||'月度缴费申报尚未完成，请完成后再进行社保证明申请！';
      prm_sign := '1';
      GOTO label_OUT;
    END IF;
    --判断单位是否参医疗保险，如果不参，不做实收（当前时间的上两个月）判断
    SELECT COUNT(1)
      INTO num_count
      FROM xasi2.AB02
     WHERE AAB001 = prm_aab001
       AND AAE140 = '03'
       AND AAB051 = '1';
    IF num_count > 0 THEN
      --当前月的上两个月
      var_aae003pre2 := to_char(add_months(SYSDATE,-2),'yyyyMM');
      --上两个月医疗是否实收
      SELECT COUNT(1) AS I
        INTO num_count
        FROM xasi2.AB08A8
       WHERE YAE517 = 'H01'
         AND AAE140 = '03'
         AND AAB001 = prm_aab001
         AND AAE003 = var_aae003pre2;
      IF num_count = 0 THEN
        prm_msg :=  '单位'||var_aae003pre2||'医疗保险账务尚未到账，请先到社保中心经行账务核对后，再进行出具！';
        prm_sign := '1';
        GOTO label_OUT;
      END IF;
    END IF;

    --判断单位是否存在待审核的月报记录
    SELECT SUM(C) AS C
      INTO num_count
      FROM (SELECT COUNT(1) AS C
              FROM (SELECT (SELECT COUNT(1)
                              FROM xasi2.ab08
                             WHERE AAB001 = B.AAB001
                               AND AAE003 = B.IAA100
                               AND YAE517 = 'H01') +
                           (SELECT COUNT(1)
                              FROM xasi2.ab08a8
                             WHERE AAB001 = B.AAB001
                               AND AAE003 = B.IAA100
                               AND YAE517 = 'H01') +
                           (SELECT COUNT(1)
                              FROM wsjb.irab08
                             WHERE AAB001 = B.AAB001
                               AND AAE003 = B.IAA100
                               AND YAE517 = 'H01') AAE003
                      FROM wsjb.irab01  A, wsjb.irad01  B
                     WHERE A.AAB001 = B.AAB001
                       AND A.AAB001 = A.IAB001
                       AND A.IAA002 = '2'
                       AND B.IAA011 = 'A04'
                       AND A.AAB001 = prm_aab001
                       AND NOT EXISTS (SELECT IAZ004
                              FROM wsjb.irad02 , wsjb.irac01  C
                             WHERE IAZ004 = B.IAZ004
                               AND IAZ007 = C.IAC001
                               AND C.IAA002 IN ('1', '4')))
               WHERE AAE003 = 0
              UNION ALL
              SELECT COUNT(1) AS C
                FROM wsjb.irab01  A, wsjb.irad01  B
               WHERE A.AAB001 = B.AAB001
                 AND A.AAB001 = A.IAB001
                 AND A.IAA002 = '2'
                 AND B.IAA011 = 'A04'
                 AND A.AAB001 = prm_aab001
                 AND EXISTS (SELECT IAZ004
                        FROM wsjb.irad02 , wsjb.irac01  C
                       WHERE IAZ004 = B.IAZ004
                         AND IAZ007 = C.IAC001
                         AND C.IAA002 IN ('1', '4')));
     IF num_count > 0 THEN
         prm_msg :=  '单位月度缴费申报未审核完成，待审核完成后，再进行证明出具。';
        prm_sign := '1';
        GOTO label_OUT;
     END IF;

    <<label_OUT>>
     num_count := 0;

   EXCEPTION
     WHEN OTHERS THEN
     /*关闭打开的游标*/
     ROLLBACK;
     prm_AppCode  :=  gn_def_ERR;
     prm_ErrorMsg := '数据库错误:'|| SQLERRM ;
     RETURN;
   END prc_p_ValidateProveApply;

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
  PROCEDURE prc_p_ValidateAddKindYesOrNo(prm_aab001   IN VARCHAR2, --单位编号
                                         prm_aac001   IN VARCHAR2, --个人编号
                                         prm_aae140   IN VARCHAR2, --险种
                                         prm_yab139   IN VARCHAR2, --经办机构
                                         prm_flag     OUT VARCHAR2, --返回状态标志
                                         prm_msg      OUT VARCHAR2, --提示信息
                                         prm_AppCode  OUT VARCHAR2, --执行代码
                                         prm_ErrorMsg OUT VARCHAR2) --出错信息
   IS
    v_flag   varchar2(1);
    v_msg    varchar2(4500);
    v_yon    varchar2(9);
    v_aab001 irac01.aab001%TYPE;
    v_aac031 irac01.aac031%TYPE;
  BEGIN
    --初始化变量
    prm_AppCode  := GN_DEF_OK;
    prm_ErrorMsg := '';
    v_flag   := '0'; --正常(0--正常，1--错误，2--警告)
    v_msg    := '';
    v_yon    := '';
    v_aab001 := '';
    v_aac031 := '0'; --默认未参保

    --判断该单位是否参加此险种

    BEGIN
      select 1
        into v_yon
        from (select b.aae140
                from xasi2.ab02 b
               where 1 = 1
                 and b.aab001 = prm_aab001
                 and b.aab051 = '1'
              union
              select '01' as aae140
                from wsjb.irab01  a
               where a.iab001 = a.aab001
                 and a.iaa002 = '2'
                 and a.aab001 = prm_aab001
                 and a.aae110 = '1') r
       where r.aae140 = prm_aae140;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_flag := '1';
        v_msg  := '单位没有参加' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  ',不能新增该险种！';
        goto label_out;
      WHEN TOO_MANY_ROWS THEN
        v_flag := '1';
        v_msg  := '单位找到多条' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  '参保记录,请联系社保中心！';
        goto label_out;
      WHEN OTHERS THEN
        v_flag := '1';
        v_msg  := '未知错误，请联系系统维护人员！';
        goto label_out;
    END;

    if v_yon <> '1' then
      v_flag := '1';
      v_msg  := '单位没有参加' ||
                xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                ',不能新增该险种！';
      goto label_out;
    end if;

    if prm_aae140 = '04' then
      begin
        select r.aab001, r.aac031
          into v_aab001, v_aac031
          from (select a.aab001, a.aae140, a.aac031
                  from xasi2.ac02 a
                 where a.aac001 = prm_aac001
                union
                select b.aab001,
                       '01' as aae140,
                       decode(b.aae110, '2', '1', '21', '2', '0', '') as aac031
                  from wsjb.irac01a3  b
                 where b.aac001 = prm_aac001
                   and b.aae110 = '2') r
         where r.aae140 = prm_aae140
           and r.aab001 = prm_aab001;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_flag := '0';
          goto label_out;
      end;

      if v_aab001 is not null or v_aac031 = '1' then
        v_flag := '1';
        v_msg  := '此人已经在本单位的' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  '为'||xasi2.pkg_comm.fun_getAaa103('AAC031', v_aac031)||'状态！';
        goto label_out;
      end if;

      /*begin
        select r.aab001, r.aac031
          into v_aab001, v_aac031
          from (select a.aab001, a.aae140, a.aac031
                  from xasi2.ac02 a
                 where a.aac001 = prm_aac001
                union
                select b.aab001,
                       '01' as aae140,
                       decode(b.aae110, '2', '1', '21', '2', '0', '') as aac031
                  from irac01a3 b
                 where b.aac001 = prm_aac001
                   and b.aae110 = '2') r
         where r.aae140 = prm_aae140
           and r.aab001 <> prm_aab001;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_flag := '0';
          goto label_out;
      end;

      if v_aab001 is not null or v_aac031 = '1' then
        v_flag := '1';
        v_msg  := '此人已经在' || v_aab001 || '单位参加了' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  ',不能新增该险种！';
        goto label_out;
      end if;*/
    else

      --判断人员该险种是否正常参保
      BEGIN
        select r.aab001, r.aac031
          into v_aab001, v_aac031
          from (select a.aab001, a.aae140, a.aac031
                  from xasi2.ac02 a
                 where a.aac001 = prm_aac001
                union
                select b.aab001,
                       '01' as aae140,
                       decode(b.aae110, '2', '1', '21', '2', '0', '') as aac031
                  from wsjb.irac01a3  b
                 where b.aac001 = prm_aac001
                   and b.aae110 = '2') r
         where r.aae140 = prm_aae140;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_flag := '0';
          goto label_out;
        WHEN TOO_MANY_ROWS THEN
          v_flag := '1';
          v_msg  := '此人找到多条' ||
                    xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                    '参保记录,请联系社保中心！';
          goto label_out;
        WHEN OTHERS THEN
          v_flag := '1';
          v_msg  := '未知错误，请联系系统维护人员！';
          goto label_out;
      END;

      if v_aab001 is not null or v_aac031 is not null then
        v_flag := '1';
        v_msg  := '此人已经在' || v_aab001 || '单位的' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  '为'||xasi2.pkg_comm.fun_getAaa103('AAC031', v_aac031)||'状态！';
        goto label_out;
      end if;
    end if;

    <<label_out>>
    prm_flag := v_flag;
    prm_msg  := v_msg;

  EXCEPTION
    WHEN OTHERS THEN
      /*关闭打开的游标*/
      ROLLBACK;
      prm_AppCode  := gn_def_ERR;
      prm_ErrorMsg := '数据库错误:' || SQLERRM;
      RETURN;
  END prc_p_ValidateAddKindYesOrNo;

--校验批量人员新增险种
PROCEDURE prc_p_ValidKindsBatchAddCheck(PRM_IAZ018 IN VARCHAR2,
                                       PRM_AAB001   IN VARCHAR2,
                                       PRM_IAA100   IN VARCHAR2,
                                       PRM_APPCODE  OUT VARCHAR2,
                                       PRM_ERRORMSG OUT VARCHAR2) IS
  v_aac001      irac01.aac001%TYPE;
  v_flag        varchar2(3);
  v_msg         varchar2(4500);
  v_aaa010      number(14, 2);
  v_aac004      irac01.aac004%TYPE;
  v_aac005      irac01.aac005%TYPE;
  v_aac006      date;
  v_aac007      date;
  v_aac008      irac01.aac008%TYPE;
  v_aac009      irac01.aac009%TYPE;
  v_aac013      irac01.aac013%TYPE;
  v_yac033      date;
  v_yac005      number(14, 2);
  v_yac004      number(14, 2);
  var_15aac002  irac01.aac002%TYPE;
  var_aac002Low irac01.aac002%TYPE;
  num_count     number(6);
  v_aac040_old  number(14, 2);
  v_aae210       irac01.aae210%TYPE;
  v_aae310       irac01.aae310%TYPE;
  v_aae410       irac01.aae410%TYPE;
  v_aae510       irac01.aae510%TYPE;
  v_aae311       irac01.aae311%TYPE;
  v_aae120       irac01.aae120%TYPE;
  cursor cur_temp is
    SELECT a.iaz018,
       a.iaa001,
       a.iaa002,
       a.aac001,
       a.aab001,
       a.yae181,
       a.yac067,
       a.aac002,
       a.aac003,
       a.aac004,
       a.aac005,
       a.aac006,
       a.aac007,
       a.aac008,
       a.aac009,
       a.aac010,
       a.aac011,
       a.aac012,
       a.aac013,
       a.aac014,
       a.aac015,
       a.aac020,
       a.yac168,
       a.yac197,
       a.yac502,
       a.yae407,
       a.yae496,
       a.yic067,
       a.aae004,
       a.aae005,
       a.aae006,
       a.aae007,
       a.yae222,
       a.yac200,
       a.aae110,
       a.aac031,
       a.yac505,
       a.yac033,
       a.aac030,
       a.yae102,
       a.yae097,
       a.yac503,
       a.aac040,
       a.yac004,
       a.yaa333,
       a.yab013,
       a.yac002,
       a.yab139,
       a.aae011,
       a.aae036,
       a.yab003,
       a.aae013,
       a.aaz002,
       a.aae120,
       a.aae210,
       a.aae310,
       a.aae410,
       a.aae510,
       a.aae311,
       a.akc021,
       a.ykc150,
       a.ykb109,
       a.aic162,
       a.yac005,
       a.aae100,
       a.errormsg,
       a.aac021,
       a.aac022,
       a.aac025,
       a.aac026,
       a.aae810,
       a.iaa100,
       a.aae009,
       a.aae008,
       a.aae010,
       a.yad050
       FROM wsjb.tmp_irac01a2 a
       WHERE iaz018 = prm_iaz018;

BEGIN
  prm_AppCode  := GN_DEF_OK;
  prm_ErrorMsg := '';
  v_aaa010   := 0;

  IF prm_aab001 IS NULL THEN
    prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
    prm_ErrorMsg := 'prm_aab001单位编号不能为空！';
    RETURN;
  END IF;

  IF PRM_IAA100 IS NULL THEN
    prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
    prm_ErrorMsg := 'prm_iaa100申报月度不能为空！';
    RETURN;
  END IF;

  --获取年度省级最低工资
  SELECT aaa010
    into v_aaa010
    FROM xasi2.AA02A1
   WHERE YAB139 = '610127'
     AND AAE001 = substr(prm_iaa100, 0, 4)
     AND YAA001 = '13';

  FOR REC_TEMP IN CUR_TEMP LOOP
    v_aae210  :='0';
    v_aae310  :='0';
    v_aae410  :='0';
    v_aae510  :='0';
    v_aae311  :='0';
    v_aae120  :='0';

    v_flag       := '0'; --校验标志（0-正常；1-错误；2 -警告）
    v_msg        := '';
    num_count    := 0;
    v_aac040_old := 0;

    --获取各种形式的证件号码
    var_15aac002  := SUBSTR(rec_temp.aac002, 1, 6) ||
                     SUBSTR(rec_temp.aac002, 9, 9);
    var_aac002Low := LOWER(rec_temp.aac002);

    SELECT count(1)
      INTO num_count
      FROM xasi2.ac01 A
     WHERE AAE120 = '0'
       AND A.AAC002 IN (var_15aac002, var_aac002Low, rec_temp.aac002)
       and replace(a.aac003, ' ', '') = rec_temp.aac003
       AND AAC003 NOT LIKE '%重复%';

    IF num_count = 0 THEN
      v_msg  := '证件号为：[' || rec_temp.aac002 ||
                ']的人员不存在个人信息或者姓名有误，请在新参保模块里操作！';
      v_flag := '1';
    END IF;
    IF num_count > 1 THEN
      v_msg  := '证件号为：[' || rec_temp.aac002 || ']的人员存在多条个人信息，请在联系社保中心！';
      v_flag := '1';
    END IF;

    begin
      SELECT aac001
        INTO v_aac001
        FROM xasi2.ac01 A
       WHERE AAE120 = '0'
         AND A.AAC002 IN (var_15aac002, var_aac002Low, rec_temp.aac002)
         and replace(a.aac003, ' ', '') = rec_temp.aac003
         AND AAC003 NOT LIKE '%重复%';
    exception
      when no_data_found then
        v_flag := '1';
        v_msg  := '证件号为：[' || rec_temp.aac002 ||
                  ']的人员不存在个人信息或者姓名有误，请在新参保模块里操作！';
    end;

    if v_flag = '0' then
      pkg_p_validate.prc_p_ValidateAac002KindAdd('1',
                                                 rec_temp.aac002,
                                                 prm_aab001,
                                                 prm_iaa100,
                                                 v_aac001,
                                                 v_msg,
                                                 v_flag,
                                                 prm_AppCode,
                                                 prm_ErrorMsg);
    end if;

   /* if v_flag = '0' and rec_temp.aac040 < v_aaa010 then
      v_flag := '1';
      v_msg  := '申报工资低于陕西省最低工资标准' || v_aaa010 || '!';
    end if;*/

    if v_flag = '0' then
      SELECT to_number(MIN(AAC040))
        into v_aac040_old
        FROM (SELECT AAC040
                FROM xasi2.AC02
               WHERE AAB001 = prm_aab001
                 AND AAC001 = v_aac001
                 AND AAE140 NOT IN ('06', '07', '08')
                 and aac031 = '1'
              UNION ALL
              SELECT AAC040
                FROM wsjb.irac01a3
               WHERE AAB001 = prm_aab001
                 AND AAC001 = v_aac001
                 AND AAE110 = '2');
      if v_aac040_old != rec_temp.aac040 then
        v_flag := '1';
        v_msg  := '申报工资' || rec_temp.aac040 || '与之前参保工资' || v_aac040_old ||
                  '不一致!';
      end if;
    end if;

    if v_flag = '0' and rec_temp.aae110 = '1' then
      prc_p_ValidateAddKindYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '01',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae210 = '1' then
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aab001 = prm_aab001 AND aae140='02' AND aac031='1';
      IF num_count = 0 THEN
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aae140='02' AND aac031='2';
      IF num_count =0 THEN
       v_aae210 :='1';
       ELSIF num_count =1 THEN
       v_aae210 :='10';
       END IF;
      ELSIF num_count = 1 THEN
      v_aae210 :='2';
      END IF;
    end if;

    if v_flag = '0' and rec_temp.aae310 = '1' then
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aab001 = prm_aab001 AND aae140='03' AND aac031='1';
      IF num_count = 0 THEN
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aae140='02' AND aac031='2';
      IF num_count =0 THEN
       v_aae310 :='1';
       ELSIF num_count =1 THEN
       v_aae310 :='10';
       END IF;
      ELSIF num_count = 1 THEN
      v_aae310 :='2';
      END IF;
    end if;

    if v_flag = '0' and rec_temp.aae410 = '1' then
       SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aab001 = prm_aab001 AND aae140='04' AND aac031='1';
      IF num_count = 0 THEN
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aae140='02' AND aac031='2';
      IF num_count =0 THEN
       v_aae410 :='1';
       ELSIF num_count =1 THEN
       v_aae410 :='10';
       END IF;
      ELSIF num_count = 1 THEN
      v_aae410 :='2';
      END IF;
    end if;

    if v_flag = '0' and rec_temp.aae510 = '1' then
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aab001 = prm_aab001 AND aae140='05' AND aac031='1';
      IF num_count = 0 THEN
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aae140='02' AND aac031='2';
      IF num_count =0 THEN
       v_aae510 :='1';
       ELSIF num_count =1 THEN
       v_aae510 :='10';
       END IF;
      ELSIF num_count = 1 THEN
      v_aae510 :='2';
      END IF;
    end if;

    if v_flag = '0' and rec_temp.aae120 = '1' then
       SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aab001 = prm_aab001 AND aae140='06' AND aac031='1';
      IF num_count = 0 THEN
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aae140='02' AND aac031='2';
      IF num_count =0 THEN
       v_aae120 :='1';
       ELSIF num_count =1 THEN
       v_aae120 :='10';
       END IF;
      ELSIF num_count = 1 THEN
      v_aae120 :='2';
      END IF;
    end if;

    if v_flag = '0' and rec_temp.aae311 = '1' then
       SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aab001 = prm_aab001 AND aae140='07' AND aac031='1';
      IF num_count = 0 THEN
      SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001=v_aac001 AND aae140='02' AND aac031='2';
      IF num_count =0 THEN
       v_aae311 :='1';
       ELSIF num_count =1 THEN
       v_aae311 :='10';
       END IF;
      ELSIF num_count = 1 THEN
      v_aae311 :='2';
      END IF;
    end if;

    if v_flag = '0' and rec_temp.aae810 = '1' then
      prc_p_ValidateAddKindYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '08',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae110 = '1' and rec_temp.aae120 = '1' then
      v_flag := '1';
      v_msg  := '企业养老和机关养老险种不能同时参保！';
    end if;

    if v_flag is null then
      v_flag := '0';
    end if;

    if v_msg is null then
      v_msg := '';
    end if;

    if v_flag = '0' then

      SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,
                                                             prm_aab001,
                                                             rec_temp.aac040,
                                                             '0',
                                                             decode(rec_temp.aae310,
                                                                    '1',
                                                                    '03',
                                                                    '04'),
                                                             '1',
                                                             '1',
                                                             prm_iaa100,
                                                             '610127'))
        into v_yac005
        FROM dual;

      if rec_temp.aae110 = '1' OR rec_temp.aae110 ='10' then
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,
                                                               prm_aab001,
                                                               rec_temp.aac040,
                                                               '0',
                                                               '01',
                                                               '1',
                                                               '1',
                                                               prm_iaa100,
                                                               '610127'))
          into v_yac004
          FROM dual;
      elsif rec_temp.aae120 = '1' then
        v_yac004 := rec_temp.aac040;
      else
        v_yac004 := 0;
      end if;

      select a.aac004,
             a.aac005,
             a.aac006,
             a.aac007,
             a.aac008,
             a.aac009,
             a.aac013
        into v_aac004,
             v_aac005,
             v_aac006,
             v_aac007,
             v_aac008,
             v_aac009,
             v_aac013
        from xasi2.ac01 a
       where a.aae120 = '0'
         and a.aac001 = v_aac001;

      select min(yac033)
        into v_yac033
        from xasi2.ac02
       where aac001 = v_aac001;

      update wsjb.tmp_irac01a2  a
         set a.aae100 = '0',
             a.errormsg = a.errormsg||v_msg,
             a.iaa100    = '',
             a.aac001    = v_aac001,
             a.aab001    = prm_aab001,
             a.yac004    = v_yac004,
             a.yac005    = v_yac005,
             a.aae210    = v_aae210,
             a.aae310     = v_aae310,
             a.aae410     = v_aae410,
             a.aae510     = v_aae510,
             a.aae311     = v_aae311
       where a.iaz018 = prm_iaz018
       AND    a.aac002 = rec_temp.aac002;

      if sql%rowcount = 0 then
        prm_appcode  := PRE_ERRCODE || GN_DEF_ERR;
        prm_errormsg := 'prc_p_ValidKindBatchAddCheck出错,出错原因:没有更新到校验结果信息！';
        return;
      end if;

      if sql%rowcount > 1 then
        prm_appcode  := PRE_ERRCODE || GN_DEF_ERR;
        prm_errormsg := 'prc_p_ValidKindBatchAddCheck出错,出错原因:更新到多条校验结果信息！';
        return;
      end if;
    else
      update wsjb.tmp_irac01a2  a
         set a.aae100 = '1',
             a.errormsg = a.errormsg||v_msg,
             a.iaa100    = '',
             a.aab001    = prm_aab001,
             a.aac001    = v_aac001,
             a.yac004    = v_yac004,
             a.yac005    = v_yac005,
             a.aae210    = v_aae210,
             a.aae310     = v_aae310,
             a.aae410     = v_aae410,
             a.aae510     = v_aae510,
             a.aae311     = v_aae311
       where a.iaz018 = prm_iaz018
       AND    a.aac002 = rec_temp.aac002;

      if sql%rowcount = 0 then
        prm_appcode  := PRE_ERRCODE || GN_DEF_ERR;
        prm_errormsg := 'prc_p_ValidKindBatchAddCheck出错,出错原因:没有更新到校验结果信息！';
        return;
      end if;

      if sql%rowcount > 1 then
        prm_appcode  := PRE_ERRCODE || GN_DEF_ERR;
        prm_errormsg := 'prc_p_ValidKindBatchAddCheck出错,出错原因:更新到多条校验结果信息！';
        return;
      end if;
    end if;

  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    PRM_APPCODE  := PRE_ERRCODE || GN_DEF_ERR;
    PRM_ERRORMSG := 'prc_p_ValidKindBatchAddCheck出错,出错原因:' || SQLERRM ||
                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
    RETURN;
END prc_p_ValidKindsBatchAddCheck;

 --校验批量人员续保
PROCEDURE prc_p_ValidBatchContinueCheck(PRM_IAZ018 IN VARCHAR2,
                                       PRM_AAB001   IN VARCHAR2,
                                       PRM_IAA100   IN VARCHAR2,
                                       PRM_APPCODE  OUT VARCHAR2,
                                       PRM_ERRORMSG OUT VARCHAR2) IS
  v_aac001      irac01.aac001%TYPE;
  v_flag        varchar2(3);
  prm_flag      VARCHAR2(3);
  v_msg         varchar2(4500);
  v_aaa010      number(14, 2);
  v_aac004      irac01.aac004%TYPE;
  v_aac005      irac01.aac005%TYPE;
  v_aac006      date;
  v_aac007      date;
  v_aac008      irac01.aac008%TYPE;
  v_aac009      irac01.aac009%TYPE;
  v_aac013      irac01.aac013%TYPE;
  v_yac033      date;
  v_yac005      number(14, 2);
  v_yac004      number(14, 2);
  var_15aac002  irac01.aac002%TYPE;
  var_aac002Low irac01.aac002%TYPE;
  num_count     number(6);
  v_aac040_old  number(14, 2);
  v_ab02aae210  irac01.aae210%TYPE;
  v_ab02aae310  irac01.aae310%TYPE;
  v_ab02aae410  irac01.aae410%TYPE;
  v_ab02aae510  irac01.aae510%TYPE;
  v_ab02aae311  irac01.aae311%TYPE;
  v_aae210      irac01.aae210%TYPE;
  v_aae310      irac01.aae310%TYPE;
  v_aae410      irac01.aae410%TYPE;
  v_aae510      irac01.aae510%TYPE;
  v_aae311      irac01.aae311%TYPE;
  v_aac012      irac01.aac012%TYPE; 
  n_ac02count    NUMBER;
  n_ab02count    NUMBER;
  COUNT_JM       NUMBER;
  Count_ZG       NUMBER;
  var_18aac002   irac01.aac002%TYPE;
  var_aac003     irac01.aac003%TYPE;
  var_aac001_more   irac01.aac001%TYPE;
  VAR_AAB004     irab01.aab004%TYPE;
   nl_aac006        NUMBER;
   sj_months        NUMBER;
   xb_aac004      irac01.aac004%TYPE;
   man_months    NUMBER;
   woman_months    NUMBER;
   zy_aac008     irac01.aac008%TYPE;
   zy_akc021     irac01.akc021%TYPE;
  v_errmsg      VARCHAR2(4500);
  yl_count  NUMBER;
  X            VARCHAR2(6);
  var_aac006   irac01.aac006%TYPE;
  woman_worker_months  NUMBER;
  var_aae110     VARCHAR2(9); 
  cursor cur_temp is
    SELECT a.iaz018,
       a.iaa001,
       a.iaa002,
       a.aac001,
       a.aab001,
       a.yae181,
       a.yac067,
       a.aac002,
       a.aac003,
       a.aac004,
       a.aac005,
       a.aac006,
       a.aac007,
       a.aac008,
       a.aac009,
       a.aac010,
       a.aac011,
       a.aac012,
       a.aac013,
       a.aac014,
       a.aac015,
       a.aac020,
       a.yac168,
       a.yac197,
       a.yac502,
       a.yae407,
       a.yae496,
       a.yic067,
       a.aae004,
       a.aae005,
       a.aae006,
       a.aae007,
       a.yae222,
       a.yac200,
       a.aae110,
       a.aac031,
       a.yac505,
       a.yac033,
       a.aac030,
       a.yae102,
       a.yae097,
       a.yac503,
       a.aac040,
       a.yac004,
       a.yaa333,
       a.yab013,
       a.yac002,
       a.yab139,
       a.aae011,
       a.aae036,
       a.yab003,
       a.aae013,
       a.aaz002,
       a.aae120,
       a.aae210,
       a.aae310,
       a.aae410,
       a.aae510,
       a.aae311,
       a.akc021,
       a.ykc150,
       a.ykb109,
       a.aic162,
       a.yac005,
       a.aae100,
       a.errormsg,
       a.aac021,
       a.aac022,
       a.aac025,
       a.aac026,
       a.aae810,
       a.iaa100,
       a.aae009,
       a.aae008,
       a.aae010,
       a.yad050
       FROM wsjb.tmp_irac01a2 a
       WHERE iaz018 = prm_iaz018;
  cursor cur_ab02 IS SELECT * FROM xasi2.ab02 WHERE aab001=prm_aab001 AND aab051='1';

  cursor cur_ac01 IS SELECT *   FROM xasi2.ac01 A
      WHERE AAE120 = '0'
       AND A.AAC002 IN (var_15aac002, var_aac002Low, var_18aac002)
       and replace(a.aac003, ' ', '') = var_aac003
       AND AAC003 NOT LIKE '%重复%';

BEGIN
  prm_AppCode  := GN_DEF_OK;
  prm_ErrorMsg := '';
  v_aaa010   := 0;
  man_months := 720;
  woman_months := 660;
  woman_worker_months :=600;

  SELECT count(1) INTO n_ab02count FROM xasi2.ab02 WHERE aab001=prm_aab001 AND aab051='1';
  IF prm_iaz018 IS NULL THEN
    prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
    prm_ErrorMsg := '流水号不能为空！';
    RETURN;
  END IF;
  IF prm_aab001 IS NULL THEN
    prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
    prm_ErrorMsg := 'prm_aab001单位编号不能为空！';
    RETURN;
  END IF;

  IF PRM_IAA100 IS NULL THEN
    prm_AppCode  := PRE_ERRCODE || GN_DEF_ERR;
    prm_ErrorMsg := 'prm_iaa100申报月度不能为空！';
    RETURN;
  END IF;

  --获取年度省级最低工资
  SELECT aaa010
    into v_aaa010
    FROM xasi2.AA02A1
   WHERE YAB139 = '610127'
     AND AAE001 = substr(prm_iaa100, 0, 4)
     AND YAA001 = '13';

  FOR REC_TEMP IN CUR_TEMP LOOP
    v_flag       := '0'; --校验标志（0-正常；1-错误；2 -警告）
    v_msg        := '';
    num_count    := 0;
    v_aac040_old := 0;
    v_aae310     := rec_temp.aae310;
    v_aae510     := rec_temp.aae510;
    v_aae311     := rec_temp.aae311;
    var_aac006   := rec_temp.aac006;
    var_aae110   := rec_temp.aae110;
    xb_aac004    := rec_temp.aac004;
    v_aac012     := rec_temp.aac012;
     

      SELECT count(1)
     INTO num_count
    FROM  wsjb.tmp_irac01a2
    WHERE aac002 = rec_temp.aac002;
    IF num_count >1 THEN
    v_msg  := v_errmsg||'身份证号为'||rec_temp.aac002||'姓名为'||rec_temp.aac003||'存在重复续保信息请勿重复增加！'||v_msg;
    v_flag := '1';
    END IF;
    --获取各种形式的证件号码
    var_15aac002  := SUBSTR(rec_temp.aac002, 1, 6) ||
                     SUBSTR(rec_temp.aac002, 9, 9);
    var_aac002Low := LOWER(rec_temp.aac002);

    var_18aac002  := rec_temp.aac002;

    var_aac003   := rec_temp.aac003;

    SELECT count(1)
      INTO num_count
      FROM xasi2.ac01 A
     WHERE AAE120 = '0'
       AND A.AAC002 IN (var_15aac002, var_aac002Low, rec_temp.aac002)
       and replace(a.aac003, ' ', '') = rec_temp.aac003
       AND AAC003 NOT LIKE '%重复%';

    /*IF num_count = 0 THEN
     SELECT count(1)
      INTO num_count
      FROM sjxt.AC01 A
     WHERE AAE120 = '0'
       AND A.AAC002 IN (var_15aac002, var_aac002Low, rec_temp.aac002)
       and replace(a.aac003, ' ', '') = rec_temp.aac003
       AND AAC003 NOT LIKE '%重复%';
       IF num_count = 0 THEN
      v_msg  := v_errmsg||v_msg|| '证件号为：[' || rec_temp.aac002 ||
                ']的人员不存在个人信息或者姓名有误，请在新参保模块里操作！';
      v_flag := '1';
      ELSIF num_count > 1 THEN
      v_msg  :=  v_errmsg||v_msg||'证件号为：[' || rec_temp.aac002 || ']的人员存在多条个人信息，请在联系社保中心！';
      v_flag := '1';
    END IF;*/




     IF num_count = 1  THEN


    SELECT aac001
        INTO v_aac001
        FROM xasi2.ac01 A
       WHERE AAE120 = '0'
         AND A.AAC002 IN (var_15aac002, var_aac002Low, rec_temp.aac002)
         and replace(a.aac003, ' ', '') = rec_temp.aac003
         AND AAC003 NOT LIKE '%重复%';

     END  IF ;

     IF   num_count > 1 THEN

           v_msg := '该身份证号已经存在多个医保编号,请在单个续保模块操作！';
           v_flag :='1';

     END  IF;

         IF num_count =1 THEN

           select to_number(to_char(min(aac006),'yyyymm')),aac004,aac008   INTO nl_aac006 ,xb_aac004,zy_aac008
            from xasi2.ac01
           where aac002 IN (var_15aac002, var_aac002Low,var_18aac002)
             AND AAC003 NOT LIKE '%重复%'
             AND rownum = 1
             group by aac004 , aac008;

           select trunc(months_between(sysdate,to_date(nl_aac006,'yyyymm'))) INTO sj_months from dual;

           --  检验逐月人员  ac01   aac008  2   kc01  akc021 11
             
           select count(1)
             into yl_count from wsjb.irac01a7_yl
            where aae123 = '2'
              and aac002  IN (var_15aac002, var_aac002Low,var_18aac002);
                   
      IF  yl_count = 0 THEN
     

        IF xb_aac004 = '1' and xb_aac004 IS NOT NULL  and  sj_months >=  man_months  THEN


           select akc021  INTO  zy_akc021 from xasi2.kc01    where aac001 = v_aac001;
         
           
               IF   zy_aac008 = 2 and  zy_akc021 =11 THEN
                  --  不做业务处理
                 select akc021  INTO  zy_akc021 from xasi2.kc01   where aac001 = v_aac001;

                ELSIF  (xb_aac004 = '1' and xb_aac004 IS NOT NULL  and  sj_months >=  man_months)   THEN

                   v_flag := '1';
                   v_msg  := '此人员年纪超过需要续保的年纪！';

               END IF;
          END IF;



          IF xb_aac004 = '2' and xb_aac004 IS NOT NULL  and  sj_months >=  woman_months  THEN
            IF   zy_aac008 = 2 and  zy_akc021 =11 THEN
               --  不做业务处理
             select akc021  INTO  zy_akc021 from xasi2.kc01   where aac001 = v_aac001;
              ELSIF    (xb_aac004 = '2' and xb_aac004 IS NOT NULL  and  sj_months >=  woman_months)  THEN
                
              v_flag := '1';
              v_msg  := '此人员年纪超过需要续保的年纪！';
            END IF;
         END IF;
         
        END IF ; --  养老继续缴费标志
          
          
        -- begin 20190703  
       select to_number(to_char(min(aac006),'yyyymm'))    INTO nl_aac006  
            from xasi2.ac01
           where aac002 IN (var_15aac002, var_aac002Low,var_18aac002)
             AND AAC003 NOT LIKE '%重复%'
             AND rownum = 1
            ;

           select trunc(months_between(sysdate,to_date(nl_aac006,'yyyymm'))) INTO sj_months from dual;
           
         IF   var_aae110 = '1' and  xb_aac004 = '2' and xb_aac004 IS NOT NULL  THEN --  养老首次参保
                select X INTO X from dual;
         
             --  处理干部  55 4  工人 50  1  针对女性   
                 IF   sj_months > woman_worker_months  and v_aac012 = '1' THEN
                      v_flag := '1';
                      v_msg  := '该人员个人身份为工人，超过需要续保的年纪！';
                     
                 ELSIF   sj_months >=  woman_months and  v_aac012 = '4'  THEN
                      v_flag := '1';
                      v_msg  := '该人员个人身份为干部，超过需要续保的年纪！';
                      
                 END IF;
             
             END IF;
   
          -- end  20190708
         
      END IF;


     IF  num_count >= 1 THEN

       --循环校验ac01
        FOR rec_cur_ac01 IN cur_ac01 LOOP
    --  BEGIN
         SELECT aac001 INTO var_aac001_more   FROM xasi2.ac01 A
         WHERE AAE120 = '0'
         AND A.aac001 = rec_cur_ac01.aac001
         AND A.AAC002 IN (var_15aac002, var_aac002Low, rec_cur_ac01.aac002)
         and replace(a.aac003, ' ', '') = rec_cur_ac01.aac003
         AND AAC003 NOT LIKE '%重复%';
      --  EXCEPTION
         --    WHEN others THEN
           IF var_aac001_more IS NULL  OR var_aac001_more = '' THEN
             v_msg := v_errmsg||v_msg||'获取不到个人编号!';
             v_flag  := '1';
            END IF;
         --  RETURN;
     --  END;

          SELECT COUNT(1)
        INTO COUNT_JM
        FROM XASI2.AC02K1
       WHERE AAC001 = var_aac001_more
         AND AAC031 = '1';
      IF COUNT_JM > 0 THEN
       SELECT AAB004
         INTO VAR_AAB004
         FROM XASI2.AB01
        WHERE AAB001 = (SELECT aab001
                          FROM XASI2.AC02K1
                         WHERE AAC001 = var_aac001_more
                           AND AAC031 = '1');
        v_msg  := '此身份证号码人员医疗保险关系目前在社区：' || VAR_AAB004 || '参加居民医保，姓名:'  ||'个人编号：'||var_aac001_more|| ',参保状态:参保缴费。';
        v_flag := '3';
       END IF;
        END LOOP;


   /* IF num_count > 1 THEN

      select aac001 INTO v_aac001 from xasi2.ac01
       where aac001 <> rec_temp.aac001
         and aac002 IN (var_15aac002, var_aac002Low, rec_temp.aac002)
         and replace(aac003, ' ', '') = rec_temp.aac003
         AND AAC003 NOT LIKE '%重复%';
         IF v_aac001 IS NULL  OR  v_aac001 = '' THEN
            v_msg := v_errmsg||v_msg||'获取不到个人编号!';
            v_flag  := '1';
      END IF;

     SELECT COUNT(1)
        INTO COUNT_JM
        FROM XASI2.AC02K1
       WHERE AAC001 = v_aac001
         AND AAC031 = '1';
      IF COUNT_JM > 0 THEN
       SELECT AAB004
         INTO VAR_AAB004
         FROM XASI2.AB01
        WHERE AAB001 = (SELECT aab001
                          FROM XASI2.AC02K1
                         WHERE AAC001 = v_aac001
                           AND AAC031 = '1');
        v_msg  := '此身份证号码人员医疗保险关系目前在社区：' || VAR_AAB004 || '参加居民医保，姓名:'  ||'个人编号：'||v_aac001|| ',参保状态:参保缴费。';
        v_flag := '3';

      END IF;
     END IF;
     */

  -- 判断是否在其他单位参保

   /* SElECT  count(*) INTO  Count_ZG  FROM  xasi2.ac02 where aac001 =   v_aac001
    and aab001 <> prm_aab001  and aac031 ='1' and  aae140 <> 04;
    IF   Count_ZG > 0 THEN
       v_msg  := '此身份证号码人员在其他单位参加职工医保，姓名:'  ||'个人编号：'||v_aac001|| ',参保状态:参保缴费。';
        v_flag := '5';
    END IF;
  */

    --判断失业是否为续
    IF  rec_temp.aae210 = '1' THEN
    SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001 = v_aac001 AND aae140='02';
    IF num_count > 0 THEN
    UPDATE wsjb.tmp_irac01a2  SET aae210 ='10' WHERE aac002 = REC_TEMP.aac002 AND iaz018 = prm_iaz018 ;
    END IF;
    END IF;
   --判断医疗是否为续
    IF rec_temp.aae310 = '1' THEN
    SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001 = v_aac001 AND aae140='03';
    IF num_count > 0 THEN
    UPDATE wsjb.tmp_irac01a2  SET aae310 ='10' WHERE aac002 = REC_TEMP.aac002 AND iaz018 = prm_iaz018 ;
    END IF;
    END IF;
     --判断工伤是否为续
    IF  rec_temp.aae410 = '1' THEN
    SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001 = v_aac001 AND aae140='04';
    IF num_count > 0 THEN
    UPDATE wsjb.tmp_irac01a2  SET aae410 ='10' WHERE aac002 = REC_TEMP.aac002 AND iaz018 = prm_iaz018 ;
    END IF;
    END IF;
     --判断生育是否为续
    IF  rec_temp.aae210 = '1' THEN
    SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001 = v_aac001 AND aae140='05';
    IF num_count > 0 THEN
    UPDATE wsjb.tmp_irac01a2  SET aae510 ='10' WHERE aac002 = REC_TEMP.aac002 AND iaz018 = prm_iaz018 ;
    END IF;
    END IF;
     --判断大额是否为续
    IF  rec_temp.aae311 = '1' THEN
    SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001 = v_aac001 AND aae140='07';
    IF num_count > 0 THEN
    UPDATE wsjb.tmp_irac01a2  SET aae311 ='10' WHERE aac002 = REC_TEMP.aac002 AND iaz018 = prm_iaz018 ;
    END IF;
    END IF;
     --判断机关是否为续
    IF rec_temp.aae120 = '1' THEN
    SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001 = v_aac001 AND aae140='06';
    IF num_count > 0 THEN
    UPDATE wsjb.tmp_irac01a2  SET aae120 ='10' WHERE aac002 = REC_TEMP.aac002 AND iaz018 = prm_iaz018 ;
    END IF;
    END IF;
     --判断公务员补助是否为续
    IF rec_temp.aae810 = '1' THEN
    SELECT count(1) INTO num_count FROM xasi2.ac02 WHERE aac001 = v_aac001 AND aae140='08';
    IF num_count > 0 THEN
    UPDATE wsjb.tmp_irac01a2  SET aae810 ='10' WHERE aac002 = REC_TEMP.aac002 AND iaz018 = prm_iaz018 ;
    END IF;
    END IF;
    ELSIF num_count > 1 THEN
      v_msg  :=  v_errmsg||v_msg||'证件号为：[' || rec_temp.aac002 || ']的人员存在多条个人信息，请在联系社保中心！';
      v_flag := '1';
    END IF;


        --判断医疗险种捆绑
    IF v_aae310 = '1' THEN

                   IF  (v_aae510 = '0') OR (v_aae311 = '0') THEN

                         v_msg :=v_errmsg||v_msg|| '医疗、生育、大额补充三险种必须一起参保!';
                         v_flag  := '1';
                    END IF;
             END IF;
      IF v_aae510 = '1' THEN
                   IF  v_aae310 = '0' OR v_aae311 = '0' THEN
                         v_msg := v_errmsg||v_msg||'医疗、生育、大额补充三险种必须一起参保!';
                         v_flag  := '1';
                    END IF;
             END IF;
      IF v_aae311 = '1' THEN
                   IF  v_aae310 = '0' OR v_aae510 = '0' THEN
                         v_msg := v_errmsg||v_msg||'医疗、生育、大额补充三险种必须一起参保!';
                         v_flag  := '1';
                    END IF;
             END IF;



    v_errmsg :=v_msg;
    IF v_flag = '0' THEN
    prc_p_checkInfoByaac001(v_aac001 ,
                           rec_temp.aac003 ,
                           prm_flag    , --1校验失败，无法续保 2校验成功，高新 3校验成功，市局 4校验成功，合并数据 5校验成功，单增工伤险种  6.未查到 医疗信息
                           v_msg     ,
                           prm_AppCode ,             --错误代码
                           prm_ErrorMsg   );
    IF prm_flag = '1' THEN
    v_flag :='1';
    v_msg :=v_errmsg||v_msg||'该人员参保险种未做暂停或有多个账户，不符合续保条件！';
    END IF;
    IF prm_flag = '2' THEN
    v_flag :=v_flag;
    v_msg :=v_errmsg;
    END IF;
    IF prm_flag = '3' THEN
    v_flag :=v_flag;
    v_msg :=v_errmsg;
    END IF;
    IF prm_flag = '4' THEN
    v_flag :=v_flag;
    v_msg :=v_errmsg;
    END IF;
    /*IF prm_flag ='5' THEN
    IF n_ab02count<5 THEN
    FOR rec_ab02 IN cur_ab02 LOOP
    IF rec_ab02.aae140 ='02' THEN
    SELECT count(1) INTO n_ac02count
     FROM sjxt.ac01 a,sjxt.ac02 b
     WHERE a.aac001=b.aac001
     and a.aac002=rec_temp.aac002
     and aae140=rec_ab02.aae140
     and aac031='1';
     IF n_ac02count>0 THEN
     v_aae210 := '';
     ELSE
      v_aae210:='1';
     END IF;
    END IF;
    IF rec_ab02.aae140 ='03' THEN
    SELECT count(1) INTO n_ac02count
     FROM sjxt.ac01 a,sjxt.ac02 b
     WHERE a.aac001=b.aac001
     and a.aac002=rec_temp.aac002
     and aae140=rec_ab02.aae140
     and aac031='1';
     IF n_ac02count>0 THEN
     v_aae310 := '';
     ELSE
      v_aae310:='1';
     END IF;
    END IF;
    IF rec_ab02.aae140 ='04' THEN
    SELECT count(1) INTO n_ac02count
     FROM sjxt.ac01 a,sjxt.ac02 b
     WHERE a.aac001=b.aac001
     and a.aac002=rec_temp.aac002
     and aae140=rec_ab02.aae140
     and aac031='1';
     IF n_ac02count>0 THEN
     v_aae410 := '';
     ELSE
      v_aae410:='1';
     END IF;
    END IF;
    IF rec_ab02.aae140 ='05' THEN
    SELECT count(1) INTO n_ac02count
     FROM sjxt.ac01 a,sjxt.ac02 b
     WHERE a.aac001=b.aac001
     and a.aac002=rec_temp.aac002
     and aae140=rec_ab02.aae140
     and aac031='1';
     IF n_ac02count>0 THEN
     v_aae510 := '';
     ELSE
      v_aae510:='1';
     END IF;
    END IF;
    IF rec_ab02.aae140 ='07' THEN
    SELECT count(1) INTO n_ac02count
     FROM sjxt.ac01 a,sjxt.ac02 b
     WHERE a.aac001=b.aac001
     and a.aac002=rec_temp.aac002
     and aae140=rec_ab02.aae140
     and aac031='1';
     IF n_ac02count>0 THEN
     v_aae311 := '';
     ELSE
      v_aae311:='1';
     END IF;
    END IF;
    v_flag :='0';
    END LOOP;
    ELSE
    v_flag :='1';
    v_msg :=v_errmsg||v_msg||'该人员在市人社局有正常参保的信息！';
    END IF;
    END IF;*/
      IF prm_flag ='6' THEN
    IF REC_TEMP.aae110 = '0' THEN
    v_flag :='1';
    v_msg :=v_errmsg||v_msg||'未查到该人员的信息，请在新参保模块操作！';
    END IF;
    END IF;
    END IF;

    if v_flag = '0' then
      pkg_p_validate.prc_p_ValidateAac002Continue('1',
                                                 rec_temp.aac002,
                                                 prm_aab001,
                                                 prm_iaa100,
                                                 v_aac001,
                                                 v_msg,
                                                 v_flag,
                                                 prm_AppCode,
                                                 prm_ErrorMsg);
    end if;

  /*  if v_flag = '0' and rec_temp.aac040 < v_aaa010 then
      v_flag := '1';
      v_msg  := v_errmsg||v_msg||'申报工资低于陕西省最低工资标准' || v_aaa010 || '!';
    end if;
    */

   /* if v_flag = '0' then
      SELECT to_number(MIN(AAC040))
        into v_aac040_old
        FROM (SELECT AAC040
                FROM xasi2.AC02
               WHERE AAB001 = prm_aab001
                 AND AAC001 = v_aac001
                 AND AAE140 NOT IN ('06', '07', '08')
                 and aac031 = '1'
              UNION ALL
              SELECT AAC040
                FROM IRAC01A3
               WHERE AAB001 = prm_aab001
                 AND AAC001 = v_aac001
                 AND AAE110 = '2');
      if v_aac040_old != rec_temp.sbgz then
        v_flag := '1';
        v_msg  := '申报工资' || rec_temp.sbgz || '与之前参保工资' || v_aac040_old ||
                  '不一致!';
      end if;
    end if;

    if v_flag = '0' and rec_temp.aae110 = '1' THEN
      pkg_p_validate.prc_p_ValidateContinueYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '01',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;
*/
    if v_flag = '0' and rec_temp.aae210 = '1' THEN
      pkg_p_validate.prc_p_ValidateContinueYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '02',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae310 = '1' then
      pkg_p_validate.prc_p_ValidateContinueYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '03',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae410 = '1' then
      pkg_p_validate.prc_p_ValidateContinueYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '04',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae510 = '1' then
      pkg_p_validate.prc_p_ValidateContinueYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '05',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae120 = '1' then
      pkg_p_validate.prc_p_ValidateContinueYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '06',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae311 = '1' then
      pkg_p_validate.prc_p_ValidateContinueYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '07',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae810 = '1' then
      pkg_p_validate.prc_p_ValidateContinueYesOrNo(prm_aab001,
                                                       v_aac001,
                                                       '08',
                                                       '610127',
                                                       v_flag,
                                                       v_msg,
                                                       prm_appcode,
                                                       prm_errormsg);
    end if;

    if v_flag = '0' and rec_temp.aae110 = '1' and rec_temp.aae120 = '1' then
      v_flag := '1';
      v_msg  := v_errmsg||v_msg||'企业养老和机关养老险种不能同时参保！';
    end if;

    if v_flag is null then
      v_flag := '0';
    end if;

    if v_msg is null then
      v_msg := '';
    end if;

    if v_flag = '0' then

      SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,
                                                             prm_aab001,
                                                             rec_temp.aac040,
                                                             '0',
                                                             decode(rec_temp.aae310,
                                                                    '1',
                                                                    '03',
                                                                    '04'),
                                                             '1',
                                                             '1',
                                                             prm_iaa100,
                                                             '610127'))
        into v_yac005
        FROM dual;

      if rec_temp.aae110 = '1' OR rec_temp.aae110='10' then
        SELECT ROUND(pkg_common.fun_p_getcontributionbase(null,
                                                               prm_aab001,
                                                               rec_temp.aac040,
                                                               '0',
                                                               '01',
                                                               '1',
                                                               '1',
                                                               prm_iaa100,
                                                               '610127'))
          into v_yac004
          FROM dual;
      elsif rec_temp.aae120 = '1' then
        v_yac004 := rec_temp.aac040;
      else
        v_yac004 := 0;
      end if;


  update wsjb.tmp_irac01a2  a
         set a.aae100 = '1',
              a.aac001 = v_aac001,
             a.errormsg  = a.errormsg||v_msg,
             a.yac004    = v_yac004,
             a.yac005    = v_yac005,
             a.iaa100     =''
       where iaz018 = prm_iaz018
       AND a.aac002 = rec_temp.aac002;

      if sql%rowcount = 0 then
        prm_appcode  := PRE_ERRCODE || GN_DEF_ERR;
        prm_errormsg := 'prc_p_ValidBatchContinueCheck出错,出错原因:没有更新到校验结果信息！';
        return;
      end if;

      if sql%rowcount > 1 then
        prm_appcode  := PRE_ERRCODE || GN_DEF_ERR;
        prm_errormsg := 'prc_p_ValidBatchContinueCheck出错,出错原因:更新到多条校验结果信息！';
        return;
      end if;
    ELSE


      update wsjb.tmp_irac01a2  a
         set a.aae100 = '0', a.errormsg = a.errormsg||v_msg,
          a.iaa100     ='',
          a.aac001 = v_aac001
       where iaz018 = prm_iaz018
       AND a.aac002 = rec_temp.aac002;

      if sql%rowcount = 0 then
        prm_appcode  := PRE_ERRCODE || GN_DEF_ERR;
        prm_errormsg := 'prc_p_ValidBatchContinueCheck出错,出错原因:没有更新到校验结果信息！';
        return;
      end if;

      if sql%rowcount > 1 then
        prm_appcode  := PRE_ERRCODE || GN_DEF_ERR;
        prm_errormsg := 'prc_p_ValidBatchContinueCheck出错,出错原因:更新到多条校验结果信息！';
        return;
      end if;
    end if;

  END LOOP;

EXCEPTION

  WHEN OTHERS THEN
    ROLLBACK;
    PRM_APPCODE  := PRE_ERRCODE || GN_DEF_ERR;
    PRM_ERRORMSG := 'prc_p_ValidBatchContinueCheck出错,出错原因:' || SQLERRM ||
                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
    RETURN;
END prc_p_ValidBatchContinueCheck;
/*--------------------------------------------------------------------------
   || 业务环节 ：校验参保人员是否可以续保某一个险种
   || 过程名称 prc_p_ValidateAddKindYesOrNo
   || 功能描述 ：校验险种续保
   ||
   || 参数描述 ：参数标识           说明
   ||            --------------------------------------------------------------
   ||
   ||
   || 作    者 ：ycliu         完成日期 ：2017-02-15
   ||------------------------------------------------------------------------*/
  PROCEDURE prc_p_ValidateContinueYesOrNo(prm_aab001   IN VARCHAR2, --单位编号
                                         prm_aac001   IN VARCHAR2, --个人编号
                                         prm_aae140   IN VARCHAR2, --险种
                                         prm_yab139   IN VARCHAR2, --经办机构
                                         prm_flag     OUT VARCHAR2, --返回状态标志
                                         prm_msg      OUT VARCHAR2, --提示信息
                                         prm_AppCode  OUT VARCHAR2, --执行代码
                                         prm_ErrorMsg OUT VARCHAR2) --出错信息
   IS
    v_flag   varchar2(2);
    v_msg    varchar2(4500);
    v_yon    varchar2(9);
    v_aab001 irab01.aab001%TYPE;
    v_aac031 irac01.aac031%TYPE;
  BEGIN
    --初始化变量
    prm_AppCode  := GN_DEF_OK;
    prm_ErrorMsg := '';
    v_flag   := '0'; --正常(0--正常，1--错误，2--警告)
    v_msg    := '';
    v_yon    := '';
    v_aab001 := '';
    v_aac031 := '0'; --默认未参保

    --判断该单位是否参加此险种

    BEGIN
      select 1
        into v_yon
        from (select b.aae140
                from xasi2.ab02 b
               where 1 = 1
                 and b.aab001 = prm_aab001
                 and b.aab051 = '1'
              union
              select '01' as aae140
                from wsjb.irab01  a
               where a.iab001 = a.aab001
                 and a.iaa002 = '2'
                 and a.aab001 = prm_aab001
                 and a.aae110 = '1') r
       where r.aae140 = prm_aae140;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_flag := '1';
        v_msg  := '单位没有参加' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  ',不能续保该险种！';
        goto label_out;
      WHEN TOO_MANY_ROWS THEN
        v_flag := '1';
        v_msg  := '单位找到多条' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  '参保记录,请联系社保中心！';
        goto label_out;
      WHEN OTHERS THEN
        v_flag := '1';
        v_msg  := '未知错误，请联系系统维护人员！';
        goto label_out;
    END;

    if v_yon <> '1' then
      v_flag := '1';
      v_msg  := '单位没有参加' ||
                xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                ',不能续保该险种！';
      goto label_out;
    end if;

    if prm_aae140 = '04' then
      begin
        select r.aab001, r.aac031
          into v_aab001, v_aac031
          from (select a.aab001, a.aae140, a.aac031
                  from xasi2.ac02 a
                 where a.aac001 = prm_aac001
                union
                select b.aab001,
                       '01' as aae140,
                       decode(b.aae110, '2', '1', '21', '2', '0', '') as aac031
                  from wsjb.irac01a3  b
                 where b.aac001 = prm_aac001
                   and b.aae110 = '2') r
         where r.aae140 = prm_aae140
           and r.aab001 = prm_aab001;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_flag := '0';
          goto label_out;
      end;

      if v_aab001 is not null AND v_aac031 = '1' then
        v_flag := '1';
        v_msg  := '此人已经在本单位的' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  '为'||xasi2.pkg_comm.fun_getAaa103('AAC031', v_aac031)||'状态！';
        goto label_out;
      end if;

     /* begin
        select r.aab001, r.aac031
          into v_aab001, v_aac031
          from (select a.aab001, a.aae140, a.aac031
                  from xasi2.ac02 a
                 where a.aac001 = prm_aac001
                union
                select b.aab001,
                       '01' as aae140,
                       decode(b.aae110, '2', '1', '21', '2', '0', '') as aac031
                  from irac01a3 b
                 where b.aac001 = prm_aac001
                   and b.aae110 = '2') r
         where r.aae140 = prm_aae140
           and r.aab001 <> prm_aab001;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_flag := '0';
          goto label_out;
      end;

      if v_aab001 is not null or v_aac031 = '1' then
        v_flag := '1';
        v_msg  := '此人已经在' || v_aab001 || '单位参加了' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  ',不能新增该险种！';
        goto label_out;
      end if;*/
    else

      --判断人员该险种是否正常参保
      BEGIN
        select r.aab001, r.aac031
          into v_aab001, v_aac031
          from (select a.aab001, a.aae140, a.aac031
                  from xasi2.ac02 a
                 where a.aac001 = prm_aac001
                union
                select b.aab001,
                       '01' as aae140,
                       decode(b.aae110, '2', '1', '21', '2', '0', '') as aac031
                  from wsjb.irac01a3  b
                 where b.aac001 = prm_aac001
                   and b.aae110 = '2') r
         where r.aae140 = prm_aae140;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_flag := '0';
          goto label_out;
        WHEN TOO_MANY_ROWS THEN
          v_flag := '1';
          v_msg  := '此人找到多条' ||
                    xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                    '参保记录,请联系社保中心！';
          goto label_out;
        WHEN OTHERS THEN
          v_flag := '1';
          v_msg  := '未知错误，请联系系统维护人员！';
          goto label_out;
      END;

      if v_aab001 is not null AND v_aac031 = '1' then
        v_flag := '1';
        v_msg  := '此人已经在' || v_aab001 || '单位的' ||
                  xasi2.pkg_comm.fun_getAaa103('AAE140', prm_aae140) ||
                  '为'||xasi2.pkg_comm.fun_getAaa103('AAC031', v_aac031)||'状态！';
        goto label_out;
      end if;
    end if;

    <<label_out>>
    prm_flag := v_flag;
    prm_msg  := v_msg;

  EXCEPTION
    WHEN OTHERS THEN
      /*关闭打开的游标*/
      ROLLBACK;
      prm_AppCode  := gn_def_ERR;
      prm_ErrorMsg := '数据库错误:' || SQLERRM;
      RETURN;
  END prc_p_ValidateContinueYesOrNo;

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
      prm_ErrorMsg        OUT           VARCHAR2)    --出错信息
   IS
     num_count        NUMBER(6);
     var_aac001       irac01.aac001%TYPE;
   num_count1        NUMBER(6);
   var_aac002Low    irac01.aac002%TYPE;
   var_15aac002     irac01.aac002%TYPE;
   var_aab001       irac01.aab001%TYPE;
   BEGIN
    /*初始化变量*/
      prm_AppCode  := GN_DEF_OK;
      prm_ErrorMsg := '';
      prm_msg :='';
      prm_sign :='0';
   --校验参数
      IF prm_yae181 IS NULL  THEN
         prm_msg :=  prm_msg||'传入证件类型为空，请核实。。。';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
      IF prm_aab001 IS NULL  THEN
         prm_msg :=  prm_msg||'传入单位编号为空，请核实。。。';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
      IF prm_aac002 IS NULL  THEN
         prm_msg :=  prm_msg||'传入证件号码为空，请核实。。。';
         prm_sign := '1';
         GOTO label_ERROR;
      END IF;
       --身份证类型
     IF prm_yae181 = 1 THEN
        --获取各种形式的证件号码
         var_15aac002 := SUBSTR(prm_aac002,1,6)||SUBSTR(prm_aac002,9, 9);
         var_aac002Low := LOWER(prm_aac002);

        SELECT count(1)
          INTO num_count
          FROM xasi2.ac01 A
         WHERE A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
           AND AAC003 NOT LIKE '%重复%';

         IF num_count = 0 THEN
           prm_msg := '证件号为：['||prm_aac002||']的人员不存在个人信息，请在新参保模块里操作';
           prm_sign :='1';
           GOTO label_ERROR ;
         END IF ;

         SELECT count(1)
          INTO num_count1
          FROM wsjb.irac01  A
         WHERE A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
           AND a.iaa001 <> '4'
           AND A.IAA002 ='0'
           AND  rownum = 1;

         IF  num_count1 > 0 THEN
          SELECT a.aab001
            INTO var_aab001
            FROM wsjb.irac01  A
           WHERE A.AAC002 IN (var_15aac002, var_aac002Low, prm_aac002)
             AND a.iaa001 <> '4'
             AND A.IAA002 ='0'
             AND rownum =1;
           prm_msg := '证件号为：['||prm_aac002||']的人员在单位'||var_aab001||'有申报记录,不能新增!';
           prm_sign :='1';
           GOTO label_ERROR ;
         END IF;

       SELECT aac001
               INTO var_aac001
               FROM xasi2.ac01 a
               WHERE a.aac002 IN (var_15aac002, var_aac002Low, prm_aac002)
           AND AAC003 NOT LIKE '%重复%';

       SELECT COUNT(*)
         INTO num_count
         FROM xasi2.ac06
         WHERE aac001=var_aac001;
         IF num_count>0 THEN
           SELECT COUNT(*)
          INTO num_count
          FROM xasi2.ac02
          WHERE aac001=var_aac001
          AND aac031='3';
           END IF;


     END IF;


     <<label_ERROR>>
      num_count := 0;

       EXCEPTION
    WHEN OTHERS THEN
      /*关闭打开的游标*/
      ROLLBACK;
      prm_AppCode  := gn_def_ERR;
      prm_ErrorMsg := '数据库错误:' || SQLERRM;
      RETURN;
 END prc_p_ValidateAac002Special;

  /*--账户转入
  procedure prc_p_accountInto(prm_str    IN CLOB,
                              prm_aaz174 IN VARCHAR2,
                              prm_AppCode OUT   VARCHAR2  ,             --错误代码
                               prm_ErrorMsg  OUT   VARCHAR2
                              )
  is
  var_aac001  xasi2.ac01.aac001%TYPE;
  var_aac002_18  VARCHAR2(18);
  n_aae001 NUMBER(4);
  num_count NUMBER;
  var_yae099  VARCHAR2(20);
  xmlPar xmlparser.Parser := xmlparser.newParser;
  doc xmldom.DOMDocument;
  len Integer;
  ac02List xmldom.DOMNodeList;
  chilNodes xmldom.DOMNodeList;
  ac02Node xmldom.DOMNode;
  ac02ArrMap xmldom.DOMNamedNodeMap;
  var_nac001 VARCHAR2(15);
  var_aac002 VARCHAR2(18);
  var_aac003 VARCHAR2(60);
  num_nkc087 NUMBER(14,2);
  num_akc087 NUMBER(14,2);
  var_flag VARCHAR2(6);
  var_aae013 VARCHAR2(120);
  var_yae235 VARCHAR2(6);
  var_yae238 VARCHAR2(800);
  var_aaz174 VARCHAR2(15);
  var_aaz175 VARCHAR2(15);
  var_aaz176 VARCHAR2(15);
  dat_aae036 date;
  begin
     prm_AppCode := GN_DEF_OK;
     prm_ErrorMsg := '';
     xmlPar := xmlparser.newParser;
     xmlparser.parseClob(xmlPar,prm_str);
     doc := xmlparser.getDocument(xmlPar);
     --释放
    xmlparser.freeParser(xmlPar);
    ac02List := xmldom.getElementsByTagName(doc,'row');
    len := xmldom.getLength(ac02List);
    n_aae001:=TO_NUMBER(substr(to_char(sysdate,'yyyy-MM-dd'),0,4));
    dat_aae036 := sysdate;
    for i in 0..len-1 loop
      var_aac001 := '';
      var_nac001 := '';
      var_aac002 := '';
      var_aac003 := '';
      var_flag := '';--下账成功标志
      var_aae013 := '';
      num_nkc087 := 0;
      num_akc087 := 0;
      var_yae235 := '1';--上账成功为1，上账失败为2
      var_yae238 := '';
      --获取第i个ac08
      ac02Node := xmldom.item(ac02List,i);
      --获取属性
     -- ac08ArrMap := xmldom.getAttributes(ac02Node);
      --获取子节点
      chilNodes := xmldom.getChildNodes(ac02Node);
      var_nac001 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,0)));
      var_aac002 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,1)));
      var_aac003 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,2)));
       num_nkc087 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,3)));
      var_flag := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,4)));
      var_aae013 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,5)));
      --对方的aaz175对应这边的aaz176
      var_aaz176 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,6)));
      if var_flag = '2' then
         var_yae235 := '2';
         var_yae238 := '因下账出错，不能进行上账!';
         GOTO label_next;
      end if;
      --查询个人编号
      begin
        select aac001
          into var_aac001
          from xasi2.ac01
         where aac002 = var_aac002
           and replace(aac003,' ','') = replace(var_aac003,' ','');
        exception
          WHEN NO_DATA_FOUND THEN
            --未获取到个人基本信息
            var_yae235 := '2';
            var_yae238 := '未获取到身份证为'||var_aac002||'人员的基本信息！';
            GOTO label_next;
          WHEN TOO_MANY_ROWS THEN
            --身份证和姓名存在多个个人编号
            var_yae235 := '2';
            var_yae238 := '该身份证号码存在多个个人编号,身份证号为:'||var_aac002;
            GOTO label_next;
      end;
      --查询该人员是否正在参保
      select count(*)
        INTO num_count
        from xasi2.ac02
       where aac001 = var_aac001
         and aae140 = '03'
         and aac031 = '1';
      IF num_count = 0 THEN
         --该人员未有基本医疗参保信息,不能转入账户
         var_yae235 := '2';
         var_yae238 := '人员未存在基本医疗参保信息，不能转入账户!';
         GOTO label_next;
      END IF;

      --var_akc087 := to_number(prm_akc087);
      select xasi2.seq_yae099.nextval into var_yae099 from dual;
      --记录从另一个系统得到的金额和个人编号
      --insert into kc04k9(yae099,
                        --aac001,
                         --iac001,
                        -- akc087,
                        -- aae120)
                  --VALUES(var_yae099,--业务流水号
                        -- var_aac001,--本系统个人编号
                        -- prm_aac001,--另一个系统中的个人编号
                        -- var_akc087,--另一个系统转入的金额
                        -- '0'--有效标志
                      --  );

      --查询人员在本系统中的账户余额
      begin
        select akc087
          into num_akc087
          from xasi2.kc04
         where aac001 = var_aac001;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            num_akc087 := 0 ;
      end;
      --更新市局此人账户余额,这里需要查询一下转入的金额 ,
      update xasi2.kc04
         set akc082 = akc082 + num_nkc087,--(转入的余额)
              akc087 = akc087 + num_nkc087
       where aac001 = var_aac001
         and aae001 = n_aae001;
      IF SQL%ROWCOUNT < 1 THEN --如果没有账户则直接插入一条
         INSERT INTO xasi2.KC04
                 (aac001,   --个人编号
                  aae001,   --年度
                  ykc203,   --帐户状态
                  akc081,   --基本医疗账户个人缴费部分本年收入总额
                  akc082,   --基本医疗账户单位缴费划入部分本年收入总额
                  ykc061,   --基本医疗账户上年结转金额
                  ykc025,   --公务员账户本年收入总额
                  ykc062,   --公务员账户上年结转金额
                  ykc252,   --公务员注入资金本年收入金额
                  ykc255,   --公务员注入资金上年结转金额
                  ykc026,   --本年继承个人缴费金额
                  ykc027,   --本年继承单位划入金额
                  ykc028,   --本年继承公务员金额
                  ykc244,   --本年继承公务员注入资金金额
                  akc087,   --当前结余金额
                  yka147,   --基本医疗上年账户利息
                  yka148,   --基本医疗本年账户利息
                  yka149,   --公务员上年账户利息
                  yka150,   --公务员本年账户利息
                  ykc256,   --公务员注入资金上年账户利息
                  ykc253,   --公务员注入资金本年账户利息
                  ykc074,   --基本医疗上年账户支出总额
                  ykc075,   --基本医疗本年账户支出总额
                  ykc076,   --公务员上年账户支出总额
                  ykc077,   --公务员本年账户支出总额
                  ykc257,   --公务员注入资金上年支出总额
                  ykc254,   --公务员注入资金本年支出总额
                  ykc250,   --公务员门诊补助历年结转金额
                  ykc036,   --截止上年末累计应缴费月数
                  akc096,   --截止上年末累计实缴费月数
                  ykc204,   --转移累计缴费年限
                  ykc035,   --基本医疗本年应缴月数
                  akc085,   --医疗本年缴费月数
                  akc095,   --账户修改日期
                  ykc031,   --上年基本医疗账户计息积数
                  akc094,   --本年基本医疗账户计息积数
                  ykc032,   --上年公务员账户计算积数
                  ykc033,   --本年公务员账户计算积数
                  ykc260,   --上年公务员注入资金记息积数
                  ykc242,   --本年公务员注入资金记息积数
                  yke104)   --行数据版本号
           VALUES(var_aac001,   --个人编号
                  TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')),   --年度
                  '1',   --帐户状态正常
                  0,   --基本医疗账户个人缴费部分本年收入总额
                  num_nkc087,   --基本医疗账户单位缴费划入部分本年收入总额
                  0,   --基本医疗账户上年结转金额
                  0,   --公务员账户本年收入总额
                  0,   --公务员账户上年结转金额
                  0,   --公务员注入资金本年收入金额
                  0,   --公务员注入资金上年结转金额
                  0,   --本年继承个人缴费金额
                  0,   --本年继承单位划入金额
                  0,   --本年继承公务员金额
                  0,   --本年继承公务员注入资金金额
                  num_nkc087,   --当前结余金额
                  0,   --基本医疗上年账户利息
                  0,   --基本医疗本年账户利息
                  0,   --公务员上年账户利息
                  0,   --公务员本年账户利息
                  0,   --公务员注入资金上年账户利息
                  0,   --公务员注入资金本年账户利息
                  0,   --基本医疗上年账户支出总额
                  0,   --基本医疗本年账户支出总额
                  0,   --公务员上年账户支出总额
                  0,   --公务员本年账户支出总额
                  0,   --公务员注入资金上年支出总额
                  0,   --公务员注入资金本年支出总额
                  0,   --公务员门诊补助历年结转金额
                  0,   --截止上年末累计应缴费月数
                  0,   --截止上年末累计实缴费月数
                  0,   --转移累计缴费年限
                  0,   --基本医疗本年应缴月数
                  0,   --医疗本年缴费月数
                  SYSDATE,   --账户修改日期
                  0,   --上年基本医疗账户计息积数
                  0,   --本年基本医疗账户计息积数
                  0,   --上年公务员账户计算积数
                  0,   --本年公务员账户计算积数
                  0,   --上年公务员注入资金记息积数
                  0,   --本年公务员注入资金记息积数
                  TO_NUMBER(TO_CHAR(SYSDATE,'yyyymmdd')));     --行数据版本号
         END IF;
         <<label_next>>
         select xasi2.seq_aaz175.nextval into var_aaz175 from dual;
         insert into xasi2_zs_n.kc04a2(AAZ174,
                           AAZ175,
                           AAZ176,
                           AAC001,
                           NAC001,
                           AAC002,
                           AAC003,
                           NKC087,
                           AKC087,
                           AAE036,
                           FLAG,
                           AAE013,
                           YAE235,
                           YAE238
                           )
                     values(
                            prm_aaz174,
                            var_aaz175,
                            var_aaz176,--记录对面的aaz175，为回写标志
                            var_aac001,
                            var_nac001,
                            var_aac002,
                            var_aac003,
                            num_nkc087,
                            num_akc087,
                            dat_aae036,
                            var_flag,
                            var_aae013,
                            var_yae235,
                            var_yae238
                           );
     end loop;

   EXCEPTION
       WHEN OTHERS THEN
       --调用存储过程出错
       prm_AppCode := '-1';
      prm_ErrorMsg := '调用上账存储过程出错！';
      RETURN;
  END prc_p_accountInto;
  --账户转出下账
  procedure prc_p_accountOut(prm_rows IN VARCHAR2,
                             prm_log OUT sys_refcursor,
                             prm_AppCode OUT   VARCHAR2,             --错误代码
                              prm_ErrorMsg  OUT   VARCHAR2
                            )
  is
  xmlPar xmlparser.Parser := xmlparser.newParser;
  doc xmldom.DOMDocument;
  len Integer;
  ac02List xmldom.DOMNodeList;
  chilNodes xmldom.DOMNodeList;
  ac02Node xmldom.DOMNode;
  ac02ArrMap xmldom.DOMNamedNodeMap;
  var_aac001 VARCHAR2(20);
  n_aae001 NUMBER;
  var_yae099 VARCHAR2(20);
  num_count  NUMBER;
  var_aac002 VARCHAR2(18);
  var_aac003 VARCHAR2(60);
  dat_aae036 date;
  num_akc087 NUMBER(14,2);
  var_aaz174 VARCHAR2(15);
  var_aaz175 VARCHAR2(15);
  var_flag VARCHAR2(6);
  var_aae013 VARCHAR2(120);
  begin
    --查询个人编号
    prm_AppCode := '1';
    prm_ErrorMsg  := '';
    xmlPar := xmlparser.newParser;
    xmlparser.parseClob(xmlPar,prm_rows);
    doc := xmlparser.getDocument(xmlPar);
    --释放
    xmlparser.freeParser(xmlPar);
    ac02List := xmldom.getElementsByTagName(doc,'row');
    len := xmldom.getLength(ac02List);
    dat_aae036 := sysdate;
    select xasi2.seq_aaz174.nextval
      into var_aaz174
      from dual;

    --查询信息进行释放
    for i in 0..len-1 loop
      var_aac001 := '';
      var_aac002 := '';
      var_aac003 := '';
      var_flag := '1';--下账成功标志
      var_aae013 := '';
      num_akc087 := 0;
      --获取第i个ac08
      ac02Node := xmldom.item(ac02List,i);
      --获取属性
     -- ac08ArrMap := xmldom.getAttributes(ac02Node);
      --获取子节点
      chilNodes := xmldom.getChildNodes(ac02Node);
      var_aac002 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,0)));
      var_aac003 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,1)));

      n_aae001:=TO_NUMBER(substr(to_char(sysdate,'yyyy-MM-dd'),0,4));
      --查询个人编号
      begin
        select aac001
          into var_aac001
          from xasi2.ac01
         where aac002 = var_aac002
           and replace(aac003,' ','') = replace(var_aac003,' ','');
        exception
          WHEN NO_DATA_FOUND THEN
            --未获取到个人基本信息
            var_flag := '2'; --失败
            var_aae013 := '未获取到身份证为'||var_aac002||'人员的基本信息！';
            GOTO label_next;
          WHEN TOO_MANY_ROWS THEN
            --身份证和姓名存在多个个人编号
            var_flag := '2';
            var_aae013 := '该身份证号码存在多个个人编号,身份证号为:'||var_aac002;
            GOTO label_next;
      end;
      --查询该人员是否正在参保
      select count(*)
        INTO num_count
        from xasi2.ac02
       where aac001 = var_aac001
         and aae140 = '03'
         and aac031 = '2';
      IF num_count = 0 THEN
         --该人员未有基本医疗参保信息,不能转入账户
         var_flag := '2';
         var_aae013 := '人员未存在基本医疗参保信息或基本医疗保险未暂停缴费!';
         GOTO label_next;
      END IF;

      select xasi2.seq_yae099.nextval into var_yae099 from dual;
      --prm_aac001 := var_aac001;
      --查询该人员是否存在账户信息
      BEGIN
        SELECT akc087
          INTO num_akc087
          FROM xasi2.kc04
         WHERE aac001 = var_aac001
           AND aae001 = n_aae001;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
             var_flag := '2';
             var_aae013 := '该人员未存在账户信息！';
             GOTO label_next;
      END;

      --账户为负，则为下账失败
      IF num_akc087 < 0 THEN
         var_flag := '2';
          var_aae013 := '该人员未存在账户余额为负!';
          GOTO label_next;
      END IF;

      --将个人账户信息写入封存表,并且记录到共享表中
      BEGIN
         INSERT INTO xasi2.kc04k4
                  ( yae099,   -- 业务流水号
                    aac001, --个人编号
                    aae001, --年度
                    ykc203, --帐户状态
                    akc081, --基本医疗账户个人缴费部分本年收入总额
                    akc082, --基本医疗账户单位缴费划入部分本年收入总额
                    ykc061, --基本医疗账户上年结转金额
                    ykc025, --公务员账户本年收入总额
                    ykc062, --公务员账户上年结转金额
                    ykc252, --公务员注入资金本年收入金额
                    ykc255, --公务员注入资金上年结转金额
                    ykc026, --本年继承个人缴费金额
                    ykc027, --本年继承单位划入金额
                    ykc028, --本年继承公务员金额
                    ykc244, --本年继承公务员注入资金金额
                    akc087, --当前结余金额
                    yka147, --基本医疗上年账户利息
                    yka148, --基本医疗本年账户利息
                    yka149, --公务员上年账户利息
                    yka150, --公务员本年账户利息
                    ykc256, --公务员注入资金上年账户利息
                    ykc253, --公务员注入资金本年账户利息
                    ykc074, --基本医疗上年账户支出总额
                    ykc075, --基本医疗本年账户支出总额
                    ykc076, --公务员上年账户支出总额
                    ykc077, --公务员本年账户支出总额
                    ykc257, --公务员注入资金上年支出总额
                    ykc254, --公务员注入资金本年支出总额
                    ykc250, --公务员门诊补助历年结转金额
                    ykc036, --截止上年末累计应缴费月数
                    akc096, --截止上年末累计实缴费月数
                    ykc204, --转移累计缴费年限
                    ykc035, --基本医疗本年应缴月数
                    akc085, --医疗本年缴费月数
                    akc095, --账户修改日期
                    ykc031, --上年基本医疗账户计息积数
                    akc094, --本年基本医疗账户计息积数
                    ykc032, --上年公务员账户计算积数
                    ykc033, --本年公务员账户计算积数
                    ykc260, --上年公务员注入资金记息积数
                    ykc242, --本年公务员注入资金记息积数
                    yke104) --行数据版本号
             SELECT var_yae099,   -- 业务流水号
                    a.aac001,  --个人编号
                    a.aae001,  --年度
                    a.ykc203,  --帐户状态
                    a.akc081, --基本医疗账户个人缴费部分本年收入总额
                    a.akc082, --基本医疗账户单位缴费划入部分本年收入总额
                    a.ykc061, --基本医疗账户上年结转金额
                    a.ykc025, --公务员账户本年收入总额
                    a.ykc062, --公务员账户上年结转金额
                    a.ykc252, --公务员注入资金本年收入金额
                    a.ykc255, --公务员注入资金上年结转金额
                    a.ykc026, --本年继承个人缴费金额
                    a.ykc027, --本年继承单位划入金额
                    a.ykc028, --本年继承公务员金额
                    a.ykc244, --本年继承公务员注入资金金额
                    a.akc087, --当前结余金额
                    a.yka147, --基本医疗上年账户利息
                    a.yka148, --基本医疗本年账户利息
                    a.yka149, --公务员上年账户利息
                    a.yka150, --公务员本年账户利息
                    a.ykc256, --公务员注入资金上年账户利息
                    a.ykc253, --公务员注入资金本年账户利息
                    a.ykc074, --基本医疗上年账户支出总额
                    a.ykc075, --基本医疗本年账户支出总额
                    a.ykc076, --公务员上年账户支出总额
                    a.ykc077, --公务员本年账户支出总额
                    a.ykc257, --公务员注入资金上年支出总额
                    a.ykc254, --公务员注入资金本年支出总额
                    a.ykc250, --公务员门诊补助历年结转金额
                    a.ykc036, --截止上年末累计应缴费月数
                    a.akc096, --截止上年末累计实缴费月数
                    a.ykc204, --转移累计缴费年限
                    a.ykc035, --基本医疗本年应缴月数
                    a.akc085, --医疗本年缴费月数
                    a.akc095, --账户修改日期
                    a.ykc031, --上年基本医疗账户计息积数
                    a.akc094, --本年基本医疗账户计息积数
                    a.ykc032, --上年公务员账户计算积数
                    a.ykc033, --本年公务员账户计算积数
                    a.ykc260, --上年公务员注入资金记息积数
                    a.ykc242, --本年公务员注入资金记息积数
                    a.yke104
           FROM xasi2.kc04 a
          WHERE a.aac001 = var_aac001
            AND a.aae001 = n_aae001;
            IF SQL%rowcount = 0 THEN
               var_flag := '2';
               var_aae013 := '没有把kc04备份到医疗个人账户封存!';
               GOTO label_next;
            END IF;
     EXCEPTION
       WHEN OTHERS THEN
          var_flag := '2';
          var_aae013 := '备份到医疗个人账户封存表错误!';
          GOTO label_next;
     END;
      --给个人账户下账
      delete from xasi2.kc04 where aac001 = var_aac001;
      IF SQL%ROWCOUNT < 1 THEN
         var_flag := '2';
         var_aae013 := '个人账户下账出错!';
         GOTO label_next;
      END IF;

      <<label_next>>
      select xasi2.seq_aaz175.nextval
        into var_aaz175
        from dual;
      --插入日志kc04a1
      insert into xasi2.kc04a1(aaz174,
                         aaz175,
                         aac001,
                         aac002,
                         aac003,
                         akc087,
                         aae036,
                         flag,
                         aae013
                        )
                  values(
                         var_aaz174,
                         var_aaz175,
                         var_aac001,
                         var_aac002,
                         var_aac003,
                         num_akc087,
                         dat_aae036,
                         var_flag,
                         var_aae013
                        );
    end loop;
    --释放文档对象
    xmldom.freeDocument(doc);
    --查询已下账的信息返回游标
    open prm_log for select aac001,--个人编号
                            aac002,--身份证
                            aac003,--姓名
                            akc087,--下账金额
                            flag, --下账标志
                            aae013,--下账 失败原因
                            aaz175
                       from xasi2.kc04a1
                      where aaz174 = var_aaz174;
    EXCEPTION
      WHEN OTHERS THEN
         --调用存储过程出错
         prm_AppCode := '-1';
        prm_ErrorMsg := '调用下账存储过程出错！'||SQLERRM||'。错误堆栈:' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
        RETURN;
  END prc_p_accountOut;
  --回写上账标志
procedure prc_p_accountUpdate(prm_rows IN VARCHAR2,
                           prm_AppCode OUT   VARCHAR2,             --错误代码
                           prm_ErrorMsg  OUT   VARCHAR2
                          )
  IS
    xmlPar xmlparser.Parser := xmlparser.newParser;
    doc xmldom.DOMDocument;
    len Integer;
    ac02List xmldom.DOMNodeList;
    chilNodes xmldom.DOMNodeList;
    ac02Node xmldom.DOMNode;
    ac02ArrMap xmldom.DOMNamedNodeMap;
    var_aac001 VARCHAR2(15);
    var_aac002 VARCHAR2(18);
    var_aac003 VARCHAR2(60);
    var_yae235 VARCHAR2(6);
    var_yae238 VARCHAR2(500);
    var_aaz175 VARCHAR2(15);
  BEGIN
    prm_AppCode := '1';
    prm_ErrorMsg  := '';
    xmlPar := xmlparser.newParser;
    xmlparser.parseClob(xmlPar,prm_rows);
    doc := xmlparser.getDocument(xmlPar);
    --释放
    xmlparser.freeParser(xmlPar);
    ac02List := xmldom.getElementsByTagName(doc,'row');
    len := xmldom.getLength(ac02List);
    for i in 0..len-1 loop
      var_aac001 := '';
      var_aac002 := '';
      var_aac003 := '';
      var_yae235 := '';--上账成功为1，上账失败为2
      var_yae238 := '';
      var_aaz175 := '';
      --获取第i个
      ac02Node := xmldom.item(ac02List,i);
      --获取属性
     -- ac08ArrMap := xmldom.getAttributes(ac02Node);
      --获取子节点
      chilNodes := xmldom.getChildNodes(ac02Node);
      var_aac001 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,0)));
      var_aac002 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,1)));
      var_aac003 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,2)));
       var_yae235 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,3)));
      var_yae238 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,4)));
      var_aaz175 := xmldom.getNodeValue(xmldom.getFirstChild(xmldom.item(chilNodes,5)));
      update xasi2.kc04a1
         set yae235 = var_yae235,
             yae238 = var_yae238
       where aac001 = var_aac001
          and aac002 = var_aac002
         and aac003 = var_aac003
         and aaz175 = var_aaz175;
     end loop;
    EXCEPTION
      WHEN OTHERS THEN
        prm_AppCode := '-1';
        prm_ErrorMsg  := '调用回写上账标志存储过程失败!';
        RETURN;
  END prc_p_accountUpdate;*/

PROCEDURE prc_p_checkInfoByaac001(prm_aac001 IN VARCHAR2,
                           prm_aab001  IN VARCHAR2,
                           prm_flag    OUT   VARCHAR2, --1校验失败，无法续保 2校验成功，高新 3校验成功，市局 4校验成功，合并数据 5校验成功，单增工伤险种  6.未查到 医疗信息
                           prm_msg     OUT   VARCHAR2,
                           prm_AppCode OUT   VARCHAR2,             --错误代码
                           prm_ErrorMsg  OUT   VARCHAR2 )
  IS

    var_aac001 irac01.aac001%TYPE;
    var_aac001_sj irac01.aac001%TYPE;
    var_aac002 irac01.aac002%TYPE;
    var_aac003 irac01.aac003%TYPE;
    var_yae235 irad55.yae235%TYPE;
    var_yab139 irac01.yab139%TYPE;
    var_yae238 irad55.yae238%TYPE;
    num_count  NUMBER(6);
    var_aab001       irac01.aab001%TYPE;
   var_aac031        irac01.aac031%TYPE;
   var_aab004        irab01.aab004%TYPE;
   var_aac002_jm     irac01.aac002%TYPE;
   var_15aac002    irac01.aac002%TYPE;
   var_18aac002    irac01.aac002%TYPE;
   var_aac002Low    irac01.aac002%TYPE;
   var_aac001_more  irac01.aac001%TYPE;
   nl_aac006        NUMBER;
   sj_months        NUMBER;
   xb_aac004      irac01.aac004%TYPE;
   zy_aac008      irac01.aac008%TYPE;
   zy_akc021      irac01.akc021%TYPE;
   count_aac002   NUMBER;
   man_months    NUMBER;
   woman_months    NUMBER;
   num_count1  NUMBER;
  count_jm NUMBER;
  X    varchar2(6);
  v_aac012  irac01.aac012%TYPE;
  woman_worker_months NUMBER;
  VAR_YAE097 NUMBER;
  sjqf_count NUMBER; -- 判断实缴或欠费
  sjqf_aab001  NUMBER; -- 实缴或欠费的单位编号
  sjqf_aab004  irab01.aab004%TYPE; -- 实缴或欠费的单位名称
  jzh_count NUMBER; -- 判断军专户
  yl_count NUMBER; --  养老缴费标志

    cursor cur_ac01 IS SELECT *   FROM xasi2.ac01 A
      WHERE AAE120 = '0'
       AND A.AAC002 IN (var_15aac002, var_aac002Low, var_18aac002)

       AND AAC003 NOT LIKE '%重复%';

  BEGIN
    prm_AppCode := xasi2.pkg_comm.gn_def_OK ;
    prm_ErrorMsg  := '';
    man_months := 720;
    woman_months := 660;
    woman_worker_months :=600;

/*    IF prm_aac001 IS NULL THEN
       prm_AppCode := '1';
       prm_ErrorMsg  := '传入个人编号为空!';
       RETURN;
    END IF;
*/    prm_flag:=2;
      PRM_MSG := '请补录缺失信息！';

        /*SELECT aac002
        INTO count_aac002
        FROM XASI2.AC01
       WHERE AAC001 = PRM_AAC001;
       */
     IF   PRM_AAC001 IS NOT NULL  OR  PRM_AAC001 != '' THEN

     SELECT aac002
        INTO var_aac002_jm
        FROM XASI2.AC01
       WHERE AAC001 = PRM_AAC001;


       --获取各种形式的证件号码
    var_15aac002  := SUBSTR(var_aac002_jm, 1, 6) ||
                     SUBSTR(var_aac002_jm, 9, 9);
    var_aac002Low := LOWER(var_aac002_jm);

    var_18aac002  := var_aac002_jm;

    SELECT count(1)
      INTO num_count
      FROM xasi2.ac01 A
     WHERE AAE120 = '0'
       AND A.AAC002 IN (var_15aac002, var_aac002Low,var_18aac002)

       AND AAC003 NOT LIKE '%重复%';

       -- wanghm modify 续保效验实缴或欠费  军转不受这个限制 start 20190210
       IF num_count>0 THEN

 select max(YAE097)
       into var_yae097
       from xasi2.ab02
      where aae140 <> '04'
        and aab001 = prm_aab001
        and aab051 = 1;

     IF var_yae097 IS NOT NULL THEN
     FOR rec_ac01 IN cur_ac01 LOOP
       SELECT COUNT(1)
        INTO sjqf_count
        FROM (SELECT yae202
                FROM ac08
               WHERE aac001 = rec_ac01.aac001
                 AND aae140 <>'04'
                 AND aae002 > var_yae097
                 AND aab001 not in (select aab001 from wsjb.yac170_info )
              UNION
              SELECT yae202
                FROM ac08a1
               WHERE aac001 = rec_ac01.aac001
                 AND aae140 <>'04'
                 AND aae002 > var_yae097
                 AND aab001 not in (select aab001 from wsjb.yac170_info ));
      IF sjqf_count > 0 THEN
          SELECT a.aab001,b.aab004
            INTO  sjqf_aab001 , sjqf_aab004
            FROM (SELECT aab001
                FROM ac08
               WHERE aac001 = rec_ac01.aac001
                 AND aae140 <>'04'
                 AND aae002 = to_char(add_months(to_date(var_yae097,'yyyymm'),1),'yyyymm')
              UNION
              SELECT aab001
                FROM ac08a1
               WHERE aac001 = rec_ac01.aac001
                 AND aae140 <>'04'
                 AND aae002 = to_char(add_months(to_date(var_yae097,'yyyymm'),1),'yyyymm')) a , xasi2.ab01 b
               WHERE a.aab001=b.aab001;
          PRM_FLAG := '6';
          PRM_MSG  := '该人员当月在单位'||sjqf_aab001||sjqf_aab004||'已存在缴费记录！';
          GOTO LEB_OVER;
       END IF;
     END LOOP;
     END IF;
     END IF;
   -- wanghm modify 续保效验实缴或欠费  军转不受这个限制 end 20190210

    IF num_count>0 THEN
        select to_number(to_char(min(aac006),'yyyymm')),aac004,aac008   INTO nl_aac006 ,xb_aac004,zy_aac008
            from xasi2.ac01
           where aac002 IN (var_15aac002, var_aac002Low,var_18aac002)
             AND AAC003 NOT LIKE '%重复%'
             AND rownum = 1
             group by aac004 , aac008;

           select trunc(months_between(sysdate,to_date(nl_aac006,'yyyymm'))) INTO sj_months from dual;
           
           --  rec_ac01
           select aac012 INTO v_aac012  from xasi2.ac01  where   aac002 IN (var_15aac002, var_aac002Low,var_18aac002)
             AND AAC003 NOT LIKE '%重复%'    AND rownum = 1;

      select count(1)
             into yl_count from wsjb.irac01a7_yl
            where aae123 = '2'
              and aac002  IN (var_15aac002, var_aac002Low,var_18aac002);
                   
      IF  yl_count = 0 THEN


           IF xb_aac004 = '1' and xb_aac004 IS NOT NULL  and  sj_months >=  man_months  THEN

              select akc021  INTO  zy_akc021 from xasi2.kc01    where aac001 = prm_aac001;

              IF   zy_aac008 = 2 and  zy_akc021 =11 THEN
                --  不做业务处理
                select akc021  INTO  zy_akc021 from xasi2.kc01   where aac001 = prm_aac001;
                ELSIF    xb_aac004 = '1' and xb_aac004 IS NOT NULL  and  sj_months >=  man_months  THEN

              PRM_FLAG := '1';
              PRM_MSG  := '此人员年纪超过需要续保的年纪！';
            GOTO LEB_OVER;
              END  IF;
         END IF;

          IF xb_aac004 = '2' and xb_aac004 IS NOT NULL  and  sj_months >=  woman_months  THEN
             IF   zy_aac008 = 2 and  zy_akc021 =11 THEN
                 --  不做业务处理
                select akc021  INTO  zy_akc021 from xasi2.kc01   where aac001 = prm_aac001;
                ELSIF   xb_aac004 = '2' and xb_aac004 IS NOT NULL  and  sj_months >=  woman_months  THEN
              PRM_FLAG := '1';
              PRM_MSG  := '此人员年纪超过需要续保的年纪！';
            GOTO LEB_OVER;
            END  IF;
        END IF;
        
        
       /*  IF   (zy_aac008 = 2 and  zy_akc021 =11)  THEN -- 逐月不处理
            select X INTO X from dual;
          ELSIF    xb_aac004 = '2' and xb_aac004 IS NOT NULL    THEN  
             --  处理干部  55 4  工人 50  1  针对女性  逐月不处理 20190703  
               
                 IF   sj_months > woman_worker_months  and v_aac012 = '1' THEN
                      PRM_FLAG := '1';
                      PRM_MSG  := '该人员个人身份为工人，超过需要续保的年纪！';
                       GOTO LEB_OVER;
                 ELSIF   sj_months >=  woman_months and  v_aac012 = '4'  THEN
                      PRM_FLAG := '1';
                      PRM_MSG  := '该人员个人身份为干部，超过需要续保的年纪！';
                       GOTO LEB_OVER;
                 END IF;
             
             END IF;
         */
        
        END IF;  
        
      END IF;





             IF  num_count > 1 OR  num_count = 1 THEN

             --循环校验ac01
              FOR rec_cur_ac01 IN cur_ac01 LOOP

               SELECT aac001 INTO var_aac001_more   FROM xasi2.ac01 A
               WHERE AAE120 = '0'
               AND A.aac001 = rec_cur_ac01.aac001
               AND A.AAC002 IN (var_15aac002, var_aac002Low,var_18aac002)
                AND AAC003 NOT LIKE '%重复%';


                SELECT COUNT(1)
              INTO COUNT_JM
              FROM XASI2.AC02K1
             WHERE AAC001 = var_aac001_more
               AND AAC031 = '1';
            IF COUNT_JM > 0 THEN
             SELECT AAB004
               INTO VAR_AAB004
               FROM XASI2.AB01
              WHERE AAB001 = (SELECT aab001
                                FROM XASI2.AC02K1
                               WHERE AAC001 = var_aac001_more
                                 AND AAC031 = '1');
              PRM_MSG  := '此身份证号码人员医疗保险关系目前在社区：' || VAR_AAB004 || '参加居民医保，姓名:'  ||'个人编号：'||var_aac001_more|| ',参保状态:参保缴费。';
              PRM_FLAG := '3';
               GOTO LEB_OVER;
             END IF;
           END LOOP;
          END IF;


          --校验续保  20181229



  END  IF ;

 /*   SELECT COUNT(1)
        INTO COUNT_JM
        FROM XASI2.AC02K1
       WHERE AAC001 = PRM_AAC001
         AND AAC031 = '1';

      IF COUNT_JM > 0 THEN
       SELECT AAB004
         INTO VAR_AAB004
         FROM XASI2.AB01
        WHERE AAB001 = (SELECT aab001
                          FROM XASI2.AC02K1
                         WHERE AAC001 = PRM_AAC001
                           AND AAC031 = '1');
        PRM_MSG  := '此身份证号码人员医疗保险关系目前在社区：' || VAR_AAB004 || '参加居民医保，姓名:'  ||'个人编号：'||var_aac001|| ',参保状态:参保缴费。';
        PRM_FLAG := '3';

        GOTO LEB_OVER;
      END IF;
       */

    -- wanghm modify 是否在军专户下参保 start 20190210
     IF num_count>0 THEN
     FOR rec_ac01 IN cur_ac01 LOOP
       select count(1) into jzh_count
         from xasi2.ac02 a, wsjb.yac170_info b
        where a.aab001 = b.aab001
          and aae140 = '03'
          and aac031 = '1'
          and a.aac001 = rec_ac01.aac001;
      IF jzh_count > 0 THEN
          PRM_FLAG := '7';
          --PRM_MSG  := '该人员在军专户下参保医疗险,可以参保的险种为失业、工伤和养老！';
          GOTO LEB_OVER;
       END IF;
     END LOOP;
     END IF;
   -- wanghm modify 是否在军专户下参保 end 20190210

      SELECT COUNT(1)
        INTO NUM_COUNT
        FROM XASI2.AC02
       WHERE AAC001 = PRM_AAC001
         AND AAC031 = '1'
         AND AAB001 <> PRM_AAB001
         AND AAE140 IN ('03', '07', '02', '05', '08');
      IF NUM_COUNT > 0 THEN
        SELECT COUNT(1)
          INTO num_count1
          FROM XASI2.AC02
         WHERE AAC001 = PRM_AAC001
           AND aab001 = prm_aab001
           AND aae140='04'
           AND AAC031 = '1';
         IF num_count1 > 0 THEN
           PRM_FLAG := '1';
           PRM_MSG  := '此人员没有符合续保条件的险种！';
        GOTO LEB_OVER;
         END IF;
        SELECT DISTINCT AAB001
          INTO VAR_AAB001
          FROM XASI2.AC02
         WHERE AAC001 = PRM_AAC001
           AND aae140 <>'04'
           AND AAC031 = '1';
        SELECT AAB004
          INTO VAR_AAB004
          FROM XASI2.AB01
         WHERE AAB001 = VAR_AAB001;
        PRM_FLAG := '5';
        PRM_MSG  := '此身份证号码人员目前正在参保，单位名称：' || VAR_AAB004 || '参保，姓名:' ||
                    VAR_AAC003 || ',参保状态:参保缴费！';
        GOTO LEB_OVER;
      END IF;
    <<leb_over>>
      num_count :=0;
    EXCEPTION
      WHEN OTHERS THEN
        prm_AppCode := '-1';
        prm_ErrorMsg  := '调用续保校验存储过程失败!'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
        RETURN;
  END prc_p_checkInfoByaac001;
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
          RETURN VARCHAR2
   IS
      n_count          NUMBER;
      v_aab020        irab01.aab020%TYPE;--单位类型
      v_aab022        irab01.aab022%TYPE;--行业代码
      v_yab534        irab01.yab534%TYPE;--银行类别
      v_yae010        irab04.yae010%TYPE;--缴费方式
      v_bab503        VARCHAR2(30);--支付银行类别
      s_Appcode        VARCHAR2(18);
      s_Errormsg       VARCHAR2(300);
   BEGIN

      /*初始化变量*/
      s_Appcode  := gn_def_OK;
      s_Errormsg := '';
      n_count    := 1;
      --单位经济类型
      IF prm_aaa100 = 'aab020'THEN
      --内资（有限责任公司）
      IF prm_aaa102 IN ('1100','1110','1123','1130','1140','1150','1151','1152','1153',
                        '2000','2100','2110','2130','2140','2151','2152','2153','5190') THEN
      v_aab020 :='150';
      --外资
      ELSIF prm_aaa102 IN ('1122','5110','5111','5130','5140','5150','5600','5800','5810','6110',
                            '6150','6810','6890') THEN
      v_aab020 :='330';
      --其他有限责任公司
      ELSIF prm_aaa102 IN ('2190','1190') THEN
      v_aab020 :='159';

      ELSE
      v_aab020 :='900';
      END IF;
      RETURN v_aab020;
      END IF;
    IF prm_aaa100 = 'aab022' THEN
    IF prm_aaa102 IN ('A1','A2','A3','A4','A5') THEN
      v_aab022 :='01';
      ELSIF prm_aaa102 IN ('B6','B7','B8','B9','B10','B11','B12') THEN
      v_aab022 :='02';
      ELSIF prm_aaa102 IN ('C13','C14','C15','C16','C17','C18','C19','C20','C21','C22','C23','C24','C25','C26','C27','C28','C29','C30','C31','C32','C33','C34','C35','C36','C37','C38','C39','C40','C41','C42','C43') THEN
      v_aab022 :='03';
      ELSIF prm_aaa102 IN ('D44','D45','D46') THEN
      v_aab022 :='04';
      ELSIF prm_aaa102 IN ('E47','E48','E49','E50') THEN
      v_aab022 :='05';
      ELSIF prm_aaa102 IN ('G53','G54','G55','G56','G57','G58','G59','G60') THEN
      v_aab022 :='06';
      ELSIF prm_aaa102 IN ('I63','I64','I65') THEN
      v_aab022 :='07';
      ELSIF prm_aaa102 IN ('F51','F52') THEN
      v_aab022 :='08';
      ELSIF prm_aaa102 IN ('H61','H62') THEN
      v_aab022 :='09';
      ELSIF prm_aaa102 IN ('J66','J67','J68','J69') THEN
      v_aab022 :='10';
      ELSIF prm_aaa102 IN ('K70') THEN
      v_aab022 :='11';
      ELSIF prm_aaa102 IN ('L71','L72') THEN
      v_aab022 :='12';
      ELSIF prm_aaa102 IN ('M73','M74') THEN
      v_aab022 :='13';
      ELSIF prm_aaa102 IN ('N76','N77','N78') THEN
      v_aab022 :='14';
      ELSIF prm_aaa102 IN ('O79','O80','O81') THEN
      v_aab022 :='15';
      ELSIF prm_aaa102 IN ('P82') THEN
      v_aab022 :='16';
      ELSIF prm_aaa102 IN ('Q83','Q84','S93') THEN
      v_aab022 :='17';
      ELSIF prm_aaa102 IN ('R85','R86','R87','R88','R89') THEN
      v_aab022 :='18';
      ELSIF prm_aaa102 IN ('S94') THEN
      v_aab022 :='19';
      ELSIF prm_aaa102 IN ('T96') THEN
      v_aab022 :='20';
      ELSE
      v_aab022 :='00';
      END IF;
    RETURN v_aab022;
    END IF;
   IF prm_aaa100 = 'yab534' THEN
     IF prm_aaa102 = '2' THEN
      v_yab534 := 'GH';
      ELSIF prm_aaa102 = '3' THEN
      v_yab534 := 'ZH';
      ELSIF prm_aaa102 = '4' THEN
      v_yab534 := 'JH';
      ELSIF prm_aaa102 = '5' THEN
      v_yab534 := 'NH';
      ELSIF prm_aaa102 = '6' THEN
      v_yab534 := 'JT';
      ELSIF prm_aaa102 = '7' THEN
      v_yab534 := 'XH';
      ELSIF prm_aaa102 = '9' THEN
      v_yab534 := 'ZS';
      ELSE
      v_yab534 := 'ZH';
      END IF;
      RETURN v_yab534;
      END IF;
   IF prm_aaa100 = 'yae010' THEN
      IF prm_aaa102 = '1' THEN
      v_yae010 := '3';
      ELSIF prm_aaa102 = '3' THEN
      v_yae010 := '2';
      ELSE
      v_yae010 := '9';
      END IF;
      RETURN v_yae010;
      END IF;

   IF prm_aaa100 = 'bab503' THEN
      IF prm_aaa102 = '2' THEN
      v_bab503 := '102';
      ELSIF prm_aaa102 = '3' THEN
      v_bab503 := '104';
      ELSIF prm_aaa102 = '4' THEN
      v_bab503 := '105';
      ELSIF prm_aaa102 = '5' THEN
      v_bab503 := '103';
      ELSIF prm_aaa102 = '6' THEN
      v_bab503 := '301';
      ELSIF prm_aaa102 = '9' THEN
      v_bab503 := '308';
      ELSE
      v_bab503 := '000';
      END IF;
      RETURN v_bab503;
      END IF;

   EXCEPTION
     -- WHEN NO_DATA_FOUND THEN
     -- WHEN TOO_MANY_ROWS THEN
     -- WHEN DUP_VAL_ON_INDEX THEN
     WHEN OTHERS THEN
       /*关闭打开的游标*/
       RETURN '';
   END FUN_GETAAB020;


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
                                prm_AppCode OUT   VARCHAR2,             --错误代码
                                prm_ErrorMsg  OUT   VARCHAR2
                              )
  IS


    num_count  NUMBER(6);
    num_yae097_min NUMBER(6);
    num_yae097_max NUMBER(6);
    num_aae001 NUMBER(4);
    var_iaa002 irab01.iaa002%TYPE;
    var_iaa006 irad51.iaa006%TYPE;
    dat_aae036 DATE;
    num_aae002 NUMBER(6);


  BEGIN
    prm_AppCode := xasi2.pkg_comm.gn_def_OK ;
    prm_ErrorMsg  := '';
    --检验传入参数
    IF prm_aab001 IS NULL THEN
       prm_AppCode := '1';
       prm_ErrorMsg  := '传入单位编号不能为空!';
       RETURN;
    END IF;

    prm_disabledBtn :='printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,cancelBtn';


    SELECT count(1)
      INTO num_count
      FROM xasi2.ab02
     WHERE aab001 = prm_aab001;
    IF num_count > 0 THEN
       --检查最大做帐期号是否正常
        SELECT MAX(yae097)
          INTO num_yae097_max
          FROM xasi2.ab02
         WHERE aab001 = prm_aab001
           and AAB051 = '1' ;

         SELECT MIN(yae097)
          INTO num_yae097_min
          FROM xasi2.ab02
         WHERE aab001 = prm_aab001
           and  AAB051 = '1' ;

         IF num_yae097_min <> num_yae097_max THEN
            prm_msg :='单位最大做帐期号不一致！';
            GOTO leb_over;
         END IF;

      --modify by whm 20190429  取年审年度 start
      SELECT MAX(aae042)
        INTO num_yae097_max
        FROM xasi2.ab02
       WHERE aab001 = prm_aab001
         AND AAB051 = '1';
     --modify by whm 20190429  取年审年度 end

--         IF var_yae097_max < 201712 THEN
--            prm_msg := '最大缴费期号小于201712!';
--            GOTO leb_over;
--          END IF;
     ELSE
        SELECT MAX(aae003)
          INTO num_yae097_max
          FROM wsjb.IRAB08
         WHERE aab001 = prm_aab001
           AND yae517 = 'H01'
           AND aae140 = '01';

--         IF var_yae097_max < 201712 THEN
--            prm_msg := '最大缴费期号小于201712!';
--            GOTO leb_over;
--          END IF;
     END IF;

     --检查年审年度
     num_aae001 :=SUBSTR(num_yae097_max,0,4)+1;
     
       SELECT count(1)
       INTO num_count
       FROM wsjb.irad54
      WHERE aab001 = prm_aab001
        AND aae001 = num_aae001
        AND iaa011 = 'A05';
     IF num_count > 0 THEN
        prm_msg :='已提交年审信息，请进行年审业务预约，并打印相关报表、携带相关资料，到社保中心审核！如发现有误，可自行撤销提交，修改正确后再次提交。';
        prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,delBtn';
        GOTO leb_over;
     END IF;

     SELECT count(1)
       INTO num_count
       FROM wsjb.irad51
      WHERE aab001 = prm_aab001
        AND aae001 = num_aae001
        AND iaa011 = 'A05';

     IF num_count > 0 THEN
        SELECT IAA002,
               iaa006,
               aae036+5
          INTO var_iaa002,
               var_iaa006,
               dat_aae036
          FROM wsjb.irad51
         WHERE aab001 = prm_aab001
           AND aae001 = num_aae001
           AND iaa011 = 'A05';

        IF var_iaa002 = '1' THEN
           --prm_msg :='已提交年审信息，请打印相关报表，到社保中心审核！如发现有误，可自行撤销提交，修改正确后再次提交。';
           prm_msg :='已提交年审信息，请等待社保中心审核！如发现有误，可自行撤销提交，修改正确后再次提交。';
           prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,delBtn';
           GOTO leb_over;
        END IF;
        IF var_iaa002 = '2' AND var_iaa006 ='0' THEN
           prm_msg :='年申报信息正在审核当中...';
           prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,cancelBtn,printBtn3,printBtn4,delBtn,printBtn5';
           GOTO leb_over;
        END IF;
        IF var_iaa002 = '3' AND var_iaa006 ='0' THEN
           prm_msg :='年申报信息审核未通过，修改后继续提交!';
           prm_disabledBtn :='printBtn3,printBtn4,printBtn5,delBtn';
        END IF;

        IF var_iaa002 = '2' AND var_iaa006 ='1' THEN

           IF dat_aae036 > SYSDATE THEN
               prm_msg :='年申报信息审核完成！请打印相关报表，及时缴费！';
               prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,cancelBtn,delBtn';
               GOTO leb_over;
           ELSE
               IF num_yae097_max < TO_NUMBER(TO_CHAR(num_aae001||'12')) THEN
                  prm_msg :='单位的做账期还未到'||TO_CHAR(num_aae001||'12')||'，请在网报系统上申报至'||TO_CHAR(num_aae001||'12')||'月度!';
                  prm_disabledBtn :='queryBtn,exportBtn,importBtn,retainBtn,viewBtn,applyBtn,cancelBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5';
                  GOTO leb_over;
               END IF;
                num_aae001 := num_aae001 + 1;
           END IF;
        END IF;
    ELSE
       --检查是否有养老提前结算申请未审核
    SELECT count(1)
      INTO num_count
      FROM irad51a1
      WHERE aab001 = prm_aab001
        AND yae031='0';
    IF num_count > 0 THEN

     prm_msg :='单位有未办结的养老保险提前结算业务，不能做年审操作！';
     prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,cancelBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,viewBtn';
     GOTO leb_over;
     END IF;
     --检查是否有未提交的人员增减
     SELECT count(1)
      INTO num_count
      FROM wsjb.irac01
      WHERE aab001 = prm_aab001
        AND iaa001 IN ('1','3','5','6','7','8')
        AND iaa100 IS NULL;
    IF num_count > 0 THEN

     prm_msg :='单位有未提交的人员增减信息，请提交月报或撤销增减信息后重新进行年审操作！';
     prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,cancelBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,viewBtn';
     GOTO leb_over;
     END IF;
     --检查是否有未提交的养老未转入备案
     SELECT count(1)
      INTO num_count
      FROM wsjb.irac01c1
      WHERE aab001 = prm_aab001
        AND yae031='0';
    IF num_count > 0 THEN
     prm_msg :='单位有未提交的养老未转入备案信息，请提交或撤销后重新进行年审操作！';
     prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,cancelBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,viewBtn';
     GOTO leb_over;
     END IF;
     --检查单位是否有未审核的月申报信息
     SELECT count(1)
      INTO num_count
      FROM wsjb.irad01
      WHERE aab001 = prm_aab001
        AND iaa100 >= prm_aae001||01
        AND iaa011 = 'A04';
    IF num_count > 0 THEN
      SELECT MAX(iaa100)
      INTO num_aae002
      FROM wsjb.irad01
      WHERE aab001 = prm_aab001
        AND iaa100 >= prm_aae001||01
        AND iaa011 = 'A04';
        SELECT SUM(coun)
          INTO num_count
          FROM
         (SELECT COUNT(1) AS coun
                 FROM xasi2.ab08
                WHERE aab001 = prm_aab001
                  AND yae517 = 'H01'
                  AND aae003 = num_aae002
               UNION
                SELECT COUNT(1) AS coun
                  FROM wsjb.irab08
                  WHERE aab001 = prm_aab001
                  AND yae517 = 'H01'
                  AND aae003 = num_aae002);
       IF num_count = 0 THEN
         prm_msg :='单位提交的月申报还未审核通过，请通过后再进行年审操作！';
         prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,cancelBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,viewBtn';
         GOTO leb_over;
             END IF;


     END IF;
     SELECT count(1)
       INTO num_count
       FROM wsjb.irac01c1
      WHERE aab001 = prm_aab001
        AND yae031='1';
      IF num_count >0 THEN
       SELECT MAX(iaa100)
         INTO num_aae002
         FROM wsjb.irac01c1
        WHERE aab001 = prm_aab001
          AND yae031='1';
        SELECT count(1)
          INTO num_count
          FROM wsjb.irab08
         WHERE aab001 = prm_aab001
           AND aae003 = num_aae002
           AND yae517 = 'H01';
       IF num_count = 0 THEN
        prm_msg :='你单位存在有未申报的养老未转入备案信息，请提交月报或撤销备案信息后后重新进行年审操作！';
         prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,cancelBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,viewBtn';
         GOTO leb_over;
        END IF;
       END IF;
     --检查是否有信息变更业务
     SELECT count(1)
       INTO num_count
      FROM IRAD31 A, IRAD32 B
       WHERE A.IAZ012 = B.IAZ012
         AND A.AAB001 = PRM_AAB001
         AND A.IAA019 = '1'
         AND A.IAA011 = 'A03';
       IF num_count >0 THEN
        prm_msg :='单位有未办结的人员重要信息变更业务，请按要求到柜台审核或撤销后再进行年审操作！';
        prm_disabledBtn :='exportBtn,importBtn,retainBtn,applyBtn,cancelBtn,printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,viewBtn';
        GOTO leb_over;
        END IF;
     END IF;





    --获取缴费上下限
    --养老
    SELECT MAX(aae041)
      INTO num_aae002
      FROM xasi2.AA02
     WHERE yaa001 = '16'
       AND aae140 = '01'
       AND aae001 = num_aae001;
    SELECT to_char(PKG_COMMON.fun_p_getcontributionbase(null,prm_aab001,1,'0','01','1','1',num_aae002,prm_yab139))
      INTO prm_dxby01
      FROM dual;
    SELECT count(1)
      INTO num_count
      FROM xasi2.AA02
     WHERE yaa001 = '16'
       AND aae140 = '01';
    IF num_count <2 THEN
      SELECT to_char(TRUNC(PKG_COMMON.fun_p_getcontributionbase(null,prm_aab001,20000000,'0','01','1','1',num_aae002,prm_yab139)*1.1))
        INTO prm_gxby01
        FROM dual;
    ELSE
      SELECT to_char(TRUNC(PKG_COMMON.fun_p_getcontributionbase(null,prm_aab001,20000000,'0','01','1','1',num_aae002,prm_yab139)))
        INTO prm_gxby01
        FROM dual;
    END IF;
    --医疗
    SELECT MAX(aae041)
      INTO num_aae002
      FROM xasi2.AA02
     WHERE yaa001 = '16'
       AND aae140 = '03'
       AND aae001 = num_aae001;
    SELECT to_char(PKG_COMMON.fun_p_getcontributionbase(null,prm_aab001,1,'0','03','1','1',num_aae002,prm_yab139))
      INTO prm_dxby03
      FROM dual;
    SELECT to_char(PKG_COMMON.fun_p_getcontributionbase(null,prm_aab001,20000000,'0','03','1','1',num_aae002,prm_yab139))
      INTO prm_gxby03
      FROM dual;
    <<leb_over>>
    num_count :=0;
    prm_aae001 := num_aae001;
    prm_aae002 := num_aae001||'01';
    EXCEPTION
      WHEN OTHERS THEN
        prm_AppCode := '-1';
        prm_ErrorMsg  := '调用续保校验存储过程失败!'||SQLERRM||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
        RETURN;
  END prc_p_checkInfoByYear;
END pkg_P_Validate;
/
