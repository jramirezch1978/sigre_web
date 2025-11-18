$PBExportHeader$w_al715_relacion_ov.srw
forward
global type w_al715_relacion_ov from w_rpt
end type
type dw_2 from datawindow within w_al715_relacion_ov
end type
type st_3 from statictext within w_al715_relacion_ov
end type
type em_hasta from editmask within w_al715_relacion_ov
end type
type dw_reporte from u_dw_rpt within w_al715_relacion_ov
end type
type cb_1 from commandbutton within w_al715_relacion_ov
end type
type em_desde from editmask within w_al715_relacion_ov
end type
type st_1 from statictext within w_al715_relacion_ov
end type
type gb_1 from groupbox within w_al715_relacion_ov
end type
end forward

global type w_al715_relacion_ov from w_rpt
integer width = 3694
integer height = 2380
string title = "Reporte Documentos Emitidos (AL715)"
string menuname = "m_impresion"
dw_2 dw_2
st_3 st_3
em_hasta em_hasta
dw_reporte dw_reporte
cb_1 cb_1
em_desde em_desde
st_1 st_1
gb_1 gb_1
end type
global w_al715_relacion_ov w_al715_relacion_ov

type variables

end variables

forward prototypes
public function boolean of_validacion_rpt ()
end prototypes

public function boolean of_validacion_rpt ();RETURN TRUE
end function

on w_al715_relacion_ov.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.dw_2=create dw_2
this.st_3=create st_3
this.em_hasta=create em_hasta
this.dw_reporte=create dw_reporte
this.cb_1=create cb_1
this.em_desde=create em_desde
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.em_hasta
this.Control[iCurrent+4]=this.dw_reporte
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.em_desde
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.gb_1
end on

on w_al715_relacion_ov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.st_3)
destroy(this.em_hasta)
destroy(this.dw_reporte)
destroy(this.cb_1)
destroy(this.em_desde)
destroy(this.st_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string  	ls_origen
Date 		ld_desde, ld_hasta

dw_2.Accepttext()

ls_origen = dw_2.object.cod_origen [1]
ld_desde =  date( em_desde.text )
ld_hasta =  date( em_hasta.text )

dw_reporte.SetTransObject(SQLCA)

dw_reporte.retrieve( ld_desde, ld_hasta, ls_origen)
	
dw_reporte.object.p_logo.filename = gs_logo
dw_reporte.object.t_nombre.text   = gs_empresa
dw_reporte.object.t_origen.text   = ls_origen
dw_reporte.object.t_fdesde.text   = string( ld_desde )
dw_reporte.object.t_fhasta.text   = string( ld_hasta )



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


end event

event resize;call super::resize;dw_reporte.width = newwidth - dw_reporte.x
dw_reporte.height = newheight - dw_reporte.y
end event

type dw_2 from datawindow within w_al715_relacion_ov
integer x = 137
integer y = 176
integer width = 1029
integer height = 88
integer taborder = 40
string title = "none"
string dataobject = "d_ext_origen_tbl"
boolean border = false
boolean livescroll = true
end type

event itemchanged;IF Getrow() = 0 THEN Return
String ls_name , ls_nombre
ls_name = dwo.name

IF dwo.name = 'cod_origen' THEN 
	select nombre
	into :ls_nombre
	from origen
	where cod_origen = :data ;
	
	Setitem(row, 'nombre', ls_nombre)
END IF

end event

event doubleclicked;IF Getrow() = 0 THEN Return
String ls_name ,ls_prot ,ls_nombre
str_seleccionar lstr_seleccionar
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
  return
end if

IF dwo.name = 'cod_origen' THEN 
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT ORIGEN.COD_ORIGEN AS COD_ORIGEN ,'&
														 +'ORIGEN.NOMBRE AS NOMBRE '&
									   				 +'FROM ORIGEN '

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_origen',lstr_seleccionar.param1[1])
					Setitem(row,'nombre',lstr_seleccionar.param2[1])
				END IF
END IF



end event

event constructor;SetTransObject(sqlca)
InsertRow(0)

end event

event itemerror;String ls_nombre
end event

type st_3 from statictext within w_al715_relacion_ov
integer x = 718
integer y = 92
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

type em_hasta from editmask within w_al715_relacion_ov
integer x = 869
integer y = 80
integer width = 361
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
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type dw_reporte from u_dw_rpt within w_al715_relacion_ov
integer y = 316
integer width = 3589
integer height = 1492
integer taborder = 0
string dataobject = "d_rpt_relacion_ov"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_1 from commandbutton within w_al715_relacion_ov
integer x = 1271
integer y = 56
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

type em_desde from editmask within w_al715_relacion_ov
integer x = 343
integer y = 80
integer width = 361
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
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type st_1 from statictext within w_al715_relacion_ov
integer x = 155
integer y = 92
integer width = 187
integer height = 64
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

type gb_1 from groupbox within w_al715_relacion_ov
integer x = 91
integer y = 28
integer width = 1175
integer height = 276
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

