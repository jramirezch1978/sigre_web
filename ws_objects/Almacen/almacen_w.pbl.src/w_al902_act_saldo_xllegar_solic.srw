$PBExportHeader$w_al902_act_saldo_xllegar_solic.srw
forward
global type w_al902_act_saldo_xllegar_solic from w_abc
end type
type st_1 from statictext within w_al902_act_saldo_xllegar_solic
end type
type pb_2 from picturebutton within w_al902_act_saldo_xllegar_solic
end type
type pb_1 from picturebutton within w_al902_act_saldo_xllegar_solic
end type
end forward

global type w_al902_act_saldo_xllegar_solic from w_abc
integer width = 2007
integer height = 716
string title = "[AL902] Regenera Saldo x llegar, Solicitado y Resevado de Articulos"
string menuname = "m_salir"
boolean resizable = false
event ue_aceptar ( )
event ue_salir ( )
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_al902_act_saldo_xllegar_solic w_al902_act_saldo_xllegar_solic

event ue_aceptar;SetPointer (HourGlass!)

string 		ls_mensaje, ls_sql
n_cst_wait	invo_wait

try 
	SetPointer (HourGlass!)
	
	invo_wait = create n_cst_wait
	
	invo_wait.of_mensaje("Apagando Triggers de ARTICULO_MOV_PROY")
	
	//Apago el trigger;
	ls_sql = 'ALTER TABLE ARTICULO_MOV_PROY DISABLE ALL TRIGGERS'
	execute immediate :ls_sql;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCa.SQLErrText
		rollback;
		gnvo_app.of_mensaje_error( "Error al ejecutar la sentencia " + ls_sql + ": " + ls_mensaje)
		return 
	end if
	
	invo_wait.of_mensaje("Actualizando cantidad procesada de ORDEN DE COMPRA")
	
	//Actualizo la cantidad procesada en Orden de compra
  	update articulo_mov_proy amp
    set amp.cant_procesada = ((Select nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov) +
                     (Select nvl(abs(sum(vtd.cant_procesada * amt.factor_sldo_total)),0)
                       from vale_mov_trans_det vtd,  
                          vale_mov_trans     vt,
                          articulo_mov_tipo  amt
                      where vtd.nro_vale  = vt.nro_vale
                        and vt.tipo_mov   = amt.tipo_mov
                        and vtd.flag_estado <> '0'
                        and vt.flag_estado  <> '0'
                        and vtd.org_amp_oc     = amp.cod_origen
                        and vtd.nro_amp_oc     = amp.nro_mov))
    where amp.cant_procesada <> ((Select nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov) +
                     (Select nvl(abs(sum(vtd.cant_procesada * amt.factor_sldo_total)),0)
                       from vale_mov_trans_det vtd,  
                          vale_mov_trans     vt,
                          articulo_mov_tipo  amt
                      where vtd.nro_vale  = vt.nro_vale
                        and vt.tipo_mov   = amt.tipo_mov
                        and vtd.flag_estado <> '0'
                        and vt.flag_estado  <> '0'
                        and vtd.org_amp_oc     = amp.cod_origen
                        and vtd.nro_amp_oc     = amp.nro_mov))
        and amp.tipo_doc = 'OC';
   
	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No se puede actualizar la cantidad procesada en la ORDEN DE COMPRA. Mensaje: ' + ls_mensaje, StopSign!)
		return 
	end if
	
	
	commit;
	
	invo_wait.of_mensaje("Actualizando cantidad procesada de ORDEN DE VENTA")
	
	//Actualizo la cantidad procesada en Orden de VENTA
  	update articulo_mov_proy amp
    set amp.cant_procesada = (Select round(nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0),4)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov)
    where amp.cant_procesada <> (Select round(nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0),4)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov)
        and amp.tipo_doc = 'OV';    

	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No se puede actualizar la cantidad procesada en la ORDEN DE VENTA. Mensaje: ' + ls_mensaje, StopSign!)
		return 
	end if
	
	commit;
	
	invo_wait.of_mensaje("Actualizando cantidad procesada de ORDEN DE TRABAJO")
	
	//Actualizo la cantidad procesada en Orden de VENTA
  	update articulo_mov_proy amp
    set amp.cant_procesada = (Select round(nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0),4)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov)
    where amp.cant_procesada <> (Select round(nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0),4)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov)
        and amp.tipo_doc = 'OT';    

	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No se puede actualizar la cantidad procesada en la ORDEN DE TRABAJO. Mensaje: ' + ls_mensaje, StopSign!)
		return 
	end if
	
	commit;
	
	invo_wait.of_mensaje("Actualizando cantidad procesada de ORDEN DE TRASLADO")
	
	//Actualizo la cantidad procesada en Orden de TRASLADO
  	update articulo_mov_proy amp
    set amp.cant_procesada = (Select round(nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0),4)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and vm.tipo_mov    = 'S03'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov)
    where amp.cant_procesada <> (Select round(nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0),4)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and vm.tipo_mov    = 'S03'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov)
        and amp.tipo_doc = 'OTR';    

	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No se puede actualizar la cantidad procesada en la ORDEN DE TRASLADO. Mensaje: ' + ls_mensaje, StopSign!)
		return 
	end if
	
	commit;
	
	invo_wait.of_mensaje("Actualizando cantidad FACTURADA de ORDEN DE TRASLADO")
	
	//Actualizo la cantidad facturada en Orden de TRASLADO
  	update articulo_mov_proy amp
    set amp.cant_facturada = (Select round(nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0),4)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and vm.tipo_mov    = 'I03'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov)
    where amp.cant_facturada <> (Select round(nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0),4)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and vm.tipo_mov    = 'I03'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov)
        and amp.tipo_doc = 'OTR';                 
        
											  
	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No se puede actualizar la cantidad FACTURADA en la ORDEN DE TRASLADO. Mensaje: ' + ls_mensaje, StopSign!)
		return 
	end if
	
	commit;
	
	invo_wait.of_mensaje("Actualizando el SALDO RESERVADO EN ARTICULO_MOV_PROY")
	
	//ACtualizo el Saldo reservado
	update articulo_mov_proy amp
		set amp.cant_reservado = (select nvl(sum(rd.cantidad - rd.cant_procesada), 0)
											 from reservacion r,
													reservacion_det rd
											where r.nro_reservacion = rd.nro_reservacion
											  and rd.flag_estado     = '1'
											  and rd.org_amp_ref    = amp.cod_origen
											  and rd.nro_amp_ref    = amp.nro_mov)
	where amp.flag_estado = '1'
	  and amp.cant_reservado <> (select nvl(sum(rd.cantidad - rd.cant_procesada), 0)
											 from reservacion r,
													reservacion_det rd
											where r.nro_reservacion = rd.nro_reservacion
											  and rd.flag_estado     = '1'
											  and rd.org_amp_ref    = amp.cod_origen
											  and rd.nro_amp_ref    = amp.nro_mov);
	commit;
	
	invo_wait.of_mensaje("Actualizando el SALDO RESERVADO en CERO para Registros no ACTIVOS en ARTICULO_MOV_PROY")

	update articulo_mov_proy amp
		set amp.cant_reservado = 0
	 where amp.flag_estado <> '1'
		and amp.cant_reservado <> 0;    
	
	commit;
	
	//Apago el trigger;
	invo_wait.of_mensaje("Apagando Triggers de ARTICULO_ALMACEN")
	
	ls_sql = 'ALTER TABLE ARTICULO_ALMACEN DISABLE ALL TRIGGERS'
	execute immediate :ls_sql;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCa.SQLErrText
		rollback;
		gnvo_app.of_mensaje_error( "Error al ejecutar la sentencia " + ls_sql + ": " + ls_mensaje)
		return 
	end if
	
	invo_wait.of_mensaje("Actualizando el SALDO RESERVADO en ARTICULO_ALMACEN")


	update articulo_almacen aa
		set aa.sldo_reservado = (select nvl(sum(amp.cant_reservado), 0)
											from articulo_mov_proy amp
										  where amp.almacen       = aa.almacen
											 and amp.cod_art       = aa.cod_art
											 and amp.flag_estado   = '1')
	  where aa.sldo_reservado <> (select nvl(sum(amp.cant_reservado), 0)
											from articulo_mov_proy amp
										  where amp.almacen       = aa.almacen
											 and amp.cod_art       = aa.cod_art
											 and amp.flag_estado   = '1');             
	commit;
	
	invo_wait.of_mensaje("Actualizando el SALDO RESERVADO en ARTICULO")
	
	update articulo a
		set a.sldo_reservado = (Select nvl(sum(aa.sldo_reservado), 0)
										  from articulo_almacen aa
										 where aa.cod_art       = a.cod_art)
	 where a.sldo_reservado <> (Select nvl(sum(aa.sldo_reservado), 0)
										  from articulo_almacen aa
										 where aa.cod_art       = a.cod_art);
	
	commit;
	
	invo_wait.of_mensaje("Activando Triggers de ARTICULO_MOV_PROY")
	
	//Apago el trigger;
	ls_sql = 'ALTER TABLE ARTICULO_MOV_PROY ENABLE ALL TRIGGERS'
	execute immediate :ls_sql;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCa.SQLErrText
		rollback;
		gnvo_app.of_mensaje_error( "Error al ejecutar la sentencia " + ls_sql + ": " + ls_mensaje)
	end if
	
	invo_wait.of_mensaje("Activando Triggers de ARTICULO_ALMACEN")
	
	//Apago el trigger;
	ls_sql = 'ALTER TABLE ARTICULO_ALMACEN ENABLE ALL TRIGGERS'
	execute immediate :ls_sql;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCa.SQLErrText
		rollback;
		gnvo_app.of_mensaje_error( "Error al ejecutar la sentencia " + ls_sql + ": " + ls_mensaje)
	end if
	
	invo_wait.of_mensaje("Ejecutando procedimiento usp_alm_act_saldo_sol_lleg")
	
	//CREATE OR REPLACE PROCEDURE usp_alm_act_saldo_sol_lleg(
	//       asi_nada             in string,
	//       aso_mensaje          out string,
	//       aio_ok               out integer
	//) is
	
	DECLARE usp_alm_act_saldo_sol_lleg PROCEDURE FOR
		usp_alm_act_saldo_sol_lleg( :gnvo_app.is_null );
	
	EXECUTE usp_alm_act_saldo_sol_lleg;
	
	IF SQLCA.sqlcode = -1 THEN
		ls_mensaje = "PROCEDURE usp_alm_act_saldo_sol_lleg: " + SQLCA.SQLErrText
		Rollback ;
		MessageBox('SQL error', ls_mensaje, StopSign!)	
		
		return 
	END IF
	
	CLOSE usp_alm_act_saldo_sol_lleg;
	
	commit;
	
	invo_wait.of_close()
	MessageBox('Aviso', 'Proceso Terminado Satisfactoriamente')
	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Error al procesar el saldo solicitado y por llegar")

finally
	
	invo_wait.of_mensaje("Activando Triggers de ARTICULO_MOV_PROY")
	
	//Apago el trigger;
	ls_sql = 'ALTER TABLE ARTICULO_MOV_PROY ENABLE ALL TRIGGERS'
	execute immediate :ls_sql;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCa.SQLErrText
		rollback;
		gnvo_app.of_mensaje_error( "Error al ejecutar la sentencia " + ls_sql + ": " + ls_mensaje)
	end if
	
	invo_wait.of_close()
	destroy invo_wait
	SetPointer (Arrow!)
end try

end event

event ue_salir();close(this)
end event

on w_al902_act_saldo_xllegar_solic.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.pb_1
end on

on w_al902_act_saldo_xllegar_solic.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

type st_1 from statictext within w_al902_act_saldo_xllegar_solic
integer width = 1984
integer height = 220
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Regenera el Saldo x Llegar, Saldo Solicitado y Saldo Reservado del Articulo"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_al902_act_saldo_xllegar_solic
integer x = 1001
integer y = 324
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "c:\sigre\resources\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

type pb_1 from picturebutton within w_al902_act_saldo_xllegar_solic
integer x = 626
integer y = 324
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "c:\sigre\resources\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

