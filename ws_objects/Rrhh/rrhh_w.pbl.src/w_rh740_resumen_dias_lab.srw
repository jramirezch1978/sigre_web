$PBExportHeader$w_rh740_resumen_dias_lab.srw
forward
global type w_rh740_resumen_dias_lab from w_report_smpl
end type
type cb_3 from commandbutton within w_rh740_resumen_dias_lab
end type
type em_descripcion from editmask within w_rh740_resumen_dias_lab
end type
type em_origen from editmask within w_rh740_resumen_dias_lab
end type
type cb_procesar from commandbutton within w_rh740_resumen_dias_lab
end type
type gb_2 from groupbox within w_rh740_resumen_dias_lab
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh740_resumen_dias_lab
end type
type em_year from editmask within w_rh740_resumen_dias_lab
end type
type em_mes from editmask within w_rh740_resumen_dias_lab
end type
type st_1 from statictext within w_rh740_resumen_dias_lab
end type
type st_2 from statictext within w_rh740_resumen_dias_lab
end type
type st_nro_reg from statictext within w_rh740_resumen_dias_lab
end type
type st_3 from statictext within w_rh740_resumen_dias_lab
end type
end forward

global type w_rh740_resumen_dias_lab from w_report_smpl
integer width = 3790
integer height = 1500
string title = "[RH740] Resumen de asistencia por tipo de trabajador"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
cb_procesar cb_procesar
gb_2 gb_2
uo_1 uo_1
em_year em_year
em_mes em_mes
st_1 st_1
st_2 st_2
st_nro_reg st_nro_reg
st_3 st_3
end type
global w_rh740_resumen_dias_lab w_rh740_resumen_dias_lab

on w_rh740_resumen_dias_lab.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.cb_procesar=create cb_procesar
this.gb_2=create gb_2
this.uo_1=create uo_1
this.em_year=create em_year
this.em_mes=create em_mes
this.st_1=create st_1
this.st_2=create st_2
this.st_nro_reg=create st_nro_reg
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.cb_procesar
this.Control[iCurrent+5]=this.gb_2
this.Control[iCurrent+6]=this.uo_1
this.Control[iCurrent+7]=this.em_year
this.Control[iCurrent+8]=this.em_mes
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_nro_reg
this.Control[iCurrent+12]=this.st_3
end on

on w_rh740_resumen_dias_lab.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.cb_procesar)
destroy(this.gb_2)
destroy(this.uo_1)
destroy(this.em_year)
destroy(this.em_mes)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_nro_reg)
destroy(this.st_3)
end on

event ue_retrieve;string 	ls_origen, ls_tipo_trabaj
Integer	li_year, li_mes

if trim(em_origen.text) = '' then
	MessageBox('Error', 'Debe especificar un origen valido, por favor verifique!', StopSign!)
	return
end if

ls_origen 	 = trim(em_origen.text) + '%'
li_year		 = Integer(em_year.text)
li_mes		 = Integer(em_mes.text)

ls_tipo_trabaj = uo_1.of_get_value()

dw_report.SetTransObject(SQLCA)
dw_report.retrieve(ls_origen, ls_tipo_trabaj, li_year, li_mes)

st_nro_reg.text = string(dw_report.RowCount())

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_user.text   	= gs_user

dw_report.object.t_titulo1.text  = 'PERIODO : ' + string(li_year, '0000') + ' ' + string(li_mes, '00')




end event

event ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

//Setear fecha
em_year.text = STRING(f_fecha_actual(),'yyyy')
em_mes.text  = STRING(f_fecha_actual(),'mm')
end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.*),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type dw_report from w_report_smpl`dw_report within w_rh740_resumen_dias_lab
integer x = 0
integer y = 228
integer width = 3689
integer height = 1000
integer taborder = 50
string dataobject = "d_rpt_resumen_dias_lab_tbl"
end type

event dw_report::clicked;call super::clicked;f_select_current_row(this)
end event

event dw_report::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type cb_3 from commandbutton within w_rh740_resumen_dias_lab
integer x = 786
integer y = 72
integer width = 87
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type em_descripcion from editmask within w_rh740_resumen_dias_lab
integer x = 882
integer y = 76
integer width = 759
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh740_resumen_dias_lab
integer x = 640
integer y = 76
integer width = 133
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
alignment alignment = center!
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type cb_procesar from commandbutton within w_rh740_resumen_dias_lab
integer x = 2638
integer width = 352
integer height = 136
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.Event ue_retrieve()
end event

type gb_2 from groupbox within w_rh740_resumen_dias_lab
integer x = 590
integer width = 1097
integer height = 212
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type uo_1 from u_ddlb_tipo_trabajador within w_rh740_resumen_dias_lab
integer x = 1714
integer taborder = 20
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type em_year from editmask within w_rh740_resumen_dias_lab
integer x = 210
integer width = 361
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
boolean spin = true
double increment = 1
string minmax = "2000~~2050"
end type

type em_mes from editmask within w_rh740_resumen_dias_lab
integer x = 210
integer y = 108
integer width = 361
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##"
boolean spin = true
double increment = 1
string minmax = "1~~12"
end type

type st_1 from statictext within w_rh740_resumen_dias_lab
integer x = 46
integer y = 16
integer width = 160
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh740_resumen_dias_lab
integer x = 46
integer y = 124
integer width = 160
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes :"
boolean focusrectangle = false
end type

type st_nro_reg from statictext within w_rh740_resumen_dias_lab
integer x = 3095
integer y = 132
integer width = 206
integer height = 92
boolean bringtotop = true
integer textsize = -9
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

type st_3 from statictext within w_rh740_resumen_dias_lab
integer x = 2624
integer y = 140
integer width = 466
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro _registros ="
boolean focusrectangle = false
end type

