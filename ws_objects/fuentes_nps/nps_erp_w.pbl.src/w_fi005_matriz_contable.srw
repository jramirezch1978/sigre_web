$PBExportHeader$w_fi005_matriz_contable.srw
forward
global type w_fi005_matriz_contable from w_abc
end type
type dw_help from datawindow within w_fi005_matriz_contable
end type
type dw_detail from u_dw_abc within w_fi005_matriz_contable
end type
type dw_master from u_dw_abc within w_fi005_matriz_contable
end type
end forward

global type w_fi005_matriz_contable from w_abc
integer width = 3639
integer height = 1972
string title = "Matriz Contable (FI005)"
string menuname = "m_mtto_smpl"
dw_help dw_help
dw_detail dw_detail
dw_master dw_master
end type
global w_fi005_matriz_contable w_fi005_matriz_contable

on w_fi005_matriz_contable.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
this.dw_help=create dw_help
this.dw_detail=create dw_detail
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_help
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.dw_master
end on

on w_fi005_matriz_contable.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_help)
destroy(this.dw_detail)
destroy(this.dw_master)
end on

event ue_open_pre();call super::ue_open_pre;dw_master.SetTransObject(sqlca)  	  // Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)
dw_help.SetTransObject(sqlca)

dw_master.Retrieve()
dw_help.Retrieve()

idw_1 = dw_master              		  // asignar dw corriente
dw_detail.BorderStyle = StyleRaised!  // indicar dw_detail como no activado

dw_master.of_protect()         		  // bloquear modificaciones 
dw_detail.of_protect()

of_position_window(0,0)       		  // Posicionar la ventana en forma fija
//ii_help = 101           				  // help topic

end event

event ue_insert();call super::ue_insert;Long    ll_row
Integer li_protect

IF idw_1 = dw_detail  THEN
	IF Isnull(dw_master.Object.matriz[dw_master.il_row]) OR Trim(dw_master.Object.matriz[dw_master.il_row]) = '' THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event resize;call super::resize;
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10

dw_help.x = newwidth - dw_help.width - cii_windowborder
dw_master.width = dw_help.x - dw_master.x - cii_windowborder
end event

event ue_modify();call super::ue_modify;Int li_protect

dw_master.of_protect()
dw_detail.of_protect()

li_protect = integer(dw_master.Object.matriz.Protect)

IF li_protect = 0 THEN
   dw_master.Object.matriz.Protect = 1
END IF 
end event

event ue_update_request();call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
	END IF
END IF

end event

event ue_update_pre;call super::ue_update_pre;//--VERIFICACION Y ASIGNACION 
IF f_row_Processing(dw_master, "tabular") <> true then	
	ib_update_check = False	
	Return
ELSE
	ib_update_check = True
END IF

IF f_row_Processing(dw_detail, "tabular") <> true then	
	ib_update_check = False	
	Return
ELSE
	ib_update_check = True
END IF
	
	
dw_master.of_set_flag_replicacion ()
dw_detail.of_set_flag_replicacion ()

end event

event ue_update();Boolean lbo_ok = TRUE

dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_open_pos();dwobject dwo


IF dw_master.Rowcount() > 0 THEN
	dw_detail.Retrieve()
	dwo = dw_master.object.matriz
	dw_master.Event Clicked(0,0,1,dwo)
END IF

end event

type ole_skin from w_abc`ole_skin within w_fi005_matriz_contable
end type

type dw_help from datawindow within w_fi005_matriz_contable
integer x = 1870
integer y = 12
integer width = 1719
integer height = 1148
integer taborder = 20
string dragicon = "Form!"
boolean titlebar = true
string title = "Campo de Ayuda"
string dataobject = "d_abc_dw_campos_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemerror;Return 1
end event

event itemchanged;Accepttext()
end event

event clicked;IF row > 0 THEN
	This.setrow(row)
	This.drag(begin!)
	This.selectrow(0,false)
	This.selectrow(row,true)
END IF
end event

type dw_detail from u_dw_abc within w_fi005_matriz_contable
integer y = 1184
integer width = 3593
integer height = 584
integer taborder = 20
string dataobject = "d_abc_matriz_cntbl_financiera_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Integer li_count = 0
Accepttext()

CHOOSE CASE dwo.name
		 CASE 'cnta_ctbl'
				SELECT Count(*)
				INTO	 :li_count
				FROM   cntbl_cnta
				WHERE  cnta_ctbl = :data ; 
					
				IF li_count = 0 THEN
					Messagebox('Aviso','Cuenta Contable No existe, Verifique! ',StopSign!)
					This.object.cnta_ctbl [row] = ''
					Return 1
				END IF
END CHOOSE


end event

event constructor;call super::constructor;is_mastdet = 'd'		   // 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				   // indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	         // columnas que recibimos del master
ii_dk[1] = 1 	         // columnas que se pasan al detalle

idw_mst  = dw_master // dw_master
idw_det  = dw_detail	// dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;This.Object.item[al_row] = al_row
This.SetColumn('cnta_ctbl')
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'cnta_ctbl'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
														 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
														 +'FROM CNTBL_CNTA '

										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_ctbl',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
END CHOOSE


end event

event dragdrop;call super::dragdrop;Dragobject ldo_control
Long       ll_fila
DataWindow ldw_drag
String 	  ls_desc_campo,ls_tipo,ls_formula,ls_glosa
Boolean 	  lb_result		

ldo_control = DraggedObject()

IF ldo_control.typeof() = Datawindow! THEN
	ldw_drag = ldo_control
	IF ldw_drag.dataobject = 'd_abc_dw_campos_tbl' THEN
		ll_fila = ldw_drag.Getrow()
		IF ll_fila > 0 THEN
			ls_desc_campo = ldw_drag.Object.campo 		[ll_fila]
			ls_tipo		  = ldw_drag.Object.flag_tipo [ll_fila]
			IF row = 0 THEN RETURN
			

			lb_result = This.IsSelected(row)
			IF lb_result THEN  //Selecciona Registro
				IF ls_tipo = 'F' THEN
					ls_formula = This.Object.formula [row]
					IF Isnull(ls_formula) THEN 
						ls_formula = ''
					ELSE
						ls_formula = ls_formula+','
					END IF
					
					ls_formula = ls_formula + ls_desc_campo
					
					This.Object.formula 		[row] = ls_formula
					
				ELSE
					ls_glosa = This.Object.glosa_campo [row]
					IF Isnull(ls_glosa) THEN 
						ls_glosa = ''
					ELSE
						ls_glosa = ls_glosa+','
					END IF
					
					ls_glosa = ls_glosa + ls_desc_campo
					
					This.Object.glosa_campo [row] = ls_glosa
					
				END IF
				
				This.ii_update = 1
				
			ELSE
				Messagebox('Aviso','Debe Seleccionar Registro ')
			END IF
			
		END IF
	END IF
END IF





end event

type dw_master from u_dw_abc within w_fi005_matriz_contable
integer y = 16
integer width = 1851
integer height = 1144
string dataobject = "d_abc_matriz_cntbl_financiera_cab_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master	// dw_master
idw_det  = dw_detail	// dw_detail
end event

event ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)


end event

event ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;String ls_filtro

ls_filtro = 'matriz = '+"'"+aa_id[1]+"'"
IF Isnull(ls_filtro) OR Trim(ls_filtro) = '' THEN
	ls_filtro = ' '
END IF


idw_det.SetFilter(ls_filtro)
idw_det.Filter()

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!	
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;dw_master.Modify("matriz.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("descripcion.Protect='1~tIf(IsRowNew(),0,1)'")
end event

