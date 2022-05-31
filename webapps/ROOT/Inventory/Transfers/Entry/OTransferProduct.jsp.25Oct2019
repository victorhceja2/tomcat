<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.io.*, java.text.*"%>
<%@ page import="generals.*"%>
<%!AbcUtils moAbcUtils = new AbcUtils();%>
<%
	String lsNStore=request.getParameter("remSt");
System.out.println("NStore: [" + lsNStore + "]");
%>
<html>
<head>
<link rel="stylesheet" type="text/css"
	href="/CSS/GeneralStandardsYum.css" />
<link rel="stylesheet" type="text/css"
	href="/CSS/DataGridDefaultYum.css" />
<link rel="stylesheet" type="text/css" href="/CSS/TooltipsYum.css" />

<script src="/Scripts/RemoteScriptingYum.js"></script>
<script src="/Scripts/AbcUtilsYum.js"></script>
<script src="/Scripts/ReportUtilsYum.js"></script>
<script src="/Scripts/Chars.js"></script>
<script src="/Scripts/StringUtilsYum.js"></script>
<script src="/Scripts/HtmlUtilsYum.js"></script>

<script>
	function nuevoAjax() {
		/*
		 * Crea el objeto AJAX. Esta funcion es generica para cualquier utilidad de
		 * este tipo, por lo que se puede copiar tal como esta aqui
		 */
		var xmlhttp = false;
		try {
			// Creacion del objeto AJAX para navegadores no IE
			xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try {
				// Creacion del objet AJAX para IE
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (E) {
				if (!xmlhttp && typeof XMLHttpRequest != 'undefined')
					xmlhttp = new XMLHttpRequest();
			}
		}
		return xmlhttp;
	}

	function sleep(milliseconds) {
		var start = new Date().getTime();
		for (var i = 0; i < 1e7; i++) {
			if ((new Date().getTime() - start) > milliseconds) {
				break;
			}
		}
	}

	function inicializaValores() {
		document.getElementById("clases").value = 0;
		document.getElementById("cant").value = 0
		document.getElementById("divReceta").innerHTML = "";
		document.frmGrid.btnUpdate.disabled = true;
	}

	function limpiaPantalla() {
		var tables = [ "Bases", "Sizes", "Prod", "Topp", "Prod2", "Topp2" ];
		for (var i = 0; i < tables.length; i++) {
			document.getElementById(tables[i]).style.display = 'none';
			document.getElementById(tables[i]).innerHTML = "";
		}
		document.getElementById("divHalf").style.display = 'none';
	}

	function limpiaDivTopps(divTop) {
		document.getElementById(divTop).style.display = 'none';
		document.getElementById(divTop).innerHTML = "";
	}

	function iniciaCarga() {
		var tables = [ "Bases", "Sizes", "Prod" ];
		var clss = document.getElementById("clases").value;
		//limpiaPantalla();
		for (var i = 0; i < tables.length; i++) {
			cargaContenido(tables[i], clss, "");
			sleep(100);
		}
		if (clss == '001') {
			document.getElementById("divHalf").style.display = 'inline';
		}
	}

	function muestraProd2(chk) {
		if (chk.checked) {
			cargaContenido('Prod2', document.getElementById('clases').value,
					false)
		} else {
			document.getElementById("Prod2").style.display = 'none';
			document.getElementById("Prod2").innerHTML = "";
			limpiaDivTopps("Topp2");
		}
	}

	function cargaContenido(lsTable, clss, mult) {
		//var selectDestino = document.getElementById("Bases");
		document.getElementById(lsTable).style.display = 'inline';
		var selectDestino = document.getElementById(lsTable);
		//alert("Se seleccionó la clase " + clss
		//	+ ", se ingresara en el destino: " + selectDestino);
		var ajax = nuevoAjax();
		ajax.open("GET", "IChooseClassYum.jsp?class=" + clss + "&table="
				+ lsTable + "&mult=" + mult, true);
		ajax.onreadystatechange = function() {
			/*if (ajax.readyState == 1) {
				// Mientras carga elimino la opcion "Selecciona Opcion..." y
				// pongo una que dice "Cargando..."
				//selectDestino.length = 0;
				var nuevaOpcion = document.createElement("p");
				//nuevaOpcion.value = 0;
				var t = document.createTextNode("Cargando " + lsTable + "...");
				nuevaOpcion.appendChild(t);
				selectDestino.appendChild(nuevaOpcion);
			}*/
			if (ajax.readyState == 4) {
				selectDestino.innerHTML = ajax.responseText;
			}
		}
		ajax.send(null);
	}

	function validaProd(cmbProd, divElem) {
		var prod = document.getElementById(cmbProd).value;
		var clss = document.getElementById("clases").value;
		if (prod == '059' || prod == '060') {
			limpiaDivTopps(divElem);
			cargaContenido(divElem, clss, "true");
		} else if (prod == '054') {
			//alert("Se selecciono el producto " + prod);
			limpiaDivTopps(divElem);
			cargaContenido(divElem, clss, "false");
		} else {
			limpiaDivTopps(divElem);
		}
	}

	function buscaReceta() {
		var nStore =
<%=lsNStore%>
	+ '';
		//alert("Se buscara informacion para transferir al CC [" + nStore + "]");
		var cont = "true";
		var cantProd = document.getElementById("cant").value;
		var clss = document.getElementById("clases").value;
		var base = "";
		var size = "";
		var prod = "";
		var topp = "";
		var prod2 = "";
		var topp2 = "";
		var half = document.getElementById("half") != null ? document
				.getElementById("half") : '';

		if (clss == "0") {
			alert("Por favor seleccione la clase del producto a traspasar");
			focusElement('clases');
			cont = "false";
		} else {
			base = document.getElementById("base") != null ? document
					.getElementById("base").value : '000';
			size = document.getElementById("sizes") != null ? document
					.getElementById("sizes").value : '000';
			prod = document.getElementById("prod").value;
			topp = document.getElementById("topp") != null ? (document
					.getElementById("topp").type != "select-multiple" ? document
					.getElementById("topp").value
					+ ","
					: "")
					: '000';
			prod2 = document.getElementById("prod2") != null ? document
					.getElementById("prod2").value : '000';
			topp2 = document.getElementById("topps2") != null ? (document
					.getElementById("topps2").type != "select-multiple" ? document
					.getElementById("topps2").value
					+ ","
					: "")
					: '000';

			if (topp == "") {
				//for (var elem=0;elem<)
				var selTopp = document.getElementById("topp");
				for (var elem = 0; elem < selTopp.length; elem++) {
					if (selTopp.options[elem].selected) {
						topp += selTopp.options[elem].value + ",";
					}
				}
			}
			if (topp2 == "") {
				//for (var elem=0;elem<)
				var selTopp = document.getElementById("topps2");
				for (var elem = 0; elem < selTopp.length; elem++) {
					if (selTopp.options[elem].selected) {
						topp2 += selTopp.options[elem].value + ",";
					}
				}
			}

			if (base == "0") {
				alert("Por favor seleccione la base del producto");
				focusElement('base');
				cont = "false";
			} else if (size == "0") {
				alert("Por favor seleccione el tama&ntilde;o del producto");
				focusElement('sizes');
				cont = "false";
			} else if (prod == "0") {
				alert("Por favor seleccione el producto a traspasar");
				focusElement('prod');
				cont = "false";
			} else if (topp == "") {
				alert("Por favor seleccione un topping");
				focusElement('topp');
				cont = "false";
			} else if (prod2 == "0") {
				alert("Por favor seleccione el producto a traspasar");
				focusElement('prod2');
				cont = "false";
			} else if (topp2 == "") {
				alert("Por favor seleccione un topping");
				focusElement('topp2');
				cont = "false";
			}
		}

		if (cont == "true") {
			if (cantProd == "0") {
				alert("Por favor ingrese la cantidad de producto a traspasar");
				focusElement('cant');
			} else {

				var descProduc = new Array();
				descProduc.push(clss);
				descProduc.push(base);
				descProduc.push(size);
				descProduc.push(prod);
				descProduc.push(topp);
				descProduc.push(half == "" ? "0" : (half.checked ? half.value
						: "0"));
				descProduc.push(prod2);
				descProduc.push(topp2);
				descProduc.push(cantProd);
				descProduc.push(nStore);
				//alert(descProduc);
				//var descProduc = clss + "," + base + "," + size + "," + prod + "," + cantProd; 
				jsrsExecute("RemoteProductMethods.jsp", muestraProductos,
						"getItems", descProduc);
				//muestraProductos();
			}
		}
	}

	function muestraProductos(lsResponse) {
		document.getElementById("divReceta").innerHTML = lsResponse;
		document.getElementById("btnActualizar").style.display = 'inline';
		document.frmGrid.btnUpdate.disabled = false;
	}

	function submitUpdate() {
		var loUser = parent.getUser();
		var lsPass = parent.getPwd();
		var user_pwd = new Array();
		user_pwd.push(loUser);
		user_pwd.push(lsPass);

		jsrsExecute("RemoteProductMethods.jsp", validateCredentials,
				"verifyCredentials", user_pwd);
	}

	function validateCredentials(rsUserPwd) {
		if (rsUserPwd == "FALSE" || rsUserPwd == "ERROR") {
			parent.focusElement('cmbAsoc');
			alert('El usuario y/o contraseña no coinciden');
			return false;
		} else {
			document.frmGrid.hidNeighborStore.value = parent
					.getIdNeighborStore();
			alert(document.frmGrid.hidNeighborStore.value);

			document.frmGrid.target = "destino";
			openWindow("", "destino", 990, 600);
			document.frmGrid.submit();
		}
	}
</script>
</head>
<body bgcolor="white" onload="limpiaPantalla(); inicializaValores()">
	<!-- 	<form action=""> -->
	<form name="frmGrid" id="frmGrid" method="post"
		action="ITransferPreviewYum.jsp">
		<table width="98%" align="center" border="0">
			<tr>
				<td class="body">
					<div id="class">
						<select name="clases" id="clases"
							onChange="limpiaPantalla(); iniciaCarga();">
							<option value="0">Seleccione una clase</option>
							<%
								String lsClases = moAbcUtils.queryToString(
										"SELECT clno, cldesc FROM sus_clss", "|", ">");
								String[] laClases = lsClases.split("\\|");
								for (String lrClases : laClases) {
									//System.out.println("lrClases: " + lrClases);
									String[] lsClass = lrClases.split(">");
									out.println("<option value=" + lsClass[0] + "> " + lsClass[1]
											+ " </option>");
								}
							%>
						</select>
					</div>
				</td>
				<td>
					<div id="Bases"></div>
				</td>
				<td>
					<div id="Sizes"></div>
				</td>
				<td>
					<div id="Prod"></div>
				</td>
				<td>
					<div id="Topp"></div>
				</td>
				<td>
					<div id="Prod2"></div>
				</td>
				<td>
					<div id="Topp2"></div>
				</td>
				<td>
					<div id="divHalf" style='display: none;'>
						<input type="checkbox" name="half" id="half" value="1"
							onchange="muestraProd2(this)">Mitad
					</div>
				</td>
				<td>
					<div id="divCant">
						Cantidad: <input type="text" maxlength="4" name="cant" id="cant">
					</div>
			</tr>
			<tr>
				<td colspan="9" class="descriptionTabla">
					<div id="btnsSearch">
						<table>
							<tr>
								<td>
									<div id="btnActualizar" style='dysplay: none;'>
										<input type="button" value="Actualizar" id="btnUpdate"
											name="btnUpdate"
											onclick="submitUpdate(); inicializaValores(); limpiaPantalla()">
									</div>
								</td>
								<td><input type="button" value="Cancelar"
									onclick="inicializaValores(); limpiaPantalla()"></td>
								<td><input type="button" value="Buscar"
									onclick="buscaReceta()"><input type="hidden"
									name="hidNeighborStore" id="hidNeighborStore"><input
									type="hidden" name="hidUser" id="hidUser"> <input
									type="hidden" id="transferProd" name="transferProd" value="1">
								</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="9">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="9">
					<div id="divReceta"></div>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>