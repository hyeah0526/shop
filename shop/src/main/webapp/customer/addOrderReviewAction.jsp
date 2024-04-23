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

	//String cMail = request.getParameter("cMail");
	int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
	int ordersNo = Integer.parseInt(request.getParameter("myOrdersNo"));
	int score = Integer.parseInt(request.getParameter("score"));
	String content = request.getParameter("content");
	
	//System.out.println(cMail + " <--cMail addOrderReviewAction.jsp");
	//System.out.println(goodsNo + " <--goodsNo addOrderReviewAction.jsp");
	System.out.println(score + " <--score addOrderReviewAction.jsp");
	System.out.println(content + " <--content addOrderReviewAction.jsp");
	System.out.println(ordersNo + " <--ordersNo addOrderReviewAction.jsp");
	
	// 리뷰작성추가 insert
	int row1 = CommentDAO.insertMyReview(ordersNo, score, content);
	
	// 리뷰작성 후 state를 '리뷰완료'로 변경
	int row2 = CommentDAO.updateMyReviewState(ordersNo);
	
	String msg = "";
	
	if(row1 == 1 && row2 == 1){
		System.out.println("등록 성공");
		msg = URLEncoder.encode("후기등록 완료하였습니다.", "UTF-8");
		response.sendRedirect("/shop/customer/customerGoodsOne.jsp?goodsNo="+goodsNo+"&msg="+msg);
	}else{
		System.out.println("취소실패");
		msg = URLEncoder.encode("후기등록 실패하였습니다. 다시 시도해주세요.", "UTF-8");
		response.sendRedirect("/shop/customer/customerGoodsOne.jsp?goodsNo="+goodsNo+"&msg="+msg);
	}
	
	
%>