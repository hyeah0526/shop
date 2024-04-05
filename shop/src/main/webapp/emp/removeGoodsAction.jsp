<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.net.URLEncoder"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%
	/* 인증분기: 세션변수 이름 - loginEmp */
	//로그인이 안되어 있으면 emploginForm.jsp로 보냄
	if(session.getAttribute("loginEmp") == null){
		response.sendRedirect("/shop/emp/empLoginForm.jsp"); 
		return;
	}
	

	/* 삭제권한 확인 */
	HashMap<String,Object> loginMember 
	= (HashMap<String,Object>)(session.getAttribute("loginEmp"));

	String empId = (String)loginMember.get("empId");
	int grade = (Integer)loginMember.get("grade");
	System.out.println(loginMember + " <--HashMap removeGoodsAction.jsp");
	System.out.println(empId + " <--empId removeGoodsAction.jsp");
	System.out.println(grade + " <--grade removeGoodsAction.jsp");

	String msg = "";
	if(grade < 1){
		System.out.println(grade + "<-- 권한없음 등록실패");
		msg = URLEncoder.encode("삭제 권한이 없습니다.","UTF-8");
		response.sendRedirect("/shop/emp/goodsList.jsp?msg="+msg);
	}
%>
<%
	/* 삭제 */
	int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
	System.out.println(goodsNo + " <--goodsNo removeGoodsAction.jsp");
	System.out.println(request.getParameter("filename"));
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	PreparedStatement stmt = null;
	String sql = "delete from goods where goods_no = ?";
	
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, goodsNo);
	System.out.println(stmt);
	
	int row = 0;
	row = stmt.executeUpdate();
	
	if(row == 1){
		//파일 삭제
		String filePath = request.getServletContext().getRealPath("upload"); //file폴더까지 쫓아가...?
		File df = new File(filePath, request.getParameter("filename")); //해당이름의 filename이 있으면 그걸 가져오고
		df.delete(); //그걸 지우기 !
		
		System.out.println("삭제성공!");
		msg = URLEncoder.encode("삭제가 완료되었습니다.","UTF-8");
		response.sendRedirect("/shop/emp/goodsList.jsp?msg="+msg);
	}else{
		System.out.println("삭제 실패!");
		msg = URLEncoder.encode("삭제에 실패하였습니다. 다시 시도해주세요.","UTF-8");
		response.sendRedirect("/shop/emp/goodsList.jsp?msg="+msg);
	}
%>
