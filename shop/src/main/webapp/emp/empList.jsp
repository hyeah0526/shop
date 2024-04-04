<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
/* 페이징 */
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

<!-- 여기부터는 Model Layer -->
<%
/* 사원목록 보여주기 ArrayList<HashMap> */

	// 특수한 형태의 자료구조(RDBMS:mariadb)
	// -> API사용(JDBC API)하여 자료구조(ResultSet) 취득 
	// -> 일반화된 자료구조(ArrayList<HashMap>)로 변경
	// -> 모델 취득
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	PreparedStatement stmt = null;
	ResultSet rs = null; 
	
	String sql = "select emp_id empId, emp_name empName, emp_job empJob, hire_date hireDate, active from emp where emp_name like ? order by hire_date desc limit ?, ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, "%"+empSearch+"%");
	stmt.setInt(2, startRow);
	
	String selectRow = request.getParameter("selectRow");
	int selectRowInt = 0;
	
	if(selectRow == null){
		selectRowInt = 15;
		stmt.setInt(3, selectRowInt);
	}else{
		selectRowInt = Integer.parseInt(selectRow);
		stmt.setInt(3, selectRowInt);
	}
	System.out.println(selectRow+" <--selectRow");
	System.out.println(stmt);
	
	rs = stmt.executeQuery(); 
	//위까지가 JDBC API에 종속된 자료구조 모델ResultSet! 이제 이걸 변경 -> 기본 API 자료구조로(ArrayList)로 변경
	ArrayList<HashMap<String, Object>> list 
		= new ArrayList<HashMap<String, Object>>();
	
	// resultSet -> ArrayList<HashMap<String, Object>> 로 이동작업!!
	// Object인이유는 int가 있을수도있으니까! (여기서는 String만있음)
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>(); 
		m.put("empId", rs.getString("empId"));
		m.put("empName", rs.getString("empName"));
		m.put("empJob", rs.getString("empJob"));
		m.put("hireDate", rs.getString("hireDate"));
		m.put("active", rs.getString("active"));
		
		//그리고 그걸 List에 넣어주기
		list.add(m);
	}
	
	//페이징
	String sql2 = "select count(*) cnt from emp where emp_name like ?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null; 
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, "%"+empSearch+"%");
	rs2 = stmt2.executeQuery();
	System.out.println(stmt2);
	
	int totalRow = 0;
	if(rs2.next()){
		totalRow = rs2.getInt("cnt");
	}
	int lastPage = totalRow / selectRowInt;
	if(totalRow % selectRowInt != 0){
		lastPage = lastPage+1;
	}
	System.out.println(lastPage+" <--lastPage empList.jsp");
	
	
	
	//JDBC API 사용이 끝났다면 DB자원들 반납 가능
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
		}
	</style>
</head>
<body class="fontContent">
<div class="" style="margin: 50px;">
	<div class="row" style="background-color: red;">쇼핑몰 타이틀</div>

	<div class="row">
		<!-- 왼쪽메뉴나오는 곳 -->
		<!-- empMenu.jsp include : 주체(서버) vs redirect(주체:클라이언트) -->
		<!-- 주체가 서버이기 때문에 include할때는 절대주소가 /shop으로 시작하는게 아니라 /emp부터 시작 -->
		<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
		
		<!-- 메인 -->
		<div class="col-10" style="background-color: #CCCCCC;">
			<h1>사원 목록</h1>
			<div style="background-color: green; display: flex;">
			<div style="background-color: gray; margin: auto;">
		<%
			//사원 목록 뿌려주기
			int floatCnt = 1;
			for(HashMap<String, Object> m : list){
				
				if(floatCnt%3 == 0){
					//System.out.println("floatCnt%4 == 0 -> "+floatCnt);
		%>
				<div class="text-center" style="border: 1px solid green; width: 300px; height: 200px; margin: 3px; display: inline-block;">
					<div><%=(String)m.get("empName")%></div>
					<div><%=(String)m.get("empJob")%></div>
					<div><%=(String)m.get("empId")%></div>
					<div><%=(String)m.get("hireDate")%></div>
					<%
						HashMap<String, Object> sm = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
						if((Integer)(sm.get("grade")) == 1){
					%>
							<div>활성화: 
								<a href="/shop/emp/modifyEmpActive.jsp?empId=<%=(String)m.get("empId")%>&active=<%=(String)m.get("active")%>">
									<%=(String)m.get("active")%>
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
				
				<div class="text-center" style="border: 1px solid green; width: 300px; height: 200px; margin: 3px; float: left;">
					<div><%=(String)m.get("empName")%></div>
					<div><%=(String)m.get("empJob")%></div>
					<div><%=(String)m.get("empId")%></div>
					<div><%=(String)m.get("hireDate")%></div>
					<%
						HashMap<String, Object> sm = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
						if((Integer)(sm.get("grade")) == 1){
					%>
							<div>활성화: 
								<a href="/shop/emp/modifyEmpActive.jsp?empId=<%=(String)m.get("empId")%>&active=<%=(String)m.get("active")%>">
									<%=(String)m.get("active")%>
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
			<br>
			<div style="clear: both; text-align: center;">
				<form method="get" action="/shop/emp/empList.jsp?currentPage=<%=currentPage%>">
					<input type="text" name="empSearch">&nbsp;&nbsp;<button type="submit">검색</button>
				</form>
			</div><br>
			<div style="clear: both; text-align: center;">
		<%
				//이전 페이징 기능
				if(currentPage <= 1){
		%>
					<a>◀이전</a> 
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
					<a>다음▶</a> 
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
	<div class="row" style="background-color: blue;">밑단</div>
</div>
</body>
</html>