$PBExportHeader$w_rh701_doc_pagar_plla.srw
forward
global type w_rh701_doc_pagar_plla from w_rpt
end type
type cb_1 from commandbutton within w_rh701_doc_pagar_plla
end type
type st_1 from statictext within w_rh701_doc_pagar_plla
end type
type cb_ttrab from commandbutton within w_rh701_doc_pagar_plla
end type
type st_2 from statictext within w_rh701_doc_pagar_plla
end type
type st_4 from statictext within w_rh701_doc_pagar_plla
end type
type em_ttrab from editmask within w_rh701_doc_pagar_plla
end type
type em_origen from editmask within w_rh701_doc_pagar_plla
end type
type cb_origen from commandbutton within w_rh701_doc_pagar_plla
end type
type em_descripcion from editmask within w_rh701_doc_pagar_plla
end type
type em_desc_ttrab from editmask within w_rh701_doc_pagar_plla
end type
type em_fec_proceso from editmask within w_rh701_doc_pagar_plla
end type
type dw_report from u_dw_rpt within w_rh701_doc_pagar_plla
end type
type gb_1 from groupbox within w_rh701_doc_pagar_plla
end type
end forward

global type w_rh701_doc_pagar_plla from w_rpt
integer width = 3735
integer height = 1860
string title = "Documentos de Pago (RH701)"
string menuname = "m_reporte"
cb_1 cb_1
st_1 st_1
cb_ttrab cb_ttrab
st_2 st_2
st_4 st_4
em_ttrab em_ttrab
em_origen em_origen
cb_origen cb_origen
em_descripcion em_descripcion
em_desc_ttrab em_desc_ttrab
em_fec_proceso em_fec_proceso
dw_report dw_report
gb_1 gb_1
end type
global w_rh701_doc_pagar_plla w_rh701_doc_pagar_plla

on w_rh701_doc_pagar_plla.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.st_1=create st_1
this.cb_ttrab=create cb_ttrab
this.st_2=create st_2
this.st_4=create st_4
this.em_ttrab=create em_ttrab
this.em_origen=create em_origen
this.cb_origen=create cb_origen
this.em_descripcion=create em_descripcion
this.em_desc_ttrab=create em_desc_ttrab
this.em_fec_proceso=create em_fec_proceso
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_ttrab
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.em_ttrab
this.Control[iCurrent+7]=this.em_origen
this.Control[iCurrent+8]=this.cb_origen
this.Control[iCurrent+9]=this.em_descripcion
this.Control[iCurrent+10]=this.em_desc_ttrab
this.Control[iCurrent+11]=this.em_fec_proceso
this.Control[iCurrent+12]=this.dw_report
this.Control[iCurrent+13]=this.gb_1
end on

on w_rh701_doc_pagar_plla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.cb_ttrab)
destroy(this.st_2)
destroy(this.st_4)
destroy(this.em_ttrab)
destroy(this.em_origen)
destroy(this.cb_origen)
destroy(this.em_descripcion)
destroy(this.em_desc_ttrab)
destroy(this.em_fec_proceso)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)

ib_preview = FALSE
THIS.Event ue_preview()



end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type cb_1 from commandbutton within w_rh701_doc_pagar_plla
integer x = 2437
integer y = 48
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reporte"
end type

event clicked;String ls_origen ,ls_tipo_trabaj
Long   ll_contador
Date	 ld_fec_proceso

ls_origen 		 = String (em_origen.text)
ls_tipo_trabaj	 = String (em_ttrab.text)
ld_fec_proceso  = Date   (em_fec_proceso.text)



select count(*) into :ll_contador 
  from origen 
 where (cod_origen  = :ls_origen ) and
 		 (flag_estado = '1'			) ;
		  
if ll_contador = 0 then
	Messagebox('Aviso','Origen No Existe ,Verifique!')
	Return
end if

select count(*) into :ll_contador 
  from tipo_trabajador
 where (tipo_trabajador = :ls_tipo_trabaj ) and
 		 (flag_estado	   = '1'					) ;

if ll_contador = 0 then
	Messagebox('Aviso','Tipo de Trabajador No Existe ,Verifique!')
	Return
end if


dw_report.retrieve(ls_origen,ls_tipo_trabaj,ld_fec_proceso)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text	= gs_empresa
dw_report.object.t_user.text 		= gs_user





end event

type st_1 from statictext within w_rh701_doc_pagar_plla
integer x = 1705
integer y = 72
integer width = 325
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "F.Proceso :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_ttrab from commandbutton within w_rh701_doc_pagar_plla
integer x = 576
integer y = 156
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
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_tiptra_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_ttrab.text      = sl_param.field_ret[1]
	em_desc_ttrab.text = sl_param.field_ret[2]
END IF

end event

type st_2 from statictext within w_rh701_doc_pagar_plla
integer x = 46
integer y = 64
integer width = 366
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_rh701_doc_pagar_plla
integer x = 46
integer y = 164
integer width = 366
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "T.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ttrab from editmask within w_rh701_doc_pagar_plla
integer x = 411
integer y = 156
integer width = 151
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh701_doc_pagar_plla
integer x = 411
integer y = 52
integer width = 151
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_origen from commandbutton within w_rh701_doc_pagar_plla
integer x = 576
integer y = 52
integer width = 87
integer height = 76
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

type em_descripcion from editmask within w_rh701_doc_pagar_plla
integer x = 677
integer y = 52
integer width = 983
integer height = 76
integer taborder = 10
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

type em_desc_ttrab from editmask within w_rh701_doc_pagar_plla
integer x = 677
integer y = 156
integer width = 983
integer height = 76
integer taborder = 10
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

type em_fec_proceso from editmask within w_rh701_doc_pagar_plla
integer x = 2039
integer y = 64
integer width = 379
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type dw_report from u_dw_rpt within w_rh701_doc_pagar_plla
integer y = 288
integer width = 2779
integer height = 1292
string dataobject = "d_rpt_pagos_planilla_tbl"
end type

type gb_1 from groupbox within w_rh701_doc_pagar_plla
integer x = 18
integer width = 3511
integer height = 268
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

