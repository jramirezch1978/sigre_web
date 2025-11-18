$PBExportHeader$w_al738_relacion_otr.srw
forward
global type w_al738_relacion_otr from w_rpt
end type
type rb_3 from radiobutton within w_al738_relacion_otr
end type
type rb_2 from radiobutton within w_al738_relacion_otr
end type
type rb_1 from radiobutton within w_al738_relacion_otr
end type
type st_3 from statictext within w_al738_relacion_otr
end type
type em_hasta from editmask within w_al738_relacion_otr
end type
type dw_reporte from u_dw_rpt within w_al738_relacion_otr
end type
type cb_1 from commandbutton within w_al738_relacion_otr
end type
type em_desde from editmask within w_al738_relacion_otr
end type
type st_1 from statictext within w_al738_relacion_otr
end type
type gb_1 from groupbox within w_al738_relacion_otr
end type
type gb_2 from groupbox within w_al738_relacion_otr
end type
end forward

global type w_al738_relacion_otr from w_rpt
integer width = 2853
integer height = 972
string title = "Relacion de Ordenes de Traslados (AL738)"
string menuname = "m_impresion"
long backcolor = 67108864
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
st_3 st_3
em_hasta em_hasta
dw_reporte dw_reporte
cb_1 cb_1
em_desde em_desde
st_1 st_1
gb_1 gb_1
gb_2 gb_2
end type
global w_al738_relacion_otr w_al738_relacion_otr

type variables

end variables

forward prototypes
public function boolean of_validacion_rpt ()
end prototypes

public function boolean of_validacion_rpt ();RETURN TRUE
end function

on w_al738_relacion_otr.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.st_3=create st_3
this.em_hasta=create em_hasta
this.dw_reporte=create dw_reporte
this.cb_1=create cb_1
this.em_desde=create em_desde
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_3
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.em_hasta
this.Control[iCurrent+6]=this.dw_reporte
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.em_desde
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_2
end on

on w_al738_relacion_otr.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.st_3)
destroy(this.em_hasta)
destroy(this.dw_reporte)
destroy(this.cb_1)
destroy(this.em_desde)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string  	ls_origen
Date 		ld_desde, ld_hasta

ld_desde =  date( em_desde.text )
ld_hasta =  date( em_hasta.text )

if rb_1.checked = true then
	dw_reporte.dataobject = 'd_rpt_relacion_otr'
elseif rb_2.checked then
	dw_reporte.dataobject = 'd_rpt_relacion_otr_res'
elseif rb_3.checked then
	dw_reporte.dataobject = 'd_rpt_relacion_otr_res_total'
end if

ib_preview = false

dw_reporte.SetTransObject(SQLCA)

dw_reporte.retrieve( ld_desde, ld_hasta, gs_empresa, gs_user)
	
dw_reporte.object.p_logo.filename = gs_logo

this.event ue_preview()

dw_reporte.visible = true
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_reporte
idw_1.Visible = false
idw_1.SetTransObject(sqlca)

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

event open;call super::open;this.em_desde.text = String( today( ) )
this.em_hasta.text = String( today( ) )


end event

event resize;call super::resize;dw_reporte.width = newwidth - dw_reporte.x
dw_reporte.height = newheight - dw_reporte.y
end event

type rb_3 from radiobutton within w_al738_relacion_otr
integer x = 1481
integer y = 100
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
end type

type rb_2 from radiobutton within w_al738_relacion_otr
integer x = 1856
integer y = 100
integer width = 489
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Resumen Articulo"
end type

type rb_1 from radiobutton within w_al738_relacion_otr
integer x = 1193
integer y = 100
integer width = 265
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Detalle"
boolean checked = true
end type

type st_3 from statictext within w_al738_relacion_otr
integer x = 594
integer y = 104
integer width = 155
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hasta:"
boolean focusrectangle = false
end type

type em_hasta from editmask within w_al738_relacion_otr
integer x = 745
integer y = 92
integer width = 311
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
string mask = "dd/mm/yyyy"
end type

type dw_reporte from u_dw_rpt within w_al738_relacion_otr
integer x = 37
integer y = 224
integer width = 2711
integer height = 484
integer taborder = 0
string dataobject = "d_rpt_relacion_otr"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_1 from commandbutton within w_al738_relacion_otr
integer x = 2414
integer y = 96
integer width = 334
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;Event ue_retrieve()
end event

type em_desde from editmask within w_al738_relacion_otr
integer x = 279
integer y = 92
integer width = 297
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
string mask = "dd/mm/yyyy"
end type

type st_1 from statictext within w_al738_relacion_otr
integer x = 96
integer y = 104
integer width = 187
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desde:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_al738_relacion_otr
integer x = 37
integer y = 28
integer width = 1102
integer height = 176
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Periodo"
end type

type gb_2 from groupbox within w_al738_relacion_otr
integer x = 1170
integer y = 32
integer width = 1211
integer height = 164
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo"
end type

