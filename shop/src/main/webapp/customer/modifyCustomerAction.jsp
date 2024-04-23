<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="shop.dao.CustomerDAO"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
/* 인증분기: 세션변수 이름 - loginEmp */
	if(session.getAttribute("loginCustomer") == null){ 
		response.sendRedirect("/shop/customer/loginForm.jsp"); 
		return;
	}
%>
<%
	HashMap<String,Object> loginCustomer 
		= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));;
%>
<%
	String cOldPw = request.getParameter("cOldPw"); //원래 비밀번호
	String cNewPw = request.getParameter("cNewPw"); //새로운 비밀번호
	String cMail = request.getParameter("cMail"); //이메일
	System.out.println(cOldPw + " <--cOldPw modifyCustomerAction.jsp");
	System.out.println(cNewPw + " <--cNewPw modifyCustomerAction.jsp");
	System.out.println(cMail + " <--cMail modifyCustomerAction.jsp");
	
	// 비밀번호 수정 DAO
	int row = CustomerDAO.updateCustomer(cOldPw, cNewPw, cMail);
	
	String msg = "";
	
	if(row == 1){ // 수정성공
		System.out.println("비밀번호 수정성공!");
		msg = URLEncoder.encode("비밀번호수정", "UTF-8");
		response.sendRedirect("/shop/customer/customerGoodsList.jsp?msg="+msg);
	}else{ // 수정실패
		System.out.println("수정실패");
		msg = URLEncoder.encode("수정에 실패하였습니다. 비밀번호를 다시 확인해주세요.", "UTF-8");
		response.sendRedirect("/shop/customer/modifyCustomer.jsp?cMail="+cMail+"&msg="+msg);
	}
	
	

%>