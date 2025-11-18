$PBExportHeader$w_pr750_resumen_cuadrilla.srw
forward
global type w_pr750_resumen_cuadrilla from w_abc_master_smpl
end type
type uo_rango from ou_rango_fechas within w_pr750_resumen_cuadrilla
end type
type cb_retrieve from commandbutton within w_pr750_resumen_cuadrilla
end type
type rb_1 from radiobutton within w_pr750_resumen_cuadrilla
end type
type rb_2 from radiobutton within w_pr750_resumen_cuadrilla
end type
type gb_1 from groupbox within w_pr750_resumen_cuadrilla
end type
end forward

global type w_pr750_resumen_cuadrilla from w_abc_master_smpl
integer width = 3625
integer height = 1956
string title = "[PR750] Resumen x Cuadrilla"
string menuname = "m_reporte"
windowstate windowstate = maximized!
event ue_saveas_Excel ( )
uo_rango uo_rango
cb_retrieve cb_retrieve
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_pr750_resumen_cuadrilla w_pr750_resumen_cuadrilla

event ue_saveas_Excel();string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( idw_1, ls_file )
End If
end event

on w_pr750_resumen_cuadrilla.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_rango=create uo_rango
this.cb_retrieve=create cb_retrieve
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_rango
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.gb_1
end on

on w_pr750_resumen_cuadrilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_rango)
destroy(this.cb_retrieve)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0
end event

event ue_retrieve;call super::ue_retrieve;date ld_fecha1, ld_fecha2

ld_fecha1 = uo_rango.of_get_fecha1( )
ld_fecha2 = uo_rango.of_get_fecha2( )

dw_master.Retrieve(ld_fecha1, ld_fecha2)

end event

type dw_master from w_abc_master_smpl`dw_master within w_pr750_resumen_cuadrilla
integer y = 228
integer width = 3246
integer height = 1416
string dataobject = "d_rpt_resumen_x_trab_cst"
end type

type uo_rango from ou_rango_fechas within w_pr750_resumen_cuadrilla
integer x = 46
integer y = 88
integer taborder = 40
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type cb_retrieve from commandbutton within w_pr750_resumen_cuadrilla
integer x = 2624
integer y = 44
integer width = 402
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;parent.event ue_retrieve( )
end event

type rb_1 from radiobutton within w_pr750_resumen_cuadrilla
integer x = 1545
integer y = 48
integer width = 645
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Nro de Trabajadores"
boolean checked = true
end type

type rb_2 from radiobutton within w_pr750_resumen_cuadrilla
integer x = 1545
integer y = 124
integer width = 645
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Nro de Horas"
end type

type gb_1 from groupbox within w_pr750_resumen_cuadrilla
integer width = 3067
integer height = 212
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros del Reporte"
end type

