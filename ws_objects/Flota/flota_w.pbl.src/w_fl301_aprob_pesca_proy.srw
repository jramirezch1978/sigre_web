$PBExportHeader$w_fl301_aprob_pesca_proy.srw
forward
global type w_fl301_aprob_pesca_proy from w_abc
end type
type pb_modify from u_pb_modify within w_fl301_aprob_pesca_proy
end type
type st_1 from statictext within w_fl301_aprob_pesca_proy
end type
type em_ano from editmask within w_fl301_aprob_pesca_proy
end type
type pb_update from u_pb_update within w_fl301_aprob_pesca_proy
end type
type pb_recuperar from u_pb_std within w_fl301_aprob_pesca_proy
end type
type dw_2 from u_dw_abc within w_fl301_aprob_pesca_proy
end type
type dw_1 from u_dw_abc within w_fl301_aprob_pesca_proy
end type
end forward

global type w_fl301_aprob_pesca_proy from w_abc
integer width = 2688
integer height = 1732
string title = "Aprobacion de la Pesca Proyectada (FL301)"
string menuname = "m_smpl"
event ue_retrieve ( integer ai_ano )
pb_modify pb_modify
st_1 st_1
em_ano em_ano
pb_update pb_update
pb_recuperar pb_recuperar
dw_2 dw_2
dw_1 dw_1
end type
global w_fl301_aprob_pesca_proy w_fl301_aprob_pesca_proy

event ue_retrieve(integer ai_ano);pb_update.enabled 	= true
pb_modify.enabled 	= true

	
dw_1.retrieve(ai_ano)
dw_2.retrieve(ai_ano)
end event

on w_fl301_aprob_pesca_proy.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.pb_modify=create pb_modify
this.st_1=create st_1
this.em_ano=create em_ano
this.pb_update=create pb_update
this.pb_recuperar=create pb_recuperar
this.dw_2=create dw_2
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_modify
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_ano
this.Control[iCurrent+4]=this.pb_update
this.Control[iCurrent+5]=this.pb_recuperar
this.Control[iCurrent+6]=this.dw_2
this.Control[iCurrent+7]=this.dw_1
end on

on w_fl301_aprob_pesca_proy.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_modify)
destroy(this.st_1)
destroy(this.em_ano)
destroy(this.pb_update)
destroy(this.pb_recuperar)
destroy(this.dw_2)
destroy(this.dw_1)
end on

event resize;call super::resize;dw_1.width  = newwidth  - dw_1.x - 10
dw_2.width  = newwidth  - dw_2.x - 10
dw_2.height = newheight - dw_2.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

idw_1 = dw_1

em_ano.text = string(year(today()))
end event

event ue_insert;call super::ue_insert;long ll_row

ll_row = idw_1.Event ue_insert()
//IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
string ls_sort

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
	dw_1.of_protect()
END IF
end event

event ue_update_pre;call super::ue_update_pre;Long 	ll_x, ll_row, ll_rows[], ll_column
boolean lb_ok = TRUE
integer li_mes
string ls_nave, ls_mensaje
decimal ln_pesca

of_get_row_update(dw_1, ll_rows[])

For ll_x = 1 TO UpperBound(ll_rows)
	ll_row 		= ll_rows[ll_x]
	li_mes 		= Integer(dw_1.object.mes[ll_row])
	ls_nave 		= Trim(dw_1.object.nave[ll_row])
	ln_pesca 	= dec(dw_1.object.pesca_estim[ll_row])
	
	If IsNull(li_mes) or li_mes = 0 then
		ls_mensaje = "Debe Ingresar algun mes"
		ll_column = 1
		lb_ok = false
	end if

	If IsNull(ln_pesca) then
		ls_mensaje = "Debe Ingresar alguna pesca"
		ll_column = 1
		lb_ok = false
	end if

	If ( IsNull(ls_nave) or ls_nave = "") and lb_ok then
		ls_mensaje = "Debe Ingresar alguna nave"
		ll_column = 2
		lb_ok = false
	end if

	IF not lb_ok THEN
		MessageBox("Error",ls_mensaje, StopSign! )
		ib_update_check = False
		dw_1.ScrollToRow(ll_row)
		dw_1.SetColumn(ll_Column)
		dw_1.SelectRow(0, false)
		dw_1.SelectRow(ll_row, true)
		dw_1.SetFocus()
		
		RETURN
	END IF
NEXT

dw_1.of_set_flag_replicacion()


end event

event ue_modify;call super::ue_modify;dw_1.of_protect()
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

type pb_modify from u_pb_modify within w_fl301_aprob_pesca_proy
integer x = 923
integer y = 768
integer width = 155
integer height = 132
integer taborder = 70
integer textsize = -2
boolean enabled = false
string text = "&m"
string picturename = "h:\SOURCE\BMP\modificar.bmp"
string disabledname = "h:\SOURCE\BMP\modificar_d.bmp"
string powertiptext = "Modificar"
end type

type st_1 from statictext within w_fl301_aprob_pesca_proy
integer x = 594
integer y = 32
integer width = 439
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese el año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ano from editmask within w_fl301_aprob_pesca_proy
event ue_keyup pbm_keyup
integer x = 1051
integer y = 20
integer width = 334
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
end type

event ue_keyup;integer li_ano

if len(trim(this.text) ) < 4 then
	pb_update.enabled 	= false
	pb_modify.enabled 	= false
end if

If Key = KeyEnter! or Key=KeyTab! Then
	li_ano = integer( this.text )

	parent.event ue_retrieve(li_ano)

end if
end event

type pb_update from u_pb_update within w_fl301_aprob_pesca_proy
integer x = 1083
integer y = 768
integer width = 155
integer height = 132
integer taborder = 60
integer textsize = -2
boolean enabled = false
string text = "&G"
string picturename = "h:\SOURCE\BMP\grabar.bmp"
string disabledname = "h:\SOURCE\BMP\grabar_d.bmp"
string powertiptext = "Grabar"
end type

type pb_recuperar from u_pb_std within w_fl301_aprob_pesca_proy
integer x = 1243
integer y = 768
integer width = 155
integer height = 132
integer taborder = 70
integer textsize = -2
string text = "&r"
string picturename = "Retrieve!"
boolean map3dcolors = true
end type

event clicked;integer li_ano

li_ano = integer(em_ano.text)
parent.event dynamic ue_retrieve(li_ano)
end event

type dw_2 from u_dw_abc within w_fl301_aprob_pesca_proy
integer y = 912
integer width = 2638
integer height = 592
integer taborder = 30
boolean titlebar = true
string title = "Proyeccion de Pesca (VistaTotal)"
string dataobject = "d_pesca_proy_crosstab"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ib_delete_cascada = FALSE
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

type dw_1 from u_dw_abc within w_fl301_aprob_pesca_proy
integer y = 140
integer width = 2638
integer height = 608
integer taborder = 20
string dataobject = "d_pesca_proy_aprob_grid"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ib_delete_cascada = FALSE
ii_ck[1] = 1				// columnas de lectrua de este dw


end event

event ue_insert;call super::ue_insert;long ll_row
string ls_unidad, ls_data, ls_nave
integer li_ano, li_mes

ll_row = This.GetRow()

if ll_row <= 0 then
	return ll_row
end if

li_ano = integer(em_ano.text)
this.object.ano[ll_row] = li_ano
this.object.flag_aprobado[ll_row] = '0'


if ll_row > 1 then
	ls_unidad = trim(this.object.unid[ll_row - 1])
	li_mes    = integer(this.object.mes[ll_row - 1])
	ls_nave   = trim(this.object.nave[ll_row - 1])
	
	if IsNull(ls_nave) or ls_nave = "" then
		Messagebox('Error', "DEBE DIGITAR EL CODIGO DE UNA NAVE", StopSign!)
		return 1
	end if

	if IsNull(li_mes) or li_mes = 0 then
		Messagebox('Error', "DEBE DIGITAR UN MES", StopSign!)
		return 1
	end if

	SetNull(ls_data)
	select desc_unidad
		into :ls_data
	from unidad
	where und = :ls_unidad;
		
	if IsNull(ls_data) or ls_data = "" then
		Messagebox('Error', "UNIDAD NO EXISTE", StopSign!)
		return 1
	end if
		
	this.object.unid[ll_row] 		  = ls_unidad
	this.object.desc_unidad[ll_row] = ls_data
	
	SetNull(ls_data)
	select nomb_nave
		into :ls_data
	from tg_naves
	where nave = :ls_nave;
		
	if IsNull(ls_data) or ls_data = "" then
		Messagebox('Error', "CODIGO DE NAVE NO EXISTE", StopSign!)
		return 1
	end if
	
	
	if li_mes < 12 then
		this.object.mes[ll_row]  		  = li_mes + 1
	else
		this.object.mes[ll_row]  		  = 1
	end if
	this.object.nave[ll_row]		  = ls_nave
	this.object.nomb_nave[ll_row]	  = ls_data
		
end if

return ll_row
end event

event itemerror;call super::itemerror;return 1
end event

event clicked;call super::clicked;this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN

if upper(dwo.name) = "FLAG_APROBADO" then
	ii_update = 1
end if
end event

event rowfocuschanged;call super::rowfocuschanged;IF currentrow = 0 OR is_dwform = 'form' THEN RETURN

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = currentrow       // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(currentrow, True)
	THIS.SetRow(currentrow)
	THIS.Event ue_output(currentrow)
	RETURN
END IF

end event

