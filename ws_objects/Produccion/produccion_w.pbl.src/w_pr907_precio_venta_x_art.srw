$PBExportHeader$w_pr907_precio_venta_x_art.srw
forward
global type w_pr907_precio_venta_x_art from w_abc
end type
type cbx_1 from checkbox within w_pr907_precio_venta_x_art
end type
type pb_exit from picturebutton within w_pr907_precio_venta_x_art
end type
type st_1 from statictext within w_pr907_precio_venta_x_art
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_pr907_precio_venta_x_art
end type
type st_2 from statictext within w_pr907_precio_venta_x_art
end type
type cb_aceptar from picturebutton within w_pr907_precio_venta_x_art
end type
type st_6 from statictext within w_pr907_precio_venta_x_art
end type
type em_desc_moneda from editmask within w_pr907_precio_venta_x_art
end type
type sle_moneda from singlelineedit within w_pr907_precio_venta_x_art
end type
end forward

global type w_pr907_precio_venta_x_art from w_abc
integer width = 2185
integer height = 1108
string title = "Guardiar Precios de Venta x Artículo (PR907)"
string menuname = "m_impresion_1"
event ue_procesar ( )
cbx_1 cbx_1
pb_exit pb_exit
st_1 st_1
uo_fecha uo_fecha
st_2 st_2
cb_aceptar cb_aceptar
st_6 st_6
em_desc_moneda em_desc_moneda
sle_moneda sle_moneda
end type
global w_pr907_precio_venta_x_art w_pr907_precio_venta_x_art

type variables
string is_dolar
end variables

event ue_procesar();// Para Generer la Orden de Servicio Usando el Procedimiento

if MessageBox('Sistema de Producción','Esta seguro de realizar esta operacion',Question!,yesno!) = 2 then
   return
End if

string 	ls_mensaje, ls_moneda, ls_borra
date 		ld_fecha_ini, ld_fecha_fin

ld_fecha_ini 		= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 		= date(uo_fecha.of_get_fecha2( ))

ls_moneda			= sle_moneda.text

if IsNull(ls_moneda) or ls_moneda = '' then
	MessageBox('PRODUCCION', 'NO HA INGRESO UNA MANEDA VALIDA',StopSign!)
	return
end if

if cbx_1.checked then
	ls_borra = '1'
else
	ls_borra = '0'
end if

//create or replace procedure USP_PROD_ACT_PRECIO_VENTA(
//       adi_fecha1 IN DATE,
//       adi_fecha2 IN DATE,
//       asi_moneda IN moneda.cod_moneda%TYPE,
//       asi_borra  IN VARCHAR2
//) IS

DECLARE 	USP_PROD_ACT_PRECIO_VENTA PROCEDURE FOR
			USP_PROD_ACT_PRECIO_VENTA( :ld_fecha_ini, 
									 		 	:ld_fecha_fin,
											 	:ls_moneda,
											 	:ls_borra) ;
EXECUTE 	USP_PROD_ACT_PRECIO_VENTA ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "USP_PROD_ACT_PRECIO_VENTA: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_PROD_ACT_PRECIO_VENTA;

MessageBox('PRODUCCION', 'PROCESO REALIZADO DE MANERASATISFACTORIA', Information!)
return
end event

on w_pr907_precio_venta_x_art.create
int iCurrent
call super::create
if this.MenuName = "m_impresion_1" then this.MenuID = create m_impresion_1
this.cbx_1=create cbx_1
this.pb_exit=create pb_exit
this.st_1=create st_1
this.uo_fecha=create uo_fecha
this.st_2=create st_2
this.cb_aceptar=create cb_aceptar
this.st_6=create st_6
this.em_desc_moneda=create em_desc_moneda
this.sle_moneda=create sle_moneda
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.pb_exit
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.uo_fecha
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cb_aceptar
this.Control[iCurrent+7]=this.st_6
this.Control[iCurrent+8]=this.em_desc_moneda
this.Control[iCurrent+9]=this.sle_moneda
end on

on w_pr907_precio_venta_x_art.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.pb_exit)
destroy(this.st_1)
destroy(this.uo_fecha)
destroy(this.st_2)
destroy(this.cb_aceptar)
destroy(this.st_6)
destroy(this.em_desc_moneda)
destroy(this.sle_moneda)
end on

event ue_open_pre;call super::ue_open_pre;string ls_desc_dolar

select cod_dolares
	into :is_dolar
from logparam
where reckey = '1';

select descripcion
	into :ls_desc_dolar
from moneda
where cod_moneda = :is_dolar;

sle_moneda.text = is_dolar
em_desc_moneda.text = ls_desc_dolar
end event

type cbx_1 from checkbox within w_pr907_precio_venta_x_art
integer x = 983
integer y = 240
integer width = 704
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 134217729
long backcolor = 67108864
string text = "Limpiar Datos Anteriores"
boolean checked = true
end type

type pb_exit from picturebutton within w_pr907_precio_venta_x_art
integer x = 1591
integer y = 672
integer width = 411
integer height = 216
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Exit!"
alignment htextalign = left!
string powertiptext = "Salir"
end type

event clicked;Close(Parent)
end event

type st_1 from statictext within w_pr907_precio_venta_x_art
integer x = 357
integer y = 60
integer width = 1458
integer height = 92
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 134217729
long backcolor = 67108864
string text = "Guardar los precios de Venta x Artículo"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_rango_fechas_v within w_pr907_precio_venta_x_art
event destroy ( )
integer x = 283
integer y = 308
integer height = 220
integer taborder = 10
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 //of_get_fecha1(), of_get_fecha2()  para leer las fechas
end event

type st_2 from statictext within w_pr907_precio_venta_x_art
integer x = 274
integer y = 212
integer width = 622
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 134217729
long backcolor = 67108864
string text = "Rango de Fechas"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_aceptar from picturebutton within w_pr907_precio_venta_x_art
integer x = 1157
integer y = 672
integer width = 411
integer height = 216
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
string picturename = "H:\source\BMP\ACEPTARE.BMP"
alignment htextalign = right!
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_procesar()
SetPointer(Arrow!)
end event

type st_6 from statictext within w_pr907_precio_venta_x_art
integer x = 210
integer y = 552
integer width = 434
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 134217729
long backcolor = 67108864
string text = "Moneda"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_desc_moneda from editmask within w_pr907_precio_venta_x_art
integer x = 992
integer y = 552
integer width = 1038
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12639424
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type sle_moneda from singlelineedit within w_pr907_precio_venta_x_art
event dobleclick pbm_lbuttondblclk
integer x = 663
integer y = 552
integer width = 320
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 12
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT M.COD_MONEDA AS CODIGO, " & 
		  +"M.DESCRIPCION AS MONEDA " &
		  + "FROM MONEDA M " &
		  + "WHERE M.flag_estado = '1' "
		  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_desc_moneda.text = ls_data
else
	em_desc_moneda.text = ' '
end if


end event

event modified;String 	ls_moneda, ls_desc

ls_moneda = this.text
if ls_moneda = '' or IsNull(ls_moneda) then
	MessageBox('Aviso', 'Debe Ingresar una Moneda')
	return
end if

SELECT DESCRIPCION INTO :ls_desc
FROM 	 MONEDA	
WHERE  COD_MONEDA =:ls_moneda;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Moneda no existe')
	em_desc_moneda.text = ''
	return
end if
		  
em_desc_moneda.text = ls_desc

end event

