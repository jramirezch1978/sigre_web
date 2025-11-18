$PBExportHeader$w_ope011_constructor_reportes.srw
forward
global type w_ope011_constructor_reportes from w_abc_mastdet_smpl
end type
type dw_detdet from u_dw_abc within w_ope011_constructor_reportes
end type
end forward

global type w_ope011_constructor_reportes from w_abc_mastdet_smpl
integer width = 3095
integer height = 1752
string title = "Constructor de Repostes (OPE011)"
string menuname = "m_master_sin_lista"
dw_detdet dw_detdet
end type
global w_ope011_constructor_reportes w_ope011_constructor_reportes

on w_ope011_constructor_reportes.create
int iCurrent
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
this.dw_detdet=create dw_detdet
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detdet
end on

on w_ope011_constructor_reportes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detdet)
end on

event ue_open_pre;call super::ue_open_pre;of_position_window(0,0)       			// Posicionar la ventana en forma fija
ii_pregunta_delete = 1   					// 1 = si pregunta, 0 = no pregunta (default)

dw_detdet.SetTransObject(sqlca)
dw_detdet.of_protect()
ii_lec_mst = 0
dw_master.Retrieve(gs_sistema)


end event

event resize;//override
//dw_master.width  = newwidth  - dw_master.x - 10
dw_detdet.width  = newwidth  - dw_detdet.x - 10
dw_detdet.height = newheight - dw_detdet.y - 10
end event

event ue_modify;call super::ue_modify;String ls_protect

dw_detdet.of_protect()

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

event ue_update_request;//override
Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1 OR dw_detdet.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
		dw_detdet.ii_update = 0
	END IF
END IF

end event

event ue_update;//override
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
	dw_detdet.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF dw_detdet.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detdet.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle Final", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
		lbo_ok = dw_detdet.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_detdet.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	dw_detdet.il_totdel = 0
	
	dw_master.REsetUpdate()
	dw_detail.ResetUpdate()
	dw_detdet.ResetUpdate()
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
END IF

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
dw_detdet.of_set_flag_replicacion()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ope011_constructor_reportes
integer x = 9
integer width = 2523
string dataobject = "d_abc_reportes_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_dk[1] = 1 	      	// columnas que se pasan al detalle
idw_mst  = dw_master

end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

//idw_det.ScrollToRow(al_row)


end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ope011_constructor_reportes
integer width = 2290
integer height = 620
string dataobject = "d_abc_rpt_grupo_tbl"
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
ii_rk[1] = 1 		      // columnas que recibimos del master
ii_dk[1] = 1 	         // columnas que se pasan al detalle
ii_dk[2] = 2 

idw_det  = dw_detdet
end event

event dw_detail::doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot 
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		
		 CASE 'cod_relacion'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CODIGO_RELACION.COD_RELACION AS RELACION_CODIGO,'&   
												+'CODIGO_RELACION.NOMBRE AS NOMBRE '&  
												+'FROM CODIGO_RELACION '

				 OpenWithParm(w_seleccionar,lstr_seleccionar)
 
				 IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

				 IF lstr_seleccionar.s_action = "aceptar" THEN
					 Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
					 Setitem(row,'nombre',lstr_seleccionar.param2[1])
					 ii_update = 1
				 END IF
			
END CHOOSE

end event

event dw_detail::itemchanged;call super::itemchanged;String ls_codigo, ls_nombre
Long   ll_count


CHOOSE CASE dwo.name
		
		 CASE 'cod_relacion'
				select count(*) into :ll_count from codigo_relacion 
				where cod_relacion=:data;
			
				IF ll_count = 0 then
					Messagebox('Aviso','Codigo de Relación no existe. Verifique !')	
					SetNull(ls_codigo)
					This.object.cod_relacion [row] = ls_codigo
					This.object.nombre       [row] = ls_codigo
					Return 1
				ELSE
					select nombre into :ls_nombre from codigo_relacion
					where cod_relacion = :data;
					
					this.SetItem( row, 'nombre', ls_nombre)
				END IF
END CHOOSE

end event

event dw_detail::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

//idw_det.ScrollToRow(al_row)

end event

event dw_detail::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2])
end event

type dw_detdet from u_dw_abc within w_ope011_constructor_reportes
integer y = 1180
integer width = 3031
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_rpt_subgrupo_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2	      


idw_mst  = dw_detail

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;accepttext()
end event

