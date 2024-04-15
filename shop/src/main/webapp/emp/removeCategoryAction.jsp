<%@page import="shop.dao.CategoryDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.net.URLEncoder"%>
<%@ page import="java.sql.*" %>
<%
	/* 인증분기: 세션변수 이름 - loginEmp */
	//로그인이 안되어 있으면 emploginForm.jsp로 보냄
	if(session.getAttribute("loginEmp") == null){
		response.sendRedirect("/shop/emp/empLoginForm.jsp"); 
		return;
	}
%>
<%
	String category = request.getParameter("category");
	System.out.println(category + " <--category removeCategoryAction.jsp");
	
	int row = CategoryDAO.deleteCategory(category);	
	
	String msg = "";
	if(row == 1){
		System.out.println("삭제성공");
		msg = URLEncoder.encode("카테고리 삭제에 성공하였습니다","UTF-8");
		response.sendRedirect("/shop/emp/categoryList.jsp?msg="+msg);
	}else{
		System.out.println("삭제실패");
		msg = URLEncoder.encode("카테고리 삭제에 실패하였습니다","UTF-8");
		response.sendRedirect("/shop/emp/categoryList.jsp?msg="+msg);
	}
	
%>