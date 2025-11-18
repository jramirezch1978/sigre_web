$PBExportHeader$w_sig730_ov_pendiente.srw
forward
global type w_sig730_ov_pendiente from w_report_smpl
end type
end forward

global type w_sig730_ov_pendiente from w_report_smpl
integer width = 1454
integer height = 1232
string title = "Ordenes de Venta Pendientes (SIG730)"
string menuname = "m_rpt_simple"
long backcolor = 67108864
end type
global w_sig730_ov_pendiente w_sig730_ov_pendiente

type variables
String	is_doc_ov
end variables

forward prototypes
public function integer of_get_parametros (ref string as_doc_tipo)
end prototypes

public function integer of_get_parametros (ref string as_doc_tipo);Long		ll_rc = 0



SELECT DOC_OV
  INTO :as_doc_tipo
  FROM LOGPARAM
 WHERE RECKEY = '1' ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -2
END IF

RETURN ll_rc

end function

on w_sig730_ov_pendiente.create
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
end on

on w_sig730_ov_pendiente.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;Long		ll_rc




IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')



IF ll_rc = 0 THEN
	idw_1.Retrieve(is_doc_ov)
	idw_1.object.t_titulo.text = 'Ordenes de Venta Pendientes'
	idw_1.object.p_logo.filename = gs_logo
	idw_1.object.t_nombre.text = gs_empresa
	idw_1.object.t_user.text = gs_user
END IF

end event

event ue_open_pre;call super::ue_open_pre;Long 	ll_rc

ll_rc = of_get_parametros(is_doc_ov)

THIS.Event ue_retrieve()

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user

THIS.Event ue_preview()
end event

type dw_report from w_report_smpl`dw_report within w_sig730_ov_pendiente
integer x = 14
integer y = 20
string dataobject = "d_ov_pendiente"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cant_entregada" 
		lstr_1.DataObject = 'd_ov_guia_det_tbl'
		lstr_1.Width = 3500
		lstr_1.Height= 800
		lstr_1.Arg[1] = is_doc_ov
		lstr_1.Arg[2] = GetItemString(row,'nro_ov')
		lstr_1.Arg[3] = GetItemString(row,'cod_art')
		lstr_1.Title = 'Entregas por OV'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
	CASE "cant_facturada" 
		lstr_1.DataObject = 'd_ov_factura_det_tbl'
		lstr_1.Width = 3200
		lstr_1.Height= 800
		lstr_1.Arg[1] = is_doc_ov
		lstr_1.Arg[2] = GetItemString(row,'nro_ov')
		lstr_1.Arg[3] = GetItemString(row,'cod_art')
		lstr_1.Title = 'Facturas por OV'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)	
END CHOOSE

end event

