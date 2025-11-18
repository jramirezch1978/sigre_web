$PBExportHeader$w_ve735_mov_atrazados.srw
forward
global type w_ve735_mov_atrazados from w_report_smpl
end type
type cb_1 from commandbutton within w_ve735_mov_atrazados
end type
type rb_todos from radiobutton within w_ve735_mov_atrazados
end type
type rb_logeado from radiobutton within w_ve735_mov_atrazados
end type
type sle_dias from singlelineedit within w_ve735_mov_atrazados
end type
type st_1 from statictext within w_ve735_mov_atrazados
end type
type rb_otros from radiobutton within w_ve735_mov_atrazados
end type
type sle_usr from singlelineedit within w_ve735_mov_atrazados
end type
type gb_1 from groupbox within w_ve735_mov_atrazados
end type
end forward

global type w_ve735_mov_atrazados from w_report_smpl
integer width = 2455
integer height = 1644
string title = "[VE735] Movimientos Atrazados"
string menuname = "m_reporte"
long backcolor = 67108864
cb_1 cb_1
rb_todos rb_todos
rb_logeado rb_logeado
sle_dias sle_dias
st_1 st_1
rb_otros rb_otros
sle_usr sle_usr
gb_1 gb_1
end type
global w_ve735_mov_atrazados w_ve735_mov_atrazados

type variables
String	is_dw = 'D'
end variables

on w_ve735_mov_atrazados.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.rb_todos=create rb_todos
this.rb_logeado=create rb_logeado
this.sle_dias=create sle_dias
this.st_1=create st_1
this.rb_otros=create rb_otros
this.sle_usr=create sle_usr
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.rb_todos
this.Control[iCurrent+3]=this.rb_logeado
this.Control[iCurrent+4]=this.sle_dias
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.rb_otros
this.Control[iCurrent+7]=this.sle_usr
this.Control[iCurrent+8]=this.gb_1
end on

on w_ve735_mov_atrazados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.rb_todos)
destroy(this.rb_logeado)
destroy(this.sle_dias)
destroy(this.st_1)
destroy(this.rb_otros)
destroy(this.sle_usr)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Long ll_dias
string ls_user

ll_dias = Long(sle_dias.text)

if ll_dias < 0 then ll_dias = 9999999
IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

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

idw_1.object.p_logo.filename 	= gs_logo
idw_1.object.t_nombre.text 	= gs_empresa
idw_1.object.t_user.text 		= gs_user
idw_1.object.detalle_t.text 	= 'Mov Proy con mas de ' + string(ll_dias) + ' dias de retrazo'

end event

event ue_open_pre;call super::ue_open_pre;idw_1.SetTransObject(SQLCA)
idw_1.Modify("DataWindow.Print.Preview=Yes")
idw_1.Object.DataWindow.Print.Paper.Size = 9


end event

type dw_report from w_report_smpl`dw_report within w_ve735_mov_atrazados
integer x = 0
integer y = 208
integer width = 2016
integer height = 1196
integer taborder = 60
string dataobject = "d_rpt_mov_proy_atrazados"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cod_labor" 
		lstr_1.DataObject = 'd_labor_ff'
		lstr_1.Width = 2500
		lstr_1.Height= 650
		lstr_1.Arg[1] = GetItemString(row,'cod_labor')
		lstr_1.Title = 'Labor'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
END CHOOSE
end event

type cb_1 from commandbutton within w_ve735_mov_atrazados
integer x = 1975
integer y = 68
integer width = 402
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;PARENT.Event ue_retrieve()

end event

type rb_todos from radiobutton within w_ve735_mov_atrazados
integer x = 718
integer y = 80
integer width = 274
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

type rb_logeado from radiobutton within w_ve735_mov_atrazados
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

type sle_dias from singlelineedit within w_ve735_mov_atrazados
integer x = 325
integer y = 68
integer width = 315
integer height = 84
integer taborder = 10
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

type st_1 from statictext within w_ve735_mov_atrazados
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

type rb_otros from radiobutton within w_ve735_mov_atrazados
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

type sle_usr from singlelineedit within w_ve735_mov_atrazados
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

type gb_1 from groupbox within w_ve735_mov_atrazados
integer x = 667
integer y = 12
integer width = 1157
integer height = 164
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Usuarios"
end type

