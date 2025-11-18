$PBExportHeader$w_sr009_documentos_tipo.srw
forward
global type w_sr009_documentos_tipo from w_abc_master_smpl
end type
end forward

global type w_sr009_documentos_tipo from w_abc_master_smpl
integer width = 3803
integer height = 1916
string title = "[SR009] Tipo de Documentos"
string menuname = "m_mtto_smpl"
end type
global w_sr009_documentos_tipo w_sr009_documentos_tipo

on w_sr009_documentos_tipo.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_sr009_documentos_tipo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.tipo_doc.Protect)

IF li_protect = 0 THEN
   dw_master.Object.tipo_doc.Protect = 1
END IF
end event

event ue_open_pre;call super::ue_open_pre;//f_centrar( this )
ii_pregunta_delete = 1 
idw_1.Retrieve()

end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if


dw_master.of_set_flag_replicacion ()
end event

type ole_skin from w_abc_master_smpl`ole_skin within w_sr009_documentos_tipo
end type

type st_filter from w_abc_master_smpl`st_filter within w_sr009_documentos_tipo
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_sr009_documentos_tipo
end type

type st_box from w_abc_master_smpl`st_box within w_sr009_documentos_tipo
end type

type uo_h from w_abc_master_smpl`uo_h within w_sr009_documentos_tipo
end type

type dw_master from w_abc_master_smpl`dw_master within w_sr009_documentos_tipo
event ue_display ( string as_columna,  long al_row )
integer x = 517
integer y = 284
integer width = 3630
integer height = 1224
string dataobject = "d_abc_doc_tipo_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "tipo_cred_fiscal"
		
		ls_sql = "SELECT TIPO_CRED_FISCAL  AS CODIGO ," &
    			 + "DESCRIPCION AS DESCRIPCION " &
				 + "FROM CREDITO_FISCAL " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_cred_fiscal 		[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "nro_libro"
		
		ls_sql = "SELECT NRO_LIBRO AS LIBRO ," &
				 + "DESC_LIBRO AS DESCRIPCION " &
				 + "FROM CNTBL_LIBRO"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.setitem( al_row, lower(as_columna), ls_codigo)
			this.ii_update = 1
		end if

	case "cod_sunat"
		
		ls_sql = "SELECT cod_sunat AS cod_sunat, " &
				 + "DESC_DOC_SUNAT AS DESCRIPCION " &
				 + "FROM doc_tipo_pago_sunat " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.setitem( al_row, lower(as_columna), ls_codigo)
			this.ii_update = 1
		end if

	
end choose


//IF Getrow() = 0 THEN Return
//
//String ls_name, ls_prot 
//Str_seleccionar lstr_seleccionar
//Datawindow		 ldw	
//ls_name = dwo.name
//ls_prot = this.Describe( ls_name + ".Protect")
//
//if ls_prot = '1' then    //protegido 
//	return
//end if
//
//CHOOSE CASE dwo.name
//		
//		 CASE ''
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = ''
//				
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'tipo_cred_fiscal',lstr_seleccionar.param1[1])
//					ii_update = 1
//				END IF
//				
//		 CASE ''
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = ' '
//				
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'nro_libro',lstr_seleccionar.param1[1])
//					ii_update = 1
//				END IF
//		
//		
//							
//END CHOOSE


end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;//dw_master.Modify("forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
//dw_master.Modify("desc_forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")

this.object.flag_afecta_prsp [al_row] = '1'
this.object.nivel_auto_req	  [al_row] = '0'	
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::itemchanged;call super::itemchanged;IF Getrow() = 0 THEN Return

String ls_name, ls_prot, ls_codigo
Long ll_count

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		
	 CASE 'tipo_cred_fiscal'
			SELECT count(*)
			INTO :ll_count
			FROM CREDITO_FISCAL
			WHERE tipo_cred_fiscal = :data ;

			IF ll_count=0 THEN
				Messagebox('Aviso','Tipo de crédito fiscal no existe')
				setnull(ls_codigo)
				this.object.tipo_cred_fiscal[row] = ls_codigo
				return
			END IF
			ii_update = 1
			
	 CASE 'nro_libro'
			SELECT count(*)
			INTO :ll_count
			FROM CNTBL_LIBRO
			WHERE nro_libro = :data ;

			IF ll_count=0 THEN
				Messagebox('Aviso','Nro de libro contable no existe')
				setnull(ls_codigo)
				this.object.nro_libro[row] = ls_codigo
				return
			END IF
			ii_update = 1
END CHOOSE

end event

