$PBExportHeader$w_com903_genera_os.srw
forward
global type w_com903_genera_os from w_abc
end type
type cbx_add_igv_os from checkbox within w_com903_genera_os
end type
type sle_importe from singlelineedit within w_com903_genera_os
end type
type gb_5 from groupbox within w_com903_genera_os
end type
type st_desc_tipo_comedor from statictext within w_com903_genera_os
end type
type sle_tipo_comedor from singlelineedit within w_com903_genera_os
end type
type st_8 from statictext within w_com903_genera_os
end type
type em_1 from editmask within w_com903_genera_os
end type
type em_origen from singlelineedit within w_com903_genera_os
end type
type sle_moneda from singlelineedit within w_com903_genera_os
end type
type em_desc_moneda from editmask within w_com903_genera_os
end type
type st_6 from statictext within w_com903_genera_os
end type
type cb_aceptar from picturebutton within w_com903_genera_os
end type
type st_nro_os from statictext within w_com903_genera_os
end type
type st_os from statictext within w_com903_genera_os
end type
type st_5 from statictext within w_com903_genera_os
end type
type sle_desc from singlelineedit within w_com903_genera_os
end type
type st_4 from statictext within w_com903_genera_os
end type
type em_nom_prove from editmask within w_com903_genera_os
end type
type sle_proveedor from singlelineedit within w_com903_genera_os
end type
type st_3 from statictext within w_com903_genera_os
end type
type st_2 from statictext within w_com903_genera_os
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_com903_genera_os
end type
type em_servicio from singlelineedit within w_com903_genera_os
end type
type em_descripcion from editmask within w_com903_genera_os
end type
type gb_3 from groupbox within w_com903_genera_os
end type
type gb_1 from groupbox within w_com903_genera_os
end type
type gb_2 from groupbox within w_com903_genera_os
end type
type gb_4 from groupbox within w_com903_genera_os
end type
type rb_1 from radiobutton within w_com903_genera_os
end type
type rb_2 from radiobutton within w_com903_genera_os
end type
type cbx_incluye_igv from checkbox within w_com903_genera_os
end type
end forward

global type w_com903_genera_os from w_abc
integer width = 2030
integer height = 1720
string title = "Generar Orden de Servicio(COM903)"
string menuname = "m_impresion_1"
boolean resizable = false
boolean center = true
event ue_generar_os ( )
cbx_add_igv_os cbx_add_igv_os
sle_importe sle_importe
gb_5 gb_5
st_desc_tipo_comedor st_desc_tipo_comedor
sle_tipo_comedor sle_tipo_comedor
st_8 st_8
em_1 em_1
em_origen em_origen
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
gb_3 gb_3
gb_1 gb_1
gb_2 gb_2
gb_4 gb_4
rb_1 rb_1
rb_2 rb_2
cbx_incluye_igv cbx_incluye_igv
end type
global w_com903_genera_os w_com903_genera_os

type variables

end variables

event ue_generar_os();// Para Generer la Orden de Servicio Usando el Procedimiento

//if MessageBox('Sistema de Comedores','Esta seguro de realizar esta operacion',Question!,yesno!) = 2 then
//					return
//End if

string 	ls_servicio, ls_proveedor, ls_descripcion, &
			ls_mensaje, ls_nro_os, ls_moneda, ls_flag_incluye_igv, ls_tipo_comedor, &
			ls_flag_fondo, ls_flag_importe, ls_flag_add_igv_os
date 		ld_fecha_ini, ld_fecha_fin
decimal	ldc_importe

ld_fecha_ini 		= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 		= date(uo_fecha.of_get_fecha2( ))

ls_servicio			= em_servicio.text
ls_proveedor		= sle_proveedor.text
ls_descripcion		= sle_desc.text
ls_moneda			= sle_moneda.text

ls_tipo_comedor = sle_tipo_comedor.text

if IsNull(ls_tipo_comedor) or ls_tipo_comedor = '' then
	MessageBox('COMEDOR', 'NO HA SELECCIONADO UN TIPO DE COMEDOR',StopSign!)
	return
end if

if cbx_incluye_igv.checked = true then
	ls_flag_incluye_igv = '1'
ELSE
	ls_flag_incluye_igv = '0'
END IF

if cbx_add_igv_os.checked = true then
	ls_flag_add_igv_os = '1'
ELSE
	ls_flag_add_igv_os = '0'
END IF



if rb_2.checked then
	ldc_importe = dec(sle_importe.text)
	if ldc_importe = 0 then
		MessageBox('Error', 'Debe ingresar un importe')
		return
	end if
elseif rb_1.checked then
	ldc_importe = 0
end if

if IsNull(ls_servicio) or ls_servicio = '' then
	MessageBox('COMEDORES', 'NO HA INGRESO UN SERVICIO VALIDO',StopSign!)
	return
end if

if IsNull(ls_proveedor) or ls_proveedor = '' then
	MessageBox('COMEDORES', 'NO HA INGRESO UN PROVEEDOR VALIDO',StopSign!)
	return
end if

if IsNull(ls_descripcion) or ls_descripcion = '' then
	MessageBox('COMEDORES', 'NO HA INGRESO UNA DESCRIPCIÓN VALIDA',StopSign!)
	return
end if

//CREATE OR REPLACE PROCEDURE USP_COM_GENERA_OS(
//    asi_origen              IN   origen.cod_origen%Type,
//    adi_fecha_ini           IN   date,
//    adi_fecha_fin           IN   date,
//    asi_servicio            IN   servicios.servicio%Type,
//    asi_usuario             IN   usuario.cod_usr%Type,
//    asi_descripcion         IN   orden_servicio.descripcion%Type,
//    asi_proveedor           IN   orden_servicio.proveedor%Type,
//    asi_cod_moneda          IN   com_parte_rac.cod_moneda%Type,
//    asi_tipo_comedor        IN   com_tipo_comed.tipo_comedor%TYPE,
//    asi_incluye_igv         IN   VARCHAR2,
//    asi_add_igv_os          IN   VARCHAR2,
//    ani_importe             IN   number,
//    aso_nro_os              OUT  orden_servicio.nro_os%TYPE
//)

DECLARE 	USP_COM_GENERA_OS PROCEDURE FOR
			USP_COM_GENERA_OS( :gs_origen, 
									 :ld_fecha_ini, 
									 :ld_fecha_fin, 
									 :ls_servicio, 
									 :gs_user, 
									 :ls_descripcion, 
									 :ls_proveedor, 
									 :ls_moneda,
									 :ls_tipo_comedor,
									 :ls_flag_incluye_igv,
									 :ls_flag_add_igv_os,
									 :ldc_importe) ;
EXECUTE 	USP_COM_GENERA_OS ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_COM_GENERA_OS: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH USP_COM_GENERA_OS INTO :ls_nro_os;
CLOSE USP_COM_GENERA_OS;

MessageBox('COMEDORES', 'PROCESO REALIZADO DE MANERA SATISFACTORIA', Information!)
st_nro_os.visible = true
st_nro_os.text 	= trim(ls_nro_os)
return
end event

on w_com903_genera_os.create
int iCurrent
call super::create
if this.MenuName = "m_impresion_1" then this.MenuID = create m_impresion_1
this.cbx_add_igv_os=create cbx_add_igv_os
this.sle_importe=create sle_importe
this.gb_5=create gb_5
this.st_desc_tipo_comedor=create st_desc_tipo_comedor
this.sle_tipo_comedor=create sle_tipo_comedor
this.st_8=create st_8
this.em_1=create em_1
this.em_origen=create em_origen
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
this.gb_3=create gb_3
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_4=create gb_4
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cbx_incluye_igv=create cbx_incluye_igv
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_add_igv_os
this.Control[iCurrent+2]=this.sle_importe
this.Control[iCurrent+3]=this.gb_5
this.Control[iCurrent+4]=this.st_desc_tipo_comedor
this.Control[iCurrent+5]=this.sle_tipo_comedor
this.Control[iCurrent+6]=this.st_8
this.Control[iCurrent+7]=this.em_1
this.Control[iCurrent+8]=this.em_origen
this.Control[iCurrent+9]=this.sle_moneda
this.Control[iCurrent+10]=this.em_desc_moneda
this.Control[iCurrent+11]=this.st_6
this.Control[iCurrent+12]=this.cb_aceptar
this.Control[iCurrent+13]=this.st_nro_os
this.Control[iCurrent+14]=this.st_os
this.Control[iCurrent+15]=this.st_5
this.Control[iCurrent+16]=this.sle_desc
this.Control[iCurrent+17]=this.st_4
this.Control[iCurrent+18]=this.em_nom_prove
this.Control[iCurrent+19]=this.sle_proveedor
this.Control[iCurrent+20]=this.st_3
this.Control[iCurrent+21]=this.st_2
this.Control[iCurrent+22]=this.uo_fecha
this.Control[iCurrent+23]=this.em_servicio
this.Control[iCurrent+24]=this.em_descripcion
this.Control[iCurrent+25]=this.gb_3
this.Control[iCurrent+26]=this.gb_1
this.Control[iCurrent+27]=this.gb_2
this.Control[iCurrent+28]=this.gb_4
this.Control[iCurrent+29]=this.rb_1
this.Control[iCurrent+30]=this.rb_2
this.Control[iCurrent+31]=this.cbx_incluye_igv
end on

on w_com903_genera_os.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_add_igv_os)
destroy(this.sle_importe)
destroy(this.gb_5)
destroy(this.st_desc_tipo_comedor)
destroy(this.sle_tipo_comedor)
destroy(this.st_8)
destroy(this.em_1)
destroy(this.em_origen)
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
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_4)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cbx_incluye_igv)
end on

event open;call super::open;//// Override
//THIS.EVENT ue_open_pre()
end event

event ue_open_pre;////Override
//
//sg_parametros  ls_param
//
//ls_param  	= message.PowerObjectParm
//
//is_moneda	= ls_param.string1

string ls_servicio, ls_desc_servicio

select s.servicio, s.descripcion
	into :ls_servicio, :ls_desc_servicio
from servicios s, comedor_param c
	where s.servicio = c.servicio_com;
	
	em_servicio.text = ls_servicio
	em_descripcion.text = ls_desc_servicio
	

end event

event ue_print;call super::ue_print;STRING ls_cod_rel, ls_nro_os

sg_parametros lstr_rep

ls_cod_rel = st_nro_os.text
ls_nro_os  = st_nro_os.text

lstr_rep.string1 = ls_cod_rel
lstr_rep.string2 = ls_nro_os
OpenSheetWithParm(w_cm314_orden_servicio_frm, lstr_rep, This, 2, layered!)


end event

event resize;call super::resize;gb_1.width = newwidth  - gb_1.x - 10
gb_1.height = newheight - gb_1.y - 10
end event

type cbx_add_igv_os from checkbox within w_com903_genera_os
integer x = 1216
integer y = 400
integer width = 658
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 32768
long backcolor = 67108864
string text = "Añadir el IGV en la OS"
boolean checked = true
end type

event clicked;if this.checked then
	cbx_incluye_igv.enabled = true
else
	cbx_incluye_igv.enabled = false
	cbx_incluye_igv.checked = false
end if
end event

type sle_importe from singlelineedit within w_com903_genera_os
integer x = 603
integer y = 472
integer width = 306
integer height = 100
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
string text = "0.00"
borderstyle borderstyle = stylelowered!
boolean hideselection = false
boolean righttoleft = true
end type

type gb_5 from groupbox within w_com903_genera_os
integer x = 18
integer y = 316
integer width = 1897
integer height = 296
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 32768
long backcolor = 79741120
string text = "Seleccionar Costo"
end type

type st_desc_tipo_comedor from statictext within w_com903_genera_os
integer x = 869
integer y = 664
integer width = 1038
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12639424
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_tipo_comedor from singlelineedit within w_com903_genera_os
event ue_dobleclick pbm_lbuttondblclk
integer x = 571
integer y = 664
integer width = 283
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql
ls_sql = "SELECT tipo_comedor AS tipo_comedor, " &
		  + "DESCR_COMEDOR AS descripcion_tipo " &
		  + "FROM com_tipo_comed " &
		  + "WHERE FLAG_ESTADO = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text = ls_codigo
	st_desc_tipo_comedor.text = ls_data
end if


end event

event modified;string ls_data, ls_null, ls_texto

SetNull(ls_null)

ls_texto = this.text

select DESCR_COMEDOR
	into :ls_data
from com_tipo_comed
where TIPO_COMEDOR = :ls_texto
  and flag_estado = '1';

if SQLCA.SQLCode = 100 then
	Messagebox('COMEDOR', "TIPO DE COMEDOR NO EXISTE O NO ESTA ACTIVO", StopSign!)
	this.text = ls_null
	st_desc_tipo_comedor.text = ls_null
	return 1
end if

st_desc_tipo_comedor.text = ls_data


end event

type st_8 from statictext within w_com903_genera_os
integer x = 87
integer y = 668
integer width = 471
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 32768
long backcolor = 67108864
string text = "Tipo de Comedor"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_1 from editmask within w_com903_genera_os
integer x = 183
integer y = 180
integer width = 923
integer height = 72
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from singlelineedit within w_com903_genera_os
event dobleclick pbm_lbuttondblclk
integer x = 41
integer y = 180
integer width = 128
integer height = 72
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  cod_origen as codigo, " & 
		  +"nombre AS DESCRIPCION " &
		  + "FROM origen " &
		  + "WHERE flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

event modified;String 	ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
	return
end if

SELECT nombre INTO :ls_desc
FROM origen
WHERE cod_origen =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe')
	return
end if

em_descripcion.text = ls_desc

end event

type sle_moneda from singlelineedit within w_com903_genera_os
event dobleclick pbm_lbuttondblclk
integer x = 571
integer y = 844
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

type em_desc_moneda from editmask within w_com903_genera_os
integer x = 869
integer y = 844
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

type st_6 from statictext within w_com903_genera_os
integer x = 87
integer y = 844
integer width = 471
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 32768
long backcolor = 67108864
string text = "Moneda"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_aceptar from picturebutton within w_com903_genera_os
integer x = 96
integer y = 1336
integer width = 530
integer height = 132
integer taborder = 80
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

type st_nro_os from statictext within w_com903_genera_os
boolean visible = false
integer x = 1216
integer y = 1340
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

type st_os from statictext within w_com903_genera_os
integer x = 718
integer y = 1332
integer width = 507
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
boolean focusrectangle = false
end type

type st_5 from statictext within w_com903_genera_os
integer x = 91
integer y = 1020
integer width = 1815
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 32768
long backcolor = 67108864
string text = "Descripción"
boolean focusrectangle = false
end type

type sle_desc from singlelineedit within w_com903_genera_os
integer x = 91
integer y = 1104
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

type st_4 from statictext within w_com903_genera_os
integer x = 87
integer y = 924
integer width = 471
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 32768
long backcolor = 67108864
string text = "Proveedor"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_nom_prove from editmask within w_com903_genera_os
integer x = 869
integer y = 928
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

type sle_proveedor from singlelineedit within w_com903_genera_os
event dobleclick pbm_lbuttondblclk
integer x = 571
integer y = 928
integer width = 283
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
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT P.PROVEEDOR as Código, " & 
		  +"P.NOM_PROVEEDOR AS Nombre " &
		  + "FROM PROVEEDOR P " &
		  + "WHERE P.flag_estado = '1' and proveedor in (Select p.proveedor from com_parte_rac p)"
		  
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

type st_3 from statictext within w_com903_genera_os
integer x = 87
integer y = 756
integer width = 471
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 32768
long backcolor = 67108864
string text = "Servicio"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_com903_genera_os
integer x = 1349
integer y = 108
integer width = 622
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 32768
long backcolor = 67108864
string text = "Rango de Fechas"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_rango_fechas_v within w_com903_genera_os
integer x = 1362
integer y = 92
integer height = 220
integer taborder = 40
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

type em_servicio from singlelineedit within w_com903_genera_os
event dobleclick pbm_lbuttondblclk
integer x = 571
integer y = 756
integer width = 283
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean enabled = false
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

type em_descripcion from editmask within w_com903_genera_os
integer x = 869
integer y = 756
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

type gb_3 from groupbox within w_com903_genera_os
integer x = 18
integer y = 96
integer width = 1326
integer height = 216
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 32768
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_1 from groupbox within w_com903_genera_os
integer width = 2007
integer height = 1556
integer taborder = 20
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Generar OS para comedores"
end type

type gb_2 from groupbox within w_com903_genera_os
integer x = 105
integer y = 96
integer width = 1157
integer height = 216
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 32768
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_4 from groupbox within w_com903_genera_os
integer x = 105
integer y = 96
integer width = 1157
integer height = 216
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 32768
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type rb_1 from radiobutton within w_com903_genera_os
integer x = 37
integer y = 376
integer width = 832
integer height = 96
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Considerar el costo de la ración"
boolean checked = true
end type

event clicked;sle_importe.enabled = false

end event

type rb_2 from radiobutton within w_com903_genera_os
integer x = 37
integer y = 472
integer width = 562
integer height = 96
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Distribuir un importe"
end type

event clicked;sle_importe.enabled = true

end event

type cbx_incluye_igv from checkbox within w_com903_genera_os
integer x = 1216
integer y = 484
integer width = 658
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 32768
long backcolor = 67108864
string text = "Importe incluye el IGV"
boolean checked = true
end type

