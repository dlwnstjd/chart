<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>파이 그래프로 게시글 작성자의 건수 출력하기</title>
<script type="text/javascript" 
	src="http://www.chartjs.org/dist/2.9.3/Chart.min.js"></script>
<style>
	canvas {	/*글씨가 선택되지 않도록*/
		-moz-user-select: none;	/*파이어폭스 브라우저*/
		-webkit-user-select: none;	/*사파리 브라우저*/
		-ms-user-select: none;	/*익스플로러 브라우저*/
	}
</style>
<sql:setDataSource var="conn" driver="org.mariadb.jdbc.Driver"
	url="jdbc:mariadb://localhost:3306/classdb"
	user="scott" password="1234"/>
<sql:query var="rs" dataSource="${conn}">
SELECT name, count(*) cnt from board
	GROUP BY name
</sql:query>
</head>
<body>
<div style="width:75%;">
	<canvas id="canvas"></canvas>
</div>
<script type="text/javascript">
	var randomColorFactor = function(){
		return Math.round(Math.random() * 255);
	}
	var randomColor = function(opacity){
		return "rgba(" + randomColorFactor() + ","
			+ randomColorFactor() + ","
			+ randomColorFactor() + ","
			+ (opacity || '.3') + ")";
	};
	var config ={
		type: 'pie',
		data:{
			datasets:[{
				data:[<c:forEach items="${rs.rows}" var="m">
						"${m.cnt}",</c:forEach>],
				backgroundColor:[<c:forEach items="${rs.rows}" var="m">
						randomColor(1),</c:forEach>],
				label: '도넛 그래프'
			}],
			labels:[<c:forEach items="${rs.rows}" var="m">
					"${m.name}",</c:forEach>]			
			},
			options: {
				responsive: true,	//반응형 웹 설정
				legend: {position: 'top',},
				title:{
					display: true,
					text: '글쓴이 별 게시판 등록 건수',
					position: 'bottom'
				},
				animation:{
					animateScale: true,
					animateRotate: true
				}
			}
	};
	window.onload = function(){
		var ctx =
			document.getElementById('canvas').getContext('2d');
		window.myBar = new Chart(ctx,config);
	}
</script>
</body>
</html>