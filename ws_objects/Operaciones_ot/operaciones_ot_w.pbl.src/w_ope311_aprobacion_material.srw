$PBExportHeader$w_ope311_aprobacion_material.srw
forward
global type w_ope311_aprobacion_material from w_abc
end type
type cbx_2 from checkbox within w_ope311_aprobacion_material
end type
type cbx_1 from checkbox within w_ope311_aprobacion_material
end type
type st_2 from statictext within w_ope311_aprobacion_material
end type
type em_items from editmask within w_ope311_aprobacion_material
end type
type rb_ord_trab from radiobutton within w_ope311_aprobacion_material
end type
type rb_ot_adm from radiobutton within w_ope311_aprobacion_material
end type
type cb_grabar from commandbutton within w_ope311_aprobacion_material
end type
type cb_procesar from commandbutton within w_ope311_aprobacion_material
end type
type dw_detail from u_dw_abc within w_ope311_aprobacion_material
end type
type uo_1 from u_ingreso_rango_fechas within w_ope311_aprobacion_material
end type
type cb_3 from commandbutton within w_ope311_aprobacion_material
end type
type st_1 from statictext within w_ope311_aprobacion_material
end type
type sle_codigo from singlelineedit within w_ope311_aprobacion_material
end type
type gb_1 from groupbox within w_ope311_aprobacion_material
end type
end forward

global type w_ope311_aprobacion_material from w_abc
integer width = 4718
integer height = 4416
string title = "Cambio de estado de materiales (OPE311)"
string menuname = "m_salir"
event ue_anular ( )
event ue_aprobar ( )
event ue_desaprobar ( )
cbx_2 cbx_2
cbx_1 cbx_1
st_2 st_2
em_items em_items
rb_ord_trab rb_ord_trab
rb_ot_adm rb_ot_adm
cb_grabar cb_grabar
cb_procesar cb_procesar
dw_detail dw_detail
uo_1 uo_1
cb_3 cb_3
st_1 st_1
sle_codigo sle_codigo
gb_1 gb_1
end type
global w_ope311_aprobacion_material w_ope311_aprobacion_material

type variables
String is_dw
end variables

forward prototypes
public function long wf_asig_nro_solicitud_ot ()
end prototypes

event ue_aprobar();Long ll_row, ll_i
string ls_oper_sec

ll_row = dw_detail.GetSelectedRow(0)
Do While ll_row <> 0
	dw_detail.object.flag_estado[ll_row]='1'
	dw_detail.ii_update = 1
	ll_row = dw_detail.GetSelectedRow(ll_row)
Loop

end event

event ue_desaprobar();Long ll_row, ll_i
string ls_oper_sec

ll_row = dw_detail.GetSelectedRow(0)
Do While ll_row <> 0
	dw_detail.object.flag_estado[ll_row]='0'
	dw_detail.ii_update = 1
	ll_row = dw_detail.GetSelectedRow(ll_row )
Loop
	

end event

public function long wf_asig_nro_solicitud_ot ();Long   ll_nro_solitiud_ot
String ls_lock_table

ls_lock_table = 'LOCK TABLE NUM_SOLICITUD_OT IN EXCLUSIVE MODE'
EXECUTE IMMEDIATE :ls_lock_table ;

SELECT NVL(ULT_NRO,0) 
INTO   :ll_nro_solitiud_ot
FROM   NUM_SOLICITUD_OT
WHERE  RECKEY = '1' ;

	
UPDATE NUM_SOLICITUD_OT
SET ULT_NRO = :ll_nro_solitiud_ot + 1
WHERE RECKEY = '1' ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
	ll_nro_solitiud_ot = 0
	
END IF


Return ll_nro_solitiud_ot

end function

on w_ope311_aprobacion_material.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.cbx_2=create cbx_2
this.cbx_1=create cbx_1
this.st_2=create st_2
this.em_items=create em_items
this.rb_ord_trab=create rb_ord_trab
this.rb_ot_adm=create rb_ot_adm
this.cb_grabar=create cb_grabar
this.cb_procesar=create cb_procesar
this.dw_detail=create dw_detail
this.uo_1=create uo_1
this.cb_3=create cb_3
this.st_1=create st_1
this.sle_codigo=create sle_codigo
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_2
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_items
this.Control[iCurrent+5]=this.rb_ord_trab
this.Control[iCurrent+6]=this.rb_ot_adm
this.Control[iCurrent+7]=this.cb_grabar
this.Control[iCurrent+8]=this.cb_procesar
this.Control[iCurrent+9]=this.dw_detail
this.Control[iCurrent+10]=this.uo_1
this.Control[iCurrent+11]=this.cb_3
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.sle_codigo
this.Control[iCurrent+14]=this.gb_1
end on

on w_ope311_aprobacion_material.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_2)
destroy(this.cbx_1)
destroy(this.st_2)
destroy(this.em_items)
destroy(this.rb_ord_trab)
destroy(this.rb_ot_adm)
destroy(this.cb_grabar)
destroy(this.cb_procesar)
destroy(this.dw_detail)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.st_1)
destroy(this.sle_codigo)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;Long ll_count

//dw_master.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)

idw_1 = dw_detail              // asignar dw corriente

rb_ot_adm.checked=true
cb_procesar.enabled=true
rb_ot_adm.enabled=true
cb_grabar.enabled=false

//Help
//ii_help = 301
em_items.text = '3'

end event

event ue_modify;call super::ue_modify;//String  ls_flag_estado
//Long    ll_row_master
//Integer li_protect
//
//dw_master.accepttext()
//ll_row_master = dw_master.getrow()
//
//IF ll_row_master = 0 THEN RETURN
//
//ls_flag_estado = dw_master.object.flag_estado [ll_row_master]
//
///*
//Estado 0 - Anulado
//Estado 1 - Activo
//Estado 2 - Atendido
//Estado 3 - Rechazado
//*/
//
//dw_master.of_protect()
//
//IF ls_flag_estado = '0' THEN //ANULADO  proteger todo
//	dw_master.ii_protect = 0
//	dw_master.of_protect() 
//ELSEIF ls_flag_estado = '1'  THEN
//	li_protect = integer(dw_master.Object.cal_rec_tipo.Protect)
//	IF li_protect = 0	THEN
//		dw_master.object.flag_estado.Protect = 1
//	END IF
//ELSE
//	dw_master.ii_protect = 0
//	dw_master.of_protect() 
//	
//	//HABILITAR RESPUESTA
//
//	dw_master.object.flag_estado.Protect = 0
////	dw_master.object.respuesta_rsp.setfocous()
//END IF
//
end event

event ue_insert;call super::ue_insert;Long  ll_row

TriggerEvent('ue_update_request')

IF ib_update_check = FALSE THEN RETURN

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN 
	This.Event ue_insert_pos(ll_row)
END IF	

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result
// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_detail.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_detail.ii_update = 0
	END IF
END IF

end event

event ue_print;call super::ue_print;/*
Long ll_row_master
Str_cns_pop lstr_cns_pop

ll_row_master = dw_master.getrow()

IF ll_row_master = 0 THEN RETURN

IF (dw_master.ii_update = 1 ) THEN
	Messagebox('Aviso','Grabe Modificaciones Pendientes ')
	RETURN
END IF

//*Imprime Boleta*//
IF dw_master.ii_update = 1 THEN
	Messagebox('Aviso','Grabe Modificaciones , Para Proceder Imprimir Solicitud ')
	Return
END IF

lstr_cns_pop.arg[1] = dw_master.object.nro_solicitud [ll_row_master]

OpenSheetWithParm(w_ope301_solicit_ot_rpt, lstr_cns_pop, this, 2, Layered!)
*/

end event

event ue_delete;Messagebox('Aviso','No se puede eliminar Registro Verifique!')
end event

event resize;call super::resize;
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_detail.AcceptText()

THIS.EVENT ue_update_pre()

IF ib_update_check = FALSE THEN RETURN

IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_detail.ii_update = 0
END IF

end event

type cbx_2 from checkbox within w_ope311_aprobacion_material
integer x = 123
integer y = 220
integer width = 645
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Proyectados a activos"
end type

event clicked;IF cbx_2.checked=TRUE THEN
	cbx_1.checked=FALSE
ELSE
	cbx_1.checked=TRUE
END IF 

end event

type cbx_1 from checkbox within w_ope311_aprobacion_material
integer x = 123
integer y = 128
integer width = 645
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Activos a proyectados"
boolean checked = true
end type

event clicked;IF cbx_1.checked=TRUE THEN
	cbx_2.checked=FALSE
ELSE
	cbx_2.checked=TRUE
END IF 

end event

type st_2 from statictext within w_ope311_aprobacion_material
integer x = 2656
integer y = 280
integer width = 183
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Items :"
boolean focusrectangle = false
end type

type em_items from editmask within w_ope311_aprobacion_material
integer x = 2857
integer y = 264
integer width = 119
integer height = 84
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type rb_ord_trab from radiobutton within w_ope311_aprobacion_material
integer x = 837
integer y = 220
integer width = 375
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Trab."
end type

event clicked;IF rb_ord_trab.checked = TRUE THEN
	st_1.text = 'Ord.Trab.'
	cb_procesar.enabled = true
	cb_grabar.enabled = false	
END IF
end event

type rb_ot_adm from radiobutton within w_ope311_aprobacion_material
integer x = 837
integer y = 128
integer width = 375
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OT Adm"
boolean checked = true
end type

event clicked;IF rb_ot_adm.checked = TRUE THEN
	st_1.text = 'OT Adm.'
	cb_procesar.enabled = true
	cb_grabar.enabled = false
END IF
end event

type cb_grabar from commandbutton within w_ope311_aprobacion_material
integer x = 2651
integer y = 124
integer width = 325
integer height = 84
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Grabar"
end type

event clicked;String ls_estado, ls_msj_err
Long ll_count

parent.event ue_update()

IF cbx_1.checked = TRUE THEN
	ls_estado='1'
ELSE
	ls_estado='3'
END IF

// aprobacion de materiales	
DECLARE usp_ope_cambia_estado_mat PROCEDURE FOR 
		  usp_ope_cambia_estado_mat(:ls_estado) ; 

EXECUTE usp_ope_cambia_estado_mat ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error usp_ope_cambia_estado_mat',ls_msj_err)
	Return
ELSE
	commit ;
END IF

CLOSE usp_ope_cambia_estado_mat ;

cb_grabar.enabled  = false

dw_detail.reset()

Messagebox('Aviso', 'Proceso ha concluído satisfactoriamente')

end event

type cb_procesar from commandbutton within w_ope311_aprobacion_material
integer x = 2249
integer y = 124
integer width = 265
integer height = 84
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;String ls_estado, ls_tipo, ls_codigo, ls_opcion, ls_msj_err
DATE ld_fec_ini, ld_fec_fin, ld_fecha
DateTime ldt_fecha_sistema
Long ll_count

IF cbx_1.checked=TRUE THEN
	ls_estado = '1'
END IF 

IF cbx_2.checked=TRUE THEN
	ls_estado = '3'
END IF 

IF rb_ot_adm.checked = FALSE AND rb_ord_trab.checked=FALSE THEN
	MessaGebox('Aviso','Seleccione ot_adm o ot, para generar procesos')
	Return
ELSEIF rb_ot_adm.checked=TRUE THEN
	ls_tipo = '1'
ELSE	
	ls_tipo = '2'
END IF

ls_codigo = TRIM(sle_codigo.text)
ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()

// Validando que la fecha no sea inferior a fecha del sistema
SELECT TRUNC(sysdate) INTO :ldt_fecha_sistema FROM dual ;

ld_fecha = DATE(ldt_fecha_sistema)

IF ld_fec_ini < ld_fecha THEN
	messagebox('Aviso','Fecha inicial no puede ser menor a fecha del sistema')
	return
END IF

DECLARE PB_usp_ope_selecc_operac_mater PROCEDURE FOR 
		  usp_ope_selecc_operac_mater(:ls_estado, 
		  										:ls_tipo, 
										 		:ls_codigo, 
										 		:ld_fec_ini, 
										 		:ld_fec_fin, 
										 		:gs_user);
												 
EXECUTE PB_usp_ope_selecc_operac_mater ;


IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error',ls_msj_err)
	Return
end if

CLOSE PB_usp_ope_selecc_operac_mater ;

cb_grabar.enabled=true

//cb_procesar.enabled=false
//
dw_detail.Retrieve()



end event

type dw_detail from u_dw_abc within w_ope311_aprobacion_material
integer x = 46
integer y = 392
integer width = 3269
integer height = 1356
integer taborder = 20
string dataobject = "d_proc_materiales_aprobadas_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle


end event

event clicked;call super::clicked;is_dw = '2'
dw_detail.ii_update = 1
end event

event rbuttondown;//Ancestor Script
if row = 0 then return
m_rbutton_aprobar 	lm_1

lm_1 = CREATE m_rbutton_aprobar 
lm_1.PopMenu(w_main.PointerX(), w_main.PointerY())

destroy lm_1

end event

event doubleclicked;call super::doubleclicked;string 			ls_nro_orden, ls_estado
Long 				ll_em_items
str_parametros 	lstr_param

IF cbx_1.checked= TRUE THEN
	ls_estado = '1' // Estado activo
ELSE
	ls_estado = '3' // Estado proyectado	
END IF 
		
choose case lower(dwo.name)
	case 'oper_sec'
		if row = 0 then return
		
		ls_nro_orden = this.object.oper_sec[row]
		lstr_param.dw1		 = 'd_cns_det_opersec_x_autorizar_mat_tbl'
		lstr_param.string1 = '1'
		lstr_param.string2 = ls_nro_orden
		lstr_param.string3 = ls_estado
		
		OpenWithParm(w_cns_datos_ot, lstr_param)
	case 'articulo_mov_proy_cod_art'
		if row = 0 then return
		ls_nro_orden = this.object.articulo_mov_proy_cod_art[row]
		ll_em_items  = LONG(em_items.text)
		lstr_param.dw1		 = 'd_cns_articulos_x_aprobar_cmp'
		lstr_param.string1 = '2'
		lstr_param.string2 = ls_nro_orden
		lstr_param.long1 	 = ll_em_items
		OpenWithParm(w_cns_datos_ot, lstr_param)

case 'nro_orden'
		if row = 0 then return
		
		ls_nro_orden = this.object.nro_orden[row]
		lstr_param.dw1		 = 'd_abc_datos_ot_frm'
		lstr_param.string1 = '3'
		lstr_param.string2 = ls_nro_orden
		OpenWithParm(w_cns_datos_ot, lstr_param)
end choose


end event

type uo_1 from u_ingreso_rango_fechas within w_ope311_aprobacion_material
integer x = 1257
integer y = 232
integer taborder = 80
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') 
of_set_fecha(today(), today())
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event getfocusobject;call super::getfocusobject;//cb_procesar.enabled

end event

type cb_3 from commandbutton within w_ope311_aprobacion_material
integer x = 1801
integer y = 120
integer width = 201
integer height = 84
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ubicar"
end type

event clicked;string ls_sql, ls_codigo, ls_desc

IF rb_ot_adm.checked = TRUE THEN
	ls_sql = "select oa.ot_adm as codigo_ot_adm, " &
			 + "oa.descripcion as desc_ot_adm "&
			 + "from ot_administracion oa, " &
			 + "ot_adm_usuario ou "&
			 + "where (oa.ot_adm=ou.ot_adm) and "&
			 + "ou.cod_usr= '" + gs_user + "'"
END IF
	
IF rb_ord_trab.checked = TRUE THEN
	ls_sql = "select ot.nro_orden as nro_orden, " &
			 + "ot.titulo as observacion, " &
       	 + "oa.ot_adm as ot_admin " &
			 + "from ot_administracion oa, " &
			 + "ot_adm_usuario ou, " &
          + "orden_trabajo ot " &
			 + "where (oa.ot_adm=ou.ot_adm) and " &
          + "oa.ot_adm = ot.ot_adm and " &
          + "ot.flag_estado in ('1','3') and " &
 			 + "ou.cod_usr='" + gs_user + "'" 
END IF
f_lista( ls_sql, ls_codigo, ls_desc, '1')													 
			
IF ls_codigo <> '' THEN
	sle_codigo.text = ls_codigo
END IF

cb_procesar.enabled=true
cb_grabar.enabled=false

end event

type st_1 from statictext within w_ope311_aprobacion_material
integer x = 1266
integer y = 124
integer width = 219
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Código:"
boolean focusrectangle = false
end type

type sle_codigo from singlelineedit within w_ope311_aprobacion_material
event ue_tecla pbm_keydown
integer x = 1486
integer y = 120
integer width = 297
integer height = 84
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;IF Key = KeyEnter! THEN
	cb_procesar.triggerevent(clicked!)
else
	cb_procesar.enabled = true
END IF

end event

type gb_1 from groupbox within w_ope311_aprobacion_material
integer x = 82
integer y = 48
integer width = 2491
integer height = 300
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

