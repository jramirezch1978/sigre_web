$PBExportHeader$w_al703_movimiento_tipo_oper.srw
forward
global type w_al703_movimiento_tipo_oper from w_report_smpl
end type
type gb_1 from groupbox within w_al703_movimiento_tipo_oper
end type
type uo_fechas from u_ingreso_rango_fechas_v within w_al703_movimiento_tipo_oper
end type
type st_1 from statictext within w_al703_movimiento_tipo_oper
end type
type cb_3 from commandbutton within w_al703_movimiento_tipo_oper
end type
type cbx_almacen from checkbox within w_al703_movimiento_tipo_oper
end type
type sle_almacen from singlelineedit within w_al703_movimiento_tipo_oper
end type
type sle_desc_almacen from singlelineedit within w_al703_movimiento_tipo_oper
end type
type sle_tipo_mov from singlelineedit within w_al703_movimiento_tipo_oper
end type
type sle_desc_tipo_mov from singlelineedit within w_al703_movimiento_tipo_oper
end type
end forward

global type w_al703_movimiento_tipo_oper from w_report_smpl
integer width = 3785
integer height = 1876
string title = "Movimientos por tipo de Operación (AL703)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
gb_1 gb_1
uo_fechas uo_fechas
st_1 st_1
cb_3 cb_3
cbx_almacen cbx_almacen
sle_almacen sle_almacen
sle_desc_almacen sle_desc_almacen
sle_tipo_mov sle_tipo_mov
sle_desc_tipo_mov sle_desc_tipo_mov
end type
global w_al703_movimiento_tipo_oper w_al703_movimiento_tipo_oper

type variables

end variables

on w_al703_movimiento_tipo_oper.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_1=create gb_1
this.uo_fechas=create uo_fechas
this.st_1=create st_1
this.cb_3=create cb_3
this.cbx_almacen=create cbx_almacen
this.sle_almacen=create sle_almacen
this.sle_desc_almacen=create sle_desc_almacen
this.sle_tipo_mov=create sle_tipo_mov
this.sle_desc_tipo_mov=create sle_desc_tipo_mov
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.cbx_almacen
this.Control[iCurrent+6]=this.sle_almacen
this.Control[iCurrent+7]=this.sle_desc_almacen
this.Control[iCurrent+8]=this.sle_tipo_mov
this.Control[iCurrent+9]=this.sle_desc_tipo_mov
end on

on w_al703_movimiento_tipo_oper.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.uo_fechas)
destroy(this.st_1)
destroy(this.cb_3)
destroy(this.cbx_almacen)
destroy(this.sle_almacen)
destroy(this.sle_desc_almacen)
destroy(this.sle_tipo_mov)
destroy(this.sle_desc_tipo_mov)
end on

event ue_retrieve;call super::ue_retrieve;Date 		ld_fec_ini, ld_fec_fin
string 	ls_operacion, ls_almacen

if cbx_almacen.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		gnvo_app.of_mensaje_error( "Debe especificar un almacen antes de continuar, por favor verifique!")
		sle_almacen.setFocus( )
		return
	else
		ls_almacen = trim(sle_almacen.text) +'%'
	end if
end if

if trim(sle_tipo_mov.text) = '' then
	gnvo_app.of_mensaje_error( "Debe especificar un Movimiento de Almacén antes de continuar, por favor verifique!")
	sle_tipo_mov.setFocus( )
	return
else
	ls_operacion = trim(sle_tipo_mov.text)
end if

ld_fec_ini = uo_fechas.of_get_fecha1()
ld_fec_fin = uo_fechas.of_get_fecha2()

dw_report.retrieve(ls_operacion, ls_almacen, ld_fec_ini, ld_fec_fin)

dw_report.object.t_user.text = gs_user
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_objeto.text = this.ClassName( )

dw_report.object.t_tit1.text = "En Nuevos Soles  del: " + &
								 String( ld_fec_ini, 'dd/mm/yyyy') + ' AL ' + &
								 String( ld_fec_fin, 'dd/mm/yyyy') 
dw_report.object.t_tit2.text = "Operacion: " + trim(sle_desc_tipo_mov.text)


if cbx_almacen.checked then
	dw_report.object.t_tit3.text = "Todos los almacenes"
else
	dw_report.object.t_tit3.text = trim(sle_desc_almacen.text)
end if

end event

type dw_report from w_report_smpl`dw_report within w_al703_movimiento_tipo_oper
integer x = 0
integer y = 280
integer width = 3342
integer height = 1316
string dataobject = "d_rpt_movimiento_x_tipo_operacion"
end type

type gb_1 from groupbox within w_al703_movimiento_tipo_oper
integer width = 745
integer height = 276
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "  Fechas  : "
end type

type uo_fechas from u_ingreso_rango_fechas_v within w_al703_movimiento_tipo_oper
integer x = 59
integer y = 56
integer height = 212
integer taborder = 40
boolean bringtotop = true
long backcolor = 67108864
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde

ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
uo_fechas.of_set_label("Desde","Hasta")
uo_fechas.of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
uo_fechas.of_set_rango_inicio(DATE('01/01/1000'))
uo_fechas.of_set_rango_fin(DATE('31/12/9999'))

end event

type st_1 from statictext within w_al703_movimiento_tipo_oper
integer x = 805
integer y = 56
integer width = 622
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean enabled = false
string text = "Operación  : "
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_3 from commandbutton within w_al703_movimiento_tipo_oper
integer x = 2875
integer y = 40
integer width = 334
integer height = 200
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.event ue_retrieve()


end event

type cbx_almacen from checkbox within w_al703_movimiento_tipo_oper
integer x = 777
integer y = 156
integer width = 649
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los almacenes : "
boolean checked = true
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
	sle_almacen.text = ''
else
	sle_almacen.enabled = true
end if
end event

type sle_almacen from singlelineedit within w_al703_movimiento_tipo_oper
event dobleclick pbm_lbuttondblclk
integer x = 1426
integer y = 152
integer width = 224
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select distinct al.almacen as almacen, " &
		 + "al.desc_almacen as descripcion_almacen " &
		 + "from almacen           al, " &
		 + "     vale_mov          vm " &
		 + "where vm.almacen = al.almacen " &
		 + "  and vm.flag_estado <> '0' " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_desc_almacen.text 	= ls_data
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_desc_almacen.text = ls_desc

end event

type sle_desc_almacen from singlelineedit within w_al703_movimiento_tipo_oper
integer x = 1655
integer y = 152
integer width = 1157
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_tipo_mov from singlelineedit within w_al703_movimiento_tipo_oper
event dobleclick pbm_lbuttondblclk
integer x = 1426
integer y = 48
integer width = 224
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
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

ls_sql = "select distinct amt.tipo_mov as tipo_mov, " &
		 + "amt.desc_tipo_mov as desc_tipo_mov " &
		 + "from articulo_mov_tipo amt, " &
		 + "     vale_mov          vm " &
		 + "where vm.tipo_mov = amt.tipo_mov " &
		 + "  and vm.flag_estado <> '0'     " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 					= ls_codigo
	sle_desc_tipo_mov.text 	= ls_data
end if

end event

event modified;String 	ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Tipo de Mov.')
	return
end if

SELECT desc_tipo_mov 
	INTO :ls_desc
FROM articulo_mov_tipo
where tipo_mov = :ls_codigo;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Tipo de Movimiento de Almacén no existe')
	return
end if

sle_desc_tipo_mov.text = ls_desc

end event

type sle_desc_tipo_mov from singlelineedit within w_al703_movimiento_tipo_oper
integer x = 1655
integer y = 48
integer width = 1157
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

