$PBExportHeader$w_rh232_ocupaciones_rtps.srw
forward
global type w_rh232_ocupaciones_rtps from w_abc
end type
type dw_master from u_dw_abc within w_rh232_ocupaciones_rtps
end type
end forward

global type w_rh232_ocupaciones_rtps from w_abc
integer width = 3474
integer height = 1192
string title = "Ocupaciones (RH232)"
string menuname = "m_master_simple"
dw_master dw_master
end type
global w_rh232_ocupaciones_rtps w_rh232_ocupaciones_rtps

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  // Relacionar el dw con la base de datos

dw_master.Retrieve()
idw_1 = dw_master              	// asignar dw corriente

end event

on w_rh232_ocupaciones_rtps.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_rh232_ocupaciones_rtps.destroy
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

type dw_master from u_dw_abc within w_rh232_ocupaciones_rtps
integer x = 32
integer y = 28
integer width = 3369
integer height = 964
string dataobject = "d_abc_ocupaciones_rtps_tbl"
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

event itemchanged;call super::itemchanged;long 		ll_nivel, ll_longitud
string	ls_codigo 	

this.AcceptText()

if row <= 0 then
	return
end if

choose case lower(dwo.name)
	
  case "cod_ocupacion_rtps"
	
	ll_longitud = len(string(this.object.cod_ocupacion_rtps [row]))
   
	if ll_longitud = 1 then
		
		this.object.nro_nivel [row] = 1

  elseif ll_longitud = 2 then
		
		this.object.nro_nivel[row] = 2
  
  elseif ll_longitud = 3 then
		
		this.object.nro_nivel[row] = 3
		
  elseif ll_longitud = 4 then
		
		this.object.nro_nivel[row] = 4
  
  elseif ll_longitud = 5 then
		
		this.object.nro_nivel[row] = 4
	
  end if
	
end choose

end event

