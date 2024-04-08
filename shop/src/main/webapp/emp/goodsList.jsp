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
	/* 페이징 */
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

<!-- 여기부터는 Model Layer -->
<%
	/* Count 카테고리별 카운트 캐수 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null; 

	String sql1 ="SELECT category, COUNT(*) cnt FROM goods GROUP BY category ORDER BY category asc";
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	//System.out.println(stmt1);
	
	ArrayList<HashMap<String, Object>> categoryList = new ArrayList<HashMap<String, Object>>();
	while(rs1.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("category", rs1.getString("category"));
		m.put("cnt", rs1.getInt("cnt"));
		categoryList.add(m);
	}
	//디버깅
	System.out.println(categoryList);
	
	/* 상품조회하기 */
	//검색어
	String nameScrh = request.getParameter("nameScrh");
	if(nameScrh==null){
		nameScrh = "";
	}
	System.out.println(nameScrh+" <--nameScrh 상품관리");
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null; 
	String sql2 = "SELECT * FROM goods where category LIKE ? and goods_title LIKE ? ORDER BY update_date desc limit ?, ?";
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, "%"+category+"%");
	stmt2.setString(2, "%"+nameScrh+"%");
	stmt2.setInt(3, startRow);
	
	String selectRow = request.getParameter("selectRow");
	int selectRowInt = 0;
	
	if(selectRow == null){
		selectRowInt = 16;
		stmt2.setInt(4, selectRowInt);
	}else{
		selectRowInt = Integer.parseInt(selectRow);
		stmt2.setInt(4, selectRowInt);
	}
	System.out.println(selectRow+" <--selectRow");
	
	rs2 = stmt2.executeQuery();
	System.out.println(stmt2);
	
	ArrayList<HashMap<String, Object>> goodsList = new ArrayList<HashMap<String, Object>>();
	while(rs2.next()){
		HashMap<String, Object> m2 = new HashMap<String, Object>();
		m2.put("goodsNo", rs2.getInt("goods_no"));
		m2.put("category", rs2.getString("category"));
		m2.put("empId", rs2.getString("emp_id"));
		m2.put("goodsTitle", rs2.getString("goods_title"));
		m2.put("goodsContent", rs2.getString("goods_content"));
		m2.put("goodsPrice", rs2.getInt("goods_price"));
		m2.put("goodsAmount", rs2.getInt("goods_amount"));
		m2.put("updateDate", rs2.getString("update_date"));
		m2.put("filename", rs2.getString("filename"));
		goodsList.add(m2);
	}
	//디버깅
	//System.out.println(goodsList);
	
	/* 페이징 */
		String sql3 = "select count(*) cnt from goods where category like ? and goods_title LIKE ?";
		PreparedStatement stmt3 = null;
		ResultSet rs3 = null; 
		stmt3 = conn.prepareStatement(sql3);
		stmt3.setString(1, "%"+category+"%");
		stmt3.setString(2, "%"+nameScrh+"%");
		rs3 = stmt3.executeQuery();
		
		System.out.println(stmt3);
		
		int totalRow = 0;
		if(rs3.next()){
			totalRow = rs3.getInt("cnt");
		}
		
		
		int lastPage = totalRow / selectRowInt;
		if(totalRow % selectRowInt != 0){
			lastPage = lastPage+1;
		}
		System.out.println(lastPage+" <--lastPage empList.jsp");
		System.out.println(totalRow+" <--totalRow empList.jsp");
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
	</style>
</head>
<body class="fontContent">
<div class="" style="margin: 50px;">
	<div class="row" style="background-color: #E6D7BD; border: 3px dashed #5E3F36; margin-bottom: 10px;"><img src="/shop/emp/img/logo3.png" style="width: 200px; margin: auto;"></div>

	<div class="row">
		<!-- 왼쪽메뉴나오는 곳 -->
		<!-- empMenu.jsp include : 주체(서버) vs redirect(주체:클라이언트) -->
		<!-- 주체가 서버이기 때문에 include할때는 절대주소가 /shop으로 시작하는게 아니라 /emp부터 시작 -->
		<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
		
		<!-- 메인 -->
		<div class="col-10" style="background-color: #E6D7BD; border: 3px dashed #5E3F36; border-radius:10px; color: #444236;">
			<h1 class="text-center">상품관리</h1>
			<%
				if(msg != null){
			%>
					<div><%=msg%></div>
			<%
				}
			%>
			<div><a href="/shop/emp/addGoodsForm.jsp">등록하기</a></div>
			<!-- 카테고리별 (카운트) 및 선택 -->
			<div>
				<a href="/shop/emp/goodsList.jsp">전체</a>&nbsp;
		<%
					for(HashMap m : categoryList) {
		%>
						<a href="/shop/emp/goodsList.jsp?category=<%=(String)(m.get("category"))%>">
							<%=(String)(m.get("category"))%>
							(<%=(Integer)(m.get("cnt"))%>)
						</a>&nbsp;
		<%		
			}
		%>
			</div>
			
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
				<div class="text-center" style="border: 2px dashed #737058; border-radius:5px; width: 260px; height:400px; margin: 5px; display: inline-block;">
					<div>
						<a href="/shop/emp/goodsOne.jsp?goodsNo=<%=(Integer)m2.get("goodsNo")%>">
							<img src="/shop/upload/<%=(String)m2.get("filename")%>" style="width: 250px; height: 250px; border-radius:5px;">
						</a>
					</div><br>
					<div><%=(String)m2.get("goodsTitle")%></div><br>
					<div>금액: <%=price2%>원</div><br>
					<a href="/shop/emp/removeGoodsAction.jsp?goodsNo=<%=(Integer)m2.get("goodsNo")%>&filename=<%=(String)m2.get("filename")%>">상품 삭제</a>
				</div>
				<div class="clear"></div>
		<%
				}else{
					//System.out.println("else-> "+floatCnt);
		%>
				
				<div class="text-center" style="border: 2px dashed #737058; border-radius:5px; width: 260px; height:400px; margin: 5px; float: left;">
					<div>
						<a href="/shop/emp/goodsOne.jsp?goodsNo=<%=(Integer)m2.get("goodsNo")%>">
							<img alt="" src="/shop/upload/<%=(String)m2.get("filename")%>" style="width: 250px; height: 250px; border-radius:5px;">
						</a>
					</div>
					<br>
					<div><%=(String)m2.get("goodsTitle")%></div><br>
					<div>금액: <%=price2%>원</div><br>
					<a href="/shop/emp/removeGoodsAction.jsp?goodsNo=<%=(Integer)m2.get("goodsNo")%>&filename=<%=(String)m2.get("filename")%>">상품 삭제</a>
				</div>
				
		<%
				}
				floatCnt=floatCnt+1;
			}
		%>
			<br>
			<div style="clear: both; text-align: center;">
				<form method="post" action="/shop/emp/goodsList.jsp?currentPage=1&category=<%=category%>">
					<input type="text" name="nameScrh">&nbsp;&nbsp;<button type="submit">제목 검색</button>
				</form>
			</div><br>
			<div style="clear: both; text-align: center;">
		<%
				//이전 페이징 기능
				if(currentPage <= 1){
		%>
					<a>◀◀처음</a>
					<a>◀이전</a> 
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
					<a>다음▶</a> 
					<a>마지막▶▶</a>
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