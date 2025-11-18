$PBExportHeader$w_fi034_flujo_proveedor.srw
forward
global type w_fi034_flujo_proveedor from w_abc_mastdet_smpl
end type
end forward

global type w_fi034_flujo_proveedor from w_abc_mastdet_smpl
integer width = 2350
integer height = 2120
string title = "[FI034] Código de Flujo de Caja vs Proveedor"
string menuname = "m_mantenimiento_sl"
end type
global w_fi034_flujo_proveedor w_fi034_flujo_proveedor

on w_fi034_flujo_proveedor.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_fi034_flujo_proveedor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)       			// Posicionar la ventana en forma fija
ii_pregunta_delete = 1   					// 1 = si pregunta, 0 = no pregunta (default)
//ii_help = 101           					// help topic

end event

event ue_modify();call super::ue_modify;String ls_protect
ls_protect = dw_master.Describe("grupo.protect")
If ls_protect = '0' Then
   dw_master.object.grupo.protect = 1
End if	

ls_protect = dw_detail.Describe("grupo.protect")
If ls_protect = '0' Then
   dw_detail.object.grupo.protect = 1
End if	
ls_protect = dw_detail.Describe("proveedor.protect")
If ls_protect = '0' Then
   dw_detail.object.proveedor.protect = 1
End if	

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

event ue_insert;//Override
Long  ll_row

IF idw_1 = dw_master THEN
	MessageBox("Error", "No esta permitido agregar registros en este panel")
	RETURN
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_delete;//Override
Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

if idw_1 = dw_master then
	MessageBox("Alerta", "Proceso no permitido en este panel")
	RETURN
end if

ll_row = idw_1.Event ue_delete()


end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_fi034_flujo_proveedor
integer x = 0
integer y = 0
integer width = 2286
integer height = 1188
string dataobject = "d_lista_cod_flujo_caja_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_dk[1] = 1 	      	// columnas que se pasan al detalle
idw_mst  = dw_master

end event

event dw_master::ue_output;call super::ue_output;if al_Row > 0 then
	dw_detail.Retrieve(this.object.cod_flujo_caja[al_Row])
end if

end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::itemchanged;call super::itemchanged;accepttext()
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_fi034_flujo_proveedor
integer x = 0
integer y = 1212
integer width = 2286
integer height = 620
string dataobject = "d_abc_prov_flujo_Caja_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw

ii_rk[1] = 2 		      // columnas que recibimos del master

end event

event dw_detail::itemchanged;call super::itemchanged;String ls_codigo, ls_desc

accepttext()
CHOOSE CASE dwo.name
		
	CASE 'proveedor'
		select nom_proveedor 
			into :ls_desc 
		from proveedor
		where proveedor=:data
		  and flag_estado = '1';
	
		IF SQLCA.SQLCode = 100 then
			Messagebox('Aviso','Código de Proveedor no existe o no esta activo. por favor Verifique !')	
			This.object.proveedor 		[row] = gnvo_app.is_null
			This.object.nom_proveedor  [row] = gnvo_app.is_null
			Return 1
		end if
		
		this.object.nom_proveedor	[row] = ls_desc
		
END CHOOSE

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;if dw_master.GetRow() > 0 then
	this.object.cod_flujo_caja [al_row] = dw_master.object.cod_flujo_caja[dw_master.GetRow()]
end if
end event

event dw_detail::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "proveedor"

		ls_sql = "select p.proveedor as codigo_proveedor, " &
				 + "p.nom_proveedor as razon_social " &
				 + "from proveedor p " &
				 + "where p.flag_estado = '1'   "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

