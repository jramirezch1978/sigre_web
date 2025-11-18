$PBExportHeader$w_rh099_cargo_vs_rtps.srw
forward
global type w_rh099_cargo_vs_rtps from w_abc
end type
type dw_master from u_dw_abc within w_rh099_cargo_vs_rtps
end type
end forward

global type w_rh099_cargo_vs_rtps from w_abc
integer width = 3474
integer height = 1680
string title = "Cargo vs Ocupacion RTPS (RH099)"
string menuname = "m_modifica_graba"
dw_master dw_master
end type
global w_rh099_cargo_vs_rtps w_rh099_cargo_vs_rtps

on w_rh099_cargo_vs_rtps.create
int iCurrent
call super::create
if this.MenuName = "m_modifica_graba" then this.MenuID = create m_modifica_graba
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_rh099_cargo_vs_rtps.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_master.Retrieve( )

idw_1 = dw_master              				// asignar dw corriente


of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

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

type dw_master from u_dw_abc within w_rh099_cargo_vs_rtps
integer x = 18
integer y = 8
integer width = 3392
integer height = 1472
string dataobject = "d_abc_cargo_cod_rtps_tbl"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)



ii_ck[1] = 1				// columnas de lectrua de este dw


idw_mst = dw_master

end event

event itemchanged;call super::itemchanged;String ls_null,ls_cod_ocupac,ls_desc_ocupacion


Accepttext()
Setnull(ls_null)

choose case dwo.name
	    case 'cargo_cod_ocupacion_rtps'
		      select r.desc_ocupacion 
				  into :ls_desc_ocupacion
				  from rrhh_ocupacion_rtps r 
				 where (r.nro_nivel 	 = '4' ) and
				 		 (r.flag_estado = '1' ) and
						 (r.cod_ocupacion_rtps = :data) ;
						  
				if sqlca.sqlcode = 100 then
					this.object.cargo_cod_ocupacion_rtps 			  [row] = ls_null
					this.object.rrhh_ocupacion_rtps_desc_ocupacion [row] = ls_null
					Messagebox('Aviso', 'No existe Ocupación de RTPS ,Verifique!')
					Return 1  
				else
					this.object.rrhh_ocupacion_rtps_desc_ocupacion [row] = ls_desc_ocupacion
				end if
						  
end choose




end event

event doubleclicked;call super::doubleclicked;String ls_sql,ls_return1,ls_return2

choose case dwo.name
		 case 'cargo_cod_ocupacion_rtps'
			
			
				ls_sql = "select r.cod_ocupacion_rtps as codigo,r.desc_ocupacion as descripcion from rrhh_ocupacion_rtps r where r.nro_nivel = '4' and r.flag_estado = '1'"
				f_lista(ls_sql, ls_return1, ls_return2, '2')
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				this.object.cargo_cod_ocupacion_rtps			  [row] = ls_return1
				this.object.rrhh_ocupacion_rtps_desc_ocupacion [row] = ls_return2
				this.ii_update = 1
end choose

end event

event itemerror;call super::itemerror;Return 1
end event

