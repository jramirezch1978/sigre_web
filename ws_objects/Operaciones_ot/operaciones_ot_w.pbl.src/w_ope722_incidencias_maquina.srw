$PBExportHeader$w_ope722_incidencias_maquina.srw
forward
global type w_ope722_incidencias_maquina from w_rpt
end type
type rb_res from radiobutton within w_ope722_incidencias_maquina
end type
type rb_det from radiobutton within w_ope722_incidencias_maquina
end type
type uo_1 from u_ingreso_rango_fechas within w_ope722_incidencias_maquina
end type
type cb_2 from commandbutton within w_ope722_incidencias_maquina
end type
type dw_report from u_dw_rpt within w_ope722_incidencias_maquina
end type
type gb_1 from groupbox within w_ope722_incidencias_maquina
end type
end forward

global type w_ope722_incidencias_maquina from w_rpt
integer width = 2834
integer height = 1680
string title = "Incidencias de equipos y/o maquinarias (OPE722)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
rb_res rb_res
rb_det rb_det
uo_1 uo_1
cb_2 cb_2
dw_report dw_report
gb_1 gb_1
end type
global w_ope722_incidencias_maquina w_ope722_incidencias_maquina

on w_ope722_incidencias_maquina.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.rb_res=create rb_res
this.rb_det=create rb_det
this.uo_1=create uo_1
this.cb_2=create cb_2
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_res
this.Control[iCurrent+2]=this.rb_det
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.dw_report
this.Control[iCurrent+6]=this.gb_1
end on

on w_ope722_incidencias_maquina.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_res)
destroy(this.rb_det)
destroy(this.uo_1)
destroy(this.cb_2)
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

event ue_retrieve;call super::ue_retrieve;String ls_ot
Date ld_fec_ini, ld_fec_fin

ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()

DECLARE pb_usp_ope_incidencias_maq_ot_adm PROCEDURE FOR usp_ope_incidencias_maq_ot_adm
        ( :ld_fec_ini, :ld_fec_fin ) ;
Execute pb_usp_ope_incidencias_maq_ot_adm ;

IF rb_det.checked=false and rb_res.checked=false then
	messagebox('Aviso','Seleccione una opción')
	return
end if

IF rb_det.checked=true then
	idw_1.dataobject = 'd_rpt_incidencias_maquina_ot_adm'	
else
	idw_1.dataobject = 'd_rpt_incidencias_maquina_ot_adm_resumen'	
end if 
idw_1.SettransObject(sqlca)


idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_texto.text = 'Del ' + string(ld_fec_ini,'dd/mm/yyyy') + ' al ' + string(ld_fec_fin,'dd/mm/yyyy')
idw_1.object.t_user.text = gs_user


idw_1.Retrieve()


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

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_filter();call super::ue_filter;idw_1.GroupCalc()
end event

type rb_res from radiobutton within w_ope722_incidencias_maquina
integer x = 50
integer y = 172
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
end type

type rb_det from radiobutton within w_ope722_incidencias_maquina
integer x = 50
integer y = 92
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
end type

type uo_1 from u_ingreso_rango_fechas within w_ope722_incidencias_maquina
integer x = 453
integer y = 108
integer taborder = 40
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') 
of_set_fecha(today(), today())
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_2 from commandbutton within w_ope722_incidencias_maquina
integer x = 1970
integer y = 88
integer width = 315
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type dw_report from u_dw_rpt within w_ope722_incidencias_maquina
integer y = 320
integer width = 1426
integer height = 868
string dataobject = "d_rpt_incidencias_maquina_ot_adm"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_ope722_incidencias_maquina
integer x = 18
integer y = 16
integer width = 1755
integer height = 240
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Opciones"
end type

