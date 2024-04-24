<%@page import="shop.dao.GoodsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="shop.dao.OrderDAO"%>
<%@ page import="java.net.*" %>
<%
/* 인증분기: 세션변수 이름 - loginEmp */
	if(session.getAttribute("loginEmp") == null){
		response.sendRedirect("/shop/emp/empLoginForm.jsp"); 
		return;
	}
%>
<%
	String oldState = request.getParameter("oldState");
	String newState = request.getParameter("newState");
	int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
	int ordersNo = Integer.parseInt(request.getParameter("ordersNo"));
	int orderAmount = Integer.parseInt(request.getParameter("orderAmount"));
	
	String orderCxl = "cxl";
	System.out.println(oldState + " <--oldState modifyStateOrder.jsp");
	System.out.println(newState + " <--newState modifyStateOrder.jsp");
	System.out.println(ordersNo + " <--ordersNo modifyStateOrder.jsp");
	
	int row1 = 0;
	if(newState.equals("주문취소")){
		System.out.println(newState + " <--newState modifyStateOrder.jsp");
		// 취소시 GoodsAmount update 수량 빼주기 
		row1 = GoodsDAO.updateGoodsAmount(goodsNo, orderCxl, orderAmount);
	}
	
	// 해당상태로바꾸기
	int row2 = OrderDAO.updateStateOrder(ordersNo, oldState, newState);
	
	String msg = "";
	
	if(row2 == 1){
		System.out.println("변경성공");
		msg = URLEncoder.encode("[주문번호 "+ordersNo+"번] "+oldState+"->"+newState+"로 주문상태가 변경완료되었습니다.", "UTF-8");
		response.sendRedirect("/shop/emp/customerOrderList.jsp?msg="+msg);
	}else{
		System.out.println("변경실패");
		msg = URLEncoder.encode("주문상태 변경에 실패하였습니다. 다시 시도해주세요.", "UTF-8");
		response.sendRedirect("/shop/emp/customerOrderList.jsp?msg="+msg);
	}
%>