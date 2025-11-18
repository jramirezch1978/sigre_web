$PBExportHeader$w_fl303_captura_empresas.srw
forward
global type w_fl303_captura_empresas from w_abc_master_smpl
end type
end forward

global type w_fl303_captura_empresas from w_abc_master_smpl
integer width = 3739
integer height = 1216
string title = "Registro de captura realizada por otras emrpesas (FL303)"
string menuname = "m_mto_smpl"
long backcolor = 67108864
end type
global w_fl303_captura_empresas w_fl303_captura_empresas

on w_fl303_captura_empresas.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl303_captura_empresas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event closequery;// Ancestor Script has been Override
THIS.Event ue_close_pre()
THIS.EVENT ue_update_request()

Destroy	im_1

of_close_sheet()
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_fl303_captura_empresas
event ue_display ( string as_columna,  long al_row )
integer width = 2587
integer height = 936
string dataobject = "d_captua_empresas"
end type

event dw_master::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_nave

choose case lower(as_columna)
	CASE 'empresa'
		ls_nave = this.object.nave [al_row]
		
		if not IsNull(ls_nave) and trim(ls_nave) <> '' then
			ls_sql = "select p.proveedor as codigo, " &
					 + "p.nomb_proveedor as razon_social, " &
					 + "decode(p.nro_doc_ident, null, p.ruc, p.nro_doc_ident) as ruc_dni " &
					 + "from proveedor p," &
					 + "     tg_naves  tn " &
					 + "where p.proveedor = tn.proveedor " &
					 + "  and tn.nave 	 = '" + ls_nave + "'" &
					 + "  and p.flag_Estado ='1'"
		else
			ls_sql = "select proveedor as codigo, " &
					 + "nomb_proveedor as razon_social, " &
					 + "decode(nro_doc_ident, null, ruc, nro_doc_ident) as ruc_dni " &
					 + "from proveedor " &
					 + "where flag_Estado ='1'"		
		end if
		
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.empresa			[al_row] = ls_codigo
			This.object.nombre_empresa	[al_row] = ls_data
			This.ii_update = 1
		END IF
	
	CASE 'especie'
		ls_sql = "select especie as codigo, " &
				 + "descr_especie as descripcion " &
				 + "from tg_especies " &
				 + "where flag_estado = '1'"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.especie			[al_row] = ls_codigo
			This.object.descr_especie	[al_row] = ls_data
			This.ii_update = 1
		END IF

	CASE 'nave'
		ls_sql = "select nave as codigo, " &
				 + "nomb_nave as descripcion_nave " &
				 + "from tg_naves " &
				 + "where flag_estado = '1'"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.nave			[al_row] = ls_codigo
			This.object.nomb_nave	[al_row] = ls_data
			This.ii_update = 1
		END IF

	CASE 'zona_pesca'
		ls_sql = "select zona_pesca as codigo, " &
				 + "descr_zona as descripcion_zona " &
				 + "from tg_zonas_pesca " &
				 + "where flag_estado = '1'"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.zona_pesca			[al_row] = ls_codigo
			This.object.desc_zona_pesca	[al_row] = ls_data
			This.ii_update = 1
		END IF

	CASE 'unidad'
		ls_sql = "select und as unidad, " &
				 + "desc_unidad as descripcion_unidad " &
				 + "from unidad " &
				 + "where flag_estado = '1'"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.unidad			[al_row] = ls_codigo
			This.ii_update = 1
		END IF

end choose


//CHOOSE CASE lower(as_columna)
//	
//
//END CHOOSE
//
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'
is_dwform = 'tabular'
ii_ss = 1
ii_ck[1] = 1
idw_mst = dw_master

end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_data, ls_null

SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE lower(dwo.name)
	CASE "empresa"
		select nombre_empresa
			into :ls_data
		from fl_empresas
		where empresa = :data;
		  
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'LA EMPRESA NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.empresa			[row] = ls_null
			this.object.nombre_empresa	[row] = ls_null
			return 1
		end if
		
		this.object.nombre_empresa [row] = ls_data
		
	CASE "especie"
		
		select descr_especie 
			into :ls_data
		from tg_especies
		where especie = :data;
		  
		if SQLCA.SQlCode = 100 then
			MessageBox('Aviso', 'EL CODIGO DE ESPECIE NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.especie			[row] = ls_null
			this.object.descr_especie	[row] = ls_null
			return 1
		end if
		
		this.object.descr_especie [row] = ls_data
	
END CHOOSE


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

event dw_master::itemerror;call super::itemerror;RETURN 1

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.unidad [al_row] = gnvo_app.is_und_ton
end event

