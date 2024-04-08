<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
/* 인증분기: 세션변수 이름 - loginCustomer */
	
	//로그인을 하지 않은 상태여야지만 loginForm으로 올 수 있기 때문에 필요없지만,
	//주소창에 직접 loginAction.jsp창을 칠수 있기때문에 분기해주기
	
	//로그인이 이미 되어있으면 goodsList.jsp로 보냄
	if(session.getAttribute("loginCustomer") != null){ 
		response.sendRedirect("/shop/customer/customerGoodsList.jsp"); 
		return;
	}
%>
%>
<%
	/* post로 넘겼으면 꼭 인코딩해주기 */
	request.setCharacterEncoding("UTF-8");

	//변수값가져오기
	String cMail = request.getParameter("cMail");
	String cPw = request.getParameter("cPw");
	
	//디버깅
	System.out.println(cMail+" <-- cMail loginAction.jsp");
	System.out.println(cPw+" <-- cPw loginAction.jsp");
	
	//DB select
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql = "SELECT c_mail Cmail, c_name cName FROM customer WHERE c_mail = ? AND c_pw = PASSWORD(?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, cMail);
	stmt.setString(2, cPw);
	
	rs = stmt.executeQuery();
	
	String msg = "";
	
	if(rs.next()){
		System.out.println("로그인 성공!");
		
		//메일주소와 이름! 여러개의 값을 HashMap에 저장
		HashMap<String, Object> loginCustomer = new HashMap<>();
		loginCustomer.put("cMail", rs.getString("Cmail"));
		loginCustomer.put("cName", rs.getString("cName"));
		session.setAttribute("loginCustomer", loginCustomer);
		
		//디버깅해보기
		HashMap<String, Object> c = (HashMap<String, Object>)(session.getAttribute("loginCustomer"));
		System.out.println((String)(c.get("cMail")) + " <--로그인 메일주소확인");
		System.out.println((String)(c.get("cName")) + " <--로그인 이름 확인");
		
		//세션에 담은 후 보내주기!
		response.sendRedirect("/shop/customer/customerGoodsList.jsp");
	}else{
		System.out.println("로그인 실패!");
		msg = URLEncoder.encode("로그인에 실패하였습니다. 메일 주소와 비밀번호를 다시 확인해주세요.", "UTF-8");
		response.sendRedirect("/shop/customer/loginForm.jsp?msg="+msg);
	}
	

%>
