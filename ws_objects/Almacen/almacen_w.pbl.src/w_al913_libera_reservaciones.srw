$PBExportHeader$w_al913_libera_reservaciones.srw
forward
global type w_al913_libera_reservaciones from w_abc
end type
type dw_master from u_dw_abc within w_al913_libera_reservaciones
end type
type sle_origen from singlelineedit within w_al913_libera_reservaciones
end type
type sle_mov from singlelineedit within w_al913_libera_reservaciones
end type
type cb_1 from commandbutton within w_al913_libera_reservaciones
end type
type st_1 from statictext within w_al913_libera_reservaciones
end type
type st_2 from statictext within w_al913_libera_reservaciones
end type
type cb_2 from commandbutton within w_al913_libera_reservaciones
end type
type gb_1 from groupbox within w_al913_libera_reservaciones
end type
end forward

global type w_al913_libera_reservaciones from w_abc
integer width = 2949
integer height = 1072
string title = "Liberar Reservaciones (AL913)"
string menuname = "m_only_grabar"
dw_master dw_master
sle_origen sle_origen
sle_mov sle_mov
cb_1 cb_1
st_1 st_1
st_2 st_2
cb_2 cb_2
gb_1 gb_1
end type
global w_al913_libera_reservaciones w_al913_libera_reservaciones

on w_al913_libera_reservaciones.create
int iCurrent
call super::create
if this.MenuName = "m_only_grabar" then this.MenuID = create m_only_grabar
this.dw_master=create dw_master
this.sle_origen=create sle_origen
this.sle_mov=create sle_mov
this.cb_1=create cb_1
this.st_1=create st_1
this.st_2=create st_2
this.cb_2=create cb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.sle_origen
this.Control[iCurrent+3]=this.sle_mov
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.gb_1
end on

on w_al913_libera_reservaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
destroy(this.sle_origen)
destroy(this.sle_mov)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente




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
	messagebox("Aviso","Grabación satisfactoria",exclamation!)	
	dw_master.ii_update = 0
END IF

end event

event ue_update_pre;call super::ue_update_pre;Long   ll_inicio,ll_nro_mov
String ls_flag_mov,ls_msj_err,ls_origen


dw_master.Accepttext( )

ib_update_check = TRUE

//For ll_inicio = 1 to dw_master.Rowcount()
// 	    ls_origen	 	= dw_master.object.org_amp_ref[ll_inicio]
//	 	 ll_nro_mov		= dw_master.object.nro_amp_ref[ll_inicio]
//	 
//		  //actualiza
//		 Update reservacion_det amp
//		    set amp.cantidad = 0.00
//		  where (amp.org_amp_ref= :ls_origen  ) and
//				  (amp.nro_amp_ref= :ll_nro_mov ) ;
//				  
//		 IF SQLCA.SQLCode = -1 THEN 
//			 ls_msj_err = SQLCA.SQLErrText
// 			 Rollback ;
//	    	 MessageBox('SQL error', ls_msj_err)
//			 ib_update_check = FALSE
//		 END IF
//Next	
end event

type dw_master from u_dw_abc within w_al913_libera_reservaciones
integer y = 224
integer width = 2889
integer height = 592
integer taborder = 30
string dataobject = "d_proc_liberacion_amp"
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

idw_mst = dw_master

end event

event itemchanged;call super::itemchanged;this.Accepttext()
dw_master.ii_update = 1
end event

event itemerror;call super::itemerror;Return 1
end event

type sle_origen from singlelineedit within w_al913_libera_reservaciones
integer x = 247
integer y = 80
integer width = 187
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mov from singlelineedit within w_al913_libera_reservaciones
integer x = 1161
integer y = 72
integer width = 343
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_al913_libera_reservaciones
integer x = 1673
integer y = 68
integer width = 256
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_origen, ls_mov, ls_doc_ot

// ls_fecha_inicio,ls_fecha_final,

ls_origen = sle_origen.text
ls_mov 	 = sle_mov.text

IF Isnull(ls_origen) or trim(ls_origen) = '' THEN ls_origen = ''
IF Isnull(ls_mov)    or trim(ls_origen) = '' THEN ls_mov		= ''

ls_origen = ls_origen + '%'
ls_mov 	 = ls_mov 	 + '%'

SELECT l.doc_ot INTO :ls_doc_ot FROM logparam l WHERE reckey='1' ;

dw_master.Retrieve(ls_origen, ls_mov, ls_doc_ot)


end event

type st_1 from statictext within w_al913_libera_reservaciones
integer x = 763
integer y = 100
integer width = 370
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Movimiento :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_al913_libera_reservaciones
integer x = 46
integer y = 104
integer width = 187
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_al913_libera_reservaciones
integer x = 453
integer y = 80
integer width = 110
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

type gb_1 from groupbox within w_al913_libera_reservaciones
integer x = 18
integer y = 16
integer width = 1966
integer height = 188
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Busqueda"
end type

