$PBExportHeader$w_pr903_guardar_costos.srw
forward
global type w_pr903_guardar_costos from w_abc
end type
type em_desc_cebe from editmask within w_pr903_guardar_costos
end type
type sle_cebe from singlelineedit within w_pr903_guardar_costos
end type
type st_5 from statictext within w_pr903_guardar_costos
end type
type pb_exit from picturebutton within w_pr903_guardar_costos
end type
type em_desc_plantilla from editmask within w_pr903_guardar_costos
end type
type sle_plantilla from singlelineedit within w_pr903_guardar_costos
end type
type st_7 from statictext within w_pr903_guardar_costos
end type
type st_1 from statictext within w_pr903_guardar_costos
end type
type em_desc_art from editmask within w_pr903_guardar_costos
end type
type sle_articulo from singlelineedit within w_pr903_guardar_costos
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_pr903_guardar_costos
end type
type st_2 from statictext within w_pr903_guardar_costos
end type
type st_3 from statictext within w_pr903_guardar_costos
end type
type sle_almacen from singlelineedit within w_pr903_guardar_costos
end type
type em_desc_almacen from editmask within w_pr903_guardar_costos
end type
type st_4 from statictext within w_pr903_guardar_costos
end type
type cb_aceptar from picturebutton within w_pr903_guardar_costos
end type
type st_6 from statictext within w_pr903_guardar_costos
end type
type em_desc_moneda from editmask within w_pr903_guardar_costos
end type
type sle_moneda from singlelineedit within w_pr903_guardar_costos
end type
type gb_1 from groupbox within w_pr903_guardar_costos
end type
type gb_2 from groupbox within w_pr903_guardar_costos
end type
end forward

global type w_pr903_guardar_costos from w_abc
integer width = 2318
integer height = 1648
string title = "Guardar Costos Diarios(PR903)"
string menuname = "m_impresion_1"
event ue_procesar ( )
em_desc_cebe em_desc_cebe
sle_cebe sle_cebe
st_5 st_5
pb_exit pb_exit
em_desc_plantilla em_desc_plantilla
sle_plantilla sle_plantilla
st_7 st_7
st_1 st_1
em_desc_art em_desc_art
sle_articulo sle_articulo
uo_fecha uo_fecha
st_2 st_2
st_3 st_3
sle_almacen sle_almacen
em_desc_almacen em_desc_almacen
st_4 st_4
cb_aceptar cb_aceptar
st_6 st_6
em_desc_moneda em_desc_moneda
sle_moneda sle_moneda
gb_1 gb_1
gb_2 gb_2
end type
global w_pr903_guardar_costos w_pr903_guardar_costos

type variables
string is_oper_ing_prod, is_dolar
end variables

event ue_procesar();// Para Generer la Orden de Servicio Usando el Procedimiento

if MessageBox('Sistema de Producción','Esta seguro de realizar esta operacion',Question!,yesno!) = 2 then
					return
End if

string 	ls_articulo, ls_almacen, ls_plantilla, &
			ls_mensaje, ls_nro_os, ls_moneda, ls_cebe
date 		ld_fecha_ini, ld_fecha_fin

ld_fecha_ini 		= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 		= date(uo_fecha.of_get_fecha2( ))

ls_articulo			= sle_articulo.text
ls_almacen			= sle_almacen.text
ls_plantilla		= sle_plantilla.text
ls_moneda			= sle_moneda.text
ls_cebe				= sle_cebe.text

//if IsNull(ls_articulo) or ls_articulo = '' then
//	MessageBox('PRODUCCION', 'NO HA INGRESO UN ARTICULO VALIDO',StopSign!)
//	return
//end if

//if IsNull(ls_almacen) or ls_almacen = '' then
//	MessageBox('PRODUCCION', 'NO HA INGRESO UN ALMACEN VALIDO',StopSign!)
//	return
//end if

if IsNull(ls_plantilla) or ls_plantilla = '' then
	MessageBox('PRODUCCION', 'NO HA INGRESO UNA PLANTILLA VALIDA',StopSign!)
	return
end if

if IsNull(ls_moneda) or ls_moneda = '' then
	MessageBox('PRODUCCION', 'NO HA INGRESO UNA MANEDA VALIDA',StopSign!)
	return
end if

if IsNull(ls_cebe) or ls_cebe = '' then
	MessageBox('PRODUCCION', 'NO HA INGRESO UN CENTRO DE BENEFICIO',StopSign!)
	return
end if

//create or replace procedure USP_PROD_COSTOS_DIARIOS(
//       asi_articulo     IN articulo.cod_art%TYPE,
//       asi_almacen      IN almacen.almacen%TYPE,
//       asi_plantilla    IN plantilla_costo.cod_plantilla%TYPE,
//       asi_moneda       IN moneda.cod_moneda%TYPE,
//       asi_cenbef       IN centro_beneficio.centro_benef%TYPE,
//       adi_Fecha1       IN DATE,
//       adi_fecha2       IN DATE
//) IS

DECLARE 	USP_PROD_COSTOS_DIARIOS PROCEDURE FOR
			USP_PROD_COSTOS_DIARIOS( :ls_articulo, 
									 		 :ls_almacen, 
									 		 :ls_plantilla, 
									 		 :ls_moneda, 
											 :ls_cebe,
									 		 :ld_fecha_ini, 
									 		 :ld_fecha_fin) ;
EXECUTE 	USP_PROD_COSTOS_DIARIOS ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "USP_PROD_COSTOS_DIARIOS: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_PROD_COSTOS_DIARIOS;

MessageBox('Aviso', 'PROCESO REALIZADO DE MANERA SATISFACTORIA', Information!)
return
end event

on w_pr903_guardar_costos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion_1" then this.MenuID = create m_impresion_1
this.em_desc_cebe=create em_desc_cebe
this.sle_cebe=create sle_cebe
this.st_5=create st_5
this.pb_exit=create pb_exit
this.em_desc_plantilla=create em_desc_plantilla
this.sle_plantilla=create sle_plantilla
this.st_7=create st_7
this.st_1=create st_1
this.em_desc_art=create em_desc_art
this.sle_articulo=create sle_articulo
this.uo_fecha=create uo_fecha
this.st_2=create st_2
this.st_3=create st_3
this.sle_almacen=create sle_almacen
this.em_desc_almacen=create em_desc_almacen
this.st_4=create st_4
this.cb_aceptar=create cb_aceptar
this.st_6=create st_6
this.em_desc_moneda=create em_desc_moneda
this.sle_moneda=create sle_moneda
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_desc_cebe
this.Control[iCurrent+2]=this.sle_cebe
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.pb_exit
this.Control[iCurrent+5]=this.em_desc_plantilla
this.Control[iCurrent+6]=this.sle_plantilla
this.Control[iCurrent+7]=this.st_7
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.em_desc_art
this.Control[iCurrent+10]=this.sle_articulo
this.Control[iCurrent+11]=this.uo_fecha
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.st_3
this.Control[iCurrent+14]=this.sle_almacen
this.Control[iCurrent+15]=this.em_desc_almacen
this.Control[iCurrent+16]=this.st_4
this.Control[iCurrent+17]=this.cb_aceptar
this.Control[iCurrent+18]=this.st_6
this.Control[iCurrent+19]=this.em_desc_moneda
this.Control[iCurrent+20]=this.sle_moneda
this.Control[iCurrent+21]=this.gb_1
this.Control[iCurrent+22]=this.gb_2
end on

on w_pr903_guardar_costos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_desc_cebe)
destroy(this.sle_cebe)
destroy(this.st_5)
destroy(this.pb_exit)
destroy(this.em_desc_plantilla)
destroy(this.sle_plantilla)
destroy(this.st_7)
destroy(this.st_1)
destroy(this.em_desc_art)
destroy(this.sle_articulo)
destroy(this.uo_fecha)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_almacen)
destroy(this.em_desc_almacen)
destroy(this.st_4)
destroy(this.cb_aceptar)
destroy(this.st_6)
destroy(this.em_desc_moneda)
destroy(this.sle_moneda)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;string ls_desc_dolar
select oper_ing_prod, cod_dolares
	into :is_oper_ing_prod, :is_dolar
from logparam
where reckey = '1';

select descripcion
	into :ls_desc_dolar
from moneda
where cod_moneda = :is_dolar;

sle_moneda.text = is_dolar
em_desc_moneda.text = ls_desc_dolar
end event

type em_desc_cebe from editmask within w_pr903_guardar_costos
integer x = 987
integer y = 980
integer width = 1038
integer height = 72
integer taborder = 70
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

type sle_cebe from singlelineedit within w_pr903_guardar_costos
event dobleclick pbm_lbuttondblclk
integer x = 658
integer y = 980
integer width = 320
integer height = 72
integer taborder = 60
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

ls_cod_art = sle_articulo.text

if ls_cod_art = '' then
	MessageBox('Aviso', 'Debe indicar un Articulo primero')
	return
end if

ls_sql = "SELECT a.almacen AS CODIGO_almacen, " &
		  + "a.desc_almacen AS descripcion_almacen " &
		  + "FROM almacen a, " &
		  + "articulo_almacen aa " &
		  + "where aa.almacen = a.almacen " &
		  + "and a.flag_estado = '1' " &
		  + "and aa.cod_art = '" + ls_cod_art + "' " &
		  + "order by a.almacen " 

		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')


if ls_codigo <> '' then
	this.text = ls_codigo
	em_desc_almacen.text = ls_data
end if
end event

event modified;String 	ls_pro, ls_desc

ls_pro = this.text
if ls_pro = '' or IsNull(ls_pro) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Alamcen')
	return
end if

SELECT desc_almacen INTO :ls_desc
FROM 	 almacen	
WHERE  almacen =:ls_pro;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	em_desc_plantilla.text = ''
	return
end if

em_desc_almacen.text = ls_desc

end event

type st_5 from statictext within w_pr903_guardar_costos
integer x = 206
integer y = 980
integer width = 434
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217729
long backcolor = 67108864
string text = "Centro Benef"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_exit from picturebutton within w_pr903_guardar_costos
integer x = 1879
integer y = 1128
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

type em_desc_plantilla from editmask within w_pr903_guardar_costos
integer x = 987
integer y = 628
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

type sle_plantilla from singlelineedit within w_pr903_guardar_costos
event dobleclick pbm_lbuttondblclk
event ue_datos_plantilla ( string as_codigo )
integer x = 658
integer y = 628
integer width = 320
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

ls_sql = "SELECT distinct a.cod_plantilla AS codigo_plantilla, " &
				  + "a.observaciones AS descripcion " &
				  + "FROM plantilla_costo a, " &
				  + "plantilla_costo_det b " &
				  + "where a.cod_plantilla = b.cod_plantilla " & 
				  + "and a.flag_estado = '1' " &
				  + "order by a.cod_plantilla "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
	em_desc_plantilla.text = ls_data
	
	this.event ue_datos_plantilla( ls_codigo )
else
	em_desc_plantilla.text = ''
end if		

end event

event ue_datos_plantilla(string as_codigo);string 	ls_cebe, ls_desc_cebe, ls_cod_art, ls_desc_art, &
			ls_almacen, ls_desc_almacen, ls_origen
Long 		ll_count

select centro_benef
  into :ls_cebe
 from plantilla_costo
 where cod_plantilla = :as_codigo;

if SQLCA.SQLCode = 100 then return

select desc_centro, cod_origen
	into :ls_desc_cebe, :ls_origen
from centro_beneficio
where centro_benef = :ls_cebe;

sle_cebe.text = ls_cebe
em_Desc_cebe.text = ls_desc_cebe

SELECT count(*)
	into :ll_count
FROM 	articulo a,
		centro_benef_articulo ca, 
		plantilla_costo pc 
where a.cod_art = ca.cod_art 
  and a.flag_estado = '1' 
  and ca.centro_benef = pc.centro_benef 
  and pc.cod_plantilla = :as_codigo;

if ll_count = 1 then 
	SELECT a.cod_art, a.desc_art
		into :ls_cod_art, :ls_desc_art
	FROM 	articulo a,
			centro_benef_articulo ca, 
			plantilla_costo pc 
	where a.cod_art = ca.cod_art 
	  and a.flag_estado = '1' 
	  and ca.centro_benef = pc.centro_benef 
	  and pc.cod_plantilla = :as_codigo;
	
	sle_articulo.text = ls_cod_art
	em_desc_art.text	= ls_desc_art
else
	sle_articulo.text = ''
	em_desc_art.text	= ''
end if

// Ahora el almacén
SELECT count( distinct a.almacen)
	into :ll_count
FROM 	almacen a,  
		vale_mov vm,  
		articulo_mov am  
where vm.almacen = a.almacen  
  and vm.nro_vale = am.nro_vale  
  and am.flag_estado <> '0'  
  and vm.flag_estado <> '0'  
  and am.cod_art = :ls_cod_art  
  and vm.tipo_mov = :is_oper_ing_prod
  and vm.cod_origen = :ls_origen;

if ll_count = 1 then
	SELECT distinct a.almacen, a.desc_almacen
		into :ls_almacen, :ls_desc_almacen
	FROM 	almacen a,  
			vale_mov vm,  
			articulo_mov am  
	where vm.almacen = a.almacen  
	  and vm.nro_vale = am.nro_vale  
	  and am.flag_estado <> '0'  
	  and vm.flag_estado <> '0'  
	  and am.cod_art = :ls_cod_art  
	  and vm.tipo_mov = :is_oper_ing_prod
	  and vm.cod_origen = :ls_origen;
	  
	sle_almacen.text 		= ls_almacen
	em_desc_almacen.text	= ls_desc_almacen	
else
	sle_almacen.text 		= ''
	em_desc_almacen.text	= ''
end if
end event

event modified;String 	ls_plantilla, ls_desc_plantilla

ls_plantilla = this.text
if ls_plantilla = '' or IsNull(ls_plantilla) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Plantilla')
	return
end if

SELECT observaciones INTO :ls_desc_plantilla
FROM 	 plantilla_costo	
WHERE  cod_plantilla =:ls_plantilla and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Plantilla de costo no existe')
	em_desc_plantilla.text = ''
	return
end if

em_desc_plantilla.text = ls_desc_plantilla	
this.event ue_datos_plantilla( ls_plantilla )
end event

type st_7 from statictext within w_pr903_guardar_costos
integer x = 206
integer y = 892
integer width = 434
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217729
long backcolor = 67108864
string text = "Almacen"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_pr903_guardar_costos
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
string text = "Guardar Costos Diarios"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_desc_art from editmask within w_pr903_guardar_costos
integer x = 987
integer y = 716
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

type sle_articulo from singlelineedit within w_pr903_guardar_costos
event dobleclick pbm_lbuttondblclk
integer x = 658
integer y = 716
integer width = 320
integer height = 72
integer taborder = 20
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
string ls_codigo, ls_data, ls_sql, ls_plantilla

ls_plantilla = sle_plantilla.text

if ls_plantilla = '' then
	MessageBox('Aviso', 'Debes Seleccionar una plantilla previamente')
	return
end if

ls_sql = "SELECT a.cod_art AS CODIGO_ARTICULO, " &
		 + "a.desc_art AS descripcion_articulo " &
		 + "FROM articulo a, " &
		 + "centro_benef_articulo ca, " &
		 + "plantilla_costo pc " &
		 + "where a.cod_art = ca.cod_art " &
		 + "and a.flag_estado = '1' " &
		 + "and ca.centro_benef = pc.centro_benef " &
		 + "and pc.cod_plantilla = '" + ls_plantilla + "' " &
  		 + "order by a.cod_art " 
		  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_desc_art.text = ls_data
end if
end event

event modified;String 	ls_cod_art, ls_desc_art

ls_cod_art = this.text
if ls_cod_art = '' or IsNull(ls_cod_art) then
	MessageBox('Aviso', 'Debe Ingresar un Articulo')
	return
end if

select desc_art
			into :ls_desc_art
		from articulo
		where cod_art = :ls_cod_art;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Articulo no existe')
	em_desc_art.text = ' '
	return
end if

em_desc_art.text = ls_desc_art
end event

type uo_fecha from u_ingreso_rango_fechas_v within w_pr903_guardar_costos
event destroy ( )
integer x = 795
integer y = 324
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

type st_2 from statictext within w_pr903_guardar_costos
integer x = 786
integer y = 240
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

type st_3 from statictext within w_pr903_guardar_costos
integer x = 206
integer y = 716
integer width = 434
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217729
long backcolor = 67108864
string text = "Articulo"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_almacen from singlelineedit within w_pr903_guardar_costos
event dobleclick pbm_lbuttondblclk
integer x = 658
integer y = 892
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

event dobleclick;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cod_art, &
			ls_origen, ls_cebe

ls_cod_art = sle_articulo.text

if ls_cod_art = '' then
	MessageBox('Aviso', 'Debe indicar un Articulo primero')
	return
end if

ls_cebe = sle_cebe.text

if ls_cebe <> '' then
	select cod_origen
		into :ls_origen
	from centro_beneficio
	where centro_benef = :ls_cebe;
	
else
	ls_origen = '%%'
end if

ls_sql = "SELECT distinct a.almacen AS CODIGO_almacen, " &
		  + "a.desc_almacen AS descripcion_almacen " &
		  + "FROM almacen a, " &
		  + "vale_mov vm, " &
		  + "articulo_mov am " &
		  + "where vm.almacen = a.almacen " &
		  + "and vm.nro_vale = am.nro_vale " &
		  + "and am.flag_estado <> '0' " &
		  + "and vm.flag_estado <> '0' " &
		  + "and am.cod_art = '" + ls_cod_art + "' " &
		  + "and vm.tipo_mov = '" + is_oper_ing_prod + "' " &
		  + "and vm.cod_origen like '" + ls_origen + "' " &
		  + "order by a.almacen " 

		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')


if ls_codigo <> '' then
	this.text = ls_codigo
	em_desc_almacen.text = ls_data
end if
end event

event modified;String 	ls_pro, ls_desc

ls_pro = this.text
if ls_pro = '' or IsNull(ls_pro) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Alamcen')
	return
end if

SELECT desc_almacen INTO :ls_desc
FROM 	 almacen	
WHERE  almacen =:ls_pro;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	em_desc_plantilla.text = ''
	return
end if

em_desc_almacen.text = ls_desc

end event

type em_desc_almacen from editmask within w_pr903_guardar_costos
integer x = 987
integer y = 892
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

type st_4 from statictext within w_pr903_guardar_costos
integer x = 206
integer y = 624
integer width = 434
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217729
long backcolor = 67108864
string text = "Plantilla"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_aceptar from picturebutton within w_pr903_guardar_costos
integer x = 1326
integer y = 1124
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

type st_6 from statictext within w_pr903_guardar_costos
integer x = 206
integer y = 804
integer width = 434
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217729
long backcolor = 67108864
string text = "Moneda"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_desc_moneda from editmask within w_pr903_guardar_costos
integer x = 987
integer y = 804
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

type sle_moneda from singlelineedit within w_pr903_guardar_costos
event dobleclick pbm_lbuttondblclk
integer x = 658
integer y = 804
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

type gb_1 from groupbox within w_pr903_guardar_costos
integer x = 142
integer y = 172
integer width = 1970
integer height = 1092
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_pr903_guardar_costos
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

