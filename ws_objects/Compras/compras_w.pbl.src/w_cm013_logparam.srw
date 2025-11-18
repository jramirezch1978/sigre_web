$PBExportHeader$w_cm013_logparam.srw
forward
global type w_cm013_logparam from w_abc_master
end type
end forward

global type w_cm013_logparam from w_abc_master
integer width = 1925
integer height = 1860
string title = "Parametros (CM013)"
string menuname = "m_logparam"
boolean maxbox = false
boolean resizable = false
boolean center = true
end type
global w_cm013_logparam w_cm013_logparam

on w_cm013_logparam.create
call super::create
if this.MenuName = "m_logparam" then this.MenuID = create m_logparam
end on

on w_cm013_logparam.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_row

f_centrar(this)

dw_master.retrieve()

ll_row = dw_master.RowCount()

if ll_row = 0 then
	dw_master.event ue_insert()
end if
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'form') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master`dw_master within w_cm013_logparam
event ue_display ( string as_columna,  long al_row )
integer width = 1851
integer height = 1648
string dataobject = "d_abc_logparam"
integer ii_sort = 1
end type

event dw_master::ue_display(string as_columna, long al_row);string			ls_sql, ls_codigo, ls_data, ls_cencos, ls_grupo, ls_cnta_prsp
Long				ll_ano
boolean			lb_ret


str_parametros 	sl_param

ll_ano = Year( Today() )

choose case lower(as_columna)
	
	case 'doc_oc'
		
		ls_sql = "SELECT TIPO_DOC AS CODIGO_DOC, " &
				 + "DESC_TIPO_DOC AS DESCRIPCION_DOCUMENTO " &
             + "FROM DOC_TIPO "
		
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.doc_oc	[al_row] = ls_codigo
			this.object.desc_oc	[al_row] = ls_data
			this.ii_update = 1
		end if

	case 'doc_os'
		
		ls_sql = "SELECT TIPO_DOC AS CODIGO_DOC, " &
				 + "DESC_TIPO_DOC AS DESCRIPCION_DOCUMENTO " &
             + "FROM DOC_TIPO "
		
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.doc_os	[al_row] = ls_codigo
			this.object.desc_os	[al_row] = ls_data
			this.ii_update = 1
		end if

	case 'doc_ss'
		
		ls_sql = "SELECT TIPO_DOC AS CODIGO_DOC, " &
				 + "DESC_TIPO_DOC AS DESCRIPCION_DOCUMENTO " &
             + "FROM DOC_TIPO "
		
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.doc_ss	[al_row] = ls_codigo
			this.object.desc_ss	[al_row] = ls_data
			this.ii_update = 1
		end if

	case 'doc_sc'
		
		ls_sql = "SELECT TIPO_DOC AS CODIGO_DOC, " &
				 + "DESC_TIPO_DOC AS DESCRIPCION_DOCUMENTO " &
             + "FROM DOC_TIPO "
		
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.doc_sc	[al_row] = ls_codigo
			this.object.desc_sc	[al_row] = ls_data
			this.ii_update = 1
		end if

	case 'doc_prog_cmp'
		
		ls_sql = "SELECT TIPO_DOC AS CODIGO_DOC, " &
				 + "DESC_TIPO_DOC AS DESCRIPCION_DOCUMENTO " &
             + "FROM DOC_TIPO "
		
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.doc_prog_cmp	[al_row] = ls_codigo
			this.object.desc_prog_cmp	[al_row] = ls_data
			this.ii_update = 1
		end if

	case 'cod_soles'
		
		ls_sql = "SELECT COD_MONEDA AS CODIGO_MONEDA, " &
				 + "DESCRIPCION AS DESCR_MONEDA " &
             + "FROM MONEDA "
		
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_soles	[al_row] = ls_codigo
			this.object.desc_soles	[al_row] = ls_data
			this.ii_update = 1
		end if

	case 'cod_dolares'
		
		ls_sql = "SELECT COD_MONEDA AS CODIGO_MONEDA, " &
				 + "DESCRIPCION AS DESCR_MONEDA " &
             + "FROM MONEDA "
		
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_dolares	[al_row] = ls_codigo
			this.object.desc_dolares	[al_row] = ls_data
			this.ii_update = 1
		end if

	case 'cod_igv'
		
		ls_sql = "SELECT TIPO_IMPUESTO AS CODIGO_IMPUESTO, " &
				 + "DESC_IMPUESTO AS DESCRIPCION_IMPUESTO " &
             + "FROM IMPUESTOS_TIPO "
		
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_igv			[al_row] = ls_codigo
			this.object.desc_impuesto	[al_row] = ls_data
			this.ii_update = 1
		end if

	case 'tipo_prov_serv'
		
		ls_sql = "SELECT TIPO_PROVEEDOR AS CODIGO_PROVEEDOR, " &
				 + "DESCRIPCION AS DESCRIPCION_TIPO_PROVEEDOR " &
             + "FROM PROVEEDOR_TIPO "
		
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_prov_serv	[al_row] = ls_codigo
			this.object.desc_prov_serv	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cencos"
		
		sl_param.dw1 = "d_sel_presup_partida_cencos_ano_all"  //d_dddw_cencos"
		sl_param.titulo = "Centros de costo"
		sl_param.field_ret_i[1] = 1
		sl_param.field_ret_i[2] = 2
		sl_param.tipo = '1N'
		sl_param.Long1 = ll_ano

		OpenWithParm( w_search, sl_param)
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then	
			ls_cencos = sl_param.field_ret[1]
			this.object.cencos[al_row] = ls_cencos
			return
		END IF		

	case "cnta_prsp"
		
		ls_cencos = this.object.cencos[al_row]
		
		if ls_cencos = '' or IsNull(ls_cencos) then
			Messagebox( "Aviso", "Ingrese Centro de costo", StopSign!)
			this.SetColumn("cencos")
			return
		end if	

		sl_param.dw1 = "d_sel_presup_partida_cnta_cc"
		sl_param.titulo = "Cuentas Presupuestales"
		sl_param.field_ret_i[1] = 1
		sl_param.field_ret_i[2] = 2
		sl_param.tipo 		= '1N1S'
		sl_param.long1 	= ll_ano
		sl_param.string1 	= ls_cencos

		OpenWithParm( w_search, sl_param)
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then			
			ls_cnta_prsp = sl_param.field_ret[1]
			this.object.cnta_prsp[al_row] = ls_cnta_prsp
			return
		END IF
	
	case "grp_azucar"

		ls_grupo = this.object.grp_azucar[al_row]
		
		sl_param.dw1 = "ds_articulo_grupo_grid"
		sl_param.titulo = "Grupos de Artículos"
		sl_param.field_ret_i[1] = 1
		sl_param.field_ret_i[2] = 2
		sl_param.tipo = ''

		OpenWithParm( w_search, sl_param )
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then			
			ls_grupo = sl_param.field_ret[1]
			this.object.grp_azucar[al_row] = ls_grupo
			return
		END IF
		
	case "cnta_prsp_transp_cana"
		
		ls_cnta_prsp = this.object.cnta_prsp_transp_cana[al_row]
		
		sl_param.dw1 = "d_dddw_cntas_presupuestal"
		sl_param.titulo = "Cuentas Presupuestales"
		sl_param.field_ret_i[1] = 1
		sl_param.field_ret_i[2] = 2
		sl_param.tipo 		= ''

		OpenWithParm( w_search, sl_param)
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then			
			ls_cnta_prsp = sl_param.field_ret[1]
			this.object.cnta_prsp_transp_cana[al_row] = ls_cnta_prsp
			return
		END IF

	case "cnta_prsp_corte_cana"
		
		ls_cnta_prsp = this.object.cnta_prsp_corte_cana[al_row]
		
		sl_param.dw1 = "d_dddw_cntas_presupuestal"
		sl_param.titulo = "Cuentas Presupuestales"
		sl_param.field_ret_i[1] = 1
		sl_param.field_ret_i[2] = 2
		sl_param.tipo 		= ''

		OpenWithParm( w_search, sl_param)
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then			
			ls_cnta_prsp = sl_param.field_ret[1]
			this.object.cnta_prsp_corte_cana[al_row] = ls_cnta_prsp
			return
		END IF

	case "cnta_prsp_alce_cana"
		
		ls_cnta_prsp = this.object.cnta_prsp_alce_cana[al_row]
		
		sl_param.dw1 = "d_dddw_cntas_presupuestal"
		sl_param.titulo = "Cuentas Presupuestales"
		sl_param.field_ret_i[1] = 1
		sl_param.field_ret_i[2] = 2
		sl_param.tipo 		= ''

		OpenWithParm( w_search, sl_param)
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then			
			ls_cnta_prsp = sl_param.field_ret[1]
			this.object.cnta_prsp_alce_cana[al_row] = ls_cnta_prsp
			return
		END IF

end choose

end event

event dw_master::constructor;call super::constructor;is_dwform = 'form'
ii_ck[1] = 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;Integer li_count
this.object.reckey[al_row] = '1'

end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event dw_master::keydwn;call super::keydwn;string 	ls_columna, ls_cadena
integer 	li_column
long 		ll_row

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

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_cencos, ls_cnta_prsp, ls_codigo, &
			ls_data, ls_null
Long		ll_ano, ll_count

this.AcceptText()

if row <= 0 then
	return
end if

ll_ano = Year( Today() )
SetNull(ls_null)

choose case lower(dwo.name)
		
	case 'doc_oc'
		
		ls_codigo = this.object.doc_oc[row]
		
		select desc_tipo_doc
			into :ls_data
		from doc_tipo
		where tipo_doc = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = '' then
			this.object.doc_oc	[row] = ls_null
			this.object.desc_oc	[row] = ls_null
			MessageBox('Aviso', 'Tipo de Documento no Existe', StopSign!)
			return 1
		end if
		
		this.object.desc_oc[row] = ls_data

	case 'doc_os'
		
		ls_codigo = this.object.doc_os[row]
		
		select desc_tipo_doc
			into :ls_data
		from doc_tipo
		where tipo_doc = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = '' then
			this.object.doc_os	[row] = ls_null
			this.object.desc_os	[row] = ls_null
			MessageBox('Aviso', 'Tipo de Documento no Existe', StopSign!)
			return 1
		end if
		
		this.object.desc_os[row] = ls_data

	case 'doc_ss'
		
		ls_codigo = this.object.doc_ss[row]
		
		select desc_tipo_doc
			into :ls_data
		from doc_tipo
		where tipo_doc = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = '' then
			this.object.doc_ss	[row] = ls_null
			this.object.desc_ss	[row] = ls_null
			MessageBox('Aviso', 'Tipo de Documento no Existe', StopSign!)
			return 1
		end if
		
		this.object.desc_ss[row] = ls_data

	case 'doc_sc'
		
		ls_codigo = this.object.doc_sc[row]
		
		select desc_tipo_doc
			into :ls_data
		from doc_tipo
		where tipo_doc = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = '' then
			this.object.doc_sc	[row] = ls_null
			this.object.desc_sc	[row] = ls_null
			MessageBox('Aviso', 'Tipo de Documento no Existe', StopSign!)
			return 1
		end if
		
		this.object.desc_sc[row] = ls_data

	case 'doc_prog_cmp'
		
		ls_codigo = this.object.doc_prog_cmp[row]
		
		select desc_tipo_doc
			into :ls_data
		from doc_tipo
		where tipo_doc = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = '' then
			this.object.doc_prog_cmp	[row] = ls_null
			this.object.desc_prog_cmp	[row] = ls_null
			MessageBox('Aviso', 'Tipo de Documento no Existe', StopSign!)
			return 1
		end if
		
		this.object.desc_prog_cmp[row] = ls_data

	case 'cod_soles'
		
		ls_codigo = this.object.cod_soles[row]
		
		select descripcion
			into :ls_data
		from moneda
		where cod_moneda = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = '' then
			this.object.cod_soles	[row] = ls_null
			this.object.desc_soles	[row] = ls_null
			MessageBox('Aviso', 'Tipo de Documento no Existe', StopSign!)
			return 1
		end if
		
		this.object.desc_soles[row] = ls_data

	case 'cod_dolares'
		
		ls_codigo = this.object.cod_dolares[row]
		
		select descripcion
			into :ls_data
		from moneda
		where cod_moneda = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = '' then
			this.object.cod_dolares	[row] = ls_null
			this.object.desc_dolares	[row] = ls_null
			MessageBox('Aviso', 'Tipo de Documento no Existe', StopSign!)
			return 1
		end if
		
		this.object.desc_dolares[row] = ls_data

	case 'cod_igv'
		
		ls_codigo = this.object.cod_igv[row]
		
		select desc_impuesto
			into :ls_data
		from impuestos_tipo
		where tipo_impuesto = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = '' then
			this.object.cod_igv			[row] = ls_null
			this.object.desc_impuesto	[row] = ls_null
			MessageBox('Aviso', 'Tipo de Impuesto no Existe', StopSign!)
			return 1
		end if
		
		this.object.desc_impuesto[row] = ls_data

	case 'tipo_prov_serv'
		
		ls_codigo = this.object.tipo_prov_serv[row]
		
		select descripcion
			into :ls_data
		from proveedor_tipo
		where tipo_proveedor = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = '' then
			this.object.tipo_prov_serv	[row] = ls_null
			this.object.desc_prov_serv	[row] = ls_null
			MessageBox('Aviso', 'Tipo de Impuesto no Existe', StopSign!)
			return 1
		end if
		
		this.object.desc_tipo_prov_serv[row] = ls_data

	case "cencos"
		
		ls_cencos = this.object.cencos[row]
		if ls_cencos = '' or IsNull(ls_cencos) then
			Messagebox('Aviso', "EL CENTRO DE COSTOS NO PUEDE ESTAR EN BLANCO", StopSign!)
			SetNull(ls_cencos)
			this.object.cencos	[row] = ls_cencos
			return 1
		end if
		
		select count(*)
			into :ll_count
		from presupuesto_partida
		where ano = :ll_ano
		  and cencos = :ls_cencos;
		  
		if ll_count = 0 then
			Messagebox('Aviso', "CENTRO DE COSTOS NO TIENE PARTIDA PRESUPUESTAL", StopSign!)
			SetNull(ls_cencos)
			this.object.cencos	[row] = ls_cencos
			return 1
		end if

	case "cnta_prsp"

		ls_cencos = this.object.cencos[row]
		if ls_cencos = '' or IsNull(ls_cencos) then
			Messagebox('Aviso', "EL CENTRO DE COSTOS NO PUEDE ESTAR EN BLANCO", StopSign!)
			SetNull(ls_cencos)
			this.object.cencos	[row] = ls_cencos
			return 1
		end if
		
		ls_cnta_prsp = this.object.cnta_prsp[row]
		if ls_cnta_prsp = '' or IsNull(ls_cnta_prsp) then
			Messagebox('Aviso', "LA CUENTA PRESUPUESTAL NO PUEDE ESTAR EN BLANCO", StopSign!)
			SetNull(ls_cnta_prsp)
			this.object.cnta_prsp	[row] = ls_cencos
			return 1
		end if

		select count(*)
			into :ll_count
		from presupuesto_partida
		where ano 			= :ll_ano
		  and cencos 		= :ls_cencos
		  and cnta_prsp 	= :ls_cnta_prsp;
		  
		if ll_count = 0 then
			Messagebox('Aviso', "CUENTA PRESUPUESTAL NO TIENE PARTIDA PRESUPUESTAL", StopSign!)
			SetNull(ls_cencos)
			this.object.cnta_prsp	[row] = ls_cnta_prsp
			return 1
		end if
		
end choose
end event

