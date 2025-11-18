$PBExportHeader$w_cn050_anexo_concepto.srw
forward
global type w_cn050_anexo_concepto from w_abc_master_smpl
end type
end forward

global type w_cn050_anexo_concepto from w_abc_master_smpl
integer width = 2853
integer height = 1552
string title = "Anexos contables x cuenta (CN050)"
string menuname = "m_master_smpl"
end type
global w_cn050_anexo_concepto w_cn050_anexo_concepto

on w_cn050_anexo_concepto.create
call super::create
if this.MenuName = "m_master_smpl" then this.MenuID = create m_master_smpl
end on

on w_cn050_anexo_concepto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify; 
IF dw_master.ii_protect = 0 THEN
   dw_master.of_column_protect("cnta_ctbl")
	dw_master.of_column_protect("concepto_cnt")
END IF

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cn050_anexo_concepto
integer x = 37
integer y = 32
integer width = 2711
integer height = 1284
string dataobject = "d_abc_cnt_concepto_grd"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::doubleclicked;call super::doubleclicked;String ls_name, ls_prot 
Datawindow ldw
ldw = This
if dwo.type<>'column' THEN RETURN 1

// Ventanas de ayuda
IF Getrow() = 0 THEN Return

String ls_inactivo

str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if
ls_inactivo = '0'

CHOOSE CASE dwo.name
	 CASE 'cnta_ctbl'
		
			lstr_seleccionar.s_seleccion = 'S'
			lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
													 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
													 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
													 +'FROM CNTBL_CNTA ' &
													 +'WHERE CNTBL_CNTA.FLAG_PERMITE_MOV = 1 AND FLAG_ESTADO <> 0 '
									  
			OpenWithParm(w_seleccionar,lstr_seleccionar)
			
			IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			IF lstr_seleccionar.s_action = "aceptar" THEN
				Setitem(row,'cnta_ctbl',lstr_seleccionar.param1[1])
				Setitem(row,'cntbl_cnta_desc_cnta',lstr_seleccionar.param1[2])
				ii_update = 1
			END IF
END CHOOSE

end event

event dw_master::itemchanged;call super::itemchanged;String ls_cuenta, ls_null, ls_descrip
Long ll_count 

this.accepttext()

isnull(ls_null)

CHOOSE CASE dwo.name
   CASE 'cnta_ctbl'	
	  ls_cuenta = DATA

	  select count(*) into :ll_count from cntbl_cnta 
	  where cnta_ctbl = :ls_cuenta and flag_estado='1' and flag_permite_mov='1' ;

	  IF ll_count=0 then
		  messagebox('Aviso', 'Cuenta contable no existe')
  		  Setnull(ls_cuenta)
		  This.object.cnta_ctbl[row] = ls_cuenta
		  return 1
	  end if

	  select desc_cnta into :ls_descrip from cntbl_cnta 
	  where cnta_ctbl = :ls_cuenta and flag_estado='1' and flag_permite_mov='1' ;
	  
	  This.object.cntbl_cnta_desc_cnta[row] = ls_descrip
	  
END CHOOSE	

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado[al_row]='1'
end event

