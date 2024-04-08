<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%
	/* 로그아웃 하기 */
	//기존 세션을 완전히 삭제하고, 새로운 세션 공간을 초기화
	session.invalidate();
	System.out.println(session.getId()); //getId로 초기화됐는지 확인
	
	//다시 로그인페이지로 보내기
	String msg = URLEncoder.encode("로그아웃 성공! 다시 로그인해주세요.","utf-8");
	response.sendRedirect("/shop/customer/loginForm.jsp?msg="+msg);
%>
