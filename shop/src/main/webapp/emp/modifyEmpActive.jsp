<%@page import="shop.dao.DBHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
/* Active를 'ON' 혹은 'OFF'로 변경 */
	String empId = request.getParameter("empId");
	String active = request.getParameter("active");
	System.out.println(empId+" <-- empId modifyEmpActive.jsp");
	System.out.println(active+" <-- active modifyEmpActive.jsp");
	
	
	Connection conn = DBHelper.getConnection();
	PreparedStatement stmt = null;
	String sql = null;
	if(active.equals("ON")){
		sql = "update emp set active = 'OFF' where emp_id = ?";
	}else{
		sql = "update emp set active = 'ON' where emp_id = ?";
	}
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, empId);
	System.out.println(stmt);
	
	int row = 0;
	row = stmt.executeUpdate();
	
	if(row == 1){
		System.out.println("변경성공");
		response.sendRedirect("/shop/emp/empList.jsp");
	}else{
		System.out.println("변경실패");
		response.sendRedirect("/shop/emp/empList.jsp");
	}
	
%>