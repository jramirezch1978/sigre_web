$PBExportHeader$w_pr910_genera_os_lavado.srw
forward
global type w_pr910_genera_os_lavado from w_abc
end type
type cbx_igv from checkbox within w_pr910_genera_os_lavado
end type
type sle_moneda from singlelineedit within w_pr910_genera_os_lavado
end type
type em_desc_moneda from editmask within w_pr910_genera_os_lavado
end type
type st_6 from statictext within w_pr910_genera_os_lavado
end type
type cb_aceptar from picturebutton within w_pr910_genera_os_lavado
end type
type st_nro_os from statictext within w_pr910_genera_os_lavado
end type
type st_os from statictext within w_pr910_genera_os_lavado
end type
type st_5 from statictext within w_pr910_genera_os_lavado
end type
type sle_desc from singlelineedit within w_pr910_genera_os_lavado
end type
type st_4 from statictext within w_pr910_genera_os_lavado
end type
type em_nom_prove from editmask within w_pr910_genera_os_lavado
end type
type sle_proveedor from singlelineedit within w_pr910_genera_os_lavado
end type
type st_3 from statictext within w_pr910_genera_os_lavado
end type
type st_2 from statictext within w_pr910_genera_os_lavado
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_pr910_genera_os_lavado
end type
type em_servicio from singlelineedit within w_pr910_genera_os_lavado
end type
type em_descripcion from editmask within w_pr910_genera_os_lavado
end type
type st_1 from statictext within w_pr910_genera_os_lavado
end type
type gb_1 from groupbox within w_pr910_genera_os_lavado
end type
type gb_2 from groupbox within w_pr910_genera_os_lavado
end type
end forward

global type w_pr910_genera_os_lavado from w_abc
integer width = 2117
integer height = 1812
string title = "Generar Orden de Servicio(COM903)"
string menuname = "m_impresion_1"
event ue_generar_os ( )
cbx_igv cbx_igv
sle_moneda sle_moneda
em_desc_moneda em_desc_moneda
st_6 st_6
cb_aceptar cb_aceptar
st_nro_os st_nro_os
st_os st_os
st_5 st_5
sle_desc sle_desc
st_4 st_4
em_nom_prove em_nom_prove
sle_proveedor sle_proveedor
st_3 st_3
st_2 st_2
uo_fecha uo_fecha
em_servicio em_servicio
em_descripcion em_descripcion
st_1 st_1
gb_1 gb_1
gb_2 gb_2
end type
global w_pr910_genera_os_lavado w_pr910_genera_os_lavado

type variables

end variables

event ue_generar_os();// Para Generer la Orden de Servicio Usando el Procedimiento

if MessageBox('Producción','Esta seguro de realizar esta operacion',Question!,yesno!) = 2 then
					return
End if

string 	ls_servicio, ls_proveedor, ls_descripcion, &
			ls_mensaje, ls_nro_os, ls_moneda, ls_igv
date 		ld_fecha_ini, ld_fecha_fin

ld_fecha_ini 		= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 		= date(uo_fecha.of_get_fecha2( ))

ls_servicio			= em_servicio.text
ls_proveedor		= sle_proveedor.text
ls_descripcion		= sle_desc.text
ls_moneda			= sle_moneda.text

if cbx_igv.checked = true then
	ls_igv = 'CON_IGV'
ELSE
	ls_igv = 'SIN_IGV'
END IF

if IsNull(ls_servicio) or ls_servicio = '' then
	MessageBox('PRODUCCIÓN', 'NO HA INGRESO UN SERVICIO VALIDO',StopSign!)
	return
end if

if IsNull(ls_proveedor) or ls_proveedor = '' then
	MessageBox('PRODUCCIÓN', 'NO HA INGRESO UN PROVEEDOR VALIDO',StopSign!)
	return
end if

if IsNull(ls_descripcion) or ls_descripcion = '' then
	MessageBox('PRODUCCIÓN', 'NO HA INGRESO UNA DESCRIPCIÓN VALIDA',StopSign!)
	return
end if

DECLARE 	USP_PROD_GENERA_OS_LAVADO PROCEDURE FOR
			USP_PROD_GENERA_OS_LAVADO( :gs_origen, 
									 :ld_fecha_ini, 
									 :ld_fecha_fin, 
									 :ls_servicio, 
									 :gs_user, 
									 :ls_descripcion, 
									 :ls_proveedor, 
									 :ls_moneda,
									 :ls_igv) ;
EXECUTE 	USP_PROD_GENERA_OS_LAVADO ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PROD_GENERA_OS_LAVADO: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH USP_PROD_GENERA_OS_LAVADO INTO :ls_nro_os;
CLOSE USP_PROD_GENERA_OS_LAVADO;

MessageBox('PRODUCCIÓN', 'PROCESO REALIZADO DE MANERA SATISFACTORIA', Information!)
st_nro_os.visible = true
st_nro_os.text 	= trim(ls_nro_os)
return
end event

on w_pr910_genera_os_lavado.create
int iCurrent
call super::create
if this.MenuName = "m_impresion_1" then this.MenuID = create m_impresion_1
this.cbx_igv=create cbx_igv
this.sle_moneda=create sle_moneda
this.em_desc_moneda=create em_desc_moneda
this.st_6=create st_6
this.cb_aceptar=create cb_aceptar
this.st_nro_os=create st_nro_os
this.st_os=create st_os
this.st_5=create st_5
this.sle_desc=create sle_desc
this.st_4=create st_4
this.em_nom_prove=create em_nom_prove
this.sle_proveedor=create sle_proveedor
this.st_3=create st_3
this.st_2=create st_2
this.uo_fecha=create uo_fecha
this.em_servicio=create em_servicio
this.em_descripcion=create em_descripcion
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_igv
this.Control[iCurrent+2]=this.sle_moneda
this.Control[iCurrent+3]=this.em_desc_moneda
this.Control[iCurrent+4]=this.st_6
this.Control[iCurrent+5]=this.cb_aceptar
this.Control[iCurrent+6]=this.st_nro_os
this.Control[iCurrent+7]=this.st_os
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.sle_desc
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.em_nom_prove
this.Control[iCurrent+12]=this.sle_proveedor
this.Control[iCurrent+13]=this.st_3
this.Control[iCurrent+14]=this.st_2
this.Control[iCurrent+15]=this.uo_fecha
this.Control[iCurrent+16]=this.em_servicio
this.Control[iCurrent+17]=this.em_descripcion
this.Control[iCurrent+18]=this.st_1
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_2
end on

on w_pr910_genera_os_lavado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_igv)
destroy(this.sle_moneda)
destroy(this.em_desc_moneda)
destroy(this.st_6)
destroy(this.cb_aceptar)
destroy(this.st_nro_os)
destroy(this.st_os)
destroy(this.st_5)
destroy(this.sle_desc)
destroy(this.st_4)
destroy(this.em_nom_prove)
destroy(this.sle_proveedor)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.uo_fecha)
destroy(this.em_servicio)
destroy(this.em_descripcion)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;//// Override
//THIS.EVENT ue_open_pre()
end event

event ue_open_pre;////Override

//MessageBox('Producción','Antes de Realizar esta operación asegúrese de que los datos hayan sido ingresados correctamente')
//
//string ls_servicio, ls_desc_servicio
//
//select s.servicio, s.descripcion
//	into :ls_servicio, :ls_desc_servicio
//from servicios s, comedor_param c
//	where s.servicio = c.servicio_com;
//	
//	em_servicio.text = ls_servicio
//	
//	em_descripcion.text = ls_desc_servicio
	

end event

event ue_print;call super::ue_print;STRING ls_cod_rel, ls_nro_os

str_parametros lstr_rep

ls_cod_rel = st_nro_os.text
ls_nro_os  = st_nro_os.text

lstr_rep.string1 = ls_cod_rel
lstr_rep.string2 = ls_nro_os
OpenSheetWithParm(w_cm314_orden_servicio_frm, lstr_rep, This, 2, layered!)


end event

type cbx_igv from checkbox within w_pr910_genera_os_lavado
integer x = 731
integer y = 540
integer width = 526
integer height = 72
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Considera IGV"
boolean checked = true
boolean lefttext = true
end type

type sle_moneda from singlelineedit within w_pr910_genera_os_lavado
event dobleclick pbm_lbuttondblclk
integer x = 590
integer y = 724
integer width = 283
integer height = 72
integer taborder = 40
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
	return
end if
		  
em_desc_moneda.text = ls_desc

end event

type em_desc_moneda from editmask within w_pr910_genera_os_lavado
integer x = 887
integer y = 724
integer width = 1038
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_6 from statictext within w_pr910_genera_os_lavado
integer x = 105
integer y = 724
integer width = 471
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Moneda"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_aceptar from picturebutton within w_pr910_genera_os_lavado
integer x = 105
integer y = 1208
integer width = 530
integer height = 132
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar OS"
string picturename = "H:\source\BMP\ACEPTARE.BMP"
alignment htextalign = right!
end type

event clicked;parent.event ue_generar_os()
end event

type st_nro_os from statictext within w_pr910_genera_os_lavado
boolean visible = false
integer x = 1477
integer y = 1444
integer width = 539
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_os from statictext within w_pr910_genera_os_lavado
integer x = 1001
integer y = 1416
integer width = 457
integer height = 136
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro. De Orden de Servico:"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_5 from statictext within w_pr910_genera_os_lavado
integer x = 105
integer y = 900
integer width = 1815
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Descripción"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_desc from singlelineedit within w_pr910_genera_os_lavado
integer x = 105
integer y = 984
integer width = 1815
integer height = 208
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33554431
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_pr910_genera_os_lavado
integer x = 105
integer y = 804
integer width = 471
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Proveedor"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type em_nom_prove from editmask within w_pr910_genera_os_lavado
integer x = 887
integer y = 808
integer width = 1038
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type sle_proveedor from singlelineedit within w_pr910_genera_os_lavado
event dobleclick pbm_lbuttondblclk
integer x = 590
integer y = 808
integer width = 283
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
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT P.PROVEEDOR as Código, " & 
		  +"P.NOM_PROVEEDOR AS Nombre " &
		  + "FROM PROVEEDOR P " &
		  + "WHERE P.flag_estado = '1' "
		  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_nom_prove.text = ls_data
end if

end event

event modified;String 	ls_pro, ls_desc

ls_pro = this.text
if ls_pro = '' or IsNull(ls_pro) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Proveedor')
	return
end if

SELECT NOM_PROVEEDOR INTO :ls_desc
FROM 	 PROVEEDOR	
WHERE  PROVEEDOR =:ls_pro;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Proveedor no existe')
	return
end if

em_nom_prove.text = ls_desc

end event

type st_3 from statictext within w_pr910_genera_os_lavado
integer x = 105
integer y = 636
integer width = 471
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Servicio"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_2 from statictext within w_pr910_genera_os_lavado
integer x = 686
integer y = 236
integer width = 622
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Rango de Fechas"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_rango_fechas_v within w_pr910_genera_os_lavado
integer x = 695
integer y = 320
integer height = 220
integer taborder = 10
boolean bringtotop = true
end type

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 //of_get_fecha1(), of_get_fecha2()  para leer las fechas
end event

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

type em_servicio from singlelineedit within w_pr910_genera_os_lavado
event dobleclick pbm_lbuttondblclk
integer x = 590
integer y = 636
integer width = 283
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
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT S.SERVICIO as Código, " & 
		  +"S.DESCRIPCION AS DESCRIPCION " &
		  + "FROM SERVICIOS S " &
		  + "WHERE flag_estado = '1' "
		  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

event modified;String 	ls_servi, ls_desc

ls_servi = this.text
if ls_servi = '' or IsNull(ls_servi) then
	MessageBox('Aviso', 'Debe Ingresar un Servicio')
	return
end if

SELECT 	DESCRIPCION INTO :ls_desc
FROM 		SERVICIOS
WHERE 	SERVICIO =:ls_servi;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Servicio no existe')
	return
end if

em_descripcion.text = ls_desc

end event

type em_descripcion from editmask within w_pr910_genera_os_lavado
integer x = 887
integer y = 636
integer width = 1038
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_1 from statictext within w_pr910_genera_os_lavado
integer x = 338
integer y = 68
integer width = 1371
integer height = 92
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Detalle de la OS del Servicio de Lavado"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_pr910_genera_os_lavado
integer x = 41
integer y = 168
integer width = 1970
integer height = 1204
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_pr910_genera_os_lavado
integer x = 777
integer y = 308
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

