$PBExportHeader$w_ve745_utilidad_categ_especies.srw
forward
global type w_ve745_utilidad_categ_especies from w_report_smpl
end type
type cb_1 from commandbutton within w_ve745_utilidad_categ_especies
end type
type rb_1 from radiobutton within w_ve745_utilidad_categ_especies
end type
type rb_2 from radiobutton within w_ve745_utilidad_categ_especies
end type
type st_4 from statictext within w_ve745_utilidad_categ_especies
end type
type sle_ano from singlelineedit within w_ve745_utilidad_categ_especies
end type
type st_3 from statictext within w_ve745_utilidad_categ_especies
end type
type sle_mes1 from singlelineedit within w_ve745_utilidad_categ_especies
end type
type st_1 from statictext within w_ve745_utilidad_categ_especies
end type
type sle_mes2 from singlelineedit within w_ve745_utilidad_categ_especies
end type
type st_2 from statictext within w_ve745_utilidad_categ_especies
end type
type sle_moneda from singlelineedit within w_ve745_utilidad_categ_especies
end type
type gb_fechas from groupbox within w_ve745_utilidad_categ_especies
end type
type gb_2 from groupbox within w_ve745_utilidad_categ_especies
end type
end forward

global type w_ve745_utilidad_categ_especies from w_report_smpl
integer width = 3250
integer height = 2068
string title = "[VE745] Margen de Contribución por Categoría / especies"
string menuname = "m_reporte"
cb_1 cb_1
rb_1 rb_1
rb_2 rb_2
st_4 st_4
sle_ano sle_ano
st_3 st_3
sle_mes1 sle_mes1
st_1 st_1
sle_mes2 sle_mes2
st_2 st_2
sle_moneda sle_moneda
gb_fechas gb_fechas
gb_2 gb_2
end type
global w_ve745_utilidad_categ_especies w_ve745_utilidad_categ_especies

type variables
string is_doc_ov
end variables

on w_ve745_utilidad_categ_especies.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_4=create st_4
this.sle_ano=create sle_ano
this.st_3=create st_3
this.sle_mes1=create sle_mes1
this.st_1=create st_1
this.sle_mes2=create sle_mes2
this.st_2=create st_2
this.sle_moneda=create sle_moneda
this.gb_fechas=create gb_fechas
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.sle_ano
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.sle_mes1
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.sle_mes2
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.sle_moneda
this.Control[iCurrent+12]=this.gb_fechas
this.Control[iCurrent+13]=this.gb_2
end on

on w_ve745_utilidad_categ_especies.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_4)
destroy(this.sle_ano)
destroy(this.st_3)
destroy(this.sle_mes1)
destroy(this.st_1)
destroy(this.sle_mes2)
destroy(this.st_2)
destroy(this.sle_moneda)
destroy(this.gb_fechas)
destroy(this.gb_2)
end on

event ue_retrieve;//Ancestor Overriding
Integer 	li_year, li_mes1, li_mes2
string	ls_moneda

li_year 	= integer(sle_ano.text)
li_mes1	= integer(sle_mes1.text)
li_mes2	= integer(sle_mes2.text)
ls_moneda = sle_moneda.text

if trim(ls_moneda) = '' then
	MessageBox('Error', 'Debe seleccionar la moneda', StopSign!)
	sle_moneda.setFocus()
	return
end if

//Tiene que seleccionar los grupos a partir del super_grupo

if rb_1.checked then
	idw_1.DataObject = 'd_rpt_utlidad_x_categoria_tbl'
elseif rb_2.checked then
	idw_1.DataObject = 'd_rpt_utlidad_x_categoria_tv'
end if

idw_1.setTransobject( SQLCA )

idw_1.Visible = True

idw_1.Retrieve(li_year, li_mes1, li_mes2, ls_moneda)

idw_1.Object.p_logo.filename 	= gs_logo
idw_1.Object.t_empresa.text 	= gs_empresa
idw_1.Object.t_user.text 		= gs_user
idw_1.Object.t_stitulo1.text 	= 'Desde ' + gnvo_app.of_nombre_mes(li_mes1) + ' hasta ' + gnvo_app.of_nombre_mes(li_mes2)

if trim(ls_moneda) = trim(gnvo_app.is_soles) then
	idw_1.Object.t_stitulo2.text 	= 'Moneda NUEVO SOLES'
else
	idw_1.Object.t_stitulo2.text 	= 'Moneda DOLARES AMERICANOS'
end if
//idw_1.Object.Datawindow.Print.Paper.Size = 8


end event

event ue_open_pre;call super::ue_open_pre;sle_ano.text = string(date(gnvo_app.of_fecha_actual( )), 'yyyy')
sle_moneda.text = gnvo_app.is_soles

end event

type dw_report from w_report_smpl`dw_report within w_ve745_utilidad_categ_especies
integer x = 0
integer y = 312
integer width = 3086
integer height = 1512
string dataobject = "d_rpt_utlidad_x_categoria_tbl"
end type

type cb_1 from commandbutton within w_ve745_utilidad_categ_especies
integer x = 1522
integer y = 40
integer width = 402
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;parent.event ue_retrieve( )
end event

type rb_1 from radiobutton within w_ve745_utilidad_categ_especies
integer x = 727
integer y = 64
integer width = 745
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato tabular"
boolean checked = true
end type

type rb_2 from radiobutton within w_ve745_utilidad_categ_especies
integer x = 727
integer y = 136
integer width = 745
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato Agrupado"
end type

type st_4 from statictext within w_ve745_utilidad_categ_especies
integer x = 46
integer y = 68
integer width = 343
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
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_ve745_utilidad_categ_especies
integer x = 421
integer y = 52
integer width = 247
integer height = 76
integer taborder = 40
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

type st_3 from statictext within w_ve745_utilidad_categ_especies
integer x = 46
integer y = 144
integer width = 343
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
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_mes1 from singlelineedit within w_ve745_utilidad_categ_especies
integer x = 421
integer y = 140
integer width = 247
integer height = 72
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

type st_1 from statictext within w_ve745_utilidad_categ_especies
integer x = 46
integer y = 220
integer width = 343
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
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_mes2 from singlelineedit within w_ve745_utilidad_categ_especies
integer x = 421
integer y = 224
integer width = 247
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

type st_2 from statictext within w_ve745_utilidad_categ_especies
integer x = 731
integer y = 212
integer width = 261
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_moneda from singlelineedit within w_ve745_utilidad_categ_especies
event dobleclick pbm_lbuttondblclk
integer x = 1006
integer y = 200
integer width = 233
integer height = 88
integer taborder = 160
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;String ls_sql, ls_data, ls_codigo

ls_sql = "SELECT 	cod_moneda as codigo_moneda, " &
		 + "descripcion as descripcion_moneda " &
		 + "FROM moneda bc " &
		 + "where flag_estado = '1'"
		 
f_lista(ls_sql, ls_codigo, ls_data, "2")

if ls_codigo <> "" then
	this.text = ls_codigo
end if

end event

event modified;String ls_moneda
Long   ll_count


ls_moneda = this.text


select count(*) into :ll_count 
  from moneda 
 where cod_moneda = :ls_moneda ;
 
IF ll_count = 0 THEN
	MessageBox('Aviso', 'El código de moneda no existe, por favor verifique')
//	sle_desc.text = gnvo_app.is_null
END IF
 

end event

type gb_fechas from groupbox within w_ve745_utilidad_categ_especies
integer x = 23
integer y = 4
integer width = 667
integer height = 300
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_ve745_utilidad_categ_especies
integer x = 704
integer y = 4
integer width = 800
integer height = 300
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Reporte"
end type

