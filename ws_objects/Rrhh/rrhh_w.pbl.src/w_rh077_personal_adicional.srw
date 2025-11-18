$PBExportHeader$w_rh077_personal_adicional.srw
forward
global type w_rh077_personal_adicional from w_abc_master_smpl
end type
type cb_1 from commandbutton within w_rh077_personal_adicional
end type
type st_2 from statictext within w_rh077_personal_adicional
end type
type st_3 from statictext within w_rh077_personal_adicional
end type
type st_1 from statictext within w_rh077_personal_adicional
end type
type sle_ano from singlelineedit within w_rh077_personal_adicional
end type
type st_4 from statictext within w_rh077_personal_adicional
end type
type sle_item from singlelineedit within w_rh077_personal_adicional
end type
type gb_1 from groupbox within w_rh077_personal_adicional
end type
end forward

global type w_rh077_personal_adicional from w_abc_master_smpl
integer width = 3447
integer height = 1916
string title = "(RH077) Personal externo adicional que recibe utilidades"
string menuname = "m_master_simple"
cb_1 cb_1
st_2 st_2
st_3 st_3
st_1 st_1
sle_ano sle_ano
st_4 st_4
sle_item sle_item
gb_1 gb_1
end type
global w_rh077_personal_adicional w_rh077_personal_adicional

on w_rh077_personal_adicional.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.cb_1=create cb_1
this.st_2=create st_2
this.st_3=create st_3
this.st_1=create st_1
this.sle_ano=create sle_ano
this.st_4=create st_4
this.sle_item=create sle_item
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_ano
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.sle_item
this.Control[iCurrent+8]=this.gb_1
end on

on w_rh077_personal_adicional.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.sle_ano)
destroy(this.st_4)
destroy(this.sle_item)
destroy(this.gb_1)
end on

event ue_modify;call super::ue_modify;string ls_protect
ls_protect=dw_master.Describe("periodo.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('periodo')
END IF
ls_protect=dw_master.Describe("cod_relacion.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('cod_relacion')
END IF
end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

end event

event ue_update_pre;call super::ue_update_pre;integer li_row, li_periodo
string  ls_cod_relacion
decimal {2} ld_remun_anual

li_row = dw_master.GetRow()

If li_row > 0 Then 

	li_periodo = dw_master.GetItemNumber(li_row,"periodo")
	If isnull(li_periodo) or li_periodo = 0 Then
		dw_master.ii_update = 0
		Messagebox("Aviso","Debe ingresar el periodo")
		dw_master.SetColumn("periodo")
		dw_master.SetFocus()
		return
	End if	

	ls_cod_relacion = dw_master.GetItemString(li_row,"cod_relacion")
	If isnull(ls_cod_relacion) or ls_cod_relacion = "" Then
		dw_master.ii_update = 0
		Messagebox("Aviso","Debe ingresar el código de la persona")
		dw_master.SetColumn("cod_relacion")
		dw_master.SetFocus()
		return
	End if	

	ld_remun_anual = dw_master.GetItemNumber(li_row,"remun_anual")
	If isnull(ld_remun_anual) or ld_remun_anual = 0.00 Then
		dw_master.ii_update = 0
		Messagebox("Aviso","Debe ingresar la remuneración anual de la persona")
		dw_master.SetColumn("remun_anual")
		dw_master.SetFocus()
		return
	End if	

End if	

dw_master.of_set_flag_replicacion( )

end event

event resize;// Override
end event

event ue_dw_share;// Override
// No debe recuperar en automatico a dw_master
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh077_personal_adicional
integer x = 37
integer y = 316
integer width = 3333
integer height = 1372
string dataobject = "d_personal_adicional_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;String ls_ano
Long ll_item

ls_ano = TRIM(sle_ano.text)
ll_item = LONG(sle_item.text)

IF IsNull(ls_ano) or ls_ano='' THEN
	MessageBox('Aviso','Defina período de utilidades')
	dw_master.DeleteRow (al_row)
END IF

dw_master.Modify("periodo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cod_relacion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("remun_anual.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("dias_efect_ano.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cod_usr.Protect='1~tIf(IsRowNew(),0,1)'")

this.setitem(al_row,"periodo", Long(ls_ano))
this.setitem(al_row,"cod_usr",gs_user)
this.setitem(al_row,"item", ll_item)

end event

event dw_master::itemchanged;call super::itemchanged;string ls_codigo, ls_nombres

accepttext()
choose case dwo.name 
	case 'cod_relacion'
		ls_codigo = dw_master.object.cod_relacion[row]	
		Select nom_proveedor
		  into :ls_nombres
		  from proveedor
		  where proveedor = :ls_codigo ;
		dw_master.object.nombres [row] = ls_nombres
end choose

end event

event dw_master::doubleclicked;call super::doubleclicked;string  ls_col, ls_sql, ls_return1, ls_return2, ls_null

SetNull(ls_null)
ls_col = lower(trim(string(dwo.name)))

choose case ls_col

	case 'cod_relacion'

		ls_sql = "select proveedor as codigo, nom_proveedor as descripcion from proveedor where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.cod_relacion[row] = ls_return1
		this.object.nombres[row]      = ls_return2
		this.ii_update = 1

end choose

end event

type cb_1 from commandbutton within w_rh077_personal_adicional
integer x = 878
integer y = 96
integer width = 265
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Long ll_ano, ll_item

ll_ano = Long(sle_ano.text)
ll_item = Long(sle_item.text)

IF ll_ano = 0 THEN
	MessageBox('Aviso', 'Defina período')
	Return 1
END IF 

dw_master.Retrieve(ll_ano, ll_item)

end event

type st_2 from statictext within w_rh077_personal_adicional
integer x = 1189
integer y = 68
integer width = 2085
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Permite registrar a personal que generalmente no trabaja en la empresa, pero "
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh077_personal_adicional
integer x = 1189
integer y = 156
integer width = 2085
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "que el Directorio o Gerencia general ha considerado necesario pagarle utilidades."
boolean focusrectangle = false
end type

type st_1 from statictext within w_rh077_personal_adicional
integer x = 69
integer y = 112
integer width = 169
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año : "
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_rh077_personal_adicional
integer x = 219
integer y = 100
integer width = 169
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_rh077_personal_adicional
integer x = 480
integer y = 112
integer width = 169
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Item : "
boolean focusrectangle = false
end type

type sle_item from singlelineedit within w_rh077_personal_adicional
integer x = 672
integer y = 96
integer width = 123
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_rh077_personal_adicional
integer x = 50
integer y = 36
integer width = 795
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Período de utilidades"
end type

