$PBExportHeader$w_fi706_comprob_egreso.srw
forward
global type w_fi706_comprob_egreso from w_rpt
end type
type em_origen from editmask within w_fi706_comprob_egreso
end type
type st_2 from statictext within w_fi706_comprob_egreso
end type
type st_3 from statictext within w_fi706_comprob_egreso
end type
type em_hasta from editmask within w_fi706_comprob_egreso
end type
type dw_reporte from u_dw_rpt within w_fi706_comprob_egreso
end type
type cb_1 from commandbutton within w_fi706_comprob_egreso
end type
type em_desde from editmask within w_fi706_comprob_egreso
end type
type st_1 from statictext within w_fi706_comprob_egreso
end type
type gb_1 from groupbox within w_fi706_comprob_egreso
end type
end forward

global type w_fi706_comprob_egreso from w_rpt
integer width = 3657
integer height = 2208
string title = "Reporte de comprobantes de egreso (FI306)"
string menuname = "m_reporte"
long backcolor = 12632256
em_origen em_origen
st_2 st_2
st_3 st_3
em_hasta em_hasta
dw_reporte dw_reporte
cb_1 cb_1
em_desde em_desde
st_1 st_1
gb_1 gb_1
end type
global w_fi706_comprob_egreso w_fi706_comprob_egreso

type variables

end variables

forward prototypes
public function boolean of_validacion_rpt ()
end prototypes

public function boolean of_validacion_rpt ();RETURN TRUE
end function

on w_fi706_comprob_egreso.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.em_origen=create em_origen
this.st_2=create st_2
this.st_3=create st_3
this.em_hasta=create em_hasta
this.dw_reporte=create dw_reporte
this.cb_1=create cb_1
this.em_desde=create em_desde
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_origen
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.em_hasta
this.Control[iCurrent+5]=this.dw_reporte
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.em_desde
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.gb_1
end on

on w_fi706_comprob_egreso.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_origen)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.em_hasta)
destroy(this.dw_reporte)
destroy(this.cb_1)
destroy(this.em_desde)
destroy(this.st_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string  ls_origen, ls_doc_ce
Date ldt_desde, ldt_hasta

select comprobante_egr into :ls_doc_ce from finparam where reckey='1' ;

ls_origen = Upper(em_origen.text)
ldt_desde =  date( em_desde.text)
ldt_hasta =  date( em_hasta.text )

dw_reporte.SetTransObject(SQLCA)
	
dw_reporte.object.p_logo.filename = gs_logo
dw_reporte.object.t_nombre.text   = gs_empresa
dw_reporte.object.t_origen.text   = ls_origen
dw_reporte.object.t_texto.text   = 'Del ' + string( ldt_desde) + ' al ' + string( ldt_hasta)
dw_reporte.retrieve( String(ldt_desde,'yyyymmdd'),String(ldt_hasta,'yyyymmdd'), ls_doc_ce, ls_origen)

end event

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_reporte
idw_1.Visible = true
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
this.em_origen.text = 'PR'

end event

event resize;call super::resize;dw_reporte.width = newwidth - dw_reporte.x
dw_reporte.height = newheight - dw_reporte.y
end event

type em_origen from editmask within w_fi706_comprob_egreso
integer x = 329
integer y = 238
integer width = 280
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "XX"
end type

type st_2 from statictext within w_fi706_comprob_egreso
integer x = 110
integer y = 256
integer width = 206
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
boolean focusrectangle = false
end type

type st_3 from statictext within w_fi706_comprob_egreso
integer x = 658
integer y = 160
integer width = 155
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hasta:"
boolean focusrectangle = false
end type

type em_hasta from editmask within w_fi706_comprob_egreso
integer x = 841
integer y = 128
integer width = 311
integer height = 88
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

type dw_reporte from u_dw_rpt within w_fi706_comprob_egreso
integer x = 37
integer y = 416
integer width = 3584
integer height = 1504
integer taborder = 0
string dataobject = "d_cns_comp_egreso"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_1 from commandbutton within w_fi706_comprob_egreso
integer x = 1499
integer y = 64
integer width = 343
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

event clicked;Event ue_retrieve()
end event

type em_desde from editmask within w_fi706_comprob_egreso
integer x = 329
integer y = 128
integer width = 297
integer height = 88
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

type st_1 from statictext within w_fi706_comprob_egreso
integer x = 110
integer y = 160
integer width = 187
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desde:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_fi706_comprob_egreso
integer x = 37
integer y = 32
integer width = 1390
integer height = 320
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

