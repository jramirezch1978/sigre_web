$PBExportHeader$w_com712_mal_asiento_rpt.srw
forward
global type w_com712_mal_asiento_rpt from w_rpt
end type
type st_1 from statictext within w_com712_mal_asiento_rpt
end type
type em_year from editmask within w_com712_mal_asiento_rpt
end type
type pb_1 from picturebutton within w_com712_mal_asiento_rpt
end type
type sle_cuenta_desde from singlelineedit within w_com712_mal_asiento_rpt
end type
type cb_4 from commandbutton within w_com712_mal_asiento_rpt
end type
type dw_report from u_dw_rpt within w_com712_mal_asiento_rpt
end type
type gb_1 from groupbox within w_com712_mal_asiento_rpt
end type
end forward

global type w_com712_mal_asiento_rpt from w_rpt
integer width = 2080
integer height = 1840
string title = "Diferecnias entre el Documento por Pagar y su Asiento Contable (COM712) "
string menuname = "m_rpt"
long backcolor = 67108864
st_1 st_1
em_year em_year
pb_1 pb_1
sle_cuenta_desde sle_cuenta_desde
cb_4 cb_4
dw_report dw_report
gb_1 gb_1
end type
global w_com712_mal_asiento_rpt w_com712_mal_asiento_rpt

on w_com712_mal_asiento_rpt.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.st_1=create st_1
this.em_year=create em_year
this.pb_1=create pb_1
this.sle_cuenta_desde=create sle_cuenta_desde
this.cb_4=create cb_4
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_year
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.sle_cuenta_desde
this.Control[iCurrent+5]=this.cb_4
this.Control[iCurrent+6]=this.dw_report
this.Control[iCurrent+7]=this.gb_1
end on

on w_com712_mal_asiento_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.em_year)
destroy(this.pb_1)
destroy(this.sle_cuenta_desde)
destroy(this.cb_4)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event open;call super::open;IF this.of_access(gs_user, THIS.ClassName()) THEN 
	THIS.EVENT ue_open_pre()
ELSE
	CLOSE(THIS)
END IF
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
//THIS.Event ue_preview()
//This.Event ue_retrieve()

string ls_cuenta, ls_year

ls_year = string(YEAR(today()))

em_year.TEXT = ls_year


select c.cnta_ctbl
	into :ls_cuenta
from cntbl_cnta c, comedor_param a
	where c.cnta_ctbl = a.cnta_ctbl_com;
	
	sle_cuenta_desde.text = ls_cuenta
	sle_cuenta_desde.enabled = false

IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

 ii_help = 101           // help topic

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

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;string 	ls_cuenta_desde, ls_desc_cuenta, ls_year
integer 	li_ok

this.SetRedraw(false)

ls_cuenta_desde 	= String(sle_cuenta_desde.text)
ls_year     = string(em_year.text)

if IsNull(ls_cuenta_desde) then
	MessageBox('COMEDORES', 'NO HA INGRESO UNA CUENTA VALIDA',StopSign!)
	return
end if

if IsNull(ls_year) then
	MessageBox('COMEDORES', 'NO HA INGRESO UN AÑO VALIDO',StopSign!)
	return
end if


SELECT DESC_CNTA INTO :ls_desc_cuenta
FROM CNTBL_CNTA
WHERE CNTA_CTBL =:ls_cuenta_desde;

idw_1.Retrieve(ls_cuenta_desde, ls_year)
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Object.t_cuenta.text  = ls_cuenta_desde
idw_1.Object.t_desc_cuenta.text  = ls_desc_cuenta
idw_1.Object.Datawindow.Print.Orientation = '1'
//idw_1.object.t_nombre.text = gs_empresa
this.SetRedraw(true)
end event

type st_1 from statictext within w_com712_mal_asiento_rpt
integer x = 951
integer y = 56
integer width = 137
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_year from editmask within w_com712_mal_asiento_rpt
integer x = 901
integer y = 136
integer width = 233
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean autoskip = true
boolean spin = true
double increment = 1
end type

type pb_1 from picturebutton within w_com712_mal_asiento_rpt
integer x = 1536
integer y = 72
integer width = 457
integer height = 188
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
end type

event clicked;parent.event dynamic ue_retrieve()
end event

type sle_cuenta_desde from singlelineedit within w_com712_mal_asiento_rpt
integer x = 206
integer y = 136
integer width = 329
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
borderstyle borderstyle = stylelowered!
end type

type cb_4 from commandbutton within w_com712_mal_asiento_rpt
integer x = 571
integer y = 136
integer width = 87
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

Sg_parametros sl_param

sl_param.dw1 = "d_cntbl_cuentas_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_cuenta_desde.text = sl_param.field_ret[1]
END IF

end event

type dw_report from u_dw_rpt within w_com712_mal_asiento_rpt
integer x = 64
integer y = 308
integer width = 1947
integer height = 1320
string dataobject = "d_asiento_comprobante_mal_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_com712_mal_asiento_rpt
integer x = 64
integer y = 56
integer width = 800
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = " Seleccione Cuenta Contable "
end type

