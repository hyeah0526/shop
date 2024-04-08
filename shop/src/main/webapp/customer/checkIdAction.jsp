<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.sql.*" %>
<%
	String chkMail = request.getParameter("chkMail");
	System.out.println(chkMail);

	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	PreparedStatement stmt = null;
	ResultSet rs = null; 
	
	String sql = "SELECT c_mail Cmail FROM customer WHERE c_mail = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, chkMail);
	
	rs = stmt.executeQuery();
	
	String msg = "";
	
	if(rs.next()){
		System.out.println("아이디가 이미 존재함");
		msg = "invalid";
		response.sendRedirect("/shop/customer/addCustomerForm.jsp?msg="+msg);
	}else{
		System.out.println("아이디 존재하지 않음");
		msg = "valid";
		response.sendRedirect("/shop/customer/addCustomerForm.jsp?msg="+msg+"&chkMail="+chkMail);
	}

%>