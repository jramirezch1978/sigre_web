$PBExportHeader$w_fi028_monto_cta_cte.srw
forward
global type w_fi028_monto_cta_cte from w_abc
end type
type dw_master from u_dw_abc within w_fi028_monto_cta_cte
end type
end forward

global type w_fi028_monto_cta_cte from w_abc
integer width = 3474
integer height = 1504
string title = "Cta Cte Limtes x Cliente (FI028)"
string menuname = "m_mantenimiento_cl"
dw_master dw_master
end type
global w_fi028_monto_cta_cte w_fi028_monto_cta_cte

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

on w_fi028_monto_cta_cte.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_fi028_monto_cta_cte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente
dw_master.retrieve()



of_position_window(0,0)       			// Posicionar la ventana en forma fija

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

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
	END IF
END IF
end event

event ue_modify;call super::ue_modify;dw_master.of_protect()

end event

event ue_insert;call super::ue_insert;Long  ll_row



ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_delete;call super::ue_delete;Long  ll_row


ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

type dw_master from u_dw_abc within w_fi028_monto_cta_cte
integer width = 3392
integer height = 1276
string dataobject = "d_abc_montos_x_cliente_cta_cte_tbl"
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;Long   ll_count 
String ls_null,ls_nombre

Accepttext()




choose case dwo.name
		 case 'cliente'
			   select nom_proveedor into :ls_nombre from proveedor 
				  where (proveedor   = :data ) and
				 		 (flag_estado = '1'   ) ; 
						  
			  if sqlca.sqlcode = 100 then
				  Messagebox('Aviso','Codigo de Proveedor No Existe o Esta Inactivo,Verifique!')	
				  this.object.cliente	    [row] = ls_null
				  This.object.nom_proveedor [row] = ls_null
				  Return 1
			  else
			     This.object.nom_proveedor [row] = ls_nombre
			  end if						  
						  
				
end choose

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw


idw_mst = dw_master

end event

event doubleclicked;call super::doubleclicked;String ls_name ,ls_prot ,ls_sql_prov

IF Getrow() = 0 THEN Return
str_seleccionar lstr_seleccionar
str_parametros   sl_param
Datawindow		 ldw	
ls_name = dwo.name

ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE	'cliente'
			 	lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO_PROV , '&
						 								 +'PROVEEDOR.NOM_PROVEEDOR AS DESCRIPCION , '&		
						  								 +'PROVEEDOR.RUC AS CODIGO_RUC '&
						  								 +'FROM PROVEEDOR '&
						  								 +'WHERE PROVEEDOR.FLAG_ESTADO <> '+"'"+'0'+"'"
															
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					This.Object.cliente       [row] = lstr_seleccionar.param1[1]
					This.Object.nom_proveedor [row] = lstr_seleccionar.param2[1]
					ii_update = 1
				END IF
				
		 CASE	'cod_moneda'
			 	lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MONEDA.COD_MONEDA  AS CODIGO , '&
						 								 +'MONEDA.DESCRIPCION AS DESCRIPCION  '&		
						  								 +'FROM MONEDA '&
						  								 +'WHERE MONEDA.FLAG_ESTADO <> '+"'"+'0'+"'"
															
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					This.Object.cod_moneda[row] = lstr_seleccionar.param1[1]
					ii_update = 1
				END IF
	
			
			
END CHOOSE



end event

