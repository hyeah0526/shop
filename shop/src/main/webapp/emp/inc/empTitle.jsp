<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
	HashMap<String,Object> loginMember 
		= (HashMap<String,Object>)(session.getAttribute("loginEmp"));
%>

<div class="row" style="background-color: #E6D7BD; border: 3px dashed #5E3F36; border-radius:10px; margin-bottom: 10px;">
	<img src="/shop/emp/img/logo3.png" style="width: 200px; margin: auto;">
</div>