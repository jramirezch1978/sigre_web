$PBExportHeader$w_cm706_servicios.srw
forward
global type w_cm706_servicios from w_rpt_list
end type
type gb_fecha from groupbox within w_cm706_servicios
end type
type gb_tipo_reporte from groupbox within w_cm706_servicios
end type
type uo_1 from u_ingreso_rango_fechas_v within w_cm706_servicios
end type
type rb_proveedor from radiobutton within w_cm706_servicios
end type
type rb_cencos from radiobutton within w_cm706_servicios
end type
type rb_cuenta from radiobutton within w_cm706_servicios
end type
type cb_3 from commandbutton within w_cm706_servicios
end type
type st_campo from statictext within w_cm706_servicios
end type
type dw_text from datawindow within w_cm706_servicios
end type
type dw_cns from datawindow within w_cm706_servicios
end type
end forward

global type w_cm706_servicios from w_rpt_list
integer width = 3177
integer height = 2124
string title = "Servicios [CM706]"
string menuname = "m_impresion"
long backcolor = 67108864
gb_fecha gb_fecha
gb_tipo_reporte gb_tipo_reporte
uo_1 uo_1
rb_proveedor rb_proveedor
rb_cencos rb_cencos
rb_cuenta rb_cuenta
cb_3 cb_3
st_campo st_campo
dw_text dw_text
dw_cns dw_cns
end type
global w_cm706_servicios w_cm706_servicios

type variables
String is_col
end variables

forward prototypes
public function integer of_set_setea ()
end prototypes

public function integer of_set_setea ();SetPointer(Hourglass!)
dw_1.reset()
dw_2.reset()

if dw_2.RowCount() = 0 then
	cb_report.text = "Muestra Datos"
else
	cb_report.text = "Reporte"
end if
Return 1
end function

on w_cm706_servicios.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_fecha=create gb_fecha
this.gb_tipo_reporte=create gb_tipo_reporte
this.uo_1=create uo_1
this.rb_proveedor=create rb_proveedor
this.rb_cencos=create rb_cencos
this.rb_cuenta=create rb_cuenta
this.cb_3=create cb_3
this.st_campo=create st_campo
this.dw_text=create dw_text
this.dw_cns=create dw_cns
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_fecha
this.Control[iCurrent+2]=this.gb_tipo_reporte
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.rb_proveedor
this.Control[iCurrent+5]=this.rb_cencos
this.Control[iCurrent+6]=this.rb_cuenta
this.Control[iCurrent+7]=this.cb_3
this.Control[iCurrent+8]=this.st_campo
this.Control[iCurrent+9]=this.dw_text
this.Control[iCurrent+10]=this.dw_cns
end on

on w_cm706_servicios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_fecha)
destroy(this.gb_tipo_reporte)
destroy(this.uo_1)
destroy(this.rb_proveedor)
destroy(this.rb_cencos)
destroy(this.rb_cuenta)
destroy(this.cb_3)
destroy(this.st_campo)
destroy(this.dw_text)
destroy(this.dw_cns)
end on

event ue_retrieve;call super::ue_retrieve;Date   ld_desde, ld_hasta
String ls_acod[]
Long 	 ll_row,ll_count_arr	

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

SetPointer( Hourglass!)
if rb_cencos.Checked = false and rb_cuenta.checked = false and rb_proveedor.checked = false then
	Messagebox( "Error", "Indicar tipo de reporte")
	Return 
End if

// Llena datos de dw seleccionados a tabla temporal
If rb_proveedor.checked = true then	
	FOR ll_row = 1 to dw_2.rowcount()
		ls_acod[ll_row] = dw_2.object.proveedor[ll_row]				
	NEXT
end if
If rb_cencos.checked = true then	
	FOR ll_row = 1 to dw_2.rowcount()
		ls_acod[ll_row] = dw_2.object.cencos[ll_row]				
	NEXT
end if
If rb_cuenta.checked = true then	
	FOR ll_row = 1 to dw_2.rowcount()
		ls_acod[ll_row] = dw_2.object.cnta_prsp[ll_row]				
	NEXT
end if

dw_report.object.t_del_dia.text = string(ld_desde)
dw_report.object.t_al_dia.text = string(ld_hasta)
dw_report.visible = true
ib_preview = false
this.event ue_preview()
dw_report.retrieve(ls_acod, ld_desde, ld_hasta )
dw_report.Object.p_logo.filename = gs_logo
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

event ue_open_pre;call super::ue_open_pre;dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
end event

type dw_report from w_rpt_list`dw_report within w_cm706_servicios
boolean visible = false
integer x = 0
integer y = 400
integer width = 3040
integer height = 1444
end type

event dw_report::doubleclicked;call super::doubleclicked;String ls_nro_os,ls_tipo_os

Choose case dwo.name
       Case 'nro_os'
				if row = 0 then  return
				
				//parametros de os
				select doc_os into :ls_tipo_os from logparam where reckey = '1';
							
			 	ls_nro_os = This.object.nro_os [row] 
				dw_cns.visible = true 
				dw_cns.Retrieve(ls_tipo_os,ls_nro_os)
				
End Choose
end event

type dw_1 from w_rpt_list`dw_1 within w_cm706_servicios
integer x = 23
integer y = 404
integer width = 1449
integer height = 1332
integer taborder = 70
end type

event dw_1::constructor;call super::constructor;ii_ck[1] = 1 
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
	
	st_campo.text = "Buscar x : " + is_col
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
END IF
end event

type pb_1 from w_rpt_list`pb_1 within w_cm706_servicios
integer x = 1490
integer y = 960
integer taborder = 80
end type

event pb_1::clicked;call super::clicked;if dw_2.RowCount() > 0 then
	cb_report.enabled = true
end if
end event

type pb_2 from w_rpt_list`pb_2 within w_cm706_servicios
integer x = 1486
integer y = 1360
integer taborder = 100
alignment htextalign = center!
end type

event pb_2::clicked;call super::clicked;if dw_2.RowCount() = 0 then
	cb_report.enabled = false
end if
end event

type dw_2 from w_rpt_list`dw_2 within w_cm706_servicios
integer x = 1659
integer y = 408
integer width = 1449
integer height = 1332
integer taborder = 90
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2

ii_rk[1] = 1
ii_rk[2] = 2

end event

type cb_report from w_rpt_list`cb_report within w_cm706_servicios
integer x = 1454
integer y = 180
integer width = 402
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 700
boolean enabled = false
string text = "Reporte"
end type

event cb_report::clicked;call super::clicked;PARENT.EVENT UE_RETRIEVE()
end event

type gb_fecha from groupbox within w_cm706_servicios
integer x = 5
integer width = 667
integer height = 300
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_tipo_reporte from groupbox within w_cm706_servicios
integer x = 686
integer width = 741
integer height = 292
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Carga Datos"
end type

type uo_1 from u_ingreso_rango_fechas_v within w_cm706_servicios
integer x = 18
integer y = 64
integer taborder = 40
boolean bringtotop = true
long backcolor = 67108864
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
call u_ingreso_rango_fechas_v::destroy
end on

type rb_proveedor from radiobutton within w_cm706_servicios
integer x = 718
integer y = 56
integer width = 626
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Por Proveedor"
boolean lefttext = true
end type

event clicked;if checked = true then
	setnull(is_col)
	st_campo.text = is_col
	dw_text.object.campo [1] = is_col
	dw_report.visible = false
	dw_report.DataObject= 'd_rpt_servicios_proveedor'
	dw_1.Dataobject = 'd_sel_servicios_proveedor'
	dw_2.DataObject = 'd_sel_servicios_proveedor'
end if	
end event

type rb_cencos from radiobutton within w_cm706_servicios
integer x = 718
integer y = 128
integer width = 626
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Por Centro Costo"
boolean lefttext = true
end type

event clicked;if checked = true then
	setnull(is_col)
	st_campo.text = is_col
	dw_text.object.campo [1] = is_col
	dw_report.visible = false
	dw_report.DataObject= 'd_rpt_servicios_cencos'
	dw_1.Dataobject ='d_sel_servicios_centrocosto'
	dw_2.DataObject = 'd_sel_servicios_centrocosto'	
end if	
end event

type rb_cuenta from radiobutton within w_cm706_servicios
integer x = 718
integer y = 200
integer width = 626
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Cuenta Presupuestal"
boolean lefttext = true
end type

event clicked;if checked = true then
	setnull(is_col)
	st_campo.text = is_col
	dw_text.object.campo [1] = is_col
	dw_report.visible = false
	dw_report.DataObject= 'd_rpt_servicios_cnta_prsp'
	dw_1.Dataobject = 'd_sel_servicios_cta_presup'
	dw_2.DataObject = 'd_sel_servicios_cta_presup'	
end if	
end event

type cb_3 from commandbutton within w_cm706_servicios
integer x = 1454
integer y = 20
integer width = 402
integer height = 104
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Carga datos"
end type

event clicked;dw_report.visible = false
dw_1.retrieve()
cb_report.enabled = false


end event

type st_campo from statictext within w_cm706_servicios
integer x = 27
integer y = 328
integer width = 718
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
string text = "Buscar x  :"
boolean focusrectangle = false
end type

type dw_text from datawindow within w_cm706_servicios
event ue_tecla pbm_dwnkey
event dw_enter pbm_dwnprocessenter
integer x = 759
integer y = 316
integer width = 1362
integer height = 76
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_1.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if
ll_row = dw_text.Getrow()
end event

event dw_enter;
dw_1.triggerevent(doubleclicked!)
return 1
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

type dw_cns from datawindow within w_cm706_servicios
boolean visible = false
integer x = 1550
integer y = 1184
integer width = 1371
integer height = 744
integer taborder = 90
boolean bringtotop = true
boolean titlebar = true
string title = "Documentos Provisionados "
string dataobject = "d_abc_lista_os_provisionado_tbl"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;SettransObject(sqlca)
end event

