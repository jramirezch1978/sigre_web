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
type rb_detalle from radiobutton within w_al705_kardex
end type
type rb_resumen from radiobutton within w_al705_kardex
end type
type cbx_val from checkbox within w_al705_kardex
end type
type cb_seleccionar from commandbutton within w_al705_kardex
end type
type st_1 from statictext within w_al705_kardex
end type
type dw_text from datawindow within w_al705_kardex
end type
type cbx_2und from checkbox within w_al705_kardex
end type
type sle_almacen from singlelineedit within w_al705_kardex
end type
type sle_descrip from singlelineedit within w_al705_kardex
end type
type hpb_1 from hprogressbar within w_al705_kardex
end type
type cbx_fecha from checkbox within w_al705_kardex
end type
type cbx_todos from checkbox within w_al705_kardex
end type
type rb_articulo from radiobutton within w_al705_kardex
end type
type rb_subcategoria from radiobutton within w_al705_kardex
end type
type rb_categoria from radiobutton within w_al705_kardex
end type
type gb_1 from groupbox within w_al705_kardex
end type
type gb_2 from groupbox within w_al705_kardex
end type
type gb_3 from groupbox within w_al705_kardex
end type
end forward

global type w_al705_kardex from w_rpt_list
integer width = 4974
integer height = 2516
string title = "Kardex (AL705)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_seleccionar ( )
gb_tipo_reporte gb_tipo_reporte
gb_fechas gb_fechas
uo_fecha uo_fecha
rb_detalle rb_detalle
rb_resumen rb_resumen
cbx_val cbx_val
cb_seleccionar cb_seleccionar
st_1 st_1
dw_text dw_text
cbx_2und cbx_2und
sle_almacen sle_almacen
sle_descrip sle_descrip
hpb_1 hpb_1
cbx_fecha cbx_fecha
cbx_todos cbx_todos
rb_articulo rb_articulo
rb_subcategoria rb_subcategoria
rb_categoria rb_categoria
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_al705_kardex w_al705_kardex

type variables
String is_ope_vta, is_col = '', is_type
Integer ii_index

end variables

event ue_seleccionar();// Crea archivo temporal
string 	ls_almacen
Date		ld_fecha2

ld_fecha2 = uo_fecha.of_get_fecha2()

if cbx_2und.checked = false then
	
	if rb_articulo.checked then
		dw_1.dataobject = 'd_sel_mov_articulos_seleccion'
		dw_2.dataObject = 'd_sel_mov_articulos_seleccionados'
	elseif rb_subcategoria.checked then
		dw_1.dataObject = 'd_sel_mov_subcategorias'
		dw_2.dataObject = 'd_sel_mov_subcategoria_seleccionados'
	elseif rb_Categoria.checked then
		dw_1.dataObject = 'd_sel_mov_categorias'
		dw_2.dataObject = 'd_sel_mov_categorias_seleccionados'
	end if

else
	if rb_articulo.checked then
		dw_1.dataObject = 'd_sel_mov_alm_sel_2und'
		dw_2.dataObject = 'd_sel_mov_articulos_seleccionados'
	elseif rb_subcategoria.checked then
		dw_1.dataObject = 'd_sel_mov_subcateg_sel_2und'
		dw_2.dataObject = 'd_sel_mov_subcategoria_seleccionados'
	elseif rb_Categoria.checked then
		dw_1.dataObject = 'd_sel_mov_categ_sel_2und'
		dw_2.dataObject = 'd_sel_mov_categorias_seleccionados'
	end if
end if

if cbx_todos.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		MessageBox('Error', 'Debe Seleccionar primero un almacén, por favor verifique!')
		sle_almacen.setfocus( )
		return
	end if
	ls_almacen = trim(sle_almacen.text) +'%'
end if


dw_1.SetTransObject(SQLCA)
dw_1.retrieve(ls_almacen, ld_fecha2)

dw_2.SetTransObject(SQLCA)
dw_2.retrieve(ls_almacen)


dw_1.visible = true
dw_2.visible = true

dw_report.visible = false	

cb_seleccionar.visible = false


end event

on w_al705_kardex.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_tipo_reporte=create gb_tipo_reporte
this.gb_fechas=create gb_fechas
this.uo_fecha=create uo_fecha
this.rb_detalle=create rb_detalle
this.rb_resumen=create rb_resumen
this.cbx_val=create cbx_val
this.cb_seleccionar=create cb_seleccionar
this.st_1=create st_1
this.dw_text=create dw_text
this.cbx_2und=create cbx_2und
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.hpb_1=create hpb_1
this.cbx_fecha=create cbx_fecha
this.cbx_todos=create cbx_todos
this.rb_articulo=create rb_articulo
this.rb_subcategoria=create rb_subcategoria
this.rb_categoria=create rb_categoria
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_tipo_reporte
this.Control[iCurrent+2]=this.gb_fechas
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.rb_detalle
this.Control[iCurrent+5]=this.rb_resumen
this.Control[iCurrent+6]=this.cbx_val
this.Control[iCurrent+7]=this.cb_seleccionar
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.dw_text
this.Control[iCurrent+10]=this.cbx_2und
this.Control[iCurrent+11]=this.sle_almacen
this.Control[iCurrent+12]=this.sle_descrip
this.Control[iCurrent+13]=this.hpb_1
this.Control[iCurrent+14]=this.cbx_fecha
this.Control[iCurrent+15]=this.cbx_todos
this.Control[iCurrent+16]=this.rb_articulo
this.Control[iCurrent+17]=this.rb_subcategoria
this.Control[iCurrent+18]=this.rb_categoria
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_2
this.Control[iCurrent+21]=this.gb_3
end on

on w_al705_kardex.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_tipo_reporte)
destroy(this.gb_fechas)
destroy(this.uo_fecha)
destroy(this.rb_detalle)
destroy(this.rb_resumen)
destroy(this.cbx_val)
destroy(this.cb_seleccionar)
destroy(this.st_1)
destroy(this.dw_text)
destroy(this.cbx_2und)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.hpb_1)
destroy(this.cbx_fecha)
destroy(this.cbx_todos)
destroy(this.rb_articulo)
destroy(this.rb_subcategoria)
destroy(this.rb_categoria)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

pb_1.x = newwidth / 2 - pb_1.width / 2
pb_2.x = newwidth / 2 - pb_2.width / 2

dw_1.height = newheight - dw_1.y - 10
dw_1.width = pb_1.x - dw_1.x - 10


dw_2.x = pb_1.x + pb_1.width + 10
dw_2.width = newwidth - dw_2.x - 10
dw_2.height = newheight - dw_2.y - 10

dw_text.width = dw_1.width + dw_1.x - dw_text.x
end event

event ue_open_pre;call super::ue_open_pre;delete from tt_alm_seleccion;
commit;

//por defecto no debe cargar los articulos hasta que haga click en seleccionar o modifique el almacen
//this.event ue_seleccionar( )
end event

event ue_filter_avanzado;//Override
dw_report.EVENT ue_filter_avanzado()
end event

event ue_retrieve;call super::ue_retrieve;Date 		ld_desde, ld_hasta
double 	ln_saldo
string	ls_mensaje, ls_flag_2und, ls_codigo, ls_nom_empresa, ls_almacen
String	ls_campos[] = {"ingresos_und", "stock_inicial", "saldo_inicial", "ingresos", "importe_ingresos", &
								"salidas", "importe_salidas", "stock_final", "saldo_final", "stock_inicial_und2", &
								"ingresos_und2", "salidas_und2", "stock_final_und2", "precio_saldo_anterior", &
								"precio_ingresos", "precio_salidas", "precio_saldo_actual", "saldo_actual", &
								"importe_actual", "precio_saldo_actual"}
Long 		ll_row, ll_default_color, ll_i


try 
	SetPointer( Hourglass!)
	
	ll_default_color = 16777215 			//white
	ld_desde = uo_fecha.of_get_fecha1()
	ld_hasta = uo_fecha.of_get_fecha2()
	
	if cbx_todos.checked then
		ls_almacen = '%%'
	else
		if trim(sle_almacen.text) = '' then
			MessageBox("Error", "Debe indicar un almacen primero, por favor verifique!")
			sle_almacen.setFocus( )
			return
		end if
		ls_almacen = trim(sle_almacen.text) + '%'
	end if
	
	dw_report.setfilter('')
	// Verifica el tipo de listado
	if rb_detalle.checked = false and rb_resumen.checked = false then
		Messagebox( "Aviso", "Debe indicar el tipo de reporte")
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
		
		SetMicrohelp( "Registro: " + string(ll_row) + " de " + string(dw_2.rowcount()) )
		
		if rb_articulo.checked then
			
			ls_codigo = dw_2.object.cod_art[ll_row]		
			Insert into tt_alm_seleccion( 
					cod_Art, fecha1, fecha2) 
			values ( 
					:ls_codigo, :ld_desde, :ld_hasta);		
					
		elseif rb_subcategoria.checked then
			
			ls_codigo = dw_2.object.cod_sub_cat[ll_row]		
			Insert into tt_alm_seleccion( 
					cod_sub_cat, fecha1, fecha2) 
			values ( 
					:ls_codigo, :ld_desde, :ld_hasta);	
					
		elseif rb_categoria.checked then
			
			ls_codigo = dw_2.object.cat_art[ll_row]		
			Insert into tt_alm_seleccion( 
					cat_art, fecha1, fecha2) 
			values ( 
					:ls_codigo, :ld_desde, :ld_hasta);	
					
		end if
					
		If sqlca.sqlcode = -1 then
			ls_mensaje = SQLCA.SQLerrtext
			ROLLBACK;
			messagebox("Error al insertar registro en tt_alm_seleccion",ls_mensaje)
			return
		END IF
	
	NEXT	
	
	hpb_1.visible = false
	setMicrohelp( "Ejecutando Procedimiento" )
	
	if rb_categoria.checked then
		if rb_resumen.checked then
			//Resumido
			if cbx_val.checked then
				if cbx_2und.checked then
					dw_report.dataobject = 'd_rpt_kardex_res_categ_val_2und_tbl'
				else
					dw_report.dataobject = 'd_rpt_kardex_res_categ_val_tbl'
				end if
			else
				if cbx_2und.checked then
					dw_report.dataobject = 'd_rpt_kardex_res_categ_2und_tbl'
				else
					dw_report.dataobject = 'd_rpt_kardex_res_categ_tbl'
				end if
			end if
		else
			//Detallado
			if cbx_val.checked then
				if cbx_2und.checked then
					dw_report.dataobject = 'd_rpt_kardex_categ_det_val_und2_tbl'
				else
					dw_report.dataobject = 'd_rpt_kardex_categ_det_val_tbl'
				end if
			else
				if cbx_2und.checked then
					dw_report.dataobject = 'd_rpt_kardex_categ_det_und2_tbl'
				else
					dw_report.dataobject = 'd_rpt_kardex_categ_det_tbl'
				end if
			end if
		end if
	elseif rb_subcategoria.checked then
		if rb_resumen.checked then
			//Resumido
			if cbx_val.checked then
				if cbx_2und.checked then
					dw_report.dataobject = 'd_rpt_kardex_res_subcateg_val_2und_tbl'
				else
					dw_report.dataobject = 'd_rpt_kardex_res_subcateg_val_tbl'
				end if
			else
				if cbx_2und.checked then
					dw_report.dataobject = 'd_rpt_kardex_res_subcateg_2und_tbl'
				else
					dw_report.dataobject = 'd_rpt_kardex_res_subcateg_tbl'
				end if
			end if
		else
			//Detallado
			if cbx_val.checked then
				if cbx_2und.checked then
					dw_report.dataobject = 'd_rpt_kardex_subcateg_det_val_und2_tbl'
				else
					dw_report.dataobject = 'd_rpt_kardex_subcateg_det_val_tbl'
				end if
			else
				if cbx_2und.checked then
					dw_report.dataobject = 'd_rpt_kardex_subcateg_det_und2_tbl'
				else
					dw_report.dataobject = 'd_rpt_kardex_subcateg_det_tbl'
				end if
			end if
		end if
	elseif rb_articulo.checked then
		if rb_resumen.checked then
			//Resumido
			if cbx_val.checked then
				if cbx_2und.checked then
					dw_report.dataobject = 'd_rpt_kardex_res_articulo_val_2und_tbl'
				else
					dw_report.dataobject = 'd_rpt_kardex_res_articulo_val_tbl'
				end if
			else
				if cbx_2und.checked then
					dw_report.dataobject = 'd_rpt_kardex_res_articulo_2und_tbl'
				else
					dw_report.dataobject = 'd_rpt_kardex_res_articulo_tbl'
				end if
			end if
		else
			//Detallado
			if cbx_val.checked then
				if cbx_2und.checked then
					dw_report.dataobject = 'd_rpt_kardex_articulo_det_val_und2_tbl'
				else
					dw_report.dataobject = 'd_rpt_kardex_articulo_det_val_tbl'
				end if
			else
				if cbx_2und.checked then
					dw_report.dataobject = 'd_rpt_kardex_articulo_det_und2_tbl'
				else
					dw_report.dataobject = 'd_rpt_kardex_articulo_det_tbl'
				end if
			end if
		end if
	end if
	/*else
		if rb_detalle.checked = true then
			DECLARE usp_alm_kardex_det PROCEDURE FOR 
					usp_alm_kardex_det(:ld_desde, :ld_hasta, :ls_almacen);
					
			EXECUTE usp_alm_kardex_det;
			
			If sqlca.sqlcode = -1 then
				ls_mensaje = SQLCA.sqlerrtext
				ROLLBACK;
				messagebox("Error en usp_alm_kardex_det", ls_mensaje)
				return 
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
					USP_ALM_KARDEX (:ld_desde, :ld_hasta, :ls_almacen);
			execute USP_ALM_KARDEX;
			
			If sqlca.sqlcode = -1  then
				ls_mensaje = SQLCA.sqlerrtext
				ROLLBACK;
				messagebox("Error en usp_alm_kardex", ls_mensaje)
				return 
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
	end if
	*/
		
	dw_1.visible = false
	dw_2.visible = false		
	ib_preview = false		
	this.Event ue_preview()		
	dw_report.SetTransObject( sqlca)
	dw_report.retrieve(ld_desde, ld_hasta, ls_almacen)	
	dw_report.visible = true
	
	dw_report.object.fec_ini.text 	= STRING(LD_DESDE, "DD/MM/YYYY")
	dw_report.object.fec_fin.text 	= STRING(LD_HASTA, "DD/MM/YYYY")
	dw_report.object.t_user.text 		= gs_user
	dw_report.object.t_ruc.text 		= gnvo_app.empresa.is_ruc
	dw_report.object.t_empresa.text 	= gnvo_app.empresa.is_nom_empresa
	dw_report.object.t_objeto.text 	= this.ClassName()
	
	dw_report.Object.p_logo.filename = gs_logo
	
	//Aplicacion de Colores
	for ll_i = 1 to UpperBound(ls_campos[]) 
		if dw_report.of_existecampo( ls_campos[ll_i] ) then
			dw_report.Modify(ls_campos[ll_i] + ".Background.Color = '" &
					+ String(ll_default_color) &
					+ "~tIf(round(" + ls_campos[ll_i] + ", 2) < 0, RGB(255, 0, 0), RGB(255, 255, 255))'")
			dw_report.Modify(ls_campos[ll_i] + ".Color = '0" &
					+ "~tIf(round(" + ls_campos[ll_i] + ", 2) < 0, RGB(255, 255, 255), RGB(0, 0, 0))'")
		end if
	next
	

	cb_seleccionar.enabled = true
	cb_seleccionar.visible = true

	
catch ( Exception ex )
	ROLLBACK;
	MessageBox('Exception Error', "Ha ocurrido un error: " + ex.getMessage())
finally
	SetPointer( Arrow!)
end try


end event

type dw_report from w_rpt_list`dw_report within w_al705_kardex
boolean visible = false
integer x = 0
integer y = 308
integer width = 3319
integer height = 1960
integer taborder = 30
string dataobject = "d_rpt_kardex_art_det_tbl"
end type

type dw_1 from w_rpt_list`dw_1 within w_al705_kardex
integer x = 32
integer y = 400
integer width = 1669
integer height = 1416
integer taborder = 100
string dataobject = "d_sel_mov_articulos_seleccion"
end type

event dw_1::constructor;call super::constructor;this.SettransObject( sqlca)

ii_ck[1] = 1				// columnas de lectrua de este dw
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

event dw_1::ue_selected_row_pro;//Overiding
Long	ll_row, ll_rc, ll_count
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)

FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)


end event

type pb_1 from w_rpt_list`pb_1 within w_al705_kardex
integer x = 1728
integer y = 876
integer taborder = 110
end type

event pb_1::clicked;call super::clicked;if dw_2.Rowcount() > 0 then
	cb_report.enabled = true
end if
	
end event

type pb_2 from w_rpt_list`pb_2 within w_al705_kardex
integer x = 1728
integer y = 1044
integer taborder = 130
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_al705_kardex
integer x = 1915
integer y = 400
integer width = 1669
integer height = 1416
integer taborder = 120
string dataobject = "d_sel_mov_articulos_seleccionados"
end type

event dw_2::constructor;call super::constructor;this.SettransObject( sqlca)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_2::ue_selected_row_pro;//Overiding
Long	ll_row, ll_rc, ll_count
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)

FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)


end event

type cb_report from w_rpt_list`cb_report within w_al705_kardex
integer x = 4091
integer y = 116
integer width = 398
integer height = 100
integer taborder = 80
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;call super::clicked;setPointer(Hourglass!)
parent.event ue_retrieve( )
setPointer(Arrow!)
end event

type gb_tipo_reporte from groupbox within w_al705_kardex
integer x = 2967
integer width = 667
integer height = 284
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nivel de Detalle"
end type

type gb_fechas from groupbox within w_al705_kardex
integer x = 18
integer y = 4
integer width = 695
integer height = 288
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

type uo_fecha from u_ingreso_rango_fechas_v within w_al705_kardex
integer x = 46
integer y = 64
integer taborder = 10
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

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event ue_output;call super::ue_output;cb_seleccionar.enabled = true
end event

type rb_detalle from radiobutton within w_al705_kardex
integer x = 2304
integer y = 64
integer width = 594
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
boolean lefttext = true
end type

type rb_resumen from radiobutton within w_al705_kardex
integer x = 2304
integer y = 136
integer width = 594
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
boolean checked = true
boolean lefttext = true
end type

type cbx_val from checkbox within w_al705_kardex
integer x = 3662
integer y = 52
integer width = 384
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Valorizado"
end type

event clicked;//cb_seleccionar.enabled = true
//cb_seleccionar.visible = true
end event

type cb_seleccionar from commandbutton within w_al705_kardex
integer x = 4091
integer y = 20
integer width = 398
integer height = 100
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

event clicked;setPointer(Hourglass!)
parent.event ue_seleccionar( )
setPointer(Arrow!)
end event

type st_1 from statictext within w_al705_kardex
integer x = 41
integer y = 328
integer width = 480
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
string text = "Buscar por:"
boolean focusrectangle = false
end type

type dw_text from datawindow within w_al705_kardex
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 567
integer y = 320
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

type cbx_2und from checkbox within w_al705_kardex
integer x = 3657
integer y = 164
integer width = 393
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "2º Unidad"
end type

event clicked;//dw_1.Reset()
//cb_seleccionar.visible = true

//if this.checked then
//	cbx_val.visible = false
//	cbx_val.checked = false
//else
//	cbx_val.visible = true
//end if

//parent.event ue_seleccionar( )
end event

type sle_almacen from singlelineedit within w_al705_kardex
event dobleclick pbm_lbuttondblclk
integer x = 759
integer y = 80
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
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " &
		 + "where flag_tipo_almacen <> 'O'"
				 
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
integer x = 987
integer y = 80
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
integer x = 768
integer y = 204
integer width = 1431
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

type cbx_fecha from checkbox within w_al705_kardex
integer x = 1810
integer y = 192
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Imprimir Fecha"
boolean checked = true
end type

event clicked;if this.checked then
	dw_report.object.t_fecha.visible = 'yes'
else
	dw_report.object.t_fecha.visible = 'no'
end if
end event

type cbx_todos from checkbox within w_al705_kardex
integer x = 759
integer y = 192
integer width = 581
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los almacenes"
boolean checked = true
end type

event clicked;if cbx_todos.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
cb_seleccionar.enabled = true
cb_seleccionar.visible = true
end event

type rb_articulo from radiobutton within w_al705_kardex
integer x = 2999
integer y = 60
integer width = 594
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Artículo"
boolean checked = true
boolean lefttext = true
end type

event clicked;cb_seleccionar.enabled = true
cb_seleccionar.visible = true

delete tt_alm_seleccion;
commit;
dw_1.Reset()

//parent.event ue_seleccionar( )

end event

type rb_subcategoria from radiobutton within w_al705_kardex
integer x = 2999
integer y = 128
integer width = 594
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Subcategoría"
boolean lefttext = true
end type

event clicked;cb_seleccionar.enabled = true
cb_seleccionar.visible = true

delete tt_alm_seleccion;
commit;
dw_1.Reset()

//parent.event ue_seleccionar( )
end event

type rb_categoria from radiobutton within w_al705_kardex
integer x = 2999
integer y = 196
integer width = 594
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Categoría"
boolean lefttext = true
end type

event clicked;cb_seleccionar.enabled = true
cb_seleccionar.visible = true

delete tt_alm_seleccion;
commit;

dw_1.Reset()

//parent.event ue_seleccionar( )
end event

type gb_1 from groupbox within w_al705_kardex
integer x = 731
integer y = 4
integer width = 1518
integer height = 288
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen:"
end type

type gb_2 from groupbox within w_al705_kardex
integer x = 2263
integer width = 704
integer height = 284
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Reporte"
end type

type gb_3 from groupbox within w_al705_kardex
integer x = 2299
integer width = 667
integer height = 224
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Reporte"
end type

