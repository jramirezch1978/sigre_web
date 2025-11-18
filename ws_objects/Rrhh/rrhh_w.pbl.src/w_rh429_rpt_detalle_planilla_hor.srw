$PBExportHeader$w_rh429_rpt_detalle_planilla_hor.srw
forward
global type w_rh429_rpt_detalle_planilla_hor from w_report_smpl
end type
type cb_3 from commandbutton within w_rh429_rpt_detalle_planilla_hor
end type
type em_descripcion from editmask within w_rh429_rpt_detalle_planilla_hor
end type
type em_origen from editmask within w_rh429_rpt_detalle_planilla_hor
end type
type cb_1 from commandbutton within w_rh429_rpt_detalle_planilla_hor
end type
type em_fec_proceso from editmask within w_rh429_rpt_detalle_planilla_hor
end type
type st_1 from statictext within w_rh429_rpt_detalle_planilla_hor
end type
type gb_2 from groupbox within w_rh429_rpt_detalle_planilla_hor
end type
type uo_2 from u_ddlb_situac_trabajador within w_rh429_rpt_detalle_planilla_hor
end type
type rb_completo from radiobutton within w_rh429_rpt_detalle_planilla_hor
end type
type rb_rpt_simple from radiobutton within w_rh429_rpt_detalle_planilla_hor
end type
type em_desc_tipo from editmask within w_rh429_rpt_detalle_planilla_hor
end type
type em_tipo from editmask within w_rh429_rpt_detalle_planilla_hor
end type
type cb_2 from commandbutton within w_rh429_rpt_detalle_planilla_hor
end type
type st_tipo_planilla from statictext within w_rh429_rpt_detalle_planilla_hor
end type
type em_tipo_planilla from editmask within w_rh429_rpt_detalle_planilla_hor
end type
type cb_tipo_planilla from commandbutton within w_rh429_rpt_detalle_planilla_hor
end type
type em_desc_tipo_planilla from editmask within w_rh429_rpt_detalle_planilla_hor
end type
type st_4 from statictext within w_rh429_rpt_detalle_planilla_hor
end type
type st_3 from statictext within w_rh429_rpt_detalle_planilla_hor
end type
type gb_1 from groupbox within w_rh429_rpt_detalle_planilla_hor
end type
end forward

global type w_rh429_rpt_detalle_planilla_hor from w_report_smpl
integer width = 4731
integer height = 1500
string title = "(RH429) Detalle de Planilla Calculada - Horizontal"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
cb_1 cb_1
em_fec_proceso em_fec_proceso
st_1 st_1
gb_2 gb_2
uo_2 uo_2
rb_completo rb_completo
rb_rpt_simple rb_rpt_simple
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
st_tipo_planilla st_tipo_planilla
em_tipo_planilla em_tipo_planilla
cb_tipo_planilla cb_tipo_planilla
em_desc_tipo_planilla em_desc_tipo_planilla
st_4 st_4
st_3 st_3
gb_1 gb_1
end type
global w_rh429_rpt_detalle_planilla_hor w_rh429_rpt_detalle_planilla_hor

on w_rh429_rpt_detalle_planilla_hor.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.cb_1=create cb_1
this.em_fec_proceso=create em_fec_proceso
this.st_1=create st_1
this.gb_2=create gb_2
this.uo_2=create uo_2
this.rb_completo=create rb_completo
this.rb_rpt_simple=create rb_rpt_simple
this.em_desc_tipo=create em_desc_tipo
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.st_tipo_planilla=create st_tipo_planilla
this.em_tipo_planilla=create em_tipo_planilla
this.cb_tipo_planilla=create cb_tipo_planilla
this.em_desc_tipo_planilla=create em_desc_tipo_planilla
this.st_4=create st_4
this.st_3=create st_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.em_fec_proceso
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.uo_2
this.Control[iCurrent+9]=this.rb_completo
this.Control[iCurrent+10]=this.rb_rpt_simple
this.Control[iCurrent+11]=this.em_desc_tipo
this.Control[iCurrent+12]=this.em_tipo
this.Control[iCurrent+13]=this.cb_2
this.Control[iCurrent+14]=this.st_tipo_planilla
this.Control[iCurrent+15]=this.em_tipo_planilla
this.Control[iCurrent+16]=this.cb_tipo_planilla
this.Control[iCurrent+17]=this.em_desc_tipo_planilla
this.Control[iCurrent+18]=this.st_4
this.Control[iCurrent+19]=this.st_3
this.Control[iCurrent+20]=this.gb_1
end on

on w_rh429_rpt_detalle_planilla_hor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.cb_1)
destroy(this.em_fec_proceso)
destroy(this.st_1)
destroy(this.gb_2)
destroy(this.uo_2)
destroy(this.rb_completo)
destroy(this.rb_rpt_simple)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.st_tipo_planilla)
destroy(this.em_tipo_planilla)
destroy(this.cb_tipo_planilla)
destroy(this.em_desc_tipo_planilla)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string 			ls_origen, ls_tipo_trabaj, ls_mensaje, ls_situac_trabaj, &
					ls_desc_tipo_trabaj, ls_tipo_reporte, ls_tipo_planilla
date 				ld_fec_proceso, ld_fec_inicio, ld_fec_final
str_parametros	lstr_param

ls_origen = string(em_origen.text)
ld_fec_proceso = date(em_fec_proceso.text)

ls_tipo_trabaj = trim(em_tipo.text) + '%'
ls_tipo_planilla = trim(em_tipo_planilla.text) + '%'

ls_situac_trabaj = uo_2.of_get_seleccion()


if rb_completo.checked then
	dw_report.DataObject = 'd_rpt_detalle_planilla_hor_crt'
	dw_report.setTransObject(SQLCA)
	
	// Ejecuto el procedimiento almacenado
	DECLARE USP_RH_RPT_DET_PLLA_CALCULADA PROCEDURE FOR 
		USP_RH_RPT_DET_PLLA_CALCULADA( :ls_origen, 
												 :ls_tipo_trabaj, 
												 :ls_situac_trabaj,
												 :ld_fec_proceso ,
												 :ls_tipo_planilla) ;
	
	EXECUTE USP_RH_RPT_DET_PLLA_CALCULADA ;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error en USP_RH_RPT_DET_PLLA_CALCULADA', ls_mensaje)
		return
	end if
	
	close USP_RH_RPT_DET_PLLA_CALCULADA;
	
	dw_report.retrieve()
	

else
	
	if ls_tipo_trabaj <> '%%' then
		select 	t.fec_inicio, t.fec_final, tt.desc_tipo_tra
			into 	:ld_fec_inicio, :ld_fec_final, :ls_desc_tipo_trabaj
		from 	rrhh_param_org t,
     			tipo_trabajador tt
		where t.tipo_trabajador 	= tt.tipo_trabajador   
		  and trunc(t.fec_proceso) = trunc(:ld_fec_proceso)
		  and t.origen 				= :ls_origen
		  and t.tipo_planilla		like :ls_tipo_planilla;

	end if
	
	if trim(em_tipo.text) = gnvo_app.rrhhparam.is_tipo_tri then
		Open(w_det_planilla_tripultante)
		
		if ISNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return
		
		//Obtengo la referencia al objecto que me han devuelto
		lstr_param = Message.PowerObjectParm
		//Si ha presionado salir entonces cancelo el reporte
		if not lstr_param.b_return then return
		
		if lstr_param.string1 = '1' then
			dw_report.DataObject = 'd_rpt_pla_hor_trip_x_nave_crt'
		else
			if gs_empresa = 'SAKANA' and left(ls_tipo_planilla,1) = 'C' then
				dw_report.DataObject = 'd_rpt_pla_tri_horizontal_simple_cts_crt'
			else
				dw_report.DataObject = 'd_rpt_pla_tri_horizontal_simple_crt'
			end if
		end if
		
	else
		
		dw_report.DataObject = 'd_rpt_pla_horizontal_simple_crt'
		
	end if
	
	dw_report.setTransObject(SQLCA)
	dw_report.retrieve(ls_origen, ls_tipo_Trabaj, ld_fec_proceso, ls_tipo_planilla)
	
	//dw_report.Object.p_logo.filename 	= gs_logo
	//dw_report.Object.t_user.text  		= gs_user
	//dw_report.Object.t_ventana.text  	= this.ClassName()
	dw_report.object.t_stitulo1.Text 	= gnvo_app.empresa.is_nom_empresa + '-' + gnvo_app.empresa.is_ruc
	
	/*if ls_tipo_trabaj <> '%%' then
		if ls_tipo_trabaj = 'JOR%' then
			dw_report.object.t_stitulo2.Text 	= ls_desc_tipo_trabaj + '. FECHAS DEL ' + string(ld_fec_inicio, 'dd/mm/yyy') + ' AL ' + string(ld_fec_final, 'dd/mm/yyyy')
		else
			dw_report.object.t_stitulo2.Text 	= ls_desc_tipo_trabaj + '. PERIODO ' + string(ld_fec_inicio, 'mm/yyy')
		end if
	end if
	*/

end if

dw_report.Object.DataWindow.Print.Orientation = 1
dw_report.Object.DataWindow.Print.Paper.Size = 8


end event

event ue_open_pre;Str_parametros		lstr_param
string	ls_desc_origen, ls_data, ls_desc_tipo_planilla

try 
	idw_1 = dw_report
	idw_1.SetTransObject(sqlca)
	idw_1.Visible = False
	
	
	If not IsNull(Message.PowerObjectparm) and IsValid(Message.Powerobjectparm) then 
		if Message.PowerObjectParm.ClassName() = 'str_parametros' then
			lstr_param = Message.PowerObjectparm
			
			select nombre
				into :ls_desc_origen
			from origen
			where cod_origen = :lstr_param.string1;
			
			select desc_tipo_tra
				into :ls_data
			from tipo_trabajador
			where tipo_trabajador = :lstr_param.string2;
			
			select usp_sigre_rrhh.of_tipo_planilla(:lstr_param.string3)
				into :ls_desc_tipo_planilla
			from dual;
	
			
			em_origen.text 		= lstr_param.string1
			em_descripcion.text 	= ls_desc_origen
			em_tipo.text 			= lstr_param.string2
			em_desc_tipo.text 	= ls_data
			
			em_tipo_planilla.text = lstr_param.string3
			em_desc_tipo_planilla.text = ls_desc_tipo_planilla
			
			
			em_fec_proceso.Text = string(lstr_param.fecha1, 'dd/mm/yyyy')
			
			rb_rpt_simple.checked = true
			
			this.Event ue_retrieve()
			
		end if
	end if
	
	//Activo los controles
	if gnvo_app.of_get_parametro("RRHH_PROCESSING_TIPO_PLANILLA", "0") = "1" OR gs_empresa = "CANTABRIA" then

	
		st_tipo_planilla.visible = true
		em_tipo_planilla.visible = true
		cb_tipo_planilla.visible = true
		em_desc_tipo_planilla.visible = true
		
		st_tipo_planilla.enabled = true
		em_tipo_planilla.enabled = true
		cb_tipo_planilla.enabled = true
		em_desc_tipo_planilla.enabled = true
		
	else
	
		st_tipo_planilla.visible = false
		em_tipo_planilla.visible = false
		cb_tipo_planilla.visible = false
		em_desc_tipo_planilla.visible = false
		
		st_tipo_planilla.enabled = false
		em_tipo_planilla.enabled = false
		cb_tipo_planilla.enabled = false
		em_desc_tipo_planilla.enabled = false
		
	end if
	


catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "")
end try


end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type dw_report from w_report_smpl`dw_report within w_rh429_rpt_detalle_planilla_hor
integer x = 0
integer y = 316
integer width = 3337
integer height = 972
integer taborder = 70
string dataobject = "d_rpt_detalle_planilla_hor_crt"
end type

event dw_report::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type cb_3 from commandbutton within w_rh429_rpt_detalle_planilla_hor
integer x = 672
integer y = 44
integer width = 87
integer height = 76
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

type em_descripcion from editmask within w_rh429_rpt_detalle_planilla_hor
integer x = 759
integer y = 44
integer width = 983
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 255
long backcolor = 15793151
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh429_rpt_detalle_planilla_hor
integer x = 485
integer y = 44
integer width = 183
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_1 from commandbutton within w_rh429_rpt_detalle_planilla_hor
integer x = 3858
integer y = 72
integer width = 293
integer height = 172
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;SetPointer(HourGlass!)
Parent.Event ue_retrieve()
SetPointer(Arrow!)
end event

type em_fec_proceso from editmask within w_rh429_rpt_detalle_planilla_hor
integer x = 2720
integer y = 156
integer width = 448
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type st_1 from statictext within w_rh429_rpt_detalle_planilla_hor
integer x = 2720
integer y = 80
integer width = 448
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha de Proceso"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_rh429_rpt_detalle_planilla_hor
integer x = 3205
integer y = 52
integer width = 640
integer height = 208
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type uo_2 from u_ddlb_situac_trabajador within w_rh429_rpt_detalle_planilla_hor
integer x = 1787
integer y = 44
integer height = 208
integer taborder = 40
end type

on uo_2.destroy
call u_ddlb_situac_trabajador::destroy
end on

type rb_completo from radiobutton within w_rh429_rpt_detalle_planilla_hor
integer x = 3241
integer y = 108
integer width = 535
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Formato Completo"
boolean checked = true
end type

type rb_rpt_simple from radiobutton within w_rh429_rpt_detalle_planilla_hor
integer x = 3241
integer y = 176
integer width = 535
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Formato Simple"
end type

type em_desc_tipo from editmask within w_rh429_rpt_detalle_planilla_hor
integer x = 759
integer y = 128
integer width = 983
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 15793151
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_tipo from editmask within w_rh429_rpt_detalle_planilla_hor
integer x = 485
integer y = 128
integer width = 183
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "%"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh429_rpt_detalle_planilla_hor
integer x = 672
integer y = 128
integer width = 87
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_origen

ls_origen = trim(em_origen.text) + '%'

ls_sql = "SELECT distinct tt.TIPO_TRABAJADOR AS CODIGO_origen, " &
		  + "tt.DESC_TIPO_TRA AS descripcion_tipo " &
		  + "FROM tipo_trabajador tt," &
		  + "     maestro			  m " &
		  + "WHERE m.tipo_Trabajador = tt.tipo_trabajador " &
		  + "  and m.cod_origen like '" + ls_origen + "'" &
		  + "  and m.flag_estado = '1'" &
		  + "  and tt.FLAG_ESTADO = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_tipo.text = ls_codigo
	em_desc_tipo.text = ls_data
end if

end event

type st_tipo_planilla from statictext within w_rh429_rpt_detalle_planilla_hor
boolean visible = false
integer x = 50
integer y = 220
integer width = 379
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean enabled = false
string text = "Tipo Planilla :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_tipo_planilla from editmask within w_rh429_rpt_detalle_planilla_hor
boolean visible = false
integer x = 485
integer y = 212
integer width = 183
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
string text = "N"
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;string ls_data, ls_tipo_planilla, ls_origen

ls_origen = em_origen.text

if IsNull(ls_origen) or trim(ls_origen) = '' then
	gnvo_app.of_message_error("Debe especificar un origen. Por favor verifique!")
	em_origen.setFocus()
	return
end if

ls_tipo_planilla = this.text

select usp_sigre_rrhh.of_tipo_planilla(:ls_tipo_planilla)
	into :ls_data
from dual;

em_desc_tipo_planilla.text = ls_data


end event

type cb_tipo_planilla from commandbutton within w_rh429_rpt_detalle_planilla_hor
boolean visible = false
integer x = 672
integer y = 212
integer width = 87
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_origen, ls_tipo_trabaj
Date		ld_fec_proceso

ls_origen = em_origen.text

if IsNull(ls_origen) or trim(ls_origen) = '' then
	gnvo_app.of_message_error( "Debe especificar primero el origen. Por favor verifique!")
	em_origen.SetFocus()
	return
end if

ls_tipo_trabaj = trim(em_tipo.text) + '%'

ls_sql = "select distinct " &
		 + "       r.tipo_planilla as tipo_planilla, " &
		 + "       usp_sigre_rrhh.of_tipo_planilla(r.tipo_planilla) as desc_tipo_planilla " &
		 + "from rrhh_param_org r " &
		 + "where r.origen = '" + ls_origen + "'" &
		 + "  and r.tipo_trabajador like '" + ls_tipo_trabaj + "'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_tipo_planilla.text = ls_codigo
	em_desc_tipo_planilla.text = ls_data
	


end if
end event

type em_desc_tipo_planilla from editmask within w_rh429_rpt_detalle_planilla_hor
boolean visible = false
integer x = 759
integer y = 212
integer width = 983
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean enabled = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_4 from statictext within w_rh429_rpt_detalle_planilla_hor
integer x = 50
integer y = 136
integer width = 379
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Tipo Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh429_rpt_detalle_planilla_hor
integer x = 50
integer y = 60
integer width = 379
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_rh429_rpt_detalle_planilla_hor
integer width = 4686
integer height = 304
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtro para el reporte"
end type

