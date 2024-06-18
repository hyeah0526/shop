<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
	.footerDiv{
		background-color: #E6D7BD;
	    border: 3px dashed #5E3F36;
	    border-radius: 10px;
	    margin: auto;
	    margin-top: 15px;
	    display: flex; 
	    flex-wrap: wrap; 
	    justify-content: center; 
	    align-items: center;
	    font-size: 11pt;
	    height: 200px; 
	    overflow: hidden;
	}
	.footerImg{
		margin: 20px;
		float: left;
		width: 200px;
	}
	.footerInfo{
		margin: 20px;
		float: left;
		width: 300px;
	}
	.footerLink{
		margin: 20px;
		float: left;
		width: 300px;
	}
	.footerPay{
		margin: 20px;
		float: left;
		width: 300px;
	}
</style>
<div class="row footerDiv">
<div style="margin-left: 30%;">
	<div class="footerImg">
		<img src="/shop/emp/img/logo3.png" style="width: 150px; margin: auto;">
	</div>
	
	<div class="footerInfo">
		<h6>회사 정보</h6>
		<p>회사명: 초록공룡 동심</p>
		<p>주소: 서울특별시 금천구 가산디지털 2로</p>
		<p>전화번호: 02-9999-9999</p>
		<p>이메일: goodee@gd.com</p>
	</div>
	    
	<div class="footerLink">
		<h6>링크</h6>
			<ul>
	            <li><a href="/shop/emp/goodsList.jsp">홈</a></li>
	            <li><a href="#">이용약관</a></li>
	            <li><a href="#">개인정보 처리방침</a></li>
	            <li><a href="#">배송 및 반품 정책</a></li>
	            <li><a href="#">고객센터</a></li>
	        </ul>
	</div>
	    
	<div class="footerPay">
		<h6>결제 수단</h6>
		<ul>
			<li>무통장입금</li>
		</ul>
	</div>
</div>
</div>