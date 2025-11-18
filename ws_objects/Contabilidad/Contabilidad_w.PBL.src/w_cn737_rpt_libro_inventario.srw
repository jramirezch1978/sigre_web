$PBExportHeader$w_cn737_rpt_libro_inventario.srw
forward
global type w_cn737_rpt_libro_inventario from w_report_smpl
end type
type cb_1 from commandbutton within w_cn737_rpt_libro_inventario
end type
type sle_ano from singlelineedit within w_cn737_rpt_libro_inventario
end type
type sle_mes from singlelineedit within w_cn737_rpt_libro_inventario
end type
type st_10 from statictext within w_cn737_rpt_libro_inventario
end type
type st_11 from statictext within w_cn737_rpt_libro_inventario
end type
type dw_almacen from datawindow within w_cn737_rpt_libro_inventario
end type
type st_1 from statictext within w_cn737_rpt_libro_inventario
end type
type cbx_1 from checkbox within w_cn737_rpt_libro_inventario
end type
type gb_12 from groupbox within w_cn737_rpt_libro_inventario
end type
end forward

global type w_cn737_rpt_libro_inventario from w_report_smpl
integer width = 3735
integer height = 1564
string title = "Libro de inventario al detalle (CN737)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
boolean righttoleft = true
cb_1 cb_1
sle_ano sle_ano
sle_mes sle_mes
st_10 st_10
st_11 st_11
dw_almacen dw_almacen
st_1 st_1
cbx_1 cbx_1
gb_12 gb_12
end type
global w_cn737_rpt_libro_inventario w_cn737_rpt_libro_inventario

on w_cn737_rpt_libro_inventario.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.st_10=create st_10
this.st_11=create st_11
this.dw_almacen=create dw_almacen
this.st_1=create st_1
this.cbx_1=create cbx_1
this.gb_12=create gb_12
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_ano
this.Control[iCurrent+3]=this.sle_mes
this.Control[iCurrent+4]=this.st_10
this.Control[iCurrent+5]=this.st_11
this.Control[iCurrent+6]=this.dw_almacen
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.cbx_1
this.Control[iCurrent+9]=this.gb_12
end on

on w_cn737_rpt_libro_inventario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.dw_almacen)
destroy(this.st_1)
destroy(this.cbx_1)
destroy(this.gb_12)
end on

event ue_retrieve;call super::ue_retrieve;String ls_ano, ls_mes, ls_texto, ls_almacen, ls_nombre_mes
Long ll_ano, ll_mes

ls_ano = String(sle_ano.text)
ls_mes = String(sle_mes.text)
ll_ano = LONG( ls_ano )
ll_mes = LONG( ls_mes )

SetPointer(HourGlass!)

DECLARE PB_USP_CNT_RPT_LIBRO_INVENT_MM2 PROCEDURE FOR USP_CNT_RPT_LIBRO_INVENT_MM2
		  ( :ll_ano, :ll_mes ) ;
Execute PB_USP_CNT_RPT_LIBRO_INVENT_MM2 ;

if cbx_1.checked = true  then
	ls_almacen= '%'
else
	ls_almacen = dw_almacen.object.almacen [dw_almacen.getrow()]
end if

dw_report.retrieve(ls_almacen)

//--
CHOOSE CASE ll_mes
			
	  	CASE 0
			  ls_nombre_mes = 'MES CERO'
		CASE 1
			  ls_nombre_mes = '01 ENERO'
		CASE 2
			  ls_nombre_mes = '02 FEBRERO'
	   CASE 3
			  ls_nombre_mes = '03 MARZO'
      CASE 4
			  ls_nombre_mes = '04 ABRIL'
		CASE 5
			  ls_nombre_mes = '05 MAYO'
	   CASE 6
			  ls_nombre_mes = '06 JUNIO'
		CASE 7
			  ls_nombre_mes = '07 JULIO'
		CASE 8
			  ls_nombre_mes = '08 AGOSTO'
	   CASE 9
			  ls_nombre_mes = '09 SEPTIEMBRE'
	   CASE 10
			  ls_nombre_mes = '10 OCTUBRE'
		CASE 11
			  ls_nombre_mes = '11 NOVIEMBRE'
	   CASE 12
			  ls_nombre_mes = '12 DICIEMBRE'
	END CHOOSE
//--

ls_texto = 'Año ' + ls_ano + ' - Mes ' + ls_nombre_mes

SetPointer(Arrow!)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_texto.text    = ls_texto
dw_report.object.t_ruc.text 		= gs_ruc
dw_report.object.t_user.text     = gs_user

end event

event ue_open_pre;call super::ue_open_pre;dw_almacen.SetTransObject(sqlca)
dw_almacen.retrieve()
end event

type dw_report from w_report_smpl`dw_report within w_cn737_rpt_libro_inventario
integer x = 23
integer y = 276
integer width = 3657
integer height = 1096
integer taborder = 90
string dataobject = "d_rpt_libro_inventario_detalle_tbl"
end type

type cb_1 from commandbutton within w_cn737_rpt_libro_inventario
integer x = 2505
integer y = 108
integer width = 297
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type sle_ano from singlelineedit within w_cn737_rpt_libro_inventario
integer x = 293
integer y = 112
integer width = 192
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cn737_rpt_libro_inventario
integer x = 827
integer y = 112
integer width = 105
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type st_10 from statictext within w_cn737_rpt_libro_inventario
integer x = 581
integer y = 120
integer width = 169
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
string text = "Mes:"
boolean focusrectangle = false
end type

type st_11 from statictext within w_cn737_rpt_libro_inventario
integer x = 123
integer y = 120
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

type dw_almacen from datawindow within w_cn737_rpt_libro_inventario
integer x = 1294
integer y = 108
integer width = 827
integer height = 92
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_almacen"
boolean border = false
boolean livescroll = true
end type

type st_1 from statictext within w_cn737_rpt_libro_inventario
integer x = 992
integer y = 120
integer width = 274
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Almacen :"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_cn737_rpt_libro_inventario
integer x = 2199
integer y = 124
integer width = 302
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = "Todos"
end type

event clicked;if cbx_1.checked = true then 

dw_almacen.enabled=false
else

dw_almacen.enabled=true

end if
end event

type gb_12 from groupbox within w_cn737_rpt_libro_inventario
integer x = 91
integer y = 36
integer width = 2761
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

