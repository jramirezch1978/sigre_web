$PBExportHeader$w_rh388_snp_retenciones.srw
$PBExportComments$abc Maestro detalle con pop window para la busqueda del maestro, ff para el Maestro, tbl para el detalle
forward
global type w_rh388_snp_retenciones from w_abc
end type
type cb_3 from commandbutton within w_rh388_snp_retenciones
end type
type rb_regenera from radiobutton within w_rh388_snp_retenciones
end type
type rb_recupera from radiobutton within w_rh388_snp_retenciones
end type
type sle_desc_origen from singlelineedit within w_rh388_snp_retenciones
end type
type em_origen from editmask within w_rh388_snp_retenciones
end type
type em_ano from editmask within w_rh388_snp_retenciones
end type
type dw_master from u_dw_abc within w_rh388_snp_retenciones
end type
type dw_detail from u_dw_abc within w_rh388_snp_retenciones
end type
type st_2 from statictext within w_rh388_snp_retenciones
end type
type st_1 from statictext within w_rh388_snp_retenciones
end type
type cb_2 from commandbutton within w_rh388_snp_retenciones
end type
type gb_1 from groupbox within w_rh388_snp_retenciones
end type
end forward

global type w_rh388_snp_retenciones from w_abc
integer width = 2720
integer height = 2220
string title = "[RH388]Retencions de SNP"
string menuname = "m_master_simple"
event ue_procesar ( integer ai_ano,  string as_cod_origen )
cb_3 cb_3
rb_regenera rb_regenera
rb_recupera rb_recupera
sle_desc_origen sle_desc_origen
em_origen em_origen
em_ano em_ano
dw_master dw_master
dw_detail dw_detail
st_2 st_2
st_1 st_1
cb_2 cb_2
gb_1 gb_1
end type
global w_rh388_snp_retenciones w_rh388_snp_retenciones

type variables
String      		is_tabla_m,is_tabla_d,is_colname_m[],is_coltype_m[],is_colname_d[],is_coltype_d[]
n_cst_log_diario	in_log

end variables

event ue_procesar(integer ai_ano, string as_cod_origen);String ls_concepto 

// Concepto de descuento de SNP 
SELECT r.c_retenc_snp 
  INTO :ls_concepto 
  FROM rrhhparam_snp_afp r 
 WHERE r.reckey='1' ;

// Elimina registros en caso lo hubiera
DELETE FROM RRHH_FORMATO_SNP r WHERE r.ano=:ai_ano AND r.cod_origen=:as_cod_origen ;

// Inserta registros de historico
INSERT INTO rrhh_formato_snp(cod_trabajador, cod_origen, ano, mes, valor_planilla, valor_digitado, flag_manual)
SELECT hc.cod_trabajador, 
		 hc.cod_origen, 
		 to_number(to_char(hc.fec_calc_plan,'yyyy')), 
		 to_number(to_char(hc.fec_calc_plan,'mm')), 
	 	 sum(hc.imp_soles), 0, '0'
  FROM historico_calculo hc
 WHERE to_number(to_char(hc.fec_calc_plan,'yyyy')) = :ai_ano and 
		 hc.cod_origen = :as_cod_origen and 
       hc.concep = :ls_concepto 
GROUP BY hc.cod_trabajador, hc.cod_origen, to_number(to_char(hc.fec_calc_plan,'yyyy')), to_number(to_char(hc.fec_calc_plan,'mm'))       
ORDER BY hc.cod_trabajador, hc.cod_origen, to_number(to_char(hc.fec_calc_plan,'yyyy')), to_number(to_char(hc.fec_calc_plan,'mm')) ;
	
COMMIT using SQLCA;
end event

on w_rh388_snp_retenciones.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.cb_3=create cb_3
this.rb_regenera=create rb_regenera
this.rb_recupera=create rb_recupera
this.sle_desc_origen=create sle_desc_origen
this.em_origen=create em_origen
this.em_ano=create em_ano
this.dw_master=create dw_master
this.dw_detail=create dw_detail
this.st_2=create st_2
this.st_1=create st_1
this.cb_2=create cb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.rb_regenera
this.Control[iCurrent+3]=this.rb_recupera
this.Control[iCurrent+4]=this.sle_desc_origen
this.Control[iCurrent+5]=this.em_origen
this.Control[iCurrent+6]=this.em_ano
this.Control[iCurrent+7]=this.dw_master
this.Control[iCurrent+8]=this.dw_detail
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.gb_1
end on

on w_rh388_snp_retenciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.rb_regenera)
destroy(this.rb_recupera)
destroy(this.sle_desc_origen)
destroy(this.em_origen)
destroy(this.em_ano)
destroy(this.dw_master)
destroy(this.dw_detail)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_insert;call super::ue_insert;Long  ll_row

//IF idw_1 = dw_detail AND dw_master.il_row = 0 THEN
//	MessageBox("Error", "No ha seleccionado registro Maestro")
//	RETURN
//END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
dw_detail.of_protect()
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)
idw_1 = dw_master              			// asignar dw corriente
dw_detail.BorderStyle = StyleRaised! 	// indicar dw_detail como no activado
dw_master.of_protect()         			// bloquear modificaciones 
dw_detail.of_protect()
is_tabla_m = dw_master.Object.Datawindow.Table.UpdateTable
is_tabla_d = dw_detail.Object.Datawindow.Table.UpdateTable

// ii_help = 101           // help topic
//ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
//ib_log = TRUE
//idw_query = dw_master

end event

event ue_scrollrow;call super::ue_scrollrow;Long ll_rc

ll_rc = dw_master.of_ScrollRow(as_value)

RETURN ll_rc
end event

event ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
//dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log_m, lds_log_d
	lds_log_m = Create DataStore
	lds_log_d = Create DataStore
	lds_log_m.DataObject = 'd_log_diario_tbl'
	lds_log_d.DataObject = 'd_log_diario_tbl'
	lds_log_m.SetTransObject(SQLCA)
	lds_log_d.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log_m, is_colname_m, is_coltype_m, gs_user, is_tabla_m)
	in_log.of_create_log(dw_detail, lds_log_d, is_colname_d, is_coltype_d, gs_user, is_tabla_d)
END IF


IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_m.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario, Maestro')
		END IF
		IF lds_log_d.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario, Detalle')
		END IF
	END IF
	DESTROY lds_log_m
	DESTROY lds_log_d
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	//dw_master.ii_update = 0
	dw_detail.ii_update = 0
END IF

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
	END IF
END IF

end event

event ue_open_pos();call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(dw_master, is_colname_m, is_coltype_m)
	in_log.of_dw_map(dw_detail, is_colname_d, is_coltype_d)
END IF
end event

event close;call super::close;Destroy in_log
end event

event ue_duplicar;call super::ue_duplicar;idw_1.Event ue_duplicar()
end event

type cb_3 from commandbutton within w_rh388_snp_retenciones
integer x = 1902
integer y = 180
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesa"
end type

event clicked;String ls_origen, ls_flag_recupera
Long ll_ano 

ll_ano = LONG(em_ano.text)
ls_origen = TRIM(em_origen.text)

// Limpia datawindows
dw_master.reset()
dw_detail.reset()

IF rb_regenera.checked = TRUE THEN 
	ls_flag_recupera = '1'
	Event ue_procesar(ll_ano, ls_origen)
END IF ;

dw_master.retrieve(ll_ano, ls_origen)






end event

type rb_regenera from radiobutton within w_rh388_snp_retenciones
integer x = 1678
integer y = 104
integer width = 681
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Regenera información"
end type

type rb_recupera from radiobutton within w_rh388_snp_retenciones
integer x = 795
integer y = 100
integer width = 727
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Recupera información"
boolean checked = true
end type

type sle_desc_origen from singlelineedit within w_rh388_snp_retenciones
integer x = 782
integer y = 196
integer width = 1065
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type em_origen from editmask within w_rh388_snp_retenciones
integer x = 539
integer y = 196
integer width = 128
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "!!"
end type

type em_ano from editmask within w_rh388_snp_retenciones
integer x = 539
integer y = 96
integer width = 169
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type dw_master from u_dw_abc within w_rh388_snp_retenciones
integer x = 27
integer y = 348
integer width = 2592
integer height = 876
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_abc_retencion_snp_grd"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event constructor;call super::constructor;is_mastdet = 'md'

is_dwform = 'tabular'	

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
idw_mst  = dw_master
idw_det  = dw_detail
end event

event doubleclicked;call super::doubleclicked;Long ll_ano
String ls_origen, ls_cod_trabajador

IF this.GetRow() = 0 THEN Return

IF row > 0 THEN 
	ll_ano = LONG (em_ano.text)
	ls_origen = TRIM(em_origen.text)
	ls_cod_trabajador = this.object.cod_trabajador[row]
	dw_detail.Retrieve(ll_ano, ls_cod_trabajador, ls_origen)
END IF 



end event

type dw_detail from u_dw_abc within w_rh388_snp_retenciones
integer x = 18
integer y = 1280
integer width = 2615
integer height = 708
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_abc_rrhh_formato_snp_grd"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'      // 'm' = master sin detalle (default), 'd' =  detalle,
                       // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular' // tabular, grid, form
 
idw_mst  = dw_master
 
ii_ck[1] = 1			// columnas de lectura de este dw
ii_ck[2] = 2			// columnas de lectura de este dw
ii_ck[3] = 3			// columnas de lectura de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

idw_det  = dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;IF dw_master.Getrow() = 0 THEN Return

this.object.ano[al_row]=Integer(em_ano.text)
this.object.cod_origen[al_row]=TRIM(em_origen.text)
this.object.cod_trabajador[al_row]=dw_master.object.cod_trabajador[dw_master.GetRow()]
this.Object.flag_manual[al_row]='1'
end event

type st_2 from statictext within w_rh388_snp_retenciones
integer x = 110
integer y = 196
integer width = 224
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 134217750
string text = "Origen :"
boolean focusrectangle = false
end type

type st_1 from statictext within w_rh388_snp_retenciones
integer x = 110
integer y = 100
integer width = 224
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 134217750
string text = "Año :"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_rh388_snp_retenciones
integer x = 384
integer y = 196
integer width = 87
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	sle_desc_origen.text = sl_param.field_ret[2]
END IF

end event

type gb_1 from groupbox within w_rh388_snp_retenciones
integer x = 50
integer y = 52
integer width = 2386
integer height = 260
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Parametros"
end type

