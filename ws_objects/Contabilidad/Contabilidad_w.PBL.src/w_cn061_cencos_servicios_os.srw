$PBExportHeader$w_cn061_cencos_servicios_os.srw
forward
global type w_cn061_cencos_servicios_os from w_abc_master_lstmst
end type
type uo_search from n_cst_search within w_cn061_cencos_servicios_os
end type
type dw_usuarios from u_dw_abc within w_cn061_cencos_servicios_os
end type
type dw_servicios from u_dw_abc within w_cn061_cencos_servicios_os
end type
type st_usuarios from statictext within w_cn061_cencos_servicios_os
end type
type st_servicios from statictext within w_cn061_cencos_servicios_os
end type
end forward

global type w_cn061_cencos_servicios_os from w_abc_master_lstmst
integer width = 4137
integer height = 2644
string title = "[CN061] Centros Costo - Usuarios - Servicios"
string menuname = "m_abc_master_smpl"
uo_search uo_search
dw_usuarios dw_usuarios
dw_servicios dw_servicios
st_usuarios st_usuarios
st_servicios st_servicios
end type
global w_cn061_cencos_servicios_os w_cn061_cencos_servicios_os

type variables
DatawindowChild idw_child_n2, idw_child_n3
end variables

on w_cn061_cencos_servicios_os.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.uo_search=create uo_search
this.dw_usuarios=create dw_usuarios
this.dw_servicios=create dw_servicios
this.st_usuarios=create st_usuarios
this.st_servicios=create st_servicios
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search
this.Control[iCurrent+2]=this.dw_usuarios
this.Control[iCurrent+3]=this.dw_servicios
this.Control[iCurrent+4]=this.st_usuarios
this.Control[iCurrent+5]=this.st_servicios
end on

on w_cn061_cencos_servicios_os.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_search)
destroy(this.dw_usuarios)
destroy(this.dw_servicios)
destroy(this.st_usuarios)
destroy(this.st_servicios)
end on

event resize;// Override
decimal	ldc_mitad

dw_lista.height 	= newheight - dw_lista.y - 10

uo_search.width  = dw_lista.width
uo_search.event ue_resize( sizetype, dw_lista.width, newheight)

ldc_mitad = newHeight / 2

st_usuarios.width 	= newWidth - st_usuarios.x - 10
dw_usuarios.width 	= st_usuarios.width
dw_usuarios.height 	= newheight - ldc_mitad - 5

st_servicios.y  		= ldc_mitad + 5
st_servicios.width  	= newwidth  - st_servicios.x - 10

dw_servicios.y 		= st_servicios.y + st_servicios.height + 10
dw_servicios.width  	= newwidth  - dw_servicios.x - 10
dw_servicios.height 	= newheight - dw_servicios.y - 10
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

dw_usuarios.of_set_flag_replicacion()
dw_servicios.of_set_flag_replicacion()

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_usuarios) <> true then return
if gnvo_app.of_row_Processing( dw_servicios) <> true then return


ib_update_check = true
end event

event ue_open_pre;call super::ue_open_pre;this.event ue_retrieve()

uo_search.of_set_dw( dw_lista )
end event

event ue_dw_share;//Override
end event

event ue_retrieve;call super::ue_retrieve;Long	ll_row

ll_row = dw_lista.getRow()

dw_lista.Retrieve()

if dw_lista.RowCount() > ll_row and ll_row > 0 then
	dw_lista.SetRow(ll_row)
	dw_lista.SelectRow(0, false)
	dw_lista.SelectRow(ll_row, true)
	dw_lista.event ue_output(ll_row)
else

	dw_usuarios.Reset()
	dw_usuarios.ResetUpdate()
	dw_usuarios.ii_update = 0

	dw_servicios.Reset()
	dw_servicios.ResetUpdate()
	dw_servicios.ii_update = 0

end if
end event

event ue_update;//Override

Boolean 	lbo_ok = TRUE
String	ls_crlf

ls_crlf = char(13) + char(10)

dw_usuarios.AcceptText()
dw_servicios.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_usuarios.of_create_log()
	dw_servicios.of_create_log()
END IF

IF	dw_usuarios.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_usuarios.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		messagebox("Error", "Error en Grabacion en USUARIOS", StopSign!)
	END IF
END IF

IF	dw_servicios.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_servicios.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		messagebox("Error", "Error en Grabacion en SERVICIOS", StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_usuarios.of_save_log()
		lbo_ok = dw_servicios.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	
	dw_usuarios.ii_update = 0
	dw_usuarios.il_totdel = 0
	dw_usuarios.ResetUpdate()
	dw_usuarios.ii_protect = 0
	dw_usuarios.of_protect( )

	dw_servicios.ii_update = 0
	dw_servicios.il_totdel = 0
	dw_servicios.ResetUpdate()
	dw_servicios.ii_protect = 0
	dw_servicios.of_protect( )

	f_mensaje('Grabación realizada satisfactoriamente', '')
	
	this.event ue_retrieve()
	
END IF


end event

type dw_master from w_abc_master_lstmst`dw_master within w_cn061_cencos_servicios_os
boolean visible = false
integer x = 0
integer y = 1928
integer width = 128
integer height = 92
boolean enabled = false
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw

end event

event dw_master::ue_insert_pre;THIS.OBJECT.origen 		[al_row] = gs_origen
THIS.OBJECT.flag_estado [al_row] = '1'
end event

event dw_master::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cencos_niv1, ls_cencos_niv2

choose case lower(as_columna)
	case "cod_n1"
		ls_sql = "SELECT COD_N1 AS CENCOS_NIV1, "&
				 + "DESCRIPCION AS descripcion_niv1 "&
				 + "FROM CENCOS_NIV1 " &
				 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_n1		[al_row] = ls_codigo
			this.object.desc_nivel1	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_n2"
		ls_cencos_niv1 = this.object.cod_n1[this.GetRow()]
		
		if ls_cencos_niv1 = '' or IsNull(ls_cencos_niv1) then
			f_mensaje("Debe Seleccionar primero el nivel1, por favor verifica", "")
			this.SetColumn("cod_n1")
		end if
		
		ls_sql = "SELECT COD_N2 AS CENCOS_NIV2, "&				
				 + "DESCRIPCION AS DESCRIPCION_NIV2 "&
				 + "FROM CENCOS_NIV2 " &
				 + "WHERE COD_N1 = '" + ls_cencos_niv1 + "'" &
				 + "  and FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_n2		[al_row] = ls_codigo
			this.object.desc_nivel2	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_n3"
		ls_cencos_niv1 = this.object.cod_n1[this.GetRow()]
		
		if ls_cencos_niv1 = '' or IsNull(ls_cencos_niv1) then
			f_mensaje("Debe Seleccionar el nivel1, por favor verifica", "")
			this.SetColumn("cod_n1")
		end if
		
		ls_cencos_niv2 = this.object.cod_n2[this.GetRow()]
		
		if ls_cencos_niv2 = '' or IsNull(ls_cencos_niv2) then
			f_mensaje("Debe Seleccionar el nivel2, por favor verifica", "")
			this.SetColumn("cod_n2")
		end if

		ls_sql = "SELECT COD_N3 AS CENCOS_NIV3, "&
				 + "DESCRIPPCION AS DESCRIPCION_NIV3 "&
				 + "FROM CENCOS_NIV3 " &
				 + "WHERE COD_N1 = '" + ls_cencos_niv1 + "'" &
				 + "  AND COD_N2 = '" + ls_cencos_niv2 + "'" &
				 + "  and FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_n3		[al_row] = ls_codigo
			this.object.desc_nivel3	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "grp_cntbl"
		ls_sql = "SELECT GRP_CNTBL AS GRUPO_CONTABLE, " &
				  + "DESC_GRP_CNTBL AS DESC_GRUPO_CONTABLE " &
				  + "FROM GRUPO_CONTABLE " 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.GRP_CNTBL		[al_row] = ls_codigo
			this.object.DESC_GRP_CNTBL	[al_row] = ls_data
			this.ii_update = 1
		end if

END CHOOSE

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

type dw_lista from w_abc_master_lstmst`dw_lista within w_cn061_cencos_servicios_os
integer x = 0
integer y = 88
integer width = 1938
integer height = 1676
string dataobject = "d_lista_centros_costo_tbl"
end type

event dw_lista::constructor;call super::constructor;ii_ck[1] = 1      // columnas de lectrua de este dw

end event

event dw_lista::ue_output;call super::ue_output;if al_row = 0 then 
	dw_usuarios.reset()
	dw_servicios.reset()

else
	dw_usuarios.retrieve(this.object.cencos	[al_row])
	dw_servicios.retrieve(this.object.cencos	[al_row])
end if

dw_usuarios.ResetUpdate()
dw_servicios.ResetUpdate()

dw_usuarios.ii_protect = 0
dw_servicios.ii_protect = 0

end event

event dw_lista::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
if currentrow > 0 then
	this.event ue_output(currentrow)
end if
end event

type uo_search from n_cst_search within w_cn061_cencos_servicios_os
integer width = 1911
integer taborder = 30
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

type dw_usuarios from u_dw_abc within w_cn061_cencos_servicios_os
integer x = 1947
integer y = 88
integer width = 1070
integer height = 728
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_cencos_aprob_os_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

end event

event ue_insert_pre;call super::ue_insert_pre;if dw_lista.getRow() = 0 then return

this.object.cencos [al_Row] = dw_lista.object.cencos [dw_lista.getRow()]
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "cod_usr"
		ls_sql = "select u.cod_usr as codigo_usuario," &
				 + "u.nombre as nombre_usuario " &
				 + "from usuario u " &
				 + "where u.flag_estado = '1'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
			this.object.cod_usr		[al_row] = ls_codigo
			this.object.nom_usuario	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event itemchanged;call super::itemchanged;String ls_data

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_usr'
		
		// Verifica que codigo ingresado exista			
		Select nombre
	     into :ls_data
		  from usuario
		 Where cod_usr = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_usr		[row] = gnvo_app.is_null
			this.object.nom_usuario	[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de USUARIO ' + data + ' no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.nom_usuario			[row] = ls_data


END CHOOSE
end event

type dw_servicios from u_dw_abc within w_cn061_cencos_servicios_os
integer x = 1947
integer y = 924
integer width = 1070
integer height = 728
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_cencos_servicios_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

end event

event ue_insert_pre;call super::ue_insert_pre;if dw_lista.getRow() = 0 then return

this.object.cencos [al_Row] = dw_lista.object.cencos [dw_lista.getRow()]
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "servicio"
		ls_sql = "select s.servicio as servicio, " &
				 + "s.descripcion as descripcion_servicio " &
				 + "  from servicios s " &
				 + " where s.flag_estado = '1'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
			this.object.servicio			[al_row] = ls_codigo
			this.object.desc_servicio	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event itemchanged;call super::itemchanged;String ls_data

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'servicio'
		
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_data
		  from servicios
		 Where servicio = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.servicio			[row] = gnvo_app.is_null
			this.object.desc_servicio	[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de SERVICIO ' + data + ' no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_servicio			[row] = ls_data


END CHOOSE
end event

type st_usuarios from statictext within w_cn061_cencos_servicios_os
integer x = 1947
integer width = 1070
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Usuarios Aprob OS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_servicios from statictext within w_cn061_cencos_servicios_os
integer x = 1947
integer y = 832
integer width = 1070
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Servicios para OS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

