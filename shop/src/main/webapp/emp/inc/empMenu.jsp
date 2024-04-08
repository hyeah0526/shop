<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
	HashMap<String,Object> loginMember 
		= (HashMap<String,Object>)(session.getAttribute("loginEmp"));
	
%>
<div class="col text-center rounded"
	style="border: 3px dashed #5E3F36; border-radius:10px; height: 800px; background-color: #E6D7BD; margin-right: 10px; color: #444236;">
		<br>
		<a href="/shop/emp/empList.jsp">사원 관리</a><br>
		<a href="/shop/emp/categoryList.jsp">카테고리 관리</a><br>
		<a href="/shop/emp/goodsList.jsp">상품 관리</a><br><br>
		<a href="/shop/emp/">
			<%=(String)(loginMember.get("empName"))%>
		</a>님 반갑습니다
		<br><br>
		<div>
			<a href="/shop/emp/empLogout.jsp" class="btn" style="border: 3px solid green;">로그아웃</a>
		</div>
</div>