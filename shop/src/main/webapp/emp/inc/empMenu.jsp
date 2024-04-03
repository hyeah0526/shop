<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
	HashMap<String,Object> loginMember 
		= (HashMap<String,Object>)(session.getAttribute("loginEmp"));
	
%>
<div class="col" style="background-color: yellow;">
	<br><a href="/shop/emp/empList.jsp">사원관리</a><br>
		<!-- category CRUD -->
		<a href="/shop/emp/categoryList.jsp">카테고리관리</a><br>
		<a href="/shop/emp/goodsList.jsp">상품관리</a><br><br>
		<a href="/shop/emp/">
			<%=(String)(loginMember.get("empName"))%>
		</a>님 반갑습니다<br>
		<a href="/shop/emp/empLogout.jsp">로그아웃</a>
</div>