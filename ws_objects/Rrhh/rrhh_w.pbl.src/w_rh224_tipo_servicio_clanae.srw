$PBExportHeader$w_rh224_tipo_servicio_clanae.srw
forward
global type w_rh224_tipo_servicio_clanae from w_abc
end type
type dw_master from u_dw_abc within w_rh224_tipo_servicio_clanae
end type
end forward

global type w_rh224_tipo_servicio_clanae from w_abc
integer width = 2811
integer height = 1208
string title = "Tipos de Servicios - CLaNAE (RH224)"
string menuname = "m_master_simple"
dw_master dw_master
end type
global w_rh224_tipo_servicio_clanae w_rh224_tipo_servicio_clanae

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  // Relacionar el dw con la base de datos

dw_master.Retrieve()
idw_1 = dw_master              	// asignar dw corriente

end event

on w_rh224_tipo_servicio_clanae.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_rh224_tipo_servicio_clanae.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0

END IF

end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

event ue_insert;call super::ue_insert;Long  ll_row


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

type dw_master from u_dw_abc within w_rh224_tipo_servicio_clanae
integer x = 9
integer y = 36
integer width = 2729
integer height = 964
string dataobject = "d_abc_clanae_rtps"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1			// columnas de lectrua de este dw

idw_mst = dw_master

end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
end event

event doubleclicked;call super::doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2, ls_clanae, ls_flag_nivel_in
long   ll_flag_nivel, ll_flag_nivel_in

ls_clanae = this.object.cod_clanae [row]

Select to_number(flag_nivel)
  into :ll_flag_nivel
  from rrhh_tipo_servicio_rtps
 where COD_CLANAE = :ls_clanae;
  
ll_flag_nivel_in = ll_flag_nivel - 1

ls_flag_nivel_in = string(ll_flag_nivel_in)

ls_col = lower(trim(string(dwo.name)))

this.Accepttext()

choose case ls_col
	case 'clanae_super'
		ls_sql = "select distinct cod_clanae as codigo, DESC_CLANAE AS DESCRIPCION, flag_nivel as nivel from rrhh_tipo_servicio_rtps where flag_nivel = '" + ls_flag_nivel_in + "'"
		f_lista(ls_sql, ls_return1, ls_return2, '1')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.clanae_super[row] = ls_return1
		this.ii_update = 1
end choose
end event

