$PBExportHeader$w_rh708_datos_derechohabiente_rtps.srw
forward
global type w_rh708_datos_derechohabiente_rtps from w_rpt
end type
type st_nro_reg from statictext within w_rh708_datos_derechohabiente_rtps
end type
type st_3 from statictext within w_rh708_datos_derechohabiente_rtps
end type
type dw_origen from u_dw_abc within w_rh708_datos_derechohabiente_rtps
end type
type dw_report from u_dw_rpt within w_rh708_datos_derechohabiente_rtps
end type
type st_ext from statictext within w_rh708_datos_derechohabiente_rtps
end type
type st_2 from statictext within w_rh708_datos_derechohabiente_rtps
end type
type st_1 from statictext within w_rh708_datos_derechohabiente_rtps
end type
type pb_1 from picturebutton within w_rh708_datos_derechohabiente_rtps
end type
type cbx_reproceso from checkbox within w_rh708_datos_derechohabiente_rtps
end type
type sle_ruc from singlelineedit within w_rh708_datos_derechohabiente_rtps
end type
type em_mes from editmask within w_rh708_datos_derechohabiente_rtps
end type
type em_year from editmask within w_rh708_datos_derechohabiente_rtps
end type
type gb_1 from groupbox within w_rh708_datos_derechohabiente_rtps
end type
end forward

global type w_rh708_datos_derechohabiente_rtps from w_rpt
integer width = 3310
integer height = 2344
string title = "[RH708] Datos de  Derechohabientes"
string menuname = "m_export"
long backcolor = 67108864
st_nro_reg st_nro_reg
st_3 st_3
dw_origen dw_origen
dw_report dw_report
st_ext st_ext
st_2 st_2
st_1 st_1
pb_1 pb_1
cbx_reproceso cbx_reproceso
sle_ruc sle_ruc
em_mes em_mes
em_year em_year
gb_1 gb_1
end type
global w_rh708_datos_derechohabiente_rtps w_rh708_datos_derechohabiente_rtps

type variables
String		is_cod_origen, is_ruc_emp
end variables

forward prototypes
public function boolean of_verificar ()
public function integer of_llamar_procedimiento (integer ai_year, integer ai_mes, string as_flag)
public function integer of_ruc_empresa ()
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

public function integer of_llamar_procedimiento (integer ai_year, integer ai_mes, string as_flag);
SetPointer (HourGlass!)
 
string ls_mensaje, ls_null
 
SetNull(ls_null)
//CREATE OR REPLACE PROCEDURE USP_RRHH_RTPS_DERECHOHBIENTE
//       ( AN_YEAR            IN RRHH_HIST_MAESTRO.ANO%TYPE,
//         AN_MES             IN RRHH_HIST_MAESTRO.MES%TYPE,
//         AS_COD_ORIGEN      IN VARCHAR2 ,
//         AS_FLAG_REPROCESO  IN VARCHAR2)
 
DECLARE USP_RRHH_RTPS_DERECHOHBIENTE PROCEDURE FOR
 USP_RRHH_RTPS_DERECHOHBIENTE(  :ai_year,
 										  :ai_mes,
										  :is_cod_origen,
										  :as_flag);
 
EXECUTE USP_RRHH_RTPS_DERECHOHBIENTE;
 
IF SQLCA.sqlcode = -1 THEN
  ls_mensaje = "PROCEDURE USP_RRHH_RTPS_DERECHOHBIENTE: " + SQLCA.SQLErrText
  Rollback ;
  MessageBox('SQL error', ls_mensaje, StopSign!) 
  SetPointer (Arrow!)
  RETURN 0
END IF
 
CLOSE USP_RRHH_RTPS_DERECHOHBIENTE;
 
MessageBox('Aviso', 'Proceso Terminado Satisfactoriamente')
 
SetPointer (Arrow!)

RETURN 1
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

on w_rh708_datos_derechohabiente_rtps.create
int iCurrent
call super::create
if this.MenuName = "m_export" then this.MenuID = create m_export
this.st_nro_reg=create st_nro_reg
this.st_3=create st_3
this.dw_origen=create dw_origen
this.dw_report=create dw_report
this.st_ext=create st_ext
this.st_2=create st_2
this.st_1=create st_1
this.pb_1=create pb_1
this.cbx_reproceso=create cbx_reproceso
this.sle_ruc=create sle_ruc
this.em_mes=create em_mes
this.em_year=create em_year
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_nro_reg
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.dw_origen
this.Control[iCurrent+4]=this.dw_report
this.Control[iCurrent+5]=this.st_ext
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.cbx_reproceso
this.Control[iCurrent+10]=this.sle_ruc
this.Control[iCurrent+11]=this.em_mes
this.Control[iCurrent+12]=this.em_year
this.Control[iCurrent+13]=this.gb_1
end on

on w_rh708_datos_derechohabiente_rtps.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_nro_reg)
destroy(this.st_3)
destroy(this.dw_origen)
destroy(this.dw_report)
destroy(this.st_ext)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.pb_1)
destroy(this.cbx_reproceso)
destroy(this.sle_ruc)
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
Decimal 	ldec_year, ldec_mes
String 	ls_flag_reproceso


IF NOT of_verificar() THEN RETURN

idw_1.SetRedraw(false)

// Obtener datos de la fecha
em_year.getdata( ldec_year)
em_mes.getdata ( ldec_mes)

//Obtiene el dato del reproceso
IF cbx_reproceso.checked THEN
	ls_flag_reproceso = '1'
ELSE
	ls_flag_reproceso = '0'
END IF

// Llamar a la función para llenar el Ruc de la empresa
IF of_ruc_empresa () = 0 THEN
	messagebox('Aviso', 'Verificar RUC de Empresa')
	RETURN
ELSE
	sle_ruc.text = is_ruc_emp
END IF

// Llamar al procedimiento para llenar el dw
of_llamar_procedimiento(ldec_year, ldec_mes, ls_flag_reproceso)

// Recuperar y mostrar datos
idw_1.Retrieve( )
idw_1.Visible = True
idw_1.SetRedraw(true)

//Activa el check para el reproceso
IF dw_report.rowcount( ) > 0 THEN
	cbx_reproceso.Enabled = True
ELSE
	cbx_reproceso.Enabled = False
END IF

// Agrega la cantidad de registros

st_nro_reg.text = String( dw_report.Rowcount())


end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_saveas;// Override

String	ls_nombre, ls_path
integer 	li_result

ls_nombre = sle_ruc.text + st_ext.text

IF dw_report.rowcount( ) < 1 THEN return



li_result = GetFolder( "Seleccione Directorio", ls_path )

// colocar la extensión al nombre el archivo
ls_nombre = ls_path +'\'+ ls_nombre 

dw_report.SaveAs(ls_nombre, Text! , FALSE)
end event

type st_nro_reg from statictext within w_rh708_datos_derechohabiente_rtps
integer x = 3017
integer y = 336
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

type st_3 from statictext within w_rh708_datos_derechohabiente_rtps
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

type dw_origen from u_dw_abc within w_rh708_datos_derechohabiente_rtps
integer x = 905
integer y = 24
integer width = 1019
integer height = 408
string dataobject = "d_origenes_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type dw_report from u_dw_rpt within w_rh708_datos_derechohabiente_rtps
integer x = 32
integer y = 460
integer width = 3182
integer height = 1644
integer taborder = 40
string dataobject = "dw_rpt_datos_derechohab_text_rtps"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type st_ext from statictext within w_rh708_datos_derechohabiente_rtps
integer x = 535
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
string text = ".der"
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh708_datos_derechohabiente_rtps
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

type st_1 from statictext within w_rh708_datos_derechohabiente_rtps
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

type pb_1 from picturebutton within w_rh708_datos_derechohabiente_rtps
integer x = 2473
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
string picturename = "H:\source\BMP\procesar_enb.bmp"
alignment htextalign = left!
end type

event clicked;Parent.event ue_retrieve()
end event

type cbx_reproceso from checkbox within w_rh708_datos_derechohabiente_rtps
integer x = 2752
integer y = 240
integer width = 448
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Reprocesar"
end type

type sle_ruc from singlelineedit within w_rh708_datos_derechohabiente_rtps
integer x = 101
integer y = 324
integer width = 411
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

type em_mes from editmask within w_rh708_datos_derechohabiente_rtps
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

type em_year from editmask within w_rh708_datos_derechohabiente_rtps
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

type gb_1 from groupbox within w_rh708_datos_derechohabiente_rtps
integer x = 41
integer y = 256
integer width = 690
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

