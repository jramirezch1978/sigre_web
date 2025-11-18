$PBExportHeader$w_cn034_cierre_contable.srw
forward
global type w_cn034_cierre_contable from w_abc_master_smpl
end type
type st_1 from statictext within w_cn034_cierre_contable
end type
type cb_1 from commandbutton within w_cn034_cierre_contable
end type
type em_ano from editmask within w_cn034_cierre_contable
end type
end forward

global type w_cn034_cierre_contable from w_abc_master_smpl
integer width = 2894
integer height = 2320
string title = "Cierre contable (CN034)"
string menuname = "m_mtto_smpl"
st_1 st_1
cb_1 cb_1
em_ano em_ano
end type
global w_cn034_cierre_contable w_cn034_cierre_contable

on w_cn034_cierre_contable.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
this.st_1=create st_1
this.cb_1=create cb_1
this.em_ano=create em_ano
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.em_ano
end on

on w_cn034_cierre_contable.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.em_ano)
end on

event ue_open_pre;call super::ue_open_pre;//dw_master.of_protect()         		// bloquear modificaciones 
em_ano.text = string(today(),'yyyy')
of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic

end event

event ue_modify();call super::ue_modify;String ls_protect

ls_protect=dw_master.Describe("ano.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("ano")
END IF

ls_protect=dw_master.Describe("mes.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("mes")
END IF
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

event ue_dw_share;// Override
Long ll_ano

ll_ano = LONG(em_ano.text)

IF ii_lec_mst = 1 THEN dw_master.Retrieve(ll_ano)
end event

type p_pie from w_abc_master_smpl`p_pie within w_cn034_cierre_contable
end type

type ole_skin from w_abc_master_smpl`ole_skin within w_cn034_cierre_contable
end type

type uo_h from w_abc_master_smpl`uo_h within w_cn034_cierre_contable
end type

type st_box from w_abc_master_smpl`st_box within w_cn034_cierre_contable
end type

type phl_logonps from w_abc_master_smpl`phl_logonps within w_cn034_cierre_contable
end type

type p_mundi from w_abc_master_smpl`p_mundi within w_cn034_cierre_contable
end type

type p_logo from w_abc_master_smpl`p_logo within w_cn034_cierre_contable
end type

type st_filter from w_abc_master_smpl`st_filter within w_cn034_cierre_contable
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_cn034_cierre_contable
end type

type dw_master from w_abc_master_smpl`dw_master within w_cn034_cierre_contable
integer y = 404
integer width = 2825
integer height = 1696
string dataobject = "d_abc_cierre_cntbl_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type st_1 from statictext within w_cn034_cierre_contable
integer x = 635
integer y = 308
integer width = 165
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Año :"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cn034_cierre_contable
integer x = 1015
integer y = 292
integer width = 279
integer height = 100
integer taborder = 20
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
ll_ano = LONG(em_ano.text)
dw_master.Retrieve(ll_ano)
end event

type em_ano from editmask within w_cn034_cierre_contable
integer x = 823
integer y = 300
integer width = 178
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
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

