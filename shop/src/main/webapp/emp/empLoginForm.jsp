<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	String errMsg = request.getParameter("errMsg");
	System.out.println(errMsg+" <-- errMsg empLoginForm.jsp");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>empLoginForm</title>
</head>
<body>
	<%
		if(errMsg != null){
	%>
			<div><%=errMsg%></div><br>
	<%
		}
	%>	
	<form action="/shop/emp/empLoginAction.jsp">
		<div>
			아이디<input type="text" name="empId"><br>
			비번<input type="password" name="empPw"><br>
			<button type="submit">제출</button>
		</div>
	</form>
</body>
</html>