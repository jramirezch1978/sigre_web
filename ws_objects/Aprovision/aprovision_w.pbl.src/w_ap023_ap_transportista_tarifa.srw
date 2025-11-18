$PBExportHeader$w_ap023_ap_transportista_tarifa.srw
forward
global type w_ap023_ap_transportista_tarifa from w_abc_mastdet_smpl
end type
type dw_detdet from u_dw_abc within w_ap023_ap_transportista_tarifa
end type
end forward

global type w_ap023_ap_transportista_tarifa from w_abc_mastdet_smpl
integer width = 2569
integer height = 2232
string title = "Proveedor Materia Prima - Especies y Tarifas (AP021) "
string menuname = "m_mantto_tablas"
dw_detdet dw_detdet
end type
global w_ap023_ap_transportista_tarifa w_ap023_ap_transportista_tarifa

on w_ap023_ap_transportista_tarifa.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_tablas" then this.MenuID = create m_mantto_tablas
this.dw_detdet=create dw_detdet
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detdet
end on

on w_ap023_ap_transportista_tarifa.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detdet)
end on

event resize;//Override
dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
//dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_detdet.SetTransObject(sqlca)
dw_detdet.BorderStyle = StyleRaised! 	// indicar dw_detail como no activado
dw_detdet.of_protect()         			// bloquear modificaciones 
dw_detdet.of_protect()
end event

event ue_update;call super::ue_update;//Override

Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()
dw_detdet.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
	dw_detdet.of_create_log()
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
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF dw_detdet.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detdet.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	lbo_ok = dw_master.of_save_log()
	lbo_ok = dw_detail.of_save_log()
	lbo_ok = dw_detdet.of_save_log()
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_detdet.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	dw_detdet.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	dw_detdet.ResetUpdate()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ap023_ap_transportista_tarifa
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 0
integer width = 2505
integer height = 648
string dataobject = "d_cns_transp_mp_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 				dw_master
idw_det  =  		   dw_detail
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::ue_insert;//Override
Return 0
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ap023_ap_transportista_tarifa
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 660
integer width = 2505
integer height = 648
string dataobject = "d_abc_transp_ruta_tbl"
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

CHOOSE CASE lower(as_columna)
		
	CASE "cod_ruta"
		 ls_sql = "Select ar.cod_ruta as codigo, ar.desc_ruta as descripcion, ar.flag_estado as estado "&
		 			 +" from ap_rutas_mp ar Where Nvl(ar.flag_estado,'0')='1' Order by ar.cod_ruta " 
		
		 lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			THIS.object.cod_ruta	[al_row] = ls_codigo
			THIS.object.desc_ruta	[al_row] = ls_data
			THIS.ii_update = 1
		END IF
		
END CHOOSE

end event

event dw_detail::constructor;call super::constructor;THIS.EVENT Post ue_conversion()
THIS.EVENT POST ue_val_param()

 
                       // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
 is_dwform = 'tabular' // tabular, grid, form
 


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle

idw_mst  = 				dw_master
idw_det  =  			dw_detdet
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;DateTime ldt_fecha

ldt_fecha = f_fecha_actual()

this.object.fecha_registro[al_row] = ldt_fecha
this.object.cod_usr[al_row] = gs_user
this.object.estacion[al_row] = gs_estacion
this.object.flag_estado[al_row] = '1'
end event

event dw_detail::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)


end event

event dw_detail::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2])
end event

event dw_detail::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

type dw_detdet from u_dw_abc within w_ap023_ap_transportista_tarifa
event ue_display ( string as_columna,  long al_row )
integer y = 1328
integer width = 2505
integer height = 648
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_ap_transp_ruta_tarifa_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

CHOOSE CASE lower(as_columna)
		
	CASE "cod_moneda"
		 ls_sql = "Select m.cod_moneda as codigo, m.descripcion as descripcion, m.flag_estado as estado "&
		 			 +"from moneda m Where Nvl(m.flag_estado,'0')='1' " 
		
		 lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			THIS.object.cod_moneda	[al_row] = ls_codigo
			THIS.ii_update = 1
		END IF
		
END CHOOSE

end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      // columnas que recibimos del master
ii_rk[3] = 3 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle
ii_dk[3] = 3 	      // columnas que se pasan al detalle

idw_mst  = 				dw_detail
idw_det  =  		   dw_detdet
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;DateTime ldt_fecha

ldt_fecha = f_fecha_actual()

this.object.nro_item				[al_row] = of_nro_item(this)
this.object.fecha_registro		[al_row] = ldt_fecha
this.object.cod_usr				[al_row] = gs_user
this.object.estacion				[al_row] = gs_estacion
this.object.flag_fijo_Variable[al_row] = 'V'
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

