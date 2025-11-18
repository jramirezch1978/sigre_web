$PBExportHeader$w_cn030_abc_cntbl_libro_mes.srw
forward
global type w_cn030_abc_cntbl_libro_mes from w_abc_master_smpl
end type
type st_1 from statictext within w_cn030_abc_cntbl_libro_mes
end type
type cb_1 from commandbutton within w_cn030_abc_cntbl_libro_mes
end type
type em_year from editmask within w_cn030_abc_cntbl_libro_mes
end type
end forward

global type w_cn030_abc_cntbl_libro_mes from w_abc_master_smpl
integer width = 2217
integer height = 1784
string title = "Correlativo de Asientos Contables (CN030)"
string menuname = "m_abc_master_smpl"
st_1 st_1
cb_1 cb_1
em_year em_year
end type
global w_cn030_abc_cntbl_libro_mes w_cn030_abc_cntbl_libro_mes

on w_cn030_abc_cntbl_libro_mes.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.st_1=create st_1
this.cb_1=create cb_1
this.em_year=create em_year
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.em_year
end on

on w_cn030_abc_cntbl_libro_mes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.em_year)
end on

event ue_open_pre;call super::ue_open_pre;// Centra pantalla
String ls_ano 

ls_ano = String( gnvo_app.of_fecha_actual(), 'yyyy')

em_year.text = ls_ano

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

event ue_dw_share;// Override
Date ld_hoy
Long ll_ano 

ld_hoy = Date(gnvo_app.of_fecha_Actual())
ll_ano = Long(String(ld_hoy,'yyyy'))
IF ii_lec_mst = 1 THEN dw_master.Retrieve(ll_ano)

end event

type dw_master from w_abc_master_smpl`dw_master within w_cn030_abc_cntbl_libro_mes
integer y = 156
integer width = 2121
integer height = 1376
string dataobject = "d_abc_ctnbl_libro_mes"
boolean hscrollbar = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw

end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;messagebox('Aviso', 'No se permite ingresos de registros, solo actualizaciones')
return 
end event

type st_1 from statictext within w_cn030_abc_cntbl_libro_mes
integer x = 64
integer y = 56
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
integer x = 485
integer y = 36
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

ll_ano = Long(em_year.text)

idw_1.retrieve(ll_ano)
end event

type em_year from editmask within w_cn030_abc_cntbl_libro_mes
integer x = 197
integer y = 40
integer width = 279
integer height = 88
integer taborder = 30
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
boolean spin = true
double increment = 1
string minmax = "0~~9999"
end type

