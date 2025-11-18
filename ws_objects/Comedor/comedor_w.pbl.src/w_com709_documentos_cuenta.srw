$PBExportHeader$w_com709_documentos_cuenta.srw
forward
global type w_com709_documentos_cuenta from w_rpt
end type
type em_year from editmask within w_com709_documentos_cuenta
end type
type st_1 from statictext within w_com709_documentos_cuenta
end type
type sle_cuenta_desde from singlelineedit within w_com709_documentos_cuenta
end type
type cb_4 from commandbutton within w_com709_documentos_cuenta
end type
type em_descripcion from editmask within w_com709_documentos_cuenta
end type
type em_origen from singlelineedit within w_com709_documentos_cuenta
end type
type pb_1 from picturebutton within w_com709_documentos_cuenta
end type
type dw_report from u_dw_rpt within w_com709_documentos_cuenta
end type
type gb_1 from groupbox within w_com709_documentos_cuenta
end type
type gb_2 from groupbox within w_com709_documentos_cuenta
end type
end forward

global type w_com709_documentos_cuenta from w_rpt
integer width = 3072
integer height = 2488
string title = "Comprobantes de pago que han generado un Asiento Contable y que no están referenciados en un Parte de Costos(COM709)"
string menuname = "m_rpt"
long backcolor = 67108864
em_year em_year
st_1 st_1
sle_cuenta_desde sle_cuenta_desde
cb_4 cb_4
em_descripcion em_descripcion
em_origen em_origen
pb_1 pb_1
dw_report dw_report
gb_1 gb_1
gb_2 gb_2
end type
global w_com709_documentos_cuenta w_com709_documentos_cuenta

on w_com709_documentos_cuenta.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.em_year=create em_year
this.st_1=create st_1
this.sle_cuenta_desde=create sle_cuenta_desde
this.cb_4=create cb_4
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.pb_1=create pb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_year
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_cuenta_desde
this.Control[iCurrent+4]=this.cb_4
this.Control[iCurrent+5]=this.em_descripcion
this.Control[iCurrent+6]=this.em_origen
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.dw_report
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
end on

on w_com709_documentos_cuenta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_year)
destroy(this.st_1)
destroy(this.sle_cuenta_desde)
destroy(this.cb_4)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.pb_1)
destroy(this.dw_report)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_year, ls_cuenta_desde, ls_cuenta_hasta, ls_origen
integer 	li_ok

this.SetRedraw(false)

ls_year       		= String(em_year.text)
ls_cuenta_desde 	= String(sle_cuenta_desde.text)
ls_origen			= em_origen.text

if IsNull(ls_year) then
	MessageBox('COMEDORES', 'NO HA INGRESO UN AÑO VALIDO',StopSign!)
	return
end if

if IsNull(ls_cuenta_desde) then
	MessageBox('COMEDORES', 'NO HA INGRESO UNA CUENTA VALIDA',StopSign!)
	return
end if

if ls_origen = '' or IsNull( ls_origen) then
	MessageBox('COMEDORES', 'EL ORIGEN NO ESTA DEFINIDO', StopSign!)
	return
end if

idw_1.Retrieve(ls_year, ls_cuenta_desde, ls_origen)
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
////idw_1.Object.t_origen.text  = ls_nombre_origen
//idw_1.Object.Datawindow.Print.Orientation = '1'
//idw_1.object.t_nombre.text = gs_empresa
this.SetRedraw(true)
end event

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

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type em_year from editmask within w_com709_documentos_cuenta
integer x = 1970
integer y = 96
integer width = 233
integer height = 88
integer taborder = 80
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

type st_1 from statictext within w_com709_documentos_cuenta
integer x = 1806
integer y = 116
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

type sle_cuenta_desde from singlelineedit within w_com709_documentos_cuenta
integer x = 183
integer y = 112
integer width = 329
integer height = 72
integer taborder = 80
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

type cb_4 from commandbutton within w_com709_documentos_cuenta
integer x = 549
integer y = 112
integer width = 87
integer height = 72
integer taborder = 80
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

type em_descripcion from editmask within w_com709_documentos_cuenta
integer x = 1056
integer y = 112
integer width = 663
integer height = 72
integer taborder = 90
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

type em_origen from singlelineedit within w_com709_documentos_cuenta
event dobleclick pbm_lbuttondblclk
integer x = 919
integer y = 112
integer width = 128
integer height = 72
integer taborder = 80
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

type pb_1 from picturebutton within w_com709_documentos_cuenta
integer x = 2569
integer y = 28
integer width = 315
integer height = 180
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type dw_report from u_dw_rpt within w_com709_documentos_cuenta
integer x = 37
integer y = 244
integer width = 2830
integer height = 1628
integer taborder = 80
string dataobject = "d_rpt_documento_asiento"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_com709_documentos_cuenta
integer x = 41
integer y = 32
integer width = 800
integer height = 196
integer taborder = 40
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

type gb_2 from groupbox within w_com709_documentos_cuenta
integer x = 873
integer y = 16
integer width = 1417
integer height = 216
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

