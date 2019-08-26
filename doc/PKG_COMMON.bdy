create or replace package body PKG_COMMON as

  /*------------------------------------------------------------------------*/
  /* 私有全局变量声明                                                       */
  /*------------------------------------------------------------------------*/

  Pre_Errcode    CONSTANT        VARCHAR2(9) := 'COMMON';

  TYPE Rec_Sequenceinfo IS RECORD(
    s_Kind VARCHAR2(30),
    s_Name VARCHAR2(30),
    b_Date BOOLEAN);
  TYPE Tab_Sequenceinfo IS TABLE OF Rec_Sequenceinfo INDEX BY BINARY_INTEGER;
  Tab_Sequence Tab_Sequenceinfo;

    /*---------------------------------------------------------------------------
  || 业务环节 ：公共类_获取序列号
  || 过程名称 ：prc_GetSequence
  || 功能描述 ：根据用户输入的类型编码，获取指定类型的序列号。
  ||            此存储过程在入口处对传入的类型编码作了有效性检查，因此如果需要增加
  ||            一类序列号，除了需要建立相应的Sequence外，还需要修改此存储过程，包
  ||            括入口的判断和后续的获取序列号的处理。
  || 使用场合 ：
  || 参数描述 ：标识                  名称             输入输出   数据类型
  ||            ---------------------------------------------------------------
  ||            prm_Prefixion      前缀                 输入     VARCHAR2(10)
  ||            prm_Kind           类型编码             输入     VARCHAR2(2)
  ||            prm_Sequence       序列号               输出     VARCHAR2(20)
  ||            prm_AppCode        执行代码             输出     VARCHAR2(12)
  ||            prm_ErrorMsg       出错信息             输出     VARCHAR2(128)
  ||
  || 参数说明 ：标识               详细说明
  ||            ---------------------------------------------------------------
  || 其它说明 ：
  || 作    者 ：
  || 完成日期 ：
  ||---------------------------------------------------------------------------
  ||                                 修改记录
  ||---------------------------------------------------------------------------
  || 修 改 人 ：×××                        修改日期 ：YYYY-MM-DD
  || 修改描述 ：
  ||-------------------------------------------------------------------------*/
  PROCEDURE Prc_Getsequence(Prm_Prefixion IN VARCHAR2,
                            Prm_Kind      IN VARCHAR2,
                            Prm_Sequence  OUT VARCHAR2,
                            Prm_Appcode   OUT VARCHAR2,
                            Prm_Errormsg  OUT VARCHAR2) IS
    /*变量声明*/
    n_Sequence NUMBER(20, 0);
    i_Count    INTEGER;
    i_For      INTEGER;
    b_Intable  BOOLEAN;
    str_Prefixion VARCHAR2(25);
    str_name VARCHAR2(30);
    str_Sequence VARCHAR2(30);
    /*游标声明*/

  BEGIN
    /*初始化变量*/
    Prm_Appcode  := PKG_Constant.GN_DEF_OK;
    Prm_Errormsg := '';
    Prm_Sequence := '';
    str_Sequence := '';
    str_Prefixion := '';
    n_Sequence   := 0;
    i_Count      := 0;
    i_For        := 0;
    b_Intable    := FALSE;

    IF Tab_Sequence.COUNT = 0 THEN

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'FRAMEWORK';
       Tab_Sequence(i_Count).s_Name := 'SEQ_FRAMEWORK';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'DEFAULT';
       Tab_Sequence(i_Count).s_Name := 'SEQ_DEFAULT';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ001';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ001';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'AAZ184';
       Tab_Sequence(i_Count).s_Name := 'SEQ_AAZ184';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAB001';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAB001';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ002';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ002';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ003';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ003';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ004';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ004';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ005';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ005';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ009';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ009';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ010';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ010';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ012';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ012';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ013';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ013';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ014';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ014';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ015';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ015';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ016';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ016';
       Tab_Sequence(i_Count).b_Date := FALSE;


       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ017';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ017';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ018';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ018';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ019';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ019';
       Tab_Sequence(i_Count).b_Date := FALSE;


       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ020';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ020';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ021';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ021';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ022';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ022';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ023';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ023';
       Tab_Sequence(i_Count).b_Date := FALSE;


       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'AAZ002';
       Tab_Sequence(i_Count).s_Name := 'SEQ_AAZ002';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAC001';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAC001';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'YAC001';
       Tab_Sequence(i_Count).s_Name := 'SEQ_YAC001';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'YAE518';
       Tab_Sequence(i_Count).s_Name := 'SEQ_YAE518';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'YAE202';
       Tab_Sequence(i_Count).s_Name := 'SEQ_YAE202';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_Kind := 'IAZ051';
       Tab_Sequence(i_Count).s_Name := 'SEQ_IAZ051';
       Tab_Sequence(i_Count).b_Date := FALSE;

       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_kind :='AAA160';
       Tab_Sequence(i_Count).s_Name := 'SEQ_AAA160';
       Tab_Sequence(i_Count).b_Date := FALSE;


       i_Count := i_Count + 1;
       Tab_Sequence(i_Count).s_kind :='YAZ031';
       Tab_Sequence(i_Count).s_Name := 'SEQ_YAZ031';
       Tab_Sequence(i_Count).b_Date := FALSE;

       --begin SEQ_*_AAB020
       --jjg 20120411 针对单位助记码根据单位类型的类别来获取不同编码 共六类
       --Prm_Prefixion前台前缀传类别，根据不同类别获取不同编码类别的前缀
       IF Upper(Prm_Kind)='AAB020' AND Prm_Prefixion IN('1','2','3','4','5','6') THEN

         IF Prm_Prefixion='1' THEN --第一类 前缀'0' 代表 国有、国有独资
            str_Prefixion :='0';
            str_name :='SEQ_0_AAB020';
         END IF;
         IF Prm_Prefixion='2' THEN --二类 前缀 '1' 代表 集体企业
             str_Prefixion :='1';
            str_name :='SEQ_1_AAB020';
         END IF;
         IF Prm_Prefixion='3' THEN --第三类 前缀 '2'、'4'、'5'、'6'、'7' 满位递增 代表 股份、私营、其他等
            str_Prefixion :='2';
            str_name :='SEQ_2_AAB020';
            EXECUTE IMMEDIATE 'SELECT '||str_name||'.NEXTVAL FROM DUAL'
            INTO Prm_Sequence;
            IF LENGTH(Prm_Sequence) > 4 THEN --如果前缀'2'的后四位用完 则使用前缀为'4'的序列号
                str_Prefixion :='4';
                str_name :='SEQ_4_AAB020';
                EXECUTE IMMEDIATE 'SELECT '||str_name||'.NEXTVAL FROM DUAL'
                INTO Prm_Sequence;
                 IF LENGTH(Prm_Sequence) > 4 THEN
                  str_Prefixion :='5';
                  str_name :='SEQ_5_AAB020';
                  EXECUTE IMMEDIATE 'SELECT '||str_name||'.NEXTVAL FROM DUAL'
                  INTO Prm_Sequence;
                    IF LENGTH(Prm_Sequence) > 4 THEN
                    str_Prefixion :='6';
                    str_name :='SEQ_6_AAB020';
                    EXECUTE IMMEDIATE 'SELECT '||str_name||'.NEXTVAL FROM DUAL'
                     INTO Prm_Sequence;
                        IF LENGTH(Prm_Sequence) > 4 THEN
                        str_Prefixion :='7';
                        str_name :='SEQ_7_AAB020';
                        EXECUTE IMMEDIATE 'SELECT '||str_name||'.NEXTVAL FROM DUAL'
                         INTO Prm_Sequence;
                        END IF;
                     END IF;
                 END IF;
            END IF;
            --直接将序列号返回
            str_Sequence := '00000'||Prm_Sequence;--补位到4位数
            Prm_Sequence := SUBSTR(str_Sequence,LENGTH(str_Sequence)-3,4);
            Prm_Sequence := str_Prefixion || Prm_Sequence;
            GOTO label_Ok;
         END IF;
         IF Prm_Prefixion='4' THEN --第四类 前缀'3' 代表 港澳台、中外合资等
            str_Prefixion :='3';
            str_name :='SEQ_3_AAB020';
         END IF;
         IF Prm_Prefixion='5' THEN --第五类 前缀'8' 高新区管委会
            str_Prefixion :='8';
            str_name :='SEQ_8_AAB020';
         END IF;
         IF Prm_Prefixion='6' THEN --第六类 前缀'9' 其他参保单位和参保人
            str_Prefixion :='9';
            str_name :='SEQ_9_AAB020';
         END IF;

         EXECUTE IMMEDIATE 'SELECT '||str_name||'.NEXTVAL FROM DUAL'
          INTO Prm_Sequence;

         --直接将序列号返回
         str_Sequence := '00000'||Prm_Sequence;--补位到4位数
         Prm_Sequence := SUBSTR(str_Sequence,LENGTH(str_Sequence)-3,4);
         Prm_Sequence := str_Prefixion || Prm_Sequence;
         GOTO label_Ok;

       END IF;
    END IF;


    FOR i_For IN 1 .. Tab_Sequence.COUNT LOOP
      IF Tab_Sequence(i_For).s_Kind = Upper(Prm_Kind) THEN
        EXECUTE IMMEDIATE 'SELECT ' || Tab_Sequence(i_For)
                         .s_Name || '.NEXTVAL FROM DUAL'
          INTO Prm_Sequence;
        b_Intable := TRUE;
        EXIT;
      END IF;
    END LOOP;
    IF NOT b_Intable THEN
      Prm_Appcode  := Pre_Errcode || '0002';
      Prm_Errormsg := '类型编码 = ' || Prm_Kind || ' 的序列号不存在';
      GOTO Label_Error;
    END IF;

    Prm_Sequence := Prm_Prefixion || Prm_Sequence;
    /*成功处理*/
    <<label_Ok>>
    /*关闭打开的游标*/

    /*给返回参数赋值*/
    Prm_Appcode  := Pkg_Constant.Gn_Def_Ok;
    Prm_Errormsg := '';
    RETURN;

    /*处理失败*/
    <<label_Error>>
    /*关闭打开的游标*/

    /*给返回参数赋值*/
    Prm_Sequence := '';
    IF Prm_Appcode = Pkg_Constant.Gn_Def_Ok THEN
      Prm_Appcode := Pre_Errcode || Pkg_Constant.Gn_Def_Err;
    END IF;
    RETURN;

  EXCEPTION
    WHEN OTHERS THEN
      Prm_Sequence := '';
      Prm_Appcode  := Pre_Errcode || Pkg_Constant.Gn_Def_Err;
      Prm_Errormsg := '获取流水号数据库错误:' || SQLERRM;
      RETURN;
  END Prc_Getsequence;


  /*---------------------------------------------------------------------------
  || 业务环节 ：公共类_获取序列号
  || 过程名称 ：prc_GetSequence
  || 功能描述 ：根据用户输入的类型编码，获取指定类型的序列号。
  ||            此存储过程在入口处对传入的类型编码作了有效性检查，因此如果需要增加
  ||            一类序列号，除了需要建立相应的Sequence外，还需要修改此存储过程，包
  ||            括入口的判断和后续的获取序列号的处理。
  || 使用场合 ：
  || 参数描述 ：标识                  名称             输入输出   数据类型
  ||            ---------------------------------------------------------------
  ||            prm_Prefixion      前缀                 输入     VARCHAR2(10)
  ||            prm_Kind           类型编码             输入     VARCHAR2(2)
  ||                               序列号               返回     VARCHAR2(20)
  ||
  || 参数说明 ：标识               详细说明
  ||            ---------------------------------------------------------------
  || 其它说明 ：
  || 作    者 ：
  || 完成日期 ：
  ||---------------------------------------------------------------------------
  ||                                 修改记录
  ||---------------------------------------------------------------------------
  || 修 改 人 ：×××                        修改日期 ：YYYY-MM-DD
  || 修改描述 ：
  ||-------------------------------------------------------------------------*/
  FUNCTION Fun_Getsequence(Prm_Prefixion IN VARCHAR2,
                           Prm_Kind      IN VARCHAR2) RETURN VARCHAR2 IS
    s_Sequence VARCHAR2(30);
    s_Appcode  VARCHAR2(18);
    s_Errormsg VARCHAR2(300);
  BEGIN

    /*初始化变量*/
    s_Appcode  := PKG_Constant.GN_DEF_OK;
    s_Errormsg := '';

    Pkg_Common.Prc_Getsequence(Prm_Prefixion,
                             Prm_Kind,
                             s_Sequence,
                             s_Appcode, -- 执行代码
                             s_Errormsg); -- 出错信息
    IF s_Appcode != Pkg_Constant.Gn_Def_Ok THEN
      RETURN '';
    END IF;
    RETURN s_Sequence;
  EXCEPTION
    -- WHEN NO_DATA_FOUND THEN
    -- WHEN TOO_MANY_ROWS THEN
    -- WHEN DUP_VAL_ON_INDEX THEN
    WHEN OTHERS THEN
      /*关闭打开的游标*/
      RETURN '';
  END Fun_Getsequence;

/***************************************************************************
   ** 过程名称 ：prc_P_getContributionBase
   ** 过程编号 ：11
   ** 业务环节 ：缴费工资封顶
   ** 功能描述 ：缴费工资封顶
   ****************************************************************************
   ** 参数述 ：参数标识        输入/输出           类型            名称
   ****************************************************************************
   ** 作  者：      作成日期 ：2009-12-07   版本编号 ：Ver 1.0.0
   ****************************************************************************
   ** 修  改：
   ****************************************************************************
   ** 备  注：prm_AppCode 构成是:过程编号（2位） ＋ 顺序号（2位）
   ***************************************************************************/
   --缴费工资封顶
   PROCEDURE prc_P_getContributionBase
                              (prm_aac001       IN     xasi2.ac01.aac001%TYPE   ,     --个人编码
                               prm_aab001       IN     xasi2.ab01.aab001%TYPE   ,     --单位编码
                               prm_Aac040       IN     xasi2.ac02.aac040%TYPE   ,     --缴费工资
                               prm_YAC503       IN     xasi2.ac02.YAC503%TYPE   ,     --工资类别
                               prm_Aae140       IN     xasi2.ac02.aae140%TYPE   ,     --险种类型
                               prm_yac505       IN     xasi2.ac02.yac505%TYPE   ,     --缴费人员类别
                               prm_yab136       IN     xasi2.ab01.yab136%TYPE   ,     --单位管理类型（区别独立缴费人员）
                               prm_Aae002       IN     xasi2.ac08.aae002%TYPE   ,     --费款所属期
                               prm_YAB139       IN     xasi2.ac02.YAB139%TYPE   ,     --参保分中心
                               prm_Yac004       OUT    xasi2.ac02.yac004%TYPE   ,     --缴费基数
                               prm_AppCode      OUT    VARCHAR2           ,     --错误代码
                               prm_ErrMsg       OUT    VARCHAR2           )     --错误内容
    IS
      /*变量声明*/
      n_Yaa005                        xasi2.aa02a2.yaa005%TYPE;   --保底数
      n_Yaa006                        xasi2.aa02a2.yaa006%TYPE;   --封顶数
      var_procNo                    VARCHAR2(3);          --过程序号
      var_yaa025                     xasi2.aa02a2.yaa025%TYPE;   --保底封顶类别
      num_Aac040                  xasi2.ac02.aac040%TYPE;     --缴费工资
      num_spgz                       xasi2.ac02.aac040%TYPE;
      var_yaa001                     xasi2.aa02.yaa001%TYPE;
      var_aae140                     xasi2.ab02.aae140%TYPE;
      num_yac004                   xasi2.ac02.yac004%TYPE;     --缴费基数
      var_yab275                     xasi2.ab01.yab275%TYPE;     --社会保险执行办法
      var_aab019                     xasi2.ab01.aab019%TYPE;     --单位性质
      n_number                       NUMBER;

      /*游标声明*/
      CURSOR cur_aa02a2                                        -- 保底封顶信息表
      IS
         SELECT NVL(yaa005,0),                                 -- 保底数
                NVL(yaa006,0)                                  -- 封顶数
           FROM xasi2.aa02a2
          WHERE aae140 = prm_Aae140                            -- 险种类型
            AND (yaa025 = var_yaa025 OR yaa025 = '$$')                          -- 保底封顶类别
            AND aae041 <= prm_Aae002                           -- 开始年月
            AND (aae042 >= prm_Aae002 OR aae042 IS NULL )      -- 终止年月
            AND (YAB139 = prm_YAB139 OR YAB139 = '$$$$' );                           -- 社保经办机构
   BEGIN
      /*初始化变量*/
      prm_AppCode    := PKG_Constant.GN_DEF_OK;
      prm_ErrMsg     := ''                  ;
      var_procNo     := '02';
      IF prm_YAC503 IS NULL THEN
         prm_AppCode := Pre_Errcode||var_procNo||'01';
         prm_ErrMsg  := '没有录入工资类别';
         GOTO label_ERROR;
      END IF;
      IF prm_Aae140 IS NULL THEN
         prm_AppCode := Pre_Errcode||var_procNo||'02';
         prm_ErrMsg  := '没有录入险种类型';
         GOTO label_ERROR;
      END IF;
      IF prm_yac505 IS NULL THEN
         prm_AppCode := Pre_Errcode||var_procNo||'03';
         prm_ErrMsg  := '没有录入缴费人员类别';
         GOTO label_ERROR;
      END IF;
      IF prm_yab136 IS NULL THEN
         prm_AppCode := Pre_Errcode||var_procNo||'04';
         prm_ErrMsg  := '没有录入单位管理类型';
         GOTO label_ERROR;
      END IF;
      IF prm_YAB139 IS NULL THEN
         prm_AppCode := Pre_Errcode||var_procNo||'05';
         prm_ErrMsg  := '没有录入参保分中心';
         GOTO label_ERROR;
      END IF;

      --chenzw 20120903 增加机关养老险种  按照政策,机关养老险种不保底封顶
      IF PRM_AAE140 = PKG_Constant.AAE140_JGYL THEN
         IF prm_Aac040 IS NULL THEN
            num_Aac040:=0;
            GOTO label_OK;
         ELSE
            num_Aac040 := prm_Aac040;
            GOTO label_OK;
         END IF;
      END IF;

      IF prm_aae140 = PKG_Constant.aae140_DEYL THEN
         IF prm_Aac040 IS NULL THEN
            num_Aac040 := 0 ;
         ELSE
            num_Aac040 := prm_Aac040;
         END IF;
      ELSE
         --获取申报工资
         IF prm_YAC503 IN(PKG_Constant.YAC503_SB,--申报工资
                          PKG_Constant.YAC503_LRYLJ)  --录入养老金
         THEN
            IF prm_Aac040 IS NULL THEN
               prm_AppCode := Pre_Errcode||var_procNo||'06';
               prm_ErrMsg  := '没有录入申报工资';
               GOTO label_ERROR;
            ELSE
               num_Aac040 := prm_Aac040;
            END IF;
         ELSIF prm_YAC503 IN(PKG_Constant.YAC503_GP100,  --岗平工资
                             PKG_Constant.YAC503_GP60,
                             PKG_Constant.YAC503_GP150)
         THEN
            var_yaa001 := '16'; --当地岗平工资
            --从aa02中获取岗平工资
            num_Aac040 := xasi2.Pkg_Comm.fun_GetAvgSalary(
                                                      prm_aae140     ,
                                                      var_yaa001     ,
                                                      prm_aae002     ,
                                                      prm_Yab139    );
            IF num_Aac040 = -1 THEN
               prm_AppCode := Pre_Errcode||var_procNo||'07';
               prm_ErrMsg  := '险种类型:'||prm_aae140||'费款所属期:'||prm_aae002||'没有获取到岗平工资';
               GOTO label_ERROR;
            ELSE
               --将年度平均工资转换为月工资
               IF prm_YAC503 = PKG_Constant.YAC503_GP100 THEN
                  num_Aac040 := ROUND(num_Aac040/12);
               ELSIF prm_YAC503 = PKG_Constant.YAC503_GP60 THEN
                  num_Aac040 := trunc(num_Aac040 * 0.6/12)+1;
               ELSIF prm_YAC503 = PKG_Constant.YAC503_GP150 THEN
                  num_Aac040 := ROUND(num_Aac040 * 1.5/12);
               END IF;
            END IF;
         END IF;
      END IF;
      --缴费工资不含小数点后的值
      --num_Aac040 := ROUND(num_Aac040,0);
      --获取单位的社会保险执行办法
      BEGIN
         SELECT yab275,aab019
           INTO var_yab275,var_aab019
           FROM wsjb.irab01
          WHERE aab001 = iab001
            and aab001 = prm_aab001;
         EXCEPTION
            WHEN OTHERS THEN
            BEGIN
               SELECT yab275,aab019
                 INTO var_yab275,var_aab019
                 FROM xasi2.ab01
                WHERE aab001 = prm_aab001;
              EXCEPTION
            WHEN OTHERS THEN
               prm_AppCode := Pre_Errcode||'getContributionBase01';
               prm_ErrMsg  := '单位编码:'||prm_aab001||'没有获取到单位基本信息'||SQLERRM;
               GOTO label_ERROR;
            END;
      END;
      --获取保底封顶原则
      IF prm_aae140 = PKG_Constant.AAE140_JBYL THEN --基本医疗:注意判断顺序
         IF prm_YAC503 IN(PKG_Constant.YAC503_LRYLJ)--录入养老金
         THEN
            var_yaa025 := '4';  --养老金
         ELSIF prm_yab136 = PKG_Constant.YAB136_GT THEN --独立缴费人员管理虚拟单位
            var_yaa025 := '3';  --独立缴费人员
         ELSE
            IF var_yab275 = PKG_Constant.YAB275_QY THEN--企业待遇
               var_yaa025 := '1';  --普通职工
            ELSE
               var_yaa025 := '1';  --公务员
            END IF;
         END IF;
      ELSE
         IF var_yab275 = PKG_Constant.YAB275_QY THEN--企业待遇
            var_yaa025 := '1';  --普通职工
         ELSE
            var_yaa025 := '1';  --公务员
         END IF;
      END IF;
      OPEN cur_aa02a2;
      FETCH cur_aa02a2 INTO  n_Yaa005,n_Yaa006;
      IF cur_aa02a2%NOTFOUND THEN
         GOTO label_ERROR;
      END IF ;
      CLOSE cur_aa02a2 ;
      /*成功处理*/
      <<label_OK>>
      IF num_Aac040 < n_Yaa005 THEN
         prm_Yac004 := n_Yaa005;
      ELSIF num_Aac040 > n_Yaa006 THEN
         prm_Yac004 := n_Yaa006;
      ELSE
         prm_Yac004 := num_Aac040;
      END IF ;

      IF var_aab019 = '60' THEN
         --获取社平工资
         num_spgz := xasi2.pkg_comm.fun_GetAvgSalary(prm_aae140,'16',prm_aae002,pkg_Constant.YAB003_JBFZX);
         --如果险种为工伤 缴费工资和缴费基数为社平工资
         
         IF substr(prm_aae002,1,4) >= 2019 THEN -- 19年后养老基数是社平的50%到300%
            IF prm_aae140 = PKG_Constant.AAE140_YL THEN
                IF num_aac040 > ROUND(num_spgz/12) THEN
                    prm_Yac004 := ROUND(num_spgz/12);
                ELSIF num_aac040 < TRUNC(num_spgz/24)+1 THEN
                    prm_Yac004 := TRUNC(num_spgz/24)+1;
                ELSE
                    prm_Yac004 := num_Aac040;
                END IF;
            END IF;
         ELSE
            IF prm_aae140 = PKG_Constant.AAE140_GS THEN
                prm_Yac004 := ROUND(num_spgz/12);
            END  IF;
            IF prm_aae140 = PKG_Constant.AAE140_JBYL THEN
                IF num_aac040 > ROUND(num_spgz/12) THEN
                    prm_Yac004 := ROUND(num_spgz/12);
                END  IF;
            END  IF;
            IF prm_aae140 = PKG_Constant.AAE140_YL THEN
                IF num_aac040 > ROUND(num_spgz/12) THEN
                    prm_Yac004 := ROUND(num_spgz/12);
                ELSIF num_aac040 < TRUNC(num_spgz/30)+1 THEN
                    prm_Yac004 := TRUNC(num_spgz/30)+1;
                ELSE
                    prm_Yac004 := num_Aac040;
                END IF;
            END IF;
         END IF;
         
      END IF;



      RETURN;
      /*处理失败*/
      <<label_ERROR>>
      NULL;
      /*关闭打开的游标*/
      IF cur_aa02a2%ISOPEN THEN
         CLOSE cur_aa02a2 ;
         prm_AppCode := Pre_Errcode||'getContributionBase01';
         prm_ErrMsg  := '获取保底封顶表出错 险种类型 = '||prm_Aae140||'  保底封顶类别 = '||var_yaa025||' 期号='||prm_Aae002||'  参保所属分中心='||prm_Yab139||'    '||SQLERRM;
         RETURN;
      END IF ;
   EXCEPTION
      WHEN OTHERS THEN
         IF cur_aa02a2%ISOPEN THEN
            CLOSE cur_aa02a2 ;
         END IF ;
         prm_AppCode := Pre_Errcode||'getContributionBase00';
         prm_ErrMsg  := '缴费工资封顶失败，失败原因：'||SQLERRM;
         RETURN;
   END prc_P_getContributionBase;

   /*****************************************************************************
   ** 过程名称 ：fun_P_getContributionBase
   ** 过程编号 ：12
   ** 业务环节 ：公共－缴费工资保底封顶
   ** 功能描述 ：缴费工资保底封顶
   ******************************************************************************
   **** 作    者：      作成日期 ：2009-05-06   版本编号 ：Ver 1.0.0
   ******************************************************************************
   ** 修    改：
   ******************************************************************************
   ** 备    注：prm_AppCode 构成是:过程编号（2位） ＋ 顺序号（2位）
   *****************************************************************************/
   --缴费工资保底封顶
   FUNCTION fun_P_getContributionBase
                              (prm_aac001       IN     xasi2.ac01.aac001%TYPE   ,     --个人编码
                               prm_aab001       IN     xasi2.ab01.aab001%TYPE   ,     --单位编码
                               prm_Aac040       IN     xasi2.ac02.aac040%TYPE   ,     --缴费工资
                               prm_YAC503       IN     xasi2.ac02.YAC503%TYPE   ,     --工资类别
                               prm_Aae140       IN     xasi2.ac02.aae140%TYPE   ,     --险种类型
                               prm_yac505       IN     xasi2.ac02.yac505%TYPE   ,     --缴费人员类别
                               prm_yab136       IN     xasi2.ab01.yab136%TYPE   ,     --单位管理类型（区别独立缴费人员）
                               prm_Aae002       IN     xasi2.ac08.aae002%TYPE   ,     --费款所属期
                               prm_Yab139       IN     xasi2.ac02.YAB139%TYPE   )     --参保分中心
   RETURN NUMBER
   IS
      var_procNo       VARCHAR2(4);  --过程序号
      num_Yac004       NUMBER(14,2); --缴费基数
      var_AppCode      VARCHAR2(18); --错误代码
      var_ErrMsg       VARCHAR2(300); --错误内容
   BEGIN
      /*初始化变量*/
      var_AppCode    := PKG_Constant.gn_def_OK ;
      var_ErrMsg     := ''                  ;
      var_procNo     := '12';
      --调用保底封顶过程
      BEGIN
          PKG_COMMON.prc_P_getContributionBase
                             (prm_aac001  ,   --个人编码
                              prm_aab001  ,   --单位编码
                              prm_Aac040  ,   --缴费工资
                              prm_YAC503  ,   --工资类别
                              prm_Aae140  ,   --险种类型
                              prm_yac505  ,   --缴费人员类别
                              prm_yab136  ,   --单位管理类型（区别独立缴费人员）
                              prm_Aae002  ,   --费款所属期
                              prm_Yab139  ,   --参保分中心
                              num_Yac004  ,   --缴费基数
                              var_AppCode ,   --错误代码
                              var_ErrMsg  );  --错误内容
         EXCEPTION
             WHEN OTHERS THEN
                RETURN -1;
      END ;
      IF var_AppCode != PKG_Constant.gn_def_OK THEN
          RETURN -1;
      END IF ;
      RETURN num_Yac004;
   EXCEPTION
      WHEN OTHERS THEN
          RETURN -1;
   END fun_P_getContributionBase;


   /*****************************************************************************
   ** 过程名称 fun_P_getYAE400xml
   ** 过程编号 ：12
   ** 业务环节 ：公共
   ** 功能描述 ：临时表XML数据封装
   ******************************************************************************
   **** 作    者：      作成日期 ：2009-05-06   版本编号 ：Ver 1.0.0
   ******************************************************************************
   ** 修    改：
   ******************************************************************************
   ** 备    注：prm_AppCode 构成是:过程编号（2位） ＋ 顺序号（2位）
   *****************************************************************************/
   --临时表XML数据封装
   PROCEDURE PRC_P_getYAE400xml(prm_iac001       IN     irac01.iac001%TYPE,
                                prm_yae399       IN     VARCHAR2          ,
                                PRM_yae400       OUT    SYS.XMLTYPE       ,
                                prm_AppCode      OUT    VARCHAR2          ,
                                prm_ErrorMsg     OUT    VARCHAR2          )      --个人编码
   IS
      rec_irac01       irac01%rowtype;
      var_yae400       clob          ;
   BEGIN
      prm_AppCode  := PKG_Constant.gn_def_OK;
      prm_ErrorMsg := '';

      /*初始化变量*/
      IF prm_iac001 IS NULL THEN
         prm_AppCode  :=  PKG_Constant.gn_def_ERR;
         prm_ErrorMsg := '参数不能为空!';
         RETURN;
      END IF;

      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      IF prm_yae399 = '01' THEN
         var_yae400 := '<employeeInsuranceVO>';
      END IF;
      IF prm_yae399 in('03','04') THEN
         var_yae400 :='<pauseAndContinueBatchVo>';
      END IF;

      var_yae400 := var_yae400||'<yac503><![CDATA[0]]></yac503>';
      var_yae400 := var_yae400||'<yac502><![CDATA['||rec_irac01.yac502||']]></yac502>';
      var_yae400 := var_yae400||'<yac505><![CDATA['||rec_irac01.yac505||']]></yac505>';
      var_yae400 := var_yae400||'<yac501><![CDATA['||rec_irac01.yac501||']]></yac501>';
      var_yae400 := var_yae400||'<yic067><![CDATA['||rec_irac01.yic067||']]></yic067>';
      var_yae400 := var_yae400||'<ykc174><![CDATA[]]></ykc174>';
      var_yae400 := var_yae400||'<yaa333><![CDATA['||rec_irac01.yaa333||']]></yaa333>';
      var_yae400 := var_yae400||'<yae407><![CDATA['||rec_irac01.yae407||']]></yae407>';
      var_yae400 := var_yae400||'<yab013><![CDATA['||rec_irac01.yab013||']]></yab013>';
      var_yae400 := var_yae400||'<aac020><![CDATA['||rec_irac01.aac020||']]></aac020>';
      var_yae400 := var_yae400||'<yae443><![CDATA[]]></yae443>';
      var_yae400 := var_yae400||'<yac002><![CDATA['||rec_irac01.yac002||']]></yac002>';
      var_yae400 := var_yae400||'<yac004><![CDATA['||rec_irac01.yac004||']]></yac004>';
      var_yae400 := var_yae400||'<aic162><![CDATA['||rec_irac01.aic162||']]></aic162>';
      var_yae400 := var_yae400||'<akc021><![CDATA['||rec_irac01.akc021||']]></akc021>';
      var_yae400 := var_yae400||'<aae036><![CDATA['||to_char(rec_irac01.aae036,'yyyy-MM-dd')||']]></aae036>';
      var_yae400 := var_yae400||'<yae181><![CDATA['||rec_irac01.yae181||']]></yae181>';--身份证
      var_yae400 := var_yae400||'<yac170><![CDATA['||rec_irac01.yac170||']]></yac170>';
      var_yae400 := var_yae400||'<zyj><![CDATA[]]></zyj>';--逐月缴费人员
      var_yae400 := var_yae400||'<yad050><![CDATA[]]></yad050>';
      var_yae400 := var_yae400||'<aae140_02><![CDATA['||rec_irac01.aae210||']]></aae140_02>';
      var_yae400 := var_yae400||'<aae140_03><![CDATA['||rec_irac01.aae310||']]></aae140_03>';
      var_yae400 := var_yae400||'<aae140_04><![CDATA['||rec_irac01.aae410||']]></aae140_04>';
      var_yae400 := var_yae400||'<aae140_05><![CDATA['||rec_irac01.aae510||']]></aae140_05>';
      var_yae400 := var_yae400||'<aae140_06><![CDATA['||rec_irac01.aae120||']]></aae140_06>';
      var_yae400 := var_yae400||'<aae140_07><![CDATA['||rec_irac01.aae311||']]></aae140_07>';
      var_yae400 := var_yae400||'<aae140_08><![CDATA['||rec_irac01.aae810||']]></aae140_08>';
      var_yae400 := var_yae400||'<yac033><![CDATA['||to_char(rec_irac01.yac033,'yyyy-MM-dd')||']]></yac033>';
      var_yae400 := var_yae400||'<aac030><![CDATA['||to_char(rec_irac01.aac030,'yyyy-MM-dd')||']]></aac030>';

      IF prm_yae399 = '04' THEN
         var_yae400 := var_yae400||'<yae102><![CDATA['||to_char(rec_irac01.aac030,'yyyy-MM-dd')||']]></yae102>';--续保日期
      END IF;
       
      IF prm_yae399 = '03' THEN
       -- modify by wanghm 20190521 start 高新停保日期为申报月1号 不符合市上停保日期规则
       -- var_yae400 := var_yae400||'<yae102><![CDATA['||to_char(rec_irac01.aac030,'yyyy-MM-dd')||']]></yae102>';--停保日期
        var_yae400 := var_yae400||'<yae102><![CDATA['||to_char(rec_irac01.yae102,'yyyy-MM-dd')||']]></yae102>';--停保日期
       -- modify by wanghm 20190521 end
      END IF;

      IF prm_yae399 = '01' THEN
         var_yae400 := var_yae400||'<yae102><![CDATA['||rec_irac01.yae102||']]></yae102>';
      END IF;

      var_yae400 := var_yae400||'<yab003><![CDATA['||rec_irac01.yab003||']]></yab003>';
      var_yae400 := var_yae400||'<aac031><![CDATA['||rec_irac01.aac031||']]></aac031>';
      var_yae400 := var_yae400||'<aac004><![CDATA['||rec_irac01.aac004||']]></aac004>';
      var_yae400 := var_yae400||'<aac003><![CDATA['||rec_irac01.aac003||']]></aac003>';
      var_yae400 := var_yae400||'<yac200><![CDATA['||rec_irac01.yac200||']]></yac200>';
      var_yae400 := var_yae400||'<aab001><![CDATA['||rec_irac01.aab001||']]></aab001>';
      var_yae400 := var_yae400||'<aac006><![CDATA['||to_char(rec_irac01.aac006,'yyyy-MM-dd')||']]></aac006>';
      var_yae400 := var_yae400||'<aac005><![CDATA['||rec_irac01.aac005||']]></aac005>';
      var_yae400 := var_yae400||'<aac008><![CDATA['||rec_irac01.aac008||']]></aac008>';
      var_yae400 := var_yae400||'<aac007><![CDATA['||to_char(rec_irac01.aac007,'yyyy-MM-dd')||']]></aac007>';
      var_yae400 := var_yae400||'<ykc150><![CDATA['||rec_irac01.ykc150||']]></ykc150>';
      var_yae400 := var_yae400||'<aac009><![CDATA['||rec_irac01.aac009||']]></aac009>';
      var_yae400 := var_yae400||'<ykb109><![CDATA[0]]></ykb109>'; --不享受公务员统筹待遇
      var_yae400 := var_yae400||'<aae009><![CDATA['||rec_irac01.aae009||']]></aae009>';
      var_yae400 := var_yae400||'<aae008><![CDATA['||rec_irac01.aae008||']]></aae008>';

      IF rec_irac01.aac009 = '20' THEN
         var_yae400 := var_yae400||'<yac168><![CDATA[1]]></yac168>'; --农民工
      ElSE
         var_yae400 := var_yae400||'<yac168><![CDATA[0]]></yac168>';
      END IF;

      var_yae400 := var_yae400||'<yae496><![CDATA['||rec_irac01.yae496||']]></yae496>';
      var_yae400 := var_yae400||'<aae007><![CDATA['||rec_irac01.aae007||']]></aae007>';
      var_yae400 := var_yae400||'<aae006><![CDATA['||rec_irac01.aae006||']]></aae006>';
      var_yae400 := var_yae400||'<aae005><![CDATA['||rec_irac01.aae005||']]></aae005>';
      var_yae400 := var_yae400||'<aac040><![CDATA['||rec_irac01.aac040||']]></aac040>';
      var_yae400 := var_yae400||'<aac040_04><![CDATA['||rec_irac01.aac040||']]></aac040_04>';
      var_yae400 := var_yae400||'<aac040_06><![CDATA['||rec_irac01.yac004||']]></aac040_06>';
      var_yae400 := var_yae400||'<aae004><![CDATA['||rec_irac01.aae004||']]></aae004>';
      var_yae400 := var_yae400||'<ykc003><![CDATA[]]></ykc003>';--视同缴费月数
      var_yae400 := var_yae400||'<yab139><![CDATA['||rec_irac01.yab139||']]></yab139>';
      var_yae400 := var_yae400||'<yac067><![CDATA['||rec_irac01.yac067||']]></yac067>';
      var_yae400 := var_yae400||'<aac001><![CDATA['||rec_irac01.aac001||']]></aac001>';
      var_yae400 := var_yae400||'<aac002><![CDATA['||rec_irac01.aac002||']]></aac002>';
      var_yae400 := var_yae400||'<aac015><![CDATA['||rec_irac01.aac015||']]></aac015>';
      var_yae400 := var_yae400||'<aac014><![CDATA['||rec_irac01.aac014||']]></aac014>';
      var_yae400 := var_yae400||'<yac197><![CDATA['||rec_irac01.yac197||']]></yac197>';
      var_yae400 := var_yae400||'<aae013><![CDATA['||rec_irac01.aae013||']]></aae013>';
      var_yae400 := var_yae400||'<aae010><![CDATA['||rec_irac01.aae010||']]></aae010>';
      var_yae400 := var_yae400||'<aae011><![CDATA['||rec_irac01.aae011||']]></aae011>';
      var_yae400 := var_yae400||'<yae222><![CDATA['||rec_irac01.yae222||']]></yae222>';
      var_yae400 := var_yae400||'<ykc120><![CDATA[]]></ykc120>';--医疗照顾人员类别
      var_yae400 := var_yae400||'<yae097><![CDATA['||rec_irac01.yae097||']]></yae097>';
      var_yae400 := var_yae400||'<aac012><![CDATA['||rec_irac01.aac012||']]></aac012>';

      IF rec_irac01.aac009 = '20' THEN
         var_yae400 := var_yae400||'<aac013><![CDATA[3]]></aac013>';
      ElSE
         var_yae400 := var_yae400||'<aac013><![CDATA[2]]></aac013>';
      END IF;

      var_yae400 := var_yae400||'<aac010><![CDATA['||rec_irac01.aac010||']]></aac010>';
      var_yae400 := var_yae400||'<aac011><![CDATA['||rec_irac01.aac011||']]></aac011>';
      var_yae400 := var_yae400||'<aac021><![CDATA['||to_char(rec_irac01.aac021,'yyyy-MM-dd')||']]></aac021>';
      var_yae400 := var_yae400||'<aac022><![CDATA['||rec_irac01.aac022||']]></aac022>';

      IF prm_yae399 = '01' THEN
         var_yae400 := var_yae400||'</employeeInsuranceVO>';
      END IF;
      IF prm_yae399 in('03','04') THEN
         var_yae400 := var_yae400||'</pauseAndContinueBatchVo>';
      END IF;

      PRM_yae400 := SYS.XMLTYPE.createXML(var_yae400);
      --insert into foo(itime,msg) values(sysdate,var_yae400);

    EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*关闭打开的游标*/
         prm_AppCode  :=  PKG_Constant.gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| PRE_ERRCODE || SQLERRM ;
         RETURN;
   END PRC_P_getYAE400xml;

    --临时表XML数据封装
   PROCEDURE PRC_P_insertAe16Tmp(prm_yae099       IN    VARCHAR2   ,    --业务流水号
                                 prm_iac001       IN     irac01.iac001%TYPE,
                                 prm_yae399       IN     VARCHAR2          ,
                                 prm_aab001       IN     irac01.aab001%TYPE,
                                 prm_aae011       IN     iraa02.iaa011%TYPE,--经办人
                                 prm_AppCode      OUT    VARCHAR2          ,
                                 prm_ErrorMsg     OUT    VARCHAR2          )
   IS
      var_yae400    sys.xmltype;
      var_yae202    VARCHAR2(30);
      num_count     NUMBER;
      rec_irac01    irac01%rowtype;

      var_aac001    ac01.aac001%type;
      var_aac002    ac01.aac002%type;
      var_aac003    ac01.aac003%type;

   begin
      var_yae400   := null;
      prm_appcode  := PKG_Constant.gn_def_OK;
      prm_ErrorMsg := '';

      SELECT *
        INTO rec_irac01
        FROM wsjb.IRAC01
       WHERE IAC001 = prm_iac001;

      --modify by fenggg at 21080910 begin  没有个人编号生成个人编号
      IF prm_yae399 = '04' THEN
         var_aac001 := rec_irac01.aac001;
         BEGIN
           SELECT aac002,
                  aac003
             INTO var_aac002,
                  var_aac003
             FROM irac01
            WHERE iac001 = prm_iac001;
         EXCEPTION
           WHEN OTHERS THEN
                var_aac002 := '0';
                var_aac003 := '0';
                goto end_label;
         END;

         SELECT COUNT(1)
           INTO num_count
           FROM xasi2.ac01
          WHERE aac002 = var_aac002
            AND aac003 = var_aac003;
         IF num_count = 0 THEN
            var_aac001 := xasi2.pkg_comm.fun_GetSequence(NULL,'aac001');

            INSERT INTO ac01
              (aac001, -- 个人编号
               yae181, -- 证件类型
               aac002, -- 身份证号码(证件号码)
               aac003, -- 姓名
               aac004, -- 性别
               aac005, -- 民族
               aac006, -- 出生日期
               aac007, -- 参加工作日期
               aac008, -- 人员状态
               aac009, -- 户口性质
               aac010, -- 户籍地址
               aac011, -- 学历
               aac021, -- 毕业日期
               aac022, -- 毕业院校
               aac013, -- 用工形式
               yac067, -- 来源方式
               yac168, -- 农民工标志
               aae005, -- 联系电话
               aae006, -- 地址
               aae007, --邮政编码
               aae011, -- 经办人
               aae036, -- 经办时间
               aae120, -- 注销标志
               yac200)
              SELECT var_aac001, -- 个人编号
                     yae181, -- 证件类型
                     aac002, -- 身份证号码(证件号码)
                     aac003, -- 姓名
                     aac004, -- 性别
                     aac005, -- 民族
                     aac006, -- 出生日期
                     aac007, -- 参加工作日期
                     aac008, -- 人员状态
                     aac009, -- 户口性质
                     aac010, -- 户籍地址
                     aac011, -- 学历
                     aac021, -- 毕业日期
                     aac022, -- 毕业院校
                     aac013, -- 用工形式
                     yac067, -- 来源方式
                     yac168, -- 农民工标志
                     aae005, -- 联系电话
                     aae006, -- 地址
                     aae007, --邮政编码
                     aae011, -- 经办人
                     aae036, -- 经办时间
                     aae120, -- 注销标志
                     yac200
                FROM wsjb.irac01
               where iac001 = rec_irac01.iac001;

            --生成个人编号后，先更新irac01，后续要用到
             UPDATE wsjb.irac01
                SET aac001=var_aac001
              WHERE iac001=rec_irac01.iac001;

         END IF;
      END IF;

      <<end_label>>
        null;
      --modify by fenggg at 21080910 end  没有个人编号生成个人编号

      PKG_COMMON.PRC_P_getYAE400xml(prm_iac001,
                                    prm_yae399,
                                    var_yae400,
                                    prm_appcode,
                                    prm_errormsg);
      IF prm_appcode <> PKG_Constant.gn_def_OK THEN
          RETURN;
      END IF ;

      IF prm_yae399 = '01' THEN
         DELETE FROM xasi2.ae16
          WHERE aab001 = rec_irac01.aab001
            AND yab003 = PKG_Constant.YAB003_JBFZX
            AND YAE031 = '0'                       --未审核
            AND YAE399 = '24';                     --网上申报新参保
      END IF;

      INSERT INTO XASI2.AE16(YAE099,
                                AAB001,
                                YAE399,
                                YAB139,
                                AAE011,
                                AAE036,
                                YAB003,
                                YAE031,
                                YAE032,
                                YAE033)
                         values(prm_yae099,
                                prm_aab001,
                                prm_yae399,
                                PKG_Constant.YAB003_JBFZX,
                                prm_aae011,
                                SYSDATE,
                                PKG_Constant.YAB003_JBFZX,
                                '0',
                                prm_aae011,
                                SYSDATE);


      var_yae202:= xasi2.PKG_comm.fun_GetSequence(NULL,'yae202');
      IF var_yae202 IS NULL OR var_yae202 = '' THEN
         prm_AppCode  := PKG_Constant.gn_def_ERR;
         prm_ErrorMsg := PRE_ERRCODE ||'没有获取到系统库的序列号:yae202';
         RETURN;
      END IF;

      --批量新参保
      IF prm_yae399 = '01' THEN
         INSERT INTO XASI2.AE16A1(YAE099,
                                     YAE202,
                                     YAE400,
                                     AAD052,
                                     AAD053,
                                     AAD054,
                                     AAD055,
                                     AAD056,
                                     AAD057,
                                     AAD058,
                                     AAD059,
                                     YAE235,
                                     YAE238)
                              values(prm_yae099,
                                     var_yae202,
                                     var_yae400,
                                     'aab001',
                                     prm_aab001,
                                     'aac002',
                                     rec_irac01.aac002,
                                     'aac003',
                                     rec_irac01.aac003,
                                     'aac001',
                                     '',
                                     '0',
                                     '');

      END IF;
      --批量续保
      IF prm_yae399 = '04' THEN

         INSERT INTO XASI2.AE16A1(YAE099,
                                     YAE202,
                                     YAE400,
                                     AAD052,
                                     AAD053,
                                     AAD054,
                                     AAD055,
                                     AAD065,
                                     YAE235,
                                     YAE238)
                              values(prm_yae099,
                                     var_yae202,
                                     var_yae400,
                                     'aab001',
                                     prm_aab001,
                                     'aac001',
                                     var_aac001,
                                     '网上经办',--标志
                                     '0',
                                     '');

      END IF;
      --批量暂停
      IF prm_yae399 = '03' THEN
         INSERT INTO XASI2.AE16A1(YAE099,
                                    YAE202,
                                     YAE400,
                                     AAD052,
                                     AAD053,
                                     AAD054,
                                     AAD055,
                                     YAE235,
                                     YAE238)
                              values(prm_yae099,
                                     var_yae202,
                                     var_yae400,
                                     'aab001',
                                     prm_aab001,
                                     'aac001',
                                     rec_irac01.aac001,
                                     '0',
                                     '');

      END IF;

      IF ((prm_yae399 = '01' and rec_irac01.aae210 = '1') or
          (prm_yae399 = '04' and (rec_irac01.aae210 = '1' or rec_irac01.aae210 = '10'))or
          (prm_yae399 = '03' and rec_irac01.aae210 = '3')) THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--个人编码-->
                                         aab001,--单位编码 -->
                                         aae140,--险种-->
                                         yab139 --参保分中心-->
                                         )
                                  VALUES (prm_yae099       ,--个人编码-->
                                          rec_irac01.aab001, --单位编码 -->
                                          '02', --险种-->
                                          PKG_Constant.YAB003_JBFZX  --参保分中心-->
                                         );
      END IF;
      IF ((prm_yae399 = '01' and rec_irac01.aae310 = '1') or
          (prm_yae399 = '04' and (rec_irac01.aae310 = '1' or rec_irac01.aae310 = '10'))or
          (prm_yae399 = '03' and rec_irac01.aae310 = '3')) THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--个人编码-->
                                         aab001,--单位编码 -->
                                         aae140,--险种-->
                                         yab139 --参保分中心-->
                                         )
                                  VALUES (prm_yae099       ,--个人编码-->
                                          rec_irac01.aab001, --单位编码 -->
                                          '03', --险种-->
                                          PKG_Constant.YAB003_JBFZX  --参保分中心-->
                                         );
      END IF;
      IF ((prm_yae399 = '01' and rec_irac01.aae410 = '1') or
          (prm_yae399 = '04' and (rec_irac01.aae410 = '1' or rec_irac01.aae410 = '10'))or
          (prm_yae399 = '03' and rec_irac01.aae410 = '3')) THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--个人编码-->
                                         aab001,--单位编码 -->
                                         aae140,--险种-->
                                         yab139 --参保分中心-->
                                         )
                                  VALUES (prm_yae099       ,--个人编码-->
                                          rec_irac01.aab001, --单位编码 -->
                                          '04', --险种-->
                                          PKG_Constant.YAB003_JBFZX  --参保分中心-->
                                         );
      END IF;
      IF ((prm_yae399 = '01' and rec_irac01.aae510 = '1') or
          (prm_yae399 = '04' and (rec_irac01.aae510 = '1' or rec_irac01.aae510 = '10'))or
          (prm_yae399 = '03' and rec_irac01.aae510 = '3')) THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--个人编码-->
                                         aab001,--单位编码 -->
                                         aae140,--险种-->
                                         yab139 --参保分中心-->
                                         )
                                  VALUES (prm_yae099       ,--个人编码-->
                                          rec_irac01.aab001, --单位编码 -->
                                          '05', --险种-->
                                          PKG_Constant.YAB003_JBFZX  --参保分中心-->
                                         );
      END IF;
      IF ((prm_yae399 = '01' and rec_irac01.aae311 = '1') or
          (prm_yae399 = '04' and (rec_irac01.aae311 = '1' or rec_irac01.aae311 = '10'))or
          (prm_yae399 = '03' and rec_irac01.aae311 = '3')) THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--个人编码-->
                                         aab001,--单位编码 -->
                                         aae140,--险种-->
                                         yab139 --参保分中心-->
                                         )
                                  VALUES (prm_yae099       ,--个人编码-->
                                          rec_irac01.aab001, --单位编码 -->
                                          '07', --险种-->
                                          PKG_Constant.YAB003_JBFZX  --参保分中心-->
                                         );
      END IF;
      IF ((prm_yae399 = '01' and rec_irac01.aae120 = '1') or
          (prm_yae399 = '04' and (rec_irac01.aae120 = '1' or rec_irac01.aae120 = '10'))or
          (prm_yae399 = '03' and rec_irac01.aae120 = '3')) THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--个人编码-->
                                         aab001,--单位编码 -->
                                         aae140,--险种-->
                                         yab139 --参保分中心-->
                                         )
                                  VALUES (prm_yae099       ,--个人编码-->
                                          rec_irac01.aab001, --单位编码 -->
                                          '06', --险种-->
                                          PKG_Constant.YAB003_JBFZX  --参保分中心-->
                                         );
      END IF;
      IF ((prm_yae399 = '01' and rec_irac01.aae810 = '1') or
          (prm_yae399 = '04' and (rec_irac01.aae810 = '1' or rec_irac01.aae810 = '10'))or
          (prm_yae399 = '03' and rec_irac01.aae810 = '3')) THEN
         INSERT INTO XASI2.TMP_AAE140(yae099,--个人编码-->
                                         aab001,--单位编码 -->
                                         aae140,--险种-->
                                         yab139 --参保分中心-->
                                         )
                                  VALUES (prm_yae099       ,--个人编码-->
                                          rec_irac01.aab001, --单位编码 -->
                                          '08', --险种-->
                                          PKG_Constant.YAB003_JBFZX  --参保分中心-->
                                         );
      END IF;
    EXCEPTION
      -- WHEN NO_DATA_FOUND THEN
      -- WHEN TOO_MANY_ROWS THEN
      -- WHEN DUP_VAL_ON_INDEX THEN
      WHEN OTHERS THEN
         /*关闭打开的游标*/
         prm_AppCode  :=  PKG_Constant.gn_def_ERR;
         prm_ErrorMsg := '数据库错误:'|| PRE_ERRCODE || SQLERRM ;
         RETURN;
   END PRC_P_insertAe16Tmp;

      --获取参保档案编号流水号
 FUNCTION fun_cbbh(prm_iaa011  IN irad01.iaa011%TYPE,
                   prm_yab003  IN irad01.YAB003%TYPE
                  )
   RETURN varchar2
   AS
      cb_dabh   varchar2(300);
   BEGIN

      IF prm_iaa011 = 'DWKH' THEN
         SELECT SEQ_DWKH001.NEXTVAL INTO cb_dabh FROM DUAL;
         cb_dabh := SUBSTR(TO_CHAR(SYSDATE,'YYYY-MM-DD'),0,4)||'-GL(DWKH)-Y-'||SUBSTR(cb_dabh,2,9);
       ELSIF prm_iaa011 = 'DWBG' THEN
         SELECT SEQ_DWBG001.NEXTVAL INTO cb_dabh FROM DUAL;
         cb_dabh := SUBSTR(TO_CHAR(SYSDATE,'YYYY-MM-DD'),0,4)||'-GL(DWBG)-Y-'||SUBSTR(cb_dabh,2,9);
      ELSIF prm_iaa011 = 'GRZY1' THEN
         SELECT SEQ_GRZY001.NEXTVAL INTO cb_dabh FROM DUAL;
         cb_dabh := SUBSTR(TO_CHAR(SYSDATE,'YYYY-MM-DD'),0,4)||'-GL(GRZY1)-100-'||SUBSTR(cb_dabh,2,9);
      ELSIF prm_iaa011 = 'GRZY2' THEN
         SELECT SEQ_GRZY002.NEXTVAL INTO cb_dabh FROM DUAL;
         cb_dabh := SUBSTR(TO_CHAR(SYSDATE,'YYYY-MM-DD'),0,4)||'-GL(GRZY2)-100-'||SUBSTR(cb_dabh,2,9);
      ELSIF prm_iaa011 = 'GRBG' THEN
         SELECT SEQ_GRBG001.NEXTVAL INTO cb_dabh FROM DUAL;
         cb_dabh := SUBSTR(TO_CHAR(SYSDATE,'YYYY-MM-DD'),0,4)||'-GL(GRBG)-100-'||SUBSTR(cb_dabh,2,9);
      ELSIF prm_iaa011 = 'DWYB' THEN
         SELECT SEQ_DWYB001.NEXTVAL INTO cb_dabh FROM DUAL;
         cb_dabh := SUBSTR(TO_CHAR(SYSDATE,'YYYY-MM-DD'),0,4)||'-ZJ(DWYB)-100-'||SUBSTR(cb_dabh,2,9);
      ELSIF prm_iaa011 = 'JSSB' THEN
         SELECT SEQ_JSSB001.NEXTVAL INTO cb_dabh FROM DUAL;
         cb_dabh := SUBSTR(TO_CHAR(SYSDATE,'YYYY-MM-DD'),0,4)||'-ZJ(JSSB)-100-'||SUBSTR(cb_dabh,2,9);
      ELSIF prm_iaa011 = 'BJ' THEN
         SELECT SEQ_BJ001.NEXTVAL INTO cb_dabh FROM DUAL;
         cb_dabh := SUBSTR(TO_CHAR(SYSDATE,'YYYY-MM-DD'),0,4)||'-ZJ(BJ)-100-'||SUBSTR(cb_dabh,2,9);
      ELSIF prm_iaa011 = 'DWZX' THEN
         SELECT SEQ_DWZX001.NEXTVAL INTO cb_dabh FROM DUAL;
         cb_dabh := SUBSTR(TO_CHAR(SYSDATE,'YYYY-MM-DD'),0,4)||'-GL(DWZX)-Y-'||SUBSTR(cb_dabh,2,9);
      END IF;
      RETURN cb_dabh;
   EXCEPTION
        WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR('-20001','生成管理类编号出错!');
         RETURN null;
   END fun_cbbh;

end PKG_COMMON;
/
