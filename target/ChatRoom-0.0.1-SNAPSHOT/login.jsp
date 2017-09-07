<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="css/jquery.mobile-1.4.5.min.css" />
		<script type="text/javascript" src="js/jquery.min.js"></script>
		<script>
			$(function() {
				$(document).on("pageinit", "#signupPage", function() {
					$('#signupCancel').click(function(){
						window.location.href="#loginPage";
					});
					$('#signup').click(function() {
						 $.ajax({
							type: "post",
							url: "signup.spring?t=" + new Date().getTime(),
							data: $('#signupForm').serialize(),
							success: function(data) {
                                if(data=="repeat")
                                	alert("昵称有人用啦");
                                else if(data=="f")
                                	alert("系统出错了。。");
                                else if(data=="s"){
                                	alert("注册成功");
                                	window.location.href="#loginPage";
                                }
                                else
                                	alert("未知异常。。");
                                	
							}
						}); 
					});
				})
				$(document).on("pageinit", "#loginPage", function() {
					$('#signupBtn').click(function(){
						window.location.href="#signupPage";
					});
					$('#login').click(function() {
						if($('#loginName').val()=="")
							 alert("总得有个昵称吧  比如狗子阿春花阿随便起一个");
						else{
							$.ajax({
								type: "post",
								url: "login.spring?t=" + new Date().getTime(),
								data: $('#loginForm').serialize(),
								success: function(data) {
	                                 if(data=="f")
	                                	 alert("昵称或密码出错了")
	                                 else if(data=="s")
	                                	 window.location.href="chat.jsp";
								}
							});
						}
					});
				})
			})
		</script>
		<script type="text/javascript" src="js/jquery.mobile-1.4.5.min.js"></script>
<title>Insert title here</title>
<style>
	
	#loginPage{background-color: #CDB5CD;}
	#loginPageHeader{background-color: #CD96CD;} 
	#loginPage input{background-color:  #CDB5CD;}
	#loginPage button{background-color: #CDC1C5; width: 100px; text-align: center;}
	.main{padding: 20px;}
	.btnDiv{padding-left: 100px; padding-top: 100px;}
	
	#signupPage{background-color: #8DB6CD;}
	#signupPage input,.radioFieldset{background-color: #8DB6CD;}
	#signupPageHeader{background-color: #9AC0CD;}
	#signupPage button{background-color: #8FB6CD;}
	
</style>
</head>
<body>
	<div data-role="page" id="loginPage">
		<div data-role="header" id="loginPageHeader">
			<h1>LoginPage</h1>
		</div>
		<div data-role="main" class="main">
			<form id="loginForm">
			<fieldset class="ui-field-contain">
				<label for="loginName">nickName</label> <input type="text"
					name="loginName" id="loginName"   />
			</fieldset>
			<fieldset class="ui-field-contain">
				<label for="loginPassword">password</label> <input type="password"
					name="loginPassword" id="loginPassword"   />
			</fieldset>
			</form>
			<div class="btnDiv">
				<button data-inline = "true" id="login">login</button>
				<button data-inline = "true" id="signupBtn">signup</button>
			</div>
		</div>
	</div>
	<div data-role="page" id="signupPage">
		<div data-role="header" id="signupPageHeader">
			<h1>SignupPage</h1>
		</div>
		<div data-role="main" class="main">
			<form id="signupForm">
				<fieldset class="ui-field-contain">
					<label for="signupName">nickName</label> <input type="text"
						name="signupName" id="signupName" />
				</fieldset>
				<fieldset class="ui-field-contain">
					<label for="signupPassword">password</label> <input type="text"
						name="signupPassword" id="signupPassword" />
				</fieldset>
				<fieldset>
					male<input type="radio" name="sex"
						value="male" id="male" data-role = "none" checked="checked"/> female<input
						type="radio" name="sex" value="female" id="female" data-role = "none" />
				</fieldset>
			</form>
			<div class="btnDiv">
				<button id="signup" data-inline = "true" >signup</button>
				<button id="signupCancel" data-inline = "true" >cancel</button>
			</div>
		</div>
	</div>
</body>
</html>