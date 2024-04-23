<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="shop.dao.OrderDAO"%>
<%@ page import="java.net.*" %>
<%
/* 인증분기: 세션변수 이름 - loginEmp */
	if(session.getAttribute("loginCustomer") == null){ 
		response.sendRedirect("/shop/customer/loginForm.jsp"); 
		return;
	}
%>
<%
	// 주문번호
	int ordersNo = Integer.parseInt(request.getParameter("ordersNo"));
	System.out.println(ordersNo+" <--ordersNo cancelMyOrdersAction.jsp");
	
	// 주문취소하기DAO
	int row = OrderDAO.updateCancelMyOrders(ordersNo);
	
	String msg = "";
	
	if(row == 1){ // 취소성공
		System.out.println("취소성공");
		msg = URLEncoder.encode("[주문번호 "+ordersNo+"번] 주문취소가 완료되었습니다.", "UTF-8");
		response.sendRedirect("/shop/customer/myOrderList.jsp?msg="+msg);
	}else{ // 취소실패
		System.out.println("취소실패");
		msg = URLEncoder.encode("[주문번호 "+ordersNo+"번] 주문취소에 실패하였습니다. 다시 시도해주세요.", "UTF-8");
		response.sendRedirect("/shop/customer/myOrderList.jsp?msg="+msg);
	}
%>
