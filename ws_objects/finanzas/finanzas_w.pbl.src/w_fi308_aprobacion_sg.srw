$PBExportHeader$w_fi308_aprobacion_sg.srw
forward
global type w_fi308_aprobacion_sg from w_abc
end type
type p_help from picture within w_fi308_aprobacion_sg
end type
type st_help from statictext within w_fi308_aprobacion_sg
end type
type st_search from statictext within w_fi308_aprobacion_sg
end type
type st_refresh from statictext within w_fi308_aprobacion_sg
end type
type pb_refresh from picturebutton within w_fi308_aprobacion_sg
end type
type dw_1 from datawindow within w_fi308_aprobacion_sg
end type
type pb_aceptar from picturebutton within w_fi308_aprobacion_sg
end type
type pb_salir from picturebutton within w_fi308_aprobacion_sg
end type
type dw_master from u_dw_abc within w_fi308_aprobacion_sg
end type
end forward

global type w_fi308_aprobacion_sg from w_abc
integer width = 3474
integer height = 1816
string title = "Solicitud de Adelanto (FI308)"
p_help p_help
st_help st_help
st_search st_search
st_refresh st_refresh
pb_refresh pb_refresh
dw_1 dw_1
pb_aceptar pb_aceptar
pb_salir pb_salir
dw_master dw_master
end type
global w_fi308_aprobacion_sg w_fi308_aprobacion_sg

type variables
String is_col
integer ii_ik[]
end variables

on w_fi308_aprobacion_sg.create
int iCurrent
call super::create
this.p_help=create p_help
this.st_help=create st_help
this.st_search=create st_search
this.st_refresh=create st_refresh
this.pb_refresh=create pb_refresh
this.dw_1=create dw_1
this.pb_aceptar=create pb_aceptar
this.pb_salir=create pb_salir
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_help
this.Control[iCurrent+2]=this.st_help
this.Control[iCurrent+3]=this.st_search
this.Control[iCurrent+4]=this.st_refresh
this.Control[iCurrent+5]=this.pb_refresh
this.Control[iCurrent+6]=this.dw_1
this.Control[iCurrent+7]=this.pb_aceptar
this.Control[iCurrent+8]=this.pb_salir
this.Control[iCurrent+9]=this.dw_master
end on

on w_fi308_aprobacion_sg.destroy
call super::destroy
destroy(this.p_help)
destroy(this.st_help)
destroy(this.st_search)
destroy(this.st_refresh)
destroy(this.pb_refresh)
destroy(this.dw_1)
destroy(this.pb_aceptar)
destroy(this.pb_salir)
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

event ue_open_pre();call super::ue_open_pre;

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente

of_position_window(0,0)       			// Posicionar la ventana en forma fija
ii_access = 1								// 0 = menu (default), 1 = botones, 2 = menu + botones

st_search.text = 'Busca Por Nro. de Solicitud : '
is_col = 'nro_solicitud'

TriggerEvent('ue_retrieve_list')
end event

event ue_update_request();call super::ue_update_request;Integer li_msg_result

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

event ue_update();call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_retrieve_list();call super::ue_retrieve_list;String ls_estado[]

ls_estado [1] = '1'
ls_estado [2] = '2'

idw_1.retrieve(ls_estado,gs_user)
IF idw_1.Rowcount() > 0 THEN
	idw_1.SelectRow(0,FALSE)
	idw_1.SelectRow(1,TRUE)
END IF
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type p_help from picture within w_fi308_aprobacion_sg
integer x = 14
integer y = 1552
integer width = 110
integer height = 76
string picturename = "C:\SIGRE\resources\bmp\Chkmark.bmp"
boolean border = true
boolean focusrectangle = false
end type

type st_help from statictext within w_fi308_aprobacion_sg
integer x = 165
integer y = 1572
integer width = 1394
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dar Doble Click Para Cambiar de Estado a Solicitud de Adelanto"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_search from statictext within w_fi308_aprobacion_sg
integer x = 41
integer y = 128
integer width = 695
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type st_refresh from statictext within w_fi308_aprobacion_sg
integer x = 2807
integer y = 136
integer width = 343
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Refrescar"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_refresh from picturebutton within w_fi308_aprobacion_sg
integer x = 3205
integer y = 92
integer width = 128
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Bmp\db.bmp"
end type

event clicked;Parent.TriggerEvent('ue_update_request')
Parent.TriggerEvent('ue_retrieve_list')
end event

type dw_1 from datawindow within w_fi308_aprobacion_sg
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 800
integer y = 120
integer width = 942
integer height = 84
integer taborder = 10
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type long dw_enter();dw_master.triggerevent(clicked!)
return 1
end event

event type long ue_tecla(keycode key, unsignedlong keyflags);Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_master.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_master.scrollnextrow()	
end if
ll_row = dw_master.Getrow()
Return ll_row
end event

event constructor;Long ll_reg

ll_reg = this.insertrow(0)


end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_master.find(ls_comando, 1, dw_master.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_master.selectrow(0, false)
			dw_master.selectrow(ll_fila,true)
			dw_master.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)
end event

type pb_aceptar from picturebutton within w_fi308_aprobacion_sg
integer x = 2624
integer y = 1448
integer width = 325
integer height = 180
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;Parent.TriggerEvent('ue_update')
Parent.TriggerEvent('ue_retrieve_list')
end event

type pb_salir from picturebutton within w_fi308_aprobacion_sg
integer x = 3013
integer y = 1448
integer width = 315
integer height = 180
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(Parent)
end event

type dw_master from u_dw_abc within w_fi308_aprobacion_sg
integer x = 23
integer y = 224
integer width = 3323
integer height = 1160
integer taborder = 20
string dataobject = "d_abc_lista_solicitud_giro_aprob_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

/////**************///
Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color, ls_etiqueta
Long 	  ll_row


li_col = dw_master.GetColumn()
ls_column = THIS.GetObjectAtPointer()
li_pos = pos(upper(ls_column),'_T')

IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column   = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_report   = mid(ls_column,1,li_pos - 1) + "_t.tag"
	ls_color    = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	
	ls_etiqueta = This.Describe(ls_report)	
	
	st_search.text = "Busca Por : " + ls_etiqueta
	dw_1.reset()
	dw_1.InsertRow(0)
	dw_1.SetFocus()
END  IF

// Si el evento es disparado desde otro objeto que esta activo, este evento no recono

end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

idw_mst  = dw_master		// dw_master

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

event doubleclicked;call super::doubleclicked;Integer li_opcion,li_return
Long    ll_count
String  ls_estado_act,ls_estado_pos,ls_aprobacion,ls_user,ls_nom_usuario,&
		  ls_origen,ls_nro_sg,ls_doc_sol_giro,ls_cencos

Accepttext()

IF row = 0 THEN Return

/*******************************************/
/*Recupero Tipo Documento de Solicitud Giro*/
/*******************************************/
SELECT doc_sol_giro
  INTO :ls_doc_sol_giro
  FROM finparam
 WHERE (reckey = '1') ;
 



ls_estado_act = This.Object.flag_estado   [row]
ls_aprobacion = This.Object.aprobacion    [row]
ls_origen	  = This.Object.origen		   [row]
ls_nro_sg	  = This.Object.nro_solicitud [row]
ls_cencos	  = This.Object.cencos		   [row]

/******Personas Autorizadas*************/
SELECT Count(*)
  INTO :ll_count
  FROM autorizador_giro
 WHERE ((cod_usr = :gs_user   ) AND
 		  (cencos  = :ls_cencos ));
 
IF ll_count = 0 THEN
	SELECT nombre
	  INTO :ls_nom_usuario
	  FROM usuario
	 WHERE (cod_usr = :gs_user) ;
	 
	Messagebox('Aviso','Usuario '+ls_nom_usuario+' Ud No es una Persona Autorizada para este Centro de Costo, Verifique!')
	Return
END IF

/*******************************/

IF 	 ls_estado_act = '1' THEN //Generado Pasara Aprobarse
		 
		 //recuperar centro de costo para verificar acceso
		 
		 
		 ls_estado_pos = 'Aprobar'
		 ls_estado_act = '2'
		 ls_user			= gs_user
		 
		 /**Afecta Presupuesto**/
		 li_return = f_afecta_presupuesto_sg(ls_origen,ls_nro_sg,ls_cencos)
		 
		 IF li_return = 0 THEN
			 Return	
		 END IF
		 
		 /**********************/
		 
		 
ELSEIF ls_estado_act = '2' THEN //Aprobado Pasar a Generado
	
	
		 IF Trim(ls_aprobacion) <> Trim(gs_user) THEN
			 Messagebox('Aviso','Usted No Puede Revertir Aprobacion, Verifique !')
			 Return
		 END IF
		 
		 ls_estado_pos = 'Revertir Aprobacion de'	
		 ls_user			= ''
 		 ls_estado_act = '1'		 
		
END IF	

li_opcion = MessageBox('Pregunta' ,'Desea '+ls_estado_pos+' la Solicitud de Adelanto ?', Question!, YesNo!, 2)

IF li_opcion = 1 THEN
	This.Object.flag_estado [row] = ls_estado_act
	This.Object.aprobacion  [row] = ls_user
	This.ii_update = 1
END IF
end event

