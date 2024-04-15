<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*"%>
<%@ page import="shop.dao.*" %>
<%
	/* 인증분기: 세션변수 이름 - loginEmp */
	//로그인이 이미 되어있으면 empList.jsp로 보냄
	if(session.getAttribute("loginEmp") != null){ 
		response.sendRedirect("/shop/emp/empList.jsp"); 
		return;
	}
%>
<%
	/* 1. 요청값분석 controller */
	String empId = request.getParameter("empId");
	String empPw = request.getParameter("empPw");
	System.out.println(empId+" <--empId empLoginAction.jsp");
	System.out.println(empPw+" <--empPw empLoginAction.jsp");
	
	// 먼저 page import를 해주고 호출하기 
	// model코드가 사라지고 model을 호출하는 코드
	HashMap<String, Object> loginEmp = EmpDAO.emplogin(empId, empPw); //이 친구의 반환값은 HashMap이므로 EmpDAQO.empLogin()를 HashMap으로 만들어줌
	
	if(loginEmp == null){ // 로그인 실패
		System.out.println("로그인실패");
	
		String errMsg = URLEncoder.encode("아이디와 비밀번호를 확인해주세요", "utf-8");
		response.sendRedirect("/shop/emp/empLoginForm.jsp?errMsg="+errMsg);
		
	}else{ // 로그인 성공
		System.out.println("로그인성공");
		
		session.setAttribute("loginEmp", loginEmp);
		response.sendRedirect("/shop/emp/empList.jsp");
	}
	
	// 이렇게 사용하므로써 DB로 접근하는 Model코드가 사라지고 controller만 남게됨!
%>