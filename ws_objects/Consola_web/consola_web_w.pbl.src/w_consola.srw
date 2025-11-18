$PBExportHeader$w_consola.srw
forward
global type w_consola from window
end type
type p_logo_sytco from picture within w_consola
end type
type tab_navigate from tab within w_consola
end type
type tp_overview from userobject within tab_navigate
end type
type tp_overview from userobject within tab_navigate
end type
type tp_empresas from userobject within tab_navigate
end type
type cb_busca_empresa from commandbutton within tp_empresas
end type
type sle_busca_empresa from u_sle_codigo within tp_empresas
end type
type pb_contactos from picturebutton within tp_empresas
end type
type pb_modulos from picturebutton within tp_empresas
end type
type pb_refresh from picturebutton within tp_empresas
end type
type dw_empresas from u_dw_abc within tp_empresas
end type
type pb_add_empresa from picturebutton within tp_empresas
end type
type tp_empresas from userobject within tab_navigate
cb_busca_empresa cb_busca_empresa
sle_busca_empresa sle_busca_empresa
pb_contactos pb_contactos
pb_modulos pb_modulos
pb_refresh pb_refresh
dw_empresas dw_empresas
pb_add_empresa pb_add_empresa
end type
type tp_cro_pagos from userobject within tab_navigate
end type
type pb_add_cuota from picturebutton within tp_cro_pagos
end type
type dw_cron_pagos from u_dw_abc within tp_cro_pagos
end type
type dw_empresas_cro from datawindow within tp_cro_pagos
end type
type tp_cro_pagos from userobject within tab_navigate
pb_add_cuota pb_add_cuota
dw_cron_pagos dw_cron_pagos
dw_empresas_cro dw_empresas_cro
end type
type tp_equ_autoriz from userobject within tab_navigate
end type
type cb_add_all from picturebutton within tp_equ_autoriz
end type
type cb_add_one from picturebutton within tp_equ_autoriz
end type
type cb_delete_one from picturebutton within tp_equ_autoriz
end type
type cb_delete_all from picturebutton within tp_equ_autoriz
end type
type st_eq_auto from statictext within tp_equ_autoriz
end type
type dw_login_equipos from u_dw_abc within tp_equ_autoriz
end type
type st_hist_log from statictext within tp_equ_autoriz
end type
type dw_equ_emp_no_auto from u_dw_abc within tp_equ_autoriz
end type
type st_eq_no_aut from statictext within tp_equ_autoriz
end type
type dw_equ_emp_auto from u_dw_abc within tp_equ_autoriz
end type
type dw_empresas_autor from datawindow within tp_equ_autoriz
end type
type tp_equ_autoriz from userobject within tab_navigate
cb_add_all cb_add_all
cb_add_one cb_add_one
cb_delete_one cb_delete_one
cb_delete_all cb_delete_all
st_eq_auto st_eq_auto
dw_login_equipos dw_login_equipos
st_hist_log st_hist_log
dw_equ_emp_no_auto dw_equ_emp_no_auto
st_eq_no_aut st_eq_no_aut
dw_equ_emp_auto dw_equ_emp_auto
dw_empresas_autor dw_empresas_autor
end type
type tp_usu_housing from userobject within tab_navigate
end type
type cb_busca_usr_housing from commandbutton within tp_usu_housing
end type
type sle_busca_usr_housing from u_sle_codigo within tp_usu_housing
end type
type pb_refreshemp from picturebutton within tp_usu_housing
end type
type pb_add_emp from picturebutton within tp_usu_housing
end type
type dw_usr_hos_emp from u_dw_abc within tp_usu_housing
end type
type st_usr_hos_emp from statictext within tp_usu_housing
end type
type pb_refresh_usr_hos from picturebutton within tp_usu_housing
end type
type pb_add_usr_hos from picturebutton within tp_usu_housing
end type
type dw_usr_housing from u_dw_abc within tp_usu_housing
end type
type tp_usu_housing from userobject within tab_navigate
cb_busca_usr_housing cb_busca_usr_housing
sle_busca_usr_housing sle_busca_usr_housing
pb_refreshemp pb_refreshemp
pb_add_emp pb_add_emp
dw_usr_hos_emp dw_usr_hos_emp
st_usr_hos_emp st_usr_hos_emp
pb_refresh_usr_hos pb_refresh_usr_hos
pb_add_usr_hos pb_add_usr_hos
dw_usr_housing dw_usr_housing
end type
type tp_usuarios from userobject within tab_navigate
end type
type pb_refresh_usr from picturebutton within tp_usuarios
end type
type pb_add_usr from picturebutton within tp_usuarios
end type
type dw_usuarios from u_dw_abc within tp_usuarios
end type
type tp_usuarios from userobject within tab_navigate
pb_refresh_usr pb_refresh_usr
pb_add_usr pb_add_usr
dw_usuarios dw_usuarios
end type
type tp_venc_renta from userobject within tab_navigate
end type
type dw_rpt_mensual from u_dw_abc within tp_venc_renta
end type
type pb_add_venc_renta from picturebutton within tp_venc_renta
end type
type pb_refresh_venc_renta from picturebutton within tp_venc_renta
end type
type dw_venc_renta from u_dw_abc within tp_venc_renta
end type
type em_periodo from editmask within tp_venc_renta
end type
type st_periodo from statictext within tp_venc_renta
end type
type rb_anual from radiobutton within tp_venc_renta
end type
type rb_mensual from radiobutton within tp_venc_renta
end type
type gb_mens_anual from groupbox within tp_venc_renta
end type
type tp_venc_renta from userobject within tab_navigate
dw_rpt_mensual dw_rpt_mensual
pb_add_venc_renta pb_add_venc_renta
pb_refresh_venc_renta pb_refresh_venc_renta
dw_venc_renta dw_venc_renta
em_periodo em_periodo
st_periodo st_periodo
rb_anual rb_anual
rb_mensual rb_mensual
gb_mens_anual gb_mens_anual
end type
type tp_versiones from userobject within tab_navigate
end type
type st_1 from statictext within tp_versiones
end type
type pb_gestion_modulos from picturebutton within tp_versiones
end type
type pb_1 from picturebutton within tp_versiones
end type
type pb_add_version from picturebutton within tp_versiones
end type
type pb_refresh_version from picturebutton within tp_versiones
end type
type st_version_modulos from statictext within tp_versiones
end type
type dw_versiones_modulo from u_dw_abc within tp_versiones
end type
type dw_versiones from u_dw_abc within tp_versiones
end type
type p_2 from picture within tp_versiones
end type
type tp_versiones from userobject within tab_navigate
st_1 st_1
pb_gestion_modulos pb_gestion_modulos
pb_1 pb_1
pb_add_version pb_add_version
pb_refresh_version pb_refresh_version
st_version_modulos st_version_modulos
dw_versiones_modulo dw_versiones_modulo
dw_versiones dw_versiones
p_2 p_2
end type
type tab_navigate from tab within w_consola
tp_overview tp_overview
tp_empresas tp_empresas
tp_cro_pagos tp_cro_pagos
tp_equ_autoriz tp_equ_autoriz
tp_usu_housing tp_usu_housing
tp_usuarios tp_usuarios
tp_venc_renta tp_venc_renta
tp_versiones tp_versiones
end type
type p_logo from picture within w_consola
end type
type gb_1 from groupbox within w_consola
end type
type pb_salir from picturebutton within w_consola
end type
type p_cabecera from picture within w_consola
end type
type p_1 from picture within w_consola
end type
end forward

global type w_consola from window
integer width = 6153
integer height = 2572
boolean titlebar = true
string title = "CONSOLA WEB - SIGRE"
boolean resizable = true
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
p_logo_sytco p_logo_sytco
tab_navigate tab_navigate
p_logo p_logo
gb_1 gb_1
pb_salir pb_salir
p_cabecera p_cabecera
p_1 p_1
end type
global w_consola w_consola

type variables
u_dw_abc	idw_empresas, idw_equ_emp_auto, idw_equ_emp_no_auto, idw_login_equipos, idw_usr_housing, &
				idw_usr_hos_emp, idw_cron_pagos, idw_usuarios, idw_venc_renta, idw_rpt_mensual, idw_versiones, &
				idw_versiones_modulo
constant int ii_right_padding = 50, ii_bottom_padding = 80
Integer ii_equipo_empresa_id, ii_empresa_id, ii_cronograma_pago_id, ii_usuario_id, ii_mes, ii_anio
String is_mensual_anual, is_ult_dig, is_bue_contrib
end variables

forward prototypes
public subroutine of_asign_dws ()
public subroutine of_carga_dw_venc_renta ()
public subroutine of_carga_dw_reporte ()
public subroutine of_retrieve (string as_busca, string as_opcion)
end prototypes

public subroutine of_asign_dws ();//Asignacion del contenido del tab empresa
idw_empresas				= tab_navigate.tp_empresas.dw_empresas
idw_equ_emp_auto		= tab_navigate.tp_equ_autoriz.dw_equ_emp_auto
idw_equ_emp_no_auto	= tab_navigate.tp_equ_autoriz.dw_equ_emp_no_auto
idw_login_equipos			= tab_navigate.tp_equ_autoriz.dw_login_equipos
idw_usr_housing			= tab_navigate.tp_usu_housing.dw_usr_housing
idw_usr_hos_emp			= tab_navigate.tp_usu_housing.dw_usr_hos_emp
idw_cron_pagos			= tab_navigate.tp_cro_pagos.dw_cron_pagos
idw_usuarios				= tab_navigate.tp_usuarios.dw_usuarios
idw_venc_renta			= tab_navigate.tp_venc_renta.dw_venc_renta
idw_rpt_mensual			= tab_navigate.tp_venc_renta.dw_rpt_mensual
idw_versiones				= tab_navigate.tp_versiones.dw_versiones
idw_versiones_modulo	= tab_navigate.tp_versiones.dw_versiones_modulo
end subroutine

public subroutine of_carga_dw_venc_renta ();Integer li_periodo

if trim(tab_navigate.tp_venc_renta.em_periodo.text) = "" then return

li_periodo 	= Integer(tab_navigate.tp_venc_renta.em_periodo.text)
ii_anio		= li_periodo
if tab_navigate.tp_venc_renta.rb_mensual.checked then
	idw_venc_renta.dataobject = "d_lista_venc_renta_mensual_tbl"
	is_mensual_anual = '0'
elseif tab_navigate.tp_venc_renta.rb_anual.checked then
	idw_venc_renta.dataobject = "d_lista_venc_renta_anual_tbl"
	is_mensual_anual = '1'
end if
idw_venc_renta.settransobject(sqlca)
idw_venc_renta.retrieve(li_periodo)
of_carga_dw_reporte( )
tab_navigate.tp_venc_renta.pb_add_venc_renta.setfocus( )
end subroutine

public subroutine of_carga_dw_reporte ();Integer li_periodo

if trim(tab_navigate.tp_venc_renta.em_periodo.text) = "" then 	return

li_periodo 	= Integer(tab_navigate.tp_venc_renta.em_periodo.text)
if tab_navigate.tp_venc_renta.rb_mensual.checked then
	idw_rpt_mensual.dataobject = "d_rpt_venc_renta_mensual_tbl" //d_rpt_venc_renta_mensual_crt
	idw_rpt_mensual.settransobject(sqlca) 
elseif tab_navigate.tp_venc_renta.rb_anual.checked then
	idw_rpt_mensual.dataobject = ""
	idw_rpt_mensual.settransobject(sqlca) 
end if
idw_rpt_mensual.retrieve(li_periodo)
end subroutine

public subroutine of_retrieve (string as_busca, string as_opcion);CHOOSE CASE UPPER(as_opcion)
	CASE "E" //Empresas
		idw_empresas.Retrieve(as_busca)
		idw_empresas.ii_update = 0
		idw_empresas.ResetUpdate ()
		return
		
	CASE "UH" //usuarios housing
		idw_usr_housing.Retrieve(as_busca)
		idw_usr_housing.ii_update = 0
		idw_usr_housing.ResetUpdate ()
		return

END CHOOSE
end subroutine

on w_consola.create
this.p_logo_sytco=create p_logo_sytco
this.tab_navigate=create tab_navigate
this.p_logo=create p_logo
this.gb_1=create gb_1
this.pb_salir=create pb_salir
this.p_cabecera=create p_cabecera
this.p_1=create p_1
this.Control[]={this.p_logo_sytco,&
this.tab_navigate,&
this.p_logo,&
this.gb_1,&
this.pb_salir,&
this.p_cabecera,&
this.p_1}
end on

on w_consola.destroy
destroy(this.p_logo_sytco)
destroy(this.tab_navigate)
destroy(this.p_logo)
destroy(this.gb_1)
destroy(this.pb_salir)
destroy(this.p_cabecera)
destroy(this.p_1)
end on

event resize;of_asign_dws( )

//Alineacion del boton salir y el logo sytco
pb_salir.x = newWidth - 300
p_logo_sytco.x = newWidth - p_logo_sytco.width
p_cabecera.width = newWidth

//Alineacion del groupbox y del tabpanel
gb_1.width 	= newwidth - gb_1.x - ii_right_padding
gb_1.height = newheight - gb_1.y - ii_bottom_padding

tab_navigate.width 	= gb_1.width - tab_navigate.x - ii_right_padding
tab_navigate.height 	= gb_1.height - ii_bottom_padding

//Alineacion del contenido del tab empresa
idw_empresas.width = tab_navigate.tp_empresas.width - idw_empresas.x - ii_right_padding
idw_empresas.height = tab_navigate.tp_empresas.Height - idw_empresas.y - ii_bottom_padding
//botones del tab empresa
tab_navigate.tp_empresas.pb_contactos.x 			= idw_empresas.x + idw_empresas.width - tab_navigate.tp_empresas.pb_contactos.width - 10
tab_navigate.tp_empresas.pb_modulos.x 			= tab_navigate.tp_empresas.pb_contactos.x - tab_navigate.tp_empresas.pb_modulos.width - 10
tab_navigate.tp_empresas.pb_add_empresa.x 		= tab_navigate.tp_empresas.pb_modulos.x - tab_navigate.tp_empresas.pb_add_empresa.width - 10
tab_navigate.tp_empresas.pb_refresh.x 				= tab_navigate.tp_empresas.pb_add_empresa.x - tab_navigate.tp_empresas.pb_refresh.width - 10

//Alineacion del contenido del tab cronograma pagos
idw_cron_pagos.width 								= tab_navigate.tp_cro_pagos.width - idw_cron_pagos.x - ii_right_padding
idw_cron_pagos.height 								= tab_navigate.tp_cro_pagos.Height - idw_cron_pagos.y - ii_bottom_padding
tab_navigate.tp_cro_pagos.pb_add_cuota.x 	= idw_cron_pagos.x + idw_cron_pagos.width - tab_navigate.tp_cro_pagos.pb_add_cuota.width - 10

//Alineacion del contenido del tab equipos autorizados
idw_equ_emp_auto.width 								= tab_navigate.tp_equ_autoriz.width * 0.3 - idw_equ_emp_auto.x - ii_right_padding
idw_equ_emp_auto.height 								= tab_navigate.tp_equ_autoriz.Height - idw_equ_emp_auto.y - ii_bottom_padding
tab_navigate.tp_equ_autoriz.st_eq_auto.x			= idw_equ_emp_auto.x
tab_navigate.tp_equ_autoriz.st_eq_auto.width		= idw_equ_emp_auto.width
tab_navigate.tp_equ_autoriz.cb_delete_all.x			= idw_equ_emp_auto.x + idw_equ_emp_auto.width + ii_right_padding
tab_navigate.tp_equ_autoriz.cb_delete_one.x		= idw_equ_emp_auto.x + idw_equ_emp_auto.width + ii_right_padding
tab_navigate.tp_equ_autoriz.cb_add_one.x			= idw_equ_emp_auto.x + idw_equ_emp_auto.width + ii_right_padding
tab_navigate.tp_equ_autoriz.cb_add_all.x			= idw_equ_emp_auto.x + idw_equ_emp_auto.width + ii_right_padding
idw_equ_emp_no_auto.x 								= tab_navigate.tp_equ_autoriz.cb_delete_all.x + tab_navigate.tp_equ_autoriz.cb_delete_all.width + ii_right_padding
idw_equ_emp_no_auto.width 							= tab_navigate.tp_equ_autoriz.width * 0.3 - ii_right_padding
idw_equ_emp_no_auto.height 							= tab_navigate.tp_equ_autoriz.Height - idw_equ_emp_no_auto.y - ii_bottom_padding
tab_navigate.tp_equ_autoriz.st_eq_no_aut.x		= idw_equ_emp_no_auto.x
tab_navigate.tp_equ_autoriz.st_eq_no_aut.width	= idw_equ_emp_no_auto.width
idw_login_equipos.x 										= idw_equ_emp_no_auto.x + idw_equ_emp_no_auto.width + ii_right_padding
idw_login_equipos.width 								= tab_navigate.tp_equ_autoriz.width * 0.37 - ii_right_padding
idw_login_equipos.height 								= tab_navigate.tp_equ_autoriz.Height - idw_login_equipos.y - ii_bottom_padding
tab_navigate.tp_equ_autoriz.st_hist_log.x			= idw_login_equipos.x
tab_navigate.tp_equ_autoriz.st_hist_log.weight		= idw_login_equipos.width

//Alineacion del contenido del tab usuarios housing
idw_usr_housing.width 											= (tab_navigate.tp_usu_housing.width / 5)*3 - idw_usr_housing.x - ii_right_padding
idw_usr_housing.height 											= tab_navigate.tp_usu_housing.Height - idw_usr_housing.y - ii_bottom_padding
tab_navigate.tp_usu_housing.pb_add_usr_hos.x			= idw_usr_housing.x + idw_usr_housing.width - tab_navigate.tp_usu_housing.pb_add_usr_hos.width
tab_navigate.tp_usu_housing.pb_refresh_usr_hos.x		= tab_navigate.tp_usu_housing.pb_add_usr_hos.x - tab_navigate.tp_usu_housing.pb_refresh_usr_hos.width
idw_usr_hos_emp.x 												= idw_usr_housing.x + idw_usr_housing.width + ii_right_padding
idw_usr_hos_emp.width 											= (tab_navigate.tp_usu_housing.width / 5)*2 - ii_right_padding
idw_usr_hos_emp.height 										= tab_navigate.tp_usu_housing.Height - idw_usr_hos_emp.y - ii_bottom_padding
tab_navigate.tp_usu_housing.st_usr_hos_emp.x			= idw_usr_hos_emp.x
tab_navigate.tp_usu_housing.st_usr_hos_emp.width		= idw_usr_hos_emp.width
tab_navigate.tp_usu_housing.pb_add_emp.x				= idw_usr_hos_emp.x + idw_usr_hos_emp.width - tab_navigate.tp_usu_housing.pb_add_emp.width
tab_navigate.tp_usu_housing.pb_refreshemp.x				= tab_navigate.tp_usu_housing.pb_add_emp.x - tab_navigate.tp_usu_housing.pb_refreshemp.width

//Alineacion del contenido del tab gestion usuarios
idw_usuarios.height		= tab_navigate.tp_usuarios.Height - idw_usuarios.y - ii_bottom_padding

//Alineacion del contenido del tab vencimiento renta
idw_venc_renta.height	 = tab_navigate.tp_venc_renta.Height - idw_venc_renta.y - ii_bottom_padding
idw_rpt_mensual.height	 = tab_navigate.tp_venc_renta.Height - idw_rpt_mensual.y - ii_bottom_padding
idw_rpt_mensual.width	 = tab_navigate.tp_venc_renta.width - idw_rpt_mensual.x - ii_right_padding

//Alineacion del contenido del tab Modulos y versiones
idw_versiones.height					= tab_navigate.tp_versiones.Height - idw_versiones.y - ii_bottom_padding
idw_versiones_modulo.width		= tab_navigate.tp_versiones.width - idw_versiones_modulo.x - ii_right_padding
idw_versiones_modulo.height		= tab_navigate.tp_versiones.Height - idw_versiones_modulo.y - ii_bottom_padding

end event

event open;of_asign_dws( )
end event

type p_logo_sytco from picture within w_consola
integer x = 5774
integer y = 344
integer width = 343
integer height = 200
string picturename = "C:\SIGRE\resources\PNG\opcionsytco2.png"
boolean focusrectangle = false
end type

type tab_navigate from tab within w_consola
integer x = 23
integer y = 608
integer width = 6062
integer height = 1808
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
alignment alignment = right!
integer selectedtab = 1
tp_overview tp_overview
tp_empresas tp_empresas
tp_cro_pagos tp_cro_pagos
tp_equ_autoriz tp_equ_autoriz
tp_usu_housing tp_usu_housing
tp_usuarios tp_usuarios
tp_venc_renta tp_venc_renta
tp_versiones tp_versiones
end type

on tab_navigate.create
this.tp_overview=create tp_overview
this.tp_empresas=create tp_empresas
this.tp_cro_pagos=create tp_cro_pagos
this.tp_equ_autoriz=create tp_equ_autoriz
this.tp_usu_housing=create tp_usu_housing
this.tp_usuarios=create tp_usuarios
this.tp_venc_renta=create tp_venc_renta
this.tp_versiones=create tp_versiones
this.Control[]={this.tp_overview,&
this.tp_empresas,&
this.tp_cro_pagos,&
this.tp_equ_autoriz,&
this.tp_usu_housing,&
this.tp_usuarios,&
this.tp_venc_renta,&
this.tp_versiones}
end on

on tab_navigate.destroy
destroy(this.tp_overview)
destroy(this.tp_empresas)
destroy(this.tp_cro_pagos)
destroy(this.tp_equ_autoriz)
destroy(this.tp_usu_housing)
destroy(this.tp_usuarios)
destroy(this.tp_venc_renta)
destroy(this.tp_versiones)
end on

event selectionchanged;Long ll_row
choose case newindex
	case 2
		idw_empresas.retrieve("" )
	case 3
		DataWindowChild ldwch_empcro
		tab_navigate.tp_cro_pagos.dw_empresas_cro.GetChild("empresa_id", ldwch_empcro)
		ldwch_empcro.SetTransObject(SQLCA)
		ll_row = ldwch_empcro.getselectedrow(0)
		if ll_row = 0 then 
			ii_empresa_id = 0
		else 
			ii_empresa_id	= Integer(tab_navigate.tp_cro_pagos.dw_empresas_cro.object.empresa_id [1])
		end if
		//ldwch_empcro.SelectRow(0, true)
		ldwch_empcro.Retrieve()
		
case 4
		DataWindowChild ldwch_1
		tab_navigate.tp_equ_autoriz.dw_empresas_autor.GetChild("empresa_id", ldwch_1)
		ldwch_1.SetTransObject(SQLCA)
		/*if ldwch_1.RowCount() > 0 then
			ldwch_1.selectrow( 1, true)
		end if*/
		ldwch_1.Retrieve()
end choose
end event

type tp_overview from userobject within tab_navigate
integer x = 18
integer y = 112
integer width = 6025
integer height = 1680
long backcolor = 16777215
string text = "Overview"
long tabtextcolor = 134217856
long tabbackcolor = 16777215
string picturename = "C:\SIGRE\resources\ICO\2016\Finanzas.ico"
long picturemaskcolor = 536870912
end type

type tp_empresas from userobject within tab_navigate
integer x = 18
integer y = 112
integer width = 6025
integer height = 1680
long backcolor = 16777215
string text = "Empresas"
long tabtextcolor = 134217856
long tabbackcolor = 16777215
string picturename = "C:\SIGRE\resources\ICO\2016\Comercializacion.ico"
long picturemaskcolor = 536870912
cb_busca_empresa cb_busca_empresa
sle_busca_empresa sle_busca_empresa
pb_contactos pb_contactos
pb_modulos pb_modulos
pb_refresh pb_refresh
dw_empresas dw_empresas
pb_add_empresa pb_add_empresa
end type

on tp_empresas.create
this.cb_busca_empresa=create cb_busca_empresa
this.sle_busca_empresa=create sle_busca_empresa
this.pb_contactos=create pb_contactos
this.pb_modulos=create pb_modulos
this.pb_refresh=create pb_refresh
this.dw_empresas=create dw_empresas
this.pb_add_empresa=create pb_add_empresa
this.Control[]={this.cb_busca_empresa,&
this.sle_busca_empresa,&
this.pb_contactos,&
this.pb_modulos,&
this.pb_refresh,&
this.dw_empresas,&
this.pb_add_empresa}
end on

on tp_empresas.destroy
destroy(this.cb_busca_empresa)
destroy(this.sle_busca_empresa)
destroy(this.pb_contactos)
destroy(this.pb_modulos)
destroy(this.pb_refresh)
destroy(this.dw_empresas)
destroy(this.pb_add_empresa)
end on

type cb_busca_empresa from commandbutton within tp_empresas
integer x = 1541
integer y = 80
integer width = 274
integer height = 88
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;of_retrieve(sle_busca_empresa.text, "E")
end event

type sle_busca_empresa from u_sle_codigo within tp_empresas
integer x = 5
integer y = 80
integer width = 1536
integer height = 88
integer taborder = 70
integer textsize = -8
end type

event modified;cb_busca_empresa.event clicked()
end event

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

type pb_contactos from picturebutton within tp_empresas
integer x = 5833
integer y = 32
integer width = 183
integer height = 160
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Toolbar\cliente.jpg"
alignment htextalign = right!
string powertiptext = "Contactos"
end type

event clicked;Long	ll_row

ll_row = idw_empresas.getselectedrow( 0)
if ll_row = 0 then return

ii_empresa_id 			= idw_empresas.object.empresa_id [ll_row]
Open(w_cw501_contactos)
end event

type pb_modulos from picturebutton within tp_empresas
integer x = 5655
integer y = 32
integer width = 183
integer height = 160
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Toolbar\compras.jpg"
alignment htextalign = right!
string powertiptext = "Asignar Versión"
end type

event clicked;Long	ll_row
String ls_flag_estado, ls_flag_autorizado

ll_row = idw_empresas.getselectedrow( 0)
if ll_row = 0 then return

ii_empresa_id 			= idw_empresas.object.empresa_id [ll_row]
ls_flag_estado 			= idw_empresas.object.flag_estado [ll_row]
ls_flag_autorizado 	= idw_empresas.object.flag_autorizado [ll_row]

if (ls_flag_estado = '0' or ls_flag_autorizado = '0') then
	MessageBox("Aviso", "No es posible asisgnar módulos para esta empresa, verifique por favor", Information!)
	return
end if

//Open(w_cw300_modulo_empresa)
Open(w_cw301_empresa_version)
end event

type pb_refresh from picturebutton within tp_empresas
integer x = 5298
integer y = 32
integer width = 183
integer height = 160
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Toolbar\actualiza.png"
alignment htextalign = right!
string powertiptext = "Actualizar listado"
end type

event clicked;idw_empresas.retrieve("" )
end event

type dw_empresas from u_dw_abc within tp_empresas
integer y = 200
integer width = 6011
integer height = 1452
integer taborder = 20
string dataobject = "d_list_empresas_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event clicked;//Override
if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

gs_empresa = tab_navigate.tp_empresas.dw_empresas.object.cod_empresa [row]
end event

event rowfocuschanged;//Override

This.SelectRow(0, False)
This.SelectRow(currentrow, True)
THIS.SetRow(currentrow)
this.event ue_output(currentrow)

end event

event doubleclicked;call super::doubleclicked;if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

gs_empresa = idw_empresas.object.cod_empresa [row]

gs_action = 'open'
Open(w_cw001_empresas)
dw_empresas.retrieve("" )
end event

event buttonclicked;call super::buttonclicked;Long 		ll_empresa_id
string 	ls_mensaje

if lower(dwo.name) = 'b_eliminar' then
	ll_empresa_id = Long(this.object.empresa_id [row])
	
	//Preguntar si desea eliminar
	if MessageBox('Aviso', 'Deseas eliminar el registro ' + string(row) + ' con id ' + string(ll_empresa_id) + '?', Information!, YesNo!, 2) = 2 then return
	
	Delete empresa
	where empresa_id = :ll_empresa_id;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = "No se ha podido eliminar la empresa. Mensaje de Error: " + SQLCA.SQLErrText
		ROLLBACK;
		gnvo_app.of_mensaje_error( ls_mensaje )
		return
	end if
	
	commit;
	MessageBox('Aviso', 'Eliminacion realizada satisfactoriamente', Information!)
	
	this.Retrieve()
end if
end event

type pb_add_empresa from picturebutton within tp_empresas
integer x = 5477
integer y = 32
integer width = 183
integer height = 160
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Toolbar\note_add.png"
alignment htextalign = right!
string powertiptext = "Registrar nueva empresa"
end type

event clicked;gs_action = 'new'
Open(w_cw001_empresas)
dw_empresas.retrieve("" )
end event

type tp_cro_pagos from userobject within tab_navigate
integer x = 18
integer y = 112
integer width = 6025
integer height = 1680
long backcolor = 16777215
string text = "Cronograma Pagos"
long tabtextcolor = 134217856
long tabbackcolor = 16777215
string picturename = "C:\SIGRE\resources\ICO\2016\Contabilidad.ico"
long picturemaskcolor = 536870912
pb_add_cuota pb_add_cuota
dw_cron_pagos dw_cron_pagos
dw_empresas_cro dw_empresas_cro
end type

on tp_cro_pagos.create
this.pb_add_cuota=create pb_add_cuota
this.dw_cron_pagos=create dw_cron_pagos
this.dw_empresas_cro=create dw_empresas_cro
this.Control[]={this.pb_add_cuota,&
this.dw_cron_pagos,&
this.dw_empresas_cro}
end on

on tp_cro_pagos.destroy
destroy(this.pb_add_cuota)
destroy(this.dw_cron_pagos)
destroy(this.dw_empresas_cro)
end on

type pb_add_cuota from picturebutton within tp_cro_pagos
integer x = 5097
integer y = 28
integer width = 183
integer height = 160
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean originalsize = true
string picturename = "C:\SIGRE\resources\Toolbar\note_add.png"
alignment htextalign = right!
string powertiptext = "Agregar Cuota"
end type

event clicked;if ii_empresa_id > 0 then
	gs_action = 'new'
	Open(w_cw004_cuotas)
	dw_cron_pagos.retrieve( ii_empresa_id)
end if
end event

type dw_cron_pagos from u_dw_abc within tp_cro_pagos
integer x = 23
integer y = 192
integer width = 5262
integer height = 1416
integer taborder = 20
string dataobject = "d_list_cronograma_pagos_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event buttonclicked;call super::buttonclicked;Long 		ll_cron_pago_id
Integer li_empresa_id
string 	ls_mensaje, ls_flag_pagado

li_empresa_id = this.object.empresa_id [row]
ll_cron_pago_id = Long(this.object.cronograma_pago_id [row])
	
if lower(dwo.name) = 'b_eliminar' then

	//Preguntar si desea eliminar
	if MessageBox('Aviso', 'Deseas eliminar la cuota ' + string(row) + ' con id ' + string(ll_cron_pago_id) + '?', Information!, YesNo!, 2) = 2 then return
	
	Delete cronograma_pagos
	where cronograma_pago_id = :ll_cron_pago_id;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = "No se ha podido eliminar la cuota. Mensaje de Error: " + SQLCA.SQLErrText
		ROLLBACK;
		gnvo_app.of_mensaje_error( ls_mensaje )
		return
	end if
	
	commit;
	MessageBox('Aviso', 'Eliminacion realizada satisfactoriamente', Information!)
	
	this.Retrieve(li_empresa_id)
elseif lower(dwo.name) = 'b_pagar' then
	ls_flag_pagado = this.object.flag_pagado	[row]
	
	if ls_flag_pagado = '1' then
		MessageBox('Aviso', 'Cuota ya se encuentra pagada', Information!)
		return
	end if
	
	ii_cronograma_pago_id = ll_cron_pago_id
	Open(w_cw005_pago_cuota)
	this.Retrieve(li_empresa_id)
end if
end event

event doubleclicked;call super::doubleclicked;Integer li_empresa_id
if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

ii_cronograma_pago_id 	= this.object.cronograma_pago_id [row]
li_empresa_id				= this.object.empresa_id [row]

gs_action = 'open'
Open(w_cw004_cuotas)
this.retrieve( li_empresa_id)
end event

type dw_empresas_cro from datawindow within tp_cro_pagos
integer x = 23
integer y = 40
integer width = 1728
integer height = 120
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_lista_empresa_ff"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Integer li_empresa_id

this.AcceptText()

li_empresa_id = Integer(this.object.empresa_id [1])

dw_cron_pagos.Retrieve( li_empresa_id)
ii_empresa_id = li_empresa_id
//para que los dw no aparescan seleccionados
dw_cron_pagos.SelectRow(0, False)
end event

event constructor;this.InsertRow(0)
end event

type tp_equ_autoriz from userobject within tab_navigate
integer x = 18
integer y = 112
integer width = 6025
integer height = 1680
long backcolor = 16777215
string text = "Equipos Autorizados"
long tabtextcolor = 134217856
long tabbackcolor = 16777215
string picturename = "C:\SIGRE\resources\ICO\2016\GerOT.ico"
long picturemaskcolor = 536870912
cb_add_all cb_add_all
cb_add_one cb_add_one
cb_delete_one cb_delete_one
cb_delete_all cb_delete_all
st_eq_auto st_eq_auto
dw_login_equipos dw_login_equipos
st_hist_log st_hist_log
dw_equ_emp_no_auto dw_equ_emp_no_auto
st_eq_no_aut st_eq_no_aut
dw_equ_emp_auto dw_equ_emp_auto
dw_empresas_autor dw_empresas_autor
end type

on tp_equ_autoriz.create
this.cb_add_all=create cb_add_all
this.cb_add_one=create cb_add_one
this.cb_delete_one=create cb_delete_one
this.cb_delete_all=create cb_delete_all
this.st_eq_auto=create st_eq_auto
this.dw_login_equipos=create dw_login_equipos
this.st_hist_log=create st_hist_log
this.dw_equ_emp_no_auto=create dw_equ_emp_no_auto
this.st_eq_no_aut=create st_eq_no_aut
this.dw_equ_emp_auto=create dw_equ_emp_auto
this.dw_empresas_autor=create dw_empresas_autor
this.Control[]={this.cb_add_all,&
this.cb_add_one,&
this.cb_delete_one,&
this.cb_delete_all,&
this.st_eq_auto,&
this.dw_login_equipos,&
this.st_hist_log,&
this.dw_equ_emp_no_auto,&
this.st_eq_no_aut,&
this.dw_equ_emp_auto,&
this.dw_empresas_autor}
end on

on tp_equ_autoriz.destroy
destroy(this.cb_add_all)
destroy(this.cb_add_one)
destroy(this.cb_delete_one)
destroy(this.cb_delete_all)
destroy(this.st_eq_auto)
destroy(this.dw_login_equipos)
destroy(this.st_hist_log)
destroy(this.dw_equ_emp_no_auto)
destroy(this.st_eq_no_aut)
destroy(this.dw_equ_emp_auto)
destroy(this.dw_empresas_autor)
end on

type cb_add_all from picturebutton within tp_equ_autoriz
integer x = 1856
integer y = 1012
integer width = 146
integer height = 128
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\primero.bmp"
end type

event clicked;String ls_mensaje
str_parametros	lstr_param
Integer li_empresa_id, li_x
Long	ll_row_count

ll_row_count = idw_equ_emp_no_auto.rowcount( )

FOR li_x = 1 to ll_row_count
	li_empresa_id = idw_equ_emp_no_auto.object.empresa_id [li_x]
	idw_equ_emp_no_auto.object.flag_estado 		[li_x]  = '1'
	idw_equ_emp_no_auto.update()
	
	if sqlca.sqlCode < 0 then
		ls_mensaje = sqlca.SQLErrText
		ROLLBACK;
		MessageBox('Error al desautorizar equipo', ls_mensaje)
		return
	end if
NEXT

dw_equ_emp_auto.Retrieve('1', li_empresa_id) //Parametros(flag_estado, empresa_id)
dw_equ_emp_no_auto.Retrieve('0', li_empresa_id) //Parametros(flag_estado, empresa_id)

COMMIT ;
end event

type cb_add_one from picturebutton within tp_equ_autoriz
integer x = 1856
integer y = 880
integer width = 146
integer height = 128
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\previous.bmp"
end type

event clicked;String ls_mensaje
str_parametros	lstr_param
Integer li_empresa_id
Long	ll_row

ll_row = idw_equ_emp_no_auto.getselectedrow( 0)

if ll_row = 0 then return

li_empresa_id = idw_equ_emp_no_auto.object.empresa_id [ll_row]
idw_equ_emp_no_auto.object.flag_estado 		[ll_row]  = '1'
idw_equ_emp_no_auto.update()

if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al desautorizar equipo', ls_mensaje)
	return
end if

dw_equ_emp_auto.Retrieve('1', li_empresa_id) //Parametros(flag_estado, empresa_id)
dw_equ_emp_no_auto.Retrieve('0', li_empresa_id) //Parametros(flag_estado, empresa_id)

COMMIT ;
end event

type cb_delete_one from picturebutton within tp_equ_autoriz
integer x = 1856
integer y = 748
integer width = 146
integer height = 128
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\next.bmp"
end type

event clicked;String ls_mensaje
str_parametros	lstr_param
Integer li_empresa_id
Long	ll_row

ll_row = idw_equ_emp_auto.getselectedrow( 0)
if ll_row = 0 then return

li_empresa_id = idw_equ_emp_auto.object.empresa_id [ll_row]
idw_equ_emp_auto.object.flag_estado 		[ll_row]  = '0'
idw_equ_emp_auto.update()

if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al desautorizar equipo', ls_mensaje)
	return
end if

dw_equ_emp_auto.Retrieve('1', li_empresa_id) //Parametros(flag_estado, empresa_id)
dw_equ_emp_no_auto.Retrieve('0', li_empresa_id) //Parametros(flag_estado, empresa_id)

COMMIT ;
end event

type cb_delete_all from picturebutton within tp_equ_autoriz
integer x = 1856
integer y = 616
integer width = 146
integer height = 128
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "C:\SIGRE\resources\BMP\last.bmp"
end type

event clicked;String ls_mensaje
str_parametros	lstr_param
Integer li_empresa_id, li_x
Long	ll_row_count

ll_row_count = idw_equ_emp_auto.rowcount( )

FOR li_x = 1 to ll_row_count
	li_empresa_id = idw_equ_emp_auto.object.empresa_id [li_x]
	idw_equ_emp_auto.object.flag_estado 		[li_x]  = '0'
	idw_equ_emp_auto.update()
	
	if sqlca.sqlCode < 0 then
		ls_mensaje = sqlca.SQLErrText
		ROLLBACK;
		MessageBox('Error al desautorizar equipo', ls_mensaje)
		return
	end if
NEXT

dw_equ_emp_auto.Retrieve('1', li_empresa_id) //Parametros(flag_estado, empresa_id)
dw_equ_emp_no_auto.Retrieve('0', li_empresa_id) //Parametros(flag_estado, empresa_id)

COMMIT ;
end event

type st_eq_auto from statictext within tp_equ_autoriz
integer x = 9
integer y = 124
integer width = 1815
integer height = 68
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "EQUIPOS AUTORIZADOS"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_login_equipos from u_dw_abc within tp_equ_autoriz
integer x = 3867
integer y = 188
integer width = 2144
integer height = 1436
integer taborder = 20
string dataobject = "d_list_login_equipos_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

type st_hist_log from statictext within tp_equ_autoriz
integer x = 3867
integer y = 124
integer width = 2144
integer height = 72
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "HISTORIAL LOGIN"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_equ_emp_no_auto from u_dw_abc within tp_equ_autoriz
integer x = 2011
integer y = 188
integer width = 1833
integer height = 1436
integer taborder = 20
string dataobject = "d_list_equipos_empresa_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event clicked;call super::clicked;Integer li_equipo_empresa_id

if row = 0 then return

this.SelectRow(0, false)
this.SelectRow(row, true)

li_equipo_empresa_id = tab_navigate.tp_equ_autoriz.dw_equ_emp_no_auto.object.equipo_empresa_id [row]
dw_login_equipos.Retrieve(li_equipo_empresa_id) 
//quito la seleccion de el dw_equ_emp_auto
dw_equ_emp_auto.SelectRow(0, False)
end event

event doubleclicked;call super::doubleclicked;Integer li_empresa_id

if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

gs_empresa 				= idw_equ_emp_no_auto.object.equipo_empresa_id [row]
li_empresa_id				= idw_equ_emp_no_auto.object.empresa_id [row]
ii_equipo_empresa_id		= idw_equ_emp_no_auto.object.equipo_empresa_id [row]

Open(w_cw003_equipos_empresa)

idw_equ_emp_no_auto.retrieve('0', li_empresa_id )
end event

type st_eq_no_aut from statictext within tp_equ_autoriz
integer x = 2011
integer y = 124
integer width = 1833
integer height = 68
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "EQUIPOS NO AUTORIZADOS"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_equ_emp_auto from u_dw_abc within tp_equ_autoriz
integer x = 9
integer y = 192
integer width = 1833
integer height = 1436
integer taborder = 20
string dataobject = "d_list_equipos_empresa_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail

end event

event clicked;call super::clicked;Integer li_equipo_empresa_id

if row = 0 then return

this.SelectRow(0, false)
this.SelectRow(row, true)

li_equipo_empresa_id = tab_navigate.tp_equ_autoriz.dw_equ_emp_auto.object.equipo_empresa_id [row]
dw_login_equipos.Retrieve(li_equipo_empresa_id) 
//quito la seleccion de el dw_equ_emp_no_auto
dw_equ_emp_no_auto.SelectRow(0, False)
end event

event doubleclicked;call super::doubleclicked;Integer li_empresa_id

if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

gs_empresa 				= idw_equ_emp_auto.object.equipo_empresa_id [row]
li_empresa_id				= idw_equ_emp_auto.object.empresa_id [row]
ii_equipo_empresa_id		= idw_equ_emp_auto.object.equipo_empresa_id [row]

Open(w_cw003_equipos_empresa)
idw_equ_emp_auto.retrieve('1', li_empresa_id )
end event

type dw_empresas_autor from datawindow within tp_equ_autoriz
integer y = 24
integer width = 1883
integer height = 116
integer taborder = 20
string title = "none"
string dataobject = "d_lista_empresa_ff"
boolean border = false
boolean livescroll = true
end type

event constructor;this.InsertRow(0)

/*DataWindowChild ldwch_1
this.GetChild("empresa_id", ldwch_1)
ldwch_1.SetTransObject(SQLCA)
ldwch_1.Retrieve()*/
end event

event itemchanged;Integer li_empresa_id

this.AcceptText()

li_empresa_id = Integer(this.object.empresa_id [1])

dw_equ_emp_auto.Retrieve('1', li_empresa_id) //Parametros(flag_estado, empresa_id)
dw_equ_emp_no_auto.Retrieve('0', li_empresa_id) //Parametros(flag_estado, empresa_id)
dw_login_equipos.retrieve( 0)	

//para que los dw no aparescan seleccionados
dw_equ_emp_auto.SelectRow(0, False)
dw_equ_emp_no_auto.SelectRow(0, False)
end event

type tp_usu_housing from userobject within tab_navigate
integer x = 18
integer y = 112
integer width = 6025
integer height = 1680
long backcolor = 16777215
string text = "Usuarios Housing"
long tabtextcolor = 134217856
long tabbackcolor = 16777215
string picturename = "C:\SIGRE\resources\ICO\2016\Asistencia.ico"
long picturemaskcolor = 536870912
cb_busca_usr_housing cb_busca_usr_housing
sle_busca_usr_housing sle_busca_usr_housing
pb_refreshemp pb_refreshemp
pb_add_emp pb_add_emp
dw_usr_hos_emp dw_usr_hos_emp
st_usr_hos_emp st_usr_hos_emp
pb_refresh_usr_hos pb_refresh_usr_hos
pb_add_usr_hos pb_add_usr_hos
dw_usr_housing dw_usr_housing
end type

on tp_usu_housing.create
this.cb_busca_usr_housing=create cb_busca_usr_housing
this.sle_busca_usr_housing=create sle_busca_usr_housing
this.pb_refreshemp=create pb_refreshemp
this.pb_add_emp=create pb_add_emp
this.dw_usr_hos_emp=create dw_usr_hos_emp
this.st_usr_hos_emp=create st_usr_hos_emp
this.pb_refresh_usr_hos=create pb_refresh_usr_hos
this.pb_add_usr_hos=create pb_add_usr_hos
this.dw_usr_housing=create dw_usr_housing
this.Control[]={this.cb_busca_usr_housing,&
this.sle_busca_usr_housing,&
this.pb_refreshemp,&
this.pb_add_emp,&
this.dw_usr_hos_emp,&
this.st_usr_hos_emp,&
this.pb_refresh_usr_hos,&
this.pb_add_usr_hos,&
this.dw_usr_housing}
end on

on tp_usu_housing.destroy
destroy(this.cb_busca_usr_housing)
destroy(this.sle_busca_usr_housing)
destroy(this.pb_refreshemp)
destroy(this.pb_add_emp)
destroy(this.dw_usr_hos_emp)
destroy(this.st_usr_hos_emp)
destroy(this.pb_refresh_usr_hos)
destroy(this.pb_add_usr_hos)
destroy(this.dw_usr_housing)
end on

type cb_busca_usr_housing from commandbutton within tp_usu_housing
integer x = 1024
integer y = 76
integer width = 229
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;of_retrieve(sle_busca_usr_housing.text, "UH")
end event

type sle_busca_usr_housing from u_sle_codigo within tp_usu_housing
integer x = 41
integer y = 76
integer width = 983
integer height = 88
integer taborder = 50
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;cb_busca_usr_housing.event clicked()
end event

type pb_refreshemp from picturebutton within tp_usu_housing
integer x = 4928
integer y = 52
integer width = 183
integer height = 160
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Toolbar\actualiza.png"
string disabledname = "C:\SIGRE\resources\Toolbar\actualiza.png"
alignment htextalign = right!
string powertiptext = "Actualizar lista"
end type

event clicked;dw_usr_hos_emp.retrieve( gi_usr_hou_id)
end event

type pb_add_emp from picturebutton within tp_usu_housing
integer x = 5106
integer y = 52
integer width = 183
integer height = 160
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Toolbar\note_add.png"
string disabledname = "C:\SIGRE\resources\Toolbar\note_add.png"
alignment htextalign = right!
string powertiptext = "Agrega empresa"
end type

event clicked;Open(w_cw500_empresas_autorizadas)
dw_usr_hos_emp.retrieve( gi_usr_hou_id)
end event

type dw_usr_hos_emp from u_dw_abc within tp_usu_housing
integer x = 3145
integer y = 212
integer width = 2139
integer height = 1448
integer taborder = 20
string dataobject = "d_list_usr_housing_empresa_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_usr_housing				// dw_master
//idw_det  =  				// dw_detail
end event

event buttonclicked;call super::buttonclicked;Long 		ll_usr_housing_id, ll_empresa_id
string 	ls_mensaje

if lower(dwo.name) = 'b_eliminar' then
	ll_usr_housing_id = Long(this.object.usr_housing_id [row])
	ll_empresa_id = Long(this.object.empresa_id [row])
	
	//Preguntar si desea eliminar
	if MessageBox('Aviso', 'Deseas eliminar el registro ' + string(row) + ' con id ' + string(ll_usr_housing_id) + '?', Information!, YesNo!, 2) = 2 then return
	
	Delete usr_housing_empresa
	where  usr_housing_id = :ll_usr_housing_id
		and empresa_id = :ll_empresa_id;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = "No se ha podido eliminar la empresa para este usuario. Mensaje de Error: " + SQLCA.SQLErrText
		ROLLBACK;
		gnvo_app.of_mensaje_error( ls_mensaje )
		return
	end if
	
	commit;
	MessageBox('Aviso', 'Eliminacion realizada satisfactoriamente', Information!)
	
	this.Retrieve(ll_usr_housing_id)
end if
end event

type st_usr_hos_emp from statictext within tp_usu_housing
integer x = 3145
integer y = 132
integer width = 2139
integer height = 64
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "ACCESO A"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_refresh_usr_hos from picturebutton within tp_usu_housing
integer x = 2647
integer y = 52
integer width = 183
integer height = 160
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Toolbar\actualiza.png"
alignment htextalign = right!
string powertiptext = "Actualizar lista"
end type

event clicked;dw_usr_housing.retrieve("" )
end event

type pb_add_usr_hos from picturebutton within tp_usu_housing
integer x = 2821
integer y = 52
integer width = 183
integer height = 160
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Toolbar\note_add.png"
alignment htextalign = right!
string powertiptext = "Agrega usuario"
end type

event clicked;gs_action = 'new'
Open(w_cw002_usuario_housing)
dw_usr_housing.retrieve("" )
end event

type dw_usr_housing from u_dw_abc within tp_usu_housing
integer x = 37
integer y = 212
integer width = 2971
integer height = 1448
integer taborder = 20
string dataobject = "d_list_usuarios_housing_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
this.retrieve("" )
end event

event doubleclicked;call super::doubleclicked;if row = 0 then return

this.SelectRow(0, false)
this.SelectRow(row, true)

gi_usr_hou_id = this.object.usr_housing_id [row]
gs_action = 'open'
Open(w_cw002_usuario_housing)
dw_usr_housing.retrieve("" )
end event

event clicked;call super::clicked;Integer li_usr_housing_id
String ls_flag_empre_ini

if row = 0 then return

this.SelectRow(0, false)
this.SelectRow(row, true)

li_usr_housing_id = this.object.usr_housing_id [row]
ls_flag_empre_ini = this.object.flag_empre_ini			[row]
gi_usr_hou_id = li_usr_housing_id
dw_usr_hos_emp.Retrieve(li_usr_housing_id) 

if ls_flag_empre_ini = '1' then
	pb_add_emp.enabled = false
	pb_refreshemp.enabled = false
	dw_usr_hos_emp.Retrieve(0) 
else
	pb_add_emp.enabled = true
	pb_refreshemp.enabled = true
end if

end event

event buttonclicked;call super::buttonclicked;Long 		ll_usr_housing_id
string 	ls_mensaje

if lower(dwo.name) = 'b_eliminar' then
	ll_usr_housing_id = Long(this.object.usr_housing_id [row])
	
	//Preguntar si desea eliminar
	if MessageBox('Aviso', 'Deseas eliminar el registro ' + string(row) + ' con id ' + string(ll_usr_housing_id) + '?', Information!, YesNo!, 2) = 2 then return
	
	Delete usuarios_housing
	where usr_housing_id = :ll_usr_housing_id;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = "No se ha podido eliminar el usuario. Mensaje de Error: " + SQLCA.SQLErrText
		ROLLBACK;
		gnvo_app.of_mensaje_error( ls_mensaje )
		return
	end if
	
	commit;
	MessageBox('Aviso', 'Eliminacion realizada satisfactoriamente', Information!)
	
	this.Retrieve()
end if
end event

type tp_usuarios from userobject within tab_navigate
integer x = 18
integer y = 112
integer width = 6025
integer height = 1680
long backcolor = 16777215
string text = "Gestión de Usuarios"
long tabtextcolor = 134217856
long tabbackcolor = 16777215
string picturename = "C:\SIGRE\resources\ICO\2016\GerOT.ico"
long picturemaskcolor = 536870912
pb_refresh_usr pb_refresh_usr
pb_add_usr pb_add_usr
dw_usuarios dw_usuarios
end type

on tp_usuarios.create
this.pb_refresh_usr=create pb_refresh_usr
this.pb_add_usr=create pb_add_usr
this.dw_usuarios=create dw_usuarios
this.Control[]={this.pb_refresh_usr,&
this.pb_add_usr,&
this.dw_usuarios}
end on

on tp_usuarios.destroy
destroy(this.pb_refresh_usr)
destroy(this.pb_add_usr)
destroy(this.dw_usuarios)
end on

type pb_refresh_usr from picturebutton within tp_usuarios
integer x = 2194
integer y = 52
integer width = 183
integer height = 160
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Toolbar\actualiza.png"
alignment htextalign = right!
string powertiptext = "Actualizar listado"
end type

event clicked;idw_usuarios.retrieve( )
end event

type pb_add_usr from picturebutton within tp_usuarios
integer x = 2373
integer y = 52
integer width = 183
integer height = 160
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Toolbar\note_add.png"
alignment htextalign = right!
string powertiptext = "Registrar nueva empresa"
end type

event clicked;gs_action = 'new'
Open(w_cw007_usuarios)
dw_usuarios.retrieve( )
end event

type dw_usuarios from u_dw_abc within tp_usuarios
integer x = 23
integer y = 212
integer width = 2533
integer height = 1448
integer taborder = 20
string dataobject = "d_list_usuarios_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
this.retrieve( )
end event

event doubleclicked;call super::doubleclicked;if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

ii_usuario_id = this.object.usuario_id [row]

gs_action = 'open'
Open(w_cw007_usuarios)
this.retrieve( )
end event

event buttonclicked;call super::buttonclicked;Long 		ll_usuario_id
string 	ls_mensaje

if lower(dwo.name) = 'b_eliminar' then
	ll_usuario_id = Long(this.object.usuario_id [row])
	
	//Preguntar si desea eliminar
	if MessageBox('Aviso', 'Deseas eliminar el registro ' + string(row) + ' con id ' + string(ll_usuario_id) + '?', Information!, YesNo!, 2) = 2 then return
	
	Delete usuarios
	where usuario_id = :ll_usuario_id;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = "No se ha podido eliminar el usuario. Mensaje de Error: " + SQLCA.SQLErrText
		ROLLBACK;
		gnvo_app.of_mensaje_error( ls_mensaje )
		return
	end if
	
	commit;
	MessageBox('Aviso', 'Eliminacion realizada satisfactoriamente', Information!)
	
	this.Retrieve()
end if
end event

type tp_venc_renta from userobject within tab_navigate
integer x = 18
integer y = 112
integer width = 6025
integer height = 1680
long backcolor = 16777215
string text = "Cronograma Renta"
long tabtextcolor = 134217856
long tabbackcolor = 16777215
string picturename = "C:\SIGRE\resources\ICO\2016\Presupuesto.ico"
long picturemaskcolor = 536870912
dw_rpt_mensual dw_rpt_mensual
pb_add_venc_renta pb_add_venc_renta
pb_refresh_venc_renta pb_refresh_venc_renta
dw_venc_renta dw_venc_renta
em_periodo em_periodo
st_periodo st_periodo
rb_anual rb_anual
rb_mensual rb_mensual
gb_mens_anual gb_mens_anual
end type

on tp_venc_renta.create
this.dw_rpt_mensual=create dw_rpt_mensual
this.pb_add_venc_renta=create pb_add_venc_renta
this.pb_refresh_venc_renta=create pb_refresh_venc_renta
this.dw_venc_renta=create dw_venc_renta
this.em_periodo=create em_periodo
this.st_periodo=create st_periodo
this.rb_anual=create rb_anual
this.rb_mensual=create rb_mensual
this.gb_mens_anual=create gb_mens_anual
this.Control[]={this.dw_rpt_mensual,&
this.pb_add_venc_renta,&
this.pb_refresh_venc_renta,&
this.dw_venc_renta,&
this.em_periodo,&
this.st_periodo,&
this.rb_anual,&
this.rb_mensual,&
this.gb_mens_anual}
end on

on tp_venc_renta.destroy
destroy(this.dw_rpt_mensual)
destroy(this.pb_add_venc_renta)
destroy(this.pb_refresh_venc_renta)
destroy(this.dw_venc_renta)
destroy(this.em_periodo)
destroy(this.st_periodo)
destroy(this.rb_anual)
destroy(this.rb_mensual)
destroy(this.gb_mens_anual)
end on

type dw_rpt_mensual from u_dw_abc within tp_venc_renta
integer x = 1874
integer y = 4
integer width = 4142
integer height = 1660
integer taborder = 20
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

type pb_add_venc_renta from picturebutton within tp_venc_renta
integer x = 1669
integer y = 300
integer width = 183
integer height = 160
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Toolbar\note_add.png"
alignment htextalign = right!
string powertiptext = "Agrega usuario"
end type

event clicked;gs_action = 'new'
Open(w_cw008_venc_renta)
of_carga_dw_venc_renta( )
end event

type pb_refresh_venc_renta from picturebutton within tp_venc_renta
integer x = 1490
integer y = 300
integer width = 183
integer height = 160
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Toolbar\actualiza.png"
alignment htextalign = right!
string powertiptext = "Actualizar lista"
end type

event clicked;of_carga_dw_venc_renta( )
end event

type dw_venc_renta from u_dw_abc within tp_venc_renta
integer x = 5
integer y = 472
integer width = 1847
integer height = 1200
integer taborder = 20
string dataobject = "d_lista_venc_renta_mensual_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event doubleclicked;call super::doubleclicked;if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

is_ult_dig 			= this.object.ult_dig_ruc						[row]
is_mensual_anual	= this.object.flag_mensual_anual			[row]
is_bue_contrib		= this.object.flag_buen_contribuyente	[row]
ii_mes				= this.object.mes								[row]

gs_action = 'open'
Open(w_cw008_venc_renta)
of_carga_dw_venc_renta( )
end event

type em_periodo from editmask within tp_venc_renta
integer x = 219
integer y = 332
integer width = 279
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean autoskip = true
boolean spin = true
double increment = 1
string minmax = "2015~~9999"
end type

event modified;of_carga_dw_venc_renta( )
end event

type st_periodo from statictext within tp_venc_renta
integer x = 5
integer y = 348
integer width = 224
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Periodo :"
boolean focusrectangle = false
end type

type rb_anual from radiobutton within tp_venc_renta
integer x = 37
integer y = 148
integer width = 1751
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "DECLARACION Y PAGO DE REGULARIZACION IMPUESTO A LA RENTA e ITF"
boolean lefttext = true
end type

event clicked;of_carga_dw_venc_renta( )
end event

type rb_mensual from radiobutton within tp_venc_renta
integer x = 37
integer y = 56
integer width = 1751
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "CRONOGRAMA DE OBLIGACIONES ENSUALES"
boolean checked = true
boolean lefttext = true
end type

event clicked;of_carga_dw_venc_renta( )
end event

type gb_mens_anual from groupbox within tp_venc_renta
integer x = 5
integer y = 4
integer width = 1847
integer height = 244
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
end type

type tp_versiones from userobject within tab_navigate
integer x = 18
integer y = 112
integer width = 6025
integer height = 1680
long backcolor = 16777215
string text = "Modulos y Versiones"
long tabtextcolor = 134217856
long tabbackcolor = 16777215
string picturename = "C:\SIGRE\resources\ICO\2016\Almacen.ico"
long picturemaskcolor = 536870912
st_1 st_1
pb_gestion_modulos pb_gestion_modulos
pb_1 pb_1
pb_add_version pb_add_version
pb_refresh_version pb_refresh_version
st_version_modulos st_version_modulos
dw_versiones_modulo dw_versiones_modulo
dw_versiones dw_versiones
p_2 p_2
end type

on tp_versiones.create
this.st_1=create st_1
this.pb_gestion_modulos=create pb_gestion_modulos
this.pb_1=create pb_1
this.pb_add_version=create pb_add_version
this.pb_refresh_version=create pb_refresh_version
this.st_version_modulos=create st_version_modulos
this.dw_versiones_modulo=create dw_versiones_modulo
this.dw_versiones=create dw_versiones
this.p_2=create p_2
this.Control[]={this.st_1,&
this.pb_gestion_modulos,&
this.pb_1,&
this.pb_add_version,&
this.pb_refresh_version,&
this.st_version_modulos,&
this.dw_versiones_modulo,&
this.dw_versiones,&
this.p_2}
end on

on tp_versiones.destroy
destroy(this.st_1)
destroy(this.pb_gestion_modulos)
destroy(this.pb_1)
destroy(this.pb_add_version)
destroy(this.pb_refresh_version)
destroy(this.st_version_modulos)
destroy(this.dw_versiones_modulo)
destroy(this.dw_versiones)
destroy(this.p_2)
end on

type st_1 from statictext within tp_versiones
integer x = 306
integer y = 84
integer width = 1061
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 16777215
string text = "GESTION DE MODULOS"
boolean focusrectangle = false
end type

type pb_gestion_modulos from picturebutton within tp_versiones
integer x = 5
integer y = 36
integer width = 183
integer height = 160
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Gif\ORDPROC.GIF"
alignment htextalign = left!
vtextalign vtextalign = top!
end type

event clicked;Open(w_cw502_modulos)
end event

type pb_1 from picturebutton within tp_versiones
integer x = 2386
integer y = 32
integer width = 183
integer height = 160
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Toolbar\compras.jpg"
alignment htextalign = right!
string powertiptext = "Asignar Módulo"
end type

event clicked;Long	ll_row
String ls_flag_estado, ls_flag_autorizado
str_parametros sl_param

ll_row = idw_versiones.getselectedrow( 0)
if ll_row = 0 then return

sl_param.int1	= idw_versiones.object.version_id [ll_row]

idw_versiones.Accepttext()

OpenWithParm( w_cw302_versiones_modulo, sl_param)
dw_versiones_modulo.Retrieve(sl_param.int1)

end event

type pb_add_version from picturebutton within tp_versiones
integer x = 2203
integer y = 32
integer width = 183
integer height = 160
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Toolbar\note_add.png"
alignment htextalign = right!
string powertiptext = "Registrar nueva versión"
end type

event clicked;gs_action = 'new'
Open(w_cw009_versiones)
idw_versiones.retrieve( )
end event

type pb_refresh_version from picturebutton within tp_versiones
integer x = 2021
integer y = 32
integer width = 183
integer height = 160
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Toolbar\actualiza.png"
alignment htextalign = right!
string powertiptext = "Actualizar listado"
end type

event clicked;idw_versiones.retrieve( )
idw_versiones_modulo.retrieve(0 )
st_version_modulos.text = "..."
end event

type st_version_modulos from statictext within tp_versiones
integer x = 2670
integer y = 112
integer width = 2944
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "..."
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_versiones_modulo from u_dw_abc within tp_versiones
integer x = 2670
integer y = 200
integer width = 2944
integer height = 1432
integer taborder = 20
string dataobject = "d_lista_versiones_modulo_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1]	= 3

idw_mst  = 		dw_versiones
//idw_det  =  				// dw_detail
end event

type dw_versiones from u_dw_abc within tp_versiones
integer x = 5
integer y = 200
integer width = 2565
integer height = 1432
integer taborder = 20
string dataobject = "d_lista_versiones_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
idw_det  =  dw_versiones_modulo
this.retrieve( )
end event

event clicked;//Override
if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

idw_versiones_modulo.retrieve(this.object.version_id		[row])
st_version_modulos.text = "MODULOS QUE COMPONEN LA VERSION " + UPPER(this.object.descripcion[row])
//gs_empresa = tab_navigate.tp_empresas.dw_empresas.object.cod_empresa [row]
end event

event doubleclicked;call super::doubleclicked;str_parametros sl_param

if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

sl_param.int1	= idw_versiones.object.version_id [row]

gs_action = 'open'
idw_versiones.Accepttext()

OpenWithParm( w_cw009_versiones, sl_param)
dw_versiones.Retrieve()
end event

type p_2 from picture within tp_versiones
integer x = 187
integer y = 76
integer width = 110
integer height = 68
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\PNG\fecha1.png"
boolean focusrectangle = false
end type

type p_logo from picture within w_consola
integer x = 18
integer width = 1376
integer height = 580
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_consola
integer y = 548
integer width = 6107
integer height = 1896
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
end type

type pb_salir from picturebutton within w_consola
integer x = 5902
integer y = 32
integer width = 178
integer height = 140
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Toolbar\salir.jpg"
alignment htextalign = left!
string powertiptext = "Salir de la aplicación"
end type

event clicked;Close(parent)
end event

type p_cabecera from picture within w_consola
integer width = 6139
integer height = 676
string picturename = "C:\SIGRE\resources\PNG\cabecera.png"
boolean focusrectangle = false
end type

type p_1 from picture within w_consola
integer x = 1431
integer y = 384
integer width = 1893
integer height = 164
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\PNG\ConsolaWeb.png"
boolean focusrectangle = false
end type

