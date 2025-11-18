$PBExportHeader$w_abc_enrolamiento.srw
forward
global type w_abc_enrolamiento from w_abc
end type
type cb_reset from commandbutton within w_abc_enrolamiento
end type
type st_desc_seccion from statictext within w_abc_enrolamiento
end type
type st_6 from statictext within w_abc_enrolamiento
end type
type st_desc_area from statictext within w_abc_enrolamiento
end type
type st_4 from statictext within w_abc_enrolamiento
end type
type st_nom_trabajador from statictext within w_abc_enrolamiento
end type
type st_3 from statictext within w_abc_enrolamiento
end type
type sle_trabajador from singlelineedit within w_abc_enrolamiento
end type
type st_2 from statictext within w_abc_enrolamiento
end type
type sle_tarjeta from singlelineedit within w_abc_enrolamiento
end type
type st_1 from statictext within w_abc_enrolamiento
end type
type cb_1 from commandbutton within w_abc_enrolamiento
end type
end forward

global type w_abc_enrolamiento from w_abc
integer width = 3040
integer height = 1204
string title = "Registro y enrolamiento de tarjetas"
boolean maxbox = false
boolean resizable = false
windowtype windowtype = popup!
event ue_reset ( )
cb_reset cb_reset
st_desc_seccion st_desc_seccion
st_6 st_6
st_desc_area st_desc_area
st_4 st_4
st_nom_trabajador st_nom_trabajador
st_3 st_3
sle_trabajador sle_trabajador
st_2 st_2
sle_tarjeta sle_tarjeta
st_1 st_1
cb_1 cb_1
end type
global w_abc_enrolamiento w_abc_enrolamiento

type variables
String 			is_lectura
str_parametros	istr_param
end variables

event ue_reset();sle_tarjeta.text = ''
sle_trabajador.text = ''
st_nom_trabajador.text = ''
st_desc_area.text = ''
st_Desc_seccion.text = ''

sle_tarjeta.setFocus()
end event

on w_abc_enrolamiento.create
int iCurrent
call super::create
this.cb_reset=create cb_reset
this.st_desc_seccion=create st_desc_seccion
this.st_6=create st_6
this.st_desc_area=create st_desc_area
this.st_4=create st_4
this.st_nom_trabajador=create st_nom_trabajador
this.st_3=create st_3
this.sle_trabajador=create sle_trabajador
this.st_2=create st_2
this.sle_tarjeta=create sle_tarjeta
this.st_1=create st_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_reset
this.Control[iCurrent+2]=this.st_desc_seccion
this.Control[iCurrent+3]=this.st_6
this.Control[iCurrent+4]=this.st_desc_area
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_nom_trabajador
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.sle_trabajador
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.sle_tarjeta
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.cb_1
end on

on w_abc_enrolamiento.destroy
call super::destroy
destroy(this.cb_reset)
destroy(this.st_desc_seccion)
destroy(this.st_6)
destroy(this.st_desc_area)
destroy(this.st_4)
destroy(this.st_nom_trabajador)
destroy(this.st_3)
destroy(this.sle_trabajador)
destroy(this.st_2)
destroy(this.sle_tarjeta)
destroy(this.st_1)
destroy(this.cb_1)
end on

event ue_open_pre;call super::ue_open_pre;istr_param = Message.PowerObjectParm

sle_tarjeta.setFocus()
end event

event ue_update;call super::ue_update;String ls_nro_tarjeta, ls_cod_trabajador, ls_nom_trabajador, ls_mensaje

ls_nro_tarjeta 	= sle_tarjeta.text
ls_cod_trabajador	= sle_trabajador.text
ls_nom_trabajador = st_nom_trabajador.text

if MessageBox('Aviso', 'Desea ENROLAR al trabajador ' + ls_cod_trabajador + ' ' + ls_nom_trabajador + "?", Information!, Yesno!, 2) = 2 then return

insert into prod_enrolamiento(nro_tarjeta, cod_trabajador, fec_asignacion, fec_registro, usr_registra, usr_enrola)
values(:ls_nro_tarjeta, :ls_cod_trabajador, sysdate, sysdate, :gs_user, :gs_user);

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	rollback;
	MessageBox("Error",  "Ha ocurrido un error registrar el enrolamiento. Mensaje de Error: " + ls_mensaje)
	return 
end if

//Inserto en el detalle del historico
insert into hist_prod_enrolamiento(nro_tarjeta,
                                   cod_trabajador,
                                   fec_registro,
                                   cod_usr)
values(:ls_nro_tarjeta, :ls_cod_trabajador, sysdate, :gs_user);

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	rollback;
	MessageBox("Error",  "Ha ocurrido un error registrar en la tabla hist_prod_enrolamiento. Mensaje de Error: " + ls_mensaje)
	return 
end if

commit;

sle_tarjeta.text 			= ''
sle_trabajador.text		= ''
st_nom_trabajador.text	= ''
st_desc_Area.text			= ''
st_desc_seccion.text		= ''

istr_param.w1.event dynamic ue_retrieve()

f_mensaje("Enrolamiento realizado satisfactoriamente", '')
end event

event open;//Overriding

THIS.EVENT ue_open_pre()
THIS.EVENT ue_dw_share()
THIS.EVENT ue_retrieve_dddw()
end event

type cb_reset from commandbutton within w_abc_enrolamiento
integer x = 2391
integer y = 44
integer width = 608
integer height = 132
integer taborder = 20
integer textsize = -18
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Limpiar"
end type

event clicked;parent.event ue_reset( )
end event

type st_desc_seccion from statictext within w_abc_enrolamiento
integer x = 1106
integer y = 712
integer width = 1893
integer height = 144
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_6 from statictext within w_abc_enrolamiento
integer x = 27
integer y = 716
integer width = 1056
integer height = 144
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seccion :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_desc_area from statictext within w_abc_enrolamiento
integer x = 1106
integer y = 532
integer width = 1893
integer height = 144
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_4 from statictext within w_abc_enrolamiento
integer x = 27
integer y = 532
integer width = 1056
integer height = 144
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Area :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_nom_trabajador from statictext within w_abc_enrolamiento
integer x = 1106
integer y = 344
integer width = 1893
integer height = 144
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_3 from statictext within w_abc_enrolamiento
integer x = 27
integer y = 348
integer width = 1056
integer height = 144
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nombre Completo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_trabajador from singlelineedit within w_abc_enrolamiento
integer x = 1106
integer y = 176
integer width = 1170
integer height = 144
integer taborder = 10
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;String 	ls_codigo, ls_nom_trabajador, ls_desc_area, ls_desc_seccion
Long 		ll_pos, ll_count

is_lectura = this.text

//Otengo el codigo de articulo
if pos(is_lectura, '|') > 0 or pos(is_lectura, ']') > 0 then
	if pos(is_lectura, '|') > 0 then
		ll_pos = pos(is_lectura, '|')
	else
		ll_pos = pos(is_lectura, ']')
	end if
	ls_codigo = left(is_lectura, ll_pos - 1)
else
	ls_codigo = this.text
end if

this.text = ls_codigo

//Busco si esta enrolado el trabajador
select count(*)
	into :ll_count
from PROD_ENROLAMIENTO t
where t.cod_trabajador = :ls_codigo;

if ll_count > 0 then
	MessageBox('Error', 'El código de trabajador ' + ls_codigo + ' ya tiene ' + string(ll_count) &
							 + ' tarjeta(s) asignado(s), por favor verifique!', StopSign!)
	
	st_nom_trabajador.text 	= ''
	st_desc_area.text			= ''
	st_desc_seccion.text		= ''
	this.text					= ''
	
	this.SetFocus( )
	
	return
end if

select nom_trabajador, desc_area, desc_seccion
  into :ls_nom_trabajador, :ls_desc_area, :ls_desc_seccion
  from vw_pr_trabajador m
 where m.cod_trabajador = :ls_codigo;
 

st_nom_trabajador.text 	= ls_nom_trabajador
st_desc_area.text			= ls_desc_area
st_desc_seccion.text		= ls_desc_seccion


//Grabar los datos
parent.event ue_update()
end event

type st_2 from statictext within w_abc_enrolamiento
integer x = 27
integer y = 164
integer width = 1056
integer height = 144
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_tarjeta from singlelineedit within w_abc_enrolamiento
integer x = 1106
integer y = 8
integer width = 1170
integer height = 144
integer taborder = 10
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;String 	ls_nro_tarjeta, ls_cod_trabajador, ls_nom_trabajador, ls_desc_area, ls_desc_seccion
Long		ll_count
Str_parametros	lstr_param


ls_nro_tarjeta = this.text

select count(*)
	into :ll_count
from PROD_ENROLAMIENTO t
where nro_tarjeta = :ls_nro_tarjeta;

if ll_count > 0 then
	// si la tarjeta existe entonces debo elegir un curso de accion
	open(w_accion_enrolamiento)
	lstr_param = Message.PowerObjectParm
	
	if not lstr_param.b_return then 
		parent.event ue_reset()
		sle_tarjeta.setFocus()
		return
	end if
	
	if lstr_param.i_return = 1 then
		//Muestro los datos del trabajador
		select t.cod_trabajador, m.NOM_TRABAJADOR, m.desc_area, m.desc_seccion
			into :ls_Cod_trabajador, :ls_nom_trabajador, :ls_desc_area, :ls_desc_seccion
		from 	prod_enrolamiento t,
     			vw_pr_trabajador  m
		where t.cod_trabajador = m.COD_TRABAJADOR (+)
		  and t.nro_tarjeta		= :ls_nro_tarjeta;
		
		sle_trabajador.text 		= ls_cod_trabajador
		st_nom_Trabajador.text	= ls_nom_trabajador
		st_desc_Area.text			= ls_desc_area
		st_desc_seccion.text		= ls_desc_seccion
		
	elseif lstr_param.i_return = 2 then
		//Quito la asignacion del trabajador
		
	end if
	
end if


sle_trabajador.setFocus()
cb_Reset.enabled = true



end event

type st_1 from statictext within w_abc_enrolamiento
integer y = 8
integer width = 1056
integer height = 144
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Numero de Tarjeta :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_abc_enrolamiento
integer x = 2478
integer y = 904
integer width = 503
integer height = 132
integer taborder = 10
integer textsize = -18
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar"
end type

event clicked;str_parametros	lstr_param

lstr_param.b_Return = true

CloseWithReturn(parent, lstr_param)
end event

