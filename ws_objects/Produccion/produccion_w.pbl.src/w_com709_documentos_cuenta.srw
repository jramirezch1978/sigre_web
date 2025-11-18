$PBExportHeader$w_com709_documentos_cuenta.srw
forward
global type w_com709_documentos_cuenta from w_rpt
end type
type em_origen from singlelineedit within w_com709_documentos_cuenta
end type
type em_descripcion from editmask within w_com709_documentos_cuenta
end type
type uo_fecha from u_ingreso_rango_fechas within w_com709_documentos_cuenta
end type
type pb_1 from picturebutton within w_com709_documentos_cuenta
end type
type dw_report from u_dw_rpt within w_com709_documentos_cuenta
end type
type cb_4 from commandbutton within w_com709_documentos_cuenta
end type
type sle_cuenta_desde from singlelineedit within w_com709_documentos_cuenta
end type
type gb_1 from groupbox within w_com709_documentos_cuenta
end type
type gb_2 from groupbox within w_com709_documentos_cuenta
end type
type gb_3 from groupbox within w_com709_documentos_cuenta
end type
end forward

global type w_com709_documentos_cuenta from w_rpt
integer width = 3511
integer height = 2488
string title = "Comprobantes de pago que han generado un Asiento Contable y que no están referenciados en un Parte de Costos(Com709)"
string menuname = "m_reporte"
long backcolor = 67108864
em_origen em_origen
em_descripcion em_descripcion
uo_fecha uo_fecha
pb_1 pb_1
dw_report dw_report
cb_4 cb_4
sle_cuenta_desde sle_cuenta_desde
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_com709_documentos_cuenta w_com709_documentos_cuenta

on w_com709_documentos_cuenta.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.uo_fecha=create uo_fecha
this.pb_1=create pb_1
this.dw_report=create dw_report
this.cb_4=create cb_4
this.sle_cuenta_desde=create sle_cuenta_desde
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_origen
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.dw_report
this.Control[iCurrent+6]=this.cb_4
this.Control[iCurrent+7]=this.sle_cuenta_desde
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_3
end on

on w_com709_documentos_cuenta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.uo_fecha)
destroy(this.pb_1)
destroy(this.dw_report)
destroy(this.cb_4)
destroy(this.sle_cuenta_desde)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_cuenta_desde, ls_origen, ls_nombre_origen
date     ld_fecha1, ld_fecha2
integer 	li_ok

this.SetRedraw(false)

ls_cuenta_desde 	= String(sle_cuenta_desde.text)

ld_fecha1 		= uo_fecha.of_get_fecha1( )
ld_fecha2 		= uo_fecha.of_get_fecha2( )
ls_origen		= em_origen.text


if ls_origen = '' or IsNull( ls_origen) then
	MessageBox('PRODUCCIÓN', 'EL ORIGEN NO ESTA DEFINIDO', StopSign!)
	return
end if

if ld_fecha2 < ld_fecha1 then
	MessageBox('PRODUCCIÓN', 'RANGO DE FECHAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
	return
end if

if IsNull(ls_cuenta_desde) then
	MessageBox('PRODUCCIÓN', 'NO HA INGRESO UNA CUENTA VALIDA',StopSign!)
	return
end if

Select nombre
  into :ls_nombre_origen
  from origen
 where cod_origen = :ls_origen;

idw_1.Retrieve(ls_cuenta_desde, ls_origen, ld_fecha1, ld_fecha2)
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_fecha1.text = string(ld_fecha1)
idw_1.Object.t_fecha2.text = string(ld_fecha2)
idw_1.Object.t_origen.text = ls_nombre_origen
idw_1.Object.usuario_t.text  = gs_user
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

IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

 ii_help = 101           // help topic
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type em_origen from singlelineedit within w_com709_documentos_cuenta
event dobleclick pbm_lbuttondblclk
integer x = 59
integer y = 92
integer width = 114
integer height = 80
integer taborder = 70
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

type em_descripcion from editmask within w_com709_documentos_cuenta
integer x = 187
integer y = 92
integer width = 649
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217738
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type uo_fecha from u_ingreso_rango_fechas within w_com709_documentos_cuenta
event destroy ( )
integer x = 1691
integer y = 92
integer width = 1303
integer height = 76
integer taborder = 60
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;date 		ld_fecha1, ld_fecha2
Integer 	li_ano, li_mes

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date('01/01/1900'), date('31/12/9999') ) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

li_ano = Year(Today())
li_mes = Month(Today())

if li_mes = 12 then
	li_mes = 1
	li_ano ++
else
	li_mes ++
end if

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( li_mes ,'00' ) &
	+ '/' + string(li_ano, '0000') )
ld_fecha2 = RelativeDate( ld_fecha2, -1 )

This.of_set_fecha( ld_fecha1, ld_fecha2 )
end event

type pb_1 from picturebutton within w_com709_documentos_cuenta
integer x = 3040
integer y = 44
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
string dataobject = "d_rpt_costo_por_cnta_cntbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_4 from commandbutton within w_com709_documentos_cuenta
integer x = 1481
integer y = 96
integer width = 87
integer height = 72
integer taborder = 50
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

str_parametros sl_param

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

type sle_cuenta_desde from singlelineedit within w_com709_documentos_cuenta
integer x = 951
integer y = 96
integer width = 480
integer height = 72
integer taborder = 20
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

type gb_1 from groupbox within w_com709_documentos_cuenta
integer x = 882
integer y = 28
integer width = 773
integer height = 168
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Cuenta Contable "
end type

type gb_2 from groupbox within w_com709_documentos_cuenta
integer x = 1664
integer y = 28
integer width = 1358
integer height = 168
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Rango de Fechas"
end type

type gb_3 from groupbox within w_com709_documentos_cuenta
integer x = 27
integer y = 28
integer width = 837
integer height = 168
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Origen "
end type

