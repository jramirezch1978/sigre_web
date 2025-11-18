$PBExportHeader$w_cn818_f12_libro_caja.srw
forward
global type w_cn818_f12_libro_caja from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn818_f12_libro_caja
end type
type sle_mes from singlelineedit within w_cn818_f12_libro_caja
end type
type cb_1 from commandbutton within w_cn818_f12_libro_caja
end type
type st_3 from statictext within w_cn818_f12_libro_caja
end type
type st_4 from statictext within w_cn818_f12_libro_caja
end type
type cbx_fecha from checkbox within w_cn818_f12_libro_caja
end type
type st_1 from statictext within w_cn818_f12_libro_caja
end type
type sle_nro_cnta from singlelineedit within w_cn818_f12_libro_caja
end type
type st_desc_cnta from statictext within w_cn818_f12_libro_caja
end type
type cbx_all from checkbox within w_cn818_f12_libro_caja
end type
type rb_1 from radiobutton within w_cn818_f12_libro_caja
end type
type rb_2 from radiobutton within w_cn818_f12_libro_caja
end type
type gb_1 from groupbox within w_cn818_f12_libro_caja
end type
end forward

global type w_cn818_f12_libro_caja from w_report_smpl
integer width = 3369
integer height = 1604
string title = "[CN818] Formato 1.2. Libro de Caja: Detalle de Mov de Cnta Cte"
string menuname = "m_abc_report_smpl"
sle_ano sle_ano
sle_mes sle_mes
cb_1 cb_1
st_3 st_3
st_4 st_4
cbx_fecha cbx_fecha
st_1 st_1
sle_nro_cnta sle_nro_cnta
st_desc_cnta st_desc_cnta
cbx_all cbx_all
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_cn818_f12_libro_caja w_cn818_f12_libro_caja

on w_cn818_f12_libro_caja.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.cbx_fecha=create cbx_fecha
this.st_1=create st_1
this.sle_nro_cnta=create sle_nro_cnta
this.st_desc_cnta=create st_desc_cnta
this.cbx_all=create cbx_all
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.cbx_fecha
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.sle_nro_cnta
this.Control[iCurrent+9]=this.st_desc_cnta
this.Control[iCurrent+10]=this.cbx_all
this.Control[iCurrent+11]=this.rb_1
this.Control[iCurrent+12]=this.rb_2
this.Control[iCurrent+13]=this.gb_1
end on

on w_cn818_f12_libro_caja.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cbx_fecha)
destroy(this.st_1)
destroy(this.sle_nro_cnta)
destroy(this.st_desc_cnta)
destroy(this.cbx_all)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_mensaje, ls_nombre_mes, ls_nro_cnta
Long 		ll_ano, ll_mes

ll_ano = long(sle_ano.text)
ll_mes = long(sle_mes.text)

if cbx_all.checked then
	ls_nro_cnta = '%%'
else
	ls_nro_cnta = trim(sle_nro_cnta.text) + '%'
end if

if rb_1.checked then
	dw_report.DataObject = 'd_f12_LIBRO_caja_tbl'
else
	dw_report.DataObject = 'd_rpt_mov_caja_bancos_tbl'
end if
dw_report.SetTransObject(SQLCA)

ib_preview = false
event ue_preview()

dw_report.object.DataWindow.print.Orientation = 1
dw_report.object.DataWindow.print.Paper.Size = 9

dw_report.retrieve(ll_ano, ll_mes, ls_nro_cnta)
//--
CHOOSE CASE ll_mes
			
	  	CASE 0
			  ls_nombre_mes = 'MES CERO'
		CASE 1
			  ls_nombre_mes = 'ENERO'
		CASE 2
			  ls_nombre_mes = 'FEBRERO'
	   CASE 3
			  ls_nombre_mes = 'MARZO'
      CASE 4
			  ls_nombre_mes = 'ABRIL'
		CASE 5
			  ls_nombre_mes = 'MAYO'
	   CASE 6
			  ls_nombre_mes = 'JUNIO'
		CASE 7
			  ls_nombre_mes = 'JULIO'
		CASE 8
			  ls_nombre_mes = 'AGOSTO'
	   CASE 9
			  ls_nombre_mes = 'SEPTIEMBRE'
	   CASE 10
			  ls_nombre_mes = 'OCTUBRE'
		CASE 11
			  ls_nombre_mes = 'NOVIEMBRE'
	   CASE 12
			  ls_nombre_mes = 'DICIEMBRE'
	END CHOOSE
//--

dw_report.object.p_logo.filename 		= gs_logo
dw_report.object.t_user.text     		= gs_user
dw_report.object.t_periodo.text  		= string(ll_ano) + '-' + ls_nombre_mes
dw_report.object.t_ruc.text      		= gnvo_app.empresa.is_ruc
dw_report.object.t_razon_social.text 	= gnvo_app.empresa.is_nom_empresa


end event

event ue_open_pre;call super::ue_open_pre;sle_ano.text = string(f_fecha_Actual(), 'yyyy')
sle_mes.text = string(f_fecha_Actual(), 'mm')
end event

type dw_report from w_report_smpl`dw_report within w_cn818_f12_libro_caja
integer x = 0
integer y = 264
integer width = 3291
integer height = 1020
integer taborder = 40
string dataobject = "d_f12_LIBRO_caja_tbl"
end type

type sle_ano from singlelineedit within w_cn818_f12_libro_caja
integer x = 201
integer y = 76
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

type sle_mes from singlelineedit within w_cn818_f12_libro_caja
integer x = 576
integer y = 76
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

type cb_1 from commandbutton within w_cn818_f12_libro_caja
integer x = 2981
integer y = 56
integer width = 297
integer height = 156
integer taborder = 30
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

type st_3 from statictext within w_cn818_f12_libro_caja
integer x = 411
integer y = 84
integer width = 160
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
string text = "Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn818_f12_libro_caja
integer x = 37
integer y = 84
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
long backcolor = 67108864
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_fecha from checkbox within w_cn818_f12_libro_caja
integer x = 763
integer y = 60
integer width = 750
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ocultar Fecha de Impresión"
end type

event clicked;if this.checked then
	dw_report.object.t_fecha.visible 	= '0'
	dw_report.object.t_user.visible 		= '0'
	dw_report.object.t_paginas.visible 	= '0'
else
	dw_report.object.t_fecha.visible 	= 'yes'
	dw_report.object.t_user.visible 		= 'yes'
	dw_report.object.t_paginas.visible 	= 'yes'
end if

end event

type st_1 from statictext within w_cn818_f12_libro_caja
integer x = 32
integer y = 164
integer width = 393
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
string text = "Nro de Cuenta :"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_nro_cnta from singlelineedit within w_cn818_f12_libro_caja
event ue_dobleclick pbm_lbuttondblclk
integer x = 448
integer y = 156
integer width = 448
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select cod_ctabco as codigo_ctabco, " &
		 + "descripcion as desc_ctabco " &
		 + "from banco_cnta bc " &
		 + "where bc.flag_estado = '1'" 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	st_desc_cnta.text = ls_data
end if

end event

type st_desc_cnta from statictext within w_cn818_f12_libro_caja
integer x = 905
integer y = 156
integer width = 759
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cbx_all from checkbox within w_cn818_f12_libro_caja
integer x = 1682
integer y = 152
integer width = 517
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todas las cuentas"
end type

event clicked;if this.checked then
	sle_nro_cnta.Text = ''
	sle_nro_cnta.Enabled = false
else
	sle_nro_cnta.Enabled = true
end if

end event

type rb_1 from radiobutton within w_cn818_f12_libro_caja
integer x = 2263
integer y = 68
integer width = 658
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Formato SUNAT"
boolean checked = true
end type

type rb_2 from radiobutton within w_cn818_f12_libro_caja
integer x = 2263
integer y = 140
integer width = 658
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Soles Y Dolares"
end type

type gb_1 from groupbox within w_cn818_f12_libro_caja
integer width = 3319
integer height = 252
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Periodo Contable "
end type

