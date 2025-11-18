$PBExportHeader$w_cntbl_rpt_detalle_gastos.srw
forward
global type w_cntbl_rpt_detalle_gastos from w_rpt_list
end type
type sle_ano from singlelineedit within w_cntbl_rpt_detalle_gastos
end type
type sle_mes from singlelineedit within w_cntbl_rpt_detalle_gastos
end type
type st_1 from statictext within w_cntbl_rpt_detalle_gastos
end type
type st_2 from statictext within w_cntbl_rpt_detalle_gastos
end type
type gb_1 from groupbox within w_cntbl_rpt_detalle_gastos
end type
type gb_2 from groupbox within w_cntbl_rpt_detalle_gastos
end type
end forward

global type w_cntbl_rpt_detalle_gastos from w_rpt_list
integer width = 3648
integer height = 2028
string title = "Reporte del Detalle de Gastos"
string menuname = "m_abc_report_smpl"
sle_ano sle_ano
sle_mes sle_mes
st_1 st_1
st_2 st_2
gb_1 gb_1
gb_2 gb_2
end type
global w_cntbl_rpt_detalle_gastos w_cntbl_rpt_detalle_gastos

on w_cntbl_rpt_detalle_gastos.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.st_1=create st_1
this.st_2=create st_2
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.gb_2
end on

on w_cntbl_rpt_detalle_gastos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve();call super::ue_retrieve;String ls_ano, ls_mes
ls_ano = String(sle_ano.text)
ls_mes = String(sle_mes.text)

DECLARE pb_usp_cntbl_rpt_detalle_gastos PROCEDURE FOR USP_CNTBL_RPT_DETALLE_GASTOS
        ( :ls_ano, :ls_mes ) ;
Execute pb_usp_cntbl_rpt_detalle_gastos ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_rpt_list`dw_report within w_cntbl_rpt_detalle_gastos
integer x = 5
integer y = 664
integer width = 3598
integer height = 1172
integer taborder = 50
string dataobject = "d_cntbl_rpt_detalle_gasto_tbl"
end type

type dw_1 from w_rpt_list`dw_1 within w_cntbl_rpt_detalle_gastos
integer x = 361
integer y = 116
integer width = 1280
integer height = 264
integer taborder = 10
string dataobject = "d_cntbl_rpt_detalle_gastos_tbl"
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;idw_1 = dw_report
idw_1.Visible = False

dw_1.SetTransObject(sqlca)
dw_1.retrieve()
dw_2.SetTransObject(sqlca)

ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2
end event

type pb_1 from w_rpt_list`pb_1 within w_cntbl_rpt_detalle_gastos
integer x = 1733
integer y = 152
integer width = 128
integer height = 84
integer taborder = 0
integer textsize = -10
string text = "»"
end type

type pb_2 from w_rpt_list`pb_2 within w_cntbl_rpt_detalle_gastos
integer x = 1733
integer y = 260
integer width = 128
integer height = 84
integer taborder = 0
integer textsize = -10
string text = "«"
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_cntbl_rpt_detalle_gastos
integer x = 1952
integer y = 116
integer width = 1280
integer height = 264
integer taborder = 0
string dataobject = "d_cntbl_rpt_detalle_gastos_tbl"
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2
end event

type cb_report from w_rpt_list`cb_report within w_cntbl_rpt_detalle_gastos
integer x = 2286
integer y = 508
integer width = 279
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
string text = "Aceptar"
end type

event cb_report::clicked;call super::clicked;integer i
string  ls_cencos, ls_descripcion

delete from tt_cntbl_centros_costo ;
	
for i = 1 to dw_2.rowcount()
  	 ls_cencos      = dw_2.object.cencos[i]
 	 ls_descripcion = dw_2.object.desc_cencos[i]
	 
	 insert into tt_cntbl_centros_costo (cencos, descripcion)
	 values (:ls_cencos, :ls_descripcion) ;
	 
	 if sqlca.sqlcode = -1 then
		 messagebox("Error al insertar registro",sqlca.sqlerrtext)
	end if
next

parent.event ue_preview()
dw_report.SetTransObject(sqlca)
dw_report.visible=true

parent.event ue_retrieve()

end event

type sle_ano from singlelineedit within w_cntbl_rpt_detalle_gastos
integer x = 1362
integer y = 516
integer width = 192
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cntbl_rpt_detalle_gastos
integer x = 2034
integer y = 516
integer width = 105
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cntbl_rpt_detalle_gastos
integer x = 1079
integer y = 520
integer width = 233
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 16711680
long backcolor = 12632256
string text = "Periodo"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cntbl_rpt_detalle_gastos
integer x = 1600
integer y = 520
integer width = 393
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 16711680
long backcolor = 12632256
string text = "Mes Contable"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cntbl_rpt_detalle_gastos
integer x = 1029
integer y = 456
integer width = 1193
integer height = 160
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_cntbl_rpt_detalle_gastos
integer x = 302
integer y = 32
integer width = 2994
integer height = 400
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Seleccione Centros de Costos "
borderstyle borderstyle = stylelowered!
end type

