$PBExportHeader$w_cd705_rpt_doc_proveedor.srw
forward
global type w_cd705_rpt_doc_proveedor from w_report_smpl
end type
type st_1 from statictext within w_cd705_rpt_doc_proveedor
end type
type sle_usuario from singlelineedit within w_cd705_rpt_doc_proveedor
end type
type cb_1 from commandbutton within w_cd705_rpt_doc_proveedor
end type
type pb_1 from picturebutton within w_cd705_rpt_doc_proveedor
end type
type st_nombre from statictext within w_cd705_rpt_doc_proveedor
end type
type uo_fecha from u_ingreso_rango_fechas within w_cd705_rpt_doc_proveedor
end type
end forward

global type w_cd705_rpt_doc_proveedor from w_report_smpl
integer width = 3515
integer height = 2276
string title = "[CD705] Documentos por Proveedor"
string menuname = "m_impresion"
long backcolor = 12632256
st_1 st_1
sle_usuario sle_usuario
cb_1 cb_1
pb_1 pb_1
st_nombre st_nombre
uo_fecha uo_fecha
end type
global w_cd705_rpt_doc_proveedor w_cd705_rpt_doc_proveedor

on w_cd705_rpt_doc_proveedor.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_1=create st_1
this.sle_usuario=create sle_usuario
this.cb_1=create cb_1
this.pb_1=create pb_1
this.st_nombre=create st_nombre
this.uo_fecha=create uo_fecha
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_usuario
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.st_nombre
this.Control[iCurrent+6]=this.uo_fecha
end on

on w_cd705_rpt_doc_proveedor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_usuario)
destroy(this.cb_1)
destroy(this.pb_1)
destroy(this.st_nombre)
destroy(this.uo_fecha)
end on

event ue_retrieve;call super::ue_retrieve;Long 	 ll_row, ll_ano, ll_mes
String ls_usuario
Date ld_fecha_desde, ld_fecha_hasta

ld_fecha_desde = uo_fecha.of_get_fecha1()
ld_fecha_hasta = uo_fecha.of_get_fecha2()
ls_usuario = sle_usuario.text
If ld_fecha_hasta < ld_fecha_desde then
	MessageBox('Error: ' + this.ClassName(), &
		'Rango de fechas inválido, por favor ingrese nuevamente', &
		Information!)
	Return
End if

dw_report.SetTransObject( sqlca)
this.Event ue_preview()
dw_report.retrieve(ld_fecha_desde,ld_fecha_hasta,ls_usuario)
dw_report.object.t_titulo1.text = 'DEL ' + STRING( ld_fecha_desde, 'dd/mm/yyyy') + &
	  ' AL ' + string( ld_fecha_hasta, 'dd/mm/yyyy')




end event

event ue_open_pre;call super::ue_open_pre;of_position_window(50,50)
end event

type dw_report from w_report_smpl`dw_report within w_cd705_rpt_doc_proveedor
integer x = 32
integer y = 196
integer width = 3374
integer height = 1740
string dataobject = "d_rpt_doc_proveedor"
end type

type st_1 from statictext within w_cd705_rpt_doc_proveedor
integer x = 1367
integer y = 28
integer width = 329
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Proveedor"
boolean focusrectangle = false
end type

type sle_usuario from singlelineedit within w_cd705_rpt_doc_proveedor
integer x = 1632
integer y = 28
integer width = 334
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cd705_rpt_doc_proveedor
integer x = 2926
integer y = 28
integer width = 311
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.event ue_retrieve()
end event

type pb_1 from picturebutton within w_cd705_rpt_doc_proveedor
integer x = 1979
integer y = 28
integer width = 101
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Custom050!"
alignment htextalign = left!
end type

event clicked;String ls_origen, ls_usuario, ls_area, ls_seccion, ls_nombre

str_seleccionar lstr_seleccionar

			
lstr_seleccionar.s_seleccion = 'S'

lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO, '&
										 +'PROVEEDOR.NOM_PROVEEDOR AS USUARIO, '&
										 +'PROVEEDOR.RUC AS RUC '&
										 +'FROM PROVEEDOR ' 
										 

						  
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_usuario 	= lstr_seleccionar.param1[1]
	ls_nombre 	= lstr_seleccionar.param2[1]
	
	sle_usuario.text = ls_usuario 
	st_nombre.text	  = ls_nombre
	
END IF


end event

type st_nombre from statictext within w_cd705_rpt_doc_proveedor
integer x = 2126
integer y = 28
integer width = 745
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_rango_fechas within w_cd705_rpt_doc_proveedor
integer x = 32
integer y = 28
integer width = 1289
integer height = 96
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;date ld_fecha_desde, ld_fecha_hasta

ld_fecha_desde = date('01/' + string(Today(), 'mm/yyyy') )
ld_fecha_hasta = RelativeDate( date('01/' &
		+ string(Month(Today()) + 1,'00') &
		+ string(Today(), '/yyyy') ), -1 )

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(ld_fecha_desde, ld_fecha_hasta ) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

