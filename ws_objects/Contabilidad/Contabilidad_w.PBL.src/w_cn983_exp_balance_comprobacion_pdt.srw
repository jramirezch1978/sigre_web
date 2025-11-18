$PBExportHeader$w_cn983_exp_balance_comprobacion_pdt.srw
forward
global type w_cn983_exp_balance_comprobacion_pdt from w_rpt
end type
type sle_year from singlelineedit within w_cn983_exp_balance_comprobacion_pdt
end type
type st_1 from statictext within w_cn983_exp_balance_comprobacion_pdt
end type
type st_nro_reg from statictext within w_cn983_exp_balance_comprobacion_pdt
end type
type st_3 from statictext within w_cn983_exp_balance_comprobacion_pdt
end type
type pb_1 from picturebutton within w_cn983_exp_balance_comprobacion_pdt
end type
type st_ext from statictext within w_cn983_exp_balance_comprobacion_pdt
end type
type sle_file from singlelineedit within w_cn983_exp_balance_comprobacion_pdt
end type
type dw_report from u_dw_rpt within w_cn983_exp_balance_comprobacion_pdt
end type
type gb_1 from groupbox within w_cn983_exp_balance_comprobacion_pdt
end type
end forward

global type w_cn983_exp_balance_comprobacion_pdt from w_rpt
integer width = 3227
integer height = 1336
string title = "[CN983] Balance de Comprobación PDT"
string menuname = "m_export"
sle_year sle_year
st_1 st_1
st_nro_reg st_nro_reg
st_3 st_3
pb_1 pb_1
st_ext st_ext
sle_file sle_file
dw_report dw_report
gb_1 gb_1
end type
global w_cn983_exp_balance_comprobacion_pdt w_cn983_exp_balance_comprobacion_pdt

type variables
String is_cod_origen, is_ruc_emp
u_ds_base  ids_datos
end variables

forward prototypes
public function integer of_ruc_empresa ()
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

on w_cn983_exp_balance_comprobacion_pdt.create
int iCurrent
call super::create
if this.MenuName = "m_export" then this.MenuID = create m_export
this.sle_year=create sle_year
this.st_1=create st_1
this.st_nro_reg=create st_nro_reg
this.st_3=create st_3
this.pb_1=create pb_1
this.st_ext=create st_ext
this.sle_file=create sle_file
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_year
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_nro_reg
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.st_ext
this.Control[iCurrent+7]=this.sle_file
this.Control[iCurrent+8]=this.dw_report
this.Control[iCurrent+9]=this.gb_1
end on

on w_cn983_exp_balance_comprobacion_pdt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_year)
destroy(this.st_1)
destroy(this.st_nro_reg)
destroy(this.st_3)
destroy(this.pb_1)
destroy(this.st_ext)
destroy(this.sle_file)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_report.width  = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)

sle_year.text =string(Integer(string(f_fecha_actual(), 'yyyy')) - 1)

this.of_ruc_empresa( )

sle_file.text = '0702' + is_ruc_emp + sle_year.text

ids_datos = create u_ds_base
ids_datos.dataObject = 'd_exp_balance_comprob_pdt_txt_2016_tbl' 
ids_datos.setTransObject(SQLCA)
end event

event ue_retrieve;call super::ue_retrieve;integer li_year

idw_1.SetRedraw(false)

// Llamar a la función para llenar el Ruc de la empresa
IF of_ruc_empresa () = 0 THEN
	messagebox('Aviso', 'Verificar RUC de Empresa')
	RETURN
end if

if sle_year.text = '' then
	messagebox('Aviso', 'Debe especificar un año para la exportacion')
	sle_year.setFocus( )
	RETURN
end if

li_year = Integer(sle_year.text)

// Recuperar y mostrar datos
idw_1.Retrieve(li_year)
idw_1.Visible = True
idw_1.SetRedraw(true)

ids_datos.retrieve( li_year )


// Agrega la cantidad de registros
st_nro_reg.text = String( ids_datos.Rowcount())

if ids_datos.Rowcount( ) > 1 then
	this.event ue_saveas( )
end if

end event

event ue_saveas;// Override
String	ls_nombre, ls_path
integer 	li_result

ls_nombre = sle_file.text + st_ext.text

ls_path = 'i:\sigre_exe\PDT'

if not DirectoryExists(ls_path) then
	CreateDirectory(ls_path)
end if

IF ids_datos.rowcount( ) < 1 THEN return

//li_result = GetFolder( "Seleccione Directorio", ls_path )

// colocar la extensión al nombre el archivo
ls_nombre = ls_path +'\'+ ls_nombre 

ids_datos.SaveAs(ls_nombre, Text! , FALSE)
MessageBox('Aviso', 'Archivo ' + ls_nombre + ' se ha grabado satisfactoriamente')
end event

event close;call super::close;destroy ids_datos
end event

type sle_year from singlelineedit within w_cn983_exp_balance_comprobacion_pdt
integer x = 1033
integer y = 56
integer width = 265
integer height = 104
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cn983_exp_balance_comprobacion_pdt
integer x = 837
integer y = 72
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
string text = "Año:"
boolean focusrectangle = false
end type

type st_nro_reg from statictext within w_cn983_exp_balance_comprobacion_pdt
integer x = 2898
integer y = 76
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

type st_3 from statictext within w_cn983_exp_balance_comprobacion_pdt
integer x = 2386
integer y = 84
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

type pb_1 from picturebutton within w_cn983_exp_balance_comprobacion_pdt
integer x = 1349
integer y = 28
integer width = 389
integer height = 160
integer taborder = 20
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

type st_ext from statictext within w_cn983_exp_balance_comprobacion_pdt
integer x = 622
integer y = 68
integer width = 123
integer height = 88
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = ".txt"
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_file from singlelineedit within w_cn983_exp_balance_comprobacion_pdt
integer x = 18
integer y = 68
integer width = 594
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

type dw_report from u_dw_rpt within w_cn983_exp_balance_comprobacion_pdt
integer y = 192
integer width = 3095
integer height = 700
string dataobject = "d_exp_balance_comprob_pdt_tbl"
end type

type gb_1 from groupbox within w_cn983_exp_balance_comprobacion_pdt
integer width = 763
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

