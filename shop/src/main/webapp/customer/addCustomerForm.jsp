<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
/* 인증분기: 세션변수 이름 - loginEmp */
	
	//로그인이 이미 되어있으면 goodsList.jsp로 보냄
	if(session.getAttribute("loginCustomer") != null){ 
		response.sendRedirect("/shop/customer/customerGoodsList.jsp"); 
		return;
	}
%>
<%
	String msg = request.getParameter("msg");

	// 사용가능 메일 중복체크
	String chkMail = "";
	if(msg == null){
		msg = "";
		chkMail = "메일 중복체크를 해주세요.";
	}else if(msg.equals("invalid")){
		chkMail = "사용 불가능한 메일주소입니다.";
	}else{
		chkMail = request.getParameter("chkMail");
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>addCustomerForm</title>
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
		.addCustomerBtn{
			border: 2px dashed #737058;
			color: #444236;
		}
		.addCustomerInput{
			border: none;
			border-bottom: 3px dashed #5E3F36;
			background-color: transparent;
		}
	</style>
</head>
<body class="container fontContent text-center">
	<div class="row" style="position: relative; margin-top: 15%">
		<div class="col"></div>
		<div class="col-6" style="background-color: #E6D7BD; border: 3px dashed #5E3F36;">
		<div style="margin: 5%">
		<h1>회원가입</h1>
		<!-- 아이디 중복체크 -->
			<form method="post" action="/shop/customer/checkIdAction.jsp">
				<table style="margin-left:auto; margin-right:auto;">
					<tr>
						<td>메일 중복체크</td>
						<td><input type="email" name="chkMail" class="addCustomerInput"></td>
						<td>&nbsp;<button type="submit" class="btn addCustomerBtn">확인하기</button></td>
					</tr>
				</table>
			</form>
			<div>
			<%
				if(msg.equals("valid")){
			%>
					<div>사용 가능 한 메일주소입니다.<br>회원가입을 진행해주세요.</div>
			<%
				}else{
			%>
					<div><%=chkMail%></div>
			<%
				}
			%>
			</div><hr>
		
		<!-- 회원가입 -->
			<form method="post" action="/shop/customer/addCustomerAction.jsp">
				<table style="margin-left:auto; margin-right:auto;">
					<tr>
						<td>메일</td>
							<%
								if(msg.equals("valid")){
							%>
									<td><input class="addCustomerInput" type="email" value="<%=chkMail%>" readonly="readonly" name="cMail"></td>
							<%
								}else{
							%>
									<td><input class="addCustomerInput" type="email" value="" readonly="readonly"></td>
							<%		
								}
							%>
					</tr>
					<tr>
						<td>비밀번호</td>
						<td><input class="addCustomerInput" type="password" name="cPw"></td>
					</tr>
					<tr>
						<td>이름</td>
						<td><input class="addCustomerInput" type="text" name="cName"></td>
					</tr>
					<tr>
						<td>생년월일(8자리)</td>
						<td><input class="addCustomerInput" type="number" min="1" name="cBirth"></td>
					</tr>
					<tr>
						<td>성별</td>
						<td><br>
							<label for="Male">남자</label><input type="radio" id="Male" name="cGender" value="남">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<label for="Female">여자</label><input type="radio" id="Female" name="cGender" value="여">
						</td>
					</tr>
				</table><br>
				<button type="submit" class="btn addCustomerBtn">가입하기</button>
			</form>
			</div>
		</div>
	<div class="col"></div>
  </div>
</body>
</html>