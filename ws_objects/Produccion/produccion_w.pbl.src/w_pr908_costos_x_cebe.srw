$PBExportHeader$w_pr908_costos_x_cebe.srw
forward
global type w_pr908_costos_x_cebe from w_abc
end type
type cbx_2 from checkbox within w_pr908_costos_x_cebe
end type
type cbx_1 from checkbox within w_pr908_costos_x_cebe
end type
type pb_exit from picturebutton within w_pr908_costos_x_cebe
end type
type st_7 from statictext within w_pr908_costos_x_cebe
end type
type st_1 from statictext within w_pr908_costos_x_cebe
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_pr908_costos_x_cebe
end type
type st_2 from statictext within w_pr908_costos_x_cebe
end type
type sle_cenbef from singlelineedit within w_pr908_costos_x_cebe
end type
type em_cenbef from editmask within w_pr908_costos_x_cebe
end type
type cb_aceptar from picturebutton within w_pr908_costos_x_cebe
end type
type st_6 from statictext within w_pr908_costos_x_cebe
end type
type em_desc_moneda from editmask within w_pr908_costos_x_cebe
end type
type sle_moneda from singlelineedit within w_pr908_costos_x_cebe
end type
type gb_1 from groupbox within w_pr908_costos_x_cebe
end type
type gb_2 from groupbox within w_pr908_costos_x_cebe
end type
end forward

global type w_pr908_costos_x_cebe from w_abc
integer width = 2153
integer height = 1132
string title = "Guarda Costos Diarios x CeBe (PR908)"
string menuname = "m_impresion_1"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
event ue_procesar ( )
cbx_2 cbx_2
cbx_1 cbx_1
pb_exit pb_exit
st_7 st_7
st_1 st_1
uo_fecha uo_fecha
st_2 st_2
sle_cenbef sle_cenbef
em_cenbef em_cenbef
cb_aceptar cb_aceptar
st_6 st_6
em_desc_moneda em_desc_moneda
sle_moneda sle_moneda
gb_1 gb_1
gb_2 gb_2
end type
global w_pr908_costos_x_cebe w_pr908_costos_x_cebe

event ue_procesar();// Para Generer la Orden de Servicio Usando el Procedimiento

if MessageBox('Sistema de Producción','Esta seguro de realizar esta operacion',Question!,yesno!) = 2 then
					return
End if

string 	ls_mensaje, ls_cenbef, ls_moneda, ls_borra
date 		ld_fecha_ini, ld_fecha_fin

ld_fecha_ini 		= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 		= date(uo_fecha.of_get_fecha2( ))

if cbx_1.checked then
	ls_borra = '1'
else
	ls_borra = '0'
end if

if cbx_2.checked then
	ls_cenbef = '%%'
else
	if sle_cenbef.text = '' then
		MessageBox('Aviso', 'Debe especificar el centro de beneficio')
		return
	end if
	ls_cenbef	= sle_cenbef.text + '%'
end if

ls_moneda	= sle_moneda.text

if IsNull(ls_cenbef) or ls_cenbef = '' then
	MessageBox('PRODUCCION', 'NO HA INGRESO UNA PLANTILLA VALIDA',StopSign!)
	return
end if

if IsNull(ls_moneda) or ls_moneda = '' then
	MessageBox('PRODUCCION', 'NO HA INGRESO UNA MANEDA VALIDA',StopSign!)
	return
end if

//create or replace procedure USP_PROD_COSTOS_X_CEBE(
//       asi_cenbef       IN centro_beneficio.centro_benef%TYPE,
//       asi_moneda       IN moneda.cod_moneda%TYPE,
//       asi_borra        IN VARCHAR2,
//       adi_Fecha1       IN DATE,
//       adi_fecha2       IN DATE
//) IS

DECLARE 	USP_PROD_COSTOS_X_CEBE PROCEDURE FOR
			USP_PROD_COSTOS_X_CEBE( :ls_cenbef, 
									 		:ls_moneda, 
											:ls_borra,
									 		:ld_fecha_ini, 
									 		:ld_fecha_fin) ;
EXECUTE 	USP_PROD_COSTOS_X_CEBE ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "USP_PROD_COSTOS_X_CEBE: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_PROD_COSTOS_X_CEBE;

MessageBox('Aviso', 'PROCESO REALIZADO DE MANERASATISFACTORIA', Information!)
return
end event

on w_pr908_costos_x_cebe.create
int iCurrent
call super::create
if this.MenuName = "m_impresion_1" then this.MenuID = create m_impresion_1
this.cbx_2=create cbx_2
this.cbx_1=create cbx_1
this.pb_exit=create pb_exit
this.st_7=create st_7
this.st_1=create st_1
this.uo_fecha=create uo_fecha
this.st_2=create st_2
this.sle_cenbef=create sle_cenbef
this.em_cenbef=create em_cenbef
this.cb_aceptar=create cb_aceptar
this.st_6=create st_6
this.em_desc_moneda=create em_desc_moneda
this.sle_moneda=create sle_moneda
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_2
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.pb_exit
this.Control[iCurrent+4]=this.st_7
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.uo_fecha
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.sle_cenbef
this.Control[iCurrent+9]=this.em_cenbef
this.Control[iCurrent+10]=this.cb_aceptar
this.Control[iCurrent+11]=this.st_6
this.Control[iCurrent+12]=this.em_desc_moneda
this.Control[iCurrent+13]=this.sle_moneda
this.Control[iCurrent+14]=this.gb_1
this.Control[iCurrent+15]=this.gb_2
end on

on w_pr908_costos_x_cebe.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_2)
destroy(this.cbx_1)
destroy(this.pb_exit)
destroy(this.st_7)
destroy(this.st_1)
destroy(this.uo_fecha)
destroy(this.st_2)
destroy(this.sle_cenbef)
destroy(this.em_cenbef)
destroy(this.cb_aceptar)
destroy(this.st_6)
destroy(this.em_desc_moneda)
destroy(this.sle_moneda)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;//string ls_servicio, ls_desc_servicio
//
//select s.servicio, s.descripcion
//	into :ls_servicio, :ls_desc_servicio
//from servicios s, costo_param c
//	where s.servicio = c.servicio_transp;
//	
//	em_servicio.text = ls_servicio
//	
//	em_descripcion.text = ls_desc_servicio
end event

type cbx_2 from checkbox within w_pr908_costos_x_cebe
integer x = 1051
integer y = 340
integer width = 887
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
string text = "Todos los centros de Beneficios"
end type

event clicked;if this.checked then
	sle_cenbef.enabled = false
else
	sle_cenbef.enabled = true
end if
end event

type cbx_1 from checkbox within w_pr908_costos_x_cebe
integer x = 1051
integer y = 248
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
end type

type pb_exit from picturebutton within w_pr908_costos_x_cebe
integer x = 1838
integer y = 760
integer width = 137
integer height = 104
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

type st_7 from statictext within w_pr908_costos_x_cebe
integer x = 197
integer y = 660
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
string text = "Centro Benef"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_pr908_costos_x_cebe
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
string text = "Guarda Costos Diarios x CeBe"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_rango_fechas_v within w_pr908_costos_x_cebe
event destroy ( )
integer x = 402
integer y = 316
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

type st_2 from statictext within w_pr908_costos_x_cebe
integer x = 393
integer y = 232
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

type sle_cenbef from singlelineedit within w_pr908_costos_x_cebe
event dobleclick pbm_lbuttondblclk
integer x = 649
integer y = 660
integer width = 320
integer height = 72
integer taborder = 50
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
string ls_codigo, ls_data, ls_sql, ls_cod_art

ls_sql = "SELECT centro_benef AS centro_beneficio, " &
		  + "desc_centro AS descripcion_centro " &
		  + "FROM centro_beneficio " &
		  + "where flag_estado = '1' " &
		  + "order by centro_benef " 

		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')


if ls_codigo <> '' then
	this.text = ls_codigo
	em_cenbef.text = ls_data
end if
end event

event modified;String 	ls_pro, ls_desc

ls_pro = this.text

if ls_pro = '' or IsNull(ls_pro) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Centro de Beneficio')
	return
end if

SELECT desc_centro 
	INTO :ls_desc
FROM 	 centro_beneficio
WHERE  centro_benef =:ls_pro;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Centro de Beneficio no existe')
	em_cenbef.text = ''
	return
end if

em_cenbef.text = ls_desc

end event

type em_cenbef from editmask within w_pr908_costos_x_cebe
integer x = 978
integer y = 660
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

type cb_aceptar from picturebutton within w_pr908_costos_x_cebe
integer x = 1285
integer y = 756
integer width = 530
integer height = 112
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

type st_6 from statictext within w_pr908_costos_x_cebe
integer x = 197
integer y = 564
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
alignment alignment = right!
boolean focusrectangle = false
end type

type em_desc_moneda from editmask within w_pr908_costos_x_cebe
integer x = 978
integer y = 564
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

type sle_moneda from singlelineedit within w_pr908_costos_x_cebe
event dobleclick pbm_lbuttondblclk
integer x = 649
integer y = 564
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

type gb_1 from groupbox within w_pr908_costos_x_cebe
integer x = 142
integer y = 172
integer width = 1970
integer height = 772
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_pr908_costos_x_cebe
integer x = 878
integer y = 312
integer width = 923
integer height = 216
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

