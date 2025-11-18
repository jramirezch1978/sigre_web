$PBExportHeader$w_cn753_cntbl_rpt_datos_itf.srw
forward
global type w_cn753_cntbl_rpt_datos_itf from w_report_smpl
end type
type cb_1 from commandbutton within w_cn753_cntbl_rpt_datos_itf
end type
type rb_bancos from radiobutton within w_cn753_cntbl_rpt_datos_itf
end type
type rb_deudas from radiobutton within w_cn753_cntbl_rpt_datos_itf
end type
type rb_contabilidad from radiobutton within w_cn753_cntbl_rpt_datos_itf
end type
type rb_finanzas from radiobutton within w_cn753_cntbl_rpt_datos_itf
end type
type em_ano_proceso from editmask within w_cn753_cntbl_rpt_datos_itf
end type
type st_1 from statictext within w_cn753_cntbl_rpt_datos_itf
end type
type gb_3 from groupbox within w_cn753_cntbl_rpt_datos_itf
end type
end forward

global type w_cn753_cntbl_rpt_datos_itf from w_report_smpl
integer width = 3707
integer height = 1600
string title = "(CN753) Reporte con Movimiento para el I.T.F."
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
rb_bancos rb_bancos
rb_deudas rb_deudas
rb_contabilidad rb_contabilidad
rb_finanzas rb_finanzas
em_ano_proceso em_ano_proceso
st_1 st_1
gb_3 gb_3
end type
global w_cn753_cntbl_rpt_datos_itf w_cn753_cntbl_rpt_datos_itf

type variables
String is_opcion

end variables

on w_cn753_cntbl_rpt_datos_itf.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.rb_bancos=create rb_bancos
this.rb_deudas=create rb_deudas
this.rb_contabilidad=create rb_contabilidad
this.rb_finanzas=create rb_finanzas
this.em_ano_proceso=create em_ano_proceso
this.st_1=create st_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.rb_bancos
this.Control[iCurrent+3]=this.rb_deudas
this.Control[iCurrent+4]=this.rb_contabilidad
this.Control[iCurrent+5]=this.rb_finanzas
this.Control[iCurrent+6]=this.em_ano_proceso
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.gb_3
end on

on w_cn753_cntbl_rpt_datos_itf.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.rb_bancos)
destroy(this.rb_deudas)
destroy(this.rb_contabilidad)
destroy(this.rb_finanzas)
destroy(this.em_ano_proceso)
destroy(this.st_1)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;integer li_ano, li_nro_libro
string  ls_dato

if rb_bancos.checked = true then
	select libro_pagos
	  into :li_nro_libro
	  from finparam
	  where reckey = '1' ;
elseif rb_deudas.checked = true then
	li_nro_libro = 39 ;
elseif rb_contabilidad.checked = true then
	select libro_liquidacion
	  into :li_nro_libro
	  from finparam
	  where reckey = '1' ;
	ls_dato = 'C' ;
elseif rb_finanzas.checked = true then
	select libro_liquidacion
	  into :li_nro_libro
	  from finparam
	  where reckey = '1' ;
	ls_dato = 'F' ;
end if

li_ano  = integer(em_ano_proceso.text)

if rb_bancos.checked = false and rb_deudas.checked = false and rb_contabilidad.checked = false and rb_finanzas.checked = false then
	MessageBox('Verificar','Seleccione algunas de las opciones requeridas')	
	return 
end if

DECLARE pb_usp_cntbl_datos_para_itf PROCEDURE FOR USP_CNTBL_DATOS_PARA_ITF
        ( :li_nro_libro, :li_ano, :ls_dato ) ;
EXECUTE pb_usp_cntbl_datos_para_itf ;

dw_report.retrieve ()


end event

event ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)
idw_1.Visible = False

end event

type dw_report from w_report_smpl`dw_report within w_cn753_cntbl_rpt_datos_itf
integer x = 23
integer y = 384
integer width = 3639
integer height = 1028
integer taborder = 30
string dataobject = "d_rpt_movimiento_itf_crt"
end type

type cb_1 from commandbutton within w_cn753_cntbl_rpt_datos_itf
integer x = 2871
integer y = 160
integer width = 297
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type rb_bancos from radiobutton within w_cn753_cntbl_rpt_datos_itf
integer x = 462
integer y = 136
integer width = 613
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Egresos Bancos"
end type

type rb_deudas from radiobutton within w_cn753_cntbl_rpt_datos_itf
integer x = 462
integer y = 208
integer width = 613
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Compensación Deudas"
end type

type rb_contabilidad from radiobutton within w_cn753_cntbl_rpt_datos_itf
integer x = 1083
integer y = 136
integer width = 795
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Asiento de Diario - Contabilidad"
end type

type rb_finanzas from radiobutton within w_cn753_cntbl_rpt_datos_itf
integer x = 1083
integer y = 208
integer width = 795
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Asiento de Diario - Finanzas"
end type

type em_ano_proceso from editmask within w_cn753_cntbl_rpt_datos_itf
integer x = 2473
integer y = 160
integer width = 256
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_1 from statictext within w_cn753_cntbl_rpt_datos_itf
integer x = 2011
integer y = 176
integer width = 421
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Año de Proceso"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_3 from groupbox within w_cn753_cntbl_rpt_datos_itf
integer x = 393
integer y = 72
integer width = 1522
integer height = 236
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Seleccione Opción "
end type

