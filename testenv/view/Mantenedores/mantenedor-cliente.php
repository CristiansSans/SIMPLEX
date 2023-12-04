<html>
	<script language="JavaScript" type="text/javascript">
		function cargaGrillaClientes() {

		}

		function agregarNuevoCliente() {

		}

		$(function() {
			cargaGrillaClientes();
		});
	</script>
	<body>
		<h1>Clientes</h1>
		<div>
			<table id="tblClientes"/>
			<button id="btnNuevocliente" onclick="agregarNuevoCliente()">
				Agregar cliente
			</button>
		</div>
		<div id="divFichaCliente">
			<!--Encabezado de la ficha-->
			<table id="tblEncabezadoFicha" width="100%">
				<tr>
					<th width="20%">Rut</th>
					<td width="30%"></td>
					<th width="20%">Nombre</th>
					<td width="30%"></td>
				</tr>
				<tr>
					<th>Contacto legal</th>
					<td></td>
					<th>Direccion</th>
					<td></td>
				</tr>
				<tr>
					<th>Ciudad</th>
					<td></td>
					<th>Comuna</th>
					<td></td>
				</tr>
				<tr>
					<th>Empresa padre</th>
					<td></td>
					<th>Giro</th>
					<td></td>
				</tr>
				<tr>
					<th>Fono</th>
					<td></td>
					<td></td>
					<td></td>
				</tr>
			</table>
			<!--Tarifas de servicios-->
			<table id="tblTarifasServicios" width="100%"/>
		</div>
	</body>
</html>