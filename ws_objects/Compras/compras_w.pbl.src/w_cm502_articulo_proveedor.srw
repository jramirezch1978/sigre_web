$PBExportHeader$w_cm502_articulo_proveedor.srw
forward
global type w_cm502_articulo_proveedor from w_rpt_list
end type
type gb_fechas from groupbox within w_cm502_articulo_proveedor
end type
type cb_3 from commandbutton within w_cm502_articulo_proveedor
end type
type uo_1 from u_ingreso_rango_fechas within w_cm502_articulo_proveedor
end type
type st_1 from statictext within w_cm502_articulo_proveedor
end type
type sle_mon from singlelineedit within w_cm502_articulo_proveedor
end type
type cb_1 from commandbutton within w_cm502_articulo_proveedor
end type
type sle_descrpcion from singlelineedit within w_cm502_articulo_proveedor
end type
type dw_detail from datawindow within w_cm502_articulo_proveedor
end type
type st_campo from statictext within w_cm502_articulo_proveedor
end type
type dw_text from datawindow within w_cm502_articulo_proveedor
end type
type dw_grafico from datawindow within w_cm502_articulo_proveedor
end type
type st_etiqueta from statictext within w_cm502_articulo_proveedor
end type
end forward

global type w_cm502_articulo_proveedor from w_rpt_list
integer width = 3543
integer height = 2000
string title = "Resumen de compras de articulos/proveedor (CM502)"
string menuname = "m_impresion"
boolean maxbox = false
windowstate windowstate = maximized!
long backcolor = 67108864
gb_fechas gb_fechas
cb_3 cb_3
uo_1 uo_1
st_1 st_1
sle_mon sle_mon
cb_1 cb_1
sle_descrpcion sle_descrpcion
dw_detail dw_detail
st_campo st_campo
dw_text dw_text
dw_grafico dw_grafico
st_etiqueta st_etiqueta
end type
global w_cm502_articulo_proveedor w_cm502_articulo_proveedor

type variables
String is_col
Integer		ii_grf_val_index = 4
end variables

on w_cm502_articulo_proveedor.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_fechas=create gb_fechas
this.cb_3=create cb_3
this.uo_1=create uo_1
this.st_1=create st_1
this.sle_mon=create sle_mon
this.cb_1=create cb_1
this.sle_descrpcion=create sle_descrpcion
this.dw_detail=create dw_detail
this.st_campo=create st_campo
this.dw_text=create dw_text
this.dw_grafico=create dw_grafico
this.st_etiqueta=create st_etiqueta
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_fechas
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_mon
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.sle_descrpcion
this.Control[iCurrent+8]=this.dw_detail
this.Control[iCurrent+9]=this.st_campo
this.Control[iCurrent+10]=this.dw_text
this.Control[iCurrent+11]=this.dw_grafico
this.Control[iCurrent+12]=this.st_etiqueta
end on

on w_cm502_articulo_proveedor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_fechas)
destroy(this.cb_3)
destroy(this.uo_1)
destroy(this.st_1)
destroy(this.sle_mon)
destroy(this.cb_1)
destroy(this.sle_descrpcion)
destroy(this.dw_detail)
destroy(this.st_campo)
destroy(this.dw_text)
destroy(this.dw_grafico)
destroy(this.st_etiqueta)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

event ue_retrieve;call super::ue_retrieve;Long 	ll_row
Date ld_desde, ld_hasta
String ls_cod,ls_moneda, ls_error

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()
ls_moneda = sle_mon.text


IF Isnull(ls_moneda) OR Trim(ls_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Moneda')
	Return
END IF

SetPointer(Hourglass!)

// Llena datos de dw seleccionados a tabla temporal
delete from tt_alm_seleccion;
FOR ll_row = 1 to dw_2.rowcount()
	ls_cod = dw_2.object.cod_art[ll_row]
	Insert into tt_alm_seleccion( cod_art) values ( :ls_cod);
NEXT	
		
DECLARE USP_CMP_ARTICULO_PROVEEDOR PROCEDURE FOR 
	USP_CMP_ARTICULO_PROVEEDOR(:ld_desde, 
										:ld_hasta ,
										:ls_moneda);
										
EXECUTE USP_CMP_ARTICULO_PROVEEDOR;

If sqlca.sqlcode = -1 then
	ls_error = SQLCA.SQLErrText
	ROLLBACK;
	messagebox("Error en el Store Procedure USP_CMP_ARTICULO_PROVEEDOR",ls_error)
	Return
end if

CLOSE USP_CMP_ARTICULO_PROVEEDOR;

dw_report.retrieve()
ib_preview = false
dw_report.ii_zoom_actual = 100
this.Event ue_preview()
dw_report.visible = true			
dw_report.object.titulo_1.text = 'Del ' + STRING(LD_DESDE, "DD/MM/YYYY") +&
					' Al :' + STRING(LD_HASTA, "DD/MM/YYYY")
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user		

end event

type dw_report from w_rpt_list`dw_report within w_cm502_articulo_proveedor
boolean visible = false
integer x = 23
integer y = 320
integer width = 3319
integer height = 1952
string dataobject = "d_cns_articulo_proveedor_303"
integer ii_sort = 0
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

String ls_prov,ls_cod_art,ls_descp

choose case dwo.name
		 case 'proveedor', 'proveedor_nom_proveedor'
				ls_prov	  = This.object.proveedor [row]
				ls_cod_art = This.object.cod_art   [row]
				ls_descp   = This.object.proveedor_nom_proveedor [row]
				
				dw_detail.title = ls_descp
				dw_detail.Retrieve(ls_prov,ls_cod_art)
				dw_detail.visible = true				
end choose

end event

type dw_1 from w_rpt_list`dw_1 within w_cm502_articulo_proveedor
integer x = 41
integer y = 512
integer width = 1623
integer height = 796
integer taborder = 50
string dataobject = "d_sel_compras_x_periodo_articulo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
integer ii_sort = 1
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

type pb_1 from w_rpt_list`pb_1 within w_cm502_articulo_proveedor
integer x = 1669
integer y = 764
integer taborder = 70
end type

event pb_1::clicked;call super::clicked;if dw_2.rowcount() > 0 then
	cb_report.enabled = true
end if
end event

type pb_2 from w_rpt_list`pb_2 within w_cm502_articulo_proveedor
integer x = 1678
integer y = 1008
integer taborder = 100
alignment htextalign = center!
end type

event pb_2::clicked;call super::clicked;if dw_2.rowcount() = 0 then
	cb_report.enabled = false
end if
end event

type dw_2 from w_rpt_list`dw_2 within w_cm502_articulo_proveedor
integer x = 1833
integer y = 512
integer width = 1623
integer height = 796
integer taborder = 90
string dataobject = "d_sel_compras_x_periodo_articulo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
integer ii_sort = 1
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2

ii_rk[1] = 1
ii_rk[2] = 2
end event

type cb_report from w_rpt_list`cb_report within w_cm502_articulo_proveedor
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

type gb_fechas from groupbox within w_cm502_articulo_proveedor
integer width = 1774
integer height = 300
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas"
end type

type cb_3 from commandbutton within w_cm502_articulo_proveedor
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

dw_1.retrieve(ld_desde, ld_hasta)


return 1


end event

type uo_1 from u_ingreso_rango_fechas within w_cm502_articulo_proveedor
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

type st_1 from statictext within w_cm502_articulo_proveedor
integer x = 73
integer y = 224
integer width = 256
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Moneda :"
boolean focusrectangle = false
end type

type sle_mon from singlelineedit within w_cm502_articulo_proveedor
integer x = 329
integer y = 224
integer width = 233
integer height = 64
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 3
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_moneda,ls_descripcion

ls_moneda = this.text

select descripcion into :ls_descripcion from moneda where cod_moneda = :ls_moneda ;

sle_descrpcion.text = ls_descripcion



end event

type cb_1 from commandbutton within w_cm502_articulo_proveedor
integer x = 585
integer y = 224
integer width = 123
integer height = 64
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar
	
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT MONEDA.COD_MONEDA AS CODIGO,'&        
								 +'MONEDA.DESCRIPCION AS DESCRIPCION '&     
								 +'FROM MONEDA '
															
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_mon.text        = lstr_seleccionar.param1[1]
	sle_descrpcion.text = lstr_seleccionar.param2[1]
END IF


end event

type sle_descrpcion from singlelineedit within w_cm502_articulo_proveedor
integer x = 731
integer y = 224
integer width = 1024
integer height = 64
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type dw_detail from datawindow within w_cm502_articulo_proveedor
boolean visible = false
integer x = 809
integer y = 352
integer width = 2199
integer height = 1412
integer taborder = 110
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_cns_articulo_proveedor_det_tbl"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;Settransobject(sqlca)
end event

event buttonclicked;String ls_titulo

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
			ls_titulo = 'Prov :'+Mid(ls_nom_prov,1,50)+' Art : '+Mid(ls_nom_art,1,40)			
			dw_grafico.Object.gr_1.Title = trim(ls_titulo)


			This.visible = FALSE

end choose

end event

type st_campo from statictext within w_cm502_articulo_proveedor
integer x = 50
integer y = 416
integer width = 622
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

type dw_text from datawindow within w_cm502_articulo_proveedor
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 695
integer y = 408
integer width = 969
integer height = 76
integer taborder = 20
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

event constructor;Long ll_reg

ll_reg = this.insertrow(0)
end event

type dw_grafico from datawindow within w_cm502_articulo_proveedor
event ue_mouse_move pbm_mousemove
boolean visible = false
integer x = 626
integer y = 524
integer width = 2418
integer height = 1168
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_grf_articulo_proveedor_grf"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
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

event constructor;settransobject(sqlca)
end event

type st_etiqueta from statictext within w_cm502_articulo_proveedor
boolean visible = false
integer x = 1833
integer y = 696
integer width = 402
integer height = 64
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

