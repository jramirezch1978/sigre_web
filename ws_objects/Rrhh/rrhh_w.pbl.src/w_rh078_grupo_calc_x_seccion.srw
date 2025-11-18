$PBExportHeader$w_rh078_grupo_calc_x_seccion.srw
forward
global type w_rh078_grupo_calc_x_seccion from w_abc
end type
type dw_master from u_dw_abc within w_rh078_grupo_calc_x_seccion
end type
end forward

global type w_rh078_grupo_calc_x_seccion from w_abc
integer width = 3799
integer height = 1636
string title = "Grupo de Calculo por Secciones (RH078)"
string menuname = "m_master_simple"
dw_master dw_master
end type
global w_rh078_grupo_calc_x_seccion w_rh078_grupo_calc_x_seccion

on w_rh078_grupo_calc_x_seccion.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_rh078_grupo_calc_x_seccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_master.Retrieve()
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

event ue_update_pre;call super::ue_update_pre;
//Verificación de Data en Cabecera de Documento
IF f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF
end event

event ue_insert;call super::ue_insert;Long  ll_row



ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_delete;call super::ue_delete;Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

type dw_master from u_dw_abc within w_rh078_grupo_calc_x_seccion
integer x = 18
integer y = 24
integer width = 3717
integer height = 1408
string dataobject = "d_abc_grupos_x_seccion_tbl"
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
ii_ck[2] = 2
ii_ck[3] = 3

idw_mst = dw_master

end event

event itemchanged;call super::itemchanged;Long   ll_count
String ls_null,ls_cod_area,ls_desc_seccion

Accepttext()


choose case dwo.name
		 case 'grupo_calculo'
				select Count(*) into :ll_count
				  from grupo_calculo
				 where grupo_calculo = :data and
				 		 flag_seccion = '1'    ;
				 
				 
				 if ll_count = 0 then
					Messagebox('Aviso','Grupo de Calculo No Existe ,Verifique!')
					This.object.grupo_calculo [row] = ls_null
					Return 1
				 end if
				
				
		 case 'cod_area'	
				select Count(*) into :ll_count
				  from area
				 where cod_area = :data ;
				 
				 
				 if ll_count = 0 then
					Messagebox('Aviso','Area No Existe ,Verifique!')
					This.object.cod_area     [row] = ls_null
					This.object.cod_seccion  [row] = ls_null
					This.object.desc_seccion [row] = ls_null
					Return 1
				 else
					This.object.cod_seccion  [row] = ls_null
					This.object.desc_seccion [row] = ls_null
				 end if
				
		 case 'cod_seccion'
				ls_cod_area = this.object.cod_area [row]

				If Isnull(ls_cod_area) or Trim(ls_cod_area) = '' Then
					Messagebox('Aviso','Debe Ingresar Codigo de Area para selecionar Alguna Seccion')					
					RETURN 1
				End If
				
				select desc_seccion into :ls_desc_seccion
				  from seccion
				 where (cod_area    = :ls_cod_area ) and
				 		 (cod_seccion = :data    ) and
						 (flag_estado = '1' ) ;
				
				
						  
			  if sqlca.sqlcode = 100 then
				  Messagebox('Aviso','Codigo de Proveedor No Existe o Esta Inactivo,Verifique!')	
				  this.object.cod_seccion  [row] = ls_null
				  This.object.desc_seccion [row] = ls_null
				  Return 1
			  else
			     This.object.desc_seccion [row] = ls_desc_seccion
			  end if
				
end choose

end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;String ls_name ,ls_prot ,ls_cod_area

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
		 CASE 'grupo_calculo'
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT GRUPO_CALCULO.GRUPO_CALCULO AS CODIGO_GRUPO ,'&
														 +'GRUPO_CALCULO.DESC_GRUPO    AS DESCRIPCION   '&
														 +'FROM GRUPO_CALCULO '&
														 +'WHERE GRUPO_CALCULO.FLAG_SECCION = '+"'"+'1'+"'"

															
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					This.Object.grupo_calculo [row] = lstr_seleccionar.param1[1]
					This.Object.desc_grupo	  [row] = lstr_seleccionar.param2[1]
					ii_update = 1
				END IF
				
		 CASE 'cod_area'	
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT AREA.COD_AREA  AS CODIGO_AREA ,'&
														 +'AREA.DESC_AREA AS DESCRIPCION  '&
														 +'FROM AREA '
														 
														 
														 
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					This.Object.cod_area	    [row] = lstr_seleccionar.param1[1]
					This.Object.cod_seccion	 [row] = ''
					This.Object.desc_seccion [row] = ''
					ii_update = 1
				END IF
														 
		 CASE 'cod_seccion'	
			   ls_cod_area = this.object.cod_area [row]
				
				If Isnull(ls_cod_area) OR Trim(ls_cod_area) = '' Then
					Messagebox('Aviso','Debe Seleccionar Codigo de Area para escoger Seccion ,Verifique!')
					Return
				End If
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql ='SELECT SECCION.COD_AREA AS CODIGO_AREA ,'&
														+'SECCION.COD_SECCION AS CODIGO_SECCION ,'&
														+'SECCION.DESC_SECCION AS DESCRIPCION  '&  
														+'FROM SECCION '&
														+'WHERE SECCION.FLAG_ESTADO = '+"'"+'1'+"' AND "&
														+'		  SECCION.COD_AREA	 = '+"'"+ls_cod_area+"'"				
													
														 
														 
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					This.Object.cod_seccion  [row] = lstr_seleccionar.param2[1]
					This.Object.desc_seccion [row] = lstr_seleccionar.param3[1]	
					ii_update = 1
				END IF
				
			
END CHOOSE


end event

