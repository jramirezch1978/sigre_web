$PBExportHeader$w_fi023_factura_rubro.srw
forward
global type w_fi023_factura_rubro from w_abc
end type
type dw_master from u_dw_abc within w_fi023_factura_rubro
end type
end forward

global type w_fi023_factura_rubro from w_abc
integer width = 1326
integer height = 1180
string title = "Rubros - Documentos (FI023)"
string menuname = "m_mantenimiento_sl"
dw_master dw_master
end type
global w_fi023_factura_rubro w_fi023_factura_rubro

on w_fi023_factura_rubro.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_fi023_factura_rubro.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  			// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente
dw_master.BorderStyle = StyleRaised!		// indicar dw_detail como no activado

of_position_window(0,0)       			// Posicionar la ventana en forma fija
dw_master.Retrieve()
end event

event ue_modify;call super::ue_modify;dw_master.of_protect()

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
IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

type dw_master from u_dw_abc within w_fi023_factura_rubro
integer x = 9
integer y = 4
integer width = 1234
integer height = 1016
string dataobject = "d_abc_factura_rubro_tbl"
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;String ls_null ,ls_desc_clase

Accepttext()


choose case dwo.name
		 case 'cod_clase'
			
				select desc_clase 
				  into :ls_desc_clase
				  from articulo_clase 
				 where (cod_clase = :data);
				
				if Isnull(ls_desc_clase) or Trim(ls_desc_clase) = '' then
					Messagebox('Aviso','Clase No Existe , Verifique! ')
					this.object.cod_clase  [row] = ls_null
					this.object.desc_clase [row] = ls_null					
					Return 1
				else

					this.object.desc_clase [row] = ls_desc_clase
				end if
				
				
				
end choose

end event

event itemerror;call super::itemerror;Return 1
end event

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

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String     ls_name ,ls_prot
str_seleccionar lstr_seleccionar
Datawindow		 ldw	
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'cod_clase'
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT ARTICULO_CLASE.COD_CLASE  AS CODIGO		  ,'&
								      				 +'ARTICULO_CLASE.DESC_CLASE AS DESCRIPCION  '&
									   				 +'FROM ARTICULO_CLASE '

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_clase' ,lstr_seleccionar.param1[1])
					Setitem(row,'desc_clase',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
				

END CHOOSE



end event

