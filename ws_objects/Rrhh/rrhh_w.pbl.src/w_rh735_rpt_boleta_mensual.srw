$PBExportHeader$w_rh735_rpt_boleta_mensual.srw
forward
global type w_rh735_rpt_boleta_mensual from w_report_smpl
end type
type cb_1 from commandbutton within w_rh735_rpt_boleta_mensual
end type
type st_3 from statictext within w_rh735_rpt_boleta_mensual
end type
type st_4 from statictext within w_rh735_rpt_boleta_mensual
end type
type st_2 from statictext within w_rh735_rpt_boleta_mensual
end type
type em_tipo_planilla from editmask within w_rh735_rpt_boleta_mensual
end type
type em_tipo from editmask within w_rh735_rpt_boleta_mensual
end type
type cb_2 from commandbutton within w_rh735_rpt_boleta_mensual
end type
type cb_tipo_planilla from commandbutton within w_rh735_rpt_boleta_mensual
end type
type em_desc_tipo_planilla from editmask within w_rh735_rpt_boleta_mensual
end type
type em_desc_tipo from editmask within w_rh735_rpt_boleta_mensual
end type
type em_descripcion from editmask within w_rh735_rpt_boleta_mensual
end type
type cb_3 from commandbutton within w_rh735_rpt_boleta_mensual
end type
type em_origen from editmask within w_rh735_rpt_boleta_mensual
end type
type em_cod_trabajador from editmask within w_rh735_rpt_boleta_mensual
end type
type cb_4 from commandbutton within w_rh735_rpt_boleta_mensual
end type
type em_nom_trabajador from editmask within w_rh735_rpt_boleta_mensual
end type
type st_5 from statictext within w_rh735_rpt_boleta_mensual
end type
type st_6 from statictext within w_rh735_rpt_boleta_mensual
end type
type em_cencos from editmask within w_rh735_rpt_boleta_mensual
end type
type cb_cencos from commandbutton within w_rh735_rpt_boleta_mensual
end type
type em_desc_cencos from editmask within w_rh735_rpt_boleta_mensual
end type
type st_1 from statictext within w_rh735_rpt_boleta_mensual
end type
type sle_year from singlelineedit within w_rh735_rpt_boleta_mensual
end type
type sle_mes from singlelineedit within w_rh735_rpt_boleta_mensual
end type
type cbx_ajuste from checkbox within w_rh735_rpt_boleta_mensual
end type
type gb_1 from groupbox within w_rh735_rpt_boleta_mensual
end type
end forward

global type w_rh735_rpt_boleta_mensual from w_report_smpl
integer width = 5115
integer height = 2152
string title = "[RH735] Boletas de pago mensual"
string menuname = "m_impresion"
cb_1 cb_1
st_3 st_3
st_4 st_4
st_2 st_2
em_tipo_planilla em_tipo_planilla
em_tipo em_tipo
cb_2 cb_2
cb_tipo_planilla cb_tipo_planilla
em_desc_tipo_planilla em_desc_tipo_planilla
em_desc_tipo em_desc_tipo
em_descripcion em_descripcion
cb_3 cb_3
em_origen em_origen
em_cod_trabajador em_cod_trabajador
cb_4 cb_4
em_nom_trabajador em_nom_trabajador
st_5 st_5
st_6 st_6
em_cencos em_cencos
cb_cencos cb_cencos
em_desc_cencos em_desc_cencos
st_1 st_1
sle_year sle_year
sle_mes sle_mes
cbx_ajuste cbx_ajuste
gb_1 gb_1
end type
global w_rh735_rpt_boleta_mensual w_rh735_rpt_boleta_mensual

on w_rh735_rpt_boleta_mensual.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.st_2=create st_2
this.em_tipo_planilla=create em_tipo_planilla
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.cb_tipo_planilla=create cb_tipo_planilla
this.em_desc_tipo_planilla=create em_desc_tipo_planilla
this.em_desc_tipo=create em_desc_tipo
this.em_descripcion=create em_descripcion
this.cb_3=create cb_3
this.em_origen=create em_origen
this.em_cod_trabajador=create em_cod_trabajador
this.cb_4=create cb_4
this.em_nom_trabajador=create em_nom_trabajador
this.st_5=create st_5
this.st_6=create st_6
this.em_cencos=create em_cencos
this.cb_cencos=create cb_cencos
this.em_desc_cencos=create em_desc_cencos
this.st_1=create st_1
this.sle_year=create sle_year
this.sle_mes=create sle_mes
this.cbx_ajuste=create cbx_ajuste
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.em_tipo_planilla
this.Control[iCurrent+6]=this.em_tipo
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.cb_tipo_planilla
this.Control[iCurrent+9]=this.em_desc_tipo_planilla
this.Control[iCurrent+10]=this.em_desc_tipo
this.Control[iCurrent+11]=this.em_descripcion
this.Control[iCurrent+12]=this.cb_3
this.Control[iCurrent+13]=this.em_origen
this.Control[iCurrent+14]=this.em_cod_trabajador
this.Control[iCurrent+15]=this.cb_4
this.Control[iCurrent+16]=this.em_nom_trabajador
this.Control[iCurrent+17]=this.st_5
this.Control[iCurrent+18]=this.st_6
this.Control[iCurrent+19]=this.em_cencos
this.Control[iCurrent+20]=this.cb_cencos
this.Control[iCurrent+21]=this.em_desc_cencos
this.Control[iCurrent+22]=this.st_1
this.Control[iCurrent+23]=this.sle_year
this.Control[iCurrent+24]=this.sle_mes
this.Control[iCurrent+25]=this.cbx_ajuste
this.Control[iCurrent+26]=this.gb_1
end on

on w_rh735_rpt_boleta_mensual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.em_tipo_planilla)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.cb_tipo_planilla)
destroy(this.em_desc_tipo_planilla)
destroy(this.em_desc_tipo)
destroy(this.em_descripcion)
destroy(this.cb_3)
destroy(this.em_origen)
destroy(this.em_cod_trabajador)
destroy(this.cb_4)
destroy(this.em_nom_trabajador)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.em_cencos)
destroy(this.cb_cencos)
destroy(this.em_desc_cencos)
destroy(this.st_1)
destroy(this.sle_year)
destroy(this.sle_mes)
destroy(this.cbx_ajuste)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String  	ls_origen, ls_tiptra, ls_desc_origen, ls_codigo,  ls_cencos, &
			ls_msg, ls_mensaje, ls_flag_ajuste
Integer 	li_msg, li_year, li_mes

try 
	dw_report.reset( )
	
	If isnull(em_origen.text)  Or trim(em_origen.text)  = '' Then 
		MessageBox('Atención','Debe Ingresar el Origen', Information!)
		em_origen.SetFocus()
		return
	end if
	
	
	ls_origen      = trim(em_origen.text) + '%'
	ls_codigo      = trim(em_cod_trabajador.text) + '%'
	ls_desc_origen = trim(em_descripcion.text)
	ls_tiptra 		= trim(em_tipo.text) + '%'
	ls_cencos 		= trim(em_cencos.text) + '%'
	
	li_year			= Integer(sle_year.text)
	li_mes			= Integer(sle_mes.text)
	
	
	If isnull(ls_tiptra)  Or trim(ls_tiptra)  = '' Then ls_tiptra  = '%'
	If isnull(ls_codigo)  Or trim(ls_codigo)  = '' Then ls_codigo  = '%'
	
	if cbx_ajuste.checked then
		ls_flag_ajuste = '1'
	else
		ls_flag_ajuste = '0'
	end if
	
	//pkg_rrhh.sp_ajustar_asig_familiar(ani_year => :ani_year,
	//											ani_mes => :ani_mes,
	//											asi_flag_ajuste => :asi_flag_ajuste);
	
	
	//ejecuto procesos de CIERRE DE PLANILLA
	DECLARE sp_ajustar_asig_familiar PROCEDURE FOR 
		pkg_rrhh.sp_ajustar_asig_familiar(	:li_year ,
														:li_mes ,
														:ls_flag_ajuste);
	
	EXECUTE sp_ajustar_asig_familiar ;
	  
	//busco errores
	if sqlca.sqlcode = -1 then
		ls_mensaje = sqlca.sqlerrtext
		Rollback ;
		Messagebox('SQL Error', 'Error al procesar procedimiento pkg_rrhh.sp_ajustar_asig_familiar(). Mensaje: ' + ls_mensaje)
		Return
	end if	   	  
	  
	CLOSE sp_ajustar_asig_familiar ;
	
	if gnvo_app.of_get_parametro("BOLETAS_POR_CENCOS", "0") = "0" then
		
		//create or replace procedure usp_rh_rpt_boleta_pago_mensual(
		//		 asi_tipo_trabajador in tipo_trabajador.tipo_trabajador%TYPE, 
		//		 asi_origen          in origen.cod_origen%TYPE, 
		//		 asi_codigo          in maestro.cod_trabajador%TYPE,
		//		 ani_year            in number,
		//		 ani_mes             in number
		//) is

		Declare usp_rh_rpt_boleta_pago_mensual PROCEDURE FOR 
			usp_rh_rpt_boleta_pago_mensual ( :ls_tiptra, 
														:ls_origen, 
														:ls_codigo, 
														:li_year,
														:li_mes) ;
		Execute usp_rh_rpt_boleta_pago_mensual ;
		
		IF SQLCA.sqlcode = -1 THEN
			ls_mensaje = "PROCEDURE usp_rh_rpt_boleta_pago_mensual: " + SQLCA.SQLErrText
			Rollback ;
			MessageBox('SQL error', ls_mensaje, StopSign!)	
			return 
		END IF
		
		Close usp_rh_rpt_boleta_pago_mensual;
		
	else
		
		//Filtro por centros de costo
		
		//create or replace procedure usp_rh_rpt_boleta_pago_mensual(
		//		 asi_tipo_trabajador in tipo_trabajador.tipo_trabajador%TYPE, 
		//		 asi_origen          in origen.cod_origen%TYPE, 
		//		 asi_codigo          in maestro.cod_trabajador%TYPE,
		//		 ani_year            in number,
		//		 ani_mes             in number
		//) is

//		Declare usp_rh_rpt_boleta_pago_mensual PROCEDURE FOR 
//			usp_rh_rpt_boleta_pago_mensual ( :ls_tiptra, 
//														:ls_origen, 
//														:ls_codigo, 
//														:li_year,
//														:li_mes) ;
//		Execute usp_rh_rpt_boleta_pago_mensual ;
//		
//		IF SQLCA.sqlcode = -1 THEN
//			ls_mensaje = "PROCEDURE usp_rh_rpt_boleta_pago_mensual: " + SQLCA.SQLErrText
//			Rollback ;
//			MessageBox('SQL error', ls_mensaje, StopSign!)	
//			return 
//		END IF
//		
//		Close usp_rh_rpt_boleta_pago_mensual;
		
	end if
	
	dw_report.setTransObject( SQLCA )
	
	ib_preview = false
	event ue_preview()
	
	dw_report.retrieve()
	dw_report.object.p_logo.filename  = gs_logo
	dw_report.object.t_nombre.text    = ls_desc_origen
	
	if dw_report.of_ExistsPictureName("p_logo1") then
		dw_report.object.p_logo1.filename = gs_logo
	end if
	if dw_report.of_ExistsText("t_nombre1") then
		dw_report.object.t_nombre1.text   = ls_desc_origen
	end if
	
	// Coloco la firma escaneada del representante 
	if gs_firma_digital <> "" then
		if Not FileExists(gs_firma_digital) then
			MessageBox('Error', 'No existe el archivo ' + gs_firma_digital + ", por favor verifique!!", StopSign!)
			return
		end if
		dw_report.object.p_firma.filename  = gs_firma_digital
		
		if dw_report.of_ExistsPictureName("p_firma1") then
			dw_report.object.p_firma1.filename = gs_firma_digital
		end if
		
		
	end if

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Error en generar boletas")
end try

	
end event

event ue_open_pre;call super::ue_open_pre;Str_parametros		lstr_param
string				ls_desc_origen, ls_data, ls_desc_tipo_planilla
Date					ld_hoy

try 
	ld_hoy = Date(gnvo_app.of_fecha_actual())
	
	sle_year.text = string(ld_hoy, 'yyyy')
	sle_mes.text = string(ld_hoy, 'mm')
	
	//Activo los controles
	if gnvo_app.of_get_parametro("RRHH_PROCESSING_TIPO_PLANILLA", "0") = "1" OR gs_empresa = "CANTABRIA" then

	
		st_1.visible = true
		em_tipo_planilla.visible = true
		cb_tipo_planilla.visible = true
		em_desc_tipo_planilla.visible = true
		
		st_1.enabled = true
		em_tipo_planilla.enabled = true
		cb_tipo_planilla.enabled = true
		em_desc_tipo_planilla.enabled = true
		
	else
	
		st_1.visible = false
		em_tipo_planilla.visible = false
		cb_tipo_planilla.visible = false
		em_desc_tipo_planilla.visible = false
		
		st_1.enabled = false
		em_tipo_planilla.enabled = false
		cb_tipo_planilla.enabled = false
		em_desc_tipo_planilla.enabled = false
		
	end if
	
	//Pongo el origen por defecto
	select 
	em_origen.text = gs_origen
	
	
	select USP_SIGRE_RRHH.of_tipo_planilla('N')
		into :ls_desc_tipo_planilla
	from dual;
	
	em_tipo_planilla.text = 'N'
	em_desc_tipo_planilla.text = ls_desc_tipo_planilla
	
	


catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "")
end try


end event

type dw_report from w_report_smpl`dw_report within w_rh735_rpt_boleta_mensual
integer x = 0
integer y = 396
integer width = 3438
integer height = 1444
integer taborder = 60
string dataobject = "d_rpt_boleta_pago_mensual_tbl"
end type

type cb_1 from commandbutton within w_rh735_rpt_boleta_mensual
integer x = 2789
integer y = 128
integer width = 315
integer height = 220
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;setPointer(HourGlass!)
Parent.Event ue_retrieve()
setPointer(Arrow!)
end event

type st_3 from statictext within w_rh735_rpt_boleta_mensual
integer x = 14
integer y = 60
integer width = 466
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

type st_4 from statictext within w_rh735_rpt_boleta_mensual
integer x = 14
integer y = 144
integer width = 466
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

type st_2 from statictext within w_rh735_rpt_boleta_mensual
boolean visible = false
integer x = 14
integer y = 312
integer width = 466
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

type em_tipo_planilla from editmask within w_rh735_rpt_boleta_mensual
boolean visible = false
integer x = 485
integer y = 304
integer width = 283
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
boolean enabled = false
string text = "%"
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

type em_tipo from editmask within w_rh735_rpt_boleta_mensual
integer x = 485
integer y = 136
integer width = 283
integer height = 76
integer taborder = 60
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

type cb_2 from commandbutton within w_rh735_rpt_boleta_mensual
integer x = 773
integer y = 136
integer width = 87
integer height = 76
integer taborder = 70
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

type cb_tipo_planilla from commandbutton within w_rh735_rpt_boleta_mensual
boolean visible = false
integer x = 773
integer y = 304
integer width = 87
integer height = 76
integer taborder = 60
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

type em_desc_tipo_planilla from editmask within w_rh735_rpt_boleta_mensual
boolean visible = false
integer x = 859
integer y = 304
integer width = 983
integer height = 76
integer taborder = 70
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

type em_desc_tipo from editmask within w_rh735_rpt_boleta_mensual
integer x = 859
integer y = 136
integer width = 983
integer height = 76
integer taborder = 80
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

type em_descripcion from editmask within w_rh735_rpt_boleta_mensual
integer x = 859
integer y = 52
integer width = 983
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 15793151
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_3 from commandbutton within w_rh735_rpt_boleta_mensual
integer x = 773
integer y = 52
integer width = 87
integer height = 76
integer taborder = 20
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

type em_origen from editmask within w_rh735_rpt_boleta_mensual
integer x = 485
integer y = 52
integer width = 283
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_cod_trabajador from editmask within w_rh735_rpt_boleta_mensual
integer x = 485
integer y = 220
integer width = 283
integer height = 76
integer taborder = 70
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

type cb_4 from commandbutton within w_rh735_rpt_boleta_mensual
integer x = 773
integer y = 220
integer width = 87
integer height = 76
integer taborder = 70
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
string ls_codigo, ls_data, ls_sql, ls_origen, ls_tipo_trabajador

ls_origen = trim(em_origen.text)

if ls_origen = '' then
	gnvo_App.of_mensaje_error("Debe especificar un codigo de origen antes de continuar", "Error")
	em_origen.setFocus()
	return
end if

ls_tipo_trabajador = trim(em_tipo.text) + '%'

ls_sql = "SELECT distinct m.COD_TRABAJADOR as codigo_trabajador, " &
		 + "m.NOM_TRABAJADOR as nombre_trabajador, " &
		 + "m.DNI as dni " &
		 + "from vw_pr_trabajador m "&
		 + "where m.cod_origen = '" + ls_origen + "'" &
		 + "  and m.tipo_trabajador like '" + ls_tipo_trabajador + "'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_cod_trabajador.text = ls_codigo
	em_nom_trabajador.text = ls_data
end if

end event

type em_nom_trabajador from editmask within w_rh735_rpt_boleta_mensual
integer x = 859
integer y = 220
integer width = 983
integer height = 76
integer taborder = 80
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

type st_5 from statictext within w_rh735_rpt_boleta_mensual
integer x = 14
integer y = 228
integer width = 466
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Código Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_6 from statictext within w_rh735_rpt_boleta_mensual
integer x = 1851
integer y = 56
integer width = 466
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Centro de Costo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_cencos from editmask within w_rh735_rpt_boleta_mensual
integer x = 2322
integer y = 48
integer width = 283
integer height = 76
integer taborder = 80
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

type cb_cencos from commandbutton within w_rh735_rpt_boleta_mensual
integer x = 2610
integer y = 48
integer width = 87
integer height = 76
integer taborder = 80
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
string ls_codigo, ls_data, ls_sql, ls_origen, ls_tipo_trabajador

ls_origen = trim(em_origen.text)

if ls_origen = '' then
	gnvo_App.of_mensaje_error("Debe especificar un codigo de origen antes de continuar", "Error")
	em_origen.setFocus()
	return
end if

ls_tipo_trabajador = trim(em_tipo.text) + '%'

ls_sql = "select distinct cc.cencos as cencos, " &
		 + "cc.desc_cencos as descripcion_cencos " &
		 + "from maestro m, " &
		 + "     centros_costo cc " &
		 + "where m.cencos = cc.cencos " &
		 + "order by cc.cencos"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_cencos.text = ls_codigo
	em_desc_cencos.text = ls_data
end if

end event

type em_desc_cencos from editmask within w_rh735_rpt_boleta_mensual
integer x = 2697
integer y = 48
integer width = 983
integer height = 76
integer taborder = 80
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

type st_1 from statictext within w_rh735_rpt_boleta_mensual
integer x = 2062
integer y = 140
integer width = 251
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Periodo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_rh735_rpt_boleta_mensual
integer x = 2322
integer y = 136
integer width = 229
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_rh735_rpt_boleta_mensual
integer x = 2569
integer y = 136
integer width = 155
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type cbx_ajuste from checkbox within w_rh735_rpt_boleta_mensual
integer x = 1938
integer y = 228
integer width = 786
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ajustar Asignacion familiar"
end type

type gb_1 from groupbox within w_rh735_rpt_boleta_mensual
integer width = 4686
integer height = 388
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtro para el reporte"
end type

