<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
	HashMap<String,Object> loginCustomer 
		= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
	
%>
<div class="col text-center rounded"
	style="border: 3px dashed #5E3F36; border-radius:10px; height: 800px; background-color: #E6D7BD; margin-right: 10px; color: #444236;">
		<br>
		<a href="/shop/customer/customerGoodsList.jsp">상품 보기</a><br>
		<a href="">메뉴2</a><br>
		<a href="">메뉴3</a><br><br>
		<a href="/shop/emp/">
			<%=(String)(loginCustomer.get("cName"))%>
		</a>님 반갑습니다
		<br><br>
		<div>
			<a href="/shop/customer/customerLogout.jsp" class="btn" style="border: 3px solid green;">로그아웃</a>
		</div>
</div>