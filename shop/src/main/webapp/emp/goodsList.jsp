<%@page import="shop.dao.GoodsDAO"%>
<%@page import="shop.dao.EmpDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!-- 여기부터는 Controller Layer -->
<%
/* 인증분기: 세션변수 이름 - loginEmp */
	//로그인이 안되어 있으면 emploginForm.jsp로 보냄
	if(session.getAttribute("loginEmp") == null){
		response.sendRedirect("/shop/emp/empLoginForm.jsp"); 
		return;
	}
%>
<%
/* 기본 페이징 및 변수가져오기 */
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 16; //한페이지에 보여줄 것
	int startRow = (currentPage-1)*rowPerPage;
	
	
	
	//카테고리가 null -> select * from goods 리밋이랑 오더바이도 추가!
	//카데고리가 null이아니면 -> select * from godds where category = ? 리밋이랑 오더바이도 추가!
	String category = request.getParameter("category");
	if(category == null){
		category = "";
	}
	System.out.println(category + " <--category goodsList.jsp");
%>
<%
/* categoryList 카테고리 조회 및 Count카테고리별 카운트 개수 */
	ArrayList<HashMap<String, Object>> categoryList = GoodsDAO.selectCategoryList();
	
	
/* goodsList 상품 목록 조회하기 */
	String nameScrh = request.getParameter("nameScrh"); //검색어
	if(nameScrh==null){
		nameScrh = "";
	}
	
	String selectRow = request.getParameter("selectRow");
	int selectRowInt = 0;
	if(selectRow == null){
		selectRowInt = 16;
	}else{
		selectRowInt = Integer.parseInt(selectRow);
	}
	
	ArrayList<HashMap<String, Object>> goodsList = GoodsDAO.selectGoodsList(category, nameScrh, startRow, selectRowInt);
	
	
/* goodsPaging 상품 목록 페이징 */
	int totalRow = 0;
	int lastPage = 0;
	ArrayList<HashMap<String, Integer>> goodsPaging = GoodsDAO.selectGoodsCnt(category, nameScrh, totalRow, selectRowInt);
 
	for(HashMap<String, Integer> paging : goodsPaging){
		totalRow = paging.get("totalRow");
		lastPage = paging.get("lastPage");
	}
%>
<%
	String msg = request.getParameter("msg");
%>
<!-- 여기부터는 View Layer -->
<!-- 모델(ArrayList<HashMap<String, Object>>)로 출력 -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>goodsList</title>
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
		
		.searchInput{
			border:none; border-bottom: 2px double #5E3F36; background-color: transparent;
		}
		
		.searchBtn{
			border: 2px solid #5E3F36; background-color: #E6D7BD; border-radius:10px;
		}
		
		.goodsBox{
			border: 2px dashed #737058; border-radius:5px; width: 260px; height:400px; margin: 5px; display: inline-block;
		}
		
		.addBtn{
			border: 2px dashed #737058; background-color: #E6D7BD; border-radius:10px;
		}
		
		.categoryList{
			border: 2px dashed #737058; background-color: #E6D7BD; border-radius:10px; margin-bottom: 10px;
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
			<br><h1 class="text-center">상품관리</h1><br>
			<%
				if(msg != null){
			%>
					<div class="text-center"><%=msg%></div><br>
			<%
				}
			%>
			
			<!-- 상품등록/카테고리별 (카운트) 및 선택 -->
			<div class="ms-3 text-center">
				<a href="/shop/emp/addGoodsForm.jsp" class="btn addBtn">상품 등록</a>&nbsp;&nbsp;&nbsp;
				<a href="/shop/emp/goodsList.jsp" class="btn categoryList">전체</a>&nbsp;&nbsp;&nbsp;
		<%
					for(HashMap m : categoryList) {
		%>
						<a href="/shop/emp/goodsList.jsp?category=<%=(String)(m.get("category"))%>" class="btn categoryList">
							<%=(String)(m.get("category"))%>
							(<%=(Integer)(m.get("cnt"))%>)
						</a>&nbsp;&nbsp;&nbsp;
		<%		
			}
		%>
			</div><br>
			
			<!-- 조회 뿌려주기 -->
			<div style="background-color: #E6D7BD; display: flex;">
			<div style="background-color: #E6D7BD; margin: auto;">
			<%
				int floatCnt = 1;
				for(HashMap<String, Object> m2 : goodsList){
					int price = (Integer)m2.get("goodsPrice");
					String price2 = String.format("%,d", price);
					
				if(floatCnt%4 == 0){
					//System.out.println("floatCnt%4 == 0 -> "+floatCnt);
		%>
				<div class="text-center goodsBox">
					<div>
						<a href="/shop/emp/goodsOne.jsp?goodsNo=<%=(Integer)m2.get("goodsNo")%>">
							<img src="/shop/upload/<%=(String)m2.get("filename")%>" style="width: 250px; height: 250px; border-radius:5px;">
						</a>
					</div><br>
					<div><%=(String)m2.get("goodsTitle")%></div><br>
					<div>금액: <%=price2%>원</div><br>
					<div>남은수량: <%=(Integer)m2.get("goodsAmount")%></div>
				</div>
				<div class="clear"></div>
		<%
				}else{
					//System.out.println("else-> "+floatCnt);
		%>
				
				<div class="text-center goodsBox">
					<div>
						<a href="/shop/emp/goodsOne.jsp?goodsNo=<%=(Integer)m2.get("goodsNo")%>">
							<img src="/shop/upload/<%=(String)m2.get("filename")%>" style="width: 250px; height: 250px; border-radius:5px;">
						</a>
					</div>
					<br>
					<div><%=(String)m2.get("goodsTitle")%></div><br>
					<div>금액: <%=price2%>원</div><br>
					<div>남은수량: <%=(Integer)m2.get("goodsAmount")%></div>
				</div>
				
		<%
				}
				floatCnt=floatCnt+1;
			}
		%>
			<br>
			<div style="clear: both; text-align: center;"><br>
				<form method="post" action="/shop/emp/goodsList.jsp?currentPage=1&category=<%=category%>">
					<input type="text" name="nameScrh" class="searchInput">&nbsp;&nbsp;<button type="submit" class="searchBtn">제목 검색</button>
				</form>
			</div><br>
			<div style="clear: both; text-align: center;">
		<%
				//이전 페이징 기능
				if(currentPage <= 1){
		%>
					<a style="color: #d1c3ac;">◀◀처음</a>
					<a style="color: #d1c3ac;">◀이전</a> 
		<%
				}else{
		%>
					<a href="/shop/emp/goodsList.jsp?currentPage=1&category=<%=category%>">◀◀처음</a>
					<a href="/shop/emp/goodsList.jsp?currentPage=<%=currentPage-1%>&category=<%=category%>&nameScrh=<%=nameScrh%>">◀이전</a> 
		<%
				}
		%>
		<%
				//다음 페이징 기능
				if(currentPage >= lastPage){
		%>
					<a style="color: #d1c3ac;">다음▶</a> 
					<a style="color: #d1c3ac;">마지막▶▶</a>
		<%
				}else{
		%>
					<a href="/shop/emp/goodsList.jsp?currentPage=<%=currentPage+1%>&category=<%=category%>&nameScrh=<%=nameScrh%>">다음▶</a>
					<a href="/shop/emp/goodsList.jsp?currentPage=<%=lastPage%>&category=<%=category%>">마지막▶▶</a>
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