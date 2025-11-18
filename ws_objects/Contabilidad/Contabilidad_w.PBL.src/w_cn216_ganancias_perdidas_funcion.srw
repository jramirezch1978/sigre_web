$PBExportHeader$w_cn216_ganancias_perdidas_funcion.srw
forward
global type w_cn216_ganancias_perdidas_funcion from w_abc_mid
end type
end forward

global type w_cn216_ganancias_perdidas_funcion from w_abc_mid
integer width = 3246
integer height = 2216
string title = "(CN216) Ganancias y Pérdidas por Función"
string menuname = "m_master_smpl"
end type
global w_cn216_ganancias_perdidas_funcion w_cn216_ganancias_perdidas_funcion

on w_cn216_ganancias_perdidas_funcion.create
call super::create
if this.MenuName = "m_master_smpl" then this.MenuID = create m_master_smpl
end on

on w_cn216_ganancias_perdidas_funcion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

dw_master.SetTransObject(sqlca)
dw_master.Retrieve()
idw_1 = dw_master
dw_detail.BorderStyle = StyleRaised!

is_tabla_m  = 'rpt_grupo'
is_tabla_dm = 'rpt_subgrupo'
is_tabla_d  = 'rpt_subgrupo_det'

end event

event ue_modify;call super::ue_modify;String ls_protect

//  Master
   ls_protect=dw_master.Describe("reporte.protect")
	IF ls_protect='0' THEN
   	dw_master.of_column_protect("reporte")
	END IF
	ls_protect=dw_master.Describe("grupo.protect")
	IF ls_protect='0' THEN
   	dw_master.of_column_protect("grupo")
	END IF

//  Detalle del Master
	ls_protect=dw_detmast.Describe("reporte.protect")
	IF ls_protect='0' THEN
   	dw_detmast.of_column_protect("reporte")
	END IF
	ls_protect=dw_detmast.Describe("grupo.protect")
	IF ls_protect='0' THEN
   	dw_detmast.of_column_protect("grupo")
	END IF
	ls_protect=dw_detmast.Describe("subgrupo.protect")
	IF ls_protect='0' THEN
   	dw_detmast.of_column_protect("subgrupo")
	END IF

//  Detalle del Master Detalle
	ls_protect=dw_detail.Describe("reporte.protect")
	IF ls_protect='0' THEN
   	dw_detail.of_column_protect("reporte")
	END IF
	ls_protect=dw_detail.Describe("grupo.protect")
	IF ls_protect='0' THEN
   	dw_detail.of_column_protect("grupo")
	END IF
	ls_protect=dw_detail.Describe("subgrupo.protect")
	IF ls_protect='0' THEN
   	dw_detail.of_column_protect("subgrupo")
	END IF
	ls_protect=dw_detail.Describe("item.protect")
	IF ls_protect='0' THEN
   	dw_detail.of_column_protect("item")
	END IF

end event

event ue_update;// Override

Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detmast.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log_m, lds_log_dm, lds_log_d
	lds_log_m = Create DataStore
	lds_log_dm = Create DataStore
	lds_log_d = Create DataStore
	lds_log_m.DataObject  = 'd_log_diario_tbl'
	lds_log_dm.DataObject = 'd_log_diario_tbl'
	lds_log_d.DataObject  = 'd_log_diario_tbl'
	lds_log_m.SetTransObject(SQLCA)
	lds_log_dm.SetTransObject(SQLCA)
	lds_log_d.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log_m, is_colname_m, is_coltype_m, gs_user, is_tabla_m)
	in_log.of_create_log(dw_detmast, lds_log_dm, is_colname_dm, is_coltype_dm, gs_user, is_tabla_dm)
	in_log.of_create_log(dw_detail, lds_log_d, is_colname_d, is_coltype_d, gs_user, is_tabla_d)
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		Rollback ;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF dw_detmast.ii_update = 1 THEN
	IF dw_detmast.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		Rollback ;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion DetMast", ls_msg, StopSign!)
	END IF
END IF

IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		Rollback ;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_m.Update() = -1 THEN
			lbo_ok = FALSE
			Rollback ;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario, Maestro')
		END IF
		IF lds_log_dm.Update() = -1 THEN
			lbo_ok = FALSE
			Rollback ;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario, DetMast')
		END IF
		IF lds_log_d.Update() = -1 THEN
			lbo_ok = FALSE
			Rollback ;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario, Detalle')
		END IF
	END IF
	DESTROY lds_log_m
	DESTROY lds_log_dm
	DESTROY lds_log_m
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detmast.ii_update = 0
	dw_detail.ii_update = 0
END IF

end event

type dw_master from w_abc_mid`dw_master within w_cn216_ganancias_perdidas_funcion
integer x = 0
integer y = 0
integer width = 3109
integer height = 624
string dataobject = "d_cuentas_balance_f_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'
ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2

idw_det  = dw_detmast
end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2])
end event

event dw_master::clicked;call super::clicked;dw_detail.reset()
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.setitem(al_row,"reporte","GYPFUNCI")

end event

type dw_detail from w_abc_mid`dw_detail within w_cn216_ganancias_perdidas_funcion
integer x = 0
integer y = 1272
integer width = 3109
integer height = 672
string dataobject = "d_cuentas_contables_3_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;is_dwform = 'tabular'
ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3

idw_mst  = dw_detmast

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;Long ll_row, ll_reg, ln_item

ll_row = dw_detail.GetRow()

// Numeración automática de items
ln_item = 0 
For ll_reg = 1 to this.RowCount()
	 if ln_item < this.GetItemNumber( ll_reg, 'item' ) then 
	    ln_item = this.GetItemNumber( ll_reg, 'item' ) 
    end if 
Next
ln_item = ln_item + 1 

this.SetItem(al_row, 'item', ln_item)

end event

event dw_detail::doubleclicked;call super::doubleclicked;string  ls_col, ls_sql, ls_null, ls_return1, ls_return2

SetNull(ls_null)
ls_col = lower(trim(string(dwo.name)))

choose case ls_col

	case 'cnta_ctbl'

		ls_sql = "select cnta_ctbl as codigo, desc_cnta as descripcion from cntbl_cnta where flag_estado = '1' and flag_permite_mov = '1' and flag_labor = 'I'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.cnta_ctbl[row] = ls_return1
		this.object.desc_cnta[row] = ls_return2
		this.ii_update = 1

end choose

end event

event dw_detail::itemchanged;call super::itemchanged;string ls_cuenta, ls_desc_cuenta, ls_flag
integer li_verifica

accepttext()
choose case dwo.name 

	case 'cnta_ctbl'

		ls_cuenta = dw_detail.object.cnta_ctbl[row]	

		li_verifica = 0
		select count(*)
		  into :li_verifica
		  from cntbl_cnta
		  where cnta_ctbl = :ls_cuenta ;
		  
		if li_verifica = 0 then
			MessageBox('Aviso','Cuenta Contable NO Existe')
			return
		end if
		
  		select desc_cnta, flag_labor
	    into :ls_desc_cuenta, :ls_flag
		 from cntbl_cnta
		 where cnta_ctbl = :ls_cuenta ;
	 
//		if ls_flag <> 'F' then
//			MessageBox('Aviso','Cuenta Contable NO es de Función')
//			return
//		end if
		
	  dw_detail.object.desc_cnta[row] = ls_desc_cuenta
		
end choose

end event

type dw_detmast from w_abc_mid`dw_detmast within w_cn216_ganancias_perdidas_funcion
integer x = 0
integer y = 628
integer width = 3109
integer height = 624
string dataobject = "d_cuentas_balance_2_tbl"
boolean vscrollbar = true
end type

event dw_detmast::constructor;call super::constructor;is_dwform = 'tabular'
ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3
ii_rk[1] = 1
ii_rk[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3

idw_mst  = dw_master
idw_det  = dw_detail
end event

event dw_detmast::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

event dw_detmast::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

end event

event dw_detmast::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2],aa_id[3])
end event

