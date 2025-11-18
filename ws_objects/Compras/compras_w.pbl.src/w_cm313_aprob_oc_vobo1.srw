$PBExportHeader$w_cm313_aprob_oc_vobo1.srw
forward
global type w_cm313_aprob_oc_vobo1 from w_abc
end type
type uo_search from n_cst_search within w_cm313_aprob_oc_vobo1
end type
type rb_oc from radiobutton within w_cm313_aprob_oc_vobo1
end type
type rb_os from radiobutton within w_cm313_aprob_oc_vobo1
end type
type cb_recuperar from commandbutton within w_cm313_aprob_oc_vobo1
end type
type rb_desaprobar from radiobutton within w_cm313_aprob_oc_vobo1
end type
type rb_aprobar from radiobutton within w_cm313_aprob_oc_vobo1
end type
type dw_master from u_dw_abc within w_cm313_aprob_oc_vobo1
end type
type gb_1 from groupbox within w_cm313_aprob_oc_vobo1
end type
type gb_2 from groupbox within w_cm313_aprob_oc_vobo1
end type
end forward

global type w_cm313_aprob_oc_vobo1 from w_abc
integer width = 3113
integer height = 2432
string title = "[CM313] Aprobación de OC y OS"
string menuname = "m_filtrar_salir"
uo_search uo_search
rb_oc rb_oc
rb_os rb_os
cb_recuperar cb_recuperar
rb_desaprobar rb_desaprobar
rb_aprobar rb_aprobar
dw_master dw_master
gb_1 gb_1
gb_2 gb_2
end type
global w_cm313_aprob_oc_vobo1 w_cm313_aprob_oc_vobo1

type variables
n_cst_usuario 		invo_aprobador
n_cst_utilitario	invo_util
end variables

on w_cm313_aprob_oc_vobo1.create
int iCurrent
call super::create
if this.MenuName = "m_filtrar_salir" then this.MenuID = create m_filtrar_salir
this.uo_search=create uo_search
this.rb_oc=create rb_oc
this.rb_os=create rb_os
this.cb_recuperar=create cb_recuperar
this.rb_desaprobar=create rb_desaprobar
this.rb_aprobar=create rb_aprobar
this.dw_master=create dw_master
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search
this.Control[iCurrent+2]=this.rb_oc
this.Control[iCurrent+3]=this.rb_os
this.Control[iCurrent+4]=this.cb_recuperar
this.Control[iCurrent+5]=this.rb_desaprobar
this.Control[iCurrent+6]=this.rb_aprobar
this.Control[iCurrent+7]=this.dw_master
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_cm313_aprob_oc_vobo1.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_search)
destroy(this.rb_oc)
destroy(this.rb_os)
destroy(this.cb_recuperar)
destroy(this.rb_desaprobar)
destroy(this.rb_aprobar)
destroy(this.dw_master)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event resize;call super::resize;uo_search.width 	= newwidth - uo_Search.x - 10
uo_search.event ue_resize(sizetype, newwidth, newheight)

dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

//dw_detail.width  = newwidth  - dw_detail.x - 10
//dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_refresh;call super::ue_refresh;if rb_oc.checked then
	if rb_aprobar.checked then
		dw_master.dataobject = 'd_abc_aprobacion_oc_tbl'
	elseif rb_desaprobar.checked then
		dw_master.dataObject = 'd_abc_desaprobacion_oc_tbl'
	end if
elseif rb_os.checked then
	if rb_aprobar.checked then
		dw_master.dataobject = 'd_abc_aprobacion_os_tbl'
	elseif rb_desaprobar.checked then
		dw_master.dataObject = 'd_abc_desaprobacion_os_tbl'
	end if
end if

dw_master.setTransObject(SQLCA)
dw_master.Retrieve(gs_user)

uo_search.of_set_dw(dw_master)
end event

event ue_open_pre;call super::ue_open_pre;invo_aprobador = create n_cst_usuario

invo_aprobador.of_aprobador( gs_user )
end event

event close;call super::close;destroy invo_aprobador
end event

type uo_search from n_cst_search within w_cm313_aprob_oc_vobo1
event destroy ( )
integer y = 240
integer taborder = 30
end type

on uo_search.destroy
call n_cst_search::destroy
end on

type rb_oc from radiobutton within w_cm313_aprob_oc_vobo1
integer x = 18
integer y = 60
integer width = 466
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Compra"
boolean checked = true
end type

type rb_os from radiobutton within w_cm313_aprob_oc_vobo1
integer x = 18
integer y = 132
integer width = 466
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Servicio"
end type

type cb_recuperar from commandbutton within w_cm313_aprob_oc_vobo1
integer x = 1202
integer y = 40
integer width = 343
integer height = 156
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;setPointer(HourGlass!)
parent.event ue_refresh( )
setPointer(Arrow!)
end event

type rb_desaprobar from radiobutton within w_cm313_aprob_oc_vobo1
integer x = 741
integer y = 132
integer width = 411
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desaprobar"
end type

type rb_aprobar from radiobutton within w_cm313_aprob_oc_vobo1
integer x = 741
integer y = 60
integer width = 379
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Aprobar"
boolean checked = true
end type

type dw_master from u_dw_abc within w_cm313_aprob_oc_vobo1
integer y = 336
integer width = 3022
integer height = 1788
string dataobject = "d_abc_aprobacion_oc_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw


end event

event buttonclicked;call super::buttonclicked;string 				ls_nro_oc, ls_mensaje, ls_nro_os, ls_cencos, ls_desc_cencos, ls_motivo
str_parametros  	lstr_param
Long					ll_count
w_rpt_preview		lw_1

try
	if row = 0 then return
	
	if lower(dwo.name) = 'b_aprobar_oc' then
		
		ls_nro_oc = this.object.nro_oc [row]
		
		if MessageBox('Aviso', 'Desea APROBAR la Orden de Compra ' + ls_nro_oc + '?', &
							Information!, Yesno!, 1) = 2 then return
		
		update orden_compra oc
			set oc.aprobador 		= :gs_user,
				 oc.fecha_aprob 	= sysdate,
				 oc.flag_estado	= '1'
		where nro_oc = :ls_nro_oc
		  and flag_estado = '3';
				
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ocurrio un error al momento de aprobar la Orden de Compra ' &
									+ ls_nro_oc + '. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		update articulo_mov_proy amp
			set amp.flag_estado	= '1'
		where amp.nro_doc = :ls_nro_oc
		  and amp.tipo_doc = :gnvo_app.is_doc_oc
		  and amp.flag_estado = '3';
				
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ocurrio un error al momento de aprobar el detalle de la Orden de compra, tabla ARTICULO_MOV_PROY, Nro OC ' &
									+ ls_nro_oc + '. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		commit;
		
		//Envio el email
		if gnvo_app.of_get_parametro("SEND_EMAIL_OC_APROBACION", "1") = '1' THEN
			gnvo_app.logistica.of_send_Email_aprob_oc(ls_nro_oc, gs_user)
		end if
		
		event ue_refresh()
		
	elseif lower(dwo.name) = 'b_desaprobar_oc' then
		
		ls_nro_oc = this.object.nro_oc [row]
		
		if MessageBox('Aviso', 'Desea DESAPROBAR la Orden de Compra ' + ls_nro_oc + '?', &
							Information!, Yesno!, 1) = 2 then return
		
		update orden_compra oc
			set oc.aprobador 		= null,
				 oc.fecha_aprob 	= null,
				 oc.flag_estado	= '3'
		where nro_oc = :ls_nro_oc;
				
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ocurrio un error al momento de DESARPROBAR la Orden de Compra ' &
									+ ls_nro_oc + '. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		update articulo_mov_proy amp
			set amp.flag_estado	= '3'
		where amp.nro_doc = :ls_nro_oc
		  and amp.tipo_doc = :gnvo_app.is_doc_oc
		  and amp.flag_estado = '1';
				
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ocurrio un error al momento de DESAPROBAR el detalle de la Orden de compra, tabla ARTICULO_MOV_PROY, Nro OC ' &
									+ ls_nro_oc + '. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		commit;
		
		//Envio el email
		if gnvo_app.of_get_parametro("SEND_EMAIL_OC_APROBACION", "1") = '1' THEN
			gnvo_app.logistica.of_send_Email_desaprob_oc(ls_nro_oc, gs_user)
		end if
	
		
		event ue_refresh()	
	
	elseif lower(dwo.name) = 'b_aprobar_os' then
		
		ls_nro_os = this.object.nro_os [row]
		
		if MessageBox('Aviso', 'Desea APROBAR la Orden de Servicio ' + ls_nro_os + '?', &
							Information!, Yesno!, 1) = 2 then return
		
		//Verifico que el detalle de la OS contenga todos los centros de costos que el usuario pueda aprobar
		select count(distinct osd.cencos)
		  into :ll_count
		  from orden_servicio_det osd
		 where osd.nro_os = :ls_nro_os
			and osd.cencos not in (select cao.cencos
											from cencos_aprob_os    cao
										  where cao.cod_usr = :gs_user);
		
		if ll_count > 0 then
			select distinct osd.cencos
			  into :ls_cencos
			  from orden_servicio_det osd
			 where osd.nro_os = :ls_nro_os
				and osd.cencos not in (select cao.cencos
												from cencos_aprob_os    cao
											  where cao.cod_usr = :gs_user);
			
			select desc_cencos
				into :ls_desc_cencos
			  from centros_costo cc
			 where cencos = :ls_Cencos;
			 
			//Emito el error
			ROLLBACK;
			MessageBox('Error', 'La Orden de Servicio tiene un Centro de costo que no le corresponde '&
									+ 'al usuario APROBAR.' &
									+ '~r~nNro OS: ' + ls_nro_os &
									+ '~r~nCentro de Costo: ' + trim(ls_cencos) + ' - ' + ls_Desc_cencos &
									+ '~r~nUsuario Aprobador: ' + gs_user, StopSign!)
			return
			
			
		end if
		
		//DEtalle con valor Cero
		select count(*)
		  into :ll_count
		  from orden_servicio_det osd
		 where osd.nro_os = :ls_nro_os
			and osd.importe  + nvl(osd.impuesto, 0) + nvl(osd.impuesto2,0) = 0;
		
		if ll_count > 0 then
			
			//Emito el error
			ROLLBACK;
			MessageBox('Error', 'La Orden de Servicio Tiene detalles con valor CERO, verifique! '&
									+ '~r~nNro OS: ' + ls_nro_os &
									+ '~r~nUsuario Aprobador: ' + gs_user, StopSign!)
			return
			
			
		end if
		
		
		update orden_servicio os
			set os.aprobador 		= :gs_user,
				 os.fecha_aprob 	= sysdate,
				 os.flag_estado	= '1'
		where nro_os = :ls_nro_os;
				
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ocurrio un error al momento de aprobar la Orden de Servicio ' &
									+ ls_nro_os + '. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		update orden_servicio_det osd
			set osd.flag_estado		= '1',
				 osd.aprobador	 		= :gs_user,
				 osd.fec_aprobacion	= sysdate
		where osd.nro_os = :ls_nro_os
		  and osd.flag_estado = '3';
				
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ocurrio un error al momento de aprobar el detalle de la Orden de ' &
									+ 'Servicio, tabla ORDEN_SERVCIO_DET, Nro OS ' &
									+ ls_nro_os + '. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		commit;
		
		//Envio el email
		if gnvo_app.of_get_parametro("SEND_EMAIL_OS_APROBACION", "1") = '1' THEN
			gnvo_app.logistica.of_send_Email_aprob_os(ls_nro_os, gs_user)
		end if
		
		event ue_refresh()
	
	
	elseif lower(dwo.name) = 'b_desaprobar_os' then
		
		ls_nro_os = this.object.nro_os [row]
		
		if MessageBox('Aviso', 'Desea DESAPROBAR la Orden de Servicio ' + ls_nro_os + '?', &
							Information!, Yesno!, 1) = 2 then return
		
		update orden_Servicio os
			set os.aprobador 		= null,
				 os.fecha_aprob 	= null,
				 os.flag_estado	= '3'
		where nro_os = :ls_nro_os;
				
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ocurrio un error al momento de DESARPROBAR la Orden de Servicio ' &
									+ ls_nro_os + '. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		update orden_servicio_det osd
			set osd.flag_estado		= '3',
				 osd.aprobador			= null,
				 osd.FEC_APROBACION 	= null
		where osd.nro_os 				= :ls_nro_os
		  and osd.flag_estado 		= '1'
		  and osd.imp_provisionado = 0;
				
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ocurrio un error al momento de DESAPROBAR el detalle de la Orden de ' &
									+ 'SERVICIO, tabla ORDEN_SERVICIO_DET, Nro OS ' &
									+ ls_nro_os + '. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		commit;
		
		//Envio el email
		if gnvo_app.of_get_parametro("SEND_EMAIL_OS_APROBACION", "1") = '1' THEN
			gnvo_app.logistica.of_send_Email_desaprob_os(ls_nro_os, gs_user)
		end if
		
		event ue_refresh()	
	
	elseif lower(dwo.name) = 'b_rechazar_os' then
		
		ls_nro_os = this.object.nro_os [row]
		
		if MessageBox('Aviso', 'Desea RECHAZAR la Orden de Servicio ' + ls_nro_os + '?', &
							Information!, Yesno!, 1) = 2 then return
	
		
		//Verifico que el detalle de la OS contenga todos los centros de costos que el usuario pueda rechazar
		select count(distinct osd.cencos)
		  into :ll_count
		  from orden_servicio_det osd
		 where osd.nro_os = :ls_nro_os
			and osd.cencos not in (select cao.cencos
											from cencos_aprob_os    cao
										  where cao.cod_usr = :gs_user);
		
		if ll_count > 0 then
			select distinct osd.cencos
			  into :ls_cencos
			  from orden_servicio_det osd
			 where osd.nro_os = :ls_nro_os
				and osd.cencos not in (select cao.cencos
												from cencos_aprob_os    cao
											  where cao.cod_usr = :gs_user);
			
			select desc_cencos
				into :ls_desc_cencos
			  from centros_costo cc
			 where cencos = :ls_Cencos;
			 
			//Emito el error
			ROLLBACK;
			MessageBox('Error', 'La Orden de Servicio tiene un Centro de costo que no le corresponde ' &
									+ 'al usuario RECHAZAR.' &
									+ '~r~nNro OS: ' + ls_nro_os &
									+ '~r~nCentro de Costo: ' + trim(ls_cencos) + ' - ' + ls_Desc_cencos &
									+ '~r~nUsuario Aprobador: ' + gs_user, StopSign!)
			return
			
			
		end if
		
		//Verifico que no tenga importe de provision
		select count(distinct osd.cencos)
		  into :ll_count
		  from orden_servicio_det osd
		 where osd.nro_os = :ls_nro_os
			and osd.imp_provisionado > 0;
		
		if ll_count > 0 then
			//Emito el error
			ROLLBACK;
			MessageBox('Error', 'La Orden de Servicio tiene IMPORTE PROVISIONADO, no se puede RECHAZAR' &
									+ '~r~nNro OS: ' + ls_nro_os, StopSign!)
			return
			
			
		end if
		
		//Indico el motivo del rechazo
		ls_motivo = invo_util.of_get_texto('Indique el motivo de ANULACION', '')
		
		//Si cancela la ventana retorno sin problemas
		if IsNull(ls_motivo) then return
		
		if trim(ls_motivo) = '' then
			MessageBox('Error', 'Debe especificar un motivo de anulacion', StopSign!)
			return
		end if
		
		
		
		update orden_servicio os
			set os.motivo_baja 	= :ls_motivo,
				 os.usr_baja		= :gs_user,
				 os.fecha_baja 	= sysdate,
				 os.flag_estado	= '0'
		where nro_os = :ls_nro_os;
				
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ocurrio un error al momento de ANULAR la Orden de Servicio ' &
									+ ls_nro_os + '. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		update orden_servicio_det osd
			set osd.flag_estado	= '0'
		where osd.nro_os = :ls_nro_os
		  and osd.imp_provisionado = 0;
				
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ocurrio un error al momento de ANULAR el detalle de la Orden de Servicio, ' &
									+ 'tabla ORDEN_SERVICIO_DET, Nro OS ' &
									+ ls_nro_os + '. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		//Quito la relacion con al AP_PD_DESCARGA_DET
		update ap_pd_descarga_det t
			set t.nro_os_proc = null,
				 t.org_os_proc = null,
				 t.item_os_proc = null
		 where t.nro_os_proc = :ls_nro_os;
				
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ocurrio un error al momento de ANULAR de la tabla AP_PD_DESCARGA_DET, ' &
									+ 'Nro OS ' &
									+ ls_nro_os + '. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		commit;
		
		//Envio el email
		gnvo_app.logistica.of_send_Email_rechazo_os(ls_nro_os, gs_user, ls_motivo)
		
		event ue_refresh()
	
	
	elseif lower(dwo.name) = 'b_detalle_oc_aprob' then
		
		if rb_aprobar.checked and rb_oc.checked then
			lstr_param.dw1     = 'd_cns_detalle_oc_tbl'
			lstr_param.titulo  = "Detalle de OC pendientes de Aprobar"
			lstr_param.tipo 	 = '1S'
			lstr_param.string1 = this.object.nro_oc[row]
			lstr_param.b_preview = false
		
			OpenSheetWithParm( lw_1, lstr_param, w_main, 0, Layered!)
		end if
		
		
		
	
		return
	
	elseif lower(dwo.name) = 'b_detalle_os_aprob' then
		
		lstr_param.dw1     	= 'd_cns_detalle_os_tbl'
		lstr_param.titulo  	= "Detalle de OS pendientes de Aprobar"
		lstr_param.tipo 	 	= '1S'
		lstr_param.string1 	= this.object.nro_os[row]
		lstr_param.b_preview = false
	
		OpenSheetWithParm( lw_1, lstr_param, w_main, 0, Layered!)
	
		return	
		
	end if	
	
catch(Exception ex)
	gnvo_app.of_catch_exception(ex, "Exception")
end try



end event

type gb_1 from groupbox within w_cm313_aprob_oc_vobo1
integer width = 686
integer height = 232
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo documento"
end type

type gb_2 from groupbox within w_cm313_aprob_oc_vobo1
integer x = 713
integer width = 1051
integer height = 232
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opciones"
end type

