$PBExportHeader$w_cn503_cntbl_cns_balance_comprob.srw
forward
global type w_cn503_cntbl_cns_balance_comprob from w_cns
end type
type sle_mes_hasta from singlelineedit within w_cn503_cntbl_cns_balance_comprob
end type
type st_1 from statictext within w_cn503_cntbl_cns_balance_comprob
end type
type st_7 from statictext within w_cn503_cntbl_cns_balance_comprob
end type
type ddlb_1 from dropdownlistbox within w_cn503_cntbl_cns_balance_comprob
end type
type st_4 from statictext within w_cn503_cntbl_cns_balance_comprob
end type
type st_3 from statictext within w_cn503_cntbl_cns_balance_comprob
end type
type cb_1 from commandbutton within w_cn503_cntbl_cns_balance_comprob
end type
type sle_mes_desde from singlelineedit within w_cn503_cntbl_cns_balance_comprob
end type
type sle_ano from singlelineedit within w_cn503_cntbl_cns_balance_comprob
end type
type dw_master from u_dw_cns within w_cn503_cntbl_cns_balance_comprob
end type
type gb_1 from groupbox within w_cn503_cntbl_cns_balance_comprob
end type
end forward

global type w_cn503_cntbl_cns_balance_comprob from w_cns
integer width = 3063
integer height = 1588
string title = "Consulta de Balance de Comprobación (CN503)"
string menuname = "m_abc_report_smpl"
sle_mes_hasta sle_mes_hasta
st_1 st_1
st_7 st_7
ddlb_1 ddlb_1
st_4 st_4
st_3 st_3
cb_1 cb_1
sle_mes_desde sle_mes_desde
sle_ano sle_ano
dw_master dw_master
gb_1 gb_1
end type
global w_cn503_cntbl_cns_balance_comprob w_cn503_cntbl_cns_balance_comprob

on w_cn503_cntbl_cns_balance_comprob.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_mes_hasta=create sle_mes_hasta
this.st_1=create st_1
this.st_7=create st_7
this.ddlb_1=create ddlb_1
this.st_4=create st_4
this.st_3=create st_3
this.cb_1=create cb_1
this.sle_mes_desde=create sle_mes_desde
this.sle_ano=create sle_ano
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_mes_hasta
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_7
this.Control[iCurrent+4]=this.ddlb_1
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.sle_mes_desde
this.Control[iCurrent+9]=this.sle_ano
this.Control[iCurrent+10]=this.dw_master
this.Control[iCurrent+11]=this.gb_1
end on

on w_cn503_cntbl_cns_balance_comprob.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_mes_hasta)
destroy(this.st_1)
destroy(this.st_7)
destroy(this.ddlb_1)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.sle_mes_desde)
destroy(this.sle_ano)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_retrieve_list;call super::ue_retrieve_list;String ls_ano, ls_mes_desde, ls_mes_hasta, ls_moneda, ls_mensaje

ls_moneda    = upper(ddlb_1.Text)
ls_ano       = String(sle_ano.text)
ls_mes_desde = String(sle_mes_desde.text)
ls_mes_hasta = String(sle_mes_hasta.text)

dw_master.SetTransObject(sqlca)
DECLARE USP_CNTBL_CNS_BALANCE_COMPROB PROCEDURE FOR 
	USP_CNTBL_CNS_BALANCE_COMPROB( 	:ls_mes_desde, 
												:ls_mes_hasta, 
												:ls_ano, 
												:ls_moneda ) ;
Execute USP_CNTBL_CNS_BALANCE_COMPROB ;

IF sqlca.SQLCode = -1 then
	ls_mensaje = SQLCA.SQLErrtext
	ROLLBACK;
	messageBox('Error en USP_CNTBL_CNS_BALANCE_COMPROB', ls_mensaje)
	return
end if

CLOSE USP_CNTBL_CNS_BALANCE_COMPROB;

dw_master.of_set_split(dw_master.of_get_column_end('descripcion'))
dw_master.retrieve()

end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_master          		// asignar dw corriente

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

type sle_mes_hasta from singlelineedit within w_cn503_cntbl_cns_balance_comprob
integer x = 1595
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

type st_1 from statictext within w_cn503_cntbl_cns_balance_comprob
integer x = 1303
integer y = 132
integer width = 274
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

type st_7 from statictext within w_cn503_cntbl_cns_balance_comprob
integer x = 1737
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

type ddlb_1 from dropdownlistbox within w_cn503_cntbl_cns_balance_comprob
integer x = 2002
integer y = 124
integer width = 215
integer height = 352
integer taborder = 40
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

type st_4 from statictext within w_cn503_cntbl_cns_balance_comprob
integer x = 453
integer y = 132
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

type st_3 from statictext within w_cn503_cntbl_cns_balance_comprob
integer x = 837
integer y = 132
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
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cn503_cntbl_cns_balance_comprob
integer x = 2363
integer y = 124
integer width = 265
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;this.enabled = false
Parent.Event ue_retrieve_list()
this.enabled = true
end event

type sle_mes_desde from singlelineedit within w_cn503_cntbl_cns_balance_comprob
integer x = 1157
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

type sle_ano from singlelineedit within w_cn503_cntbl_cns_balance_comprob
integer x = 622
integer y = 124
integer width = 192
integer height = 76
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

type dw_master from u_dw_cns within w_cn503_cntbl_cns_balance_comprob
integer x = 9
integer y = 284
integer width = 3003
integer height = 1080
integer taborder = 0
string dataobject = "d_cntbl_cns_balance1_tbl"
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = false
end type

event constructor;call super::constructor;// Asignacion de variable sin efecto alguno
ii_ck[1] = 1   //Columna de lectura del dw.

end event

event doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cnta_cntbl_2"  
		lstr_1.DataObject = 'd_cntbl_cns_balance2_tbl'
		lstr_1.Width = 3050
		lstr_1.Height= 1510
		lstr_1.Title = 'Detalle de las Cuentas de Dos Dígitos'
		lstr_1.Arg[1] = GetItemString(row,'cnta_cntbl_2')
		lstr_1.Arg[2] = ''
		lstr_1.Arg[3] = ''
		lstr_1.Arg[4] = ''
		lstr_1.Arg[5] = ''
		lstr_1.Arg[6] = ''
		lstr_1.NextCol = 'cnta_cntbl'
		of_new_sheet(lstr_1)
END CHOOSE
end event

type gb_1 from groupbox within w_cn503_cntbl_cns_balance_comprob
integer x = 416
integer y = 52
integer width = 1874
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Seleccione Parámetros Contables "
borderstyle borderstyle = styleraised!
end type

