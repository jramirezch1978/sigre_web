$PBExportHeader$w_ve722_reg_ventas_x_fec.srw
forward
global type w_ve722_reg_ventas_x_fec from w_rpt
end type
type uo_1 from u_ingreso_rango_fechas within w_ve722_reg_ventas_x_fec
end type
type dw_origen from datawindow within w_ve722_reg_ventas_x_fec
end type
type st_3 from statictext within w_ve722_reg_ventas_x_fec
end type
type dw_reporte from u_dw_rpt within w_ve722_reg_ventas_x_fec
end type
type cb_1 from commandbutton within w_ve722_reg_ventas_x_fec
end type
type gb_1 from groupbox within w_ve722_reg_ventas_x_fec
end type
end forward

global type w_ve722_reg_ventas_x_fec from w_rpt
integer width = 3511
integer height = 2208
string title = "[VE722] REPORTE DE REGISTRO DE VENTAS"
string menuname = "m_reporte"
uo_1 uo_1
dw_origen dw_origen
st_3 st_3
dw_reporte dw_reporte
cb_1 cb_1
gb_1 gb_1
end type
global w_ve722_reg_ventas_x_fec w_ve722_reg_ventas_x_fec

on w_ve722_reg_ventas_x_fec.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_1=create uo_1
this.dw_origen=create dw_origen
this.st_3=create st_3
this.dw_reporte=create dw_reporte
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.dw_origen
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.dw_reporte
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.gb_1
end on

on w_ve722_reg_ventas_x_fec.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.dw_origen)
destroy(this.st_3)
destroy(this.dw_reporte)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string ls_origen, ls_desc_origen, ls_desc_origen_rpt
Date ld_fec_ini, ld_fec_fin

ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()

// Evalua el tipo de origen selecionado
if dw_origen.GetItemString(1,'flag') = '1'  then
	ls_origen = '%'
	ls_desc_origen  = ' Todos los Origenes'
	ls_desc_origen_rpt = ls_desc_origen
else
	ls_origen =  dw_origen.GetItemString(dw_origen.getrow(),'cod_origen')
	select r.nombre into :ls_desc_origen from origen r where r.cod_origen = : ls_origen ; 	
	ls_desc_origen_rpt = ls_origen+' - '+ls_desc_origen

end if


idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
idw_1.object.t_user.text     = gs_user
idw_1.object.t_texto.text    = 'Del ' + string(ld_fec_ini) + ' al ' + string(ld_fec_fin)
idw_1.object.t_origen.text   = ls_desc_origen_rpt // Descripcion del origen

idw_1.retrieve(ld_fec_ini, ld_fec_fin, ls_origen)


end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_reporte
idw_1.Visible = true
idw_1.SetTransObject(sqlca)

dw_origen.SetTransObject(sqlca)
dw_origen.retrieve()
dw_origen.insertrow(0)

Event ue_preview()
//This.Event ue_retrieve()

// ii_help = 101           // help topic




end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

event resize;call super::resize;dw_reporte.width  = newwidth - dw_reporte.x
dw_reporte.height = newheight - dw_reporte.y
end event

type uo_1 from u_ingreso_rango_fechas within w_ve722_reg_ventas_x_fec
event destroy ( )
integer x = 64
integer y = 80
integer taborder = 50
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type dw_origen from datawindow within w_ve722_reg_ventas_x_fec
integer x = 1605
integer y = 76
integer width = 1399
integer height = 84
integer taborder = 40
string dataobject = "d_ext_origen"
boolean border = false
boolean livescroll = true
end type

event itemchanged;CHOOSE CASE GetColumnName()
	CASE 'flag'
		IF data = '1' THEN
			SetItem(1,'cod_origen','')
		END IF
END CHOOSE
end event

type st_3 from statictext within w_ve722_reg_ventas_x_fec
integer x = 1371
integer y = 84
integer width = 215
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "ORIGEN :"
boolean focusrectangle = false
end type

type dw_reporte from u_dw_rpt within w_ve722_reg_ventas_x_fec
integer y = 212
integer width = 3383
integer height = 1776
integer taborder = 0
string dataobject = "d_rpt_reg_ventas_x_fec_tbl"
end type

type cb_1 from commandbutton within w_ve722_reg_ventas_x_fec
integer x = 3095
integer y = 72
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Event ue_retrieve()
end event

type gb_1 from groupbox within w_ve722_reg_ventas_x_fec
integer x = 32
integer y = 4
integer width = 2994
integer height = 192
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Periodo  y  Selecciona Origen"
end type

