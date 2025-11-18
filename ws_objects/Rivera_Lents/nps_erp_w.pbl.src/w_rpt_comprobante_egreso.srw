$PBExportHeader$w_rpt_comprobante_egreso.srw
forward
global type w_rpt_comprobante_egreso from w_rpt
end type
type dw_report from u_dw_rpt within w_rpt_comprobante_egreso
end type
end forward

global type w_rpt_comprobante_egreso from w_rpt
integer width = 3433
integer height = 1936
string title = "Impresion de Comprobante de Egreso"
string menuname = "m_impresion"
dw_report dw_report
end type
global w_rpt_comprobante_egreso w_rpt_comprobante_egreso

type variables
Str_cns_pop istr_1

String		is_ruc_emp
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

on w_rpt_comprobante_egreso.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_rpt_comprobante_egreso.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width  = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;of_position_window(0,0)
idw_1 = dw_report
//idw_1.SetTransObject(sqlca)

istr_1 = Message.PowerObjectParm			// lectura de parametros

of_position_window(0,0)

THIS.Event ue_preview()
This.Event ue_retrieve()


//ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;//istr_1.arg[1],istr_1.arg[2],gnvo_app.invo_empresa.is_empresa,gs_user,istr_1.arg[3]

// Verifica el tipo de doc  cml

IF istr_1.arg[2] = istr_1.arg[5] THEN
	// Llamar a la función para llenar el Ruc de la empresa
	IF of_ruc_empresa () = 0 THEN
		messagebox('Aviso', 'Verificar RUC de Empresa')
		RETURN
	END IF

	idw_1.dataobject = 'dw_rpt_planilla_gastos_movilidad_tbl'
	idw_1.SetTransObject( SQLCA)
	idw_1.Retrieve(istr_1.arg[1],istr_1.arg[2],istr_1.arg[3])
	idw_1.object.monto_t.text			= istr_1.arg[6]
	idw_1.object.ruc_t.text				= is_ruc_emp
	idw_1.object.p_logo.filename 		= gnvo_app.is_logo
	
ELSE
	idw_1.dataobject = 'd_rpt_comprobante_egreso_tbl'
	idw_1.SetTransObject( SQLCA)
	idw_1.Retrieve(istr_1.arg[1],istr_1.arg[2],istr_1.arg[3],istr_1.arg[4],gnvo_app.invo_empresa.is_empresa)
END IF

ib_preview = False
This.Event ue_preview()

end event

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

type dw_report from u_dw_rpt within w_rpt_comprobante_egreso
integer x = 5
integer width = 3218
integer height = 1624
string dataobject = "d_rpt_comprobante_egreso_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

