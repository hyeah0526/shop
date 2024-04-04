<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
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
		msg = "Modify Done!!!";
		response.sendRedirect("/shop/emp/categoryList.jsp?msg="+msg);
	}else{
		System.out.println("수정 실패");
		msg = "Modify Fail!!!";
		response.sendRedirect("/shop/emp/categoryList.jsp?msg="+msg);
	}
%>