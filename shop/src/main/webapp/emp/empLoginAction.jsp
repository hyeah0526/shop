<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*"%>
<%
/* 인증분기: 세션변수 이름 - loginEmp */
	//String loginEmp = (String)session.getAttribute("loginEmp"); 
	//System.out.println(loginEmp+" <-- loginEmp empLoginForm.jsp"); // 로그인한적이 없으면 null이 들어감
	
	//로그인이 이미 되어있으면 empList.jsp로 보냄
	if(session.getAttribute("loginEmp") != null){ 
		response.sendRedirect("/shop/emp/empList.jsp"); 
		return;
	}
%>

<%
/* 요청값분석 */
	String empId = request.getParameter("empId");
	String empPw = request.getParameter("empPw");
	System.out.println(empId+" <--empId empLoginAction.jsp");
	System.out.println(empPw+" <--empPw empLoginAction.jsp");
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	PreparedStatement stmt = null;
	ResultSet rs = null;
	/*
		SELECT * FROM emp
		WHERE emp_id = 'admin2'
		AND emp_pw = PASSWORD('1234');
	*/
	String sql = "select emp_id empId, emp_name empName, grade from emp where active='ON' and emp_id=? and emp_pw=password(?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, empId);
	stmt.setString(2, empPw);
	System.out.println(stmt);
	
	rs = stmt.executeQuery();
	
	// 성공시 emp/empList.jsp
	// 실패시 emp/empLoginForm.jsp
	if(rs.next()){
		System.out.println("로그인성공");
		//하나의 세션변수안에 여러개의 값을 저장하기 위해 HashMap타입을 사용
		HashMap<String, Object> loginEmp = new HashMap<String, Object>();
		//loginEmp는 세개의 값을 가지고 있음
		loginEmp.put("empId", rs.getString("empId"));
		loginEmp.put("empName", rs.getString("empName"));
		loginEmp.put("grade", rs.getInt("grade"));
		
		session.setAttribute("loginEmp", loginEmp);
		
		//디버깅(loginEmp 세션변수)
		HashMap<String, Object> m = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
		System.out.println((String)(m.get("empId"))); //로그인된 empId
		System.out.println((String)(m.get("empName"))); //로그인된 empName
		System.out.println((Integer)(m.get("grade"))); //로그인된 grade
		
		response.sendRedirect("/shop/emp/empList.jsp");
	}else{
		System.out.println("로그인실패");
		String errMsg = URLEncoder.encode("아이디와 비밀번호를 확인해주세요", "utf-8");
		response.sendRedirect("/shop/emp/empLoginForm.jsp?errMsg="+errMsg);
	}
	
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>empLoginAction</title>
</head>
<body>
	
</body>
</html>