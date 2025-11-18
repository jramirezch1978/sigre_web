$PBExportHeader$w_pr715_horas_x_trabaajdor.srw
forward
global type w_pr715_horas_x_trabaajdor from w_abc_master_smpl
end type
type uo_rango from ou_rango_fechas within w_pr715_horas_x_trabaajdor
end type
type cb_retrieve from commandbutton within w_pr715_horas_x_trabaajdor
end type
type cbx_cuadrillas from checkbox within w_pr715_horas_x_trabaajdor
end type
type sle_cuadrilla from n_cst_textbox within w_pr715_horas_x_trabaajdor
end type
type sle_desc_cuadrilla from singlelineedit within w_pr715_horas_x_trabaajdor
end type
type cbx_trabajadores from checkbox within w_pr715_horas_x_trabaajdor
end type
type sle_trabajador from n_cst_textbox within w_pr715_horas_x_trabaajdor
end type
type sle_nom_trabajador from singlelineedit within w_pr715_horas_x_trabaajdor
end type
type rb_tabular from radiobutton within w_pr715_horas_x_trabaajdor
end type
type rb_consolidado from radiobutton within w_pr715_horas_x_trabaajdor
end type
type gb_1 from groupbox within w_pr715_horas_x_trabaajdor
end type
end forward

global type w_pr715_horas_x_trabaajdor from w_abc_master_smpl
integer width = 3625
integer height = 1956
string title = "[PR715] Resumen de Horas x Trabajador"
string menuname = "m_reporte"
windowstate windowstate = maximized!
event ue_saveas_excel ( )
uo_rango uo_rango
cb_retrieve cb_retrieve
cbx_cuadrillas cbx_cuadrillas
sle_cuadrilla sle_cuadrilla
sle_desc_cuadrilla sle_desc_cuadrilla
cbx_trabajadores cbx_trabajadores
sle_trabajador sle_trabajador
sle_nom_trabajador sle_nom_trabajador
rb_tabular rb_tabular
rb_consolidado rb_consolidado
gb_1 gb_1
end type
global w_pr715_horas_x_trabaajdor w_pr715_horas_x_trabaajdor

event ue_saveas_excel();string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( idw_1, ls_file )
End If
end event

on w_pr715_horas_x_trabaajdor.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_rango=create uo_rango
this.cb_retrieve=create cb_retrieve
this.cbx_cuadrillas=create cbx_cuadrillas
this.sle_cuadrilla=create sle_cuadrilla
this.sle_desc_cuadrilla=create sle_desc_cuadrilla
this.cbx_trabajadores=create cbx_trabajadores
this.sle_trabajador=create sle_trabajador
this.sle_nom_trabajador=create sle_nom_trabajador
this.rb_tabular=create rb_tabular
this.rb_consolidado=create rb_consolidado
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_rango
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.cbx_cuadrillas
this.Control[iCurrent+4]=this.sle_cuadrilla
this.Control[iCurrent+5]=this.sle_desc_cuadrilla
this.Control[iCurrent+6]=this.cbx_trabajadores
this.Control[iCurrent+7]=this.sle_trabajador
this.Control[iCurrent+8]=this.sle_nom_trabajador
this.Control[iCurrent+9]=this.rb_tabular
this.Control[iCurrent+10]=this.rb_consolidado
this.Control[iCurrent+11]=this.gb_1
end on

on w_pr715_horas_x_trabaajdor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_rango)
destroy(this.cb_retrieve)
destroy(this.cbx_cuadrillas)
destroy(this.sle_cuadrilla)
destroy(this.sle_desc_cuadrilla)
destroy(this.cbx_trabajadores)
destroy(this.sle_trabajador)
destroy(this.sle_nom_trabajador)
destroy(this.rb_tabular)
destroy(this.rb_consolidado)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0
end event

event ue_retrieve;call super::ue_retrieve;date 		ld_fecha1, ld_fecha2
String	ls_cuadrilla, ls_trabajador

ld_fecha1 = uo_rango.of_get_fecha1( )
ld_fecha2 = uo_rango.of_get_fecha2( )

if cbx_cuadrillas.checked then
	ls_cuadrilla = '%%'
else
	if trim(sle_cuadrilla.text) = '' then
		MessageBox('Error', 'Debe especificar una cuadrilla, por favor verifique!')
		sle_cuadrilla.SetFocus()
		return
	end if
	ls_cuadrilla = trim(sle_cuadrilla.text) + '%'
end if

if cbx_trabajadores.checked then
	ls_trabajador = '%%'
else
	if trim(sle_trabajador.text) = '' then
		MessageBox('Error', 'Debe especificar un trabajador, por favor verifique!')
		sle_trabajador.SetFocus()
		return
	end if
	ls_trabajador = trim(sle_trabajador.text) + '%'
end if

if rb_consolidado.checked then
	if gs_empresa = 'CANTABRIA' then
		dw_master.DataObject = 'd_rpt_horas_jornal_cantabria_tbl'
	else
		dw_master.DataObject = 'd_rpt_horas_jornal_tbl'
	end if
else
	dw_master.DataObject = 'd_rpt_resumen_x_trab_cst'
end if
dw_master.setTransObject( SQLCA )

dw_master.Retrieve(ld_fecha1, ld_fecha2, ls_cuadrilla, ls_trabajador)

if rb_consolidado.checked then
	dw_master.object.p_logo.filename = gs_logo
	dw_master.object.t_user.text 		= gs_user
	dw_master.object.t_empresa.text 	= gs_empresa
	dw_master.object.t_objeto.text 	= this.ClassName( )
	dw_master.object.t_titulo1.text 	= 'DESDE ' + string(ld_fecha1, 'dd/mm/yyyy') + ' HASTA ' + string(ld_fecha2, 'dd/mm/yyyy')
end if

end event

type dw_master from w_abc_master_smpl`dw_master within w_pr715_horas_x_trabaajdor
integer y = 344
integer width = 3246
integer height = 1316
string dataobject = "d_rpt_resumen_x_trab_cst"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type uo_rango from ou_rango_fechas within w_pr715_horas_x_trabaajdor
integer x = 41
integer y = 76
integer taborder = 40
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type cb_retrieve from commandbutton within w_pr715_horas_x_trabaajdor
integer x = 2656
integer y = 60
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
string text = "Reporte"
end type

event clicked;setPointer(HourGlass!)
parent.event ue_retrieve( )
setPointer(Arrow!)
end event

type cbx_cuadrillas from checkbox within w_pr715_horas_x_trabaajdor
integer x = 27
integer y = 172
integer width = 718
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todas las cuadrillas"
boolean checked = true
boolean righttoleft = true
end type

event clicked;sle_cuadrilla.enabled = not this.checked
end event

type sle_cuadrilla from n_cst_textbox within w_pr715_horas_x_trabaajdor
integer x = 763
integer y = 172
integer width = 439
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
boolean enabled = false
end type

event ue_dobleclick;call super::ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select distinct " &
		 + "       t.cod_cuadrilla as codigo_cuadrilla, " &
		 + "       t.desc_cuadrilla as descripcion_cuadrilla " &
		 + "from tg_cuadrillas t, " &
		 + "     tg_cuadrillas_det td, " &
		 + "     asistencia        a " &
		 + "where t.cod_cuadrilla   = td.cod_cuadrilla " &
		 + "  and td.cod_trabajador = a.cod_trabajador " &
		 + "order by 2   "
				 
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
	this.text 					= ls_codigo
	sle_desc_cuadrilla.text = ls_data
end if

end event

event modified;call super::modified;String 	ls_desc, ls_codigo

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Cuadrilla')
	return
end if

SELECT desc_cuadrilla 
	INTO :ls_desc
FROM TG_CUADRILLAS 
where cod_cuadrilla = :ls_codigo ;


IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Cuadrilla no existe ')
	return
end if

sle_desc_cuadrilla.text = ls_desc

end event

type sle_desc_cuadrilla from singlelineedit within w_pr715_horas_x_trabaajdor
integer x = 1211
integer y = 172
integer width = 987
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cbx_trabajadores from checkbox within w_pr715_horas_x_trabaajdor
integer x = 27
integer y = 248
integer width = 718
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos los trabajadores"
boolean checked = true
boolean righttoleft = true
end type

event clicked;sle_trabajador.enabled = not this.checked
end event

type sle_trabajador from n_cst_textbox within w_pr715_horas_x_trabaajdor
integer x = 763
integer y = 248
integer width = 439
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
boolean enabled = false
end type

event modified;call super::modified;String 	ls_desc, ls_codigo

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Trabajador')
	return
end if

SELECT nom_trabajador 
	INTO :ls_desc
FROM vw_pr_trabajador 
where cod_trabajador = :ls_codigo ;


IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Trabajador no existe ')
	return
end if

sle_nom_trabajador.text = ls_desc

end event

event ue_dobleclick;call super::ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select distinct m.COD_TRABAJADOR as codigo_trabajador, " &
		 + "m.NOM_TRABAJADOR as nombre_trabajador " &
		 + "from PD_JORNAL_CAMPO t, " &
		 + "     vw_pr_trabajador   m " &
		 + "where t.cod_trabajador = m.COD_TRABAJADOR " &
		 + "order by 2   "
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 					= ls_codigo
	sle_nom_trabajador.text = ls_data
end if

end event

type sle_nom_trabajador from singlelineedit within w_pr715_horas_x_trabaajdor
integer x = 1211
integer y = 248
integer width = 987
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type rb_tabular from radiobutton within w_pr715_horas_x_trabaajdor
integer x = 2267
integer y = 72
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Tabular"
boolean checked = true
end type

type rb_consolidado from radiobutton within w_pr715_horas_x_trabaajdor
integer x = 2267
integer y = 152
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Consolidado"
end type

type gb_1 from groupbox within w_pr715_horas_x_trabaajdor
integer width = 3127
integer height = 332
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Parametros del Reporte"
end type

