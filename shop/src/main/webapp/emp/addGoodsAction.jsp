<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%
	/* post로 넘겼으면 꼭 인코딩해주기 */
	request.setCharacterEncoding("UTF-8");

	/* 인증분기: 세션변수 이름 - loginEmp */
	if(session.getAttribute("loginEmp") == null){
		response.sendRedirect("/shop/emp/empLoginForm.jsp"); 
		return;
	}
%>
<%
	/* session 설정값 : 입력시 로그인 emp의 emp_id값이 필요해서.. */
		HashMap<String,Object> loginMember 
		= (HashMap<String,Object>)(session.getAttribute("loginEmp"));

		System.out.println((String)(loginMember.get("empId"))+"아이디정보 addGoodsAction.jsp");
%>

<!-- Model Layer -->
<%
	//변수값 가져오기
	// 로그인아이디, 카테고리, 상품제목, 가격, 수량, 내용 
	String category = request.getParameter("category");
	String empId = (String)(loginMember.get("empId"));
	String goodsTitle = request.getParameter("goodsTitle");
	int goodsPrice = Integer.parseInt(request.getParameter("goodsPrice"));
	int goodsAmount = Integer.parseInt(request.getParameter("goodsAmount"));
	String goodsContent = request.getParameter("goodsContent");
	
	Part part = request.getPart("goodsImg"); //이미지파일 가져오기
	String originalName = part.getSubmittedFileName(); 
	int dotIdx = originalName.lastIndexOf("."); // 마지막 점의 위치를 구함. 확장자를 분리하기 위해서
	String ext = originalName.substring(dotIdx); //점부터 자름 ex> .png
	System.out.println(ext+" <--ext addGoodsAction.jsp"); //디버깅
	
	UUID uuid = UUID.randomUUID();
	String fileName = uuid.toString().replace("-", ""); //uuid를 문자열로 변경하고! uuid안에는 -가 들어가 있기 때문에 그것도 없애줌
	fileName = fileName + ext;
	System.out.println(fileName+" <--fileName addGoodsAction.jsp"); //디버깅
	
	
	//디버깅
	System.out.println(category+" <-- category 상품등록액션페이지");
	System.out.println(empId+" <-- empId 상품등록액션페이지");
	System.out.println(goodsTitle+" <-- goodsTitle 상품등록액션페이지");
	System.out.println(goodsPrice+" <-- goodsPrice 상품등록액션페이지");
	System.out.println(goodsAmount+" <-- goodsAmount 상품등록액션페이지");
	System.out.println(goodsContent+" <-- goodsContent 상품등록액션페이지");
	
	//DB
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	PreparedStatement stmt = null;
	
	/*
		INSERT INTO goods(
			category,
			emp_id,
			goods_title,
			goods_content,
			goods_price,
			goods_amount
		)VALUES(
			'너의이름은',
			'admin',
			'하나뿐인',
			'곧 매진됩니다',
			30000,
			3
		);
	*/
	
	String sql = "INSERT INTO goods(category, emp_id, goods_title, filename, goods_content, goods_price, goods_amount)VALUES(?, ?, ?, ?, ?, ?, ?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, category);
	stmt.setString(2, empId);
	stmt.setString(3, goodsTitle);
	stmt.setString(4, fileName);
	stmt.setString(5, goodsContent);
	stmt.setInt(6, goodsPrice);
	stmt.setInt(7, goodsAmount);
	
	int row = 0;
	row = stmt.executeUpdate();
	System.out.println(stmt);
	
	if(row == 1){ ////insert성공하면 파일업로드
		// part -> 1) inputStream -> 2)outputStream -> 3)빈파일로 옮기기
		
		// 1)
		InputStream is = part.getInputStream();
		
		// 3) + 2)
		String filePath = request.getServletContext().getRealPath("upload");
		File f = new File(filePath, fileName); //빈파일
		OutputStream os = Files.newOutputStream(f.toPath()); //os와 file을 합침
		is.transferTo(os);
		
		os.close();
		is.close();
	}
	
	
%>

<!-- Controller Layer -->
<%
	//response.sendRedirect("goodsList 실패하면 form으로~");
	if(row == 1){
		//insert성공하면 파일도 업로드시키기
		System.out.println("추가성공!");
		response.sendRedirect("/shop/emp/goodsList.jsp");
	}else{
		System.out.println("추가실패!");
		String errMsg = "!!!Fail!!!";
		response.sendRedirect("/shop/emp/addGoodsForm.jsp?errMsg="+errMsg);
	}
%>