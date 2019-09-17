package com.yinhai.gxdatasync.util;

import com.yinhai.sysframework.exception.AppException;
import com.yinhai.sysframework.util.ValidateUtil;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;

import java.io.Reader;
import java.io.StringReader;
import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.util.*;

public class GxDataSyncUtil {

   /**
	* @Title: mapToObject 
	* @Description: map转object 把map中的数据填充到object
	* 				目前转换类型有String、Long、Date、Integer、BigDecimal 有其他需要可以再添加
	* 				传进参数map和domain对象
	* 				例如:ac01domain
	* @param @param map
	* @param @param obj
	* @param @return 
	* @return Object
	* @throws 
	*/
	public static Object mapToObject(Map map , Object obj) throws Exception{
		
		if(ValidateUtil.isEmpty(map)){
			return null;
		}
		Field[] fields =  getFields(obj);
		//循环设置每个属性的值
		for(Field f : fields){
			//设置属性访问权限
			f.setAccessible(true); 
			//字段类型
			String type = f.getType().getName();
			Object value = (map.get(f.getName())==null 
							&& "".equals(map.get(f.getName()))) 
							? null 
							: map.get(f.getName());
			if(!ValidateUtil.isEmpty(value)){
				//判断字段类型
				if(type.equals(String.class.getName())){//String 类型
					f.set(obj, String.valueOf(value).trim()); 
				}else if(type.equals(Long.class.getName())){//Long 类型
					f.set(obj, Long.valueOf(value.toString())); 
				}else if(type.equals(Integer.class.getName())){//Integer 类型
					f.set(obj, Integer.valueOf(value.toString())); 
				}else if(type.equals(BigDecimal.class.getName())){//BigDecimal 类型
					f.set(obj, BigDecimal.valueOf(Long.valueOf(value.toString()))); 
				}else if(type.equals(Float.class.getName())){//Float 类型
					f.set(obj, Float.valueOf(value.toString()));
				}else if(type.equals(Double.class.getName())){//Double 类型
					f.set(obj, Double.valueOf(value.toString()));
				}else if(type.equals(Date.class.getName())){//Date 类型
					f.set(obj, (Date)value); 
				}else{
					throw new AppException("map转换object失败,未知的参数类型！");
				}
			}
		}
		return obj;
	}
	
	/**
	 * @Description: 对象转换成字符串
	 * 				 将list对象转换成返回字符串，传入交易结果编码，交易结果，list中式domian对象
	 *  			例如：returnForXml ("1","成功",list<ac01Domain>)
	 * @param @param list
	 * @param @return
	 * @param @throws Exception   
	 * @return String  
	 * @throws
	 * @author fenggg
	 * @date 2017-10-25
	 */
	@SuppressWarnings("unchecked")
	public static String returnForXml (String code,String msg,List list) throws Exception{
		if(ValidateUtil.isEmpty(list)){
			throw new AppException("转换失败，要转换的对象为空！");
		}
		
		StringBuffer sb = new StringBuffer();
		sb.append("<result><code>")
		  .append(code)
		  .append("</code><message>")
		  .append(msg)
		  .append("</message>");
		sb.append("<data><rows>");
		
		for(Object obj : list){
			//获取要转换的对象的属性数组
			Field[] fields =  getFields(obj);
			sb.append("<row>");
			//组装成字符串
			for(Field field : fields){
				field.setAccessible(true);//设置私有属性可以访问
				String name = field.getName();//取得属性名称
				Object value = field.get(obj);//取得属性值
				sb.append(getBodyXml(name.toLowerCase(),value));
			}
			sb.append("</row>");
		}
		sb.append("</rows></data></result>");
		
		return sb.toString();
	}
	
	/**
	 * @Description: 对象转换成字符串（单个对象）
	 * 				  将对象转换成xml对象，传入对象必须为domain对象
	 * 				 objectToXml (ac01Domain)  客户端调用服务端组xml
	 * 				 
	 * @param @param list
	 * @param @return
	 * @param @throws Exception   
	 * @return String  
	 * @throws
	 * @author fenggg
	 * @date 2017-10-25
	 */
	@SuppressWarnings("unchecked")
	public static String objectToXml (Object obj) throws Exception{
		if(ValidateUtil.isEmpty(obj)){
			throw new AppException("转换失败，要转换的对象为空！");
		}
		
		StringBuffer sb = new StringBuffer();
		sb.append("<result><data><rows><row>");
		//获取要转换的对象的属性数组
		Field[] fields =  getFields(obj);
		//组装成字符串
		for(Field field : fields){
			field.setAccessible(true);//设置私有属性可以访问
			String name = field.getName();//取得属性名称
			Object value = field.get(obj);//取得属性值
			sb.append(getBodyXml(name.toLowerCase(),value));
		}
		sb.append("</row></rows></data></result>");
		
		return sb.toString();
	}
	
	/**
	 * @Description: 对象转换成字符串
	 * 				 将对象转换成xml对象，传入对象list中必须为domain对象
	 * 				 List list = new ArrayList()
	 * 				 Ac01Domain ac01 = new Ac01Domain();
	 * 			     list.add(ac01);
	 * 				 objectToXml (list)  客户端调用服务端组xml
	 * @param @param list
	 * @param @return
	 * @param @throws Exception   
	 * @return String  
	 * @throws
	 * @author fenggg
	 * @date 2017-10-25
	 */
	@SuppressWarnings("unchecked")
	public static String listToXml (List list) throws Exception{
		if(ValidateUtil.isEmpty(list)){
			throw new AppException("转换失败，要转换的对象为空！");
		}
		
		StringBuffer sb = new StringBuffer();
		sb.append("<result><data><rows>");
		for(Object obj : list){
			//获取要转换的对象的属性数组
			Field[] fields =  getFields(obj);
			sb.append("<row>");
			//组装成字符串
			for(Field field : fields){
				field.setAccessible(true);//设置私有属性可以访问
				String name = field.getName();//取得属性名称
				Object value = field.get(obj);//取得属性值
				sb.append(getBodyXml(name.toLowerCase(),value));
			}
			sb.append("</row>");
		}
		sb.append("</rows></data></result>");
		
		return sb.toString();
	}
	
	/**getBodyXml
	 * @Description: 组装字符串 把单个字段转换成字符串的形式
	 * @param @param list
	 * @param @return
	 * @param @throws Exception   
	 * @return 返回格式如下
	*         例如：AAC001=20 转换成  <AAC001><![CDATA[20]]></AAC001>
	 * @throws
	 * @author fenggg
	 * @date 2017-10-25
	 */
	private static String getBodyXml(String name, Object value) throws Exception{
		
		StringBuffer sf = new StringBuffer();
		final String frontBrackets1 = "<";
		final String frontBrackets2 = "</";
		final String backBrackets = ">";
		final String contentFrontBrackets = "<![CDATA[";
		final String contentBackBrackets = "]]>";
		
		sf.append(frontBrackets1);
		sf.append(name);
		sf.append(backBrackets);
		sf.append(contentFrontBrackets);
		
		if(value != null){
			sf.append(value);
		}
		
		sf.append(contentBackBrackets);
		sf.append(frontBrackets2);
		sf.append(name);
		sf.append(backBrackets);
		
		return sf.toString();	
	}
	
	
	/** 
	* @Title: getFields 
	* @Description: 获取对象属性数组
	* @param @param o
	* @param @return
	* @param @throws Exception 
	* @return Field[]
	* @throws 
	* @author fenggg
	* @date 2017-10-25
	*/
	@SuppressWarnings("unchecked")
	private static Field[] getFields(Object o){
		
		 if(ValidateUtil.isEmpty(o)){
			throw new AppException("转换失败，要转换的对象为空！");
		 }
		 
		 Class cls = o.getClass();  
	     Field[] fields = cls.getDeclaredFields();  
	       
	     return fields;
	}
	
	
	/**
	 * @Description: 险种拼接成字符串以逗号隔开
	 * @param @param list
	 * @param @return   
	 * @return String  
	 * @throws
	 * @author fenggg
	 * @date 2017-10-25
	 */
	public static String getAae140String(List list){
		
		StringBuffer sf = new StringBuffer();
		if(ValidateUtil.isEmpty(list)){
			throw new AppException("险种转换成字符串，传入参数为空");
		}
		List<HashMap> dataList = list;
		for(Map map : dataList){
			sf.append(map.get("aae140")).append(",");
		}
		return ValidateUtil.isEmpty(sf)?"":sf.substring(0, sf.length()-1);
	}
	
	
	/**
	 * @Description: 险种拼接成字符串以逗号隔开
	 * @param @param list
	 * @param @return   
	 * @return String  
	 * @throws
	 * @author fenggg
	 * @date 2017-10-25
	 */
	public static String getAae140String2(List list){
		
		StringBuffer sf = new StringBuffer();
		if(ValidateUtil.isEmpty(list)){
			throw new AppException("险种转换成字符串，传入参数为空");
		}
		List<String> dataList = list;
		for(String s : dataList){
			sf.append(s).append(",");
		}
		return ValidateUtil.isEmpty(sf)?"":sf.substring(0, sf.length()-1);
	}
	
	/**
	 * @Description: 返回的字符串转换成map
	 * @param @param xml
	 * @param @return
	 * @param @throws Exception   
	 * @return Map  
	 * @throws
	 * @author fenggg
	 * @date 2017-10-25
	 */
	@SuppressWarnings("unchecked")
	public static Map xmlToMap(String xml) throws Exception{
		Map map=new HashMap();
		Map rowMap=new HashMap();
		List list = new ArrayList(),lstrow = new ArrayList();
		Element row;
        try {
        	//获取xml子节点resultset
            SAXBuilder sb = new SAXBuilder();
            Reader rd = new StringReader(xml);
            Document docXml = sb.build(rd);
            Element rootArg = docXml.getRootElement();
            //if(rootArg.getChildren("output").size() != 0){
            	Element code=(Element)rootArg.getChildren("code").get(0);//返回是否执行成功
                Element message=(Element)rootArg.getChildren("message").get(0);//返回消息提示信息
                map.put("code", code.getTextTrim());
                map.put("message", message.getTextTrim()); 
            	Element elementroot=(Element)rootArg.getChildren("data").get(0);
            	Element elementroot1=(Element)elementroot.getChildren("rows").get(0);//数据集合
                //Element recordcount=(Element)elementroot.getChildren("recordcount").get(0);
                //map.put("recordcount", recordcount.getTextTrim());
                List lstArg=(List)elementroot1.getChildren();
                for (int i=0;i< lstArg.size();i++){
                	row = (Element)lstArg.get(i);
                	lstrow = row.getChildren();
                    rowMap = new HashMap();
                	for (Iterator iter = lstrow.iterator(); iter.hasNext();) {
                        Element el = (Element) iter.next();
                        rowMap.put(el.getName(), el.getText());
                    }
                	list.add(rowMap);
                }
                map.put("list", list);
            /*}else {
            	List lst=(List)rootArg.getChildren();
                for (Iterator iter = lst.iterator(); iter.hasNext();) {
                     Element el = (Element) iter.next();
                     map.put(el.getName(), el.getText());
                }
			}*/
		} catch (Exception e){
			e.printStackTrace();
			throw new Exception("XML文件解析失败！");
        }
		return map;
	}
	
	/**
	 * @Description: xml转换成List
	 * @param @param xml
	 * @param @return
	 * @param @throws Exception   
	 * @return List  
	 * @throws
	 * @author fenggg
	 * @date 2017-10-25
	 */
	public static List xmlToList(String xml) throws Exception{
		Map map=new HashMap();
		List list = new ArrayList(),lstrow = new ArrayList();
		Element row;
        try {
        	//获取xml子节点resultset
            SAXBuilder sb = new SAXBuilder();
            Reader rd = new StringReader(xml);
            Document docXml = sb.build(rd);
            Element rootArg = docXml.getRootElement();
            if(rootArg.getChildren("data").size() != 0){
            	Element elementroot=(Element)rootArg.getChildren("data").get(0);
                Element elementroot1=(Element)elementroot.getChildren("rows").get(0);//数据集合
                List lstArg=(List)elementroot1.getChildren();
                for (int i=0;i< lstArg.size();i++){
                	row = (Element)lstArg.get(i);
                	lstrow = row.getChildren();
                	map = new HashMap();
                	for (Iterator iter = lstrow.iterator(); iter.hasNext();) {
                        Element el = (Element) iter.next();
                        map.put(el.getName(), el.getText());
                    }
                	list.add(map);
                }
            }else{
            	List lst=(List)rootArg.getChildren();
                for (Iterator iter = lst.iterator(); iter.hasNext();) {
                     Element el = (Element) iter.next();
                     map.put(el.getName(), el.getText());
                }
                list.add(map);
            }
		} catch (Exception e){
			e.printStackTrace();
			throw new Exception("XML文件解析失败！");
        }
		return list;
	}
	
	/**
	 * @Description: 对象转换成字符串
	 * 				 List<Map> 中放入map对象
	 * @param @param list
	 * @param @return
	 * @param @throws Exception   
	 * @return String  
	 * @throws
	 * @author fenggg
	 * @date 2017-10-25
	 */
	@SuppressWarnings("unchecked")
	public static String listToXml2 (List<Map> list) throws Exception{
		if(ValidateUtil.isEmpty(list)){
			throw new AppException("转换失败，要转换的对象为空！");
		}
		
		StringBuffer sb = new StringBuffer();
		Set<String> set = null;
		sb.append("<result><data><rows>");
		for(Map map : list){
			set = map.keySet(); 
			sb.append("<row>");
			for(Iterator<String> it=set.iterator(); it.hasNext();){  
		        String key = it.next();  
		        Object value = map.get(key);  
		        sb.append(getBodyXml(key,value));  
		    }  
			sb.append("</row>");
		}
		sb.append("</rows></data></result>");
		return sb.toString();
	}
	
	/**
	 * @Description: 对象转换成字符串
	 * 				 单个map对象转换成xml字符串
	 * @param @param list
	 * @param @return
	 * @param @throws Exception   
	 * @return String  
	 * @throws
	 * @author fenggg
	 * @date 2017-10-25
	 */
	@SuppressWarnings("unchecked")
	public static String mapToXml (Map map) throws Exception{
		if(ValidateUtil.isEmpty(map)){
			throw new AppException("转换失败，要转换的对象为空！");
		}
		
		StringBuffer sb = new StringBuffer();
		Set<String> set = null;
		sb.append("<result><data><rows>");
		set = map.keySet(); 
		sb.append("<row>");
		for(Iterator<String> it=set.iterator(); it.hasNext();){  
	        String key = it.next();  
	        Object value = map.get(key);  
	        sb.append(getBodyXml(key,value));  
	    }  
		sb.append("</row>");
		sb.append("</rows></data></result>");
		return sb.toString();
	}
	
	
	/**
	 * @Description: 对象转换成字符串(返回字符串)
	 * 				  server端组装返回xml字符串
	 * @param @param list
	 * @param @return
	 * @param @throws Exception   
	 * @return String  
	 * @throws
	 * @author fenggg
	 * @date 2017-10-25
	 */
	@SuppressWarnings("unchecked")
	public static String returnToXml (String code,String msg,List<Map> list) throws Exception{
		if(ValidateUtil.isEmpty(list)){
			throw new AppException("转换失败，要转换的对象为空！");
		}
		
		StringBuffer sb = new StringBuffer();
		Set<String> set = null;
		
		sb.append("<result><code>")
		  .append(code)
		  .append("</code><message>")
		  .append(msg)
		  .append("</message>");
		sb.append("<data><rows>");
		for(Map map : list){
			set = map.keySet(); 
			sb.append("<row>");
			for(Iterator<String> it=set.iterator(); it.hasNext();){  
		        String key = it.next();  
		        Object value = map.get(key);  
		        sb.append(getBodyXml(key,value));  
		    }  
			sb.append("</row>");
		}
		sb.append("</rows></data></result>");
		
		return sb.toString();
	}
	
}
