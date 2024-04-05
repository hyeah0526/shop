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
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	PreparedStatement stmt = null;
	String sql = "delete from category where category = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, category);
	
	int row = 0;
	row = stmt.executeUpdate();
	
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