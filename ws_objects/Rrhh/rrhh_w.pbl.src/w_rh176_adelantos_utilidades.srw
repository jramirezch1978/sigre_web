$PBExportHeader$w_rh176_adelantos_utilidades.srw
forward
global type w_rh176_adelantos_utilidades from w_abc_master_smpl
end type
type st_1 from statictext within w_rh176_adelantos_utilidades
end type
type sle_ano from singlelineedit within w_rh176_adelantos_utilidades
end type
type cb_1 from commandbutton within w_rh176_adelantos_utilidades
end type
type st_2 from statictext within w_rh176_adelantos_utilidades
end type
type st_3 from statictext within w_rh176_adelantos_utilidades
end type
type gb_1 from groupbox within w_rh176_adelantos_utilidades
end type
end forward

global type w_rh176_adelantos_utilidades from w_abc_master_smpl
integer width = 2391
integer height = 1744
string title = "(RH176) Adelantos de Utilidades"
string menuname = "m_master_simple"
st_1 st_1
sle_ano sle_ano
cb_1 cb_1
st_2 st_2
st_3 st_3
gb_1 gb_1
end type
global w_rh176_adelantos_utilidades w_rh176_adelantos_utilidades

on w_rh176_adelantos_utilidades.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.st_1=create st_1
this.sle_ano=create sle_ano
this.cb_1=create cb_1
this.st_2=create st_2
this.st_3=create st_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_ano
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.gb_1
end on

on w_rh176_adelantos_utilidades.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_ano)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.gb_1)
end on

event ue_modify;call super::ue_modify;string ls_protect
ls_protect=dw_master.Describe("periodo.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('periodo')
END IF
ls_protect=dw_master.Describe("fecha_adelanto.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('fecha_adelanto')
END IF
end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

end event

event ue_update_pre;call super::ue_update_pre;integer  li_row, li_periodo
datetime ld_fecha_adelanto
string   ls_flag_adelanto, ls_flag_estado
decimal  {2} ld_importe

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

	ld_fecha_adelanto = dw_master.GetItemDatetime(li_row,"fecha_adelanto")
	If isnull(ld_fecha_adelanto) Then
		dw_master.ii_update = 0
		Messagebox("Aviso","Debe fecha del adelanto de utilidades")
		dw_master.SetColumn("fecha_adelanto")
		dw_master.SetFocus()
		return
	End if	
	
	ls_flag_adelanto = dw_master.GetItemString(li_row,"flag_adelanto")
	If isnull(ls_flag_adelanto) Then
		dw_master.ii_update = 0
		Messagebox("Aviso","Debe ingresar forma de pago por el adelanto")
		dw_master.SetColumn("flag_adelanto")
		dw_master.SetFocus()
		return
	End if	

	ls_flag_estado = dw_master.GetItemString(li_row,"flag_estado")
	If isnull(ls_flag_estado) Then
		dw_master.ii_update = 0
		Messagebox("Aviso","Debe ingresar estado del adelanto")
		dw_master.SetColumn("flag_estado")
		dw_master.SetFocus()
		return
	End if	
	
	ld_importe = dw_master.GetItemNumber(li_row,"importe")
	If isnull(ld_importe) or ld_importe = 0.00 Then
		dw_master.ii_update = 0
		Messagebox("Aviso","Debe ingresar monto fijo o porcentaje de adelanto")
		dw_master.SetColumn("importe")
		dw_master.SetFocus()
		return
	End if	

End if	

dw_master.of_set_flag_replicacion( )

end event

event resize;// Override
end event

event ue_dw_share;// Override

end event

type dw_master from w_abc_master_smpl`dw_master within w_rh176_adelantos_utilidades
integer x = 41
integer y = 288
integer width = 2254
integer height = 1228
string dataobject = "d_adelanto_utilidades_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;String ls_ano 


ls_ano = TRIM(sle_ano.text)

IF IsNull(ls_ano) or ls_ano='' THEN
	MessageBox('Aviso','Defina período de utilidades')
	dw_master.DeleteRow (al_row)
END IF

dw_master.Modify("periodo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("fecha_adelanto.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_adelanto.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_estado.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("importe.Protect='1~tIf(IsRowNew(),0,1)'")

this.setitem(al_row,"flag_estado",'1')
this.setitem(al_row,"periodo", Long(ls_ano)) 
end event

event dw_master::itemchanged;call super::itemchanged;String ls_periodo
String ls_ano_fecha
Date ld_fecha_adelanto

accepttext()

choose case dwo.name 
	case 'fecha_adelanto'
		ld_fecha_adelanto = DATE(dw_master.object.fecha_adelanto[row])
		ls_ano_fecha = STRING(ld_fecha_adelanto,'yyyy')
		
		IF ls_periodo <> ls_ano_fecha THEN 
			MessageBox('Aviso', 'Periodo de fecha adelanto no coincide')
			//dw_master.object.fecha_adelanto.[row].setfocus()			
			return -1

		END IF 
end choose

end event

type st_1 from statictext within w_rh176_adelantos_utilidades
integer x = 142
integer y = 104
integer width = 169
integer height = 64
boolean bringtotop = true
integer textsize = -10
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

type sle_ano from singlelineedit within w_rh176_adelantos_utilidades
integer x = 329
integer y = 92
integer width = 169
integer height = 88
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

type cb_1 from commandbutton within w_rh176_adelantos_utilidades
integer x = 695
integer y = 84
integer width = 315
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

event clicked;Long ll_ano

ll_ano = Long(sle_ano.text)

IF ll_ano = 0 THEN
	MessageBox('Aviso', 'Defina período')
	Return 1
END IF 

dw_master.Retrieve(ll_ano)

end event

type st_2 from statictext within w_rh176_adelantos_utilidades
integer x = 1134
integer y = 68
integer width = 1088
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Permite registrar los adelantos a cuenta "
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh176_adelantos_utilidades
integer x = 1129
integer y = 136
integer width = 1097
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "que se le da a los usuarios por utilidades"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_rh176_adelantos_utilidades
integer x = 50
integer y = 28
integer width = 603
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

