$PBExportHeader$w_sr010_documentos_grupo.srw
forward
global type w_sr010_documentos_grupo from w_abc
end type
type dw_detail from u_dw_abc within w_sr010_documentos_grupo
end type
type dw_master from u_dw_abc within w_sr010_documentos_grupo
end type
end forward

global type w_sr010_documentos_grupo from w_abc
integer width = 1527
integer height = 1420
string title = "[SR010] Grupos y relacion con tipos de documentos"
string menuname = "m_mtto_smpl"
dw_detail dw_detail
dw_master dw_master
end type
global w_sr010_documentos_grupo w_sr010_documentos_grupo

on w_sr010_documentos_grupo.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
this.dw_detail=create dw_detail
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.dw_master
end on

on w_sr010_documentos_grupo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.dw_master)
end on

event ue_open_pre();call super::ue_open_pre;dw_master.SetTransObject(sqlca)  	  // Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)

dw_master.Retrieve()

idw_1 = dw_master              		  // asignar dw corriente
dw_detail.BorderStyle = StyleRaised!  // indicar dw_detail como no activado

dw_master.of_protect()         		  // bloquear modificaciones 
dw_detail.of_protect()

//f_centrar( this)
//ii_help = 101           				  // help topic

end event

event ue_insert();Long    ll_row
Integer li_protect

IF idw_1 = dw_detail  THEN
	IF dw_master.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_modify();call super::ue_modify;Int li_protect

dw_master.of_protect()
dw_detail.of_protect()

li_protect = integer(dw_master.Object.grupo.Protect)

IF li_protect = 0 THEN
   dw_master.Object.grupo.Protect = 1
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
	
	
/*Replicacion*/
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
	dwo = dw_master.object.grupo
	dw_master.Event Clicked(0,0,1,dwo)
END IF
end event

type ole_skin from w_abc`ole_skin within w_sr010_documentos_grupo
end type

type dw_detail from u_dw_abc within w_sr010_documentos_grupo
integer x = 23
integer y = 636
integer width = 1431
integer height = 584
integer taborder = 20
string dataobject = "d_abc_documento_relacion_grd"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;// Busco descripcion del documento

String ls_desc

Select desc_tipo_doc into :ls_desc from doc_tipo where tipo_doc = :data;

this.object.desc_tipo_doc[row] = ls_desc
end event

event constructor;call super::constructor;is_mastdet = 'd'		   // 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				   // indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	         // columnas que recibimos del master

idw_mst  = dw_master // dw_master
idw_det  = dw_detail	// dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_master from u_dw_abc within w_sr010_documentos_grupo
integer x = 23
integer y = 16
integer width = 1431
integer height = 604
string dataobject = "d_abc_documentos_grupo_grd"
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
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master	// dw_master
idw_det  = dw_detail	// dw_detail
end event

event ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)


end event

event ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!	
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;dw_master.Modify("grupo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("descripcion.Protect='1~tIf(IsRowNew(),0,1)'")
end event

