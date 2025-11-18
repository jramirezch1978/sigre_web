$PBExportHeader$w_rh096_tip_suspension_laboral.srw
forward
global type w_rh096_tip_suspension_laboral from w_abc
end type
type dw_master from u_dw_abc within w_rh096_tip_suspension_laboral
end type
end forward

global type w_rh096_tip_suspension_laboral from w_abc
integer width = 4219
integer height = 1584
string title = "T.Suspension Laboral (RH096)"
string menuname = "m_master_simple"
dw_master dw_master
end type
global w_rh096_tip_suspension_laboral w_rh096_tip_suspension_laboral

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  // Relacionar el dw con la base de datos

dw_master.Retrieve()
idw_1 = dw_master              	// asignar dw corriente

end event

on w_rh096_tip_suspension_laboral.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_rh096_tip_suspension_laboral.destroy
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

type dw_master from u_dw_abc within w_rh096_tip_suspension_laboral
event ue_display ( string as_columna,  long al_row )
integer x = 32
integer y = 28
integer width = 4069
integer height = 1344
string dataobject = "d_abc_suspension_rel_laboral_rtps_tbl"
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, ls_desc_cencos_r, &
			ls_dom
Long		ll_row_find

str_parametros sl_param

choose case upper(as_columna)
		
	case "TIPO_SUBSIDIO" 

		ls_sql = "SELECT TIPO_SUBSIDIO AS CODIGO, " &
				  + "desc_tipo_subsidio AS DESCRIPCION " &
				  + "FROM rrhh_tipo_subsidio WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_subsidio		[al_row] = ls_codigo
			this.object.desc_tipo_subsidio  [al_row] = ls_data
			this.ii_update = 1
		end if		
end choose
end event

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

event doubleclicked;call super::doubleclicked;string 	ls_columna
long		ll_row

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event itemchanged;call super::itemchanged;string ls_codigo, ls_data, ls_cod_origen, ls_empresa, ls_dir_empresa

this.AcceptText()

if row <= 0 then
	return
end if
	
choose case upper(dwo.name)
	
  case "TIPO_SUBSIDIO"
		
		ls_codigo = this.object.TIPO_SUBSIDIO[row]

		SetNull(ls_data)
		select desc_tipo_subsidio
		  into :ls_data
		  from rrhh_tipo_subsidio
		 where TIPO_SUBSIDIO  = :ls_codigo
		   and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Aviso', "TIPO DE SUBSIDIO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.TIPO_SUBSIDIO			[row] = ls_data
			this.object.desc_tipo_subsidio	   [row] = ls_data
			return 1
		end if

		this.object.desc_tipo_subsidio[row] = ls_data
end choose

end event

