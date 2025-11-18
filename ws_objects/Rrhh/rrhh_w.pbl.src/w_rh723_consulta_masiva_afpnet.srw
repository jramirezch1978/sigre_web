$PBExportHeader$w_rh723_consulta_masiva_afpnet.srw
forward
global type w_rh723_consulta_masiva_afpnet from w_rpt
end type
type st_nro_reg from statictext within w_rh723_consulta_masiva_afpnet
end type
type st_3 from statictext within w_rh723_consulta_masiva_afpnet
end type
type pb_1 from picturebutton within w_rh723_consulta_masiva_afpnet
end type
type dw_origen from u_dw_abc within w_rh723_consulta_masiva_afpnet
end type
type dw_report from u_dw_rpt within w_rh723_consulta_masiva_afpnet
end type
end forward

global type w_rh723_consulta_masiva_afpnet from w_rpt
integer width = 3227
integer height = 1336
string title = "[RH723] Consulta Masiva AFP.NET"
string menuname = "m_export"
st_nro_reg st_nro_reg
st_3 st_3
pb_1 pb_1
dw_origen dw_origen
dw_report dw_report
end type
global w_rh723_consulta_masiva_afpnet w_rh723_consulta_masiva_afpnet

type variables
String is_cod_origen, is_ruc_emp
end variables

forward prototypes
public function integer of_ruc_empresa ()
public function boolean of_verificar ()
end prototypes

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

RETURN lb_ok



end function

on w_rh723_consulta_masiva_afpnet.create
int iCurrent
call super::create
if this.MenuName = "m_export" then this.MenuID = create m_export
this.st_nro_reg=create st_nro_reg
this.st_3=create st_3
this.pb_1=create pb_1
this.dw_origen=create dw_origen
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_nro_reg
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.dw_origen
this.Control[iCurrent+5]=this.dw_report
end on

on w_rh723_consulta_masiva_afpnet.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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
end event

event ue_retrieve;call super::ue_retrieve;
IF NOT of_verificar() THEN RETURN

idw_1.SetRedraw(false)

// Llamar a la función para llenar el Ruc de la empresa
IF of_ruc_empresa () = 0 THEN
	messagebox('Aviso', 'Verificar RUC de Empresa')
	RETURN

end if

// Recuperar y mostrar datos
idw_1.Retrieve(is_cod_origen )
idw_1.Visible = True
idw_1.SetRedraw(true)


// Agrega la cantidad de registros
st_nro_reg.text = String( dw_report.Rowcount())

if dw_report.Rowcount( ) > 1 then
	this.event ue_saveas( )
end if

end event

event ue_saveas;// Override
String	ls_FileName, ls_path, ls_inifile
integer 	li_result

ls_inifile = 'i:\sigre_exe\empresas.ini'

if not FileExists(ls_inifile) then
	MessageBox('Error', 'Archivo de configuracion ' + ls_inifile &
								+ ' no existe, por favor Verifique')
	
	return
end if

//Path donde se van a guardar los archivos
ls_path = ProfileString (ls_inifile, "Config_AFPNET", "path","i:\sigre_exe\AFPNET")
ls_FileName = ProfileString (ls_inifile, "Config_AFPNET", "fileConsultaMasiva","ConsultaMasiva")

if not DirectoryExists(ls_path) then
	CreateDirectory(ls_path)
end if

IF dw_report.rowcount( ) < 1 THEN return

if mid(ls_path, len(ls_path),1) <> '\' then
	ls_path += '\'
end if

if pos(ls_FileName, '.') > 0 then
	ls_FileName = mid(ls_FileName, 1, pos(ls_FileName, '.') - 1)
end if

ls_FileName += '.xls'


// colocar la extensión al nombre el archivo
ls_FileName = ls_path + ls_FileName

dw_report.SaveAs(ls_FileName, Excel8! , FALSE)
MessageBox('Aviso', 'Archivo ' + ls_FileName + ' se ha grabado satisfactoriamente')
end event

type st_nro_reg from statictext within w_rh723_consulta_masiva_afpnet
integer x = 1637
integer y = 236
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

type st_3 from statictext within w_rh723_consulta_masiva_afpnet
integer x = 1125
integer y = 244
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

type pb_1 from picturebutton within w_rh723_consulta_masiva_afpnet
integer x = 1431
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

type dw_origen from u_dw_abc within w_rh723_consulta_masiva_afpnet
integer width = 1019
integer height = 348
string dataobject = "d_origenes_tbl"
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type dw_report from u_dw_rpt within w_rh723_consulta_masiva_afpnet
integer y = 384
integer width = 3095
integer height = 660
string dataobject = "d_rpt_consulta_masiva_afpnet"
end type

