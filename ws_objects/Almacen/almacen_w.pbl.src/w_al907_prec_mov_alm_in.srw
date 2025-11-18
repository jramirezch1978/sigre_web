$PBExportHeader$w_al907_prec_mov_alm_in.srw
forward
global type w_al907_prec_mov_alm_in from w_abc
end type
type em_year from editmask within w_al907_prec_mov_alm_in
end type
type st_4 from statictext within w_al907_prec_mov_alm_in
end type
type em_precio from editmask within w_al907_prec_mov_alm_in
end type
type st_2 from statictext within w_al907_prec_mov_alm_in
end type
type st_3 from statictext within w_al907_prec_mov_alm_in
end type
type sle_articulo from singlelineedit within w_al907_prec_mov_alm_in
end type
type st_1 from statictext within w_al907_prec_mov_alm_in
end type
type pb_2 from picturebutton within w_al907_prec_mov_alm_in
end type
type pb_1 from picturebutton within w_al907_prec_mov_alm_in
end type
end forward

global type w_al907_prec_mov_alm_in from w_abc
integer width = 2007
integer height = 1068
string title = "Actualizar Precio de Movimiento de Almacen (AL907)"
string menuname = "m_salir"
boolean resizable = false
event ue_aceptar ( )
event ue_salir ( )
em_year em_year
st_4 st_4
em_precio em_precio
st_2 st_2
st_3 st_3
sle_articulo sle_articulo
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_al907_prec_mov_alm_in w_al907_prec_mov_alm_in

event ue_aceptar();date		ld_fecha
decimal 	ldc_precio
string	ls_cod_art, ls_mensaje

SetPointer (HourGlass!)

ld_fecha = date(em_year.text)
em_precio.getdata( ldc_precio )
ls_cod_art = sle_articulo.text

update articulo_mov
   set precio_unit = :ldc_precio
 where cod_art = :ls_cod_art
   and flag_estado <> '0'
	and nro_vale in (select nro_vale
	 						 from vale_mov
							where trunc(fec_registro) <= :ld_fecha
							  and flag_estado <> '0');

IF SQLCA.SQLCode <> 0 then
	ls_mensaje = SQLCA.SQLErrtext
	ROLLBACK;
	SetPointer (Arrow!)
	MessageBox('Error en proceso', ls_mensaje)
	return
end if

commit;

SetPointer (Arrow!)

MessageBox('Aviso', 'Proceso ejecutado Satisfactoriamente')
end event

event ue_salir();close(this)
end event

on w_al907_prec_mov_alm_in.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.em_year=create em_year
this.st_4=create st_4
this.em_precio=create em_precio
this.st_2=create st_2
this.st_3=create st_3
this.sle_articulo=create sle_articulo
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_year
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.em_precio
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.sle_articulo
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.pb_2
this.Control[iCurrent+9]=this.pb_1
end on

on w_al907_prec_mov_alm_in.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_year)
destroy(this.st_4)
destroy(this.em_precio)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_articulo)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar(this)
em_year.text = string(today())
end event

type em_year from editmask within w_al907_prec_mov_alm_in
integer x = 526
integer y = 372
integer width = 439
integer height = 88
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
boolean dropdownright = true
end type

type st_4 from statictext within w_al907_prec_mov_alm_in
integer x = 96
integer y = 376
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha <="
alignment alignment = right!
boolean focusrectangle = false
end type

type em_precio from editmask within w_al907_prec_mov_alm_in
integer x = 526
integer y = 264
integer width = 439
integer height = 88
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.000000"
end type

type st_2 from statictext within w_al907_prec_mov_alm_in
integer x = 96
integer y = 288
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Precio"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_al907_prec_mov_alm_in
integer x = 91
integer y = 192
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cod Articulo"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_articulo from singlelineedit within w_al907_prec_mov_alm_in
event ue_dobleclick pbm_lbuttondblclk
integer x = 526
integer y = 168
integer width = 439
integer height = 88
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 12
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;Str_articulo lstr_articulo

lstr_articulo = gnvo_app.almacen.of_get_articulos_all( )

if lstr_articulo.b_Return then
	this.text = lstr_articulo.cod_art
end if
end event

type st_1 from statictext within w_al907_prec_mov_alm_in
integer x = 46
integer y = 16
integer width = 1883
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Actualizar Precio de Movimientos de Almacen"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_al907_prec_mov_alm_in
integer x = 1079
integer y = 644
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "c:\sigre\resources\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

type pb_1 from picturebutton within w_al907_prec_mov_alm_in
integer x = 704
integer y = 644
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
string picturename = "c:\sigre\resources\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

