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

	HashMap<String,Object> loginMember 
	= (HashMap<String,Object>)(session.getAttribute("loginEmp"));
%>
<%
	String msg = request.getParameter("msg");
	if(msg==null){
		msg = "";
	}
	System.out.println(msg + " <-- msg goodsOne.jsp");

	int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
	System.out.println(goodsNo + " <--goodsNo GoodsOne상세보기");
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	PreparedStatement stmt = null;
	ResultSet rs = null; 
	String sql = "select * from goods WHERE goods_no = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, goodsNo);
	System.out.println(stmt); //디버깅
	rs = stmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> goodsOne = new ArrayList<>();
	while(rs.next()){
		HashMap<String, Object> goods = new HashMap<>();
		goods.put("goodsNo", rs.getInt("goods_no"));
		goods.put("category", rs.getString("category"));
		goods.put("empId", rs.getString("emp_id"));
		goods.put("goodsTitle", rs.getString("goods_title"));
		goods.put("filename", rs.getString("filename"));
		goods.put("goodsContent", rs.getString("goods_content"));
		goods.put("goodsPrice", rs.getInt("goods_price"));
		goods.put("goodsAmount", rs.getInt("goods_amount"));
		goods.put("updateDate", rs.getString("update_date"));
		goods.put("createDate", rs.getString("create_date"));
		goodsOne.add(goods);
	}
	System.out.println(goodsOne);
	
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>goodsOne.jsp</title>
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
	<div class="row" style="background-color: #E6D7BD; border: 3px dashed #5E3F36; border-radius:10px; margin-bottom: 10px;"><img src="/shop/emp/img/logo3.png" style="width: 200px; margin: auto;"></div>

	<div class="row">
		<!-- 왼쪽메뉴나오는 곳 -->
		<!-- empMenu.jsp include : 주체(서버) vs redirect(주체:클라이언트) -->
		<!-- 주체가 서버이기 때문에 include할때는 절대주소가 /shop으로 시작하는게 아니라 /emp부터 시작 -->
		<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
		
		<!-- 메인 -->
		<div class="col-10" style="background-color: #E6D7BD; border: 3px dashed #5E3F36; border-radius:10px; color: #444236;">
			<%
				if(msg.equals("modify")){
			%>
					<h1 class="text-center">상품 수정</h1>
			<%	
				}else{
			%>
					<h1 class="text-center">상품 상세</h1>
					<div class="text-center"><%=msg%></div>
			<%	
				}
			%>
			
			<div style="background-color: #E6D7BD; display: flex;">
			<div style="background-color: #E6D7BD; margin: auto;">
				<%
					if(msg.equals("modify")){
						System.out.println("modify걸리나?????");
						for(HashMap<String, Object> g2 : goodsOne){
				%>
							<form method="post" action="/shop/emp/modifyGoodsAction.jsp" enctype="multipart/form-data">
								<div class="row">
									<div class="col" style="float: left;">
										<img src="/shop/upload/<%=(String)g2.get("filename")%>" style="border: 2px dashed #737058; border-radius:5px; width: 600px; height: 600px; margin-right: 10px;">
									</div>
									<div class="col" style="float: right; width: 600px">
										<div style="border-bottom:2px dashed #737058;">[상품번호&카테고리] <%=(Integer)g2.get("goodsNo")%>&<%=(String)g2.get("category")%></div><br>
										<div>
											<input type="hidden" name="goodsNo" value="<%=(Integer)g2.get("goodsNo")%>">
											<input type="hidden" name="category" value="<%=(String)g2.get("category")%>">
											<input type="hidden" name="filename" value="<%=(String)g2.get("filename")%>">
										</div>
										<div style="border-bottom:2px dashed #737058;">[수정사원] <%=(String)(loginMember.get("empName"))%></div><br>
										<div style="border-bottom:2px dashed #737058;">[변경할이미지] <input type="file" name="goodsImg"></div><br>
										<div style="border-bottom:2px dashed #737058;">[가격] <input type="number" name="goodsPrice" value="<%=(Integer)g2.get("goodsPrice")%>"></div><br>
										<div style="border-bottom:2px dashed #737058;">[수량] <input type="number" name="goodsAmount" value="<%=(Integer)g2.get("goodsAmount")%>"></div><br>
										<div style="border-bottom:2px dashed #737058;">[제목] <input type="text" name="goodsTitle" value="<%=(String)g2.get("goodsTitle")%>"></div><br>
										<div style="border-bottom:2px dashed #737058;">[내용] <textarea rows="5" cols="50" name="goodsContent"><%=(String)g2.get("goodsContent")%></textarea></div>
										<br>
										<button type="submit">수정하기</button>
									</div>
								</div>
							</form>
				<%	
						}
					}else{
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
										<br><br>												<a href="/shop/emp/goodsOne.jsp?goodsNo=<%=(Integer)g.get("goodsNo")%>&msg=modify">수정</a>&nbsp;&nbsp;
										<a href="/shop/emp/removeGoodsAction.jsp?goodsNo=<%=(Integer)g.get("goodsNo")%>&filename=<%=(String)g.get("filename")%>">상품 삭제</a>
									</div>
								</div>
				<%	
						}
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
