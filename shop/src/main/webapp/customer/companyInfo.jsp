<%@ page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
/* 인증분기: 세션변수 이름 - loginEmp */
	if(session.getAttribute("loginCustomer") == null){ 
		response.sendRedirect("/shop/customer/loginForm.jsp"); 
		return;
	}

	HashMap<String,Object> loginCustomer 
		= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
	String cMail = (String)loginCustomer.get("cMail");
	//System.out.println(cMail+" <--cName myOrderList.jsp");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>companyInfo</title>
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
		    color: #444236;
		}
		.fontContent{
			font-family: 'TTLaundryGothicB';
			background-color: #737058;
			color: #444236;
		}
		
		a { text-decoration: none; color: #444236;}
		a:hover { color:#444236; }
		a:visited { text-decoration: none;}
	</style>
</head>
<body class="fontContent">
<div class="" style="margin: 50px;">
	<!-- 위쪽 타이틀 -->
	<jsp:include page="/emp/inc/empTitle.jsp"></jsp:include>
	
	<div class="row">
		<!-- 왼쪽메뉴나오는 곳 -->
		<jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>
		
		<!-- 메인 -->
		<div class="col-10" style="background-color: #E6D7BD; border: 3px dashed #5E3F36; border-radius:10px; color: #444236; text-align: center;">
			<img src="/shop/emp/img/logo3.png" style="width: 200px; margin: auto;"><br>
			<h1 style="margin: auto;">초록공룡 동심</h1><br>
			<div style="width: 60%; margin: auto; margin-bottom: 30px;">
				"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
				<br><br>
				Maecenas mattis augue a mi ultricies, feugiat euismod eros sollicitudin. Sed a tempus ex, eget condimentum ligula. Aliquam vitae nulla sit amet purus facilisis sodales a vitae justo. Fusce semper, tellus ut accumsan pharetra, leo leo rhoncus elit, id tempus leo elit sit amet elit. Vivamus id neque nec velit bibendum hendrerit ut dictum felis. Nam non luctus metus, id congue felis. Nunc nec tincidunt quam, vel tempor tortor. Nulla iaculis massa non elementum faucibus.
			</div>
		</div>
	</div>
	
	<!-- Footer설정 -->
	<jsp:include page="/emp/inc/empFooter.jsp"></jsp:include>
	
</div>
</body>
</html>