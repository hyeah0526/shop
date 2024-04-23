<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
	HashMap<String,Object> loginCustomer 
		= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));

	String msg = request.getParameter("msg");
	if(msg == null){
		msg = "";
	}
	System.out.println(msg+" <-- msg customerMenu.jsp");
%>
<div class="col text-center rounded fs-5"
	style="border: 3px dashed #5E3F36; border-radius:10px; height: 800px; background-color: #E6D7BD; margin-right: 10px; color: #444236;">
		<br>
		<a href="/shop/customer/customerGoodsList.jsp">상품 보기</a><br>
		<a href="/shop/customer/myOrderList.jsp">주문 확인</a><br><br>
		<a href="">
			<%=(String)(loginCustomer.get("cName"))%>
		</a>님, 반갑습니다
		<%
			if(msg.equals("비밀번호수정")){
		%>
				<div>비밀번호 수정성공</div>
		<%
			}
		%>
		<br><br>
		<div>
			<form action="/shop/customer/modifyCustomer.jsp" method="post">
				<input type="hidden" name="cMail" value="<%=(String)(loginCustomer.get("cMail"))%>">
				<button class="btn" style="border: 3px solid green;">회원정보수정</button>
			</form>
		</div><br>
		<div>
			<a href="/shop/customer/customerLogout.jsp" class="btn" style="border: 3px solid green;">로그아웃</a>
		</div><br>
</div>