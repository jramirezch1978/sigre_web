$PBExportHeader$w_cm760_oc_pendiente.srw
forward
global type w_cm760_oc_pendiente from w_report_smpl
end type
type cb_1 from commandbutton within w_cm760_oc_pendiente
end type
type uo_fechas from u_ingreso_rango_fechas within w_cm760_oc_pendiente
end type
type cbx_proveedores from checkbox within w_cm760_oc_pendiente
end type
type sle_proveedor from singlelineedit within w_cm760_oc_pendiente
end type
type cb_busqueda from commandbutton within w_cm760_oc_pendiente
end type
type st_proveedor from statictext within w_cm760_oc_pendiente
end type
end forward

global type w_cm760_oc_pendiente from w_report_smpl
integer width = 3415
integer height = 2276
string title = "OC pendientes de atencion (CM760)"
string menuname = "m_impresion"
cb_1 cb_1
uo_fechas uo_fechas
cbx_proveedores cbx_proveedores
sle_proveedor sle_proveedor
cb_busqueda cb_busqueda
st_proveedor st_proveedor
end type
global w_cm760_oc_pendiente w_cm760_oc_pendiente

forward prototypes
public function integer of_get_parametros (ref string as_doc_oc)
end prototypes

public function integer of_get_parametros (ref string as_doc_oc);Long		ll_rc = 0



  SELECT "LOGPARAM"."DOC_OC"
    INTO :as_doc_oc
    FROM "LOGPARAM"  
   WHERE "LOGPARAM"."RECKEY" = '1' ;

	
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -1
END IF


RETURN ll_rc

end function

on w_cm760_oc_pendiente.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.uo_fechas=create uo_fechas
this.cbx_proveedores=create cbx_proveedores
this.sle_proveedor=create sle_proveedor
this.cb_busqueda=create cb_busqueda
this.st_proveedor=create st_proveedor
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.cbx_proveedores
this.Control[iCurrent+4]=this.sle_proveedor
this.Control[iCurrent+5]=this.cb_busqueda
this.Control[iCurrent+6]=this.st_proveedor
end on

on w_cm760_oc_pendiente.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_fechas)
destroy(this.cbx_proveedores)
destroy(this.sle_proveedor)
destroy(this.cb_busqueda)
destroy(this.st_proveedor)
end on

event ue_retrieve;call super::ue_retrieve;Long		ls_rc
String	ls_doc_oc, ls_proveedor
date		ld_fecha1, ld_Fecha2

ld_fecha1 = uo_fechas.of_get_fecha1()
ld_fecha2 = uo_fechas.of_get_fecha2()

if cbx_proveedores.checked then
	ls_proveedor = '%%'
else
	if trim(sle_proveedor.text) = "" then
		MessageBox('Error', 'Debe ingresar algun codigo de proveedor, por favor verifique!', StopSign!)
		sle_proveedor.setfocus()
		return 
	end if
	ls_proveedor = trim(sle_proveedor.text) + '%'
end if


idw_1.Retrieve(ld_fecha1, ld_fecha2, ls_proveedor)

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = this.ClassName()
idw_1.object.t_subtitulo.text = 'Desde: ' + String(ld_fecha1, 'dd/mm/yyyy') + '- Hasta:  ' + String(ld_fecha2, 'dd/mm/yyyy')
end event

event ue_open_pre;call super::ue_open_pre;dw_report.Object.Datawindow.Print.Orientation = 1
end event

type dw_report from w_report_smpl`dw_report within w_cm760_oc_pendiente
integer x = 0
integer y = 256
integer width = 3191
string dataobject = "d_oc_pendientes_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

String		ls_tipo_doc
STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cant_pendiente" 
		lstr_1.DataObject = 'd_articulo_mov_tbl'
		lstr_1.Width = 1700
		lstr_1.Height= 1000
		lstr_1.Arg[1] = GetItemString(row,'cod_origen')
		lstr_1.Arg[2] = String(GetItemNumber(row,'nro_mov'))
		lstr_1.Title = 'Movimientos Relacionados'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
	CASE "nro_doc"
		ls_tipo_doc = TRIM(GetItemString(row,'tipo_doc'))	
		CHOOSE CASE ls_tipo_doc
			CASE 'OT'
				lstr_1.DataObject = 'd_orden_trabajo_oper_sec_ff'
				lstr_1.Width = 2000
				lstr_1.Height= 1800
				lstr_1.Arg[1] = GetItemString(row,'nro_doc')
				lstr_1.Arg[2] = GetItemString(row,'oper_sec')
				lstr_1.Title = 'Orden de Trabajo'
			CASE 'SC'
				lstr_1.DataObject = 'd_sol_compra_ff'
				lstr_1.Width = 2300
				lstr_1.Height= 1200
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Solicitud de Compra'
			CASE 'SL'
				lstr_1.DataObject = 'd_solicitud_salida_ff'
				lstr_1.Width = 2100
				lstr_1.Height= 800
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Solicitud de Salida'
			CASE 'OC'
				lstr_1.DataObject = 'd_orden_compra_ff'
				lstr_1.Width = 2400
				lstr_1.Height= 1300
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Orden de Compra'
			CASE 'OV'
				lstr_1.DataObject = 'd_orden_venta_ff'
				lstr_1.Width = 2300
				lstr_1.Height= 1500
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Orden de Venta'
		END CHOOSE
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
END CHOOSE

end event

type cb_1 from commandbutton within w_cm760_oc_pendiente
integer x = 2437
integer y = 28
integer width = 448
integer height = 164
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;PARENT.Event ue_retrieve()
end event

type uo_fechas from u_ingreso_rango_fechas within w_cm760_oc_pendiente
event destroy ( )
integer x = 9
integer y = 8
integer taborder = 50
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(RelativeDate(Today(),-90), Today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

type cbx_proveedores from checkbox within w_cm760_oc_pendiente
integer x = 18
integer y = 144
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

type sle_proveedor from singlelineedit within w_cm760_oc_pendiente
integer x = 645
integer y = 132
integer width = 347
integer height = 100
integer taborder = 70
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

type cb_busqueda from commandbutton within w_cm760_oc_pendiente
integer x = 1001
integer y = 132
integer width = 78
integer height = 100
integer taborder = 80
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

type st_proveedor from statictext within w_cm760_oc_pendiente
integer x = 1088
integer y = 132
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

