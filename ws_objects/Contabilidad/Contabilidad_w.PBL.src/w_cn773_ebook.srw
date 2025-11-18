$PBExportHeader$w_cn773_ebook.srw
forward
global type w_cn773_ebook from w_prc
end type
type hpb_progreso from hprogressbar within w_cn773_ebook
end type
type ddlb_libro from dropdownlistbox within w_cn773_ebook
end type
type st_4 from statictext within w_cn773_ebook
end type
type cb_procesar from commandbutton within w_cn773_ebook
end type
type cb_generar from commandbutton within w_cn773_ebook
end type
type st_3 from statictext within w_cn773_ebook
end type
type sle_reg from singlelineedit within w_cn773_ebook
end type
type dw_1 from u_dw_cns within w_cn773_ebook
end type
type st_1 from statictext within w_cn773_ebook
end type
type st_2 from statictext within w_cn773_ebook
end type
type em_ano from editmask within w_cn773_ebook
end type
type ddlb_mes from dropdownlistbox within w_cn773_ebook
end type
type gb_1 from groupbox within w_cn773_ebook
end type
end forward

global type w_cn773_ebook from w_prc
integer width = 5019
integer height = 2136
string title = "[CN773] Libros Electrónicos (SUNAT)"
string menuname = "m_prc"
hpb_progreso hpb_progreso
ddlb_libro ddlb_libro
st_4 st_4
cb_procesar cb_procesar
cb_generar cb_generar
st_3 st_3
sle_reg sle_reg
dw_1 dw_1
st_1 st_1
st_2 st_2
em_ano em_ano
ddlb_mes ddlb_mes
gb_1 gb_1
end type
global w_cn773_ebook w_cn773_ebook

type variables
u_ds_base 			ids_datos
n_cst_utilitario	invo_util
end variables

forward prototypes
public function boolean of_reg_inv_perm_valorizado_f13 (long al_year, long al_mes)
public function boolean of_kardex_personalizado (long al_year, long al_mes)
end prototypes

public function boolean of_reg_inv_perm_valorizado_f13 (long al_year, long al_mes);Long 		ll_i, ll_row, ll_rows
String	ls_row, ls_string, ls_flag_saldo_inicial

ids_datos.DataObject = 'd_lista_mov_ple_almacen_tbl'
ids_datos.SetTransObject(SQLCA)
ids_datos.retrieve(al_year, al_mes)

dw_1.Reset( )

ll_rows = ids_datos.RowCount()

for ll_i = 1 to ll_rows
	yield()
	
	ls_flag_saldo_inicial = ids_datos.object.flag_saldo_inicial	[ll_i]
	
	//El saldo inicial solo debe mostrarse en el mes de enero
	//if al_mes > 1 and ls_flag_saldo_inicial = '1' then continue
	
	ls_row = ""
	
	//1. Periodo
	ls_row += string(ids_datos.object.periodo 		[ll_i]) + "|"
	
	//2. CUO
	ls_row += string(ids_datos.object.voucher 		[ll_i]) + "|"
	
	//3. Nro Asiento
	ls_row += string(ids_datos.object.nro_asiento 	[ll_i]) + "|"
	
	//4. Establecimiento
	ls_row += string(ids_datos.object.cod_establecimiento	[ll_i]) + "|"
	
	//5. Codigo del catalogo
	ls_row += "1|"
	
	//6. Tipo de Existencia
	ls_string = trim(ids_datos.object.tipo_existencia		[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"

	//7. Código de Articulo
	ls_string = trim(ids_datos.object.cod_art					[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"
	
	//8. Código del catálogo utilizado
	ls_row += "1|"
	
	//9. Codigo CUBSO
	ls_string = trim(ids_datos.object.cod_cubso				[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"

	//10. Fecha Emision 
	ls_string = string(date(ids_datos.object.fecha_emision	[ll_i]), 'dd/mm/yyyy')
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"

	//11. Tipo Documento SUNAT
	ls_string = string(ids_datos.object.tipo_doc	[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"

	//12. Serie Documento
	ls_string = string(ids_datos.object.serie		[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"

	//13. Numero Documento
	ls_string = string(ids_datos.object.numero	[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"

	//14. Tipo Operacion
	ls_string = string(ids_datos.object.tipo_operacion	[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"

	//15. Descripcion Existencia
	ls_string = string(ids_datos.object.desc_art	[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += trim(left(trim(ls_string), 80)) + "|"

	//16. Unidad
	ls_string = string(ids_datos.object.und	[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"

	//17. MEtodo de Evaluacion
	ls_string = string(ids_datos.object.metodo_evaluacion	[ll_i])
	if IsNull(ls_string) then ls_string = '1'
	ls_row += ls_string + "|"

	//18. Cantidad Ingreso
	ls_string = string(Dec(ids_datos.object.cantidad_entrada	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//19. Costo Unitario Ingreso
	ls_string = string(Dec(ids_datos.object.precio_unit_ingreso	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//20. Costo Total Ingreso
	ls_string = string(Dec(ids_datos.object.costo_entrada	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//21. Cantidad Salida
	ls_string = string(Dec(ids_datos.object.cantidad_salida	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//22. Costo Unitario Salida
	ls_string = string(Dec(ids_datos.object.precio_unit_salida	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//23. Costo Total Salida
	ls_string = string(Dec(ids_datos.object.costo_salida	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//24. Saldo Final
	ls_string = string(Dec(ids_datos.object.saldo_final	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//25. Costo Unitario Saldo Final
	ls_string = string(Dec(ids_datos.object.precio_unit_final	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//26. Costo Final
	ls_string = string(Dec(ids_datos.object.costo_final	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//27. Estado Operacion
	ls_string = string(ids_datos.object.estado_operacion	[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"

	//Insertar un registro
	ll_row = dw_1.InsertRow( 0 )
	
	if ll_row > 0 then
		dw_1.Object.exp_row [ll_row] = ls_row
	end if
	
	hpb_progreso.position = Long(Dec(ll_i) / Dec(ll_rows) * 100)
	sle_reg.text = string(ll_i)
	
	yield()
next

return true
end function

public function boolean of_kardex_personalizado (long al_year, long al_mes);Long 		ll_i, ll_row, ll_rows
String	ls_row, ls_string, ls_flag_saldo_inicial

ids_datos.DataObject = 'd_lista_mov_ple_almacen_tbl'
ids_datos.SetTransObject(SQLCA)
ids_datos.retrieve(al_year, al_mes)

dw_1.Reset( )

ll_rows = ids_datos.RowCount()

for ll_i = 1 to ll_rows
	yield()
	
	ls_flag_saldo_inicial = ids_datos.object.flag_saldo_inicial	[ll_i]
	
	//El saldo inicial solo debe mostrarse en el mes de enero
	if al_mes > 1 and ls_flag_saldo_inicial = '1' then continue
	
	ls_row = ""
	
	//1. Periodo
	ls_row += string(ids_datos.object.periodo 		[ll_i]) + "|"
	
	//2. Establecimiento
	ls_row += string(ids_datos.object.cod_establecimiento	[ll_i]) + "|"
	
	//3. Codigo del catalogo
	ls_row += string(ids_datos.object.catalogo				[ll_i]) + "|"
	
	//4. Tipo de Existencia
	ls_string = trim(ids_datos.object.tipo_existencia		[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"

	//5. Código de Articulo
	ls_string = trim(ids_datos.object.cod_art					[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"
	
	//6. Fecha Emision 
	ls_string = string(date(ids_datos.object.fecha_emision	[ll_i]), 'dd/mm/yyyy')
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"

	//7. Tipo Documento SUNAT
	ls_string = string(ids_datos.object.tipo_doc	[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"

	//8. Serie Documento
	ls_string = string(ids_datos.object.serie		[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"

	//9. Numero Documento
	ls_string = string(ids_datos.object.numero	[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"

	//10. Tipo Operacion
	ls_string = string(ids_datos.object.tipo_operacion	[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"

	//11. Descripcion Existencia
	ls_string = string(ids_datos.object.desc_art	[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += trim(left(trim(ls_string), 80)) + "|"

	//12. unidad
	ls_string = string(ids_datos.object.und	[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"

	//13. Metodo Evaluacion
	ls_string = string(ids_datos.object.metodo_evaluacion	[ll_i])
	if IsNull(ls_string) then ls_string = '1'
	ls_row += ls_string + "|"

	//14. Cantidad Ingreso
	ls_string = string(Dec(ids_datos.object.cantidad_entrada	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//15. Costo Unitario Ingreso
	ls_string = string(Dec(ids_datos.object.precio_unit_ingreso	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//16. Costo Total Entrada
	ls_string = string(Dec(ids_datos.object.costo_entrada	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//17. Cantidad Salida
	ls_string = string(Dec(ids_datos.object.cantidad_salida	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//18. Costo Unitario Salida
	ls_string = string(Dec(ids_datos.object.precio_unit_salida	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//19. Costo Total Salida
	ls_string = string(Dec(ids_datos.object.costo_salida	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//20. Saldo Final
	ls_string = string(Dec(ids_datos.object.saldo_final	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//21. Costo Unitario Saldo Final
	ls_string = string(Dec(ids_datos.object.precio_unit_final	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//22. Costo Final
	ls_string = string(Dec(ids_datos.object.costo_final	[ll_i]), "########0.00")
	if IsNull(ls_string) or trim(ls_string) = '' then ls_string = '0.00'
	ls_row += ls_string + "|"

	//23. Estado Operacion
	ls_string = string(ids_datos.object.estado_operacion	[ll_i])
	if IsNull(ls_string) then ls_string = ''
	ls_row += ls_string + "|"

	//24. KINTDIAMAY
	ls_row += string(ids_datos.object.voucher 		[ll_i]) + "|"
	
	//25. KINTVTACOM - Nro Asiento
	ls_row += string(ids_datos.object.nro_asiento 	[ll_i]) + "|"

	//26. KINTREG
	ls_row += string(ids_datos.object.voucher 		[ll_i]) + "|"

	//Insertar un registro
	ll_row = dw_1.InsertRow( 0 )
	
	if ll_row > 0 then
		dw_1.Object.exp_row [ll_row] = ls_row
	end if
	
	hpb_progreso.position = Long(Dec(ll_i) / Dec(ll_rows) * 100)
	sle_reg.text = string(ll_i)
	
	yield()
next

return true
end function

event open;call super::open;
dw_1.settransobject(sqlca)
//dw_report.settransobject(sqlca)
em_ano.text = string(Date(gnvo_app.of_fecha_actual()), 'yyyy')

ids_datos 	= create u_ds_base



end event

on w_cn773_ebook.create
int iCurrent
call super::create
if this.MenuName = "m_prc" then this.MenuID = create m_prc
this.hpb_progreso=create hpb_progreso
this.ddlb_libro=create ddlb_libro
this.st_4=create st_4
this.cb_procesar=create cb_procesar
this.cb_generar=create cb_generar
this.st_3=create st_3
this.sle_reg=create sle_reg
this.dw_1=create dw_1
this.st_1=create st_1
this.st_2=create st_2
this.em_ano=create em_ano
this.ddlb_mes=create ddlb_mes
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_progreso
this.Control[iCurrent+2]=this.ddlb_libro
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.cb_procesar
this.Control[iCurrent+5]=this.cb_generar
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.sle_reg
this.Control[iCurrent+8]=this.dw_1
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.em_ano
this.Control[iCurrent+12]=this.ddlb_mes
this.Control[iCurrent+13]=this.gb_1
end on

on w_cn773_ebook.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.hpb_progreso)
destroy(this.ddlb_libro)
destroy(this.st_4)
destroy(this.cb_procesar)
destroy(this.cb_generar)
destroy(this.st_3)
destroy(this.sle_reg)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_ano)
destroy(this.ddlb_mes)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_1.width  = newwidth  - dw_1.x - 10
dw_1.height = newheight - dw_1.y - 10
end event

event close;call super::close;destroy ids_datos
end event

type hpb_progreso from hprogressbar within w_cn773_ebook
integer x = 1701
integer y = 176
integer width = 818
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 1
end type

type ddlb_libro from dropdownlistbox within w_cn773_ebook
integer x = 1696
integer y = 68
integer width = 1874
integer height = 856
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean vscrollbar = true
string item[] = {"08.01.Registro de Compras","08.02. Registro de Compras - Información de Sujetos no Domiciliados","14.01. REGISTRO DE VENTAS E INGRESOS","05.01. LIBRO DIARIO","05.03. LIBRO DIARIO - DETALLE DEL PLAN CONTABLE UTILIZADO","06.01. LIBRO MAYOR","03.02. Detalle del saldo de la cuenta 10 - Efectivo y equivalente de efectivo","13.01. REGISTRO DEL INVENTARIO PERMANENTE VALORIZADO - DETALLE DEL INVENTARIO VALORIZADO","01.01. LIBRO CAJA Y BANCOS - DETALLE DE LOS MOVIMIENTOS DEL EFECTIVO","01.02. LIBRO CAJA Y BANCOS - DETALLE DE LOS MOVIMIENTOS DE LA CUENTA CORRIENTE","03.03. Detalle del saldo de la cuenta 12 y 13 ","03.04. Detalle del saldo de la cuenta 14","03.05. Detalle del saldo de la cuenta 16 y 17","03.06. Detalle del saldo de la cuenta 19","03.07. Detalle del saldo de la cuenta 20 y 21","03.12. Detalle del saldo de la cuenta 42 y 43","03.11. Detalle del saldo de la cuenta 41","99.01. Libro Kardex personalizado","99.02. Libro Diario (Version 3.0.2)","99.03. Libro Mayor (Version 3.0.2)","99.04. Registro de Compras (Version 3.0.2)","99.05. Registro de Ventas (Version 3.0.2)","03.13. Detalle del saldo de la cuenta 46","08.04. RCE. Registro de Compras Electronicos (SIRE)","08.05. RCE. Registro de Compras no domiciliados Electronicos (SIRE)","14.04. RVIE. Registro de Ventas e Ingresos Electronicos (SIRE)"}
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_cn773_ebook
integer x = 1234
integer y = 68
integer width = 462
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Libro Electronico: "
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_procesar from commandbutton within w_cn773_ebook
integer x = 3630
integer y = 60
integer width = 571
integer height = 96
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_msj_err, ls_cadena, ls_libro
Long   ll_ano ,ll_mes,	ll_count

//LIMPIAR DW
dw_1.reset()
sle_reg.text = '0'

ll_ano = long(trim(em_ano.text))
ll_mes = long(trim(LEFT(ddlb_mes.text,2)))
ls_libro = left(trim(ddlb_libro.text),5)

ls_cadena = trim(em_ano.text)+trim(LEFT(ddlb_mes.text,2))


if Isnull(ll_ano) or ll_ano = 0 then
	Messagebox('Aviso','Debe Ingresar algun Año Valido ,Verifique!')
	Return
end if

if Isnull(ll_mes) or ll_mes < 0 or ll_mes > 13 then
	Messagebox('Aviso','Debe Ingresar algun Mes Valido ,Verifique!')
	Return
end if

IF ls_libro = "08.01" then

	dw_1.dataObject = 'd_ple_reg_compra81_tbl'

elseIF ls_libro = "08.04" then

	dw_1.dataObject = 'd_sire_reg_compra_tbl'

elseIF ls_libro = "08.05" then

	dw_1.dataObject = 'd_sire_reg_compra85_tbl'

elseIF ls_libro = "14.04" then

	dw_1.dataObject = 'd_sire_reg_venta_tbl'	
	
elseIF ls_libro = "99.04" then

	dw_1.dataObject = 'd_ple_reg_compra81_v302_tbl'

elseIF ls_libro = "08.02" then

	dw_1.dataObject = 'd_ple_reg_compra82_tbl'
	
ELSEIF ls_libro = "14.01" then
	
	dw_1.dataObject = 'd_ple_reg_venta_tbl'
	
ELSEIF ls_libro = "99.05" then
	
	dw_1.dataObject = 'd_ple_reg_venta_v302_tbl'

ELSEIF ls_libro = "05.01" then
	
	dw_1.DataObject = 'd_rpt_ple_diario_tbl'
	
ELSEIF ls_libro = "99.02" then
	
	dw_1.DataObject = 'd_rpt_ple_diario_v302_tbl'

ELSEIF ls_libro = "05.03" then
	
	dw_1.DataObject = 'd_rpt_ple_diario_F2_tbl'

ELSEIF ls_libro = "06.01" then
	
	dw_1.DataObject = 'd_rpt_ple_mayor_tbl'
	
ELSEIF ls_libro = "99.03" then
	
	dw_1.DataObject = 'd_rpt_ple_mayor_v302_tbl'

ELSEIF ls_libro = "03.02" then
	
	dw_1.DataObject = 'd_ple_detalle_cnta_10_32_tbl'
	
ELSEIF ls_libro = "03.03" then
	
	dw_1.DataObject = 'd_ple_detalle_cnta_12_13_33_tbl'

ELSEIF ls_libro = "03.04" then
	
	dw_1.DataObject = 'd_ple_detalle_cnta_14_34_tbl'
	
ELSEIF ls_libro = "03.05" then
	
	dw_1.DataObject = 'd_ple_detalle_cnta_16_17_35_tbl'

ELSEIF ls_libro = "03.06" then
	
	dw_1.DataObject = 'd_ple_detalle_cnta_19_36_tbl'

ELSEIF ls_libro = "03.07" then
	
	dw_1.DataObject = 'd_ple_detalle_cnta_20_21_37_tbl'

ELSEIF ls_libro = "03.11" then
	
	dw_1.DataObject = 'd_ple_detalle_cnta_41_311_tbl'

ELSEIF ls_libro = "03.12" then
	
	dw_1.DataObject = 'd_ple_detalle_cnta_42_43_312_tbl'

ELSEIF ls_libro = "03.13" then
	
	dw_1.DataObject = 'd_ple_detalle_cnta_46_tbl'
	
elseif ls_libro = "01.01" then
	
	dw_1.DataObject = 'd_rpt_ple_caja_f11_tbl'
	
elseif ls_libro = "01.02" then
	
	dw_1.DataObject = 'd_rpt_ple_caja_f12_tbl'

elseif ls_libro = "13.01" or ls_libro = '99.01' then
	
	dw_1.DataObject = 'd_rpt_ple_inventario_f13_tbl'

ELSE
	
	Messagebox("Aviso", "Seleccione un Tipo de Libro de Electrónico",Exclamation!)
	return
	
END IF	

dw_1.settransobject(SQLCA)

//Genero el archivo de texto
cb_procesar.enabled = false
cb_generar.enabled = false

IF ls_libro = "13.01" then
	
	
	of_Reg_Inv_Perm_Valorizado_f13(ll_ano, ll_mes)
	
	
elseIF ls_libro = "99.01" then
	
	of_kardex_personalizado(ll_ano, ll_mes)

elseIF ls_libro = "08.04" then

	dw_1.retrieve(ll_ano, ll_mes, gnvo_app.empresa.is_empresa)

elseIF ls_libro = "08.05" then

	dw_1.retrieve(ll_ano, ll_mes, gnvo_app.empresa.is_empresa)

elseIF ls_libro = "14.04" then

	dw_1.retrieve(ll_ano, ll_mes, gnvo_app.empresa.is_empresa)

ELSE
	
	dw_1.retrieve(ll_ano, ll_mes)
	
END IF	

cb_procesar.enabled = true
cb_generar.enabled = true

ll_count = dw_1.rowcount()
sle_reg.text = Trim(String(ll_count))

cb_generar.enabled = TRUE
end event

type cb_generar from commandbutton within w_cn773_ebook
integer x = 3630
integer y = 156
integer width = 571
integer height = 96
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Genera Archivo TXT"
end type

event clicked;String  ls_nomb_arch ,ls_path,ls_year,ls_mes, ls_vacio, ls_libro, ls_file_name

try 
	
	ls_year = trim(em_ano.text)
	ls_mes = trim(LEFT(ddlb_mes.text,2))
	ls_libro = left(trim(ddlb_libro.text),5)
	
	//ls_path='\SIGRE_EXE\EBOOK\' 
	
	//NOMBRE DE DIRECTORIO
	ls_path = gnvo_app.of_get_parametro("PATH_SIGRE_EBBOK", 'i:\SIGRE_EXE\EBOOK\')
	
	if right(ls_path, 1) = '\' then
		ls_path = mid(ls_path, 1, len(ls_path) - 1)
	end if
	
	//Directorio donde se guardan los archivos de Texto
	ls_path = ls_path + '\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
				  + '\' + ls_year + '_' + ls_mes + '\' //NOMBRE DE DIRECTORIO
	
	If not DirectoryExists ( ls_path ) Then
		if not invo_util.of_CreateDirectory( ls_path ) then return
	End If
	
	//Ahora creo el nombre del archivo de Texto
	if dw_1.RowCount() = 0 then
		ls_vacio = '0'
	else
		ls_vacio = '1'
	end if
	
	if ls_libro = "08.01" then
		
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'00080100001' + ls_vacio + '11.TXT'
		
	elseif ls_libro = "08.02" then
		
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'00080200001' + ls_vacio + '11.TXT'
		
	elseif ls_libro = "14.01" then
		
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'00140100001' + ls_vacio + '11.txt'
		
	elseif ls_libro = "08.04" then
		
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'00080400021' + ls_vacio + '12.TXT'
		
	elseif ls_libro = "08.05" then
		
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'00080500001' + ls_vacio + '12.TXT'
		
	elseif ls_libro = "14.04" then

		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'00140400021' + ls_vacio + '12.TXT'
	
	elseif ls_libro = "05.01" then
		
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'00050100001' + ls_vacio + '11.txt'
		
	elseif ls_libro = "05.03" then
		
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'00050300001' + ls_vacio + '11.txt'
		
	elseif ls_libro = "06.01" then
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'00060100001' + ls_vacio + '11.txt'
	elseif ls_libro = "01.01" then
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'00010100001' + ls_vacio + '11.txt'
	elseif ls_libro = "01.02" then
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'00010200001' + ls_vacio + '11.txt'
	elseif ls_libro = "13.01" then
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'00130100001' + ls_vacio + '11.txt'
	elseif ls_libro = "03.02" then
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'31030200011' + ls_vacio + '11.txt'
	elseif ls_libro = "03.03" then
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'31030300011' + ls_vacio + '11.txt'
	elseif ls_libro = "03.04" then
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'31030400011' + ls_vacio + '11.txt'
	elseif ls_libro = "03.05" then
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'31030500011' + ls_vacio + '11.txt'
	elseif ls_libro = "03.06" then
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'31030600011' + ls_vacio + '11.txt'
	elseif ls_libro = "03.07" then
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'31030700011' + ls_vacio + '11.txt'
	elseif ls_libro = "03.11" then
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'31031100011' + ls_vacio + '11.txt'
	elseif ls_libro = "03.12" then
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'31031200011' + ls_vacio + '11.txt'
	elseif ls_libro = "03.13" then
		ls_nomb_arch = 'LE'+gnvo_app.empresa.is_ruc+ls_year+ls_mes+'31031300011' + ls_vacio + '11.txt'
	elseif ls_libro = "99.01" then
		ls_nomb_arch = 'KARDEX_V302_' + gnvo_app.empresa.is_ruc + '_' + ls_year + ls_mes +'.txt'
	elseif ls_libro = "99.02" then
		ls_nomb_arch = 'LIBRO_DIARIO_V302_' + gnvo_app.empresa.is_ruc + '_' + ls_year + ls_mes +'.txt'
	elseif ls_libro = "99.03" then
		ls_nomb_arch = 'LIBRO_MAYOR_V302_' + gnvo_app.empresa.is_ruc + '_' + ls_year + ls_mes +'.txt'
	elseif ls_libro = "99.04" then
		ls_nomb_arch = 'REGISTRO_COMPRAS_V302_' + gnvo_app.empresa.is_ruc + '_' + ls_year + ls_mes +'.txt'
	elseif ls_libro = "99.05" then
		ls_nomb_arch = 'REGISTRO_VENTAS_V302_' + gnvo_app.empresa.is_ruc + '_' + ls_year + ls_mes +'.txt'
	else
		MessageBox('Error', "Libro Electronico aun no se encuentra desarrollado o no está disponible en estos momentos, por favor coordine con Contabilidad", StopSign!)
		return
	end if
	
	ls_file_name= ls_path+ls_nomb_arch
	
	//Pregunto si desea sobrescribir el archivo
	if FileExists(ls_file_name) then
		if MessageBox('Aviso', 'El archivo ' + ls_file_name + ' ya existe, ¿Desea Sobreescribirlo?', &
										Information!, YesNo!, 1) = 2 then return
	end if
	
	if dw_1.SaveAs(ls_file_name, TEXT!, FALSE) = 1 then
		Messagebox('Aviso','Se Genero Satisfactoriamente Archivo EBOOK '+ls_file_name, Information!)
	else
		Messagebox('Error','Se ha producido un error al grabar el EBOOK '+ls_file_name + ', por favor verifique!', StopSign!)
	end if

catch ( Exception ex)
	gnvo_app.of_catch_Exception(ex, 'Error al generar archivo ebook')

end try

end event

type st_3 from statictext within w_cn773_ebook
integer x = 2487
integer y = 176
integer width = 526
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Total de Registros :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_reg from singlelineedit within w_cn773_ebook
integer x = 3040
integer y = 168
integer width = 530
integer height = 96
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 65535
borderstyle borderstyle = stylelowered!
end type

type dw_1 from u_dw_cns within w_cn773_ebook
integer y = 288
integer width = 3877
integer height = 1532
integer taborder = 40
string dataobject = "d_abc_coa_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez


 ii_ck[1] = 1         // columnas de lectrua de este dw

	
end event

type st_1 from statictext within w_cn773_ebook
integer x = 37
integer y = 72
integer width = 215
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn773_ebook
integer x = 448
integer y = 72
integer width = 224
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ano from editmask within w_cn773_ebook
integer x = 270
integer y = 72
integer width = 174
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy"
end type

type ddlb_mes from dropdownlistbox within w_cn773_ebook
integer x = 709
integer y = 72
integer width = 517
integer height = 856
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean vscrollbar = true
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Julio","08 - Agosto","09 - Setiembre","10 - Octubre","11 - Noviembre","12 - Diciembre","00.- Apertura","13.- Cierre Ejercicio"}
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_cn773_ebook
integer width = 4215
integer height = 284
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Libros Electrónicos"
end type

