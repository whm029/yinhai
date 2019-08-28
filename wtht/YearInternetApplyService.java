package com.yinhai.nethall.company.yearApply.service;

import com.yinhai.sysframework.exception.AppException;
import com.yinhai.sysframework.service.WsService;

import javax.jws.WebService;

@WebService
public interface YearInternetApplyService extends WsService {

	/**
	 * 年审页面初始化检查
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String checkYearApply(String map2Xml) throws AppException;

	/**
	 * 查询人员基数信息
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String queryEmps(String map2Xml) throws AppException;

	/**
	 * 更新基数
	 *
	 * @param map2Xml
	 * @throws AppException
	 */
	public String updateYac004(String map2Xml) throws AppException;

	/*
	 * 支持分页查询
	 */
	public String queryByPage(String map2XmlWithPage) throws AppException;

	/*
	 * 文件下载
	 */
	public String getfile(String map2Xml) throws AppException;

	/**
	 * 检查能否提交申请
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String checkIsApply(String map2Xml) throws AppException;

	/**
	 * 年度基数申报
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String updateApply(String map2Xml) throws AppException;

	/**
	 * 年审申请撤销
	 *
	 * @param map2Xml
	 * @throws AppException
	 */
	public String updateCancel(String map2Xml) throws AppException;

	/**
	 * 查看个人补差缴费信息
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String getPerInfo(String map2Xml) throws Exception;

	/**
	 * 查看单位补差缴费信息
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String getPerView(String map2Xml) throws AppException;

	/**
	 * 批量更新工资
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String updatePLab05a1(String map2Xml) throws AppException;

	/**
	 * 导出人员excel
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String getExportData(String map2Xml) throws AppException;

	public String get51count_1(String map2Xml) throws AppException;

	public String getAb05a1(String map2Xml) throws AppException;

	/**
	 * 查询单位信息
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String queryUnitInfo(String map2Xml) throws AppException;

	/**
	 * 查询险种实际补差list
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String queryBcList(String map2Xml) throws AppException;

	/**
	 * 查询人员基数申报信息
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String getEmpJSInfo(String map2Xml) throws AppException;

	/**
	 * 查询单位基数汇总信息
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String getUnitJSInfo(String map2Xml) throws AppException;

	/**
	 * 查询年审单位信息
	 *
	 * @param xml
	 * @return
	 * @throws AppException
	 */
	public String getWorkerInfo(String xml) throws AppException;

	/**
	 * 查询年审补差数据
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String getInsPayBCInfo(String map2Xml) throws AppException;

	/**
	 * 获取补差工伤比例
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String getAla080(String map2Xml) throws AppException;

	/**
	 * 查询预览导出数据
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String getYearApplyExportData(String map2Xml) throws AppException;

	/**
	 * 调用养老接口
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String insertYLJK(String map2Xml) throws AppException;

	/**
	 * 是否为重点核查单位
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public int getIrad54Count(String map2Xml) throws AppException;

	/**
	 * -------------------------------------<br>
	 *
	 * @title: getIrad54_1Count
	 * @description: 是否是基数降低超出比例单位
	 * @return: int
	 * @date: 2019/8/14 0:33
	 * @A19 -------------------------------------<br>
	 */
	public int getIrad54_1Count(String map2Xml) throws AppException;

	/**
	 * 数据清除
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String deleteClear(String map2Xml) throws AppException;

	public int getIrad56Count(String map2Xml) throws AppException;

	/**
	 * 查询二次补差list
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String querySecondBcList(String map2Xml) throws AppException;

	/**
	 * 查询年审二次补差数据
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String getInsPaySecondBCInfo(String map2Xml) throws AppException;

	/**
	 * 查询二次补差人员列表
	 *
	 * @param map2Xml
	 * @return
	 * @throws AppException
	 */
	public String getAc02List(String map2Xml) throws AppException;

	/**
	 * -------------------------------------<br>
	 *
	 * @title: getConfirmTip
	 * @description: 查询承诺书
	 * @return: java.lang.String
	 * @date: 2019/8/6 16:01
	 * @A19 -------------------------------------<br>
	 */
	public String getConfirmTip(String map2Xml) throws AppException;

	/**
	 * -------------------------------------<br>
	 *
	 * @title: insertConfirmTip
	 * @description: 写入承诺书
	 * @return: java.lang.String
	 * @date: 2019/8/6 17:54
	 * @A19 -------------------------------------<br>
	 */
	public String insertConfirmTip(String map2Xml) throws AppException;

	/**-------------------------------------<br>
	 * @title: checkAac040
	 * @description: 查看是有存在未填写新缴费工资的人
	 * @return: java.lang.String
	 * @date: 2019/8/25 22:17
	 * @A19
	 * -------------------------------------<br>
	 */
	public String checkAac040(String map2Xml) throws AppException;


}