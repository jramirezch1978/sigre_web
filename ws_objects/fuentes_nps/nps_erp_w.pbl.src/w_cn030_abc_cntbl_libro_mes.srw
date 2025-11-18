$PBExportHeader$w_cn030_abc_cntbl_libro_mes.srw
forward
global type w_cn030_abc_cntbl_libro_mes from w_abc_master_smpl
end type
type sle_ano from singlelineedit within w_cn030_abc_cntbl_libro_mes
end type
type st_1 from statictext within w_cn030_abc_cntbl_libro_mes
end type
type cb_1 from commandbutton within w_cn030_abc_cntbl_libro_mes
end type
end forward

global type w_cn030_abc_cntbl_libro_mes from w_abc_master_smpl
integer width = 2217
integer height = 1784
string title = "Correlativo de Asientos Contables (CN030)"
string menuname = "m_mtto_smpl"
sle_ano sle_ano
st_1 st_1
cb_1 cb_1
end type
global w_cn030_abc_cntbl_libro_mes w_cn030_abc_cntbl_libro_mes

on w_cn030_abc_cntbl_libro_mes.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
this.sle_ano=create sle_ano
this.st_1=create st_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_1
end on

on w_cn030_abc_cntbl_libro_mes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.st_1)
destroy(this.cb_1)
end on

event ue_open_pre;call super::ue_open_pre;// Centra pantalla
String ls_ano 

ls_ano = String( Today(), 'yyyy')

sle_ano.text = ls_ano
ii_lec_mst = 0

//of_position_window(20,20)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic



end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

event ue_insert;//Override
messagebox('Aviso', 'No se permite ingresos de registros, ' &
						+ 'solo actualizaciones')

end event

type ole_skin from w_abc_master_smpl`ole_skin within w_cn030_abc_cntbl_libro_mes
end type

type uo_h from w_abc_master_smpl`uo_h within w_cn030_abc_cntbl_libro_mes
end type

type st_box from w_abc_master_smpl`st_box within w_cn030_abc_cntbl_libro_mes
end type

type st_filter from w_abc_master_smpl`st_filter within w_cn030_abc_cntbl_libro_mes
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_cn030_abc_cntbl_libro_mes
end type

type dw_master from w_abc_master_smpl`dw_master within w_cn030_abc_cntbl_libro_mes
integer x = 512
integer y = 392
integer width = 2121
integer height = 1376
string dataobject = "d_abc_ctnbl_libro_mes"
boolean hscrollbar = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw

end event

type sle_ano from singlelineedit within w_cn030_abc_cntbl_libro_mes
integer x = 667
integer y = 296
integer width = 174
integer height = 64
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

type st_1 from statictext within w_cn030_abc_cntbl_libro_mes
integer x = 526
integer y = 300
integer width = 142
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año: "
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cn030_abc_cntbl_libro_mes
integer x = 910
integer y = 280
integer width = 265
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Long ll_ano

ll_ano = Long(sle_ano.text)

idw_1.retrieve(ll_ano)
end event

