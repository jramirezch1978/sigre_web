$PBExportHeader$w_rh714_recibos_honorarios_rtps.srw
forward
global type w_rh714_recibos_honorarios_rtps from w_rpt
end type
type rb_2 from radiobutton within w_rh714_recibos_honorarios_rtps
end type
type rb_1 from radiobutton within w_rh714_recibos_honorarios_rtps
end type
type st_nro_form from statictext within w_rh714_recibos_honorarios_rtps
end type
type st_4 from statictext within w_rh714_recibos_honorarios_rtps
end type
type em_year from editmask within w_rh714_recibos_honorarios_rtps
end type
type em_mes from editmask within w_rh714_recibos_honorarios_rtps
end type
type st_1 from statictext within w_rh714_recibos_honorarios_rtps
end type
type st_2 from statictext within w_rh714_recibos_honorarios_rtps
end type
type pb_1 from picturebutton within w_rh714_recibos_honorarios_rtps
end type
type st_3 from statictext within w_rh714_recibos_honorarios_rtps
end type
type st_nro_reg from statictext within w_rh714_recibos_honorarios_rtps
end type
type sle_ruc from singlelineedit within w_rh714_recibos_honorarios_rtps
end type
type st_ext from statictext within w_rh714_recibos_honorarios_rtps
end type
type dw_origen from u_dw_abc within w_rh714_recibos_honorarios_rtps
end type
type dw_report from u_dw_rpt within w_rh714_recibos_honorarios_rtps
end type
type gb_1 from groupbox within w_rh714_recibos_honorarios_rtps
end type
type gb_2 from groupbox within w_rh714_recibos_honorarios_rtps
end type
end forward

global type w_rh714_recibos_honorarios_rtps from w_rpt
integer width = 3680
integer height = 2196
string title = "[RH714] Recibos de 4ta Categoría"
string menuname = "m_export"
rb_2 rb_2
rb_1 rb_1
st_nro_form st_nro_form
st_4 st_4
em_year em_year
em_mes em_mes
st_1 st_1
st_2 st_2
pb_1 pb_1
st_3 st_3
st_nro_reg st_nro_reg
sle_ruc sle_ruc
st_ext st_ext
dw_origen dw_origen
dw_report dw_report
gb_1 gb_1
gb_2 gb_2
end type
global w_rh714_recibos_honorarios_rtps w_rh714_recibos_honorarios_rtps

type variables
String is_cod_origen, is_ruc_emp
end variables

forward prototypes
public function boolean of_verificar ()
public function integer of_ruc_empresa ()
end prototypes

public function boolean of_verificar ();// Verifica que no falten parametros para el reporte

long 		ll_i
String 	ls_separador
boolean	lb_ok

is_cod_origen = ''
ls_separador  = ''
lb_ok			  = True

// Verificar que se ingrese año y mes
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

on w_rh714_recibos_honorarios_rtps.create
int iCurrent
call super::create
if this.MenuName = "m_export" then this.MenuID = create m_export
this.rb_2=create rb_2
this.rb_1=create rb_1
this.st_nro_form=create st_nro_form
this.st_4=create st_4
this.em_year=create em_year
this.em_mes=create em_mes
this.st_1=create st_1
this.st_2=create st_2
this.pb_1=create pb_1
this.st_3=create st_3
this.st_nro_reg=create st_nro_reg
this.sle_ruc=create sle_ruc
this.st_ext=create st_ext
this.dw_origen=create dw_origen
this.dw_report=create dw_report
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.st_nro_form
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.em_year
this.Control[iCurrent+6]=this.em_mes
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.st_nro_reg
this.Control[iCurrent+12]=this.sle_ruc
this.Control[iCurrent+13]=this.st_ext
this.Control[iCurrent+14]=this.dw_origen
this.Control[iCurrent+15]=this.dw_report
this.Control[iCurrent+16]=this.gb_1
this.Control[iCurrent+17]=this.gb_2
end on

on w_rh714_recibos_honorarios_rtps.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.st_nro_form)
destroy(this.st_4)
destroy(this.em_year)
destroy(this.em_mes)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.pb_1)
destroy(this.st_3)
destroy(this.st_nro_reg)
destroy(this.sle_ruc)
destroy(this.st_ext)
destroy(this.dw_origen)
destroy(this.dw_report)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event resize;call super::resize;dw_report.width  = newwidth - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

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
String	ls_ruc, ls_mensaje
Integer	li_year, li_mes

IF NOT of_verificar() THEN RETURN

idw_1.SetRedraw(false)

// Llamar a la función para llenar el Ruc de la empresa
IF of_ruc_empresa () = 0 THEN
	messagebox('Aviso', 'Verificar RUC de Empresa')
	RETURN
ELSE
	ls_ruc = is_ruc_emp
END IF

// Obtener los datos del mes y año
li_year = Integer(em_year.text)
li_mes  = Integer(em_mes.text)

// Armar el nombre del archivo
sle_ruc.text = trim(st_nro_form.text) + Trim(String(li_year)) + &
					trim(String(li_mes, '00')) + Trim(ls_ruc)


// Recuperar y mostrar datos
if rb_1.checked then
	idw_1.DataObject = 'd_rpt_recibos_honorarios_fpago_rtps'
else
	idw_1.DataObject = 'd_rpt_recibos_honorarios_fprovision_rtps'
end if

idw_1.SetTransObject(SQLCA)
idw_1.Retrieve(li_year, li_mes, is_cod_origen )
idw_1.Visible = True
idw_1.SetRedraw(true)


// Agrega la cantidad de registros
st_nro_reg.text = String( dw_report.Rowcount())

this.event ue_saveas( )


end event

event ue_saveas;// Override
String	ls_nombre, ls_path
integer 	li_result

ls_nombre = sle_ruc.text + st_ext.text

ls_path = 'i:\sigre_exe\RTPS'

if not DirectoryExists(ls_path) then
	CreateDirectory(ls_path)
end if

IF dw_report.rowcount( ) < 1 THEN return

//li_result = GetFolder( "Seleccione Directorio", ls_path )

// colocar la extensión al nombre el archivo
ls_nombre = ls_path +'\'+ ls_nombre 

dw_report.SaveAs(ls_nombre, Text! , FALSE)
MessageBox('Aviso', 'Archivo ' + ls_nombre + ' se ha grabado satisfactoriamente')
end event

type rb_2 from radiobutton within w_rh714_recibos_honorarios_rtps
integer x = 2761
integer y = 80
integer width = 462
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Periodo Provision"
end type

type rb_1 from radiobutton within w_rh714_recibos_honorarios_rtps
integer x = 2354
integer y = 80
integer width = 448
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Periodo Pago"
boolean checked = true
end type

type st_nro_form from statictext within w_rh714_recibos_honorarios_rtps
integer x = 1047
integer y = 28
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

type st_4 from statictext within w_rh714_recibos_honorarios_rtps
integer x = 654
integer y = 40
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

type em_year from editmask within w_rh714_recibos_honorarios_rtps
integer x = 165
integer y = 28
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
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
boolean spin = true
double increment = 1
string minmax = "2000~~2050"
end type

type em_mes from editmask within w_rh714_recibos_honorarios_rtps
integer x = 165
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

type st_1 from statictext within w_rh714_recibos_honorarios_rtps
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

type st_2 from statictext within w_rh714_recibos_honorarios_rtps
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

type pb_1 from picturebutton within w_rh714_recibos_honorarios_rtps
integer x = 2789
integer y = 236
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

event clicked;SetPointer(HourGlass!)
Parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type st_3 from statictext within w_rh714_recibos_honorarios_rtps
integer x = 567
integer y = 144
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

type st_nro_reg from statictext within w_rh714_recibos_honorarios_rtps
integer x = 1047
integer y = 136
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

type sle_ruc from singlelineedit within w_rh714_recibos_honorarios_rtps
integer x = 59
integer y = 360
integer width = 786
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

type st_ext from statictext within w_rh714_recibos_honorarios_rtps
integer x = 850
integer y = 360
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
string text = ".4ta"
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_origen from u_dw_abc within w_rh714_recibos_honorarios_rtps
integer x = 1257
integer width = 1019
integer height = 460
string dataobject = "d_origenes_tbl"
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type dw_report from u_dw_rpt within w_rh714_recibos_honorarios_rtps
integer y = 496
integer width = 3095
integer height = 1032
string dataobject = "d_rpt_recibos_honorarios_fpago_rtps"
end type

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row( this )
end event

type gb_1 from groupbox within w_rh714_recibos_honorarios_rtps
integer x = 2290
integer width = 942
integer height = 216
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Elegir periodo"
end type

type gb_2 from groupbox within w_rh714_recibos_honorarios_rtps
integer y = 292
integer width = 1147
integer height = 184
integer taborder = 40
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

