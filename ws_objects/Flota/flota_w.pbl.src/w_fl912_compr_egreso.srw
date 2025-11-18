$PBExportHeader$w_fl912_compr_egreso.srw
forward
global type w_fl912_compr_egreso from w_abc_mastdet_smpl
end type
type cb_1 from commandbutton within w_fl912_compr_egreso
end type
end forward

global type w_fl912_compr_egreso from w_abc_mastdet_smpl
integer width = 1929
integer height = 1796
string title = "Generar Comprobante de Egreso (FL912)"
string menuname = "m_edit_save_exit"
cb_1 cb_1
end type
global w_fl912_compr_egreso w_fl912_compr_egreso

on w_fl912_compr_egreso.create
int iCurrent
call super::create
if this.MenuName = "m_edit_save_exit" then this.MenuID = create m_edit_save_exit
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_fl912_compr_egreso.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
end event

event ue_update_pre;call super::ue_update_pre;//Verificación de Data en Cabecera de Documento
ib_update_check = true

IF f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False	
	return
END IF

IF f_row_Processing( dw_detail, "tabular") <> true then	
	ib_update_check = False	
	return
END IF
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_fl912_compr_egreso
integer y = 180
integer width = 1842
integer height = 816
string dataobject = "d_comprob_egreso_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_fl912_compr_egreso
integer x = 5
integer y = 1004
integer width = 1842
integer height = 584
string dataobject = "d_compr_egreso_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_rk[1] = 1

end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

type cb_1 from commandbutton within w_fl912_compr_egreso
integer x = 192
integer y = 36
integer width = 923
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar Comprobante de Egreso"
end type

event clicked;String ls_mensaje
if dw_master.ii_update = 1 or dw_detail.ii_update = 1 then
	MessageBox('Aviso', 'Tiene cambios pendientes, grabe primero')
	return
end if

if MessageBox('Aviso', 'Desea generar los comprobantes de ' &
	+ 'Egreso correspodientes?', Information!, YesNo!, 2) = 2 then return
	
SetPointer(HourGlass!)
//create or replace procedure USP_FL_GENERAR_CE(
//       asi_origen in origen.cod_origen%TYPE
//) is

DECLARE USP_FL_GENERAR_CE PROCEDURE FOR
	USP_FL_GENERAR_CE( :gs_origen );

EXECUTE USP_FL_GENERAR_CE;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_GENERAR_CE: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_FL_GENERAR_CE;

MessageBox('Aviso', 'Proceso realizado satisfactoriamente')

dw_master.Retrieve()

SetPointer(Arrow!)	
end event

