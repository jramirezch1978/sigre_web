$PBExportHeader$w_ubigeo.srw
forward
global type w_ubigeo from window
end type
type st_3 from statictext within w_ubigeo
end type
type sle_distrito from singlelineedit within w_ubigeo
end type
type sle_desc_distrito from singlelineedit within w_ubigeo
end type
type st_2 from statictext within w_ubigeo
end type
type sle_provincia from singlelineedit within w_ubigeo
end type
type sle_desc_provincia from singlelineedit within w_ubigeo
end type
type sle_desc_departamento from singlelineedit within w_ubigeo
end type
type sle_departamento from singlelineedit within w_ubigeo
end type
type st_1 from statictext within w_ubigeo
end type
type cb_cancelar from commandbutton within w_ubigeo
end type
type cb_aceptar from commandbutton within w_ubigeo
end type
type st_titulo from statictext within w_ubigeo
end type
end forward

global type w_ubigeo from window
integer width = 2085
integer height = 752
boolean titlebar = true
string title = "Seleccione el UBIGEO"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_cancelar ( )
event ue_aceptar ( )
st_3 st_3
sle_distrito sle_distrito
sle_desc_distrito sle_desc_distrito
st_2 st_2
sle_provincia sle_provincia
sle_desc_provincia sle_desc_provincia
sle_desc_departamento sle_desc_departamento
sle_departamento sle_departamento
st_1 st_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
st_titulo st_titulo
end type
global w_ubigeo w_ubigeo

event ue_cancelar();Str_parametros	lstr_param

lstr_param.b_return = false

CloseWithReturn(this, lstr_param)
end event

event ue_aceptar();str_ubigeo	lstr_param

String ls_departamento, ls_provincia, ls_distrito, ls_codigo, ls_desc

ls_distrito 		= sle_distrito.text
ls_departamento 	= sle_departamento.text
ls_provincia		= sle_provincia.text

if ls_distrito = '' or IsNull(ls_distrito) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de DISTRITO', StopSign!)
	sle_distrito.setFocus()
	return
end if

if ls_departamento = '' or IsNull(ls_departamento) then
	MessageBox('Aviso', 'Debe Ingresar primero un codigo de DEPARTAMENTO', StopSign!)
	sle_departamento.setFocus()
	return
end if

if ls_provincia = '' or IsNull(ls_provincia) then
	MessageBox('Aviso', 'Debe Ingresar primero un codigo de PROVINCIA', StopSign!)
	sle_provincia.setFocus()
	return
end if

ls_codigo 	= ls_departamento + ls_provincia + ls_distrito
ls_desc 		= sle_desc_departamento.text + ' - ' + sle_desc_provincia.text + ' - ' + sle_desc_distrito.text



lstr_param.b_return 	= true
lstr_param.codigo					= ls_codigo
lstr_param.descripcion			= ls_desc

lstr_param.cod_distrito			= sle_distrito.text
lstr_param.desc_distrito		= sle_desc_distrito.text
lstr_param.cod_provincia		= sle_provincia.text
lstr_param.desc_provincia		= sle_desc_provincia.text
lstr_param.cod_departamento	= sle_departamento.text
lstr_param.desc_departamento	= sle_desc_departamento.text



CloseWithReturn(this, lstr_param)
end event

on w_ubigeo.create
this.st_3=create st_3
this.sle_distrito=create sle_distrito
this.sle_desc_distrito=create sle_desc_distrito
this.st_2=create st_2
this.sle_provincia=create sle_provincia
this.sle_desc_provincia=create sle_desc_provincia
this.sle_desc_departamento=create sle_desc_departamento
this.sle_departamento=create sle_departamento
this.st_1=create st_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.st_titulo=create st_titulo
this.Control[]={this.st_3,&
this.sle_distrito,&
this.sle_desc_distrito,&
this.st_2,&
this.sle_provincia,&
this.sle_desc_provincia,&
this.sle_desc_departamento,&
this.sle_departamento,&
this.st_1,&
this.cb_cancelar,&
this.cb_aceptar,&
this.st_titulo}
end on

on w_ubigeo.destroy
destroy(this.st_3)
destroy(this.sle_distrito)
destroy(this.sle_desc_distrito)
destroy(this.st_2)
destroy(this.sle_provincia)
destroy(this.sle_desc_provincia)
destroy(this.sle_desc_departamento)
destroy(this.sle_departamento)
destroy(this.st_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.st_titulo)
end on

event open;sle_departamento.setFocus()
end event

type st_3 from statictext within w_ubigeo
integer x = 87
integer y = 360
integer width = 407
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Distrito :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_distrito from singlelineedit within w_ubigeo
event dobleclick pbm_lbuttondblclk
integer x = 526
integer y = 348
integer width = 251
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;string ls_codigo, ls_data, ls_sql, ls_departamento, ls_provincia

ls_departamento = sle_departamento.text
ls_provincia 	 = sle_provincia.text

if ls_departamento = '' or IsNull(ls_departamento) then
	MessageBox('Aviso', 'Debe Ingresar primero un codigo de DEPARTMENTO', StopSign!)
	sle_departamento.setFocus()
	return
end if

if ls_provincia = '' or IsNull(ls_provincia) then
	MessageBox('Aviso', 'Debe Ingresar primero un codigo de PROVINCIA', StopSign!)
	sle_provincia.setFocus()
	return
end if


ls_sql = "select distinct "&
       + "substr(t.ubigeo, 5, 2) as codigo, "&
       + "t.distrito as desc_distrito "&
		 + "from sunat_ubigeo t "&
		 + "where substr(t.ubigeo,1,2) = '" + ls_departamento + "' "&
  		 + "  and substr(t.ubigeo, 3, 2) = '" + ls_provincia + "' "&
		 + "order by 1"
				 
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	this.text 						= ls_codigo
	sle_desc_distrito.text 		= ls_data
end if
end event

event modified;String 	ls_codigo, ls_desc, ls_departamento, ls_provincia

ls_codigo 			= this.text
ls_departamento 	= sle_departamento.text
ls_provincia		= sle_provincia.text

if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de PROVINCIA', StopSign!)
	this.setFocus()
	return
end if

if ls_departamento = '' or IsNull(ls_departamento) then
	MessageBox('Aviso', 'Debe Ingresar primero un codigo de PROVINCIA', StopSign!)
	sle_departamento.setFocus()
	return
end if

if ls_provincia = '' or IsNull(ls_provincia) then
	MessageBox('Aviso', 'Debe Ingresar primero un codigo de PROVINCIA', StopSign!)
	sle_provincia.setFocus()
	return
end if


select t.distrito
	into :ls_desc
from sunat_ubigeo t
where substr(t.ubigeo,1,2) 	= :ls_departamento
  and substr(t.ubigeo, 3, 2) 	= :ls_provincia
  and substr(t.ubigeo, 5, 2) 	= :ls_codigo
order by 1;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de DISTRITO no existe para la PROVINCIA ' + ls_provincia, StopSign!)
	return
end if

sle_desc_distrito.text = ls_desc
end event

type sle_desc_distrito from singlelineedit within w_ubigeo
integer x = 791
integer y = 348
integer width = 1211
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 134217752
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_ubigeo
integer x = 87
integer y = 260
integer width = 407
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Provincia :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_provincia from singlelineedit within w_ubigeo
event dobleclick pbm_lbuttondblclk
integer x = 526
integer y = 248
integer width = 251
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;string ls_codigo, ls_data, ls_sql, ls_departamento

ls_departamento = sle_departamento.text

if ls_departamento = '' or IsNull(ls_departamento) then
	MessageBox('Aviso', 'Debe Ingresar primero un codigo de PROVINCIA', StopSign!)
	sle_departamento.setFocus()
	return
end if


ls_sql = "select distinct "&
       + "substr(t.ubigeo, 3, 2) as codigo, "&
       + "t.provincia as desc_provincia "&
		 + "from sunat_ubigeo t "&
		 + "where substr(t.ubigeo,1,2) = '" + ls_departamento + "' "&
		 + "order by 1"
				 
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	this.text 						= ls_codigo
	sle_desc_provincia.text = ls_data
end if

end event

event modified;String 	ls_codigo, ls_desc, ls_departamento

ls_codigo = this.text
ls_departamento = sle_departamento.text

if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de PROVINCIA', StopSign!)
	this.setFocus()
	return
end if

if ls_departamento = '' or IsNull(ls_departamento) then
	MessageBox('Aviso', 'Debe Ingresar primero un codigo de PROVINCIA', StopSign!)
	sle_departamento.setFocus()
	return
end if


select t.provincia
	into :ls_desc
from sunat_ubigeo t
where substr(t.ubigeo,1,2) = :ls_departamento
  and substr(t.ubigeo, 3, 2) = :ls_codigo
order by 1;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de PROVINCIA no existe para el departamento ' + ls_departamento, StopSign!)
	return
end if

sle_desc_provincia.text = ls_desc
end event

type sle_desc_provincia from singlelineedit within w_ubigeo
integer x = 791
integer y = 248
integer width = 1211
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 134217752
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_desc_departamento from singlelineedit within w_ubigeo
integer x = 791
integer y = 148
integer width = 1211
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 134217752
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_departamento from singlelineedit within w_ubigeo
event dobleclick pbm_lbuttondblclk
integer x = 526
integer y = 148
integer width = 251
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;string ls_codigo, ls_data, ls_sql

ls_sql = "select distinct " &
       + "substr(t.ubigeo, 1, 2) as codigo, " &
       + "t.departamento as desc_departamento " &
		 + "from sunat_ubigeo t " &
		 + "order by 1"
				 
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	this.text 						= ls_codigo
	sle_desc_departamento.text = ls_data
end if

end event

event modified;String 	ls_codigo, ls_desc

ls_codigo = this.text

if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de DEPARTAMENTO', StopSign!)
	return
end if

SELECT t.departamento
	INTO :ls_desc
FROM sunat_ubigeo t
where substr(t.ubigeo, 1, 2) = :ls_codigo ;


IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de DEPARTAMENTO no existe', StopSign!)
	return
end if

sle_desc_departamento.text = ls_desc

end event

type st_1 from statictext within w_ubigeo
integer x = 87
integer y = 160
integer width = 407
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Departamento :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_cancelar from commandbutton within w_ubigeo
integer x = 1134
integer y = 480
integer width = 782
integer height = 132
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar()

end event

type cb_aceptar from commandbutton within w_ubigeo
integer x = 242
integer y = 480
integer width = 782
integer height = 132
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.dynamic event ue_aceptar()
end event

type st_titulo from statictext within w_ubigeo
integer width = 2066
integer height = 92
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "SELECCION EL UBIGEO"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

