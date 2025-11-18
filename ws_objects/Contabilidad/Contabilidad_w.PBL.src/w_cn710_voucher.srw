$PBExportHeader$w_cn710_voucher.srw
forward
global type w_cn710_voucher from w_rpt_htb
end type
type st_1 from statictext within w_cn710_voucher
end type
type st_2 from statictext within w_cn710_voucher
end type
type st_3 from statictext within w_cn710_voucher
end type
type st_4 from statictext within w_cn710_voucher
end type
type em_1 from editmask within w_cn710_voucher
end type
type ddlb_1 from u_ddlb within w_cn710_voucher
end type
type ddlb_2 from u_ddlb within w_cn710_voucher
end type
type em_2 from editmask within w_cn710_voucher
end type
type st_5 from statictext within w_cn710_voucher
end type
type em_3 from editmask within w_cn710_voucher
end type
type cb_1 from commandbutton within w_cn710_voucher
end type
type em_4 from editmask within w_cn710_voucher
end type
end forward

global type w_cn710_voucher from w_rpt_htb
integer width = 2926
integer height = 1812
string title = "Voucher Contable (CN710)"
string menuname = "m_rpt_htb"
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
em_1 em_1
ddlb_1 ddlb_1
ddlb_2 ddlb_2
em_2 em_2
st_5 st_5
em_3 em_3
cb_1 cb_1
em_4 em_4
end type
global w_cn710_voucher w_cn710_voucher

on w_cn710_voucher.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_htb" then this.MenuID = create m_rpt_htb
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.em_1=create em_1
this.ddlb_1=create ddlb_1
this.ddlb_2=create ddlb_2
this.em_2=create em_2
this.st_5=create st_5
this.em_3=create em_3
this.cb_1=create cb_1
this.em_4=create em_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.em_1
this.Control[iCurrent+6]=this.ddlb_1
this.Control[iCurrent+7]=this.ddlb_2
this.Control[iCurrent+8]=this.em_2
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.em_3
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.em_4
end on

on w_cn710_voucher.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.em_1)
destroy(this.ddlb_1)
destroy(this.ddlb_2)
destroy(this.em_2)
destroy(this.st_5)
destroy(this.em_3)
destroy(this.cb_1)
destroy(this.em_4)
end on

event ue_retrieve();call super::ue_retrieve;String ls_origen
Integer ln_libro, ln_ano, ln_mes, ln_nro_asiento, ln_nro_asiento1
ls_origen = LEFT(ddlb_2.text,2)
ln_libro  = Integer( LEFT( ddlb_1.text,2))
ln_ano = Integer( em_1.text )
ln_mes = Integer( em_2.text )
ln_nro_asiento = Integer( em_3.text )
ln_nro_asiento1 = Integer( em_4.text )

idw_1.Retrieve(ls_origen, ln_ano, ln_mes, ln_libro, ln_nro_asiento, ln_nro_asiento1)
end event

type dw_report from w_rpt_htb`dw_report within w_cn710_voucher
integer x = 5
integer y = 288
integer width = 2871
integer height = 1332
string dataobject = "d_voucher_tbl"
end type

type htb_1 from w_rpt_htb`htb_1 within w_cn710_voucher
integer x = 0
integer y = 176
end type

type st_1 from statictext within w_cn710_voucher
integer x = 5
integer y = 16
integer width = 174
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn710_voucher
integer x = 809
integer y = 24
integer width = 110
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn710_voucher
integer x = 1184
integer y = 24
integer width = 119
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn710_voucher
integer x = 1545
integer y = 24
integer width = 123
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Libro:"
boolean focusrectangle = false
end type

type em_1 from editmask within w_cn710_voucher
integer x = 919
integer y = 12
integer width = 256
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
string minmax = "2001~~2099"
end type

type ddlb_1 from u_ddlb within w_cn710_voucher
integer x = 1669
integer y = 12
integer width = 498
integer height = 280
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre();call super::ue_open_pre;is_dataobject = 'nro_libro_dddw'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 3                     // Longitud del campo 1
ii_lc2 = 30							// Longitud del campo 2

end event

type ddlb_2 from u_ddlb within w_cn710_voucher
integer x = 165
integer y = 12
integer width = 631
integer height = 280
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre();call super::ue_open_pre;is_dataobject = 'origen_dddw'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 3                     // Longitud del campo 1
ii_lc2 = 50							 // Longitud del campo 2

end event

type em_2 from editmask within w_cn710_voucher
integer x = 1289
integer y = 12
integer width = 242
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##"
boolean autoskip = true
boolean spin = true
string displaydata = "Enero~t1/Febrero~t2/Marzo~t3/Abril~t4/Mayo~t5/Junio~t6/Julio~t7/Agosto~t8/Setiembre~t9/Octubre~t10/Noviembre~t11/Diciembre~t12/"
double increment = 1
string minmax = "1~~12"
end type

type st_5 from statictext within w_cn710_voucher
integer x = 2181
integer y = 56
integer width = 73
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nº"
boolean focusrectangle = false
end type

type em_3 from editmask within w_cn710_voucher
integer x = 2245
integer y = 12
integer width = 379
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "#####"
double increment = 1
end type

type cb_1 from commandbutton within w_cn710_voucher
integer x = 2638
integer y = 44
integer width = 247
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;Parent.event ue_retrieve()
end event

type em_4 from editmask within w_cn710_voucher
integer x = 2249
integer y = 96
integer width = 375
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

