$PBExportHeader$w_pr760_datos_produccion_hp.srw
forward
global type w_pr760_datos_produccion_hp from w_report_smpl
end type
type st_1 from statictext within w_pr760_datos_produccion_hp
end type
type uo_rango from ou_rango_fechas within w_pr760_datos_produccion_hp
end type
type cb_proc from commandbutton within w_pr760_datos_produccion_hp
end type
type rb_1 from radiobutton within w_pr760_datos_produccion_hp
end type
type rb_2 from radiobutton within w_pr760_datos_produccion_hp
end type
end forward

global type w_pr760_datos_produccion_hp from w_report_smpl
integer width = 3995
integer height = 2052
string title = "[PR760] Datos Producción HP - Dashboard"
string menuname = "m_reporte"
event ue_query_retrieve ( )
st_1 st_1
uo_rango uo_rango
cb_proc cb_proc
rb_1 rb_1
rb_2 rb_2
end type
global w_pr760_datos_produccion_hp w_pr760_datos_produccion_hp

event ue_query_retrieve();this.event ue_retrieve()
end event

on w_pr760_datos_produccion_hp.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_1=create st_1
this.uo_rango=create uo_rango
this.cb_proc=create cb_proc
this.rb_1=create rb_1
this.rb_2=create rb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_rango
this.Control[iCurrent+3]=this.cb_proc
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
end on

on w_pr760_datos_produccion_hp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.uo_rango)
destroy(this.cb_proc)
destroy(this.rb_1)
destroy(this.rb_2)
end on

event ue_open_pre;call super::ue_open_pre;//ii_lec_mst = 0
end event

event ue_retrieve;call super::ue_retrieve;String 	ls_titulo
Date		ld_fecha1, ld_fecha2

ld_fecha1 = date(uo_rango.of_get_fecha1( ))
ld_fecha2 = date(uo_rango.of_get_fecha2( ))

if rb_1.checked then
	dw_report.dataObject = 'd_rpt_produccion_diaria_hp_tbl'
else
	dw_report.dataObject = 'd_rpt_dashboard_produccion_cmp'
end if

dw_report.settransobject( sqlca )
dw_report.retrieve(ld_fecha1, ld_fecha2 )

if rb_1.checked then
	dw_report.of_preview(false)
end if

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_user.text = gs_user
dw_report.object.t_Fecha1.text 	= string(ld_fecha1, 'dd/mm/yyyy')
dw_report.object.t_Fecha2.text 	= string(ld_fecha2, 'dd/mm/yyyy')


end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If


end event

type dw_report from w_report_smpl`dw_report within w_pr760_datos_produccion_hp
integer x = 0
integer y = 244
integer width = 3662
integer height = 1480
integer taborder = 10
string dataobject = "d_rpt_produccion_diaria_hp_tbl"
string is_dwform = ""
end type

type st_1 from statictext within w_pr760_datos_produccion_hp
integer y = 16
integer width = 494
integer height = 64
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

type uo_rango from ou_rango_fechas within w_pr760_datos_produccion_hp
integer x = 485
integer y = 4
integer taborder = 20
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type cb_proc from commandbutton within w_pr760_datos_produccion_hp
integer x = 1765
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
boolean default = true
end type

event clicked;parent.event ue_retrieve()
end event

type rb_1 from radiobutton within w_pr760_datos_produccion_hp
integer y = 132
integer width = 530
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
string text = "Datos Produccion HP"
boolean checked = true
end type

type rb_2 from radiobutton within w_pr760_datos_produccion_hp
integer x = 562
integer y = 128
integer width = 571
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
string text = "Dashboard Producción"
end type

event clicked;//'d_rpt_dashboard_produccion_cmp'
end event

