$PBExportHeader$w_fi331_eliminacion_cri.srw
forward
global type w_fi331_eliminacion_cri from w_abc
end type
type pb_refresh from picturebutton within w_fi331_eliminacion_cri
end type
type st_refresh from statictext within w_fi331_eliminacion_cri
end type
type p_help from picture within w_fi331_eliminacion_cri
end type
type st_help from statictext within w_fi331_eliminacion_cri
end type
type pb_salir from picturebutton within w_fi331_eliminacion_cri
end type
type pb_aceptar from picturebutton within w_fi331_eliminacion_cri
end type
type dw_master from u_dw_abc within w_fi331_eliminacion_cri
end type
end forward

global type w_fi331_eliminacion_cri from w_abc
integer width = 2688
integer height = 1688
string title = "Eliminar C. de Retención de IGV (FI331)"
string menuname = "m_consulta"
event ue_eliminar_cr ( )
pb_refresh pb_refresh
st_refresh st_refresh
p_help p_help
st_help st_help
pb_salir pb_salir
pb_aceptar pb_aceptar
dw_master dw_master
end type
global w_fi331_eliminacion_cri w_fi331_eliminacion_cri

event ue_eliminar_cr();String ls_expresion
Long   ll_inicio

//filtrar comprobantes de retencio marcados

ls_expresion = "flag_elim = '1'"
dw_master.Setfilter(ls_expresion)
dw_master.filter()
dw_master.SetSort('fecha_emision asc')
dw_master.Sort()

dw_master.ii_update = 0
DO WHILE dw_master.rowcount() > 0
	dw_master.deleterow(0)
	dw_master.ii_update = 1
LOOP


dw_master.Setfilter('')
dw_master.filter()
dw_master.SetSort('fecha_emision asc')
dw_master.Sort()

TriggerEvent('ue_update')
end event

on w_fi331_eliminacion_cri.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.pb_refresh=create pb_refresh
this.st_refresh=create st_refresh
this.p_help=create p_help
this.st_help=create st_help
this.pb_salir=create pb_salir
this.pb_aceptar=create pb_aceptar
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_refresh
this.Control[iCurrent+2]=this.st_refresh
this.Control[iCurrent+3]=this.p_help
this.Control[iCurrent+4]=this.st_help
this.Control[iCurrent+5]=this.pb_salir
this.Control[iCurrent+6]=this.pb_aceptar
this.Control[iCurrent+7]=this.dw_master
end on

on w_fi331_eliminacion_cri.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_refresh)
destroy(this.st_refresh)
destroy(this.p_help)
destroy(this.st_help)
destroy(this.pb_salir)
destroy(this.pb_aceptar)
destroy(this.dw_master)
end on

event resize;call super::resize;//dw_master.width  = newwidth  - dw_master.x - 270
dw_master.height = newheight - dw_master.y - 300
pb_aceptar.y	  = newheight -  200
pb_salir.y		  = newheight -  200
p_help.y			  = newheight -  105
st_help.y		  = newheight -  105

end event

event ue_open_pre();call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente


of_position_window(0,0)       			// Posicionar la ventana en forma fija

TriggerEvent('ue_retrieve_list')
end event

event ue_retrieve_list();call super::ue_retrieve_list;String ls_fecha_inicio,ls_fecha_final,ls_cri 
str_parametros lstr_param

Open(w_pop_cri_eliminacion)

IF isvalid(message.PowerObjectParm) THEN
	lstr_param = message.PowerObjectParm
	ls_fecha_inicio = lstr_param.field_ret_s[1] // fecha inicio
	ls_fecha_final	 = lstr_param.field_ret_s[2] // fecha final
	ls_cri			 = lstr_param.field_ret_s[3] // cri
END IF

dw_master.retrieve(ls_fecha_inicio,ls_fecha_final,ls_cri)
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

type pb_refresh from picturebutton within w_fi331_eliminacion_cri
integer x = 2496
integer y = 4
integer width = 128
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\Source\Bmp\db.bmp"
alignment htextalign = left!
end type

event clicked;Parent.TriggerEvent('ue_retrieve_list')
end event

type st_refresh from statictext within w_fi331_eliminacion_cri
integer x = 2194
integer y = 52
integer width = 256
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Refrescar"
boolean focusrectangle = false
end type

type p_help from picture within w_fi331_eliminacion_cri
integer x = 55
integer y = 1324
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "H:\Source\Bmp\Chkmark.bmp"
boolean border = true
boolean focusrectangle = false
end type

type st_help from statictext within w_fi331_eliminacion_cri
integer x = 151
integer y = 1332
integer width = 1362
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Marcar Comprobante de Retencion de IGV ha eliminar"
boolean focusrectangle = false
end type

type pb_salir from picturebutton within w_fi331_eliminacion_cri
integer x = 2309
integer y = 1120
integer width = 315
integer height = 180
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(Parent)
end event

type pb_aceptar from picturebutton within w_fi331_eliminacion_cri
integer x = 1957
integer y = 1120
integer width = 315
integer height = 180
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;Parent.TriggerEvent('ue_eliminar_cr')
end event

type dw_master from u_dw_abc within w_fi331_eliminacion_cri
integer x = 27
integer y = 124
integer width = 2034
integer height = 920
string dataobject = "d_abc_lista_c_retencion_anulados_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                   	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst = dw_master

end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;This.Selectrow(0,false)
This.Selectrow(currentrow,true)
end event

