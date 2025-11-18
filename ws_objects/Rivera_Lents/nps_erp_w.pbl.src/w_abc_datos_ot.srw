$PBExportHeader$w_abc_datos_ot.srw
forward
global type w_abc_datos_ot from window
end type
type cb_2 from commandbutton within w_abc_datos_ot
end type
type sle_desc_art from singlelineedit within w_abc_datos_ot
end type
type sle_cod_art from singlelineedit within w_abc_datos_ot
end type
type st_5 from statictext within w_abc_datos_ot
end type
type sle_desc_almacen from singlelineedit within w_abc_datos_ot
end type
type cb_6 from commandbutton within w_abc_datos_ot
end type
type sle_almacen from singlelineedit within w_abc_datos_ot
end type
type st_4 from statictext within w_abc_datos_ot
end type
type cb_5 from commandbutton within w_abc_datos_ot
end type
type cb_4 from commandbutton within w_abc_datos_ot
end type
type cb_3 from commandbutton within w_abc_datos_ot
end type
type sle_ot_adm from singlelineedit within w_abc_datos_ot
end type
type st_3 from statictext within w_abc_datos_ot
end type
type sle_nro_doc from singlelineedit within w_abc_datos_ot
end type
type st_2 from statictext within w_abc_datos_ot
end type
type sle_subcateg from singlelineedit within w_abc_datos_ot
end type
type cb_1 from commandbutton within w_abc_datos_ot
end type
type uo_fecha from u_ingreso_rango_fechas within w_abc_datos_ot
end type
type st_1 from statictext within w_abc_datos_ot
end type
type sle_desc_subcateg from singlelineedit within w_abc_datos_ot
end type
type gb_1 from groupbox within w_abc_datos_ot
end type
end forward

global type w_abc_datos_ot from window
integer width = 3063
integer height = 880
boolean titlebar = true
string title = "Datos de Orden de Trabajo"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_2 cb_2
sle_desc_art sle_desc_art
sle_cod_art sle_cod_art
st_5 st_5
sle_desc_almacen sle_desc_almacen
cb_6 cb_6
sle_almacen sle_almacen
st_4 st_4
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
sle_ot_adm sle_ot_adm
st_3 st_3
sle_nro_doc sle_nro_doc
st_2 st_2
sle_subcateg sle_subcateg
cb_1 cb_1
uo_fecha uo_fecha
st_1 st_1
sle_desc_subcateg sle_desc_subcateg
gb_1 gb_1
end type
global w_abc_datos_ot w_abc_datos_ot

type variables
str_parametros istr_param 
string is_doc_ot, is_nro_cotizacion
end variables

on w_abc_datos_ot.create
this.cb_2=create cb_2
this.sle_desc_art=create sle_desc_art
this.sle_cod_art=create sle_cod_art
this.st_5=create st_5
this.sle_desc_almacen=create sle_desc_almacen
this.cb_6=create cb_6
this.sle_almacen=create sle_almacen
this.st_4=create st_4
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.sle_ot_adm=create sle_ot_adm
this.st_3=create st_3
this.sle_nro_doc=create sle_nro_doc
this.st_2=create st_2
this.sle_subcateg=create sle_subcateg
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.st_1=create st_1
this.sle_desc_subcateg=create sle_desc_subcateg
this.gb_1=create gb_1
this.Control[]={this.cb_2,&
this.sle_desc_art,&
this.sle_cod_art,&
this.st_5,&
this.sle_desc_almacen,&
this.cb_6,&
this.sle_almacen,&
this.st_4,&
this.cb_5,&
this.cb_4,&
this.cb_3,&
this.sle_ot_adm,&
this.st_3,&
this.sle_nro_doc,&
this.st_2,&
this.sle_subcateg,&
this.cb_1,&
this.uo_fecha,&
this.st_1,&
this.sle_desc_subcateg,&
this.gb_1}
end on

on w_abc_datos_ot.destroy
destroy(this.cb_2)
destroy(this.sle_desc_art)
destroy(this.sle_cod_art)
destroy(this.st_5)
destroy(this.sle_desc_almacen)
destroy(this.cb_6)
destroy(this.sle_almacen)
destroy(this.st_4)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.sle_ot_adm)
destroy(this.st_3)
destroy(this.sle_nro_doc)
destroy(this.st_2)
destroy(this.sle_subcateg)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.st_1)
destroy(this.sle_desc_subcateg)
destroy(this.gb_1)
end on

event open;Date ld_fecha1, ld_fecha2
String 	ls_cod_art, ls_desc_art, ls_nro_doc, ls_ot_adm, ls_almacen ,ls_temp

select doc_ot
	into :is_doc_ot
from logparam
where reckey = '1';

istr_param = Message.PowerObjectParm

if istr_param.tipo = 'PROG_COMPRAS' then
	//sle_nro_ot.enabled = false
	st_2.text = "Nro Programa"
	sle_ot_adm.enabled = false
	cb_3.enabled 		 = false
elseif istr_param.tipo = 'OC_DET_OS_DET' then
	st_2.text = "Orden de Compra"
	sle_ot_adm.enabled = false
	cb_3.enabled 		 = false
	
end if

if istr_param.titulo <> '' and not IsNUll(istr_param.titulo) then
	this.title = istr_param.titulo
end if

ld_fecha1 	= istr_param.fecha1
ld_fecha2 	= istr_param.fecha2
ls_cod_art 	= trim(istr_param.string1)
ls_desc_art	= trim(istr_param.string2)
ls_nro_doc	= trim(istr_param.string3)
ls_ot_adm	= trim(istr_param.string4)
ls_almacen	= trim(istr_param.string5)
is_nro_cotizacion = istr_param.nro_cotizacion

if IsNull(ld_fecha1) then ld_fecha1 = RelativeDate(Date(f_fecha_Actual(1)), -15)
if IsNull(ld_fecha2) then ld_fecha2 = RelativeDate(Date(f_fecha_Actual(1)), 15)

if Not IsNull(ls_cod_art) and ls_cod_art <> '' then
	if ls_cod_art <> '%%' then
		ls_cod_art = left(ls_cod_art, len(ls_cod_art) -1)
	else
		ls_cod_art = ''
	end if
end if

if Not IsNull(ls_desc_art) and ls_desc_art <> '' then
	if ls_desc_art <> '%%' then
		ls_desc_art = left(ls_desc_art, len(ls_desc_art) -1)
	else
		ls_desc_art = ''
	end if
end if

if Not IsNull(ls_nro_doc) and ls_nro_doc <> '' then
	if ls_nro_doc <> '%%' then
		ls_nro_doc = left(ls_nro_doc, len(ls_nro_doc) -1)
	else
		ls_nro_doc = ''
	end if
end if

if Not IsNull(ls_ot_adm) and ls_ot_adm <> '' then
	if ls_ot_adm <> '%%' then
		ls_ot_adm = left(ls_ot_adm, len(ls_ot_adm) -1)
	else
		ls_ot_adm = ''
	end if
end if

if Not IsNull(ls_almacen) and ls_almacen <> '' then
	if ls_almacen <> '%%' then
		ls_almacen = left(ls_almacen, len(ls_almacen) -1)
	else
		ls_almacen = ''
	end if
end if

uo_fecha.of_set_fecha(ld_fecha1, ld_fecha2)
sle_cod_art.text 	= ls_cod_art
sle_desc_art.text = ls_desc_art
sle_nro_doc.text	= ls_nro_doc
sle_ot_adm.text	= ls_ot_adm
sle_almacen.text	= ls_almacen

select desc_almacen
	into :ls_temp
from almacen
where almacen = :ls_almacen;

sle_desc_almacen.text = ls_temp



end event

type cb_2 from commandbutton within w_abc_datos_ot
integer x = 2249
integer y = 328
integer width = 101
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string 	ls_sql, ls_codigo, ls_data, ls_subcateg
date 		ld_fecha1, ld_fecha2

ls_subcateg = trim(sle_subcateg.text)

if ls_subcateg = '' then
	ls_subcateg = '%%'
else
	ls_subcateg = ls_subcateg + '%'
end if

ld_fecha1 = uo_Fecha.of_get_fecha1( )
ld_fecha2 = uo_Fecha.of_get_fecha2( )

if istr_param.tipo = 'PROG_COMPRAS' then
	if istr_param.flag_oc_automatico = '1' then
		ls_sql = "SELECT distinct a.cod_art AS codigo_articulo, " &
				 + "a.desc_art as descripcion_articulo, " &
				 + "a.und as unidad_articulo, " &
				 + "a2.cod_sub_cat as sub_categ, " &
				 + "a2.desc_sub_cat as desc_sub_categ " &
				 + "FROM articulo a, " &
				 + "articulo_sub_categ a2, " &
				 + "PROG_COMPRAS_DET PCD, " &
				 + "cotizacion c1, " &
				 + "cotizacion_provee c2, " &
				 + "cotizacion_provee_bien_det c3 " &				 
				 + "where a.cod_art = PCD.cod_art " &
				 + "and a2.cod_sub_cat = a.sub_cat_art " &
				 + "and c1.nro_cotiza = c2.nro_cotiza " &
				 + "and c2.nro_cotiza = c3.nro_cotiza " &
				 + "and c2.proveedor = c2.proveedor " &
				 + "and c3.cod_art = PCD.cod_art " &
				 + "and NVL(c1.flag_estado, '0') = '1' " &
				 + "and NVL(c2.cotizo, '0') = '1' " &
				 + "and NVL(c3.precio_unit, 0) > 0 " &
				 + "and NVL(c3.flag_ganador, '0') = '1' " &
				 + "and c1.nro_cotiza like '" + is_nro_cotizacion + "' " &
				 + "and PCD.flag_Estado = '1' " &
				 + "and a.flag_inventariable = '1' " &
				 + "and a.flag_estado = '1' " &
				 + "and NVL(PCD.CANT_PROYECT, 0) > NVL(PCD.CANT_PROCESADA, 0) " &
				 + "and ( PCD.NRO_AMP_OT_REF is null or " &
				 + "( PCD.NRO_AMP_OT_REF is not null and " &
				 + "USF_ALM_CANT_LIBRE_OT(PCD.ORG_AMP_OT_REF, PCD.NRO_AMP_OT_REF) > 0 ) ) " &
				 + "and to_char(PCD.FEC_REQUERIDA, 'yyyymmdd') between '" &
				 + string(ld_fecha1, 'yyyymmdd') + "' and '" &
				 + string(ld_fecha2, 'yyyymmdd') + "' " &
				 + "and a2.cod_sub_cat like '" + ls_subcateg + "'"
	else
		ls_sql = "SELECT distinct a.cod_art AS codigo_articulo, " &
				 + "a.desc_art as descripcion_articulo, " &
				 + "a.und as unidad_articulo, " &
				 + "a2.cod_sub_cat as sub_categ, " &
				 + "a2.desc_sub_cat as desc_sub_categ " &
				 + "FROM articulo a, " &
				 + "articulo_sub_categ a2, " &
				 + "PROG_COMPRAS_DET PCD " &
				 + "where a.cod_art = PCD.cod_art " &
				 + "and a2.cod_sub_cat = a.sub_cat_art " &
				 + "and PCD.flag_Estado = '1' " &
				 + "and a.flag_inventariable = '1' " &
				 + "and a.flag_estado = '1' " &
				 + "and NVL(PCD.CANT_PROYECT, 0) > NVL(PCD.CANT_PROCESADA, 0) " &
				 + "and ( PCD.NRO_AMP_OT_REF is null or " &
				 + "( PCD.NRO_AMP_OT_REF is not null and " &
				 + "USF_ALM_CANT_LIBRE_OT(PCD.ORG_AMP_OT_REF, PCD.NRO_AMP_OT_REF) > 0 ) ) " &
				 + "and to_char(PCD.FEC_REQUERIDA, 'yyyymmdd') between '" &
				 + string(ld_fecha1, 'yyyymmdd') + "' and '" &
				 + string(ld_fecha2, 'yyyymmdd') + "' " &
				 + "and a2.cod_sub_cat like '" + ls_subcateg + "'"		
	end if

else
	if istr_param.flag_oc_automatico = '1' then
		ls_sql = "SELECT distinct a.cod_art AS codigo_articulo, " &
				 + "a.desc_art as descripcion_articulo, " &
				 + "a.und as unidad_articulo, " &
				 + "a2.cod_sub_cat as cod_sub_categ, " &
				 + "a2.desc_sub_cat as desc_sub_categ " &
				 + "FROM articulo a, " &
				 + "articulo_sub_categ a2, " &
				 + "articulo_mov_proy amp, " &
				 + "cotizacion c1, " &
				 + "cotizacion_provee c2, " &
				 + "cotizacion_provee_bien_det c3 " &
				 + "where a.cod_art = amp.cod_art " &
				 + "and a2.cod_sub_cat = a.sub_cat_art " &
				 + "and c1.nro_cotiza = c2.nro_cotiza " &
				 + "and c2.nro_cotiza = c3.nro_cotiza " &
				 + "and c2.proveedor = c2.proveedor " &
				 + "and c3.cod_art = amp.cod_art " &
				 + "and NVL(c1.flag_estado, '0') = '1' " &
				 + "and NVL(c2.cotizo, '0') = '1' " &
				 + "and NVL(c3.precio_unit, 0) > 0 " &
				 + "and NVL(c3.flag_ganador, '0') = '1' " &
				 + "and c1.nro_cotiza like '" + is_nro_cotizacion + "' " &
				 + "and amp.flag_Estado = '1' " &
				 + "and a.flag_inventariable = '1' " &
				 + "and a.flag_estado = '1' " &
				 + "and amp.tipo_doc = '" + is_doc_ot + "' " &
				 + "and USF_ALM_CANT_LIBRE_OT(AMP.COD_ORIGEN, AMP.NRO_MOV) > 0 " &
				 + "and to_char(amp.fec_proyect, 'yyyymmdd') between '" &
				 + string(ld_fecha1, 'yyyymmdd') + "' and '" &
				 + string(ld_fecha2, 'yyyymmdd') + "' " &
				 + "and a2.cod_sub_cat like '" + ls_subcateg + "'"

	else
		ls_sql = "SELECT distinct a.cod_art AS codigo_articulo, " &
				 + "a.desc_art as descripcion_articulo, " &
				 + "a.und as unidad_articulo, " &
				 + "a2.cod_sub_cat as cod_sub_categ, " &
				 + "a2.desc_sub_cat as desc_sub_categ " &
				 + "FROM articulo a, " &
				 + "articulo_sub_categ a2, " &
				 + "articulo_mov_proy amp " &
				 + "where a.cod_art = amp.cod_art " &
				 + "and  a2.cod_sub_cat = a.sub_cat_art " &
				 + "and amp.flag_Estado = '1' " &
				 + "and a.flag_inventariable = '1' " &
				 + "and a.flag_estado = '1' " &
				 + "and amp.tipo_doc = '" + is_doc_ot + "' " &
				 + "and USF_ALM_CANT_LIBRE_OT(AMP.COD_ORIGEN, AMP.NRO_MOV) > 0 " &
				 + "and to_char(amp.fec_proyect, 'yyyymmdd') between '" &
				 + string(ld_fecha1, 'yyyymmdd') + "' and '" &
				 + string(ld_fecha2, 'yyyymmdd') + "' " &
				 + "and a2.cod_sub_cat like '" + ls_subcateg + "'"
	end if
end if
				 
f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	sle_cod_art.text 	= trim(ls_codigo)
	sle_desc_art.text = trim(ls_data)
end if

end event

type sle_desc_art from singlelineedit within w_abc_datos_ot
integer x = 1106
integer y = 328
integer width = 1111
integer height = 88
integer taborder = 110
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 40
borderstyle borderstyle = stylelowered!
end type

type sle_cod_art from singlelineedit within w_abc_datos_ot
integer x = 750
integer y = 328
integer width = 343
integer height = 88
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 12
borderstyle borderstyle = stylelowered!
end type

event modified;string ls_Desc, ls_codigo

ls_Codigo = this.text

select desc_almacen
	into :ls_desc
from almacen
where almacen = :ls_codigo;

sle_desc_almacen.text = ls_desc

end event

type st_5 from statictext within w_abc_datos_ot
integer x = 78
integer y = 344
integer width = 667
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Descripción de Articulo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_desc_almacen from singlelineedit within w_abc_datos_ot
integer x = 1102
integer y = 628
integer width = 1111
integer height = 88
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type cb_6 from commandbutton within w_abc_datos_ot
integer x = 2249
integer y = 628
integer width = 101
integer height = 92
integer taborder = 140
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string 	ls_sql, ls_codigo, ls_data, ls_subcateg, &
			ls_cod_art, ls_desc_art, ls_ot_adm

if trim(sle_subcateg.text) = '' then
	ls_subcateg = '%%'
else
	ls_subcateg = trim(sle_subcateg.text) + '%'
end if

if trim(sle_cod_art.text) = '' then
	ls_cod_art = '%%'
else
	ls_cod_art = trim(sle_cod_art.text) + '%'
end if

if trim(sle_desc_art.text) = '' then
	ls_desc_art = '%%'
else
	ls_desc_art = trim(sle_desc_art.text) + '%'
end if

if trim(sle_ot_adm.text ) = '' then
	ls_ot_adm = '%%'
else
	ls_ot_adm = trim(sle_ot_adm.text) + '%'
end if

if istr_param.tipo = 'PROG_COMPRAS' then
	if istr_param.flag_oc_automatico = '1' then
		ls_sql = "SELECT distinct al.almacen AS codigo_almacen, " &
				 + "al.desc_almacen as descripcion_almacen " &
				 + "FROM almacen al, " &
				 + "articulo a, " &
				 + "prog_compras_det pcd, " &
				 + "cotizacion c1, " &
				 + "cotizacion_provee c2, " &
				 + "cotizacion_provee_bien_det c3 " &				 
				 + "where al.almacen = pcd.almacen " &
				 + "and a.cod_art = pcd.cod_art " &
				 + "and c1.nro_cotiza = c2.nro_cotiza " &
				 + "and c2.nro_cotiza = c3.nro_cotiza " &
				 + "and c2.proveedor = c3.proveedor " &
				 + "and c3.cod_art = pcd.cod_art " &
				 + "and NVL(c1.flag_estado, '0') = '1' " &
				 + "and NVL(c2.cotizo, '0') = '1' " &
				 + "and NVL(c3.precio_unit, 0) > 0 " &
				 + "and NVL(c3.flag_ganador, '0') = '1' " &
				 + "and c1.nro_cotiza like '" + is_nro_cotizacion + "' " &				 
				 + "and pcd.flag_Estado = '1' " &
				 + "and a.sub_cat_art like '" + ls_subcateg + "' " &
				 + "and a.cod_art like '" + ls_cod_art + "' " &
				 + "and a.desc_art like '" + ls_desc_art + "'"
	else
		ls_sql = "SELECT distinct al.almacen AS codigo_almacen, " &
				 + "al.desc_almacen as descripcion_almacen " &
				 + "FROM almacen al, " &
				 + "articulo a, " &
				 + "prog_compras_det pcd " &
				 + "where al.almacen = pcd.almacen " &
				 + "a.cod_art = pcd.cod_art " &
				 + "and pcd.flag_Estado = '1' " &
				 + "and a.sub_cat_art like '" + ls_subcateg + "' " &
				 + "and a.cod_art like '" + ls_cod_art + "' " &
				 + "and a.desc_art like '" + ls_desc_art + "'"
	end if

else
	if istr_param.flag_oc_automatico = '1' then
		ls_sql = "SELECT distinct al.almacen AS codigo_almacen, " &
				 + "al.desc_almacen as descripcion_almacen " &
				 + "FROM almacen al, " &
				 + "articulo a, " &
				 + "articulo_mov_proy amp, " &
				 + "orden_trabajo ot, " &
				 + "cotizacion c1, " &
				 + "cotizacion_provee c2, " &
				 + "cotizacion_provee_bien_det c3 " &
				 + "where al.almacen = amp.almacen " &
				 + "and amp.cod_art = a.cod_art " &
				 + "and ot.nro_orden = amp.nro_doc " &
				 + "and c1.nro_cotiza = c2.nro_cotiza " &
				 + "and c2.nro_cotiza = c3.nro_cotiza " &
				 + "and c2.proveedor = c3.proveedor " &
				 + "and c3.cod_art = amp.cod_art " &
				 + "and NVL(c1.flag_estado, '0') = '1' " &
				 + "and NVL(c2.cotizo, '0') = '1' " &
				 + "and NVL(c3.precio_unit, 0) > 0 " &
				 + "and NVL(c3.flag_ganador, '0') = '1' " &
				 + "and c1.nro_cotiza like '" + is_nro_cotizacion + "' " &
				 + "and amp.flag_Estado = '1' " &
				 + "and amp.tipo_doc = '" + is_doc_ot + "' " &
				 + "and a.sub_cat_art like '" + ls_subcateg + "' " &
				 + "and a.cod_art like '" + ls_cod_art + "' " &
				 + "and a.desc_art like '" + ls_desc_art + "' " &
				 + "and ot.ot_adm like '" + ls_ot_adm + "'"
	else
		ls_sql = "SELECT distinct al.almacen AS codigo_almacen, " &
				 + "al.desc_almacen as descripcion_almacen " &
				 + "FROM almacen al, " &
				 + "articulo a, " &
				 + "orden_trabajo ot, " &
				 + "articulo_mov_proy amp " &
				 + "where al.almacen = amp.almacen " &
				 + "and amp.cod_art = a.cod_art " &
				 + "and ot.nro_orden = amp.nro_doc " &
				 + "and amp.flag_Estado = '1' " &
				 + "and amp.tipo_doc = '" + is_doc_ot + "' " &
				 + "and a.sub_cat_art like '" + ls_subcateg + "' " &
				 + "and a.cod_art like '" + ls_cod_art + "' " &
				 + "and a.desc_art like '" + ls_desc_art + "' " &
				 + "and ot.ot_adm like '" + ls_ot_adm + "'"
	end if
end if

				 
f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	sle_almacen.text 		 = ls_codigo
	sle_desc_almacen.text = ls_data
end if
end event

type sle_almacen from singlelineedit within w_abc_datos_ot
integer x = 750
integer y = 628
integer width = 343
integer height = 88
integer taborder = 130
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event modified;string ls_Desc, ls_codigo

ls_Codigo = this.text

select desc_almacen
	into :ls_desc
from almacen
where almacen = :ls_codigo;

sle_desc_almacen.text = ls_desc


end event

type st_4 from statictext within w_abc_datos_ot
integer x = 78
integer y = 644
integer width = 667
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Almacén:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_5 from commandbutton within w_abc_datos_ot
integer x = 2601
integer y = 168
integer width = 398
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;istr_param.titulo = 'n'

CloseWithReturn(Parent,istr_param)
end event

type cb_4 from commandbutton within w_abc_datos_ot
integer x = 2601
integer y = 48
integer width = 398
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;String 	ls_cod_art, ls_desc_art, ls_nro_doc, ls_ot_adm, &
			ls_almacen, ls_subcateg
Date		ld_fecha1, ld_fecha2

ld_fecha1	= uo_fecha.of_get_fecha1()
ld_fecha2 	= uo_fecha.of_get_fecha2()
ls_cod_art	= Trim(sle_cod_art.text)
ls_desc_art	= Trim(sle_desc_art.text)
ls_nro_doc	= Trim(sle_nro_doc.text)
ls_ot_adm	= Trim(sle_ot_adm.text)
ls_almacen	= Trim(sle_almacen.text)
ls_subcateg = Trim(sle_subcateg.text)

if Isnull(ls_cod_art) OR trim(ls_cod_art) = '' then
	ls_cod_art = '%'	
else
	ls_cod_art = ls_cod_art + '%'
end if

if Isnull(ls_desc_art) OR trim(ls_desc_art) = '' then
	ls_desc_art = '%'	
else
	ls_desc_art = ls_desc_art + '%'
end if

if Isnull(ls_nro_doc) OR trim(ls_nro_doc) = '' then
	ls_nro_doc = '%'	
else
	ls_nro_doc = ls_nro_doc + '%'
end if

if Isnull(ls_ot_adm) OR trim(ls_ot_adm) = '' then
	ls_ot_adm = '%'
else
	ls_ot_adm = ls_ot_adm + '%'	
end if

if Isnull(ls_almacen) OR trim(ls_almacen) = '' then
	ls_almacen = '%'
else
	ls_almacen = ls_almacen + '%'	
end if

if Isnull(ls_subcateg) OR trim(ls_subcateg) = '' then
	ls_subcateg = '%'
else
	ls_subcateg = ls_subcateg + '%'	
end if

if ld_fecha1 > ld_fecha2 then
	MessageBox('Aviso', 'Rango de Fechas incorrecto')
	return
end if

istr_param.fecha1 		= ld_Fecha1 	//fecha_inicial
istr_param.fecha2 		= ld_fecha2	  	//fecha_final
istr_param.string1		= ls_cod_art 	//cod_art 
istr_param.string2		= ls_desc_art 	//desc_art
istr_param.string3		= ls_nro_doc 	//orden_trabajo
istr_param.string4		= ls_ot_adm 	//ot_adm
istr_param.string5		= ls_almacen 	//Almacen
istr_param.cod_subcateg	= ls_subcateg 	//Codigo Subcateg

CloseWithReturn(Parent,istr_param)
end event

type cb_3 from commandbutton within w_abc_datos_ot
integer x = 1120
integer y = 528
integer width = 101
integer height = 92
integer taborder = 120
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string ls_sql, ls_codigo, ls_data, ls_subcateg

if sle_subcateg.text = '' then
	ls_subcateg = '%%'
else
	ls_subcateg = trim(sle_subcateg.text) + '%'
end if

if istr_param.flag_oc_automatico = '1' then
	ls_sql = "SELECT distinct ota.ot_adm as codigo_ot_adm, " &
			 + "ota.descripcion as descripcion_ot_adm " &
			 + "FROM orden_trabajo ot, " &
			 + "articulo_mov_proy amp, " &
			 + "ot_administracion ota, " &
			 + "articulo a, " &
			 + "cotizacion c1, " &
			 + "cotizacion_provee c2, " &
			 + "cotizacion_provee_bien_det c3 " &
			 + "where ota.ot_adm = ot.ot_adm " &
			 + "and amp.nro_doc = ot.nro_orden " &
			 + "and amp.cod_art = a.cod_art " &
			 + "and c1.nro_cotiza = c2.nro_cotiza " &
			 + "and c2.nro_cotiza = c3.nro_cotiza " &
			 + "and c2.proveedor = c3.proveedor " &
			 + "and c3.cod_art = amp.cod_art " &
			 + "and NVL(c1.flag_estado, '0') = '1' " &
			 + "and NVL(c2.cotizo, '0') = '1' " &
			 + "and NVL(c3.precio_unit, 0) > 0 " &
			 + "and NVL(c3.flag_ganador, '0') = '1' " &
			 + "and c1.nro_cotiza like '" + is_nro_cotizacion + "' " &
			 + "and amp.tipo_doc = '" + is_doc_ot + "'" &
			 + "and amp.flag_estado = '1' " &
			 + "and a.sub_cat_art like '" + ls_subcateg + "'"

else
	ls_sql = "SELECT distinct ota.ot_adm as codigo_ot_adm, " &
			 + "ota.descripcion as descripcion_ot_adm " &
			 + "FROM orden_trabajo ot, " &
			 + "articulo_mov_proy amp, " &
			 + "ot_administracion ota, " &
			 + "articulo a " &
			 + "where ota.ot_adm = ot.ot_adm " &
			 + "and amp.nro_doc = ot.nro_orden " &
			 + "and amp.cod_art = a.cod_art " &
			 + "and amp.tipo_doc = '" + is_doc_ot + "'" &
			 + "and amp.flag_estado = '1' " &
			 + "and a.sub_cat_art like '" + ls_subcateg + "'"
end if
				 
f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	sle_ot_adm.text 		 = ls_codigo
end if
end event

type sle_ot_adm from singlelineedit within w_abc_datos_ot
integer x = 750
integer y = 528
integer width = 343
integer height = 88
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_abc_datos_ot
integer x = 78
integer y = 544
integer width = 667
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "OT Adm. :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_nro_doc from singlelineedit within w_abc_datos_ot
integer x = 750
integer y = 428
integer width = 343
integer height = 88
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_abc_datos_ot
integer x = 78
integer y = 444
integer width = 667
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Nro OT :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_subcateg from singlelineedit within w_abc_datos_ot
integer x = 750
integer y = 228
integer width = 343
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 12
borderstyle borderstyle = stylelowered!
end type

event modified;string ls_Desc, ls_codigo

ls_Codigo = this.text

select desc_almacen
	into :ls_desc
from almacen
where almacen = :ls_codigo;

sle_desc_almacen.text = ls_desc

end event

type cb_1 from commandbutton within w_abc_datos_ot
integer x = 2249
integer y = 228
integer width = 101
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string 	ls_sql, ls_codigo, ls_data, ls_almacen
date 		ld_fecha1, ld_fecha2

ld_fecha1 = uo_Fecha.of_get_fecha1( )
ld_fecha2 = uo_Fecha.of_get_fecha2( )

if sle_almacen.text = '' then
	ls_almacen = '%%'
else
	ls_almacen = trim(sle_almacen.text) + '%'
end if

if istr_param.tipo = 'PROG_COMPRAS' then
	if istr_param.flag_oc_automatico = '1' then
		ls_sql = "SELECT distinct a2.cod_sub_cat as codigo_subcateg, " &
				 + "a2.desc_sub_cat as desc_sub_categ " &
				 + "FROM articulo a, " &
				 + "articulo_sub_categ a2, " &
				 + "PROG_COMPRAS_DET PCD, " &
				 + "cotizacion c1, " &
				 + "cotizacion_provee c2, " &
				 + "cotizacion_provee_bien_det c3 " &
				 + "where a.cod_art = PCD.cod_art " &
				 + "and a2.cod_sub_cat = a.sub_cat_art " &
				 + "and c1.nro_cotiza = c2.nro_cotiza " &
				 + "and c2.nro_cotiza = c3.nro_cotiza " &
				 + "and c2.proveedor = c3.proveedor " &
				 + "and c3.cod_art = PCD.cod_art " &
				 + "and NVL(c1.flag_estado, '0') = '1' " &
				 + "and NVL(c2.cotizo, '0') = '1' " &
				 + "and NVL(c3.precio_unit, 0) > 0 " &
				 + "and NVL(c3.flag_ganador, '0') = '1' " &
				 + "and c1.nro_cotiza like '" + is_nro_cotizacion + "' " &
				 + "and PCD.flag_Estado = '1' " &
				 + "and a.flag_inventariable = '1' " &
				 + "and a.flag_estado = '1' " &
				 + "and NVL(PCD.CANT_PROYECT, 0) > NVL(PCD.CANT_PROCESADA, 0) " &
				 + "and ( PCD.NRO_AMP_OT_REF is null or " &
				 + "( PCD.NRO_AMP_OT_REF is not null and " &
				 + "USF_ALM_CANT_LIBRE_OT(PCD.ORG_AMP_OT_REF, PCD.NRO_AMP_OT_REF) > 0 ) ) " &
				 + "and to_char(PCD.FEC_REQUERIDA, 'yyyymmdd') between '" &
				 + string(ld_fecha1, 'yyyymmdd') + "' and '" &
				 + string(ld_fecha2, 'yyyymmdd') + "' " &
				 + "and PCD.almacen like '" + ls_almacen + "'"
	else
		ls_sql = "SELECT distinct a2.cod_sub_cat as codigo_subcateg, " &
				 + "a2.desc_sub_cat as desc_sub_categ " &
				 + "FROM articulo a, " &
				 + "articulo_sub_categ a2, " &
				 + "PROG_COMPRAS_DET PCD " &
				 + "where a.cod_art = PCD.cod_art " &
				 + "and a2.cod_sub_cat = a.sub_cat_art " &
				 + "and PCD.flag_Estado = '1' " &
				 + "and a.flag_inventariable = '1' " &
				 + "and a.flag_estado = '1' " &
				 + "and NVL(PCD.CANT_PROYECT, 0) > NVL(PCD.CANT_PROCESADA, 0) " &
				 + "and ( PCD.NRO_AMP_OT_REF is null or " &
				 + "( PCD.NRO_AMP_OT_REF is not null and " &
				 + "USF_ALM_CANT_LIBRE_OT(PCD.ORG_AMP_OT_REF, PCD.NRO_AMP_OT_REF) > 0 ) ) " &
				 + "and to_char(PCD.FEC_REQUERIDA, 'yyyymmdd') between '" &
				 + string(ld_fecha1, 'yyyymmdd') + "' and '" &
				 + string(ld_fecha2, 'yyyymmdd') + "' " &
				 + "and PCD.almacen like '" + ls_almacen + "'"
	end if
else
	if istr_param.flag_oc_automatico = '1' then
		// Generar Una OC automática de datos de una OT
		ls_sql = "SELECT distinct a2.cod_sub_cat as codigo_subcateg, " &
				 + "a2.desc_sub_cat as desc_sub_categ " &
				 + "FROM articulo a, " &
				 + "articulo_sub_categ a2, " &
				 + "articulo_mov_proy amp, " &
				 + "cotizacion c1, " &
				 + "cotizacion_provee c2, " &
				 + "cotizacion_provee_bien_det c3 " &
				 + "where a.cod_art = amp.cod_art " &
				 + "and a2.cod_sub_cat = a.sub_cat_art " &
				 + "and c1.nro_cotiza = c2.nro_cotiza " &
				 + "and c2.nro_cotiza = c3.nro_cotiza " &
				 + "and c2.proveedor = c3.proveedor " &
				 + "and c3.cod_art = amp.cod_art " &
				 + "and amp.flag_Estado = '1' " &
				 + "and a.flag_inventariable = '1' " &
				 + "and a.flag_estado = '1' " &
				 + "and NVL(c1.flag_estado, '0') = '1' " &
				 + "and NVL(c2.cotizo, '0') = '1' " &
				 + "and NVL(c3.precio_unit, 0) > 0 " &
				 + "and NVL(c3.flag_ganador, '0') = '1' " &
				 + "and c1.nro_cotiza like '" + is_nro_cotizacion + "' " &
				 + "and nVL(amp.cant_proyect,0) > NVL(amp.cant_procesada,0) " &
				 + "and amp.tipo_doc = '" + is_doc_ot + "' " &
				 + "and USF_ALM_CANT_LIBRE_OT(AMP.COD_ORIGEN, AMP.NRO_MOV) > 0 " &
				 + "and to_char(amp.fec_proyect, 'yyyymmdd') between '" &
				 + string(ld_fecha1, 'yyyymmdd') + "' and '" &
				 + string(ld_fecha2, 'yyyymmdd') + "' " &
				 + "and AMP.almacen like '" + ls_almacen + "'"
	else
		ls_sql = "SELECT distinct a2.cod_sub_cat as codigo_subcateg, " &
				 + "a2.desc_sub_cat as desc_sub_categ " &
				 + "FROM articulo a, " &
				 + "articulo_sub_categ a2, " &
				 + "articulo_mov_proy amp " &
				 + "where a.cod_art = amp.cod_art " &
				 + "and  a2.cod_sub_cat = a.sub_cat_art " &
				 + "and amp.flag_Estado = '1' " &
				 + "and a.flag_inventariable = '1' " &
				 + "and a.flag_estado = '1' " &
				 + "and nVL(amp.cant_proyect,0) > NVL(amp.cant_procesada,0) " &
				 + "and amp.tipo_doc = '" + is_doc_ot + "' " &
				 + "and USF_ALM_CANT_LIBRE_OT(AMP.COD_ORIGEN, AMP.NRO_MOV) > 0 " &
				 + "and to_char(amp.fec_proyect, 'yyyymmdd') between '" &
				 + string(ld_fecha1, 'yyyymmdd') + "' and '" &
				 + string(ld_fecha2, 'yyyymmdd') + "' " &
				 + "and AMP.almacen like '" + ls_almacen + "'"
	end if
end if
				 
f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	sle_subcateg.text 	= trim(ls_codigo)
	sle_desc_subcateg.text = trim(ls_data)
end if

end event

type uo_fecha from u_ingreso_rango_fechas within w_abc_datos_ot
integer x = 82
integer y = 124
integer taborder = 70
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

type st_1 from statictext within w_abc_datos_ot
integer x = 78
integer y = 248
integer width = 667
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Subcategoría :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_desc_subcateg from singlelineedit within w_abc_datos_ot
integer x = 1106
integer y = 228
integer width = 1111
integer height = 88
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
textcase textcase = upper!
integer limit = 40
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_abc_datos_ot
integer width = 2551
integer height = 760
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Datos de Recuperación"
end type

