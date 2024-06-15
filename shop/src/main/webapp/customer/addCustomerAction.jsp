<%@page import="shop.dao.DBHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
	/* post로 넘겼으면 꼭 인코딩해주기 */
	request.setCharacterEncoding("UTF-8");

	//변수
	String cMail = request.getParameter("cMail");
	String cPw = request.getParameter("cPw");
	String cName = request.getParameter("cName");
	String cBirth = request.getParameter("cBirth");
	String cGender = request.getParameter("cGender");
	
	//디버깅
	System.out.println(cMail+" <-- cMail addCustomerAction.jsp");
	System.out.println(cPw+" <-- cPw addCustomerAction.jsp");
	System.out.println(cName+" <-- cName addCustomerAction.jsp");
	System.out.println(cBirth+" <-- cBirth addCustomerAction.jsp");
	System.out.println(cGender+" <-- cGender addCustomerAction.jsp");
	
	//DB Insert
	Connection conn = DBHelper.getConnection();
	PreparedStatement stmt = null;
	/*
		INSERT INTO customer(
		c_mail, 
		c_pw, 
		c_name, 
		c_birth,
		c_gender
	)VALUES(
		'123123@naver.com', 
		PASSWORD('1234'),
		'일이삼', 
		'1994-05-26', 
		'여'); 
	*/
	
	String sql = "INSERT INTO customer(c_mail, c_pw, c_name, c_birth, c_gender)VALUES(?, PASSWORD(?), ?, ?, ?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, cMail);
	stmt.setString(2, cPw);
	stmt.setString(3, cName);
	stmt.setString(4, cBirth);
	stmt.setString(5, cGender);
	
	int row = 0;
	row = stmt.executeUpdate();
	
	String msg = "";
	
	if(row == 1){
		System.out.println("회원가입성공");
		msg = URLEncoder.encode("회원가입에 성공하였습니다. 로그인해주세요.", "UTF-8");
		response.sendRedirect("/shop/customer/loginForm.jsp?msg="+msg);
	}else{
		msg = URLEncoder.encode("회원가입에 실패하였습니다. 다시 시도해주세요.", "UTF-8");
		response.sendRedirect("/shop/customer/loginForm.jsp?msg="+msg);
	}
	

%>