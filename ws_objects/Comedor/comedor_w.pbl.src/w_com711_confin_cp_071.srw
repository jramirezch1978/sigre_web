$PBExportHeader$w_com711_confin_cp_071.srw
forward
global type w_com711_confin_cp_071 from w_rpt
end type
type em_origen from singlelineedit within w_com711_confin_cp_071
end type
type em_descripcion from editmask within w_com711_confin_cp_071
end type
type st_1 from statictext within w_com711_confin_cp_071
end type
type em_year from editmask within w_com711_confin_cp_071
end type
type pb_1 from picturebutton within w_com711_confin_cp_071
end type
type sle_confin from singlelineedit within w_com711_confin_cp_071
end type
type cb_4 from commandbutton within w_com711_confin_cp_071
end type
type dw_report from u_dw_rpt within w_com711_confin_cp_071
end type
type gb_1 from groupbox within w_com711_confin_cp_071
end type
type gb_2 from groupbox within w_com711_confin_cp_071
end type
end forward

global type w_com711_confin_cp_071 from w_rpt
integer width = 2670
integer height = 1596
string title = "Documentos Provisionados con un confin diferente al de comedores(COM711) "
string menuname = "m_rpt"
long backcolor = 134217750
em_origen em_origen
em_descripcion em_descripcion
st_1 st_1
em_year em_year
pb_1 pb_1
sle_confin sle_confin
cb_4 cb_4
dw_report dw_report
gb_1 gb_1
gb_2 gb_2
end type
global w_com711_confin_cp_071 w_com711_confin_cp_071

on w_com711_confin_cp_071.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.st_1=create st_1
this.em_year=create em_year
this.pb_1=create pb_1
this.sle_confin=create sle_confin
this.cb_4=create cb_4
this.dw_report=create dw_report
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_origen
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.em_year
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.sle_confin
this.Control[iCurrent+7]=this.cb_4
this.Control[iCurrent+8]=this.dw_report
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
end on

on w_com711_confin_cp_071.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.st_1)
destroy(this.em_year)
destroy(this.pb_1)
destroy(this.sle_confin)
destroy(this.cb_4)
destroy(this.dw_report)
destroy(this.gb_1)
destroy(this.gb_2)
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

string ls_confin

string ls_cuenta, ls_year

ls_year = string(YEAR(today()))

em_year.TEXT = ls_year


select s.confin
	into :ls_confin
from concepto_financiero s, comedor_param c
	where s.confin = c.confin_com;
	
	sle_confin.text = ls_confin
	sle_confin.enabled = false

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

event ue_retrieve;call super::ue_retrieve;string 	ls_confin, ls_desc_confin, ls_year, ls_origen
integer 	li_ok

this.SetRedraw(false)

ls_confin 	= String(sle_confin.text)
ls_origen   = em_origen.text
ls_year     = string(em_year.text)

if IsNull(ls_confin) then
	MessageBox('COMEDORES', 'NO HA INGRESO UN CONCEPTO FINANCIERO VÁLIDO',StopSign!)
	return
end if

if IsNull(ls_year) then
	MessageBox('COMEDORES', 'NO HA INGRESO UN AÑO VALIDO',StopSign!)
	return
end if

if ls_origen = '' or IsNull( ls_origen) then
	MessageBox('COMEDORES', 'EL ORIGEN NO ESTA DEFINIDO', StopSign!)
	return
end if

SELECT DESCRIPCION INTO :ls_desc_confin
FROM CONCEPTO_FINANCIERO
WHERE CONFIN =:ls_confin;

idw_1.Retrieve(ls_year, ls_confin, ls_origen)
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Object.t_confin.text  = ls_confin
idw_1.Object.t_desc_confin.text  = ls_desc_confin
//idw_1.Object.Datawindow.Print.Orientation = '1'
//idw_1.object.t_nombre.text = gs_empresa
this.SetRedraw(true)
end event

type em_origen from singlelineedit within w_com711_confin_cp_071
event dobleclick pbm_lbuttondblclk
integer x = 695
integer y = 124
integer width = 128
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  cod_origen as codigo, " & 
		  +"nombre AS DESCRIPCION " &
		  + "FROM origen " &
		  + "WHERE flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

event modified;String 	ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
	return
end if

SELECT nombre INTO :ls_desc
FROM origen
WHERE cod_origen =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe')
	return
end if

em_descripcion.text = ls_desc

end event

type em_descripcion from editmask within w_com711_confin_cp_071
integer x = 832
integer y = 124
integer width = 663
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_1 from statictext within w_com711_confin_cp_071
integer x = 1582
integer y = 124
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

type em_year from editmask within w_com711_confin_cp_071
integer x = 1746
integer y = 124
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

type pb_1 from picturebutton within w_com711_confin_cp_071
integer x = 2130
integer y = 56
integer width = 457
integer height = 188
integer taborder = 20
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

type sle_confin from singlelineedit within w_com711_confin_cp_071
integer x = 146
integer y = 124
integer width = 247
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
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type cb_4 from commandbutton within w_com711_confin_cp_071
integer x = 411
integer y = 124
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

sl_param.dw1 = "d_concepto_financiero_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_confin.text = sl_param.field_ret[1]
END IF

end event

type dw_report from u_dw_rpt within w_com711_confin_cp_071
integer x = 37
integer y = 300
integer width = 2025
integer height = 1072
string dataobject = "d_confin_comedor_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_com711_confin_cp_071
integer x = 41
integer y = 44
integer width = 590
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
string text = "Concepto Financiero "
end type

type gb_2 from groupbox within w_com711_confin_cp_071
integer x = 649
integer y = 44
integer width = 1417
integer height = 196
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = " Seleccione Origen "
end type

