<%@page import="shop.dao.GoodsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%@page import="java.net.URLEncoder"%>
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
	
	//로그인 멤버정보 가져오기
	HashMap<String,Object> loginMember 
	= (HashMap<String,Object>)(session.getAttribute("loginEmp"));
	
	//update에서 넣어줄 empId만 변수에 담아주기
	String empId = (String)(loginMember.get("empId"));
	System.out.println(empId + " <-- empId modifyGoodsAction.jsp");
%>
<%
	//변수가져오기
	String filename = request.getParameter("filename"); //원래 파일
	int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
	String category = request.getParameter("category");
	String goodsImg = request.getParameter("goodsImg"); //변경할이미지
	
	int goodsPrice = Integer.parseInt(request.getParameter("goodsPrice"));
	int goodsAmount = Integer.parseInt(request.getParameter("goodsAmount"));
	String goodsTitle = request.getParameter("goodsTitle");
	String goodsContent = request.getParameter("goodsContent");
	
	//디버깅
	System.out.println(filename + " <--원래이미지이름 modifyGoodsAction.jsp");
	System.out.println(goodsImg + " <--변경할이미지 modifyGoodsAction.jsp");
	/*System.out.println(goodsNo + " <-- goodsNo modifyGoodsAction.jsp");
	System.out.println(category + " <-- category modifyGoodsAction.jsp");
	System.out.println(goodsPrice + " <-- goodsPrice modifyGoodsAction.jsp");
	System.out.println(goodsAmount + " <-- goodsAmount modifyGoodsAction.jsp");
	System.out.println(goodsTitle + " <-- goodsTitle modifyGoodsAction.jsp");
	System.out.println(goodsContent + " <-- goodsContent modifyGoodsAction.jsp"); */
	
	//새로 넣어줄 이미지
	String newImg = "";
	if(goodsImg == null){
		newImg = filename;
	};

	Part part = request.getPart("goodsImg"); //이미지파일 가져오기
	/* 
		String originalName = part.getSubmittedFileName(); //업로드파일의 이름 구하기
		int dotIdx = originalName.lastIndexOf("."); // 마지막 점의 위치를 구함. 확장자를 분리하기 위해서
		String ext = originalName.substring(dotIdx); //점부터 자름 ex> .png
		UUID uuid = UUID.randomUUID();
		newImg = uuid.toString().replace("-", "");
		System.out.println(newImg+"<--replace 다음(55번째줄다음)");
	*/	
	
	//DB
	int row = GoodsDAO.modifyGoods(goodsNo, empId, goodsTitle, newImg, goodsContent, goodsPrice, goodsAmount);
	
	String msg = "";
	
	if(row == 1){
		if (part != null && part.getSize() > 0) {
			// part -> 1) inputStream -> 2)outputStream -> 3)빈파일로 옮기기
			
			// 1)
			InputStream is = part.getInputStream();
					
			// 3) + 2)
			String filePath = request.getServletContext().getRealPath("upload");
			File f = new File(filePath, newImg); //빈파일
			OutputStream os = Files.newOutputStream(f.toPath()); //os와 file을 합침
			is.transferTo(os);
			os.close();
			is.close();
		};
			
		System.out.println("성공!");
		
		msg = URLEncoder.encode("수정에 성공하였습니다.", "UTF-8");
		response.sendRedirect("/shop/emp/goodsOne.jsp?goodsNo="+goodsNo+"&msg="+msg);
	}else{
		System.out.println("실패!");
		msg = URLEncoder.encode("수정에 실패하였습니다.", "UTF-8");
		response.sendRedirect("/shop/emp/goodsOne.jsp?goodsNo="+goodsNo+"&msg="+msg);
	}


%>
