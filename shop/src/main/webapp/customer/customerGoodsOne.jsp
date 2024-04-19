<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="shop.dao.GoodsDAO"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
/* 인증분기: 세션변수 이름 - loginEmp */
	
	//로그인정보가 없으면 로그인폼으로 보내기
	if(session.getAttribute("loginCustomer") == null){ 
		response.sendRedirect("/shop/customer/loginForm.jsp"); 
		return;
	}
%>
<%
	HashMap<String,Object> loginCustomer 
		= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
%>
<%
	int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
	System.out.println(goodsNo + " <--goodsNo CustomerGoodsOne상세보기");
	
	ArrayList<HashMap<String, Object>> goodsOne = GoodsDAO.goodsOne(goodsNo);
	
	String orderCxl = "order";
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>CustomerGoodsOne</title>
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
		.orderBtn{
			border: 2px dashed #737058; background-color: #E6D7BD; border-radius:10px;
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
		<jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>
		
		<!-- 메인 -->
		<div class="col-10" style="background-color: #E6D7BD; border: 3px dashed #5E3F36; border-radius:10px; color: #444236;">
			<br><h1 class="text-center">상품 상세보기</h1><br>
			<div style="background-color: #E6D7BD; display: flex;">
			<div style="background-color: #E6D7BD; margin: auto;">
				<%
					for(HashMap<String, Object> g : goodsOne){
				%>
						<div class="row">
								<div class="col" style="float: left;">
									<img src="/shop/upload/<%=(String)g.get("filename")%>" style="border: 2px dashed #737058; border-radius:5px; width: 600px; height: 600px; margin-right: 10px;">
								</div>
								<div class="col" style="float: right; width: 600px">
									<div style="border-bottom:2px dashed #737058;">[상품번호&카테고리] <%=(Integer)g.get("goodsNo")%>&<%=(String)g.get("category")%></div><br>
									<div style="border-bottom:2px dashed #737058;">[등록사원] <%=(String)g.get("empId")%></div><br>
									<div style="border-bottom:2px dashed #737058;">[수정날짜]<%=(String)g.get("updateDate")%></div><br>
									<div style="border-bottom:2px dashed #737058;">[가격] <%=(Integer)g.get("goodsPrice")%></div><br>
									<div style="border-bottom:2px dashed #737058;">[수량] <%=(Integer)g.get("goodsAmount")%></div><br>
									<div style="border-bottom:2px dashed #737058;">[제목] <%=(String)g.get("goodsTitle")%></div><br>
									<div style="border-bottom:2px dashed #737058;">[내용] <%=(String)g.get("goodsContent")%></div>
									<br><br>												
									<div class="text-center">
										<form method="post" action="/shop/customer/ordersGoodsAction.jsp?&orderCxl=<%=orderCxl%>">
											<table>
												<tr>
													<td>상품 주문 수량</td>
													<td><input type="number" name="orderAmount"></td>
												</tr>
												<tr>
													<td>배송지</td>
													<td><input type="text" name="address"></td>
												</tr>
											</table>
											
											<input type="hidden" name="goodsNo" value="<%=goodsNo%>">
											<input type="hidden" name="goodsAmount" value="<%=(Integer)g.get("goodsAmount")%>">
											<input type="hidden" name="goodsPrice" value="<%=(Integer)g.get("goodsPrice")%>"><br>
											<button class="btn orderBtn">상품 주문하기</button>
										</form>
									</div>
								</div>
							</div>
				<%	
					}
				%>
				</div>
			</div>
		</div>
	</div>
	<div class="row" style="background-color: blue;">밑단</div>
</div>
</body>
</html>