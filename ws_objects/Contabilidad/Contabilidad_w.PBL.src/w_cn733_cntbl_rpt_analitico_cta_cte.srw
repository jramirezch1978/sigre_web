$PBExportHeader$w_cn733_cntbl_rpt_analitico_cta_cte.srw
forward
global type w_cn733_cntbl_rpt_analitico_cta_cte from w_report_smpl
end type
type cb_1 from commandbutton within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type sle_codigo_desde from singlelineedit within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type sle_codigo_hasta from singlelineedit within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type cb_2 from commandbutton within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type rb_1 from radiobutton within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type rb_2 from radiobutton within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type rb_3 from radiobutton within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type cb_3 from commandbutton within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type st_1 from statictext within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type st_2 from statictext within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type sle_cuenta_desde from singlelineedit within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type sle_cuenta_hasta from singlelineedit within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type cb_4 from commandbutton within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type cb_5 from commandbutton within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type st_3 from statictext within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type st_4 from statictext within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type sle_ano from singlelineedit within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type sle_mesd from singlelineedit within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type st_20 from statictext within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type st_21 from statictext within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type st_6 from statictext within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type sle_mesh from singlelineedit within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type rb_con_quiebre from radiobutton within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type rb_sin_quiebre from radiobutton within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type gb_2 from groupbox within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type gb_3 from groupbox within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type gb_1 from groupbox within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type gb_22 from groupbox within w_cn733_cntbl_rpt_analitico_cta_cte
end type
type gb_4 from groupbox within w_cn733_cntbl_rpt_analitico_cta_cte
end type
end forward

global type w_cn733_cntbl_rpt_analitico_cta_cte from w_report_smpl
integer width = 4270
integer height = 1604
string title = "[CN733] Reporte de Analitico de Cuenta Corriente"
string menuname = "m_abc_report_smpl"
cb_1 cb_1
sle_codigo_desde sle_codigo_desde
sle_codigo_hasta sle_codigo_hasta
cb_2 cb_2
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
cb_3 cb_3
st_1 st_1
st_2 st_2
sle_cuenta_desde sle_cuenta_desde
sle_cuenta_hasta sle_cuenta_hasta
cb_4 cb_4
cb_5 cb_5
st_3 st_3
st_4 st_4
sle_ano sle_ano
sle_mesd sle_mesd
st_20 st_20
st_21 st_21
st_6 st_6
sle_mesh sle_mesh
rb_con_quiebre rb_con_quiebre
rb_sin_quiebre rb_sin_quiebre
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
gb_22 gb_22
gb_4 gb_4
end type
global w_cn733_cntbl_rpt_analitico_cta_cte w_cn733_cntbl_rpt_analitico_cta_cte

type variables


end variables

on w_cn733_cntbl_rpt_analitico_cta_cte.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.sle_codigo_desde=create sle_codigo_desde
this.sle_codigo_hasta=create sle_codigo_hasta
this.cb_2=create cb_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.cb_3=create cb_3
this.st_1=create st_1
this.st_2=create st_2
this.sle_cuenta_desde=create sle_cuenta_desde
this.sle_cuenta_hasta=create sle_cuenta_hasta
this.cb_4=create cb_4
this.cb_5=create cb_5
this.st_3=create st_3
this.st_4=create st_4
this.sle_ano=create sle_ano
this.sle_mesd=create sle_mesd
this.st_20=create st_20
this.st_21=create st_21
this.st_6=create st_6
this.sle_mesh=create sle_mesh
this.rb_con_quiebre=create rb_con_quiebre
this.rb_sin_quiebre=create rb_sin_quiebre
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
this.gb_22=create gb_22
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_codigo_desde
this.Control[iCurrent+3]=this.sle_codigo_hasta
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.rb_2
this.Control[iCurrent+7]=this.rb_3
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.sle_cuenta_desde
this.Control[iCurrent+12]=this.sle_cuenta_hasta
this.Control[iCurrent+13]=this.cb_4
this.Control[iCurrent+14]=this.cb_5
this.Control[iCurrent+15]=this.st_3
this.Control[iCurrent+16]=this.st_4
this.Control[iCurrent+17]=this.sle_ano
this.Control[iCurrent+18]=this.sle_mesd
this.Control[iCurrent+19]=this.st_20
this.Control[iCurrent+20]=this.st_21
this.Control[iCurrent+21]=this.st_6
this.Control[iCurrent+22]=this.sle_mesh
this.Control[iCurrent+23]=this.rb_con_quiebre
this.Control[iCurrent+24]=this.rb_sin_quiebre
this.Control[iCurrent+25]=this.gb_2
this.Control[iCurrent+26]=this.gb_3
this.Control[iCurrent+27]=this.gb_1
this.Control[iCurrent+28]=this.gb_22
this.Control[iCurrent+29]=this.gb_4
end on

on w_cn733_cntbl_rpt_analitico_cta_cte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_codigo_desde)
destroy(this.sle_codigo_hasta)
destroy(this.cb_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.cb_3)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_cuenta_desde)
destroy(this.sle_cuenta_hasta)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.sle_ano)
destroy(this.sle_mesd)
destroy(this.st_20)
destroy(this.st_21)
destroy(this.st_6)
destroy(this.sle_mesh)
destroy(this.rb_con_quiebre)
destroy(this.rb_sin_quiebre)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.gb_22)
destroy(this.gb_4)
end on

event ue_retrieve;call super::ue_retrieve;String 	ls_codigo1, ls_codigo2, ls_cnta_cntbl1, ls_cnta_cntbl2, ls_opcion
Integer	li_year, li_mes1, li_mes2			
			
if rb_1.checked then
	ls_opcion = '1'
elseif rb_2.checked then
	ls_opcion = '2'
elseif rb_3.checked then
	ls_opcion = '3'
else
	MessageBox('Error', 'Debe elegir una opción del reporte', StopSign!)
	return
end if

ls_codigo1 = TRIM(sle_codigo_desde.text)
ls_codigo2 = TRIM(sle_codigo_hasta.text)

ls_cnta_cntbl1 = TRIM(sle_cuenta_desde.text)
ls_cnta_cntbl2 = TRIM(sle_cuenta_hasta.text)

li_year = Integer(sle_ano.text)
li_mes1 = Integer(sle_mesd.text)
li_mes2 = Integer(sle_mesh.text)


IF rb_sin_quiebre.checked = true THEN
	idw_1.DataObject='d_cntbl_rpt_analitico_tbl'
ELSE
	idw_1.DataObject='d_cntbl_rpt_analitico_x_doc_tbl'
END IF
idw_1.SetTransObject(sqlca)

ib_preview = false
triggerevent('ue_preview')


idw_1.retrieve(ls_opcion, li_year, li_mes1, li_mes2, ls_codigo1, ls_codigo2, ls_cnta_cntbl1, ls_cnta_cntbl2)

SetPointer(Arrow!)

//dw_report.retrieve()

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
idw_1.object.t_user.text     = gs_user

end event

event ue_open_pre;call super::ue_open_pre;gb_2.enabled = false
st_1.enabled = false
sle_codigo_desde.enabled = false
cb_2.enabled = false
st_2.enabled = false
sle_codigo_hasta.enabled = false
cb_3.enabled = false

gb_1.enabled = false
st_3.enabled = false
sle_cuenta_desde.enabled = false
cb_4.enabled = false
st_4.enabled = false
sle_cuenta_hasta.enabled = false
cb_5.enabled = false

cb_1.enabled = false

end event

type dw_report from w_report_smpl`dw_report within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 0
integer y = 428
integer width = 3639
integer height = 904
integer taborder = 130
string dataobject = "d_cntbl_rpt_analitico_tbl"
end type

type cb_1 from commandbutton within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 3237
integer y = 272
integer width = 297
integer height = 92
integer taborder = 120
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

type sle_codigo_desde from singlelineedit within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 987
integer y = 76
integer width = 283
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

type sle_codigo_hasta from singlelineedit within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 1591
integer y = 76
integer width = 283
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

type cb_2 from commandbutton within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 1298
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
/*
Sg_parametros sl_param

sl_param.dw1 = "d_cntbl_proveedor_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_codigo_desde.text = sl_param.field_ret[1]
END IF
*/

str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO, '&
										 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRE '&
										 +'FROM PROVEEDOR '
										  
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo_desde.text = lstr_seleccionar.param1[1]
	END IF

end event

type rb_1 from radiobutton within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 55
integer y = 120
integer width = 594
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
string text = "Código y Cuenta"
borderstyle borderstyle = styleraised!
end type

event clicked;gb_2.enabled = true
st_1.enabled = true
sle_codigo_desde.enabled = true
sle_codigo_desde.text = ' '
cb_2.enabled = true
st_2.enabled = true
sle_codigo_hasta.enabled = true
sle_codigo_hasta.text = ' '
cb_3.enabled = true

gb_1.enabled = true
st_3.enabled = true
sle_cuenta_desde.enabled = true
sle_cuenta_desde.text = ' '
cb_4.enabled = true
st_4.enabled = true
sle_cuenta_hasta.enabled = true
sle_cuenta_hasta.text = ' '
cb_5.enabled = true

cb_1.enabled = true

end event

type rb_2 from radiobutton within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 55
integer y = 192
integer width = 594
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
string text = "Código de Relación"
borderstyle borderstyle = styleraised!
end type

event clicked;gb_2.enabled = true
st_1.enabled = true
sle_codigo_desde.enabled = true
sle_codigo_desde.text = ' '
cb_2.enabled = true
st_2.enabled = true
sle_codigo_hasta.enabled = true
sle_codigo_hasta.text = ' '
cb_3.enabled = true

gb_1.enabled = false
st_3.enabled = false
sle_cuenta_desde.enabled = false
sle_cuenta_desde.text = ' '
cb_4.enabled = false
st_4.enabled = false
sle_cuenta_hasta.enabled = false
sle_cuenta_hasta.text = ' '
cb_5.enabled = false

cb_1.enabled = true



end event

type rb_3 from radiobutton within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 55
integer y = 264
integer width = 594
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
string text = "Cuenta Contable"
borderstyle borderstyle = styleraised!
end type

event clicked;gb_2.enabled = false
st_1.enabled = false
sle_codigo_desde.enabled = false
sle_codigo_desde.text = ' '
cb_2.enabled = false
st_2.enabled = false
sle_codigo_hasta.enabled = false
sle_codigo_hasta.text = ' '
cb_3.enabled = false

gb_1.enabled = true
st_3.enabled = true
sle_cuenta_desde.enabled = true
sle_cuenta_desde.text = ' '
cb_4.enabled = true
st_4.enabled = true
sle_cuenta_hasta.enabled = true
sle_cuenta_hasta.text = ' '
cb_5.enabled = true

cb_1.enabled = true

end event

type cb_3 from commandbutton within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 1902
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

event clicked;/*
// Abre ventana de ayuda 

Sg_parametros sl_param

sl_param.dw1 = "d_cntbl_proveedor_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_codigo_hasta.text = sl_param.field_ret[1]
END IF
*/

str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO, '&
										 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRE '&
										 +'FROM PROVEEDOR '
										  
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo_hasta.text = lstr_seleccionar.param1[1]
	END IF

end event

type st_1 from statictext within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 791
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
long backcolor = 67108864
string text = "Desde"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 1422
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
long backcolor = 67108864
string text = "Hasta"
boolean focusrectangle = false
end type

type sle_cuenta_desde from singlelineedit within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 2363
integer y = 76
integer width = 329
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

type sle_cuenta_hasta from singlelineedit within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 3026
integer y = 76
integer width = 329
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

type cb_4 from commandbutton within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 2729
integer y = 76
integer width = 87
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_cnta_cntbl 	lstr_cnta

lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()

if lstr_cnta.b_return = true then
	sle_cuenta_desde.text = lstr_cnta.cnta_cntbl
	sle_cuenta_hasta.Text = lstr_cnta.cnta_cntbl
end if


end event

type cb_5 from commandbutton within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 3383
integer y = 76
integer width = 87
integer height = 72
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_cnta_cntbl 	lstr_cnta

lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()

if lstr_cnta.b_return = true then
	sle_cuenta_hasta.Text = lstr_cnta.cnta_cntbl
end if
end event

type st_3 from statictext within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 2176
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

type st_4 from statictext within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 2848
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

type sle_ano from singlelineedit within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 933
integer y = 284
integer width = 192
integer height = 72
integer taborder = 90
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

type sle_mesd from singlelineedit within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 1477
integer y = 284
integer width = 105
integer height = 72
integer taborder = 100
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

type st_20 from statictext within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 1152
integer y = 292
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
boolean focusrectangle = false
end type

type st_21 from statictext within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 763
integer y = 292
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

type st_6 from statictext within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 1614
integer y = 292
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
string text = "Mes Hasta"
boolean focusrectangle = false
end type

type sle_mesh from singlelineedit within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 1915
integer y = 284
integer width = 105
integer height = 72
integer taborder = 110
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

type rb_con_quiebre from radiobutton within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 2203
integer y = 284
integer width = 430
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
string text = "Con quiebre"
boolean checked = true
end type

type rb_sin_quiebre from radiobutton within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 2702
integer y = 284
integer width = 407
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
string text = "Sin quiebre"
end type

type gb_2 from groupbox within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 727
integer width = 1339
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Seleccione Código de Relación "
end type

type gb_3 from groupbox within w_cn733_cntbl_rpt_analitico_cta_cte
integer y = 52
integer width = 690
integer height = 312
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Opción "
end type

type gb_1 from groupbox within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 2112
integer width = 1422
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Seleccione Cuenta Contable "
end type

type gb_22 from groupbox within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 727
integer y = 212
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

type gb_4 from groupbox within w_cn733_cntbl_rpt_analitico_cta_cte
integer x = 2112
integer y = 212
integer width = 1047
integer height = 196
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Quiebre por documento"
end type

