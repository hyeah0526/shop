<%@page import="shop.dao.OrderDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
/* 인증분기: 세션변수 이름 - loginEmp */
	if(session.getAttribute("loginEmp") == null){
		response.sendRedirect("/shop/emp/empLoginForm.jsp"); 
		return;
	}
%>
<%
	ArrayList<HashMap<String, Object>> orderList = OrderDAO.selectOrderList();

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>customerOrderList</title>
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
		}
		a { text-decoration: none; color: #444236;}
		a:hover { color:#444236; }
		a:visited { text-decoration: none;}
		 
		 .mainBox{
			background-color: #E6D7BD; border: 3px dashed #5E3F36; color: #444236; border-radius:10px;
		}
		
		.addModifyInput{
			border:none; border-bottom: 2px double #5E3F36; background-color: transparent;
		}
		
		.addModifyBtn{
			border: 2px solid #5E3F36; background-color: #E6D7BD; border-radius:10px;
		}
		
		.addModifyBtn:hover { 
			background-color: #737058;
		}
	</style>
</head>
<body class="fontContent">
<div class="" style="margin: 50px;">
	<!-- 위쪽 타이틀 -->
	<jsp:include page="/emp/inc/empTitle.jsp"></jsp:include>

	<div class="row">
		<!-- 왼쪽메뉴나오는 곳 -->
		<!-- empMenu.jsp include : 주체(서버) vs redirect(주체:클라이언트) -->
		<!-- 주체가 서버이기 때문에 include할때는 절대주소가 /shop으로 시작하는게 아니라 /emp부터 시작 -->
		<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
		
		<!-- 메인 -->
		<div class="col-10 mainBox">
			<br><h1 class="text-center">고객 주문관리</h1><br>
			<div>
				<table style="border: 1px solid black;">
					<tr>
						<th>주문번호</th>
						<th>고객아이디</th>
						<th>주문상품</th>
						<th>총금액</th>
						<th>주문날짜</th>
						<th>주문상태</th>
					</tr>
				<%
					for(HashMap o : orderList){
				%>
						<tr>
							<td><%=(Integer)o.get("ordersNo")%></td>
							<td><%=(String)o.get("cMail")%></td>
							<td><%=(String)o.get("goodsTitle")%></td>
							<td><%=(Integer)o.get("toterPrice")%></td>
							<td><%=(String)o.get("createDate")%></td>
							<td><%=(String)o.get("state")%></td>
						<tr>
				<%
					}
				%>
				</table>
			</div>
		</div>
		<div class="row" style="background-color: blue;">밑단</div>
	</div>
</div>	
</body>
</html>