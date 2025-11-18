$PBExportHeader$w_cn730_cntbl_rpt_libro_mayor.srw
forward
global type w_cn730_cntbl_rpt_libro_mayor from w_report_smpl
end type
type cb_1 from commandbutton within w_cn730_cntbl_rpt_libro_mayor
end type
type sle_cuenta_desde from singlelineedit within w_cn730_cntbl_rpt_libro_mayor
end type
type sle_cuenta_hasta from singlelineedit within w_cn730_cntbl_rpt_libro_mayor
end type
type cb_4 from commandbutton within w_cn730_cntbl_rpt_libro_mayor
end type
type cb_5 from commandbutton within w_cn730_cntbl_rpt_libro_mayor
end type
type st_3 from statictext within w_cn730_cntbl_rpt_libro_mayor
end type
type st_4 from statictext within w_cn730_cntbl_rpt_libro_mayor
end type
type sle_ano from singlelineedit within w_cn730_cntbl_rpt_libro_mayor
end type
type sle_mes_desde from singlelineedit within w_cn730_cntbl_rpt_libro_mayor
end type
type st_10 from statictext within w_cn730_cntbl_rpt_libro_mayor
end type
type st_11 from statictext within w_cn730_cntbl_rpt_libro_mayor
end type
type st_1 from statictext within w_cn730_cntbl_rpt_libro_mayor
end type
type sle_mes_hasta from singlelineedit within w_cn730_cntbl_rpt_libro_mayor
end type
type gb_1 from groupbox within w_cn730_cntbl_rpt_libro_mayor
end type
type gb_12 from groupbox within w_cn730_cntbl_rpt_libro_mayor
end type
end forward

global type w_cn730_cntbl_rpt_libro_mayor from w_report_smpl
integer width = 3479
integer height = 1604
string title = "Reporte del Libro Mayor (CN730)"
string menuname = "m_abc_report_smpl"
cb_1 cb_1
sle_cuenta_desde sle_cuenta_desde
sle_cuenta_hasta sle_cuenta_hasta
cb_4 cb_4
cb_5 cb_5
st_3 st_3
st_4 st_4
sle_ano sle_ano
sle_mes_desde sle_mes_desde
st_10 st_10
st_11 st_11
st_1 st_1
sle_mes_hasta sle_mes_hasta
gb_1 gb_1
gb_12 gb_12
end type
global w_cn730_cntbl_rpt_libro_mayor w_cn730_cntbl_rpt_libro_mayor

on w_cn730_cntbl_rpt_libro_mayor.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.sle_cuenta_desde=create sle_cuenta_desde
this.sle_cuenta_hasta=create sle_cuenta_hasta
this.cb_4=create cb_4
this.cb_5=create cb_5
this.st_3=create st_3
this.st_4=create st_4
this.sle_ano=create sle_ano
this.sle_mes_desde=create sle_mes_desde
this.st_10=create st_10
this.st_11=create st_11
this.st_1=create st_1
this.sle_mes_hasta=create sle_mes_hasta
this.gb_1=create gb_1
this.gb_12=create gb_12
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_cuenta_desde
this.Control[iCurrent+3]=this.sle_cuenta_hasta
this.Control[iCurrent+4]=this.cb_4
this.Control[iCurrent+5]=this.cb_5
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.sle_ano
this.Control[iCurrent+9]=this.sle_mes_desde
this.Control[iCurrent+10]=this.st_10
this.Control[iCurrent+11]=this.st_11
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.sle_mes_hasta
this.Control[iCurrent+14]=this.gb_1
this.Control[iCurrent+15]=this.gb_12
end on

on w_cn730_cntbl_rpt_libro_mayor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_cuenta_desde)
destroy(this.sle_cuenta_hasta)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.sle_ano)
destroy(this.sle_mes_desde)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.st_1)
destroy(this.sle_mes_hasta)
destroy(this.gb_1)
destroy(this.gb_12)
end on

event ue_retrieve;call super::ue_retrieve;String 	ls_ano, ls_mes_desde, ls_mes_hasta, ls_nom_empresa
String 	ls_cuenta_desde, ls_cuenta_hasta, ls_nombre_mes_desde, ls_nombre_mes_hasta
Integer	li_year, li_mes1, li_mes2, li_pos


ls_cuenta_desde = String(sle_cuenta_desde.text)
ls_cuenta_hasta = String(sle_cuenta_hasta.text)

IF gs_empresa = 'FISHOLG' then
	
	ls_ano       = String(sle_ano.text)
	ls_mes_desde = String(sle_mes_desde.text)
	ls_mes_hasta = String(sle_mes_hasta.text)


	DECLARE USP_CNTBL_RPT_LIBRO_MAYOR PROCEDURE FOR 
		USP_CNTBL_RPT_LIBRO_MAYOR( :ls_cuenta_desde, 
											:ls_cuenta_hasta, 
											:ls_mes_desde, 
											:ls_mes_hasta, 
											:ls_ano ) ;
	Execute USP_CNTBL_RPT_LIBRO_MAYOR ;
	
	if gnvo_app.of_ExistsError(SQLCA) then 
		ROLLBACK;
		return
	end if

	dw_report.DataObject = 'd_cntbl_rpt_libro_mayor_fisholg_tbl'
	dw_report.SetTransObject(SQLCA)
	dw_report.object.t_empresa2.text  = gnvo_app.empresa.is_nom_empresa
	
	CLOSE USP_CNTBL_RPT_LIBRO_MAYOR;
	dw_report.retrieve()
else
	li_year  = Integer(sle_ano.text)
	li_mes1 	= Integer(sle_mes_desde.text)
	li_mes2 	= Integer(sle_mes_hasta.text)
	ls_mes_desde = String(sle_mes_desde.text)
	ls_mes_hasta = String(sle_mes_hasta.text)
	
	if len(trim(ls_cuenta_desde)) < len(trim(ls_cuenta_hasta)) then
		li_pos = len(trim(ls_cuenta_desde))
	else
		li_pos = len(trim(ls_cuenta_hasta))
	end if
	
	dw_report.DataObject = 'd_cntbl_rpt_libro_mayor_tbl'
	dw_report.SetTransObject(SQLCA)
	
	dw_report.retrieve(li_year, li_mes1, li_mes2, ls_cuenta_desde, ls_cuenta_hasta, li_pos)
	
	dw_report.object.t_year.text    	= string(li_year, '0000')
	
end if

CHOOSE CASE ls_mes_desde
		
	CASE '0'
		  ls_nombre_mes_desde = 'MES CERO'
	CASE '01'
		  ls_nombre_mes_desde = '01 ENERO'
	CASE '02'
		  ls_nombre_mes_desde = '02 FEBRERO'
	CASE '03'
		  ls_nombre_mes_desde = '03 MARZO'
	CASE '04'
		  ls_nombre_mes_desde = '04 ABRIL'
	CASE '05'
		  ls_nombre_mes_desde = '05 MAYO'
	CASE '06'
		  ls_nombre_mes_desde = '06 JUNIO'
	CASE '07'
		  ls_nombre_mes_desde = '07 JULIO'
	CASE '08'
		  ls_nombre_mes_desde = '08 AGOSTO'
	CASE '09'
		  ls_nombre_mes_desde = '09 SEPTIEMBRE'
	CASE '10'
		  ls_nombre_mes_desde = '10 OCTUBRE'
	CASE '11'
		  ls_nombre_mes_desde = '11 NOVIEMBRE'
	CASE '12'
		  ls_nombre_mes_desde = '12 DICIEMBRE'
	CASE '00'
		  ls_nombre_mes_desde = 'MES CERO'
	CASE '1'
		  ls_nombre_mes_desde = '01 ENERO'
	CASE '2'
		  ls_nombre_mes_desde = '02 FEBRERO'
	CASE '3'
		  ls_nombre_mes_desde = '03 MARZO'
	CASE '4'
		  ls_nombre_mes_desde = '04 ABRIL'
	CASE '5'
		  ls_nombre_mes_desde = '05 MAYO'
	CASE '6'
		  ls_nombre_mes_desde = '06 JUNIO'
	CASE '7'
		  ls_nombre_mes_desde = '07 JULIO'
	CASE '8'
		  ls_nombre_mes_desde = '08 AGOSTO'
	CASE '9'
END CHOOSE

CHOOSE CASE ls_mes_hasta
		
	CASE '0'
		  ls_nombre_mes_hasta = 'MES CERO'
	CASE '01'
		  ls_nombre_mes_hasta = '01 ENERO'
	CASE '02'
		  ls_nombre_mes_hasta = '02 FEBRERO'
	CASE '03'
		  ls_nombre_mes_hasta = '03 MARZO'
	CASE '04'
		  ls_nombre_mes_hasta = '04 ABRIL'
	CASE '05'
		  ls_nombre_mes_hasta = '05 MAYO'
	CASE '06'
		  ls_nombre_mes_hasta = '06 JUNIO'
	CASE '07'
		  ls_nombre_mes_hasta = '07 JULIO'
	CASE '08'
		  ls_nombre_mes_hasta = '08 AGOSTO'
	CASE '09'
		  ls_nombre_mes_hasta = '09 SEPTIEMBRE'
	CASE '10'
		  ls_nombre_mes_hasta = '10 OCTUBRE'
	CASE '11'
		  ls_nombre_mes_hasta = '11 NOVIEMBRE'
	CASE '12'
		  ls_nombre_mes_hasta = '12 DICIEMBRE'
	CASE '00'
		  ls_nombre_mes_hasta = 'MES CERO'
	CASE '1'
		  ls_nombre_mes_hasta = '01 ENERO'
	CASE '2'
		  ls_nombre_mes_hasta = '02 FEBRERO'
	CASE '3'
		  ls_nombre_mes_hasta = '03 MARZO'
	CASE '4'
		  ls_nombre_mes_hasta = '04 ABRIL'
	CASE '5'
		  ls_nombre_mes_hasta = '05 MAYO'
	CASE '6'
		  ls_nombre_mes_hasta = '06 JUNIO'
	CASE '7'
		  ls_nombre_mes_hasta = '07 JULIO'
	CASE '8'
		  ls_nombre_mes_hasta = '08 AGOSTO'
	CASE '9'
		  ls_nombre_mes_hasta = '09 SEPTIEMBRE'
END CHOOSE

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text  = gnvo_app.empresa.is_nom_empresa
dw_report.object.t_user.text     = gs_user
dw_report.object.t_ruc.text      = gs_ruc
dw_report.object.t_desde.text    = ls_nombre_mes_desde
dw_report.object.t_hasta.text    = ls_nombre_mes_hasta

ib_preview = false
event ue_preview()
end event

type dw_report from w_report_smpl`dw_report within w_cn730_cntbl_rpt_libro_mayor
integer x = 0
integer y = 216
integer width = 3406
integer height = 1124
integer taborder = 90
string dataobject = "d_cntbl_rpt_libro_mayor_tbl"
end type

type cb_1 from commandbutton within w_cn730_cntbl_rpt_libro_mayor
integer x = 2866
integer y = 72
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

type sle_cuenta_desde from singlelineedit within w_cn730_cntbl_rpt_libro_mayor
integer x = 251
integer y = 76
integer width = 329
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

type sle_cuenta_hasta from singlelineedit within w_cn730_cntbl_rpt_libro_mayor
integer x = 914
integer y = 76
integer width = 329
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

type cb_4 from commandbutton within w_cn730_cntbl_rpt_libro_mayor
integer x = 617
integer y = 76
integer width = 87
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_cntbl_cuentas_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_cuenta_desde.text = sl_param.field_ret[1]
END IF

end event

type cb_5 from commandbutton within w_cn730_cntbl_rpt_libro_mayor
integer x = 1271
integer y = 76
integer width = 87
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_cntbl_cuentas_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_cuenta_hasta.text = sl_param.field_ret[1]
END IF

end event

type st_3 from statictext within w_cn730_cntbl_rpt_libro_mayor
integer x = 64
integer y = 84
integer width = 183
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
string text = "Desde"
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn730_cntbl_rpt_libro_mayor
integer x = 736
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
string text = "Hasta"
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_cn730_cntbl_rpt_libro_mayor
integer x = 1691
integer y = 76
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
borderstyle borderstyle = stylelowered!
end type

type sle_mes_desde from singlelineedit within w_cn730_cntbl_rpt_libro_mayor
integer x = 2226
integer y = 76
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
borderstyle borderstyle = stylelowered!
end type

type st_10 from statictext within w_cn730_cntbl_rpt_libro_mayor
integer x = 1906
integer y = 84
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
long backcolor = 67108864
string text = "Mes Desde"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_11 from statictext within w_cn730_cntbl_rpt_libro_mayor
integer x = 1522
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

type st_1 from statictext within w_cn730_cntbl_rpt_libro_mayor
integer x = 2373
integer y = 84
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
long backcolor = 67108864
string text = "Mes Hasta"
boolean focusrectangle = false
end type

type sle_mes_hasta from singlelineedit within w_cn730_cntbl_rpt_libro_mayor
integer x = 2665
integer y = 76
integer width = 105
integer height = 72
integer taborder = 70
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

type gb_1 from groupbox within w_cn730_cntbl_rpt_libro_mayor
integer width = 1422
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Seleccione Cuenta Contable "
end type

type gb_12 from groupbox within w_cn730_cntbl_rpt_libro_mayor
integer x = 1490
integer width = 1339
integer height = 196
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

