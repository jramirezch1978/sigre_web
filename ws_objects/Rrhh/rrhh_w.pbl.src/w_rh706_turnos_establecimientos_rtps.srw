$PBExportHeader$w_rh706_turnos_establecimientos_rtps.srw
forward
global type w_rh706_turnos_establecimientos_rtps from w_rpt
end type
type st_nro_reg from statictext within w_rh706_turnos_establecimientos_rtps
end type
type st_3 from statictext within w_rh706_turnos_establecimientos_rtps
end type
type pb_1 from picturebutton within w_rh706_turnos_establecimientos_rtps
end type
type dw_origen from u_dw_abc within w_rh706_turnos_establecimientos_rtps
end type
type st_ext from statictext within w_rh706_turnos_establecimientos_rtps
end type
type sle_ruc from singlelineedit within w_rh706_turnos_establecimientos_rtps
end type
type dw_report from u_dw_rpt within w_rh706_turnos_establecimientos_rtps
end type
type gb_1 from groupbox within w_rh706_turnos_establecimientos_rtps
end type
end forward

global type w_rh706_turnos_establecimientos_rtps from w_rpt
integer width = 3227
integer height = 1336
string title = "[RH706] Turnos de Establecimientos"
string menuname = "m_export"
long backcolor = 67108864
st_nro_reg st_nro_reg
st_3 st_3
pb_1 pb_1
dw_origen dw_origen
st_ext st_ext
sle_ruc sle_ruc
dw_report dw_report
gb_1 gb_1
end type
global w_rh706_turnos_establecimientos_rtps w_rh706_turnos_establecimientos_rtps

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

on w_rh706_turnos_establecimientos_rtps.create
int iCurrent
call super::create
if this.MenuName = "m_export" then this.MenuID = create m_export
this.st_nro_reg=create st_nro_reg
this.st_3=create st_3
this.pb_1=create pb_1
this.dw_origen=create dw_origen
this.st_ext=create st_ext
this.sle_ruc=create sle_ruc
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_nro_reg
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.dw_origen
this.Control[iCurrent+5]=this.st_ext
this.Control[iCurrent+6]=this.sle_ruc
this.Control[iCurrent+7]=this.dw_report
this.Control[iCurrent+8]=this.gb_1
end on

on w_rh706_turnos_establecimientos_rtps.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_nro_reg)
destroy(this.st_3)
destroy(this.pb_1)
destroy(this.dw_origen)
destroy(this.st_ext)
destroy(this.sle_ruc)
destroy(this.dw_report)
destroy(this.gb_1)
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
ELSE
	sle_ruc.text = is_ruc_emp
END IF

// Recuperar y mostrar datos
idw_1.Retrieve(is_cod_origen )
idw_1.Visible = True
idw_1.SetRedraw(true)


// Agrega la cantidad de registros
st_nro_reg.text = String( dw_report.Rowcount())

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

type st_nro_reg from statictext within w_rh706_turnos_establecimientos_rtps
integer x = 2907
integer y = 272
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

type st_3 from statictext within w_rh706_turnos_establecimientos_rtps
integer x = 2395
integer y = 280
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

type pb_1 from picturebutton within w_rh706_turnos_establecimientos_rtps
integer x = 2702
integer y = 36
integer width = 389
integer height = 160
integer taborder = 20
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

type dw_origen from u_dw_abc within w_rh706_turnos_establecimientos_rtps
integer x = 814
integer y = 24
integer width = 1019
integer height = 348
string dataobject = "d_origenes_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type st_ext from statictext within w_rh706_turnos_establecimientos_rtps
integer x = 558
integer y = 132
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
string text = ".tur"
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_ruc from singlelineedit within w_rh706_turnos_establecimientos_rtps
integer x = 123
integer y = 132
integer width = 411
integer height = 88
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type dw_report from u_dw_rpt within w_rh706_turnos_establecimientos_rtps
integer x = 50
integer y = 448
integer width = 3095
integer height = 660
string dataobject = "dw_rpt_turnos_establecimientos_text_rtps"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_rh706_turnos_establecimientos_rtps
integer x = 64
integer y = 64
integer width = 690
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

