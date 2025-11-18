$PBExportHeader$w_al334_saldo_posicion.srw
forward
global type w_al334_saldo_posicion from w_abc_master
end type
type uo_fecha from u_ingreso_fecha within w_al334_saldo_posicion
end type
type cbx_almacen from checkbox within w_al334_saldo_posicion
end type
type sle_almacen from singlelineedit within w_al334_saldo_posicion
end type
type sle_descrip from singlelineedit within w_al334_saldo_posicion
end type
type cb_1 from commandbutton within w_al334_saldo_posicion
end type
type gb_1 from groupbox within w_al334_saldo_posicion
end type
end forward

global type w_al334_saldo_posicion from w_abc_master
integer width = 3858
integer height = 2508
string title = "[AL334] Modificar Posiciones en saldos x Almacen"
string menuname = "m_only_grabar"
uo_fecha uo_fecha
cbx_almacen cbx_almacen
sle_almacen sle_almacen
sle_descrip sle_descrip
cb_1 cb_1
gb_1 gb_1
end type
global w_al334_saldo_posicion w_al334_saldo_posicion

on w_al334_saldo_posicion.create
int iCurrent
call super::create
if this.MenuName = "m_only_grabar" then this.MenuID = create m_only_grabar
this.uo_fecha=create uo_fecha
this.cbx_almacen=create cbx_almacen
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cbx_almacen
this.Control[iCurrent+3]=this.sle_almacen
this.Control[iCurrent+4]=this.sle_descrip
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.gb_1
end on

on w_al334_saldo_posicion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cbx_almacen)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Date 		ld_fecha
String 	ls_alm

ld_fecha = uo_fecha.of_get_fecha()

if cbx_almacen.checked then
	ls_alm = '%%'
else
	if trim(sle_almacen.text) = '' then
		MessageBox('Error', 'Debe especificar un almacen, por favor corrija', StopSign!)
		sle_almacen.setFocus()
		return
	end if
	
	ls_alm = trim(sle_almacen.text) + '%'
end if

dw_master.SetTransObject( sqlca)
dw_master.retrieve(ld_fecha, ls_alm)	




end event

event ue_update;//Override
Long 				ll_row, ll_rows_updated, ll_row_first
String			ls_anaquel, ls_columna, ls_fila, ls_almacen, ls_cod_art, ls_mensaje
dwItemStatus 	ldwi_status
date				ld_fecha
n_Cst_wait		lnvo_Wait

try 
	dw_master.AcceptText()
	
	ld_fecha = uo_fecha.of_get_fecha()
	lnvo_wait = create n_cst_Wait
	
	ll_rows_updated = 0
	ll_row_first = 0
	
	if dw_master.ii_update <> 1 then
		MessageBox('Aviso', 'No se ha realizado ningun cambio para grabar, por favor verifique!', StopSign!)
		return
	end if
	
	for ll_row = 1 to dw_master.Rowcount()
		lnvo_wait.of_mensaje("Procesando filas " + string(ll_row / dw_master.RowCount() * 100, "##0.00"))
		
		ldwi_status = dw_master.GetItemStatus(ll_row, 0, Primary!)
		
		if ldwi_status = DataModified! or ldwi_status = NewModified! then
			
			if ll_row_first = 0 then
				ll_row_first = ll_row
			end if
			
			ls_almacen 	= dw_master.object.almacen 	[ll_row]
			ls_cod_art	= dw_master.object.cod_art 	[ll_row]
			ls_anaquel	= dw_master.object.anaquel 	[ll_row]
			ls_fila		= dw_master.object.fila		 	[ll_row]
			ls_columna	= dw_master.object.columna 	[ll_row]
			
			if IsNull(ls_anaquel) or trim(ls_anaquel) = '' then
				MessageBox('Error', 'No se ha especificado anaquel en registro ' + String(ll_row) + ', por favor verifique!' &
										+ "~r~nCod Art: " + ls_cod_Art &
										+ "~r~nAlmacen: " + ls_almacen &
										+ "~r~nAnaquel: " + ls_anaquel &
										+ "~r~nFila: " + ls_fila &
										+ "~r~nColumna: " + ls_columna, StopSign!)
				
				return
			end if
			
			if IsNull(ls_fila) or trim(ls_fila) = '' then
				MessageBox('Error', 'No se ha especificado FILA en registro ' + String(ll_row) + ', por favor verifique!' &
										+ "~r~nCod Art: " + ls_cod_Art &
										+ "~r~nAlmacen: " + ls_almacen &
										+ "~r~nAnaquel: " + ls_anaquel &
										+ "~r~nFila: " + ls_fila &
										+ "~r~nColumna: " + ls_columna, StopSign!)
				
				return
			end if
			
			if IsNull(ls_columna) or trim(ls_columna) = '' then
				MessageBox('Error', 'No se ha especificado COLUMNA en registro ' + String(ll_row) + ', por favor verifique!' &
										+ "~r~nCod Art: " + ls_cod_Art &
										+ "~r~nAlmacen: " + ls_almacen &
										+ "~r~nAnaquel: " + ls_anaquel &
										+ "~r~nFila: " + ls_fila &
										+ "~r~nColumna: " + ls_columna, StopSign!)
				
				return
			end if
			
			if IsNull(ls_almacen) or trim(ls_almacen) = '' then
				MessageBox('Error', 'No se ha especificado ALMACEN en registro ' + String(ll_row) + ', por favor verifique!' &
										+ "~r~nCod Art: " + ls_cod_Art &
										+ "~r~nAlmacen: " + ls_almacen &
										+ "~r~nAnaquel: " + ls_anaquel &
										+ "~r~nFila: " + ls_fila &
										+ "~r~nColumna: " + ls_columna, StopSign!)
				
				return
			end if
			
			if IsNull(ls_cod_art) or trim(ls_cod_art) = '' then
				MessageBox('Error', 'No se ha especificado CODIGO ARTICULO en registro ' + String(ll_row) + ', por favor verifique!' &
										+ "~r~nCod Art: " + ls_cod_Art &
										+ "~r~nAlmacen: " + ls_almacen &
										+ "~r~nAnaquel: " + ls_anaquel &
										+ "~r~nFila: " + ls_fila &
										+ "~r~nColumna: " + ls_columna, StopSign!)
				
				return
			end if
			
			//Actualizo la posicion en todos los movimientos de almacen
			update articulo_mov am
				set am.anaquel = :ls_anaquel,
					 am.fila    = :ls_fila,
					 am.columna = :ls_columna
			 where am.cod_art = :ls_cod_art
				and am.flag_estado <> '0'
				and am.nro_vale in (select nro_vale
											 from vale_mov vm
											where vm.almacen = :ls_almacen
											  and vm.flag_estado <> '0'
											  and trunc(vm.fec_registro) <= trunc(:ld_fecha));
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				
				ROLLBACK;
				
				MessageBox('Error', 'Error al actualizar la posicion en los movimientos de almacen, por favor verifique!' &
										+ "~r~nCod Art: " + ls_cod_Art &
										+ "~r~nAlmacen: " + ls_almacen &
										+ "~r~nAnaquel: " + ls_anaquel &
										+ "~r~nFila: " + ls_fila &
										+ "~r~nColumna: " + ls_columna, StopSign!)
				
				return
				
			end if
			
			commit;
			
			ll_rows_updated ++
			
		end if
	next
	
	if ll_rows_updated > 0 then
		this.event ue_retrieve()
		
		if ll_row_first > 0 and ll_row_first <= dw_master.RowCount() then
			dw_master.ScrollToRow(ll_row_first)
			dw_master.setRow(ll_row_first)
			dw_master.SelectRow(0, false)
			dw_master.SelectRow(ll_row_first, true)
			
		end if	
		
		dw_master.ii_update = 0
		
		f_mensaje("Grabacion realizada satisfactoriamente, se han actualizado " + string(ll_rows_updated) + " registros", "")
	end if


catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, "Ha ocurrido una excepcion")
	
finally
	lnvo_wait.of_close()
	destroy lnvo_wait
end try


end event

type dw_master from w_abc_master`dw_master within w_al334_saldo_posicion
integer y = 220
integer width = 3781
integer height = 2084
string dataobject = "d_abc_saldo_posicion_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'
ii_ck[1] = 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.reckey[al_row] = '1'
end event

event dw_master::ue_display;call super::ue_display;// Abre ventana de ayuda 
String ls_almacen, ls_sql, ls_anaquel, ls_columna, ls_fila

choose case lower(as_columna)

	case 'anaquel'
		ls_almacen = dw_master.object.almacen [al_row]
		
		ls_sql = "select t.anaquel as anaquel, " &
				 + "t.fila as fila, " &
				 + "t.columna as columna " &
				 + "from tg_posiciones t " &
				 + "where t.almacen = '" + ls_almacen + "'"
					 
		if gnvo_app.of_lista(ls_sql, ls_anaquel, ls_fila, ls_columna, '2') then
			this.object.anaquel		[al_row] = ls_anaquel
			this.object.fila			[al_row] = ls_fila
			this.object.columna		[al_row] = ls_columna
			this.ii_update = 1
		end if	

	case 'fila'
		ls_almacen = dw_master.object.almacen [al_row]
		ls_anaquel = dw_master.object.anaquel [al_row]
		
		ls_sql = "select t.fila as fila, " &
				 + "t.columna as columna " &
				 + "from tg_posiciones t " &
				 + "where t.almacen = '" + ls_almacen + "'" &
				 + "  and t.anaquel = '" + ls_anaquel + "'"
					 
		if gnvo_app.of_lista(ls_sql, ls_fila, ls_columna, '2') then
			this.object.fila		[al_row] = ls_fila
			this.object.columna			[al_row] = ls_columna
			this.ii_update = 1
		end if		

	case 'columna'
		ls_almacen 	= dw_master.object.almacen [al_row]
		ls_anaquel 	= dw_master.object.anaquel [al_row]
		ls_fila		= dw_master.object.fila 	[al_row]
		
		ls_sql = "select t.columna as columna, " &
				 + "from tg_posiciones t " &
				 + "where t.almacen = '" + ls_almacen + "'" &
				 + "  and t.anaquel = '" + ls_anaquel + "'" &
				 + "  and t.fila 	  = '" + ls_fila + "'"
					 
		if gnvo_app.of_lista(ls_sql, ls_fila, ls_columna, '2') then
			this.object.columna			[al_row] = ls_columna
			this.ii_update = 1
		end if			
end choose



end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

type uo_fecha from u_ingreso_fecha within w_al334_saldo_posicion
event destroy ( )
integer x = 23
integer y = 60
integer taborder = 90
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))		
end event

type cbx_almacen from checkbox within w_al334_saldo_posicion
integer x = 727
integer y = 60
integer width = 608
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los almacenes"
boolean checked = true
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type sle_almacen from singlelineedit within w_al334_saldo_posicion
event dobleclick pbm_lbuttondblclk
integer x = 1344
integer y = 56
integer width = 270
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "c:\sigre\resources\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
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
  and FLAG_TIPO_ALMACEN <> 'T';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_descrip.text = ls_desc

end event

type sle_descrip from singlelineedit within w_al334_saldo_posicion
integer x = 1623
integer y = 56
integer width = 1157
integer height = 88
integer taborder = 70
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

type cb_1 from commandbutton within w_al334_saldo_posicion
integer x = 2825
integer y = 48
integer width = 526
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Generar Reporte"
end type

event clicked;SetPointer( Hourglass!)
Parent.Event ue_retrieve()
SetPointer( Arrow!)
end event

type gb_1 from groupbox within w_al334_saldo_posicion
integer width = 3378
integer height = 208
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Filtros para el reporte"
end type

