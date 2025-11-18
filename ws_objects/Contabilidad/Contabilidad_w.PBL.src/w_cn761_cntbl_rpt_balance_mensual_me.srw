$PBExportHeader$w_cn761_cntbl_rpt_balance_mensual_me.srw
forward
global type w_cn761_cntbl_rpt_balance_mensual_me from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn761_cntbl_rpt_balance_mensual_me
end type
type sle_mesd from singlelineedit within w_cn761_cntbl_rpt_balance_mensual_me
end type
type cb_1 from commandbutton within w_cn761_cntbl_rpt_balance_mensual_me
end type
type st_3 from statictext within w_cn761_cntbl_rpt_balance_mensual_me
end type
type st_4 from statictext within w_cn761_cntbl_rpt_balance_mensual_me
end type
type ddlb_2 from dropdownlistbox within w_cn761_cntbl_rpt_balance_mensual_me
end type
type st_2 from statictext within w_cn761_cntbl_rpt_balance_mensual_me
end type
type st_7 from statictext within w_cn761_cntbl_rpt_balance_mensual_me
end type
type st_6 from statictext within w_cn761_cntbl_rpt_balance_mensual_me
end type
type sle_mesh from singlelineedit within w_cn761_cntbl_rpt_balance_mensual_me
end type
type em_nivel from editmask within w_cn761_cntbl_rpt_balance_mensual_me
end type
type gb_1 from groupbox within w_cn761_cntbl_rpt_balance_mensual_me
end type
type gb_2 from groupbox within w_cn761_cntbl_rpt_balance_mensual_me
end type
end forward

global type w_cn761_cntbl_rpt_balance_mensual_me from w_report_smpl
integer width = 3429
integer height = 1604
string title = "Balance General Mensual con Meses Extras (CN761)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
sle_ano sle_ano
sle_mesd sle_mesd
cb_1 cb_1
st_3 st_3
st_4 st_4
ddlb_2 ddlb_2
st_2 st_2
st_7 st_7
st_6 st_6
sle_mesh sle_mesh
em_nivel em_nivel
gb_1 gb_1
gb_2 gb_2
end type
global w_cn761_cntbl_rpt_balance_mensual_me w_cn761_cntbl_rpt_balance_mensual_me

on w_cn761_cntbl_rpt_balance_mensual_me.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mesd=create sle_mesd
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.ddlb_2=create ddlb_2
this.st_2=create st_2
this.st_7=create st_7
this.st_6=create st_6
this.sle_mesh=create sle_mesh
this.em_nivel=create em_nivel
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mesd
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.ddlb_2
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_7
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.sle_mesh
this.Control[iCurrent+11]=this.em_nivel
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
end on

on w_cn761_cntbl_rpt_balance_mensual_me.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mesd)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.ddlb_2)
destroy(this.st_2)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.sle_mesh)
destroy(this.em_nivel)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;
String ls_ano, ls_mesd, ls_mesh, ls_moneda
Integer ln_nivel, ln_niveles

ln_nivel  = Integer(em_nivel.text)
ls_moneda = upper(ddlb_2.Text)
ls_ano    = String(sle_ano.text)
ls_mesd   = String(sle_mesd.text)
ls_mesh   = String(sle_mesh.text)

select nro_niveles into :ln_niveles from cntblparam
  where reckey = '1' ;
  
if (ln_nivel > ln_niveles) or isnull(ln_nivel) or ln_nivel = 0 then
	MessageBox('Aviso','Número de Nivel no Existe')
	return
end if
  
DECLARE pb_usp_cntbl_rpt_balance_meses PROCEDURE FOR USP_CNTBL_RPT_BALANCE_MESES
        ( :ls_ano, :ls_mesd, :ls_mesh, :ls_moneda, :ln_nivel ) ;
Execute pb_usp_cntbl_rpt_balance_meses ;

dw_report.retrieve()
this.event ue_preview()
end event

event ue_preview;call super::ue_preview;ib_preview = true
end event

type dw_report from w_report_smpl`dw_report within w_cn761_cntbl_rpt_balance_mensual_me
integer x = 23
integer y = 296
integer width = 3360
integer height = 1120
integer taborder = 70
string dataobject = "d_cntbl_balance_mensual_me_tbl"
end type

type sle_ano from singlelineedit within w_cn761_cntbl_rpt_balance_mensual_me
integer x = 722
integer y = 128
integer width = 192
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type sle_mesd from singlelineedit within w_cn761_cntbl_rpt_balance_mensual_me
integer x = 1266
integer y = 128
integer width = 105
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cn761_cntbl_rpt_balance_mensual_me
integer x = 2912
integer y = 108
integer width = 297
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;Parent.Event ue_retrieve()

end event

type st_3 from statictext within w_cn761_cntbl_rpt_balance_mensual_me
integer x = 942
integer y = 136
integer width = 293
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Mes Desde"
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn761_cntbl_rpt_balance_mensual_me
integer x = 553
integer y = 136
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_2 from dropdownlistbox within w_cn761_cntbl_rpt_balance_mensual_me
integer x = 2583
integer y = 112
integer width = 215
integer height = 352
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
string text = "none"
string item[] = {"S/.","US$"}
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_cn761_cntbl_rpt_balance_mensual_me
integer x = 1984
integer y = 128
integer width = 169
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long backcolor = 12632256
string text = "Nivel"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_7 from statictext within w_cn761_cntbl_rpt_balance_mensual_me
integer x = 2336
integer y = 132
integer width = 242
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Moneda"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_cn761_cntbl_rpt_balance_mensual_me
integer x = 1403
integer y = 136
integer width = 293
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Mes Hasta"
boolean focusrectangle = false
end type

type sle_mesh from singlelineedit within w_cn761_cntbl_rpt_balance_mensual_me
integer x = 1705
integer y = 128
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
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type em_nivel from editmask within w_cn761_cntbl_rpt_balance_mensual_me
integer x = 2162
integer y = 120
integer width = 160
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 16711680
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type gb_1 from groupbox within w_cn761_cntbl_rpt_balance_mensual_me
integer x = 512
integer y = 48
integer width = 1362
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Periodo Contable "
end type

type gb_2 from groupbox within w_cn761_cntbl_rpt_balance_mensual_me
integer x = 1943
integer y = 44
integer width = 910
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 255
long backcolor = 12632256
string text = " Seleccione "
end type

