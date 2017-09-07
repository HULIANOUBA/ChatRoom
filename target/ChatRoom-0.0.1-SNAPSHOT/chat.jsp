<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/jquery.mobile-1.4.5.min.css" />
<link rel="stylesheet" href="css/index.css" />
<script type="text/javascript" src="js/jquery.min.js"></script>
<script>
$(function() {
	var oldDate;
	var toName = "";
	var upTime,downTime;
	var top,left;
	setInterval(function() {
		var dataname = {
			"nickName" : $('#currentClientName').text()
		};
		$.ajax({
			type : "post",
			contentType : "application/json",
			data : JSON.stringify(dataname),
			url : "checkSession.spring?t=" + new Date().getTime(),
			success : function(data) {
				if (data == "repeat") {
					alert("您的账户已在别处登陆")
					window.location.href = "login.jsp";

				}
			}
		});
	}, 3000);
	var webSocket = null;
	if ('WebSocket' in window)
		webSocket = new WebSocket("ws://192.168.1.164:8080/ChatRoom/chat/"
				+ "${nickName}");
	else
		alert('Not support websocket');
	if ($('#msgList').find('li').length == 0)
		$('#msgList').append("<li id='nomsg'><h3>no message</h3></li>");
	webSocket.onopen = function() {
		oldDate = new Date();
		$('#contentUl').append(
				"<li  class='systemNotice'>" + getSingleDate(oldDate) + " "
						+ getSingleTime(oldDate) + "</li>");
	}
	webSocket.onmessage = function(event) {
		var data = JSON.parse(event.data);
		showMsg(data);
		$('#contentShowDiv')[0].scrollTop = $('#contentShowDiv')[0].scrollHeight;
	}
	window.onbeforeunload = function() {
		webSocket.close();
	}
	$(document).on(
			"pagecreate",
			"#chatPage",
			function() {
				$('#currentClientName').text('${nickName}');
				$('#userDiv').hide();
				$('#msga').click(function() {
					if ($('#msgDiv').is(":hidden")) {
						$('#msgDiv').show();
						$('#userDiv').hide();
					}
				});
				$('#usera').click(function() {
					if ($('#userDiv').is(":hidden")) {
						$('#userDiv').show();
						$('#msgDiv').hide();
					}
				});

				$('#sendBtn').click(function() {
					var content = $('#contentInput').val();
					if (content == "")
						alert("写点什么情感文字吧");
					else {
						var msg = {
							"type" : "user",
							"from" : '${nickName}',
							"content" : content,
							"to" : "public",
							"time" : getTimeNoSec()
						};
						webSocket.send(JSON.stringify(msg));
						$('#contentInput').val("");
					}
				});

				$('#leave').click(function() {
					if (confirm("要走了吗"))
						window.open("about:blank", "_self").close();
					else {
					}
				});
				$('#nickNameList').delegate("li", "click", function() {
					toName = $(this).text();
					if ($('#toName').text() != toName) {
						$('#toName').text(toName);
						$('#p_contentUl').find('li').remove();
					}
					window.location.href = "#privateChatPage";

				});
				$('#msgList').on("touchstart","li",function(){
				 	top=parseInt($(this).offset().top);
					left=parseInt($(this).offset().left);
				    $('#myPop').css({"top":top-270+"px","left":-6*left+"px"});
					var date=new Date();
					downTime=date.getTime(); 
				}).on("touchend","li",function(){
					var date=new Date();
					upTime=date.getTime();
					if(upTime-downTime>=800){ 
						setTimeout(function() {
							$("#myPop").popup("open");
						}, 0);
						var liMark=$(this).attr("id");
						$('#liMark').val(liMark);
					}else{
						toName = $(this).find('span[class="nameSpan"]')
						.text();
				if ($('#toName').text() != toName) {
					if($('#toName').text()==""){
						$('#toName').text(toName);
					}else{
						$('#toName').text(toName);
						$('#p_contentUl').find('li').remove();
						var nameData = {
							"toName" : toName
						};
						$.ajax({
							type : "post",
							contentType : "application/json",
							url : "getSingleChatList.spring?t="
									+ new Date().getTime(),
							data : JSON.stringify(nameData),
							success : function(data) {
								if(data==""){
									
								}else{
									
						          var mData=JSON.parse(data);
		                            $.each(mData,function(index,item){
		                   			if (item.from == '${nickName}'&& item.to==$('#toName').text() ) {
		        						$('#p_contentUl')
		        								.append(
		        										"<li class='selfli'><div class='selftimeandcontent'><span>"
		        												+ item.content
		        												+ "</span></div><div class='selfpic'><img src='"
		        												+ getAvatarUrl(item.from)
		        												+ "' width=\"50\" height=\"50\"  /></div></li>");

		        					}

		        					else if(item.to=='${nickName}'&& item.from==$('#toName').text()) {
		        						$('#p_contentUl')
		        								.append(
		        										"<li><div class='pic'><img src='"
		        												+ getAvatarUrl(item.from)
		        												+ "' width=\"50\" height=\"50\"  /></div><div class='timeandcontent'><span>"
		        												+ item.content
		        												+ "</span></div></li>");
		        					}
		                           }); 
								}
							}
						});
					}
				}
				window.location.href = "#privateChatPage";
				var liId = $(this).attr('id');
				$('#msgList').find("li[id='" + liId + "']")
						.find("span[id='redPointSpan']")
						.removeClass("redPoint");
					}
				}); 
				$('#delete').click(function(){
					var liMark=$(this).parent().parent().find('input').val();
					$('#msgList').find("li[id='"+liMark+"']").remove();
					$("#myPop").popup("close");
					if ($('#msgList').find('li').length == 0)
						$('#msgList').append("<li id='nomsg'><h3>no message</h3></li>");
				});
				$('#stick').click(function(){
					var liMark=$(this).parent().parent().find('input').val();
					$('#msgList').prepend($('#msgList').find("li[id='"+liMark+"']"));
					$('#msgList').find("li").css({"border-bottom":"1px dashed gray","border-top":"1px dashed gray"});
					$('#msgList').find("li[id='"+liMark+"']").css({"border-bottom":"1px solid gray","border-top":"1px solid gray"});
					$("#myPop").popup("close");
				});
			});
	
	function showMsg(data) {
		var newDate;
		var diffDate;//相差毫秒数
		var diffDay;//相差天数
		/* var diffHours相差小时数 */
		var diffMinutes;//相差分钟数
		newDate = new Date();
		diffDate = newDate.getTime() - oldDate.getTime();
		diffDay = Math.floor(diffDate / (24 * 3600 * 1000));
		if (diffDay >= 1) {
			$('#contentUl').append(
					"<li class='systemNotice'>" + getSingleDate(newDate)
							+ "</li>");
			oldDate = newDate;
		}
		/* diffHours=Math.floor(diffDate%(24*3600*1000)/(3600*1000)); */
		diffMinutes = Math.floor(diffDate % (24 * 3600 * 1000)
				% (3600 * 1000) / (60 * 1000));
		if (diffMinutes >= 2) {
			$('#contentUl').append(
					"<li  class='systemNotice'>" + getSingleTime(newDate)
							+ "</li>");
			oldDate = newDate;
		}

		if (data.type == "system") {
			$('#onlineCount').text(data.onlineCount);
			$('#nickNameList').find('li').remove();
			$.each(data.nickNameList, function(index, item) {
				$('#nickNameList').append(
						"<li><a href='#'>" + item + "</a></li>");
			});
			$('#contentUl').append(
					"<li class='systemNotice'>" + data.from + " "
							+ data.content + "</li>");
		} else if (data.type == "user") {
			if (data.to == "public") {
				if (data.from == '${nickName}')
					$('#contentUl')
							.append(
									"<li class='selfli'><div class='selftimeandcontent'><span>"
											+ data.content
											+ "</span></div><div class='selfpic'><img src='"
											+ getAvatarUrl(data.from)
											+ "' width=\"50\" height=\"50\"  /></div></li>");
				else
					$('#contentUl')
							.append(
									"<li><div class='pic'><img src='"
											+ getAvatarUrl(data.from)
											+ "' width=\"50\" height=\"50\"  /></div><div class='timeandcontent'><span>"
											+ data.content
											+ "</span></div></li>");
			} else {
				$('#msgList').find("li[id='nomsg']").remove();
				if (data.from == '${nickName}') {
					var item = $('#msgList').find(
							"li[id='" + data.to + "']");
					if (item == null) {
						$('#msgList')
								.append(
										"<li id='"+data.to+"'><div class='div1'><img src='"
												+ getAvatarUrl(data.to)
												+ "' width='50' height='50'></div><div class='div2'><span class='nameSpan'>"
												+ data.to
												+ "</span><span class='timeSpan'>"
												+ data.time
												+ "</span><span class='contentSpan'>"
												+ data.content
												+ "</span><span id='redPointSpan'></span></div></li>");
					} else {
						item.remove();
						$('#msgList')
								.append(
										"<li id='"+data.to+"'><div class='div1'><img src='"
												+ getAvatarUrl(data.to)
												+ "' width='50' height='50'></div><div class='div2'><span class='nameSpan'>"
												+ data.to
												+ "</span><span class='timeSpan'>"
												+ data.time
												+ "</span><span class='contentSpan'>"
												+ data.content
												+ "</span><span id='redPointSpan'></span></div></li>");
					}
				} else if (data.to == '${nickName}') {
					var item = $('#msgList').find(
							"li[id='" + data.from + "']");
					if (item == null) {
						$('#msgList')
								.append(
										"<li id='"+data.from+"'><div class='div1'><img src='"
												+ getAvatarUrl(data.from)
												+ "' width='50' height='50'></div><div class='div2'><span class='nameSpan'>"
												+ data.from
												+ "</span><span class='timeSpan'>"
												+ data.time
												+ "</span><span class='contentSpan'>"
												+ data.content
												+ "</span><span id='redPointSpan' class='redPoint'></span></div></li>");

					} else {
						item.remove();
						$('#msgList')
								.append(
										"<li id='"+data.from+"'><div class='div1'><img src='"
												+ getAvatarUrl(data.from)
												+ "' width='50' height='50'></div><div class='div2'><span class='nameSpan'>"
												+ data.from
												+ "</span><span class='timeSpan'>"
												+ data.time
												+ "</span><span class='contentSpan'>"
												+ data.content
												+ "</span><span id='redPointSpan' class='redPoint'></span></div></li>");
					}
				}

				if (data.from == '${nickName}') {
					$('#p_contentUl')
							.append(
									"<li class='selfli'><div class='selftimeandcontent'><span>"
											+ data.content
											+ "</span></div><div class='selfpic'><img src='"
											+ getAvatarUrl(data.from)
											+ "' width=\"50\" height=\"50\"  /></div></li>");

				}

				else {
					$('#p_contentUl')
							.append(
									"<li><div class='pic'><img src='"
											+ getAvatarUrl(data.from)
											+ "' width=\"50\" height=\"50\"  /></div><div class='timeandcontent'><span>"
											+ data.content
											+ "</span></div></li>");
				}
				var mData = {
						"toName":$('#toName').text(),
						"from":data.from,
						"to" : data.to,
						"content" : data.content,
					};
				$.ajax({
					type : "post",
					url : "saveChatRecord.spring?t="
							+ new Date().getTime(),
					contentType : "application/json",
					data : JSON.stringify(mData),
					success : function(data) {
						
					}
				});
			}
		}
	}
	$(document).on("pagecreate", "#mPage", function() {

		$('#pic').attr("src", getAvatarUrl('${nickName}'));
		$('#pic').click(function() {
			$('#upload').click();
			$('#upload').on("change", function() {
				var objUrl = getObjectURL(this.files[0]); //获取图片的路径，该路径不是图片在本地的路径
				if (objUrl) {
					$("#pic").attr("src", objUrl); //将图片路径存入src中，显示出图片
				}
			});
		});

		$('#save').click(function() {
			var formData = new FormData($('#mPageForm')[0]);
			$.ajax({
				type : "post",
				url : "updateUser.spring?t=" + new Date().getTime(),
				contentType : false,
				data : formData,
				processData : false,
				success : function(data) {
					if (data == "f") {
						alert("系统错误");
					} else {
						alert("保存成功")
						var mData = JSON.parse(data);
						if (mData.u_name == mData.u_oldname) {
						} else
							window.location.href = 'login.jsp';

					}

				}

			});
		});
	});
	$(document).on("pagecreate", "#privateChatPage", function() {
		$('#p_sendBtn').click(function() {
			var content = $('#p_contentInput').val();
			if (content == "")
				alert("写点什么情感文字吧");
			else {

				var msg = {
					"type" : "user",
					"from" : '${nickName}',
					"content" : content,
					"to" : $('#toName').text(),
					"time" : getTimeNoSec()
				};
				webSocket.send(JSON.stringify(msg));
				$('#p_contentInput').val("");

				/* $.ajax({
					type : "post",
					data : JSON.stringify(msg),
					contentType : "application/json",
					url : "insertMsg.spring?t=" + new Date().getTime(),
					success : function(data) {
						if (data == "f")
							alert("发送失败。。");
					}
				}); */
			}

		});

	});

	//建立一個可存取到該file的url
	function getObjectURL(file) {
		var url = null;
		if (window.createObjectURL != undefined) { // basic
			url = window.createObjectURL(file);
		} else if (window.URL != undefined) { // mozilla(firefox)
			url = window.URL.createObjectURL(file);
		} else if (window.webkitURL != undefined) { // webkit or chrome
			url = window.webkitURL.createObjectURL(file);
		}
		return url;
	}

	function getAvatarUrl(name) {
		var mData = {
			"nickName" : name
		};
		var avatarurl = "";
		$.ajax({
			type : "post",
			url : "queryAvatarUrlByNickname.spring?t="
					+ new Date().getTime(),
			contentType : "application/json",
			async : false,
			data : JSON.stringify(mData),
			success : function(data) {
				if (data != "" || data != null)
					avatarurl = data;
			}
		});
		return avatarurl;
	}

	var getDateFull = function() {
		var date = new Date();
		var currentdatetime = date.getFullYear() + "-"
				+ appendZero(date.getMonth() + 1) + "-"
				+ appendZero(date.getDate()) + " "
				+ appendZero(date.getHours()) + ":"
				+ appendZero(date.getMinutes()) + ":"
				+ appendZero(date.getSeconds());
		return currentdatetime;
	}
	var appendZero = function(s) {
		return ("00" + s).substr((s + "").length);
	}
	function getSingleDate(date) {
		var currentdate = date.getFullYear() + "-"
				+ appendZero(date.getMonth() + 1) + "-"
				+ appendZero(date.getDate());
		return currentdate;
	}
	function getSingleTime(date) {
		var currenttime = appendZero(date.getHours()) + ":"
				+ appendZero(date.getMinutes()) + ":"
				+ appendZero(date.getSeconds());
		return currenttime;
	}
	function getTimeNoSec() {
		var date = new Date();
		var currentdatetime = appendZero(date.getHours()) + ":"
				+ appendZero(date.getMinutes());
		return currentdatetime;
	}
})
</script>
<script type="text/javascript" src="js/jquery.mobile-1.4.5.min.js"></script>
<title>Insert title here</title>
</head>

<body>

	<div data-role="page" id="chatPage">
		<div data-role="panel" id="nickNameListPanel" data-position="left"
			data-display="reveal">
			<div data-role="popup" id="myPop" class="ui-content" data-arrow="l">
			      <input type="hidden" id="liMark" />
                  <ul>
                  <li id="stick">置顶</li>
                  <li id="delete">删除</li>
                  </ul>
            </div>
			<div data-role="header">
				<div data-role="navbar">
					<ul id="narbarul">
						<li><a data-icon="comment" href="#" id="msga"></a></li>
						<li><a data-icon="user" href="#" id="usera"></a></li>
					</ul>
				</div>
			</div>
			<div data-role="main">
				<div id="userDiv">
					<h2>
						在线人数: <span id="onlineCount">0</span>
					</h2>
					<ul id="nickNameList">

					</ul>
				</div>
				<div id="msgDiv">
					<ul id="msgList">

					</ul>
				</div>
			</div>
		</div>
		<div data-role="panel" id="settingPanel" data-position="right"
			data-display="reveal">
			<ul>
				<li><a id="setting" href="#mPage">个人设置</a></li>
				<li><a id="leave" href="#">退出</a></li>
			</ul>
		</div>
		<div data-role="header" data-position="fixed" id="chatPageHeader">
			<h2 id='currentClientName'>CHATROOM</h2>
			<a href="#nickNameListPanel">信息</a> <a href="#settingPanel">设置</a>
		</div>
		<div data-role="main" class="ui-content">
			<div id="contentShowDiv">
				<ul id="contentUl"></ul>
			</div>
			<div class="footer">
				<div style="display: inline-block;">
					<input type="text" id="contentInput" data-clear-btn="true" />
				</div>
				<div style="display: inline-block;">
					<button id="sendBtn" data-inline="true">send</button>
				</div>
			</div>
		</div>
	</div>
	<div data-role="page" id="mPage">
		<div data-role="main">
			<form id="mPageForm">
				<div class="ui-field-contain">
					<input type="hidden" value="${nickName}" name="oldNickname" /> <span
						class='mPageSpan'>昵称 :</span>
					<div id="nickNameDiv">
						<input type="text" id="nickName" value="${nickName}"
							name="nickName" />
					</div>
				</div>
				<div>
					<span class='mPageSpan'>头像 :</span> <img id="pic" width="200"
						height="200" src="" style="border-radius: 50%;" /> <input
						type="file" id="upload" value="上传" style="display: none;"
						name="avatar" />
				</div>
			</form>
		</div>
		<div data-role="footer" data-position="fixed" class="foot">

			<a href='#' id='save' class="btn">保存</a> <a href="#chatPage"
				class="btn">返回</a>

		</div>
	</div>
	<div data-role="page" id="privateChatPage">
		<div data-role="header" data-position="fixed"
			id="privateChatPageHeader">
			<h2 id='toName'></h2>
			<a href="#chatPage" id="back" data-rel="back" data-icon="back">返回</a>
		</div>
		<div data-role="main" class="ui-content">
			<div id="p_contentShowDiv">
				<ul id="p_contentUl"></ul>
			</div>
			<div class="p_footer">
				<div style="display: inline-block;">
					<input type="text" id="p_contentInput" data-clear-btn="true" />
				</div>
				<div style="display: inline-block;">
					<button id="p_sendBtn" data-inline="true">send</button>
				</div>
			</div>
		</div>
	</div>
</body>

</html>