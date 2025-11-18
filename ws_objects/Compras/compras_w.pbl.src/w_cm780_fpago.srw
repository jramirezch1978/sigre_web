$PBExportHeader$w_cm780_fpago.srw
forward
global type w_cm780_fpago from w_report_smpl
end type
end forward

global type w_cm780_fpago from w_report_smpl
integer width = 3058
integer height = 1628
string title = "[CM780 FP] ABC de forma de pagos de compras"
string menuname = "m_impresion"
long backcolor = 134217750
end type
global w_cm780_fpago w_cm780_fpago

on w_cm780_fpago.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_cm780_fpago.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;This.Event ue_retrieve()

end event

event ue_retrieve;call super::ue_retrieve;String ls_texto
Decimal{6} ld_total  
str_parametros lstr_rep

lstr_rep = message.powerobjectparm

ls_texto = trim(lstr_rep.string1)
ld_total = lstr_rep.dec1 

idw_1.ii_zoom_actual = 100
ib_preview = false

event ue_preview()

idw_1.Retrieve(ld_total)
idw_1.Visible = True
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_user.text = gs_user
idw_1.Object.t_texto.text = ls_texto
idw_1.Object.p_logo.filename = gs_logo

end event

type dw_report from w_report_smpl`dw_report within w_cm780_fpago
integer x = 46
integer y = 36
integer width = 2930
integer height = 1388
string dataobject = "d_rpt_compras_fpago_tbl"
end type

