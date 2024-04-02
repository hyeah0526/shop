<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!-- 여기부터는 Controller Layer -->
<%
/* 인증분기: 세션변수 이름 - loginEmp */
	String loginEmp = (String)session.getAttribute("loginEmp"); 
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
	
	int lastPage = 7;
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
	
	String sql = "select emp_id empId, emp_name empName, emp_job empJob, hire_date hireDate, active from emp order by hire_date desc limit ?, ?";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, startRow);
	
	String selectRow = request.getParameter("selectRow");
	int selectRowInt = 0;
	
	if(selectRow == null){
		selectRowInt = 16;
		stmt.setInt(2, selectRowInt);
	}else{
		selectRowInt = Integer.parseInt(selectRow);
		stmt.setInt(2, selectRowInt);
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
</head>
<body>
<div class="" style="margin: 50px;">
	<div class="row" style="background-color: red;">쇼핑몰 타이틀</div>

	<div class="row">
		<!-- 왼쪽메뉴나오는 곳 -->
		<div class="col" style="background-color: yellow;">
			왼쪽메뉴<br>
			<a href="/shop/emp/empLogout.jsp">로그아웃</a>
		</div>
		
		<!-- 메인 -->
		<div class="col-11" style="background-color: #CCCCCC;">
			<h1>사원 목록</h1>
			<div style="background-color: gray;">
		<%
			//사원 목록 뿌려주기
			int floatCnt = 1;
			for(HashMap<String, Object> m : list){
				
				if(floatCnt%4 == 0){
					//System.out.println("floatCnt%4 == 0 -> "+floatCnt);
		%>
				<div class="" style="border: 1px solid green; width: 300px; height: 150px; margin: 3px; display: inline-block;">
					<div>아이디 : <%=(String)m.get("empId")%></div>
					<div>사원 <%=(String)m.get("empName")%></div>
					<div>부서(직급): <%=(String)m.get("empJob")%></div>
					<div>계약일: <%=(String)m.get("hireDate")%></div>
					<div>활성화: 
						<a href="/shop/emp/modifyEmpActive.jsp?empId=<%=(String)m.get("empId")%>&active=<%=(String)m.get("active")%>">
							<%=(String)m.get("active")%>
						</a>
					</div>
				</div>
				<div class="clear"></div>
		<%
				}else{
					//System.out.println("else-> "+floatCnt);
		%>
				
				<div class="" style="border: 1px solid green; width: 300px; height: 150px; margin: 3px; float: left;">
					<div>아이디 : <%=(String)m.get("empId")%></div>
					<div>사원 <%=(String)m.get("empName")%></div>
					<div>부서(직급): <%=(String)m.get("empJob")%></div>
					<div>계약일: <%=(String)m.get("hireDate")%></div>
					<div>활성화: 
						<a href="/shop/emp/modifyEmpActive.jsp?empId=<%=(String)m.get("empId")%>&active=<%=(String)m.get("active")%>">
							<%=(String)m.get("active")%>
						</a>
					</div>
				</div>
				
		<%
				}
				floatCnt=floatCnt+1;
			}
		%>
		
			<div style="clear: both;">
		<%
				//이전 페이징 기능
				if(currentPage <= 1){
		%>
					<a>◀이전</a> 
		<%
				}else{
		%>
					<a href="/shop/emp/empList.jsp?currentPage=<%=currentPage-1%>">◀이전</a> 
		<%
				}
		%>
		<%
				//다음 페이징 기능
				if(currentPage <= lastPage){
		%>
					<a>다음▶</a> 
		<%
				}else{
		%>
					<a href="/shop/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음▶</a> 
		<%
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