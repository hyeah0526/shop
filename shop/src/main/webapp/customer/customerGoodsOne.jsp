<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="shop.dao.CommentDAO"%>
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

	String cMail = (String)loginCustomer.get("cMail");
	String cName = (String)loginCustomer.get("cName");
	//System.out.println(cMail);
	//System.out.println(cName);
%>
<%
	int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
	System.out.println(goodsNo + " <--goodsNo CustomerGoodsOne상세보기");
	
	
	// 굿즈 ONE 상세보기
	ArrayList<HashMap<String, Object>> goodsOne = GoodsDAO.goodsOne(goodsNo);
	
	// 주문인지 취소인지 구분
	String orderCxl = "order";
	
	// 후기목록 뿌려주기
	ArrayList<HashMap<String, Object>> reviewList = CommentDAO.selectComment(goodsNo);
	
	// 후기작성가능 확인여부 (결과값: 작성불가 -> impossible / 작성가능 -> possible)
	String chkReview = CommentDAO.reviewChk(cMail, goodsNo);
	//System.out.println(chkReview + " <--chkReview customerGoodsOne.jsp");
	
	// MyOrders orders_no랑 state가져오기
	HashMap<String, Object> myOrdersInfo = CommentDAO.myOrdersNo(goodsNo, cMail);
	System.out.println(myOrdersInfo + " <--myOrdersNo customerGoodsOne.jsp");
	
	int myOrdersNo = (Integer)myOrdersInfo.get("ordersNo");
	String stateChk = (String)myOrdersInfo.get("state");
	
	System.out.println(myOrdersNo + " <--myOrdersNo customerGoodsOne.jsp");
	System.out.println(stateChk + " <--stateChk customerGoodsOne.jsp");
	
	// chkReview가 possible작성가능하고, ordersNo가 있으면서 state가 '배송완료'면 리뷰작성이 가능
	//if(chkReview.equals("possible") && myOrdersNo != 0 && stateChk.equals("배송완료")){
	//	chkReview = "possibleWrite";
	//} 
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
					/* 상세보기 */
					for(HashMap<String, Object> g : goodsOne){
				%>
						<div class="row">
								<div class="col" style="float: left;">
									<img src="/shop/upload/<%=(String)g.get("filename")%>" style="border: 2px dashed #737058; border-radius:5px; width: 600px; height: 600px; margin-right: 10px;">
								</div>
								<div class="col" style="float: right; width: 600px">
									<br><br><br>
									<div style="border-bottom:2px dashed #737058;">[상품번호&카테고리] <%=(Integer)g.get("goodsNo")%>&<%=(String)g.get("category")%></div><br>
									<div style="border-bottom:2px dashed #737058;">[가격] <%=(Integer)g.get("goodsPrice")%></div><br>
									<div style="border-bottom:2px dashed #737058;">[수량] <%=(Integer)g.get("goodsAmount")%></div><br>
									<div style="border-bottom:2px dashed #737058;">[제목] <%=(String)g.get("goodsTitle")%></div><br>
									<div style="border-bottom:2px dashed #737058;">[내용] <%=(String)g.get("goodsContent")%></div>
									<br><br><br><br>										
									<div class="text-center" style="border: 2px dashed #737058; border-radius: 5px; padding: 10px;">
										<!-- 상품주문 -->
										<h2>상품 주문하기</h2>
										<form method="post" action="/shop/customer/ordersGoodsAction.jsp?&orderCxl=<%=orderCxl%>">
											<table style="margin-left: auto; margin-right: auto;">
												<tr>
													<td>주문 수량</td>
													<td style="text-align:left;"><input type="number" name="orderAmount" style="border:none; border-bottom: 2px dashed #737058; background-color: transparent;">개</td>
												</tr>
												<tr>
													<td>배송지</td>
													<td style="text-align:left;"><input type="text" name="address" style="border:none; border-bottom: 2px dashed #737058; background-color: transparent;"></td>
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
				<br><Br>
			<!-- 상품을 주문한 이력이 있다면 후기 작성이 가능 -->
				<div class="">
					<h2>상품후기</h2>
					<%
						if(stateChk.equals("배송완료")){
					%>
							<form method="post" action="/shop/customer/addOrderReviewAction.jsp">
								<input type="hidden" value="<%=cMail%>" name="cMail">
								<input type="hidden" value="<%=goodsNo%>" name="goodsNo">
								<input type="hidden" value="<%=myOrdersNo%>" name="myOrdersNo">
								<div style="float: left;">
									별점&nbsp;<select name="score">
										<option value="1">1</option>
										<option value="2">2</option>
										<option value="3">3</option>
										<option value="4">4</option>
										<option value="5">5</option>
										<option value="6">6</option>
										<option value="7">7</option>
										<option value="8">8</option>
										<option value="9">9</option>
										<option value="10">10</option>
									</select>
								</div>
								<div style="float: left;">
									&nbsp;<textarea name="content" maxlength="100" style="width: 500px; height: 70px;" placeholder="후기작성(최대100자)"></textarea></div>
								<div style="float: left;">&nbsp;
								<button class="" style="margin-top: 20px;">작성하기</button></div>
							</form>
					<%
						}else if(chkReview.equals("impossible")){
					%>
							<div>이미 리뷰가 작성완료되었습니다.</div>
					<%
						}else if(stateChk.equals("주문완료") || stateChk.equals("결제완료") || stateChk.equals("배송중")){
					%>
							<div>아직 배송이 완료되지 않아 리뷰를 작성할 수 없습니다.</div>
					<%
						}else{
					%>
							<div>구매고객만 리뷰를 작성할 수 있습니다.</div>
					<%
						}
					%>
				</div>
			<!-- 상품 후기 리스트 -->
				<div style="clear: both;">
					<%
						for(HashMap r : reviewList){
							String star = "&#11088;";
					%>
							<div class="text-center" style="float: left; width: 300px; height: 300px; border: 2px dashed #737058; border-radius: 5px; padding: 10px; margin: 10px;">
								<%=star.repeat((Integer)r.get("score"))%><br>
								<%=(String)r.get("content")%><br>
								상품구매: <%=(String)r.get("orderCreateDate")%><br><br>
								<%=(String)r.get("cName")%><br>
								리뷰등록: <%=(String)r.get("commentCreateDate")%><br>
								<%
									if(cName.equals((String)r.get("cName"))){
								%>
										<form method="post" action="/shop/customer/deleteMyReviewAction.jsp">
											<input type="hidden" name="cMail" value="<%=cMail%>">
											<input type="hidden" name="goodsNo" value="<%=goodsNo%>">
											<input type="hidden" name="ordersNo" value="<%=(Integer)r.get("ordersNo")%>">
											<button class="btn" style="color: #ba0000;">리뷰삭제</button>
										</form>
								<%
									}
								%>
							</div>
							
					<%	
						}
					%>
				</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row" style="background-color: blue;">밑단</div>
</div>
</body>
</html>