<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	HashMap<String,Object> loginCustomer 
		= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
%>
<%
	int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
	int goodsAmount = Integer.parseInt(request.getParameter("goodsAmount"));
	

%>
