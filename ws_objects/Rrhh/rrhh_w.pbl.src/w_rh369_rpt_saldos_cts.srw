$PBExportHeader$w_rh369_rpt_saldos_cts.srw
forward
global type w_rh369_rpt_saldos_cts from w_report_smpl
end type
type cb_1 from commandbutton within w_rh369_rpt_saldos_cts
end type
type st_1 from statictext within w_rh369_rpt_saldos_cts
end type
type em_origen from editmask within w_rh369_rpt_saldos_cts
end type
type em_tipo from editmask within w_rh369_rpt_saldos_cts
end type
type st_2 from statictext within w_rh369_rpt_saldos_cts
end type
type cb_2 from commandbutton within w_rh369_rpt_saldos_cts
end type
type cb_4 from commandbutton within w_rh369_rpt_saldos_cts
end type
type em_desc_origen from editmask within w_rh369_rpt_saldos_cts
end type
type em_desc_tipo from editmask within w_rh369_rpt_saldos_cts
end type
type st_3 from statictext within w_rh369_rpt_saldos_cts
end type
type sle_year from singlelineedit within w_rh369_rpt_saldos_cts
end type
type sle_mes from singlelineedit within w_rh369_rpt_saldos_cts
end type
type gb_2 from groupbox within w_rh369_rpt_saldos_cts
end type
end forward

global type w_rh369_rpt_saldos_cts from w_report_smpl
integer width = 3552
integer height = 1896
string title = "(RH369) Reporte de Saldos de C.T.S."
string menuname = "m_impresion"
cb_1 cb_1
st_1 st_1
em_origen em_origen
em_tipo em_tipo
st_2 st_2
cb_2 cb_2
cb_4 cb_4
em_desc_origen em_desc_origen
em_desc_tipo em_desc_tipo
st_3 st_3
sle_year sle_year
sle_mes sle_mes
gb_2 gb_2
end type
global w_rh369_rpt_saldos_cts w_rh369_rpt_saldos_cts

on w_rh369_rpt_saldos_cts.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.st_1=create st_1
this.em_origen=create em_origen
this.em_tipo=create em_tipo
this.st_2=create st_2
this.cb_2=create cb_2
this.cb_4=create cb_4
this.em_desc_origen=create em_desc_origen
this.em_desc_tipo=create em_desc_tipo
this.st_3=create st_3
this.sle_year=create sle_year
this.sle_mes=create sle_mes
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.em_tipo
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_4
this.Control[iCurrent+8]=this.em_desc_origen
this.Control[iCurrent+9]=this.em_desc_tipo
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.sle_year
this.Control[iCurrent+12]=this.sle_mes
this.Control[iCurrent+13]=this.gb_2
end on

on w_rh369_rpt_saldos_cts.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.em_origen)
destroy(this.em_tipo)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.cb_4)
destroy(this.em_desc_origen)
destroy(this.em_desc_tipo)
destroy(this.st_3)
destroy(this.sle_year)
destroy(this.sle_mes)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_mensaje, ls_tipo, ls_origen
date   	ld_fec_proceso
Long		ll_count
Integer	li_mes, li_year

ls_origen      = String (em_origen.text)
ls_tipo        = String (em_tipo.text)

li_year 	= Integer(sle_year.text)
li_mes	= Integer(sle_mes.text)

ld_fec_proceso = date('15/' + trim(string(li_mes, '00')) + '/' +  trim(string(li_year, '0000')))

If Isnull(ls_origen) or ls_origen = '' Then
	Messagebox('Aviso','Debe Ingresar Algun Origen ,Verifique!', StopSign!)
	Return
end if

If Isnull(ls_tipo) or ls_tipo = '' Then
	Messagebox('Aviso','Debe Ingresar Algun Tipo de Trabajador ,Verifique!', StopSign!)
	Return
end if

select count(*) 
  into :ll_count 
from tipo_trabajador 
where tipo_trabajador = :ls_tipo ;
			  
if ll_count = 0 then
	Messagebox('Aviso','Tipo de Trabajador ' + ls_tipo + ' No Existe ,Verifique!',StopSign!)
	Return
end if



dw_report.SetTransObject(sqlca)
dw_report.retrieve(ls_origen, ls_tipo, ld_fec_proceso)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text 	= gs_empresa
dw_report.object.t_user.text 		= gs_user


end event

type dw_report from w_report_smpl`dw_report within w_rh369_rpt_saldos_cts
integer x = 0
integer y = 392
integer width = 3506
integer height = 992
integer taborder = 40
string dataobject = "d_rh_rpt_detalle_cts_tbl"
end type

type cb_1 from commandbutton within w_rh369_rpt_saldos_cts
integer x = 2555
integer y = 76
integer width = 334
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;ib_preview = false
parent.event ue_preview()
Parent.Event ue_retrieve()
end event

type st_1 from statictext within w_rh369_rpt_saldos_cts
integer x = 50
integer y = 64
integer width = 539
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_origen from editmask within w_rh369_rpt_saldos_cts
integer x = 613
integer y = 64
integer width = 151
integer height = 80
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
maskdatatype maskdatatype = stringmask!
end type

type em_tipo from editmask within w_rh369_rpt_saldos_cts
integer x = 613
integer y = 164
integer width = 151
integer height = 80
integer taborder = 60
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
maskdatatype maskdatatype = stringmask!
end type

type st_2 from statictext within w_rh369_rpt_saldos_cts
integer x = 50
integer y = 164
integer width = 539
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "T.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_rh369_rpt_saldos_cts
integer x = 782
integer y = 164
integer width = 87
integer height = 80
integer taborder = 70
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

type cb_4 from commandbutton within w_rh369_rpt_saldos_cts
integer x = 782
integer y = 64
integer width = 87
integer height = 80
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
	em_desc_origen.text = sl_param.field_ret[2]
END IF

end event

type em_desc_origen from editmask within w_rh369_rpt_saldos_cts
integer x = 896
integer y = 64
integer width = 1143
integer height = 80
integer taborder = 30
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

type em_desc_tipo from editmask within w_rh369_rpt_saldos_cts
integer x = 896
integer y = 164
integer width = 1143
integer height = 80
integer taborder = 80
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

type st_3 from statictext within w_rh369_rpt_saldos_cts
integer x = 50
integer y = 276
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

type sle_year from singlelineedit within w_rh369_rpt_saldos_cts
integer x = 608
integer y = 264
integer width = 210
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

type sle_mes from singlelineedit within w_rh369_rpt_saldos_cts
integer x = 832
integer y = 268
integer width = 137
integer height = 76
integer taborder = 50
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

type gb_2 from groupbox within w_rh369_rpt_saldos_cts
integer width = 2935
integer height = 384
integer taborder = 10
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

