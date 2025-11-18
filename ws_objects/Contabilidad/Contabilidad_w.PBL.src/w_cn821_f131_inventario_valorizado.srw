$PBExportHeader$w_cn821_f131_inventario_valorizado.srw
forward
global type w_cn821_f131_inventario_valorizado from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn821_f131_inventario_valorizado
end type
type sle_mes from singlelineedit within w_cn821_f131_inventario_valorizado
end type
type cb_1 from commandbutton within w_cn821_f131_inventario_valorizado
end type
type st_3 from statictext within w_cn821_f131_inventario_valorizado
end type
type st_4 from statictext within w_cn821_f131_inventario_valorizado
end type
type cbx_fecha from checkbox within w_cn821_f131_inventario_valorizado
end type
type st_1 from statictext within w_cn821_f131_inventario_valorizado
end type
type sle_metodo from singlelineedit within w_cn821_f131_inventario_valorizado
end type
type st_2 from statictext within w_cn821_f131_inventario_valorizado
end type
type sle_tipo_existencia from singlelineedit within w_cn821_f131_inventario_valorizado
end type
type st_desc_existencia from statictext within w_cn821_f131_inventario_valorizado
end type
type cbx_all from checkbox within w_cn821_f131_inventario_valorizado
end type
type gb_1 from groupbox within w_cn821_f131_inventario_valorizado
end type
end forward

global type w_cn821_f131_inventario_valorizado from w_report_smpl
integer width = 3369
integer height = 1604
string title = "[CN821] Formato 13.1. Registro de Inventario Permanente Valorizado"
string menuname = "m_abc_report_smpl"
sle_ano sle_ano
sle_mes sle_mes
cb_1 cb_1
st_3 st_3
st_4 st_4
cbx_fecha cbx_fecha
st_1 st_1
sle_metodo sle_metodo
st_2 st_2
sle_tipo_existencia sle_tipo_existencia
st_desc_existencia st_desc_existencia
cbx_all cbx_all
gb_1 gb_1
end type
global w_cn821_f131_inventario_valorizado w_cn821_f131_inventario_valorizado

on w_cn821_f131_inventario_valorizado.create
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
this.sle_metodo=create sle_metodo
this.st_2=create st_2
this.sle_tipo_existencia=create sle_tipo_existencia
this.st_desc_existencia=create st_desc_existencia
this.cbx_all=create cbx_all
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.cbx_fecha
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.sle_metodo
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.sle_tipo_existencia
this.Control[iCurrent+11]=this.st_desc_existencia
this.Control[iCurrent+12]=this.cbx_all
this.Control[iCurrent+13]=this.gb_1
end on

on w_cn821_f131_inventario_valorizado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cbx_fecha)
destroy(this.st_1)
destroy(this.sle_metodo)
destroy(this.st_2)
destroy(this.sle_tipo_existencia)
destroy(this.st_desc_existencia)
destroy(this.cbx_all)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_mensaje, ls_nombre_mes, ls_tipo_existencia
Long 		ll_ano, ll_mes

try 
	ll_ano = long(sle_ano.text)
	ll_mes = long(sle_mes.text)
	
	if cbx_all.checked then
		ls_tipo_existencia = '%%'
	else
		ls_tipo_existencia = trim(sle_tipo_existencia.text) + '%'
	end if
	
	gnvo_app.of_set_parametro("METODO_EVALUACION_" + sle_ano.text, sle_metodo.text)
	
	dw_report.object.DataWindow.print.Orientation = 1
	dw_report.object.DataWindow.print.Paper.Size = 9
	
	dw_report.retrieve(ll_ano, ll_mes, ls_tipo_existencia)
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
	
	dw_report.object.p_logo.filename 			= gs_logo
	dw_report.object.t_user.text     			= gs_user
	dw_report.object.t_periodo.text  			= string(ll_ano) + '-' + ls_nombre_mes
	dw_report.object.t_ruc.text      			= gnvo_app.empresa.is_ruc
	dw_report.object.t_razon_social.text 		= gnvo_app.empresa.is_nom_empresa
	dw_report.object.t_metodo_evaluacion.text = sle_metodo.text

catch ( Exception ex )
	
	MessageBox('Error', 'Ha ocurrido una excepción, por favor revisarla: ' + ex.getMessage())
	
end try




end event

event ue_open_pre;call super::ue_open_pre;
try 
	sle_ano.text = string(gnvo_app.of_fecha_Actual(), 'yyyy')
	sle_mes.text = string(gnvo_app.of_fecha_Actual(), 'mm')
	
	sle_metodo.text = gnvo_app.of_get_parametro( "METODO_EVALUACION_" + sle_ano.text, "Metodo del precio promedio")
	
catch ( Exception ex )
	
	MessageBox('Error', 'ha ocurrido una excepción por favor revisarla: ' + ex.getMessage())
	
end try
end event

type dw_report from w_report_smpl`dw_report within w_cn821_f131_inventario_valorizado
integer x = 0
integer y = 336
integer width = 3291
integer height = 1020
integer taborder = 40
string dataobject = "d_f131_inventario_valorizado_tbl"
end type

type sle_ano from singlelineedit within w_cn821_f131_inventario_valorizado
integer x = 201
integer y = 64
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

type sle_mes from singlelineedit within w_cn821_f131_inventario_valorizado
integer x = 576
integer y = 64
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

type cb_1 from commandbutton within w_cn821_f131_inventario_valorizado
integer x = 2222
integer y = 56
integer width = 297
integer height = 92
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

event clicked;setPointer(Hourglass!)
Parent.Event ue_retrieve()
setPointer(Arrow!)

end event

type st_3 from statictext within w_cn821_f131_inventario_valorizado
integer x = 411
integer y = 72
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

type st_4 from statictext within w_cn821_f131_inventario_valorizado
integer x = 37
integer y = 72
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

type cbx_fecha from checkbox within w_cn821_f131_inventario_valorizado
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
	dw_report.object.t_Fecha.visible = '0'
	dw_report.object.t_paginas.visible = '0'
	dw_report.object.t_user.visible = '0'
else
	dw_report.object.t_Fecha.visible = 'yes'
	dw_report.object.t_paginas.visible = 'yes'
	dw_report.object.t_user.visible = 'yes'
end if

end event

type st_1 from statictext within w_cn821_f131_inventario_valorizado
integer x = 69
integer y = 240
integer width = 567
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Metodo de Evaluación:"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_metodo from singlelineedit within w_cn821_f131_inventario_valorizado
integer x = 645
integer y = 232
integer width = 2107
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_cn821_f131_inventario_valorizado
integer x = 146
integer y = 152
integer width = 489
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
string text = "Tipo de Existencia :"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_tipo_existencia from singlelineedit within w_cn821_f131_inventario_valorizado
event ue_dobleclick pbm_lbuttondblclk
integer x = 649
integer y = 144
integer width = 247
integer height = 72
integer taborder = 30
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

ls_sql = "select t.codigo as codigo, " &
		 + "t.descripcion as desc_tipo_existencia " &
		 + "from sunat_tabla5 t " &
		 + "where flag_estado = '1'" 
				 
		
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	
	this.text 			= ls_codigo
	st_desc_existencia.text = ls_data
end if

end event

type st_desc_existencia from statictext within w_cn821_f131_inventario_valorizado
integer x = 905
integer y = 144
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

type cbx_all from checkbox within w_cn821_f131_inventario_valorizado
integer x = 1682
integer y = 140
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
	sle_tipo_Existencia.Text = ''
	sle_tipo_Existencia.Enabled = false
else
	sle_tipo_Existencia.Enabled = true
end if

end event

type gb_1 from groupbox within w_cn821_f131_inventario_valorizado
integer width = 2811
integer height = 328
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

