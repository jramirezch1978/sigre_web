$PBExportHeader$w_rh389_remuneracion_retenciones.srw
$PBExportComments$abc Maestro detalle con pop window para la busqueda del maestro, ff para el Maestro, tbl para el detalle
forward
global type w_rh389_remuneracion_retenciones from w_abc
end type
type cbx_snp from checkbox within w_rh389_remuneracion_retenciones
end type
type cbx_afp from checkbox within w_rh389_remuneracion_retenciones
end type
type cb_3 from commandbutton within w_rh389_remuneracion_retenciones
end type
type rb_regenera from radiobutton within w_rh389_remuneracion_retenciones
end type
type rb_recupera from radiobutton within w_rh389_remuneracion_retenciones
end type
type sle_desc_origen from singlelineedit within w_rh389_remuneracion_retenciones
end type
type em_origen from editmask within w_rh389_remuneracion_retenciones
end type
type em_ano from editmask within w_rh389_remuneracion_retenciones
end type
type dw_master from u_dw_abc within w_rh389_remuneracion_retenciones
end type
type dw_detail from u_dw_abc within w_rh389_remuneracion_retenciones
end type
type st_2 from statictext within w_rh389_remuneracion_retenciones
end type
type st_1 from statictext within w_rh389_remuneracion_retenciones
end type
type cb_2 from commandbutton within w_rh389_remuneracion_retenciones
end type
type gb_1 from groupbox within w_rh389_remuneracion_retenciones
end type
end forward

global type w_rh389_remuneracion_retenciones from w_abc
integer width = 3575
integer height = 2220
string title = "[RH389] Retencions de AFP y SNP"
string menuname = "m_master_simple"
event ue_procesar ( integer ai_ano,  string as_cod_origen,  string as_tipo_retencion )
cbx_snp cbx_snp
cbx_afp cbx_afp
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
global w_rh389_remuneracion_retenciones w_rh389_remuneracion_retenciones

type variables
String      		is_tabla_m,is_tabla_d,is_colname_m[],is_coltype_m[],is_colname_d[],is_coltype_d[]
n_cst_log_diario	in_log

end variables

event ue_procesar(integer ai_ano, string as_cod_origen, string as_tipo_retencion);String ls_ano, ls_tipo_retenc, ls_comis_porc, ls_seguro_inval, ls_aporte_indiv, ls_retenc_snp, &
		 ls_grp_snp, ls_grp_afp, ls_conceptos 
Integer li_ano 

SELECT r.c_comis_porc, r.c_seguro_inval, r.c_aporte_indiv, r.c_retenc_snp, r.g_retenc_snp, r.g_aportac_afp 
  INTO :ls_comis_porc, :ls_seguro_inval, :ls_aporte_indiv, :ls_retenc_snp, :ls_grp_snp, :ls_grp_afp 
  FROM rrhhparam_snp_afp r 
 WHERE r.reckey = '1';
 
ls_ano = String(ai_ano) 

// Elimina los registros antes de reprocesar en caso existiera
DELETE FROM rrhh_fmt_remun_retenc r 
 WHERE r.ano = :ai_ano 
	AND r.cod_origen = :as_cod_origen 
	AND r.flag_tipo_retencion = :as_tipo_retencion ;


IF as_tipo_retencion = 'A' THEN 
	
	ls_conceptos = ls_aporte_indiv + "','" + ls_seguro_inval + "','" + ls_comis_porc

	INSERT INTO rrhh_fmt_remun_retenc(ano, mes, cod_trabajador, concep, flag_tipo_retencion, cod_origen, valor_manual, valor_planilla) 
	select to_number(to_char(hc.fec_calc_plan,'yyyy')), 
			 to_number(to_char(hc.fec_calc_plan,'mm')), 
			 hc.cod_trabajador, hc.concep, :as_tipo_retencion, :as_cod_origen, 0, 
			 sum(hc.imp_soles) 
	from historico_calculo hc, grupo_calculo gc, grupo_calculo_det gcd, maestro m 
	where hc.cod_trabajador = m.cod_trabajador 
	  AND to_char(hc.fec_calc_plan,'yyyy')= :ls_ano 
	  AND m.cod_origen = :as_cod_origen 
	  AND gc.grupo_calculo = gcd.grupo_calculo
	  AND hc.concep = gcd.concepto_calc 
	  AND gc.grupo_calculo = :ls_grp_afp 
	  AND hc.cod_trabajador in (select distinct(hcc.cod_trabajador) 
	   								   from historico_calculo hcc 
										  where to_char(hcc.fec_calc_plan,'yyyy')=:ls_ano 
										    and hcc.concep in (:ls_aporte_indiv, :ls_seguro_inval, :ls_comis_porc))
	group by to_number(to_char(hc.fec_calc_plan,'yyyy')), 
				to_number(to_char(hc.fec_calc_plan,'mm')), 
				hc.cod_trabajador, hc.concep, :as_tipo_retencion, :as_cod_origen, 0
	order by hc.cod_trabajador ;
ELSE
	
	INSERT INTO rrhh_fmt_remun_retenc(ano, mes, cod_trabajador, concep, flag_tipo_retencion, cod_origen, valor_manual, valor_planilla) 
	select to_number(to_char(hc.fec_calc_plan,'yyyy')), 
			 to_number(to_char(hc.fec_calc_plan,'mm')), 
			 hc.cod_trabajador, hc.concep, :as_tipo_retencion, :as_cod_origen, 0, 
			 sum(hc.imp_soles) 
	from historico_calculo hc, grupo_calculo gc, grupo_calculo_det gcd, maestro m 
	where hc.cod_trabajador = m.cod_trabajador 
	  AND to_char(hc.fec_calc_plan,'yyyy')= :ls_ano 
	  AND m.cod_origen = :as_cod_origen 
	  AND gc.grupo_calculo = gcd.grupo_calculo
	  AND hc.concep = gcd.concepto_calc 
	  AND gc.grupo_calculo = :ls_grp_snp 
	  AND hc.cod_trabajador in (select hcc.cod_trabajador 
	  										from historico_calculo hcc 
										  where to_char(hcc.fec_calc_plan,'yyyy')=:ls_ano and hcc.concep=:ls_retenc_snp)
	group by to_number(to_char(hc.fec_calc_plan,'yyyy')), 
				to_number(to_char(hc.fec_calc_plan,'mm')), 
				hc.cod_trabajador, hc.concep, :as_tipo_retencion, :as_cod_origen, 0
	order by hc.cod_trabajador ;
	
END IF 

// Graba datos
COMMIT using SQLCA;
end event

on w_rh389_remuneracion_retenciones.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.cbx_snp=create cbx_snp
this.cbx_afp=create cbx_afp
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
this.Control[iCurrent+1]=this.cbx_snp
this.Control[iCurrent+2]=this.cbx_afp
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.rb_regenera
this.Control[iCurrent+5]=this.rb_recupera
this.Control[iCurrent+6]=this.sle_desc_origen
this.Control[iCurrent+7]=this.em_origen
this.Control[iCurrent+8]=this.em_ano
this.Control[iCurrent+9]=this.dw_master
this.Control[iCurrent+10]=this.dw_detail
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.cb_2
this.Control[iCurrent+14]=this.gb_1
end on

on w_rh389_remuneracion_retenciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_snp)
destroy(this.cbx_afp)
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

type cbx_snp from checkbox within w_rh389_remuneracion_retenciones
integer x = 59
integer y = 280
integer width = 635
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Remuneración de SNP "
end type

type cbx_afp from checkbox within w_rh389_remuneracion_retenciones
integer x = 59
integer y = 172
integer width = 635
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Remuneración de AFP "
boolean checked = true
end type

type cb_3 from commandbutton within w_rh389_remuneracion_retenciones
integer x = 2633
integer y = 168
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

event clicked;String ls_origen, ls_flag_recupera, ls_tipo_retencion 
Integer li_ano 

IF (cbx_afp.checked = TRUE AND cbx_snp.checked = TRUE) OR &
	(cbx_afp.checked = FALSE AND cbx_snp.checked = FALSE) THEN
	MessageBox('Aviso', 'Seleccione correctamente el tipo de retención')
	Return
END IF 

IF cbx_afp.checked = TRUE THEN
	ls_tipo_retencion = 'A'
ELSE
	ls_tipo_retencion = 'S'
END IF

IF em_ano.text = '' THEN
	MessageBox('Aviso','Defina año a procesar')
	Return
END IF 
IF em_origen.text = '' THEN
	MessageBox('Aviso','Defina origen a procesar')
	Return
END IF 

li_ano = INTEGER(em_ano.text)
ls_origen = TRIM(em_origen.text)

// Limpia datawindows
dw_master.reset()
dw_detail.reset()

IF rb_regenera.checked = TRUE THEN 
	ls_flag_recupera = '1'
	Event ue_procesar(li_ano, ls_origen, ls_tipo_retencion)
END IF ;

dw_master.retrieve(li_ano, ls_tipo_retencion, ls_origen)






end event

type rb_regenera from radiobutton within w_rh389_remuneracion_retenciones
integer x = 1778
integer y = 88
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

type rb_recupera from radiobutton within w_rh389_remuneracion_retenciones
integer x = 987
integer y = 88
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

type sle_desc_origen from singlelineedit within w_rh389_remuneracion_retenciones
integer x = 1458
integer y = 276
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

type em_origen from editmask within w_rh389_remuneracion_retenciones
integer x = 1253
integer y = 276
integer width = 169
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

type em_ano from editmask within w_rh389_remuneracion_retenciones
integer x = 1253
integer y = 176
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

type dw_master from u_dw_abc within w_rh389_remuneracion_retenciones
integer x = 27
integer y = 464
integer width = 2542
integer height = 760
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_abc_lista_remun_retenc_grd"
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

event doubleclicked;call super::doubleclicked;Integer li_ano
String ls_cod_trabajador, ls_flag_tipo_retencion

IF row > 0 THEN
	li_ano = Integer(em_ano.text)
	ls_cod_trabajador = this.object.cod_trabajador[row]
	IF cbx_afp.checked=TRUE THEN
		ls_flag_tipo_retencion = 'A'
	ELSE
		ls_flag_tipo_retencion = 'S'
	END IF
	dw_detail.Retrieve(li_ano, ls_cod_trabajador, ls_flag_tipo_retencion)
END IF 

end event

type dw_detail from u_dw_abc within w_rh389_remuneracion_retenciones
integer x = 18
integer y = 1280
integer width = 3470
integer height = 708
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_abc_fmt_renum_retenc_grd"
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
this.object.cod_trabajador[al_row]=dw_master.object.cod_trabajador[dw_master.GetRow()]

IF (cbx_afp.checked = TRUE AND cbx_snp.checked = TRUE) OR &
	(cbx_afp.checked = FALSE AND cbx_snp.checked = FALSE) THEN 
	MessageBox('Aviso','Defina correctamente el tipo de retención')
	Return
END IF 

IF cbx_afp.checked = TRUE THEN
	this.Object.flag_tipo_retencion[al_row]='A'
ELSEIF cbx_snp.checked = TRUE THEN
	this.Object.flag_tipo_retencion[al_row]='S'
END IF
end event

type st_2 from statictext within w_rh389_remuneracion_retenciones
integer x = 841
integer y = 276
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

type st_1 from statictext within w_rh389_remuneracion_retenciones
integer x = 841
integer y = 180
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

type cb_2 from commandbutton within w_rh389_remuneracion_retenciones
integer x = 1115
integer y = 276
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

type gb_1 from groupbox within w_rh389_remuneracion_retenciones
integer x = 9
integer y = 36
integer width = 3008
integer height = 384
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

