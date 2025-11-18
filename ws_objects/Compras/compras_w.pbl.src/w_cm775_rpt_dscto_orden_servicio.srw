$PBExportHeader$w_cm775_rpt_dscto_orden_servicio.srw
forward
global type w_cm775_rpt_dscto_orden_servicio from w_rpt_list
end type
type gb_fechas from groupbox within w_cm775_rpt_dscto_orden_servicio
end type
type cb_3 from commandbutton within w_cm775_rpt_dscto_orden_servicio
end type
type uo_1 from u_ingreso_rango_fechas within w_cm775_rpt_dscto_orden_servicio
end type
type st_etiqueta from statictext within w_cm775_rpt_dscto_orden_servicio
end type
type dw_text from datawindow within w_cm775_rpt_dscto_orden_servicio
end type
type st_campo from statictext within w_cm775_rpt_dscto_orden_servicio
end type
end forward

global type w_cm775_rpt_dscto_orden_servicio from w_rpt_list
integer width = 3822
integer height = 2660
string title = "(CM775)  Reporte descuentos de Ordenes de servicio"
string menuname = "m_impresion"
windowstate windowstate = maximized!
gb_fechas gb_fechas
cb_3 cb_3
uo_1 uo_1
st_etiqueta st_etiqueta
dw_text dw_text
st_campo st_campo
end type
global w_cm775_rpt_dscto_orden_servicio w_cm775_rpt_dscto_orden_servicio

type variables
String is_col
end variables

on w_cm775_rpt_dscto_orden_servicio.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_fechas=create gb_fechas
this.cb_3=create cb_3
this.uo_1=create uo_1
this.st_etiqueta=create st_etiqueta
this.dw_text=create dw_text
this.st_campo=create st_campo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_fechas
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.st_etiqueta
this.Control[iCurrent+5]=this.dw_text
this.Control[iCurrent+6]=this.st_campo
end on

on w_cm775_rpt_dscto_orden_servicio.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_fechas)
destroy(this.cb_3)
destroy(this.uo_1)
destroy(this.st_etiqueta)
destroy(this.dw_text)
destroy(this.st_campo)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

event ue_retrieve;Long 	ll_row
Date ld_desde, ld_hasta
string ls_cod, ls_soles, ls_dolar

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

select cod_soles, cod_dolares into :ls_soles, :ls_dolar from logparam where reckey='1';

SetPointer(Hourglass!)

// Llena datos de dw seleccionados a tabla temporal
delete from tt_proveedor;
FOR ll_row = 1 to dw_2.rowcount()
 	 ls_cod = dw_2.object.proveedor[ll_row]
	 Insert into tt_proveedor( proveedor) values ( :ls_cod);		
NEXT	

	dw_report.retrieve(ld_desde, ld_hasta, ls_soles, ls_dolar)
	dw_report.ii_zoom_actual = 100
	this.Event ue_preview()
	dw_report.visible = true			
	dw_report.object.t_texto.text = 'Del ' + STRING(LD_DESDE, "DD/MM/YYYY") +&
						' Al :' + STRING(LD_HASTA, "DD/MM/YYYY")
	dw_report.Object.p_logo.filename = gs_logo
	dw_report.object.t_empresa.text = gs_empresa
	dw_report.object.t_user.text = gs_user		
   dw_report.object.t_objeto.text =dw_report.dataobject



end event

type dw_report from w_rpt_list`dw_report within w_cm775_rpt_dscto_orden_servicio
boolean visible = false
integer x = 73
integer y = 384
integer width = 3319
integer height = 1196
string dataobject = "d_rpt_dscto_orden_servicio"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

String ls_prov,ls_cod_art,ls_descp

choose case dwo.name
		 case 'cod_art'
				ls_prov	  = This.object.proveedor [row]
				ls_cod_art = This.object.cod_art   [row]
				ls_descp   = This.object.proveedor_nom_proveedor [row]
				
	//	dw_detail.title = trim(ls_descp)
	//			dw_detail.Retrieve(ls_prov,ls_cod_art)
		//		dw_detail.visible = true				
end choose

end event

type dw_1 from w_rpt_list`dw_1 within w_cm775_rpt_dscto_orden_servicio
integer x = 73
integer y = 384
integer width = 1623
integer height = 796
integer taborder = 50
string dataobject = "d_sel_servicio_x_periodo_proveedor_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;
ii_ck[1] = 1 
ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2

ii_rk[1] = 1
ii_rk[2] = 2

end event

event dw_1::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	
	st_campo.text = "Orden: " + is_col
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
END IF
end event

type pb_1 from w_rpt_list`pb_1 within w_cm775_rpt_dscto_orden_servicio
integer x = 1682
integer y = 640
integer taborder = 70
end type

event pb_1::clicked;call super::clicked;if dw_2.rowcount() > 0 then
	cb_report.enabled = true
end if
end event

type pb_2 from w_rpt_list`pb_2 within w_cm775_rpt_dscto_orden_servicio
integer x = 1682
integer y = 864
integer taborder = 100
alignment htextalign = center!
end type

event pb_2::clicked;call super::clicked;if dw_2.rowcount() = 0 then
	cb_report.enabled = false
end if
end event

type dw_2 from w_rpt_list`dw_2 within w_cm775_rpt_dscto_orden_servicio
integer x = 1865
integer y = 384
integer width = 1623
integer height = 796
integer taborder = 90
string dataobject = "d_sel_servicio_x_periodo_proveedor_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2

ii_rk[1] = 1
ii_rk[2] = 2
end event

type cb_report from w_rpt_list`cb_report within w_cm775_rpt_dscto_orden_servicio
integer x = 2921
integer y = 68
integer width = 457
integer height = 92
integer taborder = 40
integer weight = 700
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;parent.event ue_retrieve()
end event

type gb_fechas from groupbox within w_cm775_rpt_dscto_orden_servicio
integer width = 1792
integer height = 224
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Fechas"
end type

type cb_3 from commandbutton within w_cm775_rpt_dscto_orden_servicio
integer x = 2441
integer y = 68
integer width = 457
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Mostrar"
end type

event clicked;Date    ld_desde, ld_hasta
Integer li_opcion
String  ls_sql_old,ls_campo,ls_sql_new,ls_desde,ls_cadena

dw_text.Accepttext()

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()
ls_campo = Upper(String(dw_text.object.campo [1]))

dw_1.SetTransObject(sqlca)
dw_1.visible = true
dw_2.visible = true
dw_report.visible = false	


SetPointer( HourGlass!)

//IF Isnull(is_col) OR Trim(is_col) = '' THEN
//	Messagebox('Aviso','Debe Seleccionar Un Campo Para Realizar la Busqueda ')	
//	Return
//END IF
//
//IF Isnull(ls_campo) OR Trim(ls_campo) = '' THEN
//	li_opcion = Messagebox('Pregunta','Desea Filtrar Por Algun Articulo ',question!,yesno!)	
//	
//	IF li_opcion = 1 THEN
//		dw_text.SetFocus()
//		Return
//	ELSE
//		ls_cadena = ''
//	END IF
//ELSE
//	ls_cadena = ' AND UPPER('+is_col+') Like '+"'"+ls_campo+"%'" 
//END IF
//

dw_1.reset()
dw_2.reset()

ls_sql_old = dw_1.getsqlselect()

ls_sql_new = ls_sql_old	+ ' AND ( TO_CHAR'+'("ORDEN_SERVICIO"."FEC_REGISTRO",' +"'"+'dd/mm/yyyy'+"'"+' ) >= '+"'"+String(ld_desde,'dd/mm/yyyy')+"')" & 
								+ ' AND ( TO_CHAR'+'("ORDEN_SERVICIO"."FEC_REGISTRO",' +"'"+'dd/mm/yyyy'+"'"+' ) <= '+"'"+String(ld_hasta,'dd/mm/yyyy')+"')" & 
								+ ls_cadena

dw_1.setsqlselect(ls_sql_new)
dw_1.retrieve(ld_desde, ld_hasta )
dw_1.setsqlselect(ls_sql_old)

return 1


end event

type uo_1 from u_ingreso_rango_fechas within w_cm775_rpt_dscto_orden_servicio
integer x = 78
integer y = 88
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;string ls_inicio 
date ld_fec_ini, ld_Fec_fin
integer li_dia
 of_set_label('Desde','Hasta') //para setear la fecha inicial

//Obtenemos el Primer dia del Mes
ld_fec_fin = today()

//li_dia = day(ld_fec_fin)
//ld_fec_fin = RelativeDate(ld_fec_fin,-li_dia)

//Obtenemoa la primera fecha
ld_fec_ini = date('01'+'/'+string(month(ld_fec_fin))+'/'+string(year(ld_fec_fin)))

of_set_fecha(ld_fec_ini,today())
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final



end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type st_etiqueta from statictext within w_cm775_rpt_dscto_orden_servicio
boolean visible = false
integer x = 1993
integer y = 244
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 65535
boolean focusrectangle = false
end type

type dw_text from datawindow within w_cm775_rpt_dscto_orden_servicio
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 805
integer y = 256
integer width = 1179
integer height = 100
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_enter;
dw_1.triggerevent(doubleclicked!)
return 1
end event

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_1.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if
ll_row = dw_text.Getrow()
end event

event constructor;Long ll_reg

ll_reg = this.insertrow(0)
end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_1.selectrow(0, false)
			dw_1.selectrow(ll_fila,true)
			dw_1.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)
end event

type st_campo from statictext within w_cm775_rpt_dscto_orden_servicio
integer x = 37
integer y = 256
integer width = 754
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Orden :"
boolean focusrectangle = false
end type

