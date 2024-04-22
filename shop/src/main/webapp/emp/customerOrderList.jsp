<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="shop.dao.OrderDAO"%>
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
	
	String msg = request.getParameter("msg");
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
		
		.divTitle{
			color: #444236; border-bottom: 2px double #5E3F36;
		}
		
		.divContent{
			color: #444236; border-bottom: 1px double #5E3F36;
		}
		
		.stateSelect{
			background-color: transparent;
			color: #ba0000;
			border: none;
			text-align: center;
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
				<%
					if(msg != null){
				%>
						<h5 class="text-center" style="color: #ba0000;"><%=msg%></h5><br>
				<%
					}
				%>
			</div>
			<div class="row text-center divTitle">
				<div class="col-1 fs-5" style="">주문번호</div>
				<div class="col-3 fs-5" style="">고객아이디</div>
				<div class="col fs-5" style="">주문상품</div>
				<div class="col fs-5" style="">총금액</div>
				<div class="col fs-5" style="">주문날짜</div>
				<div class="col fs-5" style="">주문상태변경</div>
			</div>
			<%
				for(HashMap o : orderList){
			%>
					<div class="row text-center divContent">
						<div class="col-1"><%=(Integer)o.get("ordersNo")%></div>
						<div class="col-3"><%=(String)o.get("cMail")%></div>
						<div class="col"><%=(String)o.get("goodsTitle")%> (총&nbsp;<%=(Integer)o.get("totalAmount")%>개)</div>
						<div class="col"><%=(Integer)o.get("totalPrice")%></div>
						<div class="col"><%=(String)o.get("createDate")%></div>
						<div class="col">
			<%
						// 주문완료/결제완료/배송중일때만 상태변경이 가능함
						String stateDone = (String)o.get("state");
						if(stateDone.equals("배송완료") || stateDone.equals("주문취소")){
			%>
							<%=(String)o.get("state")%>
			<%
						}else{
			%>
							<form action="/shop/emp/modifyStateOrderAction.jsp">
								<input type="hidden" value="<%=(Integer)o.get("ordersNo")%>" name="ordersNo">
								<input type="hidden" value="<%=(String)o.get("state")%>" name="oldState">
								<select class="stateSelect" name="newState" onchange="this.form.submit()">
									<option value="<%=(String)o.get("state")%>"><%=(String)o.get("state")%></option>
									<option value="주문완료">주문완료</option>
									<option value="결제완료">결제완료</option>
									<option value="배송중">배송중</option>
									<option value="배송완료">배송완료</option>
									<option value="주문취소">주문취소</option>
								</select>
							</form>
			<%
						}
			%>
						</div>
					</div>
			<%
				}
			%>
			<div>
			</div>
		</div>
		<div class="row" style="background-color: blue;">밑단</div>
	</div>
</div>	
</body>
</html>