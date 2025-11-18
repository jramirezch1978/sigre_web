$PBExportHeader$w_pr305_control_calidad.srw
forward
global type w_pr305_control_calidad from w_abc_mastdet
end type
type uo_rango from ou_rango_fechas within w_pr305_control_calidad
end type
type dw_pd_ot from u_dw_abc within w_pr305_control_calidad
end type
type dw_atributos from u_dw_abc within w_pr305_control_calidad
end type
type dw_graph from u_dw_abc within w_pr305_control_calidad
end type
type gb_1 from groupbox within w_pr305_control_calidad
end type
end forward

global type w_pr305_control_calidad from w_abc_mastdet
integer width = 4078
integer height = 1520
string title = "Control de Calidad de Producots Terminados(PR305)"
string menuname = "m_mantto_smpl"
uo_rango uo_rango
dw_pd_ot dw_pd_ot
dw_atributos dw_atributos
dw_graph dw_graph
gb_1 gb_1
end type
global w_pr305_control_calidad w_pr305_control_calidad

on w_pr305_control_calidad.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.uo_rango=create uo_rango
this.dw_pd_ot=create dw_pd_ot
this.dw_atributos=create dw_atributos
this.dw_graph=create dw_graph
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_rango
this.Control[iCurrent+2]=this.dw_pd_ot
this.Control[iCurrent+3]=this.dw_atributos
this.Control[iCurrent+4]=this.dw_graph
this.Control[iCurrent+5]=this.gb_1
end on

on w_pr305_control_calidad.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_rango)
destroy(this.dw_pd_ot)
destroy(this.dw_atributos)
destroy(this.dw_graph)
destroy(this.gb_1)
end on

event resize;//override
dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width = newwidth - dw_detail.x - 10

dw_atributos.height = newheight - dw_atributos.y - 10

dw_graph.width  = newwidth  - dw_graph.x - 10
dw_graph.height = newheight - dw_graph.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_pd_ot.SetTransObject(sqlca)
dw_pd_ot.of_protect()
dw_atributos.SetTransObject(sqlca)
dw_atributos.of_protect()
dw_graph.SetTransObject(sqlca)

this.event ue_query_retrieve()
end event

event ue_query_retrieve;date ld_ini, ld_fin
ld_ini = uo_rango.of_get_fecha1()
ld_fin = uo_rango.of_get_fecha2()

if dw_pd_ot.retrieve(ld_ini , ld_fin)  >= 1 then
	dw_pd_ot.selectrow(1,true)
	dw_pd_ot.setrow(1)
	dw_pd_ot.scrolltorow(1)
else
	dw_pd_ot.reset()
	dw_master.reset()
	dw_detail.reset()
end if
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
	dw_atributos.of_create_log()
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
		messagebox("Error en Grabacion de Artículos", ls_msg, StopSign!)
	END IF
END IF

IF dw_atributos.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_atributos.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion de Atributos de Calidad", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
		lbo_ok = dw_atributos.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_atributos.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	dw_atributos.il_totdel = 0
	
	dw_master.REsetUpdate()
	dw_detail.ResetUpdate()
	dw_atributos.ResetUpdate()
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
	
	
END IF
end event

event ue_modify;call super::ue_modify;dw_atributos.of_protect()
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
dw_atributos.of_set_flag_replicacion( )
end event

type dw_master from w_abc_mastdet`dw_master within w_pr305_control_calidad
integer x = 1554
integer y = 252
integer width = 2354
integer height = 556
string dataobject = "d_pd_ot_det_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_master::constructor;//Override

is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 					// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1			// columnas de lectura de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle

end event

event dw_master::keydwn;call super::keydwn;long ll_row, ll_total

ll_row = this.getrow()
ll_total = this.rowcount()

if keydown(KeyDownArrow!) = true then
	
	if ll_row = ll_total then return
	
	this.selectrow(ll_row, false)
	this.selectrow(ll_row + 1, true)
	
end if

if keydown(KeyUpArrow!) = true then
	
	if ll_row = 1 then return
	
	this.selectrow(ll_row, false)
	this.selectrow(ll_row - 1, true)
	
end if
end event

event dw_master::ue_insert;//override
return 0
end event

event dw_master::ue_delete;//override
return 0
end event

event dw_master::ue_delete_all;//override
return 0
end event

event dw_master::ue_delete_pre;//override
return 0
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;//if currentrow <= 0 then return
//
//dw_detail.retrieve(this.object.nro_parte[currentrow], this.object.nro_item[currentrow])
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

dw_detail.ScrollToRow(al_row)

end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;dw_detail.retrieve(aa_id[1], aa_id[2])
end event

type dw_detail from w_abc_mastdet`dw_detail within w_pr305_control_calidad
event ue_display ( string as_columna,  long al_row )
integer x = 18
integer y = 828
integer width = 3890
integer height = 468
string dataobject = "d_pd_ot_produccion_final__calidad_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor, ls_und, ls_desc_unidad
			
Long		ll_row_find

str_parametros sl_param

choose case upper(as_columna)
		
		case "COD_PRODUCTO"

		ls_sql = "SELECT COD_PROD as CODIGO, " &
				  + "DESC_PROD AS DESCRIPCION " &
				  + "FROM TIPO_PRODUCTO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_producto		[al_row] = ls_codigo
			this.object.desc_producto		[al_row] = ls_data
			this.ii_update = 1
		
			select und 
				into :ls_und
			from tipo_producto
			where cod_prod = :ls_codigo;
			
			select desc_unidad
				into :ls_desc_unidad
			from unidad
			where und = :ls_und;
			
			this.object.und			[al_row] = ls_und
			this.object.desc_unidad	[al_row] = ls_desc_unidad
			this.ii_update = 1
		end if
		
		case "COD_ESTADO"

		ls_sql = "SELECT COD_ESTADO as CODIGO, " &
				  + "DESC_ESTADO AS DESCRIPCION " &
				  + "FROM ESTADO_PRODUCTO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_estado		[al_row] = ls_codigo
			this.object.desc_estado		[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event dw_detail::constructor;call super::constructor;is_mastdet = 'd'		   // 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      // columnas que recibimos del master

end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF

end event

event dw_detail::itemchanged;call super::itemchanged;if this.ii_protect = 1 then return

string ls_col, ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, ls_oper_sec

ls_col = lower(string(dwo.name))

choose case ls_col
	case 'cod_art'
		
		ls_oper_sec = dw_master.object.oper_sec[dw_master.getrow()]
		
		select amp.cod_art, a.nom_articulo, a.und, u.desc_unidad 
			into :ls_return1, :ls_return2, :ls_return3, :ls_return4
			from articulo_mov_proy amp 
				inner join tg_producto_final pf on amp.cod_art = pf.cod_art 
				inner join articulo a on amp.cod_art = a.cod_art 
				inner join unidad u on a.und = u.und 
			where amp.tipo_mov = (select l.oper_ing_prod from logparam l where l.reckey = '1') and amp.oper_sec = :ls_oper_sec;
			
		if sqlca.sqlcode = 100 then
			messagebox(parent.title, 'No existe Artículo, o no ha sido~rasignado en la Orden de Trabajo')
			setnull(ls_return1)
			setnull(ls_return2)
			setnull(ls_return3)
			setnull(ls_return4)
		end if

		this.object.cod_art[row] = ls_return1
		this.object.nom_articulo[row] = ls_return2
		this.object.und[row] = ls_return3
		this.object.desc_unidad[row] = ls_return4
		return 2
end choose
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;//long ll_master
//ll_master = dw_master.getrow()
//this.object.nro_parte[al_row] = dw_master.object.nro_parte[ll_master]
//this.object.nro_item[al_row] = dw_master.object.nro_item[ll_master]
end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;//if currentrow <= 0 then
//	dw_atributos.reset()
//	dw_graph.reset()
//else
//	dw_atributos.retrieve(this.object.nro_parte[currentrow], this.object.nro_item[currentrow], this.object.cod_art[currentrow])
//	dw_graph.retrieve(this.object.nro_parte[currentrow], this.object.nro_item[currentrow], this.object.cod_art[currentrow])
//end if
end event

type uo_rango from ou_rango_fechas within w_pr305_control_calidad
integer x = 178
integer y = 108
integer width = 1143
integer taborder = 30
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type dw_pd_ot from u_dw_abc within w_pr305_control_calidad
integer x = 18
integer y = 252
integer width = 1531
integer height = 556
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pd_ot_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'			// 'm' = master sin detalle (default), 'd' =  detalle,
                     	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 					// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      	// columnas que se pasan al detalle

end event

event rowfocuschanged;call super::rowfocuschanged;//dw_detail.reset()
//dw_master.reset()
//
//if currentrow >= 1 then
//	if dw_master.retrieve(this.object.nro_parte[currentrow]) >= 1 then
//		dw_master.scrolltorow(1)
//		dw_master.setrow(1)
//		dw_master.selectrow( 1, true)
//	end if
//end if
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

dw_master.ScrollToRow(al_row)

end event

event ue_retrieve_det_pos;call super::ue_retrieve_det_pos;dw_master.retrieve(aa_id[1])
end event

type dw_atributos from u_dw_abc within w_pr305_control_calidad
boolean visible = false
integer y = 1384
integer width = 1467
integer height = 172
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pd_ot_prod_final_atrib_lbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;//idw_1.BorderStyle = StyleRaised!
//idw_1 = THIS
//idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;//
//is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
//
//is_dwform = 'tabular'	// tabular, form (default)
//
//ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//
ii_ck[1] = 1				// columnas de lectrua de este dw
//
//
end event

event ue_insert_pre;call super::ue_insert_pre;//long ll_detail
//ll_detail = dw_detail.getrow()
//this.object.nro_parte[al_row] = dw_detail.object.nro_parte[ll_detail]
//this.object.nro_item[al_row] = dw_detail.object.nro_item[ll_detail]
//this.object.cod_art[al_row] = dw_detail.object.cod_art[ll_detail]
end event

event doubleclicked;call super::doubleclicked;//if this.ii_protect = 1 then return
//
//string ls_col, ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, ls_cod_art
//
//ls_col = lower(string(dwo.name))
//
//choose case ls_col
//	case 'atributo'
//		ls_cod_art = trim(dw_detail.object.cod_art[dw_detail.getrow()])
//		ls_sql = "select atributo as codigo, descripcion as nombre from vw_pr_atributos_x_articulo where cod_art = '" + ls_cod_art + "'"
//		f_lista(ls_sql, ls_return1, ls_return2, '2')
//		if isnull(ls_return1) or trim(ls_return1) = '' then return
//		this.object.atributo[row] = ls_return1
//		this.object.descripcion[row] = ls_return2
//		this.ii_update = 1
//end choose


end event

event itemchanged;call super::itemchanged;//if this.ii_protect = 1 then return
//
//string ls_col, ls_sql, ls_return1, ls_return2, ls_cod_art
//
//ls_col = lower(string(dwo.name))
//
//choose case ls_col
//	case 'atributo'
//		ls_cod_art = trim(dw_detail.object.cod_art[dw_detail.getrow()])
//		select atributo as codigo, descripcion as nombre 
//			into :ls_return1, :ls_return2
//			from vw_pr_atributos_x_articulo 
//			where cod_art = :ls_cod_art
//				and atributo = :data;
//				
//		if sqlca.sqlcode = 100 then
//			messagebox(parent.title, 'No existe Artículo, o no ha sido~rasignado en la Orden de Trabajo')
//			setnull(ls_return1)
//			setnull(ls_return2)
//		end if
//		this.object.atributo[row] = ls_return1
//		this.object.descripcion[row] = ls_return2
//		this.ii_update = 1
//		return 2
//end choose
end event

type dw_graph from u_dw_abc within w_pr305_control_calidad
boolean visible = false
integer x = 1481
integer y = 1376
integer width = 2382
integer height = 184
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_lectura_calidad_grf"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;ii_ck[1] = 1	
end event

type gb_1 from groupbox within w_pr305_control_calidad
integer x = 18
integer y = 20
integer width = 1513
integer height = 220
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas"
borderstyle borderstyle = stylebox!
end type

