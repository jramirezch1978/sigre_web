$PBExportHeader$w_pr316_produccion_final.srw
forward
global type w_pr316_produccion_final from w_abc_master_smpl
end type
end forward

global type w_pr316_produccion_final from w_abc_master_smpl
integer width = 3086
integer height = 996
string title = "Produccion Final(PR316)"
string menuname = "m_mantto_smpl"
end type
global w_pr316_produccion_final w_pr316_produccion_final

on w_pr316_produccion_final.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr316_produccion_final.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_pr316_produccion_final
event ue_display ( string as_columna,  long al_row )
integer width = 3003
string dataobject = "d_pd_ot_produccion_final_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor, ls_und, ls_desc_unidad
			
Long		ll_row_find

str_parametros sl_param

choose case upper(as_columna)
		
		case "NRO_PARTE"

		ls_sql = "SELECT NRO_PARTE as NRO_PARTE, " &
				  + "to_char(NRO_ITEM) AS NRO_ITEM, " &
				  + "NRO_ORDEN, " &
				  + "CENCOS, " &
				  + "OBS, " &
				  + "COD_EJECUTOR " &
				  + "FROM PD_OT_DET " &
				  + "WHERE FLAG_REPLICACION = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.nro_parte			[al_row] = ls_codigo
			this.object.nro_item		      [al_row] = integer(ls_data)
			this.ii_update = 1
		end if
		
		case "COD_PRODUCTO"

		ls_sql = "SELECT COD_PROD as CODIGO, " &
				  + "DESC_PROD AS DESCRIPCION " &
				  + "FROM TIPO_PRODUCTO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_producto		[al_row] = ls_codigo
			this.object.desc_producto		[al_row] = ls_data
			this.ii_update = 1
		
			select und 
				into :ls_und
			from tipo_producto
			where cod_prod = :ls_codigo;
			
			select desc_unidad
				into :ls_desc_unidad
			from unidad
			where und = :ls_und;
			
			this.object.und			[al_row] = ls_und
			this.object.desc_unidad	[al_row] = ls_desc_unidad
			this.ii_update = 1
		end if
		
		case "COD_ESTADO"

		ls_sql = "SELECT COD_ESTADO as CODIGO, " &
				  + "DESC_ESTADO AS DESCRIPCION " &
				  + "FROM ESTADO_PRODUCTO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_estado		[al_row] = ls_codigo
			this.object.desc_estado		[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                        //'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[1] = 2			// columnas de lectrua de este dw

idw_mst  = 				dw_master

end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF

end event

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

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_proveedor, ls_desc, ls_null
Long		ll_count
integer	li_item

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
		
	case "nro_parte"
		
		ls_codigo = this.object.nro_orden[row]

		SetNull(ls_data)
		select nro_item
			into :ls_data
		from pd_ot_det
		where nro_parte = :ls_codigo
		  and flag_replicacion = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Nro. de Parte Diario no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.nro_orden		  	[row] = ls_codigo
			this.object.nro_item				[row] = ls_codigo
			return 1
		end if

		this.object.desc_servicio		[row] = ls_data
		
	case "cod_producto"
		
		ls_codigo = this.object.cod_producto[row]

		SetNull(ls_data)
		select desc_prod
			into :ls_data
		from tipo_producto
		where cod_prod = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Tipo de Producto no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_producto		  	[row] = ls_codigo
			this.object.desc_producto			[row] = ls_codigo
			return 1
		end if

		this.object.desc_producto		[row] = ls_data
		
		case "cod_estado"
		
		ls_codigo = this.object.cod_producto[row]

		SetNull(ls_data)
		select desc_estado
			into :ls_data
		from estado_producto
		where cod_estado = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Tipo de Producto no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_estado		  	[row] = ls_codigo
			this.object.desc_estado			[row] = ls_codigo
			return 1
		end if

		this.object.desc_estado		[row] = ls_data
		
end choose
		
end event

