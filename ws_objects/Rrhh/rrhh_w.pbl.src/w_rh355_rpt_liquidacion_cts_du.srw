$PBExportHeader$w_rh355_rpt_liquidacion_cts_du.srw
forward
global type w_rh355_rpt_liquidacion_cts_du from w_report_smpl
end type
type cb_1 from commandbutton within w_rh355_rpt_liquidacion_cts_du
end type
type st_3 from statictext within w_rh355_rpt_liquidacion_cts_du
end type
type st_4 from statictext within w_rh355_rpt_liquidacion_cts_du
end type
type sle_titulo from singlelineedit within w_rh355_rpt_liquidacion_cts_du
end type
type sle_year from singlelineedit within w_rh355_rpt_liquidacion_cts_du
end type
type sle_mes from singlelineedit within w_rh355_rpt_liquidacion_cts_du
end type
type cbx_origen from checkbox within w_rh355_rpt_liquidacion_cts_du
end type
type em_origen from editmask within w_rh355_rpt_liquidacion_cts_du
end type
type cb_origen from commandbutton within w_rh355_rpt_liquidacion_cts_du
end type
type em_descripcion from editmask within w_rh355_rpt_liquidacion_cts_du
end type
type cbx_tipo_trabaj from checkbox within w_rh355_rpt_liquidacion_cts_du
end type
type em_tipo_trabaj from editmask within w_rh355_rpt_liquidacion_cts_du
end type
type cb_tipo_trabaj from commandbutton within w_rh355_rpt_liquidacion_cts_du
end type
type em_desc_ttrab from editmask within w_rh355_rpt_liquidacion_cts_du
end type
type cbx_trabajador from checkbox within w_rh355_rpt_liquidacion_cts_du
end type
type em_trabajador from editmask within w_rh355_rpt_liquidacion_cts_du
end type
type cb_trabajador from commandbutton within w_rh355_rpt_liquidacion_cts_du
end type
type em_nom_trabajador from editmask within w_rh355_rpt_liquidacion_cts_du
end type
type gb_2 from groupbox within w_rh355_rpt_liquidacion_cts_du
end type
end forward

global type w_rh355_rpt_liquidacion_cts_du from w_report_smpl
integer width = 3497
integer height = 2232
string title = "[RH355] Carta de Liquidacion CTS"
string menuname = "m_impresion"
cb_1 cb_1
st_3 st_3
st_4 st_4
sle_titulo sle_titulo
sle_year sle_year
sle_mes sle_mes
cbx_origen cbx_origen
em_origen em_origen
cb_origen cb_origen
em_descripcion em_descripcion
cbx_tipo_trabaj cbx_tipo_trabaj
em_tipo_trabaj em_tipo_trabaj
cb_tipo_trabaj cb_tipo_trabaj
em_desc_ttrab em_desc_ttrab
cbx_trabajador cbx_trabajador
em_trabajador em_trabajador
cb_trabajador cb_trabajador
em_nom_trabajador em_nom_trabajador
gb_2 gb_2
end type
global w_rh355_rpt_liquidacion_cts_du w_rh355_rpt_liquidacion_cts_du

type variables
n_cst_rrhh invo_rrhh
end variables

on w_rh355_rpt_liquidacion_cts_du.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.sle_titulo=create sle_titulo
this.sle_year=create sle_year
this.sle_mes=create sle_mes
this.cbx_origen=create cbx_origen
this.em_origen=create em_origen
this.cb_origen=create cb_origen
this.em_descripcion=create em_descripcion
this.cbx_tipo_trabaj=create cbx_tipo_trabaj
this.em_tipo_trabaj=create em_tipo_trabaj
this.cb_tipo_trabaj=create cb_tipo_trabaj
this.em_desc_ttrab=create em_desc_ttrab
this.cbx_trabajador=create cbx_trabajador
this.em_trabajador=create em_trabajador
this.cb_trabajador=create cb_trabajador
this.em_nom_trabajador=create em_nom_trabajador
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.sle_titulo
this.Control[iCurrent+5]=this.sle_year
this.Control[iCurrent+6]=this.sle_mes
this.Control[iCurrent+7]=this.cbx_origen
this.Control[iCurrent+8]=this.em_origen
this.Control[iCurrent+9]=this.cb_origen
this.Control[iCurrent+10]=this.em_descripcion
this.Control[iCurrent+11]=this.cbx_tipo_trabaj
this.Control[iCurrent+12]=this.em_tipo_trabaj
this.Control[iCurrent+13]=this.cb_tipo_trabaj
this.Control[iCurrent+14]=this.em_desc_ttrab
this.Control[iCurrent+15]=this.cbx_trabajador
this.Control[iCurrent+16]=this.em_trabajador
this.Control[iCurrent+17]=this.cb_trabajador
this.Control[iCurrent+18]=this.em_nom_trabajador
this.Control[iCurrent+19]=this.gb_2
end on

on w_rh355_rpt_liquidacion_cts_du.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.sle_titulo)
destroy(this.sle_year)
destroy(this.sle_mes)
destroy(this.cbx_origen)
destroy(this.em_origen)
destroy(this.cb_origen)
destroy(this.em_descripcion)
destroy(this.cbx_tipo_trabaj)
destroy(this.em_tipo_trabaj)
destroy(this.cb_tipo_trabaj)
destroy(this.em_desc_ttrab)
destroy(this.cbx_trabajador)
destroy(this.em_trabajador)
destroy(this.cb_trabajador)
destroy(this.em_nom_trabajador)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;String 		ls_origen, ls_tipo_trabaj, ls_mensaje, ls_firma, ls_trabajador
Long	 		ll_count
Integer		li_year, li_mes
Date 			ld_fec_proceso
n_cst_wait	lnvo_wait

try
	SetPointer(HourGlass!)
	
	lnvo_wait = create n_cst_wait
	
	lnvo_wait.of_mensaje('Preparando Reporte de Liquidacion de CTS')
	
	li_year 	= Integer(sle_year.text)
	li_mes	= Integer(sle_mes.text)
	
	ld_fec_proceso = date('15/' + trim(string(li_mes, '00')) + '/' +  trim(string(li_year, '0000')))
	
	//Origen
	if cbx_origen.checked then
		ls_origen = '%%'
	else
		
		if IsNull(em_origen.text) or trim(em_origen.text) = '' then
			gnvo_app.of_message_error( "Debe especificar el ORIGEN. Por favor verifique!")
			em_origen.SetFocus()
			return
		end if
		
		ls_origen = trim(em_origen.text) + '%'
	
	end if
	
	//Tipo Trabajador
	if cbx_tipo_trabaj.checked then
		ls_tipo_trabaj = '%%'
	else
		
		if IsNull(em_tipo_trabaj.text) or trim(em_tipo_trabaj.text) = '' then
			gnvo_app.of_message_error( "Debe especificar el Tipo de Trabajador. Por favor verifique!")
			em_tipo_trabaj.SetFocus()
			return
		end if
		
		ls_tipo_trabaj = trim(em_tipo_trabaj.text) + '%'
	
	end if
	
	//Trabajador
	if cbx_trabajador.checked then
		ls_trabajador = '%%'
	else
		
		if IsNull(em_trabajador.text) or trim(em_trabajador.text) = '' then
			gnvo_app.of_message_error( "Debe especificar el CODIGO DE TRABAJADOR. Por favor verifique!")
			em_trabajador.SetFocus()
			return
		end if
		
		ls_trabajador = trim(em_trabajador.text) + '%'
	
	end if

	
	if UPPER(gs_empresa) = 'ADEN' then
		
		dw_report.DataObject = 'd_rpt_liquidacion_cts_aden_tbl'
		
		delete TT_RPT_DECRETO_URGENCIA;
		
		IF SQLCA.SQLCode = -1 THEN 
			ls_mensaje = SQLCA.SQLErrText
			rollback ;
			MessageBox("Error", "Error al eliminar datos de la tabla TT_RPT_DECRETO_URGENCIA. Mensaje: " &
						+ ls_mensaje, StopSign!)
			
			return
		END IF
		
		commit;
		
		DECLARE usp_rh_rpt_liquidacion_cts_du PROCEDURE FOR 
			usp_rh_rpt_liquidacion_cts_du(:ld_fec_proceso , 
													:ls_tipo_trabaj, 
													:ls_origen,
													:ls_trabajador) ;
		EXECUTE usp_rh_rpt_liquidacion_cts_du ;
		
		
		IF SQLCA.SQLCode = -1 THEN 
			ls_mensaje = SQLCA.SQLErrText
			rollback ;
			MessageBox("Error", "Error en procedimiento usp_rh_rpt_liquidacion_cts_du. Mensaje: " &
						+ ls_mensaje, StopSign!)
			
			return
		END IF
		
		CLOSE usp_rh_rpt_liquidacion_cts_du ;
		
		commit;
		
		dw_report.setTransObject(SQLCA)
	
		dw_report.retrieve()
	
	else
		dw_report.DataObject = 'd_rpt_liquidacion_cts_du_tbl'
		
		dw_report.setTransObject(SQLCA)
	
		dw_report.retrieve(ls_origen, ls_tipo_trabaj, ls_trabajador, ld_fec_proceso)
	
	end if
	
	
	
	ib_preview = false
	event ue_preview()
	
	dw_report.object.p_logo.filename   = gs_logo
	dw_report.object.t_nombre.text     = gs_empresa
	dw_report.object.t_user.text 		  = gs_user
	dw_report.object.t_tit_report.text = sle_titulo.text
	
	// Coloco la firma escaneada del representante 
	if dw_report.of_ExistsPictureName("p_firma") then
		
		ls_firma = invo_rrhh.of_get_firma_autorizado_cts(gs_inifile)
		
		if Not FileExists(ls_firma) then
			MessageBox('Error', 'No existe el archivo ' + ls_firma + ", por favor verifique!!", StopSign!)
			return
		end if
		dw_report.object.p_firma.filename  = ls_firma
		
	end if
		
	

catch(Exception ex)
	gnvo_app.of_catch_exception(ex, 'Error al generar reporte')
	
finally
	lnvo_wait.of_close()
	
	destroy lnvo_wait
	
	SetPointer(Arrow!)
end try

end event

event ue_open_pre;call super::ue_open_pre;idw_1.Visible = true
end event

event close;call super::close;destroy invo_rrhh
end event

event open;call super::open;Date ld_today

invo_rrhh = create n_cst_rrhh

ld_today = date(gnvo_app.of_fecha_Actual())

sle_year.text = string(ld_today, 'yyyy')
sle_mes.text = string(ld_today, 'mm')

end event

type dw_report from w_report_smpl`dw_report within w_rh355_rpt_liquidacion_cts_du
integer x = 0
integer y = 472
integer width = 3410
integer height = 1512
integer taborder = 50
string dataobject = "d_rpt_liquidacion_cts_du_tbl"
end type

type cb_1 from commandbutton within w_rh355_rpt_liquidacion_cts_du
integer x = 2999
integer y = 20
integer width = 421
integer height = 116
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type st_3 from statictext within w_rh355_rpt_liquidacion_cts_du
integer x = 1742
integer y = 60
integer width = 539
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Periodo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_rh355_rpt_liquidacion_cts_du
integer x = 41
integer y = 328
integer width = 576
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Titulo de Reporte : "
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_titulo from singlelineedit within w_rh355_rpt_liquidacion_cts_du
integer x = 622
integer y = 316
integer width = 2286
integer height = 80
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "DECRETO SUPREMO Nº 014-2004-TR"
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

type sle_year from singlelineedit within w_rh355_rpt_liquidacion_cts_du
integer x = 2299
integer y = 48
integer width = 210
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_rh355_rpt_liquidacion_cts_du
integer x = 2523
integer y = 48
integer width = 137
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type cbx_origen from checkbox within w_rh355_rpt_liquidacion_cts_du
integer x = 41
integer y = 52
integer width = 576
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los Origen :"
boolean checked = true
end type

event clicked;if this.checked then
	em_origen.enabled = false
	cb_origen.enabled = false
else
	em_origen.enabled = true
	cb_origen.enabled = true
end if
end event

type em_origen from editmask within w_rh355_rpt_liquidacion_cts_du
integer x = 622
integer y = 52
integer width = 279
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;string ls_data, ls_null, ls_texto
SetNull(ls_null)

ls_texto = this.text

select nombre
	into :ls_data
from origen
where cod_origen = :ls_texto
  and flag_estado = '1';

if SQLCA.SQLCode = 100 then
	Messagebox('RRHH', "CODIGO DE ORIGEN NO EXISTE O NO ESTA ACTIVO", StopSign!)
	this.text = ls_null
	em_descripcion.text = ls_null
end if

em_descripcion.text = ls_data

//parent.event ue_fecha_proceso( )

end event

type cb_origen from commandbutton within w_rh355_rpt_liquidacion_cts_du
integer x = 905
integer y = 52
integer width = 87
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql
ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
		  + "nombre AS nombre_origen " &
		  + "FROM origen " &
		  + "WHERE FLAG_ESTADO = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_origen.text = ls_codigo
	em_descripcion.text = ls_data
	//parent.event ue_fecha_proceso( )
end if

end event

type em_descripcion from editmask within w_rh355_rpt_liquidacion_cts_du
integer x = 1001
integer y = 52
integer width = 457
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cbx_tipo_trabaj from checkbox within w_rh355_rpt_liquidacion_cts_du
integer x = 41
integer y = 140
integer width = 576
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos Tipo Trabaj :"
boolean checked = true
end type

event clicked;if this.checked then
	em_tipo_trabaj.enabled = false
	cb_tipo_trabaj.enabled = false
else
	em_tipo_trabaj.enabled = true
	cb_tipo_trabaj.enabled = true
end if
end event

type em_tipo_trabaj from editmask within w_rh355_rpt_liquidacion_cts_du
integer x = 622
integer y = 140
integer width = 279
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;string ls_data, ls_tipo_trabaj, ls_origen

ls_origen = em_origen.text

if IsNull(ls_origen) or trim(ls_origen) = '' then
	gnvo_app.of_message_error("Debe especificar un origen. Por favor verifique!")
	em_origen.setFocus()
	return
end if

ls_tipo_trabaj = this.text

select desc_tipo_tra
	into :ls_data
from tipo_trabajador tt,
	  maestro			m
where m.tipo_trabajador  = tt.tipo_trabajador
  and tt.tipo_trabajador = :ls_tipo_trabaj
  and m.cod_origen		 = :ls_origen
  and tt.flag_estado 	 = '1';

if SQLCA.SQLCode = 100 then
	gnvo_app.of_message_error("TIPO DE TRABAJADOR NO EXISTE, NO ESTA ACTIVO O NO TIENE " &
									+ "TRABAJADORES ASIGNADOS A ESE ORIGEN")
	this.text = gnvo_app.is_null
	em_desc_ttrab.text = gnvo_app.is_null
	return
end if

em_desc_ttrab.text = ls_data



end event

type cb_tipo_trabaj from commandbutton within w_rh355_rpt_liquidacion_cts_du
integer x = 905
integer y = 140
integer width = 87
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_origen
Integer	li_count

if cbx_origen.checked then
	ls_origen = '%%'
else
	
	
	if IsNull(em_origen.text) or trim(em_origen.text) = '' then
		gnvo_app.of_message_error( "Debe especificar el ORIGEN. Por favor verifique!")
		em_origen.SetFocus()
		return
	end if
	
	ls_origen = trim(em_origen.text) + '%'

end if

ls_sql = "select tt.tipo_trabajador as tipo_trabajador, " &
		 + "tt.desc_tipo_tra as descripcion_tipo_trabajador " &
		 + "from tipo_trabajador tt, " &
		 + "     tipo_trabajador_user ttu " &
		 + "where tt.tipo_trabajador = ttu.tipo_trabajador " &
		 + "  and ttu.cod_usr        = '" + gs_user + "'" &
		 + "  and tt.flag_estado 	  = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_tipo_trabaj.text = ls_codigo
	em_desc_ttrab.text = ls_data
	
end if
end event

type em_desc_ttrab from editmask within w_rh355_rpt_liquidacion_cts_du
integer x = 1001
integer y = 140
integer width = 1070
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cbx_trabajador from checkbox within w_rh355_rpt_liquidacion_cts_du
integer x = 41
integer y = 228
integer width = 576
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos Trabajador :"
boolean checked = true
end type

event clicked;if this.checked then
	em_trabajador.enabled = false
	cb_trabajador.enabled = false
else
	em_trabajador.enabled = true
	cb_trabajador.enabled = true
end if
end event

type em_trabajador from editmask within w_rh355_rpt_liquidacion_cts_du
integer x = 622
integer y = 228
integer width = 279
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;string ls_data, ls_tipo_trabaj, ls_origen

ls_origen = em_origen.text

if IsNull(ls_origen) or trim(ls_origen) = '' then
	gnvo_app.of_message_error("Debe especificar un origen. Por favor verifique!")
	em_origen.setFocus()
	return
end if

ls_tipo_trabaj = this.text

select desc_tipo_tra
	into :ls_data
from tipo_trabajador tt,
	  maestro			m
where m.tipo_trabajador  = tt.tipo_trabajador
  and tt.tipo_trabajador = :ls_tipo_trabaj
  and m.cod_origen		 = :ls_origen
  and tt.flag_estado 	 = '1';

if SQLCA.SQLCode = 100 then
	gnvo_app.of_message_error("TIPO DE TRABAJADOR NO EXISTE, NO ESTA ACTIVO O NO TIENE " &
									+ "TRABAJADORES ASIGNADOS A ESE ORIGEN")
	this.text = gnvo_app.is_null
	em_desc_ttrab.text = gnvo_app.is_null
	return
end if

em_desc_ttrab.text = ls_data



end event

type cb_trabajador from commandbutton within w_rh355_rpt_liquidacion_cts_du
integer x = 905
integer y = 228
integer width = 87
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_origen, ls_tipo_trabaj
Integer	li_count

if cbx_origen.checked then
	ls_origen = '%%'
else
	
	
	if IsNull(em_origen.text) or trim(em_origen.text) = '' then
		gnvo_app.of_message_error( "Debe especificar el ORIGEN. Por favor verifique!")
		em_origen.SetFocus()
		return
	end if
	
	ls_origen = trim(em_origen.text) + '%'

end if

if cbx_tipo_trabaj.checked then
	ls_tipo_trabaj = '%%'
else
	
	
	if IsNull(em_tipo_trabaj.text) or trim(em_tipo_trabaj.text) = '' then
		gnvo_app.of_message_error( "Debe especificar el Tipo de Trabajador. Por favor verifique!")
		em_tipo_trabaj.SetFocus()
		return
	end if
	
	ls_tipo_trabaj = trim(em_tipo_trabaj.text) + '%'

end if

ls_sql = "select m.COD_TRABAJADOR as codigo_trabajador, " &
		 + "       m.NOM_TRABAJADOR as nombre_trabajador, " &
		 + "       m.NRO_DOC_IDENT_RTPS as dni " &
		 + "  from vw_pr_trabajador m " &
		 + " where m.cod_origen like '" + ls_origen + "'" &
		 + "   and m.TIPO_TRABAJADOR like '" + ls_tipo_trabaj + "' "

if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	em_trabajador.text = ls_codigo
	em_nom_trabajador.text = ls_data
	
end if
end event

type em_nom_trabajador from editmask within w_rh355_rpt_liquidacion_cts_du
integer x = 1001
integer y = 228
integer width = 1070
integer height = 76
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type gb_2 from groupbox within w_rh355_rpt_liquidacion_cts_du
integer width = 2935
integer height = 424
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Ingrese Datos"
end type

