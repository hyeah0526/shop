<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!-- 여기부터는 Controller Layer -->
<%
/* post로 넘겼으면 꼭 인코딩해주기 */
	request.setCharacterEncoding("UTF-8");

/* 인증분기: 세션변수 이름 - loginEmp */
	//로그인이 안되어 있으면 emploginForm.jsp로 보냄
	if(session.getAttribute("loginEmp") == null){
		response.sendRedirect("/shop/emp/empLoginForm.jsp"); 
		return;
	}
%>
<!-- 여기부터는 Model Layer -->
<%
	/* Count 카테고리별 카운트 캐수 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null; 

	String sql1 ="SELECT category FROM category";
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	//System.out.println(stmt1);
	
	ArrayList<String> categoryList = new ArrayList<String>();
	while(rs1.next()){
		categoryList.add(rs1.getString("category"));
	}
	//디버깅
	System.out.println(categoryList);
	
	String errMsg = request.getParameter("errMsg");
	
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>addGoodsForm.jsp</title>
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
		
		.addGoods{
			background-color: #E6D7BD; border: 3px dashed #5E3F36; border-radius:10px; color: #444236;
		}
		
		.addGoodsSelect{
			border:none; border-bottom: 2px double #5E3F36; background-color: transparent;
		}
		
		.addGoodsInput{
			border:none; border-bottom: 2px double #5E3F36; background-color: transparent;
		}
		
		.addGoodsContent{
			border:none; border: 2px double #5E3F36; background-color: transparent;
		}
		
		.addGoodsBtn{
			border: 2px solid #5E3F36; background-color: #E6D7BD; border-radius:10px;
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
		<div class="col-10 addGoods">
			<br><h1 class="text-center">상품 등록하기</h1><br>
			<%
				if(errMsg != null){
			%>
					<div>!! 등록에 실패하였습니다. 다시 등록해주세요. !!</div>
			<%
				}
			%>
			<div style="background-color: #E6D7BD; display: flex;">
			<div style="background-color: #E6D7BD; margin: auto;">
			<form action="/shop/emp/addGoodsAction.jsp" method="post" enctype="multipart/form-data">
			<!-- 이미지를 넣기 위해서는 꼭 post이여야하고,enctype을 설정해줘야함  -->
				<div class="row">
					<div class="col-2 text-center">카테고리</div>
					<div class="col" >
					<select name="category" class="addGoodsSelect">
						<option>선택</option>
					<%
							for(String c : categoryList){
					%>
								<option value="<%=c%>"><%=c%></option>
					<%
							}
					%>
					</select>
					</div>
				</div>
				<div class="row">
					<div class="col-2 text-center">상품제목</div>
					<div class="col"><input type="text" name="goodsTitle" class="addGoodsInput"></div>
				</div>
				<div class="row">
					<div class="col-2 text-center">상품가격</div>
					<div class="col"><input type="text" name="goodsPrice" class="addGoodsInput"></div>
				</div>
				<div class="row">
					<div class="col-2 text-center">상품수량</div>
					<div class="col"><input type="text" name="goodsAmount" class="addGoodsInput"></div>
				</div>
				<div class="row">
					<div class="col-2 text-center">이미지</div>
					<div class="col"><input type="file" name="goodsImg"></div>
				</div>
				<div class="row">
					<div class="col-2 text-center">내용</div>
					<div class="col"><textarea rows="5" cols="50" name="goodsContent" class="addGoodsContent"></textarea></div>
				</div>
				<div style="text-align: center;">
					<button type="submit" class="btn addGoodsBtn">등록</button>
				</div>
			</form>
			</div>
			</div>
		</div>
	</div>
	<div class="row" style="background-color: blue;">밑단</div>
</div>
</body>
</html>