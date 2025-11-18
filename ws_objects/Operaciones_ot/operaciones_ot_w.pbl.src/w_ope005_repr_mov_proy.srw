$PBExportHeader$w_ope005_repr_mov_proy.srw
forward
global type w_ope005_repr_mov_proy from w_abc
end type
type dw_master from u_dw_abc within w_ope005_repr_mov_proy
end type
type st_1 from statictext within w_ope005_repr_mov_proy
end type
type sle_dias from singlelineedit within w_ope005_repr_mov_proy
end type
type cb_1 from commandbutton within w_ope005_repr_mov_proy
end type
type gb_1 from groupbox within w_ope005_repr_mov_proy
end type
type rb_logeado from radiobutton within w_ope005_repr_mov_proy
end type
type sle_usr from singlelineedit within w_ope005_repr_mov_proy
end type
type rb_todos from radiobutton within w_ope005_repr_mov_proy
end type
type rb_otros from radiobutton within w_ope005_repr_mov_proy
end type
end forward

global type w_ope005_repr_mov_proy from w_abc
integer width = 2350
integer height = 1812
string title = "[OP005] Reprogramación de Movimientos Atrazados "
string menuname = "m_modifica_graba"
event ue_retrieve ( )
dw_master dw_master
st_1 st_1
sle_dias sle_dias
cb_1 cb_1
gb_1 gb_1
rb_logeado rb_logeado
sle_usr sle_usr
rb_todos rb_todos
rb_otros rb_otros
end type
global w_ope005_repr_mov_proy w_ope005_repr_mov_proy

event ue_retrieve();Long ll_dias
string ls_user

ll_dias = Long(sle_dias.text)

if ll_dias < 0 then ll_dias = 9999999

if rb_todos.checked then
	ls_user = "%%"
elseif rb_logeado.checked then
	ls_user = trim(gs_user) +"%"
elseif rb_otros.checked then	
	if trim(sle_usr.text) = '' or IsNull(sle_usr.text) then
		MEssageBox('Aviso', 'Tiene que indicar un usuario valido')
		return
	end if 
	ls_user = trim(sle_usr.text) +"%"
end if

idw_1.Retrieve(ls_user, ll_dias)

end event

on w_ope005_repr_mov_proy.create
int iCurrent
call super::create
if this.MenuName = "m_modifica_graba" then this.MenuID = create m_modifica_graba
this.dw_master=create dw_master
this.st_1=create st_1
this.sle_dias=create sle_dias
this.cb_1=create cb_1
this.gb_1=create gb_1
this.rb_logeado=create rb_logeado
this.sle_usr=create sle_usr
this.rb_todos=create rb_todos
this.rb_otros=create rb_otros
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_dias
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.rb_logeado
this.Control[iCurrent+7]=this.sle_usr
this.Control[iCurrent+8]=this.rb_todos
this.Control[iCurrent+9]=this.rb_otros
end on

on w_ope005_repr_mov_proy.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
destroy(this.st_1)
destroy(this.sle_dias)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.rb_logeado)
destroy(this.sle_usr)
destroy(this.rb_todos)
destroy(this.rb_otros)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente

dw_master.of_protect()         		// bloquear modificaciones 

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
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

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

type dw_master from u_dw_abc within w_ope005_repr_mov_proy
integer y = 200
integer width = 2149
integer height = 1380
integer taborder = 40
string dataobject = "d_art_mov_proy_atrazados"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

type st_1 from statictext within w_ope005_repr_mov_proy
integer x = 146
integer y = 68
integer width = 169
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dias:"
boolean focusrectangle = false
end type

type sle_dias from singlelineedit within w_ope005_repr_mov_proy
integer x = 325
integer y = 68
integer width = 315
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_ope005_repr_mov_proy
integer x = 1856
integer y = 60
integer width = 448
integer height = 104
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;PARENT.Event dynamic ue_retrieve()

end event

type gb_1 from groupbox within w_ope005_repr_mov_proy
integer x = 667
integer y = 12
integer width = 1157
integer height = 164
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Usuarios"
end type

type rb_logeado from radiobutton within w_ope005_repr_mov_proy
integer x = 978
integer y = 80
integer width = 274
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Logeado"
end type

type sle_usr from singlelineedit within w_ope005_repr_mov_proy
event dobleclick pbm_lbuttondblclk
integer x = 1472
integer y = 80
integer width = 288
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
textcase textcase = lower!
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

event dobleclick;string ls_sql, ls_codigo, ls_data
boolean lb_ret

ls_sql = "SELECT COD_USR AS CODIGO_USUARIO, " &
		  + "NOMBRE AS NOMBRE_USUARIO " &
		  + "FROM USUARIO " 
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	sle_usr.text		= ls_codigo
end if
end event

type rb_todos from radiobutton within w_ope005_repr_mov_proy
integer x = 718
integer y = 80
integer width = 261
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

type rb_otros from radiobutton within w_ope005_repr_mov_proy
integer x = 1257
integer y = 80
integer width = 206
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Otro"
end type

event clicked;if this.checked then
	sle_usr.enabled = true
else
	sle_usr.enabled = false
end if
end event

