<%@page import="shop.dao.CategoryDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!-- 여기부터는 Controller Layer -->
<%
	/* 인증분기: 세션변수 이름 - loginEmp */
	if(session.getAttribute("loginEmp") == null){
		response.sendRedirect("/shop/emp/empLoginForm.jsp"); 
		return;
	}
	
	// 삭제 최종권한(9)만 삭제 가능
	HashMap<String,Object> loginMember 
		= (HashMap<String,Object>)(session.getAttribute("loginEmp"));
	
	int grade = (Integer)loginMember.get("grade");
	//System.out.println(grade);
%>
<%
	String msg = request.getParameter("msg");
	
	/* 전체 카테고리 목록 뿌려주기 */
	ArrayList<HashMap<String, Object>> categoryList = CategoryDAO.categoryList();
	
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
		
		a { text-decoration: none; color: #444236;}
		a:hover { color:#444236; }
		a:visited { text-decoration: none;}
		 
		 .mainBox{
			background-color: #E6D7BD; border: 3px dashed #5E3F36; color: #444236; border-radius:10px;
		}
		
		.addModifyInput{
			border:none; border-bottom: 2px double #444236; background-color: transparent;
		}
		
		.addModifyBtn{
			border: 2px solid #444236; background-color: #E6D7BD; border-radius:10px;
		}
		
		.addModifyBtn:hover { 
			background-color: #737058;
			color: #E6D7BD;
		}
		
		.divContent{
			border-bottom: 1px dashed #444236; 
			height: 50px; 
			align-items: center;
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
			<br><h1 class="text-center">카테고리 관리</h1><br>
			<!-- 카테고리 추가하기 -->
			<div style="margin-left: 30px;">
				<form action="/shop/emp/addCategoryAction.jsp">
					<input type="text" name="category" class="addModifyInput">
					<button type="submit" class="addModifyBtn">카테고리 추가</button>
				</form>
			</div><br>
			
			<!-- 삭제/추가 메시지 보여주기 -->
			<%
				if(msg != null){
			%>
					<div><%=msg%></div><br>
			<%
				}
			%>
			<div style="margin: 20px;">
				<!-- 전체 카테고리 목록 보여주기 -->
				<div class="row text-center" style="color: #444236; border-bottom: 2px double #444236;">
					<div class="col fs-5" style="">카테고리</div>
					<div class="col fs-5" style="">생성날짜</div>
					<div class="col fs-5" style="">삭제</div>
				</div>
			<%
				// 전체목록 리스트 뿌려주기
				for(HashMap m : categoryList){
			%>
					<div class="row text-center divContent">
						<div class="col"><a><%=m.get("category")%></a></div>
						<div class="col"><a><%=m.get("createDate")%></a></div>
						<div class="col">
						<%
							if(grade == 9){
						%>
								<a href="/shop/emp/removeCategoryAction.jsp?category=<%=m.get("category")%>">삭제하기</a>
						<%
							}else{
						%>
								삭제권한 없음
						<%
							}
						%>
						</div>
					</div>
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