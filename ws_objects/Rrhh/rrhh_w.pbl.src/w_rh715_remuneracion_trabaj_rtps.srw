$PBExportHeader$w_rh715_remuneracion_trabaj_rtps.srw
forward
global type w_rh715_remuneracion_trabaj_rtps from w_rpt
end type
type cbx_ajuste from checkbox within w_rh715_remuneracion_trabaj_rtps
end type
type st_4 from statictext within w_rh715_remuneracion_trabaj_rtps
end type
type st_nro_form from statictext within w_rh715_remuneracion_trabaj_rtps
end type
type st_nro_reg from statictext within w_rh715_remuneracion_trabaj_rtps
end type
type st_3 from statictext within w_rh715_remuneracion_trabaj_rtps
end type
type dw_origen from u_dw_abc within w_rh715_remuneracion_trabaj_rtps
end type
type dw_report from u_dw_rpt within w_rh715_remuneracion_trabaj_rtps
end type
type st_ext from statictext within w_rh715_remuneracion_trabaj_rtps
end type
type st_2 from statictext within w_rh715_remuneracion_trabaj_rtps
end type
type st_1 from statictext within w_rh715_remuneracion_trabaj_rtps
end type
type pb_1 from picturebutton within w_rh715_remuneracion_trabaj_rtps
end type
type sle_file from singlelineedit within w_rh715_remuneracion_trabaj_rtps
end type
type em_mes from editmask within w_rh715_remuneracion_trabaj_rtps
end type
type em_year from editmask within w_rh715_remuneracion_trabaj_rtps
end type
type gb_1 from groupbox within w_rh715_remuneracion_trabaj_rtps
end type
end forward

global type w_rh715_remuneracion_trabaj_rtps from w_rpt
integer width = 3959
integer height = 2344
string title = "[RH715] Datos de Remuneración del Trabajador"
string menuname = "m_export"
cbx_ajuste cbx_ajuste
st_4 st_4
st_nro_form st_nro_form
st_nro_reg st_nro_reg
st_3 st_3
dw_origen dw_origen
dw_report dw_report
st_ext st_ext
st_2 st_2
st_1 st_1
pb_1 pb_1
sle_file sle_file
em_mes em_mes
em_year em_year
gb_1 gb_1
end type
global w_rh715_remuneracion_trabaj_rtps w_rh715_remuneracion_trabaj_rtps

type variables
String		is_cod_origen, is_ruc_emp
end variables

forward prototypes
public function boolean of_verificar ()
public function integer of_ruc_empresa ()
protected function integer of_llamar_procedimiento (integer ai_year, integer ai_mes, string as_flag)
end prototypes

public function boolean of_verificar ();// Verifica que no falten parametros para el reporte

long 		ll_i
String 	ls_separador
boolean	lb_ok

is_cod_origen = ''
ls_separador  = ''
lb_ok			  = True

IF em_year.Text = '' OR isNull(em_year.text) THEN
	messagebox('Aviso', 'Por favor seleccione una año')
	return lb_ok = False
END IF

IF em_mes.Text = '' OR isNull(em_mes.text) THEN
	messagebox('Aviso', 'Por favor seleccione una mes')
	return lb_ok = False
END IF

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

protected function integer of_llamar_procedimiento (integer ai_year, integer ai_mes, string as_flag);
SetPointer (HourGlass!)
 
string ls_mensaje, ls_null
 
SetNull(ls_null)

//CREATE OR REPLACE PROCEDURE USP_RRHH_RTPS_REMUN_TEXT
//       ( AN_YEAR            IN RRHH_HIST_MAESTRO.ANO%TYPE,
//         AN_MES             IN RRHH_HIST_MAESTRO.MES%TYPE,
//         AS_COD_ORIGEN      IN VARCHAR2 ,
//         AS_FLAG_REPROCESO  IN VARCHAR2)
         
 
DECLARE USP_RRHH_RTPS_REMUN_TEXT PROCEDURE FOR
 USP_RRHH_RTPS_REMUN_TEXT(  :ai_year,
 									 :ai_mes,
									 :is_cod_origen,
									 :as_flag);
 
EXECUTE USP_RRHH_RTPS_REMUN_TEXT;
 
IF SQLCA.sqlcode = -1 THEN
  ls_mensaje = "PROCEDURE USP_RRHH_RTPS_REMUN_TEXT: " + SQLCA.SQLErrText
  Rollback ;
  MessageBox('SQL error', ls_mensaje, StopSign!) 
  SetPointer (Arrow!)
  RETURN 0
END IF
 
CLOSE USP_RRHH_RTPS_REMUN_TEXT;
 
MessageBox('Aviso', 'Proceso Terminado Satisfactoriamente')
 
SetPointer (Arrow!)

RETURN 1
end function

on w_rh715_remuneracion_trabaj_rtps.create
int iCurrent
call super::create
if this.MenuName = "m_export" then this.MenuID = create m_export
this.cbx_ajuste=create cbx_ajuste
this.st_4=create st_4
this.st_nro_form=create st_nro_form
this.st_nro_reg=create st_nro_reg
this.st_3=create st_3
this.dw_origen=create dw_origen
this.dw_report=create dw_report
this.st_ext=create st_ext
this.st_2=create st_2
this.st_1=create st_1
this.pb_1=create pb_1
this.sle_file=create sle_file
this.em_mes=create em_mes
this.em_year=create em_year
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_ajuste
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.st_nro_form
this.Control[iCurrent+4]=this.st_nro_reg
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.dw_origen
this.Control[iCurrent+7]=this.dw_report
this.Control[iCurrent+8]=this.st_ext
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.pb_1
this.Control[iCurrent+12]=this.sle_file
this.Control[iCurrent+13]=this.em_mes
this.Control[iCurrent+14]=this.em_year
this.Control[iCurrent+15]=this.gb_1
end on

on w_rh715_remuneracion_trabaj_rtps.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_ajuste)
destroy(this.st_4)
destroy(this.st_nro_form)
destroy(this.st_nro_reg)
destroy(this.st_3)
destroy(this.dw_origen)
destroy(this.dw_report)
destroy(this.st_ext)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.pb_1)
destroy(this.sle_file)
destroy(this.em_mes)
destroy(this.em_year)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)

dw_origen.SettransObject( sqlca )
dw_origen.Retrieve( )

//Setear fecha
em_year.text = STRING(f_fecha_actual(),'yyyy')
em_mes.text  = STRING(f_fecha_actual(),'mm')




end event

event ue_retrieve;call super::ue_retrieve;
integer 	li_year, li_mes
String 	ls_flag_reproceso, ls_ruc, ls_flag_ajuste, ls_mensaje


IF NOT of_verificar() THEN RETURN

idw_1.SetRedraw(false)

// Obtener datos de la fecha
li_year = integer(em_year.text)
li_mes = integer(em_mes.text)


// Llamar a la función para llenar el Ruc de la empresa
IF of_ruc_empresa () = 0 THEN
	messagebox('Aviso', 'Verificar RUC de Empresa', StopSign!)
	RETURN
end if

ls_ruc = is_ruc_emp

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

// Armar el nombre del archivo
sle_file.text = trim(st_nro_form.text) + String(li_year) + &
					String(li_mes, '00') + Trim(ls_ruc)

// Recuperar y mostrar datos
idw_1.Retrieve(li_year, li_mes, is_cod_origen )
idw_1.Visible = True
idw_1.SetRedraw(true)

// Agrega la cantidad de registros
st_nro_reg.text = String( dw_report.Rowcount())

if dw_report.Rowcount() > 0 then
	this.event ue_saveas( )
end if


end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
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
ls_path = ProfileString (gs_inifile, "Config_RTPS", "path","i:\sigre_exe\RTPS")
ls_FileName = sle_file.text + st_ext.text

if not DirectoryExists(ls_path) then
	CreateDirectory(ls_path)
end if

IF dw_report.rowcount( ) < 1 THEN return

if mid(ls_path, len(ls_path),1) <> '\' then
	ls_path += '\'
end if

// colocar la extensión al nombre el archivo
ls_FileName = ls_path + ls_FileName 

if dw_report.SaveAs(ls_FileName, Text! , FALSE) = 1 then
	MessageBox('Aviso', 'Archivo ' + ls_FileName + ' se ha grabado satisfactoriamente', Information!)
else
	MessageBox('Error', 'No se ha podido guardar correctamente el Archivo ' + ls_FileName + ', por favor verifique!', StopSign!)
end if

end event

type cbx_ajuste from checkbox within w_rh715_remuneracion_trabaj_rtps
integer x = 2482
integer y = 232
integer width = 786
integer height = 76
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

type st_4 from statictext within w_rh715_remuneracion_trabaj_rtps
integer x = 763
integer y = 48
integer width = 379
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formulario Nº:"
boolean focusrectangle = false
end type

type st_nro_form from statictext within w_rh715_remuneracion_trabaj_rtps
integer x = 1157
integer y = 36
integer width = 174
integer height = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "0601"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_nro_reg from statictext within w_rh715_remuneracion_trabaj_rtps
integer x = 2994
integer y = 336
integer width = 261
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

type st_3 from statictext within w_rh715_remuneracion_trabaj_rtps
integer x = 2505
integer y = 344
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

type dw_origen from u_dw_abc within w_rh715_remuneracion_trabaj_rtps
integer x = 1435
integer y = 12
integer width = 1019
integer height = 408
string dataobject = "d_origenes_tbl"
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type dw_report from u_dw_rpt within w_rh715_remuneracion_trabaj_rtps
integer y = 460
integer width = 3182
integer height = 1644
integer taborder = 40
string dataobject = "dw_rpt_datos_rem_text_rtps"
end type

type st_ext from statictext within w_rh715_remuneracion_trabaj_rtps
integer x = 1093
integer y = 324
integer width = 155
integer height = 88
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = ".rem"
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh715_remuneracion_trabaj_rtps
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

type st_1 from statictext within w_rh715_remuneracion_trabaj_rtps
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

type pb_1 from picturebutton within w_rh715_remuneracion_trabaj_rtps
integer x = 2793
integer y = 44
integer width = 389
integer height = 160
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\procesar_enb.bmp"
alignment htextalign = left!
end type

event clicked;Parent.event ue_retrieve()
end event

type sle_file from singlelineedit within w_rh715_remuneracion_trabaj_rtps
integer x = 101
integer y = 324
integer width = 974
integer height = 88
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type em_mes from editmask within w_rh715_remuneracion_trabaj_rtps
integer x = 274
integer y = 136
integer width = 361
integer height = 92
integer taborder = 20
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

type em_year from editmask within w_rh715_remuneracion_trabaj_rtps
integer x = 274
integer y = 28
integer width = 361
integer height = 92
integer taborder = 10
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

type gb_1 from groupbox within w_rh715_remuneracion_trabaj_rtps
integer x = 41
integer y = 256
integer width = 1285
integer height = 184
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Archivo Text"
end type

