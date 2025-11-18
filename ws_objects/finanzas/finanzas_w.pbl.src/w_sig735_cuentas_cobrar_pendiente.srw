$PBExportHeader$w_sig735_cuentas_cobrar_pendiente.srw
forward
global type w_sig735_cuentas_cobrar_pendiente from w_report_smpl
end type
end forward

global type w_sig735_cuentas_cobrar_pendiente from w_report_smpl
integer width = 3131
integer height = 2536
string title = "[SIG735] Cuentas por Cobrar Pendientes"
string menuname = "m_impresion"
end type
global w_sig735_cuentas_cobrar_pendiente w_sig735_cuentas_cobrar_pendiente

type variables
String	is_soles, is_dolares
end variables

forward prototypes
public function integer of_get_parametros (ref string as_soles, ref string as_dolares)
end prototypes

public function integer of_get_parametros (ref string as_soles, ref string as_dolares);Long		ll_rc = 0



SELECT COD_SOLES, COD_DOLARES
  INTO :as_soles, :as_dolares
  FROM LOGPARAM
 WHERE RECKEY = '1' ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -2
END IF

RETURN ll_rc

end function

on w_sig735_cuentas_cobrar_pendiente.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_sig735_cuentas_cobrar_pendiente.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;Long	ll_rc


ll_rc = idw_1.Retrieve()
idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
THIS.Event ue_preview()
idw_1.Visible = True
end event

type dw_report from w_report_smpl`dw_report within w_sig735_cuentas_cobrar_pendiente
integer width = 2551
integer height = 2108
string dataobject = "d_cuenta_cobrar_pendiente"
end type

event dw_report::doubleclicked;call super::doubleclicked;//IF row = 0 THEN RETURN
//
//STR_CNS_POP lstr_1
//
//CHOOSE CASE dwo.Name
//	CASE "cod_relacion" 
//		lstr_1.DataObject = 'd_cuenta_cobrar_pendiente_cod_rel'
//		lstr_1.Width = 2230
//		lstr_1.Height= 1300
//		lstr_1.Arg[1] = GetItemString(row,'cod_relacion')
//		lstr_1.Title = 'Saldos por Almacen'
//		lstr_1.Tipo_Cascada = 'R'
//		of_new_sheet(lstr_1)
//END CHOOSE
end event

