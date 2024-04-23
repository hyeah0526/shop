<%@page import="shop.dao.CustomerDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.sql.*" %>
<%
	String chkMail = request.getParameter("chkMail");
	System.out.println(chkMail);

	// 가입 가능한 이메일주소 확인
	int row = CustomerDAO.checkId(chkMail);
	
	String msg = "";
	
	if(row == 1){ // 중복으로 가입불가능
		System.out.println("아이디가 이미 존재함");
		msg = "invalid";
		response.sendRedirect("/shop/customer/addCustomerForm.jsp?msg="+msg);
	}else{// 가입가능
		System.out.println("아이디 존재하지 않음");
		msg = "valid";
		response.sendRedirect("/shop/customer/addCustomerForm.jsp?msg="+msg+"&chkMail="+chkMail);
	}

%>