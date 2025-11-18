$PBExportHeader$w_pr709_asistencia_fechas.srw
forward
global type w_pr709_asistencia_fechas from w_cns_smpl
end type
type uo_rango from ou_rango_fechas within w_pr709_asistencia_fechas
end type
type cbx_ot_adm from checkbox within w_pr709_asistencia_fechas
end type
type em_ot_adm from singlelineedit within w_pr709_asistencia_fechas
end type
type em_descripcion_n from singlelineedit within w_pr709_asistencia_fechas
end type
type em_descripcion from editmask within w_pr709_asistencia_fechas
end type
type em_origen from singlelineedit within w_pr709_asistencia_fechas
end type
type pb_2 from picturebutton within w_pr709_asistencia_fechas
end type
type st_1 from statictext within w_pr709_asistencia_fechas
end type
type sle_nombre from singlelineedit within w_pr709_asistencia_fechas
end type
type sle_codigo from singlelineedit within w_pr709_asistencia_fechas
end type
type cbx_trabajador from checkbox within w_pr709_asistencia_fechas
end type
type gb_3 from groupbox within w_pr709_asistencia_fechas
end type
type gb_1 from groupbox within w_pr709_asistencia_fechas
end type
type gb_2 from groupbox within w_pr709_asistencia_fechas
end type
type gb_4 from groupbox within w_pr709_asistencia_fechas
end type
end forward

global type w_pr709_asistencia_fechas from w_cns_smpl
integer width = 3657
integer height = 2428
string title = "Asistencia de Jornaleros por periodo(PR709)"
string menuname = "m_reporte"
event ue_query_retrieve ( )
uo_rango uo_rango
cbx_ot_adm cbx_ot_adm
em_ot_adm em_ot_adm
em_descripcion_n em_descripcion_n
em_descripcion em_descripcion
em_origen em_origen
pb_2 pb_2
st_1 st_1
sle_nombre sle_nombre
sle_codigo sle_codigo
cbx_trabajador cbx_trabajador
gb_3 gb_3
gb_1 gb_1
gb_2 gb_2
gb_4 gb_4
end type
global w_pr709_asistencia_fechas w_pr709_asistencia_fechas

type variables

end variables

event ue_query_retrieve();long ll_retrieve
string ls_cod_origen, ls_fecha, ls_periodo, ls_ot_adm, ls_cod_trabajador
date ld_ini, ld_fin

dw_cns.reset( )
dw_cns.visible = false

ld_ini 				= uo_rango.of_get_fecha1()
ld_fin 				= uo_rango.of_get_fecha2()
ls_cod_origen 		= trim(em_origen.text)
ls_cod_trabajador = trim(sle_codigo.text)

if cbx_trabajador.checked = true then
	ls_cod_trabajador	= '%%'
else
	ls_cod_trabajador	= trim(sle_codigo.text)
end if
		
if ls_cod_trabajador = '' or IsNull(ls_cod_trabajador) then
	MessageBox('Producción', 'No ha definido ningún Trabajador', StopSign!)
return
end if

if ls_cod_origen = '' or IsNull(ls_cod_origen) then
	MessageBox('Producción', 'No ha definido ningún Origen', StopSign!)
return
end if

if cbx_ot_adm.checked = true then
	ls_ot_adm = trim(em_ot_adm.text)
	if ls_ot_adm = '' or IsNull(ls_ot_adm) then
	MessageBox('Producción', 'Debe definir una OT_ADM', StopSign!)
	return
	end if
	dw_cns.dataobject = 'd_asistencia_jornal_ot_adm_tbl'
	dw_cns.settransobject( sqlca )
	ll_retrieve = dw_cns.retrieve(ls_cod_origen, ld_ini, ld_fin, ls_ot_adm, ls_cod_trabajador)
else
	dw_cns.dataobject = 'd_asistencia_jornal_tbl'
	dw_cns.settransobject( sqlca )
	ll_retrieve = dw_cns.retrieve(ls_cod_origen, ld_ini, ld_fin, gs_user, ls_cod_trabajador)
end if

if ll_retrieve >= 1 then
	select to_char(sysdate, 'dd/mm/yyyy hh24:mi')
	   into :ls_fecha
	   from dual;
	
	if ld_ini <> ld_fin then
		ls_periodo = ' EL PERIODO ' + string(ld_ini, 'dd/mm/yyyy') + string(ld_fin, 'dd/mm/yyyy')
	else
		ls_periodo = ' LA FEHCA ' + string(ld_ini, 'dd/mm/yyyy')
	end if
	
	dw_cns.visible = true
	dw_cns.object.st_titulo.text = 'REPORTE DE ASISTENCIA DE JORNALEROS~rPARA' + ls_periodo
	dw_cns.object.p_logo.filename = gs_logo
	dw_cns.object.st_empresa.text = gs_empresa
	dw_cns.object.st_usuario.text = "Usuario: " + gs_user
	dw_cns.object.st_fecha.text = "Fecha: " + ls_fecha
end if
end event

on w_pr709_asistencia_fechas.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_rango=create uo_rango
this.cbx_ot_adm=create cbx_ot_adm
this.em_ot_adm=create em_ot_adm
this.em_descripcion_n=create em_descripcion_n
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.pb_2=create pb_2
this.st_1=create st_1
this.sle_nombre=create sle_nombre
this.sle_codigo=create sle_codigo
this.cbx_trabajador=create cbx_trabajador
this.gb_3=create gb_3
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_rango
this.Control[iCurrent+2]=this.cbx_ot_adm
this.Control[iCurrent+3]=this.em_ot_adm
this.Control[iCurrent+4]=this.em_descripcion_n
this.Control[iCurrent+5]=this.em_descripcion
this.Control[iCurrent+6]=this.em_origen
this.Control[iCurrent+7]=this.pb_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.sle_nombre
this.Control[iCurrent+10]=this.sle_codigo
this.Control[iCurrent+11]=this.cbx_trabajador
this.Control[iCurrent+12]=this.gb_3
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.gb_4
end on

on w_pr709_asistencia_fechas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_rango)
destroy(this.cbx_ot_adm)
destroy(this.em_ot_adm)
destroy(this.em_descripcion_n)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.pb_2)
destroy(this.st_1)
destroy(this.sle_nombre)
destroy(this.sle_codigo)
destroy(this.cbx_trabajador)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_4)
end on

type dw_cns from w_cns_smpl`dw_cns within w_pr709_asistencia_fechas
integer x = 46
integer y = 568
integer width = 2921
integer height = 1648
string dataobject = "d_asistencia_jornal_ot_adm_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_cns::constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
 is_dwform = 'tabular'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
	
end event

type uo_rango from ou_rango_fechas within w_pr709_asistencia_fechas
integer x = 201
integer y = 120
integer taborder = 20
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type cbx_ot_adm from checkbox within w_pr709_asistencia_fechas
integer x = 1586
integer y = 76
integer width = 430
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Si/No"
end type

event clicked;if this.checked = true then
	em_ot_adm.enabled = true
	em_ot_adm.text = ''
	sle_nombre.text = ''
else
	em_ot_adm.enabled = false
	em_ot_adm.text = ''
	sle_nombre.text = ''
end if
end event

type em_ot_adm from singlelineedit within w_pr709_asistencia_fechas
event dobleclick pbm_lbuttondblclk
integer x = 1586
integer y = 160
integer width = 297
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean enabled = false
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT O.OT_ADM AS CODIGO, O.DESCRIPCION AS DESCRIPCIÓN " &
				  + "FROM OT_ADMINISTRACION O, OT_ADM_USUARIO P " &
				  + "WHERE O.OT_ADM = P.OT_ADM " &
				  + "AND P.COD_USR = '" + gs_user + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
			
if ls_codigo <> '' then
	
this.text= ls_codigo

em_descripcion_n.text = ls_data

end if


end event

event modified;String ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar una OT_ADM')
	return
end if

SELECT descripcion INTO :ls_desc
FROM ot_administracion
WHERE ot_adm =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de OT_ADM no existe')
	return
end if

em_descripcion_n.text = ls_desc


end event

type em_descripcion_n from singlelineedit within w_pr709_asistencia_fechas
integer x = 1888
integer y = 160
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
long backcolor = 134217739
borderstyle borderstyle = stylelowered!
end type

type em_descripcion from editmask within w_pr709_asistencia_fechas
integer x = 1755
integer y = 416
integer width = 1166
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217738
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from singlelineedit within w_pr709_asistencia_fechas
event dobleclick pbm_lbuttondblclk
integer x = 1618
integer y = 416
integer width = 128
integer height = 80
integer taborder = 70
boolean bringtotop = true
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

type pb_2 from picturebutton within w_pr709_asistencia_fechas
integer x = 3008
integer y = 220
integer width = 471
integer height = 172
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_query_retrieve()
SetPointer(Arrow!)
end event

type st_1 from statictext within w_pr709_asistencia_fechas
integer x = 37
integer y = 284
integer width = 626
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reporte por Trabajador"
boolean focusrectangle = false
end type

type sle_nombre from singlelineedit within w_pr709_asistencia_fechas
integer x = 617
integer y = 416
integer width = 901
integer height = 72
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217738
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type sle_codigo from singlelineedit within w_pr709_asistencia_fechas
event dobleclick pbm_lbuttondblclk
integer x = 320
integer y = 416
integer width = 279
integer height = 72
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 134217746
long backcolor = 33554431
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string  ls_codigo, ls_data, ls_sql, ls_tipo, ls_origen

ls_sql = "SELECT  distinct m.cod_relacion as codigo, " & 
		 + "m.nombre AS TRABAJADOR " &
		 + "FROM CODIGO_RELACION m "

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	sle_nombre.text = ls_data
end if

end event

event modified;String 	ls_nombre, ls_codigo

ls_codigo = this.text


SELECT distinct m.nombre
	INTO :ls_nombre
FROM CODIGO_RELACION m
where m.cod_relacion =:ls_codigo;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Producción', 'Codigo de Trabajador no existe')
	this.text = ''
	sle_nombre.text = ''
	return
else
	sle_nombre.text = ls_nombre
end if

	

end event

type cbx_trabajador from checkbox within w_pr709_asistencia_fechas
integer x = 137
integer y = 412
integer width = 82
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean lefttext = true
end type

event clicked;if this.checked = true then
	
	sle_codigo.enabled = false
	sle_codigo.text = ''
	sle_nombre.text = ''
	
else
	
	sle_codigo.enabled = true

end if
end event

type gb_3 from groupbox within w_pr709_asistencia_fechas
integer x = 1568
integer y = 348
integer width = 1403
integer height = 180
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_1 from groupbox within w_pr709_asistencia_fechas
integer x = 1568
integer y = 24
integer width = 1403
integer height = 236
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "OT_ADM"
end type

type gb_2 from groupbox within w_pr709_asistencia_fechas
integer x = 37
integer y = 24
integer width = 1513
integer height = 232
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Rango de Fechas"
end type

type gb_4 from groupbox within w_pr709_asistencia_fechas
integer x = 41
integer y = 348
integer width = 1513
integer height = 180
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Todos   Seleccione Trabajador "
end type

