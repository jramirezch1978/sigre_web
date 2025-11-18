$PBExportHeader$w_abc_leer_balanza.srw
forward
global type w_abc_leer_balanza from w_abc
end type
type ole_com from olecustomcontrol within w_abc_leer_balanza
end type
type cb_grabar from commandbutton within w_abc_leer_balanza
end type
type st_status_com from statictext within w_abc_leer_balanza
end type
type sle_peso from singlelineedit within w_abc_leer_balanza
end type
type st_5 from statictext within w_abc_leer_balanza
end type
type cb_conectar from commandbutton within w_abc_leer_balanza
end type
type sle_settings from uo_textbox within w_abc_leer_balanza
end type
type ddlb_control_flujo from uo_ddlistbox within w_abc_leer_balanza
end type
type ddlb_puertos from uo_seriales within w_abc_leer_balanza
end type
type cb_reset from commandbutton within w_abc_leer_balanza
end type
type st_desc_seccion from statictext within w_abc_leer_balanza
end type
type st_6 from statictext within w_abc_leer_balanza
end type
type st_desc_area from statictext within w_abc_leer_balanza
end type
type st_4 from statictext within w_abc_leer_balanza
end type
type st_nom_trabajador from statictext within w_abc_leer_balanza
end type
type st_3 from statictext within w_abc_leer_balanza
end type
type sle_trabajador from singlelineedit within w_abc_leer_balanza
end type
type st_2 from statictext within w_abc_leer_balanza
end type
type sle_tarjeta from singlelineedit within w_abc_leer_balanza
end type
type st_1 from statictext within w_abc_leer_balanza
end type
type cb_1 from commandbutton within w_abc_leer_balanza
end type
end forward

global type w_abc_leer_balanza from w_abc
integer width = 3099
integer height = 1664
string title = "Registro y enrolamiento de tarjetas"
boolean maxbox = false
boolean resizable = false
windowtype windowtype = popup!
event ue_reset ( )
ole_com ole_com
cb_grabar cb_grabar
st_status_com st_status_com
sle_peso sle_peso
st_5 st_5
cb_conectar cb_conectar
sle_settings sle_settings
ddlb_control_flujo ddlb_control_flujo
ddlb_puertos ddlb_puertos
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
global w_abc_leer_balanza w_abc_leer_balanza

type variables
String 			is_lectura
str_parametros	istr_param
u_dw_abc			idw_master
w_pr334_proyecto_destajo lw_1
end variables

forward prototypes
public subroutine of_procesar (string as_cadena)
end prototypes

event ue_reset();sle_peso.text = ''
sle_tarjeta.text = ''
sle_trabajador.text= ''
st_nom_trabajador.text = ''
st_desc_area.text = ''
st_desc_seccion.text = ''

sle_tarjeta.enabled = false
end event

public subroutine of_procesar (string as_cadena);String ls_lectura

is_lectura = ''

ls_lectura = trim(as_cadena)
ls_lectura = TRIM(MID(ls_lectura,10))
ls_lectura = left(ls_lectura, len(ls_lectura) - 2)

sle_peso.text = ls_lectura
//lb_lectura.additem(as_cadena)

//if lb_lectura.totalitems() >= 30 then lb_lectura.reset()

sle_tarjeta.enabled = true

sle_tarjeta.setFocus( )
end subroutine

on w_abc_leer_balanza.create
int iCurrent
call super::create
this.ole_com=create ole_com
this.cb_grabar=create cb_grabar
this.st_status_com=create st_status_com
this.sle_peso=create sle_peso
this.st_5=create st_5
this.cb_conectar=create cb_conectar
this.sle_settings=create sle_settings
this.ddlb_control_flujo=create ddlb_control_flujo
this.ddlb_puertos=create ddlb_puertos
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
this.Control[iCurrent+1]=this.ole_com
this.Control[iCurrent+2]=this.cb_grabar
this.Control[iCurrent+3]=this.st_status_com
this.Control[iCurrent+4]=this.sle_peso
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.cb_conectar
this.Control[iCurrent+7]=this.sle_settings
this.Control[iCurrent+8]=this.ddlb_control_flujo
this.Control[iCurrent+9]=this.ddlb_puertos
this.Control[iCurrent+10]=this.cb_reset
this.Control[iCurrent+11]=this.st_desc_seccion
this.Control[iCurrent+12]=this.st_6
this.Control[iCurrent+13]=this.st_desc_area
this.Control[iCurrent+14]=this.st_4
this.Control[iCurrent+15]=this.st_nom_trabajador
this.Control[iCurrent+16]=this.st_3
this.Control[iCurrent+17]=this.sle_trabajador
this.Control[iCurrent+18]=this.st_2
this.Control[iCurrent+19]=this.sle_tarjeta
this.Control[iCurrent+20]=this.st_1
this.Control[iCurrent+21]=this.cb_1
end on

on w_abc_leer_balanza.destroy
call super::destroy
destroy(this.ole_com)
destroy(this.cb_grabar)
destroy(this.st_status_com)
destroy(this.sle_peso)
destroy(this.st_5)
destroy(this.cb_conectar)
destroy(this.sle_settings)
destroy(this.ddlb_control_flujo)
destroy(this.ddlb_puertos)
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

event ue_open_pre;

THIS.EVENT Post ue_open_pos()
im_1 = CREATE m_rButton 

istr_param = Message.PowerObjectParm

idw_master 	= istr_param.dw_m
lw_1			= istr_param.w1
sle_tarjeta.setFocus()

is_lectura = ''

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

end event

event timer;call super::timer;if ole_com.object.PortOpen then 
	cb_conectar.text = "Desconectar"
	st_status_com.text = "Conectado !!"
	Timer(0)
else
	cb_conectar.text = "Conectar"
	st_status_com.text = "Desconectado !!"
	Timer(0)
end if
end event

event close;call super::close;ole_com.object.PortOpen 	= False
end event

type ole_com from olecustomcontrol within w_abc_leer_balanza
event oncomm ( )
integer x = 2898
integer y = 164
integer width = 174
integer height = 152
integer taborder = 30
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_abc_leer_balanza.win"
integer textsize = -18
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type

event oncomm();String ls_car

if ole_com.object.CommEvent = 2 then
	ls_car = ole_com.object.Input
	if Asc(ls_car) = 13 then Return
	if Asc(ls_car) = 10 then 
		of_Procesar(is_lectura)
	else
		is_lectura += ls_car
	end if	
end if
end event

type cb_grabar from commandbutton within w_abc_leer_balanza
integer x = 1925
integer y = 1316
integer width = 507
integer height = 132
integer taborder = 20
integer textsize = -18
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Guardar"
end type

event clicked;String 	ls_cuadrilla, ls_cliente, ls_turno, ls_especie, ls_presentacion, ls_tarea, ls_nro_tarjeta, &
			ls_trabajador, ls_und, ls_mensaje
Decimal	ldc_peso			
Date		ld_fec_parte

ld_fec_parte		= Date(idw_master.object.fec_parte 	[1])
ls_cliente			= idw_master.object.cod_cliente		[1]
ls_cuadrilla		= idw_master.object.cod_cuadrilla	[1]
ls_turno				= idw_master.object.turno				[1]
ls_especie			= idw_master.object.cod_especie		[1]
ls_presentacion	= idw_master.object.cod_presentacion[1]
ls_tarea				= idw_master.object.cod_tarea			[1]
ls_und				= idw_master.object.und					[1]
ldc_peso				= Dec(sle_peso.text)
ls_nro_tarjeta		= sle_tarjeta.text
ls_trabajador		= sle_trabajador.text

insert into pd_destajo_balanza(
	cod_cuadrilla, cod_origen, cod_cliente, fec_parte, fec_registro, cod_usr, turno, cod_especie,
	cod_presentacion, cod_tarea, nro_tarjeta, cod_trabajador, cant_producida, und)
values(	
	:ls_cuadrilla, :gs_origen, :ls_cliente, :ld_fec_parte, sysdate, :gs_user, :ls_turno, :ls_especie,
	:ls_presentacion, :ls_tarea, :ls_nro_tarjeta, :ls_trabajador, :ldc_peso, :ls_und);

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error al grabar en pd_destajo_balanza. Mensaje: ' + ls_mensaje, StopSign!)
	return
end if

commit;



sle_peso.text = ''
sle_tarjeta.text = ''
sle_trabajador.text= ''
st_nom_trabajador.text = ''
st_desc_area.text = ''
st_desc_seccion.text = ''

sle_tarjeta.enabled = false

MessageBox('Aviso', 'Datos guardados corrrectamente', Information!)
end event

type st_status_com from statictext within w_abc_leer_balanza
integer x = 2309
integer y = 4
integer width = 663
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type sle_peso from singlelineedit within w_abc_leer_balanza
integer x = 1079
integer y = 160
integer width = 1170
integer height = 168
integer taborder = 20
integer textsize = -28
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
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

type st_5 from statictext within w_abc_leer_balanza
integer y = 160
integer width = 1056
integer height = 168
integer textsize = -28
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "PESO :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_conectar from commandbutton within w_abc_leer_balanza
integer x = 1893
integer width = 402
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Conectar"
end type

event clicked;String ls_handshaking
Integer li_control_flujo

if This.Text = 'Conectar' then
	if ddlb_control_flujo.text 	= 'Ninguno' 											then li_control_flujo 	= 0
	if ddlb_control_flujo.text 	= 'XON/XOFF' 											then li_control_flujo 	= 1
	if ddlb_control_flujo.text 	= 'RTS/CTS (Request To Send/Clear To Send)' 	then li_control_flujo 	= 2
	if ddlb_control_flujo.text 	= 'Ambos: XON/XOFF y RTS/CTS' 					then li_control_flujo 	= 3
	
	ole_com.object.CommPort		= ddlb_puertos.puerto()
	ole_com.object.Settings		= sle_settings.text
	ole_com.object.Handshaking	= li_control_flujo
	ole_com.object.NullDiscard = True 	  	 						//Se evita leer caracter null
	ole_com.object.RThreshold 	= 1		 							//Cuando se lean esta cant de caracteres se levanta OnComm, esta es la longuitud total de la cadena de datos incluyendo CF + LF
	ole_com.object.InputLen 	= ole_com.object.RThreshold	//Se lee la cantidad definida en RThreshold y se vacía
	ole_com.object.RTSEnable 	= True
	ole_com.object.PortOpen 	= True
	Timer(0.2)
else
	This.Text 						= 'Conectar'
	ole_com.object.PortOpen 	= False
	st_status_com.text			= ''
	Timer(0)
end if
end event

type sle_settings from uo_textbox within w_abc_leer_balanza
integer x = 315
integer width = 507
integer taborder = 20
string text = "9600,n,8,1"
end type

type ddlb_control_flujo from uo_ddlistbox within w_abc_leer_balanza
integer x = 846
integer width = 1038
integer taborder = 20
string item[] = {"Ninguno","XON/XOFF","RTS/CTS (Request To Send/Clear To Send)","Ambos: XON/XOFF y RTS/CTS"}
end type

type ddlb_puertos from uo_seriales within w_abc_leer_balanza
integer taborder = 20
end type

type cb_reset from commandbutton within w_abc_leer_balanza
integer x = 2363
integer y = 452
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

type st_desc_seccion from statictext within w_abc_leer_balanza
integer x = 1079
integer y = 1120
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

type st_6 from statictext within w_abc_leer_balanza
integer y = 1124
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

type st_desc_area from statictext within w_abc_leer_balanza
integer x = 1079
integer y = 940
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

type st_4 from statictext within w_abc_leer_balanza
integer y = 940
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

type st_nom_trabajador from statictext within w_abc_leer_balanza
integer x = 1079
integer y = 752
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

type st_3 from statictext within w_abc_leer_balanza
integer y = 756
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

type sle_trabajador from singlelineedit within w_abc_leer_balanza
integer x = 1079
integer y = 584
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
boolean enabled = false
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

type st_2 from statictext within w_abc_leer_balanza
integer y = 572
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

type sle_tarjeta from singlelineedit within w_abc_leer_balanza
integer x = 1079
integer y = 416
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
boolean enabled = false
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

if ll_count = 0 then
	MessageBox('Error', 'Error en tarjeta ' + ls_nro_tarjeta, StopSign!)
	return
end if

//Muestro los datos del trabajador
select t.cod_trabajador, m.NOM_TRABAJADOR, m.desc_area, m.desc_seccion
	into :ls_Cod_trabajador, :ls_nom_trabajador, :ls_desc_area, :ls_desc_seccion
from 	prod_enrolamiento t,
		vw_pr_trabajador  m
where t.cod_trabajador = m.COD_TRABAJADOR (+)
  and t.nro_tarjeta		= :ls_nro_tarjeta;
 
if ISNull(ls_cod_trabajador) or trim(ls_cod_trabajador) = '' then
	MessageBox('Error', 'Error en tarjeta ' + ls_nro_tarjeta, StopSign!)
	return
end if

sle_trabajador.text 		= ls_cod_trabajador
st_nom_Trabajador.text	= ls_nom_trabajador
st_desc_Area.text			= ls_desc_area
st_desc_seccion.text		= ls_desc_seccion





end event

type st_1 from statictext within w_abc_leer_balanza
integer y = 416
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

type cb_1 from commandbutton within w_abc_leer_balanza
integer x = 2450
integer y = 1312
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
boolean cancel = true
end type

event clicked;lw_1.event ue_refresh( )
Close(parent)
end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
02w_abc_leer_balanza.bin 
2500000c00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000004fffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000300000000000000000000000000000000000000000000000000000000732e4ad001d497b700000003000000c00000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000260000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000010000003c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a000000020000000100000004648a5600101b2c6e0000b6821400000000000000732e4ad001d497b7732e4ad001d497b7000000000000000000000000fffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
23ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00430079007000690072006800670020007400630028002000290039003100340039000000200000000000000000000000000000000000000000000000001234432100000008000003ed000003ed648a560100060000000100000000040000000200000025800008000000000000000000000000003f00000001000000001234432100000008000003ed000003ed648a560100060000000100000000040000000200000025800008000000000000000000000000003f00000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000020000003c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
12w_abc_leer_balanza.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
