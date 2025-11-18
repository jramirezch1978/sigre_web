$PBExportHeader$w_cd305_aceptar_remesa.srw
forward
global type w_cd305_aceptar_remesa from w_abc
end type
type dw_detail from u_dw_abc within w_cd305_aceptar_remesa
end type
type p_help from picture within w_cd305_aceptar_remesa
end type
type st_help from statictext within w_cd305_aceptar_remesa
end type
type pb_salir from picturebutton within w_cd305_aceptar_remesa
end type
type pb_aceptar from picturebutton within w_cd305_aceptar_remesa
end type
type dw_master from u_dw_abc within w_cd305_aceptar_remesa
end type
end forward

global type w_cd305_aceptar_remesa from w_abc
integer width = 2784
integer height = 2188
string title = "[CD305] Aceptar remesa "
string menuname = "m_consulta"
dw_detail dw_detail
p_help p_help
st_help st_help
pb_salir pb_salir
pb_aceptar pb_aceptar
dw_master dw_master
end type
global w_cd305_aceptar_remesa w_cd305_aceptar_remesa

on w_cd305_aceptar_remesa.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.dw_detail=create dw_detail
this.p_help=create p_help
this.st_help=create st_help
this.pb_salir=create pb_salir
this.pb_aceptar=create pb_aceptar
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.p_help
this.Control[iCurrent+3]=this.st_help
this.Control[iCurrent+4]=this.pb_salir
this.Control[iCurrent+5]=this.pb_aceptar
this.Control[iCurrent+6]=this.dw_master
end on

on w_cd305_aceptar_remesa.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.p_help)
destroy(this.st_help)
destroy(this.pb_salir)
destroy(this.pb_aceptar)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
//270
dw_master.height = newheight - dw_master.y - 300

pb_aceptar.y	  = newheight -  200
pb_salir.y		  = newheight -  200
p_help.y			  = newheight -  105
st_help.y		  = newheight -  105

end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente
of_position_window(0,0)       			// Posicionar la ventana en forma fija
ii_access = 1								// 0 = menu (default), 1 = botones, 2 = menu + botones

TriggerEvent('ue_retrieve_list')
end event

event ue_retrieve_list;call super::ue_retrieve_list;String ls_estado[]

ls_estado [1] = '1'
ls_estado [2] = '2'

idw_1.retrieve(gs_user)
dw_detail.reset()

IF idw_1.Rowcount() > 0 THEN
	idw_1.SelectRow(0,FALSE)
	idw_1.SelectRow(1,TRUE)
END IF
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

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
    	Rollback ;
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

COMMIT;


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

type dw_detail from u_dw_abc within w_cd305_aceptar_remesa
integer x = 46
integer y = 604
integer width = 2665
integer height = 1084
integer taborder = 20
string dataobject = "d_remesa_det_aprobar_tbl"
end type

event doubleclicked;call super::doubleclicked;Integer li_opcion,li_return
Long    ll_count
String  ls_estado_act,ls_estado_pos,ls_aprobacion,ls_user,ls_nom_usuario,&
		  ls_origen,ls_nro_sg,ls_doc_sol_giro,ls_cencos

Accepttext()

IF row = 0 THEN Return

ls_estado_act = This.Object.flag_estado [row]
ls_nro_sg	  = This.Object.nro_remesa  [row]

IF ls_estado_act = '1' THEN //Generado Pasara Aprobarse
	ls_estado_pos = 'Aprobar'
	ls_estado_act = '2'
	This.Object.flag_estado [row] = '2'
	ls_user		  = gs_user
	
	IF li_return = 0 THEN
		 Return	
	END IF
		 
ELSEIF ls_estado_act = '2' THEN //Aprobado Pasar a Generado
		 ls_estado_pos = 'Revertir Aprobacion de'	
		 ls_user			= ''
 		 ls_estado_act = '1'		 
  		 This.Object.flag_estado [row] = '2'		
END IF	

li_opcion = MessageBox('Pregunta' ,'Desea '+ls_estado_pos+' registro de Remesa ?', Question!, YesNo!, 2)

IF li_opcion = 1 THEN
	This.Object.flag_estado [row] = '1'
	This.ii_update = 1
END IF
end event

event constructor;call super::constructor;is_mastdet = 'd'		
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
idw_det  = dw_detail
end event

type p_help from picture within w_cd305_aceptar_remesa
integer x = 23
integer y = 1916
integer width = 110
integer height = 76
string picturename = "H:\Source\BMP\CHKMARK.BMP"
boolean border = true
boolean focusrectangle = false
end type

type st_help from statictext within w_cd305_aceptar_remesa
integer x = 151
integer y = 1928
integer width = 1038
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dar Doble Click Para Aceptar Remesa"
boolean focusrectangle = false
end type

type pb_salir from picturebutton within w_cd305_aceptar_remesa
integer x = 1984
integer y = 1760
integer width = 315
integer height = 180
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\BMP\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(Parent)
end event

type pb_aceptar from picturebutton within w_cd305_aceptar_remesa
integer x = 1650
integer y = 1760
integer width = 315
integer height = 180
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\Source\BMP\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;Integer i
FOR i=1 TO dw_master.RowCount() 
	IF dw_master.object.cd_remesa_flag_estado[i]='2' THEN
		dw_master.ii_update=1
	ELSE
		dw_master.ii_update=0
	END IF 
NEXT

FOR i=1 TO dw_detail.GetRow() 
	IF dw_detail.object.flag_estado[i]='2' THEN
		dw_detail.ii_update=1
	ELSE
		dw_detail.ii_update=0
	END IF 
NEXT

Parent.TriggerEvent('ue_update')
Parent.TriggerEvent('ue_retrieve_list')

end event

type dw_master from u_dw_abc within w_cd305_aceptar_remesa
integer x = 27
integer y = 36
integer width = 2309
integer height = 492
string dataobject = "d_cd_aprobar_remesa"
boolean vscrollbar = true
end type

event clicked;call super::clicked;String ls_remesa

idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

IF this.getRow()=0 THEN Return

ls_remesa = this.object.nro_remesa[row] 

dw_detail.Retrieve(ls_remesa)



end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

idw_mst  = dw_master		// dw_master

end event

event doubleclicked;call super::doubleclicked;Integer li_opcion, li_return, li
Long    ll_count
String  ls_estado_act,ls_estado_pos,ls_aprobacion,ls_user,ls_nom_usuario,&
		  ls_origen,ls_nro_sg,ls_doc_sol_giro,ls_cencos

Accepttext()

IF this.GetRow() = 0 THEN Return

ls_estado_act = This.Object.cd_remesa_flag_estado [row]
ls_nro_sg	  = This.Object.nro_remesa    		  [row]

IF 	 ls_estado_act = '1' THEN //Generado Pasara Aprobarse
		 ls_estado_pos = 'Aprobar'
		 ls_estado_act = '2'
		 This.Object.cd_remesa_flag_estado [row] = ls_estado_act
		 ls_user			= gs_user

		 IF dw_detail.GetRow() = 0 THEN
			 Return	
		 ELSE
			// Actualizando el detalle de remesa
			FOR li=1 TO dw_detail.RowCount()
				 dw_detail.object.flag_estado[li] = ls_estado_act
				 dw_detail.ii_update = 1
			NEXT 				
		 END IF
		 
ELSEIF ls_estado_act = '2' THEN //Aprobado Pasar a Generado
		 ls_estado_pos = 'Revertir Aprobacion de'	
		 ls_user			= ''
 		 ls_estado_act = '1'		 
  		 This.Object.cd_remesa_flag_estado [row] = ls_estado_act
		 // Actualizando el detalle de remesa
		 IF dw_detail.GetRow() = 0 THEN
			 Return	
		 ELSE
			FOR li=1 TO dw_detail.RowCount()
				 dw_detail.object.flag_estado[li] = ls_estado_act
 				 dw_detail.ii_update = 1
			NEXT 				
		 END IF
		
END IF	

li_opcion = MessageBox('Aviso', 'Datos correctos', Question!, YesNo!, 2)

IF li_opcion = 1 THEN
	This.ii_update = 1
ELSE
	This.ii_update = 0
END IF

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

