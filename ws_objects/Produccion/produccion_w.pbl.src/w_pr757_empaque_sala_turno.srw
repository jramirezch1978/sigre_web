$PBExportHeader$w_pr757_empaque_sala_turno.srw
forward
global type w_pr757_empaque_sala_turno from w_report_smpl
end type
type st_1 from statictext within w_pr757_empaque_sala_turno
end type
type uo_rango from ou_rango_fechas within w_pr757_empaque_sala_turno
end type
type cb_reporte from commandbutton within w_pr757_empaque_sala_turno
end type
type sle_sala from singlelineedit within w_pr757_empaque_sala_turno
end type
type st_desc_sala from statictext within w_pr757_empaque_sala_turno
end type
type sle_turno from singlelineedit within w_pr757_empaque_sala_turno
end type
type st_desc_turno from statictext within w_pr757_empaque_sala_turno
end type
type cbx_sala from checkbox within w_pr757_empaque_sala_turno
end type
type cbx_turno from checkbox within w_pr757_empaque_sala_turno
end type
end forward

global type w_pr757_empaque_sala_turno from w_report_smpl
integer width = 3995
integer height = 1680
string title = "[PR757] Parte de Empaque por SALA y TURNO"
string menuname = "m_reporte"
event ue_query_retrieve ( )
st_1 st_1
uo_rango uo_rango
cb_reporte cb_reporte
sle_sala sle_sala
st_desc_sala st_desc_sala
sle_turno sle_turno
st_desc_turno st_desc_turno
cbx_sala cbx_sala
cbx_turno cbx_turno
end type
global w_pr757_empaque_sala_turno w_pr757_empaque_sala_turno

event ue_query_retrieve();this.event ue_retrieve()
end event

on w_pr757_empaque_sala_turno.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_1=create st_1
this.uo_rango=create uo_rango
this.cb_reporte=create cb_reporte
this.sle_sala=create sle_sala
this.st_desc_sala=create st_desc_sala
this.sle_turno=create sle_turno
this.st_desc_turno=create st_desc_turno
this.cbx_sala=create cbx_sala
this.cbx_turno=create cbx_turno
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_rango
this.Control[iCurrent+3]=this.cb_reporte
this.Control[iCurrent+4]=this.sle_sala
this.Control[iCurrent+5]=this.st_desc_sala
this.Control[iCurrent+6]=this.sle_turno
this.Control[iCurrent+7]=this.st_desc_turno
this.Control[iCurrent+8]=this.cbx_sala
this.Control[iCurrent+9]=this.cbx_turno
end on

on w_pr757_empaque_sala_turno.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.uo_rango)
destroy(this.cb_reporte)
destroy(this.sle_sala)
destroy(this.st_desc_sala)
destroy(this.sle_turno)
destroy(this.st_desc_turno)
destroy(this.cbx_sala)
destroy(this.cbx_turno)
end on

event ue_open_pre;call super::ue_open_pre;//ii_lec_mst = 0
end event

event ue_retrieve;call super::ue_retrieve;Date		ld_fecha1, ld_fecha2
string	ls_turno, ls_sala

if cbx_sala.checked then
	ls_sala = '%%'
else
	if trim(sle_sala.text) = '' then 
		MessageBox('Error', 'Debe seleccionar una sala para obtener el reporte', StopSign!)
		sle_sala.setFocus()
		return
	end if
	ls_sala = trim(sle_sala.text) + '%'
end if

if cbx_turno.checked then
	ls_turno = '%%'
else
	if trim(sle_turno.text) = '' then 
		MessageBox('Error', 'Debe seleccionar una sala para obtener el reporte', StopSign!)
		sle_turno.setFocus()
		return
	end if
	ls_turno = trim(sle_turno.text) + '%'
end if

ld_fecha1 = date(uo_rango.of_get_fecha1( ))
ld_fecha2 = date(uo_rango.of_get_fecha2( ))

//Papel A-4 Apaisado
//this.dw_report.Object.DataWindow.Print.Paper.Size = 256 
//this.dw_report.Object.DataWindow.Print.CustomPage.Width = 297
//this.dw_report.Object.DataWindow.Print.CustomPage.Length = 210

dw_report.settransobject( sqlca )
dw_report.retrieve(ld_fecha1, ld_fecha2, ls_sala, ls_turno )

dw_report.object.p_logo.filename = gs_logo
dw_report.object.usuario_t.text = gs_user
dw_report.object.empresa_t.text = gs_empresa
dw_report.object.fecha1_t.text 	= string(ld_fecha1, 'dd/mm/yyyy')
dw_report.object.fecha2_t.text 	= string(ld_fecha2, 'dd/mm/yyyy')


end event

type dw_report from w_report_smpl`dw_report within w_pr757_empaque_sala_turno
integer x = 0
integer y = 316
integer width = 3314
integer height = 836
integer taborder = 10
string dataobject = "d_rpt_empaque_sala_turno_tbl"
string is_dwform = ""
end type

type st_1 from statictext within w_pr757_empaque_sala_turno
integer y = 24
integer width = 494
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Rango de Fechas:"
boolean focusrectangle = false
end type

type uo_rango from ou_rango_fechas within w_pr757_empaque_sala_turno
integer x = 485
integer y = 16
integer taborder = 20
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type cb_reporte from commandbutton within w_pr757_empaque_sala_turno
integer x = 2802
integer width = 434
integer height = 172
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
boolean default = true
end type

event clicked;parent.event ue_retrieve()
end event

type sle_sala from singlelineedit within w_pr757_empaque_sala_turno
event ue_doubleclick pbm_lbuttondblclk
integer x = 805
integer y = 128
integer width = 288
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_doubleclick;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_desc

ls_sql = "select distinct " &
		 + "		  tle.lugar_empaque as lugar_empaque, " &
		 + "		  tle.desc_sala as desc_lugar_empaque " &
		 + "from tg_lugar_empaque tle, " &
		 + "     tg_parte_empaque te " &
		 + "where tle.lugar_empaque = te.lugar_empaque " &
		 + "  and te.flag_estado <> '0'     " 		
			 
if not gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then return

this.text = ls_codigo
st_desc_sala.text = ls_data

  



end event

event modified;//string ls_desc, ls_cod
//
//ls_cod = this.text
//
//select nombre
//	into :ls_desc
//from origen
//where cod_origen = :ls_cod
//  and flag_estado = '1';
// 
//if SQLCA.SQLCode = 100 then
//	MessageBox('Aviso', 'Origen no existe o no esta activo')
//	this.text = ''
//	st_1.text = ''
//	return
//end if
//
//st_1.text = ls_desc
end event

type st_desc_sala from statictext within w_pr757_empaque_sala_turno
integer x = 1102
integer y = 128
integer width = 1097
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_turno from singlelineedit within w_pr757_empaque_sala_turno
event ue_doubleclick pbm_lbuttondblclk
integer x = 805
integer y = 216
integer width = 288
integer height = 84
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_doubleclick;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_desc

ls_sql = "select distinct " &
		 + "       tu.turno as turno, " &
		 + "		  tu.descripcion as desc_turno " &
		 + "from tg_parte_empaque te, " &
		 + "     turno            tu " &
		 + "where te.turno = tu.turno " &
		 + "  and te.flag_estado <> '0' " 		
			 
if not gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then return

this.text 				= ls_codigo
st_desc_turno.text 	= ls_data

  



end event

event modified;//string ls_desc, ls_cod
//
//ls_cod = this.text
//
//select nombre
//	into :ls_desc
//from origen
//where cod_origen = :ls_cod
//  and flag_estado = '1';
// 
//if SQLCA.SQLCode = 100 then
//	MessageBox('Aviso', 'Origen no existe o no esta activo')
//	this.text = ''
//	st_1.text = ''
//	return
//end if
//
//st_1.text = ls_desc
end event

type st_desc_turno from statictext within w_pr757_empaque_sala_turno
integer x = 1102
integer y = 216
integer width = 1097
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cbx_sala from checkbox within w_pr757_empaque_sala_turno
integer y = 132
integer width = 782
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos lugares de empaque"
boolean checked = true
end type

event clicked;if this.checked then
	sle_sala.enabled = false
else
	sle_sala.enabled = true
end if
end event

type cbx_turno from checkbox within w_pr757_empaque_sala_turno
integer y = 224
integer width = 782
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos los turnos"
boolean checked = true
end type

event clicked;if this.checked then
	sle_turno.enabled = false
else
	sle_turno.enabled = true
end if
end event

