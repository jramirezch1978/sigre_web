$PBExportHeader$w_al705_kardex.srw
forward
global type w_al705_kardex from w_rpt_list
end type
type gb_tipo_reporte from groupbox within w_al705_kardex
end type
type gb_fechas from groupbox within w_al705_kardex
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_al705_kardex
end type
type cbx_val from checkbox within w_al705_kardex
end type
type cb_seleccionar from commandbutton within w_al705_kardex
end type
type st_1 from statictext within w_al705_kardex
end type
type dw_text from datawindow within w_al705_kardex
end type
type cb_filtrar from commandbutton within w_al705_kardex
end type
type cbx_2und from checkbox within w_al705_kardex
end type
type sle_almacen from singlelineedit within w_al705_kardex
end type
type sle_descrip from singlelineedit within w_al705_kardex
end type
type hpb_1 from hprogressbar within w_al705_kardex
end type
type gb_1 from groupbox within w_al705_kardex
end type
type rb_detalle from radiobutton within w_al705_kardex
end type
type rb_resumen from radiobutton within w_al705_kardex
end type
end forward

global type w_al705_kardex from w_rpt_list
integer width = 4325
integer height = 2516
string title = "Kardex (AL705)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 1073741824
gb_tipo_reporte gb_tipo_reporte
gb_fechas gb_fechas
uo_fecha uo_fecha
cbx_val cbx_val
cb_seleccionar cb_seleccionar
st_1 st_1
dw_text dw_text
cb_filtrar cb_filtrar
cbx_2und cbx_2und
sle_almacen sle_almacen
sle_descrip sle_descrip
hpb_1 hpb_1
gb_1 gb_1
rb_detalle rb_detalle
rb_resumen rb_resumen
end type
global w_al705_kardex w_al705_kardex

type variables
String is_ope_vta, is_almacen, is_col = '', is_type
Integer ii_index

end variables

on w_al705_kardex.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_tipo_reporte=create gb_tipo_reporte
this.gb_fechas=create gb_fechas
this.uo_fecha=create uo_fecha
this.cbx_val=create cbx_val
this.cb_seleccionar=create cb_seleccionar
this.st_1=create st_1
this.dw_text=create dw_text
this.cb_filtrar=create cb_filtrar
this.cbx_2und=create cbx_2und
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.hpb_1=create hpb_1
this.gb_1=create gb_1
this.rb_detalle=create rb_detalle
this.rb_resumen=create rb_resumen
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_tipo_reporte
this.Control[iCurrent+2]=this.gb_fechas
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.cbx_val
this.Control[iCurrent+5]=this.cb_seleccionar
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.dw_text
this.Control[iCurrent+8]=this.cb_filtrar
this.Control[iCurrent+9]=this.cbx_2und
this.Control[iCurrent+10]=this.sle_almacen
this.Control[iCurrent+11]=this.sle_descrip
this.Control[iCurrent+12]=this.hpb_1
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.rb_detalle
this.Control[iCurrent+15]=this.rb_resumen
end on

on w_al705_kardex.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_tipo_reporte)
destroy(this.gb_fechas)
destroy(this.uo_fecha)
destroy(this.cbx_val)
destroy(this.cb_seleccionar)
destroy(this.st_1)
destroy(this.dw_text)
destroy(this.cb_filtrar)
destroy(this.cbx_2und)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.hpb_1)
destroy(this.gb_1)
destroy(this.rb_detalle)
destroy(this.rb_resumen)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = p_pie.y - dw_report.y

dw_1.height = p_pie.y - dw_1.y
dw_2.height = p_pie.y - dw_2.y
end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "XLS Files (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type p_pie from w_rpt_list`p_pie within w_al705_kardex
end type

type ole_skin from w_rpt_list`ole_skin within w_al705_kardex
end type

type uo_h from w_rpt_list`uo_h within w_al705_kardex
end type

type st_box from w_rpt_list`st_box within w_al705_kardex
end type

type phl_logonps from w_rpt_list`phl_logonps within w_al705_kardex
end type

type p_mundi from w_rpt_list`p_mundi within w_al705_kardex
end type

type p_logo from w_rpt_list`p_logo within w_al705_kardex
end type

type dw_report from w_rpt_list`dw_report within w_al705_kardex
boolean visible = false
integer x = 494
integer y = 524
integer width = 3319
integer height = 1960
integer taborder = 30
end type

type dw_1 from w_rpt_list`dw_1 within w_al705_kardex
integer x = 503
integer y = 624
integer width = 1669
integer height = 1416
integer taborder = 100
string dataobject = "d_sel_mov_almacen_seleccion"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;this.SettransObject( sqlca)
ii_ck[1] = 1 
ii_ck[2] = 2
ii_ck[3] = 3

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
end event

event dw_1::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column 
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
//messagebox( ls_column, li_pos)
IF li_pos > 0 THEN
	is_col = mid(ls_column,1,li_pos - 1)
	
	st_1.text = "Busca x: " + dw_1.describe( is_col + "_t.text")
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()	
	is_type = LEFT( this.Describe(is_col + ".ColType"),1)
END  IF

end event

event dw_1::getfocus;call super::getfocus;dw_text.SetFocus()
end event

type pb_2 from w_rpt_list`pb_2 within w_al705_kardex
integer x = 2199
integer y = 1268
integer taborder = 130
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_al705_kardex
integer x = 2386
integer y = 624
integer width = 1669
integer height = 1416
integer taborder = 120
string dataobject = "d_sel_mov_almacen_seleccion"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;this.SettransObject( sqlca)

ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
end event

type cb_report from w_rpt_list`cb_report within w_al705_kardex
integer x = 3543
integer y = 292
integer width = 366
integer height = 84
integer taborder = 80
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;call super::clicked;Date 		ld_desde, ld_hasta
double 	ln_saldo
string	ls_mensaje, ls_flag_2und, ls_cod
Long 		ll_row



ld_desde = uo_fecha.of_get_fecha1()
ld_hasta = uo_fecha.of_get_fecha2()

SetPointer( Hourglass!)

dw_report.setfilter('')
// Verifica el tipo de listado
if rb_detalle.checked = false and rb_resumen.checked = false then
	Messagebox( "Aviso", "Debe indicar el tipo de reporte")
	return
end if

is_almacen = sle_almacen.text

if is_almacen = '' then
	Messagebox( "Aviso", "Indique almacen")
	return
end if

if cbx_2und.checked then
	ls_flag_2und = '1'
else
	ls_flag_2und = '0'
end if

if dw_2.rowcount() = 0 then return	

// Llena datos de dw seleccionados a tabla temporal
delete from tt_alm_seleccion;
commit;

	
hpb_1.Maxposition = 1000
hpb_1.Minposition = 0
	
FOR ll_row = 1 to dw_2.rowcount()
	hpb_1.Position = Integer((ll_row / dw_2.RowCount( )) * 1000)
	hpb_1.visible = true
	SetMicrohelp( "Articulo: " + string(ll_row) + " de " + string(dw_2.rowcount()) )
	
	ls_cod = dw_2.object.cod_art[ll_row]		
	Insert into tt_alm_seleccion( 
			cod_Art, fecha1, fecha2) 
	values ( 
			:ls_cod, :ld_desde, :ld_hasta);		
			
	If sqlca.sqlcode = -1 then
		ls_mensaje = SQLCA.SQLerrtext
		ROLLBACK;
		messagebox("Error al insertar registro en tt_alm_seleccion",ls_mensaje)
		return
	END IF

NEXT	

hpb_1.visible = false
setMicrohelp( "Ejecutando Procedimiento" )

if rb_detalle.checked = true then
	DECLARE usp_alm_kardex_det PROCEDURE FOR 
			usp_alm_kardex_det(:ld_desde, :ld_hasta, :is_almacen);
			
  	EXECUTE usp_alm_kardex_det;
	
	If sqlca.sqlcode = -1 then
		ls_mensaje = SQLCA.sqlerrtext
		ROLLBACK;
		messagebox("Error en usp_alm_kardex_det", ls_mensaje)
		return 0
	end if
		
	close usp_alm_kardex_det;
	
	IF cbx_val.checked = TRUE THEN
		dw_report.dataobject = 'd_rpt_kardex_art_det_val_tbl'
	ELSE
		if cbx_2und.checked = false then
			dw_report.dataobject = 'd_rpt_kardex_art_det_tbl'
		else
			dw_report.dataobject = 'd_rpt_kardex_art_det_2und_tbl'
		end if
	END IF
else		
	 DECLARE USP_ALM_KARDEX PROCEDURE FOR 
	 		USP_ALM_KARDEX (:ld_desde, :ld_hasta, :is_almacen);
	execute USP_ALM_KARDEX;
	
	If sqlca.sqlcode = -1  then
		ls_mensaje = SQLCA.sqlerrtext
		ROLLBACK;
		messagebox("Error en usp_alm_kardex", ls_mensaje)
		return 0
	end if
	
	close USP_ALM_KARDEX;
	
	IF cbx_val.checked = TRUE THEN
		dw_report.dataobject = 'd_rpt_kardex_art_res_val_tbl'
	ELSE			
		if cbx_2und.checked = false then
			dw_report.dataobject = 'd_rpt_kardex_art_res_tbl'
		else
			dw_report.dataobject = 'd_rpt_kardex_art_res_und2_tbl'
		end if
	END IF
end if
	
dw_1.visible = false
dw_2.visible = false		
ib_preview = false		
parent.Event ue_preview()		
dw_report.SetTransObject( sqlca)
dw_report.retrieve()	
dw_report.visible = true
dw_report.object.fec_ini.text 	= STRING(LD_DESDE, "DD/MM/YYYY")
dw_report.object.fec_fin.text 	= STRING(LD_HASTA, "DD/MM/YYYY")
dw_report.object.t_user.text 		= gnvo_app.is_user
dw_report.object.t_almacen.text 	= sle_descrip.text
dw_report.Object.p_logo.filename = gnvo_app.is_logo
	
cb_seleccionar.enabled = true
cb_seleccionar.visible = true

end event

type pb_1 from w_rpt_list`pb_1 within w_al705_kardex
integer x = 2199
integer y = 1100
integer taborder = 110
end type

event pb_1::clicked;call super::clicked;if dw_2.Rowcount() > 0 then
	cb_report.enabled = true
end if
	
end event

type gb_tipo_reporte from groupbox within w_al705_kardex
integer x = 2784
integer y = 172
integer width = 667
integer height = 224
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Tipo Reporte"
end type

type gb_fechas from groupbox within w_al705_kardex
integer x = 507
integer y = 208
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
end type

type uo_fecha from u_ingreso_rango_fechas_v within w_al705_kardex
integer x = 535
integer y = 252
integer taborder = 10
boolean bringtotop = true
long backcolor = 1073741824
end type

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event ue_output;call super::ue_output;cb_seleccionar.enabled = true
end event

type cbx_val from checkbox within w_al705_kardex
integer x = 2766
integer y = 416
integer width = 357
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "Valorizado"
end type

type cb_seleccionar from commandbutton within w_al705_kardex
boolean visible = false
integer x = 3543
integer y = 196
integer width = 366
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Seleccionar"
end type

event clicked;// Crea archivo temporal
string ls_almacen

if cbx_2und.checked = false then
	dw_1.dataobject = 'd_sel_mov_almacen_seleccion'
else
	dw_1.dataObject = 'd_sel_mov_alm_sel_2und'
end if

ls_almacen = sle_almacen.text

dw_1.SetTransObject(SQLCA)
dw_1.retrieve(ls_almacen)

dw_1.visible = true
dw_2.visible = true
dw_report.visible = false	

cb_seleccionar.visible = false


end event

type st_1 from statictext within w_al705_kardex
integer x = 503
integer y = 544
integer width = 494
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Buscar por:"
boolean focusrectangle = false
end type

type dw_text from datawindow within w_al705_kardex
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 1010
integer y = 536
integer width = 1157
integer height = 80
integer taborder = 90
boolean bringtotop = true
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type long ue_tecla(keycode key, unsignedlong keyflags);Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_text.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if
ll_row = dw_1.Getrow()
return  0
//dw_lista.SelectRow(0, false)
//dw_lista.SelectRow(ll_row, true)
//dw_1.object.campo[1] = dw_lista.GetItemString(ll_row, is_col)
end event

event type long dwnenter();//Send(Handle(this),256,9,Long(0,0))
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
Long ll_fila, li_x

SetPointer(hourglass!)

String ls_campo

if TRIM( is_col) <> '' THEN

	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)	
	if li_longitud > 0 then		// si ha escrito algo	   
	   IF UPPER( is_type) = 'N' then
			ls_comando = is_col + "=" + ls_item 
		ELSEIF UPPER( is_type) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF

		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())	
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_1.selectrow(0, false)
			dw_1.selectrow(ll_fila,true)
			dw_1.scrolltorow(ll_fila)
		end if
	End if	
else
	Messagebox( "Aviso", "Seleccione el orden haciendo doble click en el titulo")
	dw_text.reset()
	this.insertrow(0)
end if	
SetPointer(arrow!)
end event

type cb_filtrar from commandbutton within w_al705_kardex
integer x = 3543
integer y = 392
integer width = 366
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Filtrar"
end type

event clicked;str_parametros lstr_1

lstr_1.dw_m = dw_report
openwithparm (w_filtros, lstr_1)
end event

type cbx_2und from checkbox within w_al705_kardex
boolean visible = false
integer x = 3145
integer y = 420
integer width = 366
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean enabled = false
string text = "2º Unidad"
end type

event clicked;dw_1.Reset()
cb_seleccionar.visible = true

if this.checked then
	cbx_val.visible = false
	cbx_val.checked = false
else
	cbx_val.visible = true
end if
end event

type sle_almacen from singlelineedit within w_al705_kardex
event dobleclick pbm_lbuttondblclk
integer x = 1221
integer y = 260
integer width = 224
integer height = 88
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " &
		 + "where flag_tipo_almacen <> 'O' " &
		 + "  and cod_empresa = '" + gnvo_app.invo_empresa.is_empresa + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
	Parent.event dynamic ue_seleccionar()
	cb_seleccionar.visible = true
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen 
  and flag_tipo_almacen <> 'O';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe o es un almacén de tránsito')
	return
end if

sle_descrip.text = ls_desc
Parent.event dynamic ue_seleccionar()
cb_seleccionar.visible = true

end event

type sle_descrip from singlelineedit within w_al705_kardex
integer x = 1449
integer y = 260
integer width = 1211
integer height = 88
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type hpb_1 from hprogressbar within w_al705_kardex
boolean visible = false
integer x = 1230
integer y = 384
integer width = 1431
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

type gb_1 from groupbox within w_al705_kardex
integer x = 1193
integer y = 184
integer width = 1518
integer height = 300
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Almacen:"
end type

type rb_detalle from radiobutton within w_al705_kardex
integer x = 2825
integer y = 236
integer width = 594
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Detalle"
boolean lefttext = true
end type

type rb_resumen from radiobutton within w_al705_kardex
integer x = 2825
integer y = 312
integer width = 594
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Resumen"
boolean lefttext = true
end type

