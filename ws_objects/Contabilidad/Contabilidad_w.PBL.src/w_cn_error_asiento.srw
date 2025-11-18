$PBExportHeader$w_cn_error_asiento.srw
forward
global type w_cn_error_asiento from w_abc_master_smpl
end type
type st_1 from statictext within w_cn_error_asiento
end type
end forward

global type w_cn_error_asiento from w_abc_master_smpl
integer width = 2382
integer height = 1000
string title = "Errores de proceso"
string menuname = "m_abc_master_smpl"
st_1 st_1
end type
global w_cn_error_asiento w_cn_error_asiento

on w_cn_error_asiento.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_cn_error_asiento.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

type dw_master from w_abc_master_smpl`dw_master within w_cn_error_asiento
integer y = 144
integer width = 2295
integer height = 736
string dataobject = "d_tt_error_asiento_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw

end event

type st_1 from statictext within w_cn_error_asiento
integer x = 631
integer y = 40
integer width = 1015
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
string text = "Errores de proceso generado"
alignment alignment = center!
boolean focusrectangle = false
end type

