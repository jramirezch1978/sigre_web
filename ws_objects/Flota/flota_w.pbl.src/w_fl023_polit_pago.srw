$PBExportHeader$w_fl023_polit_pago.srw
forward
global type w_fl023_polit_pago from w_abc
end type
type pb_recuperar from u_pb_std within w_fl023_polit_pago
end type
type pb_update from u_pb_update within w_fl023_polit_pago
end type
type pb_modify from u_pb_modify within w_fl023_polit_pago
end type
type pb_new from u_pb_insert within w_fl023_polit_pago
end type
type pb_delete from u_pb_delete within w_fl023_polit_pago
end type
type st_1 from statictext within w_fl023_polit_pago
end type
type st_tipo from statictext within w_fl023_polit_pago
end type
type sle_tipo from singlelineedit within w_fl023_polit_pago
end type
type dw_2 from u_dw_abc within w_fl023_polit_pago
end type
type dw_1 from u_dw_abc within w_fl023_polit_pago
end type
end forward

global type w_fl023_polit_pago from w_abc
integer width = 2336
integer height = 1848
string title = "Politicas de Pago (Fl023)"
string menuname = "m_smpl"
boolean center = true
event ue_retrieve ( string as_tipo_pol )
pb_recuperar pb_recuperar
pb_update pb_update
pb_modify pb_modify
pb_new pb_new
pb_delete pb_delete
st_1 st_1
st_tipo st_tipo
sle_tipo sle_tipo
dw_2 dw_2
dw_1 dw_1
end type
global w_fl023_polit_pago w_fl023_polit_pago

event ue_retrieve(string as_tipo_pol);pb_new.enabled 	= true
pb_delete.enabled = true
pb_update.enabled = true
pb_modify.enabled = true

dw_1.Retrieve(as_tipo_pol)

end event

on w_fl023_polit_pago.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.pb_recuperar=create pb_recuperar
this.pb_update=create pb_update
this.pb_modify=create pb_modify
this.pb_new=create pb_new
this.pb_delete=create pb_delete
this.st_1=create st_1
this.st_tipo=create st_tipo
this.sle_tipo=create sle_tipo
this.dw_2=create dw_2
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_recuperar
this.Control[iCurrent+2]=this.pb_update
this.Control[iCurrent+3]=this.pb_modify
this.Control[iCurrent+4]=this.pb_new
this.Control[iCurrent+5]=this.pb_delete
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_tipo
this.Control[iCurrent+8]=this.sle_tipo
this.Control[iCurrent+9]=this.dw_2
this.Control[iCurrent+10]=this.dw_1
end on

on w_fl023_polit_pago.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_recuperar)
destroy(this.pb_update)
destroy(this.pb_modify)
destroy(this.pb_new)
destroy(this.pb_delete)
destroy(this.st_1)
destroy(this.st_tipo)
destroy(this.sle_tipo)
destroy(this.dw_2)
destroy(this.dw_1)
end on

event resize;call super::resize;dw_1.width  = newwidth  - dw_1.x - 10
dw_2.width  = newwidth  - dw_2.x - 10
dw_2.height = newheight - dw_2.y - 10
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_1
dw_1.SetTransObject(SQLCA)
dw_1.of_protect()
dw_2.SetTransObject(SQLCA)
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_1.AcceptText()

ib_update_check = TRUE

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_1.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_1.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
	   Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_1.ii_update = 0
END IF

end event

event ue_modify;call super::ue_modify;dw_1.of_protect()
end event

event ue_insert;call super::ue_insert;Long  ll_row


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

//Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_1.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
		this.TriggerEvent("ue_update")
	ELSE
		dw_1.ii_update = 0
	END IF
END IF
end event

event ue_update_pre;call super::ue_update_pre;dw_1.of_set_flag_replicacion()

end event

type pb_recuperar from u_pb_std within w_fl023_polit_pago
integer x = 1166
integer y = 832
integer width = 155
integer height = 116
integer taborder = 90
integer textsize = -3
string text = "&R"
string picturename = "Retrieve!"
boolean map3dcolors = true
end type

event clicked;dw_2.Retrieve()
end event

type pb_update from u_pb_update within w_fl023_polit_pago
integer x = 1010
integer y = 832
integer width = 155
integer height = 116
integer taborder = 90
integer textsize = -3
boolean enabled = false
string text = "&G"
string disabledname = "\source\bmp\diskette2.bmp"
boolean map3dcolors = true
end type

type pb_modify from u_pb_modify within w_fl023_polit_pago
integer x = 850
integer y = 832
integer width = 155
integer height = 116
integer taborder = 80
integer textsize = -3
boolean enabled = false
string text = "&m"
string disabledname = "\source\bmp\write.bmp"
boolean map3dcolors = true
end type

event clicked;call super::clicked;PARENT.EVENT ue_modify()
end event

type pb_new from u_pb_insert within w_fl023_polit_pago
integer x = 539
integer y = 832
integer width = 155
integer height = 116
integer taborder = 80
integer textsize = -3
boolean enabled = false
string text = "&N"
string disabledname = "\source\bmp\new.bmp"
boolean map3dcolors = true
end type

event clicked;PARENT.EVENT ue_insert()
end event

type pb_delete from u_pb_delete within w_fl023_polit_pago
integer x = 695
integer y = 832
integer width = 155
integer height = 116
integer taborder = 70
integer textsize = -3
boolean enabled = false
string text = "&e"
string disabledname = "\source\bmp\trash.bmp"
boolean map3dcolors = true
end type

event clicked;PARENT.EVENT ue_delete()
end event

type st_1 from statictext within w_fl023_polit_pago
integer x = 297
integer y = 24
integer width = 640
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Tipo de Politica de Pago"
boolean focusrectangle = false
end type

type st_tipo from statictext within w_fl023_polit_pago
integer x = 1253
integer y = 16
integer width = 978
integer height = 88
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type sle_tipo from singlelineedit within w_fl023_polit_pago
event dobleclick pbm_lbuttondblclk
event ue_keyup pbm_keyup
integer x = 965
integer y = 16
integer width = 224
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "\SOURCE\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 2
integer accelerator = 116
borderstyle borderstyle = stylelowered!
end type

event dobleclick;string ls_codigo, ls_data, ls_sql
long ll_row, ll_count
integer li_i
str_seleccionar lstr_seleccionar

ls_sql = "SELECT TIPO_POL_PAGO AS CODIGO, " &
			 + "DESCR_POL_PAGO AS DESCRIPCION " &
          + "FROM FL_TIPO_POLITICA_PAGO"	
				 
lstr_seleccionar.s_column 	  = '1'
lstr_seleccionar.s_sql       = ls_sql
lstr_seleccionar.s_seleccion = 'S'

OpenWithParm(w_seleccionar,lstr_seleccionar)
	
IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
END IF	

IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_codigo = lstr_seleccionar.param1[1]
	ls_data   = lstr_seleccionar.param2[1]
ELSE		
	Messagebox('Error', "DEBE SELECCIONAR UNA POLITICA DE PAGO", StopSign!)
	return 1
end if

this.text 		= ls_codigo		
st_tipo.text 	= ls_data

parent.event ue_retrieve(ls_codigo)
end event

event ue_keyup;string ls_codigo, ls_data

if len(trim(this.text) ) < 2 then
	pb_new.enabled 		= false
	pb_delete.enabled 	= false
	pb_update.enabled 	= false
	pb_modify.enabled 	= false

end if

If Key = KeyEnter! or Key = KeyTab! Then
	ls_codigo = trim( this.text )

	select descr_pol_pago
		into :ls_data
	from fl_tipo_politica_pago
	where tipo_pol_pago = :ls_codigo;

	if IsNull(ls_data) or ls_data = "" then
		Messagebox('Error', "TIPO DE POLITICA DE PAGO NO EXISTE", StopSign!)
		return 1
	end if
	st_tipo.text = ls_data
	parent.event ue_retrieve(ls_codigo)

	pb_new.SetFocus()
end if

end event

type dw_2 from u_dw_abc within w_fl023_polit_pago
integer y = 976
integer width = 2235
integer height = 640
integer taborder = 70
string dataobject = "d_pol_pago_crosstab"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'crosstab'	// tabular, form (default)

ib_delete_cascada = false // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw


end event

event doubleclicked;call super::doubleclicked;MessageBox('', upper(dwo.name))
end event

type dw_1 from u_dw_abc within w_fl023_polit_pago
integer y = 136
integer width = 2240
integer height = 668
integer taborder = 60
string dataobject = "d_polit_pago_tbl"
end type

event constructor;call super::constructor;
is_dwform = 'tabular'	// tabular, form (default)

ib_delete_cascada = false // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw


end event

event itemchanged;call super::itemchanged;string ls_codigo, ls_data, ls_tipo
long ll_row, ll_count

this.AcceptText()
ll_row = this.GetRow()
choose case upper(dwo.name)
	case "CARGO_TRIPULANTE"
		
		ls_codigo = this.object.cargo_tripulante[ll_row]
		ls_tipo   = trim(sle_tipo.text)
		
		SetNull(ls_data)
		select descr_cargo
			into :ls_data
		from fl_cargo_tripulantes
		where cargo_tripulante = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Error', "CARGO DE TRIPULANTE NO EXISTE", StopSign!)
			return 1
		end if
		
		select count(*)
			into :ll_count
		from fl_politica_pago
		where tipo_pol_pago = :ls_tipo 
		  and cargo_tripulante = :ls_codigo;
		
		if ll_count > 0 then
			Messagebox('Error', "CARGO YA FUE ASIGNADO A ESTA POLITICA", StopSign!)
			return 1
		end if

		this.object.descr_cargo[ll_row] = ls_data

end choose

end event

event doubleclicked;call super::doubleclicked;string ls_codigo, ls_data, ls_sql, ls_tipo
long ll_row, ll_count
integer li_i
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = this.GetRow()
choose case upper(dwo.name)
		
	case "CARGO_TRIPULANTE"
		
		ls_sql = "SELECT CARGO_TRIPULANTE AS CODIGO, " &
				 + "DESCR_CARGO AS DESCRIPCION " &
             + "FROM FL_CARGO_TRIPULANTES " &
				 + "WHERE FLAG_ESTADO = '1'"
				 
		lstr_seleccionar.s_column 	  = '1'
		lstr_seleccionar.s_sql       = ls_sql
		lstr_seleccionar.s_seleccion = 'S'

		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN 
			lstr_seleccionar = message.PowerObjectParm
		END IF	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			ls_codigo = lstr_seleccionar.param1[1]
			ls_data   = lstr_seleccionar.param2[1]
		ELSE		
			Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE CARGO", StopSign!)
			return 1
		end if
		
		ls_tipo = trim(sle_tipo.text)

		select count(*)
			into :ll_count
		from fl_politica_pago
		where tipo_pol_pago = :ls_tipo 
		  and cargo_tripulante = :ls_codigo;
		
		if ll_count > 0 then
			Messagebox('Error', "CARGO YA FUE ASIGNADO A ESTA POLITICA", StopSign!)
			return 1
		end if


		this.object.descr_cargo[ll_row] 			= ls_data		
		this.object.cargo_tripulante[ll_row] 	= ls_codigo
		this.ii_update = 1

end choose

end event

event ue_insert;call super::ue_insert;string ls_codigo
long ll_row

ll_row = this.GetRow()
if ll_row < 0 then
	return -1
end if

ls_codigo = sle_tipo.text

this.object.tipo_pol_pago[ll_row] = ls_codigo

return ll_row

end event

