$PBExportHeader$w_al909_cambiar_tipo_mov.srw
forward
global type w_al909_cambiar_tipo_mov from w_abc
end type
type st_4 from statictext within w_al909_cambiar_tipo_mov
end type
type st_3 from statictext within w_al909_cambiar_tipo_mov
end type
type st_2 from statictext within w_al909_cambiar_tipo_mov
end type
type sle_tipo_mov2 from singlelineedit within w_al909_cambiar_tipo_mov
end type
type sle_desc_tipo_mov2 from singlelineedit within w_al909_cambiar_tipo_mov
end type
type sle_desc_tipo_mov1 from singlelineedit within w_al909_cambiar_tipo_mov
end type
type sle_tipo_mov1 from singlelineedit within w_al909_cambiar_tipo_mov
end type
type sle_desc_almacen from singlelineedit within w_al909_cambiar_tipo_mov
end type
type sle_almacen from singlelineedit within w_al909_cambiar_tipo_mov
end type
type uo_fecha from u_ingreso_rango_fechas within w_al909_cambiar_tipo_mov
end type
type pb_1 from picturebutton within w_al909_cambiar_tipo_mov
end type
type pb_2 from picturebutton within w_al909_cambiar_tipo_mov
end type
type st_1 from statictext within w_al909_cambiar_tipo_mov
end type
end forward

global type w_al909_cambiar_tipo_mov from w_abc
integer width = 1938
integer height = 1108
string title = "Cambiar Tipo Mov en Vale Mov (AL909)"
event ue_salir ( )
event ue_aceptar ( )
st_4 st_4
st_3 st_3
st_2 st_2
sle_tipo_mov2 sle_tipo_mov2
sle_desc_tipo_mov2 sle_desc_tipo_mov2
sle_desc_tipo_mov1 sle_desc_tipo_mov1
sle_tipo_mov1 sle_tipo_mov1
sle_desc_almacen sle_desc_almacen
sle_almacen sle_almacen
uo_fecha uo_fecha
pb_1 pb_1
pb_2 pb_2
st_1 st_1
end type
global w_al909_cambiar_tipo_mov w_al909_cambiar_tipo_mov

event ue_salir();close(this)
end event

event ue_aceptar();SetPointer (HourGlass!)

string 	ls_mensaje, ls_almacen, ls_tipo_mov1, ls_tipo_mov2
Date		ld_fecha1, ld_fecha2

ls_almacen = sle_almacen.text

if ls_almacen = '' then
	MessageBox('Aviso', 'Debe ingresar un almacen valido')
	sle_almacen.SetFocus()
	return
end if

ls_tipo_mov1 = sle_tipo_mov1.text

if ls_tipo_mov1 = '' then
	MessageBox('Aviso', 'Debe ingresar un tipo de movimiento valido')
	sle_tipo_mov1.SetFocus()
	return
end if

ls_tipo_mov2 = sle_tipo_mov2.text

if ls_tipo_mov2 = '' then
	MessageBox('Aviso', 'Debe ingresar un tipo de movimiento valido')
	sle_tipo_mov2.SetFocus()
	return
end if

if trim(ls_tipo_mov1) = trim(ls_tipo_mov2) then
	MessageBox('Aviso', 'El movimiento de almacen anterior debe ser diferente al nuevo')
	sle_tipo_mov2.SetFocus()
	return
end if

ld_fecha1 = uo_fecha.of_get_Fecha1()
ld_fecha2 = uo_fecha.of_get_Fecha2()

if ld_fecha2 <= ld_fecha1 then
	MessageBox('Aviso', 'Rango de Fecha invalido')
	uo_fecha.SetFocus()
	return
end if

//ACtualizo el tipo de movimiento
update vale_mov
	set tipo_mov = :ls_tipo_mov2
where tipo_mov = :ls_tipo_mov1
	and almacen = :ls_almacen
	and trunc(fec_registro) between trunc(:ld_fecha1) and trunc(:ld_fecha2);

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQlErrText
	ROLLBACK;
	MessageBox('Error, no se pudo actualizar vale_mov', ls_mensaje, Exclamation!)
	return
end if

commit;

MessageBox('Aviso', 'Proceso se ha relizado satisfactoriamente', Information!)


SetPointer (Arrow!)
end event

on w_al909_cambiar_tipo_mov.create
int iCurrent
call super::create
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.sle_tipo_mov2=create sle_tipo_mov2
this.sle_desc_tipo_mov2=create sle_desc_tipo_mov2
this.sle_desc_tipo_mov1=create sle_desc_tipo_mov1
this.sle_tipo_mov1=create sle_tipo_mov1
this.sle_desc_almacen=create sle_desc_almacen
this.sle_almacen=create sle_almacen
this.uo_fecha=create uo_fecha
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_tipo_mov2
this.Control[iCurrent+5]=this.sle_desc_tipo_mov2
this.Control[iCurrent+6]=this.sle_desc_tipo_mov1
this.Control[iCurrent+7]=this.sle_tipo_mov1
this.Control[iCurrent+8]=this.sle_desc_almacen
this.Control[iCurrent+9]=this.sle_almacen
this.Control[iCurrent+10]=this.uo_fecha
this.Control[iCurrent+11]=this.pb_1
this.Control[iCurrent+12]=this.pb_2
this.Control[iCurrent+13]=this.st_1
end on

on w_al909_cambiar_tipo_mov.destroy
call super::destroy
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.sle_tipo_mov2)
destroy(this.sle_desc_tipo_mov2)
destroy(this.sle_desc_tipo_mov1)
destroy(this.sle_tipo_mov1)
destroy(this.sle_desc_almacen)
destroy(this.sle_almacen)
destroy(this.uo_fecha)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_1)
end on

type st_4 from statictext within w_al909_cambiar_tipo_mov
integer x = 50
integer y = 596
integer width = 279
integer height = 152
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Mov Nuevo"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_al909_cambiar_tipo_mov
integer x = 55
integer y = 440
integer width = 297
integer height = 152
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Mov Anterior"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_al909_cambiar_tipo_mov
integer x = 105
integer y = 328
integer width = 274
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Almacen"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_tipo_mov2 from singlelineedit within w_al909_cambiar_tipo_mov
event dobleclick pbm_lbuttondblclk
integer x = 393
integer y = 628
integer width = 224
integer height = 88
integer taborder = 50
boolean bringtotop = true
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

ls_sql = "SELECT amt.tipo_mov AS tipo_movimiento, " &
	  	 + "amt.DESC_tipo_mov AS DESCRIPCION_tipo_mov " &
	    + "FROM articulo_mov_tipo amt " &
		 + "where amt.flag_estado = '1'" 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_desc_tipo_mov2.text 	= ls_data
end if

end event

event modified;String 	ls_desc, ls_tipo_mov

ls_tipo_mov = this.text

if ls_tipo_mov = '' or IsNull(ls_tipo_mov) then
	MessageBox('Aviso', 'Debe Ingresar un Tipo de Movimiento')
	return
end if

select desc_tipo_mov
	into :ls_desc
from articulo_mov_tipo
where tipo_mov = :ls_tipo_mov
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Movimiento de Almacen nuevo no existe o no esta activo')
	return
end if

sle_desc_tipo_mov2.text = ls_desc

end event

type sle_desc_tipo_mov2 from singlelineedit within w_al909_cambiar_tipo_mov
integer x = 631
integer y = 628
integer width = 1211
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
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

type sle_desc_tipo_mov1 from singlelineedit within w_al909_cambiar_tipo_mov
integer x = 631
integer y = 472
integer width = 1211
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
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

type sle_tipo_mov1 from singlelineedit within w_al909_cambiar_tipo_mov
event dobleclick pbm_lbuttondblclk
integer x = 393
integer y = 472
integer width = 224
integer height = 88
integer taborder = 50
boolean bringtotop = true
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
string ls_codigo, ls_data, ls_sql, ls_almacen

ls_almacen = sle_almacen.text

if ls_almacen = '' then
	MessageBox('Aviso', 'Debe ingresar primero el almacen')
	return
end if

ls_sql = "SELECT amt.tipo_mov AS tipo_movimiento, " &
	  	 + "amt.DESC_tipo_mov AS DESCRIPCION_tipo_mov " &
	    + "FROM articulo_mov_tipo amt, " &
		 + "vale_mov vm " &
		 + "where vm.tipo_mov = amt.tipo_mov " &
		 + "and vm.almacen = '" + ls_almacen + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_desc_tipo_mov1.text 	= ls_data
end if

end event

event modified;String 	ls_desc, ls_tipo_mov

ls_tipo_mov = this.text

if ls_tipo_mov = '' or IsNull(ls_tipo_mov) then
	MessageBox('Aviso', 'Debe Ingresar un Tipo de Movimiento')
	return
end if

select desc_tipo_mov
	into :ls_desc
from articulo_mov_tipo
where tipo_mov = :ls_tipo_mov;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Movimiento de Almacen no existe')
	return
end if

sle_desc_tipo_mov1.text = ls_desc

end event

type sle_desc_almacen from singlelineedit within w_al909_cambiar_tipo_mov
integer x = 631
integer y = 316
integer width = 1211
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
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

type sle_almacen from singlelineedit within w_al909_cambiar_tipo_mov
event dobleclick pbm_lbuttondblclk
integer x = 393
integer y = 316
integer width = 224
integer height = 88
integer taborder = 20
boolean bringtotop = true
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
	    + "FROM almacen " 
				 
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

type uo_fecha from u_ingreso_rango_fechas within w_al909_cambiar_tipo_mov
integer x = 206
integer y = 184
integer taborder = 40
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(date('01/01/1900'), date('31/12/9999')) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type pb_1 from picturebutton within w_al909_cambiar_tipo_mov
integer x = 567
integer y = 780
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

type pb_2 from picturebutton within w_al909_cambiar_tipo_mov
integer x = 942
integer y = 780
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

type st_1 from statictext within w_al909_cambiar_tipo_mov
integer x = 46
integer y = 28
integer width = 1861
integer height = 116
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Cambiar Tipo Mov en Vale_mov"
alignment alignment = center!
boolean focusrectangle = false
end type

