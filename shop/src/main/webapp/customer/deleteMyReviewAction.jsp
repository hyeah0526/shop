<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="shop.dao.CommentDAO"%>
<%@ page import="java.net.*" %>
<%
/* 인증분기: 세션변수 이름 - loginEmp */
	if(session.getAttribute("loginCustomer") == null){ 
		response.sendRedirect("/shop/customer/loginForm.jsp"); 
		return;
	}
%>
<%
	/* post로 넘겼으면 꼭 인코딩해주기 */
	request.setCharacterEncoding("UTF-8");

	String cMail = request.getParameter("cMail");
	int ordersNo = Integer.parseInt(request.getParameter("ordersNo"));
	int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
	//System.out.println(cMail + " <--cMail deleteMyReviewAction.jsp");
	//System.out.println(ordersNo + " <--ordersNo deleteMyReviewAction.jsp");
	
	// 리뷰삭제하기
	int row1 = CommentDAO.deleteMyReview(ordersNo, cMail);
	
	// 리뷰삭제하면 state를 다시 '배송완료'로 변경
	int row2 = CommentDAO.deleteMyReviewState(ordersNo);
	
	String msg = "";
	
	if(row1 == 1 && row2 == 1){
		System.out.println("삭제성공");
		response.sendRedirect("/shop/customer/customerGoodsOne.jsp?goodsNo="+goodsNo);
	}else{
		System.out.println("삭제실패");
		response.sendRedirect("/shop/customer/customerGoodsOne.jsp?goodsNo="+goodsNo);
	}
	
	
%>