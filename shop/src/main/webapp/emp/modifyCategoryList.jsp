<%@page import="shop.dao.DBHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder"%>
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
	String modifyCategory = request.getParameter("modifyCategory");
	System.out.println(category + " <--category modifyCategoryList.jsp");
	System.out.println(modifyCategory + " <--modifyCategory modifyCategoryList.jsp");
	
	Connection conn = DBHelper.getConnection();
	PreparedStatement stmt = null;
	String sql = "UPDATE category SET category = ? WHERE category = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, modifyCategory);
	stmt.setString(2, category);
	
	int row = 0;
	row = stmt.executeUpdate();
	
	String msg = "";
	
	if(row == 1){
		System.out.println("수정 성공");
		msg = URLEncoder.encode("카테고리 수정 성공하였습니다.", "UTF-8");
		response.sendRedirect("/shop/emp/categoryList.jsp?msg="+msg);
	}else{
		System.out.println("수정 실패");
		msg = URLEncoder.encode("카테고리 수정 실패하였습니다.", "UTF-8");
		response.sendRedirect("/shop/emp/categoryList.jsp?msg="+msg);
	}
%>