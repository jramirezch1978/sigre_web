$PBExportHeader$w_cn060_grupo_resumen.srw
forward
global type w_cn060_grupo_resumen from w_abc
end type
type st_3 from statictext within w_cn060_grupo_resumen
end type
type dw_cnta_cntbl from u_dw_abc within w_cn060_grupo_resumen
end type
type dw_detail from u_dw_abc within w_cn060_grupo_resumen
end type
type st_2 from statictext within w_cn060_grupo_resumen
end type
type st_1 from statictext within w_cn060_grupo_resumen
end type
type dw_master from u_dw_abc within w_cn060_grupo_resumen
end type
end forward

global type w_cn060_grupo_resumen from w_abc
integer width = 3346
integer height = 1992
string title = "[CN060] Grupo Resumen Cnta Cntbl"
string menuname = "m_abc_master_smpl"
st_3 st_3
dw_cnta_cntbl dw_cnta_cntbl
dw_detail dw_detail
st_2 st_2
st_1 st_1
dw_master dw_master
end type
global w_cn060_grupo_resumen w_cn060_grupo_resumen

type variables
n_cst_contabilidad	invo_cntbl
end variables

on w_cn060_grupo_resumen.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.st_3=create st_3
this.dw_cnta_cntbl=create dw_cnta_cntbl
this.dw_detail=create dw_detail
this.st_2=create st_2
this.st_1=create st_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.dw_cnta_cntbl
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.dw_master
end on

on w_cn060_grupo_resumen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_3)
destroy(this.dw_cnta_cntbl)
destroy(this.dw_detail)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;invo_cntbl = create n_cst_contabilidad

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)
dw_cnta_cntbl.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente
idw_1.setFocus()

dw_master.Retrieve()

if dw_master.RowCount() > 0 then
	dw_master.SelectRow(0, false)
	
	dw_master.SelectRow(1, true)
	
	dw_master.SetRow(1)
	
	dw_master.il_row = 1
	
	dw_master.event ue_output(1)
end if
end event

event close;call super::close;destroy invo_cntbl
end event

event resize;call super::resize;// Override

st_2.y = newheight/2 + 10

//Nivel 1
dw_master.width	= newwidth/2  - dw_master.x - 10
dw_master.height	= st_2.y - dw_master.y - 10
st_1.width 			= dw_master.width

//Nivel 2
dw_detail.y 		= st_2.y + st_2.height + 10
dw_detail.width	= newwidth/2  - dw_detail.x - 10
dw_detail.height	= newheight - dw_detail.y - 10
st_2.width 			= dw_detail.width

//Nivel 3
dw_cnta_cntbl.x 		= dw_master.x + dw_master.width + 10
dw_cnta_cntbl.y		= dw_master.y
dw_cnta_cntbl.width  = newwidth  - dw_cnta_cntbl.x - 10
dw_cnta_cntbl.height = newheight - dw_cnta_cntbl.y - 10

st_3.x				= dw_cnta_cntbl.x
st_3.width 			= dw_cnta_cntbl.width
end event

event ue_update_pre;call super::ue_update_pre;

ib_update_check = False

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master) <> true then return

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_detail) <> true then	return

if gnvo_app.of_row_Processing( dw_cnta_cntbl) <> true then	return


ib_update_check = true




end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
	dw_cnta_cntbl.of_create_log()
END IF

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
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF dw_cnta_cntbl.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_cnta_cntbl.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en lista de Cuentas Contables", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
		lbo_ok = dw_cnta_cntbl.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_cnta_cntbl.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	dw_cnta_cntbl.il_totdel = 0
	
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	dw_cnta_cntbl.ResetUpdate()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

event ue_insert;call super::ue_insert;Long  ll_row

IF idw_1 = dw_detail AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro", StopSign!)
	RETURN
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
dw_detail.of_protect()
dw_cnta_cntbl.of_protect()
end event

type st_3 from statictext within w_cn060_grupo_resumen
integer x = 1655
integer width = 1349
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
string text = "Listado de Cuenta Contable"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_cnta_cntbl from u_dw_abc within w_cn060_grupo_resumen
integer x = 1655
integer y = 92
integer width = 1349
integer height = 784
integer taborder = 20
string dataobject = "d_resumen_cntbl_cnta_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr 			[al_Row] = gs_user
this.object.fec_registro 	[al_Row] = gnvo_app.of_fecha_actual()

if dw_detail.getRow() <> 0 then
	this.object.cod_concepto	[al_Row] = dw_detail.object.cod_concepto [dw_detail.getRow()]
end if
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
str_cnta_cntbl 	lstr_cnta			

choose case lower(as_columna)

	case "cnta_ctbl"
		lstr_cnta = invo_cntbl.of_get_cnta_cntbl()
		
		if lstr_cnta.b_return = true then
			this.object.cnta_ctbl [al_row] = lstr_cnta.cnta_cntbl
			this.object.desc_cnta [al_row] = lstr_cnta.desc_cnta
			
		
			this.ii_update = 1
		end if

end choose


end event

event itemchanged;call super::itemchanged;String ls_data

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cnta_ctbl'
		
		// Verifica que codigo ingresado exista	
		select cc.desc_cnta
			into :ls_data
		from cntbl_cnta cc
		where cc.niv_cnta = 5
  		  and cc.flag_estado = '1'
  		  and cc.cnta_ctbl = :data;

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cnta_ctbl	[row] = gnvo_app.is_null
			this.object.desc_cnta	[row] = gnvo_app.is_null
			MessageBox('Error', 'Cuenta Contable ' + data + ' no existe, no esta activo o no pertenece al nivel 5, por favor verifique!', StopSign!)
			return 1
		end if

		this.object.desc_cnta		[row] = ls_data

END CHOOSE
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_detail from u_dw_abc within w_cn060_grupo_resumen
integer y = 976
integer width = 1349
integer height = 784
string dataobject = "d_resumen_concepto_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado 	[al_Row] = '1'
this.object.cod_usr 			[al_Row] = gs_user
this.object.fec_registro 	[al_Row] = gnvo_app.of_fecha_actual()

if dw_master.getRow() <> 0 then
	this.object.cod_grupo	[al_Row] = dw_master.object.cod_grupo [dw_master.getRow()]
end if
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
		
	case "cnta_prsp"
		
		ls_sql = "select pc.cnta_prsp as cnta_prsp, " &
				 + "       pc.descripcion as desc_cnta_prsp " &
				 + "from presupuesto_cuenta pc " &
				 + "where pc.flag_estado = '1'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.object.desc_cnta_prsp	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event itemchanged;call super::itemchanged;String ls_data

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cnta_prsp'
		
		// Verifica que codigo ingresado exista		
		select pc.descripcion as desc_cnta_prsp
			into :ls_data
		from presupuesto_cuenta pc
		where pc.flag_estado = '1'
		  and pc.cnta_prsp 	= :data;


		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cnta_prsp		[row] = gnvo_app.is_null
			this.object.desc_cnta_prsp	[row] = gnvo_app.is_null
			MessageBox('Error', 'Cuenta Presupuestal ' + data + ' no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_cnta_prsp			[row] = ls_data

END CHOOSE
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_output;call super::ue_output;if al_Row = 0 then return

dw_cnta_cntbl.Retrieve(this.object.cod_concepto [al_Row])
end event

type st_2 from statictext within w_cn060_grupo_resumen
integer y = 884
integer width = 1349
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
string text = "Listado de Conceptos"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn060_grupo_resumen
integer width = 1349
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
string text = "Listado de Grupos"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_cn060_grupo_resumen
integer y = 92
integer width = 1349
integer height = 784
string dataobject = "d_resumen_grupo_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado 	[al_Row] = '1'
this.object.cod_usr 			[al_Row] = gs_user
this.object.fec_registro 	[al_Row] = gnvo_app.of_fecha_actual()
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_output;call super::ue_output;if al_Row = 0 then return

dw_detail.Retrieve(this.object.cod_grupo [al_Row])
end event

