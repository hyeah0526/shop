<%@page import="shop.dao.CustomerDAO"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String cMail = request.getParameter("cMail");
	String cPw = request.getParameter("cPw");
	System.out.println(cMail + " <--cMail deleteCustomer.jsp");
	System.out.println(cPw + " <--cPw deleteCustomer.jsp");
	
	int row = CustomerDAO.deleteCustomer(cMail, cPw);
	
	String msg = "";
	
	if(row == 1){
		System.out.println("탈퇴성공");
		msg = URLEncoder.encode("회원탈퇴에 성공하였습니다.", "UTF-8");
		session.invalidate();
		response.sendRedirect("/shop/customer/loginForm.jsp?msg="+msg);
	}else{
		System.out.println("탈퇴 실패");
		msg = URLEncoder.encode("탈퇴에 실패하였습니다. 비밀번호를 다시 확인해주세요.", "UTF-8");
		response.sendRedirect("/shop/customer/modifyCustomer.jsp?cMail="+cMail+"&msg="+msg);
	}
%>