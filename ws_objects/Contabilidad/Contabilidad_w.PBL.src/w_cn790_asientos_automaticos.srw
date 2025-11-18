$PBExportHeader$w_cn790_asientos_automaticos.srw
forward
global type w_cn790_asientos_automaticos from w_report_smpl
end type
type cb_1 from commandbutton within w_cn790_asientos_automaticos
end type
type st_1 from statictext within w_cn790_asientos_automaticos
end type
type em_origen from editmask within w_cn790_asientos_automaticos
end type
type cb_2 from commandbutton within w_cn790_asientos_automaticos
end type
type em_descripcion from editmask within w_cn790_asientos_automaticos
end type
type st_2 from statictext within w_cn790_asientos_automaticos
end type
type em_ano from editmask within w_cn790_asientos_automaticos
end type
type ddlb_mes from dropdownlistbox within w_cn790_asientos_automaticos
end type
type st_3 from statictext within w_cn790_asientos_automaticos
end type
type gb_1 from groupbox within w_cn790_asientos_automaticos
end type
end forward

global type w_cn790_asientos_automaticos from w_report_smpl
integer width = 3502
integer height = 1780
string title = "(CN790) Asientos Automaticos"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
st_1 st_1
em_origen em_origen
cb_2 cb_2
em_descripcion em_descripcion
st_2 st_2
em_ano em_ano
ddlb_mes ddlb_mes
st_3 st_3
gb_1 gb_1
end type
global w_cn790_asientos_automaticos w_cn790_asientos_automaticos

on w_cn790_asientos_automaticos.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.st_1=create st_1
this.em_origen=create em_origen
this.cb_2=create cb_2
this.em_descripcion=create em_descripcion
this.st_2=create st_2
this.em_ano=create em_ano
this.ddlb_mes=create ddlb_mes
this.st_3=create st_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.em_descripcion
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.em_ano
this.Control[iCurrent+8]=this.ddlb_mes
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.gb_1
end on

on w_cn790_asientos_automaticos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.em_origen)
destroy(this.cb_2)
destroy(this.em_descripcion)
destroy(this.st_2)
destroy(this.em_ano)
destroy(this.ddlb_mes)
destroy(this.st_3)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_origen
Long   ll_ano,ll_mes
Long   ll_count

ll_ano    = Long(em_ano.text)
ll_mes    = Long(LEFT(ddlb_mes.text,2))
ls_origen = em_origen.text


SetPointer(HourGlass!)


DECLARE pb_usp_cntbl_rpt_genera_aut PROCEDURE FOR usp_cntbl_rpt_genera_aut
(:ls_origen,:ll_ano,:ll_mes ) ;
Execute pb_usp_cntbl_rpt_genera_aut ;	




idw_1.retrieve()





SetPointer(Arrow!)


idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_user.text = gs_user
idw_1.object.t_nombre.text = gs_empresa

end event

event ue_filter;call super::ue_filter;idw_1.groupcalc()
end event

event ue_open_pre;call super::ue_open_pre;ib_preview = FALSE
idw_1.ii_zoom_actual = 100
idw_1.Visible = true

Event ue_preview()

end event

type dw_report from w_report_smpl`dw_report within w_cn790_asientos_automaticos
integer x = 23
integer y = 480
integer width = 3415
integer height = 1096
integer taborder = 90
string dataobject = "d_rpt_asientos_automaticos_tbl"
end type

type cb_1 from commandbutton within w_cn790_asientos_automaticos
integer x = 2971
integer y = 28
integer width = 434
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "P&rocesar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type st_1 from statictext within w_cn790_asientos_automaticos
integer x = 59
integer y = 112
integer width = 279
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_origen from editmask within w_cn790_asientos_automaticos
integer x = 343
integer y = 104
integer width = 151
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_cn790_asientos_automaticos
integer x = 512
integer y = 100
integer width = 87
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

type em_descripcion from editmask within w_cn790_asientos_automaticos
integer x = 613
integer y = 100
integer width = 1143
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_2 from statictext within w_cn790_asientos_automaticos
integer x = 59
integer y = 220
integer width = 279
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ano from editmask within w_cn790_asientos_automaticos
integer x = 343
integer y = 208
integer width = 174
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
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy"
end type

type ddlb_mes from dropdownlistbox within w_cn790_asientos_automaticos
integer x = 343
integer y = 292
integer width = 517
integer height = 856
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Julio","08 - Agosto","09 - Setiembre","10 - Octubre","11 - Noviembre","12 - Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_cn790_asientos_automaticos
integer x = 59
integer y = 304
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Mes :"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn790_asientos_automaticos
integer x = 37
integer y = 24
integer width = 1815
integer height = 404
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Ingrese Datos"
end type

