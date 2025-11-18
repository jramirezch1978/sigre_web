$PBExportHeader$w_fi511_cns_inconsistencias_pdb.srw
forward
global type w_fi511_cns_inconsistencias_pdb from w_cns
end type
type pb_3 from picturebutton within w_fi511_cns_inconsistencias_pdb
end type
type pb_2 from picturebutton within w_fi511_cns_inconsistencias_pdb
end type
type em_year from editmask within w_fi511_cns_inconsistencias_pdb
end type
type ddlb_mes from dropdownlistbox within w_fi511_cns_inconsistencias_pdb
end type
type st_3 from statictext within w_fi511_cns_inconsistencias_pdb
end type
type st_2 from statictext within w_fi511_cns_inconsistencias_pdb
end type
type pb_1 from picturebutton within w_fi511_cns_inconsistencias_pdb
end type
type dw_1 from u_dw_cns within w_fi511_cns_inconsistencias_pdb
end type
type gb_1 from groupbox within w_fi511_cns_inconsistencias_pdb
end type
end forward

global type w_fi511_cns_inconsistencias_pdb from w_cns
integer width = 2734
integer height = 1828
string title = "(FI510) Documentos en planillas de cobranza"
string menuname = "m_consulta"
pb_3 pb_3
pb_2 pb_2
em_year em_year
ddlb_mes ddlb_mes
st_3 st_3
st_2 st_2
pb_1 pb_1
dw_1 dw_1
gb_1 gb_1
end type
global w_fi511_cns_inconsistencias_pdb w_fi511_cns_inconsistencias_pdb

on w_fi511_cns_inconsistencias_pdb.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.pb_3=create pb_3
this.pb_2=create pb_2
this.em_year=create em_year
this.ddlb_mes=create ddlb_mes
this.st_3=create st_3
this.st_2=create st_2
this.pb_1=create pb_1
this.dw_1=create dw_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_3
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.em_year
this.Control[iCurrent+4]=this.ddlb_mes
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.dw_1
this.Control[iCurrent+9]=this.gb_1
end on

on w_fi511_cns_inconsistencias_pdb.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.em_year)
destroy(this.ddlb_mes)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.pb_1)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_1.SetTransObject( sqlca)
em_year.text 	= string(Today(), 'yyyy')
ddlb_mes.text 	= string(Today(), 'mm')
end event

event resize;call super::resize;dw_1.width  = newwidth  - dw_1.x - 10
dw_1.height = newheight - dw_1.y - 10
end event

event ue_retrieve_list;call super::ue_retrieve_list;String 	ls_mes, ls_year

ls_mes  = left(ddlb_mes.text,2)
ls_year = em_year.text

dw_1.Retrieve(ls_year, ls_mes )
end event

type pb_3 from picturebutton within w_fi511_cns_inconsistencias_pdb
integer x = 1952
integer y = 48
integer width = 306
integer height = 148
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Save!"
alignment htextalign = left!
end type

event clicked;dw_1.saveas()
end event

type pb_2 from picturebutton within w_fi511_cns_inconsistencias_pdb
integer x = 2281
integer y = 48
integer width = 306
integer height = 148
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Print!"
alignment htextalign = left!
end type

event clicked;dw_1.print()
end event

type em_year from editmask within w_fi511_cns_inconsistencias_pdb
integer x = 288
integer y = 84
integer width = 448
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean autoskip = true
boolean spin = true
double increment = 1
string minmax = "1900~~3000"
end type

type ddlb_mes from dropdownlistbox within w_fi511_cns_inconsistencias_pdb
integer x = 978
integer y = 88
integer width = 448
integer height = 388
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"01-Enero","02-Febrero","03-Marzo","04-Abril","05-Mayo","06-Junio","07-Julio","08-Agosto","09-Setiembre","10-Octubre","11-Noviembre","12-Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_fi511_cns_inconsistencias_pdb
integer x = 814
integer y = 108
integer width = 137
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_fi511_cns_inconsistencias_pdb
integer x = 119
integer y = 100
integer width = 137
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_fi511_cns_inconsistencias_pdb
integer x = 1618
integer y = 48
integer width = 306
integer height = 148
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\procesar_enb.bmp"
alignment htextalign = left!
end type

event clicked;parent.event ue_retrieve_list( )
end event

type dw_1 from u_dw_cns within w_fi511_cns_inconsistencias_pdb
integer x = 32
integer y = 272
integer width = 2624
integer height = 712
integer taborder = 50
string dataobject = "d_cns_inconsistencias_pdb_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1 
end event

type gb_1 from groupbox within w_fi511_cns_inconsistencias_pdb
integer x = 78
integer y = 20
integer width = 1431
integer height = 200
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Periodo a Mostrar"
end type

