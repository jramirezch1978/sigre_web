$PBExportHeader$w_rh336_rpt_boletas_pago_trabajador.srw
forward
global type w_rh336_rpt_boletas_pago_trabajador from w_report_smpl
end type
type cb_3 from commandbutton within w_rh336_rpt_boletas_pago_trabajador
end type
type em_descripcion from editmask within w_rh336_rpt_boletas_pago_trabajador
end type
type em_origen from editmask within w_rh336_rpt_boletas_pago_trabajador
end type
type em_desc_tipo from editmask within w_rh336_rpt_boletas_pago_trabajador
end type
type em_tipo from editmask within w_rh336_rpt_boletas_pago_trabajador
end type
type cb_2 from commandbutton within w_rh336_rpt_boletas_pago_trabajador
end type
type cb_1 from commandbutton within w_rh336_rpt_boletas_pago_trabajador
end type
type rb_1 from radiobutton within w_rh336_rpt_boletas_pago_trabajador
end type
type rb_2 from radiobutton within w_rh336_rpt_boletas_pago_trabajador
end type
type em_fecha from editmask within w_rh336_rpt_boletas_pago_trabajador
end type
type st_1 from statictext within w_rh336_rpt_boletas_pago_trabajador
end type
type sle_codigo from singlelineedit within w_rh336_rpt_boletas_pago_trabajador
end type
type sle_nombres from singlelineedit within w_rh336_rpt_boletas_pago_trabajador
end type
type cb_4 from commandbutton within w_rh336_rpt_boletas_pago_trabajador
end type
type gb_2 from groupbox within w_rh336_rpt_boletas_pago_trabajador
end type
type gb_3 from groupbox within w_rh336_rpt_boletas_pago_trabajador
end type
type gb_1 from groupbox within w_rh336_rpt_boletas_pago_trabajador
end type
type gb_4 from groupbox within w_rh336_rpt_boletas_pago_trabajador
end type
end forward

global type w_rh336_rpt_boletas_pago_trabajador from w_report_smpl
integer width = 4430
integer height = 1500
string title = "(RH336) Boletas de Pago por Trabajador"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
cb_1 cb_1
rb_1 rb_1
rb_2 rb_2
em_fecha em_fecha
st_1 st_1
sle_codigo sle_codigo
sle_nombres sle_nombres
cb_4 cb_4
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
gb_4 gb_4
end type
global w_rh336_rpt_boletas_pago_trabajador w_rh336_rpt_boletas_pago_trabajador

on w_rh336_rpt_boletas_pago_trabajador.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.em_desc_tipo=create em_desc_tipo
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.cb_1=create cb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.em_fecha=create em_fecha
this.st_1=create st_1
this.sle_codigo=create sle_codigo
this.sle_nombres=create sle_nombres
this.cb_4=create cb_4
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.em_desc_tipo
this.Control[iCurrent+5]=this.em_tipo
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.rb_2
this.Control[iCurrent+10]=this.em_fecha
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.sle_codigo
this.Control[iCurrent+13]=this.sle_nombres
this.Control[iCurrent+14]=this.cb_4
this.Control[iCurrent+15]=this.gb_2
this.Control[iCurrent+16]=this.gb_3
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_4
end on

on w_rh336_rpt_boletas_pago_trabajador.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.em_fecha)
destroy(this.st_1)
destroy(this.sle_codigo)
destroy(this.sle_nombres)
destroy(this.cb_4)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.gb_4)
end on

event ue_retrieve;call super::ue_retrieve;string ls_codigo, ls_tabla, ls_origen, ls_tiptra, ls_descripcion
date ld_fecha

ls_origen = string(em_origen.text)
ls_codigo = string(sle_codigo.text)
ld_fecha = date(em_fecha.text)
ls_tiptra = string(em_tipo.text)
ls_descripcion = string(em_desc_tipo.text)

if rb_1.checked = true then
	ls_tabla = '1'
elseif rb_2.checked = true then
	ls_tabla = '2'
end if

DECLARE pb_usp_rh_rpt_boleta_pago_trab PROCEDURE FOR USP_RH_RPT_BOLETA_PAGO_TRAB
        ( :ls_codigo, :ld_fecha, :ls_tabla, :ls_tiptra, :ls_origen ) ;
EXECUTE pb_usp_rh_rpt_boleta_pago_trab ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.p_logo1.filename = gs_logo
dw_report.object.st_sit.text = ls_descripcion
dw_report.object.st_sit1.text = ls_descripcion

end event

type dw_report from w_report_smpl`dw_report within w_rh336_rpt_boletas_pago_trabajador
integer x = 0
integer y = 380
integer width = 3369
integer height = 764
integer taborder = 60
string dataobject = "d_rpt_boleta_pago_tbl"
end type

type cb_3 from commandbutton within w_rh336_rpt_boletas_pago_trabajador
integer x = 960
integer y = 64
integer width = 87
integer height = 68
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
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
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type em_descripcion from editmask within w_rh336_rpt_boletas_pago_trabajador
integer x = 1083
integer y = 72
integer width = 718
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh336_rpt_boletas_pago_trabajador
integer x = 846
integer y = 72
integer width = 96
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
alignment alignment = center!
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type em_desc_tipo from editmask within w_rh336_rpt_boletas_pago_trabajador
integer x = 1609
integer y = 264
integer width = 667
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type em_tipo from editmask within w_rh336_rpt_boletas_pago_trabajador
integer x = 1312
integer y = 264
integer width = 151
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
alignment alignment = center!
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh336_rpt_boletas_pago_trabajador
integer x = 1481
integer y = 256
integer width = 87
integer height = 68
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_tiptra_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_tiptra, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_tipo.text      = sl_param.field_ret[1]
	em_desc_tipo.text = sl_param.field_ret[2]
END IF

end event

type cb_1 from commandbutton within w_rh336_rpt_boletas_pago_trabajador
integer x = 2373
integer y = 252
integer width = 293
integer height = 76
integer taborder = 50
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

type rb_1 from radiobutton within w_rh336_rpt_boletas_pago_trabajador
integer x = 59
integer y = 64
integer width = 658
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = "Boleta Mensual"
end type

type rb_2 from radiobutton within w_rh336_rpt_boletas_pago_trabajador
integer x = 59
integer y = 132
integer width = 658
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = "Boleta Meses Anteriores"
end type

type em_fecha from editmask within w_rh336_rpt_boletas_pago_trabajador
integer x = 869
integer y = 264
integer width = 343
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 12632256
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type st_1 from statictext within w_rh336_rpt_boletas_pago_trabajador
integer x = 818
integer y = 192
integer width = 439
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 79741120
string text = "Fecha de Proceso"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_codigo from singlelineedit within w_rh336_rpt_boletas_pago_trabajador
integer x = 1952
integer y = 76
integer width = 247
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
boolean displayonly = true
end type

type sle_nombres from singlelineedit within w_rh336_rpt_boletas_pago_trabajador
integer x = 2373
integer y = 76
integer width = 1061
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
boolean displayonly = true
end type

type cb_4 from commandbutton within w_rh336_rpt_boletas_pago_trabajador
integer x = 2231
integer y = 68
integer width = 87
integer height = 68
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_rpt_select_codigo_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_codigo.text  = sl_param.field_ret[1]
	sle_nombres.text = sl_param.field_ret[2]
END IF

end event

type gb_2 from groupbox within w_rh336_rpt_boletas_pago_trabajador
integer x = 795
integer width = 1056
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_3 from groupbox within w_rh336_rpt_boletas_pago_trabajador
integer x = 1266
integer y = 192
integer width = 1056
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Tipo de Trabajador "
end type

type gb_1 from groupbox within w_rh336_rpt_boletas_pago_trabajador
integer width = 782
integer height = 228
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Opción "
end type

type gb_4 from groupbox within w_rh336_rpt_boletas_pago_trabajador
integer x = 1865
integer width = 1614
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Trabajador "
end type

