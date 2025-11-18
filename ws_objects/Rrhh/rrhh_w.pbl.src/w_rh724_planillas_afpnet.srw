$PBExportHeader$w_rh724_planillas_afpnet.srw
forward
global type w_rh724_planillas_afpnet from w_rpt
end type
type cb_semanas from commandbutton within w_rh724_planillas_afpnet
end type
type dw_tipo_trabaj from u_dw_abc within w_rh724_planillas_afpnet
end type
type dw_export from datawindow within w_rh724_planillas_afpnet
end type
type em_year from editmask within w_rh724_planillas_afpnet
end type
type em_mes from editmask within w_rh724_planillas_afpnet
end type
type st_1 from statictext within w_rh724_planillas_afpnet
end type
type st_2 from statictext within w_rh724_planillas_afpnet
end type
type st_nro_reg from statictext within w_rh724_planillas_afpnet
end type
type st_3 from statictext within w_rh724_planillas_afpnet
end type
type pb_1 from picturebutton within w_rh724_planillas_afpnet
end type
type dw_origen from u_dw_abc within w_rh724_planillas_afpnet
end type
type dw_report from u_dw_rpt within w_rh724_planillas_afpnet
end type
end forward

global type w_rh724_planillas_afpnet from w_rpt
integer width = 4050
integer height = 1336
string title = "[RH724] Planilla para Afp NET"
string menuname = "m_export"
event ue_semanas ( )
event ue_save_semanas ( u_ds_base ads_semanas )
cb_semanas cb_semanas
dw_tipo_trabaj dw_tipo_trabaj
dw_export dw_export
em_year em_year
em_mes em_mes
st_1 st_1
st_2 st_2
st_nro_reg st_nro_reg
st_3 st_3
pb_1 pb_1
dw_origen dw_origen
dw_report dw_report
end type
global w_rh724_planillas_afpnet w_rh724_planillas_afpnet

type variables
String is_cod_origen, is_ruc_emp, is_tipo_trabaj
n_cst_utilitario 	invo_util
end variables

forward prototypes
public function integer of_ruc_empresa ()
public function boolean of_verificar ()
end prototypes

event ue_semanas();integer li_year, li_mes
u_ds_base ds_Semanas

try 
	
	IF NOT of_verificar() THEN RETURN
	
	
	li_year = integer(em_year.text)
	li_mes = integer(em_mes.text)
	
	if li_year <= 0 then
		MessageBox('Error', 'Debe especificar un año')
		em_year.setfocus( )
		return
	end if
	
	if li_mes <= 0 then
		MessageBox('Error', 'Debe especificar un año')
		em_mes.setfocus( )
		return
	end if
	
	ds_semanas = create u_ds_base
	ds_semanas.DataObject = 'd_afp_net_semana_contributiva_tbl'
	ds_Semanas.setTransObject(SQLCA)
	
	// Recuperar y mostrar datos
	ds_Semanas.Retrieve(is_cod_origen, is_tipo_trabaj, li_year, li_mes )
	
	
	
	// Agrega la cantidad de registros
	st_nro_reg.text = String( dw_export.Rowcount())
	
	if ds_Semanas.Rowcount( ) > 1 then
		this.event ue_save_semanas( ds_semanas )
	end if

catch ( Exception ex )
	gnvo_app.of_Catch_exception( ex, "Error al generar archivo de texto de SEMANAS CONTRIBUTIVAS")
finally
	destroy ds_Semanas
end try


end event

event ue_save_semanas(u_ds_base ads_semanas);// Override
String	ls_FileName, ls_path
integer 	li_result

if not FileExists(gs_inifile) then
	MessageBox('Error', 'Archivo de configuracion ' + gs_inifile &
								+ ' no existe, por favor Verifique')
	
	return
end if

//Path donde se van a guardar los archivos
ls_path 		= ProfileString (gs_inifile, "Config_AFPNET", "path","i:\sigre_exe\AFPNET")
ls_FileName = ProfileString (gs_inifile, "Config_AFPNET", "SemanasContributivasAFPNET","SemanasContributivasAFPNet")

ls_path 		= ls_path + '\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla

if not DirectoryExists(ls_path) then
	if not invo_util.of_CreateDirectory(ls_path) then return
end if

//Si no hay registros entonces no tengo nada que exportar
IF ads_semanas.rowcount( ) = 0 THEN return

if mid(ls_path, len(ls_path),1) <> '\' then
	ls_path += '\'
end if

if pos(ls_FileName, '.') > 0 then
	ls_FileName = mid(ls_FileName, 1, pos(ls_FileName, '.') - 1)
end if

ls_FileName += em_year.text + string(integer(em_mes.text), '00') + '.txt'


// colocar la extensión al nombre el archivo
ls_FileName = ls_path + ls_FileName

if ads_semanas.SaveAs(ls_FileName, Text! , FALSE) = 1 then
	MessageBox('Aviso', 'Archivo ' + ls_FileName + ' se ha grabado satisfactoriamente')
else
	gnvo_app.of_mensaje_error( "Ha ocurrido un error al grabar el archivo " + ls_FileName)
end if
end event

public function integer of_ruc_empresa ();// Obtengo el codig de empresa en genparam

String	ls_cod_emp

	SELECT cod_empresa
	  Into :ls_cod_emp
	FROM   genparam
	WHERE reckey = '1' ;
	
IF sqlca.sqlcode = 100 THEN
	Messagebox( "Error", "No ha definido parametros en GENPARAM")
	RETURN 0
END IF

SELECT RUC
  INTO :is_ruc_emp
FROM   EMPRESA
WHERE  COD_EMPRESA = :ls_cod_emp ;

IF sqlca.sqlcode = 100 THEN
	Messagebox( "Error", "No ha definido RUC EN TABLA EMPRESA")
	RETURN 0
END IF

RETURN 1
end function

public function boolean of_verificar ();// Verifica que no falten parametros para el reporte

long 		ll_i
String 	ls_separador
boolean	lb_ok

is_cod_origen = ''
ls_separador  = ''
lb_ok			  = True

// leer el dw_origen con los origenes seleccionados

For ll_i = 1 To dw_origen.RowCount()
	If dw_origen.Object.Chec[ll_i] = '1' Then
		if is_cod_origen <>'' THEN ls_separador = ', '
		is_cod_origen = is_cod_origen + ls_separador + dw_origen.Object.cod_origen[ll_i]
	end if
Next

IF LEN(is_cod_origen) = 0 THEN
	messagebox('Generacion Archivos Texto', 'Debe seleccionar al menos un origen para el Reporte')
	return lb_ok = False
END IF

For ll_i = 1 To dw_tipo_trabaj.RowCount()
	If dw_tipo_trabaj.Object.Chec[ll_i] = '1' Then
		if is_tipo_trabaj <>'' THEN ls_separador = ', '
		is_tipo_trabaj = is_tipo_trabaj + ls_separador + dw_tipo_trabaj.Object.tipo_trabajador[ll_i]
	end if
Next

IF LEN(is_tipo_trabaj) = 0 THEN
	messagebox('Generacion Archivos Texto', 'Debe seleccionar al menos un tipo de trabajador para el Reporte')
	return lb_ok = False
END IF

RETURN lb_ok



end function

on w_rh724_planillas_afpnet.create
int iCurrent
call super::create
if this.MenuName = "m_export" then this.MenuID = create m_export
this.cb_semanas=create cb_semanas
this.dw_tipo_trabaj=create dw_tipo_trabaj
this.dw_export=create dw_export
this.em_year=create em_year
this.em_mes=create em_mes
this.st_1=create st_1
this.st_2=create st_2
this.st_nro_reg=create st_nro_reg
this.st_3=create st_3
this.pb_1=create pb_1
this.dw_origen=create dw_origen
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_semanas
this.Control[iCurrent+2]=this.dw_tipo_trabaj
this.Control[iCurrent+3]=this.dw_export
this.Control[iCurrent+4]=this.em_year
this.Control[iCurrent+5]=this.em_mes
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_nro_reg
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.pb_1
this.Control[iCurrent+11]=this.dw_origen
this.Control[iCurrent+12]=this.dw_report
end on

on w_rh724_planillas_afpnet.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_semanas)
destroy(this.dw_tipo_trabaj)
destroy(this.dw_export)
destroy(this.em_year)
destroy(this.em_mes)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_nro_reg)
destroy(this.st_3)
destroy(this.pb_1)
destroy(this.dw_origen)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width  = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)

dw_origen.SettransObject( sqlca )
dw_origen.Retrieve( )

dw_tipo_trabaj.SettransObject( sqlca )
dw_tipo_trabaj.Retrieve( )

//Setear fecha
em_year.text = STRING(f_fecha_actual(),'yyyy')
em_mes.text  = STRING(f_fecha_actual(),'mm')
end event

event ue_retrieve;call super::ue_retrieve;integer li_year, li_mes
IF NOT of_verificar() THEN RETURN

li_year = integer(em_year.text)
li_mes = integer(em_mes.text)

if li_year <= 0 then
	MessageBox('Error', 'Debe especificar un año')
	em_year.setfocus( )
	return
end if

if li_mes <= 0 then
	MessageBox('Error', 'Debe especificar un año')
	em_mes.setfocus( )
	return
end if

idw_1.SetRedraw(false)

// Recuperar y mostrar datos
idw_1.Retrieve(is_cod_origen, is_tipo_trabaj, li_year, li_mes )
dw_export.setTransObject(SQLCA)
dw_export.Retrieve(is_cod_origen, is_tipo_trabaj, li_year, li_mes )
idw_1.Visible = True
idw_1.SetRedraw(true)


// Agrega la cantidad de registros
st_nro_reg.text = String( dw_export.Rowcount())

if dw_export.Rowcount( ) > 0 then
	this.event ue_saveas( )
end if

end event

event ue_saveas;// Override
String	ls_FileName, ls_path
integer 	li_result

if not FileExists(gs_inifile) then
	MessageBox('Error', 'Archivo de configuracion ' + gs_inifile &
								+ ' no existe, por favor Verifique')
	
	return
end if

//Path donde se van a guardar los archivos
ls_path 		= ProfileString (gs_inifile, "Config_AFPNET", "path","i:\sigre_exe\AFPNET")
ls_FileName = ProfileString (gs_inifile, "Config_AFPNET", "filePlanillaAFPNET","PlanAFPNet")

ls_path 		= ls_path + '\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla

if not DirectoryExists(ls_path) then
	if not invo_util.of_CreateDirectory(ls_path) then return
end if

//Si no hay registros entonces no tengo nada que exportar
IF dw_export.rowcount( ) = 0 THEN return

if mid(ls_path, len(ls_path),1) <> '\' then
	ls_path += '\'
end if

if pos(ls_FileName, '.') > 0 then
	ls_FileName = mid(ls_FileName, 1, pos(ls_FileName, '.') - 1)
end if

ls_FileName += em_year.text + string(integer(em_mes.text), '00') + '.txt'


// colocar la extensión al nombre el archivo
ls_FileName = ls_path + ls_FileName

if dw_export.SaveAs(ls_FileName, Text! , FALSE) = 1 then
	MessageBox('Aviso', 'Archivo ' + ls_FileName + ' se ha grabado satisfactoriamente')
else
	gnvo_app.of_mensaje_error( "Ha ocurrido un error al grabar el archivo " + ls_FileName)
end if
end event

type cb_semanas from commandbutton within w_rh724_planillas_afpnet
integer x = 3291
integer y = 16
integer width = 622
integer height = 160
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Semana Contributiva"
end type

event clicked;SetPointer(HourGlass!)
Parent.event ue_semanas()
SetPointer(Arrow!)
end event

type dw_tipo_trabaj from u_dw_abc within w_rh724_planillas_afpnet
integer x = 1691
integer width = 1143
integer height = 348
string dataobject = "d_tipo_trabajador_afpnet_tbl"
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type dw_export from datawindow within w_rh724_planillas_afpnet
boolean visible = false
integer x = 3113
integer y = 876
integer width = 302
integer height = 164
integer taborder = 40
string title = "none"
string dataobject = "d_rpt_planilla_afpnet_exp_tbl"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type em_year from editmask within w_rh724_planillas_afpnet
integer x = 274
integer y = 28
integer width = 361
integer height = 92
integer taborder = 30
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

type em_mes from editmask within w_rh724_planillas_afpnet
integer x = 274
integer y = 136
integer width = 361
integer height = 92
integer taborder = 30
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

type st_1 from statictext within w_rh724_planillas_afpnet
integer x = 110
integer y = 44
integer width = 160
integer height = 60
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

type st_2 from statictext within w_rh724_planillas_afpnet
integer x = 110
integer y = 152
integer width = 160
integer height = 60
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

type st_nro_reg from statictext within w_rh724_planillas_afpnet
integer x = 3314
integer y = 252
integer width = 169
integer height = 92
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

type st_3 from statictext within w_rh724_planillas_afpnet
integer x = 2871
integer y = 260
integer width = 466
integer height = 72
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

type pb_1 from picturebutton within w_rh724_planillas_afpnet
integer x = 2898
integer y = 16
integer width = 389
integer height = 160
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "c:\sigre\resources\BMP\procesar_enb.bmp"
alignment htextalign = left!
end type

event clicked;Parent.event ue_retrieve()
end event

type dw_origen from u_dw_abc within w_rh724_planillas_afpnet
integer x = 663
integer width = 1019
integer height = 348
string dataobject = "d_origenes_tbl"
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type dw_report from u_dw_rpt within w_rh724_planillas_afpnet
integer y = 364
integer width = 3095
integer height = 660
string dataobject = "d_rpt_planilla_afpnet_tbl"
end type

