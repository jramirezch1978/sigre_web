$PBExportHeader$w_rh008_asigna_origen.srw
forward
global type w_rh008_asigna_origen from w_abc_mastdet
end type
type dw_usuarios from u_dw_abc within w_rh008_asigna_origen
end type
type st_1 from statictext within w_rh008_asigna_origen
end type
type st_2 from statictext within w_rh008_asigna_origen
end type
type st_3 from statictext within w_rh008_asigna_origen
end type
end forward

global type w_rh008_asigna_origen from w_abc_mastdet
integer width = 3438
integer height = 2216
string title = "(RH008) Asignación de Orígenes por Usuarios"
string menuname = "m_master_simple"
dw_usuarios dw_usuarios
st_1 st_1
st_2 st_2
st_3 st_3
end type
global w_rh008_asigna_origen w_rh008_asigna_origen

on w_rh008_asigna_origen.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.dw_usuarios=create dw_usuarios
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_usuarios
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
end on

on w_rh008_asigna_origen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_usuarios)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
end on

event resize;// Override

st_2.y = newheight/2 + 10

//OT ADM
dw_master.width	= newwidth/2  - dw_master.x - 10
dw_master.height	= st_2.y - 10
st_1.width 			= dw_master.width

//Listado de usuarios
dw_usuarios.x 			= dw_master.x + dw_master.width + 10
dw_usuarios.y			= dw_master.y
dw_usuarios.width   	= newwidth  - dw_usuarios.x - 10
dw_usuarios.height  	= newheight - dw_usuarios.y - 10

//Listado de OTs
dw_detail.y 			= st_2.y + st_2.height + 10
dw_detail.width		= newwidth/2  - dw_detail.x - 10
dw_detail.height		= newheight - dw_detail.y - 10
st_2.width 				= dw_detail.width



st_3.x				= dw_usuarios.x
st_3.width 			= dw_usuarios.width
end event

event ue_open_pre;call super::ue_open_pre;
dw_usuarios.SetTransObject(sqlca)
if dw_master.retrieve() <= 0 then return

dw_master.setrow( 1 )
dw_master.scrolltorow( 1 )
dw_master.selectrow( 1 , true )
end event

event ue_update;//override
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
	dw_usuarios.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion de Orígenes", ls_msg, StopSign!)
	END IF
END IF

IF dw_usuarios.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_usuarios.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion de Usuarios", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
		lbo_ok = dw_usuarios.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_usuarios.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	dw_usuarios.il_totdel = 0
	
	dw_master.REsetUpdate()
	dw_detail.ResetUpdate()
	dw_usuarios.ResetUpdate()
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
	
END IF
end event

event ue_modify;call super::ue_modify;// Porteccion de datos de DW Master

int li_protect 
li_protect = integer(dw_master.Object.ot_adm.Protect)
If li_protect = 0 Then
	dw_master.Object.ot_adm.Protect = 1
End if 

li_protect = integer(dw_master.Object.descripcion.Protect)
If li_protect = 0 Then
	dw_master.Object.descripcion.Protect = 1
End if 

	

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
dw_detail.of_set_flag_replicacion( )
dw_usuarios.of_set_flag_replicacion( )
end event

type dw_master from w_abc_mastdet`dw_master within w_rh008_asigna_origen
integer x = 0
integer y = 108
integer width = 1678
integer height = 632
string dataobject = "d_ot_administacion_tbl"
borderstyle borderstyle = styleraised!
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
idw_det  = dw_detail
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
dw_detail.retrieve ( this.object.ot_adm[currentrow] )
dw_usuarios.retrieve ( this.object.ot_adm[currentrow] )

end event

type dw_detail from w_abc_mastdet`dw_detail within w_rh008_asigna_origen
integer x = 0
integer y = 860
integer width = 1678
integer height = 444
string dataobject = "d_origen_ot_tbl"
borderstyle borderstyle = styleraised!
end type

event dw_detail::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event dw_detail::ue_insert_pre;this.object.ot_adm[al_row] = dw_master.object.ot_adm[dw_master.getrow()]
end event

event dw_detail::doubleclicked;call super::doubleclicked;if this.ii_protect = 1 then return

string ls_col, ls_sql, ls_return1, ls_return2

ls_col = lower(string(dwo.name))
choose case ls_col
	case 'cod_origen'
		ls_sql = "select cod_origen as codigo, nombre as descripcion from origen o"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.cod_origen[row] = ls_return1
		this.object.nombre[row] = ls_return2
		this.ii_update = 1
end choose
end event

event dw_detail::itemchanged;call super::itemchanged;if this.ii_protect = 1 then return

string ls_col, ls_sql, ls_return1, ls_return2

ls_col = lower(string(dwo.name))
choose case ls_col
	case 'cod_origen'
		select cod_origen, nombre
			into :ls_return1, :ls_return2
			from origen
			where cod_origen = :data;
		
		if sqlca.sqlcode = 100 then
			messagebox(parent.title, 'No existe Origen')
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.cod_origen[row] = ls_return1
		this.object.nombre[row] = ls_return2
		return 2
end choose
end event

type dw_usuarios from u_dw_abc within w_rh008_asigna_origen
integer x = 1687
integer y = 108
integer width = 1637
integer height = 1688
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_usuarios_ot_adm_tbl"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;this.object.ot_adm[al_row] = dw_master.object.ot_adm[dw_master.getrow()]
end event

event doubleclicked;call super::doubleclicked;if this.ii_protect = 1 then return

string ls_col, ls_sql, ls_return1, ls_return2

ls_col = lower(string(dwo.name))
choose case ls_col
	case 'cod_usr'
		ls_sql = "select cod_usr as codigo, nombre as descripcion from usuario where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.cod_usr[row] = ls_return1
		this.object.nombre[row] = ls_return2
		this.ii_update = 1
end choose
end event

event itemchanged;call super::itemchanged;if this.ii_protect = 1 then return

string ls_col, ls_sql, ls_return1, ls_return2

ls_col = lower(string(dwo.name))
choose case ls_col
	case 'cod_usr'
		select cod_usr, nombre
			into :ls_return1, :ls_return2
			from usuario
			where cod_usr = :data;
		
		if sqlca.sqlcode = 100 then
			messagebox(parent.title, 'No existe Origen')
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.cod_usr[row] = ls_return1
		this.object.nombre[row] = ls_return2
		return 2
end choose
end event

type st_1 from statictext within w_rh008_asigna_origen
integer width = 1678
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Listado de OT_ADM"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh008_asigna_origen
integer y = 752
integer width = 1678
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Origenes por OT_ADM"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh008_asigna_origen
integer x = 1682
integer width = 1637
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Usuarios Asignados"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

