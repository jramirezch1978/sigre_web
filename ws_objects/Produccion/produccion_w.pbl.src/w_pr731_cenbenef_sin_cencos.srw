$PBExportHeader$w_pr731_cenbenef_sin_cencos.srw
forward
global type w_pr731_cenbenef_sin_cencos from w_report_smpl
end type
type cb_2 from commandbutton within w_pr731_cenbenef_sin_cencos
end type
type rb_1 from radiobutton within w_pr731_cenbenef_sin_cencos
end type
type rb_2 from radiobutton within w_pr731_cenbenef_sin_cencos
end type
end forward

global type w_pr731_cenbenef_sin_cencos from w_report_smpl
integer width = 2473
integer height = 2144
string title = "Cencos Sin CentBenef / CenBenef sin Cencos(PR731)"
string menuname = "m_reporte"
long backcolor = 67108864
event ue_query_retrieve ( )
cb_2 cb_2
rb_1 rb_1
rb_2 rb_2
end type
global w_pr731_cenbenef_sin_cencos w_pr731_cenbenef_sin_cencos

event ue_query_retrieve();SetPointer(HourGlass!)
This.event ue_retrieve()
SetPointer(Arrow!)
end event

on w_pr731_cenbenef_sin_cencos.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_2=create cb_2
this.rb_1=create rb_1
this.rb_2=create rb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
end on

on w_pr731_cenbenef_sin_cencos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.rb_1)
destroy(this.rb_2)
end on

event ue_retrieve;call super::ue_retrieve;if rb_1.checked = true then
	dw_report.dataobject = 'd_rpt_contro_benef_sin_cencos_tbl'
	dw_report.settransobject(sqlca)
   idw_1.Retrieve()
	idw_1.Object.cabecera_t.text = 'Reporte de Centros de Beneficio no relacionados a ningún Centro de Costo'
else
	dw_report.dataobject = 'd_rpt_cencos_sin_centrobenef_tbl'
	dw_report.settransobject(sqlca)
   idw_1.Retrieve()
	idw_1.Object.cabecera_t.text = 'Reporte de Centros de Costo no relacionados a ningún Centro de Beneficio'
end if

idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user


end event

type dw_report from w_report_smpl`dw_report within w_pr731_cenbenef_sin_cencos
integer x = 37
integer y = 240
integer width = 2359
integer height = 1692
string dataobject = "d_rpt_contro_benef_sin_cencos_tbl"
end type

type cb_2 from commandbutton within w_pr731_cenbenef_sin_cencos
integer x = 1787
integer y = 76
integer width = 603
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar Reporte"
end type

event clicked;SetPointer(HourGlass!)
Parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type rb_1 from radiobutton within w_pr731_cenbenef_sin_cencos
integer x = 37
integer y = 56
integer width = 1573
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centros de Beneficio no relacionados a ningún cencos"
boolean checked = true
end type

type rb_2 from radiobutton within w_pr731_cenbenef_sin_cencos
integer x = 37
integer y = 136
integer width = 1573
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centros de Costo no relacionados a ningún CentroBenef"
end type

