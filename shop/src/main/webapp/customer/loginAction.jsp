<%@page import="shop.dao.CustomerDAO"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
/* 인증분기: 세션변수 이름 - loginCustomer */
	
	//로그인을 하지 않은 상태여야지만 loginForm으로 올 수 있기 때문에 필요없지만,
	//주소창에 직접 loginAction.jsp창을 칠수 있기때문에 분기해주기
	
	//로그인이 이미 되어있으면 goodsList.jsp로 보냄
	if(session.getAttribute("loginCustomer") != null){ 
		response.sendRedirect("/shop/customer/customerGoodsList.jsp"); 
		return;
	}
%>
<%
	/* post로 넘겼으면 꼭 인코딩해주기 */
	request.setCharacterEncoding("UTF-8");

	//변수값가져오기
	String cMail = request.getParameter("cMail");
	String cPw = request.getParameter("cPw");
	
	//디버깅
	System.out.println(cMail+" <-- cMail loginAction.jsp");
	System.out.println(cPw+" <-- cPw loginAction.jsp");
	
	String msg = "";
	//DB
	HashMap<String, Object> loginCustomer = CustomerDAO.customerLogin(cMail, cPw);
	
	if(loginCustomer == null){
		System.out.println("로그인 실패!");
		msg = URLEncoder.encode("로그인에 실패하였습니다. 메일 주소와 비밀번호를 다시 확인해주세요.", "UTF-8");
		response.sendRedirect("/shop/customer/loginForm.jsp?msg="+msg);
		
	}else{
		System.out.println("로그인 성공!");
		session.setAttribute("loginCustomer", loginCustomer);
		//세션에 담은 후 보내주기!
		response.sendRedirect("/shop/customer/customerGoodsList.jsp");
	}
%>
