$PBExportHeader$w_fi022_forma_pago.srw
forward
global type w_fi022_forma_pago from w_abc_master_smpl
end type
type st_1 from statictext within w_fi022_forma_pago
end type
end forward

global type w_fi022_forma_pago from w_abc_master_smpl
integer width = 3890
integer height = 2296
string title = "Formas de Pago (FI022)"
string menuname = "m_mantenimiento_sl"
st_1 st_1
end type
global w_fi022_forma_pago w_fi022_forma_pago

on w_fi022_forma_pago.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_fi022_forma_pago.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_modify;call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.forma_pago.Protect)

IF li_protect = 0 THEN
   dw_master.Object.forma_pago.Protect = 1
END IF
end event

event ue_open_pre;call super::ue_open_pre;
ii_pregunta_delete = 1 
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if



dw_master.of_set_flag_replicacion ()
end event

event resize;//override
dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

st_1.width  = newwidth  - st_1.x - 10
end event

type dw_master from w_abc_master_smpl`dw_master within w_fi022_forma_pago
integer y = 100
integer width = 3735
integer height = 1868
string dataobject = "d_abc_forma_pago_tbL"
end type

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;//dw_master.Modify("forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
//dw_master.Modify("desc_forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type st_1 from statictext within w_fi022_forma_pago
integer width = 3735
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
boolean enabled = false
string text = "FORMAS DE PAGO"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

