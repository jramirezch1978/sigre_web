$PBExportHeader$w_rh631_rpt_consol_afpnet.srw
forward
global type w_rh631_rpt_consol_afpnet from w_rpt
end type
type dw_origen from u_dw_abc within w_rh631_rpt_consol_afpnet
end type
type st_4 from statictext within w_rh631_rpt_consol_afpnet
end type
type ddlb_mes from dropdownlistbox within w_rh631_rpt_consol_afpnet
end type
type em_ano from editmask within w_rh631_rpt_consol_afpnet
end type
type st_3 from statictext within w_rh631_rpt_consol_afpnet
end type
type cb_1 from commandbutton within w_rh631_rpt_consol_afpnet
end type
type dw_report from u_dw_rpt within w_rh631_rpt_consol_afpnet
end type
end forward

global type w_rh631_rpt_consol_afpnet from w_rpt
integer width = 3026
integer height = 2300
string title = "(RH631) Consolidado de Documentos para AFPNet"
string menuname = "m_reporte"
long backcolor = 67108864
dw_origen dw_origen
st_4 st_4
ddlb_mes ddlb_mes
em_ano em_ano
st_3 st_3
cb_1 cb_1
dw_report dw_report
end type
global w_rh631_rpt_consol_afpnet w_rh631_rpt_consol_afpnet

type variables
string is_cod_origen
end variables

forward prototypes
public function boolean of_verificar ()
end prototypes

public function boolean of_verificar ();// Verifica que no falten parametros para el reporte

long 		ll_i
String 	ls_separador
boolean	lb_ok

is_cod_origen = ''
ls_separador  = ''
lb_ok			  = True

// leer el dw_origen con los origenes seleccionados

For ll_i = 1 To dw_origen.RowCount()
	If dw_origen.Object.Chec[ll_i] = '1' Then
		if is_cod_origen <>'' THEN ls_separador = ', '
		is_cod_origen = is_cod_origen + ls_separador + dw_origen.Object.cod_origen[ll_i]
	end if
Next

IF LEN(is_cod_origen) = 0 THEN
	messagebox('Error', 'Debe seleccionar al menos un origen para el Reporte')
	return lb_ok = False
END IF

RETURN lb_ok



end function

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

ib_preview = FALSE

THIS.Event ue_preview()

dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text     = gs_user
dw_report.object.t_name.text	   = this.classname( )

dw_origen.SettransObject( sqlca )
dw_origen.Retrieve( )

em_ano.text = string(f_fecha_Actual(),'yyyy')
ddlb_mes.text = string(f_fecha_Actual(),'mm')


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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_rh631_rpt_consol_afpnet.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.dw_origen=create dw_origen
this.st_4=create st_4
this.ddlb_mes=create ddlb_mes
this.em_ano=create em_ano
this.st_3=create st_3
this.cb_1=create cb_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_origen
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.ddlb_mes
this.Control[iCurrent+4]=this.em_ano
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.dw_report
end on

on w_rh631_rpt_consol_afpnet.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_origen)
destroy(this.st_4)
destroy(this.ddlb_mes)
destroy(this.em_ano)
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.dw_report)
end on

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;integer li_year, li_mes

IF NOT of_verificar() THEN RETURN

idw_1.SetRedraw(false)

if em_ano.text = '' then
	MessageBox('Error', 'Debe ingresar un año')
	em_ano.setfocus( )
	return
end if

if ddlb_mes.text = '' then
	MessageBox('Error', 'Debe ingresar un mes')
	ddlb_mes.setfocus( )
	return
end if

li_year = integer(em_ano.text)
li_mes = integer(mid(ddlb_mes.text,1,2))

// Recuperar y mostrar datos
idw_1.Retrieve(li_year, li_mes, is_cod_origen )
idw_1.Visible = True
idw_1.SetRedraw(true)
end event

type dw_origen from u_dw_abc within w_rh631_rpt_consol_afpnet
integer width = 1019
integer height = 348
string dataobject = "d_origenes_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type st_4 from statictext within w_rh631_rpt_consol_afpnet
integer x = 1129
integer y = 132
integer width = 183
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "MES:"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_mes from dropdownlistbox within w_rh631_rpt_consol_afpnet
integer x = 1326
integer y = 124
integer width = 517
integer height = 856
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Julio","08 - Agosto","09 - Setiembre","10 - Octubre","11 - Noviembre","12 - Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type em_ano from editmask within w_rh631_rpt_consol_afpnet
integer x = 1330
integer y = 16
integer width = 174
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
maskdatatype maskdatatype = datemask!
string mask = "yyyy"
end type

type st_3 from statictext within w_rh631_rpt_consol_afpnet
integer x = 1138
integer y = 24
integer width = 183
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "AÑO:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_rh631_rpt_consol_afpnet
integer x = 1920
integer y = 116
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;parent.event ue_retrieve( )

end event

type dw_report from u_dw_rpt within w_rh631_rpt_consol_afpnet
integer y = 376
integer width = 2094
integer height = 1088
string dataobject = "d_rpt_documentos_afpnet_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

