<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>막대/선 그래프로 게시글 작성자의 건수 출력하기</title>
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
SELECT date_format(regdate,'%Y%m%d') date, count(*) cnt from board
	GROUP BY date_format(regdate,'%Y%m%d')
	having count(*) > 1
	order by date_format(regdate,'%Y%m%d')
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
	var chartData = {
			labels: [<c:forEach items="${rs.rows}" var="m">
				"${m.date}",</c:forEach>],
			datasets: [
			{
				type: 'line',
				borderWidth: 2,
				borderColor:[<c:forEach items="${rs.rows}" var="m">
					randomColor(1),</c:forEach>],
				label: '건수',
				fill: false,
				data: [<c:forEach items="${rs.rows}" var="m">
					"${m.cnt}",</c:forEach>]
			},{
				type: 'bar',
				label: '건수',
				backgroundColor: [<c:forEach items="${rs.rows}" var="m">
					randomColor(1),</c:forEach>],
				data: [<c:forEach items="${rs.rows}" var="m">
					"${m.cnt}",</c:forEach>],
				borderWidth: 2
			}]
	};
	window.onload = function(){
		var ctx = document.getElementById('canvas').getContext('2d');
		new Chart(ctx, {
			type: 'bar',
			data: chartData,
			options: {
				responsive: true,
				title: {display:true, text:'게시판 등록 건수'},
				legend: {display: false},
				scales:{
					xAxes:[{
						display: true,
						scaleLabel: {
							display: true,
							labelString: "게시물 작성자"
						},
						stacked: true	
					}],
					yAxes: [{
						display: true,
						scaleLabel: {
							display: true,
							labelString: "게시물 작성건수"
						},
						stacked: true	//기본값 0부터 시작
					}]
				}
			}
		})
	}
</script>
</body>
</html>