$PBExportHeader$w_cm503_proveedor_articulo.srw
forward
global type w_cm503_proveedor_articulo from w_rpt_list
end type
type gb_fechas from groupbox within w_cm503_proveedor_articulo
end type
type cb_3 from commandbutton within w_cm503_proveedor_articulo
end type
type uo_1 from u_ingreso_rango_fechas within w_cm503_proveedor_articulo
end type
type dw_detail from datawindow within w_cm503_proveedor_articulo
end type
type dw_grafico from datawindow within w_cm503_proveedor_articulo
end type
type st_etiqueta from statictext within w_cm503_proveedor_articulo
end type
type dw_text from datawindow within w_cm503_proveedor_articulo
end type
type st_campo from statictext within w_cm503_proveedor_articulo
end type
type rb_1 from radiobutton within w_cm503_proveedor_articulo
end type
type rb_2 from radiobutton within w_cm503_proveedor_articulo
end type
end forward

global type w_cm503_proveedor_articulo from w_rpt_list
integer width = 3712
integer height = 2136
string title = "Resumen de compras Proveedor/Articulo (CM503)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 67108864
gb_fechas gb_fechas
cb_3 cb_3
uo_1 uo_1
dw_detail dw_detail
dw_grafico dw_grafico
st_etiqueta st_etiqueta
dw_text dw_text
st_campo st_campo
rb_1 rb_1
rb_2 rb_2
end type
global w_cm503_proveedor_articulo w_cm503_proveedor_articulo

type variables
String is_col
end variables

on w_cm503_proveedor_articulo.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_fechas=create gb_fechas
this.cb_3=create cb_3
this.uo_1=create uo_1
this.dw_detail=create dw_detail
this.dw_grafico=create dw_grafico
this.st_etiqueta=create st_etiqueta
this.dw_text=create dw_text
this.st_campo=create st_campo
this.rb_1=create rb_1
this.rb_2=create rb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_fechas
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.dw_detail
this.Control[iCurrent+5]=this.dw_grafico
this.Control[iCurrent+6]=this.st_etiqueta
this.Control[iCurrent+7]=this.dw_text
this.Control[iCurrent+8]=this.st_campo
this.Control[iCurrent+9]=this.rb_1
this.Control[iCurrent+10]=this.rb_2
end on

on w_cm503_proveedor_articulo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_fechas)
destroy(this.cb_3)
destroy(this.uo_1)
destroy(this.dw_detail)
destroy(this.dw_grafico)
destroy(this.st_etiqueta)
destroy(this.dw_text)
destroy(this.st_campo)
destroy(this.rb_1)
destroy(this.rb_2)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

event ue_retrieve;Long 	ll_row
Date ld_desde, ld_hasta
String ls_cod, ls_error

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()


SetPointer(Hourglass!)

// Llena datos de dw seleccionados a tabla temporal
delete from tt_alm_seleccion;
FOR ll_row = 1 to dw_2.rowcount()
 	 ls_cod = dw_2.object.proveedor[ll_row]
	 Insert into tt_alm_seleccion( proveedor ) values ( :ls_cod);		
NEXT	

if rb_1.checked then
	dw_report.DataObject = 'd_cns_proveedor_articulo_304'
	dw_report.SetTransObject(SQLCA)
	
	//create or replace procedure USP_CMP_PROVEEDOR_ARTICULO(
	//       adi_desde            IN date,
	//       adi_hasta            IN DATE
	//) is
	DECLARE USP_CMP_PROVEEDOR_ARTICULO PROCEDURE FOR 
		USP_CMP_PROVEEDOR_ARTICULO(:ld_desde, 
											:ld_hasta );
	EXECUTE USP_CMP_PROVEEDOR_ARTICULO;	
	
	If sqlca.sqlcode = -1 then
		ls_error = SQLCA.SQLErrText
		ROLLBACK;
		messagebox("Error USP_CMP_PROVEEDOR_ARTICULO",ls_error)
		return
	end if	
	
	CLOSE USP_CMP_PROVEEDOR_ARTICULO;
	COMMIT;
	
	dw_report.retrieve()
else
	dw_report.DataObject = 'd_cns_compras_proveedor_tbl'
	dw_report.SetTransObject(SQLCA)
	dw_report.Retrieve(ld_desde, ld_hasta)
	
end if
ib_preview = false
Event ue_preview()

dw_report.visible = true			
dw_report.object.titulo_1.text = 'Del ' + STRING(LD_DESDE, "DD/MM/YYYY") +&
						' Al :' + STRING(LD_HASTA, "DD/MM/YYYY")
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user		



end event

type dw_report from w_rpt_list`dw_report within w_cm503_proveedor_articulo
boolean visible = false
integer x = 0
integer y = 264
integer width = 3319
integer height = 1460
string dataobject = "d_cns_proveedor_articulo_304"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

String ls_prov,ls_cod_art,ls_descp

choose case dwo.name
		 case 'cod_art'
				ls_prov	  = This.object.proveedor [row]
				ls_cod_art = This.object.cod_art   [row]
				ls_descp   = This.object.proveedor_nom_proveedor [row]
				
				dw_detail.title = trim(ls_descp)
				dw_detail.Retrieve(ls_prov,ls_cod_art)
				dw_detail.visible = true				
end choose

end event

type dw_1 from w_rpt_list`dw_1 within w_cm503_proveedor_articulo
integer x = 9
integer y = 376
integer width = 1623
integer height = 796
integer taborder = 50
string dataobject = "d_sel_compras_x_periodo_proveedor_tbl"
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

type pb_1 from w_rpt_list`pb_1 within w_cm503_proveedor_articulo
integer x = 1669
integer y = 800
integer taborder = 70
end type

event pb_1::clicked;call super::clicked;if dw_2.rowcount() > 0 then
	cb_report.enabled = true
end if
end event

type pb_2 from w_rpt_list`pb_2 within w_cm503_proveedor_articulo
integer x = 1678
integer y = 1044
integer taborder = 100
alignment htextalign = center!
end type

event pb_2::clicked;call super::clicked;if dw_2.rowcount() = 0 then
	cb_report.enabled = false
end if
end event

type dw_2 from w_rpt_list`dw_2 within w_cm503_proveedor_articulo
integer x = 1801
integer y = 376
integer width = 1623
integer height = 796
integer taborder = 90
string dataobject = "d_sel_compras_x_periodo_proveedor_tbl"
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

type cb_report from w_rpt_list`cb_report within w_cm503_proveedor_articulo
integer x = 2441
integer y = 124
integer width = 457
integer height = 92
integer taborder = 40
integer weight = 700
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;SetPointer( HourGlass!)
parent.event ue_retrieve()
SetPointer( Arrow!)
end event

type gb_fechas from groupbox within w_cm503_proveedor_articulo
integer y = 4
integer width = 1778
integer height = 228
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas"
end type

type cb_3 from commandbutton within w_cm503_proveedor_articulo
integer x = 2441
integer y = 12
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

dw_text.Accepttext()

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

dw_1.SetTransObject(sqlca)
dw_1.visible = true
dw_2.visible = true
dw_report.visible = false	


SetPointer( HourGlass!)

dw_1.reset()
dw_2.reset()

dw_1.retrieve(ld_desde, ld_hasta )

SetPointer( Arrow!)

return 1


end event

type uo_1 from u_ingreso_rango_fechas within w_cm503_proveedor_articulo
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

type dw_detail from datawindow within w_cm503_proveedor_articulo
boolean visible = false
integer x = 741
integer y = 612
integer width = 2299
integer height = 992
integer taborder = 110
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_cns_proveedor_articulo_det_tbl"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;settransobject(sqlca)
end event

event buttonclicked;
choose case dwo.name
	case 'b_grafico'
			IF THIS.rowcount() = 0 THEN RETURN
			string ls_cod_art,ls_prov,ls_nom_prov,ls_nom_art
			ls_cod_art  = this.object.cod_art       [1]
			ls_prov	   = this.object.proveedor     [1]
			ls_nom_prov = this.object.nom_proveedor [1]
			ls_nom_art  = this.object.nom_articulo  [1]
			
			dw_grafico.retrieve(ls_prov,ls_cod_art)
		   dw_grafico.visible = true
			//Titulo de grafico
			dw_grafico.title = 'Variacion de Precio y Cantidad' 
			dw_grafico.Object.gr_1.Title = "Prov : "+Trim(ls_nom_prov)+" Art : "+trim(ls_nom_art)


			This.visible = FALSE

end choose

end event

type dw_grafico from datawindow within w_cm503_proveedor_articulo
event ue_mouse_move pbm_mousemove
boolean visible = false
integer x = 631
integer y = 748
integer width = 2464
integer height = 1176
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_grf_articulo_proveedor_grf"
boolean controlmenu = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_mouse_move;Integer li_Rtn, li_Series, li_Category
String  ls_serie, ls_categ, ls_cantidad, ls_mensaje
Long    ll_row
grObjectType MouseMoveObject
  
MouseMoveObject = this.ObjectAtPointer('gr_1', li_Series, li_category)
  
IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN
  ls_categ    = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías
  ls_serie    = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo  ls_cantidad = String(this.GetData('gr_1', li_series, li_category), '###,##0.0000') //la etiqueta de los valores
  ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.0000') //la etiqueta de los valores
  ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'

  st_etiqueta.BringToTop = TRUE
  st_etiqueta.x = xpos
  st_etiqueta.y = ypos
  st_etiqueta.text = ls_mensaje
  st_etiqueta.width = len(ls_mensaje) * 30
  st_etiqueta.visible = true
ELSE
  st_etiqueta.visible = false
END IF
end event

event constructor;Settransobject(sqlca)
end event

type st_etiqueta from statictext within w_cm503_proveedor_articulo
boolean visible = false
integer x = 1842
integer y = 284
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

type dw_text from datawindow within w_cm503_proveedor_articulo
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 805
integer y = 260
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

type st_campo from statictext within w_cm503_proveedor_articulo
integer x = 14
integer y = 280
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
long backcolor = 67108864
string text = "Orden :"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_cm503_proveedor_articulo
integer x = 1806
integer y = 60
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detallado"
boolean checked = true
end type

type rb_2 from radiobutton within w_cm503_proveedor_articulo
integer x = 1810
integer y = 156
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
end type

