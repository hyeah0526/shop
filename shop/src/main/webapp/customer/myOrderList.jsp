<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="shop.dao.OrderDAO"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
/* 인증분기: 세션변수 이름 - loginEmp */
	if(session.getAttribute("loginCustomer") == null){ 
		response.sendRedirect("/shop/customer/loginForm.jsp"); 
		return;
	}

	HashMap<String,Object> loginCustomer 
		= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
	String cMail = (String)loginCustomer.get("cMail");
	//System.out.println(cMail+" <--cName myOrderList.jsp");
%>
<%
	// 현제 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){ // null이 아니면 currentpage를 그 숫자로 변경 
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage + "<--currentPage myOrderList.jsp");
	
	// 한페이지당 보여줄 수 
	String selectRow = request.getParameter("selectRow  myOrderList.jsp");
	int selectRowInt = 0;
		
	if(selectRow == null){
		selectRowInt = 10;
	}else{
		selectRowInt = Integer.parseInt(selectRow);
	}
	System.out.println(selectRowInt + "<--selectRowInt  myOrderList.jsp");
		
	// 페이지당 시작할 row
	int startRow = (currentPage-1) * selectRowInt; // 첫번째페이지면 0*selectRowInt = 0이고 두번째면 1*selectRowInt
	System.out.println(startRow + "<--startRow  myOrderList.jsp");
	
	// 총 주문갯수 row
	int myOrderListRow = OrderDAO.myOrderListRow(cMail);
	System.out.println(myOrderListRow + "<--totalOrderListRow  myOrderList.jsp");
		
	// 마지막페이지
	int lastPage = myOrderListRow / selectRowInt;
		
	if(myOrderListRow % selectRowInt != 0){
		lastPage = lastPage+1;
	}
	System.out.println(lastPage + "<--lastPage  myOrderList.jsp");

	// 고객 본인이 주문한 상품 가져오기
	ArrayList<HashMap<String, Object>> myOrder = OrderDAO.myOrderOne(cMail, startRow, selectRowInt);
	//System.out.println(myOrder);
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>myOrderList</title>
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
		    color: #444236;
		}
		.fontContent{
			font-family: 'TTLaundryGothicB';
			background-color: #737058;
			color: #444236;
		}
		
		a { text-decoration: none; color: #444236;}
		a:hover { color:#444236; }
		a:visited { text-decoration: none;}
		
		.orderBtn{
			border: 2px dashed #737058; background-color: #E6D7BD; border-radius:10px;
		}
		
		.divContent{
			border-bottom: 1px dashed #444236; 
			margin: 5px;
			align-items: center;
			color: #444236;
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
			<br><h1 class="text-center">내 주문보기</h1>
				<h6 class="text-center">
					- 고객님의 배송이 완료된 후 후기 작성이 가능합니다.<br>
					- 주문완료 및 결제완료일 때만 취소가 가능합니다.<br>
					- 특정 사유로 인한 취소 및 환불요청은 고객센터로 문의부탁드립니다. <br>
				</h6><br>
			<div style="background-color: #E6D7BD; display: flex;">
			<div style="background-color: #E6D7BD; margin: auto; width: 100%">
				<table style="margin: auto; width: inherit;" class="text-center">
					<tr style="border-bottom: 3px double #444236; color: #444236;">
						<th class="fs-5">주문번호</th>
						<th class="fs-5">주문수량</th>
						<th class="fs-5">총금액</th>
						<th class="fs-5">배송주소</th>
						<th class="fs-5">주문날짜</th>
						<th class="fs-5">주문상태</th>
						<th class="fs-5">후기</th>
						<th class="fs-5">취소하기</th>
					</tr>
				<%
					// 고객 본인 주문 전체목록보기
					for(HashMap<String, Object> g : myOrder){
				%>
					<tr class="divContent">
						<td><%=(Integer)g.get("ordersNo")%></td>
						<td><%=(Integer)g.get("totalAmount")%></td>
						<td><%=(Integer)g.get("totalPrice")%></td>
						<td><%=(String)g.get("address")%></td>
						<td><%=(String)g.get("createDate")%></td>
						<td><%=(String)g.get("state")%></td>
						<td>
						<%
							// 배송완료일때만 후기 작성이 가능
							if(g.get("state").equals("배송완료")){
						%>
								<a href="/shop/customer/customerGoodsOne.jsp?goodsNo=<%=g.get("goodsNo")%>">작성하기</a>
						<%
							}else{
						%>
								  X
						<%
							}
						%>
						</td>
						<%
							//state가 주문완료 혹은 결제완료이면 취소가능
							String state = (String)g.get("state");
							if(state.equals("주문완료") || state.equals("결제완료")){
						%>
								<td>
									<form method="post" action="/shop/customer/cancelMyOrdersAction.jsp">
										<input type="hidden" value="<%=g.get("goodsNo") %>" name="goodsNo">
										<input type="hidden" value="<%=g.get("ordersNo") %>" name="ordersNo">
										<input type="hidden" value="<%=g.get("totalAmount") %>" name="totalAmount">
										<input type="hidden" value="<%=g.get("totalAmount") %>" name="goodsAmount">
										<button>취소하기</button>
									</form>
								</td>
						<%
							}else{
						%>
								<td>X</td>
						<%
							}
						%>
					</tr>	
				<%
					}
				%>
				</table>
			</div>
			</div><br>
			
			<!-- 페이징  -->
			<div>
			<%
				//이전 페이지 기능
				if(currentPage <= 1){
			%>
					<a style="color: #d1c3ac;">◀이전</a> 
			<%
				}else{
			%>
					<a href="/shop/customer/myOrderList.jsp?currentPage=<%=currentPage-1%>">◀이전</a> 
			<%
				}
			%>
			<%
				//다음 페이징 기능
				if(currentPage >= lastPage){
			%>
					<a style="color: #d1c3ac;">다음▶</a> 
			<%
				}else{
			%>
					<a href="/shop/customer/myOrderList.jsp?currentPage=<%=currentPage+1%>">다음▶</a>
			<%
				}
			%>
			</div>
		</div>
	</div>
	<!-- Footer설정 -->
	<jsp:include page="/emp/inc/empFooter.jsp"></jsp:include>
</div>
</body>
</html>