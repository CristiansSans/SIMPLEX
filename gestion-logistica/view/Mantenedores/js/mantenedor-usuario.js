/**
 * @author haichele
 */
	function editarPermisosRol(){
		var codRol = $("#txtCodRol").val();
		cargaGrillaPermisos(codRol);
	    $( "#divFichaPermisos" ).dialog({
	      resizable: false,
	      height:500,
	      width:"500px",
	      modal: true,
	      title: "Permisos",
	      buttons: {
	        "Cerrar": function() {
	          $( this ).dialog( "close" );
	        }
	      }
	    });		
	}
	
	function cargaGrillaPermisos(codRol){
		var lastsel2;
		jQuery("#tblPermisos").jqGrid({
			url : '../../controller/mantenedores/grillaPermisosRol-listar.php?codRol='+codRol,
			datatype : "json",
			height:200,
			colNames : ['Codigo','Funcionalidad','Activo'],
			colModel : [{
				name : 'FUNC_NCORR',
				index : 'FUNC_NCORR',
				editable : false,
				width : 50,
				hidden : true
			}, {
				name : 'FUNC_VDESCRIPCION',
				index : 'FUNC_VDESCRIPCION',
				editable : false,					
				width : 350,
				hidden : false
			}, {
				name : 'Activo',
				index : 'Activo',
				editable : true,					
				width : 50,
				hidden : false,
				edittype : 'checkbox',
				formatter : 'checkbox'
			}],
			rowNum : 10,
			rowList:[10,20],
			pager: '#pagtblPermisos',
			sortname : 'FUNC_VDESCRIPCION',
			viewrecords : true,
			sortorder : "ASC",
			multiselect:true,
			//subgrid : true,
			editurl : "../../controller/mantenedores/editar-rol.php?codRol="+codRol,
			caption : "Funcionalidades",
			autowidth : true,			
	        ondblClickRow: function (rowid) {
	        },		        				
		});
		$('#tblPermisos').setGridParam({url: '../../controller/mantenedores/grillaPermisosRol-listar.php?codRol='+codRol}).trigger("reloadGrid");
		jQuery("#tblPermisos").jqGrid('navGrid',"#pagtblPermisos",{edit:true,add:false,del:false}); 
	}

	function cargaGrillaRoles(){			
		jQuery("#tblRoles").jqGrid({
			url : '../../controller/mantenedores/grillaRoles-listar.php',
			datatype : "json",
			height:400,
			colNames : ['Codigo','Rol'],
			colModel : [{
				name : 'ROL_NCORR',
				index : 'ROL_NCORR',
				editable : false,
				width : 50,
				hidden : false
			}, {
				name : 'ROL_VDESCRIPCION',
				index : 'ROL_VDESCRIPCION',
				editable : true,					
				width : 150,
				hidden : false
			}],
			rowNum : 20,
			rowList: [],  
			pgbuttons: false,
			pgtext: null,
			//rowList:[20,30,40],
			pager: '#pagTblRoles',
			sortname : 'ROL_VDESCRIPCION',
			viewrecords : false,
			sortorder : "ASC",
			multiselect:false,
			//subgrid : true,
			editurl : "../../controller/mantenedores/editar-rol.php",
			caption : "Roles",
			autowidth : true,	
			onSelectRow: function (rowid){
                var tnCodRol = $('#tblRoles').jqGrid('getCell', rowid, 'ROL_NCORR');                
                var tsNombreRol = $('#tblRoles').jqGrid('getCell', rowid, 'ROL_VDESCRIPCION');
			    
			    cargaGrillaUsuarios(tnCodRol,tsNombreRol);
			},		
	        ondblClickRow: function (rowid) {
	            var tnCodRol = $('#tblRoles').jqGrid('getCell', rowid, 'ROL_NCORR');	            
	            var tsNombreRol = $('#tblRoles').jqGrid('getCell', rowid, 'ROL_VDESCRIPCION');
	            $("#lblNombreRol").text(tsNombreRol);
	            $("#txtCodRol").val(tnCodRol);
	            editarPermisosRol();
	            //cargaGrillaPermisos(tnCodRol);
	            //cargaGrillaUsuarios(tnCodRol,tsNombreRol);
	        },					
		});
		$('#tblRoles').setGridParam({url:  '../../controller/mantenedores/grillaRoles-listar.php'}).trigger("reloadGrid");
		jQuery("#tblRoles").jqGrid('navGrid',"#pagTblRoles",{edit:true,add:false,del:true, search:false}); 
		jQuery("#tblRoles").jqGrid('inlineNav',"#pagTblRoles");													
	}
	
	function cargaGrillaUsuarios(codRol, nombreRol){
		$("#txtCodRol").val(codRol);		
		var lastsel2;
		jQuery("#tblUsuarios").jqGrid({
			url : '../../controller/mantenedores/grillaUsuarios-listar.php?codRol='+codRol,
			datatype : "json",
			height:400,
			colNames : ['Codigo','Login','Nombre','Ap.Paterno','Ap.Materno','Mail','Clave'],
			colModel : [{
				name : 'USUA_NCORR',
				index : 'USUA_NCORR',
				editable : false,
				width : 50,
				hidden : true
			}, {
				name : 'USUA_VLOGIN',
				index : 'USUA_VLOGIN',
				editable : true,					
				width : 100,
				hidden : false
			}, {
				name : 'USUA_VNOMBRE',
				index : 'USUA_VNOMBRE',
				editable : true,					
				width : 100,
				hidden : false
			}, {
				name : 'USUA_VAPELLIDO1',
				index : 'USUA_VAPELLIDO1',
				editable : true,					
				width : 100,
				hidden : false
			}, {
				name : 'USUA_VAPELLIDO2',
				index : 'USUA_VAPELLIDO2',
				editable : true,					
				width : 100,
				hidden : false
			}, {
				name : 'USUA_VMAIL',
				index : 'USUA_VMAIL',
				editable : true,					
				width : 100,
				hidden : false,
				formatter: "email"
			}, {
				name : 'USUA_VCLAVE',
				index : 'USUA_VCLAVE',
				editable : true,					
				width : 0,
				hidden : false,
				edittype:"password",
				formater : 'password'
			}],
			rowNum : 20,
			//rowList:[20,30,40],
			pager: '#pagTblUsuarios',
			sortname : 'USUA_VLOGIN',
			viewrecords : true,
			sortorder : "ASC",
			multiselect:false,
			//subgrid : true,
			editurl : "../../controller/mantenedores/editar-usuario.php?codRol="+codRol,
			caption : "Usuarios del rol",
			autowidth : false,			
	        ondblClickRow: function (rowid) {
	            
	        },			
			onSelectRow : function(id) {
				/*if (id && id !== lastsel2) {
					jQuery('#tblUsuarios').jqGrid('restoreRow', lastsel2);
					jQuery('#tblUsuarios').jqGrid('editRow', id, true);
					lastsel2 = id;
  					var cont = $('#tblUsuarios').getCell(id, 'USUA_VLOGIN');
				}*/
			}	        		
		});
		$('#tblUsuarios').setGridParam({url:  '../../controller/mantenedores/grillaUsuarios-listar.php?codRol='+codRol, caption : "Usuarios del rol " + nombreRol}).trigger("reloadGrid");
		jQuery("#tblUsuarios").jqGrid('navGrid',"#pagTblUsuarios",{edit:true,add:false,del:true}); 
		jQuery("#tblUsuarios").jqGrid('inlineNav',"#pagTblUsuarios");		
	}

	function validaAlmacenamiento(){
		if (validaRutObjeto($("#txtRutEmpresa"))){
			
			if ($("#txtNombreEmpresa").val()==""){
				alert("Debe ingresar el nombre de la empresa");
			}else{
				return true;
			}
			
		}
		return false;
	}
	
	function asignarPermisos(){
		var params;
		var lsTextoEnviar;
		var codRol = $("#txtCodRol").val();
		var checkValoresSeleccionados = jQuery("#tblPermisos").jqGrid('getGridParam', 'selarrrow');
		
		lsTextoEnviar = "";
		$.each(checkValoresSeleccionados, function () {
			var rowid = this;
			CodPermiso = $('#tblPermisos').jqGrid('getCell', rowid, 'FUNC_NCORR');
			params = "oper=add&codRol="+ codRol + "&func=" + CodPermiso;
			
			$.ajax({
				type : "POST",
				async: false,
				url : "../../controller/mantenedores/editar-permiso-rol.php?"+ params,
				dataType : "json",
				//data: objJson,
				success : function(result) {
					
				}
			});			
		});
		cargaGrillaPermisos(codRol);
		alert("Permisos asignados exitosamente");		
	}
	
	function quitarPermisos(){
		var params;
		var lsTextoEnviar;
		var codRol = $("#txtCodRol").val();
		var checkValoresSeleccionados = jQuery("#tblPermisos").jqGrid('getGridParam', 'selarrrow');
		
		lsTextoEnviar = "";
		$.each(checkValoresSeleccionados, function () {
			var rowid = this;
			CodPermiso = $('#tblPermisos').jqGrid('getCell', rowid, 'FUNC_NCORR');
			params = "oper=del&codRol="+ codRol + "&func=" + CodPermiso;
			
			$.ajax({
				type : "POST",
				url : "../../controller/mantenedores/editar-permiso-rol.php?"+ params,
				dataType : "json",
				//data: objJson,
				success : function(result) {
					
				}
			});			
		});		
		cargaGrillaPermisos(codRol);
		alert("Permisos quitados exitosamente");		
	}
