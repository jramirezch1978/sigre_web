$PBExportHeader$w_fl020_empresa_provee.srw
forward
global type w_fl020_empresa_provee from w_abc_mastdet_smpl
end type
end forward

global type w_fl020_empresa_provee from w_abc_mastdet_smpl
integer width = 3470
integer height = 1900
string title = "Empresas y sus códigos de relación (FL020)"
string menuname = "m_mto_smpl"
end type
global w_fl020_empresa_provee w_fl020_empresa_provee

on w_fl020_empresa_provee.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl020_empresa_provee.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)

idw_1 = dw_detail              				// asignar dw corriente
//idw_query = dw_master								// ventana para query
dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado

//dw_master.of_protect()         		// bloquear modificaciones 
//dw_detail.of_protect()

of_position_window(0,0)       			// Posicionar la ventana en forma fija
ii_help = 101           					// help topic
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)
ii_consulta = 1                      // 1 = la lista de consulta es gobernada por el sistema de acceso
ii_access = 1								// 0 = menu (default), 1 = botones, 2 = menu + botones
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_fl020_empresa_provee
integer x = 0
integer width = 3424
integer height = 832
string title = "Empresas"
string dataobject = "d_empresa_tbl"
boolean vscrollbar = true
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1			// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
idw_det  =  dw_detail
end event

event dw_master::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop


end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_empresa


/////////////////////////creando nuevos codigo////////////////////////
select max(e.empresa) into :ls_empresa from fl_empresas e where substr(e.empresa,1,2) = :gs_origen;
ls_empresa = gs_origen+right(string((integer(right(ls_empresa,6))+1),'000000'),6)
this.object.empresa[this.RowCount()] = ls_empresa
end event

event dw_master::ue_insert;//////Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar/////
IF (dw_master.ii_update = 1) THEN
	IF MessageBox('Flota', '¿Desea gaurdar la empresa amterior?', Question!, YesNo!, 1) = 1 THEN
 		this.Update()
	ELSE
		dw_master.ii_update = 0
	END IF
END IF

///////Lo de abajo lo saco de la herencia... este evento ha perdido su herencia///////
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row
//////////////////////////////////////////////////////////////////////////////////////
end event

event dw_master::getfocus;call super::getfocus;ib_insert_mode = True
end event

event dw_master::updateend;call super::updateend;ib_insert_mode = True
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_fl020_empresa_provee
integer x = 0
integer y = 868
integer width = 2683
integer height = 808
string title = "Código Relación"
string dataobject = "d_empresa_provee_tbl"
boolean vscrollbar = true
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event dw_detail::constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = dw_master
idw_det = dw_detail
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;string ls_proveedor, ls_nom_proveedor, ls_sql, ls_empresa, ls_busca_prov, ls_cadena
long ll_row 
integer li_i, li_countcli
str_seleccionar lstr_seleccionar

this.AcceptText()
ll_row = this.rOWcOUNT()
ls_empresa = trim(dw_master.object.empresa[dw_master.getrow()])

declare lc_busca_prov cursor for
	select proveedor from fl_empresa_prove where empresa = :ls_empresa;
open lc_busca_prov;
fetch lc_busca_prov into :ls_busca_prov;

DO WHILE sqlca.sqlcode = 0
	ls_cadena = ls_cadena + " and proveedor <> '"+  trim(ls_busca_prov) +"'"
	fetch lc_busca_prov into :ls_busca_prov;
LOOP
close lc_busca_prov;

ls_cadena = right(ls_cadena, len(ls_cadena)-5)

if len(trim(ls_cadena)) > 0 then
	ls_cadena = ' where ' + ls_cadena
else
	ls_cadena = ''
end if

ls_sql = "select proveedor as Codigo, nom_proveedor as Descripcion from vw_fl_prov_non_relation"+ ls_cadena

lstr_seleccionar.s_column 	  = '1'
lstr_seleccionar.s_sql       = ls_sql
lstr_seleccionar.s_seleccion = 'S' //S SIMPLE Y M PARA MULTIPLE
OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
END IF	
IF lstr_seleccionar.s_action = "aceptar" THEN
	this.object.fl_empresa_prove_proveedor[ll_row] = lstr_seleccionar.param1[1]
	this.object.proveedor_nom_proveedor[ll_row] = lstr_seleccionar.param2[1]
	this.object.fl_empresa_prove_empresa[ll_row] = ls_empresa
	IF messagebox('FLOTA', 'DESEA GUARDAR LA RELACIOÓN CON ' + UPPER(TRIM(lstr_seleccionar.param2[1])),Question!,YesNo!,1) = 1 THEN
		parent.event ue_update()
	ELSE
		idw_det.retrieve(ls_empresa)
	END IF
ELSE
	idw_det.retrieve(ls_empresa)
END IF
end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

