$PBExportHeader$w_fi702_cntas_pagar.srw
forward
global type w_fi702_cntas_pagar from w_report_smpl
end type
end forward

global type w_fi702_cntas_pagar from w_report_smpl
integer height = 1120
string title = "[FI702] Listado de Cntas x Pagar"
string menuname = "m_impresion"
end type
global w_fi702_cntas_pagar w_fi702_cntas_pagar

event ue_open_pre;call super::ue_open_pre;idw_1.Retrieve()
idw_1.Visible = true

ib_preview = true
event ue_preview()
end event

on w_fi702_cntas_pagar.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_fi702_cntas_pagar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_report from w_report_smpl`dw_report within w_fi702_cntas_pagar
string dataobject = "d_rpt_lista_cntas_pagar_tbl"
end type

event dw_report::buttonclicked;call super::buttonclicked;String ls_cod_relacion, ls_tipo_doc, ls_nro_doc, ls_flag_estado

if row <= 0 then return
if lower(dwo.name) = "b_cerrar" then
	ls_cod_relacion = this.object.cod_relacion 	[row]
	ls_tipo_doc 	 = this.object.tipo_doc			[row]
	ls_nro_doc		 = this.object.nro_doc			[row]
	ls_flag_estado  = this.object.flag_estado		[row]
	
	if MessageBox('Aviso', "Desea cerrar definitivamete el documento " + ls_tipo_doc + "-" + ls_nro_doc + "?", Information!, YesNo!, 1) = 2 then return
	
	update cntas_pagar cp
	   set cp.flag_estado = '4',
			 cp.saldo_sol	 = 0.00,
			 cp.saldo_dol	 = 0.00
	where cod_relacion = :ls_cod_relacion
	  and tipo_doc		 = :ls_tipo_doc
	  and nro_doc		 = :ls_nro_doc;
	
	if gnvo_app.of_Existserror( SQLCA, 'UPDATE CNTAS_PAGAR' ) then
		rollback;
		RETURN
	end if
	
	delete doc_pendientes_cta_cte
	where cod_relacion = :ls_cod_relacion
	  and tipo_doc		 = :ls_tipo_doc
	  and nro_doc		 = :ls_nro_doc;
	
	if gnvo_app.of_Existserror( SQLCA, 'DELETE doc_pendientes_cta_cte' ) then
		rollback;
		RETURN
	end if
	
	insert into log_diario(
		fecha, tabla, operacion, llave, campo, val_anterior, val_nuevo, cod_usr)
	values(
		sysdate, 'CNTAS_PAGAR', 'Modif', :ls_cod_relacion || ',' || :ls_tipo_doc || ',' || :ls_nro_doc, 'flag_anterior', :ls_flag_estado, '4', :gs_user);
	
	if gnvo_app.of_Existserror( SQLCA, 'IMSERT log_diario' ) then
		rollback;
		RETURN
	end if

	COMMIT;
	this.Retrieve()
	f_mensaje("Documento " + ls_tipo_doc + ": " + ls_nro_doc + " se ha cerrado exitosamente.", "")
		
	  
end if
end event

