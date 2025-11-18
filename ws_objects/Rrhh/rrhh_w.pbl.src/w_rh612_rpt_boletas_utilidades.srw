$PBExportHeader$w_rh612_rpt_boletas_utilidades.srw
forward
global type w_rh612_rpt_boletas_utilidades from w_report_smpl
end type
type cb_1 from commandbutton within w_rh612_rpt_boletas_utilidades
end type
type em_periodo from editmask within w_rh612_rpt_boletas_utilidades
end type
type st_1 from statictext within w_rh612_rpt_boletas_utilidades
end type
type sle_representante_legal from singlelineedit within w_rh612_rpt_boletas_utilidades
end type
type st_2 from statictext within w_rh612_rpt_boletas_utilidades
end type
type em_item from editmask within w_rh612_rpt_boletas_utilidades
end type
type st_5 from statictext within w_rh612_rpt_boletas_utilidades
end type
type em_fec_proceso from editmask within w_rh612_rpt_boletas_utilidades
end type
type st_6 from statictext within w_rh612_rpt_boletas_utilidades
end type
type em_fec_pago from editmask within w_rh612_rpt_boletas_utilidades
end type
type em_origen from editmask within w_rh612_rpt_boletas_utilidades
end type
type cb_origen from commandbutton within w_rh612_rpt_boletas_utilidades
end type
type em_descripcion from editmask within w_rh612_rpt_boletas_utilidades
end type
type em_tipo_trabaj from editmask within w_rh612_rpt_boletas_utilidades
end type
type cb_tipo_trabaj from commandbutton within w_rh612_rpt_boletas_utilidades
end type
type em_desc_ttrab from editmask within w_rh612_rpt_boletas_utilidades
end type
type cbx_origen from checkbox within w_rh612_rpt_boletas_utilidades
end type
type cbx_tipo_trabaj from checkbox within w_rh612_rpt_boletas_utilidades
end type
type em_trabajador from editmask within w_rh612_rpt_boletas_utilidades
end type
type cb_trabajador from commandbutton within w_rh612_rpt_boletas_utilidades
end type
type em_nom_trabajador from editmask within w_rh612_rpt_boletas_utilidades
end type
type cbx_trabajador from checkbox within w_rh612_rpt_boletas_utilidades
end type
type rb_1 from radiobutton within w_rh612_rpt_boletas_utilidades
end type
type rb_2 from radiobutton within w_rh612_rpt_boletas_utilidades
end type
type gb_1 from groupbox within w_rh612_rpt_boletas_utilidades
end type
end forward

global type w_rh612_rpt_boletas_utilidades from w_report_smpl
integer width = 3552
integer height = 1900
string title = "(RH612) Boletas de Utilidades"
string menuname = "m_impresion"
cb_1 cb_1
em_periodo em_periodo
st_1 st_1
sle_representante_legal sle_representante_legal
st_2 st_2
em_item em_item
st_5 st_5
em_fec_proceso em_fec_proceso
st_6 st_6
em_fec_pago em_fec_pago
em_origen em_origen
cb_origen cb_origen
em_descripcion em_descripcion
em_tipo_trabaj em_tipo_trabaj
cb_tipo_trabaj cb_tipo_trabaj
em_desc_ttrab em_desc_ttrab
cbx_origen cbx_origen
cbx_tipo_trabaj cbx_tipo_trabaj
em_trabajador em_trabajador
cb_trabajador cb_trabajador
em_nom_trabajador em_nom_trabajador
cbx_trabajador cbx_trabajador
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_rh612_rpt_boletas_utilidades w_rh612_rpt_boletas_utilidades

on w_rh612_rpt_boletas_utilidades.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_periodo=create em_periodo
this.st_1=create st_1
this.sle_representante_legal=create sle_representante_legal
this.st_2=create st_2
this.em_item=create em_item
this.st_5=create st_5
this.em_fec_proceso=create em_fec_proceso
this.st_6=create st_6
this.em_fec_pago=create em_fec_pago
this.em_origen=create em_origen
this.cb_origen=create cb_origen
this.em_descripcion=create em_descripcion
this.em_tipo_trabaj=create em_tipo_trabaj
this.cb_tipo_trabaj=create cb_tipo_trabaj
this.em_desc_ttrab=create em_desc_ttrab
this.cbx_origen=create cbx_origen
this.cbx_tipo_trabaj=create cbx_tipo_trabaj
this.em_trabajador=create em_trabajador
this.cb_trabajador=create cb_trabajador
this.em_nom_trabajador=create em_nom_trabajador
this.cbx_trabajador=create cbx_trabajador
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_periodo
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_representante_legal
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.em_item
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.em_fec_proceso
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.em_fec_pago
this.Control[iCurrent+11]=this.em_origen
this.Control[iCurrent+12]=this.cb_origen
this.Control[iCurrent+13]=this.em_descripcion
this.Control[iCurrent+14]=this.em_tipo_trabaj
this.Control[iCurrent+15]=this.cb_tipo_trabaj
this.Control[iCurrent+16]=this.em_desc_ttrab
this.Control[iCurrent+17]=this.cbx_origen
this.Control[iCurrent+18]=this.cbx_tipo_trabaj
this.Control[iCurrent+19]=this.em_trabajador
this.Control[iCurrent+20]=this.cb_trabajador
this.Control[iCurrent+21]=this.em_nom_trabajador
this.Control[iCurrent+22]=this.cbx_trabajador
this.Control[iCurrent+23]=this.rb_1
this.Control[iCurrent+24]=this.rb_2
this.Control[iCurrent+25]=this.gb_1
end on

on w_rh612_rpt_boletas_utilidades.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_periodo)
destroy(this.st_1)
destroy(this.sle_representante_legal)
destroy(this.st_2)
destroy(this.em_item)
destroy(this.st_5)
destroy(this.em_fec_proceso)
destroy(this.st_6)
destroy(this.em_fec_pago)
destroy(this.em_origen)
destroy(this.cb_origen)
destroy(this.em_descripcion)
destroy(this.em_tipo_trabaj)
destroy(this.cb_tipo_trabaj)
destroy(this.em_desc_ttrab)
destroy(this.cbx_origen)
destroy(this.cbx_tipo_trabaj)
destroy(this.em_trabajador)
destroy(this.cb_trabajador)
destroy(this.em_nom_trabajador)
destroy(this.cbx_trabajador)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String  	ls_mensaje, ls_empresa, ls_nombre, ls_ruc, ls_origen, ls_tipo_trabaj, ls_trabajador, &
			ls_direccion1, ls_firma, ls_filtro
Integer 	li_periodo, li_item
Long		ll_count
Date 		ld_fecha_ini, ld_fecha_fin, ld_fec_proceso, ld_fec_pago

li_periodo 	= integer(em_periodo.text)
li_item 		= integer(em_item.text)

em_fec_proceso.getData(ld_fec_proceso)
em_fec_pago.getData(ld_fec_pago)

if isnull(li_periodo) or li_periodo = 0 then
	MessageBox('Aviso','Debe ingresar el periodo para emitir el reporte')
	return
end if

if isnull(li_item) or li_item = 0 then
	MessageBox('Aviso','Debe ingresar item del período', StopSign!)
	return
end if

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

if rb_1.checked then 
	ls_filtro = '1'
else
	ls_filtro = '2'
end if

SELECT count(*)
  INTO :ll_count
  FROM utl_distribucion
 WHERE periodo = :li_periodo 
   AND item = :li_item;

if ll_count = 0 then
	MessageBox('Aviso','No hay registros para distribución en el periodo indicado, por favor verifique!', StopSign!)
	return
end if

SELECT trunc(u.fecha_ini), trunc(u.fecha_fin)
  INTO :ld_fecha_ini, :ld_fecha_fin 
  FROM utl_distribucion u 
 WHERE u.periodo=:li_periodo 
   AND u.item=:li_item ;
	 
 
dw_report.object.t_periodo.text = 'Periodo ' + string(em_periodo.text) + ' - ' + string(em_item.text)+ ' - Del ' + String(ld_fecha_ini, 'dd/mm/yyyy') + ' al ' + String(ld_fecha_fin, 'dd/mm/yyyy')



SELECT nombre, ruc 
  INTO :ls_nombre, :ls_ruc 
  FROM empresa e 
 WHERE e.cod_empresa=(select g.cod_empresa from genparam g where reckey='1') ;


DECLARE USP_RH_UTL_RPT_BOL_UTILIDADES PROCEDURE FOR 
	USP_RH_UTL_RPT_BOL_UTILIDADES( :li_periodo, 
											 :li_item, 
											 :ls_origen, 
											 :ls_tipo_trabaj,
											 :ls_trabajador,
											 :ld_fec_proceso,
											 :ld_fec_pago,
											 :ls_filtro) ;
EXECUTE USP_RH_UTL_RPT_BOL_UTILIDADES ;
  
IF SQLCA.SQLCode = -1 THEN 
  ls_mensaje = SQLCA.SQLErrText
  rollback ;
  MessageBox("PROCEDURE Error USP_RH_UTL_RPT_BOL_UTILIDADES", ls_mensaje)
  return
END IF

Close USP_RH_UTL_RPT_BOL_UTILIDADES;

// Actualizando las direcciones (colocarlas en un FOR) mm
// Lima
select TRIM(o.dir_calle)
  into :ls_direccion1 
  from origen o 
where o.cod_origen=:gs_origen;

dw_report.retrieve()

dw_report.object.p_logo.filename 				= gs_logo
dw_report.object.t_empresa.text 					= TRIM(ls_nombre)
dw_report.object.t_ruc.text 						= gnvo_app.empresa.is_ruc
dw_report.object.t_representante_legal.text 	= TRIM(sle_representante_legal.text)
dw_report.object.t_direccion_1.text 			= TRIM(ls_direccion1)

// Firmas
if dw_report.of_existspicturename( "p_firma" ) then
	
	ls_firma = gnvo_app.logistica.of_get_firma_usuario(gs_inifile, "REPRESENTANTE LEGAL")
	
	if Not IsNull(ls_firma) and trim(ls_firma) <> '' then
		if FileExists(ls_firma) then
			idw_1.Object.p_firma.filename  = ls_firma
		else
			MessageBox("Error",  "El archivo " + ls_firma + " no existe. Por Favor verifique!", StopSign! )
		end if
	end if
	
	
end if


end event

type dw_report from w_report_smpl`dw_report within w_rh612_rpt_boletas_utilidades
integer x = 0
integer y = 532
integer width = 3456
integer height = 900
integer taborder = 0
string dataobject = "d_rpt_boleta_utilidad_new_tbl"
end type

type cb_1 from commandbutton within w_rh612_rpt_boletas_utilidades
integer x = 3173
integer y = 72
integer width = 315
integer height = 228
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type em_periodo from editmask within w_rh612_rpt_boletas_utilidades
integer x = 608
integer y = 52
integer width = 206
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_1 from statictext within w_rh612_rpt_boletas_utilidades
integer x = 9
integer y = 56
integer width = 567
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Periodo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_representante_legal from singlelineedit within w_rh612_rpt_boletas_utilidades
integer x = 1413
integer y = 52
integer width = 1216
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_rh612_rpt_boletas_utilidades
integer x = 955
integer y = 64
integer width = 439
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "REPRESENTANTE : "
alignment alignment = right!
boolean focusrectangle = false
end type

type em_item from editmask within w_rh612_rpt_boletas_utilidades
integer x = 818
integer y = 52
integer width = 91
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
string mask = "#"
end type

type st_5 from statictext within w_rh612_rpt_boletas_utilidades
integer x = 9
integer y = 152
integer width = 567
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Fecha Proceso :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_fec_proceso from editmask within w_rh612_rpt_boletas_utilidades
integer x = 608
integer y = 148
integer width = 398
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type st_6 from statictext within w_rh612_rpt_boletas_utilidades
integer x = 1042
integer y = 152
integer width = 352
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Fecha Pago :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_fec_pago from editmask within w_rh612_rpt_boletas_utilidades
integer x = 1413
integer y = 148
integer width = 398
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type em_origen from editmask within w_rh612_rpt_boletas_utilidades
integer x = 608
integer y = 240
integer width = 279
integer height = 76
integer taborder = 20
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

type cb_origen from commandbutton within w_rh612_rpt_boletas_utilidades
integer x = 891
integer y = 240
integer width = 87
integer height = 76
integer taborder = 30
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

type em_descripcion from editmask within w_rh612_rpt_boletas_utilidades
integer x = 987
integer y = 240
integer width = 457
integer height = 76
integer taborder = 40
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

type em_tipo_trabaj from editmask within w_rh612_rpt_boletas_utilidades
integer x = 608
integer y = 328
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

type cb_tipo_trabaj from commandbutton within w_rh612_rpt_boletas_utilidades
integer x = 891
integer y = 328
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

type em_desc_ttrab from editmask within w_rh612_rpt_boletas_utilidades
integer x = 987
integer y = 328
integer width = 1070
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

type cbx_origen from checkbox within w_rh612_rpt_boletas_utilidades
integer x = 9
integer y = 240
integer width = 567
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

type cbx_tipo_trabaj from checkbox within w_rh612_rpt_boletas_utilidades
integer x = 9
integer y = 328
integer width = 567
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

type em_trabajador from editmask within w_rh612_rpt_boletas_utilidades
integer x = 608
integer y = 416
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

type cb_trabajador from commandbutton within w_rh612_rpt_boletas_utilidades
integer x = 891
integer y = 416
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

type em_nom_trabajador from editmask within w_rh612_rpt_boletas_utilidades
integer x = 987
integer y = 416
integer width = 1070
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

type cbx_trabajador from checkbox within w_rh612_rpt_boletas_utilidades
integer x = 9
integer y = 416
integer width = 603
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

type rb_1 from radiobutton within w_rh612_rpt_boletas_utilidades
integer x = 2400
integer y = 308
integer width = 695
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Trabajador en planilla"
boolean checked = true
end type

type rb_2 from radiobutton within w_rh612_rpt_boletas_utilidades
integer x = 2400
integer y = 384
integer width = 695
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Trabajador fuera de planilla"
end type

type gb_1 from groupbox within w_rh612_rpt_boletas_utilidades
integer width = 3502
integer height = 520
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

