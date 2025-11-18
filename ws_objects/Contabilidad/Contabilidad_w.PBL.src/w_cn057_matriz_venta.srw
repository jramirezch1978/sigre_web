$PBExportHeader$w_cn057_matriz_venta.srw
forward
global type w_cn057_matriz_venta from w_abc_master_smpl
end type
end forward

global type w_cn057_matriz_venta from w_abc_master_smpl
integer width = 3337
integer height = 2028
string title = "[CN057] Configuración Matrices de Venta "
string menuname = "m_abc_master_smpl"
end type
global w_cn057_matriz_venta w_cn057_matriz_venta

on w_cn057_matriz_venta.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn057_matriz_venta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_cn057_matriz_venta
integer width = 3227
integer height = 1728
string dataobject = "d_abc_matriz_venta_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_ck[4] = 4				// columnas de lectrua de este dw

//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
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

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_cat_art, ls_concepto
choose case lower(as_columna)
		
	case "cat_art"

		ls_sql = "select a.cat_art as codigo_categoria, " &
				 + "a.desc_categoria as descripcion_categoria " &
				 + "from articulo_categ a " &
				 + "where a.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cat_Art			[al_row] = ls_codigo
			this.object.desc_categoria	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_sub_cat"
		ls_cat_art = this.object.cat_art [al_row]
		
		if IsNull(ls_cat_art) or trim(ls_cat_art) = '' then
			MessageBox('Error', 'Debe Indicar primero la categoría. Por favor verifique!', StopSign!)
			setColumn("cod_sub_cat")
			return 
		end if

		ls_sql = "select a.cod_sub_cat as codido_sub_categ, " &
				 + "a.desc_sub_cat as descripcion_sub_categ " & 
				 + "from articulo_sub_categ a " &
				 + "where a.cat_art = '" + ls_cat_art + "'" &
				 + "  and a.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_sub_cat		[al_row] = ls_codigo
			this.object.desc_sub_cat	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "tipo_doc"
		
		ls_sql = "select dt.tipo_doc as tipo_doc, " &
				 + "dt.desc_tipo_doc as descripcion_tipo_doc " &
				 + "from doc_tipo dt, " &
				 + "     doc_grupo_relacion dg " &
				 + "where dt.tipo_doc = dg.tipo_doc " &
				 + "  and dg.grupo = '01'" &
				 + "  and dt.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_doc		[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "cod_moneda"
		
		ls_sql = "select cod_moneda as codigo_moneda, " &
				 + "descripcion as descripcion_moneda " &
				 + "from moneda " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_moneda		[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "valor"
		
		ls_concepto = this.object.concepto [al_row]
		
		if IsNull(ls_concepto) or trim(ls_concepto) = '' then
			MessageBox('Error', 'Debe Indicar primero el concepto. Por favor verifique!', StopSign!)
			setColumn("concepto")
			return 
		end if

		if upper(trim(ls_concepto)) = 'MATRIZ_VTA' then
		
			ls_sql = "select confin as concepto_financiero, " &
					 + "cf.descripcion as descripcion_confin " &
					 + "from concepto_financiero cf " &
					 + "where cf.flag_estado = '1' " &
					 + "  and length(trim(cf.descripcion)) > 1"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			if ls_codigo <> '' then
				this.object.valor		[al_row] = ls_codigo
				this.ii_update = 1
			end if
		end if
		
end choose



end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro [al_row] = gnvo_app.of_fecha_actual()
end event

