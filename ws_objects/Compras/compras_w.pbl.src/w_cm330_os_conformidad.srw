$PBExportHeader$w_cm330_os_conformidad.srw
forward
global type w_cm330_os_conformidad from w_abc_master
end type
type rb_aprobacion from radiobutton within w_cm330_os_conformidad
end type
type rb_desaprobacion from radiobutton within w_cm330_os_conformidad
end type
type cb_lectura from commandbutton within w_cm330_os_conformidad
end type
type uo_fecha from u_ingreso_rango_fechas within w_cm330_os_conformidad
end type
type gb_1 from groupbox within w_cm330_os_conformidad
end type
end forward

global type w_cm330_os_conformidad from w_abc_master
integer width = 5024
integer height = 2208
string title = "Orden Servicio Conformidad (CM330)"
string menuname = "m_mantenimiento"
event type long ue_retrieve ( )
rb_aprobacion rb_aprobacion
rb_desaprobacion rb_desaprobacion
cb_lectura cb_lectura
uo_fecha uo_fecha
gb_1 gb_1
end type
global w_cm330_os_conformidad w_cm330_os_conformidad

event type long ue_retrieve();Long	ll_rc

IF rb_aprobacion.checked THEN
	ll_rc = idw_1.Retrieve(gs_user)
ELSE
	ll_rc = idw_1.Retrieve(gs_user, uo_fecha.of_get_fecha1(), uo_fecha.of_get_fecha2())
END IF


RETURN ll_rc
end event

on w_cm330_os_conformidad.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento" then this.MenuID = create m_mantenimiento
this.rb_aprobacion=create rb_aprobacion
this.rb_desaprobacion=create rb_desaprobacion
this.cb_lectura=create cb_lectura
this.uo_fecha=create uo_fecha
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_aprobacion
this.Control[iCurrent+2]=this.rb_desaprobacion
this.Control[iCurrent+3]=this.cb_lectura
this.Control[iCurrent+4]=this.uo_fecha
this.Control[iCurrent+5]=this.gb_1
end on

on w_cm330_os_conformidad.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_aprobacion)
destroy(this.rb_desaprobacion)
destroy(this.cb_lectura)
destroy(this.uo_fecha)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;
//ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)



uo_fecha.visible = False
end event

event ue_update;// Override
Boolean  lbo_ok = TRUE
String	ls_msg, ls_check, ls_cod_origen, ls_nro_os, ls_oper_sec, ls_user
String	ls_estado, ls_error, ls_llave, ls_val_anterior
Long		ll_x
Integer	li_nro_item
Date		ld_fecha

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF rb_aprobacion.checked THEN
	ls_estado = '2'
	ld_fecha = Today()
	ls_user = gs_user
ELSE
	ls_estado = '1'
	SetNull(ld_fecha)
	SetNull(ls_user)
END IF
	
FOR ll_x = 1 TO idw_1.Rowcount( )
	ls_check = idw_1.GetItemString(ll_x, 'flag')
	IF ls_check = '1' THEN
		ls_cod_origen = idw_1.GetItemString(ll_x, 'COD_ORIGEN')
		ls_nro_os     = idw_1.GetItemString(ll_x, 'NRO_OS')
		li_nro_item   = idw_1.GetItemNumber(ll_x, 'NRO_ITEM')
		ls_oper_sec   = idw_1.GetItemString(ll_x, 'OPER_SEC')
		//Grabacion Orden Servicio Det
		UPDATE ORDEN_SERVICIO_DET  
         SET CONFORMIDAD_FECHA = :ld_fecha,   
             CONFORMIDAD_USR   = :ls_user  
		 WHERE COD_ORIGEN = :ls_cod_origen AND
		       NRO_OS     = :ls_nro_os AND
				 NRO_ITEM   = :li_nro_item ;
		// Status de Base de Datos
		IF SQLCA.SQLCODE <> 0 THEN
			lbo_ok = FALSE
			ls_error = SQLCA.SQLErrText
			ROLLBACK USING SQLCA;
			MessageBox(ls_error, 'No se pudo Grabar en ORDEN_SERVICIO_DET')
			EXIT
		END IF
		//Grabacion Operacion
		UPDATE OPERACIONES 
         SET FLAG_ESTADO = :ls_estado
		 WHERE OPER_SEC = :ls_oper_sec;
		// Status de Base de Datos
		IF SQLCA.SQLCODE <> 0 THEN
			lbo_ok = FALSE
			ls_error = SQLCA.SQLErrText
			ROLLBACK USING SQLCA;
			MessageBox(ls_error, 'No se pudo Grabar en OPERACIONES')
			EXIT
		END IF
		//Log Diario solo para Desaprobaciones
		IF rb_desaprobacion.checked THEN
			ls_llave = ls_cod_origen + '/' + ls_nro_os + '/' + String(li_nro_item)
			ls_val_anterior = String(idw_1.GetItemDateTime(ll_x, 'CONFORMIDAD_FECHA'), 'dd/mm/yy')
			INSERT INTO LOG_DIARIO (TABLA, OPERACION, CAMPO, LLAVE, VAL_ANTERIOR, COD_USR)
			     VALUES ( 'ORDEN_SERVICIO_DET', 'Update', 'CONFORMIDAD_FECHA', :ls_llave, :ls_val_anterior, :gs_user) ;
			// Status de Base de Datos
			IF SQLCA.SQLCODE <> 0 THEN
				lbo_ok = FALSE
				ls_error = SQLCA.SQLErrText
				ROLLBACK USING SQLCA;
				MessageBox(ls_error, 'No se pudo Grabar en LOG_DIARIO')
				EXIT
			END IF
		END IF
	END IF
NEXT

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	THIS.EVENT ue_retrieve()
END IF

end event

type dw_master from w_abc_master`dw_master within w_cm330_os_conformidad
integer x = 23
integer y = 152
integer width = 2418
integer height = 1188
string dataobject = "d_os_pend_conf_ot_adm_usr_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	

is_dwform = 'tabular'

end event

event dw_master::doubleclicked;//Override
IF row = 0 THEN RETURN

String   ls_check
Decimal	ldc_prov


ls_check = idw_1.GetItemString(row, 'flag')

IF ls_check = '0' THEN
	IF rb_desaprobacion.Checked THEN
		ldc_prov = THIS.GetItemDecimal( row, 'provision')
		IF ldc_prov = 0 THEN
			idw_1.SetItem(row, 'flag', '1')
		ELSE
			MessageBox('Error', 'El Servicio tiene Importe Provisionado')
		END IF
	ELSE
		idw_1.SetItem(row, 'flag', '1')
	END IF
ELSEIF ls_check = '1' THEN
	idw_1.SetItem(row, 'flag', '0')
END IF
	
end event

type rb_aprobacion from radiobutton within w_cm330_os_conformidad
integer x = 73
integer y = 68
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Aprobacion"
boolean checked = true
end type

event clicked;idw_1.DataObject = 'd_os_pend_conf_ot_adm_usr_tbl'
idw_1.SetTransObject(SQLCA)
uo_fecha.visible = False
end event

type rb_desaprobacion from radiobutton within w_cm330_os_conformidad
integer x = 462
integer y = 68
integer width = 411
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desaprobacion"
end type

event clicked;idw_1.DataObject = 'd_os_aprob_conf_ot_adm_usr_tbl'
idw_1.SetTransObject(SQLCA)
uo_fecha.visible = True
end event

type cb_lectura from commandbutton within w_cm330_os_conformidad
integer x = 2318
integer y = 44
integer width = 343
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;PARENT.EVENT ue_retrieve()
end event

type uo_fecha from u_ingreso_rango_fechas within w_cm330_os_conformidad
integer x = 955
integer y = 48
integer taborder = 30
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(RelativeDate(Today(),-30), Today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

type gb_1 from groupbox within w_cm330_os_conformidad
integer x = 32
integer y = 8
integer width = 887
integer height = 136
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Accion"
end type

