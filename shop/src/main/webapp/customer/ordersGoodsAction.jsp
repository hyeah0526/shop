<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="shop.dao.OrderDAO"%>
<%@ page import="shop.dao.GoodsDAO"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.URLEncoder"%>
<%
/* 인증분기: 세션변수 이름 - loginEmp */
	
	//로그인정보가 없으면 로그인폼으로 보내기
	if(session.getAttribute("loginCustomer") == null){ 
		response.sendRedirect("/shop/customer/loginForm.jsp"); 
		return;
	}

/* 로그인 된 정보 */
	HashMap<String,Object> loginCustomer 
		= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
%>
<%
	// 주문 변수들
	int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
	int goodsAmount = Integer.parseInt(request.getParameter("goodsAmount"));
	String orderCxl = request.getParameter("orderCxl");//주문인지 취소인지 구분
	
	String cMail = (String)loginCustomer.get("cMail");
	int goodsPrice = Integer.parseInt(request.getParameter("goodsPrice")); //상품가격
	int totalAmount = Integer.parseInt(request.getParameter("orderAmount")); //고객이 주문한 수량
	int totalPrice = goodsPrice * totalAmount; //고객이 주문한 총 금액
	String address = request.getParameter("address"); //배송지
	
	System.out.println(goodsNo + " <-- goodsNo ordersGoodsAction.jp");
	System.out.println(goodsAmount + " <-- goodsAmount ordersGoodsAction.jp");
	System.out.println(orderCxl + " <-- orderCxl ordersGoodsAction.jp");
	//System.out.println(loginCustomer.get("cMail"));
	
	// 주문 시 GoodsAmount update 수량 빼주기 
	int row1 = GoodsDAO.updateGoodsAmount(goodsAmount, goodsNo, orderCxl, totalAmount);
	
	// order 테이블에 insert 주문작업
	int row2 = OrderDAO.orderGoods(cMail, goodsNo, totalAmount, totalPrice, address);
	
	String msg = "";
	
	// 상품 수량도 빼주고, order테이블에 추가도 성공해야 주문성공
	if(row1 == 1 && row2 == 1){
		System.out.println("주문성공");
		msg = URLEncoder.encode("주문에 성공하였습니다.", "UTF-8");
		response.sendRedirect("/shop/customer/myOrderList.jsp?msg="+msg);
	}else{
		System.out.println("주문실패");
		msg = URLEncoder.encode("주문 실패하였습니다. 다시 확인해주세요.", "UTF-8");
		response.sendRedirect("/shop/customer/customerGoodsOne.jsp?goodsNo="+goodsNo+"&msg="+msg);
	}
	
	

%>
