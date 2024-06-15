<%@page import="shop.dao.EmpDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@ page import="java.sql.*" %>
<!-- 여기부터는 Controller Layer -->
<%
/* 인증분기: 세션변수 이름 - loginEmp */
	//String loginEmp = (String)session.getAttribute("loginEmp"); 
	//System.out.println(loginEmp+" <-- loginEmp empList.jsp"); // 로그인한적이 없으면 null이 들어감
	
	//로그인이 안되어 있으면 emploginForm.jsp로 보냄
	if(session.getAttribute("loginEmp") == null){
		response.sendRedirect("/shop/emp/empLoginForm.jsp"); 
		return;
	}
%>
<%
/* 기본 페이징 */
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 16; //한페이지에 보여줄 것
	int startRow = (currentPage-1)*rowPerPage;
	
	String empSearch = request.getParameter("empSearch");
	System.out.println(empSearch+" <--empSearch empList.jsp");
	
	if(empSearch == null){ //검색어가 없으면 공백넣어주기
		empSearch = "";
	}
%>
<%
/* 사원목록 보여주기 ArrayList<HashMap> */

	String selectRow = request.getParameter("selectRow");
	int selectRowInt = 0;
	
	if(selectRow == null){
		selectRowInt = 15;
	}else{
		selectRowInt = Integer.parseInt(selectRow);
	}
	
	ArrayList<HashMap<String, Object>> list = EmpDAO.selectEmpList(empSearch, startRow, selectRowInt);
	
	
/* 사원목록 보여주기 Paging */
	int totalRow = EmpDAO.empListPaging(empSearch);

	int lastPage = totalRow / selectRowInt;
	
	if(totalRow % selectRowInt != 0){
		lastPage = lastPage+1;
	}
	System.out.println(totalRow + " <-- totalRow empList.jsp");
	System.out.println(lastPage + " <-- lastPage empList.jsp");
	
%>

<!-- 여기부터는 View Layer -->
<!-- 모델(ArrayList<HashMap<String, Object>>)로 출력 -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>empList</title>
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
			<br><h1 class="text-center">사원 목록</h1><br>
			<div style="background-color: #E6D7BD; display: flex;">
			<div style="background-color: #E6D7BD; margin: auto;">
		<%
			//사원 목록 뿌려주기
			int floatCnt = 1; // 한줄당 3개씩 보여주기
			for(HashMap<String, Object> m : list){
				
				if(floatCnt%3 == 0){
					//System.out.println("floatCnt%4 == 0 -> "+floatCnt);
		%>
				<div class="text-center" style="border: 2px dashed #737058; width: 300px; height: 200px; margin: 3px; display: inline-block;">
					<div><%=(String)m.get("empName")%></div>
					<div><%=(String)m.get("empJob")%></div>
					<div><%=(String)m.get("empId")%></div>
					<div><%=(String)m.get("hireDate")%></div>
					<%
						HashMap<String, Object> sm = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
						if((Integer)(sm.get("grade")) == 1 || (Integer)(sm.get("grade")) == 9){
					%>
							<div>활성화 변경: 
								<a href="/shop/emp/modifyEmpActive.jsp?empId=<%=(String)m.get("empId")%>&active=<%=(String)m.get("active")%>">
									[ <%=(String)m.get("active")%> ]
								</a>
							</div>
					<%
						}
					%>
				</div>
				<div class="clear"></div>
		<%
				}else{
					//System.out.println("else-> "+floatCnt);
		%>
				
				<div class="text-center" style="border: 2px dashed #737058; width: 300px; height: 200px; margin: 3px; float: left;">
					<div><%=(String)m.get("empName")%></div>
					<div><%=(String)m.get("empJob")%></div>
					<div><%=(String)m.get("empId")%></div>
					<div><%=(String)m.get("hireDate")%></div>
					<%
						HashMap<String, Object> sm = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
						if((Integer)(sm.get("grade")) == 1 || (Integer)(sm.get("grade")) == 9){
					%>
							<div>활성화 변경: 
								<a href="/shop/emp/modifyEmpActive.jsp?empId=<%=(String)m.get("empId")%>&active=<%=(String)m.get("active")%>">
									[ <%=(String)m.get("active")%> ]
								</a>
							</div>
					<%
						}
					%>
				</div>
				
		<%
				}
				floatCnt=floatCnt+1;
			}
		%>
			<div style="clear: both; text-align: center;"><br>
				<form method="get" action="/shop/emp/empList.jsp?currentPage=1">
					<input type="text" name="empSearch" class="searchInput">&nbsp;&nbsp;
						<button type="submit" class="searchBtn">사원 이름 검색</button>
				</form>
			</div><br>
			<div style="clear: both; text-align: center;">
		<%
				//이전 페이징 기능
				if(currentPage <= 1){
		%>
					<a style="color: #d1c3ac;">◀이전</a> 
		<%
				}else{
		%>
					<a href="/shop/emp/empList.jsp?currentPage=<%=currentPage-1%>&empSearch=<%=empSearch%>">◀이전</a> 
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
					<a href="/shop/emp/empList.jsp?currentPage=<%=currentPage+1%>&empSearch=<%=empSearch%>">다음▶</a>
		<%
				}
		%>
			</div>
			</div><br>
			</div>
		</div>
	</div>
	<!-- Footer설정 -->
	<jsp:include page="/emp/inc/empFooter.jsp"></jsp:include>
</div>
</body>
</html>