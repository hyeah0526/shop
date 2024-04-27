<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="shop.dao.CustomerDAO"%>
<%@ page import="java.util.*" %>
<%
/* 인증분기: 세션변수 이름 - loginEmp */
	if(session.getAttribute("loginCustomer") == null){ 
		response.sendRedirect("/shop/customer/loginForm.jsp"); 
		return;
	}
%>
<%
	HashMap<String,Object> loginCustomer 
		= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));;
%>
<%
	// 로그인한 Customer 가져오기
	String cMail = request.getParameter("cMail");
	
	// 로그인한 회원정보 가져오는 DAO
	HashMap<String, String> customerOne = CustomerDAO.customerOne(cMail);
	
	String cName = customerOne.get("cName");
	String cBirth = customerOne.get("cBirth");
	String cGender = customerOne.get("cGender");
	System.out.println(cName+" <-- cName modifyCustomer.jsp");
	System.out.println(cBirth+" <-- cBirth modifyCustomer.jsp");
	System.out.println(cGender+" <-- cGender modifyCustomer.jsp");
	
	// 수정실패시 에러msg
	String msg = request.getParameter("msg");
	System.out.println(msg+" <--msg modifyCustomer.jsp");
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>modifyCustomer</title>
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
		.modifyBtn{
			border: 2px dashed #737058; background-color: #E6D7BD; border-radius:10px;
		}
	</style>
</head>
<body class="container fontContent text-center">
	<div class="row" style="position: relative; margin-top: 15%">
		<div class="col"></div>
		<div class="col-6" style="background-color: #E6D7BD; border: 3px dashed #5E3F36;">
			<div style="margin: 5%">
				<h1>회원 정보수정</h1>
				<%
					if(msg != null){
				%>
						<div><%=msg%></div><br>
				<%
					}
				%>
				<!-- 비밀번호 수정 -->
				<form method="post" action="/shop/customer/modifyCustomerAction.jsp">
					<table style="margin-left:auto; margin-right:auto;">
						<tr>
							<td>메일</td>
							<td>
								<input type="hidden" name="cMail" value="<%=cMail%>">
								<%=cMail%>
							</td>
						</tr>
						<tr>
							<td>이름</td>
							<td><%=cName%></td>
						</tr>
						<tr>
							<td>생년월일/성별</td>
							<td><%=cBirth%> / <%=cGender%></td>
						</tr>
						<tr>
							<td>원래 비밀번호</td>
							<td><input type="password" name="cOldPw" style="border:none; border-bottom: 2px dashed #737058; background-color: transparent;"></td>
						</tr>
						<tr>
							<td>변경할 비밀번호</td>
							<td><input type="password" name="cNewPw" style="border:none; border-bottom: 2px dashed #737058; background-color: transparent;"></td>
						</tr>
					</table><br>
					<button type="submit" class="btn modifyBtn">비밀번호 변경</button><br>
				</form><br>
			
				<!-- 회원탈퇴 -->
				<form action="/shop/customer/deleteCustomerAction.jsp" method="post">
					<h1>회원 탈퇴</h1>
					비밀번호 확인: <input type="password" name="cPw" style="border:none; border-bottom: 2px dashed #737058; background-color: transparent;">
					<input type="hidden" name="cMail" value="<%=cMail%>">
					<button type="submit" class="btn modifyBtn">탈퇴하기</button>
				</form>
			</div>
		</div>
		<div class="col"></div>
	</div>
</body>
</html>