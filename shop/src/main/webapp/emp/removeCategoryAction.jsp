<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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
		msg = "Remove Done!!!";
		response.sendRedirect("/shop/emp/categoryList.jsp?msg="+msg);
	}else{
		System.out.println("삭제실패");
		msg = "Remove Fail!!!";
		response.sendRedirect("/shop/emp/categoryList.jsp?msg="+msg);
	}
	
%>