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
	<!-- 부트스트랩 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	<style>
		/* 런드리고딕 */
		@font-face {
		    font-family: 'TTLaundryGothicB';
		    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/2403-2@1.0/TTLaundryGothicB.woff2') format('woff2');
		    font-weight: 400;
		    font-style: normal;
		}
		.fontContent{
			font-family: 'TTLaundryGothicB';
			background-color: #737058;
			color: #444236;
		}
		a { text-decoration: none; color: #444236;}
		a:hover { color:#444236; }
		a:visited { text-decoration: none;}
		
		.loginPageBtn{
			border: 2px dashed #737058;
			color: #444236;
		}
		
		#empLoginForm{
			margin-left:auto; margin-right:auto;
		}
		
		#empLoginForm td{
			width: 100px; text-align: center;
		}
		
		#empLoginForm input{
			width:200px; border:none; border-bottom: 3px dashed #5E3F36; background-color: transparent;
		}
	</style>
</head>
<body class="container fontContent text-center">
	<div class="row" style="position: relative; margin-top: 15%;">
		<div class="col"></div>
		<div class="col-6" style="background-color: #E6D7BD; border: 3px dashed #5E3F36;">
			<div style="margin: 5%">
				<h1>직원용 로그인</h1>
				<%
					if(errMsg != null){
				%>
						<div><%=errMsg%></div><br>
				<%
					}
				%>	
				<form method="post" action="/shop/emp/empLoginAction.jsp">
				
					<table id="empLoginForm">
						<tr>
							<td>메일주소</td>
							<td><input type="text" name="empId" value="admin_emp"></td>
						</tr>
						<tr>
							<td>비밀번호</td>
							<td><input type="password" name="empPw" value="1234"></td>
						</tr>
					</table><br>
					<button type="submit" class="btn loginPageBtn">로그인</button>
				</form><br>
				<div>
					<a href="/shop/customer/loginForm.jsp" class="btn loginPageBtn">고객 페이지로 이동</a>
				</div>
		</div>
	</div>
	<div class="col"></div>
	</div>
</body>
</html>