<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>���� �׷����� �Խñ� �ۼ����� �Ǽ� ����ϱ�</title>
<script type="text/javascript" 
	src="http://www.chartjs.org/dist/2.9.3/Chart.min.js"></script>
<style>
	canvas {	/*�۾��� ���õ��� �ʵ���*/
		-moz-user-select: none;	/*���̾����� ������*/
		-webkit-user-select: none;	/*���ĸ� ������*/
		-ms-user-select: none;	/*�ͽ��÷η� ������*/
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
				label: '���� �׷���'
			}],
			labels:[<c:forEach items="${rs.rows}" var="m">
					"${m.name}",</c:forEach>]			
			},
			options: {
				responsive: true,	//������ �� ����
				legend: {position: 'top',},
				title:{
					display: true,
					text: '�۾��� �� �Խ��� ��� �Ǽ�',
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