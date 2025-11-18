$PBExportHeader$w_cm795_lista_prog_compras.srw
forward
global type w_cm795_lista_prog_compras from w_report_smpl
end type
type cb_1 from commandbutton within w_cm795_lista_prog_compras
end type
type uo_fechas from u_ingreso_rango_fechas within w_cm795_lista_prog_compras
end type
end forward

global type w_cm795_lista_prog_compras from w_report_smpl
integer width = 3415
integer height = 2276
string title = "[CM795] Listado de Programas de compras"
string menuname = "m_impresion"
cb_1 cb_1
uo_fechas uo_fechas
end type
global w_cm795_lista_prog_compras w_cm795_lista_prog_compras

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

on w_cm795_lista_prog_compras.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.uo_fechas=create uo_fechas
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_fechas
end on

on w_cm795_lista_prog_compras.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_fechas)
end on

event ue_retrieve;call super::ue_retrieve;Long		ls_rc
date		ld_fecha1, ld_Fecha2

ld_fecha1 = uo_fechas.of_get_fecha1()
ld_fecha2 = uo_fechas.of_get_fecha2()

idw_1.Retrieve(ld_fecha1, ld_fecha2)

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = this.ClassName()
idw_1.object.t_subtitulo.text = 'Desde: ' + String(ld_fecha1, 'dd/mm/yyyy') + ' - Hasta:  ' + String(ld_fecha2, 'dd/mm/yyyy')
end event

event ue_open_pre;call super::ue_open_pre;dw_report.Object.Datawindow.Print.Orientation = 1
end event

type dw_report from w_report_smpl`dw_report within w_cm795_lista_prog_compras
integer x = 0
integer y = 200
integer width = 3255
integer height = 1620
string dataobject = "d_rpt_listado_prog_compras_tbl"
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

type cb_1 from commandbutton within w_cm795_lista_prog_compras
integer x = 1957
integer y = 8
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

type uo_fechas from u_ingreso_rango_fechas within w_cm795_lista_prog_compras
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

