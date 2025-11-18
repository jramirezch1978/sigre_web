$PBExportHeader$w_abc_programacion_turnos_as201.srw
forward
global type w_abc_programacion_turnos_as201 from w_abc_master
end type
type uo_1 from u_cst_quick_search within w_abc_programacion_turnos_as201
end type
type st_1 from statictext within w_abc_programacion_turnos_as201
end type
end forward

global type w_abc_programacion_turnos_as201 from w_abc_master
integer width = 2263
integer height = 1616
string title = "Solo al Personal de Turno Rotativo (AS201)"
string menuname = "m_abc_master_smpl"
uo_1 uo_1
st_1 st_1
end type
global w_abc_programacion_turnos_as201 w_abc_programacion_turnos_as201

type variables
string is_codigo
end variables

on w_abc_programacion_turnos_as201.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.uo_1=create uo_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.st_1
end on

on w_abc_programacion_turnos_as201.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.st_1)
end on

event ue_modify;call super::ue_modify;int li_protect
li_protect = integer(dw_master.Object.carnet_trabajador.Protect)

IF li_protect = 0 THEN
   dw_master.Object.carnet_trabajador.Protect = 1
END IF

end event

event ue_open_pre;call super::ue_open_pre;of_position_window(700,150)
uo_1.of_set_dw('d_maestro_lista_turno_tbl')
uo_1.of_set_field('apel_paterno')

uo_1.of_retrieve_lista()
uo_1.of_sort_lista()
uo_1.of_protect()

end event

type dw_master from w_abc_master`dw_master within w_abc_programacion_turnos_as201
integer x = 0
integer y = 736
integer width = 2208
integer height = 680
string dataobject = "d_programacion_turnos_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'  // Tabular, grid, form (default)
ii_ck[1] = 1           // Forma el PK
ii_ck[2] = 2           // Forma el PK

end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;String ls_protect
String ls_carnet
ls_carnet=uo_1.dw_lista.object.carnet_trabaj[uo_1.dw_lista.getrow()]

this.setitem(al_row,"carnet_trabajador",ls_carnet)
ls_protect=dw_master.Describe("carnet_trabajador.protect")

IF ls_protect='0' THEN
  	dw_master.of_column_protect('carnet_trabajador')
END IF
this.setitem(al_row,"cod_usr",gs_user)

end event

event dw_master::itemchanged;call super::itemchanged;decimal ln_ano, ln_semana
choose case dwo.name
	case 'ano'
		ln_ano = Dec(dw_master.GetText())
		If ln_ano < 2000 or ln_ano > 2025 Then
			Messagebox("Atención","Año no es Válido")
			dw_master.SetColumn("ano")
			dw_master.SetFocus()
			return 1
		End if 
	case 'semana'
		ln_semana = Dec(dw_master.GetText())
		If ln_semana < 1 or ln_semana > 53 Then
			Messagebox("Atención","No existe número de semana")
			dw_master.SetColumn("semana")
			dw_master.SetFocus()
			return 1
		End if 
End Choose 
end event

type uo_1 from u_cst_quick_search within w_abc_programacion_turnos_as201
integer width = 2208
integer height = 608
integer taborder = 10
boolean bringtotop = true
end type

on uo_1.destroy
call u_cst_quick_search::destroy
end on

event ue_retorno;call super::ue_retorno;String ls_carnet
ls_carnet=uo_1.dw_lista.object.carnet_trabaj[uo_1.dw_lista.getrow()]
dw_master.Retrieve(ls_carnet)
is_codigo=aa_id

end event

type st_1 from statictext within w_abc_programacion_turnos_as201
integer y = 640
integer width = 2208
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
boolean underline = true
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = "PROGRAMACION DE TURNOS"
alignment alignment = center!
boolean focusrectangle = false
end type

