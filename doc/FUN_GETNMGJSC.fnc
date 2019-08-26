CREATE OR REPLACE FUNCTION FUN_GETNMGJSC(prm_aab001 VARCHAR2,prm_aae001 NUMBER)
    RETURN NUMBER AS
    v_aac001 VARCHAR2(15);
    num_count NUMBER;
    num_aac040 NUMBER; --新基数
    num_yac004 ab08.aab121%TYPE;   --差额
    num_sum004 ab08.aab121%TYPE;   --总差额 传出参数
    num_yaa333 ab08.aab121%TYPE;   --差额
    var_yae001 xasi2.ac01k8.yae001%TYPE;
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
    num_yac412   tmp_ac42.yac401%TYPE;           --12月补差金额,NUMBER
    num_aae002   ab08.aae003%TYPE;


    CURSOR cur_ac01 IS
     SELECT DISTINCT aac001
       FROM TMP_AC42
      WHERE aab001 = prm_aab001
        AND aae001 = prm_aae001
        AND aae140 = '02';

    CURSOR cur_ac08 IS
    SELECT aae002,
           aae180,
           yac505
      FROM ac08
     WHERE aac001 = v_aac001   --个人编号  传入参数
       AND aae140 = '02'   --险种     传入参数
       AND aae143 IN ('01','03')
       AND aae002 >= (SELECT aae041 FROM xasi2.AA02A3 WHERE aae140 = '02' AND aae001 = prm_aae001)   --开始期号  传入参数
       AND aab001 = prm_aab001    --单位编号 传入参数
   UNION
   SELECT aae002,
           aae180,
           yac505
      FROM ac08a1
     WHERE aac001 = v_aac001
       AND aae140 = '02'
       AND aae143 IN ('01','03')
       AND aae002 >=  (SELECT aae041 FROM xasi2.AA02A3 WHERE aae140 = '02' AND aae001 = prm_aae001)
       AND aab001 = prm_aab001;



BEGIN
  num_sum004 :=0;
  FOR rec_ac01 IN cur_ac01 LOOP
    v_aac001 := rec_ac01.aac001;

     SELECT COUNT(1)
        INTO num_count
        FROM ac02
       WHERE aac001 = v_aac001
         AND aae140 = '02'
         AND aac031 = '2';
      IF num_count > 0 then

       --年审后暂停人员也要计算
        select count(1)
          into num_count
          from wsjb.irac01
         where aac001 = v_aac001
           and aae210 = '3'
           and iaa100 >= (select aae003 from wsjb.irad51 where aab001 = prm_aab001 and aae001 = prm_aae001);

        if num_count> 0 then
           num_count :=0;
        end if;

      END IF;
      IF num_count < 1 THEN
          num_yac004 :=0;
         SELECT yaa333,
                yae001
           INTO num_aac040,
                var_yae001
           FROM xasi2.ac01k8
          WHERE aab001 = prm_aab001
            AND aac001 = v_aac001
            AND aae001 = prm_aae001
            AND yab019 = '1'
            AND (aae013 is null or aae013 ='1'  or aae013 ='2' or aae013 ='22');


         SELECT yac401,           --1月补差金额,NUMBER
                yac402,           --2月补差金额,NUMBER
                yac403,           --3月补差金额,NUMBER
                yac404,           --4月补差金额,NUMBER
                yac405,           --5月补差金额,NUMBER
                yac406,           --6月补差金额,NUMBER
                yac407,           --7月补差金额,NUMBER
                yac408,           --8月补差金额,NUMBER
                yac409,           --9月补差金额,NUMBER
                yac410,           --10月补差金额,NUMBER
                yac411,           --11月补差金额,NUMBER
                yac412            --12月补差金额,NUMBER
           INTO num_yac401,          --1月补差金额,NUMBER
                num_yac402,          --2月补差金额,NUMBER
                num_yac403,          --3月补差金额,NUMBER
                num_yac404,          --4月补差金额,NUMBER
                num_yac405,          --5月补差金额,NUMBER
                num_yac406,          --6月补差金额,NUMBER
                num_yac407,          --7月补差金额,NUMBER
                num_yac408,          --8月补差金额,NUMBER
                num_yac409,          --9月补差金额,NUMBER
                num_yac410,          --10月补差金额,NUMBER
                num_yac411,          --11月补差金额,NUMBER
                num_yac412           --12月补差金额,NUMBER
           FROM TMP_AC42
          WHERE aac001 = v_aac001
            AND aae001 = prm_aae001
            AND aae140 = '02'
            AND aab001 = prm_aab001;

         FOR rec_ac08 IN cur_ac08 LOOP
             num_aae002 := rec_ac08.aae002;
             IF rec_ac08.yac505 = '021' THEN
                num_yaa333 := num_aac040 - rec_ac08.aae180;
                IF var_yae001 = '是' THEN
                   IF num_aae002 = prm_aae001||'01' THEN
                      num_yaa333 := num_yac401;
                   END IF;

                   IF num_aae002 = prm_aae001||'02' THEN
                      num_yaa333 := num_yac402;
                   END IF;

                   IF num_aae002 = prm_aae001||'03' THEN
                      num_yaa333 := num_yac403;
                   END IF;

                   IF num_aae002 = prm_aae001||'04' THEN
                      num_yaa333 := num_yac404;
                   END IF;

                   IF num_aae002 = prm_aae001||'05' THEN
                      num_yaa333 := num_yac405;
                   END IF;

                   IF num_aae002 = prm_aae001||'06' THEN
                      num_yaa333 := num_yac406;
                   END IF;

                   IF num_aae002 = prm_aae001||'07' THEN
                      num_yaa333 := num_yac407;
                   END IF;

                   IF num_aae002 = prm_aae001||'08' THEN
                      num_yaa333 := num_yac408;
                   END IF;

                   IF num_aae002 = prm_aae001||'09' THEN
                      num_yaa333 := num_yac409;
                   END IF;

                   IF num_aae002 = prm_aae001||'10' THEN
                      num_yaa333 := num_yac410;
                   END IF;

                   IF num_aae002 = prm_aae001||'11' THEN
                      num_yaa333 := num_yac411;
                   END IF;

                   IF num_aae002 = prm_aae001||'12' THEN
                      num_yaa333 := num_yac412;
                   END IF;
                END IF;
                num_yac004 := num_yac004 + num_yaa333;
             END IF;
         END LOOP;
         num_sum004 := num_sum004 + num_yac004;

      END IF;

  END LOOP;

  RETURN num_sum004;

END;
/
