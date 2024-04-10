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
	String msg = request.getParameter("msg");
	
	/* 전체 카테고리 목록 뿌려주기 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null; 
	
	String sql1 ="SELECT category, create_date createDate FROM category";
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	//System.out.println(stmt1);
	
	ArrayList<HashMap<String, Object>> categoryList = new ArrayList<>();
	while(rs1.next()){
		HashMap<String, Object> m = new HashMap<>();
		m.put("category", rs1.getString("category"));
		m.put("createDate", rs1.getString("createDate"));
		categoryList.add(m);
	}
	//System.out.println(categoryList);
	
	
	
	/* 수정값 가져오기 */
	String category = request.getParameter("category");
	String createDate = request.getParameter("createDate");
	//System.out.println(category + " <-- category categoryList.jsp");
	//System.out.println(createDate + " <-- createDate categoryList.jsp");
	
	/* 추가값 가져오기 */
	String addCategory = request.getParameter("addCategory");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>categoryList</title>
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
		<div class="col-10" style="background-color: #E6D7BD; border: 3px dashed #5E3F36; border-radius:10px; color: #444236;">
			<h1 class="text-center">카테고리 관리</h1>
			<!-- 카테고리 추가하기 -->
			<div>
				<form action="/shop/emp/addCategoryAction.jsp">
					<input type="text" name="category">
					<button>카테고리 추가하기</button>
				</form>
			</div><br>
			
			<!-- 삭제/추가/수정 메시지 보여주기 -->
			<%
				if(msg != null){
			%>
					<div><%=msg%></div><br>
			<%
				}
			%>
			
			<!-- 전체 카테고리 목록 보여주기 -->
			<div class="row text-center" style="color: #444236; border-bottom: 2px double #5E3F36;">
				<div class="col fs-5" style="">카테고리</div>
				<div class="col fs-5" style="">생성날짜</div>
				<div class="col fs-5" style="">수정</div>
				<div class="col fs-5" style="">삭제</div>
			</div>
			
			<%
				for(HashMap m : categoryList){
			%>
					<div class="row text-center" style="border-bottom: 1px dashed #5E3F36;">
						<div class="col"><a><%=m.get("category")%></a></div>
						<div class="col"><a><%=m.get("createDate")%></a></div>
						<div class="col"><a href="/shop/emp/categoryList.jsp?category=<%=m.get("category")%>">수정하기</a></div>
						<div class="col"><a href="/shop/emp/removeCategoryAction.jsp?category=<%=m.get("category")%>">삭제하기</a></div>
					</div>
			<%
				}
			%>
				
			<!-- 카테고리 수정하기 -->
			<%
				if(category != null){
			%>
					<hr>
					<form method="get" action="/shop/emp/modifyCategoryList.jsp">
						<div>
							카테고리 이름 수정→ <input type="text" name="modifyCategory" value="<%=category%>">
							<input type="hidden" name="category" value="<%=category%>">
							<button type="submit">확인</button>
						</div>
					</form>
			<%
				}
			%>
			</div>
		</div>
	<div class="row" style="background-color: blue;">밑단</div>
</div>
</body>
</html>