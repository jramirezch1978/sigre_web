$PBExportHeader$w_rh731_rpt_basc.srw
forward
global type w_rh731_rpt_basc from w_report_smpl
end type
type cb_1 from commandbutton within w_rh731_rpt_basc
end type
type em_nombres from editmask within w_rh731_rpt_basc
end type
type em_codigo from editmask within w_rh731_rpt_basc
end type
type cb_2 from commandbutton within w_rh731_rpt_basc
end type
type ddlb_1 from dropdownlistbox within w_rh731_rpt_basc
end type
type gb_2 from groupbox within w_rh731_rpt_basc
end type
type gb_1 from groupbox within w_rh731_rpt_basc
end type
end forward

global type w_rh731_rpt_basc from w_report_smpl
integer width = 3291
integer height = 1491
string title = "(RH731) Reportes BASC"
string menuname = "m_impresion"
cb_1 cb_1
em_nombres em_nombres
em_codigo em_codigo
cb_2 cb_2
ddlb_1 ddlb_1
gb_2 gb_2
gb_1 gb_1
end type
global w_rh731_rpt_basc w_rh731_rpt_basc

on w_rh731_rpt_basc.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_nombres=create em_nombres
this.em_codigo=create em_codigo
this.cb_2=create cb_2
this.ddlb_1=create ddlb_1
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_nombres
this.Control[iCurrent+3]=this.em_codigo
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.ddlb_1
this.Control[iCurrent+6]=this.gb_2
this.Control[iCurrent+7]=this.gb_1
end on

on w_rh731_rpt_basc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_nombres)
destroy(this.em_codigo)
destroy(this.cb_2)
destroy(this.ddlb_1)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string ls_nombres, ls_codrep, ls_codusu
boolean lb_preview = false
DataWindowChild state_child
		
ls_nombres   = string(em_nombres.text)
ls_codusu = trim(em_codigo.text)
ls_codrep = mid(ddlb_1.text,1,2)

dw_report.reset()

choose case ls_codrep
		
	case '01'
		dw_report.dataobject = 'd_rpt_basc_induccion_al_puesto'
		dw_report.insertrow(0)
		dw_report.object.t_titulobasc1.text = 'INDUCCIÓN AL PUESTO'
		dw_report.object.t_titulobasc2.text = ''
		dw_report.object.t_codigobasc.text = 'CANT.FO.05.2'
		dw_report.object.t_versionbasc.text = 'VERSIÓN: 01'
		dw_report.object.t_nombre_trabajador.text = upper(ls_nombres)
		lb_preview = true
	
	case '02'
		dw_report.dataobject = 'd_rpt_basc_verificacion_domiciliaria_composite'
		dw_report.insertrow(0)
		dw_report.object.t_titulobasc1.text = 'VERIFICACIÓN DOMICILIARIA'
		dw_report.object.t_titulobasc2.text = ''
		dw_report.object.t_codigobasc.text = 'CANT.FO.05.4'
		dw_report.object.t_versionbasc.text = 'VERSIÓN: 00'
		idw_1.GetChild('dw_1', state_child)
		state_child.insertrow(0)
		idw_1.GetChild('dw_2', state_child)
		state_child.insertrow(0)
		idw_1.GetChild('dw_3', state_child)
		state_child.insertrow(0)
	
	case '03'
		dw_report.dataobject = 'd_rpt_basc_mant_protec_personal_composite'
		dw_report.insertrow(0)
		dw_report.object.t_titulobasc1.text = 'MANTENIMIENTO Y PROTECCIÓN'
		dw_report.object.t_titulobasc2.text = 'DEL PERSONAL'
		dw_report.object.t_codigobasc.text = 'CANT.FO.05.5'
		dw_report.object.t_versionbasc.text = 'VERSIÓN: 00'
		idw_1.GetChild('dw_1', state_child)
		state_child.insertrow(0)
		idw_1.GetChild('dw_2', state_child)
		state_child.insertrow(0)
	
	case '04'
		dw_report.dataobject = 'd_rpt_basc_obs_comportamiento_1_1'
		dw_report.insertrow(0)
		dw_report.object.t_titulobasc1.text = 'OBSERVACIONES DE'
		dw_report.object.t_titulobasc2.text = 'COMPORTAMIENTO'
		dw_report.object.t_codigobasc.text = 'CANT.FO.05.6'
		dw_report.object.t_versionbasc.text = 'VERSIÓN: 00'
		dw_report.object.t_nombre_trabajador.text = upper(ls_nombres)
		lb_preview = true	
	
	case '05'
		dw_report.dataobject = 'd_rpt_basc_ficha_actualizacion_datos_1_1'
		dw_report.insertrow(0)
		dw_report.object.t_titulobasc1.text = 'ACTUALIZACIÓN DE DATOS'
		dw_report.object.t_titulobasc2.text = ''
		dw_report.object.t_codigobasc.text = 'CANT.FO.05.7'
		dw_report.object.t_versionbasc.text = 'VERSIÓN: 00'
		lb_preview = true
	
	case '06'
		dw_report.dataobject = 'd_rpt_basc_funciones_perfil_puesto_1_1'
		dw_report.insertrow(0)
		dw_report.object.t_titulobasc1.text = 'FUNCIONES Y PERFIL'
		dw_report.object.t_titulobasc2.text = 'DE PUESTO'
		dw_report.object.t_codigobasc.text = 'CANT.FO.05.8'
		dw_report.object.t_versionbasc.text = 'VERSIÓN: 00'
		lb_preview = true
	
	case '07'
		if ls_codusu = '' or isnull(ls_codusu) then
			MessageBox('Aviso','Debe seleccionar un trabajador para poder visualizar este reporte')
			return
		end if
		dw_report.dataobject = 'd_rpt_basc_documentos_escaneados_composite'
		dw_report.settransobject(sqlca)
		dw_report.RETRIEVE(ls_codusu)
		dw_report.object.t_titulobasc1.text = 'CHECK LIST DE DOCUMENTOS'
		dw_report.object.t_titulobasc2.text = 'PERSONALES'
		dw_report.object.t_codigobasc.text = 'CANT.FO.05.9'
		dw_report.object.t_versionbasc.text = 'VERSIÓN: 00'
		lb_preview = true		
		
end choose	

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_usuario.text = upper(gs_user)

if lb_preview then
	dw_report.modify("DataWindow.Print.Scale = 100")
	dw_report.modify("Datawindow.Print.Preview= yes") 
	dw_report.modify('datawindow.print.preview.zoom = 100') 
end if
end event

type dw_report from w_report_smpl`dw_report within w_rh731_rpt_basc
integer x = 37
integer y = 256
integer width = 3185
integer height = 1027
integer taborder = 30
string dataobject = "d_rpt_basc_induccion_al_puesto"
end type

type cb_1 from commandbutton within w_rh731_rpt_basc
integer x = 2926
integer y = 128
integer width = 296
integer height = 99
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type em_nombres from editmask within w_rh731_rpt_basc
integer x = 1701
integer y = 109
integer width = 1145
integer height = 74
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_codigo from editmask within w_rh731_rpt_basc
integer x = 1229
integer y = 109
integer width = 315
integer height = 74
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh731_rpt_basc
integer x = 1576
integer y = 109
integer width = 88
integer height = 74
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

sl_param.dw1 = "d_rpt_seleccion_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param )
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_codigo.text  = sl_param.field_ret[1]
	em_nombres.text = sl_param.field_ret[2]
END IF

end event

type ddlb_1 from dropdownlistbox within w_rh731_rpt_basc
integer x = 66
integer y = 99
integer width = 1039
integer height = 752
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"01 - Inducción al Puesto","02 - Verificación Domiciliaria","03 - Mantenimiento y Protección del Personal","04 - Observaciones de Comportamiento","05 - Actualización de Datos","06 - Funciones y Perfil de Puesto","07 - Check List de documentos Pesonales"}
end type

event constructor;selectitem(1)
end event

type gb_2 from groupbox within w_rh731_rpt_basc
integer x = 37
integer y = 29
integer width = 1101
integer height = 202
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Tipo de Reporte"
borderstyle borderstyle = stylebox!
end type

type gb_1 from groupbox within w_rh731_rpt_basc
integer x = 1170
integer y = 32
integer width = 1730
integer height = 202
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " (Opcional) Seleccione Trabajador "
borderstyle borderstyle = stylebox!
end type

