<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
/* 인증분기: 세션변수 이름 - loginEmp */
	String loginEmp = (String)session.getAttribute("loginEmp"); 
	System.out.println(loginEmp+" <-- loginEmp empLoginForm.jsp"); // 로그인한적이 없으면 null이 들어감
	
	//로그인이 안되어 있으면 emploginForm.jsp로 보냄
	if(session.getAttribute("loginEmp") == null){
		response.sendRedirect("/shop/emp/empLoginForm.jsp"); 
		return;
	}
%>

<%
/* 사원목록 보여주기 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	/* 비밀번호 빼고 전부 조회
	select emp_id empId, emp_name empName, emp_job empJob, hire_date hireDate, active
	from emp
	order by active asc, hire_date desc
	*/
	
	String sql = "select emp_id empId, emp_name empName, emp_job empJob, hire_date hireDate, active from emp order by active asc, hire_date desc";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>empList</title>
	<!-- 부트스트랩 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</head>
<body>
	<h1>사원 목록</h1>
	<form action="/shop/emp/empLogout.jsp">
		<div><button type="submit">로그아웃</button></div>
	</form><hr>
	<%
		while(rs.next()){
	%>	
			<div>empId : <%=rs.getString("empId")%></div>
			<div>empName: <%=rs.getString("empName")%></div>
			<div>empJob: <%=rs.getString("empJob")%></div>
			<div>hireDate: <%=rs.getString("hireDate")%></div>
			<div>Active: <%=rs.getString("active")%></div>
	<%
			if(loginEmp.equals("admin")){
	%>
	<%
				if(rs.getString("Active").equals("ON")){
	%>
					<div><a href="/shop/emp/modifyEmpActive.jsp?empId=<%=rs.getString("empId")%>&active=<%=rs.getString("active")%>">OFF로 변경하기</a></div><br>
	<%		
				}else{
	%>
					<div><a href="/shop/emp/modifyEmpActive.jsp?empId=<%=rs.getString("empId")%>&active=<%=rs.getString("active")%>">ON으로 변경하기</a></div><br>
	<%			
				}
			}else{
	%>
				<br>
	<%
			}
		}
	%>
	<br>
	
<hr>
<div class="container">
	<div class="row" style="background-color: yellow;">
		<div class="col">왼쪽메뉴</div>
		<div class="col-10">메인</div>
	</div>
	<div class="row" style="background-color: blue;">3</div>
</div>
</body>
</html>