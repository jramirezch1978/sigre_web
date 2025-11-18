$PBExportHeader$w_rh603_rpt_cronograma_pagos.srw
forward
global type w_rh603_rpt_cronograma_pagos from w_report_smpl
end type
type cb_1 from commandbutton within w_rh603_rpt_cronograma_pagos
end type
type em_nombres from editmask within w_rh603_rpt_cronograma_pagos
end type
type em_codigo from editmask within w_rh603_rpt_cronograma_pagos
end type
type cb_2 from commandbutton within w_rh603_rpt_cronograma_pagos
end type
type em_fec_desde from editmask within w_rh603_rpt_cronograma_pagos
end type
type em_fec_hasta from editmask within w_rh603_rpt_cronograma_pagos
end type
type st_1 from statictext within w_rh603_rpt_cronograma_pagos
end type
type st_2 from statictext within w_rh603_rpt_cronograma_pagos
end type
type gb_2 from groupbox within w_rh603_rpt_cronograma_pagos
end type
type gb_1 from groupbox within w_rh603_rpt_cronograma_pagos
end type
end forward

global type w_rh603_rpt_cronograma_pagos from w_report_smpl
integer width = 3552
integer height = 1524
string title = "(RH603) Relación de Cronograma de Pagos"
string menuname = "m_impresion"
cb_1 cb_1
em_nombres em_nombres
em_codigo em_codigo
cb_2 cb_2
em_fec_desde em_fec_desde
em_fec_hasta em_fec_hasta
st_1 st_1
st_2 st_2
gb_2 gb_2
gb_1 gb_1
end type
global w_rh603_rpt_cronograma_pagos w_rh603_rpt_cronograma_pagos

on w_rh603_rpt_cronograma_pagos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_nombres=create em_nombres
this.em_codigo=create em_codigo
this.cb_2=create cb_2
this.em_fec_desde=create em_fec_desde
this.em_fec_hasta=create em_fec_hasta
this.st_1=create st_1
this.st_2=create st_2
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_nombres
this.Control[iCurrent+3]=this.em_codigo
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.em_fec_desde
this.Control[iCurrent+6]=this.em_fec_hasta
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_1
end on

on w_rh603_rpt_cronograma_pagos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_nombres)
destroy(this.em_codigo)
destroy(this.cb_2)
destroy(this.em_fec_desde)
destroy(this.em_fec_hasta)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string ls_codigo, ls_nombres, ls_mensaje
date   ld_fec_desde, ld_fec_hasta

ls_codigo    = string(em_codigo.text)
ls_nombres   = string(em_nombres.text)
ld_fec_desde = date(em_fec_desde.text)
ld_fec_hasta = date(em_fec_hasta.text)

if isnull(ld_fec_desde) or ld_fec_desde = date(string('01/01/1900','dd/mm/yyyy')) then
	MessageBox('Aviso','Debe ingresar fecha de inicio')
	return
end if

if isnull(ld_fec_hasta) or ld_fec_hasta = date(string('01/01/1900','dd/mm/yyyy')) then
	MessageBox('Aviso','Debe ingresar fecha final')
	return
end if

if ld_fec_desde > ld_fec_hasta then
	MessageBox('Atención','Error al digitar rango de fechas, Verifique')
	return
end if

if isnull(ls_codigo) or trim(ls_codigo) = '' then ls_codigo = '%'

dw_report.retrieve(ls_codigo, ld_fec_desde, ld_fec_hasta)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.t_fec_desde.text = string(ld_fec_desde,'dd/mm/yyyy')
dw_report.object.t_fec_hasta.text = string(ld_fec_hasta,'dd/mm/yyyy')

IF SQLCA.SQLCode = -1 THEN 
  ls_mensaje = SQLCA.SQLErrText
  rollback ;
  MessageBox("SQL error", ls_mensaje)
  MessageBox('Atención','Proceso de reporte de liquidación, Falló', Exclamation! )
END IF

end event

type dw_report from w_report_smpl`dw_report within w_rh603_rpt_cronograma_pagos
integer x = 0
integer y = 208
integer width = 3456
integer height = 1000
integer taborder = 50
string dataobject = "d_liq_rpt_cronograma_pagos_tbl"
end type

type cb_1 from commandbutton within w_rh603_rpt_cronograma_pagos
integer x = 3063
integer y = 68
integer width = 293
integer height = 76
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

type em_nombres from editmask within w_rh603_rpt_cronograma_pagos
integer x = 530
integer y = 76
integer width = 1143
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_codigo from editmask within w_rh603_rpt_cronograma_pagos
integer x = 59
integer y = 76
integer width = 315
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh603_rpt_cronograma_pagos
integer x = 407
integer y = 76
integer width = 87
integer height = 72
integer taborder = 10
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

sl_param.dw1 = "d_rpt_seleccion_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param )
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_codigo.text  = sl_param.field_ret[1]
	em_nombres.text = sl_param.field_ret[2]
END IF

end event

type em_fec_desde from editmask within w_rh603_rpt_cronograma_pagos
integer x = 2053
integer y = 72
integer width = 320
integer height = 80
integer taborder = 20
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
end type

type em_fec_hasta from editmask within w_rh603_rpt_cronograma_pagos
integer x = 2597
integer y = 72
integer width = 320
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
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type st_1 from statictext within w_rh603_rpt_cronograma_pagos
integer x = 1851
integer y = 80
integer width = 178
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Desde"
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh603_rpt_cronograma_pagos
integer x = 2418
integer y = 80
integer width = 151
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Hasta"
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_rh603_rpt_cronograma_pagos
integer width = 1728
integer height = 200
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Trabajador "
borderstyle borderstyle = stylebox!
end type

type gb_1 from groupbox within w_rh603_rpt_cronograma_pagos
integer x = 1778
integer width = 1225
integer height = 200
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Fecha de Cronograma de Pagos "
end type

