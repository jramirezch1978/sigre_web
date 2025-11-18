$PBExportHeader$w_ve714_relacion_ov.srw
forward
global type w_ve714_relacion_ov from w_rpt
end type
type uo_1 from u_ingreso_rango_fechas within w_ve714_relacion_ov
end type
type dw_2 from datawindow within w_ve714_relacion_ov
end type
type dw_reporte from u_dw_rpt within w_ve714_relacion_ov
end type
type cb_1 from commandbutton within w_ve714_relacion_ov
end type
type gb_1 from groupbox within w_ve714_relacion_ov
end type
type gb_2 from groupbox within w_ve714_relacion_ov
end type
end forward

global type w_ve714_relacion_ov from w_rpt
integer width = 2853
integer height = 816
string title = "[VE714] Reporte de Relacion de Documentos de Ordenes de Venta"
string menuname = "m_reporte"
long backcolor = 67108864
uo_1 uo_1
dw_2 dw_2
dw_reporte dw_reporte
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
end type
global w_ve714_relacion_ov w_ve714_relacion_ov

type variables

end variables

forward prototypes
public function boolean of_validacion_rpt ()
end prototypes

public function boolean of_validacion_rpt ();RETURN TRUE
end function

on w_ve714_relacion_ov.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_1=create uo_1
this.dw_2=create dw_2
this.dw_reporte=create dw_reporte
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_reporte
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.gb_2
end on

on w_ve714_relacion_ov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.dw_2)
destroy(this.dw_reporte)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string  	ls_origen
Date 		ld_desde, ld_hasta

dw_2.Accepttext()

ls_origen = dw_2.object.cod_origen [1]
ld_desde  = uo_1.of_get_fecha1()
ld_hasta  = uo_1.of_get_fecha2()

if ls_origen = '' or isnull(ls_origen) then
	messagebox('Aviso','Debe de Ingresar un Codigo de Origen')
	return
end if

dw_reporte.retrieve( ld_desde, ld_hasta, ls_origen, gs_empresa, gs_user)
	
dw_reporte.object.p_logo.filename = gs_logo

dw_reporte.visible = true

end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_reporte
idw_1.SetTransObject(sqlca)
Event ue_preview()
idw_1.visible = false
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

event resize;call super::resize;dw_reporte.width = newwidth - dw_reporte.x
dw_reporte.height = newheight - dw_reporte.y
end event

type uo_1 from u_ingreso_rango_fechas within w_ve714_relacion_ov
event destroy ( )
integer x = 69
integer y = 104
integer height = 80
integer taborder = 70
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Del:','Al:') 								//	para setear la fecha inicial
of_set_fecha(date(relativedate(today(),-1)), today()) 				// para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type dw_2 from datawindow within w_ve714_relacion_ov
integer x = 1445
integer y = 100
integer width = 928
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

type dw_reporte from u_dw_rpt within w_ve714_relacion_ov
integer x = 37
integer y = 256
integer width = 2711
integer height = 292
integer taborder = 0
string dataobject = "d_rpt_relacion_ov"
boolean hscrollbar = true
boolean vscrollbar = true
integer ii_zoom_actual = 100
end type

type cb_1 from commandbutton within w_ve714_relacion_ov
integer x = 2450
integer y = 128
integer width = 297
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

type gb_1 from groupbox within w_ve714_relacion_ov
integer x = 1426
integer y = 32
integer width = 992
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen"
end type

type gb_2 from groupbox within w_ve714_relacion_ov
integer x = 37
integer y = 32
integer width = 1358
integer height = 196
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas"
end type

