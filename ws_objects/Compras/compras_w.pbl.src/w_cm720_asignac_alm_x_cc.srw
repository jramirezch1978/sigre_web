$PBExportHeader$w_cm720_asignac_alm_x_cc.srw
forward
global type w_cm720_asignac_alm_x_cc from w_rpt
end type
type sle_moneda from singlelineedit within w_cm720_asignac_alm_x_cc
end type
type st_1 from statictext within w_cm720_asignac_alm_x_cc
end type
type sle_almacen from singlelineedit within w_cm720_asignac_alm_x_cc
end type
type st_almacen from statictext within w_cm720_asignac_alm_x_cc
end type
type st_2 from statictext within w_cm720_asignac_alm_x_cc
end type
type dw_report from u_dw_rpt within w_cm720_asignac_alm_x_cc
end type
type cb_1 from commandbutton within w_cm720_asignac_alm_x_cc
end type
end forward

global type w_cm720_asignac_alm_x_cc from w_rpt
integer x = 283
integer y = 248
integer width = 3113
integer height = 1416
string title = "[CM720] Asignacion de saldos de almacen x centro de costo"
string menuname = "m_impresion"
long backcolor = 79741120
sle_moneda sle_moneda
st_1 st_1
sle_almacen sle_almacen
st_almacen st_almacen
st_2 st_2
dw_report dw_report
cb_1 cb_1
end type
global w_cm720_asignac_alm_x_cc w_cm720_asignac_alm_x_cc

on w_cm720_asignac_alm_x_cc.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.sle_moneda=create sle_moneda
this.st_1=create st_1
this.sle_almacen=create sle_almacen
this.st_almacen=create st_almacen
this.st_2=create st_2
this.dw_report=create dw_report
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_moneda
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_almacen
this.Control[iCurrent+4]=this.st_almacen
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.dw_report
this.Control[iCurrent+7]=this.cb_1
end on

on w_cm720_asignac_alm_x_cc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_moneda)
destroy(this.st_1)
destroy(this.sle_almacen)
destroy(this.st_almacen)
destroy(this.st_2)
destroy(this.dw_report)
destroy(this.cb_1)
end on

event ue_open_pre;call super::ue_open_pre;String ls_moneda 

idw_1 = dw_report
ii_help = 101           // help topic

idw_1.SetTransObject( SQLCA )

SELECT cod_dolares INTO :ls_moneda FROM logparam WHERE reckey='1' ;

sle_moneda.text = ls_moneda
end event

event ue_retrieve();call super::ue_retrieve;dw_report.Retrieve()
dw_report.Visible = True
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_user.text     = gs_user
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_codigo.text   = dw_report.dataobject

end event

event resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y


end event

event ue_print();call super::ue_print;dw_report.EVENT ue_print()
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

type sle_moneda from singlelineedit within w_cm720_asignac_alm_x_cc
event dobleclick pbm_lbuttondblclk
integer x = 311
integer y = 156
integer width = 315
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT cod_moneda AS CODIGO_moneda, " &
		  + "descripcion AS DESCRIPCION_moneda " &
		  + "FROM moneda "  &
		  + "where flag_estado = '1'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 		 = ls_codigo
	//st_almacen.text = ls_data
end if

end event

type st_1 from statictext within w_cm720_asignac_alm_x_cc
integer x = 37
integer y = 164
integer width = 274
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda"
boolean focusrectangle = false
end type

type sle_almacen from singlelineedit within w_cm720_asignac_alm_x_cc
event dobleclick pbm_lbuttondblclk
integer x = 315
integer y = 32
integer width = 315
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
		  + "DESC_almacen AS DESCRIPCION_almacen " &
		  + "FROM almacen "  &
		  + "where flag_estado = '1'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 		 = ls_codigo
	st_almacen.text = ls_data
end if

end event

type st_almacen from statictext within w_cm720_asignac_alm_x_cc
integer x = 645
integer y = 44
integer width = 1417
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm720_asignac_alm_x_cc
integer x = 32
integer y = 44
integer width = 274
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Almacén"
boolean focusrectangle = false
end type

type dw_report from u_dw_rpt within w_cm720_asignac_alm_x_cc
integer y = 252
integer width = 2999
integer height = 900
boolean bringtotop = true
string dataobject = "d_rpt_asig_saldo_x_almacen_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_1 from commandbutton within w_cm720_asignac_alm_x_cc
integer x = 2167
integer y = 32
integer width = 302
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;string 	ls_msg, ls_almacen, ls_moneda 

ls_almacen = sle_almacen.text

if IsNull(ls_almacen) or ls_almacen = '' then
	MessageBox('Error', 'Debe especificar algun almacen')
	return
end if

ls_moneda = sle_moneda.text

if IsNull(ls_moneda) or ls_moneda = '' then
	MessageBox('Error', 'Debe especificar moneda')
	return
end if

SetPointer( hourglass!)
	
DECLARE USP_CMP_ASIG_SALDO_X_ALM PROCEDURE FOR 
		USP_CMP_ASIG_SALDO_X_ALM( :ls_almacen, 
									  	  :ls_moneda ;
EXECUTE USP_CMP_ASIG_SALDO_X_ALM;

IF SQLCA.SQLCODE = -1 THEN
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error USP_CMP_ASIG_SALDO_X_ALM", ls_msg)
	Return
END IF

CLOSE USP_CMP_ASIG_SALDO_X_ALM;
	
idw_1.Modify("DataWindow.Print.Preview=Yes")
idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
ib_preview = true

Parent.event ue_retrieve()

dw_report.object.t_texto.text   = 'Expresado en ' + ls_moneda

SetPointer(Arrow!)

end event

