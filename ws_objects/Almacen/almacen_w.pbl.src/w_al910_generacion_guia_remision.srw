$PBExportHeader$w_al910_generacion_guia_remision.srw
forward
global type w_al910_generacion_guia_remision from w_abc
end type
type uo_2 from u_ingreso_fecha_hora within w_al910_generacion_guia_remision
end type
type st_7 from statictext within w_al910_generacion_guia_remision
end type
type uo_1 from u_ingreso_rango_fechas within w_al910_generacion_guia_remision
end type
type cbx_simulacion from checkbox within w_al910_generacion_guia_remision
end type
type sle_origen from singlelineedit within w_al910_generacion_guia_remision
end type
type st_5 from statictext within w_al910_generacion_guia_remision
end type
type sle_movimiento from singlelineedit within w_al910_generacion_guia_remision
end type
type cb_movimiento from commandbutton within w_al910_generacion_guia_remision
end type
type sle_desc_movimiento from singlelineedit within w_al910_generacion_guia_remision
end type
type st_4 from statictext within w_al910_generacion_guia_remision
end type
type sle_desc_almacen from singlelineedit within w_al910_generacion_guia_remision
end type
type cb_almacen from commandbutton within w_al910_generacion_guia_remision
end type
type sle_almacen from singlelineedit within w_al910_generacion_guia_remision
end type
type st_3 from statictext within w_al910_generacion_guia_remision
end type
type sle_serie from singlelineedit within w_al910_generacion_guia_remision
end type
type st_2 from statictext within w_al910_generacion_guia_remision
end type
type st_1 from statictext within w_al910_generacion_guia_remision
end type
type pb_2 from picturebutton within w_al910_generacion_guia_remision
end type
type pb_1 from picturebutton within w_al910_generacion_guia_remision
end type
type dw_1 from datawindow within w_al910_generacion_guia_remision
end type
type gb_1 from groupbox within w_al910_generacion_guia_remision
end type
end forward

global type w_al910_generacion_guia_remision from w_abc
integer width = 3191
integer height = 1752
string title = "[AL910] Generación de Guias de Remisión"
string menuname = "m_salir"
boolean resizable = false
boolean center = true
event ue_aceptar ( )
event ue_salir ( )
uo_2 uo_2
st_7 st_7
uo_1 uo_1
cbx_simulacion cbx_simulacion
sle_origen sle_origen
st_5 st_5
sle_movimiento sle_movimiento
cb_movimiento cb_movimiento
sle_desc_movimiento sle_desc_movimiento
st_4 st_4
sle_desc_almacen sle_desc_almacen
cb_almacen cb_almacen
sle_almacen sle_almacen
st_3 st_3
sle_serie sle_serie
st_2 st_2
st_1 st_1
pb_2 pb_2
pb_1 pb_1
dw_1 dw_1
gb_1 gb_1
end type
global w_al910_generacion_guia_remision w_al910_generacion_guia_remision

event ue_aceptar();date ldt_fecha_ini, ldt_fecha_fin
datetime ldt_fecha_registro
integer li_serie
string ls_almacen, ls_movimiento, ls_guia_ini, ls_guia_fin

dw_1.visible = false
ls_guia_ini = ""
ls_guia_fin = ""

if cbx_simulacion.checked = false then
	select max(nro_guia) into :ls_guia_ini from guia;
end if

if sle_serie.text = '' or isnull(sle_serie.text) then
	messagebox("Aviso","Debe de ingresar un Numero de serie")
	return
end if

li_serie = integer(sle_serie.text)

if sle_almacen.text = '' or isnull(sle_almacen.text) then
	messagebox("Aviso","Debe de ingresar un Codigo de Almacen")
	return
end if

ls_almacen = sle_almacen.text

if sle_movimiento.text = '' or isnull(sle_movimiento.text) then
	messagebox("Aviso","Debe de ingresar un Tipo de Movimiento")
	return
end if

ls_movimiento = sle_movimiento.text

ldt_fecha_ini = uo_1.of_get_fecha1()
ldt_fecha_fin = uo_1.of_get_fecha2()
ldt_fecha_registro = uo_2.of_get_fecha()

IF ( isnull(ldt_fecha_ini) OR isnull(ldt_fecha_fin) OR isnull(ldt_fecha_registro))THEN
	messagebox('Aviso','Registre correctamente las fechas')
	Return
end if

if cbx_simulacion.checked = false then
	
	declare USP_PROC1 procedure for USP_ALM_GENERA_GUIA_REM(:gs_origen,:li_serie,:ls_almacen,:ls_movimiento,:ldt_fecha_ini,:ldt_fecha_fin,:gs_user,:ldt_fecha_registro);
	execute USP_PROC1;
	
else

	declare USP_PROC2 procedure for USP_ALM_GENERA_GUIA_REM_TT(:gs_origen,:li_serie,:ls_almacen,:ls_movimiento,:ldt_fecha_ini,:ldt_fecha_fin,:gs_user,:ldt_fecha_registro);
	execute USP_PROC2;

end if

if sqlca.sqlcode = -1 then
	messagebox('Aviso',string(sqlca.sqlcode)+' '+string(sqlca.sqlerrtext))
	rollback;
	return
end if

if cbx_simulacion.checked = false then 
	
	commit;
	select max(nro_guia) into :ls_guia_fin from guia;
	dw_1.Reset()
	dw_1.visible = false
	messagebox("Aviso","Proceso Finalizado Exitosamente")
	
else
	
	select min(nro_guia),max(nro_guia) into :ls_guia_ini,:ls_guia_fin
     from tt_guia;
	dw_1.dataobject = 'd_rpt_simulacion_generacion_guia'
	dw_1.settransobject(Sqlca)
	dw_1.retrieve()
	dw_1.visible = true
	dw_1.object.datawindow.print.preview = 'yes'
	messagebox("Aviso","Nro de Guias generadas de: "+ls_guia_ini+" al "+ls_guia_fin)

end if
end event

event ue_salir();close(this)
end event

on w_al910_generacion_guia_remision.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.uo_2=create uo_2
this.st_7=create st_7
this.uo_1=create uo_1
this.cbx_simulacion=create cbx_simulacion
this.sle_origen=create sle_origen
this.st_5=create st_5
this.sle_movimiento=create sle_movimiento
this.cb_movimiento=create cb_movimiento
this.sle_desc_movimiento=create sle_desc_movimiento
this.st_4=create st_4
this.sle_desc_almacen=create sle_desc_almacen
this.cb_almacen=create cb_almacen
this.sle_almacen=create sle_almacen
this.st_3=create st_3
this.sle_serie=create sle_serie
this.st_2=create st_2
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_1=create dw_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_2
this.Control[iCurrent+2]=this.st_7
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.cbx_simulacion
this.Control[iCurrent+5]=this.sle_origen
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.sle_movimiento
this.Control[iCurrent+8]=this.cb_movimiento
this.Control[iCurrent+9]=this.sle_desc_movimiento
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.sle_desc_almacen
this.Control[iCurrent+12]=this.cb_almacen
this.Control[iCurrent+13]=this.sle_almacen
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.sle_serie
this.Control[iCurrent+16]=this.st_2
this.Control[iCurrent+17]=this.st_1
this.Control[iCurrent+18]=this.pb_2
this.Control[iCurrent+19]=this.pb_1
this.Control[iCurrent+20]=this.dw_1
this.Control[iCurrent+21]=this.gb_1
end on

on w_al910_generacion_guia_remision.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_2)
destroy(this.st_7)
destroy(this.uo_1)
destroy(this.cbx_simulacion)
destroy(this.sle_origen)
destroy(this.st_5)
destroy(this.sle_movimiento)
destroy(this.cb_movimiento)
destroy(this.sle_desc_movimiento)
destroy(this.st_4)
destroy(this.sle_desc_almacen)
destroy(this.cb_almacen)
destroy(this.sle_almacen)
destroy(this.st_3)
destroy(this.sle_serie)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;
string ls_desc, ls_cod

select oper_vnta_mat into :ls_cod
  from logparam
 where reckey = '1';

select desc_tipo_mov into :ls_desc
  from articulo_mov_tipo
 where tipo_mov = :ls_cod;

sle_movimiento.text = ls_cod
sle_desc_movimiento.text = ls_desc

sle_origen.text = gs_origen
end event

event resize;call super::resize;dw_1.width  = newwidth  - dw_1.x
dw_1.height = newheight - dw_1.y
end event

type uo_2 from u_ingreso_fecha_hora within w_al910_generacion_guia_remision
integer x = 873
integer y = 480
integer taborder = 30
end type

event constructor;call super::constructor;datetime ld_fecha
ld_fecha = datetime(today(),now())
of_set_label('Desde:') // para seatear el titulo del boton
of_set_fecha(ld_fecha) //para setear la fecha inicial
of_set_rango_inicio(datetime('01/01/1900 06:00:00')) // rango inicial
of_set_rango_fin(datetime('31/12/9999 06:00:00')) // rango final
end event

on uo_2.destroy
call u_ingreso_fecha_hora::destroy
end on

type st_7 from statictext within w_al910_generacion_guia_remision
integer x = 18
integer y = 488
integer width = 809
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha de Registro de Guias :"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_rango_fechas within w_al910_generacion_guia_remision
integer x = 1783
integer y = 244
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cbx_simulacion from checkbox within w_al910_generacion_guia_remision
integer x = 704
integer y = 176
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Simulación"
boolean checked = true
end type

type sle_origen from singlelineedit within w_al910_generacion_guia_remision
integer x = 1591
integer y = 192
integer width = 133
integer height = 72
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
boolean enabled = false
textcase textcase = upper!
integer limit = 3
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within w_al910_generacion_guia_remision
integer x = 1234
integer y = 196
integer width = 343
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_movimiento from singlelineedit within w_al910_generacion_guia_remision
integer x = 347
integer y = 384
integer width = 270
integer height = 72
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

type cb_movimiento from commandbutton within w_al910_generacion_guia_remision
integer x = 640
integer y = 384
integer width = 78
integer height = 72
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT A.TIPO_MOV AS MOVIMIENTO, '&
								+'A.DESC_TIPO_MOV AS DESCRIPCION '&
								+'FROM ARTICULO_MOV_TIPO A '&
								+"WHERE A.FLAG_ESTADO = '1' "

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_movimiento.text = string(lstr_seleccionar.param1[1])
	sle_desc_movimiento.text = string(lstr_seleccionar.param2[1])
END IF
end event

type sle_desc_movimiento from singlelineedit within w_al910_generacion_guia_remision
integer x = 741
integer y = 384
integer width = 983
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_al910_generacion_guia_remision
integer x = 37
integer y = 388
integer width = 302
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Movimiento :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_desc_almacen from singlelineedit within w_al910_generacion_guia_remision
integer x = 741
integer y = 288
integer width = 983
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

type cb_almacen from commandbutton within w_al910_generacion_guia_remision
integer x = 640
integer y = 288
integer width = 78
integer height = 72
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT A.ALMACEN AS ALMACEN, '&
								+'A.DESC_ALMACEN AS DESCRIPCION '&
								+'FROM ALMACEN A '&
								+"WHERE A.FLAG_TIPO_ALMACEN = 'M' "&
								+"  AND A.FLAG_ESTADO = '1'"

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_almacen.text = string(lstr_seleccionar.param1[1])
	sle_desc_almacen.text = string(lstr_seleccionar.param2[1])
END IF
end event

type sle_almacen from singlelineedit within w_al910_generacion_guia_remision
integer x = 347
integer y = 288
integer width = 270
integer height = 72
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_al910_generacion_guia_remision
integer x = 37
integer y = 292
integer width = 302
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Almacen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_serie from singlelineedit within w_al910_generacion_guia_remision
integer x = 347
integer y = 192
integer width = 133
integer height = 72
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "14"
textcase textcase = upper!
integer limit = 3
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_al910_generacion_guia_remision
integer x = 37
integer y = 196
integer width = 302
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Serie :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_al910_generacion_guia_remision
integer x = 37
integer y = 32
integer width = 3077
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Generación de Guias de Remisión"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_al910_generacion_guia_remision
integer x = 2798
integer y = 400
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

type pb_1 from picturebutton within w_al910_generacion_guia_remision
integer x = 2441
integer y = 400
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

type dw_1 from datawindow within w_al910_generacion_guia_remision
boolean visible = false
integer x = 37
integer y = 608
integer width = 3077
integer height = 932
integer taborder = 30
string title = "Guias Generadas"
string dataobject = "d_rpt_simulacion_generacion_guia"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_al910_generacion_guia_remision
integer x = 1755
integer y = 160
integer width = 1358
integer height = 224
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fecha para Vales"
end type

