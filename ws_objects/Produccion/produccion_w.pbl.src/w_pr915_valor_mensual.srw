$PBExportHeader$w_pr915_valor_mensual.srw
forward
global type w_pr915_valor_mensual from w_abc_master_smpl
end type
type cb_1 from commandbutton within w_pr915_valor_mensual
end type
type cb_2 from commandbutton within w_pr915_valor_mensual
end type
end forward

global type w_pr915_valor_mensual from w_abc_master_smpl
integer width = 3054
integer height = 1880
string title = "Valorizion PPTT Mensual (PR915)"
string menuname = "m_smpl"
event type integer ue_listar_data ( )
cb_1 cb_1
cb_2 cb_2
end type
global w_pr915_valor_mensual w_pr915_valor_mensual

type variables
string is_ruta
integer ii_year
end variables

event type integer ue_listar_data();oleobject 	excel
integer		li_i
long 			ll_hasil, ll_return, ll_count, ll_max_rows, ll_max_columns, ll_fila1,ll_fila2 , ll_fila, ll_year, ll_mes
decimal 		ldc_precio
boolean 		lb_cek
String 		ls_cellValue , ls_nomcol, ls_codigo, ls_tipo_mov
oleobject  	lole_workbook, lole_worksheet


try 
	excel = create oleobject
	
	dw_master.reset()
	 
	if not(FileExists( is_ruta )) then
		gnvo_app.of_mensaje_error('Ruta del archivo ' + is_ruta + ' no existe, por favor verifique!', '') 
		return -1
	end if 
	
	//connect to office application
	ll_return = excel.connecttonewobject("excel.application")
	if ll_return <> 0 then
		gnvo_app.of_mensaje_error('No se puede crear objeto de excel MS.Excel!', '')
		dw_master.ii_update = 0
		return -1
	end if
	
	//open file excel (you can make this string as variable)
	excel.workbooks.open( is_ruta )
	excel.application.visible = false
	excel.windowstate = 2
	
	//cek rows in excel sheet with return value copy
	lole_workbook 	= excel.workbooks(1)
	lb_cek 			= lole_workbook.activate
	lole_worksheet = lole_workbook.worksheets(1)
	ll_max_rows   	= lole_worksheet.UsedRange.Rows.Count
	
	if ll_max_rows <= 1 then
		gnvo_app.of_mensaje_error('La hoja de excel debe tener al menos un registro, aparte de la cabera del mismo', '')
		dw_master.ii_update = 0
		return -1
	end if
	 
	dw_master.reset( )
	dw_master.ii_update = 0
	dw_master.setredraw(false)
	
	FOR ll_fila1 = 2 TO ll_max_rows
		ll_year 		= long(lole_worksheet.cells(ll_fila1,1).value) 
		ll_mes		= long(lole_worksheet.cells(ll_fila1,2).value)
		ls_tipo_mov	= String(lole_worksheet.cells(ll_fila1,3).value)
		ls_codigo	= String(lole_worksheet.cells(ll_fila1,4).value)  
		ldc_precio	= Dec(lole_worksheet.cells(ll_fila1,5).value)
		
		IF ll_mes <= 0  THEN
			gnvo_app.of_mensaje_error('El Mes ingresado no es correcto, por favor corrijalo para continuar!. Nro de fila ' + string(ll_fila1))
			dw_master.Reset()
			dw_master.ii_update = 0
			return -1
		end if
		
		if isnull(ll_year) or ll_year <= 0 then
			gnvo_app.of_mensaje_error('El Año ingresado no es correcto, por favor corrijalo para continuar!. Nro de fila ' + string(ll_fila1))
			dw_master.Reset()
			dw_master.ii_update = 0
			return -1
		end if
			
		ll_fila = dw_master.event ue_insert() 
		dw_master.object.año					[ll_fila] = ll_year
		dw_master.object.mes					[ll_fila] = ll_mes
		dw_master.object.tipo_mov			[ll_fila] = ls_tipo_mov
		dw_master.object.codigo				[ll_fila] = ls_codigo
		dw_master.object.costo_unitario	[ll_fila] = ldc_precio
			
	next
	
	IF dw_master.rowcount() > 0 THEN
		ii_year = dw_master.object.año[1]
		
		FOR li_i = 2 TO dw_master.rowcount()
			IF dw_master.object.año[li_i] <> ii_year THEN
				gnvo_app.of_mensaje_Error ('El Archivo Debe de Tener el Mismo Año, ' + string(ii_year))
				dw_master.ii_update = 0
				dw_master.reset()
				RETURN -1
			END IF
		NEXT
	ELSE
		gnvo_app.of_mensaje_error('No existen registros importados, verifique')
		dw_master.Reset()
		dw_master.ii_update = 0
		RETURN -1
	END IF	
	
	dw_master.setredraw( true)
	RETURN 1
	
catch ( Exception ex )
	
	gnvo_app.of_mensaje_error("Ha ocurrido una exception: " + ex.getMessage())
	dw_master.ii_update = 0
	return -1

finally
	if not IsNull(excel) and IsValid(excel) then
		excel.application.quit
		excel.disconnectobject()
	end if
	destroy excel

end try


end event

on w_pr915_valor_mensual.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
end on

on w_pr915_valor_mensual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_2)
end on

event ue_update;call super::ue_update;dw_master.of_set_flag_replicacion( )
this.event ue_dw_share()
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;

ii_lec_mst = 0
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr915_valor_mensual
event ue_display ( string as_columna,  long al_row )
integer y = 152
integer width = 2958
integer height = 1448
string dataobject = "d_abc_valor_mensual_pptt_tbl"
end type

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2

If this.ii_protect = 1 or row <= 0 then return

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'und'
		ls_sql = "select und as codigo, desc_unidad as descripcion from unidad"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim (ls_return1) = '' then return
		this.object.und[row] = ls_return1
		this.object.desc_unidad[row] = ls_return2
		this.ii_update = 1
		
	case 'grp_medicion'
		ls_sql = "select grp_medicion as codigo, descripcion as nombre from tg_med_act_atributo_grp"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim (ls_return1) = '' then return
		this.object.grp_medicion[row] = ls_return1
		this.object.grp_descripcion[row] = ls_return2
		this.ii_update = 1
end choose
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;string ls_col, ls_sql, ls_return1, ls_return2

If this.ii_protect = 1 or row <= 0 then return

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'und'
		select und, desc_unidad
			into :ls_return1, :ls_return2
			from unidad
			where und = :data;
			
		if sqlca.sqlcode = 100 then
			messagebox(parent.title, "No se encuentra la unidad")
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.und[row] = ls_return1
		this.object.desc_unidad[row] = ls_return2
		
		return 2
		
	case 'grp_medicion'
		select grp_medicion, descripcion 
			into :ls_return1, :ls_return2
			from tg_med_act_atributo_grp
			where grp_medicion = :data;
		
		if sqlca.sqlcode = 100 then
			messagebox(parent.title, "No se encuentra la unidad")
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.grp_medicion[row] = ls_return1
		this.object.grp_descripcion[row] = ls_return2
		
		return 2
		
end choose
end event

type cb_1 from commandbutton within w_pr915_valor_mensual
integer x = 37
integer y = 20
integer width = 475
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Importar de XLS"
end type

event clicked;int 		li_value, li_res, li_i, li_j, li_count
long 		ll_year, ll_mes, ll_find, ll_row, ll_year_old, ll_mes_old
decimal 	ldc_costo
string 	ls_docname, ls_named, ls_codigo, ls_filtro, ls_mensaje, ls_tipo_mov, &
			ls_tipo_mov_old, ls_codigo_old

cb_2.enabled = false

li_value =  GetFileOpenName("Abrir ..",  ls_docname, ls_named, "XLS",  &
   				"Archivos Excel (*.XLS),*.XLS" )

IF li_value = 1 THEN  
   is_ruta = ls_docname
END IF

IF parent.event ue_listar_data() = -1 THEN 
	ii_year = 0
	RETURN 
END IF

if dw_master.RowCount() = 0 then return

ll_year_old = 0
ll_mes_old = 0
ls_tipo_mov_old = ''
ls_codigo_old = ''



FOR li_i = 1 to dw_master.rowcount()
	ll_year 		= dw_master.object.año					[li_i]
	ll_mes 		= dw_master.object.mes					[li_i]
	ls_codigo 	= dw_master.object.codigo				[li_i]
	ls_tipo_mov	= dw_master.object.tipo_mov			[li_i]
	
	if ll_year <> ll_year_old or ll_mes <> ll_mes_old or ls_codigo_old <> ls_codigo or ls_tipo_mov_old <> ls_tipo_mov then
		ll_year_old 		= ll_year
		ll_mes_old 			= ll_mes
		ls_tipo_mov_old 	= ls_tipo_mov
		ls_codigo_old		= ls_codigo
		
		select count(*)
			into :li_count
		from VALORIZACION_PPTT
		where anio 		= :ll_year
		  and mes  		= :ll_mes
		  and tipo_mov = :ls_tipo_mov
		  and codigo	= :ls_codigo;
		
		if li_count > 0 then
			if MessageBox('Aviso', 'Existen ' + string(li_count) + ' registros para el periodo ' &
						+ string(ll_year) + '/' + string(ll_mes) &
						+ "~r~nTipo Mov: " + ls_tipo_mov &
						+ "~r~nCodigo Articulo: " + ls_codigo &
						+ '. Desea eliminarlos?', Information!, &
						Yesno!, 2) = 1 then
				
				delete VALORIZACION_PPTT
				where anio 		= :ll_year
				  and mes  		= :ll_mes
				  and tipo_mov = :ls_tipo_mov
				  and codigo	= :ls_codigo;
				
				if gnvo_app.of_ExistsError(SQLCA, 'Delete Tabla VALORIZACION_PPTT') then
					ROLLBACK;
					return
				end if
				
				//Confirmo los cambios
				COMMIT;

			end if
		end if

	end if
	
next

FOR li_i = 1 to dw_master.rowcount()
	ll_year 		= dw_master.object.año					[li_i]
	ll_mes 		= dw_master.object.mes					[li_i]
	ls_codigo 	= dw_master.object.codigo				[li_i]
	ls_tipo_mov	= dw_master.object.tipo_mov			[li_i]
	ldc_costo 	= Dec(dw_master.object.costo_unitario	[li_i])
	
	select count(*)
		into :li_count
	from VALORIZACION_PPTT
	where anio 		= :ll_year
	  and mes  		= :ll_mes
	  and tipo_mov = :ls_tipo_mov
	  and codigo	= :ls_codigo;
	
	if li_count > 0 then
		
		update VALORIZACION_PPTT
		   set costo_unitario = :ldc_costo
		where anio 		= :ll_year
		  and mes  		= :ll_mes
		  and tipo_mov = :ls_tipo_mov
		  and codigo	= :ls_codigo;

		if gnvo_app.of_ExistsError(SQLCA, 'UPDATE Tabla VALORIZACION_PPTT') then
			ROLLBACK;
			return
		end if
		  
	else
		insert into VALORIZACION_PPTT(anio, mes, tipo_mov, codigo, costo_unitario)
		values(:ll_year, :ll_mes, :ls_tipo_mov, :ls_codigo, :ldc_costo);
		
		if gnvo_app.of_ExistsError(SQLCA, 'INSERT Tabla VALORIZACION_PPTT') then
			ROLLBACK;
			return
		end if

	end if
	
NEXT

COMMIT;

dw_master.retrieve(ii_year)
cb_2.enabled = true
messagebox ('Atención', 'La Información se Levanto Correctamente')

end event

type cb_2 from commandbutton within w_pr915_valor_mensual
integer x = 530
integer y = 20
integer width = 475
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Procesar"
end type

event clicked;IF ii_year< 2000 THEN RETURN



update articulo_mov am 
  set am.precio_unit = round((Select NVL(vp.costo_unitario, 0)  
                      from valorizacion_pptt   vp, 
                          vale_mov         vm  
                       where vm.nro_vale = am.nro_vale 
                        and vm.tipo_mov = vp.tipo_mov
                         and trim(vp.codigo) = trim(am.cod_art) 
                         and to_number(to_char(vm.fec_registro, 'yyyy')) = vp.anio  
                         and to_number(to_char(vm.fec_registro, 'mm')) = vp.mes),8)  
where trim(am.cod_Art) in (select trim(codigo) from valorizacion_pptt)  
  and am.nro_vale in (select distinct vm.nro_vale 
                 from vale_mov vm,
                     valorizacion_pptt vp,
                    articulo_mov    am
                where vm.tipo_mov   = vp.tipo_mov 
                  and vm.nro_Vale   = am.nro_Vale
                  and vm.flag_estado <> '0'
                  and vp.codigo    = am.cod_art
                  and to_number(to_char(vm.fec_registro, 'yyyy')) = vp.anio
                  and to_number(to_char(vm.fec_registro, 'mm')) = vp.mes
                  and vp.anio      = :ii_year)  
  and am.precio_unit <> round((Select NVL(vp.costo_unitario, 0)  
                       from valorizacion_pptt vp, 
                           vale_mov       vm  
                      where vm.nro_vale = am.nro_vale 
                        and vm.tipo_mov = vp.tipo_mov
                        and vp.codigo   = am.cod_art
                        and to_number(to_char(vm.fec_registro, 'yyyy')) = vp.anio  
                        and to_number(to_char(vm.fec_registro, 'mm')) = vp.mes),8);
  

	
if not gnvo_app.of_existsError(SQLCA, 'Actualizacion Precio en ARTICULO_MOV') then 
	commit;
	f_mensaje("Proceso concluido satisfactoriamente", "")
end if
end event

