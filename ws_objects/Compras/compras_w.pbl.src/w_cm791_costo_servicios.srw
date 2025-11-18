$PBExportHeader$w_cm791_costo_servicios.srw
forward
global type w_cm791_costo_servicios from w_report_smpl
end type
type uo_fechas from u_ingreso_rango_fechas_v within w_cm791_costo_servicios
end type
type cbx_oc from checkbox within w_cm791_costo_servicios
end type
type cbx_proveedores from checkbox within w_cm791_costo_servicios
end type
type cb_buscar from commandbutton within w_cm791_costo_servicios
end type
type st_proveedor from statictext within w_cm791_costo_servicios
end type
type cb_busqueda from commandbutton within w_cm791_costo_servicios
end type
type sle_proveedor from singlelineedit within w_cm791_costo_servicios
end type
type cbx_detalle from checkbox within w_cm791_costo_servicios
end type
type sle_nro from u_sle_codigo within w_cm791_costo_servicios
end type
type gb_1 from groupbox within w_cm791_costo_servicios
end type
end forward

global type w_cm791_costo_servicios from w_report_smpl
integer width = 3758
integer height = 1904
string title = "[CM791] Reporte de Costos x OC"
string menuname = "m_impresion"
uo_fechas uo_fechas
cbx_oc cbx_oc
cbx_proveedores cbx_proveedores
cb_buscar cb_buscar
st_proveedor st_proveedor
cb_busqueda cb_busqueda
sle_proveedor sle_proveedor
cbx_detalle cbx_detalle
sle_nro sle_nro
gb_1 gb_1
end type
global w_cm791_costo_servicios w_cm791_costo_servicios

type variables
String	is_doc_ot, is_doc_oc, is_doc_prc
end variables

forward prototypes
public function integer of_get_parametros (ref string as_doc_ot, ref string as_doc_oc, ref string as_doc_prc)
end prototypes

public function integer of_get_parametros (ref string as_doc_ot, ref string as_doc_oc, ref string as_doc_prc);Long		ll_rc = 0



  SELECT "LOGPARAM"."DOC_OT", "LOGPARAM"."DOC_OC", "LOGPARAM"."TIPO_DOC_PROG_CMP"  
    INTO :as_doc_ot, :as_doc_oc, :as_doc_prc
    FROM "LOGPARAM"  
   WHERE "LOGPARAM"."RECKEY" = '1' ;

	
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -1
END IF


RETURN ll_rc

end function

on w_cm791_costo_servicios.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fechas=create uo_fechas
this.cbx_oc=create cbx_oc
this.cbx_proveedores=create cbx_proveedores
this.cb_buscar=create cb_buscar
this.st_proveedor=create st_proveedor
this.cb_busqueda=create cb_busqueda
this.sle_proveedor=create sle_proveedor
this.cbx_detalle=create cbx_detalle
this.sle_nro=create sle_nro
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.cbx_oc
this.Control[iCurrent+3]=this.cbx_proveedores
this.Control[iCurrent+4]=this.cb_buscar
this.Control[iCurrent+5]=this.st_proveedor
this.Control[iCurrent+6]=this.cb_busqueda
this.Control[iCurrent+7]=this.sle_proveedor
this.Control[iCurrent+8]=this.cbx_detalle
this.Control[iCurrent+9]=this.sle_nro
this.Control[iCurrent+10]=this.gb_1
end on

on w_cm791_costo_servicios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.cbx_oc)
destroy(this.cbx_proveedores)
destroy(this.cb_buscar)
destroy(this.st_proveedor)
destroy(this.cb_busqueda)
destroy(this.sle_proveedor)
destroy(this.cbx_detalle)
destroy(this.sle_nro)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Date		ld_fecha1, ld_fecha2
String	ls_proveedor, ls_oc

ld_Fecha1 = uo_fechas.of_get_fecha1( )
ld_Fecha2 = uo_fechas.of_get_fecha2( )

if cbx_proveedores.checked then
	ls_proveedor = '%%'
else
	if trim(sle_proveedor.text) = "" then
		MessageBox('Aviso', 'Debe Seleccionar un proveedor, por favor verifique!')
		sle_proveedor.setFocus( )
		return 
	end if
	ls_proveedor = trim(sle_proveedor.text) + '%'
end if

if cbx_oc.checked then
	ls_oc = '%%'
else
	if trim(sle_nro.text) = "" then
		MessageBox('Aviso', 'Debe Seleccionar un numero de OC, por favor verifique!')
		sle_nro.setFocus( )
		return 
	end if
	ls_oc = trim(sle_nro.text) + '%'
end if

if cbx_detalle.checked then
	idw_1.dataobject = 'd_rpt_oc_os_tbl'
else
	idw_1.dataobject = 'd_rpt_oc_os_resumen_tbl'
end if
idw_1.setTransObject(SQLCA)
ib_preview = false
event ue_preview()


idw_1.Retrieve(ld_fecha1, ld_fecha2, ls_proveedor, ls_oc)
idw_1.object.t_titulo1.text = "Desde " + string(ld_fecha1, 'dd/mm/yyyy') + " al " + string(ld_fecha2, 'dd/mm/yyyy')
if cbx_proveedores.checked then
	idw_1.object.t_titulo2.text = "Todos los proveedores"
else
	idw_1.object.t_titulo2.text = "Proveedor: " + sle_proveedor.text + "-" + st_proveedor.text
end if
idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = this.classname()


end event

event ue_open_pre;call super::ue_open_pre;// Leer tipo doc OT, cod operacion consumo interno
of_get_parametros(is_doc_ot, is_doc_oc, is_doc_prc)

end event

type dw_report from w_report_smpl`dw_report within w_cm791_costo_servicios
integer x = 0
integer y = 284
integer width = 3131
integer height = 1388
string dataobject = "d_rpt_oc_os_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "almacen" 
		lstr_1.DataObject = 'd_art_mov_almacen_tbl'
		lstr_1.Width = 2850
		lstr_1.Height= 900
		lstr_1.Arg[1] = GetItemString(row,'cod_art')
		lstr_1.Arg[2] = GetItemString(row,'almacen')
		lstr_1.Title = 'Ultimos Movimientos del Articulo en este Almacen'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)
	CASE "qnt_comp" 
		lstr_1.DataObject = 'd_oc_x_prog_comp_item_tbl'
		lstr_1.Width = 3500
		lstr_1.Height= 900
		lstr_1.Arg[1] = is_doc_prc
		lstr_1.Arg[2] = GetItemString(row,'nro_programa')
		lstr_1.Arg[3] = String(GetItemNumber(row,'nro_item'))
		lstr_1.Title = 'OC Relacionadas al Item de Programa de Compras'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)
	CASE "qnt_ing" 
		lstr_1.DataObject = 'd_art_mov_prog_comp_tbl'
		lstr_1.Width = 2950
		lstr_1.Height= 900
		lstr_1.Arg[1] = is_doc_prc
		lstr_1.Arg[2] = GetItemString(row,'nro_programa')
		lstr_1.Arg[3] = String(GetItemNumber(row,'nro_item'))
		lstr_1.Title = 'Mov de Almacen de OC Relacionadas'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)	
END CHOOSE
end event

type uo_fechas from u_ingreso_rango_fechas_v within w_cm791_costo_servicios
event destroy ( )
integer x = 37
integer y = 56
integer taborder = 40
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;Date	ld_fecha_actual

ld_fecha_actual = Date(gnvo_app.of_fecha_actual(true))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_fecha_actual, gnvo_app.of_last_date(ld_fecha_actual)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

type cbx_oc from checkbox within w_cm791_costo_servicios
integer x = 786
integer y = 148
integer width = 617
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todas Las OC"
boolean checked = true
end type

event clicked;if this.checked then
	sle_nro.enabled = false
else
	sle_nro.enabled = true
end if
end event

type cbx_proveedores from checkbox within w_cm791_costo_servicios
integer x = 782
integer y = 44
integer width = 594
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los proveedores"
boolean checked = true
boolean righttoleft = true
end type

event clicked;if this.checked then
	cb_busqueda.enabled = false
else
	cb_busqueda.enabled = true
end if
end event

type cb_buscar from commandbutton within w_cm791_costo_servicios
integer x = 3141
integer y = 48
integer width = 375
integer height = 160
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;
Event ue_retrieve()

end event

type st_proveedor from statictext within w_cm791_costo_servicios
integer x = 1851
integer y = 32
integer width = 1253
integer height = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type cb_busqueda from commandbutton within w_cm791_costo_servicios
integer x = 1765
integer y = 32
integer width = 78
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;Str_seleccionar lstr_seleccionar

string ls_sql, ls_codigo, ls_data
boolean lb_ret

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql =  "SELECT PROVEEDOR AS CODIGO, " &
   							  + "NOM_PROVEEDOR AS NOMBRE, " &
								  + "FLAG_ESTADO AS ESTADO " &
								  + "FROM PROVEEDOR " &
								  + "where flag_estado = '1'"

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_proveedor.text	= lstr_seleccionar.param1[1]
	st_proveedor.text 	= lstr_seleccionar.param2[1]
END IF

end event

type sle_proveedor from singlelineedit within w_cm791_costo_servicios
integer x = 1408
integer y = 32
integer width = 347
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type cbx_detalle from checkbox within w_cm791_costo_servicios
integer x = 2085
integer y = 144
integer width = 663
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reporte detallado"
boolean checked = true
end type

type sle_nro from u_sle_codigo within w_cm791_costo_servicios
integer x = 1408
integer y = 152
integer width = 471
integer height = 92
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
textcase textcase = upper!
integer limit = 10
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

type gb_1 from groupbox within w_cm791_costo_servicios
integer width = 741
integer height = 272
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Filtro x Fechas"
end type

