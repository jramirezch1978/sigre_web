$PBExportHeader$w_sig732_otr_pendiente.srw
forward
global type w_sig732_otr_pendiente from w_report_smpl
end type
end forward

global type w_sig732_otr_pendiente from w_report_smpl
integer width = 1454
integer height = 1232
string title = "Ordenes de Traslado Pendientes (SIG732)"
string menuname = "m_rpt_simple"
long backcolor = 67108864
end type
global w_sig732_otr_pendiente w_sig732_otr_pendiente

forward prototypes
public function integer of_get_parametros (ref string as_doc_tipo)
end prototypes

public function integer of_get_parametros (ref string as_doc_tipo);Long		ll_rc = 0

SELECT DOC_OTR
  INTO :as_doc_tipo
  FROM LOGPARAM
 WHERE RECKEY = '1' ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -2
END IF

IF IsNull(as_doc_tipo) THEN
	MessageBox('Error', 'No ha registrado el Doc OTR en PARAM')
	lL_rc = -3
END IF

RETURN ll_rc

end function

on w_sig732_otr_pendiente.create
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
end on

on w_sig732_otr_pendiente.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;Long		ll_rc
String	ls_doc_tipo

ll_rc = of_get_parametros(ls_doc_tipo)

IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')



IF ll_rc = 0 THEN
	idw_1.Retrieve(ls_doc_tipo)
	idw_1.object.t_titulo.text = 'Ordenes de Traslado Pendientes'
	idw_1.object.p_logo.filename = gs_logo
	idw_1.object.t_nombre.text = gs_empresa
	idw_1.object.t_user.text = gs_user
END IF

end event

event ue_open_pre;call super::ue_open_pre;THIS.Event ue_retrieve()

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user

THIS.Event ue_preview()
end event

type dw_report from w_report_smpl`dw_report within w_sig732_otr_pendiente
integer x = 14
integer y = 20
string dataobject = "d_otr_pendiente_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "sldo_total" 
		lstr_1.DataObject = 'd_articulo_saldos_almacen_tbl'
		lstr_1.Width = 2500
		lstr_1.Height= 1300
		lstr_1.Arg[1] = GetItemString(row,'cod_art')
		lstr_1.Title = 'Saldos por Almacen'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)
//	CASE "sldo_pendiente" 
//		lstr_1.DataObject = 'd_articulo_mov_proy_ov_pendiente'
//		lstr_1.Width = 3000
//		lstr_1.Height= 1300
//		lstr_1.Arg[1] = GetItemString(row,'cod_art')
//		lstr_1.Title = 'Solicitudes Pendientes'
//		lstr_1.Tipo_Cascada = 'R'
//		of_new_sheet(lstr_1)	
END CHOOSE

end event

